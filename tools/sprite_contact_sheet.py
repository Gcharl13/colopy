#!/usr/bin/env python3
"""
sprite_contact_sheet.py — Generate a labeled contact sheet of all
sprites in a sheet, so we can identify which sprite-index is which
visual element (grass, forest, water, etc.).

Output: a single PNG with all sprites in a grid, each labeled with
its frame number.
"""
from __future__ import annotations

import argparse
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def build_contact(sheet_dir: Path, out_path: Path, cols: int = 16, cell_size: int = 24):
    from PIL import Image, ImageDraw
    pngs = sorted(sheet_dir.glob("*.png"))
    pngs = [p for p in pngs if "pal" not in p.name.lower()]
    if not pngs:
        print(f"No PNGs in {sheet_dir}", file=sys.stderr)
        return False

    n = len(pngs)
    rows = (n + cols - 1) // cols
    grid_w = cols * cell_size
    grid_h = rows * cell_size + rows * 8  # extra for labels

    canvas = Image.new("RGB", (grid_w, grid_h), (40, 40, 40))
    draw = ImageDraw.Draw(canvas)

    for i, png in enumerate(pngs):
        # Extract frame index from filename like FOO.SS.NNN.png
        try:
            frame_idx = int(png.stem.split(".")[-1])
        except ValueError:
            frame_idx = i

        col = i % cols
        row = i // cols
        cell_x = col * cell_size
        cell_y = row * (cell_size + 8)

        # Outline cell
        draw.rectangle([(cell_x, cell_y), (cell_x + cell_size - 1, cell_y + cell_size - 1)],
                       outline=(80, 80, 80))

        # Paste sprite
        sprite = Image.open(png).convert("RGBA")
        sw, sh = sprite.size
        # Resize if too big to fit
        if sw > cell_size or sh > cell_size:
            sprite.thumbnail((cell_size - 2, cell_size - 2), Image.NEAREST)
            sw, sh = sprite.size
        ox = cell_x + (cell_size - sw) // 2
        oy = cell_y + (cell_size - sh) // 2
        canvas.paste(sprite, (ox, oy), sprite if sprite.mode == "RGBA" else None)

        # Label
        draw.text((cell_x + 1, cell_y + cell_size + 1), f"{frame_idx:03d}",
                  fill=(255, 200, 80))

    canvas.save(out_path)
    print(f"  contact sheet ({n} sprites in {cols}x{rows}) -> {out_path}")
    return True


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--sheet", required=True, help="Sheet name (e.g. PHYS0)")
    ap.add_argument("--out", type=Path)
    ap.add_argument("--cols", type=int, default=16)
    ap.add_argument("--cell-size", type=int, default=24)
    args = ap.parse_args()

    sheet_dir = ROOT / "assets" / "sprites" / args.sheet
    if not sheet_dir.is_dir():
        print(f"Not found: {sheet_dir}", file=sys.stderr)
        return 1

    out = args.out or (sheet_dir / f"{args.sheet}_contact_sheet.png")
    return 0 if build_contact(sheet_dir, out, args.cols, args.cell_size) else 1


if __name__ == "__main__":
    sys.exit(main())
