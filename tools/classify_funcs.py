#!/usr/bin/env python3
# classify_funcs.py
#
# For each function .asm file under code/<EXE>/disasm/, parse the
# instructions and emit a category tag. The result lets us batch-annotate
# functions that share a common shape (e.g. "library thunk: 1-3 instructions
# ending in a far call/jump") and identify candidates for hand-annotation
# (large functions with many calls = orchestration / game logic).
#
# Categories (best match wins; first match by priority):
#
#   LIB_THUNK       — body is essentially one far CALL/JMP, possibly
#                     wrapped by a far-RET. <=5 instructions.
#   NEAR_THUNK      — body is essentially one near CALL/JMP. <=5 instructions.
#   DOS_WRAPPER     — body issues a single INT 21h; small wrapper.
#   BIOS_WRAPPER    — body issues an INT 10h/13h/16h/2Fh; small wrapper.
#   STUB_RET        — pretty much just RET / RETF (1-3 instructions).
#   ACCESSOR        — <=10 instructions, no CALL, ends in RET. Likely a
#                     getter/setter for a global or struct field.
#   TINY_LEAF       — 11-30 instructions, no CALL, ends in RET.
#   LEAF            — 31-100 instructions, no CALL.
#   ORCHESTRATOR    — >5 CALL instructions; likely high-level control flow.
#   COMPLEX         — large + arithmetic + branches; candidate for game logic.
#   MEDIUM          — 31-100 instructions with a few CALLs.
#   LARGE           — >100 instructions; substantial function.
#   ANNOTATED       — already annotated (no UNKNOWN comments remain).
#   ALREADY_NAMED   — manual_funcs.json gave it a name; even if RAW, it
#                     escapes the unknown bucket.
#
# Output: code/<EXE>/classification.json + code/<EXE>/classification.md.

from __future__ import annotations

import argparse
import json
import re
from collections import Counter
from pathlib import Path

CODE_LINE_RE = re.compile(r"^([0-9A-F]{6})  ")
UNKNOWN_TAG = "; UNKNOWN"

# Per disasm_mz.py emit_function_asm:
#   chars 0..5   = 6-hex address
#   chars 6..7   = 2 spaces
#   chars 8..27  = 20-wide bytes column
#   chars 28..29 = 2 spaces
#   chars 30..35 = 6-wide mnemonic column (left-padded)
#   char  36     = 1 space
#   chars 37..64 = 28-wide operand column
#   chars 65..   = " ; comment"
MNEM_SLICE = slice(30, 36)
OPS_SLICE = slice(37, 65)
COMMENT_MARKER = "; "


def parse_asm(path: Path) -> dict:
    """Return per-function metrics."""
    instrs: list[tuple[str, str, str]] = []   # (mnemonic, operand, comment)
    name = path.name
    name_inner = name[len("func_"):-len(".asm")] if name.startswith("func_") else name
    parts = name_inner.split("_", 1)
    offset_hex = parts[0] if len(parts) >= 1 else "?"
    sym = parts[1] if len(parts) >= 2 else "?"

    text = path.read_text(encoding="utf-8")
    for line in text.splitlines():
        if not CODE_LINE_RE.match(line):
            continue
        # Use fixed-column slices. Pad to ensure indices exist.
        padded = line + " " * 80
        mnem = padded[MNEM_SLICE].strip().upper()
        ops = padded[OPS_SLICE].strip()
        # Comment is anything after the LAST "; "
        idx = line.rfind("; ")
        comment = line[idx:].strip() if idx >= 0 else ""
        # Strip the comment off the operand column if it bled in.
        if ";" in ops:
            ops = ops.split(";", 1)[0].strip()
        instrs.append((mnem, ops, comment))

    return {
        "asm_file": name,
        "offset_hex": offset_hex,
        "name": sym,
        "instrs": instrs,
    }


def classify(parsed: dict) -> tuple[str, dict]:
    """Return (category, stats)."""
    instrs = parsed["instrs"]
    n = len(instrs)
    mnemonics = [m for m, _, _ in instrs]
    operands = [o for _, o, _ in instrs]

    # Count returns / calls / interrupts.
    ret_count = sum(1 for m in mnemonics if m in ("RET", "RETF", "IRET"))
    call_count = sum(1 for m in mnemonics if m in ("CALL", "LCALL"))
    jmp_count = sum(1 for m in mnemonics if m in ("JMP", "LJMP"))
    int_count = sum(1 for m in mnemonics if m == "INT")
    # Simple branch instructions (conditional jumps).
    branch_re = re.compile(
        r"^J(MP|LE|LZ|LA|LB|G|GE|L|NE|E|Z|NZ|S|NS|P|NP|O|NO|C|NC|A|AE|B|BE|CXZ)$",
        re.I,
    )
    branch_count = sum(1 for m in mnemonics if m and branch_re.match(m))
    # Interrupt numbers used (immediate operand).
    int_targets: list[str] = []
    for m, o, _ in instrs:
        if m == "INT":
            int_targets.append(o.strip())

    # Is the function already annotated? (No UNKNOWN comments left on the
    # instruction lines.)
    has_unknown = any(c.startswith("; UNKNOWN") for _, _, c in instrs)
    if not has_unknown and n > 0:
        category = "ANNOTATED"
        return category, {
            "instructions": n,
            "ret": ret_count,
            "call": call_count,
            "jmp": jmp_count,
            "int": int_count,
            "branches": branch_count,
            "int_targets": int_targets,
        }

    stats = {
        "instructions": n,
        "ret": ret_count,
        "call": call_count,
        "jmp": jmp_count,
        "int": int_count,
        "branches": branch_count,
        "int_targets": int_targets,
    }

    # Category priority — most specific first.
    if n == 0:
        return "EMPTY", stats

    # Pure RET stubs.
    if n <= 3 and ret_count >= 1 and call_count == 0 and int_count == 0:
        non_ret = sum(1 for m in mnemonics if m not in ("RET", "RETF", "IRET"))
        if non_ret <= 1:
            return "STUB_RET", stats

    # Library thunks: a couple of moves + far call/jump + ret.
    if n <= 5 and any(m == "LCALL" or m == "LJMP" for m in mnemonics):
        return "LIB_THUNK", stats

    if n <= 5 and any(m == "CALL" or m == "JMP" for m in mnemonics) and ret_count <= 1:
        return "NEAR_THUNK", stats

    # DOS / BIOS interrupt wrappers — small functions whose only "external" call
    # is an INT.
    if int_count >= 1 and call_count == 0 and n <= 30:
        if any(t == "0x21" for t in int_targets):
            return "DOS_WRAPPER", stats
        if any(t in ("0x10", "0x13", "0x16", "0x2f", "0x33", "0x67") for t in int_targets):
            return "BIOS_WRAPPER", stats

    # Pure leaf accessors / utilities.
    if call_count == 0 and int_count == 0:
        if n <= 10:
            return "ACCESSOR", stats
        if n <= 30:
            return "TINY_LEAF", stats
        if n <= 100:
            return "LEAF", stats

    # Anything with many calls is orchestration.
    if call_count >= 5:
        return "ORCHESTRATOR", stats

    # Medium-size with branches and arithmetic — candidate for game logic.
    if n >= 100:
        return "LARGE", stats
    if n >= 31:
        return "MEDIUM", stats

    return "SMALL", stats


def write_report(out_dir: Path, exe_name: str, results: list[dict]) -> None:
    by_cat: dict[str, list[dict]] = {}
    for r in results:
        by_cat.setdefault(r["category"], []).append(r)

    md_lines: list[str] = []
    md_lines.append(f"# {exe_name} — Function classification")
    md_lines.append("")
    md_lines.append(
        "Each `func_*.asm` file under `disasm/` is bucketed by its instruction "
        "shape so we can batch-annotate similar functions. Generated by "
        "`tools/classify_funcs.py`. Do not hand-edit; regenerate after .asm changes."
    )
    md_lines.append("")
    md_lines.append("## Counts by category")
    md_lines.append("")
    md_lines.append("| Category | Count | Total instructions |")
    md_lines.append("|----------|------:|-------------------:|")
    cat_order = [
        "ANNOTATED",
        "STUB_RET",
        "LIB_THUNK",
        "NEAR_THUNK",
        "DOS_WRAPPER",
        "BIOS_WRAPPER",
        "ACCESSOR",
        "TINY_LEAF",
        "LEAF",
        "SMALL",
        "MEDIUM",
        "LEAF_LARGE",
        "ORCHESTRATOR",
        "LARGE",
        "EMPTY",
    ]
    for cat in cat_order + sorted(set(by_cat) - set(cat_order)):
        rows = by_cat.get(cat, [])
        if not rows:
            continue
        total = sum(r["stats"]["instructions"] for r in rows)
        md_lines.append(f"| `{cat}` | {len(rows)} | {total:,} |")
    md_lines.append("")

    for cat in cat_order + sorted(set(by_cat) - set(cat_order)):
        rows = by_cat.get(cat, [])
        if not rows:
            continue
        md_lines.append(f"## `{cat}` ({len(rows)} functions)")
        md_lines.append("")
        md_lines.append("| Offset | Name | Insns | Calls | Jmps | Ret | Int | Branches | Int# |")
        md_lines.append("|--------|------|------:|------:|-----:|----:|----:|---------:|------|")
        for r in sorted(rows, key=lambda x: x["stats"]["instructions"]):
            s = r["stats"]
            ints = ",".join(s["int_targets"][:3])
            md_lines.append(
                f"| 0x{r['offset_hex']} | `{r['name']}` | "
                f"{s['instructions']} | {s['call']} | {s['jmp']} | {s['ret']} | "
                f"{s['int']} | {s['branches']} | {ints} |"
            )
        md_lines.append("")

    (out_dir / "classification.md").write_text(
        "\n".join(md_lines), encoding="utf-8", newline="\n"
    )
    (out_dir / "classification.json").write_text(
        json.dumps(results, indent=2), encoding="utf-8"
    )


def process_exe(exe_dir: Path) -> dict:
    disasm = exe_dir / "disasm"
    if not disasm.is_dir():
        return {}
    results: list[dict] = []
    for asm in sorted(disasm.iterdir()):
        if not asm.is_file() or asm.suffix != ".asm":
            continue
        if asm.name.startswith("orphans"):
            continue
        parsed = parse_asm(asm)
        cat, stats = classify(parsed)
        results.append(
            {
                "asm_file": parsed["asm_file"],
                "offset_hex": parsed["offset_hex"],
                "name": parsed["name"],
                "category": cat,
                "stats": stats,
            }
        )
    return {"functions": results}


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--root", default=str(Path(__file__).resolve().parent.parent))
    ap.add_argument("--exes", nargs="*", default=None)
    args = ap.parse_args()

    root = Path(args.root)
    code = root / "code"
    default_exes = ["VICEROY", "MAPEDIT", "OPENING", "CLOSING"]
    targets = args.exes or default_exes

    for name in targets:
        exe_dir = code / name
        if not exe_dir.is_dir():
            continue
        out = process_exe(exe_dir)
        if not out:
            continue
        write_report(exe_dir, name + ".EXE", out["functions"])
        cnt = Counter(r["category"] for r in out["functions"])
        top = ", ".join(f"{c}:{n}" for c, n in cnt.most_common(8))
        print(f"[classify] {name+'.EXE':14s} funcs={len(out['functions'])}  {top}")

    return 0


if __name__ == "__main__":
    import sys
    sys.exit(main())
