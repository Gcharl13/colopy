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
| SFX id → COLDIG.BIN (offset,len) map | **empirical capture** (`data_extracted/data/coldig_slices.json`) |
| SFX payload bytes | **bit-clean** (verbatim COLDIG.BIN slices) |
| Fanfare banks (0x8020+power, 0x8024) | **TBD** until captured |
| Driver-internal behaviours (SFX preemption, stop nuances) | **modelled** (approximation) |
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
tools/audio/trim_normalize.py                       tools/audio/map_coldig.py
  trimmed masters + manifest                 cross-correlate vs COLDIG.BIN →
                                             data_extracted/data/coldig_slices.json
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
payload SFX: verbatim COLDIG.BIN slice (sha256 == slice named in
        coldig_slices.json — enforced by generator + validator).
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
Mixer: 2 voices (music stream + one SFX one-shot; a new SFX preempts the
playing SFX — modelled, see Approximations).

## Size budget (estimates; tune lengths are capture-derived)

| Asset | Codec | Size | Teensy 4.1 | ESP32-P4 |
|---|---|---|---|---|
| SFX bank (≤32 ids) | PCM8 @ 11025 | ≤ 970 KB | SD (or flash blob; ~4.9 MB free) | SD (or 16 MB flash) |
| ~28 tunes + fanfares | IMA4 @ 22050 ≈ 11 KB/s | est. 20–55 MB | **SD only** | **SD only** |
| Engine RAM | — | ~25–35 KB static | OCRAM | SRAM/PSRAM |

## Approximations catalogue (live; mirrored in cport/audio/README.md)

- SFX id→slice mapping: empirical (correlation scores + `"approximate"` flags
  in `coldig_slices.json`).
- Tune renders: empirical captures of the real driver under DOSBox's OPL
  emulation — authentic hardware behaviour, not byte-derived sequences.
- Tune lengths / loop behaviour: capture-derived.
- Fanfare banks: TBD until captured.
- SFX preemption + in-driver stop semantics: modelled.
- Scheduler PRNG: wall-clock-seeded xorshift standing in for the RTL rand
  (the original seeds from the tick clock `[0x83A8]` — same class).
- `[0x5386]` switch-bit mapping: pinned in Phase A, else shipped TBD with
  default all-on (0x07).
- PC-speaker and MT-32 driver variants: not reproduced.
- OPENING.EXE / CLOSING.EXE cinematic audio: out of scope.

## Verification

- `cport/host`: `smoke --audio` (scheduler unit tests with injected PRNG
  against the pinned algorithm; mixer golden-WAV sha256; ADPCM round-trip
  vs the Python encoder) and `smoke --audiopak` (TOC sanity; SFX slice
  byte-identity against `raw/COLONIZE/COLDIG.BIN` when present).
- `make test` unchanged and green (fidelity oracles untouched).
- A/B listen checklist per id (capture vs pack render) — § below, filled in
  Phase G.

## A/B listen checklist

*(Phase G — to be filled after the pack is built.)*
