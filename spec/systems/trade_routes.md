# Trade Routes

> **Layer 2 — Specification (population stub).** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R/TBD. Mostly TBD — breadth pass.

**Overall confidence:** existence + order entry `BYTE_VERIFIED`; all data/logic `TBD`. **Canonical primary:** `data_extracted/text/NAMES_sections.json` `@ORDERS`; `data_extracted/text/GAME_sections.json` `@TRADE*` keys; `docs/GAME_MANUAL.md`.

## 1. Purpose & behavior
A trade route automates a ship or wagon train: the player defines a sequence of destinations (colonies and/or Europe) plus which goods to load and unload at each. Once assigned the "Trade Route" order, the unit ferries cargo automatically each turn, delegating supply logistics to the AI. **RECONSTRUCTED** (manual §"Trade Routes").

## 2. State & data
- Unit order "Trade Route" = `@ORDERS` row index 2, key letter `T`. **BYTE_VERIFIED present** (NAMES `@ORDERS`).
- Trade-route definition records (destination list, load/unload per good, route name): **TBD — not yet traced.** No base/stride identified in `docs/DATA_MODEL.md`.

`@TRADE*` GAME.TXT keys (BYTE_VERIFIED present, dialog text only): `@TRADENAME @TRADENAMES @TRADESELECT @TRADESTART @TRADETYPE @TRADEWHICH @TRADEDELETE @TRADEMANY @TRADENONE @TRADENONE2 @TRADENOCARGO @TRADENOWANT @TRADEWITH` (some of these serve native trade too — see `spec/systems/natives.md`).

## 3. Formulas & rules
- Route selection / cargo pickup logic: **TBD** (no primary function traced).
- Max routes, max stops per route, naming: **TBD**.

## 4. UI
"Create Trade Route" via the trade menu on the map display (manual). Left column = origin/destination list; center column = unload selection; the dialog uses `@TRADE*` strings. See `docs/SESSION_UI_CATALOG.md`, `docs/UI_DIALOGS.md`.

## 5. Evidence
- `data_extracted/text/NAMES_sections.json` — `@ORDERS` row 2 "Trade Route, T". **B**
- `data_extracted/text/GAME_sections.json` — `@TRADE*` dialog keys present. **B**
- `docs/GAME_MANUAL.md` §"Trade Routes" — function/columns. **R**

## 6. Open questions (TBD)
1. Locate the trade-route definition structure (base/stride, stop list, per-good load/unload mask).
2. Byte-trace the per-turn automation that moves cargo along a route.
3. Determine route count / stop limits and where route names are stored.
