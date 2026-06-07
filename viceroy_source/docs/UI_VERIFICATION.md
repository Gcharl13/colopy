# UI & Visuals — what's decoded, and HOW TO TEST it

Answers: "where/how do I test that the UI and visuals are figured out?" Built
2026-05-30. Companion: `decompile_status.html` (function status), `RENDER_CHAIN.md`
(pixel pipeline — prose is RECONSTRUCTED, but the tile chain below is byte-verified).

## The three layers of "UI"
1. **Pixel pipeline** (`src/render/`) — VGA mode 13h (320×200×8bpp, framebuffer
   `0xA000:0`, full redraw each frame). `tile_chain.c` (O514→O513→O512),
   `terrain.c`, `blit.c`, `hud.c`, `units.c`, `tile_info_panel.c`. **Status: byte-
   verified, 0 skeletons.** This is the "what pixels go where" core and it is solid.
2. **Layout / geometry** (overlay) — where each box/row/label/sprite is placed:
   `render_frame_setup` (func_06787C, viewport span/origin/stride/zoom, centered on
   320×200), `panel_finalize_geometry` (func_06D316, dialog x/y/w/h + row stepping),
   the report-grid pitches (func_06FDF0 col×76+10 / func_0702C0 3-col), the
   difficulty/nation picker coords (func_070302 row, func_0707B6 nation). **Byte-verified.**
3. **Per-screen composition** (`src/ui/`) — assembles a whole screen from the above.
   `dialog.c`, `menu.c`, `king_audience.c`, `options_dialog.c`, `main_loop.c` are
   ported (0 skel). The `*_screen.c` files now carry **CODED, byte-traced element
   placement** (composer + ordered sub-renderers + coordinate/sprite table) — see
   the new **`SCREEN_LAYOUTS.md`** index. Done [V]: Europe (page 0x04, id 0x2B),
   Reports, Title, Hall-of-Fame, Map/HUD. In progress: Colony (page 0x03, id 0x2C
   — first pass mis-attributed the Europe composer; re-trace underway, see
   RULINGS 2026-05-30).

## Per-screen map — screen → DOS reference → draw functions → status → test

| Screen | DOS reference (reference/dos/) | Draw functions | Status | How to test |
|---|---|---|---|---|
| **Map / gameplay HUD** | `MAP_gameplay_dos_reference.png`, `AMER2_dos_reference.png` | render_frame_setup (06787C) → tile chain O514/O513/O512 (`render/tile_chain.c`) → terrain/blit; markers 067082/067182; info-panel 05E9B0 | **byte-verified** | **Automated**: `python tests/run_regression.py` (Python port map render vs `tests/golden/{AMER2,ONE,BLANK4}.png`). Visual: diff vs `MAP_gameplay`/`AMER2`. |
| **Tile info / unit-stack panel** | (in map captures) | `render/tile_info_panel.c` (func_05E9B0 two-pass measure+draw) | byte-verified | trace the flag→line dispatch vs an in-game stack readout |
| **Dialogs / pop-ups** | `popups/` | panel_construct (06C520) + panel_finalize_geometry (06D316) + dialog renderers (overlay_068A14) + `ui/dialog.c` | byte-verified | geometry is exact (320×200-centered); compare a known popup vs `popups/` |
| **Colony screen** | `COLONY_{plymouth,baltimore,jamestown}_dos_reference*.png` | `ui/colony_screen.c` (id 0x2C, entry 0x025EC8 → composer func_028592 + 11 sub-renderers) | **coded [V]** (SCREEN_LAYOUTS §3) | read the coded coord table; visual vs COLONY_* captures |
| **Europe / harbor** | `EUROPE_harbor_dos_reference.png` | `ui/europe_screen.c` (page 0x04, id 0x2B, composer 0x031E4C) | **coded [V]** (SCREEN_LAYOUTS §2) | read coded table (market bar / dock / recruits); visual vs `EUROPE_harbor` |
| **Reports** | (various) | `ui/report_screen.c`: dispatcher func_0235D6 + frame func_06FF94 + cell grids 06FDF0/0702C0 | **coded [V]** (SCREEN_LAYOUTS §4) | read the grid pitch (col·76+10); trace a report vs in-game |
| **Continental Congress / FF** | `CC_continental_dos_reference.png`, `CC_full.png` | (FF election + congress draw) | partial | visual vs `CC_*` |
| **Naval adviser** | `NAVAL_adviser_dos_reference.png` | (adviser screen) | partial | visual vs `NAVAL_adviser` |
| **Title / main menu** | `TITLE_screen_dos_reference.png` | `ui/title_screen.c`: composer func_0759E8; backdrop 0x233C; @BEGINMENU key 0x2345 | **coded [V]** (SCREEN_LAYOUTS §5) | visual vs `TITLE_screen` |
| **Hall of Fame** | — | `ui/hall_of_fame.c`: func_03A9C0 render + func_03ADA6 HALLFAME.DAT I/O (stride 42) | **coded [V]** (SCREEN_LAYOUTS §6) | read coded row layout; check HALLFAME.DAT record |
| **Opening cutscene** | — | the MicroProse/title cinematic player | **OUT-OF-SCOPE** (DOS platform: MOV/PCX/PAL playback) | n/a (excluded per scope) |

## How to TEST the UI (concrete procedures)
1. **Automated visual regression (map):** `python tests/run_regression.py` — renders the
   Python port (`colonize_sdl/`) of test maps and diffs against `tests/golden/`. This is
   the only screen with a golden baseline today. `tests/run_regression_godot.py` does the
   Godot port. (NOTE: per `docs/RULINGS.md`, the golden + `AMER2_dos_reference.png` validate
   STRUCTURE/placement, not raw pixels — the in-game PHYS0/TERRAIN.SS style differs from the
   editor-export reference; don't pixel-chase the editor export.)
2. **Per-screen visual check:** open `reference/dos/<SCREEN>_dos_reference.png` beside the
   Python/Godot port's render of that screen. The DOS captures are the pixel ground truth
   (320×200 ×4 from real DOSBox gameplay — see `reference/dos/CAPTURE_PLAN.md`).
3. **C-decompile layout check (no run needed):** for any screen, the draw functions in the
   table carry `@asm`-cited coordinates/sprite-ids/string-ids — verify a placement by
   reading the function (e.g. render_frame_setup's `0x10>>zoom` tile size, the report grid
   `col×76+10` pitch) and confirming it matches the pixel positions in the DOS capture.

## Honest gaps (what's NOT fully figured out)
- **Coded layouts now exist [V]** for Map-HUD / Europe / **Colony** / Reports /
  Title / Hall-of-Fame (see `SCREEN_LAYOUTS.md`). Colony was re-traced to its real
  composer func_028592 (the first pass mis-attributed the Europe composer 0x031E4C
  — RULINGS 2026-05-30). A few leaf constants remain `[recol-xref]`/TBD-inner: the
  Europe banner pixel origin, and the colony per-type BUILDING.SS sprite indices
  (one call deeper than the building loop).
- **Continental Congress / FF** and **Naval adviser** screens are not yet coded.
- **No golden regression images** exist for colony / europe / reports — only the map. Adding
  per-screen goldens (captured per `CAPTURE_PLAN.md`) would make those screens automatically
  testable instead of eyeball-only.
- A few overlay report dialogs are `TBD-inner` (e.g. the 854 B `dialog_dispatch`); their
  outer layout is decoded, inner per-row wiring is cited-but-not-expanded.
- The **cutscene/cinematic** player is intentionally out of scope (DOS media playback).

**Bottom line:** the map/tiles/dialog **geometry is byte-verified and map-testable today**
(`run_regression.py` + the DOS captures). The full-screen *composition* of colony/europe/
reports is the partial layer — decoded in primitives, not yet assembled in the `*_screen.c`
shells, and lacking golden baselines.
