#!/usr/bin/env python3
"""RTLink thunk cross-reference for VICEROY.EXE.

Builds: target_file_offset -> [thunks that reach it], where each thunk is
addressable by a caller as `lcall <window_seg>:<off>`.

A thunk record at file offset F is invoked as `lcall W:off` where
    F = 0x2400 (codeOffset) + (W<<4) + off
The three overlapping windows are W in {0x181F, 0x191F, 0x1A1F}; each maps a
contiguous 0x1000-byte slice of the thunk table:
    0x181F -> file 0x1A5F0..0x1B5EF
    0x191F -> file 0x1B5F0..0x1C5EF
    0x1A1F -> file 0x1C5F0..0x1D5EF

Usage:
    python xref.py build              # write thunk_xref.json
    python xref.py callers 0x3C638    # find lcall byte-sigs reaching a target + grep callers
"""
import json, re, sys, glob, os
sys.path.insert(0, os.path.dirname(__file__))
from rtlink_decode import RTLinkImage

CODE_OFF = 0x2400
WINDOWS = [0x181F, 0x191F, 0x1A1F]
HERE = os.path.dirname(__file__)
EXE = os.path.join(HERE, "..", "..", "raw", "COLONIZE", "VICEROY.EXE")
RESEG = os.path.join(HERE, "..", "..", "code", "VICEROY", "disasm_overlay_reseg")


def load_image():
    data = open(EXE, "rb").read()
    img = RTLinkImage(data, EXE)
    img.parse_all()
    return img


def window_of(file_off):
    """Return (window_seg, off) for a thunk-table file offset, or None."""
    for w in WINDOWS:
        base = CODE_OFF + (w << 4)
        off = file_off - base
        if 0 <= off < 0x1000:
            return (w, off)
    return None


def lcall_bytes(w, off):
    """Byte signature of `lcall w:off` = 9a off_lo off_hi seg_lo seg_hi."""
    return bytes([0x9A, off & 0xFF, (off >> 8) & 0xFF, w & 0xFF, (w >> 8) & 0xFF])


def build_xref(img):
    """target_file_offset -> list of {file_offset, window, off, page_id}."""
    xref = {}
    for t in img.thunks:
        tgt = img.resolve_thunk(t)
        if tgt is None:
            continue
        wo = window_of(t.file_offset)
        if wo is None:
            continue
        w, off = wo
        xref.setdefault(tgt, []).append(
            {"thunk_file_offset": t.file_offset, "window": w, "off": off,
             "page_id": t.page_id}
        )
    return xref


def load_reseg_text():
    pages = {}
    for p in sorted(glob.glob(os.path.join(RESEG, "page_*.asm"))):
        pages[os.path.basename(p)] = open(p, encoding="utf-8", errors="replace").read()
    return pages


def enclosing_func(page_text, lineno):
    """Walk back to the nearest '; ---- func_XXXX' header above lineno."""
    fn = None
    for i, line in enumerate(page_text.splitlines()):
        if i > lineno:
            break
        m = re.match(r"; ---- (func_[0-9A-Fa-f]+)", line)
        if m:
            fn = m.group(1)
    return fn


def find_callers(img, target):
    xref = build_xref(img)
    entries = xref.get(target, [])
    data = img.data
    results = {"target": hex(target), "thunks": [], "callers": []}
    sigs = []
    for e in entries:
        sig = lcall_bytes(e["window"], e["off"])
        sigs.append((sig, e))
        results["thunks"].append(
            {**{k: (hex(v) if isinstance(v, int) else v) for k, v in e.items()},
             "lcall": f"0x{e['window']:04X}:0x{e['off']:04X}",
             "byte_sig": " ".join(f"{b:02x}" for b in sig)}
        )
    # scan the whole EXE image for each lcall signature -> caller file offsets
    for sig, e in sigs:
        start = 0
        while True:
            idx = data.find(sig, start)
            if idx < 0:
                break
            results["callers"].append(
                {"caller_file_offset": hex(idx),
                 "via": f"0x{e['window']:04X}:0x{e['off']:04X}"}
            )
            start = idx + 1
    return results


def main():
    if len(sys.argv) < 2:
        print(__doc__); return 1
    img = load_image()
    if sys.argv[1] == "build":
        xref = build_xref(img)
        out = {hex(k): v for k, v in xref.items()}
        p = os.path.join(HERE, "thunk_xref.json")
        json.dump(out, open(p, "w"), indent=1)
        print(f"thunks parsed = {len(img.thunks)}; distinct targets = {len(xref)}")
        print(f"written {p}")
    elif sys.argv[1] == "callers":
        target = int(sys.argv[2], 16)
        res = find_callers(img, target)
        print(json.dumps(res, indent=1))
    return 0


if __name__ == "__main__":
    sys.exit(main())
