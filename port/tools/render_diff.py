#!/usr/bin/env python3
"""Pixel-diff oracle: compare a port render against a DOS capture.

    python3 port/tools/render_diff.py PORT.png DOS.png [--threshold N]
                                      [--mask OUT.png] [--quiet]
    python3 port/tools/render_diff.py --pairs      # run the standing pair list

Both images must be raw 320x200 (port/tools/shots.py and the DOSBox harness's
Ctrl-F5 dumps both are). Exit 0 when the differing-pixel count is at or under
the threshold, 1 otherwise. The mask PNG paints differing pixels red over a
dimmed copy of the DOS frame, which is what you stare at to find the bug.

The standing pair list below encodes every port-screen : capture pair that is
expected to correspond, with a per-pair threshold. Thresholds are not "allowed
error" -- they document the KNOWN residual (cursor, blink phase, RNG-placed
buildings, the unimplemented func_005296 dither) so that any regression shows
up as growth past the documented number.
"""
import sys
from pathlib import Path

from PIL import Image

ROOT = Path(__file__).resolve().parents[2]
SHOTS = ROOT / "port" / "_shots"
SCREENS = ROOT / "docs" / "screens"

# (port shot, DOS capture, threshold px) -- extend as captures land.
# 320*200 = 64000 px; a threshold of 640 = 1% of the frame.
PAIRS = [
    # Fresh-game states vs the turn-1 capture sweep.
    # F2's residual (6.6k, 2026-08-07): the capture's crosses-gauge state
    # differs from the shot's forced 6/9 -- re-shoot to shrink, not a bug.
    ("report_F2.png", "live_2026-08-05/21_report_F2_religious.png", 7000),
    ("report_F5.png", "live_2026-08-05/74_report_F5_economic.png", 2000),
    ("report_F7.png", "live_2026-08-05/75_report_F7_naval.png", 2000),
    ("report_F9.png", "live_2026-08-05/76_report_F9_indian.png", 4000),
    ("europe.png", "live_2026-08-05/30_europe.png", 12000),
    # Hall of Fame vs the crafted-HALLFAME.DAT capture (2026-08-07; the DOS
    # frame carries a mouse cursor, ~250 px of the residual).
    ("hof.png", "live_2026-08-07/hof_crafted_dat.png", 4000),
    # The imported 1653 Dutch game vs its capture set.
    ("1653_report_F2.png", "live_1653_save/report_F2.png", 4000),
    # 12158 measured at HEAD bbb804b and unchanged by the input-gesture batch
    # (the shot is deterministic; the old 12000 was documented against an
    # earlier snapshot) -- residual is the congress-block line layout.
    ("1653_report_F3.png", "live_1653_save/report_F3.png", 12500),
    # The census pairs (docs/screens/census/, 2026-08-08): the same 1653 load
    # state with the same UI opened. These are LOOSE gates: the residual floor
    # (~10-18k px) is the map behind the box -- the engine auto-centres its
    # viewport slightly differently, draws the X cursor arrow, and its unit
    # blink phase differs. On top of that, goto/euro_recruit carry the
    # engine's own RNG (dock candidates) and the runtime advisor anchor.
    # They exist to catch GROSS breakage: wrong font, missing rows, missing
    # separators, wrong grouping.
    ("census_menu_game.png", "census/census_menu_game.png", 20000),
    ("census_menu_view.png", "census/census_menu_view.png", 21000),
    ("census_menu_orders.png", "census/census_menu_orders.png", 22000),
    ("census_menu_reports.png", "census/census_menu_reports.png", 21000),
    ("census_menu_trade.png", "census/census_menu_trade.png", 13000),
    ("census_goto_ship.png", "census/census_goto_ship.png", 32000),
    ("census_euro_recruit.png", "census/census_euro_recruit.png", 32000),
    ("census_euro_train.png", "census/census_euro_train.png", 40000),
    ("1653_report_F5.png", "live_1653_save/report_F5.png", 4000),
    ("1653_report_F6.png", "live_1653_save/report_F6.png", 16000),
    ("1653_report_F7.png", "live_1653_save/report_F7.png", 6000),
    ("1653_report_F8.png", "live_1653_save/report_F8.png", 16000),
    ("1653_report_F9.png", "live_1653_save/report_F9.png", 16000),
    ("1653_report_F10.png", "live_1653_save/report_F10.png", 24000),
    # Colony residual (25.9k, 2026-08-07): the unimplemented func_005296
    # dither, RNG building placement, and worker-cell details. Documented in
    # RULINGS 2026-08-07l; shrink as those close.
    ("1653_colony.png", "live_1653_save/colony_curacao.png", 27000),
]


def diff(a_path, b_path, mask_path=None):
    a = Image.open(a_path).convert("RGB")
    b = Image.open(b_path).convert("RGB")
    if a.size != b.size:
        # 2x-with-letterbox captures are not comparable; say so loudly.
        return None, f"size mismatch {a.size} vs {b.size}"
    pa, pb = a.load(), b.load()
    w, h = a.size
    bad = 0
    mask = Image.new("RGB", a.size) if mask_path else None
    pm = mask.load() if mask else None
    for y in range(h):
        for x in range(w):
            if pa[x, y] != pb[x, y]:
                bad += 1
                if pm:
                    pm[x, y] = (255, 0, 0)
            elif pm:
                r, g, bl = pb[x, y]
                pm[x, y] = (r // 3, g // 3, bl // 3)
    if mask:
        mask.save(mask_path)
    return bad, None


def main():
    args = sys.argv[1:]
    if "--pairs" in args:
        failed = 0
        for shot, cap, thr in PAIRS:
            ap, bp = SHOTS / shot, SCREENS / cap
            if not ap.exists() or not bp.exists():
                print(f"  SKIP  {shot} vs {cap} (missing file)")
                continue
            n, err = diff(ap, bp)
            if err:
                print(f"  SKIP  {shot} vs {cap} ({err})")
                continue
            ok = n <= thr
            print(f"  {'PASS' if ok else 'FAIL'}  {shot} vs {cap}: "
                  f"{n} px differ (threshold {thr})")
            failed += 0 if ok else 1
        sys.exit(1 if failed else 0)

    quiet = "--quiet" in args
    mask = None
    thr = 0
    pos = []
    it = iter(args)
    for tok in it:
        if tok == "--threshold":
            thr = int(next(it))
        elif tok == "--mask":
            mask = next(it)
        elif tok == "--quiet":
            pass
        else:
            pos.append(tok)
    if len(pos) != 2:
        print(__doc__)
        sys.exit(2)
    n, err = diff(pos[0], pos[1], mask)
    if err:
        print(err)
        sys.exit(2)
    if not quiet:
        print(f"{n} px differ" + (f" (mask: {mask})" if mask else ""))
    sys.exit(0 if n <= thr else 1)


if __name__ == "__main__":
    main()
