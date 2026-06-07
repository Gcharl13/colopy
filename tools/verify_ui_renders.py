#!/usr/bin/env python3
"""
verify_ui_renders.py — Side-by-side comparison of every rendered UI
screen against its DOSBox reference screenshot. Outputs a contact
sheet showing rendered output alongside the reference.

This is the master pixel-verification tool. Run after any renderer
changes to confirm visual fidelity.
"""
from __future__ import annotations

import argparse
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ASSETS = ROOT / "assets"
SCREENS_DIR = ROOT / "verification" / "screens"
DIALOGS_DIR = ROOT / "verification" / "dialogs"
REF_DIR = ROOT / "verification" / "dosbox_screenshots"

# Pairings: (rendered file, reference file, label)
COMPARISONS = [
    (SCREENS_DIR / "colony_baltimore.png", REF_DIR / "colon3.jpg", "Colony screen"),
    (ROOT / "verification" / "gameplay" / "gameplay.png",
     REF_DIR / "screenshot_03.jpg", "Gameplay screen"),
    (SCREENS_DIR / "europe.png",
     REF_DIR / "0d9a26d4c422d6188237dff0521e62027795dcefaab8278ffc8373e500dbcbcd.jpg",
     "Europe screen"),
    (SCREENS_DIR / "nations.png",
     REF_DIR / "719e5080b9f342c2c8785061fba86c13a5702b01cf9e515ea82e47b306fa2bb8.jpg",
     "Nations screen"),
    (SCREENS_DIR / "score.png",
     REF_DIR / "f8997b67c07e4ba2f0416e5fb6a6ba3a39f9da1140bc8674edbddbb999adf7c9.jpg",
     "Score screen"),
    (DIALOGS_DIR / "example_diplomatic.png",
     REF_DIR / "acaab05505b30bd023db8e99d950ec831ed3c0aee0fc2d4441c5927bf8dfc1ab.jpg",
     "Dialog (diplomatic)"),
    (DIALOGS_DIR / "example_king_tax.png", None,
     "Dialog (king tax)"),
    (DIALOGS_DIR / "example_ff_acquired.png", None,
     "Dialog (FF acquired)"),
    (SCREENS_DIR / "menu_with_options.png", None,
     "Main menu"),
    (SCREENS_DIR / "king_audience.png", None,
     "Audience with the King (FONTKING)"),
    (SCREENS_DIR / "cc_with_fathers.png", None,
     "Continental Congress hall (no text)"),
    (SCREENS_DIR / "declaration_signed.png",
     REF_DIR / "cf61be10bc6d787cfc8c8383790326df2f98af1268ff100375fdf8d7fa7b3f28.jpg",
     "Declaration of Independence"),
    (SCREENS_DIR / "report4_overlay.png", None,
     "Economic Adviser Report"),
    (SCREENS_DIR / "report7_overlay.png", None,
     "Foreign Affairs Report"),
    (ROOT / "verification" / "popups" / "popup_lostcity2_cibola.png",
     REF_DIR / "b6235e52e93e0546fab74bc6669aa8e9f9cda0680b8439c3e3eb67fc9f970bfa.jpg",
     "Cibola treasure popup (@LOSTCITY2)"),
    (ROOT / "verification" / "popups" / "popup_kingtax.png", None,
     "King tax demand popup (@KINGTAX)"),
    (ROOT / "verification" / "popups" / "popup_indianwar.png", None,
     "Indian war declaration popup (@INDIANWAR)"),
    (ROOT / "verification" / "popups" / "popup_raidburn.png", None,
     "Raid burn popup (@RAIDBURN)"),
]


def make_contact_sheet():
    from PIL import Image, ImageDraw

    PANE_W = 480
    PANE_H = 300
    PAD = 10
    HEADER_H = 24

    rows = len(COMPARISONS)
    sheet_w = PANE_W * 2 + PAD * 3
    sheet_h = (PANE_H + PAD + HEADER_H) * rows + PAD

    sheet = Image.new("RGB", (sheet_w, sheet_h), (40, 40, 40))
    draw = ImageDraw.Draw(sheet)

    for i, (rend_path, ref_path, label) in enumerate(COMPARISONS):
        row_y = PAD + i * (PANE_H + PAD + HEADER_H)
        # Label
        draw.text((PAD, row_y), label, fill=(255, 255, 255))
        draw.text((PAD + PANE_W + PAD, row_y), label + " (DOSBox reference)",
                  fill=(255, 255, 255))
        # Rendered
        if rend_path.exists():
            img = Image.open(rend_path).convert("RGB")
            img.thumbnail((PANE_W, PANE_H), Image.LANCZOS)
            ox = PAD + (PANE_W - img.size[0]) // 2
            oy = row_y + HEADER_H
            sheet.paste(img, (ox, oy))
        else:
            draw.text((PAD + 20, row_y + HEADER_H + 100),
                      f"NOT RENDERED: {rend_path.name}", fill=(255, 100, 100))
        # Reference
        if ref_path is None:
            draw.text((PAD + PANE_W + PAD + 20, row_y + HEADER_H + 100),
                      "(no DOSBox reference)", fill=(180, 180, 180))
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
                    default=ROOT / "verification" / "ui_verification_sheet.png")
    args = ap.parse_args()

    args.out.parent.mkdir(parents=True, exist_ok=True)
    sheet = make_contact_sheet()
    sheet.save(args.out)
    print(f"  wrote {args.out}")
    print(f"  comparisons: {len(COMPARISONS)}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
