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
- **Arduino IDE**: run `python3 tools/gen_arduino_sketch.py` (from the
  repo root), then open `cport/arduino/colopy/colopy.ino` — a generated,
  self-contained sketch folder (flattened copies of core/data/render/
  game with the includes rewritten; the display/USB-keyboard defines
  live in the banner at the top of the .ino since the IDE passes no -D
  flags).  Steps, board settings and the SD prep are in that folder's
  README.md.  Regenerate after pulling engine changes.

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

With the display+input build (`-DCOLOPY_ILI9341`, optionally
`-DCOLOPY_USBHOST`) two more commands come in:

    v                   draw the map view once (loads COLOPY.PAK)
    g                   game loop: the oracle-verified input layer
                        drives the Phase-7 renderers; keys arrive from
                        a USB keyboard on the host port, or over serial
                        as `k <name>` ("k Space", "k ArrowUp", "k F5",
                        "k !g" = Alt+G) for bench runs without one

The game loop draws the screen the UI state names (map + pulldowns,
reports, colony, Europe, boot screens) and overlays the pending game
event as a popup that swallows the next key — the same modal rule the
JS runs.  Both the panel flush and the keyboard bridge are UNTESTED ON
HARDWARE; the checklist below gates that flag.

## Board checklist (hardware bring-up — clears the UNTESTED flags)

1. Teensy 4.1.  PSRAM is only needed for the SD-pak variant (EXTMEM
   holds the ~3 MB pak); the Arduino sketch's default COLOPY_PAK_FLASH
   config compiles the pak into program flash instead — no PSRAM, no
   COLOPY.PAK on the card.
2. ILI9341 on SPI0: CS pin 10, DC pin 9 (override with
   `-DCOLOPY_TFT_CS/-DCOLOPY_TFT_DC`), MOSI 11, MISO 12, SCK 13.
3. microSD with `COLOPY.PAK` (tools/gen_sd_pack.py) + a `.SAV`.
4. PlatformIO: uncomment the display+input units and defines in
   `platformio.ini`, install `ILI9341_t3n`.
5. Serial: `l COLONY00.SAV`, then `v` — the map view must draw; check
   the reported draw/flush timings.
6. `g`, then `k Space` / `k Tab` — the unit cycle must step and redraw;
   a USB keyboard on the host port must do the same directly.
7. Run `t 100` afterwards and diff the digests against the host run —
   the display path must not perturb the sim.

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
