#!/usr/bin/env python3
"""
audit.py — regression audit of the documented BYTE_VERIFIED claims against the
actual VICEROY.EXE bytes. Each claim is an assertion at a file offset, checked
either by raw byte prefix or by disassembling and matching the instruction.

This validates (a) the toolchain and (b) the prior reconstruction in one shot,
and gives a regression baseline that every new byte-trace appends to.

Run:  python3 audit.py
"""
import json
import os
import sys

from viceroy_exe import EXE, _REPO

exe = EXE()
results = []


def ins_at(foff):
    for ins in exe.disasm(foff, 16):
        return ins
    return None


def check_bytes(desc, foff, expect_hex):
    got = exe.hex(foff, len(expect_hex.split()))
    ok = got == expect_hex
    results.append((ok, desc, f"0x{foff:06x}", f"bytes={got}" + ("" if ok else f" WANT {expect_hex}")))
    return ok


def check_ins(desc, foff, mnem_sub=None, op_sub=None):
    ins = ins_at(foff)
    if ins is None:
        results.append((False, desc, f"0x{foff:06x}", "NO DECODE"))
        return False
    text = f"{ins.mnemonic} {ins.op_str}"
    ok = True
    if mnem_sub is not None and mnem_sub not in ins.mnemonic:
        ok = False
    if op_sub is not None and op_sub.replace(" ", "") not in ins.op_str.replace(" ", ""):
        ok = False
    results.append((ok, desc, f"0x{foff:06x}", f"'{text}'" + ("" if ok else f" WANT {mnem_sub or ''} {op_sub or ''}")))
    return ok


# ------------------------------------------------------------------ CLAIMS
# foundational
check_bytes("MZ header magic", 0, "4d 5a")
check_ins("entry stub @110D:071D = LCALL far", exe.foff(0x110D, 0x071D), "call", "0x727")
check_bytes("thunk[0] @181F:0 LCALL loader", exe.foff(0x181F, 0), "9a ab 0d 0d 11")
# rand() MSC LCG  seed = seed*0x343FD + 0x269EC3
check_ins("rand() mov ax,0x43fd (LCG mult lo)", 0x103D4, "mov", "0x43fd")
check_ins("rand() mov dx,0x3   (LCG mult hi)", 0x103D7, "mov", "dx,3")

# unit subsystem
check_bytes("unit_create func_04007E enter 2,0", 0x04007E, "c8 02 00 00")
check_ins("unit_place writes [bx+0x3144]", 0x06958, "mov", "[bx+0x3144]")
check_ins("chain_next reads [si+0x315e]", 0x066C4, "mov", "[si+0x315e]")
check_bytes("unit_move_step func_04E2D6 enter 0xEE", 0x04E2D6, "c8 ee 00 00")

# king tax
check_ins("king tax cap CMP [bx+1],0x4b (=75)", 0x03434F, "cmp", "0x4b")
check_bytes("king tax raise func_034AE0 prologue", 0x034AE0, "c8")

# power record base
check_ins("PowerRecord base add ax,0x8808", 0x3055D, "add", "0x8808")

# founding fathers dispatch func_03BC42
check_bytes("FF dispatch func_03BC42 enter 0x60", 0x03BC42, "c8 60 00 00")
check_ins("FF ff_count++ inc byte [bx+0x14]", 0x03BD37, "inc", "[bx+0x14]")
check_ins("FF pending slot mov [bx+0x12],0xffff", 0x03BD3A, "mov", "0xffff")

# treaty state machine func_057DC0
check_bytes("treaty func_057DC0 push bp prologue", 0x057DC0, "55 8b ec")
check_ins("treaty imul si,[bp+6],0x13c", 0x057EBD, "imul", "0x13c")

# combat resolver func_05B2C2
check_bytes("combat resolver func_05B2C2 prologue", 0x05B2C2, "c8")

# scoring/gold tick func_051EF4
check_bytes("func_051EF4 prologue", 0x051EF4, "c8")
check_ins("gold tick add [bx+0x2a],ax", 0x051F80, "add", "[bx+0x2a]")

# dialog rect func_067DC8 (ENTER 4,0 frame — corrected from prior "push bp" note)
check_bytes("dialog rect func_067DC8 enter 4,0", 0x067DC8, "c8 04 00 00")
check_ins("dialog LEA bx,[0x839e]", 0x067DFE, "lea", "[0x839e]")

# colony production-support leaves
check_ins("test_colony_building_bit IMUL si,[bp+6],0xca", 0x861E, "imul", "0xca")
check_ins("colony bit read [bx+si+0x5dca]", 0x8629, "mov", "0x5dca")

# native settlement owner +4 bias
check_ins("native owner add ax,4", 0x046FC9, "add", "ax,4")

# report renderers (page 0x05) prologues are ENTER
check_bytes("report F2 renderer 0x37958 enter", 0x37958, "c8")
check_bytes("report F4 Labor 0x38418 enter", 0x38418, "c8")

# ------------------------------------------------------------------ REPORT
npass = sum(1 for r in results if r[0])
print(f"AUDIT: {npass}/{len(results)} claims verified against VICEROY.EXE\n")
for ok, desc, addr, detail in results:
    print(f"  [{'PASS' if ok else 'FAIL'}] {addr}  {desc}")
    if not ok:
        print(f"         -> {detail}")

report = {"total": len(results), "passed": npass,
          "claims": [{"ok": r[0], "desc": r[1], "addr": r[2], "detail": r[3]} for r in results]}
with open(os.path.join(_REPO, "re_work", "audit_report.json"), "w") as f:
    json.dump(report, f, indent=1)

sys.exit(0 if npass == len(results) else 1)
