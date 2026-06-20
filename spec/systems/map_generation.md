# Map Generation

> **Layer 2 — Specification (population stub).** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R/TBD. Details TBD — breadth pass.

**Overall confidence:** **random-map generator located + passes P0–P6 (incl. the
P2 climate→terrain tables) `BYTE_VERIFIED`** (`func_064A10`: entry/gate/seed/dims,
landmass, climate `{5,4,1,3,2,2}`N/`{2,3,3,4,6,7}`S, borders, flag bits); scenario
presets `BYTE_VERIFIED` data; Customize parameter encodings `TBD`.
**Canonical primary:** `data_extracted/text/NAMES_sections.json` (@SCENARIO),
`docs/GAME_MANUAL.md` (NEW WORLD / AMERICA / Customize New World).

## 1. Purpose & behavior
At new-game setup the player chooses how the world is built (`docs/GAME_MANUAL.md`):
- **Start in NEW WORLD** — randomly generated "undiscovered America."
- **Start in AMERICA** — fixed map matching real-world Americas geography (loads the
  canonical scenario; AMER2.MP is the standard-game world, `formats/MP_FORMAT.md`).
- **Customize New World** — adjustable parameters: average **land-mass size**,
  **moisture**, and **climate** (temperate / cold / tropical), "and so on."
  (RECONSTRUCTED — function from manual; parameter encodings `TBD`.)

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
Only the *random*-map generator (separate from these fixed-scenario starts)
remains `TBD`.

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
| P4 | rivers | feature spread over the 20-cell kernel `DS:0xC8/0xDE`; sets terrain **bit 6 `0x40`** (river overlay) | `@0x65BC2` |
| P5 | borders | **right two columns → Sea Lane `0x1A` (26)** (`@0x65941`/`@0x65975`, line-fill `0x181F:0xCE` at `x=W-1` then `x=W-2`); **top/bottom rows → Arctic `0x18` (24)** (`@0x6582A`) | `@0x65941` |
| P6 | starts | seed the 4 European powers' `(x,y)` into `PowerRecord +0x32/+0x33` (stride `0x13C`): `y = (H/5)·(p+1)` band, `x` walked inland from the east sea lane | `@0x65C9C` |

Base-terrain immediates the generator literally writes: **Arctic `0x18`(24),
Ocean `0x19`(25), Sea Lane `0x1A`(26)**; flag bits **hills `0x20` / river `0x40` /
forest `0x80`**. These id↔name bindings are confirmed by the byte-verified `@OTHER`
ordering + hard rule 2 (Sea Lane = 26) — see `notes/rulings/RULINGS.md` 2026-06-20;
they reconcile the generator (fill 0x19=Ocean → grow land → poles 0x18=Arctic →
right edge 0x1A=Sea Lane) with the coast renderer (`@0x67FD0 cmp al,0x18`). The
generator builds **only the terrain layer + European starts** — native settlements,
prime resources, and Lost-City rumours are placed by separate (largely data-driven)
new-game passes (`TBD`).

### Starting units per power — **BYTE_VERIFIED (2026-06-20)**
After the generator returns, the new-game setup `func_0755CC` loops each power
`[bp-6] = 0..3` and places the classic loadout via `place_unit` (`0x181f:0x95c`)
at the power's start tile (`@0x07584B..0x0758CD`):
| order | `place_unit` type | site | notes |
|-------|-------------------|------|-------|
| 1 | **Caravel `0x0D`** (the ship) | `@0x07584B` | **Dutch (power 3):** overwritten to **Merchantman `0x0E`** (`@0x075875 cmp [bp-6],3; mov byte[bx+0x3146],0xe`) — the Dutch trading-vessel power |
| 2 | **Pioneers `2`** (aboard) | `@0x07588B` | **French (power 1):** class `UnitRecord +0x315b := 0x14` (expert/Hardy-Pioneer-tier) (`@0x0758B5 cmp [bp-6],1`) |
| 3 | **Soldiers `1`** (aboard) | `@0x0758CD` | class `+0x315b := 0x15` = **Veteran Soldier** for **Spanish (power 2)** or the easy-difficulty bonus pass (`@0x0758F5`: `[0x53a6] ≤ 1` 2nd pass, or `power==2`) |

Units 2 & 3 are flagged **aboard** the ship (`UnitRecord +0x314c := 1`; the ship
itself `:= 0`) and stamped with the start tile (`+0x314d/+0x314e`). The setup also
records the power's start `(x,y)` into the scroll/center globals
`[0x17c]/[0x8540]` (x) and `[0x17e]/[0x853e]` (y) (`@0x07591C..0x075929`). At
**difficulty ≤ 1** (Discoverer/Explorer) the human player runs the placement a
**second pass** (`[bp-8]:=1; jmp 0x75825`, `@0x075961`), i.e. **double starting
units** as an easy-mode handicap. **B.** (Class-id `0x14`'s exact profession name
pends the `+0x315b` vet-type→`@JOB` legend; `0x15` = Veteran Soldier is confirmed
in `training.md`.)

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

- **Customize** parameter ranges (land-mass size `p1+p2`, moisture, climate): the
  landmass target `(p1+p2+1)·0x140` and the climate jump tables are located; the
  menu→parameter encodings are still `TBD`.
- Polar-ice boundary: top/bottom rows = Arctic `0x18` (P5). **B** (was R).
- Sea-lane on right edge: id 26 (`0x1A`), **right two columns** (P5). **B** (CLAUDE.md hard rule 2).

## 4. UI
Setup-menu options surfaced in the opening/new-game flow. Strings likely in
`OPENING_sections.json` / `MENU_sections.json`; concrete catalog `TBD`.

## 5. Evidence
- `func_064A10` (file `0x064A10`, overlay page 0x14) — the procedural generator: RNG seed `@0x64A1B`, arg gate `@0x64A2C`, ocean fill `@0x64A4B`, landmass `@0x64AAD`, climate dispatch `@0x64CF6`/`@0x65048` (inline tables `0x64CFC`/`0x6504E`, cs-base `0x64150` → N `{5,4,1,3,2,2}` / S `{2,3,3,4,6,7}`), smoothing `@0x653F8`, sea-lane borders `@0x65941`, Arctic `@0x6582A`, starts `@0x65C9C`; wired from new-game `func_0755CC @0x7579E` (dims `@0x75702`). **B** (verified vs EXE; the C-recon climate values are confirmed — they are inline jump-table cases, not a data array).
- `notes/rulings/RULINGS.md` 2026-06-20 — terrain ids 24–28 (Arctic/Ocean/Sea-Lane/Mountains/Hills); resolves the generator's `0x18/0x19/0x1A` immediates. **A (ruling)**
- `data_extracted/text/NAMES_sections.json` — `@SCENARIO` rows. **B** (data present).
- `docs/GAME_MANUAL.md` — NEW WORLD / AMERICA / Customize options. **R** (function).
- `formats/MP_FORMAT.md` — AMER2.MP is the standard-game world. **B**

## 6. Open questions (TBD)
1. Decode the 8 `@SCENARIO` columns.
2. ~~Locate and trace the random-map generator.~~ **Done 2026-06-19/20** — `func_064A10`, passes P0–P6 **B** (§3); dims 58×72, seed, gate, and the **P2 climate→terrain tables `{5,4,1,3,2,2}`N / `{2,3,3,4,6,7}`S** all byte-verified (inline jump tables `0x64CFC`/`0x6504E`, cs-base `0x64150`). The C-recon climate values are confirmed.
3. Customize parameter encodings (land size `p1+p2` / moisture / climate scales) — the landmass target `(p1+p2+1)·0x140` + climate jump tables are located; the menu→parameter binding is `TBD`.
4. Confirm which menu strings drive the three setup choices.
5. The separate new-game passes that place native settlements / prime resources / Lost-City rumours (`0xB0`) — entry functions `TBD`.
