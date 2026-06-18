# Mercenary Hiring

> **Layer 2 — Specification.** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R/TBD.
> Re-grounded 2026-06-18 from the **real key bodies** (the breadth stub guessed
> from empty keys and mis-anchored on `@MERCENARY`).

**Overall confidence:** offer text `BYTE_VERIFIED`; price/trigger `TBD`. ·
**Canonical primary:** `data_extracted/text/GAME_sections.json`.

## 1. Purpose & behavior
The King offers to sell the player a force of **mercenary soldiers** for gold.
The player declines or pays. The mercenaries then **arrive in a colony**.

## 2. State & data (real bodies)
| Key | Real body (verbatim) | Role | Tier |
|-----|----------------------|------|------|
| `@MERCENARIES` | "The King of %STRING0 has offered to send us a force of trained {mercenaries}\n(%STRING1)\nin exchange for {%NUMBER0$}.\n\nNo thank you.\nPay {%NUMBER0$}." | **the offer dialog** (price `%NUMBER0`, force `%STRING1`, two options) | **BYTE_VERIFIED** |
| `@MERCS` | "%STRING1 mercenaries arrive in %STRING0." | arrival message | **BYTE_VERIFIED** |

- **Price (`%NUMBER0`) and force composition (`%STRING1`) are runtime-substituted**
  — the values come from game state, not the string; the formula is `TBD`.
- Eligibility/offer flag in game state: `TBD` (not traced).

**Corrections from the basis (do not reuse the old anchors):**
- `@MERCENARY` is **NOT** the mercenary offer — its body is *"The {%STRING0}
  declare war on the {%STRING1}."* (a war-declaration string). Excluded here.
- `@KINGBUY` = *"King increases military spending. {%STRING0} added to royal
  expeditionary force…"* → **REF buildup**, belongs to `spec/systems/ref_growth.md`.
- `@KINGMOBILIZE` = *"Parliament votes additional funds to suppress revolution…
  {%STRING1} mobilized in %STRING2."* → **REF mobilization** during revolution.
- `@KINGRECRUIT` body is empty.

## 3. Formulas & rules
- **Price (`%NUMBER0`):** `TBD` — byte-trace the gold cost; do not invent.
- **Offer trigger:** `TBD`.
- **Force (`%STRING1`):** unit type/count `TBD`.

## 4. UI
Offer dialog from `@MERCENARIES` (King speech-bubble framework, `KING.SS`),
two options *No thank you* / *Pay {%NUMBER0$}*; arrival via `@MERCS`. See
`spec/ui/popups.md`.

## 5. Evidence
- `data_extracted/text/GAME_sections.json` — `@MERCENARIES`, `@MERCS` (full
  bodies). **B**
- `docs/GAME_MANUAL.md` — King sells mercenaries for gold. **R**

## 6. Open questions (TBD)
1. Mercenary **price formula** (`%NUMBER0`) — byte-trace.
2. **Offer trigger** condition.
3. **Force composition** (`%STRING1`) — unit type/count.
