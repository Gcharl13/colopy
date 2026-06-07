# MAPEDIT.EXE — Analysis

**Size**: 145,292 bytes (file size). Image starts at file 0x001600
(after 352-paragraph header). Image size: 0x1A809 bytes.

**MZ header**:
| Field | Value |
|-------|-------|
| Signature | `4D 5A` ("MZ") |
| Blocks in file | 224 |
| Bytes in last block | 9 |
| Relocations | 1,365 |
| Header paragraphs | 352 |
| Initial CS:IP | 0x1388:0x001E |
| Initial SS:SP | 0x1C82:0x1000 |
| Reloc table offset | 0x001E |
| Overlay number | 0 (= main module, not an overlay) |

---

## Architecture

MAPEDIT.EXE is a standalone map editor built with the same MicroProse
engine stack as VICEROY.EXE. Both share:
- The MicroProse RTLink Plus runtime (`Smart vectoring failed`...
  signature in DGROUP confirms)
- The MSC 6.0 medium-model C runtime
- The MADS asset format library

MAPEDIT shares **graphic resources with VICEROY**:
- `viceroy.pal` — VICEROY's palette
- `phys0` — PHYS0.SS terrain sprite sheet
- `icons` — ICONS.SS UI icons
- `woodtile` — WOODTILE.SS UI background
- `fontintr`, `fonttiny` — text fonts

This sharing means **terrain ID semantics in MAPEDIT MUST match VICEROY**
— they're the same sprite sheet indexed the same way. Per CLAUDE.md, the
canonical terrain ID list comes from **NAMES.TXT $TERRAIN section**, not
from MAPEDIT.

---

## Strings discovered (file offsets relative to whole file)

### Menu / dialog (file 0x017640..0x017800)

```
0x017640  MEMORY            ; runtime / debug menu
0x017647  DEBUG             ;
0x01764d  UNTITLED.MP       ; default new file name
0x017659  NEWNAME           ; new-file prompt
0x017661  MAPEDIT           ; app name (used in dialog title bars)
0x01766c  CONTINENTS1       ; continents-mode label 1
0x017680  CONTINENTS2       ; continents-mode label 2
0x017694  SAVE              ; save dialog
0x0176a1  ERROR             ; error dialog
0x0176af  SAVEAS            ; save-as dialog
0x0176c1  ERROR
0x0176cf  CREATENOW         ; "create now" prompt
0x0176e1  LOAD              ; load dialog
0x0176ee  *.MP              ; file filter
0x0176f3  MAPTOLOAD         ; load-file prompt
0x017713  EXIT              ; exit
0x01772e  HELP1             ; help screens 1-4
0x01773c  HELP2
0x01774a  HELP3
0x017758  HELP4
0x017766  ABOUT             ; about dialog
0x017774  EXIT
0x01778f  names             ; .TXT section: tile names
0x017795  labels            ; .TXT section: tile labels
0x01779c  UNFORESTED        ; tile category 1
0x0177a7  FORESTED          ; tile category 2
0x0177b0  OTHER             ; tile category 3
0x0177b6  OTHER_NAMES       ; .TXT section
0x0177c2  COLORS            ; .TXT section: color labels
0x0177c9  *.MP              ; (second instance — different dialog)
0x0177ce  MAPTOEDIT         ; edit-existing-file prompt
```

### Asset names (file 0x0177E0..0x017820)

```
0x0177e0  viceroy.pal       ; loads VICEROY palette
0x0177ec  fontintr          ; loads FONTINTR.FF
0x0177f5  fonttiny          ; loads FONTTINY.FF
0x0177fe  cursor            ; loads CURSOR.SS
0x017805  phys0             ; loads PHYS0.SS (terrain tiles)
0x01780b  icons             ; loads ICONS.SS
0x017811  woodtile          ; loads WOODTILE.SS
```

### Branding / about (file 0x01781A..0x017900)

```
0x01781a  Colonization Map Editor\n
0x017833  Copyright (C) 1994 by Microprose Software\n\n
0x01785f  Options:\n
0x017869    mapedit           = Starts editor normally\n
0x017897    mapedit -c        = Force creation of new map\n
0x0178c8    mapedit -m:file   = Edits specified file\n
0x0178f7  Exit value: %d\n
```

This confirms the **command-line options**:
- `mapedit` — normal edit (default file? probably picks UNTITLED.MP)
- `mapedit -c` — force create new
- `mapedit -m:file` — edit specific file

### Game data references (file 0x017988..0x017A40)

```
0x017988  Illegal entry into village    ; (RTLink runtime error)
0x0179a4  $STRING                       ; section marker
0x0179e2  KING                          ; section name
0x0179e7  IND0A0                        ; native sprite-sheet name (sample)
0x0179ee  MSS0                          ; settlement sprite-sheet name
0x0179f3  MYR0                          ; ?
0x017a14  STRING                        ; .TXT section marker
0x017a1b  NUMBER                        ; .TXT section marker
0x017a28  COUNTRY                       ; .TXT section marker
0x017a30  YEAR                          ; .TXT section marker
0x017a37  OPTIONS                       ; .TXT section marker
```

---

## What MAPEDIT does (workflow inference)

1. **Startup**: parse argv (-c / -m:file / default), load
   VICEROY.PAL, PHYS0.SS, ICONS.SS, WOODTILE.SS, fonts.
2. **Read MAPEDIT.TXT**: parse the section table to get tile names,
   labels, colors. Section markers: `$STRING`, `STRING`, `NUMBER`,
   `COUNTRY`, `YEAR`, `OPTIONS`, `names`, `labels`, `OTHER`,
   `OTHER_NAMES`, `COLORS`.
3. **Display main editor UI** with a tile palette (UNFORESTED /
   FORESTED / OTHER categories) plus the map grid.
4. **Tile placement**: user clicks tiles to set the byte at that
   `(x, y)` position. Each tile byte:
   - bits 0-4: terrain id (0..27)
   - bit 5: river overlay
   - bit 6: forest overlay
   - bit 7: ?
5. **Save/Load**: writes/reads .MP file in standard layout (see
   [MP_FORMAT.md](../../formats/MP_FORMAT.md)).

---

## Per-line decompilation status

MAPEDIT has **not been per-line decompiled** in this session. The
function boundary detector and disassembler from VICEROY can be
re-pointed at MAPEDIT.EXE in a follow-up session — the binary is
~30% the size of VICEROY (145K vs 495K), so per-line annotation should
be ~1/3 the effort.

The shared MADS / RTLink Plus / MSC 6.0 runtime means most C-runtime
helper functions in MAPEDIT will be **the same byte-verified ones** as
VICEROY (`__aFlmul` at the same image-relative offset, etc.). The
MAPEDIT-specific code is roughly the menu dispatcher + .MP read/write
+ tile palette UI.

---

## Recommended next steps

1. Run the existing `tools/disasm_mz.py` against MAPEDIT.EXE to produce
   per-function .asm files in `code/MAPEDIT/disasm/`.
2. Cross-reference with VICEROY's byte-verified runtime: any MAPEDIT
   function whose disasm matches a VICEROY function byte-for-byte
   inherits the verification status.
3. Identify the .MP read/write functions via `*.MP` PUSH sites.
4. Identify the tile palette UI via the UNFORESTED / FORESTED / OTHER
   PUSH sites.

The .MP format spec (already inferred from existing project knowledge)
is documented at [`formats/MP_FORMAT.md`](../../formats/MP_FORMAT.md).
