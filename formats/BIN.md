# .BIN — Audio Sample Bank

A single concatenated PCM audio bank file referenced by the .COL
sound-config files.

**1 .BIN file in COLONIZE/**:
- `COLDIG.BIN` — 993,755 bytes

---

## Layout

Concatenated 8-bit unsigned PCM samples at 11025 Hz mono. No header.
Each .COL configuration provides (offset, length) records into this
file naming each sound effect.

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
