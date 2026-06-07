#!/usr/bin/env python3
"""
render_map_popup.py — Render map-view popup message boxes.

Real messages extracted directly from COLONIZE/GAME.TXT — NOT made up.
Each message section in GAME.TXT uses {braces} around variables and
highlighted phrases that the game renders in YELLOW; the surrounding
body text is GREEN.

Per pixel verification of acaab05.../b6235e... DOSBox screenshots:
  - Popup background: WOODPANL.PIK tiled inside dark/light border
  - Body text: light green (80, 144, 48) FONTTINY
  - Variables/highlights (in {braces}): yellow (200, 160, 24) FONTTINY
  - Optional left-side ICONS.SS sprite per event type

Used for: Lost City rumors, treasure found, diplomatic messages,
combat results, native village reactions, colony events, etc.
"""
from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ASSETS = ROOT / "assets"
COLONIZE = ROOT.parent / "COLONIZE"

# Pixel-verified popup colors
POPUP_BODY_GREEN = (140, 200, 100)   # bright yellow-green body (re-sampled 2026-05-04)
POPUP_VAR_YELLOW = (240, 200, 40)    # bright yellow for {variables} + %STRING substitutions


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


def measure_char(ch, font):
    from PIL import Image
    if ch == " ":
        return 3
    fpath = ASSETS / "fonts" / font / f"{font}.FF.{ord(ch):03d}.png"
    if fpath.exists():
        g = Image.open(fpath)
        return g.size[0] + 1
    return 4


def render_text_dual(canvas, text, x, y, font="FONTTINY"):
    """Render text where {braced} portions are yellow and rest is green.

    Also handles %STRING0, %NUMBER0 etc as yellow (variable substitutions).
    """
    cur_x = x
    # Split on {brace} or %VAR
    pattern = re.compile(r'(\{[^}]+\}|%STRING\d+|%NUMBER\d+|%COUNTRY|%YEAR|%HEX\d*|%[A-Z]+\d*\$?)')
    parts = pattern.split(text)
    for part in parts:
        if not part:
            continue
        # Determine color
        if part.startswith('{') and part.endswith('}'):
            inner = part[1:-1]
            color = POPUP_VAR_YELLOW
            text_to_render = inner
        elif part.startswith('%'):
            color = POPUP_VAR_YELLOW
            text_to_render = part
        else:
            color = POPUP_BODY_GREEN
            text_to_render = part
        for ch in text_to_render:
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


def load_sprite(sheet, idx):
    from PIL import Image
    p = ASSETS / "sprites" / sheet / f"{sheet}.SS.{idx:03d}.png"
    if p.exists():
        return Image.open(p).convert("RGBA")
    return None


def parse_game_txt():
    """Parse COLONIZE/GAME.TXT into {section_name: [body_lines]}."""
    path = COLONIZE / "GAME.TXT"
    if not path.exists():
        path = Path("COLONIZE/GAME.TXT")
    with open(path, encoding='cp437') as f:
        text = f.read()
    sections = {}
    pattern = re.compile(r'\n@(\w[\w\d]*)\b\n([\s\S]*?)(?=\n@\w|\Z)')
    for name, body in pattern.findall(text):
        # Filter out property tags and just keep body lines
        lines = []
        for line in body.split('\n'):
            stripped = line.strip()
            if not stripped: continue
            if stripped.startswith('@') or stripped.startswith(';'): continue
            lines.append(line.rstrip())
        if lines:
            sections[name] = lines
    return sections


def render_popup_overlay(canvas, popup):
    """Composite a popup message box onto the gameplay screen.

    Per b6235e reference (Cibola popup):
      - Popup is in LOWER-LEFT area of the map view (not full width)
      - Popup native: x=12..240, y=130..188 approximately
      - Wood-grain bg with carved frame outline
      - NO sprite inside the popup box (text only)
      - Event sprite (big character) overlays the map ABOVE the popup,
        rendered as a separate pre-popup layer on the gameplay canvas
    """
    from PIL import Image, ImageDraw

    # Native popup dimensions per b6235e reference pixel sample
    px = popup.get("x", 12)
    py = popup.get("y", 130)
    pw = popup.get("w", 230)
    ph = popup.get("h", 60)

    # Optional event sprite ABOVE/BEHIND the popup (separate from popup body)
    event_sprite_def = popup.get("event_sprite")
    if event_sprite_def:
        sheet, idx = event_sprite_def
        sprite = load_sprite(sheet, idx)
        if sprite:
            esx = popup.get("event_sprite_x", px + 80)
            esy = popup.get("event_sprite_y", max(8, py - sprite.size[1] + 10))
            canvas.paste(sprite, (esx, esy), sprite)

    # Wood-grain background tiled
    woodpanl_pik = ASSETS / "backgrounds" / "WOODPANL" / "WOODPANL.PIK.png"
    if woodpanl_pik.exists():
        bg = Image.open(woodpanl_pik).convert("RGBA")
        for ty in range(py, py + ph, max(bg.size[1], 1)):
            for tx in range(px, px + pw, max(bg.size[0], 1)):
                paste_w = min(bg.size[0], px + pw - tx)
                paste_h = min(bg.size[1], py + ph - ty)
                if paste_w > 0 and paste_h > 0:
                    canvas.paste(bg.crop((0, 0, paste_w, paste_h)), (tx, ty))

    # Wood-frame border (carved-frame look: dark outer, light inner)
    draw = ImageDraw.Draw(canvas)
    draw.rectangle([(px, py), (px + pw - 1, py + ph - 1)],
                   outline=(40, 20, 12), width=1)
    draw.rectangle([(px + 1, py + 1), (px + pw - 2, py + ph - 2)],
                   outline=(140, 90, 50), width=1)
    draw.rectangle([(px + 2, py + 2), (px + pw - 3, py + ph - 3)],
                   outline=(80, 50, 30), width=1)

    # Body text — dual-color (green body + yellow {braces} + %VARS)
    # NO sprite icon inside the popup per reference
    text_x = px + 6
    body = popup.get("body", [])
    cur_y = py + 5
    for line in body:
        for k, v in popup.get("substitutions", {}).items():
            line = line.replace(k, str(v))
        render_text_dual(canvas, line, text_x, cur_y, "FONTTINY")
        cur_y += 7

    return canvas


# Two distinct sprite-sheet categories for popup illustrations:
#
# (A) MSS0..5 + MYR0..3 — half-figure CHARACTER portraits.
#     These are upper-body portraits designed to OVERLAY a popup box;
#     the lower body is intentionally clipped ("half cut off"). These
#     are the canonical event-speaker sprites used by the game when a
#     specific character delivers the message.
#       MSS0 = Continental military officer (blue + epaulets)
#       MSS1 = Pioneer / colonist with rifle (tricorn hat)
#       MSS2 = Merchant / jester (purple feathered cap)
#       MSS3 = Scout / explorer with rifle (Cibola)
#       MSS4 = Bishop / clergyman (purple hat with cross)
#       MSS5 = Nun / sister (white wimple)
#       MYR0 = Native chief (feathered headdress + red blanket)
#       MYR1 = Diplomat / European gentleman (powdered wig, navy coat)
#       MYR2 = Cardinal / dark-robed cleric (gold sash)
#       MYR3 = Statesman / Founding Father type (orange coat, spectacles)
#
# (B) WDCUT01..13 — large woodcut SCENE illustrations.
#     These depict events/scenes (no specific speaker).
#       01 = A NEW WORLD                      (caravel + flag)
#       02 = DISCOVERY OF THE NEW WORLD       (chief / villager)
#       03 = BUILDING A COLONY                (pioneers working)
#       04 = MEETING THE NATIVES              (Aztec royalty)
#       05 = THE AZTEC EMPIRE                 (Inca royals + llamas)
#       06 = THE INCA NATION                  (conquistador planting flag)
#       07 = DISCOVERY OF THE PACIFIC OCEAN   (scout viewing village)
#       08 = ENTERING INDIAN VILLAGE          (jungle scene)
#       09 = THE FOUNTAIN OF YOUTH            (pirates on ship deck)
#       10 = CARGO FROM THE NEW WORLD         (battle / soldiers)
#       11 = MEETING FELLOW EUROPEANS         (ruins / abandoned city)
#       12 = COLONY BURNING                   (burning village)
#       13 = COLONY DESTROYED                 (warriors attacking)
def big_sprite(sheet, x, y):
    """Helper to spec a large MSS/MYR/WDCUT sprite layer."""
    return {"sheet": sheet, "frame": 0, "x": x, "y": y}


# Real popups loaded from GAME.TXT — NOT made up
def build_popup_examples():
    """Build popup definitions from real GAME.TXT sections."""
    sections = parse_game_txt()
    examples = {}

    # Popup geometry — pixel-measured directly from the b6235e
    # DOSBox capture (the canonical Cibola popup the user provided).
    # 532x336 capture / 1.66x scale → native 320x200.
    # Popup native rect: x=4..222, y=110..148 (within playing area;
    # right edge stops before sidebar at x=222).
    # The character sprite sits ABOVE this rect with its bottom edge
    # clipping into popup top by 5 px.
    POPUP_X = 4
    POPUP_Y = 110
    POPUP_W = 218
    POPUP_H = 38

    # Helper: compute event-sprite position so its bottom edge clips
    # into the popup top by 5 px, horizontally centered over the popup.
    # Pass sprite size (w, h) and get back (x, y) to paste at.
    def anchor_above_popup(sw, sh, overlap=5):
        ex = POPUP_X + (POPUP_W - sw) // 2
        ey = POPUP_Y - sh + overlap
        return ex, max(0, ey)

    # Sprite size lookup (cached at module load). Hard-coded from
    # measured PNG dimensions to avoid PIL load cost in the catalog.
    SPRITE_SIZES = {
        ("MSS0", 0): (75, 91),   ("MSS1", 0): (72, 139),
        ("MSS2", 0): (122, 84),  ("MSS3", 0): (149, 95),
        ("MSS4", 0): (93, 59),   ("MSS5", 0): (60, 68),
        ("MYR0", 0): (96, 93),   ("MYR1", 0): (67, 85),
        ("MYR2", 0): (74, 73),   ("MYR3", 0): (74, 68),
        ("KING", 0): (60, 100),
        ("KING1", 0): (189, 187),
        ("WDCUT12", 0): (150, 90),
        ("WDCUT13", 0): (150, 90),
    }

    def position_event(sheet, frame=0):
        sw, sh = SPRITE_SIZES.get((sheet, frame), (96, 90))
        return anchor_above_popup(sw, sh)

    # @LOSTCITY2 — Cibola scout (user-confirmed: MSS3.SS.000 is the
    # canonical sprite for this event)
    if "LOSTCITY2" in sections:
        ex, ey = position_event("MSS3")
        examples["lostcity2_cibola"] = {
            "x": POPUP_X, "y": POPUP_Y, "w": POPUP_W, "h": POPUP_H,
            "event_sprite": ["MSS3", 0],
            "event_sprite_x": ex, "event_sprite_y": ey,
            "body": sections["LOSTCITY2"],
            "substitutions": {"%NUMBER1": "6000"},
            "_source": "@LOSTCITY2",
        }

    # @LOSTCITY1 — Fountain of Youth (use scout/explorer figure)
    if "LOSTCITY1" in sections:
        ex, ey = position_event("MSS3")
        examples["lostcity1_fountain"] = {
            "x": POPUP_X, "y": POPUP_Y, "w": POPUP_W, "h": POPUP_H,
            "event_sprite": ["MSS3", 0],
            "event_sprite_x": ex, "event_sprite_y": ey,
            "body": sections["LOSTCITY1"],
            "substitutions": {},
            "_source": "@LOSTCITY1",
        }

    # @KINGTAX — king (KING.SS standing)
    if "KINGTAX" in sections:
        ex, ey = position_event("KING")
        examples["kingtax"] = {
            "x": POPUP_X, "y": POPUP_Y, "w": POPUP_W, "h": POPUP_H,
            "event_sprite": ["KING", 0],
            "event_sprite_x": ex, "event_sprite_y": ey,
            "body": sections["KINGTAX"],
            "substitutions": {"%NUMBER0": "5", "%NUMBER1": "17"},
            "_source": "@KINGTAX",
        }

    # @INDIANWAR — chief speaks (MYR0 = native chief half-figure)
    if "INDIANWAR" in sections:
        ex, ey = position_event("MYR0")
        examples["indianwar"] = {
            "x": POPUP_X, "y": POPUP_Y, "w": POPUP_W, "h": POPUP_H,
            "event_sprite": ["MYR0", 0],
            "event_sprite_x": ex, "event_sprite_y": ey,
            "body": sections["INDIANWAR"],
            "substitutions": {"%STRING0": "Cherokee"},
            "_source": "@INDIANWAR",
        }

    # @INDIANPEACE — chief speaks
    if "INDIANPEACE" in sections:
        ex, ey = position_event("MYR0")
        examples["indianpeace"] = {
            "x": POPUP_X, "y": POPUP_Y, "w": POPUP_W, "h": POPUP_H,
            "event_sprite": ["MYR0", 0],
            "event_sprite_x": ex, "event_sprite_y": ey,
            "body": sections["INDIANPEACE"],
            "substitutions": {"%STRING0": "Cherokee", "%STRING1": "English"},
            "_source": "@INDIANPEACE",
        }

    # @CHIEFAREA — scout reports to chief
    if "CHIEFAREA" in sections:
        ex, ey = position_event("MYR0")
        examples["chiefarea"] = {
            "x": POPUP_X, "y": POPUP_Y, "w": POPUP_W, "h": POPUP_H,
            "event_sprite": ["MYR0", 0],
            "event_sprite_x": ex, "event_sprite_y": ey,
            "body": sections["CHIEFAREA"],
            "substitutions": {"%STRING0": "Cherokee"},
            "_source": "@CHIEFAREA",
        }

    # @RAIDBURN — scene event (no speaker), use WDCUT12 burning-village
    if "RAIDBURN" in sections:
        ex, ey = position_event("WDCUT12")
        examples["raidburn"] = {
            "x": POPUP_X, "y": POPUP_Y, "w": POPUP_W, "h": POPUP_H,
            "event_sprite": ["WDCUT12", 0],
            "event_sprite_x": ex, "event_sprite_y": ey,
            "body": sections["RAIDBURN"],
            "substitutions": {
                "%STRING0": "Cherokee",
                "%STRING1": "Roanoke",
                "%STRING2": "Stockade",
            },
            "_source": "@RAIDBURN",
        }

    # @DECLAREWAR — diplomat / European gentleman (MYR1)
    if "DECLAREWAR" in sections:
        ex, ey = position_event("MYR1")
        examples["declarewar"] = {
            "x": POPUP_X, "y": POPUP_Y, "w": POPUP_W, "h": POPUP_H,
            "event_sprite": ["MYR1", 0],
            "event_sprite_x": ex, "event_sprite_y": ey,
            "body": sections["DECLAREWAR"],
            "substitutions": {"%STRING0": "English", "%STRING1": "Spanish"},
            "_source": "@DECLAREWAR",
        }

    # @CASHTREASURE — pioneer/colonist with rifle
    if "CASHTREASURE" in sections:
        ex, ey = position_event("MSS1")
        examples["cashtreasure"] = {
            "x": POPUP_X, "y": POPUP_Y, "w": POPUP_W, "h": POPUP_H,
            "event_sprite": ["MSS1", 0],
            "event_sprite_x": ex, "event_sprite_y": ey,
            "body": sections["CASHTREASURE"],
            "substitutions": {"%NUMBER0": "5840"},
            "_source": "@CASHTREASURE",
        }

    # @PRICEDOWN — merchant announces price drop (USER-VERIFIED 2026-05-04
    # at frame 1310280609: MSS2 merchant in purple feathered cap)
    if "PRICEDOWN" in sections:
        ex, ey = position_event("MSS2")
        examples["pricedown"] = {
            "x": POPUP_X, "y": POPUP_Y, "w": POPUP_W, "h": POPUP_H,
            "event_sprite": ["MSS2", 0],
            "event_sprite_x": ex, "event_sprite_y": ey,
            "body": sections["PRICEDOWN"],
            "substitutions": {"%STRING0": "Sugar", "%STRING1": "London", "%NUMBER0": "17"},
            "_source": "@PRICEDOWN",
        }

    # @PRICEUP — merchant announces price rise (same MSS2 sprite)
    if "PRICEUP" in sections:
        ex, ey = position_event("MSS2")
        examples["priceup"] = {
            "x": POPUP_X, "y": POPUP_Y, "w": POPUP_W, "h": POPUP_H,
            "event_sprite": ["MSS2", 0],
            "event_sprite_x": ex, "event_sprite_y": ey,
            "body": sections["PRICEUP"],
            "substitutions": {"%STRING0": "Sugar", "%STRING1": "London", "%NUMBER0": "23"},
            "_source": "@PRICEUP",
        }

    # @SEACOLONY warning ("not adjacent to ocean") — MSS3 pioneer with rifle
    # USER-VERIFIED 2026-05-04 frame 1310261859: MSS3 sprite, 2-option dialog
    if "SEACOLONY" in sections:
        ex, ey = position_event("MSS3")
        examples["seacolony_warning"] = {
            "x": POPUP_X, "y": POPUP_Y, "w": POPUP_W, "h": POPUP_H,
            "event_sprite": ["MSS3", 0],
            "event_sprite_x": ex, "event_sprite_y": ey,
            "body": sections["SEACOLONY"],
            "substitutions": {},
            "_source": "@SEACOLONY",
        }

    return examples


def render_map_popup(name, examples):
    """Render gameplay screen with popup overlay."""
    import subprocess
    from PIL import Image
    gameplay_path = ROOT / "verification" / "gameplay" / "gameplay.png"
    # Re-render gameplay at native scale
    subprocess.run(
        [sys.executable, str(Path(__file__).parent / "render_gameplay.py"),
         "--scale", "1"],
        capture_output=True
    )
    canvas = Image.open(gameplay_path).convert("RGBA")
    if name not in examples:
        raise KeyError(f"Unknown popup: {name}")
    canvas = render_popup_overlay(canvas, examples[name])
    return canvas


def main():
    examples = build_popup_examples()

    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--example", choices=list(examples.keys()))
    ap.add_argument("--list", action="store_true")
    ap.add_argument("--all-examples", action="store_true")
    ap.add_argument("--out", type=Path,
                    default=ROOT / "verification" / "popups" / "popup.png")
    ap.add_argument("--scale", type=int, default=4)
    args = ap.parse_args()
    args.out.parent.mkdir(parents=True, exist_ok=True)

    if args.list:
        for name, popup in examples.items():
            print(f'  {name}: {popup.get("_source")}')
        return 0

    def write(canvas, out_path):
        if args.scale > 1:
            from PIL import Image
            canvas = canvas.resize(
                (canvas.size[0] * args.scale, canvas.size[1] * args.scale),
                Image.NEAREST,
            )
        canvas.convert("RGB").save(out_path)

    if args.all_examples:
        for name in examples:
            canvas = render_map_popup(name, examples)
            out = args.out.parent / f"popup_{name}.png"
            write(canvas, out)
            print(f"  rendered popup_{name} ({examples[name].get('_source')}) -> {out}")
        return 0

    if args.example:
        canvas = render_map_popup(args.example, examples)
        write(canvas, args.out)
        print(f"  wrote {args.out}")
        return 0

    # Default: render Cibola
    canvas = render_map_popup("lostcity2_cibola", examples)
    write(canvas, args.out)
    print(f"  wrote {args.out}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
