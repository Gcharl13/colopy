# Combat

> **Layer 2 — Specification.** PRIMARY data only (`/METHODOLOGY.md`). Tiers:
> `BYTE_VERIFIED` / `ANCHOR_VERIFIED` / `RECONSTRUCTED` / `TBD`.

**Overall confidence:** unit stats + land-odds form `BYTE_VERIFIED`; damage/
demotion selection `TBD`. **Last updated:** 2026-06-18.
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
| `UnitRecord +0x00` | `unit_type` = @UNIT row | **BYTE_VERIFIED** | `docs/DATA_MODEL.md` |
| `UnitRecord +0x15` | `unit_class` / profession — read by the combat **demotion** table | **BYTE_VERIFIED** | `docs/DATA_MODEL.md` |

## 3. Formulas & rules

**Land-combat decider — `func_05CA7E` (file `0x5CA7E`, ENTER 0xDE). BYTE_VERIFIED
(wave-9 decode, `notes/rulings/RULINGS.md` 2026-05-30):**
```
odds = ATK / (ATK + DEF)        // same form as naval combat
```
- ATK/DEF are **derived strengths** from columns `0x5236` (atk) / `0x5235` (def),
  read via accessor functions (LAND uses `0x5235/0x5236`, **not** the ship pair
  `0x523B/0x523C`).
- Terrain / fortification bonuses enter as **`·3/2` (+50%) multipliers** in the
  land strength-modifier chain inside `func_05CA7E`. **ANCHOR_VERIFIED** (located;
  exact per-terrain/fort table values `TBD`).
- `func_05CA7E` has an **evaluate vs act** mode (`[bp+0xE]`): mode 0 = AI ranking
  (returns the score), else = apply the result.

**Damage / demotion selection:** `TBD`. The demotion table reads `UnitRecord
+0x15`, but the exact ladder (Soldier→Dragoon→…→Continental) and the
capture-vs-destroy branch are not byte-traced yet. → `spec/BACKLOG.md`.

## 4. UI layout
Combat-result popups (win/lose/demote/capture) use the shared dialog framework
(`docs/UI_DIALOGS.md`, `docs/POPUP_TEMPLATE_AUDIT.md`). Specific message keys
`TBD` (verify against `GAME_sections.json`).

## 5. Evidence
- `data_extracted/text/NAMES_sections.json` — `@UNIT` stat columns. **B**
- `notes/rulings/RULINGS.md` 2026-05-30 — `func_05CA7E` land-odds decode;
  `@0x74EC3` stat-offset mapping. **B**
- `docs/DATA_MODEL.md` — UnitRecord `+0x00`, `+0x15`. **B**

## 6. Confidence summary
- **B:** unit stat columns; stat-offset mapping; land odds = ATK/(ATK+DEF);
  the +50% modifier mechanism's location.
- **TBD:** exact terrain/fort bonus table values; damage/demotion ladder;
  capture branch; naval/bombardment specifics; result message keys.

## 7. Open questions (TBD) → `spec/BACKLOG.md`
1. Decode the terrain/fortification bonus **table values** used in `func_05CA7E`.
2. Decode the **demotion ladder** and capture-vs-destroy branch (reads `+0x15`).
3. Naval combat & bombardment specifics (ship pair `0x523B/0x523C`).
