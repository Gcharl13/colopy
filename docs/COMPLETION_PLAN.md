# PLAN — Finish the Colonization port

> **STATUS (2026-09-02; replaces the 2026-08-17 note, which said only that
> "this document records no phase as complete" — REMAINING_WORK.md G4).**
> Every phase below is DONE, in the plan's own terms, and this note says
> where in the tree each deliverable demonstrably is. It is a census of
> presence, not a re-verification of trigger fidelity — that debt is Part C
> of `docs/REMAINING_WORK.md`, which is also where everything the plan did
> not cover lives. Treat the phase lists below as historical.
>
> - **Phase 0 — DONE.** `port/tools/render_diff.py` exists (item 1).
>   `port/tools/message_status.py` reports the DONE-VIA-DATA and N/A
>   categories item 2 asked for — `docs/MESSAGE_STATUS.md`: 411 DONE, 29
>   DONE-VIA-DATA, 34 N/A, 1 BLOCKED, 0 MISSING, 0 UNWIRED (499 keys).
>   `docs/POPUP_AUDIT_2026-08-08.md` carries 27 RESOLVED→ruling pointers
>   (item 3).
> - **Phase 1 — DONE.** MESSAGE_STATUS: 0 MISSING / 0 UNWIRED. Spot-checked
>   as referenced in `port/src/game.js`: PRICEUP/PRICEDOWN, SCHOOL1, NOPLOW,
>   SPOIL1, EFFICIENT, TIMECHANGE, LANDFALL2, CONTINENTAL, EVASIVE,
>   LOSTCITY4, TRADENAME.
> - **Phase 2 — DONE.** The bounded numeric dialog (HOWMUCH1–5, 14 sites in
>   game.js; the C mirrors it as `UI.dlg`), BUYME0/1, KISSUP,
>   NOMOREWAGONS/NOMOREWAREHOUSE, VANISH, REFIT, CUSTOM, INDIANBEGFOOD, the
>   PISS0–5 bands (emitted as `` `PISS${cause}` ``), SOONRETIRING0/1, and the
>   BUILD1–10 cards (MESSAGE_STATUS: DONE-VIA-DATA through `DATA.cards`,
>   `drawCards`/`cardText`; game.js:1234).
> - **Phase 3 — DONE.** Hall of Fame (game.js ~10263, HALLFAME.DAT record
>   semantics; capture at `tools/dosbox_harness/shots/hof_01_table.png`);
>   tutorial (`G.tutMask`, `tutOnce`, 21 sites; TUTORIAL1–19 DONE); King
>   audience and war cycle (KINGRAISE, KINGWAR, MERCANTILISM, PURCHASETAX,
>   SEIZURE/CONFISCATE); War of Independence completion (REBELUP, LOSING1,
>   WARN1, INVASION, INTERVENE, WINNING, EUROPENOTAVAIL); meeting sub-branches
>   (PIRACY, SNEAK, GIVECASH, APOSTATES, HEATHEN); the news bus (EUROPEWIN,
>   BURNED2, CAPTURED2, LOOTFOREIGN, VIOLATE); depletion (DEPLETION,
>   DEFOREST); native land claim (INDIANLAND/BOW/TREATY/BRIBE). One honest
>   caveat: **KINGBLESS is an EXE orphan** — no emit site exists in VICEROY
>   (MESSAGE_STATUS.md:483) — so it is N/A, not wired.
> - **Phase 4 — DONE per `STATUS.md`** (2026-08-07 n–z14: the DOSBox capture
>   batch — Hall of Fame, K-threshold = 10000, F4/F5/F6/F9, ICONS figures,
>   Europe pitches — and the disassembly windows func_0734F8, func_020F50,
>   func_073474, func_057F4E, func_049600's tail, func_05BE84, func_056C3E).
>   The `[0x540A]` woodcut mask and the REF-strength import are in game.js.
> - **Phase 5 — DONE per `STATUS.md` (2026-08-08)**: the ledger re-verified,
>   `shots.py` + `render_diff.py` 15/15, and the scripted end-to-end playtest
>   at `port/tools/test_flow.py:1652`. One caveat the tree cannot confirm: the
>   `port-v1.0` tag STATUS cites exists neither in this clone nor on `origin`
>   (`git ls-remote --tags` returns nothing), so the release step's artifact
>   is unverified.
>
> Still true from the 2026-08-17 note: wiring a message key is not the same
> as implementing the mechanic behind it; the popup audit's per-row trigger
> and substitution verdicts remain unverified and are Part C work.


## Context

The port is playable start-to-endgame (229/229 behavioural checks, save/load,
AI, the full popup framework, haggle + meeting flows), but it is not
*finished*: 235 of the engine's 499 GAME.TXT messages are missing, 64 more are
bundled but never fire, the Hall of Fame menu row is a no-op, the tutorial
system doesn't exist, and ~30 flagged stand-ins approximate engine behaviour
where the bytes are unread. The user asked for the full plan to completion.

**Scope decisions (user, 2026-08-07):** sound/music **OUT** (standing NO-GO in
`notes/rulings/AUDIO_SPIKE.md` — the .COL "sound files" are MZ driver
executables; real reproduction is a separate multi-session RE milestone).
Tutorial **IN**. Byte-closure **of player-visible stand-ins only**; cosmetic
approximations (upscale dither texture, etc.) may stay flagged.

**Definition of done:**
1. Every reachable GAME.TXT message fires at its byte-cited (or
   flagged-documented) trigger, in the framework format. The ~26 structurally
   N/A keys (DOS save/load UI, multiplayer/hot-seat, engine assertion strings,
   debug locator) are re-tagged N/A, not implemented.
2. All five main-menu rows work (Hall of Fame implemented).
3. Tutorial bitmask + 19 triggers live.
4. Player-visible stand-ins closed from the EXE/captures; the rest documented.
5. `docs/MESSAGE_STATUS.md` reads DONE = everything except N/A; suite green;
   a render-diff oracle gates the screens against the DOS captures.

Two exploration reports (2026-08-07, in-session) provide the complete cluster
map with file:line anchors; key facts are inlined below so this plan is
self-sufficient. Effort totals ≈ **8–12 working sessions**. No LARGE new
system is required anywhere — the biggest items are MEDIUM.

---

## Phase 0 — Infrastructure (½ session, do first)

1. **`port/tools/render_diff.py`** (new, ~60 lines, Pillow): load a
   `port/_shots/*.png` + `docs/screens/*.png` pair, count differing pixels,
   emit a diff-mask PNG, fail over a per-screen threshold. This converts every
   "measured against a live frame" claim into a standing regression and gates
   Phases 3–4. `port/tools/shots.py` (44 screens) already produces the port
   side at raw 320×200.
2. **Fix `port/tools/message_status.py`**: recognise `DATA.text.*` /
   `DATA.viceroy` / `DATA.diplotext` consumption (10 current false negatives:
   BEGINMENU, DIFFICULTY, LEADERNAME, VICEROY, VICEROY2, TRADENAME/SELECT/
   START/TYPE/DELETE) and add an **N/A** category (~26 keys: SAVEGAME family,
   LOADGAME family, MAPTOLOAD, AMERICA, CCLIM/CCONT/CLAND/CTEMP, MULTI*,
   NATION0A–3B → verify against `drawBriefing` first, COLONYFLAG/UNITFLAG
   assertion strings, FINDCITY/NOCITY/COLONYUNIT).
3. **Reconcile `docs/POPUP_AUDIT_2026-08-08.md`**: mark rows resolved by
   rulings 2026-08-07 i–m with a RESOLVED→ruling pointer so it reads as a live
   queue.

## Phase 1 — Wire-only sweep (~95 keys, 1–2 sessions)

Mechanic and branch already exist; each key is a `showEvent`/`askEvent` at an
existing site. Work in clusters, regression checks per cluster:

- **Market:** `stepPrice` (game.js:3464) captures price before its while
  loops, emits PRICEUP/PRICEDOWN on delta; SOMEBOYCOTT replaces the ad-hoc
  refusal at `sellFromShip` (3840). *(spec/systems/market.md §9.2–9.4)*
- **Schooling (9 keys):** `runSchool` (2317) branches silently today —
  SCHOOL1/COLLEGE2/UNIV3 level gates, NEEDCOLLEGE/NEEDUNIVERSITY,
  NOTEACHER, TEACHCONVERT, TRAINCRIMINAL/TRAININDENTURED on the tier-climb
  branch. *(spec/systems/training.md — all byte-cited)*
- **Pioneer/site guards (~19 keys):** predicates in front of existing actions
  — NOPLOW/NOROAD/ONLYCOL/ONLYPIO in `improveOrder`; TOOMOUNTAIN/TOONEAR/
  TOONEARBUILD/SEACOLONY/NOPORT + TOOMANYCOLONIES/TOOMANYUNITS in
  `buildColony` (1791, currently returns silently); KEEPSTOCKADE on abandon;
  LANDFIRST/SHIPLAKE/CANNOTATTACK/DISBANDSHIP movement guards;
  TUTNOLUMBER/TUTNOSPACES site-quality scans (difficulty ≤1 gate @0x22763).
- **Warehouse/colony notices:** SPOIL1–4 variant pick from `warehouseLevel` ×
  qty-known in `autoExport` (2383); WAREHOUSEFULL; CARGOREADY0–2; FOOD1/FOOD2
  + STARVE2 winter split on `G.season` in `colonyTurn` (2455).
- **Misc wire-only:** EFFICIENT/INEFFICIENT latch on `toryPenalty` crossing 0
  (copy `solAnnounce`'s latch pattern); LOSTCITY4 ask before the burial roll
  (6932) and LOSTCITY0 recruit picker before the fountain outcome; EVASIVE in
  `navalAttack`, CONTINENTAL in `tryPromote`, LANDFALL2 in `landfall`;
  TIMECHANGE at the 1600 season switch in `endTurn`; swap the hardcoded
  trade-route strings for the bundled TRADENAME/SELECT/START/TYPE/DELETE
  bodies.

## Phase 2 — Small mechanics (~55 keys, 2–3 sessions)

- **Bounded numeric-entry dialog** (extend `openDialog`, 871): unlocks
  HOWMUCH1–5 and cleans quantity UX across trade. Highest-leverage single
  widget.
- **Rush-buy:** BUYME0/1 — cost-to-complete from remaining hammers/tools
  priced off `askPrice`; colony hotkey + 2-row confirm (widths 160,
  @default=1 per spec/ui/context_dialogs.md:297).
- **Boycott back-tax:** per-good arrears accumulator since the Tea Party;
  click on boycotted market column → KISSUP pay / KISSSORRY short.
- **Converter input-outage latches:** the 7 per-good "run out of X" keys when
  a manned converter's input hits 0 (`colonyProduce`, 2237).
- **Build guards:** NOMOREWAGONS (wagons ≤ colonies), NOMOREWAREHOUSE (one
  expansion), ALREADYHAVE in `buildOptions` (2438).
- **Opening cinematic:** BUILD1–10 timed title cards (@width=310 @y=30) over
  the woodcut screen before the King audience; reuse `woodcutOnce` idiom.
  *(spec/ui/cinematics.md, docs/CINEMATIC_TIMING_AUDIT.md)*
- **VANISH:** last-colonist starvation removes the colony (`colonyTurn`
  currently guards length>1).
- **REFIT:** repair-in-port timer clearing `u.damaged` (set at 4603/5467,
  never cleared).
- **CUSTOM:** Custom House export picker over `autoExport`'s existing gate.
- **Natives, friendly half:** INDIANBEGFOOD/GIVEFOOD/GIVESTUFF/COMMENT/COME/
  BRING low-tension events on existing `askEvent`+`adjustTension` plumbing;
  INDIANFOREST/FOREST2 clear-cut objection cloned from `roadObjection`
  (4447); PISS0–5 tension-band latches (copy `solAnnounce`).
- **Endgame dates:** 1800 auto-retirement + 1850 surrender + SCORED lock +
  SOONRETIRING0/1 warnings (`spec/systems/scoring.md:118,124`); RETIRING/
  RETIRING2 + EXPLOITS on the retire path.

## Phase 3 — Medium mechanics (3–4 sessions)

- **Hall of Fame** (menu row 4, `commitMenu` 9773): DOSBox capture first —
  hand-author `HALLFAME.DAT` (5 × 42-byte records, name +0x00, score i16
  +0x26; `spec/systems/save.md` §6.5) with real names, boot `VICEROY -g`,
  capture the populated table for the column x positions (sole open TBD).
  Then: localStorage roster with the 42-byte semantics, insertion sort on
  +0x26, screen per `spec/ui/menus.md` §12 (WOODPANL/WOODPAN2, FONTINTR,
  trophy 0x21/0x24/0x25 — bundle those sprites + SCORE plates in
  `build_assets.py`), HoF write on retirement/endgame.
- **Tutorial system:** `G.tutSeen` 16-bit mask seeded 0x0E (@0x755EB),
  `tutOnce(bit, key, subs)` clone of `woodcutOnce`; bundle TUTORIAL1–19;
  wire the six attributed sites (unit-move → 1, market/king → 5, colony →
  6, movement event → 7, Europe/docks → 4/12); disassemble `func_020F50`
  0x20FF0..0x215D0 (~1.5 KB) to attribute TUTORIAL3/8–11/13–15/19's guards.
  *(spec/systems/tutorial.md — fully BYTE_VERIFIED, zero residual)*
- **King audience + war cycle:** player-initiated audience (KINGBLESS/KINGNO/
  KINGLOWER/KINGNOTHING/KINGRAISE/KINGFUND/KINGLAUGH); purchase-tax hooks
  PURCHASETAX/MERCANTILISM in `euroMenuCommit`/`advanceConstruction`; KINGBUY
  on `growREF` (spec/systems/ref_growth.md:112 — KINGBUY *is* the REF-growth
  surface); European-war cycle driving KINGWAR/KINGVICTORY/KINGMERCY/
  KINGNEWWAR/KINGFRIGATE; SEIZURE/CONFISCATE on wartime shipping.
- **War of Independence completion:** national SoL mirror of `solAnnounce` →
  REBELUP/REBELUP50/REBELDOWN; the three loss conditions (all-ports /
  all-colonies / 90%-population — `runWar` 7121 only checks zero colonies)
  → LOSING1–3 + WARN1/WARN3 counters; SIEGE adjacency rule
  (spec/systems/diplomacy.md:111); INVASION/INTERVENE cards; WINNING;
  screen lockouts EUROPENOTAVAIL/EUROPENOTLEAVE/FOREIGNNOTAVAIL.
- **Meeting sub-branches:** privateer attribution — `REL.PRIVATEER 0x80` is
  declared and dead; the writer is byte-verified (`cmp [bx+0x3146],0x10`
  @0x3F092 → `or …,0x80` @0x3F0A1, spec/systems/diplomacy.md:76) — set it in
  `resolveAttack`/`navalAttack`, census → PIRACY; force-adjacency census
  (shared with SIEGE) → SIEGES; colony-encroachment metric → WANTSTUFF/RID;
  USA suffix variants on `WOI_DECLARED` (pattern exists at `runMeeting`);
  WARMEEK/WARMANLY refusal escalation; wire HAVETREATY (attack-treaty-partner
  guard) + CANCELPEACE + SNEAK + GIVECASH (AI-gift node); APOSTATES/HEATHEN
  third-party demands (note SIEGESUSA's rows are swapped in the data —
  handler acts on row 2 regardless, latent bug 1).
- **News bulletin bus:** one shared "third-party outcome → visibility →
  bulletin" emitter in `rivalTurn`/native turn serves ~15 keys (EUROPEWIN/
  LOSE, INDIANWIN*/LOSE, BURNED2/3, CAPTURED2/3, LOOTFOREIGN, VIOLATE) —
  they share one template shape.
- **Depletion plane:** wire the resource plane through the `.MP` loader (the
  SAV importer already reads it, game.js:8106); DEPLETION roll on mined
  tiles, DEFOREST on the existing CLEARCUT path.
- **Native land-claim:** INDIANLAND/BOW/TREATY/BRIBE on `buildColony` inside
  tribal territory.

## Phase 4 — Byte-closure of player-visible stand-ins (2–3 sessions)

Cheap tier first (already byte-cited, port work only):
- Popup **120-tick auto-dismiss** (func_004A80 @0x4ADD; ~2 s) — timed
  messages become a class.
- **`func_073474`** disasm (small): the in-game ink slot mapping — confirms
  or corrects the 68/149 reading globally.
- **SAV block indices** for REF strength (`0x53DA..0x53E0` + PowerRecord
  +0x22 royal fund) and the `[0x540A]` woodcut mask → importer restores both
  (one read of `func_0734F8`'s block order).
- **K-threshold**: DOSBox capture with a save edited to a 6072..12999 value.

Deep tier (two function windows cover most of it):
- **`func_057F4E`** (dispatcher, already partially mapped): the MEEK/MANLY
  tone predicate, PEACE-vs-OLDPEACE selection, topic priority, the
  withdraw/threat sub-branch selection, and the smite price.
- **`func_049600` tail** (0x0496BA..0x04A37A, undisassembled): haggle inner
  arithmetic (counter cost, village movement), the gift tension credit,
  @TRADE0's %STRING0, @TRADEWHICH's trigger.
- **`func_04B308`**: Speak-With-Chief sub-mode selector, beads amount,
  reveal radius, taboo odds. **`func_05BE84`**: RAIDWREAK payload / RAIDGOLD
  amount. **`func_056C3E`**: INDIANWELCOME treaty effect. GIVECASH refusal's
  matrix write.
- **Capture batch** (one DOSBox session): multi-ship Europe panels (band
  placement + green/yellow pairing), F4 roster tail, F5 second view, F6
  caption band, F9 paginator/portrait, blocked-cell frame, HoF columns
  (Phase 3 dependency — do first).

Deliberately left flagged (cosmetic, per scope): `func_005296` upscale
dither, building-field speckle generator, Europe panel exact band layout if
the capture is inconclusive, AI-AI war grievance drivers (the `ai.md`
evidence ceiling).

## Phase 5 — Final audit and release (1 session)

1. Regenerate `docs/MESSAGE_STATUS.md` — target: MISSING 0, UNWIRED 0
   (excluding the N/A set); re-run the popup audit spot checks.
2. Full `shots.py` + `render_diff.py` pass against every DOS capture;
   fix or document each over-threshold screen.
3. A scripted end-to-end playtest (found colony → trade → war → declare →
   win/lose → Hall of Fame) via Playwright, added to the suite.
4. Final STATUS.md/RULINGS refresh, technical-reference addendum, tag,
   artifact republish.

## Working conventions (unchanged from this session)

- Every batch: byte-cite or flag; ruling appended to
  `notes/rulings/RULINGS.md`; suite must be green (`timeout 420 python3
  port/tools/test_flow.py`); rebuild `python3 port/tools/bundle.py`; commit +
  push `claude/repo-audit-map-editor-rt0v5l`; republish the artifact
  (https://claude.ai/code/artifact/2a706a40-87b4-493d-a190-ab0ef112624d).
- Progress metric: the `message_status.py` counts + suite size, quoted in
  each ruling.

## Verification

- Per-cluster: new regression checks in `port/tools/test_flow.py` (as done
  for haggle/meeting/woodcuts), suite green twice.
- Per-screen: `render_diff.py` against `docs/screens/` with thresholds.
- Phase 4 items: each closure verified against a DOSBox capture or the
  disassembled bytes before the flag is removed from RULINGS.
- Done-check: `python3 port/tools/message_status.py` reports zero
  MISSING/UNWIRED outside N/A; all five menu rows functional; tutorial
  fires on a fresh Discoverer game.
