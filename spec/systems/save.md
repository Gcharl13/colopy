# Save / Load

> **Layer 2 — Specification (population stub).** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R/TBD. Details TBD — breadth pass.

**Overall confidence:** filename-builder anchor `BYTE_VERIFIED`; record strides
`BYTE_VERIFIED` (runtime); per-field on-disk codec `TBD`.
**Canonical primary:** `docs/SAVE_FORMAT_CROSSREF.md`, `docs/DATA_MODEL.md`
(record layouts), `data_extracted/viceroy_strings.txt` (`.SAV` @ 0x1FA89).

## 1. Purpose & behavior
The game serializes runtime DGROUP state to an on-disk save file. The save is
"largely a serialization of the runtime DGROUP state, so the field names match
closely" but **the SAV format re-serializes with a different field order** than
runtime memory (`docs/SAVE_FORMAT_CROSSREF.md`). There are 10 save slots plus two
autosave slots (`docs/GAME_MANUAL.md`). **R** (slot count from manual).

## 2. State & data
- Save filename builder: base "COLONY" at file `0x1FA82`, followed by `.SAV\0`
  (`.SAV` confirmed at `data_extracted/viceroy_strings.txt:1032`, file `0x1FA89`;
  `docs/COLONY_RENDER_CHAIN.md:263` identifies the COLONY.SAV builder). **B** (string anchor).
- The serialized records mirror runtime structures (cross-referenced against
  pavelbel/smcol_saves_utility in `docs/SAVE_FORMAT_CROSSREF.md`):
  - **NativeSettlement / TRIBE**: 18-byte stride (matches runtime). Fields
    x,y,nation_id,BLCS flags,population,mission,growth_counter,occupant slots,
    alarm[4]. **B** (cross-confirmed strides/fields).
  - **NATION / PowerRecord**: tax_rate, recruit slots, founding_fathers bitfield,
    liberty-bell accumulators, boycott bitmap, royal_money, gold, crosses,
    market arrays. Several offsets **B**, several **NEW/TBD** (see doc).
  - **ColonyRecord**: stride `0xCA` (BYTE_VERIFIED, `docs/DATA_MODEL.md`); building
    bitmask `+0x60..+0x65`. **B**
- The **on-disk field order and any header/compression** for the SAV file itself
  are **TBD** — the doc warns the SAV reorders fields vs runtime; do not assume
  runtime offsets are file offsets.

## 3. Formulas & rules
- SAV file header / magic / version: **TBD**.
- Field serialization order (runtime → disk reordering): **TBD** per record type.
- Autosave cadence and HALLFAME.DAT writing: **TBD** (Hall-of-Fame writer
  `func_03ADA6` BYTE_VERIFIED entry, `docs/ARCHITECTURE.md`).
- Any compression on the save: **TBD**.

## 4. UI
Save/Load menu with 10 user slots + 2 autosave slots (manual). Layout `TBD`.

## 5. Evidence
- `docs/SAVE_FORMAT_CROSSREF.md` — DGROUP↔SAV record cross-reference; reorder caveat. **B/R**
- `data_extracted/viceroy_strings.txt:1032` — `.SAV` at file 0x1FA89. **B**
- `docs/COLONY_RENDER_CHAIN.md:263` — COLONY.SAV filename builder at 0x1FA82. **B**
- `docs/DATA_MODEL.md` — ColonyRecord/PowerRecord/UnitRecord runtime layouts. **B**

## 6. Open questions (TBD)
1. Locate the SAV write/read function and decode the file header + field order.
2. Determine whether the SAV is compressed.
3. Map runtime record offsets to their on-disk positions per record type.
4. Autosave trigger conditions and slot rotation.
