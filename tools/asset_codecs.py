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


# ---------------------------------------------------------------- .DAT ----
# CYCLE.DAT reader = func_0783E4: fopen("CYCLE.DAT","rb") (push 0x25f9;
# lea bx,[0x25f6]; lcall 0x181f,0xe86 @0x783EF-0x783F6), fread(0x929E, 0x22, 1)
# (push 1; push 0x22; push 0x929e; lcall 0xd1d,0x528 @0x78403-0x7840A), fclose
# @0x7841B.  34 bytes land in DGROUP 0x929E and are consumed as
# {u16 count; {u8 len, phase, start, delay}[8]} by cycle_init / cycle_colors
# @0x0C51A (docs/PALETTE_AND_CYCLING.md).  Only band[0..count-1] are ever
# read; the on-disk `phase` byte is overwritten with 0 at init (@0x0C4EF).

CYCLE_STRUCT = struct.Struct("<H" + "BBBB" * 8)      # 2 + 32 = 34 = 0x22
CYCLE_SIZE = CYCLE_STRUCT.size


def cycle_dat_decode(data: bytes) -> dict:
    if len(data) < CYCLE_SIZE:
        raise ValueError(f"CYCLE.DAT shorter than 0x22 ({len(data)})")
    v = CYCLE_STRUCT.unpack_from(data, 0)
    count = v[0]
    bands = [{"len": v[1 + 4 * i], "phase": v[2 + 4 * i],
              "start": v[3 + 4 * i], "delay": v[4 + 4 * i]} for i in range(8)]
    return {
        "reader": "func_0783E4 @0x0783E4: fread(0x929E, 0x22, 1) @0x78403-0x7840A",
        "count": count,
        "bands": bands,
        "bands_read_by_engine": count,      # bands[count..7] are never read (dead bytes)
        "phase_byte_dead": "overwritten with 0 by cycle_init @0x0C4EF",
        "extra_hex": data[CYCLE_SIZE:].hex(),
    }


def cycle_dat_encode(obj: dict) -> bytes:
    flat = [obj["count"]]
    for b in obj["bands"]:
        flat += [b["len"], b["phase"], b["start"], b["delay"]]
    return CYCLE_STRUCT.pack(*flat) + bytes.fromhex(obj.get("extra_hex", ""))


# PATH.DAT: plain ASCII "x, y\r\n" pairs, read by OPENING.EXE (the string
# "PATH.DAT" is at OPENING.EXE file 0xBFE8; it is absent from VICEROY.EXE).
# The consumer's parse is not traced here (blocker: OPENING's reader is
# outside this track), so the decoder keeps every line that does not
# re-encode EXACTLY as `f"{x}, {y}"` verbatim under {"raw": ...}.

def path_dat_decode(data: bytes) -> dict:
    parts = data.split(b"\r\n")
    tail = parts[-1]                      # bytes after the final CRLF ('' when the file ends with one)
    entries = []
    for line in parts[:-1]:
        try:
            xs, ys = line.split(b", ")
            x, y = int(xs), int(ys)
            if f"{x}, {y}".encode() == line:
                entries.append([x, y])
                continue
        except ValueError:
            pass
        entries.append({"raw": line.decode("latin-1")})
    return {
        "consumer": "OPENING.EXE (string @0xBFE8); not read by VICEROY.EXE",
        "line_format": "\"x, y\" + CRLF",
        "points": entries,
        "point_count": sum(1 for e in entries if isinstance(e, list)),
        "tail": tail.decode("latin-1"),
    }


def path_dat_encode(obj: dict) -> bytes:
    out = bytearray()
    for e in obj["points"]:
        if isinstance(e, list):
            out += f"{e[0]}, {e[1]}".encode()
        else:
            out += e["raw"].encode("latin-1")
        out += b"\r\n"
    out += obj["tail"].encode("latin-1")
    return bytes(out)


# INSTALL.DAT: consumed by INSTALL.EXE only (no "INSTALL.DAT" string in
# VICEROY.EXE).  Its record grammar is NOT byte-verified -- INSTALL.EXE has
# not been annotated -- so the whole file is opaque; the ASCII runs are
# listed for orientation only and are not used by the encoder.

def _ascii_runs(data: bytes, min_len: int = 4) -> list:
    runs, cur, start = [], bytearray(), 0
    for i, b in enumerate(data):
        if 0x20 <= b < 0x7F:
            if not cur:
                start = i
            cur.append(b)
        else:
            if len(cur) >= min_len:
                runs.append({"offset": start, "text": cur.decode("ascii")})
            cur = bytearray()
    if len(cur) >= min_len:
        runs.append({"offset": start, "text": cur.decode("ascii")})
    return runs


def opaque_decode(data: bytes) -> dict:
    return {"opaque_hex": data.hex(), "size": len(data),
            "ascii_runs_observed": _ascii_runs(data)[:64]}


def opaque_encode(obj: dict) -> bytes:
    return bytes.fromhex(obj["opaque_hex"])


# ---------------------------------------------------------------- .COL ----
# CONFIG.COL reader = func_070DE8: fopen("CONFIG.COL","rb") (push 0x2056 "rb";
# push 0x2059 "CONFIG.COL"; lcall 0xd1d,0x4da @0x70DEC-0x70DF2), then seven
# fread(dest, 2, 1) into [0x260A] [0x260C] [0x260E] [0x2610] [0x2612] [0x2614]
# [0x2616] @0x70E04-0x70E93 (each checked; a short read stops the chain),
# fclose @0x70EA4, then [0x2608] = 0x1A1F:0xC50([0x260C]) @0x70EAC-0x70EB4 --
# word 1 selects the sound driver letter that func_07845A substitutes into
# "#SOUND.COL" (DGROUP 0x23BA).  Bytes 14..19 of the 20-byte file are never
# read.  What words 0, 2..6 mean is TBD (blocker: their consumers at
# [0x260A]/[0x260E..0x2616] are not traced here).

CONFIG_COL_WORDS = ("0x260A", "0x260C", "0x260E", "0x2610", "0x2612", "0x2614", "0x2616")


def config_col_decode(data: bytes) -> dict:
    n = min(7, len(data) // 2)
    words = list(struct.unpack_from("<%dH" % n, data, 0))
    return {
        "reader": "func_070DE8 @0x070DE8: seven fread(.,2,1) @0x70E04-0x70E93",
        "words": words,
        "word_destinations": list(CONFIG_COL_WORDS[:n]),
        "word1_role": "[0x260C] -> 0x1A1F:0xC50 -> [0x2608] = sound driver letter (@0x70EAC-0x70EB4)",
        "tail_hex": data[2 * n:].hex(),          # bytes 14..19: never read
    }


def config_col_encode(obj: dict) -> bytes:
    return struct.pack("<%dH" % len(obj["words"]), *obj["words"]) + bytes.fromhex(obj["tail_hex"])


# ?SOUND.COL: MZ executables loaded as DOS overlays by func_01287A
# (mov al,3; mov ah,0x4b; int 0x21 @0x128CD-0x128D1; five far entry points
# copied from image +0x32 via es:[0x28] @0x12946-0x12951).  The standard
# 28-byte MZ header and its relocation table are parsed; everything else
# (header padding, the whole load image = the driver code, its music
# sequence data and the COLDIG.BIN index) is carried verbatim.

MZ_HEADER = struct.Struct("<2s13H")
MZ_FIELDS = ("e_cblp", "e_cp", "e_crlc", "e_cparhdr", "e_minalloc", "e_maxalloc",
             "e_ss", "e_sp", "e_csum", "e_ip", "e_cs", "e_lfarlc", "e_ovno")


def mz_decode(data: bytes) -> dict:
    if len(data) < MZ_HEADER.size or data[:2] != b"MZ":
        return {"kind": "not-MZ", **opaque_decode(data)}
    v = MZ_HEADER.unpack_from(data, 0)
    hdr = dict(zip(MZ_FIELDS, v[1:]))
    reloc_off = hdr["e_lfarlc"]
    n_reloc = hdr["e_crlc"]
    image_off = hdr["e_cparhdr"] * 16
    reloc_end = reloc_off + 4 * n_reloc
    if not (MZ_HEADER.size <= reloc_off and reloc_end <= image_off <= len(data)):
        return {"kind": "MZ-irregular", **opaque_decode(data)}
    relocs = [list(struct.unpack_from("<HH", data, reloc_off + 4 * i)) for i in range(n_reloc)]
    id_str = data[0x210:0x224] if len(data) >= 0x224 else b""
    return {
        "kind": "MZ",
        "loader": "func_01287A @0x01287A (int 21h AX=4B03 @0x128CD-0x128D1); entry points from image+0x32 @0x12946-0x12951",
        "mz": hdr,
        "between_header_and_relocs_hex": data[MZ_HEADER.size:reloc_off].hex(),
        "relocations": relocs,
        "header_pad_hex": data[reloc_end:image_off].hex(),
        "image_offset": image_off,
        "id_string": id_str.decode("latin-1"),
        "image_hex": data[image_off:].hex(),      # opaque: driver code + music data
    }


def mz_encode(obj: dict) -> bytes:
    if obj.get("kind") != "MZ":
        return opaque_encode(obj)
    h = obj["mz"]
    out = bytearray(MZ_HEADER.pack(b"MZ", *[h[k] for k in MZ_FIELDS]))
    out += bytes.fromhex(obj["between_header_and_relocs_hex"])
    for seg_off in obj["relocations"]:
        out += struct.pack("<HH", *seg_off)
    out += bytes.fromhex(obj["header_pad_hex"])
    out += bytes.fromhex(obj["image_hex"])
    return bytes(out)


# ---------------------------------------------------------------- .MOV ----
# AMERICA.MOV: written by func_063E68 (lea bx,[0x1e5c] "wb"; push 0x1e5f
# "AMERICA.MOV" @0x63E6E-0x63E75; three fwrite 0xd1d:0x60c -- 0x85E8 x 0x10E,
# 0x86F6 x 0x10E, 0x945E x 0x20 @0x63E80-0x63EB2) and read by func_063ED2
# ("rb" 0x1e6e, name 0x1e71 @0x63ED8-0x63EDF; the same three freads
# @0x63EEA-0x63F1C).  572 = 270 + 270 + 32 bytes.  NEITHER FUNCTION HAS A
# CALLER in VICEROY.EXE (no thunk in data_extracted/thunk_targets.json
# resolves to 063E68/063ED2 -- the neighbouring thunks land on 063C58 and
# 063F3C -- and no near call names them), so the file is never loaded by the
# game.  The three tables are what func_063C58 (thunk 0x1A1F:0x7EA, called
# from new_game_state_init @0x757B5 on every new game) recomputes from the
# map: cells of 4x4 tiles, x from 1 step 4 while < 0x3D (15 columns,
# @0x63DB4-0x63DB8), y from 1 step 4 while < 0x49 (18 rows, @0x63D9B-0x63D9F),
# table index = column*18 + row (add [bp-0x16],0x12 per column @0x63DAD;
# imul bx,si,0x12 @0x63D81); per cell an 8-bit direction mask -- bit d (0..3,
# loop cmp [bp-8],4 @0x63D8F) set via shl al,cl / or [bx+si],al @0x63D3B-0x63D48
# when the path probe 0x1A1F:0x27E returns 1..7 @0x63D28-0x63D36, and the
# reciprocal bit (d+4)&7 in the neighbour cell @0x63D74-0x63D8A; pass 0 fills
# 0x85E8, pass 1 fills 0x86F6 ([bp-0x22] @0x63C64-0x63C6F).  0x945E[16] =
# per-region count of tiles whose base id (byte & 7, with id < 0x18) is 2..5
# (@0x63E2E-0x63E44).  What distinguishes the two passes is TBD (ANCHOR: the
# first pass's helper call 0x63bd8 was not fully read).

MOV_CELL_COLS, MOV_CELL_ROWS = 15, 18
MOV_TABLE = MOV_CELL_COLS * MOV_CELL_ROWS        # 0x10E = 270
MOV_COUNTS = 16                                   # 0x20 bytes of u16


def mov_decode(data: bytes) -> dict:
    if len(data) < 2 * MOV_TABLE + 2 * MOV_COUNTS:
        raise ValueError(f"MOV shorter than 572 bytes ({len(data)})")
    t0 = list(data[:MOV_TABLE])
    t1 = list(data[MOV_TABLE:2 * MOV_TABLE])
    counts = list(struct.unpack_from("<%dH" % MOV_COUNTS, data, 2 * MOV_TABLE))
    return {
        "writer": "func_063E68 @0x063E68 (fwrite 0x85E8 x0x10E, 0x86F6 x0x10E, 0x945E x0x20 @0x63E80-0x63EB2)",
        "reader": "func_063ED2 @0x063ED2 -- UNREACHABLE (no caller in VICEROY.EXE)",
        "producer": "func_063C58 @0x063C58 (0x1A1F:0x7EA, new_game_state_init @0x757B5) recomputes all three tables from the map",
        "cell_grid": {"cols": MOV_CELL_COLS, "rows": MOV_CELL_ROWS, "tiles_per_cell": 4,
                      "index": "col*18 + row (@0x63DAD, @0x63D81)"},
        "table0_0x85E8": t0,
        "table1_0x86F6": t1,
        "counts_0x945E": counts,
        "extra_hex": data[2 * MOV_TABLE + 2 * MOV_COUNTS:].hex(),
    }


def mov_encode(obj: dict) -> bytes:
    return (bytes(obj["table0_0x85E8"]) + bytes(obj["table1_0x86F6"])
            + struct.pack("<%dH" % len(obj["counts_0x945E"]), *obj["counts_0x945E"])
            + bytes.fromhex(obj.get("extra_hex", "")))


# -------------------------------------------------------------- registry ----
# name pattern -> (decode, encode, "what is opaque").  Matched by exact upper
# name first, then by extension.  Formats with no encoder (FAB is not
# byte-deterministic) are not here; tools/verify_assets.py handles them.

CODECS = {
    "VICEROY.PAL": (pal_decode, pal_encode, "bytes 0x300..0x3FF (unread by VICEROY)"),
    "*.MP": (mp_decode, mp_encode, "none (layer 2 is discarded by VICEROY at load)"),
    "CYCLE.DAT": (cycle_dat_decode, cycle_dat_encode, "bands[count..7] and each band's phase byte (never read)"),
    "PATH.DAT": (path_dat_decode, path_dat_encode, "none structurally; the consumer (OPENING.EXE) is untraced"),
    "INSTALL.DAT": (opaque_decode, opaque_encode, "everything (INSTALL.EXE not annotated)"),
    "CONFIG.COL": (config_col_decode, config_col_encode, "words 0, 2..6 meaning; bytes 14..19 (never read)"),
    "?SOUND.COL": (mz_decode, mz_encode, "the load image (driver code + music data); header padding"),
    "AMERICA.MOV": (mov_decode, mov_encode, "which tile pairs pass 0 vs pass 1 connect (ANCHOR); nothing byte-wise"),
}


def codec_for(name: str):
    """Return (key, decode, encode, opaque_note) or None."""
    up = name.upper()
    if up in CODECS:
        return (up, *CODECS[up])
    if up.endswith("SOUND.COL") and len(up) == len("?SOUND.COL"):
        return ("?SOUND.COL", *CODECS["?SOUND.COL"])
    ext = "*." + up.rsplit(".", 1)[-1] if "." in up else None
    if ext in CODECS:
        return (ext, *CODECS[ext])
    return None


def round_trip(name: str, data: bytes):
    """(key, decoded, ok) -- ok is True when encode(decode(data)) == data."""
    c = codec_for(name)
    if c is None:
        return None
    key, dec, enc, _ = c
    obj = dec(data)
    return key, obj, enc(obj) == data
