#!/usr/bin/env python3
# xref_bucket.py
#
# For a given EXE and a target string (or string file-offset), find every
# xref to that string and bucket them by the containing function. The
# resulting report tells us "function at offset 0xNNNN references this string
# X times" — a fast way to identify which functions handle a given concept.
#
# Without arguments, it reports the bucketed xrefs for EVERY string whose
# xref count exceeds a threshold (default 5), giving a global "hot reference"
# map.

from __future__ import annotations

import argparse
import json
from collections import Counter, defaultdict
from pathlib import Path


def load_funcs(exe_dir: Path) -> list[dict]:
    p = exe_dir / "functions.json"
    return json.loads(p.read_text(encoding="utf-8"))["functions"]


def load_strings(exe_dir: Path) -> list[dict]:
    p = exe_dir / "strings.json"
    return json.loads(p.read_text(encoding="utf-8"))["strings"]


def function_for_offset(funcs: list[dict], file_offset: int) -> dict | None:
    """Return the function record whose [start, start+size) contains file_offset."""
    for f in funcs:
        start = int(f["file_offset"], 16)
        if start <= file_offset < start + f["size"]:
            return f
    return None


def bucket_xrefs(funcs: list[dict], xrefs: list[int]) -> Counter:
    """Return Counter keyed by containing-function offset (hex string)."""
    c: Counter = Counter()
    for x in xrefs:
        f = function_for_offset(funcs, x)
        key = f["file_offset"] if f else "(orphan)"
        c[key] += 1
    return c


def report_one_string(s: dict, funcs: list[dict]) -> str:
    out = []
    out.append(f"## `{s['text']}`")
    out.append("")
    out.append(
        f"- String at file 0x{s['file_offset']:06X} ({s['region']}, "
        f"{'NUL-terminated' if s['nul_terminated'] else 'no terminator'}, "
        f"{s['length']} bytes)"
    )
    out.append(f"- Total xrefs: {len(s['xrefs'])}")
    if not s["xrefs"]:
        out.append("")
        return "\n".join(out)
    bucket = bucket_xrefs(funcs, s["xrefs"])
    out.append("")
    out.append("| Function | XRefs from this fn | Function name | Status |")
    out.append("|----------|-------------------:|---------------|--------|")
    for off, n in bucket.most_common():
        if off == "(orphan)":
            out.append(f"| (orphan) | {n} | — | unaffiliated |")
            continue
        f = next((x for x in funcs if x["file_offset"] == off), None)
        if f:
            out.append(
                f"| {off} | {n} | `{f['name']}` | {f.get('status', '?')} |"
            )
        else:
            out.append(f"| {off} | {n} | ? | ? |")
    out.append("")
    return "\n".join(out)


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--root", default=str(Path(__file__).resolve().parent.parent))
    ap.add_argument("--exe", default="VICEROY")
    ap.add_argument("--text", help="Filter by exact string text (case-sensitive)")
    ap.add_argument(
        "--min-xrefs",
        type=int,
        default=5,
        help="Minimum total xref count to include (default 5)",
    )
    ap.add_argument("--out", help="Write report to file (default stdout)")
    args = ap.parse_args()

    root = Path(args.root)
    exe_dir = root / "code" / args.exe

    funcs = load_funcs(exe_dir)
    strings = load_strings(exe_dir)

    selected: list[dict]
    if args.text:
        selected = [s for s in strings if s["text"] == args.text]
    else:
        selected = [s for s in strings if len(s["xrefs"]) >= args.min_xrefs]

    selected.sort(key=lambda s: -len(s["xrefs"]))

    out = [f"# {args.exe}.EXE — XRefs bucketed by function", ""]
    if args.text:
        out.append(f"_Filter: text == `{args.text}`_")
    else:
        out.append(f"_Threshold: strings with >= {args.min_xrefs} xrefs_")
    out.append("")
    out.append(f"_{len(selected)} string(s) selected_")
    out.append("")

    for s in selected:
        out.append(report_one_string(s, funcs))

    text = "\n".join(out)
    if args.out:
        Path(args.out).write_text(text, encoding="utf-8")
        print(f"wrote {args.out}")
    else:
        print(text)
    return 0


if __name__ == "__main__":
    import sys
    sys.exit(main())
