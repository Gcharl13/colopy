# Computer-Player AI — per-unit order/move engine

> **Layer 4 — Simulation/AI.** Canonical AI spec (this file is the one canonical AI doc; the
> durable function index is `notes/ATTRIBUTION_OVERLAY.md`, decisions in `notes/rulings/RULINGS.md`).
> Tiers: B (`BYTE_VERIFIED` at a cited `func_XXXX @0xNNNN`) / A (anchor) / R (reconstructed) / TBD.
> **Scope:** the AI that drives every non-player unit each turn. Decoded 2026-06-26 via the
> decode→verify workflow (80 byte-verified findings, adversarially re-checked against
> `raw/COLONIZE/VICEROY.EXE` with capstone). The bodies live in the orphan **overlay** pages
> (`code/VICEROY/disasm_overlay_reseg/page_0C/0D/0F/13.asm`); they are reached through a runtime
> far-jump dispatch table, which is why a static `lcall` xref never found them (see
> `ATTRIBUTION_OVERLAY.md`).

## 1. The two AI movement engines

| Engine | Function | Role |
|--------|----------|------|
| **Order/mission processor** | `func_04E2D6` @file `0x04E2D6` (~15 KB, `ENTER 0xEE`) — overlay page 0x0D | Per-unit turn driver: gate → validate → score mission/target → write order/state/goto/heading/budget. The 30-letter state machine lives here. |
| **Tactical heading evaluator** | `func_046FFA` @file `0x046FFA` (4835 B, `ENTER 0xA2`) — overlay page 0x0C | Scores the 8 compass directions (+ "stay") for one unit and writes the winning compass dir to `0x314F`. The rich terrain/enemy/colony score formula is here. |
| Heading propagator | `func_059B90` @file `0x059B90` — overlay page 0x0F | Copies/min-merges a heading onto a **neighbour** unit (escort/column behaviour); uses the same `0xb4`/`0xbe` compass tables. Not a per-unit mover. |

Both take `[bp+6]` = unit index; all fields are `bx = idx·0x1C` then `[bx+0xNNNN]` (UnitRecord
absolute offsets per `spec/systems/unit.md`).

## 2. `func_04E2D6` — per-unit order/mission pipeline (B)

Decision pipeline (each step byte-cited; runtime-table inputs marked TBD):

1. **Entry gate** `@0x04E2FE` — read owner nibble `0x3147&0xf`; continue **only if** order
   `0x314C` ∈ {0, 5, 6} or ≥ 0x0A, else `jmp` common exit `0x051C68`. *(There is **no** jump
   table — dispatch is a `cmp`-ladder branching on unit_type `0x3146`, order `0x314C`, and the
   state-char `0x314B`.)*
2. **Validity gate** `@0x04E347` — `lcall 0x181F:0x302(x,y)` ("is this tile passable for this
   unit"); returns 0 ⇒ write state `0x314B='@'` (0x40) and exit. Re-used `@0x051C43` to re-validate
   a stepped goto coord before committing.
3. **Context build** `@0x04E387`–`@0x04E3FF` — reachability/colony scoring context:
   `0x181F:0x952(owner,y,x)→[bp-0x18]`; `0x181F:0x614(flagA,flagB,y,x)` (signed reachability, **<0 =
   unreachable**) called twice → `[bp-0xe2]`, `[bp-0x60]`; if `[bp-0x60]≥0` then
   `0x181F:0x722(colonyY,colonyX)` (colony at `*(0x8542)`, hard-rule 8) → colony-attraction term.
4. **Active-move flag** `[bp-0x68]` `@0x04E55E` — a `cmp`-cascade on unit_type `0x3146`, class
   `0x315B` (0x1B/0x15 clear it), order `0x314C`, and map-cell bytes (`-0x6b1a`/`-0x6a8e`/`-0x6a0e`)
   decides whether the unit actively seeks a move this turn. Order `0x314C==0xB` calls
   `0x181F:0x37A` (path/visibility cost) and sets the flag if the target is far enough (`>0x0C`).
5. **8-direction scorer** `@0x051846`–`@0x051A0B` — inline candidate loop over compass dirs using
   signed delta tables `[bx+0xb4]` (dx) / `[bx+0xbe]` (dy); score accumulates in `[bp-0x26]`, best
   in `[bp-0xe0]` (per-handler seed e.g. `0xFC19`/`0x270F`), winner dir latched to `[bp-0x74]`.
   Score terms: `+2` ship-passable (`0x181F:0x768`), `−2` (`0x181F:0x682`),
   `+ table[0x2F79+16·ret]` (`0x181F:0x78C`), enemy/occupancy penalty
   `−(cargo 0x3150)·k` (`0x181F:0x7E0` enumerating units via `0x181F:0x2E4`), terrain-feature
   `+0x14/0x28` (`0x181F:0x322`).
6. **Budget check** `@0x051A48` — `remaining = 0x181F:0x90C(unit) − [0x3149]`; if `< 3` force
   `[bp-0x74]=8` (stay) and state `0x314B='9'` (0x39). *(Budget = move-credits spent, §5.)*
7. **Write heading** `@0x051A95` — `0x314F = [bp-0x74]` (compass 0..7, **8 = no-move**).
8. **Sentry toggle** `@0x051AB0` — if dir==8: if order not already 5/6, set `0x314C=5`; then test
   transient bit `0x3148 & 2` `@0x051AB9` — clear ⇒ exit; set ⇒ `0x314C=6`. This is the
   fortify/sentry 5↔6 toggle keyed on bit `0x3148.2`.
9. **Commit move** — *(else branch)* step `x/y` by the winning delta, re-validate `0x181F:0x302`,
   set order `0x314C=0x0C` (goto-active) and write goto-target `0x314D/0x314E` `@0x051C53` (the
   **only** writers of those fields). On the execute-now path, reset budget `0x3149=0` and call the
   step-mover `0x1A1F:0x150(dir,unit)` `@0x04FD92`.
10. **Tail normalize** `@0x051C68` — if order is 0x0A or 0: re-arm sentry (`0x314B='0'`,
    `0x314C=5`); if order 5: re-scan the 8 neighbours (`0x181F:0xA38`, `test al,0x40` = adjacent
    threat ⇒ wake, `0x314C=0`); if goto arrived and unit is a ship in state `'1'`, promote to `'B'`.
    Then `0x181F:0x934` (post-turn refresh) and return.

## 3. `func_046FFA` — tactical heading score formula (B)

The candidate loop counter `[bp-0x34]` runs **0..8** (`@0x047371`/`@0x04738D`; **9 candidates** = 8
compass dirs + 8 = stay). Per candidate (dest tile from compass tables `[bx+0xbe]` dy / `[bx+0xb4]`
dx `@0x047399`):

| Term | Value | Site | Condition |
|------|-------|------|-----------|
| **Base** | **+200** (0xC8) | `@0x0473A4` | every candidate seeds `[bp-0x24]=200` |
| Water/Arctic reject | drop candidate | `@0x0473BB` | tile id (`0x181F:0x78C`) == 0x19 Ocean / 0x1A Sea-Lane / 0x18 Arctic |
| Heading continuity | **+4** | `@0x047A79` | candidate dir == current heading `0x314F` |
| Turn cost | `−` (helper) | `@0x047A8D` | `0x181F:0x384(curHeading,candDir)` nonzero (reverse ≈ −6) |
| Enemy on tile | reject | `@0x047A1D` | unit occupies dest (`0x181F:0x7E0`) and terrain flag `<0` |
| Colony proximity (stay) | **+40** (0x28·bool) | `@0x047A33` | `0x181F:0x8BC(2,unit)` |
| Settlement bonus | **+20** (0x14) | `@0x0479C0` | unit-type test |
| Target distance | **×3** | `@0x047AEC` | goto record `[bp-0x78]≥0`: `0x181F:0x370(dx,dy)` dist >2 ⇒ score = 3·dist |
| Frontier/reveal | reject if 0 | `@0x047B46` | `0x181F:0x984(power,y,x)`==0 drops the candidate |
| Early-era terrain | **+50** (0x32) | `@0x047B76` | era `[0x8cfa]<4` and `!(0x181F:0xA38(era,power) & 0x20)` |
| Resource/yield | **+16** (0x10) | `@0x047C52` | `0x181F:0x30C(power yield) ≥ 0x5F` (branch on dir bit-0) |
| Colony-site | **+500** (0x1F4) | `@0x047D84` | `0x181F:0x7BE(x,y)≥0` and `0x181F:0x9E6` confirm a valid new-colony spot |
| RNG jitter | **+rand(1,5)** | `@0x047F44` | `0x181F:0x4D4(1,5)` — **runtime RNG (R)** |
| Clamp | `max(score,0)` | `@0x047F4A` | floor at 0 |

**Selection** `@0x047F6E`: keep the strictly-max candidate (best init `0xFFFF` `@0x04736B`); after
the loop, write `0x314F = best dir` `@0x047FA0` (8 ⇒ no move). The **+500 colony-site** term is what
makes AI settlers walk toward good colony spots; **base 200** keeps scores positive so the RNG
jitter and small terrain terms break ties.

## 4. The AI per-unit state-char alphabet — `UnitRecord+0x314B` (B)

`0x314B` is the **persistent per-unit AI mode**: the previous turn writes a letter, the next turn's
dispatch reads it to decide which mission/handler resumes. Full decoded alphabet (assign site →
meaning):

| Char | Hex | Assigned | Meaning |
|------|-----|----------|---------|
| `X` | 0x58 | `@0x06D84` (spawn/init) | freshly-created / cleared, state un-set |
| `-` | 0x2D | `@0x40061` (record free) | dead/placeholder slot (type 0x17, target 0xFF) |
| `0` | 0x30 | `@0x051C7E` (tail) | idle/sentry default — no AI mission this turn (order→5) |
| `1` | 0x31 | `@0x04E15D` | AI **target tile selected** (provisional goal; order→0xB) |
| `t` | 0x74 | `@0x04E175` | goal **class 1** (plan-map `[…-0x674e]`==1 refinement of `1`) |
| `i` | 0x69 | `@0x04E194` | goal **class 7** refinement of `1` |
| `?` | 0x3F | `@0x04E202`/`@0x04E239` | goal **lost/unreachable** — needs re-planning |
| `@` | 0x40 | `@0x04E353` | failed validity gate — **dropped** this turn |
| `9` | 0x39 | `@0x051A5E` | **out of move budget** (`0x3149` exhausted) — stay |
| `A` | 0x41 | `@0x04D9D5`(×5) | committed to a **colony task / work quota** (excluded from free pool) |
| `G` | 0x47 | `@0x04CEA7`/`@0x051A84` | **garrisoned** in a colony (promotion of `A`) |
| `E` | 0x45 | `@0x041B6D` | en-route, **explicit goto** issued (page-08 dispatcher) |
| `R` | 0x52 | `@0x050EBE` | **routed** under a goto order (order→9) |
| `V` | 0x56 | `@0x04E9F0` | **arrived at** a colony (coords coincide) |
| `L` | 0x4C | `@0x04EA53`/`@0x04EAF8` | **routing into** a colony (path step via `0x1A1F:0x59C`) |
| `=` | 0x3D | `@0x04F20E` | **absorbed** into colony population (type mutated to 2) |
| `U` | 0x55 | `@0x0508D7` | sitting **on its stored target** (`0x314A`) |
| `C` | 0x43 | `@0x04F3B8` | **work/build complete** (counter `0x315A` ≥ 10 − cost) |
| `B` | 0x42 | `@0x051B26`/`@0x051D37` | **start terrain build** (cap bit-0) / ship reached goto (`1`→`B`) |
| `e` | 0x65 | `@0x051B7A` | start terrain build (cap bit-2 sibling of `B`) |
| `F` | 0x46 | `@0x051C1C` | found an **adjacent region-match** tile — step there |
| `2 3 4 5 8 D J N P W` | — | via `func_04E2B6` | **mission-dispatch tags** (each `mov dl,imm` before the goto-helper sets state=char, order=0xB; char identifies which AI mission dispatched the unit) |

**Mission-dispatch helper `func_04E2B6` @0x04E2B6 (B):** sets `0x314B = caller's DL`, order
`0x314C = 0x0B` (AI-goto), goto `0x314D=BL`, `0x314E=[bp+4]`. So the state letter tags the dispatching
mission; the next pass re-tests it (e.g. `'2'` re-checked `@0x04E66B` for scout-class type-5 units,
`'8'` `@0x050C9D`).

## 5. `UnitRecord+0x3149` — AI move budget (RESOLVED — was AI-GATED)

**`0x3149` = move-credits SPENT this turn** (a points-per-action accumulator) — decisively **not**
an enable flag and **not** evaluation-passes-used (B, `func_0079A0 @0x007A08`).

- **Allowance** = per-unit-type byte from data table **`0x5234`** (stride 14, indexed by unit_type
  `0x3146`; helper `@0x006CEE`), **+3** for ships (type 0x0D..0x12) when a per-power trait passes
  (`lcall 0x981:0` `@0x006D01`). *(Table contents are runtime data — exact per-type allowances TBD.)*
- **Reset to 0**: at turn start for **every** unit (`@0x005872`, loop over `[0x539C]` units after
  `0x181F:0x550`); on spawn (`@0x006D7F`, `@0x02D583`); and on re-tasking inside the processor
  (`@0x04FD92`).
- **Charge**: a standard step costs **+3** (`@0x05CAE2`); heading-AI moves cost **+0x32 (50)** or
  **+2** (`func_059B90 @0x059F20/@0x059F3C`, the expensive vs cheap move classes).
- **Gate**: a unit may act while `allowance − [0x3149] ≥ 3` (`@0x03EE95`, `@0x0480E9`,
  `func_059B90 @0x059E69`); it is "out of moves" once `[0x3149] ≥ allowance` (`@0x007A08`). The
  `cmp [0x3149],0` gates (`func_051D56 @0x051D5D`, page-13 `@0x062F5C`) select units that have
  **already acted** this turn (spent ≠ 0), not an enable bit.

## 6. Cross-references / fields this names

- `spec/systems/unit.md`: `0x3149` (now named here), `0x314B` (full alphabet here), `0x314F`
  (heading written by `func_046FFA`/`func_04E2D6`), `0x314D/0x314E` goto-target (written only by
  `func_04E2D6 @0x051C53`), `0x315A` work-counter (ship blockade/build counter, `'C'` at ≥10−cost).
- `spec/systems/turn_dispatch.md`: `func_04E2D6` is the "AI orders" phase invoked per power.
- `notes/ATTRIBUTION_OVERLAY.md`: function offsets + overlay pages.

## 7. Open questions (TBD — each with its site)

1. **Compass delta tables** `[bx+0xb4]` (dx) / `[bx+0xbe]` (dy), 9 entries — DS/BSS-relative,
   contents runtime-set; exact deltas not in the instruction stream. Site: `func_046FFA @0x047399`,
   `func_04E2D6 @0x051846`.
2. **Per-type stat tables** `0x5234` (move allowance), `0x5236` (sea/land passability), `0x5237`
   (work cost), `0x523D` (terrain-feature capability bits), `0x5236+type·6` — static-ish data loaded
   at runtime; values TBD (drive `B`/`e`/`C` states and the budget allowance).
3. **Resident scoring/path helpers** behind window seg `0x181F`/`0x1A1F` thunks — `0x302`
   (validity), `0x322`/`0x6dc`/`0x682`/`0x6be`/`0x754`/`0x78c` (terrain/zone), `0x614`/`0x37a`/`0x370`
   (reachability/distance), `0x952`/`0x722`/`0x8bc`/`0x984`/`0x7be`/`0x9e6` (colony/site), `0x4d4`
   (RNG). Bodies live in resident segments not in these pages; identities are A/TBD.
4. **Plan-map goal-type codes** `1`→`'t'`, `7`→`'i'` (the `[…·4−0x674e]` per-(unit,tile) table) and
   the human-readable **mission name** for each dispatch char (`2 3 4 5 8 D J N P W`) — these are
   written by the earlier strategic AI pass that fills the plan map; that producer is the next L4
   target. Site: `func_04E2D6 @0x04E16E` (read), plan map `[…−0x674e]` (BSS).
5. **RNG jitter** `0x181F:0x4D4(1,5)` per-candidate score noise — runtime, non-static (R).
