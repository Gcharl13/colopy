#!/usr/bin/env python3
# callgraph.py
#
# Build a CALL graph from a disassembled EXE. For each function, list its
# direct callees (CALL imm and LCALL seg:imm whose target lands in another
# discovered function) and its callers (the inverse). Useful for:
#   - Confirming that a function's `Callers` / `Callees` annotation is
#     complete.
#   - Locating handlers by anchor: "everything that calls _read" must be
#     a file-I/O routine.
#   - Finding orchestrators: many CALL sites in one function = high-level
#     dispatcher (turn loop, menu handler).
#
# Output: code/<EXE>/callgraph.json plus code/<EXE>/callgraph.md (a
# pretty per-function caller/callee table).

from __future__ import annotations

import argparse
import json
import sys
from collections import Counter, defaultdict
from pathlib import Path

try:
    from capstone import Cs, CS_ARCH_X86, CS_MODE_16, CS_OP_IMM
except ImportError:
    print("ERROR: capstone not installed.", file=sys.stderr)
    sys.exit(1)

import disasm_mz


def build_callgraph(file_bytes: bytes, hdr: disasm_mz.MzHeader, funcs: list[dict]) -> dict:
    md = Cs(CS_ARCH_X86, CS_MODE_16)
    md.detail = True

    hdr_sz = hdr.header_bytes
    img = hdr.image_bytes

    # Sorted list of (start, end, fn_record) for "what function contains addr".
    intervals = sorted(
        (int(f["file_offset"], 16), int(f["file_offset"], 16) + f["size"], f)
        for f in funcs
    )

    def find_fn(addr: int) -> dict | None:
        for s, e, f in intervals:
            if s <= addr < e:
                return f
        return None

    callers: dict[int, set[int]] = defaultdict(set)
    callees: dict[int, set[int]] = defaultdict(set)
    unknown_call_targets: Counter = Counter()

    # Per-function scan: disassemble each known function's exact byte range.
    # This avoids the flat-scan desync that happens when capstone's linear
    # sweep stumbles over data tables interspersed with code.
    for f in funcs:
        host_off = int(f["file_offset"], 16)
        size = f["size"]
        func_bytes = file_bytes[host_off : host_off + size]
        for ins in md.disasm(func_bytes, host_off):
            if ins.mnemonic == "call":
                for op in ins.operands:
                    if op.type == CS_OP_IMM:
                        target = op.imm
                        target_fn = find_fn(target)
                        if target_fn:
                            t_off = int(target_fn["file_offset"], 16)
                            callees[host_off].add(t_off)
                            callers[t_off].add(host_off)
                        else:
                            unknown_call_targets[target] += 1
            elif ins.mnemonic == "lcall":
                imm_ops = [op for op in ins.operands if op.type == CS_OP_IMM]
                if len(imm_ops) >= 2:
                    seg = imm_ops[0].imm & 0xFFFF
                    off = imm_ops[1].imm & 0xFFFF
                    target = hdr_sz + seg * 16 + off
                    target_fn = find_fn(target)
                    if target_fn:
                        t_off = int(target_fn["file_offset"], 16)
                        callees[host_off].add(t_off)
                        callers[t_off].add(host_off)
                    else:
                        unknown_call_targets[target] += 1

    return {
        "callees": {f"0x{k:06X}": sorted(f"0x{v:06X}" for v in s) for k, s in callees.items()},
        "callers": {f"0x{k:06X}": sorted(f"0x{v:06X}" for v in s) for k, s in callers.items()},
        "unknown_targets_top20": [
            {"target": f"0x{k:06X}", "count": v}
            for k, v in unknown_call_targets.most_common(20)
        ],
    }


def write_callgraph_md(out_dir: Path, exe_name: str, funcs: list[dict], graph: dict) -> None:
    callees = graph["callees"]
    callers = graph["callers"]

    # Sort functions: most callers first (popular leaf utilities), then most callees.
    def n_callers(f: dict) -> int:
        return len(callers.get(f["file_offset"], []))

    def n_callees(f: dict) -> int:
        return len(callees.get(f["file_offset"], []))

    funcs_sorted = sorted(funcs, key=lambda f: (-n_callers(f), -n_callees(f)))

    lines: list[str] = []
    lines.append(f"# {exe_name} — Call graph")
    lines.append("")
    lines.append(
        "Direct CALL/LCALL relationships, recovered from capstone-decoded "
        "operands. Calls whose target lands inside a discovered function are "
        "captured; calls into orphan bytes are tallied separately as "
        "`unknown_targets`."
    )
    lines.append("")
    lines.append("## Most-called functions (high in-degree = popular utilities)")
    lines.append("")
    lines.append("| Function | Callers | Callees | Status | Purpose |")
    lines.append("|----------|--------:|--------:|--------|---------|")
    for f in funcs_sorted[:50]:
        lines.append(
            f"| 0x{f['file_offset'][2:]} `{f['name']}` "
            f"| {n_callers(f)} | {n_callees(f)} | {f.get('status', '?')} "
            f"| {f.get('purpose', '')[:120].replace('|', '\\|')} |"
        )
    lines.append("")

    lines.append("## Most-calling functions (high out-degree = orchestrators)")
    lines.append("")
    funcs_by_callees = sorted(funcs, key=lambda f: -n_callees(f))
    lines.append("| Function | Callees | Callers | Status | Purpose |")
    lines.append("|----------|--------:|--------:|--------|---------|")
    for f in funcs_by_callees[:30]:
        if n_callees(f) == 0:
            break
        lines.append(
            f"| 0x{f['file_offset'][2:]} `{f['name']}` "
            f"| {n_callees(f)} | {n_callers(f)} | {f.get('status', '?')} "
            f"| {f.get('purpose', '')[:120].replace('|', '\\|')} |"
        )
    lines.append("")

    # Per-function detail for already-annotated functions (status DONE / MANUAL).
    annotated = [f for f in funcs if f.get("status") in ("MANUAL",) or f.get("name") not in (None, "unknown")]
    annotated.sort(key=lambda f: int(f["file_offset"], 16))
    lines.append("## Detail for named functions")
    lines.append("")
    for f in annotated:
        off = f["file_offset"]
        cls = callers.get(off, [])
        cls_e = callees.get(off, [])
        lines.append(f"### {off} `{f['name']}`")
        lines.append("")
        lines.append(f"- Status: `{f.get('status', '?')}`")
        if cls:
            lines.append(f"- Callers ({len(cls)}):")
            for c in cls[:30]:
                cf = next((x for x in funcs if x["file_offset"] == c), None)
                lines.append(f"    - {c} (`{cf['name']}` if cf else 'unknown')".replace("if cf else 'unknown'", "")
                             if not cf else f"    - {c} `{cf['name']}` ({cf.get('status', '?')})")
            if len(cls) > 30:
                lines.append(f"    - … (+{len(cls) - 30} more)")
        else:
            lines.append("- Callers: none")
        if cls_e:
            lines.append(f"- Callees ({len(cls_e)}):")
            for c in cls_e[:30]:
                cf = next((x for x in funcs if x["file_offset"] == c), None)
                lines.append(
                    f"    - {c} `{cf['name']}` ({cf.get('status', '?')})"
                    if cf else f"    - {c} (orphan)"
                )
        else:
            lines.append("- Callees: none")
        lines.append("")

    (out_dir / "callgraph.md").write_text("\n".join(lines), encoding="utf-8")


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--root", default=str(Path(__file__).resolve().parent.parent))
    ap.add_argument("--exe", default="VICEROY.EXE")
    args = ap.parse_args()

    root = Path(args.root)
    raw = root / "raw" / "COLONIZE"
    code = root / "code"
    exe_path = raw / args.exe
    exe_dir = code / Path(args.exe).stem

    file_bytes = exe_path.read_bytes()
    hdr = disasm_mz.parse_mz(file_bytes)
    funcs = json.loads((exe_dir / "functions.json").read_text(encoding="utf-8"))["functions"]

    print(f"[callgraph] {args.exe}: {len(funcs)} functions, building graph…")
    graph = build_callgraph(file_bytes, hdr, funcs)

    (exe_dir / "callgraph.json").write_text(json.dumps(graph, indent=2), encoding="utf-8")
    write_callgraph_md(exe_dir, args.exe, funcs, graph)

    n_known = sum(len(v) for v in graph["callees"].values())
    n_unknown = sum(d["count"] for d in graph["unknown_targets_top20"])
    print(f"            edges: {n_known} captured  / top-20 unknown sites: {n_unknown}")
    print(f"            wrote callgraph.json, callgraph.md")
    return 0


if __name__ == "__main__":
    sys.exit(main())
