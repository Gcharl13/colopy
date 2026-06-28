# Mercenary Hiring

> **Layer 2 — Specification.** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R.
> Re-grounded 2026-06-18 from the **real key bodies** (the breadth stub guessed
> from empty keys and mis-anchored on `@MERCENARY`).

**Overall confidence:** offer text + **price formula + offer trigger + force
composition** all `BYTE_VERIFIED` (wartime + peacetime, traced from `VICEROY.EXE`). ·
**Canonical primary:** `data_extracted/text/GAME_sections.json`; `VICEROY.EXE`
`func_03E442` (wartime offer) / `func_03E664` (peacetime offer) /
`func_03D510` (force landing) / `func_03C4A2` (per-category unit type).

## 1. Purpose & behavior
The King offers to sell the player a force of **mercenary soldiers** for gold.
The player declines or pays. The mercenaries then **arrive in a colony**.

## 2. State & data (real bodies)
| Key | Real body (verbatim) | Role | Tier |
|-----|----------------------|------|------|
| `@MERCENARIES` | "The King of %STRING0 has offered to send us a force of trained {mercenaries}\n(%STRING1)\nin exchange for {%NUMBER0$}.\n\nNo thank you.\nPay {%NUMBER0$}." | **the offer dialog** (price `%NUMBER0`, force `%STRING1`, two options) | **BYTE_VERIFIED** |
| `@MERCS` | "%STRING1 mercenaries arrive in %STRING0." | arrival message | **BYTE_VERIFIED** |

- **Price (`%NUMBER0`) and force composition (`%STRING1`) are runtime-substituted**
  — the values come from game state, not the string. The price formula and the
  force-composition (count/category) rolls are **BYTE_VERIFIED** — see §3
  (`func_03E442` wartime `@0x03E512..0x03E57B`, `func_03E664` peacetime
  `@0x03E6C8..0x03E736`). **B**
- Eligibility/offer flag in game state: the offer-trigger code in `func_03E442` is
  reached only when a **per-power one-shot bit** on the active `PowerRecord` is
  already set — `func_03E442 @0x03E4BC` `test byte ptr [bx],8` (`bx = word[0x84FC]`,
  the active `PowerRecord` offset set by `func_030550` from the `[bp+6]` power arg);
  if clear, the routine instead **sets** it (`@0x03E4CD` `or byte ptr [bx],8`) and
  returns with no offer. So a foreign power makes no offer on its first eligible
  call and only from the second onward (bit `0x08` of `PowerRecord+0x00`). **B**
  The init side-effect run on that first call (`@0x03E4C3` `call 0x3EA2E →
  0x1A1F:0xC4`) **RESOLVED 2026-06-27** to overlay **`func_03E2EA`** (page 6, `@0x3E2EA`, `ENTER 0xC`;
  `0x3EA2E` is a `ljmp` dispatch island). **Effect fully decoded (overlay page_06.asm `0x3E2EA..0x3E440`):**
  it is the **Declaration-of-Independence Continental-promotion pass**. Outer loop over all colonies
  (`[0x539E]` num_colonies, `func_0082DC` select-colony @0x03E3D5) whose owner matches the power arg
  (`cmp [colony+0x1a],[bp+6]` @0x03E3E4) **and** whose Sons-of-Liberty % `≥ 50` (`func_008524`→colony
  `+0xC2`, `cmp ax,0x32; jl skip` @0x03E3F1). A per-colony promotion budget `[bp-2]` is scaled from
  SoL% and colony size `+0x1F` (`((SoL−50)·(size/2))/50`, clamped `≥1`, @0x03E3F6..0x03E425). It then
  walks the colony's unit stack (`func_0066CC` units-on-tile @0x03E436, `func_0066BA` next-unit
  @0x03E311) and, for each **Veteran** unit (`UnitRecord+0x315b vet_type == 0x15`, @0x03E337) of
  **type 1 Soldiers** or **type 4 Dragoons** (`cmp [bx+0x3146],1 / ,4` @0x03E326/0x03E32D), decrements
  the budget and **promotes** it: **type 1 → type 9 Continental Army** (`mov [si+0x3146],9` @0x03E37B),
  **type 4 → type 7 Continental Cavalry** (`mov [si+0x3146],7` @0x03E306). A per-colony message is
  emitted (`func_06C23C` with the new type's `@UNIT` name pointer `[bx+0x5230]`, stride 14, @0x03E366;
  message ids `0x132d`/`0x1336` via `func_06F5F2`/`0x181F:0x652` @0x03E3BF). It is **not** a force
  spawn — no units are created; it upgrades existing veterans in-place. (Type ids: `viceroy_source/data/
  unit_classes.c` `@UNIT` — 1=Soldiers, 4=Dragoons, 7=Cont. Cav., 9=Cont. Army; field meanings
  `viceroy_source/include/unit.h` `+0x02`=type(0x3146)/`+0x17`=vet_type(0x315b).) **BYTE_VERIFIED (B).**

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

### Force composition (`%STRING1`) — **BYTE_VERIFIED**
`func_03EA42(1) → func_03D510` is the **shared force-landing routine** (also used
by the free foreign intervention with arg `0`). For the purchased-mercenary path
(arg `≠ 0`) it:

1. **Picks the arrival colony** — a **population-weighted random** among up to 10 of
   the buyer's **coastal** colonies (`ColonyRecord +0x1C & 0x40`), weight = colony
   size `+0x1F` (`@0x03D528..0x03D5C1`), then scores the best adjacent **beach**
   tile (`@0x03D5CC..0x03D72A`). This is the colony named in `@MERCS`.
2. **Lands a `Man-O-War` (unit type 18)** as the carrier at that beach
   (`@0x03D748` `place_unit(type 0x12)`).
3. **Loads the troop stack** onto it (`@0x03D8C8` create at sentinel `(-2,-2)` =
   carried). The **per-category counts are the offer package** (`@0x03D919`
   `budget = [0x9E46 + cat*2]`, i.e. the same numbers shown in the offer text):
   - **cat 0** = `[0x9E46]` (`count`) units,
   - **cat 1** = `[0x9E48]` (category-A flag, 0/1) units,
   - **cat 3** = `[0x9E4C]` (category-C flag, 0/1/2) units. *(cat 2 is skipped.)*
4. **Per-category unit type** from `func_03EA10 → func_03C4A2(power, cat)`
   (`@0x03C4A2`), keyed on the revolution flag `[0x5382]&1` (and the buyer being a
   human/foreign power, `power<4 && AIPersonality[power]==0`):

   | cat | package word | **wartime** (`[0x5382]&1`) | **peacetime** | AI/default |
   |-----|--------------|---------------------------|---------------|-----------|
   | 0 | `[0x9E46]` count | **Continental Army (9)** | **Dragoons (4)** | Regulars (6) |
   | 1 | `[0x9E48]` A-flag | **Continental Cavalry (7)** | **Dragoons (4)** | Cavalry (8) |
   | 3 | `[0x9E4C]` C-flag | **Artillery (11)** | **Artillery (11)** | Artillery (11) |

   (Type ids per `viceroy_source/data/unit_classes.c` `@UNIT`.)
5. **Every spawned land unit is a Veteran** — `UnitRecord +0x17 vet_type := 0x15`
   (`@0x03D835`; `vet_type` range `0x13..0x1C`, `unit.h`).

So a typical **wartime** King's package is *N Veteran Continental Army* plus
**either** *1 Veteran Continental Cavalry* **or** *1 Veteran Artillery* (exactly one
category set in the wartime roll), delivered by a **Man-O-War**; the **peacetime**
foreign offer is *N Veteran Dragoons* + *1–2 Veteran Artillery*. The `@MERCENARIES`
`%STRING1` text is built from the same `count`/category words (base `str@0x5284`
wartime / `0x5268` peacetime, `+0x52A0` cat A, `+0x52CA` cat C).

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
- `VICEROY.EXE` `func_03D510` (`0x03D510..0x03D947`, force landing) — colony pick
  `@0x03D528`, Man-O-War lead `@0x03D748`, mercenary per-category budget
  `@0x03D919`, veteran stamp `@0x03D835`; byte-traced. **B**
- `VICEROY.EXE` `func_03C4A2` (`0x03C4A2`, via thunk `func_03EA10`/`0x1A1F:0x70`) —
  per-category unit type by revolution flag `[0x5382]&1`; byte-traced. **B**
- `viceroy_source/data/unit_classes.c` `@UNIT` (type ids) + `viceroy_source/include/unit.h`
  (`+0x17 vet_type`). **B**
- `docs/GAME_MANUAL.md` — King sells mercenaries for gold. **R**

## 6. Open questions
1. ~~Resolve the `%STRING1` unit-type label pointers.~~ **Done 2026-06-20** — they are
   **entries in the `@UNIT` stat table** (base `DGROUP:0x5230`, stride 14, word[0] =
   name-string pointer), init by the `@UNIT` loader (`@0x074EEE mov [bx+0x5230],ax`):
   **`[0x5268]`→idx 4 Dragoons, `[0x5284]`→idx 6 Regulars, `[0x52A0]`→idx 8 Cavalry,
   `[0x52CA]`→idx 11 Artillery** (cross-checked vs the REF display `func@0x37E1C`). **B.**
2. ~~`random_int` inclusivity.~~ **Done 2026-06-20** — `0x181F:0x4D4 → func_00C322` =
   `lo + (rand16·(hi−lo+1))>>16`, i.e. **`[lo,hi]` inclusive**; `random_int(0,6)`=0..6
   (7 values). Merc/CHIEFKILL bounds inclusive. **B.**
