# Memory Records — Runtime Record Types

> **Layer 2 — Data Specification (population stub).** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R.

**Canonical primary:** `docs/DATA_MODEL.md` (runtime/byte-verified record layouts — CANONICAL for the full field maps). This stub is an index: it pins each record's base/stride and a few byte-verified anchor fields, then points to `docs/DATA_MODEL.md` for everything else. **Do not duplicate the full field tables here** — confirm any offset at its cited read site in `docs/DATA_MODEL.md` before tagging.

## 1. Summary

VICEROY.EXE keeps per-entity state in four primary fixed-stride record arrays in DGROUP, plus secondary tables (TribeData, market state) catalogued in `docs/DATA_MODEL.md`. Each array has a constant base address and a constant per-record stride; the active colony is reached indirectly through a far pointer at `[0x8542]`.

## 2. Contents

| Record | Base (DGROUP) | Stride | Count | A few BYTE_VERIFIED fields (→ full map in `docs/DATA_MODEL.md`) | Tier |
|--------|---------------|--------|-------|----------------------------------------------------------------|------|
| **PowerRecord** | `0x8808` (`0x8809` in field table) | `0x13C` = 316 | 12 (0..3 EU, 4..11 tribes) | `+0x21` gold (dword), `+0x25` total_loot, `+0x29` treasury, `+0x06` attribute bitfield, boycott u16 `+0x20`, market bytes `+0x4C..+0x5B` | **B** |
| **ColonyRecord** | active via `[0x8542]` far ptr | `0xCA` = 202 | ~50 | `+0x1A` owner_power_idx, `+0x1B` foreign-status, `+0x1C` status-flags byte (B), `+0x1F` size, stockpile `+0x9A` 16×u16 | **B** (stride/anchors); the unmapped intra-record gaps are per-colony **runtime BSS** (loaded from the save), not static constants |
| **UnitRecord** | `0x3144` | `0x1C` = 28 | 300 max | `+0x00` map_x, `+0x01` map_y, `+0x02` unit_type (@UNIT idx), `+0x03` power\|flags, `+0x17` class/profession | **B** (base `0x3144` per RULINGS 2026-05-28 / §4 below; the old `0x3146`-as-base with `+0x07` map_x was superseded — `0x3146` is the *type* field at `+0x02`, and `0x314D/0x314E` is the goto-target, not map_x/y) |
| **NativeSettlement** | `0x54EC` | `0x12` = 18 | per-village | `+0x04` population (CHIEFKILL size_byte), `+0x08` last_bought | **B** |

> PowerRecord appears as base `0x8808` (record-array head) and `0x8809` (first field) in `docs/DATA_MODEL.md`; both are present there. Stockpile/SoL dividend-divisor/colonist-job offsets are NOT pinned here — read them at the `docs/DATA_MODEL.md` cited site.

Power index ordering (0..3 = Dutch/English/French/Spanish per NAMES `@COUNTRY`; 4..11 = tribes per NAMES `@TRIBES`) is given in `docs/DATA_MODEL.md`; see also `spec/data/names_sections.md`.

## 3. Evidence

- `docs/DATA_MODEL.md` — all four bases/strides BYTE_VERIFIED (PowerRecord via SMITE/raze/king-tax/combat; ColonyRecord via adjacent records Jamestown@0x5D46 / Quebec@0x5E10 diff=0xCA + memory inspection 2026-05-05; UnitRecord via 652+ `[reg+0x3146]` refs + runtime cross-validation; NativeSettlement via CHIEFKILL trace). **B**
- Active-colony pointer `[0x8542]` (102 refs per anchor_map). **B/A**
- `spec/systems/colony.md` — consuming spec for ColonyRecord. **B/R**

## 4. Open questions

1. ~~ColonyRecord field map.~~ **Mostly resolved 2026-06-20** — SoL dividend/divisor
   `+0xC2`/`+0xC6` (B, `colony.md`); `+0x1C` = per-colony **status-flags** byte (not
   const 0x40); `+0x92`/`+0xB6` hammers; `+0x84` constructed mask; `+0x95` warehouse
   level (`warehousing.md`); `+0x9A` 16-slot stockpile (good `i` at `+0x9A+i·2`); `+0x1A`
   owner; `+0xA4` Lumber slot. **B** (load-bearing fields). Deep-interior pass
   2026-06-27 (all sites confirmed colony-pointer-relative, `bx`/`si` from `[0x8542]`):
   `+0x1D` = flags byte, bit `0x80` only (`test [bx+0x1d],0x80` `@page_0E 0x551D8`,
   set `or …,0x80 @0x55C20`, clear `and …,0x7f @0x55A2F`) — distinct from the `+0x1C`
   status byte; `+0x1E` = byte countdown counter gated by `+0x8E` (`cmp [bx+0x1e],0`
   then `dec [bx+0x1e]` `@page_0D 0x4D9C7`, 14 sites); `+0x96` = byte counter with
   inc/dec (`inc [bx+0x96] @page_02 0x2C244`, `dec @page_10 0x5C474`, read
   `@page_0E 0x557ED`); `+0xBA` **CONFLICT RESOLVED** — it is a **4-entry per-power
   byte flag array (idx 0..3) init to 1**, paired with `+0xBE` (init 0), in the
   colony-reset loop `@page_03 0x2ED7A` (`add bx,[0x8542]; mov byte [bx+0xba],1`) and
   conditional `@0x2EDAD` (`mov byte [bx+si+0xba],1`) — **not** the hammers field, so
   the dump's "hammers@+0xBA" label is wrong (build uses `+0x92`/`+0xB6` per
   `colony.md`). **B**. Residual fields (exhaustive accessor sweep 2026-06-27, both
   resident `disasm/` and all 31 overlay pages, colony-pointer taint-tracked from
   every `mov/add bx|si|di,[0x8542]`):
   - `+0xBC` = **element [2] of the `+0xBA` 4-byte per-power flag array** (NOT a
     separate field). The reset loop `@page_03 0x2ED73` runs `[bp-6]` 0..3 with
     `bx=[bp-6]+[0x8542]` and stores `mov byte [bx+0xba],1` `@0x2ED7A` (and the
     paired `mov byte [bx+0xbe],0` `@0x2ED7F`), so bytes `+0xBA/+0xBB/+0xBC/+0xBD`
     are all written = 1; the conditional `mov byte [bx+si+0xba],1 @0x2EDAD` (si=0..3)
     re-asserts per index. Live snapshot `colony_live_1505.bin` confirms
     `+0xBA..+0xBD = 01 01 01 01` for every active colony (00 in empty slots).
     **B** (writer-traced) / **A** (oracle-confirmed) — the dump's "hammers@+0xBA"
     label was already corrected above; `+0xBC` is simply array slot 2.
   - `+0x24` (u16) and `+0x99` (byte): **no static reader or writer exists** via the
     colony pointer anywhere in VICEROY.EXE (zero colony-relative `[0x8542]`-tainted
     hits; the `[bx+0x24]` / `[bx+0xbc]` arithmetic sites in pages 03/04/06/17 are all
     based on `[0x84fc]` = active-PowerRecord, not ColonyRecord — different struct).
     Live read (`colony_live_1505.bin`, ColonyRecord_base `0x5D46`, stride `0xCA`):
     both = 0 across all 5 active colonies AND all empty slots — apparent unused/zero
     padding in this mid-game capture. No EXE byte left to decode; a future write-path
     (none found) or a game-state where they go non-zero would be needed to assign
     meaning. **A** (oracle: constant-zero, no accessor).
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
