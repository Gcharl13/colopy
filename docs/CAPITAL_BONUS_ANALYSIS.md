# Capital raze gold — bonus formula analysis

User-reported data points (session_1777952458 + session_1777955389,
both Discoverer difficulty):

| Capital | Pop (NativeSettlement +0x04) | Total gold | Civ tier |
|---------|----:|-----------:|----:|
| Inca (38,54) | 13 | 15,000 | 3 |
| Aztec (15,26) | 10 | 10,000 | 2 |

**Correction (2026-05-04)**: The `@TRIBES` column-5 values (Inca=97,
Aztec=149, Apache=111, Sioux=118, etc.) were initially mistaken for
"base wealth" in earlier drafts of this doc. They are
**palette color indices** for the tribe's map marker, not gold
values. Inca=97 → `#f7f3c7` (cream); Aztec=149 → `#c7a220` (gold/
ochre, fittingly matching their "Gold Bars" treasure theme); Sioux=
118 → `#920000` (dark red). The ordering (Apache 111 > Inca 97
despite Apache being tier-0 and Inca tier-3) was the giveaway — see
`RESIDUAL_FINDINGS.md` and the tribe-color verification table below.

| Tribe | @TRIBES col-5 | RGB at that idx | Hex | Hue |
|-------|--------------:|-----------------|------|------|
| Inca | 97 | (247,243,199) | `#f7f3c7` | cream / parchment |
| Aztec | 149 | (199,162,32) | `#c7a220` | gold / ochre |
| Arawak | 54 | (105,138,195) | `#698ac3` | blue |
| Iroquois | 87 | (109,60,24) | `#6d3c18` | dark brown |
| Cherokee | 67 | (117,166,77) | `#75a64d` | green |
| Apache | 111 | (195,174,134) | `#c3ae86` | tan |
| Sioux | 118 | (146,0,0) | `#920000` | dark red |
| Tupi | 71 | (4,93,4) | `#045d04` | dark green |

H3 (`bonus = base_wealth × dice_roll`) below is therefore
**rejected outright** — the "base_wealth" inputs were never wealth.

## Pure CHIEFKILL ceiling

`gold = sum_3 × roll_4 × 4 × (pop + 1)` where `sum_3 ∈ [3, 30]` and
`roll_4 ∈ [1, 6]` at Discoverer.

- Inca (pop=13): max 30 × 6 × 4 × 14 = **10,080**
- Aztec (pop=10): max 30 × 6 × 4 × 11 = **7,920**

Both observed totals exceed the CHIEFKILL ceiling, confirming a
capital-only bonus exists.

## Excess (minimum bonus magnitude)

- Inca excess: 15,000 − 10,080 = **at least +4,920**
- Aztec excess: 10,000 − 7,920 = **at least +2,080**

## Hypothesis comparison

### H1: Bonus = second independent CHIEFKILL roll

`total = chiefkill + bonus_chiefkill`, both with same dice ranges.

- Inca total range: 336 .. 20,160. 15,000 plausible.
- Aztec total range: 264 .. 15,840. 10,000 plausible.

**Status**: fits both within bounds, but requires both rolls to be
high. Probability of getting exactly 15,000 from this distribution
is non-trivial to compute but plausible.

### H2: Bonus = 2 × chiefkill (same dice doubled)

`total = 2 × chiefkill`.

- Inca: 15,000 / 2 = 7,500. Need chiefkill = 7,500 = sum × roll × 56.
  sum × roll = 134. **Not divisible** — sum × roll must be integer.
- Aztec: 10,000 / 2 = 5,000. Need chiefkill = 5,000 = sum × roll × 44.
  sum × roll = 113.6. **Not integer.**

**Status**: REJECTED — doesn't divide evenly.

### H3: Bonus = NAMES.TXT_base × roll

`total = chiefkill + base_wealth × dice_roll`.

- Inca base=97. Excess >= 4,920. roll >= 50.7 → 51.
- Aztec base=149. Excess >= 2,080. roll >= 13.96 → 14.

The required rolls are very different — base × const doesn't fit
with one global multiplier.

**Status**: requires varying dice, possible but no clean fit.

### H4: Bonus = civ_tier × pop × dice + small_roll

Inca: tier=3, pop=13 → tier×pop = 39. Excess 4,920 / 39 = 126
Aztec: tier=2, pop=10 → tier×pop = 20. Excess 2,080 / 20 = 104

If dice value is in 100..150 range, both fit. But that's a really
high dice roll.

### H5: Bonus = 1,000 × civ_tier × dice(1..5)

Inca: 1000 × 3 × roll. roll=1..5 → 3000..15000. Excess 4920 fits
(roll≈2 gives 6000 + chiefkill 9000 = 15000).
Aztec: 1000 × 2 × roll. roll=1..5 → 2000..10000. Excess 2080 fits
(roll≈2 gives 4000 + chiefkill 6000 = 10000).

**Status**: clean match to "round numbers." Both 15,000 and 10,000
are nice round multiples consistent with this formula. Most plausible.

## Most-likely formula (provisional)

```
chiefkill   = sum_3 × roll_4 × 4 × (pop + 1)            ; standard
capital_bonus = 1000 × civ_tier × random_int(1, 5)        ; capital only
                                                          ; (or similar)
total       = chiefkill + capital_bonus                  ; for capital razes
```

Where `civ_tier` is the NAMES.TXT @TRIBES column-4 value (Inca=3,
Aztec=2, mid-tier=1, low-tier=0).

For low-tier (civ=0) tribes, capital_bonus = 0, so razing a Sioux/
Apache/Tupi capital gives chiefkill only. This matches Colonization's
gameplay where Inca/Aztec capitals are MUCH richer prizes.

## Open questions

- The exact bonus dice range (1..5? 0..10? something else?)
- Whether civ_tier multiplier is exactly 1000 or another value
- Whether the bonus uses RNG independent of CHIEFKILL or shares
  the same `roll_4` etc.

## Next data points to collect

To uniquely solve the formula:
- **Mid-tier capital raze** (Iroquois, Cherokee, Arawak): would
  pin down whether civ_tier=1 has a bonus or not.
- **Multiple razes at same difficulty**: would let us fit the
  bonus distribution.
- **Difficulty=Viceroy capital raze**: tests whether `upper` (10-diff)
  affects the bonus dice or only the CHIEFKILL portion.

## In-game source location

Per `func_04A7CA` (CHIEFKILL formula at file 0x04AAD0..0x04AB6E):
the formula reads NativeSettlement +0x04 (population) for size_byte.
For capital razes, the function likely branches into a separate
"capital bonus" code path — find via:

1. Disasm of `func_04A7CA` looking for branches conditional on
   `(NativeSettlement +0x03 & 0x04)` (the capital flag bit).
2. Check what code path is taken when `+0x03 & 0x04 != 0`.
3. The bonus formula will be in that branch.

This decompilation work is queued — bonus formula will become
BYTE_VERIFIED once the disasm branch is read.
