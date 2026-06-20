# Native Relations

> **Layer 2 — Specification (population stub).** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R/TBD. Details TBD — breadth pass.

**Overall confidence:** NativeSettlement base/stride + a few offsets + **mission-conversion mechanism (incl. RNG bound 0..15) + CHIEFKILL treasure roll + native-raid dispatch** `BYTE_VERIFIED`; **attitude bands (−5/0/10 → Content/Uneasy/Restless/Angry; War=alarm≥128) + alarm storage `BYTE_VERIFIED`**; **mission-doubler (missionary unit+5 bit0x10) + CHIEFKILL roll→gold (→ `+0x2A`) + settlement `+0x02`/`+0x03` fields `BYTE_VERIFIED`**; trade logic + per-action alarm-raise deltas (in thunk `0x181F:0x30C`) `TBD`. **Canonical primary:** `docs/DATA_MODEL.md` NativeSettlement; `data_extracted/text/NAMES_sections.json` `@TRIBES`/`@ATTITUDE`/`@ATTITUDINAL`/`@LEVELS`/`@MISSION`; `data_extracted/text/GAME_sections.json` native keys.

## 1. Purpose & behavior
Native tribes occupy settlements the player can trade with, send missionaries to, learn skills from, demand tribute from, or attack. Tribe attitude escalates Content → Uneasy → Restless → Angry → War as the colonial presence grows, unless soothed by trade and tribute. Razing a settlement (CHIEFKILL) can yield treasure scaled by its population. **RECONSTRUCTED** (manual §"Indian Lore" + byte-cited CHIEFKILL).

## 2. State & data
`NativeSettlement` base `DGROUP:0x54EC`, **stride 18 (0x12)**.

| Field | Type | Meaning | Tier | Evidence |
|-------|------|---------|------|----------|
| +0x00 | u8 | `map_x` | **BYTE_VERIFIED** (runtime) | `docs/DATA_MODEL.md`: matches dispersal templates |
| +0x01 | u8 | `map_y` | **BYTE_VERIFIED** (runtime) | `docs/DATA_MODEL.md` |
| +0x02 | u8 | **owner tribe / nation id** | **BYTE_VERIFIED** | `[bx+0x54EE]` owner-match scans `@0x37638`/`@0x45D11`/`@0x46078` |
| +0x03 | u8 | **flags** (bit `0x04` in active use; capital/special marker, exact label TBD) | **BYTE_VERIFIED (field)** | set `@0x66225` `or [bx+0x54EF],4`; test `@0x43DC4`/`@0x46E05`; init 0 `@0x46EA7` |
| +0x04 | u8 | `population` (size byte, feeds CHIEFKILL) | **BYTE_VERIFIED** | `docs/DATA_MODEL.md` §CHIEFKILL: size_byte from `NativeSettlement[+0x04]` |
| +0x08 | u8 | per-nation `last_bought` | **ANCHOR_VERIFIED** | `docs/DATA_MODEL.md` |

`@TRIBES` (NAMES, **BYTE_VERIFIED present**): the 8 active tribes carry `name, adj, gift-good, level, sprite#`: Incas(Jewelled Relics,3,97), Aztecs(Gold Bars,2,149), Arawaks(1,54), Iroquois(1,87), Cherokee(1,67), Apache(0,111), Sioux(0,118), Tupi(0,71); plus name-only reserve tribes.

`@ATTITUDE` (5): Content, Uneasy, Restless, Angry, War. `@ATTITUDINAL` (5): Extremely, Very, Rather, Somewhat, Slightly. `@LEVELS` (5): Semi-Nomadic/Camp, Agrarian/Village, Advanced/City, Civilized/City, `<Any>`/Capital. `@MISSION` (4): mission-name prefixes. **All BYTE_VERIFIED present.**

## 3. Formulas & rules
- **Raze treasure (CHIEFKILL)** — `func_04A7CA` (file `0x4A7CA`). **Roll mechanism
  BYTE_VERIFIED** (2026-06-19): the attacker's class byte `UnitRecord +0x15 == 0x16`
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
  - on success a **convert unit is created at the colony** — thunk `0x181F:0x95C` @`0x5735F` is passed `ColonyRecord +0x00`/`+0x01`/`+0x1A` (map_x / map_y / owner); its returned `UnitRecord` index then gets **`+0x15 (class) = 0x1B`** (`MOV byte[bx+0x315B],0x1B` @`0x57374`). That `0x1B` class is the same "convert/special" colonist the colony-production formula gives a +1 staple bonus (see `colony.md` §3 `is_special`).
  - the `@INDIANSCONVERT` popup (tribe name `[0x8D52]`) is shown only to a **human European** owner (`[bp+6] < 4` and `AIPersonality[+0x543F].controller == 0`), thunk `0x191F:0x19C` @`0x57344`.
  - **Doubler RESOLVED 2026-06-20:** `cl = byte[[0x8D4A]+5]` of the **missionary
    unit record** (`@0x572DE`). Its **low nibble = owning power** (`& 0xF`, compared to
    `[bp+6]` `@0x572EA`); **bit `0x10` doubles the convert chance** (`test cl,0x10;
    shl ax,1` `@0x57300`). So the doubler is a **per-missionary attribute flag**
    (high nibble of unit+5) — almost certainly the **expert/Jesuit missionary** bit
    (the mechanism is byte-verified; the exact bit *label* stays TBD).
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
- **Tribe attitude/demand evaluator — BYTE_VERIFIED (2026-06-20)** (a separate
  per-tribe evaluator reading the active tribe-data record's fields `+2` and `+5`,
  `diff=[0x53A6]`): the human and AI take **different formulas**, making native
  friendliness a difficulty handicap —
  - **Human player** (`controller==0`, `@0x46500`):
    `attitude = 2·(diff+3) + tribe[+2] + tribe[+5] − prior` = `2·diff + 6 + …`,
    compared to threshold `0x41`.
  - **AI power** (`@0x46538`): `attitude = tribe[+2] + tribe[+5] − diff + 12 − prior`,
    threshold `0x32`.

  So at higher difficulty the human faces a **higher (worse)** native-attitude value
  while the AI faces a **lower (better)** one. (`tribe[+2]`/`tribe[+5]` are the
  `@TRIBES` per-row level/value columns; cross-ref `spec/data/tables.md`.) **B.**
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
  *magnitudes* are still TBD, but the applier + its French/Pocahontas halving gates
  are now **B**. (The 39-word row stride — only the first 4 columns = the powers are
  used here — remains **TBD**.)
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
  through `func_045DF2`'s tail (`jmp 0x46000` `@0x45F03`): **3 = relations cooling**
  (paired with −1), **5 = heating** (paired with +1), **0 = silent/generic**. The
  exact category enum at the `0x46000` emitter tail and the upstream computation of
  the mission/incite *variable* deltas remain the residual.
- **Native trade pricing — BYTE_VERIFIED (2026-06-20).** Buy price (`@0x5C976`):
  `floor = 5·difficulty + 50`; the offer is `max(floor, 2·PowerRecord.tax_pct)`
  (`@0x5C985`) then **capped at 90 (`0x5A`)** (`@0x5C9A3`); the floor applies only
  when the per-power attribute bit `(0x0A, power) == 0` (`@0x5C96A`). A successful
  trade lowers tension by 4 (`@0x5C41E`) and bumps the settlement's wealth/goodwill
  bytes `+0x07`/`+0x08`/`+0x0A` (`@0x5C3E4`). Tribute-gold *amount* table still **TBD**.

## 4. UI
Native dialogs use `@CHIEF*` / `@VILLAGE*` / `@INDIAN*` / `@MISSION*` GAME keys (e.g. `@CHIEFHOWDY @CHIEFGIFT @CHIEFKILL @VILLAGEHAPPY @INDIANTREATY`). Action menu from `@ACTIONS`. See `docs/SESSION_UI_CATALOG.md`.

## 5. Evidence
- `docs/DATA_MODEL.md` — NativeSettlement base `0x54EC` stride 18; +0x00/+0x01 pos, +0x04 population (CHIEFKILL), +0x08 last_bought; raze `func_04A7CA`. **B/A**
- `data_extracted/text/NAMES_sections.json` — `@TRIBES @ATTITUDE @ATTITUDINAL @LEVELS @MISSION`. **B (present)**
- `data_extracted/text/GAME_sections.json` — native dialog keys present. **B**
- `func_0572E6` (file `0x572E6`) — mission conversion: roll-gated success, convert-unit creation at the colony, `UnitRecord +0x15 = 0x1B`, `@INDIANSCONVERT` popup. **B**

## 6. Open questions (TBD)
1. ~~Fill the 18-byte NativeSettlement record.~~ **Mostly done 2026-06-20** —
   `+0x00/+0x01` pos, `+0x02` owner tribe, **`+0x03` flags (bit `0x04`=mission
   present, `0x08`=visited/greeted, `0x40`=event-eligible)**, `+0x04` population,
   **`+0x05` resident-missionary profession byte** (feeds the `cl&0x10` doubler),
   **`+0x07` trespass/escalation counter** (set `0xFE` on trespass `@0x4A337`, bumped
   on trade `@0x5C3F2`), `+0x08` last_bought, **`+0x0A+power·2` per-power alarm word**
   (raid ≥128 / hostile ≥75), `+0x1A` a coord/index. Remaining interior bytes **TBD**.
2. ~~CHIEFKILL treasure roll + roll→gold.~~ **Done** — the `random_int(0,40·scout+100)`
   roll is the village-escape check; the **raze gold** = `(Σ3×random(1,10−diff)) ×
   random(1,6) × 4 × (tribe_id+1)` → `+0x2A` (`@0x4AAD0..0x4AB66`, **B**, §3).
3. ~~Trace native trade pricing.~~ **Done 2026-06-20** — buy `max(5·diff+50,
   2·tax)` cap 90 (`@0x5C976..0x5C9A3`, **B**, §3). Remaining: explicit **tribute-gold
   amount** formula (TBD).
4. ~~Mission conversion `cl&0x10` doubler.~~ **Done** (expert/Jesuit missionary bit;
   mechanism **B** §3); exact bit *label* still TBD.
5. **[Resolved — B]** **TribeData `+0x46+power·2`** = per-power native **alarm/attitude seed**
   (`func_065D26 @0x65DA6`): `random_int(0,14) + (2·difficulty` **iff the power is
   human**, `controller==0` `@0x65DC7`; AI gets +0), saturating at 20. So the human
   starts each tribe more alarmed at higher difficulty (handicap). **B** (formula);
   "alarm seed" label **R**.
