# Project State — Baseline Snapshot

**Last refreshed:** 2026-05-30
**Working tree:** `C:\Users\gregc\OneDrive\Desktop\COLOPY\` (you are here; the
old `colonization_project_full/clean/` framing below is STALE — see note).

> **2026-05-30 update**: Data-fabrication audit + whole-project declutter.
> - **Audit (user-flagged)**: the native tribe data was wrong (raze gold, tribe
>   types, Apache>Aztec wealth) — root cause: `data/*.c` + some `include/*.h`
>   were a pre-byte-verified layer of PLAYTHROUGH GUESSES of data that isn't in
>   the EXE (the game loads it from NAMES.TXT at runtime). A 5-domain audit
>   (buildings/market, units/classes, terrain, founding fathers, king/scenario)
>   confirmed nearly all `data/*.c` tables were fabricated.
> - **Fixed (rebuilt in place from NAMES.TXT, cited)**: data/{tribe_data,
>   scenario_starts, commodity_prices, building_costs, unit_classes,
>   terrain_yield}.c + include/{native,building,unit,market}.h. Each verified vs
>   extracted/text/NAMES_sections.json (@TRIBES/@LEVELS/@SCENARIO/@CARGO/
>   @BUILDING/@UNIT/@UNFORESTED/@FORESTED/@OTHER). native raze (func_04A7CA)
>   flagged: it multiplies by settlement byte+2 = OWNER, not size (re-trace TODO).
> - **Archived** to `_archive/cleanup_2026-05-30/`: fabricated+superseded files
>   (kings_demands.c, ff_effects.c, ai/colony_orders.c, combat/{modifiers,
>   demotion,resolve}.c — see fabricated_data/README.md) + generated render
>   output (build/, render_test_*.png, debug_*/) + scratch + duplicate exports.
> - **Clean tree**: root loose files 30->14; Ghidra exports relocated to
>   ghidra_export/. ff.h/effects.c/recruit.c + the byte-
>   verified src/ (combat/market/king/production) were confirmed CORRECT.
> - **Still TBD**: native behavioural params (aggression/pop/skills), the raze
>   size/wealth input re-trace, the price->coin curve. ~14 RULINGS 2026-05-30.

> **2026-05-29 update**: Overnight reconstruction run — major progress (24 git
> commits). The exact-C goal advanced from "~4% verified / core logic believed
> undisassembled" to a correctly-decoded overlay with **12 game subsystems
> promoted to byte-cited C**.
> - **Structural unlock**: RTLink thunk table resolved -> VP page directory cracked
>   (descriptor table @file 0x192F0) -> all 31 overlay pages RE-SEGMENTED at correct
>   bases (629 fns, 99.5% valid prologues) -> Type-A thunk->function cross-page call
>   graph. The "core logic missing" premise was wrong — it was mis-decoded; now
>   correct. New tooling: tools/{resolve_thunks,decode_overlay_pages_v2,
>   resegment_overlay,map_typeA_thunks}.py + code/VICEROY/*.json
>   + disasm_overlay_reseg/.
> - **Byte-verified C (src/, cite-or-TBD)**: combat, market (pricing/boycott),
>   colony production, AI dispatch, king (REF/demands), native (settlement/raid/
>   mission), mapgen, render chain (O514->O513->O512), diplomacy/treaty, founding
>   fathers, save, scoring, random-events, game-loop. Fabrications removed from each.
> - **4 struct bases nailed (zero-init method)**: UnitRecord 0x3144 (was 0x3146/
>   0x315E), NativeSettlement 0x54EC/18B (the 200-byte struct was fabricated), RNG
>   0x103D4, AIPersonality 0x540E (controller @+0x31=0x543F).
> - **~14 dated docs/RULINGS.md entries** record every cross-source conflict (incl.
>   OPEN: 0x53A7 anger-vs-year, +0x2A gold-vs-score). DOS saves = COLONY*.SAV (the
>   .COL format is Win16). LCR is procedural; weather/disease subsystems don't exist.
> - **Honest limits**: nothing compiles (MSC-6.0/dosbox toolchain staged at
>   C:\dos_toolchain but blocked on EXEPACK'd binaries); NAMES.TXT data tables +
>   overlay-thunk leaf helpers are TBD; behavioral-parity needs a COLONY.SAV reader.
> - **Done since**: test-harness fixes (fabrication guard scope, render_test.py
>   revived against the package, Godot off fabricated map.json), essential/ mirror
>   archived to _archive/essential_mirror_2026-05-29/.
> - **Remaining**: AIPersonality consumer-symbol polish (cosmetic — ~8 files read
>   correct bytes via the 0x543F-column view); data/ff_effects.c FF-effect model
>   (flagged non-canonical); plus the Honest-limits items above (toolchain-blocked).

> **2026-05-28 update**: Goal clarified + reconstruction kickoff.
> - **GOAL**: the deliverable is an exact reverse-engineered **C source** of
>   VICEROY.EXE (pre-compilation source). The Python (`colonize_sdl/`) and Godot
>   (`colonization_godot/`) ports are **test harnesses**, NOT the product.
> - **Version control**: this tree is now a **git repo** (previously none). The
>   150 MB Godot binary, `build/`, and regenerable catalogs are gitignored.
> - **Verification bar = behavioral parity** (the matching-recompile toolchain is
>   staged at `C:\dos_toolchain` but blocked on EXEPACK'd MSC 6.0 binaries).
> - **3 source-of-truth contradictions byte-verified & fixed** (see new
>   `docs/RULINGS.md` 2026-05-28 entries): UnitRecord base = **0x3146** (not
>   0x315E); NativeSettlement = **18 B @ 0x54EC** (the 200-byte/0x9100 struct was
>   fabricated); RNG byte-verified **@ file 0x103D4**.
> - **Disassembly reframe**: `0x181F`/`0x191F` are RTLink thunk-table addresses,
>   NOT undisassembled overlays — the core logic IS in `viceroy_overlay_full.asm`.
>   The real unlock is decoding the RTLink VP directory + re-segmenting (WIP).
> - **Coverage reality**: ~47 functions BYTE_VERIFIED vs ~1,167 SKELETON; "100%
>   cited" = @asm-comment coverage, NOT verification.
> - **STALE BELOW (pending full refresh)**: the "two trees / `clean/`" layout, the
>   folder map (omits `colonization_godot/`), and task **#114** (the main.py split
>   is DONE: main.py is now a 35-line shim) all predate today.
>
> **2026-05-05 update**: Major UI / asset / memory progress —
> 100-task plan in `docs/UI_TASK_PLAN_100.md`,
> master cross-reference in `docs/UI_DOCS_INDEX.md`.
> See "What's verified" below for added pinned facts.

This document describes **what is here, what runs, what's verified, and what
isn't**. Read it first if you're orienting in a new session. Pair it with
`CLAUDE.md`, which holds the prime directive and the agent roster.

---

## Project in one sentence

A pixel-faithful Python+pygame port of *Sid Meier's Colonization* (1994 DOS /
MicroProse), reconstructed by reverse-engineering the original VICEROY.EXE,
the Win16 colonize.exe build, and the .SS / .PIK asset files.

## Two trees

- **`clean/`** — the curated tree. Only files that are either (a) actively used
  by the running game, or (b) primary reverse-engineering source-of-truth.
- **`clean/_archive/`** — superseded reconstructions, scratch renders, and
  one-off research writeups. See `_archive/MANIFEST.md`.

The original parent folder still has every loose file from the past months of
work. Don't edit there — work happens in `clean/`.

---

## What runs today

```bash
cd clean/

# The actual game
python colonize_sdl/main.py

# Headless render of one test map (writes render_test_<NAME>.png)
python tools/render_test.py ONE.MP        # also UNTITLED.MP, BLANK4.MP, AMER2.MP

# Visual regression suite (must pass after every rendering change)
python tests/run_regression.py
python tests/run_regression.py --update   # only with explicit user approval
```

Smoke status (verified inside `clean/` immediately after this reorg):
all six map render paths exercise without errors —
`_render_terrain`, `_render_units`, `_render_colonies`, `_render_minimap`,
`_render_messages`, `_render_right_panel`. The icon sheet (ICONS.SS) loads
with all 131 sprites.

---

## Folder map

```
clean/
├── CLAUDE.md                            agent prime directive + roster
├── STATE.md                             ← this file
├── PROJECT_BOARD.md                     ordered backlog
├── COLONIZATION_TECHNICAL_REFERENCE.md  accumulated team knowledge
├── SPRITE_CATALOG.md                    every sprite's role (sprite-cataloger)
├── MAP_FORMAT.md                        .MP byte format (map-format-decoder)
├── FUNCTIONS_INVENTORY.md               VICEROY.EXE functions (dos-disassembler)
├── ASSET_CATALOG.md                     extraction results table
├── TRUTH_HIERARCHY.md                   how to resolve cross-source conflicts
│
├── colonize_sdl/                        the runnable game (split 2026-05-02)
│   ├── main.py                          entry point (~30 LoC)
│   ├── _imports.py                      shared engine + leaf-module re-exports
│   ├── constants.py                     display geometry + asset paths
│   ├── dos_data.py                      DOS-text → parsed Python data
│   ├── states.py                        STATE_* enum + menu data
│   ├── palette.py                       VGA palette loader
│   ├── font.py                          BitmapFont
│   ├── sprites.py                       sheet + background loaders
│   ├── message_log.py                   in-game ticker
│   ├── market.py                        Europe market state
│   ├── unit_sprite_map.py               UNIT_* enum → ICONS.SS index
│   ├── menu_data.py                     MENU.TXT parser
│   ├── cc_sprites.py / cc_unit_map.py   CC-NN portrait helpers (FF dialogs)
│   ├── app/                             ColonizationApp class assembly via mixins
│   │   ├── __init__.py                  composes ColonizationApp from mixins
│   │   ├── init_world.py                __init__, init_game, map setup
│   │   ├── loop.py                      run / update / handle_input / dispatch
│   │   ├── input_handlers.py            all _key_* and _click_* handlers
│   │   ├── actions.py                   unit cmds, save/load, Europe trade
│   │   └── turn.py                      _end_turn cycle
│   ├── render/                          all _render_* methods
│   │   ├── __init__.py                  composes RenderMixin
│   │   ├── terrain.py                   _render_terrain + edges + coast (~890 LoC)
│   │   ├── entities.py                  units + colonies
│   │   ├── hud.py                       sidebar / minimap / menu / dropdowns
│   │   └── screens.py                   pre-game + auxiliary full-screen UIs
│   └── engine/                          headless game logic
│       ├── game.py, types.py, units.py
│       ├── widget_format.py             coltext0 widget-spec parser
│       ├── asset_loader.py              top-level asset pipeline
│       ├── cvpc_codec.py                CVPC PCX-RLE decoder (verified 69/69)
│       ├── hallfame_format.py, prefs.py HALLFAME.DAT / COLWIN.PRF I/O
│       └── …
│
│   See `docs/MODULE_LAYOUT.md` for the per-module charter and edit policy.
│
├── extracted/                           PNG-converted assets, ready to use
│   ├── assets/sprites/                  PHYS0, CC-00..24, BUILDING, ICONS,
│   │                                    WOODFRAM/TILE, TERRAIN, …
│   ├── assets/backgrounds/              *.PIK.png
│   ├── assets/fonts/                    FONTSMAL etc.
│   ├── disassembly/                     VICEROY.EXE dump (*.asm,
│   │                                    function_index.json)
│   ├── palette.json                     master 256-color VGA palette
│   └── text/                            MENU_sections.json, COLTEXT0 strings
│
├── COLONIZE/                            ORIGINAL DOS GAME FILES (read-only
│                                        source of truth; AMER2.MP, .SS, .PIK,
│                                        .TXT, .PCX, .EXE)
│
├── colowin/                             Win16 build of the game (DLL bundle)
│   ├── colonize.exe, coldata0..8.dll    Win16 NE binaries
│   ├── coltext0.dll                     717 in-game text strings
│   ├── HALLFAME.DAT, COLWIN.PRF         user state files
│   ├── decompiled/tools/                disasm.py, ne_resources.py
│   ├── docs/                            per-DLL resource catalogs,
│   │                                    UI_RECONSTRUCTION_GUIDE, etc.
│   └── extracted/                       Win16-side sprite/cursor/icon dumps
│
├── reference/                           DOSBox screenshots (DOS pixel ground
│                                        truth for visual-regression diffs)
│
├── tests/                               regression runner + goldens + the
│                                        no-fabrication CI guard
│   ├── run_regression.py
│   ├── check_no_fabrication.py
│   ├── golden/                          reference PNGs to diff against
│   └── regression/                      diff outputs (gitignored)
│
├── tools/                               extractors, decoders, debuggers,
│                                        atlas builders, render_test.py
│
├── docs/                                cross-source rulings + research notes
│   ├── RULINGS.md                       conflict-resolution log
│   ├── icon_catalog.png                 labeled icon reference (1280×3794)
│   ├── icon_catalog_verified.json       user-verified labels
│   ├── DOS_VISUAL_REFERENCE.md          observations from DOSBox screenshots
│   ├── RENDER_CHAIN_DISPATCH.md         func_O514 → O513 → O512 chain
│   ├── MAIN_PY_FABRICATION_AUDIT.md     fabrication-baseline scan
│   ├── COLTEXT0_INDEX.md                string ID index
│   ├── MOV_FORMAT.md                    AMERICA.MOV codec notes
│   └── WALKTHROUGH_ROADMAP.md           UI screen sequence
│
├── graphify-out/                        knowledge graph over the codebase
│   ├── GRAPH_REPORT.md
│   └── wiki/index.md
│
├── saves/                               in-game save files
│
└── _archive/                            see _archive/MANIFEST.md
```

---

## What's verified (pinned facts)

These have been checked against original artifacts and **must not be
re-litigated**.

- **CVPC bitmap codec** — PCX-style RLE on packed pixel bytes, byte-perfect
  against 69/69 extracted PNGs.
- **MS_SPRITE format** — 8-byte zero magic + LE16 width + LE16 height + 13
  metadata bytes + per-row (LE16 skip + LE16 run_count + run_count pixel
  bytes). Header length = 25 bytes for coldata0/3/5/6/8. coldata4 uses a
  different `c0fe...` prefix (decoder pending).
- **ICONS.SS** — 131 sprites at 16 px tall, indices 0-130, contiguous (no
  gaps). Contains all units, ships, buildings, and cargo icons. Foot units
  live at indices 100-105 + 109; ships at 5-7 / 14-15 / 127; cargo strip at
  22-37; nation colony flags at 118-121; rebel flag at 130.
- **Auto-forest range 8-23 (incl. Arctic, base 16)** — byte-verified at
  VICEROY.EXE 0x6204 and 0x6831B (2026-04-25). See `docs/RULINGS.md`.
- **PHYS0 sprite indices 0, 16, 100** — 1×1 placeholders, not real sprites.
  Their absence in atlases is expected.
- **Coast rendering** — PHYS0 rows 0x01 / 0x11 are RIVER sprites, not coast
  edges. Coasts come from sprites 150-153 plus the water-tile beach-halo
  mechanism.
- **Mountain/hills rows** — row 0x21 = mountains (snow peaks), row 0x31 =
  hills (brown rolling).
- **Sea-lane column** (right edge of map) — base terrain 26.
- **TERRAIN.SS** — re-extracted 2026-04-25; IS used by the renderer
  (overturned the 2026-04-21 "orphan" claim).
- **`func_O530`** is the map-editor dialog. The in-game tile-render chain is
  `func_O514` → `func_O513` → `func_O512`.
- **Terrain ID ordering** — use `extracted/text/NAMES_sections.json`,
  NOT `mapedit.c` (the C reconstruction is wrong about some terrain types).
- **Master palette** — extracted from `colowin/coldata5.dll` MS_PALETTE id
  9000, written to `extracted/palettes/master.pal` (JASC format).
- **Engine RNG** — Win16 LCG matched and ported into `engine/`.
- **Menu bar / status bar / hint strings** — sourced from
  `extracted/text/MENU_sections.json` and the coltext0 catalog, not
  hard-coded.
- **Unit map sprites** — pulled from ICONS.SS, NOT CC-NN (CC-NN are Founding
  Father portraits). Verified against the user's hand-labeled
  `docs/icon_catalog_verified.json`.

### 2026-05-05 — UI/memory verification batch

- **PowerRecord stride = 316 bytes** (0x13C), not 128. Verified by
  testing 4 records' gold values against in-game UI.
- **All 25 CC-NN founding-father portraits** visually identified
  and indexed against NAMES.TXT @FATHERS.
- **All 13 WDCUT event scenes** identified to event types.
- **All 8 IND tribe sprites** indexed per NAMES.TXT @TRIBES.
- **All 4 nation flag pairs** identified.
- **All 9 REPORT advisor PIKs** mapped to LABELS.TXT @MISC titles.
- **GAME.TXT** 510 message templates cataloged.
- **LABELS.TXT** 7 sections cataloged.
- **PEDIA.TXT** 163 indexed entries cataloged.
- **Boycott bitfield** at PowerRecord +0x20 (USER-VERIFIED).
- **King-anger byte** at DGROUP:0x53A7 (+1 per Tea Party,
  USER-VERIFIED).
- **REF array** at DGROUP:0x53DA..0x53E1, slot order
  (Reg / Cav / MoW / Art) — USER-VERIFIED.
- **NativeSettlement table** at DGROUP:0x54EC, stride 18 bytes,
  full record layout USER-VERIFIED.
- **CHIEFKILL formula** corrected — uses NativeSettlement +0x04
  (population), not TribeData +2.
- **Capital razes** confirmed to have a bonus on top of CHIEFKILL
  (Inca cap pop=13 → 15,000; Aztec cap pop=10 → 10,000).
- **ColonyRecord stockpile** at +0x9A: 16 × u16 in NAMES.TXT @CARGO
  order (RUNTIME-VERIFIED from Plymouth frame 1310196718 inventory
  matching exactly).
- **ColonyRecord colonist job-skills** at +0x40 (1 byte per
  colonist, NAMES.TXT @JOB index).
- **ColonyRecord tile-worker assignment** at +0x70 (8 bytes for
  surrounding tiles NW/N/NE/W/E/SW/S/SE, value = colonist idx
  in +0x40 array, 0xFF = empty).
- **ColonyRecord wealth** at +0xC2 (u32 — used in colony-burn loot).

For everything else, see `docs/RULINGS.md`.

---

## What's pending (open work)

From `PROJECT_BOARD.md` (open items only):

- **#62** — Replace fabricated right info panel with reverse-engineered DOS
  layout (in progress; needs `func_O514` trace).
- **#69** — Rebuild main menu / nation select / difficulty / name-entry from
  real PIK + dialog specs (in progress; some screens still partially
  fabricated).
- **#18** — Hit-test region extraction (deferred; needs WM_LBUTTONDOWN trace).
- **#70** — Re-verify coast/beach rendering against DOS pixel reference.
- **#74** — Trace nation/cargo color palette indices from VICEROY.EXE.
- **#75** — Trace context-sensitive status-bar hint selector.
- **#89** — Map terrain rendering audit pass vs DOSBox AMER2 screenshot.
- **#90** — Coast/beach blend rendering vs DOSBox reference.
- **#94** — CC sprite slicer (deferred — frame layout non-uniform).
- **#113** — Decode coldata4 MS_SPRITE format (other DLLs done).
- **#114** — Split `colonize_sdl/main.py` (~4,700 lines) into focused modules.

The full ordered list lives in `PROJECT_BOARD.md`.

---

## Source-of-truth hierarchy

When evidence conflicts, the higher-tier source wins. Documented in
`TRUTH_HIERARCHY.md`; restated here for orientation.

1. Original DOS files in `COLONIZE/` (binary game data, .SS, .PIK, .TXT,
   VICEROY.EXE).
2. Win16 build in `colowin/` (colonize.exe + coldata\*.dll, coltext0.dll —
   the same game as DOS but with friendlier resource layouts).
3. Extracted artifacts in `extracted/` (PNG / JSON conversions, byte-verified
   from sources 1-2).
4. DOSBox reference screenshots in `reference/dos/` (visual ground truth).
5. Reverse-engineered narrative docs (FUNCTIONS_INVENTORY.md, SPRITE_CATALOG.md,
   COLONIZATION_TECHNICAL_REFERENCE.md, MAP_FORMAT.md).
6. Project rulings (`docs/RULINGS.md`).
7. The Python port (`colonize_sdl/`) — DERIVED, not authoritative.

**Never trust** `_archive/mapedit_artifacts/mapedit.c` or anything under
`_archive/early_research/` as primary evidence. Both have been overturned by
re-checking sources 1-3.

---

## Hard rules for any session

1. **Never change `TILE_W`, `TILE_H`, `SCALE`** in `colonize_sdl/main.py`.
   The user has been explicit. Use internal buffers at other resolutions and
   scale down.
2. **Never load `BDARK.SS`.** Suspected orphan; not pixel-verified.
3. **Run `tests/run_regression.py` after every rendering change.** If it
   fails, either fix the regression or get explicit approval to update
   goldens. Do not silently overwrite goldens.
4. **Every new constant in `main.py` requires a citation comment** pointing
   to a VICEROY.EXE offset, a PHYS0 sprite index, or a `docs/RULINGS.md`
   entry. The CI guard in `tests/check_no_fabrication.py` enforces this.
5. **Never cite `mapedit.c`** as primary evidence. Cross-check against `.MP`
   byte data or VICEROY.EXE disassembly instead.
6. **One feature per change.** Coast refinement should not touch the Europe
   screen.

---

## How to add a new ruling

When you resolve a cross-source conflict:

1. Open `docs/RULINGS.md`.
2. Add a dated entry: which sources disagreed, which one wins, why.
3. If the ruling invalidates a fact in one of the catalog MDs
   (SPRITE_CATALOG, MAP_FORMAT, FUNCTIONS_INVENTORY,
   COLONIZATION_TECHNICAL_REFERENCE), edit those too.
4. If the ruling reverses something this STATE.md asserts, edit STATE.md.
5. Move any artifact the ruling demoted into `_archive/` with a manifest
   entry.

---

## Before ending a session

- Did every file edit come with a citation?
- Did `tests/run_regression.py` pass (or was an update explicitly approved)?
- Does `PROJECT_BOARD.md` reflect what was completed / newly started?
- If a conflict was resolved, is it written in `docs/RULINGS.md`?
- If a new fact was verified, is it in `SPRITE_CATALOG.md` /
  `MAP_FORMAT.md` / `FUNCTIONS_INVENTORY.md` /
  `COLONIZATION_TECHNICAL_REFERENCE.md`?
- If the layout of `clean/` changed, did STATE.md keep up?

If the answer to any of these is no, the work isn't done.
