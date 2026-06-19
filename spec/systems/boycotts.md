# Commodity Boycotts (Tea Party / Parliamentary)

> **Layer 2 — Specification (population stub).** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R/TBD. Details TBD — breadth pass.

**Overall confidence:** `@TEAPARTY` key `BYTE_VERIFIED`; boycott storage field + clear rule `TBD`. · **Canonical primary:** `data_extracted/text/GAME_sections.json`. Cross-ref `spec/systems/king.md` §3 (Tea-Party path).

## 1. Purpose & behavior

When the player **refuses** a royal tax raise, they hold a **Tea Party**: the
disputed good is dumped and that commodity becomes **boycotted** — it can no
longer be bought or sold in Europe (and is not subject to the new tax). A
boycott persists until lifted. The Founding Father **Jakob Fugger** clears
**all** active boycotts when acquired (manual). **RECONSTRUCTED** for the
storage/lift mechanics; the refusal→boycott link is established in `king.md`.

## 2. State & data

- `GAME.TXT @TEAPARTY` — Tea-Party / refusal string, confirmed present in
  `data_extracted/text/GAME_sections.json` (line 288). **B** (key exists).
- Related: `@TAXOPTIONS` (accept/refuse menu, per `king.md`). **B**.
- **Per-good boycott bitmask** (one bit per tradeable commodity) is expected in
  `ColonyRecord`/`PowerRecord` or a DGROUP global, but its location is **TBD** —
  no byte trace. Do not assume a field.
- **Back-tax owed** to lift a boycott (the "pay the back taxes" amount) — storage
  and value `TBD`.

## 3. Formulas & rules

- **Set boycott:** the boycotted-good bit lives in `PowerRecord +0x20` (boycott
  bitfield, `docs/DATA_MODEL.md`). The `@SOMEBOYCOTT` announcement is byte-located
  in the Europe ship-arrival/trade handler **`func_03314E`** (`@0x3331A`, shown
  when a boycott-condition flag `[bp-0x60]≠0`); the bit-set itself is in its trade
  sub-functions (`0x368C7`/`0x368D6`) — exact write site `TBD`.
- **Lift boycott:** pay accrued back taxes on that good (amount `TBD`), OR acquire
  **Jakob Fugger** which clears **all** boycotts at once (manual). **R**.
- **Effect:** boycotted good cannot be traded in Europe. **R**.
- No numbers byte-verified. **TBD**.

## 4. UI

Tea-Party result message (`@TEAPARTY`) after refusing the tax dialog. Boycotted
goods are flagged in the Europe trade screen (visual marker) — exact treatment
`TBD`. **R**.

## 5. Evidence

- `data_extracted/text/GAME_sections.json` — `@TEAPARTY` (288), `@TAXOPTIONS`. **B**
- `spec/systems/king.md` — refusal → Tea-Party → boycott one good (§1, §3, §7.5). **B/R**
- `docs/GAME_MANUAL.md` — boycott effect; Jakob Fugger clears all boycotts;
  back-tax payment to lift. **R**

## 6. Open questions (TBD)

1. **Boycott bitmask** — which field (ColonyRecord/PowerRecord/global) holds the
   per-good boycott flags; byte-trace it.
2. **Back-tax accrual** — where the owed amount is stored and how it grows.
3. **Lift paths** — byte-trace the back-tax payment clear and the Jakob Fugger
   clear-all.
4. Confirm whether the boycotted good is also exempt from the new tax rate.
