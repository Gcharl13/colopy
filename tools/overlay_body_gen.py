"""
overlay_body_gen.py -- generate richer pseudo-C bodies for overlay functions.

For every overlay function, parse its .asm and extract:
  - The sequence of CALL/LCALL operations (with operands)
  - The major branches (Jcc instructions)
  - Reads/writes of DGROUP globals (the [0xNNNN] form)
  - Loop structures (LOOP / JCXZ / explicit DEC+JNE)

Emit a richer body that documents this structure, instead of just
"return 0; /* TODO */".

The output replaces the previous overlay_*.c files in viceroy_source/src/overlay/
with the same MANIFEST + extern declarations.
"""

import json
import os
import re
from collections import defaultdict, Counter

PROJECT = str(__import__("pathlib").Path(__file__).resolve().parents[1])
DISASM_DIR = os.path.join(PROJECT, "code", "VICEROY", "disasm")
FUNCTIONS_JSON = os.path.join(PROJECT, "code", "VICEROY", "functions.json")
CLASS_JSON = os.path.join(PROJECT, "code", "VICEROY", "overlay_classification.json")
CALLGRAPH_JSON = os.path.join(PROJECT, "code", "VICEROY", "callgraph.json")
OUT_DIR = os.path.join(PROJECT, "viceroy_source", "src", "overlay")
EXTERNS_H = os.path.join(PROJECT, "viceroy_source", "include", "overlay_externs.h")
MANIFEST_MD = os.path.join(OUT_DIR, "MANIFEST.md")

# Patterns for assembly parsing
RE_INSTR = re.compile(r'^([0-9A-Fa-f]+)\s+([0-9A-F ]{1,30}?)\s+([A-Z][A-Z0-9_]*)\s*(.*?)$')
RE_LCALL = re.compile(r'LCALL\s+0x([0-9a-fA-F]+)\s*,\s*0x([0-9a-fA-F]+)')
RE_NEAR_CALL = re.compile(r'CALL\s+0x([0-9a-fA-F]+)')
RE_JCC = re.compile(r'^J(?!MP)([A-Z]+)\s+0x([0-9a-fA-F]+)')   # Jcc except plain JMP
RE_JMP = re.compile(r'^JMP\s+0x([0-9a-fA-F]+)')
RE_DGROUP_REF = re.compile(r'\[0x([0-9a-fA-F]+)\]')
RE_DGROUP_INDEXED = re.compile(r'\[(?:bx|si|di|bp)\s*[+]\s*(?:bx|si|di)\s*[+]\s*0x([0-9a-fA-F]+)\]')
RE_LOOP = re.compile(r'^LOOP\s+0x([0-9a-fA-F]+)')
RE_JCXZ = re.compile(r'^JCXZ\s+0x([0-9a-fA-F]+)')


def parse_asm(asm_path):
    """Extract structured info from a .asm file."""
    if not os.path.isfile(asm_path):
        return None
    with open(asm_path, 'r', encoding='utf-8', errors='replace') as f:
        content = f.read()

    instrs = []
    for line in content.splitlines():
        line = line.rstrip()
        if line.startswith(';') or not line.strip():
            continue
        # Strip the trailing ; comment
        m = re.match(r'^([0-9A-Fa-f]+)\s+([0-9A-F ]{1,30}?)\s{2,}([A-Z][A-Z0-9_]*)\s*(.*?)(?:\s*;.*)?$', line)
        if m:
            addr_hex, bytes_hex, mnemonic, operands = m.groups()
            instrs.append({
                'addr': int(addr_hex, 16),
                'bytes': bytes_hex.strip(),
                'mnemonic': mnemonic.upper(),
                'operands': (operands or '').strip(),
                'full': f"{mnemonic} {operands}".strip(),
            })
    return instrs


def trace_control_flow(instrs):
    """Trace the rough control flow of a function: list calls, branches, loops."""
    events = []
    globals_read = set()
    globals_written = set()
    for ins in instrs:
        full = ins['full']
        addr = ins['addr']
        # LCALL with constant operands
        m = RE_LCALL.search(full)
        if m:
            seg, off = int(m.group(1), 16), int(m.group(2), 16)
            events.append(('lcall', addr, seg, off))
            continue
        # Near CALL with operand
        m = RE_NEAR_CALL.search(full)
        if m and ins['mnemonic'] == 'CALL':
            tgt = int(m.group(1), 16)
            events.append(('call', addr, tgt))
            continue
        # Jcc
        m = RE_JCC.match(full)
        if m and ins['mnemonic'] not in ('JMP',):
            cond = m.group(1)         # the captured suffix, e.g. "E", "GE", "L"
            tgt = int(m.group(2), 16)
            events.append(('jcc', addr, cond, tgt))
            continue
        # Plain JMP
        m = RE_JMP.match(full)
        if m:
            tgt = int(m.group(1), 16)
            events.append(('jmp', addr, tgt))
            continue
        # LOOP
        m = RE_LOOP.match(full)
        if m:
            tgt = int(m.group(1), 16)
            events.append(('loop', addr, tgt))
            continue
        # JCXZ
        m = RE_JCXZ.match(full)
        if m:
            tgt = int(m.group(1), 16)
            events.append(('jcxz', addr, tgt))
            continue
        # DGROUP global read/write
        m = RE_DGROUP_REF.search(full)
        if m:
            addr_g = int(m.group(1), 16)
            if ins['mnemonic'] in ('MOV', 'CMP', 'TEST', 'AND', 'OR', 'XOR', 'ADD', 'SUB', 'INC', 'DEC'):
                if 'word ptr [0x' in full and ',' in full and full.split(',')[1].strip().startswith('['):
                    globals_read.add(addr_g)
                elif full.split(' ', 1)[1].strip().startswith('byte ptr ['):
                    # READ if first operand
                    if ins['mnemonic'] in ('CMP', 'TEST'):
                        globals_read.add(addr_g)
                    else:
                        globals_written.add(addr_g)
                else:
                    if ins['mnemonic'] in ('CMP', 'TEST'):
                        globals_read.add(addr_g)
                    elif ins['mnemonic'] in ('MOV',) and ',' in full:
                        # MOV [0x...], src   = write
                        # MOV reg, [0x...]   = read
                        first_op = full.split(',', 1)[0]
                        if '[' in first_op and ']' in first_op:
                            globals_written.add(addr_g)
                        else:
                            globals_read.add(addr_g)
                    else:
                        globals_read.add(addr_g)
    return events, globals_read, globals_written


def build_skeleton_body(events, globals_read, globals_written, info, size):
    """Build a pseudo-C body skeleton from the control-flow events."""
    lines = []
    lines.append('    /* @auto: control-flow trace from disassembly. */')

    # Globals touched
    if globals_read or globals_written:
        lines.append('    /*')
        if globals_read:
            grs = ', '.join(f"0x{g:04X}" for g in sorted(globals_read)[:10])
            lines.append(f'     * Reads DGROUP: {grs}{" ..." if len(globals_read) > 10 else ""}')
        if globals_written:
            gws = ', '.join(f"0x{g:04X}" for g in sorted(globals_written)[:10])
            lines.append(f'     * Writes DGROUP: {gws}{" ..." if len(globals_written) > 10 else ""}')
        lines.append('     */')

    # Walk events: emit pseudo-C step-by-step
    indent = 1
    open_blocks = []      # stack of (close_addr) for open if-blocks

    for event in events:
        kind = event[0]
        addr = event[1]
        # Close any open blocks whose close-target is this address
        while open_blocks and open_blocks[-1] <= addr:
            close_addr = open_blocks.pop()
            indent -= 1
            lines.append('    ' + '    ' * indent + '}')

        prefix = '    ' + '    ' * indent

        if kind == 'lcall':
            seg, off = event[2], event[3]
            lines.append(f'{prefix}/* @0x{addr:06X} */ overlay_call_{seg:04X}_{off:04X}();')
        elif kind == 'call':
            tgt = event[2]
            lines.append(f'{prefix}/* @0x{addr:06X} */ func_{tgt:06X}();')
        elif kind == 'jcc':
            cond, tgt = event[2], event[3]
            # Open an if-block that will close at the jump target
            inverted = invert_cond(cond)
            lines.append(f'{prefix}if ({inverted}) /* @0x{addr:06X} J{cond} 0x{tgt:06X} */ {{')
            open_blocks.append(tgt)
            indent += 1
        elif kind == 'jmp':
            tgt = event[2]
            lines.append(f'{prefix}goto label_{tgt:06X};  /* @0x{addr:06X} */')
        elif kind == 'loop':
            tgt = event[2]
            lines.append(f'{prefix}/* @0x{addr:06X} LOOP back to 0x{tgt:06X} */')
        elif kind == 'jcxz':
            tgt = event[2]
            lines.append(f'{prefix}if (cx == 0) goto label_{tgt:06X};  /* @0x{addr:06X} */')

    # Close any remaining blocks
    while open_blocks:
        open_blocks.pop()
        indent -= 1
        lines.append('    ' + '    ' * indent + '}')

    lines.append('    return 0;  /* @auto: TODO confirm return semantics */')
    return '\n'.join(lines)


def invert_cond(cond):
    """Invert a Jcc condition (so we can wrap the if-block-not-taken path)."""
    # Cond on JCC means "jump if condition true" -- to wrap the fall-through
    # path we need the OPPOSITE. We just emit a sentinel comment for now.
    inverters = {
        'E': '!=', 'Z': '!=',
        'NE': '==', 'NZ': '==',
        'L': '>=', 'NGE': '>=',
        'G': '<=', 'NLE': '<=',
        'LE': '>', 'NG': '>',
        'GE': '<', 'NL': '<',
        'B': '>=', 'NAE': '>=', 'C': '>=',
        'A': '<=', 'NBE': '<=',
        'BE': '>', 'NA': '>',
        'AE': '<', 'NB': '<', 'NC': '<',
        'S': '!signed', 'NS': 'signed',
        'O': '!overflow', 'NO': 'overflow',
        'P': 'odd_parity', 'PE': 'odd_parity',
        'NP': 'even_parity', 'PO': 'even_parity',
    }
    op = inverters.get(cond.upper(), '!=')
    return f"/* J{cond} fallthrough cond: */ ax {op} 0"


def args_signature(args):
    if not args:
        return ('int', [])
    arg_decls = []
    for i, slot in enumerate(args):
        arg_decls.append(f"uint16_t arg{i}_bp_{slot:02X}")
    return ('int', arg_decls)


def funcname_for(asm_file):
    return os.path.basename(asm_file).replace('.asm', '')


def emit_lcalls_block(events):
    """Build a citation comment listing all LCALLs and CALLs at start."""
    lcalls = [(e[2], e[3]) for e in events if e[0] == 'lcall']
    near_calls = [e[2] for e in events if e[0] == 'call']
    lines = []
    if lcalls:
        lines.append(' *')
        lines.append(' * LCALL targets:')
        seen = set()
        for seg, off in lcalls:
            key = (seg, off)
            if key in seen: continue
            seen.add(key)
            count = sum(1 for s, o in lcalls if (s, o) == key)
            lines.append(f' *   - 0x{seg:04X}:0x{off:04X}' + (f'  ({count}x)' if count > 1 else ''))
    if near_calls:
        lines.append(' *')
        lines.append(' * Near CALL targets:')
        seen = set()
        for tgt in near_calls:
            if tgt in seen: continue
            seen.add(tgt)
            count = near_calls.count(tgt)
            lines.append(f' *   - 0x{tgt:06X}' + (f'  ({count}x)' if count > 1 else ''))
    if not lines:
        return ''
    return '\n' + '\n'.join(lines)


def emit_function(func, info, callers, events, globals_read, globals_written):
    """Emit one function with control-flow-derived body."""
    file_offset = func['file_offset']
    fo_int = int(file_offset, 16)
    size = func['size']
    pattern = info['pattern']
    fname = funcname_for(func['asm_file'])
    ret_type, args = args_signature(info.get('args', []))
    arg_str = "void" if not args else ", ".join(args)

    lcalls_block = emit_lcalls_block(events)

    citation = f"""/* @asm        0x{fo_int:06X}..0x{fo_int+size:06X}  ({size} bytes)  region=overlay
 * @asm_file   ../code/VICEROY/disasm/{os.path.basename(func['asm_file'])}
 * @pattern    {pattern}
 * @prologue   {info.get('prologue', '?')}
 * @args_seen  {info.get('args', [])}
 * @lcalls     {sum(1 for e in events if e[0] == 'lcall')}
 * @near_calls {sum(1 for e in events if e[0] == 'call')}
 * @callers    {callers}
 * @touches_8542 {info.get('touches_8542', False)}{lcalls_block}
 * @status     SKELETON (auto-traced control flow; semantics TBD)
 */"""

    # Build body based on pattern; for LARGE/MEDIUM/UNKNOWN/PROLOGUE_HEAVY use control-flow trace.
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
    elif pattern == 'BIT_ACCESSOR':
        body = '    /* @auto: bit-array accessor. Pattern matches test_bit_at_8a family.\n     *        Use idx>>3 + (1<<(idx&7)). */\n    return 0;  /* TODO: identify bit-array offset */'
    elif pattern == 'NIBBLE_ACCESSOR':
        body = '    /* @auto: nibble pack/unpack. Pattern matches unpack_nibble_at_60. */\n    return 0;  /* TODO: identify nibble-array offset */'
    elif pattern in ('DISPATCHER', 'COUNT_LOOP', 'FIND_LOOP', 'PROLOGUE_HEAVY',
                      'MEDIUM_LOGIC', 'LARGE_LOGIC', 'UNKNOWN', 'EMPTY', 'MISSING_ASM'):
        body = build_skeleton_body(events, globals_read, globals_written, info, size)
    else:
        body = '    /* @auto: unrecognized pattern. */\n    return 0;'

    return f"""{citation}
int {fname}({arg_str})
{{
{body}
}}
"""


def main():
    with open(FUNCTIONS_JSON) as f:
        funcs_data = json.load(f)
    with open(CLASS_JSON) as f:
        classes_data = json.load(f)
    try:
        with open(CALLGRAPH_JSON) as f:
            cg = json.load(f)
    except Exception:
        cg = {}

    overlay_funcs = sorted(
        [f for f in funcs_data['functions'] if f['region'] == 'overlay'],
        key=lambda f: int(f['file_offset'], 16))
    classes = classes_data['functions']

    # Build caller-count map
    caller_counts = {}
    if 'edges' in cg:
        for e in cg['edges']:
            callee = e.get('callee', '').lower()
            caller_counts[callee] = caller_counts.get(callee, 0) + 1
    elif 'callers' in cg:
        for callee, callers in cg['callers'].items():
            caller_counts[callee.lower()] = len(callers)

    # Parse each .asm file once
    print(f"[overlay_body_gen] parsing {len(overlay_funcs)} .asm files...")
    parsed = {}
    for i, func in enumerate(overlay_funcs):
        if i % 100 == 0:
            print(f"  ... {i}/{len(overlay_funcs)}")
        asm_path = os.path.join(DISASM_DIR, os.path.basename(func['asm_file']))
        instrs = parse_asm(asm_path)
        if instrs is None:
            parsed[func['file_offset']] = ([], set(), set())
            continue
        events, gr, gw = trace_control_flow(instrs)
        parsed[func['file_offset']] = (events, gr, gw)

    # Bucket into 30-function chunks
    chunks = []
    chunk_size = 30
    for i in range(0, len(overlay_funcs), chunk_size):
        chunks.append(overlay_funcs[i:i + chunk_size])

    # Emit overlay_externs.h with all referenced LCALL targets
    all_lcalls = set()
    for func in overlay_funcs:
        events, _, _ = parsed[func['file_offset']]
        for e in events:
            if e[0] == 'lcall':
                all_lcalls.add((e[2], e[3]))
    print(f"[overlay_body_gen] {len(all_lcalls)} distinct LCALL targets")
    with open(EXTERNS_H, 'w', encoding='utf-8') as f:
        f.write("""/* ============================================================================
 * overlay_externs.h -- declarations for every overlay LCALL target
 * Auto-generated by tools/overlay_body_gen.py.
 * ============================================================================ */
#ifndef VICEROY_OVERLAY_EXTERNS_H
#define VICEROY_OVERLAY_EXTERNS_H
#include "viceroy_types.h"

""")
        for seg, off in sorted(all_lcalls):
            f.write(f"extern int overlay_call_{seg:04X}_{off:04X}(void);  /* @ref RTLink seg 0x{seg:04X} off 0x{off:04X} */\n")
        f.write("\n#endif /* VICEROY_OVERLAY_EXTERNS_H */\n")

    # Emit per-chunk .c files
    print(f"[overlay_body_gen] emitting {len(chunks)} files...")
    manifest = []
    pattern_counts = Counter()
    for ci, chunk in enumerate(chunks):
        first = int(chunk[0]['file_offset'], 16)
        last = int(chunk[-1]['file_offset'], 16) + chunk[-1]['size']
        out_name = f"overlay_{first:06X}_{last:06X}.c"
        out_path = os.path.join(OUT_DIR, out_name)

        with open(out_path, 'w', encoding='utf-8') as f:
            f.write(f"""/* ============================================================================
 * {out_name} -- overlay functions in file range 0x{first:06X}..0x{last:06X}
 * Auto-generated by tools/overlay_body_gen.py.
 *
 * {len(chunk)} functions in this file. Each carries a citation block plus
 * an auto-traced control-flow body that documents every CALL/LCALL/branch
 * found in the disassembly. Functions marked SKELETON have body content
 * derived from control-flow but their semantics still need hand-port.
 * ============================================================================ */
#include "viceroy.h"
#include "overlay_externs.h"

""")
            for func in chunk:
                info = classes.get(func['file_offset'], {})
                callers = caller_counts.get(func['file_offset'].lower(), 0)
                events, gr, gw = parsed[func['file_offset']]
                pattern_counts[info.get('pattern', 'UNKNOWN')] += 1
                f.write(emit_function(func, info, callers, events, gr, gw))
                f.write("\n")
                manifest.append((func['file_offset'], func['size'],
                                 info.get('pattern', '?'), callers,
                                 len(events), out_name))

    # Manifest
    with open(MANIFEST_MD, 'w', encoding='utf-8') as f:
        f.write(f"# Overlay-source MANIFEST\n\n")
        f.write(f"Auto-generated by `tools/overlay_body_gen.py`.\n\n")
        f.write(f"**{len(overlay_funcs)} functions** distributed across {len(chunks)} files.\n\n")
        f.write(f"## Pattern distribution\n\n")
        for p, n in pattern_counts.most_common():
            f.write(f"- **{p}**: {n}\n")
        f.write(f"\n## Per-function status (offset, size, pattern, callers, control-flow events, file)\n\n")
        f.write(f"| Offset | Size | Pattern | Callers | Events | File |\n")
        f.write(f"|---|--:|---|--:|--:|---|\n")
        for off, sz, pat, c, ev, fn in manifest:
            f.write(f"| {off} | {sz} | {pat} | {c} | {ev} | {fn} |\n")
    print(f"[overlay_body_gen] DONE -- {sum(pattern_counts.values())} stubs emitted")


if __name__ == '__main__':
    main()
