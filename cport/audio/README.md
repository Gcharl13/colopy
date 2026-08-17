# cport/audio — engine + THE APPROXIMATIONS CATALOGUE

The audio milestone's engine (design: `docs/AUDIO_PORT.md`; ruling:
`notes/rulings/RULINGS.md` 2026-08-16). Platform-free C11, static buffers,
no malloc, no I/O; boards opt in with `#define COLOPY_AUDIO`; absent from
`colopy_digest()` so the fidelity oracles cannot move.

| file | role |
|---|---|
| `colopy_audio.h` | public API (the only header shells include) |
| `colopy_audio.c` | byte-pinned caller layer: gate `func_00518E`, scheduler `func_004EE6`, queue/class verbs, switches |
| `colopy_audio_mix.c` | 2-voice mixer + IMA decoder, `au_render()` s16 mono 22050 |
| `colopy_audio_pak.c` | COLAUDIO.PAK reader (RAM buffer or SD stream callback) |
| `colopy_audio_cues.c` | §24.4 event/woodcut → cue table |

Tests: `cport/host/audio_smoke.c` (`smoke --audio`) — exact IMA
cross-language round-trip, gate truth table, class windows, crossover
ratios, re-roll, forced/one-shot/queue semantics, switch bits.
`smoke --audiopak PAK [COLDIG.BIN]` proves pack structure + slice
bit-identity.

## What is byte-faithful

- The **scheduler algorithm**: windows (peace `(1,12)`, 1-in-9 → `(13,11)`;
  war `(13,6)`, 1-in-5 → folk), class table `1→(1,7) 2→(8,5) 3→(13,6)
  4→(19,4) 5/6/7→0x33/0x35/0x36` with already-playing guards, pick
  `base + random(0,count-1)`, re-roll while == current, class derivation
  and the `[0x9A]←[0x98]` double buffer — all from the 2026-08-17 pins.
- The **gate**: driver commands < 0x10 (1 = stop), bit 0x20 → Event-Music
  gate, bit 0x40 → SFX gate.
- **Queue/class verbs**: `func_0050BC/0050F0/0050FC/005108/00513C`
  semantics including the exact one-shot condition (Event on + BG off).
- **Switch mirror bits**: bit1 BG / bit2 Event / bit3 SFX; stop sent when
  any switch is off.
- **SFX payload bytes**: verbatim `COLDIG.BIN` slices (validator-enforced).

## THE APPROXIMATIONS CATALOGUE (everything that is NOT bytes)

1. **PRNG**: seeded xorshift32 (`rnd()` with modulo) stands in for the RTL
   rand the original seeds from tick words `[0x83A8]`/`[0x83A6]`. Same
   wall-clock class, different generator and no mid-pump re-seed effect.
2. **SFX id → COLDIG slice map**: empirical (chunked cross-correlation of
   captures; `data_extracted/data/coldig_slices.json` carries per-row
   scores and `approximate` flags).
3. **Tune/fanfare audio**: DOSBox OPL renders of the real driver, IMA4
   compressed — authentic hardware family, still an emulator render.
   Lengths and (non-)looping are capture-derived.
4. **Voice model**: codec picks the voice — IMA renders serialize on the
   music voice (observed: the driver queues FM sounds), PCM slices mix on
   one SFX voice with new-preempts-old. The real driver's channel
   allocation is undecoded.
5. **Pending queue depth 1** vs the original's 8-deep dispatch ring.
6. **`au_cmd(1)` stop** silences both voices + pending; which exact voices
   the real driver's stop command touches is undecoded (forced-next
   surviving stop IS byte-pinned).
7. **Driver commands other than 1/8**: not ported (ids 0..0x0F pass the
   gate in the original; their meanings are sealed in the driver).
8. **`[0x828]` widen-to-24 rotation override**: window byte-pinned but not
   exposed (its writer/meaning is unmapped — spec §8 item 5).
9. **Cue-table rows tagged `[inferred]`** in `colopy_audio_cues.c`: key↔cue
   pairing by GAME.TXT text, not a traced call site. European first-contact
   fanfare `0x8020+power` and all combat SFX ids: **TBD, not wired** (no
   byte-cited row names them).
10. **Fanfare bank**: all 8 ids (0x8020–0x8027) captured and shipped as
    renders; the per-power CUE (0x8020+power on European first contact)
    remains unwired in cport (row 9).
11. **PC-speaker / MT-32 driver variants**: not reproduced (SB stack only).
12. **OPENING.EXE / CLOSING.EXE cinematic audio**: out of scope.
13. **Sound Test dialog** and the Pick-Music/Sound-Options UI screens are
    not in cport's input layer yet; `au_*` exposes everything they need.
