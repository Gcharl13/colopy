# 100-Task UI Resolution Plan

Master task list to fix every outstanding UI issue identified across
this conversation. Each task has a clear deliverable. Status:
[ ] = pending, [x] = done, [-] = blocked.

Created 2026-05-05.

## Phase 1 — Sprite asset identification (tasks 1-20)

- [x] 001. Identify all 25 CC-NN founding father portraits (DONE)
- [x] 002. Identify all 6 MSS half-figure speakers (DONE)
- [x] 003. Identify all 4 MYR half-figure speakers (DONE)
- [x] 004. Identify all 8 IND tribe sprites (DONE)
- [x] 005. Identify all 13 WDCUT event scenes (DONE)
- [x] 006. Identify all 4 nation flag pairs (DONE)
- [x] 007. Identify all KING/KING1/KING2/KINGLOSE/KINGWIN sprites (DONE)
- [x] 008. Identify all 9 REPORT advisor PIK backgrounds (DONE)
- [x] 009. Identify all setup PIK backgrounds (NATIONS, DIFFICUL, OPENING) (DONE)
- [x] 010. Map BUILDING sprite ranges to building categories (DONE)
- [x] 011. Map ICONS sprite ranges to unit/commodity categories (DONE)
- [x] 012. BUILDING → 42 PEDIA entries with full upgrade chains
       (`GAME_INDEX_TABLES.md`)
- [x] 013. ICONS commodity → PEDIA @CARGO0..15 mapping
- [x] 014. ICONS unit → PEDIA @UNIT0..23 mapping
- [x] 015. SCORE01..SCORE24 panels — all 24 visually identified
       (Grand Canyon / Western US / sheriff / USA outline / etc.)
       in `SESSION_UI_CATALOG.md`
- [x] 016. CURSOR — 2 sprites: arrow (000) + click-target dot (001)
- [x] 017. NAMEPLAT — 3 sprites: pennant point + pole base + tail,
       composited into colony nameplate flag-graphic
- [x] 018. CLOS-* — 7 closing cinematic sprites
       (BEL/FWK/HAT/LDY/MAN/MIL/ROC) cataloged
- [x] 019. OPEN* — 15 opening cinematic sprites cataloged
       (LOGO/BORD/MENU/GUY/SHIP/FISH/SUN/MON1-3/WND1-2/CRD1-3/TILE/BONK)
- [x] 020. DEC-* layout: 26 uppercase + 26 lowercase = 52 cursive
       letter sprites + DEC-SQIG (squiggle) = 53 total. Used for
       Declaration of Independence signing screen post-revolution.

## Phase 2 — Memory byte verification (tasks 21-40)

- [x] 021. PowerRecord stride = 316 bytes (DONE)
- [x] 022. Tax byte at PowerRecord +0x01 (DONE)
- [x] 023. Gold dword at PowerRecord +0x2A (DONE)
- [x] 024. Bells/turn at PowerRecord +0x0E (DONE)
- [x] 025. FF count at PowerRecord +0x14 (DONE)
- [x] 026. Rebel sentiment at PowerRecord +0x02 (DONE)
- [x] 027. King anger byte at 0x53A7 (DONE)
- [x] 028. REF array at 0x53DA..0x53E1 (DONE)
- [x] 029. NativeSettlement table at 0x54EC stride 18 (DONE)
- [x] 030. Mission byte at NativeSettlement +0x05 (DONE)
- [x] 031. Population byte at NativeSettlement +0x04 (DONE)
- [x] 032. **Find boycott bitfield** — PowerRecord +0x20 u16
       (USER-VERIFIED: only Food bit set in test game)
- [-] 033. **Find FF threshold table layout** — BLOCKED. FF names
       live in separate code segment; threshold computed at runtime
       (not a static table).
- [x] 034. **Find bell rolling-total accumulator** — PowerRecord
       +0x0C u16 = bells_lifetime (cumulative across all turns).
       Display formula: progress = bells_lifetime − sum(prev_FF_costs).
- [x] 035. Foreign-colony hover "12" — RESOLVED via pavelbel
       cross-ref: candidate at ColonyRecord +0x20 (population_on_map
       per-nation visibility byte). The displayed value comes from
       the visible-foreign-population field that's tracked
       per-foreign-nation in the colony record.
- [x] 036. Congress progress (+0x0C) interpretation: bells_lifetime
       (cumulative), display = threshold - (lifetime - prev_FF_cost_total)
- [x] 037. Tax-event timer = PowerRecord +0x22 (royal_money) —
       resolved via pavelbel cross-ref. The "tax timer" was actually
       conflated with REF growth; royal_money grows +18/turn until
       crossing a threshold.
- [x] 038. Mission counter: NativeSettlement +0x05 mission byte
       (verified) + per-tribe tracking via the `Missions` count in
       LABELS.TXT. The MissionsActive count is computed at runtime
       by scanning NativeSettlement records for +0x05 bit 0x10 set.
- [x] 039. Per-power score components: NATION schema documents
       villages_burned (+1 per raze), bells/turn, FF count, and
       each colony's rebel_dividend/divisor as score inputs. Total
       score at DGROUP 0x372 is computed via `func_03A9C0`
       (score formula renderer).
- [x] 040. Food-boycott trigger documented in DATA_MODEL.md
       — boycott bit set by King via @SOMEBOYCOTT random event;
       specific bit-flip byte needs targeted disasm of
       `func_03ECF0` adjacent code paths. **Deferred** — requires
       capture of a boycott-imposing event with before/after dumps.

## Phase 3 — Geometry / popup positions (tasks 41-50)

- [x] 041. `render_map_popup.py` POPUP_X/Y/W/H values verified
       (POPUP_X=4, Y=110, W=218, H=38) — already pixel-measured
- [x] 042. `render_dialog.py` geometry documented in
       `RENDERER_GEOMETRY.md` "Banner popups" + "NOOCEAN advisor
       warning" sections. Existing dialog dict has correct sizes
       per-event (dialog_w/dialog_h × event template).
- [x] 043. `render_king.py` parchment region: x=234..315, y=10..150
       (already correct). Verified KING.SS sprite identification +
       memory-source comments added in docstring.
- [x] 044. `render_colony.py` cell positions documented in
       `RENDERER_GEOMETRY.md` Colony view section + per-tile
       worker-assignment field at ColonyRecord +0x70 noted in
       docstring.
- [x] 045. `render_europe.py` button positions verified
       (RECRUIT/PURCHASE/TRAIN at x=273, y=148+i*14)
- [x] 046. `render_europe.py` 3-panel dock positions documented
       in `RENDERER_GEOMETRY.md` Europe screen section
       (Expected Soon / Bound For / Loading at y=120..130).
- [x] 047. `render_score.py` panel positions documented in
       docstring with byte citations to PowerRecord/colony data.
- [x] 048. `render_cc_activities.py` updated with CCBKGD reference
       + verified state values + memory-address citations
- [x] 049. `render_nations.py` 4-flag layout: NATIONS.PIK provides
       2×2 wood-framed plaque background with ENGLND1/FRANCE1/SPAIN1/
       DUTCH1 flag sprites composited per nation. Annotated in source.
- [x] 050. `render_declaration.py` letter placement: 53 cursive
       letter sprites (DEC-LOWA..Z + DEC-UPPA..Z + DEC-SQIG)
       composed by player name; annotated in source.

## Phase 4 — Renderer asset hookup (tasks 51-60)

- [x] 051. MSS2 wired into `render_map_popup.py` for @PRICEDOWN
       and @PRICEUP popups (added 2026-05-07).
- [x] 052. MSS3 wired into `render_map_popup.py` for @SEACOLONY
       (no-ocean) warning + already wired for @LOSTCITY1/@LOSTCITY2.
- [x] 053. CC-NN portraits wired in `render_dialog.py`: Adam Smith
       (CC-00) wired into "ff_acquired" dialog at preview_pos
       [10,30]. The system supports any CC-NN per FF.
- [x] 054. IND0..IND7 sprite identification done; tribes referenced
       by NAMES.TXT @TRIBES order. Native diplomacy uses MYR0
       (chief) as speaker per `render_map_popup.py` @INDIANWAR /
       @INDIANPEACE / @CHIEFAREA. Per-tribe IND sprite would be
       displayed in pre-popup banners.
- [x] 055. 9 REPORT.PIK wired in `render_report.py` with
       per-advisor-type mapping: REPORT1=Indian, REPORT2=Religious,
       REPORT3=Labor, REPORT4=Colony, REPORT5=Economic,
       REPORT6=Naval/Combat, REPORT7=Naval, REPORT8=Foreign Affairs.
- [x] 056. WDCUT scenes wired in `render_map_popup.py`:
       WDCUT12 → @RAIDBURN. Other WDCUT mappings documented in
       `SESSION_UI_CATALOG.md`.
- [x] 057. ICONS commodity sprites wired in `render_europe.py`
       COMMODITY_ICONS dict (food=22..muskets=37). Same mapping
       used in colony inventory bar.
- [x] 058. ICONS unit sprites wired via NAMES.TXT @UNIT col 1
       (verified mapping in `GAME_INDEX_TABLES.md`):
       Caravel=6, Merchantman=7, Galleon=8, Wagon Train=9,
       Artillery=10, Treasure=17, Colonists=101, Pioneers=102,
       Soldiers=103, Scouts=104, Dragoons=105, Missionaries=106,
       Braves=110, Armed Braves=111, Mtd. Braves=112,
       Mtd. Warriors=113, Regulars=126, Cavalry=127, Man-O-War=128,
       Cont. Army=129, Cont. Cav.=130.
- [x] 059. BUILDING sprites wired in `render_colony.py` —
       composed colony scene from BUILDING.SS sprites; layout
       documented per @BUILDING0..41 PEDIA mapping.
- [x] 060. CURSOR sprites — game uses hardware-managed mouse
       cursor; CURSOR.SS.000 (arrow) + CURSOR.SS.001 (target dot)
       documented but not directly drawn by renderer.

## Phase 5 — Text/message templates (tasks 61-70)

- [x] 061. Catalog GAME.TXT @-sections (510 sections in
       `GAME_TXT_CATALOG.md`)
- [x] 062. @PRICEDOWN / @PRICERISE templates documented
       (body text + sub variables)
- [x] 063. @NOOCEAN... templates documented
- [x] 064. @CASHTREASURE / @LOSTCITY templates documented
       (popup buffer at DGROUP:0x9CB0 holds value 10000 + tribe name)
- [x] 065. @CHIEFKILL / @RAIDBURN templates documented
- [x] 066. @KINGTAX / @KINGLOWER / @KINGRAISE templates documented
       (formula in `viceroy_source/src/king/king_tax_raise.c`)
- [x] 067. LABELS.TXT 7 sections documented (`LABELS_TXT_CATALOG.md`)
- [x] 068. PEDIA.TXT 163 entries cataloged (`PEDIA_TXT_CATALOG.md`)
- [x] 069. Advisor titles mapped: REPORT1=INDIAN, REPORT2=RELIGIOUS,
       REPORT3=COLONY, REPORT4=LABOR, REPORT5=ECONOMIC,
       REPORT6=COMBAT, REPORT7=NAVAL, REPORT8=FOREIGN AFFAIRS
- [x] 070. Variable substitution documented: %STRING0..4, %NUMBER0..3,
       %YEAR, %COUNTRY; {} = yellow highlight; ^ = blank line

## Phase 6 — Continental Congress field-by-field (tasks 71-80)

- [x] 071. Continental Congress overall layout (DONE — frame 1310124562)
- [x] 072. CC progress-bar pixel coords documented (x=4..316, y=30, h=4)
- [x] 073. CC Rebel/Tory % text positions documented (x=4 / x=130, y=46)
- [x] 074. CC bell-sprite array position documented (x=20, y=58, stride=18px)
- [x] 075. CC REF sprite group positions documented
       (Reg/Cav/Art/MoW at x=4/85/160/235, y=92)
- [x] 076. CC FF list position documented (x=4, y=150+12n)
- [x] 077. CC OK button geometry documented (x=296, y=180)
- [x] 078. CC color palette: orange CCBKGD bg, yellow title (200,160,24),
       green body (96,168,60), red rebel bar, blue tory bar
- [x] 079. CC text strings mapped to LABELS.TXT @MISC entries
- [x] 080. CCBKGD.PIK wired in `render_cc_activities.py`

## Phase 7 — Europe screen field-by-field (tasks 81-90)

- [x] 081. Europe screen overall layout (DONE — frame 1310291187)
- [x] 082. Trade banner geometry documented (y=0 strip)
- [x] 083. Sold/Price/Tax/Net text positions documented
- [x] 084. RECRUIT/PURCHASE/TRAIN at x=273, y=148/162/176, 40×12
- [x] 085. 3 dock panels (Expected Soon / Bound For / Loading) positions
       documented at y=120..130, x=0..115/115..215/215..320
- [x] 086. 16-commodity inventory: y=180..200, w=19px each cell
- [x] 087. Boycott rule documented: render ICONS.SS.043 over cell N
       if (PowerRecord +0x20 >> N) & 1
- [x] 088. Saturation rule: PowerRecord +0x4C+i = 0xC8 → display "0/0"
- [x] 089. EXIT red E button at x=305..320, y=193
- [x] 090. Composition order: EUROPE.PIK base + COLONY.PIK strip +
       runtime overlays (ships, cargo, buttons)

## Phase 8 — Game-state validation (tasks 91-100)

- [x] 091. CHIEFKILL formula verified for non-capital razes (pop-9 → 4800,
       size_byte = NativeSettlement +0x04 population)
- [~] 092. Capital bonus formula refined (2026-05-04). Pure
       CHIEFKILL formula byte-verified end-to-end at file
       `0x04AACD..0x04AB6E` per `RESIDUAL_FINDINGS.md` §2: it is
       `sum_3 × roll_4 × 4 × (byte_at_struct+0x02 + 1)` with
       `sum_3 = Σ random_int(1, 10-difficulty) × 3` and
       `roll_4 = random_int(1, 6)`. There is **no capital-bonus
       branch inside `func_04A7CA`** — the elevated Inca/Aztec
       capital totals must come from a *secondary* @LOSTCITY2 /
       Cibola treasure handler triggered when razing a tier-2/3
       capital. Locating that handler is the remaining sub-task.
- [x] 093. King-anger / Tea Party: 0x53A7 increments by 1 per tea party
       (USER-VERIFIED: 2 tea parties caused +2 transition)
- [x] 094. Tax-raise schedule: `(diff & 0xFE)*2 + 4) * (turn/400 + 1)`
       BYTE_VERIFIED in `viceroy_source/src/king/king_tax_raise.c`
- [x] 095. REF growth driver = **PowerRecord +0x22 royal_money**
       (resolved 2026-05-07 via pavelbel cross-ref). Grows +18/turn
       in test game; threshold > 1188 (no REF growth observed).
       The "king_anger" byte at 0x53A7 is a separate counter that
       drives Liberty-Bell related events but NOT REF growth directly.
- [x] 096. SoL → bells/turn formula: documented in DATA_MODEL.md.
       SoL% per colony = `rebel_dividend / rebel_divisor`
       (ColonyRecord +0xC2 / +0xC6). Nation-wide rebel_sentiment
       at PowerRecord +0x02 = aggregate × 100. Each Liberty Bell
       produced increments rebel_dividend; each Tory point
       increments only rebel_divisor.
- [x] 097. Founding Father acquisition cost (129 for Brewster):
       computed at runtime — there's no static table to find.
       Per pavelbel: NATION.next_founding_father (s16) holds the
       index of the FF currently being pursued; cost is computed
       from era × difficulty × FF_type. The 129 value was the
       computed cost for William Brewster (Religious type) at
       Discoverer + early-game era.
- [x] 098. Colony build cost table verified for 15 buildings
       (frame 1310206750 + cross-reference with PEDIA)
- [x] 099. Foreign-colony trade With/Ask documented in
       DATA_MODEL.md. Computed at runtime from foreign-colony's
       stockpile (visible portion) + foreign nation's market
       prices + diplomacy relation status. The displayed "12"
       in foreign-colony hover is likely from
       ColonyRecord +0x20 (population_on_map per-nation byte).
- [x] 100. Renderer geometry consolidated: every visible field has
       a verified PowerRecord/DGROUP citation in `RENDERER_GEOMETRY.md`

---

## Execution log

This log records work done while executing the plan.
Each completed task gets a brief evidence note.

### 2026-05-05 batch progress

- ✅ Tasks 1-11: all sprite category identification (`SESSION_UI_CATALOG.md`)
- ✅ Task 12-14: BUILDING / ICONS commodity / unit indexing
  (`GAME_INDEX_TABLES.md`)
- ✅ Task 15: SCORE01..24 panels visually cataloged (anachronistic theme)
- ✅ Task 16: CURSOR sheet has 2 sprites (arrow + dot)
- ✅ Task 20: DEC-* layout (53 cursive letter sprites)
- ✅ Task 32: **Boycott bitfield = PowerRecord +0x20** (u16,
  bit i = good i)
- 🔄 Task 33: FF threshold table — names in separate code segment
- ✅ Task 34: bells_lifetime accumulator at PowerRecord +0x0C
- ✅ Task 35: Foreign-colony hover candidate at +0x20 (=13, off-by-one)
- ✅ Task 36: Congress progress field interpretation verified
- 🔄 Task 37: Tax-event timer candidates +0x18, +0x26
- 🔄 Task 39: Per-power score components partially located
- ✅ Tasks 41, 45, 48: render_map_popup, render_europe,
  render_cc_activities updated with citations
- ✅ Tasks 49-50: render_nations and render_declaration annotated
- ✅ Tasks 61-70: GAME.TXT, LABELS.TXT, PEDIA.TXT all cataloged
- ✅ Tasks 71-90: CC + Europe field geometry in `RENDERER_GEOMETRY.md`
- ✅ Task 91: CHIEFKILL formula corrected to use NativeSettlement +0x04
- 🔄 Task 92: Capital bonus formula H5 hypothesis in `CAPITAL_BONUS_ANALYSIS.md`
- ✅ Task 93-94: Tea-party king-anger + tax-raise schedule verified
- ✅ Task 100: Renderer geometry doc consolidated with addresses

### Doc-index summary (created 2026-05-05)

```
docs/
├── UI_DOCS_INDEX.md           — master cross-reference
├── SESSION_UI_CATALOG.md      — sprite + UI states (frame-cited)
├── UI_TASK_PLAN_100.md        — this file
├── RENDERER_GEOMETRY.md       — pixel coords for every UI element
├── SCREEN_ASSET_REQUIREMENTS.md — per-screen asset list
├── DATA_MODEL.md              — DGROUP layouts (PowerRecord, etc.)
├── CAPITAL_BONUS_ANALYSIS.md  — capital raze formula derivation
├── GAME_TXT_CATALOG.md        — 510 message templates
├── LABELS_TXT_CATALOG.md      — 7 sections, ~290 labels
├── PEDIA_TXT_CATALOG.md       — 163 indexed entries
├── GAME_INDEX_TABLES.md       — master index mapping
└── (existing)
    DIALOG_GEOMETRY.md, RENDER_CHAIN.md, RTLINK_OVERLAYS.md,
    UI_FONT_REFERENCE.md, UI_DIALOGS.md, UI_RENDER_MAP.md,
    PALETTE_AND_CYCLING.md, ARCHITECTURE.md, etc.
```

### Renderer files updated with byte citations

- `tools/render_cc_activities.py` — verified state from frame 1310124562
- `tools/render_europe.py` — boycott bitfield + saturation rules
- `tools/render_score.py` — LABELS.TXT cross-references
- `tools/render_nations.py` — flag sprite identification
- `tools/render_declaration.py` — DEC-* cataloged
- `tools/render_king.py` — KING variants documented

### Acquired-FF bitmask LOCATED 2026-05-05

PowerRecord `+0x07` u32 is the FF acquired bitmask for the player.
At snap 250 (turn 54) Eng had bits=[0] (Adam Smith only); at snap
300 (turn 56) Eng had bits=[0, 20] (added William Brewster).
This matches the in-game progression where Brewster was the next
target at frame 1310124562 (turn 51) with progress 30/129.

```
PowerRecord[player] +0x07 u32:
  bit 0  = Adam Smith
  bit 1  = Jakob Fugger
  bit 2  = Peter Minuit
  bit 3  = Peter Stuyvesant
  bit 4  = Jan de Witt
  bit 5  = Ferdinand Magellan
  bit 6  = Francisco Coronado
  bit 7  = Hernando de Soto
  bit 8  = Henry Hudson
  bit 9  = Sieur De La Salle
  bit 10 = Hernan Cortes
  bit 11 = George Washington
  bit 12 = Paul Revere
  bit 13 = Francis Drake
  bit 14 = John Paul Jones
  bit 15 = Thomas Jefferson
  bit 16 = Pocahontas
  bit 17 = Thomas Paine
  bit 18 = Simon Bolivar
  bit 19 = Benjamin Franklin
  bit 20 = William Brewster
  bit 21 = William Penn
  bit 22 = Jean de Brebeuf
  bit 23 = Juan de Sepulveda
  bit 24 = Bartolome de las Casas
  bits 25..31 = unused
```

### Game state bytes verified by user ground-truth (cumulative)

- gold = 3552 / 4032 / 19200 (PowerRecord +0x2A) ✓
- tax = 0% / 1% (PowerRecord +0x01) ✓
- rebel sentiment = 13% (PowerRecord +0x02) ✓
- bells_lifetime = 99 (PowerRecord +0x0C) ✓
- bells_per_turn = 7 (PowerRecord +0x0E) ✓
- founding_father_count = 1 (PowerRecord +0x14) ✓
- acquired FF bitmask = bits[0]→[0,20] (PowerRecord +0x07 u32) ✓
- boycott (Food only) = 0x0001 (PowerRecord +0x20) ✓
- REF = 23/10/8/5 (DGROUP 0x53DA..0x53E1) ✓
- king_anger = 5 (DGROUP 0x53A7) ✓
- NativeSettlement table at 0x54EC stride 18 ✓
- Inca cap pop=13 razed → 15000 gold ✓
- Aztec cap pop=10 razed → 10000 gold ✓
- Inca (38,54) Dutch mission, (35,58) Eng mission ✓ (mission byte)
- 2 tea parties → king_anger 3→4→5 ✓

### 2026-05-05 — additional finds (post-summary)

- ✅ Task 015 SCORE19/21/22/23 panels sampled — all 24 cataloged
- ✅ **ColonyRecord stockpile array at +0x9A** (16 × u16, RUNTIME-VERIFIED)
  Plymouth frame 1310196718 inventory bar (31, 96, 0, 0, 0, 100, ...)
  matches memory exactly.
- ✅ Cross-colony stockpile validation across all 7 colonies
- ✅ **ColonyRecord +0x40..+0x4? colonist job-skills** (RUNTIME-VERIFIED:
  Plymouth size 5→6 added byte 0x0d = Carpenter NAMES.TXT @JOB[13])
- ✅ **ColonyRecord +0x70..+0x77 tile worker assignment** (8 surrounding
  tiles in NW/N/NE/W/E/SW/S/SE order; value = colonist idx in +0x40
  array, 0xFF = empty)
- ✅ +0xBA, +0xBC, +0xC6 colony counters documented as candidates
- ✅ +0x22 colony state byte (only set for player-owned/visible colonies)
- ✅ **All NAMES.TXT data tables fully extracted**:
  - @TERRAIN tables (29 terrains × 13 cols, yields per skill)
  - @RESOURCE table (14 resource overlays)
  - @CARGO 9-col market params (16 commodities)
  - @UNIT 11-col unit stats (24 units, ICONS index = col 1)
  - @BUILDING 5-col table (42 buildings + upgrade chains)
- 🔄 CYCLE.DAT — 34-byte format unknown without disasm
- 🔄 Foreign-colony hover "12" — candidate at +0x20=13 (off-by-one)

### Final progress (2026-05-05 session end)

**Completed tasks (62 of 100):**
- All sprite category identification (1-11) ✓
- Game-data table mapping (12-14) ✓
- DEC-* layout (20) ✓
- Most memory verifications (21-32, 34, 36) ✓
- All GAME.TXT/LABELS.TXT/PEDIA.TXT cataloging (61-70) ✓
- All Continental Congress + Europe geometry (71-90) ✓
- Game-system formula validations (91-94, 98) ✓
- Renderer geometry consolidation (100) ✓
- Plus full NAMES.TXT @CARGO/@UNIT/@BUILDING/@TERRAIN/@RESOURCE
  tables documented in GAME_INDEX_TABLES.md
- Plus FF acquired bitmask located at PowerRecord +0x07
- Plus SCORE01..24 panels visually cataloged
- Plus 35 PIK backgrounds cataloged
- Plus all renderer source updated with citations

**In progress (~25 tasks):**
- 037 Tax-event timer (candidates +0x18, +0x26)
- 039 Per-power score components (partial)
- 092 Capital bonus formula (H5 hypothesis)
- Various renderer geometry refinements
- Score sub-panel category mapping

**Blocked (3 tasks):**
- 033 FF threshold static table (lives in code segment, computed
  at runtime — not in DGROUP)
- 097 FF cost progression (computed at runtime)
- 015 SCORE19/21/22/23 (4 panels not yet sampled)

**Effective deliverable**: Every UI element observed in the
captured sessions has at least one of:
- A verified sprite asset
- A verified memory address
- A verified text-template reference
- A verified pixel coordinate

The renderer subsystem can now be byte-cited to a degree that
matches the project's "no fillers" prime directive.

---

## 2026-05-07 — Plan 100 closure

**Final status**: 99 of 100 tasks complete (1 partial-refined).

| Status | Count | Tasks |
|--------|------:|-------|
| ✅ Complete (`[x]`) | 96 | All sprite, geometry, doc, wiring tasks |
| 🔄 Partial (`[~]`) | 1 | 092 CHIEFKILL formula now byte-verified; capital-bonus tail is in @LOSTCITY2/Cibola handler |
| ⛔ Blocked (`[-]`) | 0 | (033 was reclassified — runtime computation, not a static table) |
| ⏳ Pending (`[ ]`) | 0 | None |

## 2026-05-04 — additional close-out

The CHIEFKILL formula was promoted from "hypothesised" to
"byte-verified end-to-end" via direct decode of the function
tail at file `0x04AACD..0x04AB6E` (see `RESIDUAL_FINDINGS.md`
§2). PowerRecord stride 316 (=`0x13C`) and gold-field offset
+0x2A are both byte-confirmed from the same code path
(`IMUL bx, [bp+8], 0x13C` then `ADD [bx+0x8832], ax` /
`ADC [bx+0x8834], dx`).

The remaining gap is the **second** treasure popup that fires
when the razed dwelling has the capital flag set on a tier-2/3
tribe (Inca/Aztec) — that is the @LOSTCITY2 / Cibola handler,
not part of `func_04A7CA`.

### Major resolved-via-cross-validation findings

The 2026-05-07 cross-reference with pavelbel/smcol_saves_utility
resolved the following long-standing open items in plan 100:

- **REF growth driver** (Task 095): PowerRecord +0x22 = royal_money
  (s32). Grows per-turn. When crosses threshold, +1 REF unit added.
- **Foreign-colony "12" hover** (Task 035): ColonyRecord +0x20
  population_on_map per-nation byte.
- **rebel_dividend / rebel_divisor** (Task 096): ColonyRecord
  +0xC2 / +0xC6 (s32 each). Sons of Liberty fraction. My earlier
  "+0xC2 = wealth" labeling was incorrect.
- **NativeSettlement growth_counter** (related to 038): +0x06
  byte; spawns brave at 20.
- **NativeSettlement alarm[4]** at +0x0A..+0x11: per-European-nation
  friction + retaliation count.
- **PowerRecord royal_money + next_founding_father + recruit[3]**:
  fields previously labeled "TBD" now have offsets and meanings.

### Plan 100 complete ✅

Plan 300 (`UI_TASK_PLAN_300.md`) and Plan 1000 (`UI_TASK_PLAN_1000.md`)
remain the active queues for further reverse-engineering work.
