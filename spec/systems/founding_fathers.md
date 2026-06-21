# Founding Fathers / Continental Congress

> **Layer 2 — Specification (population stub).** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R/TBD. Details TBD — breadth pass.

**Overall confidence:** roster + per-father data row + bell pool + bell-cost curve +
era-band selection weighting + **25/25 per-father effects** `BYTE_VERIFIED` (9 immediate via `func_03BC42` + 16 continuous via the has-father test, incl. the direct-call form `lcall 0x981:0`). **Canonical primary:** `data_extracted/text/NAMES_sections.json` `@FATHERS`/`@FOUNDING`; `viceroy_source/src/founding_fathers/congress.c`; `docs/DATA_MODEL.md`; `docs/GAME_MANUAL.md`.

## 1. Purpose & behavior
Liberty bells produced in colonies accumulate toward the **Continental Congress**, which periodically offers a **Founding Father** to join. Each father grants a permanent empire-wide effect (e.g. trade, exploration, military, political, religious, independence bonuses). Fathers are organized into categories; the Congress proposes candidates the player can work toward. **RECONSTRUCTED** (manual §"Founding Fathers").

## 2. State & data
`@FATHERS` (NAMES, **BYTE_VERIFIED present**, **25 rows**) — `name, category_id, w0, w1, w2` where w0/w1/w2 are the **era-band selection weights** (years `<1600` / `1600–1699` / `≥1700`; consumed as shown in §3):

| Category (id) | Fathers |
|---------------|---------|
| Trade (0) | Adam Smith, Jakob Fugger, Peter Minuit, Peter Stuyvesant, Jan de Witt |
| Exploration (1) | Ferdinand Magellan, Francisco Coronado, Hernando de Soto, Henry Hudson, Sieur De La Salle |
| Military (2) | Hernan Cortes, George Washington, Paul Revere, Francis Drake, John Paul Jones |
| Political (3) | Thomas Jefferson, Pocahontas, Thomas Paine, Simon Bolivar, Benjamin Franklin |
| Religious (4) | William Brewster, William Penn, Jean de Brebeuf, Juan de Sepulveda, Bartolome de las Casas |

`@FOUNDING` (**BYTE_VERIFIED present**, 6 entries): Trade, Exploration, Military, Political, Religious, **Independence**. (Independence is a 6th category in `@FOUNDING` but no `@FATHERS` row carries category id 5 — the 25 named fathers span ids 0..4. Independence is a discussion category, not a father slot — **note for byte-trace**.)

**Runtime state (BYTE_VERIFIED, per `PowerRecord` base `DGROUP:0x8808` stride `0x13C`; `docs/DATA_MODEL.md`):**
- `+0x07` u32 `acquired_ff_bitmask` (bit *i* = father *i* owned) — set on acquire by `ff_set_owned_bit` (`func_03B900`).
- `+0x0C` u16 `bells_toward_next_ff` (the **bell pool**; **resets** on each acquisition).
- `+0x0E` u16 `bells_per_turn` (Liberty Bells produced last turn).
- `+0x14` u16 `founding_father_count` (number of fathers owned; drives the cost curve below).

The 25-entry in-memory FF table is at `DGROUP:0x9652`, stride 6 (populated at startup from `@FATHERS` by the NAMES loader `func_0749E0`; per `congress.c`). The Congress offers the next father when the pool `+0x0C` reaches the cost computed in §3.

Per-father concrete **effect bindings** (what each father changes in-engine): still **TBD** — hardcoded in EXE logic, not in `NAMES.TXT`.

## 3. Formulas & rules

### Bell-cost curve — **BYTE_VERIFIED** (`func_03C282`, file `0x03C282..0x03C322`)
The "bells required for the next father" getter (`ff_bells_required`, overlay
thunk `0x191F:0x0F66` → `func_03C282`; hand-ported in
`viceroy_source/src/founding_fathers/congress.c` + `src/overlay/overlay_038A50_03C5A8.c`).
Inputs: `power` (arg), difficulty byte `[0x53A6]`, year `[0x538A]`,
`AIPersonality[power].controller` `[0x543F + power·0x34]`, `founding_father_count`
(`PowerRecord[power] +0x14`), game-phase flag `[0x5382]`.

```
diff = [0x53A6]                 # difficulty / current-player (0..4)
year = [0x538A]                 # current year
ff   = PowerRecord[power] + 0x14  # founding_father_count

if power < 4 and AIPersonality[power].controller == 0:   # human European power
    cost = (diff + 3) * 16        # @0x3C29C ADD ax,3; SHL ax,1; then SHL [bp-4],3
else:                            # AI / native power
    cost = (14 - diff) * 8        # @0x3C2A9 SUB ax,0xE; NEG; then SHL 3
for gate in (0x640, 0x672, 0x6A4, 0x6D6):   # years 1600/1650/1700/1750
    if year >= gate: cost += cost >> 1       # each era gate compounds x1.5
cost = (ff + 1) * cost + 1        # @0x3C302 IMUL [bp-4]; INC ax  (grows with #fathers)
if ff == 0: cost >>= 1            # @0x3C30B first father is half price
if [0x5382] & 1:                  # post-independence flat override @0x3C30D TEST [0x5382],1
    cost = diff * 0x5DC + 0x7D0   # = difficulty*1500 + 2000
```

Cross-check (runtime, `docs/DATA_MODEL.md:313`): a human Explorer-difficulty power
(`diff=1`) holding one father (`ff=1`), pre-1600, gives
`(1+1)·((1+3)·16)+1 = 129` — exactly the observed "Brewster next = 129". The
Congress proposes the next father once `bells_toward_next_ff (+0x0C) ≥ cost`.

### Father selection — **BYTE_VERIFIED** (`func_03BFD2` Congress screen; era-band weights)
The three numeric `@FATHERS` columns are **era-band selection weights** (band 0/1/2
= year `<1600` / `1600–1699` / `≥1700`), matching the `@FATHERS` legend
("weight 1500-1600, 1600-1700, 1700+"). The era band is chosen by `func_03B95A`
(year gates `[0x538A] ≥ 0x640/0x6A4`, raw `81 3E 8A 53 40 06` @ `0x03B963`). The
next father is then picked by a **weighted random** over the offerable fathers:
```
band  = era_band(year)                          # func_03B95A
sum   = Σ weight[ff]  over offerable fathers     # @0x03C0C4 MOV al,[ff*6 + 0x9655 + band] (raw 8A 80 55 96); ADD @0x03C0CA
budget = random_int(1, sum)                       # @0x03C0DB LCALL 0x181F:0x4D4
for ff in offerable:                              # @0x03C035
    budget -= weight[ff]                          # @0x03C03B
    if budget <= 0: pick = ff; break              # @0x03C042
```
So selection is era-weighted random (not difficulty-scaled; difficulty affects
the *cost* curve only). The per-category candidate scorer `ff_cat_candidate`
(overlay thunk `0x1A1F:0x0054`) is still **TBD** (call site verified; body
overlay-resident).

- Per-father **immediate (one-time) effects** — **BYTE_VERIFIED** (`func_03BC42`,
  file `0x03BC42..0x03BFD0`, ENTER 0x60; the acquire+effect dispatch — on `[bp+8] =
  ff_id` with the active `PowerRecord` at `[0x84FC]`). The handler increments
  `ff_count +0x14` and clears the pending slot `+0x12 := 0xFFFF` (`@0x3BD37`), then
  applies the acquiring father's one-time effect via an `if`-ladder on `ff_id`
  (ids = `@FATHERS` line index). **Verified against the EXE bytes (2026-06-19);
  every effect matches the manual:**

  | id | Father | Immediate effect (byte-verified site) |
  |----|--------|----------------------------------------|
  | 1 | Jakob Fugger | clear **all** boycotts: `PowerRecord +0x20 := 0` `@0x3BD45` |
  | 6 | Coronado | reveal every colony on the map (per-colony `0x181F:0x7AA`) `@0x3BF54` |
  | 9 | Sieur de La Salle | free **Stockade** for own colonies with size `+0x1F ≥ 3` (`0x181F:0xBBE`) `@0x3BD4A` |
  | 14 | John Paul Jones | spawn a free **Frigate** (`spawn_unit` `0x181F:0x95C`, type `0x11`) `@0x3BD8B` |
  | 16 | Pocahontas | reset native attitudes to content (per-settlement `0x181F:0xA42`) `@0x3BDDD` |
  | 18 | Simon Bolivar | rebel-sentiment meter `[0x53D0] += 20`, capped at 100 `@0x3BE64` |
  | 20 | William Brewster | dock-pool `+0x02..+0x04`: Petty-Criminal `0x19`/Indentured-Servant `0x1A` → Free-Colonist `0x1C` `@0x3BF85` |
  | 22 | Jean de Brebeuf | all own missions become expert (settlement `+5 \|= 0x10`) `@0x3BE77` |
  | 24 | Bartolomé de las Casas | convert all own Indian-Converts (class `0x1B`) → Free-Colonist `0x1C` `@0x3BEB2` |

  **B for the 9 immediate-effect fathers above.** The other fathers are
  **continuous**: checked at each affected system's own site via the has-father test
  `power_attribute_bit(power, bit)` (`0x181F:0x7B4` → `func_00BC10`, reading the
  `+0x07` bitmask) or a computed-mask test. The full per-father audit is below.

### Complete per-father effect audit — **25/25 BYTE_VERIFIED** (2026-06-20)
Found by scanning all 50 `0x181F:0x7B4` call sites + `func_03BC42`. `B` = byte-verified
mechanism at the cited site; `R` = manual effect, in-engine gate not yet located
(these 4 use a building-availability table or an inline computed-mask test that the
literal-immediate scans don't catch).

| id | Father (cat) | Effect | Tier · site |
|----|--------------|--------|-------------|
| 0 | Adam Smith (T) | **enables factory-tier buildings** (Arsenal 5 / Textile Mill 23 / Cigar Factory 26 / Rum Factory 29 / Fur Factory 34 / 41): unavailable unless owner has Smith | **B** build-availability `func_00B900 @0xBA8D..0xBAC9` (`has_father(0,owner)`) |
| 1 | Jakob Fugger (T) | clears **all** boycotts (`+0x20:=0`) | **B** `func_03BC42 @0x3BD45` |
| 2 | Peter Minuit (T) | **no payment to natives for land** — with Minuit the land charge is skipped | **B** `@0x40BB4` (skip charge) / `@0x465D5` (zero cost) |
| 3 | Peter Stuyvesant (T) | **enables Custom House (building 18)** construction | **B** `func_00B900 @0xBA37` (`has_father(3,owner)`) |
| 4 | Jan de Witt (T) | gates the scout/foreign-colony interaction (foreign info) | **B** `func_05A20E @0x5A469` |
| 5 | Ferdinand Magellan (E) | **faster Europe transit** — sets the Atlantic-crossing time to 1 (vs 2) turns | **B** `@0x41871` (+`@0x418A0`) |
| 6 | Francisco Coronado (E) | reveal **all colonies** on the map | **B** `@0x3BF54` |
| 7 | Hernando de Soto (E) | Lost-City: forces a **positive-outcome flag** (`[bp-0x2e]:=1`); **+ extended sight (NAVAL only)** — naval units (type `0xD..0x12`) get +1 sight radius (R 1→2); land units unaffected (manual says "all units" — a divergence) | **B** `func_061454 @0x614CC` (rumors) + `func_006608 @0x6647..0x6658` (`has_father(7,owner)` gated to naval; `exploration.md`) |
| 8 | Henry Hudson (E) | **doubles fur production** (`good==Furs & FF8 → ×2`) | **B** `colony.md` yield |
| 9 | Sieur de La Salle (E) | free **Stockade** for colonies size ≥3 | **B** `@0x3BD4A` |
| 10 | Hernán Cortés (M) | King treasure cut = **tax rate** (else `max(5·diff+50, 2·tax)` ≤90%) | **B** `func_05C878 @0x5C965` |
| 11 | George Washington (M) | combat winner **auto-promotes** (skips the random gate) | **B** `@0x5C758` |
| 12 | Paul Revere (M) | undefended colony w/ muskets `+0xB8 ≥ 50` → colonist defends @str 75 | **B** `@0x5CCAA` |
| 13 | Sir Francis Drake (E) | **Privateer (unit type 16) combat strength ×1.5 (+50%)** | **B** `@0x7CF0` (`cmp type,0x10; has_father(13,owner); strength += strength/2`) |
| 14 | John Paul Jones (M) | free **Frigate** (type `0x11`) | **B** `@0x3BD8B` |
| 15 | Thomas Jefferson (P) | **doubles** the bell/era quantity (`×2`) — manual says +50% | **B** `@0x55818` |
| 16 | Pocahontas (P) | reset native attitudes to content (on acquire) **+ ongoing**: halves all native tension-raise deltas | **B** `@0x3BDDD` (reset) + `func_045DF2 @0x45E30` (`has_father(16)` → delta `>>=1`; `natives.md`) |
| 17 | Thomas Paine (P) | **bells += bells × tax_rate / 100** (+tax%) | **B** `@0x290FB` |
| 18 | Simón Bolívar (P) | **+20% Sons of Liberty** (`[0x53D0]+=20`) | **B** `@0x3BE64` |
| 19 | Benjamin Franklin (P) | foreign powers offer **peace** (zeros hostility) | **B** `@0x5834E` (+6 sites in `func_057F4E`) |
| 20 | William Brewster (R) | no criminals/servants on docks (dock pool `+0x02..+0x04`) | **B** `@0x3BF85` |
| 21 | William Penn (R) | **colony crosses production ×1.5 (+50%)** (religious-unrest reduction) | **B** `@0xA16B` (`has_father(21,owner); crosses += crosses/2`) |
| 22 | Jean de Brébeuf (R) | all missions become **expert** (`+5 \|= 0x10`) | **B** `@0x3BE77` |
| 23 | Juan de Sepúlveda (R) | **+4** to the native-conversion metric `[bp-0x62]` | **B** `@0x5E20B` |
| 24 | Bartolomé de las Casas (R) | converts → free colonists (immediate); **−4** conversion metric | **B** `@0x3BEB2`, `@0x5E221` |

**All 25 fathers now `B`.** Smith, Stuyvesant, Drake and Penn — previously held
at `R` — are byte-verified as **has-father-gated after all** (2026-06-20):

| id | Father | Gate (byte-verified) |
|----|--------|----------------------|
| 0 | Adam Smith | build-availability `func_00B900 @0xBA8D..0xBAC9`: factory buildings 5/23/26/29/34/41 unavailable unless owner has Smith |
| 3 | Peter Stuyvesant | `func_00B900 @0xBA37`: Custom House (18) unavailable unless owner has Stuyvesant |
| 13 | Sir Francis Drake | `@0x7CF0`: Privateer (unit type 16) effective strength `×1.5` (`strength += strength/2`) when owner has Drake |
| 21 | William Penn | `@0xA16B`: colony crosses output `×1.5` (`crosses += crosses/2`) when owner has Penn |

**Correction (supersedes the 2026-06-20 "negative result").** My earlier scan
concluded these four were "not gated via the has-father helper." That was **wrong**:
the has-father function (`func_00BC10` @ file `0xBC10`) is also called in an
**in-overlay direct form `lcall 0x981:0`** (bytes `9A 00 00 81 09`), *not only* via
the thunk `0x181F:0x7B4` (`9A B4 07 1F 18`). The earlier scan matched only the thunk
form, so it missed **13 direct-call sites** (father ids at `@0x663B`=7, `@0x6D01`=5,
`@0x7CF0`=13 Drake, `@0x8578`=18, `@0x94B8`=9, `@0x9F77`=8, `@0xA16B`=21 Penn,
`@0xA4EB`=15, `@0xA50C`=17, `@0xA545`=18, `@0xAAA0`=2, `@0xBA49`=3 Stuyvesant,
`@0xBABD`=0 Smith). All four gates use the idiom `push <ff_id>; mov bx,[0x8542];
al=[bx+0x1A]; push ax; lcall 0x981:0` (owner = ColonyRecord `+0x1A`; unit-owner via
`+0x3147 & 0xF` for Drake). **Lesson:** scan *both* call forms for `func_00BC10`.

## 4. UI
F7 Continental Congress report (manual menu map). Father portraits via `FATHER*.SS` plates (asset attribution TBD). See `docs/ADVISOR_REPORTS_AUDIT.md`.

## 5. Evidence
- `func_03C282` (file `0x03C282..0x03C322`, 160 B) — `ff_bell_cost_curve`; the §3 formula is read directly from the disassembly. **B**
- `func_03BFD2` (Congress screen) — era-band weighted-random selection: weight read `0x03C0C4` (raw `8A 80 55 96`), pick loop `0x03C035..0x03C042`; era band `func_03B95A` `0x03B963` (`81 3E 8A 53 40 06`). **B**
- `func_03BC42` (file `0x03BC42`) — `ff_acquire_dispatch`: `ff_count +0x14`, pending `+0x12`, and the 9 immediate per-id effects (table in §3), each verified against EXE bytes; corroborated by `viceroy_source/src/founding_fathers/effects.c` (other branch). **B**
- `viceroy_source/src/founding_fathers/congress.c` — byte-verified hand-port of the bell accumulator (`func_03C322`), the cost getter, and the Congress trigger; confirms the curve + the `+0x0C`/`+0x0E`/`+0x14` offsets and the `DGROUP:0x9652` FF table. **B**
- `docs/DATA_MODEL.md` (PowerRecord) — `+0x07` ff bitmask, `+0x0C` bells-toward-next (resets), `+0x0E` bells/turn, `+0x14` ff count; runtime datum Brewster-next = 129. **B**
- `data_extracted/text/NAMES_sections.json` — `@FATHERS` (25 rows, cat id + 3 weights), `@FOUNDING` (6 categories). **B (present)**
- `data_extracted/text/GAME_sections.json` — `@SCORE` "+5 per father" cross-ref (see scoring). **B**
- `docs/GAME_MANUAL.md` §"Founding Fathers", scoring "+5 per Founding Father". **R**

## 6. Open questions (TBD)
1. Map each father to its concrete in-engine effect (effect magnitudes are hardcoded, not in NAMES; a few op-ids known — §3).
2. ~~Decode the per-category candidate scorer `ff_cat_candidate` (overlay thunk
   `0x1A1F:0x0054`).~~ **Structure decoded 2026-06-20** — `0x1A1F:0x0054 → func_03B980`
   (`enter 4`): loops the 25 father ids (`[bp-2]` `0..0x18`), and for each **not-yet-
   acquired** father (acquired-test `0x181F:0x7B4(id, power)` `@0x3B996`) whose category
   byte `[id·6 − 0x69AC]` (per-father table, DGROUP `0x9654`, **stride 6**) equals the
   target category arg `[bp+8]`, adds the per-father weight from `func_03C41A`
   (`@0x3B9B7`) and counts it (`[bp-4]`). A sibling `func_03B9E0` does the bare count
   (no weight). So the Congress scores a category by **Σ weight of its un-acquired
   fathers**. ⚠ **The `0x9654` father table is runtime-BSS (zeros in the static image)**,
   so the per-id category/weight *values* can't be byte-read here — they are populated
   at load from `@FATHERS` (cross-ref §3). **B** (scorer structure); table values runtime.
3. ~~Whether category 5 (Independence) ever instantiates a father.~~ **RESOLVED
   2026-06-20 — NO.** No memory dump needed: the `0x9654` table is loaded verbatim from
   **`@FATHERS` (NAMES.TXT)**, whose `type` column (= `@FOUNDING` index) shows the 25
   fathers are **exactly 5 each in types 0–4** (Trade/Exploration/Military/Political/
   Religious); **type 5 (Independence) has zero fathers** — it is a declared-but-unused
   category, so the candidate scorer's category-5 branch always counts 0. (The
   "independence-themed" fathers — Jefferson, Paine, Bolívar, Franklin — are all
   **type 3 = Political**.) **B** (primary data).

*(Resolved 2026-06-18: bell pool + bell-cost curve + Congress threshold + the three `@FATHERS` columns = era-band selection weights — now `BYTE_VERIFIED`, §3.)*
