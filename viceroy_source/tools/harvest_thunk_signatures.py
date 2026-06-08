#!/usr/bin/env python3
"""
harvest_thunk_signatures.py -- consolidate the overlay-thunk signature layer.

VICEROY's cross-segment calls go through RTLink overlay thunks
(`lcall 0x181F:OFF`, `0x191F:OFF`, `0x1A1F:OFF`, `0x0D1D:OFF` for the C runtime).
Over the project, most of these have been IDENTIFIED -- given a real C name and
signature -- but the declarations are scattered as `extern` lines across dozens
of decompiled subsystem files, and a parallel set of placeholder
`overlay_call_SEG_OFF(void)` stubs lives in include/overlay_externs.h.

This tool harvests every thunk-citing `extern` declaration, prefers the REAL
named signature over the `overlay_call_*` placeholder, joins it with the
resolution data (lcall_resolution_VICEROY.json: thunk -> overlay file offset),
and ranks by how often the thunk is actually called. The output is the canonical
reference for porting the ~174 overlay-dependent load_image functions FAITHFULLY
(calling the real function instead of a void stub).

Usage:  python3 viceroy_source/tools/harvest_thunk_signatures.py [--json out.json]
        (run from repo root)
"""
import json, glob, re, collections, sys, os

ROOT_SRC = 'viceroy_source/src'
ROOT_INC = 'viceroy_source/include'
RESJSON  = 'viceroy_source/lcall_resolution_VICEROY.json'
DISASM   = 're_work/disasm'

def thunk_key(seg, off):
    return f"0x{seg:04X}:0x{off:04X}"

def call_frequency():
    freq = collections.Counter()
    rx = re.compile(r'lcall 0x([0-9a-f]+), 0x([0-9a-f]+)')
    for f in glob.glob(os.path.join(DISASM, '*.asm')):
        for m in rx.finditer(open(f, errors='ignore').read()):
            freq[thunk_key(int(m.group(1), 16), int(m.group(2), 16))] += 1
    return freq

def harvest_signatures():
    """thunk_key -> {sig, name, file} preferring real names over placeholders."""
    sigs = {}
    decl = re.compile(
        r'extern\s+([A-Za-z_][\w \*]*?\b(\w+)\s*\([^;{]*\))\s*;'
        r'\s*/\*[^\n]*?0x([0-9A-Fa-f]{3,4})\s*:\s*0x([0-9A-Fa-f]{2,4})')
    for f in glob.glob(os.path.join(ROOT_SRC, '**/*.c'), recursive=True) + \
             glob.glob(os.path.join(ROOT_INC, '*.h')):
        txt = open(f, errors='ignore').read()
        for m in decl.finditer(txt):
            sig, name = m.group(1).strip(), m.group(2)
            key = thunk_key(int(m.group(3), 16), int(m.group(4), 16))
            placeholder = name.startswith('overlay_call_')
            cur = sigs.get(key)
            # prefer a real name; otherwise keep first
            if cur is None or (cur['placeholder'] and not placeholder):
                sigs[key] = {'sig': sig, 'name': name,
                             'file': os.path.relpath(f), 'placeholder': placeholder}
    return sigs

def main():
    freq = call_frequency()
    sigs = harvest_signatures()
    res = json.load(open(RESJSON)).get('by_lcall_target', {})
    # normalize resolution keys to 0xSEG:0xOFF upper
    resmap = {}
    for k, v in res.items():
        m = re.match(r'0x([0-9A-Fa-f]+):0x([0-9A-Fa-f]+)', k)
        if m:
            resmap[thunk_key(int(m.group(1), 16), int(m.group(2), 16))] = v.get('overlay_file_offset')

    allkeys = set(freq) | set(sigs)
    named = sum(1 for k in allkeys if k in sigs and not sigs[k]['placeholder'])
    placeholder = sum(1 for k in allkeys if k in sigs and sigs[k]['placeholder'])
    unresolved = sum(1 for k in allkeys if k not in sigs)
    print(f"Distinct thunks seen:        {len(allkeys)}")
    print(f"  real named signature:      {named}")
    print(f"  placeholder only:          {placeholder}")
    print(f"  no declaration at all:     {unresolved}")

    print("\n=== Top 30 by call frequency (faithful-port targets) ===")
    print("calls  thunk          overlay@         name")
    for key, c in freq.most_common(30):
        s = sigs.get(key)
        of = resmap.get(key)
        ofs = f"0x{of:06X}" if isinstance(of, int) else "?"
        nm = (s['name'] if s and not s['placeholder']
              else ("(placeholder)" if s else "-- UNRESOLVED --"))
        print(f"{c:4d}   {key:14s} {ofs:>10s}    {nm}")

    if '--json' in sys.argv:
        out = sys.argv[sys.argv.index('--json')+1]
        payload = {k: {'calls': freq.get(k, 0),
                       'overlay_file_offset': resmap.get(k),
                       **({'name': sigs[k]['name'], 'sig': sigs[k]['sig'],
                           'file': sigs[k]['file'],
                           'placeholder': sigs[k]['placeholder']} if k in sigs else {})}
                   for k in sorted(allkeys)}
        json.dump(payload, open(out, 'w'), indent=1)
        print(f"\nWrote {out}  ({len(payload)} thunks)")

if __name__ == '__main__':
    main()
