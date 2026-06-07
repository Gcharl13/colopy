"""
full_pipeline.py -- run the complete classifier+body_gen+role_tagger pipeline
on EVERY function (both load_image and overlay) for a given EXE.

Usage:
  python full_pipeline.py VICEROY      # processes VICEROY.EXE -> viceroy_source/
  python full_pipeline.py MAPEDIT      # processes MAPEDIT.EXE -> mapedit_source/

For each EXE this:
  1. Loads code/<EXE>/functions.json (already produced by disasm_mz.py)
  2. Builds an asm-file-by-offset lookup dict (handles renames)
  3. Classifies every function
  4. For overlay region -> emits to <exe>_source/src/overlay/overlay_*.c
     For load_image region -> emits to <exe>_source/src/load_image/load_image_*.c
  5. Generates control-flow-traced bodies via overlay_body_gen logic
  6. Tags with @inferred_role
  7. Bulk-renames by role
"""

import json
import os
import re
import sys
from collections import defaultdict, Counter

PROJECT = r"c:\Users\gregc\OneDrive\Desktop\COLOPY\reverse_engineered"


# Reuse logic from existing tools.
sys.path.insert(0, os.path.join(PROJECT, "tools"))
from overlay_classifier import classify
from overlay_body_gen import parse_asm, trace_control_flow, build_skeleton_body, args_signature, funcname_for, emit_lcalls_block, invert_cond


def build_asm_lookup(disasm_dir):
    """Build {offset: asm_path} dict that survives renames."""
    out = {}
    for fname in os.listdir(disasm_dir):
        m = re.match(r'func_([0-9A-Fa-f]+)_', fname)
        if m:
            out[m.group(1).upper().zfill(6)] = os.path.join(disasm_dir, fname)
    return out


def emit_function(func, info, callers, events, globals_read, globals_written):
    """Emit one function's citation block + body."""
    file_offset = func['file_offset']
    fo_int = int(file_offset, 16)
    size = func['size']
    pattern = info['pattern']
    fname = funcname_for(func['asm_file'])

    ret_type, args = args_signature(info.get('args', []))
    arg_str = "void" if not args else ", ".join(args)

    lcalls_block = emit_lcalls_block(events)

    citation = f"""/* @asm        0x{fo_int:06X}..0x{fo_int+size:06X}  ({size} bytes)  region={func['region']}
 * @asm_file   ../code/{exe_name}/disasm/{os.path.basename(func['asm_file'])}
 * @pattern    {pattern}
 * @prologue   {info.get('prologue', '?')}
 * @args_seen  {info.get('args', [])}
 * @lcalls     {sum(1 for e in events if e[0] == 'lcall')}
 * @near_calls {sum(1 for e in events if e[0] == 'call')}
 * @callers    {callers}
 * @touches_8542 {info.get('touches_8542', False)}{lcalls_block}
 * @status     SKELETON (auto-traced control flow; semantics TBD)
 */"""

    if pattern in ('TINY_RETURN',):
        body = '    /* @auto: tiny return-only function. */\n    return 0;'
    elif pattern == 'TINY_ACCESSOR':
        if globals_read:
            g = sorted(globals_read)[0]
            body = f'    /* @auto: tiny accessor reads DGROUP:0x{g:04X}. */\n    return *((uint16_t near*)0x{g:04X});'
        else:
            body = '    /* @auto: tiny accessor; field not auto-identified. */\n    return 0;  /* TODO */'
    elif pattern == 'WRAPPER_LCALL':
        lcalls = [(e[2], e[3]) for e in events if e[0] == 'lcall']
        if lcalls:
            seg, off = lcalls[0]
            body = f'    /* @auto: wrapper forwards to LCALL 0x{seg:04X}:0x{off:04X}. */\n    return overlay_call_{seg:04X}_{off:04X}();'
        else:
            body = '    /* @auto: WRAPPER_LCALL, target not parsed. */\n    return 0;'
    elif pattern == 'WRAPPER_NEARCALL':
        near = [e[2] for e in events if e[0] == 'call']
        if near:
            tgt = near[0]
            body = f'    /* @auto: wrapper forwards to near CALL 0x{tgt:06X}. */\n    return func_{tgt:06X}();'
        else:
            body = '    /* @auto: WRAPPER_NEARCALL, target not parsed. */\n    return 0;'
    else:
        body = build_skeleton_body(events, globals_read, globals_written, info, size)

    return f"""{citation}
int {fname}({arg_str})
{{
{body}
}}
"""


# Module-level for closure
exe_name = ""


def process_exe(exe_name_arg):
    """Run the full pipeline for one EXE."""
    global exe_name
    exe_name = exe_name_arg
    code_dir = os.path.join(PROJECT, "code", exe_name)
    disasm_dir = os.path.join(code_dir, "disasm")
    funcs_json = os.path.join(code_dir, "functions.json")

    if exe_name == "VICEROY":
        out_dir = os.path.join(PROJECT, "viceroy_source")
    else:
        out_dir = os.path.join(PROJECT, exe_name.lower() + "_source")

    src_dir = os.path.join(out_dir, "src")
    include_dir = os.path.join(out_dir, "include")
    os.makedirs(src_dir, exist_ok=True)
    os.makedirs(include_dir, exist_ok=True)

    print(f"\n=== Processing {exe_name} -> {out_dir} ===")

    with open(funcs_json) as f:
        fdata = json.load(f)
    funcs = fdata['functions']

    asm_lookup = build_asm_lookup(disasm_dir)

    # Classify every function
    print(f"[pipeline] classifying {len(funcs)} functions...")
    classes = {}
    parsed = {}
    for i, func in enumerate(funcs):
        if i % 100 == 0:
            print(f"  ... {i}/{len(funcs)}")
        offset_key = func['file_offset'].replace('0x', '').upper().zfill(6)
        asm_path = asm_lookup.get(offset_key)
        if not asm_path:
            asm_path = os.path.join(disasm_dir, os.path.basename(func['asm_file']))
        info = classify(func, asm_path)
        classes[func['file_offset']] = info

        # Also parse for control-flow trace
        instrs = parse_asm(asm_path)
        if instrs is None:
            parsed[func['file_offset']] = ([], set(), set())
        else:
            events, gr, gw = trace_control_flow(instrs)
            parsed[func['file_offset']] = (events, gr, gw)

    # Group by region
    by_region = defaultdict(list)
    for func in funcs:
        by_region[func['region']].append(func)

    # All distinct LCALL targets (for overlay_externs.h)
    all_lcalls = set()
    for fo, (events, _, _) in parsed.items():
        for e in events:
            if e[0] == 'lcall':
                all_lcalls.add((e[2], e[3]))

    print(f"[pipeline] {len(all_lcalls)} distinct overlay LCALL targets")
    externs_h = os.path.join(include_dir, "overlay_externs.h")
    with open(externs_h, 'w', encoding='utf-8') as f:
        f.write(f"""/* ============================================================================
 * overlay_externs.h -- declarations for every LCALL target (auto-generated)
 * Auto-generated by tools/full_pipeline.py for {exe_name}.
 * ============================================================================ */
#ifndef {exe_name.upper()}_OVERLAY_EXTERNS_H
#define {exe_name.upper()}_OVERLAY_EXTERNS_H
#include "viceroy_types.h"

""")
        for seg, off in sorted(all_lcalls):
            f.write(f"extern int overlay_call_{seg:04X}_{off:04X}(void);  /* @ref RTLink seg 0x{seg:04X} off 0x{off:04X} */\n")
        f.write(f"\n#endif /* {exe_name.upper()}_OVERLAY_EXTERNS_H */\n")
    print(f"[pipeline] wrote {externs_h}")

    # Per-region emission
    for region, region_funcs in by_region.items():
        sub_dir = os.path.join(src_dir, region)
        os.makedirs(sub_dir, exist_ok=True)

        sorted_funcs = sorted(region_funcs, key=lambda f: int(f['file_offset'], 16))

        # Skip functions already hand-written into other dirs (e.g. colony/, unit/, etc.)
        # Match by file_offset against existing C files.
        already_in_tree = set()
        for root_dir in (os.path.join(src_dir, d) for d in os.listdir(src_dir)
                          if os.path.isdir(os.path.join(src_dir, d)) and d != region):
            for fname in os.listdir(root_dir):
                if not fname.endswith('.c'): continue
                with open(os.path.join(root_dir, fname), 'r', encoding='utf-8', errors='ignore') as f:
                    content = f.read()
                for m in re.finditer(r'@asm\s+0x([0-9A-Fa-f]+)\.\.', content):
                    already_in_tree.add(int(m.group(1), 16))

        # Filter out functions already hand-written elsewhere
        remaining = [f for f in sorted_funcs if int(f['file_offset'], 16) not in already_in_tree]
        print(f"[pipeline] region={region}: {len(sorted_funcs)} total, {len(remaining)} not yet in source tree")

        if not remaining:
            continue

        # Chunk
        chunk_size = 30
        chunks = [remaining[i:i+chunk_size] for i in range(0, len(remaining), chunk_size)]

        # First, delete any existing auto-generated files for this region
        prefix = f"{region}_"
        for fname in os.listdir(sub_dir):
            if fname.startswith(prefix) and fname.endswith('.c'):
                os.remove(os.path.join(sub_dir, fname))

        for ci, chunk in enumerate(chunks):
            first = int(chunk[0]['file_offset'], 16)
            last = int(chunk[-1]['file_offset'], 16) + chunk[-1]['size']
            out_name = f"{region}_{first:06X}_{last:06X}.c"
            out_path = os.path.join(sub_dir, out_name)

            with open(out_path, 'w', encoding='utf-8') as f:
                f.write(f"""/* ============================================================================
 * {out_name} -- {region} functions in file range 0x{first:06X}..0x{last:06X}
 * Auto-generated by tools/full_pipeline.py for {exe_name}.
 *
 * {len(chunk)} functions in this file. Each carries a citation block plus
 * an auto-traced control-flow body.  Functions marked SKELETON have body
 * content derived from control-flow but their semantics still need hand-port.
 * ============================================================================ */
#include "viceroy.h"
#include "overlay_externs.h"

""")
                for func in chunk:
                    info = classes.get(func['file_offset'], {})
                    events, gr, gw = parsed[func['file_offset']]
                    callers = 0  # callgraph data not available in this fast pass
                    f.write(emit_function(func, info, callers, events, gr, gw))
                    f.write("\n")

        print(f"[pipeline] wrote {len(chunks)} files in {sub_dir}")

    print(f"[pipeline] DONE for {exe_name}")


if __name__ == '__main__':
    if len(sys.argv) < 2:
        print(__doc__)
        sys.exit(1)
    process_exe(sys.argv[1])
