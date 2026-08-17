#!/usr/bin/env python3
"""Trim per-id captures into pack-ready mono masters.

Input:  captures/{tune,fanfare}_<hex>.wav  (44100 Hz stereo mixer captures)
Output: captures/masters/<same stem>.wav   (22050 Hz mono s16, silence-trimmed)
        masters_manifest.json              (durations, trim points, levels)

SFX ids are NOT mastered here — their payloads come verbatim from COLDIG.BIN
via the map_coldig.py slice table; only tunes/fanfares ship as renders.

No normalization: the driver's relative levels between tunes are part of the
render. Only leading/trailing silence is cut (threshold TRIM_PEAK, with
PAD_MS of headroom kept on both ends).
"""
import json
import wave
from pathlib import Path

import numpy as np

HERE = Path(__file__).resolve().parent
CAPTURES = HERE / "captures"
MASTERS = CAPTURES / "masters"
MANIFEST = HERE / "masters_manifest.json"

TRIM_PEAK = 100
PAD_MS = 120


def render_sfx_ids():
    """SFX ids that ship as renders, not slices: the sound drivers' sample
    index does not map them to a COLDIG.BIN sample at all, so they are FM
    (`sfx_ids_not_samples` in data_extracted/coldig_index.json). Every id
    the index DOES map ships as a verbatim bank slice from the byte-decoded
    offsets — see tools/gen_audio_pack.py; the empirical coldig_slices.json
    this used to read was superseded 2026-08-17.
    Ids whose capture carried no real signal (unmapped in the driver, per
    captures_manifest.json) are excluded entirely: a "render" of a silent
    capture would ship trimmed noise (caught on id 0x46, 2026-08-17)."""
    table = HERE.parent.parent / "data_extracted" / "coldig_index.json"
    if not table.exists():
        return set()
    idx = json.loads(table.read_text())
    caps = json.loads((HERE / "captures_manifest.json").read_text()) \
        if (HERE / "captures_manifest.json").exists() else {}
    out = set()
    for key in idx["sfx_ids_not_samples"]:
        if not caps.get(key, {}).get("signal", True):
            continue
        out.add(int(key, 16))
    return out


def main():
    MASTERS.mkdir(parents=True, exist_ok=True)
    manifest = {}
    sfx_render = render_sfx_ids()
    sfx_caps = [p for p in CAPTURES.glob("sfx_*.wav")
                if int(p.stem.split("_")[1], 16) in sfx_render]
    for cap in sorted(list(CAPTURES.glob("tune_*.wav")) +
                      list(CAPTURES.glob("fanfare_*.wav")) + sfx_caps):
        with wave.open(str(cap)) as w:
            rate = w.getframerate()
            raw = np.frombuffer(w.readframes(w.getnframes()), dtype=np.int16)
            ch = w.getnchannels()
        mono = raw.reshape(-1, ch).mean(axis=1)
        mono = mono[:: rate // 22050]          # -> 22050
        idx = np.nonzero(np.abs(mono) > TRIM_PEAK)[0]
        if len(idx) == 0:
            manifest[cap.stem] = {"no_signal": True}
            print(f"{cap.stem}: no signal, skipped")
            continue
        pad = int(22050 * PAD_MS / 1000)
        a = max(0, int(idx[0]) - pad)
        b = min(len(mono), int(idx[-1]) + pad)
        cut = np.clip(mono[a:b], -32768, 32767).astype(np.int16)
        dst = MASTERS / cap.name
        with wave.open(str(dst), "wb") as w:
            w.setnchannels(1)
            w.setsampwidth(2)
            w.setframerate(22050)
            w.writeframes(cut.tobytes())
        manifest[cap.stem] = {
            "master": f"masters/{dst.name}",
            "duration_s": round(len(cut) / 22050, 2),
            "trim": [round(a / 22050, 2), round(b / 22050, 2)],
            "peak": int(np.max(np.abs(cut))),
        }
        print(f"{cap.stem}: {len(cut)/22050:.1f}s peak={np.max(np.abs(cut))}")
    MANIFEST.write_text(json.dumps(manifest, indent=1, sort_keys=True) + "\n")
    print(f"wrote {MANIFEST}")


if __name__ == "__main__":
    main()
