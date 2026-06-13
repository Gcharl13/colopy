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

## Visual renderer (DONE + verified)

`src/platform/intro_render_glue.c` implements the render hooks and is verified
by rendering real key frames to PPM (`--introrender`, headless):

- `OPENING.PIK` decodes via `pik.c` (MADSPACK 2.0) — it is the "Sid Meier's
  COLONIZATION" logo card; rendered correctly (frame 0/891).
- The `OPENCRD*.SS` credit cards decode via `ss.c` and composite in their
  `[start,end]` windows (verified: "COMPUTER GRAPHICS BY" at frame 200).
- The `OPEN*.SS` animation series load and the `intro_play` sequencer drives
  the frame loop; `--introrender` dumps frames {0,50,200,400,600,891}.

Pipeline verified end to end: parse → schedule → decode (PIK + SS) → composite
→ present (`vid_present` / headless `vid_screenshot_ppm`).

## Remaining refinement (needs OPENING.EXE frame-loop decode + Phase 5)

`OPENING.EXE` is disassembled (324 functions via Ghidra, `x86:LE:16` MZ loader),
but 16-bit string-xref recovery is partial, so these are reconstructed, not yet
byte-pinned:

- **Voyage-scene composition**: the opening voyage (Wind/Sun/Monsters/Fish/ship-
  bonk/guy) plays over a sky-sea scene *before* the logo/credits phase; the
  current renderer uses the `OPENING.PIK` logo as the backdrop throughout
  (correct for the credits phase). The exact two-phase composition + the
  per-frame sprite selection and `(x,y)` from `baseX` live in OPENING.EXE's loop.
- **Frame cadence**: the ticks-per-frame wall-clock pacing (the schedule frames
  are exact; the pacing is OPENING.EXE's).
- **Audio sync**: the opening music — Phase 5 (audio), out of scope by the
  current phase boundary.
