#!/usr/bin/env python3
"""
render_dialog.py — Compose a UI dialog from extracted assets.

Pixel-verified composition (per acaab.../b6235...jpg dialog screenshots):
  - Background: WOODPANL.PIK or WOODPAN2.PIK tiled across the rect
  - Frame: WOODFRAM.SS at borders (or just outline)
  - Title strip: NAMEPLAT.SS at top
  - Body text: FONTTINY in green (80, 144, 48)
  - Title text: FONTTINY in yellow (200, 160, 24)
  - Optional sprite previews: KING.SS for diplomats, ICONS.SS for unit dialogs,
    CC-NN.SS for Founding Father dialogs

All fonts/colors derived from pixel sample of DOSBox screenshots.
"""
from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ASSETS = ROOT / "assets"

# Pixel-verified dialog colors. Re-sampled from DOSBox acaab05 (diplomatic)
# and b6235e (Cibola) on 2026-05-04: dialog body text is a brighter yellow-
# green than initially measured. Highlighted variables (yellow) sit above
# the body color for contrast.
DIALOG_TITLE_YELLOW = (240, 200, 40)   # brighter yellow for highlights
DIALOG_BODY_GREEN   = (140, 200, 100)  # bright yellow-green body


def load_sprite(sheet_name: str, frame_idx: int):
    from PIL import Image
    sheet_dir = ASSETS / "sprites" / sheet_name
    fpath = sheet_dir / f"{sheet_name}.SS.{frame_idx:03d}.png"
    if not fpath.exists():
        return None
    return Image.open(fpath).convert("RGBA")


def load_glyph_recolored(font_name, ascii_code, color, shadow_color=None):
    """Load a font glyph and recolor.

    Detects 1-bit vs 2-bit fonts:
      1-bit (FONTTINY, FONTSMAL): only idx 0+1 used; idx 1 = primary color
      2-bit (FONTKING, FONTINTR, FONT-NP): idx 0/1/2/3 used; idx 3 = primary,
        idx 1 = shadow, idx 2 = mid
    """
    from PIL import Image
    fpath = ASSETS / "fonts" / font_name / f"{font_name}.FF.{ascii_code:03d}.png"
    if not fpath.exists():
        return None
    glyph = Image.open(fpath)
    if shadow_color is None:
        shadow_color = (color[0] // 3, color[1] // 3, color[2] // 4)
    if glyph.mode != "P":
        return glyph.convert("RGBA")
    gw, gh = glyph.size
    new = Image.new("RGBA", (gw, gh), (0, 0, 0, 0))
    src = glyph.load()
    dst = new.load()
    # Determine if this is a 1-bit font (only idx 0 and 1 used)
    indices_used = set()
    for py in range(gh):
        for px in range(gw):
            indices_used.add(src[px, py])
    is_one_bit = (3 not in indices_used and 2 not in indices_used)

    for py in range(gh):
        for px in range(gw):
            idx = src[px, py]
            if is_one_bit:
                if idx == 1:
                    dst[px, py] = (*color, 255)
            else:
                if idx == 3:
                    dst[px, py] = (*color, 255)
                elif idx == 1:
                    dst[px, py] = (*shadow_color, 255)
                elif idx == 2:
                    mid = ((color[0] + shadow_color[0]) // 2,
                           (color[1] + shadow_color[1]) // 2,
                           (color[2] + shadow_color[2]) // 2)
                    dst[px, py] = (*mid, 255)
    return new



def measure_text(text, font, spacing=1):
    from PIL import Image
    total = 0
    for ch in text:
        if ch == " ":
            total += 3
            continue
        ascii_code = ord(ch)
        fpath = ASSETS / "fonts" / font / f"{font}.FF.{ascii_code:03d}.png"
        if fpath.exists():
            g = Image.open(fpath)
            total += g.size[0] + spacing
        else:
            total += 4
    return total


def load_pik(pik_name: str):
    from PIL import Image
    bg_dir = ASSETS / "backgrounds" / pik_name
    if not bg_dir.is_dir():
        return None
    pngs = sorted(bg_dir.glob("*.png"))
    pngs = [p for p in pngs if "pal" not in p.stem.lower()]
    if not pngs:
        return None
    return Image.open(pngs[0]).convert("RGBA")


def render_text(canvas, text, font, x, y, color):
    cur_x = x
    for ch in text:
        if ch == " ":
            cur_x += 3
            continue
        ascii_code = ord(ch)
        glyph = load_glyph_recolored(font, ascii_code, color)
        if glyph is None:
            cur_x += 4
            continue
        canvas.paste(glyph, (cur_x, y), glyph)
        cur_x += glyph.size[0] + 1
    return cur_x


SCREEN_W = 320
SCREEN_H = 200


def render_dialog(definition: dict):
    """
    Render a dialog ON A 320x200 SCREEN CANVAS.

    The dialog box itself is a smaller window placed on the screen
    (centered or per @x/@y from GAME.TXT). The screen behind it is
    either dim/transparent, or a supplied background.

    Definition schema:
    {
        "dialog_w":  190,                  # text/content width per GAME.TXT @width
        "dialog_h":  100,                  # height (auto from body_lines if omitted)
        "dialog_x":  null,                 # explicit X (else centered horizontally)
        "dialog_y":  null,                 # explicit Y (else centered vertically)
        "screen_bg": "WOODTILE"|"OPENMENU"|"<PIK>"|null,  # screen background
        "frame":     true,                 # draw 3-line carved wood frame
        "fill":      "WOODPANL",          # PIK to fill dialog body (cropped)
        "nameplate": "NAMEPLAT",          # sprite for title strip (or null)
        "title":     "Tax Demand",
        "body_lines": [...],
        "preview_sprite": ["KING", 0],    # portrait sprite
        "preview_pos":    [x, y],         # absolute screen position
        "substitutions": {"%STRING0": "Cherokee"},
    }

    The 274x170 WOODFRAM.SS frame is too coarse a granularity; instead
    we render an arbitrary-sized window using a 3-line carved-wood
    border (matching the b6235e popup style) plus WOODPANL crop fill.
    """
    from PIL import Image, ImageDraw
    canvas = Image.new("RGBA", (SCREEN_W, SCREEN_H), (0, 0, 0, 255))

    # Optional screen background behind the dialog (e.g. WOODTILE for
    # menu-style screens, gameplay snapshot for in-game popups)
    screen_bg = definition.get("screen_bg")
    if screen_bg:
        bg = load_pik(screen_bg)
        if bg:
            if bg.size == (SCREEN_W, SCREEN_H):
                canvas.paste(bg, (0, 0))
            else:
                # Tile to fill
                for ty in range(0, SCREEN_H, max(bg.size[1], 1)):
                    for tx in range(0, SCREEN_W, max(bg.size[0], 1)):
                        canvas.paste(bg, (tx, ty))
        else:
            # Try as sprite (e.g. WOODTILE)
            tile = load_sprite(screen_bg, 0)
            if tile:
                for ty in range(0, SCREEN_H, max(tile.size[1], 1)):
                    for tx in range(0, SCREEN_W, max(tile.size[0], 1)):
                        canvas.paste(tile, (tx, ty), tile)

    # Dialog box geometry
    dialog_w = definition.get("dialog_w", 190)
    dialog_h = definition.get("dialog_h", 100)
    dialog_x = definition.get("dialog_x")
    dialog_y = definition.get("dialog_y")
    if dialog_x is None:
        dialog_x = (SCREEN_W - dialog_w) // 2
    if dialog_y is None:
        dialog_y = (SCREEN_H - dialog_h) // 2

    # Fill the dialog rectangle with WOODPANL.PIK (cropped/tiled)
    fill_pik = definition.get("fill", "WOODPANL")
    if fill_pik:
        bg = load_pik(fill_pik)
        if bg:
            if bg.size[0] >= dialog_w and bg.size[1] >= dialog_h:
                # Crop a region from the PIK (center-ish to skip its frame border)
                cx = (bg.size[0] - dialog_w) // 2
                cy = (bg.size[1] - dialog_h) // 2
                canvas.paste(bg.crop((cx, cy, cx + dialog_w, cy + dialog_h)),
                             (dialog_x, dialog_y))
            else:
                for ty in range(dialog_y, dialog_y + dialog_h, max(bg.size[1], 1)):
                    for tx in range(dialog_x, dialog_x + dialog_w, max(bg.size[0], 1)):
                        paste_w = min(bg.size[0], dialog_x + dialog_w - tx)
                        paste_h = min(bg.size[1], dialog_y + dialog_h - ty)
                        if paste_w > 0 and paste_h > 0:
                            canvas.paste(bg.crop((0, 0, paste_w, paste_h)),
                                         (tx, ty))

    # 3-line carved wood frame (matches b6235e popup style)
    if definition.get("frame", True):
        draw = ImageDraw.Draw(canvas)
        x0, y0 = dialog_x, dialog_y
        x1, y1 = dialog_x + dialog_w - 1, dialog_y + dialog_h - 1
        draw.rectangle([(x0, y0), (x1, y1)],
                       outline=(40, 20, 12), width=1)
        draw.rectangle([(x0 + 1, y0 + 1), (x1 - 1, y1 - 1)],
                       outline=(140, 90, 50), width=1)
        draw.rectangle([(x0 + 2, y0 + 2), (x1 - 2, y1 - 2)],
                       outline=(80, 50, 30), width=1)

    # Optional NAMEPLAT title strip (tile horizontally to fit dialog width)
    nameplate = definition.get("nameplate")
    if nameplate:
        np_sprite = load_sprite(nameplate, 0)
        if np_sprite:
            np_inset = 14    # nameplate sticks above/below middle area
            np_y = dialog_y + 4
            np_w = dialog_w - 24
            np_x = dialog_x + 12
            for tx in range(np_x, np_x + np_w, max(np_sprite.size[0], 1)):
                paste_w = min(np_sprite.size[0], np_x + np_w - tx)
                if paste_w > 0:
                    canvas.paste(np_sprite.crop((0, 0, paste_w, np_sprite.size[1])),
                                 (tx, np_y), np_sprite.crop((0, 0, paste_w, np_sprite.size[1])))

    # Title text — yellow centered (on or near top)
    title = definition.get("title", "")
    title_font = definition.get("title_font", "FONTTINY")
    text_y_start = dialog_y + 6
    if title:
        title_w = measure_text(title, title_font)
        title_x = dialog_x + (dialog_w - title_w) // 2
        render_text(canvas, title, title_font, title_x, dialog_y + 4,
                    DIALOG_TITLE_YELLOW)
        text_y_start = dialog_y + 14

    # Body text — green with yellow highlights for {braces} + %VARS
    import re
    body_font = definition.get("font", "FONTTINY")
    body_color = DIALOG_BODY_GREEN
    var_color = DIALOG_TITLE_YELLOW
    text_x = dialog_x + 6
    y = text_y_start
    pattern = re.compile(r'(\{[^}]+\}|%STRING\d+|%NUMBER\d+|%COUNTRY|%YEAR|%[A-Z]+\d*\$?)')
    for line in definition.get("body_lines", []):
        # Substitute supplied %VARS first
        for k, v in definition.get("substitutions", {}).items():
            line = line.replace(k, str(v))
        cur_x = text_x
        for part in pattern.split(line):
            if not part:
                continue
            if part.startswith('{') and part.endswith('}'):
                color = var_color
                text_to_render = part[1:-1]
            elif part.startswith('%'):
                color = var_color
                text_to_render = part
            else:
                color = body_color
                text_to_render = part
            for ch in text_to_render:
                if ch == " ":
                    cur_x += 3
                    continue
                ascii_code = ord(ch)
                glyph = load_glyph_recolored(body_font, ascii_code, color)
                if glyph is None:
                    cur_x += 4
                    continue
                canvas.paste(glyph, (cur_x, y), glyph)
                cur_x += glyph.size[0] + 1
        y += 9

    # Preview sprite (king portrait, founding father, etc.)
    # Position is absolute screen coords — typically extends ABOVE the
    # dialog box, with the bottom edge clipping into the box top by 5px.
    preview = definition.get("preview_sprite")
    pos = definition.get("preview_pos")
    if preview:
        sprite = load_sprite(preview[0], preview[1])
        if sprite:
            if pos is None:
                # Default: centered horizontally, anchored above popup
                # so sprite bottom = popup top + 5px overlap. The
                # sprite may extend above y=0 (and be clipped by the
                # canvas) — that's intentional for tall full-body
                # sprites like KING.SS where only the upper torso
                # should remain visible.
                ex = dialog_x + (dialog_w - sprite.size[0]) // 2
                ey = dialog_y - sprite.size[1] + 5
                pos = [ex, ey]
            # PIL paste with negative y crops the sprite to canvas bounds
            canvas.paste(sprite, tuple(pos), sprite)

    return canvas


# Example dialogs sized per GAME.TXT @width directives. Each dialog
# is rendered on a 320x200 SCREEN canvas with a smaller dialog window
# centered (or per @x/@y) on top of a darker background.
EXAMPLE_DIALOGS = {
    # @KINGTAX width=190 (GAME.TXT line 1623). King speaks via KING.SS
    # half-figure portrait that overhangs the dialog box.
    "king_tax": {
        "dialog_w": 198,
        "dialog_h": 70,
        "dialog_y": 122,
        "screen_bg": "WOODTILE",
        "fill": "WOODPANL",
        "frame": True,
        "nameplate": None,
        "title": "",
        "body_lines": [
            '"It is essential that the',
            'Crown receive proper',
            'recompense. We raise your',
            'tax by {5%}.  Rate is now',
            '{17%}.  Kiss our royal',
            'pinky ring."',
        ],
        "font": "FONTTINY",
        "preview_sprite": ["KING", 0],
        # auto-anchor: bottom-of-sprite clips into popup top by 5px
    },
    # FF acquired uses CCBKGD as full-screen background plus dialog
    # box overlaying the bottom half (matches the in-game CC screen).
    "ff_acquired": {
        "dialog_w": 240,
        "dialog_h": 80,
        "dialog_y": 110,
        "screen_bg": "CCBKGD",
        "fill": "WOODPANL",
        "frame": True,
        "nameplate": None,
        "title": "Adam Smith joins!",
        "body_lines": [
            "Your Continental Congress",
            "welcomes a new Father.",
            "Each colony with a Factory",
            "produces {+50%} manufactured goods.",
        ],
        "font": "FONTTINY",
        "preview_sprite": ["CC-00", 0],
        # CC-00 stands on the balcony above-left of the dialog
        "preview_pos": [10, 30],
    },
    # @CHIEFKILL width=190 (GAME.TXT line 1321). 3 lines × 9 + padding ≈ 50px.
    "raze": {
        "dialog_w": 198,
        "dialog_h": 50,
        "screen_bg": "WOODTILE",
        "fill": "WOODPANL",
        "frame": True,
        "nameplate": None,
        "title": "",
        "body_lines": [
            '"You have broken sacred',
            'taboos of the {Aztec} tribe!',
            'Tie you up for target practice."',
        ],
        "font": "FONTTINY",
    },
    # @HAVETREATY width=190 — diplomatic exchange. Per DOSBox acaab05 the
    # full conversation has 3 rounds: foreign demand, player response,
    # foreign acknowledgement. Each round in its own sub-box on a single
    # tall popup background.
    # MYR1 = European diplomat / gentleman half-figure portrait.
    "diplomatic": {
        "dialog_w": 280,
        "dialog_h": 80,
        "dialog_y": 110,
        "screen_bg": "WOODTILE",
        "fill": "WOODPANL",
        "frame": True,
        "nameplate": None,
        "title": "",
        "body_lines": [
            '"Our Queen is most displeased with the {Spanish} pirates',
            'lying in wait off the coast of New England. We demand',
            'that you withdraw all privateers immediately."',
            '"What pirates? We have {NEVER} condoned piracy!"',
            '"Very well, we shall withdraw our privateers to Europe."',
        ],
        "font": "FONTTINY",
        "preview_sprite": ["MYR1", 0],
        # auto-anchor: bottom of MYR1 clips into popup top
    },
    # @LOSTCITY2 width=190 — Cibola event uses MSS3.SS half-figure
    # scout-with-rifle (user-confirmed; see GAME.TXT line 646).
    "cibola": {
        "dialog_w": 220,
        "dialog_h": 60,
        "dialog_y": 130,
        "screen_bg": "WOODTILE",
        "fill": "WOODPANL",
        "frame": True,
        "nameplate": None,
        "title": "",
        "body_lines": [
            "You have found one of the",
            "{Seven Cities of Cibola}!",
            "Treasure worth {6000$} unearthed!",
            "Need a Galleon to ship to Europe!",
        ],
        "font": "FONTTINY",
        "preview_sprite": ["MSS3", 0],
        # auto-anchor: scout torso clips into popup top
    },
    # @WHACKINDIANS width=190 — Yes/No prompt with native chief speaker
    # (MYR0 = Native chief in feathered headdress + red blanket).
    "cherokee_attack": {
        "dialog_w": 198,
        "dialog_h": 60,
        "screen_bg": "WOODTILE",
        "fill": "WOODPANL",
        "frame": True,
        "nameplate": None,
        "title": "",
        "body_lines": [
            "Shall we attack the {Cherokee},",
            "Your Excellency?",
            "",
            "Yes",
            "No",
        ],
        "font": "FONTTINY",
        "title_font": "FONTTINY",
        "preview_sprite": ["MYR0", 0],
        # auto-anchor: chief torso clips into popup top
    },
}


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--def", dest="definition", type=Path,
                    help="JSON dialog definition file")
    ap.add_argument("--out", type=Path,
                    default=ROOT / "verification" / "dialogs" / "dialog.png")
    ap.add_argument("--example", choices=list(EXAMPLE_DIALOGS.keys()),
                    help="Render a built-in example dialog")
    ap.add_argument("--all-examples", action="store_true",
                    help="Render all example dialogs to verification/dialogs/")
    ap.add_argument("--scale", type=int, default=4)
    args = ap.parse_args()

    try:
        from PIL import Image
    except ImportError:
        print("PIL/Pillow required", file=sys.stderr)
        return 1

    args.out.parent.mkdir(parents=True, exist_ok=True)

    def write(canvas, out_path):
        if args.scale > 1:
            canvas = canvas.resize(
                (canvas.size[0] * args.scale, canvas.size[1] * args.scale),
                Image.NEAREST,
            )
        canvas.save(out_path)

    if args.all_examples:
        for name, d in EXAMPLE_DIALOGS.items():
            canvas = render_dialog(d)
            out_path = args.out.parent / f"example_{name}.png"
            write(canvas, out_path)
            print(f"  rendered example_{name} -> {out_path}")
        return 0

    if args.example:
        canvas = render_dialog(EXAMPLE_DIALOGS[args.example])
        write(canvas, args.out)
        print(f"  rendered {args.example} -> {args.out}")
        return 0

    if args.definition:
        d = json.loads(args.definition.read_text())
        canvas = render_dialog(d)
        write(canvas, args.out)
        print(f"  rendered {args.definition.stem} -> {args.out}")
        return 0

    ap.print_help()
    return 1


if __name__ == "__main__":
    sys.exit(main())
