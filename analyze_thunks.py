#!/usr/bin/env python3
"""
Resolve three RTLink thunks in VICEROY.EXE and disassemble their target bodies.
"""
import sys
import os
import struct
import json

sys.path.insert(0, '/home/user/colopy/viceroy_source/tools')
from viceroy_exe import EXE

VICEROY = '/home/user/colopy/re_work/VICEROY.EXE'
LOAD_BASE = 0x2400

# --- Load segment map from the pre-built JSON (faster than re-running flatten.py) ---
SEGMAP_PATH = '/home/user/colopy/re_work/overlay_segmap.json'
with open(SEGMAP_PATH) as f:
    _raw = json.load(f)
segmap = {int(k): v for k, v in _raw.items()}
print("=== Overlay segment map (numeric segids only) ===")
for sid in sorted(segmap):
    v = segmap[sid]
    print(f"  segid {sid:>3}  base={v['base']:#010x} ({v['base']})  "
          f"match={v['match']}/{v['total']}  {v['confidence']}")
print()

exe = EXE(VICEROY)

# ---- Thunk file offsets ----
# Formula: file_off = 0x2400 + seg*16 + off
def foff(seg, off):
    return LOAD_BASE + seg * 16 + off

thunks = [
    {
        'label':   'survivors join, outcome 9',
        'alias':   '0x191F:0xAC8',
        'thunk_foff': foff(0x191F, 0xAC8),
        'seg': 0x191F, 'off': 0xAC8,
    },
    {
        'label':   'per-immigrant Fountain-of-Youth loop body, outcome 1',
        'alias':   '0x191F:0xD2C',
        'thunk_foff': foff(0x191F, 0xD2C),
        'seg': 0x191F, 'off': 0xD2C,
    },
    {
        'label':   'per-owner notify after Cibola/burial treasure spawn',
        'alias':   '0x1A1F:0x6EC',
        'thunk_foff': foff(0x1A1F, 0x6EC),
        'seg': 0x1A1F, 'off': 0x6EC,
    },
]

# Sanity-check computed thunk offsets
print("=== Thunk file offset verification ===")
for t in thunks:
    print(f"  {t['alias']}  -> thunk at file 0x{t['thunk_foff']:05X}  (decimal {t['thunk_foff']})")
print()

TYPE_A_LOADER = (0xAB, 0x0D, 0x0D, 0x11)
TYPE_B_LOADER = (0x91, 0x0D, 0x0D, 0x11)

def parse_thunk(data14):
    """Returns dict with keys: type, off, segid, extra (Type-A only)"""
    if len(data14) < 12:
        return None
    if data14[0] != 0x9A or data14[5] != 0xEA:
        return {'type': 'UNKNOWN', 'raw': data14.hex()}
    loader = tuple(data14[1:5])
    off  = struct.unpack_from('<H', data14, 6)[0]
    seg  = struct.unpack_from('<H', data14, 8)[0]
    if seg != 0x0000:
        # RESIDENT thunk
        return {'type': 'RESIDENT', 'off': off, 'seg': seg}
    segid = struct.unpack_from('<H', data14, 10)[0]
    if loader == TYPE_A_LOADER and len(data14) >= 14:
        extra = struct.unpack_from('<H', data14, 12)[0]
        return {'type': 'A', 'off': off, 'segid': segid, 'extra': extra}
    elif loader == TYPE_B_LOADER:
        return {'type': 'B', 'off': off, 'segid': segid}
    else:
        return {'type': 'UNKNOWN_LOADER', 'loader': loader, 'off': off, 'segid': segid, 'raw': data14.hex()}

def resolve(parsed):
    """Return (file_offset, base, confidence) or (None, None, None)."""
    if parsed['type'] == 'RESIDENT':
        # foff is directly computable
        fo = LOAD_BASE + parsed['seg'] * 16 + parsed['off']
        return fo, None, 'RESIDENT'
    if parsed['type'] not in ('A', 'B'):
        return None, None, None
    sid = parsed['segid']
    e = segmap.get(sid)
    if e is None:
        return None, None, f'segid {sid} not in map'
    off = parsed['off']
    extra = parsed.get('extra', 0)
    fo = e['base'] + extra * 16 + off
    return fo, e['base'], e['confidence']

results = []
for t in thunks:
    foff_thunk = t['thunk_foff']
    raw = exe.read(foff_thunk, 14)
    parsed = parse_thunk(raw)
    target_foff, base, conf = resolve(parsed)

    print(f"{'='*72}")
    print(f"THUNK: {t['alias']}  ({t['label']})")
    print(f"  thunk at file 0x{foff_thunk:05X}")
    print(f"  raw bytes (14): {raw.hex(' ')}")
    print(f"  parsed: {parsed}")
    if target_foff is not None:
        print(f"  RESOLVED -> file 0x{target_foff:06X}  (decimal {target_foff})")
        if base is not None:
            extra = parsed.get('extra', 0)
            if extra:
                print(f"    formula: base[segid={parsed['segid']}]={base:#x} + extra={extra}*16 + off={parsed['off']:#x}")
            else:
                print(f"    formula: base[segid={parsed['segid']}]={base:#x} + off={parsed['off']:#x}")
        print(f"  confidence: {conf}")
        print()
        print(f"  --- DISASSEMBLY at file 0x{target_foff:06X} (200 bytes) ---")
        disasm_txt = exe.disasm_str(target_foff, 200)
        print(disasm_txt)
        results.append({
            'label': t['label'],
            'alias': t['alias'],
            'thunk_foff': foff_thunk,
            'raw': raw.hex(),
            'parsed': parsed,
            'target_foff': target_foff,
            'base': base,
            'confidence': conf,
            'disasm': disasm_txt,
        })
    else:
        print(f"  UNRESOLVED: {conf}")
        results.append({
            'label': t['label'],
            'alias': t['alias'],
            'thunk_foff': foff_thunk,
            'raw': raw.hex(),
            'parsed': parsed,
            'target_foff': None,
        })
    print()
