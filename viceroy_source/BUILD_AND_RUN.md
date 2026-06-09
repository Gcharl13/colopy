# Building and running `viceroy_modern`

The modern executable: the decompiled rules layer + DGROUP memory model +
SDL2 video, loading all content from YOUR original game files at runtime
(no game data is in this repository -- supply your own COLONIZE install).

## Prerequisites

- gcc / cmake (>= 3.16) / python3
- SDL2 dev package (`apt install libsdl2-dev`, `brew install sdl2`, ...)
  -- optional: without it the build is headless (PPM frame dumps only)
- your original Colonization data files (the directory containing
  `NAMES.TXT`, `VICEROY.PAL`, `*.PIK`, `*.SS`, ...)

## Build

```sh
cd viceroy_source

# 1. build the rules library
mkdir -p build_modern && cd build_modern
cmake .. && cmake --build . -j4          # builds libviceroy_rules.a

# 2. generate the link floor (wires overlay thunks to their real ported
#    targets + aliases DGROUP globals byte-exactly into g_dgroup)
cd .. && python3 tools/thunkwire.py && python3 tools/linkgap.py
#    (thunkwire needs re_work/VICEROY.EXE + re_work/*.json; if you don't have
#     the re_work artifacts, the committed tools/generated outputs of the last
#     run still link -- skip this step)

# 3. rebuild to pick up the floor -> the executable
cd build_modern && cmake .. && cmake --build . -j4
```

## Run

```sh
VICEROY_DATA=/path/to/COLONIZE ./viceroy_modern
```

| key | action |
|---|---|
| `4` / `n` | New game (title -> power select) |
| `1`..`4` | select nation (writes DGROUP:0x5398) |
| `1`..`5` | select difficulty (writes DGROUP:0x53A6) |
| `ESC` | back / quit |
| `F12` | screenshot -> `viceroy_shotN.ppm` |

Without a display the run is headless: it loads everything, exercises the
real title-screen logic, and dumps `viceroy_title.ppm` / `viceroy_nations.ppm`
as verification frames.

## What is real vs. reconstruction (current state)

- **Byte-verified rules**: everything in `libviceroy_rules.a` -- colony, unit,
  market, combat, king, AI, scoring logic at cited `@asm` offsets; the NAMES.TXT
  tables and terrain stats load to their byte-verified DGROUP addresses.
- **Reconstruction shell** (`main_modern.c`): the screen flow / key handling.
  The real data-driven `@BEGINMENU` menu runner (0x181F:0x3FE) is not yet
  ported; the shell presents the real backdrops + palettes and routes
  selections through real dispatch + real DGROUP state.
- **Weak-stub floor**: unported leaves no-op safely; `docs/LINK_GAP.md` and
  `docs/THUNK_WIRING.md` are the shrinking worklists. Port a function, re-run
  the two tools, the floor shrinks.

## Next milestones

1. In-game map loop: `game_main_loop()` + .SS sprite-sheet decode (MS_SPRITE
   RLE) -> terrain/unit rendering into the same Mode-13h layer.
2. GAME.TXT / LABELS.TXT loaders (same section-read pattern as NAMES.TXT).
3. The 190 mid-function-entry thunks + remaining `not yet decoded` interiors.
4. Save/load (AH=4E/4F directory scan in src/runtime/dos_io.c is stubbed).
