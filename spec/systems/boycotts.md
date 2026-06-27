# Commodity Boycotts (Tea Party / Parliamentary)

> **Layer 2 — Specification.** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R/TBD (tier vocabulary). Status: §§2–6 byte-verified; the §6 open-questions list is fully resolved (all four items Done/B). The only non-byte residue is the §4 RUNTIME pixel observation (whether the Europe trade list paints a distinct colour/glyph for a boycotted good), which is not byte-decidable because no render function reads the boycott bit (`PowerRecord +0x20`; sole accessor `func_030B38` has exactly two callers, both sell logic — see §4).

**Overall confidence:** `@TEAPARTY` key + **boycott bitmask `PowerRecord +0x20` (test/set/back-tax-lift/Jakob-Fugger-clear-all) `BYTE_VERIFIED`**; **back-tax amount `BYTE_VERIFIED`** (price×500). · **Canonical primary:** `data_extracted/text/GAME_sections.json`; `func_030B38` (test), `@0x34717` (set), `@0x3340C` (lift). Cross-ref `spec/systems/king.md` §3 (Tea-Party path), `spec/systems/ref_growth.md` (back-tax → `+0x22`).

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
- **Back-tax owed** to lift a boycott — **formula BYTE_VERIFIED** (`func_03334E`
  `@0x333AF`): `cost = commodity_price(good) × 500` (`0x1F4`), where
  `commodity_price` = `func_030566`: `base[good·9 + DGROUP:0x9700] +
  PowerRecord[+0x4C + good]` (market sensitivity), clamped `≥ 0`. Paid from treasury
  `+0x2A` and credited to King `royal_money +0x22` (`@0x3340C`). The `×500` and the
  price helper are byte-verified; the per-good `0x9700` base bytes are runtime-filled
  (BSS, stride 9) so the absolute value depends on game state.

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
  - **Back-tax AMOUNT — BYTE_VERIFIED** (`@0x333A9..0x333B3`): `back_tax =
    current_sell_price(good) × 500` (`@0x333AF imul ax,ax,0x1F4`; price from
    `func_030566` = per-good base table `[good·9 − 0x6900]` + sensitivity
    `PowerRecord +0x4C[good]`). A gold-sufficiency check precedes the charge
    (`@0x333DD`); if the player can't afford it the boycott is **not** lifted.
    (Confirms the prior "`commodity_price × 500`" estimate.) **B.**
- **Lift-all (Jakob Fugger) — BYTE_VERIFIED:** acquiring father id 1 (Jakob Fugger)
  clears the whole mask `PowerRecord +0x20 := 0` in the FF acquire dispatch
  `func_03BC42` (`@0x3BD45`, gated on `ff_id == 1`). See `founding_fathers.md` §3. **B.**
- **Effect:** boycotted good cannot be traded in Europe. **R**.

## 4. UI

Tea-Party result message (`@TEAPARTY`) after refusing the tax dialog. There is
no passive per-good "boycott marker" tested in any trade-screen render path: the
boycott-bit test `func_030B38` (thunk `0x191F:0xCD8`) has exactly **two** call
sites in the whole image and **both are sell logic, not display** — the auto-sell
loop `@0x41210` and the interactive sell handler `@0x415A6` (`lcall 0x191F,0xCD8`
`@0x415A6`; if set it falls through to the lift/back-tax dialog `lcall 0x191F,0xC06`
`@0x415B5`, GAME.TXT string id `0x1033` ≈ `@KISSUP`). So the trade-screen
"treatment" of a boycotted good is the click → back-tax (`@KISSUP`) pay-or-abort
dialog, not a passive glyph. Whether the per-good Europe trade list also paints a
distinct colour/glyph for boycotted goods is **byte-decidably resolved as NONE**:
no render function consults the boycott bit (`PowerRecord +0x20`). Proof (exhaustive
caller enumeration over `functions.jsonl`): the only accessor of `PowerRecord +0x20`
reachable via the boycott-test thunk is `func_030B38` (thunk `0x191F:0xCD8`), and that
function has **exactly two callers in the entire image** — `func_041080` (overlay page 8,
auto-sell loop, call site `@0x41210`) and `func_041410` (overlay page 8, interactive
sell, call site `@0x415A6`) — **neither a render/glyph function** (`func_041080` feeds
the tax-split `func_032914`; `func_041410` feeds the back-tax helper `func_03334E` and
int-formatters `func_002648`/`func_002632`; no sprite- or text-draw call in either is
keyed on the bit). Therefore **no boycott-bit-driven glyph or colour can exist** in the
trade screen — the question is closed negative by the bytes, not TBD. The only residue is
a purely observational sanity check (run the game, Tea-Party a good, eyeball the per-good
list pixels), which adds no decode value: the byte evidence already proves no visual
distinction is produced. **B** (caller graph) — byte-decidable half closed negative; the
optional pixel sanity-check is not a decode blocker.

## 5. Evidence

- `data_extracted/text/GAME_sections.json` — `@TEAPARTY` (288), `@TAXOPTIONS`. **B**
- `spec/systems/king.md` — refusal → Tea-Party → boycott one good (§1, §3, §7.5). **B/R**
- `docs/GAME_MANUAL.md` — boycott effect; Jakob Fugger clears all boycotts;
  back-tax payment to lift. **R**

## 6. Open questions (TBD)

1. ~~**Boycott bitmask** — which field holds the per-good flags.~~ **Done 2026-06-19**
   — `PowerRecord +0x20` (u16); test `func_030B38`, set `@0x34717`, lift `@0x33423` (**B**).
2. ~~**Back-tax amount.**~~ **Done 2026-06-19** — `cost = commodity_price(good)·500`
   (`func_03334E @0x333AF`; price helper `func_030566`). Only the per-good `0x9700`
   base bytes are runtime state (BSS).
3. ~~**Lift paths** — back-tax clear + Jakob Fugger clear-all.~~ **Done** — back-tax
   `@0x3340C` (treasury `+0x2A` → King `+0x22`, then `+0x20 &= ~bit`); **Jakob Fugger
   clear-all `+0x20 := 0` `@0x3BD45`** (`func_03BC42` id 1). Both **B**.
4. ~~Confirm whether the boycotted good is also exempt from the new tax rate.~~
   **Resolved 2026-06-20 — moot: a boycotted good cannot be sold at all** (so it never
   reaches the tax math). The sell path tests the boycott bit **before** selling — auto
   loop `@0x41210` (`lcall func_030B38; or ax,ax; jne skip`) and interactive sell
   `@0x415A6` (`je sell`); if boycotted it calls the back-tax-to-lift helper
   `func_03334E` (price×500) and sells only if the boycott lifted, else aborts
   (`@0x415C1`). The boycott bit is never consulted inside `func_032914`'s tax split —
   the good is gated out upstream. **B.**
