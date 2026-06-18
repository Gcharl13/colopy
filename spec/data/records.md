# Memory Records — Runtime Record Types

> **Layer 2 — Data Specification (population stub).** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R/TBD.

**Canonical primary:** `docs/DATA_MODEL.md` (runtime/byte-verified record layouts — CANONICAL for the full field maps). This stub is an index: it pins each record's base/stride and a few byte-verified anchor fields, then points to `docs/DATA_MODEL.md` for everything else. **Do not duplicate the full field tables here** — confirm any offset at its cited read site in `docs/DATA_MODEL.md` before tagging.

## 1. Summary

VICEROY.EXE keeps per-entity state in four primary fixed-stride record arrays in DGROUP, plus secondary tables (TribeData, market state) catalogued in `docs/DATA_MODEL.md`. Each array has a constant base address and a constant per-record stride; the active colony is reached indirectly through a far pointer at `[0x8542]`.

## 2. Contents

| Record | Base (DGROUP) | Stride | Count | A few BYTE_VERIFIED fields (→ full map in `docs/DATA_MODEL.md`) | Tier |
|--------|---------------|--------|-------|----------------------------------------------------------------|------|
| **PowerRecord** | `0x8808` (`0x8809` in field table) | `0x13C` = 316 | 12 (0..3 EU, 4..11 tribes) | `+0x21` gold (dword), `+0x25` total_loot, `+0x29` treasury, `+0x06` attribute bitfield, boycott u16 `+0x20`, market bytes `+0x4C..+0x5B` | **B** |
| **ColonyRecord** | active via `[0x8542]` far ptr | `0xCA` = 202 | ~50 | `+0x1A` owner_power_idx, `+0x1B` foreign-status, `+0x1C` const 0x40 (A), `+0x1F` size, stockpile `+0x9A` 16×u16 | **B** (stride/anchors), A/TBD elsewhere |
| **UnitRecord** | `0x3146` | `0x1C` = 28 | 300 max | `+0x00` unit_type (@UNIT idx), `+0x01` power\|flags, `+0x07` map_x, `+0x08` map_y | **B** |
| **NativeSettlement** | `0x54EC` | `0x12` = 18 | per-village | `+0x04` population (CHIEFKILL size_byte), `+0x08` last_bought | **B** |

> PowerRecord appears as base `0x8808` (record-array head) and `0x8809` (first field) in `docs/DATA_MODEL.md`; both are present there. Stockpile/SoL dividend-divisor/colonist-job offsets are NOT pinned here — read them at the `docs/DATA_MODEL.md` cited site.

Power index ordering (0..3 = Dutch/English/French/Spanish per NAMES `@COUNTRY`; 4..11 = tribes per NAMES `@TRIBES`) is given in `docs/DATA_MODEL.md`; see also `spec/data/names_sections.md`.

## 3. Evidence

- `docs/DATA_MODEL.md` — all four bases/strides BYTE_VERIFIED (PowerRecord via SMITE/raze/king-tax/combat; ColonyRecord via adjacent records Jamestown@0x5D46 / Quebec@0x5E10 diff=0xCA + memory inspection 2026-05-05; UnitRecord via 652+ `[reg+0x3146]` refs + runtime cross-validation; NativeSettlement via CHIEFKILL trace). **B**
- Active-colony pointer `[0x8542]` (102 refs per anchor_map). **B/A**
- `spec/systems/colony.md` — consuming spec for ColonyRecord. **B/R**

## 4. Open questions (TBD)

1. ColonyRecord: SoL dividend/divisor offsets, full colonist-job slot map, warehouse threshold field — confirm at read sites in `docs/DATA_MODEL.md`.
2. UnitRecord: `+0x02..+0x06`, `+0x09..+0x1B` semantics largely TBD in `docs/DATA_MODEL.md`.
3. PowerRecord `+0x06` bitfield bits beyond 6/10/19 — TBD.
4. NativeSettlement fields beyond `+0x04`/`+0x08` — TBD.
