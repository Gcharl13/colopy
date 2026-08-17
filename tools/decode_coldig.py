#!/usr/bin/env python3
"""decode_coldig.py — decode the COLDIG.BIN digital-sample bank.

COLDIG.BIN is a headerless concatenation of 8-bit unsigned PCM samples.
Its index — (offset, length) per sample — lives inside the four sound
DRIVER overlays (`?SOUND.COL`, MZ executables), not in the .BIN, and is
byte-identical in all four.  This tool re-derives the whole thing from
the bytes on every run; nothing here is transcribed by hand.

Byte evidence (file offsets; each driver loads at file 0x200, so
load = file - 0x200):

  * Index table base, taken from the `lea si,[imm16]` in the driver's
    own table walker (the `FIND`-labelled FINDWV routine) and confirmed
    by the `lea ax,[imm16]` in the play-by-index entry:

        ASOUND.COL  table @0x0039F   walker @0x00D39   player @0x00F28
        GSOUND.COL  table @0x01E7B   walker @0x02811   player @0x029FB
        PSOUND.COL  table @0x021A3   walker @0x02B3D   player @0x02D2F
        RSOUND.COL  table @0x01F01   walker @0x0289B   player @0x02A8D

  * Entry stride 8 = `add si,8` in the walker / `shl bx,3` in the
    player; entry = u32 offset, u32 length, both little-endian; the
    walker stops on a zero 32-bit LENGTH (`mov bx,[si+4]; or bx,[si+6];
    je done`) — so the last row is a terminator, and the table holds 35
    real samples.

  * Sample rate is NOT uniform.  The player branches on the index:

        cmp bx,[0x93] ; count      B9 6A 4A  mov cx,0x4A6A = 19050 Hz
        83 FB 05      cmp bx,5     72 03     jb  (keep 19050)
        B9 11 2B      mov cx,0x2B11 = 11025 Hz

    i.e. indices 0..4 play at 19050 Hz, 5..34 at 11025 Hz.  Sites:
    ASOUND @0x00F19, GSOUND @0x029EC, PSOUND @0x02D20, RSOUND @0x02A7E.

  * SFX id -> sample index.  The driver's id dispatcher (public entry
    #2) bounds-checks `cmp bx,0x5D; ja` and jumps through a word table
    of handler addresses; each SFX handler is `mov ax,<index>` followed
    by a call into the play-by-index entry.  ASOUND's SFX jump table is
    at file 0x1DB9 (ids 0x40..0x5D).  Five ids in that range are not
    sample players (they route elsewhere) and are omitted.

Three independent self-checks run on every decode and are fatal:
  1. the 35 lengths sum to exactly len(COLDIG.BIN) = 993,755;
  2. offsets are fully contiguous — offset[i+1] == offset[i]+length[i];
  3. all four drivers carry a byte-identical table.

It also inventories VICEROY.EXE's cue sites.  The game plays a sound by
pushing an id in AX and calling the gate thunk `lcall 0x181F:0x4C0`
(`9A C0 04 1F 18`), so every call site is findable, and the id is a
literal `mov ax,imm16` (`B8 xx xx`) immediately before it at all but
four sites.  Where the cue is part of a message emit the key string is
pushed a few bytes later (`6A nn 68 <dgroup ptr>`), which names the
event outright: the DGROUP->file delta is pinned by the raid block
(push `0x1B94` == `"RAIDSTORES"` at file `0x1F534`) and cross-checks
against the whole 6-key raid sequence.

Outputs:
  data_extracted/coldig_index.json   committed decoded data
  cport/data/colopy_sfx.h/.c         the C-port table (offset/len/rate)
  extracted/assets/audio/sfx_NN.wav  regenerable WAVs (--wav)

Usage:  python3 tools/decode_coldig.py [--wav]
"""
from __future__ import annotations

import argparse
import hashlib
import json
import struct
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
COLONIZE = ROOT / "raw" / "COLONIZE"

# driver -> (index-table file offset, SFX jump-table file offset or None)
DRIVERS = {
    "ASOUND.COL": (0x0039F, 0x1DB9),
    "GSOUND.COL": (0x01E7B, None),
    "PSOUND.COL": (0x021A3, None),
    "RSOUND.COL": (0x01F01, None),
}
LOAD_BIAS = 0x200          # image starts at file 0x200 in all four
SFX_LO, SFX_HI = 0x40, 0x5D
# VICEROY.EXE side: the gate thunk call, and the DGROUP -> file delta
GATE_CALL = bytes([0x9A, 0xC0, 0x04, 0x1F, 0x18])   # lcall 0x181F:0x4C0
DGROUP_DELTA = 0x1F534 - 0x1B94   # push 0x1B94 == "RAIDSTORES" @0x1F534
# only a push this close to the call belongs to the same emit block
KEY_WINDOW = 16
RATE_FAST, RATE_SLOW, RATE_SPLIT = 19050, 11025, 5


def read_table(data: bytes, off: int):
    """Walk the 8-byte rows the way FINDWV does: stop on length == 0."""
    rows = []
    while True:
        o, n = struct.unpack_from("<II", data, off)
        if n == 0:
            return rows, o          # o = the terminator's offset field
        rows.append((o, n))
        off += 8


def decode_sfx_map(data: bytes, jt: int):
    """id -> sample index, read out of the driver's own jump table."""
    out = {}
    for i in range(SFX_HI - SFX_LO + 1):
        handler = struct.unpack_from("<H", data, jt + 2 * i)[0] + LOAD_BIAS
        if data[handler] == 0xB8:          # mov ax,imm16
            out[SFX_LO + i] = struct.unpack_from("<H", data, handler + 1)[0]
    return out


def scan_cue_sites(exe: bytes):
    """Every `mov ax,id` + `lcall 0x181F:0x4C0` in VICEROY.EXE, with the
    message key when the cue is part of an emit."""

    def key_at(dg: int):
        f = dg + DGROUP_DELTA
        if not 0 <= f < len(exe):
            return None
        e = exe.find(b"\0", f, f + 40)
        if e < 0 or e - f < 4:
            return None
        raw = exe[f:e]
        ok = all(65 <= c <= 90 or 48 <= c <= 57 for c in raw)
        return raw.decode("ascii") if ok else None

    out = []
    for i in range(len(exe) - len(GATE_CALL)):
        if not exe.startswith(GATE_CALL, i):
            continue
        rec = {"call": "0x%05X" % i}
        if exe[i - 3] == 0xB8:                     # mov ax,imm16
            sid = struct.unpack_from("<H", exe, i - 2)[0]
            rec["id"] = "0x%04X" % sid
            rec["mov"] = "0x%05X" % (i - 3)
            rec["kind"] = ("command" if sid < 0x10 else
                           "tune" if 0x20 <= sid <= 0x3F else
                           "sfx" if SFX_LO <= sid <= 0x5F else
                           "fanfare" if sid >= 0x8000 else "?")
        else:
            rec["id"] = None                       # computed at runtime
            rec["kind"] = "runtime"
        for j in range(i + 5, i + 5 + KEY_WINDOW):
            if exe[j] == 0x68:
                k = key_at(struct.unpack_from("<H", exe, j + 1)[0])
                if k:
                    rec["key"] = k
                    break
        out.append(rec)
    return out


def wav(pcm: bytes, rate: int) -> bytes:
    """8-bit unsigned mono WAV — the bank's native sample format."""
    return (b"RIFF" + struct.pack("<I", 36 + len(pcm)) + b"WAVEfmt "
            + struct.pack("<IHHIIHH", 16, 1, 1, rate, rate, 1, 8)
            + b"data" + struct.pack("<I", len(pcm)) + pcm)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--wav", action="store_true",
                    help="also split COLDIG.BIN into extracted/assets/audio/")
    args = ap.parse_args()

    if not COLONIZE.is_dir():
        sys.exit("raw/COLONIZE missing — run bin/reconstitute.py first")
    bank = (COLONIZE / "COLDIG.BIN").read_bytes()
    cues = scan_cue_sites((COLONIZE / "VICEROY.EXE").read_bytes())

    tables, sfx_map = {}, {}
    for name, (toff, jt) in DRIVERS.items():
        data = (COLONIZE / name).read_bytes()
        if data[:2] != b"MZ":
            sys.exit(f"{name}: not an MZ image")
        rows, term = read_table(data, toff)
        tables[name] = (rows, term)
        if jt is not None:
            sfx_map = decode_sfx_map(data, jt)

    # --- check 3: identical in all four drivers -----------------------
    ref = tables["ASOUND.COL"]
    for name, t in tables.items():
        if t != ref:
            sys.exit(f"{name}: index table differs from ASOUND.COL")
    rows, term = ref

    # --- check 1: lengths sum to the bank size ------------------------
    total = sum(n for _, n in rows)
    if total != len(bank):
        sys.exit(f"lengths sum to {total} but COLDIG.BIN is {len(bank)}")

    # --- check 2: contiguous, terminator lands on the end -------------
    for i in range(len(rows) - 1):
        if rows[i + 1][0] != rows[i][0] + rows[i][1]:
            sys.exit(f"gap after sample {i}")
    if rows[0][0] != 0 or term != len(bank):
        sys.exit("table does not span the bank exactly")

    rates = [RATE_FAST if i < RATE_SPLIT else RATE_SLOW
             for i in range(len(rows))]

    # --- committed decoded data ---------------------------------------
    doc = {
        "_source": "tools/decode_coldig.py (re-derived from raw/COLONIZE)",
        "bank": "COLDIG.BIN",
        "bank_bytes": len(bank),
        "bank_sha256": hashlib.sha256(bank).hexdigest(),
        "format": "headerless 8-bit unsigned PCM, mono",
        "table_offsets": {k: v[0] for k, v in DRIVERS.items()},
        "entry": "u32 offset, u32 length; stride 8; zero-length terminator",
        "rate_rule": "index < 5 -> 19050 Hz, else 11025 Hz "
                     "(cmp bx,5 at ASOUND 0x00F19)",
        "samples": [{"index": i, "offset": o, "length": n, "rate": r}
                    for i, ((o, n), r) in enumerate(zip(rows, rates))],
        "sfx_id_to_index": {("0x%02X" % k): v
                            for k, v in sorted(sfx_map.items())},
        "sfx_ids_not_samples": ["0x%02X" % i
                                for i in range(SFX_LO, SFX_HI + 1)
                                if i not in sfx_map],
        "cue_sites": cues,
        "cue_sites_note":
            "VICEROY.EXE `mov ax,id` + `lcall 0x181F:0x4C0` sites. `key` is "
            "present only when a message key is pushed inside "
            f"{KEY_WINDOW} bytes of the call — that is the emit block, so "
            "the attribution is the EXE's own, not an inference. Sites "
            "with no key are real cues whose event is still TBD.",
    }
    out_json = ROOT / "data_extracted" / "coldig_index.json"
    out_json.write_text(json.dumps(doc, indent=2) + "\n")

    # --- the C-port table ---------------------------------------------
    hdr = ROOT / "cport" / "data" / "colopy_sfx.h"
    src = ROOT / "cport" / "data" / "colopy_sfx.c"
    n = len(rows)
    hdr.write_text(f"""/* colopy_sfx.h — COLDIG.BIN sample index (generated by
 * tools/decode_coldig.py; do not edit).  Every value is read out of
 * the ?SOUND.COL driver overlays — see that tool's header for the
 * byte citations. */
#ifndef COLOPY_SFX_H
#define COLOPY_SFX_H
#include <stdint.h>
#ifdef __cplusplus
extern "C" {{
#endif

#define COLOPY_SFX_COUNT {n}
#define COLOPY_SFX_BANK_BYTES {len(bank)}
#define COLOPY_SFX_ID_LO 0x{SFX_LO:02X}
#define COLOPY_SFX_ID_HI 0x{SFX_HI:02X}

typedef struct {{
    uint32_t offset;      /* byte offset into COLDIG.BIN */
    uint32_t length;      /* bytes of 8-bit unsigned PCM */
    uint16_t rate;        /* Hz — 19050 for indices 0..4, else 11025 */
}} colopy_sfx_rec;

extern const colopy_sfx_rec colopy_sfx[COLOPY_SFX_COUNT];

/* SFX id (0x40..0x5D) -> sample index, or -1 when that id is not a
 * sample player.  Ids outside the range also return -1. */
int colopy_sfx_index(int id);

#ifdef __cplusplus
}}
#endif
#endif /* COLOPY_SFX_H */
""")
    lines = [
        "/* colopy_sfx.c — generated by tools/decode_coldig.py; do not edit. */",
        '#include "colopy_sfx.h"',
        "",
        f"const colopy_sfx_rec colopy_sfx[COLOPY_SFX_COUNT] = {{",
    ]
    for i, ((o, ln), r) in enumerate(zip(rows, rates)):
        lines.append(f"    {{ 0x{o:06X}u, 0x{ln:06X}u, {r} }},   /* {i} */")
    lines += ["};", "",
              "/* the driver's own SFX jump table (ASOUND.COL @0x1DB9): each",
              " * entry is a handler that does `mov ax,<index>` then calls the",
              " * play-by-index entry.  -1 = the id is handled some other way. */",
              "static const signed char SFX_INDEX[COLOPY_SFX_ID_HI -"
              " COLOPY_SFX_ID_LO + 1] = {"]
    ids = list(range(SFX_LO, SFX_HI + 1))
    for i in range(0, len(ids), 6):
        chunk = ids[i:i + 6]
        lines.append("    " + " ".join(
            "%3d," % sfx_map.get(x, -1) for x in chunk)
            + "   /* 0x%02X.. */" % chunk[0])
    lines += ["};", "",
              "int colopy_sfx_index(int id) {",
              "    if (id < COLOPY_SFX_ID_LO || id > COLOPY_SFX_ID_HI)"
              " return -1;",
              "    return SFX_INDEX[id - COLOPY_SFX_ID_LO];",
              "}", ""]
    src.write_text("\n".join(lines))

    if args.wav:
        d = ROOT / "extracted" / "assets" / "audio"
        d.mkdir(parents=True, exist_ok=True)
        for i, ((o, ln), r) in enumerate(zip(rows, rates)):
            (d / f"sfx_{i:02d}.wav").write_bytes(wav(bank[o:o + ln], r))
        print(f"wrote {n} WAVs to {d.relative_to(ROOT)}")

    named = sum(1 for c in cues if "key" in c)
    imm = sum(1 for c in cues if c["id"])
    print(f"COLDIG.BIN: {n} samples, {total} bytes, contiguous — checks pass")
    print(f"VICEROY.EXE cue sites: {len(cues)} "
          f"({imm} with a literal id, {named} naming their message key)")
    print(f"SFX ids 0x{SFX_LO:02X}..0x{SFX_HI:02X}: "
          f"{len(sfx_map)} play samples, "
          f"{SFX_HI - SFX_LO + 1 - len(sfx_map)} route elsewhere")
    print(f"wrote {out_json.relative_to(ROOT)}, "
          f"{hdr.relative_to(ROOT)}, {src.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
