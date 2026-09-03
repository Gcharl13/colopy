# Save / Load

> **Layer 2 — Specification (population stub).** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R. Details pending — breadth pass.

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
    market arrays. Several offsets **B**; the PowerRecord fields below are byte-verified in `docs/DATA_MODEL.md` — `crosses_per_turn` @`+0x10`, `artillery_bought_count` @`+0x1e` (read×100 `IMUL ax,[bx+0x1e],0x64` @0x035124/0x03527B, `INC [bx+0x1e]` @0x035282, zeroed `MOV [bx+0x1e],0` @0x03662F — byte-confirmed), `royal_money` (s32) @`+0x22`, gold @`+0x2A`, market arrays @`+0x4C`/`+0x5C`/`+0x7C`/`+0xBC`/`+0xFC`. **B.**
  - **ColonyRecord**: stride `0xCA` (BYTE_VERIFIED, `docs/DATA_MODEL.md`). The
    building field is **NOT at `+0x60`** (that is the per-colonist job-duration
    nibble array) — it is the **48-bit TIER-PACKED struct at `+0x84..+0x89`**,
    LSB-first bit groups per building chain, each group's low bit number equal
    to the chain's first `@BUILDING` index: fortification(3@0) armory(3@3)
    docks(3@6) town_hall(3@9) school(3@12) warehouse(1@15) unused(1@16)
    stables(1@17) custom_house(1@18) printing(2@19) weaver(3@21) tobacco(3@24)
    rum(3@27) capitol(2@30) fur(3@32) carpenter(2@35) church(2@37)
    blacksmith(3@39); a tier value t marks the chain's first t entries built.
    Layout per `smcol_sav_struct.json`; **EMPIRICALLY pinned 2026-08-08**: the
    COLONY02 census save's Jamestown bytes `00 02 20 09 89 00` decode
    bit-exactly to the build list the engine's own picker offers
    (`census3_build_picker`). Also: `custom_house_flags` u16 `@+0x8A` (bit i =
    good i exported), `hammers` u16 `@+0x92`, `building_in_production` byte
    `@+0x94` (0xFF = none; Jamestown 0x06 = Docks = the picker's highlighted
    row), `warehouse_level` byte `@+0x95`, `depletion_counter` `@+0x97`,
    `hammers_purchased` u16 `@+0x98`, stock u16[16] `@+0x9A`,
    rebel dividend/divisor s32 `@+0xC2`/`+0xC6`. **B** (capture-pinned).
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

#### After block 43: the MAP PLANES + trailing blocks — BYTE_VERIFIED 2026-08-07

The 43-block table above is not the end of the file. The serializer's tail
(`@0x73938..0x73A1D`) writes, through the far-pointer stream verb
`0x1A1F:0xC9C` (size = `[0x180]/[0x182]` = the w·h dword for the planes):

| # | source | size | content |
|---|--------|------|---------|
| 44 | `[0x15C]` | w·h | **terrain plane** (the .MP layer-1 byte format) |
| 45 | `[0x160]` | w·h | **improvement plane** (road bit 0x08, plow 0x40, + other bits) |
| 46 | `[0x164]` | w·h | resource/region plane |
| 47 | `[0x168]` | w·h | **per-power fog plane** (bit `1<<(power+4)` = explored) |
| 48–49 | `0x86F6` / `0x85E8` | 0x10E each | pathfinding/region scratch |
| 50–51 | `0x945E` / `0x85C8` | 0x20 each | AI word arrays |
| 52 | `ss:[bp-6]` | 4 | **Amendment 2026-09-02** — a stack local: the serializer reseeds the C runtime RNG just before (`0x181f:0x4ca` = `func_00C31C` → `func_00C2F8`: timer `0xc0c:0x12` `& 0x7FFF` → `srand 0xd1d:0xdf2` @0x073A21..@0x073A2A) and writes the 4 bytes at `[bp-6]` @0x073A2D..@0x073A3C. Opaque (0x7285D172 in nine shipped saves); preserved verbatim. |
| 53 | `DGROUP 0x8D80` | 4 | **Amendment 2026-09-02** — the plot/skill seed base (@0x073A45..@0x073A53; loader @0x0741F6). COLONY00.SAV carries **1410965** — exactly the value the ports pin on load (`G.plotSeedBase`), so that pin is now byte-backed. |
| 54 | `DGROUP 0x190` | 2 | **Amendment 2026-09-02** — the map-detail salt (@0x073A5C..@0x073A6A; loader @0x074211). COLONY00.SAV carries **19129** (low nibble 9, as the census measured); the ports still pin 1657 — see RULINGS 2026-09-02j, follow-up row in REMAINING_WORK. |
| 55 | `0x1B22:0000` | 0x378 | **Amendment 2026-09-02** — the **trade-route table**, 12 × 0x4A records (@0x073A73..@0x073A83 via the far-pointer verb `0x1A1F:0xC9C`; loader mirror @0x07422C..@0x07423D, `0x1A1F:0xCB4`). Active count = globals `[0x53A0]` (g+0x20). Layout per `trade_routes.md` §2 (note: `+0x21` is the stop **count**). Both ports decode/encode it (C3.7). |

The trailing tail is therefore 2·0x10E + 2·0x20 + 4 + 4 + 2 + 0x378 = **1502 bytes**
(measured in all ten shipped saves). The earlier "the file ends at block 51" reading
missed the four writes after @0x073A1D.

Validated against all ten shipped `COLONY0#.SAV` (tools/dosbox_harness/game/):
header + version 73 + 58×72 + the four planes account for the file sizes
exactly; the terrain plane's tile histogram matches AMER2-family maps.

**Two field-label corrections from that validation** (both cross-checked
against the game the live 1653 captures came from):
- **PowerRecord `+0x4C` is the CURRENT PRICE array** (16 bytes, the live bid
  per good) — the js-dos "market_sensitivity" gloss does not fit the values,
  which reproduce the 1653 game's market exactly.
- **ColonyRecord `+0x20` is the per-colonist CURRENT-JOB array** (`@JOB` row,
  one byte per colonist, parallel to the `+0x40` specialty array; 28 = no
  specialty). Jamestown-1653's ten bytes decode to its exact worker roster
  (2 Farmers, Sugar Planter, 2 Lumberjacks, Distiller, Fisherman, Fur Trader,
  Carpenter, Statesman).
- **Off-map coordinates** in a UnitRecord (e.g. 231,231) are the engine's
  "in Europe / high seas" state: such ships carry their passengers as
  co-located rider records.
- **The off-map coordinate is FIVE states, not one — DECODED 2026-08-20.**
  The record stores `x == y == BASE + power` (power = the owner nibble), and
  the base says *where in the Atlantic*:

  | base | meaning | evidence |
  |------|---------|----------|
  | `0xEC` | **in Europe** (harbour + dock) | BYTE-VERIFIED at three independent sites, all testing `unit.x - power == 0xEC`: `func_042138` `@0x0421EF` (per-power recount, into `[power-0x6BA6]` `@0x0421F6`), the immigration accumulator `@0x035E01`, the REF/war sweep `@0x058B8F` |
  | `0xF0`, `0xF4` | **bound for Europe** ("Expected Soon") | BYTE-VERIFIED: `func_042138` recounts BOTH into the *other* per-power counter `[power-0x6BAA]` (`@0x042455` / `@0x04243F`) — the one the sail-for-Europe path increments `@0x041B2F` before stamping `UnitRecord+0x07 = 0x45` `@0x041B6D`. `COLONY00.SAV`'s only `0xF4`-class record (#31) carries exactly that `0x45`. |
  | `0xE4`, `0xE8` | **bound for the New World** ("Bound For …") | CAPTURE-VERIFIED for `0xE4`: the Dutch Galleon at `x == y == 0xE7 == 0xE4 + 3` (record #56) is drawn by the running game under "Bound For New Netherlands" with its three riders aboard, on a screen that simultaneously reads "No Ships In Port" (`docs/screens/census/baseline/census_EUROPE.png`). `0xE8` is the remaining slot and its direction follows from the pairing — **FLAGGED**, it has no site of its own. |

  **Still TBD:** the progress ORDER within each pair (`0xE4` vs `0xE8`,
  `0xF0` vs `0xF4`). A restored crossing is therefore given a full crossing
  timer in the port rather than a guessed remainder.

The HTML port's `importSav()` (port/src/game.js) walks this whole layout and
restores a shipped save into the playable rebuild; `port/tools/test_flow.py`
asserts the 1653 game's figures field by field.

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
- **Slots and the option-driven autosave — Amendment 2026-09-02 (C3.6, BYTE_VERIFIED).**
  Filename builder `func_072C78(buf, n)`: `strcpy("COLONY")` (0x20E2) @0x072C7B,
  `0x181f:0xe9a(buf, n, width 2)` = `func_00C362` zero-padded @0x072C92, `strcat(".SAV")`
  (0x20E9) @0x072C97 ⇒ `COLONY%02d.SAV`. Slot picker `func_072CC2(key, count)` (thunk
  `0x1A1F:0xCE8`): rows 0..count−1 (@0x072ED5..@0x072EDC), a missing file shows `(EMPTY)`
  (0x20EE @0x072F0C) with valid byte `[0xA60C+n]=0` @0x072F20. **SAVE dialog `func_072F7A`
  calls it with `(SAVEGAME, 8)` @0x072F7E — eight manual slots 00..07; LOAD dialog
  `func_073158` with `(LOADGAME, 0xA)` @0x073161 — ten rows 00..09**, an invalid row refused
  @0x073190. The Game-Options **Autosave** bit `[0x5383]&4` (@0x0058D7 and @0x005A29, gate
  `[0x829]==0` unread) calls `func_005642` @0x005642..@0x005667, which pushes **8** when
  `year%10==0 && [0x538C]==0 && turn>2` (the decade boundary) **else 9** and saves through
  `0x181f:0x5b6` (`func_072CA4`) — **one save per turn, slot 8 or 9, never both**. The slot
  **10** save @0x005AF3 is gated on `[0x104]!=0` (set @0x02F55F beside `or [0x5382],8` and
  @0x070D96, cleared @0x005826) — an event save, not the per-turn one — and slot **5**
  @0x005BDB is the game-end save. So the old "slot 10 = the rolling autosave" gloss below
  is corrected: the rolling autosave is slot 9 (8 on decades). What a present picker row
  displays (`0x1a1f:0xd04` header reader) is TBD.
- **HALLFAME.DAT format — BYTE_VERIFIED** (`func_03ADA6`, file `0x3ADA6`): the
  file is **5 records × 42 bytes (`0x2A`) = 210 bytes (`0xD2`)** — confirmed by the
  `fread` length `@0x3ADCF` (C runtime `fopen`/`fread`/`fclose` =
  `0xD1D:0x4DA`/`0x528`/`0x3F4`). Each 42-byte record = a **24-byte name** (`+0x00`,
  NUL-terminated; first byte 0 = empty slot) **+ ~8 score words** (`+0x18..`). The
  writer reads the 5 existing records, inserts the new candidate as a 6th in-memory
  slot, keeps the top 5, and writes back `@0x3AE04..0x3AE43`. (Corrects
  `docs/DATA_MODEL.md`'s "1362 bytes" — that is the *function* size, not the file
  size.) The per-word score fields' meanings are **RESOLVED (see §6.5)**: the writer `func_03ADA6` treats exactly ONE word as the ranking score — the signed `int16` at record `+0x26` (`MOV ax,[bx+0x26]; CMP [bp+si-0xda],ax; JL` insertion-sort @0x3AECD..0x3AEDC, where stack base `[bp-0x100]`+0x26 = `[bp+si-0xda]`); every other field is display metadata. **Field roles CAPTURE-PINNED 2026-08-07** (two crafted-DAT rounds rendered live, `docs/screens/live_2026-08-07/hof_*.png` — this corrects the earlier static reading "+0x22 nation / +0x24 year"): name string @`+0x00`; **nation index @`+0x18`** (doubles as the empty sentinel, init 0xffff, `CMP[bp+si-0xe8],0;JL` empty-test — a valid nation 0..3 passes, 0xffff fails); **declared-independence flag @`+0x1a`** (draws the "Free " prefix and the "General, Continental Army" career); **independence-won flag @`+0x1c`** ("President, <@INDEPENDENT[nation]>", wins over the General line); **year @`+0x1e`** ("to A.D. <year>"); `+0x20` undisplayed; **difficulty @`+0x22`** (Discoverer…Viceroy title word); **score points @`+0x24`** ("Score: N"); **`+0x26` = the Colonization Rating %** ("--- Colonization Rating: N% ---") and the sole ranking key (func_03ADA6 @0x3AED0); `+0x28` undisplayed. (The old "nation @+0x22 SHL 1 → power-name table @0x3B16E" walk mis-identified the field: the render proves +0x22 selects the Discoverer…Viceroy title word, so the @0x3B16E string table is the difficulty-title list by inference from the capture — the disasm window has not been re-read.)
- **The complete 43-block sequence — READ 2026-08-07** (parsed mechanically from the
  annotated `save_serializer` disasm; the fixed tail sums to exactly the 727 bytes the
  port's importer skips, cross-checking both). Each row is one `fwrite(ptr, size, 1, f)`;
  variable blocks scale by the count words in the globals block:

  | # | DGROUP | size | # | DGROUP | size | # | DGROUP | size |
  |---|--------|------|---|--------|------|---|--------|------|
  | 0 | `[0x81A]` copy | 2 | 15 | 0x9410 | 4 | 30 | 0x918C | 0x40 |
  | 1 | 0x853A | 4 (map w/h) | 16 | 0x9180 | 4 | 31 | 0x9572 | 0x40 |
  | 2 | 0x5380 | 0x8E (globals) | 17 | 0x9414 | 4 | 32 | 0x944E | 8 |
  | 3 | 0x540E | 0xD0 | 18 | 0x9418 | 4 | 33 | 0x336 | 1 |
  | 4 | 0x948E | 0x18 | 19 | 0x941C | 8 | 34 | 0x9184 | 8 |
  | 5 | 0x5D46 | ncol·0xCA | 20 | 0x9424 | 4 | 35 | 0x9622 | 8 |
  | 6 | 0x3144 | nunit·0x1C | 21 | 0x9428 | 4 | 36 | 0x962A | 8 |
  | 7 | 0x8808 | 0x4F0 (powers) | 22 | 0x942C | 4 | 37 | 0x91CC | 0x80 |
  | 8 | 0x54EC | nvill·0x12 | 23 | 0x924C | 0x4C | 38 | 0x8540 | 2 |
  | 9 | 0x5AD6 | 0x270 (tribes) | 24 | 0x947E | 0x10 | 39 | 0x853E | 2 |
  | 10 | 0x9566 | 0xC | 25 | 0x95F2 | 0x10 | 40 | 0x184 | 2 |
  | 11 | 0x8CFC | 4 | 26 | 0x94A6 | 0x40 | 41 | 0x17C | 2 |
  | 12 | 0x9298 | 4 | 27 | 0x94E6 | 0x40 | 42 | 0x17E | 2 |
  | 13 | 0x9408 | 4 | 28 | 0x95B2 | 0x40 | | (map planes follow) | |
  | 14 | 0x940C | 4 | 29 | 0x9526 | 0x40 | | | |

  Because block 2 is the raw globals dump, the engine's once-flags sit at fixed offsets
  inside it: **`g+0x06` = `[0x5386]`** (the SHARED flags word — low three bits the sound
  switches, upper bits the tutorial step-shown guards; the "sound mirror" and "tutorial
  mask" readings coexist, which also re-reads the `0x0E` new-game seed as sound-defaults-ON,
  not "three steps pre-shown"), **`g+0x5A..0x60` = `[0x53DA/DC/DE/E0]`** REF
  Regulars/Cavalry/Man-O-War/Artillery, **`g+0x8A` = `[0x540A]`** the woodcut shown-bitmask.
  The port's importer restores all three verbatim (2026-08-07).

  **Three more globals fields identified 2026-08-17** by transcribing the
  new-game initialiser `func_0755CC` (`viceroy_source/src/boot/page1A_boot_newgame.c`),
  which writes the whole block from scratch and so names each field by how it is
  seeded:

  | Field | Seeded at new game | Reading |
  |---|---|---|
  | **`g+0x29..0x41`** (25 bytes) | `memset(0x53A9, 0xFF, 0x19)` `@0x757CB` | **Founding-Father owner array** — one byte per father, `0xFF` = unelected. 25 == `DAT_FATHERS_COUNT`, and the fixtures settle it: `savstart` is 25x`0xFF`, while `sav1653` and `savraleigh` carry a mix of `00/01/02/03` (the owning power) and `0xFF`. |
  | **`g+0x6A..0x89`** (16 words) | `random_int(600, 1000)` per entry `@0x7564B` | **the market's per-good price pool.** `0x53EA` has only three references in the binary — this seed, a read `@0x305B8` and a subtract `@0x30639`, both inside the market module. Per pass `func_0305A8` computes `total = pool[i] + Σ_p clamp0(PowerRecord[p]+0xFC+4i)` and does `pool[i] -= total >> 7`, i.e. the pool decays toward −Σ at 1/128 per pass; a second phase `@0x3070D` maps it onto `price_level` (+0x4C) for goods 0..12. See the 2026-08-17b ruling. |
  | **`g+0x27` / `g+0x28`** | `0` `@0x757D3` / `random_int(1, 8)` `@0x757E4` | the king-anger pair already documented in `spec/systems/scoring.md` — this adds their **initial conditions**. Anger starts at 0; its companion counter starts at a random 1..8 (fixtures: 5, 3, 8), which reads more like a scheduled countdown than a plain tally. Does not overturn the existing phase-multiplexed reading. |

  The same function independently confirms the block base and four known
  offsets: `[0x5386]` -> `g+0x06` (written `0x0E` `@0x755EB`), `[0x53DA/DC/DE/E0]`
  -> `g+0x5A..0x60` (the REF counts), `[0x540A]` -> `g+0x8A` (cleared with a
  4-byte `memset` `@0x75688`). It also pins the start of play — year **1492**
  (`0x5D4` `@0x757E7`), turn 0 — and the REF sizing from difficulty *d*:
  **Regulars 8d+15, Cavalry 5(d+1), Artillery 6d+2, Man-O-War 3d+2**
  (`@0x7569B..0x756D0`), which match `cport/core/colopy_newgame.c` exactly —
  an independent confirmation of numbers the port reached through the JS.
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
computed at render time inside `func_06E3D0`.** RESOLVED-AS-STATE: the absolute pixel positions are
genuine runtime values, not static byte-immediates — `func_06E3D0` (modal pump, file `0x6E3D0..0x6E4CD`)
operates on the window struct passed by far ptr `[bp+6]`, reading the window origin live from
`es:[bx+0x80]` (x) / `es:[bx+0x82]` (y) (`PUSH es:[bx+0x82]; PUSH es:[bx+0x80]; CALL 0x6cd66`
@0x6E45F..0x6E469) and adding the per-row content delta `es:[bx+0x46]` to form the row Y
(`ADD ax, es:[bx+0x46]; MOV [bp-8], ax` @0x6E472..0x6E476), then driving the row draw/hit-test
calls (0x6BE92/0x6BF12/0x6BF3C/0x6BF66) off that struct. So the layout source is fully documented:
the window-geometry fields in the run-time window object built by `func_06F0F4` (template interpreter)
are the inputs; `func_06E3D0` derives x/y/row-height from them at render time. A static x/y/line-height
triple does not exist in the EXE to extract. **B** (renderer + geometry-field reads byte-cited).

## 5. Evidence
- `docs/SAVE_FORMAT_CROSSREF.md` — DGROUP↔SAV record cross-reference; reorder caveat. **B/R**
- `data_extracted/viceroy_strings.txt:1032` — `.SAV` at file 0x1FA89. **B**
- `docs/COLONY_RENDER_CHAIN.md:263` — COLONY.SAV filename builder at 0x1FA82. **B**
- `docs/DATA_MODEL.md` — ColonyRecord/PowerRecord/UnitRecord runtime layouts. **B**

## 6. Open questions
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

## Amendment 2026-09-03 — the four trailing fields, by offset (C3.8)

Tail offsets after the planes (`2·0x10E + 2·0x20 = 604`): `[bp−6]` RNG
residue 4 B @604, `[0x8D80]` plot base 4 B @608, `[0x190]` map salt 2 B
@612, the 0x378 route block @614 — the loader reads them in that order
(`fread(0x8D80, 4)` @0x0741F6..0x07420C, `fread(0x190, 2)` @0x074211..
0x074225, the route block @0x07422C). Both ports read `[0x190]` at load and
the C writes it back (RULINGS 2026-09-03i1). COLONY00.SAV carries
`[0x8D80]` = 1410965 and `[0x190]` = 19129.
