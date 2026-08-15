# Colopy on Teensy 4.1 — the serial digest shell (C-port Phase 4)

The sketch drives the **same parity-verified core** the host harness
runs: `colopy_load_sav` on a `.SAV` read from the built-in microSD,
whole `endTurn()`-equivalent steps (`turn_step_prefix` → `turn_step2` →
`turn_step3` → `turn_step5`), and `colopy_digest()` after each turn.
The digest printed on the wire must match the host run turn for turn —
that is the hardware acceptance test.

## Build

This repo's dev container has **no `arm-none-eabi` toolchain**, so the
cross-build must run on your machine:

- **PlatformIO** (recommended): `pio run` in this directory — the
  `platformio.ini` pulls in `cport/core/*.c` + `cport/data/colopy_data.c`
  alongside the sketch.
- **Arduino IDE**: copy (or symlink) `cport/core/*.{c,h}` and
  `cport/data/colopy_data.{c,h}` into the sketch folder first; the IDE
  only compiles sources inside it.

`cport/data/colopy_text.c` (~220 KB of display strings) is deliberately
NOT part of the build — the core never references it (the generator
refuses to emit if it does), so the sim runs without it.

## Use

Copy a `.SAV` (e.g. the shipped `COLONY00.SAV`) to the microSD, open a
115200-baud serial monitor:

    l COLONY00.SAV      load
    t 100               run 100 turns, one digest line per turn
    d                   print the current digest
    i                   overview (year/turn/counts/tax)
    s OUT.SAV           write the state back to SD

To verify against the host: `cport/host/smoke --saveout sav1653 100 f.sav`
runs the same 100 turns from the same seed; the digests and the written
save must agree byte-for-byte with the shell's.

## Memory fit (measured, host x86-64 `-O2`; Thumb-2 is typically smaller)

| piece                         | size      | Teensy 4.1 home        |
|-------------------------------|-----------|------------------------|
| `colopy_state` (the .SAV image in record form) | 39,788 B | DTCM/OCRAM (of 1 MB) |
| `colopy_runtime` (JS-object-model state)       | 11,892 B | DTCM/OCRAM          |
| SD I/O buffer (`savbuf`)      | 80,000 B  | OCRAM                  |
| core code (`.text`, 11 units) | ~67 KB    | flash (of 8 MB)        |
| sim data (`colopy_data`)      | ~20 KB    | flash                  |
| display text (excluded)       | ~180 KB   | flash or SD, later     |

Everything is static — no heap use anywhere in the core.

## SD container ruling (2026-08-15, user decision)

The microSD carries **COLOPY.PAK** (built by `tools/gen_sd_pack.py`), not
the original DOS files. Reading the originals as-is was assessed and
declined: it would need the MADSPACK/FAB/RLE codecs ported on-board
(~300 lines, references exist in `tools/ssdec.py`) for no RAM saving —
decoded pixels are ~3 MB in PSRAM either way — while the pak keeps the
board free of decode code, boots faster, and is cross-checked against
the JS DATA census at generation time (`sim_compare.py pak`). Display
text stays in flash as `colopy_text.o`; the pak's TEXT section remains
the fallback container if flash pressure ever demands it.
