# COLONIZE/ Data Files — Complete UI Inventory (2026-05-24)

Full inventory of every data file in `COLONIZE/`, classified by whether
it drives UI rendering. This is the answer to: **"where does the game
say what gets rendered where?"**

---

## 1. UI / layout data files (drive renderer behavior)

| File | Bytes | Role |
|---|---|---|
| **VICEROY.EXE** | 494,910 | Game binary. DGDS engine + Colonization overrides. Contains paint functions, sprite-channel dispatcher (`[0x1F5C/5E/60]`), dialog framework (`func_06F0F4`), popup rect computer (`func_067DC8`). |
| **MODULES.DB** | 421 | 34 DGDS engine module names. The 6 Colonization-specific modules (`ViceroyMenu/Popup/Sprite/Europe/Colony/Map`) extend the generic ones. |
| **ERRORS.DB** | 1,198 | Engine constraint names: `PopupTooManyLines`, `PopupBoundaries`, `MessageTooLong`, `MenuBoundaries`, etc. — these are the limits the popup template enforces. |
| **VICEROY.PAL** | 1,024 | 256-color DOS VGA palette. 4× each byte (6-bit RGB×4 → 8-bit). |
| **GAME.TXT** | 87,731 | **510 popup `@KEY` definitions** with directives `@width`, `@x`, `@y`, `@default`, `@checkbox`, `@smallfont`, `@textcolr`, `@options`, `@prompt`, `@text`, `@length`. Body text uses `{...}` for yellow highlights, bare `%STRING0`/`%NUMBER0` for green-substituted text. |
| **LABELS.TXT** | small | UI labels — sections: `@MISC` (top menu words like "GAME"/"VIEW"/"ORDERS"), `@CMISC`/`@CTITLE`/`@CMESSAGE` (colony screen), `@INFO`/`@EUROLABEL` (sidebar), `@FATHERS`/`@COLORS`/`@ROUTE` (other panels). Referenced from VICEROY.EXE via `LCALL 0x4509:0x10F` with index. |
| **NAMES.TXT** | small | Tribe order (`@TRIBES`: Inca/Aztec/Arawak/Iroquois/Cherokee/Apache/Sioux/Tupi → IND0..IND7), commodity names (`@CARGO`), unit names (`@UNIT`), founding fathers (`@FOUNDING`). |
| **MENU.TXT** | 1,801 | **Complete dropdown menu structure** (NEW — not previously analyzed). 8 menu groups: `@GAME`/`@VIEW`/`@ORDERS`/`@REPORTS`/`@TRADE`/`@CUP`/`@PEDIA`/`@END`. Each item with `~` accelerator letters and F-key bindings. The `@REPORTS` block CONFIRMS the F-key→report mapping the audit found: F2 Religious, F3 CC, F4 Labor, F5 Economic, F6 Colony, F7 Naval, F8 Foreign Affairs, F9 Indian, F10 Score. |
| **MAPMENU.TXT** | 557 | Map editor menu (Editor/View/Map/Help). Same `~` accelerator format. |
| **PEDIA.TXT** | 55,561 | Colonizopedia content — 163 indexed entries that the Colonizopedia popup displays. |
| **COLONY.TXT** | 2,540 | Default colony names per nation, with founding year. e.g. `Jamestown,1607` / `Plymouth,1620`. Used by COLONY popup ("What shall we name this colony?") for the default suggestion. Sections: `@ENGLISH`, `@FRENCH`, `@SPANISH`, `@DUTCH`. |
| **TRIBE.TXT** | 813 | Tribal dispersal `(x, y)` map coordinates per tribe. Used by map generator. |
| **WOODCUT.TXT** | 341 | **16 event woodcut scene names** (NEW). Sections name the WDCUT01..13.SS sprite sheets: "A NEW WORLD" / "DISCOVERY OF THE NEW WORLD" / "BUILDING A COLONY" / "MEETING THE NATIVES" / "THE AZTEC EMPIRE" / "THE INCA NATION" / "DISCOVERY OF THE PACIFIC OCEAN" / "ENTERING INDIAN VILLAGE" / "THE FOUNTAIN OF YOUTH" / "CARGO FROM THE NEW WORLD" / "MEETING FELLOW EUROPEANS" / "COLONY BURNING" / "COLONY DESTROYED" / "INDIAN RAID" / "woodcut 14" / "woodcut 15" / "woodcut 16". |
| **CLOSING.TXT** | 762 | Closing-cinematic animation timing. Each line: `Series, Frame, Repeats, BaseX, Delay`. e.g. `4, 1, -1, 0, 0  ; Fireworks`. Drives CLOS-FWK/BEL/HAT/LDY/MAN/MIL/BKG.SS sprite playback. |
| **OPENING.TXT** | 1,479 | Opening-credits animation timing. Each line: `start_frame, end_frame, series, sprite`. e.g. `25, 50, 0, 1 ; Microprose presentation`. |
| **PATH.DAT** | 6,459 | Opening-sequence ship trajectory `(x, y)` per frame. Already integrated. |
| **CYCLE.DAT** | 34 | Palette cycling animation data — defines color rotation ranges for waterline shimmer, fire flicker, etc. (Not yet decoded.) |
| **DEBUG.TXT** | 3,367 | Developer message of the day (`@MOTD`) — version info popup. |

---

## 2. Asset files (drawing primitives — not layout)

| File pattern | Count | Role |
|---|---|---|
| `*.PIK` | 35 | Full-screen 320×200 background images (REPORT1..9, COLONY, EUROPE, CCBKGD, KINGLSS1/2, DECLARAT, OPENING, OPENMENU, CUSTOMIZ, DIFFICUL, NATIONS, etc.). |
| `*.SS` | 100+ | Sprite sheets — BUILDING, ICONS, PHYS0, TERRAIN, MSS0..5, MYR0..3, CC-NN, IND0A0..IND7A3, KING/KING1/2, WIN, KINGLOSE/WIN, WOODFRAM/PANL, WDCUT01..13, CLOS-*, OPEN*, etc. |
| `*.FF` | 5 | Bitmap fonts: FONTTINY (popup body / inventory numbers), FONTSMAL (uppercase-only buttons), FONTINTR (titles / chrome / sidebar), FONTKING (King speech bubble only), FONT-NP (disabled menu items). |
| `*.MP` | 1+ | Map data — AMER2.MP is the bundled Americas map. |

---

## 3. Sound files (NOT UI-relevant)

| File | Bytes | Role |
|---|---|---|
| **COLDIG.BIN** | 993,755 | **8-bit unsigned PCM digital audio** (avg byte=127, characteristic of unsigned PCM around 0x80 silence). Contains all sampled sounds. NOT referenced by VICEROY.EXE directly — loaded via .COL sound configurations by the sound driver. |
| `ASOUND.COL` / `PSOUND.COL` / `RSOUND.COL` / `GSOUND.COL` | ~50 KB each | Sound configurations for AdLib / PC Speaker / Roland / Gravis Ultrasound. Pick the matching one for the user's sound card. |
| `AMERICA.MOV` | 572 | Tiny movie metadata for opening cinematic. |

---

## 4. Other (NOT UI-relevant)

| File | Role |
|---|---|
| `OPENING.EXE` / `CLOSING.EXE` / `MAPEDIT.EXE` | Auxiliary programs (also use DGDS engine — share MODULES.DB / ERRORS.DB). |
| `INSTALL.EXE` / `MPSCOPY.EXE` | Installer programs (simple utilities, no DGDS engine). |
| `INSTALL.DAT` / `INSTALL.GIF` | Installer data + splash. |
| `AUTOEXEC.TXT` / `CONFIG.TXT` | Sample DOS config files for the user. |
| `MEMORY.TXT` / `MEMORY2.TXT` | Out-of-memory error messages. |
| `README.TXT` | Game release notes (v3.0, 1995). |
| `COLDEMO.BAT` / `COLONIZE.BAT` | DOS batch launchers. |
| `PKUNZJR.COM` | Bundled `pkunzip` utility. |

---

## 5. What this changes for the renderer

Three NEW data sources to integrate that I hadn't been using:

### MENU.TXT
- **Top menu bar rendering**: the words "GAME / VIEW / ORDERS / REPORTS / TRADE" come from the menu group headers (the line after `@GAME` is `~GAME` which is what gets rendered, with the `~` letter highlighted).
- **Dropdown popups**: when player clicks a menu word, show the items in that group. Each item line has its accelerator and (sometimes) F-key/keyboard shortcut.
- **CHEAT menu (`@CUP`)** is normally hidden; activated via cheat code.

### COLONY.TXT
- **Naming new colonies**: the COLONY popup's default name should come from this file based on player nation. Sequence: English → Jamestown, Plymouth, Roanoke, Barbados, Penobscot, Boston, Baltimore, …

### WOODCUT.TXT
- **Event cinematics**: when a major event fires (founding a colony, native attack, etc.), the game shows a WDCUT*.SS scene + a title from this file. e.g. `WDCUT01.SS` + "A NEW WORLD" title.

### CLOSING.TXT / OPENING.TXT
- **Already covered** by the opening-sequence work (PATH.DAT integration). CLOSING.TXT timing is similar.

### CYCLE.DAT
- **Palette-cycling animations**: waterline shimmer, torch flicker, etc. Not critical for static popup renders but needed for fully-animated playback.

---

## 6. What we still DON'T have a data file for

These behaviors must be encoded in VICEROY.EXE itself (not in any data file):

- Popup x/y position when `@x`/`@y` are not in GAME.TXT (computed at runtime from cursor + char dims per `func_067DC8`).
- Advisor sprite channel assignment (per-event handler writes `[0x1F5C/5E/60]`).
- Native tribe context selection for IND0..IND7 (`func_0081C6` writes from NativeSettlement context).
- Per-screen paint function pixel layouts (each REPORT, the colony grid, the Europe harbor scene, etc.).

These live in code, not data. The ScummVM DGDS source is the reference implementation pattern; the actual Colonization-specific positions need to be byte-traced from VICEROY.EXE.
