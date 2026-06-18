# Market & Prices

> **Layer 2 — Specification.** PRIMARY data only (`/METHODOLOGY.md`). Tiers:
> `BYTE_VERIFIED` / `ANCHOR_VERIFIED` / `RECONSTRUCTED` / `TBD`.

**Overall confidence:** commodity set + price-storage location grounded; the
per-turn drift formula is `TBD`. **Last updated:** 2026-06-18.
**Primary evidence:** `data_extracted/text/NAMES_sections.json` (@CARGO),
`docs/DATA_MODEL.md` (price storage).

## 1. Purpose & behavior
The European market sets a buy/sell price per commodity. Selling pushes a price
down, demand pushes it up; prices drift over time. Boycotts (from Tea Parties)
block trading a good until lifted. Custom Houses allow trade after independence.

## 2. State & data layout

| Field | Meaning | Tier | Evidence |
|-------|---------|------|----------|
| `@CARGO` (NAMES.TXT) | commodity list (16 goods + specials) with economic params | **BYTE_VERIFIED** | `data_extracted/text/NAMES_sections.json` |
| `PowerRecord +0x4C[16]` | per-good price-level array | **ANCHOR_VERIFIED** | `docs/DATA_MODEL.md` (price area; confirm read site) |
| `DGROUP:0x53EA` word[4] | per-player market base | **ANCHOR_VERIFIED** | `docs/DATA_MODEL.md` ("market function") |

## 3. Formulas & rules
**Per-turn price drift:** `TBD`. The drift computation sits behind an RTLink
overlay thunk (`0x181F:0x9A4`); not byte-traced yet. Do **not** import any
reconstructed drift formula. → `spec/BACKLOG.md`.

**Buy/sell tax interaction:** the King's tax is taken from European sale proceeds
— see [`king.md`](king.md) §3 (revenue loop currently `TBD`).

**Boycotts:** a Tea Party boycotts one good; field/bitmask `TBD` (cross-ref
`king.md` §7).

## 4. UI layout
Prices surface on the **Europe screen** (`docs/SESSION_UI_CATALOG.md`) and the
**Economic Adviser (F5)** (`docs/ADVISOR_REPORTS_AUDIT.md`). Commodity icons via
`docs/GAME_INDEX_TABLES.md`.

## 5. Evidence
- `data_extracted/text/NAMES_sections.json` — `@CARGO`. **B**
- `docs/DATA_MODEL.md` — `PowerRecord +0x4C` price area; `0x53EA` market base. **A**

## 6. Confidence summary
- **B:** commodity set.
- **A:** price-storage locations.
- **TBD:** drift formula, buy/sell spread, boycott bookkeeping, spoilage.

## 7. Open questions (TBD) → `spec/BACKLOG.md`
1. Byte-trace the **price-drift** formula behind thunk `0x181F:0x9A4`.
2. Confirm the read/write sites for `PowerRecord +0x4C[16]` and `0x53EA`.
3. Locate the **boycott** bitmask field and its clear conditions.
