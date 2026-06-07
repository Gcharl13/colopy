"""
emit_c_chunks.py -- generate citation-backed .c files from a classification JSON.

Usage:
  python emit_c_chunks.py <funcs.json> <classification.json> <disasm_dir> <out_dir> <region>

Emits load_image_*.c or overlay_*.c chunks in <out_dir>, each containing 30
functions with full citation blocks + auto-traced control-flow bodies.

Skips functions that already exist in any sibling .c file under the source
tree (those are hand-written modules like colony/, unit/, etc.).
"""

import json
import os
import re
import sys
from collections import defaultdict

PROJECT = str(__import__("pathlib").Path(__file__).resolve().parents[1])

sys.path.insert(0, os.path.join(PROJECT, "tools"))
from overlay_body_gen import (parse_asm, trace_control_flow, build_skeleton_body,
                               args_signature, funcname_for, emit_lcalls_block)


def emit_function(func, info, callers, events, globals_read, globals_written, exe_name):
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

    if pattern == 'TINY_RETURN':
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


def find_already_in_tree(out_dir, region):
    """Find functions already hand-written in sibling directories."""
    tree_root = os.path.dirname(out_dir)  # one level up
    already = set()
    if os.path.isdir(tree_root):
        for d in os.listdir(tree_root):
            full_d = os.path.join(tree_root, d)
            if not os.path.isdir(full_d) or d == region:
                continue
            for fname in os.listdir(full_d):
                if not fname.endswith('.c'): continue
                with open(os.path.join(full_d, fname), 'r', encoding='utf-8', errors='ignore') as f:
                    content = f.read()
                for m in re.finditer(r'@asm\s+0x([0-9A-Fa-f]+)\.\.', content):
                    already.add(int(m.group(1), 16))
    return already


def main(funcs_json, class_json, disasm_dir, out_dir, region, exe_name):
    with open(funcs_json) as f:
        fdata = json.load(f)
    with open(class_json) as f:
        classes = json.load(f)['functions']

    funcs = [f for f in fdata['functions'] if f['region'] == region]
    funcs = sorted(funcs, key=lambda f: int(f['file_offset'], 16))

    asm_lookup = {}
    if os.path.isdir(disasm_dir):
        for fname in os.listdir(disasm_dir):
            m = re.match(r'func_([0-9A-Fa-f]+)_', fname)
            if m:
                asm_lookup[m.group(1).upper().zfill(6)] = os.path.join(disasm_dir, fname)

    print(f"[emit] parsing {len(funcs)} {region} functions for {exe_name}...")
    parsed = {}
    for i, func in enumerate(funcs):
        if i % 100 == 0:
            print(f"  ... {i}/{len(funcs)}")
        offset_key = func['file_offset'].replace('0x', '').upper().zfill(6)
        asm_path = asm_lookup.get(offset_key)
        if not asm_path:
            asm_path = os.path.join(disasm_dir, os.path.basename(func['asm_file']))
        instrs = parse_asm(asm_path)
        if instrs is None:
            parsed[func['file_offset']] = ([], set(), set())
        else:
            events, gr, gw = trace_control_flow(instrs)
            parsed[func['file_offset']] = (events, gr, gw)

    already = find_already_in_tree(out_dir, region)
    remaining = [f for f in funcs if int(f['file_offset'], 16) not in already]
    print(f"[emit] {len(funcs)} total, {len(remaining)} not yet in source tree")

    if not remaining:
        return

    # Delete existing auto-generated files for this region
    prefix = f"{region}_"
    if os.path.isdir(out_dir):
        for fname in os.listdir(out_dir):
            if fname.startswith(prefix) and fname.endswith('.c'):
                os.remove(os.path.join(out_dir, fname))

    chunk_size = 30
    chunks = [remaining[i:i+chunk_size] for i in range(0, len(remaining), chunk_size)]
    for ci, chunk in enumerate(chunks):
        first = int(chunk[0]['file_offset'], 16)
        last = int(chunk[-1]['file_offset'], 16) + chunk[-1]['size']
        out_name = f"{region}_{first:06X}_{last:06X}.c"
        out_path = os.path.join(out_dir, out_name)
        with open(out_path, 'w', encoding='utf-8') as f:
            f.write(f"""/* ============================================================================
 * {out_name} -- {region} functions in file range 0x{first:06X}..0x{last:06X}
 * Auto-generated by tools/emit_c_chunks.py for {exe_name}.
 *
 * {len(chunk)} functions in this file. Each carries a citation block plus
 * an auto-traced control-flow body documenting every CALL/LCALL/branch.
 * Functions marked SKELETON have body content derived from control-flow
 * but their semantics still need hand-port.
 * ============================================================================ */
#include "viceroy.h"
#include "overlay_externs.h"

""")
            for func in chunk:
                info = classes.get(func['file_offset'], {})
                events, gr, gw = parsed[func['file_offset']]
                f.write(emit_function(func, info, 0, events, gr, gw, exe_name))
                f.write("\n")
    print(f"[emit] wrote {len(chunks)} files to {out_dir}")


if __name__ == '__main__':
    if len(sys.argv) < 7:
        print(__doc__)
        sys.exit(1)
    main(sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4], sys.argv[5], sys.argv[6])
