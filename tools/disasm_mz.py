#!/usr/bin/env python3
# disasm_mz.py
#
# Phase 1 disassembler for the six DOS executables in raw/COLONIZE/.
#
# Per the project plan (formats/EXE_MZ.md, formats/RTLINK.md):
#
#   1. Parse the 28-byte MZ header.
#   2. Slice load image and (if present) overlay.
#   3. In the load image, find candidate function starts via the standard
#      `55 8B EC` prologue (push bp; mov bp, sp). Walk forward to the next
#      RET / RETF or next prologue to find the function end.
#   4. In the overlay, do the same flat scan (Phase 1 treats overlay as
#      one flat region; Phase 2 will partition it).
#   5. Disassemble each function with capstone CS_ARCH_X86 + CS_MODE_16.
#   6. Emit one file per function:
#        code/<EXE>/disasm/func_<6hex>_unknown.asm
#      Format per line:
#        <6hex>  <bytes>   <MNEMONIC>  <operands>   ; UNKNOWN
#      (Phase 2 work replaces ; UNKNOWN with semantic comments.)
#   7. Emit code/<EXE>/functions.json (index for ledger_update.py).
#   8. Emit code/<EXE>/header.asm (annotated MZ header bytes).
#   9. Emit code/<EXE>/relocs.json (relocation table).
#  10. Anything not covered by an identified function is collected into
#      code/<EXE>/disasm/orphans.asm (unclaimed bytes) so the ledger
#      reflects 100% coverage of the file's bytes.
#
# We do NOT load any prior symbol tables (KNOWN_STRIDES, KNOWN_GLOBALS, etc.).
# Annotation is a Phase 2 concern. Phase 1 produces a complete, mechanical
# baseline.

from __future__ import annotations

import argparse
import json
import os
import re
import struct
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import Iterable

try:
    from capstone import Cs, CS_ARCH_X86, CS_MODE_16
except ImportError:
    print("ERROR: capstone not installed. Run: pip install capstone", file=sys.stderr)
    sys.exit(1)


# ----------------------------------------------------------------------------
# MZ header
# ----------------------------------------------------------------------------

@dataclass
class MzHeader:
    e_signature: int
    e_last_page: int
    e_pages: int
    e_relocs: int
    e_hdr_paragraphs: int
    e_min_alloc: int
    e_max_alloc: int
    e_ss: int
    e_sp: int
    e_checksum: int
    e_ip: int
    e_cs: int
    e_reloc_table_offset: int
    e_overlay_number: int

    @classmethod
    def from_bytes(cls, b: bytes) -> "MzHeader":
        f = struct.unpack("<HHHHHHHHHHHHHH", b[:28])
        return cls(*f)

    @property
    def image_bytes(self) -> int:
        if self.e_last_page == 0:
            return self.e_pages * 512
        return (self.e_pages - 1) * 512 + self.e_last_page

    @property
    def header_bytes(self) -> int:
        return self.e_hdr_paragraphs * 16

    @property
    def code_data_bytes(self) -> int:
        return self.image_bytes - self.header_bytes


def parse_mz(file_bytes: bytes) -> MzHeader:
    if file_bytes[:2] != b"MZ":
        raise ValueError("Not an MZ executable")
    return MzHeader.from_bytes(file_bytes)


def read_relocations(file_bytes: bytes, hdr: MzHeader) -> list[tuple[int, int]]:
    """Returns list of (offset, segment) pairs from the relocation table."""
    out: list[tuple[int, int]] = []
    base = hdr.e_reloc_table_offset
    for i in range(hdr.e_relocs):
        off, seg = struct.unpack_from("<HH", file_bytes, base + i * 4)
        out.append((off, seg))
    return out


# ----------------------------------------------------------------------------
# Function discovery
# ----------------------------------------------------------------------------

def _is_prologue(region: bytes, i: int) -> int:
    """Return the byte length of a prologue at offset i, or 0 if no
    prologue starts here.

    Recognised prologues:
      * 55 8B EC                          (push bp ; mov bp, sp)             -> 3 bytes
      * C8 xx xx xx                       (enter imm16, imm8)                -> 4 bytes
      * 55 89 E5                          (push bp ; mov bp, sp)             -> 3 bytes
                                          (alternative encoding)

    The Borland-style ENTER prologue is what VICEROY's overlay is built
    with — it's almost universal there. Without it, function detection in
    the overlay misses ~95% of the real functions.
    """
    n = len(region)
    if i + 3 <= n:
        # 55 8B EC
        if region[i] == 0x55 and region[i + 1] == 0x8B and region[i + 2] == 0xEC:
            return 3
        # 55 89 E5
        if region[i] == 0x55 and region[i + 1] == 0x89 and region[i + 2] == 0xE5:
            return 3
    if i + 4 <= n:
        # C8 imm16 imm8 (ENTER)
        # ENTER's imm16 frame size is small for typical functions (< 0x1000).
        # We require the imm16 to be < 0x1000 to filter out the many random
        # 0xC8 bytes appearing as operands of other instructions.
        if region[i] == 0xC8:
            frame_size = region[i + 1] | (region[i + 2] << 8)
            nesting = region[i + 3]
            if frame_size < 0x1000 and nesting < 8:
                return 4
    return 0


def find_functions_in_region(region: bytes) -> list[tuple[int, int]]:
    """Find function (start, end) byte offsets within `region`.

    For each prologue found, walk forward to the first plausible function
    end. The walk stops at:
      * a return instruction (RET / RETF / IRET / RET imm16 / RETF imm16)
      * the start of the next prologue
      * the LEAVE+RETF / LEAVE+RET pair (Borland convention)
    The heuristic still misses some functions; those bytes go to the
    orphan bucket so the ledger still covers 100%.
    """
    funcs: list[tuple[int, int]] = []
    i = 0
    n = len(region)
    while i + 3 < n:
        prologue_len = _is_prologue(region, i)
        if prologue_len:
            start = i
            j = i + prologue_len
            while j < n - 1:
                b = region[j]
                # Function-terminating returns: RET / RETF / IRET
                if b in (0xC3, 0xCB, 0xCF):
                    j += 1
                    break
                # RET imm16 / RETF imm16
                if b in (0xC2, 0xCA) and j + 2 < n:
                    j += 3
                    break
                # LEAVE + RET / RETF (typical Borland epilogue)
                if b == 0xC9 and j + 1 < n and region[j + 1] in (0xC3, 0xCB):
                    j += 2
                    break
                # Next prologue at byte boundary?
                if _is_prologue(region, j):
                    break
                j += 1
            else:
                j = n
            funcs.append((start, j))
            i = j
        else:
            i += 1
    return funcs


# ----------------------------------------------------------------------------
# Output formatting
# ----------------------------------------------------------------------------

def fmt_hex_addr(n: int, width: int = 6) -> str:
    return f"{n:0{width}X}"


def fmt_bytes(bs: bytes, max_show: int = 7) -> str:
    """Render a tight hex column for an instruction's raw bytes, max 7 bytes."""
    bs = bs[:max_show]
    return " ".join(f"{b:02X}" for b in bs)


# Pattern that classifies a comment as "still RAW" (not a real annotation).
RAW_COMMENT_RE = re.compile(r"^;\s*UNKNOWN(\b|\s|$)", re.IGNORECASE)


def load_existing_comments(path: Path) -> dict[int, str]:
    """Read an existing func_*.asm and return {address_int: comment_str} for
    every instruction line whose comment is NOT one of the `; UNKNOWN…`
    sentinels. The returned dict is consumed by emit_function_asm() so that a
    --force regeneration preserves real semantic annotations.

    Comments are returned WITH the leading `; ` and trailing newline stripped.
    """
    out: dict[int, str] = {}
    if not path.exists():
        return out
    for line in path.read_text(encoding="utf-8").splitlines():
        if len(line) < 8 or line[6:8] != "  ":
            continue
        addr_str = line[:6]
        if not all(c in "0123456789ABCDEF" for c in addr_str):
            continue
        try:
            addr = int(addr_str, 16)
        except ValueError:
            continue
        # Comment is everything from the FIRST `; ` at or after the comment
        # column. Per emit_function_asm the comment column is at index 66, but
        # operand-overflow can shift it, so we start the search a bit earlier.
        idx = line.find("; ", 60)
        if idx < 0:
            continue
        comment = line[idx:].rstrip()
        if RAW_COMMENT_RE.match(comment):
            continue
        out[addr] = comment
    return out


def emit_function_asm(
    md: Cs,
    region: bytes,
    region_label: str,
    region_file_offset: int,
    func_local_start: int,
    func_local_end: int,
    out_path: Path,
    func_name: str = "unknown",
    manual_metadata: dict | None = None,
    preserved_comments: dict[int, str] | None = None,
) -> int:
    """Disassemble one function and write its .asm file.

    If `out_path` already exists, return 0 without overwriting — Phase 2
    annotations live in the .asm files and must not be clobbered. The caller
    can pass --force to override.

    Returns the number of instructions emitted (used by the ledger).
    """
    func_bytes = region[func_local_start:func_local_end]
    file_offset = region_file_offset + func_local_start

    lines: list[str] = []
    # Header block. Phase 2 fills in purpose/args/etc. Phase 1 gives the
    # boilerplate plus enough metadata to relocate the function.
    lines.append(
        "; ============================================================================"
    )
    lines.append(f"; func_{fmt_hex_addr(file_offset)}_{func_name}")
    lines.append(f"; Region   : {region_label}")
    lines.append(
        f"; Bytes    : file 0x{fmt_hex_addr(file_offset)}..0x{fmt_hex_addr(file_offset + len(func_bytes))}  "
        f"({len(func_bytes)} bytes)"
    )
    if manual_metadata:
        lines.append(f"; Purpose  : {manual_metadata.get('purpose', 'UNKNOWN')}")
        lines.append(f"; Args     : {manual_metadata.get('args', 'UNKNOWN')}")
        lines.append(f"; Returns  : {manual_metadata.get('returns', 'UNKNOWN')}")
        lines.append(f"; Callers  : {manual_metadata.get('callers', 'UNKNOWN')}")
        lines.append(f"; Callees  : {manual_metadata.get('callees', 'UNKNOWN')}")
        lines.append(f"; Verified : {manual_metadata.get('verified', 'not yet')}")
        if "source" in manual_metadata:
            lines.append(f"; Source   : {manual_metadata['source']}")
    else:
        lines.append("; Purpose  : UNKNOWN")
        lines.append("; Args     : UNKNOWN")
        lines.append("; Returns  : UNKNOWN")
        lines.append("; Callers  : UNKNOWN")
        lines.append("; Callees  : UNKNOWN")
        lines.append("; Verified : not yet")
    lines.append(
        "; ============================================================================"
    )
    lines.append("")

    preserved = preserved_comments or {}

    insn_count = 0
    cursor = 0
    for insn in md.disasm(func_bytes, file_offset):
        raw = bytes(insn.bytes)
        addr_col = fmt_hex_addr(insn.address)
        bytes_col = fmt_bytes(raw)
        mnem = insn.mnemonic.upper()
        ops = insn.op_str
        # If the previous version of this file had a non-UNKNOWN comment for
        # this exact address, reuse it. Otherwise emit `; UNKNOWN`.
        comment = preserved.get(insn.address, "; UNKNOWN")
        line = f"{addr_col}  {bytes_col:<20}  {mnem:<6} {ops:<28} {comment}"
        lines.append(line.rstrip())
        insn_count += 1
        cursor = insn.address - file_offset + insn.size

    # Anything capstone refused to decode (rare for valid 16-bit code, but
    # possible at function end / data tails) is appended as raw bytes so the
    # file accounts for every byte of the function.
    if cursor < len(func_bytes):
        tail = func_bytes[cursor:]
        for k, b in enumerate(tail):
            addr = file_offset + cursor + k
            comment = preserved.get(addr, "; UNKNOWN (raw)")
            line = (
                f"{fmt_hex_addr(addr)}  {b:02X}                    DB     0x{b:02X}{'':<24} {comment}"
            )
            lines.append(line)
            insn_count += 1

    lines.append("")
    out_path.write_text("\n".join(lines), encoding="utf-8", newline="\n")
    return insn_count


def emit_orphans_asm(
    md: Cs,
    region: bytes,
    region_label: str,
    region_file_offset: int,
    covered: list[tuple[int, int]],
    out_path: Path,
) -> int:
    """Emit an .asm file containing every byte of `region` not claimed by a
    function. The bytes are disassembled best-effort; any byte capstone
    cannot decode is emitted as DB. Returns instruction line count."""
    covered_sorted = sorted(covered)
    gaps: list[tuple[int, int]] = []
    cur = 0
    for start, end in covered_sorted:
        if start > cur:
            gaps.append((cur, start))
        cur = max(cur, end)
    if cur < len(region):
        gaps.append((cur, len(region)))

    if not gaps:
        if out_path.exists():
            out_path.unlink()
        return 0

    lines: list[str] = []
    lines.append("; ============================================================================")
    lines.append(f"; orphans — region: {region_label}")
    lines.append(
        f"; Bytes not claimed by any prologue-detected function. Phase 2 will "
        "promote\n; the real ones into proper func_*.asm files; the rest are data tables, "
        "padding,\n; or leaf functions without a stack frame."
    )
    lines.append(
        f"; Total orphan ranges: {len(gaps)}, "
        f"total bytes: {sum(b - a for a, b in gaps)}"
    )
    lines.append("; ============================================================================")
    lines.append("")

    insn_count = 0
    for gap_start, gap_end in gaps:
        gap_bytes = region[gap_start:gap_end]
        gap_file_offset = region_file_offset + gap_start

        lines.append(
            f"; --- orphan range: file 0x{fmt_hex_addr(gap_file_offset)}"
            f"..0x{fmt_hex_addr(gap_file_offset + len(gap_bytes))} "
            f"({len(gap_bytes)} bytes) ---"
        )

        cursor = 0
        for insn in md.disasm(gap_bytes, gap_file_offset):
            raw = bytes(insn.bytes)
            addr_col = fmt_hex_addr(insn.address)
            bytes_col = fmt_bytes(raw)
            mnem = insn.mnemonic.upper()
            ops = insn.op_str
            line = f"{addr_col}  {bytes_col:<20}  {mnem:<6} {ops:<28} ; UNKNOWN (orphan)"
            lines.append(line.rstrip())
            insn_count += 1
            cursor = insn.address - gap_file_offset + insn.size

        if cursor < len(gap_bytes):
            tail = gap_bytes[cursor:]
            for k, b in enumerate(tail):
                addr = gap_file_offset + cursor + k
                line = (
                    f"{fmt_hex_addr(addr)}  {b:02X}                    DB     0x{b:02X}{'':<24} ; UNKNOWN (orphan-raw)"
                )
                lines.append(line)
                insn_count += 1
        lines.append("")

    out_path.write_text("\n".join(lines), encoding="utf-8", newline="\n")
    return insn_count


def emit_header_asm(file_bytes: bytes, hdr: MzHeader, out_path: Path) -> None:
    lines: list[str] = []
    lines.append("; ============================================================================")
    lines.append("; MZ header + relocation table")
    lines.append("; (mechanically labeled per formats/EXE_MZ.md; not Phase 2 \"identified\")")
    lines.append("; ============================================================================")
    lines.append("")

    fields = [
        ("e_signature",          hdr.e_signature,           "MZ"),
        ("e_last_page",          hdr.e_last_page,           "bytes used in last 512-byte page"),
        ("e_pages",              hdr.e_pages,               "total 512-byte pages in image"),
        ("e_relocs",             hdr.e_relocs,              "relocation entry count"),
        ("e_hdr_paragraphs",     hdr.e_hdr_paragraphs,      "header size in 16-byte paragraphs"),
        ("e_min_alloc",          hdr.e_min_alloc,           "min extra paragraphs"),
        ("e_max_alloc",          hdr.e_max_alloc,           "max extra paragraphs"),
        ("e_ss",                 hdr.e_ss,                  "initial SS (segment-relative)"),
        ("e_sp",                 hdr.e_sp,                  "initial SP"),
        ("e_checksum",           hdr.e_checksum,            "header checksum"),
        ("e_ip",                 hdr.e_ip,                  "initial IP"),
        ("e_cs",                 hdr.e_cs,                  "initial CS (segment-relative)"),
        ("e_reloc_table_offset", hdr.e_reloc_table_offset,  "file offset of relocation table"),
        ("e_overlay_number",     hdr.e_overlay_number,      "0 = main module"),
    ]
    off = 0
    for name, val, comment in fields:
        bytes_at = file_bytes[off:off + 2]
        lines.append(
            f"{fmt_hex_addr(off, 4)}  {bytes_at[0]:02X} {bytes_at[1]:02X}      "
            f"{name:<22} = 0x{val:04X}   ; {comment}"
        )
        off += 2

    if hdr.e_relocs:
        lines.append("")
        lines.append("; ---- Relocation table ----")
        lines.append(f"; {hdr.e_relocs} entries starting at file offset 0x{hdr.e_reloc_table_offset:04X}")
        lines.append("; Each entry: (offset, segment) — DOS adds load segment to the word")
        lines.append("; at image[offset + segment*16] at load time.")

    out_path.write_text("\n".join(lines) + "\n", encoding="utf-8", newline="\n")


# ----------------------------------------------------------------------------
# Per-EXE driver
# ----------------------------------------------------------------------------

def load_manual_funcs(out_dir: Path) -> list[dict]:
    """Read code/<EXE>/manual_funcs.json if present.

    Each entry shape:
      {
        "file_offset": "0x013BED" | int,
        "size":        10,
        "name":        "startup_stub",
        "purpose":     "C runtime entry-point stub: ...",
        "args":        "(none)",
        "returns":     "does not return (tail-jumps to _main)",
        "callers":     "DOS loader",
        "callees":     "system_init (0x13BF7), _main (0x11720)",
        "source":      "manually identified — MZ entry point per cs:ip = 110D:071D"
      }

    The `file_offset` and `size` together pin the function's byte range
    inside the load image / overlay; `name` becomes the filename suffix.
    """
    p = out_dir / "manual_funcs.json"
    if not p.exists():
        return []
    raw = json.loads(p.read_text(encoding="utf-8"))
    out: list[dict] = []
    for r in raw:
        off = r["file_offset"]
        if isinstance(off, str):
            off = int(off, 16) if off.startswith("0x") else int(off)
        out.append(
            {
                **r,
                "file_offset_int": off,
                "size_int": int(r["size"]),
            }
        )
    return out


def disassemble_exe(exe_path: Path, out_dir: Path, force: bool = False) -> dict:
    file_bytes = exe_path.read_bytes()
    hdr = parse_mz(file_bytes)

    img_size = hdr.image_bytes
    hdr_size = hdr.header_bytes
    load_image = file_bytes[hdr_size:img_size]            # disassemble this
    overlay = file_bytes[img_size:]                        # disassemble this if non-empty
    relocs = read_relocations(file_bytes, hdr)

    out_dir.mkdir(parents=True, exist_ok=True)
    disasm_dir = out_dir / "disasm"
    disasm_dir.mkdir(exist_ok=True)

    md = Cs(CS_ARCH_X86, CS_MODE_16)
    md.detail = False

    emit_header_asm(file_bytes, hdr, out_dir / "header.asm")

    manual_funcs = load_manual_funcs(out_dir)

    (out_dir / "relocs.json").write_text(
        json.dumps(
            {
                "count": len(relocs),
                "table_offset": hdr.e_reloc_table_offset,
                "entries": [{"offset": o, "segment": s} for o, s in relocs],
            },
            indent=2,
        ),
        encoding="utf-8",
    )

    funcs_index: list[dict] = []
    total_instr = 0

    # Bucket the manual functions by region.
    manual_li: list[dict] = []
    manual_ov: list[dict] = []
    for m in manual_funcs:
        off = m["file_offset_int"]
        if hdr_size <= off < img_size:
            manual_li.append(m)
        elif img_size <= off < img_size + len(overlay):
            manual_ov.append(m)
        else:
            print(
                f"WARN: manual func at 0x{off:06X} ({m.get('name','?')}) is outside "
                f"the executable's regions — ignoring",
                file=sys.stderr,
            )

    def _emit_one(
        region: bytes,
        region_label: str,
        region_file_offset: int,
        local_start: int,
        local_end: int,
        func_name: str,
        manual_md: dict | None,
    ) -> tuple[int, str]:
        file_off = region_file_offset + local_start
        out_path = disasm_dir / f"func_{fmt_hex_addr(file_off)}_{func_name}.asm"
        # Idempotent write: skip if file exists, unless --force was passed.
        if out_path.exists() and not force:
            # Count existing lines so the ledger stays accurate.
            existing = out_path.read_text(encoding="utf-8").splitlines()
            n_existing = sum(
                1 for line in existing
                if len(line) >= 8 and all(c in "0123456789ABCDEF" for c in line[:6]) and line[6:8] == "  "
            )
            return n_existing, str(out_path.relative_to(out_dir).as_posix())
        # In --force mode, harvest any non-UNKNOWN comments from the existing
        # file at this path AND from any sibling file with the same offset
        # but a different name (i.e. a rename). They get merged back in.
        preserved: dict[int, str] = load_existing_comments(out_path)
        prefix = f"func_{fmt_hex_addr(file_off)}_"
        for sibling in disasm_dir.glob(f"{prefix}*.asm"):
            if sibling == out_path:
                continue
            for k, v in load_existing_comments(sibling).items():
                preserved.setdefault(k, v)
        n = emit_function_asm(
            md=md,
            region=region,
            region_label=region_label,
            region_file_offset=region_file_offset,
            func_local_start=local_start,
            func_local_end=local_end,
            out_path=out_path,
            func_name=func_name,
            manual_metadata=manual_md,
            preserved_comments=preserved,
        )
        return n, str(out_path.relative_to(out_dir).as_posix())

    # Region 1: load image. File offset of byte 0 = hdr_size.
    auto_li_funcs = find_functions_in_region(load_image)
    # Combine manual + auto, with manual taking precedence on overlap.
    manual_li_ranges = [
        (m["file_offset_int"] - hdr_size,
         m["file_offset_int"] - hdr_size + m["size_int"], m)
        for m in manual_li
    ]
    # Drop auto entries that overlap a manual range.
    def _overlaps(a, b, ranges):
        for s, e, _ in ranges:
            if not (b <= s or a >= e):
                return True
        return False
    li_combined: list[tuple[int, int, dict | None]] = [
        (s, e, m) for s, e, m in manual_li_ranges
    ]
    li_combined.extend(
        (s, e, None)
        for s, e in auto_li_funcs
        if not _overlaps(s, e, manual_li_ranges)
    )
    li_combined.sort()

    for start, end, manual_md in li_combined:
        file_off = hdr_size + start
        name = manual_md["name"] if manual_md else "unknown"
        n, asm_rel = _emit_one(
            region=load_image,
            region_label="load_image",
            region_file_offset=hdr_size,
            local_start=start,
            local_end=end,
            func_name=name,
            manual_md=manual_md,
        )
        funcs_index.append({
            "file_offset": f"0x{fmt_hex_addr(file_off)}",
            "size": end - start,
            "instructions": n,
            "region": "load_image",
            "name": name,
            "asm_file": asm_rel,
            "status": "MANUAL" if manual_md else "RAW",
        })
        total_instr += n

    # Orphan bucket for the load image — covers everything not in li_combined.
    n_orphan_li = emit_orphans_asm(
        md=md,
        region=load_image,
        region_label="load_image",
        region_file_offset=hdr_size,
        covered=[(s, e) for s, e, _ in li_combined],
        out_path=disasm_dir / "orphans_load_image.asm",
    )
    total_instr += n_orphan_li

    # Region 2: overlay (if any).
    n_overlay_funcs = 0
    if overlay:
        auto_ov_funcs = find_functions_in_region(overlay)
        manual_ov_ranges = [
            (m["file_offset_int"] - img_size,
             m["file_offset_int"] - img_size + m["size_int"], m)
            for m in manual_ov
        ]
        ov_combined: list[tuple[int, int, dict | None]] = [
            (s, e, m) for s, e, m in manual_ov_ranges
        ]
        ov_combined.extend(
            (s, e, None)
            for s, e in auto_ov_funcs
            if not _overlaps(s, e, manual_ov_ranges)
        )
        ov_combined.sort()

        for start, end, manual_md in ov_combined:
            file_off = img_size + start
            name = manual_md["name"] if manual_md else "unknown"
            n, asm_rel = _emit_one(
                region=overlay,
                region_label="overlay",
                region_file_offset=img_size,
                local_start=start,
                local_end=end,
                func_name=name,
                manual_md=manual_md,
            )
            funcs_index.append({
                "file_offset": f"0x{fmt_hex_addr(file_off)}",
                "size": end - start,
                "instructions": n,
                "region": "overlay",
                "name": name,
                "asm_file": asm_rel,
                "status": "MANUAL" if manual_md else "RAW",
            })
            total_instr += n
            n_overlay_funcs += 1

        n_orphan_ov = emit_orphans_asm(
            md=md,
            region=overlay,
            region_label="overlay",
            region_file_offset=img_size,
            covered=[(s, e) for s, e, _ in ov_combined],
            out_path=disasm_dir / "orphans_overlay.asm",
        )
        total_instr += n_orphan_ov

    # Orphan cleanup: in --force mode, delete any func_*.asm under disasm/
    # that isn't in the current funcs_index. Without this, renaming a manual
    # function via manual_funcs.json would leave the old `func_<off>_unknown.asm`
    # behind, doubling its bytes in the ledger.
    if force:
        wanted = {Path(f["asm_file"]).name for f in funcs_index}
        for asm in disasm_dir.iterdir():
            if (
                asm.is_file()
                and asm.name.startswith("func_")
                and asm.suffix == ".asm"
                and asm.name not in wanted
            ):
                asm.unlink()

    summary = {
        "exe": exe_path.name,
        "file_size": len(file_bytes),
        "image_bytes": img_size,
        "header_bytes": hdr_size,
        "code_data_bytes": hdr.code_data_bytes,
        "overlay_bytes": len(overlay),
        "relocations": len(relocs),
        "load_image_functions": len(li_combined),
        "overlay_functions": n_overlay_funcs,
        "total_functions": len(funcs_index),
        "total_instructions": total_instr,
    }
    (out_dir / "functions.json").write_text(
        json.dumps({"summary": summary, "functions": funcs_index}, indent=2),
        encoding="utf-8",
    )
    return summary


def main() -> int:
    ap = argparse.ArgumentParser(description="Disassemble DOS MZ executables.")
    ap.add_argument(
        "--root",
        default=str(Path(__file__).resolve().parent.parent),
        help=" root",
    )
    ap.add_argument(
        "--exes",
        nargs="*",
        default=None,
        help="EXE filenames to disassemble (default: all in scope)",
    )
    ap.add_argument(
        "--force",
        action="store_true",
        help=(
            "Overwrite existing func_*.asm files. Default: skip files that "
            "already exist so Phase 2 annotations are preserved."
        ),
    )
    args = ap.parse_args()

    root = Path(args.root)
    raw = root / "raw" / "COLONIZE"
    code = root / "code"

    default_exes = [
        "VICEROY.EXE",
        "MAPEDIT.EXE",
        "OPENING.EXE",
        "CLOSING.EXE",
    ]
    targets = args.exes or default_exes

    results = []
    for name in targets:
        exe_path = raw / name
        if not exe_path.is_file():
            print(f"WARN: missing {exe_path}", file=sys.stderr)
            continue
        out_dir = code / Path(name).stem
        print(f"[disasm] {name} -> {out_dir.relative_to(root)}/")
        s = disassemble_exe(exe_path, out_dir, force=args.force)
        results.append(s)
        print(
            f"        funcs={s['total_functions']:5d} "
            f"insns={s['total_instructions']:7d} "
            f"img={s['image_bytes']:>7} ovl={s['overlay_bytes']:>7}"
        )

    return 0


if __name__ == "__main__":
    sys.exit(main())
