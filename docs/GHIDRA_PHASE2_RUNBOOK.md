# Ghidra runbook — decompile the VICEROY report-screen painters (overlay page 0x06)

**Target: VICEROY.EXE only** (the DOS build). The advisor-report (F2–F9) painters are
**overlay-resident** — they sit past VICEROY's load image (which ends at file `0x20665`), so a
plain import shows them as `halt_baddata()` and a byte search finds **no matches**. They all
live in **overlay page 0x06**; loading that one page makes them decompile.

> Cross-check available: the full disassembly of these functions is already committed at
> `code/VICEROY/disasm_overlay_reseg/page_06.asm` — I validate your export against it, and it's
> the fallback if Ghidra's overlay addressing misbehaves.

## What loading page 0x06 gives you
All the report painters in one block (verified file offsets / page-relative addresses):

| F-key (slot) | function | file offset | page-rel addr |
|---|---|---|---|
| F2 | `func_03BC42` | `0x3BC42` | `3b38:08c2` |
| F5-slot | `func_03CDA2` (`ENTER 0x82,0`) | `0x3CDA2` | `3b38:1a22` |
| F6 | `func_03D510` | `0x3D510` | `3b38:2190` |
| F7 | `func_03DA2A` | `0x3DA2A` | `3b38:26aa` |
| F8 | `func_03DE46` | `0x3DE46` | `3b38:2ac6` |

Page 0x06 = file `0x3B380 … 0x3E4E0` (size `0x3160`).

---

## Steps (Windows)
1. Reconstitute the binary:
   ```
   python bin/reconstitute.py
   ```
   → `raw/COLONIZE/VICEROY.EXE` (494,910 bytes — make sure it's **VICEROY**, not COLONIZE).
2. Ghidra → **`File → Import File`** → `raw/COLONIZE/VICEROY.EXE`. Accept the **MZ / x86 16-bit
   real mode** language. Let **Auto-Analyze** run (this covers the load image only).
3. **Add the overlay page as a memory block** — `Window → Memory Map`, then the **`+`** (Add
   Block) button:
   - **Name:** `ov_page06`
   - **Start Addr:** `3b38:0000`  (= linear `0x3B380`)
   - **Length:** `0x3160`
   - **Block Type:** Default, with **Initialized** selected; set the init source to **File
     Bytes** = the imported `VICEROY.EXE`, **File Offset = `0x3B380`**.
     (The goal: fill the block with VICEROY.EXE's bytes starting at file `0x3B380`. If your
     Ghidra build doesn't offer "File Bytes," use *Initialized* and then **Memory → Import…**/
     paste the bytes, but File Bytes is the clean way.)
4. Select the new `ov_page06` block in the Listing and press **`D`** (Disassemble).
5. Find the painter — now that the page is loaded the byte search works:
   - **`Search → Memory…`** (shortcut **`S`**) → **Format = Hex** → enter **`c8 82 00 00 56`** →
     **Search All** → one hit at **`3b38:1a22`** = `func_03CDA2`. (Or just **`G`** Go To →
     `3b38:1a22`.) Open the **Decompiler** → you should see real C: a `load_PIK` call, a 320×200
     rect, and a loop over a record table — **not** `halt_baddata()`.
   - The other painters are at the page-rel addresses in the table above.
6. Export: **`File → Export Program → C/C++`** → `ghidra_export/VICEROY_overlays.c`. Commit:
   ```
   git add ghidra_export/VICEROY_overlays.c
   git commit -m "ghidra: VICEROY overlay page 0x06 (report painters) decompile export"
   git push
   ```
7. Tell me it's pushed.

## What you'll see (so the output isn't misread)
Per report, decompiling yields:
- **Literals** — the background/frame: a `load_PIK("REPORTn")`, the `320×200` rect (`0x140`,`0xC8`),
  a few fixed column anchors.
- **A per-row layout FORMULA, not a flat coordinate list** — field rows are drawn in a **loop**
  over a record table, row Y walked per iteration (`base + index·pitch`). So the useful output is
  **"anchor + pitch + which record table feeds it"** per report.

## Confirm the F-key labels first (don't assume)
The per-F-key mapping isn't pinned — the `func_03CDA2` "F5 slot" actually reads the
REF/Expeditionary tables (looks military). Before labeling F2–F9, the ground truth is **which
`REPORTn.PIK` each function loads** (the `load_PIK` string) / its MISC title index. I'll resolve
that when I parse your export.

## Then I integrate (TBD → B)
I cross-check `VICEROY_overlays.c` against `page_06.asm` (same bytes → same instructions), confirm
the mapping, and record each report's layout formula as **B** in the canonical spec + the lab
**Screens** tab (anchor+pitch rows replacing the TBD drag-to-measure fields), citing the VICEROY
function offset (e.g. `func_03CDA2 @0x3CDA2`).

## Honesty / if it fights you
- The one unverified bit is whether Ghidra accepts the block at `3b38:0000` in this real-mode
  program. It *should* — the base sits above the load image (≤ `0x2B5A0`) and the whole block
  stays inside one 64-KB region (`0x30000–0x3FFFF`). **If Add Block throws on the address/length,
  tell me the error** and we adjust (or fall back to the committed `page_06.asm`).
- Cross-page **type-A far calls won't resolve** (runtime-paged, `jmpf_seg=0x0000`). Expected —
  we extract per-function facts, not the cross-overlay call graph.
- Bulk alternative (all 31 overlay pages at once): `Window → Script Manager` →
  `tools/ghidra_add_overlays.py` (it reads `code/VICEROY/ghidra_overlay_blocks.json`); **validate
  on one block first**. Not needed just for the reports.
