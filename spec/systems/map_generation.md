# Map Generation

> **Layer 2 — Specification (population stub).** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R/TBD. Details TBD — breadth pass.

**Overall confidence:** **random-map generator located + pass sequence `BYTE_VERIFIED`**
(`func_064A10`); scenario presets `BYTE_VERIFIED` data; Customize parameter encodings `TBD`.
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
(`@0x64A1B`). Map dims: **`g_map_width = [0x853A]`, `g_map_height = [0x853C]`**;
4 layers via far ptrs `[0x15C]` terrain / `[0x160]` elevation-scratch / `[0x164]`
resource / `[0x168]` fog. Passes, in execution order (all byte-verified):

| # | Pass | What it does | site |
|---|------|--------------|------|
| P0 | init | fill terrain+elev layers with **`0x19` Ocean** (region fill `0x181F:0x484`) | `@0x64A4B` |
| P1 | landmass | blob-growth: seed `≈(p1+p2+1)·0x140` land tiles (`@0x64AAD`), random-walk each with the **8-dir compass table `DS:0xB4`(dx)/`0xBE`(dy)** carrying a 4-neighbour land mask (mask 6/9 triggers fill) | `@0x64B5A..0x64BD1` |
| P2 | climate | latitude sweeps: N half (`y<H/2`) elevation→base via jump table `cs:[bx+0xBAC]` (`5,4,1,3,2,2`), S half `cs:[bx+0xEFE]`; OR **hills `0x20`** (`@0x64D19`) / **forest `0x80`** (`@0x64D23`) | `@0x64CEE,0x65048` |
| P3 | smoothing | relaxation budgeted `(p_iter+1)·0x320`; folds unforested→forested ids (**`+8`/`+0x10`**, `@0x653F8/0x6540E`); converts stray interior Ocean | `@0x64DD4,0x65318` |
| P4 | rivers | feature spread over the 20-cell kernel `DS:0xC8/0xDE`; sets terrain **bit 6 `0x40`** (river overlay) | `@0x65BC2` |
| P5 | borders | **right two columns → sea-lane `0x1A` (26)** (`@0x65941`/`@0x65975`, line-fill `0x181F:0xCE` at `x=W-1` then `x=W-2`); **top/bottom rows → Arctic `0x18` (24)** (`@0x6582A`) | `@0x65941` |
| P6 | starts | seed the 4 European powers' `(x,y)` into `PowerRecord +0x32/+0x33` (stride `0x13C`): `y = (H/5)·(p+1)` band, `x` walked inland from the east sea lane | `@0x65C9C` |

Base-terrain immediates the generator literally writes: **Arctic `0x18`, Ocean `0x19`,
Sea-Lane `0x1A`**; flag bits **hills `0x20` / river `0x40` / forest `0x80`**. The
generator builds **only the terrain layer + European starts** — native settlements,
prime resources, and Lost-City rumours are placed by separate (largely data-driven)
new-game passes (`TBD`).

- **Customize** parameter ranges (land-mass size `p1+p2`, moisture, climate): the
  landmass target `(p1+p2+1)·0x140` and the climate jump tables are located; the
  menu→parameter encodings are still `TBD`.
- Polar-ice boundary: top/bottom rows = Arctic `0x18` (P5). **B** (was R).
- Sea-lane on right edge: id 26 (`0x1A`), **right two columns** (P5). **B** (CLAUDE.md hard rule 2).

## 4. UI
Setup-menu options surfaced in the opening/new-game flow. Strings likely in
`OPENING_sections.json` / `MENU_sections.json`; concrete catalog `TBD`.

## 5. Evidence
- `func_064A10` (file `0x064A10`, overlay page 0x14) — the procedural generator: RNG seed `@0x64A1B`, arg gate `@0x64A2C`, ocean fill `@0x64A4B`, landmass `@0x64AAD`, climate `@0x64CEE`, smoothing `@0x653F8`, sea-lane borders `@0x65941`, Arctic `@0x6582A`, starts `@0x65C9C`. **B** (verified vs EXE; cross-ref `viceroy_source/src/mapgen/*.c`).
- `data_extracted/text/NAMES_sections.json` — `@SCENARIO` rows. **B** (data present).
- `docs/GAME_MANUAL.md` — NEW WORLD / AMERICA / Customize options. **R** (function).
- `formats/MP_FORMAT.md` — AMER2.MP is the standard-game world. **B**

## 6. Open questions (TBD)
1. Decode the 8 `@SCENARIO` columns.
2. ~~Locate and trace the random-map generator.~~ **Done 2026-06-19** — `func_064A10`, pass sequence P0–P6 **B** (§3).
3. Customize parameter encodings (land size `p1+p2` / moisture / climate scales) — the landmass target `(p1+p2+1)·0x140` + climate jump tables are located; the menu→parameter binding is `TBD`.
4. Confirm which menu strings drive the three setup choices.
5. The separate new-game passes that place native settlements / prime resources / Lost-City rumours (`0xB0`) — entry functions `TBD`.
