#!/usr/bin/env python3
"""
find_missed_funcs.py — Find function entries the prologue scanner
in `disasm_mz.py` missed.

Strategy: scan the orphan / un-claimed bytes for patterns that look
like function entries beyond the standard `55 8B EC` / `C8 ...`:

- `83 EC NN`               sub sp, imm8 (direct frame allocation)
- `81 EC NN NN`            sub sp, imm16 (large frame)
- `56`/`57`/`53` then any of the above (push reg + sub sp)
- After RET/RETF + optional 0x90 NOP padding
"""
from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def find_in_orphan(exe_bytes: bytes, range_start: int, range_end: int,
                   detected_offs: set[int]) -> list[int]:
    """Scan the byte region for additional function entries.

    Heuristic:
      * After any RET (C3) or RETF (CB) followed by optional 0x90 NOP padding,
        the next byte is potentially a function entry.
      * Validate the candidate by checking it's a recognized prologue-like start:
          - 55 (PUSH BP)
          - 56/57/53 + 8B EC (push reg + mov bp, sp eventually)
          - 83 EC nn (sub sp, small imm)
          - 81 EC nn nn (sub sp, larger imm)
    """
    candidates: list[int] = []
    i = range_start
    n = min(range_end, len(exe_bytes))
    last_was_ret = True  # treat range start as if just after a RET
    while i < n - 4:
        b = exe_bytes[i]
        # Skip NOP padding after RET
        if last_was_ret and b == 0x90:
            i += 1
            continue
        if last_was_ret:
            # Check if this position could be a function entry
            ok = False
            if b == 0x55:  # PUSH BP
                # Check 55 8B EC, 55 89 E5, or 55 followed by SUB SP
                if exe_bytes[i+1:i+3] == b"\x8B\xEC":
                    ok = True
                elif exe_bytes[i+1:i+3] == b"\x89\xE5":
                    ok = True
                elif exe_bytes[i+1] == 0x83 and exe_bytes[i+2] == 0xEC:
                    ok = True
            elif b == 0xC8:  # ENTER
                fs = exe_bytes[i+1] | (exe_bytes[i+2] << 8)
                nl = exe_bytes[i+3]
                if fs < 0x1000 and nl < 8:
                    ok = True
            elif b in (0x56, 0x57, 0x53):  # push si/di/bx
                # Check next byte is another push or sub sp
                nb = exe_bytes[i+1]
                if nb in (0x55, 0x56, 0x57, 0x53, 0x83):
                    if nb == 0x83 and exe_bytes[i+2] == 0xEC:
                        ok = True
                    elif nb in (0x55, 0x56, 0x57, 0x53):
                        ok = True
            elif b == 0x83 and exe_bytes[i+1] == 0xEC:  # sub sp, imm8
                ok = True
            elif b == 0x81 and exe_bytes[i+1] == 0xEC:  # sub sp, imm16
                ok = True

            if ok and i not in detected_offs:
                candidates.append(i)

        # Track if this byte starts a RET / RETF
        if b in (0xC3, 0xCB):
            last_was_ret = True
        elif b == 0xC2 or b == 0xCA:  # RET imm16
            last_was_ret = True
            i += 3
            continue
        else:
            last_was_ret = False
        i += 1

    return candidates


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--exe", default="VICEROY")
    args = ap.parse_args()
    exe_path = ROOT / "raw" / "COLONIZE" / f"{args.exe}.EXE"
    func_path = ROOT / "code" / args.exe / "functions.json"
    exe = exe_path.read_bytes()
    funcs = json.loads(func_path.read_text())["functions"]

    detected = set(int(f["file_offset"], 16) for f in funcs)
    func_ranges: list[tuple[int, int]] = []
    for f in funcs:
        s = int(f["file_offset"], 16)
        e = s + f["size"]
        func_ranges.append((s, e))
    func_ranges.sort()

    # Find gaps between detected functions in the overlay
    overlay_start = 0x20665 if args.exe == "VICEROY" else None
    if overlay_start is None:
        # Use the EXE's image_bytes as overlay start
        import struct
        e_pages = struct.unpack_from("<H", exe, 4)[0]
        e_last_page = struct.unpack_from("<H", exe, 2)[0]
        image_bytes = e_pages * 512 - (512 - e_last_page if e_last_page else 0)
        overlay_start = image_bytes

    # Scan all gaps
    gap_candidates: list[int] = []
    prev_end = 0x2400  # start of CS (load image data after MZ header for VICEROY)
    for s, e in func_ranges:
        if s > prev_end:
            # Gap: scan for function entries
            gap_candidates.extend(find_in_orphan(exe, prev_end, s, detected))
        prev_end = max(prev_end, e)
    # Final gap
    if prev_end < len(exe):
        gap_candidates.extend(find_in_orphan(exe, prev_end, len(exe), detected))

    print(f"[find_missed_funcs] {args.exe}:")
    print(f"  Total detected: {len(detected)}")
    print(f"  New candidate function entries: {len(gap_candidates)}")
    print(f"  Sample first 20: {[f'0x{c:06X}' for c in gap_candidates[:20]]}")

    out = ROOT / "viceroy_source" / f"missed_funcs_{args.exe}.json"
    out.write_text(json.dumps({
        "exe": args.exe,
        "method": "gap-scan after RET for prologue-like entries",
        "candidates": [f"0x{c:06X}" for c in gap_candidates],
    }, indent=2))
    print(f"  Wrote {out}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
