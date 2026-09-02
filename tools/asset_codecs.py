#!/usr/bin/env python3
"""asset_codecs.py — pure decode/encode pairs for the small COLONIZE/ data files.

Every codec is a pair `decode(bytes) -> dict` / `encode(dict) -> bytes` whose
round trip is BIT-EXACT against the shipped file (tools/verify_assets.py runs
it over every file in raw/COLONIZE/).  Where the engine reads a field, the
decoder names it and cites the VICEROY.EXE read site; where a byte is never
read by any traced loader it is carried VERBATIM under a key that says so
(`*_opaque_hex`, `tail_hex`, `raw`), so the round trip stays exact without
pretending the meaning is known.  Meaning is documented in formats/*.md.

Offsets are FILE offsets into raw/COLONIZE/VICEROY.EXE as printed by
data_extracted/disassembly/VICEROY_annotated.asm; DGROUP string offsets are
relative to file 0x1D9A0.  Loader citations (all re-read from the listing
2026-09-02, REMAINING_WORK.md G5/G6):

  .PAL  func_0781DE (thunk 0x1A1F:0xE28, sole caller boot func_075FB6 @0x76043):
        fopen(name,"rb") @0x781EF; fread(buf, 0x300, 1) @0x781FA-0x78205;
        far-copy 0x300 bytes to A000:FC00 @0x78211-0x78220.  Bytes 0x300..0x3FF
        of VICEROY.PAL are NEVER read by VICEROY.EXE.
  .MP   func_071106 (thunk 0x1A1F:0xC8E, caller new_game_state_init @0x75733):
        fread(0x853A, 4, 1) = width, height @0x7113E-0x71146 (error 2);
        fread(&ver, 2, 1) @0x7115C-0x71167; ver must be 4 @0x71173-0x71182
        (error 3 unless [0x152] < 0); three fread(w*h) layers @0x711B1/0x711D8/
        0x71200 into [0x15C]/[0x160]/[0x164] (errors 4/5/6); nothing after.
        Writer func_071246 emits the same six bytes + three layers @0x71286/
        0x712AD/0x712DD/0x71304/0x7132C.
"""
from __future__ import annotations

import struct

# ---------------------------------------------------------------- .PAL ----

PAL_RGB_BYTES = 0x300          # what func_0781DE reads: fread(buf, 0x300, 1) @0x781FD


def pal_decode(data: bytes) -> dict:
    """VICEROY.PAL: 256 VGA 6-bit RGB triples (read by func_0781DE), then one
    byte per index that VICEROY never reads (kept verbatim as `padding`)."""
    if len(data) < PAL_RGB_BYTES:
        raise ValueError(f"PAL shorter than 0x300 bytes ({len(data)})")
    entries = []
    for i in range(256):
        r, g, b = data[i * 3], data[i * 3 + 1], data[i * 3 + 2]
        entries.append({
            "index": i,
            "vga_6bit": [r, g, b],
            "rgb_8bit": [(r * 255 + 31) // 63, (g * 255 + 31) // 63, (b * 255 + 31) // 63],
            # Byte 0x300+i.  NOT read by VICEROY.EXE (the loader stops at 0x300);
            # real content in the shipped file (0x05 / 0x00), meaning TBD.
            "padding": data[PAL_RGB_BYTES + i] if len(data) >= PAL_RGB_BYTES + 256 else None,
        })
    return {
        "layout": "768 bytes of RGB triples (read by func_0781DE), then one "
                  "flag byte per index (768+i) that VICEROY never reads",
        "trailing_bytes": len(data) - PAL_RGB_BYTES,
        "entries": entries,
        # Anything past 0x400 (none in the shipped file) is carried verbatim.
        "extra_hex": data[PAL_RGB_BYTES + 256:].hex(),
    }


def pal_encode(obj: dict) -> bytes:
    entries = obj["entries"]
    n_tail = 256 if any(e.get("padding") is not None for e in entries) else 0
    blob = bytearray(PAL_RGB_BYTES + n_tail)
    for e in entries:
        i = e["index"]
        blob[i * 3:i * 3 + 3] = bytes(e["vga_6bit"])
        if n_tail:
            blob[PAL_RGB_BYTES + i] = e["padding"]
    return bytes(blob) + bytes.fromhex(obj.get("extra_hex", ""))


# ----------------------------------------------------------------- .MP ----

MP_HEADER = struct.Struct("<HHH")      # width, height, version — func_071106 @0x71143 (4) + @0x71161 (2)
MP_VERSION = 4                         # cmp word [bp-4], 4 @0x71173
MP_LAYERS = ("terrain", "feature", "continent")   # [0x15C] @0x711B5, [0x160] @0x711DC, [0x164] @0x71204


def mp_decode(data: bytes) -> dict:
    if len(data) < MP_HEADER.size:
        raise ValueError(f"MP shorter than the 6-byte header ({len(data)})")
    w, h, ver = MP_HEADER.unpack_from(data, 0)
    n = w * h
    layers = {}
    off = MP_HEADER.size
    for name in MP_LAYERS:
        layers[name] = list(data[off:off + n])
        off += n
    short = off - len(data) if off > len(data) else 0
    return {
        "width": w,
        "height": h,
        "version": ver,
        "version_ok": ver == MP_VERSION,
        "tile_count": n,
        "layer_offsets": {name: MP_HEADER.size + i * n for i, name in enumerate(MP_LAYERS)},
        "layers": layers,
        "truncated_by": short,              # >0 only for a malformed file
        # VICEROY reads nothing after layer 3 (func_071106 closes @0x7123C);
        # any surplus is carried verbatim so a foreign file still round-trips.
        "extra_hex": data[off:].hex() if off < len(data) else "",
    }


def mp_encode(obj: dict) -> bytes:
    w, h = obj["width"], obj["height"]
    blob = bytearray(MP_HEADER.pack(w, h, obj.get("version", MP_VERSION)))
    for name in MP_LAYERS:
        blob += bytes(obj["layers"][name])
    blob += bytes.fromhex(obj.get("extra_hex", ""))
    return bytes(blob)
