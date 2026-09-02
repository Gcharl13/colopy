# AUDIO_PORT — the separately-scoped audio milestone (cport)

Commissioned 2026-08-16 (user directive; ruling in `notes/rulings/RULINGS.md`
2026-08-16). This document is the design + provenance record for the audio
port. It is a **pragmatic-tier** effort: the fidelity done-bar ("100% identical
except audio") is untouched, and everything here that is not byte-cited is
explicitly marked as `empirical capture` or `TBD`.

## Scope decisions (user)

1. **Target:** the embedded C port (`cport/`) — Teensy 4.1 and CrowPanel
   Advance 7" ESP32-P4 — as a separate module `cport/audio/`, compiled out of
   any build that does not define `COLOPY_AUDIO`. The JS port keeps its
   `playTune` stub.
2. **Music:** offline OPL2 render. Each tune is rendered ONCE, offline, by the
   original `?SOUND.COL` driver running the real game under the DOSBox harness;
   the captures ship as compressed audio. No runtime FM synthesis.
3. **Fidelity:** pragmatic first pass. Working audio now; every approximation
   catalogued (§ Approximations, and `cport/audio/README.md`).

## Why capture instead of decode

The music sequence data, OPL2 patch tables, and the `COLDIG.BIN` per-effect
index all live inside the four MZ driver overlays and are not decoded
(`formats/COL.md`). Decoding them is the multi-session path the AUDIO_SPIKE
ruling scoped out. Running the *original driver* under emulation and recording
its output gives an authentic render of the same bytes without decoding them —
at the cost of provenance dropping from "byte-verified" to "empirical capture".

The one thing that must stay bit-clean is the SFX audio itself, and it does:
captures are used only to *locate* each effect inside `COLDIG.BIN`
(cross-correlation), and the shipped payload is the verbatim `COLDIG.BIN`
slice, sha256-checked against the committed slice table.

## What is byte-verified vs empirical vs TBD

| Layer | Status |
|---|---|
| Command-id space (<0x10 driver cmds; 0x20–0x3F tunes; 0x40–0x5F SFX; 0x8020+ fanfares), gates, switches | **byte-verified** (`spec/ui/options_dialogs.md` §5) |
| Tune-id ↔ name table | **byte-verified** (§24.1 tech ref) |
| Background scheduler algorithm (`func_004EE6`) | **byte-verified** (spec §4; remaining tail pinned in Phase A) |
| Event → cue map | **byte-verified** (§24.4 tech ref) — the cport wiring notes per-row confidence |
| Tune audio (renders), tune lengths, loop behaviour | **empirical capture** |
| SFX id → COLDIG.BIN (offset,len) map | **byte-verified** (`data_extracted/coldig_index.json` — the drivers' own sample table; `sfx_id_to_index` + `rate_rule` at ASOUND `0x00F19`). Superseded the empirical `data/coldig_slices.json` on 2026-08-17. |
| SFX payload bytes | **bit-clean** (verbatim COLDIG.BIN slices) |
| Fanfare banks (0x8020+power, 0x8024) | **TBD** until captured |
| Driver-internal behaviours (SFX preemption, stop, commands 0–8, no queue) | **byte-verified** from ASOUND.COL (spec/ui/options_dialogs.md §9, 2026-09-02); channel-record field meanings still glossed |
| PC-speaker / MT-32 driver variants; OPENING/CLOSING cinematic audio | **out of scope** |

## Pipeline (tools/audio/)

```
col.zip ──bin/reconstitute.py──▶ raw/COLONIZE/ (drivers + COLDIG.BIN + game)
                                      │
        tools/dosbox_harness (AUDIO=1, sb16 emulated, headless)
                                      │  in-game Sound Test cheat, per id
                                      ▼
        tools/audio/capture_audio.py ──▶ tools/audio/captures/*.wav (gitignored)
                                      │
          ┌───────────────────────────┴───────────────────────────┐
          ▼ tunes                                                 ▼ SFX
tools/audio/trim_normalize.py                       tools/decode_coldig.py
  trimmed masters + manifest                   read the .COL drivers' sample
                                             table -> data_extracted/
                                                      coldig_index.json
          └───────────────────────────┬───────────────────────────┘
                                      ▼
                    tools/gen_audio_pack.py ──▶ cport/pak/COLAUDIO.PAK
                                                (+ cport/data/colopy_audio_pak.h)
```

Captured WAVs and the pack are **regenerable and git-ignored** (repo policy: no
committed binaries); the committed artifacts are the two JSONs (slice table,
captures manifest) that make regeneration deterministic and auditable.

## COLAUDIO.PAK format (v1)

```
header  'CAUD' u16 version(1) u16 count u16 mix_rate(22050) u16 reserved
TOC     count × 16 bytes, sorted by id:
        u16 id        0x0020..0x005F tunes/SFX, 0x8020.. fanfares
        u8  codec     0 = PCM8 unsigned mono, 1 = IMA ADPCM 4-bit mono
        u8  flags     bit0 = loop (TBD from capture; default 0)
        u16 rate      11025 (SFX) or 22050 (music)
        u16 reserved  0
        u32 offset    payload start, from file start
        u32 len       payload bytes
payload SFX: verbatim COLDIG.BIN slice at the byte-decoded offsets in
        coldig_index.json; the whole bank is sha256-checked by both the
        generator and tools/audio/verify_pack.py, so every payload is
        bit-exact by construction.
        Music: IMA ADPCM in 1024-sample blocks, each block prefixed
        { i16 predictor, u8 step_index, u8 pad } — seekable for SD streaming.
```

## cport/audio module

Platform-free C11, static buffers only, no malloc, no I/O (streaming reaches it
through a shell-provided read callback). It never touches core state and is
absent from `colopy_digest()` — the fidelity oracles cannot move. Public API in
`cport/audio/colopy_audio.h`: `au_cmd(id)` (the gate, port of `func_00518E`),
`au_pump()` (the scheduler, port of `func_004EE6`), `au_queue_tune`,
`au_class_request`, switches (`au_set_switch`/`au_load_switches`), cue helpers
(`au_on_event`/`au_on_woodcut`/`au_on_new_game`), and the backend pull
`au_render(int16_t*, nframes)` at 22050 Hz s16 mono.

Backends own the DAC: host = deterministic WAV writer (tests) + optional
listen; ESP32-P4 = I2S DMA (gated on hardware verification); Teensy 4.1 = MQS.
Mixer: 3 voices after the driver's channel split — FM ch1–6 (tunes,
fanfares), FM ch7–9 (the SFX ids the driver renders on the OPL), the DSP
sample ring — each new-replaces-old, which is what the driver's handlers do
(spec §9).

## Size budget (measured, 2026-08-17 pack)

| Asset | Codec | Measured | Teensy 4.1 | ESP32-P4 |
|---|---|---|---|---|
| 16 digitized SFX | PCM8 slices @ 11025 | 383 KB | SD stream | SD stream |
| 51 renders (28 tunes + 15 FM sfx + 8 fanfares) | IMA4 @ 22050 (≈11 KB/s) | 25.5 MB | **SD only** | **SD only** |
| **COLAUDIO.PAK total** | | **25.9 MB** (67 entries) | | |
| Engine RAM | — | ~12 KB static (2 voices + TOC) + backend ring/DMA | OCRAM | SRAM |

## Capture results (2026-08-17, the full sweep)

Every id was driven through the Sound Test cheat under the stock-config
driver (DOSBox 0.74, sb16 at 220/7/1) and recorded:

- **SFX 0x40–0x5F (32 ids):** 29 sounded. 16 matched `COLDIG.BIN`
  cleanly (chunked cross-correlation, consistent DSP clock ≈ ×0.9966 of
  11025 across the fleet) and ship as **bit-clean slices**; 13 are
  FM-rendered by the driver (or partial/layered matches) and ship as
  renders. **0x46, 0x5E, 0x5F are silent** — unmapped ids in the driver,
  recorded as data, nothing shipped.
- **Tunes 0x20–0x3B, 0x3E, 0x3F (30 ids):** all sounded (3.6–166 s
  trimmed). **0x34 hit the 240 s capture cap** — it likely loops;
  flagged, shipped at cap length.
- **Fanfares 0x8020–0x8027 (8 ids):** all sounded (3.7–47 s) — the
  fanfare bank is real and fully captured (former open item V6).

## Approximations catalogue (live; mirrored in cport/audio/README.md)

- SFX id→slice mapping: **no longer an approximation** — byte-decoded from
  the sound drivers (`data_extracted/coldig_index.json`). The empirical
  correlation map `data_extracted/data/coldig_slices.json` is retained as a
  record of the capture work but is no longer read by any tool: it disagreed
  with the drivers on every shared id (offsets off by tens to thousands of
  bytes, lengths uniformly short) and mapped 0x59, which the drivers list as
  not a bank sample at all.
- Tune/fanfare/FM-sfx renders: empirical captures of the real driver under
  DOSBox's OPL emulation — authentic hardware family, not byte-derived
  sequences. Lengths/loop behaviour capture-derived (0x34 capped).
- SFX preemption (new kills old), stop semantics (cmd 1 = FM channels
  1–9, digital untouched), commands 0–8: **decoded** from ASOUND.COL
  2026-09-02; the "pending queue" is gone with the dead dispatcher ring.
  Still modelled: the `[0x24D]` digital-suppression state and the ring's
  FM fallback when full; commands 2/6/7 as stop/mute rather than OPL
  register writes.
- Scheduler PRNG: the RTL MS-C `rand` with both tick re-seeds — on a
  PRIVATE state by decision (RULINGS 2026-09-02c), not the sim's shared
  LCG the original actually re-seeds.
- Cue rows tagged `[inferred]`; European first-contact fanfare
  (0x8020+power) and combat SFX ids: not wired (no byte-cited row).
- PC-speaker and MT-32 driver variants: not reproduced.
- OPENING.EXE / CLOSING.EXE cinematic audio: out of scope.

## Verification

- `cport/host`: `smoke --audio` (scheduler unit tests with injected PRNG
  against the pinned algorithm; exact cross-language IMA round-trip; gate
  truth table; crossover ratios in binomial bounds) and
  `smoke --audiopak PAK COLDIG.BIN` (TOC walk + slice byte-identity) —
  both green; `make test` unchanged and green (fidelity oracles untouched).
- `tools/audio/verify_pack.py` — objective per-entry report: every slice
  **bit-clean**, every render decoded and SNR'd against its master
  (14.1–37.6 dB, median ≈ 26 — IMA's adaptive quantizer dips on
  transient-dense OPL content; the 12 dB gate is a regression floor, not
  a quality verdict). 67 entries, 0 failures.

## A/B listen pass (human, on hardware — the perceptual gate)

Not performable in this container. Protocol: enable `COLOPY_AUDIO` on a
board (or `aplay` the masters on a host), play each id via
`au_cmd(id)`/Sound-Test order, and compare by ear against
`tools/audio/captures/` (regenerable). Listen-first candidates: the
lowest-SNR renders 0x47 (0.5 s FM click, 14 dB), 0x5B, 0x27, 0x26,
0x8022, and the capped 0x34. Record outcomes here.
