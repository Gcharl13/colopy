# Tory Uprising (Internal Dissent During Independence)

> **Layer 2 — Specification (population stub).** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R/TBD. Details TBD — breadth pass.

**Overall confidence:** message keys `BYTE_VERIFIED`; trigger + effect `TBD`. · **Canonical primary:** `data_extracted/text/GAME_sections.json`.

## 1. Purpose & behavior

During the War of Independence, colonists loyal to the Crown (**Tories**) can
cause internal dissent — a **Tory uprising** — opposing the rebel cause. The
balance between **Tory** and **Rebel** (Sons of Liberty) sentiment governs
morale, production bonuses/penalties, and uprising events. **RECONSTRUCTED**
function from the manual; trigger and effects are not byte-traced.

## 2. State & data

Sentiment / uprising keys confirmed present in
`data_extracted/text/GAME_sections.json`:

| Key | Line | Note | Tier |
|---|---|---|---|
| `@TORYUPRISING` | 454 | uprising event string | **B** (key exists) |
| `@TORYMINORITY` | 396 | Tory-minority status string | **B** |
| `@TORYMAJORITY` | 397 | Tory-majority status string | **B** |
| `@REBELMAJORITY` | 394 | Rebel-majority status string | **B** |
| `@REBELUNANIMOUS` | 395 | full Rebel support string | **B** |

(Values empty in extracted section — markers; prose binding `TBD`.)

The **rebel fraction** that drives these states is byte-grounded: `ColonyRecord
+0xC2` = `rebel_dividend` (Sons of Liberty numerator), `+0xC6` = denominator —
e.g. 66/617 = 10.7% Sons of Liberty, RUNTIME-VERIFIED per `docs/DATA_MODEL.md`.
The Tory share is the complement. The specific **uprising-trigger threshold** on
this fraction is **TBD**.

## 3. Formulas & rules

- **Sentiment:** Sons-of-Liberty % = `+0xC2 / +0xC6` (per colony).
  **RUNTIME-VERIFIED** (field meaning); the Tory complement and the
  majority/minority cutoffs that select `@TORY*`/`@REBEL*` are `TBD`.
- **Uprising trigger:** `TBD` — condition that fires `@TORYUPRISING` (likely a
  low rebel % during the independence war).
- **Effect:** internal dissent / loss penalty — magnitude `TBD`.

## 4. UI

Status messages (`@TORYMAJORITY`/`@TORYMINORITY`/`@REBELMAJORITY`/
`@REBELUNANIMOUS`) in colony/advisor reports; uprising event dialog
(`@TORYUPRISING`). Geometry per shared framework. **R**.

## 5. Evidence

- `data_extracted/text/GAME_sections.json` — `@TORYUPRISING` (454),
  `@TORYMINORITY` (396), `@TORYMAJORITY` (397), `@REBELMAJORITY` (394),
  `@REBELUNANIMOUS` (395). **B**
- `docs/DATA_MODEL.md` — `ColonyRecord +0xC2/+0xC6` rebel fraction. **B/runtime**
- `docs/GAME_MANUAL.md` — Tory/Rebel sentiment & dissent during independence. **R**

## 6. Open questions (TBD)

1. **Uprising trigger** — byte-trace the condition firing `@TORYUPRISING`.
2. **Majority/minority cutoffs** on the rebel fraction selecting the `@TORY*`/
   `@REBEL*` status strings.
3. **Effect magnitude** of an uprising (units lost / morale / production).
