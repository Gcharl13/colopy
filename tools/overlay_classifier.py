"""
overlay_classifier.py — pattern-detect each overlay function.

For every function in functions.json with region == 'overlay', read its
.asm file and classify the body shape into one of these patterns:

  TINY_ACCESSOR    — <30 bytes, no LCALL, single struct-field load
  TINY_RETURN      — <15 bytes, returns a constant/global only
  WRAPPER_LCALL    — <60 bytes, single LCALL forwards
  WRAPPER_NEARCALL — <60 bytes, single near CALL
  DISPATCHER       — multiple LCALLs with constant opcodes
  BIT_ACCESSOR     — bit-array test/set/clear pattern
  NIBBLE_ACCESSOR  — packed-nibble pack/unpack pattern
  COUNT_LOOP       — simple iteration accumulating a counter
  FIND_LOOP        — linear scan with early return on match
  PROLOGUE_HEAVY   — prologue + several PUSH/POP only (likely empty body)
  LARGE_LOGIC      — 200+ bytes; needs hand-port
  UNKNOWN          — doesn't match any pattern

For each function, also extract:
  - prologue type: ENTER N / PUSH-BP / PUSH-BP+SI
  - args (from final operand displacement at [bp+6], [bp+8], [bp+0xA]…)
  - LCALLs found in the body (segment:offset pairs)
  - near CALLs found (relative target)
  - whether DGROUP global at 0x8542 (colony struct ptr) is referenced

Output: code/VICEROY/overlay_classification.json with one entry per function.
"""

import json
import re
import os
import sys
from collections import Counter

PROJECT = str(__import__("pathlib").Path(__file__).resolve().parents[1])
DISASM_DIR = os.path.join(PROJECT, "code", "VICEROY", "disasm")
FUNCTIONS_JSON = os.path.join(PROJECT, "code", "VICEROY", "functions.json")
OUTPUT_JSON = os.path.join(PROJECT, "code", "VICEROY", "overlay_classification.json")


# ---- Regexes ---------------------------------------------------------------

LINE_RE = re.compile(r'^([0-9A-Fa-f]+)\s+([0-9A-F ]+?)\s{2,}([A-Z][A-Z0-9_ ]*?)\s+(.*?)(?:\s*;|$)')
LCALL_RE = re.compile(r'LCALL\s+(?:0x([0-9a-fA-F]+))?\s*[,]\s*(?:0x([0-9a-fA-F]+))?')
NEAR_CALL_RE = re.compile(r'CALL\s+0x([0-9a-fA-F]+)')
ENTER_RE = re.compile(r'ENTER\s+(0x[0-9a-fA-F]+|\d+)\s*,\s*(\d+)')
PUSH_BP_RE = re.compile(r'\bPUSH\s+bp\b', re.IGNORECASE)
MOV_BP_SP_RE = re.compile(r'\bMOV\s+bp\s*,\s*sp\b', re.IGNORECASE)


def parse_asm(asm_path):
    """Parse a .asm file into structured form."""
    with open(asm_path, 'r', encoding='utf-8', errors='replace') as f:
        content = f.read()

    instructions = []
    for line in content.splitlines():
        # Skip header/comment lines
        if line.startswith(';') or not line.strip():
            continue
        # Try to extract a hex-prefixed line
        m = re.match(r'^([0-9A-Fa-f]+)\s+([0-9A-F ]{1,30})\s+(.*?)(?:\s*;.*)?$', line)
        if m:
            addr_str, bytes_str, rest = m.groups()
            mnemonic = rest.split()[0] if rest.split() else ''
            instructions.append({
                'addr': int(addr_str, 16),
                'bytes': bytes_str.strip(),
                'mnemonic': mnemonic.upper(),
                'rest': rest.strip(),
            })
    return instructions


def classify(func, asm_path):
    """Classify an overlay function's pattern."""
    info = {
        'file_offset': func['file_offset'],
        'size': func['size'],
        'asm_file': func['asm_file'],
        'pattern': 'UNKNOWN',
        'prologue': None,
        'args': [],
        'lcalls': [],
        'near_calls': [],
        'touches_8542': False,
        'instruction_count': 0,
    }

    if not os.path.isfile(asm_path):
        info['pattern'] = 'MISSING_ASM'
        return info

    instrs = parse_asm(asm_path)
    info['instruction_count'] = len(instrs)
    if not instrs:
        info['pattern'] = 'EMPTY'
        return info

    # ---- Detect prologue ----
    first_few = ' | '.join(i['rest'] for i in instrs[:4])
    if 'ENTER' in first_few:
        m = ENTER_RE.search(first_few)
        if m:
            info['prologue'] = f"ENTER {m.group(1)}"
    elif PUSH_BP_RE.search(first_few) and MOV_BP_SP_RE.search(first_few):
        info['prologue'] = 'PUSH-BP-MOV-BP-SP'
    else:
        info['prologue'] = 'OTHER'

    # ---- Find LCALLs and near CALLs ----
    for ins in instrs:
        rest = ins['rest']
        if 'LCALL' in rest:
            m = LCALL_RE.search(rest)
            if m and m.group(2):
                seg = int(m.group(1) or '0', 16)
                off = int(m.group(2), 16)
                info['lcalls'].append((seg, off))
        elif rest.startswith('CALL '):
            m = NEAR_CALL_RE.search(rest)
            if m:
                info['near_calls'].append(int(m.group(1), 16))
        # Check for DGROUP:0x8542 reference
        if '0x8542' in rest or '85 42' in ins['bytes']:
            info['touches_8542'] = True

    # ---- Detect args from PUSH word ptr [bp+N] near the end ----
    args_seen = set()
    for ins in instrs:
        m = re.search(r'\[bp\s*\+\s*(0x[0-9a-fA-F]+|\d+)\]', ins['rest'])
        if m:
            v = m.group(1)
            n = int(v, 16) if v.startswith('0x') else int(v)
            if n >= 6 and n < 0x40:    # arg slot range
                args_seen.add(n)
    info['args'] = sorted(args_seen)

    # ---- Pattern classification ----
    sz = func['size']
    n_lcalls = len(info['lcalls'])
    n_calls = len(info['near_calls'])

    if sz >= 200:
        info['pattern'] = 'LARGE_LOGIC'
    elif sz < 12:
        info['pattern'] = 'TINY_RETURN'
    elif sz < 30 and n_lcalls == 0 and n_calls == 0:
        info['pattern'] = 'TINY_ACCESSOR'
    elif sz < 60 and n_lcalls == 1 and n_calls == 0:
        info['pattern'] = 'WRAPPER_LCALL'
    elif sz < 60 and n_calls == 1 and n_lcalls == 0:
        info['pattern'] = 'WRAPPER_NEARCALL'
    elif n_lcalls >= 3 or n_calls >= 3:
        info['pattern'] = 'DISPATCHER'
    elif sz < 60 and any('SHL' in i['rest'] or 'SAR' in i['rest'] for i in instrs):
        # Contains shift; likely bit/nibble access
        for i in instrs:
            if 'AND' in i['rest'] and ('0x07' in i['rest'] or '0x0f' in i['rest']):
                info['pattern'] = 'BIT_ACCESSOR' if '0x07' in i['rest'] else 'NIBBLE_ACCESSOR'
                break
        else:
            info['pattern'] = 'WRAPPER_NEARCALL' if n_calls else 'TINY_ACCESSOR'
    elif any(i['mnemonic'] == 'LOOP' or 'JCXZ' in i['rest'] for i in instrs):
        # Has explicit loop
        if any('INC' in i['rest'] for i in instrs):
            info['pattern'] = 'COUNT_LOOP'
        else:
            info['pattern'] = 'FIND_LOOP'
    elif sz < 100 and n_lcalls + n_calls <= 1:
        info['pattern'] = 'PROLOGUE_HEAVY'
    elif sz >= 100:
        info['pattern'] = 'MEDIUM_LOGIC'

    return info


def main():
    with open(FUNCTIONS_JSON, 'r') as f:
        funcs_data = json.load(f)
    funcs = funcs_data['functions']
    overlay_funcs = [f for f in funcs if f['region'] == 'overlay']
    print(f"[overlay_classifier] {len(overlay_funcs)} overlay functions")

    results = {}
    pattern_counts = Counter()

    # Build a dict of available asm files keyed by offset prefix (handles renames)
    asm_by_offset = {}
    for fname in os.listdir(DISASM_DIR):
        m = re.match(r'func_([0-9A-Fa-f]+)_', fname)
        if m:
            asm_by_offset[m.group(1).upper().zfill(6)] = os.path.join(DISASM_DIR, fname)

    for i, func in enumerate(overlay_funcs):
        if i % 100 == 0:
            print(f"  ... {i}/{len(overlay_funcs)}")
        offset_key = func['file_offset'].replace('0x', '').upper().zfill(6)
        asm_path = asm_by_offset.get(offset_key)
        if not asm_path:
            asm_path = os.path.join(PROJECT, *func['asm_file'].split('/'))
            if not os.path.isfile(asm_path):
                asm_path = os.path.join(DISASM_DIR, os.path.basename(func['asm_file']))
        info = classify(func, asm_path)
        results[func['file_offset']] = info
        pattern_counts[info['pattern']] += 1

    print(f"\n[overlay_classifier] pattern distribution:")
    for p, n in pattern_counts.most_common():
        print(f"  {p:20s}: {n}")

    with open(OUTPUT_JSON, 'w') as f:
        json.dump({'pattern_counts': dict(pattern_counts), 'functions': results}, f, indent=2)
    print(f"\n[overlay_classifier] wrote {OUTPUT_JSON}")


if __name__ == '__main__':
    main()
