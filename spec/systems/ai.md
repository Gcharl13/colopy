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
| **Strategic planner** | `func_04CC50` @file `0x04CC50` (`0x04CC50..0x04E2D5`, `ENTER 0x1E4`) — overlay page 0x0D | Per-**power** pass (`[bp+6]`=power): reads the plan map (§6) and assigns each unit a mission, writing the planning states `1`/`t`/`i`/`?` + order `0x0B` + goto coords. |
| **Order/mission processor** | `func_04E2D6` @file `0x04E2D6` (~15 KB, `ENTER 0xEE`) — overlay page 0x0D | Per-**unit** turn driver (`[bp+6]`=unit): gate → validate → score → write order/state/goto/heading/budget; writes the execution states. |
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

### 3a. AI scoring helpers — resolved to resident functions (B, 2026-06-27)

The `0x181F:xxxx` scoring helpers the AI calls are **Type-B resident** functions in the load image
(resolved via `tools/follow_thunk.py` — each thunk's `LJMP` lands at `file = 0x2400 + S·16 + O`,
all `< 0x20665`, so they disassemble directly). Two cross-validate against prior anchors, confirming
the whole map:

| Thunk | Resident fn | Role | Notes |
|-------|-------------|------|-------|
| `0x181F:0x302` | `func_005BFA` | **tile in-bounds / valid** | returns 1 iff `1 ≤ x < [0x853a]−1` ∧ `1 ≤ y < [0x853c]−1` → `[0x853a]`=**map width**, `[0x853c]`=**map height** |
| `0x181F:0x37A` | `func_00493C` | **tile distance** | `abs(dx)`,`abs(dy)` (two's-comp `not;inc`) |
| `0x181F:0x614` | `func_0083F2` | reachability/terrain (ENTER 0xC) | signed; `<0` = unreachable |
| `0x181F:0x4D4` | `func_00C322` | **random_int(lo,hi)** | the documented LCG `lo+((rand·range)>>15)` (✓ = the Track-12 colony-placement RNG) |
| `0x181F:0x90C` | `func_006CCA` | **move allowance** | reads UnitTypeStats `0x5234` (✓ = §5a; `+3` ships) |
| `0x181F:0x9E6` | `func_0082DC` | **select colony** → sets `[0x8542]` | |
| `0x181F:0xA4C` | `func_0081F2` | **select native settlement** → sets `[0x8d4a]` | |
| `0x181F:0x7BE` | `func_008D26` | **colony-site validity** | feeds the `+500` site term (§3) |
| `0x181F:0x78C` | `func_00627A` | **tile terrain id** | the `get_terrain_id` family (near `func_006204`) |
| `0x181F:0x7E0` | `func_0066CC` | **units-on-tile** enumerator | |
| `0x181F:0x322` | `func_00860E` | **terrain-feature** query | feeds `+0x14/0x28` feature bonus |

So the AI's evaluation primitives are **named, load-image-resident, and decodable** — no longer
"behind opaque overlay thunks." `[0x853a]`/`[0x853c]` (map W/H) are a useful by-product.

**Internals — the scorers bottom out at the shared map/colony data layer (B, 2026-06-27).** Decoding
the bodies shows they call the engine's **map-access segment `0x37f`** — `0x37f:0xA` (tile in-bounds),
`0x37f:0x10E` (raw map byte), `0x37f:0x314` (unit-index at tile), `0x37f:0x358` (tile terrain/owner) —
i.e. the *same* primitives the rest of the engine uses, not an AI-private map:
- `func_00627A` (tile-id) → `0x37f:0x10E` raw byte → `func_00624E` = the `get_terrain_id_from_raw`
  chain (CLAUDE.md hard-rule 3); returns terrain 0..26, default **Ocean** off-map.
- `func_0066CC` (units-on-tile) → `0x37f:0x314`; returns the occupying unit index or `0xFFFF`.
- `func_008D26` (colony-at-tile) iterates `ColonyRecord[0x5d46]` stride `0xCA` (count `[0x539e]`),
  matching record `+0x00`=x / `+0x01`=y; returns colony index or `0xFFFF`. *(Re-confirms the
  already-documented colony layout, `spec/systems/colony.md` — base `0x5D46`, stride `0xCA`; oracle:
  active colony `[0x8542]=0x606e = 0x5d46 + 4·0xCA`.)*

So the AI scoring stack terminates in the **already-specified** map (`formats/MP_FORMAT.md`,
`map_system.md`) and colony (`colony.md`) data layers — there is no further AI-only black box beneath
the helper map above.

### 3b. Colony-site VALUE — "Show Colony Sites" (CHEAT F9) — LIVE-CAPTURED (2026-06-27)

The cheat menu's **F9 "Show Colony Sites"** (`MENU @CUP`) overlays a per-tile **colony-site value**
on the map. Static decode did NOT pin the handler/formula (two deep passes mis-resolved to Reveal-Map
`func_06892E` and a generic message drawer `func_038418`; the value routine is overlay-resident with no
clean dispatch anchor — TBD). So it was **captured from the running game** (the oracle).

**Live-capture method (reproducible):** launch VICEROY under DOSBox (`scratchpad/dbx/db.conf`,
`autolock=false`); load a save to reach the map (e.g. `COLONY00.SAV`); type the cheat code **Alt+W+I+N**
(the `CHEAT` title then appears in the menu bar); CHEAT → **Reveal Map → Complete Map**; CHEAT →
**F9 Show Colony Sites**. Reference capture: `docs/screens/colony_sites_live.png` (England, AMER2/Original
Americas, Spring 1490).

**Confirmed facts (B, oracle):**
- The value is printed on **every** tile (white digits in a black box). **Ocean/sea-lane tiles = 0**
  (cannot found a colony there).
- **Coastal land tiles carry the score** — observed values on one coast stretch: **9, 11, 12, 13, 13**
  (the `13` spots are the best sites; one sat on a special-resource tile). Range seen so far ≈ 0–24.
- The per-tile value is **computed at draw time, NOT stored as a map array**: an FFT/ocean-zero search
  of a 16 MB live RAM snapshot (`tools/runtime_snapshot.py`) found **no** 58×72 array whose zero-pattern
  matches the ocean mask with colony-site-range land values — only false hits (row-0-only arrays). So
  reversing the exact formula requires reading the displayed values across the map and correlating each
  `(x,y)` with its AMER2 terrain/features/neighbours.

**Still TBD:** the exact arithmetic (which yields/bonuses/adjacency sum to the printed number) and the
handler function offset. Next step = systematic screenshot value-read + terrain correlation (the inputs
are all known: AMER2 terrain `data_extracted/map/AMER2_tiles.json`, yields, coastal/resource bonuses).

## 4. The AI per-unit state-char alphabet — `UnitRecord+0x314B` (B)

`0x314B` is the **persistent per-unit AI mode**: the previous turn writes a letter, the next turn's
dispatch reads it to decide which mission/handler resumes. The alphabet splits by writer (both in
overlay page 0x0D): the **planning** states `1`/`t`/`i`/`?` are written by the strategic pass
`func_04CC50` (`0x04CC50..0x04E2D5`, sites `0x04E15D`/`0x04E175`/`0x04E194`/`0x04E202` — all *before*
`func_04E2D6`'s entry, see §6.1); the **execution** states (`@`,`V`,`L`,`=`,`C`,`U`,`R`,`9`,`G`,`B`,
`e`,`F`,`0`, mission chars) are written by the per-unit consumer `func_04E2D6` (`≥0x04E2D6`). Full
decoded alphabet (assign site → meaning):

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

- **Allowance** = the `+0x00` field of the **UnitTypeStats** record (`DS:0x5234`, 14-byte stride,
  indexed by unit_type `0x3146`; helper `@0x006CEE` computes `bx = type·14` via `cx=t;shl;add;shl;
  add;shl`), **+3** for ships (type 0x0D..0x12) when a per-power trait passes (`lcall 0x981:0`
  `@0x006D01`). The stored allowance = **`@UNIT` moves × 3** (Colonist 1→3, Scout/ship 4→12,
  Frigate 6→18, Privateer 8→24) — so **one move = 3 budget**, which is exactly the +3 step charge.
  See the UnitTypeStats layout in §5a.
- **Reset to 0**: at turn start for **every** unit (`@0x005872`, loop over `[0x539C]` units after
  `0x181F:0x550`); on spawn (`@0x006D7F`, `@0x02D583`); and on re-tasking inside the processor
  (`@0x04FD92`).
- **Charge**: a standard step costs **+3** (`@0x05CAE2`); heading-AI moves cost **+0x32 (50)** or
  **+2** (`func_059B90 @0x059F20/@0x059F3C`, the expensive vs cheap move classes).
- **Gate**: a unit may act while `allowance − [0x3149] ≥ 3` (`@0x03EE95`, `@0x0480E9`,
  `func_059B90 @0x059E69`); it is "out of moves" once `[0x3149] ≥ allowance` (`@0x007A08`). The
  `cmp [0x3149],0` gates (`func_051D56 @0x051D5D`, page-13 `@0x062F5C`) select units that have
  **already acted** this turn (spent ≠ 0), not an enable bit.

### 5a. UnitTypeStats — `DS:0x5234`, 14-byte record per unit type (B, RESOLVED 2026-06-27)

The per-type combat/move table the AI reads is a **14-byte record at `DS:0x5234`**, one per `@UNIT`
row (24 types). It is the **loaded `@UNIT` CSV** (`data_extracted/text/NAMES_sections.json @UNIT` —
primary game data, HIGH trust) with the move field scaled ×3. Stride proven ×14 at the resident
sites `@0x006CEE`/`@0x0074A9`/`@0x006826` (`cx=t; shl;add;shl;add;shl` = `t·14`). Field map
(byte-confirmed fields + the `@UNIT` column each loads from):

| Field | `@UNIT` col | Meaning | Read by |
|-------|------------|---------|---------|
| `+0x00` (`0x5234`) | moves×3 | **move allowance** (budget; 1 move = 3) | allowance helper `@0x006CEE`; §5 |
| `+0x01` (`0x5235`) | def | **defense** | combat |
| `+0x02` (`0x5236`) | atk | **attack** / sea-passability test (`cmp ==1`) | `@0x0074A9`, AI `'V'` gate |
| `+0x03` (`0x5237`) | (col5) | **work/build cost** (`'C'` done at counter ≥ 10−cost) | `@0x006826`, AI `@0x04F389` |
| `+0x04`..`+0x08` | (cols 6–10) | ship/cargo block (`99` sentinel for ships in col6 `+0x04`; cargo/bombard in `+0x05..+0x08`) | ship handlers (exact split TBD) |
| `+0x09` (`0x523d`) | capbits (binary) | **terrain-feature capability bitfield** (`@UNIT` last column verbatim: Colonist `0x40`, Soldier `0x1c`, Caravel `0xA2`) | AI build states `B`/`e` (`test &0x40/&0x20/&1/&4`), `@0x04E01D`/`@0x051196` |

So a port can drive the AI's combat/move/build decisions straight from the `@UNIT` table (×3 the move
column); no separate decode of the stat values is needed. *(The middle ship/cargo fields `+0x04..+0x08`
map to `@UNIT` cols 6–10 but their exact game labels — cargo slots vs bombard — are not individually
pinned; the bytes are the `@UNIT` data verbatim.)*

## 6. The strategic plan-map + per-turn invocation (B, L4 Phase 2)

### 6.1 Plan-record table (B, with one flagged ambiguity)

A family of small **far accessor** functions (`0x04C1F0`..`0x04C3FD`) maintains a fixed BSS table of
4-byte plan records at **`DS:0x98B0`** (addressed `[bx−0x6750]`…`[bx−0x674d]`, byte-address
`= ((idx<<6)+slot)<<2`, **slot 0..0x3F = 64 entries per idx**):

| Field | Offset | Meaning |
|-------|--------|---------|
| `field0` | `−0x6750` (`DS:0x98B0`) | candidate-target **X** (copied to UnitRecord `0x314D` on goto commit) |
| `v1` | `−0x674f` | candidate-target **Y** (→ `0x314E`) |
| `goal_type` | `−0x674e` | **mission-type selector**; `0xFF` = empty slot. `==1`→unit state `'1'→'t'`; `==7`→`'t'→'i'`; `==4` special (skip). |
| `v3` | `−0x674d` | **priority/weight** — the setter inserts into a priority-ordered slot |

Accessors (all far, page 0x0D): **clearer** `func_04C1F0` (reset one slot to `goal_type=0xFF,v3=0`);
**setter** `func_04C3A2` (naked, reuses caller frame; scans 64 slots for the first free
`goal_type==0xFF` whose `v3` ranks the new entry, calls priority-insert thunk `0x534F3→0x1A1F:0x4E8`,
then writes the 4 fields from caller-frame slots `[bp+8/0xA/0xC/0xE]`); **query** `func_04C306`
(returns max `v3` among slots matching `field0/v1/goal_type`).

> **Outer index = POWER (RESOLVED 2026-06-27).** The plan map is indexed by **power (0..3), 64 slots
> each** — `idx = power` in `((power<<6)+slot)<<2`. Two independent proofs:
> 1. **All** plan reads/writes (`@0x04DFF4`, `@0x04E05C`, `@0x04E07E`, `@0x04E16E`, `@0x04E199`) sit
>    **inside `func_04CC50`** (one large function `0x04CC50..0x04E2D5` — verified no intervening
>    prologue-after-`retf`), where `[bp+6]` is the function's **power** argument (the per-power turn
>    loop §6.3 calls it once per power). The earlier "`func_04E2D6` reads it by unit index" was a
>    **function-boundary mis-attribution** — those sites are the *tail of `func_04CC50`*, before
>    `func_04E2D6`'s entry at `0x04E2D6`. The consumer `func_04E2D6` does **not** re-read the plan map
>    by unit index; it acts on the `0x314B`/`0x314C`/`0x314D/E` that `func_04CC50` already wrote.
> 2. **BSS layout:** a power-indexed table spans `0x98B0..0x9CB0` (`4·64·4 = 0x400` bytes) and the
>    next live global cluster begins **exactly at `0x9CB0`**. A *unit*-indexed table (`300·64·4 =
>    0x12C00`) is impossible — it overflows the 64 KB segment and the live globals from `0x9A00` up.

### 6.2 Mission-dispatch chars → missions (B)

All mission dispatches route through `func_04E2B6` (sets `0x314B=dl`, order `0x314C=0x0B`,
goto `0x314D=bl`/`0x314E=[bp+4]`) via the shared tail `@0x04E9DB` (`jmp 0x2f95`). Each `mov dl,imm`
site's branch names the mission:

| Char | Site | Mission |
|------|------|---------|
| `2` | `@0x04F030` | **Scout explore** — type-5 unit to a runtime-scored frontier tile (best of a desirability loop). Re-entry `@0x04E664` (type 5 + state `'2'`). |
| `3` | `@0x04F1FD` | **move-to-colony** — scores own colonies (count `[0x539e]`) by distance + size `[+0x1f]`, best → `[0x8542]`. |
| `4` | `@0x0508AB` | **go-to-native-village** — scores native settlements (count `[0x539a]`, stride 0x12) → `[0x8d4a]`. |
| `5` | `@0x050768` | **move-to-current-colony** (`[0x8542]`). |
| `8` | `@0x050D58` | **explore-wander** — multi-step random walk; step counter `0x3156` = `rand(1,0x14)`, displacement table `[bx+0xc8]/[bx+0xde]`. Re-entry `@0x050C9D`. |
| `D` | `@0x05107C` | **long-range explore** (variant of `8`; distance `0x181F:0x37A ≥ 8`, sets unit bit `0x3148.10`). |
| `J` | `@0x050BD8` | **go-to-native-village, capital-preferring** (scores `NativeSettlement+0x03 & 0x04` = Capital, distance + capital bonus). |
| `N` | `@0x050C3B` | **Scout/Pioneer → colony** (type 5 or 2). |
| `P` | `@0x0504D2` | **move-to-best-colony** ranked by colony field `+0xAA`. |
| `V` | `@0x04E9E2` | **fallback move-to-colony** for non-Pioneer land units with a colony but no active goal. |
| `W` | `@0x050E18` | **move-to-colony with a pending need** (colony flag `[0x8542]+0x1b & 0x04`; clears it + decrements `+0x1e` on arrival). |

So the AI's unit missions are: **explore** (`2`/`8`/`D`), **return-to-colony** (`3`/`5`/`N`/`P`/`V`/`W`),
and **visit-natives** (`4`/`J`) — selection driven by the plan-map `goal_type` upstream (§6.1) and the
per-target scoring loops.

### 6.3 Per-turn AI invocation (B)

- **Main turn loop** `func_005760` (body `@0x5836`): resets `0x3149=0` for every unit (`@0x5872`,
  bound `[0x539c]`), then a **per-power loop** index `[bp-0x14]` = 0..3 (`@0x5907`), setting active
  power `[0x5394]` (`@0x5920`).
- **Controller gate** (skips the human): `imul bx,[bp-0x14],0x34; cmp byte[bx+0x543f],0; jne skip`
  (`@0x58A6`) — `[idx·0x34+0x543f]` is the controller byte (0 = this power runs King+Orders; the AI
  sub-handlers re-test it `@0x4C9D3`/`@0x5148A`). (`AIPersonality[idx]` is the parallel `idx·0x34+0x540E`.)
- **Orders/movement phase** `func_024A48` (`lcall 0x181F:0x62C @0x58E7`): branches on mode word
  `[0x5390]` — `==0` interactive (BIOS-tick poll, viewport scroll), `≠0` AI/fast path (skips the wait).
- **Strategic pass** `func_04CC50` (`@0x4CC50`, `ENTER 0x1E4`): reads the plan map and assigns goals —
  iterates units (`[bp-0x152]` < `[0x539c]`, filtered to this power via `0x3147&0xf`), matches them to
  plan slots, writes the mission char to `0x314B` + order `0x314C=0x0B` + goto coords (`@0x04E199`).
- **Per-unit driver** `func_051D56` (`@0x51D56`): gate `cmp [unit+0x3149],0`/`je` (already-acted) and
  `cmp [unit+0x314c],0x0B`/`jne` (only AI-goto units); calls the action dispatcher `func_04E2D6` via
  the far-jump **island** at `0x534F8` (`ljmp 0x1A1F:0x4F4`). A secondary order-7..12 jump table
  `jmp word cs:[bx+0x5c2a]` `@0x51E15` post-processes the result (entries CS-relative — **TBD**).
- **Unit enumeration** is a flat index loop `i < [0x539c]` (the global unit count) filtered by owner,
  **not** the per-tile occupancy links `0x315C/0x315E`.

Control flow per power: **controller-gate → strategic plan fill (`func_04CC50`) → per-unit dispatch
(`func_051D56` → `func_04E2D6`) → execute/step.**

## 7. Cross-references / fields this names

- `spec/systems/unit.md`: `0x3149` (now named here), `0x314B` (full alphabet here), `0x314F`
  (heading written by `func_046FFA`/`func_04E2D6`), `0x314D/0x314E` goto-target (written only by
  `func_04E2D6 @0x051C53`, copied from plan `field0/v1` §6.1), `0x315A` work-counter.
- `spec/systems/turn_dispatch.md`: `func_04E2D6` is the "AI orders" phase; §6.3 here gives the
  full per-power invocation (`func_005760`→`func_024A48`→`func_04CC50`→`func_051D56`→`func_04E2D6`).
- `spec/systems/national_powers.md`: controller byte `[idx·0x34+0x543f]`, `AIPersonality`
  `[idx·0x34+0x540E]`.
- `notes/ATTRIBUTION_OVERLAY.md`: function offsets + overlay pages.

## 8. Open questions (TBD — each with its site)

1. **Compass delta tables** `[bx+0xb4]` (dx) / `[bx+0xbe]` (dy), 9 entries — DS/BSS-relative,
   contents runtime-set; exact deltas not in the instruction stream. Site: `func_046FFA @0x047399`,
   `func_04E2D6 @0x051846`.
2. ✅ **Per-type stat tables — RESOLVED 2026-06-27 (§5a).** `0x5234`/`0x5236`/`0x5237`/`0x523d` are
   **fields of one 14-byte UnitTypeStats record** (`DS:0x5234`, stride ×14 proven at `@0x006CEE`,
   not ×6) = the loaded **`@UNIT` CSV** with moves×3. Values are the `@UNIT` primary data (no longer
   TBD); the middle ship/combat fields `+0x04..+0x08` are now reader-pinned (RESOLVED 2026-06-27,
   §5a): `+0x04`(`0x5238`)=`99` naval sentinel (`@0x03FCC9`), `+0x07`/`+0x08`(`0x523b`/`0x523c`)=the
   two combat-roll strength terms summed into `rand(1,sum)` (`@0x05B844`), `+0x05`/`+0x06`
   (`0x5239`/`0x523a`)=ship cargo/size math (`idiv` divisor `@0x051536`, ×32 extent `@0x00B6B1`).
3. ✅ **Resident scoring/path helpers — RESOLVED 2026-06-27 (§3a).** The `0x181F:xxxx` helpers are
   named load-image-resident functions; their bodies bottom out at the engine's shared **map-access
   layer `0x37f`** (tile-valid / raw-byte / unit-at-tile / terrain) and the already-specified
   map (`MP_FORMAT.md`) + colony (`colony.md`, stride `0xCA`@`0x5d46`) data. No AI-only black box
   remains beneath the helper map. The only soft spot is the exact arithmetic *weighting* inside
   `func_0083F2` (reachability) — a small resident function, fully decodable but not yet line-traced.
4. ✅ **Plan-map outer-index — RESOLVED 2026-06-27 (§6.1): POWER-indexed (4×64).** All plan
   reads/writes are in `func_04CC50` (`[bp+6]`=power); BSS layout proves it (table `0x98B0..0x9CB0`,
   next global cluster at `0x9CB0`; unit-indexed would overflow the 64 KB segment). The prior
   "unit-indexed" reading was a function-boundary mis-attribution.
5. **Full plan-map goal_type enumeration** — only `1`/`4`/`7` byte-confirmed as distinct consumed
   codes; the complete code→mission table is written by the (resident, behind `0x181F:0x952`) planner
   helper whose body is outside the committed pages. Site: setter `func_04C3A2`, reader
   `func_04E05C @0x04E05C`/`@0x04E07E`.
6. **Order-7..12 secondary jump table** `jmp word cs:[bx+0x5c2a]` (`func_051D56 @0x51E15`) and the
   far-jump **island** slots at `0x534BC..0x53539` — CS(runtime)-relative; only slot `0x4F4`
   (→`func_04E2D6`) is pinned. Per-case targets TBD.
7. **RNG jitter** `0x181F:0x4D4(1,5)` per-candidate score noise — runtime, non-static (R).
