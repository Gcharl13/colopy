# Following RTLink overlay thunks (mitigation notes)

How to read code that hides behind an overlay thunk (`LCALL seg:off` to the
`0x18xx`/`0x19xx`/`0x1Axx` thunk segments), and what tooling already exists.

## Branch survey (2026-06-19)
Checked the sibling branches for thunk tooling: `claude/beautiful-maxwell-EUu9I`
and `claude/clever-franklin-kx8gse` are **rendering** branches (Europe screen,
colony work-grid, coast tiles) and carry **no** RTLink/thunk tools. This branch
(`claude/repo-audit-map-editor-rt0v5l`) has the complete suite:
`tools/rtlink/rtlink_decode.py`, `viceroy_rtlink_map.json`, `thunk_xref.json`,
`RTLINK_V2.md`, plus `code/VICEROY/{thunks_resolved,typeA_thunk_targets,
overlay_thunks}.json`.

## The mechanism (byte-verified)
`LCALL seg:off` lands on a 7-byte **thunk stub** at the resident file offset
`0x2400 + seg*16 + off`:
```
LCALL 0x110D:0xD91     ; RTLink page-loader (pages in the overlay)
LJMP  S:O              ; jump to the paged-in code
```
- **Type-B (resident):** `S:O` is in the always-loaded image →
  file `0x2400 + S*16 + O`. Disassemble directly.
- **Type-A (paged overlay):** `S:O` is in an overlay page →
  file `overlay_pages[page_id].code_offset + (S<<4) + O`
  (formula in `code/VICEROY/typeA_thunk_targets.json`; pages in
  `overlay_functions_reseg.json`). The `page_id` comes from the call-site's page.

## The enabler: capstone
`pip install capstone` works in this environment, so any file offset (thunk
targets, unenumerated overlay gaps) can be disassembled on demand:
`tools/follow_thunk.py 0x181f 0x9a4` (resolve+disasm a thunk) or
`tools/follow_thunk.py --at 0x05FE60` (disasm a file offset). It lists call
sites, reads the stub's `LJMP`, classifies Type-A/B, and disassembles Type-B
targets directly.

## Caveats (learned the hard way)
- The inline disasm annotations `... overlay @file 0xNNNNNN` are **unreliable for
  Type-A thunks** — e.g. `0x181F:0x9A4` is annotated `@file 0x5FE0C`, which is
  **data/padding**; the real `LJMP` target is `0x05B3:0x01E0` in a page. Trust the
  stub `LJMP` + the page formula, not the annotation offset.
- **Call-site count is a strong signal of role.** A thunk with dozens of callers
  across unrelated systems is a shared utility, not a system-specific function:
  `0x181F:0x9A4` has **92** callers; `0x181F:0x4D4` (random_int) has **222**. So
  attributing such a thunk to one feature (see the corrected market-drift note in
  `spec/BACKLOG.md` #2) is a mistake.

## UPDATE 2026-06-19 — type-A resolution solved (89%)

The pre-computed thunk table in `viceroy_rtlink_map.json` (1023 thunks, each with
`type`, `page_id`, `ljmp_seg`, `offset_in_segment`) resolves every thunk:
```
base = 0x2400                            (type-B resident)
       segments[page_id-1].code_offset   (type-A paged)
target_file_offset = base + ljmp_seg*16 + offset_in_segment
```
This lands on a clean function prologue for **906/1023 = 89%** of thunks (the
map's own `page_id_model` text omitted the `ljmp_seg<<4` term and only hit 68% of
type-A; the `typeA_thunk_targets.json` formula with that term is the correct one).
`tools/follow_thunk.py` now uses this; `--emit` writes
`data_extracted/thunk_targets.json` (stub → resolved file offset for all 1023).
First payoff: the scoring component-sum `0x191F:0x3AA` resolves to file `0x39EE2`
(see `spec/systems/scoring.md`).
