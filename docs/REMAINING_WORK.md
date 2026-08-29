# REMAINING_WORK — everything still open to finish the handheld build

> **What this is.** One honest ledger of every open item between here and a
> finished game on the CrowPanel Advance 7" ESP32-P4. Compiled 2026-08-17 by
> auditing the whole tree, not by copying the older ledgers — several of which
> disagree with each other and with the code (see *Ledgers this supersedes*).
>
> **Scope (user directive, 2026-08-17): the playable build + fidelity debt.**
> IN: everything that makes the handheld a complete, correct game, plus every
> `FLAGGED` approximation in either engine. OUT: the CLAUDE.md UI documentation
> mandate, the MAPEDIT rewrite, the `viceroy_source` reconstruction — Part H
> records those explicitly so nothing looks forgotten.
>
> **How to read a row.** Every row says what is open, cites a `file:line` or a
> byte site, and flags what it is blocked on. Per the CLAUDE.md prime directive
> nothing here is an invented estimate: where a number is unknown it says so.

## The headline

The recent cadence has been user-reported bug fixes, which makes the build feel
close. It is closer than the first draft of this ledger said, and still not done.

**Correction, 2026-08-17.** This section originally announced that "none of these
work today: colonists starving, food-shortage warnings, population growth from
surplus food, natives burning a colony, the Docks prerequisite for fishing,
boycott relief…", on the authority of `docs/POPUP_AUDIT_2026-08-08.md`'s 14 HIGH
and 74 MEDIUM open rows. That was wrong. The audit is a point-in-time snapshot,
sweeps landed after it, and its rows were never updated.
`tools/popup_census.py` — written to settle it — checks each audited row against
both engines as they stand:

> **196 key mentions across the 149 still-open audit rows: 186 wired in both
> engines, 2 in one engine only, 8 absent from both.**
> *(177/6/13 when this ledger was written; the four context menus below closed
> the gap, and the tool learned to see two reference forms it had been blind
> to — see G2b.)*

Every item in that sentence except the two orders menus emits in both engines
today. What is genuinely missing is listed in B.1, and it is four context menus,
a handful of sub-keys, and the engine gaps in B.3 — of which **rival AI colony
development** (no growth, no construction, no unit production) is far the
largest.

The deeper point stands, though: a key emitting is not the mechanic being right.
`docs/MESSAGE_STATUS.md`'s **0 missing / 0 unwired** reads as "text-complete" and
is not evidence about behaviour, and neither is the census. Both only bound the
problem from one side. The audit's per-row verdicts on *trigger* and
*substitution* for those 177 wired keys are simply **unverified** — that is Part C
work, and it is why Part C is the biggest part of this document.

**Totals.** `tools/churn_metric.py` counts **581 open TBDs** repo-wide (docs +
code). Engine-side, the two ports carry **138 flagged sites + 23 TBD + 60
"unread"** in `port/src/game.js` and **73 flagged + 13 TBD** across
`cport/core|game|render`. This ledger organises those into ~350 actionable rows;
the remainder are documentation TBDs belonging to Part H's out-of-scope tracks.

---

## Part A — Blocking or broken right now

**Status 2026-08-17: A2–A6 closed. A1 is not a code fault** — it is the Arduino Tools ▸ PSRAM setting, and it reverts every time the sketch folder is unzipped fresh, so it stays listed. Nothing in this part blocks play any more; what remains blocking is Part B.

| # | Item | Cite | Blocked on |
|---|---|---|---|
| A1 | **Black screen on boot** is a Tools setting, not a code fault. The MIPI DPI driver fails to allocate its 1024x600x2 (~1.2 MB) frame buffer *before* the sketch allocates anything: `esp_lcd_new_panel_dpi(239): no memory for frame buffer` -> `board=nullptr` -> the `if (sd_ready && fbuf && g_lcd)` gate skips `boot_title()`. Fix: **Tools > PSRAM: Enabled** (+ Flash 16MB, a Huge-APP partition, USB CDC On Boot). Arduino stores board settings per sketch-folder path, so a fresh unzip reverts them to defaults. | `cport/p4/colopy_p4.ino` `setup()` ~1752-1792 | You (IDE) |
| A2 | ~~**`PAKBUF_CAP` is a hard 3,500,000 bytes with no error path**: a pak that outgrew it loaded **silently truncated**, because `fread(cap)` returns a prefix and `rd_init()` accepts a prefix whose header still parses.~~ **RESOLVED 2026-08-17** — `sd_read_file()` now sizes the file first and refuses one that will not fit, printing both numbers; the cap is 8,000,000 against a 3,148,409-byte pack, which Part E's 146 unshipped assets will eat into. | `cport/p4/colopy_p4.ino` `sd_read_file()`, `PAKBUF_CAP` | closed |
| A3 | ~~**No P4 memory-budget document.**~~ **RESOLVED 2026-08-17** — `cport/MEMORY_BUDGET.md` rewritten to cover both boards: the board-independent static census re-measured after the audio merge (BSS 219,304 B; `CR` has grown 11,892 -> 39,364 since Phase 3), the P4's PSRAM/flash/SD split, the PSRAM-Enabled requirement, and why nothing may be added to internal SRAM. Free-space figures are deliberately **not** filled in from a datasheet — the sketch's new `m` command reads them off the hardware. | `cport/MEMORY_BUDGET.md` | a live `m` run (D) |
| A4 | ~~The **`w` serial command** is not in the sketch banner or either README.~~ **RESOLVED 2026-08-17** — the banner now prints one line per command instead of a bare list, `cport/p4/README.md` carries the full table, and `m` (memory census) was added alongside. | `.ino` default case, `cport/p4/README.md` | closed |
| A5 | ~~Stale comment: `colopy_map_render.c:8` claimed zoom 1/2 unported.~~ **RESOLVED 2026-08-17** — `rm_draw_map_zoom` exists and `set_zoom` clamps 0..3 on z/x; the comment was true of the original ILI9341 target and stale since the P4 work. Comment corrected. | `cport/render/colopy_map_render.c:8` | closed |
| A7 | ~~**The sketch does not compile with `COLOPY_BLE_MOUSE=1`.**~~ **RESOLVED 2026-08-19** — reported from a real IDE build (esp32 core 3.3.11): `variable or field 'bt_notify_cb' declared void`. The IDE hoists a generated prototype for every function definition in the .ino to above the file's own `#include`s, so a prototype naming `BLERemoteCharacteristic` landed where `<BLEDevice.h>` had not been seen. The old guard was a one-space indent, on the belief that only column-0 definitions are picked up — false on this toolchain. The callback is now a **captureless lambda at its registration site**: a lambda has no name to hoist, so no heuristic about the generator can make it wrong again. The mock gate that passed the broken sketch is G2e. | `cport/p4/colopy_p4.ino` `bt_connect()` | closed |
| A6 | ~~**Stale doc:** `cport/p4/README.md` still says typed digits need serial and lists the on-screen keyboard as an open follow-up.~~ **RESOLVED 2026-08-17** — both corrected; the numeric keypad and alpha keyboard shipped 2026-08 and the README now says so. | `cport/p4/README.md` | closed |

---

## Part B — Missing features: the game is incomplete without these

### B.1 The HIGH popup rows — **re-censused 2026-08-17, and much smaller than it looked**

The first version of this section copied `docs/POPUP_AUDIT_2026-08-08.md`'s open
rows verbatim. That audit is a point-in-time snapshot; sweeps landed after it and
its rows were never updated, so this part read as a to-do list that badly overstated
what is missing. `tools/popup_census.py` now checks each audited row against the two
engines as they stand:

> **196 key mentions across the 149 still-open audit rows: 186 wired in both
> engines, 2 in one engine only, 8 absent from both.**
> *(177/6/13 when this ledger was written; the four context menus below closed
> the gap, and the tool learned to see two reference forms it had been blind
> to — see G2b.)*

Emission is not correctness — a WIRED key still has to be judged on its
substitutions and trigger — but a row the audit calls MISSING whose key both
engines emit is a row to **re-audit before implementing anything**. Run
`python3 tools/popup_census.py --absent` for the current list; it is the honest
starting point, not the table below.

**The four context menus — DONE 2026-08-17.** All four now read their rows
from GAME.TXT and are wired in both engines:

| Key | State |
|---|---|
| `@ARMOPTIONS` | The 12-row Europe dock-unit menu. The mechanic was never missing — every action was wired — but both engines retyped the row text, differently, losing the `{brace}` highlight markup and the section's `%NUMBER` price slots. Now read from the section. **FLAGGED:** the section gives each good ONE number for both its buy and sell row; the buy price goes in, so a sell row displays the ask while paying the bid less tax. |
| `@EUROPESHIPOPTIONS` | Same story, four rows, 1:1 swap. `@EUROPESHIPCLICK` (its caption) now wired both sides. |
| `@UNITOPTIONS` | **New.** The colony garrison-unit menu: a click on a figure past the byte-verified 4px break opens it. Rows write the byte-verified `@ORDERS` values 0/1/5; "Move to front" reorders the unit cycle. Oracle-exercised (9 openings, orders 5→1→5). **FLAGGED:** "Sentry / Board ship" is one row; it sets Sentry and leaves boarding to the drag — whether the engine's row boards when a ship is in port is unread. No caption section exists, so the port titles it with the unit. |
| `@SHIPOPTIONS` | **New.** The colony-harbour ship menu, on a second click of a ship box in the (already byte-cited) dock. Rows 0–3 mirror `@UNITOPTIONS` over a ship; "Unload all cargo" empties the whole hold behind the same `@WAREHOUSEFULL` gate the per-slot `u` path uses. **NOT oracle-exercised** — no fixture parks a ship in a colony at that point in the script; the clicks are in place and will cover it when one does. See G2a. |

**What is still absent from both engines:**

| Key | What is missing |
|---|---|
| `@KINGRECRUIT` | C-only; the JS never emits it |
| `@TOONEARBUILD`, `@RECRUIT2`, `@CLASS`, `@FRIEND` | sub-keys of rows whose main mechanic is wired |
| `@MISSION0` / `@MISSION3` | wired keys, but the 0..3 band selection runs on invented cutoffs, so the outer two are never chosen |

Everything else the old table listed here — `@FOODLOW`, `@FOOD1`, `@STARVE1`,
`@WAREHOUSEFULL`, `@NEEDTOOLS`, `@NEWCOLONIST`, `@REBELUP50`, `@TRAINPROFESSION`,
`@NODOCKS`, `@INDIANBURNCOLONY`, `@KISSUP`/`@SOMEBOYCOTT` — **emits in both engines
today**. Spot-checked while censusing: `@TRAINPROFESSION`'s slots are NOT transposed
(both engines pass `STRING0` = colony, `STRING1` = profession, matching the
template); `@NODOCKS` gates both water-tile assignment paths; `@NEEDTOOLS`/
`@NEEDTOOLS0` fire with the byte-derived `tools_x10 * 10` requirement. The
`@NEWCOLONIST` row is corrected below. The remaining audit verdicts on these keys
(trigger cadence, exact substitutions) are **unverified either way** and belong in
Part C, not here.


**Two more that the census cannot see**, because their key is wired but the
mechanic behind it is not:

| Key | What is missing |
|---|---|
| `@NEWCOLONIST` | **CLOSED 2026-08-28** — the 200-food threshold is byte-verified: `func_0098B4` returns the constant `0xC8` (`@0x98BD`), fetched via thunk `0x181F:0xCB8` and compared/deducted `@0x2E11D/@0x2E123`; growth spawns a type-0 (Colonists) **unit at the fence** (`@0x2E136`), it does not add a member — both engines now do the same. (The "25/50 mis-attributed to horses" claim stayed withdrawn — that pair belongs to horse breeding, RULINGS 2026-08-17.) |
| REF growth cadence | `func_03E162`: accrual timing opposite the bytes; tax->REF-fund loop unwired; ratio ladder approximated. `@KINGBUY`/`@KINGMOBILIZE` both emit, so the census reads this row as wired. |

### B.2 The 74 MEDIUM popup rows, by family

Full row detail in `docs/POPUP_AUDIT_2026-08-08.md`; grouped here so nothing is lost.

**Same caveat as B.1, and it bites harder here:** the census finds all but a handful of these keys emitting in both engines today. The families below are the audit's 2026-08-08 reading, kept for its per-row detail — treat every entry as *needs re-auditing*, not *needs building*. `python3 tools/popup_census.py --sev MEDIUM --absent` lists the ones that really are not there: `@EUROPESHIPOPTIONS`, `@ARMOPTIONS`, and the `@CLASS`/`@FRIEND` sub-keys.

- **Colony per-turn (23, all MISSING):** `@FOOD2 @STARVE2 @VANISH @SPOIL1 @SPOIL2 @CARGOREADY0 @LUMBER @COTTON @TOBACCO @CANESUGAR @FURS @ORE @TOOLS @NEEDTOOLS0 @SONSUP @SONSDOWN @REBELUP @REBELDOWN @TRAINCRIMINAL @TRAININDENTURED @NOTEACHER @NEEDCOLLEGE @NEEDUNIVERSITY`
- **Colony partial (9):** `@BUILT` (status string not popup), `@REBELMAJORITY` (empty %/nation slots), `@REBELUNANIMOUS` (missing sub + education-speed effect), `@TORYMINORITY` `@TORYMAJORITY` (incomplete substitutions), `@TORYUPRISING` (cadence/target/spawn diverge), `@TRAINFAIL`, `@UPKEEP` (trigger unread), COLONYOPTIONS report gating (settings persisted, zero consumers)
- **Natives (16):** `@INDIANLAND` (bundled but unreachable), `@PISS0..5` (whole family absent), `@BURIAL1-3`, `@INDIANWARPATH` `@INDIANWARPATH2` `@INDIANWAR` `@INDIANGRUDGE` `@INDIANSURPRISE` `@INDIANGIVEFOOD` `@INDIANBEGFOOD` `@INDIANGIVESTUFF` `@WHACKINDIANS`
- **Combat / diplomacy (10):** `@CARGOCAPTURE` `@SHIPDAMAGE` `@SHIPSUNK` `@HALF` `@LOOT` `@FORTFIRE` `@DECLAREWAR` `@GIVECASH` `@HAVETREATY/@CANCELPEACE/@SNEAK` `@SCOUTCOLONY`
- **Map-side (8):** `@EUROPESHIPOPTIONS/@EUROPESHIPCLICK` `@OVERBOARD` (picker replaced by silent dump-everything) `@TOONEAR` `@NOPORT` `@TUTNOLUMBER` `@TUTNOSPACES` `@SEACOLONY` `@TOOMOUNTAIN`
- **Europe (7):** ship-arrival passenger handling, `@SOMEBOYCOTT`, `@ARMOPTIONS` (11 of 12 rows + the sentry/don't-board mechanic), `@RECRUIT` chooser, `@RECRUITCHOOSE` (no choose-your-immigrant, no Brewster), `@REALLYBUY`, arrival banner + woodcut 9
- **King / tax / war (14):** `@KINGTAX` (core demand body is dead data), `@MERCANTILISM` `@PURCHASETAX` `@MOBILIZE` `@CANTMOBILIZE` `@KINGMOBILIZE` `@KINGBUY` `@WARN2` `@INTERVENTION` `@INTERVENE` `@KINGLOSE` `@KINGWIN` `@REFIT` (repair loop unimplemented, damage permanent), peacetime mercenary offer `func_03E664`

### B.3 Engine gaps the popup audit does not cover

| # | Item | Cite |
|---|---|---|
| B3.1 | ~~The colony ships-in-port dock panel is never drawn.~~ **IMPLEMENTED, then CORRECTED against a live DOS frame 2026-08-28.** `drawColonyDock` (both engines) draws the full `func_027DB2` panel: headline centred in the rect x=121 w=84 at y=132 (`@0x27DCE`/`@0x27E95`), the carrier strip at x=130+18k through the shared `func_00386A` composite (`@0x28049`, mode 0x64, centre-width 0x10; the y−1/−2 only for ship types 0x0D..0x12 `@0x2801A`), the green selection cell (`@0x27F15`), overflow pips (flagged approximation), and hold cells (slot ≥ capacity → the 0x7B cross; occupied → engine 0x17/0x27+good centred x+5−w/2 at the cell y `@0x28063`; empty → nothing). The new `COLONY_SHIP` census baseline (Vlissingen, the docked Galleon) then corrected the MEMBERSHIP: the strip holds every unit with **cargo capacity > 0** — the DOS frame docks the WAGON TRAIN beside the Galleon — so carriers moved out of the plaza row into the dock in both engines. | `port/src/game.js` `drawColonyDock`/`colonyShips`/`plazaRow`, `cport/render/colopy_colony_render.c` | closed |
| B3.2 | ~~F5 Economic's second page (@MISC 91/92) is not drawn; the view switch is TBD.~~ **CLOSED 2026-08-29 — there is no second page.** A full sweep finds **no consumer** of `@MISC 91` "(Building Upkeep)" / `92` "TOTAL UPKEEP" in VICEROY.EXE: the @MISC pointer table is `[0x2DBA + n·2]` (calibrated on the F5 header slots `[0x2E2E]`=58 Tons .. `[0x2F52]`=204 Ask Price), slots `[0x2E70]/[0x2E72]` are read nowhere, no `push 0x5B/0x5C` exists in the image, and no register-passed constant reaches the by-index printer `func_00C09A`. The two strings are orphans of the cut building-upkeep feature (the `@BUILDING` upkeep column); F5's drawer `func_038A50` draws exactly the one European-Trade view the port already has. (The earlier "second page" guess also mis-slotted `[0x2E10]/[0x2E12]` — those are @MISC 43 "Requires"/44 "(CLEAR SPECIALTY)", the colony production panel's tools line.) | `spec/ui/advisor_reports.md` F5 | closed |
| B3.3 | ~~F9's multi-page paginator `func_039E98` is not wired.~~ **The premise was wrong twice, and the fix landed 2026-08-28.** `func_039E98` is byte-disproved as a pager: it is the SCORE screen's population-icon FLOW PLACER — `[0x2D0E] += 8`, wrap at x ≥ 0x124 to `y += 8` with the staggered restart `((x & 8) >> 1) + 0x10`, stop at y ≥ 0x90, one icon per call through `0x181F:0x254` — called twice from `score_component_sum_and_report` (@0x03A107 for colonists, @0x03A1CA for units). And F9 needs no pager at all: its row loop's own bound is `cmp [bp-0x64], 8` — ALL EIGHT tribes draw in one pass at pitch 21. The real bug was the port's `F9_PER_PAGE = 7`, which silently dropped an 8th listed tribe; both engines now use the byte-cited 8. (The fixture lists 7 tribes, so the census cannot see the fix; a save with 8 contacted-or-extinct tribes would.) | `port/src/game.js` `F9_PER_PAGE`, `cport/render/colopy_report_render.c` | closed |
| B3.4 | ~~Trade routes have no per-stop good-list editor.~~ **CLOSED 2026-08-29**: both engines carry the record's per-stop LOAD/UNLOAD lanes (six goods each — the nibble-packed `+0x03..+0x05`/`+0x06..+0x08` lanes, `trade_routes.md` §2) and honour them in the automation (unload the listed goods, load up to 100 each per `func_00B880 @0xB8A5`); the TRADE menu's **Edit Trade Route** row now opens the editor (route → stop → @CARGOLOAD lane → @CARGOUNLOAD lane, `func_060C34`/`func_060D8C`'s pair). A route with no lanes anywhere keeps the port's old first-stop-loads default (documented convenience; the engine with empty lanes does nothing at a stop). | both engines' trade screens | closed |
| B3.5 | ~~Roads as a terrain band (§6.8) are not implemented — the .MP loader discards the feature plane.~~ **CLOSED 2026-08-29 — the premise dissolved on the evidence already in the tree**: VICEROY's own loader **discards .MP layer 2** (live-verified, RULINGS batch 7 / `formats/MP_FORMAT.md` §loader), so no road ever arrives from a map file — roads exist only in the improvement plane (SAV + pioneers), which the port carries. And the §6.8 band itself IS implemented: `drawImprovements` draws the road hub plus the eight adjacency connectors (`PHYS.ROAD+1+d` toward road/colony neighbours) — the same sprites the compositor band would emit — and the map render oracle scores 0 structural against the live road-bearing baselines. | `port/src/game.js` drawImprovements | closed |
| B3.6 | **Rival AI colony development** — RE-SCOPED 2026-08-19, and it is not what the row said. It said `func_04CC50`/`func_04E2D6` "are not ported"; those are the AI's **unit** planner and per-unit pipeline (`spec/systems/ai.md`), and neither has anything to do with colony growth. **There is no rival-colony AI in the original at all.** `func_02F052` @`0x59EA` is a *per-power* colony pass: it loops every colony once per power and processes the ones that power owns (`ColonyRecord +0x1A == power` @`0x2F256`), so a rival's colonies run the **same production code** the human's do. That is the whole mechanism. **The blocker is the data model, not the logic.** The C already imports every colony into `CS.colonies` with its owner byte — COLONY01 carries 8 human + 6 rival colonies fully populated (Jamestown pop 11, 11 jobs, 7 field workers, a live build target) and `cr_reset_from_load` builds runtime state for all of them — but the JS reference port keeps only the human's in `G.colonies` and models rivals as a separate stub (`{x,y,level,pop,spared}`). Turning the loop on in the C alone breaks the reference relationship the whole oracle suite rests on. Unifying the models means auditing ~374 owner-correctness sites (127 `G.colonies` + 247 `CS.colonies`). **Prerequisite DONE:** the per-power scaffolding (`turn_power`/`cur_power`/`cev`/`cask`) is in `colopy_turn.c`, oracle-verified behaviour-neutral, and it fixed a latent cross-power bug on the way — `father_owned` read the human's Congress unconditionally, so every rival colony would have inherited the human's Founding Fathers (Jan de Witt's +20 SoL first). | `cport/core/colopy_turn.c` `turn_step_prefix`, `port/src/game.js:11080` | re-scoped |
| B3.7 | ~~An empty colony taken by a rival is burned rather than captured; the selector unread.~~ **SELECTOR BYTE-READ + WIRED 2026-08-29** (func_05CA7E @0x5D574..@0x5D5D0): a EUROPEAN winner ALWAYS captures (the @CAPTURED family @0x5DED1); only a TRIBE burns, and only a **size-1** colony (@0x5D59A → removal @0x5D651, tribe musket/horse loot @0x5D627/@0x5D63D, @BURNED1/2/3 by involvement) — a bigger colony loses ONE colonist to a tribal win (0x181f:0xa9c @0x5D5A2). Both engines now capture unconditionally (the razing fallback only at the port's own colony-array capacity 48, an artifact flagged as such). Residue: the captured colony still degrades to the rival-colony stub (full record management is B3.6); a European razing a size-1 native settlement sets the tribe grudge bit +0x03\|=0x40 (@0x5D69D) — unmodeled. | both engines' rival attack paths | selector closed |
| B3.8 | ~~An unimplemented report prints "Not in this build."~~ **CLOSED 2026-08-29 — the row is stale**: every adviser report F2..F10 is populated in the `REPORTS` table (F1 routes to the pedia), so the "Not in this build." branch in `drawReport` is an unreachable defensive guard, kept as such. | `port/src/game.js` drawReport | closed |
| B3.9 | ~~Reports F8/F9 unreachable by pointer in DOS — decide whether to keep the board's tappable divergence.~~ **DECIDED 2026-08-29: keep it.** The board has no function keys, so without the touch route the two reports would be dead content on the device; their CONTENT is byte-faithful, and the divergence is interface adaptation of the same class as the touch bindings themselves. Recorded here as the deliberate ruling; the `.ino` comment already flags it. | `.ino` reports touch map | closed |
| B3.10 | **Boot cinematic chain** (King audience -> ten LEVN tutorial cards -> `@VICEROY` scroll) needs pak assets not yet carried; the C boot starts at page-1 dismissal. | `cport/game/colopy_input.c:256` |
| B3.11 | ~~The colony BUILD view's BUY button diverges, one bug on each side.~~ **MISDIAGNOSED — corrected 2026-08-17, same day.** Both engines DO run `rushBuy` and DO ask `@BUYME1`; only the ANSWER differs. The harnesses answer every scripted ask with `seq++ % 2` on one **global** counter, and the counters have drifted: the C never reaches the European meeting flow (B4.6), so during the oracle's 30-Space block the JS asks `@PEACEMEEK` and the C does not — JS 16 asks, C 15 — and from there every later ask gets the opposite answer. `@BUYME1` lands on 16 (even -> "Never mind") in the JS and 15 (odd -> "Complete it") in the C. Not a BUY bug at all. Folded into B4.6 and G2c. | `tools/input_compare.py` `colony_clicks`, `cport/core/colopy_turn.c` `ask_choice` | closed |

### B.4 C-engine-only gaps (the board runs the C engine)

| # | Item | Cite |
|---|---|---|
| B4.1 | ~~Map zoom 1/2 unported.~~ **NOT A GAP** — see A5; the claim came from a stale comment. | — |
| B4.2 | **Tutorial bindings (`tutOnce`) not ported** — TUTORIAL* keys filtered from the event comparison. | `cport/core/colopy_turn.c:11-13` |
| B4.3 | ~~Village trade haggle unported.~~ **CLOSED 2026-08-29** — the C now carries the full byte-model haggle (`trade_sell_pick..trade_buy_round`, mirroring the JS draw-for-draw); the harness still remaps the trade rows to Cancel on both sides, so the path runs only in live play. The `RAIDSTORES` banking is the tribe-arming byte model (no CR home needed — the counters live in `CR.tribe_*` and the record). | `cport/core/colopy_village.c` | closed |
| B4.4 | ~~**Unit build pipeline**: the completion path handles buildings only; the importer nulls `bip >= 42`.~~ **STALE — struck 2026-08-19.** Unit builds shipped (task #99): the picker encodes a unit target as `0xC0+u`, `advance_construction` resolves it through `BUILD_UNIT_NAMES`, and the `.CPX` sidecar persists it across a save. Wagon Trains, Artillery and ships complete. The row and its source comment both outlived the fix and were still being read as current — this is the row that put a false gap into a status overview. Pinned by `tools/stale_check.py` (`FIXED-2026-08-19b`). | `cport/core/colopy_turn.c` `advance_construction` | closed |
| B4.5 | ~~Several move targets are **explicit no-ops**: ships at sea, rival tiles, villages, sea lane, rumour entry.~~ **STALE — struck 2026-08-19.** All of them are implemented: attacks resolve for natives and the REF with the §14.3 `@HALF` fatigue ask, the rival LAND arms are complete (war ladder, treaty ask, Wagon Train trade, Scout dialog, parley), `village_enter()` runs at `colopy_cmd.c:885`, `enter_rumour()` at `:890`, the sea lane at `:895`. Three comments in `colopy_cmd.c` still described the slice-2 subset long after slices 3–5 landed, and this row inherited them — it is the third stale row found in one sweep, and the third to have been repeated in a status overview. Pinned by `tools/stale_check.py` (`FIXED-2026-08-19c`). | `cport/core/colopy_cmd.c` `cmd_move` | closed |
| B4.6 | ~~`askEvent` is stubbed in the C trace, so **every meeting topic ends at its first ask** — treaties, tribute, war declarations and withdrawals never execute.~~ **MOSTLY STALE — corrected 2026-08-19.** `ask_choice()` returns an answer and the code after it runs: in live play the board installs `colopy_ask_hook` (`board_ask`, `colopy_p4.ino:1932`) and the PLAYER answers; in the parity trace a scripted per-prompt counter answers (G2c). `meeting_topic` acts on the result at 13 sites — `accept_treaty()` writes the treaty matrix and clears `REL_WAR`, `declare_war_on()` sets `REL_WAR`, the `@PIRACY` row sails every player Privateer home, tribute and tension apply. **European diplomacy works on the board.** The narrow residual that survives: the war matrix starts **empty on import** (the JS importer does not populate it — TBD against `PowerRecord +0x34`), so a loaded save begins with no wars in progress and `rivalTurn`'s WAR branch only becomes reachable once war is declared in play. This row's old wording put "European diplomacy = STUB" into a status overview; pinned now by `tools/stale_check.py` (`FIXED-2026-08-19a`). | `cport/core/colopy_rivals.c` `meeting_topic` | narrowed |
| B4.7 | Only the **drag layer** is absent from the C input port (by design; every function is reachable another way). | `cport/game/colopy_input.c:2222` |

---

## Part C — Fidelity debt: works, but the rule is a reading

Every one of these produces a plausible game today; each is a place where the
port chose a rule the EXE has not been read for. Grouped by subsystem, each
naming the byte site that would retire it. This is the "provably faithful" half
of the scope.

### C.1 The ones that visibly change play

| # | Item | Cite |
|---|---|---|
| C1.1 | ~~Combat §14.3 step 8 — a doubling with an unknown condition.~~ **CLOSED 2026-08-29**: the "further doubling" is the **native-settlement branch** of the tile-defence filler func_007D3E (@0x7D8B: a settlement on the tile takes its own EXCLUSIVE branch — base 2, owning tribe tech ≥ 2 → 4 @0x7DB5, and the **CAPITAL flag** (settlement +0x03 & 4) doubles it @0x7DCA — not a difficulty gate). Both engines carry the branch in defenceBonus/combat_params. Noted for the spec: the filler's branches are EXCLUSIVE (settlement > feature > terrain, each `jmp @0x7EFE`), so the earlier "colony +2 @0x7D8D / fortified +4 @0x7DBC" glosses were this settlement branch misattributed — the European colony/fortify bonuses are separately cited and stand. | both engines' combat chain, `spec/systems/combat.md` §7.1 | closed |
| C1.2 | ~~func_005DF0 rumour gate not reproduced; the plane's identity disputed.~~ **CLOSED 2026-08-29**: func_005DF0 = the plane-3 HIGH-nibble **TERRITORY OWNER** query (0xF → −1; both callers use it as an owner — @0x2288A vs the active player, @0x47242 range < 4), multiplexed with the func_005F82 FEATURE marker (improve bit 2 + nibble ≥ 4) — the old "feature nibble vs continent owner" dispute was both-half-right (low nibble region, high nibble owner). The rumour hash func_006188 suppresses at @0x61BC on ANY claimed nibble; both engines now carry the gate (the JS RESOURCE[] plane imported verbatim, the C region hi-nibble; fresh maps unclaimed 0xF). Residue: the territory-claim WRITER (colony founding?) is unread — fresh-game claims never form, flagged; the low-nibble writer func_005DCC is the region setter, not the rumour consumer (the port's rumoursDone set stays the consumption model). | both engines' rumourAt | closed |
| C1.3 | ~~Go To moves one square per turn whatever the allowance.~~ **CLOSED 2026-08-29**: both engines now step the pathfinder route repeatedly per turn, spending the unit's movement budget per step (moveCost's road/river/terrain model; the first step always allowed, the step() rule) — a Caravel reaches its lane at ship speed. | both engines' advanceGoTo | closed |
| C1.4 | ~~Rush-buy: 26$/hammer fits census3 but not the older frame; a second term open.~~ **CLOSED 2026-08-29 by the byte read (@0x2B779..@0x2B8C2)**: price = **13 × remaining hammers + (tools price level + 4) × missing tools, DOUBLED when no hammers are banked** (@0x2B7E9) — census3's untouched Docks quoted 13×2 = 26$/hammer, the older started build did not, which is the whole mystery. gold ≥ price → @BUYME1 (row 2 confirms), else @BUYME0; accepting tops the hammer bank (overage into the +0x98 tally), adds the MISSING tools to stock (@0x2B8BA) and debits the gold. Both engines run it. | both engines' rushBuy | closed |
| C1.5 | ~~Settlement placement not in the evidence.~~ **CLOSED 2026-08-29 by the func_065D26 read.** TRIBE.TXT mode (@0x660C4..@0x66246): each file site scatters by a **triangular ±2 jitter** (random_int(−1,1)+random_int(−1,1) per axis), up to 100 tries against passable / improve&3 clear / terrain < 0x18 with (id&7) ∉ {Desert 1, Swamp 7} / nearest-settlement distance > 3 → 2 → 1 as tries mount; the **first placed site is the capital** (flags |= 4 @0x66222 — byte-confirmed, the old flag is gone). The FALLBACK mode (no TRIBE.TXT, @0x65F50..) is fully random with a 90−tries/4 min-distance schedule, a west bias for the first two tribes and 18×15 five-tile sector exclusivity — documented, not needed by the port (TRIBE.TXT ships). Tribe init also read: tension = random_int(0,13) + 2×diff for human powers (@0x65D8C — the port's floor(rand×15) is one off, kept as its own seeded contract), tech from the 4th TRIBE.TXT field. Both engines place with the byte model. | both engines' newgame village seeding | closed |
| C1.6 | ~~Which skill a village teaches is derived from site coordinates, not any mapped store.~~ **CLOSED 2026-08-29 — it IS coordinate-derived, but through the real machinery**: the Live Among handler `func_04A426` seeds the runtime LCG with `srand(((y<<8)+x+dword[0x8D80]) & 0x7FFF)` (the colony-layout construct) and draws a weighted pick over the 16-word teach table at `[0x9E78]`, filled by `func_048F34` (the demand builder's sibling half) from a 5×5 terrain scan minus colony-worked cells, tribe tech/pop/settlement count and the tribe `+0x0C` word; pick 4 → Seasoned Scout when `(x+y)%3==0`, pick 0 → Fisherman by a water count over the 20-ring (`DS:0xC8/0xDE`). Both engines carry the byte model (`villageSkill` / `village_skill`); loads pin the JS seed base to the C's 0x795. Residual flags: tribe `+0x0C`'s writer ("hoard"), `[0x962A]` = villages-per-tribe gloss, both ports track only the 8-ring of worked cells (the EXE masks all 20). Bonus byte reads: @LEARN keys are composed `"LEARN"+suffix` in-EXE; @LEARNMAD fires at attitude band > 1 (tension ≥ 50) **and costs 3 tension**; the failure roll only runs at band > 0; the taught latch (settlement `+0x03` bit 1) never blocks a **capital**. | both engines' `villageSkill` | closed |
| C1.7 | ~~Village rows gated on an undecodable "tribe posture byte +0x5236".~~ **CLOSED 2026-08-29**: the byte is the **visitor's @UNIT ATTACK column** — func_04B308's gates read `[unit_type × 14 + 0x5236]` (the imul-14 chain @0x4B820..@0x4B838; +0x5236 = @UNIT col 2 per unit.md §3), misattributed to a tribe record. Both engines now gate: Incite/Demand Tribute need attack ≠ 0 and not a ship; Live Among needs attack < 2; the Attack row needs attack > 1. context_dialogs.md §6's "tribe-record" glosses corrected. | both engines' villageActions, `spec/ui/context_dialogs.md` §6 | closed |
| C1.8 | ~~func_049600's tail not disassembled; the loop numbers are stand-ins.~~ **CLOSED 2026-08-29 by the full tail read (0x0496BA..0x04A37A)** — both engines now run the byte model: sell offer = max(1, (max(0, 2·(base−diff−att+mood+4)·want) + 5·mood)·qty/100 / 2) with the corrected per-good colour (Trade Goods −rand(0..7) @0x499C3, Tools +1 @0x49A05 — the old Furs/TradeGoods guesses were misassigned) and att = 2·attitude-band (func_008262: 25/50/75), halved at want≥20, zero for muskets/horses; haggle budget = rand(0,1) + (want−att+4)>>2 @0x49AB4; the player's "fairer price" = the ceiling (want+1)·4+offer (stretching +10 when reached); a haggle folds the village while random_int(1,8·budget) > difficulty — one budget point and +random_int(want/2+1, 2·want+1)·qty/100 per fold — else it walks (settlement +0x07 remembers the good → @BADHAGGLE1, tension +att/2+1, session over). Buy side: ask = the @0x4A025 chain (−4·DEMAND, not stock), floor max(10, ask/2), step max(1, ask/4), fold roll random_int(0, demand/25+8) > diff+1, insult latch +0x07=0xFE → @BADHAGGLE2/3. Sale/gift credits −2·budget / −4·(budget+1); a gift also bumps the horse counter. Goods land in the TRIBE's +0x0E stock words (imported both sides), and settlement +0x07/+0x08/+0x09 are the persisted haggle memories. Residue: func_048F34 (the demand/want builder) stays the port's terrain-scan reconstruction; the AI buy-pick value table [0x84BC] and the engine's unit-index @0x49BFD last-bought bug are documented, not modeled. | `spec/systems/natives.md` §19.5, `port/src/game.js` tradeSell*/tradeBuy*, `cport/core/colopy_village.c` | closed |
| C1.9 | ~~Native demand triggers and amounts untraced.~~ **CONTENT CLOSED 2026-08-29** by the native-meeting demand handler read (0x5755C..0x57A15): **@INDIANCITY** demands the ARGMAX of value×min(100,stock) over the colony's stores (value = the [0x84BC] bid table = max(0, level−1); horses −tribe-counter+10; muskets +random_int(1,4)−tech+diff+4), halved on random_int(0,diff+1)==0; a GIVE zeroes the village alarm, credits tension by −score×4/100 grown −5 at a time until the meter lands ≤ 70, and ARMS the tribe (the engine upgrades the demanding brave — muskets: unarmed→Armed Braves, horses: +2 type → Mounted, @0x577A5..@0x577F7); a REFUSAL spikes the village alarm +128 (@0x57A0B). **@INDIANWAGONS** presses the wagon's slots one at a time (give: slot emptied, −bid×qty×4/100, alarm zeroed, loop; refuse: +128 and done). Nothing worth demanding → **@INDIANCOMMENT** + alarm cleared. **@INDIANGOLD is DEAD GAME.TXT content** (zero EXE hits, like @KINGMERCY) — removed. Both engines carry the model. Residue: the TRIGGER cadence (the engine's brave-adjacency native meeting) stays the port's flagged per-turn roll; the tribe +0x2E per-power demand stamp (2 = never demand) unmodeled; @INDIANROAD's site (@0x22449 lea-emit) untraced. | both engines' nativeDemands | content closed |
| C1.10 | ~~Raid payloads unmapped.~~ **MOSTLY CLOSED (rolling; STORES amount+picker 2026-08-29)**: GOLD = random(0x32, min(gold,0x7FFF)) with the −16 tension credit (@0x5C2D4/@0x5C5BC); STORES = up to 100 tries of random_int(0,15) at stock ≥ 10 with the first-try horses coin-flip past stock 52 (@0x5C03E..@0x5C0C7), taking clamp(1, stock, random_int(min(10,stock/2), stock/2)) (@0x5C370..@0x5C3AD) and arming the tribe (horses → counter+herd+25, muskets → counter ×2 at 50+, @0x5C3DD..@0x5C3FB) with the −4 credit; WREAK = a building-tier decrement (@0x5C42A); the burn/ship split and the size-1 razing ride the aftermath (func_05CA7E). Open leaves: the muskets magnitude register (@0x5C08F consumer unread), the outcome-ladder attribute gates (@0x5BFB1..@0x5C023 — power attribute 0/2 bits reshape the roll, identities unread), and the WREAK tier arithmetic detail. | both engines' nativeRaid | mostly closed |
| C1.11 | ~~The Crown's European war cycle is a flagged reconstruction.~~ **CLOSED 2026-08-29 by the full byte read.** The tax-demand pretext bands (func_036138: @KINGVICTORY <100 direct cut / @KINGWIFE <650 with the 30-@ORDINAL wedding cap / @KINGWAR <950 with the remembered country [0x53A8] / @KINGNAVACT <1100 / @KINGSTAMPACT) and the WAR itself are both implemented to the byte model: @KINGNEWWAR = func_035E80 (human, (diff+2)·turn≥800, ≥1 treaty partner, random_int(0,(4−T)·20)≤diff, grant (diff+1)·100 +25/strength-deficit capped (5−diff)·500, veterans (deficit>>3)+1 capped 6−diff ON THE EUROPE DOCK, treaty→war-bit-0x10 swap, 16-turn expiry @0x57FFF); @KINGFRIGATE = the func_02F052 tail (every 8th turn on the [0xA89A]/[0xA89B] blockade tallies — now computed for real by both engines' blockade census — free Frigate for a +10 @KINGTAX raise, no latch); @KINGMERCY is dead GAME.TXT content (0 hits in the EXE) and is GONE. Flagged residue: the strength proxy (0x181f:0x9c8 unread — @UNIT attack+combat stands in), the peace-pending P term (unmodeled, 0), the [0x925D+p·0x13] frigate gate byte (identity TBD), expiry-on-turn instead of at-next-meeting, and the box-only water-path in the census. | `spec/systems/king.md` §3, `port/src/game.js` kingWarCycle, `cport/core/colopy_rivals.c` | closed |
| C1.12 | ~~Cross accrual and bell rates are flagged placeholders.~~ **CLOSED 2026-08-28 by the full production byte-read.** The per-colony site is `func_00A3E1`'s tail: crosses = base 1 + Church + Cathedral (`@0xA4B0..@0xA4D2`, rows 0x25/0x26) + preachers (`func_009FFC @0xA132`: (expert?6:class)+pen, ×2 Cathedral, +50% William Penn); bells = base 1 (`@0xA4DB`) + statesmen (`@0xA1C8`: class+pen, ×2 expert), +50% Jefferson (father 15), +tax% Paine (father 17), Bolivar `(size+3)/5` for AI colonies (father 18), then Newspaper ×2 / Printing Press +50% on the TOTAL (`@0xA587..@0xA5AC`). Both engines implement it; the AI-colony Bolivar term is scoped out with B3.6. | `cport/core/colopy_colony.c` `colony_produce`, `port/src/game.js` `colonyProduce` | closed |
| C1.13 | ~~No prime-resource model at all.~~ **CLOSED — resources are the seeded detail hash** (0x37F:0x4B0 = `tile_terrain_variant_hash @0x60A0`), the bonus table is `func_009AAA` verbatim, and the centre-tile `+2` for types 1/2/9 is wired (`@0xA314`). Runtime-confirmed: the view-mode sidebar prints "(Minerals)" on Vlissingen's centre exactly where the hash says id 6 — which also independently validates the pinned map seed 1657. | `cport/core/colopy_map.c` `map_detail_id`, `colopy_colony.c` `RES_BONUS` | closed |
| C1.14 | ~~Mine depletion uses a port-runtime bit.~~ **CLOSED 2026-08-28 — the full byte chain is wired in both engines.** Accrual: `[0xA896]` += per worked mineral (ore on Minerals +1, silver on Minerals +2, silver on a Depleted Mine +1, `@0x9E13..@0x9E41`, zeroed per produce `@0xA22C`). Consumer (`@0x2EA62..@0x2EA9D`): each point rolls `random_int(0, difficulty+1)`; a NONZERO roll bumps the record's `+0x97` counter; at 50 it wraps and the action `func_02D30A` marks EVERY worked ore/silver cell whose detail is 6/12 with improve bit **0x04** (`@0x2D383`) — which kills the resource bonus and shows the Depleted Mine sprite through `map_detail_id`'s `imp&4` gate — and emits `@DEPLETION` (string 0xD75) once per turn. The old 1/50-per-silver-cell stand-in and its runtime 0x80 marker are gone; the silver-with-no-mine rule (`@0x9E41..@0x9EA6`) stands on bit 0x04 alone. The `[0xA895]` fish accumulator's consumer is FOUND (2026-08-29): the colony-screen food-row renderer `@0x27337`/`@0x2737E` splits the eaten/surplus food segments into fish vs corn glyph runs (display-only, no sim consumer — `spec/systems/colony.md`); the port draws a plain food row, render oracle green, so nothing to wire. | `cport/core/colopy_colony.c`, `colopy_turn.c`, `port/src/game.js` | closed |
| C1.15 | **CLOSED 2026-08-29, driver included.** The bulletin machinery is byte-read (func_02F736..@0x2F962) — pct = min(100, PowerRecord[+0x19] × population_census / 100), GRANT threshold (8−difficulty)×10 (Discoverer 80 .. Viceroy 40), @OTHERMIGHT on every new maximum vs the stored +0x1A with @OTHERLESS at −5 hysteresis, @OTHERGRANTED setting flag +0x00 bit 2 + a diplomacy reset (write pair unread). (The old "+0x02" offset claim was wrong — that byte is the dock pool.) **The +0x19 SENTIMENT DRIVER is now read too**: func_03C424 (stored @0x3E8AA by the per-power updater func_03E844, whose human path also feeds the [0x53D0] rebel meter) = the power's population-weighted average colony SoL, Σ(size × colonySoL)/Σ(size), with colonySoL = func_008524 = 100·(+0xC2)/(+0xC6) (+ a Bolívar father-18 check). Both engines import each rival colony's SoL from the record pair and compute the pct; the random-walk stand-in is gone. Residue: the value is STATIC until B3.6 gives rival colonies bell production, and the father-18 boost is skipped (rival fathers unmodeled). | `cport/core/colopy_rivals.c` news_tick, `port/src/game.js` newsTick | framework closed |
| C1.16 | ~~`PowerRecord +0xFC` totals preserved but unread; the traffic accumulator runtime-zeroed.~~ **CLOSED 2026-08-29 by the sale-bookkeeping byte read** (func_03234A / func_0322D0): the transaction pool at DGROUP [-0x779C] IS `PowerRecord +0x5C` (the 0x9E word stride × 2 = the 0x13C record stride), so the accumulator is SAV-persistent — both engines now keep it IN the record (signed 16-bit words), seed it at load, and move ALL FOUR powers' pools per trade with the byte-verified pressure `qty<<volatility + qty·(diff−2)·16/100` — the **Dutch accrue only 2/3 of sell pressure** (@0x32396) and full buy pressure, the famous trade perk. Fixing it surfaced that `sim_compare market` had sat RED unnoticed (the C dump printed bid, the JS the level); the dump is repaired and the oracle is green. `+0xFC` itself is still only written (its reader is the drift fn's supply sum, modeled). | `cport/core/colopy_market.c`, `port/src/game.js` market fns | closed |
| C1.17 | ~~AI-AI war grievance drivers unread and omitted; war START drivers omitted.~~ **RESOLVED 2026-08-29 — the imagined driver does not exist.** A full sweep of every war-bit-2 write in VICEROY.EXE (all 15 relation_or sites + the direct matrix writes) finds NO autonomous European-vs-European war start: Euro wars begin only at diplomatic meetings (@0x58A7B/@0x59A71), from attacks (func_03ECF0 @0x3F0E8), or as the King's bit-0x10 war (C1.11). The one autonomous driver is a NATIVE TRIBE declaring war on an AI European power (@0x542F0 in the per-colony AI pass func_053B7E) — fully decoded with its census-table gates and tension>25 check (Spain exempt, ×2 aggression scalars) in `spec/systems/diplomacy.md` §3. The port keeps tribe tension only toward the player and rival colonies as static records (B3.6), so that declaration has no consumer there — the rival-vs-rival war tick stays the flagged SIMULATION of meeting-driven wars. Open leaf: the persisted per-power triple [0x9566+p·3] (the war-tier bytes) — meaning TBD. | `spec/systems/diplomacy.md` §3 | resolved |
| C1.18 | ~~Imported units are never Fortified.~~ **FIXED 2026-08-28 (scoped).** The record's `+0x08` byte indexes the same `@ORDERS` table the status letter reads, and both importers now RESTORE the stable states — 1 Sentry, 5 Fortify, 6 Fortified (the fixture's player units carry exactly 0/1/6) — so a fortified defender keeps its +50%/+4 combat standing across a load. 2026-08-29: **8/9 (clear-plow/road) now RESTORE too** — their only companion state is `+0x16` turns_worked, which both importers read (with the `+0x04` bit-0x80 damaged flag for ships/artillery), and the work processors are byte-modeled, so a pioneer resumes mid-job. 2026-08-29 again: **3 (Go To) now RESTORES** — the goal rides in `+0x09/0x0A` (setter @0x41B62, orders 3 for the human @0x41B4B) and both importers accept it when on-map; the existing executor resumes it. The orders-7..12 dispatch table is pinned (@0x51E15): 7 Build Colony -> func_040C1E (founds on the very next tick — a one-turn restore window, left reset), 8/9 the work processors, 11/12 AI internals (func_040E22, left reset). Still reset: 2 Trade Route, 4 Live In Village, FLAGGED. | `cport/core/colopy_turn.c` `units_session_seed`, `port/src/game.js` import loop | closed |
| C1.19 | ~~headingScore: halving predicates, frontier gate and era/resource/colony-site terms unread.~~ **MOSTLY CLOSED 2026-08-29**: `0x902` = func_00765C (ARMED types 1/4/0xB/0x14/0x16, leash ÷2), `0x8D0` = func_007630 (MOUNTED types 4/5/0x15/0x16, leash ÷4), `0x984` = func_00704C (a foreign party on an adjacent same-landmass tile, owner left in [0x8CFA] — it gates the frontier TERMS, it never rejects the candidate); the "early-era" +50 is the **border-pressure** term (+50 vs a non-peace European neighbour, +(tension−50)>>2 above Content) with −25 vs another tribe, and the idle **colony-drift** pull is (band+1)·(12−d)>>2 within 12. All of these now run in both engines (landmass/region gates box-proxied, flagged). Still open: the `+4` orthogonal-candidate flag pair ([bp-0x54]/[bp-0x3E]), the `+5` [bp-6] flag, and the war-party strength-contest branch (the port's war braves ride the raid mission instead — spec'd in ai.md §3). | `spec/systems/ai.md` §3, both engines' headingScore | mostly closed |
| C1.20 | ~~The goto executor's path scoring unported — a straight-line step stands in.~~ **CLOSED 2026-08-29 by the full read of the real stepper.** The premise was off: func_04E2D6 step 5's scorer is the AI MISSION evaluator (its [bp-0xe6] term is func at 0x191f:0xa14's ATTACK VALUE, not a goto distance). The actual goto stepper is `func_062D84` (0x1a1f:0x210, dispatched per goto unit by func_040E22): adjacent goal steps straight; within 7 it runs the 16×16 goal-centred Dijkstra `func_061F02` (byte cost plane [0xA270], queue 225, tile cap 99; step costs: both-tiles road/river-improve (&0xA) = 1, both-tiles terrain river bit 0x40 = 1, one-move unit = 3, else 3× the terrain Movement column [0x2F76]; foreign units/settlements block; a human pays +8 beside a foreign settlement; step picked by lowest plane+step cost with straight-distance tiebreak). Both engines now run it in advanceGoTo. Flagged residue: beyond 7 the engine paths to a 4×4-sector waypoint (func_061E10, unread — the port clamps the goal to 7 along the line); the ship land-entry nibble gate (0x181f:0x6b4 == 1) and the braves' rumour-avoid (0x75e) are proxied/omitted; C1.3 (one tile per turn regardless of movement allowance) is unchanged and stays open. | `cport/core/colopy_rivals.c` goto_path_step, `port/src/game.js` gotoPathStep, `spec/systems/ai.md` §2 | closed |

### C.2 Rules and thresholds that are readings (~60)

Colony: building->job binding inferred from names (`:2548`); the
easy-difficulty +2/+1 field bonus is GONE 2026-08-28 — not in the bytes; the
whole field/indoor/centre chain is now the byte model (`func_009B9C`,
`func_009FFC`, `func_00A222`, `func_008E02`, see spec/systems/colony.md);
Scout in the village-teachable list
uncited (`:2679`); the SCHOOL PASS rewritten to the byte model 2026-08-28
(@0x2DDAC..@0x2E016: per-TEACHER +0x60 nibble counters that tick for every
colonist and persist in the save, flat 3-graduations cap, RANDOM student
from the unskilled pool, @TRAINFAIL only on an empty pool, unskilled
teachers teach at the Servant class via the 0x1C->0x19 remap; the old
first-student/per-student-counter model is gone); school-guard timing
(`:2838`); the 200-food growth threshold BYTE-LOCATED 2026-08-28
(func_0098B4 returns the constant 0xC8 @0x98BD; the whole
growth/starvation/@FOODLOW block rewritten to func_02D658
@0x2E10A..@0x2E36C — growth spawns a UNIT at the fence, starvation keys off
the outage plane [0x8E5A] with the start-of-turn-empty death gate and
easy-difficulty leniency, @FOODLOW is latchless at stock < 4x overdraw; see
spec/systems/colony.md); the over-100 disposal CLOSED 2026-08-28 — the
Custom House IS the gate (@0x2D980; without one nothing auto-sells and
overflow spoils at capacity), the human per-good gate is the +0x8A
checkbox bit, the protected list func_02D606 is AI-only, and the
@SPOIL1-4 / @CARGOREADY0-2 selectors are byte-read (one-good vs many
plus the Warehouse-Expansion digit patch @0x2E8D8; 100-crossing edge
trigger with the at-capacity variants) — see spec/systems/colony.md;
the x32 hammer scale BYTE-VERIFIED 2026-08-28
(func_00B65A @0x0B6B7 shl ax,5, floor 40 @0x0B6C2 — the Wagon Train's
"off-scale 40" was the floor all along; completion also ZEROES the hammer
bank @0x2D26C instead of carrying surplus, and +0xB6 turned out to be
stock[TOOLS], not a second hammer bank — RULINGS 2026-08-28);
`@SIEGE` radius 1, no blockade (`:3091`); the pre-winter
variant CLOSED 2026-08-28 — the engine picks @FOOD2/@STARVE2 off the season
word [0x538C] != 0 (@0x2E19A), which is exactly `G.season === 1`;
herd-growth cap (`:3168`); `@DEPLETION` 1/50 (`:3181`);
`@MERCANTILISM` rate (`:3269`); Custom House picker format (`:3292`);
FIELD LEARN-BY-DOING added 2026-08-28 (was entirely absent): byte-read
@0x2E01C..@0x2E107 — planter/trapper jobs 1..4, unskilled tiers only
(func_0082B2), gated on the power owning ZERO of the specialty (the
func_042726 census), odds 1/100 (1/200 servant, 1/300 criminal),
@TRAINPROFESSION on success; both engines;
tier-packed building write inverts the byte-verified decode
(`cport/core/colopy_turn.c:317`); building removal does not rewrite record bytes
(`colopy_sim.h:74`); a fresh colony's tier field left zeroed (`colopy_cmd.c:369`).

Natives: alarm/tension coupling (`:5192`); `@PISS0-5` pick and trigger (`:5203`);
capital = first listed site (`:5266`); `village_supply_demand` phases 1 and 3 not
reproduced (`:5290`); presence score not decomposed (`:5417`); conversion roll
timing (`:5468`); `@INDIANFOREST` gates cloned (`:5651`); raid-target layer-2 bit
and fort term approximated (`:5728`); raze threshold and `@INDIANWINCOLONY`
placement (`:5863`); `@LEARNMAD` band (`:6087`); scout attribute-bit-6 exemption
and `@CHIEFAREA` radius unread — **the port has no fog to lift** (`:6115`);
`@INDIANSHUN`, `@LOOT`/`@LOOT2`/`@NOLOOT`, `@INDIANSLAVES` (`:6307-6342`);
`@INDIANHELLO1/2` split (`:6539`); `@MADATWAGONS/@MADATSHIPS` bands (`:6631`);
mission founding applies the clamp but **no magnitude** (`:5410`); heresy uses a
fair coin (`:5443`); incite pricing (`cport/core/colopy_village.c:8`).

Combat: `@EVASIVE` evade condition (`:7006`); `@LOSTTHEIRSCOUTS` 50 horses
(`:7239`); Combat Analysis shown after resolution rather than after the roll
(`:7331`).

Rivals/diplomacy: force proxy for `[0x941C]` (`:8337`); PEACE-vs-OLDPEACE, topic
priority, withdraw/threat selection and smite price all uncited (`:8337`);
`@PIRACY` priority and `@MEEKNESS` verb (`:8375`); withdrawal recalls to nearest
colony vs "to Europe" (`:8410`); `@HEATHEN` has no tribe-vs-rival relations
(`:8439`); `@WARMEEK/@WARMANLY` ladder (`:8462`); `@GIFTS/@THREATS/@PROVOKE`
selection TBD (`:8540`); smite price (`:8572`); `@SNEAK` 1/60 and `@GIVECASH`
purse (`:7505`); `@LOOTFOREIGN` has no port model, simulated (`:7467`);
rival-vs-rival rates (`:7566`); news ticker parameters (`:7462`).

King/WoI: `@KINGWIFE` second gate (`:8739`); TUTORIALn difficulty gate (`:8188`);
`@CANTMOBILIZE` musket gate has no surviving emit site (`:9156`); rebel-band
trigger (`:9236`); capitulation ladder razes rather than occupies (`:9250`);
mercenary offerer unread (`:9354`); retirement warning lead times (`:10903`);
intervention 2000-bell threshold (`cport/core/colopy_woi.c:14`).

Map/Europe: region builder unread, fresh games flood-fill (`:493`);
`@LOSTCITY0` candidate-list size (`:8863`); founding guard ORDER (`:2101`);
`@TOONEAR` radius (`:2113`); the three pre-founding confirms and "ocean access"
(`:2138`); `@INDIANLAND` radius and price (`:2162`); `@ONLYCOL` predicate
(`:2045`); clear-forest lumber column and `@DEFOREST` adjacency (`:2453`);
`@SHIPRUN/@SHIPSLOW` odds 50/50 (`:11064`); capture plunder formula (`:11172`);
`@TRADEWITH` barter pricing (`:11208`); `@SAILHOME` trigger from the manual
(`:11256`); `@ONLYPIO` predicate (`:11315`); `@WAREHOUSEFULL` per-good behaviour
(`:11399`); `@FINDCITY` matcher (`:11443`); crossing bands indexed by slot
(`:4576`); `@ARMOPTIONS` row gating and C row text (`:4706`); Europe menu row
text and price placement (`cport/game/colopy_input.c:761`); `@PURCHASETAX` rate
(`:5042`); **the tax petition has no engine entry point** — port-authored under
key K (`:9001`); `@PRICEUP/@PRICEDOWN` bid-vs-ask (`:4434`); market traffic
accumulator not reconciled into the save (`cport/core/colopy_market.c:17`);
the `@REFIT` repair timer CLOSED 2026-08-29 — byte-read from func_02F052
(+0x16 counter, +2/turn on the map, +1 in Europe, complete at the @UNIT
defense column; no Drydock gate exists in the bytes).

Dialogs: KING*/IND* sheet centres unmeasured (`:894`); `@0x073474` ink slots
(`:907`); empty-entry = full amount (`:980`); speaker anchoring per family
(`:6437`); key->wrapper routing only partially byte-mapped (`:6376`); ad-hoc
notices where no key is identified (`:6457`); the ask queue holds one dialog
(`:6475`); plural string phrasing (`:1239`); village greeting band
(`cport/render/colopy_dialog.c:379`); `@KILLWAGONS/@LOOTWAGONS` `%STRING3` has no
slot on the C two-string bus (`cport/core/colopy_rivals.c:1241`).

Menus/sprites: pulldown grouping and per-unit gating capture-derived (`:1775`);
`onSeaLane` gate capture-derived (`:1786`); carried-unit label verified for two
units only (`:1954`); `@SCORE` joke-name row runtime-driven (`:8221`);
`stripPitch` fractional path unread, so report gauges stay a separate helper
(`:266`); settlement X anchor (`:5122`); ownership patch art uncited (`:5148`);
colony speckle a positional hash (`:3955`); `func_005296` ramp dither not
reproduced (`:3679`); plowed-field furrow dots invented — **no PHYS0 frame
exists** (`:1539`); blocked-cell bit 0x40 read (`:3777`); dock drop-highlight
inferred (`:4197`); BUY/CHANGE plate metrics (`:4233`); goods drag armed on the
down-edge (`:11800`); plaza lift = identity (`:12008`); which drag pairing
loads vs unloads (`:12037`); build-picker unit target `0xC0+u` outside the .SAV
vocabulary (`cport/game/colopy_input.c:932`); pedia sort approximation
(`cport/render/colopy_boot_render.c:609`); F3 bells gauge discrepancy
(`cport/render/colopy_report_render.c:14`); F6 caption/row-base contradiction
(`:9957`); F9 contact flag stand-in and portrait rule unresolved (`:10137`,
`:10129`); Expert Teachers figure an unobserved pattern extension (`:9692`).

Save/load: **898 of the 1502-byte save tail is TBD-unmodeled** (preserved
verbatim so the roundtrip stays byte-exact) (`cport/core/colopy_state.h:49`);
only the first two cargo quantity bytes are mapped, further slots load full
(`:10573`); the `declared` WoI flag is not mapped from the globals block
(`cport/core/colopy_sav.c:174`); new-game prelude/mid/tail blocks zeroed
(`cport/core/colopy_newgame.c:15`); Europe crossings, trade routes and the
diplomacy matrices **load empty / at peace** (`:10310`).

### C.3 Deliberate non-fidelity to decide on

| # | Item | Cite |
|---|---|---|
| C3.1 | **Taking the last colonist out of a colony is refused** — engine behaviour unread, `@ABANDON` already exists. | `port/src/game.js:2086` |
| C3.2 | **No fence hit-rect** — `@TUTORIAL4` places it "near the water on the colony picture" but no byte-read rectangle exists. | `port/src/game.js:2088` |
| C3.3 | **Ending a turn with nothing active** has no DOS `@ORDERS` row; the board adds two exits (long-press, ORDERS > Wait for next unit). | `cport/README.md` |
| C3.4 | **Drag and drop absent by design** on the board; every JS drag has a tap equivalent. | `cport/README.md` |
| C3.5 | Deleting a trade route leaves later indices unshifted on bound units — mirrored verbatim from the JS as a flagged quirk. | `cport/game/colopy_input.c:1459` |
| C3.6 | Ten fixed save slots + `HOF.DAT` are port inventions (shell chrome). | `.ino:1180`, `:1680` |
| C3.7 | Sidecar `.CPX` carries the unit build target and trade routes because the DOS format has no field for either. | `cport/core/colopy_extras.c` |

---

## Part D — Board verification: needs the physical device

| # | Item | Cite |
|---|---|---|
| D1 | **The digest acceptance run has never been done on the P4** — `l COLONY00.SAV` then `t 100`, matching the host digest turn for turn. This is the acceptance gate for the whole port. | `cport/p4/README.md` bring-up item 4 |
| D2 | **RGB565 LUT vs the panel's element order** (red/blue swap) — one line in `build_lut` if wrong. | `cport/p4/README.md` watch-fors |
| D3 | **Flush cost unmeasured**: `drawBitmap` pushes the full 1024x600x2 (1.2 MB) every redraw. Fix if slow: `getFrameBufferByIndex` direct writes or dirty-row tracking. | same |
| D4 | **Partition scheme never measured** against a real build. | same |
| D5 | **Loop-task stack headroom** — the live crash risk; `w` prints the watermark, "a number near zero means the next deep screen will crash". | `.ino` `stack_report` |
| D6 | **BLE mouse end-to-end untested**; needs a core with hosted BT for the P4 *and* C6 firmware exposing BT (Elecrow ship it for Wi-Fi 6 and publish no BT example). Only BLE can ever work — the C6 has no Classic radio. **HARDWARE-VERIFIED 2026-08-19: `BLEDevice::init()` crashes this board.** With `COLOPY_BLE_MOUSE 1` it panicked during `setup()` — no boot at all, no serial diagnosis, because the init ran before anything could report. With `0` the same build boots. Which of the two upstream conditions fails is still unknown (core without hosted BT vs C6 firmware without BT); what is settled is that the call does not survive on this hardware today. The bring-up is now lazy (`bt_begin()` from `bt_scan()`), so the blast radius is Bluetooth alone — but **the feature does not work**, and turning the flag on still costs a panic the moment you tap Scan. Treat `COLOPY_BLE_MOUSE` as off. | `.ino:186-214`, `bt_begin()` |
| D7 | **BLE HID report parsing is a guess for non-boot mice** — the Report Map is not parsed; reports hex-dump to serial so a real device can be characterised. | `.ino:210-214` |
| D8 | **The whole I2S audio path is unverified on hardware.** | `.ino:381-412` |
| D9 | ~~**Audio pin provenance does not resolve** — the block cites "Elecrow Lesson12, PROVENANCE.md" but `elecrow_ref/` has no Lesson12.~~ **RESOLVED 2026-08-17** — the audio merge brought `cport/p4/elecrow_ref/lesson12_audio.ino` and `cport/p4/elecrow_ref/lesson12_board_config.h` into the tree with both `PROVENANCE.md` rows. All five values in the sketch match the reference byte for byte: LRCLK 21, BCLK 22, SDATA 23, power gate GPIO 30 with LOW = enabled. | `cport/p4/PROVENANCE.md`, `cport/p4/colopy_p4.ino:452-457` | closed |
| D10 | **No USB host keyboard path** — Elecrow's only USB example is device-mode HID; the P4 Arduino core has no host-keyboard driver. | `cport/p4/README.md` |
| D11 | **Long-press -> right-click is not implemented** — every tap is a left-click. | `cport/p4/README.md` |
| D12 | ~~The three Europe SHOP menus lay their price out differently on the board than in the reference port.~~ **FIXED 2026-08-17.** `rm_draw_dialog_rows_notes` gives the C dialog painter the right-aligned second column it never had; `ui_euro_menu_rows` now returns label and price separately instead of concatenating them, and the box widens by `label + note + 20` the way `euroMenuBox` does. Board and port now lay the shop menus out alike, price hard against the right edge as `census_euro_train` shows. Knock-on: `emrows` no longer has to be scoped to the two harbour menus — the scoping existed only because the baked-in price made the strings unmatchable — so **all five euro menus are now compared, labels and prices** (new `emnotes`). | `cport/render/colopy_dialog.c`, `cport/game/colopy_input.c` | closed |

---

## Part E — Assets present in the game but not shipped

Measured 2026-08-17: **139 of 206 `.SS` and 7 of 35 `.PIK` are absent** from the
pack (67 sheet files packed + `PHYS0C` derived at runtime; 28 backgrounds).

| Group | Count | Pairs with |
|---|---|---|
| Founding Father portraits `CC-00..CC-24` | 25 | F3 draws names as text only |
| Declaration lettering `DEC-LOW/UPP A-Z`, `DEC-SQIG` | 53 | Declaration screen does not exist |
| Score plates `SCORE01..24` | 24 | End-game score screen unimplemented |
| Opening cinematic sheets | 14 | `OPENING.EXE` — separate program (Part H) |
| Closing cinematic sheets | 7 | `CLOSING.EXE` — separate program (Part H) |
| King / win / lose plates | 5 | Endgame screens unimplemented |
| Second banner frames `*2` | 4 | Only `*1` banners packed |
| MicroProse boot logo | 2 | Boot animation not implemented |
| `CURSOR.SS`, `PARCH.SS` | 2 | **Why the BLE pointer is a hand-drawn arrow** |
| Backgrounds | 7 | `CCBKGD CLOS-BKG CUSTOMIZ DECLARAT DECOIND OPENBORD OPENING` |

**Correctly excluded, and staying excluded:** `BDARK.SS` (CLAUDE.md hard rule 5,
enforced by an assert in `gen_sd_pack.py:187`) and `WDCUT06` / `WDCUT12` — both
have **no traced call site**, so they are omitted rather than fired on a guessed
event (the WDCUT12 razed-scene gloss was REFUTED 2026-07-30).

All source files are present in `raw/COLONIZE/`; the blocker is painter work, not
extraction.

---

## Part F — Audio

**F1. Merge `claude/colonization-audio-port-mwt067`. — DONE 2026-08-17.**
It delivered what this branch could not: music (each tune rendered offline by the
*original* `?SOUND.COL` driver under DOSBox, shipped as IMA renders — no runtime
FM synthesis), a 2-voice mixer, a byte-pinned cue/scheduler layer, `COLAUDIO.PAK`,
host tests (`./smoke --audio`, `./smoke --audiopak`), and both P4 I2S and Teensy
MQS backends. Ten files conflicted, including both board sketches — each branch
had grown a P4 audio backend independently.

**Both** audio paths survive the merge, chosen at boot in `audio_init()`
(`cport/p4/colopy_p4.ino`): if the SD card carries `COLAUDIO.PAK`, the merged
pack backend takes it; otherwise this branch's direct `COLDIG.BIN` cue player
runs. That is deliberate — the pack must be rebuilt from a DOSBox capture the
user may not have, and dropping the COLDIG path would have silenced the board
outright. `tools/audio/captures/` and `cport/pak/COLAUDIO.PAK` are gitignored, so
the pack is not in the tree.

**F2. Replace its SFX slice table with the byte-decoded one. — DONE 2026-08-17.**
That branch located effects in `COLDIG.BIN` by cross-correlation and labelled the
result "empirical capture — NOT byte-cited". This branch decoded the driver's
actual `(offset,length)` table. They disagree on **every one of the 15 shared
ids**: offsets drift by tens to thousands of bytes and lengths run uniformly
short, clipping decay tails — and the empirical map shipped `0x59`, which the
drivers list in `sfx_ids_not_samples` as not a bank sample at all. Four ids it
shipped as FM renders — `0x4D` `0x4E` `0x4F` `0x5B` — the driver's own dispatcher
sends to real COLDIG samples; `0x4E`, `0x4F` and `0x5B` are wired cues today
(`RAIDGOLD`, `RAIDSTORES`, `RAIDNOTHING`), so they were audibly wrong.

`tools/gen_audio_pack.py`, `tools/audio/verify_pack.py` and
`tools/audio/trim_masters.py` now read `data_extracted/coldig_index.json`. The
pack builds **25 SFX entries, all 25 bit-clean** against the bank
(`tools/audio/verify_pack.py`: 0 failures) — up from 16, and every cue id the
engine fires now resolves to a real sample. The generator also refuses any
sample whose rate is not 11025 Hz, because the mixer's PCM8U path is a fixed
2× hold (`cport/audio/colopy_audio_mix.c:115`); no sfx id maps to one of the
five 19050 Hz samples today, and this catches it if that changes.
`data_extracted/data/coldig_slices.json` is retained as a record of the capture
work, marked superseded in its own `_meta`, and read by nothing.

**F2a. The capture run is NOT blocked on the user's machine. — DONE 2026-08-19.**
Both this ledger and the sketch banner recorded `COLAUDIO.PAK`'s music as needing
a DOSBox capture "the user may not have", and that assumption was never tested
against the session container — which has `dosbox`, `xvfb-run`, `xdotool`, the
full `tools/dosbox_harness/game/` tree and 28 GB free. All three sets were
captured here: **30 tunes** (`0x20..0x3B`, `0x3E`, `0x3F`), **8 fanfares**
(`0x8020..0x8027`), **32 SFX** of which the 4 live FM-only ids are kept. Every
tune and fanfare carried signal.

Corroboration, since nobody can listen from here: durations reproduce the prior
run's committed record to within ~0.1 s per tune (captures carry real jitter, so
that is the tightest agreement available), and tune **`0x34` hit 241.5 s against
the 240 s cap**, matching the prior 242.18 s — the "overruns and probably loops"
note is now reproduced by two independent runs, so it is a property of the tune.

`COLAUDIO.PAK` is now **25,929,772 bytes, 67 entries (25 slices + 42 renders),
`verify_pack.py` 0 failures**. The board needs no code for this: `au_pump`,
`au_on_new_game`, `au_on_woodcut` and `au_on_event` are already called from the
sketch and path 1 streams the pack from a `FILE*` on SD, so the 25.9 MB never
enters RAM. **Copy it to the card beside `COLOPY.PAK` and the board has music.**

This also retired the last artifact still carrying the pre-F2 error:
`masters_manifest.json` held **13** SFX renders from the empirical slice map,
including `0x4D`/`0x4E`/`0x4F`/`0x5B` which F2 showed are real bank samples. The
byte-decoded index lists exactly five ids as not-samples and `0x46` captures
silent, so **4** is right. Regenerated.

**F3. Then that branch's own open list:** the human A/B listen pass (needs
speakers); tune `0x34` hit the 240 s capture cap and likely loops; SFX preemption
modelled not decoded; pending queue depth 1 vs the original's 8-deep ring;
`au_cmd(1)` stop semantics approximated; driver commands other than 1/8 unported;
`[0x828]` rotation override unexposed; scheduler PRNG a stand-in; cue rows tagged
`[inferred]`; **European first-contact fanfare not wired**; **all combat SFX ids
TBD**; the Sound Test and Pick-Music/Sound-Options screens not in cport's input
layer; play far-call thunk identity untraced; PC-speaker and MT-32 variants not
reproduced; 25.9 MB is SD-only on both boards.

**F3a. Music is now DATA-complete but EAR-unverified.** `verify_pack.py` proves
each render survived IMA encoding (SNR per entry) and each slice is bit-identical
to the bank. It does NOT prove a cue fires the tune the original fired, that the
scheduler's rotation matches, or that `0x34`'s loop point is right. The human A/B
listen pass in F3 is the gate for all of that and remains open. Nothing in this
repo can close it.

**F4. On the fallback COLDIG cue path** (used when no `COLAUDIO.PAK` is on the card): 24 of the 40 `lcall 0x181F:0x4C0` play sites
stay silent because their event is TBD (four compute the id at runtime); only 12
cues are wired. `sfx_play()` blocks for the sample's length — one voice, no
mixing.

---

## Part G — Tooling and oracle gaps

| # | Item | Why it matters |
|---|---|---|
| G1 | ~~No worst-case stack-path budget.~~ **FIXED 2026-08-19.** `tools/stack_budget.py` compiles the core with `-fstack-usage` for frame sizes, reads call edges out of `objdump -d`, and reports the max-weight path from each of the board's 11 entry points; `make test` runs it at `--limit 4096`. It closed the crash that prompted it — the D12 note column put `enotes[24][64]` into `in_click_inner`, taking that frame 1,952 → 3,488 bytes on top of the whole command chain, and `-Wframe-larger-than=4096` never fired because 3,488 < 4,096. Worst paths after the fix: `in_key` 5,200 → **2,352**, `in_click` 4,192 → **2,048**. Recursion cycles and indirect calls are reported but NOT summed — that is the tool's stated limit, not a silent one. | closed |
| G1a | ~~**Nothing compares the port to the REAL game.**~~ **CLOSED 2026-08-19.** Every other gate proves `C == JS` — `sim_compare`, the five `input_compare` scenarios, all seven `render_*_compare` — so an error both engines share was invisible to all of them. `tools/screen_census.py` drives the original under DOSBox, captures the emulated 320×200 framebuffer, renders the port's own version from the **same save**, and diffs. The foundation: `COLONY00.SAV` is byte-identical to the `sav1653` fixture (27,909 bytes, digest `3348C0DC`), so DOS slot 0 and the oracle fixture are one game state. Task #79 was parked as "blocked on the user's DOSBox" — it was never blocked; this container runs the harness, as the music capture proved. `make census` diffs (seconds, off committed baseline frames); `make census-capture` re-grabs (minutes). First results below. | closed |
| C4.1 | ~~F7 Naval: the per-row unit icon is in the wrong place.~~ **IMPLEMENTED 2026-08-20 from the `func_00386A` decode.** The composite is *sprite + a black-outlined PLATE in the owner colour + a status letter*, and the plate's **side depends on the unit CLASS**: a Galleon or Frigate (class 1) wears it to the RIGHT of the hull, a Merchantman or Caravel (class 3) to the LEFT, a foot unit (class 0) bottom-aligned, a wagon or artillery (class 2/4) at `dx0 - pw/2 + 9`. The port drew a fixed 8×9 plate at a fixed x for every unit — and the comment that sat there admitted the model was wrong, noting the Frigate landed a pixel off "unexplained". Plate size comes from the letter: `strwidth + 3` × `fontheight + 3`. **Measured: 1,635 → 1,100 px.** Two approximations remain, both stated at the call site: the engine takes the sprite w/h from two undecoded sheet-header fields (`es:[bx+0x3E]`/`[bx+0x40]`) so the port substitutes its own trimmed frame size (measurably the better candidate — a fixed cell width scores worse at every value tried, 12–18), and the F7 caller's own x is untraced, so the anchor **4 is FITTED** (2 → 1,529 px, 5 → 1,996). **CLOSED 2026-08-28: both approximations resolved by bytes.** `func_00380C` is a TWO-LAYER draw — a solid black SILHOUETTE of the frame at (x, y) (`@0x003829`–34), the real sprite at (x+2, y) (`@0x003854`) — and the F7 caller `func_03954C` enters the composite at `@0x039843` with **bx = [bp-0x56] = 2** for ship rows (`@0x039574` passes +0x56 = 88 for sea-borne land units); the fitted 4 was compensating for the +2. The sheet field `es:[bx+0x3E]` settled as the TRIMMED width by sweep (0 best, −1 → +91 px, −2 → +103). With the per-good cargo crates (`(qty>=0x64 ? 0x17 : 0x27) + good` `@0x039605`/`@0x0395A8` = bundle 22/38+good at 88+12k) and the colony-name location column (`@0x0396A4`) landed too, **F7: 1,100 → 163 px** (82 = mouse pointer). | `cport/render/colopy_report_render.c` `draw_f7`, `cport/render/colopy_map_render.c` `rm_unit_panel`, `port/src/game.js` `unitPanel`, `spec/ui/render_primitives.md` §1b | closed |
| C4.5 | ~~The Europe screen renders with the wrong palette.~~ **FIXED 2026-08-19 — the census's first repaired fidelity bug.** The port let `EUROPE.PIK`'s embedded palette win; the original follows the master `VICEROY.PAL` at all **22 indices where the two disagree** (byte-checked at 54–59: PIK `(113,142,198)…(57,69,150)`, master and DOS `(105,138,195)…(40,56,146)`). **Measured, both engines: the census EUROPE row went 12,817 px (20.0%) → 5,355 px (8.4%), and its palette component 7,848 → 0.** The C was one line (`rd_use_palette(0)`), because it renders backdrops from PIK pixel indices through the current palette. The JS needed more: it draws a PNG mpskit had already flattened to RGB with the PIK's table, so `usePalette()` could not reach it — `render_europe_compare` went red at (306,129), JS `(89,113,178)` vs C `(77,101,174)`, index 56. `bundle.py` now re-tables that one backdrop (`uri_remapped`, pixels untouched, colour table swapped), and the Europe oracle is back to **0 structural with 0 palette-model acceptances** — down from 7, so the fix also removed a standing acceptance. **Scoped to Europe deliberately:** the five report plates show 0 px of palette divergence, so they agree with the master anyway and cannot tell us whether the engine ignores *every* PIK palette. Do not generalise without a screen whose palette actually differs. | `cport/render/colopy_europe_render.c:107`, `port/src/game.js` `drawEurope`, `port/tools/bundle.py` `uri_remapped` | closed |
| C4.6 | ~~Europe's wood menu bar is 8 rows of wood with no separator.~~ **FIXED 2026-08-19 — and the spec had been right all along.** `spec/ui/europe_screen.md:51` has said *"WOODTILE tiled y0..6 (7px only) + black separator at y7"* (measured from capture, tier **A**) since the screen was specified. Both engines clipped the strip to 8 rows and drew no separator, so row 7 rendered wood instead of black — **all 320 px of it wrong on every visit**, and invisible to every gate because C and JS were wrong *identically*. Measured: the census EUROPE row 5,355 → 5,035 px, exactly the 320 px of row 7. The lesson is not the pixel: a spec line can sit correct and unimplemented indefinitely when nothing compares the build to the thing the spec describes. | `cport/render/colopy_europe_render.c`, `port/src/game.js` `drawEurope` | closed |
| C4.2 | ~~F9 Indian: per-tribe colour divergence.~~ **SUPERSEDED** by the C4.12–C4.15 rebuild (name ink = the tribe's own `@TRIBES` colour, drop shadows, muskets/horse cells, the 40+56k grid) and closed outright by C4.16's hardcoded-Sioux find: F9 sits at 94 px, of which 82 is the pointer. | census `F9` | closed |
| C4.3 | ~~F2 Religious: a 37 px block differs.~~ **SUPERSEDED** by C4.18 (the reading was the crosses badge's absence) and closed by C4.23 (the gauge seeds): F2 sits at the 82 px pointer floor. | census `F2` | closed |
| C4.4 | **F5 Economic: 398 px at glyph scale** over x 67–245 — reads as text metrics or content rather than a misplaced element. 0.6%. **Half of it was C4.9** (the bid/ask straddle — the report prints `market_bid`/`market_ask` and both quotes were one high): 398 → **202 px (0.3%)**, measured. The remainder was ONE element, found 2026-08-28: the **vertical rule at x = 67** (rows 25–176, the same 0x77 rule ink) between the commodity names and the price columns — 202 → **97 px**, of which 82 is the pointer. F5 is closed to ~15 px of glyph-scale residual. | census `F5` | closed |
| C4.7 | ~~Europe puts a crossing ship in the harbour and dumps its passengers on the dock.~~ **FIXED 2026-08-20.** The off-map "in Europe / high seas" sentinel is not ONE state — it is **five**. A `UnitRecord` parked off the map stores `x == y == BASE + power`, and the base says where in the Atlantic it is: **`0xEC` = in Europe** (byte-verified at three independent sites, all testing `unit.x - power == 0xEC`: `@0x0421EF` in `func_042138`'s per-power recount, `@0x035E01` in the immigration accumulator, `@0x058B8F` in the REF/war sweep); **`0xF0`/`0xF4` = bound for Europe** (`func_042138` recounts both into the same per-power counter `[power-0x6BAA]` — `@0x042455`/`@0x04243F` — which is the counter the sail-for-Europe path increments `@0x041B2F` before stamping `UnitRecord+0x07 = 0x45` `@0x041B6D`, and the fixture's only `0xF4`-class record, #31, carries exactly that `0x45`; `0xEC` feeds the *other* counter, `[power-0x6BA6]`, `@0x0421F6`); **`0xE4`/`0xE8` = bound for the New World** — capture-verified for `0xE4`, since sav1653's Dutch Galleon (record #56, `x == y == 0xE7 == 0xE4 + 3`) is drawn by the original under **"Bound For New Netherlands"** with its three passengers aboard while the same screen reads **"No Ships In Port"**. The port read every off-map unit as in-port. **Measured, both engines: census EUROPE 5,035 → 4,116 px.** `0xE8`'s direction follows from the pairing and has no site of its own — FLAGGED. So does the progress ORDER inside each pair, so a restored crossing gets a full `SAIL_TURNS` timer rather than a guessed remainder. | `cport/core/colopy_europe.c` `euro_sentinel`, `port/src/game.js` `euroSentinel` | closed |
| C4.8 | ~~Europe's six cargo slots vanish when the harbour is empty.~~ **FIXED 2026-08-20.** Both engines hung the cargo row off `if (ship)`, so an empty harbour showed bare backdrop where the original draws six empty slots. `func_0314DC` `@0x0314F1` branches the other way: with no ship selected (`[0xFA2] == 0`) it walks `i = 0..5` and paints **every** slot from one sprite (`@0x03154F`, frame `0x7B`). The grid is byte-verified too — `func_0314AE` `@0x0314AE` stores `x = 12i + 0x93` (147), `y = 0xA5` (165), `w = 0x0A` (10), `h = 0x0C` (12), confirming constants the port had from a capture. `ICONS` frame **122 matches the original's empty slot pixel-for-pixel** on the census frame, which also settles the engine-`0x7B` ↔ bundle-122 mapping the colony dock had already assumed. **Measured: 4,116 → 3,396 px.** | `cport/render/colopy_europe_render.c`, `port/src/game.js` `drawEurope` | closed |
| C4.9 | ~~Every market price in the port is one too high.~~ **FIXED 2026-08-20 — a SIM bug the census caught through a render.** The record byte at PowerRecord `+0x4C` is the **price LEVEL**, and neither quoted number equals it: they straddle it. `func_030590` `@0x030590` computes the **bid** as `al = power[+0x4C+good]; dec ax; jns` → `max(0, level - 1)`; `commodity_current_price` `@0x030566` computes the **ask** as `cx = [good*9 - 0x6900]; al = power[+0x4C+good]; add ax, cx; jns` → `max(0, level + spread)`, where that `@CARGO` byte is the number `burden` already carries. The port quoted the level itself as the bid and `burden + 1` as the ask, so **both** numbers came out one high — all sixteen goods, on the Europe market bar and in the F5 report, and in every sale's revenue. The old `max(1, level)` **read**-clamp went with it: it clamped the level, the original clamps the result, and the original's first market cell quotes a bid of **0**. **Measured: census EUROPE 3,396 → 3,140 px and F5 398 → 202 px**, with the full parity suite still green (both engines changed together). This is the first census finding that was not a render bug at all — and, like C4.6, **the documentation already said so**: `docs/COLONIZATION_TECHNICAL_REFERENCE.md:1421` has read *"Display: sell = level − 1, buy = level + burden"* since the PowerRecord table was written, and `:1433` spells out the worked example (Food at level 9, burden 7 → sells at 8, buys at 16). Neither engine implemented it. That is now twice in one census that a correct, byte-derived line sat unimplemented because nothing compared the build to the original. | `cport/core/colopy_market.c`, `port/src/game.js` `bidPrice`/`askPrice` | closed |
| C4.10 | **Europe's market-bar ICON row is offset.** 1,011 px over rows 178–192 after C4.9. The measurement says most of it is a whole-row shift: rendering the port's icons **one pixel left** drops that band 1,049 → 684 px. Not fixed, because the centring rule has not been read from the bar's own drawer, and the two candidate expressions are the same for every width — `9 + 19i - (w>>1)` and `19i + (19-w)/2` agree at all `w`, so the −1 is *not* a rounding choice between them, and inventing a third would be a fabrication. Needs the market bar's draw site. | census `EUROPE` |
| C4.20 | ~~The Europe status band has one space where the original has two.~~ **FIXED 2026-08-20 — one character, 578 px.** The band read `"%s, %s. %s, %u.  Tax…"`; the original doubles the space after the country too. Established by measurement, not by eye: every 8-px window of the band left of x=136 fit the original at shift **+1 with zero differing pixels**, every window right of x=144 fit at **−1 with zero**, so exactly one 2-px width difference sits between them — and the gap between "Netherlands." and "Autumn" measures **7 px on the original against the port's 5**, which is precisely the difference between the double space this same string already uses after the year (7 px on both sides) and a single one. Rows 0–6 now diff to **zero**. | `cport/render/colopy_europe_render.c`, `port/src/game.js` `drawEurope` | closed |
| C4.21 | ~~Europe's three panel headings: wrong ink, wrong x, wrong line.~~ **FIXED 2026-08-20.** Every heading is palette **69**, not the **68** the top bar uses — measured on four independent captures (the census baseline plus the three 2026-08-07 Europe frames). And they are **centred**, not at the fixed x's the port carried. The proof that it must be centring: panel 3's heading MOVES with its content — "No Ships In Port" sits at 156–209 while "Loading:" sits at 168–194 with the ship's name on a **second line** at 160–205, so the port was wrong twice there, once about x and once about putting the ship name on the same line. Panel 2 settles the convention: "Bound For" (ink 33) at 91 and the region name (ink 56) at 79 are two strings of different widths that solve to the **same** centre under the port's own rule, cx = 107 — and they must be centred anyway, since `regionname` varies by nation and a fixed x could only be right for one. Panel 3's two strings likewise both solve to cx = 183. **Measured: the panel band 445 → 39 px, Europe 2,524 → 1,956.** FLAGGED: "Loading:" alone solves to cx ≈ 181–181.5, ~1.5 px off the 183 its own second line gives; a trailing space in the engine's string would close it exactly, and that guess is not made. Panel 1's heading never changes, so its cx = 36 is a one-string fit indistinguishable from a fixed x = 12. | `cport/render/colopy_europe_render.c`, `port/src/game.js` | closed |
| C4.22 | ~~Europe's recruit buttons are flat boxes in the wrong colour.~~ **FIXED 2026-08-20.** The frame is a **bevel**: top edge and left column `0x39`, bottom edge and right column `0x30`. Read straight off the census frame, where all three buttons carry it identically — rows 89 and 97 are 37 px of `0x39` and `0x30`, and rows 90–96 hold `0x39` at x=281 and `0x30` at x=317. The port drew a flat `0x7D` rect, which is why the two edge rows differed across their whole width. The label tail is `0x0F`, not `0x10`; only the accelerator letter is `0x0E`. **Measured: that band 470 → 88 px (of which 82 is the mouse pointer), Europe 1,956 → 1,537.** FLAGGED: the original shows **no** selected row on any Europe frame available, so the port's `0x0F` highlight is its own affordance for a click cursor the original may not have; it is kept, and the census now renders with `euro_row = -1` to match the state the captures are in. | `cport/render/colopy_europe_render.c`, `port/src/game.js` | closed |
| C4.23 | ~~F2's missing badge is the crosses gauge.~~ **FIXED 2026-08-21 — F2 is at the cursor floor (82 px, all mouse pointer); the badge diffs to ZERO.** The gauge machinery (`0x181F:0x236` = `func_002EE4`, pitch/scale helper `func_002D74` reading the sheet-header width at `es:[bx+si+0x3E]`, number badge `func_002E4E`: black `(strwidth+1)×7` box at `(x, y+2)`, digits at `+1/+1`, early-out on value ≤ 0) was **already implemented faithfully in both engines** as `r_gauge`/`gauge` — decoded against it line for line, only the number-badge y and the drip modulus were confirmed rather than changed. What was missing was the **data**: PowerRecord `+0x2E` (crosses accumulated, 30 on the fixture) and `+0x30` (threshold, 284) — byte-verified at the F2 caller `func_037958` `@0x0379AB/AE` — were inside an unmapped pad, so `G.crosses`/`CR.crosses` stayed 0 and the gauge bailed at its first guard. Both are now mapped, seeded at import, and the gauge span reads the stored/mirrored threshold. The fixture corroborates: the byte-cited threshold formula computes exactly the stored 284. | `cport/core/colopy_records.h`, `colopy_turn.c`, `colopy_report_render.c`, `port/src/game.js` | closed |
| C4.29 | ~~The port's immigration unit count is 130 where the original's is 138.~~ **FIXED 2026-08-28 — the membership read is done.** `func_035D9A`'s unit loop counts **one per owned UnitRecord, owner nibble `+0x03` and nothing else** (`@0x35DDE..@0x35DF8`) — a rider counts separately from its ship, Europe-parked ships and dock units included; the `0xEC`-sentinel branch (`@0x35E01..@0x35E2B`) adjusts the CROSS base for dock units after independence, never the count. Also byte-read on the way: threshold = min(2·count+8, 4000) (`@0x35E2E..@0x35E47`), ×(8−difficulty)/8 for a human power (`@0x35E5D`), and **England pays 2/3** (`@0x35E6E..@0x35E7B`). Both engines now count colony pops + on-map units + their riders + crossings + passengers + dock recruits; the C computes **exactly the fixture's stored 284**, and all sim/input oracles stay at 0. | `cport/core/colopy_turn.c` `immigration_threshold`, `port/src/game.js` `immigrationCount` | closed |
| C4.24 | ~~Europe's market icons are a pixel left, all sixteen.~~ **FIXED 2026-08-20.** The market cell CENTRE is `19i + 10`, byte-verified in the price drawer: `imul ax, [bp+6], 0x13; add ax, 0xa` `@0x030ED4`–`@0x030ED8`, with the icon row's y stored in the same frame as `0xB5` = 181 `@0x030ECF`. The port centred on 9. This is the row C4.10 measured but refused to fix on a fitted −1, because the two candidate centring expressions were identical at every width and a third would have been invented — the EXE settles it instead. **Measured: that band 1,030 → 59 px, Europe 1,537 → 566.** Scoped to Europe: the colony screen has its own market strip from a different function and no census capture yet, so it keeps its capture-derived 9. | `cport/render/colopy_europe_render.c`, `port/src/game.js` | closed |
| C4.25 | ~~A ship's manifest: wrong figures, wrong profession, wrong order.~~ **FIXED 2026-08-20 — three faults in one row.** (a) A professioned entry is `{name, type}` — *name* is what the man IS, *type* what he is EQUIPPED as — and both engines only looked the profession up for a plain STRING entry, so every professioned passenger drew as the generic Colonists sprite: three identical grey figures where the original draws three different ones. (b) Profession byte **0 is Expert Farmers**, `@JOBEXPERT` row 0, not "none"; the no-specialty value is 28 (spec/systems/save.md, ColonyRecord `+0x20`), and the fixture agrees — byte 28 appears 47× on braves, artillery and plain colonists while byte 0 appears on only **two** colonist records in the whole save. (c) The manifest is in **CHAIN order**, not record order: `UnitRecord +0x18/+0x1A` are the alias-confirmed links and a ship heads its own manifest — the Galleon (#56) has `chain_prev = 0xFFFF`, `chain_next = 87`, and 87 → 86 → 85, the **reverse** of file order (corroborated on two other ships in the same save). All three were already implied by a comment the code never used: the 2026-08-07 capture analysis named the passengers *Expert Farmer / Master Distiller / Master Gunsmith*, matched **1.0** — professions 0, 9, 15, i.e. records 87, 86, 85. **Measured: the crossing band 406 → 326 px.** | `cport/core/colopy_europe.c`, `cport/render/colopy_europe_render.c`, `port/src/game.js` | closed |
| C4.26 | ~~Profession byte 0 is read as "none" everywhere except the Europe manifest.~~ **RESOLVED for the colony side 2026-08-28 — exactly by the census entry the row asked for.** The DOS expert test is plain **byte equality**: field `@0x9CDC` compares the profession byte with the working COLUMN, indoor `@0xA01A` with the occupation byte — no `>= 1` guard exists in the engine. The proof is the COLONY_SHIP baseline's worked-tile grid: Vlissingen's two prof-0 farmers badge **6 and 5**, which only the expert (+2 food) path produces, and the plaza row draws them with the **farmer figure** (matching the C plaza against DOS dropped COLONY_SHIP ~1,136 px). `isExpert`/`is_expert` are now byte equality in both engines and the colony importer reads prof 0 as Expert Farmers (`SAV_PROFESSION0`). STILL GUARDED (no byte read yet): the unit-record side — `scoutLevel`, `profIs`, and the unit importer's `SAV_PROFESSION` — where relaxing the guard would change combat numbers without a test. | `cport/core/colopy_colony.c` `is_expert`, `cport/render/colopy_colony_render.c` `colonist_figure`, `port/src/game.js` `isExpert`/`SAV_PROFESSION0`; open remainder: `colopy_resolve.c` `prof_is`, `colopy_cmd.c` `scout_level` |
| C4.27 | **Europe's crossing column: the missing black PLATE.** ~326 px. The geometry is right — sweeping the ship anchor over 72–76 against the passenger pitch over 16–18 leaves **(75, 17)**, what the port already has, as the unique minimum — so the residual is the plate the original draws behind every figure and ship. **Routing this column through the now-shared `rm_unit_panel()` was TRIED and MEASURED WORSE, 326 → 361 px, so it was reverted.** The reason is instructive rather than discouraging: the model's class-0 plate y is `y + sh − ph`, and with this screen's sprites that lands on exactly the `+7` the 2026-08-07 capture pinned — the vertical half of the decode is *confirmed* here. Its plate **x** depends on the sprite width the engine reads from the undecoded sheet-header field `es:[bx+0x3E]`, and substituting the port's trimmed frame width puts the plate ~5 px right of the original. Until that field is read, the capture-derived `+5/+7` is the better number and the measurement says so. **RESOLVED (mostly) 2026-08-28 by the C4.1 decode:** the plate is `func_00380C`'s SILHOUETTE layer — black frame-shape at x, sprite at x+2 — so with the capture-pinned x's being the SPRITE positions, the silhouette goes 2 px LEFT of every figure and ship. Measured: **EUROPE 486 → 421 px** (the ship's silhouette alone worth 35); the alternative reading (silhouette at the pinned x, sprite +2) scores 529, and dropping the sack scores 509, so sack + silhouette both stay. ~339 px remain at glyph scale, untriaged. | census `EUROPE`, `cport/render/colopy_europe_render.c` `crossing_cell`, `spec/ui/render_primitives.md` §1b |
| C4.12 | ~~F9 lists the wrong tribes.~~ **FIXED 2026-08-20.** The report's row loop decides membership by the per-(tribe, power) RELATION byte, `TribeRecord + 0x3A + power`: `@0x03784C` calls the shared getter (`0x181F:0xA38` = `func_007F34`) with `(tribe + 4, power)` and draws the row when `al & 0x20`, falling back on `TribeRecord +0x03` bit `0x80`, and only skips when both are clear. The field offset is byte-derived: `func_007F34 @0x007F46` reads `[b + a*0x4E + 0x59D8]` for a native party, and the tribe array base is **`0x5AD6`** (`func_0081E6 @0x0081EA` `add ax, 0x5ad6`, corroborated by `func_00822A @0x008232` reading the tech level at `+0x5AD8` = record+2), so it resolves to record + 0x3A + b; `func_007F62 @0x007F76` is the setter, and for a EUROPEAN party the same accessor reads the PowerRecord war matrix at `-0x77C4` instead. The port listed a tribe when it had a village on an **explored tile** — a different question, wrong twice over: it dropped the three EXTINCT tribes the original lists (Incas, Aztecs, Tupi — contacted, then wiped out, drawn as "<name>: Extinct") and agreed about the Iroquois only by accident, since the original skips them because their relation byte is `0` even though they own **eleven** villages. The importer's blanket `G.tribes.forEach(t => t.met = true)` is gone with it. **Measured: 3,365 → 1,506 px.** Only bit `0x20` is decoded; the rest of the fixture's `0x60/0x62/0x64/0x66` values are FLAGGED, not guessed. | `cport/core/colopy_turn.c`, `cport/render/colopy_report_render.c` `draw_f9`, `port/src/game.js` | closed |
| C4.13 | ~~Report labels are drawn without their shadow.~~ **FIXED 2026-08-20 — and the framework already had it.** The original draws these labels with a black drop shadow at exactly **(+1,0), (0,+1), (+1,+1)**, then the coloured glyph on top. Established by fitting, not by eye: that offset set reproduces the original's black pixels **134/134 and 88/88** on two independent rows with zero missing and zero extra, while the 4- and 8-neighbour outlines over-predict by 48 and 83 on the same row. The JS `FONT.draw` has carried that exact `[[1,0],[0,1],[1,1]]` loop as its optional `shadow` argument since the class was written — F9 simply never passed it. **Measured: 1,506 → 375 px.** Third instance this census of a correct thing already present and unused. | `cport/render/colopy_report_render.c` `r_text_shadow`, `port/src/game.js` `f9Shadow` | closed |
| C4.14 | ~~F9's muskets and horse-herd cells never draw.~~ **FIXED 2026-08-20.** Both were read from a RUNTIME stock map the importer leaves empty. They come from the record: **muskets** = (`TribeRecord +0x07` + one per unit of that tribe whose type is `0x14` Armed Braves or `0x16` Mtd. Warriors — `cmp [bx+0x3146], 0x14 / 0x16` `@0x03768E`/`@0x037695`) **× 50** (`mov ax, 0x32; imul` `@0x0376AB`), drawn only when nonzero (`@0x037787`); **horse herds** = `TribeRecord +0x08` verbatim, drawn only when nonzero (`@0x0377D6`). On the census fixture the Apache carry `+0x07 = 0` with one Armed Brave → "50 Muskets", and `+0x08 = 1` → "1 Horse Herds", which is exactly the original's row. **Measured: 375 → 348 px.** | `cport/render/colopy_report_render.c`, `port/src/game.js` | closed |
| C4.15 | ~~F9's horse-herd column is one pixel off.~~ **FIXED 2026-08-20.** The sub-line is four cells at pitch `0x38` = 56 — `add word ptr [bp-0x68], 0x38` three times, `@0x037728`, `@0x037783`, `@0x0377D2` — so the grid is **40 + 56k**: settlements 40, missions 96, muskets 152, horse herds **208**. The port's 40 and 152 came from a capture and happened to be exact; its 209 did not. **Measured: 348 → 220 px.** | `cport/render/colopy_report_render.c` `F9_HORSE_X`, `port/src/game.js` | closed |
| C4.16 | **The Sioux row is inked in palette 12, not its `@TRIBES` colour.** ~126 px of F9's remaining 220. The original draws that tribe's name and level in index **12 (255,0,0)**; `@TRIBES` gives the Sioux **118 (146,0,0)**, and the port draws 118. Every other tribe on the frame matches `@TRIBES` exactly, so this is one tribe on one save and the cause is **unknown**. Not guessed: the obvious candidates were checked and killed — the relation byte's `0x40` bit is set for the Sioux exactly as it is for the tribes that render correctly, and the Sioux carry the *lowest* tension on the save (1) while the Incas carry the highest (100) and render in their own colour. **SOLVED 2026-08-28 with bytes: it is HARDCODED.** The F9 row painter loads its ink from `[0x848 + power]` and then special-cases power index 0xA — tribe 6, the Sioux — to palette 0xC: `cmp bx, 0xA; mov byte [bp-0x6E], 0xC` `@0x037496`–`@0x03749B`. A literal branch in the engine, not a data value. Both engines mirror it; F9 dropped 220 → 94 px (82 = the pointer). | census `F9`, `cport/render/colopy_report_render.c` `draw_f9`, `port/src/game.js` `drawIndianReport` | closed |
| C4.17 | **F9's MISSIONS cell is not implemented.** The third sub-cell, `x = 96`. Its counting rule is byte-cited (`@0x037650`: count this tribe's settlements whose mission byte's low nibble equals the power) but its singular/plural strings `[0x2DF0]`/`[0x2DF2]` are unresolved, and the census fixture carries no Dutch mission to show them. Flagged rather than invented. | `cport/render/colopy_report_render.c` `draw_f9` |
| C4.18 | **F2 Religious is missing an element, not misplacing one.** 454 px, of which 82 is the DOS mouse pointer (below). The rest is a single black badge at (10,27)–(46,37) carrying the crosses figure and a cross glyph — the original reads "30 ✝" on this save and the port draws nothing there. Supersedes the earlier "a 37 px block differs, port orange vs original black" reading, which described the badge's absence as a colour fault. **CLOSED by C4.23** (the crosses accumulator + stored-threshold seeds): the badge now diffs to zero and F2 sits at the 82 px pointer floor. | census `F2` | closed |
| C4.28 | **The census still covers six screens; the colony screen resisted two entry paths.** `--capture-only ID` now re-grabs one screen without disturbing the other baselines — which matters, because every "N → M px" figure in the notes is quoted against a specific frame and a blanket re-capture silently invalidates all of them. Adding the COLONY screen was attempted and **abandoned rather than faked**: `VIEW ▸ Find Colony ▸ Return` moves the SELECTION to a colony and scrolls to show it but does not open it, and the view it leaves behind is not stable between runs (the second attempt came back centred on a different colony with a different active unit), so a fixed click landed on ocean. Both attempts filed a MAP frame, and both were caught by **looking at the capture** — a map frame filed as a colony baseline would report ~100% divergence and read exactly like a catastrophic port bug. **RESOLVED 2026-08-28 — both new entries are in the registry.** A MAP entry (no navigation at all) came first: the post-load view centres on the first active unit — the frigate at (44, 29), G.units ordinal 6 — and the origin (37, 23) is the sweep's unique minimum (9,794 px; every neighbour ≥ 16,428). The COLONY entry then went in by the MANUAL's keyboard path after the mouse proved a dead end (while a unit awaits orders, a map click only advances the unit cycle — measured twice, including a click directly on a colony icon): `V` (view mode) puts the square cursor on the active unit, `Left` lands on Isabella (43, 29), `Return` opens her display. Fully deterministic. New OPEN findings from the MAP frame, each in the census note: the Ocean/Sea-Lane dither band (~2,500 px), the minimap's tan northern landmass, colony POPULATION NUMBERS + rival colony name labels (the port draws neither), the sidebar unit-panel layout, and Moves 6-vs-5 (a declared harness pin). From the COLONY frame: the declared RNG building placement dominates; the area-view crop offset and two 10-off counters (372/632 vs 362/642) are OPEN. | `tools/screen_census.py` |
| C4.19 | **Every census capture carries the DOSBox mouse pointer**, ~82 px at (158–172, 98–116) — 168 px on F3, where it lands on busier art. It is a floor no port change can close, so `make census` now REPORTS it as its own column rather than subtracting it: a number this tool quietly edited would be worth less than one it explains. (The same policy now covers the water-palette CYCLE: a `cycle` column reports pixels a single global rotation of 120..127 explains, fitted per frame off the port's own index buffer.) The fix is to park the pointer off-screen before `shot()` on the next `--capture` run, which will move every baseline frame and every figure quoted against them. With F2/F7 at exactly 82 px and F5/F9 within 15, the pointer is now the DOMINANT residual on four screens — the re-capture is worth planning. | `tools/screen_census.py` |
| C4.11 | **Europe's crossing columns are laid out per SLOT, not per ORDINAL.** 406 px over rows 140–162. `func_031298` `@0x031298` lays a crossing column out by a running ordinal: `y = 0x92` (146) at step `16 + arg` for ordinals 0–3, `y = 0x89` (137) at step 8 with `x += 2` for 4–11, `y = 0x84` (132) at step 4 with `x += 1` beyond — and `func_031366` `@0x031366` draws **one unit per call and increments that ordinal**, so a ship and its passengers share one sequence. The port's `crossing_cell` uses `CROSS_BANDS[k]` indexed by ship SLOT, switching band at k=1 and k=2, which is only equivalent while a column holds a single ship. The band constants 146/137/132 are right and now byte-cited; the indexing is not. | `cport/render/colopy_europe_render.c` `crossing_cell`, `port/src/game.js` |
| G2 | **No ceiling on the render oracles' palette-delta counts.** `render_map_compare` accepts a pixel when the C index re-resolved through the master matches the JS — exactly what a wrong runtime palette produces. That is how the sandy sea hid. Counts are now low (3 / 104 / 54 / 145); freeze them as a ceiling. | Silent visual regressions |
| G2a | **Scenario coverage is not measured, so a whole screen's pointer layer was dead and the oracle read green.** `colony_clicks` ran wherever the preceding 40-step loop happened to leave the session — the MAP — so every colony click fell through the map handler for months. The two engines agreed about the fall-through, which is all the oracle asks. Fixed 2026-08-17 by opening the colony deliberately first (3 -> 46 colony-screen events), and it found B3.11 immediately. **What is missing is the check**: nothing asserts that a scenario reaches the screens it claims to cover. A per-scenario census of screens and popup kinds visited, compared against a declared expectation, would have caught this the day it started. | A dead scenario reads exactly like a passing one |
| G2b | **`tools/popup_census.py` saw only one of the three ways a key reaches an engine.** It matched quoted literals (`showEvent('STARVE1')`), which is how a popup is POSTED, but not `DATA.events.ARMOPTIONS` property reads or the C's `dat_events_armoptions_body` symbols — which is how a section's ROWS are read. So the four context menus read ABSENT on the day they were wired. Fixed 2026-08-17; the open-row census moved 177/6/13 -> 186/2/8. The general lesson is the tool's own: a key showing absent has at least three causes, and only one of them is "the mechanic is missing". | A green tool that measures the wrong thing |
| G2d | **A comparison that can never pass gets scoped down, and the scoping outlives the cause.** `emrows` was scoped to the two harbour menus on the day it was written, because D12 made the shop menus' strings unmatchable. D12 is fixed and the scoping is gone — but nothing would have reminded anyone to remove it. Same shape as G2a and G2b: the check stays green while quietly covering less than it reads as covering. No tooling for this yet; the habit is to write the *reason* for a scope at the site, so removing the cause surfaces the scope. | Scope notes outlive the bugs that justified them |
| G2c | ~~The scripted ask policy uses ONE GLOBAL counter, so a question either engine skips flips every later answer.~~ **FIXED 2026-08-17.** Counters are now per-prompt in all four places that hold them — the three JS harnesses in `tools/sim_trace.py` and the C's `ask_choice`, which keys on `ev_last_key()` (the core's invariant prompt pattern, skipping the `A0`/`A1` answer markers it emits itself). The first attempt looked broken only because it changed one of the three JS harnesses. `input_compare` now projects `askmap` — the per-prompt ask count — and compares it on the **intersection**: a prompt only one engine raises is B4.6 and is reported (`PEACEMEEK JS only`), while a shared prompt with different counts fails. The BUY click is re-enabled and passes. | closed |
| G2e | **The .ino mock-compile gate modelled the IDE wrong in two places, and lived outside the repo.** A real Arduino IDE build (esp32 core 3.3.11) failed with `variable or field 'bt_notify_cb' declared void` on a sketch this gate had passed. Two wrong assumptions: (a) it hoisted prototypes to just after the **last `#include`**, where the real preprocessor puts them immediately **above the first function definition** — so a prototype naming a type from a later include compiled here and failed there; (b) it only matched definitions whose return type starts at **column 0**, and the sketch was *relying* on that belief, indenting `bt_notify_cb` by one space to keep a BLE type out of the hoisted block. The current toolchain hoists it regardless. Both fixed 2026-08-19; the corrected gate reproduces the user's error byte-for-byte against the old sketch. The gate also moved from a scratch directory into `tools/ino_mock/`, which is why it had drifted unnoticed in the first place. Same shape as G2a/G2b/G2d: green because it was not looking. | A gate that models the wrong compiler |
| G3 | ~~`cport/PORT_LEDGER.md` is stale enough to mislead.~~ **FIXED 2026-08-19, and it was worse than "stale".** The status column was a **hard-coded literal** written fresh by `gen_port_ledger.py` on every run, while the file's own header called it "maintained by hand as porting proceeds". It could not change: 279 rows read `todo`, and **113 of them named functions the C demonstrably ports**. A column that cannot change is worse than a stale one — it reads as evidence. Status is now **derived** from the C sources' own `game.js:NNNN` citations (310 ported / 192 unevidenced / 19 excluded / 6 n.a.), with `unevidenced` explicitly meaning "no citation found", NOT "unported". Pinned by `tools/stale_check.py` (`G3`). | closed |
| G2f | **Prose claims of absence had no way to notice they had become false** — the shape behind G2a/G2b/G2d/G2e, G3, and both 2026-08-19 corrections (B4.4, B4.6). `tools/stale_check.py` now turns the ledger's load-bearing claims into **probes that run**, wired into `make test` as the `records` target: a claim whose code no longer matches fails the build and names the row. Its own honest limits are in its docstring — a probe tests a proxy, not behaviour; unlisted claims are unchecked (`--list` shows coverage); and a probe can rot too, which it did on first run (B3.2/B3.3 matched the very comments documenting the gaps, fixed by stripping comments before matching). | closed |
| G4 | **`docs/COMPLETION_PLAN.md` records no phase as complete** though most of Phases 0-2 landed. | Contradicts MESSAGE_STATUS |
| G5 | Asset loader functions/offsets are TBD in `extract_pal.py`, `extract_visuals.py`, `extract_mp.py`. | Phase D |
| G6 | Round-trip/encode status TBD for DAT (only CYCLE.DAT), COL (header only), MOV (script only), PART. | `tools/verify_assets.py` |
| G7 | `STATUS.md` records visual asset extraction as NOT RUNNABLE HERE and warns of "a green gate that nobody re-runs". | Asset gates not continuously verified |
| G8 | `.MP` format has 3 open `TODO_VERIFY` items. | `formats/MP_FORMAT.md` |
| G9 | Elecrow reference files must be refreshed by hand; no pinned commit hash. | `cport/p4/PROVENANCE.md` |
| G10 | Elecrow's own repo ZIP fails to extract for users — hence the three vendored libraries. | Upstream packaging |

---

## Part H — Explicitly out of scope for this build

Recorded so nothing looks forgotten. Each is a separate track.

1. **The CLAUDE.md UI documentation mandate.** `docs/UI_AUDIT_TRACKER.md`'s own
   2026-07-28 correction: **~300 UI surfaces have zero spec** (Colonizopedia 166,
   map editor 23, options/music/debug 26, European diplomacy ~45, 12 woodcuts,
   tutorial overlays, multiplayer, Combat Analysis) and **every "DONE" row should
   be treated as UNVERIFIED**. No `spec/ui/*.md` passes the "redraw from spec
   alone" test.
2. **MAPEDIT.EXE rewrite** — 0 of 210 functions hand-decoded; `REWRITE_PLAN.md`
   awaits go-ahead.
3. **`viceroy_source` full reconstruction** — ~1,241 functions detected, ~47
   (3.8%) BYTE_VERIFIED; per-system formulas and 8 data tables still
   RECONSTRUCTED.
4. **OPENING.EXE / CLOSING.EXE cinematics** — separate DOS programs, including
   their audio.
5. **PC-speaker and MT-32 driver variants.**
6. **Multiplayer.**

---

## Ledgers this supersedes or corrects

- `cport/PORT_LEDGER.md` — stale (G3); use this file.
- `docs/COMPLETION_PLAN.md` — phase status unrecorded (G4).
- `docs/POPUP_AUDIT_2026-08-08.md` — still authoritative for per-row detail;
  Part B summarises it.
- `docs/MESSAGE_STATUS.md` — accurate about *text*, and easy to misread as
  "feature complete". Part B.1/B.2 is the mechanic-side counterpart.
- `docs/UI_AUDIT_TRACKER.md` — belongs to the Part H track, not this one.

## Counts

`tools/churn_metric.py` (2026-08-17, after the audio merge): **581 open TBDs** repo-wide, 252 RULINGS
entries, 82,834 doc lines across 164 files. Engine-side: `port/src/game.js`
carries 138 flagged / 23 TBD / 60 "unread"; `cport/core|game|render` carries 73
flagged / 13 TBD. The difference between 581 and this ledger's ~350 rows is
documentation TBDs belonging to Part H.
