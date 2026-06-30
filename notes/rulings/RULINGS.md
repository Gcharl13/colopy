# Rulings — reconstructed / non-byte-verified decisions

This log records gameplay rules that are **not** byte-verified from the original binary
(which is not committed to this repo) and were therefore *reconstructed* from the manual and
known original-game behavior. Each is editable data/logic so it can be replaced with a
byte-verified formula if the disassembly/`VICEROY.EXE` is later added. Tier convention follows
`spec/` (B = BYTE_VERIFIED, A = ANCHOR_VERIFIED, R = RECONSTRUCTED).

## 2026-06-30 — Rush-buy ("Complete it") gold cost — **R (RECONSTRUCTED)**

**Question.** When the player pays gold to finish a colony's current building immediately (the
`@BUYME0`/`@BUYME1` "Cost to complete %STRING0: %NUMBER0$" dialog), what is `%NUMBER0` — the gold
cost?

**Status.** The cost computation is **not decoded**. `spec/systems/colony.md` documents the dialog
and a side-effect of the buy path (`page_0E @0x5627D` sets the food accumulator floor to 2 after a
−10 treasury debit) but **not** the `%NUMBER0` cost formula, and the raw disassembly / `VICEROY.EXE`
is not present in this repo, so it cannot be byte-traced here.

**Ruling (reconstructed).** The rush cost is modeled as a function of the **hammers still needed**,
computed in the `colony_rush_buy` graph by a **Formula node** (not hardcoded in the sim), so it is
fully visible and editable:

```
rush_cost = colony<N>.build_remaining * GOLD_PER_HAMMER        ( + tools premium, see below )
```

with `GOLD_PER_HAMMER` a tunable constant in the Formula (default 8). The original game also
charges more when **no** hammers have been invested yet and adds a tools component; a fuller
reconstruction is:

```
rush_cost = remaining_hammers * GOLD_PER_HAMMER
          + remaining_tools  * GOLD_PER_TOOL
          * (build_bank == 0 ? NO_PROGRESS_PREMIUM : 1)
```

The sim function `rush_build(Colony&, Power&, gold_cost)` (`sim/economy.cpp`) only **applies** a
cost the caller supplies — it debits the owner's gold if affordable, sets the built bit, and
clears the target. It contains **no** cost constants, keeping the reconstructed curve in the
editable logic layer.

**To upgrade to B:** add `VICEROY.EXE`/the disassembly to the repo, byte-trace the `@BUYME0`
`%NUMBER0` producer (the function that pushes string handle for `@BUYME0`/`@BUYME1` and computes
`[bp-...]` cost before the dialog), and replace the Formula's expression with the verified curve.
