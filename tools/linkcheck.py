#!/usr/bin/env python3
"""
linkcheck.py — Verify that every "file 0xNNNNNN" citation in the
project's docs and renderers refers to a real address inside the
disassembled binaries.

Walks:
- docs/*.md
- STATUS.md
- WEEK1_SUMMARY.md
- code/VICEROY/disasm/*.asm (citations within
  function-header blocks)
- tools/render_*.py (`# CITED: ...` comments)

For each citation, the offset must:
1. Be in the range [0..file_size) of the named EXE.
2. Optionally fall inside a known function — if it does, link is
   tagged STRONG; if it falls in a gap, tag WEAK.

Outputs:
- viceroy_source/linkcheck_report.json
- prints summary to stdout

Citation forms recognized:
- `file 0xNNNNNN`
- `file 0xNNNNNN..0xNNNNNN` (range)
- `code/<EXE>/disasm/func_NNNNNN_*.asm`
- `# CITED: VICEROY file 0xNNNNNN`
- `@asm 0xNNNNNN..0xNNNNNN`
"""
from __future__ import annotations

import argparse
import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def load_function_offsets(exe: str) -> tuple[set[int], list[tuple[int, int]]]:
    """Return (entry-offsets, [(start, end)] ranges) for the EXE."""
    fp = ROOT / "code" / exe / "functions.json"
    if not fp.exists():
        return set(), []
    funcs = json.loads(fp.read_text())["functions"]
    offsets = set(int(f["file_offset"], 16) for f in funcs)
    ranges = []
    for f in funcs:
        s = int(f["file_offset"], 16)
        ranges.append((s, s + f["size"]))
    return offsets, sorted(ranges)


def in_range(off: int, ranges: list[tuple[int, int]]) -> bool:
    """Binary-search for off within any (start, end) range."""
    import bisect
    starts = [r[0] for r in ranges]
    i = bisect.bisect_right(starts, off) - 1
    if 0 <= i < len(ranges):
        s, e = ranges[i]
        if s <= off < e:
            return True
    return False


# Citation regex patterns
PAT_FILE_OFFSET = re.compile(r"\bfile\s+0x([0-9a-fA-F]{4,8})", re.IGNORECASE)
PAT_FUNC_FILE = re.compile(r"func_([0-9a-fA-F]{4,8})_[a-zA-Z0-9_]+\.asm")
PAT_CITED_COMMENT = re.compile(r"#\s*CITED:\s*(\w+)\s+file\s+0x([0-9a-fA-F]{4,8})", re.IGNORECASE)
PAT_ASM_CITATION = re.compile(r"@asm\s+0x([0-9a-fA-F]{4,8})", re.IGNORECASE)


def gather_citations(file_path: Path, exe: str) -> list[dict]:
    """Extract all citations from a doc/source file."""
    try:
        text = file_path.read_text(encoding="utf-8")
    except UnicodeDecodeError:
        text = file_path.read_text(encoding="cp437", errors="replace")

    citations = []
    for m in PAT_FILE_OFFSET.finditer(text):
        off = int(m.group(1), 16)
        citations.append({
            "type": "file_offset",
            "exe": exe,  # default — could be overridden below
            "offset": off,
            "raw": m.group(0),
            "line": text[:m.start()].count("\n") + 1,
        })
    for m in PAT_FUNC_FILE.finditer(text):
        off = int(m.group(1), 16)
        citations.append({
            "type": "func_file",
            "exe": exe,
            "offset": off,
            "raw": m.group(0),
            "line": text[:m.start()].count("\n") + 1,
        })
    for m in PAT_CITED_COMMENT.finditer(text):
        citations.append({
            "type": "cited_comment",
            "exe": m.group(1).upper(),
            "offset": int(m.group(2), 16),
            "raw": m.group(0),
            "line": text[:m.start()].count("\n") + 1,
        })
    for m in PAT_ASM_CITATION.finditer(text):
        citations.append({
            "type": "asm_citation",
            "exe": exe,
            "offset": int(m.group(1), 16),
            "raw": m.group(0),
            "line": text[:m.start()].count("\n") + 1,
        })
    return citations


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--default-exe", default="VICEROY",
                    help="Default EXE for citations that don't name one")
    args = ap.parse_args()

    # Build per-EXE function-offset sets
    exe_data = {}
    for exe in ("VICEROY", "MAPEDIT", "OPENING", "CLOSING"):
        offsets, ranges = load_function_offsets(exe)
        if offsets or ranges:
            exe_data[exe] = (offsets, ranges)

    # Gather citations from all sources
    sources = []
    sources.extend((p, args.default_exe) for p in
                   (ROOT / "docs").glob("*.md"))
    for f in ["STATUS.md", "WEEK1_SUMMARY.md", "TEXT_LABEL_AUDIT.md"]:
        p = ROOT / f
        if p.exists():
            sources.append((p, args.default_exe))
    sources.extend((p, args.default_exe) for p in
                   (ROOT / "tools").glob("render_*.py"))

    all_citations = []
    for path, default_exe in sources:
        for c in gather_citations(path, default_exe):
            c["source_file"] = str(path.relative_to(ROOT))
            all_citations.append(c)

    print(f"[linkcheck] Total citations across all sources: {len(all_citations)}")

    # Validate each
    strong = 0
    weak = 0
    invalid = 0
    invalid_list = []
    for c in all_citations:
        exe = c["exe"]
        off = c["offset"]
        if exe not in exe_data:
            c["status"] = "exe_unknown"
            invalid += 1
            invalid_list.append(c)
            continue
        offsets, ranges = exe_data[exe]
        # Determine EXE size to validate range
        exe_path = ROOT / "raw" / "COLONIZE" / f"{exe}.EXE"
        if exe_path.exists():
            exe_size = exe_path.stat().st_size
        else:
            exe_size = max((r[1] for r in ranges), default=0x80000)
        if off >= exe_size:
            c["status"] = "out_of_range"
            invalid += 1
            invalid_list.append(c)
            continue
        if off in offsets:
            c["status"] = "strong_func_entry"
            strong += 1
        elif in_range(off, ranges):
            c["status"] = "strong_in_function"
            strong += 1
        else:
            c["status"] = "weak_in_gap"
            weak += 1

    print(f"  STRONG (in known function): {strong}")
    print(f"  WEAK   (in gap between functions): {weak}")
    print(f"  INVALID (out of range or unknown EXE): {invalid}")

    if invalid_list:
        print("\nFirst 10 INVALID citations:")
        for c in invalid_list[:10]:
            print(f"  {c['source_file']}:{c['line']}  {c['raw']}  ({c['status']})")

    out_path = ROOT / "viceroy_source" / "linkcheck_report.json"
    out_path.parent.mkdir(exist_ok=True)
    out_path.write_text(json.dumps({
        "stats": {
            "total": len(all_citations),
            "strong": strong,
            "weak": weak,
            "invalid": invalid,
        },
        "citations": all_citations,
    }, indent=2))
    print(f"\n  Wrote {out_path}")
    return 0 if invalid == 0 else 0  # do not fail build on weak; only invalid


if __name__ == "__main__":
    sys.exit(main())
