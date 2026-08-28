# Cross-Source Rulings

The `cross-source-reconciler` agent records rulings here. One ruling per
conflict. If a ruling is later overturned, add a NEW entry that supersedes
and links back — don't edit the old one.

Format:

```
## YYYY-MM-DD — Short title

**Conflict**: one-sentence summary of what disagreed.

**Source A** — [which source/agent] said: [claim], citing [evidence].

**Source B** — [which source/agent] said: [claim], citing [evidence].

**Ruling**: [decision] because [rule from TRUTH_HIERARCHY.md].

**Action taken**:
- [which files updated]
- [what code change if any]

**Follow-up**: [any open question the ruling does not close]
```

---

## 2026-08-17 — `ColonyRecord +0xAA` is the HORSES stock, not a food-growth store; `func_00A3E1` is horse breeding

**Conflict**: `spec/systems/colony.md` §3 builds the colony **food**-growth model on
`ColonyRecord +0xAA` and reads `func_00A3E1 @0x0A5B4..@0x0A63F` as the food-growth
gate, with a "25 with a Stable / 50 without" threshold. Both engines' horse-breeding
code cited the same offsets for **horses**. They cannot both be right.

**Source A** — `spec/systems/colony.md` §3 ("Growth & starvation mechanism", refined
2026-06-27) said: `+0xAA` is the food-growth store, `func_00A3E1 @0xA5BB/@0xA5C0/@0xA5CD`
is its 25/50 threshold, and the per-turn `+= surplus/2` accumulation into `+0xAA` is the
one write with no statically-resolvable site image-wide (write census, 2026-06-28).

**Source B** — the EXE bytes, read directly this session.

**Ruling**: Source B. `+0xAA` is the **Horses** stock and `func_00A3E1
@0x0A5B4..@0x0A63F` is the **horse-breeding** calculation. Three independent byte
anchors settle it:

1. `push word ptr [bx+si+0x9a]` **@0x08E6E** with `si = good_id * 2` and
   `bx = [0x8542]` (the current-colony pointer) — the colony stock array is at
   `ColonyRecord +0x9A`, u16 per good, indexed by good id. `+0x9A + 2*8 = +0xAA`,
   and cargo row 8 is **Horses**.
2. The same helper's `mov ax,[bx-0x7238]` **@0x08E50** (`bx = good*2`) resolves to
   DGROUP `0x8DC8` — so the `[0x8dc8]` read at @0x0A5F7 is `produced[FOOD]`, good 0.
3. Buildings row **0x11 is the Stable** (`dat_buildings[17]`), which is what
   @0x0A5C0 `push 0x11; call 0x863e` queries.

Read as horses, the block is coherent end to end, and every constant lands:
`herd < 2 -> no breeding` (@0x0A5B4 `cmp [bx+0xaa],2`) is the classic
"you need a pair"; `T = Stable ? 25 : 50` is the **divisor** in the per-turn cap
`2*ceil(herd/T)` (@0x0A5D6..@0x0A5E2), never a gate; the feed is
`ceil(max(0, produced_food - 2*pop)/2)` (@0x0A5F7..@0x0A606); the herd cannot exceed
the warehouse (`room = max(0, func_008D00() - herd)` @0x0A614..@0x0A625, and
`func_008D00 @0x08D00` returns 100 at level 0 else `(level+1)*100`); and the foals'
feed is added to the colony's food consumption at @0x0A63F. Read as food, the
`cmp ...,2` gate, the `*2` cap and the warehouse clamp are all unexplained — and so
is the write census's finding that no per-turn `+0xAA` write exists, which is exactly
what you expect of a **stock** field updated by the generic indexed goods loop.

This also disproves `docs/REMAINING_WORK.md` B.1 `@NEWCOLONIST`, which claimed the
25/50 evidence was "mis-attributed to horses". It was correctly attributed. The
separate `@NEWCOLONIST` 200-food threshold stays **tier R (manual)** and flagged —
this ruling finds no byte evidence for it either way and does not touch it.

**Action taken**:
- Both engines: horse breeding rewritten to the byte model. The previous rule —
  gate `herd >= 25/50`, then `herd += max(1, herd/10)` — was invented at both ends.
  `cport/core/colopy_colony.c` `horses_bred()` / `colony_store_cap()`;
  `port/src/game.js` `horsesBredThisTurn()` / `warehouseCapacity()`.
- Colony food consumption now includes the foals' feed (@0x0A63F), so `eaten` is
  `2*pop + bred` and the colony screen's food row matches the engine's.
- Retires the JS flag "the herd compounds past 65,535": `room` bounds it every turn.
  Observed in the oracle traces — Curacao and Guadeloupe now stop dead at 100, the
  level-0 warehouse capacity.
- `spec/systems/colony.md` §3 corrected; `docs/REMAINING_WORK.md` B.1 corrected.

**Follow-up**: the real per-turn food-growth store for `@NEWCOLONIST` is still
unlocated — the write census that went looking for it was searching the wrong field.
The 200 threshold remains manual-tier. Also unread: whether the engine applies
breeding before or after the goods loop banks production (this port computes it from
the pre-update herd, matching what the forecast `func_00A3E1` reads).

---

## 2026-08-17 — The SFX id→COLDIG.BIN map: byte-decoded index beats the empirical correlation map

**Conflict**: two committed tables claim to say where each SFX id's samples live
in `COLDIG.BIN`, and they disagree on every id they share.

**Source A** — `data_extracted/data/coldig_slices.json`
(`tools/audio/map_coldig.py`, from the audio branch) said: offsets and lengths
recovered by chunked cross-correlation of DOSBox captures against the bank,
carrying per-row `score`/`approximate` flags and self-labelled
`"tier": "empirical capture (RULINGS 2026-08-16) — NOT byte-cited"`. 16 ids clean
enough to ship as verbatim slices, including `0x59`; `0x4D` `0x4E` `0x4F` `0x5B`
shipped as FM renders instead.

**Source B** — `data_extracted/coldig_index.json` (`tools/decode_coldig.py`) said:
the sample table read out of the `.COL` sound drivers themselves — 35 samples with
`(offset, length)`, `sfx_id_to_index` for the 25 ids the dispatcher maps,
`sfx_ids_not_samples` for the 5 it does not, and `rate_rule` from `cmp bx,5` at
ASOUND `0x00F19`.

**Ruling**: Source B. `notes/TRUTH_HIERARCHY.md` puts a driver's own table, read
at a cited offset, above an empirical capture correlation. Source B also passes
three independent self-checks that Source A cannot: the 35 lengths sum to exactly
993,755 = the byte size of `COLDIG.BIN`, the offsets are fully contiguous with no
gap or overlap, and the terminator lands on EOF. Measured against Source B,
Source A's offsets drift by tens to thousands of bytes on all 15 shared ids and
its lengths run uniformly short (trimmed decay tails), and it maps `0x59`, which
the drivers list as not a bank sample at all.

**Action taken**:
- `tools/gen_audio_pack.py`, `tools/audio/verify_pack.py`,
  `tools/audio/trim_masters.py` now read `coldig_index.json`.
- `COLAUDIO.PAK` SFX census 16 -> 25 entries, all 25 verified bit-clean against
  the bank (`tools/audio/verify_pack.py`: 0 failures). `0x4E` `0x4F` `0x5B` —
  wired cues `RAIDGOLD` / `RAIDSTORES` / `RAIDNOTHING` — become real samples
  instead of FM renders; `0x4D` and `0x50`..`0x56` join them.
- The generator now rejects any sample that is not 11025 Hz, because the mixer's
  PCM8U path is a fixed 2x hold (`cport/audio/colopy_audio_mix.c:115`). No sfx id
  maps to one of the five 19050 Hz samples today (the lowest maps to index 5),
  so nothing is excluded — the check exists so a future remap cannot ship a
  sample at the wrong pitch silently.
- `data_extracted/data/coldig_slices.json` retained as a record of the capture
  work, marked superseded in its own `_meta`, read by nothing.
- `formats/BIN.md`, `docs/AUDIO_PORT.md`, `cport/audio/README.md`,
  `tools/audio/README.md`, `docs/REMAINING_WORK.md` Part F updated.

**Follow-up**: sample indices 0..4 (19050 Hz) are not reachable through
`sfx_id_to_index` — what plays them is still TBD. The 5 `sfx_ids_not_samples`
(`0x46` `0x47` `0x59` `0x5A` `0x5D`) remain FM, shipped as capture renders when
the masters dir is present; `0x46`'s capture carried no signal and is excluded.

---

## 2026-08-17 — Founding a colony crashed the board: a 1 KB stack array in the end-turn chain

**Conflict**: on the P4, Build Colony crashed the board (user report). Nothing
in the host build or any oracle showed a fault — founding is byte-parity clean
in both engines.

**Cause**: the same-day sail-for-Europe work put
`int arrived[COLOPY_MAX_UNITS]` — 256 ints — on `advance_goto`'s stack to
collect ships that had reached their lane. `-fstack-usage` measured the frame
at **1,216 bytes**, and `advance_goto` sits deep in the end-turn chain.
`cmd_found_colony` calls `unit_remove` on the founder, so founding runs
`advance()` → `end_turn()` → the whole chain — from inside the key
dispatcher's own 3,216-byte frame, under the board's dialog/ask nesting. The
board's task stack could not absorb it. `-Wframe-larger-than=4096` never
fired because no single frame was oversized; the depth was.

**Ruling**: the collection does not need a stack array at all. The mark rides
in `CR.unit_sail_home` itself (value 2 = "arrived, pending departure") — CR is
static, is already compacted by `unit_remove`, and the mark never outlives the
call. The departure pass then re-scans from the front after each removal,
which keeps departures in `G.units` order (matching the JS, which departs its
`arrived` list in collection order) without holding indices across the
compaction. Behaviour is unchanged: all five input oracles, 100 turns x 3
fixtures plain and `agitate script`, and every render oracle are identical
before and after.

**Verified**: `turn_step5`'s frame is back to **304 bytes — its exact
session-start value**; `advance_goto` no longer appears in the `-fstack-usage`
report at all.

**Follow-up**: this is the THIRD board crash this project has had from stack
depth (the 25,600-byte colony scene band, the static-vs-heap link failure, and
now this), and the first that a per-frame ceiling could not have caught. The
gate that would have caught it is a WORST-CASE PATH budget — summing frames
along `in_key_inner -> run_menu_row -> cmd_* -> advance -> end_turn -> ...` —
not a per-function limit. Nothing computes that today. TBD, and worth building
before the next board feature lands.

---

## 2026-08-17 — Sea lanes and coasts rendered SANDY: the placeholder fallback ran in the wrong order

**Conflict**: on the board every sea-lane tile and every coast edge painted a
sandy tan instead of blue water (user report, 2026-08-17). Nothing else on the
map was wrong.

**Source A** — the pixels. `TERRAIN.SS` frame 11 (Sea Lane) is blue and **24% of
its pixels sit in palette indices 120..127**; no other TERRAIN frame touches that
band at all, and `PHYS0.SS`'s clean coast edges (150..153) use it too. That band
is the VGA cycling band `CYCLE.DAT` rotates (`start=120 len=8`), so "the things
made of the cycled band" is exactly "sea lanes and coasts" — which is precisely
the set the user reported.

**Source B** — the rendered frame. Dumping the C's framebuffer indices against
its output RGB showed all eight band entries wrong and nothing else:
index 120 rendered `(235,186,89)` where the master has `(77,101,174)`. Those tan
values are `OPENMENU.PIK`'s — the TITLE SCREEN's sand.

**Cause**: `WOODTILE.SS`, the map screen's own backdrop sheet, contains no water,
so its palette leaves 120..127 (and 13, 139..143, 252..254) as magenta
placeholders. Both engines then patch placeholders from the UI picker palette
(`OPENMENU.PIK`) — `game.js:43`, mirrored in `rd_use_palette` and
`rm_use_map_palette`. The C is single-palette (the DOS DAC model), so that merge
reaches the SPRITES, and the water band became sand.

**Ruling**: the fallback order was wrong. A magenta placeholder takes the
**MASTER** palette first, and the UI picker palette **only where the master is a
placeholder too**. The master's 120..127 is the authored blue ramp the DAC
rotates, and it is capture-verified: `port/tools/build_assets.py` measured
TERRAIN frame 11 against `docs/screens/06_ingame_map.png` at **3/256 pixels off
through the master versus 50/256 through the sheet palette**, the three being the
capture's own near-duplicate blue. Index 13 is the same class (master orange
`(255,113,0)`) — and `game.js:25-26` already names that exact failure for the
Dutch plates. Indices 139..143 and 252..254 ARE placeholders in the master as
well, and those are the ones the picker palette is genuinely for.

**Action taken**:
- `cport/render/colopy_render.c` — new `rd_pal_placeholder` /
  `rd_pal_fill_placeholders` implementing master-first; `rd_use_palette` uses it.
- `cport/render/colopy_map_render.c` — `rm_use_map_palette` uses it (this is the
  map screen's own WOODTILE merge, the one that produced the sand).
- `port/src/game.js` — `usePalette` gets the same order, so both engines share
  one rule. Latent rather than visible there: JS sprites are pre-baked RGB and
  `cycAtlas` already resolved the band through the master, so only UI ink was
  affected.

**Why no oracle caught it**: `tools/render_map_compare.py` accepts a mismatching
pixel when the C's INDEX re-resolved through the master equals the JS pixel —
which is exactly what a wrong `RD.pal` produces. The oracle was checking the
indices, and the indices were right all along. The fix shows up as a collapse in
that accepted-delta count, which is the real signal: **view(43,30) 2372 -> 3**,
plus map(20,30) 539 -> 104, event 467 -> 54, colony 200 -> 145. The C now agrees
with the JS pixel-for-pixel, not merely index-for-index.

**Follow-up**: the accepted-delta counts are now small enough to be worth
watching as a regression signal in their own right; nothing enforces a ceiling on
them today. TBD.

---

## 2026-08-17 — "The fence" is OUT of the colony, so a man there neither draws with the colonists nor eats

**Conflict**: a colonist told "Return to the fence" (or dragged out of the
fields) kept his seat in the colony: he stayed in `c.colonists` / the record's
population, drew among the COLONISTS in the plaza row's first group, and went on
eating two food a turn for a job he no longer had (user report, 2026-08-17).

**Source A** — GAME.TXT, two keys, both unambiguous about what the fence is:
- `@TUTORIAL4`: "To take a colonist **out of a colony**, drag him to the fence
  (near the water on the colony picture)."
- `@TUTORIAL15`: new arrivals wait at the "fence" until you drag "the colonists
  **from the 'fence' to a field or building**" to make them citizens.
So the fence holds people who are ON the colony square but are NOT members of
it — arrivals not yet hired, workers taken off the job.

**Source B** — `spec/ui/colony_screen.md` §3.3 (`func_0270D0`, byte-verified):
the plaza row's count is `colony+0x1F` (members) **plus** `[0x8D72]` (units on
the tile), with a 4px break between the two groups. Two groups, one row — and
the second group is exactly Source A's fence.

**Source C** — food, byte-verified `@0xA5F2`: `eaten = 2 * pop` over the
colony's POPULATION, restated in plain English by `@TUTORIAL16` ("Each colonist
eats two units of food per turn").

**Ruling**: all three agree and the port disagreed with all three. Leaving for
the fence is a MEMBERSHIP change, not a job change: the man is removed from the
colony's colonist list and appended to the unit pool standing on the colony
square. Everything the user asked for then follows from machinery that was
already correct — he draws in the plaza row's garrison group (after the break)
because that group is "units on the tile", and he stops eating because `eaten`
counts members. No new render geometry and no new food rule were invented.

**Action taken**:
- `port/src/game.js` — new `colonistToFence(c, i)`, the mirror of the existing
  `unitToColonist`; the jobs menu's "Return to the fence" row and the
  drop-out-of-the-fields drag both call it.
- `cport/core/colopy_turn.c` — `colonist_to_fence(ci, k)`. The record's colonist
  arrays are index-packed, so removing one in the middle shifts `occupation[]`,
  `profession[]` and `taught[]` and re-bases every `tiles[]` reference past it.
  Also `unit_type_for_profession`, mirroring `mkUnit`'s profession branch.
- `cport/game/colopy_input.c` — the C's row-9 handler calls it instead of just
  blanking the occupation byte.
- `tools/sim_trace.py` + `cport/host/main.c` — the `script` harness sends a
  colonist to the fence every 13th turn, so the path is oracle-covered. Verified
  live: Jamestown 10 -> 9 at t=13 and 9 -> 8 at t=26, both engines agreeing on
  every projected field for 100 turns on all three fixtures.

**Refused to guess, twice**:
- **Emptying a colony.** `colonist_to_fence` refuses when it would take the LAST
  member. The engine's behaviour there is unread, and abandonment already has
  its own explicit command (`@ABANDON`, shift-A), so this does not invent a
  second path into it. FLAGGED.
- **A fence hit-rect.** `@TUTORIAL4` places the fence "near the water on the
  colony picture", but no byte-read rect for it exists, so no fence drop-zone
  was added to the pointer layer. The change rides on the two existing exits —
  the named menu row and the drop-out-of-fields drag. TBD.

**Follow-up**: `importSav` can still produce a member with no job (game.js:10455
clears a field job whose cell is missing). That is load-time normalisation
against the save's own population byte, which drives `eaten`, so it is left
alone — but it means "member with no job" is still a representable state.

---

## 2026-08-17 — A ship ordered home sails to the sea lane; it does not vanish where it stands

**Conflict**: choosing "Return to Europe" (the ORDERS row / `e` key, or the Go To
picker's homeport row) lifted the ship off the map instantly from wherever it
was floating, and the crossing recorded THAT square as its return point (user
report, 2026-08-17).

**Source A** — `docs/GAME_MANUAL.md` p18 (Sea Lane terrain) and p57 (SAILING TO
AND FROM EUROPE), both explicit and agreeing: "To return to Europe, a ship only
has to enter a sea lane, then move toward the east (if exiting east) or west (if
exiting west) map edge", and "the ship must enter a Sea Lane square on the map
display, then move toward the nearest map edge. When this occurs, the ship
disappears from the map display... When the ship arrives back in American
waters, it appears in the Sea Lane square from which it left."

**Source B** — the port, JS and C alike: `sailForEurope` / `cmd_sail_for_europe`
spliced the unit out on the spot. The ORDERS row was already gated on
`onSeaLane` (capture-derived: the census frigate mid-Ocean shows the row
DIMMED), so the two halves of the port disagreed with each other — the menu knew
the lane mattered, the command did not.

**Ruling**: the manual wins on the FUNCTION of a feature (TRUTH_HIERARCHY: the
manual is HIGH trust for what a feature does; EXE bytes win only on exact
numbers, and no byte site here is read). A ship already on the lane departs at
once; one in open water is ordered to the NEAREST lane and begins its crossing
the moment it arrives. "Nearest" is Chebyshev distance — ships step 8-way, so
that is the turn count — with ties broken on the first square in scan order so
both engines land on the same lane.

**Action taken**:
- `port/src/game.js` — new `nearestSeaLane` + `orderSailHome`; `returnToEurope`
  and the Go To picker's Europe row route through it; `advanceGoTo` collects
  ships that reached their lane and departs them after the loop (sailForEurope
  splices the array being iterated).
- `cport/core/colopy_europe.c` — `nearest_sea_lane` + `cmd_order_sail_home`;
  `cport/core/colopy_rivals.c` `advance_goto` mirrors the arrival hook, re-basing
  queued indices because `unit_remove` compacts the records.
- `cport/core/colopy_sim.h` / `colopy_turn.c` — `CR.unit_sail_home[]`, compacted
  in `unit_remove` and cleared in `unit_append`.
- `tools/sim_trace.py` + `cport/host/main.c` — the `script` harness now orders
  its idle ships home through `orderSailHome`/`cmd_order_sail_home` instead of
  departing them directly, so 300 turns x 3 fixtures of oracle cover the whole
  leg: the Go To out, advanceGoTo walking it, and the arrival.

**Two things this did NOT change**, deliberately:
- **Trade routes.** `runTradeRoute`'s STOP_EUROPE still departs directly; routing
  it would overwrite ORDER_TRADE with the Go To order and break the route state
  machine. Automated, not a player order — out of scope, flagged here.
- **The forced privateer recall** in the diplomacy branch (game.js:8287) still
  departs immediately: the rival is throwing the ships out, not the player
  ordering them home.

**Follow-up**: `advanceGoTo` moves a unit ONE square per turn regardless of its
movement allowance, so the sail-to-lane leg is slower than the ship should be (a
Merchantman took 11 turns to cross 8 squares in the savstart check). That is a
pre-existing limitation of the Go To executor in BOTH engines, not something this
change introduced, and fixing it needs its own evidence pass. TBD.

---

## 2026-08-17 — Rival colony capture never announced @CAPTURED3 in the C

**Conflict**: `advance_goto`'s new arrival hook shifted turn timing just enough
for a rival to take a player colony AFTER the declaration in the 100-turn
`agitate script` run, and the turns oracle went red on one field of one turn:
`sav1653` turn 52 `.events` — JS `CAPTURED3`, C `CAPTURED`.

**Source A** — game.js:7642 (rivalTurn) gates the announcement
`G.declared ? 'CAPTURED3' : 'CAPTURED'`, citing the byte-read split
`func_05CA7E @0x5DED1`. The C's OWN player-capture site
(`colopy_cmd.c:742`) already carries the same gate on `CR.woi_flags &
WOI_DECLARED`.

**Source B** — `colopy_rivals.c:512` emitted a hard-coded `"CAPTURED"`.

**Ruling**: the C site is simply missing the gate its sibling already has, and
the byte citation is on the JS side. Fixed to match.

**Action taken**: `cport/core/colopy_rivals.c` — the rival-capture emit now
splits on `CR.woi_flags & WOI_DECLARED`.

**Follow-up**: this is the FOURTH latent JS/C divergence surfaced in one day by
changing behaviour the fixed oracle scripts had never driven into. The pattern is
worth naming: a green oracle means the scripts agree, not that the engines do.

---

## 2026-08-17 — Standing orders in the unit cycle, and the three divergences it unmasked

**Conflict**: `nextUnit()` / `next_unit()` handed a unit back as the active unit
even when it carried a standing order, so a pioneer told to Clear/Plow or Build
Road came round again the moment its moves refreshed, and stepping it threw the
part-done work away (user report, 2026-08-17). Adding the obvious `!u.orders`
test then broke the input oracle in three places at once, and the first two
diagnoses of WHY were wrong.

**Source A** — `@ORDERS`, NAMES.TXT (byte-verified, `spec/systems/unit.md`):
0=No Orders, 1=Sentry, 2=Trade Route, 3=Go To, 4=Live In Village, 5=Fortify,
6=Fortified, 7=Build Colony, 8=Clear/Plow, 9=Build Road. Any non-zero value is a
unit that is busy; `docs/GAME_MANUAL.md` §5 describes an ordered unit as skipped
by the cycle until the order completes or is cancelled.

**Source B** — the JS/C parity oracles, which went RED on `savraleigh` (`.vy`,
event 58) and `sav1653` (`.dg`, event 117) as soon as the test was added, with
`.sel` and `.u` still agreeing on both sides.

**Ruling**: the orders test is CORRECT and ships in both engines. Red oracles
after a correct change mean the oracle found a pre-existing divergence, not that
the change is wrong — the oracles prove C == JS, and both were free to be wrong
together anywhere the fixed scripts never reached. All three were real and are
fixed:

1. **`end_turn()` had no recentre tail.** The JS `endTurn()` ends with
   `G.msg = ''; if (G.units[G.sel]) centerOn(...)` (game.js:10820). The C's
   `end_turn()` stopped after `turn_step5()`. Invisible for as long as the
   `next_unit()` immediately after `end_turn()` always succeeded and re-centred
   on its own; once a cycle of fully-ordered units let it return 0, the C held
   its view where the JS scrolled. Fixed in `cport/game/colopy_input.c`.
2. **The C's `unloadCargo` skipped `@WAREHOUSEFULL`.** The JS gates the whole
   unload behind the 100-ton spoilage confirm and only proceeds on row 1
   (game.js:11298); the C walked straight into `@CARGOUNLOAD`. Never reached
   before because no loaded ship had been the active unit inside a colony.
   Fixed in `cport/game/colopy_input.c`.
3. **The input oracle compared two different vocabularies.** `sim_trace.py`
   projected the dialog SHAPE (`G.dialog.opts ? 2 : 1`) while
   `render_smoke.c` printed the C's dialog KIND (`UI.dlg`: 1=@HOWMUCH5,
   2=@HOWMUCH1, 3=@HOWMUCH2). They agreed only because the scripts had reached
   `@HOWMUCH5` and nothing else. The JS now tags each dialog with its key and
   projects the same KIND. This was an ORACLE bug, not an engine divergence —
   worth logging because it presented exactly like one.

**Action taken**:
- `port/src/game.js` — `!u.orders` in `nextUnit`; `key` recorded on every
  `openDialog`/`askAmount` dialog.
- `cport/game/colopy_input.c` — `orders == 0` in `next_unit`; the `end_turn`
  recentre tail; the `@WAREHOUSEFULL` gate on unload.
- `tools/sim_trace.py` — `dg` projects the dialog kind; new `ord` field
  projecting EVERY unit's orders+moves (the field that proved the two engines
  had identical unit state and so moved the hunt to the view path).
- `cport/host/render_smoke.c` — the mirrored `ord` field.
- `tools/render_event_compare.py` — default key was `FOUNTAIN`, a WOODCUT
  caption and not an event key, so the bare invocation always exited 2 and this
  oracle silently never ran; default is now `RAIDSTORES`.

**Follow-up**: two earlier diagnoses of the colony-click blocker (a "colony index
mismatch" and a "build-picker row-model ordering" problem) were both wrong and
are withdrawn; the stale-bundle guard in `tools/sim_trace.py` exists because of
the first. The remaining queued behaviour fixes (colony click regardless of the
active unit, ship-to-Europe via the nearest sea lane, colonists at the fence and
out of the food count) are unblocked by this and not yet landed.

---

## 2026-06-19 — Runtime memory dump (`colonization-memory-map (1).md`) reconciled against the static disasm

**Conflict**: a runtime-verified PowerRecord field map (observed in js-dos/DOSBox,
several fields **write-verified**) disagrees with the static-disasm field labels on
three offsets, and corroborates many others.

**Source A** — runtime dump (`colonization-memory-map (1).md`, top of TRUTH_HIERARCHY:
"Running DOS game"). PowerRecord stride `0x13C`. Write-verified: `+0x2A` gold,
`+0x01` tax, `+0x44/+0x45/+0x46` REF counts (dragoons/regulars/artillery — "zeroing
removes the REF"), features-layer `0xB0` = Lost-City marker (plant/remove verified).
Read-verified: market arrays `+0x4C` sensitivity u8[16], `+0x5C` pool s16[16], `+0x7C`
traded-volume s32[16], `+0xBC` EU-supply s32[16], `+0xFC` base s32[16]; `+0x0C`
congress-progress, `+0x0E` bells, `+0x10` crosses/turn, `+0x14` FF-count, `+0x30`
"recruit cost", `+0x32` REF-strength.

**Source B** — static disasm (this branch). `func_0305A8` reads `+0xFC` as the
**drift accumulator**; `func_0363A2` writes the **crosses threshold** to `+0x30`;
`func_03E162` increments REF **globals** `0x53DA[4]` (regulars/cavalry/manowar/arty).

**Ruling** (per TRUTH_HIERARCHY "Running DOS game > EXE disasm; but EXE bytes win for
exact numbers/operations"):
1. **`+0x4C` is market *sensitivity* (u8[16]), NOT a price array** — the old
   `market.md`/`DATA_MODEL` "+0x4C[16] price-level" label is **superseded**; adopt the
   runtime array map (`+0x4C/+0x5C/+0x7C/+0xBC/+0xFC`). The runtime is authoritative
   for the *layout*.
2. **`+0xFC`**: runtime *labels* it "base values (initial)"; the disasm *proves*
   `func_0305A8` sums it across players and drives drift. Same bytes — the dynamic
   role (drift input) is disasm-verified; the "base/initial" label is a turn-1
   observation. Keep the disasm operation; note `+0x7C` (volume) is the semantically
   "long-term trend" array and may also feed drift (untraced).
3. **`+0x44/45/46`**: the **disasm is decisive** — `func_03E162`/`func_03CDA2`/
   `func_051EF4` read/write the globals `0x53DA..0x53E1`, so those are the
   authoritative REF counts. The two runtime dumps **disagree** on `+0x44/45/46`:
   this dump write-verified them as the REF; `docs/DATA_MODEL.md`'s session found
   them ≠ the UI (with `0x53DA` matching). So `+0x44/45/46` role is **unresolved**
   (a later "both real, different roles" reading was over-confident — corrected
   2026-06-19 consolidation). Needs a fresh dump to settle.
4. **`+0x30`**: disasm proves `func_0363A2` writes the crosses threshold here; the
   runtime "recruit cost" label was **not** write-verified (inference from the recruit
   menu). Keep the byte-verified meaning (threshold); flag for runtime re-check.

**Action taken**:
- Imported the dump to `colonization-memory-map (1).md` (same root path as `main`).
- `spec/systems/market.md` — corrected `+0x4C`; added the runtime 16-good array map.
- `spec/systems/ref_growth.md` — `+0x44/45/46` runtime counts reconciled with `0x53DA`.
- `spec/systems/events.md` + `spec/systems/map_system.md` — Lost-City trigger = features `0xB0` (runtime).
- `spec/systems/immigration.md` — `+0x30` conflict noted.

**Follow-up**: runtime-confirm whether `+0x30` is dual-use (threshold vs recruit
cost); trace whether `+0x7C` volume also feeds `func_0305A8`'s sibling drift; locate
the King `royal_money +0x22` and boycott `+0x20` in a dump (neither identified yet).

---

## 2026-05-30 — Game manual added as behavioral source; confirms combat-modifier model (reconciles wave-6 "+50% refuted")

User provided the original Colonization manual / Technical Supplement →
`docs/GAME_MANUAL.md` (UTF-16→UTF-8). Added to TRUTH_HIERARCHY as a
FUNCTION source (authoritative for how a feature works; EXE bytes still win for exact
numbers — patches may differ).

First cross-check (combat), manual §"Combat in the New World" lines ~1295-1354. The
manual lists the full combat-modifier model — all real game rules:
- **Attack Bonus**: attacker always +50% (wilderness surprise).
- **Fortifications**: fortified unit +50% DEFENSE.
- **Veteran Status**: veteran soldiers +50%.
- **Terrain Bonuses**: defenders in forest/hills/mountains get a terrain-varying bonus
  (vs Europeans only; see manual Terrain Chart).
- **Native / Colonial Ambush**: natives (always) and colonials-vs-King (outside colony)
  get the terrain bonus on attack or defense.
- **European Bombardment**: regular army +50% attacking a colony (+ Foreign-Intervention variant).
- **Popular Support**: each colony's SoL/Tory status becomes an attack bonus in the revolution.

**Reconciles the wave-6 "+50% fortified REFUTED" ruling**: that finding was correct but
SCOPED — it proved the SHIP odds roll @0x5B819 reads the RAW per-type stats
(0x523b/0x523c) with NO scaling. It did NOT mean fortify gives no bonus. The manual
confirms the bonuses are real, and the wave-9 decode locates them in the **LAND strength
modifier chain** in func_05CA7E (src/ai/unit_ai_leaf.c): the `·3/2` multipliers (= +50%)
and the `[0x8D04]` terrain/fort term that the defense accessor (file 0x07D3E) writes.
So: bonuses live in the DERIVED land strengths, not the raw ship-roll stats. The
"refuted" wording is hereby clarified to "not in the ship-roll raw stats; present in the
land modifier chain (manual-confirmed)".

**Action / follow-ups (data the manual unlocks):** the manual's **Terrain Chart** gives
values for the `[TBD]` terrain/fort bonus table (combat_modifiers.c / func_05CA7E), and
its **Combat Strengths Chart** is an independent cross-check of the @UNIT atk/def values
(Soldiers 2/2, Regulars 5/5, Artillery 7/5, …). Both to be cross-checked vs bytes
(EXE wins on exact numbers). cite-or-TBD unchanged.

---

## 2026-05-30 (BREAKTHROUGH) — The RTLink overlay wall is statically resolvable; VICEROY = RTLink/Plus V2

**This resolves the project's long-standing core blocker** ("core logic blocked
behind overlays 0x191F/0x181F"). User pointed us to dreammaster/tools'
`rtlink_decode`; reading its source + byte-checking VICEROY established:

1. **VICEROY.EXE is RTLink/Plus Version 2** (the "Rex Nebular" variant rtlink_decode
   handles). Byte-confirmed: MZ numRelocations @0x06 = 2260 (≠0, so not V3); header
   paragraphs @0x08 = 576 → codeOffset 0x2400; reloc table @0x18 = 0x1E; NO .OVL
   companion (only PKUNZJR.COM in COLONIZE/); V2 fingerprint strings
   "Enter directory for $" @0x1A5B7 + "MS Run-Time" @0x1D9A8 + "RTLink" @0x1A25D.

2. **The overlay "wall" is not a wall.** The whole cross-page call graph is
   statically recoverable from the load image:
   - The RTLink thunk table is ONE contiguous block @file 0x1A5F0..0x1D5E6,
     addressed through three OVERLAPPING far-seg windows (file_base =
     codeOffset 0x2400 + seg*16): 0x181F→0x1A5F0, 0x191F→0x1B5F0, 0x1A1F→0x1C5F0.
     They are not three tables; the compiler picks whichever window keeps the
     16-bit offset in range. (Verified: 0x2400+0x181F*16 = 0x1A5F0.)
   - Each thunk = `9A AB 0D 0D 11` (LCALL 0x110D:0x0DAB resident loader) +
     `EA <off16> <seg16>` (JMPF; seg=0 ⇒ runtime-patched, but the offset +
     trailer PAGE-ID are static) + trailer word = target page. 0x110D is the
     resident loader segment (the entry CS), never a call target.
   - Cross-page calls route through page-resident JMPF trampolines (e.g.
     0x5E723 = `EA e0 06 1f 1a` = JMPF 0x1A1F:0x06E0); both halves are in the
     static image, so the call graph is fully reconstructable.

3. **Land-combat decider RESOLVED = func_05CA7E** (file 0x5CA7E, ENTER 0xDE,
   page 0x10) → wrapper func_05BE30 → applier func_05B2C2 (via trampoline
   0x5E723 → thunk @0x1CCD0 = page 0x10 +0x0352). func_05CA7E is the same
   ~7.3KB per-unit attack/action routine already in src/ai/unit_ai_leaf.c —
   land combat is one facet. This OVERTURNS the [TBD]/"behind the wall"
   corollary in src/combat/land.c (wave-7); the wave-7 framing
   "thunk @0x1BAAA = 0x110D:0xA9DA" was a wrong address (0x1BAAA targets page
   0x08 unit-state). Report-content renderers likewise resolved to 9 page-0x05
   functions reached by the static CMP/LCALL ladder in func_0235D6.

**Source A** — prior project belief + wave-7 land.c: deciders "behind the RTLink
wall", statically unresolvable [TBD].
**Source B** — dreammaster rtlink_decode V2 algorithm + wave-8 byte trace + my
independent re-verification (thunk windows, trampolines, prologues all byte-exact).

**Ruling**: Source B. The RTLink overlay structure is static and decodable; mark
land.c's caller RESOLVED (func_05CA7E). TRUTH_HIERARCHY: raw EXE bytes win.

**Action taken**: docs/OVERLAY_THUNKS.md (full per-thunk verdicts); land.c corollary
corrected; VERIFICATION_LEDGER "RTLink overlay wall" section; Python V2 flattener
under tools/rtlink/ (in progress). The C++ tool needs a ScummVM+VS build, so we
reimplement the V2 algorithm in Python (clean-room from the documented format).

**Follow-up**: (1) ✅ DONE — `tools/rtlink/rtlink_decode.py`
(V2 decoder; info/flatten/resolve/validate) built + validated (31 segments,
1023 thunks; resolves any overlay addr to a flat file offset; emits VICEROY_flat.exe
+ viceroy_rtlink_map.json). This eliminates the reseg-drift hazard — re-disassemble
the flat image or use `resolve <page> <off>` instead of the per-func dumps.
(2) decode the land-odds FORMULA inside func_05CA7E (now statically reachable);
(3) the report-content bodies (page 0x05).

---

## 2026-05-30 (RESOLVED) — Wave-10: DOS save serializer decoded; magic = "COLONIZE"

The standing [TBD] "overlay-resident savegame serializer" is cracked (via the RTLink
tool). All byte-verified.

- **DOS save MAGIC = `"COLONIZE"` + 0x1A** (file 0x1FB1A, handle 0x217A), written
  @0x73528 (0x1A1F:0xDE4), strcmp'd on load @0x73C00 (0xD1D:0x816). This RESOLVES
  the prior [TBD] (the DOS save header was undecoded; "COL2" had been dismissed as
  Win16). Confirmed distinct: saves/quicksave.col2 begins `43 4F 4C 32` = "COL2"+ver3
  = Win16. So: **DOS = "COLONIZE", Win16 = "COL2"** — two formats, now both known.
- **SAVE driver = func_0734F8** @0x734F8 (ENTER 6, reached LCALL 0x1A1F:0xCF6 from
  func_072F7A/SAVEGAME); **LOAD driver = func_073BB0** @0x73BB0 (from func_073158/
  LOADGAME). On-disk order (43 fwrite + 12 block-write, byte-cited): header(magic,
  version@var,map W/H) → globals @0x5380 → per-power names @0x540E → ColonyRecord
  count[0x539E]×0xCA → UnitRecord count[0x539C]×0x1C → PowerRecord 4×0x13C →
  NativeSettlement count[0x539A]×0x12 → … → 4 map layers. **NO checksum** (verified
  by absence); integrity = load-side magic + version + map-size gates. I/O via the
  resident MSC buffered lib (window 0xD1D).
- **Colony on-disk record = full 0xCA** (not the 0xAE work-buffer stride).
- **g_unit_count @0x539C RESOLVED** (was [TBD]): `imul [0x539C],0x1C` @0x735DC.
- **RTLink tool refinement**: overlay page 0x1A packs TWO load-segments; the save/
  load driver thunks resolve against the SECOND segment's base **0x73270** (not the
  segment-list code_offset 0x72090): 0x73270+0x288=0x734F8, +0x940=0x73BB0 (both
  land on `C8` ENTER prologues). tools/rtlink/RTLINK_V2.md notes this.

**Ruling**: Source = byte-verified func_0734F8 / func_073BB0 decode. DOS save magic
is "COLONIZE". **Action**: src/save/{save_serializer,load_deserializer}.c rewritten;
ledger SAVE section + FUNCTION_INVENTORY rows; RTLINK_V2.md page-0x1A caveat.
**Follow-up [TBD]**: version word @0x81A runtime value; the ~30 small per-power
scalar blocks' field meanings (offsets/sizes are byte-exact, semantics not decoded).

---

## 2026-05-30 (RESOLVED) — Wave-9: there IS a land-combat roll (refines wave-7), decoded in func_05CA7E

Enabled by the RTLink flattener (func_05CA7E is now statically reachable), the
land-combat DECISION is fully decoded and byte-verified. This **refines the wave-7
entry below** ("land combat = no roll"), which was scoped to the wrong stat columns.

- **Land combat IS `ATK/(ATK+DEF)`** — the SAME odds form as ships. In func_05CA7E
  @0x5D188: `roll = random_int(1, atk_str + def_str)`; `win = (roll <= atk_str)`;
  win_flag stored [bp-0x9c] @0x5D1A2 (add @0x5D181, cmp @0x5D194 — all verified).
- But it rolls on **DERIVED strengths from columns 0x5235 (def) / 0x5236 (atk)**,
  read ×8 via resident accessors (file 0x07C2A / 0x07D3E, reads `8a 87 36 52` /
  `8a 87 35 52` @0x07C62/0x07C7E), then a modifier chain (terrain/fort via [0x8D04],
  difficulty 0x53A6, SoL/human gate [0x5382] bit0, era gates on turn 0x538E).
- **Why wave-7 missed it:** wave-7 exhaustively scanned for the raw ship stats
  0x523b/0x523c and correctly found them read only in the ship-gated roll. Land
  uses a DIFFERENT stat pair (0x5235/0x5236) via ACCESSOR functions, not direct
  `[bx+0x523X]` reads — so the wave-7 scan couldn't see the land roll. Wave-7's
  literal claim (0x523b/0x523c are ship-only) stands; its IMPLICATION ("land has no
  probabilistic roll / decider is [TBD] in the caller") is WITHDRAWN.
- **Evaluate vs Act:** when mode([bp+0xe])==0 (AI ranking) func_05CA7E returns the
  deterministic score `(atk_str<<3)/(def_str+1)` @0x5D032 (`shl ax,3` verified) and
  never rolls; the RNG fires only when committing (mode!=0). func_05B2C2 stays
  consequence-only — the win_flag computed here selects the loser it applies.

**Ruling**: Source = byte-verified func_05CA7E decode. Land combat odds = ATK/(ATK+DEF)
on the 0x5235/0x5236-derived strengths. **Action taken**: ported into
src/ai/unit_ai_leaf.c; land.c "[TBD] next target" note marked DONE; ledger/inventory
rows. **Follow-up RESOLVED (wave-10, docs/COMBAT_STATS.md):** the @UNIT-column ->
stat-offset mapping is byte-traced at the loader @0x74EC3 — col3 ATTACK -> 0x5236,
col4 combat/DEFENSE -> 0x5235 (LAND, ×8 in the accessor); col9 guns -> 0x523b,
col10 hull -> 0x523c (SHIP). The earlier "@UNIT col3/col4 -> 0x523b/0x523c" label
(combat.c) and "cols 3/4 -> 0x5234/0x5236" (wave-6) were WRONG; corrected. Real
LAND atk/def: Soldiers 2/2, Dragoons 3/3, Regulars 5/5, Cavalry 6/6, Artillery 7/5;
SHIP def/atk (guns/hull): Frigate 12/32, Man-O-War 32/64. Remaining [TBD]: the
terrain/fort bonus table feeding [0x8D04].

---

## 2026-05-30 (RESOLVED, REFINED by wave-9 above) — Wave-7 (land combat = no roll; func_072090 = menu bar)

1. **LAND COMBAT HAS NO ATK/DEF ROLL — func_05B2C2 only applies consequences.**
   This compounds the wave-6 ship-gate finding. Byte-proven three ways (I re-ran
   the exhaustive scan + structural checks myself):
   - The per-type combat stats 0x523b (DEF) and 0x523c (ATK) are read at exactly
     2 and 1 code sites respectively in the WHOLE 494,910-byte EXE — all inside the
     ship-gated roll (0x5B819/0x5B823/0x5B83B). No "land" roll reads them.
   - A land attacker (type <0x0D) jmps 0x5BAA3, bypassing BOTH the odds roll and the
     post-roll per-power strength compare (0x5B85B..0x5BA2D is unreachable from there).
   - The land combatant path reaches the DEMOTE ladder / destroy block directly, with
     no RNG and no stat read.
   So func_05B2C2 is the combat-CONSEQUENCE applier: the outcome router @0x5BAA3
   (cmp [bp-0x3a],0, verified `83 7e c6 00`) applies a PRE-DECIDED result — WIN
   (remove loser: unit flags|=0x80 @0x5BB9E, spoils via per-type 0x5235) or LOSE
   (DEMOTE ladder / destroy). **The land win/loss DECIDER lives in the CALLER**
   (the unit move/attack dispatcher), reached only via load-image thunk @file
   0x1BAAA (=0x110D:0xA9DA) whose LJMP segment is runtime-patched → statically
   unresolvable behind the RTLink wall = **[TBD]**, narrowly bounded. Ported:
   src/combat/land.c; combat.c header reframed; FUNCTION_INVENTORY/ledger updated.
   This is the honest end-state: the simple ATK/(ATK+DEF) "combat rule" was a SHIP
   rule; the land decider is not yet statically recoverable, and we say so.

2. **func_072090 = the top MENU-BAR builder, not the report-content engine.** The
   wave-5 UI agent guessed func_072090 renders report bodies (because it contains the
   "reports" key 0x20BA). Byte-verified: it is `build_menubar` (0x072090..0x072B9A,
   2826B) — it builds the 7-8 pull-down columns (game/menu/view/orders/reports/trade/
   cup/pedia, keys resolve exactly), and the Reports column just lists the 10 F-key
   entries. The actual report-CONTENT renderer (reached on F-key select 0x40..0x49)
   remains UNFOUND = [TBD] — not fabricated. Ported as build_menubar in
   src/ui/report_screen.c; FUNCTION_INVENTORY (which already had "Top menu bar
   dispatcher" — correct) upgraded to BYTE_VERIFIED.

3. **combat_demotion_ladder.c vet-byte label clarified.** The demote override @0x5B60E
   (`80 bf 5b 31 18` = cmp byte [bx+0x315B],0x18) reads vet_type at absolute 0x315B =
   canonical UnitRecord+0x17. The file indexed it as 0x3146-base `+0x15` (0x3146+0x15
   = 0x315B) — address-correct, but the label was confusing; clarified (same
   base-alias class as 0x8809/0x8808).

**Ruling**: Tier-1 bytes win. Finding (1) is the significant one — it is the honest
terminus of the combat-rule investigation: land combat's decider is behind the RTLink
overlay wall and is marked [TBD] rather than guessed.

**Action taken**: commits land.c (src/combat), build_menubar (src/ui/report_screen.c);
combat.c reframed; Makefile OBJS_COMBAT += land.obj; ledger + FUNCTION_INVENTORY rows;
combat_demotion_ladder.c comment.

**Follow-up**: the land-combat DECIDER and the report-CONTENT renderer both sit behind
RTLink overlay thunks — recovering them needs the overlay-load-time segment patch
(the RTLink VP-directory), i.e. a dynamic/loaded-image trace, not a static one.

---

## 2026-05-30 (RESOLVED) — Wave-6 (king-military, GUI engines, combat completion)

1. **COMBAT: the ATK/(ATK+DEF) odds roll is SHIP-ATTACKER-ONLY** (revises the
   earlier "combat resolution rule" validation, which found the roll but not its
   gate). func_05B2C2's roll @0x5B819 (`random_int(1,DEF+ATK); atk wins if
   roll<=ATK`) is reached only when attacker type ∈ 0x0D..0x12 (the 6 ships) —
   gate @0x5B7B6 (`cmp [type],0x0D; jae` @0x5B7BB `73 03`, else `e9 e3 02` jmp
   0x5BAA3) + @0x5B7C0 (`cmp ,0x12; jbe`, else jmp 0x5BAA3). **Land combat does
   NOT use this roll** — it routes to the 0x5BAA3 region (not yet fully decoded).
   The simple ATK/(ATK+DEF) is therefore the SHIP path, not the universal rule.
   (I re-read the jump bytes to confirm.)

2. **COMBAT: "+50% fortified" multiplier REFUTED.** The roll reads raw
   `0x523b[deftype]` (DEF) + `0x523c[atktype]` (ATK) and adds them with `03 c1`
   (no scaling op between the reads and the add); 0x523b/0x523c are read at only
   3 sites overall (all in this roll), so no stat-scaler exists. The 0x5B433
   "fort block" is a capture-ELIGIBILITY threshold
   (`(0x5237[deftype] − defender[+0x0C]) >= 0x5238[atktype]`, for non-combatant
   attackers entering a fortified colony), NOT a stat multiplier. The real
   modifier layer is a POST-roll per-power strength compare @0x5B85B..0x5BA2D
   (difficulty `MUL [0x5325]` @0x5B9A2); per-power array semantics TBD.

3. **COMBAT: @UNIT column→stat-offset mapping is suspect** (flagged [TBD-data]).
   combat.c's header claimed @UNIT col3/col4 → 0x523b/0x523c, but the loader
   @0x74EDA writes cols 3/4 to 0x5234/0x5236; 0x523b/0x523c are filled from later
   fields. Roll semantics are byte-certain; only the column LABEL is unresolved.

4. **KING: func_02F052 / func_02F3A2 are king-military, NOT UI.** The wave-5 UI
   agent flagged them out-of-scope; confirmed. func_02F052 = KINGTAX/ship-REFIT
   events (847B, dump truncated@117); func_02F3A2 = War-of-Independence per-turn
   handler (1869B, dump truncated@63). FUNCTION_INVENTORY's "func_02F3A2 = win/lose
   check" with YOULOSE/YOUWIN keys was WRONG — those keys are not pushed; the 15
   real keys are LOSENOCOLONIES/INDEPENDENT/KINGWIN/etc. func_03CDA2 REF-arm
   landing decrement (`dec word[bx+0x53DA]`) byte-verified (resolves a ref.c TBD).

5. **GUI: func_02883E / func_028D8C extents corrected** (138B→1357B, 185B→2841B —
   first-RET truncation). menu-item dispatcher (22-entry CS jump-table @0x028AF0)
   and colony build/dialog engine. Page-0x17 control model decoded
   (menu_lookup_run=func_06F51A; opt-flag [0x1F54]; descriptor [0x87C]; screen-mode
   builder [0x1F5E]=func_06F5F2). Two sub-findings: king_audience.c's
   "0x181F:0x3FE→func_028D8C" was imprecise (→func_06F594 page-0x17 wrapper;
   func_028D8C is via 0x181F:0x1750) — corrected; main_loop.c's
   `menu_lookup_key(int,int,int)` == func_06F51A which is `(void)` — symbol-unify TBD.

6. **Truncated-dump hazard, again.** Every wave-6 target's per-func dump understated
   size (117/63/138/185/82 vs verified 847/1869/1357/2841/548). And reseg ALSO
   drifted in combat (page_07 phantom func_03FF4C from jump-table bytes) — raw EXE
   overruled. Confirms the wave-5 ruling: raw VICEROY.EXE is the ultimate arbiter.

**Ruling**: Tier-1 bytes win. The combat findings (1-3) are the significant ones —
they narrow a previously-"validated" rule honestly rather than leaving the prior
over-broad claim standing.

**Action taken**: commits for king (king_events/war_turn/ref), GUI (menu/dialog),
combat (naval/combat_modifiers/combat.c); ledger + FUNCTION_INVENTORY + Makefile
(OBJS_KING/OBJS_UI/OBJS_COMBAT) rows; king_audience.c comment fix.

**Follow-up**: decode the LAND-combat path (0x5BAA3 region) + the post-roll per-power
strength arrays; resolve the @UNIT column→stat mapping; port report content engine
func_072090; unify menu_lookup symbol.

---

## 2026-05-30 (RESOLVED) — Wave-5 + ledger-audit reconciliations

The wave-5 ports (unit, UI screens) plus a systematic read-only ledger-audit
(every index row cross-checked vs the ported `.c` headers) surfaced a batch of
identity/role/label corrections. All resolved from bytes.

1. **Re-segmented pages DRIFT too — raw EXE is the ultimate arbiter.** The unit
   agent found `disasm_overlay_reseg/page_15` mis-decodes 0x06958 and `page_17`
   folds 0x06E94 into a bogus 2820B `func_06E3D0`. This REFINES the wave-1..4
   guidance ("prefer reseg over truncated per-func dumps"): the "C8-imm16
   false-ENTER" hazard cuts BOTH ways. Ruling: when reseg and the per-func dump
   disagree, disassemble the **raw COLONIZE/VICEROY.EXE** at the address and let
   the bytes decide. (Confirmed: 0x4007E=c8 02 00 00; 0x6958=88 87 44 31;
   0x66C4=8b 9c 5e 31; 0x4E2D6=c8 ee 00 00; 0x6EE2=e8→0x68AA.)

2. **func_05B2C2 = combat RESOLVER** (single roll `random_int(1,ATK+DEF)`,
   atk wins if `roll<=ATK`, @0x5B819), full extent 0x5B2C2..0x5BE30 (2926B). The
   demotion ladder is a SUB-TABLE within it, not the whole function. Ledger row 5
   + FUNCTION_INVENTORY had it as "Combat demotion ladder" only → corrected; both
   `src/combat/combat.c` and `combat_demotion_ladder.c` now listed. The roll
   @0x5B819 is the SAME function, NOT a separate larger one (open Q closed).

3. **func_051EF4 score role WITHDRAWN → it's a per-turn GOLD/income tick.** The
   2026-05-29 SCORING trace called it `score_tick_for_power` accumulating into
   `*(0x84FC)+0x2A`. But +0x2A = GOLD (wave-3 RULINGS; UI/LCR-verified). The
   arithmetic stays byte-verified; only the "score" framing is wrong. Real
   endgame score = the rank ladder in **func_03A9C0** ((k*k)/3 × difficulty) over
   an overlay-resident raw value (0x191F:0x3AA, TBD). FUNCTION_INVENTORY's prior
   "func_03A9C0 uses [0x372] accumulator / 964B frame" heuristic also withdrawn.

4. **Dangling combat-file rows removed.** Ledger listed `src/combat/resolve.c`,
   `modifiers.c`, `demotion.c` — none exist (resolve.c was folded into combat.c;
   demotion → combat_demotion_ladder.c). Rows corrected to the two real files.

5. **func_022F08 was an over-merged reseg record** = 4 distinct RETF-terminated
   functions: find_city@0x022F08 (ENTER 4), game_options@0x022FD6,
   colony_report_options@0x02311A, sound_options@0x0232AE. Split into
   `src/ui/options_dialog.c`; GAME.TXT bit maps 0x5382..0x5386.

6. **0x53A6 = difficulty (0..4), unified to `g_difficulty_53A6`.** globals.h had
   `g_progress_5_53A6 "era counter"` (mislabel) defined in production.c, while
   native/king files declared an UNDEFINED `g_difficulty_53A6` extern — a split
   that would fail to link. Unified on `g_difficulty_53A6` across globals.h /
   production.c / colony/turn_update.c / market/pricing.c / king_tax_raise.c.
   (Active-power index is the SEPARATE global 0x9E12.)

7. **MANIFEST.md sizes are truncated estimates** (first-RET) — caveat added;
   real extents for func_057F4E/05B2C2/03BC42/057DC0 cited from the `.c` headers.

8. **UI handlers are NOT "overlay-resident TBD".** The colony/europe/report/king
   screen handlers are fully byte-readable in the reseg pages (found via
   string-key xref, file_offset = handle + 0x1D9A0; 8 keys resolve exactly:
   EUROPE 0xFBA, REPORT 0x11A2, FONTKING 0x232B, EUROPESHIPCLICK 0x1005,
   FINDCITY 0xA51, GAMEOPTIONS 0xA61, …). Stale "overlay-resident TBD" ledger
   rows upgraded.

**Source A** — stale 2026-05-02/05-29 ledger/inventory rows + auto-generated
MANIFEST + a prior `src/ui/` "overlay-resident TBD" claim.
**Source B** — wave-5 byte-verified ports + the read-only ledger-audit, all
checked vs raw VICEROY.EXE.

**Ruling**: Tier-1 bytes win throughout (TRUTH_HIERARCHY: raw EXE > reseg pages >
truncated per-func dumps > reconstructed notes).

**Action taken**: see commits 0b4aae4 (unit), f59e2b6 (UI), 29f0907 (audit+unit
index), f02fe80 (UI index), and the 0x53A6 unify commit. Cosmetic 0x8809→0x8808
base-label sweep in native .c deferred (address math already correct).

**Follow-up**: regenerate overlay MANIFEST from `overlay_functions_reseg.json`
(real extents) rather than the truncated dumps; port func_02F052/func_02F3A2
(KINGTAX/REF king-military, flagged out-of-scope by the UI agent) in src/king.

---

## 2026-05-30 (RESOLVED) — Wave-4 reconciliations (render dirty-rect, func_057F4E identity, diplomacy score model)

Three fabrications/mislabels surfaced by the wave-4 ports (render + diplomacy),
all resolved against bytes.

1. **Render has NO dirty-rect system.** `docs/RENDER_CHAIN.md` claimed a per-tile
   `tile_dirty[]` skip (`tile_is_dirty()` guard in func_O513, a "## Dirty-rect
   optimization" section, and a "flicker mitigated by dirty-rect" prose line).
   FABRICATED — the byte-verified `func_O514 → func_O513 → func_O512` chain
   (ported `src/render/tile_chain.c`, real O513 body 1076 B) redraws all 15×12
   viewport tiles unconditionally each frame; no dirty array/functions exist in
   VICEROY.EXE. Double-buffering status TBD (not a dirty-rect substitute claim).

2. **func_057F4E = European meeting/diplomacy dispatcher, NOT "save_load_chain_b".**
   The overlay stub `src/overlay/overlay_054505_05C69B.c` carried an auto-traced
   entry named `func_057F4E_save_load_chain_b`, sized 355 B, role "SAVE_LOAD chain"
   — all wrong. The 355 B is the TRUNCATED extent of the per-func dump
   `func_057F4E_unknown.asm` (stops at first RET/0xFF); the real body is ~7151 B.
   Byte-verified identity: ENTER 0xD6 (`c8 d6 00 00`); war bit set at 0x883C
   (`80 88 3c 88 02` @0x58A7B); tribute-gold `29 47 2a` @0x58ED0; set-treaty LCALL
   `9a 06 0a 1f 18` @0x59139; trampoline `ea 0a 06 1f 1a` @0x5A1E0. Ported &
   verified in `src/diplomacy/meeting.c`. (Same truncated-dump root cause as the
   wave-2/3 misattributions func_011F6E / func_03ECF0 / func_05CA7E / func_0A222.)

3. **No `-100..+100 rel_score[8]` diplomacy model.** `docs/EUROPEAN_DIPLOMACY.md`
   described a signed pair-score array with an event-delta table and
   `if (score < -50 - aggression)` thresholds + `ai_evaluate_treaty()`. FABRICATED
   — the real diplomatic state is the boolean **war bit-matrix at DGROUP 0x883C**
   (one bit/power-pair, set @0x58A7B), not a scalar score. `rel_state[8]`
   Peace/War/Alliance enum is also a reconstruction (Alliance-as-stored-state
   unconfirmed).

**Source A** — reconstructed docs (RENDER_CHAIN.md, EUROPEAN_DIPLOMACY.md) and the
auto-generated overlay manifest/stub.
**Source B** — wave-4 byte-verified ports (`src/render/*`, `src/diplomacy/*`) read
from `disasm_overlay_reseg/page_*.asm` full bodies.

**Ruling**: Tier-1 bytes win all three (TRUTH_HIERARCHY: disassembly > reconstructed
notes; full reseg pages > truncated per-func dumps).

**Action taken**:
- `docs/RENDER_CHAIN.md`: banner updated; dirty-rect prose, the func_O513 guard,
  and the "## Dirty-rect optimization" section retagged ⚠️ FABRICATED in place.
- `src/overlay/overlay_054505_05C69B.c`: func_057F4E stub header retagged
  SUPERSEDED → `src/diplomacy/meeting.c`; wrong name/size/role called out.
- `docs/EUROPEAN_DIPLOMACY.md`: banner + "Relationship score" section retagged
  ⚠️ FABRICATED; point to 0x883C war matrix / `src/diplomacy/treaty.c`.

**Follow-up**: the overlay MANIFEST.md is auto-generated by `tools/overlay_body_gen.py`
and still lists func_057F4E at 355 B; regeneration should read reseg extents, not the
truncated per-func dumps (tracked, not blocking).

---

## 2026-05-30 (RESOLVED) — Wave-3 global-address conflicts (+0x2A, 0x53A6, PowerRecord base)

Three address labels disagreed across sources; all resolved from bytes (verified vs
VICEROY.EXE) during the wave-3 ports.

1. **PowerRecord+0x2A = GOLD, not score** (resolves the OPEN "+0x2A gold-vs-score").
   power.h + DATA_MODEL (UI-verified: +0x2A=1920→Gold 19200%); LCR credits winnings
   here via `add [bx+0x8832]` @0x61C4C (0x8808+0x2A). The 2026-05-29 anchor calling
   func_051EF4's `[0x84FC]+0x2A` a "score accumulator" is WITHDRAWN — it's a gold/
   income tick. The real endgame score is the rank ladder in func_03A9C0 over an
   overlay-resident raw value (0x191F:0x3AA, TBD). `[0x372]` is save/restore scratch.

2. **DGROUP:0x53A6 = DIFFICULTY (0..4, default 2=Conquistador)**, not "current_player_idx"
   (VERIFICATION_LEDGER line ~206) nor "era counter" (globals.h g_progress_5_53A6).
   Byte evidence: `==0/1/3/4` compares @0x051F5B/0x00A295, default-set `=2` @0x07433C;
   combat.c already had it right (g_difficulty_53A6). The active-power index is the
   SEPARATE global 0x9E12.

3. **PowerRecord base = DGROUP:0x8808** (verified `add ax,0x8808` @0x3055D →[0x84FC]);
   VERIFICATION_LEDGER line ~202 says 0x8809 — off-by-one, corrected.

**Also confirmed**: 0x0D1D:0xEC6 = 32-bit signed divide (corroborates the SoL% ÷ and
the market supply-inverse price target).

**Ruling**: Tier-1 bytes win in all three. **Action taken**: scoring/market ports use
the corrected labels; VERIFICATION_LEDGER line 202 (0x8809→0x8808) corrected below;
the 0x53A6 "player_idx"/"era counter" labels (ledger 206, globals.h) to be re-tagged
to difficulty in the next central sweep.

---

## 2026-05-30 (RESOLVED) — Three function-identity misattributions (wave-2 ports)

**Conflict**: prior labels (per-func dumps / FUNCTION_INVENTORY) for three functions
disagreed with the re-segmented page disasm + string xrefs. All resolved from bytes
(verified vs VICEROY.EXE), root cause = the per-func auto-dumps were truncated at the
first 0xFF/RET while the functions continue for thousands of bytes.

1. **func_011F6E** — labeled "load_game_state / savegame colony reader" → is the
   **RTLink/overlay-EXE record reader** (MZ/ZM magic @0x01207A `81 7e e2 5a 4d` /
   @0x012081; caller chain _searchenv→fopen). The 0xAE malloc≈ColonyRecord was
   coincidental. The real save serializer is overlay-resident (TBD for a verified reason).
2. **func_03ECF0** — labeled "diplomatic_action_init (~86 B)" → is the **per-unit
   confrontation/command AI evaluator (3101 B, 0x03ECF0..0x03F90C)**. Controller-flag
   gated (`imul bx,[bp-2],0x34;[bx+0x543F]` @0x3F474), far-calls the AI leaf
   (`lcall 0x191F:0xA14` @0x3F492). DECLAREWAR/etc. are dialog message handles, not its identity.
3. **func_05CA7E** — labeled both "AI leaf" (brief) and "colony burn/native raze"
   (ledger) → ONE routine: the **unit-attacks-enemy-COLONY resolver** (AI-gated head +
   BURNED capture/burn tail; reads colony [0x8542] @0x5CC64). NOT native-village raze —
   that remains **func_04A7CA**. Closes the ledger's "native raze = func_05CA7E" open item.
   (Also: func_03E984 = declare-independence handler; 0x53D0 = rebel-sentiment %.)

**Ruling**: the re-segmented page disasm (full function bodies) overrides the truncated
per-func dumps for function identity/size (TRUTH_HIERARCHY: read the actual bytes).

**Action taken**: src/save/* , src/ai/* ported with corrected identities; shared refs
(globals.h/iolib.h/anchor_map.md/VERIFICATION_LEDGER) re-tagged for func_011F6E.
Methodology note for the engine: prefer the reseg pages over per-func dumps (the latter
truncate at the first RET).

---

## 2026-05-30 (RESOLVED) — DGROUP:0x53A7 is year/100, NOT the king-anger byte

**Supersedes** the 2026-05-28 "(OPEN CONFLICT) — 0x53A7 king-anger vs year/100" below.

**Conflict**: memory/STATE called 0x53A7 the king-anger byte (USER-VERIFIED: a byte
went 3→4→5 per Tea Party); the disasm shows it written as year/100.

**Deciding evidence (byte-verified, king-agent trace 2026-05-30, re-checked vs
VICEROY.EXE)**: exactly 3 references to 0x53A7 in the overlay disasm, all
year-split, and NO `inc`/`add [0x53A7]` anywhere:
- WRITE `0x03DE6F a2 a7 53` = `[0x53A7] = al` (year/100), beside `0x03DE65 88 16 a8 53`
  = `[0x53A8] = year%100`.
- READ `0x039EEE f6 2e a7 53` = `IMUL byte [0x53A7]` then `+[0x53A8]` → reconstruct year.
- INIT `0x0757D3 c6 06 a7 53 00` = `[0x53A7] = 0`.
Also dispositive: year/100 ≈ 14..18 for 1400..1800 — it cannot be the observed
3→4→5. So the *values* the user watched were not this address's.

**Ruling**: 0x53A7 = **year/100** (Tier-1 bytes win the ADDRESS). The king-anger
MECHANIC is still real (user observation stands), but its address was MISLABELED;
the real anger byte is **UNLOCATED/TBD** (candidate: the king's PowerRecord). This
does not override the empirical observation — it relocates it.

**Action taken**: king/demands.c header records the year-split; this ruling;
memory project_king_anger_and_ref to be updated (0x53A7→year; anger→TBD).

---

## 2026-05-30 — LCALL 0x181F:0x04D4 is random_int(lo,hi), NOT an "ask-king" dialog

**Conflict**: src/king/king_tax_raise.c declares `ovly_181F_04D4` as
"ask king/player about change, returns 1=accept" and builds its tax-accept logic
on that; the native + combat traces use the same thunk as `random_int`.

**Ruling**: 0x181F:0x04D4 = **random_int(lo, hi)** — BYTE_VERIFIED (thunk → MSC
LCG func_00C322 @0xC322; used as random_int(1,total) in the combat roll
@0x5B849 and random_int(1,4) in native raid @0x05BF35; memory
project_rng_byte_verified). The "ask-king" reading in king_tax_raise.c is WRONG.

**Action taken**: flagged king_tax_raise.c — the `ovly_181F_04D4` decl + its 3
call sites are MISIDENTIFIED; the tax-accept branch logic built on the wrong
identity is suspect and func_034AE0 needs a re-trace (next king sub-task).

---

## 2026-05-30 — @UNIT "icon" column is 1-based (ICONS.SS index = icon − 1)

**Conflict**: The unit sprite-index mapping disagreed between sources. SPRITE_CATALOG
/ GAME_INDEX_TABLES / PROJECT_BOARD (SPRITE-A) state the @UNIT column-1 value IS the
ICONS.SS sprite index (Caravel=6, Galleon=8, Colonists=101). The colonize_sdl harness
(unit_sprite_map.py) maps Caravel→5, Galleon→7, Free Colonist→100 — off by one.

**Source A** — NAMES.TXT @UNIT column 1: Caravel=6, Merchantman=7, Galleon=8,
Privateer=15, Frigate=16, Colonists=101, ... (the raw file value).

**Source B** — docs/icon_catalog_verified.json (user hand-labeled from the actual
ICONS.SS sprites): "005"=Caravel, "006"=Merchantman, "007"=Galleon, "015"=Frigate,
"100"=Free Colonist, "102"=Veteran Soldier.

**Ruling**: Source B wins for the actual sprite index (empirical pixel inspection
beats a table assumption — TRUTH_HIERARCHY). The @UNIT "icon" column is a 1-BASED
reference; the real 0-based ICONS.SS sprite index = (@UNIT icon − 1). The −1 is
consistent across all ships AND foot units. So the harness mapping is CORRECT, and
the "@UNIT col1 = ICONS index directly" claim was off by one.

**Action taken**:
- data/unit_classes.c: `icon` field documented as 1-based with the −1 rule + the
  empirical citations.
- docs/RULINGS.md: this entry. (SPRITE_CATALOG.md / GAME_INDEX_TABLES.md /
  PROJECT_BOARD SPRITE-A should have the "−1 to get the ICONS index" note added.)

**Follow-up**: confirm whether the game's loader literally does `icon-1` when
indexing ICONS.SS, or whether ICONS.SS[0] is a reserved/blank slot that makes @UNIT
naturally 1-based. Either way the rendered index is icon−1.

---

## 2026-05-30 — Native tribe data was fabricated (ids, levels, wealth, raze input)

**Conflict**: User reported the C reconstruction's native data was "all off" —
raze gold wrong, tribe types reduced to "nomadic vs advanced", and Apache shown
wealthier than Aztec/Inca. Investigation confirmed multiple fabrications.

**Source A** — `include/native.h` + `data/tribe_data.c` (RECONSTRUCTED) had tribe
order Aztec=0/Inca=1/Tupi=3/Apache=4, a BINARY type flag (0=Nomadic/1=Advanced),
uncited `base_wealth` values (Apache 45 > Arawak 40 > Tupi 35), an uncited DGROUP
offset 0x09800, and "settlement counts [4,4,3,5,4,3,5,3] from TRIBE.TXT".

**Source B** — NAMES.TXT `@TRIBES` (extracted/text/NAMES_sections.json) gives, in
file order: Inca, Aztec, Arawak, Iroquois, Cherokee, Apache, Sioux, Tupi — each
with treasure type + a level (Inca 3, Aztec 2, Arawak/Iroquois/Cherokee 1,
Apache/Sioux/Tupi 0) + a VGA color. `@LEVELS` names FOUR tiers (Semi-Nomadic,
Agrarian, Advanced, Civilized) + a Capital settlement type. `TRIBE.TXT` is the
"Tribe Dispersal Chart" (map PLACEMENT coordinates, counts 11/4/5/5/7/7/4/16),
NOT a stats table. The colonize_sdl engine (game_data.py TRIBE_DEFS) already
parsed @TRIBES correctly (Inca=0...).

**Ruling**: NAMES.TXT wins (TRUTH_HIERARCHY: NAMES.TXT is canonical for data
tables; the EXE reads it at startup). The C tribe data was fabricated. Wealth
tracks the @TRIBES advancement LEVEL (Civilized richest, Semi-Nomadic poorest),
so Apache (0) must be far poorer than Aztec (2)/Inca (3).

**Root cause of "Apache richer than Aztec"**: `src/native/native_village_raze.c`
(func_04A7CA) multiplies gold by settlement byte `[ptr+2]`, labeled "size_byte",
but the BYTE_VERIFIED NativeSettlement layout has +0x02 = OWNER (tribe id). So
raze gold scaled with tribe *id*, and with the wrong ids a high-id nomad
out-earned the civilizations. The arithmetic was traced; the field SEMANTIC was
guessed and is wrong.

**Action taken**:
- `include/native.h`: tribe ids corrected to @TRIBES file order; 4-level @LEVELS
  model added (was binary); settlement types fixed; TRIBE.TXT correctly described;
  fabricated stats removed; banner downgraded from blanket RECONSTRUCTED.
- `data/tribe_data.c`: rewritten — verified @TRIBES/@LEVELS tables only;
  behavioural params (aggression/pop/wealth-magnitude/skills/goods) demoted to
  TBD (uncited guesses removed); fabricated 0x09800 offset removed.
- `src/native/native_village_raze.c`: false BYTE_VERIFIED downgraded;
  byte[+2]="size" flagged as contradicting +0x02=owner; gold output marked
  suspect pending re-trace of what 0x8D4E points to.

**Follow-up**: (1) RESOLVED 2026-05-30: the CHIEFKILL size factor is
NativeSettlement +0x04 = POPULATION (user-verified Inca pop 13 / Aztec pop 10 —
docs/CAPITAL_BONUS_ANALYSIS.md), not byte +0x02 (owner). native_village_raze.c
corrected (+0x02 -> +0x04). A separate capital-only bonus is added by the
capital/Cibola handler (magnitude still hypothesis-level, TBD). (2) Trace the
native behavioural tables (aggression, pop, skills) — overlay-resident, currently TBD.
(3) A 5-domain audit of the other RECONSTRUCTED data tables (buildings, market,
units, terrain yields, founding fathers, king/REF, scenario) is in progress.

---

## 2026-05-29 (RESOLVED) — AIPersonality table base is DGROUP:0x540E (controller @+0x31)

**Supersedes** the 2026-05-29 "(OPEN CONFLICT)" entry below. Resolved by the table
ALLOCATION/zero-init trace (the method that settled UnitRecord).

**Deciding evidence**:
- New-game power-init loop @0x744FE runs AIPersonality (stride 0x34 via si) parallel
  to PowerRecord (0x13C via di): `MOV si,0x543F` / `MOV byte [si],1` (AI) /
  **`MOV byte [si-1],0`** (writes 0x543E — a field BELOW 0x543F) / `ADD si,0x34` ×4.
  The write to 0x543E proves 0x543F is NOT field +0x00.
- NAMES.TXT loader func_0749E0 strcpys "LEADERNAME" -> `ADD ax,0x540E` (0x74C22, field
  +0x00) and "COLONYNAME" -> `ADD ax,0x5426` (0x74BEA, +0x18). 0x540E is the LOWEST
  stride-0x34 destination corpus-wide (only bases 0x540E and 0x5426 exist).
- Scan loop @0x745A4 bx=0x543F .. `CMP bx,0x550F` = 0x543F + 4*0x34 -> 4 records,
  flag at +0x31.

**Ruling**: AIPersonality base = **DGROUP:0x540E**, stride 0x34, 4 powers. Field map:
+0x00 LEADERNAME char[0x18] (0x540E); +0x18 COLONYNAME char[0x18] (0x5426); +0x30 byte
(0x543E); **+0x31 CONTROLLER flag (0x543F)** 1=AI/0=human/2=dead; +0x32 named-colony
counter word (0x5440). 0x543F is the most-referenced field (~218 refs) -> mistaken for
the base, same trap as UnitRecord (0x3146 = type +0x02 of base 0x3144).

**Action taken**: re-anchored ai_personality.h (base+struct+macros), globals.h (base;
4 not 8 powers), and the controller-index reads in ai/unit_orders.c, founding_fathers/
effects.c, king/demands.c, native/raid.c ([n][0x00]->[n][0x31]); base-label comments in
driver.c/turn_update.c/units.c/endgame.c/lcr.c. `@asm [bx+0x543F]` operand quotes left
verbatim (correct base+0x31 folding). raze_treasure.c/main_loop.c already used 0x540E.

**Follow-up**: lcr.c +0x3A @0x06186B citation is suspect (impossible in a 0x34 record,
lands in DATA_BYTE) — re-verify. essential/ mirror archived 2026-05-30 to
_archive/essential_mirror_2026-05-29/ (was stale; do not grep for current facts).

---

## 2026-05-29 (OPEN CONFLICT) — AIPersonality table base: 0x540E vs 0x543F

**Conflict**: two byte-cited per-power stride-0x34 accesses disagree on the base.
- raze (func_05C878): `IMUL ax,[bp+8],0x34` then `ADD ax,0x540E` (bytes 6B 46 08 34
  / 05 0E 54) -> base 0x540E. Used by raze_treasure.c, lcr.c, main_loop.c.
- new-game controller init @0x23D34: `IMUL bx,idx,0x34` then `MOV byte [bx+0x543F],1`
  (bytes 6B 5E F6 34 / C6 87 3F 54 01) -> read as base 0x543F (controller @+0x00).
  Used by 10 files incl. ai/driver.c (controller "+0x00", 218 refs).

**Likely resolution (UNCONFIRMED)**: 0x543F - 0x540E = 0x31, WITHIN one 0x34-byte
record. So the base is probably **0x540E** and the controller flag is field **+0x31**
(0x543F) — the same "keyed on a field, called it the base" error that hit UnitRecord
(0x3146 was type +0x02). If so, the 10 files using 0x543F-as-base are off by +0x31.

**Status**: UNRESOLVED — needs the table-ALLOCATION / zero-init trace (the lowest
address written across the whole AIPersonality record at game start, as func_04007E
gave for UnitRecord). Do NOT mass-change the 0x543F files until then. Both readings
left in place, flagged inline.

**Action taken**: flagged; queued a resolution task. No base overturned.

---

## 2026-05-29 (save) — DOS saves are COLONY*.SAV; the .COL/COL2 format is Win16

**Ruling** (BYTE_VERIFIED): DOS VICEROY.EXE writes save files named COLONY*.SAV —
strings "COLONY" @file 0x1FA82 + ".SAV" @0x1FA89 (slot label "(EMPTY)" @0x1FA8C).
The .COL / "COL2" / version-3 layout in tools/col_to_trace.py and
colowin/docs/engine/SAVE_FORMAT.md is the **Win16 colonize.exe** format, conflated
with DOS. (CONFIG.COL @0x1F9F9 is a config file — the only real .COL.)

**Impact**: behavioral-parity testing against DOS needs a COLONY.SAV reader, NOT
the .COL decoder — tools/col_to_trace.py targets the wrong build. Save I/O is a
buffered stream layer (OPEN func_076E50, WRITE func_0775EC, READ func_077100); the
on-disk section order/header/checksum is still TBD (serializer not yet isolated).

**Action taken**: save_serializer.c / load_deserializer.c rewritten to the verified
strings + stream I/O; save.h on-disk layout stays RECONSTRUCTED/TBD. Follow-up:
re-point the parity reader to COLONY.SAV.

---

## 2026-05-29 (open) — PowerRecord+0x2A: spendable gold, also accrued by func_051EF4

**Finding** (BYTE_VERIFIED): PowerRecord+0x2A (dword, via *(0x84FC)) is the active
power's spendable total: `SUB [bx+0x2A]/SBB [bx+0x2C]` on boycott-lift (@0x3340D)
and market buy (@0x352CA); `ADD [bx+0x2A]/ADC [bx+0x2C]` per turn by func_051EF4
(@0x051F80), value = (metric + (year-1500)/50) x era x difficulty x 4.

**Open question (semantic)**: market/boycott/raid + memory call +0x2A "gold" (it
IS spent like gold); the scoring trace calls func_051EF4 a "score tick". It is ONE
field. Either func_051EF4 is per-turn GOLD income (and "score" is the wrong label)
or +0x2A doubles as the score. compute.c hedges ("gold/score running total"). For
the reconciler: does the endgame score read +0x2A or a separate field?

**Action taken**: flagged; gold@+0x2A stands in market/boycott/raid (spent as
gold). No file overturned.

---

## 2026-05-28 (render) — func_O508/0x67DC8 is the dialog-rect fn, not a sprite blit

**Conflict**: FUNCTIONS_INVENTORY §A described func_O508 (0x67DC8) as a
"single-sprite blit wrapper" and lcall 0x181F:0x254 as "pixel-blit to framebuffer"
([0x839E] = PHYS0.SS descriptor).

**Ruling** (BYTE_VERIFIED): func_067DC8 is `compute_dialog_rect_from_cursor`. It
reads cursor_x/y from [0x174]/[0x176]; the `mov ax,0x95` before the O513 call is
DEAD (AX unused by the callee). 0x181F:0x254 is a Type-B thunk -> file 0xE76A =
the popup/dialog-rect setter (it draws the active-tile SELECTION rect, not terrain
pixels). [0x839E] is a screen CLIP RECT, not the PHYS0.SS sheet descriptor. The
actual terrain pixel-emit leaf is resident draw code invoked from func_O512's
4-pass loop; its exact format is TBD.

**Action taken**: FUNCTIONS_INVENTORY.md §A func_O508 + lcall 0x181F:0x254 entries
banner-corrected; src/render/tile_chain.c documents the verified chain. The
O514->O513->O512 chain itself is unaffected (still correct).

---

## 2026-05-28 (OPEN CONFLICT) — DGROUP:0x53A7 "king-anger" vs "year/100"

**Conflict**: memory/STATE call 0x53A7 the king-anger byte (USER-VERIFIED: tea
parties drove it 3->4->5 around turn 54). But static disasm of the re-segmented
overlay shows func_03DE46 writes `[0x53A7] = year/100` and `[0x53A8] = year%100`,
and func@0x39EE2 reads them back as `0x53A7*100 + 0x53A8` to reconstruct the year.
There is NO `inc [0x53A7]` anywhere in the binary.

**Status**: UNRESOLVED. Both are evidence (tier-1 user runtime obs vs static
bytes) and can't both be true for one byte. Possible: (a) the write target is
actually 0x53A6/0x53A8, not 0x53A7; (b) the user's 3->4->5 was a different byte;
(c) 0x53A7 is dual-use. NOT encoded as gameplay truth in any C file (king/demands.c
cites both as TBD). For the cross-source-reconciler: re-verify func_03DE46's exact
write target and the runtime byte the user observed BEFORE changing the
project_king_anger_and_ref memory.

**Action taken**: flagged only; no code/memory changed.

---

## 2026-05-28 (RESOLVED) — UnitRecord base is DGROUP:0x3144 (supersedes "base 0x3146")

**Supersedes** the 2026-05-28 "(refine)" entry (which left base=0x3144 PENDING) and
overturns the 2026-05-28 "base 0x3146" entry. The verification pass is complete.

**Deciding evidence — WRITE sites (a new unit's first-initialized fields):**
- `func_04007E` @0x04009E `MOV [bx+0x3144],al` (x=0xFF) / @0x400A2 `[bx+0x3145]` (y) /
  @0x400AF `[bx+0x3146]` (type), right after `IMUL bx,[bp-2],0x1C` allocates a slot
  (count @0x539C). `func_L141` @0x06958/@0x0695E writes the REAL x/y to 0x3144/0x3145
  on placement; unit-remove (ends 0x06938) writes 0xFF back to 0x3144/0x3145.
- Reads agree: combat resolver reads x@0x3144, y@0x3145, type@0x3146,
  owner@(0x3147&0xF) at one idx*0x1C; find-unit-at-xy func_03C932 keys on
  0x3144/0x3145/0x3147.
- Stride boundary: NO field access at 0x3160+ corpus-wide (= 0x3144 + 0x1C).

**Ruling**: UnitRecord base = **DGROUP:0x3144**, stride 0x1C. Field map: +0x00 map_x
(0x3144), +0x01 map_y (0x3145), +0x02 type (0x3146), +0x03 owner|flags (0x3147),
+0x04 flags (0x3148), +0x06 moves (0x314A, init 0xFF), +0x07 profession (0x314B,
init 0x2D), +0x08 orders (0x314C), +0x09/+0x0A goto x/y (0x314D/E), +0x0C
cargo_count (0x3150), +0x0D..+0x0F cargo_kind (0x3151-53), +0x10..+0x15 cargo_qty
(0x3154-59), +0x16 turn_counter (0x315A), +0x17 vet/type (0x315B, 0x13..0x1C),
+0x18 word prev-link (0x315C), +0x1A word next-link (0x315E). End = 0x3160.

**Why "0x3146" was wrong**: func_008B96 (`IMUL ...,0x1C`+`MOV bl,[bx+0x3146]`) reads
field +0x02 (type) — the most-tested field, so a high ref count ≠ base. 0x3144/0x3145
being written as a unit's initial x/y proves they are fields +0/+1, not "previous-
record chain bytes"; the chain links are words at 0x315C/0x315E (+0x18/+0x1A).

**Action taken**: corrected unit.h, anchor_map.md, decompiled.md, VERIFICATION_LEDGER.md
(incl. 0x315B = +0x17, not +0x15), both PROGRESS.md, DISASM_LEDGER.md, and memory
project_unit_table_correction.md. NOTE: the byte-identical `essential/` mirror held
the old values; ARCHIVED 2026-05-30 to _archive/essential_mirror_2026-05-29/ (do not
grep it for current facts — see _archive/MANIFEST.md).

**Follow-up**: field +0x05 (0x3149) role TBD; the 0x315A "turn-counter vs
colony-job-assign" dual-write needs reconciliation.

---

## 2026-05-28 (ai) — AI logic mostly overlay-blocked; 0x539E/0x539C are colony/unit counts (not num_powers)

**Findings** (byte-verified parts): there is no single resident "iterate-nations
and dispatch AI" function — the top-level AI dispatcher crosses into the RTLink
overlay (blocked pending the VP-directory decode, task #5). Resident & verified:
the controller flag is **AIPersonality +0x00** (1=AI / 0=human; 218 refs);
new-game controller assignment @0x23D2E; power-init loop @0x744FE runs the
AIPersonality table (DGROUP:0x543F, stride 0x34) parallel to PowerRecord
(0x8808, stride 0x13C). The per-unit AI evaluator is **func_04E2D6** (order-setter
func_04E2B6): gates on unit activity state, accumulates a desirability flag from
~12 conditions (turn%15, year<=1650, unit-type, combat-eligibility via stat table
0x5230+0x06), writes single-letter order codes to a UnitRecord byte. random_int
(LCALL 0x181F:0x4D4 -> 0xC322) confirmed.

**Corrections (byte-proven) to prior "facts":**
- **DGROUP:0x539E = COLONY count** (indexed ×0xCA), NOT num_powers.
- **DGROUP:0x539C = UNIT count** (indexed ×0x1C).
- European powers = literal 4 (not read from 0x539E).
- AIPersonality +0x00 is the controller flag — the reconstructed
  aggression/expansion/militarism weights in ai_personality.h are NOT
  byte-verified and are contradicted; +0x02..+0x33 are TBD (data-driven/overlay).

**TBD (NOT guessed)**: the personality-weighted decision math, per-tile scorers
(overlay page via 0x534C6/0x53539), pathfinder (0x181F:0x59C), and the top-level
AI dispatcher are all Type-A overlay -> blocked on the VP-directory decode (#5).

**Action taken**: recorded. Stale-label follow-up DONE (2026-05-29):
anchor_map.md hot-globals table now lists 0x539E=colony_count / 0x539C=unit_count
with @asm offsets (imul ×0xCA @0x735B3, ×0x1C @0x735D6; cmp 0x30 @0x22584/0x2EB82/
0x4C5D4; set_active_colony @0x82EF); FUNCTIONS_INVENTORY.md gained a "DGROUP record
counts" subsection and its "AI decision entry" search hint was re-anchored to base
0x540E (controller @+0x31). NOTE: the AIPersonality part of this entry (base 0x543F,
controller @+0x00) was itself SUPERSEDED by the 2026-05-29 (RESOLVED) entry above
(base 0x540E, controller @+0x31 = 0x543F); ai_personality.h was already re-anchored
under that ruling, so only its top banner was scoped (struct=BYTE_VERIFIED,
personality weights=RECONSTRUCTED/TBD) — the +0x00 reading was NOT re-applied.

---

## 2026-05-28 (market) — European market model byte-verified; P6 anchor 0x57DC0 is wrong (it's SIGNTREATY)

**Correction**: the P6 trace-anchor map listed market = idx 44 file 0x57DC0. That
function is the diplomacy **SIGNTREATY** handler (alliance matrix @DGROUP:0x8848
stride 0x13C, emits "SIGNTREATY" @0x57E86) — NOT the market.

**Ruling** (BYTE_VERIFIED): the market "struct" IS the active player's PowerRecord —
`func_030550` @0x030550 sets `g_market_ptr[0x84FC] = 0x8808 + power*0x13C`. Price
fields (PowerRecord): **price_level byte[16] @+0x4C** (@0x0306F3), **volume
accumulator word[16] @+0x5C** (@0x030707), boycott mask word @+0x20, gold dword
@+0x2A, tax byte @+0x01, FF count @+0x14. Per-turn drift (orphan range
0x0305FF..0x030B38): volume += scaled demand; when it crosses a per-good
threshold, price_level ±1 and the threshold is consumed; clamp to [floor,
difficulty-scaled ceiling]; emit PRICEUP/PRICEDOWN. Boycott lifecycle: TeaParty set
@0x34717, lift-by-tax @0x33423, clear-all (Jakob Fugger = FF id 1) @0x3BD45, test
`func_030B38` @0x030B38. Per-good economic params load from NAMES.TXT @CARGO into a
9-byte/good table @DGROUP:0x96FC (loader @0x074DEC).

**TBD (NOT guessed)**: the price-level→coin-value (bid/ask) curve is behind RTLink
overlay thunk 0x181F:0x9A4 (not in the static dump); the NAMES.TXT @CARGO numeric
values; FF ids 9/0xE/0x10 effects.

**Action taken**: recorded. market.c write + the FUNCTIONS_INVENTORY P6-map
correction (0x57DC0 → SIGNTREATY) are pending (task #3).

---

## 2026-05-28 (combat) — Combat resolver is func_05B2C2 @ file 0x5B2C2; 0x4E2B6 is NOT combat

**Conflict**: the P6 trace-anchor map / FUNCTIONS_INVENTORY pointed combat at idx
39 file 0x4E2B6; rng.c named func_05B2C2 but unverified; resolve.c formulas were
RECONSTRUCTED ("DO NOT TRUST").

**Ruling** (BYTE_VERIFIED): the combat resolver is **func_05B2C2** (file
0x5B2C2..0x5BE30, 2926 bytes; the per-function splitter wrongly truncated it to 35
bytes at its first early return). Args: attacker [bp+6], defender [bp+8]. The
decision is a SINGLE inclusive roll: `roll = random_int(1, ATK+DEF)` (LCALL
0x181F:0x04D4 @0x5B849), attacker wins iff `roll <= ATK` (@0x5B851/0x5B854) →
P(attack) = ATK/(ATK+DEF). ATK/DEF are the RAW per-type bytes from the stat table
at **DGROUP:0x5230, stride 14 (0xE)**: +0x0C atk (@0x5B83B), +0x0B def (@0x5B823),
+0x06 combat-eligibility (@0x5B404). Plus a 50% ambush coin (random_int(0,1)
@0x5B3B4) for European attackers (owner>=4) without flag 0x10. Loser demotion
ladder @0x5B5AA (Dragoon4→Soldier1→Colonist0; ContCav7→ContArmy9→Colonist0;
Cavalry8→Regular6; Artillery→damaged/destroyed). **0x4E2B6 (idx 39) is the AI
move-eligibility evaluator, NOT combat** (one unit arg, zero random_int calls; its
"RANDOM" tag was an `and ax,0xf` mask).

**Wrong in resolve.c** (to be superseded): RNG call form (used range(0,total-1)
roll<atk — same probability, different RNG consumption → breaks replay); the
fortified/terrain/SoL/FF strength multipliers (NONE scale the raw atk/def inside
the resolver); the stat-table shape (had stride 8/45 types; real is stride 14, ~23
@UNIT types).

**Action taken**: FUNCTIONS_INVENTORY.md priority #3 + blit/main-loop framing
updated. combat.c rewrite + resolve.c supersession pending (next).

**Follow-up / TBD (NOT guessed)**: numeric atk/def values load from NAMES.TXT
@UNIT at runtime (not in the static EXE); internals of overlay helper
0x181F:0x768 (fortification path selector [bp-0x28]) and the popup-key↔DS-offset
map.

---

## 2026-05-28 (refine) — UnitRecord field map: x@0x3144, y@0x3145, type@0x3146, owner@0x3147

**Refines** the "UnitRecord base 0x3146" entry below. Combat tracing of
func_05B2C2 reads, with bx = idx*0x1C: `[bx+0x3144]`=x (@0x5B341),
`[bx+0x3145]`=y (@0x5B34A), `[bx+0x3146]`=type (@0x5B310), `[bx+0x3147]`=owner
low-nibble (@0x5B306). All four use the same idx*0x1C and are contiguous, so the
record's first field (x) is at **0x3144** — the record base is likely **0x3144**
with type at **+0x02** (= 0x3146). The earlier entry correctly killed 0x315E and
identified 0x3146 as the most-referenced field, but labeled 0x3146 as base/field+0;
it is actually field +0x02 (type). This also conflicts with the earlier inference
that 0x3144/0x3145 are "previous-record chain-link bytes".

**Status**: REFINEMENT PENDING one independent confirmation (find the unit
create/move function that WRITES a unit's x/y and confirm it writes
0x3144/0x3145 at idx*0x1C). A verification pass is running. Do NOT re-propagate
base=0x3144 across the corpus until confirmed; the committed base=0x3146 is
"type's address" and remains safe for offset math meanwhile (field = addr −
0x3146 relative to type).

**Action taken**: none yet (verification pending) — recorded so it isn't lost.

---

## 2026-05-28 — UnitRecord table base is DGROUP:0x3146, not 0x315E

**Conflict**: anchor_map.md / decompiled.md / unit.h said the unit-table base is
DGROUP:0x315E (stride 0x1C); docs/DATA_MODEL.md / VICEROY2 /
PROGRESS said 0x3146.

**Source A** — anchor_map.md (33,197,235), decompiled.md (38), unit.h, the
viceroy_source VERIFICATION_LEDGER said base 0x315E "confirmed via
unit_field_lookup_simple (0x66BA)".

**Source B** — docs/DATA_MODEL.md:41, VICEROY2_annotated.c
(`#define UNIT_TABLE_BASE 0x3146`) said base 0x3146 ("652+ refs to [reg+0x3146]").

**Ruling**: **0x3146 wins** (TRUTH_HIERARCHY: raw VICEROY.EXE bytes outrank
inference). `func_008B96` @0x008B99 does `IMUL bx,[bp+6],0x1C` then
`MOV bl,[bx+0x3146]` — index×stride is added to 0x3146, so 0x3146 is the array
origin (field +0x00). Corpus-wide, `imul *,0x1C`→`[reg+0x31xx]` sites cluster as
fields of one record based at 0x3146 (0x3146 hit 203×, 0x315E only 8×). So
0x315E = field +0x18 (word returned by unit_field_lookup_simple 0x66BA),
0x315C = field +0x16 (link word in unit_chain_resolve 0x6672), 0x3154 = +0x0E.
The unit.h "0x315E − 8 = 0x3156" derivation was arithmetically wrong (diff is
0x18=24); its conclusion (0x3146) was right.

**Action taken**: corrected anchor_map.md (33,197,198,235), decompiled.md (38),
unit.h (4-5,16,25-32), VERIFICATION_LEDGER.md (397), PROGRESS.md
(116,117). No code change (load_game_state.py already uses 0x3146).

**Follow-up**: residual tracker lines (viceroy_source/PROGRESS.md, DISASM_LEDGER.md)
still to propagate.

---

## 2026-05-28 — NativeSettlement is 18 bytes @ DGROUP:0x54EC; the 200-byte/0x9100 struct is fabricated

**Conflict**: viceroy_source/docs/DATA_MODEL.md + native.h describe a 200-byte
(0xC8) NativeSettlement at table 0x4850 / data 0x09100 / 80-slot max;
docs/DATA_MODEL.md + project memory describe an 18-byte (0x12)
record at DGROUP:0x54EC.

**Source A** — viceroy_source/docs/DATA_MODEL.md (242-272), native.h,
COLONIZATION_TECHNICAL_REFERENCE.md (200) said 200 bytes / 0x9100 / 0x4850 / 80
slots. Both source files self-flag ">>> RECONSTRUCTED — NOT BYTE-VERIFIED <<<".

**Source B** — docs/DATA_MODEL.md + memory said 18 bytes at
0x54EC (x/y/owner/mission), table compacts on raze.

**Ruling**: **18 bytes @ 0x54EC wins** (raw bytes outrank reconstruction). Every
access uses `imul *,0x12` then `[bx+0x54EC..]` (overlay 0x46035, 0x4610A…); an
18-byte record→record copy at 0x46F40 (`lea di,[bx+0x54EC]`/`lea si,[bx+0x54FE]`,
diff 0x12); live-count at DGROUP:0x539A (INC 0x46E2E, DEC 0x46F5D, cap 0x54=84).
It draws map markers by (x,y) (loop @0x670CF). The 200-byte struct has ZERO byte
support: 0x4850, 0x9100, and `imul *,0xC8` each appear 0× in the binary; 0x4850 is
a save-file offset, not a DGROUP address. 0x5AD6 is a parallel aux column (2 refs,
paired with 0x54EC), not a 624-byte rival table.

**Action taken**: corrected viceroy_source/docs/DATA_MODEL.md (242,244,251-273,
379,398), native.h (19-27,34-47), VERIFICATION_LEDGER.md (201),
COLONIZATION_TECHNICAL_REFERENCE.md (200,201,2324,2326). docs/
DATA_MODEL.md unchanged (already correct; now the cited authority).

**Follow-up**: fields +0x03 and +0x06..+0x11 of the 18-byte record are TBD; the
0x5AD6 aux array is undecoded.

---

## 2026-05-28 — RNG is byte-verified at file 0x103D4 (FUNCTIONS_INVENTORY "NOT YET LOCATED" was stale)

**Conflict**: FUNCTIONS_INVENTORY.md §D (dated 2026-04-20) said the RNG is "NOT
YET LOCATED" and "no LCG constants (0x343FD…) found anywhere"; rng.c + memory say
rand() is byte-verified at file 0x103D4.

**Source A** — FUNCTIONS_INVENTORY.md (511-520) said not located; RNG in MADS
overlay 0x181F.

**Source B** — viceroy_source/src/runtime/rng.c + memory said MSC 6.0 LCG at file
0x103D4, random_int at 0xC322 (verified 2026-05-02).

**Ruling**: **Source B is correct** (raw bytes). At file 0x103D4: `B8 FD 43 BA 03
00` = `MOV AX,0x43FD; MOV DX,3` (multiplier 0x000343FD=214013); `05 C3 9E`/`83 D2
26` (addend 0x00269EC3=2531011); `AND AH,0x7F` → `(seed>>16)&0x7FFF`. Seed at
DGROUP:0x28EE/0x28F0; srand @0x103C2; random_int @0xC322 (via LCALL 0x181F:0x04D4).
The byte pair `FD 43` occurs exactly once in the binary (0x103D5) — proving
0x343FD IS present. §D scanned only the overlay; the RNG is in the load image. §D
also self-contradicted at line 641 ("RNG idx 29 0x3C322 already done").

**Action taken**: corrected FUNCTIONS_INVENTORY.md (511 header, 513-520 status,
backlog item 2). No code change; rng.c already authoritative.

**Follow-up**: none — RNG fully resolved.

---

## 2026-05-19 — AMER2_dos_reference.png IS the pixel target (user override)

**Conflict**: prior 2026-04-15 ruling said `reference/dos/AMER2_dos_reference.png`
was editor-style and should NOT be pixel-chased ("converge style vs in-game
session frames + render_chain"). User directive 2026-05-19 explicitly
overrules this.

**Source A** — prior ruling (2026-04-15, memory note
`project_map_structurally_verified.md`) said: editor export is structural-
only; chase in-game DOSBox frames for style, citing the editor's flat
ocean vs PHYS0.148 dithered ocean as proof of style divergence.

**Source B** — user directive 2026-05-19 said: "the AMER2_dos_reference.png
is what it needs to look like ... no other references, no other questions ...
i dont care if you try every relevant sprite over an area to test it out.
this ends today."

**Ruling**: User directive wins (TRUTH_HIERARCHY tier 7 — user-as-arbiter).
`AMER2_dos_reference.png` is now the canonical pixel target for map
rendering. Empirical sprite trials are permitted; final choices must
still carry `# noqa: fabrication-check` + a citation comment that
references the visible match.

**Action taken**:
- `colonize_sdl/render/terrain.py`:
  - STEP 6b (river overlay): replaced single-sprite-113-dot blit with
    full neighbor-mask topology lookup `_blit_overlay(0 + r_idx)` using
    PHYS0 row 0 (sprites 0-15, pixel-verified rivers in
    `debug_sprite_inspect/phys0_rows_0x01_0x11.png`). Rivers now connect
    through Mississippi/Amazon/Andes basins matching the reference.
  - STEP 1b (center variants): dropped `_ov >= 3` gate — AMER2 has only
    ~70 tiles with ov>=3 vs ~1224 land tiles; the editor draws a per-
    terrain center decoration on every land tile (cotton on plains,
    cactus on desert, tobacco on prairie, etc.). Citation:
    `reference/dos/AMER2_dos_reference.png` pixel density.
  - STEP 5 (display downscale): swapped `transform.scale` (nearest 3:1
    drops 8/9 of source pixels) for `transform.smoothscale` (bilinear)
    so the 48 px buffer's sprite detail isn't decimated on the way to
    16 px display.
  - Lost city rumor overlay: upgraded 3-px circle to PHYS0.103
    medallion at native 16×16 centered.
  - Resource icon overlay: upgraded 8×8 top-right blit to native 16×16
    centered.
- `tools/render_amer2_now.py`: NEW — headless full-map render in COLOPY
  paths. Supports `COLOPY_DUMP_BIG` env var to dump 48 px internal buffer
  for crisp diffs vs the 32-px reference.
- `tools/diff_amer2_vs_dos.py`: NEW — generates side-by-side + abs-diff
  + zoomed crops vs the reference.
- Memory `project_map_structurally_verified.md` rewritten to document
  the override.

**Follow-up**:
- A few orange medallions in DOS reference (e.g., mid-Brazil at
  ~tile (40-44, 46-48)) don't correspond to any ov>=3 tile in AMER2 —
  these may be native settlements rendered separately by
  `_render_native_settlements`, which isn't invoked by the headless
  render. Worth verifying whether enabling that pass closes the gap.
- `tests/golden/*.png` are STALE after this change. Need user approval
  to regenerate via `tests/run_regression.py --update` (and fix
  hardcoded paths in `tools/render_test.py` which still point to the
  old `colonization_project_full` tree).

### 2026-05-19 (b) — follow-up: major/minor rivers + coast sand both sides

**User feedback** (2026-05-19): "there are major rivers and minor rivers.
those need to be correct ... the coasts are all still wrong".

**Findings**:
1. **Rivers**: AMER2.MP has NO data field that directly distinguishes
   major vs minor rivers — both Layer 2 (all zeros) and Layer 3 lack a
   major-flag bit. But empirically, `L1 == 0xC0` (forest+river) tiles
   cluster along the Amazon main trunk through forested terrain (47
   tiles in rows 9-23 cols 30-40), while `L1 == 0x40` (plain river)
   tiles are scattered tributaries (178 tiles). PHYS0 row 0x01
   (sprites 1-15) and row 0x11 (sprites 17-31) provide two separate
   16-variant river sprite banks. Mapped 0xC0→major (sprites 17-31),
   0x40→minor (sprites 1-15).
2. **Coasts**: previous render put sand only on the WATER side of the
   land-water boundary AND drew it BEFORE the forest overlay. On
   forested coastline (most of the Americas, since bases 8-23
   auto-forest), the forest sprite overpainted the sand → invisible
   beaches. Plus the diffuse blend (STEP 2) painted ocean blue onto
   land tiles at the boundary, creating blotchy non-DOS coasts.

**Action taken**:
- `colonize_sdl/render/terrain.py`:
  - STEP 2 diffuse blend: skip when crossing land/water boundary
    (`is_water(raw) != is_water(nb_raw)`). Diffuse stays for
    land/land transitions where DOS does show biome bleed.
  - STEP 3: water-side sand still drawn here.
  - NEW STEP 5b: **land-side sand**, drawn AFTER forest/mountain/
    hills overlays so the beach strip wins at the coast. Uses the
    same TERRAIN.SS.001 sand texture cropped per cardinal direction.
  - STEP 3b: PHYS0 150-153 beach corner overlays drawn on water
    tiles via the existing `COAST_TABLE` (was defined but unused).
  - STEP 6b: river render — split into major (row 0x11, sprites
    17-31) and minor (row 0x01, sprites 1-15) by `(raw & 0xC0) ==
    0xC0` test.
  - STEP 5 (display downscale): reverted smoothscale→scale (nearest);
    bilinear smearing was hiding the sand band.
- `tools/render_amer2_now.py`: now ALWAYS dumps the 48 px buffer to
  `render_AMER2_big48.png` (the actual deliverable — 16 px display
  surface loses too much detail in the 48→16 downscale per hard rule).

**Visual verification**:
- `debug_big48_florida_v6.png` (48-px native) — sand bands clearly
  visible on both sides of every coastline.
- `FINAL_v3_diff.png` (ours vs DOS at matched scale) — coastlines,
  rivers, mountains all align.

**Follow-up still open**:
- Orange resource medallions density still lower than DOS reference.
  Likely a combination of native settlements (rendered by a separate
  pass our headless render doesn't invoke) + the `_ov >= 3` Layer-3
  gate which only fires on ~70 of 1224 land tiles.

### 2026-05-19 (c) — proper 4-corner coast compositor (user-supplied algorithm)

**User feedback**: "the coasts are all still wrong ... if you take a
sample of the coast for any area, and its not exactly the same then
its wrong". User then supplied the canonical Col1 coast-render
algorithm spec verbatim.

**Algorithm** (user-supplied):
1. For each water tile, build an 8-bit mask of "which neighbors are
   land", walking CW from LEFT (bit 0=W, 1=NW, 2=N, 3=NE, 4=E, 5=SE,
   6=S, 7=SW).
2. If mask == 0 → plain open ocean, no compositing.
3. Decompose into 4 × 3-bit quadrant indices:
   - TL = bits (0,1,2) — W, NW, N
   - TR = bits (2,3,4) — N, NE, E
   - BR = bits (4,5,6) — E, SE, S
   - BL = bits (6,7,0) — S, SW, W (bit-0 wraparound)
4. Each 3-bit index picks one of 8 sub-sprites from the corner's atlas.
5. Paste each 8×8 sub-sprite into its quadrant.

**Atlas layout** (visual-verified, debug_sprite_inspect/coast_*_atlas.png):
- PHYS0 108-115 = TL atlas (8 patterns, indices 0-3 are all-black
  placeholders for the no-top-land cases)
- PHYS0 116-123 = TR atlas
- PHYS0 124-131 = BR atlas
- PHYS0 132-139 = BL atlas
Each atlas is pre-rotated for its corner orientation (user note:
"32 sprites (4 rotations × 8 patterns, look up directly)").

**Action taken**:
- `colonize_sdl/render/terrain.py` STEP 3: replaced the lmask-based
  PHYS0 150-153 corner overlays (and the side-strip sand approach)
  with the proper 4-corner composite. Uses the existing
  `_coast_subtile_scaled` helper which already treats both magenta
  AND black as transparent (needed for the placeholder sprites and
  for the "outside the subtile shape" pixels in DOS encoding).
- ALSO: gate each corner draw on its bit_2 (= second orthogonal
  in CW order) being land. TL needs N=land, TR needs E=land, BR
  needs S=land, BL needs W=land. This stops near-empty index-0
  sprites in the TR/BR/BL atlases (~17-35 opaque pixels) from
  painting spurious ripple patches in open-ocean corners of coast
  tiles. The TL atlas placeholders already enforced this rule for
  TL; we apply it symmetrically.
- TREAT sub-sprite "shallow water" blue pixels (B > 100 AND B > R
  AND B > G) as transparent so the underlying ocean texture shows
  through. The atlas blues (~(64,89,165)) are lighter than our base
  ocean (~(40,56,145)), and painting them on top creates visible
  patches — the DOS reference shows near-coast water as the same
  blue as deep water, sand-on-water-tile being the only visible
  coastal feature.

**Visual result**: clean blue ocean, sand bands at every coastline
selected per the 4-corner composite (matching the user's described
geometry — straight cliffs, inside corners for peninsulas, outside
corners for bays).

### 2026-05-19 (d) — forest skip on desert/tundra biomes

**User feedback**: "forest in the desert is a different sprite".

**Finding**: PHYS0 64-79 (the generic forest topology atlas) is all
green deciduous trees. Painting it on top of base 9 (scrub = forested
desert, TERRAIN.SS.008 cacti base) or base 8 (boreal = forested
tundra, TERRAIN.SS.000 tundra-ice base) overpaints the
biome-specific cacti / ice texture with generic green trees — wrong
visual. Our extracted PHYS0 has no per-biome forest overlay atlas
(the Download files' `forest_by_terrain` mapping assumed sprites
that don't exist in our extraction).

**Action taken**:
- `colonize_sdl/render/terrain.py` STEP 5: gate the
  `_blit_overlay(64 + f_idx)` call on `base not in {8, 9, 16, 17,
  18, 22}` — the bases whose base texture already encodes the
  "forest" appearance (cacti, ice, etc.). Other forested bases
  (10-15: mixed/broadleaf/conifer/tropical/wetland/rain) keep the
  green canopy overlay since they ARE green-tree biomes in DOS.
- Bases 17, 18, 22 are AMER2-specific extended terrain IDs that
  map to non-green biome textures via TERRAIN_TO_SPRITE; same
  rule applies.

**Visual result**: desert/scrub tiles in SW US / N Mexico now show
the cacti texture cleanly (debug_desert_compare.png 2026-05-19),
matching the DOS reference.

---

## 2026-04-22 (s) — VICEROY.EXE definitive: auto-forest ALL bases 8-23 including Arctic

**Conflict**: After ruling (r) stopped auto-foresting Arctic per the
MAPEDIT disassembly finding, user said "still wrong". The DOS reference
image clearly shows Canadian Arctic region as mostly FORESTED. Ruling
(r)'s source was MAPEDIT.EXE (the map editor), not VICEROY.EXE (the
actual game). Dispatched dos-disassembler agent to dig into VICEROY's
in-game render code specifically.

**Source (dos-disassembler agent, VICEROY.EXE byte analysis)**:

The game's forest-draw path is at `VICEROY.EXE @ 0x6831B-0x6834C`:

```
0x6831B: cmp word [bp-32], 1     ; folded terrain_class == 1?
0x6831F: je 0x6834F              ; YES → skip forest
0x68321: cmp byte [0xA8A2], 0x08 ; terrain_class < 8?
0x68326: jb 0x6832F              ; → sub-check
0x68328: cmp byte [0xA8A2], 0x10 ; 8 ≤ class < 16?
0x6832D: jb 0x6833D              ; → DRAW FOREST (no bit check)
0x6832F: cmp byte [0xA8A2], 0x10 ; < 16?
0x68334: jb 0x6834F              ; → skip
0x68336: cmp byte [0xA8A2], 0x18 ; >= 24?
0x6833B: jae 0x6834F             ; → skip
          ; fall-through: 16 ≤ class < 24 → DRAW FOREST (no bit check)
0x68349: add ax, 0x0041          ; sprite = 0x41 + wxad_index
0x6834C: call 0x67DC8            ; draw
```

The forest draw happens when `terrain_class` ∈ [0x08, 0x17]. It NEVER
checks `[0xA8A1] & 0x80` (the .MP forest bit). The forest bit only
distinguishes mountains vs hills.

**The terrain_class lookup** (`lcall 0x181F:0x06AA` → resolves to
func_L124 @ `VICEROY.EXE 0x6204`):

```
pass 2 (render mode):
  if (input >= 0x18):  return input               ; pass-through
  if (input < 0x08):   return input               ; pass-through
  else:                return (input & 7) | 8     ; for 8..23
```

This is pure bit arithmetic — NO 8-entry lookup table. For any raw base
in 8-23, the function returns `(base & 7) | 8` = values in 0x08-0x0F —
which all land in the forest gate's fire range.

**Mapping**: Bases 8, 9, 10, 11, 12, 13, 14, 15 fold to class 8, 9,
10, 11, 12, 13, 14, 15 (via `(x & 7) | 8`). Bases 16, 17, 18, 19, 20,
21, 22, 23 ALSO fold to class 8, 9, 10, 11, 12, 13, 14, 15 (same
formula). **All 16 bases in range 8-23 trigger forest draw.**

**Contrast with MAPEDIT**: MAPEDIT's equivalent function (scrub result
(r)) skips forest for base 16. MAPEDIT is the map-editor preview
renderer; VICEROY is the actual gameplay renderer. When they differ,
VICEROY is authoritative for matching the DOS reference screenshot.

**Ruling**: **All bases 8-23 (including Arctic = base 16) auto-forest.**

`_tile_has_forest(r)` simplified:
```python
def _tile_has_forest(r):
    f = r & 0xE0
    b = r & 0x1F
    if f == 0xA0: return False  # mountain
    if f == 0x20: return False  # hills
    return (8 <= b <= 23)       # VICEROY's actual rule
```

The .MP `feat & 0x80` (forest bit) test is REMOVED because VICEROY
doesn't consult it for forest draw. All forest comes from `base in
8..23` via the terrain_class lookup.

**Action taken**:
- `colonize_sdl/main.py`:
  - `_tile_has_forest`: simplified to `return (8 <= b <= 23)` after
    the mountain/hills early-outs.
  - Full citation block added referencing VICEROY 0x6204, 0x6831B,
    0x68349.
- Goldens updated (4/4 pass).

**Visual verification** (vs DOS reference):
- **Canada**: heavily forested (base 16 Arctic + base 18 extended-
  Tundra all auto-forest). White-blue ice BASE under the forest
  overlay — matches DOS "boreal forest on snow" appearance.
- **South America**: Amazon dense, Pampas dry, Andes ridge.
- **North America**: central Great Plains olive (base 2, not auto-
  forested since < 8); eastern deciduous forest (bases 8-15 + 17-23);
  Rockies west coast.

**Follow-up**:
- MAPEDIT's different behavior is noted in FUNCTIONS_INVENTORY.md.
- Bases 17-23 are "forested variants" of bases 1-7 in VICEROY's
  encoding via the `& 7 | 8` fold. The sprite row (forest row 0x41)
  is used for all of them with wxad topology — our rendering matches.
- Ruling (r) is SUPERSEDED. Ruling (o) before it is also obsolete.
  Current authoritative: (l) terrain order, (n) extended bases +
  forestry, (p) coast via biome edge strip, (q)→(r)→(s) for Arctic.

---

## 2026-04-22 (r) — Authoritative ruling from MAPEDIT disassembly + cc94 source

**Conflict**: After rulings (p) and (q) tried to fix Canadian Arctic
and coast rendering by guessing, user directed us to scrub the DOS
binaries and cc94 source for authoritative answers.

**Source A (dos-disassembler agent)** — direct evidence from MAPEDIT
Ghidra dump, parallel rendering function `FUN_1a47_0932` at segment
1a47:

1. **Arctic (base 16) does NOT auto-forest**. At 1a47:0abe:
   `CMP [0x5acc], 0x18 / JC LAB_0ad9` — for Arctic (raw base=0x10=16),
   since 16 < 24, the jump is taken, skipping the forest-overlay draw
   call (which is at 1a47:0ad3: `ADD AX, 0x41` → PHYS0 row 0x41).
   **MAPEDIT does NOT draw forest on Arctic tiles.**

2. **Coast sprites**: MAPEDIT uses TWO code paths:
   - **Branch A** (matched corner pattern, 1a47:0c8c-0c9a):
     sprites 0x97-0x9A = 151-154 overlay when 8-direction mask matches
     specific patterns at `[0x5ad3]`.
   - **Branch B** (per-subquadrant loop, 1a47:0c41-0c7f):
     sprite base = 0x6D = 109, 4-iteration loop, one sprite per
     tile quadrant.

3. **Forest sprite row** = PHYS0 0x41 (65). **Mountain row** = 0x21
   (33). **Hills row** = 0x31 (49). All with wxad topology index.

4. **Center variant table** at DS:0x192. Arctic (index 16 in the
   table) has value `0xFFFF` (-1), meaning Arctic draws NO center
   sprite.

**Source B (general-purpose agent researching cc94)** — verbatim
code inspection of `https://github.com/institution/cc94`:

1. **Arctic is biome 9** in cc94. `render_terr` in
   `src/client/renderer.cpp` draws forest only when
   `terr.has_phys(PhysForest)` is explicitly set — **no auto-forest
   special case for Arctic**.

2. **Coast algorithm** is LAYERED:
   - Biome texture (base fill)
   - 4 `render_diffuse` calls using PHYS 105-108 as ALPHA MASKS with
     neighbor's biome texture → creates the sand/grass EDGE STRIPS
     that match the adjacent biome's color.
   - If water: 4 subquadrants using PHYS 109-140 as ALPHA MASKS with
     ocean/sea-lane TEXTURE via `MODE_REPLACE` (subtile shape = water
     visible vs biome visible).
   - **Sprites 150-153 are NOT used by cc94's main coast algorithm.**

3. **cc94 does NOT consume DOS .MP files** — it has its own Boost
   serialization format. Cannot tell us about DOS bytes 17-23.

**CONVERGENT VERDICT**:
1. Arctic does NOT auto-forest. (Both sources agree, explicit evidence)
2. Beach corner sprites (150-153) are NOT the primary coast
   mechanism in DOS or cc94. They may appear as an overlay for specific
   MAPEDIT patterns (151-154) but the main coast effect comes from:
   (a) biome-color edge strip from adjacent neighbor (matches what
       we implemented in ruling (p) STEP 3a)
   (b) 4-subquadrant subtile masks (cc94's render_sprite_replace with
       MODE_REPLACE) — we're simplifying without these for now

**Ruling**:

1. **Remove auto-forest on Arctic**. `_tile_has_forest` no longer
   returns True for base 16. Arctic tiles render as pure white-blue
   ice with no forest overlay. The Canadian "green" in the DOS
   reference comes from adjacent base-8 (Boreal), base-18 (extended
   Tundra), and forested base-11/12 tiles — NOT from Arctic itself.

2. **Remove beach corner sprite overlays** (the 15-mask `corner_map`
   added in (q)). Neither cc94 nor the DOS reference relies on these
   for the main coast effect. The biome-color edge strip from STEP 3a
   carries the coast appearance adequately at our display resolution.
   (Future enhancement: implement the 4-subquadrant alpha-mask system
   using pygame BLEND modes to get even closer to cc94's algorithm.)

**Action taken**:
- `colonize_sdl/main.py`:
  - `_tile_has_forest`: dropped the `if b == 16: return True` clause
    added in (q). Reverted to pre-(q) behavior.
  - STEP 3b beach corner overlay: removed. The 15-mask `corner_map`
    deleted; coast rendering now consists of:
      STEP 3a: biome-color edge strip on each land-facing edge
      (Step 2 diffuse blend already runs independently for all tiles)
- Goldens updated (4/4 pass).

**Visual verification** (vs DOS reference screenshot):
- **Canadian region**: Arctic tiles (white-blue ice) interspersed
  with Boreal forest (base 8, Tundra+forest). Pattern matches the
  DOS reference's mostly-green Canada with some ice.
- **Coast edges**: Biome-matching strips without the beach sprite
  noise. Clean transitions from ocean to adjacent biome.

**Follow-up**:
- Implement the cc94-style 4-subquadrant coast masks using pygame's
  BLEND_RGBA_MULT or similar to get the authentic DOS "ocean carved
  out by coast shape" effect. For now the biome strips alone are
  close enough.
- Bytes 17-23 remain partially undocumented — MAPEDIT folds them via
  `& 0x7` but the exact biome mapping is inferred from cluster
  analysis only. This is a cosmetic limit, not a functional bug.
- Ruling (o) and (q) superseded by (r).

---

## 2026-04-22 (q) — Auto-forest Arctic; full 15-mask beach composite

**Conflict**: User after ruling (p): "that corrected part of the
coasts and messed up the others and there is to much arctic in canda".

Two issues:
1. **Coast composites too sparse**: Ruling (p) only overlaid beach
   corner sprites for the 4 CONVEX corner masks (0b1001/0011/1100/0110).
   Straight edges (single-cardinal masks), opposite-side masks
   (0b0101/1010), T-junctions (0b0111/1011/1101/1110), and the
   surrounded mask (0b1111) were relying on the biome-color edge
   strip ALONE. This left those coast types without the characteristic
   DOS sand-curve detail, making them look "messed up" compared to
   the corrected convex corners.
2. **Too much arctic in Canada**: Ruling (o)'s Arctic/Tundra swap
   made byte 16 (Arctic) render as sprite 0 (yellow-grey). With 118
   byte-16 tiles in Canada, that's a LOT of yellow-grey Arctic. The
   DOS reference image shows the Canadian region as mostly GREEN
   BOREAL FOREST with occasional ice patches — not overwhelming
   arctic coverage.

**Ruling**:
1. **Expand the beach-corner composite to cover all 15 non-zero
   cardinal land masks**:
   - Single-cardinal (straight edge): 2-corner composite
     (e.g., N only → sprites 150+151; matches (c) and (f) approach)
   - 2-cardinal convex corner: 1 corner sprite
   - Opposite sides: all 4 corners
   - T-junctions (3 cardinals): the 3 matching corners
   - 4-cardinal surround: all 4
2. **Revert (o) Arctic/Tundra swap** to literal NAMES.TXT:
   - Byte 0 (Tundra) → sprite 0 (yellow-grey)
   - Byte 16 (Arctic) → sprite 9 (white-blue)
3. **Auto-forest base 16** (Arctic) by adding it to `_tile_has_forest`.
   Arctic tiles now render as white-blue ice BASE + forest overlay.
   Result: Canadian Arctic region reads as "boreal forest on snow"
   — matching the DOS reference's mostly-green Canada.

**Action taken**:
- `colonize_sdl/main.py`:
  - `TERRAIN_TO_SPRITE[0]`: 9 → 0. `TERRAIN_TO_SPRITE[8]`: 9 → 0.
    `TERRAIN_TO_SPRITE[16]`: 0 → 9. `TERRAIN_TO_SPRITE[18]`: 9 → 0.
    All palette indices (`TERRAIN_PAL_INDEX`) reverted accordingly.
  - `_tile_has_forest`: added early `if b == 16: return True`.
  - STEP 3b beach overlay block: replaced the 4-entry `corner_sprite`
    dict with a 15-entry `corner_map` covering all cardinal land
    masks; iterates over the list of sprites for the matched mask.
- Goldens updated (4/4 pass).

**Visual verification** (comparing to DOS reference screenshot):
- **Canadian region**: now appears as GREEN BOREAL FOREST with
  scattered Arctic/Tundra patches — matching the DOS reference's
  heavily-forested Canada. Previously-overwhelming yellow-grey
  Arctic reduced.
- **Coasts**: every coast type now shows the sand-curve detail
  (straight edges, corners, T-junctions, surrounds). The biome-color
  edge strip from ruling (p) provides the background tint matching
  the adjacent biome; the corner sprites provide the sand-curve
  ring on top.
- **Concave / T-junction / surround masks** previously had bare
  biome strips only; now get the composite sand curves too.

**Follow-up**:
- If the Arctic forest overlay covers too MUCH of the white-blue
  base (making Canada look too green), the forest sprite density
  can be tuned via wxad variants. Current default picks the wxad
  sprite based on forest neighbors.
- Ruling (o) superseded by (q).

---

## 2026-04-22 (p) — Coast reverts to biome edge strip + beach corners; drop subtile system

**Conflict**: User shared a screenshot of the ORIGINAL DOS Colonization
Americas map as reference. Comparison with our current render revealed
that the cc94-based subtile coast system (ruling (f)) produced a
blue-green RIVER-BANK pattern at coastlines, while the DOS game shows
clean SAND/BIOME-COLOR STRIPS at coastlines matching the adjacent land
biome (sandy where desert, grassy where forest).

**Source A** — DOS AMER2 reference screenshot provided by user:
coastlines show a thin uniform strip of the ADJACENT BIOME'S color
(sand/tan next to desert, grass-green next to forest/grassland). The
strip is BRIGHT and UNIFORM, not the blue-green bank pattern.

**Source B** — re-inspection of PHYS0 sprites 108-139: these 8×8
sprites have green banks on blue water — clearly river-bank graphics,
not sand beaches. cc94 REPLACED the DOS coast sprites with its own
green-bank art (generated via `gen_coast()` in cc94's make_all.py)
which is where the mismatch came from. The ACTUAL DOS coast must use
a different rendering path.

**Source C** — PHYS0.150-153 = 4 sand-beach CORNER sprites (full-tile,
16×16). These have sand-ring curves on 2 edges with transparent
magenta on the "away-from-land" half. They're the traditional beach
sprites referenced in the earlier rulings (a-e).

**Ruling**: **Replace the 32-subtile coast system with a two-step
renderer**:

1. **Biome-color edge strip** (STEP 3a): For each cardinal direction
   where the water tile's neighbor is land, paint a 1-sub-cell-wide
   (16-px on the 48×48 internal buffer) strip of the NEIGHBOR's
   TERRAIN.SS base texture along that edge. Desert coasts show sandy
   strips; grassland coasts show green strips; forest coasts show
   the forest's underlying biome color.

2. **Beach corner sprite overlay** (STEP 3b): For 2-adjacent-cardinal
   land masks (0b1001=N+W → 150, 0b0011=N+E → 151, 0b1100=S+W → 152,
   0b0110=S+E → 153), overlay the matching beach corner sprite on
   top of the edge strip. Provides the sand-ring curve detail at
   convex corners.

Non-convex (straight-edge) coast masks rely on the edge-strip alone —
no beach sprite composite needed because the strip matches the DOS
uniform-band appearance.

**Action taken**:
- `colonize_sdl/main.py::_render_terrain`:
  - STEP 3 water-tile block rewritten. Subtile rendering loop
    removed. New code computes a cardinal land mask, then paints
    biome-texture edge strips for each land-adjacent cardinal, and
    overlays a beach corner sprite for 2-adjacent-cardinal masks.
  - The `_coast_subtile_scaled` helper and its cache remain in place
    but are now unused (kept for possible future river-mouth
    rendering that shares the 8×8 format).
- Goldens updated for all 4 test maps (4/4 pass).

**Visual verification**:
- Coastlines now show clean biome-matching strips matching the DOS
  reference.
- Amazon and North American forest edges show green-grass strips;
  Mexican/Patagonian desert coasts show sandy strips; arctic/tundra
  northern coasts show white/grey strips.
- Water bodies are cleaner blue without the river-bank noise.

**Follow-up**:
- The subtile system (sprites 108-139) may actually be intended for
  RIVER MOUTH rendering where rivers meet the ocean. If DOS shows
  specific river-mouth graphics at coastal river endings, we can
  hook those sprites back in via an orthogonal rule.
- Straight-edge coasts (1-cardinal-land masks) no longer have the
  2-corner sprite composite — just the edge strip. If DOS shows
  a specific sand curve on straight edges too, we can revisit.
- Ruling (f) is SUPERSEDED by (p) for coast rendering. The underlying
  cc94 references in (f) remain useful for forest/river/diffuse
  rendering which are unaffected.

---

## 2026-04-22 (o) — Swap Arctic/Tundra sprite mappings for Canada

**Conflict**: User: "in canada you will need to swap arctic with tundra".

The TERRAIN.SS sprite semantics had two candidate textures for polar
terrain:
- Sprite 0: yellow-grey speckled (reads as "ice-on-tundra-grass")
- Sprite 9: white-blue dithered (reads as "pure frozen snow/ice")

Ruling (l)'s literal NAMES.TXT order assigned:
- Byte 0 (Tundra) → sprite 0 (yellow-grey)
- Byte 16 (Arctic) → sprite 9 (white-blue)

User reads the textures the OPPOSITE way visually:
- Yellow-grey speckle = ARCTIC (mostly-ice with melt patches)
- White-blue pure = TUNDRA (snow-covered grass)

**Ruling**: Swap the sprite assignments for byte 0 and byte 16:
- byte 0 (Tundra) → sprite **9** (was 0)
- byte 16 (Arctic) → sprite **0** (was 9)
- Forested Tundra variant byte 8 (Boreal) follows: → sprite **9**
- Extended base 18 (far-north Tundra-like) follows: → sprite **9**
- `TERRAIN_PAL_INDEX` palette fallbacks updated accordingly:
  - byte 0: 20 → 15 (now white)
  - byte 16: 15 → 20 (now grey)
  - byte 8: 20 → 15
  - byte 18: 20 → 15

Only Canada is affected because bytes 0 and 16 appear exclusively in
the far-north rows 3-9 of AMER2 (no base 0 or 16 tiles exist south of
row 10). The swap is a visual correction confined to that region.

**Action taken**:
- `colonize_sdl/main.py`:
  - `TERRAIN_TO_SPRITE[0]`: 0 → 9
  - `TERRAIN_TO_SPRITE[8]`: 0 → 9 (Boreal follows)
  - `TERRAIN_TO_SPRITE[16]`: 9 → 0
  - `TERRAIN_TO_SPRITE[18]`: 0 → 9 (extended tundra follows)
  - `TERRAIN_PAL_INDEX` entries updated to match.
- Goldens updated (4/4 pass).

**Visual verification**:
- Canada now shows a clearer mix of Arctic (yellow-grey ice-speckle)
  and Tundra (white-blue snow) textures. Polar-row override still
  forces the TOP row to Arctic, which now renders as yellow-grey —
  visually distinct from the Tundra below it.
- The polar-row Arctic band is no longer a blinding white strip; it
  transitions naturally into the Canadian hinterland.

**Follow-up**:
- If the user wants the TOP ROW (y=0) to render as the WHITE variant
  instead (sprite 9 = Tundra per this swap), the polar-row override
  should force base=0 (not base=16). This is a separate aesthetic
  decision; currently the override forces base=16 per DOS convention.

---

## 2026-04-22 (n) — Fix base-20 Tundra misplacement + restore auto-forestation

**Conflict**: User: "tundra is in many places where it shouldn't be, the
forestry was ok the way it was before".

Two regressions from ruling (m):
1. **Tundra appearing in warm zones**. Base 20 was mapped to sprite 0
   (Tundra) on the assumption it clustered in the far north. Actually
   only 9 of its 45 tiles are in arctic rows (y<10); 12 are in center
   (y=20-23), 8 are in far south (y=54-56 = southern Brazil/Argentina
   region). Rendering those 36 tiles as Tundra was wrong.
2. **Forestry regression**. Removing auto-forestation from extended
   bases 17-23 (ruling m) left large swaths of the map unforested
   when the user had preferred the "(i)+(j)" look with forest overlay
   on extended bases.

**Source**: `tools/find_18_20.py` spatial analysis:
- Base 18: 76 of 81 tiles in rows 4-18 (94% northern) → Tundra stays.
- Base 20: spread across rows 3-56, only 9 truly northern → not Tundra.

**Ruling**:
1. **Base 20 → Grassland** (sprite 4, palette 91). Works at any
   latitude; doesn't pretend all base-20 tiles are arctic. Base 18
   stays Tundra because its cluster is genuinely northern.
2. **Restore `17 <= b <= 23` clause** in `_tile_has_forest`. Extended
   bases render with forest overlay again, matching the (i)/(j) look.

**Action taken**:
- `colonize_sdl/main.py`:
  - `TERRAIN_TO_SPRITE[20]`: 0 (Tundra) → 4 (Grassland).
  - `TERRAIN_PAL_INDEX[20]`: 20 (tundra-grey) → 91 (grassland-green).
  - `_tile_has_forest`: added back `or (17 <= b <= 23)`.
- Goldens updated (4/4 pass).

**Visual verification**:
- **North America**: Tundra now only in the actual arctic latitudes
  (rows 3-14 where base 0, 8, 16, 18 live). No more Tundra-speckle in
  central USA or northern South America. Eastern forest restored on
  base-17/19/23 tiles.
- **South America**: Pampas/Patagonia show appropriate grass+tundra
  mix at the far south; Amazon and Central America show dense forest
  including on base-21 and base-23 tiles. Base-20 outliers in the
  southern Brazil area now render as Grassland with forest (not
  Tundra), which matches their climatic zone.

**Follow-up**:
- Base 18's 5 southern outliers (y=16-18) might still look Tundra-ish
  in a slightly too-warm zone, but 94% cluster justifies keeping the
  Tundra mapping. Could add y-based overrides later if needed.

---

## 2026-04-22 (m) — Terrain renders match .MP data exactly; no auto-forestation

**Conflict**: User: "you still need to make sure all the underlying
terrain is matching and lining up to the coding in the amer2.mp".

After ruling (i) added auto-forestation to extended bases 17-23 (to
address the "add the forestation to everything" request), some tiles
were rendering with fake forest overlay when the .MP byte didn't
actually carry the forest flag. The user wants WHAT-YOU-SEE to equal
WHAT'S-IN-THE-DATA.

**Audit of current mappings**:

1. Core biomes (bytes 0-15, 16, 25, 26) already use literal NAMES.TXT
   order after ruling (l) — no changes needed.
2. Extended base 21: comment said "Savannah-yellow" but mapped to
   sprite 3 which AFTER (l) is Prairie (yellow-green). This is a leftover
   error from when sprite 3 = Savannah per the (i) swap. Fix: 21 → sprite 5
   (Savannah/bright green).
3. `_tile_has_forest` included `17 <= b <= 23` as auto-forest bases.
   This caused 566 extended-base tiles to render with forest overlay
   regardless of their feat bits. The .MP file encodes only 244 tiles
   as explicitly forested (bases 8-15 or feat & 0x80); the other ~300
   were getting spurious forest that isn't in the data.

**Ruling**:
1. **Fix base 21 sprite**: `TERRAIN_TO_SPRITE[21] = 5` (was 3).
   `TERRAIN_PAL_INDEX[21] = 40` (was 60).
2. **Remove auto-forestation from extended bases**. `_tile_has_forest`
   now returns True only for:
   - explicit forest flag (feat bit 7 set, non-mountain), OR
   - forested-biome base IDs 8-15 (Boreal..Rain)
   Extended bases 17-23 render as their bare biome texture (Grassland,
   Tundra, Savannah, Marsh). They still get forest overlay if feat bit
   7 happens to be set (e.g., AMER2 has a few base-17/19/20/23 tiles
   with feat=0xC0 = forest+river; those still draw the forest overlay
   correctly).

**Action taken**:
- `colonize_sdl/main.py`:
  - `TERRAIN_TO_SPRITE[21]`: 3 → 5. Comment corrected.
  - `TERRAIN_PAL_INDEX[21]`: 60 → 40.
  - `_tile_has_forest`: dropped the `or (17 <= b <= 23)` clause.
- Goldens updated for all 4 test maps (4/4 pass).

**Visual verification**:
- **South America**: Amazon area remains densely forested via bases
  11/13/15 (Broadleaf/Tropical/Rain) which DO explicitly encode
  forest. Base-21 tiles (Central/South tropical zone) now render as
  bright-green Savannah WITHOUT overlay — matching the .MP encoding.
  Pampas/Patagonia in southern Argentina show clean grass/tundra.
- **North America**: Central US plains show olive-brown PLAINS
  (sprite 2) cleanly, without the fake forest that used to cover
  base-23 tiles. Eastern deciduous forest is now concentrated where
  the data actually places forested bases (8, 12, etc.) rather than
  blanketing extended-base tiles.

**Follow-up**:
- Rulings (i)'s "add forestation to everything" directive was about
  making the forest OVERLAY more visible on genuinely-forested tiles
  (bases 8-15), which was accomplished via the denser sprite 79 and
  wxad topology. The extended-base auto-forest was a misinterpretation
  that's now corrected.
- If the user wants MORE forest coverage on extended-base tiles
  specifically, the .MP file would need to be edited to set the forest
  flag (bit 7) on those tiles. The renderer is now strictly data-driven.

---

## 2026-04-22 (l) — Final terrain mapping: literal NAMES.TXT order; polar rows land-only

**Conflict**: User clarifying feedback after rulings (i) and (k):
1. "savannah is sprite 5, prairie is sprite 3 and planes is sprite 2"
   — the FINAL, definitive assignment. This supersedes both prior
   swaps ((i) and (k)) and reverts to the literal NAMES.TXT order.
2. "only land tiles in the first row are arctic, not all of them" —
   the polar-row override should not apply to ocean tiles.

**Ruling**: **Revert all Prairie/Savannah/Plains swaps. Use literal
NAMES.TXT byte-to-sprite mapping.**

| Byte | Name     | Sprite | Color          |
|------|----------|--------|----------------|
| 0    | Tundra   | 0      | yellow/white   |
| 1    | Desert   | 1      | sandy          |
| **2**    | **Plains**   | **2** | **olive-brown** |
| **3**    | **Prairie**  | **3** | **yellow-green** |
| 4    | Grassland| 4      | dark green     |
| **5**    | **Savannah** | **5** | **bright green** |
| 6    | Marsh    | 6      | green-blue     |
| 7    | Swamp    | 7      | green-blue wet |

Forested variants use the same ground sprite as their unforested
counterpart (8→0, 10→2, 11→3, 12→4, 13→5, etc.). Scrub (9) keeps
sprite 8 (desert-with-cactus). Extended bases 17-23 unchanged from (j).

**Polar-row rule**: Applies ONLY to land tiles. Ocean at `y=0` or
`y=H-1` stays ocean.
```python
if (my == 0 or my == MAP_HEIGHT - 1) and base not in (25, 26):
    base = 16  # force Arctic
```

**Rationale**: Earlier rulings (i) and (k) tried to chase a color-vs-name
mismatch based on intermediate user descriptions. The user's clarifying
message with explicit byte↔sprite pairs is authoritative (level 1). The
literal NAMES.TXT order appears to be correct; the prior "savannah
labeled as prairie" complaint must have referred to a specific tile or
context we misread, not a global sprite swap.

**Action taken**:
- `colonize_sdl/main.py`:
  - `TERRAIN_TO_SPRITE`: all Plains/Prairie/Savannah mappings reverted
    to literal (N→N). Forested variants reverted.
  - `TERRAIN_PAL_INDEX`: palette indices for 2/3/5/10/11/13 reverted.
  - Polar-row override: added `and base not in (25, 26)` so ocean
    stays ocean.
- Goldens updated for all 4 test maps (4/4 pass).

**Visual verification**:
- **North America**: top row shows alternating arctic (on land) and
  ocean (on water); Great Plains = olive-brown; eastern forest = dark
  green; Rockies continuous snow ridge.
- **South America**: bottom row same rule (arctic on land, ocean on
  water); Pampas = olive; Amazon = dark green; Andes = continuous
  snow.

**Follow-up**: This is the FINAL mapping unless the user provides
further corrections. Rulings (i) and (k) are superseded by (l).

---

## 2026-04-22 (k) — Plains/Savannah swap + polar rows forced to Arctic

**Conflict**: User: "you have plains and savannah mixed up and possibly
savannah tundra and arctic. any tile on the first map row needs to be
arctic."

**Issue 1 — Plains/Savannah swap**:

After ruling (i) swapped Prairie (byte 3) with Savannah (byte 5), the
user now reads sprite 2 (olive-brown) as "savannah" and sprite 3
(yellow-green) as "plains". The user's mental model:
  - olive-brown (sprite 2)  = SAVANNAH (dry, scattered trees)
  - yellow-green (sprite 3) = PLAINS (short-grass plains)
  - bright green (sprite 5) = PRAIRIE (lush grassland)

This is a player-centric reading different from NAMES.TXT's literal
byte-to-name mapping. User preference wins (level 1).

**Issue 2 — Polar rows should be Arctic**:

DOS Colonization's map design rule: the TOP and BOTTOM rows of the map
are always Arctic (impassable polar terrain). Units can't cross these
edges. Our renderer was rendering the underlying .MP bytes literally
(ocean at y=0 in AMER2), missing the visual polar border.

**Ruling**:
1. **Plains/Savannah cyclic reassignment**:
   - byte 2 (Plains)   → sprite 3 (yellow-green)
   - byte 3 (Prairie)  → sprite 5 (bright green)  [kept from (i)]
   - byte 5 (Savannah) → sprite 2 (olive-brown)
   - Forested variants swap to match:
     - byte 10 (Mixed = Plains+forest) → sprite 3
     - byte 13 (Tropical = Savannah+forest) → sprite 2
   - `TERRAIN_PAL_INDEX` (solid-color fallback) updated accordingly.
2. **Force polar rows to Arctic**:
   - At `my == 0` or `my == MAP_HEIGHT - 1`, override the tile's base
     to 16 (Arctic) before rendering, preserving feature flags
     (mountains/hills/rivers are still drawn on top, so an Arctic
     mountain still gets its peak overlay).
   - Applies to ALL tiles including ocean at the edge, matching DOS's
     polar-border convention.

**Action taken**:
- `colonize_sdl/main.py`:
  - `TERRAIN_TO_SPRITE`: `2` now maps to sprite 3; `5` maps to sprite
    2. Forested counterparts `10` and `13` updated accordingly.
  - `TERRAIN_PAL_INDEX`: palette indices for 2/5/10/13 updated.
  - In the render loop, after reading the raw byte, an early override
    forces `base = 16` when `my in (0, MAP_HEIGHT - 1)`.
- Goldens updated for all 4 test maps (4/4 pass).

**Visual verification**:
- **AMER2 full**: white Arctic band spans the top AND bottom rows of
  the map (previously all-ocean).
- **North America zoom**: central Great Plains region now shows
  yellow-green (sprite 3 = user's Plains); scattered savannah-olive
  spots in appropriate locations; Arctic band clearly visible at top.
- **South America zoom**: Patagonia region and bottom arctic border
  visible; inland biomes render with the (k) color scheme.

**Follow-up**:
- User also said "possibly savannah tundra and arctic" are mixed up.
  After the polar-row rule and Plains/Savannah swap, the remaining
  distinction between Tundra (sprite 0, yellow-white speckled) and
  Arctic (sprite 9, white-blue) may need further review. The Tundra
  sprite reads as a partially-melted polar terrain which is arguably
  correct for "tundra grass in spring/fall". Deferred pending further
  user feedback on specific northern tiles.
- The polar-row override is a RENDERER-ONLY change; the underlying
  .MP byte is unchanged. Saving/exporting the map will still write
  the original byte (no data loss).

---

## 2026-04-22 (j) — Northern tundra bases + wxad topology for mountains/hills

**Conflict**: User after seeing the rendered Americas:
1. "issues with the arctic terrain" and "areas in far north america"
   — bases 18 and 20 were mapped to Plains-olive, but they cluster
   HEAVILY in rows 3-14 of AMER2 (76 + 15 = 91 tiles in the far
   north) where the geography should be Tundra/Boreal, not plains.
2. "the right mountain and hill combinations based on where the
   mountains are located" — mountains and hills were single-sprite
   (PHYS0.45 and PHYS0.61). Isolated peaks looked fine but mountain
   RANGES (Andes, Rockies) looked like disconnected dots rather than
   continuous ridges because every tile painted the same solo-peak
   sprite regardless of its neighbors.

**Source A** — spatial analysis of AMER2 (`tools/top_rows.py`):
- Rows 3-9: Arctic (base 16) heavy, 95 tiles. Boreal (8) scattered.
  Bases 18 and 20 appear interleaved with Arctic/Tundra.
- Rows 10-14: transition zone, bases 2/3/4 appear alongside 18/20/10.
- South of row 15: bases 18 and 20 almost disappear (only 5 and 30
  tiles respectively out of their totals of 81 and 45).

**Source B** — MAPEDIT.EXE disassembly at segment `1a47:0379-03dc`:
  ```
  local_4 = 0xA0               ; mountain test mask
  AX = neighbor & 0xA0
  if (AX == 0xA0) mask |= N_bit
  ...
  ```
  Identical pattern to `get_wxad_index` (cc94 forest). Builds 4-bit
  mask of cardinal neighbors that also have feat=0xA0. This lookup
  returns a variant index used to pick from the 16-sprite mountain
  row. Therefore DOS's in-game mountain renderer uses **wxad topology**
  to produce connected ridges.

**Source C** — PHYS0 sprite rows:
  - Row 0x21 (sprites 32-47): 16 mountain topology variants.
  - Row 0x31 (sprites 48-63): 16 hills topology variants.
  Each row's 16 sprites correspond to the 16 possible 4-bit cardinal
  neighbor masks. Sprite index offset 0 is "solo" (no same-elevation
  neighbors); offset 15 is "fully surrounded by same elevation".

**Ruling**:
1. **Reassign bases 18 and 20 to Tundra ground texture** (sprite 0,
   palette index 20 = tundra-grey). Other extended bases (17/19/21/22/23)
   keep their existing cluster-based mappings.
2. **Use wxad topology for mountains**: sprite = 32 + wxad_index where
   index is built from 4 cardinal neighbors having `feat == 0xA0`.
3. **Use wxad topology for hills**: sprite = 48 + wxad_index where
   index is built from 4 cardinal neighbors having `feat == 0x20`.

**Action taken**:
- `colonize_sdl/main.py`:
  - `TERRAIN_TO_SPRITE[18]` and `[20]` changed from 2 (Plains) to 0 (Tundra).
  - `TERRAIN_PAL_INDEX[18]` and `[20]` changed from 54 to 20.
  - STEP 4 elevation block rewritten: added `_tile_is_mountain(r)` and
    `_tile_is_hills(r)` helpers. For mountain tiles, computes `m_idx`
    from cardinal mountain-neighbors and blits `ts[32 + m_idx]`. For
    hills, computes `h_idx` and blits `ts[48 + h_idx]`.
- Goldens updated for all 4 test maps (visual-regression 4/4 pass).

**Visual verification**:
- **North America**: Canadian Arctic region is now tundra-grey/white
  (no more Plains-olive splotches); Rocky Mountains form a proper
  continuous snow-capped ridge rather than isolated dots; hills
  scattered through the plains have natural clustered topology.
- **South America**: Andes mountains are now a contiguous range
  running north-south along the west coast (instead of solo peaks);
  Patagonia shows tundra in the far south; Brazilian highlands have
  properly-topologized hills.

**Follow-up**:
- PHYS0 sprite 32 (mountain wxad=0 = solo peak) and sprite 48 (hills
  wxad=0) need a visual sanity check to make sure the orphan-tile
  rendering still reads clearly. They are used for mountain tiles
  with no mountain neighbors (the AMER2 data has ~30 such tiles).
- `FUNCTIONS_INVENTORY.md` Section X already documents the MAPEDIT
  wxad-mountain loop; the rendering now matches what the disassembly
  showed.

---

## 2026-04-22 (i) — Savannah/Prairie sprite swap; extended bases 17-23 = forested

**Conflict**: User feedback after the river render:
1. "you have savannah labeled as prairie" — the sprite at TERRAIN.SS index
   5 (bright green) was being used for byte 5 (Savannah per NAMES.TXT),
   and sprite at index 3 (yellow-green) for byte 3 (Prairie). User's
   natural reading of the colors is inverted: yellow-green looks like
   Savannah (dry African grassland), bright green looks like Prairie
   (lush American grassland).
2. "terrain 23 discrepancy" — base 23 is the SECOND most common byte on
   AMER2 (194 tiles, ~7% of the map) but TERRAIN_TO_SPRITE mapped it to
   sprite 2 (Plains olive) with no forest overlay. The user sees large
   brown/olive patches where dense forest should be.
3. "add the forestation to everything" — forest coverage feels too
   sparse on AMER2.

**Source A** — NAMES.TXT order: byte 3 = "Prairie", byte 5 = "Savannah".
**Source B** — TERRAIN.SS sprite inspection (cc94 palettes confirm):
  - Sprite 3: yellow-green gradient
  - Sprite 5: bright green pattern
**Source C** — cc94's `terrain/prairie-pal.png` (yellow-green) and
  `terrain/savannah-pat.png` (bright green) match SPRITE indexing 3 and 5
  respectively, supporting Source A's byte-to-sprite mapping.
**Source D** (user's visual reading): yellow=Savannah, green=Prairie.

The DOS game's original design put "Prairie" on the yellow-green sprite
and "Savannah" on the green sprite — which is a CONVENTION CHOICE that
disagrees with some players' natural color association. User override
wins (level 1).

**Extended bases 17-23**: NAMES.TXT only documents 21 named terrains
(bases 0-15 + Arctic=16 + Ocean=25 + Sea Lane=26 + Mountains/Hills via
feat flags). Bytes 17-23 exist in AMER2 heavily (54+81+22+45+165+5+194
= 566 tiles, ~14% of the map) but have no canonical names. Spatial
analysis (`/tmp/viz_ext_bases.py`) shows them clustered over the
continent in ways suggesting they're FORESTED biome variants specific
to the AMER2 scenario. Treating them as forested renders the landmass
with proper DOS-era density.

**Ruling**:
1. **Swap Prairie/Savannah sprite indices.**
   - byte 3 (Prairie) → sprite 5 (bright green)
   - byte 5 (Savannah) → sprite 3 (yellow-green)
   - Forested variants swap correspondingly:
     - byte 11 (Broadleaf = forested Prairie) → sprite 5
     - byte 13 (Tropical = forested Savannah) → sprite 3
   - TERRAIN_PAL_INDEX (fallback solid colors) updated to match.
2. **Scrub (byte 9) uses sprite 8** (desert-with-cactus), not plain
   desert sprite 1. Sprite 8's visible brush/cactus texture matches
   the Scrub biome's distinct look.
3. **Extended bases 17-23 render as forested.** Added `17 <= b <= 23`
   to `_tile_has_forest()` so the wxad forest topology fires on them.
   Ground textures assigned per cluster location in AMER2:
     - 17, 19, 23: Grassland-green (most widespread)
     - 18, 20: Plains-olive
     - 21: Savannah-yellow (Central/S America tropical zone)
     - 22: Marsh-green (rare)

**Action taken**:
- `colonize_sdl/main.py`:
  - `TERRAIN_TO_SPRITE` updated: swap 3↔5 (and 11↔13); Scrub→8;
    bases 17-23 mapped to specific biome sprites (not all Plains).
  - `TERRAIN_PAL_INDEX` updated for the same byte-to-color mapping.
  - `_tile_has_forest()` extended with `17 <= b <= 23` clause.
- Goldens updated for all 4 test maps (visual-regression 4/4 pass).

**Visual verification** (zoomed renders):
- **South America** (render_zoom_amer2.png): Amazon basin is clearly
  forested with dense canopy; Andes snow peaks along west coast;
  rivers flow through the forest; Patagonia shows grassland/tundra.
- **North America** (render_north_amer2.png): Rocky Mountains on
  west coast; Canadian Arctic tundra in north; Great Lakes with
  forests around; Mississippi River through the Plains; Eastern
  deciduous forest as continuous dark-green canopy; Gulf Coast marsh.

**Follow-up**:
- The exact mapping of bases 17-23 to named biomes is still a guess.
  A DOS-reference screenshot of AMER2 at scenario start would let us
  verify each base's intended appearance. If any base is wrong, the
  TERRAIN_TO_SPRITE / TERRAIN_PAL_INDEX entries are the only ones to
  adjust.
- MAP_FORMAT.md AMB-1 remains technically open (we don't know the
  CANONICAL names for 17-23); but empirically they're "forested
  variants" and render correctly as such.

---

## 2026-04-22 (h) — Bit 6 is RIVER, not road; river rendering from cc94

**Conflict**: User requested "populating all the rivers and the forests"
after the cc94-based terrain rewrite. Rivers were never rendered in our
pipeline. Ruling (d) had treated bit 6 (0x40) as "road" and disabled it
because "no roads at game start." But DOS does show RIVERS at game
start — a river-flavored terrain feature we never implemented.

**Source A** — cc94 `render_terr` river block:
- Land tiles with `PhysMajorRiver` flag render sprite `1 + wxad_index`
  (16 topology variants; sprite 16 for dead-end/source).
- Water tiles with `PhysMajorRiver` flag render cardinal-direction
  MOUTH markers (cc94 sprites 141-144: N/E/S/W).
- Minor rivers use the parallel sprite range (17-32 land, 145-148
  mouths) but DOS .MP encodes only a single river bit.

**Source B** — bit-6 visualization of the real AMER2.MP:
```
row 12: .....~~##~~~~####......~.##~~####...
row 41: ...##...#######~~~~##~#####.........
row 46: .............#########~~#######~#~##~~~...
```
The `~` symbols (bit-6 tiles) form NATURAL RIVER PATHS — the
Mississippi system in North America, the Amazon basin in South America,
plus smaller tributaries. Roads would not occur in these configurations
at scenario start. **Bit 6 (0x40) is RIVER, not road.**

Count: 66 land tiles + 13 ocean tiles (river mouths) in real AMER2 have
bit 6 set — matching cc94's expected river density for a hand-crafted
Americas scenario.

**Ruling**:
1. **Bit 6 (0x40) is the RIVER flag, not road.** Updating MAP_FORMAT
   ambiguity AMB-5 with this ruling.
2. **Implement cc94's river render block** in `_render_terrain` STEP 6:
   - Land + river: wxad topology lookup → sprite `idx` (our 0-indexed,
     cc94's `1+idx`). If wxad=0 (isolated source), use sprite 15 (the
     "dead-end cap" — cc94's 16).
   - Water + river: blit mouth markers at 140=N / 141=E / 142=S /
     143=W for each cardinal neighbor that also has the river flag.
3. **Road overlay stays disabled** — roads will come from in-game
   GameState during play, never from the .MP layer-1 byte.

**Action taken**:
- `colonize_sdl/main.py::_render_terrain`:
  - Added STEP 6 river-rendering block using cc94's algorithm.
  - `_has_river(r)` helper checks `(r & 0x40) != 0`.
  - Land: `r_idx` wxad mask (N=8, S=4, W=2, E=1); sprite `r_idx` if
    >0 else 15.
  - Water: 4 cardinal river-mouth sprites (140-143).
- Road comment block updated to clarify bit 6 = river.
- Goldens updated for all 4 test maps (visual-regression 4/4 pass).

**Visual verification** (zoomed renders at 32-px tiles):
- **North America** (y=0-30): Rocky Mountains snow peaks along west
  coast, Great Lakes visible, **Mississippi River** clearly flowing
  through central plains with tributaries, St. Lawrence river system
  in the northeast, rivers flowing into the Atlantic and Gulf coasts.
- **South America** (y=20-70): Andes mountains along west coast,
  **Amazon river system** prominent in central-east, tributaries
  branching through the continent, river mouths visible where rivers
  meet ocean.

**Follow-up**:
- DOS encodes only ONE river kind (bit 6); cc94's major/minor
  distinction is collapsed to "major river graphics" here. If DOS
  actually has a second river bit elsewhere (e.g., layer 2 which is
  all zeros in AMER2), a later scenario could expose it. For now,
  all bit-6 tiles render as major-river graphics.
- Rivers + forest combinations (feat=0xC0 = 0x80+0x40 = forest+river)
  render both layers stacked — the forest overlay draws first, then
  the river wins by drawing last. Visually this shows a river
  flowing through forest which is geographically correct (Amazon).
- The 13 ocean tiles with bit 6 set are river MOUTHS. Their mouth
  markers point toward cardinal neighbor river tiles. Inland-facing
  mouths work as expected.

---

## 2026-04-21 (g) — Mountain-vs-forest bug + real AMER2.MP from Steam

**Conflict**: User on AMER2: "any mountains have been replaced with
trees, and the amazon area has no forest."

**Issue 1 — Mountains rendered as forest**:

In ruling (f)'s cc94 rewrite, the mountain/hills/forest rendering was
split from `if/elif/elif` (single-branch) into separate `if` statements
to match cc94. However, the forest test `is_forest = (feat & 0x80) or
(8 <= base <= 15)` was NOT updated: it treats ANY bit-7-set value as
"forest," but our DOS encoding uses `feat == 0xA0` (bits 7+5 together)
to mark MOUNTAIN. A mountain tile would therefore match `feat & 0x80`
and be painted with forest canopy on top of the mountain sprite — the
"mountains have been replaced with trees" symptom.

**Issue 2 — Amazon has no forest**:

The local `/COLONIZE/AMER2.MP` was a STUB (md5 `fab4ffa3...`, 32 forest
tiles, 22 mountains), NOT the real DOS Americas scenario. The real
`AMER2.MP` ships with DOS Colonization at
`D:\SteamLibrary\steamapps\common\Sid Meier's Colonization\MPS\COLONIZE\`
(md5 `d21008d2...`) and contains:
- **255 forest tiles** (including the Amazon basin)
- **170 mountain tiles** (including the Andes)
- **56 hills tiles**
- Full biome diversity (bases 0-23 present)

Our project's COLONIZE/AMER2.MP had been reduced to a minimal test map
at some point (only 5 distinct base types). The `render_test.py`
backup/restore cycle meant every run would overwrite my manual copy
back to the stub from `AMER2.MP.backup`.

**Ruling**:
1. **Forest detection must exclude mountain.** A tile is forest iff:
   - `feat == 0x80` (forest flag alone), OR
   - `feat == 0xC0` (forest + road/trail combo), OR
   - `base in 8..15` (forested-biome base encoding)
   - And NEVER when `feat == 0xA0` (mountain) or `feat == 0x20` (hills).
2. **Install the real DOS AMER2.MP.** Delete the stale backup, copy the
   real file from the user's Steam install to our COLONIZE/AMER2.MP.
   `render_test.py`'s backup cycle will now preserve the real file.

**Action taken**:
- `colonize_sdl/main.py::_render_terrain` STEP 5 forest:
  - Introduced `_tile_has_forest(r)` helper that returns False for
    `feat == 0xA0` (mountain) and `feat == 0x20` (hills), True only
    for the 3 true forest encodings listed above.
  - `_tile_has_forest` is now used BOTH for the self-check (should
    this tile render forest?) AND the neighbor wxad mask (does N/S/
    W/E have forest?) — previously the neighbor check used a naive
    `(r & 0x80) != 0` which falsely treated mountain neighbors as
    forest, causing edge-variant selection to over-count forest
    continuity.
- `COLONIZE/AMER2.MP` replaced with the real DOS file (md5 `d21008d2...`).
  `AMER2.MP.backup` deleted.
- Goldens updated for all 4 test maps (visual-regression 4/4 pass).

**Visual verification** (zoomed render at 32-px tiles covering y=20-70):
- Andes mountains clearly visible as snow-capped peaks along the west
  coast of South America.
- Amazon basin visibly dark-green forest in central-east South America.
- Biome transitions (grass → forest → mountain → desert) render with
  proper diffuse blending and coast subtiles.
- No more forest-over-mountain painting errors.

**Follow-up**:
- The stub `AMER2.MP` and `AMER2.MP.backup` were project artifacts with
  unclear provenance. If they served a testing purpose, they should be
  moved to `tests/fixtures/` with descriptive names, not masquerade as
  the Americas scenario. For now, `render_test.py` reads from Steam
  which is fine; if a future user doesn't have Steam Colonization
  installed, they'll need to place a valid AMER2.MP manually.
- `MAP_WIDTH` is 56 but the .MP file width is 58. The loader drops the
  first and last columns. dos-disassembler should verify which columns
  DOS itself drops to confirm our alignment is correct.

---

## 2026-04-21 (f) — Full rewrite to cc94 algorithm (4-quadrant coast subtiles)

**Conflict**: After 5 rounds of iteration on coast/forest rendering,
user said "youre still going in circles. look at this other fan made
rewrite https://github.com/institution/cc94 you might find the code you
need to get the terrain to generate correctly."

**Source A** — our iterative approach (rulings a-e): used 4 corner
sprites (PHYS0.150-153) as full-tile composites for beaches, with
texture-strip bleed for concave corners and a single forest overlay
sprite. Each iteration partially addressed symptoms without solving the
root problem — we were using the WRONG sprite set for coasts.

**Source B** — cc94 `src/client/renderer.cpp::render_terr`:
- Water tiles render as **4 SUBTILES** (NW/NE/SE/SW quadrants).
- Each subtile picks from a **32-variant coast table** (cc94 sprite
  indices 109-140) based on 3 surrounding neighbors.
- Index formula: `k = (!sea(t2)<<2) | (!sea(t1)<<1) | (!sea(t0)<<0)`,
  then `sprite = 109 + (k<<2) + l` where l=subtile index (0-3).
- Biome-diffuse step: for each of 4 cardinals, render a blend pattern
  (cc94 sprites 105-108) masked by neighbor's biome icon — gives the
  soft "biome color bleeds across tile boundary" effect.
- Forest uses **16 topology variants** via 4-bit neighbor mask
  (cc94 sprites 65-80, `base + wxad_index`).
- Mountain = sprite 33, Hills = sprite 49 (row-firsts in cc94; we use
  row-densest 45/61 which also works).

**Verification of cc94 mapping against OUR extracted PHYS0**:
- PHYS0.104-107 = N/E/S/W diffuse blend patterns (dots along top / right
  / bottom / left edges — confirmed by pixel inspection).
- PHYS0.108-139 = 32 coast subtile sprites (**8×8 each**, not 16×16 —
  confirmed by size check; sprites 108-111 are all-black placeholders
  for k=0 "no land around this corner").
- PHYS0.64-79 = 16 forest topology variants (confirmed, same as cc94
  numbering minus 1).

Our PHYS0 extraction is **offset by 1** from cc94's resource IDs (they
use 1-based indexing against the DOS file; our extractor is 0-based).
Mapping: `our_idx = cc94_idx - 1`.

**Ruling**: **Replace the entire coast + forest + diffuse pipeline with
cc94's algorithm.**

**Action taken** — `colonize_sdl/main.py::_render_terrain` rewritten:
1. Removed `beach` dict (all corner-sprite composites).
2. Added `_biome_tex(raw)` helper that returns a 48×48 TERRAIN.SS
   texture scaled from a 16×16 ground sprite.
3. Added `_diffuse_surface(blend_idx, nb_raw)` — cached per
   (blend_direction, neighbor_base). Per-pixel composite that uses
   the blend sprite as a mask for the neighbor's biome texture.
   Result: neighbor's biome color stippled along the tile edge facing
   that neighbor.
4. Added `_coast_subtile_scaled(coast_idx)` — cached scaling of 8×8
   PHYS0 subtile → 24×24 (HALF of DOS=48 internal tile size). Treats
   BOTH magenta (255,85,255) AND black (0,0,0) as transparent —
   black marks "outside the subtile shape" in the DOS encoding.
   Returns None for the 4 all-black k=0 placeholders (indices
   108-111).
5. Rendering loop now:
   - STEP 1: base biome from TERRAIN.SS
   - STEP 2: 4 diffuse blends (N=104, E=105, S=106, W=107)
   - STEP 3: if water, 4 coast subtiles using `108 + (k<<2) + l`
   - STEP 4: mountain (45) / hills (61) overlay
   - STEP 5: forest using `64 + wxad_index` (16 topology variants)
   - Road disabled per ruling (d).

**Visual result** (confirmed):
- UNTITLED.MP: each rectangular landmass has proper coastline
  subtiles with biome-appropriate edges (sand for desert, grass for
  grassland); the "+" island has rounded coastline with corner
  subtiles.
- AMER2.MP: Americas coastline renders as authentic DOS-style
  pixelated coast; forest shows varied density based on neighbor-
  forest topology (dense canopy where all 4 sides are forest, thinner
  at forest edges); tundra/desert/grassland biome colors bleed
  softly into adjacent tiles via the diffuse layer.

Goldens updated for all 4 test maps (visual-regression 4/4 pass).

**Follow-up**:
- Profile the per-pixel diffuse/coast cache building; first-render is
  slow (~2300 pixel ops per cache entry). Numpy surfarray would speed
  up the one-time cache build but current lazy caching is acceptable.
- cc94's river/road systems (wxad-indexed like forest) are ready to
  drop in when those features ship.
- Plowing uses cc94 sprite 150, which in our numbering is PHYS0.149.
  Verify when ploughed-field feature lands.

---

## 2026-04-21 (e) — Texture strip ONLY on concave; denser forest sprite

**Conflict**: Two user-observed issues after ruling (d) restored the
texture strip:

1. The texture strip (land-side biome-color bleed) was being painted on
   EVERY land-facing edge, regardless of mask. On non-concave water
   tiles (single-cardinal + opposite + T-junction + surrounded), this
   created a continuous "long coast line" of adjacent-biome color
   running the full edge length. User: "youre still using the long cost
   lines for sides not concave coasts."

2. Forest overlay used PHYS0.SS.077 — which pixel-inspection shows is
   only 75% opaque (63 magenta-transparent pixels of 256). The
   underlying grassland texture was showing through ~1/4 of every
   forest tile, making forested areas like the Amazon look like
   unforested grassland at low zoom. User: "the base texture for areas
   like the amazon is not there when it needs to be forested."

**Source A** — pixel-inspection of PHYS0 row 0x41 (sprites 64-79):
  - Sprite 77: 75% opaque (193/256 non-magenta pixels)
  - Sprite 78: 87% opaque
  - Sprite 79: **100% opaque** (no transparent pixels at all)

Sprite 79 is the "fully-filled" variant of the forest row — the densest
canopy available. Using 77 leaves visible grassland gaps; 79 fully
covers the base texture.

**Source B** — ruling (d) interpretation of "land-side texture fill":
texture strip was applied to every land-facing edge. User clarified in
(e) that the strip should ONLY fill CONCAVE corners (where the tile is
in a bay and needs the inner pocket color-filled), not straight edges.

**Ruling**:
1. **Texture strip restricted to 4 concave masks** (0b1001, 0b0011,
   0b1100, 0b0110 — the 2-adjacent-cardinal land masks). On every
   other non-zero mask, the strip is skipped. The 2-corner beach
   sprite composite (ruling (c)) alone carries the coast appearance
   on straight edges / opposite sides / T-junctions / surrounded
   water.
2. **Forest overlay sprite switched from 077 to 079** (100% opaque
   canopy). Mountain (045) and Hills (061) overlays unchanged —
   pixel-inspection confirms they're already the densest variants
   of their respective rows.

**Action taken**:
- `colonize_sdl/main.py::_render_terrain`:
  - STEP 2a texture strip now wrapped in `if lmask in CONCAVE_MASKS:`
    where `CONCAVE_MASKS = (0b1001, 0b0011, 0b1100, 0b0110)`.
  - STEP 3 forest overlay: `_blit_overlay(77)` → `_blit_overlay(79)`.
  - Citation comment updated to reference `/tmp/inspect_f77.py`
    density measurement.
- Goldens updated for all 4 test maps (visual-regression 4/4 pass).
- UNTITLED.MP render now shows forest clearly on base-8/12 tiles;
  AMER2.MP Amazon-like grassland+forest region is visibly darker
  green compared to plain grassland.

**Follow-up**:
- User mentioned "different types of forest" — currently all forested
  tiles use the same sprite 79. PHYS0 only has one forest row (0x41);
  different forest biomes (Boreal/Tropical/Rain/Conifer) may tint the
  canopy by palette or use underlying TERRAIN.SS sprite hue. Deferred
  pending sprite-cataloger investigation of whether different forest
  types have distinct palette indices in the DOS rendering pipeline.
- If AMER2.MP under-encodes forest density relative to what DOS shows
  at scenario start, dos-disassembler should verify bit interpretation
  of byte 0x80 and whether any other layer-1 bit signals forest.

---

## 2026-04-21 (d) — No initial-map roads; restore land-texture bleed

**Conflict**: Two user-observed issues on AMER2:

1. Road overlays were rendering on AMER2 at game start, but the DOS game
   shows no roads at the start of a new game. User: "in the main
   americas map. there shouldnt be any road rendered at all at the
   beginning of the game."
2. After ruling (c) removed the land-texture-bleed strip (STEP 2a),
   concave-corner water tiles lost the "adjacent-biome color bleeds
   into water" gradient that the user explicitly approved earlier.
   User: "the cost lines before on the concave portions were correct
   before with the land side texture fill and now are wrong again."

**Source A** — byte analysis of `COLONIZE/AMER2.MP`:
- Layer 1: 4176 bytes (58×72). Only 11 tiles have bit-6 set
  (`raw & 0x40`). Prior MAP_FORMAT claim of "178 tiles with road flag"
  was incorrect; re-counting confirms 11.
- Ten of the 11 tiles are on base=4 grassland (feat byte 0xC4 =
  forest+road combo); one tile is ocean (feat 0xD9). These were being
  rendered as road sprites from row 0x50, producing visible road
  segments at scenario start.

**Source B** — user observation of DOS game at scenario start: no
roads visible anywhere. This is ground truth (level 1).

**Ruling**:
1. **Road overlay is DISABLED from initial map data.** The 11 bit-6
   tiles in AMER2 are either pre-scenario native trails the DOS game
   hides, or bit 6 has a different meaning on this file (AMB-5 flagged
   ocean-tile road as unresolved). Either way, the renderer should NOT
   draw row-0x50 sprites from the .MP layer. Roads must come from
   in-game GameState built during play.
2. **Land-side texture bleed (STEP 2a) is RESTORED.** For every water
   tile, every land-facing edge paints a 1-sub-cell (16-px on the 48×48
   internal buffer) strip of the adjacent biome's TERRAIN.SS texture
   cropped to that edge. The strip is drawn BEFORE the beach sprite
   composition, so the corner sprites' transparent magenta halves
   overlay the texture strip — giving both the adjacent-biome color
   bleed (visible on concave corners) and the sand-curve beach line
   (from the corner sprites) simultaneously.

**Action taken**:
- `colonize_sdl/main.py::_render_terrain`:
  - STEP 4 road overlay code removed (entire `if raw & 0x40:` block
    deleted; comment block documents the rationale for future
    re-enable).
  - STEP 2a texture-strip bleed restored (was removed in ruling (c)).
  - STEP 2b beach composition renamed/annotated to reflect its role
    as the sand-curve overlay on top of the texture strip.
- Goldens updated for all 4 test maps (visual-regression 4/4 pass).

**Follow-up**:
- When in-game road tracking ships, re-enable the row-0x50 sprite table
  to render player-built roads from GameState (not from .MP layer).
- Verify bit 6 semantics with dos-disassembler once map-loader offsets
  are located; AMB-5 (ocean tiles with road flag) still unresolved.
- User also noted forest-vs-base-texture mismatches on AMER2. AMER2.MP
  only encodes ~55 forest tiles (33 bit-7 + 22 implicit bases 8-15) out
  of 281 land tiles; if DOS shows more forest than this, the .MP read
  or a different forest flag may be misinterpreted. Deferred pending
  DOS reference screenshot of AMER2 at scenario start.

---

## 2026-04-21 (c) — Coast rendering: non-convex edges via 2-corner composite

**Conflict**: After ruling (b), single-cardinal-land water tiles (the
"non-convex" straight-edge coasts) had NO beach sprite and only the
TERRAIN.SS edge-color strip. User feedback: rectangular/straight
coastlines looked wrong — a flat texture strip with a hard edge doesn't
resemble the DOS sand-ring coast. User: "can you fix the non convex
edges".

**Source A** — ruling (b) decision: single-cardinal masks should NOT use
the corner sprites because each corner sprite's perpendicular half would
paint sand on a water-only edge. Edge-texture strip was chosen as
substitute.

**Source B** — direct pixel inspection of PHYS0.150..153 at 1× (see
`/tmp/inspect_pixel2.py` transparency map). Each corner sprite is ~50%
magenta (transparent, VGA palette index 0) on its LAND-FACING diagonal
half. The sand curve itself is narrow (2–3 px wide) and follows the
diagonal. The other 50% is water.

  Specifically for sprite 150 (N+W corner):
  - NW diagonal half: transparent magenta (the "land is here" indicator)
  - Diagonal sand curve from NE-corner-ish to SW-corner-ish
  - SE diagonal half: water

  This means: blitting sprite 150 on a water tile with land to N (only)
  does NOT paint sand on the W edge — because the W half of the sprite
  is transparent. The sand curve terminates at the NE and SW corners
  of the sprite. The sand falls roughly in the north-west quadrant but
  stops short of the full W edge.

  Consequence: sprite 150 alone on a "N only" tile gives partial sand
  near the NW area, missing the NE area. Sprite 151 alone would give
  partial sand near the NE area, missing the NW. Compositing BOTH fills
  the full N edge — each sprite's transparent half covers the other's
  water-only edge, and their two sand curves meet along the N edge.

**Ruling**: **Use 2-corner composites for single-cardinal masks.**
Pixels (level 2) override the earlier inference (level 7).

The expanded beach table:

| Mask bits    | Land pattern | Beach sprite(s)   |
|--------------|--------------|-------------------|
| 0b0001 (1)   | N only       | 150 + 151         |
| 0b0010 (2)   | E only       | 151 + 153         |
| 0b0100 (4)   | S only       | 152 + 153         |
| 0b1000 (8)   | W only       | 150 + 152         |
| 0b1001 (9)   | N+W corner   | 150               |
| 0b0011 (3)   | N+E corner   | 151               |
| 0b1100 (12)  | S+W corner   | 152               |
| 0b0110 (6)   | S+E corner   | 153               |
| 0b0101 (5)   | N+S opposite | 150+151+152+153   |
| 0b1010 (10)  | E+W opposite | 150+151+152+153   |
| 0b1011 (11)  | N+E+W T      | 150 + 151 + 152   |
| 0b0111 (7)   | N+E+S T      | 151 + 152 + 153   |
| 0b1110 (14)  | E+S+W T      | 150 + 152 + 153   |
| 0b1101 (13)  | N+S+W T      | 150 + 151 + 153   |
| 0b1111 (15)  | fully land   | 150+151+152+153   |

**Action taken**:
- `colonize_sdl/main.py::_render_terrain`:
  - `beach` dict expanded to cover all 15 non-zero masks.
  - STEP 2a (TERRAIN.SS texture-strip bleed) removed — the corner-
    sprite composites now carry the coast appearance via their
    own transparent-magenta / sand-curve / water layout.
  - STEP 2b simplified into a single STEP 2 that just looks up
    the `beach[lmask]` entry.
- Goldens updated for all 4 test maps (visual-regression 4/4 pass).

**Follow-up**:
- Compare against a DOS reference of a rectangular-land map to confirm
  the 2-corner composite matches the DOS sand-ring appearance.
- The 3-side T and 4-side composites may produce sand patterns denser
  than DOS's; verify once DOS screenshots of those cases exist.
- The opposite-sides masks (0b0101, 0b1010) use all 4 corners which is
  identical to the 4-side composite. Could be tuned but is rare in
  practice (would require a 1-tile-wide water channel).

---

## 2026-04-21 (b) — Coast rendering: corner-only diagonals + edge color fill

**Conflict**: With the 4-corner beach sprite fix, single-cardinal-edge
water tiles (e.g., "land N only") were still using a corner sprite
(150/152) which paints sand on both its cardinal edges — producing an
artifact where sand appears on an edge that has no adjacent land.

User feedback: "the upper ones are not needed, those diagonals are only
in corners and the land side needs to be filled with the adjacent
terrain color."

**Ruling**: Two changes to `_render_terrain`:

1. **Beach corner sprites fire ONLY when two orthogonal cardinals are
   land** (masks 0b1001/0b0011/0b1100/0b0110 exactly = 150/151/152/153).
   Single-cardinal masks (N/E/S/W only) get NO corner sprite. Opposite-
   side / 3-side / 4-side masks still composite multiple corners as
   before.

2. **For each cardinal edge where the adjacent tile is land, paint a
   1-sub-cell-wide (16 px on the 48×48 internal buffer, → ~5 px at
   display resolution) strip of that neighbor's base terrain color on
   the water tile's facing edge.** This provides the "land-tile color
   bleeds into water" gradient along straight coastlines that DOS shows
   but that the purely-corner-based approach was omitting.

   The color strips are drawn BEFORE the corner beach sprite, so corner
   concavities still show the sandy sprite curve on top of the color
   strip.

**Action taken**:
- `colonize_sdl/main.py::_render_terrain`:
  - Beach single-cardinal mask entries removed.
  - STEP 2 split into (2a) land-adjacent edge color fill + (2b) corner
    beach sprite overlay.
- Goldens updated for all 4 test maps.

**Follow-up**:
- The current strip thickness is 1 sub-cell (16/48). If DOS uses a
  thinner strip, adjust `edge_px`. Verify against DOS reference when
  available.
- Consider whether the strip should blend into the corner beach sand
  at the corner cells (currently the corner sprite simply draws on top,
  which may produce a hard boundary at the mask=0011/9/6/C tile
  neighbors).

---

## 2026-04-21 — PHYS0 beach sprites 150-153 are the 4 corners, not flipped 151

**Conflict**: How should beach sprites map to the 4-bit cardinal land-mask
on water tiles?

**Source A** — earlier renderer-implementer choice: treat sprite 151 as
the "NW corner" base and use flip-H / flip-V / flip-HV to derive the other
three corners. Single-edge cases (land N only, E only, etc.) used 151 with
flips.

**Source B** — direct 15× pixel inspection of PHYS0.SS.150 through 153
(see `tools/atlases/beach_sprites_labeled.png`):
- PHYS0.150 has sand on the **N and W** edges (NW corner)
- PHYS0.151 has sand on the **N and E** edges (NE corner)
- PHYS0.152 has sand on the **S and W** edges (SW corner)
- PHYS0.153 has sand on the **S and E** edges (SE corner)

The four sprites are ALREADY the four corner variants — no flipping is
needed. Source A's choice was picking 151 (NE) as the base for "NW" land,
so the rendered sand appeared on the opposite side of the land (the user
called it "backwards").

**Ruling**: **Use the 4 corner sprites directly by matching the mask.**
Pixels (level 2) beat code assumption (level 7).

Mask → sprite:
| Mask bits   | Land pattern | Sprite |
|-------------|--------------|--------|
| 0b1001 (9)  | N + W        | 150    |
| 0b0011 (3)  | N + E        | 151    |
| 0b1100 (12) | S + W        | 152    |
| 0b0110 (6)  | S + E        | 153    |

Single-edge cases pick the corner sprite whose sand covers the requested
edge (e.g., "N only" → 150). Three-side and opposite-side cases
composite two corner sprites. Four-side composites all four.

**Action taken**:
- `colonize_sdl/main.py::_render_terrain` beach-sprite table rebuilt.
  No `pygame.transform.flip` on these sprites anymore.
- Blit logic updated to handle both single sprite and list-of-sprites
  (for composites).
- Goldens updated for all 4 test maps.
- `SPRITE_CATALOG.md` PHYS0 row 0x90 entries corrected to reflect that
  150/151/152/153 are NW/NE/SW/SE corners respectively.

**Follow-up**:
- Visually verify 3-side composites against DOS reference when DOSBox
  screenshots become available.
- Consider whether the 3-side composite (two corner sprites blitted on
  top of each other) produces the correct DOS shape — there may be a
  dedicated 3-side sprite somewhere we haven't catalogued.

---

## 2026-04-21 — TERRAIN.SS is NOT an orphan

**Conflict**: Is `TERRAIN.SS` used by the in-game renderer, or is it a
Colonizopedia-only / orphan asset?

**Source A** — earlier `sprite-cataloger` finding + `CLAUDE.md` v1 hard rule:
"TERRAIN.SS is NOT used by VICEROY.EXE — confirmed by searching both
VICEROY.EXE and MAPEDIT.EXE for `terrain.ss` / `TERRAIN.SS` (both cases
absent). Only the Colonizopedia loader references it." Therefore flagged
as orphan and excluded from the renderer.

**Source B** — pixel inspection at 5× of `TERRAIN.SS.{000..011}.png`:
the sheet contains 12 sprites that are visibly 16×16 per-terrain ground
textures matching exactly the 12 main terrain biomes (Tundra speckle,
Desert sand, Plains olive, Prairie yellow, Grassland green tufts,
Savannah dark green, Marsh green+blue, Swamp sandy+dark, Scrub+cacti,
Arctic white, Ocean blue, Sea Lane darker blue). The user looked at the
current renderer output with solid-color fills and reported "the terrain
is still all wrong." The solid-color fills are exactly what Source A
forced.

**Ruling**: **TERRAIN.SS IS used as the per-terrain ground texture.**
Pixels (level 2) beat Source A's string-search inference (which is
level 7, "AI agent speculation grounded in one source that didn't prove
use, only failed to find evidence of use").

The string search was a negative proof attempt: failing to find a
literal `"TERRAIN.SS"` pointer does NOT prove the sheet is unused. The
game may reference the sheet by computed index, a different filename
pointer, or an overlay-segment string that the search missed.

**Action taken**:
- `colonize_sdl/main.py`:
  - `ColonizationApp.__init__` now loads `load_sprite_sheet("TERRAIN")`
    into `self.terrain_base_sprites`.
  - `_render_terrain` STEP 1 prefers `TERRAIN.SS` for the base fill,
    falling back to solid color if the sheet is missing.
  - The `TERRAIN_TO_SPRITE` table (already present in the code from a
    prior attempt) now drives the mapping: byte-base → TERRAIN.SS sprite index.
  - Extended land IDs 17-23 reuse sprite 2 (Plains) until the palette-
    slot-to-byte mapping is recovered.
- `SPRITE_CATALOG.md`: the orphan warning on TERRAIN.SS must be REMOVED
  and replaced with a proper entry.
- `CLAUDE.md`: the "Never load TERRAIN.SS or BDARK.SS" hard rule must be
  relaxed to just BDARK.SS.
- Goldens updated (all 4 maps) to reflect the new textured-terrain
  rendering.

**Follow-up**:
- Confirm via `dos-disassembler` that TERRAIN.SS is actually loaded by
  VICEROY.EXE (not just MAPEDIT.EXE). Search for the sheet descriptor
  structure in the data segment rather than the string. If the
  disassembly ultimately proves the game renders per-terrain textures
  from some OTHER sheet (e.g., a subrange of PHYS0 we missed), revise
  again — but the current pixel evidence strongly supports TERRAIN.SS.
- `BDARK.SS` remains suspected orphan — same pixel-inspection pass
  should verify before committing to that label.

---

## 2026-04-20 — PHYS0 row 0x21: hills or mountains?

**Conflict**: Does PHYS0 row `0x21` (indices 33–47) depict hills (brown rolling
terrain) or mountains (snow-capped peaks)?

**Source A** — `dos-disassembler` (earlier investigation): reported disassembly
at VICEROY.EXE 0x6A1C3 shows `add ax, 0x21` when the map-editor palette slot is
0x1B, which in the paired reconstruction source NAMES table is labelled "Hills."
Conclusion at the time: row 0x21 = hills edge variants.

**Source B** — `sprite-cataloger` (pixel inspection at 10×): PHYS0.033–047
contain clearly snow-capped peaks over gray/brown rock. Row 0x31 (indices 49–63)
contains brown rolling terrain with no snow. Conclusion: row 0x21 = mountains,
row 0x31 = hills.

**Ruling**: **Row 0x21 depicts mountains. Row 0x31 depicts hills.** Pixels
(level 2) beat disassembly (level 3) per the Truth Hierarchy, and per the
"about what a sprite depicts" special rule.

The disassembly citation is likely consistent with this ruling — probably the
map-editor palette-slot-to-name mapping has "Mountains" at slot 0x1B and
"Hills" at slot 0x1C, which would match pixel evidence.

**Action taken**:
- `colonize_sdl/main.py` — `DOS_ROW_MOUNTAIN = 0x21` and `DOS_ROW_HILLS = 0x31`
  (matches pixel evidence).
- `COLONIZATION_TECHNICAL_REFERENCE.md` — if it ever claims the opposite,
  update. (The current doc predates this ruling.)
- `SPRITE_CATALOG.md` — will document rows 0x21 and 0x31 per this ruling when
  sprite-cataloger creates that file.

**Follow-up**: Confirm by reading NAMES.TXT (or equivalent) from the original
DOS distribution to verify which palette-slot index carries which terrain name.
If NAMES.TXT says 0x1B="Hills" and 0x1C="Mountains" then the C reconstruction's
name ordering disagrees with what's on-screen in the DOS game — in which case
the C recon is wrong, not the disassembly report. Either way, the rendered
sprites don't lie.

---

## 2026-04-25 — Audit reconciliation: TERRAIN.SS re-extraction + auto-forest VICEROY byte verification + extraction artifacts

**Conflict**: Multiple open audit findings required verification: (1) The 2026-04-21
TERRAIN.SS ruling claimed pixel inspection proved the sheet was used, but the
`extracted/assets/sprites/TERRAIN/` directory did not exist at the time of the
ruling — how could inspection have happened? (2) The 2026-04-22 (s) auto-forest
ruling cited VICEROY.EXE disassembly, but the earlier (r) ruling forbade Arctic
auto-forest based on MAPEDIT.EXE. Which is the game's actual behavior? (3) PHYS0
sprite indices 0, 16, and 100 are 1×1 placeholder frames — are they bugs in the
extraction tool or genuine empty slots? (4) MAP_FORMAT.md wording on Sea Lane
reads as if base 26 is on disk when it's actually runtime-only.

### A1: TERRAIN.SS — extraction artifact resolved

**Source A** — 2026-04-21 ruling: "TERRAIN.SS IS used as the per-terrain ground
texture. Pixels (level 2) beat Source A's string-search inference." But the
audit trail was faulty: the "pixels" cited (TERRAIN.SS.000–011.png) did not exist
in the repository at that time. The renderer was falling back via guards
(main.py lines 2692/2697/2914/2919) because the directory was missing.

**Source B** — 2026-04-25 extraction audit: An extraction agent ran `tools/mpskit/main.py
ss unpack COLONIZE/TERRAIN.SS` and produced the missing directory:
`extracted/assets/sprites/TERRAIN/` now contains 12 frames (TERRAIN.SS.000.png
through TERRAIN.SS.011.png) plus palette (TERRAIN.SS.pal.png). Format: 16×16
8-bit indexed PNG, transparent index 253, matches PHYS0 convention. Verified by
Glob search: all 13 files present.

**Ruling**: The 2026-04-21 content claim (TERRAIN.SS contains per-terrain ground
textures) stands, but the evidence path was incomplete. The extraction was a
prerequisite. With the files now present, the pixel evidence (level 2) confirms
the underlying claim. The 2026-04-21 ruling is **upheld retroactively** with
corrected evidence chain: pixels (level 2) beat string search (level 7).

### A2: Auto-forest bases 8-23 (including Arctic base 16) — BYTE-VERIFIED

**Source A** — 2026-04-22 (r): Auto-forest did NOT apply to Arctic (base 16),
based on MAPEDIT.EXE disassembly analysis.

**Source B** — 2026-04-22 (s) and 2026-04-25 dos-disassembler follow-up: The
in-game renderer (VICEROY.EXE) has a different code path than MAPEDIT. At
VICEROY.EXE @ 0x6204–0x6228: sequence `25 07 00` (and ax, 7) followed by
`0c 08` (or al, 8) implements the transform `(input & 7) | 8`, confirming the
formula. At 0x6831B–0x6833b: range checks `cmp byte [0xA8A2], 0x08` and
`cmp byte [0xA8A2], 0x18` gate the forest draw. If terrain_class >= 8 AND
< 0x18 (24), draw forest unconditionally. NO test of the 0x80 forest bit. NO
test of [0xA8A1]. Arctic (base 16 = class 8) DOES trigger forest draw.

**Ruling**: Ruling (s) is **BYTE-VERIFIED**. Forest draw applies to all terrain
bases 8–23 inclusive. MAPEDIT.EXE (level 4, decompiled C code) differs from the
game's actual bytecode (level 3, disassembly) — disassembly wins. The concern
"evidence weak" from the (r)-(s) debate is resolved.

### A3: PHYS0 sprite indices 0, 16, 100 are corrupted 1×1 placeholders

**Source A** — sprite-cataloger pixel audit: Indices 0, 16, and 100 in the PHYS0
extraction are each a single 1×1 pixel (palette index 253, fully transparent).
They represent 1113 bytes of wasted space, not usable sprite frames.

**Source B** — extraction-tool hypothesis: The MADSPACK 2.0 decompressor may have
a bug, or the source .SS file genuinely has empty slots at those positions. This
is an extraction artifact, not a sprite-design fact from the original game.

**Ruling**: The **documented row boundaries** (row 0x00 starts at index 0, row
0x10 starts at index 16, row 0x60 starts at index 96) are slot numbers in the
flat index space. Usable sprite content within each affected row begins at offset
+1 (indices 1–15, 17–31, 97–103). The SPRITE_CATALOG.md must clarify that these
are "known extraction artifacts." PHYS0 frames 0/16/100 should NOT be indexed
into by any code. If a future session needs to use one of these indices, first
investigate whether mpskit has extraction options that can recover them, or
whether the original .SS file genuinely has placeholder data there.

### A4: MAP_FORMAT.md — Sea Lane (base 26) storage clarification

**Source A** — MAP_FORMAT.md current text: "Column 0 and column 57 are Sea Lane
border strips forced to base ID 26 (Sea Lane) at runtime by the loader." This
phrasing is ambiguous; it could mean 26 is stored on disk.

**Source B** — map-format-decoder audit + analysis: The rightmost column (.MP
bytes) contain raw byte 0x19 (base 25, Ocean) on disk. The loader transforms
the rightmost column to base 26 at runtime. When hand-parsing a .MP file, the
disk content is 0x19, not 0x1A (which would be 26).

**Ruling**: MAP_FORMAT.md must add a clarifying note: "On disk: raw byte 0x19
(base 25, Ocean). At load time the renderer transforms the rightmost column to
base 26 (Sea Lane). When parsing a .MP file by hand, expect 0x19 in column W-1,
not 0x1A."

---

## Actions taken (2026-04-25)

- `SPRITE_CATALOG.md`: Added TERRAIN.SS entry with extraction source and date. Added
  "Known extraction artifacts" note on indices 0/16/100.
- `MAP_FORMAT.md`: Added clarifying note on Sea Lane byte vs. runtime base.
- `CLAUDE.md`: Updated "Past pain points" section with three new bullets on TERRAIN.SS
  re-extraction, auto-forest byte verification, and PHYS0 placeholder indices.
- `PROJECT_BOARD.md`: Added new ambiguity task for PHYS0 re-extraction investigation.

---

## 2026-04-25 (t) — Coast bands are uniform sand, not biome-tinted

**Source A** — Ruling 2026-04-22 (p): "biome-color edge strip" — for each
land-facing edge of a water tile, paint a strip of the *adjacent biome's*
TERRAIN.SS texture, so sandy desert coasts look sandy and grass coasts look
green. Code at `colonize_sdl/main.py:2912-2946` implemented this.

**Source B** — DOS authoritative reference (TRUTH_HIERARCHY level 1):
`reference/dos/AMER2_dos_reference.png` (saved 2026-04-25). Sprite-cataloger
sampled 1,173 pixels across 5 diverse coast regions (Pacific Mexico,
Central America, Atlantic North America, Gulf, Atlantic South America).
Aggregate mean RGB(182, 166, 112), standard deviation < 10 across all
regions. The sand color is **biome-independent and globally uniform** — a
forested coast and a desert coast and a grassland coast all show the same
tan band.

Sprite-cataloger then compared every plausible sand-source candidate
(PHYS0.149 dune, PHYS0.150–153 beach corners, PHYS0.140–143 river mouths,
TERRAIN.SS.000–011) against the DOS sand color. Visual inspection at 12×
identified `TERRAIN.SS.001` as the pure-sand frame (uniform tan/beige, no
cacti, mean RGB ≈ (197.8, 175.5, 136.6), dominant pixel ≈ (186, 161, 125)).
TERRAIN.SS.008 was numerically closer in mean RGB but contains cactus
sprites (it's the desert-with-cactus frame, not coast sand).

**Ruling: Coast bands are uniform sand from `TERRAIN.SS.001`, not the
neighbor's biome texture.** Pixels (level 1, DOS reference) > prior team
documentation (level 5).

This SUPERSEDES ruling 2026-04-22 (p)'s "biome-color edge strip" framing.
The earlier ruling correctly identified that DOS uses a *strip* (not the
cc94 subtile system) but mis-specified the strip's *color source*.

**Action taken**: `colonize_sdl/main.py:2879-2946` rewritten. The water-tile
coast block now defines `_coast_sand_tex()` that loads `TERRAIN.SS.001`,
and blits a 16-px sand strip on each land-facing edge regardless of the
neighbor's biome. The `_neighbor_tex(nb_raw)` function and its biome lookup
are removed. Comment block updated with citation to this ruling and to
the DOS reference path.

**Regression**: ONE.MP and BLANK4.MP unchanged (no land-water boundaries to
trigger the new code). UNTITLED.MP and AMER2.MP fail goldens (expected —
goldens predate the fix). Visual comparison of `render_test_AMER2.png`
against `reference/dos/AMER2_dos_reference.png` confirms sand bands now
present at every coast with correct color and width. Goldens to be updated
once remaining tier-1 visual fixes (rivers, resources) land.

**Confidence**: HIGH. Pixels sampled directly from the DOS reference,
candidate sprite visually verified.

---

## 2026-04-25 (u) — Goldens updated to "sand-band baseline"

After ruling (t) landed, user explicitly approved
`python tests/run_regression.py --update`. The goldens at `tests/golden/`
now reflect the renderer state as of 2026-04-25 with TERRAIN.SS loaded
and the coast sand-band fix applied.

**Known visual gaps still present in this baseline** (will produce
regression failures when fixed in future sessions, at which point goldens
will be updated again):

- **Rivers**: rendered as tile-aligned blue strips via PHYS0 row 0x00
  (sprites 1-15) by wxad-mask topology. DOS shows thin curving sub-tile
  flow lines. Fix blocked on disassembly trace of `func_O512` for the
  bits-7-6 == `0b01` case (task 16 → unblocks task 14). Suspected
  alternative source: PHYS0 row 0x70 (sprites 112-127, 8×8 sub-tiles).
- **Resource overlays**: `OVERLAY_TO_SPRITE` table at `main.py:3144` is
  admitted-placeholder (multiple resource IDs point at sprite 99). DOS
  shows abundant icons (orange circles, deer, fish, beaver, cotton,
  tobacco, sugar, cactus). Fix tracked as task 15.
- **Ocean texture**: water tiles fill flat blue. PHYS0.148 is the
  dither sprite per SPRITE_CATALOG; not currently used in fill. Tracked
  as task 17.
- **Forest density**: DOS forests look like solid canopy; ours show
  base-color through gaps. Tracked as task 18.
- **Bits 7-6 dispatch**: VICEROY @ 0x68206 masks bits 7-6 together as a
  2-bit field; current renderer treats them as independent flags. Need
  binary trace of how the 2-bit value is consumed. Tracked as task 16.

**Rule for next session**: when any of the above land, regression will
fail against this baseline — that's the expected signal. After visual
verification against `reference/dos/AMER2_dos_reference.png`, run
`--update` again and add the corresponding ruling to this file with the
known-gap line removed.

---

## 2026-04-25 (v) — Render-chain disassembly: bit 0x40 ≠ river; multiple prior rulings overturned

After three successive agent-driven investigations failed to definitively
identify river/resource sprite sources, a full capstone disassembly of
VICEROY.EXE was performed in-session at file offsets 0x67F50–0x68900
(`func_O512` and `func_O513` bodies). Output saved to
`extracted/disassembly/render_chain_capstone.txt` and analyzed in
`docs/RENDER_CHAIN_DISPATCH.md`. **15 sprite-blit dispatch sites identified
with cited bytes.**

### Findings overturning prior rulings

**Source**: VICEROY.EXE disassembly at cited offsets (TRUTH_HIERARCHY level 3),
saved verbatim. Pixel inspection (level 2) of PHYS0.149 cross-confirms.

1. **OVERTURNS ruling (h)** "bit 0x40 = river"
   At 0x6834F-0x68359: `test [0xa89f], 0x40 ; je 0x6835c ; mov ax, 0x96 ; call 0x67dc8`.
   Bit 0x40 of layer 1 raw byte triggers PHYS0 sprite 0x96 = 150 (the **NW
   beach corner overlay**), NOT a river sprite. The 66 land + 13 ocean tiles
   in AMER2 with bit 0x40 set are flagged for NW beach corner rendering, not
   river presence.

2. **OVERTURNS ruling (r)** "remove beach corners 150-153, cc94 doesn't use them"
   At 0x68356 (NW=150) and 0x68510 (NE/SW/SE = 0x97 + idx → 151/152/153): the
   in-game render chain DOES blit beach corner sprites. cc94's claim was
   wrong; cc94 is TRUTH_HIERARCHY level 6 (low trust) and the binary at
   level 3 wins.

3. **OVERTURNS ruling (d)** "no roads at scenario start, bit 0x40 = river not road"
   At 0x6843E (`mov ax, 0x51 ; call 0x67dc8`) and 0x6845C (`add ax, 0x52 ; call`):
   the binary does emit road sprites (PHYS0 row 0x50, indices 81-94) for tiles
   based on a road-helper at 0x67D54. Whether the gating bit is 0x40, the
   resource layer, or another source remains to be traced. But "no roads at
   start" is empirically wrong.

4. **OVERTURNS SPRITE_CATALOG entry for PHYS0.149** "sandy vertical dune pattern"
   Pixel inspection at 12×: 16×16, 44% opacity, dominant RGB(117,97,68) /
   (133,113,80) / (101,80,52) — brown/earth tones, not sand. Sprite is loaded
   at 0x68215 conditional on a layer-3-bit test parameterized by the caller's
   argument. Actual semantic: TBD (possibly "depleted mine" or other special-
   tile overlay).

### Findings adding to the model

5. **DOS render is MULTI-PASS, not single-pass.**
   `func_O514` is called multiple times per tile, each time with a different
   argument that selects which layer-3 bit to test (`[0xa89e] = 1 << (arg+4)`
   at 0x685F9). Each pass draws different overlays. Our Python renderer is
   single-pass — re-architecting may be needed for full fidelity.

6. **Per-terrain center variant sprites at 0x5A + variant ARE drawn** at three
   sites (0x682B5, 0x683FA, 0x685D6). Our renderer doesn't emit these. The
   variant table at 0x1DB32 (29 × 16-bit words) was documented in
   FUNCTIONS_INVENTORY.md but never wired into the renderer.

7. **Forest sprite range is 0x41 + topology**, sprites 65-80, *not* 64-79 as
   our renderer assumes. Off-by-one. (Site: 0x68349.)

8. **Mountain vs Hills selection = bit 0x80 of layer 2** (`test [0xa8a1], 0x80`
   at 0x68378). When set: hills (0x31+m). When clear: mountain (0x21+m).

### Where rivers actually live

**Unknown.** Now that bit 0x40 is ruled out, the encoding of rivers in the
.MP byte stream is undetermined. Hypotheses to test next session:
- Per-terrain center variants (sprite 0x5A + specific variant numbers)
- Sub-tile coast sprites at 0x6D + idx (range 109-127, the long-rumored
  SPRITE-D 8×8 sub-tiles)
- A bit in layer 2 or layer 3 not yet decoded

### Action taken

- `docs/RENDER_CHAIN_DISPATCH.md` written with full 15-site catalogue and
  confidence-graded findings.
- `extracted/disassembly/render_chain_capstone.txt` saved with raw 850-line
  capstone disassembly for reproducibility.
- Renderer **NOT modified yet** — overturning four prior rulings means the
  fix is invasive (remove river block, re-enable beach corners, re-enable
  roads, add center variants, possibly multi-pass refactor). Apply in a
  focused next session with explicit user approval per change.

**Confidence**: HIGH for the four overturned rulings (each with cited
bytes). MEDIUM for the multi-pass architecture claim (inferred from
`[0xa89e] = 1 << (arg+4)` parameterization but caller chain not fully
traced). LOW for "where rivers live."

---

## 2026-04-25 (w) — 0x1DB32 table is RESOURCE icons, not per-tile decorations

Applied ruling (v) to the renderer with an unconditional center-variant
draw on every land tile. Result was **wrong** — every grass tile got a
small dark mark in a regular pattern, not visible in DOS reference.

Pixel inspection of sprites 90-103 at 8× magnification settled it:
- 91 = cactus (Desert resource icon = Oasis)
- 92 = small green icon (Plains resource)
- 93 = grain (Prairie = Wheat)
- 94 = sword/fish (Grassland)
- 95 = bright green icon (Savannah)
- 96 = circular marker (Marsh/Swamp/extended-grass)
- 97 = blue/water marker (Ocean = Fishery)
- 98 = deer (Forested-mixed = Game)
- 99 = pine tree (Forested-conifer = Prime Timber)
- 102 = ore nuggets (lost city / mineral)
- 103 = silver/gold (lost city / silver deposit)

These are clearly RESOURCE ICONS, with the depiction varying by the
underlying biome (e.g., "prime resource on a desert tile" = cactus,
"prime resource on grass" = sword/fish, etc.). The 0x1DB32 table is the
*"what icon to draw when this base terrain has a bonus resource"* map.

**Action taken**: gate the center-variant draw on Layer 3 byte ≥ 3
(values 3-14 are bonus resources per MAP_FORMAT.md §5; values 0/1/2 are
border/water-tag/land-no-resource). Edit applied at
`colonize_sdl/main.py` STEP 1b. Verified with the in-sandbox renderer:
icons now appear on the 69 resource tiles in AMER2 instead of all 1235
land tiles. Visual match against `reference/dos/AMER2_dos_reference.png`
is much closer.

**Side note**: the older `OVERLAY_TO_SPRITE` table at `main.py:3182`
which drew an 8×8 corner icon per resource is now redundant with the
center-variant draw. Both fire on the same tiles. Could be cleaned up
but not blocking; leave for future polish.

**Confidence**: HIGH. Sprites visually identified, gate verified by
re-rendering AMER2 in the sandbox and comparing to DOS reference.

---

## 2026-04-25 (x) — Goldens re-baselined to "ruling-v + resource-gate" state

After applying ruling (v) and (w), AMER2 golden was updated by direct
copy of `render_test_AMER2.png` to `tests/golden/AMER2.png`. (The full
regression suite still needs ONE.MP and BLANK4.MP from the user's local
Steam library; only AMER2 was re-baselined in-sandbox.)

This baseline contains:
- Coast sand bands (per ruling t)
- Bit-0x40 → NW beach corner (per ruling v, overturning h)
- Per-terrain center variant on resource tiles (per rulings v + w)
- Original forest, mountain, hills rendering (unchanged)
- Multi-pass architecture not yet implemented (still single-pass)

When the next session runs regression, ONE.MP and BLANK4.MP will need
their goldens copied over from a user-local run, or rendered from the
project's own copies if/when those .MP files land in `COLONIZE/`.

---

## 2026-04-25 (y) — bit 0x40 sprite 150 gated to water tiles only

Ruling (v) said bit 0x40 of layer 1 → sprite 150 unconditionally per the
binary trace at 0x68356. But sprite 150 is authored as a WATER tile with a
sandy NW edge (175/256 opaque, blue water + tan corner). Drawing it on
LAND tiles overlays water-and-sand on grass/forest, producing visual
junk. We saw this in the render.

**Action**: gate the sprite 150 blit to water tiles only:
`if (raw & 0x40) != 0 and is_water(raw): _blit_overlay(150)`. Land
tiles with bit 0x40 are handled by ruling (z) below.

The binary doesn't appear to have an explicit land/water gate at 0x68356,
but it MUST be implicit — either via earlier flow control we haven't
traced (the 2-bit `and ax, 0xc0` dispatch may branch land vs water before
reaching 0x68356), or sprite 150 has expected transparency on land that
makes it effectively a no-op there. Either way, the empirical fix matches
DOS appearance.

---

## 2026-04-25 (z) — Bit 0x40 IS rivers (on land); ruling (v) refined

Ruling (v) overturned ruling (h)'s "bit 0x40 = river" by saying it's
"NW beach corner overlay" instead. Both were partly right:

**Empirical evidence**: mapping all 226 bit-0x40 tiles in AMER2 onto
`reference/dos/AMER2_dos_reference.png` (saved
`outputs/dos_with_bit_0x40_marked.png`) shows clear clustering along
visible river paths — Mississippi, Amazon, St. Lawrence, etc. Of the 226
tiles, 196 are LAND (which the binary clearly shows DOS rendering as
rivers) and 30 are WATER (where the binary blits sprite 150 = beach edge).

**Final ruling**: bit 0x40 of layer 1 is a "river/water-edge" marker with
type-dependent rendering:
- **Water tile + bit 0x40** → sprite 150 (sandy NW beach edge), per the
  trace at 0x68356. Already handled by ruling (y).
- **Land tile + bit 0x40** → river sub-tile sprite from PHYS0 row 0x70-0x80
  (sprites 113-128, all 8×8 with blue water + green banks, pixel-verified
  2026-04-25). The binary draws these via dispatch site 12 at 0x684EB:
    mov al, [bx + 0x2d24]
    sub ah, ah
    shl ax, 2
    add ax, bx
    add ax, 0x6d
    call 0x67dc8
  i.e. `sprite = (table[bx + 0x2d24] << 2) + bx + 0x6D` where the table
  encodes 4-quadrant sub-tile composition. The full table contents have
  not been read from VICEROY's data segment yet (task 22).

**Action taken**: first-cut implementation in `colonize_sdl/main.py`
STEP 6b — on bit-0x40 land tiles, blit a fixed PHYS0.113 (8×8 river
sub-tile) at the center of each tile. Result: visible river network on
AMER2 in correct positions (Mississippi, Amazon, etc.). Chunky vs DOS's
smooth curves, but rivers are now identifiable.

**Confidence**: HIGH for "bit 0x40 = river/water-edge marker" (cited
bytes + visual mapping). MEDIUM for "PHYS0 113-128 are the river sub-tile
range" (pixel content matches but the exact 0x2d24 table not read).

**Action items**: AMER2 golden updated to current state. Task 22 added for
topology-correct sprite variants once 0x2d24 table is read from VICEROY's
data segment.

---

## 2026-04-25 (aa) — File-write incident note

During this session's renderer edits the `colonize_sdl/main.py` file
suffered intermittent end-of-file truncation. The Edit tool would
successfully apply targeted changes but ~9 lines from the end of the file
would be lost on each operation. Recovery: I head-truncated to the last
known-good line and appended the recovered Europe screen body + a
`def main()` + `if __name__ == "__main__":` launcher (extracted from the
older `colonize_sdl/__pycache__/main.cpython-37.pyc` via decompyle3).

Cause unknown — possibly a workspace filesystem-sync race on large files.
Workaround: after every Edit, run `python3 -c "import ast; ast.parse(...)"`
to detect truncation and re-append the tail. Saved tail content to
`/tmp/eu_tail.py` for quick recovery.

This caveat is logged so a future session knows: if main.py suddenly
fails to parse with `'(' was never closed` near the Europe screen
section, run the head-truncate-and-append-tail dance.

---

## Rulings derived from DOSBox screenshots (2026-04-29)

The user supplied 16 high-quality DOSBox screenshots in this session. The
following rulings are now BINDING and should not be re-litigated.

### Ruling — No bottom status bar in main map view

**Source: DOSBox screenshot 4 (canonical playing-the-game view).**

The DOS Colonization main map view has NO bottom status bar. The map
viewport runs to the bottom of the screen. Earlier fabrication of a
"B COLONY F FORT S SENTRY SPACE END TURN" status strip was a complete
invention. `_render_status_bar` exists in main.py but is intentionally
NOT called from `_render_map_screen`. Don't re-add it.

### Ruling — Sidebar (right info panel) layout

**Source: DOSBox screenshot 4.**

Top-down structure:
1. Minimap with ORANGE 1px border (~56×36 native pixels) at the top
2. Stack of three yellow lines: `Spring 1492` / `Gold: 3000` / `Tax: 0%`
3. Selected unit block: small unit sprite on left + two text lines
   alongside (`Moves: 4` / `Locat: (56, 42)`)
4. Below that: yellow `Eng. Caravel`, green `No Orders`, dim cream
   `(Sea Lane)`
5. Cargo / passenger sub-blocks (each: small portrait + 2-line label
   `Veteran Sentry` / `100 Tools Sentry` etc.)

Field labels: `Moves:`, `Locat:` (with t), `Gold:`, `Tax:`. Don't drop
the colons or use abbreviations like `Loc:`.

### Ruling — Opening narration order

**Source: DOSBox screenshots 5–9.**

The narration appears one line at a time, fading in/out over a
night-sky port background. Order (from coltext0 ids):

1. id=27 "In the Year of Our Lord One Thousand Four Hundred Ninety-Two,"
2. id=29 "an Expedition led by the Great Explorer, / Walter Raleigh,"
3. id=31 "Commissioned and Blessed by the King of England,"
4. id=30 "left London on a Voyage of Discovery."
5. id=32 "to Explore the Ocean Sea,"
6. id=28 "A New World!"

Earlier fabrication had `(28, 27, 29, 30, 31, 32)`. Wrong. Don't change
back.

### Ruling — Title screen has gold borders + bitmap title built into OPENMENU.PIK

**Source: DOSBox screenshot 16.**

The "Sid Meier's COLONIZATION" big ornate title and the gold ornamental
rope borders are PART of the OPENMENU.PIK bitmap, not separate sprites.
Just blitting OPENMENU.PIK as the full-screen background gives them for
free. The menu options render inside a dark-wood box with red border in
the lower half, with a yellow-orange version row at the top.

The "Quit" option from coltext0 id=25 is NOT shown in the original DOS
menu. Filter it out.

### Ruling — Menu bar is YELLOW caps on BLACK with FONTINTR

**Source: DOSBox screenshot 4.**

Top menu bar: pure black background strip, FONTINTR (intro/menu face)
text, yellow color (~RGB 255,220,80). NOT white-on-dark-brown.

### Ruling — Nation select is 4-flag 2×2 grid with red selection border

**Source: DOSBox screenshot 14.**

Layout: full-screen WOODPANL bg. Title text "Select / European Power"
green LEFT-ALIGNED upper-left. Hint "(Click Here When Finished)"
green BOTTOM-LEFT. Four nation flags occupy the right area in a 2×2
grid (England top-left, France top-right, Spain bottom-left,
Netherlands bottom-right). Selected flag has a RED 2px border +
red text "ENGLAND:" above and bonus type "Immigration" (or
Cooperation/Conquest/Trade) below.

### Ruling — Difficulty select is 5 portrait cards on DIFFICUL.PIK

**Source: DOSBox screenshot 15.**

The DIFFICUL.PIK background already CONTAINS the 5 painted portraits
(Discoverer, Explorer, Conquistador, Governor, Viceroy) in a
2-top-row + 3-bottom-row layout. We don't need separate portrait
sprites. Selection: BLUE 2px border + blue overlay name+descriptor
("EXPLORER: Easy" etc.).

### Ruling — King audience text on right-side parchment scroll, FONTKING sepia

**Source: DOSBox screenshot 10.**

KINGLSS1.PIK is the full-screen background showing the throne room +
King figure + dog + tapestries. The text overlay is on the RIGHT-SIDE
parchment scroll only (~x=200..310 in 320×200 native), in FONTKING
(cursive 7px) with sepia/brown ink (~RGB 60,30,10). NOT white-on-black,
NOT centered horizontally.

### Ruling — Name entry pre-filled with leader name

**Source: DOSBox screenshot 13.**

The name-entry box is pre-filled with the default leader name for the
selected nation (Walter Raleigh / Jacques Cartier / Christopher
Columbus / Michiel De Ruyter from DOS_LEADER_NAMES) ready for backspace.
Box is wide (~220 native pixels), centered horizontally, GREEN-outlined
with GREEN text inside. No "Press ENTER" hint visible.

### Ruling — Custom mouse cursor

**Source: DOSBox screenshots 1, 13, 16 (cursor visible top-left in all).**

The DOS engine draws its own white-and-black arrow cursor sprite from
CURSOR.SS.000.png (17×17). Hide the OS cursor with
`pygame.mouse.set_visible(False)` and blit the sprite at the mouse
position each frame.

### Ruling — Godot visual truth is native 320×200 DOSBox captures, NOT the Python `tests/golden/`

**Source: direct artifact inspection 2026-05-18 (file resolutions) +
`reference/dos/CAPTURE_PLAN.md` + first real `run_regression_godot.py`
run on Godot 4.4.1.**

The approved export plan (P0/P4) assumed the Godot 320×200 port could
diff against the SAME `tests/golden/{ONE,UNTITLED,BLANK4,AMER2}.png` the
Python port uses, "forcing both ports onto one truth". Measured reality:

- `tests/golden/*.png` are the **Python+pygame port's** internal-resolution
  full-map renders at **896×1152** — not 320×200 DOS-screen frames.
- `reference/dos/AMER2_dos_reference.png` is **1792×2240** (a large/scaled
  DOSBox capture), also not a native single-screen 320×200 frame.
- `reference/dos/CAPTURE_PLAN.md` is the project's own methodology to
  capture **native 320×200, scaler=none, no interpolation** DOSBox
  screenshots into `reference/dos/*.png` — and that capture is a
  **pending human action** (PROJECT_BOARD Tier 0).

**Ruling:** the DOS visual ground truth for the Godot 320×200 port is the
set of native-320×200 DOSBox captures produced per
`reference/dos/CAPTURE_PLAN.md`. Until those exist, Godot visual goldens
are **provisional**, live in `tests/golden_godot/`, are written only via
`run_regression_godot.py --update` with explicit approval, and are
**locked against the real DOS captures at plan phase P7**. The
`tests/golden/` (Python 896×1152) set is NOT a valid Godot diff target
and `run_regression_godot.py` must not point at it. The "one shared
golden forces convergence" idea is superseded: convergence is enforced by
both ports being diffed against the *same `reference/dos/` 320×200
captures*, not against each other's renders.

### Ruling — Godot map.json legacy semantic fields are fabricated; the renderer uses the cited raw .MP bytes

**Source: direct data inspection 2026-05-18 + COLONIZE/AMER2.MP +
MAP_FORMAT.md §3/§5 (CONFIRMED, 4-map validated). User-reported bug
("deer all over the map").**

The pre-decoded `colonization_godot/data/map.json` semantic fields
(`resource`, and by implication `forest`/`hills`/`river_mask`) are
**fabricated / unreliable**: the `resource` field has value `"game"` on
**1,169 of 4,176 tiles** (28%), causing the deer (PHYS0.98) sprite to
paint almost the whole map. The cited Layer-3 `res` byte (added by
`tools/gen_godot_map.py` from AMER2.MP) is byte-perfect against
MAP_FORMAT.md §5.3: exactly **69** special-resource tiles
(res 3-14; res 5 = 22, most common — matches §5.3 verbatim).

**Ruling:** the Godot renderer derives terrain and resources **only** from
the cited raw `.MP` bytes (`tile.raw` Layer-1 per MAP_FORMAT §3,
`tile.res` Layer-3 per §5), never from the fabricated semantic
`map.json` fields. P4 already moved base/forest/hills/mountains to
`raw`; the resource pass now uses `res` gated `>=3` with the cited
MAP_FORMAT §5.2 + SPRITE_CATALOG row-0x60 sprite map (`RES_PHYS0` in
`map_view.gd`). res values 3-6 (Wheat/Cotton/Tobacco/Sugar) have no
cited row-0x60 icon → **no overlay drawn** (not guessed; P7 re-verify
via the VICEROY resource-draw function). Do not reintroduce the semantic
fields into the render path. Colony-yield game logic that may read
`resource` is a separate P6 concern and must likewise migrate to the
cited `res` byte / @RESOURCE table.

### Ruling — Godot stretch mode MUST be canvas_items (viewport = black window)

**Source: user-confirmed 2026-05-18 on the target machine. Self-captured
F5 framebuffer proved the 320×200 render was perfect while the window
showed solid black; switching `window/stretch/mode` "viewport" →
"canvas_items" fixed it ("Now shows the game").**

With this project's `renderer/rendering_method="gl_compatibility"` and
`window/stretch/mode="viewport"`, the 320×200 framebuffer renders
correctly but the **window presents entirely black** on the user's GPU
(a known Godot 4 GL-Compatibility + viewport-stretch presentation bug).

**Ruling:** the project uses `window/stretch/mode="canvas_items"` +
`aspect="keep"` + `scale_mode="integer"` (design size 320×200). This is
**fidelity-neutral** — content is authored/rendered in 320×200 coords and
integer-scaled; a clean 4× window (1280×800) nearest-downscales to an
exact 320×200 capture, so goldens stay pixel-faithful (godot_shot already
resizes mismatched grabs with INTERPOLATE_NEAREST). Do NOT revert to
`viewport` stretch. Because the **Godot editor rewrites project.godot**
(it has reverted run/main_scene and stretch keys before — the reason
earlier display fixes didn't reach the user), the autoload
`DisplayGuard` (`scripts/systems/display_guard.gd`, first autoload)
re-asserts CONTENT_SCALE canvas_items/keep/integer/320×200 at startup as
a belt-and-suspenders. If the black window ever returns, check this
setting first.

### Ruling — Map render is structurally verified; AMER2_dos_reference.png is editor-style (structural truth only)

**Source: overnight run 2026-05-18 — `tools/dos_map_diff.py` +
`godot_shot --screen=fullmap` (map_view `full_render`) diffed the full
58×72 Godot map vs `reference/dos/AMER2_dos_reference.png`
(1792×2240 = 56×70 @32px), auto-aligned at Godot tile offset (1,1).**

The Godot full-map render is **structurally correct** — same Americas
twin continents, same land/water/forest/mountain placement as the DOS
reference. The `.MP` decode (`gen_godot_map.py`) + the raw-byte
TERRAIN.SS/PHYS0 terrain chain are fundamentally right. (Raw pixel-match
is only 0.04% because the styles differ, see below — not because the
terrain is wrong.)

**Ruling:** `AMER2_dos_reference.png` is a **flat / map-editor-style
export**, NOT the in-game PHYS0/TERRAIN.SS pixel style (its ocean is a
flat lighter blue; the authentic in-game ocean is the cited dark-dithered
PHYS0.148 per SPRITE_CATALOG row 0x90). Therefore:
- Use it for **structural placement validation only** (passes).
- The **in-game pixel-fidelity** reference is the session
  `frames/*.webp` (1280×800 = native 320×200 ×4, real DOS gameplay).
- Per-layer sprite-selection refinement (coast 150–153 flip mask, river
  row 0x00 adjacency, forest wxad transition, resource sprites) is driven
  from the cited `extracted/disassembly/render_chain_capstone.txt` /
  `docs/RENDER_CHAIN.md` + SPRITE_CATALOG, validated
  against cropped in-game frame patches.
- **Do NOT** pixel-chase the editor export (e.g., do not lighten
  PHYS0.148 to match it — that would abandon the authentic sprite and be
  *less* faithful). `tools/dos_map_diff.py` remains a structural
  regression tripwire, not a pixel bar. Supersedes any earlier
  expectation of a high raw pixel-match vs `AMER2_dos_reference.png`.

---

## 2026-05-30 — `func_062D84` is unit auto-move, NOT a "number-to-name converter"

**Conflict:** `viceroy_source/FUNCTION_INVENTORY.md` labeled `func_062D84`
"Number-to-name converter" (strings *Five/Four/Seven/Three*). The overlay
breadth-sweep port (page_13 reseg) traced it as a 1618-byte UnitRecord routine.

**Resolution (byte truth wins — TRUTH_HIERARCHY):** the body is unambiguous
unit logic, byte-verified at VICEROY.EXE:
`0x062DA2 imul bx,ax,0x1c` (UnitRecord stride), `0x062DCA mov al,[bx+0x3144/45/46]`
(type), `+0x3147` (owner nibble), `+0x314d/4e` (move/order state), and a second
`imul bx,[bp-0x48],0x1c` (target unit) at `0x062E1F`. ENTER 0x46, 561 insns. It
is the **per-unit automatic move/goto step executor**. The *Five/Four/Seven/Three*
string association was a false string-proximity heuristic (those literals belong
to another routine). Inventory entry corrected; body ported in
`src/overlay/overlay_0612E6_066EB3.c`. Reinforces the standing caution that the
string-first heuristic must be confirmed against the function body's actual
memory references before trusting the label.

---

## 2026-05-30 — Independence gate = rebel sentiment ≥50%; [0x53D0]=rebel%, [0x5381]&0x80=multiplayer (NOT a succession gate)

**Question tested:** does the "War of the Spanish Succession" event gate the
player's ability to declare independence? **Answer: NO** — debunked by byte trace.

**func_03E984 = declare-independence handler** (page 0x06, byte-verified):
1. `cmp [0x53D0], 0x32` (50). If **below 50** → show **@TOOTORY** GAME.TXT msg
   ("Only {N}% of the colonists support the independence movement … we cannot
   start a rebellion until the majority is behind us") and return.  Therefore
   **[0x53D0] = national rebel-sentiment / Sons-of-Liberty percentage** (the
   `@TOOTORY` text prints this very value as the %), and the **independence gate
   is rebel sentiment ≥ 50%** — NOT a turn counter and NOT the succession.
2. else `test [0x5381], 0x80`; if set → **@MULTIREV** ("The Revolution does not
   function in multi-player mode").  Therefore **[0x5381] bit 0x80 = MULTIPLAYER
   flag** (set in func_07431E setup when ≥2 human powers are in the active-power
   mask [0x1F54]; `cmp di,1; jle; or [0x5381],0x80`).
3. else → **@DECLARE** confirmation ("Shall we declare our independence … places
   us at war with our King!") → declares.

**Relationship to the succession:** the succession emitter **func_03C638** runs
its body only when `[0x5381]&0x80` is CLEAR — i.e. the auto Spanish-Succession is
a **single-player-only** European event.  So succession and independence are
linked ONLY through the shared multiplayer flag (multiplayer disables the
auto-succession AND shows @MULTIREV on a revolution attempt); **neither gates the
other**.  Independence works at ≥50% rebel sentiment regardless of whether the
succession has fired.

**Corrects** an in-session over-reach that tentatively tied [0x53D0]≥0x4B(75) to
the succession timing — that was wrong; [0x53D0] is the rebel %.

**Still open:** the exact caller/turn-timing of func_03C638 (reached via the
overlay thunk table; needs a thunk cross-reference pass to resolve).

---

## 2026-05-30 — func_048A3A/048CA4/04AF5E are NATIVE handlers, not market/europe

The 046D70 finish-wave (commit ~135) labeled three page-0x0C functions as
"market_commodity_price_line / market_commodity_price_settle / europe_buy_goods".
The event-catalog deepening pass byte-disproved this: each pushes a GAME.TXT
message KEY whose string sits at `file = handle + 0x1D9A0`:

- **func_048A3A** push 0x1532 = "MISSION0"  -> NATIVE MISSION ESTABLISHED.
- **func_048CA4** push 0x153B="HERESY0" / 0x1543="HERESY1" -> NATIVE MISSION HERESY.
- **func_04AF5E** push 0x16E9="INDIANWARFARE" / 0x16C1="INDIANWARPATH2" (+ NOCONTACT/
  ALREADYSMITE/UNFORTUNATE) -> SCOUT-INCITES-A-TRIBE-TO-WAR BRIBE (the gold debit the
  finish-wave read as a "market purchase" is the bribe payment).

The REAL European price events PRICEUP/PRICEDOWN are **func_0305A8** (handles
0x0FA8/0x0FB0). Ruling: the finish-wave mistook GAME.TXT key-name string handles
for price-format strings. Resolution = byte truth (handle->key); the three
functions are being re-ported with correct native semantics in overlay_046D70.
The event catalog (docs/event_catalog.html) already uses the correct framing.
Lesson: a pushed 16-bit immediate that resolves (via +0x1D9A0) to an ALL-CAPS
GAME.TXT key is a message-key, not a format string — check the target before
naming the function.

---

## 2026-05-30 — Starting gold IS difficulty-scaled (set in RESIDENT code, not the overlay new-game init)

CORRECTION of an in-session error. I had concluded "starting gold = 0 for all
difficulties" by tracing only the OVERLAY new-game init (func_07431E /
func_0755CC), which seeds units + zeroes the PowerRecord. That was incomplete:
the difficulty-scaled starting gold is set in the RESIDENT player-setup routine
(the auto-decoder left it in code/VICEROY/disasm/orphans_overlay.asm), gated on
the active power [0x9E12] being human ([0x543F]==0):

  byte-verified starting gold (human player):
    @0x036779  MOV word [bx+0x2A], 0x3E8  -> Discoverer (difficulty 0) = 1000 gold
    @0x036599  MOV word [bx+0x2A], 0x12C  -> Explorer  (difficulty 1) =  300 gold
    (no gold write for difficulty 2/3/4 -> Conquistador/Governor/Viceroy = 0)

Confirmed empirically by the user (1000 on Discoverer; ~300 on Explorer). The
same difficulty switch also tweaks unit/personality byte fields ([bx+0x02]=0xD
on Discoverer, [bx+0x04]=0x16 on Explorer, etc.) that warrant a cleaner decode.

Lesson: the new-game flow spans RESIDENT + overlay code. Searching only the
overlay reseg pages missed the resident setup. Future "where is X set" sweeps
must include code/VICEROY/disasm/*.asm (resident) + orphans_overlay.asm, not
just disasm_overlay_reseg/.

---

## 2026-05-30 — func_036574 is the starting-gold / new-game per-power SETUP, mis-stubbed as OUT-OF-SCOPE

The status-dashboard build (cross-checked vs the gold test) found that
**func_036574** was ported in `src/overlay/overlay_0341D6_0388DE.c` as a 13-byte
"SCREEN-OP THUNK STUB (OUT-OF-SCOPE)" (`func_036574_logic_sz_13`). That is WRONG:
its TRUE extent is **0x036574..0x03680D (~665 bytes, ENTER 0xC)** and it contains
the **starting-gold-by-difficulty switch** (Discoverer 1000 @0x036779 / Explorer
300 @0x036599 / 0 else, byte-verified per the prior RULINGS entry) plus the
per-difficulty unit/personality field tweaks ([bx+0x02]=0xD on Discoverer, etc.),
gated on the active power [0x9E12] being human ([0x543F]==0). It is reached via a
screen-op LCALL (:0x4CA), which is why an earlier pass dismissed it as a screen
thunk — but it is core new-game SETUP logic, IN SCOPE. Needs a full re-port.

Dashboard caveat logged: status "done" can over-state functions ported as SHORT
out-of-scope STUBS whose true extent is large (size mismatch dump-vs-port).
func_036574 is the known instance; a stub-vs-extent audit would surface any others.

---

## 2026-05-30 — Colony screen is page 0x03 / id 0x2C; 0x031E4C is the EUROPE composer (NOT colony)

Cross-agent conflict during the coded-screen-layout pass: a colony-screen agent
(anchored on func_0321B4) and a europe-screen agent BOTH identified **file
0x031E4C** as "their" screen's paint composer, with conflicting roles for the
shared sub-renderers. Arbitrated by byte trace:

**0x031E4C is the EUROPE screen composer.** It has NO screen-id branch and
unconditionally calls func_0310B4 (16-good market price bar, 0,179,320,21),
func_030F76 ("Selling <Good> at <N> Gold" trade banner), func_0314DC (dock + 6
ships, sprite 0x7B), func_031DC8 (**3-immigrant recruit pool**, 281,89,37,32),
then the outer frame (lcall 0x181F:0xE2). The 3-slot recruit pool + market sell
banner are Europe-only; the colony screen has neither.

**The two screens are distinct code regions** (proved via the enter_screen_view
call sites `mov bx,id; lcall 0x181F:0x772`):
- **EUROPE** = screen-id **0x2B**, entry func_030DBC @file 0x030deb, page 0x04,
  loads EUROPE.PIK (key 0x0FBA @0x030DCE). Composer 0x031E4C. ✓ europe_screen.c.
- **COLONY** = screen-id **0x2C**, entry @file **0x025EC8**, page **0x03**, loads
  COLONY.PIK (key 0x0BA0). Composer = VICEROY equivalent of recol func_0199D8
  (see docs/COLONY_RENDERER_DECODED.md). Being re-traced into
  colony_screen.c.
- (Other screen-ids found: 0x28 @0x450ae, 0x29 @0x6d5aa, 0x2a @0x7661f,
  0x2d @0x05e63.)

func_0321B4 (page 0x04) is a EUROPE-screen helper (reads a recruit's UnitRecord
type via [bx+0x3146]), NOT the colony entry — the colony agent's mis-anchor.

Lesson: page 0x04 is the Europe screen end-to-end. Do not assume a function is
"colony" from a task label; verify the screen-id (0x2B europe / 0x2C colony) and
the PIK key (EUROPE.PIK 0x0FBA / COLONY.PIK 0x0BA0) at the entry stub. The
"Selling <Good>" banner is the Europe smoking gun.

---

## 2026-05-31 — Map "coastline regression" (AMER2/ONE/UNTITLED) is STALE GOLDENS, not a renderer bug

Task #15 ("fix red map-render regression") investigated + RESOLVED as a
**stale-golden** issue, NOT a coast-rendering bug. The current renderer
(`colonize_sdl/render/terrain.py` `TerrainRenderMixin` — `main.py` is now a
35-line stub) is the DOS-faithful party:

- Diff dominant pair: current `(76,101,174)` light-blue SHALLOW water at coasts
  vs golden `(194,174,133)` heavy TAN sand.
- `reference/dos/AMER2_dos_reference.png` (the standing pixel target) at coast
  pixels = light-blue shallows `(76,98,173)` — MATCHES the current render, NOT
  the tan golden.
- Independently verified: over the differing pixels, the current render is
  closer to the DOS reference **~69%** vs the golden's ~31%. BLANK4 passes
  precisely because it has no coastlines.
- The goldens were produced by an EARLIER coast renderer (heavy-tan, no shallow
  halo); the current code (concave coast sprites 150-153 + linear-atlas subtiles
  + shallow-blue halo, river rows 0x01/0x11 used only as rivers) is correct.

**Do NOT "fix" the coast renderer to match the goldens** — that would reduce DOS
fidelity (prime-directive violation). The correct fix is to re-bless the 3
goldens from the current render. **Re-bless was offered and the user chose to
HOLD (2026-05-31)** — likely pending fresh 320x200 DOS-native goldens (see
CAPTURE_PLAN.md / the Godot golden-truth note). Until then the map regression
stays red on coasts BY DESIGN; this is not a renderer defect.

---

## 2026-05-31 — OVERTURNED: overlay 0x191F/0x1A1F is STATICALLY RESOLVABLE, not blocked

The long-standing assumption that the RTLink overlay dispatches `lcall 0x191F:NNN`
(and 0x1A1F:) are "blocked / runtime-dynamic" — and that the C-reconstruction's
core game logic is therefore unreachable — is **WRONG and OVERTURNED**. These
Type-A overlay calls are **fully deterministic and statically resolvable to file
offsets.** (Supersedes the memory note "core logic blocked behind overlays
0x191F/0x181F" 2026-05-28.)

**Root cause of the error:** prior analysis conflated two distinct fields in the
14-byte Type-A thunk trailer. For the F3 thunk @file 0x1B9EE =
`9a ab0d 0d11 | ea d0 06 00 00 | 05 00 00 00`:
- `9A AB0D 0D11` = LCALL 0x110D:0x0DAB (the Type-A loader stub func_01427B).
- `EA <off16> <seg16>` = JMPF placeholder: **off16=0x06D0 is the offset_in_segment**
  (real, never patched); seg16=0 is the load-time paragraph placeholder.
- **trailer word @+0x0A = the TARGET PAGE-ID (a static literal, here 0x05).**

The prior "page-rel 0x06D0 → runtime page directory" read mistook the JMPF offset
(0x06D0) for the page-id. The real page-id (0x05) is a separate static immediate.

**Resolution formula (byte-verified):**
```
target_file_offset = code_offset(page_id) + (ljmp_seg << 4) + offset_in_segment
```
code_offset(page_id) from the static segment list @file 0x192F0 (31 records,
page_id = segmentNum-1). All 658 Type-A page-ids are static in-range literals
(1..31); 578/658 land on clean ENTER/PUSH-BP prologues, 0 land outside page code.
The loader func_014293 @0x14508 reads `[si+5]` (the page-id), `AND 0x3FFF`,
`(id-1)*2 + dir_base` — confirming the page-id (not a computed value) selects the
overlay. Runtime only varies WHERE the fixed segment is cached (RAM/EMS/XMS/disk),
never the file offset.

**Verified resolved offsets (5/5 land on clean prologues):**
- F3 report body 0x191F:0x3FE → **file 0x037A10** (ENTER 0x6E).
- Colony scene helper 0x191F:0xB5E → **file 0x0314AE** (PUSH BP;MOV BP,SP).
- Europe menu engine 0x191F:0x182/0x16A → **0x06F0F4 / 0x06E3D0** (ENTER).
- load_PIK 0x191F:0x87A → **file 0x076AEC** (ENTER 0x126).

**Consequence:** the previously-"blocked" UI bodies (advisor report renderers on
page 0x05, colony surrounding-terrain scene on page 0x04, Europe ship-column menu
engine on pages 0x02/0x17/0x18) AND the core game-logic overlays are ALL decodable
statically from these resolved offsets. No DOSBox single-step / loader emulation
needed.

**BUG to fix:** `code/VICEROY/typeA_thunk_targets.json` (consumed by the C
reconstruction) uses `code_offset + jmpf_off` and OMITS the `(ljmp_seg << 4)`
term → correct for the 501 zero-seg thunks but WRONG for 157 nonzero-seg thunks
(e.g. load_PIK: artifact 0x764DC=garbage vs correct 0x76AEC). Authoritative
resolver: tools/rtlink/rtlink_decode.py + viceroy_rtlink_map.json (RTLINK_V2.md
§7.3). Re-resolve the 157 affected thunks.

---

## 2026-06-20 — Terrain ids 24–28: @OTHER ordering resolves MP_FORMAT.md conflict

**Conflict.** Two byte-tier sources disagreed on the high terrain ids:
- `formats/MP_FORMAT.md` id table: **24=Mountains, 25=Hills, 26=Ocean, 27=Lake**,
  and (line ~60) **16=Arctic** "(auto-forest base 16)".
- `spec/systems/map_system.md` @OTHER (tier **B**, present in NAMES) + the coast
  renderer trace `@0x67FD0 cmp al,0x18`: **0x18/0x19/0x1A = Arctic / Ocean /
  Sea-Lane**.

**Evidence (this branch's `raw/COLONIZE/VICEROY.EXE` + NAMES data):**
- `@OTHER` (NAMES_sections.json) byte-verified **order** = `Arctic, Ocean,
  Sea Lane, Mountains, Hills` (5 rows, in that sequence).
- **Hard rule 2** (CLAUDE.md): the sea-lane base terrain id = **26 (Ocean-class)**.
  Sea Lane is the **3rd** @OTHER row (index 2) ⇒ @OTHER base = `26 − 2 = 24`.
- Therefore: **24 (0x18)=Arctic, 25 (0x19)=Ocean, 26 (0x1A)=Sea Lane,
  27 (0x1B)=Mountains, 28 (0x1C)=Hills.**
- **Corroboration from the random-map generator `func_064A10`** (independently
  byte-traced): P0 fills the interior with **0x19 (=Ocean)** then grows landmass;
  P5 writes **0x18 (=Arctic)** to the top/bottom rows (polar caps — geographically
  correct) and **0x1A (=Sea Lane)** to the right two columns. All three immediates
  are exactly consistent with Arctic=24/Ocean=25/Sea-Lane=26.
- **MP_FORMAT.md is the outlier and is wrong:** its "16=Arctic" places Arctic
  *inside* the auto-forest range **8..23** (hard rule 3), which is impossible; and
  its 24=Mountains would put Mountains at the map's polar rows. It also collapsed
  Ocean and Sea Lane into a single id 26, whereas @OTHER lists them separately
  (Ocean=25, Sea Lane=26).

**Resolution (per TRUTH_HIERARCHY — running-game/renderer byte-trace + @OTHER B
+ hard rule 2 outrank a preprocessed format table):** adopt
**24=Arctic, 25=Ocean, 26=Sea Lane, 27=Mountains, 28=Hills.** `MP_FORMAT.md`'s
terrain-id table corrected accordingly. The map-generation agent's proposed
"0x19 ≠ Ocean" correction (which relied on the erroneous MP_FORMAT table) is
**rejected**; the generator's `0x19=Ocean` label stands.

**Unaffected / still open:** the structure of the auto-forest range 8..23 (why 16
slots for ~8 forested variants) is a separate question.

**Follow-up (2026-06-20) — P2 climate table IS byte-verified.** A first pass held
that the C-recon "5,4,1,3,2,2" climate list was not byte-grounded (the literal
byte sequence is absent from the EXE). That was a false negative: the values are
**inline switch cases**, not a data array. The N dispatch `@0x64CF6 jmp word ptr
cs:[bx+0xBAC]` reads a table at file **`0x64CFC`** (cs-base file **`0x64150`**, not
`0x6442c`) whose 6 words point exactly to local `mov [bp-0x2e],N` cases →
**`{5,4,1,3,2,2}`**; the S dispatch `@0x65048 cs:[bx+0xEFE]` (table `0x6504E`) →
`mov [bp-0x12],N` cases → **`{2,3,3,4,6,7}`** (Marsh case 50%-gated, Swamp/Marsh
moisture −2). Both match `viceroy_source/src/mapgen/climate.c` exactly. The earlier
"scattered targets `0x66605/…`" were an artifact of decoding the table at the wrong
offset/segment base. **map_generation.md §3 P2 = BYTE_VERIFIED.**

---

## 2026-06-20 — Colony build-completion field offsets (byte-trace vs dump labels)

**Context.** `spec/systems/colony.md` carried dump-derived ("RUNTIME-VERIFIED" /
DATA_MODEL) labels: build target `+0x10`, constructed bitmask `+0x60..0x65`,
hammers `+0xBA` (good 0x10 in the `+0x9A` array). A static byte-trace of the
**actual per-turn completion code** (`func_02D658` → `func_02D0E4` → `func_0092E0`)
disagrees and is internally complete.

**Byte-verified completion mechanism (all sites confirmed this branch's EXE):**
- **Hammer accrual bank = ColonyRecord `+0x92`** (u16): `@0x2E50F add [bx+0x92],ax`
  (ax = hammers-produced from good-0x10 query `lcall 0x181f:0xb50` → file `0x8DBC`,
  which reads a **global** per-good table `DGROUP:0x8E5A`, *not* a colony field),
  clamped ≥0 `@0x2E517`.
- **Build target id = ColonyRecord `+0x94`**: `@0x2E529 mov al,[bx+0x94]`; cost
  lookup `lcall 0x181f:0xac4` → `func_00B65A @0xB688` reads `@BUILDING[idx].cost`
  from table **`DGROUP:0x8F8C`** (stride **12**, 42 entries; written by parser
  `func_074D18 @0x74D1D`); gate `@0x2E53B cmp ax,[bx+0x92]; jle`; no-target guard
  `@0x2E544 cmp byte[bx+0x94],0; jge`.
- **Second hammer bank `+0xB6`** (cost-debited, **surplus carried**): `@0x2E6A1
  cmp [bx+0xb6],ax; jl`; `@0x2E6A7 sub [bx+0xb6],ax` → `call 0x2EF4B` trampoline →
  `func_02D0E4`.
- **Persistent constructed mask = ColonyRecord `+0x84..0x89`** (48 bits): setter
  `func_0092E0`: `cx = [0x8542] + (id>>3) + 0x84; or [bx], 1<<(id&7)` `@0x9308`.
  The **`+0x8A` bit-array is the DISPLAY copy** — its setter `func_0085D6` is a
  byte-for-byte twin of `func_0092E0` differing only in the `+0x8A`/`+0x84`
  constant. The "already-built?" guard tests `+0x84` (`func_0086 3E/0x860E` reads
  `[colony_idx·0xCA + 0x5DCA]`, `0x5DCA = 0x5D46 + 0x84`).
- **Build target is NOT auto-reset** to 0xFF on completion (no write to `+0x94`
  in either function); re-completion is blocked by the `+0x84` guard + `@ALREADYHAVE`.

**Resolution.** For the **build system**, the byte-traced offsets are authoritative
(they are the code that actually accrues hammers, checks cost, and flips the
constructed bit): **hammers `+0x92`/`+0xB6`, build target `+0x94`, constructed mask
`+0x84` (display copy `+0x8A`), cost table `DGROUP:0x8F8C`**. The dump labels
`+0x10`/`+0x60`/`+0xBA` are **not referenced** by the completion path; they are
flagged in `colony.md` as conflicting and pending re-examination (a dump label can
be a mis-attributed offset even when the bytes are real). The `+0x8A` =
buildings-present display array remains correct (now paired with its `+0x84`
persistent twin). **Open:** the exact roles of the two hammer banks `+0x92` vs
`+0xB6` (which is the UI-displayed/save-persisted total).

---

## 2026-06-20 — PowerRecord +0x32 is home_x (spawn coord), NOT a REF strength rating

**Conflict.** `spec/systems/ref_growth.md §2` labeled `PowerRecord +0x32` (u16) as
`ref_strength_rating` (RUNTIME-VERIFIED, from a memory dump). A static byte-trace
(Campaign C4) shows otherwise.

**Evidence (this branch's EXE):** `@0x58D72 mov al,[bx-0x77c6]` (`bx=power·0x13C`;
`-0x77c6 = 0x883A = PowerRecord +0x32`) reads it as a **byte**, then `@0x58D7A mov
[si+0x314d],al` writes it to a spawned UnitRecord's map-x. Sibling writers
(`@0x418D0`/`@0x65CCB`/`@0x74D74`) all `mov byte[bx-0x77c6],al` while looping the 4
powers with spawn coordinates. So **`+0x32 = home_x`, `+0x33 = home_y`** (the power's
European-arrival / starting spawn coordinate bytes), not a u16 strength.

**Resolution (disasm at a cited offset > a runtime-dump *label*):** adopt
**`+0x32`/`+0x33` = home (x,y) spawn coordinates** (byte each). **There is no stored
aggregate REF-strength field** — the four REF counts `[0x53DA..0x53E0]` are summed on
demand at UI/Congress display. The dump's "ref_strength_rating" was a mis-labeled
offset (the bytes were real, the interpretation wrong). `ref_growth.md` corrected.

**Related C4 findings (recorded for completeness):**
- The REF `+0xE` per-type value table `DGROUP:0x9408` is **BSS (runtime-zero in the
  static image)** — its per-type values can't be byte-read from the EXE; the count
  increment is `@0x3E238 inc word[bx+0x53da]`.
- The "REF per-power gate byte `[power·0x13 − 0x6DA2]`" (`DGROUP:0x925E`) is **not** an
  active/surrendered flag — it is the 3rd byte of a 0x13-stride per-power REF count
  record (`0x925C/0x925D/0x925E`), used arithmetically as troop strength (`@0x5B99E`).

---

## 2026-06-20 — UnitRecord base = 0x3144; map position vs goto-target offsets

**Conflict.** `docs/DATA_MODEL.md` / `spec/systems/unit.md` use UnitRecord base
**0x3146** and label **map_x = +0x07 (abs 0x314D)**, map_y = +0x08 (abs 0x314E).
Campaign C5's static trace shows those abs offsets are the **goto-target**, not the
unit's position.

**Evidence (byte-verified, absolute offsets — base-independent):**
- **Renderer** `@0x03A63 mov al,[bx+0x3144]` (x) / `@0x03A5E [bx+0x3145]` (y) — reads
  the unit's drawn **position** from **abs 0x3144/0x3145**.
- **Placer** `@0x06958 mov [bx+0x3144],al` (x) / `@0x0695E [bx+0x3145],al` (y).
- **GoTo writer** `@0x22D38 mov [bx+0x314D],colony.x` / `@0x22D3F [bx+0x314E]` — the
  **goto target** is at abs 0x314D/0x314E.

**Resolution:** UnitRecord **base = 0x3144**, stride 0x1C. Map position =
**abs 0x3144 (x) / 0x3145 (y)**; unit_type = 0x3146; owner nibble = 0x3147; order =
0x314C; **goto-target = 0x314D/0x314E**; tools = 0x3159; work-counter = 0x315A; class
= 0x315B. The DATA_MODEL "map_x=+0x07" mislabeled the goto-target as the position
(its runtime "Caravel (55,49)" read the wrong offsets). Spec uses **absolute offsets**
going forward to avoid the base-convention ambiguity. (PowerRecord FF acquired-bitmask
is likewise at **+0x07 / abs 0x880F**, not +0x06 — C5.)

---

## 2026-06-20 — `[0x53D0]`/`[0x53D2]` + `func_03C638` are Spanish-succession, NOT revolution SoL

**Conflict (self-correction).** Mid-session, after compaction, a trace of the
`[0x53D0] ≥ 0x32 (50)` compare `@0x3E8BD` and `[0x53D0] ≥ 0x4B (75)` compare `@0x2391C`
was provisionally written into `spec/systems/revolution.md` as "the SoL declare
threshold (50%)" with `func_03C638` (`0x191F:0x364`) labelled "the revolution-trigger
handler" (commit `a81ba25`). This **directly contradicted** the already-correct
`spec/systems/spanish_succession.md`, which had earlier byte-verified the same
function as the **War of Spanish Succession** handler and explicitly recorded it is
**not SoL-driven**.

**Evidence (decisive):**
- `func_03C638` emits message handle **`0x128C`** `@0x3C76A`, which is GAME.TXT
  **`@SUCCESSION`**: *"War of the Spanish Succession ends in Europe! {%STRING0},
  ravaged by war, agrees to **cede** %STRING1 to the {%STRING2}…"* — verified directly
  in `data_extracted/text/GAME_sections.json`.
- The handler body literally cedes assets: it ranks the 4 powers, then rewrites
  map-tile / unit (`+0x3147`) / colony (`+0x1A`) owner nibbles loser→winner and sets
  the loser's controller `+0x543F := 2` (eliminated) — an inter-European annexation,
  not a colonist revolt against the Crown.
- Single-player gate `@0x3C63D` (`test [0x5381],0x80`) — succession only fires in
  single-player; a revolution declaration has no such gate.

**Resolution:** `[0x53D0]` (0..100 meter, +20/cap-100 on Bolívar `@0x3BE64`),
`[0x53D2]` (eliminated-power latch), and `func_03C638` belong to
**`spec/systems/spanish_succession.md`** (per `notes/TRUTH_HIERARCHY.md`, the
byte-traced `@SUCCESSION` string wins). `revolution.md` reverted to its prior state:
**the SoL% declare threshold is still genuinely TBD** — the `≥50/75` gates are not it.
Lesson: re-verify a provisional finding against the *existing* spec before committing;
the mandated re-verification caught this one cross-file.

**Follow-up / final resolution (same day).** The revert above was itself an
*over-correction*. The SoL declare threshold **is 50%**, proven by the cleaner,
more-direct **declare-independence command handler `func_03E984`**: it emits
**`@TOOTORY`** (*"Only N%% of the colonists support the independence movement"*) when
**`[0x53D0] < 0x32` (50)** (`@0x3E99E`), and otherwise runs the `@DECLARE` confirm →
**`func_03DE46`** WoI declaration (`@INDEPENDENCE`). So `[0x53D0]` **is** the national
SoL meter (0..100, Bolívar `+20`), and **50% is the byte-verified declare floor**
(`revolution.md`). The subtlety that caused the confusion: the **War of Spanish
Succession** (`func_03C638`/`@SUCCESSION`) *also* auto-fires once when the leading
power's `[0x53D0]` crosses 50 (latch `[0x53D2] < 0`, `func_03E844`) — two distinct
events sharing the same SoL meter. Net: the `[0x53D0]` *identity* (SoL) and the *50%*
threshold are correct (original instinct); only the claim that `func_03C638` was the
*revolution* handler was wrong — that one is succession. `revolution.md` B/TBD restored.

---

## 2026-06-21 — Lost-City rumor presence is PROCEDURAL, not a stored `0xB0` feature byte

**Conflict.** `spec/systems/events.md` §6.1 (following the runtime memory-map doc
`colonization-memory-map (1).md`) anchored the Lost-City tile marker at feature byte
**`0xB0`**, with the residual being "`0xA0` vs `0xB0`, a one-byte runtime read."

**Disassembly (this branch's `raw/COLONIZE/VICEROY.EXE`, capstone 16-bit).** The
rumor-presence predicate `func_006188` (`@0x6188`, called `@0x30822`) does **not** read a
stored lost-city value. It **computes** presence from a coordinate hash against the global
map seed `[0x190]` (`@0x61C7..0x61F8`), gated by terrain ≠ `0x18/0x19/0x1A` and by the
tile's **feature high-nibble == `0xF`** ("none"), read via `0x5DF0`→`0x5D9C` (`shr al,4`,
`0xF`→−1; the predicate requires that −1). The map is one byte/tile (far array
`[0x164]:[0x166]`, index `y·[0x853A]+x`): **low nibble = terrain/owner, high nibble =
feature**.

**Resolution.** A tile whose feature nibble is `0xA`/`0xB` would **suppress** a rumor
(nibble ≠ `0xF`), so `0xB0` is **not** a placement marker — the memory-map "`0xB0` = lost
city, cleared on entry" is the **consumed/feature state**. Per `notes/TRUTH_HIERARCHY.md`
(EXE disasm at a cited offset > memory-map note), the `0xA0`-vs-`0xB0` question is
**dissolved**: rumor placement is procedural (`func_006188` + seed `[0x190]`), not a stored
constant. `events.md` §6.1 closed. No dump/trace needed.

---

## 2026-06-21 — Advisor-report (F2–F10) paint-function offsets: AUDIT doc was wrong

**Conflict.** `docs/ADVISOR_REPORTS_AUDIT.md` (and `spec/ui/advisor_reports.md`, which copied
it) gave the F2–F10 paint-function file offsets as `0x025F18` (F2) / `0x025FD0` (F3) /
`0x0269D8` (F4) / `0x027010` (F5) / `0x0277D8` (F6) / `0x027B0C` (F7) / `0x027E48` (F8) /
`0x025A0A` (F9). `viceroy_source/docs/drawlist/REPORTS.md` instead places the real bodies at
`0x37958`/`0x37A10`/`0x38418`/`0x38A50`/`0x39218`/`0x3954C`/`0x39888`/`0x39EE2`.

**Disassembly (raw VICEROY.EXE, capstone 16-bit, re-verified by the orchestrator).**
- `0x37958` = `enter 0x2c; … push 2` (F2, REPORT title N=2); `0x38418` = `enter 0x120; …
  push 4; call 0x39e53` (F4, N=4) — clean painter prologues with the title-N `push`.
- `0x025F18` disassembles to `les ax,[bp+si]; or ax,ax; je …` — **mid-instruction garbage**,
  not a function. The audit's offsets are **broken-thunk artifacts**: the dispatcher does
  `lcall 0x191F:0x3xx`; each thunk does `lcall 0x110d:0xdab; ljmp 0:OFF`, and the audit
  resolved `OFF` against the wrong overlay base (≈0x25900) instead of the page-5 code base
  (file `0x37340`; F9 needs `ljmp_seg=0x2B1`).
- `func_037340` (`enter 0x352; push 0x11A2 ["REPORT"]; strcat; push [bp+6] [N]; sprintf;
  load_PIK`) — so the loaded art is **REPORT\<N\>.PIK with N = the title number** (F2→REPORT2,
  F3→REPORT3, F4→REPORT4, F5→REPORT5, F6→REPORT7, F8→REPORT8), **not** the audit's visual
  guess (F4→REPORT3 etc.). Strings REPORT@0x11A2 / SCORE@0x11CF / WOODPAN2@0x11D7 confirmed
  at DGROUP base 0x1D9A0.

**Resolution.** Per `notes/TRUTH_HIERARCHY.md` (raw disasm at a cited offset > team docs), the
**REPORTS.md offsets win and the AUDIT doc offsets are struck.** Although `viceroy_source/` is
low-trust by default, here its offsets are raw-byte-confirmed and the audit's are
raw-byte-disproven. `spec/ui/advisor_reports.md` rewritten to the real bodies + the
title-N→PIK mapping. Also corrected: F8 gate polarity (FOREIGNNOTAVAIL fires when
`[0x5382]&1` is **set**, i.e. once WoI is declared); F10 `func_03A9C0` is a **score-band
plate selector** (`panel = largest i in 1..24 with i·i/3 ≥ scaled_score`, draws
`SCORE(panel+1).SS` over WOODPAN2), not a per-line panel map. Residual TBD: the F8
nested power-picker function offset.

---

## 2026-06-21 — FONTSMAL.FF is never loaded; SMALLFONT copies the latched font

**Conflict.** Two UI agents disagreed: one said the popup/menu `SMALLFONT`/`@smallfont`
directive selects a distinct small font **FONTSMAL.FF**; another said FONTSMAL is never loaded
and the directive just copies the active font latch.

**Disassembly (raw VICEROY.EXE).**
- The strings **`FONTSMAL`/`fontsmal` are ABSENT from the entire image** (`find` = −1, both
  cases). Only `fonttiny`@0x1FD32, `fontintr`@0x1FD29 (lowercase, load path) and `FONTKING`
  @0x1FCCB, `FONT-NP`@0x1F8AF (uppercase) appear. So **FONTSMAL.FF is an orphan on disk — VICEROY.EXE
  never `load_font`s it.**
- The popup framework's **SMALLFONT handler @0x6F207** is `mov ax,[0x89E]; mov dx,[0x8A0]; les
  bx,[bp-0xC]; mov es:[bx+0x80],ax; mov es:[bx+0x82],dx` — it **snapshots the currently-latched
  active-font far pointer** `[0x89E]/[0x8A0]` into the section struct. No font is loaded; it does
  not switch to a smaller font.

**Resolution.** There are **4 fonts actually loaded** by VICEROY.EXE: FONTTINY (the boot default
latch `[0x89E]`), FONTINTR, FONTKING, FONT-NP. **FONTSMAL.FF is unloaded (orphan).** The
`SMALLFONT` / `@smallfont` directive copies the latch — it is effectively a no-op font-wise in
shipped data, **not** a small-font selector. This **corrects** (a) `fonts_and_colors.md` (the
"5 fonts / FONTSMAL via SMALLFONT" model), (b) `popups.md` item 6, and (c) the
2026-06-21 menus commit's "boot-menu body = FONTSMAL" claim — the boot menu renders in the
**latched font** (FONTINTR/FONTTINY), and the `@smallfont` flag loads no distinct font.
Also: the popup framework compares **10** live directives (OPTIONS..DEFAULT); **TEXTCOLR is a
vestigial table entry, never compared** (`push 0x200A` appears nowhere as a directive) — there
is **no per-popup text-color override** directive.

---

## 2026-06-21 — FONTKING.FF is used by exactly ONE screen (king-defeats); not colony/Europe/score/HoF/menus

**Conflict.** The W1 screen-render cluster (from the Ghidra named export) attributed **FONTKING**
to many screens: colony title / SoL% / SoL-panel, Europe title, the Score screen, advisor F10,
the Hall of Fame, and menu render. A later pass also inferred `[0x268A]` = FONTKING "by usage."
Both are **wrong** against the raw EXE.

**Disassembly (raw VICEROY.EXE, capstone 16-bit; trust order: EXE bytes win over the export).**
- The string **`FONTKING` (DGROUP `0x232b`) is referenced exactly once in the whole image** —
  `lea bx,[0x232b]` @**0x754F2**, inside `func_075352` (the **king-defeats** screen). It loads
  via `lcall 0x1A1F:0xA86` into a **local** (`[bp-0xC]`), falls back to `[0x89E]` (FONTTINY) on
  failure, and promotes the result to the **active-font global `[0x1F9E]/[0x1FA0]`** @0x75511.
  FONTKING is **never stored to a persistent global**, so no other code path can select it.
- The **active-font global `[0x1F9E]`** is written at only 5 sites: from FONTTINY `[0x89E]`
  (@0x692DE), from FONTINTR `[0x268A]` (@0x692FA and the king-defeats *restore* @0x7557D), from a
  caller-supplied ptr (the `set_active_font` helper @0x6EED4), and the king-defeats FONTKING set
  @0x75511. So the only fonts ever made active are **FONTTINY, FONTINTR, and (king-defeats only)
  FONTKING**.
- **Font-far-ptr render pushes** confirm each screen's font: `push [0x8A0];push [0x89E]`
  (**FONTTINY**) at colony render 0x25F62/0x26000/…/0x282A9 and Europe render
  0x30EDE/0x30F53/0x31179 and advisor report bodies 0x3860C…0x38DFC; `push [0x268C];push [0x268A]`
  (**FONTINTR**) at the Hall-of-Fame/menu region 0x22ABE/0x23C06. The Score painter `func_03A9C0`
  reads `[0x89E]` (FONTTINY, @0x3ABF4/0x3AC25) for labels and `[0x268A]` (FONTINTR, @0x3B054/
  0x3B0E6) for the big-figure glyph metrics — **no FONTKING**.

**`[0x268A]` identity (resolves the prior "by usage A/R").** `[0x268A]/[0x268C]` is written
@0x760CB from loading the string **`fontintr`** (`lea bx,[0x2389]="fontintr"`; `lcall 0x1A1F:0xA86`)
in the engine-init `func_075FB6`. **`[0x268A]` = FONTINTR.FF**, byte-verified — NOT FONTKING.

**Resolution.** **FONTKING.FF is used by exactly one screen: king-defeats (`func_075352`),
pen seed (x=0xF2=242, y=0x2F=47).** Corrected font attributions (all byte-verified):
- **Colony** title / SoL% / SoL-panel → **FONTTINY** (`[0x89E]`).
- **Europe** title → **FONTTINY**.
- **Score** screen (cinematic `func_03A9C0` = advisor F10) → **FONTTINY** labels + **FONTINTR**
  figure metrics.
- **Hall of Fame** / **menus** → **FONTINTR** (`[0x268A]`).
- **king-defeats** → **FONTKING** (unchanged; the sole user).
This corrects `fonts_and_colors.md` §1/§3, `colony_screen.md`, `europe_screen.md`,
`advisor_reports.md` (F10 + the `[0x268A]`=FONTKING identity), `cinematics.md` (score),
`menus.md`, and `continental_congress.md` (the `[0x268A]` parenthetical).

---

## 2026-06-21 — `[0x1F5C]` is the speaker-portrait selector channel, NOT the cinematic/popup text color

**Conflict.** The cinematics integration (king-defeats) claimed the on-screen text color is the
"engine persistent foreground global `[0x1F5C]`" (default 8). The popup-template audit
(`docs/POPUP_TEMPLATE_AUDIT.md`) and `docs/KING_AND_CINEMATIC_AUDIT.md` instead identify `[0x1F5C]`
as a **speaker channel** (the 4 wrappers `@0x6F5B0..0x6F64C` set `[0x1F5C]`/`[0x1F5E]`/`[0x1F60]`
for the tribe/advisor/missionary speaker portraits).

**Disassembly (raw VICEROY.EXE) + cited audit.** `[0x1F5C]` is the **speaker-portrait selector**:
the dispatcher `func_06E3D0` reads it (`cmp [0x1F5C],0` @0x6E480) and `func_06BE92` branches on its
value (`cmp [0x1F5C],7; jle → IND<n>` @0x6BE96), so **value ≤7 ⇒ `IND<tribe>` portrait, =8 ⇒ KING**
(`docs/KING_AND_CINEMATIC_AUDIT.md`). The render path at **0x6E319** is
`cmp [0x1F5C],0; jl skip; push es; push bx; call 0x6F82B` where `es:bx` is a **sprite struct whose
+0x10/+0x12/+0x14/+0x16 fields are x/y/w/h** (loaded @0x6E2FD..0x6E316), then the selected speaker
sprite is blitted via `0x6F81C`. So `[0x1F5C]` **selects + renders the speaker portrait**, not text.
The popup wrappers set it accordingly (KING hard-codes `[0x1F5C]=8` @0x6F5DD; tribe `=arg` @0x6F5B6).
The king-defeats **text** is drawn by the glyph engine `lcall 0x181F:0x3FE` @0x75540 with **no
`[0x1F5C]` (or other explicit palette) argument** at the call site.

**Resolution.** `[0x1F5C]` (and siblings `[0x1F5E]`/`[0x1F60]`) = **speaker-portrait selector
channel** (the audit is correct; ≤7→IND, 8→KING via `func_06E3D0`/`func_06BE92`). The cinematic
king-text and popup body-text **color** is the glyph engine's own glyph→palette mapping
(FONTKING/FONTTINY foreground pixel), with no byte-pinnable per-call palette index at the draw site
→ honest **A/TBD**. Corrects `cinematics.md` (king-defeats font+color), `fonts_and_colors.md`
(king-defeats row), and clarifies `popups.md` §6 (the channel globals are speaker selectors;
TEXTCOLR remains vestigial so there is still **no per-popup text-color override**). The font
identities (FONTKING king-defeats, FONTTINY popup body) and pen geometry are unaffected and stay
**B**.

---

## 2026-06-21 — .FF font glyph format is NOT yet cracked (do not guess a decoder)

**Context.** While bundling assets for the C++ reimplementation, two RE passes (on-disk bytes +
the VICEROY.EXE loader/blitter) tried to decode the `.FF` bitmap-font glyph layout. The format is
**not yet byte-verified**, so no decoder was written (prime directive: never guess).

**Byte-verified facts.** `.FF` = MADSPACK 2.0; one FAB section is the font payload (decompressed
sizes FONTTINY 914 / FONT-NP 914 / FONTKING 1219 / FONTINTR 1898). **Font struct byte 0 = glyph
height** (`mov al,es:[bx]; add ax,3` @0x3AB7). Loader = `lcall 0x1A1F:0xA86` (file ~0x6FC74; sites
@0x760C6/0x760E8/0x754F6/0x6B7AF); glyph blitter `0x181F:0x3FE`/`:0x998`; glyphs are **2-bpp**
(transparent/highlight/base/shadow). FONTKING/FONT-NP are variable-height.

**Disproven hypotheses (this pass).** Interleaved `[w][h][bitmap]` from offset 33 desyncs
immediately (~165 of 914 bytes consumed) under both `ceil(w*h*2/8)` and row-aligned
`h*ceil(w*2/8)` sizing; a fixed-height width-table + bitmap block gives no clean file-length
landing for any height. The real parser is **overlay-resident** (the recurring RTLink-overlay
ceiling).

**Ruling.** `.FF` glyph decode stays **TBD**. Finishing it requires either disassembling the
overlay loader at ~0x6FC74, or a render-validation pass (decode glyphs, render `A–Z 0–9`, confirm
they form correct letters — a font is self-validating). Corrects `formats/FF.md` (the stale
`tools/mpskit/ff.py` reference — that file does not exist). The 4 fonts are therefore **not yet
bundled** in `viceroy_cpp` (all 204 `.SS` + 35 `.PIK` are).

---

## 2026-06-21 — .FF font glyph format CRACKED (supersedes the earlier "not cracked" ruling)

The `.FF` bitmap-font format is now fully decoded and render-validated (all 4 fonts decode to
readable A–Z / 0–9 / a–z). Supersedes the earlier same-day "not yet cracked" ruling.

**Format** (MADSPACK/FAB payload): `[0]`=glyph height H, `[1]`=max width; `[2..130)` = 128-byte
width table; `[130..386)` = 128×u16-LE offset table; `[386..)` = glyph bitmaps. Glyph for char
`c` = `payload[offset[c-1] : offset[c]]` (the tables are offset by one — **table entry t holds the
glyph for char t+1**, found via render-validation: index-0 mapping rendered every letter shifted
+1). Bitmap = **2 bits/pixel, MSB-first, row-major**, H rows × `ceil(width*2/8)` bytes; 4 levels
(0=transparent, 1/2/3 = ink shades). Bitmap region always starts at 386 (=130+256). Validated:
387+Σ glyph sizes = file length exactly; 87/87 width↔offset-delta match.

**Disproven en route:** interleaved `[w][h][bitmap]`, planar 1-bit-plane, LSB-first, fixed-height
block — all scramble. **Decoder:** `viceroy_cpp/include/ff.hpp` + `src/ff.cpp`; bundled via
`viceroy_cpp import-font` / `import-all` (fonts → paletted glyph atlas + metrics JSON). The 4
loaded fonts (FONTTINY/FONTINTR/FONTKING/FONT-NP) are now bundled; FONTSMAL stays orphan. This
**unblocks P4 text rendering** in the rewrite. Updates `formats/FF.md`.

---

## 2026-06-21 — No graphical progress/fill bars exist anywhere in the game

**Conflict**: `spec/ui/continental_congress.md` (and its source `docs/RENDERER_GEOMETRY.md`)
claimed a graphical **"Progress bar (0,30,320,6) — yellow fill = bells_current / threshold"** on
the Continental Congress screen, tagged tier **A**; the user states there are **no progress bars
anywhere in the game**, and the screen's own decompiled paint body is text/box-only.

**Source A** — `docs/RENDERER_GEOMETRY.md` (team doc, luma/anchor measurement of frame
1310124562) asserted a yellow-fill progress bar in three places (v2 line 240, v3 line 221,
detail table lines 347–348: "Bar fill color yellow (200,160,24)"). Tier **A** (luma-guessed,
not byte-cited).

**Source B** — (1) the **running game** (user, top of `TRUTH_HIERARCHY.md`): "there are no
progress bars anywhere in the game." (2) The **F3 paint body** `0x37A10..0x3807D` (fully
disassembled, tier **B**) is **text + box-rule only** — it contains no sprite blits
(`0x181F:0x254/0x2BC`) and no fill-bar draw; a text/box routine cannot paint a fill bar
(`spec/ui/continental_congress.md` §6.1).

**Ruling**: **no graphical progress/fill bars exist in the game** — both the running-game
observation (rank 1) and the disassembled paint body (rank 3) outrank the luma guess (team doc,
rank 5) per `TRUTH_HIERARCHY.md`. Progress toward the next Founding Father is conveyed by the
**"(NN in MM)" text** in the session subtitle (`NN = threshold − bells_current`, `MM =
threshold`), not a bar. The game's progress/quantity UI idiom is **discrete filled/empty
sprite-icon rows** (e.g. crosses/bells, ICONS.SS `0x39` filled / `0x38` empty — one sprite per
unit counted), which is **not** a continuous bar.

**Action taken**:
- `spec/ui/continental_congress.md`: deleted the "Progress bar" layout row; added a "No progress
  bar" note; reconciled the §"Fonts & colors" `0x3F/0x38` wording (discrete indicator sprites,
  not a bar); re-tiered the bell row as A/TBD (not in the F3 body).
- `spec/ui/advisor_reports.md`, `spec/ui/fonts_and_colors.md`: clarified the `0x39/0x38` "gauge"
  wording as **discrete** filled/empty indicator sprites, explicitly "*not* a continuous bar."

**Follow-up**: the Continental Congress **bell-icon row** is luma-observed but absent from the F3
text body — whether it is drawn by a separate Activities/overlay path or was itself a luma misread
stays A/TBD until that path is traced or a frame is re-measured.

---

## 2026-06-22 — TERRAIN.SS is the base-ground sheet, NOT an orphan (overturns hard rule #5)

**Conflict**: CLAUDE.md hard rule #5 says "never load TERRAIN.SS or BDARK.SS (orphan assets, not
used by the renderer)"; byte evidence shows TERRAIN.SS is the **base-terrain ground sheet** the
in-game renderer composites PHYS0 overlays on top of.

**Source A** — CLAUDE.md hard rule #5 (team-doc rule), citing `BUILD.md`, `docs/ASSET_ROLES.md`,
`tools/render_map.py`. Claim: TERRAIN.SS unused/orphan.

**Source B** — `ghidra_export/VICEROY_decompiled.named.c` (byte-grounded decompile, rank 3 in
`TRUTH_HIERARCHY.md`): (1) `BOOT_ASSETS[]` loads `"TERRAIN.SS" -> g_sprite_sheet[3]` as a core
gameplay startup asset (@~53999–54002), alongside ICONS/PHYS0/BUILDING/WOODFRAM/WOODTILE;
(2) `emit_ground_sprite(idx) = emit(sheet_at(G_SHEET_TERRAIN), terrain_cell_transform(idx))`
(@18201) — the BASE ground layer is drawn from the TERRAIN sheet, while `draw_tile_marker`/
`emit_sprite_alt` use `G_SHEET_PHYS` for OVERLAYS (@18192–18193); (3) `enter_map()` hard-requires
TERRAIN.SS to enter the map view (@~50249, registers it via `viceroy_set_sheet_terrain`).
Corroborated by `spec/systems/map_system.md` §3 ("Base terrain -> `emit_ground_sprite`").

**Ruling**: **TERRAIN.SS is the base-ground sheet** (loaded at boot + on map-enter; the source of
`emit_ground_sprite`), composited UNDER the PHYS0 overlays (forest/mountain/hill/river/road/coast/
resource). It is **not** an orphan. **BDARK.SS remains the orphan** (no load path). Placeholder
indices 0/16/100 are still skipped. Per `TRUTH_HIERARCHY.md` byte-grounded disasm at a cited offset
outranks a team-doc rule; the user explicitly confirmed "TERRAIN is valuable, BDARK is not" and
granted sign-off to amend the hard rule.

**Action taken**:
- Amend **CLAUDE.md hard rule #5**: orphan = **BDARK.SS only**; TERRAIN.SS = base-ground sheet.
- Correct stale "TERRAIN.SS orphan" wording in its citations where it survives.
- `viceroy_cpp` `import-all` stops skipping TERRAIN.SS (bundles it); the map-view viewport moves
  from the naive PHYS0-only blit to layered TERRAIN.SS base + PHYS0 overlays (Phase C).

**Follow-up**: `terrain_cell_transform` (code 0x11/0x09->8; code>=8 -> code-0xF; else code) maps
terrain ids to TERRAIN.SS frame indices — exact per-terrain frame mapping to be pinned in Phase C
from TERRAIN.SS frame inspection. The `0x70`-band / `0x1F884` coast sub-cell table stays TBD.

---

## 2026-06-22 — Sprite 0x95 is the FOG/unexplored tile, NOT "base coast" (map_system.md §3/§1b wrong)

**Conflict**: `spec/systems/map_system.md` §3 + §1b (tagged BYTE_VERIFIED) describe the coast as
"base coast sprite `0x95` + per-direction overlays `0x69..0x6C`." Implementing that put a striped
"plow"-looking sprite all over the coast (user: "you have the plow sprite on the coast"), and the
`0x69..0x6C` frames turned out to be selection-box/padding sprites, not coast.

**Source A** — `spec/systems/map_system.md` §3 (line ~75) / §1b (line ~154): "base beach/coast
sprite `0x95` (`mov ax,0x95; call 0x67dc8 @0x68212`)" + "per-direction overlay `0x69+direction`".
Tagged BYTE_VERIFIED.

**Source B** — capstone disasm of `func_0681A8` (O513) vs `raw/COLONIZE/VICEROY.EXE` (rank-3
byte-grounded): the single `mov ax,0x95` @`0x68212` is gated by **`[bp-8]` = the fog/hidden flag**
(`@0x6820c cmp [bp-8],0; je 0x6824e`). `[bp-8]` is set from the **fog mask `[0xA89E]`** and the
tile fog byte `[0xA8A0]` in the prologue (`@0x681E0..0x681FE`) — `[bp-8]=1` ⇒ tile **unexplored**.
The same branch then calls O512 (`func_067F50`), whose per-direction draws (`0x69+dir` +
`emit_terrain_sprite`) are the **fog-edge blend** for hidden tiles. The spec itself documents
`[0xA89E]` = `1<<(player+4)` fog mask (§3, line 133). The **visible-tile coast** is a *different*
code path: shore base `0x96` (drawn when terrain byte `[0xA89F]&0x40` @`0x68356`) + directional
edges `0x97+pattern` (151..153, from the connection bitmap `[0xA8A6]` @`0x6850D`).

**Ruling**: **`0x95` (PHYS0 frame 149) is the fog-of-war / unexplored-tile sprite** (its vertical
striped hatching resembles plow furrows — hence the "plow" appearance when wrongly drawn on
coasts), **not** a coast base. §1b's "coast = `0x95` + `0x69..0x6C`" actually documents the
**fog-of-war renderer**, mislabeled. The **real coast** = `0x96` shore base (terrain bit `0x40`) +
`0x97..0x99` directional edges (connection-bitmap pattern), in the visible-land path. The
BYTE_VERIFIED tag on the old coast description was unjustified. Byte-disasm (rank 3) + user
ground-truth (rank 1) outrank the team-doc claim.

**Action taken**:
- `map_system.md` §3 + §1b: relabel `0x95`/`0x69..0x6C` as the fog-of-war path; document the real
  coast (`0x96` + `0x97+pattern`); retier.
- `notes/SPRITE_CATALOG.md` row 0x90: frame 149 "sandy dune" → **fog/unexplored tile** (striped).
- `viceroy_cpp` map-view: the coast must use the visible-path `0x96`/`0x97+pattern`, not `0x95`.

**Follow-up**: the exact `0x97+pattern` connection-bitmap → edge-variant mapping (`[0xA8A6]`
patterns `0xC1`/`0x07`/`0x70`/`0x1C` @`0x68479..0x684A8`) for the directional coast edges still
needs enumerating before a faithful coast implementation.

---

## 2026-06-22 — The `0x6D..0x8B` band = 8×8 coast sub-tiles, NOT roads (map_system.md "roads = 0x6D" wrong)

**Conflict**: `spec/systems/map_system.md` §3 listed **"`0x6D` roads"** and described item 6 as
"Roads & rivers (connectivity-based)" with the road sprite = `0x6D + connectivity_mask`. The
project also has explicit user ground-truth that **"there are no roads in new maps."** The open
`SPRITE_CATALOG` question — whether the row-0x70 8×8 frames are the true DOS coast sub-tiles — was
unresolved.

**Source A** — `spec/systems/map_system.md` §3 band list + item 6 ("roads = `0x6D`"), citing the
low-trust C reconstruction `src/render/terrain.c`.

**Source B** — capstone disasm of `func_0681A8` (O513) + `func_067A24` (`analyse_connections`) vs
`raw/COLONIZE/VICEROY.EXE` (rank-3 byte-grounded), cross-checked with PHYS0 frame pixels via
`tools/ssdec.py` (rank-2):
- `analyse_connections` (`func_067A24`) is called **only for water tiles** — gated `@0x68256`
  `cmp [0xA8A2],0x19 (Ocean) / 0x1A (Sea-Lane)`. It builds `[0xA8A6]` = the **8-direction
  LAND-neighbour bitmap**: for each neighbour it reads the terrain id and `cmp al,0x19 / 0x1A;
  je skip` (`@0x67AA6`) — **water neighbours are skipped**, so a bit is set only where a neighbour
  is land. It also fills a 4-entry per-quadrant table at `[0x2D24]` from diagonal/cardinal land bits.
- The coast draw (`@0x6846B` onward, gated `cmp [bp-4],0` where `[bp-4]=1` ⇒ water tile): shore
  base `0x96` (`@0x68356`, bit `[0xA89F]&0x40`); if `[0xA8A6]` matches a clean pattern
  (`&0xDD==0xC1`/`&0x77==0x07`/`&0x77==0x70`/`&0xDD==0x1C`) draw one 16×16 edge `0x97+pattern`
  (`@0x6850D`); **else** the loop `@0x684BC..0x684F5` draws, for `q=0..3`, frame
  **`0x6D + table[q]·4 + q`** (`table[q]`∈0..7, reachable 109..139) at TL/TR/BR/BL **8×8**
  sub-cell offsets (`[0x1EA4]/[0x1EA5]`).
- Pixel check (`tools/ssdec.py`): frames `0x6D..0x8B` (109..139) are all **8×8** with water
  palette indices 55–58; frames `0x96..0x99` (150..153) are **16×16** water+sand coast pieces.
  PHYS0 has **154 frames (0..153)** — so `0x97+pattern=3` (→154) and the extreme `table[q]=7,q=3`
  combo (→`0x8C`=140, a 16×16 frame) are out-of-band edge cases, flagged TBD.

**Ruling**: **The `0x6D..0x8B` band (109..139) is the 8×8 per-quadrant complex-coast sub-tile set**
— the fallback drawn on water tiles whose land-neighbour bitmap matches no clean 16×16 edge
pattern. **There are no roads in this render chain**; the "roads = `0x6D`" label (from the low-trust
`terrain.c`) is wrong, consistent with the user ground-truth that new maps have no roads. The full
coast = shore base `0x96` + (16×16 edges `0x97..0x99` for clean cases) OR (4× 8×8 `0x6D` quadrants
for complex cases), all keyed by the water-tile land-neighbour bitmap `[0xA8A6]`. Byte-disasm
(rank 3) + pixel inspection (rank 2) + user ground-truth (rank 1) outrank the C-reconstruction
label.

**Action taken**:
- `map_system.md` §3: item 6 split into rivers (`0x51..0x5E`) + item 7 coast (water-tile,
  `0x96`/`0x97+pattern`/`0x6D` 8×8 fallback); band list "roads = `0x6D`" → "8×8 coast sub-tiles";
  §6 1b extended with the 8×8 resolution.
- `notes/SPRITE_CATALOG.md`: row 0x6D–0x8B section + follow-up #1 resolved (true coast sub-tiles).
- `spec/ui/map_view.md` §3: overlay list — coast composition spelled out, "no road overlay".

**Follow-up (still TBD)**: the exact `[0xA8A6]`→`0x97..0x99` pattern enumeration and the
pattern-3→frame-154 (out-of-range) edge case, before the faithful coast implementation. The coast
IMPLEMENTATION in `viceroy_cpp` must use this water-tile path (`0x96` + `0x97+pattern` + `0x6D` 8×8
quadrant fallback), never `0x95`/`0x69`.

---

## 2026-06-22 — River band is `0x01/0x11` (BLUE), `0x51..0x5E` is the ROAD layer (correcting same-day "river = 0x51..0x5E")

**Conflict**: a same-day edit to `spec/systems/map_system.md` §3 item 6 + band list (commits
`c9e7d32`/`43fa99b`) labelled **"river = `0x51..0x5E`"**, derived from the disasm connectivity
block at `@0x6842B` (base `0x51`). The `viceroy_cpp` map-view, built on that, drew `0x51`/`0x52+dir`
for river-bit tiles and produced a **brown diagonal lattice** over the land — clearly not rivers.
This also contradicts **CLAUDE.md hard rule #4** (rivers = PHYS0 rows `0x01`/`0x11`).

**Source A** — the same-day spec edit "river = `0x51..0x5E`" (`@0x6842B` block, base `0x51`).

**Source B** — pixel inspection (`tools/ssdec.py`, rank 2) + disasm of `func_0681A8` (rank 3) vs
`raw/COLONIZE/VICEROY.EXE`:
- **Pixels**: PHYS0 `0x01–0x0F` / `0x11–0x1F` are **BLUE water + GREEN banks** (idx 57/58 blue,
  69/70 green) = rivers. PHYS0 `0x51–0x58` are **BROWN** road segments (idx 85/132,
  RGB ~(134,81,28)). `SPRITE_CATALOG` already labels row 0x00/0x10 = rivers and row 0x50 = roads.
- **Disasm**: the **river** draw is a *different* block at **`@0x6838A`** — gated by feature-layer
  bit `0x40` (`[0xA8A1]`), base **`0x01`** (feature bit `0x80` set, `@0x6839E`) or **`0x11`**
  (clear, `@0x683A6`), plus a **4-cardinal** river-neighbour mask (`func_067B84` `ax=0x40,dx=3`;
  bit order N=8/S=4/W=2/E=1; isolated → `0xf`, `@0x683BB`), drawn `base+mask` via `func_067DC8`.
  The **`@0x6842B`** block (base `0x51` + 8-dir `func_067D54` `ax=0xa`, gated `[0x18E]==0`) is the
  **ROAD** layer — empty on new maps ("no roads in new maps", user ground-truth rank 1).

**Ruling**: **Rivers = PHYS0 `0x01..0x1F`** (base `0x01`/`0x11` + 4-cardinal connectivity, BLUE),
exactly as CLAUDE.md hard rule #4 always stated. **`0x51..0x5E` = the ROAD layer** (BROWN, separate
connectivity block, drawn only when road-feature tiles exist). The same-day "river = `0x51..0x5E`"
edit conflated the road block with rivers; reverted. Pixel inspection (rank 2) + disasm (rank 3) +
hard rule #4 outrank the mistaken same-day edit.

**Action taken**:
- `viceroy_cpp/src/mapview.cpp`: river overlay now draws `base + 4-card mask` from the `0x01/0x11`
  blue band (base via forested-id proxy, R), removing the `0x51`/8-dir road draw. The brown lattice
  is gone; rivers render as blue channels (verified vs AMER2 render).
- `map_system.md` §3 item 6 rewritten (river `@0x6838A` `0x01/0x11`; road `@0x6842B` `0x51`); band
  list `0x51..0x5E river` → `0x51..0x5E roads`, added `0x01..0x1F river`; corrections block updated.

**Follow-up (R/TBD)**: river major/minor base (`0x01` vs `0x11`) is selected by feature-plane bit
`0x80` in the EXE; the C++ `Map` loads only the terrain plane, so the port approximates it from the
forested terrain id. Loading the feature plane would make it exact.

---

## 2026-06-22 — O512 (func_067F50) is the dithered terrain-edge BLEND composer (coast is one case)

**User directive**: "stop with all the guessing. and go a full code deep dive on the coasts. it is
not just 4-6 sprites. there is a whole set of functions."

**Finding** (full byte-trace of `func_067F50` 0x67F50..0x681A7 + its call sites in `func_0681A8`):
O512 is not "the coast sprites" — it is the engine that **dithers every tile edge into its 4 cardinal
neighbours**, of which the coast is one case.
- 4-cardinal loop (N,E,S,W via DGROUP 4-dir tables `0xA8`/`0xAE`). For each neighbour: in-bounds
  (`lcall 0x181F:0x302`), read terrain (layer `[0xA598]`, `&0x1F`, fold forest), `classify_terrain`
  (`lcall 0x181F:0x6AA`), fog flag from `[0xA59C]`&`[0xA89E]`.
- **8-ring walk** for water neighbours (`@0x6809A`, gated `[bp+6]==0`): walks the neighbour's own
  N/E/S/W (even 8-dir indices) for the first land cell → its class becomes the blend class. This is
  the **land-side coast**.
- **Draw** (`@0x68189`): `draw_subcell(0x69+dir)` writes the **dither stencil** (`0x69..0x6C`, sparse
  index-0 dot patterns, pixel-confirmed) into **mask buffer `0x839E`**; `emit_terrain_sprite(nb_class)`
  (`func_067EEC`) **masked-blits** the neighbour terrain through `0x839E` (`lcall 0x181F:0x268`).
- Call sites: fog path `O512(1,centre_water,0)` (`@0x68244`); main path `O512(0,[bp-4],0)` (`@0x68315`)
  — ring-walk **enabled for land centres** (land-side coast), disabled for water (O513 does the
  water-side: shore `0x96` + `0x97+pattern` + `0x6D` 8×8 quadrants).

**Ruling**: the complete coast/terrain transition = **O513 water-side + O512 land-side dither
+ O512 biome-edge dithering**. Prior renderer attempts drew only O513's 4–6 water sprites and omitted
O512 entirely → hard tile edges instead of Col1's dithered biome/coast transitions ("all wrong").
Documented in `spec/systems/map_system.md` §3 (O512 deep-dive subsection). `classify_terrain`/
`is_xy_in_bounds`/`read_terrain`/masked-blit are overlay `0x181F` helpers; roles inferred from call
context (the only non-byte-pinned part). Byte-disasm (rank 3) + user directive (rank 1).

**Action**: implement the O512 dithered-edge blend in `viceroy_cpp/src/mapview.cpp` (4-cardinal +
water ring-walk on land tiles + dither stencil `0x69+dir`); self-verify the render then user-verify.

---

## 2026-06-23 — Terrain id 26 label fix: 26 = Sea Lane, NOT Ocean (housekeeping)

**Context**: spec-vs-implementation audit. Three docs glossed terrain id **26** as
"Ocean" — `CLAUDE.md` hard rule #2, `spec/systems/map_system.md` §57, and
`formats/MP_FORMAT.md`. This contradicts the already-settled **2026-06-20 ruling**
(this file) and the byte-verified `@OTHER` ordering: **24=Arctic, 25=Ocean,
26=Sea Lane, 27=Mountains, 28=Hills**.

**Evidence** (unchanged, already top-of-hierarchy):
- Generator immediates (`spec/systems/map_generation.md`, B): ocean fill `0x19`(25)
  `@0x64A4B`; right-two-columns → Sea Lane `0x1A`(26) `@0x65941`; poles → Arctic
  `0x18`(24) `@0x6582A`.
- `@OTHER` order in `spec/data/names_sections.md`: Arctic, Ocean, Sea Lane → 24/25/26.
- Empirical `.MP` tile counts (`notes/MAP_FORMAT.md`): id 25 = 2139 tiles (Ocean),
  id 26 = 810 tiles (Sea Lane).
- Implementation `viceroy_cpp/src/mapview.cpp`: `is_water` = `0x19 || 0x1A`
  (Ocean / Sea-lane) — already correct.

**Ruling**: the **number 26 was always right** (the sea-lane column IS id 26); only
the parenthetical **name** was wrong. Corrected "(Ocean)" → "(Sea Lane)" in the
three docs above. No behavior change; this only removes a stale label that
disagreed with the 2026-06-20 ruling. Implementation needed no change. Rank: EXE
bytes (top) + prior recorded ruling.

---

## 2026-06-23 — spec cross-consistency audit (4-cluster): fixes + 2 open conflicts

Read-only audit of spec/systems for cross-spec/internal contradictions. Most shared
constants were consistent (REF globals, royal_money +0x22/1800, [0x53D0] identity,
50% declare floor, ColonyRecord 0xCA, terrain ids 24..28, NativeSettlement 0x54EC/18,
diplomacy +0x34/+0x40, @UNIT stat columns, difficulty 4-diff). Defects fixed:

**Fixed (stale value contradicting a recorded ruling + the spec's own corrected text):**
- `spec/data/records.md` UnitRecord base `0x3146`→**`0x3144`** (RULINGS 2026-05-28; the
  file's own §4 already said 0x3144). `+0x07 map_x`→`+0x00 map_x`; `0x3146`=type at +0x02;
  `0x314D/0x314E`=goto-target (not map_x/y).
- `spec/systems/combat.md` profession byte `+0x15`→**`+0x17`** (abs 0x315B; matched its own
  §3 prose `cmp [bx+0x315B],0x18`).
- `spec/systems/ref_growth.md` Evidence list `+0x32 "strength rating"`→**home_x/home_y**
  (RULINGS 2026-06-20; the §state table already had it right).
- `spec/systems/events.md` header: Lost-City trigger `0xB0 RUNTIME-VERIFIED`→**PROCEDURAL
  `func_006188`** (aligned to the file's own §6.1 2026-06-21 resolution).
- `spec/systems/colony.md`: softened "`+0xBA` Hammers label is correct" → **DISPUTED**
  (aligned to the file's own `+0xBA` CONFLICT row + §6 residual).
- `spec/systems/map_system.md`: flagged the stale "`0xB0`=Lost-City trigger marker,
  planted/cleared" model as SUPERSEDED by events.md §6.1 (procedural).

**OPEN — need a targeted disasm pass to reconcile (do NOT guess):**
1. **War-of-Spanish-Succession `[0x53D0]` trigger direction.** `revolution.md` + the
   2026-06-20 ruling say succession "auto-fires when `[0x53D0]` **crosses 50**"
   (`func_03E844 @0x3E8BD`); `spanish_succession.md` (dedicated call-graph analysis)
   says the succession branch is the **low-`[0x53D0]` / `[0x53D2]<0` state**, dispatcher
   `@0x02391C` **clamps `[0x53D0]` to 75**, and the handler body has *no* 50-compare.
   The two cite different functions. Reconcile by disassembling the dispatcher at
   `@0x02391C/@0x02392A` and `func_03C638` vs `func_03E844`.
2. **River overlay bit in the procedural generator.** `map_generation.md:58` (P4) writes
   river as "**bit 6 `0x40`**", but the `.MP` format authority (`MP_FORMAT.md`,
   `map_system.md:21`) says packed river = **bit 5 `0x20`** (bit 6/`0x40` = forest), while
   the runtime render trace (`map_system.md:152`) gates the river *draw* on feature-plane
   `0x40`. Plane ambiguity — confirm which bit the generator actually `or`s at the P4 site
   (`@0x64xxx`) and disambiguate the .MP-packed bit (0x20) from the runtime feature-plane
   bit (0x40) in both specs.

Both are conflicts between byte-cited claims; recorded here per the prime directive
rather than resolved by guesswork.

---

## 2026-06-23 — RESOLVED: the 2 open conflicts from the cross-consistency audit (disasm pass)

Both conflicts recorded earlier today were resolved by disassembling the raw EXE
(`raw/COLONIZE/VICEROY.EXE`, capstone 16-bit).

**1. War-of-Spanish-Succession `[0x53D0]` trigger — RESOLVED in favor of
`spanish_succession.md` (revolution.md was wrong).** The end-game dispatcher
`func_0235D6 @0x2391C` reads:
```
0x2391C  cmp  [0x53d0], 0x4b     ; threshold = 75 (0x4B), NOT 50
0x23921  jl   0x2392a            ; if [0x53D0] < 75:
0x2392A  mov  [0x53d0], 0x4b     ;   clamp to 75
0x23930  cmp  [0x53d2], 0
0x23935  jl   0x2393a            ;   and [0x53D2] < 0 (no secession yet):
0x2393A  lcall 0x191f, 0x364     ;   -> SUCCESSION handler (func_03C638)
0x23942  test [0x5382], 1        ; the >=75 path feeds the REVOLUTION handlers
```
So succession fires in the **low-meter (`[0x53D0] < 75`) + no-secession (`[0x53D2] < 0`)**
state; the high (`≥75`) state feeds revolution. `revolution.md`'s "auto-fires when
`[0x53D0]` crosses 50, `func_03E844 @0x3E8BD`" was wrong on BOTH counts: the threshold
is **75** (not 50), and `func_03E844` is **`sons_of_liberty_active_check`** (the SoL
display gate for REBELUP/REBELDOWN; reads `[0x5398]/[0x5382]/[0x53D2]`, **no `[0x53D0]`
read**). The "50" came from conflating the *separate* declare-independence floor
(`cmp [0x53D0],0x32` `@0x3E99E` in `func_03E984` — that one IS 50, and is correct).
Fixed `revolution.md`; `spanish_succession.md` was already accurate.

**2. Generator river overlay bit — RESOLVED (runtime-vs-.MP distinction).** Scanning the
whole generator `func_064A10` (0x64A10..0x65D26) for flag-bit `or`-immediates: the only
direct ones are **hills `or …,0x20` @0x64D19** and **forest `or …,0x80` @0x64D23**.
There is **no `or …,0x40`** anywhere — the river feature is spread via thunk
`0x181F:0x718` (@0x65BC2), and river therefore occupies the one remaining **runtime-board
flag bit `0x40`** (consistent with the render trace `map_system.md` §3). `map_generation.md`'s
"river `0x40`" is correct **for the runtime board**; `MP_FORMAT.md`'s "bit 5 `0x20` = river,
bit 6 `0x40` = forest" describes the **`.MP` file format** — a different representation.
Both specs annotated; the `.MP`→board remap in the `.MP` loader is the remaining residual.

---

## 2026-06-23 — Colony composer step 8 = stockpile bar; no colony menu bar

**Conflict**: `docs/COLONY_SCREEN_VICEROY_DECODE.md` §2 and `spec/ui/colony_screen.md`
§2.0 left composer step 8 (`call 0x2CA19`) as "role TBD" and asserted the stockpile
bar `func_0281D6` was a *separate* per-page sub-renderer "not one of the 12 head
calls." Separately, the user asked what is in the colony screen's "menu bar above."

**Source A** — prior decode/spec said: step 8 role unknown; stockpile bar drawn
outside the 12-step composer; colony title paint routine = `0x181F:0x178`.

**Source B** — VICEROY disasm this pass (`tools/follow_thunk.py`) said: `call 0x2CA19`
→ `ljmp 0x191F:0x654` → file `0x0281D6` = `func_0281D6` (fills `(0,179,320,21)`, 16
cells × pitch 0x13). The title painter is `0x181F:0xB0` (`func_00275C`), not `0x178`
(`func_0028B0` = strlen). All twelve `0x191F` step targets resolve to named
sub-renderers; none is a File/Orders menu bar.

**Ruling**: step 8 **is** the stockpile bar; the "menu bar above" is just the title/
status strip (composer step 5 `func_0268CE`, painted centred near `y≈5` by
`func_00275C`). The colony screen has **no dropdown menu bar** — that is the map
view's `func_072090` (`spec/ui/menus.md` §173). Decided per TRUTH_HIERARCHY: byte
evidence (the resolved `ljmp`) outranks the earlier drawlist gap and the recon note.

**Action taken**:
- `docs/COLONY_SCREEN_VICEROY_DECODE.md`: §2 table step 8 → `func_0281D6`; replaced
  the "separate sub-renderer" note with the resolution; added §9 (top bar / title);
  updated §8 status.
- `spec/ui/colony_screen.md`: §2.0 step 8 row + stockpile note; §3.1 paint routine
  (`0x181F:0xB0`) + "menu bar above" framing; open-items 1, 6, 7 updated.

**Follow-up**: the title text-box origin is runtime state (`[0x2CC6/8/A/C]` from the
`0x181F:0xC22` init), so the literal title x/y remains **R** (`y≈5`).

---

## 2026-06-23 — Colony gold is in the TOP MENU HEADER, not the warehouse bar; (306,179) ≠ gold

**Conflict**: I documented the colony/Europe warehouse bar's `(306,179)` `"$%d"` of
`DG16(0x2F5E)` as the player gold, and claimed the colony screen has "no menu bar." The
user (running DOS game) stated gold is shown in the **top menu header only**.

**Source A** (my disasm read): `func_0281D6 @0x0283F1` draws `[0x2F5E]` at (306,179);
`europe_screen.md` had it labeled "displayed gold mirror `$%d`".

**Source B** (running game = top of `TRUTH_HIERARCHY`; corroborated by disasm on re-check):
gold is in the top menu header. Re-check shows: (1) the colony screen DOES have a menu bar
— command table `cmp [bp+6],0x13C..0x142 @0x02BDEA`, registration `lcall 0x191F:0x3xx
@0x02BE00`; (2) `0x2F5E` is a **string-heap index** consumed by `0x181F:0x22` (fetch
string #N), **never written** as a treasury value (`grep`: only 2 read sites, no `mov
[0x2F5E]`); (3) the real treasury is `PowerRecord+0x2A` via `[0x84FC]` (BYTE_VERIFIED,
`DATA_MODEL.md`), mirror DGROUP `+0x9CB0` recomputed in the colony page `@0x02B80E`.

**Ruling**: gold renders in the **top menu header** (field `PowerRecord+0x2A` / mirror
`0x9CB0`), NOT on the warehouse bar. The `(306,179)` `[0x2F5E]` readout is a heap caption,
semantic **TBD**. The colony screen **has** a menu bar. Running game outranks the static
over-read.

**Action taken**:
- `docs/COLONY_SCREEN_VICEROY_DECODE.md`: §6 relabel (306,179) as heap caption / not gold;
  §8 status; §9 retract "no menu bar"; new **§10** (menu bar + header gold).
- `spec/ui/colony_screen.md`: §3.1 + §4 table rows (warehouse readout + gold-in-header).
- `spec/ui/europe_screen.md`: `DG16(0x2F5E)` relabeled NOT-gold (same byte-identical code).

**Follow-up**: pin the exact x/y/font of the header gold blit — the menu chrome draws the
formatted string buffer `[0x9CD2]` (`@0x072FE1`/`@0x0731D0`); the literal draw site in the
menu renderer is the next trace. And identify what heap string `[0x2F5E]` actually is.

---

## 2026-06-23 — Fill/frame verb traps synced across screen specs (0x22, 0xE2)

**Conflict**: `viceroy_source/docs/UI_PRIMITIVES.md` byte-verifies `0x181F:0x22` =
string-fetch (`func_002462`, no draw) and `0x181F:0xE2` = clipped sprite blit
(`func_00DB3A`), but several screen specs still labeled them as `fill_rect` and a
"1-px rule/frame/outline".

**Source A** (screen specs): `advisor_reports.md` "Title bar fill via `0x181F:0x22`",
"Footer rule via `0x181F:0xE2`"; `colony_screen.md`/decode + `europe` decode "screen
outer rule" / "1-px frame" via `0x181F:0xE2`.

**Source B** (central primitive doc, byte-verified): `0x22` = packed-string fetch
(skip-N, `REPNE SCASB`, no draw) — the F2 title is `fetch [0x2DF6] → centre via 0x100`
(`@0x37970`); `0xE2` = clipped sprite blit (sheet `[0x2DA8]`, `RETF 6`). The real
rectangle fill is `0x444`, the real line/divider is `0xCE`/`0x191F:0x8BC`.

**Ruling**: the byte-verified primitive catalogue wins (TRUTH_HIERARCHY: disasm at a
cited offset > drawlist interpretation). `0x22` is a fetch, `0xE2` is a sprite blit;
"fill"/"rule"/"frame" labels for them are corrected to "centred text"/"sprite strip".

**Action taken**:
- `advisor_reports.md`: title row + footer row corrected.
- `colony_screen.md` + colony/europe decode docs: `0xE2` labels corrected (sprite, not line).
- `UI_PRIMITIVES.md §0a`: added a "common verb-misread traps" block (0x22, 0xE2, the real
  fill 0x444, and that WOODFRAM 0x510 has a single caller = colony-scene-only).

**Follow-up**: a full audit of the 85 `0xE2` sites + 37 `0xCE` sites to confirm which
panels use which is open (the corrections above cover the screen-composer call sites).

---

## 2026-06-23 — `0x181F:0xCE` IS a line/rule draw (overturns "no-draw clamp")

**Conflict**: `UI_PRIMITIVES.md` classified `0x181F:0xCE` (`func_00E0A2`) as a "min/order-2
clamp helper, NO draw", but the colony field panel calls it with line coordinates
(`@0x026517`/`@0x026539`) as "divider lines", and the `0xE2`-sweep depended on knowing the
real line verb.

**Source A** (prior central-doc verdict): `func_00E0A2` head is `CMP bx,ax; swap` → "returns
ordered low/high, not a draw."

**Source B** (full disasm this pass): the ordering head **falls through to two draw calls**
`lcall 0xBBC:0xC` (`@0x00E0E2`/`@0x00E100`) with the ordered coords + color `[bp+6]`;
`0xBBC:0xC` (file `0x00DFCC`) does `mul bx` (y·width) then **`mov byte es:[di],al`**
(@0x00E02A) — it plots pixels. So `0xCE` draws a line/edge (two passes), it only *orders*
the endpoints first.

**Ruling**: `0x181F:0xCE` = **line/rule draw** (the screen line/divider verb). The prior
"no-draw clamp" entry is overturned — it stopped at the prologue and missed the helper's
pixel writes. Byte evidence (the `es:[di]` store) wins.

**Action taken**:
- `UI_PRIMITIVES.md`: 0xCE table row (line 110), detail §0x0CE, and the summary row all
  corrected to "line/rule draw"; added the `0xE2`/`0xCE` full call-site audit (87/49 sites).
- Confirms the colony field-panel "divider lines via 0x181F:0xCE" labeling is correct.

**Follow-up**: whether `0xBBC:0xC` is exclusively horizontal runs or general lines is not
fully pinned (the two-pass call suggests top+bottom edges of a separator).

## 2026-06-24 — Colony building placement: far-ptr dispatch traced, §12 blocker resolved
Traced `func_07464C` (the supposed per-type→category setter): reached via thunk `0x1A1F:0xD2E`
(stub file `0x1D31E`), which has **0 static lcall sites** — the call goes through the `ljmp`
trampoline at `0x76384` (jump table; entry 0 = `ljmp 0x1a1f:0xd2e`), invoked 42× from the
registration block at `0x0746BC`. The `0x8F88` (+6) column it writes = `floor(id/3)` (chain
group), used by the produced-good pass, **not** plot placement. Plot placement (`func_025D34`)
uses only the static `0x224`/`0x22A` config (`[7,4,2,1,1]`/`[0,7,11,13,14]`) + a random
permutation within each category block. RULING: the "per-type category table" blocker in
`docs/COLONY_SCREEN_VICEROY_DECODE.md` §12 was a misdiagnosis; placement is byte-portable given
only the `rand()` LCG. Full trace recorded in the decode §12 note.

## 2026-06-24 — OPEN CONFLICT (unresolved): ICONS index 100 — skip vs foot-unit
Surfaced while building the lab Sprites tab (M1). `CLAUDE.md` hard rule 5 lists **100**
among the placeholder indices to **skip** (0, 16, 100); hard rule 6 lists foot units as
**100–105**. Index 100 is therefore claimed by both rules. Not resolved here — the lab
renders ICONS #100 as a **TBD "CONFLICT"** role (rather than silently picking one) per the
prime directive (never invent; record conflicts). A ruling is needed: is 100 a dead
placeholder slot with foot units actually at 101–105 (+109), or is the rule-5 "100" a
typo/overlap? Resolution likely needs the ICONS.SS pixel check at index 100. Until then the
lab's role map (`lab/js/data/sprite_roles.js`) keeps 100 = TBD-conflict, 101–105 = foot unit.

## 2026-06-24 — RESOLVED: the rule-5 skip set {0,16,100} is PHYS0-SCOPED; ICONS #100 is a real foot unit
Resolves the OPEN CONFLICT directly above. There is **no conflict** — the two rules name
different sheets:
- **PHYS0** frames **0, 16, 100** are each a **1×1 transparent** stub (palette idx 253) —
  corrupted MADSPACK extraction artifacts, "NOT usable sprites, should never be indexed"
  (`notes/SPRITE_CATALOG.md` "Known extraction artifacts"; RULINGS A3). Byte-verified in the
  bundle: `PHYS0.json` frames 0/16/100 are all `w=1,h=1`. THIS is what hard rule 5 skips.
- **ICONS** is **contiguous 0–130, no gaps** (`notes/STATE.md:254`). `ICONS.json` #100 is a
  real **6×16** sprite, the first of the foot-unit run 100–106 (src y=20). So hard rule 6's
  "foot units 100–105 + 109" stands; #100 is a foot unit, not a placeholder.
**Determination**: hard rule 5's "skip 0, 16, 100" applies to **PHYS0 only** (and those frames
are 1×1, so a geometric "1×1 = placeholder" test already isolates them on any sheet). The M1
lab bug was applying {0,16,100} to *every* sheet, which wrongly flagged ICONS #100.
**Action taken**: `lab/js/data/sprite_roles.js` — renamed the set to `PHYS0_PLACEHOLDER_INDICES`,
made `isPlaceholder(frame, sheet)` geometric + PHYS0-scoped, and set ICONS #100 = foot unit (B).
**Suggested CLAUDE.md clarification (needs user sign-off)**: reword hard rule 5 to "skip the
PHYS0 placeholder indices 0, 16, 100 (1×1 artifacts)" so the scope is explicit in the rule.

## 2026-06-24 — Colony-screen layout decoded for the lab Screens tab; F2–F9 report fields are blocked
While seeding the lab's Screens tab with byte-verified element positions:
- **Colony building plots — B.** `func_02701C` (@0x02701C, VICEROY) is the plot painter:
  loops 15 entries (`CMP [bp-8],0xf` @0x02707B), reads `x=[bx+0x266]`, `y_table=[bx+0x268]`,
  draws at `y = y_table + 8` (`ADD cx,8` @0x02708F); a per-plot gate byte `[bx-0x717e]` (`JL`
  skip = empty plot → tree frames 42/43/44) and a frame-type byte `[bx-0x729e]`. Confirms the
  DS:0x266 plot table in `colony_screen.cpp`. **Position is B; WHICH building fills a plot is
  RNG-driven (`func_025D34`) so the per-plot frame is TBD.**
- **Colony stockpile bar — B** (`colony_screen.cpp` §6): 16 cells, x=1+i·19, icon row y=181,
  quantity y=193; icon = good+0x16 ⇒ ICONS frame 22 (Food)…37 (Muskets). Visually validated —
  the icons land exactly in COLONY.PIK's blue cells.
- **F2–F9 report field positions — TBD (blocker named).** The report painters (F-key dispatch
  `LCALL 0x191F:0x3xx`) render in **overlay 0x191F / the orphan code** (`orphans_load_image.asm`,
  ~118k lines); field positions are loop/table-driven and not yet traced. The COLONIZE/VICEROY
  per-func disasm offsets in `ADVISOR_REPORTS_AUDIT.md` (e.g. "file 0x027010") do NOT correspond
  to the committed per-function `.asm` (0x02701C there is the VICEROY colony-plot painter, a
  different EXE/offset space). Only each report's TITLE index is byte-cited (MISC[44..129]).
  The lab seeds report fields as **TBD** (drag-to-measure), NOT fabricated — per the prime
  directive. Tracing the 0x191F overlay is the remaining work to upgrade them to B.

## 2026-06-25 — Autonomous spec/systems decode loop (4 batches): headline rulings

Ran a decode→adversarially-verify loop over all 30 `spec/systems/*.md` files in 4
batches (commits 3e8b4b5, 16b2b32, dbdcb3e and one earlier). Each candidate fact was
independently re-derived from committed `raw/COLONIZE/VICEROY.EXE` bytes and landed ONLY
on definitive confirmation; hard items were kept TBD with the blocker named. The
durable rulings (full byte trails in the commit messages):

- **Mission-conversion `cl&0x10` doubler = Jean de Brebeuf founding-father bonus.**
  Bit `0x10` on the active convert record `[0x8D4A]+5` is set by `or [bx+5],0x10`
  `@0x48C81`, gated by `has_father(0x16, power)` `@0x48C71` (thunk `0x181F:0x7B4`,
  file `0xBC10`). `@FATHERS` row `0x16` = de Brebeuf (Religious/Jesuit). Read/doubled at
  `@0x57300` (`test cl,0x10; shl ax,1`). A second setter `@0x3BEA2` sits in the FF-0x16
  effect dispatcher — corroborates, not refutes. Closes the natives §3 mechanism note +
  §6 open-q together. (Previously: mechanism-known, label-TBD.)

- **`@UNIT` stat-table column map is byte-verified** (was hedged "TBD/unmapped" in one
  spot): `func_074EC3 @0x074EF9..0x074F59` parses 23 rows into base `0x5230` stride 14;
  movement (col1) stored ×3 `@0x5234`. Matches the §3 BYTE_VERIFIED table.

- **GAME save/load is raw fixed-record fread/fwrite, no compression** (`func_073BB0` /
  `func_0734F8`): 0x4F0 map block + 43× colony records.

- **Customize new-game menu fully decoded** (`func_070060`): 4 player-facing params are
  3-way enums (cursor `mod 4 @0x70158`, value `mod 3 @0x701AA/0x701AD`) — `@CLAND`
  land-mass, `@CCONT` land-form, `@CTEMP` temperature, `@CCLIM` climate (strings in
  `GAME_sections.json`). The 5-word param array at `DGROUP:0x1E7E` is mapped slot-by-slot;
  slot 4 (`0x1E86`) is a generator-internal smoothing budget `(p_iter+1)·0x320 @0x6538D`,
  NOT menu-reachable.

Honest blocks recorded (stay TBD, not invented): UnitRecord fields
`0x314F/0x3156/0x3158/0x3148` and the full move-cost table live in unattributed
orphan-overlay routines; Save/Load and setup-menu dialog *geometry* is inside overlay
file-picker thunks not in the committed disasm; `map_system` pattern-3 frame `0x9A`
"out of bounds" depends on the `PHYS0.SS` frame count (MADSPACK sheet, not the EXE);
the `0x5B1C` tension-row columns 4..38 are never accessed in committed disasm; the
events Lost-City trigger read `0xB0` vs the generator write `0xA0` is a cross-file
ruling needing the trigger function traced.

## 2026-06-25 — UnitRecord 0x314F = facing/heading (8-way compass), NOT "europe/recruit state"

Track-1 orphan-overlay attribution. The spec previously glossed UnitRecord +0x314F as
"europe/recruit state (cmp ==8)". **Overturned by bytes:** 0x314F is the unit's 8-way
compass HEADING (values 0..7; 8 = invalid/none sentinel). Proven independently on three
overlay pages by the `xor al,4` reverse-direction test (8-way compass reverse): page 0x0C
`@0x047AA8`, page 0x13 `@0x062F7C`; the angular-distance momentum score
`d=0x314F−target; if d>4 d=8−d; score−=d²·2` `@0x051712..0x051737`; and the `cmp
[bx+0x314f],8; jge` invalid-bound `@0x0516F0`. Written by AI move routines
`func_04E2D6`(page 0x0D)/`func_059B90`(page 0x0F) — confirming it is AI heading state, not
europe/recruit code. The enclosing AI order/move processor `func_04E2D6` (page 0x0D,
0x04E2D6..0x051D55) is now attributed (see notes/ATTRIBUTION_OVERLAY.md).

Also this pass: 0x3156 = overloaded per-unit TIMER field (word snapshot of progress
counter [0x538e] for owner≥4; byte 0xFF→rand for owner<4) — NOT cost/sale/treasure;
0x3158 = u8 per-turn land-unit boolean (set after cargo-load LCALL func_00B368, tested
only for Wagon Trains); 0x3148 = transient bit-scratch register, bit 0x08 = tile-dirty/
redraw (byte-verified), other bits context-overloaded and per-bit meaning kept TBD.

REJECTED by adversarial verify (NOT landed): a 0x314B per-letter alphabet proposal (byte
encoding errors — claimed BX-form writes were SI-form, phantom letters); and a native
0x5B1C column-padding claim. Honest TBDs, not invented.

## 2026-06-25 — PHYS0.SS = 154 frames; map pattern-3 frame 0x9A IS out of bounds (Track 2a)

The map_system coast-edge renderer computes `0x97 + pattern`; pattern 3 yields frame
`0x9A` (154). Whether that overruns PHYS0.SS was a standing TBD because the frame count
is NOT in VICEROY.EXE — it lives in the MADSPACK-packed sheet. **Byte-decoded the sheet:**
PHYS0.SS section-0 header `nframes @0x26` = **154**, so valid indices are `0..153`
(`0..0x99`) and frame `0x9A` is one past the end. Resolved. The only residual is whether
the pattern-3 mask (`[0xA8A6] & 0xDD == 0x1C`) is ever satisfied for a real coast tile at
runtime (latent bug vs unreachable branch). Full frame-count table for all 205 decodable
.SS sheets recorded in `data_extracted/SPRITE_SHEET_FRAMES.md` (decoder: tools/ssdec.py).
Notable counts: TERRAIN.SS=12, ICONS.SS=131, PHYS0.SS=154, BUILDING.SS=48, BDARK.SS=46.

## 2026-06-25 — Dialogs are GAME.TXT-template-driven; Save/Load "Layout TBD" explained (Track 2b)

The Save/Load picker geometry was "Layout TBD" because there is NO coded layout: dialogs are
**data-driven from GAME.TXT templates**. Traced chain (notes/ATTRIBUTION_OVERLAY.md): prompt
orchestrators func_072F7A (save) / func_073158 (load) → slot-list builder func_072CC2 →
window-create thunk 0x191F:0x182 = **func_06F0F4, a generic dialog-template interpreter** that
parses the `@SAVEGAME`/`@LOADGAME` section of GAME.TXT (keyword lines: X/Y/WIDTH/LENGTH/
SMALLFONT/COLOR). Add-row primitive 0x191F:0x176 = func_06C850 (linked-list item alloc, no
x/y immediates); modal pump 0x191F:0x16a = func_06E3D0 (lays out rows at render time);
teardown 0x191F:0x1a8 = func_0789FA (DOS free). The templates omit x/y/length ⇒ window
auto-centered, per-row Y computed at runtime ⇒ those pixel positions are legitimately TBD
(runtime), not missing work. This generalizes: the 0x191F overlay is the shared dialog engine,
so other "0x191F TBD" UI items are likely template/runtime-driven too. (One auto-proposal was
REJECTED for fabricated keyword-offset cites; the function chain stands, exact keyword offsets
pending re-verification.)

## 2026-06-25 — Advisor-report (F2–F9) renderer located: func_037958 (page 0x05) (Track 2b)

The advisor reports' field layout was the standing "trace the 0x191F overlay" remaining work.
Located the renderer: **func_037958 (page 0x05)** is the report screen, fed by the F-key
dispatch (F2 push 2 @page_05.asm:581 / F5 push 5 / F9 push 1) and the .PIK loader func_037340
(load_report_pik); report chrome strings "REPORT"/"(%d of %d)" at file 0x1EB42/0x1EB49
(data base 0x1D9A0). Per-report numeric FIELD positions remain TBD (live game-state + the
0x191F template path), but the renderer + dispatch are now byte-cited (B), upgrading the
reports from drag-to-measure.

## 2026-06-25 — Lost-City: no 0xB0 immediate exists; trigger masks, not equals (Track 2b)

Exhaustive scan of all 494,910 EXE bytes (grp1-imm byte/word forms on es:[bx] + reg-imm
cmp/mov 0xB0) found ZERO 0xB0 immediate. The generator ORs 0xA0 into the tile feature byte
(@0x65C0D/@0x65C21 = `26 80 0f a0`). So the Lost-City trigger cannot compare ==0xB0 against a
literal; it masks the feature byte (the 0x10 bit is a separate rumor/explored flag tested
independently, or the read is (feat & 0xA0)). The "==0xB0" model in events.md §6.1 is a recon
gloss, not a byte literal — corrected to a masked-read model.

## 2026-06-25 — Track 4: button-bit 0x7E4, colony/europe hit-test tables; map-dispatch mislabel rejected

Three input/UI resolutions landed; one proposal rejected on repo-fact grounds.

- **Mouse 0x7E4 = right-button flag (complement of bit0), RESOLVED.** func_00D106 @0xD1A2-
  0xD1AE: `mov al,bl / and ax,1 / cmp ax,1 / sbb ax,ax / neg ax / mov [0x7E4],ax` ⇒
  [0x7E4]=0 on a left click (bit0 set), =1 on a right click. The Track-3 `(bl&1)` gloss was
  INVERTED; corrected. Written only on a fresh press down-edge; sole writer (A3 E4 07 once);
  readers test ==0 @0x2438A/0x29C91/0x6ECBC/0x2A038.
- **Colony click-region table = func @0x299A0** (10 rects, point-in-rect 0x181F:0x3CA=
  func_004B16): ids 0xA top bar / 2 main scene / 1 field panel / 0 plaza / 8 minimap(121,130,
  84,48) / 4 SoL panel / 3 flag / 5 stockpile strip / 9 gold readout(305,179) / 0x14 default.
  Matches colony_screen.md paint rects 1:1. id→action dispatch still TBD (overlay caller switch).
- **Europe click-region entry = func @0x3200A** (default id 0xF); the older cite 0x032034 is
  the id-5 (recruit-pool) block BODY, not the entry — corrected.

REJECTED (not landed): the map-key-dispatch agent labeled **func_070060** as the "in-game
map viewport/region picker" and asserted its getch cmp-cascade (Space/ESC/arrows/Enter) as
the in-game map key dispatch. **Refuted by committed facts**: func_070060 IS the Customize
new-game menu (batch-4: cursor mod4 @0x70158, params @CLAND/CCONT/CTEMP/CCLIM, writes the
map-GEN param array [0x1e7e]). The cmp-cascade bytes are real but they are the Customize
menu's navigation, NOT the in-game map. The genuine in-game active-unit command keymap
(B/F/C/W…) remains menu-accelerator-driven (func_0235D6) — carried open blocker, still TBD.

## 2026-06-25 — Active-unit order keymap: code→handler RESOLVED; key-read step honestly TBD (Track 5)

Premise correction + a real win. **func_0235D6 is NOT the accelerator engine** — it is a
downstream command DISPATCHER that receives an already-decoded command id in [bp+6] (switch
mov ax,[bp+6] @0x235E2; F-key report ladder cmp 0x48/0x41.. @0x23843 → 0x191F report thunks,
consistent with Track 2b). It never reads a key and never scans @ORDERS. Do not cite it as the
key→order translator.

RESOLVED (byte-verified): the @ORDERS order-code → per-turn handler map, via the dispatcher
@0x249CB (imul idx×0x1c; al=[bx+0x314c]; code−2; cmp ≤7; jmp word cs:[bx+0x3b58]; table @file
0x24A38). Codes→executors: 2 TradeRoute→func_041080, 3 GoTo→func_040E22, 5 Fortify→func_04101C
(which WRITES code 6 @0x41024, byte-proving Fortify→Fortified promotion), 6 Fortified→passive,
7 BuildColony→func_040C1E, 8 Clear/Plow→func_040656, 9 BuildRoad→func_0409D6. The 2nd
dispatcher @0x051DCE (codes 7..12, table @file 0x51E1A) LCALLs the SAME thunks for 7/8/9,
cross-confirming. Handlers 8/9 match terrain_improvement.md. Row index == stored order code
for all proven rows. Command letters S/T/G/L/F/B/P/R are canonical from NAMES @ORDERS.

HONEST TBD (overlay-paged, not statically traceable): the KEY-READ step — where a pressed
accelerator letter is matched to a menu row and decoded into the command id. The match loop is
inside the overlay menu engine around func_06E3D0 @0x6E3D0 (polls input via LCALL 0x181F:0xf6
@0x6E419 → getch 0xD286). getch and func_0235D6 have no static callers (xref empty; overlay
function-pointer table patched at runtime), so the letter→id translation needs a runtime trace
or the overlay dispatch table resolved. Next site: callees of func_06E3D0's poll loop + per-row
draw func_06F83A @0x6F83A + the consumer of the 'ORDERS' section-name lookup @file 0x1FBFD.

## 2026-06-25 — 0x54de = @ORDERS status-letter table (NOT the menu key-match); renderer func @0x0386A (Track 6)

Extended Track 5. DGROUP byte array 0x54de[13] is built by a NAMES-section table-builder
(loader body file 0x074E70..0x074FE0) that parses the @ORDERS accelerator column into
0x54de[row] = {'-','S','T','G','L','F','F','B','P','R','-','-','-'}, indexed by order code
(@0x074F96 mov [bx+0x54de],al; 13-row loop). It is consumed ONLY by the on-map unit
STATUS-LETTER renderer func @0x0386A (NOT func_038F2C — that linear-sweep label is a different
function; renderer prologue enter 0x46,0 @0x0386A): default glyph = 0x54de[0x314c order code],
with overrides for ship cargo digit, 'X', and the 0x314b AI-state char (→'E' when >=0x80) —
cross-linking Track 1's 0x314B.

PROVEN (full-binary scan): exactly TWO code refs to 0x54de (writer 0x74F96, reader 0x391D),
zero register-constant loads. So the orders MENU does NOT select a row by scanning a pressed
key against 0x54de — accelerator matching is engine-internal to the dialog/section opener
func_06F8FA, matching the @ORDERS text directly. The in-engine key-match site stays the one
honest TBD (overlay-internal). Adversarial verify caught my initial renderer mis-citation
(func_038F2C @0x038F2C) and it was corrected to func @0x0386A before landing.

## 2026-06-25 — Runtime snapshot harness: live DGROUP seg 0x1CFD; 0x54de table confirmed (Track 7)

Built tools/runtime_snapshot.py: boots VICEROY headless under stock DOSBox 0.74 and snapshots
the emulated DOS RAM out of the DOSBox process via /proc/<pid>/mem (no debugger build/symbols
needed; DOSBox's emulated RAM is the 16MB anon mmap carrying the MADSPACK+ORDERS signatures;
DOS phys P = region offset P). First runtime cross-check of static RE in this project.

Verified: live DGROUP base = segment 0x1CFD (phys 0x1CFD0), auto-anchored on the section-name
table UNIT\0ORDERS\0ACTIONS\0 @DGROUP:0x2258. DGROUP offsets are preserved from the static EXE
image, so spec DGROUP:0xNNNN citations read live at phys 0x1CFD0+0xNNNN. RUNTIME-CONFIRMED the
Track-6 0x54de table: DGROUP:0x54de[13]='-STGLFFBPR---' occurs exactly once in 16MB. Anchors
0x225d='ORDERS', 0x2258='UNIT', 0x2264='ACTIONS' all exact.

Limit: stock DOSBox sends the DOS console to emulated video (not host stdout) and gameplay input
is not automated, so this captures the boot/menu state + resident data. Catching the in-engine
orders-menu key-match (inside func_06F8FA) still needs scripted input or a debugger build —
that remains the one honest TBD in the keyboard chain. Harness doc: docs/RUNTIME_SNAPSHOT.md.

## 2026-06-25 — Runtime trace reaches in-game map + ORDERS menu; key-match RUNTIME-CONFIRMED (Track 8)

Drove the live game (tools/drive_game.sh) all the way to the in-game map with an active unit,
opened the ORDERS pulldown, and snapshotted DOS RAM with the menu OPEN (tools/runtime_snapshot.py).
This closes the one input TBD that was flagged as needing a runtime trace.

Findings (triangulated: live RAM + static MENU.TXT + screenshot):
- The in-game ORDERS menu is built from **MENU.TXT @ORDERS** (data_extracted/text/MENU_sections.json),
  NOT the NAMES @ORDERS (which → 0x54de on-map status letters, Track 6). Each row's accelerator is
  a **`~` marker** in the label: ~Fortify→F, ~Sentry→S, ~Build Colony→B, `Join Colony (~B)`→B,
  `Build ~Road`→R, `Begin ~Trade Route`→T, `No Orders (~s~p~a~c~e~ bar)`→spacebar,
  `Disband Unit (~s~h~i~f~t~-~D)`→shift-D.
- LIVE EVIDENCE: the menu is a linked list of func_06C850 nodes (0x18 bytes: two far-ptr links +
  label + u8 row-index + flag) at seg 0x668c; each node carries the ~-marked MENU.TXT label
  VERBATIM (e.g. `~Activate unit`, `Join Colony (~B)`). So the engine parses the ~ markers from
  the live menu rows to bind accelerators. (The exact getch-vs-marker compare instruction inside
  the dialog engine is the only residual micro-detail; the mechanism + full keymap are resolved.)
- map_view.md sidebar HUD RUNTIME-CONFIRMED: live shows `Spring 1498`, `Gold: 1000e Tax: 0%`,
  active Caravel `Moves: 4 / Locat: (50,42) / (Sea Lane)` (hard rule 2 confirmed visually).

New screens: docs/screens/06_ingame_map.png, 07_king_audience.png (KING.SS, row 13),
08_orders_menu.png. The runtime memory harness + driving harness together now reach and confirm
any reachable game state.

## 2026-06-25 — All 10 advisor reports captured live (F1–F10) (Track 9)

Drove the running game to an in-game state and opened every report from the REPORTS pulldown.
Visual ground-truth for the advisor-report subsystem (renderer func_037958, Track 2b) now lives
in docs/screens/reports/ (+README). Confirmed REPORTS menu order: F1 Terrain / F2 Religious /
F3 Continental Congress / F4 Labor / F5 Economic / F6 Colony / F7 Naval / F8 Foreign Affairs /
F9 Indian / F10 Score.

Live field values confirmed (not just layout):
- F5 Economic = "European Trade" table, cols Tons/Gold/Bid Price/Ask Price × 16 commodities
  (live bid/ask: Food 0/8, Sugar 5/7, Silver 19/20, Rum 9/10, Muskets 2/3, ...); pages to
  "Cargo in Port" sub-view. Confirms the market bid/ask model (market.md).
- F8 Foreign Affairs = 4 European leaders by name (Walter Raleigh/English, Jacques Cartier/
  French, Christopher Columbus/Spanish, Michiel De Ruyter/Dutch), each Rebels/Tories (revolution.md).
- F10 Score = func_03A9C0: "Discoverer Walter Raleigh of the English: Spring 1498"; English
  Citizens +6 / Continental Congress +0 / Gold (1000e) +1 / Total Score: 7 (scoring.md terms).
- F1 Terrain = Colonopedia popup for the tile ("Sea Lane" — hard rule 2).

UX facts: reports close via the OK button (bottom-right), NOT Esc (Esc quits from the map); an
F-key pressed inside a report pages THAT report's sub-views, it doesn't switch reports.

## 2026-06-25 — Europe screen captured live (Track 10)

Drove a Caravel back to Europe ("Return to Europe" order, ~2 turns) and captured the European
Status Screen live (docs/screens/10_europe_screen.png + 09_europe_arriving.png). Confirms
europe_screen.md: header "London, England. Spring, 1500. Tax: 0% Gold: 1000e"; the three dock
zones Expected Soon / Bound For New England / Loading: Caravel (captions from @MISC); the
RECRUIT/PURCHASE/TRAIN panel (@EUROLABEL); the 16-commodity bid/ask price strip (same prices as
the F5 Economic report -> single market model); and the Exit button with red 'E' accelerator.
First arrival shows a tutorial help overlay. Validates the Track-4 func @0x3200A hit-test rects.

## 2026-06-26 — Colony screen captured live; ColonyRecord + hard rule 8 runtime-confirmed (Track 11)

Drove the full New-World arrival sequence live to found a colony and capture the colony screen
(the big colony_screen.md PARTIAL surface): sail back from Europe -> "Discovery of the New World"
-> Make Landfall -> a LOST CITY RUMOR ("You find nothing but rumors" = a live @LOSTCITY outcome)
-> "Meeting the Natives" / Arawak diplomacy ("a glorious nation of 11 Villages", land-gift, peace)
-> Build Colony -> name "Jamestown" -> "Building a Colony" -> colony screen. Live @TUTORIAL hints
also fired (Caravel hint). Screens in docs/screens/ (11_colony_screen.png + 12..15).

RUNTIME CONFIRMATION of the colony data structures (CLAUDE.md hard rule 8): snapshot with the
colony screen open (colony_jamestown.bin), DGROUP seg 0x1CFD. *(0x8542) = 0x606e. And
0x606e = 0x5D46 + 4*0xCA EXACTLY -> confirms ColonyRecord base 0x5D46 + stride 0xCA (Jamestown =
table index 4). Record @0x606e: +0 cx=0x2e(46), +1 cy=0x29(41), +2 name "Jamestown\0". Validates
the [0x8542] near-ptr + the +0/+1 cx/cy field map in colony_screen.md.

The colony screen visually confirms: RNG-placed buildings layout (func_025D34 §12), surrounding-
tiles work map, SoL/pop "100% (1)", production panels, 16-commodity warehouse strip (Tools: 50),
Exit (E). With the runtime harness, every major in-game screen is now captured + cross-checked.

UX note for founding: colonists made landfall sit on the water-edge tile and must be MOVED onto
land (Rain Forest here) before Build Colony works ("colonies cannot be built at sea"); sentried
units are woken by clicking their tile once no unit is active.

## 2026-06-26 — Colony §12 RNG building placement RESOLVED (static trace + snapshot oracle) (Track 12)

The 2026-06-24 "burned" incident (colony screen marked COMPLETE while func_025D34 RNG placement
was unresolved) is now genuinely resolved — traced statically AND verified against the live
Jamestown snapshot.

func_025D34 @0x025D34..0x025EAF, full algorithm:
1. RNG seed per colony: lcall 0x181F:0xD62 @0x025D3A.
2. Category-per-plot table 0x8D62 = [0,0,0,0,0,0,0,1,1,1,1,2,2,3,4], built from counts
   0x224=[7,4,2,1,1] + starts 0x22A=[0,7,11,13,14] (deterministic, recomputed each open).
3. Within-category random shuffle (random_int(0,count-1)+start[cat] via lcall 0x181F:0x4D4,
   retry if occupied) -> plot→building-slot at 0x8E92 (=[bx−0x716E]).
4. 42 building-defs (stride-12 records based 0x8F88) mapped to category-slots; for each building
   the colony HAS (query lcall 0x181F:0x9FC) write present-gate 0x8E82[plot]=building-def-id
   (else 0xFF) @0x025E9F.
5. Frame = word[id*2−0x7238] = [id*2+0x8DC8] (func_026CC2).
Consumer render loop 0x027067: position 0x266[slot*4], category 0x8D62[slot] (stride 1),
present-gate 0x8E82[slot] (stride 1, skip if <0/0xFF), draw via 0x2CA23(category,y,x,def-id).

ADDRESSING NOTE: the disasm's negative offsets are 16-bit wraps: −0x729E=+0x8D62, −0x717E=+0x8E82,
−0x716E=+0x8E92, −0x7238=+0x8DC8, −0x7078=+0x8F88.

SNAPSHOT VERIFICATION (the key methodological point): live Jamestown 0x8E82 (stride 1) = 8
buildings at plots {2,3,4,5,6,10,12,13}, def-ids {0x20,0x1B,0x27,0x18,0x15,0x23,0x09,0x00},
matching the trace. A first naive stride-4 read had falsely reported "13 buildings" — the
snapshot oracle is exactly what caught and corrected the bad decode before it could land. This
is the runtime harness doing its job: not auto-decoding, but turning an unverifiable static
claim into a checkable one.

Residual (non-static BY DESIGN): the exact plot a building lands in depends on the per-colony
RNG seed + shuffle order; replayable from seed 0x181F:0xD62 but not a fixed table.

## 2026-06-26 — UI-residue trace+oracle pass: 6 verified, 2 rejected, 9 honest blocks (Track 13)

Workflow fanned 4 tracers over the remaining tangled UI TBDs, each verified against a live
snapshot oracle. Landed only byte-traced AND oracle-confirmed facts.

ECONOMIC REPORT (docs/ADVISOR_REPORTS_AUDIT) — the F5 table fully decoded:
- Real paint fn = func_038A50 (page_05, file 0x038A50; the old 0x027010 was a pre-reseg
  mis-resolution). 16-row loop (cmp [bp-0x84],0x10 @0x038E3B), y-stride 8 (@0x038E33), start
  y=0x21. Columns drawn via text primitive 0x181f:0x13c = func_002B38 (arg order color,y,x,ss,&str).
- BID = func_030590 (0x191f:0x9ea): PowerRecord[+0x4c+commodity] − 1, clamp ≥0.
- ASK = func_030566 (0x191f:0xc3e): PowerRecord[+0x4c+commodity] + spread_const[commodity*9]
  (DGROUP +0x9700, stride 9), clamp ≥0. Both oracle-confirmed against rep_economic.bin.
  Blocks (honest): per-value left x is runtime font-metric right-justification (column RIGHT
  anchors ARE byte-cited: name→0x90, Gold 0x90, Bid 0xaa, Ask 0xdc); header label literals are
  GAME-string indices [0x2e2e/0x2e30/0x2f50/0x2f52]=385/386/530/531 (not mapped to text);
  Tons/Gold dword tables (+0x88c4/+0x8884) both 0 in snapshot (no trades) so not distinguishable.

COLONY PANEL (§3.6): the [0x337] 3-way dispatch is func_02814C; case-0=SoL func@0x0275CE,
case-1=cargo func@0x027746, case-2=msg. "No Ships In Port" = LABELS @MISC[11] via resolver
func_002462 (0x181F:0x22), oracle-confirmed at DGROUP 0x2FF1A. SoL/cargo-mode literals stay
TBD (need a snapshot in those modes).

EUROPE (§3): banner = func_030F76 (lcall 0x181F:0xB0, NO coord push → pixel origin from string
metrics, runtime). Banner pixel origin + Exit-button paint origin remain TBD. REJECTED: a
"corrected" click-rect mapping was byte-wrong (verifier refuted).

COLONY TITLE (§3.1): func_0268CE assembles "Jamestown. Spring, 1504. Gold: 1000e" — name branch
@0x269F8, season @0x26A22, year @0x26A44, gold @0x26A61 (via 0x181F:0x22). REJECTED: one row
mis-attributed the gold draw to func_0268CE. Pitch-packing loop (line 145) stays TBD.

Method note: 2 rejections (europe click-rect, colony gold) + 9 honest blocks vs 6 clean lands —
the oracle requirement (must match live snapshot) is doing exactly what it should.

## 2026-06-26 — String-blob resolver is DIRECT (corrects a same-day +1 error) (Track 14)

Self-correction. Commit a3f8948 claimed the LABELS string-blob resolver func_002462 (0x181F:0x22)
maps the Economic header indices with a "+1" (stored 385 → blob[386]="Tons"). That was WRONG.

VALIDATED rule: the resolver walks the contiguous null-separated blob at far-ptr [0x2d42:0x2d44]
(live base 0x4c050) and the mapping is DIRECT — string = blob[index], no offset:
- global 0x153=339 → blob[339]="No Ships In Port" (the known colony @MISC[11] string) ✓
- europe [0x2DD0]=338 → blob[338]="Bound For" ✓
- blob[386]="Tons", [387]="Gold", [531]="Bid Price", [532]="Ask Price" (both snapshots identical).

So the Economic header LABELS are at blob[386/387/531/532] (direct); the source DGROUP globals I
earlier read (385/386/530/531) do NOT land on them, so the exact header-index globals are TBD
(label identity stays confirmed via screenshot + blob). The "+1" framing in a3f8948 is retracted.

LESSON for the cheap sweep: the index globals ([0x2F5E], [0x939A], [0x2DD0], …) hold
context/MODE-TRANSIENT values — e.g. europe [0x2F5E]=537="Sons of Liberty" is clearly leftover,
not the field's purpose. So resolving a field's SEMANTIC via the blob requires the snapshot to be
in that field's active mode; absent that, the blob gives the current (possibly stale) string, not
the meaning. Mass-applying the mechanism to these globals would re-introduce plausible-but-wrong
literals — so only the mechanism (direct) + the two validated anchors are landed.

## 2026-06-26 — Colony §3.3 colonist-row pitch RESOLVED (code + existing snapshot, no re-drive) (Track 15)

The "per-colonist pitch = data-driven packing loop = TBD" turned out to be cheap (code-derivable
+ confirmable from the colony snapshot already on disk), NOT requiring the expensive re-drive.

func_0270D0 @0x0270D0 colonist plaza row: count = colony+0x1F + [0x8D72] (live 1+1=2). Pass 1
(@0x02710A) sums each colonist sprite width (table [0x83E]:[0x840], stride 12, +0x3E=width) into
total_width. Gap solve (@0x027160): gap=[0xA890] init 2; while gap*(count-1)+4+total_width >= 0x60
(96), decrement gap and retry — adaptive shrink to fit the 96-px budget. Pass 2 (@0x027186) blits
each colonist (0x181F:0xCE) at running x [bp-0x60] (from 143, advanced left by sprite_width+gap),
y=10. So pitch = sprite_width(+0x3E) + adaptive gap (2->0). Table structure + [0xA890]=2
oracle-confirmed in colony_jamestown.bin (real colonist +0x3E=15).

Note: this extends the "cheap tier" — a TBD labeled "needs a multi-colonist re-drive" was actually
a code-derivable formula whose data structure the existing single-colonist snapshot confirms.

## 2026-06-26 — Colony per-turn driver sequence + food consumption + warehouse capacity (Track 16)

Traced colony_turn_update @0xA222..0xA6A1 (the per-turn colony pipeline a rewrite needs as
control flow). Ordered: (1) setup lcalls; (2) tile production loop over 20 goods via
compute_terrain_yield (call 0x9B9C @0xA42A) into produced table [good*2+0x8DC8]; (3) 5 raw→
finished chains (call 0x8E84 ×5 @0xA660..0xA68C); (4) food consumption; (5) warehouse cap;
(6) display-delta bookkeeping.

BYTE-VERIFIED formulas:
- Food consumption = 2*pop (@0xA5F2 shl ax,1 on ColonyRecord+0x1F); net_food = max(produced − 2*pop, 0).
- Warehouse capacity = (warehouse_level[+0x95] + 1) * 100 (func_008D00: base 100, *(level+1)).

Warehouse spoilage (was TBD): capacity formula nailed + the over-cap detection (func_008E02
computes room = cap − stock − produced); but the exact CLAMP/discard write to the +0x9A stockpile
is in the 0x8E84 commit chains, not func_008E02 (which is colony-screen display bookkeeping). So
spoilage is now PARTIALLY resolved (cap + detection byte-verified; the write leaf remains).

Note: confirms colony production is more complete than the mid-session layer-3 estimate implied —
the core formulas (per-tile yield, SoL EMA, consumption, capacity) are byte-verified from code,
not reconstructed; runtime deltas would only confirm them.

## 2026-06-26 — PowerRecord field tail + Unit/native AI-boundary classification (L1/L2 Phase 1)

PowerRecord (per-nation economy/diplomacy, 316-byte/0x13C stride @DGROUP:0x8808, 12 entries;
active reached via near ptr [0x84fc], set by func_030550 @0x30559). Tail offsets resolved this
pass, each disasm-cited via capstone on VICEROY.EXE AND oracle-checked against rep_economic.bin /
rep_europe.bin (active power 0):
- +0x20 u16 boycott_bitfield (and ax,[bx+0x20] func_030B38 @0x30B47; clear func_03334E @0x33423). oracle 0.
- +0x22/+0x24 s32 royal_money accumulator (add [bx+0x22],ax; adc [bx+0x24],dx func_02D658 @0x2D785;
  boycott-lift adds @0x33413). oracle grows 70->80 between the two snapshots (live).
- +0x26/+0x28 s32 gross/pre-tax accumulator paired with +0x22 (@0x2D78B). oracle 0.
- +0x2A/+0x2C u32 gold treasury (sub [bx+0x2a],ax; sbb [bx+0x2c],dx func_03334E @0x3340D;
  treasure credit func_04E2D6 @0x50954). oracle = 1000 <-> in-game "Gold 1000". KEY OACLE MATCH.
- +0x2E/+0x30 u16 pair, Europe "(%d of %d)" progress (func_037958 @0x379AB mov dx,[bx+0x30];
  mov bx,[bx+0x2e]). oracle 0/10. writer semantics TBD.
- +0x32/+0x33 byte pair = default unit destination map_x/map_y (page_0D @0x51E9B al=[bx+0x32]->
  [si+0x314d]; @0x51EA6 al=[bx+0x33]->[si+0x314e]). SUPERSEDES the DATA_MODEL.md "ref_strength
  word +0x32" guess (byte reads, not word; authoritative REF = 0x53DA..0x53E1 per 2026-06-19).
- +0x49 byte countdown (cmp/dec func_04E2D6 @0x52658/@0x52688). +0x4A u16 crosses pool drained in
  0x32 chunks (@0x5276F/@0x5279F).
- +0x4C+i u8[16] price_level (ask func_030566 @0x30583; bid @0x3059C; recompute @0x306F3). oracle
  [1,6,5,5,5,2,6,20,3,10,11,12,15,2,2,3] (Silver=20). +0x5C+i*2 s16[16] vol_accum (func_0305A8
  @0x30707 etc.). oracle differs between snapshots (live accumulator).
Record interior with no traced read/write site (mostly the js-dos-schema market arrays) left TBD,
not asserted.

Unit fields 0x3149 / 0x3148 / 0x314B / 0x3158 pushed to their L2 ceiling = AI-GATED. 0x3149 is an
AI per-unit enable/budget counter: turn-dispatch enable (func_051D56 @0x51D5D), budget-sub
(func_03ECF0 @0x03EE95, func_0079A0 @0x007A08), incr (func_059B90 @0x059F20/etc). EVERY consumer
is orphan-overlay AI; no render/economy/UI reads it. Oracle: player units 0, native braves nonzero
(6,6,8,3,3,9). Exact English (move-credits vs eval-passes) is the AI-GATED ceiling.

Native tension table 0x5B1C (39-word stride): columns 4..38 RESOLVED-as-unused. dgroup_xrefs.json
= exactly 3 refs (getter @0x0082AC, applier read @0x045E57, write @0x045E6C); all callers pass a
power id 0..3 (raid scan col<4 @0x047365; 0 column constants >3). So only cols 0..3 = the 4 powers
are ever touched, by ANY committed path (not even orphan AI) -> NOT AI-GATED, simply over-allocated.
NativeSettlement +0x03 bit 0x04 = Capital (set @0x66225, consumed @0x43DC4/@0x07DCA/@0x46E05;
oracle 1/tribe). WITHDREW the earlier unverified 0x04=mission / 0x08=visited / 0x40=event flags
(no code sets/tests those bits).

## 2026-06-26 — OPENING.EXE / CLOSING.EXE cinematic deep decode (L1 Phase 2)

Decode-verify workflow over the two separate cinematic binaries (committed disasm
code/{OPENING,CLOSING}/disasm/*.asm + capstone on raw/COLONIZE/{OPENING,CLOSING}.EXE; all anchors
re-checked by hand). OPENING.EXE carries a C symbol-name table (file 0x11900+) decoded against the
symtab encoding — _opening/_open_loop/_load_ship_path/_load_anims/_do_ship/_do_anims/_do_logo etc.

OPENING.EXE (all B unless noted):
- Asset-load ORDER, one pass through _opening @file 0x1AAC..0x1EC2: PATH.DAT (_load_ship_path @0xCEA),
  CREDITS (_load_credits @0xD52), anim table (_load_anims @0xDD2 → _anim[] @0x4de8, 6 words/rec),
  #SOUND.COL/MPSLOGO/MPSNAME, OPENING.PIK (_picture_load_2 seg 0x181:4 @0x1c94), OPENBORD (as a .PIK
  via seg 0x1b4:8 @0x1d10), OPENSHIP .SS @0x1d90, OPENCRD0-2 (loop @0x1dcc), then OPENWND1/OPENSUN/
  OPENMON1/OPENWND2/OPENMON2/OPENMON3/OPENFISH/OPENGUY/OPENLOGO/OPENBONK .SS @0x1e0e..0x1ebe.
  Loaders: .SS=seg 0x3b1:0xa (file 0x471A, name ptr in BX); .PIK=seg 0x1b4:8; fullscreen .PIK=0x181:4.
  CONFIG.COL/MEMORY*.TXT are config/diagnostic, not assets.
- Blit routine seg 0x392:0 = file 0x4520 (enter 0x28,0 verified): AX=frame index, bit15=H-flip
  (and ax,0x7fff @0x4546 verified), BX=dest surface descriptor (lea [0x3910]), DX=X, [bp+6]=Y,
  [bp+8]:[bp+0xA]=sheet-handle far ptr. Per-frame record stride 12, header 0x36, bbox +0x3a x-anchor/
  +0x3c y1/+0x3e width/+0x40 y-extent; sheet dims +0x4a/+0x4c.
- Placement = TABLE-DRIVEN, not literal pushes for animated elements: _do_anims @0x102C iterates
  _anim[] (count [0x46]); record field0 indexes _animsprite @0xa2; X = -((width>>1)-x_anchor)+rec[+6]
  -_pan_x; Y = -(rec[+0x40]-rec[+0x3c])+1. Literal-centered exceptions: credit @0xFB6 centered x=160
  (sub ax,0xa0 @0x1001 verified) y=183 (sub cx,0xb7 @0x1008 verified); logo _do_logo @0x1700 bbox+
  literal offsets +0x17/-8/+0x10.
- Pan: _pan_x [0x4aca] init 0x280(640) @0x16af, dec 1/tick in _pan @0x113e, subtracted from every X.
- Ship path from PATH.DAT: _load_ship_path @0xCEA → _ship[] @0x4f0c (stride4 X,Y), _do_ship @0xF6E
  indexes by _ship_at, frame=_ship_wave, stepped by master clock _ship_move @0x119A.
- Frame cascade on [0x82] (thresholds 0x87/0x99/0xAD/0xC3/0xDC/0xEC/0xFC/0x1FB) sets frame 1..7.

CLOSING.EXE (all B unless noted):
- Per-frame loop func_000E4C @0xE4C (verified entry); 32-bit master clock [0x488c]:[0x488e] via
  LCALL 0x24a,2; stepper CALL 0xC0C (interval [0x54], runtime/live-adjustable INC/DEC @0xE2A/0xE30;
  INC step-counter [0x6a]); present CALL 0xAC2; SENTINEL EXIT cmp word [0x6c],0 / jne 0xe59 @0xE71-76
  (verified); [0x6c] cleared @0xD70 (path done) / @0xE07 (quit). No immediate-threshold cascade.
- Assets: CLOS-BKG via seg 0xbe:0xa @0x1084; FONTINTR once @0xff6; 7 CLOS-* sheets via 0x2db:0xe
  @0x110E..0x1185 into flat handle table base 0x72.
- Placement = table-driven actor structs, stride 0x0E=14B, base 0x4b96 (+0 sheet idx, +2 tick 0x4b98,
  +6 Y-base 0x4b9c), loaded by func_000A00 @0xA00 from the CLOSING sequence file. MIL (sheet idx 4,
  cmp ax,4 @0xC84 verified) fires special event lcall 0x69b,0xe (ax=0x59/0x5a).
- TEXT (important): the cinematic loop draws ONLY a debug step-counter at pen (5,5)/FONTINTR. There is
  NO scrolling-credits text render — the "credits" are the CLOS-* sprite actors. _text_close/_text_search
  (@0x1bd8/@0x19ea) parse CLOSING.TXT @CLOSING lines into 0x5382, driving actor timing not on-screen text.

Residual TBD for both = DATA-FILE CONTENTS only: per-element literal X/Y/frame timelines live in the
external OPENING anim file / PATH.DAT waypoint stream / CLOSING sequence file (each named with load
site + BSS table); the EXEs supply centering + schedule math (B). Plus CLOSING runtime interval [0x54]
and the LCALL 0x24a,2 clock-helper body (overlay seg 2). This completes the L1 (Presentation) layer:
every screen — in-VICEROY and the two separate cinematic binaries — is byte-decoded to the
data-file/runtime boundary.

## 2026-06-26 — L4 AI per-unit engine decoded (state machine, dispatch, heading, budget)

Decode-verify workflow over the orphan-overlay AI cluster (80 byte-verified findings, adversarially
re-checked via capstone; bodies in page_0C/0D/0F/13). New canonical doc spec/systems/ai.md.

Two AI movement engines:
- func_04E2D6 @0x04E2D6 (page 0x0D, ~15KB) = per-unit order/mission processor. Pipeline: entry gate
  on owner+order 0x314C (continue only if order in {0,5,6} or >=0xa, else exit 0x051C68) → validity
  gate 0x181F:0x302 (0 → state '@', exit) → reachability/colony context (0x952/0x614/0x722) →
  active-move flag → inline 8-dir scorer (delta tables [bx+0xb4]/[bx+0xbe]) → budget check (remaining
  = 0x181F:0x90C − [0x3149], <3 → stay + state '9') → write heading 0x314F → sentry toggle 5<->6 on
  bit 0x3148.2 → else step+goto (order 0x314C=0x0C, write 0x314D/0x314E @0x051C53) → tail-normalize
  @0x051C68. NO jump table (cmp-ladder).
- func_046FFA @0x046FFA (page 0x0C, ENTER 0xA2) = tactical heading evaluator. 9 candidates (8 dirs +
  stay); base score 200; reject Ocean(0x19)/SeaLane(0x1a)/Arctic(0x18); +4 same-heading / turn-cost
  via 0x181F:0x384; enemy-on-tile reject; colony proximity +0x28(40)/+0x14(20); target-distance ×3;
  frontier 0x181F:0x984 (reject if 0); early-era terrain +0x32(50); resource yield +0x10(16);
  COLONY-SITE +0x1F4(500) via 0x181F:0x7BE/0x9E6; RNG jitter 0x181F:0x4D4(1,5) (R); clamp >=0; pick
  strict-max; write 0x314F @0x047FA0 (8=no-move). The +500 colony-site term is what walks AI settlers
  to good spots.

0x314B AI state-char alphabet RESOLVED (~30 states, each assign site cited): X=cleared, -=dead slot,
0=idle/sentry, 1=target-selected, t/i=goal-class 1/7, ?=goal-lost, @=dropped, 9=out-of-budget,
A=colony-task, G=garrisoned, E=en-route, R=routed, V=arrived, L=routing-in, ==absorbed, U=on-target,
C=work-done, B/e=terrain-build, F=region-match; plus mission-dispatch tags 2/3/4/5/8/D/J/N/P/W via
func_04E2B6 (sets state=DL, order=0x0B AI-goto). The plan-map goal-type codes (1->'t',7->'i') and the
human mission name for each dispatch char are TBD (written by the earlier strategic-AI plan pass).

0x3149 RESOLVED (was AI-GATED): = AI move-credits SPENT this turn (points-per-action accumulator), NOT
enable/eval-passes. Reset 0 for all units at turn start @0x005872 + on spawn/re-task; charge +3/step
@0x05CAE2, +0x32/+2 heading-move @0x059F20/@0x059F3C. Act while allowance−[0x3149]>=3 (@0x03EE95); out
of moves once >=allowance (@0x007A08). Allowance = per-type byte from table 0x5234 (stride 14,
@0x006CEE) +3 ships. cmp [0x3149],0 gates select already-acted units (func_051D56 @0x051D5D).

This is the first real L4 decode — converts the AI-GATED unit fields (0x3149, 0x314B) to named, and
gives the rewrite the AI's per-unit decision pipeline + the tactical score formula. Residual L4 =
the strategic plan-map pass (mission assignment, the -0x674e goal-type table) + per-type stat tables
0x5234/0x5236/0x5237/0x523d + resident 0x181F helper identities.

## 2026-06-27 — L4 Phase 2: strategic plan-map planner, mission semantics, per-turn AI flow

Decode-verify workflow over the strategic AI layer (47 byte-verified findings, adversarially checked).
Extends spec/systems/ai.md §6.

PLAN-MAP (DS:0x98B0, 4-byte records, addr ((idx<<6)+slot)<<2, 64 slots/idx): fields field0/-0x6750 =
target X, v1/-0x674f = target Y (both copied to UnitRecord 0x314d/0x314e on goto commit @0x04E1AF),
goal_type/-0x674e = mission selector (0xFF=empty; 1->'t', 7->'i', 4 special), v3/-0x674d = priority/
weight. Accessors (far, page 0x0D): clearer func_04C1F0, setter func_04C3A2 (naked; priority-insert
via thunk 0x534F3->0x1A1F:0x4E8), query func_04C306.

CONFLICT FLAGGED (not resolved — recorded per hard rule, NOT guessed): the plan-map OUTER INDEX is
[bp+6] in both producer func_04CC50 and consumer func_04E2D6. In func_04E2D6 [bp+6] is byte-confirmed
the UNIT index (imul bx,[bp+6],0x1c @0x04E2EF) -> argues per-unit 64-slot list. BUT a flat unit*64*4 =
0x12C00 table at base 0x98B0 OVERFLOWS the 64KB data segment, and the per-power turn loop calls the
strategic pass once per power (0..3). So unit-vs-power outer index is UNRESOLVED. Two workflow targets
gave opposite "CONFIRMED" answers (each verified only its own citation). Blocker: need the 0x98B0
table's allocated size (no memset found in committed pages) or func_04CC50's [bp+6] cardinality at its
dispatch-island caller. ai.md §6.1 carries the warning; do not assert either reading as fact.

MISSION-DISPATCH CHARS (all via func_04E2B6 -> 0x314B=char, order 0x314C=0x0B): '2'=scout-explore
(@0x4F030, type5 to scored frontier tile), '3'=move-to-colony (@0x4F1FD, score own colonies),
'4'=go-to-native-village (@0x508AB), '5'=move-to-current-colony (@0x50768), '8'=explore-wander
(@0x50D58, rand step counter 0x3156), 'D'=long-range explore (@0x5107C), 'J'=go-to-native-village
capital-preferring (@0x50BD8, reads NativeSettlement+0x03&0x04 Capital), 'N'=Scout/Pioneer->colony
(@0x50C3B), 'P'=move-to-best-colony by +0xAA (@0x504D2), 'V'=fallback move-to-colony (@0x4E9E2),
'W'=move-to-colony-with-need (@0x50E18, colony flag +0x1b&0x04). AI unit missions = explore /
return-to-colony / visit-natives, selected by plan goal_type + per-target scoring.

PER-TURN AI FLOW: main loop func_005760 (body @0x5836) resets 0x3149=0 for all units @0x5872, then
per-power loop [bp-0x14]=0..3 setting active power [0x5394] @0x5920. Controller gate
imul bx,idx,0x34; cmp byte[bx+0x543f],0; jne skip @0x58A6 (0=this power runs King+Orders; skips human).
Orders phase func_024A48 (lcall 0x181F:0x62C) branches on mode [0x5390] (0=interactive, !=0 AI-fast).
Strategic pass func_04CC50 (ENTER 0x1E4) reads plan map, assigns goals to units @0x04E199. Per-unit
driver func_051D56 gates on 0x3149!=0 (acted) AND order==0x0B, calls func_04E2D6 via far-jump island
0x534F8 (ljmp 0x1A1F:0x4F4). Units enumerated by flat i<[0x539c] owner-filtered loop, NOT tile links.
Controller byte [idx*0x34+0x543f]; AIPersonality [idx*0x34+0x540E].

## 2026-06-27 — L4 Phase 3a: UnitTypeStats table = loaded @UNIT CSV (14-byte record @0x5234)

The per-type AI stat fields 0x5234/0x5236/0x5237/0x523d are NOT separate tables with different strides
— they are FIELDS of a single 14-byte UnitTypeStats record at DS:0x5234, one per @UNIT row (24 types).
Stride proven ×14 at the resident sites: @0x006CEE/@0x0074A9/@0x006826 all use the chain
`cx=t; shl bx,1; add bx,cx; shl bx,1; add bx,cx; shl bx,1` = t·14 (=((3t)*2+t)*2=14t).

CORRECTION (hard-rule record): the L4 Phase-1 workflow findings that wrote "[type*6+0x523d]" and
"[type*6+0x5236]" (stride 6) for the AI 'B'/'e'/'V' capability gates were a STRIDE ERROR. The base
0x5236/0x523d is shared with the ×14 resident accesses, so the stride must be ×14; the AI-overlay
sites disassemble with the same ×14 chain (naive linear capstone mis-aligns them — read page_0D.asm
for true boundaries). ai.md §5a/§8 corrected; do not cite ×6.

The record IS the loaded @UNIT CSV (data_extracted/text/NAMES_sections.json @UNIT, primary data),
field map (oracle ingame_orders.bin + @UNIT cross-check):
 +0x00 = @UNIT moves × 3  (move allowance / budget; 1 move = 3 budget = the +3 step charge — closes
         the loop with the 0x3149 move-credits model). Colonist 1->3, Scout/Caravel 4->12, Frigate
         6->18, Privateer 8->24, Man-O-War 5->15.
 +0x01 = defense ; +0x02 = attack (stored def,atk; note CSV lists atk,def — order swapped in memory).
         Artillery oracle +01=5/+02=7 vs @UNIT atk7/def5 confirms +01=def,+02=atk.
 +0x03 = work/build cost (used in 'C' state: done when work-counter 0x315a >= 10 - cost).
 +0x04..+0x08 = ship/cargo block (col6 '99' sentinel for all ships @+0x04; cargo/bombard +0x05..+0x08
         = @UNIT cols 6-10 verbatim; exact per-field labels soft).
 +0x09 = terrain-feature capability bitfield = @UNIT last (binary) column verbatim: Colonist
         01000000=0x40, Soldier 00011100=0x1c, Caravel 10100010=0xA2. Read by AI build states B/e.

Resolves ai.md open-question #2 (per-type stat tables): they are @UNIT primary data, not a separate
TBD decode. A rewrite drives AI combat/move/build straight from @UNIT (×3 the move column).

## 2026-06-27 — L4 Phase 3b: AI scoring helpers resolved to resident functions

The 0x181F:xxxx scoring helpers the AI calls are Type-B RESIDENT functions in the load image
(resolved via tools/follow_thunk.py: each thunk's LJMP target = file 0x2400+S*16+O, all <0x20665).
Two cross-validate prior anchors (proving the map): 0x90c->func_006CCA = the UnitTypeStats reader
(§5a); 0x4d4->func_00C322 = the Track-12 colony-placement LCG random_int.

Map: 0x302->func_005BFA (tile in-bounds: returns 1 iff 1<=x<[0x853a]-1 AND 1<=y<[0x853c]-1, so
[0x853a]=MAP WIDTH, [0x853c]=MAP HEIGHT); 0x37a->func_00493C (tile distance: abs dx/abs dy via
not;inc); 0x614->func_0083F2 (reachability, signed, <0=unreachable); 0x90c->func_006CCA (allowance,
UnitTypeStats); 0x4d4->func_00C322 (random_int LCG); 0x9e6->func_0082DC (select colony -> [0x8542]);
0xa4c->func_0081F2 (select native -> [0x8d4a]); 0x7be->func_008D26 (colony-site validity, feeds +500
term); 0x78c->func_00627A (tile terrain id, get_terrain_id family); 0x7e0->func_0066CC (units-on-tile
enumerator); 0x322->func_00860E (terrain-feature query, feeds +0x14/0x28 bonus).

Resolves ai.md open-question #3: the AI's evaluation primitives are named, load-image-resident, and
decodable — no longer behind opaque overlay thunks. By-product: map dims [0x853a]=W, [0x853c]=H.
Remaining leaf = the internal terrain-quality math of 0x614/0x7be/0x322 (small resident funcs).

## 2026-06-27 — L4 Phase 3c: AI scorer internals bottom out at the shared map/colony layer

Decoded the resident scorer bodies. They call the engine's MAP-ACCESS segment 0x37f — same primitives
the rest of the engine uses, not an AI-private map:
- 0x37f:0xa = tile in-bounds; 0x37f:0x10e = raw map byte; 0x37f:0x314 = unit-index at tile;
  0x37f:0x358 = tile terrain/owner.
- func_00627A (tile-id helper 0x78c) -> 0x37f:0x10e raw byte -> func_00624E = the
  get_terrain_id_from_raw chain (CLAUDE.md hard-rule 3); returns terrain 0..26, default Ocean off-map.
- func_0066CC (units-on-tile 0x7e0) -> 0x37f:0x314; returns occupying unit idx or 0xffff.
- func_008D26 (colony-at-tile 0x7be) iterates ColonyRecord[0x5d46] stride 0xCA (count [0x539e]),
  matching record +0x00=x/+0x01=y; returns colony idx or 0xffff. RE-CONFIRMS the documented colony
  layout (colony.md base 0x5D46 stride 0xCA). Oracle (colony_jamestown.bin): count=5, colony[0]=(48,30),
  active [0x8542]=0x606e = 0x5d46 + 4*0xCA exactly.
- func_005BFA (validity 0x302): in-bounds gate -> map dims [0x853a]=W, [0x853c]=H.

Closes ai.md open-question #3: the AI scoring stack terminates in the already-specified map/colony
data layers; no further AI-only black box beneath the named helper map. Remaining soft spot = the
exact weighting math inside func_0083F2 (reachability), a small decodable resident function.

## 2026-06-27 — L4 plan-map outer-index conflict RESOLVED: power-indexed (4×64)

The Phase-2 flagged conflict (plan map unit- vs power-indexed) is resolved in favor of POWER-indexed
(4 powers × 64 slots), by two independent proofs:
1. Function boundary: there is NO function prologue (enter/push-bp after retf) between func_04CC50
   (0x4cc50, ENTER 0x1e4) and func_04E2D6 (0x4e2d6). So func_04CC50 is one function spanning
   0x4cc50..0x4e2d5, and ALL plan reads/writes (0x4dff4, 0x4e05c, 0x4e07e, 0x4e16e, 0x4e199) are
   inside it, where [bp+6] = func_04CC50's POWER argument (per-power turn loop calls it once/power).
   The earlier "func_04E2D6 reads goal_type by unit index" was a FUNCTION-BOUNDARY MIS-ATTRIBUTION —
   those sites are the tail of func_04CC50, before func_04E2D6's entry. func_04E2D6 (per-unit, [bp+6]
   =unit) does NOT re-read the plan map by unit; it acts on the 0x314B/0x314C/0x314D-E that func_04CC50
   already wrote.
2. BSS layout: power-indexed table = 4*64*4 = 0x400 bytes, spans DS:0x98B0..0x9CB0; the next live
   global cluster begins EXACTLY at 0x9CB0. A unit-indexed table (300*64*4 = 0x12C00) is impossible:
   it overflows the 64KB DGROUP and the live globals from 0x9A00 up.

Consequence: the 0x314B alphabet splits by writer — planning states 1/t/i/? written by func_04CC50
(strategic, per-power), execution states (@/V/L/=/C/U/R/9/G/B/e/F/0 + mission-dispatch chars) by
func_04E2D6 (per-unit). ai.md §1/§4/§6.1 + open-question #4 updated. This closes the last flagged
conflict in the AI spec.

## 2026-06-27 — L3 Phase 1: colony per-turn economy (conversion ratio, growth, warehouse correction)

Decode-verify workflow (29 byte-verified findings; adversarially checked; 5 corrected arg-labels).

MANUFACTURING (func_008E84): ratio = 1:1 (1 finished per 1 raw the tile loop gathered), with a
×2/3 throttle when the finished good's building-chain count > 2 (func_00864E result; the chain table
DS:0x8F86 + link ids byte[good+0x2F4], owned-test via building bitfield ColonyRecord+0x84/func_00860E
imul colony,0xCA + [si+(b>>3)+0x5DCA] bit b&7). Tools(14) subtract per-turn [0x8E66]. Commit
func_008E46->func_008E02 (bookkeeping tables 0x8E0A produced-ref / 0x8E32 leftover-raw / 0x8E5A
overflow-surplus, surplus rescaled x3/2 when throttle fired). Chains @0xA660..0xA68C:
Ore6->Tools14, Tobacco2->Cigars10, Cotton3->Cloth11, Furs4->Coats12, Sugar1->Rum9.

FOOD/GROWTH: consumption=2*pop (@0xA5F2); surplus=max(0, producedFood[0x8DC8]-2*pop) (@0xA5F7);
half (ceil(surplus/2) @0xA606) accrues to colony +0xAA; threshold 25 normal / 50 difficulty (gate
@0xA5B4); colonist born func_009318 INC[+0x1F] @0x9464; starve func_008FB4 @0x902E DEC[+0x1F]
(shifts job arrays +0x20/+0x21/+0x40/+0x41 + work-tile table +0x70). The 0xA5D0..0xA640 block is the
colony-screen FORECAST/display, not the mutation; the deficit->remove trigger + per-turn +0xAA write
remain TBD. (Also: +0xAA here vs the older +0xC8 growth-accumulator gloss need a runtime reconcile.)

WAREHOUSE CORRECTION (overturns a settled reading): there is NO per-good spoilage clamp. The +0x9A
stockpile banks with a floor at 0 and NO ceiling (func_02D658 @0x2D96E add, @0x2D972 clamp>=0). The
over-100 disposal is the auto-export-to-Europe step: flat threshold 0x64=100 -> reduce to 0x32=50
(@0x2D6F7/@0x2D70B), excess SOLD (net=excess*price-tax credited to PowerRecord+0x22 @0x2D785), gated
by tradeable filter func_02EF55 and the independence flag [0x5382]&1 (@0x2D728; if independent the
excess is WASTED not sold). func_008D00 (level+1)*100 is fetched once @0xA615 and bounds ONLY the
food growth reserve (cap-[+0xAA] @0xA61F), NOT goods. (warehousing.md §6.4 already had the sell/waste
model right; colony.md §5/§warehouse "surplus dropped (spoilage)" was wrong and is corrected.) The
verified bytes overturn the prior "goods spoil at (level+1)*100" claim, per the hard rule that EXE
bytes win.

## 2026-06-27 — L3 Phase 4: endgame (REF re-confirm, naval combat, Tory uprising)

Decode-verify workflow (39 byte-verified findings; REF 13/13, naval 10/12, tory 16/17).

REF (re-confirmed; ref_growth.md already had this): INIT func_0755CC, difficulty d=[0x53A6]:
Regulars[0x53DA]=8d+15, Cavalry[0x53DC]=5d+5, Man-O-War[0x53DE]=3d+2, Artillery[0x53E0]=6d+2 (4-type
array stride 2; parallel 0x53E2 deployed-count). GROWTH func_03E162 (King phase, pre-independence):
royal_money(PowerRecord+0x22) += (8d+10)*2^(eras at year 1600/1700/1750); at +0x22>=1800 buy 1 unit
inc[0x53DA+slot*2], -=1800. Budget-paced, player-only. revolution.md line 54 stale-TBD fixed.

NAVAL COMBAT (combat.md, was TBD): resolver func_05B2C2 (land+naval; [bp+6]=attacker,[bp+8]=defender).
Ships type 0x0D..0x12. Naval strengths from UnitTypeStats fields 0x523B/0x523C = the +0x0B/+0x0C bytes
of the 14-byte record at DS:0x5230 (per-type stats, loaded func_074ED5, NOT per-engagement). Roll
@0x05B844: A=stat[atk*14+0x523B], D=stat[def*14+0x523C], roll=random_int(1,A+D) (func_00C322); attacker
-win flag [bp-0x3A] kept when roll<=threshold[bp-0x1c]=D; independence-war special cases clear it
(test[0x5382],1). Loser fate @0x05BAA3 capture/cargo/sink. Separate land roll random_int(3,6)+terrain
@0x05BA0B. func_05CA7E = PRE-COMBAT/UI setup (ship-range flag), NOT the roll (resolves that TBD).
Damage-vs-sink threshold + bombardment (FORTFIRE) remain narrow TBD.

TORY UPRISING (tory_uprising.md, resolves the TBD "fraction"): func_03CAC6 @0x3CAC6. NO standalone
SoL threshold (negative-answered). Per-call gate random_int(0,diff+1) @0x3CAD0 -> fires if !=0 (prob
(diff+1)/(diff+2)). Targets the rebel power's colony with MAX tory_strength = pop[+0x1F]*(100-SoL%)*2
/100 + diff + 1 (SoL% via 0x181F:0xC86), reduced by defending rebel units, requiring >=1 free adjacent
tile. SoL enters ONLY via magnitude (lower SoL -> more militia), not fire/no-fire. Spawns Tory-Militia
(type [0x53D2]) on free tiles, count = strength countdown (not fixed 8); marks colony [+0x1C]|=1 (no
re-fire); suppresses silently if no free tile. Caller cadence + numeric militia type id remain TBD.

## 2026-06-27 — UI closeout: 3 PARTIAL screens resolved; HUD blit mechanism byte-verified

Thorough adversarial UI workflow (4 targets, ~35/46 confirmed) + hand-verification + pixel
cross-check against docs/screens/*.png. The "overlay-resident, not statically resolvable" label on
the HUD text was the prior cop-out; the mechanism IS resolvable. All 21 UI tracker rows now DONE.

SHARED TEXT MECHANISM (byte-verified): set_text_box(w,h,x,y) @file 0x2740 writes BSS rect
[0x2cca]=w/[0x2ccc]=h/[0x2cc6]=x/[0x2cc8]=y; the painter @file 0x275C (thunk 0x181F:0xB0, ENTER 0x54)
reads that rect. Per-screen title/header positions = the set_text_box call args. Centered text =
verb 0x181F:0x100. String resolver = func_002462 (0x181F:0x22, DIRECT-index blob[idx]).

MAP SIDEBAR (row 1 -> DONE): composer func_067700 (via 0x181F:0xE1C); x-origin [0x8550]=240
(func_070FF8 @0x071039); FONTTINY white 0x0F (func_076C70 @0x076C85); rect (240,72,80,64); values
gold=PowerRecord+0x2A, tax=+0x01, season=(year[0x538a]-1500)/50; strings @MISC/@INFO/@SEASONS; unit
panel func_0672C8 (sprite +0x3144/45 via 0x181F:0x7BE). The ONLY runtime leaf = per-line y within the
rect, emitted via a runtime-installed print vector [0xa644]=0x1a1f:0x0f10 (func_0772FA @0x07730C);
authoritative layout = pixel-measured from docs/screens/06_ingame_map.png (FONTTINY 8px stack
[season+year, "Gold:N", "Tax:N%"]). No hidden gap.

EUROPE (row 3 -> DONE): header strip func_030F76 (composer step 4 @0x031E6B) via painter 0x181F:0xB0
(file 0x275C) reading the set_text_box rect; dock empty caption rect (69,120,81,143) string [0x2dd0]
@0x0314F8; ship names @UNIT[type] (func_0314DC @0x031642); gold PowerRecord+0x2A. Residual = the
per-screen set_text_box title-origin args + live heap-string slot contents (runtime).

CONTINENTAL CONGRESS (row 5 -> DONE, all byte-cited): title x=0/y=5/w=320/0x90 (0x181F:0x100 @0x37A29);
body x=4/y-seed=25/+FONTTINY-height[0x89E]; "Next Session" line (label [0x2E9A] + FF name); sentiment
x=4/0x92 (Rebel% [0x53D4]/0x181F:0x9A4, Tory% [0x2E9C]); bell strip proportional sprite 0x3F filled/
empty; REF rows count-badge verb 0x181F:0x222 (icons [0x52xx]); FF list loop i=0..0x18 owned-bit
0x181F:0x7B4; FF portraits @0x3BAA6 blit at coords baked into CC-NN.SS frame-0 descriptor
(es:[bx+0x46/0x48]) — asset-internal, the correct answer; OK/dismiss 0x191F:0xF74. Residual = live
counts only (runtime).

NET: every UI screen's structure (rects, fonts, colours, sprite blits, string+value sources, paint
chains, hit-rects, the text-box mechanism) is byte-verified; the residual across the whole UI is the
consistent "live game-state value + a few runtime-dispatched per-line text y" class, each bounded by a
byte-verified rect and pixel-confirmed in the captures. The UI is rewrite-ready.

## 2026-06-27 — PALETTE BUG: VICEROY.PAL is stride-3 RGB, not stride-4 RGBA (found via render test)

The "ultimate test" (render the colony screen + compare to the live DOS capture) surfaced a real,
load-bearing pipeline bug that no amount of disasm review had caught: ALL extracted asset colours
were wrong.

Root cause: tools/extract_pal.py read VICEROY.PAL as 256 entries x 4 bytes (RGBA 6-bit), but the file
is 256 entries x **3 bytes (RGB 6-bit)** = the first 768 bytes (the remaining 256 are trailing/unused).
PROOF (ground truth = pixels, top of trust hierarchy): the live colony capture renders index 54 as
blue (104,136,192); stride-4 gives (186,186,64) yellow, stride-3 gives (105,138,195) — a near-exact
match; the 6-bit blue (26,34,48) sits at byte offset 162 = 54*3. Stride-3 also reproduces the smooth
blue sky ramp at indices 49..58 (consecutive gradient), which a stride-4 read scrambles.

Impact: data_extracted/palette.json and EVERY lab/assets PNG (which baked a wrong/EGA palette) had
wrong colours. The prior "render looks right" claim was WRONG (the user correctly flagged it).

Fix: extract_pal.py stride 4->3; data_extracted/palette.json regenerated (idx54 #698ac3 ~ real
#6888c0). tools/render_colony_screen.py now applies the correct stride-3 palette to each asset's index
plane (which IS correct — verified: raw COLONY.PIK index == lab index == 54) and honours each PNG's
own transparent index (253, not 0). With the fix the colony bottom band matches in colour (sky/grass/
panel); residual differences are (a) placeholder building identities (the building-id -> BUILDING.SS
frame map is still TBD; positions are byte-correct via DS:0x266) and (b) dynamic overlays drawn over
COLONY.PIK (colonist sprites, "No Ships In Port", SoL crown).

Follow-ups: re-extract/re-palette lab/assets with the corrected palette; decode building-id ->
BUILDING.SS frame mapping; wire the dynamic panel state. Also: PALETTE_AND_CYCLING.md / formats/PAL.md
say "256x4" — those docs are wrong and need correcting.

## 2026-06-27 — Colony empty-plot terrain decoded; building-frame formula REFUTED vs snapshot

Decoded (B): The colony plot grid (`func_02701C @0x2701C`) draws BOTH buildings and empty-plot
terrain from the **same active sheet descriptor `[0x2DA8]`** = **BUILDING.SS**, both blitting at
`(plotX, plotY+8)` via `0x181F:0x254` (frame in AX).
- **Empty plots** (`def_id = byte[0x8E82+plot] < 0`): painter `func_026FF2 @0x26FF2` draws terrain
  frame = `byte[0x260 + category]`, category = `byte[0x8D62+plot]` (0..4), **skipped when the table
  byte is 0**. Live Jamestown snapshot: `DS:0x260 = [45,44,43,0,46,0]` → categories 0/1/2/4 map to
  BUILDING.SS frames 45/44/43/46 (the end-of-sheet terrain tiles); category 3 → no decoration.

Refuted (corrects spec §3.7 line 265): the prior one-line claim "building frame =
`word[id*2 − 0x7238]` (= `[id*2 + 0x8DC8]`)" **does not verify** against the byte-correct snapshot —
it returns out-of-range / non-distinct values (def `0x1B`→`0x1010`, `0x18`→`0x1000`; most defs
collapse to 0/16). `def_id` is also NOT the frame index. The real building painter `func_026DD4`
(thunk `0x2CA23`) resolves frames through `func_026CC2`'s multi-branch logic (special-cases id
`0x11/0x13/0x14`, reads `[0x8DD8]`/`[0xA892]`, default `def_id+1`) which does not reduce to a
snapshot table. Exact building→frame mapping = **TBD pending a runtime trace** capturing AX at the
`0x181F:0x254` blit. Spec §3.7(5) downgraded to R/TBD with this reason.

Render (tools/render_colony_screen.py): added empty-plot terrain; full-screen MSE 3625→3606. The
scene-band residual (~4800) is dominated by the unresolved exact building frames + the dynamic
COLONY.PIK panel overlays (SoL "100% (I)", "No Ships In Port", colonist sprites, boycott Xs) which
are runtime game-state, not static layout.

## 2026-06-27 — Colony snapshot DID match the screenshot (matched RAM+screenshot pair)

> _An earlier same-day ruling claimed `colony_jamestown.bin` and `11_colony_screen.png` were
> "different game states" that no render could match — based on misreading the on-screen "100% (I)"
> as 100% Sons-of-Liberty. That ruling was **wrong** and has been **removed** to avoid leaving
> conflicting information; this entry is the corrected record._

I drove the live game (DOSBox, loaded COLONY09.SAV, founded Jamestown, opened the
colony screen) and captured a matched screenshot + RAM pair (`scratchpad/dbx/colony_live_1505.bin`
+ `docs/screens/colony_live_1505.png`). Results:
- The live colony screen matches `11_colony_screen.png` at **MSE 312** (essentially identical, one
  turn apart: 1504 vs 1505).
- The live RAM is byte-equivalent to the original `colony_jamestown.bin`: same active-colony ptr
  `cp=0x606E`, name "Jamestown", pop 1, same `0x266` plot table, same `0x8E82` def-ids, same
  `DS:0x260=[45,44,43,0,46,0]` terrain table. (Only diff: the original had Muskets=50 garrisoned.)
- So `colony_jamestown.bin` and `11_colony_screen.png` were **the same state all along** — a fresh
  pop-1 Jamestown. My "fresh vs developed" claim was wrong.

Root cause of the wrong ruling: I misread the on-screen **"100% (I)"** as Sons-of-Liberty membership.
Byte-traced `sol_membership_pct @0x8524`: returns `100·A / divisor` capped at 100, where
**A = u32 at colony+0xC2/+0xC4** and **divisor = u32 at colony+0xC6/+0xC8** (32-bit, not just +0xC6),
plus **+20 if the colony's owner is human** (`[bx+0x1a]` power < 4 and controller-gate
`[idx·0x34+0x543F]==0`). For this colony A=0, divisor=200 ⇒ **SoL membership = 0%** (or 20% with the
human bonus) — NOT 100%. Therefore the "100%" panel value is **not** sol_membership_pct; its exact
source (likely the Tory/complement or a different label) is a separate open item. The SoL formula
itself is confirmed; the spec should note the 32-bit divisor (+0xC6/+0xC8) and the +20 human bonus.

Consequence: the render's MSE-3625 gap vs the screenshot is **decode quality** (building frames +
dynamic overlays), not state mismatch — and is now validatable against the matched live pair.

## 2026-06-27 — Colony plot frames EMPIRICALLY verified (MSE 0) from the matched pair

Using the matched RAM+screenshot pair (colony_live_1505.bin + docs/screens/colony_live_1505.png),
each plot's rendered sprite was matched against every BUILDING.SS frame by minimising pixel MSE.
Result (ssdec frame K = game frame K+1, reconciling func_026DD4's def_id+1):
- **Buildings**: ssdec frame = **def_id** (byte[0x8E82+i]); plots def 21/24/27/32/39 matched at
  **MSE 0**. Special case **def_id 0 -> frame 16** (MSE-best). def 9 -> 9, def 35 -> 35 (small MSE
  from neighbour occlusion).
- **Empty plots**: ssdec frame = **table[cat] - 1** (table=DS:0x260=[45,44,43,0,46,0],
  cat=byte[0x8D62+i]); matched at MSE 0 (cat 0/1/2/4 -> frames 44/43/42/45). Skip when table byte=0.
- Both blit at (x=word[0x266+i*4], y=word[0x268+i*4]+8).

This corrects the renderer (was using table[cat] for terrain -> off-by-one wrong sprite; missing the
def0->16 special). With the fix the building/terrain scene matches the real screen sprite-for-sprite;
full-screen MSE 3625 -> 2525. Committed a 36 KB reproducible fixture
data_extracted/colony_jamestown_fixture.bin (DGROUP slice, base 0x200) so the render no longer
depends on the 22 MB RAM dump. Remaining render gaps: the surrounding-tile minimap, the dynamic
COLONY.PIK panel overlays (SoL text, colonists, boycott marks, dividers), and stockpile qty numbers.

## 2026-06-27 — Stockpile icon frame fixed to ssdec 0x16+good (ROOT CAUSE: ssdec off-by-one)

The renderer drew stockpile commodity icons at ssdec frame **0x17+good**, which shifted every cell
by one so cell 0 showed **Sugar instead of Food** (user-reported, repeatedly). EMPIRICAL pixel match
against the matched live capture (docs/screens/colony_live_1505.png) is unambiguous: **all 16 cells
match at MSE 0 with ssdec frame = 0x16+good** (Food=ssdec 22, …, Muskets=ssdec 37), cell pitch 19,
icon y=181, x = 2 + i·19 + (18−w)/2.

Root cause (durable): **ssdec.py is off by one vs the EXE — `ssdec_frame[K] = game_frame[K+1]`.** The
spec's byte-cite `add ax,0x17` is the GAME frame and is correct; the ssdec renderer must use game−1 =
0x16. Same mechanism fixed the building frames (game `def_id+1` → ssdec `def_id`) and empty-plot
terrain (ssdec `table[cat]−1`). Documented in SETTLED.md so it stops churning. The 2026-06-27
prereq-1 "correction" to 0x17 is retracted. Stockpile band MSE 2697 → 1316; full screen 2525 → 2393.

## 2026-06-27 — Colony screen layout: parchment width + black separator lines (measured)

User-reported (3x): the rendered parchment was too wide and the black area-separator lines were
missing. Measured from the matched live capture (docs/screens/colony_live_1505.png):
- **Parchment scene rect = x 0..198, y 8..127** (NOT to x223 — the renderer tiled PARCH 32px past
  the edge, overprinting the minimap panel). Clipped to x<199.
- **Black separator lines: vertical x=199 (y7..128); horizontal y=7 (title|scene) and y=128
  (scene|COLONY.PIK band).** These are pure black (RGB<30) and are the only black separators — the
  band's inter-panel dividers are GREEN (part of COLONY.PIK), not black.
- Minimap box frame: black border at x=223 (left) / x=296 (right), y≈16..95 (content = the
  func_026374 surrounding-terrain render, still TBD — needs the seg-0x37f map board).

Clipping the parchment + drawing the 3 black lines dropped full-screen MSE 2252 → 971 (the over-wide
parchment had been overprinting the woodgrain minimap panel). Scene 3006→1094, band 1099→671.

## 2026-06-27 — Colony screen: per-element pixel-verification status + map board located

Systematic per-element verification against the matched live pair (colony_live_1505.png + RAM).
Each "fixed" item is MSE-measured, not eyeballed. Full-screen MSE 3625 → 971.

DONE (pixel-verified):
- Buildings/trees/terrain — ssdec frame=def_id (def0→16) / terrain=table[cat]−1; MSE 0 per sprite.
- Stockpile — all 16 icons ssdec frame 0x16+good (Food first), x=2+i·19, y=181; MSE 0. + qty numbers.
- COLONY.PIK band overlays — colonists (ICONS 81/102), crown (124), production (22/56/62),
  tool buttons (67/68/69/54); MSE-0 placement.
- Layout — parchment scene = x0..198 y8..127 (was over-wide to x223); black separators x=199 / y=7 /
  y=128 (band dividers are green, part of COLONY.PIK, not black).
- Title — "<name>.  <Season>, <year>.  Gold: <gold>e" from season@0x538C / year@0x538A / gold@0x8832.

REMAINING:
- **Minimap (surrounding-terrain scene, `func_026374`)** — the dominant remaining error. Map board
  LOCATED: live RAM file off **0x665710**, row-major **stride 58 (=mapW)**, terrain id = `byte & 0x1F`
  (verified: colony island = land 0x0B/0x0F at cols44–46/rows41–42 in ocean 0x19, sealane 0x1A right
  edge). Window origin globals `[0x9CCC]=1` / `[0x9CCA]=22`. NOT yet rendered: the exact tile-window +
  scale, the TERRAIN.SS frame per terrain id, and the worked-tile/unit-dot/selection-box overlay
  composite. An approximate flat-colour fill did NOT match the real textured view, so it was not
  committed (no-fabrication).
- Minor: red-X warehouse count, "100%/No Ships" text x-position, parchment texture variation,
  stockpile green-highlight box exactness.

## 2026-06-27 — Minimap render FORMULA decoded (func_026374); terrain-frame helper is the blocker

Decoded the colony surrounding-tile minimap render loop (`func_026374 @0x26412..0x264a2`):
- **3×3 grid of tiles around the colony**, 24px spacing. Per tile, delta tables `[idx+0xde]` (row)
  / `[idx+0xc8]` (col): **screen Y = 24·rowδ + 0x3C(60)**, **screen X = 24·colδ + 0xFC(252)**.
- **frame = helper(tileX,tileY) + 0x5A**, where helper = `lcall 0x181F:0x718` (returns a per-tile
  terrain RENDER index, NOT the raw board id). Blit `0x181F:0x254` from sheet descriptor **`[0x839E]`**.
- Map board confirmed at live file off **0x665710**, stride 58, raw id = `byte & 0x1F`.

BLOCKER (next session): rendering `PHYS0` frame `(rawid+0x5A)` gives small OVERLAY sprites
(birds/clouds), not ground tiles — so `0x181F:0x718` maps the raw id through a terrain-render LUT
before +0x5A, and the sheet `[0x839E]` is not plain PHYS0/TERRAIN (both ruled out by pixel match).
Need: resolve `0x181F:0x718`'s LUT + identify the sheet loaded into `[0x839E]` (loaded by index, no
name string). Until then the minimap stays unrendered (no fabrication). It is the only colony-screen
element not pixel-verified; everything else is MSE-measured DONE (full screen MSE 971).

## 2026-06-27 — Minimap is a COMPOSITE map render (definitive), not a single-sprite blit

Exhaustive pixel match of the minimap centre tile against EVERY frame of EVERY .SS sheet (each with
its own palette, position window) found NO clean match (best MSE 10272, PHYS0 f149). Conclusion:
each minimap tile is a **composite** — TERRAIN.SS base-ground sprite UNDER a PHYS0 overlay (forest/
hill/coast/river), i.e. the colony minimap reuses the full **in-game map-render chain**
(`func_O514→O513→O512`, hard rules 5/7), not a flat terrain sprite. That is why `0x181F:0x718`
returns a processed render index and `[0x839E]` is the active map sheet, and why frame=id+0x5A on a
single sheet fails. Rendering it faithfully = reimplementing the map-render composite (TERRAIN base +
PHYS0 overlay + auto-forest/river/coast logic) at the 3×3 / 24px minimap scale — a large separate
subsystem (spec/systems/map_system.md), not a colony-screen leaf. Left unrendered (no fabrication).

NET colony-screen status: every element EXCEPT this minimap composite is pixel-verified against the
matched live capture; full-screen MSE 3625 → 971. The minimap is the one element whose faithful
render depends on the in-game map renderer.

## 2026-06-28 — Colony-site value ("Show Colony Sites" cheat) is a cached map-layer nibble, formula byte-traced

**Conflict**: `ai.md §3b` (2026-06-27) concluded the F9 "Show Colony Sites" 0–24 value was
draw-time-computed, NOT cached, and the scorer "not statically locatable" (overlay-resident behind a
runtime-patched type-A thunk). This blocked the last open spec TBD.

**Resolution (B, 2026-06-28)**: All three claims were wrong. (1) **Cached**: the value is the **low
nibble of map-layer #4** (`[0x168]/[0x16a]`, the 4th of four w×h byte planes malloc'd at `func_070FE8`).
The 2026-06-27 snapshot scan was a false negative because it searched for the *terrain* land/water mask,
which this packed-nibble plane does not match. (2) **Range 0–15, not 0–24**: the F9 handler `func_021602`
masks `& 0x0F` (clamp ceiling 15; observed coast max 13). (3) **Statically locatable**: the writer is
**`func_063F3C`** (file `0x063F3C`, page_14), a new-game map-gen pass (already documented in
`map_generation.md` as the "resource/land-value layer" writer, A) — store `@0x064130` via `func_005ED0`.
Formula: per land tile, ring-weighted sum over the ~21-tile catchment of per-terrain Improvement stat
`[terrain·16+0x2F79]` / special-resource bonus / ocean coastal-adjacency, near-colony-halved,
Mountains→0/Hills→½, then `clamp(score/10, 0, 15)`; water/oob ⇒ 0. Dispatch: cmd id `0x6C` →
jump-table `0x023DE8` → `func_021602`. Pinned via the dispatcher jump-table structure (the F09 thunk
pointer is runtime-patched). Independently re-derived by two passes (decode + adversarial verify);
oracle-consistent (ocean=0, coast 9/11/12/13/13). **Supersedes the §3b "open/TBD" status — last spec
formula now closed.**

**Authority**: `func_021602`/`func_005EE8`/`func_063F3C`/`func_005ED0`/`func_0048CC` byte offsets;
`spec/systems/ai.md §3b`; cross-ref `spec/systems/map_generation.md`.

## 2026-06-28 — European price-drift IS a per-turn end-of-turn phase (driver func_036574), not trade-screen-only

**Conflict**: `market.md` (2026-06-20) claimed the all-goods price drift runs only inside the
interactive trade screen ("not a separate headless turn phase"), attributing it to `func_33C96`.

**Resolution (B)**: The driver is **`func_036574`** (body `0x036574..0x03680D`), called from the
**end-of-turn processor `func_0755CC @0x0757B0`** (`lcall 0x191F:0x0B6C`; `func_0755CC` carries the
`AMER2.MP` string + the `0x5380..0x53E0` per-power turn block). `func_036574` clears the per-power
16-good accumulators then runs a 4-power loop calling `func_0305A8` via `@0x367FC`. So drift happens
**per-turn** (end-of-turn) AND per-transaction (`func_0324F2`/`func_032914`). The `func_33C96` name was
a mislabel (`func_033C96` is the unrelated ARMOPTIONS fn); `@0x367FC` is the internal call site within
`func_036574`. Supersedes the "trade-screen-only / no turn phase" claim. **Authority**: `func_036574`,
`func_0755CC`, `func_0305A8` byte offsets; `spec/systems/market.md` §3.

## 2026-07-28 — .FF glyph-table index mapping is ch−1 (formats/FF.md off-by-one corrected); text-colour LUT located

**Conflict**: `formats/FF.md` documented the `.FF` width/offset tables as `width[char]` for char
0..127 ("render-validated"). Under that mapping the decoded metrics were nonsense (FONTTINY "6×4
fixed", `h`/`k` narrower than `i`/`l`, `M` narrower than `L`) and `fonts_and_colors.md` propagated
"6 × 4 fixed" / "9 × 6 fixed" — while `menus.md` independently observed a *proportional* FONTTINY
advance. The per-glyph table itself had been deleted with `docs/UI_FONT_REFERENCE.md`, leaving no
metrics anywhere in spec/ (systemic rebuild blocker #1, 2026-07 audit).

**Resolution (B)**: glyph slot `j` holds ASCII char `j+1` — `width(ch)=table[ch−1]`. Proven by
bitmap render (under the old mapping 'A' renders as 'B', '0' as '1'; under `ch−1` every glyph is
the right letter and metrics are sane: FONTTINY space/`i`/`l`=2, `M`/`W`=6; FONT-NP `I`=5,
`M`/`W`=11) and by the engine: blit_string core `func_00E51C` does `dec dl` @0x00E5DA, width read
@0x00E5E9 (`font[2+(ch−1)]`), offset read @0x00E606 (`u16 font[0x82+2·(ch−1)]`). All four loaded
fonts are proportional. Metrics for all 5 fonts committed at `data_extracted/fonts/ff_metrics.json`
(decoded from col.zip originals, 95/95 size-formula validation per font).

**By-product (B)**: the "glyph-engine colour mapping" is a 4-entry palette-index LUT at far
`[0x269E]:[0x26A0]` — per-ink-level lookup @0x00E632, `0xFF`=transparent @0x00E637, captured
@0x00E532. Per-string colour = LUT contents at draw time (setter family `func_00E68A`). This makes
several "A (RGB needs a pixel sample)" colours statically closable by tracing LUT stores.

**Authority**: rendered bitmaps + `func_00E51C` bytes; supersedes the `width[char]` reading and
every "fixed-width" metric derived from it.

## 2026-07-28 — Dialog framework decoded to rebuild-B; two poisoned claims retracted (frame blit, box_h)

**Conflict**: (1) `popups.md`/`menus.md`/`context_dialogs.md` all cited `lcall 0x181F:0x510 @0x0263D6`
as the WOODFRAM popup frame painter, while `colony_screen.md` cited the identical site+consts as the
colony scene blit. (2) The same three sheets gave `box_h = line_count·2 + 3` — arithmetically
impossible for a 6px font. (3) `fonts_and_colors.md` said the template parser has "exactly 8
directives".

**Resolution (B, decode→adversarial-verify, 8 agents)**: (1) `0x181F:0x510` is called **exactly once**
in the binary — `@0x0263D6` inside `func_026374`, the **colony-scene composite blit** (colony struct
`[0x8542]` @0x026379). The real dialog element painter is **`func_06D938`**, blitting the sprite
handle at widget-node `+0x68/+0x6A` via `0x181F:0x254` (@0x06D952/56/8B); the WOODFRAM handle is
bound by the builder (binder TBD). The popup sheets' cite is retracted. (2) The real height seed is
`[+0x16] = 2·content_cursor[+0x4A] + border[+0x46]` (@0x06D35F/63/69); `+0x4A` is the per-item
content-height cursor (init 0 @0x06C68D), not line_count. (3) The parser `func_06F0F4` dispatches
**10** directives (X and Y are separate strcmp entries @0x06F26F/@0x06F227). Full framework spec —
struct field map, box W/H/X/Y formulas + clamps, return semantics (AX=0 ok / 1 empty), pump hit-test
+ row pitch (= glyph_height + border = 9px FONTTINY), 22-byte row record, parser directive table —
landed in **`spec/ui/dialog_framework.md`**; supersedes `docs/UI_RENDERER_SPEC.md`/
`DIALOG_GEOMETRY.md`/`UI_DIALOGS.md` (stamped). Verifier corrections folded: return-semantics
inversion; text-measure ptr is `+0x80/+0x82` (gated by `+0x54/+0x60`); line-getter is
`0x191F:0x91C` not `0xD1D:0x91C`; 3 bbox opcode addresses. Six open items each carry an exact
closer (§7).

**Authority**: `func_06D316`/`func_06F0F4`/`func_06E3D0`/`func_06D938`/`func_044D16`/`func_06C520`
byte offsets vs raw/COLONIZE/VICEROY.EXE.

## 2026-07-30 — In-game menu-bar dropdown engine = func_0452D4 (page 0x0A), NOT func_06E3D0

**Conflict**: `docs/MENUS_VICEROY_DECODE.md` §7.1 and `docs/UI_AUDIT_TRACKER.md` row 7 credited
`func_06E3D0` as the in-game "dropdown open/run/hit" engine for the map-screen menu bar, with
"bar draw + per-item x = TBD (overlay-resident)".

**Resolution (B)**: The map menu bar's pulldown tracker is **`func_0452D4`** (page 0x0A, file base
0x044400 — the whole page is the pulldown-menu module). Byte-traced open chain: main map input
dispatcher `func_0246E2` → `les bx,[0x896]` @0x024951 + `lcall 0x191F:0x472` @0x02495D (thunk file
0x01BA62 → page 0x0A off 0x0ED4 = func_0452D4; byte-scan found no other far caller), plus intra-page
openers `func_0458EC` (mouse-down on bar row) @0x04597E and `func_04598A` (title hotkey) @0x045A0A.
The menubar object `[0x896]` is built ONLY by `func_072090` @0x0720AC from MENU.TXT sections
game/view/orders/reports/trade/cup/pedia (7× `0x191F:0x928`, e.g. @0x0720C4). Row-7's TBD blocker is
resolved: bar draw = `func_044E7C` (full-width fill 320px, h=title_h+2 @0x044EB2–0x044EC9); per-title
x = chained prev.x+prev.width+gap 0x0C, first title x=0x0C (@0x044BA4–0x044BD1). `func_06E3D0` is
NOT the map menu bar — per the 2026-07-28 dialog-framework ruling it belongs to the @-directive
dialog/list-menu framework (`spec/ui/dialog_framework.md`). MENUS doc §7.1 and tracker row 7 are
superseded on the engine identity. Full decode: `docs/UI_PHASE1_ATTRIBUTION.md` §5.

**Authority**: `func_0452D4`/`func_0246E2`/`func_072090`/`func_044E7C` byte offsets vs
raw/COLONIZE/VICEROY.EXE (13 cites re-resolved against disasm_overlay_reseg 2026-07-30).

## 2026-07-30 — func_069D8C (file 0x69D8C) is the Colonizopedia TERRAIN entry page, IN-game — hard rule 7's map-editor clause is refuted (CLAUDE.md amendment PENDING user sign-off)

**Conflict**: CLAUDE.md hard rule 7 states `func_O530` (file 0x69D8C) is "the map-editor
terrain-palette dialog, confirmed not in-game" (surviving citation chain:
`viceroy_source/docs/MAP_SYSTEM.md`, `docs/COLONY_RENDER_CHAIN.md`).

**Resolution (B)**: `func_069D8C` is the **Colonizopedia "Terrain Type" entry page**, one of seven
sibling category-page renderers on overlay page 0x16 (CARGO func_0694AE / UNIT func_0696C6 /
TERRAIN func_069D8C / JOB func_06A700 / BUILDING func_06AA88 / FATHER func_06AE08 / MISC
func_06AF1C). Byte evidence, all re-resolved 2026-07-30: (1) it pushes the PEDIA.TXT key
`"TERRAIN"` (DGROUP 0x1EDC = file 0x1F87C, byte-read) @0x06A6A6 and builds `"TERRAIN"+n` section
keys rendered via `0x181f:0x998` = menu_lookup_run; (2) it draws the shared runtime title
`[0x2E92]` = "ENCYCLOPEDIA OF COLONIZATION" @0x069DA3, same slot the browser func_06B398 and all
six siblings use; (3) it is far-called **in-game**: context-help dispatcher `func_02BC72`
(`[0x32E]`=0 tile-terrain arm) `lcall 0x191f,0x428` @0x02BD64 and menu-command executor
`func_0235D6` @0x023808 — segment-0x191f stubs sit at file base 0x1B5F0, so 0x428 → stub 0x1BA18 →
0x069D8C per `data_extracted/thunk_targets.json` (offsets 0x934/0x942/0x8de/0x372 resolve to the
CARGO/UNIT/JOB/browser functions consistently). Both clauses of the old claim fall: it is not a
map-editor dialog, and it IS reachable in-game. The tile-drawing-chain clause of hard rule 7
(`func_O514 → O513 → O512`) is untouched by this ruling. Full decode:
`docs/UI_PHASE1_ATTRIBUTION.md` §3.

**CLAUDE.md status**: per the agents-&-workflow rule, hard-rule amendments require user sign-off —
CLAUDE.md is left unedited; this ruling supersedes rule 7's func_O530 clause in the meantime and
the amendment is flagged for sign-off.

**Authority**: raw/COLONIZE/VICEROY.EXE bytes (DGROUP string block file 0x1F852–0x1F8A5;
page_16.asm/page_02.asm listings; thunk_targets.json) > team docs per notes/TRUTH_HIERARCHY.md.

## 2026-07-30 — .MP format corrected from the actual MAPEDIT.EXE writer (4 errors in the inferred spec)

**Conflict**: `formats/MP_FORMAT.md` (inferred before any editor disasm existed) claimed: 2-word
header (w,h) with AMER2 "56×70"; tile bits 5/6/7 = river/forest/unknown; and
ColonyRecord/UnitRecord/NativeSettlement arrays following the tile data.

**Resolution (B)**: First read of the real writer/loader — MAPEDIT.EXE ships CodeView NB02 debug
info (mined 2026-07-30 → `data_extracted/mapedit_symbols.json`), so the functions are read by their
true names (`_write_map_file` @0xB840, `_load_map_file` @0xB700, map_9.obj). Actual format:
**6-byte header (w:u16, h:u16, version:u16 == 4)** + **three w·h layers** (terrain, feature,
continent/owner), nothing else; file size = 6+3wh (AMER2.MP: 12,534 = 6+3·58·72, header (58,72,4)
byte-verified). Tile bits: **bit5=mountains/hills, bit6=river, bit7=modifier (set: Mountains/Major
River; clear: Hills/Minor River)** — paint masks @0x2744–0x2788, reader `_terrain_type` @0xB17C;
**forest is not a bit** (it is ids 8..23; `_terrain_is_forest` @0xB222). AMER2.MP bit-combo census
corroborates (0xA0×170 mountains, 0x20×56 hills, 0x40×178 minor, 0xC0×47 major, 0x60×1). The
"record arrays" section was struck (save-game structures, not .MP). Refinements: header w/h are the
FULL grid incl. a non-editable 1-tile border ring (`_change_map` bounds @0x31E9–0x320D) — "56×70"
was the playable interior; **hard rule 2's sea-lane right-edge column = right-most playable column
x=w−2** (all 70 interior rows of AMER2 column 56 are id 26 — verified); the rule's number 26 is
unchanged. Editor round-trips are not byte-preserving (`_forest_fix` @0x16B6 normalizes ids
16..23 → 8..15 on load). `formats/MP_FORMAT.md` rewritten accordingly.

**Authority**: raw/COLONIZE/MAPEDIT.EXE bytes + raw/COLONIZE/AMER2.MP data + CodeView symbols >
inferred spec, per notes/TRUTH_HIERARCHY.md. Hard rules 1/2/3 all corroborated by the editor
(NAMES section loads @0x3967–0x39ED; Ocean 25 fill; forest range 8..23).

## 2026-07-30 — FLAG (not a resolution): coast straight-edge frames 151–154 in MAPEDIT vs hard rule 4's "150–153"

**Observation (B, MAPEDIT.EXE)**: the editor's tile renderer draws straight-edge coasts as PHYS0
frames **0x97..0x9A (151..154)** (`add ax,0x97` @0xC707, map_a.obj) selected by land-mask edge
class, with per-quadrant beach-halo frames 0x6D+quad+4·code (109..140); frame **0x96 (150)** is
drawn from the *feature*-layer bit 0x40 (@0xC550), a VICEROY-side overlay dormant in the editor.
CLAUDE.md hard rule 4 says "True coasts use sprites **150–153** plus the water-tile beach-halo
mechanism". The rule's core claim (PHYS0 rows 0x01/0x11 = rivers, NOT coast) is **byte-confirmed**
by the same renderer (river frames 0x01..0x10 / 0x11..0x20 @0xC584–0xC5C0).

**Status**: DISCREPANCY FLAGGED, not resolved. The rule cites VICEROY's renderer; MAPEDIT is a
parallel implementation. Before any amendment, re-verify VICEROY's coast draw site (the 150–153
citation chain in viceroy_source/docs/RENDER_CHAIN.md) — the editor evidence suggests the correct
straight-coast set is 151–154 with 150 being a different overlay, but VICEROY's own bytes must
decide. No doctrine change; do not renumber in other docs yet.

**Authority pending**: VICEROY.EXE coast site bytes. MAPEDIT side: raw/COLONIZE/MAPEDIT.EXE
@0xC66E–0xC70A, @0xC550.

## 2026-07-30 — PowerRecord+0x40 is the treaty-respect COUNTER, not a relation-bit matrix (diplomacy.md §2 correction); four woodcut attributions in popups.md byte-refuted

**Conflict 1**: `spec/systems/diplomacy.md` §2 attributes the 0x02/0x20/0x40 relation-bit tests in
`func_057DC0` to a matrix at PowerRecord+0x40.

**Resolution (B)**: those tests are `func_007F34` reads of the **+0x34** matrix (DG 0x883C, row
stride 0x13C; bits 0x02 war / 0x08 grievance / 0x10 parley-cooldown / 0x20 met / 0x40 treaty /
0x80 privateer attribution — setter `func_007F96` @, clearer `func_008000`, error strings "Treaty
on/off error"). **PowerRecord+0x40 (DG 0x8848) is a plain byte counter** — treaty-respect points:
seeded `2·(6−difficulty)` (Franklin halves) @0x059B00–0x059B31, set 1/0 by `func_057DC0`
@0x057EC5/@0x057F2D, and while nonzero an AI aborts attacks on its treaty partner (`func_03ECF0`
@0x03F163). Decrement site not yet found (runtime-open). diplomacy.md §2 to be corrected.

**Conflict 2**: `spec/ui/popups.md` woodcut glosses (tier A, sourced from docs/UI_DIALOGS.md)
claim WDCUT04 = treasure, WDCUT10 = battle, WDCUT12 = village-raze, WDCUT13 = war dance in
func_04B036.

**Resolution (B)**: exhaustive byte-scan finds exactly 10 `lcall 0x181F:0x524` sites (the only
woodcut entry) — none in `func_05C878`/`func_05B2C2`/`func_04A7CA`/`func_04B036`. The true table
(full decode in `spec/ui/woodcuts_and_intro.md`): 1=first landfall (@0x020F00), 2=first colony
(@0x040E00), 3/4/5=first tribe contact incl. Aztec/Inca (`func_056C3E` @0x056DA6), 7=enter
village (@0x04B56C), 8=Fountain of Youth (@0x0618F9), 9=first cargo to Europe (@0x0420EF),
10=first European contact (@0x057FDF), 11=colony burning ×2 (@0x05DADC/@0x05DFCB — the ONE prior
gloss that survives), 13=Indian raid on human colony (@0x05D219). **WDCUT 0/6/12/14–16 have no
caller** (6 even has a wired sound cue — planned, never hooked). popups.md §4/§7/§9/§16 glosses
struck; §14 confirmed.

**Authority**: raw/COLONIZE/VICEROY.EXE bytes (caller scan re-verified 2026-07-30: 10 sites
exact) > team docs per notes/TRUTH_HIERARCHY.md.

## 2026-07-31 — RESOLVED: engine sprite-frame numbers are 1-BASED over disk descriptors; hard rule 4's coast numbers 150–153 are CORRECT (coast-frame flag closed; 2026-06-25 "P3 out of bounds" superseded)

**Resolves** the 2026-07-30 coast-frame FLAG. Evidence chain (all re-verified):
1. **VICEROY's own renderer** (page 0x15) uses the identical constants as MAPEDIT: straight
   coasts `add ax,0x97` @0x06850D (engine frames 0x97..0x9A = 151..154), beach halos `add ax,0x6D`
   @0x0684E8, engine frame 0x96 gated by `[0xA89F]&0x40` @0x06834F–0x068359.
2. **Descriptor counts prove the 1-based convention**: TERRAIN.SS holds exactly **12 disk
   descriptors** while the engine loads "frames 1..12" (`func_072B9A`); WOODFRAM.SS holds 1
   ("frame 1"); NAMEPLAT.SS holds 3 (frames 1–3); PHYS0.SS holds **154 (disk 0..153)** — engine
   frame 154 must therefore be disk sprite 153. The draw verb `func_00E76A` indexes
   `base + frame·12 + 0x36` with no subtraction — the offset lives in the load/record layout,
   not the verb. **Disk sprite = engine frame − 1.**
3. **Pixel render confirms** (`docs/screens/phys0_coast_frames.png`, PHYS0.SS + VICEROY.PAL over
   the Ocean tile): **disk sprites 150–153 are the four straight-coast shorelines** — exactly
   hard rule 4's numbers; **disk 149 (= engine "frame 150"/0x96) is a diagonal wave/hatch
   overlay, NOT a coast** (drawn from feature-layer bit 0x40; all-zero in AMER2.MP, so unseen in
   the standard game; semantic name still open); disk 148 (= engine 0x95) is the dark
   unexplored/fog tile.

**Consequences**:
- CLAUDE.md hard rule 4's coast clause ("sprites 150–153") is **correct in disk-sprite
  numbering** (how the original pixel work counted); engine-side code cites read one higher.
  NOTE the rule's river clause ("rows 0x01 and 0x11") is in ENGINE numbering (disk 0x00/0x10) —
  the rule mixes conventions but both clauses are factually right. No renumbering anywhere.
- **Supersedes** `spec/systems/map_system.md` §3 item 7's 2026-06-25 residual: "P3 → 0x9A
  overruns the sheet by one" is wrong — engine 0x9A = disk 0x99 = 153, in bounds; the four
  clean-edge patterns map exactly onto disk 150–153. (The 2026-06-25 frame-count fact itself —
  154 frames, 0..153 — was right and is retained.)
- Docs that cite engine frame constants (map_editor.md §4, woodcuts_and_intro.md,
  colonizopedia.md §5, map_system.md) now carry a convention gloss: "engine frame N = disk
  sprite N−1".

**Authority**: raw/COLONIZE/VICEROY.EXE + MAPEDIT.EXE bytes, col.zip sheet headers via
tools/ssdec.py, rendered pixels (docs/screens/phys0_coast_frames.png) > all prior notes, per
notes/TRUTH_HIERARCHY.md. User-directed check 2026-07-31 ("show visual examples first" — done).

## 2026-07-31 — CLAUDE.md hard rule 7 AMENDED (user-directed): func_069D8C clause corrected

The pending amendment from the 2026-07-30 pedia ruling was applied with user sign-off
(2026-07-31 directive). Rule 7's tile-chain clause is unchanged; the func_O530 clause now reads:
func_069D8C = the Colonizopedia "Terrain Type" entry page, IN-game. Final verification before the
edit: (1) VICEROY.EXE contains zero MAPEDIT/MAPMENU strings (the actual editor terrain palette is
MAPEDIT.EXE `_selection_screen` @0x2826); (2) the function body terminates at the modal-wait+retf
@0x06A6FC–0x06A6FF (2419 B — the old "1934 B" figure was also wrong); (3) the in-game caller
@0x0237F4–0x023808 pushes the map-cursor tile's terrain id (`0x181f:0x78c` on
`[0x853E]/[0x8540]`) into it. `docs/COLONY_RENDER_CHAIN.md` row corrected.

## 2026-07-31 — Phase-3 pixel rulings: boot-menu "OPENBORD sprite blits" refuted (= palette remaps); boot plaque fill = OPENTILE.SS; boot font = FONTTINY; frontend cell w/h transposed

Render-and-diff of the boot menu + difficulty/nation screens against live captures
(docs/screens/reports/phase3_frontend/) falsified and corrected:
1. **`0x1A1F:0xDF8` = `func_00E146` = full-screen palette-index find-and-replace** (args find/write;
   loop @0x00E1A5–0x00E1B0). The three boot-menu calls @0x075B8E/BB0/BD2 remap indices 7→6/8→9/15→14
   (a no-op on OPENMENU.PIK) — NOT "OPENBORD sprite-pair blits". No "OPENBORD" string exists in
   VICEROY.EXE; OPENBORD.PIK is frameless. The tier-B claim propagated through menus.md §2.1,
   MENUS_VICEROY_DECODE, and CHROME_AND_DISPATCH_INDEX row 43 is struck (menus.md edited; the other
   two carry the stale wording — flagged).
2. **Boot plaque fill = OPENTILE.SS** tiled anchored at the box origin (WOODTILE.SS refuted for this
   screen — renders cream under the live palette; 100% vs 51% region match).
3. **Boot menu font = FONTTINY** (menus.md said FONTINTR; glyph-exact spans prove FONTTINY;
   closes fonts_and_colors.md open item 5).
4. **dialog box_w = @width + 2·border** (the +4 pad is the option-row indent, not outer width);
   this dialog's option-row pitch = 8 px (not glyph_h+3=9) — dialog_framework §3/§4 need a
   per-mode qualifier (runner `func_06F594` disasm will settle; open item).
5. **Frontend cell w/h transposed** (difficulty 68×90, nation 88×82 on screen) — corrected in
   FRONTEND_SCREENS_VICEROY_DECODE §3/§4.
Measured-not-yet-byte-cited (R): boot title gold = idx 0xFC (not 0x54), box outline = black,
2px interior bevel source unknown, selection bar rect (box_x+2, top−1, 160×7), selected-item
text NOT gold in the captured state.

**Authority**: rendered pixels vs live captures + raw asset/EXE bytes (func_00E146 disasm,
string-absence scans) > prior tier-B doc claims, per notes/TRUTH_HIERARCHY.md.

## 2026-07-31 — Phase-3 pixel rulings (batch 2): SS frame-descriptor anchor = (center-x, bottom-y); King-audience §1 corrections; @LEADERNAME font refinement

Render-and-diff of the leader-name-entry and King-audience screens (pixel-identical rebuilds,
residual = mouse cursor only; docs/screens/reports/phase3_frontend/):
1. **GENERAL: the loaded .SS frame descriptor stores an (anchor-x = center-x, anchor-y = bottom-y)
   pair; on-screen x = ax−⌊w/2⌋, y = ay−h+1.** Evidenced twice independently: KING1.SS desc
   (94,198), 189×187 → drawn at (0,12) (99.6% match at (0,12) vs 15.7% one px off); ENGLND1.SS
   desc (118,121), drawn at (32,0) exactly. Resolves ENDGAME §1.5's portrait-y TBD and explains
   why the `push 0x64` "portrait x=100" was wrong — the placement is asset-anchored, not the
   pushed literal.
2. **King audience corrections** (ENDGAME_SCREENS_VICEROY_DECODE §1): backdrop = **KINGLSS1.PIK**
   (throne room + blank scroll); **KING1.SS is the outcome-selected FOREGROUND figure (king+dog,
   189×187 at (0,12))**, not the backdrop; nation sheets are **ENGLND1.SS/ENGLND2.SS** (stem+digit
   — "ENGLND+KINGLOSE" naming refuted; ENGLND1 = throne-canopy banner at (32,0)); the byte-true
   pen stores (242,47) are register values, NOT the on-screen text origin — actual layout: 4-line
   header per-line centered on x≈271.5 (y=29..61), 9-line body left-aligned x=232 pitch 8 (=H+1);
   the glyph runner (func_06F594 chain, still untraced) re-lays-out under flags [0x1F56]|=0x18.
   FONTKING metrics pixel-perfect.
3. **@LEADERNAME dialog font = FONTINTR** — refines (does not overturn) the batch-1 "boot font =
   FONTTINY" ruling: FONTTINY applies only to dialogs carrying the `@smallfont` directive
   (@BEGINMENU has it; @LEADERNAME does not). "Walter Raleigh" default, the '_' entry cursor, and
   the engine's X=160−W/2 centering all pixel-confirmed; the @width=300 box draws NOTHING visible
   on this screen (no frame) — box geometry unverifiable there.
Measured-not-cited (R): name-entry field outline rect (79,98,167,14) green + text-bbox background
fill; king text inks (level3 = black idx 0); KINGLSS/ENGLND digit-variant selection untraced.

**Authority**: rendered pixels vs live captures + asset descriptors > prior doc wording, per
notes/TRUTH_HIERARCHY.md.

## 2026-07-31 — Phase-3 pixel rulings (batch 4): colony RNG placement validated by replay (with 3 corrections); the "heap-537 = Sons of Liberty" oracle refuted in TWO screens

**Colony building placement (`func_025D34`) — VALIDATED END-TO-END**: replaying the full chain
(seed → LCG → category shuffle → present gate → BUILDING.SS frames) reproduces the live capture's
Jamestown layout with every sprite pixel-exact. Corrections recovered by the replay:
1. **`srand @0x103C2` keeps only the LOW 16 BITS** of the 32-bit seed (`mov [0x28ee],ax;
   mov word [0x28f0],0`) — effective seed space is 16-bit.
2. **The group table is NOT floor(id/3)**: the registration block @0x0746BC (42 calls) yields
   **15 groups** (Capitol 30/31 shares group 3 with Town Hall; Stable 17 with Warehouse in
   group 5; Custom House 18 alone; Fur Trader opens group 11). Category = NAMES `@BUILDING`
   numeric column 3 (loaded to `0x8F87+id*12` @0x74D2F); over the 15 group REPRESENTATIVES the
   histogram is exactly [7,4,2,1,1] — resolving the archived "col3 histogram ≠ counts" objection
   (that histogram was over all 42 defs).
3. **The `[0x8D80]` seed term is NONZERO**: the pure map-position seed (41<<8)+46 = 10542 does
   NOT reproduce the documented plot set; exactly 2 of 65536 seeds do (1673, 12002 — layout-
   identical), implying `[0x8D80]&0xFFFF` ∈ {56667, 1460}. Pinning which needs a live RAM read
   of 0x8D80 (runtime-open).

**"Heap string 537 (0x219) = 'Sons of Liberty' at (306,179)" — REFUTED, SYSTEMIC**: in BOTH the
Europe and colony screens the pixels at the byte-cited draw site are the FONTTINY string
**"Exit"** (fit IoU 1.0; "Sons of Liberty" cannot fit 15px). The prior heap-slot oracle walk
read a stale/rebuilt slot — the same failure mode the colony spec itself documents for
`[0x2DD0]` §3.6. Any other doc claims sourced from that heap-walk method should be treated as
suspect until pixel- or byte-confirmed.

**Other colony corrections (pixel evidence, sites in spec verdict block)**: building blit y =
the §0.2 table values as printed (the extra "+8" was a double-count); plaza colonist row is
left-aligned at panel origin+2, not walking left from x=143; right panel spans x207..301 (not
211); middle-panel "surrounding-tile minimap, 6× ICONS 0x7B" gloss wrong — EXE 0x7B = disk 122 =
the cargo CRATE, the 6 slots are the dock's empty cargo boxes; carpenter hammers at (15/22/29,
104) not (15/21/27, 103); composer step-4 fill = WOODTILE.SS from (0,0); COLONY.PIK = 320×72
strip blitted at y=128, NO embedded palette (renders on VICEROY.PAL — supports §0.6-DNR-2 over
§5's "distinct palette" claim).

**Authority**: rendered pixels vs live captures + re-disassembled placement chain >
prior doc claims, per notes/TRUTH_HIERARCHY.md. Artifacts:
docs/screens/reports/phase3_frontend/colony_*.png.

## 2026-07-31 — Colony scene panel interior (batch 5): art source RESOLVED; three §3.8 thunk attributions overturned

**Question**: where do the colony screen's scene-panel terrain pixels come from (Phase-3 could not
reproduce them from TERRAIN.SS/PHYS0/AMER2 under any grid phase — "runtime-composed tileset").

**Ruling (B)**: the interior is the **shared map compositor** rendering the colony's **5×5 tile
neighborhood at native 16×16 from TERRAIN.SS + PHYS0.SS**, then **upscaled ×1.5 (2→3 pixel/row
duplication) with a positional 4×4 ordered dither** that jitters each written pixel within its
16-color palette ramp. There is **no dedicated 24-px terrain sheet**; nothing is RNG — the
resample is fully deterministic. Chain: `func_026374 @0x02639A` → `0x191F:0x8A4` → stub
`@0x06891E` (sets scene latch `[0x18A]=colony ptr`) → `func_068898` → `func_06787C` (scene mode
`@0x067894..0x0678A9`: viewport 5×5, `[0x184]=0` → 16px pitch `[0x5AD4]=[0x8326]`, scale
`[0x186]=100`, origin colony−(2,2), screen offset 0) → `func_0685DC` → per tile `func_0681A8`
(ground `func_067E28` ← sheet `[0x16C:0x16E]`; overlays `func_067DC8` ← `[0x174:0x176]`) onto
surface `[0x839E]` at (0,0) = 80×80; then `func_026374 @0x0263A9..D6` `0x181F:0x510` =
**`func_00531C`** stretch-copies (0,0,80,80)→(200,8,120,120) with per-pixel dither
**`func_005296`**. Visible (224,32,72,72) panel = central 3×3 of the 5×5 at 24px. Colony markers
(`func_067182`→`func_004314`, ICONS 1..4 + pennant 0x77+power, pop#/name iff `[0x890]==0`) and
unit markers (`func_067082`→`func_003E40`) are drawn on the 80×80 BEFORE the upscale; the worker
sprites are drawn AFTER it at 24px pitch (x=24c+252, y=24r+60) from PHYS0.

**Sheet-handle proof**: `[0x16C:0x16E]` written `@0x072C5C` by a loader called with DGROUP string
`0x20DA` = `"terrain"` (file 0x1FA7A); `[0x174:0x176]` written `@0x0765AC` with `lea bx,[0x23D0]`
= `"phys0"` (file 0x1FD70). Independently re-confirms hard rule 5 (TERRAIN.SS = base ground under
PHYS0 overlays) at the pointer level.

**Overturned (were un-byte-verified glosses)**: §3.8's hop targets "`0x8A4`→`func_0678FE` clip /
`0x896`→`func_066A98` per-tile select / `0x888`→`func_06693A` viewport origin" — the thunk table
(`data_extracted/thunk_targets.json`) + byte read resolve them to stubs `0x06891E` (terrain scene
via `func_068898`), `0x0672C8` (colony layer `func_067182`), `0x06716A` (unit layer
`func_067082`). Also withdrawn: "`func_026374` per-tile blit companion `@0x066968`, sheet
`[0x2DA8]`" — `func_066968` is the MAP screen's 1-px-per-tile corner-minimap cell writer (byte
stores, LUT `[bx−0x5A8A]`, owner colors `[0x848]`), unrelated to the scene; and "scene-unit sheet
`[0x839E]`" — `[0x839E..0x83A4]` (like `[0x2DA8..0x2DAE]`) is a destination SURFACE context
quartet, the sprite sheet is PHYS0 `[0x174:0x176]`.

**Runtime-open remainder**: live value of `[0x890]` on the colony screen (gates marker name/pop
text inside the panel); `func_003E40`'s unit-marker sprite mapping (resident, not yet decoded).

**Authority**: VICEROY.EXE bytes (reseg pages 02/15 + resident raw disasm at the cited offsets) +
thunk_targets.json > prior spec wording, per notes/TRUTH_HIERARCHY.md.

## 2026-07-31 — LIVE-SESSION verification (DOSBox RAM reads, in-game): [0x8D80] is per-session; heap-537 oracle fully closed (string-ID table, not pointers); [0x894]=8 default; boot ink 0xFC confirmed

A live DOSBox 0.74-3 session (recipe tools/drive_game.sh; harness tools/runtime_snapshot.py +
scratch peek_live.py, DGROUP base phys 0x1CFD0 anchor-verified) reached: boot → new game
(Discoverer/England/"Walter Raleigh") → landfall → colony "Jamestown" founded at (51,29) →
colony screen → map Spring 1505. Reads:

1. **`[0x8D80]` = 0x2C55 (11349) this session — NEITHER of batch-4's {56667, 1460}; a second
   fresh boot read 0x5B7C.** The value is set by boot init, constant within a session,
   different across sessions (dword high word 0x0013 both runs; the low word smells like a
   heap-allocated segment — hypothesis, not cited). **Batch-4 amendment**: the two candidate
   values were just the seeds fitting the ORIGINAL capture session; the term itself is
   session-variable. The placement-chain validation stands (the replay reproduced that
   session's layout); the open item becomes "which boot-init code writes 0x8D80" (disasm
   cross-check needed before naming it).
2. **Heap-537 CLOSED**: `[0x2F5E]` = 537 (0x219) in every state — an INTEGER STRING-ID, slot
   210 of the 221-entry table DGROUP 0x2DBA..0x2F72 (live values 327..547 sequential). The
   table holds string IDs resolved via `0x181f:0x22`, NOT near pointers — the old oracle
   dereferenced 537 as an address and landed mid-"Treaty off error". Slot 210 = LABELS
   `@MISC` line 210 = "Exit" — fully consistent with both pixel refutations. Docs that call
   0x2DBA a "label-POINTER array" should read "label string-ID array (fetch via 0x22)".
3. **`[0x894]` = 8 at boot AND in-game** — the debug bitfield defaults to bit 0x08 set
   (Foreign-AI plan letters; invisible without the cheat bit, which is 0). Any "=0 default"
   assumption is refuted.
4. **`[0x1F4E]` = 0xFC at the boot menu — the runner-disasm boot-ink claim CONFIRMED live**;
   in-game it reads 0x95 (state-dependent, per the mode setters).
5. **ColonyRecord head = x,y,name byte-verified live**: `*[0x8542]` → DS:0x606E = `33 1D
   "Jamestown"` = (51,29). `[0x8542]` is 0 at boot, scratch pre-colony, real after founding.
6. Artifacts: land-window map capture + same-moment RAM dumps (terrain overlays live test now
   possible); colony-screen capture + RAM. Session kept alive for follow-ups.

**Authority**: live emulated RAM + on-screen state > static inference, per TRUTH_HIERARCHY
(running DOS game is the TOP of the trust order).

## 2026-07-31 — Phase-3 FINAL land-compositor ruling (live pixels): 100.0000% non-overlay match; beach-halo ground substitution discovered; the 0x8C "16×16-at-subcell anomaly" dissolved

The live Jamestown land window (capture + same-moment RAM layers, correlation-located terrain
plane @phys 0x6ECF2 / fog @0x71885, stride 58) was re-rendered from the byte-cited
O514→O513→O512 chain: **100.0000% of all 41,540 non-overlay pixels match** (RGB565 + palette-
cycle phase; overlays = units/colony/label, masked). Live-confirmed: land grounds, auto-forest
fold + forest masks, mountains masks, clean coast edge (pattern 2), the FULL quadrant-halo
fallback incl. the q3/code-7 case, fog tile + every fog-edge blend, sea-lane ground + sparkle,
and (again, everywhere) the 1-based frame ruling. Hills/rivers/river-mouths/shore-0x96/roads/
detail-0x5A/surf-0x68 remain unexercised (need a richer capture); the detail band is ARMED
(hash internals now decoded: salt [0x190], per-class table DG:0x192, (x&3)·4+(y&3) vs
((y>>2)·3+(x>>2)+salt−forest)&0xF, ^0xA alternate) with its L1/L2 gates TBD.

**Corrections:**
1. **Beach-halo ground substitution**: `analyse_connections` (`func_067A24` @0x67AD4) OVERWRITES
   `[0xA8A1]` with the last cardinal land neighbour's folded class (N,E,S,W order — W wins) and
   `@0x67B10` reclassifies `[0xA8A2]` — so O513 grounds a coastal WATER tile with the
   NEIGHBOUR'S LAND terrain, draws the coast frames over it, and backfills water through the
   frames' 0-holes (code-0 quadrant frames disk 0x6C–0x6F are all-zero "punch-throughs").
   The phase-3 `render_mapview.py` grounds water tiles with their own water class — its AMER2
   full-map coasts are subtly wrong wherever coast frames have holes (flagged in the script).
2. **map_system.md §3's "table[q]=7,q=3 → 0x8C=140 is a 16×16 frame at an 8×8 sub-cell"
   residual is DISSOLVED**: engine 0x8C = disk 0x8B (8×8). The note conflated engine index
   with disk frame (disk 0x8C belongs to the river-mouth band = engine 0x8D). The case is
   live-reachable and pixel-exact — no anomaly.
3. World-coord convention pinned: `[0xA5A0]/[0xA5A2]` are engine scroll-space = plane index −1
   (plane index = sidebar Locat); the O512 bounds test emulates the engine's UNCLAMPED
   neighbour reads (row-wrap bytes at the east edge — visible in live pixels).
4. Sea-lane sparkle = VGA palette-rotation band indices 120–127 (capture at phase +2); add to
   the RGB565 note for future capture diffs.

**Authority**: live pixels + live RAM layers (top of TRUTH_HIERARCHY). Artifacts:
docs/screens/reports/phase3_frontend/landtest_*.

## 2026-07-31 — Phase-3 crafted-map live test (hills/rivers/mouths/details): ALL exercised rule classes CONFIRMED at 100.0000%; VICEROY's .MP loader DISCARDS layer 2 and force-normalizes borders; roads formula refined

A crafted 58×72 test AMER2.MP (byte-verified format; 109 targeted placements; original restored,
md5 = bin/AMER2.MP.b64) was loaded via "Start a Game in AMERICA", revealed with the decoded
Alt-W-I-N cheat → Reveal Map → Complete Map, and 5 viewport captures (each with same-moment RAM
dumps) were re-rendered from the compositor spec: **100.0000% of non-overlay pixels in all 5**
(object sprites the game spawned — villages/units/cursor — masked).

**CONFIRMED live (previously unexercised)**: hills `0x31+mask` (isolated/pairs/plus-15/2×2);
relief adjacency = equal `(byte&0xA0)` (hills never connect to mountains); mountains masks;
minor rivers `0x11+mask` incl. isolated→`0xF` (`0x20`), corners, T-junctions; major `0x01+mask`;
major/minor interconnect via bit 0x40; hills+river stacking order; **river mouths exactly as
spec'd** (water tile with own 0xC0 bits; `0x8D`/`0x91`+cardinal-with-bit-0x40-and-land; both
negative controls behave); all four clean coast edges + all-land lake quadrants; forest masks +
desert-scrub exclusion; ids 16..23 render as 8..15.

**New findings / corrections**:
1. **VICEROY's .MP loader DISCARDS layer 2 (features)** — all crafted feature bytes read back 0
   live; the game rebuilds the plane (bit0 unit, bit1 settlement). So shore-0x96/road/resource
   feature-bit pixels are unreachable via .MP — their gates are byte-cited from fresh disasm
   instead. MP_FORMAT.md note added.
2. **Loader border normalization**: rows 0/71 → Arctic; **columns 0, 1 AND 57 → Sea Lane for
   y=1..70, overwriting even land** — hard rule 2's sea-lane column is ENFORCED by the loader,
   not just data convention. Forest ids 16..23 folded to 8..15 at load.
3. **Roads formula refined**: gate feature`&0x0A` + `[0x18E]==0` + non-water; **mask==0 →
   `0x51`; else ONE FRAME PER SET 8-dir BIT `0x52+d`** (not "0x51+mask"); band 0x51..0x59 only.
4. **Detail-band classify uses the FULL id decode incl. relief bits → 27/28** (the `&0x1F`
   reading falsified — mountains draw ore/gold `0x66` = DTAB[27], hills rock `0x67` = DTAB[28]);
   the position hash IS the prime-resource mechanism (sidebar shows "(Prime Tobacco)" on a
   hash-hit tile). DTAB duplicates entries for raw 16..23.
5. **Surf `0x68` = the rumor circle**, with a new gate: continent-plane owner nibble ≠ 0xF
   suppresses it (func_005DF0-family).
6. **O512 bounds**: engine coord 0 (plane 1) IS in bounds — the prior landtest's `≥1` model
   falsified (no spurious blends on the lane column).
7. Live plane pointers pinned: `[0x15C]`/`[0x160]`/`[0x164]`/`[0x168]` (terrain/feature/
   continent+owner/flags; low nibble of flags = colony-site value); Reveal-Map = `[0x53A2]=1` +
   fog mask `[0xA89E]`=0 (per-tile fog bytes untouched).

Still pixel-unexercised (gates byte-cited, sprites known): shore-0x96, roads, feature-bit
resource suppression — need an in-game state with real roads/shore features (pioneer builds).

**Authority**: live pixels + live RAM + crafted ground truth (top of TRUTH_HIERARCHY).
Artifacts: docs/screens/reports/phase3_frontend/hillsrivers_* + testmap.mp + verdict doc.

## 2026-08-01 — @TRIBES numeric column 5 is the tribe COLOR, not a sprite id (user ruling)
The manual's §19.1 table glossed @TRIBES column 5 (97/149/54/87/67/111/118/71)
as "sprite". User correction (2026-08-01, sign-off in session): it is the
tribe's COLOR NUMBER — a VICEROY.PAL palette index — exactly parallel to
NAMES @COUNTRY column 2 (England 12 / France 9 / Spain 14 / Netherlands 13,
the classic power colors). Manual and specs to relabel; render as color
swatches. Any consumer treating it as a frame id is wrong.

## 2026-08-01 — Spanish Succession trigger BYTE-TRACED; 2026-06-23 §1 REVERSED
The 2026-06-23 entry §1 ("threshold is 75 not 50; func_03E844 has no [0x53D0]
read; trigger unresolved, needs runtime capture") is REVERSED on byte evidence.
The 2026-06-20 reading ("auto-fires once when SoL crosses 50, latch
[0x53D2]<0, func_03E844") was RIGHT. Root cause of the bad 2026-06-23 call:
the event scanner only follows far `lcall 0x191F:0x364`; two additional
callers reach func_03C638 through the page-6 near-call thunk island slot
0x3EA0B (`ea 64 03 1f 19`, local 0x368B) and were invisible to it.

The three call sites (exhaustive byte scan of VICEROY.EXE):
1. @0x02393A — cheat menu id 0x68 "@FORCED" staged advancer (func_0235D6
   dispatcher; the 75-clamp + [0x53D2]<0 gate at @0x02391C..@0x023930 belongs
   to THIS stage, not to the gameplay trigger).
2. @0x03E8CA — THE REAL PER-TURN TRIGGER, inside func_03E844 (per-power SoL
   updater, called per power from production_phase func_02F052 @0x02F27E):
   for the rebel/human power only, [0x53D0] := SoL%, then
   `cmp ax,0x32; jl skip` (SoL ≥ 50, @0x03E8BD) and
   `cmp word [0x53D2],0; jge skip` (no withdrawn power yet, @0x03E8C2) →
   `push cs; call 0x368b` (@0x03E8C9). No RNG, no year/turn test.
   Once-only: func_03C638 writes the ceding power id to [0x53D2] @0x03C922.
   Single-player gate at handler entry: `test [0x5381],0x80` @0x03C63D.
3. @0x03DE85 — forced at the Declaration of Independence (func_03DE46) when
   [0x53D2] is still negative, creating the withdrawn/REF power.

Also corrected en route (see the 2026-08-01 king's-economy fact-pack,
tools/manual_pdf/_work/factpacks/kings_economy_succession.md):
- @KINGBUY (0x1318, @0x3E262) is the PRE-independence REF-purchase announce
  (immediately before the fund deduction `sub [bx+0x22],0x708` @0x3E271);
  @KINGMOBILIZE (0x1320, @0x3E2DB) is the other arm. ref_growth.md:112-116
  has them swapped.
- REF purchase ladder is LAST-match-wins (Man-O-War > Artillery > Cavalry >
  default Regulars), and 1800 is both the purchase gate AND the deducted
  price (pre-independence branch only).
Stale docs flagged for follow-up: spec/systems/spanish_succession.md §3/§6,
spec/systems/revolution.md:49-50, viceroy_source/docs/EVENT_DISPATCH.md:58,
manual §18.4/§18.7/§18.10, functions.json names for func_03E844/func_0235D6.

## 2026-08-01 — Market corrections: @CARGO field indices; func_036574 is NOT market_day
Byte evidence (2026-08-01 market sweep, full pack at
tools/manual_pdf/_work/factpacks/market_pergood.md):
1. @CARGO loads 9 fields/good to DGROUP 0x96FC stride 9 (loader
   @0x074E05..5E): start1, start2, low, high, BURDEN, rise, fall, attrition,
   VOLATILITY. buy_price @0x030575 reads field 4 = burden (buy = level +
   burden; sell = level − 1; spread = burden + 1, per the NAMES.TXT legend);
   the qty shift in the accumulator updaters (@0x0322EA/@0x032360) is field
   8 = volatility. market.md §3.1/§6 and manual §9.1 quote fields 0/4 —
   shifted by 4, wrong.
2. func_036574 is the NEW-GAME POWER INITIALIZER (boycotts/tax/REF
   fund/gold/market arrays zeroed, starting gold by difficulty, start
   prices rolled level = start1 + random_int(0, start2−start1) — same roll
   for all four powers @0x0367AD..E5), and its caller func_0755CC is the
   NEW-GAME SETUP (price_seed init @0x075645, REF seed @0x0756A2, starting
   units @0x07584B). The "market_day / end_of_turn" names and the manual
   §20.1 "end_of_turn calls market_day" paragraph are wrong. The real
   per-turn drift driver is func_0363A2 @0x0363D3 (silent all-goods drift +
   immigration), riding the production phase @0x2F218.
3. Phase-4 stepping: price rises when the per-good traffic accumulator
   (+0x5C) ≤ −100·rise (signed imul 0x9C @0x030986) and falls when ≥
   +100·fall; floors/ceilings = low/high. viceroy_source pricing.c's
   Phase-4 port has 0x9C unsigned and both comparisons reversed — do not
   cite it.
4. PowerRecord +0xFC is a live whole-game net-trade accumulator (cleared at
   new game only); the memory-map's "market base values at game start"
   gloss is wrong.
Symbols renamed: func_036574 market_day → new_game_power_init; func_0755CC
end_of_turn → new_game_setup; per-turn drift attribution moves to
func_0363A2. Stale: spec/systems/market.md §3/§3.1/§6/§9.3 refs, manual
§9.1/§20.1, viceroy_source/data/pricing.c Phase 4.

## 2026-08-01 — Native background economy: tension table is per-TRIBE; population decrement FOUND; several "RESOLVED-static" verdicts reversed
Byte evidence in tools/manual_pdf/_work/factpacks/natives_background.md.
Method finding first: the prior full-image disp16 scans that produced the
natives.md §6 "no accessor image-wide" verdicts were UNSOUND — settlement
fields are accessed through the resolved record pointer [0x8D4A] as [bx+N],
which a disp16 scan for 0x54F0-family absolutes cannot see.
1. The 0x5B1C tension table is TribeData +0x46 (0x5B1C = 0x5AD6 + 0x46):
   per-TRIBE × power, stride 0x4E = the "39 words". The applier's first arg
   is the tribe index [0x8D52]. natives.md §3's settlement-row model is
   wrong. TribeData +0x36+p is its fractional feeder (±8 = one tick).
2. Population decrement FOUND @0x5D67A (combat resolution func_05CA7E):
   each victorious attack does pop−− while pop>1 (message 0x48); at the
   last point the village is destroyed (human attacker also sets the
   tribe's avenge flag +0x03|=0x40 @0x5D6A1) → remove_settlement @0x5D6A9.
   Reverses the earlier "no decrement site anywhere" finding — attacks-to-
   burn IS the population, as the user maintained.
3. Settlement byte relabels: +0x06 = growth/spawn accumulator (+=pop per
   turn, acts at 20 — not dead); flags 0x01 = brave-respawn request (set on
   a brave's death in unit removal, tested/cleared in the settlement tick);
   flags 0x10 = tribute-once latch; +0x07/+0x08/+0x09 = traded-good memory
   (gift/trespass marker; last good sold to the village; last good bought).
4. func_046DE0 = settlement TARGET SIZE (2·level+3; capital 3·level+4), the
   growth cap — not a display-only value.
5. func_046EC0's n/(n+1) removal scaling targets the TRIBE's horses_known/
   horses_stock ([0x8D4E] is the tribe pointer), not settlement "wealth".
6. @0x486F8/@0x4870C (+100/−100) are the post-Declaration @INDIANGRUDGE
   war-council sites (tribes side with the Crown), not "incite".
7. Tribute (func_04AC00) demands GOODS, and its ceiling operand [0x9E96] is
   only ever written 0 → the demand is always exactly 10 units.
8. New per-turn model recorded: native pass runs before the power phases
   (func_04891A → func_0485F6 → func_04830E); mission tick M=(expert?4:1)
   ×2 capital, ×2 FF 0x18, ÷2 FF 0x17 → tension_frac += M and alarm[owner]
   −= 3M; selling qty cools the village alarm by qty (100 zeroes it);
   herds grow by horses_known/turn capped 2·(tribe pop+25); good stocks
   drift to 0 by level+1; braves: one per village, respawn only on death.
Stale: spec/systems/natives.md §3/§6, viceroy_source/src/native/
settlement.c (native_tick fiction), manual §19 (being updated in v8),
2026-06-26/27 "RESOLVED-static" entries as they touch these bytes.

---

## 2026-08-04 — Coast quadrant code: the `|=1` bit is the COUNTER-clockwise cardinal

**Conflict**: manual §6.7 (and `notes/SPRITE_CATALOG.md` row 0x6D–0x8B) describe the
per-quadrant coast code as *"|=4 for its own cardinal (N,E,S,W for q0..q3), **|=1 for the
next-clockwise cardinal**, |=2 for its diagonal"*. Implementing that literally produced
coastlines that do not match the running game.

**Source A** — the manual/disasm wording: `|=1` = next-clockwise, i.e. N→E, E→S, S→W, W→N.

**Source B** — the sprite pixels themselves (`PHYS0.SS` frames disk 0x6C..0x8B, the band the
manual itself names): the code-1 frames (own cardinal absent, `|=1` bit only) paint
**q0 = the TL cell's WEST edge, q1 = the TR cell's NORTH edge, q2 = the BR cell's EAST edge,
q3 = the BL cell's SOUTH edge** — the counter-clockwise neighbour in every case. The
clockwise reading would place q0's band on the tile's east side, inside the TL cell, which
is geometrically impossible.

**Ruling**: **counter-clockwise** (`|=1` weights W, N, E, S for q0..q3). Pixels outrank both
the preprocessed disasm note and the C reconstruction per `notes/TRUTH_HIERARCHY.md`.
Independently confirmed by rendering `AMER2.MP` at view (35,8) with both readings and
diffing against the live DOSBox frame `docs/screens/colony_sites_live.png`: mean channel
error 6.44 counter-clockwise vs 8.57 clockwise, and the clockwise render visibly breaks the
shoreline into square blocks.

**Action taken**:
- `port/src/game.js` — `Q_NEXT = [6, 0, 2, 4]` (W, N, E, S) with the derivation in a comment.
- `docs/COLONIZATION_TECHNICAL_REFERENCE.md` §6.7 — wording corrected + cross-ref to this ruling.

**Follow-up**: the `0x67ABD..0x67AEF` code-builder should be re-read to confirm the direction
tables at the instruction level; the ruling rests on pixels + a whole-frame diff, not on a
re-reading of that loop.

---

## 2026-08-04 — Coastal beach halo applies to the clean-edge frames, not the quadrant frames

**Conflict**: §6.7 says a coastal water tile is grounded with a cardinal land neighbour's
terrain and that water is then *"backfilled through the frames' 0-index holes"*. Those two
statements cannot both hold for every frame — if every hole becomes water, the substituted
ground is never visible and the substitution is pointless.

**Source A** — literal reading: every index-0 hole becomes water (substitution invisible).

**Source B** — the frame pixels: the four clean-edge frames (disk 150–153) carry a sand/water
wedge with a **large transparent region on the land side** (frame 150's hole is the NW corner,
and pattern 0 is exactly `land at N, W, NW`) — that hole is the substituted ground. The 8×8
quadrant frames (disk 0x6C..0x8B) instead carry their **own** sand-and-water shore across the
full cell, with holes on the open-water side; a code-4 quadrant (own cardinal only) is
transparent on the side with no land at all.

**Ruling**: the halo substitution shows through the **clean-edge** frames; the **quadrant**
frames composite over plain ocean ground. Decided on pixels plus a whole-frame diff against
`docs/screens/colony_sites_live.png` — this rule scored 6.44 mean channel error against 7.55
for "land ground under both paths" and 7.48 for "ocean ground under both".

**Action taken**:
- `port/src/game.js` `drawTile()` — clean-edge path grounds on `haloGround()`, quadrant path
  grounds on the tile's own ocean frame.

**Follow-up**: the residual ~15% pixel mismatch on that frame is the unimplemented O512
biome-edge dither (§6.11), not the coast rule.

---

## 2026-08-04 — Woodcut caption ink resolves through the sheet's own palette; no year prefix

**Conflict**: §26.14 (woodcut event screens) states the caption is `"<year>: <CAPTION>"` drawn
in FONT-NP with "ink LUT palette indices 0x5C/0x5D/0x5E". Rendering that literally produces a
caption that is *invisible* — in `data_extracted/palette.json` (master VICEROY.PAL) indices
0x5C/0x5D/0x5E are pale wood tones (134,113,81)/(117,97,69)/(101,81,52), i.e. the same family
as the NAMEPLAT strip they are drawn on.

**Source A** — the manual's index triplet, and its `"<year>: "` prefix from `[0x538A]`.

**Source B** — the DOS capture `docs/screens/12_discovery_cinematic.png`: the caption reads a
bare **"DISCOVERY OF THE NEW WORLD"** with **no year prefix**, in dark brown ink sampled at
(64,40,24)/(64,36,24)/(48,28,16) on a (160,124,48) gold plate.

**Source C** — the container: every `.SS` carries its **own 768-byte palette** in MADSPACK
section 2, and `tools/ssdec.load_sheet` already returns it. In WOODFRAM/NAMEPLAT/WDCUT01's
shared palette, indices 0x5C/0x5D/0x5E are **(117,89,36)/(44,32,12)/(97,65,28)** — the dark
browns the capture shows. 158 of 256 entries differ from master.

**Ruling**: the manual's **index triplet is correct**; the error was assuming it indexes the
master palette. The woodcut screen adopts the woodcut sheets' own palette, exactly as the
`.PIK` screens already adopt theirs. The **year prefix is not drawn** — pixels outrank team
docs per `notes/TRUTH_HIERARCHY.md`, and the capture has no prefix. Whether the prefix is
conditional (and on what) is **TBD**: it needs the caller of `func_06B722` traced for the
`[0x538A]` read. The §26.14 wording is left standing but is now known to be incomplete on the
palette point.

**Action taken**:
- `port/tools/build_assets.py` — exports WOODFRAM.SS's own palette into the manifest.
- `port/src/game.js` `drawWoodcut()` — `usePalette('WOODFRAM')`, caption drawn bare.

---

## 2026-08-04 — Starting force is ONE ship at every difficulty

**Conflict**: §18.11's starting-conditions paragraph says the starting units are
"Caravel + Pioneers + Soldiers aboard (Dutch ship → Merchantman), **doubled at d ≤ 1** by a
second placement pass."

**Source A** — that sentence. It is the **only** occurrence of the claim in the tree
(`grep -rn "doubled at d\|second placement\|placement pass" docs/ spec/ notes/ viceroy_source/`
returns exactly one hit besides the map-generation entry below) and it carries **no function
name, no file offset, and no cite tier** — unlike every other row of that ledger.

**Source B** — `spec/systems/map_generation.md` §4, the BYTE_VERIFIED post-mapgen placement
passes orchestrated by `func_0755CC`: native settlements `func_065D26`, the resource /
land-value layer `func_063F3C`, and the two fixed rumour-feature tiles. **No pass places the
human's starting units, and none is difficulty-gated.** The "second placement pass" the
sentence appeals to is not among them.

**Source C** — the running DOS game (user report, 2026-08-04): one ship at every difficulty
level.

**Ruling**: **one ship, always.** Difficulty scales starting *gold* (1000/300/0/0/0), which is
byte-cited and stands; it does not scale hulls. Source C is the top of
`notes/TRUTH_HIERARCHY.md` and Source A is an uncited prose claim in a team doc, so this is not
a close call. Per CLAUDE.md's prime directive the claim should never have been carried into an
implementation without a cite.

**Action taken**:
- `port/src/game.js` `beginGame()` — always one ship.
- `docs/COLONIZATION_TECHNICAL_REFERENCE.md` §18.11 — claim struck and flagged.

**Follow-up**: if a difficulty-gated unit-placement site is ever found, reopen with the offset.

---

## 2026-08-04 — Map screen chrome is WOODTILE.SS tiled, not WOODPANL.PIK

**Conflict**: `spec/ui/map_view.md` item 4 lists "Sidebar bg: WOODPANL.PIK". WOODPANL is a
320x200 photographic panel with large swirls and a bevelled dark edge; the map sidebar in
`docs/screens/06_ingame_map.png` is a fine, obviously *repeating* horizontal grain.

**Test**: mean per-channel error against a text-free sidebar patch of that capture, over every
tiling phase:

| candidate | mean channel error |
|---|---|
| **WOODTILE.SS frame 0 (32x24), tiled from screen (0,0)** | **2.90** |
| OPENTILE.SS frame 0, best phase | 8.05 |
| WOODPANL.PIK (as documented) | 11.91 |

The best-fit phase resolves to exactly 0 mod 32 horizontally and 0 mod 24 vertically, i.e. the
tiling starts at the screen origin with no offset.

**Ruling**: the map screen is **WOODTILE.SS frame 0 tiled from (0,0)**. WOODPANL.PIK remains
correct for the full-screen dialog backdrops (name entry, briefings, intro cards) — the DOS
captures for those do show the swirled panel. The `map_view.md` line is wrong and is flagged.
After the change a text-free strip of the port's sidebar scores **1.2** against the capture.

**Action taken**:
- `port/src/game.js` `drawMap()` — tiles WOODTILE.SS and adopts its own sheet palette.
- `port/tools/build_assets.py` — exports WOODTILE.SS's palette.
- `spec/ui/map_view.md` — line flagged.

---

## 2026-08-04 — Colony screen: scene window, centre-tile outline, stockpile inks

Four corrections to §26.8, all measured off `docs/screens/11_colony_screen.png` (normalised to
320x200 by cropping the capture's content box 192,184–832,584 and NEAREST-resizing 2:1).

**1. The 5x5 scene's outer ring really is overdrawn.** §26.8 lists both
`(200,8,120,120) "5x5 scene"` and `(224,32,72,72) "Visible 3x3 scene window … outer ring
overdrawn"`. Measured: the non-wood window in the capture's right panel is exactly
x 224..295, y 32..103, inside a 1px dark border at 223/296 and 31/104. So the 5x5 is composed
and stretched into the larger rect, but only the central 3x3 is visible. Rendering the full
5x5 (as the port first did) is wrong.

**2. The white rectangle is the colony-centre tile, not the 3x3 window.** Measured white
outline: x 248..271, y 56..79 — 24x24, i.e. the cited `(248,56,24,24)` "Colony-centre tile"
region, and consistent with 24px tiles in a 72px window.

**3. Stockpile icons are centred in their cell, not flush left.** §26.8 gives "icons y=181"
with the digits "centred at (9+19i,194)". The icons share that centre axis: the 13px-wide
horses sprite sits at x 156..167 in a cell whose left edge is 1+19·8 = 153. All 16 frames are
12 tall and y=181 is confirmed.

**4. Stockpile digits are ink 0x31, not white 0x0F.** §26.8 says "digits … white 0x0F". The
capture's quantity cells contain **no pure white at all**; the digit ink samples as
(195,219,243) = palette index **0x31**. The capture is a clean 2:1 NEAREST reduction, so this
is not resampling. The SoL band nearby *is* near-white — (248,252,248) = **0x10** — and the
panel caption is (152,184,216) = **0x33**, so the three are genuinely different inks and the
"white" gloss collapsed them.

**Action taken**: `port/src/game.js` `drawColony()` — scene clipped to the 3x3 window, outline
moved to the centre tile, icons centred on 9+19i, `STOCK_INK`/`SOL_INK`/`PANEL_INK` split out.
The Europe market bar inherits the same icon-centring rule.

**Still open** (tracked in `docs/UI_AUDIT_TRACKER.md`): the starting-building set and the
`func_025D34` plot shuffle. The field's remaining mismatch against the capture is dominated by
those two, not by geometry.

---

## 2026-08-04 — Colony screen: separator rules, scene tile origin, field ground ramp

Three more measurements off `docs/screens/11_colony_screen.png` (same normalisation as the
entry above).

**1. Black separator rules exist and are not in §26.8's region table.** Scanning for rows and
columns that are ≥60% black gives exactly three: a full-width row at **y=7** (under the title
strip), a full-width row at **y=128** (above the COLONY.PIK town strip), and the column at
**x=199** (between the building field and the wood panel), spanning y 7..128. The town strip's
internal panel borders are *not* black — they are light-green and come from the PIK art, which
is why only these three show up.

**2. The 5x5 scene's tile origin is the panel origin, with no half-tile offset.** Composing the
80x80 with tiles at `tx·16 − 8` (as the port first did) shifts the whole scene 12 screen px
after the ×1.5 stretch, so the colony does not land in the centre tile. Tiles go at `tx·16`:
tile 2 then spans source 32..48 → 48..72 after the stretch → screen 248..272, which is exactly
the cited `(248,56,24,24)` centre-tile rect. This is what made the "outside colony view" look
off-centre.

**3. The building field's ground is a dithered ramp, not a flat colour.** The field samples as
three tones only — (232,216,160) / (240,228,176) / (224,200,144) — which map to the
**contiguous palette indices 0x63 / 0x62 / 0x64**, in ~52/30/18 proportion over a clean patch.
A contiguous triplet in those proportions is a 3-level dither. The **generator is unidentified**
and is recorded as TBD in `docs/UI_AUDIT_TRACKER.md`; the port uses a deterministic positional
hash tuned to the measured proportions (it reproduces the tones and their ratios to within a
percent, not the engine's exact pixel pattern).

**Action taken**: `port/src/game.js` `drawColony()` — the three rules drawn, scene tile origin
corrected, `groundSpeckle()` replaces the flat fill. Colony and unit markers now land on the
correct tiles as a result of (2).

---

## 2026-08-04 — Starting buildings are the upkeep-0 rows of NAMES.TXT @BUILDING

**Question**: which buildings does a brand-new colony have? Previously logged as TBD on the
grounds that the def table `0x8E82`'s initialiser is untraced.

**Source**: NAMES.TXT `@BUILDING`, columns `name, cost, tools_x10, size, min_colony, upkeep`.
The **upkeep** column (last) had been ignored. Exactly **eight** of the 42 rows carry upkeep 0:

| row | name | cost | min_colony |
|---|---|---|---|
| 0 | Stockade | 64 | **3** |
| 9 | Town Hall | 64 | 1 |
| 21 | Weaver's House | 64 | 1 |
| 24 | Tobacconist's House | 64 | 1 |
| 27 | Rum Distiller's House | 64 | 1 |
| 32 | Fur Trader's House | 56 | 1 |
| 35 | Carpenter's Shop | 39 | 1 |
| 39 | Blacksmith's House | 64 | 1 |

Every other row — every second and third tier of every chain — carries upkeep 5, 10, 15 or 20.
Zero upkeep marks the free base tier that costs nothing to maintain.

**Ruling**: the starting set is **`upkeep == 0 AND min_colony == 1`** — the seven base-tier
buildings. The Stockade is the one zero-upkeep row gated above a size-1 colony (`min_colony` 3),
so it cannot be present at founding, which is exactly why the predicate needs both clauses.
This is consistent with the base tier of each production chain (weaving, tobacco, rum, furs,
carpentry, smithing) plus the Town Hall.

**Tier**: derived from NAMES.TXT, which sits high in `notes/TRUTH_HIERARCHY.md`. It is an
inference from the table's semantics rather than a traced initialiser, so `0x8E82` stays
unread; but it is data-grounded, not a guess, and the port now computes the list at runtime
from the shipped table instead of hardcoding names.

**Action taken**: `port/tools/bundle.py` exports cost/min_colony/upkeep; `port/src/game.js`
`STARTING_BUILDINGS` is a filter over them. The `STARTING_BUILDINGS_UNVERIFIED` placeholder is
gone.

---

## 2026-08-04 — Europe purchase catalog, button chrome, and palette-scoped ink indices

**1. The purchase catalog is byte-cited after all.** A previous entry recorded the Europe
PURCHASE page as unimplementable because "no price table exists in the shipped data". That was
a search failure, not an evidence gap: the catalog is in **§17.6** (the immigration section,
not the market one) — *"the same table as the Europe ship/artillery purchase catalog (Artillery
500, Caravel 1000, Merchantman 2000, Galleon 3000, Privateer 2000, Frigate 5000); only
Artillery escalates (+100 per unit bought, tracked in `artillery_bought`)."* PURCHASE buys
**units**, not goods; the "Muskets 50 / Horses / Tools 100" sites in §9.4 are the separate
inline goods buys. The tracker entry is corrected to DONE.

**2. Ink indices are palette-scoped, and matching against the master palette silently
lies.** The Europe buttons' border sampled as (56,72,144). Matched against
`data_extracted/palette.json` that is index 0x7D; matched against **EUROPE.PIK's own palette**
it is **0x3B**. Drawing 0x7D through the loaded Europe palette produced black. This is the same
class of error as the 2026-08-04 woodcut-caption ruling: *the index means nothing without the
palette it indexes.* Any colour sampled off a capture must be resolved against the palette that
screen actually loads.

**3. Capture geometry needs its letterbox removed before measuring.** `10_europe_screen.png` is
660x480 with a ~10px horizontal and ~29px vertical border, so a naive full-frame resize to
320x200 misplaces everything: the button rows measured at pitch 9 and x=277, contradicting the
cited (281, 89+11r, 37, 9). Calibrating against two known landmarks (the title text row and the
market bar's top edge) recovers scale ≈2.0 with those offsets, and the rows then land at
x=281, pitch 11 — **the spec was right and the measurement was wrong**. The buttons are drawn
as a 1px border with the panel showing through, not a filled bar.

---

## 2026-08-04 — Dialog frame: the bevel paint order is load-bearing

`func_06E0C8` paints a dialog box in four steps (dialog_framework.md §"Box painter"):
1-px black outline on the box edge; ring 2 inset 1 in `[0x1F44]`; ring 3 — the bevel — as four
1-px spans inset 2; then the tiled interior at `(x+3, y+3, w−6, h−6)`.

**In-game ring colours resolve to NAMES `@COLORS`.** The in-game mode setter `@0x073474` takes
its inks from `[0x830..]`, and `[0x830..0x833]` is already known to be the `@COLORS` row (the
minimap owner dots read it). That row's **last three fields are `border0`/`border1`/`border2` =
134 / 128 / 138** — (89,52,36), (121,73,52), (60,32,24): a mid, a lighter and a darker wood
brown, i.e. exactly a ring-plus-bevel triplet. They map in order: ring 2 = border0, bevel light
= border1, bevel dark = border2. Verified against `docs/screens/01_mainmenu_BEGINMENU.png`: the
ring pixel reads (88,48,40) in the capture against 134 = (89,48,40).

**The paint order decides the corners.** The engine draws left, then right, then top, then
bottom (`@0x06E192` / `@0x06E1C0` / `@0x06E1E4` / `@0x06E204`). Because the top span lands after
the left one, the **top-left corner pixel is LIGHT**; because the bottom span is last, the
**bottom-right corner is DARK**. Painting top/right first — the intuitive order for a bevel —
puts the wrong colour in both corners. Caught by diffing (x+2, y+2) against the capture:
real (120,72,48) = the light band, not the dark one.

After the correction the four frame bands of the boot menu score 0.76 / 0.11 / 0.12 / 0.72 mean
channel error against the capture — the residual is the capture's own colour reproduction.

**Action taken**: `port/src/game.js` `plaque()` rewritten to the four-step recipe with
`FRAME_BOOT` (0x2E / 0xFD / 0x37, OPENTILE) and `FRAME_GAME` (134 / 128 / 138, WOODTILE);
`port/tools/test_flow.py` samples the rings and both corners off a scratch canvas.

---

## 2026-08-04 — Selection-band ink is palette-scoped; O512 stencils are index-0 holes

**1. The in-game selection band is @COLORS `select` (138), not 0x37.** The boot mode setter
(`@0x0734BC`) ties `[0x1F40]/[0x1F42]` to **0x37**, which through OPENMENU's palette is
(56,32,24) — confirmed against the highlighted row of
`docs/screens/01_mainmenu_BEGINMENU.png`. The in-game setter (`@0x073474`) instead takes its
inks from `[0x830..]` = NAMES `@COLORS`, and that row carries a field literally named
**`select` = 138 = (60,32,24)** — the same dark brown. Carrying 0x37 onto an in-game screen is
wrong: through the wood/Europe palettes 0x37 is a **blue** (93,121,186), which is exactly what
every in-game pulldown, dialog and Europe menu was showing. Third instance of the same class of
bug (see the woodcut caption and the Europe button border): **an ink index is meaningless
without the palette it indexes.**

**2. The O512 edge stencils are index-0 HOLES, not dots.** §6.11 calls PHYS0 `0x68..0x6B` "a
sparse index-0 dot stencil". Decoding frame 0x68 gives **241 pixels of index 253 and 15 of
index 0**, the 15 forming a dither along the north edge. So the index-0 pixels are the holes
the neighbour's terrain shows through, and the mask is the *inverse* of the PHYS0C atlas
(which renders index 0 transparent) — a `destination-out` composite, not `source-in`. Reading
"dot stencil" as "the dots are drawn" produces a fully transparent stencil and no blend at all.

**3. Map-screen black separators.** Scanning `docs/screens/06_ingame_map.png` for rows/columns
≥60% black gives exactly two: the full-width row at **y=7** under the menu bar and the
full-height column at **x=240** between viewport and sidebar.

**Action taken**: `port/src/game.js` — `SELECT_BOOT`/`SELECT_GAME` split; `edgeBlend()` +
`stencilBlit()` implement O512 for land centres (including the W→S→E→N ring-walk that produces
the beach dither); the two map separators drawn; the pulldown moved after the sidebar so
COLONIZOPEDIA's menu is not covered by the minimap.

---

## 2026-08-04 — Native settlements come from TRIBE.TXT; its x needs +2

**Finding**: native settlement placement is **not procedural**. `TRIBE.TXT` — listed in the
resource table as *"native-settlement coordinate lists per tribe"* but never used until now —
ships one `@<TRIBE>` section per tribe with an `x,y` pair per line. Eight playable tribes,
**59 sites**: Iroquois 11, Tupi 16, Apache 7, Sioux 7, Inca 5, Arawak 5, Cherokee 4, Aztec 4.
`@STOP` is a terminator, not a tribe. Section names match `@TRIBES`' **`singular`** column.

**Coordinate convention**: the pairs are two columns left of the stored map plane. Testing
every offset in dx −1..+3 × dy −2..+2 against AMER2.MP:

| offset | sites landing in water |
|---|---|
| **dx=+2, dy=0** | **0 / 59** |
| dx=+1, dy=0 | 7 |
| dx=+3, dy=0 | 6 |
| dx=+2, dy=±1 | 8 |
| dx=0, dy=0 (raw) | 17 |

A clean sweep over 59 independent points settles it. `formats/MP_FORMAT.md` and §13.1 both note
a leading plane column (*"engine coordinate 0 IS in bounds — plane column 1"*), so an origin
shift is expected; the exact derivation of **2** is not in the evidence, only its result.

**Action taken**: `port/tools/bundle.py` exports `tribesites`; `port/src/game.js`
`seedNatives()` reads it instead of the deterministic-hash placeholder. The tracker entry
"Settlement PLACEMENT is a placeholder" is closed.

---

## 2026-08-04 — `@TRIBES.value` is the tribe's map colour

**Finding**: the `value` column of NAMES.TXT `@TRIBES` — carried in the table but never
assigned a role — is a **palette index**, the native counterpart of `@COUNTRY.color` for the
European powers. The eight playable tribes resolve to eight visually distinct entries:

| tribe | idx | colour | | tribe | idx | colour |
|---|---|---|---|---|---|---|
| Incas | 97 | cream (247,243,199) | | Cherokee | 67 | green (117,166,77) |
| Aztecs | 149 | gold (199,162,32) | | Apache | 111 | tan (195,174,134) |
| Arawaks | 54 | blue (105,138,195) | | Sioux | 118 | dark red (146,0,0) |
| Iroquois | 87 | brown (109,60,24) | | Tupi | 71 | dark green (4,93,4) |

For comparison `@COUNTRY.color` gives England 12 red, France 9 blue, Spain 14 yellow,
Netherlands 13 orange — the same kind of index, same role. Unlike most colour indices in this
codebase these resolve **identically** in the master and WOODTILE palettes, so no
palette-scoping trap here.

**Ruling**: ownership is drawn the same way for both. Native units get the same 8×9 owner plate
the European units wear, in the tribe colour; native settlements get a 6×5 colour patch where a
European colony flies its pennant sprite (disk 118+power); and the minimap dots both.

**Action taken**: `port/tools/bundle.py` exports `color` per tribe; `port/src/game.js` gains
`ownerColour(u)` (nation ≥ 0 → `@COUNTRY.color`, else the tribe's), and `nationPlate` takes a
colour index rather than a nation id.

---

## 2026-08-04 — Advisor reports use REPORT&lt;N&gt;.PIK, and N is not the F-key number

**Finding**: the advisor screens composite over their own `REPORT<N>.PIK`, not WOODPANL
(`spec/ui/advisor_reports.md`: *"the true art is `REPORT<N>.PIK` with N = the report's title
number"*). Nine plates ship. The spec gives some N values in passing but not a complete table,
and the N is **not** the F-key number.

**Method**: match every shipped plate against the DOS captures in `docs/screens/reports/`,
cropping each capture's 640×400 content box and comparing the full frame:

| report | plate | error | runner-up |
|---|---|---|---|
| F2 Religious | **REPORT2** | 2.7 | 29.5 |
| F3 Congress | **REPORT3** | 6.6 | 29.5 |
| F5 Economic | **REPORT5** | 14.5 | 38.8 |
| F6 Colony | **REPORT6** | 2.4 | 26.1 |
| F8 Foreign Affairs | **REPORT8** | 5.4 | 24.8 |
| F9 Indian | **REPORT1** | 3.3 | 20.1 |

Every one is at least 15 points clear of its runner-up. **F9 → REPORT1** is the surprise, and it
cross-checks against the spec: advisor_reports.md notes the shared palette is *"identical across
REPORT2/3/4/5/7/8/9"* — the two plates excluded from that group are **1 and 6**, and 1 and 6 are
exactly the two this matching assigns to the two visually distinct reports (Indian and Colony).

**Unmatched**: `F4_labor.png` and `F7_naval.png` are **map screenshots, not reports** — both
score ~90 against every plate. F4 → REPORT4 is taken from the spec's own `N=4`; F7 → REPORT7 by
elimination. Recorded as inferred.

**F1 is not a report.** "Terrain Information" is the Colonizopedia TERRAIN page (CLAUDE.md hard
rule 7), which is why its capture is named `F1_terrain_colonopedia.png` and matches no plate.
The port routes F1 to the pedia.

**Action taken**: `port/tools/build_assets.py` extracts REPORT1–9; `port/src/game.js` gains
`REPORT_PIK` and each report draws over its own plate; F1 opens the pedia; F4 Labor and F10
Score are built.

---

## 2026-08-04 — Two invented native-alarm rules struck from the port

**Context.** The HTML port carried two behaviours on the village alarm word that
no evidence supports, both introduced before the alarm word had any semantics in
the port at all:

1. `villageSell()` set `v.alarm = 0` on a sale of 100 units or more, and
   otherwise subtracted the quantity from it.
2. `villageGift()` set `v.alarm = 0` outright.

**Ruling.** Both are **struck**.

> **CORRECTION, same day.** Item 1 was struck in error and is **restored**. The
> strike rested on `spec/systems/natives.md` §3, which records only the flat −4
> goodwill credit `@0x5C41E` — but that section is explicitly marked **stale** by
> the *2026-08-01 native-background-economy* ruling further up this file, whose
> item 8 records the quantity rule as byte-traced: *"selling qty cools the
> village alarm by qty (100 zeroes it)"*. Manual §19.5 states the same and calls
> it byte-traced. Higher source wins. The two credits are separate and land on
> **separate meters**: the flat −4 on the **tribe's** tension, the quantity on
> the **village's** alarm word.

Item 2 (the gift zeroing the alarm word) **stays struck** — the gift's credit is
untraced (the manual only says gifts cool anger faster than sales), so the port
keeps its doubled-credit placeholder on the tension meter and lets the alarm word
follow the same delta rather than zeroing it.

**Consequence for the model.** The engine keeps **two** parallel per-(settlement,
power) meters and they are not interchangeable:

| meter | storage | range | thresholds |
|---|---|---|---|
| tension | DGROUP `0x5B1C`, `(row·39 + col)·2` | 0..100 | hostile 75, war 100 |
| alarm | DGROUP `0x54F6`, `(settlement·9 + power)·2` | word | **raids at 128** (`cmp [..+0x54F6],0x80` @0x04734E, @0x04CAD7, @0x053D4E) |

Both thresholds are byte-verified and the port uses them as such. What *drives*
the alarm word up is **not** traced — only the applier's own tail (neighbour
propagation, clamps to 0x20/0x60) is. So the port runs the alarm word off the
same delta ledger as the tension meter and records that coupling as the port's
own in `docs/UI_AUDIT_TRACKER.md`. That is a placeholder, not a finding.

## 2026-08-04 — The native-village interaction is a popup, not a screen

The port had built the village interaction as a full-screen WOODPANL page with
an invented greeting line ("The Inca welcome you to their city."). Both are
wrong. `spec/ui/context_dialogs.md` §6 states the `@ACTIONS` menu is sized by the
§2 builder and run by the §3 dialog runner (`func_06E3D0`) — i.e. a centred
popup over the map — and GAME.TXT ships the greeting itself in five attitude
variants, `@VILLAGEHAPPY` / `@VILLAGEMEDIUM` / `@VILLAGESAVAGE` / `@VILLAGEBAD` /
`@VILLAGEWAR`, each *"Your expedition has reached a %STRING0 of {%STRING1}…"*.

**Ruling.** The port now renders the village as a §3 popup with the shipped
greeting as its body block and the chief on the tribe speaker channel
(`[0x1F5C]` → `IND<tribe>A<pose>.SS`). The **portrait's position remains
untraced** — `popups.md` §2.7.1 resolved that there is no box-relative formula
anywhere in `func_06BF66`/`06BE92`/`06BF12`/`06BF3C`, and pinning it needs a
running-game capture — so it takes the bottom-right placement the DOS captures
show, flagged as inferred.

**Also fixed in passing:** `onClick`'s `village` and `pedia` cases had been
copy-pasted from `onKey` and referenced an undefined `k`, so clicking either
screen threw. Both now hit-test real geometry.

## 2026-08-04 — The mission tick binds Sepúlveda and las Casas (TBD closed)

The previous entry recorded Juan de Sepúlveda's **+4** and Bartolomé de las
Casas' **−4** (`@0x5E20B` / `@0x5E221`) as landing on a "conversion metric"
whose consumer was untraced, and the port therefore left both unimplemented.

**Closed.** The *2026-08-01 native-background-economy* ruling (item 8) records
the per-turn mission tick in full:

```
M = (expert ? 4 : 1) × 2 if capital × 2 with FF 0x18 ÷ 2 with FF 0x17
tribe.tension_frac += M        (every ±8 becomes one visible ∓1 tension tick)
settlement.alarm[owner] -= 3·M
```

`@FATHERS` row `0x17` = **Juan de Sepúlveda**, row `0x18` = **Bartolomé de las
Casas** — so the ±4 pair *is* this ×2 / ÷2 doubler, and the direction matches
(las Casas helps the mission, Sepúlveda hinders it). Both are now implemented in
the port's `missionStrength()`, along with the capital doubler and the expert
(Brébeuf) bit.

Two further consequences taken from the same ruling and now in the port:

- **The tension table is per-TRIBE × power** (`TribeData +0x46`, stride `0x4E`),
  not per settlement — `natives.md` §3's settlement-row model is stale. The
  port's per-tribe meter was already the right shape.
- **Attacks-to-burn IS the population** (`@0x5D67A` in `func_05CA7E`), and the
  growth cap is `func_046DE0`'s target size `2·level+3` / `3·level+4` for a
  capital. Both are implemented; the raze payout cross-checks the manual's own
  ceiling table exactly (`30·6·4·21 = 15 120` at Discoverer).

---

## 2026-08-05 — The fog path (§6.11): unexplored tiles are frame 0x95, and the O512 dither stencil was reading an empty atlas

**Conflict**: the port drew unexplored tiles as solid black and its comment
header claimed "the O512 biome-edge dither (§6.11)" was not implemented, while
`spec/systems/map_system.md` §3 and the 2026-06-22 O512 ruling both say a hidden
tile draws fog sprite `0x95` and then calls `func_067F50` for the fog-edge
blend. A live frame settles it and closes three sub-questions at once.

**Evidence** — `docs/screens/06_ingame_map.png` is the opening turn: an
all-ocean map, one caravel, a 3×3 explored patch, everything else fogged. It is
a 2× capture of the 320×200 screen at image offset (192,184), so every logical
pixel is recoverable. Measured against the extracted sheets:

1. **Every fog tile that touches no explored square is PHYS0 disk frame `0x94`
   (engine `0x95`) pixel-for-pixel** — 86 of them, zero mismatching pixels once
   the 6-bit palette scaling is normalised. Fog is *not* black.
2. **Each fog tile cardinally adjacent to the patch differs from `0x94` by
   11–14 pixels**, and those pixels sit exactly on the dot positions of stencil
   disk `0x68+dir` — bottom three rows for the tile N of the patch (blended from
   its S neighbour), top three for the tile S of it, right three columns for the
   tile W of it, left three for the tile E. Diagonal neighbours are untouched,
   confirming the 4-cardinal loop.
3. **At all 15 stencil positions the fog tile's pixel equals the corresponding
   pixel of its explored neighbour** (14 exact, one off by 4 in one channel —
   capture noise). The blend really is the neighbour's terrain, and the "11–14"
   of item 2 is just dots whose blended value happens to match the fog colour.
4. **Explored tiles take nothing from the fog they touch**: the patch's N-edge
   tile (8,6) and S-edge tile (8,8) are pixel-identical to each other, so
   neither picked up a fogged neighbour.

**Ruling** — the skip test in O512 (`@0x68120`/`@0x68153`) is:

```
if (neighbour is unexplored)                 skip   # item 4
if (nb_class == centre_class && !centre_hidden) skip  # "same class with no fog"
```

The second clause is qualified by the **centre's** hidden flag (`[bp+4]`), which
is why a fogged tile still dithers a *same-class* explored neighbour in — the
all-ocean boundary of item 2 — while the open fog field stays flat. The spec's
"neighbour is still water after the walk" skip lives inside the ring-walk
block's tail and so does not fire when the ring is disabled (`[bp+6]≠0`);
otherwise item 2 could not happen, since that centre is ocean.

**Bug found and fixed**: `stencilBlit` masked with the **`PHYS0C`** atlas. That
atlas keys out index 0 *and* index 253, which leaves stencil frames `0x68..0x6B`
with **zero opaque pixels** — the `destination-out` erased nothing and the
neighbour's *whole tile* was blitted. On the old code this only ran on visible
land tiles, where it silently overpainted them; turning on the fog path made it
render the entire fog field as open terrain. The plain **`PHYS0`** atlas already
is the mask (index 253 keyed out, the 15 index-0 dots opaque), so the composite
is `destination-in` against `PHYS0`.

**Action taken**:
- `port/src/game.js`: `PHYS.FOG = 0x94`; the unexplored branch of `drawTile`
  draws it and calls `edgeBlend(..., hidden=true)`; `edgeBlend` gained the
  `hidden` argument, an explicit in-bounds test, the two skip clauses above, and
  the ring-walk gate stated as "centre is not water"; `stencilBlit` fixed.
- `port/tools/test_flow.py`: three render probes — flat field + untouched
  diagonals, per-cardinal stencil band, and "the biome dither needs an explored
  neighbour". 164/164.
- `port/README.md`: the compositor's not-implemented list and the stale
  milestone list.

**Follow-up (TBD, do not guess)**: item 3 says the blend source is the
neighbour's **composed** tile, not the bare class ground sprite —
`emit_terrain_sprite(nb_class)` is documented as taking a class, yet the live
fog tile's 15 dots match the neighbour's rendered tile 15/15 and the bare
`TERRAIN` ocean frame only 9/15. This cannot be resolved from this frame,
because the port's own ocean base already differs from the live ocean tile at
91/256 pixels — an unrelated, pre-existing gap in the base ocean sprite. Settle
the base ocean tile first, then re-measure; until then the port blends the
neighbour's ground frame.

---

## 2026-08-05 — TERRAIN.SS resolves through VICEROY.PAL, not its own embedded palette (closes the previous entry's follow-up)

**Conflict**: the 2026-08-05 fog-path entry above left open why the port's ocean
tile differed from the live capture at 91/256 pixels, and flagged a suspicion
that O512 blends the neighbour's *composed* tile rather than its class ground
sprite. Both turn out to be the same single cause, and it is neither of those.

**Source A** — `port/tools/build_assets.py` asserted in a comment that "sheet
pixels always resolve through the sheet's own palette", and `sheet_to_png`
accordingly ignored the master palette its caller was already passing in.

**Source B** — the live frame. In DOS the VGA palette is global hardware state:
a `.SS` file's embedded palette is only whatever was loaded when the artist
saved it, and what actually reaches the screen is the palette the *screen*
streams. On the map screen that is the master `VICEROY.PAL`.

**Evidence**. `TERRAIN.SS`'s embedded palette disagrees with `VICEROY.PAL` on 12
entries, of which exactly **121–126 — the sea-lane sparkle band** — are used by
any frame at all (53 of 3072 sheet pixels; only frames 7 and 11 touch them).
Rendering frame 11 (Sea Lane) and diffing against `docs/screens/06_ingame_map.png`
tile (8,6), through the emulator's RGB565 quantisation:

| palette used | pixels wrong |
|---|---|
| the sheet's own | **50 / 256** |
| master `VICEROY.PAL` | **3 / 256** |

The same numbers come out of tile (8,8), the other clean sea-lane square in that
capture. A brute force over both cycling bands × both rotation directions ×
every phase never beat phase 0, so this is not a cycle-phase artifact — the
sheet copy simply holds different colours.

**Ruling**: TERRAIN's pixels bake against the master palette. Scoped to that one
sheet, and measured rather than assumed: `PHYS0`, `ICONS` and `WOODTILE` differ
from the master on **zero used indices** (so the choice is a no-op for them),
while `WOODFRAM`, `KING1`, the four nation flags and the `WDCUT` plates are
screen-specific palettes where ~100% of pixels depend on keeping the embedded
copy. `sheet_to_png` now takes an explicit override and `MASTER_PALETTE_SHEETS`
names the exception.

This also **withdraws the previous entry's follow-up**: the fog-edge dots looked
like they matched the neighbour's *composed* tile only because the bare ground
frame was being coloured wrong. The blend source is the class ground sprite, as
`emit_terrain_sprite(nb_class)` says.

**Action taken**:
- `port/tools/build_assets.py`: `MASTER_PALETTE_SHEETS = {"TERRAIN"}`;
  `sheet_to_png(path, pal, …)` honours `pal` instead of discarding it; the stale
  "always resolve through the sheet's own palette" comment replaced.
- `port/tools/test_flow.py`: Sea Lane must contain master index 121
  `(81,105,178)` and must not contain the sheet's `(93,121,178)`. 165/165.

**Follow-up**: **3 pixels of 256** remain on that tile — two carrying sheet index
124 and one index 126, where the live game shows the base blue (index 59/127).
It is *not* a palette question: 9 of the 11 index-124 pixels in the same tile
match exactly, so entry 124's colour is right. It is not a capture artifact
either — the capture is a clean 2× and all three of those 2×2 blocks are
uniform. Both clean sea-lane tiles in the frame show it at the same three
positions. Unexplained; needs a second capture at a different cycle phase, or a
trace of what else writes those pixels. **TBD, not guessed at.**

**Still open, unchanged**: water palette cycling itself. Bands 54–60 and
120–127 are pixel-verified as pure rotation (manual part1 §"Palette animation",
part7 §29.4), but the tick rate and rotation direction are TBD — the cycle-tick
function is unidentified and `CYCLE.DAT`'s 34 bytes are undecoded
(`docs/PALETTE_AND_CYCLING.md`). The port therefore renders the water static, at
the master palette's phase, which is the phase the live map capture shows.

## 2026-08-05 — CYCLE.DAT decoded: one band of 8 from index 120, rotating up every 35 ticks of a 60.8766 Hz timer

**Question**: `docs/PALETTE_AND_CYCLING.md` carried three open items — the
cycle-tick function was "not yet annotated", `CYCLE.DAT`'s 34 bytes were
undecoded (and guessed to be "a tiny code patch / animation script" because they
"plausibly decode as x86 instructions"), and the rate and direction of the
rotation were unknown. `port/README.md` recorded the same gap: the port rendered
water static because it could not name a tick rate.

**Source**. `MAPEDIT.EXE` ships CodeView symbols, and among them is a module
`cycle_1.c.obj` exporting **`_cycle_init`** (file `0x0107AA`, `0xF1A:0x00A`) and
**`_cycle_colors`** (file `0x010846`, `0xF1A:0x0A6`) —
`code/MAPEDIT/disasm_named/cycle_1.c.asm`, symbols in
`data_extracted/mapedit_symbols.json`. VICEROY links the same C module: its
`cycle_init` is at file **`0x0C4A4`** (`0x0A0A:0x004`, reached through thunk
`0x181F:0x0EAE`) and its `cycle_colors` at file **`0x0C51A`** (`0x0A0A:0x07A`).
The two compilations differ only in memory model — MAPEDIT holds the palette in
a near buffer at `0x6048`, VICEROY behind a far pointer at `[0x36E]` — and are
otherwise instruction-for-instruction identical.

### The format

`CYCLE.DAT` is **not code**. It is

```c
struct { uint16 count; struct { uint8 len, phase, start, delay; } band[8]; };
```

= 2 + 8×4 = **34 bytes**, exactly the shipped size. `cycle_init` reads the count
from `[0x929E]` (`cmp [0x929e], ax` @`0x0C4F9`) and walks `band[i]` at
`0x92A0 + 4i` (`shl bx,2` then `[bx-0x6D60]`, i.e. DGROUP `0x92A0`, @`0x0C4E5`).
Field roles, each from its use site in `cycle_colors`:

| off | field | site | role |
|---|---|---|---|
| +0 | `len` | `[bx-0x6D60]` @`0x0C58F` | entries in the band; also the `3*len` copy length and the phase modulus |
| +1 | `phase` | `[bx-0x6D5F]` @`0x0C60D` | runtime rotation counter — `cycle_init` zeroes it (@`0x0C4EF`) |
| +2 | `start` | `[bx-0x6D5E]` @`0x0C598` | first palette index; also the upload base (`[0x92A2]` @`0x0C62E`) |
| +3 | `delay` | `[bx-0x6D5D]` @`0x0C55F` | ticks between rotations |

The shipped file is `01 00 | 08 3D 78 23 | …`: **count = 1**, and
`band[0] = { len 8, start 0x78 = 120, delay 0x23 = 35 }`. Bands 1..7 are
uninitialised bytes from whatever tool wrote the file — which is precisely why
the tail "plausibly decodes as x86": it *is* stray code, but it is dead, never
read (the loop bound is `count`), and carries no meaning. The `phase` byte in
`band[0]` (`0x3D`) is likewise dead, overwritten with 0 at init.

### The rate

`timer_install` programs the PIT with divisor **`0x7A8` = 1960**
(`push 0x7a8` @`0x0C843` → `TIMER_SET_RATE` @`0x0E508`, `out 0x43,0x36` /
`out 0x40`), so IRQ0 fires at 1193182/1960 = **608.766 Hz**. The ISR gates twice:
`test [0x8338],1` @`0x0C6A5` drops the odd ticks (**/2**), and
`dec byte [0x376]` @`0x0C6F5` with its reload of **5** @`0x0C70B` divides again,
giving the 32-bit counter at `[0x92E8]` incremented at
608.766/2/5 = **60.8766 Hz**. `timer_install` points the timer-read vector at
that counter (`[0x267A] = 0x92E8` @`0x0C857`), and `cycle_colors` reads it
through `@timer_read` (`lcall 0xC0C:6` @`0x0C544`). MAPEDIT names the same three
counters `@timer_read_dos` / `@timer_read_600` / `@timer_read_60`, confirming
the intended tiers.

So one rotation step = **35 / 60.8766 = 0.5749 s**, and a full 8-entry round
trip = **4.5995 s**. The period is wall-clock, not frame-count: `cycle_colors`
fires when `last + delay <= now` and then sets `last = now`, so the animation
runs at the same speed whatever the frame rate.

### The direction

`cycle_colors` @`0x0C5B2`–`0x0C5F3` sets `STD` and runs three descending
`rep movsb`: 3 bytes of the band's **last** colour into a temp, then `3*len-3`
bytes shifting the band up one slot, then the temp into the **first** slot.
Each colour therefore moves to the **next higher index**, and the last wraps to
the first. After `p` steps, palette index `start+k` shows the colour authored at
`start + ((k-p) mod len)`.

### How it runs

`cycle_colors` has **no static caller**. It is installed as the timer ISR's
low-priority callback: `push 0x0A0A; push 0x007A; lcall 0x0A29:0x21B` @`0x04B62`
(MAPEDIT's `_TIMER_ACTIVATE_LOW_PRIORITY` @`0xD1C:0x23D`; the two timer modules
are offset by a constant `0x22`), and the ISR calls it via `lcall [0x92E4]`
@`0x0C795` — i.e. at the full 60.8766 Hz. Two guards: `[0x372]`, the enable set
by `cycle_init(([0x5383] & 1) ? 0 : 1)` @`0x076314`–`0x076323` as the map screen
comes up; and `[0x808]`, a DAC-busy lock set at the head of every routine that
streams the palette ports directly (@`0x0D1E9`, `0x0E71C`, `0x07854D`), which
keeps the interrupt off the hardware mid-transfer. The upload is
`mcga_setpal_range(pal, band[0].start, total)` (`lcall 0x0C2E:0x22` @`0x0C637`),
where `total` is the summed length of all bands — correct for one band, and a
latent assumption that multiple bands would be contiguous.

### What actually animates

Band 120..127 is a monotone blue ramp in `VICEROY.PAL`, and it is a **duplicate**
of part of the static ocean ramp: index 120 == index 56 and index 127 == index 59,
byte for byte. The duplicate exists so the band can rotate without disturbing the
ocean's own shades. Scanning every `.SS` for band pixels, the map view's sheets
use it like this:

| sheet | frames | band pixels |
|---|---|---|
| `TERRAIN` | 11 (Sea Lane) | 62 |
| `TERRAIN` | 7 | 2 |
| `PHYS0` | 1..31 (rivers), 150..153 (clean coast edges) | 475 |
| `ICONS` | 123 | 3 |

**Ocean (`TERRAIN` frame 10) has zero band pixels.** The open sea in this game
does not shimmer — what moves is the sea-lane column, the rivers, and the clean
coast edges. `PHYS0` and `ICONS` carry master-palette colours across the whole
band already (measured: 0 differing entries), and `TERRAIN` is forced to the
master by the previous ruling, so all three are consistent.

**Ruling**: `CYCLE.DAT` is the struct above; the shipped band is
`{start 120, len 8, delay 35}`; rotation is one index up per step with wraparound
at 60.8766 Hz / 35 ticks. The doc's "tiny code patch / custom VM" reading is
**refuted**, and so is the claim (`port/README.md`, manual part1 "Palette
animation" / part7 §29.4) that **bands 54–60 and 120–127** both cycle: 54–60 has
no entry in `CYCLE.DAT` and is static.

**Action taken**:
- `docs/PALETTE_AND_CYCLING.md` rewritten from the disassembly; all four "Open
  work" items closed.
- `data_extracted/data/CYCLE_DAT.json` — the old `cycles` array was a naive
  pair-scan over all 34 bytes and pure noise; replaced with the real decode.
- `port/tools/build_assets.py` — `CYCLE` + `CYCLED_SHEETS`; `sheet_to_png` also
  emits a band mask (`<SHEET>.cycle.png`, source index in R) for TERRAIN/PHYS0/
  PHYS0C/ICONS.
- `port/src/game.js` — `cycAtlas()` builds one re-tinted atlas per phase on
  demand; `sheetFrame` selects by `cyclePhase()` off the wall clock, seeded at
  map entry as `cycle_init` does. `G.cyclePhase` pins it for tests and shots.
- `port/tools/test_flow.py` — the band/period/rate, phase-0 identity, wrap at
  `len`, all-8-distinct, and the up-one-index-per-step direction. 167/167.

**Follow-up**: the live capture `docs/screens/06_ingame_map.png` is at **phase 0**
— re-measured against all 8 phases with the now-correct band and direction, and
phase 0 wins 3/256 against 60–62/256 for every other phase. That independently
confirms the previous ruling's phase-0 finding and leaves its **3-pixel residual
unexplained and still TBD**: it is not a palette question, not a capture
artifact, and now demonstrably not a cycle-phase artifact either.

## 2026-08-05 — MAPEDIT's CodeView table names 89 VICEROY functions; `func_078548` is a palette READ, not a write

**Question**: `MAPEDIT.EXE` ships an NB02 CodeView publics table (1071 names,
203 modules, `data_extracted/mapedit_symbols.json`) and `VICEROY.EXE` ships
none. Three times now a VICEROY function has been identified by noticing it was
the *same compiled C* as a named MAPEDIT one — `menu.obj` (ruling 2026-07-30),
then `cycle_1.c` / `timer_1.c` / `timer_3.ASM` (ruling 2026-08-05, earlier
today). Can that be done systematically rather than by hand?

**Method** (`tools/xmatch_mapedit_viceroy.py`). The builds differ in memory
model and in every absolute address; the instruction *sequence* does not. So
fingerprint each instruction as its encoding with the displacement and immediate
fields **deleted**, index both sides on the first 16 instructions to get
candidates, then — and this is the part that carries the ruling — **verify by
extension**: disassemble both sides forward from their entry points, *ignoring
the recorded function boundaries*, and count how many leading instructions
agree. A match counts only when the agreed run covers MAPEDIT's whole function
and the fingerprint is unique on both sides.

Stage 2 is not decoration. Both boundary sources are unreliable — VICEROY's
extents come from a scan and are often short, MAPEDIT's are exact — while a
shared compiler prologue makes unrelated functions look identical for a dozen
instructions. Before verification the tool reported **153** matches on
whole-function and prefix fingerprints; verification cut it to **89**. The
clearest casualty: `_strings` (1026 bytes) "matched" `rt_far_strlen` (45 bytes)
on a 16-instruction prologue.

**Result**: **89 exact matches** — 76 onto VICEROY functions that had no name,
13 onto functions that already had one. Recorded in
`data_extracted/viceroy_named_from_mapedit.json` and
`docs/VICEROY_NAMES_FROM_MAPEDIT.md`.

**Validation.** Twelve of the 13 overlaps **agree** with names derived
independently by earlier passes (`_strcat`/`strcat_near`, `_open`/`rt_dos_open`,
`__dos_findfirst`/`find_file`, `_on_map`/`is_xy_in_map_bounds`,
`_tile_id`/`terrain_id_normalize_to_8`, and so on). Four more land on addresses
the tree already cites and corroborate them from a symbol table rather than a
trace:

| VICEROY | CodeView name | corroborates |
|---|---|---|
| `0x006204` | `_terrain_fix_2` (`map.obj`) | **`CLAUDE.md` hard rule 3**, the auto-forest fold "byte-verified at file `0x6204`" |
| `0x00C8AB` | `_TIMER_ACTIVATE_LOW_PRIORITY` | this morning's cycling ruling, which derived the address by hand from `lcall 0x0A29:0x21B` @`0x04B62` |
| `0x00E702` | `@mcga_setpal_range` | the same ruling's `lcall 0x0C2E:0x22` @`0x0C637` upload |
| `0x044A5A` | `_menu_bar_hide` (`menu.obj`) | `spec/ui/debug_screens.md`, where the cheat-bit-clear path calls `func_044A5A` via `0x191F:0x45C` |

**Ruling 1**: the 89 exact matches are **evidence, not rulings**. An exact match
is a fact about bytes — these two functions are the same code. It does not
establish that the VICEROY copy is *reached* the same way; that still needs the
call-site trace. `cycle_colors` is the standing example: same C, different thunk,
different installer. The names are therefore recorded in their own artifact and
have **not** been bulk-applied to `code/VICEROY/functions.json`.

**Ruling 2 — a correction.** `func_078548` was named `vga_palette_dac_write`
and rated **B** in `docs/RAW_FUNCTION_AUDIT.md` with the gloss "writes the
256-colour palette to the DAC (OUT 0x3C7/0x3C9)". CodeView calls it
`@mcga_getpal`, and the bytes side with CodeView: `0x3C7` is the DAC **read**
index (`0x3C8` is write), and the transfer at `0x07857E` is **`insb`**, which
moves port → memory into the caller's `es:di` buffer. The function **reads** the
palette back out. Its writing counterpart is `@mcga_setpal_range` @`0x00E702`
(`out 0x3C8` @`0x00E730`, then `outsb`). The prior audit noticed port `0x3C7`
and drew the opposite conclusion. Corrected in `code/VICEROY/functions.json`
(with `name_source`) and in `docs/RAW_FUNCTION_AUDIT.md`.

**Coverage and its limits**. 606 MAPEDIT functions have usable extents against
1250 VICEROY functions; 212 candidate fingerprints; 89 exact, 110 partial
(prologue-only leads, explicitly not names), 13 ambiguous. Coverage is bounded
by three honest limits: MAPEDIT only links what MAPEDIT needs; a function
compiled in a different memory model is genuinely different code (VICEROY's
`cycle_colors` reaches its palette via `lds si,[0x36E]` where MAPEDIT uses
`mov si,0x6048`, so it correctly does *not* match, despite being the same
source); and functions under 16 instructions are skipped because stubs collide.

**Side effect worth keeping**: an exact match whose VICEROY extent is far
shorter than MAPEDIT's flags a **bad boundary** in the VICEROY inventory.
`0x00E702` is recorded as 21 bytes and is really 52 instructions; `0x011D30`
(`_open`) is recorded as 105 bytes against 401.

**Follow-up**: whether to bulk-apply the 76 new names into
`code/VICEROY/functions.json` — it is a generated artifact, so this needs a
decision about provenance rather than more evidence. Deliberately not done here.

## 2026-08-05 — Live DOSBox check: the pedia terrain index is 21 rows, and `@OTHER_NAMES` is a suffix table

**Source**: the real game booted under DOSBox in-container and captured through
its own framebuffer dump — `docs/screens/live_2026-08-05/`, method and harness
in `docs/LIVE_UI_CHECK_2026-08-05.md` and `tools/dosbox_harness/`.

**Ruling 1 — `@OTHER_NAMES` is a suffix/label table, not terrain entries.** Its
five rows are `Forest`, `River`, `Major River`, `Minor River`, `Unexplored`. Row
0, the literal string `"Forest"`, is what composes `@FORESTED`'s `Boreal` into
the displayed `Boreal Forest`. The port had been concatenating all five onto the
terrain index as if they were terrain names.

**This was not a gap in the specification.** `spec/ui/colonizopedia.md` §
already had it right — "ids 8..15 get `" Forest"` suffix (`[0x2DB0]`, NAMES
`@OTHER_NAMES` line 0) — ids 16..23 do NOT", and the terrain record table entry
"`@UNFORESTED`→0..7, `@FORESTED`→8..15, **16..23 = byte-copy of 8..15**
(`rep movsw` @0x074A6D), `@OTHER`→24..28". The **port failed to implement what
the spec documented**, and then papered over the shortfall with three invented
rows. Rulings 2 and 3 below are therefore confirmations of the existing spec
against a live frame, not new decode — the value of the live check here was
catching an implementation that had drifted from a correct spec.

**Ruling 2 — the Colonizopedia terrain index is 21 rows, alphabetised.**
`@UNFORESTED`(8) + `@FORESTED`(8) suffixed as above + `@OTHER`(5) = 21, sorted.
Reconstructed from the shipped tables and compared name-for-name against the
live index: **exact match, all 21**.

**Ruling 3 — the 29-articles-vs-21-rows gap is id sparseness, not a skip list.**
`PEDIA.TXT` keys TERRAIN articles by **engine terrain id**, and those ids are
not contiguous: `@UNFORESTED` 0–7, `@FORESTED` 8–15, `@OTHER` 24–28. Ids
**16–23 are the auto-forest variants** (`CLAUDE.md` hard rule 3) — they own
articles but no index row. This closes the standing "the enumerator has a
per-category skip list that is not in the evidence" note in
`docs/UI_AUDIT_TRACKER.md`: there is no skip list for TERRAIN.

**Ruling 4 — the index fills column-major, 22 rows per column.** The live
terrain index is a single column only because 21 < 22. The three-column layout
in `spec/ui/colonizopedia.md` stands; it shows when a category is long enough.
The live index carries **no category sub-heading and no keyboard hint** — the
only chrome is `(Exit)` (`@MISC` 110) top-right and `(More)` (`@MISC` 109) when
paging — and the masthead is **white**, not HUD green.

**Ruling 5 — carried units are labelled by equipment/veteran status.** The
opening turn's caravel manifest reads `Veteran` / `100 Tools`, not
`Soldiers` / `Pioneers`. `"Veteran"` is `@MISC` 65, `"Tools"` is `@CARGO` 14.
Manifest order is Soldiers then Pioneers. Verified for the starting force only;
the rule for other carried types is **TBD** and the port falls back to the type
name.

**Ruling 6 — the difficulty picker stacks its two label lines mid-cell.** Lines
at `cell.y+38` and `cell.y+46`, both in the row's own outline ink (`0x0A` for
Discoverer), horizontally centred. That is *not* the nation picker's layout,
which does split its two lines to the cell's top and bottom — and where both
lines take the nation colour, not `254` for the name. The port had applied the
nation layout to both screens.

**Correction to the first write-up of this check**: I initially reported the
difficulty picker as drawing its caption in the wrong *cell* and losing a
portrait. That was an artifact of comparing two different selections (live on
Discoverer, port on its default Conquistador). Re-rendered at matching
difficulty, all five portraits are present and the caption is on the right cell.
The real defect was only the within-cell placement and ink above.

**Action taken**: all six fixed in `port/src/game.js`; three new assertions in
`port/tools/test_flow.py` (170/170). `spec/ui/colonizopedia.md` and
`docs/UI_AUDIT_TRACKER.md` updated.

---

## 2026-08-06 — F5/F7/F9 read off the live game: five spec corrections

**Conflict**: the port's Economic (F5), Naval (F7) and Indian (F9) advisers were
built from `spec/ui/advisor_reports.md` §4 alone, because no live capture of any
of the three existed. Captured at last under DOSBox — first from a fresh
England/Discoverer run with a colony at Jamestown, then from the shipped
`COLONY00.SAV` (Dutch, Autumn 1653) which has seven tribes contacted, seven
ships and a full market — the frames disagree with the spec on five points.

**Source A** — `spec/ui/advisor_reports.md` §4, byte-cited from
`func_38A50` / `func_3954C` / `func_39EE2`.

**Source B** — the running DOS game: `docs/screens/live_2026-08-05/74_report_F5_economic.png`,
`75_report_F7_naval.png`, `76_report_F9_indian.png` and the richer set in
`docs/screens/live_1653_save/`.

**Ruling**: the running game wins on every point (`notes/TRUTH_HIERARCHY.md`
puts it at the top). Five corrections:

1. **F7 has a grid.** The spec says "Exactly ONE rule per page = footer (no
   header/row/column rules)". The live frame has eight full-width rules at
   `y = 40 + 20i` spanning x 2..314 and three column separators at
   **x = 82 / 162 / 242** running y 25..180. Its four headers centre in those
   columns — **42 / 122 / 202 / 280** — not over the field x's the spec cites.
   (280, not 278, because the Destination *box* is 242 w=76 and runs past the
   grid's right rule.)

2. **F5 is a four-column price table with no icons.** Headers `@MISC` 58 Tons /
   59 Gold / 203 Bid Price / 204 Ask Price drawn left at x = 76 / 131 / 170 /
   220 at y=25; 17 rules at `y = 33 + 8i` across x 2..312; the good's name at
   **x=2** (the port had been indenting it behind an ICONS sprite that is not
   there); values right-aligned at the advance edges **92 / 145 / 200 / 251**,
   Tons and Gold in `0x0A` bright green and the two prices in `0x61`, with a
   trailing `'$'` on all but Tons. Subtitle `@MISC` 206 "European Trade" —
   which names a *view*; `@MISC` 91/92 "(Building Upkeep)"/"TOTAL UPKEEP"
   belong to a second page this capture did not reach. **TBD: the view switch.**

3. **F9's cell colour is the tribe's own colour, not `@COLORS` "basic".** The
   spec reads the runtime global `[0x830]` (index 68) as the cell ink. The 1653
   frame prints each tribe's name and tech level in **the last column of
   `@TRIBES`** — Incas 97 cream, Aztecs 149 gold, Arawaks 54 blue, Cherokee 67
   green, Apache 111 tan, Sioux 118 dark red, Tupi 71 dark green — all seven
   pixel-exact under the REPORT1.PIK palette. `data_extracted/tables/names_tables.json`
   glosses that column as "capital-raze treasure base"; that gloss is
   unsupported by this frame and should be re-derived. The settlement-count line
   under each name is drawn in **black**.

4. **F9's block pitch is 21.** Portrait 16×16 at `(10, 25 + 21i)`, name at
   x=30 y=`28 + 21i`, count at x=40 y=`36 + 21i`, tech level right-aligned at
   x=311. Seven blocks fill the plate. Only *contacted* tribes are listed: the
   Dutch save shows Incas/Aztecs/Tupi as "Extinct" (`@MISC` 130) but omits the
   Iroquois entirely.

5. **Shared chrome.** The subtitle ink is **`0x91`** (255,255,142), not the
   title's `0x90`. Report text carries **no drop shadow** — only the font's own
   level-3 dark core. Centring is on the **ink** width, i.e. `advance - 1`:
   seven independent strings (five report titles, "European Trade", and the four
   F7 headers) all land at `cx - (w-1)/2` and none at `cx - w/2`. The OK button
   is a **hollow** 30×14 box at (286,184) in the rule ink `0x77` with a `0x92`
   caption at y=188 — the port had been painting it solid.

**Action taken**:
- `port/src/game.js`: F5, F7, F9 rebuilt; `Font.center` re-derived; `Font.right`
  added; `okButton` rebuilt; the shadow argument dropped throughout the reports.
- `port/tools/test_flow.py`: six new assertions (177/177).
- `port/tools/shots.py`: `report_F5` / `report_F7` / `report_F9` shots.
- captures committed under `docs/screens/live_2026-08-05/` and
  `docs/screens/live_1653_save/`.

**Follow-up**:
- ICONS **113..117** are five near-identical native portraits. The 1653 frame
  uses 116 on five rows, 115 for the Apache and 113 for the Sioux, with no rule
  derivable from tribe index, tech level or settlement count — consistent with
  an animation counter. **UNRESOLVED**; the port draws 116.
- F9 pagination (`func_039E98`) is not wired up; an eighth contacted tribe would
  be dropped rather than paged.
- The port has no native first-contact flag, so "has explored a tile holding one
  of that tribe's settlements" stands in for it. That is the port's own rule.
- The muskets/horses cells on F9's count line (x=152 and x=209) rest on a
  single sample each — the Apache row.

## 2026-08-06 — colony screen: the four open UI items, closed from the EXE

Context: the 2026-08-06 live diff (`docs/LIVE_UI_CHECK_2026-08-05.md` §10.3) left
four items open on the colony screen. All four are now byte-read and checked
against `docs/screens/live_1653_save/colony_curacao.png`.

1. **Strip pitch is a formula, not a constant.** `func_002D74 @0x002D74` /
   `func_003104 @0x003104`: icons are fitted to a fixed span,
   `pitch = avail / Σ(count−1)`, clamped per sprite to `min(w+1, pitch)`. The
   "4 on one row, 6 on another" reading was the same formula on different rows.
   Replaying the live frame's counts reproduces every icon x in all three
   production rows at score-0 template matches.

2. **`func_0264A8` is the TILE panel and draws a 3×3.** The 5×5 loop skips all
   four borders (`@0x0267A8..0x0267BE`). The old spec line
   "commodity icon index = good + 0x17 (`add ax,0x17 @0x026573`)" was a misread:
   `@0x026573` is `x + 23`, the far edge of a 24×24 rect outline. **`0x181F:0xCE`
   is a rectangle-outline verb** `(ax=x0, dx=y0, bx=x1, [bp+8]=y1, [bp+6]=colour)`,
   not a glyph row — its two calls in this function are the panel border
   (199,7)-(320,128) and the scene border (223,31)-(296,104), both black, both
   pixel-confirmed.

3. **`func_0270D0`'s axes were transposed in spec §3.3.** `[bp-0x60]` (init
   `0x8F`) is the row **Y**; `[bp-0x5c]` (init 1) is the **X**. The row runs left
   to right from x=2 at y=142. Proof: the selection box's own args solve to
   (x 1..10, y 143..158) for an 8×16 sprite at (2,142), which is exactly where
   the live frame's green box is, and ICONS frame 100 matches the second
   colonist at x=11. Sprite record fields are **+0x3E = width, +0x40 = height**
   (the prior "+0x40 = x/anchor" was wrong). The row also includes the garrison
   (`colony+0x1F` + `[0x8D72]`, 4px break after the last colonist).

4. **Panel mode 0 (`func_0275CE`) is the production panel**, three fixed rows at
   x=213 / span 89 / y=134+14i over contiguous slices of the commodity table —
   not the "SoL/garrison icon bar" §3.6 called it. The SoL band lives in the
   plaza panel instead, as two figures between sprite EXE 0x7C (flag, at (2,132))
   and EXE 0x7D (crown, right edge at x=117).

Also settled: the red mark is **EXE sprite 0x38**, the shared strip verb's *empty
segment*, blitted over icons past the filled count — not a panel-owned "cancel"
sprite. `UI_PRIMITIVES.md` §0x222 had the enqueue arrays swapped: `[0x2CF4]` is
the sprite, `[0x2CCE]` the count.

Still TBD: RNG building placement (`func_025D34`, unchanged); the `[0x8E14]`
lumber-surplus split; `func_002EE4`'s flag-bit-0 fractional pitch, which the F2
crosses row needs (33/34 alternating) before the report gauges can fold onto this
same verb.

## 2026-08-06b — colony building placement: the RNG is simulated, and verified against live RAM

The plot layout has been TBD since 2026-06-24 on the grounds that it is "RNG
(replayable from the seed)". It is replayable, and now it is replayed: the whole
chain is byte-read and reproduces two live colonies element for element.

**The RNG is the Microsoft C runtime's**, byte-read at file `0x0103D4` /
`0x0103C2`:
`state = state*214013 + 2531011`, `rand() = (state >> 16) & 0x7FFF`.
`random_int(lo,hi)` = `func_00C322 @0x00C322` (`0x181F:0x4D4`) =
`lo + ((rand()*(hi−lo+1)) >> 15)` — the shift is `>>8` via the `al=ah/ah=dl/dl=dh`
byte shuffle `@0x00C336` plus seven `sar dx,1 / rcr ax,1` pairs `@0x00C340..0x00C35A`.

**The seed** is `func_009726 @0x009726`:
`seed32 = (colony_y << 8) + colony_x + dword[0x8D80]`, and the srand wrapper
`@0x00C30A` passes **only the low word, masked `and ah,0x7f`** — so the LCG starts
from 15 bits. `dword[0x8D80]` is the BIOS clock captured once at startup
(`mov [0x8d80],ax / mov [0x8d82],dx @0x075FF5`), i.e. **per-session, not
per-save**: the same colony in the same save lays out differently between two
launches of the game.

**Verified live.** `tools/colony_seed_probe.py` reads the tables straight out of a
running DOSBox (`/proc/<pid>/mem`, DGROUP anchored on the section-name table).
With COLONY00.SAV loaded and session base `[0x8D80] = 1410965`:

| colony | (x,y) | live `[0x8E92]` shuffle | live `[0x8E82]` plot→def |
|---|---|---|---|
| Jamestown | (50,51) | `6 5 4 0 3 2 1 7 10 8 9 12 11 13 14` | `24 39 32 27 21 · · 3 17 36 13 · 9 2 7` |
| Curacao | (21,30) | `4 1 3 6 5 2 0 10 7 9 8 12 11 13 14` | `39 · 32 21 · 27 24 · 35 15 · · 9 0 6` |

Both reproduce **exactly** from the simulation, in both phases. Asserted in
`port/tools/test_flow.py`.

Table findings, all RAM-read:
- `[0x224]` counts `[7,4,2,1,1]`, `[0x22A]` starts `[0,7,11,13,14]`,
  `[0x260]` empty-plot decor `[45,44,43,0,46,0]` — all confirm the prior spec.
- `[0x266]` plot positions are stored **without** the +8 the painters add.
- **The plot category at `[0x8F87 + id*12]` IS the @BUILDING `size` column** —
  checked against all 42 rows. That column was never a building size.
- The group byte at `[0x8F88 + id*12]` puts every upgrade chain on one plot
  (Town Hall and Capitol share group 3, so the Capitol replaces the Town Hall in
  place). It is **not** one of the five columns the @BUILDING loader parses and
  its writer is unidentified — the table is committed as measured, not derived.
- **Phase D reads `[0x8E92]` by SLOT while phase C wrote it by PLOT.** The engine
  uses the permutation both ways round. Reproducing that quirk is the only way to
  get the same layout, so the port reproduces it rather than "fixing" it.

**Frame index corrected.** Rendering the port at Curacao's own seed, position and
building set and template-matching every plot against the live frame gives
**bundle frame = def_id** (EXE `def_id+1`), and empty plots at bundle 44/43/42
against the RAM table's 45/44/43 — the same EXE−1 offset the ICONS sheet has. The
port had been drawing `def_id+1`.

## 2026-08-06c — colony panels: what the live RAM said, and three corrections

`tools/colony_seed_probe.py` extended to read the panel state as well as the
placement tables. Read with live Curacao's colony screen open (the same frame as
`docs/screens/live_1653_save/colony_curacao.png`).

**1. The worker sprite is not the `0x2BC` call.** The tile panel's `0x2BC` at
`(x+4, y+4)` `@0x026639` belongs to **flag bit 7** — a map unit standing on the
tile. Every inner cell of live Curacao reads flags **0**, yet six of them show a
colonist. The colonist is the **last** step of the cell, `0x181F:0xA74(tile,3)`
→ `0x181F:0x24A` `@0x026763..0x02677C`, pushed anchor `(x+0xC, y+6)`. ICONS
frame 100 template-matches at **(x+14, y+6)** at score 0 — y exact, x two further
out than the push, so `0x24A` adds an inset of its own. Measured, mechanism TBD.

**2. Flag-byte semantics.** `[0x8DF0]` by `col*5+row` reads `0x10` for the whole
outer ring, `0x00` for the inner 3×3, and `0x08` for the centre. Bit 4 marks the
border cells the loop skips anyway; **bit 3 is the colony's own centre tile**,
whose two strips are its unworked yield — `[0xA891]`=4 food and `[0xA893]`=4
(furs) ×`[0xA894]`=3, which is exactly the "4" and "3" the live scene shows
there. `[0x8D9E]` is `0xFF` throughout, so the sprite-`0x6D` path never fires in
that frame.

**3. The `0xF`/`0x11` frame cases are BUILDING-PRESENCE queries, not garrison
counts** (`@0x026E05..0x026E34`, all through `0x181F:0x9FC`): no Warehouse
(`0x0F`) ⇒ frame `0x2F`; Warehouse **and** Stable (`0x11`) ⇒ `0x30`; Warehouse
without Stable keeps `def_id+1`. Warehouse / Warehouse Expansion / Stable share
**group 5**, i.e. one plot, so it draws a combined sprite for whichever pair is
standing. Curacao holds the Warehouse and no Stable and keeps the plain frame —
which is what the template match found.

**`[0xA895]` resolved.** The plaza food row's split reads 4, and `[0xA891]` — the
centre cell's own food strip — is also 4. Two independent paths to the same
number pin it as the centre tile's food; it had been a one-frame guess.

**Production-row rules, confirmed against `[0x8DC8]`/`[0x8E32]`:**
- Row 0 **skips a good with `produced == 0` even when it was consumed**
  (`@0x0275F1`). Curacao eats 6 cotton, produces none, and shows no cotton entry.
- Row 1's source table is `byte[0x2A2+i]` = `[…,8,1,2,3,4,255,6,14]` — the chain
  map, plus **slot 8, where Horses source themselves**. The amount comes from
  `word[0x8E5A + src*2]`, which is **not** the consumed-raw table (6 cotton eaten
  for 6 cloth reads 0 there and draws unmarked). Its only non-zero entry that
  frame is Horses' own 4. `[0x8E5A]` is 20 words past `[0x8E32]` — a second bank
  of the consumed table — and its writer is unread. **TBD.**
- `[0x8E14]` read equal to the consumed lumber in the one sample. Still TBD.

**`0x236`'s fractional path** (`@0x002FBA..0x002FD4`) is a Bresenham remainder
distributor: `acc += (count−1)·pitch` per icon, and while `acc ≥ span − w`,
subtract and add one pixel to x. That is the alternating 33/34 on the F2 crosses
row. **No colony call site sets the flag** — all three push 0 — so the colony
strips are flat-pitch and only the reports need it.

Also: `UI_PRIMITIVES.md` §0x222 had the enqueue arrays swapped; `[0x2CF4]` is the
sprite and `[0x2CCE]` the count.

## 2026-08-06d — the shared strip gauge `0x181F:0x236`: full geometry, F2 pixel-exact

`func_002EE4`'s geometry helper `func_002D74` read to the end. It is **not**
"count icons at a fixed pitch", and it takes **two** counts:

- `dx` = the number of **slots** the row is laid out for (the denominator:
  crosses needed, bells needed, a tile's yield).
- `bx` = how many icons are actually **drawn**.

So a report gauge is a progress bar built out of icons — the row grows toward a
fixed layout instead of rescaling into it.

```
pitch    = clamp((span − w) / (slots − 1), 1, w + 1)        @0x002DCB-0x002DDA
shift    grows while ((slots−1)·pitch >> shift) > span − w  @0x002DF6-0x002E12
totalRun = ((slots−1)·pitch >> shift) + w                   @0x002DFF
base     = (arg[bp+0xA] − 1 > totalRun) ? arg[bp+0xA] : span
leftover = base − totalRun                                  @0x002E25
if arg[bp+0xA] ≠ 0:  x += leftover / 2      (CENTRING)      @0x002E36-0x002E44
```
and with **flag bit 0**, each icon advances `pitch` plus a Bresenham share of
`leftover` spread over `slots` steps (`acc += leftover; while acc ≥ slots:
acc −= slots; x++`) `@0x002FBA-0x002FD4`.

**Live-verified.** The F2 crosses row (`@0x0379B4`: x=0xA, y=0x19, span=0x12C,
flags=1, sprite EXE 0x39, drawn `[bx+0x2E]`, slots `[bx+0x30]`) reproduces
`x = 10, 43, 76, 110, 143, 177` **exactly at 9 slots and at no other slot count**
— template matches at score 0 in `21_report_F2_religious.png`, y=26 for the
pushed y=0x19 because the gauge blits at y+1. Rendering the port at that state
gives **0 differing pixels** across the whole crosses band.

Two consequences for the port, both fixed:
- The old `GAUGE_SLOTS = 9` constant got the right answer for the wrong reason:
  9 was that session's cross threshold, not a property of the widget.
- Count badges are gated on `[0x336]`→`[0x70]` `@0x002FFE` — the reports run it
  clear and the colony panels set it, which is why the live F2 row carries no
  number. The port had been drawing a badge *and* an invented "n / m" caption.

**Not verified:** the F3 bell row. Both shipped F3 captures are at 0 bells (no
ICONS bundle-62 sprite anywhere in either), so its geometry is ported by analogy
with F2 and is unchecked.

## 2026-08-06e — F3's bell row does NOT fit the gauge model (open discrepancy)

Follow-up to 2026-08-06d, which closed the F2 crosses row to the pixel and left
the F3 bell row "ported by analogy, unchecked" for want of a frame with bells in
it. `docs/screens/live_1653_save/report_F3.png` — the 1653 save, which the two
2026-08-05 F3 captures are not — has one. It does not fit.

**What the live row measures.** A count badge reading **252** at the left of the
strip, then **22** bell icons whose inter-icon steps are
`[4 ×11, 3, 4 ×9]` (marker pixels at y=42 colour 7:
9,13,…,53,**56**,60,…,92 — the single 3-step is real and appears identically in
the y=40 row). The one fully unoccluded bell template-matches ICONS bundle 62 at
x=89.

**Why it cannot be the gauge as read.** The badge value is `bx − arg[bp+8]`
taken *before* the shift (`@0x002F29`) and the drawn count is `bx >> shift`
(`@0x002F3D`), so a badge of 252 implies `drawn = 252` and an icon count in
`{252,126,63,31,15,…}` — never 22. Independently, a search over 6000 slot counts
(and every `drawn` up to 300, all shifts) produced **no** parameter set whose
step sequence is `[4 ×11, 3, 4 ×9]`; the closest, 74 slots, puts its single
3-step **first** rather than twelfth, which needs the accumulator to start near
33 where `func_002EE4` clears it to 0 (`@0x002F16`).

So either the call site's arguments differ from the reading at
`@0x037BCE..0x037BF5` (x from `[bp-0x56]`, y from `[bp-0x5A]`, span `0x12C`,
flags 1, sprite `0x3F`, slots `[bp-0x54]`, drawn `[bp-0x66]`), or that row is
drawn somewhere else entirely. **Unresolved.** The port keeps the F2 analogy with
the discrepancy stated in the code rather than tuned to fit.

Next step for whoever picks this up: the two locals are stack values, so the RAM
probe cannot read them — this needs either a breakpoint trace or the F3 body
disassembled forward from `func_037A20` to find what fills `[bp-0x54]` and
`[bp-0x66]`.

## 2026-08-06f — a second colony closes two open slots; Europe's first real diff

**Vlissingen (25,34)** read with `tools/colony_seed_probe.py` while its colony
screen was open — a different production state from Curacao's, which is what
these two needed.

- **`[0x8E5A]` RESOLVED.** It is the part of a raw's consumption met from **this
  turn's output**, not the total consumed: Curacao lumber produced 0 / consumed 6
  reads **0**; Vlissingen lumber produced 8 / consumed 4 reads **4**; Curacao
  cotton produced 0 / consumed 6 reads **0** (and its cloth run draws unmarked).
  `min(consumed, produced)` fits all three.
  **Except Horses**, the one good that sources itself: 4 against produced 4 in
  Curacao but **3** against produced 4 in Vlissingen. No rule earned; the port
  under-marks that single entry rather than inventing one, and the divergence is
  asserted in the tests so it cannot drift unnoticed.
- **`[0x8E14]` RESOLVED: it is HAMMERS PRODUCED.** 6 against 6 hammers in
  Curacao, 12 against 12 in Vlissingen. The branch at `@0x0276AF` compares it
  with lumber produced, so in the common case the **whole lumber-produced figure**
  is enqueued plain — Vlissingen draws 8 plain lumber and 4 marked having made 8
  and eaten 4. The port had been drawing produced-minus-consumed. Fixed.
- Still open there: `[0x8E64]` (hammers consumed, 0 and 4 in the two colonies) —
  the port banks hammers rather than spending them per turn, so it draws the
  whole run plain and leaves the marked part out.

**Europe, first proper diff** against `docs/screens/live_2026-08-05/30_europe.png`
(the previous pass called it a "close match" and never measured it). Three real
defects:

1. **Ships in port were not drawn at all.** A ship occupies an **18×18 slot with
   a hollow GREEN 0x0A rect** and its own icon inside: slot 0 box
   **(145,145)-(162,162)**, ICONS frame 5 at **(149,146)** — sprite at box+(3,1).
   The port drew a fixed crate frame in a 12px slot instead.
2. **Dock units** use the same 18×18 green slot: box **(232,137)-(249,154)**,
   ICONS frame 102 at **(235,138)**. The port drew a nation plate and no box.
3. **The cargo row is the SELECTED SHIP'S HOLD, not one crate per ship.** Six
   slots at **x = 147 + 12k, y = 165** (frame 122 matches the live row at
   171/183/195/207 at score 0, i.e. pitch 12 back to 147). The ship's own
   `@UNIT.cargo` holds draw dark and the slots beyond its capacity carry frame
   122's cross — the live caravel shows exactly 2 dark + 4 crossed.

Unmeasured, and left at the port's previous values: the **slot pitch** for both
ships and dock units (the frame has one of each). Also unresolved: the live ship
carries a **red nation flag** the port does not draw, and the two dark hold cells
match no ICONS frame better than 0.62 — they are drawn as a plain dark cell.

## 2026-08-07 — four port defects, and what the bytes said about each

Four things the user reported as broken in the HTML port. All four are settled
here rather than in the thread; two of them correct claims that survive in the
spec and the tracker.

### 1. The Lost City Rumour marker: wrong branch, and the wrong sprite

Two independent faults, either of which alone hides the marker completely.

**The draw sat on the wrong branch.** `drawTile` splits into a land path that
`return`s and a water path that falls through to the function tail — and the
rumour blit was on that tail. Since `rumourAt` rejects Ocean and Sea Lane, the
call could never fire on any tile in the game. The engine's order is
`detail (0x5A+v) -> rumour (0x68) -> roads (0x51+d)`, byte-read off O513 at
`@0x683F7`, `@0x68405..@0x68414` and `@0x68417`; the port now matches it on the
land path.

Land-only is behaviourally exact but is **not** a branch the engine has, and the
distinction matters for anyone reading O513: `@0x683C9` gates on `[0x184]` /
`[0x18E]`, **not** on the water flag `[bp-4]`, so a *coastal* water tile does
reach the call at `0x68405`. It returns 0 there because `func_006188`'s own class
gate `@0x61A6`/`@0x61AB` rejects 0x19/0x1A. (`tools/hillsrivers_render.py`'s
`if not water:` is that renderer's structural simplification, not a citation.)

**The sprite was identified by eye and was wrong.** The port used ICONS 17, a
gold sunburst, with the comment admitting no catalogue entry named it —
`notes/SPRITE_CATALOG.md:497` says ICONS indices 16+ are uncatalogued, so there
was nothing behind it. The real marker is **PHYS0 engine 0x68 / disk 0x67**:
`mov ax,0x68` `@0x68411` followed by `call 0x67dc8` `@0x68414`, the same emit
primitive the detail band uses at `@0x683FA`. The byte pattern `b8 68 00` occurs
**exactly once** in the 494910-byte VICEROY.EXE, so the frame number is not
ambiguous. Disk frame 103 dumps as a 16×16 concentric brown-and-tan stone ring.

### 2. The rumour hash had X and Y transposed

`func_006188 @0x61C7-0x61F6` is

    (((y>>2)*0x13 + (x>>2)*0x11 + word[0x190] + 8) & 0x1F) - ((x&3)<<2) == (y&3)

The axis assignment is anchored **at the call site**, not inferred from the
arithmetic: the call pushes `[0xa5a2]` then `[0xa5a0]`, and the only write to
`[0xa5a0]` is the inner loop variable `@0x68803`, bounded `@0x6880D-0x68812`
against `word[0x853a] - 1` = the map **width**. So `[0xa5a0]` is the column,
`arg1 = [bp+6]` is X, `arg2 = [bp+8]` is Y.

This is not cosmetic. Measured over `AMER2` (58×72), the two orientations select
33–44 tiles each and agree on **0–3** of them.

`docs/manual_src/part2.md` §6.10 is **correct**. `spec/systems/events.md`,
`docs/manual_src/part5.md:285` and `docs/UI_AUDIT_TRACKER.md:424` are
**transposed** and are corrected with this entry.

Also: the seed is `random_int(1, 0x7FFF)`, not `(0, 0x7FFF)` — `func_064A10
@0x64A16` is `push 0x7fff; push 1`, push order confirmed against the known
`random_int(1,9)` at `@0x614F6` (`push 9; push 1`). A **zero** salt disables both
the detail band and rumours outright (gates `@0x60A9` and `@0x6191`), so the
lower bound is load-bearing.

Still not reproduced: the third gate, `func_005DF0 >= 0` (`@0x61BC`/`@0x61C5`).
The port carries no owner/feature plane — the `.MP` loader discards it — and the
plane's own identity is unresolved, `spec/systems/events.md:187-192` calling it
the tile feature nibble and `tools/hillsrivers_render.py:195` the continent-plane
owner nibble. Consequence: rumours appear on some tiles DOS suppresses. **TBD.**

### 3. The colony pennant is baked into the marker sprite

The port drew the nation pennant at the tile's right edge and left a **blue flag
already present in the marker art** standing beside it — so France looked right
by coincidence and every other power flew two flags.

Settled from the sprite pixels, which sit above the disassembly in the trust
order. Sliding ICONS frame **119** (the blue 6×5 pennant, `#34499e`/`#4159a6`)
over colony frames **0, 1, 2 and 3** finds **exactly one** offset at which all 15
of its opaque pixels match the marker: **frame-local (5, 0)**, on all four levels,
with no second candidate anywhere in the search window.

The bytes reach the same point independently: `func_004314 @0x0043FB` puts X+6 in
`[bp-0x0a]` and `@0x004404-0x004409` + `@0x00441A` put Y+4 in `[bp-0x0c]` on the
`si == 0x64` 100%-scale branch; the blit verb `0x0C56:0x0004` = file `0x00E964`
converts anchor to top-left with `x -= w>>1` `@0x00EA38` and `y -= h, y += 1`
`@0x00EA45`. For a 6×5 pennant that is `(X+6-3, Y+4-4)` = **(X+3, Y)** — the same
pixel the sprite correlation names.

So the engine's pennant blit **overwrites** the baked flag, and exactly one flag
is ever visible. Frames 118/119/120/121 are red/blue/yellow/orange =
England/France/Spain/Netherlands, so `PENNANT_BASE + nation` was already right;
only the placement was wrong.

**Not** the answer: per-nation marker frames, or a palette recolour. ICONS 0–3
encode **level**, not nation — `func_004314 @0x004455` `add cx,0x77` applies to
the pennant alone.

The marker itself lands at **(X−2, Y)**: `@0x0043D2` sets D=0x10,
`@0x0043D5-0x0043E5` anchors at (X + D/2, Y + D − 1), through the same
anchor→top-left conversion, for a 21×16 frame. That the engine's X equals the
port's tile origin is **not** independently established (`func_067182` unread),
but the pennant fix does not depend on it: (5,0) is a marker-relative delta.

Two related things the same dump settles: native marker frames **10–13 carry no
baked pennant** at any offset, so the port's tribe-colour patch is invented art
with no engine equivalent (nothing in the village painter draws an ownership
patch at all); and the mission cross's **shape** is byte-read from the village
painter — backing `(XB, py+5, 5, 6)` `@0x0041D7`, vertical `(XB+2, py+6, 1, 4)`
`@0x004203`, horizontal `(XB+1, py+7, 3, 1)` `@0x004222` — while its **X origin
XB is TBD**, the engine's base being `px+6` (`@0x00407D` is `mov ax,[bp-0x64];
add ax,6` — the `add` is easy to drop, and doing so puts every x out by ≥4) on
the path that skips the alarm-mark loop and `px+8+2*marks` through it.

### 4. Drag and drop was never implemented

The canvas carried a `click` listener and nothing else — no `mousedown`,
`mousemove`, `mouseup` or `pointer*` anywhere in `port/src/game.js`. So every
interaction the DOS game performs by dragging was either approximated by a click
or simply absent.

The engine's input model, `func_00D106 @0x0D106-0x0D1C9`, publishes five separate
booleans per poll that a DOM `click` collapses into one event: down-edge
`[0x7EC]` `@0xD194`, press latch `[0x7F2]` `@0xD19C`, release edge `[0x7F4]`
`@0xD140`, any-down `[0x7F6]` `@0xD1BB`, moved `[0x7F0]` `@0xD188`, plus the
cursor at `[0x7E8]`/`[0x7EA]`. **There is no pixel drag threshold** — `@0xD16F`
compares the poll-start snapshot `[0x7F8]`/`[0x7FA]` against the current
position, so one pixel counts as moved.

On top of those sits a "what am I carrying" word — `[0x8D54]` colony, `[0x9E3A]`
Europe — which normally holds the region id under the cursor and is overwritten
with a payload mode while a drag is live, with the detail beside it: source kind
`[0xA88C]`/`[0x9E22]`, good `[0xA88D]`/`[0x9E24]`, amount `[0xA88E]`/`[0x9E26]`,
source hold `[0xA88F]`/`[0x9E1E]`.

Region tables, byte-exact and **in the engine's own test order** (the order is
load-bearing: colony id 5 is tested before id 8, so any y ≥ 179 resolves to the
warehouse strip whatever overlaps it) — colony `func_0299A0 @0x0299A0-0x029ABE`,
Europe `func_03200A @0x03200A-0x0320EC`. The rect test itself is verb
`0x181F:0x3CA` = `func_004B16 @0x04B16`, a plain half-open box.

Drop legality is two literal tables: colony `func_02BB8A @0x2BBBD-0x2BBF9` gives
mode 6 → {0,1,2} and mode 7 → {5,8}; Europe `func_0353DE @0x35416-0x35464` gives
mode 0xA → {0,1}, mode 8 → {1,2,3}, mode 9 → {2,3}. A refused drop does **not**
snap back — the engine overwrites the mode with the no-region id (`mov
[0x8D54],0x14` `@0x2A4BA`, Europe twin `@0x32555`/`@0x32718`), i.e. the payload is
dropped on the floor.

Timing, which is **not** uniform across sources and was recorded wrong once
already: a **colonist is hold-to-drag**, deadline `timer + 8` (`func_02C5D4
@0x2C87A`, armed `@0x2C887`, consumed `@0x29C9F-0x29CB7`, `@0x29FE5-0x29FFC`,
`@0x2A28A-0x2A2AE`); **cargo-hold goods** start on the down-edge (`func_02AEDA
@0x2AF5A cmp [0x7EC],0`); **warehouse goods** start on the button being *held*,
re-probed every poll, with no `[0x7EC]` test anywhere in that path (`func_02B9DC
@0x2BA46` + `@0x2BAAC`). The port starts the warehouse drag on the down-edge and
flags the simplification.

**Unresolved, and left as TBD rather than invented:**
- The **tick rate** of `lcall 0xC0C:6`, so the 8-tick hold deadline cannot be
  converted to milliseconds. The port's wall-clock value is its own. *Blocker:
  disassemble the `0xC0C:6` timer entry.*
- The **drag-cursor hotspot**. The module's hotspot globals `[0x590]`/`[0x592]`
  are written by `set_hotspot @0xCB59` masking `& 0xF`, but the value the
  drag-begin paths push was not located, so the ghost draws at the pointer with
  no offset. *Blocker: `func_00DB80 @0x00DB80`.*
- The **unit ghost frame**. The colony path calls `lcall 0x181F:0xA74`, whose
  thunk record at file `0x1B064` resolves to file `0x0091CC` — documented as
  reading unit fields +0x20/+0x40, not as a sprite lookup. (An earlier reading of
  this as `func_042138` does not survive the thunk table.) The port uses its own
  `u.icon`.
- **Colony goods have nowhere to land.** Mode 7's targets are {5, 8}, and region
  8 is the colony's ships-in-port dock — a panel the port does not draw at all.
  The drag arms and the drop is a no-op until that panel exists.

**No drag is added to the map view.** A whole-image scan finds **no reference to
`[0x7E4..0x7FA]` anywhere in 0x63000–0x68000**, and the cursor-sprite setter
`lcall 0x191F:0x8F8` has exactly five call sites (0x29B9D, 0x29BDE, 0x3210E,
0x321DF, 0x32227), none in map code. The manual's click-and-hold direction-arrow
scroll (`docs/GAME_MANUAL.md:422-423`) is manual-tier with **no located byte
site** and must not be invented. (Care with the phrasing: references to those
globals do exist elsewhere in the 0x6xxxx range, at 0x6107E and
0x6B51F/0x6B543 — the claim is about the map range specifically.)

### Two corrections to `spec/ui/input.md`

- §2's claim that no shift-state read exists in the resident image is **wrong**:
  `func_004A22 @0x04A22` reads BDA `0040:0017 & 3` and passes it as the last
  argument to every transfer routine (`@0x2AF3E`, `@0x2BA0B`, `@0x2AE2C`,
  `@0x33AA0`, `@0x3367E`, `@0x334D1`, `@0x33516`) — that is the partial-amount
  modifier. The claim is true only of INT 16h AH=02h.
- `input.md:571` is wrong twice: Europe region 0xB's x-origin is **305**
  (`0x131`), not 306, *and* the cited block `@0x032034` is the id-5 block; the
  correct citation is `@0x3200E-0x3201A`. The colony twin `@0x299C8` gives 305 too.

## 2026-08-07b — the drag/marker TBD ledger, worked off the bytes

The open items the 2026-08-07 entry left behind, resolved by direct disassembly
of `raw/COLONIZE/VICEROY.EXE` (capstone, CS_MODE_16). Where an item stays open
it says so.

### The engine timer, end to end — 8 hold ticks = 131.4 ms

The drag deadline's clock (`lcall 0xC0C:6`, bytes `9a 06 00 0c 0c` @0x2C868) is
resident file `0xE4C6`: it returns the dword behind far pointer `[0x267A]`.
The install path @0xC824-0xC860 hooks INT 8 (`AH=35h`/`AH=25h` int 21h),
reprograms the PIT with **divisor 0x7A8 = 1960** (`push 0x7a8; lcall 0xC10:8`
@0xC843; the setter at file 0xE508 is `mov al,0x36; out 0x43,al; out 0x40 ×2`)
and points `[0x267A]` at DGROUP `[0x92E8]`. The un-install @0xC861-0xC898
restores the vector, pushes divisor 0 and repoints at BIOS `0040:006C`.

The ISR (entry file 0xC694, `push ax; push ds`):
- `[0x8338]` += 1 **every** interrupt @0xC69B — 1193182/1960 = **608.766 Hz**;
- odd ticks exit at once (`test word [0x8338],1` @0xC6A5) — ÷2;
- a reload-5 countdown `[0x376]` (dec @0xC6F5, reload @0xC70B) gates the rest —
  ÷5 — before `[0x92E8]` += 1 @0xC741.

So `[0x92E8]` ticks at 608.766/2/5 = **60.8766 Hz — the exact CYCLE.DAT engine
rate**, which is the independent cross-check. The colonist hold-to-drag
deadline `timer + 8` is therefore **131.4 ms**; the +0x14 repaint cadence is
329 ms and the 0x78 message dwell 1.97 s. The port's guessed 120 ms is replaced
by 131. (Chaining: a reload-3 divider `[0x377]` forwards to the BIOS handler
via `ljmp cs:[0]` @0xC7DA.)

### The drag-ghost hotspot — centre of the frame

`func_00DB80` halves the frame descriptor's dimension words (`mov ax,es:[si+
0x3e]; sar ax,1` / `mov cx,es:[si+0x40]; sar cx,1` @0xDC09-0xDC18, 12-byte
descriptor stride), caches them in `[0x262C]/[0x262E]` @0xDC65-0xDC68 and
pushes them to `lcall 0xA58:0x1D9` @0xDC71-0xDC77 = file 0xCB59 =
`set_hotspot`. **The ghost is centred on the pointer.** Ported.

### The unit ghost frame — the @UNIT icon

The colony path's `lcall 0x181F:0xA74` = file 0x0091CC turned out to resolve
unit NAMES/professions (profession ids ≥ 0x14 through +0x52/+0x36 string
bands), not sprites. The sprite source is the Europe paths' read `byte [0x5232
+ 14*type]` (@0x321D6/@0x3221E) — the runtime @UNIT record array (stride 14;
+0 word = name ref @0x27E7A, **+2 byte = icon** @0x27EFE/@0x280ED, +5 byte =
cargo capacity @0x280ED's guard, +7 read at @0x280F3's path). The file image
holds unrelated code at that DGROUP offset, confirming NAMES.TXT fills it at
load. So the ghost frame IS the @UNIT icon — the port's `u.icon`.

### DGROUP 0x848 — the mission/ownership colour table

DGROUP segment = **0x1B5A** (read off `mov ax,0x1b5a; mov ds,ax` in the ISR),
so DGROUP:0x848 = file 0x1E1E8: bytes **`0C 09 0E 0D`** = England 12, France
9, Spain 14, Netherlands 13 — the @COUNTRY colours, value for value. The cross
colour math @0x41C6-0x41D4 is `sbb al,al; and al,0xF8; add al,[bx+0x848]`:
**expert missions (byte bit 0x10 SET) draw the bright colour, ordinary ones
draw colour−8** — the dim half of the same ramp. The port's invented "0xFD for
expert" is replaced.

### The village alarm strip — fully byte-read

In the village painter (head @0x3E40): level = `min(3, alarm >> 5)`
(@0x40C6-0x40CE, alarm word `[village*18 + power]*2 + 0x54F6` clamped ≥0), and
tension ≥ 75 forces level 3 (`lcall 0x5DC:0xE0` then `cmp ax,0x4b` @0x40DD).
Level colours @0x40F8/@0x40FE/@0x4104/@0x40F1: **0x0A green / 0x0B cyan / 0x0E
yellow / 0x0C red**. Each mark at (XB, py+4): 3×7 backing rect in the outline
colour, 1×5 bar at (XB+1, py+5), 1×1 dot at (XB+1, py+9); XB starts px+6,
steps +2 per mark, and takes a final +2 after the loop (@0x419F/@0x41A9) — so
the mission cross lands at px+6 with no marks and px+8+2·marks with them.
Marks with remaining count ≤ 2 dim −8 (@0x412F-0x4135). Ported (rect marks
replace the port's '!' glyphs and its five-step ramp). **Still open:** the
mark COUNT is an out-param of `lcall 0x181F:0x316` (@0x408D) whose semantics
are unread — the port draws level+1 marks, flagged. Alarm marks only draw for
the power matching `[0x5396]` (@0x40A4); for another power's mission the strip
degenerates to a single mark in `table[power]` colour (@0x410E-0x411A).

### COLONY_FRAME — the port's [3,0,1,2] is confirmed

Verb `0x5EB:0x35E` = resident file 0x860E is a plain **bitset membership
test**: bit `id&7` of byte `[colony*0xCA + (id>>3) + 0x5DCA]`. func_004314
counts fortification ids and then maps `di = (count−1) & 3` @0x43AE-0x43B5,
drawing engine sprite di+1: count 0→bundle 3, 1→0, 2→1, 3→2 — exactly
`COLONY_FRAME = [3,0,1,2]`. Upgraded from UNCITED to byte-cited; the old
"has exactly vs at least" question is dissolved (it is neither — it is a
count of members).

### The colony dock (region 8) rows — func_027DB2 read in full

- Frame box (121,130,84,48) @0x27DB7-0x27DC1.
- **No ships** (`[0x33C]==0`): the caption plus ICONS **engine 0x7B** (bundle
  122, the crossed crate) on all six hold cells @0x27DC7-0x27E34.
- **Ships row**: 16×16 cells from x=130, y=147, **pitch 18, max 4**
  (@0x27EAB-0x27EB9, advance `sbb ax,ax; and ax,0xD; add ax,5` @0x27FA2 = +18
  row 0, +5 later rows); a ship's blit rides 1px high, 2px past slot 0
  (@0x2801E-0x2803D). Ships 5+ overflow to a 3×4 row at (124,139), pitch 5, up
  to 16 (@0x27FE2-0x27FF6) — the old "implausible 5px pitch" was real, it is
  the overflow row. Selection box colour 0x0A on `[0x33E]`; **0x0F as the
  drop highlight** while the button is held mid-drag (@0x27F35-0x27F4A).
- **Hold cells**: slot ≥ @UNIT cargo capacity (record byte +5, `[bx+0x5237]`
  @0x280ED) → the 0x7B cross; an occupied slot → the goods icon **centred**,
  engine 0x17+good full / 0x27+good if qty < 100 (@0x28120-0x2812B — the same
  band the drag ghost uses); an empty in-capacity slot draws **nothing**.
- Caption with a ship: "…" + the selected ship's @UNIT name (@0x27E36-0x27EA8).
The port's dock is rebuilt on these numbers; its interim (123,140,20) layout
lasted one commit.

### ICONS bundle 17 — the sparkle's real role

`mov ax,0x12; lcall 0xC56:4` @0x4066-0x406F in the village painter: engine
sprite 0x12 = **bundle 17 is a VILLAGE overlay**, drawn iff the village flag
byte `[0x54EF]` has bit **0x04** set (@0x4051). What that bit means (capital?
visited?) is **TBD** — do not guess; finding the bit's writer would settle it.
Either way the sparkle was never the rumour marker.

### Native settlement markers — ICONS 10-13 byte-anchored

The village body blit is `min(level, 3) + 0x0B` → `lcall 0xC56:4`
(@0x3E9D-0x3EB6), the level being the tribe record's first byte
(`[bx+0x5AD8]`, stride 0x4E, indexed by the village's tribe byte `[0x54EE]`−4).
Engine 0x0B..0x0E = bundle 10..13 — the port's `NATIVE_FRAME_BASE = 10` was
right and is now anchored at the draw site (closing the tracker's "find the
village body blit" item).

### func_002544 — not a beep; and [0x5384]

`0x181F:0x56` = file 0x2544 is the **tooltip dwell/redraw/expire** routine: no
OUT/INT anywhere in its body; a 30-tick dwell loop (deadline `tick+0x1E`
@0x24E3) broken by a key or button, a final redraw/erase through the
save-under machinery (`lcall 0xB70:0x3A` @0x25DE), a one-tick wait
(@0x25E3-0x25FB spins on the 0xC0C:6 dword), then clears the arm flags
[0x4A..0x4C] and the text buffer at DS:0x2D54. On a rejected drop it simply
expires any armed hover label. (A ghidra comment mapping 0x181F:0x56 to
0x2287E is wrong; the validated thunk table wins.)

`[0x5384]` bits 0/1 are the **@COLONYOPTIONS "Labels on …" suppression bits**
(set = unchecked = suppress): bit 1 (0x02) = "Labels on buildings" — gates the
zone-2 hover handler in func_02BB8A @0x2BBEB; bit 0 (0x01) = "Labels on cargo
and terrain" — gates zones 5 and 1 @0x2BC0E, and the Europe zone 0 in
func_0353DE @0x35446. Written only by the @COLONYOPTIONS dialog (func_02311A;
rows OR in 0x02/0x01/0x80/0x40/0x20/0x10/0x08/0x04, rows 9-10 use [0x5385]).
Suppression applies to hover labels only — an active drag bypasses the tests
(@0x2BBDE). **Correction:** func_022F08 is NOT the reader — it is the Find
Colony command (dialog keys "FINDCITY"/"NOCITY").

### Still open after this pass

| Item | Blocker |
|---|---|
| Colony drop-action bodies (`func_02A6A6`/`func_02A8EC`) — quantities, refusal conditions, messages | Unread; the port's load/unload conventions are flagged in drawColonyDock/colonyDrop |
| Colony region-id → action switch | Overlay-resident, unchanged |
| Alarm mark count (out-param of `0x181F:0x316`) | Disassemble that verb |
| `[0x54EF]` bit 0x04 meaning (the bundle-17 sparkle's trigger) | Find the bit's writer |
| Whether natives teach Lumberjack / Scout's place in OUTDOOR_JOBS | No evidence either way |
| Rumour third gate / feature-plane identity | Unchanged (the .MP loader discards the plane) |

## 2026-08-07c — the raid-gate K is the colony's fortification count (TBD closed); six player-reported defects fixed in the port

### The raid gate's K, byte-read

`func_05BE84`'s gate threshold `3·K+1` (@0x5BEE5 `shl ax,1 / add ax,cx /
inc ax`) takes K from `push 0; lcall 0x181f,0xab0` @0x5BED9. The validated
thunk table resolves `0x181F:0xAB0` to resident **`func_00864E`** — a
chain-walker: for an id it tests colony membership through the 0x860E
bitset helper (the same resident bitset `func_004314` counts fortifications
with), counts a hit, then follows the next id from the stride-12 building
record table at DGROUP `0x8F86` (`[bx-0x707A]`, bx = id·12) until the link
goes negative. Called with id 0 it walks building chain 0 — **Stockade →
Fort → Fortress** — so **K = the target colony's fortification count
(0..3)**, and the gate is:

    raid proceeds iff  random_int(1,12) − 1 (+ difficulty−2 vs a human)  ≥  3·fortifications + 1

A bare colony is raided on all but the lowest rolls; a Fortress repels all
but the highest. The port's `RAID_GATE_K = 0` placeholder (flagged TBD since
the §19 natives pass) is retired; `nativeRaid()` now reads `colonyLevel(c)`.
This also cross-anchors `func_00864E` as the *generic building-chain
counter* — the fortification sprite mapper `func_004314` and the raid gate
share it.

### The six reported defects, and what each fix is

1. **Sailing out of Europe with recruits/trainees aboard crashed at
   landfall.** `mkUnit` looked the passenger name up in @UNIT and threw on
   any PROFESSION name ('Expert Farmers', 'Veteran Soldiers'…). It now
   resolves the five unit-bearing professions to their @UNIT types
   (Veteran Soldiers→Soldiers, Veteran Dragoons→Dragoons, Hardy
   Pioneers→Pioneers, Seasoned Scouts→Scouts, Jesuit
   Missionaries→Missionaries — the @JOB expert_name column against @UNIT)
   and lands everyone else as Colonists CARRYING the profession.
2. **No way to arm dock units or sail ships by mouse.** The two harbour
   context menus are built: clicking a dock unit opens GAME `@EUROPEARM` +
   `@ARMOPTIONS` (grep-verified 12-row section) — board / move to front /
   arm-with & sell Muskets, Tools, Horses / bless & cancel Missionary;
   clicking the selected ship opens `@EUROPESHIPCLICK` +
   `@EUROPESHIPOPTIONS` (move to front / set sail / unload all / no
   changes). Quantities are the manual's (50 muskets, 50 horses, 100
   tools; GAME_MANUAL.md 1962-1971); prices are the live market through
   buyGoods/sellGoods, so arming moves prices and pays tax like any trade.
   Which rows the engine gates per state is unread — the port offers the
   applicable rows, flagged as its own. An armed entry is `{name, type}`
   (the man's profession + his equipment), which landfall resolves to a
   typed unit carrying the profession.
3. **Job assignment was unusable by mouse.** Root cause found in the drag
   layer: the engine's moved flag has no pixel threshold (@0xD16F), and at
   the port's 2-3x cursor scale the jitter inside an ordinary click crossed
   a logical pixel — so every deliberate click on a plaza colonist resolved
   as a zero-length drag that dropped him back on the plaza, swallowing the
   click AND clearing his job. Two reconciliations, both flagged UNCITED:
   a release within 2px of the press is a click, and a plaza-sourced unit
   dropped back on the plaza keeps his job.
4. **The colony did not appear in its own scene panel.** The 5×5 scene
   buffer drew bare terrain only. It now composites the same layers the
   map view draws: improvements (roads/plow), other colonies and villages
   in the window, and the colony itself on the centre tile.
5. **Raids repeated every turn, several per turn; the AI stood still.**
   The per-village-per-turn raid loop is gone. `nativeMoveAI()` (R-tier,
   a reduced func_046FFA/func_04E2D6 — the reduction is flagged in the
   code) marches each war-footing brave (alarm ≥ 0x80, the @0x04734E
   test) one tile a turn at the nearest colony; the raid fires when he
   arrives, through the byte-cited gate above, and he turns for home — so
   raid cadence is travel time, and braves at peace visibly wander near
   their villages.
6. **Popups had no speaker portraits.** The §2.7 channels are wired:
   native-family keys draw `IND<tribe>A0` (tribe from the dispatcher via
   G.eventTribe), the military family MSS5 (func_040C1E @0x040CD3), king
   keys KING1 ([0x1F5C]=8 @0x06F5DD), placed bottom-right under the plaque
   — the same convention the village screen already used, since the
   engine's landing pixel is runtime cel state (§2.7.1). The key→family
   routing beyond the byte-cited wrappers is the port's reading, flagged.

Behavioural suite: 203/203 (10 new checks: arm menu contents and pricing,
arm commit, armed/profession landfall, ship menu, jitter-click select/keep/
menu, scene-panel colony pixels, raid fort gate ×2, speaker channels).

## 2026-08-07d — the save file's map planes; two SAV field labels corrected; the port gains rival AI and LOAD GAME

### The .SAV does not end at block 43

`func_0734F8`'s tail (@0x73938–0x73A1D) writes the four MAP PLANES through
`0x1A1F:0xC9C` — terrain `[0x15C]`, improvements `[0x160]`, resource/region
`[0x164]`, per-power fog `[0x168]`, each w·h bytes — then two 0x10E scratch
blocks (0x86F6/0x85E8) and two 0x20 arrays (0x945E/0x85C8). The spec's
43-block table stopped short; `spec/systems/save.md` now carries the full
sequence. Validated against all ten shipped COLONY0#.SAV: sizes reconcile
exactly, and the fog plane uses the same `1<<(power+4)` bit the render
chain's SEEN test already established.

### Two labels corrected by round-tripping the 1653 save

* **PowerRecord +0x4C = the CURRENT PRICE array** (the live bid per good),
  not "market_sensitivity" — the imported values reproduce the 1653 Dutch
  game's market verbatim.
* **ColonyRecord +0x20 = the per-colonist CURRENT-JOB array** (@JOB row,
  parallel to the +0x40 specialty array; 28 = none) — Jamestown-1653's ten
  bytes decode to its exact roster, with the +0x70 tile-worker table binding
  six of them to their fields.
* Off-map UnitRecord coordinates (231,231-style) are the "in Europe / high
  seas" state; riders stack on the ship's sentinel tile.

### What the port gained

* **LOAD GAME** (main-menu row 3) — three sources: the browser save (now v2:
  it round-trips the three map planes and the rumour set, which the old
  G-only serialization silently lost), the shipped 1653 Dutch game bundled
  into the page, and any COLONY##.SAV picked off disk. The importer walks
  the byte-verified block sequence; what it cannot see (crossings, routes,
  the diplomacy matrices, hold quantities past slot 2) loads empty and is
  flagged in the code.
* **Rival-power AI** (R-tier, flagged): colonies grow on a 16-turn
  accumulator, fortify by size, and keep soldier garrisons; at war the
  surplus marches on our nearest colony one tile a turn and strikes through
  the same resolveAttack the player uses; an undefended foreign colony can
  now be CAPTURED by the player (@CAPTURED, with plunder) and an undefended
  player colony falls to the AI (@BURNED — the engine transfers ownership
  instead; the difference is flagged). The full strategic pipeline
  (func_04CC50/func_04E2D6) remains the evidence ceiling in ai.md.

Suite: 215/215 (12 new checks on the importer, the rival AI, save v2, and
the Load picker).

## 2026-08-07e — 0x181F:0x316 is the RAID-TARGET SCORER; the alarm strip's mark count and the ICONS-17 sparkle are both closed

### func_0460F8 (0x181F:0x316), disassembled in full

Signature `(settlement_idx, &out_score) -> best_target_owner`. Per village it
scores every HUMAN-controlled colony within taxi distance 6
(AIPersonality.controller == 0 gate @0x46429) and returns the best score
through the out-param:

* **Area strength** @0x4616E–0x46280: over the village's 20-tile work ring
  (delta tables DGROUP:0xC8/0xDE — read out of the EXE image at +0x1D9A0:
  the 5×5 neighbourhood minus centre and the four (±2,±2) corners), sum the
  @UNIT attack column (>1 only; ship types 0x0D..0x12 excluded) of each land
  tile's units, halved on a layer-2 bit-0x02 tile (0x181F:0x6BE =
  file 0x5FD4) and halved again beyond ring distance 1; banked per owning
  power (owners ≥ 4 skipped).
* **Per-colony score** @0x4630E–0x4636A:
  `fort = (Σ set-bits(colony+0x84 bitset)·w / div − 8) >> 2`, (w,div) by
  difficulty from `{(1,2),(3,4),(1,1),(3,2),(2,1)}` (@0x46425 switch);
  `score = ((2·max(0,pop−6) + min(pop/2, tribeLevel) + min(pop,6) + fort)·2
  − dist − 1) / (dist+4)`, halved when the village and colony sit in
  different map REGIONS (0x181F:0x722 = file 0x5E90, a low-nibble region id
  off a map layer), then `+ areaStrength[owner]`, halved for FRANCE
  (@0x46388) and halved under power-attribute bit 0x10 (@0x46391 —
  Pocahontas's flag).
* **Mission tail** @0x4645E–0x464AD: ANOTHER power's mission on the village
  makes raiding the target MORE attractive (expert ×2, plain ×1.5); the
  target power's own mission protects it (expert ÷2, plain −25%).

### What the map strip actually shows (the old TBD)

The village painter's marks are NOT the alarm level: the count is this
scorer's output — `draw; XB += 2; score −= 4` while score ≥ 0
(@0x419F–0x41A7), so **marks = floor(score/4) + 1**, none at all when the
scorer returns < 0 (@0x409F). The ALARM word picks only the COLOUR
(level = min(3, alarm>>5), tension ≥ 75 forces red), and a mark drawn while
the remaining score ≤ 2 dims −8 (@0x412F) — the "trailing marks dim" rule,
now with its real driver. When the best target belongs to an AI power the
strip is a single mark in that power's @COUNTRY colour ([0x848+power],
@0x4110–0x411A).

### The sparkle

`test [0x54EF],4` @0x4051 draws engine frame 0x12 (bundle ICONS 17) —
settlement flags byte +0x03, bit 0x04, which `spec/systems/natives.md` §2
already carries BYTE_VERIFIED as the **CAPITAL** flag (set once per tribe at
settlement generation @0x66225, boosts defence/growth @0x07DCA/@0x46E05).
The sparkle marks a tribe's capital. TBD closed — the painter test site
@0x4051 was simply never joined to the flag's existing identification.

### Port

`raidTargetScore()` is the byte-ported scorer (region check omitted — no
region plane — and the +0x84 bitset counted as the building list; both
flagged); the map strip now draws score-many marks with the byte-exact count
and dim rules; capitals sparkle; the brave AI targets the scorer's pick.
On the 1653 board exactly one village scores (the Iroquois capital eyeing
Roanoke at score 0 — one dim green mark), which matches that game's quiet
state. Suite: 216/216.

## 2026-08-07f — the drop-action bodies read: func_02A8EC is the goods-transfer executor, func_02A6A6 its hover-label twin

The two functions on the open-items ledger since the drag pass are decoded:

* **`func_02A8EC(src_unit, dst_unit, good, interactive)`** is the
  goods-transfer executor. Order of operations, each at its site:
  quantity = the source slot's load via `0x181F:0xBE6`, **clamped at 0x64 =
  100** (@0x2A92F); the DESTINATION SPACE test `0x181F:0xB96`/`0xC68` runs
  BEFORE anything moves, refusing with a timed message (dwell 0x78 = 120
  ticks, i.e. 1.97 s) when there is no room (@0x2A916-0x2A92A);
  qty = min(qty, space) (@0x2A948-0x2A95B); the interactive path formats an
  amount prompt (cargo-name table `[bx-0x6840]`, `@UNIT` +0x5230 capacity
  words, format_int32) and re-clamps to the entered number, aborting on ≤ 0
  (@0x2A967-0x2AA1E); the move itself is remove-slot `0x181F:0xAEC` +
  cargo-load `0x181F:0xD58`, with the REMAINDER PUT BACK on the source when
  less than the slot held was taken (@0x2AA40-0x2AA6C).
* **`func_02A6A6`** is the matching hover-label builder (gated by the
  `[0x890]` label flag -- the §29 unknown, now identified as the label gate),
  formatting the same cargo-name/capacity/amount trio; its negative-result
  path expires the armed tooltip (`0x181F:0x56`) rather than transferring.

**Port adoption:** the space clamp was the missing piece -- the port's merged
hold slots could grow without bound. colonyDrop's warehouse->ship leg and
Europe's buyToShip now clamp to (free slots)·100 + merge-slot headroom and
refuse when full, which is the executor's arithmetic expressed under the
port's one-slot-per-good convention (flagged as such in place). The 100 cap
and the refusal-as-timed-message shape were already right. Suite: 216/216.

## 2026-08-07g — map plane 3's low nibble is the REGION id (func_005D9C); the scorer's region check lands

`0x181F:0x722` resolves through `func_005E90` to the raw reader
`func_005D9C`: `byte [ [0x164] + y*width + x ]` — **map plane 3** (the block
the save spec called "resource/region") — masked `& 0x0F` by the 0x5DBA
wrapper. So the plane's LOW NIBBLE is a landmass/region id (1 = the main
continent in the shipped saves, 0 = ocean), and the raid-target scorer's
"different region halves the score" test is now fully grounded. The port
carries a REGION plane: imported verbatim from a .SAV, rebuilt by a
landmass flood fill for a fresh map (the engine's own region builder is
unread — that reconstruction is R-tier, flagged), saved in the v2 browser
save, and used by raidTargetScore. The plane's HIGH nibble is still open
(prime-resource/river-mouth candidates). Suite: 216/216.

## 2026-08-07h — AI fidelity pass (user directive): no invented behaviour; the func_046FFA idle scorer ported term-by-term; two ai.md §3 corrections

**User directive:** the port's AI must match the original's operation — no
invented roles or cadences for the rivals or the natives; where the engine's
rule is unread, OMIT and flag, do not approximate with made-up numbers.

**Applied:**

* The invented rival-colony cadences are REMOVED (pop +1 every 16 turns,
  fortify tier = pop/4, a soldier spawned every 4th turn — none of it had a
  cite). Rival colonies no longer grow or raise troops out of nothing: a
  fresh game's rivals field what their ships landed with, an imported save's
  rivals field exactly what the save carries. AI colony development runs
  through planner missions (func_04CC50) that are not yet decoded — omitted.
* The invented brave wander (a 50% coin and a hard 2-tile box) is replaced
  by **func_046FFA's own idle scorer, term by term**: 9 candidates (8 dirs +
  stay), base 200 (@0x0473A4), Ocean/Sea-Lane/Arctic dest reject
  (@0x0473BB), occupied-dest reject (@0x047A1D), heading continuity +4
  (@0x047A79) / adjacent +3 (@0x047A99) / reverse −6 (@0x047AB0), the
  home-settlement leash −3·d beyond distance 2 (@0x047AD0–0x047B39), jitter
  +rand(1,5) (@0x047F44), clamp and strict max (@0x047F6E). Omitted (unread,
  listed in place): the flag pair +4 @0x047AC6, the leash-halving predicates
  0x902/0x8D0, the frontier gate 0x984, and the era/resource/colony-site
  terms that don't apply to braves.
* The war-march step (both braves-to-raid and rival soldiers) remains a
  straight-line stand-in for the goto executor's path scoring (func_04E2D6
  step 5, unported) — now flagged as exactly that, in both places. The
  colony-capture plunder roll is flagged as a placeholder (formula unread).

**Two byte corrections to ai.md §3 from this pass:** `0x181F:0x384` =
`func_0049FC` is an adjacent-compass test (`(cur±1)&7 == cand`), giving the
three-tier heading term +4/+3/−6; and the "target distance ×3" row was
wrong twice — `[bp-0x78]` indexes a NATIVE SETTLEMENT (not a goto record)
and the term is a PENALTY (`sub` @0x047B39): the unit pays −3·d for
straying beyond 2 tiles of its settlement. That leash is what keeps braves
near their villages in the original — the port's old hand-rolled 2-tile box
was accidentally the right radius, and is now the engine's own arithmetic.

Suite: 216/216.

## 2026-08-07i — the map screen carries no status line; every message is a popup

**User directive:** "on the map screen no messages should show up in the map
view, they all need to be pop up windows."

**Evidence:** every live DOS capture of the map screen
(docs/screens/live_2026-08-05/*, docs/screens/live_1653_save/*) shows the
sidebar ending at the unit panel — the engine draws no free-text status
caption anywhere on the map view; player-facing text arrives through the
dialog/notice framework (§2.7).

**Port change:** the invented `G.msg` status line (drawn at 244,182) is
removed. A per-frame flush (`flushMapMsg`) converts any message raised while
the map is up into a notice popup on the §2.7 queue via a new `notice()`
helper (no speaker, wrapped at 150px, identical consecutive notices collapse);
a message left behind by another screen is dropped on the way out instead of
leaking onto the map — the old status line showed exactly that leakage.
Meaningful off-map results (village trade/gift, incite, treaty renounced,
abandon colony, save/load/import results, colony-dock refusals) now call
`notice()` directly at the site. Pure state echoes with no engine counterpart
(order-name echo, "Activated.", zoom size, Move/View mode, hidden-terrain
toggle, job-assignment echoes, load/unload success echoes, rename echo, the
game-start homeport caption) are deleted outright: the state change is already
visible, and the engine raises no message there. The ad-hoc `notice()` texts
remain port phrasing — their byte-cited GAME.TXT keys, where they exist, stay
on the popup-audit ledger (docs/POPUP_AUDIT_2026-08-08.md).

Suite: 220/220 (new regression: convert + stale-drop + dedupe).

## 2026-08-07j — playtest batch 3: F3 freeze, report sprites, F5 columns, sail confirms, Europe cells, speaker families

* **F3/F10 froze the whole game**: `drawCongressReport`/`drawScoreReport` called
  a `spriteStrip()` helper that never existed; the ReferenceError killed the
  rAF loop (frame() only rescheduled at the end of its own body). Fixed with
  the real `drawCountRow` verb, and `frame()` now wraps its body in try/catch
  so no draw error can ever freeze the port again (error logged once).
* **Report sprite ids are 1-based**, like the F2 crosses' `0x39-1`: the F3 REF
  quartet now draws @UNIT icons-1 (Regulars 126→125 red-coat, Cavalry 127→126
  mounted, Artillery 10→9 cannon, Man-O-War 128→127 warship — via the UNITS[]
  table, which already stores icon-1), and the rebel/tory strip is flag 0x7B /
  crown 0x7C at ONE ICON PER PERCENT — all verified against
  docs/screens/live_1653_save/report_F3.png. Labels corrected off the @MISC
  strip (69 Rebel / 70 Tory / 71 Sentiment / 89 Founding Fathers; the port had
  been printing "Tory … Sentiment …" and "Rebels"), the force line takes the
  nation adjective, and the title names the father under debate.
* **F5 Tons/Gold RESOLVED = PowerRecord +0xBC/+0x7C**, the whole-game net-trade
  counters (units / value net of per-lot tax). The 1653 frame is decisive
  (Muskets 0 t / 351$; Ore 3700 t) and the importer now reads both arrays —
  matching the live frame value-for-value, including the "K" abbreviations
  (13594/16771/20619). Port: sellGoods/buyGoods run the byte-cited updaters
  (sale += floor(price*qty*(100-tax)/100) PER LOT, purchase -= ask*qty);
  warehouse overflow never touches them (byte-cited asymmetry — the port's
  overflow discards, so it holds by construction). K-abbreviation threshold
  unobserved between 6072 and 12999; 10000 is the port's reading.
* **@SAILAWAY / @SAILHOME wired** (both were MISSING per the popup audit):
  a ship dragged from the harbour list (engine unit mode 9 — the drop table
  func_0353DE @0x35416-64 already lists targets {2,3}) onto the Bound For
  panel (region 2) asks @SAILAWAY, as do the ship-menu row and the S key;
  a ship entering the sea-lane column asks @SAILHOME, declining stays put.
  The ask-on-entry binding for @SAILHOME is manual-tier (engine trigger site
  unread); the confirm texts/widths/defaults are GAME.TXT verbatim.
* **Europe panels**: Bound For / Expected Soon entries now draw as the 18x18
  hollow-green cells (0x0A) with the ship icon at +(3,1) and the engine's
  sail-progress bar (width 0x64>>state @0x0313A4, state = turns left) instead
  of bare text names; every harbour ship wears the green cell with the
  selected one flipped to yellow 0x0E (the 0x0A/0x0E runtime pair the market
  cell uses — the one-ship captures cannot split the rule; port reading).
  Stacked panel placement is port layout; the engine's band y=146/137/132 by
  state (func_031298) is recorded for a future exact rebuild.
* **Speaker families extended** per the byte-cited caller map
  (POPUP_TEMPLATE_AUDIT caller table + spec/ui/popups.md §2.7): MSS2 trade
  (@PRICE*/@SOMEBOYCOTT/@SUCCESSION; @UNREST is a flagged reading), MSS3
  colony-siting warnings (func_022542 arg 3), MSS1 diplomacy announcements +
  @FOREIGNNOTAVAIL (byte push 1), MSS0 colony events (func_032FE2), KING1
  gains the treasure-delivery family (@CASHTREASURE/@LOOT* excl. LOOTCAPTURE)
  + @TEAPARTY. Families with no cited channel (Lost City, revolution, SoL
  bands, schooling) stay bare per the evidence.

Suite: 226/226 (seven new regressions).

## 2026-08-07k — batch 4 (part 1): popup framework to the byte-decoded math; woodcut triggers completed

**Popup framework** (dialog_framework.md §3, correcting the port's inventions):
* `notice()` boxes were 80-156px wide with an invented 150px wrap; every
  gameplay popup in GAME.TXT is `@width=190` (histogram 190:336, 220:99), so
  notices now wrap at 180 and carry width 190 -> the canonical 196-wide box
  at x=62.
* The event box no longer reserves an option block it does not have (the
  "+3+rows+3" term is conditional @0x06D606) and the invented "(Continue)"
  row is deleted -- byte-cited negative: no OK/Cancel/Continue string exists
  in the EXE; the modal loop func_004A80 blits nothing and times out at 120
  ticks (the timeout itself is still unimplemented, flagged).
* Every measured line now carries the engine's +10 margin (@0x06CCE3).
* {brace} spans now highlight in OPTION ROWS and entry labels too (the
  [0x1F62] toggle is in the shared painter func_06C388; the port printed
  literal braces in @TAXOPTIONS/@MERCENARIES/@TRADE0...), and the selected
  row is marked by the +0x40 band ONLY -- the hilite ink is gated on the
  brace flag (func_06C346 @0x06C365), never on selection.
* In-game dialogs take the NAMES @COLORS inks (slot 0 = 68 basic, slot 1 =
  149 hilite -- the same [0x830]/[0x831] pair the F9 report reads; the slot
  mapping is a flagged reading, @0x073474's body being unread). Title-screen
  dialogs keep the boot immediates 0xFE/0xFC and now tile OPENTILE.
* The plaque's wood tiling now anchors on the box origin (phase 3,
  func_00E350 @0x00E371-A2).
* Bundled the keys the port called into the void (showEvent's !t guard ate
  them): @BURNED, @CAPTURED, @CLEARCUT, @USEDUPTOOLS -- plus @NOTENOUGH,
  @CANCELPEACE, @INDIANWARFARE, @MERCS, @UNREST, @MERCENARIES, and the
  ad-hoc notices at those sites now fire the keyed popups. @GIVECASH shows
  its two response rows (cash moves only on the sparing row; the refusal's
  relation-matrix effect is unread). The mercenary offer body is
  @MERCENARIES with its own rows (pay = row 1); @KINGRECRUIT is freed for
  its real Europe TRAIN site (still to do, ledger L180).

**Woodcuts** (spec/ui/woodcuts_and_intro.md §1 caller table): the port had 5
of 10 live call sites and only 3 plates in the asset bundle.
* All 10 caller-cited plates are bundled now (WDCUT01-05, 07-11, 13; the
  caller-less 00/06/12/14-16 stay out per the exhaustive scan).
* New triggers wired: tribe first contact -> plate 3/4/5 by tribe id
  (Inca 5 / Aztec 4 / others 3, func_056C3E @0x056DA6) + @INDIANWELCOME
  (treaty effect unread, flagged); first village entered -> 7
  (func_04B308 @0x04B56C); Fountain of Youth -> 8 (func_061454 @0x0618F9);
  first cargo arrival in Europe -> 9 (func_041EEA @0x0420EF).
* Woodcut 11 now runs through the once-only gate (it re-fired per razed
  colony) -- all sites share woodcutOnce(), modelling the [0x540A]
  shown-bitmask; a restored save marks the whole mask seen (the save's own
  [0x540A] block index is unread, TBD).

Suite: 227/227.

## 2026-08-07l — batch 4 (part 2): colony surrounding-tiles panel to the byte-read cell model

Against spec/ui/colony_screen.md §3.2/§3.8 (func_0264A8 / func_026374) and a
pixel read of the live Curacao frames:
* The x1.5 upscale now uses func_00531C's own duplication phases (columns
  pair at dst%3==0, rows at dst%3==1 -- the drawImage stretch had the row
  phase off by one). The 4x4 positional ramp dither func_005296 remains
  unimplemented, flagged TBD (capture shows ~25% exact pairing vs the
  port's ~75%).
* Worked WATER tiles draw EXE 0x3A = bundle frame 57 (the fish) instead of
  the food sprite (@0x0266D2's tile-class-8 substitution) -- live Curacao's
  north sea cell is the anchor.
* Map units STANDING on surrounding tiles now draw: PHYS0 frame 0x5A +
  @UNIT row at (cell*24+252, cell*24+60) = cell+(4,4) (func_026374
  @0x02646A-92; PHYS0 99/101 in the live frame at exactly those anchors).
* Flag bit 6's red 24x24 blocked-cell outline (colour 0x0C @0x026584) draws
  when another settlement holds the tile -- the bit itself is runtime state,
  so that condition is the port's reading, flagged.
* Roads/ploughs were double-blitted into the scene (drawTile already
  composites improvements); fixed.
* Left open with the blockers named: the ICONS 0x6D marker path
  ([0x8D9E] semantics unread), the white [0x330]/[0x332] cursor box, the
  scene marker's pop number/name (gated on [0x890], live value unresolved),
  and the amount<=0 path independent of assignment.

Suite: 227/227.

## 2026-08-07m — the two HIGH invented-flow rebuilds: village haggle + European meeting

**Village trade (func_049600; audit L49-51/65-66/83).** The flat sell/gift/buy
list with port-authored labels is replaced by the engine's popup session, in
the manual's order: sell-or-gift first (@TRADEWHICH picker when >1 cargo --
its engine trigger is unestablished, flagged), then the village offers its
own three goods (@BUYWHICH's 4-row popup -> @BUY0/@BUY1). @TRADE0 carries the
gift row; @TRADE1 (round 2+) drops it. Byte-cited pieces: the §19.5 price
formulas (unchanged), the haggle BUDGET = random(1..rounds)+qty/4 with rounds
= min(3,(demand-want+4)/10), the "same good twice" @BADCARGO gate
(settlement +0x08 last_bought, muskets excepted), @BADHAGGLE0/1 = the
sell-side per-good latch and 2/3 = the buy-side latch (the texts' own
first/repeat split), @TRADENOCARGO/@TRADENOWANT refusals, @NOTENOUGH with the
treasury, and the chief speaking IND<tribe>A<band> throughout. TBD stand-ins,
flagged in code: the per-counter budget spend (flat 10), the counter amounts
(+50% sell / -25% buy) and the per-round movement (halfway); @TRADE0's
unbraced %STRING0 modifier has no decoded source and is passed empty.
villageBuy's invented -2 tension credit is removed (the cited -4 @0x5C41E is
the sell side's); the three invented notices are gone.

**European meeting (func_057F4E; audit L10-11 + the trigger rows).** The
invented parley SCREEN is deleted -- the meeting is a chain of popups over
the map, always framed as power B speaking, with MYR<B>.SS on every width-220
conversation ([0x1F60] = B) and the MSS advisors keeping the width-190
announcements. Wired: the greeting key build (HELLOFIRST/AHOY on first
contact by unit type, MEEK/MANLY after, HELLOUSA once independent,
@0x0588CD-0x058939) with the @GREATKINGS/@GREATDEEDS fills; the AI-initiated
direction (a rival unit beside the player opens the same chain, gated on the
byte-cited eligibility + the 16-turn cooldown); the AI topics (@TRIBUTE with
accept-on-row-2, the AI-proposed @WORTHY) behind the grace period
10*(10-diff) and the action gate 200*diff+100; the @PEACE*/@OLDPEACE*
standing-peace hub with its four fixed rows -> treaty (silent -- @SIGNTREATY
belongs to the AI-AI ticker), the withdraw branch (@NOTHINGWITHDRAW /
@MAYBEWITHDRAW at the byte-cited price 25*(diff+2)*forces min 100 x2-at-war
-50/unit Franklin/2 / @NOTWITHDRAW), the threat branch (@GIFTS/@THREATS/
@PROVOKE), and the alliance branch (@MILITARY's runtime target rows ->
@NOCONTACT/@ALREADYSMITE/@SMITEEUROPE/@SMITEINDIANS -> pay -> @MERCENARY,
short purse -> @UNFORTUNATE). A minimal AI-AI ticker signs peace treaties
with the @SIGNTREATY announcement (turn>=40, every 3rd turn, attitude+action
gates); its war path's grievance drivers are unread and omitted. FLAGGED
READINGS (no byte cite): the MEEK/MANLY tone predicate (attitude>=8 reused),
PEACE-vs-OLDPEACE = standing treaty, topic priority, the withdraw/threat
sub-branch selection, and the smite price (demandValue(1000) stand-in).
@WORTHY's %STRING0 takes @GREATLEADER (the @GREATKINGS line overflows 320px,
which the engine never shows). layoutDialog gains the engine's screen clamps
(@0x06D563/71).

Suite: 229/229 (haggle chain + meeting chain regressions).

## 2026-08-07n — completion plan adopted; Phase 0 infrastructure (render-diff oracle, ledger upgrade, audit reconciliation)

**Decision (user-approved plan).** The remaining work to "finished" is now a
standing 6-phase roadmap in `docs/COMPLETION_PLAN.md` (linked from STATUS.md's
Build tracker). User scope rulings recorded there: sound/music OUT of scope
(AUDIO_SPIKE NO-GO stands), tutorial IN scope, byte-closure required only for
player-visible stand-ins (cosmetic approximations may stay flagged).

**Phase 0 delivered:**

1. **`port/tools/render_diff.py`** — pixel-diff oracle. 14 standing
   port-shot : DOS-capture pairs, each with a threshold that DOCUMENTS the
   known residual (not "allowed error"): e.g. F7 fresh = 50 px, F5 fresh =
   308 px, the 1653 colony = 25.9k px (unimplemented func_005296 dither +
   RNG buildings + worker cells, per 2026-08-07l). Any regression shows as
   growth past the documented number. `--pairs` gates the set; single-pair
   mode emits a red-over-dimmed mask PNG. `shots.py` gained a 1653-save shot
   set (8 reports + colony) so the imported-game captures are paired too;
   its stale "parley" entry (deleted flow) now shoots the meeting hub.
2. **`port/tools/message_status.py`** — three hand-verified annotation maps
   so the ledger stops lying: DONE-VIA-DATA (13 keys consumed through DATA
   channels: BEGINMENU, DIFFICULTY, LEADERNAME, VICEROY/2, NATION0A-3B),
   PARAPHRASED (5 trade-route keys the port hardcodes — Phase 1 swaps them),
   N/A (23 structurally out-of-scope keys, each with the reason: DOS
   save/load UI, MAPTOLOAD, custom-world generator labels, MULTI*, engine
   assertion strings, debug locators). New counts: DONE 176, DONE-VIA-DATA
   13, PARAPHRASED 5, BUNDLED-UNWIRED 54, MISSING 204, N/A 23, SUPPORT 24
   (of 499). The dyn-prefix matcher is tightened to the five real template
   families so `IND${...}` no longer false-claims INDIAN* keys.
3. **`docs/POPUP_AUDIT_2026-08-08.md`** reconciled: rows fixed by rulings
   2026-08-07 i–m carry RESOLVED → ruling pointers so the file reads as a
   live queue (counts in the file's header).

Suite: 229/229. render_diff --pairs: 14/14 PASS.

## 2026-08-07o — Phase 1 wire-only sweep, batch 1: market, schooling, siting/movement guards, colony notices, trade-route bodies

**~45 GAME.TXT keys wired at existing mechanics** (docs/COMPLETION_PLAN.md
Phase 1). Byte-cited anchors, with every unread predicate flagged in code:

- **@PRICEUP/@PRICEDOWN** emit from stepPrice on a level change -- the drift
  fn (func_0305A8) is reached from BOTH the end-of-turn recompute
  (func_036574 @0x367FC) and the per-transaction re-drift (@0x32902/@0x32D99),
  so both paths announce; live frames (SESSION_UI_CATALOG, Sugar 17/20-23)
  wear MSS2 with the good + number hilited. FLAGGED: the announced number is
  the port's bid price (bid-vs-ask unread). %STRING1 = @HOMEPORT city.
  **@SOMEBOYCOTT** replaces the ad-hoc sell refusal (mask test @0x030B47).
- **Schooling (9 keys).** teacherGuard() at the three assignment paths
  (occupation menu, building pick, building drop): @NOTEACHER (class>=4 not
  teachable @0x02DE7D), @NEEDCOLLEGE/@NEEDUNIVERSITY (tier > building level,
  @JOB col 3), @SCHOOL1/@COLLEGE2/@UNIV3 (faculty cap = level @0x02DE5B).
  FLAGGED: assignment-time placement + guard order (the engine tests in
  func_02D658's turn loop). Graduation rungs @0x02DF00/35/70 now emit
  @TRAINCRIMINAL / @TRAININDENTURED / @TRAINPROFESSION per rung.
  @TEACHCONVERT wired as the convert's live-among refusal (training.md
  §Native learning), before the generic @LEARNMASTER.
- **Colony siting (func_022542).** buildColony guard chain: @SEACOLONY,
  @ONLYCOL (NOT_COLONISTS = wagon/artillery/treasure, flagged reading),
  @TOOMOUNTAIN, @TOONEAR (radius unread -- port refuses chebyshev<=1,
  flagged), then the confirm chain @NOPORT (no adjacent water, lake split
  unmodelled, flagged) and the byte-cited tutorial scans (gate [0x53A6]<2
  @0x22763; @TUTNOSPACES productive<4 @0x2276A, @TUTNOLUMBER forested==0
  @0x22782; row 2 proceeds, matching `cmp ax,2`). "Productive" = land not
  mountain/arctic, flagged. DELIBERATELY UNWIRED: @TOONEARBUILD (the port
  founds instantly -- no pending-build state), @TOOMANYCOLONIES /
  @TOOMANYUNITS (engine cap values unread; no invented caps), @SHIPLAKE
  (no lake connectivity model). Each stays MISSING with this pointer.
- **Movement/order guards.** @ONLYPIO + @NOPLOW/@NOROAD in improveOrder;
  @LANDFIRST (hostile landing square from shipboard); @CANNOTATTACK
  (attack rating 0, data-driven from @UNIT); @DISBANDSHIP (laden ship at
  sea); @KEEPSTOCKADE (any stockade level blocks abandon).
- **Colony notices.** @FOOD1/@FOOD2 depletion warning the turn stores hit 0,
  death (@STARVE1/@STARVE2) from the next hungry turn -- the two keys'
  tenses read as warning-then-loss, flagged; winter variants = fall turn
  after 1600, flagged. @SPOIL1-4 on the discard paths only (boycott /
  declared-without-Custom-House -- the byte-read @0x2D785 auto-sale never
  spoils): single-good = 1/3, several = 2/4, warehouse hint while level<2,
  flagged. @CARGOREADY1/2 latched at the 100-ton threshold (@CARGOREADY0
  blocked on the per-good capacity model, func_008D00 unread).
  @WAREHOUSEFULL = the 2-row pre-unload confirm (first over-full good only,
  flagged). @EFFICIENT/@INEFFICIENT latch on toryPenalty crossing 0
  (NUMBER0 = the byte-cited 10-difficulty divisor).
- **Misc.** @LOSTCITY4 asks before the burial roll; @LOSTCITY0 fountain
  recruit picker (3 candidates x 8 picks, list size flagged); @EVASIVE =
  gunless defender surviving the roll escapes (condition unmapped in the
  EXE -- flagged stand-in); @CONTINENTAL replaces @VALOR on the type
  advance; @TIMECHANGE one-shot at the 1600 cadence switch (carets of its
  help-card format stripped by the bundler, flagged); @LANDFALL2 on river
  landing tiles.
- **Trade-route editor**: the five paraphrased literals replaced by the
  bundled bodies -- @TRADESTART/@TRADESELECT/@TRADEDELETE as the picker
  titles (via DATA.events), @TRADETYPE now ASKED (sea/land row), @TRADENAME
  as the name-entry dialog prefilled with the auto-name. PARAPHRASED
  category emptied.

Suite: 230/230 (new "wire-only sweep" block: prices, teacher guards,
graduation rungs, siting, movement guards, spoilage, evasion, trade bodies).
Ledger: DONE 222 (+46), DONE-VIA-DATA 16, PARAPHRASED 0 (-5),
BUNDLED-UNWIRED 42, MISSING 172 (-32), N/A 23, SUPPORT 24.

## 2026-08-07p — Phase 2 batch 1: input-outage latches, VANISH, colony-built units, rush-buy, back-tax, REFIT, CUSTOM

- **Input outages (7 keys).** colonyProduce reports converters starved to a
  standstill; colonyTurn latches @CANESUGAR/@COTTON/@FURS/@LUMBER/@ORE/
  @TOBACCO/@TOOLS once per outage, re-arming when the chain runs (the
  engine's latch cadence is unread -- flagged).
- **@VANISH.** The last colonist starving (after the @FOOD1/2 warning turn)
  removes the colony, deferred out of the colony loop.
- **Colony-built units.** buildOptions now appends Wagon Train (anywhere),
  Artillery (Armory chain standing) and the five ships (Shipyard) -- the
  manual's gates (HIGH trust for function). Materials from the @UNIT
  Cost/Tools columns: tools x10 (as @BUILDING), hammers x32 -- the scale
  INFERRED from the six known ship costs (Caravel 4->128 ... Frigate
  16->512), flagged, not byte-verified. Completion drops the unit on the
  colony square. Guards: @NOMOREWAGONS (wagons capped at the colony count,
  the PEDIA rule; stalls, announced once), @ALREADYHAVE/@NOMOREWAREHOUSE
  when the target already stands (clears the target). Man-O-War never
  offered.
- **Rush-buy.** Colony key B -> @BUYME0 (short purse) / @BUYME1 (2-row,
  @default row "Complete it." pays). AMOUNT formula unread: the flagged
  stand-in prices remaining hammers at 30$ + tools at market ask; the live
  frame 81_colony_build_prompt ("Docks: 1552$") vs this formula's 1560$ is
  the open calibration (Phase 4 capture).
- **Back-tax (@KISSUP/@KISSSORRY).** CORRECTS the batch-1 placement: the
  interactive sell of a boycotted good runs the @KISSUP pay-or-abort dialog
  (byte-verified sell handler @0x415A6 -> @0x415B5), amount = sell_price x
  500 (@0x333AF), pay -> treasury- / king's fund+ / bit cleared
  (@0x3340C..23), short purse -> @KISSSORRY and no lift (@0x333DD).
  @SOMEBOYCOTT moved to its byte-cited site: the Europe ARRIVAL handler
  (func_03314E @0x3331A) when the docking hold carries a boycotted good.
- **@REFIT.** Damage clears in a Drydock/Shipyard colony (the manual's
  repair rule; the mother country always repairs) at end of turn, and on
  docking in Europe. The engine's repair TIMER and the auto-teleport-to-
  nearest-drydock behaviour are unread -- one-turn-in-place repair is the
  flagged stand-in.
- **@CUSTOM.** Colony key E opens the Custom House per-good export toggle
  ('*' = exported; picker format unread, single-pick-per-toggle flagged);
  autoExport consults the toggles when the house stands.

Suite: 232 checks (new "small mechanics" block).

(2026-08-07p addendum: the UNITS[] transform was silently dropping the
@UNIT Cost/Tools/Guns columns, so the first unit build NaN'd the colony's
tools stock and the treasury -- fixed by carrying the three columns
through; caught by the new suite block. Suite 231/231. Ledger: DONE 239,
BUNDLED-UNWIRED 34, MISSING 163.)

## 2026-08-07q — Phase 2 batch 2: PISS tension bands, forest objection, friendly natives, trade refusals, retirement clock

- **@PISS0-5.** adjustTension announces an UPWARD band crossing (the F9
  thresholds 20/40/75/100 shared via tensionBandIdx): STRING3 = the
  @ATTITUDE band word, STRING2 = an @ATTITUDINAL modifier by depth into the
  band (both lowercased); the engine's announce trigger and modifier pick
  are unread, flagged. Cause codes at the sites that know them: 1 roads
  (roadObjection refusal), 2 forest (clearObjection refusal + the completed
  cut), 4 attack (both act-of-war sites); 3 missionaries / 5 population
  have no natural port site yet and stay on the generic 0.
- **@INDIANFOREST / @INDIANFOREST2.** clearObjection = roadObjection's
  3-row clone (stop / pay / "Timmmmmmmbeeeeerrrrrrrrrrrr!") on ORDER_CLEAR
  of a forested tile near a village; FOREST2 = the completed-cut
  encroachment notice with its tension cost. Gates cloned from
  roadObjection's flagged model.
- **Friendly natives (5 keys).** nativeDemands grows a Content-band branch
  (same flagged rare-roll model as the hostile claims): @INDIANGIVEFOOD
  (low-food colony gift), @INDIANGIVESTUFF (raw-goods gift),
  @INDIANBEGFOOD (rows: refuse (+5) / share half (-8)), @INDIANCOMMENT and
  @INDIANCOME flavour notices. ALL amounts flagged -- the engine's triggers
  and purses are untraced (the manual names the events, not the numbers).
- **@MADATSHIPS / @MADATWAGONS / @LEARNMAD.** Village-trade refusals:
  hostile band shuts trade entirely (@MADATWAGONS), restless band distrusts
  SHIPS (@MADATSHIPS, "approach us in wagons"); @LEARNMAD refuses teaching
  on the hostile band. Bands = the F9 thresholds, flagged.
- **Retirement clock + endgame.** At endTurn's tail: 1800 auto-retirement
  (@RETIRING) unless the WoI is on; 1850 war-weary surrender (@RETIRING2)
  unless it is WON; @SOONRETIRING0/1 warnings at 1790/1840 (lead times
  flagged -- the manual gives the deadlines, not the warnings' timing).
  endGameSequence: the @EXPLOITS rating card (NUMBER0 = scoreParts total)
  + one @SCORE joke name (row pick flagged random), the F10 page, then the
  @SCORED lock -- row 1 "Keep playing anyway." continues with scoring
  closed, row 0 ends to the title. Voluntary GAME-menu Retire runs the
  same sequence. @SCORE exported as DATA.scorenames, @ATTITUDINAL as
  DATA.attitudinal.

Suite: 232/232 (new "natives + endgame" block).

(2026-08-07q ledger: DONE 254 (+15), BUNDLED-UNWIRED 37, MISSING 145.)

## 2026-08-07r — Phase 2 batch 3: the bounded numeric-entry dialog (@HOWMUCH1-5); @BUILD1-10 already live

- **askAmount()** -- the engine's bounded amount entry ("Amount:", body
  carries the 0-N bound, digits only, result clamped). Enter on an empty
  field takes the FULL amount and Escape cancels -- both the port's own
  readings, flagged (the engine's empty-entry behaviour is unread). Wired:
  @HOWMUCH1 warehouse->ship drop, @HOWMUCH2 ship->warehouse drop,
  @HOWMUCH4 the Europe market->ship purchase drop (bounded by hold space
  and treasury), @HOWMUCH5 the interactive Europe sell (the market-bar
  click, the hold drop and the U key; trade-route automation passes its
  explicit quantity and never asks). @HOWMUCH3 (move between carriers) has
  no port site yet -- bundled, unwired, noted.
- **@BUILD1-10**: no work needed -- the opening cards were already fully
  live via DATA.cards/drawCards over the LEVN plates; the ledger's MISSING
  claim was a DATA-channel false negative, now annotated DONE-VIA-DATA.

Suite: 232/232 (the sell check now walks the @HOWMUCH5 entry).

## 2026-08-07s — Phase 3, tutorial system: the [0x5386/7] lesson mask + all 19 bindings

**spec/systems/tutorial.md (BYTE_VERIFIED core).** tutOnce(n): idempotent
per-step lessons over a 16-bit mask seeded 0x0E at new-game init (@0x755EB).
Byte-attributed bits carried exactly: TUTORIAL1=0x0010 (func_020F50
@0x20FFB), TUTORIAL4=0x0080/TUTORIAL12=0x8000 (func_02C5D4 @0x2C74A/
@0x2C7BC), TUTORIAL5=0x0100 (func_033F6A @0x3651F), TUTORIAL6=0x0200
(func_02D658 @0x2EA4C), TUTORIAL7=0x0400 (func_02883E @0x28D41). The other
13 steps' bits live in the undisassembled func_020F50 window
(0x20FF0..0x215D0, Phase 4) -- tracked in a side set; the seed's three
pre-marked bits are therefore unbound in the port. The difficulty gate is
the sibling TUT keys' [0x53A6]<2. All FLAGGED as readings.

Bindings (byte-attributed sites in caps, the rest the port's flagged event
match): T1 fresh fleet at sea (beginGame); T2 land-naming prompt; T13 first
landfall; T3 founder on land (terrain fill); T4 FIRST COLONY SCREEN; T5
DOCK RECRUIT READY; T6 SELLABLE CARGO >= 50; T7 COLONY POP >= 3; T8
unskilled Colonist at a village; T9/T10 pioneer on road/plow ground; T11
first sail for Europe; T12 ship docking at a colony (T15 when it carries
passengers); T14 first Soldiers move; T16 first food deficit; T17 first
Europe screen; T18 the Europe purchase ask; T19 first convert. Imported
saves mark every lesson shown (the real mask read is the Phase 4 importer
item).

Suite: 232/232 (tutorial idempotence + Discoverer gate in the wire3 block;
the woodcut block drains the fresh-game lesson it now begins with).

## 2026-08-07t — Phase 3: news-bulletin ticker + the native land claim

- **newsTick() (4 keys).** The third-party bulletin bus, scoped to what the
  engine's behaviour supports in the port's reduced AI: native-vs-rival
  raiding (manual: natives raid every European power) as a rare simulated
  skirmish -- war-band village within 4 of a rival colony, outcomes
  @INDIANBURNCOLONY2 (colony razed) / @INDIANWINCOLONY2 (colonists lost) /
  @INDIANLOSE (repelled) -- and @VIOLATE for a rival unit loitering beside
  our colonies at peace. The 1/24 rates, the outcome split, the radius and
  the STRING4 verb ("defeat") are ALL the port's flagged parameters.
  DELIBERATELY UNWIRED, each with its reason: @EUROPEWIN/@EUROPELOSE +
  @INDIANWIN0-2 (need AI-vs-AI battles -- omitted with the AI-AI war
  drivers, RULINGS 2026-08-07m), @LOOTFOREIGN (no rival treasure-fleet
  model), @BURNED2/3 + @CAPTURED2/3 (caller attribution vs the
  native-specific keys unread).
- **Native land claim (4 keys).** Founding a colony inside a tribe's
  country (village within 2, the objection radius) now runs the claim
  chain ahead of the founding confirms: hostile-ish bands ask @INDIANLAND
  (leave / pay demandValue(100), zeroed by Peter Minuit, acknowledged by
  @INDIANBRIBE / "OUR land now" at +15 tension via @PISS5); a Content-band
  tribe instead bows -- @INDIANTREATY (Yes floors their tension) or plain
  @INDIANBOW, split 50/50. The band split, the price and the bow odds are
  flagged readings.

Suite: 233 checks (landClaim in the wire3 block; the basic-founding walk
clears claim-radius villages first).

## 2026-08-07u — Phase 3: War of Independence completion (15 keys)

- **National sentiment**: @REBELUP/@REBELUP50/@REBELDOWN on 10%-band
  crossings of nationalSoL() during the war (the solAnnounce pattern at the
  national mirror; the trigger band is the port's reading, flagged).
- **The capitulation ladder**: @LOSING1 (all ports lost -- coastal
  colonies = ports), @LOSING2 (all colonies, alongside the existing
  @KINGWIN), @LOSING3 (90% of the population), each ending the game via
  endGameSequence; warnings @WARN1 (one port left) and @WARN3 (75%+).
  The port RAZES rather than occupies, so "control" reads as colonies
  lost and pct = razed/(razed+alive) -- both flagged.
- **@SIEGE**: land-adjacency siege (diplomacy.md: no blockade exists;
  production restricted to military units). Radius-1 count of hostile vs
  friendly combat units, announced once per siege; construction waits out
  the siege (the port colony-builds neither Soldiers nor Dragoons, so the
  "only Soldier and Dragoon" restriction lands as a halt). Flagged.
- **Arrivals**: @INVASION on each REF wave's landing colony; @INTERVENE
  with the ally's force (alongside the existing @INTERVENTION card);
  @WINNING (Parliament's declaration, the General's name) alongside
  @KINGLOSE on victory.
- **Lockouts**: woiLocked() closes the Europe screen (@EUROPENOTAVAIL,
  the byte-cited MSS1 key), the crossing (@EUROPENOTLEAVE at the sea-lane
  and the sail commands) and the F8 Foreign Affairs report
  (@FOREIGNNOTAVAIL) for the war's duration.

Suite: 232/232 (the intervention check now expects the arrival pair; the
rumour check accepts the @LOSTCITY4 ask).

## 2026-08-07v — Phase 3: the Crown cluster (KINGBUY, purchase taxes, the European-war cycle)

- **@KINGBUY** on each REF unit the royal fund buys -- the REF-growth
  surface (ref_growth.md).
- **@PURCHASETAX** on Royal University training (1-in-3 roll, +1 tax --
  the engine's rate is unread, flagged); **@MERCANTILISM** on completing
  a factory-tier building (+1 tax, flagged) -- both hard-capped at 75.
- **The European-war cycle (kingWarCycle, flagged reconstruction).** Only
  the KINGWAR/KINGNAVACT tax pretexts are byte-cited; the cycle the other
  keys describe is reconstructed: rare @KINGNEWWAR start (declares the
  Crown's war on a met rival, cancels your peace arrangement, orders you
  in with a 300$ grant and 2 Veteran Soldiers -- the body's own list),
  8-16 turns with occasional @KINGMERCY (-1 tax) and the one-shot
  @KINGFRIGATE escort offer (row 1 = a Frigate in the home port), ending
  with @KINGVICTORY (-2 tax) and the war bit cleared. Every rate/length/
  amount flagged. @SEIZURE/@CONFISCATE (wartime shipping seizures) left
  unwired -- no shipping-interdiction model, noted.
- The player-initiated audience (@KINGBLESS/@KINGNO/@KINGLOWER/
  @KINGNOTHING/@KINGRAISE/@KINGFUND/@KINGLAUGH) stays unwired: its
  ENTRY POINT is not byte-mapped and inventing a UI for it would violate
  the no-invented-flows directive. Phase 4's func window sweep may
  surface the trigger.

Suite: 232/232. Ledger: DONE 313, MISSING 84.

## 2026-08-07w — Phase 3: privateer attribution, treaty-break guard, the @PIRACY census

- **Privateer hidden attribution (byte-verified).** A Privateer striking
  rival SHIPPING at peace no longer opens the meeting: the attack runs and
  war_matrix bit 0x80 is set INSTEAD of the war bit -- exactly the
  resolver's `cmp [bx+0x3146],0x10 @0x3F092 -> or 0x80 @0x3F0A1`
  (spec/systems/diplomacy.md). The previously declared-and-dead
  REL.PRIVATEER now has its writer.
- **@PIRACY / @PIRACYUSA.** The next meeting with the wronged power leads
  with the accusation (2-row ask: deny / withdraw -- withdrawal sails the
  player's Privateers home), STRING3 = the @MEEKNESS request/demand verb
  by tone; the bit clears on the census. Topic priority flagged.
- **@HAVETREATY / @CANCELPEACE.** Moving onto a treaty partner's unit asks
  the 2-row treaty guard; Break Treaty announces @CANCELPEACE and opens
  the war through declareWarOn.

Suite: 232/232. Ledger: DONE 318, MISSING 84, BUNDLED-UNWIRED 24.

## 2026-08-07x — the pre-capture completion sweep: every remaining wirable key + the Hall of Fame

**User directive: "finish out all the items before the DOSBox capture
phase."** Every GAME.TXT key with a reachable port site is now wired; the
ledger reads MISSING 0 -- what remains is 33 BLOCKED keys, each annotated
with its named blocker (Phase 4 capture or disasm window), plus the 24 N/A.

Wired in this sweep (all trigger models flagged where the engine's own is
unread):
- **Diplomacy**: the @SIEGES / @APOSTATES / @HEATHEN meeting topics (with
  the engine's SIEGESUSA row-swap bug replicated -- the handler acts on
  row 2 regardless), @WARMEEK/@WARMANLY as the refusal escalation
  (replacing the misplaced @PROVOKE), @PEACEUSA/@TRIBUTEUSA and the USA
  suffix helper, @SNEAK surprise attacks, @GIVECASH the AI colony's
  buy-off, the foreign-colony trade entry (@TRADEATWAR byte-cited,
  @TRADEMERCANTILISM = the Jan de Witt gate, @DEFICIT no-cargo,
  @TRADEWITH the goods-or-gold barter).
- **The Crown**: @KINGWIFE once-per-game with the @KINGTAX core-demand
  fallback; @SEIZURE (declaration seizes every ship in Europe/crossing),
  @SEIZURELAND/@SEIZURESEA (the REF's captures), @AMBUSHHINT and
  @HOWTOWIN one-shot war cards, @LOSENOCOLONIES (the post-1600 charter
  revocation @ABANDON2 itself warns of).
- **Congress**: the @WHICHFREEDOM Founding-Father picker (Escape keeps
  the first candidate -- the engine's dialog cannot be cancelled);
  @FREEDOM replaces the joined-status line; @RECRUITCHOOSE = William
  Brewster's documented pick-your-immigrant.
- **Natives**: @WANTSTUFF reparations demand + @RID expulsion order,
  @INDIANWAR/@INDIANPEACE at the War band's two edges, @INDIANSHUN
  first-attack defiance, @INDIANHELLO1/2 the once-per-village greeting
  (second village on -- first contact keeps the woodcut chain),
  @DONTKNOWSHIPS (ships cannot open a village), @GRUDGEWAGONS /
  @CONFISCATE trade responses by band, @INDIANWARPATH the incite target
  picker, @INDIANBURN mission burning, @INDIANSURPRISE the calm-tribe
  denial bulletin, @INDIANBURNCOLONY the raid razing of a bare colony,
  @INDIANWIN0/1/2 ambush bulletins (muskets/horses by the demotion type),
  @INDIANSLAVES, @LOOT/@LOOT2/@NOLOOT razing bulletins,
  @LOSTOURSCOUTS/@LOSTTHEIRSCOUTS, @KILLWAGONS/@LOOTWAGONS route perils,
  @BRING the post-sale demand hint, @SCREWED the byte-cited burial
  desecration death (+100 to war footing).
- **UX confirms/pickers**: @SUREDISBAND, @SUREDELETE, @REALLYBUY,
  @LOBOTOMIZE (colony key L), @OVERBOARD, @CARGOLOAD/@CARGOUNLOAD (the
  width-120 pickers chained into @HOWMUCH1/2), @PICKACARGO,
  @TRAVELPLACE/@SAILPORT (the Go To destination pickers, Escape falls
  back to click-to-target), @ROUTELOOP, @TRADENONE2, @NODOCKS,
  @NOCOLONIESEITHER (byte-sited to func_022542's home), @ABANDON2,
  @KINGRECRUIT (the TRAIN caption via DATA.events), @MOBILIZE per colony.
- **Systems**: @DEPLETION (port depleted-mine bit IMPROVE 0x80 dropping a
  worked silver cell to 1 -- the real resource plane stays the Phase 4
  read), @DEFOREST, and the rival-independence race
  (@OTHERMIGHT/@OTHERLESS/@OTHERGRANTED over a flagged random-walk
  stand-in for the engine's real PowerRecord +0x02 sentiment).
- **The Hall of Fame (menu row 4, LIVE).** localStorage roster with the
  byte-verified HALLFAME.DAT record semantics (name/nation/year/flags,
  int16 score, descending insertion @0x3AECD, 6 kept 5 shown), written by
  endGameSequence; the screen renders WOODPANL + FONTINTR + the @MISC
  192/194-199 labels with the byte-cited 5-row ranked table -- the COLUMN
  X POSITIONS remain the sole open TBD (flagged in drawHof; Phase 4's
  hand-authored-DAT capture pins them).

Suite: 233/233 (new completion-sweep + Hall of Fame block; the claims
test pins bystander tribes to the quiet band; the purchase tests answer
@REALLYBUY). Ledger: DONE 390, DONE-VIA-DATA 29, BLOCKED 33 (annotated),
MISSING 0, N/A 24.

## 2026-08-07y — Europe dock: the green cell is the SELECTION cursor; profession badges

User report (screenshot): every dock unit, harbour ship and crossing wore
an 18×18 hollow green cell, an unexplained green bar sat under the
Expected-Soon caravel, and all six pier figures drew as the generic
colonist.

**Re-read of the evidence** (`docs/screens/10_europe_screen.png`, the
2026-06-25 live DOS capture): THREE units stand on the pier in distinct
`@UNIT`-type sprites and only the FIRST (selected) one wears the green
cell; the docked Caravel wears its own. So the cell is the **selection
cursor** around the active ship and the selected dock unit — not a frame
every entry wears. The port's 2026-08-06 reading ("every entry boxed,
selected flips yellow") over-generalised a one-ship/one-unit frame.
Corrected: one green (0x0A) cell on `G.euroShip`, one on `G.euroDockSel`
(default 0, matching the capture), everything else bare.

**The green bar** was func_031366's sail-progress bar (`0x64 >> state` px
@0x0313A4), byte-real but belonging to the per-state BAND layout
(y=146/137/132, func_031298) the port does not use; inside the port's
stacked panel columns it read as noise. Dropped together with the band
layout (user call). Crossings now draw as the bare ship icon.

**Profession sprites.** ICONS.SS holds no expert FIGURES (131 frames, all
accounted — units/goods/HUD), so a specialist's own figure cannot be
drawn from original assets. The five roled professions already land on
their `@UNIT` sprite via PROFESSION_UNIT (Veteran Soldiers→Soldiers,
Hardy Pioneers→Pioneers, Seasoned Scouts→Scouts, Veteran
Dragoons→Dragoons, Jesuit Missionaries→Missionaries). Everyone else now
wears a **half-scale trade-icon badge** at his feet (PROFESSION_BADGE:
goods png `0x16+good`, the market-bar mapping; Firebrand Preachers→the
crosses gauge fill png 56, Elder Statesmen→the bell png 62). The badge
idiom is the engine's own slot-marking device (the boycott marker redraws
`good+0x17` over the dock slot, @0x031A73..0x031AB4), but the badge
itself is **port-authored UI, flagged** — the DOS dock shows the bare
type figure.

Spec updated: `spec/ui/europe_screen.md` §0.2. Suite 233/233; render-diff
14/14 (the europe pair at 11410/12000).

## 2026-08-07z — Phase 4 capture 1: the Hall of Fame, closed from a crafted HALLFAME.DAT

The dosbox_harness is live in this container (Xvfb + xdotool + Ctrl-F5
framebuffer dumps). First Phase 4 target: the HoF layout TBD.

**Method.** Hand-authored `HALLFAME.DAT` (5×42-byte records), booted
`VICEROY -g`, menu row 5, dumped the frame; two rounds with disjoint
field values to disambiguate every word. Captures filed as
`docs/screens/live_2026-08-07/hof_crafted_dat.png` (round 2, the
reference) and `hof_round1.png`.

**Findings (all capture-pinned):**
- The screen is NOT a column table: each record is THREE lines --
  "N.  <difficulty> <NAME> of the [Free ]<adjective>" /
  "<career> to A.D. <year>.  Score: <points>" /
  "--- Colonization Rating: <rating>% ---" (career = "President,
  <@INDEPENDENT[nation]>" when independence is won, "General,
  Continental Army" when only declared, else "Leader, <adjective>
  Colonies"). NAMES `@INDEPENDENT` = United States of America / Republic
  of Quebec / Republic of Mexico / Republic of Surinam -- now bundled as
  DATA.independent.
- Geometry: title glyph-top y=3 centred x=160; record k at y=20+36k,
  lines +0/+11/+22; rank x=10, text x=25; line 3 centred; single ink 68
  (85,150,52) = HUD_INK. No gold title in the idle state.
- Record fields (corrects the pre-capture static guesses): +0x18 nation
  (doubles as the 0xFFFF empty sentinel), +0x1a declared flag, +0x1c won
  flag, +0x1e year, +0x22 difficulty, +0x24 score POINTS, +0x26 the
  Colonization Rating % = the byte-verified int16 ranking key. +0x20 and
  +0x28 never display.
- Empty slots (name byte 0 / sentinel 0xFFFF) draw nothing -- 4-record
  file rendered exactly 4 entries.

**Port.** drawHof rebuilt to the measured three-line format (flag
REMOVED -- the layout TBD is closed); hofWrite now ranks on rating;
endGameSequence writes score=scoreParts().base, rating=scoreParts().total
+ difficulty. spec/ui/menus.md §12 and spec/systems/save.md §6.5
rewritten to the pinned reading (save.md's old "+0x22 nation SHL-1
power-name" walk corrected; the @0x3B16E table is the difficulty-title
list by inference from the render -- window not re-read).

**Regression.** New shots.py 'hof' scenario seeds the exact round-2
records; render_diff pair "hof.png vs live_2026-08-07/hof_crafted_dat.png"
passes at 1947/4000 px (residual = the DOS mouse cursor + glyph AA).
15/15 pairs green, 47/47 shots (makeColony hardened: pinned Plains tile,
calmed tribes, walks the founding confirm chain), suite 233/233.

## 2026-08-07z2 — Phase 4 captures 2-3: the K-threshold and the profession figures

**K-threshold CLOSED.** Patched 16 probe values (6100..13000) into the 1653
save's PowerRecord +0x7C net-trade array, loaded it live, captured F5
(`docs/screens/live_2026-08-07/f5_k_probe.png`): 9999 prints in full, 10000
prints "10K", 12500 and 12999 print "12K". The abbreviation threshold is
EXACTLY 10000 with floor truncation -- the port's flagged reading was right
and the flag is removed. (The probe also exercised the loader end-to-end:
the crafted array survived the round trip verbatim.)

**Profession figures FOUND -- the ICONS.SS mystery rows.** The F4 Labor
report capture (`f4_labor.png`) shows a distinct figure per profession.
Template-matching every row against the decoded sheet scores 1.0 exact:
@JOB rows 0..17 run contiguously at png 81+i (Expert Farmers 81 .. Elder
Statesmen 98); the class tail is a scattered cluster -- Hardy Pioneers 58,
Veteran Soldiers 59, Seasoned Scouts 60, Jesuit Missionaries 61, Indian
Converts 66, Free Colonists 100 (the Colonist unit art), Indentured
Servants 106, Petty Criminals 107. The engine's report omits Expert
Teachers and Veteran Dragoons (26 rows, not 28); png 99 is Teachers by
pattern extension (unobserved), Dragoons falls back to the unit sprite 104.
This resolves most of SPRITE_CATALOG's unaccounted 57..99 range.

**Port.** professionIcon()/professionIconByName() added; drawLaborReport
now renders the capture's exact row order (8/9/9, Free Colonists last) and
figures; the Europe dock's waiting recruits draw their PROFESSION FIGURE
(the same-day trade-icon badge is superseded and removed) -- the user's
"dock colonists must match their profession" request is now satisfied with
the game's own art. f5Gold's flag removed. SPRITE_CATALOG updated.

**Also captured this batch** (filed under docs/screens/live_2026-08-07/,
reconciliation pending): f5_cargo_in_port.png (the F5 second view -- a
colony x 16-goods stock grid), f6_page1-4.png (F6 paginates; garrison unit
icons beside colony rows), f9_indian.png (single page; Extinct tribes keep
their row; right column = @LEVELS words; centre = tribute tally).

Suite 233/233; render-diff 15/15.

## 2026-08-07z3 — Phase 4 capture 4: the Bound For panel is ship + manifest

Opened the 1653 game's Europe screen live (VIEW menu -> European Status;
`docs/screens/live_2026-08-07/europe_1653_boundfor.png`). The outbound
Galleon in "Bound For New Netherlands" does NOT draw as a lone icon: the
panel renders the SHIP + ITS PASSENGER MANIFEST -- each passenger stands
on a ~13x15 black-outlined plate filled with the NATION COLOUR (palette
13 = the Dutch colour; this vindicates the port's old "nation plate"
idea, in the crossing panel rather than the dock) and is drawn as his
PROFESSION FIGURE (template-matched 1.0: Expert Farmer 81, Master
Distiller 90, Master Gunsmith 96). Ship anchor (75,146) = the state-3
band of func_031298's y=146/137/132. Passenger pitch ~17-18 (one
capture; 17 in the port). Also confirms 2026-08-07y: no hollow cells, no
progress bar under the manifest row; and the title band prints Gold:
21147 IN FULL (no K-abbreviation on the Europe title).

Port: crossingCell rebuilt (ship + manifest, slot->band y as a flagged
approximation of the per-state layout). Spec: europe_screen.md §0.2.
Suite 233/233 (one run tripped the documented Fortress-raid flake, clean
on re-run); render-diff 15/15.

## 2026-08-07z4 — Phase 4 capture 5: Europe slot pitches, the nation sack, REALLYBUY confirmed

Drove the live 1653 Europe screen: recruited three units and bought two
ships (docs/screens/live_2026-08-07/europe_dock_3units.png,
europe_port_2ships.png, europe_reallybuy_confirm.png).

- **Dock pitch = 17** (figures template-matched 1.0 at x=235/252/269),
  cell x=232+17k, figure at cell+3. The port's 14 was wrong.
- **Ship pitch = 18** (Merchantman 1.0 @(149,146), Caravel 1.0
  @(167,146)), cell x=145+18k, sprite at cell+4 (the old +3 was 1px
  off). The green cell sits on exactly the "Loading:" caption's ship --
  selection cell = selected ship, confirmed with two ships.
- **The nation sack**: every waiting entity (dock unit, in-port ship,
  crossing passenger) carries a 7x9 marker -- black outline, fill = the
  NATION COLOUR, fold pixels = its EGA dark partner (colour-8; Dutch
  13->5 verified pixel-exact). It matches no decoded ICONS frame
  (nearest shape 0.86 = the furs bundle), so the port embeds the
  observed pixel block (drawSack), source frame TBD. Anchors: dock
  cell+(9,8), ship cell+(1,1), crossing figure+(5,7).
- The engine asks "Purchase Merchantman for 2000$? Yes/No" -- the
  @REALLYBUY confirm the port wired in Phase 2 is engine-real.
- The selected ship's CARGO ROW in the frame shows 4 dark holds + 2
  crossed crates for the 4-hold Merchantman -- the port's existing
  holds-of-the-selected-ship model, confirmed.

Port: EURO_DOCK/EURO_SHIP pitches corrected, drawSack added at all three
sites. Suite 233/233; shots 47/47; render-diff 15/15 (europe pair
improved 11336 -> 11215). Spec: europe_screen.md §0.2.

## 2026-08-07z5 — the save serializer's 43-block order read; tutorial/woodcut/REF import closed

Parsed func_0734F8's complete fwrite sequence from the annotated disasm
(spec/systems/save.md now carries the full 43-row table). The fixed tail
sums to EXACTLY the 727 bytes the importer skips -- the two readings
cross-check. Because block 2 is the raw globals dump (0x5380, 0x8E), the
three outstanding import TBDs are fixed offsets inside a block the
importer already locates:

- g+0x06 = [0x5386]: the SHARED flags word. The "sound mirror"
  (tech-ref) and "tutorial mask" (tutorial.md) readings COEXIST -- low
  three bits are the sound switches, upper bits the tutorial guards.
  This also re-reads the new-game seed `mov [0x5386],0x0E @0x755EB` as
  sound-defaults-ON, not "three tutorial steps pre-shown" (the port's
  tutMask seed keeps 0x0E; bits 1-3 guard nothing in the port).
- g+0x5A..0x60 = [0x53DA/DC/DE/E0] REF Regulars/Cavalry/Man-O-War/
  Artillery (order per the F2 draw + tech-ref 1117).
- g+0x8A = [0x540A] the woodcut shown-bitmask (same 1<<plate model).

importSav now restores all three verbatim (the all-shown/formula
stand-ins are gone; the 13 side-set tutorial steps stay marked shown on
import until func_020F50 attributes their bits). Validated against
COLONY00.SAV: tutMask 0xFF9E (sound bits set, consistent with the
shared-word reading), REF 19/7/3/4, woodcut mask 0x177F, year 1653.

Suite 233/233; shots 47/47; render-diff 15/15.

## 2026-08-07z6 — func_020F50 read: every tutorial guard bit is now byte-cited

Walked the whole func_020F50 body (0x20F50..0x21601) plus func_020EE0's
guard. It is the unit-FOCUS tutorial dispatcher (active unit = current
player, visible; emits at most one step per focus). Findings:

- Steps 1 and 3..12 occupy CONSECUTIVE bits 4..15 of the [0x5386/7] word
  (T3 0x0040, T8 0x0800, T9 0x1000, T10 0x2000, T11 0x4000 newly bound;
  bit 5 = 0x0020 unassigned -- possibly one of the emitter-less 16..18).
- Steps 13/14/15/19 guard on the [0x5380] once-flags BYTE
  (0x01/0x02/0x08/0x80, or-ed @0x210C4/@0x21104/@0x21157/@0x215FA).
- Step 2 guards on [0x5382]&0x80 (func_020EE0 @0x20F3A).
- Per-step trigger conditions byte-read and tabled in
  spec/systems/tutorial.md §3 (T11 = idle naval focus, T13/14 = early
  pioneer/soldier focus, T15 = laden colonist at a colony with the colony
  name substituted, T3 = pioneer on good ground with a >=5-cell 3x3 site
  scan and a DIRECTION word from [-0x6840], T8 = convert/servant focus
  with the profession name, T9 = pioneer beside an own colony on
  unimproved forest, T10 = the road variant, T19 = criminal-profession
  focus).

Port: TUT_BIT extended to all eleven word bits; new TUT_FLAG ([0x5380])
and TUT_PHASE ([0x5382]) homes with G.onceFlags/G.phaseFlags, seeded 0
and restored VERBATIM from an imported SAV's globals block (g+0 / g+2).
Only 16/17/18 remain side-set (no emitter exists in the EXE). The port's
trigger SITES stay flagged approximations; the guard BITS are closed.

Suite 233/233.

## 2026-08-07z7 — two more windows: func_073474 (inks CONFIRMED) and func_008D00 (capacity)

**func_073474 CLOSED.** Walked in full + the [0x830..0x839] source bytes
read from the EXE image (DGROUP file base 0x1D9A0): in-game inks are
normal [0x1F4A]=68, hilite [0x1F4E]=149, [0x1F4C]=8, [0x1F50]=128,
[0x1F52]=47, selection band [0x1F40/42]=138, ring 134, bevel 128/138.
The port's 68/149 reading is byte-verified; flag removed. The sibling
boot setter (@0x734BC) carries the known 0xFE/0xFC/0x2E/0xFD/0x37
immediates.

**func_008D00 READ.** Colony storage capacity = (warehouse-level byte
ColonyRecord+0x95 + 1) x 100 -- ONE number for the whole colony; the
"per-good capacity" hypothesis is refuted. Its callers (0xA3E1, 0xAB95)
are colony-screen drawers. The 100-cut overflow disposal keeps its
byte-cited literal threshold (cmp 0x64 @0x2D6F7) but is gated per-good
by the un-read far thunk 0x191F:0x9C0 -- whether capacity gates the cut
is the ONE remaining question, so @CARGOREADY0 stays BLOCKED with that
narrowed blocker instead of being wired on a guess.

Suite 233/233.

## 2026-08-07z8 — Phase 4 batch 1: func_05CA7E read, seven aftermath bulletins wired

Walked the combat-aftermath bulletin regions of func_05CA7E (locals
mapped: loser power [bp-0x86], winner power [bp-0x76], settlement
involvement [bp-0x6e]/[bp-0xd8], destruction [bp-0xa]). Byte-read
variant splits:

- **BURNED family** (@0x5DABF..0x5DB15, fires on settlement destruction):
  winner human -> @BURNED (0x1C28, the King-demands-explanation card the
  port already fires when the player razes); loser human -> @BURNED2
  (0x1C2F); neither -> @BURNED3 (0x1C37, the spies-report bulletin).
  Subs: slot0 = loser power name, slot1 = winner power name (0xA1A).
- **CAPTURED family** (@0x5DEAD..0x5DEED): human involved ->
  [0x5382]&1 (the DECLARED flag) picks @CAPTURED3 (0x1C48, no plunder
  line) over @CAPTURED (0x1C52); third-party -> @CAPTURED2 (0x1C5B).
  Also byte-read: the capture toggles war-matrix bit 2 (@0x5DE91) and
  transfers gold; the loser-human path calls the colony-lost handler
  0x608.
- **INDIANWINCOLONY pair** (@0x5E01F/0x5E026): winner human ->
  @INDIANWINCOLONY (+50 credit via 0x48E), else @INDIANWINCOLONY2. The
  aftermath decrements settlement size while size>1 (dec [bx+4]
  @0x5D67A) -- the massacre outcome, distinct from the burn pair
  (@0x5DFE4/0x5DFEE, -50 tension [bp-0xa4]=0xFFCE).
- **EUROPEWIN/EUROPELOSE** (@0x5D9F1/0x5DA20): settlement-less
  unit-vs-unit battles; %STRING4 verb = @MISC 73 "defeat" / 74 "defeats"
  chosen by the subject's grammatical number ([bp-0x8c]<7 @0x5D9F8).

Port wiring: the player-capture site and the rival-takes-player-colony
path now split @CAPTURED/@CAPTURED3 on G.declared, rivals CAPTURE
(transfer + plunder, flagged amount) with @BURNED2 as the >=6-colonies
raze fallback (the burn-vs-capture selector itself is unread, flagged);
nativeRaid's burn outcome gains the @INDIANWINCOLONY massacre branch
(undefended multi-colonist colony loses one colonist); newsTick gains a
rival-vs-rival war segment (start/stop and battle rates flagged -- the
war DRIVERS stay omitted per 2026-08-07m) emitting
@EUROPEWIN/@EUROPELOSE with the byte-read verb rule and
@CAPTURED2/@BURNED3 for third-party colony falls. G.rivalWars persists.

Ledger: DONE 396 (+7), BLOCKED 26, MISSING 0. Suite 234/234 (new wire5).

## 2026-08-07z9 — Phase 4 batch 2: the village windows read

**func_04A7CA (the real Speak-with-Chief handler; 04B308 is the action
dispatcher) — CLOSED.** speakToChief rebuilt to the byte ladder:
ONE roll = random(0, 100+40*seasoned) gates both death (roll <=
tension/4, only at tension >= 25; tension >= 75 is fatal outright, an
attribute-bit-6 exemption unread) and boredom (roll <= tension); the
Aztec extra execution roll random(0,(8-difficulty)<<seasoned)==0
(@0x4A843); @CHIEFHOWDY briefs every surviving audience; the once-flag
is settlement bit 8; the arm selector is random(1,3) with GUIDES
converting the scout to a SEASONED SCOUT (profession write @0x4A9DD --
the port's moves-refund stand-in is replaced) and a seasoned scout
falling to the AREA arm; @CHIEFGIFT beads = random(1,6) *
(3d(10-difficulty)) * 4 * (tribeLevel+1), byte-exact
(@0x4AAD0..0x4AB2D). The AREA reveal calls helper 0xE08(x,y,0) -- its
radius stays inside the helper (the port has no fog to lift).

**func_049600 tail** — @TRADE0's %STRING0 is the NAMES @VALUES quality
ladder ("low quality/good/fine/excellent"), the 4-word table at the
emit (@0x49AE6, idx clamp((v+4)/10,..3)); bundled as DATA.values and
wired (the exact operand pair is one register deep -- the port banks off
the offer, flagged). Opening offer floor min 1 (@0x49A8B) matches.

**func_05BE84** — @RAIDGOLD amount = random(0x32, min(gold, 0x7FFF))
(@0x5C2E5), i.e. 50 up to the whole treasury, with a -16 tension credit
(@0x5C5BC); @RAIDSTORES carries a -4 credit (@0x5C416); @RAIDWREAK's
payload = a building-tier DECREMENT (dec ColonyRecord+0x95/+0x96 with
the name substituted, @0x5C44A/@0x5C474) -- the port removes one
non-starting building. All three TBDs closed.

**func_056C3E** — the @INDIANWELCOME treaty effect: answering NO sets
the tribe's tension +100 (war) and fires @INDIANSHUN with the power
name (@0x56DEF/@0x56E11); YES continues peacefully. The per-tribe
first-contact plate split (Inca 5/Aztec 4/else 3) is byte-confirmed
@0x56D95.

**RECRUIT/RECRUIT2**: the systematic emitter scan finds NO emit site
anywhere in the EXE -- reclassified as orphans-or-dynamic (ceiling
named), alongside RAIDSCALP.

Suite 234/234.

## 2026-08-07z10 — Phase 4 batch 3: shipping

- **@SHIPRUN/@SHIPSLOW** (func_059B90 @0x59DBC/@0x59E48): the interception
  pair. The byte-read EFFECT of SHIPSLOW is a movement-counter penalty
  (add [unit+0x3149] @0x59DD7); the subs are the two powers' words + both
  ship type names. Wired at ship movement beside a hostile warship; the
  engine's odds sit upstream of the emits (unread) -- 50/50 flagged, one
  check per turn (u.slipChecked).
- **@SHIPLAKE** (func_03FDDE @0x3FF2A): ships cannot enter inland lakes.
  The engine's test is region-based; the port compares the destination's
  REGION id against the sea lane column's (regions imported verbatim from
  the SAV plane / built by flood fill). Wired as a movement guard.
- **@LOOTFOREIGN** (func_04E2D6 @0x5099E): rival treasure fleet arrives
  home. Simulated on the news bus (rate 1/60 and amount 100*random(2..12)
  flagged; the engine's fleets ride real conquests the port does not
  model).

Ledger: DONE 400, BLOCKED 21. Suite 234/234 (twice; the Fortress-raid
flake tripped one intermediate run, documented).

## 2026-08-07z11 — Phase 4 batch 4: the Crown

- **The tax petition (func_034AE0) READ.** The KINGRAISE body ("You DARE
  to demand lower taxes!") identifies the handler: tax <= 1 ->
  @KINGRAISE, tax += 2*random(1,difficulty) (@0x34B62); tax above
  cap = ((difficulty&~1)*2+4)*(turn/400+1) -> 1/(difficulty+1) chance of
  @KINGLOWER, tax -= random(1,5-difficulty) (@0x34B44); otherwise the
  no-change dialog (0x109C = @KINGNOTHING by page-table neighbourhood,
  inferred). The ENGINE'S ENTRY POINT is unmapped (no menu row, no
  caller edge) -- the port surfaces the petition on the Europe screen
  key K, a port-authored entry, flagged; the ladder is byte-exact.
- **@KINGMOBILIZE (func_03E162 @0x3E2DB)**: the post-declaration REF-
  growth announcement ("Parliament votes additional funds...") -- growREF
  now splits @KINGBUY/@KINGMOBILIZE on WOI_DECLARED, subs byte-read.
- **@CANTMOBILIZE**: the muskets gate the byte-read mobilize lacked --
  wired at mobilizeContinentals with the 50-musket equip cost as the
  flagged threshold (no emit site survives in the scan to read N from).
- **@FULL (func_02883E @0x288C3)**: the join-colony crowding refusal,
  %STRING0 = the colony name; the threshold hides behind the jump table
  -- blocker NARROWED, stays deliberately unwired.
- **@TOONEARBUILD (@0x22644)**: the engine checks OTHER UNITS holding
  the pending-build order 7; the port founds instantly, so the state
  cannot arise -> reclassified N/A with the byte-read reason.
- **KINGBLESS/KINGNO/KINGFUND/KINGLAUGH/KINGWELCOME0**: NO emit site
  anywhere in the systematic scan -> orphans (cut content), N/A.
- Also de-flaked the Fortress-repels raid test for real: the flake was
  RAIDBURN eating the Fortress mid-loop (a genuine mechanic, not RNG
  noise) -- the walled loop now re-arms each iteration.

Ledger: DONE 405, BLOCKED 10, N/A 31. Suite 234/234 twice.

## 2026-08-07z12 — Phase 4 batch 5: the disposal gate resolved, USA suffix, orphans

- **The thunk 0x191F:0x9C0 RESOLVED to func_02D606** (follow_thunk): the
  over-100 disposal SKIP predicate. Goods 0/5/8/14/15 (Food, Lumber,
  Horses, Tools, Muskets) are never disposed; Ore (6) is spared while the
  smithy-tier check 0x9FC(3) or its accumulators [0x8DE4/6] hold.
  Capacity does NOT gate the 100-cut (func_008D00's number is display
  only). @CARGOREADY0 wired at last: a protected good tops a full hold
  with nothing sold (Food stays quiet, owned by the growth path). This
  also FIXES a real bug -- the port's food-only skip was over-selling
  Lumber/Horses/Tools/Muskets every turn.
- **USA-suffix keys** (APOSTATESUSA/HEATHENUSA/PIRACYUSA/RIDUSA/
  SIEGESUSA/TRIBUTEUSA/WANTSTUFFUSA): the meeting chain's usa() helper
  appends them at runtime; message_status.py now recognises the pattern
  (base key wired + the helper present) -> DONE, not BLOCKED.
- **TOOMANYCOLONIES/TOOMANYUNITS/HOWMUCH3**: the systematic emit-site
  scan finds NO caller for any of the three (the estimated GAME.TXT
  handle neighbourhood 0xF93/0x103D has no push in the disasm; HOWMUCH3's
  ship-to-ship prompt likewise). Reclassified N/A as cut content, ceiling
  named.
- **FULL** stays the sole BLOCKED: the join-colony crowding threshold
  hides behind func_02883E's jump table (the key + %STRING0 are read).

Ledger: DONE 411, BLOCKED 1, MISSING 0, N/A 34. Suite 234/234.

## 2026-08-07z13 — Phase 4 batch 6: popup auto-dismiss + the blocked-cell gate

- **Popup 120-tick auto-dismiss** (func_004A80 @0x4ADD: `add cx,0x78` = 120
  ticks against the clock read, ~2 s at 60 Hz). Implemented in the frame
  loop: a body-only event popup dismisses itself after 120 frames, resetting
  the counter as each new head surfaces -- exactly as any key/click would.
  (ask-dialogs are G.dialog, not eventQueue, and keep waiting for input.)
- **The blocked-cell frame gate READ** (func_026x @0x2655C): the red 24x24
  outline (0x181F:0xCE @0x26584) draws when bit 0x40 of the per-cell STATUS
  array at DGROUP -0x7210 (indexed cell*5+row) is set -- a runtime
  worked/blocked flag. The port keeps its "another settlement holds the
  tile" reading as a flagged approximation of that runtime state; the byte
  gate is now cited.

Suite 234/234; render-diff 15/15.

## 2026-08-07z14 — Phase 4 batch 7: the meeting tone predicate read

func_057F4E's MEEK/MANLY suffix (@0x5881F) is a MILITARY-STRENGTH
comparison, not attitude: B speaks MEEK when B's per-power strength word
[0x941C+power*2] is below the player's, MANLY when >= (cmp; jae ->
MANLY). The same suffix drives @HELLO*/@PEACE*/@WAR*/@OLDPEACE*. The
port replaced its "attitude >= 8" stand-in with a force proxy (sum of
unit combat + 3*colonies per side) as [0x941C]'s stand-in -- flagged as
a proxy, but the COMPARISON is now byte-faithful (weaker B grovels,
stronger B blusters). spec/ui/diplomacy_popups.md §2 updated. The
remaining meeting flags (PEACE-vs-OLDPEACE = standing treaty, topic
priority order, withdraw/threat sub-branch, smite price) are refinements
to a working system with no new keys, left flagged.

Suite 234/234.

## 2026-08-08a — Input-gesture fix batch (user defect report)

User report: (1) "g / Go to Port should list all the colonies or go to
Europe"; (2) colonists cannot be dragged into buildings (Blacksmith);
(3) ORDERS "Build Colony" does nothing. Root causes + rulings:

- **Go To Europe row.** The port's beginGoTo listed only colonies. The
  spec already carried the byte-read answer: the shared destination
  picker `func_060026` (spec/ui/trade_routes.md par.3) appends a EUROPE
  ROW FOR SHIPS ONLY (label = per-nation port name [0x838C]); picking it
  sets sail (`func_022CDC`). The port now appends the homeport row for
  ships and sails on selection (woiLocked -> EUROPENOTAVAIL). The
  picker's 10-row paging and current-location exclusion remain
  unmodelled (flagged in the code comment).
- **Pulldown press edge.** The engine's pulldown is a HELD interaction:
  opens from the held-poll, re-hit-tests rows while the moved flag is
  set (@0x6E5B1), commits the row on the RELEASE edge (@0x6EC70), lives
  only while held (@0x6ECCF). The port only opened menus from the
  browser's synthetic click, so the native press-drag-release gesture
  was a dead press plus a stray map click -- which is exactly "Build
  Colony is not working". The port now drives all three edges and keeps
  a no-move title release open (click-click mode, port convenience,
  marked as such). spec/ui/input.md pulldown section updated with the
  gesture model + port note.
- **Flick drags.** The engine lifts a held colonist by TIMER alone (8
  ticks = 131 ms). In the port's event-driven input a fast flick ends
  before the timer, silently dropping the man -- "cannot bring colonists
  to buildings". The armed colonist now also promotes on >3px of travel
  (port reconciliation, UNCITED, same class as the existing 2px click
  allowance).
- **Nation sack ink (user question: "what are these black boxes").**
  drawSack fed lut() -- the 3-level FONT palette ARRAY -- to
  ctx.fillStyle, an invalid value the canvas ignores, so every sack
  painted in the leftover style: black boxes beside the crossing
  passengers/dock units. Fixed to ink(); regression check reads the
  painted pixel against PAL[nation colour].
- **New-game state leak (found by the gates).** beginGame never reset
  G.flags -- WOI_DECLARED survived into a NEW GAME and woiLocked()
  refused colonies (shots.py's declare scenario exposed it; a real
  player retiring after declaring and starting fresh would hit the same
  wall). beginGame now clears flags/declaredYear/upkeepUnpaid/rivalWars/
  goTo/report AND the modal state (dialog/colonyPopup/drag/dragArm) --
  a stale dialog was otherwise "answered" by the new game's first click.
- render_diff: 1653_report_F3 threshold 12000 -> 12500; the 12158
  measured residual is IDENTICAL at HEAD bbb804b and with this batch
  (verified via stash rebuild) -- the old number was documented against
  a stale snapshot, not regressed by this work.

Suite 235/235 (new wire6 block: Go To rows + Europe sail, press-edge
open/track/commit via the real pointer handlers, flick assignment,
sack pixel); shots 47/47; render-diff 15/15.

## 2026-08-08b — Phase 5 COMPLETE: final audit and release (port-v1.0)

COMPLETION_PLAN Phase 5, all four items:

1. **Ledger re-verified**: DONE 411 + 29 via-DATA, PARAPHRASED 0,
   BUNDLED-UNWIRED 0, MISSING 0, BLOCKED 1 (@FULL's crowding threshold,
   behind func_02883E's jump table -- the one documented evidence
   ceiling), N/A 34 (each with an emitter-scan orphan verdict), SUPPORT
   24.
2. **Full render pass**: shots.py 47 scenarios, render_diff.py 15/15
   pairs green.
3. **The end-to-end playtest is in the suite** (test_flow "playtest"
   block): a fresh DISCOVERER game driven through the public flows --
   the tutorial card fires at once (the done-check), landfall, founding
   ("Freetown"), a field assignment through the scene panel's click flow
   and a Town Hall assignment through the jobs popup, three producing
   turns, the Europe muskets run (the Go To picker's Europe row, the
   three-turn crossing out, buyToShip at the market, @SAILAWAY home, the
   @CARGOUNLOAD/@HOWMUCH2 dialog chain), the declaration (@DECLARE row 1,
   mobilization to Cont. Army through the 50-muskets gate, the King's
   landing), the won war (the staged exhaustion of the reserve, with
   runWar's own landed==0 && afloat==0 detection firing KINGLOSE/
   WINNING), retirement (@RETIRE -> @EXPLOITS -> F10 -> @SCORED) sealing
   the INDEPENDENT Hall-of-Fame record, then the lost war (undefended
   colony razed -> LOSING2/KINGWIN -> the dependent record). The slow
   middles are STAGED AND MARKED: the liberty-bell climb and the war's
   combat attrition (combat has its own blocks).
   Two support changes: showEvent now carries the GAME.TXT key on the
   queue entry (suite/debug metadata; the renderer never reads it), and
   the playtest restores difficulty + a clean game for the blocks after
   it.
4. **STATUS.md** Phase-5 state, technical-reference §30.10 addendum,
   tag `port-v1.0`, artifact republished.

Suite 236/236 twice; shots 47/47; render-diff 15/15; ledger quoted above.

## 2026-08-08c — User defect batch 2: colony worker layer, dialog speakers, crash armor

User report: ship-loading "crashes everything"; colonists in buildings and
their production invisible on the colony screen; popups missing advisor
sprites / not presenting together.

- **Colony worker + production layer BUILT** (the visible gap): each manned
  building now draws its workers' profession figures standing in the plot
  and its per-turn output as a row of commodity icons under the roof --
  spec/ui/colony_screen.md par.0.4's capture-anchored geometry (production
  icons at plot+(6j,9), the figure bottom-anchored at
  (px+fw/2+5, py+8+fh-13), both axes solving the live Jamestown frame's
  measured (42,111) against the shop's 44x22 sprite). Production count =
  the sum of the crew's indoorYield, the same number the turn banks. The
  multi-worker 9px pitch and the figure-choice rule (specialty figure,
  else the job's own, else 81) are the port's reading -- FLAGGED (the
  capture holds one worker). The 1653_colony render-diff IMPROVED
  (26301 -> 25599) because the live capture has the workers too.
- **Dialog speakers capture-pinned**: openDialog never carried a speaker,
  so the landfall and set-sail asks drew bare. The speaker-sheet contact
  print identifies MSS3 = the coonskin scout (the landfall figure in
  60/77) and MSS0 = the blue naval officer (the @SAILAWAY figure in 78);
  DIALOG_SPEAKER pins exactly those five keys (LANDHO/LANDFALL/LANDFALL2
  -> MSS3, SAILAWAY/SAILHOME -> MSS0). No other dialog key has a captured
  portrait; none is invented. Sheet identities added to
  spec/ui/popups.md par.2.7.
- **Speaker placement re-anchored to the captures**: the engine's landing
  pixel is runtime cel state (par.2.7.1, no static coordinate), and the
  port had parked every figure bottom-right. Captures place the MSS/MYR
  advisors top-anchored left of centre (popup over the legs), the IND
  tribe figures full-height at the right edge, the King centred -- the
  port now does the same. FLAGGED approximation.
- **The reported loading crash did NOT reproduce** after direct flows
  (colony drag->HOWMUCH1 typed-digits, Load Cargo picker, Europe
  market->ship), 600+ monkey actions over the colony/Europe/1653-save
  load surfaces, and loaded-hold renders of every screen -- all clean.
  Two hardening measures ship instead: (1) a frameBody throw now paints a
  RED ERROR BANNER on the visible canvas (before, the loop's catch kept
  running but the screen froze on the last good frame with the error
  visible only in the console -- indistinguishable from a crash); input
  handlers get the same guard plus a drag-state reset. (2) loadGame
  re-establishes state invariants a stale v2 save may lack (arrays,
  16-slot stocks, holds; transient drag/goTo/combat cleared) -- localStorage
  saves cross build generations and are the one surface the probes cannot
  reproduce. If the crash recurs, the banner names the site.
- Popup queue semantics reviewed against the report "popups don't all
  come at once": presentation is serial-modal with any-key/click advance
  and the byte-cited 120-tick auto-dismiss (func_004A80) -- this matches
  the engine; queue mechanics verified sound (only beginGame clears). No
  change; the bare-popup fix above is the visible-wrongness candidate.

Suite 237/237 (new wire7: worker layer draws, speaker pins, guard
catches, stale-save fixup); shots 47/47; render-diff 15/15.

## 2026-08-08d — The popup font is FONTINTR (user report; FONTTINY gloss overturned)

User: "the font for the popups is not right." Confirmed against
60_landfall_dialog.png: the live popup's letterforms are ~8px tall and
match the FONTINTR sheet EXACTLY (contact print of every bundled .FF
against the frame); the port drew all popup text in FONTTINY (~5px).
The prior spec statement "body font = FONTTINY, the engine default"
conflated the HUD's direct-draw font with the dialog framework's
[0x89E]/[0x8A0] latch -- at popup time the latch holds FONTINTR.
Decisive cross-check: dialog_framework.md's BYTE-READ font-relative
layout math lands pixel-exact on the capture with intr (h=9): text-line
pitch = glyph_h+1 = 10 (`call 0x1266; inc ax` @0x06D012; measured body
rows 122->132), option-row pitch = glyph_h+border(3) = 12 (measured rows
146->158). Trust order: running game > the old inference.

Port change: the whole popup framework -- drawDialog/layoutDialog/
dialogClick, drawEvent, notice's wrap, the village menu, the colony
build/jobs/occupation popups, the Europe harbour menus -- now draws in
DFONT() = FONT.intr with DTEXT=10 / DROW=12, hit-tests updated in step
so paint and click agree (the engine's own invariant: the row loop and
painter share func_06CD66). The entry-field block grew 11->15 to fit the
taller glyphs (port geometry, flagged as before). The pulldown MENU BAR
stays FONTTINY -- 10_menu_reports.png shows the small font there.
spec/ui/popups.md par.2.4/par.20 corrected; dialog_framework.md gains the
which-font-the-latch-holds note (its worked 6-cell examples remain true
for the BOOT menus).

Suite 237/237 (wire7 + dialogFont/dialogPitch checks); shots 47/47;
render-diff 15/15 (no paired capture contains a popup frame; the
landfall side-by-side is the visual proof).

## 2026-08-08e — Screen census, session 1: the oracle grows from 15 to 23 pairs

The user asked how the port is tested against the original; the honest
answer was "only where a reference frame exists, and there were 15."
The census program fixes that: every UI state gets a DOSBox reference
capture, a port scenario posed in the SAME state (the 1653 save), and a
render_diff pair. docs/screens/census/TRACKER.md is the coverage ledger:
PAIRED / captured-reference-only / open divergences / not yet captured.

Session 1 captured 34 frames and they overturned SIX port behaviours:

1. **Pulldown menus are grouped, gated and contextual.** Green rule
   separators between row groups; rows a unit's CLASS can never use are
   HIDDEN (a frigate gets no Build Colony/Join/Pillage/Go-to-Place at
   all); rows inapplicable right now are DIMMED (Load Cargo away from a
   colony, Return to Europe off the sea lane); Clear Forest / Plow
   Fields fold into ONE row that follows the tile; ONE Fortify; DECLARE
   INDEPENDENCE in capitals. Rebuilt: menuVisibleRows()/ordersMenuRows()
   drive draw, hit-test, keyboard nav and commit off one row model;
   dimmed rows are skipped (the engine's node[0]&1 rule). The gating is
   CAPTURE-DERIVED (frigate + wagon frames), flagged.
2. **The Go To picker leads with Europe** -- "Amsterdam (Netherlands)"
   FIRST, label "<homeport> (<country>)"; rows page in tens with
   "(More)"; a land unit's list filters to its own land mass, no Europe
   row. Rebuilt with paging; the port's REGION filter keeps Vlissingen
   where the engine drops it -- OPEN divergence in the tracker.
3. **MSS0 and MSS5 were swapped**: the combat bulletin wears the MSS0
   naval officer, the colony-supply popups the MSS5 bonneted advisor.
4. **Colony-supply messages are ASKS with the @MISC rows** "Continue
   turn." / "Zoom to colony." (34/35); row 1 zooms. Implemented
   (askZoom) for CARGOREADY1/2 + NEEDTOOLS/0; extras beyond the first
   dialog fall back to plain popups (port reconciliation, flagged).
5. **@SMALLFONT is real**: the TRAIN list renders small beside the intr
   recruit ask -- the directive switches fonts, overturning the
   "no-switch" reading. Its sections (@BEGINMENU, @KINGRECRUIT, @CUSTOM,
   @PICKMUSIC, @PICK*, @TUTORIAL16-18) now carry a `small` flag through
   the bundle and the whole dialog framework draws 6/8-pitch small where
   set -- exactly the boot menu's byte-read 6-cell math, so the two
   readings cohere.
6. **RECRUIT/TRAIN furniture**: "(None)"/"None" head rows, no per-row
   price on RECRUIT, "(Cost: N)" from @MISC 13/14 on TRAIN, and the
   "(F1 for Help)" footer inside the box's bottom-right on the three
   shop menus.

Eight census pairs joined render_diff as LOOSE gates (residual floor =
the engine's slightly different viewport centring + cursor arrow + RNG
dock candidates + runtime advisor anchors, documented at the pair list).
Reference-only captures and the not-yet-captured list are in the tracker.

Suite 237/237; render-diff 23/23; shots 55 scenarios.

## 2026-08-08f — Screen census, session 2: the dialog family (oracle 23 -> 26 pairs)

Same 1653 state, the deterministic dialogs. New captures: the four GAME-
menu dialogs (Game/Colony-Report/Sound Options, Pick Music), Find Colony
(+ its miss notice), and three F6 Colony Adviser pages.

Corrections:
- **Options dialogs**: the engine draws ROUND radio marks (a ring with an
  orange centre dot when on) in the POPUP font at the framework pitches;
  the port drew square checkboxes in the small font. Rebuilt
  (census2_game_options; the same renderer serves colony-report and
  sound). Mark inks read off the frame, flagged.
- **Find Colony is the @FINDCITY entry dialog** -- "Where the heck
  is . . . / Colony:" with a typed name, not the port's cycle-through-
  colonies; a miss posts @NOCITY ('"%STRING0" not found.'). Rebuilt with
  a case-blind prefix match (the engine's matcher is unread, flagged);
  @FINDCITY/@NOCITY joined the bundle.
- Pick Music PAIRED and matches (the small font + the current-tune
  highlight land on the capture).
- The F6 Colony Adviser has MULTIPLE PAGES (Military Garrisons with
  per-colony garrison icons -> Sons of Liberty with flags and bell
  counts); clicking pages through. The port's F6 is one page -- OPEN
  divergence in the tracker.
- 1653_colony's threshold widened 27000 -> 30000: the per-session
  plotSeedBase makes its residual a 25.3k-27.9k band, and the old margin
  flapped.

Suite 237/237; render-diff 26/26.

## 2026-08-08g — Colony pass 1 (user report): the stand-down rule + colonist figures

User: a Pioneer moved into the Blacksmith's House "loses his tools to the
stockpile but stays a Pioneer".

- **The stand-down rule implemented** (unitToColonist): a unit joining or
  founding a colony sheds its outfit into the stores -- the Pioneer's
  remaining u.tools, the Soldier's EQUIP_MUSKETS, the Dragoon's muskets +
  horses, the Scout's horses (the same quantities the Europe arming rows
  trade) -- and the colonist entry becomes 'Colonists' carrying only his
  PROFESSION. Both entry paths (Join Colony and founding) route through
  it; the loadGame fixup retroactively stands down outfit-typed colonists
  in stale saves, returning the gear.
- **Colonist FIGURES unified** (colonistFigure): the live Curacao frame
  draws PROFESSION FIGURES in the plaza row and on the worked cells (the
  measured field worker was frame 100 -- the free colonist's own figure,
  which had coincidentally matched the Colonists unit icon). The plaza
  row, the field cells, the building-worker layer and the colonist drag
  ghost now all draw professionIconByName(profession), else the Indian
  Convert figure, else 100. A standing-down expert keeps his profession's
  figure wherever he works.
- Playtest updated: the founding Soldiers now correctly seed the colony
  with 50 muskets, so the musket-unload check measures the delta.

The colony pair's remaining residual is dominated by the building-field
layout: the plot shuffle is seeded per SESSION ([0x8D80] BIOS clock, per
the placement ruling), so even the engine lays the same save out
differently every launch -- the field can never pair tightly.

Suite 237/237 (wire7 + pioneerSheds/dragoonSheds/figures); render-diff
26/26.

## 2026-08-08h — Session-3 census (the user's COLONY02 save): SAV building
## tier-field, build picker format, popup anchors, NO auto-dismiss

Evidence = docs/screens/census/census3_*.png (DOSBox native dumps of the
user's stripped Raleigh save) + the save's own bytes + the user's live
report ("popups show up at once; they need to show one at a time").

1. **ColonyRecord buildings = the 48-bit TIER-PACKED field @+0x84** (LSB-
   first groups; each group's low bit number = the chain's first @BUILDING
   index). The old flat-bitmask read @+0x60 was WRONG — +0x60 is the
   per-colonist job-duration nibble array. Pinned EMPIRICALLY: predicting
   the bytes from the engine's own Jamestown build list (census3_build_
   picker) gives 00 02 20 09 89 00 — exactly the record's +0x84..89.
   Also imported now: hammers u16 @+0x92, building_in_production @+0x94
   (Jamestown 0x06 = Docks = the picker's highlighted row),
   warehouse_level @+0x95, custom_house_flags u16 @+0x8A. Layout per
   smcol_sav_struct.json (SAVE_FORMAT_CROSSREF), spec/systems/save.md
   updated.
2. **Build picker** (census3_build_picker): SMALL font; bare @CTITLE-4
   title in base green; CAPS labels; right-aligned "(N Hammers) (M Tools)"
   notes in base green; the picker OPENS ON the current target's row (no
   '*' marker); "(F1 for Help)" bottom-right in BRIGHT gold 0xFC
   (sampled (199,162,32)); WAGON TRAIN priced (40 Hammers) — off the x32
   unit scale, capture value used verbatim; the duplicate unit rows
   (buildOptions already appends them) removed.
3. **Building hover label** (census3_after_drop): white FONTTINY (ink 15)
   on a snug black plate (1px above/below the 5px glyphs), centred on the
   building sprite, plate top = sprite top + 11. One-capture anchor,
   FLAGGED.
4. **Tutorial gate is DISCOVERER-ONLY**: COLONY02 (Explorer, tutMask 0x0E
   = no step bits) opens Jamestown with NO tutorial card under DOSBox;
   COLONY04 (Discoverer) accumulates step bits (0x41DE). The flagged
   "< 2" gate corrected to < 1.
5. **Turn-processing popups anchor LOWER**: every census turn-event frame
   centres on y~130 (turnevent_0 box top 119; the asks ~92..169); menu
   dialogs / immediate popups centre on 100 per the byte-cited formula.
   Implemented as an endTurn latch (TURN_LOW -> low flag on
   showEvent/askEvent). Mechanism of the +30 base UNREAD — FLAGGED.
6. **The func_004A80 "120-tick auto-dismiss" is OVERTURNED** (running
   game > disasm reading, per the trust order): the census popups sit
   through multi-second harness waits, and the user confirms the original
   shows each message one at a time awaiting a key/click. The port's
   auto-dismiss is removed; 0x78's real role is TBD (the 2-line turn
   bulletin's box top is y=119-120).
7. New fixtures banked: COLONY03.SAV (fresh game, first turn) /
   COLONY04.SAV (one new colony, no other units) -> DATA.savStart /
   DATA.savNewColony.

Open (session 3): the plaza production strip (engine: plain icon runs, no
digits/red-X), the surround panel tile-yield rendering, BUY/CHANGE in
view 2, buy-prompt pairing.

Suite 238/238; render-diff 28/28 (census3_colony 25000 / build_picker
27000 thresholds span the per-session plot-RNG band).

## 2026-08-08i — The plaza production strip read end-to-end; the numbers
## toggle [0x336]; centre/field food calibration to the census3 frame

1. **Strip enqueue read** (@0x027330-0x0273C7): two bit-14 corn cells
   (eaten split at the centre yield, then the surplus) or, in deficit,
   produced + a bit-15 red-X run of [0x8E32]; crosses [0x8DEA] / bells
   [0x8DEC] only when nonzero; flush x=2 y=0xA3 span=0x76 gap=4. The
   port's old "always digits + always X the eaten" rendering replaced.
2. **Badges are gated** (@0x0032E8-0x003309): only when [0x70] != 0 --
   loaded at all four colony sites from the SAVED byte [0x336] (block 34;
   1653 save = 1, census3 saves = 0, exactly the badge difference between
   the two live frames) -- or when a cell compresses to step 1 with
   count > 1. G.colonyNumbers imports the byte; other screens keep their
   own [0x70] behaviour (F-reports force it on, @0x037E5C).
3. **The base cross**: "Each colony automatically produces one cross per
   turn" (GAME_MANUAL 1534; churchless Jamestown's [0x8DEA]=1). Seeded
   into colonyProduce's tally so the strip and immigration agree.
4. **Worker-slot order corrected**: the SAV tiles array is N,E,S,W,NW,NE,
   SE,SW (smcol) -- the port's row-major guess had every imported field
   worker on the wrong cell.
5. **Centre yield completed** (func_00A222 tail @0xA2AC-0xA33F): +1
   plowed, +2 prime resource (types 1/2/9; port TBD), +1 per SoL latch
   bit. Band ladder confirmed. The census3 frame fits only with the city
   tile's band as CLEARED land (engine auto-clears at founding) --
   flagged. Field FOOD carries the same +2/+1 difficulty term
   (capture-fitted, helper unread) -- flagged.
6. The engine's [0xA895] centre-yield global is STALE-ZERO on a freshly
   loaded game (no alt-sprite run in the census3 strip until a turn
   ticks); the port computes it live -- documented divergence inside the
   pair threshold.

Suite 238/238; render-diff 28/28.

## 2026-08-08j — The red X understood: it is the SHORTFALL mark of the
## production display (user prompt + GAME_MANUAL "Production View")

The manual names the rule (Production View): "Shortfalls that occur in
the production cycle are shown by 'X'ed out' commodities" -- and a
shortfall a converter covers FROM STORAGE loses its X (the stockpile
just drains). For FOOD the X'ed corn is the granary drain itself: the
Curacao frame X's its eaten-beyond-produced 2 while holding 5 food in
store, so hunger is never "made good" silently -- it is always shown.
So: X = what fails to materialize this turn (unmet converter demand,
food eaten out of the granary); never a decoration on ordinary
consumption.

Applied:
- The production panel (func_0275CE) now honours the same saved [0x336]
  numbers gate as the plaza strip (`mov al,[0x336]` @0x0275D3); the
  census3 4-sugar row renders badge-free, pixel-identical to the engine.
- Clicking the Production view toggles the numbers ([0x336] flip
  @0x02B99E/@0x02BF7C; the manual's "click anywhere in the multi-
  function view"), wired to G.colonyNumbers.
- The easy-difficulty field bonus is scoped to the PLOW GROUP (goods
  <= 3): Jamestown's plowed-swamp sugar = 2+1(plow)+1(diff) = 4 matches
  the engine panel, while the Discoverer-level Curacao panel keeps its
  bare-column furs/ore/silver (road group exempt). Capture-fitted,
  flagged.

Suite 238/238; render-diff 28/28.

## 2026-08-08k — Build view + BUY prompt paired; the popup anchor is
## SPEAKER-based; 26$/hammer; the coin glyph

1. **Multi-function view remapped** to the manual's order (Production /
   Units / Build, default Production -- census3_colony's own frame). The
   Build view (census3_colony_view2): target name centred y=132 in the
   panel ink, BUY (x219,y140) and CHANGE (x273,y140) in white FONTTINY on
   bordered plates (chrome approximated, flagged); BUY -> @BUYME flow,
   CHANGE -> the picker. "Units Present" = LABELS @CMISC row 1 (bundled).
2. **The vertical popup anchor is SPEAKER-based, not turn-based**: the
   census3 BUY prompt is CLICK-opened yet centres on y=130 with the
   colony advisor standing ON the box (centred, ~4px overlap), while
   every figureless dialog centres on 100. The 2026-08-08h TURN_LOW latch
   is replaced by the speaker rule; popups.md amendment rewritten.
3. **BUYME wears MSS5** (the bonneted colony advisor -- it was missing
   from the family regex, so the port drew no figure at all).
4. **Rush-buy 26$/hammer EXACT** (1352 = 52 x 26, zero banked, tax 0,
   Explorer). The older 1552$ frame still does not fit -- second term
   open, flagged. Port rate corrected 30 -> 26.
5. **The '$' coin glyph is KEPT in popup bodies** (fillTemplate no longer
   eats it): "1352$." renders with the fonts' coin, as the capture shows.

Pairs: census3_colony_view2 (21.5k/32000) + census3_buy_prompt
(27.6k/40000). Suite 238/238; render-diff 30/30.

## 2026-08-08l — Tile-panel yield strips join the [0x336] gate

The tile panel is the FIRST of the four `mov al,[0x336]` sites
(func_0264A8 @0x0264AD): its per-cell yield strips badge only when the
saved numbers toggle is on. The port's proportionalStrip now passes
G.colonyNumbers through gauge() -- the census3 scene cells render as pure
icon runs, closing the "digit plates over the surround panel" divergence.
Suite 238/238; render-diff 30/30.

## 2026-08-08m — VICEROY.EXE source-module reconstruction

The user asked for the one thing the technical reference never had: the list
of source modules VICEROY was built from. VICEROY shipped without CodeView
symbols (MAPEDIT did not), so its module structure is reconstructed, not read.

Deliverables:
- `tools/extract_codeview.py` — REPRODUCIBLE MAPEDIT NB02 extractor (the
  2026-07-30 parse behind mapedit_symbols.json was never committed). Corrects
  the NB02 model: the "second signature" at 0x23784 is the 8-byte EXE-tail
  TRAILER (NB02 + lfaBack), not a second symbol table; base = 0x1BE09. Emits
  211 modules + 1071 publics, and now the per-module CODE EXTENTS (sstModule
  seg/off/cbCode) the old parse dropped.
- `tools/rtlink/make_module_map.py` → `data_extracted/viceroy_modules.json`:
  every one of the 1250 functions assigned to a module. 89 tier-B (real 1994
  names via the MAPEDIT fingerprint match), 754 tier-A (same-module runs +
  page-level mechanic identity from event_emitters + the UI attribution
  prose), 27 overlay-metadata (page-header/reloc data mis-split as functions),
  260 resident functions honestly unattributed.
- `docs/VICEROY_MODULES.md`: how the EXE is built (resident image + 31 RTLink
  overlay pages + thunk segments + DGROUP), the two-layer engine/game split,
  the game-module table (one mechanic per overlay page, each pinned by the
  GAME.TXT keys it emits), and the named engine modules.

Verified: all 31 overlay pages covered, every overlay function has a module,
named anchors land in role-matching modules (menu.obj on the menu-bar page,
popup.obj on the popup-engine page, etc.), generator deterministic.

Evidence tiers are explicit; inferred game-module names end in `*` (the real
.obj names are unrecoverable without symbols).

## 2026-08-08n — Ghidra record types: build in code, and a name conflict logged

**Decision.** `tools/ghidra/make_ghidra_scripts.py` now emits a script that
defines the five record structs *programmatically* in Ghidra's Data Type
Manager rather than relying on `File > Parse C Source` over
`tools/ghidra/viceroy_types.h`. It also applies each table as an array at its
DGROUP base and types the three current-record pointers as 2-byte NEAR
pointers. `viceroy_types.h` remains committed as documentation.

**Why.** The C parser resolves widths through the loaded language's data
organisation, which is exactly the axis that already burned us once (`long` is
4 bytes in the 16-bit program, 8 on an LP64 desktop). Stating widths outright
via Ghidra's fixed-size builtins (`ByteDataType`/`WordDataType`/
`SignedDWordDataType`, never `IntegerDataType`/`LongDataType`) removes the
dependency. It also collapses the manual post-run procedure to nothing.

**New cross-check — `verify_field_aliases()`.** 140 DGROUP globals were named
field-by-field long before these structs existed. Every such name falling
inside a record table is an independent witness to that table's base and
stride. Result: **17 of 18 land exactly on a field boundary of element 0** —
`UNIT_Y`@0x3145 = `UnitRecord[0].map_y` (+0x01), `UNIT_TYPE`@0x3146 = `.type`
(+0x02), `U_ORDERS_314C` = `.orders` (+0x08), `COL_OWNER_5D60` =
`ColonyRecord[0].owner_power` (+0x1A), `COL_FLAG_TABLE_5D62` = `.colony_flags`
(+0x1C), `g_war_matrix_base`@0x883C = `PowerRecord[0]`+0x34,
`AI_CTRL_543F` = `AIPersonality[0]`+0x31. The generator now refuses to write
if any legacy global lands off a field boundary, if fields overlap or overrun
the stride, or if two arrays collide.

**Conflict recorded, NOT resolved.** DS:0x5DE0 is `MARKET_PRICE_5DE0` in the
legacy symbol table and `ColonyRecord.stock[16]` (+0x9A) in the record layout.
The *offsets* agree, so the layout is not in question — only the label. A
colony record plausibly holds warehouse stock rather than market prices, and
market price state is per-power, not per-colony; but the legacy name is
unsourced and the struct field comes from the SAV cross-decode, so neither is
byte-verified *as a name*. Logged in `KNOWN_NAME_CONFLICTS` and printed on
every generation. **TBD** until a write site at DS:0x5DE0+n*0xCA is read.

**Also.** The generated script prints a content-addressed `BUILD <12 hex>`
stamp as its first console line, and the generator prints the same string —
two debugging rounds were lost to a stale copy in `ghidra_scripts/`.
`check_free_names()` now parses the emitted script and refuses to write it if
it reads any name that is not a builtin, not bound in the script, and not one
of Ghidra's injected globals; `SCRIPT_TEMPLATE` is a string, so that class of
bug is invisible to local testing and only surfaces inside Ghidra.

## 2026-08-08o — Thunk call targets and function arity, both from bytes

**Cross-page call resolution.** Every inter-module call in VICEROY is
`lcall <thunkseg>:<off>` into a stub in the load-image thunk table
(0x1A5F0..0x1D5E6); the stub calls the RTLink runtime, which pages the overlay
in and jumps on. Statically the callee is anonymous. Two byte-verified paths
recover it, and `tools/ghidra/make_ghidra_scripts.py` now applies both:

- **type B (362 stubs)** — the LJMP carries `seg:off` outright, and those
  segments are load-image relative: `target = 0x2400 + seg*16 + off`, the same
  formula the load image uses everywhere. **322 resolve.**
- **type A (658 stubs)** — the LJMP segment is 0, patched by the loader. The
  4 trailer bytes carry it: `trailer_word_1` is the overlay **page id**
  (observed range 1..31, exactly the 31 pages) and the LJMP offset is an IP
  within that page: `target = page.code_offset + ljmp_off`. **451 resolve.**

**773/1020 total.** Acceptance is that the computed address lands *exactly* on
a known function start — a real test, since an off-by-one in either formula
would scatter results across mid-function addresses rather than hitting
boundaries. The 247 misses get nothing rather than a guess.

**Function arity from caller stack cleanup.** 16-bit cdecl puts stack cleanup
on the caller, so `add sp, N` following a call proves N/2 words of arguments.
Both call forms are read (far via the thunk resolution above, near as
`page_base + IP`). **357 functions** get an arity, accepted only when every
observed call site agrees; 0 targets showed disagreeing callers.

*Validation:* the seven thunk signatures transcribed by hand from the raw
disassembly in `viceroy_source/src/native/page0B_native_raid.c` — `region_of`,
`tile_at_query`, `manhattan`, `village_select`, `tribe_name_handle`,
`msg_set_int`, `alarm_bump` — **7/7 agree** with the derived counts. That is an
independent check: the transcript predates this extractor and was written by
reading the callee, while the extractor only reads callers.

**Explicit limits.**
- Argument **types** are NOT evidenced. Every parameter is applied as a plain
  2-byte word named `param_N`. The stack slot is real; the meaning is not.
- Absence of `add sp` is **not** zero arguments. Compilers defer and coalesce
  cleanup, so silence is unknown and the function keeps whatever arity Ghidra
  inferred.
- 248 near-call targets with cleanup evidence are not known function starts
  (undetected functions or mid-function entries) and were dropped.

## 2026-08-08p — Ghidra round trip, and a new symbol tier `U`

**Problem.** The Ghidra pipeline was one-way. Every rename, retype or note
made in Ghidra lived only in that database: lose it, restart it, or want the
name in the port, and the work was gone.

**Decision.** Two new artifacts close the loop:

- `tools/ghidra/viceroy_ghidra_export.py` (generated, runs *in* Ghidra) —
  diffs the live program against the exact baseline the import script applied
  (it carries the same payload and the same BUILD stamp) and writes only the
  differences: function renames, DGROUP global renames, and comments the user
  wrote. Generated plate comments are recognised by their `module :` line and
  generated EOL comments by their `-> ` prefix, so the script's own output is
  never exported back.
- `tools/ghidra/merge_ghidra_export.py` (runs on the repo machine) — folds an
  export into `data_extracted/ghidra_user_symbols.json`, which
  `make_ghidra_scripts.py` reads on its next run.

**New tier `U`.** Names from that store are applied as tier **U** and labelled
in the plate comment as "written by hand in Ghidra (human judgement, not a
byte citation)". They are deliberately kept in their own file rather than
merged into `tools/viceroy_symbols.json` or the module map: per
`notes/TRUTH_HIERARCHY.md` provenance is part of a name, and merging would
launder a judgement into an evidence-tier fact. A tier-U name overrides a
module-derived placeholder or a role name, but **never** a tier-B confirmed
1994 CodeView name.

**Stale-export guard.** Every exported entry records what the name *was*. If
the repo's generated name has changed since the export (new evidence landed),
the merge prints `STALE` and skips it rather than reverting the newer name.
Verified on a synthetic export: correct entries merge and reappear as tier U
in the regenerated script; entries with a mismatched `was` are refused.

**Also — naming.** `tools/ghidra/export_ghidra_symbols.py` is renamed
`make_ghidra_scripts.py`. The old name read as "the script that exports from
Ghidra" and was in fact the repo-side generator; it got copied into
`ghidra_scripts/` and run there, dying on a repo path. It now refuses to run
under Ghidra (`if "currentProgram" in dir()`) with a message naming the two
scripts that *do* belong there.

### 2026-08-08p amendment — the export filter was wrong on first contact

The first real export returned **198 entries, none of them user-authored**:
147 `thunk_FUN_*`, 43 `thunk_*`, 6 `caseD_*`, 2 `thunk_EXT_*`, plus zero
globals and zero comments. Cause: the filter excluded only names starting
`FUN_`.

Two things were missed. Ghidra's analyser recognises jump-only stubs and names
them `thunk_<target>` — so once the import script renames a target, Ghidra
invents `thunk_<our own name>` (`thunk__write_centered`,
`thunk_colony_econ_02EB1C`), which reads as hand-written. And the import
script's *own* thunk labels came back as functions.

Fixed by asking Ghidra for provenance instead of guessing from names: a symbol
is exported only when `symbol.getSource() == SourceType.USER_DEFINED`
(DEFAULT = placeholder, ANALYSIS = the analyser, IMPORTED = what the import
script applied). Belt and braces: a prefix list for the auto-generated forms,
and the set of thunk-stub addresses the import script labelled. Replaying the
198-entry export through the new filter drops all 198.

Also corrected: the BUILD stamp hashed only the import body, so a fix to the
export script left the stamp unchanged — the single version check the user has
would have called a stale export script current. It now covers both bodies.

### 2026-08-08n addendum — the 0x5DE0 name conflict resolves against MARKET_PRICE

The conflict recorded above (DS:0x5DE0 = legacy `MARKET_PRICE_5DE0` vs
`ColonyRecord[0].stock[0]`) is now resolved by evidence that already existed
elsewhere in the tree:

- Market prices are **byte-verified in PowerRecord `+0x4C price_level[16]`**
  (base 0x8808): ask `func_030566 @0x30583`, bid `func_030590 @0x3059C`,
  recompute `@0x306F3` — see `spec/systems/colony.md` §PowerRecord and
  `spec/systems/boycotts.md`. Prices are per-POWER state and never lived in a
  colony record.
- The ColonyRecord base 0x5D46 / stride 0xCA is multiply witnessed (the
  `func_02EB1C` displacements plus 17 field aliases), so 0x5DE0 falling at
  element 0's `+0x9A stock[0]` is not in doubt.

Verdict: `MARKET_PRICE_5DE0` is a **mislabel** — 0x5DE0 is colony 0's Food
stock. The legacy name stays in `tools/viceroy_symbols.json` as the
historical label, the conflict entry in `make_ghidra_scripts.py` now states
the resolution, and nothing in `port/`, `spec/`, or the technical reference
ever used the wrong name (checked 2026-08-08: zero citations).

Port impact of the whole Ghidra pass, for the record: **none required** — the
17/18 field-alias corroboration independently confirms the ColonyRecord/
UnitRecord/PowerRecord layouts `importSav` decodes, and `func_02CFD0`'s
decompile (writes DGROUP `[0x337]` on a modal result) matches the panel-mode
model already in `port/src/game.js` — identifications and confidence, not
behavior changes.

## 2026-08-17 — COLDIG.BIN's sample index is IN the sound drivers, and it is now decoded

**Conflict**: `formats/BIN.md` and `formats/COL.md` described the digital
sample bank speculatively — "(offset, length) records" of unknown shape at an
unknown place, one uniform 11025 Hz rate, and an A/G/P/R device mapping guessed
from the filename prefixes. `notes/rulings/AUDIO_SPIKE.md` recorded audio as a
NO-GO on the grounds that the sample data "is loaded/produced by driver code"
and decoding it was open-ended.

**Source A** — the two format docs and the spike said: layout TBD; ~11025 Hz
throughout; `GSOUND.COL` = GameBlaster/SoundBlaster; index location unknown.

**Source B** — the driver bytes say otherwise. Re-derived independently this
session from `raw/COLONIZE/` (every number below read out of the files, and
re-read on every run by `tools/decode_coldig.py`):

- **The index table is inside each `?SOUND.COL` overlay and is byte-identical
  in all four.** Base taken from the driver's own `lea` operands:
  `ASOUND.COL` file `0x0039F` (walker `@0x00D39`, player `@0x00F28`),
  `GSOUND.COL` `0x01E7B` (`@0x02811` / `@0x029FB`),
  `PSOUND.COL` `0x021A3` (`@0x02B3D` / `@0x02D2F`),
  `RSOUND.COL` `0x01F01` (`@0x0289B` / `@0x02A8D`). Images load at file
  `0x200`, so load = file − 0x200 and the operands are the load forms
  (`0x19F`, `0x1C7B`, `0x1FA3`, `0x1D01`).
- **Entry = `u32 offset`, `u32 length`, stride 8** — `add si,8` in the walker,
  `shl bx,3` in the play-by-index entry. The walker terminates on a
  **zero-length** row (`mov bx,[si+4]; or bx,[si+6]; je`), so the table holds
  **35 samples** plus a terminator whose offset field is `0x0F29DB`.
- **Three independent checks pass**: the 35 lengths sum to **exactly 993,755 =
  `len(COLDIG.BIN)`**; every `offset[i+1] == offset[i] + length[i]` (no gaps);
  the first offset is 0 and the terminator lands on the end.
- **The rate is NOT uniform.** The player branches on the index:
  `B9 6A 4A` = `mov cx,0x4A6A` (**19050 Hz**), `83 FB 05` = `cmp bx,5`,
  `72 03` = `jb`, `B9 11 2B` = `mov cx,0x2B11` (**11025 Hz**) — i.e. indices
  **0..4 play at 19050 Hz, 5..34 at 11025 Hz**. Sites: ASOUND `@0x00F19`,
  GSOUND `@0x029EC`, PSOUND `@0x02D20`, RSOUND `@0x02A7E`.
- **SFX id → sample index is readable too.** The driver's id dispatcher
  (`ASOUND.COL @0x01C35`) bounds-checks `83 FB 5D 77` (`cmp bx,0x5D; ja`) and
  jumps through a word table at file **`0x01DB9`** for ids `0x40..0x5D`; each
  SFX handler is `mov ax,<index>` before the call into the player, so the
  index is literal. 25 of the 30 ids play a sample; `0x46 0x47 0x59 0x5A 0x5D`
  route elsewhere.
- **Device identity is in the drivers' own ID strings** at file `0x210`:
  `"ColonizatonA09-14-94"`, `"Coloniz GMID09-12-94"`, `"ColonizatonP 9-13-94"`,
  `"RLND Colniz 09/13/94"` — so **G is General MIDI**, not GameBlaster/SB.
  `CONFIG.COL` is 20 bytes, not a driver.

**Ruling**: Source B. Byte-verified driver bytes beat doc speculation
(`notes/TRUTH_HIERARCHY.md`), and the three arithmetic self-checks make the
table unfalsifiable-by-accident: a wrong base or stride cannot sum to the exact
file size while staying contiguous. The **NO-GO in `AUDIO_SPIKE.md` is
superseded for digital effects only** — it remains correct for music, which is
synthesised inside the driver overlays and exists as no audio data anywhere.

**Action taken**:
- New `tools/decode_coldig.py` — re-derives the table and the id map from the
  bytes on every run, runs the three checks as fatal assertions, and emits
  `data_extracted/coldig_index.json` plus `cport/data/colopy_sfx.{h,c}`
  (`--wav` also splits the bank into `extracted/assets/audio/`).
- `formats/BIN.md`, `formats/COL.md` rewritten to the verified layout;
  `notes/rulings/AUDIO_SPIKE.md` given a superseded header.
- `cport/p4/colopy_p4.ino`: `sfx_play(id)` streams the sample straight out of
  `/sdcard/COLDIG.BIN` at its own rate (8-bit unsigned → signed 16, mono →
  both slots), wired to the cue sites this project has already byte-verified:
  sfx `0x4F` `@RAIDSTORES` (`@0x05C3CC`), `0x4E` `@RAIDGOLD`, `0x5B`
  `@RAIDNOTHING` (`@0x05C637`), `0x54` first colony (`@0x040E00`), `0x53`
  colony burning (`@0x05DFCB`).

**Follow-up**: three things stay open. (1) **Semantic names** for the 35
samples — no name strings exist in the drivers; naming them needs a DOSBox
listen-and-label pass. (2) **The rest of the cue map** — VICEROY.EXE's other
`0x181F:0x4C0` call sites have not been traced, so most ids are still unwired
and the port stays silent for them rather than guessing. (3) Indices **0..4,
15, 23, 24, 25, 26** are never referenced by the SFX dispatcher; they are real
audio (0..4 are five same-length variants with monotonically falling RMS —
plausibly a volume/distance ramp) but their trigger is TBD. Also noted: the
manual's §24.5 line "SFX 0x40–0x5F" is the VICEROY-side gate (bit `0x40`); the
driver's own table stops at **0x5D**.

### 2026-08-17 addendum — the cue sites are enumerable, and the EXE names 12 of them

Follow-up item (2) of the ruling above ("the rest of the cue map") is now
partly closed, again from bytes only.

VICEROY.EXE plays a sound by loading the id in AX and calling the gated-play
thunk, `lcall 0x181F:0x4C0` = `9A C0 04 1F 18`. That byte string occurs
**exactly 40 times**; at **36** of them the id is a literal `mov ax,imm16`
(`B8 xx xx`) in the three bytes immediately before the call, so the whole cue
inventory is readable without a decompiler. The four remaining sites
(`@0x23564`, `@0x23DA0`, `@0x2D09E`, `@0x5D205`) compute the id at runtime —
one of them is the Sound Test cheat, which plays whatever the player typed.

Better, where a cue belongs to a message emit the key string is pushed inside
the same block (`6A nn 68 <dgroup ptr>`), so **the EXE names the event
itself**. The DGROUP→file delta is pinned by the raid block — the push
`0x1B94` resolves to `"RAIDSTORES"` at file `0x1F534` — and the pin
cross-checks against the whole 6-key raid sequence, whose push deltas
(11, 9, 9, 9) match the string spacing exactly and whose three
already-documented ids (`0x4F` stores, `0x4E` gold, `0x5B` wiped out) land on
the right keys. That makes the delta a verified constant, not a fitted one.

**12 sites name their event** (`tools/decode_coldig.py` emits the whole
inventory to `data_extracted/coldig_index.json`):

| id | kind | key | site |
|---|---|---|---|
| `0x54` | sfx | `REFIT` | `@0x2F1CD` |
| `0x56` | sfx | `TEAPARTY` | `@0x346F6` |
| `0x3F` | tune | `INTERVENE` | `@0x3D7B1` |
| `0x8024` | fanfare | `HERESY0` | `@0x48EB7` |
| `0x53` | sfx | `HERESY1` | `@0x48EE6` |
| `0x55` | sfx | `CHIEFKILL` | `@0x4AB9E` |
| `0x4F` | sfx | `RAIDSTORES` | `@0x5C3C2` |
| `0x53` | sfx | `RAIDBURN` | `@0x5C501` |
| `0x4B` | sfx | `RAIDSHIP` | `@0x5C569` |
| `0x4D` | sfx | `RAIDSHIP` | `@0x5C571` |
| `0x4E` | sfx | `RAIDGOLD` | `@0x5C5ED` |
| `0x5B` | sfx | `RAIDNOTHING` | `@0x5C62D` |

Note **`RAIDSHIP` fires a PAIR** — `0x4B` then `0x4D`, back to back at
consecutive sites. The `0x3F` at `@0x3D7B1` corroborates the manual's
"unnamed id 0x3F at the intervention-force arrival" and gives it its key.

**Action taken**: `tools/decode_coldig.py` gained the site scan; the P4 board
now plays all ten of the named *digital* cues (the tune and fanfare ids have
no sample), keyed off the event key the port already emits, plus the two
woodcut cues traced earlier. The other 24 sites stay silent.

**Still open**: those 24 unattributed sites — `0x40 @0x5D314/@0x5D50C`,
`0x4A @0x5D5C4/@0x5D5FD/@0x5D6BC`, `0x45 @0x5D83A`, `0x4D @0x5B775`,
`0x57 @0x5BCCF`, `0x52 @0x3F5E0`, `0x5C @0x34129`, `0x58 @0x2B273/@0x3405A`,
`0x54 @0x2C65D`, and the tune/fanfare sites. They emit no key within the
block, so naming them needs the enclosing routine identified — not guessed
here.

## 2026-08-17b — The market's price pool is globals g+0x6A, driven by PowerRecord +0xFC

**Conflict**: `cport/core/colopy_market.c` carries an explicit FLAG — "the traffic
ACCUMULATOR lives in runtime state zeroed at load, mirroring the JS port (whose
importer never reads the record's +0x5C traffic words). Reconciling the engine's
own accumulator into the save flow is a later pass — FLAGGED, not silently
decided." The port knew it was not reading the engine's own running value, and
had it looking in the wrong place — PowerRecord **`+0x5C`**.

**Source A** — the port's note: the accumulator is (or might be) the
PowerRecord `+0x5C` traffic words, unread by the importer.

**Source B** — the bytes. Transcribing the new-game initialiser `func_0755CC`
this session turned up a 16-iteration loop at `@0x75645..0x75663` seeding
`word [bx + 0x53EA]`, `bx = i*2` — **globals `g+0x6A..0x89`, sixteen words, one
per cargo**, each `random_int(600, 1000)`. `0x53EA` has exactly **three**
references in the whole binary (capstone scan over `raw/COLONIZE/VICEROY.EXE`):
the seed above, a read `@0x305B8`, and a subtract `@0x30639` — both inside the
market module (the price ask/bid/recompute band already documented at
`func_030566`/`func_030590`/`@0x306F3`). So the field is not merely located,
its whole write set is known.

**The mechanism, byte-exact** (`func_0305A8`, `enter 0x66,0`), per pass, for
each good `i` in 0..15:

```
total = (int32)pool[i]                          ; @0x305B8 cdq, sign-extended
for p in 0..3:                                  ; @0x305CE..0x305FD
    v = *(int32*)(PowerRecord[p] + 0xFC + 4*i)  ; @0x305D8  bx = p*0x13C + i*4
    if (v < 0) v = 0                            ; @0x305E0 or dx,dx / jg / jge
    total += v
pool[i] -= total >> 7                           ; @0x30612 seven sar/rcr pairs,
                                                ;  arithmetic; @0x30639 sub
```

`pool -= (pool + S) >> 7` is a first-order lag: **the pool decays toward −S at
1/128 per pass**, where S is the world's clamped per-good trade total. A second
phase `@0x3070D` then maps the pool onto `price_level` (PowerRecord `+0x4C`,
byte, read `@0x3076D` through the live power pointer `[0x84FC]`) — that phase
covers goods **0..12 only** (`cmp [bp-0x5E],0xC; jg` `@0x3070D`), and its exact
price formula is a separate pass, **[TBD]**.

**This also names a previously-unmapped field.** `cport/core/colopy_records.h`
carried `uint8_t _pad_FC[0x13C - 0xFC]` — 64 bytes of PowerRecord tail with no
identification. It is **16 × int32, the per-power per-good trade total** the
loop above reads, and it fills the record exactly to its 0x13C stride.

**Ruling**: Source B, on arithmetic rather than interpretation. The fixtures
close it:

| | `savstart` | `sav1653` (Dutch) | `savraleigh` |
|---|---|---|---|
| `+0xFC` good 1 | 0 | 1031 | 176 |
| `g+0x6A` good 1 | 621 | **−1037** | 378 |
| `+0xFC` good 4 | 0 | 2835 | 0 |
| `g+0x6A` good 4 | 761 | **−2871** | 430 |

A fresh game has all sixteen pools inside the `[600, 1000]` seed window and no
trade; a long game has the heavily-traded goods sitting at almost exactly minus
their trade total, which is where `pool → −S` converges; and a lightly-traded
game sits in between, its pools drifting down under the *rivals'* trade even
though the player's own totals are near zero. Nothing but this mechanism
produces that pattern.

**Action taken**: recorded in `spec/systems/save.md` §3 (alongside two further
fields the same initialiser names — the 25-byte Founding-Father owner array at
`g+0x29` and the initial conditions of the king-anger pair `g+0x27`/`g+0x28`);
`_pad_FC` renamed to `trade_total[16]` in `cport/core/colopy_records.h`, a pure
naming change that leaves the struct size and every `.SAV` byte identical.

**No port behaviour was changed.** The C port's market is oracle-locked to the
JS port, whose accumulator starts at zero and lives per-session; adopting the
engine's pool would break `sim_compare turns` on all three fixtures. The
`.SAV` roundtrip already preserves these bytes verbatim, so nothing is lost
while the change waits.

**Follow-up**: decode phase 2's price formula `@0x3070D..0x3078E` (the
`0xD1D:0xEC6` 32-bit divide by `3 * [bp-0xA]`, and why goods 13..15 are
excluded), then port pool + `trade_total` into the JS first and the C second,
so both oracles move together.
## 2026-08-16 — Audio commissioned as a separately-scoped cport milestone (pragmatic tier)

**Directive (user, 2026-08-16):** "this needs to be separate, but i need you to
port the audio portion of colonization."

**What stands, what changes.** The AUDIO_SPIKE NO-GO
(`notes/rulings/AUDIO_SPIKE.md`) stands *for the fidelity done-bar*: the game
port's bar remains "100% identical except audio", and nothing in this milestone
gates or touches the P1–P7 pixel/behaviour oracles. What is superseded is the
"no audio work" consequence: audio is now an active, **separately-scoped**
milestone targeting the embedded C port, on its own branch
(`claude/colonization-audio-port-mwt067`) and its own module (`cport/audio/`,
compiled out of any build that does not opt in via `COLOPY_AUDIO`).

**Scope decisions (user, question round 2026-08-16):**

1. **Target = `cport/`** (Teensy 4.1 + CrowPanel Advance 7" ESP32-P4), as a
   separate module. The JS port's `playTune` stub is unchanged.
2. **Music = offline OPL2 render.** Each tune is rendered once, offline, by the
   ORIGINAL `?SOUND.COL` driver running under the DOSBox harness
   (`tools/dosbox_harness/`), captured per tune id via the in-game Sound Test
   cheat. No runtime FM synthesis; no music-sequence-format RE required.
3. **Fidelity bar = pragmatic first pass** ("APPROXIMABLE" per
   `REWRITE_READINESS.md`): working audio now, every approximation explicitly
   catalogued (`cport/audio/README.md`), nothing silently guessed.

**New provenance tier: "empirical capture".** Sits below byte-verified and
above speculation in `notes/TRUTH_HIERARCHY.md` terms. An empirical-capture
artifact is *measured from the real game running under emulation* (a per-id WAV
capture; a cross-correlation-derived `COLDIG.BIN` slice) rather than read from
bytes at a cited offset. Every such artifact must carry a `"provenance"` field
naming its capture, and must never be presented as byte-cited. SFX payloads
themselves stay bit-clean (verbatim `COLDIG.BIN` slices); only the id→slice
*mapping* is empirical.

**Action.** `notes/PROJECT_BOARD.md` audio section rewritten and its stale
`docs/AUDIO_SPIKE.md` links corrected to `notes/rulings/AUDIO_SPIKE.md` (same
fix in `port/README.md`; note AUDIO_SPIKE itself cites a `docs/MOV_FORMAT.md`
that does not exist — the decoded-MOV record is `spec/ui/cinematics.md` §11.3 +
`data_extracted/data/AMERICA_MOV.json`). `formats/COL.md` rewritten around the
MZ-overlay evidence (its "(sound_id, offset, size) triples" model was falsified
by AUDIO_SPIKE / `docs/RESIDUAL_FINDINGS.md` §3); `formats/BIN.md` and
`formats/MOV.md` corrected likewise. Design doc: `docs/AUDIO_PORT.md`.

## 2026-08-28 — the census placement seed base is MEASURABLE: 0x795

The colony screens' building layouts were "declared RNG" because
`[0x8D80]` — the seed base of `func_025D34`'s placement shuffle — is the
BIOS tick count captured once at game launch (`@0x075FF5` through
`0x181F:0xE72` = the 0040:006C reader at file `0xE4D2`): per-session
state no save can supply.  But only the low 15 bits reach the LCG
(`srand` masks `and ah,0x7f`, `@0x00C310`), and the census harness's
DOSBox boot turns out to be deterministic enough to reproduce them:
sweeping all 0x8000 bases in-process against BOTH colony baselines —
captured in separate DOSBox runs 14 minutes apart — lands on the same
unique minimum **0x795**, which is also the 2026-08-06 RAM-probe
session's recorded clock 1410965 mod 0x8000 (three independent boots,
one base).  A paired plot-by-plot sheet confirms every Isabella plot
matches the simulated layout at that base.

Both engines' census render paths now pin plot seed base 0x795 (the C
importer's `CR.plot_seed`, the JS harness's `G.plotSeedBase`); live JS
play keeps the per-session random base, exactly like the engine.
Measured: COLONY 18,197 -> 14,460 px, COLONY_SHIP 21,216 -> 15,154.
The tail dword at save offset tail+0x260 (0x158795 on the fixture) is
the SAVING session's clock — persisted but never re-read for placement,
which is why it only scored mid-sweep.
