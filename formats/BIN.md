# .BIN — Audio Sample Bank

A single concatenated PCM audio bank file, indexed from inside the loaded
`?SOUND.COL` driver overlay (see the 2026-08-16 correction below).

**1 .BIN file in COLONIZE/**:
- `COLDIG.BIN` — 993,755 bytes

---

## Layout

Concatenated 8-bit unsigned PCM samples at 11025 Hz mono. No header.

**Corrected 2026-08-16:** the per-effect (offset, length) index does NOT live
in a decodable `.COL` data format — the `.COL` files are MZ driver executables
(`formats/COL.md`, `docs/RESIDUAL_FINDINGS.md` §3) and the index sits in the
loaded driver's data segment, which is not decoded. The audio milestone's
empirical id→slice map (cross-correlation of per-id DOSBox captures against
this file) is committed at `data_extracted/data/coldig_slices.json` with
per-entry provenance — see `docs/AUDIO_PORT.md`.

Total ~90 seconds of audio at 11025 Hz mono.

---

## Loader in VICEROY.EXE

Loaded once at startup; samples are referenced by index from .COL
configs at runtime. Playback uses `LCALL 0x181F:0x04C0` (the sound
helper, BYTE_VERIFIED in raid dispatcher analysis).

---

## Round-trip

Byte-identity.

---

## Future work (Phase C-VISUAL extension)

Decode each .COL → COLDIG.BIN reference into per-sample WAV files at
`assets/audio/<sample_NN>.wav`, with a sidecar JSON listing the .COL
reference and the in-game sound role (sword clash, native cry, etc.).
