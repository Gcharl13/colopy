# Truth Hierarchy

When evidence from different sources conflicts, the higher-numbered source wins.
This document exists because **the same factual disputes have been re-litigated
multiple times in this project.** Write rulings down; don't re-fight them.

> **Path note (2026-06-18):** some sources below cite `extracted/…` (e.g.
> `extracted/assets/sprites/`), and elsewhere the repo references
> `colonize_src_v3/`, `viceroy_overlay_full.asm`, `function_index.json`. These
> are **regenerable, git-ignored** working artifacts (produced by
> `tools/extract_visuals.py` and the disasm drivers), **not committed**.
> Committed decoded data lives in **`data_extracted/`**. A citation to
> `extracted/…` means "regenerate it, then inspect" — it is not a dead link.
> See `CLAUDE.md` → "Path convention".

## The hierarchy

| # | Source | Why it ranks here |
|---|--------|-------------------|
| 1 | Running DOS game in DOSBox (screenshot or recording) | Ground truth — what a user actually sees. |
| 2 | Pixel inspection of extracted sprites (`extracted/assets/sprites/`) | What's literally on disk. Cannot be wrong about itself. |
| 3 | `VICEROY.EXE` disassembly at a cited offset | What the binary executes. May not be fully decoded yet. |
| 4 | Pre-processed disassembly (`viceroy_overlay_full.asm`, `function_index.json`) | One hop from #3. Trust unless #3 directly contradicts. |
| 5 | Team docs (`docs/`, `notes/`) | Accumulated knowledge. Can be stale; update when overruled. |
| 6 | C reconstruction (`mapedit.c`, `src/*.c`, `colonize_src_v3/`) | **Low trust.** Has been wrong about terrain ordering, sprite roles, etc. Never wins unless higher sources are silent *and* multiple C files agree. |
| 7 | AI agent speculation (any Claude session — including the current one) | Lowest trust. Always requires corroboration from levels 1–6. |

## Special source: the original game manual (user-provided 2026-05-30)

`docs/GAME_MANUAL.md` is the official Colonization manual /
Technical Supplement (converted from the user's `document.md`). It documents the
**design intent — how each feature is meant to FUNCTION.** Authority rule:

- **For a feature's FUNCTION / which factors matter** (e.g. "fortified units get a
  defense bonus", "the attacker gets a bonus", "veterans are stronger", "terrain
  affects defense", "SoL status becomes an attack bonus during the revolution") →
  the manual is **HIGH trust** — above the C reconstruction and team docs. Use it to
  confirm a decoded function does the right *thing* and to find factors a decode missed.
- **For exact NUMBERS** (the actual %s, table values, thresholds) → the **EXE bytes
  (source 3) WIN.** The user warned patches may have changed values; the manual can be
  a stale number even when its *description of the mechanic* is correct.
- A manual statement alone is **not** proof of a code path; it's corroboration that
  guides where to look in the bytes. Cite-or-TBD still governs the C.

## Special rule: pixels vs. disassembly

When source **2 (pixels)** and source **3 (disassembly)** disagree:

- **About what a sprite depicts** → pixels win. The binary might select a sprite index at runtime from a table that's still being decoded; the rendered pixel is the rendered reality.
- **About when a sprite is drawn** → disassembly wins. Pixels show what's on disk, not the conditions under which the game draws it.

Example: disassembly says "palette slot 0x1B (labelled 'Hills') uses PHYS0 row 0x21." Pixels show row 0x21 contains snow-capped peaks (mountains). These are consistent if the DOS game's palette-slot labeling swapped "Hills" and "Mountains" relative to the C reconstruction — and that's probably what happened. **Ruling lives in `docs/RULINGS.md`.**

## Who arbitrates

The `cross-source-reconciler` agent applies this hierarchy and records the ruling
to `docs/RULINGS.md`. Do not rule conflicts in the main conversation thread —
rulings should survive compaction by living in the file.

## When to update this document

Add rules, not decisions. Decisions go in `docs/RULINGS.md`. Only amend this file
when a *meta* change is needed (e.g., a new source type enters the project, or we
collectively decide to reorder trust levels).

Every amendment requires explicit user sign-off.
