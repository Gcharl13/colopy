# Save / Load

> **Layer 2 — Specification (population stub).** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R/TBD. Details TBD — breadth pass.

**Overall confidence:** **full SAV format `BYTE_VERIFIED`** (2026-06-20) — orchestrator
`func_072F7A`, serializer `func_0734F8` (the **43-block on-disk sequence**, §3), loader
`func_073BB0`, magic `"COLONIZE"`+`0x1A`, **no compression**, **autosave** to slot 10
from the turn loop — plus **HALLFAME.DAT layout** `BYTE_VERIFIED` (42-byte records,
score `int16` @ `+0x26` = the scoring.md composite; §6.5). No residual.
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
    market arrays. Several offsets **B**; the formerly **NEW/TBD** PowerRecord fields are now byte-verified in `docs/DATA_MODEL.md` — `crosses_per_turn` @`+0x10`, `artillery_bought_count` @`+0x1e` (read×100 `IMUL ax,[bx+0x1e],0x64` @0x035124/0x03527B, `INC [bx+0x1e]` @0x035282, zeroed `MOV [bx+0x1e],0` @0x03662F — byte-confirmed), `royal_money` (s32) @`+0x22`, gold @`+0x2A`, market arrays @`+0x4C`/`+0x5C`/`+0x7C`/`+0xBC`/`+0xFC`. **B.**
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
- **PowerRecord per-field reordering — RESOLVED (no reordering).** The load path
  `func_073BB0` reads the PowerRecord region as a single raw `fread(0x8808, 1, 0x4f0, FILE)`
  (`@0x73D54..0x73D5F`, `0xD1D:0x528`), the exact mirror of the writer's raw
  `fwrite(0x8808, 1, 0x4f0, FILE)` (`@0x735EE..0x735F7`, `0xD1D:0x60C`). The whole `0x4F0`
  block goes DGROUP→disk→DGROUP verbatim with no intervening transform call, so the
  `SAVE_FORMAT_CROSSREF` "reordered vs runtime" claim is **refuted**: within a PowerRecord,
  disk byte order = runtime byte order. (Symmetry is total: the serializer issues **43×**
  `fwrite` `0xD1D:0x60C`, the loader **43×** `fread` `0xD1D:0x528`, one per DGROUP block.) **B.**
- **HALLFAME.DAT format — BYTE_VERIFIED** (`func_03ADA6`, file `0x3ADA6`): the
  file is **5 records × 42 bytes (`0x2A`) = 210 bytes (`0xD2`)** — confirmed by the
  `fread` length `@0x3ADCF` (C runtime `fopen`/`fread`/`fclose` =
  `0xD1D:0x4DA`/`0x528`/`0x3F4`). Each 42-byte record = a **24-byte name** (`+0x00`,
  NUL-terminated; first byte 0 = empty slot) **+ ~8 score words** (`+0x18..`). The
  writer reads the 5 existing records, inserts the new candidate as a 6th in-memory
  slot, keeps the top 5, and writes back `@0x3AE04..0x3AE43`. (Corrects
  `docs/DATA_MODEL.md`'s "1362 bytes" — that is the *function* size, not the file
  size.) The per-word score fields' meanings are **RESOLVED (see §6.5)**: the writer `func_03ADA6` treats exactly ONE word as the ranking score — the signed `int16` at record `+0x26` (`MOV ax,[bx+0x26]; CMP [bp+si-0xda],ax; JL` insertion-sort @0x3AECD..0x3AEDC, where stack base `[bp-0x100]`+0x26 = `[bp+si-0xda]`); every other field is display metadata, NOT a score term: name string @`+0x00`, validity/empty sentinel @`+0x18` (init 0xffff, `CMP[bp+si-0xe8],0;JL` empty-test), independence/SCORED flags @`+0x1a`/`+0x1c`, nation index @`+0x22` (`SHL 1` → power-name table `[bx-0x7c6c]` = DGROUP 0x8394, @0x3B16E), year @`+0x24`. So the only scoring field is the composite at `+0x26` (func_03ADA6 @0x3AED0).
- Any compression on the save: **RESOLVED — none.** The loader `func_073BB0` is a 1:1
  mirror of the writer: it makes exactly **43× raw `fread`** (`0xD1D:0x528`), one per DGROUP
  block, with no decompression/transform pass (the only other stream calls are a single
  `fopen` `0xD1D:0x4DA` and the map-dimension `memcpy` `0xD1D:0xD82`). Each block is read
  back into its original DGROUP base at its full stride, matching the writer's **43× raw
  `fwrite`** (`0xD1D:0x60C`). Verbatim dump in, verbatim dump out ⇒ **no compression**. **B.**

## 4. UI
Save/Load menu with 10 user slots + 2 autosave slots (manual).

**Layout is data-driven, not coded — RESOLVED-AS-TEMPLATE 2026-06-25.** The picker is *not*
laid out by code immediates; it is built from a **`GAME.TXT` dialog template** (section
`@SAVEGAME` / `@LOADGAME`) parsed at runtime. Traced chain (page 0x1A → 0x17/0x18, see
`notes/ATTRIBUTION_OVERLAY.md`): the prompt orchestrators `func_072F7A` (save) /
`func_073158` (load) call the **slot-list builder `func_072CC2`**, which creates the window
(window-create thunk `0x191F:0x182` → `func_06F0F4`, the **generic dialog-template
interpreter**), enumerates `COLONY*.SAV` slots, and appends one list item per slot
(`'(EMPTY)'` when the file is absent) via the add-row primitive (`0x191F:0x176` →
`func_06C850`). The modal pump `func_06E3D0` (run-picker thunk `0x191F:0x16a`) draws the
linked-list rows and hit-tests the mouse; teardown frees the window (`0x191F:0x1a8` →
`func_0789FA`). The `@SAVEGAME`/`@LOADGAME` templates specify essentially only the prompt +
width; **x / y / row line-height are omitted, so the window is auto-centered and per-row Y is
computed at render time inside `func_06E3D0` — these absolute pixel positions are therefore
runtime-derived (TBD), not byte-immediates.** (The exact template keyword offsets in
`func_06F0F4` are pending re-verification — an automated proposal over-specified two of them.)

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
5. ~~Per-word **HALLFAME.DAT score-field** meanings within the 42-byte record.~~ **DONE
   2026-06-21.** The hall-of-fame manager `hall_of_fame_table` reads/writes **HALLFAME.DAT**
   as **raw, uncompressed `0xD2`-byte (210) blocks = 5 records × `0x2A` (42) bytes** (`fread`/
   `fwrite` `1,0xD2`); up to 6 records held (`HALLFAME_MAX`), 5 shown. Within each 42-byte
   record the **ranking field is a signed `int16` score at `+0x26`** — the *only* field the
   manager compares: a new entry is **insertion-sorted descending** (`slot_score < new_score`
   ⇒ shift the tail down and `memcpy` the 42-byte entry in, `@hall_of_fame_table`). That
   `+0x26` score **is the composite end-game score** (the `scoring.md` total: colonists +
   liberty/SoL + gold + founding fathers + the additive revolution bonus). The record's
   leading bytes (`+0x00…`) hold the **player/colony display name** (string), with the
   remaining bytes carrying display metadata (rank/nation) — *not* additional score terms.
   So the score-field semantics are resolved: **one `int16` score @ `+0x26` = the scoring.md
   composite**; the rest of the 42 bytes is the name + vanity metadata, no hidden mechanic.
   Source: `hall_of_fame_table` (string-handle I/O; sort key `+0x26` byte-confirmed). **B.**
