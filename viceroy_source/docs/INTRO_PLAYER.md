# Intro player (ROUTE_B Phase 6.4)

The original boxed boot runs **OPENING.EXE** (a separate 89 KB MADS media
player) before VICEROY.EXE: it reads the **OPENING.TXT** animation script, draws
the **OPENING.PIK** backdrop + palette and the **OPEN\*.SS** sprite series, plays
the timed credits + opening animation, prints "Loading Game...", then chains to
the title. `src/ui/intro_player.c` is the modern port, data-driven entirely from
the user's own files (copyright rule).

## What's done (data-driven core — verified)

- **`OPENING.TXT` parser** (`intro_load_script`): the self-documented script
  format — `@CREDITS` (start_frame, end_frame, series, sprite), `@OPENING`
  (series, frame, repeats, baseX), `@MESSAGES`. Verified against the real file:
  **19 credit cards, 13 animations, end_frame 891, "Loading Game..."**.
- **Series → sheet binding** (byte-derived: the shipped `.SS` filenames match the
  script's inline labels 1:1):
  `0 OPENWND1 · 1 OPENSUN · 2 OPENMON1 · 3 OPENWND2 · 4 OPENMON2 · 5 OPENMON3 ·
  6 OPENFISH · 7 OPENGUY · 8 OPENLOGO · 9 OPENBONK`; credits `0/1/2 →
  OPENCRD1/2/3`.
- **Sequencer** (`intro_play`): frame loop 0..end_frame firing each animation at
  its trigger frame and each credit card during its `[start,end]` window, then
  the "Loading Game..." message.
- **Pre-title boot stage**: wired in `main_modern.c` after `vid_init` (display
  present), faithful to the OPENING.EXE→title order. Headless it validates the
  script and returns (weak render hooks). `--introtest` reports the schedule.
- **Assets**: `OPENING.PIK` decodes via the existing `pik.c` (MADSPACK 2.0 +
  FAB: 8-byte header + pixels + 768-byte palette). `AMERICA.MOV` (572 B) is a
  small bitmap (the Americas shape), not a video.

## Remaining refinement (needs OPENING.EXE player-loop decode + Phase 5)

`OPENING.EXE` is disassembled (324 functions via Ghidra, `x86:LE:16` MZ loader),
but 16-bit string-xref recovery is partial, so these are not yet byte-pinned:

- **Visual renderer** (`intro_render_*` strong overrides in `src/platform/`):
  decode each `OPEN*.SS` series and blit the per-frame sprite at its script
  position. The exact per-frame sprite selection and (x,y) from `baseX` + the
  animation curve live in OPENING.EXE's frame loop.
- **Frame cadence**: the ticks-per-frame rate (the schedule is exact; the wall-
  clock pacing is OPENING.EXE's).
- **Audio sync**: the opening music — Phase 5 (audio), currently out of scope.

The schedule (what plays when) is exact from `OPENING.TXT`; the above are the
"how it's drawn/timed/heard" details that finish the byte-faithful playback.
