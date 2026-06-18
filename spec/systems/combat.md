# Combat

> **Layer 2 — Specification.** PRIMARY data only (`/METHODOLOGY.md`). Tiers:
> `BYTE_VERIFIED` / `ANCHOR_VERIFIED` / `RECONSTRUCTED` / `TBD`.

**Overall confidence:** unit stats + land-odds form + **demotion ladder**
`BYTE_VERIFIED`; exact terrain/fort bonus *values* + capture branch `TBD`.
**Last updated:** 2026-06-18.
**Primary evidence:** `data_extracted/text/NAMES_sections.json` (@UNIT),
stat loader `func @0x74EC3`, land decider `func_05CA7E` (file `0x5CA7E`),
`notes/rulings/RULINGS.md` 2026-05-30 (wave-9/10, byte-traced).

## 1. Purpose & behavior
Resolves attacks between units (land and naval). The attacker either wins
(defender destroyed/demoted/captured) or loses (attacker destroyed/demoted),
decided by a single odds roll modified by terrain/fortification/veterancy.

## 2. State & data layout

| Field | Meaning | Tier | Evidence |
|-------|---------|------|----------|
| `@UNIT` rows (NAMES.TXT) | per-type stat columns (attack, defense, guns, …) | **BYTE_VERIFIED** | `data_extracted/text/NAMES_sections.json` |
| stat loader `@0x74EC3` | maps `@UNIT` col3 ATTACK→`0x5236`, col4 DEFENSE→`0x5235` (LAND, ×8 in accessor); col9 guns→`0x523B`, →`0x523C` (ship) | **BYTE_VERIFIED** | `notes/rulings/RULINGS.md` (wave-10 loader trace) |
| `UnitRecord +0x00` | `unit_type` = @UNIT row — indexes the **demotion** if-ladder | **BYTE_VERIFIED** | `docs/DATA_MODEL.md` |
| `UnitRecord +0x15` | `unit_class` / profession — the demotion **override** condition (`==24`) | **BYTE_VERIFIED** | `docs/DATA_MODEL.md` |

**Two combat functions (role split, RULINGS 2026-05-30):**
- `func_05CA7E` (file `0x5CA7E`, in `src/ai/unit_ai_leaf.c`) — the **LAND decider**: computes win/loss via `ATK/(ATK+DEF)` on *derived* strengths (stat pair `0x5235`/`0x5236`), applying the terrain/fort/veteran modifiers.
- `func_05B2C2` (file `0x5B2C2..0x5BE2C`, ENTER `0x3A`) — the **consequence applier**: demote/destroy/capture/spoils, plus the **ship** odds roll on *raw* stats `0x523B`/`0x523C` (gated to ship attacker types `0x0D..0x12`). The "+50% on the odds-roll inputs" was refuted **for the ship roll only** (raw stats); land modifiers live in `func_05CA7E`.

## 3. Formulas & rules

**Land-combat decider — `func_05CA7E` (file `0x5CA7E`, ENTER 0xDE). BYTE_VERIFIED
(wave-9 decode, `notes/rulings/RULINGS.md` 2026-05-30):**
```
odds = ATK / (ATK + DEF)        // same form as naval combat
```
- ATK/DEF are **derived strengths** from columns `0x5236` (atk) / `0x5235` (def),
  read via accessor functions (LAND uses `0x5235/0x5236`, **not** the ship pair
  `0x523B/0x523C`).
- Terrain / fortification / veterancy bonuses enter as **`·3/2` (+50%) multipliers**
  in the land strength-modifier chain inside `func_05CA7E`. **ANCHOR_VERIFIED**
  (mechanism located; exact per-terrain/fort byte values `TBD`). Per the game
  manual (`docs/GAME_MANUAL.md`; RULINGS 2026-05-30) the +50% bonuses are: attacker
  surprise (+50% ATK), **fortified** (+50% DEF), **veteran** (+50%), and **European
  bombardment** of a colony (+50%). Tier **R** (manual) for the set; mechanism
  located **A**; the specific values/conditions in `func_05CA7E` are **TBD**.
- `func_05CA7E` has an **evaluate vs act** mode (`[bp+0xE]`): mode 0 = AI ranking
  (returns the score), else = apply the result.

**Demotion ladder — BYTE_VERIFIED** (consequence applier `func_05B2C2`, if-ladder
at file `0x5B5AA..0x5B61F`; `viceroy_source/src/combat/combat_demotion_ladder.c`).
A defeated unit's *type* (`UnitRecord +0x00`) is looked up to its demoted type;
no match ⇒ the unit is **destroyed**:

| Source type (@UNIT) | → Demoted type (@UNIT) | site |
|---------------------|------------------------|------|
| 1 Soldiers | 0 Colonists | `0x5B5C3` |
| 4 Dragoons | 1 Soldiers | `0x5B5B3` |
| 7 Cont. Cav. | 9 Cont. Army | `0x5B5DF` |
| 8 Cavalry | 6 Regulars | `0x5B5EF` |
| 9 Cont. Army | 0 Colonists | `0x5B5CF` |
| any other | *destroyed* (outcome −1) | — |

Override (`0x5B60B..0x5B616`): if the outcome is `0` (Colonists) **and** the
profession byte `UnitRecord +0x15 == 24`, the outcome becomes type `3` instead.
The index ladder + offsets are byte-verified; the @UNIT-name reading follows from
the now-verified `@UNIT` table; the `+0x15==24` profession semantics and a couple
of mappings (Cont. Army→Colonists; the →type-3 override) warrant runtime
confirmation. The **capture-vs-destroy** branch (units seized, not demoted) is `TBD`.

## 4. UI layout
Combat-result popups (win/lose/demote/capture) use the shared dialog framework
(`docs/UI_DIALOGS.md`, `docs/POPUP_TEMPLATE_AUDIT.md`). Specific message keys
`TBD` (verify against `GAME_sections.json`).

## 5. Evidence
- `data_extracted/text/NAMES_sections.json` — `@UNIT` stat columns (demotion target names). **B**
- `notes/rulings/RULINGS.md` 2026-05-30 — `func_05CA7E` land-odds decode; the land vs ship role split; `@0x74EC3` stat-offset mapping; +50% modifier reconciliation. **B**
- `viceroy_source/src/combat/combat_demotion_ladder.c` — demotion if-ladder at `func_05B2C2` `0x5B5AA..0x5B61F`. **B**
- `viceroy_source/src/combat/combat_modifiers.c` — ship odds roll uses raw `0x523B/0x523C` (no scaling), 3 byte-proofs. **B**
- `docs/DATA_MODEL.md` — UnitRecord `+0x00`, `+0x15`. **B**
- `docs/GAME_MANUAL.md` — the four +50% bonuses (attack/fortify/veteran/bombardment). **R**

## 6. Confidence summary
- **B:** unit stat columns; stat-offset mapping; land odds = ATK/(ATK+DEF);
  the +50% modifier mechanism's location; the **demotion ladder** (index table +
  offsets) and its `+0x15==24` override.
- **R:** the set of +50% bonuses (manual-sourced).
- **TBD:** exact terrain/fort bonus *byte values* in `func_05CA7E`; the
  capture-vs-destroy branch; `+0x15==24` profession semantics; naval/bombardment
  specifics; result message keys.

## 7. Open questions (TBD) → `spec/BACKLOG.md`
1. Decode the terrain/fortification bonus **table values** (the `·3/2` chain inside `func_05CA7E`).
2. Decode the **capture-vs-destroy** branch; confirm the `+0x15==24`→type-3 override semantics and the Cont. Army→Colonists mapping at runtime.
3. Naval combat & bombardment specifics (ship pair `0x523B/0x523C`, roll in `func_05B2C2`).
