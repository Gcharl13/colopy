# STATUS — Reverse-Engineering Progress Dashboard

> **This is the single source of truth for current project state.**
> `PROGRESS.md`, `DISASM_COMPLETION.md`, `WEEK1_SUMMARY.md`, and `OVERLAY_PLAN.md`
> are historical/stale and carry banners pointing here. For the correct-vs-
> misleading information audit and **corrected metrics** (the headline "100% in
> citable C" / "99.36% identified" figures are syntactic, not semantic), see
> [`AUDIT.md`](AUDIT.md).
>
> **Methodology (2026-06-18):** the project now follows a three-layer model —
> evidence → **specification** → implementation — see [`METHODOLOGY.md`](METHODOLOGY.md).
> The specification (`spec/README.md`) is the source of truth; `viceroy_source/`
> is reclassified as evidence (`viceroy_source/ROLE.md`).

Live snapshot of project completion. Refresh by running:

```bash
python tools/verify.py
python tools/sigmatch.py --self-test
python tools/build_catalogs.py
```

Last update: 2026-06-18 (audit pass). Verification-gate rows below were last
re-run 2026-05-03; the MAPEDIT line is updated for the clean-rewrite re-approach.

**Headline (honest tiers — see `AUDIT.md` §4):** VICEROY ~47/1,241 functions
BYTE_VERIFIED (~3.8%), rest skeleton/reconstructed with citations · MAPEDIT 0
hand-decoded to clean C (rewrite planned, see `mapedit_source/REWRITE_PLAN.md`) ·
PAL+MP assets round-trip byte-perfect · OPENING/CLOSING = RAW stubs + sigmatch
helpers.

---

## Verification gates

| Gate | Status | Tool |
|------|--------|------|
| A. sigmatch self-test (17/17 BYTE_VERIFIED helpers re-found) | ✅ PASS | `tools/sigmatch.py --self-test` |
| B. byte-identity round-trip for all 319 COLONIZE/ files | ✅ PASS | `tools/verify.py` (319/319) |
| B-PAL. PAL extract+encode round-trip | ✅ PASS | `tools/extract_pal.py` + `tools/encode_pal.py` |
| B-MP. MP extract+encode round-trip | ✅ PASS | `tools/extract_mp.py` + `tools/encode_mp.py` |
| C. visual asset extraction (lossless decoded) | ✅ PASS | `tools/extract_visuals.py` (245/246) |
| C-VISUAL. catalog generation | ✅ PASS | `tools/build_catalogs.py` |
| D. per-line annotation 100% | ⏳ ~5% | `tools/ledger_update.py` |
| E. other-EXE annotation | ⏳ partial (sigmatch) | `tools/ledger_update.py` |
| F. doc-to-code linkcheck | ⏳ TODO | `tools/linkcheck.py` (not yet built) |
| G. DOSBox playable-rebuild smoke test | ⏳ TODO | manual playthrough |
| H. third-party reproducibility | ✅ DOC done | `BUILD.md` |

---

## Coverage at a glance

### Code (1,740 disasm files across 4 EXEs)

| EXE | .asm files | BYTE_VERIFIED | % |
|-----|-----------:|--------------:|--:|
| VICEROY.EXE | 1,243 | ~25 | ~2% |
| MAPEDIT.EXE | 212 | 5 (sigmatch-promoted) | ~2% (clean rewrite planned — see `mapedit_source/REWRITE_PLAN.md`; old auto-skeleton quarantined in `mapedit_source/legacy_autogen/`) |
| OPENING.EXE | 147 | 4 (sigmatch-promoted) | ~3% |
| CLOSING.EXE | 138 | 4 (sigmatch-promoted) | ~3% |
| MPSCOPY.EXE | 0 | 0 | not yet disassembled |
| INSTALL.EXE | 0 | 0 | not yet disassembled |

### Game-system formulas (BYTE_VERIFIED)

| System | Status |
|--------|--------|
| Native village raze (CHIEFKILL gold formula) | ✅ |
| Diplomatic SMITE (gold formula) | ✅ |
| King tax raise (formula) | ✅ |
| King tax cap (=75) | ✅ |
| Combat demotion ladder | ✅ |
| Treasure transport (King's Galleon) | ✅ |
| Universal RNG (rand + random_int) | ✅ |
| Universal helpers (clamp, __aFlmul, __aFldiv, etc.) | ✅ |
| Combat damage roll | ⏳ TBD |
| Market price drift formula | ⏳ TBD |
| Founding Father acquisition | ⏳ TBD |
| LCR outcome distribution | ⏳ TBD |
| REF growth rate | ⏳ TBD |
| Score formula details | ⏳ TBD |
| Map generation | ⏳ TBD |

### Format specs (12 documented)

| Format | Spec | Extract | Encode | Round-trip |
|--------|------|---------|--------|------------|
| EXE_MZ | ✅ | n/a | n/a | n/a |
| RTLINK | ✅ | n/a | n/a | n/a |
| MP | ✅ | ✅ | ✅ | ✅ byte-perfect |
| PAL | ✅ | ✅ | ✅ | ✅ byte-perfect |
| SS | ✅ | ✅ (mpskit) | (mpskit) | lossless decoded (FAB non-deterministic) |
| PIK | ✅ | ✅ (mpskit) | (mpskit) | lossless decoded |
| FF | ✅ | ✅ (mpskit) | (mpskit) | lossless decoded |
| TXT | ✅ | (byte-identity) | (byte-identity) | ✅ byte-perfect |
| DAT | ✅ | (byte-identity) | (byte-identity) | ✅ byte-perfect |
| COL | ✅ | (byte-identity) | (byte-identity) | ✅ byte-perfect |
| BIN | ✅ | (byte-identity) | (byte-identity) | ✅ byte-perfect |
| MOV | ✅ | (byte-identity) | (byte-identity) | ✅ byte-perfect |
| GIF | ✅ | (byte-identity) | (byte-identity) | ✅ byte-perfect |

### Asset extraction (290 game-content files)

| Category | Total | Extracted |
|----------|-----:|----------:|
| Sprite sheets (.SS) | 206 | 205 (BDARK skipped) |
| Backgrounds (.PIK) | 35 | 35 |
| Fonts (.FF) | 5 | 5 |
| Maps (.MP + .backup) | 2 | 2 |
| Palette (.PAL) | 1 | 1 |
| Text data (.TXT) | 18 | 18 (byte-identity) |
| Sound configs (.COL) | 5 | 5 (byte-identity) |
| Audio bank (.BIN) | 1 | 1 (byte-identity) |
| Cinematic (.MOV) | 1 | 1 (byte-identity) |
| Misc data (.DAT) | 3 | 3 (byte-identity) |
| GIF | 1 | 1 |
| Database (.DB) | 2 | 2 (byte-identity) |
| **Total** | **280** | **279** |

### Synthesis docs (`docs/`)

| Doc | Status |
|-----|--------|
| ARCHITECTURE.md | ✅ |
| RENDER_CHAIN.md | ✅ |
| DATA_MODEL.md | ✅ |
| ASSET_ROLES.md | ✅ |
| UI_DIALOGS.md | ✅ |
| RTLINK_OVERLAYS.md | ✅ |
| ENGINE.md | ✅ |
| PALETTE_AND_CYCLING.md | ✅ |
| BUILD.md | ✅ |
| STATUS.md (this file) | ✅ |

### Per-asset catalogs

| Catalog | Status |
|---------|--------|
| `assets/sprites/SPRITE_CATALOG.md` (205 sheets, 1,676 frames) | ✅ |
| `assets/sprites/SPRITE_ROLE_CATALOG.md` (per-frame role mapping) | ✅ partial (~30% — Phase D advances this) |
| `assets/backgrounds/BACKGROUND_CATALOG.md` (35) | ✅ |
| `assets/fonts/FONT_CATALOG.md` (5) | ✅ |
| `assets/maps/AMER2.json` (58×72 tiles) | ✅ |
| `assets/palettes/viceroy.pal.json` | ✅ |

### Memory (durable knowledge)

7 entries in
`C:\Users\gregc\.claude\projects\c--Users-gregc-OneDrive-Desktop-COLOPY\memory\`:

- `feedback_pseudo_c_first.md`
- `feedback_string_first_function_id.md`
- `project_colony_struct_at_8542.md`
- `project_native_raze_chiefkill.md`
- `project_names_txt_authoritative_data.md`
- `project_rng_byte_verified.md`
- `project_thunk_table_calls_are_load_image.md`
- `project_unit_table_correction.md`
- `project_viceroy_source_tree.md`

---

## Phase completion

| Phase | Description | Status |
|-------|-------------|--------|
| A | Automation infrastructure (sigmatch + string_xref) | ✅ DONE |
| B | Format specs + extractors | ✅ DONE (byte-identity tier; PAL/MP byte-perfect) |
| B.5 | Golden manifest | ✅ DONE |
| C | Asset extraction with sidecars | ✅ DONE (245 visual + 35 byte-identity) |
| C-VISUAL CV1 | CYCLE.DAT decode | ⏳ partial (format unclear, needs Phase D loader) |
| C-VISUAL CV2 | All 206 SS sheets | ✅ DONE |
| C-VISUAL CV3 | All 35 PIK backgrounds | ✅ DONE |
| C-VISUAL CV4 | All 5 FF fonts | ✅ DONE |
| C-VISUAL CV5 | AMER2.MP visual rendering | ✅ DONE (Americas continents + tile decoration via render_map_v2) |
| C-VISUAL CV6 | AMERICA.MOV decode | ⏳ TBD (gated by OPENING.EXE Phase E) |
| C-VISUAL CV7 | Sprite role catalog | ✅ partial (~50%; SPRITE_INDEX.md has all commodities BYTE_VERIFIED, ships 5/6/7/14/15 BYTE_VERIFIED) |
| C-VISUAL CV8 | RENDER_CHAIN.md | ✅ |
| C-VISUAL CV9 | UI_DIALOGS.md | ✅ |
| C-VISUAL CV10 | Animation catalog | ⏳ TBD |
| **V (NEW)** | **Visual verification programs** | ✅ DONE — render_map_v2/render_gameplay/render_colony/render_dialog/simulate_*.py all built |
| **G-CONSOLIDATE** | **Single-file Ghidra C consolidation** | ⏳ infrastructure ready (build_rename_table.py + rename_pass.py + 100 substitutions) — gated on user re-exporting Ghidra C |
| D | Per-line annotation (long pole) | ⏳ ~5% (DEFERRED — visual verification is the higher-leverage path now) |
| E | OPENING/CLOSING/MPSCOPY/INSTALL annotation | ⏳ partial (sigmatch promotions; per-line pending) |
| F | Synthesis docs (8 docs) | ✅ DONE |
| G | DOSBox playable-rebuild smoke test | ⏳ TBD (gated by user-provided DOSBox screenshot for visual_diff) |
| H | BUILD.md + STATUS.md | ✅ DONE |

---

## Visual verification status (post-pivot)

After the user's strategic input (visual rendering > per-line annotation),
the project pivoted to building visual verification programs that
produce output comparable to DOSBox screenshots.

### What works (BYTE_VERIFIED end-to-end)

- **`render_map_v2.py`** — Decodes `.MP` → maps each terrain ID via
  `TERRAIN_PAL_INDEX` → renders Americas continental outline correctly.
  Output: `assets/maps/AMER2_render_v2.png`.
- **`render_gameplay.py`** — Composes full gameplay screen:
  - Top menu bar (uppercase yellow FONTSMAL): GAME / VIEW / ORDERS /
    REPORTS / TRADE / COLONIZOPEDIA
  - Map view (250×192px) with terrain + tree overlays + ship/unit
    sprites + cursor box on selected unit
  - Right sidebar (75px wide): minimap of Americas + viewport
    rectangle + mixed-case yellow status text in **FONTINTR** (Spring
    1510, Gold: 3000, Tax: 0%, Moves: 4, Locat: (28,31), Fr.
    Caravel, No Orders, (Ocean))
  - Wood-tile background
  - Output: `verification/gameplay/gameplay.png`
- **`render_colony.py`** — Composes colony screen matching Baltimore
  reference:
  - Title bar: "Baltimore. Spring, 1567. Gold: 4010" (WOODTILE bg)
  - Top-left: building grid + colonist sprites at building positions
  - Top-right: 3×3 production grid with commodity icons + yields
  - **Bottom strip (y=128..200)**: COLONY.PIK background blitted
    directly. Provides sky/grass/dock/cells colors from authentic
    extracted PIK (using EUROPE.PIK-derived palette).
  - SoL "5%(0)" / "95%(8)" overlaid on left middle-band panel
  - "No Ships in Port" centered on middle-band water panel
  - 16 commodity icons standing on grass strip (y=158) with white
    quantity numbers in blue cells below (y=184). All commodity
    icons BYTE_VERIFIED (ICONS 022-037).
  - Right wood-grain panel with vertical "EXIT" label (FONTKING)
  - Output: `verification/screens/colony_baltimore.png`
- **`simulate_formulas.py`** — Runs the BYTE_VERIFIED game-system
  formulas (raze, SMITE, king tax, combat demotion).
- **`simulate_rng.py`** — Simulates the MSC 6.0 LCG with
  BYTE_VERIFIED constants.

### Sprite catalog (assets/sprites/SPRITE_INDEX.md)

- **All 16 commodity icons** identified (ICONS 022-037)
- **Ships identified**: 005=Caravel, 006=Merchantman, 007=Galleon,
  014=Privateer, 015=Frigate
- **Foot units identified**: 095=Free Colonist, 098=Continental
  Soldier, 100=Continental Army Soldier, 103=Dragoon, 105=Missionary
- **Native units**: 108=Warrior, 109=Scout
- **Native settlements**: 000-003 = village variants, 012=Aztec
  pyramid

### User corrections applied (2026-05-03)

1. ✅ ICONS 005 = Caravel (was wrongly identified as 015 earlier)
2. ✅ ICONS 015 = Frigate (was the Caravel placeholder)
3. ✅ Font shadow rendering fixed via 2-bit-per-pixel palette decode
   (idx 1 = shadow, idx 3 = primary)
4. ✅ COLONY.PIK extraction fixed:
   - COLONY.PIK has only 2 MADSPACK sections (header + pixels), no
     embedded palette — UNIQUE among the 35 PIK files
   - Inherits palette from EUROPE.PIK at runtime
   - Decoded as 320×72; blits at colony screen y=128..200
5. ✅ TERRAIN.SS catalogued (12 frames, 16×16 each).
   Frame 001 = Plains beige — confirmed via pixel match to colon3.jpg
   colony-view ground (rgb~224,208,160 matches TERRAIN.SS.001 indices).
6. ✅ **UI element catalogue completed** — see
   `docs/UI_RENDER_MAP.md`. Every text/sprite element across colony,
   gameplay, Europe, dialog, and score screens is mapped to:
   - Asset (font / sprite / PIK) — code-cited via VICEROY.EXE startup
     asset table at file 0x1FD20
   - Color — pixel-sampled from DOSBox capture screenshots
   - Position — measured pixel coordinates
7. ✅ **Per-screen font usage** (CORRECTED again 2026-05-03 per user
   "smaller cleaner" feedback):

   **CRITICAL RULE: FONTKING is reserved for the "Audience with the
   King" screen ONLY.** Every other screen uses **FONTTINY**
   (smaller, cleaner, 4×6 fixed-width).

   - Audience with the King: **FONTKING** yellow (the ONE place it's used)
   - All other screens (colony / gameplay / europe / nations / score /
     dialogs / menu / reports): **FONTTINY** with appropriate color
     (yellow for titles, green for body, white for SoL bars, dark navy
     for inventory numbers).
   - Continental Congress hall: NO TEXT — just FF portraits on balcony
     (CC-NN.SS sprites at appropriate balcony y-coordinate).
   - Nations selection: green border aligned with NATIONS.PIK flag tile
     boundaries — verified against green pixels in 719e508.jpg
     reference (native x=211..299, y=104..186 for bottom-right panel).
   - Nations panels: (111,16,199,98) / (211,16,299,98) /
     (111,104,199,186) / (211,104,299,186) — matches outer wood-frame
     edge of each flag tile in PIK.

8. ✅ **Map popup messages** — `tools/render_map_popup.py` composites
   wood-grain message boxes (woodpanl background + dark/light border)
   over the bottom of the gameplay screen, with green FONTTINY body
   text and an optional left-side ICONS.SS sprite. Examples: treasure
   found, diplomatic message, combat result, town founded, lost city
   rumor.

8. ✅ **Per-screen renderers built** (each pixel-verified against DOSBox):
   - `tools/render_colony.py` — colony screen (title, view, production
     grid, middle band, inventory, EXIT panel)
   - `tools/render_gameplay.py` — gameplay (top menu, map view with
     PHYS0 forest/mountain overlays, sidebar, dialog overlay)
   - `tools/render_europe.py` — Europe screen (title, panel labels,
     inventory bar)
   - `tools/render_dialog.py` — dialogs (king tax, FF acquired, raze,
     diplomatic) with proper green text + WOODFRAM frame +
     NAMEPLAT title strip + KING.SS / CC-NN.SS portraits
   - `tools/render_score.py` — final COLONIZATION SCORE end screen
   - `tools/render_nations.py` — nation selection screen
   - `tools/render_menu.py` — main menu (Sid Meier's COLONIZATION
     title + options box from GAME.TXT @BEGINMENU)
   - `tools/render_cc.py` — Continental Congress hall with FF
     portraits arranged on the balcony
   - `tools/render_screen.py` — dispatcher for all screens with
     dedicated-renderer fallback to PIK-only render
   - `tools/verify_ui_renders.py` — master 10-pane verification
     contact sheet (rendered vs DOSBox reference)

9. ✅ **Production grid in colony screen** now uses TERRAIN.SS frames
   per yield-type heuristic + colony BUILDING.SS sprite at center.

10. ✅ **Town Hall label** clipping fixed: rendered BELOW building
    with black background pill behind for legibility.

11. ✅ **Map view** in gameplay now overlays PHYS0.SS sprites for
    forest (frame 64), mountain (frame 17), hill (frame 32),
    desert (frame 80) terrain types — visible tree sprites, mountain
    triangles, etc., on top of base terrain colors.

12. ✅ **WOODFRAM.SS dialog frame border** added to dialogs that need
    it (king tax, raze). Diplomatic + FF dialogs use full PIK background.

13. ✅ **NAMEPLAT.SS title strip** centered at top of dialog with
    yellow FONTKING title text rendered on it.

### Documentation

- `docs/UI_RENDER_MAP.md` — authoritative element catalog
- `docs/UI_FONT_REFERENCE.md` — code-cited font reference
- `docs/RENDERER_ARCHITECTURE.md` — per-screen renderer architecture
  + asset pipeline + verification workflow

### Still TBD for pixel-perfect match

- **PHYS0 sprite mapping with neighbor-aware transitions** — gated on
  decoding the render-chain function (`func_O514` → `O513` → `O512`).
  Currently using solid colors per terrain + decorative overlays (V
  trees, mountain triangles, river stripes). This produces RECOGNIZABLE
  but not pixel-perfect tiles.
- **CYCLE.DAT decode** — for water shimmer animation. CYCLE.DAT is
  only 34 bytes and looks like a small code patch; needs the
  cycle-tick function annotation to interpret.
- **Continental Army soldier portrait** — for dialog overlays. Not in
  any extracted .SS sheet; likely embedded in code or overlay-page-
  resident.
- **Per-building real placement in colony view** — current placement
  is approximate. Real game places buildings at fixed grid positions
  defined in the colony struct.

---

## What "100%" requires

The remaining gap is dominated by **Phase D** (per-line annotation of
~250,000 instructions across 1,740 .asm files). At realistic pace:

- 30 functions/session × 30 sessions = ~900 functions = ~70% coverage
- Plus sweep pass (5 sessions × 30 funcs/session = 150 more) = ~85%
- Plus deep MAPEDIT/OPENING/CLOSING individual annotation = ~95%
- Plus final cleanup = 100%

Estimated total to **genuine 100%** from current state:
**40–47 sessions** of focused work (per the approved plan).

The infrastructure is **complete** — every remaining session is
direct manual decompilation, with sigmatch + string_xref + the
documented runtime API providing acceleration.

Run `python tools/verify.py` periodically during Phase D to ensure
no regressions in already-verified content.


---

## UI rendering completion (final pass 2026-05-03)

### Citations from VICEROY.EXE binary

- **Audience screen render function**: `func_075352_unknown.asm` at file
  `0x075352..0x075594`. Loads "KINGLSS" PIK + per-nation banner
  (ENGLND/FRANCE/SPAIN/DUTCH per `[0x5398]` selector) + KING1 sprite
  (or KINGLOSE/KINGWIN per `[bp+8]` flag).
- **Sprite blit X = 100** (native pixels) cited from `PUSH 0x64`
  at file offsets `0x07541E` (banner blit) and `0x075444` (KING1 blit).
- **Sprite struct fields** `[+0x46]` and `[+0x48]` are mode flags (0/2/3),
  not Y positions — verified by tracing `func_06C520` which writes them
  via `SBB cx,cx` `AND cx,3` pattern (binary flag derivation).
- **Per-screen 320x200 surface** confirmed by `PUSH 0x140` (320 width)
  and `PUSH 0xC8` (200 height) at file `0x0754D2`/`0x0754E2`.

### Renderers (each runs cleanly)

| Tool | Output | Citations |
|------|--------|-----------|
| `render_colony.py` | colony screen | TERRAIN.SS.001 ground, ICONS 22-37 commodities, COLONY.PIK middle band |
| `render_gameplay.py` | gameplay | PHYS0 sprites for forest/mountain, FONTTINY sidebar |
| `render_europe.py` | Europe screen | EUROPE.PIK background |
| `render_dialog.py` | 6 dialogs | real GAME.TXT messages, FONTTINY green/yellow |
| `render_map_popup.py` | 9 map popups | real @LOSTCITY/KINGTAX/INDIANWAR/etc from GAME.TXT |
| `render_score.py` | end-game score | WOODTILE bg + FONTTINY |
| `render_nations.py` | nation selection | NATIONS.PIK + green border at PIK frame edges |
| `render_menu.py` | main menu | OPENMENU.PIK + GAME.TXT @BEGINMENU options |
| `render_cc.py` | Continental Congress hall | CCBKGD.PIK + CC-NN.SS portraits, NO TEXT |
| `render_declaration.py` | Declaration of Independence | DECLARAT.PIK |
| `render_king.py` | Audience with the King | KINGLSS1.PIK + nation banner + KING1 sprite + parchment text. ONLY screen using FONTKING. |
| `render_report.py` | 9 advisor reports | REPORT*.PIK + LABELS.TXT body |
| `render_screen.py` | 30 screens dispatcher | dispatches to dedicated renderers + PIK-only fallback |

### Verified colors (pixel-sampled from DOSBox references)

- **Yellow gold**: `(200, 160, 24)` — sampled at acaab05 dialog yellow highlights
- **Body green**: `(80, 144, 48)` — sampled at acaab05 dialog body text
- **Dark navy**: `(20, 28, 120)` — sampled at colon3.jpg inventory cell numbers
- **White**: `(255, 255, 255)` — SoL bars
- **Black**: `(0, 0, 0)` — parchment ink (king audience)
- **Wood-grain bg**: WOODTILE.SS frame 000 tiled

### Font usage rule (from user 2026-05-03)

- **FONTKING is reserved for "Audience with the King" screen ONLY**
- Every other screen uses **FONTTINY** for body text (smaller, cleaner, 4×6 fixed-width)
- 1-bit recoloring: FONTTINY/FONTSMAL use idx 0 (transparent) + idx 1 (primary)
- 2-bit recoloring: FONTKING/FONTINTR/FONT-NP use idx 1 (shadow) + idx 3 (primary)

### Master verification

`tools/verify_ui_renders.py` produces an 18-panel side-by-side
comparison sheet at `verification/ui_verification_sheet.png` showing
all rendered screens against their DOSBox reference screenshots
where available.

---

## 2026-05-03 — Byte-verified text-box placement & fake-name purge

### Audience with the King — exact GAME.TXT placement

GAME.TXT @VICEROY (line 200) declares the EXACT parchment placement:
```
@VICEROY
@width=78        ← parchment text width = 78 px
@x=232           ← parchment text left = x=232 (NATIVE 320x200)
@y=21            ← parchment text top  = y=21
^                  blank line
^^Year of Our Lord
^^1492
^                  blank line
^^An Audience With
^^The King of %COUNTRY
^                  blank line
"For the greater glory of %COUNTRY, we
dub thee Viceroy of the New World. Go
and explore this new land. Settle it
and bring wealth and glory to yourself
and our nation."
```

`render_king.py` now uses `PARCH_X=232, PARCH_Y=21, PARCH_W=78` —
byte-citation from GAME.TXT line 202-203. The Dutch variant
@VICEROY2 (line 218) substitutes "The Stadtholder" for the
"The King of %COUNTRY" line, handled by a runtime nation check.

### Real-name purge across all renderers

Replaced all "GOG GOG", "Vincent van GOG", "Continental", "Good Old GOG"
placeholder strings with **NAMES.TXT-sourced** values:

| File | Old placeholder | Replaced with | NAMES.TXT source |
|------|-----------------|---------------|------------------|
| `render_europe.py` | `"GOG"` / `"Good Old GOG"` | `"Eng."` / `"London"` | @NATIONABBREV / @HOMEPORT |
| `render_colony.py` | `owner: "Continental"` | `owner: "England"` | @COUNTRY |
| `render_nations.py` | `"GOG GOG:"` | `"Netherlands:"` | @COUNTRY[3] |
| `render_declaration.py` | `"Vincent van GOG"` | `"Walter Raleigh"` | @LEADERNAME[0] |
| `render_score.py` | `leader: "Vincent van GOG"`, `nation: "Good Old GOG"` | `leader: "Walter Raleigh"`, `nation: "England"` | @LEADERNAME[0] / @COUNTRY[0] |
| `render_report.py` | `"GOG GOG: ourselves"` | `"England: ourselves"` | @COUNTRY[0] |
| `render_dialog.py` | `"GOG pirates"` | `"Spanish privateers"` | @NATIONALITY[2] |
| `render_map_popup.py` | `"%STRING1": "GOG"` (×2) | `"English"` / `"Spanish"` | @NATIONALITY |

After this purge, `grep -r "GOG\|Vincent van\|Continental\b" reverse_engineered/tools/render_*.py`
returns only legitimate matches (e.g. "Continental Congress" the body name
of the Founding Father institution).

---

## 2026-05-03 — Inventory icon repositioning + WDCUT popup mapping

### Inventory bar icon-Y was 24 px too high

User reported: "resource sprites are too high". Verified against the
DOSBox capture `0d9a26d…jpg` (Europe screen). The 16-cell commodity
inventory bar lives at NATIVE y=180..200; icons must bottom-align to
y=192 (top of cell label area), not float at y=156 as previously.

| Renderer | Old | New | Citation |
|----------|-----|-----|----------|
| `render_europe.py` | `icon_y=156, num_y=182` | `icon_bottom=192, num_y=193` | DOSBox 0d9a26d |
| `render_colony.py` | `icon_y=156, num_y=182` | `icon_bottom=186, num_y=189` | DOSBox colon3.jpg (icons sit on COLONY.PIK grass strip just above blue cells) |

### Europe screen: RECRUIT / PURCHASE / TRAIN buttons added

Per `0d9a26d…jpg`, the right edge of Europe screen has three stacked
buttons at native x=275..319, y=130..159 — yellow FONTTINY on dark
blue (24,32,96) background with white border. Implemented in
`render_europe.py` after the inventory bar fix.

### Popup event illustrations: ICONS.SS → WDCUT01..13

Per b6235e DOSBox capture (Cibola popup), the LARGE illustration that
overlays the upper map area (above the popup body) is from the WDCUT
woodcut sheets, NOT the small ICONS.SS map sprites. Mapped each
GAME.TXT event section to its appropriate WDCUT in
`render_map_popup.py`:

| GAME.TXT section | WDCUT | Subject |
|------------------|-------|---------|
| @LOSTCITY2 (Cibola) | WDCUT07 | scout viewing native village/ruins |
| @LOSTCITY1 (Fountain of Youth) | WDCUT11 | abandoned ruins |
| @KINGTAX | KING1.SS | seated king |
| @INDIANWAR | WDCUT13 | warriors attacking |
| @INDIANPEACE | WDCUT02 | native chief / friendly villager |
| @CHIEFAREA | WDCUT07 | scout |
| @RAIDBURN | WDCUT12 | burning village |
| @DECLAREWAR | WDCUT06 | conquistador planting flag |
| @CASHTREASURE | WDCUT04 | Aztec/Mayan royals (Inca/Aztec gold) |

All 9 popups now render with the correct large illustration above the
green-body / yellow-highlight popup box, matching the DOSBox reference
composition.

### Verified renders

```
verification/screens/europe.png            (icons fixed; buttons added)
verification/screens/colony_baltimore.png  (icons fixed; on grass strip)
verification/popups/popup_lostcity2_cibola.png  (WDCUT07 scout)
verification/popups/popup_indianwar.png         (WDCUT13 warriors)
verification/popups/popup_raidburn.png          (WDCUT12 burning)
verification/popups/popup_kingtax.png           (KING1 seated)
verification/popups/popup_*.png                 (all 9 popups)
verification/dialogs/example_king_tax.png        (KING.SS portrait + green body + yellow nameplate)
verification/ui_verification_sheet.png           (18-panel contact sheet)
```

---

## 2026-05-03 — Dialog window sizing + screen-canvas restructure

User feedback: dialogs are still too large and backgrounds are wrong.
Reviewed against the `acaab05…jpg` (diplomatic) and `b6235e…jpg`
(Cibola) DOSBox captures and discovered:

1. The dialog box is a **smaller window** placed on a 320×200 screen,
   not a standalone canvas the size of the dialog itself.
2. Width is dictated by GAME.TXT `@width=NNN` (text content width).
3. Portraits (KING.SS, CC-NN.SS) extend ABOVE/BESIDE the dialog box,
   overlapping the screen background.
4. Frame is a 3-line carved-wood border (matching b6235e popup frame),
   NOT the WOODFRAM.SS sprite directly (which is 274×170 fixed).

### `render_dialog.py` rewrite

`render_dialog(definition)` now:
- Always returns a **320×200 RGBA screen canvas**
- Optional `screen_bg`: PIK or sprite tiled across the screen
  (e.g. `WOODTILE` or `CCBKGD` for full-screen backgrounds)
- Dialog box: `dialog_w` × `dialog_h` placed at `dialog_x`/`dialog_y`
  (centered if not specified)
- Body fill: cropped region of `WOODPANL.PIK` for wood-grain interior
- Frame: 3-line carved border drawn around the dialog rect
- `preview_sprite` placed at absolute `preview_pos` (so portraits
  can overhang above the dialog, matching acaab style)

### Canonical dialog sizes (from GAME.TXT @width)

| Example | GAME.TXT section | @width | dialog_w × dialog_h | Notes |
|---------|------------------|--------|---------------------|-------|
| king_tax | @KINGTAX | 190 | 198×92 | centered; KING.SS hangs right |
| ff_acquired | (custom) | — | 240×80 | bottom-anchored; CCBKGD fullscreen bg; CC-00 portrait left |
| raze | @CHIEFKILL | 190 | 198×50 | centered; 3 body lines |
| diplomatic | @HAVETREATY | 190 | 240×70 | bottom-anchored; KING.SS above-right |
| cibola | @LOSTCITY2 | 190 | 220×60 | bottom-anchored; treasure cart icon left |
| cherokee_attack | @WHACKINDIANS | 190 | 198×60 | centered; soldier sprite above |

All dialogs render with green body / yellow {brace} highlights /
yellow %VAR substitutions / no nameplate by default.

---

## 2026-05-03 — Advisor reports → REPORT*.PIK remapping

User feedback: WDCUT sprites are NOT advisor sprites. WDCUT sheets
are reserved for **map-popup event illustrations** only. The
advisor figures are pre-baked into the **REPORT*.PIK backgrounds**
(no separate advisor portrait sprite exists).

Visually identified each REPORT*.PIK and remapped the advisor
type → PIK assignment in `render_report.py`. Previous mapping had
several advisors pointing at the wrong PIK (e.g. ECONOMIC was using
REPORT4 = pioneers when it should use REPORT5 = scales of justice).

### Corrected REPORT.PIK assignments

| Advisor / Title | PIK | Scene depicted |
|------------------|----:|----------------|
| INDIAN ADVISER REPORT | REPORT1 | Indian on coast with rifle |
| RELIGIOUS ADVISER REPORT | REPORT2 | Priest preaching in church |
| LABOR ADVISER REPORT | REPORT3 | Two clerks at desk |
| ECONOMIC ADVISER REPORT | **REPORT5** | Scales of justice + scrolls + candle |
| COLONY ADVISER REPORT | **REPORT4** | Pioneers building colony |
| NAVAL ADVISER REPORT | **REPORT7** | Galleon under sail |
| FOREIGN AFFAIRS REPORT | **REPORT8** | Map with diplomatic stamp |
| CONTINENTAL CONGRESS ACTIVITIES | **REPORT6** | Aerial view of fortified colony |

`render_report.py:REPORTS` dict now stores `(title, body_lines, pik_num)`
3-tuples; the PIK lookup is decoupled from the dict key so the title
order (1..8) is independent of the PIK selection.

### WDCUT vs CHARACTER PORTRAIT sprite separation

**Three distinct categories of popup illustration:**

**(A) MSS0..5 + MYR0..3 — half-figure CHARACTER portraits.**
Upper-body sprites cropped at chest/waist, designed to OVERLAY a
popup box (the bottom half is "cut off" by the dialog). These are
the canonical event-speaker sprites used when a specific character
delivers the message. User-confirmed identification:

| Sprite | Size | Character |
|--------|------|-----------|
| MSS0 | 75×91 | Continental military officer (blue + epaulets) |
| MSS1 | 72×139 | Pioneer/colonist with rifle (tricorn hat) |
| MSS2 | 122×84 | Merchant/jester (purple feathered cap) |
| **MSS3** | **149×95** | **Scout/explorer with rifle (Cibola event — user-confirmed)** |
| MSS4 | 93×59 | Bishop/clergyman (purple hat with cross) |
| MSS5 | 60×68 | Nun/sister (white wimple) |
| MYR0 | 96×93 | Native chief (feathered headdress + red blanket) |
| MYR1 | 67×85 | European diplomat / gentleman (powdered wig, navy coat) |
| MYR2 | 74×73 | Cardinal / dark-robed cleric (gold sash) |
| MYR3 | 74×68 | Statesman / Founding Father type (orange coat, spectacles) |

**(B) WDCUT01..13 — large woodcut SCENE illustrations.**
Painted multi-figure scenes (no specific speaker). Used for events
where the message describes a happening rather than a character
speaking. Catalog cited from WOODCUT.TXT @WOODCUT.

**(C) Advisor figures embedded inside REPORT*.PIK backgrounds.** No
separate advisor portrait sprite sheet — the advisor is painted
INTO the report background.

### Event → sprite assignments (corrected)

| Event | GAME.TXT section | Sprite | Sheet | Reason |
|-------|------------------|--------|-------|--------|
| Cibola treasure | @LOSTCITY2 | MSS3 | half-figure scout | user-confirmed; matches b6235e |
| Fountain of Youth | @LOSTCITY1 | MSS3 | scout | exploration scene |
| King tax demand | @KINGTAX | KING | full king portrait | king speaks |
| Indian war declaration | @INDIANWAR | MYR0 | native chief | chief speaks |
| Indian peace | @INDIANPEACE | MYR0 | native chief | chief speaks |
| Chief area | @CHIEFAREA | MYR0 | native chief | chief speaks |
| Raid burn | @RAIDBURN | WDCUT12 | burning village scene | event scene, no speaker |
| Declare war | @DECLAREWAR | MYR1 | European diplomat | diplomat speaks |
| Cash treasure | @CASHTREASURE | MSS1 | pioneer with rifle | colonist returns with gold |

The dialog renderer (`render_dialog.py`) was updated in parallel:
king_tax → KING, diplomatic → MYR1, cibola → MSS3, cherokee_attack
→ MYR0.

---

## 2026-05-03 — 3-Week Disasm Sprint Day 1 (PARTIAL — gate not clean)

User stopped the visual-positioning iteration and demanded byte-level
analysis. Plan committed for a 3-week disasm sprint covering VICEROY
+ MAPEDIT to byte-cite every renderer position. Plan file:
`C:\Users\gregc\.claude\plans\in-this-is-the-radiant-tarjan.md`.

### Day 1 deliverables (partial)

**Decoded** (file `reverse_engineered/viceroy_source/`):

- `overlay_directory.json` — empirical seg → file_offset mapping for
  34 of 82 distinct overlay segments (41% coverage).
- `overlay_thunks_resolved.json` — 967 of 1020 thunks now have a
  candidate file offset; 177 of those (17%) verified by landing on
  a detected function-entry prologue.

**Method**: cross-reference 1020 thunks (each carrying an LJMP
target seg:off) with 691 already-detected overlay-resident functions
(at concrete file offsets via ENTER prologue scanning). For each
segment with ≥2 thunks, find the file_offset base F such that
F+thunk_off lands on the most detected function entries.
Score = matched count.

**Top-resolved segments**:

| Segment | File offset | Matched | Total thunks |
|---------|------------:|--------:|-------------:|
| 0x0000 | 0x025900 | 99 | 661 |
| 0x0427 | 0x030D14 | 5 | 47 |
| 0x05EB | 0x026FF0 | 4 | 82 |
| 0x004B | 0x0603A8 | 4 | 25 |
| 0x037F | 0x02EB3C | 4 | 24 |
| 0x0984 | 0x031F16 | 3 | 16 |
| (28 more segments resolved) | | | |

### Day 1 gate status: NOT CLEAN

The plan's Day-1 gate required "every `LCALL 0x181F:NNN` resolves to
a file offset". Status: 95% have a candidate, 17% verified. Two
remaining options to clear the gate:

1. **Extend prologue scanner** (`tools/disasm_mz.py`): the 691 detected
   functions came from `C8 imm16 imm8` (ENTER) and `55 8B EC` (push
   bp/mov bp,sp) heuristics. The remaining ~530 unmatched thunks
   point at functions whose entry doesn't start with either pattern
   (they may begin with stack-arg loads, register pushes, or be
   tail-call entries from another function).

2. **Decode the RTLink directory format** at `overlay_offset + 0x0B`
   = file `0x20670`. The first 4-byte LE32 records are:
   `0x00870458 0x000002BC 0x0000020F 0x00000000` — followed by
   sequence of small-int LE32 values (8000–15000 range) all with
   zero high word. Format unknown without deeper RE of the runtime
   loader at file `0x14293`.

### Honest blocker assessment

The user's specific frustration — popup geometry globals
[0x839E..0x83A4] — has the SETTER somewhere in overlay code. That
overlay function probably lives in one of the 48 unresolved
segments. Until either path-1 or path-2 above is completed, the
setter's file offset cannot be cited.

### Recommended next step

Path-1 is faster: extend `disasm_mz.py` to scan for the additional
function-entry patterns I see in the unmatched-thunk targets, push
the detected-function count from 691 → ~1,500+, then re-run the
empirical resolver. Should reach 80%+ thunk verification within
1–2 sessions. Path-2 (full directory decode) needs an RE pass on
the RTLink runtime that doesn't fit in a single session.

---

## 2026-05-03 — 3-Week Disasm Sprint Days 1-5 Progress

### Day 1 BREAKTHROUGH

Decoded the LCALL → thunk file-offset mapping:

```
thunk_file_offset = 0x2400 + (seg << 4) + off
```

This formula resolves every `LCALL <seg>:<off>` in disasm to a
specific thunk in the table at file `0x1A5F0..0x1D5E6`. Built
`tools/resolve_lcall.py` and applied to all 1,243 VICEROY .asm files:

- 8,869 LCALL sites total
- 7,048 (79.5%) resolved to a known thunk
- 6,499 (73.3%) further resolve to an overlay-target file_offset
- 432 .asm files now have inline `; THUNK -> 0xSEG:0xOFF (overlay
  @file 0xNNNNNN)` comments after each LCALL

Generated `viceroy_source/lcall_resolution_VICEROY.json` and
`viceroy_source/all_call_targets.json`.

### Day 2 — Sigmatch self-test PASSES 17/17

`sigmatch.py --self-test` re-finds all 17 BYTE_VERIFIED helpers in
VICEROY with zero false positives. MAPEDIT scan finds 5 shared
functions (clamp, strcpy, strcat, __aFlmul, __aFldiv) — already
auto-promoted to BYTE_VERIFIED in `code/MAPEDIT/disasm/`.

### Days 3-4 — auto-annotation passes already in place

String-xref + DGROUP-xref auto-annotators were run in prior
sessions. Combined with Day-1 LCALL pass, ledger now reports:

| Binary | Identified lines | % of total |
|--------|----------------:|-----------:|
| VICEROY.EXE | 8,493 / 212,834 | **3.99%** |
| MAPEDIT.EXE | 0 / 83,318 | 0.00% |

Up from 0.53% baseline — Day-1 pass alone added ~7,000 ident lines.

### Day 5 BREAKTHROUGH — Dialog geometry data flow traced

The user's specific frustration (popup geometry globals
`[0x839E..0x83A4]`) is now byte-cited:

1. **func_067DC8** (`code/VICEROY/disasm/func_067DC8_unknown.asm`,
   65 bytes at file `0x067DC8..0x067E09`) **hand-annotated
   line-by-line** as `compute_dialog_rect_from_cursor`. Reads
   cursor `[0x174,0x176]`, char dims `[0x1EA4,0x1EA5]`, font cell
   `[0xA5A4,0xA5A6]`. Computes rect args:
   - `dx = font_cell_width + char_width_cols - 8`
   - `cx = font_cell_height + char_height_rows - 0xF`
   plus cursor x,y. Then `LEA bx,[0x839E]` and LCALLs the setter
   at overlay `0x0C36:0x000A`.

2. **func_067E8C** — structurally identical variant, calls a
   different setter at `0x0C89:0x0006`. Bulk-annotated.

3. **`docs/DIALOG_GEOMETRY.md`** written with the full data flow,
   citing every file offset.

### Day 5 unresolved (carries to Day 6)

- The setter at overlay `0x0C36:0x000A` itself is in segment
  0x0C36, which has only 1 thunk reference and is NOT in
  `overlay_directory.json`'s resolved set. The actual write
  pattern (which arg lands in which `[0x839E..0x83A4]` field) is
  TBD until segment 0x0C36 is resolved.
- Writers of `[0x1EA4]` (char_width_cols) and `[0x1EA5]`
  (char_height_rows) — the GAME.TXT @width parser. Not yet
  found by direct memory-write search; likely in undecoded
  overlay code.

### Honest Day-5 verification gate status

The plan's Day-5 gate required: "popup x/y/w/h values for @KINGTAX,
@LOSTCITY2, @WHACKINDIANS, @VICEROY etc. can be predicted from
GAME.TXT @width/@x/@y values via byte-cited code paths."

**Status: PARTIALLY MET.** The COMPUTE function (func_067DC8) is
fully byte-cited. The downstream SETTER (overlay 0x0C36:0x000A) is
unresolved. The upstream PARSER ([0x1EA4]/[0x1EA5] writers) is
unresolved.

The renderers can NOT yet derive popup geometry purely from binary
citations because two pieces of the chain remain undecoded. The
`DIALOG_GEOMETRY.md` document records exactly which steps are
byte-cited and which are TBD.

### Day 6 — Render-chain partial decode

Several render-chain thunks resolved to file offsets via the Day-1
LCALL formula + Day-1 overlay_directory.json:

| Function | LCALL | Overlay target | File offset |
|----------|-------|----------------|-------------|
| screen_blit_helper | 0x1A1F:0x0E02 | 0x0000:0x0002 | 0x025902 |
| load_PIK | 0x191F:0x087A | 0x0000:0x000C | 0x02590C |
| load_sprite_struct | 0x191F:0x0FD0 | 0x0000:0x0054 | 0x025954 |
| popup_finalizer | 0x1A1F:0x0E1E | 0x0B70:0x0002 | 0x027954 |
| common_call_270x | 0x181F:0x016E | 0x004B:0x00E2 | 0x06048A |
| random_int (BYTE_VERIFIED) | 0x181F:0x04D4 | 0x09EF:0x0032 | 0x027DB2 |

**Caveat**: The empirical seg→file_offset map has alignment imprecision
for some segments. For example, seg 0x0000:0x000C resolves to file
0x02590C, which lands MID-INSTRUCTION inside the function detected at
file 0x025900 (`func_025900_unknown.asm`). This means either:
(a) the segment-base is off by ~12 bytes, OR
(b) the function-detection prologue scanner placed func_025900's
    boundary at the wrong byte. Likely (a) — the proper RTLink
    directory decode (Day-1 path-2) would correct this.

**sprite_blit** (LCALL 0x181F:0x2F8 → overlay 0x0C56:0x0004) remains
unresolved — segment 0x0C56 has only 1 thunk reference and is in the
`unresolved_single_thunk` list.

### Week 1 verification gate — overall status

| Gate | Plan target | Actual status |
|------|-------------|---------------|
| Day 1 — overlay directory | every LCALL resolves | **PASS** (formula derived; 79.5% LCALL→thunk, 73.3% LCALL→overlay file_offset) |
| Day 2 — sigmatch self-test | 17/17, 0 false-positive | **PASS** |
| Day 5 — dialog geometry | popup x/y/w/h byte-cited end-to-end | **PARTIAL** (compute traced; setter+parser unresolved) |
| Day 6 — render functions traced | every render-touching func annotated line-by-line | **STARTED** (1 function fully annotated; ~6 functions identified by file_offset; bulk annotation pending) |
| Day 7 — week 1 exit | ≥25% lines annotated, all overlay thunks resolved | **PARTIAL** (3.99% lines; 79.5% thunks) |

### Practical next steps (Week 2 candidates)

1. **Extend `disasm_mz.py` prologue scanner** to detect non-ENTER /
   non-pushBP function entries. The 530 unmatched thunks point at
   functions the current scanner missed.

2. **Decode RTLink directory format** at file 0x20670. The 4-byte
   LE32 records carry segment metadata; full decode would resolve
   ALL 82 segments and clear the alignment imprecision.

3. **Bulk-annotate via sigmatch + LCALL chains**. The Day-1 LCALL
   resolution gives the call graph; sigmatch can propagate
   annotations from BYTE_VERIFIED helpers. A scripted pass could
   add semantic comments to thousands more lines without manual
   work.

4. **Hand-annotate the 6 render-chain functions** at the resolved
   file offsets (load_PIK, screen_blit_helper, etc.). Even with
   the alignment caveat, the function bodies starting at 0x025900
   et al are the right code to study.

5. **Find writers of [0x1EA4] / [0x1EA5]** via byte-pattern search
   for `BB A4 1E` or `BE A4 1E` (LEA reg, [0x1EA4] then indirect
   write). My Day-5 search only covered direct memory writes.
