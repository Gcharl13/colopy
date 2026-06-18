# METHODOLOGY — How this project reaches an accurate, portable reconstruction

This document defines **how** the *Colonization* (`VICEROY.EXE`) reconstruction
is built. It exists because the project stalled in an endless cycle —
*decompile → write bad C → fix → go back to disassembly → repeat* — and the
root cause was structural, not effort: **one artifact (the line-for-line C) was
forced to be the evidence, the specification, AND the implementation at once,
while chained byte-for-byte to the disassembly.** Re-reading bytes forced a code
rewrite every time, and the code could never run to validate itself.

The fix is to separate those concerns into **three layers** and enforce one
direction of dependency.

## The three layers

| Layer | What it is | Where it lives |
|-------|-----------|----------------|
| **1 — Evidence** | Raw disassembly, byte-verified decode-notes, extraction tools, decoded data tables. The ground truth. | `code/`, `tools/`, `bin/`, `data_extracted/`, `ghidra_export/`, and **`viceroy_source/`** (the line-for-line C, now reclassified as evidence — see `viceroy_source/ROLE.md`) |
| **2 — Specification** | A clean, accurate, human-readable description of **every game behavior and every UI function** — formulas, state layouts, screen composition — each claim cited to Layer 1 and tagged with a confidence tier. **This is the project's baseline and source of truth.** | **`spec/`** |
| **3 — Implementation** | A modern, runnable port built *from the spec*. Idiomatic, testable, actually compiles and runs. | future programs (the map editor, `mapedit_source/`, is the first; build language TBD) |

## The one rule that breaks the cycle

> **Each layer is built only from the layer below it. Never skip a layer.**
> Layer 3 is built from Layer 2, **never directly from the bytes.**

Consequences:
- When a re-reading of the disassembly changes our understanding, the change
  lands in the **spec** (Layer 2). The implementation then follows the spec.
  **The spec — not the code — absorbs disassembly churn.** No more rewrite loop.
- The spec is **language-neutral**. Choosing C, C++, or anything else for Layer 3
  does not change Layer 2.
- The implementation is free to be clean and idiomatic, because it implements
  the *documented behavior*, not the *byte sequence*.

## Confidence tiers (shared vocabulary, per `notes/TRUTH_HIERARCHY.md`)

Every spec claim is tagged:

- **`BYTE_VERIFIED`** — read directly from the binary at a cited offset.
- **`ANCHOR_VERIFIED`** — pinned to a confirmed anchor (function boundary,
  string xref, runtime cross-check) but the exact value isn't byte-traced.
- **`RECONSTRUCTED`** — plausible behavior written from the manual / gameplay /
  decompiler inference; **not** byte-proven. Carry the caveat explicitly.
- **`TBD`** — unknown. An honest `TBD` is fine; **a guess poisons the rebuild.**

The trust order itself (running game > pixels > EXE bytes > preprocessed disasm >
team docs > C reconstruction > AI speculation) lives in
`notes/TRUTH_HIERARCHY.md`; conflicts are ruled in `notes/rulings/RULINGS.md`.

## Spec-authoring workflow (Layer 1 → Layer 2)

1. Pick a subsystem or UI screen from `spec/README.md`.
2. Gather evidence: disasm in `code/`, decode-notes in `viceroy_source/`,
   existing findings in `docs/` / `notes/`, data in `data_extracted/`.
3. Write/update the spec doc from `spec/_TEMPLATE.md`: behavior, state layout,
   formulas, UI layout, **evidence citations**, confidence tier, open questions.
4. Anything not byte-grounded is `RECONSTRUCTED` or `TBD` — never asserted.
5. Record any cross-source conflict in `notes/rulings/RULINGS.md`.

Layer-1 gap-closing work (turning `TBD`/`RECONSTRUCTED` sections into
`BYTE_VERIFIED`) is queued in `spec/BACKLOG.md`.

## What changed for existing material

- **`viceroy_source/` is no longer "the product."** It is Layer-1 evidence —
  valuable byte-verified decode-notes that feed the spec. See
  `viceroy_source/ROLE.md`. (This supersedes the "C source is THE product"
  stance in `viceroy_source/RECONSTRUCTION_PLAN.md`.)
- The scattered `docs/` and `viceroy_source/docs/` corpus is consolidated under
  the **`spec/`** index, which names the single canonical doc per topic;
  superseded duplicates carry redirect banners.

Entry points: `spec/README.md` (the specification) · `STATUS.md` (current state)
· `AUDIT.md` (correct-vs-misleading audit) · `CLAUDE.md` (hard rules).
