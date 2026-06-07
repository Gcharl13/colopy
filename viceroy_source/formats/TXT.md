# TXT Format — Sectioned Text Resource

## File inventory
18 .TXT files in COLONIZE/:
- `NAMES.TXT` — terrain names, units, buildings, cargo, founding fathers
- `GAME.TXT` — major game-text strings (~499 sections)
- `TRIBE.TXT` — Native tribe data + village positions
- `MENU.TXT` — menu bar / status bar / hint strings
- `OPENING.TXT` — opening cinematic dialogue
- `CLOSING.TXT` — closing ceremony / endgame text
- `WOODCUT.TXT` — woodcut event text
- `LABELS.TXT` — UI element labels
- `DEBUG.TXT` — internal debug labels (developer-only)
- `PEDIA.TXT` — Colonipedia entries
- `COLONY.TXT` — colony-screen specific text
- `MAPEDIT.TXT` — map editor text
- `CONFIG.TXT` — runtime config descriptions
- `AUTOEXEC.TXT` — startup banner
- `MEMORY.TXT` / `MEMORY2.TXT` — memory-related diagnostic strings

## Format

Section-delimited plain text. Sections are introduced by an `@`-prefixed
section name on its own line:

```
@SECTION_NAME
line 1 content
line 2 content
...

@NEXT_SECTION
content
...
```

Within a section, entries are typically newline-delimited. Some
sections use tab-delimited fields for tabular data (e.g. NAMES.TXT
@RESOURCE has columns like resource_id, name, bonus_type, bonus_amount).

## Parser

The DOS-side parser is in the overlay (asset-loader region). The
Python-port parser at `colonize_sdl/dos_data.py` reads all 18 TXT
files and exposes their sections as Python dicts.

## Section catalog

`NAMES.TXT` sections (the most important — terrain/unit/building/cargo names):

```
@TERRAIN     21 base terrain types in canonical order
@UNIT        Unit type names (Free Colonist, Soldier, Pioneer, Caravel, ...)
@BUILDING    Building names (Stockade, Fort, Town Hall, Carpenter's Shop, ...)
@CARGO       16 commodities (Food, Sugar, Tobacco, ..., Tools, Muskets)
@FATHER      25 founding-father names (Adam Smith, Benjamin Franklin, ...)
@RESOURCE    14 resource overlay entries (Wheat, Beaver, Silver Deposit, ...)
@TRIBE       Native tribe names (Aztec, Inca, Apache, Sioux, ...)
@SCENARIO    Scenario configurations including starting positions
```

`GAME.TXT` has ~499 sections covering all in-game dialogue and message
text. Each section has a key like `@AMERICA` or `@FOUND_LOST_CITY` and
expands to one or more lines of text.

## Verification

- @python  ../../../colonize_sdl/dos_data.py
- @python  ../../../tools/extract_text.py
- @verified  All 18 .TXT files parse cleanly, all sections roundtrip.

## Citations

- @asm_file  TBD (overlay-resident TXT-section parser)
- @ref       ../../../extracted/text/NAMES_sections.json  -- the
              authoritative parsed terrain ordering
- @rule      Per docs/RULINGS.md: terrain ordering MUST come from
              @TERRAIN of NAMES.TXT, never from `mapedit.c` (which has
              been wrong before).
