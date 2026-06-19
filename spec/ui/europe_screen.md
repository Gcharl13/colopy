# Europe Screen (London / home trade port)

> **Layer 2 — UI Specification (population stub).** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R/TBD. Details TBD — breadth pass.

**Overall confidence:** outer band geometry **A** (luma-measured); state fields **B/R**; per-element draw code **TBD**. · **Canonical primary:** `docs/RENDERER_GEOMETRY.md` "Europe screen (VERIFIED v3)", `docs/SESSION_UI_CATALOG.md` §4, `docs/SCREEN_ASSET_REQUIREMENTS.md` "Europe trade port".

## 1. Purpose
The home-nation harbor where the player sells/buys cargo, recruits/purchases/trains units, and dispatches ships. Three docked panels track ship traffic (Expected Soon / Bound For \<colony\> / Loading). Bottom strip shows the 16 commodities with current/max and a boycott red-X overlay. **A** (`SESSION_UI_CATALOG.md` §4).

## 2. Layout — "what is drawn where"
Native 320×200. Bands frame-verified via luma analysis (`RENDERER_GEOMETRY.md` v3, tier **A** — pixel-measured, not byte-cited).

| Region | Pixel rect | Tier | Notes |
|--------|-----------|------|-------|
| Title bar | (0, 0, 320, 8) | A | "Selling \<Cargo\> at \<N\> Gold: (\<gold\>)" |
| Trade transaction panel | (0, 8, 320, 37) | A | "Sold N X at Y/ton / Price / % Tax / Net" over parchment |
| Dock + ships scene | (0, 45, 270, 90) | A | sky+grass+water+dock; Expected/Bound/Loading panels ~y=118 |
| Right button column | (270, 45, 50, 130) | A | RECRUIT / PURCHASE / TRAIN |
| Stockpile strip | (8, 179, 304, 21) | A | 16 cells × 19 px stride |
| Exit button | (303, ~190, 17, 10) | A | small red "E" |

Boycott vs saturation: boycotted good shows ICONS.SS red-X overlay; saturated goods show "0/0" with no X (`SESSION_UI_CATALOG.md` §4 "critical observation"). **A**

**Caveat:** the Europe screen renderer (per-element blit code, exact panel sub-coordinates) is the same overlay-segment family as the colony screen; v2 sub-coordinates (RECRUIT y=144 etc.) are deprecated/unverified — tier **R**.

## 3. Assets & text
- **Background:** EUROPE.PIK (sky+harbor) full-screen + COLONY.PIK strip y=128..200 (inventory bar). Ships/cargo: ICONS.SS. Boycott marker: ICONS.SS (red X, ~slot 043, observation). Exit: EXIT.SS. **A/R**
- **Buttons** (verified `LABELS_sections.json` `@EUROLABEL` = "RECRUIT\nPURCHASE\nTRAIN\nx"): RECRUIT/PURCHASE/TRAIN. **B**
- **Trade text** (verified `@CMESSAGE`): "sold for", "bought for", "at", "Selling", "Loading", "% Tax:", ". Net:", ". Price:". **B**
- **Dock panel labels** (verified `@MISC`): "Expected Soon", "Bound For", "Loading", "Off Mapboard (Europe)", "Awaiting Passage". **B**
- 16-commodity order from NAMES `@CARGO` (verified). **B**

## 4. Interactions
- RECRUIT / PURCHASE / TRAIN buttons (right column). **A**
- Drag cargo between warehouse and ship hold (SHIFT for partial loads — see GAME `@smallfont` cargo-units help text, verified present). **B**
- Exit → return to map. **A**

## 5. Evidence
- `docs/RENDERER_GEOMETRY.md` "Europe screen (VERIFIED v3)" + luma edge table; v2 deprecated block. **A / R**
- `docs/SESSION_UI_CATALOG.md` §4 — Europe frame, 3 dock panels, boycott vs saturation. **A**
- `docs/SCREEN_ASSET_REQUIREMENTS.md` "Europe trade port" — asset/text/memory table. **A**
- `data_extracted/text/LABELS_sections.json` — `@EUROLABEL`, `@CMESSAGE`, `@MISC` (verified). **B**
- State fields (`SCREEN_ASSET_REQUIREMENTS.md`): PowerRecord +0x2A gold, +0x20 boycott bitfield, +0x4C+i **market sensitivity** (u8; corrected from "price" — RULINGS 2026-06-19; the displayed price is computed from the `0x53EA` base + drift, not stored here), +0x5C+i*2 market pool. **B/R**

## 6. Open questions (TBD)
1. Exact (x,y) of RECRUIT/PURCHASE/TRAIN and the 3 dock panels — only band rects measured; v2 values unverified.
2. Boycott bitfield DGROUP location — `SESSION_UI_CATALOG.md` flags PowerRecord +0x20 as candidate but notes it is not yet confirmed.
3. Stockpile cell current/max draw geometry & font color — overlay code.
4. Title-bar sell-price number format ("at 1632") semantics.
