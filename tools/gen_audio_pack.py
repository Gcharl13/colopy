#!/usr/bin/env python3
"""gen_audio_pack.py — audio milestone: build COLAUDIO.PAK for the cport.

Packs the audio milestone's assets into ONE file plus a generated C header
cport/data/colopy_audio_pak.h. Peer of gen_sd_pack.py; design doc
docs/AUDIO_PORT.md; provenance tier "empirical capture" (RULINGS 2026-08-16).

Sources:
  * SFX (ids 0x40..0x5F): **verbatim COLDIG.BIN slices** named by the
    byte-decoded index data_extracted/coldig_index.json — the sample
    table read out of the .COL sound drivers (tools/decode_coldig.py),
    with `sfx_id_to_index` giving the id -> sample mapping and
    `rate_rule` the per-sample rate (`cmp bx,5` at ASOUND 0x00F19).
    8-bit unsigned PCM, codec 0. The whole bank is sha256-checked here
    at build time, so every payload is bit-exact by construction.

    This replaced the empirical map data_extracted/data/coldig_slices.json
    (tools/audio/map_coldig.py) on 2026-08-17. The two disagree on every
    shared id — the capture-correlated offsets are off by tens to
    thousands of bytes and its lengths are uniformly short (trimmed
    tails) — and the empirical map shipped 0x59, which the drivers list
    as not a bank sample at all. Byte-decoded index wins per the
    CLAUDE.md trust order (EXE disasm at a cited offset beats an
    empirical capture); see formats/BIN.md.
  * Tunes/fanfares (0x20..0x3F, 0x8020..): trimmed capture masters
    (tools/audio/trim_masters.py) encoded as IMA ADPCM 4-bit mono blocks
    (tools/audio/ima_adpcm.py), 22050 Hz, codec 1. These are renders of the
    real driver under DOSBox — empirical, never presented as byte-derived.

Pack format (little-endian; mirrored in the generated header):
  header  'CAUD' u16 version(=1) u16 count u16 mix_rate(=22050) u16 reserved
  TOC     count * { u16 id; u8 codec (0=PCM8U,1=IMA4); u8 flags (bit0 loop);
                    u16 rate; u16 reserved; u32 offset; u32 len }
          sorted by id; offsets from file start.
  payload codec 0: raw unsigned 8-bit mono samples
          codec 1: N self-contained blocks of { i16 predictor, u8 step_index,
                   u8 pad, 512 B nibbles (1024 codes, low nibble first) }

Usage: python3 tools/gen_audio_pack.py [--out cport/pak/COLAUDIO.PAK]
"""
from __future__ import annotations

import argparse
import hashlib
import json
import struct
import sys
import wave
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "tools" / "audio"))
import ima_adpcm  # noqa: E402

COLDIG = ROOT / "raw" / "COLONIZE" / "COLDIG.BIN"
INDEX = ROOT / "data_extracted" / "coldig_index.json"
MASTERS = ROOT / "tools" / "audio" / "captures" / "masters"
HDR_OUT = ROOT / "cport" / "data" / "colopy_audio_pak.h"

MAGIC = b"CAUD"
VERSION = 1
MIX_RATE = 22050
CODEC_PCM8U = 0
CODEC_IMA4 = 1


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--out", default=str(ROOT / "cport" / "pak" / "COLAUDIO.PAK"))
    args = ap.parse_args()

    entries = []  # (id, codec, flags, rate, payload)

    # ---- SFX: verbatim COLDIG.BIN slices, byte-decoded index ----
    n_sfx = 0
    sfx_ids = set()
    if INDEX.exists() and COLDIG.exists():
        bank = COLDIG.read_bytes()
        idx = json.loads(INDEX.read_text())
        if len(bank) != idx["bank_bytes"]:
            sys.exit(f"COLDIG.BIN is {len(bank)} B, index says "
                     f"{idx['bank_bytes']} B")
        if hashlib.sha256(bank).hexdigest() != idx["bank_sha256"]:
            sys.exit("COLDIG.BIN sha256 mismatch vs coldig_index.json")
        samples = idx["samples"]
        for key, sidx in sorted(idx["sfx_id_to_index"].items(),
                                key=lambda kv: int(kv[0], 16)):
            ent = samples[sidx]
            assert ent["index"] == sidx, (key, sidx)
            off, ln = ent["offset"], ent["length"]
            # the mixer's PCM8U path is a fixed 11025 -> 22050 sample hold
            # (cport/audio/colopy_audio_mix.c:115), so a 19050 Hz sample
            # would play at the wrong pitch. No sfx id maps to one today
            # (rate_rule: only sample indices < 5, and the lowest id maps
            # to index 5) — this catches it if that ever changes.
            if ent["rate"] != 11025:
                sys.exit(f"{key}: sample {sidx} is {ent['rate']} Hz; the "
                         f"mixer's PCM8U path only handles 11025")
            entries.append((int(key, 16), CODEC_PCM8U, 0, ent["rate"],
                            bank[off: off + ln]))
            sfx_ids.add(int(key, 16))
            n_sfx += 1
    else:
        print("note: no sample index / COLDIG.BIN — pack will carry no SFX")

    # ---- tunes / fanfares: ADPCM-encoded masters ----
    n_music = 0
    n_skipped = 0
    for wav_path in sorted(MASTERS.glob("*.wav")) if MASTERS.is_dir() else []:
        stem = wav_path.stem            # tune_20 / fanfare_8020
        sound_id = int(stem.split("_")[1], 16)
        if sound_id in sfx_ids:
            # a capture render of a sound the bank actually holds: the
            # verbatim slice already shipped above and wins.
            n_skipped += 1
            continue
        with wave.open(str(wav_path)) as w:
            assert w.getnchannels() == 1 and w.getframerate() == MIX_RATE, stem
            raw = w.readframes(w.getnframes())
        samples = struct.unpack(f"<{len(raw)//2}h", raw)
        payload = ima_adpcm.encode(samples)
        entries.append((sound_id, CODEC_IMA4, 0, MIX_RATE, payload))
        n_music += 1

    if not entries:
        sys.exit("nothing to pack — run the tools/audio pipeline first")

    entries.sort(key=lambda e: e[0])
    hdr = MAGIC + struct.pack("<HHHH", VERSION, len(entries), MIX_RATE, 0)
    toc = bytearray()
    body = bytearray()
    base = len(hdr) + 16 * len(entries)
    for sound_id, codec, flags, rate, payload in entries:
        toc += struct.pack("<HBBHHII", sound_id, codec, flags, rate, 0,
                           base + len(body), len(payload))
        body += payload

    out = Path(args.out)
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_bytes(hdr + bytes(toc) + bytes(body))

    lines = [
        "/* Generated by tools/gen_audio_pack.py — DO NOT hand-edit.",
        " * COLAUDIO.PAK: the audio milestone's asset pack (docs/AUDIO_PORT.md).",
        " * Mixed provenance: SFX payloads are verbatim COLDIG.BIN slices at the",
        " * byte-decoded index offsets (data_extracted/coldig_index.json); music",
        " * payloads are DOSBox renders of the original driver, IMA-encoded —",
        " * empirical capture tier (notes/rulings/RULINGS.md 2026-08-16). */",
        "#ifndef COLOPY_AUDIO_PAK_H",
        "#define COLOPY_AUDIO_PAK_H",
        "",
        "#ifdef __cplusplus",
        'extern "C" {',
        "#endif",
        "#include <stdint.h>",
        "",
        '#define CAUD_MAGIC        "CAUD"',
        "#define CAUD_VERSION      %d" % VERSION,
        "#define CAUD_HDRLEN       12    /* magic + u16 ver,count,mix_rate,rsvd */",
        "#define CAUD_TOCENT       16    /* u16 id; u8 codec; u8 flags; u16 rate;",
        "                                   u16 rsvd; u32 offset; u32 len */",
        "#define CAUD_CODEC_PCM8U  0     /* unsigned 8-bit mono (COLDIG slice) */",
        "#define CAUD_CODEC_IMA4   1     /* IMA ADPCM 4-bit mono, 1024-sample",
        "                                   self-contained blocks: i16 predictor,",
        "                                   u8 step_index, u8 pad, 512 B nibbles",
        "                                   (low nibble first) */",
        "#define CAUD_MIX_RATE     %d" % MIX_RATE,
        "#define CAUD_BLOCK        1024  /* samples per IMA block */",
        "#define CAUD_BLOCK_BYTES  516   /* 4-byte header + 512 nibble bytes */",
        "",
        "/* Generation census: %d entries (%d SFX slices, %d music renders)%s */"
        % (len(entries), n_sfx, n_music,
           "" if MASTERS.is_dir() else
           "\n * — the capture masters dir was absent at generation, so this\n"
           " * build carries SFX only; rerun with tools/audio/captures/masters\n"
           " * present to pack the tunes and fanfares."),
        "",
        "#ifdef __cplusplus",
        "}",
        "#endif",
        "#endif /* COLOPY_AUDIO_PAK_H */",
        "",
    ]
    HDR_OUT.write_text("\n".join(lines))

    total = len(hdr) + len(toc) + len(body)
    print(f"COLAUDIO.PAK: {len(entries)} entries ({n_sfx} sfx, {n_music} music), "
          f"{total} bytes")
    if n_skipped:
        print(f"note: {n_skipped} master render(s) skipped — the byte-decoded "
              f"index ships those ids as verbatim bank slices")
    print(f"wrote {out} + {HDR_OUT.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
