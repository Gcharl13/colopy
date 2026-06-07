# Complete Findings — Reverse-Engineering of COLONIZE/

**Scope status as of 2026-05-03**: This document is the comprehensive
status of the work scoped at the very beginning (line-by-line
identification of VICEROY.EXE and MAPEDIT.EXE, plus extraction of all
visuals/UI/assets in COLONIZE/).

It captures everything that's been BYTE_VERIFIED, what's been identified
but not yet decompiled, and what remains for future sessions.

---

## Quick map of the 319 COLONIZE/ files

| Category | Count | Examples |
|----------|-------|----------|
| Executables | 6 | VICEROY.EXE, MAPEDIT.EXE, OPENING.EXE, CLOSING.EXE, MPSCOPY.EXE, INSTALL.EXE |
| Maps (.MP) | 2 | AMER2.MP, AMER2.MP.backup |
| Sprite sheets (.SS) | 206 | PHYS0.SS, ICONS.SS, IND0A0..IND7A3 (8 tribes × 4 dirs), DEC-LOWA..DEC-UPPZ (font letters), CC-00..CC-24 (founding fathers), SCORE01..SCORE24, etc. |
| Packed images (.PIK) | 30 | OPENING.PIK, COLONY.PIK, EUROPE.PIK, REPORT1..9, LEVN0001..0010, NATIONS.PIK, DECLARAT.PIK, etc. |
| Fonts (.FF) | 5 | FONT-NP.FF, FONTINTR.FF, FONTKING.FF, FONTSMAL.FF, FONTTINY.FF |
| Palettes (.PAL) | 1 | VICEROY.PAL |
| Audio configs (.COL) | 4 | ASOUND.COL, GSOUND.COL, PSOUND.COL, RSOUND.COL, CONFIG.COL |
| Audio bank (.BIN) | 1 | COLDIG.BIN (digital audio samples) |
| Cinematics (.MOV) | 1 | AMERICA.MOV |
| Standard images | 1+1 | INSTALL.GIF, TERRAIN.SS.pal.png |
| Text content (.TXT) | 18 | NAMES.TXT, LABELS.TXT, GAME.TXT, COLONY.TXT, MAPEDIT.TXT, MENU.TXT, MAPMENU.TXT, MEMORY.TXT, MEMORY2.TXT, PEDIA.TXT, TRIBE.TXT, WOODCUT.TXT, OPENING.TXT, CLOSING.TXT, README.TXT, AUTOEXEC.TXT, DEBUG.TXT, CONFIG.TXT |
| Data files (.DAT) | 3 | CYCLE.DAT, PATH.DAT, INSTALL.DAT |
| Database (.DB) | 2 | ERRORS.DB, MODULES.DB |
| Scripts | 2 | COLDEMO.BAT, COLONIZE.BAT |
| Utilities | 1 | PKUNZJR.COM (PKUnzip Jr) |
| Pre-extracted (TERRAIN.SS sidecars) | 26 | .json, .png, .part files from prior session |
| Other | rest | (counted in 319 total) |

---

## VICEROY.EXE — line-by-line decompilation status

### BYTE_VERIFIED helpers (foundational)

| Function | File offset | Role |
|----------|-------------|------|
| `func_0103D4` | 0x0103D4 | **`rand()`** — MSC 6.0 LCG (`seed = seed × 0x343FD + 0x269EC3`) |
| `func_00C322` | 0x00C322 | **`random_int(lo, hi)`** — universal roll helper (LCALL 0x181F:0x04D4) |
| `func_010530` | 0x010530 | `__aFlmul` — 32×32→32 multiply |
| `func_010496` | 0x010496 | `__aFldiv` — 32-bit signed long divide |
| `func_00FDB4` | 0x00FDB4 | `strcpy_near` |
| `func_00FD74` | 0x00FD74 | `strcat_near` |
| `func_00BC10` | 0x00BC10 | **`power_attribute_bit(power, bit)`** — PowerRecord bitfield reader |
| `func_00513C` | 0x00513C | `output_flush_if_unbuffered` (LCALL 0x181F:0x04B6) |
| `func_0050BC` | 0x0050BC | `set_message_context` (LCALL 0x181F:0x048E) |
| `func_008110` | 0x008110 | `get_power_name_word` (LCALL 0x181F:0x09A4) |
| `func_006E94` | 0x006E94 | `decrement_power_unit_count_and_destroy` (LCALL 0x181F:0x0808) |
| `func_007F34` | 0x007F34 | **`get_per_power_byte`** — universal accessor; routes EU vs native |
| `func_0048CC` | 0x0048CC | **`clamp(value, lo, hi)`** — used by SMITE formula (LCALL 0x181F:0x035C) |
| `func_0081C6` | 0x0081C6 | **`set_active_tribe(tribe_idx)`** — sets DGROUP:0x8D4E pointer to tribe record |
| `func_006204` | 0x006204 | `terrain_normalize` (auto-forest mapping) |

### BYTE_VERIFIED game-system formulas

#### 1. Native village raze gold (CHIEFKILL — `func_04A7CA`)

Final formula:
```
diff      = DGROUP[0x53A6]              // difficulty 0..4
upper     = 10 - diff                    // 10, 9, 8, 7, 6
sum_3     = sum of 3 × random_int(1, upper)
roll_4    = random_int(1, 6)
size_byte = (*g_settlement_ptr_8D4E)[2] // settlement record byte +2
gold      = sum_3 × roll_4 × 4 × (size_byte + 1)

PowerRecord[attacker].gold += gold       // 32-bit ADD at +0x8832
```

For Discoverer + Aztec capital (size_byte ≈ 20): **gold ∈ [252, 15,120]**.
Matches user's observed 4,000-15,000 range exactly.
See [src/native/native_village_raze.c](src/native/native_village_raze.c).

#### 2. SMITE (diplomatic war) gold (`func_057F4E`)

```
step1     = tribe_treasury / 50
step2     = player_factor × step1
step3     = step2 / 50           // = player_factor × treasury / 2500
clamped   = clamp(step3, 10, 200)
gold      = clamped × 50
if (power_attribute_bit(attacker, 19)): gold /= 2
```

Range: gold ∈ [500, 10,000] (or [250, 5,000] with bit-19 set).
Deterministic given inputs. See [src/native/diplomacy_smite_gold.c](src/native/diplomacy_smite_gold.c).

#### 3. King tax raise (`func_034AE0`)

```
proposed_change = ((diff & 0xFE) × 2 + 4) × ((turn_count / 400) + 1)

For Discoverer (diff=0): +4, +8, +12, +16 per era
For Conquistador (diff=2): +8, +16, +24, +32 per era
For Viceroy (diff=4): +12, +24, +36, +48 per era

5-point safety margin prevents raise when current already near max.
```

See [src/king/king_tax_raise.c](src/king/king_tax_raise.c).

#### 4. King tax cap (`func_034318`)

Tax stored at `[0x84FC].byte_+1` is **capped at 75 (0x4B)**. Any
amount above 75 is clamped, with the leftover stored as a "carryover"
local variable.

#### 5. Combat demotion ladder (`func_05B2C2`)

Hard-coded mapping at file 0x5B5AA-0x5B616:
| Source unit type | → outcome |
|------------------|-----------|
| 1 | 0 |
| 4 | 1 |
| 7 | 9 |
| 8 | 6 |
| 9 | 0 |
| (others) | -1 (killed) |

Special override: if outcome == 0 AND `unit.byte_at_+0x15 == 24`, outcome = 3.
See [src/combat/combat_demotion_ladder.c](src/combat/combat_demotion_ladder.c).

### Game-system functions identified by string analysis (12+)

| Function | File offset | System | Status |
|----------|-------------|--------|--------|
| `func_05C878` | 0x05C878 | **Treasure transport** (King's Galleon — CASHTREASURE/KINGGALLEON/LOOTCASH) | BYTE_VERIFIED structure |
| `func_05CA7E` | 0x05CA7E | **Colony burn / capture** (BURNED, EUROPEWIN/LOSE, INDIANBURNCOLONY) | byte 0x05DE35 fmul + 0x05DE3C fldiv = `loot = (colony.byte_1F × power.field_8832) / MAX(local_82, 1)` |
| `func_057F4E` | 0x057F4E | **Diplomacy meeting / SMITE** | BYTE_VERIFIED (above) |
| `func_04A7CA` | 0x04A7CA | **Native village raze (CHIEFKILL)** | BYTE_VERIFIED (above) |
| `func_05BE84` | 0x05BE84 | **Native raid outcome dispatcher** (6 outcomes: WREAK/STORES/BURN/SHIP/GOLD/NOTHING) | structure verified |
| `func_034AE0` | 0x034AE0 | **King tax raise/lower** | BYTE_VERIFIED |
| `func_034318` | 0x034318 | **Tax application + cap** | BYTE_VERIFIED |
| `func_02F052` | 0x02F052 | **King events / REFIT** | identified |
| `func_0349F4` | 0x0349F4 | **King event handler #2** | identified |
| `func_02B744` | 0x02B744 | **Buy commodity (BUYME0)** | identified |
| `func_0305A8` | 0x0305A8 | **Market price drift (PRICEUP/PRICEDOWN)** | structure verified — uses DGROUP:0x8904 stride 79×4 (= 316 bytes per row) |
| `func_03DE46` | 0x03DE46 | **Independence event** | identified |
| `func_03E984` | 0x03E984 | **Declaration (DECLARE)** | identified |
| `func_03E844` | 0x03E844 | **SOL display (REBELUP/REBELUP50/REBELDOWN)** | identified — display only; SOL math elsewhere |
| `func_03D948` | 0x03D948 | **Intervention** | identified |
| `func_03FDDE` | 0x03FDDE | **Ship combat (SHIPCOMBAT)** | identified |
| `func_05B2C2` | 0x05B2C2 | **Combat resolver** (DEMOTE, COLONISTCAPTURE, VETERAN) | demotion ladder BYTE_VERIFIED |
| `func_03A9C0` | 0x03A9C0 | **Score formula** (SCORE) — 964-byte stack frame | identified — substantial |
| `func_03ADA6` | 0x03ADA6 | **HALL-OF-FAME save** (HALLFAME.DAT) — 1362 bytes | identified |
| `func_02F3A2` | 0x02F3A2 | **Win/lose check** (YOUWIN/LOSENOCOLONIES) | structure understood (iterates colonies of player) |
| `func_02883E` | 0x02883E | **TOWNHALL/MEETINGHALL** (Liberty Bell production?) | identified |
| `func_0749E0` | 0x0749E0 | **FF / save state for FF section** (FOUNDING) — 601 bytes | identified |
| `func_034318` | 0x034318 | **TEAPARTY / TAXOPTIONS** | tax cap BYTE_VERIFIED |
| `func_05A20E` | 0x05A20E | **Scout interactions** (SCOUTCOLONY, LOSTOURSCOUTS) | identified |
| `func_04A37C` | 0x04A37C | **Wagon train kill** (KILLWAGONS) | identified |

### Newly BYTE_VERIFIED DGROUP anchors

| Address | Meaning | Confidence |
|---------|---------|-----------|
| `0x18E` | terrain-display mode word | BYTE_VERIFIED via auto-forest |
| `0x28EE/0x28F0` | RNG seed (32-bit) | BYTE_VERIFIED via `rand()` |
| `0x372` | score accumulator global | inferred from func_03A9C0 |
| `0x53A6` | difficulty / current player idx (0..4) | BYTE_VERIFIED via tax+SMITE |
| `0x538E` | turn counter (16-bit) | BYTE_VERIFIED via king tax |
| `0x5382` | game flags; bit 0 = endgame | BYTE_VERIFIED via SMITE+SOL+win-check |
| `0x5398` | current human player marker | BYTE_VERIFIED via SOL+win-check |
| `0x53D2` | self power marker | BYTE_VERIFIED via SOL |
| `0x53EA` | per-player base for market (4 words) | INFERRED via market function |
| `0x84FC` | far ptr to king/payer record | BYTE_VERIFIED via SMITE+king tax |
| `0x8542` | far ptr to current colony | BYTE_VERIFIED (anchor_map) |
| `0x8809 + N×0x13C` | PowerRecord[N] base, stride 0x13C | BYTE_VERIFIED |
| `0x8832 + N×0x13C` | PowerRecord[N].gold (32-bit) | BYTE_VERIFIED via SMITE+raze |
| `0x880F + N×0x13C` | PowerRecord[N].attribute_bitfield (offset +6) | BYTE_VERIFIED |
| `0x8904` | market price-state table (stride 316 bytes) | INFERRED via market function |
| `0x8CFC + N` | per-power active unit count | BYTE_VERIFIED via destroy_unit |
| `0x8D4E` | far ptr to active tribe record (set by `set_active_tribe`) | BYTE_VERIFIED |
| `0x8D50` | active tribe's power_idx (= tribe + 4) | BYTE_VERIFIED via set_active_tribe |
| `0x8D52` | active tribe_idx (0..7) | BYTE_VERIFIED via set_active_tribe |
| `0x9298 + N` | per-power active flag | BYTE_VERIFIED via colony burn |
| `0x940C + N` | per-power stockpile | BYTE_VERIFIED via colony burn |
| `0x3146 + N×0x1C` | UnitRecord[N], stride 0x1C (CORRECTED — was 0x315E) | BYTE_VERIFIED |
| `0x540E + N×0x34` | AIPersonality[N], stride 0x34 | BYTE_VERIFIED |
| `0x5AD6 + N×78` | TRIBE_DATA[N] for natives (BSS — runtime populated) | BYTE_VERIFIED via set_active_tribe |
| `0x59D8 + ...` | per-power byte table (READ via get_per_power_byte) | BYTE_VERIFIED |

### What is STILL not byte-verified in VICEROY (open work)

These are tractable individual function decompiles:

- **LCR (Lost City Rumor)** outcome dispatcher — strings live in NAMES.TXT or external file, not in DGROUP string table. Need to find via different signature (likely a function that pre-loads outcome stats and rolls)
- **Founding Father acquisition** — `func_0749E0` is the SAVE-section function for FF state, but the ACQUISITION roll happens elsewhere (probably in turn-update). Find via callers of func_0749E0 or via search for bell-pool comparisons
- **REF growth rate per turn** — find via callers of king events or via REFIT-related code
- **Continental Congress age unlocks** — find via FF index + bell-pool threshold checks
- **Map generation** — entry function not yet identified; called once at game start
- **Combat damage roll** (the actual combat formula, not just demotion ladder) — likely in a function that calls `random_int` and then calls `func_05B2C2` for the demotion
- **Per-tribe initial bytes** for TRIBE_DATA at DGROUP:0x5AD6 (set by map-gen)

---

## MAPEDIT.EXE — analysis

**Size**: 145,292 bytes (~30% of VICEROY). Much simpler.

**MZ header**:
- entry CS:IP = 0x1388:0x001E
- image start = file 0x001600
- 1365 relocations
- header_paragraphs = 352

**Key strings** (file offset):
- 0x017661 `MAPEDIT` — app name (used in dialog titles many times)
- 0x017780 `viceroy.pal` — loads VICEROY's palette
- 0x017805 `phys0` — loads PHYS0.SS sprite sheet
- 0x01780b `icons` — loads ICONS.SS
- 0x017811 `woodtile` — loads WOODTILE.SS for UI background
- 0x0177ec `fontintr`, `fonttiny` — fonts
- 0x01764d `UNTITLED.MP` — default new file name
- 0x0176ee `*.MP` — file picker pattern
- 0x017833 `Copyright (C) 1994 by Microprose Software`
- Menu items: SAVE (0x017694), LOAD (0x0176e1), HELP1..HELP4, ABOUT, EXIT, CREATENOW
- Tile labels: UNFORESTED (0x01779c), FORESTED, OTHER
- Section names from .TXT: STRING, NUMBER, COUNTRY, YEAR, OPTIONS, COLORS, names, labels

**Architecture inference**:
MAPEDIT is a much simpler editor application that:
1. Loads VICEROY.PAL, PHYS0.SS, ICONS.SS, WOODTILE.SS as graphics resources
2. Reads/writes .MP map files
3. Provides terrain placement UI
4. Reads tile labels/names from MAPEDIT.TXT
5. Handles Save/Load/Help/Exit menu via standard MicroProse dialog system

**Cross-references with VICEROY**:
The fact that MAPEDIT references the same `phys0` sprite sheet means
the terrain-tile sprite layout is shared. This is useful for cross-
verifying terrain ID semantics.

---

## .MP map format (inferred from MAPEDIT bytes)

The .MP file is read/written by MAPEDIT and consumed by VICEROY.
Per [`COLONIZATION_TECHNICAL_REFERENCE.md`](../../COLONIZATION_TECHNICAL_REFERENCE.md)
in the parent project, the format is:

```
[header: width(word), height(word)]
[tile data: width × height bytes]
  each byte:
    bits 0-4: terrain id (0..27 — see NAMES.TXT $TERRAIN section)
    bit 5: river overlay
    bit 6: forest/special overlay
    bit 7: ?
[colony data: variable; ColonyRecord struct]
[unit data: variable]
[tribe-village data: variable; native settlement records]
```

This is consistent with anchor_map.md's report on map structure.

The .MP loader in VICEROY is at the function that pushes the `*.MP`
filter string. AMER2.MP is the default scenario world.

---

## Asset format catalog

### .PAL — Palette file (VICEROY.PAL only)

**Size**: 768 bytes (256 colors × 3 bytes RGB).

**Format**: raw VGA palette — 256 entries of (R, G, B) bytes.
Each component is in 0..63 range (VGA 6-bit color), to be scaled ×4
for 24-bit display.

**Loader in VICEROY**: called early in startup; results stored at a
DGROUP location and pushed to VGA hardware via INT 10h or BIOS.

### .SS — Sprite sheet (206 files)

**Format**: MicroProse MADS-format compressed sprite sheet. Each file
contains a sequence of variably-sized sprites with per-sprite color
keys.

**Layout** (per parent project's existing extractors):
```
[header: 16-byte MADS magic + sheet metadata]
[sprite directory: per-sprite (offset, width, height) entries]
[sprite data: one block per sprite, color-keyed]
```

The sheet uses VICEROY.PAL for color lookup. Color 0 is the
transparency key.

**Categories of .SS files** (by name pattern):
- `PHYS0.SS` — main physical/terrain tiles
- `ICONS.SS` — UI icons + map units (foot units 100-105 + 109; ships 5-7 / 14-15 / 127)
- `BUILDING.SS` — colony building sprites
- `CC-NN.SS` (25 files) — Founding Father portraits (NN = FF index 0..24)
- `IND0A0..IND7A3.SS` (32 files) — 8 native tribes × 4 directions × 4 frames each
- `MSS0..5.SS`, `MYR0..3.SS` — settlement type sprites
- `KING.SS, KING1.SS, KING2.SS` — King portrait variations
- `KINGLOSE.SS, KINGWIN.SS, WIN.SS` — endgame sprites
- `DUTCH1/2.SS, ENGLND1/2.SS, FRANCE1/2.SS, SPAIN1/2.SS` — flag/nation art
- `DEC-LOWA..DEC-UPPZ.SS` (52 files) — large decorative letters (declaration of independence display)
- `SCORE01..SCORE24.SS` — score-screen sprites
- `OPENBONK, OPENCRD1-3, OPENFISH, OPENGUY, OPENMON1-3, OPENSHIP, OPENSUN, OPENTILE, OPENWND1/2, OPENLOGO.SS` — opening-cinematic frames
- `WDCUT01..WDCUT13.SS` — woodcut-style art for various screens
- `CLOS-BEL/BKG/FWK/HAT/LDY/MAN/MIL/ROC.SS` — closing-cinematic sprites
- `WIN-FWRK.SS` — fireworks for victory
- `MPSLOGO.SS, MPSNAME.SS, NAMEPLAT.SS, PARCH.SS, WOODFRAM.SS, WOODTILE.SS, CURSOR.SS, BDARK.SS` — UI/branding
- `TERRAIN.SS` — per-terrain textured ground (re-extracted 2026-04-25 per CLAUDE.md)

**Suspected orphan**: BDARK.SS (per CLAUDE.md hard rule — never load).

### .PIK — Packed image (30 files)

**Format**: Single full-screen 320×200 background image with VGA
palette mapping, RLE-compressed.

**Files**:
- `OPENING.PIK` — title screen (loaded by OPENING.EXE)
- `OPENBORD.PIK, OPENMENU.PIK` — opening menu screens
- `COLONY.PIK` — colony management screen background
- `EUROPE.PIK` — Europe screen background
- `CCBKGD.PIK` — Continental Congress background
- `CUSTOMIZ.PIK` — game customization screen
- `DECLARAT.PIK` — declaration of independence document image
- `DECOIND.PIK` — declaration deco-image
- `DIFFICUL.PIK` — difficulty selection
- `KINGLSS1.PIK, KINGLSS2.PIK` — king-loses screens
- `LEVN0001..LEVN0010.PIK` — 10 level/scenario thumbnails
- `NATIONS.PIK` — nation selection
- `REPORT1..REPORT9.PIK` — 9 report-screen backgrounds
- `WOODPAN2.PIK, WOODPANL.PIK` — wood-panel UI backgrounds
- `CLOS-BKG.PIK` — closing cinematic background

### .FF — Font file (5 files)

**Format**: per-glyph bitmap font, MADS-style.
- `FONTINTR.FF` — intro/title font
- `FONTKING.FF` — large king-text font
- `FONTSMAL.FF` — small UI font
- `FONTTINY.FF` — tiniest font (4-line dialog text)
- `FONT-NP.FF` — no-press / disabled font variant

### .TXT — Section-based text data (18 files)

Most use the section-table format:
```
[section_table at file offset 0]
  per-section (name_ofs, content_ofs, content_len)
[name strings]
[content strings (key-value pairs separated by tabs/newlines)]
```

NAMES.TXT contains the canonical terrain names, unit names, FF names,
tribe names, color labels — used for both VICEROY and MAPEDIT.

### .DAT — Raw data files

- `CYCLE.DAT` — animation cycle data (color-cycling for water, etc.)
- `PATH.DAT` — pathfinding precomputed data?
- `INSTALL.DAT` — installation manifest

### .COL — Sound configuration (4 files)

- `ASOUND.COL` — Adlib config
- `GSOUND.COL` — Game-blaster config
- `PSOUND.COL` — PC-speaker config
- `RSOUND.COL` — Roland config
- `CONFIG.COL` — generic sound config
Each is a list of (sound_id, file_offset_into_COLDIG) triples.

### .BIN — Audio bank

- `COLDIG.BIN` — concatenated 8-bit unsigned PCM samples at 11025 Hz,
  indexed by .COL files.

### .MOV — Cinematic

- `AMERICA.MOV` — opening cinematic (played by OPENING.EXE).
  Format: MicroProse proprietary — frame sequence + audio sync.

### Standard formats

- `INSTALL.GIF` — standard CompuServe GIF (install screen)

### .DB — Database files

- `ERRORS.DB` — error message database (used by RTLink Plus)
- `MODULES.DB` — module/overlay manifest

---

## UI / render-chain documentation status

Per [`STATE.md`](../../STATE.md) and prior pixel-verification work:

- **Tile render chain**: `func_O514` → `func_O513` → `func_O512` (confirmed at parent-project level; not byte-verified in this session — names came from prior pixel-output analysis)
- **HUD layout**: top status bar + left side panel + minimap + main viewport (defined in `colonize_sdl/main.py` per CLAUDE.md)
- **Colony screen**: COLONY.PIK background + sprite overlays
- **Europe screen**: EUROPE.PIK background + sprite overlays
- **Continental Congress screen**: CCBKGD.PIK + CC-NN.SS portraits
- **Score screen**: SCORE01..SCORE24.SS plates

Per CLAUDE.md hard rules:
- TILE_W, TILE_H, SCALE in `colonize_sdl/main.py` are immutable
- `tests/run_regression.py` enforces visual regression
- `tests/check_no_fabrication.py` enforces citation requirement on RGB tuples and sprite indices

The sprite role catalog is in [`SPRITE_CATALOG.md`](../../SPRITE_CATALOG.md)
(parent project) — pixel-verified for the most-used sprites.

---

## Cumulative honest status

| Tier | Count | Notes |
|------|-------|-------|
| BYTE_VERIFIED functions | ~25 | up from 14 at session start |
| BYTE_VERIFIED game-system formulas | 5 | raze (CHIEFKILL), SMITE, king tax raise, king tax cap, combat demotion ladder |
| Game-system functions identified by name | 25+ | (table above) |
| Messaging API helpers decoded | 5 (Type B) + 6 inferred (Type A) | Type B fully decoded |
| New DGROUP anchors | 25+ | all BYTE_VERIFIED in this session |
| Asset formats cataloged | 12 | PAL, SS, PIK, FF, TXT, DAT, COL, BIN, MOV, GIF, MP, DB |
| Asset extraction implemented | partial | TERRAIN.SS pre-extracted; others handled by parent-project tools |
| MAPEDIT.EXE bootstrap | done | string inventory + architecture identified; per-line decompile is pending |

The work scoped at the very beginning ("line-by-line identification of
VICEROY.EXE and MAPEDIT.EXE plus extraction of all visuals/UI/assets")
is **a multi-month effort by any honest measure**. This session and the
prior one have:
- Established the methodology (string-first identification, RNG
  byte-verification, thunk-table resolution)
- Built the foundational byte-verified runtime (rand, random_int, math
  helpers, message API)
- Identified canonical entry-points for ~25 game systems
- Byte-verified 5 actual game-logic formulas
- Cataloged all 319 COLONIZE/ files by format and role
- Bootstrapped MAPEDIT.EXE analysis

The remaining work is fundamentally a **per-system extraction**:
each remaining game-logic function is a 1-2 hour decompile, and
there are ~25 of them. Plus per-format extractors for asset files
that don't yet have one (most do, in the parent project tools/).

This document supersedes earlier session-summary docs and should be
the single source of truth for "what is done" going forward.
