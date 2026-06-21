# Unit Orders

> **Layer 2 — Specification (population stub).** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R/TBD. Details TBD — breadth pass.

**Overall confidence:** order list + key letters + **order-code storage (`0x314C`) + work counter (`0x315A`) + pioneer durations + fortify `·3/2` mechanism `BYTE_VERIFIED`** (2026-06-20, cross-ref `unit.md`/`terrain_improvement.md`/`combat.md`). **Canonical primary:** `data_extracted/text/NAMES_sections.json` `@ORDERS`/`@ACTIONS`; `docs/GAME_MANUAL.md`.

## 1. Purpose & behavior
A unit can be given a standing order that persists across turns and suppresses auto-activation: Sentry, Fortify, Go To, Build Colony, Clear/Plow, Build Road, Live In Village, Trade Route, or No Orders. Pioneers do terrain work (clear/plow/road); soldiers fortify (defense bonus); ships and wagons can run trade routes. **RECONSTRUCTED** (manual §"Unit orders").

## 2. State & data
The active order is stored at **`UnitRecord 0x314C`** (base `0x3144`, stride 28) —
**BYTE_VERIFIED (2026-06-20)**: both dispatchers read it (`@0x249CB mov al,[bx+0x314c]`
→ jump table orders 2..9; `@0x051DCE` `sel=[0x314c]−7`), and immediate writes exist for
every order value (1 Sentry `@0x078CF`, 2 Trade Route `@0x22E05`, 3 GoTo `@0x22D2D`,
5 Fortify `@0x22105`, 6 Fortified `@0x41024`, 7 Build Colony `@0x2279E`, 8 Clear/Plow
`@0x22324`, 9 Build Road `@0x2250E`, 0xA–0xC AI). The pioneer **work-progress counter
is a separate field `0x315A`** (`terrain_improvement.md`).

`@ORDERS` rows (NAMES, **BYTE_VERIFIED present**) — `name, key-letter`:

| Idx | Order | Key | Tier |
|----|-------|-----|------|
| 0 | No Orders | `-` | **B** (present) |
| 1 | Sentry | `S` | **B** |
| 2 | Trade Route | `T` | **B** |
| 3 | Go To | `G` | **B** |
| 4 | Live In Village | `L` | **B** |
| 5 | Fortify | `F` | **B** |
| 6 | Fortified | `F` | **B** |
| 7 | Build Colony | `B` | **B** |
| 8 | Clear/Plow | `P` | **B** |
| 9 | Build Road | `R` | **B** |
| 10–12 | No Orders (reserved/AI) | `-` | **B** |

> Note the two states "Fortify" (in progress) vs "Fortified" (active) — distinct rows, matching the manual's "not gain the effects until the following turn."

`@ACTIONS` (native-interaction menu, BYTE_VERIFIED present): Trade With Village, Enter Hostile Village, Establish Mission, Denounce Heresy of %Fs Mission, Live Among The Natives, Ask to Speak With Chief, Incite Indians, Demand Tribute, Attack Village, Cancel Action.

## 3. Formulas & rules
- Fortify = **+50% defense bonus**, applied as a **`·3/2` multiplier in the land
  strength-modifier chain inside `func_05CA7E`** — **mechanism BYTE_VERIFIED**
  (`spec/systems/combat.md` §3/§7.1; the `+50%` *value* is manual-sourced **R**).
- Clear/plow/road completion times, tool cost, and terrain transitions are
  **BYTE_VERIFIED** in `spec/systems/terrain_improvement.md` (executors `func_040656`
  clear/plow / `func_0409D6` road; work-counter `UnitRecord +0x16` abs `0x315A`;
  threshold from the `@TERRAIN` table `terrain·16 + 0x2F78`, **+2** clear/plow / **+0**
  road; **Hardy Pioneer halves**; tools **−20**).
- Sentry auto-board outgoing ships; aboard ship = forced sentry (manual; **RECONSTRUCTED**).

## 4. UI
Orders shown as a single key letter in the active-unit orders box; commands via on-map keys. See `docs/UI_RENDER_MAP.md`, `docs/SESSION_UI_CATALOG.md`.

## 5. Evidence
- `data_extracted/text/NAMES_sections.json` — `@ORDERS` (13 rows w/ key letters), `@ACTIONS`. **B**
- `docs/GAME_MANUAL.md` — fortify/sentry/clear-plow/trade-route function. **R (function HIGH; numbers EXE-win)**

## 6. Open questions (TBD)
1. ~~Find the `UnitRecord` offset storing the order code and the work-progress counter.~~
   **Done 2026-06-20** — order code = `UnitRecord 0x314C`, work-progress counter =
   `0x315A` (§2; cross-ref `unit.md` §2, `terrain_improvement.md`). **B.**
2. ~~Byte-verify the fortify defense multiplier and pioneer task durations.~~ **Done
   2026-06-20** — fortify `·3/2` (+50%) mechanism in `func_05CA7E` (`combat.md`);
   pioneer durations/tool-cost in `terrain_improvement.md` (§3). **B** (mechanism).
3. ~~Trade Route data structure → see `spec/systems/trade_routes.md`.~~ **Covered** —
   `trade_routes.md` is fully byte-verified (all §6 items closed). **B** (cross-ref).
