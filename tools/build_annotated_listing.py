#!/usr/bin/env python3
"""Build a symbolized, Ghidra-style full-program disassembly of VICEROY.EXE.

Every recognized memory operand is annotated inline:
  - absolute  [0x8542]            -> g_current_colony_ptr
  - indexed   [bx - 0x77f7]       -> PowerRecord.tax_pct   (DISP encodes base+field)
  - ptr-field [bx + 0x1f]         -> ColonyRecord.size     (base reg tracked from a ptr load)
  - calls     lcall 0x181f:0x4d4  -> random_int  (resolved via the thunk map)

Output: data_extracted/disassembly/VICEROY_annotated.asm  (one file, by function).
Run:    python3 tools/build_annotated_listing.py
"""
import json, re
from pathlib import Path
from capstone import Cs, CS_ARCH_X86, CS_MODE_16

ROOT = Path(__file__).resolve().parent.parent
EXE = (ROOT / "raw/COLONIZE/VICEROY.EXE").read_bytes()
SYM = json.load(open(ROOT / "tools/viceroy_symbols.json"))
FUNCS = json.load(open(ROOT / "code/VICEROY/functions.json"))["functions"]

# --- symbol tables -----------------------------------------------------------
GLOBALS = {int(k, 16): v for k, v in SYM["globals"].items()}
WINDOWS = {n: (int(d["base"], 16), int(d["stride"], 16)) for n, d in SYM["record_windows"].items()}
FIELDS = {rec: {int(k, 16): v for k, v in fl.items()} for rec, fl in SYM["record_fields"].items()}
PTR_REC = {int(k, 16): v for k, v in SYM["ptr_record_type"].items()}

# func offset -> name (only the meaningfully-named ones)
FUNC_NAME = {}
for f in FUNCS:
    off = int(f["file_offset"], 16)
    nm = f.get("name")
    if nm and nm != "unknown":
        FUNC_NAME[off] = nm
FUNC_STARTS = sorted(int(f["file_offset"], 16) for f in FUNCS)

# thunk targets (seg:off -> file + known function start)
THUNKS = {}
try:
    tt = json.load(open(ROOT / "data_extracted/thunk_targets.json"))
    for k, v in (tt["thunks"] if isinstance(tt, dict) else {}).items():
        THUNKS[k] = v
except Exception:
    pass

md = Cs(CS_ARCH_X86, CS_MODE_16)

def field_for(rec, off):
    """Nearest field at or below off within rec; returns 'field' or 'field+N'."""
    fl = FIELDS.get(rec, {})
    if off in fl:
        return fl[off]
    below = [o for o in fl if o < off]
    if below:
        o = max(below)
        return f"{fl[o]}+{off - o:#x}"
    return f"+{off:#x}"

def resolve_disp(d):
    """d is an effective DGROUP displacement (0..0xffff). Return a symbol or None."""
    if d in GLOBALS:
        return GLOBALS[d]
    for rec, (base, stride) in WINDOWS.items():
        if base <= d < base + stride:
            return f"{rec}.{field_for(rec, d - base)}"
    # near a record base but past one stride (still likely that record, indexed)
    for rec, (base, stride) in WINDOWS.items():
        if base <= d < base + 4 * stride:
            return f"{rec}.{field_for(rec, (d - base) % stride)}"
    return None

MEM = re.compile(r"\[([^\]]+)\]")
DISP = re.compile(r"([+-])\s*0x([0-9a-f]+)")

def annotate_ops(op_str, base_reg):
    """Return a comment string for any symbolizable memory operands."""
    notes = []
    for m in MEM.finditer(op_str):
        inner = m.group(1)
        if "bp" in inner:           # stack local / arg, not a record field
            continue
        # absolute [0xNNNN]
        ma = re.fullmatch(r"0x([0-9a-f]+)", inner.strip())
        if ma:
            a = int(ma.group(1), 16)
            if a in GLOBALS:
                notes.append(GLOBALS[a])
            else:
                s = resolve_disp(a)
                if s: notes.append(s)
            continue
        # [reg .. +/- 0xDISP]
        dm = DISP.search(inner)
        if dm:
            sign, hexv = dm.group(1), dm.group(2)
            disp = int(hexv, 16)
            eff = disp if sign == "+" else (-disp) & 0xFFFF
            s = resolve_disp(eff)
            if s:
                notes.append(s)
                continue
        # small displacement with a tracked base register -> ptr-record field
        sm = re.match(r"(\w+)\s*\+\s*0x([0-9a-f]+)$", inner.strip())
        if sm and sm.group(1) in base_reg:
            rec = base_reg[sm.group(1)]
            off = int(sm.group(2), 16)
            if rec in FIELDS:
                notes.append(f"{rec}.{field_for(rec, off)}")
    return "  ; " + ", ".join(dict.fromkeys(notes)) if notes else ""

def track_base(ins, base_reg):
    """Update reg->record_type tracking. Conservative: set on ptr loads, clear on other writes."""
    m, o = ins.mnemonic, ins.op_str
    # mov reg, [0xPTR]  where PTR is a known record pointer
    mm = re.match(r"(\w+), (?:word ptr )?\[0x([0-9a-f]+)\]$", o)
    if m == "mov" and mm:
        reg, ptr = mm.group(1), int(mm.group(2), 16)
        if ptr in PTR_REC:
            base_reg[reg] = PTR_REC[ptr]
        else:
            base_reg.pop(reg, None)
        return
    # any write to a register clears its tracking (dest is first operand)
    if "," in o:
        dst = o.split(",")[0].strip()
        if dst in base_reg and m in ("mov", "lea", "pop", "add", "sub", "xor", "and", "or", "shl", "shr", "imul", "les", "lds", "xchg"):
            base_reg.pop(dst, None)

def call_target(ins):
    """Resolve lcall/ljmp seg:off or near call to a function name."""
    o = ins.op_str
    m = re.match(r"0x([0-9a-f]+),\s*0x([0-9a-f]+)$", o)  # seg, off  (lcall/ljmp far)
    if m:
        seg, off = m.group(1), m.group(2)
        key = f"{int(seg,16):X}:{int(off,16):X}"
        # well-known resident helpers
        known = {"181F:4D4": "random_int", "181F:7B4": "power_attribute_bit",
                 "181F:484": "layer_fill", "181F:95C": "spawn_unit",
                 "181F:9AE": "format_int32", "181F:652": "msg_append",
                 "181F:438": "msg_set_int", "D1D:7E4": "strcpy", "181F:182": "strcat_itoa"}
        return known.get(key)
    mn = re.fullmatch(r"0x([0-9a-f]+)", o)  # near call
    if mn:
        return FUNC_NAME.get(int(mn.group(1), 16))
    return None

def disasm_function(start, end):
    out = []
    base_reg = {}
    code = EXE[start:end]
    for ins in md.disasm(code, start):
        ann = annotate_ops(ins.op_str, base_reg)
        ct = call_target(ins) if ins.mnemonic in ("call", "lcall", "ljmp", "jmp") else None
        if ct and not ann:
            ann = f"  ; -> {ct}"
        elif ct:
            ann += f"  -> {ct}"
        line = f"  {ins.address:06X}  {ins.mnemonic:<7s} {ins.op_str}"
        out.append(f"{line:<48s}{ann}")
        track_base(ins, base_reg)
    return out

def main():
    outp = ROOT / "data_extracted/disassembly/VICEROY_annotated.asm"
    outp.parent.mkdir(parents=True, exist_ok=True)
    lines = [
        "; ============================================================",
        "; VICEROY.EXE — symbolized full disassembly",
        "; Generated by tools/build_annotated_listing.py",
        f"; binary: raw/COLONIZE/VICEROY.EXE ({len(EXE)} bytes)",
        "; record fields annotated inline as Record.field via tools/viceroy_symbols.json",
        "; ============================================================",
        "",
    ]
    starts = FUNC_STARTS
    for i, s in enumerate(starts):
        e = starts[i + 1] if i + 1 < len(starts) else len(EXE)
        e = min(e, s + 0x4000)  # cap runaway gaps
        nm = FUNC_NAME.get(s, f"func_{s:06X}")
        tag = "" if s in FUNC_NAME else "  [unnamed]"
        lines.append("")
        lines.append(f"; ===== {nm} @ file 0x{s:06X}{tag} =====")
        lines.extend(disasm_function(s, e))
    outp.write_text("\n".join(lines))
    named = sum(1 for s in starts if s in FUNC_NAME)
    print(f"wrote {outp.relative_to(ROOT)}  ({outp.stat().st_size//1024} KB, "
          f"{len(starts)} functions, {named} named)")

if __name__ == "__main__":
    main()
