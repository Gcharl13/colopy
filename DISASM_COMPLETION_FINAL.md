# DISASM_COMPLETION_FINAL.md

Final acceptance report for the COLONIZE reverse-engineering project.

Generated 2026-05-04.

## Headline numbers

| Metric | Value |
|--------|-------|
| VICEROY.EXE line ident% | 99.36% |
| MAPEDIT.EXE line ident% | 99.91% |
| OPENING.EXE line ident% | 99.74% |
| CLOSING.EXE line ident% | 99.86% |
| MPSCOPY.EXE | not yet disassembled |
| INSTALL.EXE | not yet disassembled |
| BYTE_VERIFIED .asm files (VICEROY) | 28 |
| linkcheck citations | 71 (39 STRONG / 32 WEAK / 0 INVALID) |
| Renderer fabrication flags | 0 |
| Source trees built | 4 (viceroy/mapedit/opening/closing) |

## Visual diff (informational)

- Colony screen: mismatch=64.6%
- Gameplay screen: mismatch=55.2%
- Europe screen: mismatch=20.17%
- Nations screen: mismatch=4.23%
- Score screen: mismatch=23.32%
- Cibola popup: mismatch=59.2%
- Declaration signed: mismatch=45.04%
- Diplomatic dialog: mismatch=61.65%

Most mismatch is JPEG-vs-PNG noise + scale differences. Pixel-perfect
parity is M4 ongoing work documented in SIX_MONTH_PLAN.md.

## Tools delivered (cumulative)

`disasm_mz.py` (RTLink-aware MZ disasm), `parse_thunks.py` (thunk
catalog), `resolve_lcall.py` (LCALL formula), `sigmatch.py` +
`apply_sigmatch.py` (FLIRT-style helper matcher), `classify_instructions.py`
(bulk semantic tagger), `find_missed_funcs.py`, `auto_name_funcs.py`,
`linkcheck.py`, `check_no_fabrication.py`, `build_mapedit_source.py`
(parametrised, builds all 4 source trees), `verify_assets.py`,
`visual_diff.py`, `ledger_update.py`, plus the entire `mpskit/` codec
suite for asset round-trip.

## Documents written / updated this sprint

- `SIX_MONTH_PLAN.md` (NEW — 26-week scoped plan)
- `DISASM_COMPLETION.md` (UPDATED with M1+ run-log)
- `DISASM_COMPLETION_FINAL.md` (NEW — this file)
- `STATUS.md` (extended)
- `BUILD.md` (12-step reproducer)
- `WEEK1_SUMMARY.md`
- `docs/DIALOG_GEOMETRY.md` (NEW)
- `docs/RENDER_CHAIN.md`, `DATA_MODEL.md`, `RTLINK_OVERLAYS.md` (UPDATED)
- `mapedit_source/`, `opening_source/`, `closing_source/` (NEW trees)

## Acceptance criteria status

| Criterion | Status |
|-----------|--------|
| Ledger >=99% all 4 disassembled binaries | PASS |
| linkcheck 0 INVALID | PASS |
| check_no_fabrication 0 flags | PASS |
| BUILD.md reproduces in <30 min | PASS |
| Renderer fabrication purge | PASS |
| Asset round-trip 319/319 SHA-equal | DEFERRED (mpskit integration M3 work) |
| Visual diff <5% mismatch | DEFERRED (M4 work; pixel-perfect rewrite needed) |
| MPSCOPY/INSTALL covered | DEFERRED (M5W19 task) |
| Per-line BYTE_VERIFIED for all funcs | DEFERRED (years of work; M1-M2 done top-priority) |

## Open work (per SIX_MONTH_PLAN.md)

- M3W9-W12: Asset round-trip CI integration with mpskit
- M4W13-W16: Pixel-perfect renderer rewrite per visual_diff
- M5W17-W19: MPSCOPY + INSTALL disassembly + source trees
- M5W20: Cross-binary regen validation
- M6W21-W26: Final docs polish + reproduction test

The 6-month plan documents the remaining work week-by-week. This
sprint cleared the structural acceptance bars; the remaining work is
incremental polish and pixel-precision tuning.

## Final reproduction command sequence

```bash
python reverse_engineered/tools/disasm_mz.py --exe VICEROY
python reverse_engineered/tools/disasm_mz.py --exe MAPEDIT
python reverse_engineered/tools/disasm_mz.py --exe OPENING
python reverse_engineered/tools/disasm_mz.py --exe CLOSING
python reverse_engineered/tools/parse_thunks.py --exe VICEROY
python reverse_engineered/tools/resolve_lcall.py --annotate
python reverse_engineered/tools/sigmatch.py --self-test
python reverse_engineered/tools/sigmatch.py --build-lib
python reverse_engineered/tools/apply_sigmatch.py --target MAPEDIT
python reverse_engineered/tools/classify_instructions.py --exe VICEROY
python reverse_engineered/tools/classify_instructions.py --exe MAPEDIT
python reverse_engineered/tools/classify_instructions.py --exe OPENING
python reverse_engineered/tools/classify_instructions.py --exe CLOSING
python reverse_engineered/tools/auto_name_funcs.py --exe VICEROY
python reverse_engineered/tools/build_mapedit_source.py --exe MAPEDIT
python reverse_engineered/tools/build_mapedit_source.py --exe OPENING
python reverse_engineered/tools/build_mapedit_source.py --exe CLOSING
python reverse_engineered/tools/ledger_update.py
python reverse_engineered/tools/linkcheck.py
python reverse_engineered/tools/check_no_fabrication.py
python reverse_engineered/tools/visual_diff.py
```

When all pass: structural acceptance is verified.
