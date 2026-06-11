#!/usr/bin/env python3
"""
portlib.py -- shared query layer joining the binary inventories to the C tree.

The manual loop this kills (done by hand dozens of times per session):
  thunk seg:off -> file offset -> containing function -> "is it ported?
  what name? which file/line? what signature?"

Provides:
  Spans      -- functions.json span index (file offset -> function)
  PortIndex  -- every func_XXXXXX symbol in src/ + include/, classified
                definition / extern / mention, with signature text
  resolve_thunk(seg, off) -> (kind, target_file_offset, detail)
  dgroup_name(addr)       -> curated global name or None

All caches live under re_work/ (gitignored, regenerable). Committed inputs
contain names/addresses only -- never original bytes.
"""
import bisect
import glob
import json
import os
import re
import struct

HERE = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.normpath(os.path.join(HERE, "..", ".."))
RE_WORK = os.path.join(REPO, "re_work")
SRC = os.path.join(REPO, "viceroy_source", "src")
INC = os.path.join(REPO, "viceroy_source", "include")

EXE_PATH = os.environ.get("VICEROY_EXE", os.path.join(RE_WORK, "VICEROY.EXE"))
FUNCTIONS_JSON = os.path.join(RE_WORK, "functions.json")
SEGMAP_JSON = os.path.join(RE_WORK, "overlay_segmap.json")
DGROUP_NAMES = os.path.join(HERE, "dgroup_names.json")

HDR = 0x2400
LOADER_RESIDENT = 0x0D91
LOADER_OVERLAY = 0x0DAB
# two-anchor corrected overlay bases (see resolve_thunks.py header)
BASE_OVERRIDES = {21: 0x67080, 26: 0x73270}


# ---------------------------------------------------------------- functions
class Spans:
    def __init__(self, path=FUNCTIONS_JSON):
        data = json.load(open(path))
        rows = sorted((f["foff"], f["end"]) for f in data)
        self.starts = [r[0] for r in rows]
        self.rows = rows

    def at(self, foff):
        """(start, end) of the function containing foff, or None."""
        i = bisect.bisect_right(self.starts, foff) - 1
        if i < 0:
            return None
        s, e = self.rows[i]
        return (s, e) if s <= foff < e else None

    def all_at(self, foff):
        """ALL (start, end) spans containing foff, outermost (earliest) first.

        The boundary detector records false starts inside large functions
        (linear sweep past early-exit RETFs), so spans nest; callers that
        need the disasm file should try outermost first."""
        i = bisect.bisect_right(self.starts, foff) - 1
        hits = []
        while i >= 0:
            s, e = self.rows[i]
            if s <= foff < e:
                hits.append((s, e))
            # stop once starts are so far back they cannot contain foff
            # (no function exceeds 0x4000 bytes in this image except 04E2D6/05CA7E)
            if foff - s > 0x8000:
                break
            i -= 1
        return list(reversed(hits))

    @staticmethod
    def name(start):
        return f"func_{start:06X}"

    def disasm_path(self, start):
        return os.path.join(RE_WORK, "disasm", f"{self.name(start)}.asm")


# ---------------------------------------------------------------- port index
_DEF_RX = re.compile(r"^[A-Za-z_][\w \*]*\b(func_[0-9A-Fa-f]{4,6}\w*)\s*\(")
_EXT_RX = re.compile(r"^\s*extern\b[^;{]*?\b(func_[0-9A-Fa-f]{4,6}\w*)\s*\(")
_ANY_RX = re.compile(r"\b(func_[0-9A-Fa-f]{4,6})(\w*)\b")


class PortIndex:
    """name-stem (func_XXXXXX, upper hex) -> records of where it lives in C."""

    CACHE = os.path.join(RE_WORK, "portindex.json")

    def __init__(self, rebuild=False):
        if not rebuild and os.path.exists(self.CACHE):
            self.idx = json.load(open(self.CACHE))
            return
        self.idx = {}
        files = glob.glob(os.path.join(SRC, "**", "*.c"), recursive=True) + glob.glob(
            os.path.join(INC, "*.h")
        )
        for path in files:
            rel = os.path.relpath(path, REPO)
            for n, line in enumerate(open(path, errors="ignore"), 1):
                m = _ANY_RX.search(line)
                if not m:
                    continue
                stem = "func_" + m.group(1)[5:].upper().rjust(6, "0")
                kind = "mention"
                sig = None
                dm = _DEF_RX.match(line)
                em = _EXT_RX.match(line)
                if dm and not line.lstrip().startswith("extern"):
                    # col-0 prototypes end with ';' -- not a body
                    kind = "prototype" if line.rstrip().endswith(";") else "definition"
                    sig = line.strip()
                elif em:
                    kind, sig = "extern", line.strip()
                rec = {"kind": kind, "file": rel, "line": n,
                       "name": m.group(1) + m.group(2)}
                if sig:
                    rec["sig"] = sig
                self.idx.setdefault(stem, []).append(rec)
        os.makedirs(RE_WORK, exist_ok=True)
        json.dump(self.idx, open(self.CACHE, "w"))

    def lookup(self, foff_or_stem):
        stem = (
            foff_or_stem
            if isinstance(foff_or_stem, str)
            else f"func_{foff_or_stem:06X}"
        )
        recs = self.idx.get(stem, [])
        defs = [r for r in recs if r["kind"] == "definition"]
        exts = [r for r in recs if r["kind"] == "extern"]
        return {"stem": stem, "definitions": defs, "externs": exts,
                "mentions": len(recs) - len(defs) - len(exts)}


# ---------------------------------------------------------------- thunks
_segmap_cache = None


def _segmap():
    global _segmap_cache
    if _segmap_cache is None:
        raw = json.load(open(SEGMAP_JSON))
        _segmap_cache = {int(k): v["base"] for k, v in raw.items()}
        _segmap_cache.update(BASE_OVERRIDES)
    return _segmap_cache


def resolve_thunk(seg, off, exe_bytes=None):
    """(kind, target_file_offset_or_None, detail_str)."""
    if exe_bytes is None:
        exe_bytes = open(EXE_PATH, "rb").read()
    pos = HDR + seg * 16 + off
    rec = exe_bytes[pos : pos + 14]
    if len(rec) < 10 or rec[0] != 0x9A:
        # bare far jump record?
        if rec and rec[0] == 0xEA:
            o, s = struct.unpack_from("<HH", rec, 1)
            return "farjmp", HDR + s * 16 + o, f"{s:04X}:{o:04X}"
        return None, None, f"not a thunk record @0x{pos:05X}"
    loader = struct.unpack_from("<H", rec, 1)[0]
    if rec[5] != 0xEA:
        return None, None, f"no EA after loader @0x{pos:05X}"
    o, s = struct.unpack_from("<HH", rec, 6)
    if loader == LOADER_RESIDENT or s != 0:
        return "resident", HDR + s * 16 + o, f"{s:04X}:{o:04X}"
    page = struct.unpack_from("<H", rec, 10)[0]
    # RTLink Type-A "extra" trailer: a non-zero word after the page selects a
    # SUB-SEGMENT (directory decode pending in ovlresolve.py).  Resolving such
    # records as page+off is WRONG -- it once wired a unit timer-decay function
    # as the AI ship-explore leaf (ROUTE_B 1.2 soak catch).
    trailer = struct.unpack_from("<H", rec, 12)[0] if len(rec) >= 14 else 0
    if trailer != 0:
        return "subseg", None, f"page{page:02d}+0x{o:04X} SUBSEG 0x{trailer:X}"
    base = _segmap().get(page)
    if base is None:
        return "overlay", None, f"page {page} (no segmap base)"
    return "overlay", base + o, f"page{page:02d}+0x{o:04X}"


# ---------------------------------------------------------------- dgroup
_names_cache = None


def dgroup_name(addr):
    global _names_cache
    if _names_cache is None:
        _names_cache = (
            {int(k, 0): v for k, v in json.load(open(DGROUP_NAMES)).items()}
            if os.path.exists(DGROUP_NAMES)
            else {}
        )
    return _names_cache.get(addr)


def dgroup_names_all():
    dgroup_name(0)  # prime
    return dict(_names_cache)
