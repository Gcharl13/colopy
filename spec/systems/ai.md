# Computer-Player AI — per-unit order/move engine

> **Layer 4 — Simulation/AI.** Canonical AI spec (this file is the one canonical AI doc; the
> durable function index is `notes/ATTRIBUTION_OVERLAY.md`, decisions in `notes/rulings/RULINGS.md`).
> Tiers: B (`BYTE_VERIFIED` at a cited `func_XXXX @0xNNNN`) / A (anchor) / R (reconstructed) / open.
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

Decision pipeline (every step below is byte-cited to a `func_XXXX @0xNNNN`). The only non-static inputs are the DGROUP-resident compass delta tables `[bx+0xb4]`/`[bx+0xbe]` read in step 5 (runtime-initialised; see §8.1) and the per-candidate RNG jitter (§8.7) — both source-cited and explicitly runtime, not blocking the pipeline trace:

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

## 2a. The goto stepper — `func_062D84` + the pathfinder `func_061F02` (B, read 2026-08-29)

Order-driven movement (player Go To order 9/0xC, AI order 0xB) is stepped
per turn by **`func_040E22`** (the orders-11/12 dispatch row): it calls the
direction chooser **`func_062D84`** (`0x1a1f:0x210`) and executes the
returned compass dir — humans through the move executor `func_03FDDE`
(`0x191f:0x44e`, combat asks intact), AI through the stepper `0x1a1f:0x142`.

`func_062D84` (goal from `+0x314D/+0x314E`):

- **adjacent goal** (|dx|≤1 and |dy|≤1): the delta→dir converter
  (`@0x62E55..@0x62E78`) — one straight step, no scoring;
- **within 7** (`@0x62E94..@0x62EF1`): the 16×16 pathfinder (below) with
  budget 0x3E7;
- **farther**: a pre-check `0x1a1f:0x7d0`, then the pathfinder with budget
  0x3E6 toward the goal; on failure the goal is replaced by a **4×4-sector
  waypoint** (`[0xA572]/[0xA574]·4+1` chosen by `func_061E10` — unread) and
  the pathfind retried (`@0x62F21..@0x62F51`);
- an oscillation guard (`@0x62F58`: order 0xB, budget spent, found dir ==
  heading XOR 4 → fall through) and a straight-line walker fallback for
  European movers (`@0x62FB8..`).

**`func_061F02` — the pathfinder** (`0x1a1f:0x5f0`): a Dijkstra over a
**16×16 window centred on the GOAL** (origin g−8, byte cost plane
`[0xA270]`, BFS queue `[0xA372]/[0xA472]` head/tail `[0x2D18]/[0x2D16]`,
queue cap 0xE1=225 `@0x62055`, per-tile cap 0x63=99 `@0x6206B`), the wave
running FROM the goal, with a **goal cache** (`[0x2D1A/C]` — an unchanged
goal reuses the plane, `@0x61F83`). Tile admission: passable (`0x302`),
element match (water = terrain ids 0x19/0x1A only; **colony tiles admit
both elements** `@0x621A9`; ships may also enter when the `0x6b4` nibble
== 1 — unread), tiles holding a FOREIGN unit or settlement excluded
(owner query `0x6d2` `@0x6220A`), braves avoid `0x75e` (rumour) tiles
(`@0x621E8`). **Step cost onto a tile** (`@0x622A1..@0x6230C`): `1` when
BOTH tiles carry the improve road/river bits (`0x754 & 0xA`); else `1`
when both carry the terrain-plane river bit `0x40` (`0x72c`); else `3`
for a one-move unit (@UNIT movement ≤3 thirds, `@0x61F6B`); else **3× the
terrain Movement column** `[0x2F76 + 16·terrain]`. A HUMAN mover pays
**+8** for a tile beside a foreign settlement (`0x6e6` `@0x6225E`); AI
powers and natives skip such tiles entirely. **Step selection**
(`@0x62374..@0x625D3`): among the unit's 8 neighbours, lowest
plane-cost + step-cost (≤ 99), ties broken by the straight distance
`0x37a` to the goal. A debug overlay (`[0x894]&0x10`) draws the plane.

Both engines run the model in `advanceGoTo` (`gotoPathStep` /
`goto_path_step`); the sector waypoint is proxied by clamping the goal to
7 along the line — flagged.

## 3. `func_046FFA` — tactical heading score formula (B)

The candidate loop counter `[bp-0x34]` runs **0..8** (`@0x047371`/`@0x04738D`; **9 candidates** = 8
compass dirs + 8 = stay). Per candidate (dest tile from compass tables `[bx+0xbe]` dy / `[bx+0xb4]`
dx `@0x047399`):

| Term | Value | Site | Condition |
|------|-------|------|-----------|
| **Base** | **+200** (0xC8) | `@0x0473A4` | every candidate seeds `[bp-0x24]=200` |
| Water/Arctic reject | drop candidate | `@0x0473BB` | tile id (`0x181F:0x78C`) == 0x19 Ocean / 0x1A Sea-Lane / 0x18 Arctic |
| Heading continuity | **+4** | `@0x047A79` | candidate dir == current heading `0x314F` |
| Heading adjacency | **+3** | `@0x047A99` | `0x181F:0x384(cand,cur)` = `func_0049FC`, true iff `(cur±1)&7 == cand` — an adjacent-compass test (resolved 2026-08-07h) |
| Heading reverse | **−6** | `@0x047AB0` | candidate == `heading XOR 4` |
| Enemy on tile | reject | `@0x047A1D` | unit occupies dest (`0x181F:0x7E0`) and terrain flag `<0` |
| Colony proximity (stay) | **+40** (0x28·bool) | `@0x047A33` | `0x181F:0x8BC(2,unit)` |
| Settlement bonus | **+20** (0x14) | `@0x0479C0` | unit-type test |
| Home-settlement leash | **−3·d** | `@0x047AD0–0x047B39` | `[bp-0x78]` is a NATIVE-SETTLEMENT index (the `imul 0x12`/`[0x54EC]` reads): d = dist from the CANDIDATE tile to that settlement; `d > 2` ⇒ `score −= 3·d` (`sub [bp-0x24],ax` @0x047B39 — the old "score = 3·dist" gloss had the sign and the target wrong; corrected 2026-08-07h). **Predicates RESOLVED 2026-08-29**: halved when a "war-party" mode flag `[bp-0x86]` stands (`@0x47B05`), halved again for an **ARMED** unit (`0x902` = `func_00765C`: types 1/4/0xB/0x14/0x16 — Soldiers, Dragoons, Artillery, Armed Braves, Mtd. Warriors, `@0x47B14`), quartered for a **MOUNTED** one (`0x8D0` = `func_007630`: types 4/5/0x15/0x16 — Dragoons, Scouts, Mtd. Braves, Mtd. Warriors, `@0x47B26`) — an armed rider roams at an eighth of the leash |
| Frontier gate | skip block if 0 | `@0x047B46` | `0x984` = **`func_00704C(x,y,owner)`** — true iff a FOREIGN unit/settlement stands on one of the candidate's 8 neighbours **on the same landmass** (region via `0x3E4:0x74`), leaving that owner in `[0x8CFA]`; a 0 result skips the frontier terms (jmp `@0x47B52`→`@0x47C9A`), it does NOT drop the candidate (corrected 2026-08-29) |
| Border pressure (European) | **+50**, then **+(tension−50)>>2** | `@0x047B76`/`@0x047BB2` | adjacent owner `[0x8CFA] < 4` (a European): +50 unless the relation `0x20` peace bit stands (`@0x47B72`); the tension term only when the attitude band (`0xA60` = `func_008262`: 25/50/75 thresholds) is above Content — braves crowd hostile borders (the old "early-era terrain" gloss misread `[0x8CFA]` as an era; corrected 2026-08-29) |
| Border repulsion (tribe) | **−25** (0x19) | `@0x047C96` | adjacent owner `[0x8CFA] ≥ 4` — another tribe's ground repels |
| Colony drift (idle) | **+(band+1)·(12−d)>>2** | `@0x047C9A..@0x047D45` | normal mode (`[bp-0x86]`=0): the preselected colony `[bp-0x92]` in the unit's region (`0x6B4` match `@0x47CBE`) within distance <12 pulls idle braves by attitude; a `+5` on the unknown `[bp-6]` flag `@0x47CA4` remains unread |
| War-party tension bonus | **+16** (0x10) | `@0x047C52` | war mode, adjacent European with tension ≥ 0x5F (95) (the old "resource/yield" gloss; corrected 2026-08-29) |
| Colony-site | **+500** (0x1F4) | `@0x047D84` | war mode: a colony on the tile (`0x181F:0x7BE(x,y)≥0`) — the raid magnet; else a unit stack there is scored by a strength contest (`@0x47DB0..@0x47E73`: own strength ×1.5 vs the stack walked via the type jump-table at cs:0x1044 — +0x10/+8/+4/−1/−2 by class) |
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

### 3b. Colony-site VALUE — "Show Colony Sites" (CHEAT F9) — **CLOSED (B, 2026-06-28)**

The cheat menu's **F9 "Show Colony Sites"** (`MENU @CUP`) overlays a per-tile land-value digit on
the map. **Fully byte-traced (B) on 2026-06-28** — superseding the 2026-06-27 "not statically
locatable / draw-time, no cached array" finding, which was wrong on both counts (it searched for a
scorer next to the cheat handler and scanned the snapshot for the *terrain* mask; the value is a
**cached nibble** filled by a map-gen pass). Two independent passes (decode + adversarial verify)
agree.

**Dispatch (B).** `MENU @CUP` row **F09 "Show Colony Sites" = command id 0x6C**. The menu-bar builder
`func_072090` (page_1A) registers the row with id 0x6C; the cheat dispatcher `func_0235D6` (page_01)
runs a jump table at file `0x023DE8` whose 0x6C entry trampolines (`cs:0x44C2 → ljmp 0x181F:0xF48`)
to handler **`func_021602`** (file `0x021602`, page_01). (F08 "Show Strategy" = id 0x6B → `func_02165E`
confirms the table; the F09 thunk pointer is runtime-patched, so the handler was pinned via the
jump-table structure, not the pointer.)

**Handler = display only (B).** `func_021602` sweeps the visible viewport (rows `[0x8328]..[0x8804]`,
cols `[0x832e]..[0x8806]`); per tile it fetches a byte from **map-layer #4** via `181F:0x74a`
(=`func_005EE8`: `es=[0x16a]; bx=[0x168]+y*[0x853a]+x; al=es:[bx]`), **masks `& 0x0F`**, and draws the
nibble via `191F:0x12c`. So the shown value is the **low nibble of map-layer #4** — range **0–15**
(the earlier "0–24" was an over-estimate; the clamp ceiling is 15, observed coast max 13).

**The value IS cached (correction).** Map-layer #4 is the 4th of four `width×height` byte planes
malloc'd by the layer allocator at `func_070FE8`/`0x710A2` (far ptr `[0x168]/[0x16a]`, stride
`[0x853a]`=map width). It is **dual-nibble**: high nibble = per-power fog/visibility bits (written by
the reveal/render path `func_0685DC @0x685F9`, `[0xa89e]`); **low nibble = the colony-site / land-value
score**. The 2026-06-27 full-snapshot scan was a false negative — it matched the *terrain* land/water
mask, which this packed-nibble plane does not resemble.

**Formula — writer `func_063F3C` (B).** The low nibble is filled tile-by-tile during new-game map
generation by **`func_063F3C`** (body file `0x063F3C`, page_14; invoked from the new-game chain
`func_0755CC @0x757BA` via `0x1a1f:0x7f8` — already byte-verified as the "resource/land-value layer"
writer in `map_generation.md` §… (Q4 / pass list), here connected to the F09 display). Store site:
`func_005ED0` (`181F:0x736`, address-of layer-4 tile) → `mov es:[bx], al` at file **`0x064130`**
(page_14.asm:832). Per tile (outer y `0..[0x853c]`, inner x `0..[0x853a]`):

- **Water / out-of-bounds → 0** — in-bounds gate `181F:0x302` (`func_005BFA`); water/occupancy gate
  `181F:0x768` (`func_0062B4`) non-zero ⇒ skip accumulation, the accumulator stays 0. This is why
  ocean / sea-lane read 0.
- **Land:** accumulate a score over the **~21-tile colony catchment** (signed delta tables `[bx+0xc8]`
  =dx, `[bx+0xde]`=dy; ring index `[bp-0xe]=0..0x14`). Each catchment tile's base contribution:
  - special-resource present (`181F:0x718`=`func_0060A0` returns id ≠ −1) → bonus from table
    `[id − 0x684e]`;
  - else ocean (terrain id 25) → coastal-adjacency bonus `(2 + 2·adjacent-land) >> 2` (8-neighbour
    deltas `[si+0xb4]`/`[si+0xbe]`, gated by `181F:0x768`);
  - else → the per-terrain **Improvement** stat `byte[terrain·16 + 0x2F79]` — offset 2 of the 4-byte
    prefix Movement/Defensive/**Improvement**/Value in the 16-byte terrain record (base `0x2F77`;
    yields at `+0x2F7B` per `map_system.md`);
  - plus +1 if the layer-1 feature bit `0x40` is set (`181F:0x72c`=`func_005CFE`).
  Each contribution is **ring-weighted** (multiplier 5→2, nearer rings higher; thresholds
  `cmp [bp-0xe], 4/8/0xc/0x14`) as `di = (di·w) >> 1` and summed into `[bp-0x10]`.
- Post-process: a near-existing-colony test (`181F:0xd12`/`181F:0x6b4` vs `[0x8dba]/[0x8dbc]`) halves
  the score; centre terrain Mountains (27) → 0, Hills (28) → halved.
- **Final low nibble = `clamp( score / 10, 0, 15 )`** — `idiv 10` at `0x6410E`, then
  `181F:0x35c` (`func_0048CC` = clamp(v, lo=0, hi=0xf)).

**Oracle cross-check (A).** The byte formula reproduces the live capture: ocean / sea-lane = 0;
coastal land carries the score (observed run 9 / 11 / 12 / 13 / 13, `docs/screens/colony_sites_live*.png`);
range 0–15. Formula and oracle agree. **This was the last open spec item; it is now closed (B).**

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
| `+0x04`..`+0x08` | (cols 6–10) | ship/cargo block, split pinned (§8.2): `+0x04`(`0x5238`)=`99` naval sentinel (`CMP [bx+0x5238],0x63` @0x03FCC9); `+0x05`(`0x5239`)/`+0x06`(`0x523a`)=ship cargo/size math (`+0x05` clamped ≥1 then `IDIV cx` @0x051536; `+0x06` @0x00B6E3); `+0x07`(`0x523b`)/`+0x08`(`0x523c`)=the two combat-roll strength terms summed into `rand(1,sum)` (`MOV al,[bx+0x523b]` @0x05B823, `MOV cl,[bx+0x523c]` @0x05B83B, `ADD ax,cx` @0x05B844, `LCALL 0x181F:0x4D4` @0x05B849) | combat roll @0x05B819-0x05B849; cargo idiv @0x051536; sentinel @0x03FCC9 |
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
  `jmp word cs:[bx+0x5c2a]` `@0x051E15` post-processes the result; the 6 entries are byte-decoded
  (inline table @file `0x051E1A`, §8 item 6): order7→func_040C1E, 8→func_040656, 9→func_0409D6,
  10/default→func_007BCE (`0x181F:0x934` post-turn refresh), 11/12→func_040E22 — all page-08 order
  handlers called with `[bp+6]`=unit.
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

## 8. Open questions (each with its site)

1. **Compass delta tables** `[bx+0xb4]` (dx) / `[bx+0xbe]` (dy), 9 entries — DS/BSS-relative,
   contents runtime-set; exact deltas not in the instruction stream. Site: `func_046FFA @0x047399`,
   `func_04E2D6 @0x051846`.
2. ✅ **Per-type stat tables — RESOLVED 2026-06-27 (§5a).** `0x5234`/`0x5236`/`0x5237`/`0x523d` are
   **fields of one 14-byte UnitTypeStats record** (`DS:0x5234`, stride ×14 proven at `@0x006CEE`,
   not ×6) = the loaded **`@UNIT` CSV** with moves×3. Values are the `@UNIT` primary data (no longer
   open); the middle ship/combat fields `+0x04..+0x08` are now reader-pinned (RESOLVED 2026-06-27,
   §5a): `+0x04`(`0x5238`)=`99` naval sentinel (`@0x03FCC9`), `+0x07`/`+0x08`(`0x523b`/`0x523c`)=the
   two combat-roll strength terms summed into `rand(1,sum)` (`@0x05B844`), `+0x05`/`+0x06`
   (`0x5239`/`0x523a`)=ship cargo/size math (`idiv` divisor `@0x051536`, ×32 extent `@0x00B6B1`).
3. ✅ **Resident scoring/path helpers — RESOLVED 2026-06-27 (§3a).** The `0x181F:xxxx` helpers are
   named load-image-resident functions; their bodies bottom out at the engine's shared **map-access
   layer `0x37f`** (tile-valid / raw-byte / unit-at-tile / terrain) and the already-specified
   map (`MP_FORMAT.md`) + colony (`colony.md`, stride `0xCA`@`0x5d46`) data. No AI-only black box
   remains beneath the helper map. The only soft spot is the exact arithmetic *weighting* inside
   `func_0083F2` — **RESOLVED 2026-06-28 (B).** It is the *nearest-matching-colony* scan (loop over `num_colonies` `[0x539E]`, ColonyRecord stride `0xCA` @`0x5D46`, filters on `+0x5D60`/region/`+0x5D62&0x40`), and its per-step **weighting is the octile distance** `cost = max(|dx|,|dy|) + (min(|dx|,|dy|)>>1)` computed in helper **`func_004900`** (`lcall 0x24C:0x40 @0x008491`); best kept by `cost<=best`, result via `func_0082DC`. Fully static — no AI black box remains.
4. ✅ **Plan-map outer-index — RESOLVED 2026-06-27 (§6.1): POWER-indexed (4×64).** All plan
   reads/writes are in `func_04CC50` (`[bp+6]`=power); BSS layout proves it (table `0x98B0..0x9CB0`,
   next global cluster at `0x9CB0`; unit-indexed would overflow the 64 KB segment). The prior
   "unit-indexed" reading was a function-boundary mis-attribution.
5. ✅ **Plan-map goal_type semantics — RESOLVED 2026-06-27 (multibranch decode).** goal_type is **not**
   an opaque mission enum and there is **no** separate writer behind `0x181F:0x952` — that thunk resolves
   to the reachability helper `func_00723E` (`0x181F:0x952`→`func_00723E`), unrelated to the plan field.
   The *only* writer of plan field `[bx−0x674e]` is the local naked setter `func_04C3A2 @0x04C3F6`
   (`mov [bx−0x674e],al`, al = caller-frame goal_type arg `[bp+0xc]`); the clearer writes `0xFF`
   (`func_04C1F0 @0x04C1FF`). Reader `func_04CC50 @0x04DFFB` decodes goal_type **as a bit index into the
   per-unit-type capability bitfield** UnitTypeStats `+0x523d` (§5a): `cl=goal_type; ax=1<<cl;
   dl=[type·14+0x523d]; test ax,dx` — a plan slot of goal_type G is matchable only if `(1<<G)&capbits`
   is set, so **goal_type ∈ 0..7 = the capbit position**, the same bitfield the build states B/e test
   (§5a: Colonist 0x40, Soldier 0x1c, Caravel 0xA2). Three values carry extra reader behaviour:
   `==1` → state `'1'`→`'t'` (`@0x04E16E`/`@0x04E175`) plus unit-flag `0x3148&4` gate (`@0x04E05C`);
   `==7` → `'t'`→`'i'` (`@0x04E188`/`@0x04E194`) plus `0x3148&8` gate (`@0x04E07E`); `==4` → consumed
   but **excluded** from the per-class tally (`cmp [si−0x674e],4; je skip-increment` `@0x04E1BF`). The
   downstream *mission* a matched unit then runs is chosen by the §6.2 dispatch (`func_04E2B6` char
   table), not by a goal_type→mission table. Setter `func_04C3A2`, readers `func_04CC50
   @0x04DFFB`/`@0x04E05C`/`@0x04E07E`/`@0x04E16E`/`@0x04E188`/`@0x04E1BF`.
6. **Order-7..12 secondary jump table — table RESOLVED 2026-06-27 (binary decode); island slot-labels
   still partial.** `func_051D56 @0x051E0A`: `ax=order−7; cmp ax,5; ja default; shl ax,1; jmp
   word cs:[bx+0x5c2a]`. The 6-word table is inline right after the jmp (file `0x051E1A`, bytes
   `fc 5b e6 5b f2 5b 10 5c 06 5c 06 5c`); runtime-CS offsets = file-local−0x7A0), decoded to:
   **order7→`@0x051DEC` `lcall 0x191F:0x1FA`=func_040C1E (pg8); order8→`@0x051DD6` `0x191F:0x1C2`=func_040656 (pg8);
   order9→`@0x051DE2` `0x191F:0x216`=func_0409D6 (pg8); order10/default→`@0x051E00` `0x181F:0x934`=func_007BCE
   (resident post-turn refresh); order11→`@0x051DF6` `0x191F:0x4BA`=func_040E22 (pg8); order12→`@0x051DF6`
   = same func_040E22.** Each passes `[bp+6]`=unit; these are the page-08 order-execution handlers (the
   `'E'`/goto-dispatch band, §4 `@0x041B6D`). The far-jump **island** `0x534BC..0x53539` is byte-decoded
   as **26 `ljmp 0x1A1F:OFF` slots** (5-byte ljmp, OFF=0x464+slot·0xC up to 0x590; target base
   0x04DDE2 ⇒ files 0x04E246..0x04E372 in the `func_04CC50`/`func_04E2D6` band). Slot 12
   (`0x534F8`→`0x1A1F:0x4F4`→file 0x04E2D6 = `enter 0xee,0`) is the confirmed `func_04E2D6` entry; the
   other 25 targets are **interior labels** of that giant function reached by computed dispatch. **TERMINAL
   (B):** `func_04E2D6`'s behaviour is fully decoded (the per-unit order/mission pipeline, §2), so these 25
   slots are *resume-points into the already-decoded state machine*, not a separate undecoded mechanic —
   mapping each slot to its exact interior offset is cosmetic labelling, with no missing game logic.
7. **RNG jitter** `0x181F:0x4D4(1,5)` per-candidate score noise — runtime, non-static (R).


## Amendment 2026-09-03 — `func_046FFA`: the +4 pair, the +5, the war block, the ring (CORE-B, RULINGS 2026-09-03d)

- Candidate ring = DS:0xB4/0xBE (file 0x1DA54/0x1DA5E): N,E,S,W,NW,NE,SE,SW;
  candidate 8 = stay. Rejects: class 0x19/0x1A (`func_00624E`: Ocean/Sea
  Lane — hills are 0x1C, mountains 0x1B) `@0x473C6`, a rumour tile
  (`0x181F:0x75E`) `@0x4737E`, Arctic `@0x473D2`.
- `+4` `@0x47AC6`: candidate and unit tile both road/river-improved
  (`0x754 & 0xA`), else an even candidate index with the terrain river bit
  (`0x72C & 0x40`) on both (`@0x47BB8..@0x47BD3`).
- `[bp-0x86]` war footing `@0x4731A..@0x47365`: count of powers p with
  `tension(tribe,p) >= 75` or home alarm word `>= 0x80`. Zero → the peace
  branch: `+5` for an unclaimed candidate (`@0x47CA4`) then the colony
  drift; nonzero → the war block `@0x47D48`: hostile claim owner
  (`[bp-0x14]`/`[bp-0x6E]`, `@0x4744F..@0x474DF`, incl. the besieger
  `[bp-0x4C]` of `@0x471F5..@0x47309`) → +5, +10 prime, +500 colony, else
  the stack contest (`@0x47D8C..@0x47E73`, type table file 0x47E24);
  non-hostile with a settlement → reject (`@0x47E78`).
- Port status: both engines run the ring, the +4 pair, the +5, the war
  footing, the besieger, the hostility pair and the +5/+10/+500 block; a
  war brave's raid fires on the +500 pick. Flagged: the foreign-stack
  branch/contest (no brave-vs-unit combat), rival-power tension/alarm, the
  region gate, the own-tribe stack −40.
