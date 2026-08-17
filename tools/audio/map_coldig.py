#!/usr/bin/env python3
"""Locate each captured SFX inside COLDIG.BIN -> committed slice table.

COLDIG.BIN is headerless 8-bit unsigned PCM @ ~11025 Hz mono; the per-id
index lives inside the (undecoded) `?SOUND.COL` driver data segment
(`formats/BIN.md`). This tool recovers the id -> (offset, length) map
EMPIRICALLY: each tools/audio/captures/sfx_<hex>.wav (44100 Hz stereo mixer
capture of the real driver playing that id) is decimated to 11025 Hz and
normalized-cross-correlated against the whole bank; the best alignment names
the slice. Slice ends are refined against silence-run boundaries detected in
the bank itself.

Output: data_extracted/data/coldig_slices.json — committed, with per-entry
correlation score, capture provenance, and an "approximate" flag on every
low-confidence row (score < SCORE_OK or capture had no signal).

The shipped payloads (gen_audio_pack.py) are verbatim COLDIG.BIN bytes named
by this table — captures only establish the mapping (RULINGS 2026-08-16).
"""
import json
import wave
from datetime import date
from pathlib import Path

import numpy as np

HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
COLDIG = ROOT / "raw" / "COLONIZE" / "COLDIG.BIN"
CAPTURES = HERE / "captures"
OUT = ROOT / "data_extracted" / "data" / "coldig_slices.json"

RATE = 11025
SCORE_OK = 0.55          # normalized corr below this -> "approximate": true
SILENT_EPS = 2           # |sample-0x80| <= eps counts as bank silence
SILENT_RUN = int(0.025 * RATE)   # 25 ms of silence = a boundary candidate


def load_capture(path: Path) -> np.ndarray:
    with wave.open(str(path)) as w:
        raw = np.frombuffer(w.readframes(w.getnframes()), dtype=np.int16)
        ch = w.getnchannels()
    mono = raw.reshape(-1, ch).mean(axis=1)
    dec = mono[::4].astype(np.float64)            # 44100 -> 11025
    # trim capture to its sounding span (keys/menu silence around it)
    env = np.abs(dec)
    idx = np.nonzero(env > 200)[0]
    if len(idx) == 0:
        return np.empty(0)
    return dec[idx[0]: idx[-1] + 1]


def bank_boundaries(bank: np.ndarray) -> np.ndarray:
    """Starts of >=SILENT_RUN silence runs — candidate sample edges."""
    silent = np.abs(bank) <= SILENT_EPS
    edges = [0]
    run = 0
    for i, s in enumerate(silent):
        run = run + 1 if s else 0
        if run == SILENT_RUN:
            edges.append(i - SILENT_RUN + 1)
    edges.append(len(bank))
    return np.unique(np.asarray(edges))


def best_offset(bank: np.ndarray, cap: np.ndarray) -> tuple[int, float]:
    """Argmax of normalized cross-correlation via FFT."""
    n = len(bank) + len(cap)
    size = 1 << (n - 1).bit_length()
    fb = np.fft.rfft(bank, size)
    fc = np.fft.rfft(cap[::-1], size)
    corr = np.fft.irfft(fb * fc, size)[len(cap) - 1: len(cap) - 1 + len(bank) - len(cap) + 1]
    # normalize by local bank energy (sliding window) to avoid loud-region bias
    csum = np.cumsum(bank * bank)
    win = csum[len(cap) - 1:] - np.concatenate(([0.0], csum[:-len(cap)]))
    win = win[: len(corr)]
    denom = np.sqrt(win * float(np.dot(cap, cap))) + 1e-9
    ncorr = corr / denom
    k = int(np.argmax(ncorr))
    return k, float(ncorr[k])


def main():
    bank_u8 = np.frombuffer(COLDIG.read_bytes(), dtype=np.uint8)
    bank = bank_u8.astype(np.float64) - 128.0
    bounds = bank_boundaries(bank)
    print(f"bank: {len(bank)} samples, {len(bounds)} boundary candidates")

    slices = {}
    for cap_path in sorted(CAPTURES.glob("sfx_*.wav")):
        sound_id = int(cap_path.stem.split("_")[1], 16)
        cap = load_capture(cap_path)
        if len(cap) < RATE // 10:
            slices[f"0x{sound_id:X}"] = {
                "capture": cap_path.name, "no_signal": True,
                "approximate": True,
            }
            print(f"0x{sound_id:X}: capture has no signal")
            continue
        off, score = best_offset(bank, cap)
        length = len(cap)
        # snap end to the nearest bank boundary within 60 ms
        end = off + length
        near = bounds[np.abs(bounds - end) <= int(0.06 * RATE)]
        snapped = bool(len(near))
        if snapped:
            end = int(near[np.argmin(np.abs(near - end))])
        # snap start likewise
        near0 = bounds[np.abs(bounds - off) <= int(0.06 * RATE)]
        if len(near0):
            off = int(near0[np.argmin(np.abs(near0 - off))])
        entry = {
            "offset": int(off),
            "length": int(end - off),
            "score": round(score, 3),
            "snapped_to_boundary": snapped,
            "capture": cap_path.name,
            "approximate": bool(score < SCORE_OK),
            "provenance": f"empirical capture cross-correlation, {date.today()}",
        }
        slices[f"0x{sound_id:X}"] = entry
        flag = "" if score >= SCORE_OK else "  APPROXIMATE"
        print(f"0x{sound_id:X}: offset={off} len={end-off} "
              f"score={score:.3f}{flag}")

    OUT.write_text(json.dumps({
        "_meta": {
            "source": "tools/audio/map_coldig.py",
            "bank": "COLDIG.BIN (993,755 B, 8-bit unsigned PCM @ ~11025 Hz)",
            "tier": "empirical capture (RULINGS 2026-08-16) — NOT byte-cited",
            "note": "payloads ship as verbatim COLDIG.BIN slices; only this "
                    "id->slice mapping is empirical",
        },
        "slices": slices,
    }, indent=1, sort_keys=True) + "\n")
    print(f"wrote {OUT}")


if __name__ == "__main__":
    main()
