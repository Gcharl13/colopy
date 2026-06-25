# Ghidra runbook — decompile the report-screen painters (and other overlay code)

**Goal:** turn the report-screen render code from a black box into readable C, so the field
layouts become **citable byte-fact** instead of guesses that get re-litigated. Most of the
churn-prone UI/report logic was "TBD" only because it was never decompiled.

There are two tiers. **Do Tier 1 — it needs no overlay surgery at all.** Tier 2 is the harder,
optional path for code that lives only in VICEROY's overlays.

---

## Tier 1 — the report painters (RESIDENT in COLONIZE.EXE) — *do this one*

The advisor-report (F2–F9) painters are in the **plain load image of COLONIZE.EXE** (the
smaller "recol" build). No memory blocks, no segment math, no scripts — a normal import
decompiles them. (Byte-verified: `code/COLONIZE/disasm/func_01EFA3_unknown.asm` is
`Region: load_image`, prologue `ENTER 0x82,0` — a report painter. The committed disasm there
is a *truncated 272-byte stub* from a splitter bug; Ghidra gives the full ~1900-byte function,
which is exactly why running it is worth it.)

### Steps (Windows)
1. Reconstitute the binary:
   ```
   python bin/reconstitute.py
   ```
   → `raw/COLONIZE/COLONIZE.EXE` (455,137 bytes).
2. Ghidra → **`File → Import File`** → `raw/COLONIZE/COLONIZE.EXE`. Accept the **MZ / x86
   16-bit real mode** language the loader offers. Let **Auto-Analyze** run.
3. Find the painter by its bytes (file offset `0x1EFA3` becomes a `seg:off` address after
   import, so search bytes instead). In the CodeBrowser:
   - **`Search` menu → `Memory…`** (keyboard shortcut **`S`**).
   - In the *Search Memory* dialog, set **Format = `Hex`** (NOT String — String finds nothing).
   - Enter **`c8 82 00 00 56`** (`ENTER 0x82,0; PUSH si`; spaces optional).
   - Click **`Search All`** → exactly **one** result (this pattern is unique in COLONIZE.EXE).
     Double-click it to jump there.
   - If it shows as raw bytes, press **`D`** to disassemble, then open the **Decompiler**
     (`Window → Decompiler`). You should see real C — a `load_PIK` call, a 320×200 rect fill,
     and a loop over a record list — **not** `halt_baddata()`.
   - (The other report painters share the `C8 ?? 00 00 56` shape with different frame sizes.)
   - *If `Search All` finds nothing:* confirm Format is `Hex` and that Auto-Analyze has finished
     (the search only covers loaded bytes).
4. Export the C: **`File → Export Program → C/C++`** → save as
   `ghidra_export/COLONIZE_reports.c`. (Exporting the whole program is fine.) Commit + push:
   ```
   git add ghidra_export/COLONIZE_reports.c
   git commit -m "ghidra: COLONIZE report-painter decompile export"
   git push
   ```
5. Tell me it's pushed.

### What you'll see (so the output isn't misread)
Decompiling yields, per report:
- **Literals** — the background/frame: a `load_PIK("REPORTn")`, a `320×200` rect (`0x140`,`0xC8`),
  and a few fixed column anchors (e.g. `x=26`).
- **A per-row layout FORMULA, not a flat coordinate list** — field rows are drawn in a **loop**
  over a record table, with the row Y walked per iteration (`base + index·pitch`). So the useful
  output is **"anchor + pitch + which record table feeds it"** per report — which is *more*
  faithful than guessing one coordinate per field.

### One thing to confirm first (don't assume the F-key labels)
The per-F-key mapping isn't pinned: the function commonly labeled "F5/Economic" actually reads
the REF/Expeditionary tables (looks military). Before labeling F2–F9, note **which `REPORTn.PIK`
each function loads** (the `load_PIK` string) and/or its **MISC title index** — that's the
ground truth for which painter is which report. I'll do this when I parse the export; flag it if
you spot it.

### Then I integrate (TBD → B)
From `COLONIZE_reports.c` I record each report's layout formula (frame literals + per-row anchor
& pitch + feeding record table) as **B** in the canonical spec and the lab **Screens** tab
(anchor+pitch rows replacing the TBD drag-to-measure fields), citing the COLONIZE function offset.

---

## Tier 2 — VICEROY overlay pages (optional, harder — *skip unless needed*)

Only for code resident **only** in VICEROY.EXE's overlays (not in COLONIZE's load image). In
VICEROY the report painters are in **overlay page 0x06** (`code/VICEROY/disasm_overlay_reseg/page_06.asm`);
the report helpers (PIK loader, score renderer) are in **page 0x05**.

Prep the per-page block manifest:
```
python bin/reconstitute.py          # -> raw/COLONIZE/VICEROY.EXE
python tools/ghidra_prep_overlays.py # -> code/VICEROY/ghidra_overlay_blocks.json (31 page blocks)
```
This now emits **one contiguous block per overlay page** at its real code base (e.g. page 0x06 @
`0x3B900`, page 0x05 @ `0x37340`) — not the old 209 flat-file-offset blocks (those were unsafe in
a 16-bit segmented program).

Import `raw/COLONIZE/VICEROY.EXE` (x86 16-bit real mode), then add the pages:
- **Bulk:** `Window → Script Manager` → run `tools/ghidra_add_overlays.py`. **When it asks how
  many blocks, enter `1` first** — confirm that one overlay function decompiles to real C — then
  re-run with `0` (all 31).
- **Manual fallback (one page):** `Window → Memory Map → + (Add Block)` → Initialized, **File
  Bytes** = `VICEROY.EXE` at the page's `file_offset`, length from the manifest. Disassemble (`D`).

Then `Analysis → Auto Analyze`, `File → Export Program → C/C++` → `ghidra_export/VICEROY_overlays.c`,
commit.

### Tier-2 honesty
- 16-bit real-mode addressing of these page bases is the **unverified** part — that's why the
  script says validate one block first. If `createInitializedBlock`/`getAddress` throws, send me
  the error.
- Cross-page **type-A far calls won't resolve** (`jmpf_seg=0x0000`, runtime-paged — see
  `code/VICEROY/thunks_resolved.json`). Expected; extract per-function facts, not the call graph.
- The raw overlay disassembly already exists at `code/VICEROY/disasm/orphans_overlay.asm` and
  `code/VICEROY/disasm_overlay_reseg/page_0{5,6}.asm` — use it as a cross-check.

---

## Why this is the right first move
Tier 1 converts a re-guessed subsystem (report layouts) into byte-fact with a **plain import and
no overlay surgery**. A decompiled `load_PIK + 320×200 rect + a record loop with base+pitch`
**is** the layout — there's nothing left to re-litigate. That's one concrete TBD→B win that the
churn metric (`tools/churn_metric.py`) should reflect.
