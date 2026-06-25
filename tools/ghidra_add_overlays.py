# Ghidra Jython script — add VICEROY.EXE overlay PAGE blocks (Tier 2 only).
# @category Colopy
# @menupath Tools.Colopy.Add Overlay Blocks
#
# TIER 2 ONLY. For the report screens you do NOT need this: those painters are RESIDENT
# in COLONIZE.EXE and decompile from a plain import (docs/GHIDRA_PHASE2_RUNBOOK.md Tier 1).
# Use this only for code that lives ONLY in VICEROY.EXE's overlay pages.
#
# RUN INSIDE GHIDRA (Script Manager), not with system python — it uses the Ghidra API.
# Prereq: VICEROY.EXE already imported (Phase-1 load image) and open as currentProgram.
#
# It reads code/VICEROY/ghidra_overlay_blocks.json (produced by
# tools/ghidra_prep_overlays.py) — now ONE contiguous block per RTLink overlay page (31
# blocks at real per-page bases, e.g. page 0x06 @ 0x3B900), not 209 flat-offset blocks —
# and adds each at its base, then disassembles. Function BODIES (incl. literal operands)
# decompile; cross-page far-calls (type-A, runtime-paged) may stay unresolved — expected.
#
# UNTESTED on your Ghidra build — VALIDATE on the first block (use limit=1) and confirm a
# known overlay function decompiles before doing the rest. 16-bit real-mode addressing of
# these bases is the unverified part; if a block throws on getAddress/createBlock, that's
# the thing to report back. Manual fallback: Window -> Memory Map -> + (Add Block),
# Initialized, File Bytes = VICEROY.EXE @ the block's file_offset.

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
