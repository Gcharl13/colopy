# Storage map — where every byte of the game lives on a board

Two targets ship: the **Elecrow CrowPanel Advance 7" (ESP32-P4)**, which is
the playable build, and the **Teensy 4.1**, which came first and is kept as a
second implementation of the same core. Guiding rule for both: **the core
never does I/O** — anything on the SD card reaches it through a buffer via the
`colopy_core.h` API, so the sim stays platform-free and host-testable.

## The numbers that do not depend on the board

These are static sizes of the C core, measured on the host build
(`cd cport/host && make`, then `size`/`nm` on the objects — re-measured
2026-08-17, after the audio merge). They are the same on any target.

| Object | Bytes | What |
|---|---:|---|
| `RD` (`render/colopy_render.o`) | 77,744 | the 320x200 8-bit framebuffer + render scratch |
| `CS` (`colopy_state`) | 39,788 | the .SAV image + record pools; printed by `cport/host/smoke` |
| `CR` (`colopy_runtime`) | 39,364 | the JS object-model state beside the records: per-colony runtime, tribe/village meters, rival lists, the order lists |
| `colopy_boot_render.o` | 22,464 | boot/title/menu scratch |
| `colopy_colony_render.o` | 6,448 | colony scene bands |
| `colopy_input.o` | 5,360 | dialog rows, pointer, menu state |
| audio (`audio/*.o`) | 9,508 | 3 voice structs (2,600 each: FM ch1-6 / FM ch7-9 / DSP, 2026-09-02) + pak TOC |
| **total BSS, core+render+game+audio** | **219,304** | |
| **total `.data`** | 3,372 | |
| `colopy_data.o` | 11,264 text + 8,648 data | the sim's numeric tables (yields, cargo, units, buildings, jobs, map, tribes) — `const`, so flash |
| `colopy_text.o` | 151,814 text + 42,752 data | event/pedia/dialog bodies. Display text only; the sim never reads it (the generator refuses to emit if a `cport/core/*.c` references a text symbol) |
| core+render+game+audio `.text` | 275,898 | x86-64 `-O2`; Thumb-2 / RISC-V typically come out smaller |

A `.SAV` is 22–28 KB, so an 80 KB save buffer covers load and save with
headroom on either board.

**`CR` grew from 11,892 bytes (Phase-3 close) to 39,364** as the rival AI,
village meters, trade routes and sail-home state landed. That is the number to
watch: it is static, it is not optional, and it lives in whatever the target
calls "fast RAM".

## ESP32-P4 (CrowPanel Advance 7") — the playable build

Sketch: `cport/p4/colopy_p4.ino`, generated into `cport/arduino_p4/colopy_p4/`
by `tools/gen_arduino_p4_sketch.py`.

| Store | What lives there |
|---|---|
| Internal SRAM | every static above (~219 KB BSS + 3 KB data), the loop task's stack, and the IDF/Arduino runtime's own allocations |
| PSRAM (heap, `heap_caps_malloc(..., MALLOC_CAP_SPIRAM)`) | `fbuf` 1,228,800 B (1024x600 RGB565), `pakbuf` 8,000,000 B cap, `savbuf` 80,000 B, `sidebuf` 8,192 B — plus the MIPI DPI driver's own frame buffer, allocated *before* the sketch runs |
| Program flash | core code, `colopy_data`, `colopy_text` |
| microSD | `COLOPY.PAK` (3,148,409 B today), `COLAUDIO.PAK` when present, `.SAV` files + their `.CPX` sidecars — the only writable store |

**Tools ▸ PSRAM must be Enabled.** Without it the DPI driver cannot allocate
its ~1.2 MB frame buffer and fails before any of the above is attempted:
`esp_lcd_new_panel_dpi(239): no memory for frame buffer` → `board=nullptr` →
black screen. Arduino stores board settings per sketch-folder path, so a fresh
unzip reverts them.

**Do not add statics.** The core's BSS is already the dominant internal-SRAM
consumer, which is why `sidebuf` and the pak buffer are PSRAM allocations
rather than arrays. It is also why the host build compiles with
`-Wframe-larger-than=4096 -Werror`: a 25,600-byte scene band on the stack
smashed the loop task on 2026-08-17, and a 1,216-byte array deep in the
end-turn chain did it again the same day.

**Per-frame ceilings do not catch depth**, and depth is what every crash
after the first one actually was. `make test` therefore also runs
`tools/stack_budget.py`, which compiles the core with `-fstack-usage` for
frame sizes, reads the call edges out of `objdump -d`, and reports the
max-weight path from each of the board's entry points. The gate is
`--limit 4096`. Current worst paths:

| entry | bytes | path |
|---|---|---|
| `in_key` | 2,352 | `in_key_inner` → `build_picker_commit` → `build_rows` |
| `in_click` | 2,048 | `in_click_inner` → `build_picker_commit` → `build_rows` |
| `rm_draw_colony` | 1,376 | `gauge_strip` |
| `rm_draw_dialog_rows_notes` | 688 | `draw_speaker` |
| `rm_draw_europe` | 640 | `crossing_cell` → `draw_sack` |

Recursion cycles and calls through function pointers are reported
separately and are NOT in these totals — the tool says so on every run.

**The one sanctioned exception to "do not add statics"** is UI scratch on
the deep path. The two input dispatchers sit at the top of the whole
command chain (`in_click_inner` → `run_menu_row` → `cmd_*` → `advance` →
`end_turn`), so a row buffer there is charged against every frame beneath
it. `erows`/`enotes`/`erp`, `trows`, and the three `rm_mrow` row arrays
are file-scope statics for that reason. The trade, measured:

- BSS `colopy_input.o` 5,360 → 14,528 bytes (**+9,168**, paid once)
- stack `in_key` 5,200 → 2,352, `in_click` 4,192 → 2,048 (**−2,848 peak**)

BSS is the plentiful side of this budget and the stack is the scarce one:
the loop task has a few KB, the core's BSS has ~219 KB of a much larger
pool. Converting a variable peak into a fixed cost is the right direction
here — but it is an exception with a reason, not a licence. The UI is
single-threaded and non-reentrant, which is what makes it safe; anything
that could be entered twice must not do this.

**Measure, do not quote.** How much internal SRAM is actually free after the
IDF, the DPI driver and the Arduino runtime have taken their share is a
hardware fact, so the sketch reads it out rather than asserting it:

- `m` over serial — internal SRAM free/total/largest-block/min-ever-free,
  PSRAM free/total/largest-block, our four PSRAM buffers, and the stack mark.
- `w` over serial (also printed once at boot) — the loop task's stack
  high-water mark. A number near zero means the next deep screen will crash.

Those two numbers from a live board are what this document is missing, and the
only reason the P4 rows above carry no free-space figures. Nothing here should
be filled in from a datasheet.

**`pakbuf` is 8 MB against a 3.1 MB pack.** It was 3.5 MB, which left 10%
headroom while Part E of `docs/REMAINING_WORK.md` still has 139 `.SS` sheets
and 7 `.PIK` backgrounds to ship. `sd_read_file()` now sizes a file before
reading it and refuses one that would not fit, because a plain `fread(cap)`
returns a truncated prefix and `rd_init()` accepts a prefix whose header still
parses — the pack would have come up quietly missing its tail assets.

## Teensy 4.1

Harness: `cport/teensy/` (PlatformIO). SD `.SAV` in, full turns,
`colopy_digest()` per turn on the serial wire — matched against the host's
`--saveout`/`--turns` run from the same seed.

| Store | Size | What lives there |
|---|---|---|
| ITCM/DTCM | 512 KB | code hot paths + stack (toolchain-managed) |
| OCRAM | 512 KB | the statics above (~219 KB) + the SD I/O buffer (80 KB, one save) + the event ring |
| Program flash | 8 MB | core code + `colopy_data` + `colopy_text` (~195 KB) |
| microSD | GB | `.SAV` files, `COLOPY.PAK` |

`colopy_text` can be dropped from flash entirely: `COLOPY.PAK` carries a `TEXT`
section with the exact same 3,137 key/value pairs, so a flash-constrained build
serves the strings from SD instead. The split exists so that choice stays open.

## The SD asset container

`tools/gen_sd_pack.py` builds `cport/pak/COLOPY.PAK` (git-ignored, 3,148,409 B):
67 sprite sheets (8-bit indexed + frame tables), 28 PIK backgrounds, the 5
engine fonts verbatim, `VICEROY.PAL` as RGB888, the `CYCLE.DAT` band, and the
`TEXT` section. TOC contract: generated `cport/data/colopy_pak.h`; validator and
census: `cport/host/smoke --pak`, diffed against the JS `DATA` census by
`tools/sim_compare.py pak`.

`tools/gen_audio_pack.py` builds the optional `COLAUDIO.PAK` beside it — SFX as
verbatim `COLDIG.BIN` slices at the byte-decoded offsets, music as IMA renders.
Validator: `cport/host/smoke --audiopak FILE COLDIG.BIN`. Both packs stream
from SD; neither is ever resident whole beyond `pakbuf`.
