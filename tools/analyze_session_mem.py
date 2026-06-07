#!/usr/bin/env python3
"""
analyze_session_mem.py — Extract VICEROY runtime globals from
DOSBox memory snapshots in a session-NN/ directory.

Usage:
    python analyze_session_mem.py --session session-12

The session directory must contain:
  events.jsonl  — capture log
  frames/       — webp screenshots
  mem/          — zstd-compressed DOSBox process memory dumps
"""
from __future__ import annotations

import argparse
import json
import struct
import sys
from pathlib import Path

try:
    import zstandard as zstd
except ImportError:
    print("zstandard not installed: pip install zstandard", file=sys.stderr)
    sys.exit(1)

ROOT = Path(__file__).resolve().parents[1]


# Globals to read out of DGROUP at every snapshot.
# Tuples: (name, dgroup_offset, 'byte'|'word'|'dword')
GLOBALS = [
    ("g_174",          0x0174, "word"),
    ("g_176",          0x0176, "word"),
    ("dialog_state",   0x0186, "word"),
    ("char_w_byte",    0x1EA4, "byte"),
    ("char_h_byte",    0x1EA5, "byte"),
    ("font_w",         0xA5A4, "word"),
    ("font_h",         0xA5A6, "word"),
    ("scr_bound_h",    0x839E, "word"),  # screen height (verified runtime const)
    ("scr_bound_w",    0x83A0, "word"),  # screen width (verified runtime const)
    ("scr_bound_2",    0x83A2, "word"),
    ("scr_bound_3",    0x83A4, "word"),
    ("colony_ptr",     0x8542, "word"),
    ("active_power",   0x5398, "word"),
    ("rev_flags",      0x5382, "byte"),
]


def find_dgroup(data: bytes) -> int | None:
    """Locate VICEROY's runtime DGROUP base in a DOSBox memory dump.

    Anchor: the WOODPANL string sits at DS:0x2189. Multiple copies of
    the string may exist in the dump (one is the EXE-image const-data
    table, another is the live runtime DGROUP). The live copy is the
    one where DGROUP+0x839E starts with the screen bounds (200, 320).
    """
    start = 0
    while True:
        p = data.find(b"WOODPANL", start)
        if p < 0:
            return None
        cand = p - 0x2189
        if cand < 0:
            start = p + 1
            continue
        rect = struct.unpack_from("<HH", data, cand + 0x839E)
        if rect == (200, 320):
            return cand
        start = p + 1


def read_globals(data: bytes, dgroup: int) -> dict:
    out = {}
    for name, off, kind in GLOBALS:
        if kind == "byte":
            out[name] = data[dgroup + off]
        elif kind == "word":
            out[name] = struct.unpack_from("<H", data, dgroup + off)[0]
        elif kind == "dword":
            out[name] = struct.unpack_from("<I", data, dgroup + off)[0]
    return out


def read_colony_record(data: bytes, dgroup: int, colony_ptr: int) -> dict:
    """Read a 202-byte ColonyRecord at DGROUP+colony_ptr."""
    rec = data[dgroup + colony_ptr : dgroup + colony_ptr + 202]
    out = {
        "raw_hex_first_64": rec[:64].hex(),
        "byte_0x00": rec[0],
        "byte_0x01": rec[1],
        "byte_0x1A": rec[0x1A],          # owner_nation per disasm
        "word_0x90":  struct.unpack_from("<H", rec, 0x90)[0],
        "word_0x9A":  struct.unpack_from("<H", rec, 0x9A)[0],
        "word_0x22":  struct.unpack_from("<H", rec, 0x22)[0],
        "word_0xC6":  struct.unpack_from("<H", rec, 0xC6)[0],
    }
    return out


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--session", default="session-12",
                    help="Session directory under ")
    ap.add_argument("--include-colony-record", action="store_true")
    args = ap.parse_args()
    sess = ROOT / args.session
    if not sess.is_dir():
        print(f"ERROR: session dir not found: {sess}", file=sys.stderr)
        return 1
    mem_dir = sess / "mem"
    out_path = sess / "runtime_trace.json"

    trace = []
    n_ok = 0
    n_no_dgroup = 0
    for snap in sorted(mem_dir.glob("*.zst")):
        data = zstd.decompress(snap.read_bytes())
        dgroup = find_dgroup(data)
        if dgroup is None:
            n_no_dgroup += 1
            continue
        rec = {"mem": snap.name, "t": int(snap.stem), "dgroup": hex(dgroup)}
        rec.update(read_globals(data, dgroup))
        if args.include_colony_record and rec.get("colony_ptr"):
            rec["colony_record"] = read_colony_record(
                data, dgroup, rec["colony_ptr"])
        trace.append(rec)
        n_ok += 1

    out_path.write_text(json.dumps(trace, indent=2))
    print(f"[analyze_session_mem] {sess.name}:")
    print(f"  Snapshots scanned: {n_ok + n_no_dgroup}")
    print(f"  DGROUP located:    {n_ok}")
    print(f"  DGROUP not found:  {n_no_dgroup}")
    print(f"  Wrote {out_path}")

    # Summary
    print("\nGlobal variation:")
    for name, _, _ in GLOBALS:
        vals = [r[name] for r in trace]
        if not vals:
            continue
        distinct = set(vals)
        print(f"  {name:14s}  min={min(vals):7d}  max={max(vals):7d}  "
              f"distinct={len(distinct):3d}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
