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
close. It is not. `docs/MESSAGE_STATUS.md` reports **0 missing / 0 unwired**
message keys, and that reads as "the game is text-complete" — but the message
text being wired is not the same as the *mechanic behind it* existing. The popup
audit still carries **14 HIGH and 74 MEDIUM** rows where the mechanic is absent.

Concretely, none of these work today: colonists starving, food-shortage warnings,
population growth from surplus food, natives burning a colony, the per-unit
orders menu, the per-ship orders menu, the Docks prerequisite for fishing,
boycott relief, and rival AI colonies growing or building anything at all.

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
| A6 | ~~**Stale doc:** `cport/p4/README.md` still says typed digits need serial and lists the on-screen keyboard as an open follow-up.~~ **RESOLVED 2026-08-17** — both corrected; the numeric keypad and alpha keyboard shipped 2026-08 and the README now says so. | `cport/p4/README.md` | closed |

---

## Part B — Missing features: the game is incomplete without these

### B.1 The 14 HIGH popup rows (mechanic absent, not just text)

Source: `docs/POPUP_AUDIT_2026-08-08.md`, rows not marked RESOLVED.

| Key | What is missing |
|---|---|
| `@INDIANBURNCOLONY` / `2` | Natives burning a colony is entirely absent |
| `@FOODLOW` | Low-food warning never fires |
| `@FOOD1` | Depletion warning never posted |
| `@STARVE1` | Popup, winter band and the multi-colonist removal loop all absent |
| `@WAREHOUSEFULL` | Capacity rule at unload (the confirm gate landed 2026-08-17; the rule did not) |
| `@NEEDTOOLS` | Construction stalls with zero feedback |
| `@NEWCOLONIST` | Fires as a popup and the population cap (32, `@0x009432`) is enforced by `colonist_add`; the **200-food threshold is still tier R (manual), not byte-located** — flagged in both engines. The "25/50 evidence mis-attributed to horses" claim was itself wrong and is **withdrawn 2026-08-17**: that pair belongs to horse breeding, byte-proved (RULINGS 2026-08-17). The real per-turn food-growth store is unlocated. |
| `@REBELUP50` | Announcement and the rebel-power-designation state write both absent |
| `@TRAINPROFESSION` | STRING0/STRING1 transposed in every graduation popup; option gating absent |
| `@NODOCKS` | Docks prerequisite and refusal popup both absent |
| `@UNITOPTIONS` | The entire per-unit orders menu and its five actions |
| `@SHIPOPTIONS` | The colony/harbour ship orders menu and all six row actions |
| `@KINGRECRUIT` (TRAIN) | Chooser drops the byte-verified body/smallfont; key misappropriated for the mercenary event (real key `@MERCENARIES`) |
| `@KISSUP` / `@SOMEBOYCOTT` | Boycott back-tax lift absent, so **boycotts are permanent** unless Fugger appears |
| REF growth cadence | `func_03E162`: accrual timing opposite the bytes; tax->REF-fund loop unwired; ratio ladder approximated |

### B.2 The 74 MEDIUM popup rows, by family

Full row detail in `docs/POPUP_AUDIT_2026-08-08.md`; grouped here so nothing is lost.

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
| B3.1 | **The colony ships-in-port dock panel is never drawn.** `drawColonyPanel` paints only Buildings/Garrison/Production, so a goods drop onto the dock is armed but a **no-op**. | `port/src/game.js:11806` (mode-7 targets {5,8}) |
| B3.2 | **F5 Economic's second page** (`@MISC 91` "(Building Upkeep)" / `92` "TOTAL UPKEEP") is not drawn; only the European Trade view exists. How the view switches is TBD. | `port/src/game.js:9914` |
| B3.3 | **F9's multi-page paginator `func_039E98` is not wired** — an 8th contacted tribe is simply never shown. | `port/src/game.js:10123` |
| B3.4 | **Trade routes have no per-stop good-list editor.** The engine lets you name what to load/unload at each stop; this build uses a fixed default. | `port/src/game.js:7816` |
| B3.5 | **Roads as a terrain band (§6.8) are not implemented** — the `.MP` loader discards the feature plane; player roads come from `drawImprovements`. | `port/src/game.js:1387` |
| B3.6 | **Rival AI colony development is entirely absent** — no growth, construction or unit production. Rivals field only what their ships landed with. `func_04CC50` (strategic planner) and `func_04E2D6` (per-unit pipeline) are not ported. | `port/src/game.js:7402,7444` |
| B3.7 | Rival colony management of our records is not modelled: an empty colony taken by a rival is **burned rather than captured**; the burn-vs-capture selector is unread. | `port/src/game.js:7673`, `cport/core/colopy_rivals.c:494` |
| B3.8 | An unimplemented report prints "Not in this build." | `port/src/game.js:9645` |
| B3.9 | **Reports F8/F9 unreachable by pointer in DOS** — the board deliberately diverges to make them tappable. Decide whether to keep the divergence. | `.ino:1029-1036` |
| B3.10 | **Boot cinematic chain** (King audience -> ten LEVN tutorial cards -> `@VICEROY` scroll) needs pak assets not yet carried; the C boot starts at page-1 dismissal. | `cport/game/colopy_input.c:256` |

### B.4 C-engine-only gaps (the board runs the C engine)

| # | Item | Cite |
|---|---|---|
| B4.1 | ~~Map zoom 1/2 unported.~~ **NOT A GAP** — see A5; the claim came from a stale comment. | — |
| B4.2 | **Tutorial bindings (`tutOnce`) not ported** — TUTORIAL* keys filtered from the event comparison. | `cport/core/colopy_turn.c:11-13` |
| B4.3 | **Village trade haggle unported** (slice 4c; harness remaps to Cancel). `RAIDSTORES` village-side banking has no CR home. | `cport/core/colopy_village.c:14-16,509` |
| B4.4 | **Unit build pipeline**: the completion path handles buildings only; the importer nulls `bip >= 42`. | `cport/core/colopy_turn.c:17` |
| B4.5 | Several move targets are **explicit no-ops**: ships at sea, rival tiles, villages, sea lane, rumour entry. | `cport/core/colopy_cmd.c:4-5,500-506,617-619` |
| B4.6 | `askEvent` is stubbed in the C trace, so **every meeting topic ends at its first ask** — treaties, tribute, war declarations and withdrawals never execute. The WAR matrix starts empty so `rivalTurn`'s whole WAR branch is unreachable. | `cport/core/colopy_rivals.c:16-22` |
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
| C1.1 | **Combat §14.3 step 8 — a further doubling gated on difficulty — is NOT implemented.** The condition is unknown, so applying it would be a guess. | `port/src/game.js:6890` |
| C1.2 | **`func_005DF0` rumour gate not reproduced** — the port has no owner/feature plane, so **rumours appear on tiles the DOS game suppresses**. | `port/src/game.js:8815` |
| C1.3 | **Go To moves one square per turn** whatever the unit's allowance — in both engines. Makes a ship's run to the sea lane slower than the ship. | `cport/README.md`, RULINGS 2026-08-17 |
| C1.4 | **Rush-buy amount formula**: 26$/hammer fits census3 exactly but not the older `81_colony_build_prompt` frame — **a second term (tax? difficulty?) is still open**. | `port/src/game.js:3285` |
| C1.5 | **Settlement placement** (`func_065D26`, up to 84 settlements from the map seed) is not in the evidence — villages scattered by a deterministic hash. | `port/src/game.js:5079` |
| C1.6 | **Which skill a village teaches** is derived from site coordinates, not any mapped store. | `port/src/game.js:6078` |
| C1.7 | **Village rows gated on the tribe POSTURE byte `+0x5236` cannot be reproduced** (traced, semantics undecoded) — those rows are offered unconditionally. | `port/src/game.js:6569` |
| C1.8 | **Village trade haggle arithmetic**: `func_049600`'s tail `0x0496BA..0x04A37A` not disassembled — the budget spend, the +50%/-25% counter and the halfway-move-per-round are stand-ins. | `port/src/game.js:6616-6798` |
| C1.9 | **Native demand triggers and amounts largely untraced**: `@INDIANGOLD` `@INDIANWAGONS` `@INDIANCITY` `@INDIANROAD` fired off tension, priced off demand. | `port/src/game.js:5525-5592` |
| C1.10 | **Raid payloads unmapped** — what WREAK / GOLD / BURN / SHIP each take is the port's own. | `port/src/game.js:5704` |
| C1.11 | **The Crown's European war cycle is a flagged reconstruction** — only `@KINGWAR`/`@KINGNAVACT` pretexts are byte-cited; every rate, length and amount is the port's parameter. | `port/src/game.js:9053` |
| C1.12 | **Cross accrual and bell rates are flagged placeholders** — the per-turn church/cathedral production site is unidentified. | `port/src/game.js:10236`, `:7736` |
| C1.13 | **No prime-resource model at all**; the centre-tile `+2` for types 1/2/9 is TBD. | `port/src/game.js:2742` |
| C1.14 | **Mine depletion uses a port-runtime bit**; the engine's resource plane is unread. | `port/src/game.js:2653` |
| C1.15 | `PowerRecord +0x02` (rival independence progress) is real engine state the port does not model — a random walk stands in. | `port/src/game.js:7474` |
| C1.16 | `PowerRecord +0xFC` per-good trade totals are preserved but **the market does not read them**. | `cport/core/colopy_records.h:133-140` |
| C1.17 | **AI-AI war grievance drivers unread and omitted**; war START drivers omitted. | `port/src/game.js:8587`, `:7467` |
| C1.18 | **Imported units are never Fortified** — the importer never copies the record's orders byte. | `cport/core/colopy_resolve.c:9-11` |
| C1.19 | `headingScore`: halving predicates `0x902`/`0x8D0`, the `+4` flag pair, the frontier gate `0x984` and the era/resource/colony-site terms are **unread and omitted**. | `port/src/game.js:5918` |
| C1.20 | The goto executor's own path scoring (`func_04E2D6` step 5) is unported — a straight-line one-tile step stands in. | `port/src/game.js:5927` |

### C.2 Rules and thresholds that are readings (~60)

Colony: building->job binding inferred from names (`:2548`); easy-difficulty
+2/+1 field bonus capture-fitted (`:2664`); Scout in the village-teachable list
uncited (`:2679`); school-guard timing (`:2838`); 199-cap / 200-food-per-colonist
are the manual's, not byte-located (`:2919`); Custom-House gate on over-100
disposal open (`:2930`); `@CARGOREADY1/2` and `@SPOIL1-4` selectors unread
(`:2958`, `:2987`); x32 hammer scale for buildable units inferred from six ship
costs (`:3059`); `@SIEGE` radius 1, no blockade (`:3091`); pre-winter turn
(`:3128`); herd-growth cap (`:3168`); `@DEPLETION` 1/50 (`:3181`);
`@MERCANTILISM` rate (`:3269`); Custom House picker format (`:3292`);
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
`@REFIT` repair timer (`:3369`).

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
| D6 | **BLE mouse end-to-end untested**; needs a core with hosted BT for the P4 *and* C6 firmware exposing BT (Elecrow ship it for Wi-Fi 6 and publish no BT example). Only BLE can ever work — the C6 has no Classic radio. | `.ino:186-214` |
| D7 | **BLE HID report parsing is a guess for non-boot mice** — the Report Map is not parsed; reports hex-dump to serial so a real device can be characterised. | `.ino:210-214` |
| D8 | **The whole I2S audio path is unverified on hardware.** | `.ino:381-412` |
| D9 | ~~**Audio pin provenance does not resolve** — the block cites "Elecrow Lesson12, PROVENANCE.md" but `elecrow_ref/` has no Lesson12.~~ **RESOLVED 2026-08-17** — the audio merge brought `cport/p4/elecrow_ref/lesson12_audio.ino` and `cport/p4/elecrow_ref/lesson12_board_config.h` into the tree with both `PROVENANCE.md` rows. All five values in the sketch match the reference byte for byte: LRCLK 21, BCLK 22, SDATA 23, power gate GPIO 30 with LOW = enabled. | `cport/p4/PROVENANCE.md`, `cport/p4/colopy_p4.ino:452-457` | closed |
| D10 | **No USB host keyboard path** — Elecrow's only USB example is device-mode HID; the P4 Arduino core has no host-keyboard driver. | `cport/p4/README.md` |
| D11 | **Long-press -> right-click is not implemented** — every tap is a left-click. | `cport/p4/README.md` |

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

**F3. Then that branch's own open list:** the human A/B listen pass (needs
speakers); tune `0x34` hit the 240 s capture cap and likely loops; SFX preemption
modelled not decoded; pending queue depth 1 vs the original's 8-deep ring;
`au_cmd(1)` stop semantics approximated; driver commands other than 1/8 unported;
`[0x828]` rotation override unexposed; scheduler PRNG a stand-in; cue rows tagged
`[inferred]`; **European first-contact fanfare not wired**; **all combat SFX ids
TBD**; the Sound Test and Pick-Music/Sound-Options screens not in cport's input
layer; play far-call thunk identity untraced; PC-speaker and MT-32 variants not
reproduced; 25.9 MB is SD-only on both boards.

**F4. On the fallback COLDIG cue path** (used when no `COLAUDIO.PAK` is on the card): 24 of the 40 `lcall 0x181F:0x4C0` play sites
stay silent because their event is TBD (four compute the id at runtime); only 12
cues are wired. `sfx_play()` blocks for the sample's length — one voice, no
mixing.

---

## Part G — Tooling and oracle gaps

| # | Item | Why it matters |
|---|---|---|
| G1 | **No worst-case stack-path budget.** `-Wframe-larger-than=4096` is per-function; the build-colony crash was *depth* — a 1,216-byte frame under a 3,216-byte dispatcher. The gate that would catch it sums frames along `in_key_inner -> run_menu_row -> cmd_* -> advance -> end_turn`. Nothing computes that. | Third board crash from stack depth |
| G2 | **No ceiling on the render oracles' palette-delta counts.** `render_map_compare` accepts a pixel when the C index re-resolved through the master matches the JS — exactly what a wrong runtime palette produces. That is how the sandy sea hid. Counts are now low (3 / 104 / 54 / 145); freeze them as a ceiling. | Silent visual regressions |
| G3 | **`cport/PORT_LEDGER.md` is stale enough to mislead** — all 10 MIXED hoist rows and dozens of SIM rows still read `todo` though shipped. | Not usable as an open-item list |
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
