# Founding Fathers / Continental Congress

> **Layer 2 — Specification (population stub).** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R/TBD. Details TBD — breadth pass.

**Overall confidence:** roster (25 fathers, 6 categories) + per-father data row `BYTE_VERIFIED` (present); **bell pool + bell-cost curve now `BYTE_VERIFIED`** (`func_03C282`, file `0x03C282`); per-father *selection weighting* and concrete *effects* still `TBD`. **Canonical primary:** `data_extracted/text/NAMES_sections.json` `@FATHERS`/`@FOUNDING`; `viceroy_source/src/founding_fathers/congress.c`; `docs/DATA_MODEL.md`; `docs/GAME_MANUAL.md`.

## 1. Purpose & behavior
Liberty bells produced in colonies accumulate toward the **Continental Congress**, which periodically offers a **Founding Father** to join. Each father grants a permanent empire-wide effect (e.g. trade, exploration, military, political, religious, independence bonuses). Fathers are organized into categories; the Congress proposes candidates the player can work toward. **RECONSTRUCTED** (manual §"Founding Fathers").

## 2. State & data
`@FATHERS` (NAMES, **BYTE_VERIFIED present**, **25 rows**) — `name, category_id, w0, w1, w2` (three trailing numeric weights, likely per-personality selection weights):

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

### Still TBD
- Father selection among a category (the three numeric `@FATHERS` weights per
  row): **TBD** — likely AI/availability weights; decode the `@FATHERS` consumer
  (in-memory table `DGROUP:0x9652`).
- Per-father gameplay effects: **TBD** (function HIGH in manual; effect magnitudes
  hardcoded in EXE logic, numbers TBD).

## 4. UI
F7 Continental Congress report (manual menu map). Father portraits via `FATHER*.SS` plates (asset attribution TBD). See `docs/ADVISOR_REPORTS_AUDIT.md`.

## 5. Evidence
- `func_03C282` (file `0x03C282..0x03C322`, 160 B) — `ff_bell_cost_curve`; the §3 formula is read directly from the disassembly. **B**
- `viceroy_source/src/founding_fathers/congress.c` — byte-verified hand-port of the bell accumulator (`func_03C322`), the cost getter, and the Congress trigger; confirms the curve + the `+0x0C`/`+0x0E`/`+0x14` offsets and the `DGROUP:0x9652` FF table. **B**
- `docs/DATA_MODEL.md` (PowerRecord) — `+0x07` ff bitmask, `+0x0C` bells-toward-next (resets), `+0x0E` bells/turn, `+0x14` ff count; runtime datum Brewster-next = 129. **B**
- `data_extracted/text/NAMES_sections.json` — `@FATHERS` (25 rows, cat id + 3 weights), `@FOUNDING` (6 categories). **B (present)**
- `data_extracted/text/GAME_sections.json` — `@SCORE` "+5 per father" cross-ref (see scoring). **B**
- `docs/GAME_MANUAL.md` §"Founding Fathers", scoring "+5 per Founding Father". **R**

## 6. Open questions (TBD)
1. Decode the three `@FATHERS` numeric columns (selection weights vs effect magnitudes) — the `DGROUP:0x9652` consumer.
2. Map each father to its concrete in-engine effect (effect magnitudes are hardcoded, not in NAMES).
3. Confirm whether category 5 (Independence) ever instantiates a father.

*(Resolved 2026-06-18: bell pool location + bell-cost curve + Congress proposal threshold — now `BYTE_VERIFIED`, §3.)*
