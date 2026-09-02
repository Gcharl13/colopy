#!/usr/bin/env python3
"""extract_visuals.py — Gate C: decode every shipped .SS / .PIK / .FF.

Writes PNGs plus a per-file sidecar into extracted/assets/{sprites,
backgrounds,fonts}/<NAME>/ — the regenerable, git-ignored tree CLAUDE.md
names for this tool's output.  Exit 0 only when every file decodes to at
least one frame, EXCEPT the failures declared in KNOWN_FAILURES, which must
keep failing: a declared failure that starts passing is a stale record and
fails the gate too, so the list cannot outlive what it describes.

WHAT WAS WRONG BEFORE 2026-09-02 (STATUS.md gate C, REMAINING_WORK.md G7).
This drove an external `mpskit` expected at <repo>/../tools/mpskit/main.py —
a path that exists in no checkout — and never looked at the subprocess's
exit status.  Every run therefore printed "205/206 extracted" and wrote
nothing but sidecars saying `frames_or_glyphs_count: 0` (the tracked
assets/*/loader.json files are that residue; `git log -- assets` shows
them arriving with a capture commit).  The gate could not fail, and
"NOT RUNNABLE HERE" was the kindest true thing STATUS could say about it.

Codec: tools/ssdec.py — the byte-verified MADSPACK/FAB/RLE port
(formats/SS.md, formats/PIK.md) — and port/tools/build_assets.py's .PIK and
.FF readers (formats/FF.md), the same code the JS bundle and the C pak are
built from.  Nothing here is a new decode.  Loader function/offset fields
in the sidecar stay TBD (REMAINING_WORK.md G5).

Usage:
    python3 tools/extract_visuals.py             # all three formats
    python3 tools/extract_visuals.py --type SS   # one format
    python3 tools/extract_visuals.py --quiet     # summary only (make test)
"""
from __future__ import annotations

import argparse
import hashlib
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
COLONIZE = ROOT / "raw" / "COLONIZE"
OUT = ROOT / "extracted" / "assets"
ASSET_DIRS = {"SS": OUT / "sprites", "PIK": OUT / "backgrounds", "FF": OUT / "fonts"}

sys.path.insert(0, str(ROOT / "tools"))
sys.path.insert(0, str(ROOT / "port" / "tools"))
import ssdec  # noqa: E402
import build_assets  # noqa: E402  (load_pik / load_font; importing runs nothing)
from PIL import Image  # noqa: E402

# Skipped, not failed (CLAUDE.md hard rule 5: BDARK.SS has no load path).
SKIP_FILES = {"BDARK.SS"}

# Declared failures. Each names the exact fault so the day it is fixed the
# gate reports "declared failure now passes" and the entry gets removed.
KNOWN_FAILURES = {
    "WIN-FWRK.SS": "ssdec.load_sheet: the palette section is not 6-bit "
                   "(a byte >= 0x40 breaks the (v<<2)|(v>>4) widening, "
                   "ValueError). Whether the sheet stores an 8-bit palette "
                   "or a different section order is TBD -- not guessed.",
}

TRANSPARENT = ssdec.SS_TRANSPARENT


def master_palette() -> list[int]:
    pal6 = (COLONIZE / "VICEROY.PAL").read_bytes()[:768]
    return [((v << 2) | (v >> 4)) & 0xFF for v in pal6]


def extract_ss(src: Path, dest: Path) -> tuple[int, dict]:
    sh = ssdec.load_sheet(str(src))
    pal = sh["pal"]
    frames = []
    for k, (hx, hy, w, h, pixels) in enumerate(sh["frames"]):
        img = Image.new("RGBA", (max(w, 1), max(h, 1)), (0, 0, 0, 0))
        px = img.load()
        for j in range(h):
            for i in range(w):
                v = pixels[j * w + i]
                if v != TRANSPARENT:
                    px[i, j] = (pal[v * 3], pal[v * 3 + 1], pal[v * 3 + 2], 255)
        img.save(dest / f"{src.name}.{k:03d}.png")
        frames.append({"index": k, "hx": hx, "hy": hy, "w": w, "h": h})
    (dest / f"{src.name}.json").write_text(json.dumps(
        {"frames": frames, "palette_6bit_widened": True}, indent=1))
    return len(frames), {"frames": len(frames)}


def extract_pik(src: Path, dest: Path, fallback: list[int]) -> tuple[int, dict]:
    w, h, idx, pal = build_assets.load_pik(src.read_bytes())
    im = Image.frombytes("P", (w, h), bytes(idx))
    im.putpalette(list(pal) if pal is not None else fallback)
    im.convert("RGB").save(dest / f"{src.name}.png")
    return 1, {"w": w, "h": h, "own_palette": pal is not None}


def extract_ff(src: Path, dest: Path) -> tuple[int, dict]:
    H, glyphs = build_assets.load_font(src.read_bytes())
    order = [c for c in sorted(glyphs) if glyphs[c]["w"] > 0]
    if not order:
        return 0, {"h": H}
    pad = 1
    W = sum(glyphs[c]["w"] + pad for c in order) + pad
    strip = Image.new("L", (W, H + 2 * pad), 0)
    px = strip.load()
    x = pad
    meta = {}
    for c in order:
        g = glyphs[c]
        for r, row in enumerate(g["rows"]):
            for i, v in enumerate(row):
                if v:
                    px[x + i, pad + r] = 85 * v      # 2bpp ink level as grey
        meta[c] = {"x": x, "w": g["w"]}
        x += g["w"] + pad
    strip.save(dest / f"{src.name}.png")
    (dest / f"{src.name}.json").write_text(json.dumps(
        {"h": H, "glyphs": meta, "levels": "pixel = 85 * ink level (1..3)"},
        indent=1))
    return len(order), {"h": H, "glyphs": len(order)}


def sidecar(src: Path, kind: str, dest: Path, count: int, extra: dict) -> None:
    (dest / "loader.json").write_text(json.dumps({
        "source_file": src.name,
        "sha256": hashlib.sha256(src.read_bytes()).hexdigest(),
        "format": kind,
        "format_spec": f"formats/{kind}.md",
        "loader_function": "TBD",
        "loader_offset": "TBD",
        "called_with_args": [],
        "extracted_to": str(dest.relative_to(ROOT)),
        "frames_or_glyphs_count": count,
        "extraction_tool": "tools/ssdec.py + port/tools/build_assets.py",
        **extra,
    }, indent=2))


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__.split("\n\n")[0])
    ap.add_argument("--type", choices=["SS", "PIK", "FF", "ALL"], default="ALL")
    ap.add_argument("--limit", type=int, help="only the first N files of each type")
    ap.add_argument("--quiet", action="store_true", help="summary lines only")
    args = ap.parse_args()

    if not COLONIZE.is_dir():
        print("extract_visuals: %s is missing -- run bin/reconstitute.py "
              "(raw/ is git-ignored)" % COLONIZE)
        return 2

    fallback = master_palette()
    kinds = ["SS", "PIK", "FF"] if args.type == "ALL" else [args.type]
    bad = 0
    seen_known = set()
    for kind in kinds:
        files = sorted(COLONIZE.glob(f"*.{kind}"))
        if args.limit:
            files = files[:args.limit]
        dest_root = ASSET_DIRS[kind]
        ok = skipped = failed = 0
        frames_total = 0
        for f in files:
            if f.name in SKIP_FILES:
                skipped += 1
                if not args.quiet:
                    print(f"  [{kind}] {f.name}: SKIPPED (orphan per CLAUDE.md)")
                continue
            dest = dest_root / f.stem
            dest.mkdir(parents=True, exist_ok=True)
            try:
                if kind == "SS":
                    n, extra = extract_ss(f, dest)
                elif kind == "PIK":
                    n, extra = extract_pik(f, dest, fallback)
                else:
                    n, extra = extract_ff(f, dest)
                if n == 0:
                    raise ValueError("decoded to 0 frames/glyphs")
            except Exception as exc:                 # a decode fault IS the finding
                err = "%s: %s" % (type(exc).__name__, exc)
                if f.name in KNOWN_FAILURES:
                    seen_known.add(f.name)
                    failed += 1
                    if not args.quiet:
                        print(f"  [{kind}] {f.name}: FAILED as declared ({err})")
                    continue
                failed += 1
                bad += 1
                print(f"  [{kind}] {f.name}: FAILED, undeclared -- {err}")
                continue
            if f.name in KNOWN_FAILURES:
                bad += 1
                print(f"  [{kind}] {f.name}: declared failure now PASSES ({n} "
                      f"frames) -- remove it from KNOWN_FAILURES")
            sidecar(f, kind, dest, n, extra)
            ok += 1
            frames_total += n
            if not args.quiet and (ok <= 3 or ok % 25 == 0):
                print(f"  [{kind}] {f.name}: {n} frames/glyphs")
        print(f"  {kind}: {ok}/{len(files)} decoded ({frames_total} frames/glyphs), "
              f"{skipped} skipped, {failed} failed")

    missing_known = {k for k in KNOWN_FAILURES
                     if (args.type in ("ALL", k.rsplit('.', 1)[1])) and k not in seen_known
                     and not args.limit}
    for k in sorted(missing_known):
        print(f"  declared failure {k} did not run -- is the file present?")
        bad += 1

    print("extract_visuals: %s -> %s" % ("OK" if not bad else "FAILED (%d)" % bad,
                                         OUT.relative_to(ROOT)))
    return 1 if bad else 0


if __name__ == "__main__":
    sys.exit(main())
