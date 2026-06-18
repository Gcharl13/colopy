# Six-Month Plan — Full COLONIZE Reverse-Engineering Completion

> **⚠️ PROSPECTIVE roadmap — ~1 of 26 weeks executed (as of 2026-06-18).**
> Only M1W1 ran; M1W2–M6W26 are not started. This is aspirational planning, not
> current status — see [`STATUS.md`](STATUS.md) and [`AUDIT.md`](AUDIT.md).

26 weeks of focused work to close every open gap from the prior
12-week sprint and reach **pixel-perfect parity with DOSBox** for
every render, **per-line semantic annotation** for every game-logic
function, and **byte-perfect round-trip** for every asset.

## Context

The 12-week disasm sprint (completed 2026-05-03, see
`DISASM_COMPLETION.md`) cleared the structural acceptance bars
(ledger ≥95%, linkcheck clean, 0 fabrication flags, BUILD.md
reproduces in 30 min). It left these specific gaps documented:

1. Overlay segment 0x0C36 (dialog setter) and 0x0C56 (sprite blit)
   single-thunk segments — file_offset unresolved.
2. GAME.TXT @width parser — function entry not detected.
3. 48 of 82 distinct overlay segments unresolved.
4. Per-line semantic hand-annotation only ~5 functions deep.
5. Visual diff vs DOSBox shows 20–65% pixel mismatch.
6. Asset round-trip SHA-256 not yet wired up.
7. OPENING/CLOSING/MPSCOPY/INSTALL untouched.

This plan resolves each gap with a specific week-by-week schedule.

## Milestones

| Month | Weeks | Theme | Exit criterion |
|-------|-------|-------|----------------|
| M1 | W1-4 | Per-line hand annotation push | 100 highest-impact functions BYTE_VERIFIED |
| M2 | W5-8 | Game-system formulas | All player-visible mechanics byte-cited |
| M3 | W9-12 | Asset round-trip integration | All 319 files round-trip SHA-equal |
| M4 | W13-16 | Renderer pixel-perfect rewrite | visual_diff <1% mismatch on positions |
| M5 | W17-20 | Other binaries + cross-binary regen | All 6 EXEs covered |
| M6 | W21-26 | Final acceptance + comprehensive docs | All criteria pass; BUILD.md verified by third party |

---

## Month 1 — Per-Line Hand Annotation Push (W1-4)

### Week 1 — Combat + colony entry points (top 25)
- W1.1 Combat dispatcher (`func_03ECF0` diplomatic, ~86 bytes)
- W1.2 Combat resolution (find via "DEMOTION"/"COMBAT" string xrefs)
- W1.3 Colony screen handler (`func_02D658`, 1061 bytes — large!)
- W1.4 Colony production calculator (per-tile yield)
- W1.5 Colony job-assignment logic
- W1.6 Town hall menu (`func_02883E`)
- W1.7 Stockade/fort defense bonus calculator
- W1.8 Founding-Father acquisition (`func_03DE46` independence)
- W1.9 Update FUNCTION_INVENTORY.md with new BYTE_VERIFIED tags
- W1.10 Run linkcheck.py + ledger snapshot

### Week 2 — UI dispatchers + render chain (next 25)
- W2.1 Top menu bar dispatcher (`func_072090`, 7 strings)
- W2.2 Right sidebar render function
- W2.3 Map view tile render — find `func_O514`/`O513`/`O512`
- W2.4 Sprite blit overlay (segment 0x0C56)
- W2.5 Font glyph blitter (FONTKING/FONTSMAL/FONTTINY xrefs)
- W2.6 Palette load + color-cycle ticker (port 0x3C8/0x3C9)
- W2.7 Dialog framework (`func_06F0F4` 80 bytes, plus larger callees)
- W2.8 Text template parser (`func_06EEEC` 83 bytes)
- W2.9 GAME.TXT @width parser (find via byte sequence `77 69 64 74 68`)
- W2.10 Add render-chain section to RENDER_CHAIN.md

### Week 3 — Asset loaders + parsers (next 25)
- W3.1 PIK loader (`load_PIK` at file 0x02590C)
- W3.2 SS sprite-sheet loader (full byte trace)
- W3.3 FF font loader (full byte trace)
- W3.4 MP map loader
- W3.5 PAL palette loader + CYCLE.DAT loader
- W3.6 COL audio descriptor loader
- W3.7 BIN raw sample loader
- W3.8 NAMES.TXT data-table loader (`func_0749E0`)
- W3.9 GAME.TXT section parser (writes `[0x1EA4]/[0x1EA5]`)
- W3.10 Promote `formats/<EXT>.md` to BYTE_VERIFIED

### Week 4 — AI + diplomacy (next 25)
- W4.1 AI action dispatcher (`func_04E2D6`, 584 bytes)
- W4.2 11 AI sub-actions (AI10..AI20)
- W4.3 Native attitude formula (`func_03ECF0`)
- W4.4 Tribe-tribute / chief-gift mechanics (CHIEFAREA, CHIEFGIFT)
- W4.5 Native village raze (`func_04A7CA` CHIEFKILL — partial)
- W4.6 King-tax raise formula (already BYTE_VERIFIED — extend
  context)
- W4.7 King-popularity tracker
- W4.8 Diplomatic actions: declare war, treaty, cancel peace
- W4.9 SMITE formula full annotation (already BYTE_VERIFIED)
- W4.10 Continental Congress + FF voting

**M1 exit gate**: 100 functions hand-annotated to BYTE_VERIFIED;
ledger shows ≥10% of LINES (not just functions) are deeply
annotated (not just classified).

---

## Month 2 — Game-System Formulas (W5-8)

### Week 5 — Combat full mechanics
- W5.1 Combat-demotion formula full annotation
- W5.2 Ambush bonus (`+ Terrain` from LABELS.TXT @MISC line 94)
- W5.3 Fortified bonus (LABELS.TXT line 96)
- W5.4 Spain combat bonus (LABELS.TXT line 97)
- W5.5 Plowed-fields bonus
- W5.6 Artillery-vs-raid mechanic (LABELS.TXT line 144)
- W5.7 Naval combat (ship vs ship)
- W5.8 Privateering mechanics
- W5.9 Combat-analysis dialog (LABELS.TXT @MISC line 90)
- W5.10 docs/COMBAT.md with all formulas cited

### Week 6 — Market + economy
- W6.1 Market price drift (`func_0305A8`, already BYTE_VERIFIED — extend)
- W6.2 Buy/sell price calculation
- W6.3 Tax mechanics (rate cap, raise cooldown)
- W6.4 Boycott mechanics (LABELS.TXT @MISC line 146)
- W6.5 Treasury accumulation
- W6.6 Annual income/expense breakdown (matches Economic Adviser report)
- W6.7 Liberty Bell production
- W6.8 Tory/Rebel sentiment formula
- W6.9 docs/ECONOMY.md with all formulas cited
- W6.10 Verify market-price drift against in-game observation

### Week 7 — Score + Hall of Fame
- W7.1 Score formula (`func_03A9C0`, 964-byte stack frame!)
- W7.2 Score-plate mapping (SCORE01..24 → which categories)
- W7.3 Hall-of-Fame writer (`func_03ADA6`, HALLFAME.DAT)
- W7.4 Independence-achieved formula (LABELS.TXT line 134)
- W7.5 Foreign-recognition formula (LABELS.TXT line 135)
- W7.6 Total-score calculation (LABELS.TXT line 136)
- W7.7 Early-revolution bonus (LABELS.TXT line 157)
- W7.8 Citizens count
- W7.9 Villages-burned penalty
- W7.10 docs/SCORE.md with formulas + plate role catalog

### Week 8 — Save/load + AI personality
- W8.1 Save game format (find via `func_0749E0` SAVEAS)
- W8.2 Load game format
- W8.3 Auto-save logic
- W8.4 AI personality table (per-power: aggressive/friendly,
  expansionist/perfectionist, civilize/militaristic from
  NAMES.TXT @LEADERNAME)
- W8.5 AI economic strategy
- W8.6 AI military strategy
- W8.7 AI diplomatic strategy
- W8.8 AI native-relations strategy
- W8.9 docs/SAVE_FORMAT.md
- W8.10 docs/AI.md

**M2 exit gate**: every player-visible game mechanic is byte-cited
in either a `formats/*.md` or `docs/*.md` document with a
BYTE_VERIFIED function citation.

---

## Month 3 — Asset Round-Trip Integration (W9-12)

### Week 9 — mpskit wiring
- W9.1 Wire `tools/mpskit/main.py ss extract` into `verify_assets.py`
- W9.2 Same for PIK, FF, FAB
- W9.3 SHA-256 round-trip for all 206 .SS files
- W9.4 SHA-256 round-trip for all 35 .PIK files
- W9.5 SHA-256 round-trip for all 5 .FF files
- W9.6 Document mpskit codec edge cases
- W9.7 Verify TERRAIN.SS round-trips byte-equal
- W9.8 Verify VICEROY.PAL round-trips
- W9.9 Verify CYCLE.DAT round-trips
- W9.10 Pass: 246+ files round-trip SHA-equal

### Week 10 — Custom format byte-verify
- W10.1 .COL audio descriptor decoder
- W10.2 .BIN raw sample (verify by playback test)
- W10.3 .MOV cinematic timeline parser
- W10.4 .DAT remaining files (HALLFAME.DAT, etc.)
- W10.5 .PART RTLink overlay parts decoder
- W10.6 Encoder for each
- W10.7 Round-trip CI for .COL/.BIN/.MOV/.DAT/.PART
- W10.8 docs/AUDIO.md
- W10.9 docs/CINEMATIC.md (extends existing AMERICA.MOV findings)
- W10.10 Pass: every COLONIZE/ file has documented format

### Week 11 — Asset role catalog (full)
- W11.1 Each .SS sheet → role catalog entry (frame index → in-game role)
- W11.2 Each .PIK background → screen catalog entry
- W11.3 Each .FF font → use-site catalog entry
- W11.4 Each WDCUT01..13 → event catalog entry
- W11.5 Each MSS0..5/MYR0..3 → speaker catalog entry
- W11.6 Each SCORE01..24 → score-category catalog entry
- W11.7 Each CC-NN.SS → Founding Father catalog entry
- W11.8 Each IND0A0..IND7A3 → tribe sprite catalog entry
- W11.9 Each DEC-LOWA..UPPZ → declaration letter catalog entry
- W11.10 SPRITE_ROLE_CATALOG.md ≥95% non-TBD

### Week 12 — Asset round-trip CI integration
- W12.1 `tools/asset_ci.py` — single command runs all round-trip
- W12.2 Pre-commit hook for asset round-trip
- W12.3 Document any non-deterministic encoders
- W12.4 Add asset_ci to BUILD.md step list
- W12.5 Run asset_ci across all 319 files; goal: 100% pass
- W12.6 Document any files that don't round-trip + reason
- W12.7 verify_assets.py reports `round_trip_pass=N/319`
- W12.8 Refresh golden_manifest.json
- W12.9 Cross-link asset → loader function file_offset for every asset
- W12.10 docs/ASSET_ROLES.md updated with full catalog

**M3 exit gate**: 319/319 asset files round-trip SHA-equal; every
asset has a sidecar JSON linking to its loader function.

---

## Month 4 — Renderer Pixel-Perfect Rewrite (W13-16)

### Week 13 — King audience + dialogs
- W13.1 render_king.py: audit every literal vs the GAME.TXT/disasm citations
- W13.2 render_dialog.py: dialog box geometry from byte-cited formula
- W13.3 render_dialog.py: portraits use MSS/MYR catalog
- W13.4 visual_diff vs acaab05 (diplomatic) → mismatch <5%
- W13.5 visual_diff vs b6235e (Cibola popup) → mismatch <5%
- W13.6 visual_diff vs cf61be1 (Declaration) → mismatch <5%
- W13.7 Add fonts/glyph-cell-width and font-cell-height to renderers
- W13.8 Implement char-grid → pixel formula for popup rect
- W13.9 docs/RENDER_KING.md per-pixel layout
- W13.10 docs/RENDER_DIALOG.md per-pixel layout

### Week 14 — Colony + Europe
- W14.1 render_colony.py: every position cited from func_02D658 trace
- W14.2 visual_diff vs colon3.jpg → mismatch <5%
- W14.3 render_europe.py: every position cited from Europe-render
- W14.4 visual_diff vs 0d9a26d → mismatch <5%
- W14.5 SoL bar geometry byte-cited
- W14.6 16-cell inventory bar geometry byte-cited
- W14.7 Building grid layout byte-cited
- W14.8 docs/RENDER_COLONY.md per-pixel layout
- W14.9 docs/RENDER_EUROPE.md per-pixel layout
- W14.10 Both renderers pass visual_diff <5%

### Week 15 — Map + gameplay HUD
- W15.1 render_map.py: per-tile PHYS0/TERRAIN logic byte-cited
- W15.2 Coast/forest/river/mountain decoration logic
- W15.3 Unit blit (UnitRecord → ICONS index)
- W15.4 Native village blit (MSS/MYR per tribe)
- W15.5 render_gameplay.py top menu bar exact pixel positions
- W15.6 render_gameplay.py sidebar minimap layout
- W15.7 visual_diff vs screenshot_03 → mismatch <5%
- W15.8 docs/RENDER_MAP.md per-pixel layout
- W15.9 docs/RENDER_GAMEPLAY.md per-pixel layout
- W15.10 Map render passes visual_diff

### Week 16 — Score + reports + remaining screens
- W16.1 render_score.py: SCORE01..24 plate placement
- W16.2 visual_diff vs f8997b → mismatch <5%
- W16.3 render_report.py: each advisor's REPORT*.PIK + text overlay
- W16.4 render_nations.py: panel positions byte-cited from NATIONS.PIK frames
- W16.5 render_menu.py: GAME.TXT @BEGINMENU positions
- W16.6 render_cc.py: Continental Congress hall layout
- W16.7 render_declaration.py: signature placement
- W16.8 render_map_popup.py: rect+sprite positions byte-cited
- W16.9 Visual-diff every render against its DOSBox reference
- W16.10 visual_diff_report.json shows every render <5% mismatch

**M4 exit gate**: every Python renderer has 0 fabrication flags
and every visual_diff entry shows <5% pixel mismatch against the
DOSBox reference for that screen.

---

## Month 5 — Other Binaries + Cross-Binary Regen (W17-20)

### Week 17 — OPENING.EXE
- W17.1 Disassemble OPENING.EXE (already at 147 .asm files, run
  classifier)
- W17.2 Identify entry chain: opening cinematic dispatcher
- W17.3 Decode AMERICA.MOV timeline player
- W17.4 Annotate opening menu rendering
- W17.5 Sigmatch shared functions with VICEROY
- W17.6 Generate opening_source/ pseudo-C tree
- W17.7 OPENING FUNCTION_INVENTORY.md
- W17.8 docs/CINEMATIC.md updated with player byte-trace
- W17.9 OPENING ledger ≥99%
- W17.10 OPENING linkcheck clean

### Week 18 — CLOSING.EXE
- W18.1 Disassemble CLOSING.EXE (already at 138 .asm files, run
  classifier)
- W18.2 Identify entry chain: closing cinematic dispatcher
- W18.3 Decode CLOSING.TXT timeline (fireworks, hat, lady, man, etc.)
- W18.4 Closing animation player annotation
- W18.5 Sigmatch shared functions
- W18.6 Generate closing_source/ pseudo-C tree
- W18.7 CLOSING FUNCTION_INVENTORY.md
- W18.8 docs/CLOSING_CINEMATIC.md
- W18.9 CLOSING ledger ≥99%
- W18.10 CLOSING linkcheck clean

### Week 19 — MPSCOPY.EXE + INSTALL.EXE
- W19.1 Disassemble MPSCOPY.EXE (per RTLINK.md, mostly overlay)
- W19.2 Disassemble INSTALL.EXE (51KB, no overlay)
- W19.3 Document MPSCOPY purpose (likely an internal copier)
- W19.4 Document INSTALL purpose
- W19.5 Sigmatch each
- W19.6 mpscopy_source/ + install_source/ trees
- W19.7 Per-EXE FUNCTION_INVENTORY.md
- W19.8 docs/INSTALL.md per-EXE notes
- W19.9 ledger ≥99% for both
- W19.10 linkcheck clean for both

### Week 20 — Cross-binary regen
- W20.1 Identify functions byte-shared across all 6 EXEs (sigmatch)
- W20.2 Document the MicroProse runtime library found in all 6
- W20.3 Validate viceroy_source/ pseudo-C compiles (TCC or borland-tcc)
- W20.4 Validate compiled bytes match VICEROY function entries
- W20.5 Document per-function regen status (compiled-and-byte-matched
  vs RECONSTRUCTED-only)
- W20.6 viceroy_source/CROSS_BINARY_REGEN_STATUS.md
- W20.7 Document the full RTLink directory format (segment table at
  file 0x20670)
- W20.8 Resolve all 82 overlay segments (was 34/82)
- W20.9 Decode segment 0x0C36 (dialog setter)
- W20.10 Decode segment 0x0C56 (sprite blit)

**M5 exit gate**: all 6 EXEs have ≥99% ledger; all 82 overlay
segments resolved; cross-binary regen reproduces VICEROY function
bytes for ≥50% of functions.

---

## Month 6 — Final Acceptance + Comprehensive Docs (W21-26)

### Week 21 — Documentation pass: synthesis docs
- W21.1 docs/ARCHITECTURE.md final pass — every claim cited
- W21.2 docs/ENGINE.md final pass
- W21.3 docs/RENDERER_ARCHITECTURE.md final pass
- W21.4 docs/UI_DIALOGS.md per-dialog catalog
- W21.5 docs/UI_FONT_REFERENCE.md per-font catalog
- W21.6 docs/UI_RENDER_MAP.md per-screen render map
- W21.7 docs/VISUAL_VERIFICATION.md final
- W21.8 docs/PALETTE_AND_CYCLING.md final
- W21.9 docs/ASSET_ROLES.md full sprite-role catalog cross-reference
- W21.10 linkcheck.py: 100% STRONG citations (no WEAK or INVALID)

### Week 22 — Documentation pass: format specs
- W22.1 formats/PAL.md — full byte-layout + verifier
- W22.2 formats/SS.md — full byte-layout + verifier
- W22.3 formats/PIK.md — full byte-layout + verifier
- W22.4 formats/FF.md — full byte-layout + verifier
- W22.5 formats/MP_FORMAT.md — full byte-layout + verifier
- W22.6 formats/DAT.md — full byte-layout + verifier
- W22.7 formats/COL.md — full byte-layout + verifier
- W22.8 formats/BIN.md — full byte-layout + verifier
- W22.9 formats/MOV.md — full byte-layout + verifier
- W22.10 Each format has BYTE_VERIFIED extract+encode tools

### Week 23 — Game-mechanic docs
- W23.1 docs/COMBAT.md
- W23.2 docs/ECONOMY.md
- W23.3 docs/AI.md
- W23.4 docs/DIPLOMACY.md
- W23.5 docs/COLONY.md (production formulas)
- W23.6 docs/SCORE.md
- W23.7 docs/REVOLUTION.md
- W23.8 docs/NATIVE_RELATIONS.md
- W23.9 docs/MAP_GENERATION.md (random map mechanics)
- W23.10 docs/SAVE_FORMAT.md

### Week 24 — Tooling polish + CI
- W24.1 `tools/full_pipeline.py` — single-command end-to-end build
- W24.2 Pre-commit hooks for ledger/linkcheck/fabrication
- W24.3 GitHub Actions workflow (run pipeline + verifiers in CI)
- W24.4 Asset round-trip CI integration
- W24.5 Visual-diff CI integration
- W24.6 docs/TOOLING.md — every tool catalogued
- W24.7 Tools README per-script docstring polish
- W24.8 Add `--help` consistency check
- W24.9 Tools cross-cutting integration test
- W24.10 BUILD.md updated with full CI verification

### Week 25 — Final visual + canary verification
- W25.1 Run visual_diff across all renders; target every <5%
- W25.2 Run canary_test.py: RNG, raze, SMITE, king-tax — pass
- W25.3 Run linkcheck — 0 INVALID, ≤5 WEAK
- W25.4 Run check_no_fabrication — 0 flags
- W25.5 Run verify_assets — 319/319 round-trip pass
- W25.6 Run ledger_update — ≥99% all 6 EXEs
- W25.7 verify_ui_renders contact sheet shows pixel-perfect renders
- W25.8 Update STATUS.md with final state
- W25.9 Commit final-acceptance tag
- W25.10 Document any remaining gaps in DISASM_COMPLETION_FINAL.md

### Week 26 — Third-party reproduction test
- W26.1 Wipe `code/` and re-run BUILD.md from step 1
- W26.2 Wipe `viceroy_source/` and re-generate
- W26.3 Wipe `mapedit_source/` and re-generate
- W26.4 Wipe all extracted assets and re-extract
- W26.5 Time the full reproduction; target <30 min
- W26.6 Verify every BYTE_VERIFIED claim still resolves
- W26.7 Verify every renderer still passes visual_diff
- W26.8 Verify every doc still passes linkcheck
- W26.9 Final FINAL_REPORT.md
- W26.10 Tag release `v1.0-byte-verified`

**M6 exit gate**: third-party reproduction passes; all CI
verifiers green; no remaining open gaps in `DISASM_COMPLETION.md`.

---

## Verification gates (summary)

| Gate | Target |
|------|--------|
| M1 W4 | 100 functions hand-annotated; ≥10% lines deeply annotated |
| M2 W8 | every player-visible mechanic byte-cited |
| M3 W12 | 319/319 assets round-trip SHA-equal |
| M4 W16 | every renderer <5% pixel mismatch |
| M5 W20 | all 6 EXEs ≥99% ledger; 82/82 segments resolved |
| M6 W26 | third-party reproduction in <30 min; release tagged |

## Stop conditions

This plan is "complete" only when:
1. All gates above PASS.
2. The third-party reproduction test (W26) succeeds end-to-end.
3. Every claim in every doc has a STRONG linkcheck citation.
4. `DISASM_COMPLETION_FINAL.md` shows zero documented gaps.

---

## Critical files (paths)

### To create or fully populate
- `docs/COMBAT.md`
- `docs/ECONOMY.md`
- `docs/AI.md`
- `docs/DIPLOMACY.md`
- `docs/COLONY.md`
- `docs/SCORE.md`
- `docs/REVOLUTION.md`
- `docs/NATIVE_RELATIONS.md`
- `docs/MAP_GENERATION.md`
- `docs/SAVE_FORMAT.md`
- `docs/AUDIO.md`
- `docs/CINEMATIC.md`
- `docs/TOOLING.md`
- `opening_source/`, `closing_source/`, `mpscopy_source/`, `install_source/`
- `viceroy_source/CROSS_BINARY_REGEN_STATUS.md`
- `tools/full_pipeline.py`
- `tools/asset_ci.py`

### To extend with byte-cited content
- `code/VICEROY/disasm/*.asm` — line-by-line annotation for ~100
  highest-impact functions
- `viceroy_source/src/**` — promote stubs to BYTE_VERIFIED
- All format docs in `formats/*.md`
- All docs in `docs/*.md`
- All renderers in `tools/render_*.py`
