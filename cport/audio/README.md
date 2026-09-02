# cport/audio — engine + THE APPROXIMATIONS CATALOGUE

The audio milestone's engine (design: `docs/AUDIO_PORT.md`; ruling:
`notes/rulings/RULINGS.md` 2026-08-16). Platform-free C11, static buffers,
no malloc, no I/O; boards opt in with `#define COLOPY_AUDIO`; absent from
`colopy_digest()` so the fidelity oracles cannot move.

| file | role |
|---|---|
| `colopy_audio.h` | public API (the only header shells include) |
| `colopy_audio.c` | byte-pinned caller layer: gate `func_00518E`, scheduler `func_004EE6`, queue/class verbs, switches |
| `colopy_audio_mix.c` | 3-voice mixer (FM ch1-6 / FM ch7-9 / DSP) + IMA decoder, `au_render()` s16 mono 22050 |
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
- The **gate**: the SIGNED compare @0x5197 — ids ≥ 0x8000 (fanfares) and
  ids < 0x10 (driver commands) pass ungated; bit 0x20 → Event-Music gate,
  bit 0x40 → SFX gate (spec §9, RULINGS 2026-09-02h).
- **Driver commands 0..8** per the ASOUND.COL handlers (spec §9): 0 reset,
  1 = stop-mark all nine FM channels (music + FM sfx, NOT the digital
  sample), 2/3 stop music, 4 stop FM sfx + DSP, 5 stop FM sfx, 6/7
  mute/unmute, 8 = FM records only (a digital sample never holds the pump).
- **No queue anywhere**: VICEROY's dispatcher ring is unreachable (its lock
  has no caller) and the driver's tune head stop-marks ch1-6 first — a new
  tune REPLACES the playing one; `0:0xCE2` stops a sample in flight — a new
  digital SFX kills the old.
- **The scheduler's PRNG**: the RTL MS-C `rand` (`state*0x343FD+0x269EC3`,
  high 15 bits) with `random_int(lo,hi) = lo + ((rand*(hi-lo+1))>>15)` and
  both `srand(ticks & 0x7FFF)` seed points (@0x4F28/@0x5040) — on a PRIVATE
  state (the deliberate deviation, RULINGS 2026-09-02h).
- **`[0x828]`** (`au_set_demo`): window (1,24) @0x4F82; writers @0x70D00
  ('/D' switch) and @0x4DA6 (abort keys).
- **The title tune** 0x33 through the raw driver entry (@0x75C2A) —
  `au_on_title()`, no gate, no switch.
- **Queue/class verbs**: `func_0050BC/0050F0/0050FC/005108/00513C`
  semantics including the exact one-shot condition (Event on + BG off).
- **Switch mirror bits**: bit1 BG / bit2 Event / bit3 SFX; stop sent when
  any switch is off.
- **SFX payload bytes**: verbatim `COLDIG.BIN` slices (validator-enforced).

## THE APPROXIMATIONS CATALOGUE (everything that is NOT bytes)

1. **PRNG state is private.** The generator, scaling and seed points are
   the original's; the original runs them on the SIM's shared `[0x28EE]`
   state (every music pick re-seeds the game's random stream from the
   clock). The port keeps the scheduler off `CS.rng` on purpose — RULINGS
   2026-09-02h gives the three reasons. With no tick source installed the
   scheduler is fully deterministic (the host tests).
2. **SFX id → COLDIG slice map**: **not an approximation** — byte-decoded
   from the sound drivers' own sample table
   (`data_extracted/coldig_index.json`: `sfx_id_to_index` + `samples`,
   `rate_rule` at ASOUND `0x00F19`). Every packed payload is a verbatim
   bank slice, bank sha256-checked by generator and validator. The earlier
   empirical correlation map is superseded (2026-08-17).
3. **Tune/fanfare audio**: DOSBox OPL renders of the real driver, IMA4
   compressed — authentic hardware family, still an emulator render.
   Lengths and (non-)looping are capture-derived.
4. **Voice model**: three voices after the driver's channel split (FM
   ch1-6 music, FM ch7-9 sfx, DSP samples), each new-replaces-old. Still
   approximations inside it: the FM channel records are 9 mono channels
   sharing one OPL, the port sums three independent renders; the digital
   ring's FM-fallback-when-full and the `[0x24D]` suppression (digital
   samples muted until the first tune handler runs — runtime value TBD)
   are not modelled; commands 2/6/7 (release, mute, unmute) are modelled
   as stop / output gate rather than OPL volume writes.
5. ~~Pending queue depth 1 vs the original's 8-deep dispatch ring.~~
   Resolved 2026-09-02: neither exists in play (the ring is dead code) —
   no queue in the port either.
6. ~~`au_cmd(1)` stop semantics undecoded.~~ Decoded (ASOUND @0x1AA0):
   FM channels 1-9, digital untouched.
7. ~~Driver commands other than 1/8 not ported.~~ Ported per the handler
   bodies (0/1/3/4/5/8 exact in effect; 2/6/7 approximated as above).
8. ~~`[0x828]` unexposed.~~ `au_set_demo()`; writers byte-read (spec §9).
9. ~~Cue-table rows tagged `[inferred]`.~~ Re-cut 2026-09-02 from all 40
   play sites (spec §10, RULINGS 2026-09-02i): every row cites its emit
   block; action cues come from the core (`colopy_next_sound`). Still
   glossed: `INDIANWINCOLONY`'s 0x45 (function outcome, not a traced jump
   chain), the church fanfare's meaning, the raid rows' `RAIDSHIP` pair
   order (byte-adjacent, so not really).  Unwired with the blocker named
   in the ledger F4: the colony-open 0x54 (`[0x34A]`), the native-attacker
   `0x3B + type`, the Sound Test, the contact re-parley.
10. **Fanfare bank**: all 8 ids (0x8020–0x8027) captured and shipped as
    renders; `0x8020+power` fires from the JS `checkContact`; the C
    `check_contact` is a stub, so the C board emits none until it lands.
11. **PC-speaker / MT-32 driver variants**: not reproduced (SB stack only).
12. **OPENING.EXE / CLOSING.EXE cinematic audio**: out of scope.
13. **Sound Test dialog** is in neither port (no `@CUP` cheat menu, no
    DEBUG.TXT in the bundles); its engine path is the boards' bench
    command `a <id>` → `au_cmd`. Pick Music and Sound Options ARE in both
    input layers and reach the engine through `SND_PICK` / `SND_SWITCHES`
    (`au_on_sound`); `tools/input_compare.py` slice 9 drives both.
14. **Command 8 timing**: the original polls the driver each idle tick;
    the port answers from the voice flags at the moment of the call —
    the same answer, minus the ISR granularity.
