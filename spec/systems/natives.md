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
  owner `@0x5BF1A`) vs threshold `3·K+1` `@0x5BEE5`, where **K = the target
  colony's fortification count** — the `push 0; lcall 0x181f,0xab0` @0x5BED9
  resolves to `func_00864E`, the building-chain counter (membership bitset per
  link, next id from `[id·12−0x707A]`), and chain 0 is Stockade→Fort→Fortress
  (RULINGS.md 2026-08-07c; the old "K untraced" TBD is closed); a **base outcome**
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
  trade lowers tension by 4 (`@0x5C41E`); the `@0x5C3E1/@0x5C3E4` writes are
  the TRIBE's arming counters, not settlement wealth (corrected 2026-08-29:
  a raided HORSES load bumps the tribe herd counter `+0x08` and adds 25 to
  the herd word `+0x0A`; raided MUSKETS bump `+0x07`, twice at 50+). **Tribute-gold *amount* RESOLVED (see §6.3):**
  the demand (Demand Tribute, func_04AC00) is `raw = [bp-2] − colony_stock[good]` then
  clamped to `[10, min(3·tribe_wealth[0x9E96]+10, 100)]` (func_04AC00 @0x4AE95..@0x4AEB8:
  ceiling 100 @0x4AEA2, floor 10 @0x4AEB0). **B.**

### The village trade haggle — **BYTE_VERIFIED** (`func_049600`, tail `0x0496BA..0x04A37A` read 2026-08-29)

The whole session, in engine order (session prep `func_048F34` — the 5×5
terrain scan that fills the per-good **want** table `[0x9E58+g·2]` and the
demand copy `[0x9E78]` — stays the port's `villageDemand` reconstruction):

- **Cargo pick**: one laden slot goes straight in; several raise
  `@TRADEWHICH` (`@0x49782..`); cancel ends the session (`@0x49845`). An
  empty hold meets `@DEFICIT` (`@0x49F0E`). AI callers pick a random slot
  (`@0x49749`).
- **Refusals**: settlement `+0x07` == the good → `@BADHAGGLE1`
  (`@0x49976`); want == 0 → `@BADCARGO` naming the want trio and the
  session ENDS (`@0x4996F`). The last-bought check's muskets/horses
  exception compares the **unit index** (`cmp [bp+6],0xf` `@0x49BFD`) —
  an authentic engine bug; the good was meant.
- **The sell offer** (`@0x4999C..@0x49B02`): `mood = random_int(1,5)`;
  `base = 6` (7 for goods ≥ 9), **Trade Goods −random_int(0,7)**
  (`@0x499C3`), **Muskets +12 − tribe counter `+0x07`** (`@0x499D9`),
  **Horses +10 − tribe counter `+0x08`** (`@0x499F0`), **Tools +1**
  (`@0x49A05`); `att = 2·func_008262(tension)` (bands 25/50/75), zero
  for muskets/horses, **halved when want ≥ 20** (`@0x49A34`);
  `offer = max(1, (max(0, 2·(base−diff−att+mood+4)·want) + 5·mood)·qty/100 / 2)`.
  The `@TRADE<n>` body's `%STRING0` is the `@VALUES` ladder row
  `clamp3((want−att+4)/10)` (`@0x49A96`); `%NUMBER1` — the player's "a
  fairer price would be" — is the **ceiling** `(want+1)·4 + offer`
  (`@0x49AD1`), stretched `offer+10` whenever the offer reaches it
  (`@0x49DDC`).
- **The haggle** (`@0x49D76`): budget `= random_int(0,1) + (want−att+4)>>2`
  (`@0x49AB4`). Each "fairer price" answer folds the village while
  `random_int(1, 8·budget) > difficulty` — costing one budget point and
  raising the offer by `max(1, random_int(want/2+1, 2·want+1)·qty/100)` —
  otherwise it **walks away** (`@0x49DFE`): settlement `+0x07` remembers
  the good, tension `+att/2+1`, `@BADHAGGLE0`, session over (the buy
  phase is skipped, `[bp-0xc4]=0`).
- **Acceptance** (`@0x49B80`): gold `+offer`; the goods land in the
  **TRIBE's stock words `+0x0E..+0x2D`** (`@0x49BAC` — there is no
  per-village store); `+0x07` clears to 0xFF; the village alarm word
  drops by the load, a 100-load zeroing it (`@0x49BE4..@0x49BF8`);
  tension credit **−2·remaining-budget** (`@0x49BD0`); muskets ≥25/≥50
  bump `+0x07` once/twice (`@0x49C25`), horses likewise `+0x08` plus
  `herd += qty/4` (`@0x49C46`); `+0x08` = the good (muskets/horses →
  0xFF).
- **The gift row** (round 0 only, `@0x49E4C`): tension credit
  **−4·(budget+1)** (`@0x49E8D`), alarm −2·load (100-load zeroes,
  `@0x49EAC`), one arming tick each (`@0x49ED5`; horses `@0x49EFA` jumps
  into the sale's `+0x08` inc).
- **The buy phase** (`@0x49C72..@0x4A34C`): needs a free cargo slot
  (`@UNIT` cargo column, `@0x49C92`); `+0x07 == 0xFE` (the insult latch)
  → `@BADHAGGLE3`; the sold good outside the top-two wants → `@BRING`.
  `@BUYWHICH` lists the village goods (AI picks the max of the per-power
  value table `[0x84BC+p·16+g]`, `@0x49FBF` — unmodeled). Ships carry a
  **quarter load** (`@0x4A012`). Ask (`@0x4A025..@0x4A0E1`):
  `200` (goods ≥ 8: `(8 − tribe tech +0x02)·50`), silver-up
  `+value·(15+2·diff)`, `+random_int(0,ask)`, **−4·demand**, `+4·tension`,
  `·qty/100`, `+(diff+random_int(0,2))·10`, floor 50. Counter floor
  `max(10, ask/2)`, step `max(1, ask/4)` (`@0x4A15F`). Pay: short →
  `@NOTENOUGH` + tension +1 (`@0x4A24E`); else tribe stock out, `+0x09` =
  the good (rum 9 → 0xFF, `@0x4A1F2`), tension `−random_int(0, ask/25+1)`
  (`@0x4A21D`). Haggle: folds while `random_int(0, demand/25+8) > diff+1`
  and ask > 10 (step down, floor 10, a `1/(8−diff)` chance of tension +1
  `@0x4A2CA`); else tension +2, `+0x07 = 0xFE`, `@BADHAGGLE2`
  (`@0x4A30E`).

Both engines carry the model (JS `tradeSellPick..tradeBuyRound`, C
`colopy_village.c`); the scripted harness still remaps the trade rows to
Cancel, so the path runs only in live play. Settlement `+0x07/+0x08/+0x09`
and the tribe counters/stock are SAV-persisted and imported. **B.**

### Live Among The Natives — the teach skill — **BYTE_VERIFIED** (`func_04A426` + weight builder `func_048F34`, read 2026-08-29; C1.6)
Which skill a village teaches is DETERMINISTIC PER SITE, drawn inside a private
RNG window: the handler builds the weights, calls the clock re-seed
(`0x181F:0x4CA → @0x00C2F8`, its pushed arg ignored), then
`srand(((y<<8) + x + dword[0x8D80]) & 0x7FFF)` (`@0x4A49B..@0x4A4C7`, wrapper
`@0x00C30A`) — the colony-building-layout construct — draws the pick, and the
next `0x4CA` restores clock seeding. Model:

- **Weights** (`func_048F34`, reached via stub `0x1CA24` — the same routine
  that fills the goods-demand table `[0x9E58]`; the teach table is its sibling
  `[0x9E78]`, 16 words = @JOB rows): a 5×5 scan around the settlement
  (interior tiles only, `func_005BFA`), skipping cells its mask marks as
  colony-worked — the colony plot array `+0x70` through
  `lookup_byte_from_pair @0x8956/0x8892` (box coords − 2 against the 20-ring
  tables at `DS:0xC8/0xDE`) plus each colony centre; NOTE the mask arithmetic
  uses village-relative values where colony-box coordinates belong (engine
  quirk, transcribed literally in both ports). Terrain ids per `func_00627A`
  (0x1B mountains / 0x1C hills / 0x18 Arctic / 0x19-0x1A water / 8..0x17
  forested). Written rows: 0 Farmer `((tech+pop+1)·food)/(7−tech)`;
  1/2/3 Sugar/Tobacco/Cotton from crop-terrain counters; 4 Fur Trapper
  `(2·primefur + forest/2)/(tech+1)`; 6 Ore Miner `2·hills+mtn+tundra-ish`
  (tech ≥ 1); 7 Silver Miner `tribe[+0x0C]/settlements + 4·mtn` (8·mtn at
  tech 3; tech ≥ 2; ×1.5 at tech 3 `@0x4A512`); 11 Weaver
  `2·((cotton+tech)>>1)`; 12 Fur Trader `2·((fur+tech)>>1)`. Rows 5, 9, 10,
  13..15 are never written; row 8 is zeroed pre-pick (`@0x4A4CF`). Tech
  gates: tech 0 zeroes 6/12 and halves row 0; tech < 2 zeroes 7/11 and
  ×¾ row 0.
- **Pick** (`@0x4A521`): `random_int(1, Σw)`, subtractive walk.
- **Seasoned Scout**: pick 4 converts to row 0x16 when `(x+y)%3 == 0`
  (`@0x4A56B`).
- **Expert Fisherman**: pick 0 converts to row 8 when `random_int(1,20)` <
  the count of water tiles (`raw&0x1F ∈ {0x19,0x1A}`, `func_0062B4`) over
  the 20-ring (`@0x4A595..@0x4A5EB`).
- **Ladder** (handler order): @LEARNMAD at attitude band > 1 (tension ≥ 50,
  `func_008262`) **and +3 tension via the applier** (`@0x4A669`); criminal
  (0x1A) / convert (0x1B) / not-{0x19 servant, 0x1C free} refusals; the
  taught latch (settlement `+0x03` bit 1, set `@0x4A78A`) blocks only
  NON-capitals (`@0x4A6EE`); the @LEARNSLOW roll
  `random_int(1,1000) < 200·difficulty+100` runs only at band > 0 — a
  content tribe always teaches. GAME keys are composed `"LEARN"+suffix`
  in-EXE (suffix strings `MAD CRIMINAL MASTER ALREADY SLOW LATER DONE` +
  base `LEARN` at DS `0x15E7..0x162A`).
- **LCG**: the runtime is the MSC pair `srand @0x103C2` / `rand @0x103D4`
  (`state·214013+2531011`, top 15 bits) — the same one both ports already
  carry for colony layouts (`ColonyRng` / the plot LCG); loads pin the JS
  seed base to the C's measured `0x795`.
- Both engines: `villageSkill` (JS) / `village_skill` (C). Residual flags:
  tribe `+0x0C`'s writer (glossed "hoard"); `[0x962A]` = per-tribe
  settlement count (usage-consistent, writer unread); both ports track only
  the 8 adjacent worked cells (their colony model), so range-2 worked cells
  never mask. **B.**

### Convert loss of faith — **BYTE_VERIFIED** (`func_02EF64`, `0x191F:0xA58`, read 2026-08-29)
Run per unit from the nation's upkeep pass (`func_02F052 @0x2F0BD`).  A
**convert** unit (type 0 Colonists with profession `0x1B`, `@0x2EF99/@0x2EFA3`)
ticks the record's own **`+0x16` counter** only while all three hold:

1. his coordinates are on the map (`is_xy_in_map_bounds`, `@0x2EF86`);
2. he is **not on a settlement tile** (village-or-colony lookup
   `0x181F:0x6BE` → `func_005FD4`: improve **bit 2**, set by both village
   placement and colony creation `@0x2EBDC`; `@0x2EFB5`);
3. he is **alone** — his tile stack counts fewer than 2 (the chain walker
   `func_0073A8` verb 2, `@0x2EFC9`).

Past **8** qualifying turns (`@0x2EFDA` — the `@DEADCONVERTS` text's own
"eight turns") he is deleted (`0x181F:0x808` `@0x2F00B`) with
`@DEADCONVERTS` (id 0xEE2 = key `@0x1E882`) and a view-center for the human
owner (`@0x2F000`).  An escorted or parked convert keeps his faith
indefinitely, and the timer **survives a save** (it is the SAV's
`turns_worked` byte).  Both engines carry this model; because settled
converts never age, the ports add a shared 100-living-converts conversion
bound (capacity policy, FLAGGED — the DOS pool is finite too, size unread).

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


## Amendment 2026-09-03 — the raid ladder re-read (CORE-B, RULINGS 2026-09-03c)

`func_05BE84(tribe_power, colony, home_settlement, force, attacker_type)`,
called from the combat resolver `@0x5DF5E` when a native attacker beats a
European colony (`[bp-0x9C] == 0`, or forced for Braves vs a human colony
defended by Artillery `@0x5D1A6..@0x5D1D2`). Clock reseed `@0x5BEED` (not
mirrored, RULINGS 2026-09-03b).

- Gate: `roll = random_int(0,12) - 1` (`@0x5BEF9..@0x5BF06`), `+ difficulty
  - 2` for a human owner (`@0x5BF09..@0x5BF21`); `K = 3*func_00864E(0) + 1`
  (chain-0 tiers present); `roll < K && !force` → exit (`@0x5BF32`).
- Outcome `random_int(1,4)` (`@0x5BF35`); softener `@0x5BF44..@0x5BF69`:
  `turn < 40*(2-diff)` and `diff <= 1` and outcome ∈ {2,3} → 0.
- Building gates `@0x5BF6E..@0x5C023` (`0x181F:0x9FC` = has_building):
  out 2: `random_int(0,8) > (human?diff:1)+2` → 1, Fort → 1; out 4:
  Stockade → 1; out 3: Fortress → 0; out 1: Stockade and `random_int(0,8)
  > diff` → 0.
- Ladder (`@0x5C023..@0x5C03B`): **1 STORES, 2 WREAK, 3 SHIP, 4 GOLD, 0
  NOTHING** — §3's "3 → RAIDGOLD, 4 → RAIDBURN/RAIDSHIP" is withdrawn.
- STORES `@0x5C03E..@0x5C0C7` + payload `@0x5C348..@0x5C426` (RULINGS
  2026-09-03c items 6; credit −4). WREAK `@0x5C0CA..@0x5C24F` + payload
  `@0x5C42A..@0x5C52C` (item 7; credit −12; human message `RAIDBURN`).
  SHIP `@0x5C252..@0x5C297` (the tile stack's first ship, damaged through
  `0x1A1F:0x6E0` = func_05B2C2, unread; credit −16). GOLD `@0x5C29A..
  @0x5C31F` (`max = gold*size/(pop_census+1)+10` clamp 0x7FFF,
  `random_int(0x32,max)`, `gold < amount || amount < 0x32` → 0; credit −8).
  NOTHING `@0x5C61C` (`RAIDNOTHING`, sfx 0x5B, no credit). `RAIDWREAK` is
  the AI-owner bulletin only (`@0x5C1C5..@0x5C1E6`).
- End `@0x5C642..@0x5C651`: the raider's home settlement alarm word toward
  the owner := 0.
- Port status: both engines run this model (`nativeRaid` / `native_raid`);
  the pre-raid combat, the force flag, `func_05B2C2`, the tribe-row war
  bit on the credits and the `[0x9410]` census are flagged stand-ins; the
  tribal-win massacre (`func_05CA7E @0x5D59A..@0x5D67A`) has no port site.


## Amendment 2026-09-03b — the grudge bit, the war council, the hoard (CORE-B, RULINGS 2026-09-03e)

- **TribeRecord +0x03 bit 0x40 = GRUDGE**: set only when a HUMAN power
  razes a size-1 settlement (`func_05CA7E @0x5D68A..@0x5D6A1`); bit 0x20 =
  the war-council latch (`@0x48755`).
- **The war council** (`func_0485F6 @0x48632..@0x48759`, per tribe, after
  the Declaration, once): `tension >= 25 && tension >= random_int(1,400)`
  or the grudge bit, then `random_int(0, 2*(5-difficulty)) == 0` →
  @INDIANGRUDGE, +100 tension toward the player, −100 toward `[0x53D2]`,
  the player's missions on the tribe's settlements destroyed
  (`func_045D00`), muskets counter `:= min(settlements, counter) * 4`
  (8-bit), horses `:= min(settlements, counter)`, herd `:= horses * 25`.
  Both engines run it (`tribeWarCouncil` / `tribe_war_council`); the −100
  leg is flagged (single-power tension).
- **TribeRecord +0x0C = the HOARD**: `Σ over the tribe's settlements of
  tech × (Mountain tiles in the in-bounds 5x5 box)` written at newgame
  (`@0x65E71`, `@0x665E0..@0x6664B`); the Silver Miner teach weight
  divides it by the settlement count. Both engines write it at village
  seeding; §3's FLAG on the `+0x0C` writer is lifted.
- **Demand cadence / the +0x2E stamp**: the research lead (adjacency-driven
  meetings through `func_059B90 → func_056C3E`, the per-power visit stamp
  0/1/2) is recorded in RULINGS 2026-09-03e as UNVERIFIED and unported;
  the ports' per-turn roll stays flagged.
