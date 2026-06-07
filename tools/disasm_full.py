#!/usr/bin/env python3
"""Full disassembly of VICEROY.EXE - both load image and overlay."""
import struct, os, json
from collections import defaultdict
from capstone import Cs, CS_ARCH_X86, CS_MODE_16

STRIDES = {0x1C:"Unit",0xCA:"Colony",0x13C:"Power",0x34:"AI",0xC8:"Village",0x12:"TradeRoute"}
GLOBALS = {
    0x2DA8:"map_terrain",0x3144:"unit_table",0x4285:"player_ptr",
    0x538A:"year",0x538E:"unk_thresh",0x5390:"season",0x539C:"score",
    0x53C2:"game_flag",0x543F:"ai_pers",0x5D60:"colony_tbl",
    0x8542:"cur_nation",0x8820:"power_tbl",0x8D4A:"glob_8D4A",
    0x8DB8:"glob_8DB8",0x8D52:"glob_8D52",
}
YEARS = {0x5DC:1492,0x640:1600,0x672:1650,0x6A4:1700,0x708:1800,0x73A:1850}

def find_funcs(code):
    funcs = []
    i = 0
    while i < len(code)-3:
        if code[i]==0x55 and code[i+1]==0x8B and code[i+2]==0xEC:
            end = i+3
            while end < len(code)-3:
                if code[end] in (0xCB,0xC3):
                    end += 1; break
                if code[end]==0x55 and code[end+1]==0x8B and code[end+2]==0xEC:
                    break
                end += 1
            funcs.append((i, end-i))
            i = end
        # Also find ENTER prologue: C8 xx xx 00
        elif code[i]==0xC8 and i+3<len(code) and code[i+3]==0x00:
            end = i+4
            while end < len(code)-3:
                if code[end] in (0xCB,0xC3,0xC9):  # RETF/RET/LEAVE
                    if code[end]==0xC9:  # LEAVE usually followed by RET
                        if end+1<len(code) and code[end+1] in (0xCB,0xC3):
                            end += 2
                        else:
                            end += 1
                    else:
                        end += 1
                    break
                if code[end]==0x55 and end+2<len(code) and code[end+1]==0x8B and code[end+2]==0xEC:
                    break
                if code[end]==0xC8 and end+3<len(code) and code[end+3]==0x00:
                    break
                end += 1
            funcs.append((i, end-i))
            i = end
        else:
            i += 1
    return funcs

def annotate(insn):
    op = insn.op_str
    mn = insn.mnemonic
    ann = ""
    if mn == 'imul':
        for s,n in STRIDES.items():
            if f'0x{s:x}' in op: ann = f"  ; *{n}"; break
    for a,n in GLOBALS.items():
        if f'0x{a:x}' in op: ann = f"  ; {n}"; break
    if mn == 'cmp':
        for h,y in YEARS.items():
            if f'0x{h:x}' in op: ann = f"  ; year={y}"; break
    if mn == 'and' and 'ax' in op:
        for m,p in [(3,"25%"),(7,"12.5%"),(0xf,"6.25%"),(0x1f,"3.125%")]:
            if f', 0x{m:x}' in op or f', {m}' in op: ann = f"  ; {p} chance"; break
    return ann

def main():
    data = open('COLONIZE/VICEROY.EXE','rb').read()
    out_dir = 'extracted/disassembly'
    os.makedirs(out_dir, exist_ok=True)
    md = Cs(CS_ARCH_X86, CS_MODE_16)

    # ---- Load image ----
    load = data[0x2400:0x20665]
    load_funcs = find_funcs(load)
    print(f"Load image: {len(load_funcs)} functions in {len(load)//1024} KB")

    with open(f'{out_dir}/viceroy_load_image.asm','w') as f:
        f.write(f"; VICEROY.EXE Load Image Disassembly - {len(load_funcs)} functions\n\n")
        stats = defaultdict(int)
        for fi,(off,sz) in enumerate(load_funcs):
            if sz < 3: continue
            f.write(f"\n{'='*60}\n")
            f.write(f"func_L{fi:03d} at file 0x{0x2400+off:05X}, {sz} bytes\n")
            f.write(f"{'='*60}\n")
            for insn in md.disasm(load[off:off+sz], 0x2400+off):
                a = annotate(insn)
                f.write(f"  0x{insn.address:05X}: {insn.mnemonic:8s} {insn.op_str}{a}\n")
                if insn.mnemonic == 'imul': stats['imul'] += 1
                if insn.mnemonic in ('call','lcall'): stats['call'] += 1
                if a: stats['annotated'] += 1
        print(f"  Wrote {out_dir}/viceroy_load_image.asm")
        print(f"  Stats: {dict(stats)}")

    # ---- Overlay ----
    ovl = data[0x20665:]
    ovl_funcs = find_funcs(ovl)
    print(f"\nOverlay: {len(ovl_funcs)} functions in {len(ovl)//1024} KB")

    big_funcs = []
    all_globals_found = defaultdict(list)
    all_strides_found = defaultdict(list)
    rand_patterns = []
    year_checks = []

    with open(f'{out_dir}/viceroy_overlay_full.asm','w') as f:
        f.write(f"; VICEROY.EXE Overlay Disassembly - {len(ovl_funcs)} functions\n\n")
        for fi,(off,sz) in enumerate(ovl_funcs):
            if sz < 3: continue
            f.write(f"\n{'='*60}\n")
            f.write(f"func_O{fi:03d} at overlay+0x{off:05X} (file 0x{0x20665+off:05X}), {sz} bytes\n")
            f.write(f"{'='*60}\n")
            func_tags = set()
            for insn in md.disasm(ovl[off:off+sz], 0x20665+off):
                a = annotate(insn)
                f.write(f"  0x{insn.address:05X}: {insn.mnemonic:8s} {insn.op_str}{a}\n")
                if a:
                    if '*' in a:
                        name = a.split('*')[1].strip()
                        all_strides_found[name].append(fi)
                        func_tags.add(name)
                    for addr,gn in GLOBALS.items():
                        if gn in a:
                            all_globals_found[gn].append(fi)
                            func_tags.add(gn)
                    if 'chance' in a:
                        rand_patterns.append((fi, off, a.strip()))
                    if 'year=' in a:
                        year_checks.append((fi, off, a.strip()))

            big_funcs.append({"idx":fi,"offset":f"0x{off:05X}","size":sz,"tags":list(func_tags)})

    print(f"  Wrote {out_dir}/viceroy_overlay_full.asm")

    # ---- Analysis report ----
    big_funcs.sort(key=lambda x:-x["size"])
    with open(f'{out_dir}/analysis_report.json','w') as f:
        json.dump({
            "load_image_functions": len(load_funcs),
            "overlay_functions": len(ovl_funcs),
            "total_functions": len(load_funcs)+len(ovl_funcs),
            "struct_references": {k:len(v) for k,v in all_strides_found.items()},
            "global_references": {k:len(v) for k,v in all_globals_found.items()},
            "random_patterns": rand_patterns[:50],
            "year_checks": year_checks,
            "top_30_functions": big_funcs[:30],
        }, f, indent=2)
    print(f"  Wrote {out_dir}/analysis_report.json")

    # Summary
    print(f"\n{'='*60}")
    print(f"TOTAL: {len(load_funcs)+len(ovl_funcs)} functions disassembled")
    print(f"\nStruct references in overlay:")
    for k in sorted(all_strides_found, key=lambda x:-len(all_strides_found[x])):
        print(f"  {k}: {len(all_strides_found[k])} functions")
    print(f"\nGlobal references in overlay:")
    for k in sorted(all_globals_found, key=lambda x:-len(all_globals_found[x])):
        print(f"  {k}: {len(all_globals_found[k])} functions")
    print(f"\nRandom/probability patterns: {len(rand_patterns)}")
    for _,_,a in rand_patterns: print(f"  {a}")
    print(f"\nYear threshold checks: {len(year_checks)}")
    for _,_,a in year_checks: print(f"  {a}")
    print(f"\nTop 10 largest overlay functions:")
    for e in big_funcs[:10]:
        tags = ', '.join(e['tags']) if e['tags'] else 'no tags'
        print(f"  {e['offset']}: {e['size']:5d} bytes [{tags}]")

if __name__ == '__main__':
    main()
