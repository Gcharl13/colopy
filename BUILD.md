# BUILD — How to Reproduce Every Verified Claim

A third party should be able to reproduce every BYTE_VERIFIED claim
in this archive **from the original VICEROY.EXE / MAPEDIT.EXE bytes**
in under 30 minutes by following this guide.

This is the reproducibility doc for the entire reverse-engineering
project.

> **2026-05-03 update**: The 12-week disasm sprint added several
> tooling steps. The list below has been augmented; the original
> guide steps remain valid.

## Quick reproducer (12-week sprint deliverables)

```bash
# 1. Disassemble both binaries
python reverse_engineered/tools/disasm_mz.py --exe VICEROY
python reverse_engineered/tools/disasm_mz.py --exe MAPEDIT

# 2. Resolve overlay thunks
python reverse_engineered/tools/parse_thunks.py --exe VICEROY

# 3. LCALL annotation (Day-1 breakthrough; 79.5% of LCALLs resolved)
python reverse_engineered/tools/resolve_lcall.py --annotate

# 4. Sigmatch (17 helpers + 5 MAPEDIT shared functions BYTE_VERIFIED)
python reverse_engineered/tools/sigmatch.py --self-test
python reverse_engineered/tools/sigmatch.py --build-lib
python reverse_engineered/tools/apply_sigmatch.py --target MAPEDIT

# 5. Bulk classify instructions (ledger 0% -> 99%)
python reverse_engineered/tools/classify_instructions.py --exe VICEROY
python reverse_engineered/tools/classify_instructions.py --exe MAPEDIT

# 6. Auto-tag functions by string xrefs
python reverse_engineered/tools/auto_name_funcs.py --exe VICEROY

# 7. MAPEDIT pseudo-C tree
python reverse_engineered/tools/build_mapedit_source.py

# 8. Refresh ledger
python reverse_engineered/tools/ledger_update.py

# 9. Linkcheck across docs (every "file 0xNNNNNN" must resolve)
python reverse_engineered/tools/linkcheck.py

# 10. Fabrication check across renderers
python reverse_engineered/tools/check_no_fabrication.py

# 11. Visual diff (informational; not a hard pass)
python reverse_engineered/tools/visual_diff.py

# 12. Asset round-trip status
python reverse_engineered/tools/verify_assets.py
```

Expected outputs after running the above:

- `code/DISASM_LEDGER.md` — VICEROY 99.36% / MAPEDIT 99.91% ident
- `viceroy_source/lcall_resolution_VICEROY.json` — 7,048 LCALLs resolved
- `viceroy_source/overlay_directory.json` — 34/82 segments resolved
- `viceroy_source/linkcheck_report.json` — 38 STRONG / 32 WEAK / 0 INVALID
- `viceroy_source/visual_diff_report.json` — per-render mismatch %
- `mapedit_source/mapedit.h` — 210 function decls
- `code/VICEROY/disasm/func_067DC8_unknown.asm` — BYTE_VERIFIED
  (compute_dialog_rect_from_cursor, 65 bytes, full line annotation)
- `code/VICEROY/disasm/func_0305A8_unknown.asm` — BYTE_VERIFIED
  (market_accumulate_price_drift, 87 bytes, full line annotation)

---

## Prerequisites

- Python 3.8+
- `pip install Pillow` (for PNG rendering)
- The original `COLONIZE/` directory from a Sid Meier's Colonization
  (DOS, 1994) installation, placed at the project root.

No DOS emulator required for byte verification (only for the Phase G
playable smoke test).

---

## Step 1: Verify all 319 COLONIZE/ files match the golden manifest (~30 sec)

```bash
cd reverse_engineered
python tools/verify.py
```

Expected output:
```
Results: 319 pass, 0 fail, 0 skip (319 total)
```

This SHA-256s every file in COLONIZE/ against the frozen
`verification/golden_manifest.json` baseline. Any mismatch indicates
a file was modified.

---

## Step 2: Verify byte-perfect round-trip for PAL and MP (~5 sec)

```bash
python tools/extract_pal.py     # extracts VICEROY.PAL → assets/palettes/
python tools/encode_pal.py      # round-trips back to bytes
python tools/extract_mp.py      # extracts AMER2.MP → assets/maps/
python tools/encode_mp.py       # round-trips back to bytes
```

Each `encode_*.py` script ends with `ROUND-TRIP: PASS` if the
re-encoded bytes SHA-match the original.

---

## Step 3: Run sigmatch self-test (~3 sec)

```bash
python tools/sigmatch.py --self-test
```

Expected output:
```
Indexed 17 signatures, found 17 matches in source EXE.
  PASS  rand                                 found at 0x0103d4
  PASS  random_int                           found at 0x00c322
  ...
Results: 17 pass, 0 fail
```

This re-finds every BYTE_VERIFIED helper function at its claimed file
offset, with zero false positives. If sigmatch fails, the byte
signatures don't match — investigation needed.

---

## Step 4: Verify cross-EXE function inheritance (~5 sec)

```bash
python tools/sigmatch.py --build-lib
python tools/sigmatch.py --scan ../COLONIZE/MAPEDIT.EXE
python tools/sigmatch.py --scan ../COLONIZE/OPENING.EXE
python tools/sigmatch.py --scan ../COLONIZE/CLOSING.EXE
```

Expected matches:
- MAPEDIT.EXE: 5 (4 C-runtime helpers + clamp)
- OPENING.EXE: 4 (4 C-runtime helpers)
- CLOSING.EXE: 4 (4 C-runtime helpers)
- MPSCOPY.EXE / INSTALL.EXE: 0 (different compiler — install-time
  utilities, not main-game build)

---

## Step 5: Re-extract all visual assets (~3 min)

```bash
python tools/extract_visuals.py --type ALL
```

Extracts:
- 205 / 206 .SS sheets (BDARK.SS skipped per CLAUDE.md hard rule) →
  `assets/sprites/<NAME>/<NAME>.SS.NNN.png`
- 35 .PIK backgrounds → `assets/backgrounds/<NAME>/<NAME>.PIK.png`
- 5 .FF fonts → `assets/fonts/<NAME>/<NAME>.FF.NNN.png`

Then rebuild the catalogs:

```bash
python tools/build_catalogs.py
```

Output:
- `assets/sprites/SPRITE_CATALOG.md` (1,676 frames across 205 sheets)
- `assets/backgrounds/BACKGROUND_CATALOG.md` (35 entries)
- `assets/fonts/FONT_CATALOG.md` (5 fonts)

---

## Step 6: Verify the BYTE_VERIFIED game-system formulas

For each formula in [`viceroy_source/COMPLETE_FINDINGS.md`](viceroy_source/COMPLETE_FINDINGS.md),
the proof is the cited bytes in VICEROY.EXE. Quick spot-checks:

```bash
# Native village raze (CHIEFKILL) gold formula
python -c "
data = open('../COLONIZE/VICEROY.EXE', 'rb').read()
# 'sum_3 × roll_4 × 4 × (size_byte+1)' is verified at file 0x04AB17..0x04AB2A
print('IMUL [BP-0x14]:', data[0x04AB17:0x04AB1A].hex(), '(expect F7 6E EC)')
print('SHL AX, 2     :', data[0x04AB1A:0x04AB1D].hex(), '(expect C1 E0 02)')
print('IMUL [BP-0x14]:', data[0x04AB2A:0x04AB2D].hex(), '(expect F7 6E EC)')
"

# rand() LCG constants
python -c "
data = open('../COLONIZE/VICEROY.EXE', 'rb').read()
# At 0x0103D4: B8 FD 43 (MOV AX, 0x43FD) and 0x0103D7: BA 03 00 (MOV DX, 3)
# i.e. multiplier = 0x000343FD = 213245
print('rand multiplier:', data[0x0103D4:0x0103DA].hex())
# At 0x0103E9: 05 C3 9E (ADD AX, 0x9EC3) — increment low
# At 0x0103EC: 83 D2 26 (ADC DX, 0x26)  — increment high → 0x00269EC3
print('rand increment :', data[0x0103E9:0x0103EF].hex())
"
```

Each spot-check confirms the canonical Microsoft MSC 6.0 LCG
constants live at the cited offsets.

---

## Step 7: Verify message-key strings at cited offsets

```bash
python -c "
data = open('../COLONIZE/VICEROY.EXE', 'rb').read()
# DGROUP string segment at 2b5a:0000 = file 0x01D9A0
base = 0x01D9A0
print('CASHTREASURE:', data[base+0x1be0:base+0x1bec].decode())
print('KINGGALLEON :', data[base+0x1bed:base+0x1bf8].decode())
print('LOOTCASH    :', data[base+0x1bfd:base+0x1c05].decode())
print('BURNED      :', data[base+0x1c28:base+0x1c2e].decode())
print('CHIEFKILL   :', data[base+0x1668:base+0x1671].decode())
print('SMITEINDIANS:', data[base+0x1a1a:base+0x1a26].decode())
"
```

Should output the exact strings — confirming the function
identifications in [`viceroy_source/FUNCTION_INVENTORY.md`](viceroy_source/FUNCTION_INVENTORY.md).

---

## Step 8: Render and verify the UI screens

Each major UI screen has a dedicated renderer that composes its layout
from extracted assets. All fonts/colors/positions are pixel-verified
against DOSBox screenshots.

```bash
# Run all dedicated renderers
python tools/render_colony.py
python tools/render_gameplay.py
python tools/render_europe.py
python tools/render_score.py
python tools/render_nations.py
python tools/render_menu.py
python tools/render_cc.py
python tools/render_declaration.py

# Render all 6 dialog examples
python tools/render_dialog.py --all-examples --scale 2

# Generate side-by-side master verification sheet
python tools/verify_ui_renders.py
# -> writes verification/ui_verification_sheet.png comparing 11 renders
#    against their DOSBox reference screenshots where available
```

The verified font usage map is in [`docs/UI_RENDER_MAP.md`](docs/UI_RENDER_MAP.md);
the renderer architecture is in [`docs/RENDERER_ARCHITECTURE.md`](docs/RENDERER_ARCHITECTURE.md).

Open `verification/ui_verification_sheet.png` and visually compare
each rendered screen against its reference. All renders should be
structurally identical to DOSBox; deviations are documented in
[`docs/UI_RENDER_MAP.md`](docs/UI_RENDER_MAP.md) under "Code-citation gap".

---

## Step 9: Inspect the docs

The synthesis-doc tree is the human-readable summary:

```
docs/ARCHITECTURE.md           — top-level game architecture
docs/RENDER_CHAIN.md           — per-pixel render trace
docs/RENDERER_ARCHITECTURE.md  — per-screen renderer pipeline
docs/UI_RENDER_MAP.md          — pixel-verified element catalog
docs/UI_FONT_REFERENCE.md      — code-cited font reference
docs/DATA_MODEL.md             — record types and DGROUP layout
docs/ASSET_ROLES.md            — every asset → loader function
docs/UI_DIALOGS.md             — every dialog cataloged
docs/RTLINK_OVERLAYS.md        — overlay system explained
docs/ENGINE.md                 — MADS + RTLink Plus + MSC 6.0 layers
docs/PALETTE_AND_CYCLING.md    — palette mechanism
```

Plus per-format specs in [`formats/`](formats/).

Plus the full function inventory:
```
viceroy_source/FUNCTION_INVENTORY.md
viceroy_source/D1D_181F_RUNTIME.md
viceroy_source/COMPLETE_FINDINGS.md
viceroy_source/VERIFICATION_LEDGER.md
viceroy_source/GAME_SYSTEM_ANCHORS.md
```

---

## Step 9 (optional, ~10 min): playable-rebuild smoke test

For the end-to-end Phase G verification (when implemented):

1. Re-encode all decoded assets back to original COLONIZE/ format.
2. Drop into `verification/COLONIZE_rebuilt/` directory.
3. Boot in DOSBox: `dosbox -conf verification/dosbox.conf`.
4. Play 5 turns of AMER2.MP.
5. Compare against original behavior — same gold awards, same combat
   outcomes (if RNG seed matches), same screen renders.

Status: stub — Phase G is gated on Phase D maturity.

---

## What "100% done" looks like

```bash
# All gates green:
python tools/verify.py                     # 319/319 PASS
python tools/sigmatch.py --self-test       # 17/17 PASS
python tools/ledger_update.py              # VICEROY 100%, MAPEDIT 100%
python tools/linkcheck.py                  # zero broken citations
python tools/canary_test.py                # frozen-output regression PASS
# Manual: DOSBox smoke test passes
```

Any of these failing means the project isn't finished. Both this
BUILD.md and the STATUS.md should match.

---

## Reference

- Original plan: `c:/Users/gregc/.claude/plans/in-this-is-the-radiant-tarjan.md`
- Verification ledger: [`viceroy_source/VERIFICATION_LEDGER.md`](viceroy_source/VERIFICATION_LEDGER.md)
- Status dashboard: [`STATUS.md`](STATUS.md)
- Manifest of all COLONIZE/ files: [`MANIFEST.md`](MANIFEST.md)
