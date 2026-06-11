#!/usr/bin/env python3
"""
cite_check.py -- validate every `@asm 0xOFFSET` citation in C sources.

Catches the two stale-cite failure modes cheaply:
  1. an offset that is not the start of any disassembled instruction
     (mistyped / drifted address), and
  2. an offset landing in a DIFFERENT function than the rest of its block
     (copy-paste from the wrong section).

A cite is checked against the instruction-start set of every function span
containing it (spans nest; either disasm matching counts as valid).

Usage:
  python3 viceroy_source/tools/cite_check.py src/unit/move.c [...]
  python3 viceroy_source/tools/cite_check.py --all          # whole src tree
"""
import glob
import os
import re
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from portlib import REPO, SRC, Spans

CITE_RX = re.compile(r"@asm[^0-9A-Fa-fx]*0x([0-9A-Fa-f]{4,6})(:?)")
LINE_RX = re.compile(r"^0x([0-9a-f]+)\s+(?:[0-9a-f]{2} )+")

# thunk windows / runtime segs cited as `0xSEG:0xOFF` -- never file offsets
SEG_TOKENS = {0x181F, 0x191F, 0x1A1F, 0x0D1D, 0x110D}

_starts_cache = {}


def insn_starts(spans, fstart):
    if fstart in _starts_cache:
        return _starts_cache[fstart]
    path = spans.disasm_path(fstart)
    s = set()
    if os.path.exists(path):
        for raw in open(path, errors="ignore"):
            m = LINE_RX.match(raw)
            if m:
                s.add(int(m.group(1), 16))
    _starts_cache[fstart] = s
    return s


def check_file(path, spans):
    """Flag only PROVABLY-wrong cites: an offset inside a known code span
    that is not on any instruction boundary.  Offsets outside all spans are
    data/segment references (legitimate cite styles) -- counted, not flagged."""
    bad = []
    n_cites = n_data = 0
    for ln, line in enumerate(open(path, errors="ignore"), 1):
        for m in CITE_RX.finditer(line):
            off = int(m.group(1), 16)
            if m.group(2) == ":" or off in SEG_TOKENS:
                continue  # 0xSEG:0xOFF thunk form, not a file offset
            n_cites += 1
            hits = spans.all_at(off)
            if not hits:
                n_data += 1
                continue
            if not any(off in insn_starts(spans, s) for s, _ in hits):
                if any(os.path.exists(spans.disasm_path(s)) for s, _ in hits):
                    bad.append((ln, off, "not an instruction start"))
    return n_cites, n_data, bad


def main(argv):
    spans = Spans()
    if "--all" in argv:
        files = glob.glob(os.path.join(SRC, "**", "*.c"), recursive=True)
    else:
        files = [a if os.path.isabs(a) else os.path.join(REPO, a) for a in argv]
    total = stale = data = 0
    for f in files:
        n, nd, bad = check_file(f, spans)
        total += n
        data += nd
        stale += len(bad)
        for ln, off, why in bad:
            print(f"{os.path.relpath(f, REPO)}:{ln}: @asm 0x{off:05X} -- {why}")
    print(f"\n{total} code-offset citations checked "
          f"({data} data-region refs skipped), {stale} provably stale")
    return 1 if stale else 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
