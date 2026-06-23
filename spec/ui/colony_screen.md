# Colony Screen

> **Layer 2 — UI Specification.** Per `/METHODOLOGY.md`. Tiers: **B** = byte-cited
> (a `func_XXXXXX @0xNNNNN` file offset, a verified `*.TXT` key, or a recorded ruling);
> **A** = overlay/pixel-measured geometry (no byte literal); **R** = single-frame /
> low-trust approximation or a decompiler stub the EXE keys differently; **TBD** = unknown.

**Overall confidence:** the **composer draw ORDER and every panel-paint sub-renderer are
byte-transcribed** from the colony composer `func_028592 @0x028592` (tier **B** — the 12 ordered
calls and each sub-renderer's background-fill rect were re-read PUSH-for-PUSH); the active-colony
pointer, building-slot table, stockpile bar, and flag/minimap/SoL panel rects are
**raw-EXE-verified** (**B**). The remaining soft spots — the **title paint origin**, the
**colonist-row per-unit pitch**, the **work-grid vs 6-slot surrounding scene** discrepancy, and the
**SoL/cargo/msg panel's mode text source** — are honestly **R/TBD**, each called out in §6 with the
exact reason. · **Canonical primary:** `viceroy_source/docs/drawlist/EUROPE_COLONY.md` PART 2
(composer + sub-renderers), `viceroy_source/docs/SCREEN_LAYOUTS.md` §3, `docs/COLONY_RENDER_CHAIN.md`
(entry chain + data globals), `raw/COLONIZE/VICEROY.EXE`.

> **Provenance note (2026-06-22):** earlier revisions cited `docs/RENDERER_GEOMETRY.md` and
> `ghidra_export/VICEROY_decompiled.named.c` line numbers as primary. Those geometry docs were
> removed in cleanup and are **not** cited here; the byte-true source for every rect below is the
> drawlist's `@0xNNNNN` PUSH transcription and SCREEN_LAYOUTS' `[V]` table. Where a prior claim came
> only from the low-trust C reconstruction (e.g. the "3×3 work grid" cell formula), it is now tagged
> **R** and reconciled against the drawlist in §6.

## 1. Purpose
The colony management screen (Plymouth/New Amsterdam in the session snaps): a live terrain scene with
the colony's surrounding tiles and colonists-on-tiles, table-positioned buildings, a colonist plaza
row, a field-production panel, a nation flag, a surrounding-tile minimap, a Sons-of-Liberty/cargo/
message panel, and a bottom 16-commodity warehouse strip. **A/B**

**Entry.** Clicking an own colony runs `func_L187 (process_unit_move_to_tile) @0x07D3E →
set_active_colony @0x82DC → lcall 0x191f:0x1de (colony-screen open)`; the screen-id is **0x2C** and
the backdrop is **COLONY.PIK** (key 0x0BA0, loaded by the entry stub `@0x025EC8` before
`mov bx,0x2C; lcall 0x181f:0x772` = `enter_screen_view`). **B** (`docs/COLONY_RENDER_CHAIN.md` §2,
`SCREEN_LAYOUTS.md` §3).

**Active colony.** `[0x8542]` is a **near pointer to the active `ColonyRecord`** (not a nation
index): `set_active_colony` does `imul bx,idx,0xCA; add bx,0x5D46; mov [0x8542],bx` `@0x8302..0x830B`.
`+0`=cx, `+1`=cy. **B** (`docs/COLONY_RENDER_CHAIN.md` §1/§2).

## 2. State & data layout
| Field | Meaning | Tier | Evidence |
|-------|---------|------|----------|
| `[0x8542]` | active `ColonyRecord` near ptr; `+0`=cx, `+1`=cy | B | `set_active_colony @0x830B`; read by `func_026381` (`[0x8542]:[bx+0]`/`+1`) |
| `ColonyRecord` base `DGROUP:0x5D46`, stride `0xCA` | colony table | B | `@0x8307` (`add bx,0x5D46` after `imul *0xCA`) |
| `[0x539E]` (u16) | num_colonies, current player, max 48 (0x30) | B | `cmp [0x539e],0x30 @0x2EB82` |
| `[0x848]+0x266` (word, stride 4, ×15) | building screen-pos: x@`+0`, y@`+2`(+8) | B | `func_02701C @0x027087`/`@0x02708B` |
| `[bx−0x729E]` (byte ×15) | building-type per slot | B | `func_02701C @0x027095` |
| `[bx−0x717E]` (byte ×15, signed) | building present/level per slot; `<0` ⇒ slot empty | B | `func_02701C @0x02709D` (skip if `<0`) |
| `colony+0x1F` + `[0x8D72]` | colonist plaza-row count | B | `func_0270D0 @0x0270E6` |
| `colony+0x9A..+0xB9` (16×u16) | warehouse stockpile per good | B | `DATA_MODEL.md` / stockpile bar `func_0281D6` |
| `[0x337]` (byte) | SoL/cargo/msg panel mode (3-way branch) **and** flag-frame nation byte | B | `func_02814C @0x028166`; `func_02853C @0x028558` (also `[0x339]`) |
| `colony+0xC2`, `+0xC6` | SoL numerator/denominator (wealth/goal) | R | `COLONY_SYSTEM.md` (RECONSTRUCTED, not byte-verified — see §6) |
| `colony+0x1A` | owner power index (`<4` = European) | B | `@0x830F` (`cmp [bx+0x1A],al`) |
| `[0xA897]` (byte) | "human visiting colony" flag | B | `set_active_colony @0x8338` |

## 3. Draw chain — composer `func_028592 @0x028592` (12 steps, byte-read)
Native 320×200 (mode 13h). The composer head is transcribed call-for-call (`@0x028592..0x02860D`).
Paint-order subtlety: the **terrain scene + scene-units (step 3) are drawn FIRST**, then the
**full-screen region fill (step 4)** is composited over it, then title/panels/buildings on top.
The fill (`func_02633E`, a flat patterned fill via `0x181F:0x444`) is a region paint, **not** a
destructive clear — the scene survives. **B** (drawlist §2.0). There are **no HI/LO bevel edges**
anywhere in the colony composer; every panel is a flat fill with at most a frame via `0x181F:0xE2`.
**Correction (2026-06-23):** `0x181F:0xE2` is byte-verified as `func_00DB3A`, a **clipped sprite
blit** (sheet `[0x2DA8]`), **not** a drawn 1-px line/rectangle (`UI_PRIMITIVES.md` §0x0E2). So the
"1-px frame", "panel outlines", and "screen-bottom rule" labels below all denote a **composited
frame/edge SPRITE**, not a vector line. The byte-verified primitive supersedes the drawlist's
"1px frame" wording. **B** (primitive) / drawlist §0 (geometry).

| # | Call site | Sub-renderer | Role | Tier |
|---|-----------|--------------|------|------|
| 1 | `@0x028595` `lcall 0x181F:0xC22` | — | scene context / clear setup | B |
| 2 | `@0x02859B` `call 0x2CA5A` | `func_025C32` | colonist sort / stage A | B |
| 3 | `@0x02859F` `call 0x2CACD` | `func_026374` | **TERRAIN scene + scene units** (§3.8) | B |
| 4 | `@0x0285A2` `call 0x2CAC3` | `func_02633E` | **full-screen region FILL (0,0,320,200)** | B |
| 5 | `@0x0285B5` `call 0x2CAE6` | `func_0268CE` | **title text** (§3.1) | B |
| 6 | `@0x0285BD` `call 0x2C9A1` | `func_0264A8` | **field-production panel** (§3.2) | B |
| 7 | `@0x0285C5` `call 0x2C9DD` | `func_0270D0` | **colonist plaza row** (§3.3) | B |
| 8 | `@0x0285CD` `call 0x2CA19` → `0x191F:0x654` | `func_0281D6` | **stockpile bar** (§3.9) | B |
| 9 | `@0x0285D7` `call 0x2C9E7` | `func_02853C` | **flag panel** (§3.4) | B |
| 10 | `@0x0285DF` `call 0x2C9FB` | `func_027DB2` | **surrounding-tile minimap** (§3.5) | B |
| 11 | `@0x0285E7` `call 0x2C983` | `func_02814C` | **SoL / cargo / msg panel** (§3.6) | B |
| 12 | `@0x0285EF` `call 0x2C97E` | `func_02701C` | **buildings loop, 15 slots** (§3.7) | B |
| — | `@0x028607` `lcall 0x181F:0xE2` (if `[bp+6]≠0`) | — | screen-bottom rule (0,200,320) | B |

> **Stockpile-bar note (resolved 2026-06-23).** The 16-cell warehouse strip `func_0281D6`
> (the per-page **twin** of Europe's market bar `func_0310B4`) IS composer **step 8**:
> `call 0x2CA19` → `ljmp 0x191F:0x654` → file `0x0281D6`
> (`tools/follow_thunk.py 0x191f 0x654`; body fills `(0,179,320,21)` then loops 16 cells
> at pitch 0x13). All 12 head calls are now resolved sub-renderers (`docs/COLONY_SCREEN_VICEROY_DECODE.md` §2).

### 3.1 Title text — `func_0268CE @0x0268CE`  (the colony screen's only "menu bar above")
Assembles the title/status line into `[bp-0x50]` with the C string library (helper bodies
decoded): `0x181F:0x182` (`func_0029DE`, append **decimal number**), `0x181F:0x16E`
(`func_002992`, append a **string fetched from a table** via `0:0x62`), `0x181F:0x1A0`
(`func_002A06`, zero-padded number), `0x181F:0x178` (`func_0028B0`, **strlen / util — not a
paint**) `@0x026906..0x026A61` — guarded by state checks (`[0xB98]==0`, `[0x828]==0`,
controller gate at `0x268D7`); owner descriptor/colour merged from `colony+0x1A` via
`0x181F:0xB1E` (`func_008862`). The final **paint is `0x181F:0xB0` (`func_00275C`, the
rich-text painter) at `@0x026AA6`** with `mode=[bp+6]=0` (composer pushes `0` at `@0x0285B2`).
Paint origin is the per-screen text-box globals `[0x2CC6/0x2CC8/0x2CCA/0x2CCC]` from the
`0x181F:0xC22` context init, so x/y are **runtime state** — centred near `y≈5` is **R**
(recol clear `(0,0,320,7)`). The byte-confirmed tail of this banner is the **season**
(`[0x538C]`) + **year** (`[0x538A]`) — i.e. colony name + date. This is the *title*,
separate from the **top menu bar** (command table `@0x02BDEA`, registration `@0x02BE00`;
`docs/COLONY_SCREEN_VICEROY_DECODE.md` §10), which carries the dropdown commands and the
**gold** readout (treasury `PowerRecord+0x2A`).
**The call sequence + which fields feed the string are B; the literal rendered words are
TBD/R** — the `0x16E`/`0x22` appends read from the runtime string heap (`[0x2D42:0x2D44]`,
per-colony word tables at `-0x6840`/`-0x6800`), so the exact text needs a string-section
dump or a runtime trace (do not invent it). Full breakdown:
`docs/COLONY_SCREEN_VICEROY_DECODE.md` §9.

### 3.2 Field-production panel — `func_0264A8 @0x0264A8`
- Background fill `@0x0264E9`: `push 0x48,0x48,0x20,0xE0 → func_02633E` ⇒ **rect (x=224, y=32,
  w=72, h=72)**. **B**
- Scene strip blit `(0x78,0x78,8,[0x835])` via `0x181F:0x506` `@0x0264E1`; two `0x181F:0xCE`
  glyph-rules at `(0xC7,7,0x140)` `@0x026517` and `(0xDF,0x1F,0x128)` `@0x026539` (scene divider
  lines). **B**
- Per-field-worker loop: commodity icon index `= good + 0x17` (`add ax,0x17 @0x026573`), h=0xC,
  sheet `[0x2DA8]`. **B**
- **Production yield indicators use the SHARED proportional sprite-strip primitive
  `0x181F:0x236`** (`func_002EE4`, calls `@0x02665D`/`@0x02668A`/`@0x026700`) — a count shown
  as a row of filled/empty icons fitted to a fixed span at pitch `(span−w)/(count−1)` clamped
  `[1, w+1]` (overlapping when the count is large). This is the **same** verb the Continental
  Congress bell row and other reports use; see `viceroy_source/docs/UI_PRIMITIVES.md` §0x236.
  Do not re-derive it per panel. **B**
- ⇒ field-production panel = FILL (224,32,72,72) + commodity icons (ICONS 0x17+). Labels
  "Harvest / Resources" / "Units Present" / "Make" are **LABELS `@CMISC`** (verified present). **B**

### 3.3 Colonist plaza row — `func_0270D0 @0x0270D0`
- Background fill `@0x0270D6`: `push 0x30,0x78,0x82,0 → func_02633E` ⇒ **rect (x=0, y=130, w=120,
  h=48)**. **B**
- Count = `colony+0x1F` + `[0x8D72]` `@0x0270E6`. **B**
- **Row x-origin = 0x8F = 143** (`mov [bp-0x60],0x8F @0x0270FA`); the row walks **LEFT**
  (`dec [bp-0x60] @0x027178`) and wraps when a row's packed width exceeds 0x60=96
  (`cmp ax,0x60 @0x027170`). Per-colonist sprite width from `[0x83E]:[si+0x3E]` (ICONS). **x-origin
  143 is byte-exact (B); per-colonist pitch is a data-driven packing loop = TBD.**
- Scene-row marker sprite via `0x181F:0xC0E`/`0xA74` lookups. **B**

### 3.4 Flag panel — `func_02853C @0x02853C`
- Background fill `@0x028540`: `push 0x2D,0x11,0x84,0x12F → func_02633E` ⇒ **rect (x=303, y=132,
  w=17, h=45)**. (Disassembler mis-tags `0x84` as STRING "BUILD"; in context it is y=132.) **B**
- **Flag sprite** `@0x028558`: `push 0x44 (ICONS 68), push 3, push [0x337]/[0x339] (frame);
  call 0x2C979`. ⇒ **ICONS sprite 0x44 = 68**, drawn at panel **+3**, **frame = nation byte**
  `[0x337]`/`[0x339]`. **B**
- Trailing `[bp+6]≠0`: `0x181F:0xE2 @0x02858A` outlines (303,132,17,45). **B**

### 3.5 Surrounding-tile minimap — `func_027DB2 @0x027DB2`
- Background fill `@0x027DB7`: `push 0x30,0x54,0x82,0x79 → func_02633E` ⇒ **rect (x=121, y=130,
  w=84, h=48)**. **B**
- `[0x33C]==0` (no tiles) → sub-fill `(0x79,0x54,0x84,0x39)` + **CENTERED caption** (string `[0x2DD0]`)
  via `0x181F:0x22`+`0x181F:0x100` `@0x027DCE..0x027DE5`. **`[0x2DD0]` is the SHARED empty-panel
  caption string** — the Europe dock "No Ships In Port" draws the same id (`@0x031501`); shared-
  widget index `viceroy_source/docs/UI_PRIMITIVES.md` §0a. **B**
- Else: **6-slot surrounding-tile loop** (`cmp 6 @0x027DF7`), geometry from `call 0x2C9D8`, sprite
  **ICONS 0x7B = 123** (`mov ax,0x7B @0x027E25`), sheet `[0x2DA8]`, blit `0x181F:0x254`. **B**
- ⇒ per the drawlist this "minimap" is the **surrounding-tile scene drawn as 6 sprite-0x7B tiles**
  over the flat fill — **NOT** a world-map render. (Reconcile with the prior "28×19 minimap" /
  "3×3 work grid" claims in §6.) **B**

### 3.6 SoL / cargo / message panel — `func_02814C @0x02814C`
- Background fill `@0x02814F`: `push 0x30,0x5B,0x82,0xD3 → func_02633E` ⇒ **rect (x=211, y=130,
  w=91, h=48)**. **B**
- Branches on `[0x337]` to one of three sub-renderers (`call 0x2C9B0 / 0x2CA50 / 0x2CAA0`
  `@0x028166/0x02816C/0x028172`) — the SoL-bar vs cargo vs message variants. **B**
- Trailing `[bp+6]≠0`: `0x181F:0xE2 @0x028197` outlines (211,130,91,48). **B**
- **Mode text source = TBD.** No colony-screen-render call cites a literal "Sons of Liberty" /
  "No Ships" string; those words appear only in **GAME `@COLONYOPTIONS`** (a report-options dialog)
  and the GAME advisor messages (`@SONSUP`/`@REBELMAJORITY`/`@TORYMAJORITY`), and **LABELS `@MISC`**
  has "No Ships In Port" — none is tied by a cited offset to this panel. Treat the panel-label text
  as **TBD** until a sub-renderer (`0x2C9B0`/`0x2CA50`/`0x2CAA0`) is decoded. (Corrects the prior
  spec's asserted literals.)

### 3.7 Buildings loop — `func_02701C @0x02701C`
- Scene backdrop: `0x181F:0xCE` glyph-row `(0xC7,7,…) @0x02703F`; `0x181F:0x4FC` strip blit
  `(7,0x78,0xC7,8,0) @0x02705F`. **B**
- **15-slot loop** `@0x027067..0x0270B1` (`cmp 0xF @0x02707B`): per slot `bx = slot·4`
  (`shl bx,2`), then **x = `[bx+0x266]`**, **y = `[bx+0x268] + 8`** `@0x027087/0x02708B`. Building
  TYPE from `[bx−0x729E]`, present-gate from `[bx−0x717E]` (skip if `<0`). Blit `call 0x2CA23`. **B**
- ⇒ buildings are **TABLE-POSITIONED** (DGROUP `0x266` stride 4), **not** a fixed column grid.
  BUILDING.SS sprite index = **type+1** ([V @0x027087], `SCREEN_LAYOUTS.md` §3). The exact
  per-type/level frame map (level switch 0x0F/0x11/0x13/0x14/0x2F/0x30) is one leaf deeper and is
  **R/TBD** (recol-xref to `COLONY_RENDERER_DECODED.md` §2, VICEROY frame offset not yet pinned). **B**

### 3.8 Terrain scene — `func_026374 @0x026374`
- Colony cell from `[0x8542]:[bx+0]` (X→`[0x17C]`) / `+1` (Y→`[0x17E]`) `@0x026381`. **B**
- Scene-cell ptr via `0x181F:0xC5E` (→`func_03200A`) `@0x02638A`. **B**
- Three page-21 hops set viewport + per-tile select: `0x191F:0x8A4` (→`func_0678FE` clip),
  `:0x896` (→`func_066A98` per-tile select), `:0x888` (→`func_06693A` viewport origin)
  `@0x02639A/0x02639F/0x0263A4`. **B**
- Scene backdrop blit: `push 0x50,0x50,8,0xC8,0,0` + 8 sheet words `[0x839E..0x83A4]×2;
  0x181F:0x510 @0x0263A9..0x0263D6`. **B**
- **scene UNIT/worker loop** `@0x0263E5`: count `colony+0x329`; per-record cell `+0xC8`(col)/`+0xDE`
  (row); **x = cell·24 + 252 (0xFC)**, **y = cell·24 + 60 (0x3C)** (+90 carried); sprite via
  `0x181F:0x718` (→`func_0060A0`), sheet `[0x839E]`, blit `0x181F:0x254`. **B**
- **per-tile blit** (companion `@0x066968`): **x = col − [0x9CCC] + 252**, **y = row − [0x9CCA] + 9**,
  sheet `[0x2DA8]`, blit `0x181F:0x290`; scroll origin = colony (x=[0x17C]−28, y=[0x853C]−40).
  16-px terrain pitch vs 24-px unit-cell pitch (both byte-confirmed). **B**
- per-tile sprite select (`func_066A98`): forest type 0x10→glyph 8; coast via `[bx−0x5A8A]`; special
  terrain via `[di+0x848]`. **B**

### 3.9 Stockpile bar — `func_0281D6` (warehouse twin of Europe's market bar)
- Background fill `@0x0281DB`: **bar (x=0, y=179, w=320, h=21)**. **B**
- **16 cells, pitch 19 (0x13)** (`add 0x13 @0x02822A`), count `cmp 0x10 @0x028231`; icon index
  `good + 0x17` (`add 0x17 @0x028253`) ⇒ **ICONS 23..38**, icon-Y 181 (0xB5). Per-cell number =
  warehouse **quantity** (vs Europe's market price). **B**
- Gold readout at **(306, 179)** `@0x0283F1`. **B**

## 4. UI layout — "what is drawn where"
All rects below are **byte-cited B** unless tagged otherwise (the `func @ offset` is the PUSH site of
the rect or sprite). Colors are EUROPE/COLONY.PIK palette indices → RGB; fonts are screen-latched
(see `fonts_and_colors.md`).

| Element | Rect (x,y,w,h) | Sprite / text | Font | Color | Fn @offset | Tier |
|---------|----------------|---------------|------|-------|------------|------|
| Full-screen region fill | (0,0,320,200) | flat patterned fill | — | panel fill | `func_02633E` (`0x181F:0x444`) | B |
| Title strip ("menu bar above") | origin **R** (DOS-centered, y≈5) | per-colony fields + table strings (literal text **TBD**, §3.1) | FONTTINY¹ | nation/screen-latched¹ | `func_0268CE @0x0268CE` (paint `0x181F:0xB0`) | B chain / TBD text |
| Field-production panel | (224,32,72,72) | commodity icons ICONS `good+0x17` | FONTTINY | per-icon | `func_0264A8 @0x0264E9` | B |
| Colonist plaza row | (0,130,120,48) | colonist sprites; **x-origin 143, walks left** | — | — | `func_0270D0 @0x0270D6` | B (pitch TBD) |
| Flag panel | (303,132,17,45) | **ICONS sprite 0x44 (68)** at +3, frame=`[0x337]`/`[0x339]` | — | — | `func_02853C @0x028540` | B |
| Surrounding-tile minimap | (121,130,84,48) | **6× ICONS sprite 0x7B (123)** tiles (or centered caption if `[0x33C]==0`) | — | per-tile | `func_027DB2 @0x027DB7` | B |
| SoL / cargo / msg panel | (211,130,91,48) | mode-switch on `[0x337]` (3 cases) | FONTTINY | — | `func_02814C @0x02814F` | B (text TBD) |
| Buildings (15 slots) | **each BUILDING.SS frame's own baked (x,y)** (the `0x266` table is filled FROM the frame coords) | **BUILDING.SS** frame from (type,level); type=`byte[0x8D62+i]`, level=`byte[0x8E82+i]` (`<0`=empty); dummy frames 10/11/17/30/31 = level-fallback markers (skip) | — | — | `func_02701C @0x027067` / `SPRITE_CATALOG.md` | B |
| Terrain scene tiles | x=col−[0x9CCC]+252, y=row−[0x9CCA]+9 | sheet `[0x2DA8]`, blit `0x181F:0x290` | — | per-tile | `func_026374 @0x066968` | B |
| Scene units | x=cell·24+252, y=cell·24+60 | sheet `[0x839E]` via `func_0060A0` | — | — | `func_026374 @0x0263E5` | B |
| Stockpile strip | (0,179,320,21); 16 cells, pitch 19, icon-Y 181 | ICONS `good+0x17` (23..38); qty | FONTTINY | qty white `0x0F`, **red `0x0C` when over warehouse cap** (`0x181F:0xD3A`) | `func_0281D6 @0x0281DB` | B |
| Warehouse-bar right readout | (306,179) | heap **string #`[0x2F5E]`** (caption; **NOT gold** — corrected 2026-06-23) | FONTTINY | white `0x0F` | `@0x0283F1` | B draw / TBD semantic |
| **Gold (treasury)** | **top menu header** (x/y TBD) | `PowerRecord+0x2A` via `[0x84FC]` (mirror `+0x9CB0`) | menu-bar font | — | menu chrome (`[0x9CD2]`, `@0x072FE1`); colony recompute `@0x02B80E` | B field / TBD blit |
| Panel outlines | each panel (single colour) | 1-px frame | — | — | `0x181F:0xE2` | B |
| Screen-bottom rule | (0,200,320) | 1-px rule | — | — | `func_028592 @0x028607` | B |

¹ Title font/colour: the EXE emits the green UI colour `(0x52,0x8A,0x31)` via the screen-latched
handle (the same latch the map-view title strip uses); the per-blit handle is **not** a per-draw
push, so title-as-rendered is **A**, and a prior pixel capture read it as yellow (218,178,0) — a
noted discrepancy (`fonts_and_colors.md`). The title **paint origin** is **TBD** (§3.1).

> **Stripped fabrications (do NOT render these — they are not in `func_028592`):** two-tone HI/LO
> bevel edges on any panel; a (0,130,130,25) "field panel" with "Bells:"/"Food:" readouts (the
> (0,130,120,48) region is the colonist row, and the real field panel is at (224,32,72,72)); plaza
> grass bands at (0,155,…)/(0,171,…); a colonist row at x=8 walking right (it is x=143 walking left);
> a fixed 5-column buildings grid (positions come from table `0x266`). All per drawlist "PORT FIXES /
> COLONY". **B**

## 5. Assets & text
- **Sheets:** **BUILDING.SS** (buildings, index type+1), **ICONS.SS** (`[0x83E]`: commodity 0x17..0x26,
  colonist, flag 0x44, surrounding-tile 0x7B), terrain/scene sheet `[0x2DA8]`, scene-unit sheet
  `[0x839E]`. Backdrop **COLONY.PIK** (key 0x0BA0) — **a 320×72 *scene strip*, NOT a full-screen
  background** (build-verified 2026-06-23 from the decoded bundle: `COLONY.png` is 320×72). The lower
  ⅔ of the screen is the composer's wood-pattern region fill (step 4, `func_02633E`), panels over it.
  Note: COLONY.PIK has its **own palette** (≈ VICEROY.PAL), distinct from the **gameplay palette**
  (PHYS0/WOODTILE/ICONS/**BUILDING** all share it — build-verified: BUILDING.SS renders NOISY under
  VICEROY.PAL but correct under the gameplay palette). The colony screen runs on the gameplay palette;
  the COLONY.PIK strip is remapped onto it. **Buildings:** the BUILDING atlas is itself laid out at the
  colony-screen coordinates — **each frame is blitted at its own (x,y)**, which IS the byte-accurate
  building layout (NOT a grid; the `0x266` runtime table caches these). **B** (build-verified 2026-06-23).
- **Verified text keys** (grepped present in `data_extracted/text/*_sections.json` this pass):
  - **LABELS `@CTITLE`** = "Pop:", "Gold:", "BUY", "CHANGE", "Select An Item To Build",
    "(No Production)", "(More)", "Turns)", "Select a Profession for", "Tax:". **B**
  - **LABELS `@CMISC`** = "Harvest / Resources", "Units Present", "Make". **B**
  - **LABELS `@CMESSAGE`** = colony trade/cargo message lines ("bought for", "sold for",
    "moved to", "% Tax:", "No room for", …). **B**
  - **NAMES `@CARGO`** = the 16 goods (Food…) → stockpile/field icons. **B**
  - **NAMES `@BUILDING`** = `name, hammers, tools×10, size, min_colony, upkeep` (Stockade 64H,
    Docks 52H, Town Hall 64H, …). **B**
  - **NAMES `@JOB`** = profession names (Farmer, Sugar Planter, …) for the work assignment. **B**
  - **NAMES `@SEASONS`** = `Spring\nAutumn` (**2** entries, not 4) for the title line. **B**
  - **NAMES `@COLORS`** = `68,149,8,128,47,138,134,128,138` (UI palette indices into VICEROY.PAL —
    the minimap owner-dot / hilite slots `0x830..0x839`). **B**
  - **NAMES `@COLONYNAME`** + per-nation lists **COLONY `@DUTCH`/`@ENGLISH`/`@FRENCH`/`@SPANISH`**
    (the colony name pool the title draws from). **B**
- **NOT a colony-screen text key (TBD):** there is **no** colony-render-cited "Sons of Liberty" /
  "No Ships" string. "Sons of Liberty" occurs only in GAME `@COLONYOPTIONS` and advisor messages
  (`@SONSUP`, `@REBELMAJORITY`, `@TORYMAJORITY`, `@SONSDOWN`); LABELS `@MISC` has "No Ships In Port".
  The SoL-panel label text source stays **TBD** (§3.6).

## 6. Interactions
- Click own colony tile → this screen (entry chain §1). **B**
- The bottom stockpile strip mirrors Europe's market bar layout but shows warehouse **quantities**;
  on the colony screen it is the per-page twin `func_0281D6` (not the trade interface). **B**
- Build-cost gating: per-building hammer/tool costs are **data, not code** — NAMES `@BUILDING`
  (`name, hammers, tools×10, size, min_colony, upkeep`; DGROUP table `0x8F8C`). `func_02D658` *reads*
  `@BUILDING[+0x94]` and gates the two hammer banks (`+0x92`/`+0xB6`); it holds no cost table.
  Stockade 64H, Docks 52H, Armory 52H all byte-confirmed against `@BUILDING`. **B**
- The SoL/cargo/msg panel switches content on `[0x337]` (3 modes); the per-mode behaviour is in
  sub-renderers `0x2C9B0`/`0x2CA50`/`0x2CAA0`, not yet decoded. **B** (switch) / **TBD** (modes).

## 7. Evidence
- `viceroy_source/docs/drawlist/EUROPE_COLONY.md` PART 2 — composer `func_028592 @0x028592` 12-step
  ORDER (§2.0); sub-renderers title `func_0268CE @0x0268CE` (§2.1), field `func_0264A8 @0x0264A8`
  (§2.2), plaza `func_0270D0 @0x0270D0` (§2.3), flag `func_02853C @0x02853C` (§2.4), minimap
  `func_027DB2 @0x027DB2` (§2.5), SoL/cargo/msg `func_02814C @0x02814C` (§2.6), buildings
  `func_02701C @0x02701C` (§2.7), terrain scene `func_026374 @0x026374` (§2.8); "Coordinate summary"
  + "PORT FIXES / COLONY". **B**
- `viceroy_source/docs/SCREEN_LAYOUTS.md` §3 — `[V]`-cited element table: stockpile bar 16 cells,
  ICONS 23..38, pitch 19, fill `@0x0281DB`; flag (303,132,17,45) sprite 0x44; minimap (121,130,84,48);
  SoL panel (211,130,91,48); buildings 15 slots `cmp 0xF @0x02707B`, BUILDING.SS type+1. **B**
- `docs/COLONY_RENDER_CHAIN.md` §1/§2 — `[0x8542]` near-ptr; ColonyRecord base `0x5D46` stride `0xCA`;
  entry chain `func_L187 @0x07D3E → set_active_colony @0x82DC → lcall 0x191f:0x1de`. **B**
- `viceroy_source/docs/COLONY_SYSTEM.md` — colony-record field meanings for the live data. Marked
  **RECONSTRUCTED — NOT BYTE-VERIFIED** in its own header, so its formulas (SoL ratio, production,
  warehouse caps) are tier **R** here, not B (see §8). **R**
- `data_extracted/text/{LABELS,NAMES,COLONY}_sections.json` — `@CTITLE`, `@CMISC`, `@CMESSAGE`,
  `@CARGO`, `@BUILDING`, `@JOB`, `@SEASONS`, `@COLORS`, `@COLONYNAME`, `@DUTCH`… (all grep-verified
  present this pass). **B**

## 8. Open questions
1. **Title paint origin/centering — TBD (paint routine now identified).** The terminal paint in
   `func_0268CE` is `0x181F:0xB0` (`func_00275C`) at `@0x026AA6` with `mode=0` (§3.1); the call chain
   and string sources are **B**. The x/y are the per-screen text-box globals `[0x2CC6/0x2CC8/0x2CCA/
   0x2CCC]` (runtime state from the `0x181F:0xC22` context init), so centred `y≈5` stays **R** — do not
   invent a literal origin.
2. **Colonist-row per-unit pitch — TBD.** `func_0270D0` x-origin 143 walking left is **B**; the pitch
   is a data-driven width-accumulate/wrap loop (wrap at packed width >96) with no static literal.
3. **SoL / cargo / msg panel mode text — TBD.** Panel rect (211,130,91,48) and the 3-way `[0x337]`
   switch are **B**; the per-mode strings are in sub-renderers `0x2C9B0`/`0x2CA50`/`0x2CAA0` (not
   decoded). No colony-render-cited "Sons of Liberty"/"No Ships" key exists (§5) — earlier revisions
   asserting those literals were **overcommitted**; corrected to TBD here.
4. **SoL% formula — R, not B.** The prior spec gave `sol = (colony[+0xC2]·100)/colony[+0xC6]` +20
   human-latch, clamp 100, and a tory-threshold text-colour rule. Those traced to overlay-`0x181F`
   helpers and the **RECONSTRUCTED** `COLONY_SYSTEM.md`; neither survives as a byte-cited offset in
   the primary sources mined this pass. **Downgraded to R/TBD** until re-confirmed against a
   `func_XXXXXX @0xNNNNN` (the colony's SoL math lives in overlay 0x191F, not yet extracted —
   `COLONY_RENDER_CHAIN.md` §6d).
5. **Building per-type/level frame map — R.** Index = **type+1** is **B** (`@0x027087`); the exact
   BUILDING.SS frame for each level (switch 0x0F/0x11/0x13/0x14/0x2F/0x30) is recol-xref only
   (`COLONY_RENDERER_DECODED.md` §2), VICEROY offset not pinned → **R**.
6. **"Work grid" vs surrounding-tile scene — RECONCILED to the drawlist (B).** Earlier revisions
   described a **3×3 work grid** at cell `(col·0x18+0xC8, r·0x18+8)` and separately a **28×19**
   surround minimap, both from the low-trust C reconstruction / removed geometry docs. The
   byte-cited drawlist shows two distinct things instead: (a) the **terrain scene** `func_026374`
   places worked colonists on tiles at **cell·24+252 / cell·24+60** (§3.8), and (b) the
   **surrounding-tile minimap** `func_027DB2` is a **6-slot loop of sprite 0x7B** over (121,130,84,48)
   (§3.5) — *not* a 28×19 raster and *not* a 3×3 grid. The "3×3 work grid" cell formula is therefore
   **R** (decompiler/C-recon, superseded by the scene loop); the surround panel is **B**. Step-8 is
   now **resolved** to the stockpile bar (`func_0281D6`, below), so it is *not* a work-assignment grid.
7. **Stockpile bar's position in the composer order — RESOLVED (B), 2026-06-23.** Step 8
   (`call 0x2CA19` → `0x191F:0x654`) is `func_0281D6`; all 12 composer head-calls are now named
   sub-renderers and **no menu/button bar** is drawn — the top is the title strip (§3.1, item 1).
