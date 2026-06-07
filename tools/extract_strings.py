#!/usr/bin/env python3
# extract_strings.py
#
# Pull every immediate printable ASCII string out of an EXE and emit
# code/<EXE>/strings.json. Each entry records:
#   - string text
#   - file offset
#   - region ("load_image" or "overlay")
#   - length
#   - sha256 of the string bytes
#   - xrefs: offsets in the file where the string's 16-bit offset (and/or
#     full LE16 offset+segment fixup target) appears as immediate data.
#
# This is a Phase 1 *inventory* tool. It does not parse or annotate code
# semantics; it just identifies bytestreams that look like strings and
# records every place those strings' addresses appear.

from __future__ import annotations

import argparse
import hashlib
import json
import re
import struct
import sys
from pathlib import Path

import disasm_mz  # parse_mz, MzHeader

PRINTABLE_RE = re.compile(rb"[\x20-\x7E]{4,}")


def find_strings(region: bytes, region_label: str, region_file_offset: int) -> list[dict]:
    """Find printable ASCII runs of length >= 4. Allow trailing 0x00 or 0x0A
    as terminator (still counted as "the string"). Strings include any
    whitespace in the printable range."""
    out: list[dict] = []
    for m in PRINTABLE_RE.finditer(region):
        start = m.start()
        end = m.end()
        # If the byte just past the run is a NUL, treat the string as
        # explicitly NUL-terminated (record terminator's position).
        terminated = end < len(region) and region[end] == 0
        text = region[start:end].decode("ascii")
        out.append(
            {
                "text": text,
                "file_offset": region_file_offset + start,
                "length": end - start,
                "nul_terminated": terminated,
                "region": region_label,
                "sha256": hashlib.sha256(region[start:end]).hexdigest()[:16],
            }
        )
    return out


def find_xrefs(region: bytes, region_file_offset: int, target_file_offset: int) -> list[int]:
    """Find every 16-bit aligned-or-not occurrence of the target file
    offset's *low 16 bits* inside the region. Returns file offsets where
    the immediate appears.

    Phase 1 heuristic: we look for the target's 16-bit offset (LE) appearing
    as bytes anywhere in the region. This will produce some false positives
    from ordinary 16-bit constants, but it captures every real reference. A
    Phase 2 pass driven by the disassembly will narrow these to instructions
    whose operand actually consumes the immediate.
    """
    needle = struct.pack("<H", target_file_offset & 0xFFFF)
    out: list[int] = []
    start = 0
    while True:
        idx = region.find(needle, start)
        if idx < 0:
            break
        out.append(region_file_offset + idx)
        start = idx + 1
    return out


def process_exe(exe_path: Path, out_dir: Path) -> dict:
    file_bytes = exe_path.read_bytes()
    hdr = disasm_mz.parse_mz(file_bytes)
    img = hdr.image_bytes
    hdr_sz = hdr.header_bytes

    load_image = file_bytes[hdr_sz:img]
    overlay = file_bytes[img:]

    strings: list[dict] = []
    strings.extend(find_strings(load_image, "load_image", hdr_sz))
    strings.extend(find_strings(overlay, "overlay", img))

    # For each string, search for xrefs in BOTH regions. This catches
    # load-image code that references overlay strings and vice versa.
    for s in strings:
        xrefs_li = find_xrefs(load_image, hdr_sz, s["file_offset"])
        xrefs_ov = find_xrefs(overlay, img, s["file_offset"])
        # Exclude the string's own bytes from xrefs (the LE16 of the
        # offset can match itself if the string is at a low file offset).
        own = s["file_offset"]
        s["xrefs"] = sorted(
            x for x in (xrefs_li + xrefs_ov)
            if not (own <= x < own + s["length"])
        )

    out_dir.mkdir(parents=True, exist_ok=True)
    out_path = out_dir / "strings.json"
    out_path.write_text(
        json.dumps(
            {
                "exe": exe_path.name,
                "count": len(strings),
                "strings": strings,
            },
            indent=2,
        ),
        encoding="utf-8",
    )
    return {"exe": exe_path.name, "count": len(strings)}


def main() -> int:
    ap = argparse.ArgumentParser(description="Extract immediate strings from MZ EXEs (Phase 1).")
    ap.add_argument("--root", default=str(Path(__file__).resolve().parent.parent))
    ap.add_argument("--exes", nargs="*", default=None)
    args = ap.parse_args()

    root = Path(args.root)
    raw = root / "raw" / "COLONIZE"
    code = root / "code"

    default_exes = [
        "VICEROY.EXE",
        "MAPEDIT.EXE",
        "OPENING.EXE",
        "CLOSING.EXE",
    ]
    targets = args.exes or default_exes

    for name in targets:
        exe_path = raw / name
        if not exe_path.is_file():
            print(f"WARN: missing {exe_path}", file=sys.stderr)
            continue
        out_dir = code / Path(name).stem
        s = process_exe(exe_path, out_dir)
        print(f"[strings] {s['exe']:14s} -> {s['count']} strings")

    return 0


if __name__ == "__main__":
    sys.exit(main())
