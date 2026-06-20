# Terrain Improvement (Roads / Clearing / Plowing)

> **Layer 2 — Specification (population stub).** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R/TBD. Details TBD — breadth pass.

**Overall confidence:** order set + **executors (`func_040656` clear/plow,
`func_0409D6` road) + work-counter + completion + tile-bits + lumber grant
`BYTE_VERIFIED`** (2026-06-20); the 20-tool debit is in an overlay handler (TBD).
**Canonical primary:** `func_040656`/`func_0409D6`; `data_extracted/text/NAMES_sections.json`
(@ORDERS), `docs/GAME_MANUAL.md`.

## 1. Purpose & behavior
A Pioneer (a colonist carrying tools) can improve a terrain tile to raise yields
and ease movement (`docs/GAME_MANUAL.md`):
- **Clear (forested tile)** — removes forest; raises crop potential, eliminates
  timber/fur potential; yields some lumber; cleared land can never re-forest.
- **Plow (non-forested tile)** — raises crop production.
- **Build Road** — speeds movement; raises ore/fur/timber output by easing access
  (mountain road does not raise silver unless a silver deposit is present).

Each action **expends 20 tools** from the Pioneer (manual). **R** (function;
"20 tools" is a manual number — confirm against EXE bytes, hard rule: EXE wins).

## 2. State & data
`@ORDERS` (`NAMES_sections.json`, **BYTE_VERIFIED** data) lists the order codes,
including improvement orders:
- `Clear/Plow, P` (single order; clear vs plow chosen by tile forest state).
- `Build Road, R`.
(Other orders: No Orders `-`, Sentry `S`, Trade Route `T`, Go To `G`, Live In
Village `L`, Fortify/Fortified `F`, Build Colony `B`.)

**Per-tile improvement bits — BYTE_VERIFIED (2026-06-20):** on completion the
executor writes the **tile/feature byte** directly: **clear forest = subtract 8**
(`sub es:[bx],8` `@0x040896`, drops the forested id to its unforested base); **plow
= set bit `0x40`** (`or es:[bx],0x40` `@0x04089F`); **road = set bit `0x08`**
(`or es:[bx],8` `@0x040AEC`). (Pointers obtained from map-query overlays `0x181F:0x70E`
clear / `0x181F:0x740` plow+road.)

## 3. Formulas & rules

### Order dispatch + executors — BYTE_VERIFIED (2026-06-20)
The per-unit order dispatcher (`@0x051D56`) computes `sel = UnitRecord[+0x08
(0x314C)] − 7` and routes: order **8 (Clear/Plow "P") → `func_040656`** (`@0x40656`),
order **9 (Build Road "R") → `func_0409D6`** (`@0x409D6`). Clear-vs-plow is chosen by
the tile's forest state (`[bp-0xc]=0` if terrain id ∈ 8..0x17 forested, `@0x406C3`).

### Turns-to-complete (work counter) — BYTE_VERIFIED
- **Work-progress counter = `UnitRecord +0x16` (abs `0x315A`)** — incremented each
  turn the unit holds the order (`inc [bx+0x315a]` `@0x04071D` clear, `@0x040A46` road).
- **Threshold = the per-terrain `@TERRAIN` table** `byte[terrain·16 + 0x2F78]` (same
  stride-16 table whose `+0x2F80` column is the combat-defense value): **clear/plow
  `= table[t·16] + 2`** (`@0x040727`/`@0x04072D`), **road `= table[t·16]`** (no +2,
  `@0x040A50`). **Halved for a Hardy Pioneer** (profession class `UnitRecord
  +0x315B == 0x14`, `sar ax,1` `@0x04074A`/`@0x040A59`).
- **Completion:** when `counter ≥ threshold` (`@0x040756`/`@0x040A6C`) the counter is
  reset to 0 and the order byte `+0x314C` is cleared. **B.**

### Lumber from clearing — BYTE_VERIFIED
Clearing a forested tile near a colony deposits lumber into the current colony
(`*(0x8542)`): `add [colony +0xA4], ax` (`@0x04084D`) — **`+0xA4 = +0x9A + 5·2` =
the Lumber slot** of the 20-good colony array (good 5 = Lumber), *not* a separate
field. The amount derives from the `@TERRAIN` table column at `+0x2F80`, scout-scaled
and clamped ≥0; emits `@CLEARCUT` (GAME idx 459, "%NUMBER0 lumber added"). Road
completion also bumps `ColonyRecord +0x98` by `0xA` when the tile is the owner's
(`@0x040AA9`). **B.**

### Tool cost (−20) — TBD (overlay)
Neither executor subtracts 20 tools inline; the **20-tool debit + pioneer→colonist
reversion** (`@USEDUPTOOLS`, GAME idx 297) is in the `0x1A1F` overlay handlers reached
via thunks at file `0x04181D`/`0x041822` (not in this disasm snapshot). The manual's
"20 tools per action" is therefore **not yet byte-confirmed**; entry offsets recorded.

## 4. UI
Active-Pioneer hotkeys (manual keyboard ref): `P` clear/plow, `R` build road.
Orders box shows `P` / `R` while in progress. Layout `TBD`.

## 5. Evidence
- `data_extracted/text/NAMES_sections.json` — `@ORDERS` (Clear/Plow P, Build Road R). **B** (data).
- `docs/GAME_MANUAL.md` — clear/plow/road effects; 20-tool cost; keys. **R**
- `formats/MP_FORMAT.md` — tile-byte overlay bits. **B**

## 6. Open questions (TBD)
1. ~~Locate the order-execution function.~~ **Done 2026-06-20** — `func_040656`
   (clear/plow) / `func_0409D6` (road), dispatched from `@0x051D56` (§3). The
   **20-tool cost** is in the `0x1A1F` overlay (thunks `0x04181D`/`0x041822`) — still
   byte-TBD.
2. ~~Per-improvement completion time.~~ **Done** — work counter `UnitRecord +0x16`
   ≥ `@TERRAIN[t·16+0x2F78](+2 clear/plow)`, Hardy-Pioneer halved (§3). **B.**
   **Yield deltas** from plow/road/clear (the production effect of the `0x40`/`0x08`
   tile bits) — trace where `compute_terrain_yield` consults the plow/road bits.
3. ~~Where cleared/plowed/road state is stored.~~ **Done** — **plow = tile bit
   `0x40`, road = tile bit `0x08`, clear = forest id −8** (§3 "Per-tile bits"). **B.**
