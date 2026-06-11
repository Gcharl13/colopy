#!/usr/bin/env python3
"""
whois.py -- one-shot identity query for any address form.

Replaces the manual loop (resolve thunk bytes, find containing function,
grep src/ for the port, read its signature) with one command.

Accepts, in any mix:
  SEG:OFF        thunk reference        e.g. 0x181F:0xC7C  181f:c7c
  0xFOFF         raw file offset        e.g. 0x08734
  func_XXXXXX    function name stem

Output per query: resolution chain, containing function, disasm file,
port status (definition / extern-only / unported) with file:line + signature.

Usage:
  python3 viceroy_source/tools/whois.py 0x181F:0xC7C 0x191F:0xA14 func_05CA7E
  python3 viceroy_source/tools/whois.py --rebuild-index 0x181F:0x316
"""
import os
import re
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from portlib import EXE_PATH, PortIndex, Spans, resolve_thunk

THUNK_RX = re.compile(r"^(?:0x)?([0-9A-Fa-f]{3,4}):(?:0x)?([0-9A-Fa-f]{1,4})$")
FOFF_RX = re.compile(r"^0x([0-9A-Fa-f]{4,6})$")
NAME_RX = re.compile(r"^func_([0-9A-Fa-f]{4,6})\w*$")


def describe(foff, spans, ports, prefix=""):
    span = spans.at(foff)
    if not span:
        print(f"{prefix}file 0x{foff:05X}: NOT inside any known function span")
        return
    start, end = span
    stem = spans.name(start)
    inside = "" if foff == start else f" (+0x{foff - start:X} into it)"
    print(f"{prefix}file 0x{foff:05X} -> {stem} [0x{start:05X}..0x{end:05X}]{inside}")
    print(f"{prefix}  disasm: re_work/disasm/{stem}.asm")
    rec = ports.lookup(start)
    if rec["definitions"]:
        for d in rec["definitions"]:
            print(f"{prefix}  PORTED: {d['name']}  @ {d['file']}:{d['line']}")
            if "sig" in d:
                print(f"{prefix}          {d['sig']}")
    elif rec["externs"]:
        seen = set()
        for e in rec["externs"][:4]:
            key = e.get("sig", e["name"])
            if key in seen:
                continue
            seen.add(key)
            print(f"{prefix}  EXTERN-ONLY: {e['name']}  @ {e['file']}:{e['line']}")
            if "sig" in e:
                print(f"{prefix}          {e['sig']}")
        print(f"{prefix}  (no definition in src/ -- body NOT ported)")
    else:
        print(f"{prefix}  UNPORTED: no reference to {stem} anywhere in src/")


def main(argv):
    rebuild = "--rebuild-index" in argv
    queries = [a for a in argv if not a.startswith("--")]
    if not queries:
        print(__doc__)
        return 1
    spans = Spans()
    ports = PortIndex(rebuild=rebuild)
    exe = open(EXE_PATH, "rb").read() if os.path.exists(EXE_PATH) else None

    for q in queries:
        print(f"== {q}")
        m = THUNK_RX.match(q)
        if m:
            seg, off = int(m.group(1), 16), int(m.group(2), 16)
            if exe is None:
                print("  (no re_work/VICEROY.EXE -- cannot resolve thunk)")
                continue
            kind, target, detail = resolve_thunk(seg, off, exe)
            print(f"  thunk 0x{seg:04X}:0x{off:04X} -> [{kind}] {detail}")
            if target is not None:
                describe(target, spans, ports, prefix="  ")
            continue
        m = NAME_RX.match(q)
        if m:
            describe(int(m.group(1), 16), spans, ports, prefix="  ")
            continue
        m = FOFF_RX.match(q)
        if m:
            describe(int(m.group(1), 16), spans, ports, prefix="  ")
            continue
        print(f"  unrecognized query form: {q}")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
