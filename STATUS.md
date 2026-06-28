# STATUS — Reverse-Engineering Progress Dashboard

> **This is the single source of truth for current project state.**
> The historical/stale status logs (`PROGRESS.md`, `DISASM_COMPLETION.md`,
> `DISASM_COMPLETION_FINAL.md`, `WEEK1_SUMMARY.md`, `OVERLAY_PLAN.md`,
> `SIX_MONTH_PLAN.md`) were removed in the 2026-06-22 cleanup (they inflated /
> contradicted the verified state). For the correct-vs-misleading information
> audit and **corrected metrics** (the headline "100% in citable C" / "99.36%
> identified" figures are syntactic, not semantic), see [`AUDIT.md`](AUDIT.md).
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

> **Spec-depth reconciliation (2026-06-27).** `spec/README.md` and `spec/BACKLOG.md` previously
> carried a "certification" that *every mechanic is byte-grounded / nothing needed a runtime trace*.
> That was **over-claimed and is corrected** in those files. **Update 2026-06-28:** the formula
> table below is now **byte-closed** (combat damage, market drift, FF acquisition, LCR distribution,
> REF growth, score details, map generation — all ✅), and a 213-TBD close-out pass cut the `spec/`
> open-TBD lines from **~317 → ~76** (the remainder are tier-vocabulary legends + ~17 genuinely
> runtime-only values, each with source byte-cited + the exact oracle capture named). The colony-site
> value formula — the last open item — was **closed (B) 2026-06-28** (`spec/systems/ai.md §3b`:
> `func_063F3C` fills map-layer-4 low nibble = `clamp(land-value/10, 0, 15)`, displayed by F09
> `func_021602`). Each spec sheet's §6/§8 is the source of truth, not any summary header.

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
| Combat damage roll | ✅ (`func_05CA7E` odds + `+50%`/SoL/difficulty chain; shore bombardment `func_02D3C6` deterministic) |
| Market price drift formula | ✅ (`func_0305A8` decay `(base+Σtrade)/256`; display spread = Burden) |
| Founding Father acquisition | ✅ (threshold `func_03C282`; bells `PowerRecord +0x0C`) |
| LCR outcome distribution | ✅ (`func_061454` `random_int(1,9)`→`@LOSTCITY<n>` + reward magnitudes) |
| REF growth rate | ✅ (`ref_growth.md`, B) |
| Score formula details | ✅ (`func_03A9C0`/`func_039EE2`, 7-term grand total byte-bound) |
| Map generation | ✅ (`map_generation.md` post-gen pass order + customize params, B) |

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
| INGAME_MAP_RENDER_TRACE.md (byte-verified map render chain) | ✅ |
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
| C-VISUAL CV6 | AMERICA.MOV decode | ✅ (1-bpp coastline bitmap + 8-waypoint stream, data_extracted/data/AMERICA_MOV.json) |
| C-VISUAL CV7 | Sprite role catalog | ✅ partial (~50%; SPRITE_INDEX.md has all commodities BYTE_VERIFIED, ships 5/6/7/14/15 BYTE_VERIFIED) |
| C-VISUAL CV8 | map render chain (`docs/INGAME_MAP_RENDER_TRACE.md`) | ✅ byte-verified |
| C-VISUAL CV9 | UI_DIALOGS.md | ✅ |
| C-VISUAL CV10 | Animation catalog | ⏳ TBD |
| **V** | **Map renderer** | ✅ `viceroy_cpp` `mapview` (terrain/coast/forest/minimap from the byte-verified chain) |
| **G-CONSOLIDATE** | **Single-file Ghidra C consolidation** | ⏳ infrastructure ready (build_rename_table.py + rename_pass.py + 100 substitutions) — gated on user re-exporting Ghidra C |
| D | Per-line annotation (long pole) | ⏳ ~5% (DEFERRED — visual verification is the higher-leverage path now) |
| E | OPENING/CLOSING/MPSCOPY/INSTALL annotation | ⏳ partial (sigmatch promotions; per-line pending) |
| F | Synthesis docs (8 docs) | ✅ DONE |
| G | DOSBox playable-rebuild smoke test | ⏳ TBD (gated by user-provided DOSBox screenshot for visual_diff) |
| H | BUILD.md + STATUS.md | ✅ DONE |


---

> **Note (2026-06-22 cleanup):** the former ~700-line appendix of 2026-05-03
> "visual verification" / "UI rendering completion" session logs described the
> old Python per-screen renderers (`tools/render_*.py`), which were naive
> placeholders since superseded by the `viceroy_cpp` C++ renderer and the
> byte-verified `docs/INGAME_MAP_RENDER_TRACE.md`. That stale appendix was
> removed to stop it contradicting the verified render chain. Current renderer
> state lives in `viceroy_cpp/` and the spec.
