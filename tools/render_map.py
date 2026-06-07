#!/usr/bin/env python3
"""
render_map.py — Render an .MP map to PNG using PHYS0.SS sprites.

Output: a PNG that should be visually identical to the in-game world
view (modulo unit/colony overlays, which require RuntimeState — not
rendered here).

Usage:
    python render_map.py                        # AMER2.MP, default
    python render_map.py --map AMER2.MP --out assets/maps/AMER2_render.png
"""
from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def load_phys0_sprites(sprites_dir: Path):
    """Load all PHYS0 sprite PNGs into a dict {index: PIL.Image}."""
    from PIL import Image
    out = {}
    for png in sorted(sprites_dir.glob("PHYS0.SS.*.png")):
        # Skip the palette preview
        if "pal" in png.stem.lower():
            continue
        # Filename like PHYS0.SS.001.png — index = "001"
        parts = png.stem.split(".")
        try:
            idx = int(parts[-1])
        except ValueError:
            continue
        img = Image.open(png).convert("RGBA")
        out[idx] = img
    return out


def render_map(map_json: dict, sprites: dict, tile_size: int = 16):
    from PIL import Image
    width = map_json["width"]
    height = map_json["height"]
    tiles = map_json["tiles"]

    # Compose at native tile resolution
    canvas = Image.new("RGBA", (width * tile_size, height * tile_size), (0, 0, 0, 255))

    skipped_indices = set()
    used_indices = set()
    for y in range(height):
        for x in range(width):
            byte = tiles[y * width + x]
            terrain_id = byte & 0x1F           # bottom 5 bits
            forest_bit = bool(byte & 0x40)
            river_bit  = bool(byte & 0x20)
            high_bit   = bool(byte & 0x80)

            # Naive mapping: sprite_index = terrain_id
            # (refine via Phase D when render-chain function is annotated)
            sprite_idx = terrain_id

            # Skip placeholder sprites (0, 16, 100 per CLAUDE.md hard rule)
            if sprite_idx in (0, 16, 100):
                skipped_indices.add(sprite_idx)
                continue

            sprite = sprites.get(sprite_idx)
            if sprite is None:
                # Try a fallback: if forest_bit set, try forested variant (idx + 8)
                continue

            used_indices.add(sprite_idx)
            # Resize sprite to tile_size if needed
            if sprite.size != (tile_size, tile_size):
                sprite = sprite.resize((tile_size, tile_size), Image.NEAREST)
            canvas.paste(sprite, (x * tile_size, y * tile_size), sprite)

            # River overlay (bit 5): try sprite at index 0x100 + terrain_id
            # if exists; otherwise overlay sprites 1 or 17 (per CLAUDE.md the
            # river sprites are at PHYS0 row 0x01 and 0x11, indices 1 & 17)
            if river_bit:
                river_sprite = sprites.get(1) or sprites.get(17)
                if river_sprite:
                    if river_sprite.size != (tile_size, tile_size):
                        river_sprite = river_sprite.resize((tile_size, tile_size), Image.NEAREST)
                    canvas.paste(river_sprite, (x * tile_size, y * tile_size), river_sprite)

    return canvas, used_indices, skipped_indices


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--map", type=Path,
                    default=ROOT / "assets" / "maps" / "amer2.json")
    ap.add_argument("--sprites", type=Path,
                    default=ROOT / "assets" / "sprites" / "PHYS0")
    ap.add_argument("--out", type=Path,
                    default=ROOT / "assets" / "maps" / "AMER2_render.png")
    ap.add_argument("--tile-size", type=int, default=16,
                    help="Output tile size in pixels (default 16)")
    args = ap.parse_args()

    if not args.map.exists():
        print(f"Map JSON not found: {args.map}", file=sys.stderr)
        return 1
    if not args.sprites.exists():
        print(f"Sprites dir not found: {args.sprites}", file=sys.stderr)
        return 1

    try:
        from PIL import Image
    except ImportError:
        print("PIL/Pillow not installed; install with `pip install Pillow`", file=sys.stderr)
        return 1

    print(f"Loading PHYS0 sprites from {args.sprites}...")
    sprites = load_phys0_sprites(args.sprites)
    print(f"  loaded {len(sprites)} sprites (indices {min(sprites)}..{max(sprites)})")

    print(f"Loading map from {args.map}...")
    map_json = json.loads(args.map.read_text())
    print(f"  {map_json['width']}×{map_json['height']} tiles")

    print(f"Rendering at tile_size={args.tile_size}...")
    canvas, used, skipped = render_map(map_json, sprites, args.tile_size)
    canvas.save(args.out)
    print(f"  wrote {args.out}  ({canvas.size[0]}×{canvas.size[1]})")
    print(f"  used sprite indices: {sorted(used)}")
    if skipped:
        print(f"  skipped placeholder indices: {sorted(skipped)}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
