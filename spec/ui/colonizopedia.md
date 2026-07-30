# Colonizopedia (in-game encyclopedia)

> **Layer 2 — UI Specification.** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R.
> Renderer topology + per-page layouts are **B** (byte-cited against
> `raw/COLONIZE/VICEROY.EXE` via `code/VICEROY/disasm_overlay_reseg/page_16.asm`;
> decode record: `docs/UI_PHASE1_ATTRIBUTION.md` §3, all load-bearing cites
> independently re-resolved 2026-07-30). Entry TEXT is data (PEDIA.TXT), names are
> NAMES.TXT — both committed under `data_extracted/text/`. All sections are
> decoded (2026-07-30); residual TBDs are enumerated in §11 with exact trace
> sites.

**Canonical primary:** `page_16.asm` (complete listing for all seven entry pages +
browser; the per-function `code/VICEROY/disasm/func_*_unknown.asm` files are
truncated — do not cite them), `data_extracted/thunk_targets.json`,
`data_extracted/text/{PEDIA,NAMES,LABELS,MENU}_sections.json`.
**Ruling:** `notes/rulings/RULINGS.md` 2026-07-30 — `func_069D8C` is the pedia
TERRAIN page, in-game (refutes the old "map-editor palette" claim; CLAUDE.md hard
rule 7 amendment pending user sign-off).

## 1. Purpose
The in-game encyclopedia ("ENCYCLOPEDIA OF COLONIZATION"). 166 content surfaces:
seven category index pages + per-entry article pages (Cargo 16, Unit, Terrain,
Colonist Skill 28, Colony Building 42, Founding Father 25, Game Concept 12).
Reached two ways (both B):
- **Menu**: menu-command executor `func_0235D6` → browser `func_06B398`
  (`0x191f:0x372` @0x02390B).
- **Context help**: dispatcher `func_02BC72` (page 0x02), switch on selection
  type `[0x32E]` @0x02BD08 → 0 = tile terrain → TERRAIN page @0x02BD64; 1 = unit
  profession → JOB @0x02BD90; 2/3 = unit type → UNIT @0x02BDCE; 4 = cargo
  (`[0x33A]`) → CARGO @0x02BDDC. Plus per-screen help sites (colony/europe
  helpers) listed per page below.

Renderer roster (overlay page 0x16, one function per category, `@PEDIA` line n =
category label):

| n | category (`@PEDIA` line) | function | key | entries |
|---|---|---|---|---|
| 0 | Cargo Type | `func_0694AE` | `"CARGO"` | 0..15 |
| 1 | Unit Type | `func_0696C6` | `"UNIT"` | 0..22 |
| 2 | Terrain Type | `func_069D8C` | `"TERRAIN"` | 0..28 |
| 3 | Colonist Skill | `func_06A700` | `"JOB"` | 0..27 |
| 4 | Colony Building | `func_06AA88` | `"BUILDING"` | 0..41 |
| 5 | Founding Father | `func_06AE08` | `"FATHER"` | 0..24 |
| 6 | Game Concept | `func_06AF1C` | `"MISC"` | 0..11 |

Key strings live at DGROUP 0x1ECD..0x1F05 (byte-read at file 0x1F86D–0x1F8A5).
Article body = PEDIA.TXT section `<KEY><idx>` rendered by the standard text-window
engine (`0x181f:0x998` = `func_06F51A` = menu_lookup_run).

## 2. Shared page skeleton (B — identical opcode sequence in all seven)
Native 320×200, full-screen modal.

| step | element | placement / mechanism | cite |
|---|---|---|---|
| 1 | Background | WOODPANL.PIK via `func_069304`: `0x191f:0x87A("WOODPANL"@DG 0x1EC4, ctx [0x2DA8], 0)`; on nonzero → fill color 8 (`0x484`) + full-screen rect op `0x444` (320×200) | @0x069319/@0x069337/@0x069365 |
| 2 | Screen title | `[0x2E92]` = **"ENCYCLOPEDIA OF COLONIZATION"** (LABELS `@MISC` line 108; runtime label-ptr array base DG 0x2DBA, slot = line), centered `0x100` (x0=0, w=320, **y=5**, color `[0x831]`) | e.g. @0x0694C4–@0x0694D2 |
| 3 | Entry header | `<entry name>` + separator + `<category label>` (from `func_06927C`: `0x181f:0x422("PEDIA","PEDIA", n)` = `@PEDIA` line n), centered `0x100` at **y = font_height+7** (font far ptr `[0x89E]`) | @0x06927F–@0x069295 |
| 4 | Body seed | y = header_y + font_height + 0xE (JOB page: +font_height+3); **x = 10** | per-page cites |
| 5 | Article | key = `<KEY><idx>` (strcpy + `0x182` append-number); `[0x1F5A]` = text-window y-cursor (word global, init 0xFFFF; NOT a string); `0x181f:0x438` = `func_06C23C` sets text-substitution slot 0 = entry name; `func_06929C` sets `[0x1F56]\|=0x20` and runs menu_lookup_run("PEDIA", key) | @0x06C23C/@0x0692D2/@0x0692EE |
| 6 | Terminate | present `0xE2` (0, 0x140, 0xC8) + `0x3C0` MODAL-WAIT, RETF | e.g. @0x0696B8–@0x0696C4 |

Sprite convention: `0x181f:0x254` AX=frame, DX=x, stacked y + far sheet handle,
BX=&ctx 0x2DA8. Sheets: **ICONS.SS = `[0x83E]`** (cargo icons frames 0x17+i;
profession figures 0x52+job), **BUILDING.SS = `[0x842]`** (building pictures
frame rec+1).

## 3. Cargo Type page (`func_0694AE`, idx 0..15) — B
- Entry name: cargo-name ptr table DG 0x97C0 (runtime-filled from NAMES `@CARGO`)
  @0x0694FE.
- Production-chain rows (switch @0x069567–@0x069633; row renderer `func_06936C`;
  **row pitch y+=0x14**):
  Food → (Farmer row)+(Fish row: icon 0x3A, job 8 Fisherman, "Fish"=`[0x2F1C]`);
  Sugar/Tobacco/Cotton/Furs → raw+manufactured pairs (i,i)+(i+8,i+8);
  Lumber → (5,5)+(Hammers 0x10, Carpenter 0xD); Ore → 3 rows Ore→Tools→Muskets;
  Silver/Horses/Trade Goods → single row.
- Row layout (`func_06936C`): job figure ICONS frame job+0x52 at (10, y−2),
  x+=0xE; cargo icon frame cargo+0x17 (0x10→0x37, <0→0x3A) at x, x+=0x10, then
  **6 more copies at x+=4** (7-icon stack), x+=0xC; text `"<Cargo> With
  <Expert>"` (`[0x2F1E]`="With") at (x, y+4) color `[0x830]`
  @0x0693B1–@0x0694A7.
- Context-help callers: @0x02BDDC (`[0x32E]`=4), @0x02AFBE, @0x02BABD, @0x0336AB,
  @0x033B4F, @0x035560.

## 4. Unit Type page (`func_0696C6`, idx 0..0x16) — B
Signature: `far func(unit_type)`, one word param. Decoded 2026-07-30; 12
load-bearing cites + the separator literal pool + the type→job byte table
re-verified against the EXE.

- **Temp preview unit**: creates a throwaway UnitRecord via `0x1a1f:0x1CA` =
  `func_04007E` (type 0, x=y=−6, nation `[0x5398]`) @0x0696CB–@0x0696DA; sets
  orders=0, type=param, profession=0x13 @0x0696E7–@0x0696F6; destroyed at exit
  (`0x181f:0x808` = `func_006E94` on `[0x539C]−1`) @0x069D7B–@0x069D85.
- **Figures** drawn by `0x181f:0x2BC` = `func_00386A` (per-unit info panel) from
  the temp record — args (width=0x64, 0, y), AX=unit idx, DX=0, BX=x.
  **Horizontal pitch 0x12 (18px)**; x home = 8.
  - Type 0 (Colonists) = full profession gallery: prof 0x1C first, then
    0x19/0x1A/0x1B, then profs 0..0x16 skipping 0x12 (Teacher) and 0x13
    (Colonist); **17 figures per row** (`cmp [bp-2],0x11` @0x069864), wrap
    y+=0x14 — 25 figures total @0x0697C7–@0x069879.
  - Types 1–5: two figures — prof 0x13 at x=8, then expert job from byte table
    DG 0x30E (file 0x1DCAE = `13 15 14 18 17 16`: 1→0x15, 2→0x14, 3→0x18,
    4→0x17, 5→0x16; job 0x17 renders as prof 0x15 @0x0698DB) at x=0x1A
    @0x06987C–@0x0698FE.
  - Type 0xB (Artillery): second figure with UnitRecord flags `+0x04 |= 0x80`
    set @0x069923 then cleared @0x069942 — the "Damaged" state pair.
- **Name line** at (post-figures x, fig_y+6), color `[0x830]`: UnitName (stride
  0xE table DG 0x5230, +0) plus — types 1–5: `" (and <ExpertPlural>)"`
  (`[0x2E8E]`=@MISC 106 "and"; plural = JOB table 0x8EA2 +2); type 0xB:
  `" (and Damaged <UnitName>"` — **the closing ")" is missing in this branch
  (original bug, byte fact @0x0699E6–@0x069A62)**. Then y += 0x18.
- **Stat line** at (8, y), color `[0x830]`, from table 0x5230 (+5=combat,
  +6=attack, +4=moves×3, +7=cargo holds):
  `"Combat: N"` (`[0x2F20]`=@MISC 179) — type 0xB adds
  `"(Attack: +2 Damaged: -2)"` (delta = +6−+5 @0x069B39; literal 2 @0x069B89);
  types 1/4 add `"(Veteran: N)"` with attack×1.5 (`×3>>1` @0x069BEC);
  all: `"Moves: N"` = +4 **div 3** (`cl=3` @0x069C46); if +7≠0:
  `"(Cargo Holds: N)"` @0x069C86–@0x069CF0.
- **Article**: key `"UNIT"+idx` (push 0x1ED3 @0x069D0C) → PEDIA `@UNIT0..23`;
  `[0x1F5A]` = stat_y + 0xC @0x069D2B; modal-wait @0x069D76.
- **Separator helpers resolved (B)**: the `0x181f` string-builder wrappers
  strcat DGROUP literals (pool byte-read at file 0x1D9F0+): `0x178`=" " (DG
  0x50), `0x1BE`=": " (0x55), `0x11E`="(" (0x5E), `0x128`=")" (0x60),
  `0x146`="+" (0x66), `0x15A`="−" (0x68), `0x196`=" "×N, via `0xd1d:0x7a4`.
- Callers: browser @0x06B5FE; context help @0x02BDCE (`[0x32E]`=2/3);
  unit-list help sites @0x02AECB, @0x02B355, @0x02B701 (buildable-unit items),
  @0x03342C tail @0x033570, @0x0339F8, and three sites in the un-resegmented
  page-04 tail (@0x034305, @0x035263, @0x03559C — containing functions MEDIUM).

## 5. Terrain Type page (`func_069D8C`, id 0..28) — B
Signature: `far func(terrain_id)` — full id space (0–7 unforested, 8–23
auto-forest, 24–28 `@OTHER`). Decoded 2026-07-30; 10 load-bearing cites + the
resource table + sheet-name strings re-verified against the EXE. **This decode
byte-confirms hard rule 5**: the preview's base ground comes from the same
TERRAIN.SS-derived tile array the map composer uses.

- **Header**: `"(<Name>: Terrain Type)"` centered at y=font_h+7; name from
  terrain record table **DG 0x2F74, stride 16, field +0** @0x069DE3; ids 8..15
  get `" Forest"` suffix (`[0x2DB0]`, NAMES `@OTHER_NAMES` line 0) — ids 16..23
  do NOT. Tile-block top y0 = 2·font_h+9.
- **Terrain record table** (loader `func_0745F0`/`func_0749E0`): +0 name,
  +2 move cost, +3 defense factor, +4/+5 numeric cols, **+7..+15 = 9 yield
  bytes (jobs 0..8)**; `@UNFORESTED`→0..7, `@FORESTED`→8..15, **16..23 =
  byte-copy of 8..15** (`rep movsw` @0x074A6D), `@OTHER`→24..28.
- **3×3 tile preview** at frame box (7, y0)–(0x3A, y0+0x33) (52×52, double
  rect `0x181f:0xce` colors `[0x839]`/`[0x837]`); cells 16×16 at x=9/25/41,
  y=y0+2+16r:
  1. Base ground via `0x181f:0x25e` = `func_003460` blitting 256-byte tiles
     from the flat array `[0x16c]/[0x16e]` @0x06A127 — **12 tiles rasterized
     at boot by `func_072B9A` from sheet "terrain" (TERRAIN.SS) frames 1..12**
     (`mov ax,0xc` @0x072BA8; `[0x16c]` write @0x072C5C; placeholder frame 0
     skipped, hard rule 5). Tile ids: 0..7 base terrains, 8 forest ground,
     9 Arctic, 10 Ocean, 11 Sea Lane; normalizer `func_003436` (0x11||9→8,
     ≥8→−15). Ground id: mtn/hills→3 (Prairie), ≥24→id, else id&7; forest with
     desert base (Scrub) → ground 0x11 + decoration suppressed.
  2. Forest overlay (ids 8..23): PHYS0.SS (`[0x174]`) frame **0x41 +
     M[c+3r]**, M = DG 0x1EE4 = [5,7,6,13,15,14,9,11,10] (byte-verified) —
     the per-cell connection masks. Hills: 0x31+M; Mountains: 0x21+M.
  3. Plain-land decoration: corner cells get tree clumps (frame 0x41) or, for
     Desert, forest-ground redraw; bottom-center cell gets shore-base frame
     **0x96 (150)**.
  4. Rivers (land, incl. forest): (0,1)→frame 0x17, (0,2)→0x1B (minor-river
     band 0x11 + masks 6/0xA, hard rule 4). Roads (all but water): (2,0)→
     0x53+0x56, (2,1)→0x52+0x55.
  5. Center cell: prime resource frame **0x5A + R[id]** if R[id]≠−1; **R =
     word table DG 0x192 (file 0x1DB32, re-verified)** =
     [6,1,2,3,4,5,6,6, 9,1,8,9,10,10,6,6, 9,1,8,9,10,10,6,6, −1,7,−1,12,13]
     (indexes NAMES `@RESOURCE`: Plains→Wheat, Ocean→Fishery, Mountains→
     Silver Deposit, Hills→Ore Deposit, Arctic/Sea Lane→none).
- **Stat rows** (right column, x=63, row pitch 0x10): one row per job j=0..8
  with nonzero yield byte:
  - ICONS figure frame 0x52+j at (63, row_y); `"<JobName>: N"` at (75,
    row_y+6) color `[0x831]` — **N = yield, +1 for Farmer/Fisherman, ×2 for
    Lumberjack** (@0x06A570–@0x06A582);
  - `"    <Plow|Road|Coast>/River: +K"` color `[0x830]` — label Plow (j≤3) /
    Road (j 4..7) / Coast (j=8); K = 1 + (j==4) + (j==5);
  - resource-bonus line if `0x181f:0xa6a(R[id], j)` ≠ 0 (`func_009AAA`,
    matrix byte-read: Game/Farmer +2, Beaver/Trapper +3, Fishery/Fisherman
    +3, prime crops → ×2, Minerals/Ore/Silver bonuses…): inline PHYS0
    resource icon + name (table DG 0x930C; Prime Tobacco → label "Prime") +
    `"x2"` for prime crops or `"+r"` (doubled for Lumberjack; `"/2r"` extra
    for Farmer/Fisherman) color `[0x831]`;
  - `"    Expert: "` + ("+3" for j∈{0,8}, else "x2") color `[0x830]`.
- **Movement/defense line**: `"<Move Cost>: M    <Defense or Ambush Bonus>:
  +D%"` — M = record +2 @0x06A604; **D = 25 × record +3** (`mov al,0x19; mul`
  @0x06A650); at (63, row_y+6) color `[0x830]`.
- **Article**: key `"TERRAIN"+raw id` → `@TERRAIN0..28` (all 29 sections
  exist; forest variants have their own articles); article y = max(stats_y,
  y0+0x40); substitution slot 0 = name via `0x181f:0x416` = `func_06C220`
  (slot buffer DG 0x9CD2 + 64·slot); modal-wait @0x06A6F7.
- **Callers** (id derivation confirmed for all three): browser case 2;
  `func_02BC72` @0x02BD64 — colony-screen tile: map coords = colony x/y +
  plot offset − 2 (colony base `*[0x8542]`, hard rule 8), terrain via
  `0x181f:0x78c` = `func_00627A` (default 25 Ocean off-map); `func_0235D6`
  @0x023808 — map-screen tile at (`[0x8540]`,`[0x853E]`). Corroborates the
  2026-07-30 ruling (not a map-editor palette).
- Static ink inits byte-read at file 0x1E1D0+: `[0x830]`=0x44, `[0x831]`=0x95
  (runtime rewrites untraced — open item).

## 6. Colonist Skill page (`func_06A700`, idx 0..27) — B
- Job name: DG 0x8EA2 stride-8 table +0 (NAMES `@JOB`; +2 = expert-plural)
  @0x06A74F.
- Workplace: `0x181f:0xB00` = `func_008D9C`, signed-byte table DG 0x2F4 (file
  0x1DC94, 19 entries; jobs 0–8 → −1 outdoor); no building → y+=0xB.
- Job figure ICONS frame idx+0x52 (idx 0x1B→0x43) at (10, y + bldg_h/2−7);
  expert name at (+0xE, fig_y+6); x+=0x18 @0x06A7F5–@0x06A86C.
- Building upgrade-chain loop: BUILDING frame b+1, x += frame_width+3, name from
  DG 0x8F82 stride-12; next b = byte 0x8F82[b]+4 while ≥0 @0x06A89C–@0x06A947.
- Product strip (idx<0x13): cargo icon idx+0x17 (specials 8→0x3A, 0xD→0x37,
  0x10→0x39, 0x11→0x3F), x+=0x10; name `[0x97C0]` with id remap 0xD→0x10,
  0x10→0x11, 0x11→0x12; idx 8 → "Fish" @0x06A95C–@0x06AA11.
- Context-help callers: @0x02BD90 (`[0x32E]`=1, profession field +0x40, remap
  0x1C→0x13), @0x029721, @0x029D15, @0x02A05B, @0x034984, @0x03500C.

## 7. Colony Building page (`func_06AA88`, idx 0..41) — B
- Name: DG 0x8F82 stride-12 +0 (NAMES `@BUILDING`) @0x06AAD3.
- Big picture: BUILDING frame rec+1 at (10, y), w/h from sheet header; idx
  0x10/0x1F → no picture (h=0x18, w=0); idx 0x11 → frame 0x2F (same override as
  colony screen) @0x06AB43–@0x06ABA1.
- Header strip: name at (10+w+3, h/2−7+y+6) color `[0x831]`; worker job via
  `0x181f:0xACE` = `func_009786` byte table DG 0x2CA (42 entries building→job);
  skip if job 0x12 (Teacher) / 0x15; else figure + expert name + product icon
  and name @0x06ABA6–@0x06AD1C.
- y += h+0xC; **Prerequisite line** if byte 0x8F82[idx]+3 ≥ 0:
  `[0x2F32]`="Prerequisite" + separator + prerequisite name at (10, y) color
  `[0x830]`; y+=0x14 @0x06AD3C–@0x06AD9F.
- Context-help callers: @0x02A076, @0x02B6E4.

## 8. Founding Father page (`func_06AE08`, idx 0..24) — B
Text-only. Name from DG 0x9652 stride-6 +0 @0x06AE53; y += font_height+0xE;
article `@FATHERn` (sections exist for 0..24). Extra callers: **FF-acquire
dispatch `func_03BC42` @0x03BD26** (shown when a Father joins the Congress) and
Congress selection screen @0x03C24E.

## 9. Game Concept page (`func_06AF1C`, idx 0..11) — B
Text-only. Name from DG 0x935C stride-2 ptr table @0x06AF67 — **loader resolved
2026-07-30 (B)**: page-1A text-loader @0x07530B–@0x07534B reads section
"MISCELLANEOUS" (DG 0x22DE) of "PEDIA" via `0x191f:0x928`; line 0 = "12" →
count `[0x846]` @0x075329; 12 line-pointers → `[0x935C+2i]` @0x07533E. Article
key `"MISCn"`. Only caller = browser. **Open item:** extracted PEDIA.TXT has no
`@MISC0..11` sections — resolution of `"MISC5"` by menu_lookup_run is TBD
(possibly header-only render).

## 10. Browser + index pager (`func_06B398` / `func_06B02A`) — B
Decoded 2026-07-30; jump tables, menu-command binding, and section-name strings
re-verified against raw bytes (menu jump table file 0x023DE8: all eight commands
0x70..0x77 → handler file 0x023904; DGROUP 0x22DE="MISCELLANEOUS",
0x22EC="PEDIA", 0x21CE="OTHER_NAMES" byte-read).

### Entry & menu binding
`func_06B398(category 0..7)`. The category menu is **the standard pulldown**
built from MENU.TXT `@PEDIA` (8 items: 7 categories + "Complete") — NOT a `0x998`
list-menu. Menu executor `func_0235D6` dispatches commands 0x1B..0x77 via
`jmp cs:[bx+0x2F08]` @0x023DE3 (table file 0x023DE8); commands 0x70..0x77 all
target @0x023904: `category = command − 0x70`, `lcall 0x191f:0x372` @0x02390B →
browser. **Category 7 = "Complete"** merges all 7 categories into one
alphabetized index (loop i=0..6 @0x06B3B4–@0x06B3C7) — 162 entries total.

### List build (helpers, all page-0x16-local)
- `func_068F38` list-init @0x06B39D: allocates 3 far buffers — name handles
  (0x1B0 B, word/entry → `[0x1EA6]`), category bytes (0xD8 → `[0x1EAA]`),
  within-category index bytes (0xD8 → `[0x1EAE]`); count `[0xA5AA]`=0.
  **Capacity 0xD8 = 216 entries** (`cmp [0xa5aa],0xd8` @0x068FA4 in the
  appender `func_068FA0`).
- Enumerator `func_06B202(cat)` (dispatch table file 0x06B388) appends per
  category:

| cat | bound | skips | name table (DG, stride) | source |
|---|---|---|---|---|
| 0 Cargo | 16 | — | 0x97C0, 2 | NAMES `@CARGO` 0..15 |
| 1 Unit | 23 (@0x06B243) | — | 0x5230, 0xE | NAMES `@UNIT` |
| 2 Terrain | 0x1D (@0x06B279) | ids 0x10..0x17 (@0x06B282) | 0x2F74, 0x10 | 0..7 `@UNFORESTED`, 8..15 `@FORESTED`, 24..28 `@OTHER` |
| 3 Skill | 0x1C | 0x12 Teacher (@0x06B2BA) | 0x8EA2, 8 | NAMES `@JOB` |
| 4 Building | 0x2A | 0xA,0xB,0x1E,0x1F (@0x06B2EC) | 0x8F82, 0xC | NAMES `@BUILDING` |
| 5 Father | 25 | — | 0x9652, 6 | NAMES `@FATHERS` |
| 6 Concept | `[0x846]`=12 (@0x06B35B) | — | 0x935C, 2 | PEDIA `@MISCELLANEOUS` |

→ sizes 16/23/21/27/38/25/12. Forested terrains (idx 8..15 of cat 2) get a
display suffix: `func_06921A` appends `" " + [0x2DB0]` ("Forest") @0x069248–
@0x069270 — "Boreal Forest" etc.; the sort still compares the base name.
- **Alphabetical sort** `func_069058` @0x06B3E9: gnome/bubble sort, comparator
  `0xd1d:0x103e` (strcmp-family) on the 0x22-resolved name pointers @0x0690B5.
- Free on exit: `func_068EE0` (three `0x191f:0x1A8` frees) @0x06B658.

### Index-page layout (`func_06B02A(highlight, present)`)
- Content clear `0x444` at (0, 0xF, 0x140, 0xB9) — preserves the 15px title
  strip @0x06B04E.
- **Grid: 3 columns × 24 rows = 72 entries/screen.** First index =
  `[0xA5AC]`·0x18 @0x06B05E; cell pos (`func_069156`): row = i%0x18, col =
  i/0x18 − `[0xA5AC]`; **x = col·0x64 + 5** (5/105/205) @0x069182;
  **y = row·7 + 0x19** (25..186, **pitch 7**) @0x069190. Font = FONTTINY
  (`[0x89E]`).
- Per cell: text at (x+2, y+1), ink `[0x830]` normal / `[0x831]` highlighted;
  highlight = solid bar `0x181f:0xBA` (w = textwidth+4, h = fontH+1) color
  `[0x835]` @0x06B14E–@0x06B15E.
- **"(More)"** (`[0x2E94]`, @MISC 109) at **(5,5)** left, drawn only when
  count>0x48 @0x06B184; **"(Exit)"** (`[0x2E96]`, 110) always,
  **right-aligned to x=0x13B (315), y=5** via `0x150` @0x06B1CF (right-align
  mechanism byte-verified in `func_002B72` @0x002B9F). Both flank the centered
  title on the title row; hover recolors them to `[0x831]` (params −2/−3).
- Present `0xE2` when `[bp+8]`≠0.
- Browser title differs from entry pages: color **0xF literal** @0x06B3F1–
  @0x06B408 (entry pages use `[0x831]`).

### Input (browser loop @0x06B425)
- Keys: Up '8'/0x148, Down '2'/0x150 ((cursor±1) mod count), Left '4'/0x14B
  (−0x18, wrap to right-most column same row), Right '6'/TAB/0x14D (+0x18,
  wrap to residue mod 0x18; accept test `jle` @0x06B4C5 admits cursor==count —
  **apparent original off-by-one**), ENTER/SPACE = open article, ESC = exit.
- Column-granular auto-scroll on `[0xA5AC]` @0x06B470/@0x06B508.
- Mouse (`func_0691A4` hit-test): y≤0xF & x<0xA0 → "(More)" (−2); y≤0xF &
  x≥0xA0 → "(Exit)" (−3); else per-entry rect (w=0x64, h=7) via `0x3CA`
  @0x0691EF. Hover tracks; click on "(More)" pages forward 3 columns
  (cyclic) @0x06B557–@0x06B57D; click on entry opens it; "(Exit)"/empty
  space exits.
- After an article returns, full redraw with cursor/page reset @0x06B3DE;
  loop until exit.

### Reachability
`func_06B398` has exactly one caller (whole-corpus grep): `func_0235D6`
@0x02390B — the Colonizopedia is reachable only from the eight `@PEDIA`
pulldown items (plus the direct per-page context-help sites of §1).

## 11. Open items (exact trace sites)
1. ~~`[0x2E92..]` label-array loader~~ **RESOLVED 2026-07-30**: the LABELS
   `@MISC` pointer table (base DG 0x2DBA, 221 entries) is loaded
   @0x075214–0x07523C (opens section "MISC" DG:0x22B3, stores line ptrs
   `[0x2DBA+2i]`) — same page-1A loader cluster as `@OTHER_NAMES`
   (@0x074AC2) and `@MISCELLANEOUS` (@0x07530B).
2. `LCALL 0xd1d:...` C-runtime (0x7e4 strcpy, 0x7a4 strcat, 0x103e strcmp,
   0x117e strcpy, 0x8f6 atoi — usage-inferred) — resolve the 0xd1d segment
   fixup; also settles sort case-sensitivity.
3. Substitution-slot store body near 0x06F7EA.
4. `"MISCn"` section resolution (§9).
5. ~~Separator-glyph helpers~~ **RESOLVED 2026-07-30** (§4): strcat wrappers of
   the DGROUP literal pool at 0x50.. (" ", ": ", "(", ")", "+", "−").
6. Internal y/baseline of centered-title verb `0x100` (overlay @0x0606C0).
7. `func_00386A` (0x2BC per-unit info panel) internals — figure sheet + frame
   math, effect of flags bit 0x80 "Damaged", meaning of prof 0x1C figure
   (needs full disasm of 0x00386A..~0x003E4x; per-func asm truncated).
8. NAMES `@UNIT` → DG 0x5230 loader (confirm +4 stored as moves×3); same
   family as the unlocated 0x8EA2 `@JOB` loader.
