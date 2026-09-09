# Map Generation

> **Layer 2 — Specification (population stub).** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R. Details pending — breadth pass.

**Overall confidence:** **random-map generator located + passes P0–P6 (incl. the
P2 climate→terrain tables) `BYTE_VERIFIED`** (`func_064A10`: entry/gate/seed/dims,
landmass, climate `{5,4,1,3,2,2}`N/`{2,3,3,4,6,7}`S, borders, flag bits); scenario
presets `BYTE_VERIFIED` data; Customize parameter encodings `BYTE_VERIFIED` — the 4 player-facing picks are a 5-word global array at `DGROUP:0x1E7E` written by the Customize dialog `func_070060` (`@0x701AD mov [bx+0x1e7e],dx`, value mod-3 → 0..2) and read by the generator: landmass `(p1+p2+1)·0x140` (`func_064A10 @0x64AAD mov ax,[0x1e80]; @0x64AB0 add ax,[0x1e7e]; inc ax; imul ax,ax,0x140`), temperature `@0x64CA0 sub ax,[0x1e82]`, climate/moisture `@0x64DFE mov cx,[0x1e84]`, smoothing iters `@0x6538D mov ax,[0x1e86]; inc ax; imul ax,ax,0x320` (see §6 Q3).
**Canonical primary:** `data_extracted/text/NAMES_sections.json` (@SCENARIO),
`docs/GAME_MANUAL.md` (NEW WORLD / AMERICA / Customize New World).

## 1. Purpose & behavior
At new-game setup the player chooses how the world is built (`docs/GAME_MANUAL.md`):
- **Start in NEW WORLD** — randomly generated "undiscovered America."
- **Start in AMERICA** — fixed map matching real-world Americas geography (loads the
  canonical scenario; AMER2.MP is the standard-game world, `formats/MP_FORMAT.md`).
- **Customize New World** — adjustable parameters: average **land-mass size**,
  **moisture**, and **climate** (temperate / cold / tropical), "and so on."
  (RECONSTRUCTED — function from manual; parameter encodings **BYTE_VERIFIED**: the 3 menu-exposed picks plus land-form are the 3-way enums (0..2) stored at `DGROUP:0x1E7E/0x1E80/0x1E82/0x1E84`, written by `func_070060 @0x701AD` and consumed by the generator — landmass `(p1+p2+1)·0x140` `func_064A10 @0x64AAD`, temperature `@0x64CA0 sub ax,[0x1e82]`, climate/moisture `@0x64DFE mov cx,[0x1e84]`; see §6 Q3.)

## 2. State & data
`@SCENARIO` (`NAMES_sections.json`, **BYTE_VERIFIED** data present) lists named
scenarios with numeric parameter rows:
```
AMER2,     34, 20, 39, 10, 47, 61,  50, 33
AMERICA,   56, 27, 67, 12, 66, 42, 84,  65
```
The columns **are documented** by the `@SCENARIO` legend (and used by
`viceroy_source/data/scenario_starts.c`, byte-identical to the basis):
`map_file, start, end, x0, y0, x1, y1, x2, y2, x3, y3` — i.e. a map filename, the
scenario's **start/end year bounds**, and the **(x,y) starting tile** for each
European power. **BYTE_VERIFIED** (legend + `spec/data/tables.md` `@SCENARIO`).
The *random*-map generator (separate from these fixed-scenario starts) is
**located + BYTE_VERIFIED**: `func_064A10` (file `0x064A10`, overlay page 0x14),
wired from new-game `func_0755CC @0x7579E` via `lcall 0x1a1f:0x83e` (resolves to
`func_064A10`, thunk_resolve.json), passes P0–P6 per §3 (see §6 Q2).

## 3. Formulas & rules

### Random-map generator — **`func_064A10`** (file `0x064A10..0x065D07`, ENTER 0x3C, overlay page 0x14, cs base file `0x64150`). **READ WHOLE 2026-09-09 (RULINGS 2026-09-09d) and ported pass for pass** — `cport/core/colopy_mapgen.c` / `game.js generateNewWorld` carry every site; this section is the map of it.
Arg `[bp+6]`: `0` = build a world; nonzero = a premade map is in memory, jump to P5
(`@0x64A2C`). First act: `[0x190] = random_int(1, 0x7FFF)` (`@0x64A1B`), the map
salt. Every `lcall 0x181F:0x4D4` below is the sim's **shared** `random_int`. Dims
`[0x853A]`×`[0x853C]` = 58×72 (set in `func_0755CC @0x75702/@0x75708`). Layers:
`[0x85A8]` = plane 1 terrain, `[0x85B0]` = plane 2 (the ELEVATION scratch until P6a,
then the improvement plane), `[0x85C0]` = plane 4 (walker stamps; the river pass's
backup), `[0x85B8]` = plane 3 regions (labeller `func_063880`, `0x1A1F:0x7DC`).
Tables: DS:`0xB4`/`0xBE` 8-ring N,NE,E,SE,S,SW,W,NW + two zero pads; DS:`0xA8`/`0xAE`
N,E,S,W; DS:`0xC8`/`0xDE` the 20-cell kernel. Switches (cs:`0xBAC`/`0xEFE`/`0x11CE`,
decoded by matching their words to the case labels).

| # | Pass | What it does (all B) | site |
|---|------|--------------|------|
| P0 | init | terrain ← Ocean `0x19`, plane 2 ← 0; walker box x 3..w−6, y 0..h or 5..h−6 on `random_int(0,1)` (the pole side left empty) | `@0x64A35..0x64AA4` |
| P1 | land | repeat `grow(0)` until stamps ≥ `(land_mass+land_form+1)·0x140`; `grow`: clear plane 4, pick `x=random_int(1,w−16)+7, y=random_int(1,h−8)+3`, walk — `func_0641EC` (2+random_int(1,0x40) diagonal steps stamping a 2×2 `func_064154`) or, land_form ≥ 2, `func_064266` (2+random_int(1,0x30) steps with four 1-in-4 side stamps); merge: plane 2 += 1 per stamped square (1 flat, 2 hills, ≥3 mountains). Then label, count landmasses (the labeller tests TERRAIN — still all ocean — so 0), `15 − n` islands, minus `random_int(0,·)` when land_form > 0, each `grow(1)` = 1–3 runs of `func_06436C` (2+random_int(1,16) cardinal single squares, seeded on open water). Then the diagonal-gap fill (2×2 patterns 6/9 → filled, cursor steps back) | `@0x64AA4..0x64C6E` |
| P2 | latitude | per square (ocean too, the draws are unconditional): `c = h/2 − random_int(1,16) − y + 8`, band = `|h/2 − random_int(1,16) − y + 8| + 2·(1−temperature)`, clamp ≥ 0, `>> 2` → cs:`0xBAC` **{5,4,1,3,2,2}**, > 5 → 0 (Tundra); elevation 2 → `|0x20`, 3 → `|0x80` | `@0x64C6E..0x64DCC` |
| P2b | moisture | per row a counter `random_int(0, |h/4 − dist| + 4·climate)` swept west→east: ocean regains toward that cap; mountains −3; **hills are flattened** (`and 0x5F`); dry (< 0) Grassland→Prairie→(Desert or Plains)→Plains→Tundra (Tundra → elevation 2); wet (> 0) Tundra→Plains→Prairie→Grassland→Marsh/Savannah→Swamp on 1-in-4; counter −random_int(1, 7−2·climate) while wet, +1 while dry. Then east→west from 0 with the cs:`0xEFE` ladder {0→2,1→3,2→3,3→4,4→6 on a coin,5→7} and an ocean cap `dist/2 + climate` | `@0x64DCC..0x65114` |
| P3 | relaxation | `(p_iter+1)·0x320` visits (`[0x1E86]`, not exposed): even = a random square, odd = an 8-ring(+pad) step; mountains: `func_064534` flattens when all four diagonals are land; hills → mountains, elevation 1; flat: the cs:`0x11CE` ladder per base (coins that shift the base, set elevation 2, or raise a mountain), then hills on `random_int(0,p20)==0` and mountains on `random_int(0,p26)==0` with the ladder's odds | `@0x65114..0x653C8` |
| P3b | forest | flat (elevation 1): `+8` on 1-in-9 else `+0x10`; elevated: if coastal (`func_008352`) `+8` on a coin else `+0x10` on 4-in-5 | `@0x653C8..0x654BA` |
| P3c | rivers | `func_0645F6`: up to 0x200 attempts for `(climate+land_mass+2)·8` rivers; backup plane 1 → 4; a random flat land source; 4-direction walk (turn on a 60/36/4 % roll), each square `|0x40`, stops at water or an old river; < 3 squares → restored; on reaching water `random_int(1,2·(climate+6)) > 6` → `random_int(1,2·climate+3)` squares upstream `|0x80` (major); the 20-cell kernel round the source `+8` on coins (base < 0x10) | `@0x0645F6..0x064A0F` |
| P3d | poles/ring | the 4-row pole band ← Ocean; hollow ring (2,0)–(w−3,h−1) Ocean; 40× Arctic at `(random_int(1,w)−1, 1)` and `(…, h−2)` | `@0x654BA..0x65590` |
| P4 | sea lane | (a) each row from the east: water → Sea Lane down to the first coast or x < w/2; (b) three columns east of each row's first coast, in rows y±3, the next water square east of land → Ocean; (c) west of the lane run every water square → Ocean; (d) rows 1/h−2 land → Arctic, 2/h−3 → Arctic or Tundra on a coin, 3/h−4 → Tundra on a coin | `@0x65590..0x657F4` |
| P5 | outline+fold | (both paths) hollow rects (0,0)–(w−1,h−1) and (1,0)–(w−2,h−1) Sea Lane, rows 0/h−1 Arctic; fold: `base ≥ 0x18` skip, hills bit → `(v&0xE0)|(base&7)`, 16..23 → −8 | `@0x65941..0x65AA0` |
| P6 | tail | labels; planes 2 and 4 ← 0; **plane-2 `0x20`** on the western sea (row by row from x=1 to the first coast, x < w−16 premade / w/2 built); **plane-2 `0x04`** on water squares whose detail hash hits with no land in the 20-cell kernel (offshore fish suppressed); `[0x2174]==0`-gated `0xA0` at (1,21)/(43,68) (off in play); **starts**: the four H/5 bands dealt at random from the human (`random_int(1,2)` first on a built world, `random_int(0,3)` premade, redraws until free), each start = the first Sea Lane square east of the band row's coast → PowerRecord +0x32/+0x33 | `@0x65AA0..0x65D07` |

The premade tail was diffed against the fresh-game fixture `savstart`: the 0x20
bits 1309/1309, the 0x04 bits exactly (with the `func_00627A` edge-class rule),
the start squares = rows 42/14/56/28 — **so the AMERICA new game's starts are the
bands, not `@SCENARIO`** (the loader stores those; the builder overwrites them).
Base-terrain immediates: Arctic `0x18`, Ocean `0x19`, Sea Lane `0x1A`; the terrain
byte's bits are the `.MP` bits (`formats/MP_FORMAT.md`): `0x20` hills, `0xA0`
mountains, `0x40` river, `0xC0` major river, forest = base+8 (the earlier
"runtime board differs from the file" gloss here was wrong — the builder writes the
file layout). The earlier "S table {2,3,3,4,6,7}" gloss was the cs:`0xEFE` moisture
ladder, not a hemisphere. Native settlements, the resource/land-value layer and Lost
City rumours remain separate passes (§6 Q4).

### Starting units per power — **BYTE_VERIFIED (2026-06-20)**
After the generator returns, the new-game setup `func_0755CC` loops each power
`[bp-6] = 0..3` and places the classic loadout via `place_unit` (`0x181f:0x95c`)
at the power's start tile (`@0x07584B..0x0758CD`):
| order | `place_unit` type | site | notes |
|-------|-------------------|------|-------|
| 1 | **Caravel `0x0D`** (the ship) | `@0x07584B` | **Dutch (power 3):** overwritten to **Merchantman `0x0E`** (`@0x075875 cmp [bp-6],3; mov byte[bx+0x3146],0xe`) — the Dutch trading-vessel power |
| 2 | **Pioneers `2`** (aboard) | `@0x07588B` | **French (power 1):** profession-class `UnitRecord +0x315b := 0x14` = **Pioneer** (`@JOB` index; `@0x0758B5 cmp [bp-6],1`) |
| 3 | **Soldiers `1`** (aboard) | `@0x0758CD` | profession-class `+0x315b := 0x15` = **Soldier** (`@JOB`; the professional/Veteran-Soldier class vs `0x13` Free Colonist) for **Spanish (power 2)** or the easy-difficulty bonus pass (`@0x0758F5`: `[0x53a6] ≤ 1` 2nd pass, or `power==2`) |

Units get a default **order** in `UnitRecord +0x314c` (the order field, per
`trade_routes.md` §2): the ship `:= 0`, the two colonists `:= 1`; their GoTo/position
cache `+0x314d/+0x314e` is stamped with the start tile. The setup also
records the power's start `(x,y)` into the scroll/center globals
`[0x17c]/[0x8540]` (x) and `[0x17e]/[0x853e]` (y) (`@0x07591C..0x075929`). At
**difficulty ≤ 1** (Discoverer/Explorer) the human player runs the placement a
**second pass** (`[bp-8]:=1; jmp 0x75825`, `@0x075961`), i.e. **double starting
units** as an easy-mode handicap. **B.** (Class ids are `@JOB` profession indices:
`0x13`=Free Colonist, `0x14`=Pioneer, `0x15`=Soldier — so the French get a
Pioneer-class colonist and the Spanish a Soldier-class one.)

**P2 climate band → base terrain — BYTE_VERIFIED (2026-06-20).** The two latitude
sweeps each dispatch a 6-entry inline jump table (cs-base file `0x64150`) to local
`mov [bp-0x2e/0x12], N` cases:
- **North half** (table file `0x64CFC`, `cs:0xBAC`): band 0..5 →
  **`{5, 4, 1, 3, 2, 2}`** = Savannah, Grassland, Desert, Prairie, Plains, Plains.
- **South half** (table file `0x6504E`, `cs:0xEFE`): band 0..5 →
  **`{2, 3, 3, 4, 6, 7}`** = Plains, Prairie, Prairie, Grassland, Marsh, Swamp
  (the Marsh case `@0x6500C` is gated by a 50% roll `lcall 0x181f:0x4d4`; Swamp/Marsh
  also apply a moisture `−2`).
These match `viceroy_source/src/mapgen/climate.c` exactly.

> **Self-correction (2026-06-20, supersedes the earlier "P2 unresolved" note).** The
> values were briefly second-guessed (marked unresolved) after a search found the literal byte
> sequence `05 04 01 03 02 02` absent from the EXE. That was a false negative: the
> values are not stored as a data array — they are **inline switch cases** reached
> through the jump tables above. Decoded at the correct table location/cs-base, the
> targets land exactly on the `mov [bp-…],N` cases, recovering `{5,4,1,3,2,2}` (N)
> and `{2,3,3,4,6,7}` (S). The prior "scattered targets `0x66605/0x63888/…`" were an
> artifact of decoding the table at the wrong offset (`0x6442c`) with the wrong
> segment base. **P2 terrain-value mapping is BYTE_VERIFIED.**

- **Customize** parameter ranges: the **4 player-facing parameters are 3-way enums
  (value 0..2)** chosen from a 4-row menu (`func_070060`, cursor `mod 4` `@0x70158`,
  value `mod 3` `@0x701AA/0x701AD`): idx0 `@CLAND` land-mass {Small/Normal/Large},
  idx1 `@CCONT` land-form {Archipelago/Normal/Large Continents}, idx2 `@CTEMP`
  temperature {Cool/Temperate/Warm}, idx3 `@CCLIM` climate {Arid/Normal/Wet}
  (`GAME_sections.json`). They feed the generator as landmass target `(p1+p2+1)·0x140`
  and the temperature/climate jump-table inputs. A 5th array slot `0x1E86` =
  smoothing-iteration count is generator-internal (`(p_iter+1)·0x320` `@0x6538D`), not
  on the menu. **B.**
- Polar-ice boundary: top/bottom rows = Arctic `0x18` (P5). **B** (was R).
- Sea-lane on right edge: id 26 (`0x1A`), **right two columns** (P5). **B** (CLAUDE.md hard rule 2).

## 4. UI — top-level new-game setup menu — **BYTE_VERIFIED (2026-06-25)**
The host screen is **`@BEGINMENU`** (`GAME_sections.json`), NOT `OPENING`/`MENU`:
title `"{COLONIZATION} Version %STRING0 -- %STRING1"` + **5 selectable rows**:
1. *Start a Game in NEW WORLD*, 2. *Start a Game in AMERICA*, 3. *CUSTOMIZE New
World*, 4. *LOAD Game*, 5. *View Hall of Fame*.

**Menu-builder / host = `func_0759E8`** (file `0x0759E8..0x075F86`, ~1438 B, ENTER
`0x3F4`, RETF, overlay page **0x1A**) — the "open-menu framework" (already tagged
OPENMENU/MAPTOLOAD). It loads the `@BEGINMENU` section-key address
(`@0x75C60 lea bx,[0x2345]`; the key string `"BEGINMENU"` is at file `0x1FCE5`,
DGROUP base `0x1D9A0` → imm `0x2345`) and runs the menu via the **run-named-menu
primitive `lcall 0x181f:0x3fe`** (`@0x75C64`; bx = key addr, returns the **1-based
selected row in `ax`**, 0 = cancel). The selection is stored in the stack local
**`[bp-0xe0]`** (`@0x75C69`); the persistent cursor *global* for this primitive is
the menu-state structure based at **`DGROUP:0x87C`** — the run-named-menu primitive `0x181f:0x3fe` resolves (`thunk_resolve.json` `181F:03FE`) to wrapper `func_06F594`, which does `mov ax,bx` (ax=key addr) then **`lea bx,[0x87c]`** (`@0x6F596`, bytes `8d 1e 7c 08`) before `call 0x6f7ef` into the menu core, i.e. it hands the core the persistent menu/cursor state block at `[0x87c]`. This is distinct from the `[0xa60a]` cursor the customize builder keeps for itself (see §6). **B** (`func_06F594 @0x6F596` byte-verified).

**Row dispatch** (dec-chain `@0x75C6D..0x75C83`): sel 0 → `0x4afd` (cancel); sel
**1/2/3** → `0x47f6` (shared world-build setup loop); sel **4** (*LOAD Game*) →
`0x495a`; sel **5** (*View Hall of Fame*) → `0x4a20`. Two rows insert sub-dialogs
inside the shared path:
- **Row 2 *AMERICA*** — `@0x75CDE cmp [bp-0xe0],2; jne` then `@0x75CE5 lea
  bx,[0x234f]` (key `"AMERICA"`, file `0x1FCEF`) + `lcall 0x181f:0x3fe` = the
  **`@AMERICA`** sub-menu *"Original Americas / Map Editor"* (map-editor file picker
  uses `*.MP` imm `0x2357` / `MAPTOLOAD` imm `0x235c`).
- **Row 3 *CUSTOMIZE New World*** — `@0x75CC4 cmp [bp-0xe0],3; jne 0x484a` then
  **`@0x75CCB lcall 0x1a1f:0xbe4` → `func_070060`** (the Customize sub-menu, §6 Q3).
  Thunk `0x1A1F:0xBE4` (byte sig `9a e4 0b 1f 1a`, thunk record file `0x1D1D4`)
  resolves to `func_070060` and `func_0759E8 @0x75CCB` is its **only** caller
  (`tools/rtlink/xref.py callers 0x070060`).

String-key→DGROUP-immediate binding is byte-verified (base `0x1D9A0`: CUSTOMIZ
`0x1F9C2`→`0x2022`, DIFFICUL→`0x202d`, NATIONS→`0x2043`, OPENMENU `0x1FCDC`→`0x233c`,
BEGINMENU `0x1FCE5`→`0x2345`, AMERICA `0x1FCEF`→`0x234f`). **B.**

## 5. Evidence
- `func_064A10` (file `0x064A10`, overlay page 0x14) — the procedural generator: RNG seed `@0x64A1B`, arg gate `@0x64A2C`, ocean fill `@0x64A4B`, landmass `@0x64AAD`, climate dispatch `@0x64CF6`/`@0x65048` (inline tables `0x64CFC`/`0x6504E`, cs-base `0x64150` → N `{5,4,1,3,2,2}` / S `{2,3,3,4,6,7}`), smoothing `@0x653F8`, sea-lane borders `@0x65941`, Arctic `@0x6582A`, starts `@0x65C9C`; wired from new-game `func_0755CC @0x7579E` (dims `@0x75702`). **B** (verified vs EXE; the C-recon climate values are confirmed — they are inline jump-table cases, not a data array).
- `notes/rulings/RULINGS.md` 2026-06-20 — terrain ids 24–28 (Arctic/Ocean/Sea-Lane/Mountains/Hills); resolves the generator's `0x18/0x19/0x1A` immediates. **A (ruling)**
- `data_extracted/text/NAMES_sections.json` — `@SCENARIO` rows. **B** (data present).
- `docs/GAME_MANUAL.md` — NEW WORLD / AMERICA / Customize options. **R** (function).
- `formats/MP_FORMAT.md` — AMER2.MP is the standard-game world. **B**

## 6. Open questions
1. ~~Decode the 8 `@SCENARIO` columns.~~ **Done 2026-06-20 (legend CORRECTED)** — the
   loader `func_0749E0 @0x74D6A` reads, after the map-file token (`AMER2`), a loop
   `i=0..3` of **2 ints each → `PowerRecord[i]` start_x `[bx−0x77C6]` / start_y
   `[si−0x77C5]`**. So the 8 integers are **4 `(x,y)` power-start pairs**
   `(34,20)(39,10)(47,61)(50,33)`, **not** start/end-year columns (zero year reads) —
   the NAMES.TXT comment legend is stale. Consumer `@0x58BB5` copies them to unit
   coords. **B.**
2. ~~Locate and trace the random-map generator.~~ **Done 2026-06-19/20** — `func_064A10`, passes P0–P6 **B** (§3); dims 58×72, seed, gate, and the **P2 climate→terrain tables `{5,4,1,3,2,2}`N / `{2,3,3,4,6,7}`S** all byte-verified (inline jump tables `0x64CFC`/`0x6504E`, cs-base `0x64150`). The C-recon climate values are confirmed.
3. ~~Customize parameter encodings + menu binding.~~ **Done 2026-06-20** — the
   parameters are a **5-word global array at `DGROUP:0x1E7E`** (idx 0 land-mass p1
   `0x1E7E`, 1 land-form p2 `0x1E80`, 2 temperature `0x1E82`, 3 climate/moisture
   `0x1E84`, 4 smoothing-iteration count `p_iter` `0x1E86`), all five read by the
   generator: landmass target `(p1+p2+1)·0x140` (`@0x64AAD/0x64AB0 mov ax,[0x1E80];
   add ax,[0x1E7E]`); temperature shifts the latitude/climate band index
   (`@0x64CA0 sub ax,[0x1E82]`); climate/moisture biases smoothing
   (`@0x64DFE/0x64E2A mov cx,[0x1E84]`); and **idx 4 = `[0x1E86]` is the P3 relaxation
   budget `(p_iter+1)·0x320`** (`@0x6538D mov ax,[0x1E86]; inc ax; imul ax,ax,0x320`). `func_064A10` itself takes only
   `[bp+6]` = regenerate flag. The **Customize dialog `func_070060`** (`@0x75CCB`,
   gated `[bp-0xe0]==3`) writes the player's picks `mov [bx+0x1E7E],…` (`@0x701AD`,
   value mod-3 → 0..2); the menu exposes **exactly 4 rows** (cursor wraps `([0xa60a]+3)
   mod 4` `@0x70158`) → idx 0..3 of the array, with strings `@CLAND/@CCONT/@CTEMP/@CCLIM`
   (`@CLAND`="LAND MASS: Small/Normal/Large", `@CCONT`="LAND FORM: Archipelago/Normal/
   Large Continents", `@CTEMP`="TEMPERATURE: Cool/Temperate/Warm", `@CCLIM`="CLIMATE:
   Arid/Normal/Wet"; `GAME_sections.json`). **idx 4 (`0x1E86`, smoothing iterations) is
   NOT player-exposed** — it is read only by the generator. **B** (array+target+idx-4
   site + 4-row menu + strings).
4. ~~Post-mapgen placement passes.~~ **Done — BYTE_VERIFIED entry functions (2026-06-20):**
   all orchestrated by `func_0755CC` after the generator call `@0x7579E`:
   - **Native settlements** `func_065D26` (`@0x7596A`): allocates up to **84** (`0x54`)
     settlement records (stride `0x12` @ `0x54EC`, counter `[0x539A]`; per-tribe data
     `0x5AD6` stride `0x4E`, tribe type byte = `tribe+4` for tribes 4..11). **B.**
   - **Resource / land-value layer** `func_063F3C` (`@0x757BA`; body `0x063F3C`): per-tile value byte
     write (`0x181F:0x736` → `func_005ED0`, store `@0x064130`) into **map-layer #4** `[0x168]/[0x16a]`
     **low nibble** = `clamp(land-value/10, 0, 15)`. This low nibble is exactly what the **"Show Colony
     Sites" cheat (F9)** displays — full per-tile formula byte-traced in `spec/systems/ai.md §3b`
     (closed B 2026-06-28). **B.**
   - **Lost-City rumour features**: inside the generator tail `@0x65BFD..0x65C21`,
     `or byte es:[bx], 0xA0` into the **features plane** `[0x15C]` at **two FIXED tile
     coordinates** — `(1,0x15)` (`@0x65C0D`) and `(0x44,0x2b)` (`@0x65C21`), each
     `26 80 0f a0` = `or byte ptr es:[bx],0xa0` (pointer from tile helper `0x181F:0x70E`),
     both gated by `cmp [bp+6],0` and `cmp [0x2174],0/jne`. **0xA0 vs 0xB0 — RULED CLOSED
     (events.md §6.1, byte proof 2026-06-25; supersedes RULINGS.md line 38's stale
     `0xB0`-marker gloss per TRUTH_HIERARCHY EXE-bytes-win).** An exhaustive scan of all
     494,910 bytes of `VICEROY.EXE` for every tile-byte grp1-imm form (`26 80 0f a0` /
     `26 80 0f b0` / `26 80 0f 10`) returns **only** the two `0xA0` writes above — **zero**
     `0xB0` writes and **zero** `0x10` sets anywhere; the `==0xB0` trigger-read function
     **does not exist** (re-verified independently here). So no instruction ever turns
     `0xA0` into `0xB0`. The two `0xA0` tiles are NOT rumour placement: Lost-City rumour
     *presence* is **procedural** (coordinate-hash predicate `func_006188 @0x6188`,
     `events.md` §6.1), and the stored `0xA` high-nibble at these two fixed tiles actually
     *suppresses* a rumour there via `func_005DF0`'s sentinel + `jge`-fail `@0x61C5`. **B**
     (write byte-verified; reconcile ruled — the `0x10` bit is set by no instruction).
