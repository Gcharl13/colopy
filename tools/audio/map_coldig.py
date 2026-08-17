#!/usr/bin/env python3
"""Locate each captured SFX inside COLDIG.BIN -> committed slice table.

COLDIG.BIN is headerless 8-bit unsigned PCM @ ~11025 Hz mono; the per-id
index lives inside the (undecoded) `?SOUND.COL` driver data segment
(`formats/BIN.md`). This tool recovers the id -> (offset, length) map
EMPIRICALLY from the tools/audio/captures/sfx_*.wav mixer captures.

Method (v2, chunked): the SB DSP's time-constant clock is near but not
exactly 11025 Hz, so a fixed 44100/4 decimation drifts out of phase over
long samples and a single whole-capture correlation collapses. Instead the
capture is cut into ~0.37 s chunks, each chunk is independently
normalized-cross-correlated against the whole bank, and a robust line fit
over (chunk index -> best bank offset) yields the true rate ratio, the
slice start, and the slice length. Sounds with no coherent chunk line are
not in the bank at all (FM-rendered by the driver) and are marked
`"in_bank": false` — they ship as ADPCM renders instead of slices.

Output: data_extracted/data/coldig_slices.json — committed, with per-entry
chunk-agreement scores, the fitted rate, sha256 of the slice, and an
"approximate" flag on low-confidence rows.

The shipped payloads (gen_audio_pack.py) are verbatim COLDIG.BIN bytes named
by this table — captures only establish the mapping (RULINGS 2026-08-16).
"""
import hashlib
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
CHUNK = 4096                  # ~0.37 s at 11025
CHUNK_SCORE_MIN = 0.45        # a chunk below this never counts as a match
LINE_TOL = 600                # samples: chunk offset within this of the fit
AGREE_MIN = 0.6               # fraction of strong chunks on the line
SILENT_EPS = 2
SILENT_RUN = int(0.025 * RATE)


def load_capture(path: Path) -> np.ndarray:
    with wave.open(str(path)) as w:
        raw = np.frombuffer(w.readframes(w.getnframes()), dtype=np.int16)
        ch = w.getnchannels()
    mono = raw.reshape(-1, ch).mean(axis=1)
    dec = mono[::4].astype(np.float64)            # 44100 -> nominal 11025
    env = np.abs(dec)
    idx = np.nonzero(env > 200)[0]
    if len(idx) == 0:
        return np.empty(0)
    return dec[idx[0]: idx[-1] + 1]


def bank_boundaries(bank: np.ndarray) -> np.ndarray:
    silent = np.abs(bank) <= SILENT_EPS
    edges = [0]
    run = 0
    for i, s in enumerate(silent):
        run = run + 1 if s else 0
        if run == SILENT_RUN:
            edges.append(i - SILENT_RUN + 1)
    edges.append(len(bank))
    return np.unique(np.asarray(edges))


class BankCorr:
    """Reusable full-bank FFT for many chunk correlations."""

    def __init__(self, bank: np.ndarray):
        self.bank = bank
        self.size = 1 << (len(bank) + CHUNK).bit_length()
        self.fb = np.fft.rfft(bank, self.size)
        csum = np.cumsum(bank * bank)
        self.csum = np.concatenate(([0.0], csum))

    def best(self, chunk: np.ndarray) -> tuple[int, float]:
        n = len(chunk)
        fc = np.fft.rfft(chunk[::-1], self.size)
        corr = np.fft.irfft(self.fb * fc, self.size)[n - 1: n - 1 + len(self.bank) - n + 1]
        win = self.csum[n:] - self.csum[:-n]
        win = win[: len(corr)]
        denom = np.sqrt(win * float(np.dot(chunk, chunk))) + 1e-9
        ncorr = corr / denom
        k = int(np.argmax(ncorr))
        return k, float(ncorr[k])


def fit_line(xs, ys):
    """Robust 1-D line fit: median slope over pairs, median intercept."""
    xs = np.asarray(xs, dtype=np.float64)
    ys = np.asarray(ys, dtype=np.float64)
    slopes = []
    for i in range(len(xs)):
        for j in range(i + 1, len(xs)):
            if xs[j] != xs[i]:
                slopes.append((ys[j] - ys[i]) / (xs[j] - xs[i]))
    slope = float(np.median(slopes)) if slopes else 1.0
    inter = float(np.median(ys - slope * xs))
    return slope, inter


NOMINAL_RATIO = 0.9966        # fleet-median DSP clock vs 11025 (measured)


def map_short(bc: BankCorr, cap: np.ndarray):
    """Whole-capture fallback for sounds too short for a chunk line
    (< ~3 chunks): resample by the fleet-median DSP ratio, one correlation."""
    n = int(len(cap) * NOMINAL_RATIO)
    x = np.interp(np.linspace(0, len(cap) - 1, n),
                  np.arange(len(cap)), cap)
    off, score = bc.best(x)
    if score < 0.6:
        return None
    return {"start": float(off), "end": float(off + n),
            "rate_ratio": NOMINAL_RATIO, "score": score, "coverage": 1.0,
            "short_fallback": True}


def map_one(bc: BankCorr, cap: np.ndarray):
    if len(cap) < 3 * CHUNK:
        return map_short(bc, cap)
    starts = list(range(0, max(1, len(cap) - CHUNK), CHUNK // 2))
    hits = []
    for s in starts:
        chunk = cap[s: s + CHUNK]
        if len(chunk) < CHUNK // 2 or float(np.max(np.abs(chunk))) < 150:
            continue
        off, score = bc.best(chunk)
        hits.append((s, off, score))
    strong = [(s, o) for s, o, sc in hits if sc >= CHUNK_SCORE_MIN]
    if len(strong) < 2:
        return None
    slope, inter = fit_line([s for s, _ in strong], [o for _, o in strong])
    if not (0.9 < slope < 1.1):
        return None
    inliers = [(s, o, sc) for s, o, sc in hits
               if sc >= CHUNK_SCORE_MIN and abs(o - (inter + slope * s)) < LINE_TOL]
    agree = len(inliers) / max(1, len([h for h in hits if h[2] >= CHUNK_SCORE_MIN]))
    coverage = len(inliers) / max(1, len(hits))
    if agree < AGREE_MIN or len(inliers) < 2:
        return None
    slope, inter = fit_line([s for s, _, _ in inliers], [o for _, o, _ in inliers])
    start = inter
    end = inter + slope * len(cap)
    score = float(np.median([sc for _, _, sc in inliers]))
    return {
        "start": start, "end": end, "rate_ratio": slope,
        "score": score, "coverage": coverage,
    }


def main():
    bank_u8 = np.frombuffer(COLDIG.read_bytes(), dtype=np.uint8)
    bank = bank_u8.astype(np.float64) - 128.0
    bounds = bank_boundaries(bank)
    bc = BankCorr(bank)
    print(f"bank: {len(bank)} samples, {len(bounds)} boundary candidates")

    slices = {}
    for cap_path in sorted(CAPTURES.glob("sfx_*.wav")):
        sound_id = int(cap_path.stem.split("_")[1], 16)
        key = f"0x{sound_id:X}"
        cap = load_capture(cap_path)
        if len(cap) < RATE // 10:
            slices[key] = {"capture": cap_path.name, "no_signal": True,
                           "in_bank": False}
            print(f"{key}: no signal")
            continue
        m = map_one(bc, cap)
        if m is None:
            slices[key] = {
                "capture": cap_path.name, "in_bank": False,
                "note": "no coherent bank alignment — FM-rendered by the "
                        "driver; ships as an ADPCM render",
            }
            print(f"{key}: NOT in bank (FM sound)")
            continue
        off = int(round(m["start"]))
        end = int(round(m["end"]))
        near0 = bounds[np.abs(bounds - off) <= int(0.06 * RATE)]
        if len(near0):
            off = int(near0[np.argmin(np.abs(near0 - off))])
        near1 = bounds[np.abs(bounds - end) <= int(0.08 * RATE)]
        snapped = bool(len(near1))
        if snapped:
            end = int(near1[np.argmin(np.abs(near1 - end))])
        off = max(0, off)
        end = min(len(bank), max(end, off + 1))
        payload = bank_u8[off:end].tobytes()
        entry = {
            "offset": off,
            "length": end - off,
            "sha256": hashlib.sha256(payload).hexdigest(),
            "score": round(m["score"], 3),
            "chunk_coverage": round(m["coverage"], 2),
            "rate_ratio": round(m["rate_ratio"], 5),
            "snapped_to_boundary": snapped,
            "capture": cap_path.name,
            "in_bank": True,
            "approximate": bool(m["score"] < 0.6 or m["coverage"] < 0.6),
            "provenance": f"empirical capture chunk-correlation, {date.today()}",
        }
        slices[key] = entry
        flag = "  APPROXIMATE" if entry["approximate"] else ""
        print(f"{key}: offset={off} len={end-off} score={m['score']:.3f} "
              f"cov={m['coverage']:.2f} rate×{m['rate_ratio']:.4f}{flag}")

    OUT.write_text(json.dumps({
        "_meta": {
            "source": "tools/audio/map_coldig.py (v2 chunked)",
            "bank": "COLDIG.BIN (993,755 B, 8-bit unsigned PCM @ ~11025 Hz)",
            "tier": "empirical capture (RULINGS 2026-08-16) — NOT byte-cited",
            "note": "payloads ship as verbatim COLDIG.BIN slices named here; "
                    "in_bank:false ids are FM sounds shipping as renders",
        },
        "slices": slices,
    }, indent=1, sort_keys=True) + "\n")
    print(f"wrote {OUT}")


if __name__ == "__main__":
    main()
