#!/usr/bin/env python3
"""
Disassemble VICEROY.EXE overlay section (250 RTLink Virtual Pages).
Extracts all functions, cross-references with known strings/structs.
"""
import struct
import sys
import os
import json
from collections import defaultdict

try:
    from capstone import Cs, CS_ARCH_X86, CS_MODE_16
    HAS_CAPSTONE = True
except ImportError:
    print("ERROR: capstone not installed. Run: pip install capstone")
    sys.exit(1)

# Known struct strides
KNOWN_STRIDES = {
    0x1C: "UnitRecord (28B)",
    0xCA: "ColonyRecord (202B)",
    0x13C: "PowerRecord (316B)",
    0x34: "AIPersonality (52B)",
    0xC8: "VillageRecord (200B)",
    0x12: "TradeRouteRec (18B)",
}

# Known DS addresses
KNOWN_GLOBALS = {
    0x2DA8: "map_terrain",
    0x4285: "current_player_ptr",
    0x538A: "current_year",
    0x538E: "unk_threshold",
    0x5390: "current_season",
    0x539C: "score_related",
    0x53C2: "game_flag",
    0x543F: "ai_personality",
    0x5D60: "colony_table",
    0x8820: "power_table",
}

# Known PowerRecord field offsets
POWER_FIELDS = {
    0x01: "tax_rate",
    0x0C: "congress_progress",
    0x0E: "liberty_bells",
    0x10: "crosses",
    0x14: "founding_fathers_count",
    0x2A: "gold",
    0x44: "ref_dragoons",
    0x45: "ref_regulars",
    0x46: "ref_artillery",
    0x47: "ref_cavalry",
    0x48: "ref_man_o_war",
    0x49: "ref_frigates",
    0x4C: "market_sensitivity[0]",
    0x5C: "market_pool[0]",
    0x7C: "market_traded_volume[0]",
    0xBC: "market_eu_supply[0]",
    0xFC: "market_base_values[0]",
}


def find_functions(code, base_offset=0):
    """Find function boundaries using prologue/epilogue patterns."""
    functions = []
    i = 0
    while i < len(code) - 3:
        # Standard prologue: 55 8B EC (push bp; mov bp, sp)
        if code[i] == 0x55 and code[i+1] == 0x8B and code[i+2] == 0xEC:
            func_start = base_offset + i
            # Find end: look for RETF (CB) or RET (C3) or next prologue
            end = i + 3
            while end < len(code) - 3:
                if code[end] in (0xCB, 0xC3):  # RETF or RET
                    end += 1
                    break
                if code[end] == 0x55 and code[end+1] == 0x8B and code[end+2] == 0xEC:
                    break  # Next function
                end += 1
            func_end = base_offset + end
            func_size = end - i
            functions.append((func_start, func_end, func_size, i))
            i = end
        else:
            i += 1
    return functions


def disassemble_function(md, code, func_offset, func_size, file_base):
    """Disassemble a single function and annotate references."""
    instructions = []
    annotations = []

    func_code = code[func_offset:func_offset + func_size]

    for insn in md.disasm(func_code, file_base + func_offset):
        line = f"  0x{insn.address:05X}: {insn.mnemonic:8s} {insn.op_str}"

        # Annotate known references
        ann = ""
        op = insn.op_str

        # Check for imul with known strides
        if insn.mnemonic == 'imul':
            for stride, name in KNOWN_STRIDES.items():
                if f'0x{stride:x}' in op or f'{stride}' in op:
                    ann = f"  ; × {name}"
                    break

        # Check for known global addresses
        for addr, name in KNOWN_GLOBALS.items():
            if f'0x{addr:x}' in op or f'[0x{addr:x}]' in op:
                ann = f"  ; {name}"
                break

        # Check for known power record field offsets
        if '+' in op or '-' in op:
            for off, name in POWER_FIELDS.items():
                if f'+ 0x{off:x}]' in op or f'+0x{off:x}]' in op:
                    ann = f"  ; PowerRecord.{name}"
                    break

        # Check for CMP with known year values
        if insn.mnemonic == 'cmp' and any(f'0x{v:x}' in op for v in [0x5DC, 0x640, 0x708, 0x73A]):
            years = {0x5DC: 1492, 0x640: 1600, 0x708: 1800, 0x73A: 1850}
            for hex_v, year in years.items():
                if f'0x{hex_v:x}' in op:
                    ann = f"  ; year {year}"
                    break

        # Check for rand() % N patterns
        if insn.mnemonic == 'and' and 'ax' in op:
            for mask in [3, 7, 15, 31]:
                if f'0x{mask:x}' in op or f', {mask}' in op:
                    ann = f"  ; rand() & {mask} = 1/{mask+1} probability"
                    break

        instructions.append(line + ann)

    return instructions


def main():
    exe_path = sys.argv[1] if len(sys.argv) > 1 else "COLONIZE/VICEROY.EXE"
    out_dir = sys.argv[2] if len(sys.argv) > 2 else "extracted/disassembly"

    os.makedirs(out_dir, exist_ok=True)

    data = open(exe_path, 'rb').read()
    ovl_start = 0x20665
    ovl = data[ovl_start:]
    load_image = data[0x2400:ovl_start]

    md = Cs(CS_ARCH_X86, CS_MODE_16)
    md.detail = False

    print(f"VICEROY.EXE Disassembler")
    print(f"Overlay: {len(ovl):,} bytes at file offset 0x{ovl_start:05X}")
    print()

    # ============================================================
    # 1. Find all functions in the overlay
    # ============================================================
    print("[1] Finding functions in overlay...")
    funcs = find_functions(ovl, 0)
    print(f"    Found {len(funcs)} functions")

    # Also find functions in load image
    print("[2] Finding functions in load image...")
    load_funcs = find_functions(load_image, 0)
    print(f"    Found {len(load_funcs)} functions in load image")

    # ============================================================
    # 2. Disassemble all overlay functions
    # ============================================================
    print(f"[3] Disassembling {len(funcs)} overlay functions...")

    all_output = []
    func_index = []

    # Summary stats
    total_instructions = 0
    struct_refs = defaultdict(int)
    global_refs = defaultdict(int)
    string_refs = []
    imul_refs = defaultdict(int)
    rand_patterns = []
    cmp_values = defaultdict(int)
    call_count = 0

    for fi, (fstart, fend, fsize, code_off) in enumerate(funcs):
        if fsize < 3:
            continue

        instrs = disassemble_function(md, ovl, code_off, fsize, ovl_start)
        total_instructions += len(instrs)

        # Analyze this function
        has_imul = False
        has_rand = False
        refs_structs = set()
        refs_globals = set()

        for line in instrs:
            if 'imul' in line.lower():
                has_imul = True
                for stride, name in KNOWN_STRIDES.items():
                    if name in line:
                        imul_refs[name] += 1
                        refs_structs.add(name)

            for addr, name in KNOWN_GLOBALS.items():
                if name in line:
                    global_refs[name] += 1
                    refs_globals.add(name)

            if 'probability' in line:
                has_rand = True
                rand_patterns.append((fstart, line.strip()))

            if 'call' in line.lower():
                call_count += 1

            if '; year' in line:
                cmp_values['year_check'] += 1

        # Build function summary
        summary = f"func_{fi:03d}"
        tags = []
        if refs_structs:
            tags.append("structs:" + ",".join(refs_structs))
        if refs_globals:
            tags.append("globals:" + ",".join(refs_globals))
        if has_rand:
            tags.append("RANDOM")

        func_entry = {
            "index": fi,
            "overlay_offset": f"0x{fstart:05X}",
            "file_offset": f"0x{ovl_start + code_off:05X}",
            "size": fsize,
            "instructions": len(instrs),
            "tags": tags,
        }
        func_index.append(func_entry)

        # Write to output
        all_output.append(f"\n{'='*70}")
        all_output.append(f"FUNCTION {fi:03d} at overlay+0x{fstart:05X} (file 0x{ovl_start+code_off:05X}), {fsize} bytes")
        if tags:
            all_output.append(f"  Tags: {', '.join(tags)}")
        all_output.append(f"{'='*70}")
        all_output.extend(instrs)

    # ============================================================
    # 3. Write output files
    # ============================================================

    # Full disassembly
    asm_path = os.path.join(out_dir, "viceroy_overlay.asm")
    with open(asm_path, 'w') as f:
        f.write(f"; VICEROY.EXE Overlay Disassembly\n")
        f.write(f"; {len(funcs)} functions, {total_instructions} instructions\n")
        f.write(f"; Generated by disassemble_viceroy.py\n\n")
        f.write('\n'.join(all_output))
    print(f"    Wrote {asm_path} ({os.path.getsize(asm_path):,} bytes)")

    # Function index
    idx_path = os.path.join(out_dir, "function_index.json")
    with open(idx_path, 'w') as f:
        json.dump(func_index, f, indent=2)
    print(f"    Wrote {idx_path}")

    # ============================================================
    # 4. Summary report
    # ============================================================
    print()
    print(f"{'='*60}")
    print(f"DISASSEMBLY SUMMARY")
    print(f"{'='*60}")
    print(f"  Overlay functions:    {len(funcs)}")
    print(f"  Load image functions: {len(load_funcs)}")
    print(f"  Total instructions:   {total_instructions:,}")
    print(f"  Total call sites:     {call_count}")
    print()

    print(f"  Struct references:")
    for name, count in sorted(imul_refs.items(), key=lambda x: -x[1]):
        print(f"    {name}: {count}")

    print(f"\n  Global variable references:")
    for name, count in sorted(global_refs.items(), key=lambda x: -x[1]):
        print(f"    {name}: {count}")

    print(f"\n  Random/probability patterns: {len(rand_patterns)}")
    for fstart, line in rand_patterns[:20]:
        print(f"    func at 0x{fstart:05X}: {line[:80]}")

    print(f"\n  Functions by size:")
    sizes = [s for _, _, s, _ in funcs if s >= 3]
    if sizes:
        sizes.sort()
        print(f"    Smallest: {min(sizes)} bytes")
        print(f"    Largest:  {max(sizes)} bytes")
        print(f"    Median:   {sizes[len(sizes)//2]} bytes")
        print(f"    Total code: {sum(sizes):,} bytes")

    # Large functions are likely the most important game logic
    print(f"\n  Top 20 largest functions (likely core game logic):")
    big_funcs = sorted(funcs, key=lambda x: -x[2])[:20]
    for fstart, fend, fsize, _ in big_funcs:
        tags_for = [e for e in func_index if e["overlay_offset"] == f"0x{fstart:05X}"]
        tag_str = ""
        if tags_for and tags_for[0]["tags"]:
            tag_str = " [" + ", ".join(tags_for[0]["tags"]) + "]"
        print(f"    0x{fstart:05X}: {fsize:5d} bytes{tag_str}")


if __name__ == '__main__':
    main()
