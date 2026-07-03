# Native Relations

> **Layer 2 — Specification (population stub).** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R. Details pending — breadth pass.

**Overall confidence:** NativeSettlement base/stride + a few offsets + **mission-conversion mechanism (incl. RNG bound 0..15) + CHIEFKILL treasure roll + native-raid dispatch** `BYTE_VERIFIED`; **attitude bands (−5/0/10 → Content/Uneasy/Restless/Angry; War=alarm≥128) + alarm storage `BYTE_VERIFIED`**; **mission-doubler (missionary unit+5 bit0x10) + CHIEFKILL roll→gold (→ `+0x2A`) + settlement `+0x02`/`+0x03` fields `BYTE_VERIFIED`**; **trade pricing (`max(5·diff+50, 2·tax)` cap 90, func_05C878 @0x5C976) + per-action tension deltas (applier func_045DF2 via thunk `0x181F:0xD6C`, delta table §3) `BYTE_VERIFIED` (RESOLVED — see §3)**. **Canonical primary:** `docs/DATA_MODEL.md` NativeSettlement; `data_extracted/text/NAMES_sections.json` `@TRIBES`/`@ATTITUDE`/`@ATTITUDINAL`/`@LEVELS`/`@MISSION`; `data_extracted/text/GAME_sections.json` native keys.

## 1. Purpose & behavior
Native tribes occupy settlements the player can trade with, send missionaries to, learn skills from, demand tribute from, or attack. Tribe attitude escalates Content → Uneasy → Restless → Angry → War as the colonial presence grows, unless soothed by trade and tribute. Razing a settlement (CHIEFKILL) can yield treasure scaled by its population. **RECONSTRUCTED** (manual §"Indian Lore" + byte-cited CHIEFKILL).

## 2. State & data
`NativeSettlement` base `DGROUP:0x54EC`, **stride 18 (0x12)**.

| Field | Type | Meaning | Tier | Evidence |
|-------|------|---------|------|----------|
| +0x00 | u8 | `map_x` | **BYTE_VERIFIED** (runtime) | `docs/DATA_MODEL.md`: matches dispersal templates |
| +0x01 | u8 | `map_y` | **BYTE_VERIFIED** (runtime) | `docs/DATA_MODEL.md` |
| +0x02 | u8 | **owner tribe / nation id** | **BYTE_VERIFIED** | `[bx+0x54EE]` owner-match scans `@0x37638`/`@0x45D11`/`@0x46078` |
| +0x03 | u8 | **flags** — bit `0x04` = **Capital** marker (set once per tribe during settlement generation; doubles/boosts a per-settlement metric), bit `0x01` = unit-removal marker (write-only, no consumer) | **BYTE_VERIFIED** | bit `0x04` SET `@0x66225` `or [bx+0x54EF],4` (preceded by `imul bx,ax,0x12` settlement stride, gated `[bp-0xd0]` reset after each set → 1 per tribe; oracle confirms 1/tribe — see §6.1); TESTed `@0x07DCA` (func_007D3E: `imul bx,[bp-0x10],0x12; test [bx+0x54ef],4` then **doubles** value `shl [bp-0x18],1` + sets `[0x8d02]` bit 0x20 = capital defense/value bonus), `@0x46E05` (func_046DE0: adds `level+1` bonus when set), `@0x43DC4`, `@0x04051`; init 0 `@0x46EA7` |
| +0x04 | u8 | `population` (size byte, feeds CHIEFKILL) | **BYTE_VERIFIED** | `docs/DATA_MODEL.md` §CHIEFKILL: size_byte from `NativeSettlement[+0x04]` |
| +0x08 | u8 | per-nation `last_bought` | **ANCHOR_VERIFIED** | `docs/DATA_MODEL.md` |

`@TRIBES` (NAMES, **BYTE_VERIFIED present**): the 8 active tribes carry `name, adj, gift-good, level, sprite#`: Incas(Jewelled Relics,3,97), Aztecs(Gold Bars,2,149), Arawaks(1,54), Iroquois(1,87), Cherokee(1,67), Apache(0,111), Sioux(0,118), Tupi(0,71); plus name-only reserve tribes.

`@ATTITUDE` (5): Content, Uneasy, Restless, Angry, War. `@ATTITUDINAL` (5): Extremely, Very, Rather, Somewhat, Slightly. `@LEVELS` (5): Semi-Nomadic/Camp, Agrarian/Village, Advanced/City, Civilized/City, `<Any>`/Capital. `@MISSION` (4): mission-name prefixes. **All BYTE_VERIFIED present.**

## 3. Formulas & rules
- **Raze treasure (CHIEFKILL)** — `func_04A7CA` (file `0x4A7CA`). **Roll mechanism
  BYTE_VERIFIED** (2026-06-19): the attacker's class byte `UnitRecord +0x17` (abs `0x315B`) `== 0x16`
  (**Seasoned Scout**) sets a bonus flag `scout∈{0,1}` (`@0x4A7D9`); the settlement
  **size** `sz` is fetched via thunk `0x181F:0x30C` (`@0x4A7F2`, `[bp-0x22]`). Then:
  - **normal path** (`sz < 0x4B = 75`): treasure roll = `random_int(0, 40·scout + 100)`
    (`@0x4A81A`: `bp-2 = scout·0x28 + 0x64`, `@0x4A827` roll); for `sz ≥ 0x19 = 25`,
    the roll is **rejected and re-rolled while `sz/4 ≥ roll`** (`@0x4A832..0x4A841`) —
    so larger settlements bias toward larger treasure;
  - **tribe == 2** special: bound `= (8 − difficulty[0x53A6]) << scout` (`@0x4A84A`);
  - `sz ≥ 75`: a distinct big-treasure branch (`@0x4A802 → 0x4AB72`).

  So the magnitude is a **Seasoned-Scout-boosted, size-biased random** roll. **B
  (roll mechanism).** **Roll→gold RESOLVED 2026-06-20:** the `random_int(0,40·scout+100)`
  roll `@0x4A827` is the **village-survives/escape** check (vs alarm `[bp-0x22]`,
  `@0x4A97A`), **not** the payout. The raze **treasure gold** is computed in the raze
  branch `(Σ 3×random_int(0,10−diff)) × random_int(0,6) × 4 × (TribeData[+2]+1)`
  (`@0x4AAD0..0x4AB35`) and **credited directly to the attacker's gold** `PowerRecord
  +0x2A` (32-bit `add/adc` at `@0x4AB66`, `[bx−0x77CE]` = `0x8832` = `+0x2A`). No
  ×100, no treasure-unit for this path.
- **Mission conversion** — `func_0572E6` (file `0x572E6`, "INDIANSCONVERT"). **BYTE_VERIFIED mechanism:**
  - success is gated by a roll: `threshold = TribeData[+2] + 2` (`[0x8D4E]` = active TribeData), **doubled** if a flag bit (`cl & 0x10`) is set; the roll is **`random_int(0, 15)`** (bound `0x0F` `@0x5730A`, thunk `0x181F:0x4D4` `@0x5730E`); convert **fails if `roll ≥ threshold`** (`@0x57316`). So **P(convert) = (TribeData[+2]+2)/15**, doubled to `2·(…)/15` when `cl & 0x10`. **BYTE_VERIFIED bound.**
  - on success a **convert unit is created at the colony** — thunk `0x181F:0x95C` @`0x5735F` is passed `ColonyRecord +0x00`/`+0x01`/`+0x1A` (map_x / map_y / owner); its returned `UnitRecord` index then gets **`+0x17 (class, abs 0x315B) = 0x1B`** (`MOV byte[bx+0x315B],0x1B` @`0x57374`). That `0x1B` class is the same "convert/special" colonist the colony-production formula gives a +1 staple bonus (see `colony.md` §3 `is_special`).
  - the `@INDIANSCONVERT` popup (tribe name `[0x8D52]`) is shown only to a **human European** owner (`[bp+6] < 4` and `AIPersonality[+0x543F].controller == 0`), thunk `0x191F:0x19C` @`0x57344`.
  - **Doubler RESOLVED 2026-06-20:** `cl = byte[[0x8D4A]+5]` of the **missionary
    unit record** (`@0x572DE`). Its **low nibble = owning power** (`& 0xF`, compared to
    `[bp+6]` `@0x572EA`); **bit `0x10` doubles the convert chance** (`test cl,0x10;
    shl ax,1` `@0x57300`). **Bit `0x10` LABEL RESOLVED 2026-06-25 (B):** the same
    `byte[[0x8D4A]+5]` is given bit `0x10` by `or [bx+5],0x10` @`0x48C81` (with
    `bx = [0x8D4A]`), gated by `has_father(0x16, power)` — thunk `0x181F:0x7B4`
    with arg `0x16` and `[bp+8]` @`0x48C71`, taken only when the call returns
    nonzero (`or ax,ax; je` @`0x48C79`). Founding father `0x16` = **Jean de
    Brebeuf** (`@FATHERS` row 0x16, Religious category — a Jesuit). So the doubler
    is the **Jean de Brebeuf founding-father bonus**, set on the active
    convert-context record `[0x8D4A]`, NOT a per-missionary profession bit.
- **Native raid on colony** — `func_05BE84` (file `0x5BE84`). **BYTE_VERIFIED:** the
  6 raid outcomes are the message keys `RAIDWREAK` (`@0x5C1DE`), `RAIDSTORES`
  (`@0x5C3CC`), `RAIDBURN` (`@0x5C50B`), `RAIDSHIP` (`@0x5C57B`), `RAIDGOLD`
  (`@0x5C5F7`), `RAIDNOTHING` (`@0x5C637`) — i.e. raze havoc / steal stores / burn a
  building / sink a docked ship / steal gold / no effect. Selection: a **gate roll**
  `random_int(1,12)−1` `@0x5BEFD` (biased `+(difficulty−2)` for a human-European
  owner `@0x5BF1A`) vs threshold `3·K+1` `@0x5BEE5`; a **base outcome**
  `random_int(1,4)` `@0x5BF35` adjusted by turn/difficulty (`turn < 40·(2−diff)`
  downgrades `@0x5BF44`) and per-outcome availability gates (thunk `0x181F:0x9FC`);
  a **5-way dispatch** `@0x5C026` (`dec ax` ladder) — **outcome→key now
  BYTE_VERIFIED** (verified vs EXE): outcome **1 → `@RAIDSTORES`** (loot cargo, sfx
  `0x4F`, `@0x5C3CC`), **2 → `@RAIDWREAK`** (`@0x5C1DE`), **3 → `@RAIDGOLD`** (sfx
  `0x4E`, `@0x5C5F7`), **4 → `@RAIDBURN`/`@RAIDSHIP`** family, **0 → `@RAIDNOTHING`**
  (sfx `0x5B`, `@0x5C637`). The STORES branch also bumps the target settlement's
  raid-budget `+0x08` (`@0x5C3E1`) and wealth `+0x0A` (`+= 0x19 @0x5C3E4`) — the same
  fields the tribe-death redistribute uses. **B.**
- **Per-power alarm/tension storage — BYTE_VERIFIED.** Each settlement holds a
  **word of alarm per European power** at `NativeSettlement +0x0A + power·2`
  (`= DGROUP 0x54F6 + (settlement·9 + power)·2`, since stride `0x12` = 9 words;
  reconciles with `docs/DATA_MODEL.md` "+0x0A..+0x11 alarm[4]"). Indexed in the
  native AI via `[unit+0x314A]·9 + power` (`@0x4734E`).
- **War / raid threshold — BYTE_VERIFIED: alarm ≥ `0x80` (128).** When a settlement's
  alarm toward a power reaches 128 the natives treat that power as hostile —
  byte-verified at the raid-target scan (`@0x04734E`) and the colony-placement
  desirability gates (`@0x04CAD7`, `@0x053D4E`) which all test `cmp [..+0x54F6],0x80`.
- **Attitude bands — BYTE_VERIFIED** (settlement attitude builder, `@0x048B62..0x048B90`,
  the func in page_0C that reads the current settlement `[0x8D4A]` and pushes
  `MISSION0` `@seg 0x1532`). A per-settlement colonial-presence **score** `[bp-0x2E]`
  (built from colony proximity + founding-father conversion metrics, then `8·X−5`
  `@0x048AFE`) is banded into a level **0..3** at cutoffs **−5 / 0 / 10**:

  | score | level | `@ATTITUDE` |
  |-------|-------|-------------|
  | `< −5` | 0 | **Content** |
  | `−5 … 0` | 1 | **Uneasy** |
  | `0 … <10` | 2 | **Restless** |
  | `≥ 10` | 3 | **Angry** |

  The 5th level **War (4)** is the separate **alarm ≥ 128** raid state above.
  `@ATTITUDINAL` intensity {Extremely, Very, Rather, Somewhat, Slightly} modifies the
  displayed phrase. The exact composition of the presence score `X` (`[bp-0x2C]`) is
  multi-term and not fully decomposed, but the **band cutoffs are byte-verified.**
- **Native LAND-PRICE evaluator `func_0464C2` — CORRECTED 2026-07-03 (was
  misread as a "tribe attitude vs threshold" evaluator).** The two branches
  previously described here (`@0x46500` human / `@0x46538` AI) are the two arms
  of the **`@INDIANLAND` land-price computation**, and the `0x41`/`0x32`
  constants are **`imul` price multipliers** (`imul [bp-2]` `@0x4658A`), *not*
  comparison thresholds. Reading the active tribe-data record's fields `+2` and
  `+5` (the `@TRIBES` per-row **level**/**value** columns, cross-ref
  `spec/data/tables.md`; `diff=[0x53A6]`):
  - **Human player** (`controller==0`, `@0x464F5`):
    `score = 2·(diff+3) + tribe[+2] + tribe[+5] − dist`, unit price `0x41` (65).
  - **AI power** (`@0x46538`): `score = tribe[+2] + tribe[+5] − diff − dist + 12`,
    unit price `0x32` (50).

  Then: prime resource on the tile → `score ×2` (`@0x46576`); clamp
  `score ≥ 1` (`@0x4657C`); `price = score × unit`; CAPITAL settlement →
  `+50%` (`@0x465C5`); Peter Minuit (FF index 2, the `0x7b4(power,2)` gate
  `@0x465D5`) → `0`; final halving (`@0x465E6`). The difficulty handicap
  stands, but as a **price**: at higher difficulty the human pays **more**
  per demanded plot while an AI power pays **less**. **B** (shape + anchors);
  the per-power prior-deduction operand (`[bx−0x6bf0]`, `@0x4654C`) and the
  human-path `(X+1)` distance multiply (`@0x465A1`) remain unidentified, **R**.
  See `spec/systems/difficulty.md` §3.
- **Thunk `0x181F:0x30C` is a table GETTER, not the delta computer — CORRECTED
  2026-06-20.** It resolves (Type-B) to **file `0x0082A0`**: a 2-arg accessor
  `return word[DGROUP:0x5B1C + (row·39 + col)·2]` (`imul bx,[bp+6],0x27; add
  bx,[bp+8]; shl bx,1; mov ax,[bx+0x5b1c]`). 48 callers across the native-AI
  cluster (`0x4Axxx`). In the **raid scan `func_047320`** it is called per power
  `col = 0..3` (row `[bp-0x42]`) and the returned value is compared to **`75`
  (`0x4b`)** (`@0x47328`): a per-`(tribe-row, power)` **tension/relationship**
  value with a **hostility threshold of 75** — a *parallel, distinct* signal from
  the `+0x54F6` alarm array (settlement·9 + power, threshold **128**, checked in
  the very next block `@0x4734E`). Both raise a per-power hostility tally
  (`[bp-0x86]`) + bitmask. The thunk only **reads** the `0x5B1C` tension table; its
  **writer/applier is `func_045DF2`** (below, range `[0,100]`). The per-action delta
  *magnitudes* are now **BYTE_VERIFIED** (RESOLVED): every call site pushes the literal
  `delta` as the 2nd thunk arg to `0x181F:0xD6C → func_045DF2` (e.g. `PUSH -1`/`PUSH +1`
  @0x48574/@0x4859E, `PUSH -4` @0x5C414), enumerated in the per-action-events table
  below (func_045DF2 @0x045DF2); the applier + its French/Pocahontas halving gates
  are **B**. **39-word row stride — columns 4..38 RESOLVED-as-unused (2026-06-26).**
  `dgroup_xrefs.json` shows exactly **3** references to the `0x5B1C` base — getter read
  `@0x0082AC`, applier read `@0x045E57`, applier write `@0x045E6C` — and **every** one of
  the getter/applier call sites passes the column as a **European-power id `0..3`** (raid
  scan loop bounds `col < 4` `@0x047365`; a scan of all callers found **0** column
  constants `> 3`). So only **columns 0..3 = the 4 powers** are ever read or written;
  **columns 4..38 are never accessed by any committed code path — not even an
  orphan-overlay AI func** (so this is *not* AI-GATED — there is no consumer at all). The
  oracle confirms the region past col 3 holds unrelated/overlapping DGROUP bytes (65535
  runs, not a `[0,100]` meter), so the 39-word stride is an **over-allocation**: the live
  tension table is effectively `[settlement-row][power 0..3]`.
- **Tension-raise APPLIER — `func_045DF2` BYTE_VERIFIED (2026-06-20).** This is the
  function that applies a tension **delta** to the `0x5B1C` table:
  `tension[row·39 + power] += delta` (delta = arg `[bp+0xa]`), then **clamped to
  `[0,100]`** (clamp helper `func@0x48CC`, `@0x45E4A..0x45E6C`). Two mitigations
  **halve** a positive delta:
  - **French national power** — `if power==1 && delta>0: delta >>= 1` (`@0x45E21`).
  - **Pocahontas (FF 16)** — `if has_father(16,power) && delta>0: delta >>= 1`
    (`@0x45E30`, thunk `0x181f:0x7b4`).
  After the write it raises hostility flags at **tension ≥ 75 (`0x4b`)** and
  **tension == 100 (`0x64`, maxed → war path)** (`@0x45E9E`/`@0x45EB2`), matching
  the raid scan's `≥75` test. So the `0x5B1C` tension is a `[0,100]` per-
  `(settlement-row, power)` anger meter (thresholds 75 hostile / 100 war), separate
  from the `+0x54F6` alarm array (threshold 128).
- **Per-action tension events — BYTE_VERIFIED deltas + characterized bindings (2026-06-20).**
  `func_045DF2` is reached from **33 call sites** via thunk `0x181f:0xd6c`, args
  `(settlement [bp+6], power [bp+8], delta [bp+0xa], category [bp+0xc])`. The
  notable events (delta = **B** from the immediate push; event label from the
  enclosing handler's `@`-string/context):
  | site | delta | cat | event |
  |------|-------|-----|-------|
  | `@0x4857D` | −1 | 3 | per-turn alarm **decay** (when tribe spread byte crosses −8) |
  | `@0x485A7` | +1 | 5 | per-turn alarm **rise** (crosses +8) |
  | `@0x485E7` | −1 | 0 | normalization decay loop |
  | `@0x486F8` | **+100** | 0 | **incite / allegiance shift** vs current player `[0x5398]` (message `@[0x14f6]`) |
  | `@0x04870C` | **−100** | 0 | the paired rival-favor drop (`[0x53d2]`) |
  | `@0x4A2E8` | +1 | 0 | **trespass** minor |
  | `@0x4A319` | +2 | 0 | trespass moderate (sets settlement `+0x07=0xFE`) |
  | `@0x4A674` | +3 | 0 | trespass severe |
  | `@0x5C41E` | −4 | 0 | **successful trade** goodwill (attr-bit-2 gated) |
  | `@0x571EB` | −(neg) | 0 | **mission established** (delta clamped so tension+delta ≤ 70, `@0x571DA cmp ax,0x46;jg`) |
  | `@0x57267` | +(computed) | 0 | **mission destroyed / missionary expelled** |
  | `@0x61B84` | **+100** | 0 | **burial-ground desecration** vs `[0x5394]` (see `events.md`) |
  The **4th arg `category` ([bp+0xc])** is a **news/advisor message class** routed
  by caller convention (−1 push paired with cat 3 `@0x48574`, +1 push paired with
  cat 5 `@0x4859E`): **3 = relations cooling**, **5 = heating**, **0 = silent/generic**.
  **CORRECTED 2026-06-27 (B, reseg):** there is **no `0x46000` emitter tail.** The
  committed disasm of func_045DF2 truncated at 0x45F16; re-capstoning the full body
  `0x45DF2..0x46002` shows `jmp 0x46000` `@0x45F03` is an **intra-function jump to
  func_045DF2's own epilogue** (`0x46000: POP si; LEAVE; RETF`), not a call into an
  emitter. A full disasm of the entire function confirms **`[bp+0xc]` is never read
  by any instruction** (0 accesses in `0x45DF2..0x46002`) — so the `category` 4th arg
  is **pushed by all 33 callers but dropped (dead) by func_045DF2**. The cooling/
  heating/silent meaning is purely a **caller-side label**, carried in the push
  literal, with no consumer in this applier. (The 0x45F16..0x45FFF tail instead does
  alarm-array propagation: it clamps neighbour settlements' `[bx+0x54f6]` words to
  0x20/0x60 and scans by owner `[bx+0x54ee]`.) The upstream computation of the
  mission/incite *variable* deltas (the few non-literal pushes) is the only residual.
- **Native trade pricing — BYTE_VERIFIED (2026-06-20).** Buy price (`@0x5C976`):
  `floor = 5·difficulty + 50`; the offer is `max(floor, 2·PowerRecord.tax_pct)`
  (`@0x5C985`) then **capped at 90 (`0x5A`)** (`@0x5C9A3`); the floor applies only
  when the per-power attribute bit `(0x0A, power) == 0` (`@0x5C96A`). A successful
  trade lowers tension by 4 (`@0x5C41E`) and bumps the settlement's wealth/goodwill
  bytes `+0x07`/`+0x08`/`+0x0A` (`@0x5C3E4`). **Tribute-gold *amount* RESOLVED (see §6.3):**
  the demand (Demand Tribute, func_04AC00) is `raw = [bp-2] − colony_stock[good]` then
  clamped to `[10, min(3·tribe_wealth[0x9E96]+10, 100)]` (func_04AC00 @0x4AE95..@0x4AEB8:
  ceiling 100 @0x4AEA2, floor 10 @0x4AEB0). **B.**

## 4. UI
Native dialogs use `@CHIEF*` / `@VILLAGE*` / `@INDIAN*` / `@MISSION*` GAME keys (e.g. `@CHIEFHOWDY @CHIEFGIFT @CHIEFKILL @VILLAGEHAPPY @INDIANTREATY`). Action menu from `@ACTIONS`. See `docs/SESSION_UI_CATALOG.md`.

## 5. Evidence
- `docs/DATA_MODEL.md` — NativeSettlement base `0x54EC` stride 18; +0x00/+0x01 pos, +0x04 population (CHIEFKILL), +0x08 last_bought; raze `func_04A7CA`. **B/A**
- `data_extracted/text/NAMES_sections.json` — `@TRIBES @ATTITUDE @ATTITUDINAL @LEVELS @MISSION`. **B (present)**
- `data_extracted/text/GAME_sections.json` — native dialog keys present. **B**
- `func_0572E6` (file `0x572E6`) — mission conversion: roll-gated success, convert-unit creation at the colony, `UnitRecord +0x17 = 0x1B` (abs `0x315B`), `@INDIANSCONVERT` popup. **B**

## 6. Open questions
1. ~~Fill the 18-byte NativeSettlement record.~~ **Mostly done 2026-06-20** —
   `+0x00/+0x01` pos, `+0x02` owner tribe, **`+0x03` flags — bit `0x04` = **Capital**
   (RESOLVED 2026-06-26; SET `@0x66225`, consumed `@0x43DC4`/`@0x07DCA`/`@0x46E05`, oracle:
   1 per tribe), bit `0x01` = unit-removal marker — **write-only, NO CONSUMER anywhere
   in VICEROY.EXE (RESOLVED-static 2026-06-27, B).** A full-image opcode scan for every
   instruction touching disp16 `0x54ef` finds exactly **7 sites**: bit `0x01` is SET only
   at `@0x06EDA` (`OR [bx+0x54ef],1`, func_006E94 = UnitRecord array-compaction/removal,
   stride 0x1c REP MOVSW, where `bx = unit[+0x314a]·0x12` = the removed unit's settlement
   index); bit `0x04` is set `@0x66225`, init-zeroed `@0x46EA7`, and TESTed `@0x04051`/
   `@0x07DCA`/`@0x43DC4`/`@0x46E05`. **Bit `0x01` is never read or TESTed by any
   instruction in the whole image** — so its runtime effect (if any) is unrecoverable
   statically; a running-game watch would be needed to observe behaviour.
   The earlier `0x04`=mission-present / `0x08`=visited / `0x40`=event-eligible labels were
   **unverified and are withdrawn** — no code sets or tests `0x54EF` bits `0x08`/`0x40`**,
   `+0x04` population,
   **`+0x05` resident-missionary profession byte** (feeds the `cl&0x10` doubler),
   **`+0x07` trespass/escalation counter** (set `0xFE` on trespass `@0x4A337`, bumped
   on trade `@0x5C3F2`), `+0x08` last_bought, **`+0x0A+power·2` per-power alarm word**
   (raid ≥128 / hostile ≥75), `+0x1A` a coord/index. **Remaining interior bytes RESOLVED-static 2026-06-27 (B):**
   full-image opcode scans show **+0x06 (0x54F2) is NEVER accessed by any instruction**
   (dead/padding), and **+0x09 (0x54F5) is write-only** — set to 0xFF once in the
   settlement initializer (`mov [bx+0x54f5],al`, al=0xFF `@0x46EB6`, alongside +0x07/+0x08
   `@0x46EAE`/`@0x46EB2`) and read by no instruction. So those interior bytes have no
   readable consumer in the static image; the remaining word-fields are the alarm array
   `+0x0A..+0x11` already documented in §3.
2. ~~CHIEFKILL treasure roll + roll→gold.~~ **Done** — the `random_int(0,40·scout+100)`
   roll is the village-escape check; the **raze gold** = `(Σ3×random(1,10−diff)) ×
   random(1,6) × 4 × (tribe_id+1)` → `+0x2A` (`@0x4AAD0..0x4AB66`, **B**, §3).
3. ~~Trace native trade pricing + tribute-gold amount.~~ **Done 2026-06-20** — buy
   `max(5·diff+50, 2·tax)` cap 90 (`@0x5C976..0x5C9A3`, **B**, §3). **Tribute (Demand
   Tribute → `@EXTORT*`, `func_04AC00`):** the gold extorted is **clamped to
   `[10, min(3·tribe_wealth[0x9E96]+10, 100)]`** (`@0x4AE95..0x4AEB8`: ceiling
   `min(3·[0x9E96]+10, 100)`, floor `10`), then added to the player and removed from the
   settlement; emits `@EXTORTSTUFF` (gold) / `@EXTORTPOOR` / `@EXTORTLAUGH` / `@EXTORTNO`
   by outcome. **B** (bounds). The raw pre-clamp demand derives from the settlement's
   stock. ✓ All native `§6` items resolved.
4. ~~Mission conversion `cl&0x10` doubler.~~ **Done — label RESOLVED 2026-06-25 (B):**
   the `[0x8D4A]+5` bit `0x10` is set by `or [bx+5],0x10` @`0x48C81` gated by
   `has_father(0x16, power)` (@`0x48C71`); FF `0x16` = **Jean de Brebeuf** (`@FATHERS`
   row 0x16, Religious/Jesuit). So the doubler is the **Jean de Brebeuf** founding-father
   bonus, not a per-missionary profession bit. Mechanism + label both **B** (§3).
5. **[Resolved — B]** **TribeData `+0x46+power·2`** = per-power native **alarm/attitude seed**
   (`func_065D26 @0x65DA6`): `random_int(0,14) + (2·difficulty` **iff the power is
   human**, `controller==0` `@0x65DC7`; AI gets +0), saturating at 20. So the human
   starts each tribe more alarmed at higher difficulty (handicap). **B** (formula);
   "alarm seed" label **R**.
