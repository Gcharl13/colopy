# Ghidra Jython script — add VICEROY.EXE overlay regions as memory blocks (Phase 2).
# @category Colopy
# @menupath Tools.Colopy.Add Overlay Blocks
#
# RUN INSIDE GHIDRA (Script Manager), not with system python — it uses the Ghidra API.
# Prereq: VICEROY.EXE already imported (Phase-1 load image) and open as currentProgram.
#
# It reads code/VICEROY/ghidra_overlay_blocks.json (produced by
# tools/ghidra_prep_overlays.py) and adds each overlay code region as an initialized
# memory block at a linear base = its file offset, then disassembles it. Function
# BODIES (incl. literal coordinate/value operands) then decompile; cross-overlay
# far-calls (type-A, runtime-paged) may stay unresolved — that's expected.
#
# UNTESTED on your Ghidra build — VALIDATE on the first block before trusting the rest:
# run with `limit=1` (prompt) first, confirm a known overlay function decompiles, then
# re-run with the full set. Manual fallback: Window -> Memory Map -> + (Add Block),
# Block Type = Initialized (from file bytes), Source = VICEROY.EXE @ the file offset.

import json
import jarray
from java.io import ByteArrayInputStream

def main():
    exe = askFile("Select VICEROY.EXE", "Open")
    manifest = askFile("Select ghidra_overlay_blocks.json", "Open")
    limit = askInt("How many blocks to add? (use 1 to validate first; 0 = all)", "count")

    raw = open(exe.getAbsolutePath(), "rb").read()
    blocks = json.load(open(manifest.getAbsolutePath()))["blocks"]
    if limit and limit > 0:
        blocks = blocks[:limit]

    mem = currentProgram.getMemory()
    space = currentProgram.getAddressFactory().getDefaultAddressSpace()
    added = 0
    skipped = 0
    for b in blocks:
        foff = int(b["file_offset"], 16)
        length = int(b["length"])
        base = int(b["base"], 16)
        data = raw[foff:foff + length]
        if len(data) != length:
            skipped += 1
            continue
        addr = space.getAddress(base)
        try:
            jbytes = jarray.array([ (x - 256 if x > 127 else x) for x in bytearray(data) ], "b")
            mem.createInitializedBlock(b["name"], addr, ByteArrayInputStream(jbytes),
                                       length, monitor, False)
            added += 1
        except Exception as e:
            # block already exists / overlaps a Phase-1 segment — skip, don't abort
            skipped += 1
            continue
        try:
            disassemble(addr)
        except:
            pass

    print("[colopy] overlay blocks added: %d, skipped: %d" % (added, skipped))
    print("[colopy] now run Analysis -> Auto Analyze, then File -> Export Program -> C/C++")

main()
