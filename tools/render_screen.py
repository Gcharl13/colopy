#!/usr/bin/env python3
"""
render_screen.py — Render full-screen UIs to PNG by combining their
extracted .PIK background + relevant sprite overlays.

For each screen, output goes to verification/screens/<name>.png. Compare
against DOSBox-captured reference at verification/dosbox_screenshots/.

Usage:
    python render_screen.py                # render all known screens
    python render_screen.py --screen colony
    python render_screen.py --list         # list available screens
"""
from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ASSETS = ROOT / "assets"
OUTDIR = ROOT / "verification" / "screens"


# Screen definitions: (output_name, PIK background dir, list of overlay sprites or None)
# Each overlay is (sheet_dir, frame_idx, x, y) — drawn in order.
SCREENS = {
    "title":          ("OPENING",   []),
    "menu":           ("OPENMENU",  []),
    "colony":         ("COLONY",    []),
    "europe":         ("EUROPE",    []),
    "cc":             ("CCBKGD",    []),
    "customize":      ("CUSTOMIZ",  []),
    "difficulty":     ("DIFFICUL",  []),
    "nations":        ("NATIONS",   []),
    "declaration":    ("DECLARAT",  []),
    "decoind":        ("DECOIND",   []),
    "kinglss1":       ("KINGLSS1",  []),
    "kinglss2":       ("KINGLSS2",  []),
    "report1":        ("REPORT1",   []),
    "report2":        ("REPORT2",   []),
    "report3":        ("REPORT3",   []),
    "report4":        ("REPORT4",   []),
    "report5":        ("REPORT5",   []),
    "report6":        ("REPORT6",   []),
    "report7":        ("REPORT7",   []),
    "report8":        ("REPORT8",   []),
    "report9":        ("REPORT9",   []),
    "scenario01":     ("LEVN0001",  []),
    "scenario02":     ("LEVN0002",  []),
    "scenario03":     ("LEVN0003",  []),
    "scenario04":     ("LEVN0004",  []),
    "scenario05":     ("LEVN0005",  []),
    "woodpan":        ("WOODPAN2",  []),
    "woodpanl":       ("WOODPANL",  []),
    "openborder":     ("OPENBORD",  []),
    "closing_bg":     ("CLOS-BKG",  []),
}


def find_pik_png(name: str) -> Path | None:
    """Locate the extracted PIK PNG for a given background name."""
    bgdir = ASSETS / "backgrounds" / name
    if not bgdir.is_dir():
        return None
    pngs = sorted(bgdir.glob("*.png"))
    pngs = [p for p in pngs if "pal" not in p.stem.lower()]
    return pngs[0] if pngs else None


# Screens that have dedicated renderer scripts with full UI overlays.
# When rendering "all", these are invoked; otherwise the basic PIK-only
# version is rendered.
DEDICATED_RENDERERS = {
    "colony":   "render_colony",
    "europe":   "render_europe",
    "nations":  "render_nations",
    "score":    "render_score",
    "gameplay": "render_gameplay",
}


def render_screen(screen_name: str, definition, prefer_dedicated: bool = True):
    from PIL import Image

    # Use dedicated renderer if available
    if prefer_dedicated and screen_name in DEDICATED_RENDERERS:
        import subprocess
        module = DEDICATED_RENDERERS[screen_name]
        print(f"  invoking dedicated renderer: {module}")
        result = subprocess.run(
            [sys.executable, str(Path(__file__).parent / f"{module}.py")],
            capture_output=True, text=True
        )
        if result.returncode == 0:
            return True
        print(f"  dedicated renderer failed: {result.stderr}")
        # Fall through to basic PIK render

    pik_dir, overlays = definition
    pik_png = find_pik_png(pik_dir)
    if pik_png is None:
        print(f"  SKIP {screen_name}: no PNG found for background {pik_dir}")
        return False

    bg = Image.open(pik_png).convert("RGBA")

    for ov_sheet, ov_frame, x, y in overlays:
        sheet_dir = ASSETS / "sprites" / ov_sheet
        ov_path = sheet_dir / f"{ov_sheet}.SS.{ov_frame:03d}.png"
        if not ov_path.exists():
            print(f"  WARN: overlay {ov_path.name} not found in {sheet_dir}")
            continue
        ov = Image.open(ov_path).convert("RGBA")
        bg.paste(ov, (x, y), ov)

    OUTDIR.mkdir(parents=True, exist_ok=True)
    out_path = OUTDIR / f"{screen_name}.png"
    bg.save(out_path)
    print(f"  rendered {screen_name} ({bg.size[0]}x{bg.size[1]}) -> {out_path.name}")
    return True


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--list", action="store_true", help="List available screen names")
    ap.add_argument("--screen", help="Render a specific screen by name")
    args = ap.parse_args()

    if args.list:
        print("Available screens:")
        for name, (bg, ov) in SCREENS.items():
            print(f"  {name:20s} -> {bg}.PIK + {len(ov)} overlays")
        return 0

    if args.screen:
        if args.screen not in SCREENS:
            print(f"Unknown screen: {args.screen}", file=sys.stderr)
            return 1
        return 0 if render_screen(args.screen, SCREENS[args.screen]) else 1

    # Render all
    success = 0
    skipped = 0
    for name, definition in SCREENS.items():
        if render_screen(name, definition):
            success += 1
        else:
            skipped += 1
    print(f"\n{success} rendered, {skipped} skipped (out of {len(SCREENS)} screens)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
