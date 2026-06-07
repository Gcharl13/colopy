#!/usr/bin/env python3
"""
auto_name_funcs.py — Auto-rename func_NNNNNN_unknown.asm files to
include a semantic-name suffix derived from their string xrefs.

Heuristic:
- For each function, find every ; STRING: "..." comment in its body.
- The most-distinctive string becomes the function's "tag" (suffix).
- Rename the .asm file from `func_NNNNNN_unknown.asm` to
  `func_NNNNNN_<tag>.asm`.

This is a sieve, not a perfect taxonomy: the resulting names are
hints, not authoritative semantics. They're useful for grep and
visual scanning of disasm.

Common-string filter: ignore strings that are too generic (numbers,
single chars, filenames common to many functions).
"""
from __future__ import annotations

import argparse
import json
import re
import shutil
import sys
from collections import Counter
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

STRING_COMMENT_RE = re.compile(r';\s*STRING:\s*"([^"]+)"')

# Strings we don't want to use as tags (too generic / frequent)
NOISE_STRINGS = {
    ".", ",", "  ", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
    "OK", "Cancel", "Yes", "No", "%s", "%d", "%c", "\\n", "%",
    "GAME", "TXT", "DAT", "BIN", "MP", "SS", "PIK", "PAL", "FF",
}


def slugify(s: str, max_len: int = 24) -> str:
    """Convert a string to an asm-file-safe identifier slug."""
    s = re.sub(r"[^a-zA-Z0-9]+", "_", s).strip("_")
    if not s:
        return "tagged"
    if s[0].isdigit():
        s = "x_" + s
    return s[:max_len].lower()


def collect_string_tags(asm_path: Path) -> list[str]:
    """Return list of distinct strings referenced by this function."""
    try:
        text = asm_path.read_text(encoding="utf-8")
    except UnicodeDecodeError:
        text = asm_path.read_text(encoding="cp437", errors="replace")
    tags = []
    for m in STRING_COMMENT_RE.finditer(text):
        s = m.group(1).strip()
        if s in NOISE_STRINGS:
            continue
        if len(s) < 3 or len(s) > 30:
            continue
        if s not in tags:
            tags.append(s)
    return tags


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--exe", default="VICEROY")
    ap.add_argument("--dry-run", action="store_true",
                    help="Print proposed renames without applying")
    args = ap.parse_args()

    disasm = ROOT / "code" / args.exe / "disasm"
    if not disasm.is_dir():
        print(f"ERROR: no disasm dir at {disasm}", file=sys.stderr)
        return 1

    # Build a string→count map across all functions to identify
    # truly distinctive strings (low count = good tag)
    all_strings: Counter = Counter()
    func_strings: dict[Path, list[str]] = {}
    for asm in disasm.glob("func_*_unknown.asm"):
        tags = collect_string_tags(asm)
        func_strings[asm] = tags
        all_strings.update(tags)

    annotated_count = 0
    skip_count = 0
    for asm, tags in func_strings.items():
        if not tags:
            skip_count += 1
            continue
        # Use TOP 3 tags to embed a richer semantic hint
        sorted_tags = sorted(tags, key=lambda t: all_strings[t])
        best_tags = [t for t in sorted_tags[:3]
                     if all_strings[t] <= 10]
        if not best_tags:
            skip_count += 1
            continue
        # Read existing header
        try:
            text = asm.read_text(encoding="utf-8")
        except UnicodeDecodeError:
            text = asm.read_text(encoding="cp437", errors="replace")
        # If already has "; Tagged:" line, skip
        if "; Tagged:" in text[:1000]:
            skip_count += 1
            continue
        # Insert the tag line in the header block before the
        # "; ============" line that closes the header.
        tag_line = "; Tagged: " + ", ".join(f'"{t}"' for t in best_tags) + "  (auto-named via string xrefs)"
        # Find the closing ; ===== of the header block (second occurrence)
        # Header looks like:
        #   ; ====
        #   ; func_NNNNNN_unknown
        #   ; ...
        #   ; ====
        # Insert tag_line just before the second ; ====.
        lines = text.splitlines()
        eq_count = 0
        new_lines = []
        inserted = False
        for line in lines:
            if line.startswith("; =====") or line.startswith("; -----"):
                eq_count += 1
                if eq_count == 2 and not inserted:
                    new_lines.append(tag_line)
                    inserted = True
            new_lines.append(line)
        if not inserted:
            # Fallback: prepend at start
            new_lines.insert(0, tag_line)
        if args.dry_run:
            print(f"  tag: {asm.name} -> {tag_line}")
        else:
            asm.write_text("\n".join(new_lines) + "\n", encoding="utf-8")
        annotated_count += 1

    print(f"\n[auto_name_funcs] {args.exe}:")
    print(f"  Tagged:  {annotated_count}")
    print(f"  Skipped: {skip_count}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
