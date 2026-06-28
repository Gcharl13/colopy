#!/usr/bin/env python3
"""ghidra_prep_overlays.py — emit the per-PAGE overlay block manifest for Ghidra (Tier 2).

NOTE: for the report screens you do NOT need this — those painters are RESIDENT in
COLONIZE.EXE and decompile from a plain import (see docs/GHIDRA_PHASE2_RUNBOOK.md, Tier 1).
This script is only for the harder Tier-2 case: code that lives ONLY in VICEROY.EXE's
overlay pages.

The committed Ghidra export covers only VICEROY's load image (file 0x2400..0x20665); overlay
code decompiles to `halt_baddata()` because the pages were never loaded. This emits ONE
contiguous memory block per RTLink overlay PAGE (from code/VICEROY/overlay_pages.json
`pages`), each placed at a real per-page base — far safer than the prior 209 flat-file-offset
blocks (a single page is well under a 64-KB segment, and the base matches the project's
`disasm_overlay_reseg` address convention so function starts line up).

Block model: load `size_bytes` from VICEROY.EXE at file `file_offset`, placed at base =
`file_offset` (linear, == the reseg address space). The page's code starts at `code_offset`
within it; far calls across pages (type-A, runtime-paged) still won't resolve — extract
per-function facts.

Output: code/VICEROY/ghidra_overlay_blocks.json
Run:    python3 tools/ghidra_prep_overlays.py
"""
import json
import os
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
PAGES = os.path.join(ROOT, "code/VICEROY/overlay_pages.json")
OUT = os.path.join(ROOT, "code/VICEROY/ghidra_overlay_blocks.json")


def h(x):
    return int(x, 16) if isinstance(x, str) else int(x)


def main():
    with open(PAGES) as f:
        pages = json.load(f)["pages"]

    blocks = []
    for pid in sorted(pages, key=lambda k: h(k)):
        p = pages[pid]
        foff = h(p["file_offset"])
        size = h(p["size_bytes"])
        code = h(p["code_offset"])
        blocks.append({
            "name": "page_%02x" % h(pid),
            "page_id": pid,
            "file_offset": "0x%06x" % foff,     # disk read position
            "length": size,                     # whole page (header+reloc+code)
            "base": "0x%06x" % foff,            # load address (== reseg convention)
            "code_offset": "0x%06x" % code,     # where the code starts inside the block
            "confidence": p.get("confidence", ""),
        })

    manifest = {
        "_doc": ("Per-PAGE overlay memory blocks for Ghidra Tier 2 (VICEROY-only overlay code). "
                 "Add each as an initialized block from VICEROY.EXE [file_offset, +length) at "
                 "`base`. Function bodies + literal operands decompile; cross-page far-calls "
                 "(type-A, runtime-paged) may stay unresolved. The report painters do NOT need "
                 "this — they are resident in COLONIZE.EXE (Tier 1, plain import)."),
        "exe": "raw/COLONIZE/VICEROY.EXE",
        "source": "code/VICEROY/overlay_pages.json",
        "block_count": len(blocks),
        "total_bytes": sum(b["length"] for b in blocks),
        "blocks": blocks,
    }
    with open(OUT, "w") as f:
        json.dump(manifest, f, indent=1)

    print("wrote %s" % os.path.relpath(OUT, ROOT))
    print("  %d page blocks, %d KB total" % (len(blocks), manifest["total_bytes"] // 1024))
    for b in blocks:
        if b["page_id"] in ("0x05", "0x06"):
            print("  %s: load @ %s len 0x%x (code @ %s) — report-painter pages"
                  % (b["name"], b["base"], b["length"], b["code_offset"]))
    return 0


if __name__ == "__main__":
    sys.exit(main())
