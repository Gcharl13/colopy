#!/usr/bin/env python3
# ledger_update.py
#
# Walks every code/<EXE>/disasm/*.asm file and computes per-function
# identification stats, then rebuilds code/DISASM_LEDGER.md as a single
# top-level dashboard. The .asm files are the truth; the ledger is a view.
#
# A "code line" is a line that begins with 6 hex digits followed by two
# spaces — i.e. the address column of an instruction or DB row. Comment
# lines that start with `;` and blank lines do not count.
#
# A code line is "identified" iff it has a `;` comment AFTER the operand
# column, AND that comment is NOT one of:
#   - "; UNKNOWN"
#   - "; UNKNOWN (raw)"
#   - "; UNKNOWN (orphan)"
#   - "; UNKNOWN (orphan-raw)"
#
# i.e. as long as a Phase 2 annotator wrote a real semantic comment, the
# line counts. Header `; ====` blocks and the function-summary lines are
# not code lines and don't affect counts.

from __future__ import annotations

import argparse
import json
import re
from collections import defaultdict
from datetime import datetime, timezone
from pathlib import Path

# Match a code line: starts with 6 hex digits + 2 spaces.
CODE_LINE_RE = re.compile(r"^([0-9A-F]{6})  ")

UNKNOWN_TAGS = (
    "; UNKNOWN",
    "; UNKNOWN (raw)",
    "; UNKNOWN (orphan)",
    "; UNKNOWN (orphan-raw)",
)


def line_status(line: str) -> str | None:
    """Return None if not a code line, "raw" or "ident" otherwise."""
    if not CODE_LINE_RE.match(line):
        return None
    # Extract the comment after the last `;`. Strip trailing whitespace first.
    s = line.rstrip()
    # The comment we care about is the FINAL `;`-introduced suffix.
    semi = s.rfind(";")
    if semi < 0:
        return "ident"  # no comment — pre-annotated something? treat as ident
    tail = s[semi:].strip()
    # Strip trailing whitespace and compare against the UNKNOWN sentinels.
    for t in UNKNOWN_TAGS:
        if tail == t:
            return "raw"
    return "ident"


def analyze_asm_file(path: Path) -> tuple[int, int]:
    """Returns (total_code_lines, identified_lines)."""
    total = 0
    ident = 0
    with path.open("r", encoding="utf-8") as f:
        for line in f:
            st = line_status(line)
            if st is None:
                continue
            total += 1
            if st == "ident":
                ident += 1
    return total, ident


def analyze_function_file(path: Path) -> dict:
    total, ident = analyze_asm_file(path)
    # Status: DONE if total>0 and ident==total, RAW if ident==0, IN-PROGRESS otherwise.
    if total == 0:
        status = "EMPTY"
    elif ident == total:
        status = "DONE"
    elif ident == 0:
        status = "RAW"
    else:
        status = "IN-PROGRESS"
    # Pull header purpose if present.
    purpose = ""
    with path.open("r", encoding="utf-8") as f:
        for line in f:
            if line.startswith("; Purpose"):
                m = re.match(r";\s*Purpose\s*:\s*(.*)$", line.strip())
                if m:
                    purpose = m.group(1).strip()
                break
    # Recover function offset from filename.
    m = re.search(r"func_([0-9A-F]{6})_", path.name)
    offset = int(m.group(1), 16) if m else None
    name = path.stem.replace("func_", "").split("_", 1)
    if len(name) == 2:
        sym = name[1]
    else:
        sym = "?"
    return {
        "asm_file": str(path.name),
        "offset": offset,
        "name": sym,
        "lines": total,
        "identified": ident,
        "status": status,
        "purpose": purpose,
    }


def build_per_exe(exe_dir: Path) -> dict:
    disasm_dir = exe_dir / "disasm"
    if not disasm_dir.is_dir():
        return None  # type: ignore[return-value]

    funcs: list[dict] = []
    orphan_total = 0
    orphan_ident = 0

    for asm in sorted(disasm_dir.iterdir()):
        if not asm.is_file() or asm.suffix != ".asm":
            continue
        if asm.name.startswith("orphans"):
            t, i = analyze_asm_file(asm)
            orphan_total += t
            orphan_ident += i
            continue
        funcs.append(analyze_function_file(asm))

    func_total = sum(f["lines"] for f in funcs)
    func_ident = sum(f["identified"] for f in funcs)
    grand_total = func_total + orphan_total
    grand_ident = func_ident + orphan_ident
    pct = (grand_ident * 100.0 / grand_total) if grand_total else 0.0

    summary = {
        "exe": exe_dir.name,
        "functions_total": len(funcs),
        "function_lines_total": func_total,
        "function_lines_identified": func_ident,
        "orphan_lines_total": orphan_total,
        "orphan_lines_identified": orphan_ident,
        "grand_total": grand_total,
        "grand_identified": grand_ident,
        "pct_identified": pct,
    }
    by_status = defaultdict(int)
    for f in funcs:
        by_status[f["status"]] += 1
    summary["by_status"] = dict(by_status)
    return {"summary": summary, "functions": funcs}


def write_ledger(root: Path, per_exe: dict[str, dict]) -> None:
    out = root / "code" / "DISASM_LEDGER.md"
    now = datetime.now(timezone.utc).strftime("%Y-%m-%d %H:%M UTC")

    lines: list[str] = []
    lines.append("# Disassembly Ledger")
    lines.append("")
    lines.append(
        "Per-line identification status of every disassembled DOS executable. "
        "**Generated** by `tools/ledger_update.py` from the `.asm` files in "
        "`code/<EXE>/disasm/`. Do not hand-edit; rerun the tool after editing "
        "any `.asm` file."
    )
    lines.append("")
    lines.append(f"_Last updated: {now}_")
    lines.append("")
    lines.append("## Status legend")
    lines.append("")
    lines.append("- **RAW** — every code line is `; UNKNOWN`. Capstone output, no annotation.")
    lines.append("- **IN-PROGRESS** — some lines have semantic comments, some still `; UNKNOWN`.")
    lines.append("- **DONE** — every code line has a semantic comment. No `; UNKNOWN`s remain.")
    lines.append("")

    # ----- Top-level summary table -----
    lines.append("## Top-level summary")
    lines.append("")
    lines.append("| Executable    |   Funcs |    Total lines | Identified |   % | RAW | IN-PROG | DONE |")
    lines.append("|---------------|--------:|---------------:|-----------:|----:|----:|--------:|-----:|")
    for exe_name in ["VICEROY", "MAPEDIT", "OPENING", "CLOSING"]:
        d = per_exe.get(exe_name)
        if not d:
            lines.append(f"| {exe_name:<13} |       — |              — |          — |   — |   — |       — |    — |")
            continue
        s = d["summary"]
        bs = s.get("by_status", {})
        lines.append(
            f"| {exe_name:<13} | {s['functions_total']:>7} | {s['grand_total']:>14,} "
            f"| {s['grand_identified']:>10,} | {s['pct_identified']:>4.1f} "
            f"| {bs.get('RAW', 0):>3} | {bs.get('IN-PROGRESS', 0):>7} | "
            f"{bs.get('DONE', 0):>4} |"
        )
    lines.append("")

    # ----- Per-EXE function tables -----
    for exe_name in ["VICEROY", "MAPEDIT", "OPENING", "CLOSING"]:
        d = per_exe.get(exe_name)
        if not d:
            continue
        s = d["summary"]
        lines.append(f"## `{exe_name}.EXE`")
        lines.append("")
        lines.append(
            f"- Functions: **{s['functions_total']}**"
            f" (DONE: {s['by_status'].get('DONE', 0)}, "
            f"IN-PROGRESS: {s['by_status'].get('IN-PROGRESS', 0)}, "
            f"RAW: {s['by_status'].get('RAW', 0)})"
        )
        lines.append(
            f"- Function code lines: {s['function_lines_total']:,} "
            f"(identified: {s['function_lines_identified']:,})"
        )
        lines.append(
            f"- Orphan code lines: {s['orphan_lines_total']:,} "
            f"(identified: {s['orphan_lines_identified']:,})"
        )
        lines.append(f"- Grand total: **{s['grand_total']:,}** lines, "
                     f"**{s['pct_identified']:.2f}%** identified.")
        lines.append("")

        # Function table — first 50 only when there are many; full list in JSON.
        funcs = sorted(d["functions"], key=lambda f: f["offset"] or 0)
        lines.append("| Offset | Name | Lines | Ident | % | Status | Purpose |")
        lines.append("|--------|------|------:|------:|--:|--------|---------|")
        cap = 1000  # write up to 1000 rows per EXE; full data is in functions.json
        shown = 0
        for f in funcs:
            if shown >= cap:
                break
            pct_f = (f["identified"] * 100.0 / f["lines"]) if f["lines"] else 0
            offset_str = f"0x{f['offset']:06X}" if f["offset"] is not None else "?"
            lines.append(
                f"| {offset_str} | `{f['name']}` | {f['lines']} | "
                f"{f['identified']} | {pct_f:.0f} | {f['status']} | "
                f"{f['purpose']} |"
            )
            shown += 1
        if len(funcs) > cap:
            lines.append(
                f"_… and {len(funcs) - cap} more — see `code/{exe_name}/ledger.json` for the full list._"
            )
        lines.append("")

        # Per-EXE JSON.
        json_path = root / "code" / exe_name / "ledger.json"
        json_path.write_text(json.dumps(d, indent=2), encoding="utf-8")

    out.write_bytes(("\n".join(lines)).encode("utf-8"))


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--root", default=str(Path(__file__).resolve().parent.parent))
    args = ap.parse_args()

    root = Path(args.root)
    code = root / "code"

    per_exe: dict[str, dict] = {}
    for exe_name in ["VICEROY", "MAPEDIT", "OPENING", "CLOSING"]:
        exe_dir = code / exe_name
        d = build_per_exe(exe_dir)
        if d is not None:
            per_exe[exe_name] = d

    write_ledger(root, per_exe)

    for name, d in per_exe.items():
        s = d["summary"]
        print(
            f"[ledger] {name+'.EXE':14s} funcs={s['functions_total']:5d} "
            f"lines={s['grand_total']:7,d} "
            f"ident={s['grand_identified']:7,d} ({s['pct_identified']:5.2f}%)"
        )

    print(f"\nLedger written to: {root / 'code' / 'DISASM_LEDGER.md'}")
    return 0


if __name__ == "__main__":
    import sys
    sys.exit(main())
