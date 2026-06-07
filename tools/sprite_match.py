"""
sprite_match.py — sprite-by-sprite identification matcher.

Algorithm (per the user's spec):
  1. Select a sprite from the library.
  2. Scan the entire screen for matches.
  3. For every position where match score >= 0.95, record placement
     and BLACK OUT that area on the working frame.
  4. Move to the next sprite.
  5. Goal: identify every sprite on the screen and where it is located.

Key properties:
  - HIGH-CONFIDENCE only: 95%+ match threshold. False positives rejected.
  - Cumulative blackout: once a region is claimed by sprite S, subsequent
    sprites cannot re-claim that area (because it's black).
  - Sprite ordering: largest-area first, so big sprites get first claim.
  - Tolerance accommodates webp compression artifacts (the captured frames
    are .webp which shifts RGB by up to ~16 per channel from the original
    palette colors).

Output:
  {frame}_sprites.png          — overlay with rectangles per match
  {frame}_blackout.png         — working frame after all blackouts
  {frame}_reconstruct.png      — sprites painted on empty canvas
  {frame}_sprites.json         — manifest of every (sprite, x, y, score)
  {frame}_unidentified.png     — what no sprite explained

Usage:
    python sprite_match.py FRAME_STEM [SCREEN_TYPE]
    e.g. python sprite_match.py 1310262984 gameplay
"""
from __future__ import annotations

import json
import sys
import time
from dataclasses import dataclass
from pathlib import Path
from typing import Optional

import numpy as np
from PIL import Image, ImageDraw, ImageFont

ROOT = Path(str(__import__("pathlib").Path(__file__).resolve().parents[1]))
SPRITE_ROOT = ROOT / 'extracted' / 'assets' / 'sprites'
FRAMES = ROOT / 'reverse_engineered' / 'session_1777952458' / 'frames'
OUT_DIR = ROOT / 'reverse_engineered' / 'verification' / 'sprite_matches'
OUT_DIR.mkdir(parents=True, exist_ok=True)

# Match parameters
MATCH_THRESHOLD = 0.95          # >= 95% of opaque sprite pixels must match
COLOR_TOLERANCE = 12            # max RGB-channel delta per pixel
                                 # (webp shifts colors by up to ~16; 12 strikes
                                 # a balance between strictness and tolerance)

# Atlases per screen type
ATLASES_BY_SCREEN = {
    'gameplay':   ['PHYS0', 'TERRAIN', 'ICONS', 'NAMEPLAT', 'CURSOR'],
    'colony':     ['BUILDING', 'ICONS', 'PHYS0', 'TERRAIN', 'NAMEPLAT'],
    'europe':     ['ICONS', 'WOODTILE', 'WOODFRAM'],
    'congress':   ['CC-00','CC-01','CC-02','CC-03','CC-04','CC-05',
                   'CC-06','CC-07','CC-08','CC-09','CC-10','CC-11',
                   'CC-12','CC-13','CC-14','CC-15','CC-16','CC-17',
                   'CC-18','CC-19','CC-20','CC-21','CC-22','CC-23',
                   'CC-24','ICONS','WOODFRAM'],
    'popup':      ['ICONS','MSS0','MSS1','MSS2','MSS3','MSS4','MSS5',
                   'MYR0','MYR1','MYR2','MYR3'],
    'all':        None,         # auto-discover all atlases
    'default':    ['PHYS0', 'ICONS', 'BUILDING', 'TERRAIN'],
}


# ---------------------------------------------------------------------------
# Sprite library
# ---------------------------------------------------------------------------
@dataclass
class Sprite:
    atlas: str
    index: int
    label: str
    pixels: np.ndarray
    mask: np.ndarray
    h: int
    w: int

    @property
    def opaque_count(self) -> int:
        return int(self.mask.sum())


def load_atlas(atlas_name: str) -> list[Sprite]:
    folder = SPRITE_ROOT / atlas_name
    if not folder.exists():
        return []
    sprites = []
    for path in sorted(folder.glob('*.png')):
        stem = path.stem
        idx_str = stem.split('.')[-1]
        idx = int(idx_str) if idx_str.isdigit() else 0
        img = Image.open(path).convert('RGBA')
        arr = np.array(img)
        if arr.shape[0] <= 1 or arr.shape[1] <= 1:
            continue
        rgb = arr[:, :, :3]
        mask = arr[:, :, 3] > 0
        if not mask.any():
            continue
        sprites.append(Sprite(atlas=atlas_name, index=idx, label=stem,
                              pixels=rgb, mask=mask,
                              h=arr.shape[0], w=arr.shape[1]))
    return sprites


def discover_all_atlases() -> list[str]:
    return sorted([d.name for d in SPRITE_ROOT.iterdir() if d.is_dir()])


# ---------------------------------------------------------------------------
# Pixel matching
# ---------------------------------------------------------------------------
def match_score(frame: np.ndarray, sprite: Sprite, x: int, y: int,
                tolerance: int) -> float:
    """Score how well sprite fits at frame position (x, y).
    Returns ratio of opaque-pixel matches in [0, 1]."""
    fh, fw = frame.shape[:2]
    if x < 0 or y < 0 or x + sprite.w > fw or y + sprite.h > fh:
        return 0.0
    sub = frame[y:y+sprite.h, x:x+sprite.w].astype(np.int16)
    spr = sprite.pixels.astype(np.int16)
    delta = np.abs(sub - spr).max(axis=-1)
    diff = delta <= tolerance
    matching = (diff & sprite.mask).sum()
    return matching / sprite.opaque_count


def find_all_matches_above_threshold(frame: np.ndarray, sprite: Sprite,
                                     threshold: float, tolerance: int
                                     ) -> list[tuple[int, int, float]]:
    """Find every position where sprite matches at >= threshold.
    Uses a fast-reject on the first opaque pixel."""
    fh, fw = frame.shape[:2]
    if sprite.w > fw or sprite.h > fh:
        return []
    first_opaque = np.argwhere(sprite.mask)
    if len(first_opaque) == 0:
        return []
    iy, ix = first_opaque[0]
    fast_pixel = sprite.pixels[iy, ix].astype(np.int16)

    hits = []
    for y in range(0, fh - sprite.h + 1):
        for x in range(0, fw - sprite.w + 1):
            # fast reject on the first opaque pixel
            test = frame[y+iy, x+ix].astype(np.int16)
            if np.abs(test - fast_pixel).max() > tolerance:
                continue
            score = match_score(frame, sprite, x, y, tolerance)
            if score >= threshold:
                hits.append((x, y, score))
    return hits


# ---------------------------------------------------------------------------
# Sprite-by-sprite identification
# ---------------------------------------------------------------------------
@dataclass
class Placement:
    sprite: Sprite
    x: int
    y: int
    score: float


def blackout_region(working: np.ndarray, sprite: Sprite, x: int, y: int):
    """Black out the area where sprite was matched (in working frame).
    Subsequent sprite scans against this region cannot match."""
    sub = working[y:y+sprite.h, x:x+sprite.w]
    # Set the OPAQUE pixels of the sprite to black in the working frame
    m3 = np.stack([sprite.mask, sprite.mask, sprite.mask], axis=-1)
    sub[m3] = 0


def deduplicate_overlaps(matches: list[tuple[int,int,float]],
                         sprite_w: int, sprite_h: int) -> list[tuple[int,int,float]]:
    """For a single sprite, dedupe overlapping matches.
    If two matches significantly overlap (>30% of sprite area), keep
    only the one with the higher score."""
    if not matches:
        return []
    matches_sorted = sorted(matches, key=lambda m: -m[2])  # higher score first
    accepted = []
    for (x, y, score) in matches_sorted:
        too_close = False
        for (ax, ay, _) in accepted:
            # Overlap rectangle
            ox = max(0, min(x + sprite_w, ax + sprite_w) - max(x, ax))
            oy = max(0, min(y + sprite_h, ay + sprite_h) - max(y, ay))
            overlap_area = ox * oy
            if overlap_area > sprite_w * sprite_h * 0.3:
                too_close = True
                break
        if not too_close:
            accepted.append((x, y, score))
    return accepted


def identify_sprites(frame: np.ndarray, sprites: list[Sprite],
                     threshold: float = MATCH_THRESHOLD,
                     tolerance: int = COLOR_TOLERANCE) -> tuple[list[Placement], np.ndarray]:
    """Per-sprite identification with cumulative blackout.

    For each sprite (largest first):
        Find every position on the working frame where the sprite matches
        at >= threshold. For each match: record placement, blackout area.
    Returns (placements, working_frame_after_blackouts)."""
    working = frame.copy()
    placements: list[Placement] = []

    # Largest-area first so big sprites get first claim
    sprites_sorted = sorted(sprites, key=lambda s: -s.opaque_count)

    t0 = time.time()
    print(f'\nScanning {len(sprites_sorted)} sprites '
          f'(threshold={threshold:.2f}, tolerance={tolerance})...')
    last_print = t0

    for i, sprite in enumerate(sprites_sorted):
        # Find all matches on the WORKING frame (which has earlier matches blacked out)
        hits = find_all_matches_above_threshold(working, sprite, threshold, tolerance)
        # Dedupe overlapping matches (keep highest-score in each overlap cluster)
        hits = deduplicate_overlaps(hits, sprite.w, sprite.h)
        # Record + blackout
        for (x, y, score) in hits:
            placements.append(Placement(sprite, x, y, score))
            blackout_region(working, sprite, x, y)

        # Periodic progress
        now = time.time()
        if now - last_print > 3.0 or i == len(sprites_sorted) - 1:
            print(f'  [{i+1:4d}/{len(sprites_sorted)}] '
                  f'{sprite.label:20s} placements so far: {len(placements):4d} '
                  f'  ({now-t0:.1f}s)')
            last_print = now

    print(f'\nIdentification complete: {len(placements)} placements in '
          f'{time.time()-t0:.1f}s')
    return placements, working


# ---------------------------------------------------------------------------
# Output
# ---------------------------------------------------------------------------
def annotate_overlay(frame: np.ndarray, placements: list[Placement],
                     out_path: Path, upscale: int = 4):
    fh, fw = frame.shape[:2]
    img = Image.fromarray(frame).resize((fw * upscale, fh * upscale), Image.NEAREST)
    img = img.convert('RGBA')
    overlay = Image.new('RGBA', img.size, (0, 0, 0, 0))
    draw = ImageDraw.Draw(overlay)
    try:
        font = ImageFont.truetype('C:/Windows/Fonts/consola.ttf', 9)
    except Exception:
        font = ImageFont.load_default()

    palette = {
        'PHYS0':    (255, 230,   0, 200),
        'TERRAIN':  (200, 230,   0, 200),
        'ICONS':    (  0, 220, 230, 200),
        'BUILDING': (255, 100, 230, 200),
        'NAMEPLAT': (255, 200, 100, 200),
        'CURSOR':   (255, 255, 255, 220),
        'WOODTILE': (180,  90,  30, 200),
        'WOODFRAM': (180,  90,  30, 200),
        'PARCH':    (220, 180,  80, 200),
    }
    for p in placements:
        if p.sprite.atlas in palette:
            color = palette[p.sprite.atlas]
        elif p.sprite.atlas.startswith('CC-'): color = (255, 100, 100, 200)
        elif p.sprite.atlas.startswith(('MSS','MYR')): color = (255, 150, 50, 200)
        elif p.sprite.atlas.startswith('IND'): color = (100, 255, 100, 200)
        elif p.sprite.atlas.startswith('DEC-'): color = (200, 100, 255, 200)
        elif p.sprite.atlas.startswith('SCORE'): color = (255, 200, 0, 200)
        elif p.sprite.atlas.startswith('WDCUT'): color = (180, 180, 180, 200)
        else: color = (200, 200, 200, 180)
        x0, y0 = p.x * upscale, p.y * upscale
        x1 = (p.x + p.sprite.w) * upscale - 1
        y1 = (p.y + p.sprite.h) * upscale - 1
        draw.rectangle([x0, y0, x1, y1], outline=color, width=1)
    final = Image.alpha_composite(img, overlay)
    final.convert('RGB').save(out_path, 'PNG', optimize=True)


def render_blackout(working: np.ndarray, out_path: Path, upscale: int = 4):
    """Save the working frame after all sprite blackouts (residual)."""
    fh, fw = working.shape[:2]
    img = Image.fromarray(working).resize((fw * upscale, fh * upscale), Image.NEAREST)
    img.save(out_path, 'PNG', optimize=True)


def render_reconstruction(placements: list[Placement], shape: tuple[int,int],
                          out_path: Path, upscale: int = 4):
    fh, fw = shape
    canvas = np.zeros((fh, fw, 3), dtype=np.uint8)
    for p in placements:
        sub = canvas[p.y:p.y+p.sprite.h, p.x:p.x+p.sprite.w]
        m3 = np.stack([p.sprite.mask, p.sprite.mask, p.sprite.mask], axis=-1)
        sub[:] = np.where(m3, p.sprite.pixels, sub)
    img = Image.fromarray(canvas).resize((fw * upscale, fh * upscale), Image.NEAREST)
    img.save(out_path, 'PNG', optimize=True)


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------
def main():
    if len(sys.argv) < 2:
        print('Usage: python sprite_match.py FRAME_STEM [SCREEN_TYPE]')
        sys.exit(1)

    frame_stem = sys.argv[1]
    screen_type = sys.argv[2] if len(sys.argv) > 2 else 'default'

    matches = list(FRAMES.glob(f'{frame_stem}*.webp')) + \
              list(FRAMES.glob(f'{frame_stem}*.png'))
    if not matches:
        print(f'No frame matches "{frame_stem}"')
        sys.exit(1)
    frame_path = matches[0]
    print(f'Frame: {frame_path.name}')
    print(f'Screen type: {screen_type}')

    img = Image.open(frame_path).convert('RGB')
    if img.size != (320, 200):
        img = img.resize((320, 200), Image.NEAREST)
    frame = np.array(img)

    atlas_list = ATLASES_BY_SCREEN.get(screen_type, ATLASES_BY_SCREEN['default'])
    if atlas_list is None:
        atlas_list = discover_all_atlases()
    print(f'Loading {len(atlas_list)} atlases...')

    sprites: list[Sprite] = []
    for atlas in atlas_list:
        loaded = load_atlas(atlas)
        if loaded:
            sprites.extend(loaded)
    print(f'Loaded {len(sprites)} total sprites')
    if not sprites:
        sys.exit(1)

    placements, working = identify_sprites(frame, sprites,
                                           threshold=MATCH_THRESHOLD,
                                           tolerance=COLOR_TOLERANCE)

    # Per-atlas breakdown
    by_atlas = {}
    for p in placements:
        by_atlas.setdefault(p.sprite.atlas, 0)
        by_atlas[p.sprite.atlas] += 1
    print('\nSprites identified per atlas:')
    for atlas in sorted(by_atlas, key=lambda a: -by_atlas[a]):
        print(f'  {atlas:14}  {by_atlas[atlas]:4}')

    # Per-sprite breakdown (top 20)
    by_sprite = {}
    for p in placements:
        by_sprite.setdefault(p.sprite.label, 0)
        by_sprite[p.sprite.label] += 1
    print('\nTop 20 most-frequently-placed sprites:')
    for label in sorted(by_sprite, key=lambda l: -by_sprite[l])[:20]:
        print(f'  {label:24}  x{by_sprite[label]}')

    # Outputs
    annotate_overlay(frame, placements, OUT_DIR / f'{frame_stem}_sprites.png')
    render_blackout(working, OUT_DIR / f'{frame_stem}_blackout.png')
    render_reconstruction(placements, frame.shape[:2],
                          OUT_DIR / f'{frame_stem}_reconstruct.png')

    manifest = {
        'frame': frame_path.name,
        'screen_type': screen_type,
        'threshold': MATCH_THRESHOLD,
        'tolerance': COLOR_TOLERANCE,
        'placements': [
            {'sprite': p.sprite.label, 'atlas': p.sprite.atlas,
             'x': p.x, 'y': p.y, 'w': p.sprite.w, 'h': p.sprite.h,
             'score': round(p.score, 3)}
            for p in placements
        ],
        'total': len(placements),
        'by_atlas': by_atlas,
    }
    out_json = OUT_DIR / f'{frame_stem}_sprites.json'
    out_json.write_text(json.dumps(manifest, indent=2))

    print(f'\nOutputs in {OUT_DIR.name}/:')
    print(f'  {frame_stem}_sprites.png       (overlay)')
    print(f'  {frame_stem}_blackout.png      (working frame after blackouts)')
    print(f'  {frame_stem}_reconstruct.png   (sprites only)')
    print(f'  {frame_stem}_sprites.json      (manifest)')


if __name__ == '__main__':
    main()
