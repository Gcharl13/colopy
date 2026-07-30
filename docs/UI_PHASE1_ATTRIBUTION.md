# Phase 1 — Attribution of the undocumented in-game render code

> Closes the "Undocumented in-game render code" row of the coverage gap ledger in
> `docs/UI_AUDIT_TRACKER.md`. Five targets: `func_05E9B0` (page 0x11),
> the page-0x16 modal family (`func_0694AE/06A700/06AA88/06AE08/06AF1C`),
> `func_061F02` (page 0x13), `func_048F34` (page 0x0C), `func_0452D4` (page 0x0A).
> Every fact below is cited `@0xNNNNNN` (file offset = linear address; DGROUP base
> file 0x1D9A0). Un-cited = **TBD**, per the CLAUDE.md UI mandate.

Disasm substrate: `code/VICEROY/disasm_overlay_reseg/page_*.asm` (committed).
Spot-check protocol: load-bearing cites re-resolved against the reseg listing
before a section is marked verified.

---

## 1. `func_05E9B0` (page 0x11, file 0x05E9B0..0x05FAC2, 4371 B) — generic two-column unit-roster modal

**SCREEN: RESOLVED 2026-07-30 — this is the COMBAT ANALYSIS dialog** (the
pre-combat odds breakdown gated by the Game Options "Combat Analysis"
checkbox). The runtime pointers are now pinned: sole caller = land-combat
resolver `func_05CA7E` @0x05D291 (`lcall 0x1a1f,0x704` → stub 0x1CCF4 →
0x05E9B0; gate `test [0x5383],2` @0x05D221), and the title/label pointers
`[0x2E36..0x2EC4]` are slots of the LABELS.TXT `@MISC` pointer table at
DGROUP 0x2DBA, loaded @0x075214–0x07523C (`[0x2E50]` = line 75 = "COMBAT
ANALYSIS"; Fatigue/Attack Bonus/Ambush/Terrain/Colony/Fortified/Spain
Bonus/Drake/Bombard/Tory Unrest/Rebel Unrest…). The two "columns" are
attacker and defender; the descriptor bitmasks are combat modifier-flag
words `[col*2+0x8D00]`/`[col*2+0xA156]`. Full row/value decode:
`spec/ui/combat_analysis.md`. (Original analysis below kept for the layout
record — it was correct; only the identity was open.)

**Verification status:** 15 load-bearing cites spot-checked against
`page_11.asm` 2026-07-30 — all resolve exactly (`0x9e6` @0x05E9BE, `0xa4c`
@0x05E9CF, `imul ax,ax,0x14; add ax,6` @0x05E9F7, panel `0x1a1f:0x710` @0x05EA22,
title loader `0x22` @0x05EA50, centered title `0x100` @0x05EA5A, info-panel `0x2bc`
@0x05EAA9, `imul bx,[bp-0x78],0x1c` @0x05EABC, row pitch `add [bp-0xe],0x14`
@0x05EB6F, sprite `0x254` @0x05EBAB, `cmp byte[bx+0x3146],1/4` @0x05EC4D/@0x05EC54,
`mov al,[bx+0x3150]` @0x05ED3D, right-column `add ax,0x50` @0x05FA12, pass gate
`cmp [bp-0x1c],2` @0x05FA7F, full-blit `0xe2` @0x05FAB1 + modal-wait `0x3c0`
@0x05FAB6).

### Why user-facing, not debug
Ends in MODAL-WAIT `lcall 0x181f,0x3c0` @0x05FAB6, right after a full-screen op
`lcall 0x181f,0xe2` with (x=0, y=0xC8=200, w=0x140=320) @0x05FAB1, then cleanup
`0x181f:0x56a` @0x05FABB, `leave/retf` @0x05FAC2. A drawn screen that blocks on
input is a real screen.

### Data it iterates (identity anchor: the unit table)
- Row record = **UnitRecord, base DGROUP:0x3144, stride 0x1C**. Index in
  `[bp-0x78]`, addressed via `imul bx,[bp-0x78],0x1c` @0x05EABC / @0x05EC49 /
  @0x05ED39.
- UnitRecord **+0x02 = type** (`0x3146`): `cmp byte[bx+0x3146],1` / `,4`
  @0x05EC4D/@0x05EC54 — type 1 = Soldiers, 4 = Dragoons per NAMES.TXT `@UNIT`.
- **+0x0C = cargo_slot_count** (`0x3150`): `mov al,[bx+0x3150]` @0x05ED3D, then
  `al*0x64` and `sar ax,3` @0x05ED65 → emits **value×100÷8** (an "of-8-slots"
  percent).
- **+0x17** (`0x315b`): `cmp byte[bx+0x315b],0x15` @0x05EC62 — Soldier/Dragoon
  special-case; appends label ptr `[0x2e3c]` + literal `0x32`=50 @0x05EC92.
- Unit sprite icon: `lcall 0x181f,0x254` @0x05EBAB with sprite index **0x26 (38)**,
  sheet handle `lea bx,[0x2da8]` (runtime), icon-strip words `[0x83e]/[0x840]`
  @0x05EB93/@0x05EB97.
- Per-unit unit-info-panel: `lcall 0x181f,0x2bc` @0x05EAA9, draw-pass gated.

### Layout (rebuild-B facts)
- **Two-pass render**: gate word `[bp-0x1c]` loops 0..1 (`cmp [bp-0x1c],2; jge
  exit` @0x05FA7F). Pass 0 = MEASURE (all draw calls skipped), pass 1 = DRAW.
  Pass 0 accumulates per-column row counts into `[bp-0x16]`/`[bp-0x14]`.
- **Framed background panel**: `lcall 0x1a1f,0x710` @0x05EA22 — x-base **0x35
  (53)**, width **0xD6 (214)** (x 53..267), height = `maxrows*0x14 + 6`, top-y =
  **100 − height/2** (vertically centered on the 200-px screen); maxrows math
  `imul ax,ax,0x14; add ax,6` @0x05E9F7.
- **Centered title**: `lcall 0x181f,0x100` @0x05EA5A; title string fetched by
  loader `lcall 0x181f,0x22` @0x05EA50 from **runtime ptr `[0x2e50]`** (y=0x38=56,
  x-seed=0xd0=208). Two header string-ids arrive as params `bp+0x16`/`bp+0x18`,
  pre-resolved via `0x181f:0x9e6` @0x05E9BE and `0x181f:0xa4c` @0x05E9CF (only if
  ≥0).
- **Two side-by-side unit columns**: inner loop `[bp-0x18]` 0..1. Per-column
  unit-list base params `bp+6`/`bp+8`; per-column **render bitmasks** from DGROUP
  descriptor tables `[bx-0x7300]`→`[bp-0x76]` and `[bx-0x5eaa]`→`[bp-0xcc]`
  @0x05FA4C/@0x05FA53 (bx = colidx×2); value table `[bx-0x72fa]` @0x05EB11.
  Column x-seed `[bp-0xc]` = **0x38 (56)**; right column **+0x50 (80)**
  (`add ax,0x50` @0x05FA12; pane calc @0x05FA61). **Row pitch 0x14 (20 px)**:
  `add word[bp-0xe],0x14` @0x05EB6F / @0x05EC2B / @0x05FA24.
- **Shadowed dual-draw cells**: each cell drawn twice — `0x181f:0x13c` with color
  byte `[0x830]` then `0x181f:0x150` with color byte `[0x831]` (dark/light
  drop-shadow pair; used by all ~20 row draws).
- **Cell strings** built in stack buffers `[bp-0x6c]`/`[bp-0xc8]` via helper chain
  `0x146`/`0x15a`/`0x182` (append-number)/`0x10a`/`0x16e` (strcat). Primitive
  histogram over the blob: `0x13c`×20, `0x150`×20, `0x182`×21, `0x16e`×20,
  `0x146`×17, `0x10a`×16 → **~12–16 configurable columns**, each gated by a bit
  (1/2/4/8) of the descriptor bitmask. Literal `0x182` args (0x21=33, 0x42=66,
  0x32=50, 0x11=17, 0x64=100): **meaning TBD** — values vs field widths hinges on
  the unverified `0x15a`/`0x10a`/`0x146` helper semantics.
- **Labels**: runtime DGROUP pointer block `[0x2e36]`, `[0x2e3c]`,
  `[0x2e50]..[0x2ec4]`, plus `[0x97de]`, `[0x5ad4]` — BSS, zero on disk; the label
  TEXT is a runtime value.

### What reaches it
Only via overlay thunk segment 0x181f (Type-A, page-0x11 directory); **no static
caller in callgraph.json**. The caller passes: `bp+6`/`bp+8` = the two column
unit-list bases; `bp+0x12`/`bp+0x14` = per-column header/count;
`bp+0x16`/`bp+0x18` = two title/label string-ids. Screen identity is entirely
determined by that caller.

### Runtime-open items (exact trace sites)
1. **Screen identity + title text**: trace the writer of DGROUP `0x2e50` and the
   thunk that lcalls page-0x11 offset 0x0270 (= this function's entry IP).
2. **Column set / labels**: capture live the descriptor tables at DGROUP ~0x8d00
   (`[bx-0x7300]`), ~0xa156 (`[bx-0x5eaa]`), value table ~0x8d06 (`[bx-0x72fa]`),
   and the label-pointer block `0x2e36..0x2ec4`.
3. **Sprite sheet**: handle `[0x2da8]` + icon strip `[0x83e]/[0x840]` are runtime;
   index 0x26 is fixed.
4. **Helper semantics** of `0x181f:0x15a/0x10a/0x146` decide whether the `0x182`
   literals are values or widths.

---

## 2. `func_061F02` (page 0x13, file 0x061F02, 2067 B) — "Close Moves" pathfinding DEBUG overlay

**SCREEN:** **debug-only** — the "Close Moves" pathfinding debug overlay
(DEBUG.TXT `@OPTIONS` bit **0x10**), drawn over the in-game map view.
`func_061F02` itself is not a screen: it is the **short-range (16×16-window)
path-step finder**, with the debug renderer embedded in its tail. The prompt-era
hypothesis "debug/diagnostic overlay" is **verified**; the "Three"/"Four" string
association is **refuted** (see below).

### Identity evidence
- Debug gate at entry: @0x061F0A reads latch `[0x1DF2]`; @0x061F14
  `test byte [0x894],0x10`; @0x061F1B `[0x53A2]`; @0x061F21–0x061F28
  `[0x1DD6]==[0x5396]` (current player, per `docs/COLONY_RENDER_CHAIN.md`).
- `[0x894]` is the **debug-options bitfield**: builder `func_02356C`
  @0x023585–0x023587 (`shl dx,cl; and dx,[0x894]`) loops exactly **7 bits**
  (@0x023593 `cmp [bp-2],7`), shows a dialog with strings DS:0xABB="OPTIONS",
  DS:0xAC3="DEBUG" (file 0x1E45B), rebuilds bits @0x0235C6 `or [0x894],ax`.
  DEBUG.TXT `@OPTIONS` ("Select Debug Information Options",
  `data_extracted/text/DEBUG_sections.json`) has exactly 7 `~` checkbox items;
  **index 4 (bit 0x10) = "~Close Moves"**.
- Family corroboration: sibling `func_06295E` tests bit **0x20 "Far Moves"**
  @0x062975 and pushes fmt DS:0x1DF6 "Far: %d(%d,%d)…" @0x062CDA; `func_062D84`
  tests bit **0x40 "All Movement"** @0x062D94 and sets the latch `[0x1DF2]=1`
  @0x062D75 that `func_061F02` honors.
- Draws over the live map view: `0x181F:0xE1C(1)` @0x062601 → `func_067700` =
  map composer (RULINGS.md, tracker row 1).
- **Refuted hint**: strings "Three"/"Four" (DS:0x1E2C/0x1E32) are NOT referenced
  by this function — its only DGROUP string refs are `push 0x1DD8` @0x06267B
  (fmt `"(%d,%d)-(%d,%d) %d == %d"`, file 0x1F778) and `lea bx,[0x1DCA]`
  @0x0626AA. The strings.json xref 0x13C79 for that fmt is a false positive
  (immediate inside EMS code @0x013C73 `int 0x67`).

### Function decode (the path-step finder)
Register args saved @0x061F06–0x061F09: ax=target_x→`[bp-0x8A]`,
dx=target_y→`[bp-0x88]`, bx=cost bound→`[bp-0x86]`; returns ax = best direction
0..7 at the *target* toward the path start, −1 fail (init @0x06205A).
- Start tile = (`[0xA14E]`,`[0xA14C]`); window origin = start−8
  (@0x061F2F/@0x061F38), 16×16.
- Ship test: moving unit type `[0x1DD2]` in 13..18 (@0x061F41/@0x061F48) —
  NAMES `@UNIT` rows 13..18 = Caravel…Man-O-War.
- One-move unit: `byte[0x5234+type*14] ≤ 3` @0x061F6B (UnitTypeStats moves×3) →
  flat step cost 3 @0x0622F4.
- Cost cache 256 B at DS:0xA270, memset via `0xD1D:0xDAE` = `func_01037E`
  @0x061FBA–0x061FC7; BFS queues x@DS:0xA372 / y@DS:0xA472, write/read idx
  `[0x2D16]/[0x2D18]`, cap 0xE1 @0x062055; cache reused when origin
  `[0x2D1A]/[0x2D1C]` unchanged @0x061F83–0x061FA9.
- Neighbor tables (file 0x1DA54/0x1DA5E): DS:0xB4 dx {0,1,1,1,0,−1,−1,−1},
  DS:0xBE dy {−1,−1,0,1,1,1,0,−1} → dirs 0..7 = N,NE,E,SE,S,SW,W,NW; applied
  @0x06210D/@0x06211B.
- Tile rules: bounds `0x302`=`func_005BFA` @0x062157; terrain `0x78C`=`func_00627A`
  @0x062169, ==0x19/0x1A (**Ocean 25 / Sea Lane 26**, consistent with hard rule 2)
  → water @0x062174–0x06217C; land/water mismatch allowed only at endpoints
  @0x0621BE–0x0621E5; water-water extra check `0x6B4`=`func_005DBA` @0x06219D;
  `0x696`=`func_005F48` @0x0621AF; native units (type≥19 @0x0621E8) reject rumor
  tiles `0x75E`=`func_006188` @0x0621F5; occupying power `0x6D2`=`func_006018`
  @0x062217 must be −1 or `[0x1DD6]`; `0x6E6`=`func_00603A(x,y,[0x1DD6])`
  @0x062239 → power≥4 reject @0x062245, AI power (`byte[0x543F+power*0x34]≠0`
  @0x06224F–0x062254) reject, else +8 @0x06225E.
- Step costs: layer-160 mask 0x0A (`0x754`=`func_005D32`) both ends → +1
  @0x0622A7–0x0622C0; river bit 0x40 layer-15C (`0x72C`=`func_005CFE`) cardinal →
  +1 @0x0622CC–0x0622EC; else terrain Movement `byte[terrain*16+0x2F76]×3`
  @0x062300–0x06230C (TerrainStats).
- Phase 2 picks min-cost neighbor of the target (init 0x63=99 @0x06206B),
  tie-break by distance `0x37A`=`func_00493C` @0x06259F; prune vs `[0xA370]`
  @0x06202C/@0x062062.

### Debug overlay layout (byte-cited)
- Focus tile `[0x17C]/[0x17E]` ← target @0x0625F1/@0x0625F8 (same globals as the
  colony screen); full map redraw `0x181F:0xE1C(1)` @0x0625FF (`func_067700`).
- **Per-tile cost numbers**: for each nonzero cache cell (@0x06262B),
  `0x191F:0x12C` @0x06263F → `func_078068(x, y, cost, color 0x0F)` (args
  @0x062632–0x06263C; thunk via `data_extracted/thunk_targets.json`
  01B71C→0x078068). Placement inside `func_078068`:
  px = `(x+[0x832A]−[0x8328])·[0x5AD4]` @0x078081–0x07808B;
  py = `(y+[0x832C]−[0x832E])·[0x8326]+8` @0x078092–0x0780A0; nudge
  `+7>>zoom, +6>>zoom`, zoom=`[0x184]` @0x0780D2–0x0780E3 (map zoom 0..3,
  `spec/ui/map_view.md` §6.2); at zoom 0 a backing rect at (px−1,py−1), width
  strwidth+1 via `0x181F:0xBA` @0x07810C; color set `0x1F0`=`func_00E68A`
  @0x07811C; digits blitted `0x1FA`=`func_00E51C` @0x07813A.
- **Summary line**: sprintf-family `0xD1D:0xB48`=`func_010118` @0x062683, fmt
  DS:0x1DD8 `"(%d,%d)-(%d,%d) %d == %d"` filled with (startX `[0xA14E]`, startY
  `[0xA14C]`, targX, targY, bound, bestdir) — pushes @0x062664–0x06267E; color
  **12 (red)** via `0x1F0` @0x06268B–0x062695; drawn at **x=5, y=190**
  (`ax=5` @0x0626AE, `dx=0xBE` @0x0626B1) onto surface descriptor DS:0x1DCA
  (file 0x1F76A: 200, 320, seg 0xA000 — direct 320×200 VGA), font far ptr from
  `[0x89E]/[0x8A0]` @0x06269A–0x06269E.
- **Key loop**: getch `0x3E0`=`func_00D286` @0x0626B9, post `0xD1D:0x92C`
  @0x0626C2; **'Z'** → `[0x184]−−` clamp ≥0 @0x0626D0–0x0626D8 (zoom in);
  **'X'** → `[0x184]++` clamp ≤3 @0x0626DE–0x0626EA (zoom out), each redraws;
  **ESC** → clears `[0x1DF2]/[0x1DF4]` @0x0626EC–0x0626F1 and exits; any other
  key exits; final redraw `0xE1C(1)` @0x062705.

### What reaches it
Exactly **one static call site** in the corpus — @0x05392F in `func_053820`
(page 0x0E) via thunk `0x1A1F:0x5F0` (file 0x1CBE0 → 0x061F02,
`thunk_targets.json`). That caller sets `[0x1DD6]=−1` @0x053908, start = source
colony x/y → `[0xA14E]/[0xA14C]` @0x05390E–0x053917, `[0x1DD2]=[0x1DD4]=1`
@0x05391A–0x053920, bound 0x63 @0x05392C — it walks a colony→colony land route
and spawns a unit of type `[0x524E]` on it (`0x191F:0xA20` @0x053A0A). Note: with
`[0x1DD6]=−1` the Close-Moves gate arm `[0x1DD6]==[0x5396]` fails, so for this
caller the overlay appears only via `[0x53A2]≠0` or the All-Movement latch
`[0x1DF2]`.

### Confidence & open items
HIGH on attribution (debug-only, "Close Moves") — the 7-bit dialog ↔ `@OPTIONS`
text ↔ bit-0x10 test plus the 0x20/0x40 siblings triangulate it; HIGH on overlay
layout (all draw calls byte-cited); MEDIUM on some cost-rule helper semantics.
The low-trust recon (`viceroy_source/src/overlay/overlay_0612E6_066EB3.c` line
312, "ai_unit_order / path preview") agrees on the algorithm but missed the DEBUG
`@OPTIONS` attribution.

**TBD (exact trace sites):** (1) `0x181F:0xBA` push args (0,7) + surface dwords
`[0x25AC..0x25B2]` in `func_078068` @0x0780ED–0x07810C; (2) internal semantics of
`func_005DBA` (0x6B4), `func_005F48` (0x696), `func_006018` (0x6D2),
`func_00603A` (0x6E6); (3) exact bit names inside layer-160 mask 0x0A (road vs
plow) — needs `func_005D32` layer-write sites; (4) identity of the font behind
`[0x89E]/[0x8A0]`; (5) precise meaning of `[0x53A2]` in the gate.

---

## 3. Page-0x16 modal family — the Colonizopedia entry pages

**SCREEN:** the five targets (`func_0694AE/06A700/06AA88/06AE08/06AF1C`) plus two
siblings on the same page (`func_0696C6`, `func_069D8C`) are the **per-entry
article screens of the Colonizopedia**, one per category:

| function | key | PEDIA category (`@PEDIA` line n) | entries |
|---|---|---|---|
| `func_0694AE` | `"CARGO"` (DGROUP 0x1ECD, push @0x069664) | 0 = Cargo Type | 0..15 |
| `func_0696C6` | `"UNIT"` (0x1ED3, push @0x069D0C) | 1 = Unit Type | — |
| `func_069D8C` | `"TERRAIN"` (0x1EDC, push @0x06A6A6) | 2 = Terrain Type | — |
| `func_06A700` | `"JOB"` (0x1EED, push @0x06AA2A) | 3 = Colonist Skill | 0..27 |
| `func_06AA88` | `"BUILDING"` (0x1EF1, push @0x06ADA3) | 4 = Colony Building | 0..41 |
| `func_06AE08` | `"FATHER"` (0x1EFA, push @0x06AEC4) | 5 = Founding Father | 0..24 |
| `func_06AF1C` | `"MISC"` (0x1F01, push @0x06AFD2) | 6 = Game Concept | 0..11 |

Each builds a PEDIA.TXT section key (`"CARGO12"`, `"FATHER7"`, …) via strcpy +
`0x181f:0x182` append-number and renders it with the standard text-window engine —
matching `@CARGO0..15 / @JOB0..27 / @BUILDING0..41 / @FATHER0..24` in
`data_extracted/text/PEDIA_sections.json`.

**Verification status:** independently re-verified 2026-07-30 — the DGROUP key
string block byte-read from VICEROY.EXE (file 0x1F852..0x1F8A5: `PEDIA`×3,
`WOODPANL`, `CARGO`, `UNIT`, `TERRAIN`, `JOB`, `BUILDING`, `FATHER`, `MISC`);
all seven key pushes + both `[0x2e92]` title pushes (@0x0694C4, @0x069DA3) +
modal terminator (@0x0696B8/@0x0696BD) resolved in `page_16.asm`; thunk stubs
resolved via `thunk_targets.json` (01B962→0x06B398, 01BA18→0x069D8C,
01BECE→0x06A700, 01BEF2→0x06AA88, 01BF24→0x0694AE, 01BF32→0x0696C6,
01C652→0x06AE08, 01CFA4→0x06AF1C) — with segment-0x191f stub base **file
0x1B5F0**, so `lcall 0x191f,0x428` @0x02BD64 → 0x1BA18 → `func_069D8C`,
`0x934`→CARGO, `0x942`→UNIT, `0x8de`→JOB, `0x372`→browser, all consistent.

### Shared skeleton (identical opcode sequence in all seven)
1. **Wood-panel background** — near stub 0x6B692 → thunk 0x1CFC0 →
   `func_069304`: `0x191f:0x87A("WOODPANL"@DGROUP 0x1EC4, ctx [0x2DA8], 0)`
   @0x069319 (same WOODPANL.PIK loader as the front-end); on nonzero → fill
   color 8 via `0x181f:0x484` @0x069337 + full-screen 320×200 rect op
   `0x181f:0x444` @0x069365.
2. **Screen title** — `0x181f:0x22` fetch handle **`[0x2E92]`**, centered via
   `0x100` (x0=0, w=0x140, y=5, color `[0x831]`), e.g. @0x0694C4–0x0694D2.
   **`[0x2E92]` = LABELS.TXT `@MISC` line 108 = "ENCYCLOPEDIA OF COLONIZATION"**
   — no static writer; it is slot 108 of a runtime label-pointer array based at
   DGROUP 0x2DBA, anchored by 5 independent slot hits ((More)=109, (Exit)=110
   drawn by pager `func_06B02A` @0x06B1A3/@0x06B1D2; Fish=177; With=178;
   Prerequisite=188 — deltas all `(addr−0x2E92)/2`).
3. **Entry header line** — entry name + separator + category label, centered via
   `0x100` at y = font_height+7 (font far ptr `[0x89E]`). Category label =
   helper `func_06927C` (stub 0x6B67E → thunk 0x1CF88):
   `0x181f:0x422("PEDIA","PEDIA", n)` fetches line n of PEDIA.TXT `@PEDIA`
   @0x06927F–0x069295.
4. **Body y** = header_y + font_height + 0xE (JOB page: +font_height+3); x = 10.
5. **Article** — key = `<KEY><idx>`; `[0x1F5A]` = **text-window y-cursor**
   (word global, static init 0xFFFF at file 0x1F8FA — NOT a string; the earlier
   "sheet name [0x1F5A]" hint is refuted); `0x181f:0x438` = `func_06C23C`
   (@0x06C23C) sets text-substitution slot 0 = entry name; helper `func_06929C`
   (stub 0x6B68D → thunk 0x1CFB2) sets `[0x1F56]|=0x20` @0x0692D2 and runs
   **`0x181f:0x998` = `func_06F51A` = menu_lookup_run** (the standard TXT window
   engine) with ("PEDIA"@DGROUP 0x1EBE, key) @0x0692EE.
6. **Terminate** — present `0xE2` (0, 0x140, 0xC8) + `0x3C0` MODAL-WAIT, RETF
   (e.g. @0x0696B8–0x0696C4). Full-screen modal for all.

Sprite convention: `0x181f:0x254` AX=frame, DX=x, stacked y + far sheet handle,
BX=&ctx 0x2DA8. Sheets: **ICONS.SS = `[0x83E]`, BUILDING.SS = `[0x842]`**.
Cargo icons = ICONS frames 0x17+i; profession figures = ICONS 0x52+job;
building pictures = BUILDING frames rec+1.

### `func_0694AE` — "Cargo Type" page (idx 0..15)
- Entry name from cargo-name ptr table DGROUP 0x97C0 (`[bx-0x6840]`) @0x0694FE
  (runtime-filled from NAMES `@CARGO`; same table as §4's debug dump).
- **Production-chain rows** (switch @0x069567–0x069633; drawn by `func_06936C`;
  row pitch y+=0x14 @0x069655): Food → (0,0)+(Fish row: icon 0x3A, job 8
  Fisherman, name `[0x2F1C]`="Fish" @0x069399–0x0693A8); Sugar/Tobacco/Cotton/
  Furs → raw+manufactured pairs (i,i)+(i+8,i+8) @0x06960A–0x069630; Lumber →
  (5,5)+(Hammers 0x10, Carpenter 0xD) @0x0695EE; Ore → 3 rows Ore→Tools→Muskets
  @0x0695BA–0x0695EC; Silver single @0x0695A4; Horses/Trade Goods single
  @0x069582–0x0695A1.
- **Row layout** (`func_06936C`): job figure ICONS frame job+0x52 at (10, y−2),
  x+=0xE @0x0693B1–0x0693D1; cargo icon frame cargo+0x17 (0x10→0x37 Hammers,
  <0→0x3A Fish) at x, x+=0x10, then 6 more copies at x+=4 (7-icon stack)
  @0x0693D5–0x06941D, x+=0xC; text `"<Cargo> With <Expert>"` (`[0x2F1E]`="With")
  at (x, y+4), color `[0x830]` @0x069423–0x0694A7.
- Callers: pedia browser `func_06B398` @0x06B5F4; context-help far-call sites
  @0x02BDDC (`func_02BC72`, case `[0x32E]`=4, cargo id `[0x33A]`), @0x02AFBE,
  @0x02BABD, @0x0336AB, @0x033B4F, @0x035560.

### `func_06A700` — "Colonist Skill" page (idx 0..27)
- Job name from **DGROUP 0x8EA2 stride-8 table** field +0 (`shl bx,3;
  [bx-0x715e]`) @0x06A74F (runtime-filled from NAMES `@JOB`; +2 =
  expert-plural). This resolves the "stride-8 table 0x8EA2" hint.
- Workplace lookup `0x181f:0xB00` = `func_008D9C` — signed-byte table DGROUP
  0x2F4 (file 0x1DC94, 19 entries: jobs 0–8→−1 outdoor, 13→35 Carpenter's Shop,
  15→3 Armory, 17→9 Town Hall, …); no building → y+=0xB @0x06A7CD.
- Job figure ICONS frame idx+0x52 (special idx 0x1B→0x43 @0x06A811) at (10,
  y+voffset), voffset = building_height/2−7 from BUILDING.SS header
  (`[0x842]`+0x4A+12·b) @0x06A7F5–0x06A805; expert name at (+0xE, fig_y+6)
  @0x06A86C; x+=0x18.
- **Building upgrade-chain loop** @0x06A89C–0x06A947: BUILDING frame b+1
  @0x06A8CB, x += frame_width+3 @0x06A8D4; name from stride-12 table DGROUP
  0x8F82 @0x06A8E5; next b = byte 0x8F82[b]+4 @0x06A939 while ≥0.
- Product strip (idx<0x13): cargo icon idx+0x17 with specials 8→0x3A, 0xD→0x37,
  0x10→0x39, 0x11→0x3F @0x06A95C–0x06A983; name `[0x97C0]` with remap
  0xD→0x10, 0x10→0x11, 0x11→0x12 @0x06A9B6; idx 8 → `[0x2F1C]`="Fish"
  @0x06A9E0; text color `[0x831]` @0x06AA11.
- Callers: browser @0x06B612; context help @0x02BD90 (`[0x32E]`=1, profession
  via `0x181f:0xC54` field +0x40, remap 0x1C→0x13 @0x02BD83), @0x029721,
  @0x029D15, @0x02A05B, @0x034984, @0x03500C.

### `func_06AA88` — "Colony Building" page (idx 0..41)
- Name from DGROUP 0x8F82 stride-12 table +0 @0x06AAD3 (NAMES `@BUILDING`).
- Big picture: BUILDING frame rec+1 at (10, y), w/h from sheet header
  @0x06AB6C–0x06ABA1; idx 0x10/0x1F → no picture (h=0x18, w=0) @0x06AB43;
  idx 0x11 → record 0x2E ⇒ frame 0x2F @0x06AB62 (same override as the colony
  screen).
- Header strip: name at (10+w+3, h/2−7+y+6) color `[0x831]` @0x06ABA6; worker
  job via `0x181f:0xACE` = `func_009786` — byte table DGROUP 0x2CA (file
  0x1DC6A, 42 entries building→job; verified 3-5→15 Gunsmith, 9-11→17
  Statesman, 21-23→11 Weaver, 27-29→9 Distiller, 35-36→13 Carpenter, 37-38→16
  Preacher, 39-41→14 Blacksmith); skip if job==0x12 (Teacher) or 0x15
  @0x06AC1A; else ICONS figure job+0x52 @0x06AC43 + expert name @0x06AC59;
  product cargo icon job+0x17 with remaps @0x06AC91–0x06ACC8 + name @0x06ACF3.
- y += h+0xC @0x06AD27; **Prerequisite line** if byte 0x8F82[idx]+3 ≥ 0
  @0x06AD3C: `[0x2F32]`="Prerequisite" + separator + prerequisite building
  name at (10, y) color `[0x830]` @0x06AD47–0x06AD94; y+=0x14.
- Callers: browser @0x06B61C; @0x02A076, @0x02B6E4.

### `func_06AE08` — "Founding Father" page (idx 0..24)
- Text-only (no sprites). Name from DGROUP 0x9652 stride-6 table +0
  (`[bx-0x69ae]`) @0x06AE53; y += font_height+0xE @0x06AEB4; article
  `@FATHERn`.
- Callers: browser @0x06B626; **`func_03BC42` (FF-acquire dispatch) @0x03BD26**
  — shown when a Founding Father joins the Congress; @0x03C24E (Congress
  selection screen).

### `func_06AF1C` — "Game Concept" page (idx 0..11)
- Text-only. Name from DGROUP 0x935C stride-2 ptr table @0x06AF67
  (runtime-filled; source = PEDIA.TXT `@MISCELLANEOUS` 12 concept names —
  loader site TBD). Article key `"MISCn"`.
- Callers: **only** the browser @0x06B630 (exhaustive far-call scan: zero other
  hits). **Open item**: extracted PEDIA.TXT has no `@MISC0..11` sections (only
  `@MISCELLANEOUS`) — how `menu_lookup_run` resolves `"MISC5"` is TBD (trace
  `func_06F51A`'s section lookup; possibly empty body, header-only render).

### Caller topology
- **`func_06B398` (page 0x16) = the Colonizopedia browser** — same `[0x2E92]`
  title @0x06B3FA; calls all 7 category pages in MENU.TXT `@PEDIA` order via
  the near-stub block @0x06B660–0x06B6BF (CARGO @0x06B5F4, UNIT @0x06B5FE,
  TERRAIN @0x06B608, JOB @0x06B612, BUILDING @0x06B61C, FATHER @0x06B626,
  MISC @0x06B630). Its caller is the menu-command executor `func_0235D6`
  @0x02390B (`0x191f:0x372` → stub 0x1B962).
- **`func_02BC72` (page 0x02) = context-sensitive pedia dispatcher**: switch on
  selection type `[0x32E]` @0x02BD08 → 0 = tile terrain → TERRAIN page
  @0x02BD64; 1 = unit profession → JOB @0x02BD90; 2/3 = unit type → UNIT
  @0x02BDCE; 4 = cargo → CARGO @0x02BDDC. These use segment alias `0x191f`
  (stub base file 0x1B5F0), which is why a naive `0x181f` grep finds no callers.

### Conflict recorded → RULINGS.md 2026-07-30 (touches CLAUDE.md hard rule 7)
Hard rule 7 states file **0x69D8C** (`func_O530`) is the *map-editor
terrain-palette dialog, "confirmed not in-game."* Byte evidence refutes both
clauses: `func_069D8C` pushes pedia key `"TERRAIN"` (0x1EDC @0x06A6A6), draws
the shared "ENCYCLOPEDIA OF COLONIZATION" title (`[0x2e92]` @0x069DA3), and is
far-called **in-game** from `func_02BC72` @0x02BD64 (with a terrain id) and
`func_0235D6` @0x023808, plus the browser @0x06B608. CLAUDE.md itself is NOT
edited (rule amendments need user sign-off) — see the ruling.

### Runtime-open items (exact trace sites)
1. `[0x2E92..]` label-array loader — find the loop filling DGROUP 0x2DBA+2n
   after parsing LABELS.TXT.
2. `LCALL 0xd1d:0x7e4/0x7a4` = strcpy/strcat (usage-inferred) — resolve the
   0xd1d segment fixup.
3. `0x438` substitution-slot store — disassemble near 0x06F7EA to confirm
   slot-0 semantics.
4. `"MISCn"` section resolution (see MISC page).
5. Separator-glyph helpers `0x181f:0x1BE/0x128/0x178/0x11E` — resolve thunk
   stubs @0x01A7AE/0x01A718/0x01A72E properly.
6. Internal y/baseline handling of `0x100` (overlay @0x0606C0) — pushed y=5 and
   header y=font_height+7 are the seed values; internal offset unverified.

Note: `code/VICEROY/disasm/func_06A700_unknown.asm` and siblings are truncated —
`page_16.asm` is the complete listing.

## 4. `func_048F34` (page 0x0C, file 0x048F34..0x0495FF, 1740 B) — native supply/demand model + "Supply and Demand (Indians)" debug dump

**SCREEN:** **debug-only** — `func_048F34` is *not a screen renderer*. It is the
**native-settlement supply/demand economic model** (computes the 16-good
buy-interest and sell-supply arrays for the active Indian village); its only
drawing is the cheat-menu **"Supply and Demand (Indians)" debug dump**, gated on
`[0x894] & 4`. The "colony-placement band" hint for `[0x8D4A]/[0x8D4E]/[0x8D52]`
is **refuted**: those are the active native-settlement ptr / tribe-record ptr /
tribe idx.

**Verification status:** 12 load-bearing cites spot-checked 2026-07-30 — all
resolve exactly (entry `enter 0xa4,0` @0x048F34, colony select `0x181f:0x9e6`
@0x04903A, terrain read `0x78c` @0x049185, tribe ptr `[0x8d4e]` @0x0492F4, clamp
`push 0x32` @0x04943E, debug gate `test byte [0x894],4` @0x0494DA, text draw
`0x13c` @0x04952F, `(0,0x140,0xC8)` blit @0x0495E5ff, blocking getch `0x3e0`
@0x0495F7, sole caller `lcall 0x1a1f,0x434` @0x057093, popup-key pushes
`push 0x181c` @0x05716F / `push 0x1839` @0x0573EB).

### Identity evidence
- **Debug gate**: `test byte [0x894],4` @0x0494DA and @0x0495DE. `[0x894]` is
  the 7-bit debug-options bitfield built by `func_02356C` (see §2). DEBUG.TXT
  `@OPTIONS` item 3 (bit 2, mask 4) = **"~Supply and Demand (Indians)"** — the
  function's exact subject. Sibling bits 0x10/0x20/0x40 already verified as
  Close/Far/All Movement (§2).
- **Debug dump body** @0x0494DA–0x049534: one line per good g (0..15), only if
  either array entry ≠0 (@0x0494E6–0x0494F2):
  `sprintf(buf, "%Fs %d %d\n", name, supply, demand)` — fmt at DGROUP 0x154B
  (file 0x1EEEB), sprintf `func_010118` via `0xD1D:0xB48` @0x049516; good name
  fetched by `0x181F:0x22` from id table `[0x97C0+2g]` @0x049505; drawn by
  `0x181F:0x13C` @0x04952F at **x=1, y=8·(g+1), color 0x0F**
  (@0x04951E–0x04952E). Epilogue: bottom-rule blit `0xE2` with the `(0,0x140,
  0xC8)` idiom @0x0495E5–0x0495F2, then **blocking getch** `0x3E0` =
  `func_00D286` @0x0495F7 — a debug pause, not a game screen.
- **Outputs**: two 16-word DGROUP arrays, zeroed @0x049259–0x04926F:
  `0x9E58[16]` = per-good **demand**, `0x9E78[16]` = per-good **supply**, good
  order = NAMES `@CARGO`. Proven by consumers: `func_04A7CA` (village-visit)
  zeroes last-bought goods @0x04A8C1–0x04A8F0, index-sorts via `0x191F:0xED0`
  @0x04A8F7, pushes good-name ids @0x04A91D/@0x04A932 (the "especially
  interested in …" text); `func_056C3E` reads `[0x9E58]−[0x9E78]` food deficit
  @0x057098–0x05709F → **INDIANBEGFOOD** popup (key DGROUP 0x181C, pushed
  @0x05716F) and surplus `[0x9E78]>[0x9E58]` @0x05737C → **INDIANGIVEFOOD**
  (0x1839, pushed @0x0573EB); `func_049600` (haggle/lost-city) subtracts
  `0x9E78[idx]·4` @0x04A07A.

### Byte-cited structure
- **Phase A — colony-claimed-tile mask** (@0x048F3C–0x049049): clear 25-byte
  mask @0x048F6C; for each colony 0..`[0x539E]` (@0x04902F) select via
  `0x181F:0x9E6` → `[0x8542]` @0x04903A; 5×5 loop maps settlement-relative
  (a,b) to colony-relative coords @0x048F92–0x048FBA, requires x′,y′∈0..4
  @0x048FCC–0x048FE2, center (2,2) special-cased @0x048FE4, else worked-slot
  test `0x181F:0xCE0` = `func_008956` @0x048FF6 (helper matches (dx,dy) against
  20-entry tables DGROUP 0xC8/0xDE, reads ColonyRecord+0x70+slot); mark
  mask[a·5+b]=1 @0x049002. **Anomaly (suspected original bug)**: the in-bounds
  call `0x181F:0x302` = `func_005BFA` @0x048FC0 receives *relative* (x′−2,
  y′−2), but `func_005BFA` tests absolute `1≤x<[0x853A]−1 ∧ 1≤y<[0x853C]−1`
  (@0x005BFE–0x005C1F). Phase B passes absolute coords correctly @0x04913D.
- **Phase B — 5×5 terrain scan** around the settlement (@0x04904A–0x049241):
  terrain id via `0x181F:0x78C` @0x049185 (hard rule 3 family). Classification
  per NAMES `@UNFORESTED` 0..7 + `@OTHER` 24=Arctic/25=Ocean/26=Sea Lane/
  27=Mountains/28=Hills: mountains ctr @0x049190, hills ctr @0x049199, Arctic
  cold+4 @0x0491A2; forested 8..23 routed @0x0491AB–0x0491C2 (food/game pt
  @0x0491C5; base=t−8/t−16 @0x0491D2/@0x0491E5; cold-forest base<3 vs
  warm-forest sugar/tobacco/cotton +2 @0x049206/@0x049211/@0x04921F); open
  land: Savannah sugar+4 @0x04909F, Swamp sugar+2 @0x0490A5, Grassland
  tobacco+4 @0x0490AF, Marsh tobacco+2 @0x0490B9, Prairie cotton+4 @0x0490C3,
  Tundra ore+2 @0x0490CD, Plains cotton+1/food+2 @0x0490D7; Ocean/Sea-Lane fish
  @0x049066–0x049090 (every 3 rate-pts → food+2).
- **Phase C — array build** (@0x049242–0x0495DC), N = settle[+4]+1
  (population+1) @0x049242, tier = tribe[+2]: food supply
  `+= (tier+N)·foodpts/(7−tier)` @0x049271–0x04928B; food demand `4N²` (halved
  if tier≥2) @0x04928F–0x0492A7; silver from tribe[+0xC]/K (K per-tribe byte
  `[0x962A+idx]`) + 4·mountains @0x0492B8–0x0492F0; ore
  `2·hills+mountains+tundra` (tier≥1) @0x0492F4–0x04930B; furs
  `(2·coldforest+otherforest/2)/(tier+1)` @0x04930F–0x049328; coats/tobacco/
  sugar/cotton/cloth supplies @0x04932C–0x049386; demands — tobacco
  `(6−tier)·N+2·cold+5` @0x04938F, cigars @0x0493A5, coats `8·cold+furs`
  @0x0493B5, rum @0x0493C2, trade goods `(tier+2)(N+3)+8` @0x0493D5, tools
  `(tier·N)<<(cold/2+1)` @0x0493EA, muskets `4·(7−tribe[+7]−tier)` @0x0493FC,
  horses `4·(9−tribe[+8]−tier)` @0x049423; horses supply
  `tribe[+0xA]/([0x962A+idx]/2+1)` @0x04940D; muskets supply=0 @0x049434.
  Demand clamp to [0,0x32] via `0x181F:0x35C` = `func_0048CC` clamp
  @0x04943E–0x049460. Capital boost (settle[+3]&4) @0x049462–0x0494B5:
  demand[0..7]×2, demand[13..15]×1.5, supply[7..15]×2. Per-good tribe stock
  `tribe[+0xE+2g]` adjustment @0x0495B9–0x0495D6 / @0x0494C0–0x0494D6; final
  mutual discount `supply−=demand/2, demand−=supply/2` with ≥1 floors
  @0x049537–0x049591 (debug dump sits between the two).

### Reachability
Exactly one stub (`0x01CA24`, type A, = `0x1A1F:0x434`) and exactly one call
site (whole-file scan): **@0x057093 inside `func_056C3E`** (page 0x0F,
mission-village event handler: INDIANSCONVERT @0x057341, INDIANBEGFOOD
@0x05716F, INDIANGIVEFOOD @0x0573EB). `func_056C3E` is entry 9 of a 10-way
far-jmp trampoline row @0x05A1DB–0x05A20C inside the unit-at-village dispatcher
`func_059B90`. So the *computation* runs in normal gameplay; the *drawing*
additionally requires the cheat-menu `@CUP` debug flag.

### Confidence & open items
HIGH on identity (the gate bit's own DEBUG.TXT label names the function's
subject; three independent consumers agree on the array semantics). MEDIUM on
individual accumulator→good attributions inside the dense Phase-C formulas.

**TBD (exact trace sites):** (1) array freshness for the trade dialogs — no
second call to `func_048F34` exists; confirm the enter-village flow always
passes through `func_056C3E` first (breakpoints 0x48F34 vs 0x4A8F7). (2) the
Phase-A `func_005BFA` relative-arg anomaly @0x048FC0 — confirm in-game.
(3) DGROUP 0x962A per-tribe byte table — name TBD (likely a NAMES `@TRIBES`
column). (4) 0x97C0 good-name string-id table init site TBD (runtime,
likely the `@CARGO` load path). (5) tribe bytes +7/+8 semantic names TBD.
Note: `code/VICEROY/disasm/func_048F34_unknown.asm` is stale (covers 922 of
1740 bytes).

## 5. `func_0452D4` (page 0x0A, file 0x0452D4, 1559 B) — pulldown-menu tracking loop of the in-game map menu bar

**SCREEN:** widget/helper — the **pull-down-menu modal open/navigate/select engine
of the in-game map-screen menu bar** (GAME/VIEW/ORDERS/REPORTS/TRADE/CHEAT/
COLONIZOPEDIA from MENU.TXT). Page 0x0A (file base 0x044400) is the whole
pulldown-menu module; `func_0452D4` is its interaction core.

**Verification status:** 13 load-bearing cites spot-checked 2026-07-30 — all
resolve exactly (`cmp [0xb96],0` @0x024925, `les bx,[0x896]` @0x024951,
`lcall 0x191f,0x472` @0x02495D, entry `enter 0x3c,0` @0x0452D4, save-under
`0x1a1f:0x364` @0x04538C, restore `0x38a` @0x04585F, result write @0x045895,
right-clamp `cmp [bp-8],0x13e` @0x04505F, bottom-clamp `cmp [bp-2],0xc6`
@0x04506E, bar y `mov ax,1` @0x0448AE, node alloc `mov ax,0x22` @0x044BD9,
`[0x896]` writer @0x0720AC, MENU.TXT loader `0x191f:0x928` @0x0720C4).

### Identity evidence
- Sole cross-page caller: `lcall 0x191f,0x472` @0x02495D (thunk file 0x01BA62 →
  page 0x0A off 0x0ED4 = `func_0452D4`; byte-scan found no other far call). Call
  site is in `func_0246E2` (page 0x01, main map input dispatcher):
  `les bx,[0x896]; push es:[bx+0x3A]; push es:[bx+0x38]` @0x024951–0x02495D —
  "open first pulldown of the menubar object at DGROUP `[0x896]`" when the
  Alt-tap flag `[0xB96]` is set (@0x024925/@0x02494C).
- `[0x896]` is created/written only by `func_072090` @0x0720AC (page 0x1A), which
  builds the bar from MENU.TXT: section names `"game"` DGROUP:0x2098 (file
  0x1FA38), `"view"` 0x20A6, `"orders"` 0x20AF, `"reports"` 0x20BA, `"trade"`
  0x20C5, `"cup"` 0x20CB, `"pedia"` 0x20D3, loaded via `0x191F:0x928` (7 sites,
  e.g. @0x0720C4, @0x0728CB) — exactly the `@GAME/@VIEW/@ORDERS/@REPORTS/@TRADE/
  @CUP/@PEDIA` keys in `MENU_sections.json`. 7 add-pulldown calls
  (`0x1A1F:0x31A`→`func_044B7A`, e.g. @0x0720E4) + 91 add-item calls
  (`0x1A1F:0x33E`→`func_044D16`).
- Intra-page callers (via trampoline `call 0x17ED`→`ljmp 0x191f:0x472`
  @0x045BED): `func_0458EC` @0x04597E (mouse-down on bar row opens menu:
  `[0x7EC]` down-edge @0x045901, row test @0x04591F–0x045924, per-title x/x+w
  test @0x04593B–0x045943) and `func_04598A` @0x045A0A (title-hotkey open: key
  via `0x1A1F:0x380`→`func_00D2AC` @0x0459B2, matched against menu field +8
  @0x0459D2). Both called only from `func_0246E2` (`0x191F:0x47E`
  @0x02475D/0x024895, `0x191F:0x496` @0x02481E).

### Structs (offsets byte-cited)
- **Menubar** (`[0x896]`, created `func_044836`): +0 result command id (@0x045895
  write / @0x0458C9 zero), +4 bar y=1 @0x0448AE, +6 title gap=0x0C @0x04489C,
  +8 item leading=3 @0x0448A2, +0xA title x-pad=1 @0x0448B5, +0xE/0x10 bar colors
  ← `[0x149C]/[0x149E]` @0x0448BF, +0x1A/0x1C highlight colors ←
  `[0x14A8]/[0x14AA]` @0x0448F6, +0x20/+0x2C two font descriptors (copied
  @0x0448EA/@0x044947; far strings at +0x28 = title font, +0x34 = item font),
  +0x38 first menu @0x044894.
- **Menu node** (0x22 bytes, alloc @0x044BD9): +2 x = prev menu's (x+width) +
  menubar gap (@0x044BA4–0x044BB7 sum, +gap @0x044BCD–0x044BD1 ⇒ first title
  x = 0x0C), +4 title width, +6 panel inner width (init 0xA @0x044C96), +8 title
  hotkey char @0x044C92, +0xC flags (bit0 disabled @0x04541C), +0xE title string
  @0x044C70, +0x12 owner menubar @0x0452E9, +0x16 next / +0x1A prev menu
  (@0x045440/@0x0456D1), +0x1E first item @0x0453A1.
- **Item node**: +0 flags (bit0 disabled @0x0454ED; bit1 hidden @0x0454D2), +2
  shortcut key @0x045776, +4 command id (returned @0x04588E), +6 label far ptr
  (empty first byte = separator @0x0454F2–0x0454FA), +0xE next / +0x12 prev
  (@0x04551E/@0x0455AD).

### Layout (`func_044FA4`, called @0x045357)
- Panel x = menu.x @0x044FB0; panel y = menubar.y + title-text-height + 3
  @0x044FC5–0x044FE2; width = menu.+6 + 2 @0x045022–0x045027; height =
  n_visible·(item-font-height + leading) + leading + 2 @0x045036–0x045053
  (visible count skips flag-bit1 items @0x045002); first-item y = panel y +
  leading + 1 @0x045085–0x045092; item x = panel x + 1 @0x04507D.
- **Screen clamp**: right edge ≥ 0x13E → shift so right = 0x13D (317)
  @0x04505F–0x04506C; bottom ≥ 0xC6 → shift so bottom = 0xC7 (199)
  @0x04506E–0x04507B (320×200 mode).
- **Bar draw** (`func_044E7C`): full-width fill x=0, y=0, w=0x140 (320),
  h = title-height+bar_y+1 @0x044EB2–0x044EC9; selected title highlight box in
  colors menubar+0x1A/+0x1C @0x044F04–0x044F41; title text at menu.x + pad,
  y = bar y @0x044F44–0x044F6B.
- **Save-under**: rect saved before opening via `0x1A1F:0x364` (ax=0xFFF8,
  descriptor DGROUP:0x2DA8) @0x04538C → `func_078640` (page 0x1F); restored on
  close via `0x1A1F:0x38A` @0x04585F → `func_0786FE`, then blit `0x181F:0xE2`
  @0x045875.

### Interaction loop (`func_0452D4`, retf 4, one far arg = menu node)
- Entry: highlight title @0x045332 (`func_044E7C`, flag 1); layout @0x045357;
  row height = item-font-height + owner.leading @0x045368–0x045375; save-under
  @0x04538C; if `[0x7EE]` (buttons at open) == 0 → keyboard-open: preselect
  first item @0x045394–0x0453AC. Alt state = BIOS 0x40:0x17 & 8
  @0x0452FC–0x04530A.
- Per frame: `0x181F:0x470` begin-frame @0x0453AF, `0x466` (poll/edge
  `func_00D106`) @0x0453B6, yield `0x45C` @0x045835.
- **Mouse** (only if `[0x7F6]` any-button-down @0x0453BB): pointer in bar row
  (@0x0453CA–0x0453E7) → walk bar titles, drag onto a different enabled title
  switches menus (arg replaced @0x045450–0x045459, panel closed/reopened via
  outer loop @0x045880); pointer outside panel rect @0x04546A–0x04548E →
  selection cleared; inside → per-item y hit test @0x0454BA–0x045529 (skips
  hidden/disabled/separator). Release edge `[0x7F4]` @0x045817: with selection →
  commit; without: if opened-by-press and release on bar row → stay open
  (@0x04589A–0x0458C2), else cancel.
- **Keys** (`0x181F:0xF6` kbhit @0x045532, `0x3E0` getch @0x045550; toupper via
  ctype `[bx+0x27ED]&2 → −0x20` @0x04555D–0x045569): '8'/scan 0x148 = up (prev
  via +0x12, skipping flags&3 / separators, wraps @0x04559A–0x045613); '2'/0x150
  = down (+0xE @0x045664–0x0456CA); 0x14B left / 0x14D right = prev/next enabled
  menu with wrap through owner+0x38 (@0x0456CE–0x045716 / @0x04571E–0x04574E);
  Enter 0x0D = accept @0x045750; Esc 0x1B = cancel + clear selection
  @0x045758–0x045765; any other key = item-shortcut scan against item+2
  @0x045768–0x0457B8. Dispatch ladder @0x045571–0x0457D8.
- **Alt-tap release** closes the menu: re-read 0x40:0x17&8 each pass
  @0x04561A–0x045628, exit arm/trigger @0x04562B–0x04563D, @0x04565B.
- Selection-change repaint via `func_0450BA` @0x0457FF–0x04580C. Exit: result =
  selected item's +4 → menubar word 0 @0x04588B–0x045895 (0 if none @0x0458C6);
  `0x47A` reset latches @0x0458CE; un-highlight title @0x0458D3–0x0458E0.

### Reachability
Main map turn loop (page 0x01 tail, @0x024A73–0x024B0F) → `func_0246E2` (only
entry into the menu module; also key 'd'=0x64 swallow @0x0247E2, accelerator scan
`func_045A1E` @0x024838) → `func_0452D4`. Returned command id consumed
@0x024886–0x0248C1 → command executor `func_0235D6` (thunk `0x181F:0xF78`,
switch on id @0x0235E2ff). ORDERS-item enable/disable by unit type:
@0x0217E2–0x02192x (ids 0x301, 0x330, 0x302, 0x304, 0x310, … against UnitRecord
`[bx+0x3144]`).

### Conflict recorded → RULINGS.md 2026-07-30
`docs/MENUS_VICEROY_DECODE.md` §7.1 / tracker row 7 credited **`func_06E3D0`** as
the in-game dropdown engine. The byte-traced open chain
(@0x024951→@0x02495D; @0x02475D/@0x024895→`func_0458EC`→@0x04597E) reaches
`func_0452D4`, not `func_06E3D0` — and the 2026-07-28 dialog-framework ruling
already identifies `func_06E3D0` as part of the @-directive dialog/list-menu
framework. Row 7's "bar draw + per-item x = TBD" blocker is resolved here (bar
draw = `func_044E7C`; per-title x mechanism @0x044BA4–0x044CA0). See the ruling
for the arbitration.

### Confidence & open items
HIGH that it is the pulldown-menu modal tracker; HIGH that its only reachable
instantiation is the main-map menu bar (single construction site `func_072090`,
single open chain `func_0246E2`).

**TBD (exact trace sites):** (1) bar/highlight colors `[0x149C]..[0x14AC]` and
font metrics `[0x14B0]..[0x14B8]` are runtime-filled (partially by the page-0A
init tail @0x045BA6–0x045BD9 from sprite-sheet queries `0x181F:0x254` sprites
6/7; `MENUCOLR.SS` string at file 126556) — writer chain for the 0x149C block
TBD. (2) Absolute per-title x/width pixels depend on font text-width
(`0x181F:0x204` via `func_0445EE` @0x044CB4ff) — need font decode or live trace.
(3) Panel width source: menu+6 init 0xA @0x044C96, presumed max-item-width
update inside add-item `func_044D16` — not yet read. (4) Save-under internals
(mode ax=0xFFF8, pool DGROUP:0x2D28, type const 0x2618) in `func_078640`
@0x078671–0x0786BF.
