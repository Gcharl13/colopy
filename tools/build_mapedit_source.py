#!/usr/bin/env python3
"""
build_mapedit_source.py — Generate mapedit_source/ tree from MAPEDIT
disasm files. Mirrors viceroy_source/ structure.

For each MAPEDIT function, emit a stub .c file with:
  - Header banner identifying it as MAPEDIT-resident
  - @asm citation block with file offset
  - Stub body (TODO: pseudo-C)
  - BYTE_VERIFIED tag if a sigmatch hit promoted the function

Also emits mapedit_source/FUNCTION_INVENTORY.md listing all 210 funcs.
"""
from __future__ import annotations

import argparse
import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--exe", default="MAPEDIT",
                    help="EXE name (MAPEDIT/OPENING/CLOSING/MPSCOPY/INSTALL)")
    args = ap.parse_args()

    # Load functions
    funcs_path = ROOT / "code" / args.exe / "functions.json"
    if not funcs_path.exists():
        print(f"ERROR: {funcs_path} not found", file=sys.stderr)
        return 1
    funcs = json.loads(funcs_path.read_text())["functions"]

    # Output directory
    out_dir = ROOT / f"{args.exe.lower()}_source"
    out_dir.mkdir(exist_ok=True)
    src_dir = out_dir / "src"
    src_dir.mkdir(exist_ok=True)

    inventory_lines = [
        f"# {args.exe}.EXE — Function Inventory",
        "",
        "Generated 2026-05-04 by `tools/build_mapedit_source.py`.",
        "",
        f"Total functions in {args.exe}.EXE: **{len(funcs)}**",
        "",
        "## Functions sharing bytes with VICEROY (BYTE_VERIFIED via sigmatch)",
        "",
        "| File offset | Size | Sigmatch name | Source |",
        "|------------|------:|---------------|--------|",
    ]

    byte_verified = []
    raw_funcs = []
    for f in funcs:
        # Read the asm file header to detect BYTE_VERIFIED tag
        asm_path = ROOT / "code" / args.exe / f["asm_file"]
        try:
            head = asm_path.read_text(encoding="utf-8")[:1500]
        except (FileNotFoundError, UnicodeDecodeError):
            head = ""
        if "BYTE_VERIFIED" in head:
            # Extract sigmatch name
            m = re.search(r"^;\s*([a-zA-Z_][\w]*)\s*\(BYTE_VERIFIED", head, re.M)
            sig_name = m.group(1) if m else "unknown"
            byte_verified.append((f, sig_name))
        else:
            raw_funcs.append(f)

    for f, sig_name in byte_verified:
        inventory_lines.append(
            f"| {f['file_offset']} | {f['size']} | `{sig_name}` | sigmatch from VICEROY.EXE |"
        )
    inventory_lines.append("")
    inventory_lines.append("## Other detected functions (RAW or partially classified)")
    inventory_lines.append("")
    inventory_lines.append("| File offset | Size | ASM file |")
    inventory_lines.append("|------------|------:|----------|")
    for f in raw_funcs:
        inventory_lines.append(
            f"| {f['file_offset']} | {f['size']} | `{f['asm_file']}` |"
        )

    (out_dir / "FUNCTION_INVENTORY.md").write_text(
        "\n".join(inventory_lines) + "\n", encoding="utf-8"
    )
    print(f"Wrote {out_dir / 'FUNCTION_INVENTORY.md'}")
    print(f"  BYTE_VERIFIED via sigmatch: {len(byte_verified)}")
    print(f"  RAW (need annotation):      {len(raw_funcs)}")

    # Emit a single header file with all function declarations
    exe_lower = args.exe.lower()
    header_lines = [
        "/*",
        f" * {exe_lower}.h — auto-generated function declarations for {args.exe}.EXE",
        " * Generated 2026-05-04 by tools/build_mapedit_source.py",
        " */",
        f"#ifndef {args.exe}_H",
        f"#define {args.exe}_H",
        "",
    ]
    for f in funcs:
        ofs = int(f["file_offset"], 16)
        end = ofs + f["size"]
        name = f"func_{ofs:06X}"
        header_lines.append(f"// @asm 0x{ofs:06X}..0x{end:06X} ({f['size']} bytes) {f['region']}")
        header_lines.append(f"void {name}(void);")
    header_lines.append("")
    header_lines.append("#endif")
    (out_dir / f"{exe_lower}.h").write_text("\n".join(header_lines), encoding="utf-8")
    print(f"Wrote {out_dir / (exe_lower + '.h')} ({len(funcs)} declarations)")

    # Emit a "tree summary" file aggregating all function bodies
    summary_lines = [
        "/*",
        f" * {exe_lower}.c — auto-generated stub bodies for {args.exe}.EXE",
        " * Each function is BYTE-VERIFIED (sigmatch) or RAW (stub).",
        " */",
        f"#include \"{exe_lower}.h\"",
        "",
    ]
    for f in funcs:
        ofs = int(f["file_offset"], 16)
        end = ofs + f["size"]
        name = f"func_{ofs:06X}"
        # Find sigmatch name if any
        sig = next(((bv_f, sn) for bv_f, sn in byte_verified
                    if bv_f["file_offset"] == f["file_offset"]), None)
        if sig:
            summary_lines.append(f"// @asm 0x{ofs:06X}..0x{end:06X}  BYTE_VERIFIED {sig[1]}")
        else:
            summary_lines.append(f"// @asm 0x{ofs:06X}..0x{end:06X}  RAW")
        summary_lines.append(f"void {name}(void) {{")
        summary_lines.append(f"    // see code/MAPEDIT/disasm/{f['asm_file'].split('/')[-1]} for body")
        summary_lines.append(f"}}")
        summary_lines.append("")
    (src_dir / f"{exe_lower}.c").write_text(
        "\n".join(summary_lines), encoding="utf-8"
    )
    print(f"Wrote {src_dir / (exe_lower + '.c')} ({len(funcs)} stubs)")

    return 0


if __name__ == "__main__":
    sys.exit(main())
