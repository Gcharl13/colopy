# Live DOSBox UI check — 2026-08-05

The real game, booted in this container under DOSBox 0.74-3 on a headless Xvfb
display, driven with xdotool, and captured through DOSBox's own Ctrl-F5
framebuffer dump (the emulated 320×200, no X compositing, no scaling, no aspect
correction — the same geometry `port/_shots/*.png` use).

Captures: `docs/screens/live_2026-08-05/`. Harness: `tools/dosbox_harness/`.

## 0. Getting it to run — two things worth recording

**The game will not start without an emulated Sound Blaster.** With
`sbtype=none` the opening runs, sets mode 13h, and renders a **black screen
forever** — no error, no exit. `CONFIG.COL`'s 20 bytes select SB at port
`0x220` / IRQ 7 (`20 02 | 20 00 | 07 00 | …`), and the boot path blocks on the
card. `sbtype=sb16` + `nosound=true` + `SDL_AUDIODRIVER=dummy` runs it silently.
This cost the first hour and is the single most useful fact for anyone
reproducing this.

**Clicks need the press and release in different emulated frames.** A single
`xdotool click` puts both edges in one tick and the DOS `INT 33h` polling loop
never sees the button down — motion tracks, nothing else responds. `mousedown`,
sleep, `mouseup`. A window manager also has to be running (bare Xvfb gives SDL
no input focus).

`VICEROY -g` starts straight at the main menu, skipping `OPENING.EXE`'s long
map-pan cinematic.

## 1. What was checked

| screen | live capture | verdict |
|---|---|---|
| Main menu | `01_main_menu.png` | matches |
| Map-source prompt | `02_map_source_prompt.png` | **not in the port** |
| Difficulty picker | `03_difficulty.png` | layout matches, **one real difference** (§2) |
| Nation picker | `04_nation.png` | matches |
| Name entry | `05_name_entry.png` | matches |
| Nation briefing | `06_briefing_england.png` | matches |
| Map view | `07`, `08`, `09` | matches; **sidebar unit labels differ** (§3) |
| REPORTS / ORDERS / pedia / CHEAT pulldowns | `10`–`13` | match |
| F2 Religious Advisor | `21_report_F2_religious.png` | real reference captured |
| F3 Continental Congress | `22_report_F3_congress.png` | real reference captured |
| F4 Labor Advisor | `20_report_F4_labor.png` | real reference captured |
| Europe | `30_europe.png` | close match |
| Colonizopedia terrain index | `40_pedia_terrain_index.png` | **port is wrong** (§4) |
| `@SETVIEW`, `@CREATE` cheat dialogs | `50`, `51` | confirm `spec/ui/debug_screens.md` |
| `@LANDFALL` | `60_landfall_dialog.png` | **port omits the speaker portrait** (§5) |
| Arawak first contact | `61_arawak_first_contact.png` | real reference captured |

Side-by-side sheets: `_compare_boot_sequence.png`, `_compare_in_game.png`.

**The colony screen was reached on the third run** — `80_colony_screen.png`,
see §6b. §7 below records the two attempts that failed and why.

## 2. Difficulty picker — both label lines belong in the middle of the cell

> **Corrected after the first write-up.** I originally read this as the port
> drawing a plaque in the wrong *cell* and losing a portrait. That was wrong:
> the two screenshots were at different selections (live on Discoverer, the port
> on its default Conquistador), so the caption appeared in different cells for
> an innocent reason. Re-rendering the port at Discoverer showed all five
> portraits present and the caption on the correct cell. The real difference is
> smaller and purely positional.

Both render the same 3×2 grid with the title text in cell 0 and the five levels
in cells 1–5, and the per-level outline ink matches (`{0x0A, 9, 0x0E, 0x0D,
0x0C}` — Discoverer green, Explorer blue, confirmed live by clicking between
them).

The difference: the **nation** picker splits its two lines to the top and bottom
of the cell (`ENGLAND:` at the top edge, `Immigration` at the bottom), and the
port applied that same layout to the **difficulty** picker. The original stacks
the difficulty picker's two lines **together in the middle**, 8px apart:

| | live | port (before) |
|---|---|---|
| line 1 `DISCOVERER:` | glyph row **45** = `cell.y + 38` | `cell.y + 2` |
| line 2 `Easiest` | glyph row **53** = `cell.y + 46` | `cell.y + h - 9` |
| both inks | **0x0A** `(4,182,16)`, the row's own colour | `254` and `0xFC` |

Both lines are horizontally centred on the cell centre (measured 161.0 and
161.5 against a cell centre of 161.5). The nation picker's own colours were also
slightly off — live has **both** `ENGLAND:` and `Immigration` at `(247,0,0)` =
`@COUNTRY.color` 12, where the port drew the name line in `254`.

Fixed; the port's green rows now land on exactly 45–49 and 53–57, matching the
live frame row for row.

## 3. Map sidebar — cargo units are labelled by equipment, not by type

Real, carried in the caravel on turn 1:

```
Veteran      Sentry
100 Tools    Sentry
```

Port:

```
Soldiers     Sentry
Pioneers     Sentry
```

The original labels a carried unit by its **veteran status / equipment load**
("Veteran", "100 Tools"), not by the unit-type name. The port used `@UNIT`
names. `"Veteran"` is `@MISC` 65 (first of Veteran/Seasoned/Learned) and
`"Tools"` is `@CARGO` 14, so the tools line is `<count> <cargo name>`.

The **order** is also fixed: live lists Veteran above 100 Tools, i.e. the
manifest is Soldiers-then-Pioneers, where the port had Pioneers first.

Fixed for the two units of the starting force, which is all the capture proves.
What a *non*-veteran Soldiers or another carried type shows is **TBD** and falls
back to the type name rather than being guessed at. Still open: the carried
unit's **icon + nation-plate composition** differs (the original puts the sprite
flush left with a small plate beside it; the port draws a larger plate with the
sprite offset). Not fixed — I would be inventing offsets.

Everything else in the sidebar — season+year, `Gold:`, `Tax:%`, the
active unit's moves and location, the `(Ocean)`/`Sea Lane` terrain line — lines
up.

## 4. Colonizopedia terrain index — one column, 21 entries, alphabetical

The live index is a **single column of 21 alphabetically-sorted names**:

> Arctic, Boreal Forest, Broadleaf Forest, Conifer Forest, Desert, Grassland,
> Hills, Marsh, Mixed Forest, Mountains, Ocean, Plains, Prairie, Rain Forest,
> Savannah, Scrub Forest, Sea Lane, Swamp, Tropical Forest, Tundra,
> Wetland Forest

The port builds its terrain index from `@UNFORESTED`+`@FORESTED`+`@OTHER`+
`@OTHER_NAMES` = 26 names against 29 `PEDIA.TXT` TERRAIN articles, shows ids
26–28 by number, and lays the index out in **three columns**.

**Solved.** The list is exactly

```
@UNFORESTED (8)  +  @FORESTED (8) each suffixed with @OTHER_NAMES[0]  +  @OTHER (5)
```

= **21**, sorted alphabetically — reconstructed from the shipped tables and
compared name-for-name against the capture: **exact match, all 21**.

Two errors fell out of it:

- **`@OTHER_NAMES` is a suffix/label table, not five more terrain entries.** Its
  first row is the literal string `"Forest"`, which is what turns `@FORESTED`'s
  `Boreal` into `Boreal Forest`; the rest are `River`, `Major River`,
  `Minor River`, `Unexplored`. The port had been appending all five as index
  rows and then padding to 29 with invented `Terrain 26/27/28` entries.
- **The 29-vs-21 gap is not a skip list.** `PEDIA.TXT` keys TERRAIN articles by
  **engine terrain id**, and the ids the index shows are not contiguous:
  `@UNFORESTED` is 0–7, `@FORESTED` 8–15, `@OTHER` 24–28. Ids **16–23 are the
  auto-forest variants** (`CLAUDE.md` hard rule 3) — they have articles but no
  index row. 21 rows over 29 articles, with nothing dropped arbitrarily.

The single column is not special either: the index fills **column-major, 22 rows
per column**, so a 21-row category never spills into column 2. The three-column
layout in `spec/ui/colonizopedia.md` is right; it only shows when a category is
long enough.

The live index also carries **no category sub-heading and no keyboard hint** —
the only chrome is `(Exit)` at the top right (`@MISC` 110) and `(More)` when the
list pages (`@MISC` 109). Both of the port's extra lines were its own invention.
The masthead is **white**, not the HUD green the rest of the browser uses.

All of this is fixed in the port and asserted in `test_flow.py`.

## 5. `@LANDFALL` — the port omits the speaker portrait

The real dialog draws a **large character portrait filling the right half of the
screen** behind/beside the text box. The port renders the text box alone.
`spec/ui/popups.md` already documents a speaker channel (`func_06BE92/BF12/BF3C`)
and a special-sprite slot with `func_06BF66`'s sprite x/y math marked TBD — this
capture is what that TBD looks like on screen, and the same applies to the
Arawak first-contact popup (`61`), which shows the chief portrait on the right.

## 6. Live confirmations of byte-derived findings

- **Alt-W-I-N** adds the `CHEAT` menu to the bar, exactly as
  `spec/ui/debug_screens.md` says (`xor [0x5383],0x20` @`0x023F9A`).
- The `@SETVIEW` dialog lists English/French/Spanish/Dutch/Complete/No-Special
  in that order, as documented.
- The `@CREATE` spawner lists the full documented unit family.
- Spawning a unit onto a native village raises the shipped debug assertion
  **"DANGER, WILL ROBINSON! Warning: Illegal entry into village"**, and then the
  error logger: `Error "VillageEntrySave" in module "<Map>" data: 46 30` with
  memory-check / DOS-error / stack-use lines. That is the error-exit path the
  tracker identifies at `0x181F:0x772` — seen live, in its own screen.
- Starting gold **1000** at Discoverer matches the difficulty table.
- The `Original America / Map Editor` prompt fires before difficulty select.

## 6a. Advisor reports — rebuilt (2026-08-05, second pass)

The first pass captured F2/F3/F4 as references but did not compare them against
the port. Doing so found the port's reports were wrong in kind, not degree:

- **There is no advisor portrait.** The port blitted an `MSS0`–`MSS5` sprite
  into the corner of every report. The shared draw chain
  (`spec/ui/advisor_reports.md` §2.1) is plate → title → footer rule → OK, and
  the painted scene in `REPORT<N>.PIK` *is* the advisor. The portrait was
  invented. Removed from all ten.
- **The bodies are tables and sprite rows, not wrapped paragraphs.** The port
  drew each report as a text stack.

Rebuilt against the captures, with the spec's byte cites confirmed by pixels:

| element | value | source |
|---|---|---|
| title ink | `0x90` = (255,255,190), glyph top y=5, centred | measured, matches spec |
| subtitle | `@MISC` 56 "(Click on item to zoom)" at y=12 | measured |
| row label ink | `0x92` = (255,243,93) | measured = spec |
| value ink | `0x61` = (247,243,199) | measured = spec |
| rule ink | `0x77` = (134,0,0) | spec |

**F4 Labor** is a three-column occupation matrix: column bases x = **2 / 107 /
212**, name at base+12, count centred at base+39 eight pixels below it, first
row y=**26**, row pitch **18**, icon at (base+2, y−2). The icon is **ICONS frame
81 + job index** — found by matching the live pixels against every frame in the
sheet: Farmer→81, Sugar Planter→82, Fisherman (job 8)→89, all at score 1.000.
Column split 8/9/10 follows `@JOB`'s own grouping (the eight field jobs that
have yield columns, then the indoor trades, then the classes).

**F2 Religious** is one crosses gauge. The segments are **spaced, not packed**:
six filled crosses (ICONS 56 = engine 0x39) at x = 10, 43, 76, 110, 143, 177 —
x-start `0x0A` exactly as the spec says, pitch ≈33.

### Residuals, explicitly not guessed

- **The gauge slot count.** Pitch 33 over a 300-wide span implies 9 slots, but a
  single frame cannot separate "9 slots" from some other derivation, so `9` is a
  measured constant in the code, flagged as such.
- **F4's occupation tail.** The live grid fills 27 rows; `@JOB` has 28 entries
  plus a "Free Colonists" row. The port's column 3 order therefore diverges from
  the capture (it shows Veteran Dragoons, the live one does not). The grid stops
  when it runs out of entries rather than inventing any.
- **F3 Continental Congress** has the right elements — session line, bell gauge
  (sprite `0x3F`), rebel/tory strip (`0x7C`/`0x7D`), REF quartet, FF name grid at
  columns {4,82,160,238} — but its **vertical rhythm is wrong**: the sections
  overlap where the original spaces them out. The per-section y advance is the
  font-height flow accumulator the spec marks **R**, and I have one frame, so it
  is left visibly imperfect rather than fudged to match a single screenshot.
- ~~**F5–F10 are not rebuilt.**~~ **Done** — all ten now draw a table from the
  spec's byte-cited geometry:

  | report | geometry used |
  |---|---|
  | F5 Economic | headers y=25; 16 commodity rows x=2 y=33 pitch 8 with goods sprites; bid x=140/150, ask x=240/250. Captions `@MISC` 59/140/203/204. |
  | F6 Colony | four captions in boxes (2,80)/(82,80)/(162,80)/(242,76) — `@MISC` 206–209, the four consecutive strings that exist for exactly this row; rows pitch 17, 9/page, name ink 0x92 at base+0x17. |
  | F7 Naval | the fully-decoded 4-column ruled table: headers `@MISC` 61–64, first row y=0x2A=42, pitch 0x14=20, 7/page, ship name at x=26, Location box x=162 w=80, Destination box x=242 w=76. |
  | F8 Foreign | gate on the declaration flag; strength labels `@MISC` 95–100 ink 0x91 at x=2, four power columns, per-row rule ink 0x77. |
  | F9 Indian | y-start 0x18=24, columns x=16 → +72 → +20, cell text in the `@COLORS` "basic" green (85,150,52) the spec resolves from `[0x830]`. |
  | F10 Score | `@MISC` 115/116/117/120/121 with FONTTINY labels and FONTINTR figures. |

### Second capture run — F8 was wrong, and only half the reports are verified

Going back for live references (captures `70`–`72`) found that building F5–F10
from the spec's label lists was not good enough:

- **F8 is not a strength table.** I built the six `@MISC` 95–100 rows
  (Colonies/Population/Average Colony/Military Power/Naval Power/Merchant
  Marine) the spec lists. The live report is **four per-power blocks**, and the
  geometry is exact: separator rule `y = 10 + 45i`, power header
  `"<Leader>'s <Nationality>:"` at x=2 `y = 16 + 45i`, then `Rebels: N` at x=2
  and `Tories: N` at x=80 on `y = 27 + 45i`. Rebuilt; it now matches. The labels
  are `@MISC` **86/87** (the plurals), not 69/70. Whether the strength rows
  appear in the same body once colonies exist is **unverified** — the capture is
  from turn 1.
- **F6 draws no caption strip.** The four captions are the report's **view
  modes**; the live frame carries the active one ("Military Garrisons") in the
  *subtitle* line and nothing else. My header row was wrong.

**Verified against a live frame: F2, F3 (structure), F4, F6 (frame), F8.**
**Still unverified: F5, F7, F9, F10** — they are built from the spec's
byte-cited columns and render as plausible tables, but I have no capture of
them, and F8 is the proof that a plausible table built from the spec's label
list can still be the wrong screen. Two capture attempts failed: enabling cheat
mode inserts a "View Whose Report?" power picker in front of every report, and
without cheats the run needs colonies and ships that turn 1 does not have.

Also still open: **F3's vertical rhythm** overlaps, and F10's
`SCORE<panel>.SS` band plate is not bundled.

## 6b. Third capture run — the colony screen, and F10

A full no-cheat playthrough (sail west → @LANDHO → @LANDFALL → step ashore →
accept the Iroquois treaty → Build Colony) reached **Jamestown, Spring 1495**.

- **`80_colony_screen.png` — the colony screen is captured at last.** This is the
  screen §7 recorded as an honest gap through two earlier attempts. It shows the
  building scene, the 5×5 tile panel with worker markers, the field strip and the
  goods bar. Not yet diffed against the port — that is the next unit of work, and
  it now has a reference to work against.
- **`73_report_F10_score.png` — F10 is a green breakdown, not a figure table.**
  Title y=5, subtitle y=13 centred
  (`"<Difficulty> <Leader> of the <Nationality>: <Season> <Year>"`), then score
  components in **green at x=16, pitch 28**, each followed by a row of the
  counted sprites, with Gold and Total Score at the bottom. Measured green rows
  24 / 52 / 150. Rebuilt.
- **`14_menu_reports_measured.png`** — the REPORTS dropdown, measured properly at
  last: **F1=17, F2=33, F3=42, F4=50, F5=59, F6=74, F7=82, F8=91, F9=99,
  F10=114**. Every earlier capture run had been guessing these, which is why
  several landed on the wrong report.

**F5, F7 and F9 are still uncaptured.** All three attempts were intercepted by
event popups that fire on the turns the run passes through — an Iroquois raid, a
Founding Father election, an immigration notice. They are not hard, just noisy;
the fix is to dismiss-and-retry per report rather than assume a clean frame.

Live-verified now: **F2, F3 (structure), F4, F6 (frame), F8, F10**.
Still unverified: **F5, F7, F9**.

## 7. Not reached — the colony screen

Three attempts. The colony screen needs a landed colonist to execute Build
Colony, and the automation kept losing the active unit: creating a unit through
the cheat menu does not make it current, `b` acts on whatever the sidebar has
selected, and one attempt crashed the game via the village-entry assertion
above. The run that did land units (`61`) put them on a tile the sidebar still
reported as `(Ocean)`.

This is the screen the port has the most detailed reconstruction of
(RNG building placement, `func_025D34`, §12) and it is exactly the one still
unverified against a live frame. It needs a longer scripted playthrough or a
save file, not another few clicks.

## 8. What did NOT differ

Worth stating plainly, because it is the bulk of the check: the **main menu,
nation picker, name entry, briefing, map view, Europe screen, and all four
pulldown menus** match the port closely in layout, colour and text. The Europe
screen in particular — dock buildings, sky, the RECRUIT/PURCHASE/TRAIN button
stack, the three status panels, the bottom goods bar and the Exit button — is a
close match.

---

## 9. Second pass, 2026-08-06 — F5, F7 and F9 captured

### 9.0 What went wrong the first time, and the fix

The retry harness from §6b reported all ten reports `ok (attempt 0)` and
captured **ten copies of the Europe screen**. Its discriminator was the absence
of the map's green menu bar at the top left — and the Europe screen has no menu
bar either, so every frame passed. The run had drifted into Europe rather than
founding a colony, and nothing in the check could tell.

Two harness rules came out of this:

* **Test positively, not negatively.** Every advisor report draws its centred
  title in ink `0x90` = (255,255,190) inside the top ten rows, and nothing else
  in the game does. Counting those pixels is the check.
* **Never press Escape.** On the map, Escape quits to DOS. The old retry loop
  pressed it after each failure and eventually killed the process mid-run.
  Reports close on their OK button at (300,190); popups close with a click.

The replay also **saves the game** (`COLONY05.SAV`, England/Discoverer,
Jamestown founded 1495), so the state is reproducible without replaying the
whole opening. And the shipped `COLONY00.SAV` — "Discoverer Willem De Ruyter of
the Dutch, Autumn 1653" — turns out to be a real late-game save: seven tribes
contacted, seven ships, four colonies, 271,473 gold. It is the best fixture in
the box for any report that needs data, and the whole set is captured in
`docs/screens/live_1653_save/`.

### 9.1 The three reports

| | live frame | what the port had wrong |
|---|---|---|
| **F5 Economic** | `74_report_F5_economic.png` | drew a commodity icon that is not there and indented the name behind it; two value columns instead of four; left-aligned values instead of right-aligned; no rules |
| **F7 Naval** | `75_report_F7_naval.png` | no grid at all (the spec says there is only a footer rule; there are eight rules and three separators); Ship and Cargo headers centred on the field x's instead of their columns |
| **F9 Indian** | `76_report_F9_indian.png` | a status grid at pitch 18 in one fixed green; the real screen is a per-tribe block at pitch 21 with a portrait, and each tribe's name is in **its own colour** |

Geometry, inks and the corrections to `spec/ui/advisor_reports.md` §4 are
recorded in `notes/rulings/RULINGS.md` 2026-08-06.

### 9.2 Shared chrome — four things wrong on every report

Found by diffing the port's render against the live frame rather than by reading
the spec, and all four were wrong on screens previously called verified:

1. the subtitle line is ink `0x91`, not the title's `0x90`;
2. report text has **no drop shadow** — the port was drawing the whole string
   three more times in black, which is what made its titles look heavy;
3. centring is on the **ink** width (`advance − 1`). Seven independent strings
   agree and none matches `advance / 2`;
4. the OK button is a **hollow** dark-red box, not a filled one with a cream
   border.

### 9.3 Where it stands

Port-vs-live pixel diff over the whole 320×200 frame, after the fixes:

| report | before | after | what is left |
|---|---|---|---|
| F7 | 1305 | **75** | the nation plate's colour index and orders letter, and the ship's map position |
| F5 | 3608 | **299** | the bid/ask columns — the two games have different market rolls |
| F9 | 3838 | **576** | the port's shot has a different tribe contacted |

Nothing structural is left in any of the three. **Live-verified now: F2, F3
(structure), F4, F5, F6 (frame), F7, F8, F9, F10** — every advisor report.

### 9.4 Still open

* ICONS **113..117** are five near-identical native portraits; the 1653 frame
  uses three of them across seven rows with no derivable rule. The port draws
  116. **Unresolved.**
* F9 pagination (`func_039E98`) is not wired up.
* The port has no native first-contact flag; "has explored a tile holding one of
  that tribe's settlements" stands in for it.
* F5's second view — `@MISC` 91/92 "(Building Upkeep)" / "TOTAL UPKEEP" — was
  never reached, so how the view is switched is **TBD**.
* The colony screen (§7) is captured at last — `79_colony_screen_fresh.png` and
  the 1653 set — but **not yet diffed** against the port.

---

## 10. The colony screen, 2026-08-06

### 10.1 How to reach it

Not by clicking the colony on the map — with a unit active every map click is a
move order, and the click just sails the ship. F6's rows do not zoom either;
clicking one pages the report. What works is the **`Zoom to colony.` option on
a colony event popup** (`@MISC` 36), e.g. the food-shortage warning. The 1653
save throws one on the first turn advance.

Two screens fell out of the same run, both captured for the first time:
`docs/screens/live_1653_save/combat_analysis.png` (the modifier stack:
Attack Bonus +50%, Stockade +100%, Fortified +50%) and the colony
food-shortage popup.

### 10.2 What the diff found

The frame is `docs/screens/live_1653_save/colony_curacao.png` — Curacao,
population 8, five buildings, eight worked tiles.

**Header, stockpile bar, panel boxes and the black separators all match.**
Word-for-word: the port's title lays out `<name>, <Season>, <Year>, Gold: <n>$`
with identical word widths, and the whole string is centred, so the only offset
between the two frames is the width of the gold figure.

**The production panel was wrong in kind, not degree.** The port drew a text
list; the real panel is three rows of *count badge + overlapping sprite strip*,
with a red cancel sprite laid over a run to mark consumption — the same verb
F3 uses for its REF rows. Rebuilt; geometry and sprite identifications are in
the code comment and the commit.

### 10.3 Still to do on this screen

* The **tile panel** (top right) draws a colonist sprite and a yield badge in
  each worked cell, with a green selection box on the active one. The port draws
  the terrain and a single white centre-tile rectangle.
* The **colonist row** in the bottom-left panel is one sprite per colonist; the
  port draws only the unassigned ones.
* The **SoL band** carries *two* figures — "6% (1)" at the left and "94% (8)"
  right of it, with the crown between — where the port draws one.
* The strip **pitch** is unresolved: furs and ore fit 4, hammers and the cancel
  marks fit 6, and one capture cannot tell a per-band rule from a global one.
* Building placement in the scene panel is RNG-driven (`func_025D34`) and stays
  TBD, as it has been since 2026-06-24.

## 10.4 The four open items, closed from the EXE (2026-08-06)

All four went the same way: the answer was in the disassembly, and the live frame
was the check on it rather than the source of it. Details and citations are in
`spec/ui/colony_screen.md` §3.2 / §3.3 / §3.6 / §3.6a; the short version:

**The pitch was never a constant.** `func_002D74 @0x002D74` and the row flush
`func_003104 @0x003104` both compute it: a row's icons are fitted into a fixed
span, `pitch = avail / Σ(count−1)`, then clamped per sprite to `min(w+1, pitch)`.
Feeding the Curacao frame's own counts through that solve reproduces **every**
icon position in all three production rows — 223 / 269 / 291 at pitch 5 on the
top row, 225 / 260 / 290 at pitch 4 on the middle, 243 / 287 at pitch 6 on the
bottom. So "4 on one row and 6 on another" was the formula working, not two
different rules. That solve is now `countRowLayout()` in the port, with the
positions above asserted in `port/tools/test_flow.py`.

**The tile panel is a 3×3, byte-exact.** `func_0264A8` loops 5×5 but skips all
four borders, so cells land at `x = 200+24·col`, `y = 8+24·row` for col/row 1..3.
Per cell: the unit at (x+4, y+4), a yield strip across a 24px span, and — when a
tile yields nothing — the good's icon centred in 16px with EXE sprite 0x41 over
it. Two selection boxes exist, green `0x0A` on the selected colonist's tile and
white `0x0F` on a separate cursor cell; the live frame has the green one at
x 224..247, y 32..55 and **no white box at all**, which is what retired the
port's "white rectangle on the centre tile" (that had been measured off the
1024×768 rescale of the 1504 capture, not off a 320×200 frame).

**The colonist row's axes were transposed in the spec.** `[bp-0x60]`, which §3.3
called the x-origin walking left from 143, is the **y** — the row runs left to
right from x=2 at y=142. The green box's own geometry proves it: measured at
x 1..10, y 143..158, which only solves if `[bp-0x5c]=2` is x and `[bp-0x60]=142`
is y. ICONS frame 100 then template-matches the second colonist at exactly
x=11 — the position the adaptive pack predicts for a gap of 1. The row also
draws the **garrison**, not just colonists: the count is `colony+0x1F` plus
`[0x8D72]`, with the 4px break spent after the last colonist.

**The SoL band is two figures with two end-caps.** EXE sprite 0x7C (the flag) at
(2,132) with the SoL figure beside it, EXE 0x7D (the crown) with its right edge
pinned to x=117 and the Tory figure right-aligned against it. The headcount in
each pair is `round(pct·pop/100)`, remainder to the other side.

**One thing found on the way.** The red mark is not a "cancel" sprite the panel
owns — it is EXE 0x38, the *empty segment* of the shared strip verb, blitted over
an icon whose index is past the filled count. A second flag (bit 14) swaps the
filled icons for EXE 0x3A instead and moves the badge. That is what the plaza
food row does: bundle 57 template-matches at x=14 and bundle 22 from x=18 on, so
the first four icons of a 16-food run are the alternate sprite — and the scene
panel's centre cell in the same frame reads 4, the food the centre tile makes
with nobody on it.

**Still open on this screen**, unchanged: building placement is RNG
(`func_025D34`); the lumber surplus split against `[0x8E14]`; and the report
gauges in `drawReligiousReport`/`drawCongressReport` still use their own measured
helper rather than this one — their alternating 33/34 pitch needs the
flag-bit-0 fractional path in `func_002EE4 @0x002FBA` read first.

## 11. Colony building placement — simulated, 2026-08-06

The one thing on this screen that had been TBD since June because it is "RNG".
It is RNG, but the RNG is a plain LCG seeded from a value the port can hold, so
it simulates exactly. Full citations in `spec/ui/colony_screen.md` §3.7 and
`notes/rulings/RULINGS.md` 2026-08-06b.

**The chain.** `rand`/`srand` are the Microsoft C runtime's (file `0x0103D4` /
`0x0103C2`): `state = state*214013 + 2531011`, result `(state >> 16) & 0x7FFF`.
`random_int(lo,hi)` is `lo + ((rand()*(hi−lo+1)) >> 15)`. The seed is
`(colony_y << 8) + colony_x + dword[0x8D80]`, of which only the low word survives
— the srand wrapper masks it with `and ah,0x7f`, so the whole layout of a colony
comes out of 15 bits.

`dword[0x8D80]` is the BIOS clock read once at startup, which is the part worth
knowing: it is **per-session, not per-save**. The same colony in the same save
file lays out differently between two launches of the original game. The port
draws it once per game and keeps it in `G`, so it survives save/load — a
deliberate difference, and the friendlier one.

**Verified against the real thing.** `tools/colony_seed_probe.py` reads the
placement tables straight out of a running DOSBox (`/proc/<pid>/mem`, DGROUP
anchored on the section-name table). Booting COLONY00.SAV and opening two
colonies gave session base 1410965 and:

    Jamestown (50,51)  shuffle 6 5 4 0 3 2 1 7 10 8 9 12 11 13 14
                       plots   24 39 32 27 21 · · 3 17 36 13 · 9 2 7
    Curacao   (21,30)  shuffle 4 1 3 6 5 2 0 10 7 9 8 12 11 13 14
                       plots   39 · 32 21 · 27 24 · 35 15 · · 9 0 6

The simulation reproduces all four arrays exactly. They are now regression
assertions in `port/tools/test_flow.py`, so the port is checked against the real
engine's output rather than against itself.

**Two things the RAM read corrected.** The plot **category** the placement reads
at `[0x8F87 + id*12]` is the @BUILDING **`size` column** — identical for all 42
rows. That column was never a building size. And phase D indexes the shuffle
array by *slot* where phase C wrote it by *plot*; the engine reads the same
permutation both ways round, and reproducing that quirk is the only way to get
the same layout.

**And one the render corrected.** Feeding the port Curacao's own seed, position
and building set and template-matching every plot against the live frame puts
BUILDING **frame = def_id** in the lab bundle, not `def_id + 1` — the same EXE−1
offset the ICONS sheet carries. Empty plots likewise draw 44/43/42 for the RAM
table's 45/44/43. Side by side, every building and every tree cluster now lands
on the same pixel; what differs is only what the live frame has drawn *over* the
field — the animated flag, two colonists, the "Town Hal" tooltip and the cursor.
New capture: `docs/screens/live_1653_save/colony_curacao_1656.png`.

Still TBD here: the `0xF`/`0x11` garrison frame cases (`@0x026E05`) need a
garrison count the port does not track, and the ground speckle's noise source is
still unidentified.

## 12. Reading the panels out of RAM, 2026-08-06

Having a probe that reads DGROUP out of a running game changes what "TBD" means
on this screen, so I extended `tools/colony_seed_probe.py` to dump the panel
state too and re-opened Curacao — the same colony `colony_curacao.png` was taken
from. Full citations in `spec/ui/colony_screen.md` §3.2/§3.3/§3.6 and
`notes/rulings/RULINGS.md` 2026-08-06c. Three of them were things the port had
wrong.

**The colonist in a worked tile is not drawn by the call I thought.** The tile
panel's `0x2BC` at `(x+4, y+4)` belongs to flag bit 7 — a *map unit* standing on
the tile — and every inner cell of the live frame reads flags `0` while six of
them plainly show a colonist. The colonist is the cell's **last** step: the
colony enumerator `0xA74` feeding `0x24A`. Pushed anchor `(x+12, y+6)`, and ICONS
frame 100 matches at **(x+14, y+6)** at score 0 — y exact, x two out, so `0x24A`
adds an inset of its own. Fixed to the measured position, mechanism left open.

**The centre tile draws two strips, and that settled `[0xA895]`.** The flag byte
is `0x10` around the whole outer ring, `0x00` on the inner 3×3, and `0x08` on the
centre — so bit 3 *is* the colony's own tile, and its two strips are what it
yields with nobody on it: `[0xA891]` = 4 food and `[0xA893]` = furs ×
`[0xA894]` = 3. That is the "4" and "3" visible in the middle cell. It also
resolves the guess I flagged last pass: the plaza food row's `[0xA895]` is 4 and
the centre cell's food strip is 4, two independent paths to the same number.

Following that through, the centre tile really does produce a second good — those
3 furs show up in `[0x8DC8]` as the colony's whole fur output — which the port's
production model did not do at all. Added; *which* good is the best-yielding
non-food column, which fits this frame but is inferred, and says so.

**The `0xF`/`0x11` frame cases are not garrison counts.** They are
building-presence queries: no Warehouse → frame `0x2F`; Warehouse *and* Stable →
`0x30`; Warehouse without Stable keeps its own frame. Warehouse, Warehouse
Expansion and Stable share group 5 — one plot — so it draws a combined sprite for
whichever pair is standing. Curacao holds the Warehouse and no Stable, keeps the
plain frame, and that is what the template match found. Wired in; the "needs a
garrison count the port does not track" note from last pass was wrong.

**Production rows, against the real tables.** Row 0 skips a good with
`produced == 0` even when it was consumed — Curacao eats 6 cotton, produces none,
and shows no cotton entry. Row 1's source table is `byte[0x2A2+i]`, the chain map
plus a slot where Horses source *themselves*, which is the all-marked 13px run at
the head of that row. The amount comes from `[0x8E5A]`, which is **not** the
consumed-raw table — 6 cotton eaten for 6 cloth reads 0 there and draws unmarked
— so the port reproduces the one case the evidence covers and leaves the rest
alone rather than guessing what fills that array. All three rows are regression
assertions now, built from Curacao's own numbers.

**And one thing that stays shut for now.** `0x236`'s flag-bit-0 path is a
Bresenham remainder distributor — `acc += (count−1)·pitch` per icon, add a pixel
whenever it crosses `span − w` — which is where the F2 crosses row's alternating
33/34 comes from. No colony call site sets that flag, so the colony strips are
flat-pitch; the report gauges are the only consumers, and folding them onto this
verb is the next thing rather than this one.

## 13. The shared strip gauge, folded onto one verb (2026-08-06)

The thread I left open last section. `func_002EE4`'s geometry helper turns out to
be doing considerably more than "count icons at a fixed pitch", and reading it to
the end made the F2 crosses row fall into place exactly.

**It takes two counts, not one.** `dx` is the number of **slots** the row is laid
out for — the denominator, crosses *needed* — and `bx` is how many icons actually
get **drawn**. A report gauge is therefore a progress bar built out of icons: the
row grows toward a fixed layout rather than rescaling into it. On top of that the
helper computes a `leftover` against the span, optionally **centres** the row by
half of it, and can right-shift the counts until a long row fits. With flag bit 0
— which both report call sites set and no colony call site does — each icon's
advance is the pitch plus a Bresenham share of that leftover.

Put together, it reproduces the live F2 row exactly: 6 crosses at
x = 10, 43, 76, 110, 143, 177, **at 9 slots and at no other slot count**.
Rendering the port at that state and diffing against the capture gives **0
differing pixels** across the whole crosses band.

Two things in the port were wrong and are now right. The `GAUGE_SLOTS = 9`
constant had been measured off this very frame and flagged as a guess — it got
the right answer for the wrong reason, because 9 was that session's cross
threshold, not a property of the widget. And the count badges are gated on
`[0x336]`, which the reports run clear and the colony panels set: the port had
been drawing a badge over the first cross *and* an invented "6 / 9" caption
underneath, neither of which is in the original.

The colony strips and the report gauges are now the same function, which is what
the primitives index said they should be all along.

**Not verified:** the F3 bell row. Both shipped F3 captures sit at 0 bells — no
bell sprite anywhere in either — so its geometry is ported by analogy with F2 and
is unchecked. Getting a frame with bells on it is the cheap next step now that
the harness reaches the reports.


## 14. F3's bells: the frame exists, and it refutes the analogy (2026-08-06)

§13 closed F2 to the pixel and left F3's bell row unverified for want of a frame
with bells in it. The 1653 save has one — `report_F3.png` in
`docs/screens/live_1653_save/` — and it does not fit.

The live row is a **252** badge followed by **22** bell icons whose steps are
`[4 x11, 3, 4 x9]`. That single 3-step is real: it shows identically in two
different pixel rows of the sprite. And it cannot be produced by the gauge as
read. A badge of 252 means `drawn = 252`, which makes the icon count one of
252/126/63/31/15 — never 22. Searching 6000 slot counts, every `drawn` up to 300
and every shift produced no parameter set with that step sequence; the closest
candidate puts its 3-step first rather than twelfth, which would need the
accumulator to start near 33 where the code clears it to zero.

So either the call site's arguments differ from what I read at `@0x037BCE`, or
that row is drawn somewhere else. Recorded as an open discrepancy in
`notes/rulings/RULINGS.md`; the port keeps the F2 analogy with the mismatch
stated in the code rather than tuned until it matched. Resolving it needs the F3
body traced forward from `func_037A20` — the two counts are stack locals, so the
RAM probe cannot reach them.

This is the first thing in this pass where having the live frame made the answer
*less* certain rather than more, which seems worth saying plainly: the F2 result
stands on its own evidence and does not transfer to F3.
