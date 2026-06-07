#!/usr/bin/env python3
"""
decode_overlay_pages.py -- Recover the RTLink/Plus overlay PAGE -> file-offset
map for VICEROY.EXE, and document the on-disk VP-directory blocker.

============================================================================
CONTEXT (byte-verified; see tools/resolve_thunks.py for the thunk decode)
============================================================================
VICEROY.EXE is an RTLink/Plus overlaid binary (signature "Internal error in
.RTLink(R)/Plus run-time code." at file 0x1A24A). Calls into overlay code go
through Type-A thunks in the thunk table 0x1A5F0..0x1D5E6. A Type-A thunk:

    9A AB 0D 0D 11      LCALL 110D:0DAB     ; RTLink type-A loader
    EA OO OO 00 00      JMPF  0000:OOOO     ; seg word is a 0x0000 PLACEHOLDER
    PP 00 [SS SS]       trailer: page_id (word), optional sub-index

The JMPF segment is ALWAYS 0x0000 for all 658 Type-A thunks (verified) -- it
is patched at run time by the RTLink loader. The trailer's FIRST word is the
overlay PAGE id, ranging 0x01..0x1F (31 pages, verified). The JMPF offset OOOO
is the entry offset WITHIN that page. So to turn a Type-A thunk into a file
offset we need: page_id -> page_file_base, then file = base + OOOO.

============================================================================
WHAT THIS SCRIPT RECOVERS  (page_file_base for each of the 31 pages)
============================================================================
The runtime VP directory that the loader consults is not a flat, statically
indexable (page->disk_offset,size) table (see BLOCKER below). So instead we
recover each page's file base *empirically and verifiably* by prologue-voting:

  For page P, every Type-A thunk gives a page-relative entry offset OOOO. The
  real entry at file (base+OOOO) must be a function prologue. We scan the whole
  overlay region (file 0x20670..EOF) for standard prologues
  [55 8B EC | C8 xx xx 00], then for each page choose the base B that maximises
  the count of {B + OOOO in prologues}. Pages are laid out sequentially in
  page_id order (the recovered bases are monotonically increasing), which we
  use as a sanity constraint and to derive per-page sizes (next_base - base).

Confidence = hits/total for the page. Pages with many thunks resolve at
80-100%; the misses are the ~11% of entries that are valid but non-standard
(leaf / __loadds / mid-function) -- the same class quantified in
tools/resolve_thunks.py. A handful of sparse pages (1-2 thunks, e.g. page
0x11) cannot be uniquely pinned and are flagged low_confidence.

Output: reverse_engineered/code/VICEROY/overlay_pages.json
    { "page_id": {file_offset, size_bytes_estimate, size_paragraphs_estimate,
                  anchor_hits, anchor_total, confidence}, ... }

============================================================================
BLOCKER: the on-disk VP directory field semantics are NOT byte-decoded
============================================================================
The overlay image begins at file 0x20665 (11 bytes of zero padding to the
paragraph boundary 0x20670). At 0x20670 there is an 8-word header:
    0x0458 0x0087 0x02BC 0x0000 0x020F 0x0000 0x0000 0x0000
followed by a run of u32 values (0x20680: 0x3941, 0x2991, 0x3330, ...). The
first overlay function prologues appear at file 0x2083C, 0x20918, 0x20F50 --
i.e. CODE is interleaved with per-segment relocation tables. Inspection of the
bytes immediately preceding each overlay prologue (e.g. before 0x20918:
"DC 3C 00 00  D7 3C 00 00  D2 3C 00 00 ..." -- u32s decreasing by 5) shows each
overlay segment carries its OWN fixup/relocation list right before its code.
This is the classic RTLink/Plus layout: the appended overlay is a sequence of
[per-segment reloc table][segment code] blocks, NOT one flat page directory.

The 31 u32 values at 0x20680 do NOT equal the recovered page file-paragraph
bases (verified: large nonzero deltas), so they are something else -- most
likely the runtime *memory* load paragraphs or fixup counts, resolved by the
loader's relocation walker. Assigning each header/table field a precise meaning
(disk seek vs paragraph size vs residency vs reloc-count) requires tracing the
RTLink relocation walker that runs several call-levels below the dispatcher at
file 0x164A2 (which itself only does call-site CLASSIFICATION: its sub-routines
at 0x167F2 / 0x16837 walk the *caller's* opcodes to determine near/far call
form). That trace -- or a dynamic capture -- is the remaining work. Per the
project's prime directive, this script does NOT fabricate a field layout for
that directory; it records exactly what is decoded (above) and recovers the
page bases by the independent, prologue-anchored method instead.
"""
from __future__ import annotations

import json
import struct
from collections import Counter, defaultdict
from pathlib import Path

HDR = 0x2400
OVERLAY_PAD_START = 0x20665   # 11 zero bytes of paragraph alignment
OVERLAY_START = 0x20670       # paragraph-aligned overlay image base
FILE_SIZE = 494910


def find_prologues(exe: bytes, lo: int, hi: int) -> set[int]:
    """Standard near-frame prologues: push bp;mov bp,sp  or  ENTER imm,0."""
    out: set[int] = set()
    for off in range(lo, hi - 4):
        b = exe[off:off + 4]
        if (b[0] == 0x55 and b[1] == 0x8B and b[2] == 0xEC) or (b[0] == 0xC8 and b[3] == 0x00):
            out.add(off)
    return out


def load_typeA_page_offsets(root: Path) -> dict[int, list[int]]:
    """page_id -> [entry offsets within page] from the parsed thunk table."""
    thunks = json.loads((root / "reverse_engineered" / "code" / "VICEROY"
                         / "overlay_thunks.json").read_text())["thunks"]
    pageoffs: dict[int, list[int]] = defaultdict(list)
    for t in thunks:
        if t["type"] == "A":
            pid = t.get("trailer_word_1")
            if pid is not None:
                pageoffs[pid].append(t["ljmp_off"])
    return pageoffs


def recover_page_bases(exe: bytes, prologues: set[int],
                       pageoffs: dict[int, list[int]]) -> dict[int, dict]:
    """Prologue-vote a file base per page, then enforce monotonic page order."""

    def score(offs, base):
        return sum(1 for o in offs if (base + o) in prologues)

    # candidate bases per page, ranked by anchor score
    cands: dict[int, list[tuple[int, int]]] = {}
    for pid in sorted(pageoffs):
        offs = sorted(set(pageoffs[pid]))
        votes: Counter = Counter()
        for p in prologues:
            for o in offs:
                cand = p - o
                if OVERLAY_START <= cand < len(exe):
                    votes[cand] += 1
        ranked = sorted(((score(offs, base), base) for base, _ in votes.most_common(20)),
                        reverse=True)
        cands[pid] = ranked or [(0, OVERLAY_START)]

    pages = sorted(cands)

    # First pass: best unconstrained base per page.
    best_uncon = {pid: cands[pid][0] for pid in pages}

    # Second pass: choose monotonic-increasing bases, but only let the
    # constraint override when the page is well-anchored AND a >=prev candidate
    # keeps a strong score. Otherwise keep the unconstrained best and flag it.
    result: dict[int, dict] = {}
    prev = OVERLAY_START
    for pid in pages:
        offs = sorted(set(pageoffs[pid]))
        total = len(offs)
        uscore, ubase = best_uncon[pid]
        # find best candidate that is >= prev
        mono = next(((s, b) for s, b in cands[pid] if b >= prev), None)
        if mono and mono[0] >= max(3, uscore - 1):
            chosen_score, chosen_base = mono
        else:
            chosen_score, chosen_base = uscore, ubase
        result[pid] = {
            "file_offset": chosen_base,
            "anchor_hits": chosen_score,
            "anchor_total": total,
        }
        prev = max(prev, chosen_base)

    # Derive size estimates from consecutive bases (monotonic pages only).
    ordered = sorted(result, key=lambda k: result[k]["file_offset"])
    for i, pid in enumerate(ordered):
        base = result[pid]["file_offset"]
        nxt = result[ordered[i + 1]]["file_offset"] if i + 1 < len(ordered) else len(exe)
        size = nxt - base
        result[pid]["size_bytes_estimate"] = size if size > 0 else None
        result[pid]["size_paragraphs_estimate"] = (size + 15) // 16 if size > 0 else None

    # Confidence label.
    for pid, r in result.items():
        tot = r["anchor_total"]
        hit = r["anchor_hits"]
        ratio = hit / tot if tot else 0.0
        if tot >= 8 and ratio >= 0.6:
            r["confidence"] = "high"
        elif tot >= 4 and ratio >= 0.5:
            r["confidence"] = "medium"
        else:
            r["confidence"] = "low"
        r["anchor_ratio"] = round(ratio, 3)
    return result


def main() -> int:
    root = Path(__file__).resolve().parent.parent
    exe = (root / "COLONIZE" / "VICEROY.EXE").read_bytes()
    assert len(exe) == FILE_SIZE

    prologues = find_prologues(exe, OVERLAY_START, len(exe))
    pageoffs = load_typeA_page_offsets(root)
    pages = recover_page_bases(exe, prologues, pageoffs)

    # header words (documented, not assigned semantics)
    hdr = struct.unpack("<8H", exe[OVERLAY_START:OVERLAY_START + 16])
    dir_u32 = [struct.unpack("<I", exe[OVERLAY_START + 16 + i * 4:
                                       OVERLAY_START + 16 + i * 4 + 4])[0]
               for i in range(31)]

    high = sum(1 for r in pages.values() if r["confidence"] == "high")
    med = sum(1 for r in pages.values() if r["confidence"] == "medium")
    low = sum(1 for r in pages.values() if r["confidence"] == "low")

    out = {
        "_doc": "RTLink/Plus overlay page -> file-offset map for VICEROY.EXE, "
                "recovered by prologue-anchored voting over Type-A thunk page "
                "offsets (NOT by decoding the on-disk VP directory; see _blocker).",
        "exe": "COLONIZE/VICEROY.EXE",
        "overlay_image_start": f"0x{OVERLAY_START:06X}",
        "overlay_pad_start": f"0x{OVERLAY_PAD_START:06X}",
        "page_count": len(pages),
        "method": "prologue_anchor_vote + monotonic_page_order",
        "confidence_summary": {"high": high, "medium": med, "low": low},
        "vp_directory_raw": {
            "_note": "On-disk header at 0x20670 (semantics NOT decoded; see _blocker). "
                     "8-word header then 31 u32 values. These u32s do NOT equal the "
                     "recovered page file paragraphs.",
            "header_words": [f"0x{w:04X}" for w in hdr],
            "u32_table_at_0x20680": [f"0x{v:08X}" for v in dir_u32],
        },
        "_blocker": {
            "decoded": [
                "Overlay image begins file 0x20670 (0x20665 + 11 pad bytes to paragraph).",
                "8-word header at 0x20670 = 0458 0087 02BC 0000 020F 0000 0000 0000.",
                "Layout is per-segment [reloc table][code] blocks, NOT a flat page "
                "directory: first code prologues at 0x2083C/0x20918/0x20F50, each "
                "preceded by a u32 fixup list (e.g. before 0x20918: DC3C,D73C,D23C... "
                "decreasing by 5).",
                "All 658 Type-A JMPF seg words are 0x0000 placeholders; page_id is the "
                "trailer's first word (range 0x01..0x1F = 31 pages).",
                "Each page's file base recovered here by prologue voting; bases are "
                "monotonically increasing in page_id order.",
            ],
            "missing": [
                "Field-by-field meaning of the 0x20670 header and 0x20680 u32 table "
                "(disk seek vs paragraph size vs residency vs reloc-count).",
                "The exact runtime arithmetic that maps page_id -> disk position, which "
                "lives in the RTLink relocation walker below the dispatcher at file "
                "0x164A2 (subs 0x167F2/0x16837 only classify the caller's call form).",
            ],
            "next_step": "Trace the relocation walker from 0x164A2's load path, or "
                         "capture a dynamic overlay load, to assign the directory "
                         "fields. Do NOT fabricate the field layout.",
        },
        "pages": {
            f"0x{pid:02X}": {
                "file_offset": f"0x{r['file_offset']:06X}",
                "size_bytes_estimate": (None if r["size_bytes_estimate"] is None
                                        else f"0x{r['size_bytes_estimate']:06X}"),
                "size_paragraphs_estimate": r["size_paragraphs_estimate"],
                "anchor_hits": r["anchor_hits"],
                "anchor_total": r["anchor_total"],
                "anchor_ratio": r["anchor_ratio"],
                "confidence": r["confidence"],
            }
            for pid, r in sorted(pages.items())
        },
    }

    out_path = root / "reverse_engineered" / "code" / "VICEROY" / "overlay_pages.json"
    out_path.write_text(json.dumps(out, indent=2), encoding="utf-8")

    print(f"[decode_overlay_pages] recovered {len(pages)} page bases "
          f"(high={high}, medium={med}, low={low})")
    print("  page  base       hits/total  conf")
    for pid in sorted(pages):
        r = pages[pid]
        print(f"   0x{pid:02X}  0x{r['file_offset']:06X}  "
              f"{r['anchor_hits']:2d}/{r['anchor_total']:2d}       {r['confidence']}")
    print(f"  wrote {out_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
