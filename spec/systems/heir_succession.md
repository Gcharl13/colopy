# King Succession / Ambitious Heir

> **Layer 2 — Specification (population stub).** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R/TBD. Details TBD — breadth pass.

**Overall confidence:** `@SUCCESSION` key `BYTE_VERIFIED`; everything else `TBD`. · **Canonical primary:** `data_extracted/text/GAME_sections.json`.

## 1. Purpose & behavior

Over a long game the **King may die and be succeeded** by a new monarch (often an
**ambitious heir**) whose disposition toward the player — tax appetite,
willingness to grant ships/units, REF aggression — may differ from the
predecessor's. **RECONSTRUCTED** function from the manual; almost nothing is
byte-traced. This is a minor/secondary event system.

## 2. State & data

- `GAME.TXT @SUCCESSION` — succession announcement string, confirmed present in
  `data_extracted/text/GAME_sections.json` (line 393). **B** (key exists).
- Surrounding King strings (context, not all succession-specific):
  `@KINGWELCOME0` (284), `@KINGBLESS` (282), `@KINGLAUGH` (283),
  `@KINGMERCY` (315), `@KINGNEWWAR` (316). **B** (keys exist).
- A **king/heir identity or disposition field** in PowerRecord is expected but
  **TBD** (no byte trace). Note `+0x22` `royal_money` and the king-anger value
  are documented (`docs/DATA_MODEL.md`) but are not confirmed to change on
  succession — relationship `TBD`.

## 3. Formulas & rules

- **Succession trigger:** `TBD` (random over time / on certain events?).
- **Heir disposition:** how a new King's tax/grant/REF behavior is set — `TBD`.
- No numbers byte-verified. **TBD**.

## 4. UI

Succession announcement dialog (`@SUCCESSION`), King speech-bubble framework,
King portrait (`KING.SS`). Geometry per shared framework. **R**.

## 5. Evidence

- `data_extracted/text/GAME_sections.json` — `@SUCCESSION` (393) and adjacent
  King strings. **B**
- `docs/GAME_MANUAL.md` — King succession / new monarch disposition. **R**
- `spec/systems/king.md` — King dialog framework, `royal_money`, king-anger. **B/A**

## 6. Open questions (TBD)

1. **Succession trigger** — byte-trace the event that fires `@SUCCESSION`.
2. **King/heir disposition field** in PowerRecord (if any) and how it changes
   tax/grant/REF behavior.
3. Whether `royal_money` (+0x22) or king-anger reset on succession.
