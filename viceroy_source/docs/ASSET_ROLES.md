> **>>> RECONSTRUCTED — NOT BYTE-VERIFIED <<<**
>
> The formulas, tables, and specific numbers in this document are reconstructed
> from accumulated playthrough knowledge and prior reverse-engineering notes.
> They have **not** been confirmed by reading bytes from VICEROY.EXE.
>
> Treat every numerical claim as RECONSTRUCTED until cross-referenced to a
> hand-decompiled function in `code/VICEROY/decompiled.md` or to bytes
> documented in `viceroy_source/VERIFICATION_LEDGER.md`.

# Asset Roles

Cross-references every COLONIZE/ asset to the code that references it.


## Palettes (1)

| File          | Role                              | Loaded by                    |
|---------------|-----------------------------------|------------------------------|
| VICEROY.PAL   | 256-color VGA palette             | `_main()` at boot            |

@ref `../formats/PAL.md`

## Sprite sheets (.SS, 206 files)

### Always-loaded core (loaded at `_main()` boot)

| File         | Role                                                       |
|--------------|------------------------------------------------------------|
| ICONS.SS     | Mouse cursors, unit map sprites (100..127), HUD icons     |
| PHYS0.SS     | Terrain overlays (forest, river, mountain, hills, resources) |
| BUILDING.SS  | Per-building sprites for colony screen                    |
| TERRAIN.SS   | Per-terrain textured ground (re-extracted 2026-04-25)     |
| WOODFRAM.SS  | Wood frame for in-construction buildings                  |
| WOODTILE.SS  | Floor tile texture                                         |

### On-demand (loaded when entering colony / Europe screens)

| File         | Role                                                       |
|--------------|------------------------------------------------------------|
| COLONY.SS    | Colony screen widgets (worker slots, etc.)                |
| EUROPE.SS    | Europe screen widgets (dock, ships, recruit pool)         |
| MENU.SS      | Menu / dialog widgets                                      |
| CC-NN.SS     | Founding Father portraits (NOT unit sprites — see CLAUDE.md) |

### Special

| File         | Role                                                       |
|--------------|------------------------------------------------------------|
| BDARK.SS     | **ORPHAN — NEVER LOAD** (per CLAUDE.md)                   |

@ref `../formats/SS.md`

## Packed images (.PIK, 35 files)

PIK files are CVPC-compressed full-screen backgrounds:

| File         | Role                                                       |
|--------------|------------------------------------------------------------|
| TITLE.PIK    | Title screen background                                    |
| INTRO.PIK    | Intro screen                                                |
| COLONY.PIK   | Colony screen background                                   |
| EUROPE.PIK   | Europe screen background                                   |
| INDEPDAY.PIK | Independence Day animation                                 |
| KING_WIN.PIK | King wins ending                                           |
| HOF.PIK      | Hall of Fame background                                    |
| ...          | (event popups, dialog backgrounds)                         |

@ref `../formats/PIK.md`

## Fonts (.FF, 5 files)

| File         | Role                          | Used by (byte-verified)        |
|--------------|-------------------------------|--------------------------------|
| FONTTINY.FF  | Default / body font           | reports, status, popups, stockpile counts ([0x89E] @0x0760E8) |
| FONTINTR.FF  | Menus / titles                | main menu, dropdowns, new-game pickers ([0x268A] @0x0760C2) |
| FONTKING.FF  | King-audience font            | King audience (on demand @0x0754F2) |
| FONT-NP.FF   | Newspaper / woodcut font      | event-report woodcut (on demand @0x06B7AB) |
| FONTSMAL.FF  | (on disk; NOT loaded)         | **orphan — never referenced by VICEROY.EXE** |

> Corrected 2026-05-30: FONTMED/FONTLARG/FONTBOLD/SYMBOLS were **fabricated** (no
> such files/strings). See docs/UI_FIDELITY.md "Fonts" for byte citations.

@ref `../formats/FF.md`

## Maps (.MP, 4 files)

| File         | Role                                                       |
|--------------|------------------------------------------------------------|
| AMER2.MP     | Default map — Earth's American continent                   |
| AMER3.MP     | Larger continent variant                                   |
| BLANK4.MP    | Mostly water (testing)                                     |
| ONE.MP       | Single small island (AI testing)                           |

@ref `../formats/MP.md`

## Text resources (.TXT, 18 files)

| File         | Role                                                       |
|--------------|------------------------------------------------------------|
| NAMES.TXT    | All named entities: terrain, units, buildings, FFs, tribes |
| GAME.TXT     | In-game messages and alerts                                |
| MENU.TXT     | Menu strings (Main, Colony, Europe, dialogs)              |
| LABELS.TXT   | UI labels                                                   |
| TRIBE.TXT    | Native tribe descriptions                                  |
| FATHER.TXT   | Founding father descriptions                               |
| TUTORIAL.TXT | Tutorial text                                               |
| HELP.TXT     | In-game help                                                |
| CREDITS.TXT  | Credits roll                                                |
| README.TXT   | Game info                                                   |
| EVENTS.TXT   | Event popup text                                           |
| ...          | (specific to dialog/screen)                                |

@ref `../formats/TXT.md`

## Audio data (.COL, .BIN)

| File          | Role                                                       |
|---------------|------------------------------------------------------------|
| ASOUND.COL    | Adlib music/sound config (instrument tables, song defs)   |
| GSOUND.COL    | General MIDI variant                                       |
| PSOUND.COL    | PC speaker variant                                         |
| RSOUND.COL    | Roland MT-32 variant                                       |
| CONFIG.COL    | Audio device config                                         |
| COLDIG.BIN    | Digitized samples (PCM 8-bit unsigned, 11025 Hz)          |

@ref `../formats/COL.md`, `../formats/BIN.md`

## Movie / scripted (.MOV)

| File         | Role                                                       |
|--------------|------------------------------------------------------------|
| AMERICA.MOV  | Intro animation script (572 bytes — NOT a video)          |

Played by OPENING.EXE; sets the camera path over the AMER2.MP map for the
intro fly-in.

@ref `../formats/MOV.md`

## Configuration data (.DAT)

| File         | Role                                                       |
|--------------|------------------------------------------------------------|
| CYCLE.DAT    | Color cycling table (34 bytes, water animation)            |
| PATH.DAT     | Pre-computed pathfinding aids                               |
| HALLFAME.DAT | Top 10 high scores                                          |
| INSTALL.DAT  | Installation manifest (used by INSTALL.EXE)                |

@ref `../formats/DAT.md`

## Standard format (PCX, GIF)

| File         | Role                                                       |
|--------------|------------------------------------------------------------|
| TITLE.PCX    | (alternate title image, may be unused)                    |
| INSTALL.GIF  | Installer banner — out of scope                            |

## Save files

Files matching `*.SAV` in user save directory:

| Pattern        | Role                                                     |
|----------------|----------------------------------------------------------|
| GAMEnnnn.SAV   | User save slots                                          |
| AUTO.SAV       | Auto-save (every N turns)                                |

@ref `../include/save.h`

## Asset → loader cross-reference (provisional)

```
VICEROY.PAL   → load_palette()         at _main() boot
ICONS.SS      → load_sprite_sheet()   at _main() boot
PHYS0.SS      → load_sprite_sheet()   at _main() boot
BUILDING.SS   → load_sprite_sheet()   at _main() boot
TERRAIN.SS    → load_sprite_sheet()   at _main() boot
WOODFRAM.SS   → load_sprite_sheet()   at _main() boot
WOODTILE.SS   → load_sprite_sheet()   at _main() boot
NAMES.TXT     → load_text_resource()  at _main() boot
GAME.TXT      → load_text_resource()  at _main() boot
MENU.TXT      → load_text_resource()  at _main() boot
LABELS.TXT    → load_text_resource()  at _main() boot
AMER2.MP      → load_map()             when new game starts
TITLE.PIK     → load_pik()             at title screen entry
COLONY.PIK    → load_pik()             on colony screen entry
EUROPE.PIK    → load_pik()             on Europe screen entry
ASOUND.COL    → load_audio_config()   at sound init
COLDIG.BIN    → load_sample_bank()    at sound init
HALLFAME.DAT  → load_hallfame()       at endgame screen
*.SAV         → load_savegame()       on user load
```

@ref `ARCHITECTURE.md` for boot sequence, `../src/load_image/*.c` for
     overlay-resident loaders.
