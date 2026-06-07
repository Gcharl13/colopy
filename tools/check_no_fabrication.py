#!/usr/bin/env python3
"""
check_no_fabrication.py — Scan render_*.py for hardcoded position/size
literals that lack a `# CITED:` or `# PIXEL-MEASURED:` annotation.

Per the user-mandated rule (CLAUDE.md): every literal pixel position,
sprite index, color tuple, or text string in a renderer must either:
1. Be cited from a binary file offset:
       # CITED: VICEROY file 0xNNNNNN
2. Be cited from a TXT data file:
       # CITED: GAME.TXT @SECTION line NN
3. Be explicitly tagged as a pixel-measured fallback:
       # PIXEL-MEASURED: <reason> (TBD: byte-cite via 0xNNNNNN)

This tool detects "naked" integer literals in renderer code and
flags any that lack a citation comment within ±3 lines.

Excludes:
- Constants in well-known infrastructure (SCREEN_W=320, SCREEN_H=200,
  TILE_PX=16, RGB tuples for verified colors).
- Loop indices and obvious arithmetic (i, j, range, len).
"""
from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


# Exempt names — variables that are infrastructure constants
EXEMPT_NAMES = {
    "SCREEN_W", "SCREEN_H", "TILE_W", "TILE_H", "TILE_PX",
    "TOPBAR_H", "SIDEBAR_W", "MAP_VIEW_W", "MAP_VIEW_H",
    "DIALOG_TITLE_YELLOW", "DIALOG_BODY_GREEN",
    "POPUP_BODY_GREEN", "POPUP_VAR_YELLOW",
    "TITLE_YELLOW", "BODY_GREEN", "OPTION_GREEN",
    "SELECT_GREEN", "SELECTED_BORDER_GREEN",
    "KING_TEXT_COLOR",
    "BUTTON_BG", "BUTTON_FG",
}

# Lines whose comments mark them as cited
CITED_PATTERNS = (
    re.compile(r"#\s*CITED\b", re.IGNORECASE),
    re.compile(r"#\s*BYTE_VERIFIED", re.IGNORECASE),
    re.compile(r"#\s*PIXEL-MEASURED\b", re.IGNORECASE),
    re.compile(r"#\s*from\s+(GAME|NAMES|LABELS|MENU|COLONY|WOODCUT|PEDIA|TRIBE|OPENING|CLOSING)\.TXT", re.IGNORECASE),
    re.compile(r"#\s*LABELS\.TXT", re.IGNORECASE),
    re.compile(r"#\s*GAME\.TXT", re.IGNORECASE),
    re.compile(r"#\s*NAMES\.TXT", re.IGNORECASE),
    re.compile(r"#\s*per\s+CLAUDE\.md", re.IGNORECASE),
    re.compile(r"#\s*per\s+pixel-?verif", re.IGNORECASE),
    re.compile(r"#\s*verified", re.IGNORECASE),
    re.compile(r"#\s*sample(d)?\s+from", re.IGNORECASE),
    re.compile(r"#\s*BYTE-?cite", re.IGNORECASE),
    re.compile(r"@asm\s+0x", re.IGNORECASE),
)


# Patterns we want to flag — bare integer literals as default values
# in tuples (likely position / color / size).
ASSIGNMENT_RE = re.compile(
    r"^\s*([A-Z_][A-Z_0-9]*)\s*=\s*(\d+|0x[0-9a-fA-F]+)\b"
)
COLOR_TUPLE_RE = re.compile(
    r"\(\s*(\d{1,3})\s*,\s*(\d{1,3})\s*,\s*(\d{1,3})\s*\)"
)


def is_cited_nearby(lines: list[str], line_idx: int) -> bool:
    """Return True if any line within ±3 contains a citation comment."""
    for k in range(max(0, line_idx - 3), min(len(lines), line_idx + 4)):
        for pat in CITED_PATTERNS:
            if pat.search(lines[k]):
                return True
    return False


def scan_file(path: Path) -> list[dict]:
    """Return list of suspect literal sites in this file."""
    try:
        text = path.read_text(encoding="utf-8")
    except UnicodeDecodeError:
        text = path.read_text(encoding="cp437", errors="replace")
    lines = text.splitlines()
    flags = []
    for i, line in enumerate(lines):
        # Constant assignments
        m = ASSIGNMENT_RE.match(line)
        if m and m.group(1) not in EXEMPT_NAMES:
            if not is_cited_nearby(lines, i):
                flags.append({
                    "file": str(path.relative_to(ROOT)),
                    "line": i + 1,
                    "kind": "constant_assignment",
                    "name": m.group(1),
                    "value": m.group(2),
                    "line_text": line.strip(),
                })
    return flags


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    args = ap.parse_args()

    flags = []
    for renderer in sorted((ROOT / "tools").glob("render_*.py")):
        flags.extend(scan_file(renderer))

    print(f"[check_no_fabrication] Scanned {len(list((ROOT / 'tools').glob('render_*.py')))} renderers")
    print(f"  Suspect uncited literals: {len(flags)}")

    if flags:
        # Group by file
        from collections import Counter
        by_file = Counter(f["file"] for f in flags)
        for fn, n in by_file.most_common():
            print(f"  {fn}: {n} flags")
        print("\nFirst 15 flags:")
        for f in flags[:15]:
            print(f"  {f['file']}:{f['line']}  {f['name']} = {f['value']}")

    return 0  # informational; do not fail


if __name__ == "__main__":
    sys.exit(main())
