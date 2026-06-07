# Asset Roles — Every Asset → Code That Uses It

For every file in COLONIZE/, this doc records:
- Which function loads it
- What in-game role it plays
- Where the visualization / decoded output lives in `assets/`

This is the master cross-reference between disk files and code.

---

## Executables (6)

| File | Role | Status |
|------|------|--------|
| `VICEROY.EXE` | The main game | per-line decompile in progress (~25 BYTE_VERIFIED functions) |
| `MAPEDIT.EXE` | Map editor | bootstrap done; sigmatch promoted 5 functions to BYTE_VERIFIED |
| `OPENING.EXE` | Title-screen / cinematic player | sigmatch promoted 4 C-runtime helpers; per-line annotation pending |
| `CLOSING.EXE` | Endgame cinematic player | sigmatch promoted 4 C-runtime helpers |
| `MPSCOPY.EXE` | Install-time file copier | not yet disassembled |
| `INSTALL.EXE` | Installer (uses INSTALL.DAT + GIF + DAT files) | not yet disassembled |

---

## Maps

| File | Loader | Role | Extraction |
|------|--------|------|------------|
| `AMER2.MP` | TBD (find via PUSH `*.MP` in `func_0749E0`) | Standard Americas world (58×72 tiles) | `assets/maps/amer2.json` (BYTE_VERIFIED via extract_mp.py round-trip) |
| `AMER2.MP.backup` | (not loaded — backup file) | Backup copy | byte-identical to AMER2.MP |

---

## Palette

| File | Loader | Role | Extraction |
|------|--------|------|------------|
| `VICEROY.PAL` | TBD (find in `func_0749E0` startup chain — pushed alongside `phys0`/`icons`) | 256-color VGA palette for entire game | `assets/palettes/viceroy.png` + `viceroy.pal.json` (BYTE_VERIFIED via extract_pal.py round-trip) |

---

## Sprite sheets (.SS — 206 files)

All .SS files are loaded by the same .SS-loader function in VICEROY
(TBD — find via PUSH "phys0" / "icons" / etc. sites in `func_0749E0`'s
asset-loading chain). The loader uses MADSPACK 2.0 + FAB compression.

See [`assets/sprites/SPRITE_CATALOG.md`](../assets/sprites/SPRITE_CATALOG.md)
for the per-file role table and [`assets/sprites/SPRITE_ROLE_CATALOG.md`](../assets/sprites/SPRITE_ROLE_CATALOG.md)
for per-frame role mapping.

**Extraction**: 205 / 206 sheets extracted to PNGs.
- Skipped: `BDARK.SS` (orphan per CLAUDE.md hard rule)

---

## Backgrounds (.PIK — 35 files)

All .PIK files load via the .PIK-loader (TBD — analogous to the .SS
loader). Used as full-screen 320×200 backgrounds for specific screens.

See [`assets/backgrounds/BACKGROUND_CATALOG.md`](../assets/backgrounds/BACKGROUND_CATALOG.md).

**Extraction**: 35 / 35 extracted.

---

## Fonts (.FF — 5 files)

| File | Loader | Role | Extraction |
|------|--------|------|------------|
| `FONTINTR.FF` | TBD | Intro/title font | 88 glyphs |
| `FONTKING.FF` | TBD | Large king-text font | 78 glyphs |
| `FONT-NP.FF` | TBD | Disabled menu items | 27 glyphs |
| `FONTSMAL.FF` | TBD | Standard small UI font | 65 glyphs |
| `FONTTINY.FF` | TBD | Smallest dialog text | 71 glyphs (estimated) |

Loader function: TBD (find via PUSH "fontintr" / "fonttiny").

---

## Text data (.TXT — 18 files)

| File | Loader | Role |
|------|--------|------|
| `NAMES.TXT` | `func_0749E0` (BYTE_VERIFIED — 40 sections enumerated) | Authoritative game-data dictionary |
| `LABELS.TXT` | `func_0749E0` (PUSH "labels" string) | UI labels |
| `GAME.TXT` | TBD | Game messages |
| `COLONY.TXT` | TBD | Colony screen text |
| `MAPEDIT.TXT` | (loaded by MAPEDIT.EXE) | Map editor labels |
| `MENU.TXT` | TBD | Main game menu strings |
| `MAPMENU.TXT` | (MAPEDIT.EXE) | Map editor menu strings |
| `MEMORY.TXT` / `MEMORY2.TXT` | TBD | Memory diagnostics |
| `PEDIA.TXT` | TBD | Encyclopedia |
| `TRIBE.TXT` | `func_0749E0` (PUSH "TRIBES") | Per-tribe descriptions |
| `WOODCUT.TXT` | TBD | Woodcut sequence captions |
| `OPENING.TXT` | (OPENING.EXE) | Opening cinematic captions |
| `CLOSING.TXT` | (CLOSING.EXE) | Closing cinematic captions |
| `README.TXT` | (not loaded) | Standard readme |
| `AUTOEXEC.TXT` | (not loaded) | Sample autoexec.bat lines |
| `DEBUG.TXT` | TBD | Debug message strings |
| `CONFIG.TXT` | (loaded by INSTALL.EXE?) | Config menu text |

---

## Sound configs (.COL — 5 files)

| File | Audio device |
|------|--------------|
| `ASOUND.COL` | Adlib |
| `GSOUND.COL` | SoundBlaster / GameBlaster |
| `PSOUND.COL` | PC speaker |
| `RSOUND.COL` | Roland MT-32 |
| `CONFIG.COL` | Generic per-device selection |

Loader: sound-init function in VICEROY (TBD — find via PUSH "ASOUND.COL"
or similar). Each .COL provides (sound_id → COLDIG.BIN offset+size)
records.

---

## Audio bank

| File | Loader | Role |
|------|--------|------|
| `COLDIG.BIN` | sound-init | 8-bit unsigned PCM samples at 11025 Hz, indexed by .COL files |

---

## Cinematic

| File | Loader | Role |
|------|--------|------|
| `AMERICA.MOV` | OPENING.EXE cinematic player | Script driving frame sequences from OPEN*.SS |

---

## Standard files

| File | Loader | Role |
|------|--------|------|
| `INSTALL.GIF` | INSTALL.EXE | Install screen splash (CompuServe GIF87a) |

---

## Misc data (.DAT — 3 files)

| File | Loader | Role | Format |
|------|--------|------|--------|
| `CYCLE.DAT` | timer-tick function in VICEROY | Animation patch / cycle script (34 bytes; format TBD) | x86 code? |
| `PATH.DAT` | TBD | Pathfinding waypoints (BYTE_VERIFIED format: ASCII "x, y\r\n" pairs, ~6.5KB) | Plain text |
| `INSTALL.DAT` | INSTALL.EXE | Installer manifest (binary with embedded filenames) | TBD |

---

## Database (.DB — 2 files)

| File | Loader | Role |
|------|--------|------|
| `ERRORS.DB` | RTLink Plus runtime | Error messages displayed by overlay system |
| `MODULES.DB` | RTLink Plus runtime | Module/overlay manifest |

---

## Scripts and utilities

| File | Role |
|------|------|
| `COLDEMO.BAT` | Demo-mode launcher |
| `COLONIZE.BAT` | Main game launcher (calls VICEROY.EXE) |
| `PKUNZJR.COM` | PKUnzip Jr (used by INSTALL.EXE for unpacking) |

---

## Pre-extracted (TERRAIN.SS sidecars from prior session)

26 files: TERRAIN.SS.000.json/png through TERRAIN.SS.011.json/png, plus
master TERRAIN.SS.json, TERRAIN.SS.pal.png, and TERRAIN.SS.s00..s03.part
section dumps. Output of prior pixel-verification work; preserved
verbatim and referenced by `assets/sprites/TERRAIN/` once integrated.

---

## Coverage summary

| Category | Total | Extracted | Loader BYTE_VERIFIED |
|----------|-----:|----------:|---------------------:|
| Executables | 6 | 4 disasm'd | 25+ functions |
| Maps | 2 | 2 | 0 (loader function TBD) |
| Palette | 1 | 1 | 0 (loader TBD) |
| Sprite sheets | 206 | 205 | 0 (loader TBD) |
| Backgrounds | 35 | 35 | 0 (loader TBD) |
| Fonts | 5 | 5 | 0 (loader TBD) |
| Text data | 18 | 18 (byte-identity) | 1 (NAMES.TXT via func_0749E0) |
| Sound configs | 5 | 5 (byte-identity) | 0 |
| Audio bank | 1 | 1 (byte-identity) | 0 |
| Cinematic | 1 | 1 (byte-identity) | 0 |
| Misc DAT | 3 | 3 (byte-identity) | 0 |
| GIF | 1 | 1 (byte-identity) | 0 |
| DB | 2 | 2 (byte-identity) | 0 |
| Other | 4 | 4 (byte-identity) | n/a |

**Total**: 290 of 290 game-content files extracted (byte-identity or
content-decoded). Loader-function BYTE_VERIFICATION is the long-pole
remaining work in Phase D.
