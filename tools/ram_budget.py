#!/usr/bin/env python3
"""RAM budget gate for the board sketches (2026-09-03).

WHY THIS EXISTS.  The ESP32-P4 has 320 KB of internal DRAM and the sketch's
globals were already near it (`cport/MEMORY_BUDGET.md`).  On 2026-09-03 a
real IDE build came back

    Global variables use 335996 bytes (102%) of dynamic memory,
    leaving -8316 bytes for local variables.  Maximum is 327680 bytes.
    data section exceeds available space in board

after a campaign that had added statics across the core -- and nothing in
`make test` had noticed, because the mock-compile gate is `-fsyntax-only`
and never produces an object to measure.  The cause was three separate
`static pedia_row rows[PEDIA_MAX]` scratch buffers in
`cport/render/colopy_boot_render.c` (11,200 B each on the host, 10,400 B
each on a 32-bit board); they now share one.

WHAT THIS MEASURES.  The writable footprint (.data + .bss) of the object
set the SKETCHES compile -- core, render, game, audio, data -- as built by
`cport/host`.  It is a PROXY, not the board's own number:

  * host objects are 64-bit, so every pointer inside a struct counts 8 B
    where the board counts 4 -- the proxy OVERSTATES pointer-heavy state,
    which is the safe direction for a ceiling;
  * the board total additionally carries the `.ino`'s own statics and the
    Arduino core's, which are not in this set and do not change here.

So the ceiling below is a REGRESSION gate on the shared core, which is
where every recent growth came from -- not a prediction of the board
figure.  When a change legitimately needs more, raise CEILING in the same
commit and say why, exactly as the render ceilings work.

Exits nonzero when the total exceeds the ceiling.
"""

import glob
import os
import subprocess
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DIRS = ("cport/core", "cport/render", "cport/game", "cport/audio", "cport/data")

# Frozen 2026-09-03 at 229,576 B measured, with ~1 KB of slack for
# incidental growth.  Raise deliberately, never to make a red gate green.
CEILING = 230_600


def main() -> int:
    objs = []
    for d in DIRS:
        objs += sorted(glob.glob(os.path.join(ROOT, d, "*.o")))
    if not objs:
        print("ram_budget: no objects -- run `cd cport/host && make` first",
              file=sys.stderr)
        return 1

    data = bss = relro = 0
    worst = []
    for o in objs:
        out = subprocess.run(["size", "-A", o], capture_output=True,
                             text=True).stdout
        d = b = 0
        for line in out.splitlines():
            p = line.split()
            if len(p) >= 2:
                if p[0] == ".data":
                    d += int(p[1])
                elif p[0] == ".bss":
                    b += int(p[1])
                elif p[0].startswith(".data.rel.ro"):
                    # .data.rel.ro / .data.rel.ro.local: const pointer tables that
                    # need relocation under the host's PIE build. The board
                    # has no PIE and maps flash directly, so these stay in
                    # flash there -- reported, never charged.
                    relro += int(p[1])
        data += d
        bss += b
        if d + b:
            worst.append((d + b, os.path.relpath(o, ROOT)))

    total = data + bss
    worst.sort(reverse=True)
    print("ram_budget: .data %d + .bss %d = %d B "
          "(ceiling %d, %d objects)" % (data, bss, total, CEILING, len(objs)))
    print("            largest: " +
          ", ".join("%s %d" % (n, s) for s, n in worst[:4]))
    if relro:
        # Read-only after relocation: flash-resident on the board, so it is
        # reported but NOT charged against the ceiling.
        print("            (.data.rel.ro %d B -- flash-resident, not charged)"
              % relro)
    if total > CEILING:
        print("RAM BUDGET EXCEEDED: %d > %d. The board has 320 KB of internal "
              "DRAM and the sketch's globals sit near it -- a static added "
              "here can make the IDE build fail with 'data section exceeds "
              "available space in board'. Move the buffer to PSRAM (the heap), "
              "share it, or raise CEILING in this file with a reason."
              % (total, CEILING), file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
