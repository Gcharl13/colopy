# Founding Fathers / Continental Congress

> **Layer 2 — Specification (population stub).** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R/TBD. Details TBD — breadth pass.

**Overall confidence:** roster (25 fathers, 6 categories) + per-father data row `BYTE_VERIFIED` (present); bell-cost/selection logic `TBD`. **Canonical primary:** `data_extracted/text/NAMES_sections.json` `@FATHERS`/`@FOUNDING`; `docs/GAME_MANUAL.md`.

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

Per-father effect bindings, the player's "fathers joined" bitmask, and current bell pool: **TBD — not yet traced** (no base/stride in `docs/DATA_MODEL.md`).

## 3. Formulas & rules
- Liberty-bell cost per father / Congress proposal cadence: **TBD**.
- Father selection among a category (the three numeric weights per row): **TBD** — likely AI/availability weights; decode the `@FATHERS` consumer.
- Per-father gameplay effects: **TBD** (function HIGH in manual, numbers TBD).

## 4. UI
F7 Continental Congress report (manual menu map). Father portraits via `FATHER*.SS` plates (asset attribution TBD). See `docs/ADVISOR_REPORTS_AUDIT.md`.

## 5. Evidence
- `data_extracted/text/NAMES_sections.json` — `@FATHERS` (25 rows, cat id + 3 weights), `@FOUNDING` (6 categories). **B (present)**
- `data_extracted/text/GAME_sections.json` — `@SCORE` "+5 per father" cross-ref (see scoring). **B**
- `docs/GAME_MANUAL.md` §"Founding Fathers", scoring "+5 per Founding Father". **R**

## 6. Open questions (TBD)
1. Decode the three `@FATHERS` numeric columns (selection weights vs effect magnitudes).
2. Byte-trace the bell pool, per-father cost, and Congress proposal cadence.
3. Map each father to its concrete in-engine effect.
4. Confirm whether category 5 (Independence) ever instantiates a father.
