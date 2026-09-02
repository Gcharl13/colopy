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
built from.  Nothing here is a new decode.

LOADERS (byte-verified 2026-09-02, REMAINING_WORK.md G5; file offsets into
VICEROY.EXE, DGROUP strings relative to file 0x1D9A0; thunks resolved with
tools/follow_thunk.py).  The table below is what the sidecar carries.

  Container (shared by .SS/.PIK/.FF):
    func_076E50 stream open (0x1A1F:0xE9E; callers 0x76706 SS, 0x76B23 /
      0x76BD5 PIK, 0x76CE9 FF): open via 0x181F:0xE86 @0x76EB9 (FILE* at
      obj+6 @0x76EC0); fread 16 header bytes (mov ax,0x10; lcall 0x1a1f,0xcb4
      @0x76F06-0x76F0A); memcmp 12 bytes against DGROUP 0x240A
      "MADSPACK 2.0\\x1A" (push 0xc; push ds; push 0x240a; lcall 0xd1d,0x1084
      @0x76F16-0x76F26); directory = obj+0x28 (u16 at header +0x0E) entries x
      10 bytes (mov ax,es:[si+0x28]; shl/add x10; lcall 0x1a1f,0xcb4
      @0x76F47-0x76F5A); seek to 0xB0 (add [bp-0xa],0xb0; lcall 0xd1d,0xabe
      @0x76F66-0x76F7C).  Entry = {u8 type, u8, u32 unpacked, u32 packed}.
    func_077100 section read (0x1A1F:0xE82): mallocs the packed size, freads
      it, decompresses via 0x1A1F:0xEBA (-> func_0772FA, FAB when the type
      byte is 1 @0x773CA); result must equal the requested size @0x77290.
  .SS   func_076642 (0x1A1F:0x372; 10 callers incl. boot func_075FB6 @0x7615A
      cursor / @0x761E7 woodtile / @0x76226 parch / @0x76264 opentile):
      strcat ".SS" (DGROUP 0x23E6, file 0x1FD86) when the name has no '.'
      @0x7667F-0x76691; mode "rb" = 0x23ED @0x766FF.
      section 0 = 0x98-byte sheet header (mov ax,0x98; lcall 0x1a1f,0xe82
        @0x76734-0x76738): +0x00 u8 -> sheet+0x2C @0x76916-0x7691D and gates
        the pixel read (@0x7677C/@0x76A0F/@0x76A43); +0x02/+0x04 u16 ->
        sheet+0 = (hdr+2 != 0 && hdr+4 < 4) @0x76921-0x7693E, sheet+2 = hdr+4
        @0x7693E-0x76945; +0x0C u16 must be non-zero (cmp word [bp-0x108],0
        @0x7685C) else fatal dialog 0xFFF9 @0x7686B-0x76874; +0x26 u16 =
        FRAME COUNT -> sheet+4 @0x76949-0x7694D (frame table alloc n<<4
        @0x76744-0x7674B); +0x90/+0x92 u16 -> sheet+0x28/+0x2A
        @0x76951-0x7695D; +0x94 u32 = pixel-section size @0x76A5C-0x76A62.
      section 1 = frame table, 16 bytes/frame (mov ax,[bp-2]=n*16;
        lcall 0x1a1f,0xe82 @0x76845-0x76849): +8/+0xA/+0xC/+0xE = x,y,w,h
        copied to the 12-byte sheet frame entry @0x769C9-0x76A04; +4 = size
        (running data pointer @0x76A24-0x76A2C); +0 not read.
      section 2 = 0x300 palette, read ONLY when the global palette sink
        [0x23F2:0x23F4] is non-zero (mov ax,[0x23f4]; or ax,[0x23f2]; je
        @0x76899-0x768A0; mov ax,0x300; lcall 0x1a1f,0xe82 @0x768C4-0x768C8),
        otherwise skipped by ftell/fseek @0x768DC-0x7690E.
      section 3 = RLE pixels, read whole (length hdr+0x94) @0x76A4A-0x76A62.
  .PIK  func_076AEC (no palette) / func_076B9E (with palette; 0x181F:0x44E):
      ext "PIK" (DGROUP 0x23FA / 0x2402 -- no dot; the '.' comes from
      func_00D72E via 0x1A1F:0xA94 @0x76B0A / @0x76BBC); mode "rb" 0x23FE/0x2406.
      section 0 = 8 bytes (mov ax,8; lcall 0x1a1f,0xe82 @0x76B3B-0x76B3F /
        @0x76BF0-0x76BF4): +0 u16 HEIGHT, +2 u16 WIDTH -- pixel length =
        hdr+2 * hdr+0 (mov ax,[bp-0xa]; imul word [bp-0xc] @0x76B7C-0x76B7F),
        bottom-anchored row = surface.h - hdr+0 @0x76B59-0x76B64
        (0x181F:0x290 -> func_00C8E8 = off + y*stride + x); +4..+7 NOT read.
      section 1 = w*h pixels straight into the caller's buffer @0x76B6E-0x76B82.
      section 2 = 0x300 palette, read only by func_076B9E into its 5th arg
        (push [bp+0x14]; push [bp+0x12]; mov ax,0x300 @0x76C40-0x76C54).
      Order is header, PIXELS, PALETTE -- formats/PIK.md had them swapped.
  .FF   func_076C70 (0x1A1F:0xA86; callers 0x760C6 fontintr -> [0x268A],
      0x760E8 fonttiny -> [0x89E], 0x754F6, 0x6B7AF): strcat ".FF" (DGROUP
      0x2682, file 0x20022) when no '.' @0x76CAE; allocation = directory entry
      0's unpacked size (obj+0x2C/0x2E; lcall 0x1a1f,0xe90 -> func_078872
      @0x76CF7-0x76D05); section 0 read whole @0x76D13-0x76D27; returns the far
      pointer.  Single-section container; payload parsed by func_00E51C.

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
    "WIN-FWRK.SS": "ssdec.load_sheet: section 2 is 104 bytes, not a 0x300 "
                   "palette (its bytes are not 6-bit either -- ValueError in "
                   "the (v<<2)|(v>>4) widening). Its header +0x0C is 0, which "
                   "VICEROY's own loader rejects with the fatal dialog 0xFFF9 "
                   "(cmp word [bp-0x108],0 @0x7685C -> @0x7686B), and the "
                   "name WIN-FWRK occurs in none of VICEROY/OPENING/CLOSING/"
                   "MAPEDIT/COLONIZE.EXE (string census 2026-09-02). Which "
                   "program loads it, and what its 104-byte section 2 is, "
                   "stay TBD -- not guessed.",
}

# Loader citations per format, carried into every sidecar (REMAINING_WORK.md
# G5).  Every offset here was re-read from the listing on 2026-09-02; the
# module docstring has the per-field detail.
LOADERS = {
    "SS": {
        "loader_function": "func_076642",
        "loader_offset": "0x076642",
        "loader_thunk": "0x1A1F:0x372",
        "container_open": "func_076E50 @0x076E50 (0x1A1F:0xE9E): 16-byte header @0x76F06, "
                          "memcmp 'MADSPACK 2.0\\x1a' @0x76F16-0x76F26, directory x10 @0x76F47-0x76F5A, "
                          "seek 0xB0 @0x76F66-0x76F7C",
        "section_read": "func_077100 @0x077100 (0x1A1F:0xE82); FAB via func_0772FA when type==1 @0x773CA",
        "called_from": ["func_075FB6 @0x07615A cursor", "func_075FB6 @0x0761E7 woodtile",
                        "func_075FB6 @0x076226 parch", "func_075FB6 @0x076264 opentile",
                        "@0x072BD0", "@0x045B02", "@0x06F6F6", "@0x06C043", "@0x06C0DA"],
        "called_with_args": ["BX = name (\".SS\" appended when no '.', DGROUP 0x23E6 @0x76691)",
                             "AX = flags (boot passes 0x4000; bit 2 clear -> pixel section read)"],
        "sections": {
            "0": "0x98-byte header @0x76734: +0x26 frame count @0x76949, +0x94 pixel size @0x76A5C, "
                 "+0x0C must be non-zero @0x7685C, +0/+2/+4/+0x90/+0x92 stored @0x76916-0x7695D",
            "1": "frame table 16 B/frame @0x76845: +4 size, +8/+A/+C/+E x,y,w,h @0x769C9-0x76A04",
            "2": "0x300 palette @0x768C4, read only when [0x23F2:0x23F4] != 0 @0x76899-0x768A0",
            "3": "RLE pixels, hdr+0x94 bytes @0x76A4A-0x76A62",
        },
    },
    "PIK": {
        "loader_function": "func_076AEC (no palette) / func_076B9E (with palette)",
        "loader_offset": "0x076AEC / 0x076B9E",
        "loader_thunk": "0x181F:0x44E -> func_076B9E (11 callers)",
        "container_open": "func_076E50 @0x076E50 via @0x76B23 / @0x76BD5",
        "section_read": "func_077100 @0x077100 (0x1A1F:0xE82)",
        "called_with_args": ["name (ext \"PIK\" DGROUP 0x23FA/0x2402 appended by func_00D72E @0x76B0A/@0x76BBC)",
                             "dest surface {h,w,off,seg}; func_076B9E: 5th arg = palette dest @0x76C40"],
        "sections": {
            "0": "8 bytes @0x76B3B/@0x76BF0: +0 u16 height, +2 u16 width (imul @0x76B7C-0x76B7F); +4..+7 unread (TBD)",
            "1": "width*height pixels @0x76B6E-0x76B82",
            "2": "0x300 palette, func_076B9E only @0x76C40-0x76C54",
        },
    },
    "FF": {
        "loader_function": "func_076C70",
        "loader_offset": "0x076C70",
        "loader_thunk": "0x1A1F:0xA86",
        "container_open": "func_076E50 @0x076E50 via @0x76CE9",
        "section_read": "func_077100 @0x077100 (0x1A1F:0xE82) @0x76D27",
        "called_from": ["func_075FB6 @0x0760C6 fontintr -> [0x268A]", "@0x0760E8 fonttiny -> [0x89E]",
                        "func_075352 @0x0754F6", "func_06B722 @0x06B7AF"],
        "called_with_args": ["BX = name (\".FF\" appended when no '.', DGROUP 0x2682 @0x76CAE)"],
        "sections": {
            "0": "whole payload, size = directory entry 0 unpacked (obj+0x2C) @0x76CF7-0x76D27; "
                 "parsed by func_00E51C (formats/FF.md)",
        },
    },
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
        **LOADERS[kind],
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
