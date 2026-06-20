# Mercenary Hiring

> **Layer 2 — Specification.** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R/TBD.
> Re-grounded 2026-06-18 from the **real key bodies** (the breadth stub guessed
> from empty keys and mis-anchored on `@MERCENARY`).

**Overall confidence:** offer text `BYTE_VERIFIED`; **price formula `BYTE_VERIFIED`**
(wartime + peacetime, traced from `VICEROY.EXE`); offer trigger `BYTE_VERIFIED`;
force composition `R`. ·
**Canonical primary:** `data_extracted/text/GAME_sections.json`; `VICEROY.EXE`
`func_03E442` (wartime) / `func_03E664` (peacetime).

## 1. Purpose & behavior
The King offers to sell the player a force of **mercenary soldiers** for gold.
The player declines or pays. The mercenaries then **arrive in a colony**.

## 2. State & data (real bodies)
| Key | Real body (verbatim) | Role | Tier |
|-----|----------------------|------|------|
| `@MERCENARIES` | "The King of %STRING0 has offered to send us a force of trained {mercenaries}\n(%STRING1)\nin exchange for {%NUMBER0$}.\n\nNo thank you.\nPay {%NUMBER0$}." | **the offer dialog** (price `%NUMBER0`, force `%STRING1`, two options) | **BYTE_VERIFIED** |
| `@MERCS` | "%STRING1 mercenaries arrive in %STRING0." | arrival message | **BYTE_VERIFIED** |

- **Price (`%NUMBER0`) and force composition (`%STRING1`) are runtime-substituted**
  — the values come from game state, not the string; the formula is `TBD`.
- Eligibility/offer flag in game state: `TBD` (not traced).

**Corrections from the basis (do not reuse the old anchors):**
- `@MERCENARY` is **NOT** the mercenary offer — its body is *"The {%STRING0}
  declare war on the {%STRING1}."* (a war-declaration string). Excluded here.
- `@KINGBUY` = *"King increases military spending. {%STRING0} added to royal
  expeditionary force…"* → **REF buildup**, belongs to `spec/systems/ref_growth.md`.
- `@KINGMOBILIZE` = *"Parliament votes additional funds to suppress revolution…
  {%STRING1} mobilized in %STRING2."* → **REF mobilization** during revolution.
- `@KINGRECRUIT` body is empty.

## 3. Formulas & rules

There are **two** offer paths, near-identical, that share the same price shape.
Both roll a random unit `random_int(lo,hi)` via `0x181F:0x04D4` and scribble a
4-word scratch package at DGROUP `0x9E46` (count) / `0x9E48` (category A flag) /
`0x9E4C` (category C flag). `diff = byte[0x53A6]` (difficulty). The mercenary
**price (`%NUMBER0`)** is — **BYTE_VERIFIED**:

```
price = (gold_per_unit) * qty
  gold_per_unit = ( (diff + K)*2  +  random_int(0,6) ) * 100     # imul ...,0x64
  qty           = ( (catA + catC) * 2 )  +  count
```

where `K = 3` on the **wartime** path and `K = 4` on the **peacetime** path, and
`count`/`catA`/`catC` are the scratch words rolled just above the price.

### Wartime — King's intervention offer — `func_03E442` (`@0x03E512..0x03E57B`)
- `count = random_int(2, (4−diff)/2 + 2)` → `[0x9E46]`  (`@0x03E512` `sub ax,4;
  neg ax; sar ax,1; inc; inc`; roll `@0x03E523`).
- `random_int(0,1)` picks exactly one category: `≠0 → catA([0x9E48])=1`, else
  `catC([0x9E4C])=1` (`@0x03E52E..0x03E546`). So `(catA+catC)=1` ⇒ `qty = count + 2`.
- `gold_per_unit = ((diff+3)*2 + random_int(0,6)) * 100`
  (`@0x03E558` `cl=[0x53A6]; add cx,3; shl cx,1; add cx,ax; imul ax,cx,0x64`).
- `price = gold_per_unit * qty` (`@0x03E56B..0x03E57B`
  `[0x9E4C]+[0x9E48]; shl 1; add [0x9E46]; imul [bp-0x54]`).

### Peacetime — foreign-power veteran/mercenary offer — `func_03E664` (`@0x03E6C8..0x03E736`)
- `count = random_int(1,3)` then a coin (`@0x03E6D7`): heads → `count++` and **no
  category** (`catA=catC=0`); tails → `catC([0x9E4C])=1` then a second coin can
  `catC++` (`@0x03E6EE..0x03E703`). `catA` is always 0 here.
- `gold_per_unit = ((diff+4)*2 + random_int(0,6)) * 100` (`@0x03E713` `add cx,4`).
- `qty = catC*2 + count`; `price = gold_per_unit * qty` (`@0x03E726..0x03E736`).

### Offer trigger — **BYTE_VERIFIED**
- **Wartime** (`func_03E442`): only when revolution is **not** blocked by a pending
  intervention (`!([0x5382]&2 && [0x53E6]≠0)`), then a **1-in-3** gate
  (`random_int(0,2)==0`, `@0x03E4E8`). Offer is shown only **if affordable**:
  `price ≤ treasury` where `treasury = *(int32*)([0x84FC]+0x2A)` (`@0x03E5FD`).
- **Peacetime** (`func_03E664`): gated **off** once the revolution is declared
  (`[0x5382]&1 → return`), then a **1-in-21** gate (`random_int(0,0x14)≠0 → return`,
  `@0x03E66A`); the offering power `[0x53D6] = random_int(3,…)` must be at
  peace/contactable (`power_relation(...)&0x40`, `@0x03E6A2`).

### Accept / charge — **BYTE_VERIFIED**
On *Pay* (`msg_show` returns `2`), debit the buyer's treasury in place
(`*(int32*)([0x84FC]+0x2A) −= price`, wartime `@0x03E651`) and run the accept
side-effect `func_03EA42(1)` (spawns the force / `@MERCS` arrival).

- **Force (`%STRING1`):** the offer text is assembled from `count` plus category
  strings (`str@0x5284`/`0x5268` base, `+0x52A0` for cat A, `+0x52CA` for cat C);
  the concrete unit types per category are **R** (string-built, unit spawn in
  `func_03EA42` not yet traced).

## 4. UI
Offer dialog from `@MERCENARIES` (King speech-bubble framework, `KING.SS`),
two options *No thank you* / *Pay {%NUMBER0$}*; arrival via `@MERCS`. See
`spec/ui/popups.md`.

## 5. Evidence
- `data_extracted/text/GAME_sections.json` — `@MERCENARIES`, `@MERCS` (full
  bodies). **B**
- `VICEROY.EXE` `func_03E442` (`0x03E442..0x03E663`, wartime King's offer) — price
  `@0x03E512..0x03E57B`, 1/3 gate `@0x03E4E8`, affordability/debit `@0x03E5FD/0x03E651`,
  byte-traced. **B**
- `VICEROY.EXE` `func_03E664` (`0x03E664..0x03E842`, peacetime foreign offer) — price
  `@0x03E707..0x03E736` (K=4), 1/21 gate `@0x03E66A`, byte-traced. **B**
- `random_int(lo,hi)` helper `0x181F:0x04D4`; difficulty `byte[0x53A6]`; buyer
  treasury `*(int32*)([0x84FC]+0x2A)`. **B**
- `docs/GAME_MANUAL.md` — King sells mercenaries for gold. **R**

## 6. Open questions (TBD)
1. **Force composition** (`%STRING1`) — the concrete unit type/count each category
   (A `+0x52A0` / C `+0x52CA`) spawns; trace `func_03EA42` (accept side-effect).
2. Confirm `random_int(0,6)` / `random_int(0,2)` inclusivity convention of
   `0x181F:0x04D4` (affects the exact min/max gold-per-unit bounds, not the shape).
