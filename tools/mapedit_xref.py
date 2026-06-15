#!/usr/bin/env python3
"""
mapedit_xref.py — Cross-reference MAPEDIT.EXE functions against VICEROY.EXE.

MAPEDIT and VICEROY were built from the same MicroProse engine stack (MSC 6.0
C runtime + MADS asset library + RTLink/Plus runtime), so a large fraction of
MAPEDIT's functions are byte-for-byte the *same OBJ modules* that were linked
into VICEROY. Those functions inherit VICEROY's hand-assigned name and (where
present) its decompiled body.

Matching strategy
-----------------
Two 16-bit DOS images linked at different base addresses differ in exactly two
classes of bytes:

  1. Relocated words   — segment fixups listed in the MZ relocation table.
  2. Relative branches — E8 CALL / E9 JMP / 0F8x Jcc rel16 operands, *when the
     branch target lives in a different OBJ module* (different relative
     distance after linking). Intra-function branches keep the same distance.

We neutralise both classes before comparing:

  * reloc words      -> zeroed using each EXE's relocs.json
  * branch operands  -> zeroed using the per-instruction decode already present
                        in the disasm .asm files (CALL_NEAR / JUMP / CJUMP tags)

A MAPEDIT function is declared SHARED with a VICEROY function when their
normalised byte strings are identical and they have the same length.

Outputs code/MAPEDIT/xref_viceroy.json:
  { "<mapedit_offset>": {"size", "viceroy_offset", "viceroy_name",
                         "match": "exact"|"masked"} , ... }
"""
from __future__ import annotations

import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
COLONIZE = ROOT / "raw" / "COLONIZE"

# Disasm-line format:  "016527  8B EC                 MOV    bp, sp ; MOV"
LINE_RE = re.compile(r"^([0-9A-Fa-f]{4,6})\s+((?:[0-9A-Fa-f]{2} )+?)\s{2,}(\S+)")
# Tags (after the trailing ';') that denote a relative-displacement operand.
BRANCH_TAGS = {"CALL_NEAR", "JUMP", "CJUMP"}


def load_relocs(path: Path, image_base: int) -> set[int]:
    """Return the set of absolute file offsets occupied by a relocated word."""
    masked: set[int] = set()
    data = json.loads(path.read_text())
    for e in data["entries"]:
        abs_off = image_base + e["segment"] * 16 + e["offset"]
        masked.add(abs_off)
        masked.add(abs_off + 1)
    return masked


def parse_branch_mask(asm_path: Path) -> set[int]:
    """Absolute file offsets of relative-branch *operand* bytes in a function.

    For a CALL_NEAR/JUMP/CJUMP instruction the opcode byte(s) are kept (they
    identify the instruction) and only the rel8/rel16 displacement operand is
    masked. We detect operand width from how many raw bytes the line carries.
    """
    masked: set[int] = set()
    try:
        text = asm_path.read_text(encoding="utf-8", errors="replace")
    except FileNotFoundError:
        return masked
    for line in text.splitlines():
        m = LINE_RE.match(line.strip())
        if not m:
            continue
        tag = line.rsplit(";", 1)[-1].strip()
        if tag not in BRANCH_TAGS:
            continue
        off = int(m.group(1), 16)
        raw = bytes.fromhex(m.group(2).replace(" ", ""))
        if not raw:
            continue
        opcode = raw[0]
        # rel8 forms: EB (JMP short), 70-7F (Jcc short), E0-E3 (LOOP/JCXZ)
        if opcode in (0xEB,) or 0x70 <= opcode <= 0x7F or 0xE0 <= opcode <= 0xE3:
            opbytes = 1
        elif opcode in (0xE8, 0xE9):       # CALL/JMP rel16
            opbytes = 2
        elif opcode == 0x0F and len(raw) >= 2 and 0x80 <= raw[1] <= 0x8F:
            opbytes = 2                     # Jcc rel16 (two-byte opcode)
        else:
            # Unknown encoding (e.g. indirect JMP word ptr) — don't mask.
            continue
        for i in range(len(raw) - opbytes, len(raw)):
            masked.add(off + i)
    return masked


def viceroy_names() -> dict[int, str]:
    """offset -> hand-assigned name, taken from disasm/func_XXXXXX_<name>.asm."""
    names: dict[int, str] = {}
    for p in (ROOT / "code" / "VICEROY" / "disasm").glob("func_*.asm"):
        m = re.match(r"func_([0-9A-Fa-f]{6})_(.+)\.asm$", p.name)
        if not m:
            continue
        off = int(m.group(1), 16)
        nm = m.group(2)
        if nm != "unknown":
            names[off] = nm
    return names


def normalise(data: bytes, start: int, size: int,
              reloc_mask: set[int], branch_mask: set[int]) -> bytes:
    buf = bytearray(data[start:start + size])
    for i in range(size):
        if (start + i) in reloc_mask or (start + i) in branch_mask:
            buf[i] = 0
    return bytes(buf)


def main() -> int:
    me = (COLONIZE / "MAPEDIT.EXE").read_bytes()
    vc = (COLONIZE / "VICEROY.EXE").read_bytes()

    me_funcs = json.loads((ROOT / "code/MAPEDIT/functions.json").read_text())
    vc_funcs = json.loads((ROOT / "code/VICEROY/functions.json").read_text())

    me_base = me_funcs["summary"]["header_bytes"]
    vc_base = vc_funcs["summary"]["header_bytes"]

    me_reloc = load_relocs(ROOT / "code/MAPEDIT/relocs.json", me_base)
    vc_reloc = load_relocs(ROOT / "code/VICEROY/relocs.json", vc_base)
    vnames = viceroy_names()

    # Index VICEROY functions by normalised bytes (exact and masked).
    vc_exact: dict[bytes, tuple] = {}
    vc_masked: dict[bytes, tuple] = {}
    for f in vc_funcs["functions"]:
        off = int(f["file_offset"], 16)
        size = f["size"]
        exact = normalise(vc, off, size, vc_reloc, set())
        bmask = parse_branch_mask(ROOT / "code/VICEROY" / f["asm_file"])
        masked = normalise(vc, off, size, vc_reloc, bmask)
        # Prefer the first occurrence; collisions are rare (tiny stubs).
        vc_exact.setdefault((size, exact), (off, size))
        vc_masked.setdefault((size, masked), (off, size))

    out: dict[str, dict] = {}
    n_exact = n_masked = n_named = 0
    for f in me_funcs["functions"]:
        off = int(f["file_offset"], 16)
        size = f["size"]
        exact = normalise(me, off, size, me_reloc, set())
        hit = vc_exact.get((size, exact))
        match_kind = "exact"
        if hit is None:
            bmask = parse_branch_mask(ROOT / "code/MAPEDIT" / f["asm_file"])
            masked = normalise(me, off, size, me_reloc, bmask)
            hit = vc_masked.get((size, masked))
            match_kind = "masked"
        if hit is None:
            continue
        v_off, _ = hit
        rec = {
            "size": size,
            "viceroy_offset": f"0x{v_off:06X}",
            "viceroy_name": vnames.get(v_off, "unknown"),
            "match": match_kind,
        }
        out[f["file_offset"]] = rec
        if match_kind == "exact":
            n_exact += 1
        else:
            n_masked += 1
        if rec["viceroy_name"] != "unknown":
            n_named += 1

    outpath = ROOT / "code/MAPEDIT/xref_viceroy.json"
    outpath.write_text(json.dumps(out, indent=2) + "\n")
    total = len(me_funcs["functions"])
    print(f"MAPEDIT functions:        {total}")
    print(f"  shared w/ VICEROY:      {len(out)}  "
          f"({n_exact} exact, {n_masked} masked)")
    print(f"  of those, NAMED:        {n_named}")
    print(f"  MAPEDIT-unique:         {total - len(out)}")
    print(f"Wrote {outpath}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
