#!/usr/bin/env python3
"""ghidra_prep_overlays.py — emit the overlay memory-block manifest for Ghidra Phase 2.

The committed Ghidra export covers only the load image (file 0x2400..0x20665); every
overlay function decompiles to `halt_baddata()` because the overlay code regions were
never added as memory blocks. The overlay code IS present in VICEROY.EXE (and raw-
disassembled in code/VICEROY/disasm/orphans_overlay.asm) — it just isn't loaded into
Ghidra.

This script reads code/VICEROY/overlay_segments.json (`detected_segments`, the overlay
code regions found by the project's segmenter) and writes a flat manifest of memory
blocks for the Ghidra Jython helper (tools/ghidra_add_overlays.py) to add.

Block placement: each overlay region is mapped at a LINEAR base = its file offset. That
is enough for Ghidra to disassemble + decompile each function BODY — including the
literal operands we care about (e.g. `push 0x46; push 7; lcall draw_text` = a field at
x=0x46,y=7). Cross-overlay FAR calls won't auto-resolve (type-A targets are runtime-
paged, jmpf_seg=0x0000 placeholder per thunks_resolved.json), but intra-function logic
and constants decompile correctly — which is what UI-position / value decode needs.

Output: code/VICEROY/ghidra_overlay_blocks.json
Run:    python3 tools/ghidra_prep_overlays.py
"""
import json
import os
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SEG = os.path.join(ROOT, "code/VICEROY/overlay_segments.json")
OUT = os.path.join(ROOT, "code/VICEROY/ghidra_overlay_blocks.json")
IMAGE_END = 0x20665   # load-image already covered by the Phase-1 Ghidra import


def h(x):
    return int(x, 16) if isinstance(x, str) else int(x)


def main():
    with open(SEG) as f:
        data = json.load(f)
    segs = data["detected_segments"]

    blocks = []
    for s in segs:
        first = h(s["first_offset"])
        last = h(s["last_offset"])
        length = last - first + 1
        if length <= 0:
            continue
        blocks.append({
            "name": "ov_%06x" % first,
            "file_offset": "0x%06x" % first,
            "length": length,
            "func_count": s.get("function_count", 0),
            "func_offsets": s.get("function_offsets", []),
            # base = file offset (flat). Ghidra script maps the block here.
            "base": "0x%06x" % first,
            "past_image": first >= IMAGE_END,
        })

    manifest = {
        "_doc": ("Overlay memory blocks for Ghidra Phase 2. Add each as an initialized "
                 "block from VICEROY.EXE bytes [file_offset, file_offset+length) at `base`. "
                 "Then Auto-Analyze + re-export C. Function bodies (incl. literal "
                 "coordinate/value operands) decompile; cross-overlay far-calls (type-A, "
                 "runtime-paged) may stay unresolved — extract per-function facts, not the "
                 "cross-overlay call graph."),
        "exe": "raw/COLONIZE/VICEROY.EXE",
        "image_end": "0x%06x" % IMAGE_END,
        "block_count": len(blocks),
        "total_bytes": sum(b["length"] for b in blocks),
        "blocks": blocks,
    }
    with open(OUT, "w") as f:
        json.dump(manifest, f, indent=1)

    past = sum(1 for b in blocks if b["past_image"])
    print("wrote %s" % os.path.relpath(OUT, ROOT))
    print("  %d overlay blocks, %d KB total (%d past the load-image boundary)"
          % (len(blocks), manifest["total_bytes"] // 1024, past))
    return 0


if __name__ == "__main__":
    sys.exit(main())
