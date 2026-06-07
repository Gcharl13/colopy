#!/usr/bin/env python3
"""
classify_instructions.py — Replace `; UNKNOWN` comments with semantic
classifications for common 16-bit x86 instruction patterns.

This is a coarse pattern classifier (mnemonic + operand shape) that
adds a single-word semantic tag to every line whose pattern is
unambiguous. It will NOT replace deep hand-annotation but it pushes
ledger coverage from 4% → ~40-50% via mechanical classification.

Categories tagged:
- ; PROLOGUE         function entry (ENTER, push bp, sub sp)
- ; EPILOGUE         function exit (leave, pop bp)
- ; RETURN           ret/retf with optional imm
- ; JUMP / ; CJUMP   unconditional / conditional jumps
- ; LCALL_RTLINK     calls to RTLink runtime (already preserved)
- ; STACK_CLEANUP    add sp, N
- ; ARG              push of stack arg [bp+N]
- ; LOCAL            mov to/from [bp-N]
- ; GLOBAL_LOAD      mov reg, [imm16]
- ; GLOBAL_STORE     mov [imm16], reg / a3 imm
- ; CONST_LOAD       mov reg, imm16
- ; ARITH            arithmetic ops (add/sub/inc/dec/imul/idiv)
- ; LOGIC            logic ops (and/or/xor/test/not/shl/shr)
- ; CMP              compare
- ; FLAG             flag manipulation (clc/stc/cld/std/sti/cli)
- ; IO               in/out (port I/O)
- ; STR              string ops (movs/stos/lods/scas/cmps)
- ; SYS              dos/bios interrupts (int)
- ; FPU              x87 floating-point op (D8-DF first byte)

Lines that already have a richer comment (THUNK, STRING, GLOBAL,
BYTE_VERIFIED, hand-written annotations) are NOT touched.
"""
from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


# Match a code line: 6 hex digits + 2 spaces, then bytes column, then
# mnemonic. Use a permissive parser that only requires the address.
CODE_LINE_RE = re.compile(
    r"^([0-9A-F]{6})  ([0-9A-F][0-9A-F ]+?)\s{2,}([A-Z][A-Z0-9]*)\s*(.*?)\s*(;.*)?$",
    re.IGNORECASE,
)


# Mnemonic → category (default tag if not refined by operand inspection)
MNEMONIC_TAG = {
    # Returns
    "RET": "RETURN", "RETF": "RETURN", "IRET": "RETURN",
    # Stack
    "PUSH": "STACK_PUSH", "POP": "STACK_POP", "PUSHF": "STACK_PUSH",
    "POPF": "STACK_POP", "PUSHA": "STACK_PUSH", "POPA": "STACK_POP",
    "PUSHFD": "STACK_PUSH", "POPFD": "STACK_POP",
    # Jumps (unconditional)
    "JMP": "JUMP",
    # Jumps (conditional)
    "JE": "CJUMP", "JNE": "CJUMP", "JZ": "CJUMP", "JNZ": "CJUMP",
    "JL": "CJUMP", "JLE": "CJUMP", "JG": "CJUMP", "JGE": "CJUMP",
    "JA": "CJUMP", "JAE": "CJUMP", "JB": "CJUMP", "JBE": "CJUMP",
    "JC": "CJUMP", "JNC": "CJUMP", "JS": "CJUMP", "JNS": "CJUMP",
    "JO": "CJUMP", "JNO": "CJUMP", "JP": "CJUMP", "JNP": "CJUMP",
    "JCXZ": "CJUMP", "JECXZ": "CJUMP",
    "LOOP": "CJUMP", "LOOPE": "CJUMP", "LOOPNE": "CJUMP", "LOOPZ": "CJUMP", "LOOPNZ": "CJUMP",
    # Calls (LCALL handled separately to preserve ; THUNK ->)
    "CALL": "CALL_NEAR",
    "LCALL": "LCALL",
    # Frame
    "ENTER": "PROLOGUE",
    "LEAVE": "EPILOGUE",
    # Arithmetic
    "ADD": "ARITH", "SUB": "ARITH", "ADC": "ARITH", "SBB": "ARITH",
    "INC": "ARITH", "DEC": "ARITH", "NEG": "ARITH",
    "MUL": "ARITH", "IMUL": "ARITH", "DIV": "ARITH", "IDIV": "ARITH",
    "AAA": "ARITH", "AAS": "ARITH", "AAM": "ARITH", "AAD": "ARITH",
    "DAA": "ARITH", "DAS": "ARITH",
    "CBW": "ARITH", "CWD": "ARITH", "CDQ": "ARITH", "CWDE": "ARITH",
    "XADD": "ARITH",
    # Logic
    "AND": "LOGIC", "OR": "LOGIC", "XOR": "LOGIC", "NOT": "LOGIC",
    "TEST": "LOGIC",
    "SHL": "LOGIC", "SHR": "LOGIC", "SAL": "LOGIC", "SAR": "LOGIC",
    "RCL": "LOGIC", "RCR": "LOGIC", "ROL": "LOGIC", "ROR": "LOGIC",
    "SHLD": "LOGIC", "SHRD": "LOGIC",
    "BT": "LOGIC", "BTC": "LOGIC", "BTR": "LOGIC", "BTS": "LOGIC",
    # Compare
    "CMP": "CMP", "CMPSB": "STR", "CMPSW": "STR",
    # Flags
    "CLC": "FLAG", "STC": "FLAG", "CLD": "FLAG", "STD": "FLAG",
    "STI": "FLAG", "CLI": "FLAG", "CMC": "FLAG", "LAHF": "FLAG", "SAHF": "FLAG",
    # IO
    "IN": "IO", "OUT": "IO", "INSB": "IO", "INSW": "IO",
    "OUTSB": "IO", "OUTSW": "IO",
    # String ops
    "MOVSB": "STR", "MOVSW": "STR", "STOSB": "STR", "STOSW": "STR",
    "LODSB": "STR", "LODSW": "STR", "SCASB": "STR", "SCASW": "STR",
    "REP": "STR", "REPE": "STR", "REPNE": "STR", "REPZ": "STR", "REPNZ": "STR",
    # System
    "INT": "SYS", "INT3": "SYS", "INTO": "SYS", "BOUND": "SYS",
    "HLT": "SYS", "WAIT": "SYS", "ESC": "FPU",
    # Memory / register copy
    "MOV": "MOV",
    "XCHG": "MOV", "BSWAP": "MOV",
    "LDS": "MOV_FAR", "LES": "MOV_FAR", "LFS": "MOV_FAR", "LGS": "MOV_FAR", "LSS": "MOV_FAR",
    "LEA": "ADDR",
    # Misc
    "NOP": "NOP",
    "DB": "DATA_BYTE",
    "DW": "DATA_WORD",
}


def classify_mov(operands: str) -> str:
    """Refine a MOV instruction tag based on operand shape."""
    # mov [bp - N], reg → LOCAL_STORE
    if "[bp -" in operands or "[bp -" in operands.lower():
        if operands.split(",")[0].strip().endswith("]"):
            return "LOCAL_STORE"
        else:
            return "LOCAL_LOAD"
    # mov reg, [bp + N] / mov reg, [bp - N] → LOCAL_LOAD
    if "[bp +" in operands or "[bp +" in operands.lower():
        if operands.split(",")[1].strip().endswith("]") if "," in operands else False:
            return "LOCAL_LOAD"
        else:
            # mov [bp+N], reg → LOCAL_STORE (rare write to arg slot)
            return "LOCAL_STORE"
    # mov [imm], reg or mov reg, [imm]
    m = re.search(r"\[0x[0-9a-fA-F]+\]", operands)
    if m:
        # Determine direction
        parts = operands.split(",", 1)
        if len(parts) == 2:
            if parts[0].strip().startswith("["):
                return "GLOBAL_STORE"
            else:
                return "GLOBAL_LOAD"
    # mov reg, imm → CONST_LOAD
    m = re.search(r"\b0x[0-9a-fA-F]+\s*$", operands)
    if m and "," in operands:
        return "CONST_LOAD"
    # default
    return "MOV"


def classify_push(operands: str) -> str:
    """Refine PUSH based on operand."""
    operands = operands.strip()
    if operands.startswith("0x"):
        return "PUSH_CONST"
    if operands.startswith("[bp +") or operands.startswith("[bp + "):
        return "PUSH_ARG"
    if operands.startswith("[bp -") or operands.startswith("[bp - "):
        return "PUSH_LOCAL"
    if "[" in operands and "0x" in operands:
        return "PUSH_GLOBAL"
    return "STACK_PUSH"


def classify_pop(operands: str) -> str:
    operands = operands.strip()
    if operands.startswith("[bp +"):
        return "POP_ARG"
    if operands.startswith("[bp -"):
        return "POP_LOCAL"
    if "[" in operands and "0x" in operands:
        return "POP_GLOBAL"
    return "STACK_POP"


def classify_add_sub(mnem: str, operands: str) -> str:
    """ADD/SUB with sp is stack-frame management."""
    if "sp," in operands.replace(" ", "") or "sp ," in operands.lower():
        return "STACK_CLEANUP" if mnem.upper() == "ADD" else "STACK_ALLOC"
    return "ARITH"


def classify_line(mnem: str, operands: str) -> str | None:
    """Return the semantic tag for an instruction, or None if unclear."""
    mnem_u = mnem.upper()
    if mnem_u == "MOV":
        return classify_mov(operands)
    if mnem_u == "PUSH":
        return classify_push(operands)
    if mnem_u == "POP":
        return classify_pop(operands)
    if mnem_u in ("ADD", "SUB"):
        return classify_add_sub(mnem_u, operands)
    return MNEMONIC_TAG.get(mnem_u)


# Patterns that mean "do not overwrite this line"
PRESERVE_PATTERNS = (
    "; THUNK ->",
    "; STRING:",
    "; GLOBAL:",
    "BYTE_VERIFIED",
    "PROLOGUE",  # in case we already ran
    "EPILOGUE",
    "; RETURN",
    "; JUMP",
    "; CJUMP",
    "; ARITH",
    "; LOGIC",
    "; CMP",
    "; FLAG",
    "; IO",
    "; STR",
    "; SYS",
    "; MOV",
    "; LEA",
    "; LOCAL_",
    "; GLOBAL_",
    "; STACK_",
    "; PUSH_",
    "; POP_",
    "; ADDR",
    "; CALL_NEAR",
    "; CONST_LOAD",
)


def annotate_file(asm_path: Path) -> tuple[int, int]:
    """Replace ; UNKNOWN with semantic tags. Return (total_lines, annotated)."""
    try:
        text = asm_path.read_text(encoding="utf-8")
    except UnicodeDecodeError:
        text = asm_path.read_text(encoding="cp437", errors="replace")

    lines_in = text.splitlines(keepends=False)
    lines_out = []
    annotated = 0
    total = 0

    for line in lines_in:
        m = CODE_LINE_RE.match(line)
        if not m:
            lines_out.append(line)
            continue
        total += 1
        # Has a richer comment? Preserve.
        if any(p in line for p in PRESERVE_PATTERNS):
            lines_out.append(line)
            continue
        # Only act on lines that end with `; UNKNOWN` or `; UNKNOWN (raw)` etc.
        rstripped = line.rstrip()
        if not (rstripped.endswith("; UNKNOWN") or rstripped.endswith("; UNKNOWN (raw)") or
                rstripped.endswith("; UNKNOWN (orphan)") or
                rstripped.endswith("; UNKNOWN (orphan-raw)")):
            lines_out.append(line)
            continue
        # Classify
        mnem = m.group(3)
        operands = m.group(4) or ""
        tag = classify_line(mnem, operands)
        if tag is None:
            lines_out.append(line)
            continue
        # Strip the trailing UNKNOWN and append our tag
        # Find position of `; UNKNOWN` and remove
        idx = rstripped.rfind("; UNKNOWN")
        new_line = rstripped[:idx].rstrip() + " ; " + tag
        lines_out.append(new_line)
        annotated += 1

    if annotated > 0:
        asm_path.write_text("\n".join(lines_out) + "\n", encoding="utf-8")
    return total, annotated


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--exe", default="VICEROY",
                    help="Target EXE (VICEROY, MAPEDIT, OPENING, CLOSING)")
    args = ap.parse_args()
    disasm = ROOT / "code" / args.exe / "disasm"
    if not disasm.is_dir():
        print(f"ERROR: no disasm dir at {disasm}", file=sys.stderr)
        return 1

    total = 0
    annotated = 0
    files_changed = 0
    for asm in sorted(disasm.glob("*.asm")):
        ft, fa = annotate_file(asm)
        total += ft
        annotated += fa
        if fa > 0:
            files_changed += 1
    print(f"[classify_instructions] {args.exe}:")
    print(f"  Total code lines scanned: {total}")
    print(f"  Annotated:                {annotated} ({100*annotated/total:.1f}%)" if total else "")
    print(f"  Files changed:            {files_changed}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
