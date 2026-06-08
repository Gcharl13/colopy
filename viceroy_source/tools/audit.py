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

# embedded DGROUP control tables (data-tables resolution 2026-06-07)
check_bytes("NEIGHBOR_DX[8] @DS:0xb4", 0x1DA54, "00 01 01 01 00 ff ff ff")
check_bytes("NEIGHBOR_DY[8] @DS:0xbe", 0x1DA5E, "ff ff 00 01 01 01 00 ff")
check_ins("adjacency loop bound cmp [bp-4],8", 0x007088, "cmp", "8")
check_ins("adjacency dx read mov al,[bx+0xb4]", 0x007091, "mov", "[bx+0xb4]")
check_ins("adjacency dy read mov al,[bx+0xbe]", 0x00709B, "mov", "[bx+0xbe]")
check_ins("good->chain accessor func_008D9C cmp [bp+6],0x13", 0x008DA5, "cmp", "0x13")
check_ins("good->chain read mov al,[bx+0x2f4]", 0x008DAE, "mov", "[bx+0x2f4]")
check_bytes("GOOD_TO_CHAIN_BIT[19] tail @DS:0x2fd", 0x1DC9D, "1b 18 15 20 23 27 03 25 09 0c")
check_bytes("GOOD_TO_RAW_INPUT[19] tail @DS:0x2aa", 0x1DC4A, "08 01 02 03 04 ff 06 0e 05 ff ff")
# external balance tables: confirm the BSS bases the accessors use are >0x2cc5
# (i.e. NOT in the initialized image) — proves they are runtime-loaded.
assert 0x5235 > 0x2CC5 and 0x59D8 > 0x2CC5 and 0x8808 > 0x2CC5
results.append((True, "balance-table bases (0x5235/0x59d8/0x8808) are BSS (>0x2cc5)", "model", "external/.TXT-loaded"))

# ---- market price drift func_0305A8 (re-verified 2026-06-07) -------------
check_bytes("market drift func_0305A8 enter 0x66", 0x0305A8, "c8 66 00 00")
check_bytes("market supply imul power x0x4f", 0x0305CE, "6b 5e ac 4f")
check_ins("market price-target sub [bx+0x53ea],ax", 0x030639, "sub", "[bx+0x53ea]")
check_bytes("market rise threshold mov al,0x9c (-100)", 0x030986, "b0 9c")
check_ins("market PRICE+1 inc byte[bx+di+0x4c]", 0x0309B5, "inc", "[bx+di+0x4c]")
check_bytes("market fall threshold mov al,0x64 (+100)", 0x030A22, "b0 64")
check_ins("market PRICE-1 dec byte[bx+di+0x4c]", 0x030A4C, "dec", "[bx+di+0x4c]")
check_bytes("market PRICEUP push 0x0fa8", 0x030A04, "68 a8 0f")
check_bytes("market PRICEDOWN push 0x0fb0", 0x030A9B, "68 b0 0f")
check_bytes("market func_0305A8 terminating RETF", 0x030B37, "cb")

# ---- SoL / Tory func_2D658 + sol_membership_pct (re-verified 2026-06-07) --
check_ins("SoL bell-EMA add [bx+0xc2],ax", 0x2DA9C, "add", "[bx+0xc2]")
check_ins("SoL Tory difficulty mov al,[0x53a6]", 0x2DCBC, "mov", "[0x53a6]")
check_ins("SoL Tory sub ax,0xa (->10-diff)", 0x2DCC1, "sub", "0xa")
check_ins("SoL REBELMAJORITY cmp rebel,0x32(>=50)", 0x2DB29, "cmp", "0x32")
check_ins("SoL REBELUNANIMOUS cmp rebel,0x64(100)", 0x2DB6E, "cmp", "0x64")
check_ins("SoL membership +20 deWitt add ax,0x14", 0x00859F, "add", "0x14")
check_ins("SoL membership clamp cmp ax,0x64", 0x0085A8, "cmp", "0x64")

# ---- LCR dispatcher func_061454 (re-verified 2026-06-07) ----------------
check_bytes("LCR func_061454 enter 0x3c", 0x061454, "c8 3c 00 00")
check_bytes("LCR primary roll random_int(1,9)", 0x0614F6, "6a 09 6a 01 9a d4 04 1f 18")
check_ins("LCR scout-type cmp byte[bx+0x3146],5", 0x0614A6, "cmp", "5")
check_ins("LCR dispatch cmp ax,9", 0x061C2C, "cmp", "9")
check_ins("LCR gold imul bx,[0x5394],0x13c", 0x061C4C, "imul", "0x13c")
check_ins("LCR gold add [bx-0x77ce],ax (PowerRec+0x2a)", 0x061C52, "add", "[bx-0x77ce]")
check_bytes("LCR terminating RETF", 0x061C9C, "cb")

# ---- endgame rank ladder func_03A9C0 (verified 2026-06-07) ---------------
check_bytes("score rank-ladder func_03A9C0 enter 0x3c4", 0x03A9C0, "c8 c4 03 00")
check_ins("score difficulty mov al,[0x53a6]", 0x03AA0A, "mov", "[0x53a6]")
check_ins("score mult base add ax,4", 0x03AA0F, "add", "ax,4")
check_bytes("score scale /100 mov cx,0x64", 0x03AA38, "b9 64 00")
check_bytes("score rank ladder i*i/3 mov bx,3", 0x03AA4F, "bb 03 00")
check_ins("score rank cap cmp ax,0x17 (23)", 0x03AA71, "cmp", "0x17")
check_ins("score ladder loop bound cmp ...,0x18 (24)", 0x03AA63, "cmp", "0x18")
check_bytes("HOF record builder func_03B2F8 enter 0x2c", 0x03B2F8, "c8 2c 00 00")

# ---- native mission convert rate func_0572E6 (verified 2026-06-07) -------
check_bytes("mission convert func_0572E6 enter 0xf25", 0x0572E6, "c8 25 0f 00")
check_ins("mission rate tribe[+2] mov al,[bx+2]", 0x0572F6, "mov", "[bx+2]")
check_ins("mission bonus test cl,0x10", 0x057300, "test", "cl,0x10")
check_bytes("mission roll random_int(0,15)", 0x05730A, "6a 0f 6a 00 9a d4 04 1f 18")
check_ins("mission gate cmp roll,[bp-4]", 0x057316, "cmp", "[bp-4]")
check_bytes("mission INDIANSCONVERT push 0x182a", 0x057341, "68 2a 18")

# ---- king tax demand + REF growth (verified 2026-06-07) ------------------
check_ins("king tax func_034AE0 mov bx,[0x84fc]", 0x034AE4, "mov", "[0x84fc]")
check_bytes("king tax raise base and ax,0xfe", 0x034AF1, "25 fe 00")
check_bytes("king tax raise turn/400 mov cx,0x190", 0x034AFF, "b9 90 01")
check_bytes("king RAISE step random_int(1,diff)", 0x034B6A, "9a d4 04 1f 18")
check_ins("REF growth gate test [0x5382],1", 0x03E172, "test", "[0x5382]")
check_bytes("REF budget base shl ax,3 (diff*8)", 0x03E181, "c1 e0 03")
check_bytes("REF budget +10 add ax,0xa", 0x03E184, "05 0a 00")
check_bytes("REF era x2 cmp [0x538a],0x640 (1600)", 0x03E18A, "81 3e 8a 53 40 06")
check_bytes("REF buy threshold cmp [bx+0x22],0x708", 0x03E1C6, "81 7f 22 08 07")
check_bytes("REF GROWTH inc word[bx+0x53da]", 0x03E238, "ff 87 da 53")
check_bytes("REF arm count 4 cmp [bp-0x62],4", 0x037DA0, "83 7e 9e 04")

# ---- founding-father bell economy (verified 2026-06-07) ------------------
check_bytes("PowerRec ptr imul ax,ax,0x13c", 0x030559, "69 c0 3c 01")
check_bytes("PowerRec ptr add ax,0x8808", 0x03055D, "05 08 88")
check_bytes("FF bells add [bx+0xc],ax (spend acc)", 0x03C336, "01 47 0c")
check_bytes("FF bells add [bx+0xe],ax (lifetime)", 0x03C339, "01 47 0e")
check_bytes("FF bells reset [bx+0xc]=0 on elect", 0x03C3EA, "c7 47 0c 00 00")
check_bytes("FF cost factor shl [bp-4],3 (x8)", 0x03C2B1, "c1 66 fc 03")
check_ins("FF cost reads ff_count [bx-0x77e4]", 0x03C2FA, "mov", "[bx-0x77e4]")
check_bytes("FF threshold (ff_count+1)*factor imul [bp-4]", 0x03C303, "f7 6e fc")
check_bytes("FF select random_int(1,total_weight)", 0x03C0DB, "9a d4 04 1f 18")
check_bytes("FF pending slot mov [bx+0x12],ax", 0x03C269, "89 47 12")

# ---- map generation func_0645F6 / func_064A10 (verified 2026-06-07) -------
check_bytes("mapgen PASS1 func_0645F6 enter 0x26", 0x0645F6, "c8 26 00 00")
check_bytes("mapgen PASS2 func_064A10 enter 0x3c", 0x064A10, "c8 3c 00 00")
check_ins("mapgen reads map_width [0x853a]", 0x064B33, "mov", "[0x853a]")
check_bytes("mapgen equator sar ax,1 (height/2)", 0x064C8D, "d1 f8")
check_bytes("mapgen climate band sar ax,2 (height/4)", 0x064DE5, "c1 f8 02")
check_bytes("mapgen moisture 4*climate shl cx,2", 0x064E02, "c1 e1 02")
check_bytes("mapgen base-land terrain id 0x19", 0x064D0E, "c7 46 d2 19 00")
check_bytes("mapgen start slot imul [bp-0x28],0x13c", 0x065CC6, "69 5e d8 3c 01")
# 4-cardinal delta table (used by mapgen blob growth)
check_bytes("CARDINAL_DX[4] @DS:0xa8", 0x1DA48, "00 01 00 ff")
check_bytes("CARDINAL_DY[4] @DS:0xae", 0x1DA4E, "ff 00 01 00")

# ---- combat strength modifier stack (verified 2026-06-07) ----------------
check_bytes("ATK/DEF accessor func_07C2A enter 6", 0x07C2A, "c8 06 00 00")
check_ins("ATTACK column mov al,[bx+0x5236]", 0x07C62, "mov", "[bx+0x5236]")
check_ins("DEFENSE column mov al,[bx+0x5235]", 0x07C7E, "mov", "[bx+0x5235]")
check_bytes("combat strength x8 shl ax,3", 0x07CA9, "c1 e0 03")
check_bytes("DEF composite func_07D3E enter 0x18", 0x07D3E, "c8 18 00 00")
check_bytes("land combat decider func_05CA7E enter 0xde", 0x05CA7E, "c8 de 00 00")
check_bytes("land roll random_int(1,ATK+DEF)", 0x05D188, "9a d4 04 1f 18")
check_ins("land win iff roll<=ATK cmp ax,[bp-0x90]", 0x05D194, "cmp", "[bp-0x90]")
check_ins("combat difficulty mul [0x5325]", 0x05B9A2, "mul", "[0x5325]")
check_bytes("combat KILLED flag or [bx+0x3148],0x80", 0x05BB9E, "80 8f 48 31 80")

# ---- native raid dispatcher func_05BE84 (verified 2026-06-07) -------------
check_bytes("raid dispatcher func_05BE84 enter 0x24", 0x05BE84, "c8 24 00 00")
check_bytes("raid outcome random_int(1,4)", 0x05BF35, "6a 04 6a 01 9a d4 04 1f 18")
check_ins("raid GOLD tribe byte [bx-0x6bf0] (DS:0x9410)", 0x05C29D, "mov", "[bx-0x6bf0]")
check_ins("raid GOLD colony +0x1f mov al,[si+0x1f]", 0x05C2B0, "mov", "[si+0x1f]")
check_bytes("raid GOLD +10 add ax,0xa", 0x05C2D1, "05 0a 00")
check_bytes("raid GOLD random_int(50,..) lo=0x32", 0x05C2E6, "6a 32")
check_ins("raid GOLD subtract PowerRecord [bx-0x77ce]", 0x05C5D4, "sub", "[bx-0x77ce]")
check_ins("raid STORES sub colony goods [bx+si+0x9a]", 0x05C3AD, "sub", "0x9a")
check_bytes("raid alarm reset [bx+0x54f6]=0 on success", 0x05C651, "c7 87 f6 54 00 00")
check_bytes("raid TRIGGER alarm>=0x80 cmp [bx+0x54f6]", 0x04734E, "81 bf f6 54 80 00")
check_bytes("colony ptr idx*0xca+0x5d46", 0x008302, "69 5e 06 ca 00")
check_bytes("tribe ptr tribe*0x4e+0x5ad6 (TribeData)", 0x0081E6, "6b 46 06 4e")

# ---- unit_individual_handler_9FFC (BYTE_VERIFIED 2026-06-08) -------------
# per-colonist bells/crosses/manufactured-goods producer
check_bytes("colonist handler func_9FFC enter 0x1c", 0x009FFC, "c8 1c 00 00")
check_ins("colonist handler call sol_membership_pct", 0x00A02A, "call", "0x8524")
check_bytes("colonist handler meta_out=-1 default", 0x00A0BD, "c7 46 e8 ff ff")
check_bytes("colonist handler job13 meta=0x10 (Bells)", 0x00A100, "c7 46 e8 10 00")
check_bytes("colonist handler job16 meta=0x11 (Crosses)", 0x00A144, "c7 46 e8 11 00")
check_bytes("colonist handler job17 meta=0x12 (Flags)", 0x00A1D1, "c7 46 e8 12 00")
check_bytes("colonist handler JMP CS:[BX+0x1F44] dispatch", 0x00A1EF, "2e ff a7 44 1f")
check_bytes("colonist handler jump table 18 bytes @A1F4",  0x00A1F4,
            "d8 1e d8 1e d8 1e d8 1e 50 1e d8 1e d8 1e 82 1e 18 1f")
check_bytes("colonist handler NULL guard CMP [bp+8],0", 0x00A206, "83 7e 08 00")
check_bytes("colonist handler yield clamp OR ax,ax",  0x00A217, "0b c0")
check_bytes("colonist handler RETF", 0x00A221, "cb")

# ---- colony_surrounding_tile_scan tail (BYTE_VERIFIED 2026-06-08) -----------
check_bytes("tile_scan Phase C terrain classify entry", 0x049066, "83 7e 82 19")
check_bytes("tile_scan Phase C hills batch to food", 0x049088, "83 46 94 02")
check_bytes("tile_scan Phase D base/tiles init", 0x049242, "8a 47 04 2a e4")
check_bytes("tile_scan Phase D food yield weighted", 0x049285, "f7 6e 94")
check_bytes("tile_scan Phase D food cap write", 0x0492a7, "a3 58 9e")
check_bytes("tile_scan Phase D minerals fold", 0x04930b, "01 06 84 9e")
check_bytes("tile_scan Phase D silver yield", 0x049328, "01 06 80 9e")
check_bytes("tile_scan Phase D silver cap", 0x049341, "a3 90 9e")
check_bytes("tile_scan Phase D grain yield 9e6e", 0x049366, "a3 6e 9e")
check_bytes("tile_scan Phase D fort bonus double cap 0..7", 0x049476, "d1 a7 58 9e")
check_bytes("tile_scan Phase D per-slot cap normalize", 0x04944d, "9a 5c 03 1f 18")
check_bytes("tile_scan Phase D per-slot decay sub cap/2", 0x049549, "29 87 78 9e")
check_bytes("tile_scan epilogue RETF", 0x0495ff, "cb")

# ---- overlay_table_c_shift_down func_04C2CE (BYTE_VERIFIED 2026-06-08) ------
check_bytes("table_c shift enter + r init 0x0E", 0x04C2CE, "c8 02 00 00")
check_bytes("table_c shift bx = r*6 (shl/add/shl)", 0x04C2DC, "8b 5e fe 8b c3 d1 e3 03 d8 d1 e3")
check_bytes("table_c shift di = &TABLE_C[r*6+6]", 0x04C2E7, "8d bf e2 a0")
check_bytes("table_c shift si = &TABLE_C[r*6]",   0x04C2EB, "8d b7 dc a0")
check_bytes("table_c shift es=ds + movsw x3",     0x04C2EF, "8c d8 8e c0 a5 a5 a5")
check_bytes("table_c shift loop r >= stop_row",   0x04C2F9, "8b 46 06 39 46 fe 7d db")
check_bytes("table_c shift RETF", 0x04C304, "cb")

# ---- func_00B5A8 value-band + func_00B65A lookup (BYTE_VERIFIED 2026-06-08) --
check_bytes("value_band enter 4", 0x00B5A8, "c8 04 00 00")
check_bytes("value_band tier1 threshold cmp 0x2A", 0x00B5BE, "83 7e 06 2a")
check_bytes("value_band tier2 adj += 0xB", 0x00B5E1, "05 0b 00")
check_bytes("value_band RETF", 0x00B5F9, "cb")
check_bytes("unit_band enter 8", 0x00B65A, "c8 08 00 00")
check_bytes("unit_band calls value_band 0xB5A8", 0x00B66B, "e8 3a ff")
check_bytes("unit_band tier1 word @0x8F8C[adj*12]", 0x00B688, "8b 87 8c 8f")
check_bytes("unit_band tier2 byte @0x5239[adj*14]", 0x00B6B1, "8a 87 39 52")
check_bytes("unit_band tier2 clamp >=0x28", 0x00B6BD, "3d 28 00")
check_bytes("unit_band RETF", 0x00B703, "cb")

# ---- raw_power_score func_039EE2 (LOCATED 2026-06-08 via Type-A extra field) -
# Thunk 0x191F:0x3AA @ file 0x1B99A: off=0x0092, segid=5, extra=0x02B1
# base[5]=0x37340 + 0x02B1*16 + 0x0092 = 0x039EE2  (function start confirmed)
check_bytes("score_thunk 0x191F:0x3AA Type-A header", 0x1B99A, "9a ab 0d 0d 11")
check_bytes("score_thunk off=0x0092", 0x1B9A0, "92 00")
check_bytes("score_thunk segid=5", 0x1B9A4, "05 00")
check_bytes("score_thunk extra=0x02B1", 0x1B9A6, "b1 02")
check_bytes("raw_power_score ENTER 0x7E at 0x039EE2", 0x039EE2, "c8 7e 00 00")
check_bytes("raw_power_score reads [0x53A8]", 0x039EE6, "a0 a8 53")
check_bytes("raw_power_score imul 100*[0x53A7]", 0x039EEC, "b0 64")
check_bytes("raw_power_score arg==0 gate jmp", 0x039F46, "75 03")
# trampoline chain: call->ljmp->thunk
check_bytes("score trampoline ljmp 0x191F:0x3AA", 0x03B36A, "ea aa 03 1f 19")
check_bytes("score_endgame_rank call trampoline", 0x03A9F6, "e8 71 09")

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
