# Map Generation

> **Layer 2 — Specification (population stub).** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R/TBD. Details TBD — breadth pass.

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

### Random-map generator — **`func_064A10`** (file `0x064A10..0x065D25`, ~4.9 KB, ENTER 0x3C, overlay page 0x14). BYTE_VERIFIED control flow (2026-06-19, verified vs EXE)
The single procedural map builder. Arg `[bp+6]`: **`0` = generate a random
continental map**; nonzero = a premade scenario is already in memory, skip the fill
(`@0x64A2C cmp [bp+6],0; jne 0x65941`). It seeds the RNG `[0x190] = random_int(1, 0x7FFF)`
(`@0x64A1B`; the seed is stored `[0x190]`, `[0x192]=0`). Map dims: **`g_map_width =
[0x853A]`, `g_map_height = [0x853C]`** — the random-map defaults **58×72**
(`0x3A`×`0x48`) are set in the caller `func_0755CC` (`@0x75702 mov [0x853a],0x3A`,
`@0x75708 mov [0x853c],0x48`) just before the generator call at `@0x7579E`
(`lcall 0x1a1f:0x83e` → `func_064A10`, arg `[bp+6]`); the loaded-scenario path uses
the `@SCENARIO`/`.MP`-header dims instead. The loop bounds confirm the globals
(x `< [0x853a] @0x64D48`, y `< [0x853c] @0x64DBC`);
4 layers via far ptrs `[0x15C]` terrain / `[0x160]` elevation-scratch / `[0x164]`
resource / `[0x168]` fog. Passes, in execution order (all byte-verified):

| # | Pass | What it does | site |
|---|------|--------------|------|
| P0 | init | fill terrain+elev layers with **`0x19` = Ocean (id 25)** (region fill `0x181F:0x484`) — the all-sea background before landmass growth | `@0x64A4B` |
| P1 | landmass | blob-growth: seed `≈(p1+p2+1)·0x140` land tiles (`@0x64AAD`), random-walk each with the **8-dir compass table `DS:0xB4`(dx)/`0xBE`(dy)** carrying a 4-neighbour land mask (mask 6/9 triggers fill) | `@0x64B5A..0x64BD1` |
| P2 | climate | latitude sweeps: N half (`y<H/2`) maps the climate-band index (`[bp-6]>>2`, 0..5) → base terrain via an **inline jump table** `jmp word ptr cs:[bx+0xBAC]` (table at file `0x64CFC`, cs-base file `0x64150`) → cases set `[bp-0x2e]`; S half uses `cs:[bx+0xEFE]` (table `0x6504E`) → `[bp-0x12]`. Then sets **hills bit `0x20`** (`@0x64D19`) / **forest bit `0x80`** (`@0x64D23`); elevation-0 default = `0x19` Ocean (`@0x64D0E`) | `@0x64CF6,0x65048` |
| P3 | smoothing | relaxation budgeted `(p_iter+1)·0x320`; folds unforested→forested ids (**`+8`/`+0x10`**, `@0x653F8/0x6540E`); converts stray interior Ocean | `@0x64DD4,0x65318` |
| P4 | rivers | feature spread over the 20-cell kernel `DS:0xC8/0xDE` via thunk `0x181F:0x718`; river occupies the runtime-board flag **bit `0x40`** — verified by elimination: the generator's only direct `or`-immediates are **hills `0x20`** (`@0x64D19`) and **forest `0x80`** (`@0x64D23`), so river takes the remaining high bit; the river bit-set itself is inside the thunk, not a literal `or …,0x40` in the body (2026-06-23 disasm) | `@0x65BC2` |
| P5 | borders | **right two columns → Sea Lane `0x1A` (26)** (`@0x65941`/`@0x65975`, line-fill `0x181F:0xCE` at `x=W-1` then `x=W-2`); **top/bottom rows → Arctic `0x18` (24)** (`@0x6582A`) | `@0x65941` |
| P6 | starts | seed the 4 European powers' `(x,y)` into `PowerRecord +0x32/+0x33` (stride `0x13C`): `y = (H/5)·(p+1)` band, `x` walked inland from the east sea lane | `@0x65C9C` |

Base-terrain immediates the generator literally writes: **Arctic `0x18`(24),
Ocean `0x19`(25), Sea Lane `0x1A`(26)**; **runtime-board** flag bits **hills `0x20`
(`@0x64D19`) / river `0x40` (thunk, by elimination) / forest `0x80` (`@0x64D23`)**.
⚠ This runtime-board layout differs from the **`.MP` *file* format** (`formats/MP_FORMAT.md`:
bit 5 `0x20` = river, bit 6 `0x40` = forest) — the file packing and the in-memory board
are **different representations** of the same features; the `.MP`→board remap (in the
`.MP` loader) is the remaining residual. The runtime river bit is `0x40` (this spec +
the render trace `map_system.md` §3; hills `0x20`/forest `0x80` are byte-confirmed here).
These id↔name bindings are confirmed by the byte-verified `@OTHER`
ordering + hard rule 2 (Sea Lane = 26) — see `notes/rulings/RULINGS.md` 2026-06-20;
they reconcile the generator (fill 0x19=Ocean → grow land → poles 0x18=Arctic →
right edge 0x1A=Sea Lane) with the coast renderer (`@0x67FD0 cmp al,0x18`). The
generator builds **only the terrain layer + European starts** — native settlements,
prime resources, and Lost-City rumours are placed by separate (largely data-driven)
new-game passes — **BYTE_VERIFIED entry functions** (§6 Q4): native settlements `func_065D26` (`func_0755CC @0x7596A lcall 0x1a1f:0x87c`), resource/land-value layer `func_063F3C` (`@0x757BA lcall 0x1a1f:0x7f8`), and Lost-City rumour features written inline in the generator tail (`func_064A10 @0x65C0D/@0x65C21 or byte es:[bx],0xa0`).

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

> **Self-correction (2026-06-20, supersedes the earlier "P2 = TBD" note).** The
> values were briefly downgraded to TBD after a search found the literal byte
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
`TBD` (not the `[0xa60a]` used by the customize builder — see §6).

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

## 6. Open questions (TBD)
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
   - **Resource / land-value layer** `func_063F3C` (`@0x757BA`): per-tile value byte
     write (`0x181F:0x736`). **A.**
   - **Lost-City rumour features**: inside the generator tail `@0x65BFD..0x65C21`,
     `or byte es:[bx], 0xA0` into the **features plane** `[0x15C]`. ⚠ **0xA0 vs 0xB0:**
     the generator writes mask **`0xA0`** (byte-verified `@0x65C0D`), while
     `events.md` cites the Lost-City *trigger* read as features `== 0xB0`
     (runtime-verified) — reconcile (the 0x10 difference may be a second feature bit
     set elsewhere or a trigger-side mask; **flagged, not yet ruled**). **B** (write).
