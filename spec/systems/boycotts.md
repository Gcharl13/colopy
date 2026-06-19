# Commodity Boycotts (Tea Party / Parliamentary)

> **Layer 2 — Specification (population stub).** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R/TBD. Details TBD — breadth pass.

**Overall confidence:** `@TEAPARTY` key + **boycott bitmask `PowerRecord +0x20` (test/set/lift) `BYTE_VERIFIED`**; back-tax *amount* + Jakob-Fugger clear-all `TBD`. · **Canonical primary:** `data_extracted/text/GAME_sections.json`; `func_030B38` (test), `@0x34717` (set), `@0x3340C` (lift). Cross-ref `spec/systems/king.md` §3 (Tea-Party path), `spec/systems/ref_growth.md` (back-tax → `+0x22`).

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
- **Per-good boycott bitmask** = `PowerRecord +0x20` (u16, one bit per good index).
  **BYTE_VERIFIED** — test `func_030B38 @0x30B47`, set `@0x34717`, clear `@0x33423`.
- **Back-tax owed** to lift a boycott: paid from treasury `PowerRecord +0x2A` and
  credited to King `royal_money +0x22` (`@0x3340C`, **B**); the *amount* is
  caller-supplied — still `TBD`.

## 3. Formulas & rules

- **Boycott bitmask — BYTE_VERIFIED:** the per-good boycott bits live in
  `PowerRecord +0x20` (one bit per good index). The **test** is `func_030B38`
  (reached via thunk `0x191F:0xCD8`): `return (1 << good) & PowerRecord[+0x20]`
  (`@0x30B3B..0x30B47`, current player via `[0x84FC]`). **B.**
- **Set boycott — BYTE_VERIFIED** (`@0x34717`, in the king/tax-dialog region):
  `PowerRecord[+0x20] |= (1 << good)` (`ax = 1 << [bp-2]; or [bx+0x20], ax`),
  preceded by the boycott message (`push 0x106A; lcall 0x181F:0x652` `@0x34700`).
  The `@SOMEBOYCOTT` announcement is also byte-located in the Europe ship-arrival/
  trade handler `func_03314E` (`@0x3331A`, gated by `[bp-0x60]≠0`). **B.**
- **Lift boycott (pay back-tax) — BYTE_VERIFIED** (`@0x3340C..0x33423`): the
  payment `ax` (the back-tax owed, computed by the caller) is **subtracted from the
  player's treasury** `PowerRecord +0x2A` (32-bit `sub +0x2A; sbb +0x2C`) **and
  added to the King's `royal_money +0x22`** (32-bit `add +0x22; adc +0x24`) — i.e.
  the back-tax flows straight into the Crown's REF budget (see
  `spec/systems/ref_growth.md` `func_03E162`) — then the good's bit is cleared:
  `PowerRecord[+0x20] &= ~(1 << good)` (`ax = ~(1<<[bp+6]); and [bx+0x20], ax`). **B.**
  (The back-tax **amount** is set by the caller — still `TBD`.)
- **Lift-all (Jakob Fugger):** clears **all** boycotts at once (manual); the
  clear-all write site (`+0x20 := 0`) is **TBD**. **R**.
- **Effect:** boycotted good cannot be traded in Europe. **R**.

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

1. ~~**Boycott bitmask** — which field holds the per-good flags.~~ **Done 2026-06-19**
   — `PowerRecord +0x20` (u16); test `func_030B38`, set `@0x34717`, lift `@0x33423` (**B**).
2. **Back-tax amount** — the caller-supplied payment value (`ax` at `@0x3340C`); where
   it is computed / how it accrues. `TBD`.
3. ~~**Lift path** — back-tax payment clear.~~ **Done** (`@0x3340C`: treasury `+0x2A` →
   King `+0x22`, then `+0x20 &= ~bit`). Remaining: the **Jakob Fugger** clear-all
   write (`+0x20 := 0`).
4. Confirm whether the boycotted good is also exempt from the new tax rate.
