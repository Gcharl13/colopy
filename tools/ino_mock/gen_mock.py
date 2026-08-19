#!/usr/bin/env python3
"""gen_mock.py — reproduce the Arduino IDE's prototype hoist, then compile.

The .ino is the one file in this project no oracle covers and no host build
compiles.  This gate stands in for the IDE: it rewrites the generated sketch
the way arduino-cli's preprocessor does, and hands the result to g++ against
the stub headers beside this file.

TWO THINGS THIS GOT WRONG, both found by a real IDE build on 2026-08-19 that
this gate had passed:

1. **The insertion point is the FIRST FUNCTION DEFINITION, not the last
   #include.**  arduino-cli inserts the generated prototype block immediately
   above the first function it finds, with a `#line` directive pointing back
   at the original — which is why the error is reported at the definition's
   line even though the prototype is what failed.  Hoisting to just after the
   last #include put every prototype BELOW the sketch's own includes, so a
   prototype naming a type from a later include compiled fine here and failed
   on hardware.

2. **Indentation does not hide a definition from the generator.**  The old
   belief was that only column-0 return types are picked up; the sketch relied
   on it, indenting `bt_notify_cb` by one space to keep a BLE type out of the
   hoisted block.  The current toolchain hoisted it regardless and the build
   died with "variable or field 'bt_notify_cb' declared void".  Leading
   whitespace is now matched.

The residual honest limit: this is a regex, not ctags.  It can miss a
definition ctags would find (a macro-wrapped return type, a K&R signature) or
invent one ctags would skip.  It cannot see the real BLE/Panel libraries at
all — the headers here are stubs with the signatures the sketch uses.  A
green run means "the hoist hazard and the syntax are clean", not "this links".
"""
from __future__ import annotations

import re
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
SKETCH = ROOT / "cport" / "arduino_p4" / "colopy_p4" / "colopy_p4.ino"
OUT = HERE / "sketch_test.cpp"

# A function DEFINITION: optional leading whitespace (see note 2), an optional
# `static`, a return type, a name, a parenthesised list with no `;` or braces
# in it, then an opening brace.  DOTALL so a signature may wrap lines.
DEF = re.compile(
    r"^[ \t]*((?:static\s+)?[A-Za-z_][A-Za-z0-9_ *]*?\**[A-Za-z_][A-Za-z0-9_]*"
    r"\([^;{}]*?\))\s*\{",
    re.M | re.S)

NOT_A_FUNCTION = {"if", "for", "while", "switch", "do", "else", "return",
                  "catch"}


def main() -> int:
    src = SKETCH.read_text()
    lines = src.split("\n")

    protos, first_line = [], None
    for m in DEF.finditer(src):
        sig = " ".join(m.group(1).split())
        name = re.search(r"([A-Za-z_][A-Za-z0-9_]*)\s*\(", sig).group(1)
        if name in NOT_A_FUNCTION:
            continue
        if first_line is None:
            first_line = src[:m.start()].count("\n")
        protos.append(sig + ";")

    if first_line is None:
        print("no function definitions found — the regex is wrong",
              file=sys.stderr)
        return 2

    # Insert ABOVE the first definition, which is where arduino-cli puts it.
    out = lines[:first_line] + protos + lines[first_line:]
    OUT.write_text("\n".join(out))
    print("%d prototypes hoisted above line %d (%s)"
          % (len(protos), first_line + 1, lines[first_line].strip()[:48]))
    return 0


if __name__ == "__main__":
    sys.exit(main())
