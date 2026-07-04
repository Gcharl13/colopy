#!/usr/bin/env python3
"""package_player.py -- assemble the standalone game package (the "export").

Collects the curated data set the GameShell player needs at runtime into a
self-contained folder next to an exe:

    Viceroy-win64/
      Viceroy.exe            (pass --exe; omitted for a data-only layout)
      README.txt
      data/                  canonical record store (drydock boots from it)
      data_extracted/        palette + tileset + map + engine + text
      docs/atlas/pik/        PIK backgrounds (map HUD chrome, screens)
      docs/atlas/sprites/atlas_PARCH.bmp   the colony parchment tile

Self-test: run the LINUX player headless against the packaged tree
(`viceroy --root PKG --frames 6`) to prove the set is complete before
zipping -- pass --selftest BIN to enable.

Usage: tools/package_player.py --out DIR [--exe PATH] [--selftest BIN]
"""
import argparse
import os
import shutil
import subprocess
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

COPY_TREES = [
    "data",
    "data_extracted/tileset",
    "data_extracted/map",
    "data_extracted/engine",
    "data_extracted/text",
    "docs/atlas/pik",
]
COPY_FILES = [
    "data_extracted/palette.json",
    "docs/atlas/sprites/atlas_PARCH.bmp",
]

README = """Viceroy -- the reconstructed game, standalone player
=====================================================

RUN
  Windows: double-click Viceroy.exe (it reads the data folders next to it).
  The window scales the native 320x200 screen to any size, pixel-crisp.

PLAY
  Enter          start a new game / end the turn
  arrows         move the selected unit
  Tab / W        next unit with moves
  click          select a unit / open your colony
  B              found a colony (confirm popups: click or keys 1..2)
  G then click   go-to (moves on end turn)
  F/S/P/R        fortify / sentry / clear-plow / build road
  L/U/O          load / unload / dump cargo (ships & wagons)
  Shift-D        disband unit
  E              Europe (click a good: sell 1; right-click: buy 1;
                 click a dock row to recruit)
  F1..F10        advisor reports
  In the colony: click a surrounding tile to put a colonist to work /
                 take one off; right-click picks the profession.
  F11            save (viceroy_save.txt)
  Esc            back / quit

This package was produced by the Forge engine export from the byte-verified
reconstruction. It is a private build: the art is converted from the
original game's files -- do not redistribute.
"""


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--out", required=True)
    ap.add_argument("--exe", help="player exe to place at the package root")
    ap.add_argument("--selftest", help="a host player binary to verify the tree")
    args = ap.parse_args()

    out = os.path.abspath(args.out)
    if os.path.exists(out):
        shutil.rmtree(out)
    os.makedirs(out)

    for tree in COPY_TREES:
        src = os.path.join(ROOT, tree)
        dst = os.path.join(out, tree)
        shutil.copytree(src, dst)
        print(f"  + {tree}/")
    for f in COPY_FILES:
        src = os.path.join(ROOT, f)
        dst = os.path.join(out, f)
        os.makedirs(os.path.dirname(dst), exist_ok=True)
        shutil.copy2(src, dst)
        print(f"  + {f}")
    with open(os.path.join(out, "README.txt"), "w") as fh:
        fh.write(README)
    if args.exe:
        shutil.copy2(args.exe, os.path.join(out, os.path.basename(args.exe)))
        print(f"  + {os.path.basename(args.exe)}")

    if args.selftest:
        print("self-test: booting the packaged tree headless ...")
        r = subprocess.run([os.path.abspath(args.selftest), "--root", out,
                            "--frames", "6"], capture_output=True, text=True)
        sys.stdout.write(r.stdout)
        sys.stderr.write(r.stderr)
        if r.returncode != 0:
            print("PACKAGE SELF-TEST FAILED", file=sys.stderr)
            return 1
        print("PACKAGE OK (headless boot + 6 frames on the packaged data)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
