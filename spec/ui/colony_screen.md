# Colony Screen

> **Layer 2 — UI Specification.** Per `/METHODOLOGY.md`. Tiers: **B** = byte-cited
> (a `func_XXXXXX @0xNNNNN` file offset, a verified `*.TXT` key, or a recorded ruling);
> **A** = overlay/pixel-measured geometry (no byte literal); **R** = single-frame /
> low-trust approximation or a decompiler stub the EXE keys differently.

**Overall confidence:** the **composer draw ORDER and every panel-paint sub-renderer are
byte-transcribed** from the colony composer `func_028592 @0x028592` (tier **B** — the 12 ordered
calls and each sub-renderer's background-fill rect were re-read PUSH-for-PUSH); the active-colony
pointer, building-slot table, stockpile bar, and flag/minimap/SoL panel rects are
**raw-EXE-verified** (**B**). The **colonist-row per-unit pitch** (adaptive fit-to-96px pack,
`func_0270D0 @0x02710A..0x027173`, §8.2) and the **SoL/cargo/msg panel's mode text source** (3-way
`[0x337]` dispatch → `func_0275CE`/`func_027746`/`func_027BB6`, all byte-decoded, §8.3) are now
**B-resolved**. The one remaining genuinely-runtime soft spot is the **title paint origin** — `func_00275C`
byte-reads x=`[0x2CC6]`/y=`[0x2CC8]` and the context init seeds no literal, so it needs a runtime trace
(§8.1); the **work-grid vs 6-slot surrounding scene** discrepancy is reconciled to the byte-cited scene
loop in §6 item 6 (the 3×3 grid was low-trust C-recon, superseded). · **Canonical primary:**
`viceroy_source/docs/drawlist/EUROPE_COLONY.md` PART 2
(composer + sub-renderers), `viceroy_source/docs/SCREEN_LAYOUTS.md` §3, `docs/COLONY_RENDER_CHAIN.md`
(entry chain + data globals), `raw/COLONIZE/VICEROY.EXE`.

> **Provenance note (2026-06-22):** earlier revisions cited `docs/RENDERER_GEOMETRY.md` and
> `ghidra_export/VICEROY_decompiled.named.c` line numbers as primary. Those geometry docs were
> removed in cleanup and are **not** cited here; the byte-true source for every rect below is the
> drawlist's `@0xNNNNN` PUSH transcription and SCREEN_LAYOUTS' `[V]` table. Where a prior claim came
> only from the low-trust C reconstruction (e.g. the "3×3 work grid" cell formula), it is now tagged
> **R** and reconciled against the drawlist in §6.

## 0. AS-BUILT LAB BASELINE (2026-06-27) — cross-checked vs RAM dump + NAMES

This section is the **frozen starting point** for the lab's colony render (`lab/js/sim/screens.js`
`SCREENS.colony`). It is the authoritative description of *what the lab draws today* and *how each
element was verified*. Do not regress past the mistakes listed at the end. Everything below was
**re-cross-checked this date** against three independent sources:

- **Live screenshot** `docs/screens/colony_live_1505.png` (native 320×200, the founded "Jamestown").
- **RAM dump** `scratchpad/dbx/colony_live_1505.bin` (regenerable; DGROUP base **0x61ffd0**, located
  via the `UNIT\0ORDERS\0ACTIONS\0` signature − 0x2258; `*(0x8542)` = **0x606e**, confirming
  ColonyRecord base 0x5D46 + 4·0xCA, table index 4).
- **Original game data** `data_extracted/text/NAMES_sections.json` `@BUILDING`.

### 0.1 Colony state read from the RAM dump (ground truth for this capture)
| Datum | RAM source | Value | Matches render? |
|-------|-----------|-------|-----------------|
| Colony name | record `+2` (DGROUP 0x6070) | `"Jamestown"` | ✓ title text |
| Map cx,cy | record `+0`,`+1` | 46, 41 | (not drawn) |
| Population | record `+0x1F` | **1** | ✓ (fresh 1-colonist colony) |
| Stockpile (16×u16) | record `+0x9A` | **all 0** | ✓ all 16 qty = "0" |
| Gold (treasury) | global `[0x8832]` | **1000** | ✓ title "Gold: 1000" |
| Plot def_ids | `byte[0x8E82+i]`, i=0..14 | `[255,255,32,27,39,24,21,255,255,255,35,255,9,0,255]` (255 = empty) | ✓ frames below |
| Plot categories | `byte[0x8D62+i]` | `[0,0,0,0,0,0,0,1,1,1,1,2,2,3,4]` | ✓ empty-plot frames |
| Empty-plot terrain table | `DS:0x260[cat]` | `[45,44,43,0,46,0,56,0]` | ✓ (`−1` ⇒ frame) |

### 0.2 Building plots — positions + def_ids RAM-verified; per-plot frames pixel-matched
15 plots, positions from the `DS:0x266` table (stride-4: x@`+0`, y@`+2`, drawn at **y+8**), painter
`func_02701C`. **What is verified vs what is empirical:**
- **B (RAM-verified):** the **positions**, the **def_id per plot** (`byte[0x8E82+i]`), the **category
  per plot** (`byte[0x8D62+i]`), the **empty/occupied gate** (`def_id==255` ⇒ empty), and the
  **empty-plot frame = `DS:0x260[category] − 1`** (also byte-cited at §3.7 item 5, empty-plot painter
  `func_026FF2`).
- **Empirical (B vs the *image*, not a proven formula):** for each **occupied** plot the lab draws
  **BUILDING bundle frame = def_id** (special case **def_id 0 → frame 16**), which is **MSE-0** vs the
  live capture. This reproduces the pixels but is **NOT** the EXE's general frame formula.
- **RESOLVED 2026-06-27 (reseg, was R/TBD):** the building-frame selector is **`func_026DD4 @0x026DD4`**
  (NOT `func_026CC2` — that path computes the production/garrison strip). The frame is `[bp-0x58]`,
  set to **`def_id + 1`** in EXE-sheet space `@0x026DE5..0x026DE9`, with byte-read special cases:
  `def_id==0` & build-query0==0 ⇒ `0x11` (`@0x026DEC`); `def_id==0xF`/`0x11` garrison ⇒ `0x2F`/`0x30`
  (`@0x026E05`). The building blit is `0x181F:0x254 @0x026E4E`. The lab's "frame = def_id" works because
  the bundle `.SS` decoder is the **same off-by-one** as the stockpile (bundle`[def_id]` = EXE`[def_id+1]`),
  and def_id-0→16 is the `def_id==0` special branch. So `def_id+1` (EXE) IS the static rule — **no runtime
  AX trace is needed** (live-verified against the Jamestown capture, plots 2/12/13). See §3.7 item 5 / §8.5.

| Plot | x,y(+8) | def_id (RAM) | cat | Frame drawn | NAMES `@BUILDING` |
|------|---------|--------------|-----|-------------|-------------------|
| 0 | 56,13 | 255 (empty) | 0 | 44 (=45−1) | — |
| 1 | 145,15 | 255 (empty) | 0 | 44 | — |
| 2 | 173,18 | 32 | 0 | 32 | Fur Trader's House |
| 3 | 8,41 | 27 | 0 | 27 | Rum Distiller's House |
| 4 | 37,45 | 39 | 0 | 39 | Blacksmith's House |
| 5 | 67,54 | 24 | 0 | 24 | Tobacconist's House |
| 6 | 96,53 | 21 | 0 | 21 | Weaver's House |
| 7 | 6,14 | 255 (empty) | 1 | 43 (=44−1) | — |
| 8 | 128,53 | 255 (empty) | 1 | 43 | — |
| 9 | 10,76 | 255 (empty) | 1 | 43 | — |
| 10 | 15,102 | **35** | 1 | **35** | **Carpenter's Shop** |
| 11 | 87,11 | 255 (empty) | 2 | 42 (=43−1) | — |
| 12 | 66,87 | 9 | 2 | 9 | Town Hall |
| 13 | 123,106 | 0 | 3 | **16** (def_id 0→16) | Stockade |
| 14 | 123,55 | 255 (empty) | 4 | 45 (=46−1) | — |

All 15 plots' **def_ids and positions** match the RAM dump; the **drawn frames** match the live
capture pixel-for-pixel (MSE-0). The prior "type+1" framing in §4/§5/§8.5 is superseded (the EXE
default is `def_id+1` in EXE-sheet space, not `category+1`); the **general** frame formula is now
**RESOLVED (B)** — `func_026DD4 @0x026E4E` blits `0x181F:0x254` with frame `[bp-0x58]=def_id+1`
(special cases at `@0x026DEC`/`@0x026E05`), a static rule needing no runtime trace (§3.7 item 5, §8.5).

### 0.3 Stockpile bar (bottom strip)
16 cells, icon row **y=181**, good order **Food, Sugar, Tobacco, Cotton, Furs, Lumber, Ore, Silver,
Horses, Rum, Cigars, Cloth, Coats, Trade Goods, Tools, Muskets** (Food **FIRST**). The lab indexes
the icon as **ssdec frame `0x16 + good`** (ICONS 22=Food … 37=Muskets). The EXE literal is
`good+0x17` (`add ax,0x17`); the lab's `.SS` decoder is **off-by-one** (`ssdec[K] = game[K+1]`), so
`0x16 + good` in lab space == `0x17 + good` in EXE space — **the same icon**. Applying `0x17` to the
lab/ssdec frames re-introduces the "starts with Sugar" bug (see §0.6). Per-cell qty centered under
each cell, dark navy `#181c7d`; all 16 = "0" this capture (RAM stockpile all-zero).

### 0.4 Carpenter's shop, working colonist, hammer-production overlay
Plot 10 (def_id 35) is the **Carpenter's Shop** (NAMES-confirmed). The lab draws, in the element
layer **on top of** the building plots: the **working colonist** (ICONS frame **81** @ (42,111),
MSE-0 vs capture) inside a **green selection box** (`#55ff55`, bbox x39..50 y112..127), and the
**hammer-production overlay** = the hammer commodity icon (ICONS frame **54**) blitted ×3 in a row
under the shop roof at **x={15,21,27} y103** (pitch 6, best-fit vs capture). NOTE: the tool the
colonist *holds* is part of his sprite — the **three hammers under the roof** are the production
indicator. The **count 3** is what this capture shows; the building-strip count is **live per-turn
production state** rendered by `func_026DD4`'s strip blit `0x181F:0x236 @0x026EF7` (count carried in
`dx=[bp-4]` from the building-production query `0x181F:0xACE`/`0xBAA`). The *value* (3) is computed by
the colony economy sim in overlay `0x191F` (not yet extracted); the **render path is byte-cited (B)**,
the **count-derivation formula is RESOLVED 2026-06-27** — it is **NOT** in overlay `0x191F`: the field-production counts `[0xA891]`/`[0xA893]`/`[0xA894]` are written by the **resident** `func_00A222 @0x00A222` (`compute_colony_center_yields`, called from the turn-update path `func_038F2C @0x0390B4` / `func_053B7E`). It reads the colony-center terrain band via `lcall 0x3e4:0x3a @0x00A23C` → base food `[0xA891]`=0/1/2/3 (`@0x00A24C..0x00A290`), then adds difficulty `[0x53A6]` (`@0x00A29C`/`@0x00A2A8`), resource/river flags (`lcall 0x37f:0x142`/`0x4b0`/`0x10e`), and ColonyRecord `+0x1c` bit-flags (`@0x00A32F`/`@0x00A339`); the row-2 good `[0xA893]`+count `[0xA894]` are picked by the `@0x00A34D..0x00A3D1` loop. **B (writer-traced + snapshot-confirmed `[0xA891]=4`).** The per-turn building-strip *hammer* count (`dx=[bp-4]` at the `0x181F:0x236 @0x026EF7` strip blit) is separately a runtime building-production value returned by the near helper `0x2ca46 @0x026EB3` over the overlay build-queries `0x181F:0xACE`/`0xBAA` — genuine per-turn state, render path byte-cited.

### 0.5 Text + band/SoL overlays (matched to the capture; underlying counts runtime-derived)
- Title `"Jamestown.  Spring, 1505.  Gold: 1000"` (green FONTTINY, x90 y1). Name/gold RAM-verified;
  "Spring, 1505" is the displayed string (season from `@SEASONS`, year derived from the turn
  counter — exact formula not re-decoded here, value matches the capture).
- `"100% (1)"` SoL line (x75 y133, white) — a **digit 1** in parens, NOT a letter I.
- `"No Ships In Port"` (x118 y130). The white string at **(306,179)** is the warehouse-bar caption
  **"Sons of Liberty"** — byte-proven: `func_0281D6 @0x0283F1` blits heap string `[0x2F5E]=0x219`
  (oracle-resolved 2026-06-27, §4 line 439), **not** an "Exit" label (the earlier "Exit" gloss here
  was unverified).
- Band/SoL panel sprites (2 colonists, 4 corn, cross, liberty bell, SoL crown, 2 warehouse-top
  goods, the **Lumber(27)+Hammers(54) build-shortage** goods with **red ✗ (ICONS 55)** over each,
  3 tool buttons): every sprite frame/position is **MSE-matched to the capture (B vs the image)**.
  The field-production "**4 corn**" count is now **render-source-cited (B):** `func_0264A8 @0x026652`
  reads row-1 count from **global `[0xA891]`** (snapshot `colony_live_1505.bin` reads `[0xA891]=4`,
  matching the rendered 4) and blits the proportional strip via `0x181F:0x236 @0x02665D` with food icon
  `0x17`; row-2 good=`[0xA893]` (=1), count=`[0xA894]` (=2), blit `@0x02668A`. So the **count is live
  state read from `[0xA891]`/`[0xA894]`**, rendered by `func_0264A8` via the `0x181F:0x236` proportional
  strip — per-game economy state, not a static constant. The *formula* that fills `[0xA891]` lives in
  overlay `0x191F` (not yet extracted); the **render source + globals are byte-cited (B)**, the
  fill-formula is RESOLVED (2026-06-27): the values `[0xA891]`/`[0xA893]`/`[0xA894]` are written by the
  **resident** `func_00A222 @0x00A222` (`compute_colony_center_yields`), **not** by an un-extracted
  overlay-`0x191F` routine. It derives the center-tile food band (`[0xA891]`=0..3, `@0x00A24C..0x00A290`)
  from the colony-cell terrain (`lcall 0x3e4:0x3a`), then adds difficulty `[0x53A6]`, resource/river
  flags, and ColonyRecord `+0x1c` bits; row-2 good/count come from the `@0x00A34D..0x00A3D1` loop. Called
  each turn from `func_038F2C @0x0390B4` / `func_053B7E`. **B (writer-traced + snapshot-confirmed).**

### 0.6 DO NOT REGRESS (burned before — keep these fixed)
1. Stockpile starts with **Food**, not Sugar. Lab icon = ssdec **0x16**+good (not 0x17). 
2. Palette is **VICEROY.PAL stride-3 RGB** (not stride-4); COLONY.PIK sky is **blue** (106,139,196),
   not yellow.
3. The carpenter shortage good is **Hammers (ICONS 54)**, not Tools (ICONS 36).
4. SoL reads **"(1)"** (digit), not "(I)".
5. `TERRAIN.SS` is the **base ground sheet** (loaded at boot + map-enter), **not** an orphan.
6. The colony screen is **NOT "COMPLETE"**: building *placement* is RNG-driven (`func_025D34`), and the
   minimap window/scale + work-tile markers (`func_026374`/`func_027DB2`) still need a runtime origin
   trace. The **field-production count formula is now resolved** (resident `func_00A222 @0x00A222`,
   writer of `[0xA891]`/`[0xA893]`/`[0xA894]`, §0.5/§3.2). The **SoL% formula is now RESOLVED (B,
   2026-06-27, reseg + writer-trace):** it is NOT in an un-extracted overlay — the percent is computed by the
   resident **`func_008524 @0x008524`** (= thunk `0x181F:0xC86`, role "SoL%/rebel-sentiment compute"):
   `SoL% = (colony+0xC2·100)/colony+0xC6` (32-bit, mul `0xd1d:0xf60 @0x008557` + div `0xd1d:0xec6 @0x00855E`;
   0 if denom≤0 `@0x008542`), then **+20 human latch** (`add ax,0x14 @0x00859F`, gated `colony+0x1A<4` &
   `[bx+0x543f]==0` & flag `0x981:0(0x12)`), **clamp 100** (`cmp ax,0x64;mov ax,0x64 @0x0085A8..0x0085AD`).
   The bell-pool source fields are written each turn by the **resident-overlay `func_02D658 @0x02D658`**
   (page_03): numerator `+0xC2` accumulated and clamped to cap `+0xC6` (`@0x02DAC6..0x02DAD4`), cap
   `+0xC6` rebuilt = decay + population·2 (`@0x02DA1C..0x02DA6F`); founding init `+0xC6=100`,`+0xC2=0`
   (`@0x02EC26`). The display (SoL% + member count + tory text-colour) is at page_02 `@0x0273DC` (§8 item 4).
   This baseline is recognizable + RAM-cross-checked, not finished.

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

> **RUNTIME-CONFIRMED 2026-06-26** (founded "Jamestown" live; snapshot via `tools/runtime_snapshot.py`;
> screen `docs/screens/11_colony_screen.png`). Live DGROUP seg `0x1CFD`: `*(0x8542)` = `0x606e`, and
> `0x606e = 0x5D46 + 4·0xCA` **exactly** — confirming the ColonyRecord base `0x5D46` + stride `0xCA`
> (this colony is table index 4). The record at `0x606e` decodes `+0`=cx=`0x2e`(46), `+1`=cy=`0x29`(41),
> and **`+2` = the colony name** "Jamestown\0". Validates CLAUDE.md hard rule 8 and the `+0/+1` field map.
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
**Field assembly RESOLVED 2026-06-26** (full body re-disassembled `@0x0268CE..0x026AB0`;
verified against the live "Jamestown. Spring, 1504. Gold: 1000e" snapshot `colony_jamestown.bin`).
The top guard selects the branch: `mov bx,[0x8542]; cmp [bx+0x1a],4` (owner<4 = European),
`imul bx,owner,0x34; cmp [bx+0x543f],ah` — on the own/normal-colony case (`==0`) it `jmp 0x269f8`,
the **name+date+gold** assembler (the `0x26902` branch is the *foreign/owner-descriptor* case). The
`0x269f8` branch appends, in order, into `[bp-0x50]`:
1. **Colony name** `@0x269F8`: `mov ax,[0x8542]; inc ax; inc ax` (⇒ **ColonyRecord+0x2**) → `lcall
   0xd1d:0x7e4` (string copy). **B + oracle:** `*(0x8542)=0x606e`, bytes at `+0x2`=`Jamestown\0`.
2. separator `@0x26A0E` `0x181F:0x1dc`.
3. **Season** `@0x26A22`: `bx=[0x538C]; shl bx,1; push word[bx-0x6800]` → `0x181F:0x16E` (append
   string-from-table). **B + oracle:** `[0x538C]=0` ⇒ `@SEASONS` index 0 = `Spring`.
4. separator `@0x26A3C` `0x181F:0x1b4`.
5. **Year** `@0x26A44`: `push word[0x538A]` → `0x181F:0x182` (append decimal). **B + oracle:**
   `[0x538A]=1504`.
6. separator `@0x26A55` `0x181F:0x1dc`.
7. **Gold** `@0x26A61`: `push word[0x93A0]` (a sequential format/msg id, oracle `=0x231`) →
   `0x181F:0x22` (getter `0:0x62`) returns the value in `dx:ax` → `lcall 0xd1d:0x11b4` (money
   formatter, which supplies the `Gold:` label `@CTITLE`[1] + the `e`/currency suffix). **B chain;
   the rendered NUMBER is oracle-confirmed = PowerRecord+0x2a (treasury):** `[0x84FC]`=PowerRecord
   `0x8808`, `PowerRecord+0x2a=1000` (matches `1000e`), while `PowerRecord+0x2=7181` does **not**
   match — so the title gold is the **treasury at `PowerRecord+0x2A`**, same field as the menu-bar
   gold. The `0:0x62` id→field internal byte-trace is the one un-pinned link (see §8). Owner
   descriptor/colour is merged from `colony+0x1A` via `0x181F:0xB1E` `@0x026A96` before the paint.
**All five fields (name/season/year/gold + owner colour) and their sources are now B (oracle-
confirmed for name+season+year+gold); only the inter-field punctuation glyphs from the `0x1dc`/
`0x1b4` separator helpers and the paint origin (§8.1) remain unliteralized.** Full breakdown:
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
  (`dec [bp-0x60] @0x027178`), y = `0x0A` (10). Per-colonist sprite from the far-ptr table
  `[0x83E]:[0x840]`, **stride 12**: `+0x3E` = sprite width, `+0x40` = x/anchor.
- **Per-colonist pitch — RESOLVED 2026-06-26 (code-derived + snapshot-confirmed; was open).**
  It is an **adaptive fit-to-span pack**, not a fixed pitch:
  1. **Pass 1** (`@0x02710A..0x027141`) sums every colonist's sprite width into `[bp-0x7E]`
     (`total_width`), looping `count = colony+0x1F + [0x8D72]` times (live: 1+1 = 2).
  2. **Gap solve** (`@0x027160..0x027173`): `gap = [0xA890]` (init **2**); while
     `gap·(count−1) + [bp-0x5A](=4, or 0 if [0x8D72]==0) + total_width ≥ 0x60 (96)`, **decrement
     the gap** (`@0x02715C`) and retry — i.e. the inter-colonist gap shrinks from 2 down until the
     row fits the **96-px budget**.
  3. **Pass 2** (`@0x027186..`): draws each colonist (sprite blit `0x181F:0xCE`) at the running
     x `[bp-0x60]` (from 143, advanced left by `sprite_width + gap` per colonist), y = 10.
  So **pitch = per-colonist `sprite_width(+0x3E)` + adaptive `gap` (2→0, fit-to-96px)**. The
  width table `[0x83E]` (stride 12) and `[0xA890]=2` are oracle-confirmed in `colony_jamestown.bin`
  (a real colonist row carries `+0x3E`=15 width). **B.** (Per-colonist *index* comes from the
  colony enumerator `0x181F:0xA74`.)
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
- **Sub-renderer locations RESOLVED 2026-06-26, CORRECTED 2026-06-26** (thunk chain): the three
  `call 0x2C9B0/0x2CA50/0x2CAA0` are RTLink near-stubs `ljmp 0x191F:0x558/0x6D8/0x798`. Resolved with
  the correct RTLink formula `file = code_offset + (ljmp_seg<<4) + jmpf_off`
  (`tools/follow_thunk.py`; `typeA_thunk_targets.json` `_doc`/`formula`) → **file `0x0275CE` (case 0
  = SoL/garrison bar) / `0x027746` (case 1 = cargo) / `0x027BB6` (case 2 = message)**. The earlier
  `0x268BE/0x26A36/0x26EA6` figures were **wrong** — they came from the naive `0x024BF0 + IP` that
  omitted the `(ljmp_seg<<4)` term, and `0x26A36` actually lands inside the title-builder body, not
  the cargo panel. **B** (thunk-resolved). Behaviours read this pass: case 0 `0x0275CE` paints the
  SoL/garrison **icon-bar** rows (table `[bx−0x7238]` via `0x181F:0x222`) — **no @MISC string fetch**;
  case 1 `0x027746` reads cargo holds `colony+0x94` (`0x181F:0xAC4/0xD4E`) and, when `[0xB98]==0`,
  draws a centered caption from **string-index `[0x939A]`** via `0x181F:0x22`+`0x100`.
- **@MISC index → string mechanism RESOLVED + ORACLE-CONFIRMED 2026-06-26.** The panel/minimap
  captions resolve a **global string index** through **`0x181F:0x22` = `func_002462 @0x002462`**: it
  loads the string-heap far ptr from **`[0x2D42:0x2D44]`**, then walks N NUL-terminated strings
  (`repne scasb`, `dec dx` per string, arg N = `[bp+6]`) and returns the far ptr to string #N.
  **B** (`func_002462_find_char_in_buffer.asm`; `follow_thunk 0x181f 0x22`).
  - **"No Ships In Port" = global string index `0x153` (339) = `LABELS @MISC` local index `11`**,
    living at **DGROUP `0x2FF1A`**. **ORACLE-CONFIRMED:** live heap base `[0x2D42:0x2D44]` = `0x4C05:0`
    (phys `0x4C050`); walking exactly `0x153` strings from there lands on file `0x4CEEA` = DGROUP
    `0x2FF1A` = `"No Ships In Port"`. The `@MISC` global-index table at DGROUP **`0x2DC0`** holds the
    contiguous ids (`0x2DC0`=`0x14A`=`@MISC[2]`, so `@MISC[N]` global = `0x148+N`); slot **`[0x2DD2]`**
    = `0x153` = "No Ships In Port" (`[0x2DD0]` = `0x152` = "Bound For"). **B (index→string, oracle-verified).**
  - **Which renderer pushed `0x153` at render = BLOCKED (honest).** On the live screen
    (`docs/screens/11_colony_screen.png`, same frame: Jamestown/Spring/1504) "No Ships In Port"
    appears in the **minimap rect (121,130,84,48)** (`func_027DB2`, `[0x33C]==0` caption path), whose
    text push is the **static-looking `push word[0x2DD0]`**. But the oracle reads `[0x2DD0]=0x152`
    ("Bound For"), **not** `0x153` — and the `0x2DC0` table is **runtime-built** (the `0x14A,0x14B,…`
    pattern is absent from `VICEROY.EXE`, so these slots are scratch and can be rewritten after a
    paint). So the snapshot value contradicts the rendered output and I **cannot** snapshot-confirm
    that `[0x2DD0]` held `0x153` when `func_027DB2` ran. Per the prime directive the exact
    renderer→slot binding stays **BLOCKED**; the string identity + lookup mechanism above are
    confirmed, the render-time index push is not.

### 3.7 Buildings loop — `func_02701C @0x02701C`
- Scene backdrop: `0x181F:0xCE` glyph-row `(0xC7,7,…) @0x02703F`; `0x181F:0x4FC` strip blit
  `(7,0x78,0xC7,8,0) @0x02705F`. **B**
- **15-slot loop** `@0x027067..0x0270B1` (`cmp 0xF @0x02707B`): per slot, **position** from
  `bx = slot·4` → **x = `[bx+0x266]`**, **y = `[bx+0x268] + 8`** `@0x027087/0x02708B`; then
  `bx = slot` (stride 1) → **category = `[bx−0x729E]`** (= `[bx+0x8D62]`), **present-gate =
  `[bx−0x717E]`** (= `[bx+0x8E82]`), **skip if `<0`** (`0xFF` = empty plot). Blit `call 0x2CA23`
  with (category, y, x, building-def-id). **B**

- **§12 placement algorithm — FULLY TRACED + SNAPSHOT-VERIFIED 2026-06-26** (`func_025D34`
  `@0x025D34..0x025EAF`; verified against the live "Jamestown" colony, `colony_jamestown.bin`):
  1. **RNG seed** per colony: `lcall 0x181F:0xD62` `@0x025D3A`.
  2. **Category-per-plot table `0x8D62`** built from counts `0x224=[7,4,2,1,1]` + starts
     `0x22A=[0,7,11,13,14]`: `0x8D62[p]` = the category of plot `p` = **`[0,0,0,0,0,0,0,1,1,1,1,2,2,3,4]`**
     (deterministic — recomputed each open, not random). `@0x025D7B..0x025DB8`.
  3. **Within-category random shuffle** `@0x025DBF..0x025E07`: for each slot, `plot =
     random_int(0,count[cat]-1) + start[cat]` (`lcall 0x181F:0x4D4`), retry if occupied →
     plot→building-slot map at **`0x8E92`** (`[bx−0x716E]`).
  4. **42 building-defs** (stride-12 records based at `0x8F88`/`[bx−0x7078]`) each mapped to a
     category-slot `@0x025E0E..0x025E5A`; then for every building the colony actually HAS
     (`lcall 0x181F:0x9FC` query `@0x025E64`), the **present-gate `0x8E82[plot]` = building-def
     id** is written `@0x025E9F`, else stays `0xFF`.
  5. **Frame — RESOLVED 2026-06-27 (reseg of `func_026DD4 @0x026DD4..0x026FF1`).** The earlier
     `func_026CC2`/`word[id*2 − 0x7238]` claim was **wrong**: that path computes the *production/garrison
     strip* (blit `0x181F:0x236 @0x026EF7`), **not** the building sprite. The building-sprite blit is
     **`0x181F:0x254 @0x026E4E`**, frame = local `[bp-0x58]` set at **`@0x026DE5..0x026DE9` to
     `def_id + 1`** (`mov ax,[bp+6]; inc ax; mov [bp-0x58],ax`, EXE-sheet space). Special cases, all
     byte-read: **(a)** `def_id==0` AND build-query `0x181F:0x9FC(0)==0` (`@0x026DEC..0x026E00`) ⇒ frame
     `0x11`; **(b)** `def_id==0xF`/`0x11` with garrison queries (`@0x026E05..0x026E34`) ⇒ frame
     `0x2F`/`0x30`. Otherwise **frame = def_id+1** (EXE) = **def_id** in the lab's off-by-one bundle.
     **Live-verified** (Jamestown): plot 2 `0x20`→0x21/bundle 32 ✓, plot 12 `0x09`→0x0A/bundle 9 ✓,
     plot 13 `0x00`→`0x11`/bundle 16 ✓ (the `def_id==0` special case). So **`def_id+1` IS the frame**
     (EXE-sheet), reducible to a static rule — no runtime AX trace needed. **B (reseg + live-verified).**
     - **Empty plots** (`def_id < 0`): the painter is `func_026FF2 @0x26FF2` (thunk `0x2CA1`→`0x191F:0x834`),
       which draws a terrain decoration = **BUILDING.SS frame `[0x260 + category]`** (category =
       `byte[0x8D62+plot]`, 0..4), **skipped when the table byte is 0**. Snapshot table
       `DS:0x260 = [45,44,43,0,46,0]` ⇒ categories 0/1/2/4 → frames 45/44/43/46, category 3 → none. **B**
       (byte-verified + snapshot-read). Both painters blit at `(plotX, plotY+8)`.
  - **Live verification (Jamestown, snapshot):** `0x8E82` (stride-1) = 8 buildings at plots
    `{2,3,4,5,6,10,12,13}` with def-ids `{0x20,0x1B,0x27,0x18,0x15,0x23,0x09,0x00}` — matches the
    traced structure exactly. (An earlier naive *stride-4* read of `0x8E82` falsely reported "13
    buildings"; the snapshot is what caught it — the consumer loop reads stride-1 by plot.)
  - **What is genuinely non-static (by design):** *which* plot a given building lands in depends
    on the per-colony RNG seed + shuffle order, so the exact plot→building map varies per colony
    and cannot be a fixed table — but the **mechanism, the table semantics, the building set, and
    the frame-lookup path are all resolved**. **B (positions + algorithm + frame path) / per-colony
    shuffle output = RNG (replayable from the seed, verified against live state).**

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
| Title strip ("menu bar above") | origin **R** (DOS-centered, y≈5) | name + season + year + gold (all **B**-resolved §3.1; only the inter-field separator glyph `0xd1d:0x7a4(0x58/0x52)` is unliteralized) | FONTTINY¹ | nation/screen-latched¹ | `func_0268CE @0x0268CE` (paint `0x181F:0xB0` @0x026AA6) | B chain |
| Field-production panel | (224,32,72,72) | commodity icons ICONS `good+0x17` | FONTTINY | per-icon | `func_0264A8 @0x0264E9` | B |
| Colonist plaza row | (0,130,120,48) | colonist sprites; **x-origin 143, walks left**; pitch = `sprite_width(+0x3E)` + adaptive `gap` (`[0xA890]`=2→0, fit-to-96px) | — | — | `func_0270D0 @0x0270D6` (pitch @0x027160) | B |
| Flag panel | (303,132,17,45) | **ICONS sprite 0x44 (68)** at +3, frame=`[0x337]`/`[0x339]` | — | — | `func_02853C @0x028540` | B |
| Surrounding-tile minimap | (121,130,84,48) | **6× ICONS sprite 0x7B (123)** tiles (or centered caption if `[0x33C]==0`) | — | per-tile | `func_027DB2 @0x027DB7` | B |
| SoL / cargo / msg panel | (211,130,91,48) | mode-switch on `[0x337]`: 0=SoL/garrison icon bar (`func_0275CE`, no string), 1=cargo+caption `[0x939A]` (`func_027746`), 2=cargo+caption+hammer strip (`func_027BB6`) | FONTTINY | — | `func_02814C @0x02814F` (cases @0x0275CE/0x027746/0x027BB6) | B |
| Buildings (15 slots) | `DS:0x266` table (stride-4: x@`+0`, y@`+2`, drawn y+8) | **BUILDING.SS** frame (`func_026DD4 @0x026E4E` blit, reseg 2026-06-27): occupied ⇒ **`def_id+1` EXE-sheet** (`=def_id` in lab bundle), special: `def_id 0`+query0==0→`0x11`(bundle 16), `def_id 0xF`/`0x11`→`0x2F`/`0x30`; empty (`byte[0x8E82+i]==255`) ⇒ `DS:0x260[byte[0x8D62+i]]−1` | — | — | `func_02701C @0x02701C` → `func_026DD4 @0x026DD4` | B |
| Terrain scene tiles | x=col−[0x9CCC]+252, y=row−[0x9CCA]+9 | sheet `[0x2DA8]`, blit `0x181F:0x290` | — | per-tile | `func_026374 @0x066968` | B |
| Scene units | x=cell·24+252, y=cell·24+60 | sheet `[0x839E]` via `func_0060A0` | — | — | `func_026374 @0x0263E5` | B |
| Stockpile strip | (0,179,320,21); 16 cells, pitch 19, icon-Y 181 | ICONS `good+0x17` (23..38); qty | FONTTINY | qty white `0x0F`, **red `0x0C` when over warehouse cap** (`0x181F:0xD3A`) | `func_0281D6 @0x0281DB` | B |
| Warehouse-bar right readout | (306,179) | heap **string #`[0x2F5E]` = `0x219` (537) = "Sons of Liberty"** (oracle-resolved 2026-06-27; **NOT gold**) | FONTTINY | white `0x0F` | `@0x0283F1` (`push 0xf,0xb3,0x132,[0x2f5e]→0x181F:0x22`) | B |
| **Gold (treasury)** | **rendered as part of the TITLE** (§3.1 field 7), not a separate colony-composer blit | `PowerRecord+0x2A` via `[0x84FC]`, formatted into title buffer by `0xd1d:0x11b4` `@0x026A61` | FONTTINY (title) | green title latch | title `func_0268CE @0x026A61` (paint `0x181F:0xB0 @0x026AA6`) | B |
| Panel outlines | each panel (single colour) | 1-px frame | — | — | `0x181F:0xE2` | B |
| Screen-bottom rule | (0,200,320) | 1-px rule | — | — | `func_028592 @0x028607` | B |

¹ Title font/colour: the EXE emits the green UI colour `(0x52,0x8A,0x31)` via the screen-latched
handle (the same latch the map-view title strip uses); the per-blit handle is **not** a per-draw
push, so title-as-rendered is **A**, and a prior pixel capture read it as yellow (218,178,0) — a
noted discrepancy (`fonts_and_colors.md`). The title **paint origin** is **RUNTIME**: `func_00275C`
byte-reads x=`[0x2CC6]`/y=`[0x2CC8]` (`@0x00278F`/`@0x002782`) and the context init `func_00BC06` sets
no literal for them, so the live origin needs a runtime trace (§8 item 1).

> **Stripped fabrications (do NOT render these — they are not in `func_028592`):** two-tone HI/LO
> bevel edges on any panel; a (0,130,130,25) "field panel" with "Bells:"/"Food:" readouts (the
> (0,130,120,48) region is the colonist row, and the real field panel is at (224,32,72,72)); plaza
> grass bands at (0,155,…)/(0,171,…); a colonist row at x=8 walking right (it is x=143 walking left);
> a fixed 5-column buildings grid (positions come from table `0x266`). All per drawlist "PORT FIXES /
> COLONY". **B**

## 5. Assets & text
- **Sheets:** **BUILDING.SS** (buildings, frame per §0.2 RAM-verified rule), **ICONS.SS** (`[0x83E]`: commodity 0x17..0x26,
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
- **"No Ships In Port" text source RESOLVED (index) 2026-06-26:** it is **`LABELS @MISC` local index
  11 = global string index `0x153`**, resolved at runtime by the by-index resolver `0x181F:0x22`
  (`func_002462`) over the heap at `[0x2D42:0x2D44]`, landing on **DGROUP `0x2FF1A`** —
  **oracle-confirmed** against `colony_jamestown.bin` (§3.6). The colony screen renders it in the
  **minimap rect** via `func_027DB2`'s `[0x33C]==0` caption path; the exact render-time index slot is
  BLOCKED (snapshot `[0x2DD0]`=0x152 ≠ rendered 0x153, §3.6).
- **"Sons of Liberty" IS colony-rendered — RESOLVED 2026-06-27.** The warehouse-bar right readout at
  (306,179) (`func_0281D6 @0x0283F1`, `push 0xf,0xb3,0x132,[0x2f5e]→0x181F:0x22`) draws **heap string
  index `[0x2F5E]` = `0x219` (537) = "Sons of Liberty"** — oracle-confirmed by walking exactly `0x219`
  NUL-terminated strings from the live heap base `[0x2D42:0x2D44]` in `colony_live_1505.bin` (both
  snapshots read `[0x2F5E]=0x219`). So the SoL caption label IS on the colony screen — as the warehouse
  strip's right caption — even though the SoL-*mode* (case 0) panel itself paints an **icon bar**, not
  a labelled string (§3.6). **B (index→string, oracle-verified).**

## 6. Interactions
- Click own colony tile → this screen (entry chain §1). **B**
- The bottom stockpile strip mirrors Europe's market bar layout but shows warehouse **quantities**;
  on the colony screen it is the per-page twin `func_0281D6` (not the trade interface). **B**
- Build-cost gating: per-building hammer/tool costs are **data, not code** — NAMES `@BUILDING`
  (`name, hammers, tools×10, size, min_colony, upkeep`; DGROUP table `0x8F8C`). `func_02D658` *reads*
  `@BUILDING[+0x94]` and gates the two hammer banks (`+0x92`/`+0xB6`); it holds no cost table.
  Stockade 64H, Docks 52H, Armory 52H all byte-confirmed against `@BUILDING`. **B**
- The SoL/cargo/msg panel switches content on `[0x337]` (3 modes); the per-mode behaviour is in
  sub-renderers `0x2C9B0`/`0x2CA50`/`0x2CAA0` → file `0x0275CE`/`0x027746`/`0x027BB6`, **now byte-decoded**
  (`func_0275CE`/`func_027746`/`func_027BB6`): case 0 = SoL/garrison **icon bar** (`0x181F:0x222` loop, no
  string), case 1 = cargo holds + `[0x939A]` caption, case 2 = cargo + caption + hammer strip
  (§3.6, §8 item 3). **B** (switch + all 3 modes).

## 7. Evidence
- `viceroy_source/docs/drawlist/EUROPE_COLONY.md` PART 2 — composer `func_028592 @0x028592` 12-step
  ORDER (§2.0); sub-renderers title `func_0268CE @0x0268CE` (§2.1), field `func_0264A8 @0x0264A8`
  (§2.2), plaza `func_0270D0 @0x0270D0` (§2.3), flag `func_02853C @0x02853C` (§2.4), minimap
  `func_027DB2 @0x027DB2` (§2.5), SoL/cargo/msg `func_02814C @0x02814C` (§2.6), buildings
  `func_02701C @0x02701C` (§2.7), terrain scene `func_026374 @0x026374` (§2.8); "Coordinate summary"
  + "PORT FIXES / COLONY". **B**
- `viceroy_source/docs/SCREEN_LAYOUTS.md` §3 — `[V]`-cited element table: stockpile bar 16 cells,
  ICONS 23..38, pitch 19, fill `@0x0281DB`; flag (303,132,17,45) sprite 0x44; minimap (121,130,84,48);
  SoL panel (211,130,91,48); buildings 15 slots `cmp 0xF @0x02707B`, BUILDING.SS frame per §0.2. **B**
- `docs/COLONY_RENDER_CHAIN.md` §1/§2 — `[0x8542]` near-ptr; ColonyRecord base `0x5D46` stride `0xCA`;
  entry chain `func_L187 @0x07D3E → set_active_colony @0x82DC → lcall 0x191f:0x1de`. **B**
- `viceroy_source/docs/COLONY_SYSTEM.md` — colony-record field meanings for the live data. Marked
  **RECONSTRUCTED — NOT BYTE-VERIFIED** in its own header, so its formulas (SoL ratio, production,
  warehouse caps) are tier **R** here, not B (see §8). **R**
- `data_extracted/text/{LABELS,NAMES,COLONY}_sections.json` — `@CTITLE`, `@CMISC`, `@CMESSAGE`,
  `@CARGO`, `@BUILDING`, `@JOB`, `@SEASONS`, `@COLORS`, `@COLONYNAME`, `@DUTCH`… (all grep-verified
  present this pass). **B**

## 8. Open questions
1. **Title paint origin/centering — RUNTIME (paint routine + global reads byte-confirmed; literal x/y
   is runtime state).** The terminal paint in `func_0268CE` is `0x181F:0xB0` → `func_00275C @0x00275C`
   at `@0x026AA6`, pushing **only** `(ss, &buf[bp-0x50], mode=[bp+6])` — **no x/y argument**
   (`@0x026A9E..0x026AA6`). `func_00275C` then byte-reads the per-screen text-box globals directly:
   **x=`[0x2CC6]`** (`@0x00278F`), **y=`[0x2CC8]`** (`@0x002782`/`@0x002810`), width=`[0x2CCA]`
   (`@0x00278C`), line-height=`[0x2CCC]` (`@0x002785`). These are **runtime state**: the context init
   `0x181F:0xC22` (→ `func_00BC06 @0x00BC06` = `call 0xBBE0; call 0xBBFC`) does **not** write
   `[0x2CC6/0x2CC8/0x2CCA/0x2CCC]` with any literal, so the centred `y≈5` cannot be byte-literalized
   here. **Next action: a runtime trace (or the screen-table that seeds `[0x2CC6..]` for screen 0x2C)
   to capture the live origin.** Do not invent a literal.
2. **Colonist-row per-unit pitch — RESOLVED (B), 2026-06-26** (was open; full decode in §3.3).
   `func_0270D0` x-origin 143 walking left is **B**; the pitch is an **adaptive fit-to-span pack**:
   pass 1 sums each colonist's sprite width `+0x3E` into `total_width` (`@0x02710A..0x027141`); the
   gap solve starts `gap=[0xA890]` (init 2) and decrements it while
   `gap·(count−1) + [bp-0x5A] + total_width ≥ 0x60 (96)` (`@0x02715C..0x027173`); pass 2 draws each
   colonist at the running x, advanced left by `sprite_width + gap` (`@0x027186..`, blit `0x181F:0xCE`).
   So **pitch = per-colonist `sprite_width(+0x3E)` + adaptive `gap` (2→0, fit-to-96px)** — data-driven,
   no single static literal, but the mechanism + the `[0xA890]=2` seed are **B** (oracle-confirmed,
   §3.3).
3. **SoL / cargo / msg panel mode text — RESOLVED (B), 2026-06-27** (was open; reconciles §8 with the
   §3.6 decode). Panel rect (211,130,91,48) and the 3-way `[0x337]` dispatch are **B**
   (`func_02814C @0x02815F..0x028180`: `al=[0x337]`; `0→call 0x2c9b0`, `1→call 0x2ca50`,
   `2→call 0x2caa0`). The three near-stubs thunk-resolve to file `0x0275CE`/`0x027746`/`0x027BB6`
   (§3.6), and all three bodies are now byte-read: **case 0 `func_0275CE`** paints the SoL/garrison
   **icon bar** (loops `0x181F:0x222` = `func_0033F2` icon-strip queue over table `[bx−0x7238]`;
   `@0x0275EF..0x027738`) — **NO string fetch** (`func_0275CE @0x027612`/`@0x027688`); **case 1
   `func_027746`** reads cargo holds `colony+0x94` (`0x181F:0xAC4`/`0xD4E` `@0x027763`/`@0x027778`)
   and, when `[0xB98]==0`, draws a CENTERED caption from string-index `[0x939A]` via
   `0x181F:0x22`+`0x100` at (211,130,…) (`func_027746 @0x0277AC..0x0277C4`); **case 2 `func_027BB6`**
   reads cargo (`0xAC4`/`0xD4E` `@0x027BCC`/`@0x027BE1`), draws a centered caption via `0x181F:0x100`
   (`@0x027C13`) and a hammer production strip `0x181F:0x236` sprite 0x37=55 (`func_027BB6 @0x027CC6`).
   The SoL/garrison mode (case 0) panel is an icon bar, not a labelled string; the "Sons of Liberty"
   *caption* is rendered elsewhere — as the warehouse-bar right readout `[0x2F5E]=0x219` (§5, §4 line
   439, oracle-resolved 2026-06-27). **B (sub-renderers byte-decoded).**
4. **SoL% formula — RESOLVED (B), 2026-06-27 (reseg + writer-trace).** The prior reconstruction
   `sol = (colony[+0xC2]·100)/colony[+0xC6]` + 20 human-latch + clamp-100 + tory text-colour rule is now
   **fully byte-cited** — it does NOT live in an un-extracted overlay. **Compute:** resident
   `func_008524 @0x008524` (= thunk `0x181F:0xC86`, role "SoL%/rebel-sentiment compute"; reseg'd from
   VICEROY.EXE 0x008524..0x0085B1): loads colony (`[0x8542]`) `+0xC2:+0xC4` (32-bit bell-pool numerator)
   and `+0xC6:+0xC8` (32-bit cap); if cap≤0 returns 0 (`@0x008539..0x008547`); else pushes `0x64`(100) +
   numerator and calls `0xd1d:0xf60` (32-bit mul ×100) `@0x008557` then `0xd1d:0xec6` (32-bit div by cap)
   `@0x00855E` ⇒ `base = (+0xC2·100)/+0xC6`; **+20 human latch** `add ax,0x14 @0x00859F` (gated
   `colony+0x1A<4` & `[bx+0x543f]==0` & flag check `lcall 0x981:0(0x12,owner) @0x008578`); **clamp 100**
   `cmp ax,0x64; mov ax,0x64 @0x0085A8..0x0085AD`; return AX. **Source fields:** written each colony-turn
   by `func_02D658 @0x02D658` (page_03) — numerator `+0xC2` accumulated then clamped to cap `+0xC6`
   (`@0x02DAC6..0x02DAD4`), cap `+0xC6` = decay(`-(+0xC6>>6)`) + population·2 (`@0x02DA1C..0x02DA6F`);
   colony founding sets `+0xC6=0x64`,`+0xC2=0` (`@0x02EC26..0x02EC38`). **Display:** the SoL line
   ("100% (1)") is rendered at page_02 `@0x0273DC`: `lcall 0x181F:0xC86 → [bp-0x70]` = SoL%, `0x64-SoL%`
   = tory%, `member_count = population(colony+0x1F) − round(tory%·pop/100)` (`@0x0273F4..0x02740E`),
   and the tory-threshold **text-colour** `[bp-0x7c]` = `0x0F`(white) default → `0x04`/`0x0C` when the
   tory threshold (`[bp-0x62]`, from difficulty `[0x53A6]` `@0x027416`) exceeds the rebel count
   (`@0x027441..0x02745D`). So every piece of the prior recon is now B (`COLONY_RENDER_CHAIN.md` §6d's
   "overlay 0x191F, not extracted" note is superseded — the math is resident `func_008524` fed by
   `func_02D658`).
5. **Building per-slot frame map — RESOLVED (B), 2026-06-27 (see §0.2 + §3.7).**
   The earlier "index = type+1" (category+1) framing is **wrong and dropped**; the `func_026CC2`/
   `word[id*2−0x7238]` attribution was also wrong (that path is the production strip). The real painter
   is **`func_026DD4 @0x026DD4`** (reseg'd from VICEROY.EXE): building blit `0x181F:0x254 @0x026E4E`,
   **frame = `def_id + 1`** (EXE-sheet, `[bp-0x58]` set `@0x026DE5..0x026DE9`), special cases
   `def_id==0`+query0==0 ⇒ `0x11` (`@0x026DEC`), `def_id==0xF`/`0x11` garrison ⇒ `0x2F`/`0x30`
   (`@0x026E05`). In the lab's off-by-one bundle this is **frame = def_id** (def_id 0→16 via the
   special case). **Live-verified** against the Jamestown capture for every occupied plot (plots
   2/12/13 etc.). Empty-plot frame = `DS:0x260[category]−1` (B). No runtime AX trace needed — the rule
   is static. **B (reseg + live-verified).**
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
