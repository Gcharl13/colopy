# Difficulty Levels

> **Layer 2 — Specification (population stub).** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R/TBD. Details TBD — breadth pass.

**Overall confidence:** 5 level names + global byte `BYTE_VERIFIED`; **a broad set
of per-level modifier formulas `BYTE_VERIFIED`** (REF size, combat handicap,
native attitude, diplomacy demands — see §3); some economy/king touch points still
`R`/`TBD`.
**Canonical primary:** `data_extracted/text/NAMES_sections.json` (@DIFFICULTY),
`docs/DATA_MODEL.md` (DGROUP `0x53A6`).

## 1. Purpose & behavior
A difficulty level chosen at setup adjusts many factors to make the game easier
or harder (`docs/GAME_MANUAL.md`). Five levels, ascending:

| Idx | Name | Manual gist |
|-----|------|-------------|
| 0 | Discoverer | easiest; novice players |
| 1 | Explorer | opponents stronger/smarter, natives less friendly |
| 2 | Conquistador | enemies substantially more aggressive |
| 3 | Governor | opponents evenly matched with player |
| 4 | Viceroy | hardest; winnable but not consistently |

Names `BYTE_VERIFIED` from `@DIFFICULTY`; ordering matches manual.

## 2. State & data
- `@DIFFICULTY` (`NAMES_sections.json`): 5 level strings (above). **BYTE_VERIFIED**.
- **DGROUP `0x53A6`** — byte holding "difficulty / current player (0..4)"
  (`docs/DATA_MODEL.md:280`, BYTE_VERIFIED via king-tax + SMITE byte-traces;
  also listed `docs/ARCHITECTURE.md:108`). **BYTE_VERIFIED**.
  > Note: this single byte is documented as serving both "current player" and
  > "difficulty" roles; disambiguate at the read site before relying on it.

## 3. Formulas & rules
`diff` = byte `[0x53A6]` (0=Discoverer … 4=Viceroy). Most sites gate the
difficulty term on `AIPersonality.controller` (`[idx·0x34 + 0x543F]`): the human
branch carries the `diff` term while the AI branch uses a fixed constant — i.e.
**the difficulty term is a human handicap**, not a symmetric scaler. (Caveat:
`0x53A6` is dual-role — also "current player"; the sites below were confirmed to
be genuine difficulty arithmetic, not player indexing.)

### Byte-verified per-level formulas (2026-06-20 trace; high confidence)
| Mechanic | Formula | Site |
|---|---|---|
| **Starting REF — regulars** | `[0x53DA] = 8·diff + 15` (15/23/31/39/47) | `new_game_state_init @0x7569B` |
| **Starting REF — cavalry** | `[0x53DC] = 5·(diff+1)` (5/10/15/20/25) | `@0x7569B` |
| **Starting REF — artillery** | `[0x53E0] = 6·diff + 2` (2/8/14/20/26) | `@0x7569B` |
| **Starting REF — man-o-war** | `[0x53DE] = 3·diff + 2` (2/5/8/11/14) | `@0x7569B` |
| **Combat human handicap** | attacker `[bp-0x90] += (4−diff)`; defender `[bp-0xa6] += (4−diff)` (human only) → fed to `odds=ATK/(ATK+DEF)` | land decider `func_05CA7E @0x5CE35`/`@0x5CE54` |
| **Generic combat base** | `strength_base [bp-0x34] = diff + 5` | `@0x3F005` |
| **Native attitude (human)** | `2·(diff+3) + tribe[+2] + tribe[+5] − prior`; threshold `0x41` | native eval `@0x46500` |
| **Native attitude (AI)** | `tribe[+2] + tribe[+5] − diff + 12 − prior`; threshold `0x32` | `@0x46538` |
| **Native per-power seed** | AI powers: `tribe[+0x46 + power·2] = rand(0..13) + 2·diff` | tribe init `func_065D26 @0x65DCE` |
| **AI war/refusal grace** | `10·(10−diff)` turns (100/90/80/70/60) | diplomacy `@0x58374` |
| **AI tribute/demand value** | `value · 10·(diff+8)/100` (×0.8…×1.2) | `@0x583A0` |
| **AI demand surcharge** | `+= 500·(diff+1)` | `@0x5842B` |
| **AI/native action prob** | `random_int(1000) < 200·diff + 100` (10%…90%) | `@0x4A73D`, `@0x58315` |
| **Easy-mode double starting units** | at `diff ≤ 1` the human reruns the starting-unit placement a 2nd time (double Caravel+Pioneer+Soldier, stamped Veteran) | new-game setup `func_0755CC @0x0758F5`/`@0x075961` |

Net effect of the human-side terms: higher difficulty → larger Royal Expeditionary
Force at independence, less combat padding for the player, worse native attitude,
and more aggressive/expensive AI diplomacy. **B** (the rows above).

### Touch points consistent with the same idioms (spot-checked subset; treat as R until each is instruction-verified)
- **Native gift/treasure:** reward `2·diff+15` (`@0x4A05A`); `10·(diff+rand)`
  (`@0x4A0C2`); gate `diff+1` + cap `8−diff` (`@0x4A2A9`); native price floor
  `5·diff+50` (`@0x5C976`). (CHIEFKILL roll bound `(8−diff)<<scout` `@0x4A84D` is
  already **B** in `natives.md`.)
- **Native aggression:** attack chance `random_int((5−diff)·2)` (`@0x48697`);
  raid severity family in `native_raid_outcome_dispatch` (`@0x5BF1A`…`@0x5C09E`);
  native-war escalation `(diff+1)/100` (`@0x3F0B2`).
- **King / REF / mercenaries:** REF budget `8·diff+10` (`@0x3E17C`); merc cost
  `((diff+3)·2+rand)·100·troops` (`@0x3E558` — confirms `mercenary.md`); King
  reinforcement `+ diff + 1` (`@0x3CC06`); King merc stock `100·(10−diff)`
  (`@0x529FC`).
- **Economy / immigration / score:** immigration cost `(8−diff)/8` (`@0x35E60`,
  cross-ref `national_powers.md` English ×2/3); rival-immigration bonus
  `100·(diff+1)` (`@0x35FFB`); production base `diff+5` (`@0x8AFF`); score
  multiplier `diff+4 (+1 if≥3, +1 if≥4)` (`@0x3AA0A`, already **B** in scoring);
  FF score penalty `ff_count·(−1−diff)` (`@0x3A4B9`).

### Non-mechanics (excluded — do not cite as difficulty modifiers)
- `g_king_galleon_displaynum[diff]` (base `−0x7C6C`, index `diff·2`) is **UI
  salutation text only** (15 push sites incl. `@0x2F2CC`, `@0x34B7E`, `@0x73031`);
  confirms `spec/BACKLOG.md` galleon-fee correction.
- `@0x705D2`/`@0x706A3`/`@0x7071E` = difficulty-**selection** setup screen (write
  `0x53A6`, `(diff+4) mod 5` wrap); `@0x47968`/`@0x70378` = dead read / player-index
  compare.

### Manual-sourced (R — byte-confirm pending)
- Indian Destruction Penalty = `−(diff + 1)` per native settlement destroyed
  (`docs/GAME_MANUAL.md`). **R**.
- **Tory production-penalty threshold = `10 − diff`** (10 at Discoverer … 6 at
  Viceroy, `docs/GAME_MANUAL.md:3528`): when a colony's Tory count reaches this
  number, all production there drops by 1. **Value BYTE_VERIFIED:** the colony-
  production region computes `ax = 10 − diff` for a human-controlled owner
  (`mov al,[0x53a6]; sub ax,0xa; neg ax`) and a fixed **10** (or **0x32**) for AI,
  at **`@0x9D49`, `@0xA05C`, `@0x27416`** (all three same idiom, gated on
  `[bx+0x1a]<4 && [idx·0x34+0x543F]==0`). The `10−diff` value exactly matches the
  manual's 10→6, identifying this family as the SoL/Tory production thresholds.
  **B** (value); the exact site→effect binding (which of the three is the Tory
  *penalty* vs the SoL *bonus* divisor) is the residual — cross-ref
  `spec/systems/tory_uprising.md`, `spec/systems/colony.md` (SoL production).

## 4. UI
Selected on the difficulty-selection setup screen (manual). Strings in the
opening/menu catalogs; layout `TBD`.

## 5. Evidence
- `data_extracted/text/NAMES_sections.json` — `@DIFFICULTY` (5 names). **B**
- `docs/DATA_MODEL.md:280` / `docs/ARCHITECTURE.md:108` — DGROUP `0x53A6`. **B**
- `VICEROY.EXE` `new_game_state_init @0x7569B` — starting REF (regulars/cavalry/
  artillery/man-o-war) as `8·diff+15 / 5·(diff+1) / 6·diff+2 / 3·diff+2`. **B**
- `VICEROY.EXE` `func_05CA7E @0x5CE35`/`@0x5CE54` — human combat handicap `+(4−diff)`. **B**
- `VICEROY.EXE` native eval `@0x46500`/`@0x46538` — native attitude human/AI split. **B**
- `VICEROY.EXE` diplomacy `@0x58374`/`@0x583A0`/`@0x5842B`/`@0x58315` — AI grace/demand/prob. **B**
- `docs/GAME_MANUAL.md` — level descriptions; Indian penalty. **R**

## 6. Open questions (TBD)
1. ~~Byte-trace per-level modifier table.~~ **Done 2026-06-20** — REF size, combat
   handicap, native attitude, diplomacy demands, action probability all **B** (§3).
   Residual: instruction-level confirm of the §3 "touch points" subset
   (economy/king clusters) and the native field `+0x46` label.
2. Resolve the `0x53A6` dual role (difficulty vs current player) at read sites.
3. ~~Confirm the score difficulty factor.~~ **Done** — `diff+4 (+1 if≥3, +1 if≥4)`
   `@0x3AA0A` (**B**, see scoring). Indian-destruction penalty still **R**.
