#!/usr/bin/env python3
"""
strings_scan.py — extract printable strings from VICEROY.EXE with file offsets,
and (optionally) find the code sites that PUSH each string's offset (xref).

The game's text lives in the DGROUP data segment as NUL-terminated ASCII. Game
code references a string by PUSHing its load-module-relative offset (imm16) just
before an LCALL to a message/format helper. So an xref = a `68 <lo> <hi>`
(PUSH imm16) whose imm16 equals the string's DGROUP offset.

Outputs re_work/strings.json:
  [{foff, off (dgroup-relative), seg, text, len, xrefs:[foff,...]}...]
"""
import json
import os
import re
import sys

from viceroy_exe import EXE, _REPO

OUT = os.path.join(_REPO, "re_work", "strings.json")

# DGROUP data segment in the load image. The resident data lives roughly in
# file 0x10000..0x20000 (load-module-relative seg ~0xDC00.. up). We record both
# the file offset and the offset relative to the DGROUP base so PUSH-imm xref
# matching works regardless of which segment register addresses it.


def scan_strings(exe, minlen=4):
    d = exe.data
    out = []
    i = 0
    n = len(d)
    while i < n:
        b = d[i]
        if 0x20 <= b < 0x7f:
            j = i
            while j < n and 0x20 <= d[j] < 0x7f:
                j += 1
            if j < n and d[j] == 0 and (j - i) >= minlen:
                out.append((i, d[i:j].decode("ascii")))
                i = j + 1
                continue
        i += 1
    return out


def build_imm_index(exe):
    """Index every `68 lo hi` (PUSH imm16) site -> imm value, and also the
    raw imm16 immediates in mov/cmp via a coarse scan. Returns dict imm->[foff]."""
    d = exe.data
    idx = {}
    # Only scan the code/overlay region (skip the data segment itself to cut noise).
    # Resident code: load_base..image_len ; overlays: image_len..end.
    for start, end in [(exe.load_base, exe.image_len), (exe.image_len, len(d))]:
        i = start
        while i < end - 2:
            if d[i] == 0x68:  # PUSH imm16
                imm = d[i + 1] | (d[i + 2] << 8)
                idx.setdefault(imm, []).append(i)
            i += 1
    return idx


def main(argv):
    exe = EXE()
    strings = scan_strings(exe, minlen=int(argv[1]) if len(argv) > 1 else 4)
    print(f"found {len(strings)} strings (len>=4)")

    # DGROUP base guess: most game strings are addressed as offsets within the
    # data segment. We compute dgroup-relative offset by assuming the data
    # segment file-base; but for xref matching we try the raw 16-bit low word of
    # the file offset minus the load image data base. Empirically the message
    # keys satisfy foff = dgroup_off + 0x1D9A0 (seg 0x1b5a). We expose both.
    DG = 0x1D9A0  # file offset of dgroup-string area base (seg 0x1b5a:0)
    imm_idx = build_imm_index(exe)

    records = []
    for foff, text in strings:
        dg_off = foff - DG
        xrefs = []
        if 0 <= dg_off <= 0xFFFF:
            xrefs = imm_idx.get(dg_off, [])
        records.append({
            "foff": foff,
            "dg_off": dg_off if 0 <= dg_off <= 0xFFFF else None,
            "text": text,
            "len": len(text),
            "xrefs": xrefs[:32],
            "nxref": len(xrefs),
        })

    with open(OUT, "w") as f:
        json.dump(records, f)
    print(f"wrote {OUT}")

    # quick confidence check: locate some known keys
    by_text = {}
    for r in records:
        by_text.setdefault(r["text"], r)
    for key in ["VICEROY.EXE", "AMERICA.MOV", "HALLFAME.DAT", "SMITEINDIANS",
                "KINGTAX", "BURNED", "TEAPARTY", "SHIPCOMBAT", "REBELMAJORITY",
                "COLONIZE", "SAVEGAME"]:
        r = by_text.get(key)
        if r:
            print(f"  {key:16} foff=0x{r['foff']:06x} dg_off="
                  f"{('0x%04x' % r['dg_off']) if r['dg_off'] is not None else '-':>7}"
                  f" xrefs={r['nxref']}")
        else:
            # substring search
            hits = [r2 for r2 in records if key in r2["text"]]
            if hits:
                print(f"  {key:16} (substring) e.g. {hits[0]['text']!r} @0x{hits[0]['foff']:06x}")
            else:
                print(f"  {key:16} NOT FOUND")


if __name__ == "__main__":
    main(sys.argv)
