#!/usr/bin/env python3
# parse_thunks.py
#
# Parses the RTLink overlay-thunk table inside VICEROY.EXE (and similar
# DOS binaries that use Pocket Soft RTLink Plus overlays). The thunk table
# is the bridge between load-image code and overlay code: each thunk is a
# tiny stub of the form
#
#     LCALL <runtime_addr>          ; 9A oo oo ss ss
#     LJMP  <overlay_seg:overlay_off>; EA oo oo ss ss
#     [optional 4 trailing bytes for "type A" thunks that pass extra metadata
#      to the runtime]
#
# When the load image far-calls a thunk, the LCALL invokes the RTLink
# runtime, which figures out which overlay segment contains the LJMP target,
# loads it (from disk / EMS / XMS) if needed, and patches the LJMP's
# segment word so it lands in the correct runtime address. On return, the
# LJMP fires and execution continues in overlay code.
#
# This tool walks the thunk table, classifies each entry, and emits a
# JSON + Markdown catalog of overlay entry points.

from __future__ import annotations

import argparse
import json
import struct
import sys
from collections import Counter, defaultdict
from pathlib import Path


# Defaults derived from the VICEROY.EXE analysis:
DEFAULT_TABLE_START = 0x1A5F0
# Two RTLink runtime entry points observed:
#   0x110D:0x0DAB — 14-byte "type A" thunk (with 4 trailing metadata bytes)
#   0x110D:0x0D91 — 10-byte "type B" thunk (no trailer)
RTLINK_ENTRY_A = (0x110D, 0x0DAB)
RTLINK_ENTRY_B = (0x110D, 0x0D91)


def parse_table(file_bytes: bytes, start: int, end_limit: int | None = None) -> tuple[list[dict], int]:
    """Walk thunks starting at `start`. Defensive parser:
      * Recognises a thunk start at any `9A` byte that's followed by
        a 4-byte LCALL operand, an `EA` byte, and a 4-byte LJMP operand.
      * Type-A (LCALL target = 0x110D:0x0DAB) thunks have a variable
        trailer. We probe for the NEXT thunk start (0x9A AB/91 0D 0D 11)
        starting at +10 and +12 and +14 bytes; whichever yields a valid
        next thunk determines the trailer length.
      * Type-B (LCALL target = 0x110D:0x0D91) thunks have no trailer
        (always 10 bytes).
      * If neither LCALL target is recognised, we still try to parse a
        10-byte stub but mark it as type "?".
      * The walk stops at the first byte that isn't a 0x9A or after
        end_limit.
    """
    n = end_limit if end_limit is not None else len(file_bytes)
    i = start
    thunks: list[dict] = []

    def _is_thunk_start(off: int) -> bool:
        if off + 10 > n:
            return False
        if file_bytes[off] != 0x9A or file_bytes[off + 5] != 0xEA:
            return False
        lc_off = struct.unpack("<H", file_bytes[off + 1 : off + 3])[0]
        lc_seg = struct.unpack("<H", file_bytes[off + 3 : off + 5])[0]
        return (lc_seg, lc_off) in (RTLINK_ENTRY_A, RTLINK_ENTRY_B)

    while i + 10 <= n:
        if not _is_thunk_start(i):
            break
        lcall_off = struct.unpack("<H", file_bytes[i + 1 : i + 3])[0]
        lcall_seg = struct.unpack("<H", file_bytes[i + 3 : i + 5])[0]
        ljmp_off = struct.unpack("<H", file_bytes[i + 6 : i + 8])[0]
        ljmp_seg = struct.unpack("<H", file_bytes[i + 8 : i + 10])[0]

        if (lcall_seg, lcall_off) == RTLINK_ENTRY_B:
            ttype = "B"
            size = 10
            trailing = b""
        else:
            # Type-A: trailer is variable; probe possible sizes.
            # Trailers observed include 4-byte (early thunks), 2-byte, and
            # 6-byte (some at table tail). Probe in increments of 2 from
            # 10 (no trailer) up to 20.
            ttype = "A"
            size = 14  # default for safety
            for candidate in (10, 12, 14, 16, 18, 20):
                if _is_thunk_start(i + candidate):
                    size = candidate
                    break
            else:
                # No subsequent thunk found at any probed size; this is
                # the last thunk in the table.
                size = 14
            trailing = file_bytes[i + 10 : i + size]

        t1 = struct.unpack("<H", trailing[0:2])[0] if len(trailing) >= 2 else None
        t2 = struct.unpack("<H", trailing[2:4])[0] if len(trailing) >= 4 else None
        thunks.append(
            {
                "thunk_offset": i,
                "size": size,
                "type": ttype,
                "lcall_seg": lcall_seg,
                "lcall_off": lcall_off,
                "ljmp_seg": ljmp_seg,
                "ljmp_off": ljmp_off,
                "trailer_word_1": t1,
                "trailer_word_2": t2,
                "trailer_hex": trailing.hex().upper(),
            }
        )
        i += size
    return thunks, i


def emit_md(out_path: Path, exe_name: str, table_start: int, end: int, thunks: list[dict]) -> None:
    by_segment: dict[int, list[dict]] = defaultdict(list)
    for t in thunks:
        by_segment[t["ljmp_seg"]].append(t)

    type_count = Counter(t["type"] for t in thunks)
    trailer_groups: Counter = Counter()
    for t in thunks:
        if t["type"] == "A":
            trailer_groups[t["trailer_hex"]] += 1

    lines: list[str] = []
    lines.append(f"# {exe_name} — Overlay-thunk catalogue")
    lines.append("")
    lines.append(
        "Every entry in the load-image-resident overlay-thunk table, sorted by "
        "thunk address. Each thunk is the load-image-side stub for one overlay-"
        "resident function: when the load-image code far-calls a thunk, the "
        "thunk's `LCALL` invokes the RTLink runtime, which loads the requested "
        "overlay segment if needed and patches the following `LJMP`'s segment "
        "word. Generated by `tools/parse_thunks.py`."
    )
    lines.append("")
    lines.append(f"- Table location: file 0x{table_start:06X}..0x{end:06X} ({end - table_start} bytes)")
    lines.append(f"- Total thunks: **{len(thunks)}**")
    lines.append(f"- Type breakdown: A (14-byte, with metadata): **{type_count.get('A', 0)}**, "
                 f"B (10-byte, no metadata): **{type_count.get('B', 0)}**")
    lines.append(f"- Distinct overlay segments referenced: **{len(by_segment)}**")
    lines.append("")
    lines.append("## RTLink runtime entry points")
    lines.append("")
    lines.append(
        "- `0x110D:0x0DAB` (file 0x01427B) — type-A loader (with metadata). "
        "Sets `cs:[0x39F1] = 0` before running the shared loader logic at 0x14293."
    )
    lines.append(
        "- `0x110D:0x0D91` (file 0x014261) — type-B loader (no metadata). "
        "Sets `cs:[0x39F1] = 0x52` before running the same shared loader logic. "
        "The 0x52 value flags 'no relocation patch needed' to the loader."
    )
    lines.append("")

    lines.append("## Type-A trailer-byte groupings")
    lines.append("")
    lines.append(
        "Type-A thunks carry 4 trailing metadata bytes between the LJMP and "
        "the next thunk. The byte pattern groups thunks into RTLink \"chains\" "
        "— thunks with identical trailers all participate in the same overlay-"
        "graph relationship. Distinct trailer values seen:"
    )
    lines.append("")
    lines.append("| Trailer hex | Count | Decoded LE16 pair |")
    lines.append("|-------------|------:|-------------------|")
    for trailer, n in trailer_groups.most_common():
        if len(trailer) == 8:
            t1 = int(trailer[0:2] + trailer[2:4], 16) if False else int.from_bytes(bytes.fromhex(trailer)[0:2], "little")
            t2 = int.from_bytes(bytes.fromhex(trailer)[2:4], "little")
            lines.append(f"| `{trailer}` | {n} | (0x{t1:04X}, 0x{t2:04X}) |")
        else:
            lines.append(f"| `{trailer}` | {n} | — |")
    lines.append("")

    lines.append("## Distinct overlay segments")
    lines.append("")
    lines.append("| Segment | Thunk count | Sample thunk offsets (within target segment) |")
    lines.append("|---------|------------:|-----------------------------------------------|")
    for seg in sorted(by_segment):
        offs = sorted({t["ljmp_off"] for t in by_segment[seg]})
        sample = ", ".join(f"0x{o:04X}" for o in offs[:6])
        if len(offs) > 6:
            sample += f", … (+{len(offs) - 6} more)"
        lines.append(f"| 0x{seg:04X} | {len(by_segment[seg])} | {sample} |")
    lines.append("")

    lines.append("## All thunks (sorted by file offset)")
    lines.append("")
    lines.append(
        "Each row is one overlay-resident entry point. The `target_id` "
        "column is a stable identifier `seg:off` for the overlay function — "
        "the runtime resolves this to the actual physical address at load "
        "time. Use this id when annotating overlay functions."
    )
    lines.append("")
    lines.append(
        "| Thunk file offset | Type | LJMP target (seg:off) | Trailer | Notes |"
    )
    lines.append(
        "|-------------------|------|------------------------|---------|-------|"
    )
    for t in thunks:
        seg = t["ljmp_seg"]
        off = t["ljmp_off"]
        trailer = t["trailer_hex"] or "—"
        notes = ""
        if t["thunk_offset"] == 0x1A5F0:
            notes = "called by `cstart` at 0xF7D8 — _main entry"
        lines.append(
            f"| 0x{t['thunk_offset']:06X} | {t['type']} "
            f"| 0x{seg:04X}:0x{off:04X} | `{trailer}` | {notes} |"
        )
    lines.append("")

    out_path.write_text("\n".join(lines), encoding="utf-8", newline="\n")


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--root", default=str(Path(__file__).resolve().parent.parent))
    ap.add_argument("--exe", default="VICEROY.EXE")
    ap.add_argument(
        "--table-start",
        type=lambda x: int(x, 0),
        default=DEFAULT_TABLE_START,
        help="File offset where the thunk table starts (default: 0x1A5F0 for VICEROY).",
    )
    args = ap.parse_args()

    root = Path(args.root)
    exe_path = root / "raw" / "COLONIZE" / args.exe
    out_dir = root / "code" / Path(args.exe).stem

    file_bytes = exe_path.read_bytes()
    thunks, end = parse_table(file_bytes, args.table_start)
    print(f"[parse_thunks] {args.exe}: {len(thunks)} thunks at 0x{args.table_start:06X}..0x{end:06X}")

    out_dir.mkdir(exist_ok=True)
    (out_dir / "overlay_thunks.json").write_text(
        json.dumps(
            {
                "table_start": args.table_start,
                "table_end": end,
                "thunks": thunks,
            },
            indent=2,
        ),
        encoding="utf-8",
    )
    emit_md(out_dir / "overlay_thunks.md", args.exe, args.table_start, end, thunks)
    print(f"            wrote overlay_thunks.json, overlay_thunks.md")
    return 0


if __name__ == "__main__":
    sys.exit(main())
