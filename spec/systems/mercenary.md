# Mercenary Hiring

> **Layer 2 — Specification (population stub).** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R/TBD. Details TBD — breadth pass.

**Overall confidence:** message keys `BYTE_VERIFIED`; price formula + trigger `TBD`. · **Canonical primary:** `data_extracted/text/GAME_sections.json`.

## 1. Purpose & behavior

The King occasionally offers to sell the player a band of **mercenary soldiers**
for gold (typically when independence looms or war is declared). The player
accepts (pays gold, receives soldier units in Europe) or declines. **RECONSTRUCTED**
function from the manual; the offer trigger and pricing are not byte-traced.

## 2. State & data

Mercenary-related keys confirmed present in primary
`data_extracted/text/GAME_sections.json`:

| Key | Line | Note | Tier |
|---|---|---|---|
| `@MERCENARY` | 392 | singular offer string | **B** (key exists) |
| `@MERCENARIES` | 462 | plural / offer body | **B** |
| `@MERCS` | 463 | short label | **B** |
| `@KINGBUY` | 405 | "the King offers to sell you…" purchase prompt | **B** |
| `@KINGMOBILIZE` | 424 | mobilization (war footing) prompt | **B** |
| `@KINGRECRUIT` | 86 | recruit-related King string | **B** |

(Distinguish from `@MERCANTILISM` at 285 — economic doctrine, unrelated.)
The values of these keys are empty in the extracted section (markers); the
displayed prose binding is `TBD`. The offered-unit type/count, the gold price,
and the offer-eligibility flag in game state are all **TBD** (no byte trace).

## 3. Formulas & rules

- **Price formula:** `TBD` — manual implies it scales (often steep); no primary
  trace. Do **not** invent a number.
- **Offer trigger:** `TBD` (commonly near independence / high king-anger).
- **Units delivered:** soldier units placed in Europe — count/type `TBD`.

## 4. UI

King speech-bubble offer dialog (shared popup framework): body from
`@MERCENARY`/`@MERCENARIES`/`@KINGBUY`, accept/decline options, King portrait
(`KING.SS`). Geometry per the shared dialog framework. **R**.

## 5. Evidence

- `data_extracted/text/GAME_sections.json` — `@MERCENARY` (392), `@MERCENARIES`
  (462), `@MERCS` (463), `@KINGBUY` (405), `@KINGMOBILIZE` (424),
  `@KINGRECRUIT` (86). **B**
- `docs/GAME_MANUAL.md` — King sells mercenaries for gold. **R**
- `spec/systems/king.md` — King dialog framework & related pretexts. **A**

## 6. Open questions (TBD)

1. Mercenary **price formula** — byte-trace the gold cost (no reconstruction reuse).
2. **Offer trigger** condition (king-anger / independence proximity?).
3. **Unit composition** delivered, and where (`@MERCS` count/type).
4. Confirm which key is the offer body vs. the result/confirmation.
