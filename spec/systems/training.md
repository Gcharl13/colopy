# Colonist Training & Promotion

> **Layer 2 — Specification (population stub).** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R/TBD. Details TBD — breadth pass.

**Overall confidence:** job/profession roster `BYTE_VERIFIED` (present); promotion rules `RECONSTRUCTED`/`TBD`. **Canonical primary:** `data_extracted/text/NAMES_sections.json` `@JOB`/`@CLASS`; `docs/GAME_MANUAL.md`.

## 1. Purpose & behavior
Colonists gain expertise three ways: **schools** (a skilled colonist teaches the unskilled), **native learning** (live in a village to learn a local skill such as tobacco planting or fur trapping), and **veterancy** (soldiers become Veteran Soldiers through combat). Education also advances class: petty criminals → indentured servants → free colonists → masters. **RECONSTRUCTED** (manual §"Education"/"Indian Lore").

## 2. State & data
A unit's profession is held in `UnitRecord +0x15` (`unit_class`/profession, init 0..0x1C; read by the combat demotion table). **ANCHOR_VERIFIED** (`docs/DATA_MODEL.md`).

`@JOB` (NAMES, **BYTE_VERIFIED present**, 28 rows) — `base_name, expert_name, tier, number`:

| Job | Expert form | tier | num |
|-----|-------------|------|-----|
| Farmer | Expert Farmers | 1 | 1100 |
| Sugar/Tobacco/Cotton Planter | Master … Planters | 2 | -1 |
| Fur Trapper | Expert Fur Trappers | 1 | -1 |
| Lumberjack | Expert Lumberjacks | 1 | 700 |
| Ore/Silver Miner | Expert … Miners | 1 | 600/900 |
| Fisherman | Expert Fishermen | 1 | 1000 |
| Distiller/Tobacconist/Weaver/Fur Trader | Master … | 2 | 1100/1200/1300/950 |
| Carpenter/Blacksmith/Gunsmith | Master … | 1/2 | 1000/1050/850 |
| Preacher | Firebrand Preachers | 3 | 1500 |
| Statesman | Elder Statesmen | 3 | 1900 |
| Teacher | Expert Teachers | 4 | -1 |
| Colonist | Free Colonists | 4 | -1 |
| Pioneer | Hardy Pioneers | 1 | 1200 |
| Soldier | Veteran Soldiers | 2 | 2000 |
| Scout | Seasoned Scouts | … | … |

(Column 3 = a tier/teach-level; column 4 = a number, likely a market/base value — **semantics TBD**.)

`@CLASS` 8-tier ladder (Petty Criminals … Educated Elite) governs promotion-by-education. **BYTE_VERIFIED present.**

## 3. Formulas & rules
- School teaching rate, turns-to-train, school-tier limits (schoolhouse/college/university): **TBD** (`@SCHOOL1` GAME key present; logic not traced).
- Native-learning eligibility (which `@JOB` learnable, attitude gate): **TBD** (manual lists tobacco/fur/wood lore).
- Veteran promotion on combat: read of `+0x15` by the demotion/promotion table is **ANCHOR_VERIFIED**; exact rule **TBD**.

## 4. UI
Surfaces in the colony screen (assign job) and education building tooltips. See `spec/systems/colony.md`, `docs/SESSION_UI_CATALOG.md`.

## 5. Evidence
- `data_extracted/text/NAMES_sections.json` — `@JOB` (28 rows), `@CLASS` (8). **B (present)**
- `docs/DATA_MODEL.md` — `UnitRecord +0x15` profession, combat demotion read. **A**
- `docs/GAME_MANUAL.md` §"Education", "Indian Lore". **R**

## 6. Open questions (TBD)
1. Decode `@JOB` columns 3 (tier) and 4 (number).
2. Byte-trace school teaching (rate, building-tier cap, who-teaches-whom) — start from `@SCHOOL1` consumer.
3. Byte-trace native-learning grant and the veteran promotion rule (demotion table at the `+0x15` reader).
