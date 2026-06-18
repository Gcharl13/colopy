# Terrain Improvement (Roads / Clearing / Plowing)

> **Layer 2 — Specification (population stub).** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R/TBD. Details TBD — breadth pass.

**Overall confidence:** order set `BYTE_VERIFIED` (data); effect magnitudes
`RECONSTRUCTED`/`TBD`.
**Canonical primary:** `data_extracted/text/NAMES_sections.json` (@ORDERS),
`docs/GAME_MANUAL.md` (Clear Land / Plow Fields / Build Road).

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

Per-tile road/cleared/plowed overlay flags: tile-byte bit 5 = river, bit 6 =
forest/special (`formats/MP_FORMAT.md`); a dedicated road/plow flag location is
**TBD**.

## 3. Formulas & rules
- Turns to complete clear / plow / road (terrain-dependent): **TBD**.
- Yield delta from plow / road / clear: **TBD** (manual gives direction, not numbers).
- Tool cost = 20 per action: **R** (manual) — byte-confirm pending. → `spec/BACKLOG.md`.
- Lumber granted by clearing: **TBD**.

## 4. UI
Active-Pioneer hotkeys (manual keyboard ref): `P` clear/plow, `R` build road.
Orders box shows `P` / `R` while in progress. Layout `TBD`.

## 5. Evidence
- `data_extracted/text/NAMES_sections.json` — `@ORDERS` (Clear/Plow P, Build Road R). **B** (data).
- `docs/GAME_MANUAL.md` — clear/plow/road effects; 20-tool cost; keys. **R**
- `formats/MP_FORMAT.md` — tile-byte overlay bits. **B**

## 6. Open questions (TBD)
1. Byte-confirm the 20-tool cost and locate the order-execution function.
2. Per-improvement completion time and yield deltas.
3. Where road/cleared/plowed state is stored per tile.
