# Viceroy on the Teensy 4.1

The same reconstructed game the desktop players run — the platform-free
`forge::GameShell` (sim core + screen composers, 320×200 indexed surface) —
compiled for the Teensy 4.1's Cortex-M7 with a bare-metal frontend.

**STATUS: compile-verified port, not yet run on hardware.** The core is the
identical C++17 the desktop builds test every commit; the board-specific
pieces (SPI display timing, USB host, SD throughput, PSRAM pressure) need a
bench pass. Expect to tune `Ili9341::SPI_HZ`, pins, and boot time.

## Hardware

| Part | Notes |
|------|-------|
| Teensy 4.1 | 600 MHz IMXRT1062, 1 MB RAM, 8 MB flash |
| **PSRAM** (required) | solder to the underside pads — 8 MB minimum, **2×8 MB recommended**: the record store + decoded art live there |
| ILI9341 320×240 SPI TFT | the 320×200 game screen, letterboxed 20 px top/bottom |
| microSD card | the game data (see below); the built-in socket |
| USB keyboard (optional) | on the USB **host** port; full key map |
| 6 push buttons (optional) | Up/Down/Left/Right/Enter/Esc fallback input |

### Wiring (defaults in `src/main.cpp` / `src/ili9341.hpp`)

```
ILI9341:  VCC->3V3  GND->GND  CS->10  DC->9  RST->8
          MOSI->11  SCK->13  MISO->12 (unused)  LED->3V3
Buttons:  pin -> button -> GND (INPUT_PULLUP)
          UP=2  DOWN=3  LEFT=4  RIGHT=5  ENTER=6  ESC=7
```

## SD card

Copy the **player package data** to the card root (FAT32/exFAT):

```
data/            data_extracted/          docs/atlas/pik/
                 docs/atlas/sprites/atlas_PARCH.png
```

That is the `Viceroy-win64` package minus the `.exe` (build it with
`tools/package_player.py --out <dir>` from the repo). To trim boot time and
memory you may delete `data/base/sprt/` (the editor's sprite catalog — the
player reads the tileset sheets directly).

## Build & flash

```
pip install platformio
cd teensy
pio run                # compiles the whole game for the imxrt1062
pio run -t upload      # flashes over USB
```

The serial monitor (115200) prints boot progress and errors ("SD card not
found", missing data folders).

## How the port works

- **One game, three frontends.** `forge::GameShell` is the entire game;
  `src/main.cpp` here is ~150 lines: pump keys in, blit the surface out.
- **Files**: newlib's `_open/_read/_lseek` syscalls are implemented over the
  SD library (`src/sd_syscalls.cpp`), so the shared loaders' `std::ifstream`
  reads the card without modification.
- **Memory**: global `operator new` routes allocations ≥ 1 KB to PSRAM
  (`extmem_malloc`); the internal 1 MB stays for stacks and hot state.
- **Display**: palette → RGB565 LUT per frame, rows streamed over SPI at
  ~15 fps (a full frame is 128 KB of pixel data; 40 MHz SPI moves it in
  ~26 ms).
- **Exceptions ON** (`-fexceptions`): the loaders throw to signal missing
  files; the shell catches at boot.
