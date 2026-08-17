## 22. The string files

Every word the game displays lives in eleven plain-text `.TXT` resources shipped beside the executables, all sharing one section format: an `@KEY` line opens a section, the following lines are its body, and `@;` lines are comments. GAME.TXT holds the dynamic message templates (with `%`-substitution slots), LABELS.TXT the static UI labels, NAMES.TXT the game-data taxonomy whose *row order is the runtime id*, PEDIA.TXT the encyclopedia, MENU.TXT the pull-down menu tree, DEBUG.TXT the cheat/debug dialogs, WOODCUT.TXT the event-screen captions, and MAPEDIT.TXT/MAPMENU.TXT the map editor's text. This chapter inventories all of them and specifies the template grammar and the engine that renders it.

### 22.1 File inventory

| File | `@`-sections | Role |
|------|-------------:|------|
| GAME.TXT | 499 | dynamic message/dialog templates (semantic catalogue counts 510 sections; the raw file also carries valueless directive lines) |
| LABELS.TXT | 7 | static UI labels (`@INFO` 4 · `@MISC` 221 · `@ROUTE` 9 · `@CMISC` 3 · `@CTITLE` 10 · `@CMESSAGE` 19 · `@EUROLABEL` 4) |
| NAMES.TXT | 31 | data taxonomy — row index = runtime id |
| PEDIA.TXT | 166 | Colonizopedia articles + category index |
| MENU.TXT | 8 | in-game menu bar (`@GAME @VIEW @ORDERS @REPORTS @TRADE @CUP @PEDIA @END`) |
| DEBUG.TXT | 20 | cheat/debug dialogs (4 sections dead) |
| WOODCUT.TXT | 1 | `@WOODCUT`, 17 caption lines (0–16) |
| MAPEDIT.TXT | 19 | map-editor dialogs (MAPEDIT.EXE only) |
| MAPMENU.TXT | 5 | map-editor menu bar (`@GAME @VIEW @CUP @HELP @END`) |
| OPENING.TXT / CLOSING.TXT | 3 / 2 | intro/outro cinematic scripts (`@CREDITS`/`@OPENING`/`@CLOSING` timing rows + `@MESSAGES` "Loading Game...") |
| COLONY.TXT / TRIBE.TXT | 5 / 9 | colony-name pools per nation; native-settlement coordinate lists per tribe |

### 22.2 GAME.TXT — the message bank

499 sections. The major key families:

| Family | Keys | Notes |
|--------|------|-------|
| Boot & options dialogs | `@BEGINMENU @AMERICA @GAMEOPTIONS @COLONYOPTIONS @SOUNDOPTIONS @SAVEGAME @LOADGAME* @PICKNATION @DIFFICULTY @LEADERNAME @LANDHO` | checkbox/options dialogs of Part V |
| Music pickers | `@PICKMUSIC @PICKINDEPENDENCE @PICKMILITARY @PICKINDIAN` | see §24.2 |
| European diplomacy | 48 sections: 42 `@width=220` conversations + 6 `@width=190` announcements/guards + 5 support lists (`@GREATKINGS @GREATDEEDS @GREATLEADER* @MEEKNESS @FRIEND`) | keys are **built at runtime** from a fragment pool at file 0x1F250+ ("MEEK" 0x1F250, "MANLY" 0x1F255, "HELLO" 0x1F267, "AHOY" 0x1F26D, "FIRST" 0x1F272, "USA"…), which is why full names never appear as string literals |
| Tutorials | `@TUTORIAL1..19` + `@TUTNOLUMBER @TUTNOSPACES` | see §23.2 |
| Intro caption cards | `@BUILD1..10` | one per LEVN000n.PIK card, rendered at pen (14,54) during world generation |
| Nation flavour | `@NATION0A/0B..3A/3B` | two briefing pages per power |
| Hot-seat multiplayer | `@MULTI @MULTINEXT @MULTIREV` | unlocked by `SET COLONIZE=MULTI` |
| Trade routes | `@TRADESTART @TRADETYPE @TRADENAMES @TRADENAME @TRADENONE @TRADENONE2 @TRADESELECT @TRADEDELETE @ROUTELOOP @TRADEWITH @TRADENOCARGO @TRADENOWANT` | `@TRADENAMES` = "5 / Run / Ferry / Cargo / Transport / Triangle" (count + 5 name stems) |
| Unit-option menus | `@UNITOPTIONS @SHIPOPTIONS @ARMOPTIONS @EUROPESHIPOPTIONS @EUROPESHIPCLICK @EUROPEARM` | dock/unit right-click order menus |
| King & tax | `@KINGTAX @KINGRAISE @KINGLOWER @KINGNOTHING @KINGNAVACT @KINGSTAMPACT @KINGWAR @KINGWIFE @MERCANTILISM @PURCHASETAX @TAXOPTIONS @TEAPARTY` + audience/war keys `@KINGRECRUIT @KINGFUND @KINGGALLEON2/3 @KINGFRIGATE @KINGNEWWAR @KINGVICTORY @KINGMERCY @KINGBUY @KINGMOBILIZE @KINGLOSE @KINGWIN @KINGBLESS @KINGLAUGH @KINGNO @KINGWELCOME0` | see §23.4 |
| Lost City | `@LOSTCITY0..9 @BURIAL1..3 @SCREWED @VANISH` | see §23.5 |
| Native events | `@INDIAN*` (welcome/treaty/gifts/war), `@RAID*` (6-key block at file 0x1F52A + orphan `@RAIDSCALP`), `@CHIEF*`, `@EXTORT*`, `@VILLAGE*`, `@LEARN*`, `@MISSION0..3`, `@HERESY0/1` | see §23.6 |
| Revolution | `@DECLARE @INDEPENDENCE @TOOTORY @ALREADYREVOLUTION @MOBILIZE* @UPKEEP @WARN1..3 @INTERVENTION @INTERVENE @CONSIDER @SUCCESSION @SEIZURE* @INVASION @REFIT` + guards `@NOWARSDURINGREV @NOCOLONIESEITHER @NOMAYORSDURINGREV @EUROPENOTAVAIL @FOREIGNNOTAVAIL` | see §23.7 |

Layout directives across the whole file: the `@width` histogram is {190: 336 sections, 220: 99, 300: 11, 310: 10, 160: 8, …}; only 21 sections carry a literal `@x`/`@y` (menus, tutorials, and the King-audience trio `@VICEROY` x=232/y=21, `@KINGLOSE` x=232/y=31, `@KINGWIN` x=202/y=125). No gameplay event popup is pinned — they all centre.

### 22.3 LABELS.TXT — the `@MISC` string-ID table

LABELS.TXT carries no substitution slots; it is pure label text. Six of its sections are consumed positionally (`@INFO` unit-info panel, `@CMISC`/`@CTITLE`/`@CMESSAGE` colony screen, `@EUROLABEL` Europe buttons, `@ROUTE` trade-route editor). The 221-line `@MISC` section is special: it feeds a runtime **string-ID table**.

- **Loader** (at file 0x75226–0x7523C, in the page-0x1A boot loader cluster): opens file "LABELS", selects section "MISC" (via 0x191F:0x928), then loops idx 0..220 (`cmp 0xDD` @0x75237) storing one interned value per line with `mov [bx+0x2DBA],ax` (`shl bx,1`).
- **The slots hold integer string IDs, not pointers.** Live values run **327..547 sequential**; they are resolved to text through the fetch verb **0x181F:0x22**. (A snapshot oracle that dereferenced slot value 537 as an address landed mid-string — the ID model is the byte-proven one.)
- **Slot formula:** any DGROUP word at offset O in 0x2DBA..0x2F72 holds `@MISC line = (O − 0x2DBA)/2`.

Notable slot map (line = slot index):

| Line | Text | Line | Text |
|-----:|------|-----:|------|
| 0/1 | "a" / "an" | 106 | "and" |
| 2 | End of Turn | 108 | ENCYCLOPEDIA OF COLONIZATION |
| 29/30/37/49–52/93 | the advisor-report titles (F9/F2/F3/F4/F5/F6/F7/F8) | 109/110 | (More) / (Exit) — pedia pager |
| 61–64 | Ship / Cargo / Location / Destination (F7 headers) | 129 | Artillery Vs. Raid |
| 65 | Veteran | 132/133 | Tory Unrest / Rebel Unrest |
| 75 | COMBAT ANALYSIS | 161–176 | setup labels ("Click Here When Finished", Choose/Difficulty Level/Level, Easiest..Toughest, Select/European Power/Power, Immigration/Cooperation/Conquest/Trade) |
| 76–84 | Fatigue, Attack Bonus, Ambush, Terrain, Colony, Fortified, Spain Bonus, …, Artillery In Open | 179–188 | pedia stat labels: Combat, Attack, Cargo Holds, Moves, Plow, River, Coast, Move Cost, Defense or Ambush Bonus, Prerequisite |
| 90 | Drake | 200/201 | Prime / Damaged |
| 95–100 | F8 strength rows: Colonies, Population, Average Colony, Military Power, Naval Power, Merchant Marine | 203/204 | Bid Price / Ask Price |
| 104 | Bombard | 210 | Exit |
| — | — | 211–220 | placeholder numerals "211".."220" |

`@ROUTE` (9 lines, the trade-route editor): EDIT TRADE ROUTE · Route Name: · Route Type: · Sea · Land · Destination · Unload Cargo · Load Cargo · (Delete Destination).

### 22.4 NAMES.TXT — sections and column legends

31 sections; row order is the runtime id everywhere (e.g. `@UNIT` row = unit type byte, `@COUNTRY`/`@TRIBES` order = power index 0..3 / 4..11). Column legends, verbatim from the file's own comment headers:

| Section | Lines | Columns (legend) |
|---------|------:|------------------|
| `@SEASONS` | 2 | Spring / Autumn |
| `@UNFORESTED` / `@FORESTED` | 8+8 | name; Movement, Defensive, Improvement, Value; Yield (Farmer, Planter(s), Planter(t), Planter(c), Trapper, Lumberjack, Ore Miner, Silver Miner, Fisherman) |
| `@OTHER` | 5 | same columns — Arctic, Ocean, Sea Lane, Mountains, Hills (ids 24..28) |
| `@OTHER_NAMES` | 5 | Forest, River, Major River, Minor River, Unexplored |
| `@RESOURCE` | 14 | "Special resource squares & values" — name, value |
| `@COUNTRY` | 4 | "Country names (color => must be 9-15)" — name, colour |
| `@NATIONALITY` / `@NATIONABBREV` / `@HOMEPORT` / `@COLONYNAME` / `@INDEPENDENT` / `@MISSION` | 4 each | positional per-power strings |
| `@LEADERNAME` | 4 | "Leaders: a) aggressive/friendly b) expansionist/perfectionist c) civilize/militaristic" — name + AI-bias triplet (loaded at 0x547A1 into the per-power table at DGROUP 0x9566) |
| `@DIFFICULTY` | 5 | Discoverer..Viceroy |
| `@CLASS` | 8 | "European classes: Name, transportation costs" |
| `@BUILDING` | 42 | "name, cost, tools(*10), size, min_colony, upkeep" |
| `@SCENARIO` | 2 | "map file (do not change), start, end, x0, y0, x1, y1, x2, y2, x3, y3" |
| `@JOB` | 28 | "name, student level (4 = unlearnable), cost in europe" (+ expert name) |
| `@CARGO` | 20 | "start1, 2, low, high, burden, rise, fall, attrition, volatility" — the market model; stats loaded only for rows 0–15, rows 16–19 name-only |
| `@UNIT` | 23 | "icon, movement, attack, combat, cargo, size, cost, tools, guns, hull, role; AI Role(binary) => Invade Settle Explore Attack Defend Escort Transp Naval" |
| `@ORDERS` | 13 | order name + status letter |
| `@ACTIONS` | 10 | village-visit action labels (incl. "Denounce Heresy of %Fs Mission") |
| `@VALUES` | 4 | quality grades low quality/good/fine/excellent |
| `@ATTITUDE` / `@ATTITUDINAL` | 5+5 | Content..War; Extremely..Slightly |
| `@LEVELS` | 5 | tribe tech levels: Semi-Nomadic/Camp, Agrarian/Village, Advanced/City, … |
| `@TRIBES` | 26 | "Indian tribe info: tech-level, color" — first 8 rows full 5-column tribes (name, adjective, treasure good, level, sprite), rows 9+ name-only reserve pool |
| `@FOUNDING` | 6 | father categories (Trade/Exploration/Military/Political/Religious/Independence) |
| `@FATHERS` | 25 | "type, weight 1500-1600, weight 1600-1700, weight 1700+" |
| `@COLORS` | 1 | "Text Colors: basic, hilite, grey, enhance, shadow, select, border 0, 1, 2" = 68, 149, 8, 128, 47, 138, 134, 128, 138 |

### 22.5 PEDIA.TXT — 166 surfaces

The Colonizopedia's article bank: seven category renderers, each keyed `<KEY><idx>`:

| Category (`@PEDIA` line) | Key | Entries |
|--------------------------|-----|---------|
| Cargo Type | `@CARGO0..15` | 16 |
| Unit Type | `@UNIT0..23` | 24 |
| Terrain Type | `@TERRAIN0..28` | 29 (spans the unforested+forested+other id space) |
| Colonist Skill | `@JOB0..27` | 28 |
| Colony Building | `@BUILDING0..41` | 42 |
| Founding Father | `@FATHER0..24` | 25 |
| Game Concept | *(see quirk)* | 12 titles |
| index sections | `@PEDIA` (7 category labels) + `@MISCELLANEOUS` | 2 |

Total = 166 top-level sections. **The `@MISC0..11` quirk:** the Game Concept category loads its 12-entry index from `@MISCELLANEOUS` (line 0 = count "12", then Disband, Fortify, Plowing, Roads, Sentry, Trade Route, Veteran Units, Prices, Taxes, Liberty Bells, Crosses, Hammers — loader at 0x07530B–0x07534B, count to `[0x846]`, line pointers to `[0x935C+2i]`), and the article renderer then builds the key `"MISC"+n` — but **no `@MISC0..11` sections exist in PEDIA.TXT**. What the engine renders when `menu_lookup_run` misses the section is unresolved (likely a header-only page); unmapped.

### 22.6 MENU.TXT, DEBUG.TXT, WOODCUT.TXT, editor files

**MENU.TXT** is flat: 8 sections, each one dropdown (line 0 = the bar title). Grammar: `~` precedes a hotkey/underline letter (`~GAME`, `~F~1`, `~F~0~1`, `~s~p~a~c~e~ bar`), `#` marks a separator/value-fill cell (e.g. "Zoom In#   ~Z"). `@CUP`'s title line is `~CHEAT` (the cheat menu, hidden until the Alt-W/I/N combo); `@PEDIA`'s is `~COLONIZOPEDIA`; `@END` is the empty terminator. Row texts are given verbatim in Part V §menus.

**DEBUG.TXT**: 20 sections. Sixteen are live cheat/debug dialogs (`@MEMORY @CREATE @CREATE2 @CSHIP @FOREIGN @FOREIGN2 @SETVIEW @SETHUMAN @SETAUTO @SETREPORT @SETEUROPE @DANGER @SOUND @OPTIONS @FORCED @TEST`); **four are dead** — `@MOTD`, `@MOTD2`, `@BADGUYS`, `@END` have no referencing string in any shipped EXE (`@END` is empty anyway). `@DANGER` ("DANGER, WILL ROBINSON!") is the AI assertion box, reachable in the shipping binary from 37 call sites.

**WOODCUT.TXT**: one section `@WOODCUT`, 17 caption lines 0–16 ("A NEW WORLD" … "INDIAN RAID"); lines 14–16 are placeholders with no art (see §23.1).

**MAPEDIT.TXT** (19 sections: `@MAPTOLOAD @MAPTOEDIT @SAVE @LOAD @ERROR @EXIT @SAVEAS @CREATENOW @NEWNAME @XS @YS @CONTINENTS1 @CONTINENTS2 @HELP1..5 @ABOUT`) and **MAPMENU.TXT** (5: `@GAME @VIEW @CUP @HELP @END`) serve MAPEDIT.EXE only; none of the 19 sections uses any `@`-directive.

### 22.7 The substitution grammar

Token inventory across GAME.TXT (502 scanned sections): `%STRING0` ×360, `%STRING1` ×211, `%STRING2` ×87, `%STRING3` ×49, `%STRING4` ×6; `%NUMBER0` ×124, `%NUMBER1` ×35, `%NUMBER2` ×11, `%NUMBER3` ×2; `%COUNTRY` ×7; `%YEAR` ×1. DEBUG.TXT adds `%HEXn` (`@MEMORY`'s "PSP at = %HEX4"). `%%` is a literal percent; `$` after a number renders as currency. The substituter uses longest-digit-run matching with trailing alpha kept literal (`%STRING0catraz` → "Alcatraz").

Slot storage:

- **VICEROY.EXE**: `%NUMBERn` values live in the slot array at DS:0x9CB0. `%STRINGn` slots are registered immediately before each emit via the two resident setters `func_06C220` (thunk 0x181F:0x416) and `func_06C23C` (thunk 0x181F:0x438, slot 0) — e.g. TUTORIAL12 registers the colony name at 0x2C7A7 just before its emit at 0x2C7B1.
- **MAPEDIT.EXE** (a compiled twin of the same engine): `%STRINGn` slots at **DS:0x634E + 64·n**, set by `_popup_say_string`; `%NUMBERn`, `%HEXn`, `%%` likewise.

Line and span directives (parser state machine, byte-cited in the MAPEDIT twin at 0x7C82 and in VICEROY's dialog engine):

| Syntax | Effect |
|--------|--------|
| *(blank line)* | separates the text block from the option block; option lines get ids 1..n in read order |
| `^` | raw (non-wrapped) line |
| `^^` | centred line |
| *(plain)* | word-wrapped paragraph text |
| `{…}` | highlight span — `{`/`}` toggle the hilite latch `[0x1F62]` (glyph loop `func_06C388` @0x06C3C4/@0x06C478); ink = the hilite entry of the dialog ink record |
| `\|` | truncates — ends the visible span of the line |
| `~x` | accelerator: underlines/hot-keys the following character (menus, checkbox rows); `~F~1`-style sequences bind F-keys |
| `#` | separator / value-fill placeholder in menu rows |

`@`-directives inside a section body — the parser `func_06F0F4` @0x06F0F4 (keyword table at file 0x1F967) recognises exactly **10 live directives**:

| Directive | Handler | Effect |
|-----------|---------|--------|
| `@OPTIONS` | mode switch | following lines are option rows |
| `@PROMPT` | mode switch | text-entry mode |
| `@TEXT` | @0x6F1D8 | back to body-text mode |
| `@SMALLFONT` | @0x6F207 | copies the current font latch `[0x89E]/[0x8A0]` into the dialog — it does **not** load FONTSMAL.FF (never loaded by the engine) |
| `@X=` / `@Y=` | @0x6F266 / @0x6F21E | literal popup origin (−1 = centre sentinel) |
| `@WIDTH=` | @0x6F2B0 | pixel content-width **floor** (never a clamp; keyword "WIDTH\0" at file 0x1F989) |
| `@LENGTH=` | @0x6F302 | text-entry max length → `[0xA5B6]` |
| `@CHECKBOX` | @0x6F350 | checkbox dialog (`FLAGS \|= 5`) |
| `@DEFAULT=` | @0x6F374 | pre-highlighted row index (an index, not a colour) |

An 11th keyword string, `TEXTCOLR` (file 0x1F9AA), is **vestigial as a directive** — the parser never compares it. The string is instead the sheet name for the TEXTCOLR.SS colour-table load (`func_06F6DA` @0x06F6F0), whose sprite pixels seed the dialog ink globals `[0x1F3C..0x1F4E]`. There is no per-popup text-colour override.

### 22.8 Template-engine key facts

- **`menu_lookup_run` = 0x181F:0x998 = `func_06F51A`.** Calling convention: **AX = section-name pointer, BX = file-name pointer, DX = preselect row; returns the 1-based selected row**. The GAME-file wrapper 0x181F:0x3FE (@0x06F594) hardwires file "GAME" (DS:0x87C) and takes the section in BX.
- Build chain: section reader 0x191F:0x928 (`func_06F8FA`) → template parser 0x191F:0x182 (`func_06F0F4`) → geometry finalize `func_06D316` (centred on (160,100) unless `@x/@y`) → modal pump 0x191F:0x16A (`func_06E3D0`), which returns the row.
- Checkbox channel: bitmask word `[0x1F54]` — reset 0x191F:0x26E, pre-seed 0x262, read-back 0x306.
- **ESC returns 0xFFFF** (byte-cited in the editor twin's event loop `@popup_exec` @0x6F5E: Up/Down move skipping greyed rows with wrap, Enter/Space select, hotkey match, mouse row select; entry mode appends printables to maxlen with backspace).
- Text entry lands in the popup text buffer (editor twin: DS:0x4B64); dead wrapper `@popup_ask_number` has zero callers in MAPEDIT.EXE.

## 23. The event catalogue

This chapter is the game's event book: every interrupting event, one row per event, in the schema *event_id / string_key / trigger / condition / options / outcomes (state writes) / arms (downstream)*. All string keys are GAME.TXT sections (verbatim bodies quoted where load-bearing); all popups render through the shared centred-dialog engine of Part V with a speaker channel (`[0x1F5C]` king/tribe, `[0x1F5E]` advisor, `[0x1F60]` missionary), all three reset to 0xFFFF after close at 0x06EE6B. Where a probability or write was not byte-decoded it is marked unmapped rather than estimated.

### 23.1 Woodcut event screens (17)

One renderer, `func_06B722` @0x06B722 (`show_woodcut(n)`): black clear, WOODFRAM frame 1 centred, title `"<year>: <CAPTION>"` from `@WOODCUT` line n, NAMEPLAT strip at y=162, caption at y=165 in FONT-NP (ink LUT palette indices 0x5C/0x5D/0x5E), WDCUT art blit, staged fade, modal wait. The wrapper `func_00543C` (0x181F:0x524) enforces **once-only** per game via the shown-bitmask at `[0x540A]` and fires the sound cues. Art = WDCUT01..WDCUT13.SS (no 00/14/15/16); a missing-file check @0x06B79F makes the art-less numbers unshowable. The caller scan is exhaustive: exactly 10 call sites.

| n | Caption (string = `@WOODCUT` line n) | Trigger | Sound cue | Arms |
|---|--------------------------------------|---------|-----------|------|
| 0 | A NEW WORLD | **no caller** (latent save-under popup mode) | music class 2 wired | — |
| 1 | DISCOVERY OF THE NEW WORLD | first landfall — `func_020EFE` @0x020F00 (sole caller `func_03FDDE`, after `[0x543E]\|=0x80`) | music class 2 | tutorial T2 tail |
| 2 | BUILDING A COLONY | first colony — build executor `func_040C1E` @0x040E00, human only | sfx 0x54 | — |
| 3 | MEETING THE NATIVES | first tribe contact, tribe ≥ 2 — `func_056C3E` @0x056DA6 | tune 0x33 | then `@INDIANWELCOME` |
| 4 | THE AZTEC EMPIRE | same site, tribe 1 (Aztec) | tune 0x35 | then `@INDIANWELCOME` |
| 5 | THE INCA NATION | same site, tribe 0 (Inca) | tune 0x36 | then `@INDIANWELCOME` |
| 6 | DISCOVERY OF THE PACIFIC OCEAN | **no caller** — sound cue wired @0x0054A2 but never hooked | tune 0x39 (dead) | — |
| 7 | ENTERING INDIAN VILLAGE | first village entry — `func_04B308` @0x04B56C (human) | — | village-visit dialog |
| 8 | THE FOUNTAIN OF YOUTH | Lost City outcome 1 — `func_061454` @0x0618F9 | after tune 0x37 | recruit prompt `@LOSTCITY0` |
| 9 | CARGO FROM THE NEW WORLD | first cargo arrival in Europe — `func_041EEA` @0x0420EF | music class 2 | — |
| 10 | MEETING FELLOW EUROPEANS | first power-to-power contact — `func_057F4E` @0x057FDF | contact fanfare 0x8020+p (§24.4) | `@HELLO*` greeting |
| 11 | COLONY BURNING | colony burned — `func_05CA7E` @0x05DADC (with `@BURNED`) and @0x05DFCB | sfx 0x53 + tune 0x32 | — |
| 12 | COLONY DESTROYED | **no caller** | — | — |
| 13 | INDIAN RAID | natives attack a human colony — `func_05CA7E` @0x05D219 | — | raid outcome popup (§23.6) |
| 14–16 | placeholders | unreachable — no caller *and* no .SS art | — | — |

### 23.2 Tutorial overlays (`@TUTORIAL1..19`)

All 19 are ordinary GAME.TXT popups emitted through 0x181F:0x652 = `func_06F5F2(name, advisor)` (sets the advisor portrait channel `[0x1F5E]` → MSS<n>.SS) or the 0x3FE wrapper. Gate: Game-Options bit 0x80 "Tutorial Hints" (T18 is ungated). Each step is **event-driven and idempotent**: its site does `test [0x5386/7],bit; jne skip → emit → or [0x5386/7],bit`; new-game init pre-marks `[0x5386]=0x0E`. Sections with literal placement: T1 (10,40), T4 (x=10), T12 (y=5), T16 (5,10 smallfont), T17/T18 (y=10 w=300 smallfont); the rest centre.

The unit-focus dispatcher `func_020F50` @0x020F50 (called from the end-of-move handler @0x021E63 and the map idle loop @0x024AC6 after a ~30-tick wait) serves T1, T3, T8–T11, T13–T15, T19 from an if/else chain over the selected unit:

| # | Trigger site | Condition | Advisor |
|---|--------------|-----------|---------|
| T1 | dispatcher | first turn (%STRING0 = unit-type name) | 0 |
| T2 | @0x020F43 | land discovered (tail of `func_020EFE`; no once-flag) | 0 |
| T3 | dispatcher | pioneer on a ≥5-resource site (%STRING0 = signature good) | 3 |
| T4 | @0x02C73F | colony open: better job available from the terrain ring (%STRING0/1 = current/alternative goods) | 5 |
| T5 | @0x036514 | religious-unrest immigration — chained after `@UNREST` | 4 |
| T6 | @0x02EA41 | goods ready for export at end of turn (%NUMBER0 qty, %STRING0..2 goods/colony/port) | 0 |
| T7 | @0x028D36 | colony pop ≥ 3 and no stockade | 1 |
| T8 | dispatcher | petty-criminal/servant near a training village | 5 |
| T9 | dispatcher | pioneer on unroaded forest/hills near a colony | 3 |
| T10 | dispatcher | pioneer on a plowable/clearable colony ring tile | 3 |
| T11 | dispatcher | idle ship, turn < 20 | — |
| T12 | @0x02C7B1 | colony open with a ship at the tile (%STRING0 = colony name) | 5 |
| T13 | dispatcher | pioneer before the first colony | 3 |
| T14 | dispatcher | soldier selected | 1 |
| T15 | dispatcher | colonist on a colony tile (%STRING0 = colony name) | 5 |
| T16 | @0x0286F6 | colony food deficit (red-X corn counters) | — |
| T17 | @0x035C22 | Europe screen first open | — |
| T18 | @0x032760 | Europe buy: cannot afford 100 units — **ungated** (no hints bit, no once-flag) | — |
| T19 | dispatcher | Indian convert selected | 4 |

Related conditional warnings from the found-colony validator `func_022542` (fire only at difficulty < 2, i.e. `[0x53A6] < 2` @0x22763): `@TUTNOSPACES` when adjacent productive squares < 4 (@0x22772), `@TUTNOLUMBER` when forested squares = 0 (@0x2278A); both are two-option confirms and the build proceeds only on row 2.

### 23.3 European diplomacy (the 48-section family)

One dispatcher owns the family: **`func_057F4E`** (page 0x0F, 7,151 bytes), entered from the contact evaluator `func_059B90` when a unit meets a foreign power (unit-vs-tile resolver @0x03F82B; movement processor @0x0481CB). AI-to-AI meetings delegate silently to the ticker `func_057DC0` @0x057FA4 — popups run only for the human. Conversations emit via 0x1A1F:0x688 = `func_06F61C` (speaker channel `[0x1F60]` = power B → MYR0..MYR3.SS portrait; returns the 1-based row); announcements via 0x181F:0x652 (advisor portraits MSS1/MSS2). Relation state = the 4×4 matrix at PowerRecord+0x34 (DGROUP 0x883C, row stride 0x13C): bits 0x02 war · **0x08 pending grievance** · 0x10 parley cooldown (16 turns) · 0x20 met · 0x40 peace treaty · **0x80 privateer hidden attribution**. PowerRecord+0x40 is the **treaty-respect counter** (plain byte, seeded `2·(6−difficulty)`, halved with Franklin; a nonzero value makes an AI abort attacks on its treaty partner @0x03F163; the decrement site is unmapped). `%STRING` slots are filled from `@GREATKINGS/@GREATDEEDS/@GREATLEADER*[power]` by `func_057A3A`; `@MEEKNESS` supplies "request"/"demand". Franklin (FF #19) halves demands/prices and cancels AI hostility at 6 cited sites; a war fanfare (`func_005108(4)`) precedes every WAR*/MERCENARY emit.

| Event / key(s) | Trigger (key-push → emit) | Options & outcomes (state writes) | Armed by / arms |
|----------------|---------------------------|-----------------------------------|-----------------|
| Greeting `@HELLOFIRST/@HELLOAHOY/@HELLOMEEK/@HELLOMANLY/@HELLOUSA` | key = "HELLO" + (not-met ? ship ? "AHOY" : "FIRST" : tone "MEEK"/"MANLY"); USA for an independent power; @0x0588CD–0x058923 → @0x058939 | greeting only; leads into the parley menu | first contact also fires woodcut 10 @0x057FDF + fanfare 0x8020+p |
| Third-party demand `@APOSTATES` (+USA) | AI asks the player to attack its treaty partner; @0x058989 → @0x058A30 | row 2 accepts → player's treaty with the target cleared + war bit 0x02 set @0x058A6A/@0x058A7B | — |
| Third-party demand `@HEATHEN` (+USA) | AI asks the player to attack a tribe; @0x0589C0 → @0x058A30 | row 2 accepts → tribe tension +100 vs the target tribe (`func_045DF2(t,A,100,0)` @0x058A91) | — |
| Protest `@PIRACY/@PIRACYUSA` — *"%STRING0 is most displeased with the {%STRING1 pirates} lying in wait off the coast of %STRING2…"* | fires when the war-matrix **privateer bit 0x80** is set for the pair; @0x058B0D → @0x058B45 | row 1 "What pirates? We have NEVER condoned piracy!" — denial; row 2 recalls **all** privateers to Europe and clears bit 0x80 @0x058B7D–0x058BE1 (Europe is the engine's destination sentinel **999/0x3E7**, the same value used by trade-route stops; a ship-type-guarded scan against it sits @0x6013C–0x60146) | armed by `func_03ECF0` @0x03F0A1: a Privateer attack (unit type 0x10 guard @0x03F092) sets 0x80 *instead of* the war bit |
| Protest `@SIEGES/@SIEGESUSA` | player units besieging B's colonies; @0x058C99 → @0x058CD8 | row 2 withdraws the besieging units. **Latent bug:** `@SIEGESUSA`'s rows are textually swapped but the handler acts on row 2 for both — answering "our forces shall stay" to an independent power executes the withdrawal | — |
| Extortion `@TRIBUTE/@TRIBUTEUSA` | demand accumulated from forces-near-colonies, difficulty-scaled (`value·10·(diff+8)/100`, surcharge `+500·(diff+1)`); @0x058E7D → @0x058EB8 | pay → gold transfer @0x058ED0; refuse → escalation into the WAR keys below | grievance: bit 0x08 set when the grievance score crosses its threshold @0x3F0D7/@0x59AE9 |
| Extortion `@WANTSTUFFUSA` — goods demand | @0x058F56 → @0x058F95 | accept → colony stock rows moved to B @0x058FB4. **Latent bug:** the non-USA key "WANTSTUFF" is built @0x058F56 but **has no GAME.TXT section** (only `@WANTSTUFFUSA` exists) | — |
| War declarations `@WARMEEK`/`@WARMANLY` — *"You reject our generous offer? Then in the name of %STRING0 we shall wipe you from the face of the New World. Prepare for WAR!"* | refusal outcomes of the demand tree; @0x059222/@0x059516 → @0x059274/@0x05957E | war bit 0x02 set for the pair | war fanfare class 4 first |
| Ultimatum `@RID/@RIDUSA`, provocation `@PROVOKE` | @0x059077 → @0x0590A3; @0x058FEE/@0x05974C | leave-or-war ultimatum; `@PROVOKE` = *"We can no longer tolerate your foul provocations. Prepare for WAR!"* | — |
| Treaty menu `@WORTHY` → `@PEACEMEEK/@PEACEMANLY/@OLDPEACE*/@PEACEUSA`, `@GIVECASH` | standing-peace proposals; @0x05911D–@0x059395 | treaty set both ways @0x059139 (0x181F:0xA06, bit 0x40) + siege stand-down `func_057CE0`; respect counter set 1 | 16-turn parley cooldown stamp `[0x53C8+p·2]` |
| Withdraw family `@WITHDRAW/@NOTWITHDRAW/@NOTHINGWITHDRAW/@MAYBEWITHDRAW` | @0x0593B7–@0x05949B | withdraw price = `25·(diff+2)·forces` (min 100, ×2 at war, −50/unit, Franklin ÷2) | `@GIFTS` @0x059700 / `@THREATS` @0x059755 side outcomes |
| Alliance `@MILITARY` → `@NOCONTACT/@ALREADYSMITE/@SMITEINDIANS/@SMITEEUROPE/@UNFORTUNATE/@MERCENARY` | dynamic row list (lea 0x19FA @0x05976D, shown via the modal pump @0x059848); smite family @0x05989D–@0x059A0F | purchase → B declares war on target T (bits @0x059A49–0x059A71) + player pays B @0x059AC7; `@MERCENARY` = *"The {%STRING0} declare war on the {%STRING1}."* | war fanfare class 4 |
| AI↔AI ticker `@SIGNTREATY`/`@DECLAREWAR` | `func_057DC0`, every 3rd turn per met pair; @0x057E86 / @0x057F18 | peace → treaty bit 0x40 both ways + respect := 1; war → `@DECLAREWAR`. **Latent bug:** the had-treaty branch pushes key "CANCELTREATY" @0x057F10 which **has no GAME.TXT section** (only `@CANCELPEACE` exists) | — |
| Attacking a treaty partner `@HAVETREATY` → `@CANCELPEACE`; `@SNEAK` | human attacker → `@HAVETREATY` @0x03F130 (row 2 "Break Treaty." continues) → `@CANCELPEACE` @0x03F22F; AI attacker → `@DECLAREWAR` @0x03F262; human victim → `@SNEAK` @0x03F1B4 | war bit set @0x03F298, treaty cleared @0x03F2A5 | second `@HAVETREATY` site @0x0220CE (order-issuing flow; its UI trigger is unmapped) — that path sets the war bit @0x220E6, clears the treaty via 0x181F:0xA10, plays **SFX 0x58** @0x220F9 and issues attack order 5 before the attack-execution call |
| `@SUCCESSION` — *"War of the Spanish Succession ends in Europe! {%STRING0}, ravaged by war, agrees to cede %STRING1 to the {%STRING2}…"* | `func_03C638` @0x03C76A (MSS2 advisor), scheduled while the SoL meter `[0x53D0] < 75` and no power has seceded (`[0x53D2] < 0`) | whole-map owner-bit rewrite @0x03C799–0x03C7D1 — the weakest AI power is absorbed | skipped in hot-seat multiplayer @0x03C63D |
| Movement guards `@NOWARSDURINGREV` / `@TRADEATWAR` / `@TRADEMERCANTILISM` | `@NOWARSDURINGREV` @0x05A916 (also enforcement @0x5A912 in the attack handler, only inside the WoI-declared gate @0x5A8C8: emits and sets the cancel flag, skipping the attack call @0x5A92C); `@TRADEATWAR` @0x05A458 and the **Jan de Witt gate** (FF #4) `@TRADEMERCANTILISM` @0x05A469, both in the foreign-colony trade entry `func_05A40E` | attack/trade cancelled; no state change | — |

### 23.4 King and tax events

The per-turn tax-demand driver is `func_036138`. Cadence: nothing before turn 30; then a demand fires when `turn % interval == 0`, interval 18 shrinking to 15/12/9 as the year crosses 1600/1700/1750, further reduced by `(diff−2)` for the human; skipped once tax > 85. Speaker channel `[0x1F5C]=8` → KING1.SS.

The **pretext** is chosen by a composite severity score
```text
sev = random_int(1,1000) + (2·SoL[0x53D0] − tax)·5 + gold_term(+0x2A,100)
    + per_player_const[0x9410+p] + turn/30            ; @0x361CC..0x36221
```

| event_id | string_key | Condition (sev) | Message opening |
|----------|-----------|------------------|-----------------|
| KING-WIFE | `@KINGWIFE` | `< 0x28A` (and `[0x53A7] < 0x1E`) @0x362C7 | "In honor of our recent wedding to our %STRING2 wife…" |
| KING-WAR | `@KINGWAR` | `< 0x3B6` @0x362FA (+`random_int(1,8)` war number) | "Because of recent developments in our ongoing war with %STRING2…" |
| KING-NAVACT | `@KINGNAVACT` | `< 0x44C` @0x36348 (+`random_int(3,4)`) | "…impose a new {Navigation Act}…" |
| KING-STAMPACT | `@KINGSTAMPACT` | else @0x36371 (+`random_int(5,8)`) | "…teach them proper respect… by imposing a new {Stamp Act}…" |

The core demand `@KINGTAX` (width 190): *"It is essential that the Crown receive proper recompense for its efforts on your behalf. Therefore we have graciously decided to raise your tax rate by {%NUMBER0%%}. The tax rate is now {%NUMBER1%%}. If you wish, you may kiss our royal pinky ring."* Options `@TAXOPTIONS`: **"Kiss pinky ring."** (accept — tax applied, hard-clamped to 75 at 0x03434F) / **"Hold '{%STRING3 Party}.'"** (refuse). Refusal fires `@TEAPARTY` — *"{%STRING3 Party}! Sons of Liberty throw {%NUMBER0} tons of %STRING0 into the sea at %STRING1! … %STRING0 cannot be traded in %STRING2 until boycott is lifted."* — and sets the per-good boycott bit `PowerRecord+0x20 |= (1<<good)` @0x034717. The boycott is lifted per-good by paying back-tax = `count × 500` gold (count = `PowerRecord[+0x4C+good] + base_table[0x9700+good·9]`, clamped ≥0; payment @0x03340D moves the gold into the royal fund and clears the bit @0x033423), or wholesale by acquiring Jakob Fugger (FF id 1: `mov [bx+0x20],0` @0x03BD45).

Related rows:

| event_id | string_key | Trigger / condition | Outcome |
|----------|-----------|---------------------|---------|
| KING-RAISE | `@KINGRAISE` | player *demands lower taxes* and fails | punitive raise ("Your DARE to demand lower taxes!…") |
| KING-LOWER / KING-NOTHING | `@KINGLOWER` / `@KINGNOTHING` | outcome of the lower-taxes petition | tax −%NUMBER0 / unchanged |
| KING-MERCANTILISM | `@MERCANTILISM` | building a profit-taking manufactory | tax raise, same options |
| KING-PURCHASETAX | `@PURCHASETAX` | use of Crown resources (Royal University etc.) | tax raise |
| KING-GALLEON | `@KINGGALLEON2/3`, `@CASHTREASURE`, `@LOOTCASH` | treasure unit with no Galleon; accept → Crown ships it | cut% = tax (with Cortés, FF #10) else `max(5·diff+50, 2·tax)` clamped ≤ 90; player receives gross − cut |
| KING-NEWWAR | `@KINGNEWWAR` | Crown declares war on a rival and orders the player in ("…we shall provide you with {%NUMBER0$}…") | peace arrangement cancelled. Portrait = **KING1.SS** (no "KING2.SS" exists anywhere in the binary — byte-refuted) |
| Tax-level gate | — | `tax ≥ 60` (0x3C, @0x034A1B) branches the king message flow; 75 (0x4B) is the hard cap | — |

### 23.5 Lost City rumors (`func_061454`)

Trigger: a unit enters a rumor tile. Rumor presence is **procedural** — predicate `func_006188` @0x6188 computes it from a coordinate hash against the map seed `[0x190]` (`((y>>2)·0x13 + (x>>2)·0x11 + seed + 8) & 0x1F − (x&3)·4 == (y&3)`), gated on terrain ≠ ocean/sea-lane/arctic and feature nibble = "none". Outcome index `n = max(anti_streak_floor, random_int(1,9))` — the floor rises by 1 per rumor and caps at 3, so the good low outcomes are only reachable on the first rumors; a quality roll `random_int(1,100) + scout·10` against thresholds 10/25 demotes/refines; per-game caps `[0x1DC6]/[0x1DC7]` limit Fountain and Cibola to one each; with debug bit `[0x5382]&1` the outcome is forced to 2. `s` = Seasoned-Scout bonus (unit type 5, class 0x16). The key is built literally as `"LOSTCITY"+n` (itoa append @0x618D1).

| n | string_key | Outcome (state writes) | Reward roll |
|---|-----------|------------------------|-------------|
| 1 | `@LOSTCITY1` — *"You have discovered a {Fountain of Youth}!…"* | **8 free immigrants** queued on the Europe docks; recruit prompt `@LOSTCITY0`; **woodcut 8** @0x0618F9 after **tune 0x37** @0x618ED; promotes to 2 if `[0x5382]&1` | — |
| 2 | `@LOSTCITY2` — Seven Cities of Cibola | Treasure unit created (type 0xA); value stored /100 in its class byte; sound 0x3C | `%NUMBER1 = 100·(10·(s+2) + 1d20)` |
| 3 | `@LOSTCITY3` — ruins of a lost civilization | gold credited to PowerRecord+0x2A @0x61C4C | `10·(3d8)`, scaled `·(s+2)/2` |
| 4 | `@LOSTCITY4` — burial mounds | options: "Let us search for treasure!" / "Stay clear of those!"; search → sub-dispatch `@BURIAL1` (empty) / `@BURIAL2` gold `10·(3d8)` / `@BURIAL3` treasure `200·(1d8+2s+10)`; a **human** desecrating a **hostile** tribe's grounds appends `@SCREWED` (*"…You have trespassed on sacred land. Now you must die!"*) and the unit is lost; desecration raises that tribe's tension **+100** (`func_045DF2` @0x61B84 → war footing); one special path per power (flag bit 0x40 in `[0x543E]` @0x6186B) | — |
| 5 | `@LOSTCITY5` | expedition **vanishes** — triggering unit destroyed (downgrades to 6 when disallowed) | — |
| 6 | `@LOSTCITY6` | nothing but rumors | — |
| 7 | `@LOSTCITY7` — small friendly tribe | chief's gift of gold | `2·(4d10)` |
| 8 | `@LOSTCITY8` | trespass near holy shrines — tribe displeased | — |
| 9 | `@LOSTCITY9` — desperate survivors | colonist(s) spawn and join the nation @0x61809 | — |

### 23.6 Native events

Speaker channel `[0x1F5C]` = tribe index (0=Inca … 7=Tupi) → IND<n>A<pose>.SS portrait, read from the settlement's owner byte.

| event_id | string_key | Trigger / condition | Options | Outcomes / arms |
|----------|-----------|---------------------|---------|-----------------|
| NAT-WELCOME | `@INDIANWELCOME` — *"The {%STRING0} tribe welcomes you. We are a glorious nation of {%NUMBER0 %STRING1}… Will you accept our treaty and live with us in peace as brothers?"* | first contact with a tribe (`func_056C3E`, after woodcut 3/4/5) | Yes / No | No → `@INDIANSHUN` ("…Prepare for WAR!"); related `@INDIANBOW`/`@INDIANTREATY`/`@INDIANPEACE`/`@INDIANCOME` |
| NAT-GIVEFOOD | `@INDIANGIVEFOOD` | supply/demand model in `func_056C3E`: the tribe's per-good **supply array [0x9E78] exceeds demand [0x9E58]** for food @0x05737C, and the player's stores are low — emit @0x0573EB | — | +%NUMBER0 food gifted |
| NAT-BEGFOOD | `@INDIANBEGFOOD` — *"…Will our brothers of {%STRING1} share the bounty of their harvests…"* | food **deficit** `[0x9E58]−[0x9E78]` @0x057098–0x05709F — emit @0x05716F | "I'm sorry, we gave at the office." / "We offer you {%NUMBER0} of our {%NUMBER1 food}…" | refusal/gift affect tension (delta site unmapped) |
| NAT-GIVESTUFF / CONVERT | `@INDIANGIVESTUFF`, `@INDIANSCONVERT` | goodwill gift; mission conversion `func_0572E6` — P(convert) = `(TribeData[+2]+2)/15`, doubled by Jean de Brebeuf (FF 0x16) | — | convert unit created at the colony, class 0x1B |
| NAT-RAID | 6-key block `@RAIDWREAK @RAIDSTORES @RAIDBURN @RAIDSHIP @RAIDGOLD @RAIDNOTHING` (contiguous in the EXE at file 0x1F52A) — e.g. *"Spies report: {%STRING0} raiding party wreaks havoc in the {%STRING3} colony of {%STRING1}."* | raid handler `func_05BE84`: gate roll `random_int(1,12)−1` (+`diff−2` vs a human European) vs threshold `3·K+1`; base outcome `random_int(1,4)` adjusted by turn (`turn < 40·(2−diff)` downgrades) and availability gates; 5-way dispatch @0x5C026 | — | 1→`@RAIDSTORES` (loot cargo, sfx 0x4F), 2→`@RAIDWREAK`, 3→`@RAIDGOLD` (sfx 0x4E), 4→`@RAIDBURN`/`@RAIDSHIP`, 0→`@RAIDNOTHING` (raiders wiped out, sfx 0x5B). `@RAIDSCALP` exists as a section but is **not** in the 6-key block — an orphan, not a 7th outcome. Raid on a human colony also fires **woodcut 13** @0x05D219 |
| NAT-WARPATH | `@INDIANWARPATH @INDIANWARPATH2 @INDIANWARFARE @INDIANWAR @INDIANGRUDGE @INDIANSURPRISE` | warpath handler `func_04B036` (sets `[0x1F5C]` = tribe owner); `@INDIANGRUDGE` = the Tory-side war-council entry during the revolution | — | war footing; alarm ≥ 128 (per-settlement per-power word at +0x0A+2·p) is the raid state; the parallel tension table (0..100) turns hostile at 75, war at 100 |
| NAT-EXTORT | `@EXTORTSTUFF @EXTORTPOOR @EXTORTLAUGH @EXTORTNO` | player Demands Tribute (`func_04AC00`) | — | gold clamped to `[10, min(3·tribe_wealth+10, 100)]`, moved from settlement to player |
| NAT-VILLAGE | `@VILLAGEHAPPY @VILLAGEMEDIUM @VILLAGESAVAGE @VILLAGEBAD @VILLAGEWAR`; `@MADATSHIPS @MADATWAGONS @DONTKNOWSHIPS` | scout enters village (`func_04B308`; attitude words from NAMES `@ATTITUDE`, banded at score cutoffs −5/0/10; War = alarm ≥ 128) | — | display; ship/wagon anger blocks trade |
| NAT-RAZE | `@CHIEFKILL @INDIANGOLD @INDIANBURN` | player attacks a settlement (`func_04A7CA`); `@CHIEFKILL` = taboo execution | — | raze gold = `(Σ3·random(1,10−diff)) · random(1,6) · 4 · (tribe+1)` → +0x2A; no woodcut fires here (the old "WDCUT12" gloss is byte-refuted — WDCUT12 has no caller) |
| NAT-TENSION | *(silent)* | tension applier `func_045DF2` (33 call sites): trespass +1/+2/+3, successful trade −4, mission established −(clamped), burial desecration +100, incite ±100, per-turn drift ±1 | — | deltas halved for France and with Pocahontas (FF 16); clamp [0,100] |

### 23.7 Revolution events

| event_id | string_key | Trigger / condition | Options | Outcomes / arms |
|----------|-----------|---------------------|---------|-----------------|
| REV-DECLARE | `@DECLARE` — *"Shall we declare our independence from {%STRING0}…? This will end our turn and place us at war with our King!"* | GAME menu "DECLARE INDEPENDENCE" → `func_03E984`; refused with `@ALREADYREVOLUTION` if already at war, or `@TOOTORY` (+%NUMBER0 = SoL) while the national SoL meter `[0x53D0] < 50` (@0x3E99E) | "Never! That would be treasonous!…" / "Yes! Give me liberty or give me death!" | yes → `func_03DE46`: `[0x5382]\|=1`, rebel power `[0x5398]:=[0x5394]`, declaration year stored, initial REF dispatch |
| REV-INDEPENDENCE | `@INDEPENDENCE` — *"Continental Congress signs {Declaration of Independence}! … General %STRING0 calls for volunteers for new Continental Army!"* | emitted by `func_03DE46` @0x3E104 | — | war begins; veteran soldiers promote (`@MOBILIZE`) |
| REV-WARN | `@WARN1/2/3` — *"…the King's forces control all but %NUMBER0 of the ports in %STRING0!…"* / *"…all but %NUMBER1 of our colonies!…"* / *"…%NUMBER2%% of the %STRING0 population. If he ever controls 90%%, the Continental Congress will be unable to continue the war…"* | wartime status warnings (ports / colonies / population thresholds); emit sites unmapped | — | surrender conditions foreshadowed |
| REV-CONSIDER | `@CONSIDER` — *"%STRING0 is considering intervention on our behalf… If we can generate %NUMBER0 liberty bells, they will join us."* | pre-intervention notice | — | arms the intervention watch |
| REV-INTERVENTION | `@INTERVENTION` (+ ally names from `@FRIEND`: British General Cornwallis / French General Lafayette / Spanish Generals / Dutch Admiral de Ruyter) | intervention declaration `func_03D948` — picks the strongest eligible foreign ally, sets `[0x5382]\|=2` @0x3DA22; arrival waves `func_03D510` land at a weighted colony pick `random_int(1, Σ weights)` @0x3D57E | — | Intervention Force joins the rebel side |
| REV-TORY | `@TORYUPRISING` | per-turn roll in `func_03CAC6`: `random_int(0, diff+1) ≠ 0` @0x3CADD ⇒ probability `(diff+1)/(diff+2)` | — | Tory uprising spawns loyalist units |
| REV-END | `@KINGVICTORY` / win path | per-turn resolver @0x02F464: rebels **win** when surviving REF combatants fall below the threshold (1, or 8 with `[0x5382]&0x40`) → `[0x5382]\|=8` @0x2F55A | — | score bonus `+2·(1780 − declaration_year)` if declared before 1780 |
| REV-MULTI | `@MULTIREV` — *"The Revolution does not function in multi-player mode…"* | declaring in hot-seat (`[0x5381]&0x80`) @0x03E9C5 | Declare independence / Never Mind | confirm clears the multiplayer flag (`and [0x5381],0x7F` @0x03E9D3) — game continues single-player |
| REV-GUARDS | `@NOWARSDURINGREV @NOCOLONIESEITHER @NOMAYORSDURINGREV @EUROPENOTAVAIL @FOREIGNNOTAVAIL` | action guards while `[0x5382]&1` (see §23.3 last row for the byte-cited `@NOWARSDURINGREV` enforcement) | — | action cancelled |

### 23.8 Europe arrival and immigration chain

| event_id | string_key | Trigger | Outcome / arms |
|----------|-----------|---------|----------------|
| EUR-UNREST | `@UNREST` — *"Religious unrest in %COUNTRY causes increased emigration. Colonists ({%STRING1}) now available in %STRING0."* | crosses-driven immigration event (market/king phase; emit @0x3651F region) | **arms tutorial T5** (chained immediately after, advisor 4, @0x036514); recruit variant `@RECRUITCHOOSE` presents the dock choice |
| EUR-ARRIVE | *(banner, not a popup)* | ship reaches the Europe port: the header banner is composed by `func_030F76` into the top text band (band rect (x=320,y=7,w=0,h=0) set by `set_text_box` @0x035B2D) from the dock-state strings of LABELS `@MISC` lines 5–8 ("Sailing For" / "Inbound From" / "Now Arriving In" / "Docks At") plus port, season/year and tax/gold state | first cargo sold in Europe fires **woodcut 9** @0x0420EF |
| EUR-SAILHOME | `@SAILHOME` — *"We have reached the {high seas}… Shall we sail for Europe?"* (default row 1) | ship enters the sea-lane column | yes → Europe screen on arrival; `@SAILAWAY`/`@SAILPORT` are the return prompts |

## 24. Music and sound

All music and effects are driven through an external, load-time sound driver; VICEROY.EXE itself contains **no `.XMI` filenames and no tune names beyond the picker menus** — a tune id is an opaque byte handed to the driver. Three master switches (Background Music `[0xA2]`, Event Music `[0xA0]`, Sound Effects `[0xA4]`) gate everything, persisted via the save-side mirror `[0x5386]`.

### 24.1 The tune-id table (0x20..0x3E)

Byte-verified row↔id mapping from the Pick-Music jump tables (names verbatim from the `@PICKMUSIC` family):

| id | name | id | name |
|----|------|----|------|
| 0x20 | Bird Song | 0x30 | Morelli's Lesson |
| 0x21 | Smoky Tune | 0x31 | To Arms |
| 0x22 | Cornwall | 0x32 | Indian Victory |
| 0x23 | Shady Grove | 0x33 | Natives |
| 0x24 | Fiddler's Dance | 0x34 | *(event-only; no picker row)* |
| 0x25 | Jine the Cavalry | 0x35 | Tenochtitlan |
| 0x26 | Joe Clark | 0x36 | Pizarro at Cuzco |
| 0x27 | Little Fiddle | 0x37 | *(event-only — Fountain of Youth, requested @0x0618ED)* |
| 0x28 | *(unnamed, independence-class scheduler-only)* | 0x38 | Bonny Morn |
| 0x29 | Love Forever | 0x39 | Hornpipe |
| 0x2A | York Fusiliers | 0x3A | Hole In The Wall |
| 0x2B | Washington Artillery March | 0x3B | Nightingale |
| 0x2C | Road to Boston | 0x3E | *(event-only; requested @0x02F30A/@0x05C93D/@0x07544B)* |
| 0x2D | Independence Way | | |
| 0x2E | The Reveille | | |
| 0x2F | Successful Campaign | | |

The id→XMI resolution happens inside the driver binary (`?SOUND.COL`), so the names of 0x28/0x34/0x37/0x3E are unmapped. One further id outside the table, **0x3F**, is played exactly once — at the intervention-force arrival (`mov ax,0x3F` @0x3D7B1); it has no picker row and its name is likewise unmapped.

### 24.2 The four pickers (`func_023344` @0x023344)

One function drives all four GAME.TXT picker sections (PICKMUSIC / PICKINDEPENDENCE / PICKMILITARY / PICKINDIAN; section-name strings at file 0x1E428–0x1E450). Reached from the GAME menu, command 4 (@0x023617). Behaviour:

- **Preselect**: the current tune `[0x96]` maps to a picker row via a 28-entry jump table at file 0x0233E4 (ids 0x20..0x3B; 0x34/0x37 have no row — event-only).
- **Main menu**: rows 1–12 = the 12 folk tunes; rows 13/14/15 open the Independence/Military/Indian sub-pickers (each run via 0x181F:0x3FE) and offset the returned row: 13 → id = sel+0x28, 14 → sel+0x2D, 15 → sel+0x31 with a skip over 0x34 (@0x02351A).
- **On pick** (selection→id jump table at file 0x02353A): `mov [0x96],ax` then gated play via 0x181F:0x4C0. There is **no persistent lock** — normal rotation resumes when the tune ends.

The Sound Options dialog (`@SOUNDOPTIONS`, `func_0232AE` @0x0232AE) is the standard 3-row checkbox: row 1 → `[0xA2]` Background Music, row 2 → `[0xA0]` Event Music, row 3 → `[0xA4]` Sound Effects; results mirrored into `[0x5386]` @0x023301–0x023322; turning an option off immediately sends **driver command 1 (stop)** @0x023339.

### 24.3 The background scheduler (`func_004EE6` @0x004EE6)

Pumped from the input-idle loops (verb 0x181F:0x470). Per pump:

1. Skip unless background music `[0xA2]` is on or a one-shot `[0x9E]` is pending; poll the driver with **command 8 ("playing?")** and return while a tune is still sounding.
2. **Forced-next** `[0x94]` wins if set. The queue-tune API `func_0050BC` (0x181F:0x48E) sets `[0x94]` and sends a stop so the pump switches immediately.
3. **Class requests** `[0x9A]` (set by events via 0x181F:0x498/0x4A2/0x4AC/0x4B6 = `func_0050F0/0050FC/005108/00513C`, plus the woodcut wrapper `func_00543C`) map through the jump table @0x005008: **1** → folk window A, **2** → folk window B, **3** → independence tunes, **4** → military tunes, **5** → tune 0x33 once, **6** → 0x35, **7** → 0x36.
4. Otherwise the RNG (seeded from `[0x83A8]`) picks a tune-index window:
   - **peace** (`[0x5382]&1` clear): indices 1–12 (folk), with a **1-in-9** crossover into 13–23 (the war/period tunes);
   - **War of Independence**: indices 13–18, with a **1-in-5** crossover back into folk.
5. Index→id via `func_004DF8` (table @0x004EAC); a result equal to the current `[0x96]` is re-rolled; playback through the gate `func_00518E`.

### 24.4 Event cues

| Cue | Where |
|-----|-------|
| Woodcuts 0/1/9 | music **class 2** request (folk window B) in the wrapper `func_00543C` |
| Woodcuts 3/4/5/6 | direct tunes 0x33 / 0x35 / 0x36 / 0x39 (the 0x39 cue @0x0054A2 is wired but its woodcut has no caller) |
| Woodcut 11 (colony burning) | **sfx 0x53 + tune 0x32** ("Indian Victory") @0x05DFCB |
| Build first colony (woodcut 2) | **sfx 0x54** @0x040E00 |
| Fountain of Youth | **tune 0x37** @0x0618ED, then woodcut 8 |
| Cibola treasure | sound 0x3C |
| Native raid outcomes | sfx **0x4F** (stores looted), **0x4E** (gold seized), **0x5B** (raid wiped out) |
| First European contact | **fanfare id 0x8020+power** (high-bit ids address driver fanfare banks; `mov ax,0x8020` @0x58040) |
| Native contact / live-among-natives | fanfare **0x8024** @0x48C41 / @0x48EB7; native raze/massacre **sfx 0x53** @0x48EE6 |
| Treaty-break attack (order flow) | **sfx 0x58** @0x220F9, right after the war-bit write @0x220E6 (§23.3) |
| War declaration / mercenary | war fanfare — class-request 4 via `func_005108(4)` before every WAR*/MERCENARY emit |
| Revolution | independence-class (3) requests: declaration @0x3DE88, intervention @0x3D790/@0x3D9A3, REF phase @0x3E2EF; intervention arrival also plays the unnamed id **0x3F** @0x3D7B1 |
| Lost City sub-events | tune 0x33 queued @0x61910 (native outcome); tune 0x24 queued @0x61ABB (burial treasure); tune 0x32 queued @0x61B42 (desecration → war footing); class requests 1/2 @0x61BCE/@0x61920 |
| First cargo in Europe (woodcut 9) | tune **0x24** queued @0x4208C alongside the class-2 request |
| Colony burn music | class-2 requests @0x5C8AC/@0x5CA2B (with the sfx 0x53 + tune 0x32 pair above) |
| New-game start | plays tune **0x39** @0x756E4 and queues **0x25** @0x759A0 in the page-0x1A init path |
| Turn-loop event tune 0x3E | requested @0x02F30A / @0x05C93D / @0x07544B (name unmapped) |

### 24.5 Driver architecture

- **Load**: at boot `func_07845A` (called @0x0762E6) builds the driver filename from the template **`"#SOUND.COL"`** (file 0x1FD5A) — the `#` replaced by the sound-config byte `[0x2608]` — and loads it via DOS **int 21h AX=4B03** (load-overlay) in `func_01287A`; the driver image is identified by the tag **`"$sound$ "`** (file 0x2004B). Seven config words are fed to it; the writers of `[0x2608]`/`[0x260A..0x2616]` (setup-program output) are unmapped.
- **Vectors**: the driver header exports **5 entry vectors**, installed to DGROUP 0xA654–0xA667 by `func_012928`, reset @0x012976. Vector 1 = play/query command entry; vector 2 = shutdown flush; vectors 3/4 = ISR service entries.
- **Dispatch** (@0x01299A): a lock byte `[0x26C5]` guards re-entry — unlocked commands `ljmp [0xA658]` straight into the driver; locked ones queue (8 deep, ring at `[0x26B4]`, count `[0x26C4]`).
- **Clocking**: the timer ISR @0x00C6D9 calls **vector 4 every tick and vector 3 every 5th tick**. The exit path sends stop (id 1), polls id 8 until silent, then calls vector 2.
- **Command gate** `func_00518E` (AX = id): ids `< 0x10` are driver commands and always pass; **bit 0x20 ids (tunes) are gated on `[0xA0]`** (Event Music); **bit 0x40 ids (SFX 0x40–0x5F) on `[0xA4]`**; the surviving id goes `lcall 0x1059:0xA` into the driver. Command ids seen: **1 = stop**, **8 = query-playing**.
- **Sound Test cheat** (MENU `@CUP` cmd 0x69 → @0x023D86): numeric-entry dialog from DEBUG.TXT `@SOUND` ("Play what sound #?"), result `[0x9CC8]` → gated play — arbitrary id playback against the live driver.

### 24.6 The digital sample bank (`COLDIG.BIN`) — decoded

Everything above concerns *tunes*, which the driver synthesises. Sound **effects**
are different: they are recorded audio, concatenated into `COLDIG.BIN` (993,755
bytes of headerless 8-bit unsigned PCM, mono), and the index that carves that
file into 35 samples lives **inside each `?SOUND.COL` driver**, byte-identical
in all four. Decoded 2026-08-17; the full citation set is in `formats/BIN.md`
and the ruling of that date, and `tools/decode_coldig.py` re-derives it from
the bytes on every run.

- **Table base** (from the driver's own `lea` operands): ASOUND file `0x0039F`,
  GSOUND `0x01E7B`, PSOUND `0x021A3`, RSOUND `0x01F01`. Images load at file
  `0x200`.
- **Row** = `u32 offset`, `u32 length`, stride 8 (`add si,8` in the walker
  `FINDWV` @0x00D39; `shl bx,3` in the play-by-index entry @0x00F28). The walker
  stops on a **zero-length** row, so there are **35 samples** and a terminator.
- **Self-consistent**: the 35 lengths sum to exactly 993,755, offsets are gapless
  and start at 0, and the terminator's offset is the end of the file.
- **Two rates, not one**: the player picks the rate from the index before it
  fetches the descriptor — `mov cx,0x4A6A` (**19050 Hz**), `cmp bx,5`, `jb`,
  `mov cx,0x2B11` (**11025 Hz**) @0x00F19. Indices **0..4 are 19050 Hz**, the
  rest 11025 Hz.
- **Id → index**: the driver's id dispatcher @0x01C35 bounds-checks
  `cmp bx,0x5D; ja` and jumps through a word table at file `0x01DB9`; each SFX
  handler is a literal `mov ax,<index>`. So e.g. the raid cues resolve as
  **0x4E → sample 6**, **0x4F → 11**, **0x5B → 22**, the first-colony cue
  **0x54 → 13**, and colony burning **0x53 → 19**. Five ids in the range
  (`0x46 0x47 0x59 0x5A 0x5D`) are not sample players. Note §24.5's gate speaks
  of `0x40–0x5F` because it tests bit `0x40`; the driver's table stops at `0x5D`.
- **Who opens the bank**: not the driver. `COLONIZE.EXE` holds `"#SOUND.COL"`
  @0x6C3B0 and `"coldig.bin"` @0x6C3EE; the `"coldig.bin"` strings inside the
  drivers are unreferenced by driver code.

Still TBD: the samples have no names anywhere in the drivers (labelling them
needs a listen-and-label pass), most VICEROY.EXE cue sites beyond §24.4 are
untraced, and indices 0..4, 15, 23, 24, 25 and 26 are never referenced by the
SFX dispatcher at all — real audio whose trigger is unknown. (Indices 0..4 are
five same-length clips with monotonically falling RMS, which *looks* like a
volume or distance ramp; that reading is not byte-verified and is not asserted.)
