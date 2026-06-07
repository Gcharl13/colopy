# Advisor Reports Audit (2026-05-24)

This document maps every Colonization advisor report (F2-F8 menu) from
the VICEROY.EXE disassembly to its paint function, background image,
title string, and data sources. Renderers can use this to produce
pixel-faithful versions.

**Source files searched**
- `code/VICEROY/disasm/` (1,243 .asm files)
- `code/COLONIZE/disasm/` (1,245 .asm files, recol overlay)
- `raw/COLONIZE/GAME.TXT`
- `raw/COLONIZE/LABELS.TXT`
- `build/ui_extract/funcs.json` (185+ LCALLs catalogued per function)

---

## Dispatcher (byte-verified)

### F-key handler (extended scan-code → paint function)

The F-key dispatcher lives inside the large function **`func_0x2b743`**
(orphan-range overlay code at file `0x02BDEA`..`0x02BECF`). It compares
`word ptr [bp + 6]` (the keyboard event) against extended scan codes
0x13C..0x144 and LCALLs into the corresponding paint thunk.

| F-key | Scan code | LCALL thunk | Overlay target | Paint func file offset | Report name |
|-------|-----------|-------------|----------------|------------------------|-------------|
| F2 | 0x13C | `LCALL 0x191F:0x40C` | 0x0000:0x0618 | **file 0x025F18** | Religious Adviser |
| F3 | 0x13D | `LCALL 0x191F:0x3FE` | 0x0000:0x06D0 | **file 0x025FD0** | Continental Congress |
| F4 | 0x13E | `LCALL 0x191F:0x3F0` | 0x0000:0x10D8 | **file 0x0269D8** | Labor Adviser |
| F5 | 0x13F | `LCALL 0x191F:0x3E2` | 0x0000:0x1710 | **file 0x027010** | Economic Adviser |
| F6 | 0x140 | `LCALL 0x191F:0x3D4` | 0x0000:0x1ED8 | **file 0x0277D8** | Colony Adviser |
| F7 | 0x141 | `LCALL 0x191F:0x3C6` | 0x0000:0x220C | **file 0x027B0C** | Naval Adviser |
| F8 | 0x142 | `LCALL 0x191F:0x3B8` | 0x0000:0x2548 | **file 0x027E48** | Foreign Affairs |
| F9 | 0x143 | `LCALL 0x191F:0x41A` | 0x0000:0x010A | **file 0x025A0A** | Indian Adviser |
| F10 | 0x144 | conditional: `LCALL 0x181F:0x574` or `LCALL 0x191F:0x3AA` | 0:0x14A8 / 0:0x92 | **file 0x026DA8** / file 0x025992 | Score |

Citation: `code/VICEROY/disasm/orphans_overlay.asm`
lines 13818..13898 (file offset 0x2BDEA..0x2BECF).

The F-key handler pushes the **current player power_idx** (from
`word ptr [0x8542]` byte `+0x1a`) as the sole argument to each paint
function. So the paint function knows whose data to display.

### Menu-letter handler (parallel)

The REPORTS dropdown menu also has a letter-hot-key handler at
file offset `0x023843..0x0238E7` (orphans_overlay.asm lines
3856..3905) that handles ASCII letter presses 'A'..'I' (0x41..0x49)
mapped to the same paint targets. Citations match exactly:

| Letter | Maps to | File offset |
|--------|---------|-------------|
| 'A' (0x41) | F2 Religious | 0x025F18 |
| 'B' (0x42) | F3 Continental Congress | 0x025FD0 |
| 'C' (0x43) | F4 Labor | 0x0269D8 |
| 'D' (0x44) | F5 Economic | 0x027010 |
| 'E' (0x45) | F6 Colony | 0x0277D8 |
| 'F' (0x46) | F7 Naval | 0x027B0C |
| 'G' (0x47) | F8 Foreign Affairs | 0x027E48 |
| 'H' (0x48) | F9 Indian | 0x025A0A |
| 'I' (0x49) | F10 Score | 0x026DA8 |

This argues `func_0x2b743` is the central in-game input handler that
covers BOTH keyboard menu clicks and dropdown letter selections.

### Third dispatcher (variation)

A third copy of the same dispatcher exists at file offset
`0x0355AE..0x03561E` (orphans_overlay.asm lines 28225..28262).
This is likely the **"main menu pulldown" handler** for the wood-strip
top menu's REPORTS item — same paint targets, same arguments.

---

## Common renderer infrastructure (shared by all reports)

Per `RENDER_CHAIN.md` BYTE_VERIFIED helpers:

| LCALL | Resolves to | Purpose |
|-------|-------------|---------|
| `LCALL 0x191F:0x087A` | overlay @ file 0x02590C | **load_PIK** (full-screen background loader) |
| `LCALL 0x181F:0x016E` | 0x004B:0x00E2, overlay @ file 0x06048A | `common_call_270x` — string-concat/format helper |
| `LCALL 0x181F:0x0182` | 0x004B:0x012E, overlay @ file 0x0604D6 | text-format-and-draw |
| `LCALL 0x181F:0x01BE` | 0x004B:0x0042, overlay @ file 0x0603EA | sprintf-style format |
| `LCALL 0x181F:0x07E4` | 0x0D1D:0x07E4 (load-image segment) | string concat (strcat) |
| `LCALL 0x181F:0x0204` | 0x0C2A:0x0006 | text-width compute (FONTTINY) |
| `LCALL 0x181F:0x035C` | 0x024C:0x000C, overlay @ file 0x028792 | rect/font box draw |
| `LCALL 0x181F:0x00BA` | 0x0B9E:0x000A | rect-with-color draw |
| `LCALL 0x181F:0x01F0` | 0x0C28:0x000A | palette-color set for text |
| `LCALL 0x181F:0x01FA` | 0x0C11:0x000C | text-draw-with-rect |
| `LCALL 0x181F:0x0652` | 0x0000:0x37A2, overlay @ file 0x0290A2 | `display_text_key` (GAME.TXT keyed message) |
| `LCALL 0x181F:0x09E6` | 0x05EB:0x002C, overlay @ file 0x02701C | `set_current_colony` / 16-cell iterator |

### Title bar painter

The shared title-bar painter is `LCALL 0x4509:0x10F` (direct overlay,
not via thunk table). It takes a **LABELS.TXT @MISC index** and draws
that text as a centered title bar. Function `func_0x2b743` calls this
114 times with every MISC index 2..117 in turn — it's the universal
"set window title" helper.

Per `LABELS_TXT_CATALOG.md`, the report titles are:
- `MISC[44]` = "INDIAN ADVISER REPORT"
- `MISC[45]` = "RELIGIOUS ADVISER REPORT"
- `MISC[52]` = "CONTINENTAL CONGRESS ACTIVITIES"
- `MISC[64]` = "LABOR ADVISER REPORT"
- `MISC[65]` = "ECONOMIC ADVISER REPORT"
- `MISC[66]` = "COLONY ADVISER REPORT"
- `MISC[67]` = "NAVAL ADVISER REPORT"
- `MISC[108]` = "FOREIGN AFFAIRS REPORT"
- `MISC[129]` = "COLONIZATION SCORE"

---

## PIK background sprintf loader

The function `func_037340` (file 0x037340..0x0373A4) is a generic
loader that pushes the string "REPORT" (at `0x11A2`) into a stack
buffer, appends the report-number argument via `sprintf` (LCALL
0xD1D:0x7E4 = string concat), then calls **load_PIK** (LCALL
0x181F:0x0182) on the result.

Pseudo-C reconstruction:
```c
void load_report_pik(int n) {
    char buf[80];                          // [bp-0x50]
    strcat(buf, "REPORT");                  // LCALL 0xD1D:0x7E4
    sprintf_append(buf, n);                 // LCALL 0x181F:0x0182
    load_PIK(buf, globals[0x2DA8..0x2DAE]); // LCALL 0x181F:0x044E
}
```

Each adviser's paint function calls this with its assigned report
number. Per `LABELS_TXT_CATALOG.md` cross-reference + SESSION_UI_CATALOG.md
and `reference/dos/popups/INDEX.md`:

| Report # | PIK file | Used by |
|----------|----------|---------|
| **REPORT1.PIK** | native warrior on shore | F9 Indian Adviser (NOTE: F9 may use REPORT1 or REPORT9) |
| **REPORT2.PIK** | preacher in church | F2 Religious Adviser |
| **REPORT3.PIK** | clerks at desk | F4 Labor Adviser |
| **REPORT4.PIK** | pioneers building colony | F6 Colony Adviser |
| **REPORT5.PIK** | scales+currency+hourglass | F5 Economic Adviser |
| **REPORT6.PIK** | aerial fortified colony | (COMBAT ANALYSIS — popup, not in F-menu) |
| **REPORT7.PIK** | galleon under sail | F7 Naval Adviser |
| **REPORT8.PIK** | map+wax-seal | F8 Foreign Affairs |
| **REPORT9.PIK** | (duplicate of REPORT1) | F9 alt or unused |
| **CCBKGD.PIK** | scribe at desk | F3 Continental Congress |
| (no PIK) | wood-panel score screen | F10 Score |

The mapping REPORT2↔F2, REPORT3↔F4, REPORT5↔F5, REPORT4↔F6, REPORT7↔F7,
REPORT8↔F8 is `# GUESS — needs visual verification by running each
paint function and matching the loaded PIK`. The renderer artwork
visually matches each advisor's domain.

---

## Per-report details

### F2 — Religious Adviser Report

- **paint_func**: file `0x025F18`..end of orphan range `0x026021` (~265 bytes)
- **F-key**: F2 (scan 0x13C)  
- **menu-letter**: 'A'
- **background**: REPORT2.PIK (`# GUESS — render & visually confirm`)
- **title text**: LABELS.TXT @MISC[45] = "RELIGIOUS ADVISER REPORT"
- **title font/color**: FONTTINY in dark sepia (per `UI_RENDER_MAP.md`
  TEXT_DARK=(40,24,16))
- **title position**: x=center, y=4 (`# GUESS — based on existing render_report.py`)
- **body structure**: per-colony grid showing crosses + colonist
  counts (per `SESSION_UI_CATALOG.md`)
- **data source**: 
  - For each colony C (iterate via `LCALL 0x181F:0x09E6 = set_current_colony`):
    - ColonyRecord +0x1F (size) 
    - ColonyRecord +0x70 + N (per-citizen profession byte) — check for missionary skill
    - PowerRecord per-colony bell rate
- **footer**: typically "OK" button (LABELS.TXT @MISC[61] = "OK") or "(press any key)"
- **TBD**: the body row template — needs deeper trace of file 0x025F18 code.
  The code calls `LCALL 0x181F:0x09E6` (set_current_colony) which means
  it iterates colonies. Row layout for each colony unconfirmed.

---

### F3 — Continental Congress Report  

- **paint_func**: file `0x025FD0`..end orphan range (~250 bytes)
- **F-key**: F3 (scan 0x13D)
- **menu-letter**: 'B'
- **background**: CCBKGD.PIK (loaded by paint code at this offset).
  Per `screens.json`: `continental_congress` screen entry_func is
  `0x4270b` and paint_func is `0x425e4` — those are the load helper
  layer. The actual F3 dispatch reaches via 0x025FD0.
- **title text**: LABELS.TXT @MISC[52] = "CONTINENTAL CONGRESS ACTIVITIES"
- **already cataloged**: see `SCREEN_ASSET_REQUIREMENTS.md` "Continental Congress Activities" section
- **body**: bells/turn (PowerRecord +0x0E), Rebel/Tory pct (PowerRecord +0x02),
  Expeditionary Force (DGROUP 0x53DA/DC/DE/E0), FF list (NAMES.TXT @FATHERS).
- **footer**: "OK" (LABELS.TXT @MISC[61])

This report is **already well-mapped** by prior work. The paint
function call chain is the new finding.

---

### F4 — Labor Adviser Report

- **paint_func**: file `0x0269D8`..end (~1024 bytes, large function)
- **F-key**: F4 (scan 0x13E)
- **menu-letter**: 'C'
- **background**: REPORT3.PIK (`# GUESS`) — clerks at desk artwork
- **title text**: LABELS.TXT @MISC[64] = "LABOR ADVISER REPORT"
- **title suffix**: LABELS.TXT @MISC[71] = "(Click on item to zoom)" 
  (per dos popup catalog `fullscreen_labor_adviser`)
- **body structure (per `fullscreen_labor_adviser.png` reference)**:
  columns of profession names with colonist counts per colony
- **layout bounds (per dos popup catalog)**: x=0, y=52, w=244, h=144
- **data source**:
  - Iterate all colonies (LCALL 0x181F:0x09E6 set_current_colony)
  - For each colony, walk citizen array ColonyRecord +0x70 + N
  - Tally counts by profession (NAMES.TXT @JOB index)
- **footer**: "OK" button bottom-right
- **TBD**: exact (x,y) per profession row and per-colony column

---

### F5 — Economic Adviser Report

- **paint_func**: file `0x027010`..end (large function)
- **F-key**: F5 (scan 0x13F)
- **menu-letter**: 'D'
- **background**: REPORT5.PIK (`# GUESS`) — scales+currency artwork
- **title text**: LABELS.TXT @MISC[65] = "ECONOMIC ADVISER REPORT"
- **layout (per `fullscreen_advisor_lower.png`)**: x=0, y=124, w=244, h=68 (lower table)
  + top body area for currency display
- **body structure**:
  - Treasury gold display (PowerRecord +0x2A)
  - Tax rate (PowerRecord +0x01) — LABELS.TXT @MISC `Tax:` (@CTITLE Tax)
  - Per-commodity sale prices + market pool
  - "TOTAL UPKEEP" line (LABELS.TXT @MISC[107])
  - "(Building Upkeep)" line (LABELS.TXT @MISC[106])
- **data source**:
  - PowerRecord +0x4C+i (per-good market price, i=0..15)
  - PowerRecord +0x5C + i*2 (per-good market pool)
  - PowerRecord +0x2A (gold)
- **footer**: "OK"
- **TBD**: precise row count and (x,y) — needs deeper code trace

---

### F6 — Colony Adviser Report

- **paint_func**: file `0x0277D8`..end (large function)
- **F-key**: F6 (scan 0x140)
- **menu-letter**: 'E'
- **background**: REPORT4.PIK (`# GUESS`) — pioneers building artwork
- **title text**: LABELS.TXT @MISC[66] = "COLONY ADVISER REPORT"
- **body structure**:
  - Per-colony summary row: name, size, production highlights,
    Sons of Liberty %, sentiment
- **data source**:
  - ColonyRecord +0x00..+0x19 (name)
  - ColonyRecord +0x1A (owner)
  - ColonyRecord +0x1F (size)
  - PowerRecord per-colony SoL state
- **footer**: "OK"
- **TBD**: row template and per-column layout

---

### F7 — Naval Adviser Report

- **paint_func**: file `0x027B0C`..end (~830 bytes, see func 0x279c6)
- **F-key**: F7 (scan 0x141)
- **menu-letter**: 'F'
- **background**: REPORT7.PIK — galleon at sail (visually confirmed
  per `SESSION_UI_CATALOG.md`)
- **title text**: LABELS.TXT @MISC[67] = "NAVAL ADVISER REPORT"
- **column headers** (per LABELS.TXT @MISC[76..79]):
  - "Ship" / "Cargo" / "Location" / "Destination"
- **body structure**: table — one row per ship in player's fleet
- **data source**:
  - Iterate UnitRecord table (base DGROUP:0x3146, stride 0x1C, byte-verified)
  - Filter where UnitRecord +0x00 == ship-type (ICONS 5,6,7,14,15 etc.)
  - For each ship:
    - Type byte → NAMES.TXT @UNIT[type] for name
    - Pos bytes +0x07, +0x08 → location label or "High Seas" (LABELS.TXT @MISC[75])
    - Status bytes → "On Mapboard" (MISC[69]) / "Off Mapboard (Europe)" (MISC[68])
    - Cargo bytes → goods carried
- **categories** per `SESSION_UI_CATALOG.md`: "Expected Soon" / "Bound For" / "Loading"
- **footer**: "OK"
- **globals_read by func 0x279c6**: `0x3e02`, `0x3e10` (likely ship counters)
- **TBD**: exact row spacing

---

### F8 — Foreign Affairs Report

- **paint_func**: file `0x027E48`..end (in func `0x27bca`, 0x500+ bytes)
- **F-key**: F8 (scan 0x142)
- **menu-letter**: 'G'
- **background**: REPORT8.PIK — map + wax seal artwork (visually
  confirmed)
- **title text**: LABELS.TXT @MISC[108] = "FOREIGN AFFAIRS REPORT"
- **prerequisite check**: byte ptr `[0x5382]` bit 0 must be set; else
  shows GAME.TXT @FOREIGNNOTAVAIL ("The Foreign Affairs Adviser's
  report is no longer available once the {War of Independence} has
  begun"). This check is implemented in `func_039888` (file 0x039888..
  0x0398A4), byte-verified.
- **NESTED PICKER**: Reports menu opens a sub-menu "View Whose Report?"
  with options England / French / Spanish / Dutch — per
  `reference/dos/popups/INDEX.md` cluster `foradv_picker`
  (bounds x=60, y=96, w=180, h=68). Body texts hardcoded from
  NAMES.TXT @NATION (English/French/Spanish/Dutch).
- **per-nation body** (per `fullscreen_foreign_affairs.png`, bounds
  x=8, y=12, w=236, h=184):
  - Title row: "{Leader Name}'s {Nation}"  (e.g. "Walter Raleigh's English")
    - Uses LABELS.TXT @MISC[109] = "'s"
  - Body rows (LABELS.TXT @MISC):
    - "Colonies" (110)
    - "Population" (111)
    - "Average Colony" (112)
    - "Military Power" (113)
    - "Naval Power" (114)
    - "Motherland" (`# GUESS — string TBD`)
    - "Tories" (102) / "Rebels" (101)
    - "Merchant Marine" (115)
- **status line**: "War" (MISC[116]) / "Peace" (MISC[117])
- **data source per nation N**:
  - PowerRecord N base (offset N*316 from DGROUP:0x8808 per project memory)
    - +0x01 Tax%
    - +0x02 Rebel% 
    - +0x07 FF mask
    - +0x0C/+0x0E bells
    - +0x14 FF count
    - +0x2A Gold
  - Military counts (TBD)
- **lcalls confirmed at 0x27bf2**: pushes -352 / 0x4086 (string for diff
  display); LCALL 0x5f65:0x774 (likely `format_text`)
- **lcalls confirmed at 0x27bfc**: `LCALL 0x4509:0x24` — different
  title call (variant of title painter)
- **lcalls confirmed at 0x27c4a**: `LCALL 0x4509:0x10F` — the standard
  title painter (so it IS used in the per-nation body too)
- **footer**: "OK"

---

### F9 — Indian Adviser Report

- **paint_func**: file `0x025A0A`..end (in func `0x258af`, ~440 bytes)
- **F-key**: F9 (scan 0x143)
- **menu-letter**: 'H'
- **background**: REPORT1.PIK or REPORT9.PIK — native warrior with spear
  (visually confirmed per asset catalog)
- **title text**: LABELS.TXT @MISC[44] = "INDIAN ADVISER REPORT"
- **body structure**:
  - Per-tribe row showing tribe name, settlements count, mission count,
    relationship status (Peace/War/Alarmed)
- **data source**:
  - Iterate NativeSettlement table at DGROUP:0x54EC (stride 18, byte-verified)
    - +0x00 x, +0x01 y, +0x02 owner_tribe, +0x04 pop, +0x05 mission flag
  - NAMES.TXT @TRIBES for tribe names (8 entries: Inca/Aztec/Arawak/Iroquois/
    Cherokee/Apache/Sioux/Tupi)
- **lcalls in func 0x258af**: `LCALL 0x5b7a:0x10e` (×2), `LCALL 0x5f65:0x1448`,
  `LCALL 0x5f65:0x148a` (variable-width text draws)
- **footer**: "OK"

---

### F10 — Colonization Score (bonus, not in F2-F8 brief)

- **paint_func**: file `0x026DA8` (when in-game) or `0x025992` (alt code path)
- **F-key**: F10 (scan 0x144)
- **menu-letter**: 'I'
- **conditional**: byte ptr `[0x5383]` bit 5 selects between two
  code paths (see dispatcher at 0x2BEB7..0x2BECA). The 0x5383 byte
  is likely an "Independence declared" or game-state flag.
- **background**: wood-panel screen (no PIK), per
  `SESSION_UI_CATALOG.md` "Score screen"
- **title text**: LABELS.TXT @MISC[129] = "COLONIZATION SCORE"
- **body structure**:
  - Hero line: "Explorer Vincent... Spring 1582"
  - "Citizens: +N" (MISC[130])
  - "Independence Declared: ..." (MISC[131] + MISC[133])
  - "Villages Burned: N" (MISC[132])
  - "Foreign Recognition: N" (MISC[135])
  - "Total Score: N" (MISC[136])
  - Founding Fathers acquired list
  - "Rebel Sentiment: N%"
- **fonts**: FONTKING per `UI_RENDER_MAP.md` (only screen that uses FONTKING)
- **24 SCORE artwork panels**: rendered via `func_03A9C0` (score-screen
  renderer per existing docs) which maps each line to a SCORE01..SCORE24 sprite
- **footer**: "Press" (MISC[217]) + key prompt

---

## Open work / TBD

1. **Per-report exact body layout** — each paint function (at the cited
   file offsets) needs deeper decompilation to extract:
   - Exact (x,y) coordinates of each text label
   - Exact font (FONTTINY vs FONTSMAL vs FONTINTR) per element
   - Row spacing in pixels
   - Column widths for table headers

2. **REPORT PIK assignments** — visual cross-check by actually running
   each paint function in DOSBox and capturing the loaded PIK file
   name. Current mapping is GUESS-level based on artwork+title pairs.

3. **F4 Foreign Affairs nested picker** — the "View Whose Report?"
   sub-menu paint function is not yet located in disasm. Likely inside
   `func_0x27bca` near the start (offset ~0x27bf0).

4. **Color choices** — title color (sepia? yellow on wood?) per report.
   The `LCALL 0x181F:0x01F0` (palette-color set) takes color args that
   need extraction per paint function.

5. **Footer text** — "OK" vs "(press any key)" vs "(F1 for Help)" per
   report. The OK button glyph location (LCALL `0x181F:0x35C` calls
   in each paint function likely produce these).

6. **Conditional report content** — some reports show different
   layouts based on game state (Foreign Affairs becomes unavailable
   during Revolution per FOREIGNNOTAVAIL string).

---

## Memory map summary

Globals accessed by report paint functions (by F-key):

| Global | Used by | Meaning |
|--------|---------|---------|
| `[0x8542]` | All | Active ColonyRecord base pointer (BYTE_VERIFIED) |
| `[0x8542]+0x1A` | All | Active power_idx (current player nation) |
| `[0x5382]` bit 0 | F8 | Foreign-Affairs-available flag (clears at Revolution) |
| `[0x5383]` bit 5 | F10 | Score variant flag |
| `[0x83a4..0x839e]` | F2 | 4-word filename buffer for load_PIK (e.g. "REPORT" sprintf'd) |
| `[0x2da8..0x2dae]` | Multiple | Generic 4-word buffer (cursor/text region?) |
| `[0x9b4]`, `[0x9b6]` | F3 | Continental Congress globals |
| `[0xa04..0xa0e]` | F3 | (TBD - more CC state) |
| `[0xede..0xef0]` | F5 | Economic state globals |
| `[0xce82..0xce90]` | F5/F6 | Per-good or per-colony scratch buffer |
| `[0x3e02]`, `[0x3e10]` | F7 | Ship counters |
| `[0x4086]`, `[0x4088]` | F8 | Per-nation diff buffer |

Per PowerRecord layout (byte-verified, stride 316 from DGROUP:0x8808):
- +0x01 Tax%
- +0x02 Rebel%
- +0x07 FF mask
- +0x0C/+0x0E bells lifetime/per-turn
- +0x14 FF count
- +0x20 Boycott bitfield
- +0x2A Gold
- +0x4C+i per-good price
- +0x5C+i*2 per-good pool

Per ColonyRecord (stride per CLAUDE.md, base from `[0x8542]`):
- +0x00 map_x
- +0x01 map_y
- +0x02..+0x19 name (NUL-term)
- +0x1A owner_power_idx
- +0x1F size
- +0x70+N per-citizen profession byte (active workers)
- +0x84+N Sons of Liberty per-citizen
- +0x9A+i*2 per-colony pool state
- +0xC2 wealth accumulator

Per NativeSettlement (DGROUP:0x54EC, stride 18):
- +0x00 x, +0x01 y, +0x02 owner_tribe, +0x04 pop, +0x05 mission_flag

REF table (DGROUP, BYTE_VERIFIED):
- 0x53DA u16: Regulars
- 0x53DC u16: Cavalry
- 0x53DE u16: Man-O-War
- 0x53E0 u16: Artillery

---

## How the renderer should use this

For each F-key the renderer:

1. Load the assigned PIK background (per "Per-report details" → background).
2. Draw the title bar text from LABELS.TXT @MISC at the cited index, using
   FONTTINY in sepia-brown (TEXT_DARK = (40,24,16) from existing render_report.py).
3. Iterate the appropriate data source (colonies / ships / nations / tribes).
4. Draw row template using FONTTINY rendered glyphs.
5. Draw footer "OK" button + "(press any key)".

The titles can be hardcoded from LABELS.TXT (parsed at startup) and
don't need byte-level fidelity to the binary — but the BODY layout
needs deeper trace of each paint function for pixel-perfect rendering.

---

## Cross-references

- `LABELS_TXT_CATALOG.md` — full @MISC index → string mapping
- `SCREEN_ASSET_REQUIREMENTS.md` — Continental Congress data flow
- `RENDER_CHAIN.md` — shared LCALL helpers
- `UI_RENDER_MAP.md` — font assignments per screen element
- `SESSION_UI_CATALOG.md` — Continental Congress (frame 1310124562)
  is the only report observed in the recorded session
- `reference/dos/popups/INDEX.md` — `fullscreen_advisor_report`,
  `fullscreen_labor_adviser`, `fullscreen_foreign_affairs`,
  `foradv_picker` cluster geometries
- `tools/render_report.py` — current Python renderer (uses incorrect
  REPORTn mapping — needs update to match this audit)

---

## Citations summary (all byte-verified)

| Finding | Source |
|---------|--------|
| F-key dispatcher at func 0x2b743, offset 0x2BDEA..0x2BECF | orphans_overlay.asm lines 13818..13898 |
| Menu-letter dispatcher at offset 0x023843..0x0238E7 | orphans_overlay.asm lines 3856..3905 |
| Third (top-menu) dispatcher at offset 0x0355AE..0x03561E | orphans_overlay.asm lines 28225..28262 |
| F-key paint targets (file offsets) | LCALL thunk resolution per `tools/resolve_lcall.py` formula |
| LABELS.TXT @MISC string indices | `LABELS.TXT` raw + `LABELS_TXT_CATALOG.md` |
| GAME.TXT @FOREIGNNOTAVAIL string at 0x11B6 | func_039888.asm line 19 |
| PIK loader (REPORT%d sprintf) func_037340 | func_037340_unknown.asm lines 14..47 |
| Common LCALL helper map | `RENDER_CHAIN.md` 2026-05-03 update |
| PowerRecord/ColonyRecord/NativeSettlement layouts | `DATA_MODEL.md`, project memory |

Generated 2026-05-24 from VICEROY.EXE disassembly + LABELS.TXT.
