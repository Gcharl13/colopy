#!/usr/bin/env python3
"""
render_king.py — Render the "Audience with the King" screen.

This is the ONE AND ONLY screen that uses FONTKING.

Per user correction:
  - Background: KINGLSS1.PIK (throne room with chair + parchment scroll)
  - King sprite from KING.SS sits ON the throne
  - Text goes ON the parchment (right side of screen,
    native x=234..315, y=10..150)

KING sprite variants (selected per game state):
  - KING.SS       — Standing king in red coat (default appointment)
  - KING1.SS      — King walking with corgi/dog (peaceful event)
  - KINGLOSE.SS   — Dejected king with dog (Revolution lost / win for player)
  - KINGWIN.SS    — King leaping back, crown thrown off
                    (Revolution won by player — King's victory dance)

Per GAME.TXT @VICEROY message format:
  Year of Our Lord <YEAR>           ; LABELS-style header
  An Audience With                  ; LABELS-style header
  The King of <NATION>              ; %COUNTRY substitute
  "For the greater glory of <NATION>, we dub thee Viceroy..."
                                    ; @VICEROY full body

Doc refs:
  - docs/SESSION_UI_CATALOG.md — KING sprite identification
  - docs/RENDERER_GEOMETRY.md — parchment text region
  - docs/GAME_TXT_CATALOG.md — @VICEROY template

Memory:
  - PowerRecord +0x01 = tax_pct (the byte the king will raise)
  - DGROUP 0x53A7 = king_anger (drives raise frequency)
"""
from __future__ import annotations

import argparse
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ASSETS = ROOT / "assets"

SCREEN_W = 320
SCREEN_H = 200

KING_TEXT_COLOR = (0, 0, 0)        # BLACK ink on parchment per user reference


def load_glyph_recolored(font_name, ascii_code, color, shadow_color=None):
    """Load a font glyph and recolor.

    1-bit fonts (FONTTINY, FONTSMAL): only idx 0+1 used; idx 1 = primary.
    2-bit fonts (FONTKING, FONTINTR, FONT-NP): idx 1=shadow, idx 3=primary.
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


def render_text(canvas, text, x, y, color, font="FONTKING"):
    """The only renderer that uses FONTKING — for the King audience screen."""
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


def render_king(state):
    from PIL import Image

    # KINGLSS1.PIK — throne room with chair + parchment scroll
    pik = ASSETS / "backgrounds" / "KINGLSS1" / "KINGLSS1.PIK.png"
    if pik.exists():
        canvas = Image.open(pik).convert("RGBA")
        if canvas.size != (SCREEN_W, SCREEN_H):
            canvas = canvas.resize((SCREEN_W, SCREEN_H), Image.LANCZOS)
    else:
        canvas = Image.new("RGBA", (SCREEN_W, SCREEN_H), (60, 30, 20, 255))

    # 2. & 3. Banner + KING1 sprite blit positions per
    # func_075352_unknown.asm at file 0x075352..0x075594.
    #
    # CITED from disasm (file 0x07541E and 0x075444):
    #   PUSH 0x64                         ; ANCHOR_X = 100 native
    #   PUSH word es:[si + 0x48]          ; sprite struct field +0x48
    #   MOV  dx, word es:[si + 0x46]      ; sprite struct field +0x46
    #   LCALL 0x181F:0x2F8                ; blit_sprite(...)
    #
    # The sprite blit anchors the sprite's CENTER X at the ANCHOR_X
    # destination coord. For native 320x200 the anchor (100, ?) puts
    # the sprite's body axis at x=100.
    #
    # The Y position is read from the sprite's runtime struct
    # (es:[si+0x48]) populated by the sprite-load helper at
    # LCALL 0x191F:0xFD0 (an overlay function not statically traced).
    # Empirically Y is set so the sprite's bottom touches the floor.
    BLIT_X = 100   # CITED: disasm PUSH 0x64 (file 0x07541E and 0x075444)

    nation = state.get("nation", "England")
    NATION_BANNER = {
        "England":     "ENGLND1",
        "France":      "FRANCE1",
        "Spain":       "SPAIN1",
        "Netherlands": "DUTCH1",
    }
    banner_sheet = NATION_BANNER.get(nation, "ENGLND1")
    banner_png = ASSETS / "sprites" / banner_sheet / f"{banner_sheet}.SS.000.png"
    if banner_png.exists():
        banner = Image.open(banner_png).convert("RGBA")
        # Anchor banner so its center is at BLIT_X
        bx = BLIT_X - banner.size[0] // 2
        canvas.paste(banner, (bx, 0), banner)

    king_png = ASSETS / "sprites" / "KING1" / "KING1.SS.000.png"
    if king_png.exists():
        king = Image.open(king_png).convert("RGBA")
        # Anchor king so its body axis is at BLIT_X = 100
        kx = BLIT_X - king.size[0] // 2
        ky = SCREEN_H - king.size[1] - 5
        canvas.paste(king, (kx, ky), king)

    # 4. Text on the parchment scroll
    # CITED from GAME.TXT @VICEROY: @x=232 @y=21 @width=78
    # The Dutch variant is @VICEROY2 (uses "Stadtholder" not "King of %COUNTRY")
    year = state.get("year", 1492)
    PARCH_X = 232    # CITED: GAME.TXT @VICEROY @x=232
    PARCH_Y = 21     # CITED: GAME.TXT @VICEROY @y=21
    PARCH_W = 78     # CITED: GAME.TXT @VICEROY @width=78
    LINE_H = 8       # FONTKING line spacing per glyph height

    def render_centered(text, y):
        text_w = measure_text(text, "FONTKING")
        x = PARCH_X + (PARCH_W - text_w) // 2
        render_text(canvas, text, x, y, KING_TEXT_COLOR, "FONTKING")

    # Per @VICEROY exact layout:
    #   ^               (blank line)
    #   ^^Year of Our Lord
    #   ^^<year>
    #   ^               (blank line)
    #   ^^An Audience With
    #   ^^The King of <country>      (or "The Stadtholder" for Netherlands)
    #   ^               (blank line)
    #   "For the greater glory of %COUNTRY, we
    #   dub thee Viceroy of the New World. Go
    #   and explore this new land. Settle it
    #   and bring wealth and glory to yourself
    #   and our nation."
    y = PARCH_Y + LINE_H  # initial blank line ^
    render_centered("Year of Our Lord", y); y += LINE_H
    render_centered(str(year), y); y += LINE_H * 2   # blank line ^
    render_centered("An Audience With", y); y += LINE_H
    if nation == "Netherlands":
        render_centered("The Stadtholder", y); y += LINE_H * 2
    else:
        render_centered(f"The King of {nation}", y); y += LINE_H * 2

    # Body lines - word-wrapped to fit 78px parchment width.
    # Source: GAME.TXT @VICEROY body (single quoted paragraph)
    # Wrap the body to fit width=78 (FONTKING ~7px avg glyph). The
    # parchment extent in KINGLSS1.PIK reaches roughly y=170 native.
    body_lines = [
        '"For the greater',
        f'glory of {nation},',
        'we dub thee',
        'Viceroy of the',
        'New World. Go',
        'and explore this',
        'new land. Settle',
        'it, and bring',
        'wealth and glory',
        'to yourself."',
    ]
    # PIXEL-MEASURED: bottom of parchment in KINGLSS1.PIK background
    # (TBD: byte-cite via the @VICEROY @y= directive + parchment-glyph
    # height in func_075352 once segment 0x0C36 is resolved).
    PARCH_BOTTOM = 168
    for line in body_lines:
        if y + LINE_H > PARCH_BOTTOM:
            break
        render_centered(line, y)
        y += LINE_H

    return canvas.convert("RGB")


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--out", type=Path,
                    default=ROOT / "verification" / "screens" / "king_audience.png")
    ap.add_argument("--nation", default="England",
                    help="Nation name from NAMES.TXT @COUNTRY: "
                         "England / France / Spain / Netherlands")
    ap.add_argument("--year", type=int, default=1492)
    ap.add_argument("--scale", type=int, default=4)
    args = ap.parse_args()
    args.out.parent.mkdir(parents=True, exist_ok=True)
    canvas = render_king({"nation": args.nation, "year": args.year})
    if args.scale > 1:
        from PIL import Image
        canvas = canvas.resize(
            (SCREEN_W * args.scale, SCREEN_H * args.scale),
            Image.NEAREST,
        )
    canvas.save(args.out)
    print(f"  wrote {args.out}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
