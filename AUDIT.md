# AUDIT — Project State, Correct vs Misleading Information

**Date:** 2026-06-18 · **Branch:** `claude/repo-audit-map-editor-rt0v5l`
(identical to `main` @ `2855885`)

> **2026-08-17:** for the *forward* view — what is still open to finish the
> handheld build — see **`docs/REMAINING_WORK.md`**. This document remains the
> record of correct-vs-misleading information; that one is the work queue.

Purpose: establish the **real** progress of this reverse-engineering bench,
separate **correct** information from **bad/misleading** information that has
been blocking completion, and record the decision to re-approach the map editor
as clean modern C. This document is the single rationale index for the cleanup
applied in this pass (quarantine, status consolidation, `CLAUDE.md` recreation).

---

## 1. Branch reconciliation

`main` and `claude/repo-audit-map-editor-rt0v5l` point at the **same commit**
(`2855885`); there is no divergent branch work to merge. History is 6 linear
commits — an early phased import (Phase 1 C source → Phase 2 disasm/tooling →
Phase 3 data) topped by "Add files via upload" snapshots. **Conclusion:** the
"audit including branches" reduces to auditing one tree; no cross-branch
conflicts exist.

---

## 2. What is CORRECT (keep and trust)

| Area | Evidence | Tier |
|------|----------|------|
| VICEROY core hand-ports | `viceroy_source/` ~47 functions with `@asm` offsets; `VERIFICATION_LEDGER.md`, `COMPLETION.md` mark tiers honestly | BYTE_VERIFIED |
| Trust discipline | `notes/TRUTH_HIERARCHY.md`, `notes/rulings/RULINGS.md` — C reconstruction ranked *low trust* on purpose; corrections logged, not silently edited | — |
| `.MP` format | `formats/MP_FORMAT.md` — header, tile bit layout, terrain table from NAMES.TXT `$TERRAIN`, auto-forest byte-verified at `func_006204`; only 3 honest `TODO_VERIFY` items | mostly verified |
| Tooling | `tools/disasm_mz.py`, `sigmatch.py` (self-test 17/17), `rtlink/`, `reconstitute.py`, `verify.py` (319/319 round-trip) — self-contained | PASS |
| MAPEDIT raw evidence | `code/MAPEDIT/disasm/*.asm` (212 files), `*.json` (functions/relocs/strings/classification), `MAPEDIT_ANALYSIS.md`, `FUNCTION_INVENTORY.md` | authoritative |
| Asset round-trip (PAL, MP) | byte-perfect via `extract/encode_pal.py`, `extract/encode_mp.py` | PASS |

The honest tier system already exists in the *detail* docs. The problem was
never the underlying RE — it was the **top-level summaries layered over it**.

---

## 3. What is MISLEADING / REDUNDANT (the actual blockers)

### 3.1 The map-editor "source" is ~0% semantic *(fixed this pass)*
`mapedit_source/src/` was ~6,460 lines of auto-generated control-flow
skeletons — every function `@status SKELETON (auto-traced control flow;
semantics TBD)`, bodies reduced to `if (ax != 0) {}` with registers/meaning
discarded (e.g. `legacy_autogen/src/load_image/load_image_015CA2_0172C7.c:25`).
Yet `mapedit_source/README.md` claimed *"hand-ported semantic detail on the
largest functions."* **That claim was false for MAPEDIT** and is the central
piece of bad information: it presents ~6,500 lines of unusable scaffolding as
progress.
**Action taken:** moved to `mapedit_source/legacy_autogen/` with a do-not-cite
disclaimer; rewrote `mapedit_source/README.md`; wrote `mapedit_source/REWRITE_PLAN.md`
for the clean modern-C re-approach.

### 3.2 `CLAUDE.md` was missing but cited 30+ times *(fixed this pass)*
The "prime directive + agent roster" and hard-rules authority was referenced in
`formats/MP_FORMAT.md`, `BUILD.md`, `notes/STATE.md` (drawn in its tree),
`notes/PROJECT_BOARD.md` (marked `[x]` done), and many `docs/*`,
`viceroy_source/docs/*`, `tools/*` — but **did not exist**. Every "per CLAUDE.md
hard rule" citation resolved to nothing.
**Action taken:** reconstructed `/CLAUDE.md` from the surviving rule text, each
rule carrying its citation.

### 3.3 Contradictory / stale status docs *(banners + consolidation this pass)*
`PROGRESS.md` states "Phase 2 IN PROGRESS", "100% of 1,241 functions in citable
C", and "OPENING/CLOSING not started" — contradicted by
`DISASM_COMPLETION_FINAL.md` (sprint complete; OPENING/CLOSING classified to
99%+). Three docs competed to be "the status": `PROGRESS.md`, `STATUS.md`,
`DISASM_COMPLETION.md` (+ its `_FINAL` twin).
**Action taken:** `STATUS.md` designated single source of truth; STALE banners
added to `PROGRESS.md`, `DISASM_COMPLETION.md`, `WEEK1_SUMMARY.md`,
`OVERLAY_PLAN.md`; a "1 of 26 weeks executed" caveat added to `SIX_MONTH_PLAN.md`.

### 3.4 Inflated headline metrics *(corrected wording this pass)*
"100% of functions in citable C" and "99.36% lines identified" conflate
*syntactically tagged/stubbed* with *semantically understood*. Reality: ~3.8%
byte-verified; the rest are skeletons/stubs with syntactic tags. The *detail*
docs (`COMPLETION.md`, `VERIFICATION_LEDGER.md`) are honest; only the headlines
inflated.

### 3.5 Dangling paths *(annotated this pass)*
`extracted/...`, `colonize_src_v3/`, `viceroy_overlay_full.asm`,
`function_index.json` are cited in `notes/TRUTH_HIERARCHY.md` and ~16 other
files. `extracted/` was deleted + git-ignored (commit `b0aa17b`); committed
decoded data lives in `data_extracted/`.
**Action taken:** added a single path-convention note in `/CLAUDE.md` and
`notes/TRUTH_HIERARCHY.md` clarifying `extracted/` is regenerable/uncommitted
rather than rewriting every in-doc path (mass path-edits across 17 files would
risk more harm than the dangling references themselves).

### 3.6 `col.zip` vs the "no verbatim binaries" policy *(kept, per decision)*
`col.zip` (5.1 MB uncompressed, 600 files) is a **verbatim** bundle of the
original game, including `VICEROY.EXE` (494,910 bytes) and `AMER2.MP`. This
contradicts `README.md`'s stated policy: *"No verbatim binaries (they live only
as `bin/*.b64`)."* It is also redundant with `bin/*.b64` + `reconstitute.py`.
**Decision (user):** keep `col.zip`; recorded here as a known policy exception.
The policy text in `README.md` should be read with this exception in mind.

---

## 4. Corrected metrics (use these, not the headlines)

| Component | Honest state |
|-----------|--------------|
| VICEROY.EXE functions | ~1,241 detected; **~47 BYTE_VERIFIED (~3.8%)**; remainder SKELETON/RECONSTRUCTED with `@asm` citations |
| VICEROY overlay | ~691 functions auto-detected (~28% of the 362 KB overlay); deep semantics ~a handful of functions |
| OPENING / CLOSING.EXE | classified ≥99% *lines* (syntactic tags); source = honest RAW stubs, ~13 sigmatch BYTE_VERIFIED helpers |
| MAPEDIT.EXE | 210 functions detected; **0 hand-decoded to clean C**; 5 sigmatch BYTE_VERIFIED shared helpers; clean rewrite planned (`mapedit_source/REWRITE_PLAN.md`) |
| Assets | PAL + MP round-trip byte-perfect; full 319-file SHA round-trip via `verify.py` PASS; image extraction deferred (regenerable) |
| "lines identified" | ~99% **syntactic** tags ≠ semantic understanding (~few %). Do not quote the 99% figure as completion. |

---

## 5. Map-editor re-approach (decision)

The auto-traced skeleton cannot be "finished" — there is nothing to build on.
The map editor is being re-approached as a **clean, modern-C reconstruction**,
hand-decoding the genuinely MAPEDIT-specific functions (`.MP` read/write, menu
dispatcher, tile-palette UI) from `code/MAPEDIT/disasm/`, grounded only in
verified facts (NAMES.TXT terrain table, `func_006204` auto-forest, the `.MP`
format, sigmatch'd shared helpers), with the same cite-or-TBD discipline as
`viceroy_source/`. Full design: `mapedit_source/REWRITE_PLAN.md`. **No clean C
is written yet** — the rewrite is planned and awaits go-ahead.

---

## 6. Recommended next steps (not done this pass)

1. Execute `mapedit_source/REWRITE_PLAN.md` step 1–2 (terrain + `.MP` I/O) and
   prove the `AMER2.MP` round-trip with `tools/verify.py`.
2. Resolve the 3 `MP_FORMAT.md` `TODO_VERIFY` items by tracing the `.MP` loader.
3. Optionally reconcile the `README.md` "no verbatim binaries" wording with the
   `col.zip` exception, or relocate `col.zip` out of the tree if the policy is
   to be enforced.
