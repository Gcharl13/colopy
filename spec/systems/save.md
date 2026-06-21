# Save / Load

> **Layer 2 — Specification (population stub).** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R/TBD. Details TBD — breadth pass.

**Overall confidence:** **full SAV format `BYTE_VERIFIED`** (2026-06-20) — orchestrator
`func_072F7A`, serializer `func_0734F8` (the **43-block on-disk sequence**, §3), loader
`func_073BB0`, magic `"COLONIZE"`+`0x1A`, **no compression**, **autosave** to slot 10
from the turn loop — plus **HALLFAME.DAT layout** `BYTE_VERIFIED`. Only residual:
HALLFAME per-word score-field semantics.
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
- The **on-disk field order, header, and compression** are **RESOLVED (2026-06-20, §3)**:
  header `"COLONIZE"`+`0x1A`; body = **43 raw DGROUP blocks**, **no compression**, **no
  reordering** (each block is a verbatim memory dump, so within a block runtime offset =
  file offset; the `SAVE_FORMAT_CROSSREF` "reordered" claim is refuted by `func_0734F8`).

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

#### Complete on-disk block sequence — BYTE_VERIFIED 2026-06-20

`func_0734F8` writes **43 raw DGROUP blocks** back-to-back via
`fwrite(base, 1, size, FILE)` (`0xD1D:0x60C`), **no compression, no per-field
reordering** — the file is a verbatim dump of these memory regions in this exact
order (the four record tables above are blocks 6–9). So **on-disk offset = the sum of
the preceding block sizes; within a block, layout = the runtime struct.** This
resolves §6.1–6.3.

| # | DGROUP base | size | content |
|---|-------------|------|---------|
| 1 | `[0x081A]` | 2 | save format/version word (after the `"COLONIZE"`+`0x1A` header) |
| 2 | `0x853A` | 4 | map width `[0x853A]` + height `[0x853C]` |
| 3 | `0x5380` | `0x8E` (142) | **game-globals block** (game flags `0x5382`, season/year/turn `0x538A–E`, counts `0x539A–E`, difficulty `0x53A6`, Bolívar/SoL `0x53D0`, REF globals `0x53DA–E0`, …) |
| 4 | `0x540E` | `0xD0` (208) | 4× **AIPersonality** (stride `0x34`) |
| 5 | `0x948E` | `0x18` (24) | AI/diplomacy block |
| 6 | `0x5D46` | `[0x539E]·0xCA` | **ColonyRecords** |
| 7 | `0x3144` | `[0x539C]·0x1C` | **UnitRecords** |
| 8 | `0x8808` | `0x4F0` (1264) | 4× **PowerRecord** (stride `0x13C`) |
| 9 | `0x54EC` | `[0x539A]·0x12` | **NativeSettlements** |
| 10 | `0x5AD6` | `0x270` (624) | **TribeData** (`@TRIBES` runtime table) |
| 11 | `0x9566` | `0xC` (12) | `@LEADERNAME` AI-bias triplets (4×3) |
| 12 | `0x8CFC` | 4 | per-power word |
| 13 | `0x9298` | 4 | per-power **colony count** |
| 14 | `0x9408` | 4 | per-type **REF value** array (the `BSS` table — saved, so 4-element runtime) |
| 15–23 | `0x940C`/`0x9410`/`0x9180`/`0x9414`/`0x9418`/`0x941C`(8)/`0x9424`/`0x9428`/`0x942C` | 4 each | per-power AI/economy word arrays |
| 24 | `0x924C` | `0x4C` (76) | AI state block |
| 25–26 | `0x947E`/`0x95F2` | `0x10` (16) each | AI arrays |
| 27–32 | `0x94A6`/`0x94E6`/`0x95B2`/`0x9526`/`0x918C`/`0x9572` | `0x40` (64) each | per-power AI matrices |
| 33 | `0x944E` | 8 | AI word array |
| 34 | `[0x0336]` | 1 | flag byte |
| 35–37 | `0x9184`/`0x9622`/`0x962A` | 8 each | AI word arrays |
| 38 | `0x91CC` | `0x80` (128) | AI matrix |
| 39–40 | `0x8540`/`0x853E` | 2 each | current-colony / map-cursor words |
| 41–43 | `[0x0184]`/`[0x017C]`/`[0x017E]` | 2 each | viewport/scroll words |

(Sites: blocks at `@0x7353C..0x73929`; variable counts via `imul [count],stride`.)

- **Load deserializer `func_073BB0`** (file `0x73BB0`) — mirror read path (same block order).
- **Autosave — BYTE_VERIFIED 2026-06-20.** The serializer is also reached via the
  filename-arg helper **`func_072CA4`** (`0x181F:0x5B6`), called **7×**, four from the
  main turn loop `func_005760`. The primary autosave (`@0x5AF3`) writes **slot `0xA`
  (10)** — gated by the autosave-enable flag `[0x826]==0` (`@0x5AD7`), the game-running
  gate `[0x53C2]` (`@0x5ADE`), and a **periodic check** (`[0x104]` after `0x181F:0x61E`
  `@0x5AE5`). A second turn-loop save (`@0x5BDB`, slot `5`) fires near **game-end**
  (gated on `[0x82B]`, the forced-1725-end flag). So: **slots 0–9 = manual** (chosen in
  the `SAVEGAME` dialog), **slot 10 = the rolling autosave**.
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
1. ~~Locate the SAV write/read function and decode the file header + field order.~~
   **Done 2026-06-20** — serializer `func_0734F8`, loader `func_073BB0`; header =
   `"COLONIZE"`+`0x1A`; field order = the **43-block sequence** in §3. **B.**
2. ~~Determine whether the SAV is compressed.~~ **Done — no compression** (raw `fwrite`
   of each DGROUP block, §3). **B.**
3. ~~Map runtime record offsets to their on-disk positions per record type.~~ **Done
   2026-06-20** — disk offset = Σ preceding block sizes; within a block, layout = the
   runtime struct (no reordering; the `SAVE_FORMAT_CROSSREF` "reordered" claim is
   refuted). Full table in §3. **B.**
4. ~~Autosave trigger conditions and slot rotation.~~ **Done 2026-06-20** — turn-loop
   autosave to **slot 10** (`@0x5AF3`, gated `[0x826]==0` / `[0x53C2]` / periodic
   `[0x104]`); manual slots 0–9; near-game-end save gated on `[0x82B]` (§3). **B.**
5. Per-word **HALLFAME.DAT score-field** meanings within the 42-byte record (the only
   SAV-family residual; layout is **B**, field semantics **TBD**).
