# Render Ground-Truth & Per-Screen Gap Analysis

This is the working roadmap for making every UI screen match the original
MicroProse Colonization (VICEROY.EXE, 1994) **pixel-for-pixel**. It exists so
the work can be continued without re-deriving anything: it records the
ground-truth capture method, the exact differences found per screen, and the
palette/colour data needed to fix them.

## Ground-truth capture (reproducible)

The original `VICEROY.EXE` runs under `dosbox-x` headless via `Xvfb`; screens
are grabbed with `xwd` and cropped to the 320×200 framebuffer. The user's game
data is at `/home/user/colodata/game/` (gitignored, never committed). Captured
references live in `/home/user/colodata/refs/` (outside the repo).

```sh
# 1. virtual display (24bpp — 8bpp makes dosbox-x SDL2 segfault)
Xvfb :100 -screen 0 1024x768x24 -nolisten tcp &     # run in background

# 2. dosbox-x config: mount the game dir, autoexec VICEROY.EXE
#    [dosbox] machine=vgaonly ; [autoexec] mount c <gamedir> / c: / VICEROY.EXE
DISPLAY=:100 dosbox-x -conf /tmp/dbx.conf -nomenu &  # run in background

# 3. the dosbox window is 640x400 centred in 1024x768 -> crop at +192+184
DISPLAY=:100 xwd -root -silent > cap.xwd
convert cap.xwd -crop 640x400+192+184 +repage -resize 320x200! ref.png
```

Navigation uses `xdotool`. **Important:** plain `xdotool click` / `--repeat`
are unreliable into dosbox-x; use explicit `mousedown`/`mouseup` pairs. Open a
colony by double-clicking its building tile (explicit down/up ×2). Load a saved
game (the `COLONY0x.SAV` slots are real games with colonies) via the GAME
dropdown (mousedown on GAME, drag down, mouseup on "Load Game"), then confirm
with `Return`.

## Asset inspector

`tools/asset_inspect.c` (committed) dumps `.PIK`/`.SS` assets to PPM and prints
palette indices. Build:

```sh
D=build/CMakeFiles/viceroy_modern.dir/src/platform
gcc -O2 -Iinclude tools/asset_inspect.c $D/pik.c.o $D/ss.c.o stubs.c -o asset_inspect
#   stubs.c provides vid_framebuffer()/vid_get_palette() returning static buffers
asset_inspect pikpal OPENMENU.PIK   # palette w/ green/gold tags
asset_inspect ss     WOODTILE.SS 0 out.ppm
```

## Palette fact that bit us

Each PIK carries its **own** palette, which differs from the in-game master
(VICEROY.PAL / TERRAIN.SS palette) in ~31 entries — and those entries are
exactly the UI-colour slots. e.g. OPENMENU palette index 7 = gray `aa aa aa`,
8 = `55 55 55`; the master is also gray there. So the menu's fixed style
indices 7/8 render gray on every screen. The UI green/gold live at *different*
indices per palette (OPENMENU green ≈ 254, master green = 68; OPENMENU gold =
84, master gold = 148). **Fix pattern:** resolve UI colours to the nearest
entry in the *live* palette at draw time (see `mr_color_for` in
`src/ui/menu_runner.c`). RGB targets sampled from the live game:

| role            | RGB        |
|-----------------|------------|
| menu/option/bar text (green) | `#528A31` |
| highlight / title word (gold) | `#E3AA28` |
| selected-row dark bar | ~`#382010` |
| panel/menubar background | WOODTILE.SS planks |

## Per-screen status vs ground truth

### Title / main menu — DONE (matches)
`src/ui/menu_runner.c`. Wood panel (WOODTILE.SS tiled, remap-blit), green
options, gold `{COLONIZATION}`, dark selection bar, `%STRING0=3.0` /
`%STRING1=7-Feb-95` (both byte-cited from VICEROY.EXE). Verified against
`refs/ref_title.png`.

### Nation / difficulty pickers — verify
PIK-based (`NATIONS.PIK` flags, `DIFFICUL.PIK` portraits); do not go through
`menu_runner`. Roughly correct; confirm flag/portrait highlight box position
and the left-side label text against `refs/ref_nation.png` /
`refs/ref_difficulty.png`.

### Map — CHROME MISSING (terrain itself OK)
`draw_map()` in `src/main_modern.c`. Terrain tiles render correctly (real
TERRAIN.SS sprites via the O514/O513 chain). Missing/wrong:
1. **Top menu bar** — never drawn. Real = a wood strip across the top (y≈0–8)
   with green labels `GAME VIEW ORDERS REPORTS TRADE` (left) and `COLONIZOPEDIA`
   (right). Labels come from `MENU.TXT` column titles (`~GAME`, `~VIEW`, …).
   `build_menubar` (func_072090, `src/ui/report_screen.c`) builds the menu
   *data*, but the page-02 render primitives (`menubar_create`/`menu_add`/
   `menubar_finalize`) were never ported — a modern bar-painter is needed.
   Approx label left-x (320-space): GAME 11, VIEW 45, ORDERS 77, REPORTS 109,
   TRADE 146, COLONIZOPEDIA 261. Text green `#528A31` on WOODTILE.
2. **Right sidebar** — background must be WOOD (currently black). Real layout
   top→bottom: minimap (orange border) → "Spring YYYY / Gold: N% Tax: N%" →
   active-unit panel (icon + "Moves" / "Locat: (x, y)" / unit name / orders /
   terrain) → carried-unit rows. Mine shows a placeholder column of `0`s where
   the unit panel belongs.

### Colony — NEEDS REWRITE (largest remaining task)
Real screen (`refs/ref_colony_interior.png`): a sandy building plot filling the
top ~65% with scattered structures (log cabins, thatched houses, a church with
steeple, workshops) and colonists working; the 3×3 work-tiles grid top-right;
header "Curacao, Autumn, 1653, Gold: …" in green. Bottom ~35%: population/SoL
panel + portraits (left), "No Ships In Port"/dock (mid), cargo + warehouse goods
strip (right), red "Exit E" button (corner).

**Asset roles (confirmed via asset_inspect):**
- `COLONY.PIK` = **320×72**, the BOTTOM-BAR background only (not full screen;
  the current code wrongly uses it as the whole backdrop). No palette → master.
- `BUILDING.SS` = **48 frames** (~73×18 each) = the building sprites.

**Code state — `src/ui/colony_screen.c` is a skeleton with empty blits:**
The composer `colony_screen_render` and sub-painters exist, but every actual
sprite blit is a no-op `;`:
- `colony_paint_buildings` (line ~322/324): the per-slot building draw (and
  empty-lot draw) are stubs. Slot positions: DGROUP `0x266 + i*4` (x,y, 15
  slots). Per-slot TYPE `0x8D62+i`, LEVEL `0x8E82+i` (0xFF = empty). The
  `(type,level) → BUILDING.SS frame` mapping (orig leaf at near-call `0x7E33`)
  is not ported.
- `colony_paint_flag` (~360), `colony_paint_minimap` tile-walk (~396),
  `colony_paint_sol_panel`, `colony_paint_stockpile` — sprite/icon blits stubbed.
- The building-DATA pipeline that fills `0x8D62`/`0x8E82` from the colony record
  lives in `src/overlay/overlay_024342_027B62.c` (func_025D4x: clears slots to
  0xFF, flattens the 5×N config into `0x8D62`, records produced goods into
  `0x8E82`) — partially ported; verify it runs for a loaded colony.

**Concrete data gathered (so implementation needs no re-investigation):**

*Building slot positions* — read from the live DGROUP image (VICEROY.EXE file
0x1D9A0+0x266), 15 slots, `(x, y)`; the painter adds +8 to y:
```
 0:(56,5)  1:(145,7)  2:(173,10) 3:(8,33)  4:(37,37)
 5:(67,46) 6:(96,45)  7:(6,6)    8:(128,45) 9:(10,68)
10:(15,94) 11:(87,3) 12:(66,79) 13:(123,98) 14:(123,47)
```

*Sub-panel layout rects* (from the colony_screen.c banner, byte-verified):
- top building plot: the 15 slots above, over a sandy backdrop (top band fill
  `0,7,199` then frame `0,8,199,7`)
- 3×3 work-tiles grid: upper-right `(224,32,72,72)`
- surrounding minimap: `(121,130,84,48)`; SoL/cargo/ship panel: `(211,130,91,48)`
- nation flag: `(303,132,17,45)`, flag sprite id 68
- stockpile strip: bottom `y=179..199` (16 goods)
- `COLONY.PIK` (320×72) is the bottom-bar backdrop (draw at y≈128, not y=0)

*Building system* (docs/COLONY_SYSTEM.md): ~16 building categories, most with 3
tiers (Stockade/Fort/Fortress, Church/Cathedral, Warehouse, Carpenter→Lumber
Mill, …) + standalone Town Hall (always present). `BUILDING.SS` = 48 frames
covering categories×tiers.

**The one remaining blocker:** the `(building_type, level) → BUILDING.SS frame`
map (orig leaf at near-call `0x7E33`, "national-variant select on player
nation"; recol twin `func_018230`, switch on level 0x0F/0x11/0x13/0x14/0x30/0x2F).
Not in this repo. Derive it from the recol reference OR empirically by matching
`BUILDING.SS` frames to the slot positions in `refs/ref_colony_interior.png`
(Curacao). Then: implement the per-slot blit in `colony_paint_buildings`, draw
the sandy backdrop, place `COLONY.PIK` at the bottom, and **seed a building set
into the `main_modern.c` test colony** (it currently seeds only x/y/owner/pop/
name) to verify. Do NOT ship an approximate frame map — per the accuracy bar,
the buildings must be the correct sprites.

## Repo / safety constraints (persistent)
VICEROY.EXE is never committed and never embedded in the modern build;
`game_data/`, `col.zip`, and game captures stay out of git. Develop on
`claude/beautiful-maxwell-EUu9I`.
