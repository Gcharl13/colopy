# Ghidra Phase 2 — decompile the overlay code (runbook)

**Why:** the committed Ghidra export (`ghidra_export/VICEROY_decompiled.c`) covers only the
**load image** (file `0x2400..0x20665`). Every overlay function decompiles to
`halt_baddata()` because the overlay code was never added to the Ghidra program. That
overlay code is where the **report screens, market, and most UI/render logic** live — i.e.
the subsystems that keep getting *re-guessed* because nobody can read them as C. Loading the
overlay regions makes those function bodies decompile, so their literal operands (a field's
`x`/`y`, a constant) become **citable byte-fact** instead of opinion.

> The overlay bytes are already raw-disassembled at `code/VICEROY/disasm/orphans_overlay.asm`
> (~109k lines) and `orphans_load_image.asm` — use those as a cross-check. Phase 2 turns that
> wall of asm into readable decompiled C.

**What Phase 2 delivers / does not:**
- ✅ Function **bodies** decompile — control flow, locals, and **literal operands** (the
  coordinates/values we need).
- ⚠️ Cross-overlay **far calls** (type-A, 658 of them) may stay unresolved: their target
  segment is patched by RTLink at runtime (`jmpf_seg = 0x0000` placeholder, see
  `code/VICEROY/thunks_resolved.json`). That's fine — we extract per-function facts, not the
  cross-overlay call graph.

---

## Steps (Windows)

### 0. Prereqs
- Ghidra installed (any recent build).
- This repo checked out. Reconstitute the EXE:
  ```
  python bin/reconstitute.py
  ```
  → produces `raw/COLONIZE/VICEROY.EXE`. Generate the overlay block manifest:
  ```
  python tools/ghidra_prep_overlays.py
  ```
  → writes `code/VICEROY/ghidra_overlay_blocks.json` (209 overlay regions, ~123 KB).

### 1. Import the EXE
- Ghidra → `File → Import File` → `raw/COLONIZE/VICEROY.EXE`.
- Language: **x86, 16-bit, real mode** (the MZ loader will offer this). Let auto-analysis run
  on the load image first (this reproduces the existing Phase-1 export).

### 2. Add the overlay blocks
Two ways — **do the targeted one first.**

**a) Targeted (recommended first):** you usually only need the one overlay region behind the
screen you're decoding. Find its file offset in `orphans_overlay.asm` (search for the painter,
e.g. a report's title-painter `LCALL 0x4509,0x10f`), then add just that block:
`Window → Memory Map → + (Add Block)` → Block Type **Initialized**, **File Bytes** source =
`VICEROY.EXE` at that file offset, length from the manifest. Disassemble it (`D`), open in the
Decompiler.

**b) Bulk (all 209):** `Window → Script Manager` → run `tools/ghidra_add_overlays.py`.
**Validate first:** when it asks "how many blocks", enter **1**, confirm that one overlay
function decompiles to real C, *then* re-run with **0** (all). If a block overlaps a Phase-1
segment it's skipped, not aborted.

### 3. Re-analyze + export
- `Analysis → Auto Analyze` (accept defaults; the new blocks get disassembled).
- `File → Export Program → C/C++` → save as `ghidra_export/VICEROY_overlays.c`.
- Commit it:
  ```
  git add ghidra_export/VICEROY_overlays.c
  git commit -m "ghidra: Phase-2 overlay decompile export"
  git push
  ```

### 4. Hand back
Tell me it's pushed. I parse `VICEROY_overlays.c` and extract byte-cited facts for the
currently-TBD subsystems — **starting with the F2–F9 report painters** (the field `x`/`y` the
lab Screens tab marks TBD) — landing each as a **B** fact in the canonical `spec/` doc (and the
Screens-tab seed), citing the Ghidra function. That's a TBD→B conversion that can't be
re-litigated.

---

## Validation / sanity
- A known-good check: after loading, a resident **type-B** thunk target should match
  `code/VICEROY/thunks_resolved.json` `anchor_validation` (e.g. thunk `0x1aaa6` → target file
  `0x513c`). If your loaded bytes decode to the same instructions there, placement is right.
- If a report painter's decompiled C shows a sequence like
  `draw_text(font, 0x46, 7, "...")` (or the equivalent `push 0x46; push 7; lcall`), that
  `0x46,7` **is** the field position — exactly the kind of fact we want.

## Known limits / honesty
- Linear `base = file offset` placement means cross-overlay far-calls won't auto-link; extract
  per-function facts. Resolving the full type-A call graph (runtime overlay paging) is a
  separate, harder follow-up and is **not** required for the position/value decode that breaks
  the churn.
- `tools/ghidra_add_overlays.py` is written against the standard Ghidra FlatProgramAPI but is
  **untested on your build** — that's why step 2b says validate on one block first.
