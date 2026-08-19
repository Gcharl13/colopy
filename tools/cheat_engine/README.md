# Cheat Engine bridge — live VICEROY state inside DOSBox

**Yes: everything this project has byte-verified about the game's RAM can be
watched (and edited) live in DOSBox.** This directory turns the repo's
DGROUP/record documentation into a Cheat Engine table + Lua bridge that
auto-locates the running game inside any DOSBox process and exposes ~1,400
labelled addresses — game state, all four PowerRecords, colonies, units, native
settlements, AI personalities, the market model, the REF, the map planes, and
the NAMES-loaded stat tables.

A live running game is the **top of `notes/TRUTH_HIERARCHY.md`**, so this is
not just a cheat tool: it is the project's interactive verification instrument.
(It already paid for itself — see §Verification log and the MemBase pitfall it
uncovered.)

| File | What |
|---|---|
| `VICEROY_DOSBOX.CT` | Cheat Engine 7.x table (generated — do not hand-edit) |
| `viceroy_dosbox.lua` | The same Lua bridge standalone (for CE's Lua console, or as a reference port) |
| `addresses.json` | The byte-cited inventory every entry is generated from (offset → gloss → repo citation → tier) |
| `make_ct.py` | Generator; re-verifies the DGROUP anchor bytes against the reconstituted EXE before emitting |

## Quick start

1. Run the game in DOSBox (any recent 0.74/ECE/Staging/X build; the game files
   from `col.zip` / `bin/reconstitute.py`).
2. Open Cheat Engine, load `VICEROY_DOSBOX.CT`, answer **Yes** to "execute the
   table Lua script".
3. The script auto-attaches to the first `dosbox*` process and locates the
   game. If you started CE first, attach manually (File → Open Process), then
   activate the **"LOCATE VICEROY"** entry (or run `VICEROY.locate()` in the
   Lua console).
4. Expand the groups. Everything is addressed off registered symbols, so
   values survive DOSBox restarts — just re-activate LOCATE after a restart.

Console one-liners (Memory View → Tools → Lua Engine):

```lua
VICEROY.status()      -- year/turn/difficulty/counts/REF one-screen summary
VICEROY.powers()      -- tax, rebel%, gold, bells, crosses, boycotts, prices x4
VICEROY.colonies()    -- every occupied colony slot + stockpiles
VICEROY.units(30)     -- unit records: type, pos, owner, order, goto, AI state
VICEROY.settlements() -- native settlements: tribe, pop, missions, capital flag
VICEROY.unitStats()   -- the NAMES-loaded @UNIT stat table (editable!)
VICEROY.tile(x, y)    -- decode terrain under record/HUD coords
VICEROY.setGold(99999)     -- cheat: treasury
VICEROY.revealMap(0)       -- cheat: reveal map for power 0 (England)
```

## Registered symbols

| Symbol | Meaning |
|---|---|
| `DG` | DGROUP linear base — every `DGROUP:0xNNNN` citation in the specs is live at `DG+NNNN` |
| `MB` | Emulated physical address 0 (MemBase) |
| `CURPOWER` | Active PowerRecord (`DG + [DG+84FC]`) |
| `CURCOLONY` | Active ColonyRecord (`DG + [DG+8542]` — CLAUDE.md hard rule 8) |
| `CURTRIBE` | Active TribeData record (`DG + [DG+8D4E]`) |
| `MAPTERRAIN`, `MAPLAYER1`, `MAPLAYER2`, `MAPFOG` | Linear bases of the four map byte-planes (far ptrs at `DG+15C/160/164/168`) |

The near pointers refresh on a 400 ms timer, so `CURCOLONY+9A` keeps tracking
whichever colony screen you have open.

## How it works

DOSBox keeps the emulated PC's RAM as one big host allocation; emulated
physical address `P` lives at `MemBase + P`. Two problems must be solved to
map the repo's knowledge onto that:

1. **Finding DGROUP** (the game's data segment, where all `DGROUP:0xNNNN`
   citations live). The static section-name table `UNIT\0ORDERS\0ACTIONS\0`
   sits at `DGROUP:0x2258`; it is unique in VICEROY.EXE (byte-checked at
   generation time against file offset `0x1FBF8` = DGROUP file base `0x1D9A0`
   + `0x2258`) and unique in live RAM (`docs/RUNTIME_SNAPSHOT.md`). One AOB
   scan → `DG = hit − 0x2258`. The NAMES-loaded `@ORDERS` accelerator letters
   `-STGLFFBPR---` at `DG+0x54DE` serve as a second, confidence-only anchor
   (they exist only after the loaders have run). This is a 1:1 port of
   `tools/runtime_snapshot.py::find_dgroup()`.

2. **Finding MemBase** — needed to follow far pointers (`seg:off` →
   `MB + seg*16 + off`), i.e. the map planes. **Pitfall (live-diagnosed
   2026-08-19): the host allocation base is *not* reliably phys 0.** DOSBox
   0.74-3 (Linux) places phys 0 at allocation+0x10; trusting the region base
   shifts every plane read by 16 bytes (which masquerades as a bizarre
   toroidal (16,1) map displacement — an hour of confusion, fully resolved).
   The bridge instead walks DGROUP-segment candidates high→low (so candidates
   ascend from below) and accepts the first address with a valid **BIOS Data
   Area + IVT signature**: `u16[MB+0x413] == 640` (base memory KB) and
   populated INT 08h/21h vectors. In the live session this signature matched
   **exactly one** address in the entire space.

Everything else is the repo's own documentation, mechanically applied:
records at fixed DGROUP bases (`spec/data/records.md`), the active-record near
pointers, and the tile reader math `plane[y*w + x]` (`func_005D9C`).

## What is exposed (and where it came from)

| Group | Source docs |
|---|---|
| Game state (year/season/turn, difficulty, current power, unit/colony counts, SoL meter, flags, RNG) | `spec/systems/turn_dispatch.md`, `notes/rulings/RULINGS.md`, `docs/DATA_MODEL.md` |
| King & REF (4 REF counts, royal_money, tax) | `spec/systems/king.md`, `ref_growth.md`, `revolution.md` |
| PowerRecord ×4 + CURPOWER (tax, rebel%, FF mask, bells, crosses, boycotts, gold, home xy, diplomacy matrices, price_level[16], market arrays) | `docs/DATA_MODEL.md`, `spec/systems/colony.md` §PowerRecord, `market.md`, `diplomacy.md`, `founding_fathers.md`, `immigration.md` |
| ColonyRecord ×8 + CURCOLONY (name/pos/owner/size, jobs, buildings bitmasks, tile workers, hammers, build target/progress, warehouse, 16-good stockpile, SoL pair) | `docs/DATA_MODEL.md`, `spec/systems/colony.md`, `spec/data/records.md` |
| UnitRecord ×12 (pos, type, owner, orders, goto, heading, cargo, tools, work, profession, links, AI state char) | `spec/systems/unit.md` §2 (base 0x3144 per RULINGS 2026-05-28) |
| NativeSettlement ×12 (pos, tribe, pop, flags, missions, alarm pairs) | `docs/DATA_MODEL.md`, `spec/systems/natives.md` |
| AIPersonality ×4 + TribeData | RULINGS 2026-05-29 (controller at +0x31), `docs/DATA_MODEL.md` |
| Map & viewport (dims, selected tile, viewport, the four plane pointers) | `docs/DATA_MODEL.md`, `spec/systems/exploration.md` §4, live session |
| Economy & stat tables (price seeds, recruit dock slots, @UNIT stat table — editable) | `spec/systems/market.md`, `immigration.md`, `unit.md` §3 |
| Cheats group (gold, tax, bells, SoL meter, boycott, REF disband) | write-shortcuts onto the entries above |

Full per-entry glosses, citations, and confidence tiers: `addresses.json`.
Tier meanings: **B** byte-verified at a cited EXE site, **A** oracle/runtime
confirmed, **CONFLICT** = knowingly disputed (kept visible, labelled — e.g.
PowerRecord `+0x44..46` REF bytes per RULINGS 2026-06-19).

## Verification log (2026-08-19, in-container)

The address math was not taken on faith. The exact algorithm embedded in the
Lua was executed against a **live driven game** (headless DOSBox 0.74-3 +
Xvfb/xdotool per `tools/drive_game.sh`; New World, England, Discoverer), with
RAM snapshots taken via `tools/runtime_snapshot.py`'s region reader:

* DGROUP found at the documented anchor; secondary anchor OK once in-game.
* `[0x84FC] = 0x8808` (England = active PowerRecord); **gold=1000, tax=0
  matched the HUD pixel-for-pixel**; `[0x8542] = 0x5D46` (first colony).
* `year=1495→1496` across an end-turn, `turn=4`, `difficulty=0` (Discoverer,
  as selected), `current_power=0`.
* **REF start counts 15/5/2/2 = the byte-cited `8d+15 / 5d+5 / 3d+2 / 6d+2`
  at d=0** (`spec/systems/revolution.md`).
* Price seeds `[0x53EA]`: 16 values all inside the byte-cited
  `random_int(600,1000)`; PowerRecord `price_level[0..3] = 1,4,5,2` inside the
  `@CARGO` start ranges.
* AIPersonality: `Walter Raleigh/New England` controller=0 (human) + three
  AI=1 — exactly the RULINGS 2026-05-29 field map.
* UnitRecord[0] = the HUD's Caravel: type 0x0D at (46,42), order 0 (No
  Orders), moves init, AI state `'X'`, player timer sentinel `0xFF`, goto =
  own tile, chain links sane. **Moving the ship west updated `+0x00` 46→45
  and `[0x8540]` (selected-tile X) in lockstep.**
* ColonyRecord[0] = "New Amsterdam" (50,25) owner 3 (Netherlands) size 1 on a
  land tile; NativeSettlement[0] Inca pop 11 on land.
* Map planes: right-edge column = {Arctic, **Sea Lane 26**} on a *generated*
  map (hard rule 2 live); 79/81 units terrain-consistent (the 2 exceptions =
  the two passengers aboard the Caravel); fog plane gained `0x10` (England's
  `1<<(power+4)` bit) on exactly the newly revealed tiles after the move;
  plane `[0x160]` counted units per tile (ship=1, garrison=2, braves=2).

Two live observations are **new evidence** the repo did not have (recorded in
`notes/rulings/RULINGS.md` 2026-08-19): the MemBase/allocation-header pitfall
above, and plane `[0x160]` behaving as a unit-presence count (its disasm label
`g_layer_elev_ptr` looks stale; plane `[0x164]`'s role — broad per-power
bit-4..7 masks — remains open).

## Limits / honest TBDs

* Runtime-only values stay runtime values: entries show live state, not specs.
  Fields the repo marks TBD/CONFLICT are labelled that way here too — nothing
  was invented to fill a row (CLAUDE.md prime directive).
* Plane `[0x164]`'s semantic and the PowerRecord `+0x44..46` bytes are open
  disputes; the table shows them, labelled.
* Colony "working buffers" (per-tile yield caches etc.) are computed on demand
  by the game (`docs/DATA_MODEL.md`) — there is nothing stable to pin.
* The CT ships 8 colony / 12 unit / 12 settlement slots to stay navigable; the
  Lua dumpers cover all slots.
* Tribal PowerRecords (indices 4..11) exist at `DG+8808+i*13C` but only the
  four European records are pre-built in the tree.

## Regenerating

```
python3 bin/reconstitute.py          # once, for the anchor byte-check
python3 tools/cheat_engine/make_ct.py
```

The generator refuses to emit if the anchor bytes at `0x1FBF8` diverge from
`addresses.json`, and validates the emitted XML. `viceroy_dosbox.lua` is
parse-checked with `lua5.4` in CI-less fashion: `lua5.4 -e
'assert(loadfile("tools/cheat_engine/viceroy_dosbox.lua"))'`.

## No Windows? Same addresses, headless

Cheat Engine is the interactive front-end; the *addresses* are front-end
agnostic. On Linux/CI, `tools/runtime_snapshot.py` reads the same DOSBox RAM
(mind the MemBase footnote), and `addresses.json` is machine-readable for any
other tooling (e.g. a scanmem/GameConqueror import, or a Python watcher).
