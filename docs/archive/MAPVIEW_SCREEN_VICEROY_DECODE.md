# MAP VIEW SCREEN — VICEROY.EXE decode (code-anchored)

> Source of truth = **VICEROY.EXE disassembly** (`raw/COLONIZE/VICEROY.EXE`, capstone
> 16-bit). Companion to `docs/COLONY_SCREEN_VICEROY_DECODE.md` /
> `docs/EUROPE_SCREEN_VICEROY_DECODE.md`. Built 2026-06-24. Tiers: **B** byte-verified
> (a cited file offset / push-arg) / **A** anchor / **R** reconstructed (recon doc, cross-check
> only) / **TBD** (blocker named). Recon docs (`spec/ui/map_view.md`, `spec/ui/menus.md`,
> `docs/UI_FIDELITY.md`, `*_DECODED.md`) are used as cross-check **only**; where they
> disagree with the bytes below, the bytes win (per CLAUDE.md prime directive).

## 0. Anchors
- DGROUP file base = `0x1D9A0`; BSS starts `DS:0x2CC6` (see colony decode §0). A `DS:`
  offset **< 0x2CC6** is STATIC, readable at file `0x1D9A0+off`; **≥ 0x2CC6** is runtime/BSS.
- **Map-view entry = `enter_screen_view(bx=0xD)`** — `@0x076871`: `mov bx,0xd; lcall
  0x181F:0x772` (`@0x076874`). `0x181F:0x772` is the **generic screen-view runner** (the
  same verb that drives Europe `enter_screen_view(0x2B)`, `EUROPE…` §11). It owns the modal
  event loop and calls the per-screen composer registered for screen id 0xD. **B.**
- **Map composer (chrome) = `func_067700` @0x067700** (reached `0x1A1F:0x8a4`-adjacent; it
  is the function that wraps the minimap call `@0x0677B5` and the viewport-render chain). It
  paints: outer frame, the 5 viewport/scene sub-painters, the units-on-map overlay, the
  optional nation-name caption (zoom 3), then the minimap. **B (see §3).**
- **Viewport geometry setup = `func_06787C` @0x06787C** (zoom `[0x184]`): `SPAN_W[0x8544] =
  0xF<<zoom` (`@0x067887/0x067889`), `SPAN_H[0x8546] = 0xC<<zoom` (`@0x06788F/0x067891`),
  `TILE_PX[0x5AD4]=[0x8326] = 0x10>>zoom` (`@0x0678B1/0x0678B3/0x0678B6`), scroll-centre
  half-spans `[0x8328]=SPAN_W/2` (`@0x0678BC/0x0678C4`), `[0x832E]=SPAN_H/2`
  (`@0x0678CB/0x0678D3`). zoom 0..3 ⇒ 15×12@16px / 30×24@8px / 60×48@4px / 120×96@2px. **B.**

---

## 1. ⚠ CORRECTION — `func_06083A` is the TRADE-ROUTE EDITOR title, NOT the map menu bar

> **The recon docs are wrong here, and the EXE proves it.** `spec/ui/menus.md` §6.2 / §15,
> `docs/UI_FIDELITY.md` §(B), and the brief all label `func_06083A` as
> `draw_map_view_chrome` — "the in-game top menu bar." That attribution is **REFUTED by
> bytes.**

`func_06083A` reads `[0x9E14]` and divides it by **`0x4A` (74)**, then `inc`:
```
06087D  mov   ax, word ptr [0x9e14]
0x067883  mov   cx, 0x4a          ; (file 0x060883)
0x067887  idiv  cx                ; (file 0x060887)
0x067889  inc   ax                ; → "route number" = base/74 + 1
06088A  push  ax
060890  lcall 0x181F:0x182        ; append that number to the title buffer
```
`0x4A` is the **trade-route record stride** and `[0x9E14:0x9E16]` is the **active-route base
far-pointer** (`spec/systems/trade_routes.md` §2, BYTE_VERIFIED). The writer is the route
selector `func_05FE60`:
```
05FE69  imul  ax, ax, 0x4a        ; route_id * 74
05FE6F  mov   word ptr [0x9e14], ax   ; [0x9E14] = route base
```
So `func_06083A` builds **"Route N: «name»"** for the trade-route editor (it is reached
**only** via the trade-route segment's far-ptr dispatch — `tools/find_callers.py 0x6083A`:
one thunk `0x1A1F:0x770`, data-ref `0x61437`, inside the `0x05FE60` editor page). It is **not**
on the `enter_screen_view(0xD)` map path at all.

**What is real in `func_06083A` (and what the recon authors mis-saw):** it *does* draw one
centred line — `@0x060898` `push 0xF`(color white) `push 5`(y) `push 0x140`(box-w=320)
`push 0`(x) → `0x181F:0x100` (centre-text-in-box) `@0x0608A6` — plus info lines at
`y=0x19=25` (`@0x0608D0` / `@0x060932` via `0x181F:0x13C` left-draw) and a row of value cells.
This y=5/w=320/color-0x0F/`0x100` pattern is what the recon docs latched onto and mislabeled
"menu bar." **It is the trade-route editor's title + stop list, not the map HUD.** **B (refutation).**

> **Net:** there is **no** byte-pinned "map menu bar painter" named `func_06083A`. The real
> map top bar is the shared menu-bar widget (§2). The map-view doc `spec/ui/map_view.md` §6.3's
> menu-bar-line claim should be retracted to point at §2 here.

### 1a. `func_06083A` decoded fields (for the trade-route-editor doc, not map view)
| @site | call | source | meaning |
|------|------|--------|---------|
| 0x060851 | `0x181F:0x484` | nation quartet `[0x2DA8..0x2DAE]` | composited title prefix |
| 0x06085A | `0x181F:0x22` | string id `[0x93DE]` | title template fetch (→ `0xD1D:0x117E` sprintf) |
| 0x060890 | `0x181F:0x182` | **`[0x9E14]/0x4A + 1`** | **route number** appended |
| 0x0608A6 | `0x181F:0x100` | buffer | **centred title line, y=5, color 0x0F, box 0..320** |
| 0x0608BA | `0x181F:0x16E` | string id `[0x93E0]` | strcat label |
| 0x0608DE | `0x181F:0x13C` | buffer | left-draw at **x=0x0A=10, y=0x19=25, color 0x0F** |
| 0x060932 | `0x181F:0x13C` | label `[bx-0x6C22]` (route-type: sea/land via `[0x9E14]+0x20`) | left-draw, y=25 |
| 0x0609AA/0x0609C7/0x0609E5 | `0x181F:0x22`→`0x13C` | string ids `[0x93E8]/[0x93EA]/[0x93EC]` at x=`[bp-0x56]`/`0x7D=125`/`0xD0=208`, color 0x0F | three column captions |
| 0x060A22/0x060A4F/0x060A6E | `0x191F:0x8bc`/`0x191F:0x8b2` | stop-cell sprites | stop-list cells (pitch 0x14=20) |

(Font latched FONTTINY via `[0x89E]`, read `@0x0608FE`/`@0x06097D` — see §4. These belong in
`spec/systems/trade_routes.md`, recorded here only to close out the mis-attribution.)

---

## 2. TOP MENU BAR — shared menu widget (`func_072090` build / `func_06E3D0` run)

The map view's top menu strip (GAME / VIEW / ORDERS / REPORTS / TRADE / CHEAT /
COLONIZOPEDIA) is the **shared in-game menu-bar widget**, NOT a map-page-private painter:
- **Build** `func_072090 @0x072090`: opens the `game menu` data section
  (`push "game"/"menu"` @0x0720BE, reader `0x191F:0x928` @0x0720C4) and registers each
  command row via `0x1A1F:0x31A` / `0x1A1F:0x33E` (`@0x0720E4 / 0x0720FD`, → command-record
  builders). The command ids are **sequential `game menu` section indices** (not coords). **B.**
- **Run / hit-test / dropdown** `func_06E3D0 @0x06E3D0` (via `0x191F:0x16A`), sized by the
  shared dialog geometry engine `func_06D316`/`func_06C520`; @-directive parse `func_06F0F4`.
  Dropdown rows = **FONTINTR** (dialog ctx). **B** (mechanism; cross-ref `spec/ui/menus.md` §6.3).
- **Item text** = `data_extracted/text/MENU_sections.json` keys `@GAME @VIEW @ORDERS @REPORTS
  @TRADE @CUP(CHEAT) @PEDIA`. **B** (keys verified present).

**Bar geometry — the exact strip-fill / per-label x is TBD (B-blocker).** `func_072090` does
not itself emit the bar pixels with a static literal; the bar strip + per-label x come from the
menu widget's glyph-grid layout (FONTTINY title widths), which is **overlay-resident** and not
a static immediate. The map viewport begins at **y=8** (`func_06787C`, §0), so the bar occupies
the top 8px (y=0..7) — that **height is B** (it is the viewport-origin complement); the per-label
x's (recon: GAME@4 VIEW@44 ORDERS@84 REPORTS@144 TRADE@200 CHEAT@244) are **R** (from the
`_VICEROY_MODERN`/`hud.c` recon, absent from the EXE — `UI_FIDELITY.md` §(B), `map_view.md` §6.4).

---

## 3. RIGHT SIDEBAR — minimap + viewport sub-painters + map-unit overlay (`func_067700`)

The map composer `func_067700` paints (in order):

| step | @site | call | role | tier |
|------|-------|------|------|------|
| frame | 0x067727 | `0x181F:0xCE` | hollow rect, x=0, y=`[0x8552]+8`, w=0xFFFF, h=7, color `[0x8550]` (nation quartet `[0x2DA8..]`) | B |
| A | 0x06773B | `0x191F:0x2a4` → **func_068898** | viewport scroll/scene-buffer setup (`[0x839E..0x83A4]`) | B |
| B | 0x067740 | `0x191F:0x888` → **func_06716A** | viewport tile render (pushes `SPAN_H[0x8546]/SPAN_W[0x8544]/[0x832E]/[0x8328]`) | B |
| C | 0x067745 | `0x191F:0x896` → **func_0672C8** | viewport tile render variant (same span args) | B |
| D | 0x06774A | `0x191F:0x296` → **func_066F32** | scene-buffer composite (`[0x839E..0x83A4]` + nation quartet, `0x181F:0x33A`) | B |
| E | 0x06774F | `0x1A1F:0x93e` → **func_06760E** | viewport render (span args) | B |
| name | 0x06779E | `0x181F:0x100` | **zoom-3 only** (`cmp [0x184],3` @0x067754): nation name `[0x5396]*0x34+0x5426` (`0xD1D:0x7E4` sprintf @0x06776C), centred at x derived from `[0x832C]*[0x8326]`, y=`[0x8550]`, color 0x0F | B |
| minimap | 0x0677B5 | `0x1A1F:0x8a4` → **func_066CD6** | minimap panel (§3a) | B |
| (post) | 0x0677C3 | `0x1A1F:0x8ea` → **func_067024** | sidebar sprite-strip blit `0x181F:0xE2` at x=`[0x8550]`, y=`[0x8552]`, when `[bp+6]≠0` | B |

### 3a. Minimap panel — `func_066CD6` — RECTS BYTE-VERIFIED
```
066CF8  mov ax,0xf1 (241)   ; x
066CFB  mov dx,8            ; y
066CFE  mov bx,0x4f (79)    ; w           push 0x29(41)=h  → lcall 0x181F:0xBA (blit pre-rendered bitmap)
```
- **Minimap panel rect = (241, 8, 79, 41)** `[V @0x066CF8]` (matches `INGAME_MAP_RENDER_TRACE.md`
  §5). The bitmap is pre-rendered (`0x181F:0xBA`); when a clip rect is active (`[0x82C]≠0`,
  @0x066CDD) it instead composites via `0x181F:0xC4` with the clip far-ptr `[0x82C]+0..6`.
- **Viewport-window rect overlay** `@0x066D4B`: `0x181F:0xCE` (hollow rect) with `push 0x30`(48)
  `push 6`, `ax=0xFB` color, `dx=8`, `bx=0x134`(308) — the scroll-window indicator drawn over
  the minimap from scroll `[0x9CCA]/[0x9CCC]` (`INGAME_MAP_RENDER_TRACE.md` §5.minimap). **B.**

### 3b. Map-unit overlay — `func_067024` family (`@0x06703C`/`0x067082`/`0x06716A`)
The units painted **on the map viewport** (not the sidebar text) loop `[0x539A]` entries from
record base `0x54EC` (`@0x0670CF`), stride **0x12=18** (`@0x067156` `add [bp-6],0x12`), clipping
each to the viewport span (`@0x0670E6..0x0670FC`) and blitting via `0x181F:0x2B2` (the shared
per-unit panel verb) at viewport pixel `(([0x832A]-[0x8328]+tx)*TILE_PX, ([0x832C]-[0x832E]+ty)*…)`
`@0x067126..0x067151`. **B.**

### 3c. ⚠ Sidebar TEXT (season / gold / tax / selected-unit panel) — NO byte-pinnable draw site in the map page — **TBD**
**Exhaustively checked and genuinely unresolvable from static map-page bytes:**
- A capstone sweep of the **entire map page region `0x66000..0x77000`** finds **zero** reads of
  the treasury ptr `[0x84FC]`, the gold mirror `[0x9CB0]`, or the season global `[0x538C]`. (All
  `[0x84FC]` reads live in the colony/Europe/turn pages `0x2D…0x36xxx`; all `[0x9CB0]` writes are
  popup-substitution buffers `@0x2B80E/0x34E51/0x48C13`; no read-as-draw-arg site exists.)
- ⇒ The map-view season/year/gold/tax sidebar lines and the selected-unit panel are painted by
  the **shared screen-view-runner HUD overlay** (invoked through the `0x181F:0x772` runner for
  screen 0xD), whose layout constants are **overlay-resident and not statically resolvable**.
  This matches `map_view.md` §6.3's honest finding: the HUD thunks `0x191F`/`0x1A1F:0x6a/0x74/0x88`
  do **not** parse cleanly from the rtlink trailer (only `0x1A1F:0x7e`→file 0x3E162 resolves, and
  that is a treasury/tax **turn** routine, not a sidebar painter).
- **Therefore the per-line x/y/color/string for season/gold/tax/unit-panel are TBD (B-blocker:
  overlay-resident HUD painter, no static draw site in the EXE image).** **Do NOT** copy the
  `map_view.md` §6.3 R-table (Season@244,58 / Gold@244,66 / Tax@290,66 / …) as verified — it is a
  single eyeballed frame (frame 1310262984), explicitly **R**, internally imperfect, usable only
  as an approximate implementer's layout.

> **On "where is gold shown" (the long-standing question):** byte-pinned answer is **negative for
> the map page** — the map-view sidebar gold is **not** drawn by any instruction in `0x66000..0x77000`.
> The treasury *value* is `PowerRecord+0x2A` via `[0x84FC]` (`DATA_MODEL.md`, BYTE_VERIFIED); its
> map-sidebar *blit* is overlay HUD chrome, **TBD** with the blocker named. (The colony/Europe gold
> headers are likewise menu-chrome TBD — `COLONY…` §10, `EUROPE…` §6.)

---

## 4. VIEWPORT TILE-RENDER CHAIN (re-confirmed)

Per CLAUDE.md hard rule #7 and `docs/INGAME_MAP_RENDER_TRACE.md` (authoritative, user ruling
2026-06-22), re-confirmed against bytes:
- Each tile: `func_O514 → func_O513 → func_O512`. `func_O513` (`@0x681A8`/`0x681D5`) reads the
  three planes (terrain `[0xA598]`, feature `[0xA594]`, fog `[0xA59C]`) and decodes terrain via
  `lcall 0x181F:0x6aa` → `[0xA8A2]`.
- `get_terrain_id_from_raw` (`func_006204` @0x006204): `and al,0x1f` (`@0x00620A`) then auto-forest
  for ids 8..23 (`and ax,7; or al,8` `@0x006225`) — confirms hard rule #3 byte-for-byte.
- `func_O512` (`@0x067F50`/`0x68026`) 4-neighbour blend loop (`cmp [bp-4],4`); world coords
  `[0xA5A0]/[0xA5A2]`; on-screen test `lcall 0x181F:0x302`.
- Blit model (`INGAME_MAP_RENDER_TRACE.md` §3, all `[V]`): per-tile composite buffer near-ptr
  **`0x839E`**; `emit_ground_sprite` (`0x181F:0x25E`→file 0x3460, unconditional `rep movsb`),
  `emit_terrain_sprite` (`0x181F:0x268`→file 0x34C4, **0-key backfill**), `draw_subcell`
  (`0x181F:0x254`→file 0xE76A, RLE, transparent = **0xFD** only). Sprite→TERRAIN frame via
  `terrain_cell_transform` (`func_03436`). **B** (re-cited, not re-derived).
- Sheet roles per CLAUDE.md #5: **TERRAIN.SS = base ground**, composited under **PHYS0.SS**
  overlays. Coast = O512 land-terrain dither + coast sub-tiles (`0x97+pattern` or `0x6D+…` quads)
  + `emit_terrain(water)` backfill (`INGAME_MAP_RENDER_TRACE.md` §6.1). **B.**
- The viewport sub-painters B/C/E (`func_06716A`/`func_0672C8`/`func_06760E`, §3) push
  `SPAN_W/SPAN_H/[0x8328]/[0x832E]` and drive this per-tile chain across the 15×12(zoom-scaled)
  grid. **B.**

---

## 5. FONTS + COLORS per element (cite `fonts_and_colors.md`, `[0x89E]` latch confirmed)

- **Font = FONTTINY**, the boot-default latch **`[0x89E]/[0x8A0]`** (`fonts_and_colors.md` §1).
  Latch reads confirmed at the map/trade-route draw sites: `les bx,[0x89E]; mov al,es:[bx]`
  `@0x0608FE` and `@0x06097D` (glyph-height fetch into the y-advance), and `@0x067781` (the
  zoom-3 nation-name line). Font is a **screen-level latch, not a per-draw select** (§1 caveat,
  tier A for the per-element font handle). **B (latch site) / A (role).**
- **Colors (palette-index push-args, B):**
  | element | color idx | RGB | site |
  |---------|-----------|-----|------|
  | minimap viewport-window rect | `0xFB` | (per WOODPANL/gameplay pal) | `@0x066D4F` (`ax=0xFB`) |
  | minimap panel frame | `0x0F` white | (255,255,255) | `INGAME_MAP_RENDER_TRACE.md` §5 (0xFB/0x0F) |
  | composer frame rect (`func_067700`) | `[0x8550]` (nation) | runtime | `@0x067723` |
  | zoom-3 nation name | `0x0F` white | (255,255,255) | `@0x067774` |
  | menu-bar titles | green `ui_color_for(0x52,0x8A,0x31)`→(82,138,49) | green | `fonts_and_colors.md` §2 (menu framework) |
  | dropdown rows | per-row palette byte; sel-bar RGB(56,32,16); gold RGB(227,170,40) | — | menu framework 48507/48508 |
  - Sidebar season/gold/tax text color = **TBD** (no static draw site, §3c) — recon `map_view.md`
    says white `0x0F`, tier **R**.

---

## 6. Status / remaining TBD

**Byte-verified (B):**
- Entry `enter_screen_view(0xD)` @0x076871 → generic runner `0x181F:0x772`.
- Viewport geometry `func_06787C`: SPAN_W `[0x8544]`, SPAN_H `[0x8546]`, TILE_PX `[0x5AD4]/[0x8326]`,
  scroll half-spans `[0x8328]/[0x832E]`, zoom `[0x184]` — all literal sites cited (§0).
- Map composer `func_067700` + its 5 viewport/scene sub-painters (`func_068898/06716A/0672C8/
  066F32/06760E`) all resolved via `follow_thunk` (§3).
- **Minimap panel rect (241,8,79,41)** `[V @0x066CF8]`; viewport-window overlay `@0x066D4B`.
- Map-unit overlay loop (`[0x539A]`, base 0x54EC, stride 0x12, blit `0x181F:0x2B2`) (§3b).
- Tile-render chain (`func_O514/O513/O512`, `func_006204` decoder, blit model) — re-cited (§4).
- FONTTINY latch sites `[0x89E]` @0x0608FE/0x06097D/0x067781 (§5).
- **`func_06083A` REFUTED as the map menu bar** — it is the trade-route editor title
  (`[0x9E14]/0x4A+1` @0x060883/0x060887, writer `func_05FE60` @0x05FE6F) (§1).

**TBD (blocker named):**
1. **Top menu-bar strip pixels + per-label x** — overlay-resident menu-widget glyph-grid layout;
   no static immediate in `func_072090`. Bar **height 8px is B** (viewport y=8 complement); per-label
   x's are **R** (recon, absent from EXE). *Blocker:* disassemble the menu-bar layout walk inside
   the `func_06E3D0`/widget overlay, or pixel-measure. (§2)
2. **Sidebar season / year / gold / tax text — x/y/color/string** — **no draw site in the map page
   `0x66000..0x77000`** (verified: zero `[0x84FC]`/`[0x9CB0]`/`[0x538C]` reads there). Painted by the
   shared screen-view HUD overlay. *Blocker:* the HUD thunks (`0x191F/0x1A1F:0x6a/0x74/0x88`) do not
   parse from the rtlink trailer; only `0x1A1F:0x7e`→0x3E162 resolves and it is a turn routine, not a
   painter. Needs a runtime trace of the screen-0xD HUD paint or the overlay-page decode. (§3c)
3. **Selected-unit sidebar panel (sprite + Moves/Locat/type/skill/orders)** — same overlay HUD
   blocker as #2; the only available layout is `map_view.md` §6.3's single-frame **R** table.
4. **Gold value→blit on the map sidebar** — value `PowerRecord+0x2A` via `[0x84FC]` is B
   (`DATA_MODEL.md`), but the **blit is overlay HUD chrome (TBD)** — there is no map-page draw site.
5. **Viewport-window indicator scroll inputs** — `[0x9CCA]/[0x9CCC]` scroll, `[0x8804]/[0x8806]`
   bounds feed `@0x066D4B`; the values are runtime (BSS), site is B but contents TBD.
