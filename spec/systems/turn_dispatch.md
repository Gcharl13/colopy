# Turn Dispatch & Phases

> **Layer 2 — Specification (population stub).** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R/TBD. Details TBD — breadth pass.

**Overall confidence:** **main turn loop `func_005760`, power iteration order, and
turn/year cadence `BYTE_VERIFIED`** (2026-06-20); the per-power phase *ordering*
(inside the two per-power processors `func_03E664`/`func_024A48`) `TBD`.
**Canonical primary:** `func_005760` (the loop); `docs/ARCHITECTURE.md`;
`data_extracted/text/NAMES_sections.json` (@NATIONALITY).

## 1. Purpose & behavior
Each turn the game iterates active powers and, per power, processes pending events
(combat, market, king, diplomacy) via function dispatchers, then redraws the
viewport/HUD and writes saves at intervals (`docs/ARCHITECTURE.md`). Powers:
0..3 European players + 4..11 native tribes (`docs/ARCHITECTURE.md`). **B** (iteration scheme).

**Power order — BYTE_VERIFIED (2026-06-20):** the loop processes the **4 European
powers in strict index order 0,1,2,3** (English/French/Spanish/Dutch), indexing
`AIPersonality[idx] = idx·0x34 + 0x540E` and testing the controller byte
`[idx·0x34 + 0x543F]` (`@0x57C5`/`@0x58AA`/`@0x5929`). **Natives are NOT a separate
turn pass** — the prior "natives → English → …" framing is superseded; native
relations are handled within/transitively from each European power's processing,
not as powers 4..11 in the top loop.

## 2. State & data
DGROUP anchors (`docs/ARCHITECTURE.md`, BYTE_VERIFIED):
- `0x53A6` — **difficulty level (0..4)** (byte), *not* current player (resolved 2026-06-20, `difficulty.md` §6.2; current power index = `[0x5394]`). **B**
- `0x538E` — turn counter (16-bit, BYTE_VERIFIED via king-tax formula). **B**
- `0x5382` — game flags. **B**
- PowerRecord[N] at `0x8808 + N×0x13C` (base `0x8808`; `0x8809` is the off-by-one
  first-field addr, corrected per RULINGS 2026-05-30 wave-3); UnitRecord[N] at
  `0x3144 + N×0x1C` (base `0x3144` per RULINGS 2026-05-28; `0x3146` is the type field
  at `+0x02`); AIPersonality[N] at `0x540E + N×0x34`. **B**

**Main turn loop — `func_005760` (file `0x5760`, `enter 0x16`, ends `retf @0x5BF9`).
BYTE_VERIFIED.** It is the multi-turn game loop: one turn begins at `0x5836`; at the
end (`0x5BF4`) it `jmp 0x5836` to run the next turn while the **continue-gate
`[0x53C2] != 0`** (`@0x5BED`); when the gate clears it `leave/retf`. Called **once**
from the new-game/load setup machine `func_075FB6` (`@0x76330`, thunk `0x181F:0x546`);
the gate `[0x53C2]` is armed `@0x76309` at game start. **New-game init:** year
`[0x538a] = 0x5D4` (**1492**) `@0x757E7`, turn `[0x538e] = 0` `@0x757EF`, season
`[0x538c] = 0` `@0x757F2`. The end-of-turn / year-advance block is **inline at the
loop tail** (`0x5A9D..0x5BF9`), run once per turn after all powers.

> There is **no single ~27-case turn-phase dispatcher** — the phases are a
> straight-line + per-power-processor structure (§3). The "~27-case dispatcher"
> guess is retired; the 35-entry switch `@0x0D2AC` (and `@0x233D7`/`@0x2C076`) are
> **keyboard/command routers**, not turn sequencers.

## 3. Formulas & rules

### Per-power phase structure — BYTE_VERIFIED (call graph) / TBD (intra-order)
`func_005760` issues, per power, a set of direct calls (thunks resolved); the big
system functions are **not** called from the top loop — they are reached
*transitively* from the two per-power processors, so the fine phase ordering lives
one level down:
| call from `func_005760` | → function | role |
|---|---|---|
| `@0x5866` (`0x181F:0x550`) | `func_056B08` | unit-cleanup |
| `@0x58E2` (`0x181F:0x668`) | `func_03E664` | **King/mercenary-offer phase** (peacetime mercenary roll `@0x3E707`, cross-ref `mercenary.md`; body = random rolls + offer dialog, *not* a generic AI processor) |
| `@0x58E7`/`@0x5A91` (`0x181F:0x62C`) | `func_024A48` | **orders & movement / interactive input-pump** (per-unit orders region, near order dispatch `@0x249CB`) |
| `@0x59EA` (`0x181F:0x644`) | `func_02F052` | **per-power colony/production phase** — zeroes the per-turn bells accumulator (`PowerRecord +0xE := 0` `@0x2F23F`) then loops all colonies (`[0x539E]` count) and, for each owned by the current power (`ColonyRecord +0x1A == power` `@0x2F256`), calls **production `func_02D658`** (`@0x2F25F`, thunk `0x191F:0x950`) |
| `@0x5A37` (`0x181F:0x638`) | `func_052F7E` | diplomacy/meeting context |
| `@0x5AE5` (`0x181F:0x61E`) | `func_02F3A2` | **periodic milestone/congress driver** → colony-stats `func_042138` (`@0x2F3B8`), founding-fathers/congress `func_03B2F8` (`@0x2F453`), king-defeat cinematic `func_075352` (`@0x2F552`) |
So the **production phase is byte-confirmed** = `func_02F052` (per-power colony loop
→ `func_02D658`). The remaining big system functions are reached via the **JMP-FAR
trampoline island** (`call near <trampoline>; retf`), and their call sites are now
located (2026-06-20):
- **Immigration crosses** `func_035D9A` ← `func_33C96 @0x363E2` — **immediately after
  the price-drift call** (`@0x363D3`), so the economic recompute does drift **and**
  immigration together (trampoline `0x36836`).
- **REF growth** `func_03E162` ← `func_03E888 @0x3E892` (conditional, in the King/
  mercenary cluster just past the `func_03E664` King phase) and `@0x3E46B`
  (trampoline `0x3EA15`).
- **King tax** `func_034AE0` ← `@0x34C05`, one branch of a **king-action dispatch**
  (`dec ax; je` ladder `@0x34C14` selecting `push cs; call <trampoline>; retf`
  wrappers `@0x34BF8`/`@0x34BFE`/`@0x34C05`; trampoline `0x368AE`).
- **AI action dispatch** `func_04E2D6` (the 25-case per-unit AI switch `@0x4EA7`) ←
  `@0x51DC1` (the page-0x51 AI-unit processor; trampoline `0x534F8`).
**Intra-turn phase order & cadence — BYTE_VERIFIED (2026-06-20).** Per power, the
five `func_005760` phases fire in order, with the system functions nested inside:
1. **King/mercenary offer** `func_03E664` (`@0x58E2`; gated `[0x5382]&1==0`).
2. **Orders/movement** `func_024A48` (`@0x58E7`) — **REF accrual rides here**:
   `func_03E162` is reached via `0x24B42 → func_0235D6 → 0x3EA16`, and **accrues
   every turn per power** (`(climate_diff<<3)+0xA`, ×2 at 1600/1700/1750, frozen at
   `≥1800`); **AI orders** `func_04E2D6` via `func_004EE6` (`@0x24731`).
3. **Production** `func_02F052` (`@0x59EA`, colony loop `@0x2F25F`) — **immigration
   rides here**: `func_0363A2 @0x2F218 →` drift `@0x363D3` then immigration
   `func_035D9A @0x363E2`.
4. **Diplomacy** `func_052F7E` (`@0x5A37`) — calls the **king-action dispatcher
   `func_034C24`** (`@0x5255D`/`@0x52CF4`), whose switch **case #4 → king-tax
   `func_034AE0`** (`@0x34C05`); **king-tax is therefore event/relationship-driven
   within diplomacy, not an every-N-turns gate** (REF, by contrast, is strictly
   per-turn). AI diplomacy `func_04E2D6` via `func_004EE6` (`@0x531BD`).
5. **Periodic/congress** `func_02F3A2` (`@0x5AE5`) — Founding-Father congress
   `func_03B2F8 @0x2F453` (gated `[0x5382]&0x10==0`), king-defeat cinematic `@0x2F552`.

So the full per-power order is **King→Orders(+REF,AI)→Production(+drift+immigration)
→Diplomacy(+king-tax,AI)→Periodic(+Congress)**, then the once-per-turn year/cadence
block (§ "Turn / year advance"). **B.**

### Turn / year advance — BYTE_VERIFIED (`0x5A9D..0x5ACC`), runs once/turn (gated `[0x53C2]`)
- `@0x5A9D` `inc [0x538e]` — **turn counter +1 every turn**.
- **Year cadence (`@0x5AA1` `cmp [0x538a],0x640`=1600):**
  - **year < 1600 → `inc [0x538a]` directly = 1 turn ⇒ 1 year** (fast early game,
    Autumn-only).
  - **year ≥ 1600 →** the **season counter `[0x538c]`** toggles `0→1→0` (`@0x5ABB`
    `inc`; `@0x5AC6` reset when >1) and the year steps only when it wraps ⇒ **2 turns
    per year** (Spring/Autumn) from 1600 on.
- **1600 announcement** at year==1600 & season==0 (`@0x5AB2`, event `0x181F:0x3FE`,
  `bx=[0x141]`).
- **Game start = 1492 (`0x5D4`)**, **forced game-end check at 1725 (`0x6BD`)**
  `@0x5BB5` (sets `[0x82b]=1`).
- **Periodic events** after the advance: `[0x538e] mod 4 == 0` (`@0x5B0F`); `mod 3`
  paths (`@0x5B1F` inc `[0x150]` cap `0x19`=25; `@0x5B54` REF/sea-lane edge spawn).

## 4. UI
End-of-turn redraw via render chain `func_O514 → O513 → O512`; HUD update; "next
unit needing orders" prompt loop (manual). Layout `TBD`.

## 5. Evidence
- `func_005760` (file `0x5760`) — main turn loop: per-turn top `@0x5836`, continue-gate `[0x53C2]` `@0x5BED`, power loop `[bp-0x14]` 0..3, inline end-of-turn/year-advance `0x5A9D`. **B**
- `func_075FB6` (file `0x75FB6`) — setup machine that calls the loop once (`@0x76330`); new-game year=1492/turn=0/season=0 init (`@0x757E7..0x757F2`). **B**
- per-power processors `func_03E664` (`0x3E664`), `func_024A48` (`0x024A48`); diplomacy `func_052F7E`; periodic `func_02F3A2`. **B** (call sites)
- `docs/ARCHITECTURE.md` — per-turn loop framing. **B/R** (power "4..11" framing superseded — natives not a separate pass)
- `docs/GAME_MANUAL.md` — per-unit orders prompt; end-of-turn flow. **R**

## 6. Open questions (TBD)
1. ~~Identify the top-level turn/phase dispatcher (~27 cases).~~ **Resolved
   2026-06-20** — there is **no single dispatcher**; the loop is `func_005760` with a
   straight-line set of per-power calls (§2/§3). The `func_33C96` 12-case switch and
   the `0x0D2AC`/`0x233D7`/`0x2C076` switches are keyboard/command routers, not turn
   sequencers.
2. ~~Confirm power order.~~ **Done** — strict European index order 0..3; natives not a
   separate pass (§1). **B.**
3. ~~Map each phase to its system function + intra-turn order.~~ **Done 2026-06-20**
   — full per-power order King→Orders(+REF/AI)→Production(+drift/immigration)→
   Diplomacy(+king-tax/AI)→Periodic(+Congress) byte-verified (§3). REF per-turn;
   king-tax event-driven within diplomacy. **B.**
4. ~~Turn-counter → in-game-year conversion.~~ **Done 2026-06-20** — start 1492
   (`0x5D4`); 1 turn/year before 1600, 2 turns/year (seasons) from 1600; forced end
   1725 (`0x6BD`). **B** (§3).
