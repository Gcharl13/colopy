#!/usr/bin/env python3
"""sprite_atlas.py -- render a labeled visual atlas (contact sheet) for one or
more .SS sprite sheets, so a human can see which sprite index is which.

Each cell is labeled `decimal/0xHEX` (the index the specs cite). Output PNGs go
to the git-ignored, regenerable `extracted/sprite_atlas/` tree (per the CLAUDE.md
path convention -- decoded binaries are regenerable, never committed).

Usage:
    python3 tools/sprite_atlas.py ICONS.SS PHYS0.SS BUILDING.SS
    python3 tools/sprite_atlas.py --all          # every .SS in raw/COLONIZE
    python3 tools/sprite_atlas.py ICONS.SS --cols 16 --scale 3

Requires the sheet present in raw/COLONIZE/ (unzip from col.zip or reconstitute);
decoding uses tools/ssdec.py.
"""
from __future__ import annotations
import argparse
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
RAW = ROOT / "raw" / "COLONIZE"
OUT = ROOT / "extracted" / "sprite_atlas"
sys.path.insert(0, str(ROOT))


def _viceroy_pal():
    """Fallback palette (first 256 RGB6 triples of VICEROY.PAL) -> 8-bit."""
    raw = (RAW / "VICEROY.PAL").read_bytes()
    return bytes(((raw[i] << 2) | (raw[i] >> 4)) for i in range(768))


def render_pik(pik_path: Path, out_path: Path):
    """Render a full-screen .PIK image. Layout: sec0 = header (h,w u16),
    sec1 = w*h indexed pixels, sec2 (optional) = raw 768 palette else VICEROY.PAL."""
    import struct
    import tools.ssdec as ssdec
    from PIL import Image

    secs = ssdec.madspack_load(pik_path.read_bytes())
    hdr = secs[0][1]
    h, w = struct.unpack_from("<HH", hdr, 0)
    pix = secs[1][1]
    if len(secs) >= 3 and len(secs[2][1]) >= 768:
        p6 = secs[2][1]
        pal = bytes(((p6[i] << 2) | (p6[i] >> 4)) for i in range(768))
    else:
        pal = _viceroy_pal()
    im = Image.new("RGB", (w, h))
    im.putdata([(pal[v * 3], pal[v * 3 + 1], pal[v * 3 + 2]) for v in pix[: w * h]])
    out_path.parent.mkdir(parents=True, exist_ok=True)
    im.save(out_path)
    return w, h


def _load_sheet_robust(ss_path: Path):
    """Like ssdec.load_sheet but tolerant of sheets whose section-2 isn't a
    standard 768-byte palette (e.g. WIN-FWRK.SS) -> fall back to VICEROY.PAL."""
    import struct
    import tools.ssdec as ssdec
    secs = ssdec.madspack_load(ss_path.read_bytes())
    blobs = [d for _, d in secs]
    hdr, desc, pal6, pix = blobs[0], blobs[1], blobs[2], blobs[3]
    nframes = struct.unpack_from("<H", hdr, 38)[0]
    if len(pal6) >= 768 and max(pal6[:768]) <= 63:
        pal = bytes(((pal6[i] << 2) | (pal6[i] >> 4)) for i in range(768))
    else:
        pal = _viceroy_pal()
    frames = []
    for k in range(nframes):
        e = desc[k * 16:k * 16 + 16]
        if len(e) < 16:
            break
        off, size = struct.unpack_from("<I", e, 0)[0], struct.unpack_from("<I", e, 4)[0]
        x, y, w, h = struct.unpack_from("<hhHH", e, 8)
        frames.append((x, y, w, h, ssdec.rle_decode(pix[off:off + size], w, h)))
    return pal, frames


def render_atlas(ss_path: Path, out_path: Path, cols: int, scale: int,
                 cellw: int, cellh: int) -> tuple[int, tuple[int, int]]:
    import tools.ssdec as ssdec
    from PIL import Image, ImageDraw

    pal, frames = _load_sheet_robust(ss_path)
    n = len(frames)
    rows = (n + cols - 1) // cols
    W, H = cols * cellw, rows * cellh + 24
    im = Image.new("RGB", (W, H), (28, 28, 34))
    dr = ImageDraw.Draw(im)
    dr.text((6, 7), f"{ss_path.name}  ({n} sprites)  label = decimal / 0xhex",
            fill=(255, 255, 120))

    for i, (x, y, w, h, px) in enumerate(frames):
        if w <= 0 or h <= 0 or w > 240 or h > 240:          # placeholder / oversize
            cell = Image.new("RGB", (8, 8), (60, 30, 30))
        else:
            cell = Image.new("RGB", (w, h), (0, 100, 0))     # green color-key bg
            for yy in range(h):
                row = yy * w
                for xx in range(w):
                    v = px[row + xx]
                    if v == ssdec.SS_TRANSPARENT or v == 0:
                        continue
                    cell.putpixel((xx, yy), (pal[v * 3], pal[v * 3 + 1], pal[v * 3 + 2]))
            sc = min(scale, (cellw - 6) // max(w, 1), (cellh - 22) // max(h, 1)) or 1
            cell = cell.resize((max(w * sc, 1), max(h * sc, 1)), Image.NEAREST)
        cx, cy = (i % cols) * cellw, 24 + (i // cols) * cellh
        dr.rectangle([cx, cy, cx + cellw - 1, cy + cellh - 1], outline=(70, 70, 80))
        im.paste(cell, (cx + (cellw - cell.width) // 2,
                        cy + 16 + ((cellh - 16) - cell.height) // 2))
        dr.text((cx + 3, cy + 3), f"{i}/0x{i:02X}", fill=(180, 200, 255))

    out_path.parent.mkdir(parents=True, exist_ok=True)
    im.save(out_path)
    return n, im.size


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("sheets", nargs="*", help="sheet filenames in raw/COLONIZE (e.g. ICONS.SS)")
    ap.add_argument("--all", action="store_true",
                    help="render every .SS and .PIK in raw/COLONIZE")
    ap.add_argument("--out", default=str(OUT), help="output dir (default extracted/sprite_atlas)")
    ap.add_argument("--cols", type=int, default=16)
    ap.add_argument("--scale", type=int, default=3)
    ap.add_argument("--cellw", type=int, default=58)
    ap.add_argument("--cellh", type=int, default=58)
    args = ap.parse_args()
    outdir = Path(args.out)

    if args.all:
        names = sorted(p.name for p in RAW.glob("*.SS")) + sorted(p.name for p in RAW.glob("*.PIK"))
    else:
        names = args.sheets
    if not names:
        ap.error("give sheet names (e.g. ICONS.SS / OPENMENU.PIK) or --all")

    for name in names:
        src = RAW / name
        if not src.exists():
            print(f"SKIP {name}: not in {RAW} (unzip from col.zip first)", file=sys.stderr)
            continue
        try:
            if src.suffix.upper() == ".PIK":
                out = outdir / "pik" / f"{src.stem}.png"
                w, h = render_pik(src, out)
                print(f"{name}: PIK {w}x{h} -> {out}")
            else:
                out = outdir / "sprites" / f"atlas_{src.stem}.png"
                n, size = render_atlas(src, out, args.cols, args.scale, args.cellw, args.cellh)
                print(f"{name}: {n} sprites -> {out} {size}")
        except Exception as e:                                  # noqa: BLE001
            print(f"FAIL {name}: {e}", file=sys.stderr)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
