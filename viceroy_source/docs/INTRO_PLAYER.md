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

## Visual renderer (DONE + verified — frame-loop decoded)

`src/platform/intro_render_glue.c` is now a faithful port of OPENING.EXE's
player loop. The loop is fully decoded in **docs/INTRO_FRAMELOOP_DECODE.md**
(frame loop `FUN_1000_0aac`, scheduler `FUN_1000_0724`, compositor
`FUN_1000_042c`, scroll `FUN_1000_036e`, cadence `FUN_1000_0922`). Verified by
rendering key frames to PPM (`--introrender`, headless; frames
{0,50,200,400,600,891}):

- **Backdrop = `OPENING.PIK`, a 960×132 voyage panorama** (NOT the logo — that
  earlier assumption was wrong). A 320-wide window PANS across it; the scene
  scrolls while sprites stay screen-fixed (proven: OPENSHIP's 8 frames share one
  `(x,y)`). `OPENBORD.PIK` frames the play window.
- **Sprites are event-triggered**: each `@OPENING` series activates at its
  trigger frame, advances its own sheet frame, holds the last frame when
  `repeats==0` (the guy holds `nframes-5`), loops `repeats` times otherwise.
  Series 1 (Sun) uses the hand-keyed frame ladder; series 8 (logo, `OPENLOGO.SS`)
  shows at frame 767; series −1 ends @891. Each blits at its `.SS` per-frame
  `(x,y)` screen anchor (bottom-center registration), clipped to 320×132.
- **Credit cards** (`OPENCRD1/2/3.SS`) composite in their `[start,end]` windows
  (verified: "GAME DESIGN BY"@50, "COMPUTER GRAPHICS BY"@200; logo @891).

Pipeline verified end to end: parse → schedule → decode (PIK + SS) → composite
(pan + event-triggered sprites + credits + logo) → present (`vid_present` /
headless `vid_screenshot_ppm`).

## Remaining refinement (documented residual — needs a DOSBox runtime trace)

The model is byte-decoded; these last values are runtime data, not statically
recoverable from the decompile, so the renderer reconstructs them:

- **Scroll-position table** (`OPENING.EXE` DGROUP `0x4f0e`) and **cadence**
  (`0x48` ticks/frame): the modern pan is linear in the frame number; capturing
  the exact table needs a DOSBox memory trace.
- **Z-order swap at frame 507** (the scene draws over sprites in the late phase):
  the modern renderer keeps scene-behind-sprites throughout (drawing an opaque
  scene over the sprites would hide them).
- **Logo palette cross-fade** (`FUN_1373_000a` DAC upload): the modern renderer
  sets the scene palette directly.
- **Audio sync**: the opening music — Phase 5 (audio), out of scope here.
