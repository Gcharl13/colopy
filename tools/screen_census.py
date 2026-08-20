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
# NOT IN THE REGISTRY YET: the COLONY screen, and it is worth saying why.
# Two entry paths were tried and both filed a MAP frame instead:
#   VIEW > Find Colony > Return          -- Find Colony moves the SELECTION to
#                                           a colony and scrolls to show it; it
#                                           does not open the colony screen, and
#                                           a second Return does nothing.
#   ...then a click on the colony tile   -- the view Find Colony leaves behind
#                                           is not stable between runs (the
#                                           second attempt came back centred on
#                                           a different colony with a different
#                                           active unit), so a fixed click
#                                           coordinate lands on ocean.
# Both attempts were caught by LOOKING at the capture, which is the whole
# reason the docstring's "an untriaged row is an open question" rule exists --
# a map frame filed as a colony baseline would have reported ~100% divergence
# and read exactly like a catastrophic port bug. The next attempt needs a
# deterministic way in: either a keyboard path that opens a colony outright,
# or a plain MAP entry first (no navigation at all) whose frame can be read to
# place the click.

# id -> (DOS entry key, port render args, declared divergence or None)
# The DOS entry key is what `capture()` presses from a known map state. A
# screen reached by a menu carries its accel path instead (see capture()).
REPORTS = {
    "F2": ("F2", ["--renderreport", FIXTURE, str(PAK), "{out}", "F2"],
           "OPEN (0.7%): 454 px, of which 82 is the DOS mouse pointer. The "
           "rest is ONE element the port does not draw at all -- a black "
           "badge at (10,27)-(46,37) carrying the crosses figure and a cross "
           "glyph (the original reads \"30 +\" on this save). Same shape as "
           "the earlier misses: not a placement error, a missing element."),
    "F3": ("F3", ["--renderreport", FIXTURE, str(PAK), "{out}", "F3"],
           "Founding Father portraits: the 25 CC-00..CC-24 sheets are not in "
           "the pack (Part E), so the port lists names as text where the "
           "original draws faces."),
    "F5": ("F5", ["--renderreport", FIXTURE, str(PAK), "{out}", "F5"],
           "OPEN (0.3%), down from 0.6%. Half of it was C4.9, the bid/ask "
           "straddle: the report's price columns print market_bid/market_ask, "
           "and both quotes were one high. 398 -> 202 px. What is left is "
           "still at glyph scale rather than in blocks, so it reads as text "
           "metrics or remaining content, not a misplaced element. "
           "Untriaged."),
    "F7": ("F7", ["--renderreport", FIXTURE, str(PAK), "{out}", "F7"],
           "OPEN (1.7%), down from 2.5%. C4.1 is now IMPLEMENTED from the "
           "decode of the shared verb func_00386A (spec/ui/render_primitives "
           "§1b): the composite is sprite + a black-outlined PLATE in the "
           "owner colour + a status letter, and the plate's SIDE depends on "
           "the unit CLASS -- a Galleon or Frigate (class 1) wears it to the "
           "RIGHT of the hull, a Merchantman or Caravel (class 3) to the "
           "LEFT. The port drew a fixed 8x9 plate at a fixed x for every "
           "unit. 1,635 -> 1,100 px.\n"
           "        What is LEFT (1,100, of which 82 is the mouse pointer) "
           "is the model's two remaining approximations, both stated at the "
           "call site: the engine takes the sprite's w/h from two "
           "sheet-header fields (es:[bx+0x3E] / [bx+0x40]) that are not "
           "decoded, so the port substitutes its own trimmed frame size -- "
           "measurably the better of the two candidates, since a fixed cell "
           "width scores worse at every value tried (12..18) -- and the F7 "
           "caller's own x is untraced (the call @0x039574 passes "
           "bx = [bp-0x56] + 0x56), so the anchor 4 is FITTED: 2 gives "
           "1,529 px and 5 gives 1,996."),
    "EUROPE": ("EUROPE", ["--rendereurope", FIXTURE, str(PAK), "{out}", "0", "0", "-1", "0"],
           "OPEN (0.8%), down from 20.0%. Twelve fixes; the last four:\n"
           "         1,537 -> 1,030(band)  C4.24 the market cell CENTRE is "
           "19i + 10, not 9 -- `imul ax, [bp+6], 0x13; add ax, 0xa` "
           "@0x030ED4, with the icon row's y (0xB5) in the same frame "
           "@0x030ECF. Every one of the sixteen icons was a pixel left; that "
           "band 1,030 -> 59 px\n"
           "         C4.25 the crossing manifest: a professioned entry shows "
           "his PROFESSION figure (the port drew the generic Colonists sprite "
           "for all three), profession byte 0 is Expert Farmers rather than "
           "'none', and the manifest runs in CHAIN order (UnitRecord "
           "+0x1A from the ship: 56 -> 87 -> 86 -> 85), which is the REVERSE "
           "of record order here. The 2026-08-07 capture had already named "
           "the three as Expert Farmer / Master Distiller / Master Gunsmith, "
           "matched 1.0 -- professions 0, 9, 15 -- and the code never used "
           "it. Crossing band 406 -> 326 px\n"
           "        What is LEFT: 82 px of DOS mouse pointer and ~326 px in "
           "the crossing column. That column is now a CONTENT question, not a "
           "placement one: sweeping the ship anchor over 72..76 and the "
           "passenger pitch over 16..18 leaves (75, 17) -- what the port "
           "already has -- as the unique minimum, and the residual is the "
           "black PLATE the original draws behind every figure and ship. "
           "That plate is the per-unit info-panel verb 0x181F:0x2BC = "
           "func_00386A, which is also F7's blocker (C4.1). One decode "
           "closes both."),
    "F9": ("F9", ["--renderreport", FIXTURE, str(PAK), "{out}", "F9"],
           "OPEN (0.3%), down from 5.3%. Four fixes, each measured:\n"
           "         3,365 -> 1,506  C4.12 WHICH TRIBES get a row. The row "
           "loop tests the relation byte (@0x03784C, `test al, 0x20`) and "
           "falls back on TribeRecord +0x03 bit 0x80; the port listed a tribe "
           "when it had a village on an explored tile, which dropped the "
           "three EXTINCT tribes the original lists and agreed about the "
           "Iroquois only by accident (they own ELEVEN villages and are "
           "skipped because their relation byte is 0)\n"
           "         1,506 ->   375  C4.13 the labels carry a BLACK DROP "
           "SHADOW at exactly (+1,0), (0,+1), (+1,+1). Not a guess: the "
           "model reproduces the original's black pixels 134/134 and 88/88 "
           "on two rows with zero missing and zero extra, while the 4- and "
           "8-neighbour outlines over-predict by 48 and 83. The JS FONT class "
           "already had that exact offset list as its `shadow` argument -- F9 "
           "never passed it\n"
           "           375 ->   348  C4.14 the muskets cell: "
           "(TribeRecord +0x07 + one per Armed Brave / Mtd. Warrior) x 50 "
           "(@0x03766D-@0x0376B1), and the horse-herds cell: TribeRecord "
           "+0x08 verbatim (@0x0377D6). The port read both from a runtime "
           "stock map the import leaves empty, so neither ever drew\n"
           "           348 ->   220  C4.15 the sub-line grid is 40 + 56k "
           "(`add [bp-0x68], 0x38` x3), so horse herds sit at 208, not the "
           "209 the port had by eye\n"
           "        Rows 0, 1, 2 and 6 are now pixel-exact. What is LEFT: "
           "82 px of DOS mouse pointer (see `cursor`), ~126 px on the SIOUX "
           "row where the original inks the name and level in palette index "
           "12 (255,0,0) while @TRIBES gives that tribe 118 (146,0,0) -- "
           "every other tribe matches @TRIBES exactly, so this is one tribe, "
           "cause UNKNOWN and NOT guessed -- and ~10 px inside the Apache and "
           "Sioux portraits. Also NOT implemented: the MISSIONS cell at "
           "x = 96 (@0x037650), whose counting rule is byte-cited but whose "
           "singular/plural strings [0x2DF0]/[0x2DF2] are unresolved and "
           "which this fixture cannot exercise."),
}


def read_ppm(path: Path) -> np.ndarray:
    d = path.read_bytes()
    parts = d.split(b"\n", 3)
    w, h = map(int, parts[1].split())
    return np.frombuffer(parts[3][: w * h * 3], dtype=np.uint8).reshape(h, w, 3)


def capture(only: str | None = None) -> None:
    """Drive DOSBox once and file one PNG per registry entry.

    `only` re-grabs a SINGLE screen and leaves every other baseline frame
    untouched. That matters more than it looks: every "N -> M px" figure in
    the notes below is quoted against a specific baseline, so a blanket
    re-capture silently invalidates all of them (the emulated mouse pointer
    alone lands somewhere new). Add a screen with --capture-only, not by
    re-running the lot.

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
        if only and sid != only: continue
        drive.key("Escape", delay=0.8)                      # back to a known map
        drive.key("Escape", delay=0.8)
        if sid == "EUROPE":                    # VIEW > European Status
            drive.key("alt+v", delay=1.5)
            drive.key("E", delay=3.0)
        else:
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

    dos_img = Image.open(dos_png)
    dos = np.array(dos_img.convert("RGB"))
    port = read_ppm(out)[:200]                              # drop the chrome band
    if dos.shape != port.shape:
        return {"id": sid, "error": "shape %s vs %s" % (dos.shape, port.shape)}

    mask = (dos != port).any(axis=2)
    rows = np.where(mask.any(axis=1))[0]

    # Split the divergence by KIND, because "20% differs" is not one fact.
    #
    # The DOS capture is an indexed PNG, so its palette is the set of colours
    # the original could possibly have drawn on this screen. A port pixel whose
    # colour is NOT in that set cannot be a content difference -- the port drew
    # some index with the WRONG RGB, i.e. it is using a different palette. A
    # port pixel whose colour IS in the set but in the wrong place is a genuine
    # content difference.
    #
    # This is what separated the Europe screen's 20% into 61% palette + 39%
    # content, and showed the palette half is Europe-only: all five reports
    # come back 0% palette. Without the split, one number invited one wrong
    # explanation for two unrelated faults.
    known = {tuple(dos_img.getpalette()[3 * i:3 * i + 3]) for i in range(256)}
    pal_px = content_px = 0
    for y, x in zip(*np.where(mask)):
        if tuple(int(v) for v in port[y, x]) in known:
            content_px += 1
        else:
            pal_px += 1
    # The DOSBox pointer. Every capture in this baseline was taken with the
    # emulated mouse parked at the same spot, so a ~90 px arrow sits at
    # (158..172, 98..116) on EVERY screen and counts as divergence the port can
    # never close. It is REPORTED, not subtracted -- a number this tool quietly
    # edited would be worth less than one it explains. The real fix is to park
    # the pointer off-screen before shot() on the next --capture run, which
    # will move every baseline and every figure quoted against it.
    cursor = int(mask[98:116, 158:173].sum())
    OUT.mkdir(parents=True, exist_ok=True)
    side = Image.new("RGB", (320 * 3 + 8, 200), (24, 24, 24))
    side.paste(Image.fromarray(dos), (0, 0))
    side.paste(Image.fromarray(port), (324, 0))
    side.paste(Image.fromarray((mask[:, :, None] * np.array([255, 0, 0], np.uint8))
                               .astype(np.uint8)), (648, 0))
    side.save(OUT / ("%s.png" % sid))
    return {"id": sid, "px": int(mask.sum()), "pct": round(100 * mask.sum() / mask.size, 2),
            "cursor": cursor,
            "rows": [int(rows.min()), int(rows.max())] if len(rows) else None,
            "pal": pal_px, "content": content_px, "declared": div}


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--capture", action="store_true",
                    help="boot DOSBox and re-grab every screen (slow)")
    ap.add_argument("--capture-only", metavar="ID",
                    help="re-grab ONE screen, leaving the other baselines "
                         "(and every figure quoted against them) intact")
    ap.add_argument("--json", action="store_true")
    args = ap.parse_args()

    if args.capture or args.capture_only:
        capture(args.capture_only)
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
        tag = ("  [OPEN]" if str(r["declared"]).startswith("OPEN")
               else "  [declared]") if r["declared"] else ""
        print("  %-7s %6d px  %5.1f%%  rows %-10s  palette %5d / content %5d"
              "  cursor %3d%s"
              % (r["id"], r["px"], r["pct"], r["rows"], r["pal"], r["content"],
                 r["cursor"], tag))
        if r["declared"]:
            print("        %s" % r["declared"])
    print("\nside-by-side (DOS | port | delta): %s" % OUT)
    print("A percentage is a measurement, not a verdict -- every row needs a "
          "cause before it means anything.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
