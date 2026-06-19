#!/usr/bin/env python3
"""Strip ALL C comments from ghidra_export/VICEROY_decompiled.c -> a code-only file.
State machine respects string/char literals so code is never damaged. Runs of
blank lines (left where comments were) are collapsed.

Output: ghidra_export/VICEROY_decompiled.nocomments.c
"""
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
src = (ROOT / "ghidra_export/VICEROY_decompiled.c").read_text()

out = []
i, n = 0, len(src)
NORMAL, LINE, BLOCK, STR, CHAR = range(5)
st = NORMAL
while i < n:
    c = src[i]
    nx = src[i + 1] if i + 1 < n else ""
    if st == NORMAL:
        if c == "/" and nx == "/":
            st = LINE; i += 2; continue
        if c == "/" and nx == "*":
            st = BLOCK; i += 2; continue
        if c == '"':
            st = STR; out.append(c); i += 1; continue
        if c == "'":
            st = CHAR; out.append(c); i += 1; continue
        out.append(c); i += 1; continue
    if st == LINE:
        if c == "\n":
            st = NORMAL; out.append(c)
        i += 1; continue
    if st == BLOCK:
        if c == "*" and nx == "/":
            st = NORMAL; i += 2; continue
        if c == "\n":
            out.append("\n")          # keep line count sane
        i += 1; continue
    if st == STR:
        out.append(c)
        if c == "\\" and nx:
            out.append(nx); i += 2; continue
        if c == '"':
            st = NORMAL
        i += 1; continue
    if st == CHAR:
        out.append(c)
        if c == "\\" and nx:
            out.append(nx); i += 2; continue
        if c == "'":
            st = NORMAL
        i += 1; continue

text = "".join(out)

# trim trailing whitespace per line, collapse 2+ blank lines to one
lines = [ln.rstrip() for ln in text.split("\n")]
clean, blank = [], False
for ln in lines:
    if ln == "":
        if not blank:
            clean.append("")
        blank = True
    else:
        clean.append(ln); blank = False

outp = ROOT / "ghidra_export/VICEROY_decompiled.nocomments.c"
outp.write_text("\n".join(clean) + "\n")
print(f"wrote {outp.relative_to(ROOT)}  ({outp.stat().st_size//1024} KB, "
      f"{len(clean)} lines, was {len(src.splitlines())} lines)")
