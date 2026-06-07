"""
overlay_to_c.py -- generate citation-backed C stubs for every overlay function.

Reads:
  - code/VICEROY/functions.json       (function inventory)
  - code/VICEROY/overlay_classification.json (pattern + LCALLs/CALLs)
  - code/VICEROY/callgraph.json       (caller counts)

Emits:
  - viceroy_source/src/overlay/seg_<id>.c  (one file per detected segment)
  - viceroy_source/src/overlay/seg_unknown.c  (orphans -- no segment id)
  - viceroy_source/include/overlay_externs.h  (every overlay LCALL target)
  - viceroy_source/src/overlay/MANIFEST.md  (per-function status table)

Each emitted function has:
  - A complete @asm citation block
  - A function signature inferred from its arg slot uses
  - For TINY_ACCESSOR / WRAPPER_LCALL / WRAPPER_NEARCALL: a generated body
  - For DISPATCHER / LARGE_LOGIC / MEDIUM_LOGIC / UNKNOWN: TODO body with
    visible LCALL target list as comments
"""

import json
import os
import sys
from collections import defaultdict, Counter

PROJECT = r"c:\Users\gregc\OneDrive\Desktop\COLOPY\reverse_engineered"
FUNCTIONS_JSON = os.path.join(PROJECT, "code", "VICEROY", "functions.json")
CLASS_JSON = os.path.join(PROJECT, "code", "VICEROY", "overlay_classification.json")
CALLGRAPH_JSON = os.path.join(PROJECT, "code", "VICEROY", "callgraph.json")
THUNKS_JSON = os.path.join(PROJECT, "code", "VICEROY", "overlay_thunks.json")
OUT_DIR = os.path.join(PROJECT, "viceroy_source", "src", "overlay")
EXTERNS_H = os.path.join(PROJECT, "viceroy_source", "include", "overlay_externs.h")
MANIFEST_MD = os.path.join(OUT_DIR, "MANIFEST.md")


def load():
    with open(FUNCTIONS_JSON) as f:
        funcs_data = json.load(f)
    with open(CLASS_JSON) as f:
        classes_data = json.load(f)
    try:
        with open(CALLGRAPH_JSON) as f:
            cg = json.load(f)
    except Exception:
        cg = {}
    try:
        with open(THUNKS_JSON) as f:
            thunks_data = json.load(f)
    except Exception:
        thunks_data = {'thunks': []}
    return funcs_data, classes_data, cg, thunks_data


def caller_count_for(file_offset, callgraph):
    """Return number of distinct callers of file_offset, from callgraph."""
    if not callgraph:
        return 0
    target = file_offset.lower()
    if 'callers' in callgraph:
        # Either dict-of-callers or list
        return len(callgraph['callers'].get(target, []))
    if 'edges' in callgraph:
        return sum(1 for e in callgraph['edges'] if e.get('callee') == target)
    return 0


def thunk_segment_for(file_offset, thunks):
    """Try to infer which RTLink segment id a function belongs to,
    based on whether a thunk's ljmp_off matches a function offset within
    the same segment. Best-effort; many functions won't match."""
    return None  # stubbed; left for next-pass refinement


def args_signature(args):
    """Build a (return_type, arg_list) C signature from the arg-slot list."""
    # bp+6 is arg0, bp+8 is arg1, bp+0xA is arg2, ...
    # We don't know argument types reliably; use uint16_t as the safe default.
    if not args:
        return ('int', [])
    arg_decls = []
    for i, slot in enumerate(args):
        # Arg name: legal C identifier; encode the bp slot as a hex tail.
        arg_decls.append(f"uint16_t arg{i}_bp_{slot:02X}")
    return ('int', arg_decls)


def funcname_for(file_offset, asm_file, pattern):
    """Turn an asm_file path + pattern into a C identifier."""
    base = os.path.basename(asm_file).replace('.asm', '')
    # base is like func_021A14_unknown
    return base


def emit_lcalls_block(lcalls, near_calls):
    """Generate a comment block listing all calls in the function.
    Returns a string starting with a newline (for use after @touches_8542)."""
    lines = []
    if lcalls:
        lines.append('')        # blank-line continuation
        lines.append(' *')
        lines.append(' * LCALL targets:')
        for seg, off in lcalls:
            lines.append(f' *   - 0x{seg:04X}:0x{off:04X}')
    if near_calls:
        lines.append('')
        lines.append(' *')
        lines.append(' * Near CALL targets:')
        for tgt in near_calls:
            lines.append(f' *   - 0x{tgt:06X}')
    if not lines:
        return ''
    return '\n' + '\n'.join(lines[1:])  # skip the leading blank-line marker


def emit_function(func, info, callers):
    """Emit one citation-backed C function declaration + body."""
    file_offset = func['file_offset']
    fo_int = int(file_offset, 16)
    size = func['size']
    pattern = info['pattern']
    fname = funcname_for(file_offset, func['asm_file'], pattern)

    ret_type, args = args_signature(info['args'])

    if not args:
        arg_str = "void"
    else:
        arg_str = ", ".join(args)

    citation = f"""/* @asm        0x{fo_int:06X}..0x{fo_int+size:06X}  ({size} bytes)  region=overlay
 * @asm_file   ../code/VICEROY/disasm/{os.path.basename(func['asm_file'])}
 * @pattern    {pattern}
 * @prologue   {info.get('prologue', '?')}
 * @args_seen  {info.get('args', [])}
 * @lcalls     {len(info.get('lcalls', []))}
 * @near_calls {len(info.get('near_calls', []))}
 * @callers    {callers}
 * @touches_8542 {info.get('touches_8542', False)}{emit_lcalls_block(info.get('lcalls', []), info.get('near_calls', []))}
 * @status     STUB (auto-generated; body needs hand-port)
 */"""

    # Body generation per pattern
    body_lines = []
    if pattern == 'TINY_RETURN':
        body_lines = ['    /* @auto: tiny -- return constant or single global. */',
                      '    return 0;  /* TODO: identify constant */']
    elif pattern == 'TINY_ACCESSOR':
        body_lines = ['    /* @auto: tiny accessor -- single struct/global field load. */',
                      '    return 0;  /* TODO: identify field */']
    elif pattern == 'WRAPPER_LCALL':
        if info['lcalls']:
            seg, off = info['lcalls'][0]
            body_lines = [f'    /* @auto: wrapper forwards to LCALL 0x{seg:04X}:0x{off:04X}. */',
                          f'    extern int overlay_call_{seg:04X}_{off:04X}(void);  /* TODO: signature */',
                          f'    return overlay_call_{seg:04X}_{off:04X}();']
        else:
            body_lines = ['    /* @auto: wrapper but no LCALL identified. */', '    return 0;']
    elif pattern == 'WRAPPER_NEARCALL':
        if info['near_calls']:
            tgt = info['near_calls'][0]
            body_lines = [f'    /* @auto: wrapper forwards to near CALL 0x{tgt:06X}. */',
                          f'    extern int func_{tgt:06X}(void);  /* TODO: signature */',
                          f'    return func_{tgt:06X}();']
        else:
            body_lines = ['    /* @auto: wrapper but no near CALL identified. */', '    return 0;']
    elif pattern == 'BIT_ACCESSOR':
        body_lines = ['    /* @auto: bit-array test/set/clear. Body matches the test_bit_at_8a',
                      '     *        family in colony/accessors.c.  Pattern: shift+AND. */',
                      '    return 0;  /* TODO: identify which bit-array offset */']
    elif pattern == 'NIBBLE_ACCESSOR':
        body_lines = ['    /* @auto: packed-nibble pack/unpack. Pattern matches unpack_nibble_at_60.',
                      '     *        Use idx>>1 for byte offset, (idx&1) for high/low nibble. */',
                      '    return 0;  /* TODO: identify which nibble-array offset */']
    elif pattern == 'COUNT_LOOP':
        body_lines = ['    /* @auto: count-loop. Iterates with INC accumulator. */',
                      '    int tally = 0;',
                      '    /* TODO: identify the loop bound and predicate */',
                      '    return tally;']
    elif pattern == 'FIND_LOOP':
        body_lines = ['    /* @auto: find-loop. Linear scan with early return. */',
                      '    /* TODO: identify the loop bound and match predicate */',
                      '    return -1;']
    elif pattern == 'DISPATCHER':
        body_lines = [f'    /* @auto: dispatcher with {len(info["lcalls"])} LCALL + {len(info["near_calls"])} near CALL targets. */',
                      '    /* TODO: identify which dispatch code drives the branch */']
        for seg, off in info.get('lcalls', [])[:6]:
            body_lines.append(f'    /*    LCALL 0x{seg:04X}:0x{off:04X} */')
        for tgt in info.get('near_calls', [])[:6]:
            body_lines.append(f'    /*    CALL  0x{tgt:06X} */')
        body_lines.append('    return 0;')
    elif pattern in ('MEDIUM_LOGIC', 'LARGE_LOGIC', 'PROLOGUE_HEAVY', 'UNKNOWN'):
        body_lines = [f'    /* @auto: {pattern} -- needs hand-port.',
                      f'     * @ref see ../code/VICEROY/disasm/{os.path.basename(func["asm_file"])} */']
        if info['lcalls']:
            body_lines.append('    /* LCALL targets:')
            for seg, off in info['lcalls'][:8]:
                body_lines.append(f'     *    0x{seg:04X}:0x{off:04X}')
            body_lines.append('     */')
        body_lines.append('    return 0;  /* TODO */')
    else:
        body_lines = [f'    /* @auto: pattern={pattern}. Needs hand-port. */',
                      '    return 0;']

    body = '\n'.join(body_lines)

    sig_line = f"int {fname}({arg_str})"

    return f"""{citation}
{sig_line}
{{
{body}
}}
"""


def main():
    funcs_data, classes_data, callgraph, thunks_data = load()
    funcs_by_offset = {f['file_offset']: f for f in funcs_data['functions']}
    overlay_funcs = [f for f in funcs_data['functions'] if f['region'] == 'overlay']
    classes = classes_data['functions']

    # Group by segment id (best-effort; for now, all into seg_unknown)
    by_segment = defaultdict(list)
    for func in overlay_funcs:
        seg_id = thunk_segment_for(func['file_offset'], thunks_data)
        if seg_id is None:
            seg_id = 'unknown'
        by_segment[seg_id].append(func)

    os.makedirs(OUT_DIR, exist_ok=True)

    # Bucket overlay functions into ~25 chunks for manageable file sizes.
    # Sort by file_offset, then group by 25-30 functions per file.
    chunks = []
    sorted_funcs = sorted(overlay_funcs, key=lambda f: int(f['file_offset'], 16))
    chunk_size = 30
    for i in range(0, len(sorted_funcs), chunk_size):
        chunks.append(sorted_funcs[i:i + chunk_size])

    print(f"[overlay_to_c] generating {len(chunks)} files for {len(overlay_funcs)} functions")

    # Emit overlay_externs.h
    all_lcalls = set()
    for func in overlay_funcs:
        info = classes.get(func['file_offset'], {})
        for seg, off in info.get('lcalls', []):
            all_lcalls.add((seg, off))
    print(f"[overlay_to_c] {len(all_lcalls)} distinct overlay LCALL targets")
    with open(EXTERNS_H, 'w', encoding='utf-8') as f:
        f.write("""/* ============================================================================
 * overlay_externs.h -- declarations for every overlay LCALL target
 * Auto-generated by tools/overlay_to_c.py -- do not edit by hand.
 * ============================================================================ */
#ifndef VICEROY_OVERLAY_EXTERNS_H
#define VICEROY_OVERLAY_EXTERNS_H
#include "viceroy_types.h"

""")
        for seg, off in sorted(all_lcalls):
            f.write(f"extern int overlay_call_{seg:04X}_{off:04X}(void);  /* @ref RTLink seg 0x{seg:04X} off 0x{off:04X} */\n")
        f.write("\n#endif /* VICEROY_OVERLAY_EXTERNS_H */\n")
    print(f"[overlay_to_c] wrote {EXTERNS_H}")

    # Emit overlay function files
    manifest = []
    pattern_counts = Counter()
    for chunk_idx, chunk in enumerate(chunks):
        chunk_first = int(chunk[0]['file_offset'], 16)
        chunk_last = int(chunk[-1]['file_offset'], 16) + chunk[-1]['size']
        out_name = f"overlay_{chunk_first:06X}_{chunk_last:06X}.c"
        out_path = os.path.join(OUT_DIR, out_name)

        with open(out_path, 'w', encoding='utf-8') as f:
            f.write(f"""/* ============================================================================
 * {out_name} -- overlay functions in file range 0x{chunk_first:06X}..0x{chunk_last:06X}
 * Auto-generated by tools/overlay_to_c.py.
 *
 * {len(chunk)} functions in this file. Each carries a citation block
 * pointing back to its disassembled .asm file. Functions marked STUB have
 * auto-generated bodies that need hand-port.
 * ============================================================================ */
#include "viceroy.h"
#include "overlay_externs.h"

""")
            for func in chunk:
                info = classes.get(func['file_offset'], {})
                callers = caller_count_for(func['file_offset'], callgraph)
                pattern_counts[info.get('pattern', 'UNKNOWN')] += 1
                f.write(emit_function(func, info, callers))
                f.write("\n")
                manifest.append((func['file_offset'], func['size'], info.get('pattern', '?'),
                                 callers, out_name))

    # Manifest
    with open(MANIFEST_MD, 'w', encoding='utf-8') as f:
        f.write(f"# Overlay-source MANIFEST\n\n")
        f.write(f"Auto-generated by `tools/overlay_to_c.py`.\n\n")
        f.write(f"**{len(overlay_funcs)} functions** distributed across {len(chunks)} files.\n\n")
        f.write(f"## Pattern distribution\n\n")
        for p, n in pattern_counts.most_common():
            f.write(f"- **{p}**: {n}\n")
        f.write(f"\n## Per-function status\n\n")
        f.write(f"| Offset | Size | Pattern | Callers | File |\n")
        f.write(f"|---|--:|---|--:|---|\n")
        for off, sz, pat, c, fn in manifest:
            f.write(f"| {off} | {sz} | {pat} | {c} | {fn} |\n")
    print(f"[overlay_to_c] wrote {MANIFEST_MD}")
    print(f"[overlay_to_c] DONE -- {sum(pattern_counts.values())} stubs emitted")


if __name__ == '__main__':
    main()
