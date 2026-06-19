# Save / Load

> **Layer 2 — Specification (population stub).** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R/TBD. Details TBD — breadth pass.

**Overall confidence:** **SAV orchestrator + serializer + magic + on-disk table
strides `BYTE_VERIFIED`** (`func_072F7A`/`func_0734F8`, verified vs EXE) +
**HALLFAME.DAT layout** `BYTE_VERIFIED`; per-field *order within* PowerRecord/SAV
body `TBD`.
**Canonical primary:** `docs/SAVE_FORMAT_CROSSREF.md`, `docs/DATA_MODEL.md`
(record layouts), `data_extracted/viceroy_strings.txt` (`.SAV` @ 0x1FA89).

## 1. Purpose & behavior
The game serializes runtime DGROUP state to an on-disk save file. The save is
"largely a serialization of the runtime DGROUP state, so the field names match
closely." (`docs/SAVE_FORMAT_CROSSREF.md` claims a *reordered* field layout, but the
byte-verified serializer `func_0734F8` writes each table's **raw in-memory block** at
full stride — see §3; treat the "reordered" claim as unconfirmed.) There are 10 save
slots plus two autosave slots (`docs/GAME_MANUAL.md`). **R** (slot count from manual).

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

### SAV save path — **BYTE_VERIFIED** (verified vs EXE 2026-06-19)
- **Orchestrator `func_072F7A`** (file `0x72F7A`, page 0x1A, gated by the `SAVEGAME`
  key `@0x72F80`): opens the slot dialog, builds the filename, calls the driver.
- **Filename** (`func_072C4E`): `strcpy("COLONY")` (`@file 0x1FA82`) + slot digit +
  `strcat(".SAV")` (`@0x1FA89`) → `COLONY<slot>.SAV`. **B.**
- **Serializer `func_0734F8`** (file `0x734F8`, ENTER 6; reached via `0x1A1F:0xCF6`):
  writes the **magic `"COLONIZE"`** (`@file 0x1FB1A`) + a **Ctrl-Z `0x1A`** terminator,
  in mode `"wb"`, then dumps the four game-state tables **each at its full in-memory
  stride** (no trimmed subset) — byte-verified from the `imul count,stride; push` /
  base-`push` operands:

  | Table | Base (push) | Count | Stride | On-disk bytes | Site |
  |-------|-------------|-------|--------|---------------|------|
  | ColonyRecord | `0x5D46` | `[0x539E]` | `0xCA` (202) | count·202 | `@0x735BD` |
  | UnitRecord | `0x3144` | `[0x539C]` | `0x1C` (28) | count·28 | `@0x735DF` |
  | PowerRecord | `0x8808` | 4 (fixed) | `0x13C` (316) | `0x4F0` = 1264 | `@0x735F7` |
  | NativeSettlement | `0x54EC` | `[0x539A]` | `0x12` (18) | count·18 | `@0x73619` |

  So the **colony `0xCA`-vs-`0xAE` question is RESOLVED**: the disk record is the full
  `0xCA` stride (the `0xAE` at `*(0x8542)` is a working buffer, not the saved record).
- **Load deserializer `func_073BB0`** (file `0x73BB0`) — mirror read path.
- Corroborated by `viceroy_source/src/save/{save_serializer,load_deserializer}.c`
  (other branch); the offsets/strides above are re-verified against this branch's EXE.
- **Remaining `TBD`:** the per-field *byte order within* a PowerRecord on disk (the
  `SAVE_FORMAT_CROSSREF` "reordered vs runtime" claim is **not** supported by
  `func_0734F8`, which writes the raw `0x13C` block — re-confirm whether any
  reordering happens elsewhere); compression (none seen).
- **HALLFAME.DAT format — BYTE_VERIFIED** (`func_03ADA6`, file `0x3ADA6`): the
  file is **5 records × 42 bytes (`0x2A`) = 210 bytes (`0xD2`)** — confirmed by the
  `fread` length `@0x3ADCF` (C runtime `fopen`/`fread`/`fclose` =
  `0xD1D:0x4DA`/`0x528`/`0x3F4`). Each 42-byte record = a **24-byte name** (`+0x00`,
  NUL-terminated; first byte 0 = empty slot) **+ ~8 score words** (`+0x18..`). The
  writer reads the 5 existing records, inserts the new candidate as a 6th in-memory
  slot, keeps the top 5, and writes back `@0x3AE04..0x3AE43`. (Corrects
  `docs/DATA_MODEL.md`'s "1362 bytes" — that is the *function* size, not the file
  size.) The per-word score fields' meanings are **TBD**.
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
