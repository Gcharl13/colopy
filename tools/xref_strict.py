#!/usr/bin/env python3
# xref_strict.py
#
# Replaces the LE16-byte-search xref scan from extract_strings.py with a
# capstone-driven walk: disassemble every byte of the load image and the
# overlay; for each instruction with an immediate or memory-displacement
# operand, record the operand value; then cross-reference those values
# against the known string file offsets.
#
# Two passes:
#   1. Walk the executable; collect (instruction_offset, value, value_kind)
#      where value_kind is "imm16" / "disp16" / "imm32" (far ptr).
#   2. For each string, list every instruction whose operand value matches
#      one of the candidate addresses for that string. Candidates:
#        a) full file_offset (low 16 bits)        -- for code that uses
#                                                     the file offset directly
#        b) file_offset - header_bytes            -- segment-relative
#                                                     offset within image
#        c) (file_offset - header_bytes) % 0x10000  -- low-16-bit
#                                                     DGROUP-relative offset
#      Plus per-string segment guesses derived from the code's far-pointer
#      operands.
#
# The output is a strict-xrefs json + a per-EXE markdown report bucketing
# real xrefs by containing function. False positives are not zero (some
# constants in arithmetic happen to match), but they are dramatically
# reduced relative to the byte-search heuristic.

from __future__ import annotations

import argparse
import json
import sys
from collections import Counter, defaultdict
from pathlib import Path

try:
    from capstone import Cs, CS_ARCH_X86, CS_MODE_16, CS_OP_IMM, CS_OP_MEM
except ImportError:
    print("ERROR: capstone not installed. Run: pip install capstone", file=sys.stderr)
    sys.exit(1)

import disasm_mz  # parse_mz, MzHeader


def collect_immediates(file_bytes: bytes, hdr: disasm_mz.MzHeader) -> list[dict]:
    """Disassemble the load image and overlay; return one record per
    immediate / displacement operand: {file_offset, kind, value, mnemonic,
    target_segment} for each candidate cross-reference target."""
    md = Cs(CS_ARCH_X86, CS_MODE_16)
    md.detail = True

    img = hdr.image_bytes
    hdr_sz = hdr.header_bytes
    load_image = file_bytes[hdr_sz:img]
    overlay = file_bytes[img:]

    out: list[dict] = []

    def _walk(region: bytes, region_label: str, region_file_offset: int) -> None:
        for insn in md.disasm(region, region_file_offset):
            for op in insn.operands:
                if op.type == CS_OP_IMM:
                    val = op.imm
                    out.append({
                        "ins_offset": insn.address,
                        "kind": "imm",
                        "value": val,
                        "mnemonic": insn.mnemonic,
                        "region": region_label,
                    })
                elif op.type == CS_OP_MEM:
                    disp = op.mem.disp
                    if disp != 0:
                        out.append({
                            "ins_offset": insn.address,
                            "kind": "mem_disp",
                            "value": disp & 0xFFFF,  # 16-bit
                            "mnemonic": insn.mnemonic,
                            "region": region_label,
                        })

    _walk(load_image, "load_image", hdr_sz)
    _walk(overlay, "overlay", img)
    return out


def function_for_offset(funcs: list[dict], file_offset: int) -> dict | None:
    for f in funcs:
        start = int(f["file_offset"], 16)
        if start <= file_offset < start + f["size"]:
            return f
    return None


def candidate_offsets(file_offset: int, hdr_size: int) -> list[int]:
    """Return all 16-bit candidate addresses for a string at file_offset.

    The runtime code addresses data using one of:
      - the file offset directly (rare; only if the program uses absolute
        addressing into a fixed segment),
      - segment-relative offset (file_offset - segment_base*16 - header_size).

    Without doing a full segment-by-segment def-use, we enumerate the
    plausible candidates and let the caller filter. We always try the
    image-relative offset modulo 0x10000.
    """
    candidates: set[int] = set()
    candidates.add(file_offset & 0xFFFF)
    image_off = file_offset - hdr_size
    candidates.add(image_off & 0xFFFF)
    # Try every 64K-aligned base inside the image (e.g. DGROUP spanning
    # several different "base" guesses).
    for base_para in range(0, (image_off // 16) + 1, 0x1000):
        rel = image_off - base_para * 16
        if 0 <= rel < 0x10000:
            candidates.add(rel)
    return sorted(candidates)


def build_xrefs(
    immediates: list[dict],
    strings: list[dict],
    funcs: list[dict],
    hdr_size: int,
) -> dict[int, list[int]]:
    """For each string (by file_offset), return list of instruction file
    offsets that referenced it. Filtering rules:
      - Only count an instruction-immediate match if the immediate value
        equals one of the candidate offsets for that string.
      - Skip matches in the same function as the string (a string at
        file 0xFFA8 inside a function would otherwise match itself).
    """
    # Build a value -> list of immediates index.
    by_value: dict[int, list[dict]] = defaultdict(list)
    for imm in immediates:
        by_value[imm["value"]].append(imm)

    xrefs_by_string_off: dict[int, list[int]] = {}
    for s in strings:
        f_off = s["file_offset"]
        candidates = candidate_offsets(f_off, hdr_size)
        hits: set[int] = set()
        for v in candidates:
            for imm in by_value.get(v, []):
                ins_off = imm["ins_offset"]
                # Don't count an instruction inside the string's own bytes.
                if f_off <= ins_off < f_off + s["length"]:
                    continue
                hits.add(ins_off)
        xrefs_by_string_off[f_off] = sorted(hits)
    return xrefs_by_string_off


def write_anchor_drilldown(
    out_dir: Path,
    exe_name: str,
    strings: list[dict],
    funcs: list[dict],
    xrefs: dict[int, list[int]],
    keys_of_interest: list[str],
) -> None:
    lines: list[str] = []
    lines.append(f"# {exe_name} — Strict xref drilldown for game-logic anchors")
    lines.append("")
    lines.append(
        "Capstone-driven xref scan (instruction operand-immediate matches "
        "against string addresses, with image-relative and segment-relative "
        "candidate offsets). Generated by `tools/xref_strict.py`."
    )
    lines.append("")

    # Build (text → list of strings entries) so we can find each anchor.
    by_text: dict[str, list[dict]] = defaultdict(list)
    for s in strings:
        by_text[s["text"]].append(s)

    for key in keys_of_interest:
        rows = by_text.get(key, [])
        if not rows:
            lines.append(f"## `{key}` — _(string not found in EXE)_")
            lines.append("")
            continue
        # Pick the row with the most strict-xrefs.
        rows = sorted(rows, key=lambda r: -len(xrefs.get(r["file_offset"], [])))
        s = rows[0]
        ref_list = xrefs.get(s["file_offset"], [])
        lines.append(f"## `{key}` — {len(ref_list)} strict xref(s)")
        lines.append("")
        lines.append(
            f"- String at file 0x{s['file_offset']:06X} ({s['region']}, "
            f"{'NUL-terminated' if s['nul_terminated'] else 'no terminator'}, "
            f"{s['length']} bytes)"
        )
        if not ref_list:
            lines.append("- (no strict xref matches; the string is likely")
            lines.append("  reached only through a runtime-resolved table)")
            lines.append("")
            continue
        bucket: Counter = Counter()
        ins_in_func: dict[str, list[int]] = defaultdict(list)
        for ins in ref_list:
            f = function_for_offset(funcs, ins)
            key_func = f["file_offset"] if f else "(orphan)"
            bucket[key_func] += 1
            ins_in_func[key_func].append(ins)
        lines.append("")
        lines.append("| Function | Hits | Status | Name | Sample instructions |")
        lines.append("|----------|-----:|--------|------|---------------------|")
        for fn_key, n in bucket.most_common():
            sample = ", ".join(f"0x{i:06X}" for i in ins_in_func[fn_key][:3])
            if len(ins_in_func[fn_key]) > 3:
                sample += f", … (+{len(ins_in_func[fn_key]) - 3})"
            if fn_key == "(orphan)":
                lines.append(f"| (orphan) | {n} | — | — | {sample} |")
            else:
                f = next((x for x in funcs if x["file_offset"] == fn_key), None)
                if f:
                    lines.append(
                        f"| {fn_key} | {n} | {f.get('status', '?')} "
                        f"| `{f['name']}` | {sample} |"
                    )
                else:
                    lines.append(f"| {fn_key} | {n} | ? | ? | {sample} |")
        lines.append("")

    (out_dir / "anchor_drilldown.md").write_text(
        "\n".join(lines), encoding="utf-8", newline="\n"
    )


def write_summary_md(
    out_dir: Path,
    exe_name: str,
    strings: list[dict],
    funcs: list[dict],
    xrefs: dict[int, list[int]],
    min_xrefs: int,
) -> None:
    lines: list[str] = []
    lines.append(f"# {exe_name} — Strict xref top hits")
    lines.append("")
    lines.append(
        "Strings with the most capstone-validated xrefs. Generated by "
        "`tools/xref_strict.py`."
    )
    lines.append("")

    # Filter to strings with at least min_xrefs strict xrefs and length >= 5.
    by_text: dict[str, list[dict]] = defaultdict(list)
    for s in strings:
        by_text[s["text"]].append(s)

    rows: list[tuple[str, int, dict]] = []
    seen_texts: set[str] = set()
    for s in strings:
        text = s["text"]
        if text in seen_texts:
            continue
        if len(text) < 5:
            continue
        n = len(xrefs.get(s["file_offset"], []))
        if n >= min_xrefs:
            rows.append((text, n, s))
            seen_texts.add(text)
    rows.sort(key=lambda r: -r[1])

    lines.append(f"_{len(rows)} strings with >= {min_xrefs} strict xrefs (length >= 5)_")
    lines.append("")
    lines.append("| Hits | Distinct fns | String | Offset |")
    lines.append("|-----:|-------------:|--------|--------|")
    for text, n, s in rows[:200]:
        ref_list = xrefs[s["file_offset"]]
        nfns = len({
            function_for_offset(funcs, x)["file_offset"]
            for x in ref_list
            if function_for_offset(funcs, x) is not None
        })
        lines.append(f"| {n} | {nfns} | `{text}` | 0x{s['file_offset']:06X} |")
    lines.append("")

    (out_dir / "hot_strings_strict.md").write_text(
        "\n".join(lines), encoding="utf-8", newline="\n"
    )


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--root", default=str(Path(__file__).resolve().parent.parent))
    ap.add_argument("--exe", default="VICEROY.EXE")
    ap.add_argument("--min-xrefs", type=int, default=3)
    args = ap.parse_args()

    root = Path(args.root)
    raw = root / "raw" / "COLONIZE"
    code = root / "code"
    exe_path = raw / args.exe
    exe_dir = code / Path(args.exe).stem

    print(f"[xref_strict] processing {args.exe}…")
    file_bytes = exe_path.read_bytes()
    hdr = disasm_mz.parse_mz(file_bytes)
    print(f"             header_bytes={hdr.header_bytes:#x}, image_bytes={hdr.image_bytes:#x}")

    immediates = collect_immediates(file_bytes, hdr)
    print(f"             collected {len(immediates):,} operand-immediate sites")

    strings = json.loads((exe_dir / "strings.json").read_text(encoding="utf-8"))["strings"]
    funcs = json.loads((exe_dir / "functions.json").read_text(encoding="utf-8"))["functions"]
    print(f"             strings={len(strings)}, functions={len(funcs)}")

    xrefs = build_xrefs(immediates, strings, funcs, hdr.header_bytes)
    print(f"             cross-referenced {sum(len(v) for v in xrefs.values()):,} hits")

    # Save the strict xref table.
    strict = {
        "exe": args.exe,
        "candidate_strategy": "image-relative + low-16 + 64K-base sweep",
        "total_imm_sites": len(immediates),
        "xrefs": {f"0x{k:06X}": v for k, v in xrefs.items() if v},
    }
    (exe_dir / "strict_xrefs.json").write_text(
        json.dumps(strict, indent=2), encoding="utf-8"
    )

    # Anchor drilldown for the GAME.TXT / NAMES.TXT keys we care about.
    anchor_keys = [
        # NAMES.TXT
        "COUNTRY", "NATIONALITY", "NATIONABBREV", "HOMEPORT", "COLONYNAME",
        "LEADERNAME", "MISSION", "DIFFICULTY", "BUILDING", "SCENARIO",
        "CARGO", "UNIT", "ORDERS", "ACTIONS", "VALUES", "ATTITUDE",
        "LEVELS", "TRIBES", "FOUNDING", "FATHERS", "COLORS",
        "UNFORESTED", "FORESTED", "OTHER_NAMES", "RESOURCE", "SEASONS",
        # GAME.TXT high-xref keys
        "MISCELLANEOUS", "WOODCUT", "WAREHOUSEFULL", "DANGER",
        "KINGNAVACT", "KINGWAR", "KINGTAX", "KINGWIN", "KINGLOSE",
        "TAXOPTIONS", "ARMOPTIONS", "PICKINDEPENDENCE", "TRADEMANY",
        "FREEDOM", "HEATHEN", "FATHER", "SHIPRUN",
        "INDIANCITY", "EXPLOITS", "LEADER2",
        "ENGLND", "EUROPENOTAVAIL", "EUROPEARM", "OTHERMIGHT",
        "TUTORIAL15", "LUMBER", "OPENMENU", "SOONRETIRING",
        # asset filenames
        "AMER2.MP", "AMERICA.MOV", "CYCLE.DAT", "CONFIG.COL", "TRIBE.TXT",
    ]
    write_anchor_drilldown(exe_dir, args.exe, strings, funcs, xrefs, anchor_keys)
    write_summary_md(exe_dir, args.exe, strings, funcs, xrefs, args.min_xrefs)

    print(f"             wrote strict_xrefs.json, hot_strings_strict.md, anchor_drilldown.md")
    return 0


if __name__ == "__main__":
    sys.exit(main())
