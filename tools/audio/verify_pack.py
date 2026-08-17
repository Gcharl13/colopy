#!/usr/bin/env python3
"""Objective pack verification: decode every COLAUDIO.PAK entry and hold it
against its source.

- codec 1 (IMA render): decode with ima_adpcm.decode and report SNR vs the
  trimmed master WAV (the codec's only loss; the master IS the reference).
- codec 0 (PCM slice): sha256 vs the COLDIG.BIN slice named in
  data_extracted/data/coldig_slices.json (bit-clean or fail).

Output: a markdown table for docs/AUDIO_PORT.md's A/B section, plus a
nonzero exit if any slice mismatches or any SNR falls below SNR_MIN.
"""
import hashlib
import json
import struct
import sys
import wave
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
sys.path.insert(0, str(HERE))
import ima_adpcm  # noqa: E402

PAK = ROOT / "cport" / "pak" / "COLAUDIO.PAK"
COLDIG = ROOT / "raw" / "COLONIZE" / "COLDIG.BIN"
SLICES = ROOT / "data_extracted" / "data" / "coldig_slices.json"
MASTERS = HERE / "captures" / "masters"
# A REGRESSION floor, not a quality verdict: IMA's adaptive quantizer dips
# into the low-20s dB on transient-dense OPL content while sounding fine —
# the perceptual gate is the human A/B listen pass (docs/AUDIO_PORT.md).
# Below 12 dB indicates an encoder/pipeline bug, not codec character.
SNR_MIN = 12.0


def main():
    blob = PAK.read_bytes()
    assert blob[:4] == b"CAUD"
    count = struct.unpack_from("<H", blob, 6)[0]
    bank = COLDIG.read_bytes()
    table = json.loads(SLICES.read_text())["slices"]

    rows = []
    bad = 0
    for i in range(count):
        sid, codec, flags, rate, _r, off, ln = struct.unpack_from(
            "<HBBHHII", blob, 12 + 16 * i)
        payload = blob[off: off + ln]
        if codec == 0:
            ent = table[f"0x{sid:X}"]
            want = bank[ent["offset"]: ent["offset"] + ent["length"]]
            ok = hashlib.sha256(payload).hexdigest() == \
                hashlib.sha256(want).hexdigest()
            bad += not ok
            rows.append((sid, "slice", f"{ln} B",
                         "bit-clean" if ok else "**MISMATCH**"))
        else:
            stem = ("fanfare" if sid >= 0x8000 else
                    "sfx" if 0x40 <= sid < 0x60 else "tune")
            master = MASTERS / f"{stem}_{sid & 0xFFFF:x}.wav"
            if sid >= 0x8000:
                master = MASTERS / f"fanfare_{sid:x}.wav"
            with wave.open(str(master)) as w:
                raw = w.readframes(w.getnframes())
            src = struct.unpack(f"<{len(raw)//2}h", raw)
            dec = ima_adpcm.decode(payload)[: len(src)]
            n = len(src)
            err = sum((a - b) ** 2 for a, b in zip(src, dec)) / n
            sig = sum(a * a for a in src) / n
            snr = 99.0 if err == 0 else \
                10 * __import__("math").log10(max(sig, 1e-9) / err)
            ok = snr >= SNR_MIN
            bad += not ok
            rows.append((sid, "IMA render", f"{n/22050:.1f} s",
                         f"SNR {snr:.1f} dB" + ("" if ok else " **LOW**")))

    print("| id | kind | size | check |")
    print("|---|---|---|---|")
    for sid, kind, size, check in rows:
        print(f"| 0x{sid:X} | {kind} | {size} | {check} |")
    print(f"\n{count} entries, {bad} failures")
    return 1 if bad else 0


if __name__ == "__main__":
    sys.exit(main())
