#!/usr/bin/env python3
"""screen_census.py — the port against the REAL game, not against itself.

Every other gate here proves C == JS: sim_compare, the five input_compare
scenarios, all seven render_*_compare tools. Each diffs one half of the port
against the other. **A mistake both engines share is invisible to all of them**,
and that limit has been stated in the ledger for months without being closed.

This closes it. It drives the original under DOSBox, captures the emulated
320x200 framebuffer, renders the port's own version of the same screen from the
SAME save, and diffs them.

The foundation is that both sides can be put in one state: `COLONY00.SAV` is
byte-identical to the `sav1653` fixture (27,909 bytes, digest 3348C0DC), so DOS
slot 0 and the port's oracle fixture are the same game.

Two passes, because one is slow and one is not:

    python3 tools/screen_census.py --capture   # boot DOSBox, grab every screen
    python3 tools/screen_census.py             # diff + report (seconds)

WHAT A NUMBER HERE MEANS, and what it does not:

  * It is a PIXEL count over the 320x200 game area. It says how much differs,
    never why. Every row is triaged by hand into port-bug / declared-divergence
    / capture-artefact; an untriaged row is an open question, not a pass.
  * The port renders 320x240 (the extra 40 rows are the board's chrome band,
    which has no DOS counterpart). Only the top 200 rows are compared.
  * DOSBox is an emulator. Palette cycling and per-frame timing are live, so a
    screen that animates cannot be compared frame-exact -- those are declared,
    not fudged into passing.
  * A screen this cannot reach (state the fixture saves do not contain -- an
    active siege, a war in progress) is absent from the registry rather than
    guessed at. CLAUDE.md prime directive.
"""
from __future__ import annotations

import argparse
import json
import subprocess
import sys
from pathlib import Path

import numpy as np
from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
HARNESS = ROOT / "tools" / "dosbox_harness"
# Captures live under the census's own committed baseline, not in the
# harness's scratch shots/ dir -- that one is gitignored and a census whose
# reference frames vanish on a fresh clone is not a gate.
SHOTS = ROOT / "docs" / "screens" / "census" / "baseline"
OUT = ROOT / "docs" / "screens" / "census"
PAK = ROOT / "cport" / "pak" / "COLOPY.PAK"
SMOKE = ROOT / "cport" / "host" / "smoke"

# The save both sides load. COLONY00.SAV == the sav1653 fixture, verified by
# size (27,909) and digest (3348C0DC) -- see the module docstring.
DOS_SLOT = 0
FIXTURE = "sav1653"

# id -> (F-key, port render args, declared divergence or None)
REPORTS = {
    "F2": ("F2", ["--renderreport", FIXTURE, str(PAK), "{out}", "F2"], None),
    "F3": ("F3", ["--renderreport", FIXTURE, str(PAK), "{out}", "F3"],
           "Founding Father portraits: the 25 CC-00..CC-24 sheets are not in "
           "the pack (Part E), so the port lists names as text where the "
           "original draws faces."),
    "F5": ("F5", ["--renderreport", FIXTURE, str(PAK), "{out}", "F5"], None),
    "F7": ("F7", ["--renderreport", FIXTURE, str(PAK), "{out}", "F7"], None),
    "F9": ("F9", ["--renderreport", FIXTURE, str(PAK), "{out}", "F9"], None),
}


def read_ppm(path: Path) -> np.ndarray:
    d = path.read_bytes()
    parts = d.split(b"\n", 3)
    w, h = map(int, parts[1].split())
    return np.frombuffer(parts[3][: w * h * 3], dtype=np.uint8).reshape(h, w, 3)


def capture() -> None:
    """Drive DOSBox once and file one PNG per registry entry.

    Each screen is entered from a KNOWN map state, not from wherever the last
    one left off. The first attempt at this chained F2,Esc,F3,Esc,... and two
    of the five captures came back showing the map -- 30% ocean blue -- because
    an Escape had not landed. A capture that silently grabs the wrong screen
    reports as a 100% divergence, which reads exactly like a catastrophic port
    bug. Re-enter from the map every time.
    """
    sys.path.insert(0, str(HARNESS))
    subprocess.run(["./boot.sh", "VICEROY -g"], cwd=HARNESS, check=True,
                   env={"WAIT": "18", "PATH": "/usr/bin:/bin"},
                   stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    import drive                                            # noqa: E402

    drive.key("Down", times=3, delay=0.5)                   # LOAD Game
    drive.key("Return", delay=2.0)
    drive.key("Return", delay=2.5)                          # slot DOS_SLOT
    drive.key("Return", delay=3.0)
    print("loaded DOS slot %d" % DOS_SLOT)

    for sid, (fkey, _args, _div) in REPORTS.items():
        drive.key("Escape", delay=0.8)                      # back to a known map
        drive.key("Escape", delay=0.8)
        drive.key(fkey, delay=2.5)
        p = drive.shot("census_%s" % sid)
        if p:
            SHOTS.mkdir(parents=True, exist_ok=True)
            import shutil
            p = shutil.move(str(p), SHOTS / ("census_%s.png" % sid))
        print("  captured %-4s -> %s" % (sid, p))
        drive.key("Escape", delay=1.2)


def diff_one(sid: str) -> dict:
    dos_png = SHOTS / ("census_%s.png" % sid)
    if not dos_png.exists():
        return {"id": sid, "error": "no capture (run --capture)"}
    fkey, args, div = REPORTS[sid]
    out = Path("/tmp/census_port_%s.ppm" % sid)
    cmd = [str(SMOKE)] + [a.replace("{out}", str(out)) for a in args]
    r = subprocess.run(cmd, cwd=ROOT, capture_output=True)
    if r.returncode != 0 or not out.exists():
        return {"id": sid, "error": "port render failed"}

    dos = np.array(Image.open(dos_png).convert("RGB"))
    port = read_ppm(out)[:200]                              # drop the chrome band
    if dos.shape != port.shape:
        return {"id": sid, "error": "shape %s vs %s" % (dos.shape, port.shape)}

    mask = (dos != port).any(axis=2)
    rows = np.where(mask.any(axis=1))[0]
    OUT.mkdir(parents=True, exist_ok=True)
    side = Image.new("RGB", (320 * 3 + 8, 200), (24, 24, 24))
    side.paste(Image.fromarray(dos), (0, 0))
    side.paste(Image.fromarray(port), (324, 0))
    side.paste(Image.fromarray((mask[:, :, None] * np.array([255, 0, 0], np.uint8))
                               .astype(np.uint8)), (648, 0))
    side.save(OUT / ("%s.png" % sid))
    return {"id": sid, "px": int(mask.sum()), "pct": round(100 * mask.sum() / mask.size, 2),
            "rows": [int(rows.min()), int(rows.max())] if len(rows) else None,
            "declared": div}


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--capture", action="store_true",
                    help="boot DOSBox and re-grab every screen (slow)")
    ap.add_argument("--json", action="store_true")
    args = ap.parse_args()

    if args.capture:
        capture()
        return 0

    rows = [diff_one(s) for s in REPORTS]
    if args.json:
        print(json.dumps(rows, indent=1))
        return 0

    print("DOS vs port, 320x200 game area, save %s (= DOS slot %d)\n"
          % (FIXTURE, DOS_SLOT))
    for r in rows:
        if "error" in r:
            print("  %-4s ERROR %s" % (r["id"], r["error"]))
            continue
        tag = "  [declared]" if r["declared"] else ""
        print("  %-4s %6d px  %5.1f%%  rows %s%s"
              % (r["id"], r["px"], r["pct"], r["rows"], tag))
        if r["declared"]:
            print("        %s" % r["declared"])
    print("\nside-by-side (DOS | port | delta): %s" % OUT)
    print("A percentage is a measurement, not a verdict -- every row needs a "
          "cause before it means anything.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
