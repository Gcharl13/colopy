#!/usr/bin/env python3
"""
verify_dosbox_examples.py — Build a comprehensive side-by-side
contact sheet showing every DOSBox reference screenshot the user
provided alongside its regenerated Python render.
"""
from __future__ import annotations
import argparse
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SCREENS = ROOT / "verification" / "screens"
DIALOGS = ROOT / "verification" / "dialogs"
POPUPS = ROOT / "verification" / "popups"
GAMEPLAY = ROOT / "verification" / "gameplay"
REF = ROOT / "verification" / "dosbox_screenshots"


# Each entry: (rendered_path, reference_path, label, group)
PAIRS = [
    # Titles + main menus
    (SCREENS / "title.png",
     REF / "screenshot_02_VGvkmOV.png",
     "Title screen (Sid Meier's COLONIZATION)", "intro"),
    (SCREENS / "menu_with_options.png", None,
     "Main menu (BEGINMENU)", "intro"),

    # Nation + customize
    (SCREENS / "nations.png",
     REF / "719e5080b9f342c2c8785061fba86c13a5702b01cf9e515ea82e47b306fa2bb8.jpg",
     "Nation selection", "setup"),

    # King audience
    (SCREENS / "king_audience.png", None,
     "Audience with the King (FONTKING parchment)", "audience"),

    # Gameplay / map views
    (GAMEPLAY / "gameplay.png",
     REF / "screenshot_03.jpg",
     "Gameplay (Spring 1510, Fr. Caravel selected)", "gameplay"),
    (GAMEPLAY / "gameplay.png",
     REF / "colon4.jpg",
     "Gameplay (Spring 1567, Arawak Land)", "gameplay"),
    (GAMEPLAY / "gameplay.png",
     REF / "b3fbac7e22dd630ec28ab813a13cde78141c869bb31890e6e3957abffe9455df.jpg",
     "Gameplay (Spring 1542, Wasteland Tropical Forest)", "gameplay"),
    (GAMEPLAY / "gameplay.png",
     REF / "b986629754bd012f92a4635c43a7f64cf94b150a053d95ed9bb6f80e7668e7bb.jpg",
     "Gameplay (Spring 1542, Mixed Forest, fur tile)", "gameplay"),
    (GAMEPLAY / "gameplay.png",
     REF / "531862-colonizationscr.jpg",
     "Gameplay (Autumn 1681, Dutch Wagon Train)", "gameplay"),

    # Colony screen
    (SCREENS / "colony_baltimore.png",
     REF / "colon3.jpg",
     "Colony screen (Baltimore, Spring 1567)", "colony"),
    (SCREENS / "colony_baltimore.png",
     REF / "bddd119afd69d81eb6ed6e9cab16135c93fa84d924298283ab375c17a27ff0a4.jpg",
     "Colony screen (System Shock 2, Spring 1529)", "colony"),

    # Europe
    (SCREENS / "europe.png",
     REF / "0d9a26d4c422d6188237dff0521e62027795dcefaab8278ffc8373e500dbcbcd.jpg",
     "Europe screen (London / GOG, Spring 1498)", "europe"),

    # Continental Congress + Hall of Fame
    (SCREENS / "cc_activities.png",
     REF / "a272beddb171b6655913f02e0e4bad4a377a15c687007c539566111e7e9d3a2f.jpg",
     "Continental Congress Activities", "cc"),
    (SCREENS / "cc_with_fathers.png", None,
     "Continental Congress hall (CCBKGD)", "cc"),

    # End-game
    (SCREENS / "score.png",
     REF / "f8997b67c07e4ba2f0416e5fb6a6ba3a39f9da1140bc8674edbddbb999adf7c9.jpg",
     "Score screen (COLONIZATION SCORE)", "endgame"),
    (SCREENS / "hall_of_fame.png",
     REF / "ae4f47d9ea45a21ec7f044b4499d16832b7b0406a3cba4cd2ca0eef07c28900e.jpg",
     "Hall of Fame / Colonization Rating", "endgame"),
    (SCREENS / "declaration_signed.png",
     REF / "cf61be10bc6d787cfc8c8383790326df2f98af1268ff100375fdf8d7fa7b3f28.jpg",
     "Declaration of Independence (signed)", "endgame"),
    (POPUPS / "popup_victory.png",
     REF / "4de8318b7c4a02339008064b0ab2d7caecaf195b87ea72759d662d08f5d3cc07.jpg",
     "Victory message popup (Royal Force annihilated)", "endgame"),

    # Dialogs / popups
    (POPUPS / "popup_lostcity2_cibola.png",
     REF / "b6235e52e93e0546fab74bc6669aa8e9f9cda0680b8439c3e3eb67fc9f970bfa.jpg",
     "Cibola treasure popup (@LOSTCITY2 + MSS3 scout)", "popup"),
    (DIALOGS / "example_diplomatic.png",
     REF / "acaab05505b30bd023db8e99d950ec831ed3c0aee0fc2d4441c5927bf8dfc1ab.jpg",
     "Diplomatic dialog (HAVETREATY)", "popup"),
]


def make_contact_sheet():
    from PIL import Image, ImageDraw

    PANE_W = 480
    PANE_H = 300
    PAD = 10
    HEADER_H = 24

    rows = len(PAIRS)
    sheet_w = PANE_W * 2 + PAD * 3
    sheet_h = (PANE_H + PAD + HEADER_H) * rows + PAD

    sheet = Image.new("RGB", (sheet_w, sheet_h), (40, 40, 40))
    draw = ImageDraw.Draw(sheet)

    for i, (rend_path, ref_path, label, group) in enumerate(PAIRS):
        row_y = PAD + i * (PANE_H + PAD + HEADER_H)
        # Labels
        draw.text((PAD, row_y), f"[{group}] {label}", fill=(255, 255, 255))
        draw.text((PAD + PANE_W + PAD, row_y), label + " (DOSBox reference)",
                  fill=(255, 255, 255))

        # Rendered (left)
        if rend_path and rend_path.exists():
            img = Image.open(rend_path).convert("RGB")
            img.thumbnail((PANE_W, PANE_H), Image.LANCZOS)
            ox = PAD + (PANE_W - img.size[0]) // 2
            oy = row_y + HEADER_H
            sheet.paste(img, (ox, oy))
        else:
            draw.text((PAD + 20, row_y + HEADER_H + 100),
                      f"NOT RENDERED: {rend_path.name if rend_path else 'N/A'}",
                      fill=(255, 100, 100))

        # Reference (right)
        if ref_path is None:
            draw.text((PAD + PANE_W + PAD + 20, row_y + HEADER_H + 100),
                      "(no DOSBox reference; new render)", fill=(180, 180, 180))
        elif ref_path.exists():
            img = Image.open(ref_path).convert("RGB")
            img.thumbnail((PANE_W, PANE_H), Image.LANCZOS)
            ox = PAD + PANE_W + PAD + (PANE_W - img.size[0]) // 2
            oy = row_y + HEADER_H
            sheet.paste(img, (ox, oy))
        else:
            draw.text((PAD + PANE_W + PAD + 20, row_y + HEADER_H + 100),
                      f"NO REFERENCE: {ref_path.name}", fill=(255, 100, 100))

    return sheet


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--out", type=Path,
                    default=ROOT / "verification" / "dosbox_examples_contact_sheet.png")
    args = ap.parse_args()
    args.out.parent.mkdir(parents=True, exist_ok=True)
    sheet = make_contact_sheet()
    sheet.save(args.out)
    print(f"  wrote {args.out}")
    print(f"  size: {sheet.size[0]}x{sheet.size[1]}")
    print(f"  pairs: {len(PAIRS)}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
