#!/usr/bin/env python3
"""Extract Microsoft CodeView NB02 debug info from a DOS EXE (MAPEDIT.EXE).

Reproducible source of data_extracted/mapedit_symbols.json (the original
2026-07-30 parse was ad-hoc and never committed - this replaces it).

Layout (verified against MAPEDIT.EXE):
  * The EXE TAIL carries an 8-byte trailer: "NB02" + u32 lfaBase, where
    lfaBase counts BACK from the end of the trailer to the debug base.
    (MAPEDIT: end 0x2378C - 0x7983 = base 0x1BE09. The "second NB02
    signature" at 0x23784 is this trailer, not a second symbol table.)
  * At base: "NB02" + u32 lfoSubsectionDir (from base).
  * Subsection directory: u16 cDir, then cDir 10-byte entries
    {u16 sst, u16 iMod, u32 lfo, u16 cb} with lfo from base.
  * sst 0x101 sstModule (cb bytes):
    {u16 seg, u16 off, u16 cbCode, u16 pad, u16 ovl, u16 style,
     u8 nameLen, name} - ONE contiguous code range per module.
  * sst 0x102 sstPublics: stream of {u16 off, u16 seg, u16 typind,
    u8 nameLen, name}.

file_offset = seg*16 + off + header_size (MAPEDIT header = 0x1600).
"""
import json
import struct
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def parse(exe_path, header_size):
    d = Path(exe_path).read_bytes()
    sig, lfa_back = struct.unpack_from('<4sI', d, len(d) - 8)
    if sig != b'NB02':
        raise SystemExit(f'{exe_path}: no NB02 trailer')
    base = len(d) - lfa_back
    if d[base:base + 4] != b'NB02':
        raise SystemExit(f'{exe_path}: trailer points to non-NB02 base {base:#x}')
    dir_off = base + struct.unpack_from('<I', d, base + 4)[0]
    n = struct.unpack_from('<H', d, dir_off)[0]
    modules, publics = [], []
    mod_names = {}
    o = dir_off + 2
    for _ in range(n):
        sst, imod, lfo, cb = struct.unpack_from('<HHIH', d, o)
        o += 10
        p = base + lfo
        if sst == 0x101:                              # sstModule
            seg, off, cbcode = struct.unpack_from('<HHH', d, p)
            nl = d[p + 12]
            name = d[p + 13:p + 13 + nl].decode('ascii', 'replace')
            mod_names[imod] = name
            modules.append({
                'iMod': imod, 'name': name, 'seg': seg, 'off': off,
                'size': cbcode,
                'file_offset': f'0x{seg * 16 + off + header_size:06X}',
            })
        elif sst == 0x102:                            # sstPublics
            end = p + cb
            while p < end:
                off, seg, _ti = struct.unpack_from('<HHH', d, p)
                nl = d[p + 6]
                name = d[p + 7:p + 7 + nl].decode('ascii', 'replace')
                p += 7 + nl
                publics.append({
                    'name': name, 'seg': seg, 'off': off,
                    'file_offset': f'0x{seg * 16 + off + header_size:06X}',
                    'module': mod_names.get(imod, f'iMod{imod}'),
                })
    return base, modules, publics


def main():
    exe = ROOT / 'raw/COLONIZE/MAPEDIT.EXE'
    header_size = 0x1600
    base, modules, publics = parse(exe, header_size)
    out = {
        'source': f'MAPEDIT.EXE CodeView NB02 publics at file 0x{base:X}',
        'note': f'file_offset = seg*16 + off + 0x{header_size:X} (header size)',
        'generator': 'tools/extract_codeview.py',
        'modules': modules,
        'symbols': publics,
    }
    dst = ROOT / 'data_extracted/mapedit_symbols.json'
    dst.write_text(json.dumps(out, indent=1))
    print(f'{len(modules)} modules, {len(publics)} publics -> {dst}')


if __name__ == '__main__':
    sys.exit(main())
