# King & Royal Taxation

> **Layer 2 — Specification.** Built from evidence (Layer 1), consumed by the
> implementation (Layer 3). See `/METHODOLOGY.md`. Claims tagged
> `BYTE_VERIFIED` / `ANCHOR_VERIFIED` / `RECONSTRUCTED` / `TBD`.
> **This is the pilot/worked-example spec** — copy its shape for other systems.

**Overall confidence:** mixed (state layout B; tax-change formula R; revenue R) ·
**Last updated:** 2026-06-18 ·
**Canonical evidence:** `docs/DATA_MODEL.md`, `func_034AE0`, turn counter
`0x538E`, `docs/KING_AND_CINEMATIC_AUDIT.md`, `GAME.TXT @KINGTAX`.

## 1. Purpose & behavior

The Crown periodically raises the player's **tax rate** (a percentage applied to
European sales) under escalating pretexts, and maintains a **Royal Expeditionary
Force (REF)** budget that grows over time. The player may **accept** a tax hike
(kiss the pinky ring) or **refuse** (hold a "Tea Party"), which dumps one good
into the sea and triggers a Parliamentary **boycott** of that good until back
taxes are paid. Tax can also be **reduced** (winning the King's war, losing a REF
unit, or a successful petition). `[RECONSTRUCTED` from manual + `docs` §12;
player-visible effects well attested.]

## 2. State & data layout

PowerRecord base `DGROUP:0x8808`, **stride 316 (0x13C)**, 12 entries (4 European
+ 8 native). Active record reachable via far ptr `DGROUP:0x84FC`. All tiers
below per canonical `docs/DATA_MODEL.md` (runtime cross-validated against the
in-game UI).

| Address / field | Type | Meaning | Tier | Evidence |
|-----------------|------|---------|------|----------|
| `PowerRecord +0x01` | u8 | `tax_pct` (0..100) | **BYTE_VERIFIED** | `docs/DATA_MODEL.md`; `func_034AE0`; user 0%→1% transition |
| `PowerRecord +0x22` | s32 | `royal_money` — King's REF-expansion budget (drives REF growth; player-only) | **BYTE_VERIFIED** (runtime) | `docs/DATA_MODEL.md`: English 936→1062 @ **+18/turn**, Discoverer |
| `PowerRecord +0x2A` | u32 | `gold` — player treasury | **BYTE_VERIFIED** | `docs/DATA_MODEL.md`: write-back updates UI; 3552/4032 match |
| `PowerRecord +0x44..+0x49` | u8[6] | REF unit counts (Dragoon/Regular/Cavalry/Artillery/Man-O-War/Frigate) | **RECONSTRUCTED** | `notes/COLONIZATION_TECHNICAL_REFERENCE.md` §12 |
| `DGROUP:0x538E` | u16 | global **turn counter** (drives the tax-raise cadence/era gates) | **BYTE_VERIFIED** | `docs/DATA_MODEL.md`; `ghidra_export` `*(0x538e)` mod-3/mod-4 gates |
| `DGROUP:0x53A6` | u8 | difficulty / current player (0..4) | **BYTE_VERIFIED** | `docs/DATA_MODEL.md` (king-tax + SMITE traces) |

> **Conflict (ruled by hierarchy):** `notes/COLONIZATION_TECHNICAL_REFERENCE.md`
> §"Colony Tax/Production" places `king_treasury` at `+0x22`, `player_treasury`
> at `+0x26`, `gold` at `+0x21`. The **canonical** `docs/DATA_MODEL.md` —
> runtime-verified against the live UI — places `gold` at `+0x2A` and
> `royal_money` at `+0x22`. **`docs/DATA_MODEL.md` wins** (higher trust: runtime
> cross-check). The TECH_REF offsets are treated as an older serializer-relative
> reading. See `notes/rulings/RULINGS.md`.

## 3. Formulas & rules

**Tax-rate change** (`func_034AE0`, file `0x034AE0` — identified as
`king_attempt_tax_change`):
```
delta   = ((difficulty & 0xFE) * 2) + 4      // ghidra-inferred  (RECONSTRUCTED)
tax_pct = min(tax_pct + delta, 75)           // cap 75            (BYTE_VERIFIED: CMP …,0x4B)
```
- The **cap of 75%** is hardcoded — `CMP tax_rate, 0x4B` (`0x4B` = 75).
  **BYTE_VERIFIED** (`notes/COLONIZATION_TECHNICAL_REFERENCE.md` §"Tax rate cap").
- The function identity (`0x034AE0` = the tax-change routine) is
  **ANCHOR_VERIFIED** (`docs/DATA_MODEL.md` cites `func_034AE0` as the writer of
  `tax_pct`; `code/DISASM_LEDGER.md` marks `0x034AE0` DONE).
- The `delta` expression is from the **Ghidra decompiler** annotation
  (`ghidra_export/VICEROY2_annotated.c:215`) and is **RECONSTRUCTED** — it must
  be byte-confirmed against the disasm before the implementation hardcodes it.
  → see Open questions.

**Tax revenue on European sales** (per-good, annual processing; `func_O111`):
```
for good in 0..15:
    if stockpile[good] > 100: amount = stockpile[good] - 50
    sale_price      = market_price(good) * amount
    king_tax        = sale_price * tax_pct / 100
    player_revenue  = sale_price - king_tax
    treasury_gold  += player_revenue          // +0x2A
    // king's cut accrues to the Crown side
```
Tier **RECONSTRUCTED** (`notes/COLONIZATION_TECHNICAL_REFERENCE.md` §"Tax revenue
calculation", from a 1440-byte decode of `func_O111`).

**Tax-raise cadence:** gated on the `0x538E` turn counter via modulo arithmetic
(`*(0x538e) % 3`, `% 4`, and `0x4F <` era comparisons appear in `ghidra_export`).
Exact pretext-selection and interval table are **TBD** (see §7). Leniency window
by difficulty is reported as **20 / 15 / 10 / 7 / 4 turns** (Discoverer→Conquistador)
— **RECONSTRUCTED** (`notes/COLONIZATION_TECHNICAL_REFERENCE.md`).

**Tax-raise pretexts** (string keys, BYTE_VERIFIED that these keys exist in
GAME.TXT; selection logic TBD): `@KINGTAX`, `@MERCANTILISM` (Custom House),
`@PURCHASETAX`, `@KINGNAVACT` (Navigation Act), `@KINGSTAMPACT` (Stamp Act),
`@KINGWIFE` (royal wedding), `@KINGWAR`.

## 4. UI layout — "what is drawn where"

The tax demand surfaces as the **King speech-bubble dialog**:
- **Message body:** `GAME.TXT @KINGTAX` (catalog **line 1622**) — *"…the Crown
  receive proper recompense… raise tax rate by X%. Tax rate is now Y%."* The
  dispatcher substitutes `X` (delta) and `Y` (new `tax_pct`).
  **BYTE_VERIFIED** key (`docs/KING_AND_CINEMATIC_AUDIT.md` line 241;
  `TEXT_LABEL_AUDIT.md` line 1622).
- **Portrait:** `KING.SS` (default standing king). The `KING1.SS` sheet is a
  different pose ("mocking king + bound colonist"), used by sub-variants — do
  **not** use it for the routine `@KINGTAX` popup. **BYTE_VERIFIED**
  (`docs/KING_AND_CINEMATIC_AUDIT.md` lines 35–36).
- **Options:** `TAXOPTIONS` — *"Kiss the pinky ring"* (accept) / *"Hold a
  [Good] Party"* (refuse → boycott). **BYTE_VERIFIED** key
  (`docs/KING_AND_CINEMATIC_AUDIT.md` line 241).
- **Title variant:** the monarch is addressed as **Viceroy** or **Stadtholder**
  depending on the human player's nation (investiture sequence). Exact gate
  offset **TBD** (reported near `func_075594` / `0x0755A7`; not byte-confirmed
  here) — see §7. Cross-ref `docs/KING_AND_CINEMATIC_AUDIT.md`.

Panel geometry / hit-regions follow the shared dialog framework — see
`docs/DIALOG_GEOMETRY.md` and `docs/POPUP_TEMPLATE_AUDIT.md`.

## 5. Evidence (citations)

- `docs/DATA_MODEL.md` — PowerRecord base `0x8808`/stride 316; `+0x01` tax,
  `+0x22` royal_money, `+0x2A` gold; globals `0x538E`, `0x53A6`, `0x84FC`. (B)
- `func_034AE0` (`code/VICEROY/disasm/`, `code/DISASM_LEDGER.md:765` DONE) —
  tax-change routine. (A)
- `ghidra_export/VICEROY2_annotated.c:215` — `king_attempt_tax_change`, delta
  expression. (R, decompiler-inferred)
- `notes/COLONIZATION_TECHNICAL_REFERENCE.md` §12 + §"Tax revenue calculation" +
  §"Tax rate cap (CMP …,0x4B)". (B for the cap; R for the revenue loop)
- `docs/KING_AND_CINEMATIC_AUDIT.md` lines 35–36, 241 — portrait, message key,
  options. (B)
- `GAME.TXT @KINGTAX` line 1622; `TEXT_LABEL_AUDIT.md`. (B)

## 6. Confidence summary

- **Solid (B):** state layout (tax/gold/royal_money offsets, turn counter,
  difficulty), the 75% cap, the dialog's message key / portrait / options.
- **Reconstructed (R):** the tax-change `delta` formula, the per-good revenue
  loop, the difficulty leniency intervals, the REF unit-count offsets.
- **TBD:** pretext-selection logic & cadence table, REF growth threshold, the
  Viceroy/Stadtholder gate offset, Tea-Party boycott bookkeeping.

## 7. Open questions (TBD) → feeds `spec/BACKLOG.md`

1. **Byte-confirm the tax `delta` formula.** Disasm `func_034AE0` (file
   `0x034AE0`, ~39 bytes) and verify `((diff & 0xFE)*2 + 4)` against the bytes;
   promote R→B or correct it.
2. **Tax-raise cadence & pretext selection.** Trace the `0x538E`-gated caller of
   `func_034AE0` (the modulo gates in `ghidra_export`) to pin the interval table
   and how a pretext key is chosen.
3. **REF growth threshold.** `royal_money +0x22` grows +18/turn at Discoverer;
   the spend/threshold that adds a REF unit is unknown (no unit added ≤1188 in
   two runtime sessions, per `docs/DATA_MODEL.md`).
4. **Viceroy vs Stadtholder gate.** Confirm the title-variant condition near
   `func_075594` / `0x0755A7`.
5. **Tea-Party boycott bookkeeping.** Which field stores the per-good boycott
   bitmask and how back-tax payment clears it (Jakob Fugger FF forgives all).

Cross-source conflicts (the `+0x22`/`+0x2A` treasury question) are ruled in §2
and recorded in `notes/rulings/RULINGS.md`.
