# BIN Format — Audio Sample Bank

## File inventory
1 .BIN file in COLONIZE/:
- `COLDIG.BIN` — digital audio sample bank

## Format

Container for 8-bit unsigned PCM audio samples, sampled at ~11,025 Hz
typical for early-1990s DOS games. The format is likely a directory of
named samples followed by raw PCM data:

```
+---------------------------------------------------------------+
| Sample-table header                                             |
| - LE16 sample_count                                              |
| - per-sample entry: { name[8], LE32 file_offset, LE32 length } |
+---------------------------------------------------------------+
| Raw PCM data: byte sequences for each sample                  |
+---------------------------------------------------------------+
```

Exact byte layout TBD. The Python port doesn't yet have a verified
COLDIG.BIN decoder.

## Sample inventory (suspected)

Based on the GAME.TXT message catalog and DOSBox audio capture:
- Cannon-fire (combat)
- Musket-fire (combat)
- Crowd cheer (Sons of Liberty events)
- Bell (turn end, message arrival)
- Trumpet (king's edict)
- Hammer (building completion)
- Plowing (settler arrival)
- Tribal drums (native interaction)
- Various menu-click feedback sounds

## Loader

DOS-side: overlay-resident sample-bank loader. Selected at startup
based on the chosen sound driver (only AdLib/Sound Blaster path uses
COLDIG.BIN; the PC-speaker path uses square-wave synthesis from
PSOUND.COL alone).

## Verification

- @verified  Audio playback in DOSBox confirms the sample IDs roughly
             match the suspected inventory above.
- @ref       ../../../docs/AUDIO_NOTES.md  (TBD — to be created)

## Citations

- @asm_file  TBD
- @ref       ../../../COLONIZATION_TECHNICAL_REFERENCE.md  §1
- @python    The Python port currently uses pre-generated WAV samples;
             a future BIN extractor would write per-sample WAVs from the
             original COLDIG.BIN.
