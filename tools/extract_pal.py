#!/usr/bin/env python3
"""
extract_pal.py — Extract VICEROY.PAL to JSON + PNG swatch.

Format spec: formats/PAL.md.  Codec: tools/asset_codecs.py (pal_decode /
pal_encode; the round trip is bit-exact and is run by tools/verify_assets.py).

LOADER (byte-verified 2026-09-02, REMAINING_WORK.md G5; offsets are file
offsets into VICEROY.EXE, DGROUP strings relative to file 0x1D9A0):

  func_0781DE  = the .PAL loader, thunk 0x1A1F:0xE28, ONE caller: the boot
                 asset loader func_075FB6 @0x76039-0x76043:
                     push 0xa000 ; push 0xfc00 ; lea bx,[0x237d] ; lcall 0x1a1f,0xe28
                 i.e. (dest far ptr A000:FC00, name BX -> DGROUP 0x237D =
                 "viceroy.pal", lowercase, at file 0x1FD1D).  Failure sets
                 [0x822] = 0x13 @0x7604C.
  inside:        fopen(name, "rb") -- lea bx,[0x25f2] ("rb"); lcall 0x181f,0xe86
                 @0x781EB-0x781EF (-> func_00C45A);
                 fread(buf, 0x300, 1, fp) -- push si; push 1; push 0x300;
                 lea ax,[bp-0x302]; lcall 0xd1d,0x528 @0x781FA-0x78205;
                 far memcpy of 0x300 bytes to the destination -- push 0x300 ...
                 lcall 0xd1d,0xfb2 @0x78211-0x78220; fclose @0x78232.
  DAC upload:    push 0xa000; push 0xfc00; lcall 0x181f,0x3f4 @0x762FE-0x76304
                 (-> func_00D1E4: out 0x3C8,0 then 0x300 x outsb 0x3C9).

  CONSEQUENCE: VICEROY reads exactly 0x300 bytes.  The trailing 256 flag
  bytes (0x300..0x3FF, values 0x05/0x00 in the shipped file) are NEVER read
  by VICEROY.EXE.  Their consumer, if any, is TBD -- blocker: MAPEDIT.EXE and
  COLONIZE.EXE also carry a "viceroy.pal" string (MAPEDIT @0x177E7,
  COLONIZE @0x6C334) and neither loader has been traced.  They are still
  content: the extract keeps them so the round trip stays byte-exact.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
COLONIZE = ROOT / "raw" / "COLONIZE"
sys.path.insert(0, str(ROOT / "tools"))
import asset_codecs  # noqa: E402

LOADER = {
    "loader_function": "func_0781DE",
    "loader_offset": "0x0781DE",
    "loader_thunk": "0x1A1F:0xE28",
    "called_from": ["func_075FB6 @0x076043 (boot asset loader)"],
    "called_with_args": ["dest = A000:FC00 (push 0xa000; push 0xfc00 @0x76039-0x7603C)",
                         "name = DGROUP 0x237D \"viceroy.pal\" (lea bx,[0x237d] @0x7603F)"],
    "bytes_read": "0x300 (fread @0x781FA-0x78205); bytes 0x300..0x3FF never read by VICEROY",
    "dac_upload": "func_00D1E4 via 0x181F:0x3F4 @0x762FE-0x76304 (out 0x3C8,0; 0x300 x outsb 0x3C9)",
    "unread_tail_consumer": "TBD -- MAPEDIT/COLONIZE .pal loaders not traced",
}


def extract(pal_path: Path, out_dir: Path):
    out_dir.mkdir(parents=True, exist_ok=True)
    data = pal_path.read_bytes()
    if len(data) < 768:
        print(f"WARN: expected >=768 palette bytes, got {len(data)}", file=sys.stderr)

    decoded = asset_codecs.pal_decode(data)
    entries = decoded["entries"]
    sha = hashlib.sha256(data).hexdigest()
    out_json = {
        "source_file": pal_path.name,
        "source_sha256": sha,
        "format_spec": "formats/PAL.md",
        **decoded,
    }
    json_path = out_dir / "viceroy.pal.json"
    json_path.write_text(json.dumps(out_json, indent=2))
    print(f"  wrote {json_path}")

    # PNG swatch (16x16 grid of 16x16 pixel cells = 256x256 image)
    try:
        from PIL import Image
        img = Image.new("RGB", (256, 256))
        pixels = img.load()
        for i in range(256):
            row, col = i // 16, i % 16
            r8, g8, b8 = entries[i]["rgb_8bit"]
            for y in range(row * 16, row * 16 + 16):
                for x in range(col * 16, col * 16 + 16):
                    pixels[x, y] = (r8, g8, b8)
        png_path = out_dir / "viceroy.png"
        img.save(png_path)
        print(f"  wrote {png_path}")
    except ImportError:
        print("  WARN: PIL/Pillow not installed; skipping PNG swatch")

    sidecar = {
        **LOADER,
        "original_filename": pal_path.name,
        "sha256": sha,
        "format_spec": "formats/PAL.md",
        "extracted_to": str(json_path.relative_to(ROOT)),
    }
    sidecar_path = out_dir / "viceroy.pal.sidecar.json"
    sidecar_path.write_text(json.dumps(sidecar, indent=2))
    print(f"  wrote {sidecar_path}")


def main():
    ap = argparse.ArgumentParser(description=__doc__.split("\n\n")[0])
    ap.add_argument("--source", type=Path, default=COLONIZE / "VICEROY.PAL")
    ap.add_argument("--out", type=Path, default=ROOT / "assets" / "palettes")
    args = ap.parse_args()
    if not args.source.exists():
        print(f"Source not found: {args.source}", file=sys.stderr)
        return 1
    extract(args.source, args.out)
    return 0


if __name__ == "__main__":
    sys.exit(main())
