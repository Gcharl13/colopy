# Memory Records — Runtime Record Types

> **Layer 2 — Data Specification (population stub).** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R/TBD.

**Canonical primary:** `docs/DATA_MODEL.md` (runtime/byte-verified record layouts — CANONICAL for the full field maps). This stub is an index: it pins each record's base/stride and a few byte-verified anchor fields, then points to `docs/DATA_MODEL.md` for everything else. **Do not duplicate the full field tables here** — confirm any offset at its cited read site in `docs/DATA_MODEL.md` before tagging.

## 1. Summary

VICEROY.EXE keeps per-entity state in four primary fixed-stride record arrays in DGROUP, plus secondary tables (TribeData, market state) catalogued in `docs/DATA_MODEL.md`. Each array has a constant base address and a constant per-record stride; the active colony is reached indirectly through a far pointer at `[0x8542]`.

## 2. Contents

| Record | Base (DGROUP) | Stride | Count | A few BYTE_VERIFIED fields (→ full map in `docs/DATA_MODEL.md`) | Tier |
|--------|---------------|--------|-------|----------------------------------------------------------------|------|
| **PowerRecord** | `0x8808` (`0x8809` in field table) | `0x13C` = 316 | 12 (0..3 EU, 4..11 tribes) | `+0x21` gold (dword), `+0x25` total_loot, `+0x29` treasury, `+0x06` attribute bitfield, boycott u16 `+0x20`, market bytes `+0x4C..+0x5B` | **B** |
| **ColonyRecord** | active via `[0x8542]` far ptr | `0xCA` = 202 | ~50 | `+0x1A` owner_power_idx, `+0x1B` foreign-status, `+0x1C` status-flags byte (B), `+0x1F` size, stockpile `+0x9A` 16×u16 | **B** (stride/anchors), A/TBD elsewhere |
| **UnitRecord** | `0x3146` | `0x1C` = 28 | 300 max | `+0x00` unit_type (@UNIT idx), `+0x01` power\|flags, `+0x07` map_x, `+0x08` map_y | **B** |
| **NativeSettlement** | `0x54EC` | `0x12` = 18 | per-village | `+0x04` population (CHIEFKILL size_byte), `+0x08` last_bought | **B** |

> PowerRecord appears as base `0x8808` (record-array head) and `0x8809` (first field) in `docs/DATA_MODEL.md`; both are present there. Stockpile/SoL dividend-divisor/colonist-job offsets are NOT pinned here — read them at the `docs/DATA_MODEL.md` cited site.

Power index ordering (0..3 = Dutch/English/French/Spanish per NAMES `@COUNTRY`; 4..11 = tribes per NAMES `@TRIBES`) is given in `docs/DATA_MODEL.md`; see also `spec/data/names_sections.md`.

## 3. Evidence

- `docs/DATA_MODEL.md` — all four bases/strides BYTE_VERIFIED (PowerRecord via SMITE/raze/king-tax/combat; ColonyRecord via adjacent records Jamestown@0x5D46 / Quebec@0x5E10 diff=0xCA + memory inspection 2026-05-05; UnitRecord via 652+ `[reg+0x3146]` refs + runtime cross-validation; NativeSettlement via CHIEFKILL trace). **B**
- Active-colony pointer `[0x8542]` (102 refs per anchor_map). **B/A**
- `spec/systems/colony.md` — consuming spec for ColonyRecord. **B/R**

## 4. Open questions (TBD)

1. ColonyRecord: SoL dividend/divisor `+0xC2`/`+0xC6` (B, `colony.md`); `+0x1C` =
   per-colony **status flags** byte (not const 0x40 — `colony.md`); `+0x92`/`+0xB6`
   hammers, `+0x84` constructed mask. **Mostly resolved 2026-06-20.**
2. ~~UnitRecord `+0x02..+0x1B` semantics.~~ **Done 2026-06-20** — base `0x3144`,
   near-complete field map in `spec/systems/unit.md` §2 (RULINGS; position `0x3144`,
   type `0x3146`, owner `0x3147`, order `0x314C`, goto `0x314D/E`, cargo `0x3150..`,
   tools `0x3159`, work `0x315A`, class `0x315B`, links `0x315C/E`).
3. ~~PowerRecord `+0x06` bitfield.~~ **Corrected 2026-06-20** — the FF acquired-bitmask
   is at **`+0x07`** (abs `0x880F`), not `+0x06`; bits 2/4/5/6/7/10/11/15/16/19/20/22/
   23/24 are FF/national-advantage gates (`diplomacy.md`/has-father helper). `+0x32`/
   `+0x33` = home (x,y) spawn coords (`ref_growth.md`, RULINGS).
4. ~~NativeSettlement fields.~~ **Mostly done 2026-06-20** — `+0x02` owner, `+0x03`
   flags (`0x02` taught / `0x04` mission / `0x08` visited / `0x40` event), `+0x05`
   missionary profession, `+0x07` trespass counter, `+0x0A+power·2` alarm
   (`natives.md` §2/§6).
