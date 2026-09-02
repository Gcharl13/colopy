#!/usr/bin/env python3
"""
extract_mp.py — Extract a .MP map file to JSON + raw tile-grid PNG.

Format spec: formats/MP_FORMAT.md.  Codec: tools/asset_codecs.py (mp_decode /
mp_encode; bit-exact round trip run by tools/verify_assets.py).

FILE LAYOUT (byte-verified against VICEROY's loader, 2026-09-02, G5):
    u16 width, u16 height, u16 version(=4), then THREE width*height byte
    layers -- terrain, feature, continent -- and nothing else
    (6 + 3*58*72 = 12,534 = the size of AMER2.MP).

WHAT WAS WRONG BEFORE 2026-09-02: this tool assumed a 4-byte header
(`<HH`, tiles from offset 4).  The version word `04 00` therefore became the
first two "tiles" and every tile sat at linear index +2; the true last two
tiles and layers 2/3 were dumped as an opaque "trailer".  The committed
`data_extracted/map/AMER2_tiles.json` (commit d87e9bb) is that output --
its tiles begin `[4, 0, 25, 3, ...]` -- and both ports' new-game terrain
plane is built from it (`port/tools/bundle.py:554`, `tools/gen_c_data.py`
dat_map_tiles).  That is a SIM-side fix with its own ledger row
(REMAINING_WORK.md G11); this tool now reads the real layout.

LOADER (file offsets into VICEROY.EXE; DGROUP strings relative to 0x1D9A0):
  func_071106  = map_load_file, thunk 0x1A1F:0xC8E, caller new_game_state_init
                 @0x75733.  Appends the default extension [0x154] = "mp" when
                 the name has no '.' (lcall 0x1a1f,0xcaa @0x7111B -> func_00D77C)
                 and fopen([0x8554], "rb") (lea bx,[0x208e] @0x71124;
                 lcall 0x181f,0xe86 @0x71128; error [0x158]=1 @0x71134).
                 [0x8554] is strcpy'd from [0x2166] = "AMER2.MP" (file 0x1FB06)
                 @0x755D1-0x755D7; the MAPTOLOAD picker overwrites it.
    header       fread(0x853A, 4, 1) @0x7113E-0x71146 -> [0x853A] width,
                 [0x853C] height (error 2 @0x71152);
                 fread(&ver, 2, 1) @0x7115C-0x71167;
                 cmp [bp-4],4; jg; jge @0x71173-0x71179: ver != 4 -> error 3
                 @0x71182 unless [0x152] < 0 @0x7117B; [0x152] = ver @0x7118F;
                 w*h -> [0x85A4:0x85A6] @0x71192-0x7119C; size gate
                 func_0710C2 (w*h > 0x2EE0 -> error 9999) via call 0x7147c @0x711A1.
    layers       three lcall 0x1a1f,0xcb4 (-> func_00D41E fread) of w*h bytes:
                 terrain -> [0x15C:0x15E] @0x711B1-0x711C6 (error 4),
                 feature -> [0x160:0x162] @0x711D8-0x711EE (error 5),
                 continent -> [0x164:0x166] @0x71200-0x71216 (error 6);
                 call 0x70fa0 @0x71230 publishes the planes; fclose @0x7123C.
  func_071246  = map_save_file ("wb" = DGROUP 0x2091 @0x71264): fwrite w,h
                 (4 bytes @0x71286), version [0x152] (2 bytes @0x712AD), three
                 layers via 0x1A1F:0xC9C @0x712DD/0x71304/0x7132C.
  func_0713D4  = map_load_default, thunk 0x1A1F:0xC80, called @0x7571C for
                 every new game: for a file map ([0x18C]==0) opens [0x8554]
                 @0x713FF-0x71403, presets 120x75 (@0x7140B-0x7141D), reads
                 ONLY the 4-byte w/h header @0x71427-0x7142F, then allocates
                 the four runtime planes (call 0x71481 -> func_070FF8).
  post-load    new_game_state_init + func_064A10's file-map branch normalise
               the terrain plane (rows 0/h-1 Arctic, columns 0/1/w-2/w-1 Sea
               Lane, forest ids 16..23 folded, layer 2 and fog zeroed) --
               formats/MP_FORMAT.md "VICEROY loader behavior".
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
    "loader_function": "func_071106",
    "loader_offset": "0x071106",
    "loader_thunk": "0x1A1F:0xC8E",
    "called_from": ["new_game_state_init @0x075733",
                    "func_0713D4 (map_load_default, 0x1A1F:0xC80, @0x07571C) reads the 4-byte w/h header only"],
    "called_with_args": ["name = [0x8554] (strcpy of [0x2166] \"AMER2.MP\" @0x755D1, or the MAPTOLOAD pick)",
                         "mode \"rb\" = DGROUP 0x208E @0x71124"],
    "header_reads": ["fread(0x853A,4,1) @0x7113E-0x71146 = width,height",
                     "fread(&ver,2,1) @0x7115C-0x71167; ver==4 required @0x71173-0x71182"],
    "layer_reads": ["terrain -> [0x15C] @0x711B1-0x711C6", "feature -> [0x160] @0x711D8-0x711EE",
                    "continent -> [0x164] @0x71200-0x71216"],
    "writer": "func_071246 @0x071246 (header @0x71286/@0x712AD, layers @0x712DD/@0x71304/@0x7132C)",
}


def extract(mp_path: Path, out_dir: Path):
    out_dir.mkdir(parents=True, exist_ok=True)
    data = mp_path.read_bytes()
    if len(data) < 6:
        print(f"ERROR: file too small ({len(data)} bytes)", file=sys.stderr)
        return 1

    decoded = asset_codecs.mp_decode(data)
    width, height = decoded["width"], decoded["height"]
    if decoded["truncated_by"]:
        print(f"WARN: {width}x{height} needs {3 * width * height} layer bytes; file is "
              f"{decoded['truncated_by']} short", file=sys.stderr)
    if not decoded["version_ok"]:
        print(f"WARN: version {decoded['version']} != 4 -- VICEROY rejects it (error 3 @0x71182)",
              file=sys.stderr)

    sha = hashlib.sha256(data).hexdigest()
    base_name = mp_path.stem.lower()

    out_json = {
        "source_file": mp_path.name,
        "source_sha256": sha,
        "format_spec": "formats/MP_FORMAT.md",
        "layer_names": {
            "terrain": "bits 0-4 terrain id, 0x20 hills/mountains, 0x40 river, 0x80 major/mountain modifier",
            "feature": "discarded by VICEROY at load (memset 0 @0x65AA5-0x65AB7)",
            "continent": "low nibble region id, high nibble owner (MAPEDIT _continent_at/_owner_of)",
        },
        **decoded,
    }
    json_path = out_dir / f"{base_name}.json"
    json_path.write_text(json.dumps(out_json, indent=2))
    print(f"  wrote {json_path}  ({width}x{height}, version {decoded['version']}, "
          f"3 layers, {len(decoded['extra_hex']) // 2} surplus bytes)")

    # Raw tile-id PNG (1 pixel per tile, the terrain byte as grey)
    try:
        from PIL import Image
        terrain = decoded["layers"]["terrain"]
        img = Image.new("L", (width, height))
        pixels = img.load()
        for y in range(height):
            for x in range(width):
                pixels[x, y] = terrain[y * width + x]
        png_path = out_dir / f"{base_name}_tileids.png"
        img.save(png_path)
        print(f"  wrote {png_path}")
    except ImportError:
        print("  WARN: PIL/Pillow not installed; skipping tile-id PNG")

    sidecar = {
        **LOADER,
        "original_filename": mp_path.name,
        "sha256": sha,
        "format_spec": "formats/MP_FORMAT.md",
        "extracted_to": str(json_path.relative_to(ROOT)),
    }
    sidecar_path = out_dir / f"{base_name}.sidecar.json"
    sidecar_path.write_text(json.dumps(sidecar, indent=2))
    print(f"  wrote {sidecar_path}")
    return 0


def main():
    ap = argparse.ArgumentParser(description=__doc__.split("\n\n")[0])
    ap.add_argument("--source", type=Path, default=COLONIZE / "AMER2.MP")
    ap.add_argument("--out", type=Path, default=ROOT / "assets" / "maps")
    args = ap.parse_args()
    if not args.source.exists():
        print(f"Source not found: {args.source}", file=sys.stderr)
        return 1
    return extract(args.source, args.out)


if __name__ == "__main__":
    sys.exit(main())
