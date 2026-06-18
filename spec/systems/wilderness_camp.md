# Wilderness Camping / Unit Consolidation

> **Layer 2 — Specification (population stub).** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R/TBD. Details TBD — breadth pass.

**Overall confidence:** order list `BYTE_VERIFIED` (`@ORDERS`); camp/consolidate mechanics `TBD`. · **Canonical primary:** `data_extracted/text/NAMES_sections.json` (`@ORDERS`).

## 1. Purpose & behavior

Units standing in open terrain (the wilderness, outside a colony) can be given
holding/consolidation orders rather than moved each turn: **Sentry** (skip until
something happens nearby), **Fortify** (dig in for a defense bonus), and **No
Orders** (idle/skip). These let a player park or group units in the field. This
"camping" behavior is implemented as **unit orders**, not a distinct subsystem.
**RECONSTRUCTED** function; the disassembly is not traced — mostly `TBD`.

## 2. State & data

The order set is byte-grounded in `NAMES.TXT @ORDERS`
(`data_extracted/text/NAMES_sections.json`, line 23) — verbatim list with
hotkeys, **B**:

| Order | Key | Relevant to camping |
|---|---|---|
| No Orders | `-` | idle / skip turn |
| Sentry | `S` | hold until event — field camping |
| Trade Route | `T` | (movement) |
| Go To | `G` | (movement) |
| Live In Village | `L` | join native village |
| Fortify | `F` | dig in (defensive camp) |
| Fortified | `F` | fortified state |
| Build Colony | `B` | (founds colony) |
| Clear/Plow | `P` | terrain work |
| Build Road | `R` | terrain work |

(Trailing "No Orders" slots are AI-reserved per the `@ORDERS` comment.)

- The **per-unit orders field** is expected in UnitRecord (`docs/DATA_MODEL.md`
  notes `UnitRecord +0x06`, 189 refs, "likely orders or state") but the exact
  encoding of Sentry/Fortify/No-Orders is **TBD** (not byte-confirmed here).
- Whether stacked units in one tile are stored as a list / consolidated — `TBD`.

## 3. Formulas & rules

- **Fortify** grants a defensive combat bonus — magnitude `TBD` (not byte-traced).
- **Sentry** wakes a unit on adjacent enemy/event — wake condition `TBD`.
- Stacking / consolidation limits in a wilderness tile — `TBD`.
- No numbers byte-verified. **TBD**.

## 4. UI

Orders issued via the unit command menu / hotkeys from `@ORDERS` (S, F, etc.).
Fortified/sentry state shown by a unit overlay glyph — exact rendering `TBD`. **R**.

## 5. Evidence

- `data_extracted/text/NAMES_sections.json` — `@ORDERS` list with hotkeys (23). **B**
- `docs/DATA_MODEL.md` — `UnitRecord +0x06` candidate orders/state field. **A**
- `docs/GAME_MANUAL.md` — Sentry / Fortify / field unit behavior. **R**

## 6. Open questions (TBD)

1. **Orders encoding** — confirm `UnitRecord +0x06` (or other field) holds the
   order id; map each `@ORDERS` entry to its value.
2. **Fortify bonus** magnitude and **Sentry** wake condition (byte-trace).
3. Whether multiple units share a tile as a stack/list and any consolidation rule.
