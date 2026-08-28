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
# The COLONY screen's two FAILED mouse entry paths (VIEW > Find Colony >
# Return, then a fixed click) each filed a MAP frame as a colony baseline --
# caught only by LOOKING at the capture, which is why the docstring's
# "an untriaged row is an open question" rule exists. RESOLVED 2026-08-28:
# a bare map click can never open a colony while a unit awaits orders (it
# only advances the unit cycle -- measured twice, including a click directly
# on a colony icon); the manual's keyboard path works instead and is fully
# deterministic. See the COLONY registry entry.

# id -> (DOS entry key, port render args, declared divergence or None)
# The DOS entry key is what `capture()` presses from a known map state. A
# screen reached by a menu carries its accel path instead (see capture()).
REPORTS = {
    "F2": ("F2", ["--renderreport", FIXTURE, str(PAK), "{out}", "F2"],
           "CLOSED to the cursor floor (82 px = the DOS mouse pointer, "
           "0.1%), from 454. C4.23: the crosses gauge was never drawn "
           "because the runtime accumulator was never seeded -- PowerRecord "
           "+0x2E holds the crosses (30 on this save) and +0x30 the "
           "threshold (284), byte-verified at the F2 caller func_037958 "
           "@0x0379AB/AE, and the gauge itself (0x181F:0x236 = func_002EE4, "
           "pitch/scale helper func_002D74, number badge func_002E4E) was "
           "already implemented faithfully in both engines. Two seeds "
           "closed it: the accumulator, and the gauge SPAN, which is the "
           "STORED threshold rather than a draw-time recompute -- the "
           "port's recompute counted 130 units where the original's record "
           "iteration counts 138 (G.units excludes Europe-side and "
           "aboard-ship records), threshold 268 vs 284, which spread the "
           "30 crosses ~6% wider and leaked sprite edges through the "
           "smear. The badge now diffs to ZERO. The unit-count divergence "
           "itself is flagged (C4.29), not silently absorbed."),
    "F3": ("F3", ["--renderreport", FIXTURE, str(PAK), "{out}", "F3"],
           "Founding Father portraits: the 25 CC-00..CC-24 sheets are not in "
           "the pack (Part E), so the port lists names as text where the "
           "original draws faces."),
    "F5": ("F5", ["--renderreport", FIXTURE, str(PAK), "{out}", "F5"],
           "CLOSED to ~the cursor floor (97 px, of which 82 is the DOS "
           "mouse pointer), from 398. C4.9 fixed the bid/ask straddle "
           "(398 -> 202); the rest was ONE element -- the VERTICAL rule "
           "between the commodity names and the price columns at x = 67, "
           "rows 25..176, in the same rule ink as the horizontal rules, "
           "measured off the baseline (202 -> 97). ~15 px of glyph-scale "
           "residual remains untriaged."),
    "F7": ("F7", ["--renderreport", FIXTURE, str(PAK), "{out}", "F7"],
           "CLOSED AT THE CURSOR FLOOR -- 82 px, every one of them the DOS "
           "mouse pointer: the F7 grid is PIXEL-PERFECT. The last 81 px "
           "were the merged-hold crate count (the runtime hold merges "
           "same-good slots via hold_add, so rec 0's two full fur holds "
           "drew as ONE crate; the draw now expands one crate per 100 "
           "plus a partial, per record semantics). C4.1's decode: the "
           "func_00386A "
           "panel composite (spec/ui/render_primitives §1b) plus four "
           "byte-verified findings from the F7 caller func_03954C took "
           "1,100 -> 163 px, of which 82 is the mouse pointer:\n"
           "         1. the FITTED anchor 4 is really 2 -- SHIP rows enter "
           "the shared verb at @0x039843 with bx = [bp-0x56] = 2 (the row "
           "x); sea-borne LAND units enter at @0x039574 with bx = "
           "[bp-0x56]+0x56 = 88 (the cargo column). The old 4 was "
           "compensating for finding 2:\n"
           "         2. func_00380C is a TWO-LAYER sprite draw -- layer 1 a "
           "solid BLACK SILHOUETTE of the frame at (x, y) (@0x003829-34), "
           "layer 2 the real sprite at (x+2, y) (`lea dx,[di+2]` @0x003854); "
           "class 0 defers the silhouette until after the plates (@0x003D71)\n"
           "         3. cargo crates are PER-GOOD, per occupied hold: frame "
           "= (qty >= 0x64 ? 0x17 : 0x27) + good (@0x039605/@0x0395A8) = "
           "bundle 22+good full / 38+good partial, at 88+12k; the port drew "
           "the generic frame 22 per PASSENGER\n"
           "         4. the location column (@0x0396A4, formatter "
           "0x191F:0xF82) prints the colony NAME when the ship sits on a "
           "colony tile, coordinates only at sea\n"
           "        The sheet-header width field also settled: es:[bx+0x3E] "
           "holds the frame's TRIMMED width (adjustment sweep: 0 -> best, "
           "-1 -> +91 px, -2 -> +103 px). What is LEFT (~81 px beyond the "
           "pointer) is at glyph/edge scale, untriaged."),
    "EUROPE": ("EUROPE", ["--rendereurope", FIXTURE, str(PAK), "{out}", "0", "0", "-1", "0"],
           "OPEN (0.6%, 379 px of which 82 is the pointer), down from 20.0%. "
           "Thirteen fixes -- the latest: the crossing and harbour SHIPS "
           "go through the full func_00386A composite (the baseline shows "
           "the class-1 plate at the hull's top-right; the old worse "
           "measurement predates the silhouette + x+2 decode), 421 -> 379. "
           "What remains is figure-level pixel noise in the crossing band "
           "(anchors verified identical) and a sparse market-strip row. "
           "Earlier fixes:\n"
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
           "        The black-plate residual named here resolved as "
           "predicted: it is func_00380C's SILHOUETTE layer (the two-layer "
           "sprite draw decoded for F7/C4.1 -- black shape at x, sprite at "
           "x+2, so the capture-pinned sprite x's put the silhouette 2 px "
           "LEFT). Adding it took 486 -> 421 px (the ship's silhouette "
           "alone is worth 35); the alternative reading (silhouette at the "
           "pinned x, sprite +2) scores 529 and is dead. The sack stays -- "
           "with silhouettes but no sack the screen scores 509.\n"
           "        What is LEFT: 82 px of DOS mouse pointer and ~339 px "
           "spread over the crossing bands and panel text at glyph scale, "
           "untriaged."),
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
           "        Rows 0, 1, 2 and 6 are now pixel-exact. CLOSED to ~the "
           "cursor floor (94 px, of which 82 is the pointer): the SIOUX "
           "red is HARDCODED in the EXE -- the row painter sets the ink "
           "from [0x848+power] then overrides power index 0xA (tribe 6) "
           "to 0xC (`cmp bx,0xA; mov [bp-0x6E],0xC` @0x037496-@0x03749B). "
           "~12 px remain inside the Apache and Sioux portraits. Also NOT "
           "implemented: the MISSIONS cell at "
           "x = 96 (@0x037650), whose counting rule is byte-cited but whose "
           "singular/plural strings [0x2DF0]/[0x2DF2] are unresolved and "
           "which this fixture cannot exercise."),
    # The MAP itself, straight after LOAD GAME -- no navigation at all, so the
    # frame is deterministic up to the declared animations. WHERE THE VIEW IS:
    # not the saved cursor. The save stores [0x017C]/[0x017E] = (21, 30)
    # (serializer blocks 41-43; the words byte-verify as tile x/y via the
    # clamp loops @0x24002-@0x2405C against g_map_width/height and the view
    # verb 0x181F:0xE08), but the captured frame's sidebar reads "Dutch
    # Frigate / Locat: (44, 29)" -- on load the engine focuses the first
    # active unit and centres THERE. That unit is record 51 = G.units
    # ordinal 6 (the 7th player ship in record order), so the entry passes
    # view origin (44-7, 29-6) = (37, 23) and sel 6. Declared divergences:
    # the active-unit BLINK (the frigate is visible or hidden by frame
    # parity), the water palette cycle (120..127), and the mouse pointer.
    # sel 6 = the active frigate; menu -1 msel 0; BLINK 0 -- this baseline
    # caught the blink-OFF half (the frigate is absent from its tile), so
    # the render matches that half rather than declaring the whole unit.
    "MAP": (None, ["--rendermap", FIXTURE, str(PAK), "{out}", "37", "23", "6",
                   "-1", "0", "0"],
            "OPEN (8.2%), captured 2026-08-28 and taken 9,855 -> 5,263 "
            "the same day (content 2,132 + cycle 3,119 + pointer 98). The view origin (37, 23) is the sweep's unique "
            "minimum (every neighbour >= 16,428), confirming the centring "
            "model clamp(unit - (7, 6)). The fixes, each measured:\n"
            "         MAP UNITS draw through the shared func_00386A "
            "composite (silhouette + class-aware plate) on every layer -- "
            "player, rival, native, REF -- and a unit standing on a COLONY "
            "tile is INSIDE it and does not draw (San Salvador's docked "
            "Galleon). Labels are FLAT white with the glyph's own black "
            "outline, no ramp (0xC28:0xA gets one ink + shadow 0). This "
            "baseline caught the blink-OFF half, so the entry renders "
            "blink 0 via the harness's new BLINK argument\n"
            "         The LABELS lost their invented drop shadow (the "
            "baseline carries only the glyph's own class-3 outline, -324), "
            "and the sidebar TEXT GEOMETRY was measured off the frame: "
            "Moves (260,69) / Locat (260,77) pitch 8, the unit block "
            "(242,86)/(242,93)/(242,100) pitch 7, with the ORDERS line in "
            "yellow 0x95 (-573). FLAGGED: the menu-bar face is narrower "
            "than every shipped .FF (GAME runs 13 px vs FONTTINY's 17; "
            "NP/SMAL/zero-tracking all measured worse) -- unidentified; "
            "the Gold line's trailing glyph after the number is unread; "
            "Moves 6-vs-5 semantics unread\n"
            "         RESOLVED: the 'Ocean/Sea-Lane dither band' was no "
            "band at all -- TERRAIN.SS frame 11 (Sea Lane) carries 62 "
            "pixels per tile in the WATER CYCLE ramp 120..127 (frame 10, "
            "Ocean, is all static 58..60), and the DOS capture holds a "
            "live phase while the port renders phase 0. The census now "
            "models it: one global rotation fit per frame, accepted "
            "pixels in the `cycle` column (3,117 here), never silently "
            "subtracted. The initially-suspected darker band further out "
            "was the UNEXPLORED region, and it matches the port's fog "
            "exactly (166/166 tiles)\n"
            "         RESOLVED: the sidebar unit panel is the SHARED "
            "func_00386A composite (silhouette + class-1 plate at the "
            "frigate's top-right, interior orange measured (252..256, "
            "69..75)); anchor (242, 68) is the sweep's unique minimum. "
            "RESOLVED: the MINIMAP -- 1,353 -> ~118 px. The colour "
            "source was never a table in the EXE: the init loop "
            "@0x0668B8-@0x066922 SAMPLES each colour at runtime as the "
            "ground frame's pixel (8,8) of a 16x16 render (func_066884 "
            "returns buffer offset 0x88; ids 8..23 copy their BASE id's "
            "sample, so forests show the unforested colour; slots "
            "0x1B/0x1C sample PHYS0 frames 0x21/0x31 for mountains/"
            "hills), the window is clamp(cursor - (0x1C, 0x13), 1, "
            "map - (0x39, 0x28)) (@0x066928), and the paint loop "
            "(func_066968) layers fog-black < terrain < unit dots < "
            "settlement dots, with a foreign Privateer greyed to 8 "
            "(@0x066AED). Rival colonies and unit dots were missing "
            "entirely. FLAGGED: the engine gates unit dots on the record "
            "owner byte's per-power seen mask (@0x066ABC); both engines "
            "substitute tile visibility identically. Still OPEN: Moves: "
            "6 vs DOS 5 -- and 5 matches NEITHER the pinned full moves "
            "(@UNIT Frigate movement = 6) NOR the record's +0x06 = 9 "
            "thirds = 3; the loader's moves semantics are UNREAD\n"
            "         DONE (9,855 -> 9,612): colony POPULATION NUMBERS and "
            "the missing RIVAL name labels, decoded from func_004314 "
            "(0x181F:0x2A8, the marker painter): number = FONTTINY ([0x89E]) "
            "left-aligned at (px+7, py+7), ink 0xF / 0xA / 0xB per record "
            "+0x1C bits 4|2 (@0x00448B-@0x0044EF); name = FONTINTR "
            "([0x268A]) left-aligned at (px+2, py+16) (@0x0044FA-@0x004529) "
            "-- the port's centred-FONTTINY label was a guess, and rival "
            "colonies now get both. Residual glyph-level ink ramp unread\n"
            "        Declared: the active-unit blink, the water palette "
            "cycle (120..127, see `palette`), the mouse pointer."),
    # The COLONY screen, entered by the manual's KEYBOARD path -- the mouse
    # is a dead end: while a unit awaits orders, a map click only advances
    # the unit cycle and recentres on the next active unit (measured twice,
    # including a click directly on the San Salvador icon). The manual's
    # "pressing Return when the square is selected" works instead: V (view
    # mode) puts the square cursor on the ACTIVE unit -- the frigate at
    # (44, 29), verified by the sidebar reading "Frigate / Locat: (44, 29)"
    # -- so Left lands on Isabella (43, 29) and Return opens her display.
    # Fully deterministic from the post-load state. Isabella is G.colonies
    # ordinal 1 (player colonies in record order: Jamestown 0, Isabella 1).
    # Vlissingen (25, 34) -- the colony WITH a docked ship (the Galleon,
    # record 34, two full holds: goods 6 and 4), so this frame exercises the
    # func_027DB2 ships-present branch the Isabella entry cannot. Same view-
    # mode path: the cursor starts on the active frigate (44, 29), so 19
    # Lefts and 5 Downs land on the colony. Vlissingen is record 12 =
    # G.colonies ordinal 10 (the 11th player colony in record order).
    "COLONY_SHIP": (("KEYS", "v") + ("Left",) * 19 + ("Down",) * 5 +
                    ("Return",),
               ["--rendercolony", FIXTURE, str(PAK), "{out}", "10"],
               "NEW ENTRY (42.4%), first captured 2026-08-28, and it "
               "corrected the dock model immediately (B3.1): the strip's "
               "membership is CARGO CAPACITY > 0, not hull -- the DOS frame "
               "docks the WAGON TRAIN beside the Galleon, and the engine's "
               "own y-1 @0x2801A applying only to ship types 0x0D..0x12 is "
               "the byte-side tell. Carriers left the plaza row for the "
               "dock in both engines, the ship strip now goes through the "
               "shared func_00386A composite (@0x28049 mode 0x64 W=0x10), "
               "and the headline/crate placement follows the bytes "
               "(163,132 / x+5-w/2 at y=165). (The SoL split 6%/94% vs "
               "DOS 5%/95% was the rounding bug fixed via the COLONY "
               "entry: the engine floors -- 64/1082 = 5.92 prints 5.) "
               "2026-08-28 PRODUCTION DECODE (42.4% -> 35.2%): this "
               "frame's strips forced the full byte read of the yield "
               "chain -- func_009B9C (field), func_009FFC (indoor jump "
               "table at cs 0x82B0), func_00A222 (centre + secondary), "
               "func_008E02/8E84 (the band planes) -- and every scene "
               "badge now reproduces: farmers 6/5 (prof-0 IS the Expert "
               "Farmer, C4.26), lumberjacks 4/4 (the LUMBER column "
               "doubles @0x9EAB), miners 4/4 (mountains classify to the "
               "@OTHER row via func_00624E), fisherman 4 (ocean-neighbour "
               "ladder + Docks gate), and the ore row's 13 = 8 + the "
               "centre's Minerals secondary 5 -- confirmed at RUNTIME by "
               "the view-mode sidebar printing '(Minerals)' on (25,34), "
               "which independently validates the detail hash AND the "
               "pinned seed 1657. The crossed runs are the OUTAGE plane "
               "[0x8E5A] (lumber 4 = 12 wanted - 8 made), row 0 crosses "
               "the warehouse overdraw [0x8E32] (ore crosses NOTHING "
               "against a 161 stock), and the horses cell is want 4 with "
               "[0x8E6A] = 3 unfed foals crossed. The production panel "
               "region is now ~123 px from DOS (X-mark pixel offsets); "
               "the remaining bulk is the DECLARED RNG building "
               "placement."),
    "COLONY": (("KEYS", "v", "Left", "Return"),
               ["--rendercolony", FIXTURE, str(PAK), "{out}", "1"],
               "NEW ENTRY (33.3%), first captured 2026-08-28 -- the failed "
               "mouse entries above are RESOLVED by this keyboard path. "
               "The frame is structurally right (title, scene, docks, "
               "stockade band, warehouse row, people row all line up). "
               "The bulk of the 21,303 is the DECLARED building-placement "
               "divergence: the scene scatters buildings through the "
               "RNG-driven func_025D34, which is unresolved (the exact "
               "reason this screen must never be marked COMPLETE -- "
               "2026-06-24). 2026-08-28 re-measure: the SoL band counters "
               "now MATCH (36%/64% (1)/(1) both -- the colony_sol floor "
               "fix), and the area-view CROP aligns tile-for-tile. The "
               "area view's TEXTURE decoded the same day: func_005296 is "
               "the engine's per-pixel ramp dither (position hash + a "
               "running salt inside func_00531C's full 80->120 upscale, "
               "the panel being its (24,24)+72x72 window), and the "
               "literal loop took the panel 3,597 -> 1,340 px (33.1% -> "
               "28.4% whole-frame). The residual dither phase plus the "
               "port's coast halo/detail specks in the source are "
               "FLAGGED open. "
               "2026-08-28: the production decode (see "
               "COLONY_SHIP) also fixed THIS frame's rows -- Isabella's "
               "row 0 'tobacco' was really the centre's savannah SUGAR "
               "secondary 4, and her rum row is 4 = criminal 1 + free 3 "
               "(the indoor class rates @0xA0D7), with the consumed sugar "
               "crossing nothing because stock covers it."),
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
        elif fkey is None:                     # the map itself -- press nothing
            import time
            time.sleep(1.5)
        elif isinstance(fkey, tuple) and fkey[0] == "CLICK":
            drive.click(fkey[1], fkey[2], delay=3.0)
        elif isinstance(fkey, tuple) and fkey[0] == "KEYS":
            # 0.8s between keys (0.6 verified interactively for the view-mode
            # cursor walk), a long settle after the final key so the opened
            # screen finishes drawing before the shot.
            for k in fkey[1:-1]:
                drive.key(k, delay=0.8)
            drive.key(fkey[-1], delay=3.0)
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
    # The WATER CYCLE. Palette indices 120..127 rotate live (the animated
    # sparkle ramp -- TERRAIN.SS frame 11, the Sea Lane ground, carries 62
    # such pixels per tile, byte-checked against frame 10's static 58..60).
    # The port renders phase 0; DOSBox is captured mid-animation, so every
    # cycling pixel can disagree while both sides are RIGHT. The model is a
    # SINGLE GLOBAL PHASE for the whole frame (the engine rotates the ramp
    # once per tick, not per pixel): read the port's own index buffer
    # (OUT.ppm.idx = fb + palette), try all 8 rotations of 120..127 on the
    # port's cycling pixels, keep the rotation that explains the most, and
    # accept ONLY the pixels that rotation makes byte-equal. Reported in its
    # own column -- never silently subtracted from content.
    cyc_px = 0
    idx_file = Path(str(out) + ".idx")
    if idx_file.exists():
        raw = np.fromfile(idx_file, dtype=np.uint8)
        npx = raw.size - 768
        fbw = port.shape[1]
        fb = raw[:npx].reshape(npx // fbw, fbw)[:200]
        ppal = raw[npx:].reshape(256, 3)
        cyc_pts = [(y, x) for y, x in zip(*np.where(mask))
                   if 120 <= fb[y, x] <= 127]
        best_phase, best_hits = 0, -1
        for ph in range(8):
            hits = sum(1 for y, x in cyc_pts
                       if (dos[y, x] == ppal[((fb[y, x] - 120 + ph) & 7)
                                             + 120]).all())
            if hits > best_hits:
                best_phase, best_hits = ph, hits
        accepted = {(y, x) for y, x in cyc_pts
                    if (dos[y, x] == ppal[((fb[y, x] - 120 + best_phase) & 7)
                                          + 120]).all()}
        cyc_px = len(accepted)
    else:
        accepted = set()
    pal_px = content_px = 0
    for y, x in zip(*np.where(mask)):
        if (y, x) in accepted:
            continue
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
            "pal": pal_px, "content": content_px, "cycle": cyc_px,
            "declared": div}


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
              " / cycle %4d  cursor %3d%s"
              % (r["id"], r["px"], r["pct"], r["rows"], r["pal"], r["content"],
                 r.get("cycle", 0), r["cursor"], tag))
        if r["declared"]:
            print("        %s" % r["declared"])
    print("\nside-by-side (DOS | port | delta): %s" % OUT)
    print("A percentage is a measurement, not a verdict -- every row needs a "
          "cause before it means anything.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
