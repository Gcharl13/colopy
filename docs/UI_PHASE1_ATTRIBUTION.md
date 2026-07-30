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

**SCREEN:** a full-screen MODAL two-column unit-list/roster panel (user-facing, not
debug). The *concrete* screen name is **TBD at the byte-verified bar** — the title
and every column label are runtime BSS pointers supplied by the caller, so this
function is a **parameterized shared renderer**; identity is caller-determined.
Low/medium-confidence reading of the data it shows (Soldier/Dragoon special-cases,
cargo-slot %) suggests a military muster / unit-comparison style report.

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

## 3. Page-0x16 modal family (`func_0694AE/06A700/06AA88/06AE08/06AF1C`) — TBD (decode in progress)

## 4. `func_048F34` (page 0x0C) — TBD (decode in progress)

## 5. `func_0452D4` (page 0x0A) — TBD (decode in progress)
