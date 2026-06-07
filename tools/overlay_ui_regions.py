"""
overlay_ui_regions.py — visualise the derived UI region map on captured frames.

For each screen type (gameplay, colony, europe, congress, popup, etc.) the
script draws labelled rectangles showing what we believe occupies each
pixel region. The original frame is kept underneath so the eye can verify
the math matches the pixels.

Outputs go to `reverse_engineered/verification/ui_overlays/`.

Each frame is upscaled 4× for legibility (320×200 → 1280×800).

Usage:
    python overlay_ui_regions.py            # process all reference frames
    python overlay_ui_regions.py FRAMENAME  # process one specific frame

Region colors:
    yellow   tile-grid (16 px aligned)
    cyan     sprite-bbox (variable)
    magenta  glyph-grid (text-aligned)
    red      verification anchor (known position from RENDERER_GEOMETRY.md)
"""
from __future__ import annotations

import os
import sys
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont

ROOT = Path(r'c:/Users/gregc/OneDrive/Desktop/COLOPY')
FRAMES = ROOT / 'reverse_engineered' / 'session_1777952458' / 'frames'
OUT = ROOT / 'reverse_engineered' / 'verification' / 'ui_overlays'
OUT.mkdir(parents=True, exist_ok=True)

UPSCALE = 4  # 320×200 → 1280×800 for legibility

# Color codes per layout regime
C_TILE = (255, 230, 0, 220)        # yellow — tile grid
C_SPRITE = (0, 220, 230, 220)      # cyan — sprite bbox
C_GLYPH = (255, 100, 230, 220)     # magenta — glyph grid
C_ANCHOR = (255, 60, 60, 220)      # red — verification anchor
C_DIM = (255, 255, 255, 80)        # light grid lines


def make_font(size):
    candidates = [
        r'C:/Windows/Fonts/consola.ttf',
        r'C:/Windows/Fonts/cour.ttf',
        r'C:/Windows/Fonts/arial.ttf',
    ]
    for p in candidates:
        if os.path.exists(p):
            try:
                return ImageFont.truetype(p, size)
            except Exception:
                continue
    return ImageFont.load_default()


def draw_rect(draw, x, y, w, h, color, label, font, label_pos='above'):
    """Draw a labelled rectangle in upscaled coords."""
    x0 = x * UPSCALE
    y0 = y * UPSCALE
    x1 = (x + w) * UPSCALE - 1
    y1 = (y + h) * UPSCALE - 1
    draw.rectangle([x0, y0, x1, y1], outline=color, width=2)
    if label:
        # Text background pill above the rect
        if label_pos == 'above':
            tx = x0 + 4
            ty = y0 - 14
        elif label_pos == 'below':
            tx = x0 + 4
            ty = y1 + 2
        elif label_pos == 'inside':
            tx = x0 + 4
            ty = y0 + 2
        bbox = draw.textbbox((tx, ty), label, font=font)
        pad = 2
        draw.rectangle(
            [bbox[0]-pad, bbox[1]-pad, bbox[2]+pad, bbox[3]+pad],
            fill=(0, 0, 0, 200))
        draw.text((tx, ty), label, fill=color, font=font)


def draw_grid_overlay(draw, color, x_step=16, y_step=16, x0=0, y0=0,
                      x1=320, y1=200):
    """Draw a faint grid for reference."""
    for gx in range(x0, x1+1, x_step):
        draw.line([gx*UPSCALE, y0*UPSCALE, gx*UPSCALE, y1*UPSCALE],
                  fill=color, width=1)
    for gy in range(y0, y1+1, y_step):
        draw.line([x0*UPSCALE, gy*UPSCALE, x1*UPSCALE, gy*UPSCALE],
                  fill=color, width=1)


# ----------------------------------------------------------------------------
# Region definitions (one function per screen type)
# Each returns a list of (x, y, w, h, color, label, label_pos) tuples
# ----------------------------------------------------------------------------

def regions_gameplay():
    """Map view at closest zoom — TIGHT-FIT v3 2026-05-08.
    Each rectangle bounds the actual visible content, not the logical region."""
    return [
        # Top menu label strip — text glyphs only
        (0, 2, 320, 8, C_GLYPH, 'menu labels (GAME/VIEW/ORDERS/REPORTS/TRADE/CHEAT/COLONIZOPEDIA)', 'inside'),
        # Map viewport — visible portion below menu
        (0, 14, 240, 186, C_TILE, 'map viewport 240x186', 'below'),
        # Minimap (the world map in upper-right)
        (243, 20, 70, 50, C_TILE, 'minimap 70x50 (world map)', 'inside'),
        # Sidebar B: date/gold/tax (2 lines of text)
        (243, 84, 75, 22, C_GLYPH, 'date/gold/tax 2 lines', 'inside'),
        # Sidebar C: selected unit panel (Moves/Locat/Type/Skill/Orders/Terrain = 6 lines)
        (243, 116, 75, 70, C_GLYPH, 'unit panel 6 lines', 'inside'),
    ]


def regions_colony():
    """Plymouth colony screen — TIGHT-FIT v3 2026-05-08."""
    return [
        # Title bar with "Plymouth, Spring 1543, Gold: 1920¢" text
        (0, 2, 320, 8, C_GLYPH, 'title bar (Plymouth Spring Gold)', 'inside'),
        # Main scene (colony + 8 surrounding tiles, layered)
        (0, 12, 256, 136, C_TILE, 'colony+tiles scene 256x136', 'below'),
        # Buildings panel right side
        (256, 12, 64, 136, C_TILE, 'buildings panel 64x136', 'inside'),
        # Colonist working strip (sprites + production indicators)
        (0, 148, 320, 30, C_SPRITE, 'colonist working strip 320x30', 'inside'),
        # 16 stockpile cells at bottom
        *[(8 + i*19, 178, 19, 22, C_ANCHOR, '', None) for i in range(16)],
    ]


def regions_europe():
    """Europe screen — CORRECTED from overlay v1.
    Added missed transaction-dialog element."""
    return [
        # Trade banner at top
        (0, 0, 320, 8, C_GLYPH, 'trade banner 320x12 (Selling X at Y Gold:Z)', 'inside'),
        # Transaction dialog — refined: "Sold X Y at Zc/ton" / Price / Tax / Net
        (105, 11, 120, 50, C_GLYPH, 'TXN dialog 120x50 (Sold/Price/Tax/Net)', 'above'),
        # Three dock panels
        (1, 118, 70, 51, C_SPRITE, 'Expected Soon 115x14', 'above'),
        (72, 118, 70, 51, C_SPRITE, 'Bound For 100x14', 'above'),
        (143, 118, 82, 60, C_SPRITE, 'Loading 105x14', 'above'),
        # 3 buttons RECRUIT/PURCHASE/TRAIN at right column
        (281, 89, 37, 9, C_GLYPH, 'RECRUIT 40x14', 'above'),
        (281, 100, 37, 9, C_GLYPH, 'PURCHASE 40x14', 'above'),
        (281, 111, 37, 9, C_GLYPH, 'TRAIN 40x14', 'above'),
        # EXIT button
        (305, 180, 16, 20, C_ANCHOR, 'EXIT', 'inside'),
        # Stockpile strip at bottom
        (0, 180, 304, 20, C_GLYPH, '16-commodity inv (16 x 19 px)', 'inside'),
    ]


def regions_congress():
    """Continental Congress (CCBKGD) — TIGHT-FIT v3 2026-05-08."""
    return [
        # Title (centered at top)
        (60, 2, 200, 8, C_GLYPH, 'CONTINENTAL CONGRESS ACTIVITIES', 'inside'),
        # Subtitle (session info)
        (4, 12, 312, 8, C_GLYPH, '1st Cong. Session: (Brewster) (30 in 129)', 'inside'),
        # Yellow progress bar with bells
        (4, 22, 312, 8, C_ANCHOR, 'progress bar', 'above'),
        # Rebel/Tory sentiment text line
        (4, 32, 130, 8, C_GLYPH, 'Rebel Sentiment: 13%', 'above'),
        (160, 32, 130, 8, C_GLYPH, 'Tory Sentiment: 87%', 'above'),
        # Bell icons row (Liberty Bells)
        (20, 42, 280, 14, C_SPRITE, 'bell icons row', 'above'),
        # Expeditionary Force header
        (4, 58, 200, 8, C_GLYPH, 'English Expeditionary Force:', 'above'),
        # 4 REF groups
        (4, 68, 80, 24, C_SPRITE, 'REF Reg', 'below'),
        (85, 68, 80, 24, C_SPRITE, 'REF Cav', 'below'),
        (160, 68, 80, 24, C_SPRITE, 'REF Art', 'below'),
        (235, 68, 80, 24, C_SPRITE, 'REF MoW', 'below'),
        # Founding Fathers header
        (4, 100, 120, 8, C_GLYPH, 'Founding Fathers:', 'above'),
        # FF list
        (4, 110, 280, 70, C_GLYPH, 'FF list (12-px stride)', 'inside'),
        # OK button at bottom-right
        (294, 184, 22, 12, C_ANCHOR, 'OK', 'above'),
    ]


def regions_popup():
    """Banner-class popup (PRICEDOWN) — TIGHT-FIT v4.
    Speaker sprite drawn ABOVE banner; banner contains text only."""
    return [
        # MSS2 merchant speaker — figure spans head to mid-torso
        (115, 35, 100, 95, C_SPRITE, 'MSS2 merchant speaker', 'above'),
        # Banner with single-line message text
        (4, 110, 218, 38, C_GLYPH, 'banner popup 218x38', 'below'),
        # Text region inside banner (text wraps to 2 lines)
        (8, 118, 210, 26, C_GLYPH, 'wrapped text 2 lines', 'inside'),
    ]


def regions_seacolony():
    """SEACOLONY (NOOCEAN) warning popup — TIGHT-FIT v4."""
    return [
        # MSS3 explorer speaker
        (130, 35, 90, 105, C_SPRITE, 'MSS3 explorer speaker', 'above'),
        # Warning popup body
        (4, 130, 218, 68, C_GLYPH, 'warning popup 218x68', 'below'),
        # Body text (5 lines wrapping)
        (8, 134, 210, 42, C_GLYPH, 'body 5 lines', 'inside'),
        # Response option 1
        (40, 168, 180, 10, C_GLYPH, '"Oh, I forgot about that."', 'inside'),
        # Response option 2
        (16, 182, 210, 10, C_GLYPH, '"And that is exactly what I had in mind."', 'inside'),
    ]


def regions_buildmenu():
    """Build menu overlay (frame 1310206750)."""
    return [
        # Build menu modal — typically center-screen
        (40, 30, 240, 140, C_GLYPH, 'build menu modal 240×140', 'above'),
        # Title
        (40, 30, 240, 16, C_GLYPH, 'menu title', 'inside'),
        # List of options
        (48, 50, 224, 110, C_GLYPH, 'option list (small-font stride 12-14)', 'inside'),
    ]


def regions_foreign_hover():
    """Foreign-colony hover popup (frame 1310321000)."""
    return [
        (4, 110, 218, 38, C_GLYPH, 'foreign-colony popup 218×38', 'above'),
    ]


# (regions_seacolony defined above with corrected geometry)


# ----------------------------------------------------------------------------
# Frame → region-set lookup
# ----------------------------------------------------------------------------
FRAME_MAP = {
    '1310262984': ('gameplay (map view)', regions_gameplay),
    '1310196718': ('colony (Plymouth)', regions_colony),
    '1310291187': ('europe (with boycott)', regions_europe),
    '1310124562': ('continental_congress', regions_congress),
    '1310280609': ('popup PRICEDOWN', regions_popup),
    '1310261859': ('popup SEACOLONY', regions_seacolony),
    '1310321000': ('foreign_colony_hover', regions_foreign_hover),
    '1310206750': ('build_menu', regions_buildmenu),
}


def annotate_frame(frame_path: Path, screen_type: str, region_fn) -> Path:
    """Load frame, draw overlay, save annotated copy."""
    img = Image.open(frame_path).convert('RGBA')
    if img.size != (320, 200):
        # Resize to match expected; some captures may be at different resolution
        img = img.resize((320, 200), Image.NEAREST)

    # Upscale for legibility
    big = img.resize((320*UPSCALE, 200*UPSCALE), Image.NEAREST)

    # Overlay layer
    overlay = Image.new('RGBA', big.size, (0, 0, 0, 0))
    draw = ImageDraw.Draw(overlay)

    # Faint 16-px tile grid
    draw_grid_overlay(draw, C_DIM, 16, 16)

    # Title bar
    font_big = make_font(20)
    font_small = make_font(11)

    # Draw all regions
    for region in region_fn():
        if len(region) == 7:
            x, y, w, h, color, label, pos = region
        else:
            x, y, w, h, color, label, pos = region + (None,) * (7 - len(region))
        if label is None:
            continue
        draw_rect(draw, x, y, w, h, color, label or '', font_small, pos or 'above')

    # Composite
    result = Image.alpha_composite(big, overlay)

    # Add header band with frame info
    header = Image.new('RGBA', (result.size[0], 40), (20, 20, 30, 255))
    header_draw = ImageDraw.Draw(header)
    title = f'{frame_path.stem}  ·  {screen_type}'
    header_draw.text((12, 8), title, fill=(255, 255, 255, 255), font=font_big)
    header_draw.text((12, 24), 'tile-grid (yellow) · sprite-bbox (cyan) · glyph-grid (magenta) · anchor (red)',
                     fill=(180, 180, 180, 255), font=font_small)

    final = Image.new('RGBA', (result.size[0], result.size[1] + 40))
    final.paste(header, (0, 0))
    final.paste(result, (0, 40))

    out_path = OUT / f'{frame_path.stem}_overlay.png'
    final.convert('RGB').save(out_path, 'PNG', optimize=True)
    return out_path


def main():
    if len(sys.argv) > 1:
        targets = [sys.argv[1]]
    else:
        targets = list(FRAME_MAP.keys())

    results = []
    for stem in targets:
        # Find the actual file
        matches = list(FRAMES.glob(f'{stem}*.webp')) + list(FRAMES.glob(f'{stem}*.png'))
        if not matches:
            print(f'  [skip] no frame matches "{stem}"')
            continue
        frame_path = matches[0]
        if stem not in FRAME_MAP:
            # Try by filename match
            print(f'  [skip] frame {stem} not in FRAME_MAP — add a region function')
            continue
        screen_type, region_fn = FRAME_MAP[stem]
        out_path = annotate_frame(frame_path, screen_type, region_fn)
        results.append((stem, screen_type, out_path))
        print(f'  [ok] {stem} ({screen_type}) -> {out_path.name}')

    print(f'\nGenerated {len(results)} overlays in:')
    print(f'  {OUT}')


if __name__ == '__main__':
    main()
