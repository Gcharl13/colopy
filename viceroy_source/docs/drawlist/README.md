# UI Draw-List — complete byte-cited decode of every VICEROY.EXE screen

**Goal (user directive, 2026-05-31):** "this ui is pretty simple — this screen,
these sprites, this string, this location ... decompile whatever's needed so
there is no question of if something is missing."

This directory is the **single source of truth** for the original game's UI, for
BOTH the C reconstruction (`viceroy_source/src/ui/`) and the test-harness ports
(`colonize_sdl/`, `colonization_godot/`). Every screen is reduced to a complete
draw-list: for each paint operation, **what** (sprite sheet+index / string
source / rect / line / gauge), **where** (x, y), and **how** (font, color, fill
fraction) — with **every value cited to a VICEROY.EXE file offset or a named
data table**. Genuinely unresolvable values are tagged `NEEDS VERIFICATION`,
never guessed (CLAUDE.md prime directive).

## Why this is now possible (the unblock)

The 2026-05-28 premise that the core/UI code was "blocked behind un-disassembled
overlay 0x191F / 0x181F" was **wrong**. Those `lcall 0x191F:NNN` dispatches are
**statically resolvable**:

```
target_file_offset = code_offset(page_id) + (ljmp_seg << 4) + offset_in_segment
page_id = static trailer word @thunk+0x0A   (segment list @file 0x192F0)
DGROUP  = handle + 0x1D9A0
```

Resolver: `reverse_engineered/tools/rtlink/rtlink_decode.py`
(`resolve <page> <off>` / `flatten` / `info` / `validate`). `validate` passes
ALL byte self-checks, including `resolve(0x10, 0x352) == 0x5B2C2` landing on the
combat resolver's clean `ENTER` prologue. Proof of method end-to-end: the F3
Continental Congress body (func_037A10) was decoded and conformed
(0.8%→53.5% vs DOS ref). See `docs/RULINGS.md` commit 199.

## The decode (one file per surface group)

| File | Surfaces |
|---|---|
| `REPORTS.md` | the 9 F-key advisor bodies (F1 Terrain … F9 Indian), via selector func_0235D6 |
| `EUROPE_COLONY.md` | Europe overlay band (per-ship slots, status strings, info-line) + colony terrain scene |
| `CHROME_AND_DISPATCH_INDEX.md` | master painter→offset index + Title / Main-menu / Nation / Difficulty / Enter-name / Load-game / King / Hall-of-Fame / Map-HUD / shared popup frame / menu bar+dropdowns |

## How the ports consume this

For each screen, the port renderer (`colonize_sdl/render/screens.py`,
`.../hud.py`) is conformed element-by-element to its draw-list here. Pixel-verify
via `tools/ui_pixel_loop.py <SCREEN>` against `reference/dos/`. No coordinate,
sprite, string, or color enters a renderer without a citation that traces back
to an entry in this directory (enforced by `tests/check_no_fabrication.py`).

> Status: decode in progress (5 agents, 2026-05-31). This index lists the target
> structure; sections fill in as each surface is decoded. F3 is complete and
> already conformed in the port.
