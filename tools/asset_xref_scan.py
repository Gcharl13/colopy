#!/usr/bin/env python3
# asset_xref_scan.py
#
# For each original COLONIZE/ filename (per MANIFEST.json), scan every
# disassembled EXE's strings.json for a matching string. Where matches
# exist, emit a provisional asset_xrefs.md entry per EXE.
#
# Also emit a per-EXE rtlink_segments.md listing any *.obj strings (RTLink
# overlay segment names — used to be linker object files) found.
#
# This is a Phase 1 INVENTORY tool. Loader functions are NOT identified
# yet — that work happens in Phase 2 when the disassembly is annotated.

from __future__ import annotations

import argparse
import json
import re
from pathlib import Path
from typing import Iterable

OBJ_RE = re.compile(r"^[A-Za-z0-9_]+\.obj$")


def load_manifest(root: Path) -> dict:
    p = root / "MANIFEST.json"
    return json.loads(p.read_text(encoding="utf-8"))


def load_strings(exe_dir: Path) -> dict:
    p = exe_dir / "strings.json"
    if not p.exists():
        return {"strings": []}
    return json.loads(p.read_text(encoding="utf-8"))


def write_asset_xrefs(
    exe_dir: Path,
    exe_name: str,
    manifest: list[dict],
    strings: list[dict],
) -> tuple[int, int]:
    """Returns (matched_originals_count, total_xref_count)."""
    # Build a name -> manifest-row index for fast lookup.
    name_to_row: dict[str, dict] = {r["name"].upper(): r for r in manifest if not r.get("foreign")}
    # Build a name -> [string entries] map.
    name_to_strs: dict[str, list[dict]] = {}
    for s in strings:
        upper = s["text"].upper()
        if upper in name_to_row:
            name_to_strs.setdefault(upper, []).append(s)

    matched = sorted(name_to_strs.keys())
    out_path = exe_dir / "asset_xrefs.md"

    lines: list[str] = []
    lines.append(f"# {exe_name} — Asset cross-references (Phase 1)")
    lines.append("")
    lines.append(
        "Provisional inventory of where each `COLONIZE/` filename appears as an "
        "immediate string in this executable, plus every byte offset that "
        "*looks like* a 16-bit immediate referencing it."
    )
    lines.append("")
    lines.append(
        "Phase 1 method: filename appears in `strings.json`, and the string's "
        "low-16-bit file offset appears as raw bytes anywhere else in the EXE. "
        "Phase 2 (annotation) will narrow these to the actual loader instructions "
        "and promote each entry from `Loader: TBD` to `Loader: func_<…>`."
    )
    lines.append("")
    lines.append(
        f"**{len(matched)} of {len(name_to_row)} original `COLONIZE/` files** "
        f"appear by name in this executable."
    )
    lines.append("")

    if not matched:
        lines.append(
            "_No original-COLONIZE filenames appear as immediate strings in this "
            "executable. Asset filenames are likely constructed at runtime or "
            "stored in another data file. Phase 2 will trace the loader._"
        )

    total_xrefs = 0
    for name in matched:
        rows = name_to_strs[name]
        lines.append(f"## `{name_to_row[name]['name']}`")
        lines.append("")
        lines.append(f"- Source ext: `.{name_to_row[name]['ext']}`")
        lines.append(f"- Source size: {name_to_row[name]['size']:,} bytes")
        lines.append(f"- Source SHA256: `{name_to_row[name]['sha256'][:16]}…`")
        lines.append(f"- Loader: TBD (pending Phase 2 annotation)")
        lines.append(f"- Format spec: TBD (`formats/{name_to_row[name]['ext']}.md`)")
        lines.append("")
        lines.append("String occurrences in this EXE:")
        lines.append("")
        for s in rows:
            xrefs = s.get("xrefs", [])
            total_xrefs += len(xrefs)
            xref_repr = (
                ", ".join(f"0x{x:06X}" for x in xrefs[:8])
                + (f", … (+{len(xrefs) - 8} more)" if len(xrefs) > 8 else "")
            )
            lines.append(
                f"- file 0x{s['file_offset']:06X} ({s['region']}, "
                f"{'NUL-terminated' if s['nul_terminated'] else 'unterminated'}, "
                f"{s['length']} bytes) — xrefs: {xref_repr or '(none)'}"
            )
        lines.append("")

    out_path.write_text("\n".join(lines), encoding="utf-8", newline="\n")
    return len(matched), total_xrefs


def write_rtlink_segments(exe_dir: Path, exe_name: str, strings: list[dict]) -> int:
    objs = [s for s in strings if OBJ_RE.match(s["text"])]
    if not objs:
        return 0
    out_path = exe_dir / "rtlink_segments.md"
    lines: list[str] = []
    lines.append(f"# {exe_name} — RTLink overlay segment names (Phase 1)")
    lines.append("")
    lines.append(
        "Strings ending in `.obj` found inside the executable. Under Pocket Soft "
        "RTLink Plus these are the linker object files that became overlay "
        "segments at link time. The runtime loader uses this list to demand-load "
        "each segment when its code is called. Phase 2 will tie each entry to "
        "the segment's byte range in the overlay."
    )
    lines.append("")
    lines.append(f"Total: **{len(objs)}**")
    lines.append("")
    lines.append("| File offset | Region    | XRefs | Name         |")
    lines.append("|-------------|-----------|------:|--------------|")
    for s in sorted(objs, key=lambda r: r["file_offset"]):
        lines.append(
            f"| 0x{s['file_offset']:06X} | {s['region']:9s} | {len(s['xrefs']):>5} | "
            f"`{s['text']}` |"
        )
    lines.append("")
    out_path.write_text("\n".join(lines), encoding="utf-8", newline="\n")
    return len(objs)


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--root", default=str(Path(__file__).resolve().parent.parent))
    ap.add_argument("--exes", nargs="*", default=None)
    args = ap.parse_args()

    root = Path(args.root)
    code = root / "code"

    manifest = load_manifest(root)

    default_exes = [
        "VICEROY.EXE",
        "MAPEDIT.EXE",
        "OPENING.EXE",
        "CLOSING.EXE",
    ]
    targets = args.exes or default_exes

    for name in targets:
        exe_dir = code / Path(name).stem
        if not exe_dir.is_dir():
            continue
        strings = load_strings(exe_dir).get("strings", [])
        matched, total = write_asset_xrefs(exe_dir, name, manifest, strings)
        nobj = write_rtlink_segments(exe_dir, name, strings)
        print(
            f"[xref] {name:14s} matched={matched:3d} originals  "
            f"xrefs={total:5d}  rtlink_objs={nobj}"
        )

    return 0


if __name__ == "__main__":
    import sys
    sys.exit(main())
