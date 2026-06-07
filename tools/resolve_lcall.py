#!/usr/bin/env python3
"""
resolve_lcall.py — Annotate every LCALL <seg>:<off> in VICEROY's
disassembly with the thunk it targets and the overlay function the
thunk forwards to.

KEY DECODE (Day-1 breakthrough, 2026-05-03):

    A load-image disassembly line of form
        LCALL  0xSSSS, 0xOOOO        ; (in capstone "LCALL <seg>, <off>" syntax)
    points at a thunk in the overlay-thunk table at file 0x1A5F0..0x1D5E6.
    The mapping is:
        thunk_file_offset = 0x2400 + (seg << 4) + off

    Each thunk is either Type-A (with metadata trailer) or Type-B
    (10 bytes, no trailer), and carries an LJMP <seg2>:<off2> to the
    overlay function it forwards to.

This tool consumes:
  - code/VICEROY/overlay_thunks.json (1020 thunks)
  - viceroy_source/overlay_directory.json (34 of 82
    segments resolved to file offsets)

It emits:
  - viceroy_source/lcall_resolution.json — mapping
    every (seg, off) seen in disasm to thunk + overlay-target metadata
  - Optionally: in-place .asm annotation appending
       ; THUNK -> 0xSEG2:0xOFF2 [@file 0xNNNNNN]
    to each LCALL line.

Usage:
  python resolve_lcall.py            # build mapping JSON only
  python resolve_lcall.py --annotate # also annotate .asm files in place
"""
from __future__ import annotations

import argparse
import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def build_resolver():
    """Return (lcall_resolver, file_offset_to_thunk).

    lcall_resolver(seg, off) -> dict with:
      thunk_file_offset, thunk_type, ljmp_seg, ljmp_off,
      overlay_file_offset (None if segment not yet resolved)
    """
    with open(ROOT / "code/VICEROY/overlay_thunks.json") as f:
        thunks = json.load(f)["thunks"]
    try:
        with open(ROOT / "viceroy_source/overlay_directory.json") as f:
            seg_dir = json.load(f).get("resolved_segments", {})
            # keys are "0x..." strings
            seg_dir = {int(k, 16): v for k, v in seg_dir.items()}
    except FileNotFoundError:
        seg_dir = {}

    file_to_thunk = {t["thunk_offset"]: t for t in thunks}

    def resolve(seg: int, off: int) -> dict | None:
        # The seg in disasm is image-relative; thunk file offset:
        thunk_off = 0x2400 + (seg << 4) + off
        t = file_to_thunk.get(thunk_off)
        if t is None:
            return None
        ov_seg = t["ljmp_seg"]
        ov_off = t["ljmp_off"]
        ov_dir_entry = seg_dir.get(ov_seg)
        ov_file_off = None
        if ov_dir_entry and ov_dir_entry.get("file_offset") is not None:
            ov_file_off = ov_dir_entry["file_offset"] + ov_off
        return {
            "lcall_seg": seg,
            "lcall_off": off,
            "thunk_file_offset": thunk_off,
            "thunk_type": t["type"],
            "overlay_seg": ov_seg,
            "overlay_off": ov_off,
            "overlay_file_offset": ov_file_off,
            "overlay_seg_resolved": ov_dir_entry is not None
                                    and ov_dir_entry.get("file_offset") is not None,
        }

    return resolve, file_to_thunk


def scan_disasm_for_lcalls(disasm_dir: Path):
    """Yield (asm_path, line_no, seg, off) for every LCALL in any .asm."""
    pat = re.compile(r"LCALL\s+0x([0-9a-fA-F]+),\s*0x([0-9a-fA-F]+)")
    for asm in sorted(disasm_dir.glob("*.asm")):
        try:
            text = asm.read_text(encoding="utf-8")
        except UnicodeDecodeError:
            text = asm.read_text(encoding="cp437", errors="replace")
        for ln, line in enumerate(text.splitlines(), 1):
            m = pat.search(line)
            if m:
                seg = int(m.group(1), 16)
                off = int(m.group(2), 16)
                yield asm, ln, seg, off


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--annotate", action="store_true",
                    help="Append ; THUNK -> ... comments to each LCALL line in place")
    ap.add_argument("--exe", default="VICEROY",
                    help="Which EXE's disasm tree to scan")
    args = ap.parse_args()

    resolve, file_to_thunk = build_resolver()
    disasm_dir = ROOT / f"code/{args.exe}/disasm"
    if not disasm_dir.is_dir():
        print(f"ERROR: no disasm dir at {disasm_dir}", file=sys.stderr)
        return 1

    seen = {}
    annotations_per_file: dict[Path, dict[int, str]] = {}
    total = 0
    resolved = 0
    overlay_resolved = 0
    for asm, ln, seg, off in scan_disasm_for_lcalls(disasm_dir):
        total += 1
        # Cache by (seg, off)
        key = (seg, off)
        if key in seen:
            info = seen[key]
        else:
            info = resolve(seg, off)
            seen[key] = info
        if info is not None:
            resolved += 1
            if info["overlay_seg_resolved"]:
                overlay_resolved += 1
            if args.annotate:
                comment = (f"; THUNK -> 0x{info['overlay_seg']:04X}:0x{info['overlay_off']:04X}"
                           f" (thunk @file 0x{info['thunk_file_offset']:06X}"
                           f" type {info['thunk_type']})")
                if info["overlay_file_offset"] is not None:
                    comment += f" overlay @file 0x{info['overlay_file_offset']:06X}"
                annotations_per_file.setdefault(asm, {})[ln] = comment

    # Emit JSON resolution table
    out = {
        "exe": args.exe,
        "lcall_resolution_method": "thunk_file_offset = 0x2400 + (seg<<4) + off",
        "stats": {
            "total_lcall_sites": total,
            "resolved_to_thunk": resolved,
            "overlay_target_resolved": overlay_resolved,
        },
        "by_lcall_target": {
            f"0x{seg:04X}:0x{off:04X}": info
            for (seg, off), info in seen.items()
            if info is not None
        },
    }
    out_path = ROOT / "viceroy_source" / f"lcall_resolution_{args.exe}.json"
    with open(out_path, "w") as f:
        json.dump(out, f, indent=2)
    print(f"[resolve_lcall] {args.exe}:")
    print(f"  Total LCALL sites: {total}")
    print(f"  Resolved to thunk: {resolved} ({100*resolved/total:.1f}%)" if total else "")
    print(f"  Overlay target resolved: {overlay_resolved} ({100*overlay_resolved/total:.1f}%)"
          if total else "")
    print(f"  Wrote {out_path}")

    if args.annotate:
        # Apply per-file annotations: append the comment to the LCALL line
        # if no semantic annotation already present (no "; UNKNOWN" still on
        # the line means it was already annotated; we don't overwrite that).
        for asm, ann_map in annotations_per_file.items():
            try:
                text = asm.read_text(encoding="utf-8")
            except UnicodeDecodeError:
                text = asm.read_text(encoding="cp437", errors="replace")
            lines = text.splitlines(keepends=True)
            changed = False
            for ln_idx, comment in ann_map.items():
                line = lines[ln_idx - 1].rstrip("\r\n")
                # If it ends with "; UNKNOWN", replace with our comment.
                # Otherwise, append after a space if the comment isn't there yet.
                if comment in line:
                    continue
                if line.rstrip().endswith("; UNKNOWN"):
                    line = line.rstrip()[:-len("; UNKNOWN")].rstrip() + " " + comment
                elif "THUNK ->" not in line:
                    line = line.rstrip() + "  " + comment
                lines[ln_idx - 1] = line + "\n"
                changed = True
            if changed:
                asm.write_text("".join(lines), encoding="utf-8")
        print(f"  Annotated {len(annotations_per_file)} files")

    return 0


if __name__ == "__main__":
    sys.exit(main())
