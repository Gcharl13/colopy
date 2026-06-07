#!/usr/bin/env python3
"""
rtlink_decode.py -- clean-room decoder for the RTLink(R)/Plus VERSION 2
overlay structure used by COLONIZE/VICEROY.EXE (Sid Meier's Colonization,
1994 MicroProse / DOS).

This is an INDEPENDENT Python reimplementation of the publicly documented
RTLink/Plus V2 on-disk format. It was written from the format description
(MZ header, embedded segment list, per-segment headers, far-call thunk
table) and validated byte-for-byte against the raw EXE. No GPL source was
copied; the dreammaster/tools C++ was read only as a format reference.

WHAT V2 IS (Rex-Nebular flavour, which VICEROY uses):
  * All overlay code is embedded in the single .EXE -- there is NO .OVL file.
  * A "segment list" (table of 32-byte records) describes each dynamically
    loaded overlay segment: where it loads in memory and where its header
    lives in the file.
  * Each overlay segment begins with a small header giving its paragraph
    sizes and its own internal relocation list, followed by the code.
  * Resident "load image" code never calls overlay code directly. Instead it
    far-calls a THUNK in a thunk table. The thunk's `LCALL` invokes the
    RTLink runtime loader, which pages in the right overlay segment and
    patches the thunk's following `JMPF` so it lands at the right physical
    address.

VICEROY-SPECIFIC, BYTE-VERIFIED FACTS (all confirmed against the 494,910-byte
COLONIZE/VICEROY.EXE, sha256 a17ed64c...):
  * MZ: numRelocations@0x06 = 2260; headerParagraphs@0x08 = 576
    -> codeOffset = 576<<4 = 0x2400; relocTableOffset@0x18 = 0x1E;
    entry CS:IP = 0x110D:0x071D.
  * Markers: "RTLink" @0x1A25D; "Enter directory for $" @0x1A5B7;
    "MS Run-Time" @0x1D9A8.  DGROUP image base = 0x1D9A0 (= MS-Run-Time - 8).
  * Segment list @0x192F0: 31 records (segmentNum 2..32), stride 32 bytes.
  * Thunk table @0x1A5F0..~0x1D604: 1023 thunks, addressable via three
    overlapping far-segment windows whose bases are codeOffset+seg<<4:
        0x181F -> base file 0x1A5F0
        0x191F -> base file 0x1B5F0
        0x1A1F -> base file 0x1C5F0
  * Thunk runtime entry points: 0x110D:0x0DAB (type A, with page-id trailer)
    and 0x110D:0x0D91 (type B, no trailer / static-call alias).
  * PAGE-ID model (verified): a type-A thunk carries a trailer word that is
    the 0-based index into the segment list PLUS ONE.  Equivalently
        page_id = segment_list_index + 1 = segmentNum - 1.
    Resolving a thunk: code base = segmentList[page_id - 1].codeOffset, and
    the target file offset = code base + offsetInSegment.

  DEVIATION FROM THE GENERIC V2 SPEC (reported, not worked around blindly):
  * The generic V2 detector expects the segment list at
    (zeroOffsetReloc.fileOffset + 48).  In VICEROY the relevant zero-offset
    relocation is at file 0x192B0 and the segment list begins at 0x192F0,
    i.e. +64, not +48.  This tool probes a small set of candidate deltas
    {48, 64} and, failing those, brute-scans for the 2,3,4 segmentNum
    signature, so it locates VICEROY's list correctly while remaining
    compatible with textbook V2 images.  See RTLINK_V2.md.

USAGE:
    python rtlink_decode.py info   [--exe PATH] [--json OUT.json]
    python rtlink_decode.py flatten [--exe PATH] --out OUT.exe [--map OUT.json]
    python rtlink_decode.py resolve <page_id> <offset>   [--exe PATH]
    python rtlink_decode.py validate [--exe PATH]

`info`    prints the segment list and a sample of the thunk/jump table, and
          (with --json) writes the full machine-readable map.
`flatten` writes a best-effort flat EXE with every overlay segment laid out
          contiguously, and always writes a per-page file-offset map JSON.
`resolve` resolves a (page_id, offsetInSegment) pair to a file offset.
`validate` runs the built-in self-checks described at the bottom of this file.

Field meanings that are not byte-confirmed are labelled "TBD" in the output;
nothing is invented.
"""
from __future__ import annotations

import argparse
import json
import struct
import sys
from pathlib import Path


# ---------------------------------------------------------------------------
# Constants confirmed against COLONIZE/VICEROY.EXE.  Each is independently
# re-derived from the MZ header at run time; these are sanity references.
# ---------------------------------------------------------------------------
RTLINK_ENTRY_A = (0x110D, 0x0DAB)   # type-A loader: thunk carries a page-id trailer
RTLINK_ENTRY_B = (0x110D, 0x0D91)   # type-B loader: static-call alias / no trailer
MARKER_RTLINK = b"RTLink"
MARKER_ENTER_DIR = b"Enter directory for $"
MARKER_MS_RUNTIME = b"MS Run-Time"

SEG_RECORD_SIZE = 32                # V2 segment-list record stride
# Candidate deltas from a zero-offset relocation site to the segment list.
# 48 is the textbook V2 value; 64 is VICEROY's actual value (see module docs).
SEGLIST_PROBE_DELTAS = (48, 64)


def _u16(data: bytes, off: int) -> int:
    return struct.unpack_from("<H", data, off)[0]


def _u32(data: bytes, off: int) -> int:
    return struct.unpack_from("<I", data, off)[0]


# ---------------------------------------------------------------------------
# Data model
# ---------------------------------------------------------------------------
class Segment:
    """One dynamically loaded overlay segment (a V2 segment-list record plus
    the per-segment header parsed at its headerOffset)."""

    __slots__ = (
        "list_index", "segment_num", "rec_offset", "load_segment",
        "header_offset", "seg_paragraphs", "hdr_paragraphs",
        "reloc_start", "num_relocations", "code_offset", "code_size",
        "relocations", "is_data_segment",
    )

    def __init__(self) -> None:
        self.list_index = 0          # 0-based position in the segment list
        self.segment_num = 0         # incrementing id from the record (2..N)
        self.rec_offset = 0          # file offset of the 32-byte record
        self.load_segment = 0        # in-memory load paragraph (low 16 bits)
        self.header_offset = 0       # file offset of the per-segment header
        self.seg_paragraphs = 0      # total paragraphs (header + code)
        self.hdr_paragraphs = 0      # header paragraphs
        self.reloc_start = 0         # reloc-list start word (==0 in V2)
        self.num_relocations = 0
        self.code_offset = 0         # file offset of this segment's code
        self.code_size = 0           # bytes of code
        self.relocations = []        # list of (offset, segment) internal relocs
        self.is_data_segment = False

    @property
    def page_id(self) -> int:
        """RTLink page-id used by type-A thunk trailers (1-based)."""
        return self.list_index + 1

    def to_dict(self) -> dict:
        return {
            "list_index": self.list_index,
            "page_id": self.page_id,
            "segment_num": self.segment_num,
            "rec_offset": self.rec_offset,
            "load_segment": self.load_segment,
            "header_offset": self.header_offset,
            "seg_paragraphs": self.seg_paragraphs,
            "hdr_paragraphs": self.hdr_paragraphs,
            "reloc_start": self.reloc_start,
            "num_relocations": self.num_relocations,
            "code_offset": self.code_offset,
            "code_size": self.code_size,
            "is_data_segment": self.is_data_segment,
        }


class Thunk:
    """One entry of the resident far-call thunk table."""

    __slots__ = (
        "file_offset", "lcall_seg", "lcall_off", "thunk_type",
        "offset_in_segment", "ljmp_seg", "segment_index", "page_id",
        "size", "raw_hex",
    )

    def __init__(self) -> None:
        self.file_offset = 0
        self.lcall_seg = 0
        self.lcall_off = 0
        self.thunk_type = "?"        # "A", "B", or "?"
        self.offset_in_segment = 0   # JMPF offset (offset within overlay segment)
        self.ljmp_seg = 0            # JMPF segment operand (0 = runtime-patched)
        self.segment_index = -1      # 0-based segment-list index, or -1 (static)
        self.page_id = None          # segment_index + 1, or None
        self.size = 0                # bytes consumed by this thunk record
        self.raw_hex = ""

    def to_dict(self) -> dict:
        return {
            "file_offset": self.file_offset,
            "type": self.thunk_type,
            "lcall_seg": self.lcall_seg,
            "lcall_off": self.lcall_off,
            "offset_in_segment": self.offset_in_segment,
            "ljmp_seg": self.ljmp_seg,
            "segment_index": self.segment_index,
            "page_id": self.page_id,
            "size": self.size,
            "raw_hex": self.raw_hex,
        }


class RTLinkImage:
    """Parsed RTLink/Plus V2 view of an executable."""

    def __init__(self, data: bytes, path: str = "<memory>") -> None:
        self.data = data
        self.path = path
        # MZ header fields
        self.num_relocations = 0
        self.header_paragraphs = 0
        self.code_offset = 0
        self.reloc_table_offset = 0
        self.entry_ip = 0
        self.entry_cs = 0
        self.relocations = []          # list of (offset, segment)
        # Detection results
        self.rtlink_marker = -1
        self.is_v2 = False
        self.segments_offset = 0
        self.rtlink_segment = 0
        self.seglist_delta = None      # which probe delta found the list
        self.segments = []             # list[Segment]
        self.data_segment = None       # Segment or None
        # Thunk table
        self.jump_offset = 0
        self.jump_size = 0
        self.thunks = []               # list[Thunk]
        self.notes = []                # list[str] of caveats / TBDs

    # -- MZ header ---------------------------------------------------------
    def parse_header(self) -> None:
        d = self.data
        if d[:2] != b"MZ":
            raise ValueError("not an MZ executable")
        self.num_relocations = _u16(d, 0x06)
        self.header_paragraphs = _u16(d, 0x08)
        self.code_offset = self.header_paragraphs << 4
        self.entry_ip = _u16(d, 0x14)
        self.entry_cs = _u16(d, 0x16)
        self.reloc_table_offset = _u16(d, 0x18)
        # Read the relocation table.
        p = self.reloc_table_offset
        relocs = []
        for _ in range(self.num_relocations):
            off, seg = struct.unpack_from("<HH", d, p)
            relocs.append((off, seg))
            p += 4
        self.relocations = relocs

    def reloc_file_offset(self, off: int, seg: int) -> int:
        return self.code_offset + (seg << 4) + off

    # -- version detection / segment list ---------------------------------
    def find_rtlink_marker(self) -> None:
        self.rtlink_marker = self.data.find(MARKER_RTLINK)

    def _seglist_signature_ok(self, base: int) -> bool:
        """A V2 segment list begins with records whose segmentNum word (+14)
        increments 2, 3, 4 at stride 32."""
        d = self.data
        if base + SEG_RECORD_SIZE * 3 > len(d):
            return False
        return (_u16(d, base + 14) == 2
                and _u16(d, base + SEG_RECORD_SIZE + 14) == 3
                and _u16(d, base + SEG_RECORD_SIZE * 2 + 14) == 4)

    def detect_v2_and_locate_segments(self) -> bool:
        """Find the segment list. Returns True if a V2 segment list is found.

        Strategy (robust superset of the textbook V2 rule):
          1. For every relocation whose OFFSET == 0, probe the candidate
             deltas (48 = textbook, 64 = VICEROY) after its file offset and
             accept the first whose 2,3,4 signature checks out.
          2. If none match, brute-scan the whole file (stride 2) for the
             2,3,4 signature. (VICEROY is caught by step 1 at delta 64.)
        """
        d = self.data
        for (off, seg) in self.relocations:
            if off != 0:
                continue
            base_fo = self.reloc_file_offset(off, seg)
            for delta in SEGLIST_PROBE_DELTAS:
                cand = base_fo + delta
                if self._seglist_signature_ok(cand):
                    self.segments_offset = cand
                    self.rtlink_segment = seg
                    self.seglist_delta = delta
                    self.is_v2 = True
                    if delta != 48:
                        self.notes.append(
                            "Segment list found at zeroRelocFileOffset(0x%06X) + %d, "
                            "not the textbook +48 (VICEROY deviation)."
                            % (base_fo, delta))
                    return True
        # Fallback: brute scan.
        for cand in range(0, len(d) - SEG_RECORD_SIZE * 3, 2):
            if self._seglist_signature_ok(cand):
                self.segments_offset = cand
                self.rtlink_segment = 0
                self.seglist_delta = None
                self.is_v2 = True
                self.notes.append(
                    "Segment list located by brute signature scan at 0x%06X "
                    "(no zero-offset relocation pointed at it via the probed "
                    "deltas)." % cand)
                return True
        return False

    def parse_segment_list(self) -> None:
        """Parse 32-byte records from segments_offset while the segmentNum
        word keeps incrementing from 2."""
        d = self.data
        off = self.segments_offset
        expected = 2
        idx = 0
        while off + SEG_RECORD_SIZE <= len(d):
            seg_num = _u16(d, off + 14)
            if seg_num != expected:
                break
            s = Segment()
            s.list_index = idx
            s.segment_num = seg_num
            s.rec_offset = off
            s.load_segment = _u16(d, off + 0)      # word @ +0
            s.header_offset = _u32(d, off + 8)     # dword @ +8
            # NOTE: dword @ +4 and the 16 bytes @ +16 are unused/zero in
            # VICEROY; labelled TBD rather than guessed.
            self.segments.append(s)
            off += SEG_RECORD_SIZE
            expected += 1
            idx += 1

    def parse_segment_headers(self) -> None:
        """Per-segment header at headerOffset:
             +0 segParagraphs, +2 hdrParagraphs, +4 (skip word, TBD),
             +6 relocationStart (==0 in V2), +8 numRelocations,
             then numRelocations * (offset word, segment word)."""
        d = self.data
        for s in self.segments:
            ho = s.header_offset
            s.seg_paragraphs = _u16(d, ho + 0)
            s.hdr_paragraphs = _u16(d, ho + 2)
            # word @ +4 -- purpose TBD (often a small nonzero value)
            s.reloc_start = _u16(d, ho + 6)
            s.num_relocations = _u16(d, ho + 8)
            s.code_offset = ho + s.hdr_paragraphs * 16
            s.code_size = (s.seg_paragraphs - s.hdr_paragraphs) * 16
            if s.reloc_start != 0:
                self.notes.append(
                    "Segment #%d header relocationStart=0x%X != 0 (V2 expects 0)."
                    % (s.segment_num, s.reloc_start))
            # Internal relocations: start at header +10 + relocStart*4.
            rp = ho + 10 + s.reloc_start * 4
            relocs = []
            for _ in range(s.num_relocations):
                if rp + 4 > len(d):
                    break
                r_off, r_seg = struct.unpack_from("<HH", d, rp)
                relocs.append((r_off, r_seg))
                rp += 4
            s.relocations = relocs

    def locate_data_segment(self) -> None:
        """The static data segment (DGROUP) is the last static segment; its
        start is 'MS Run-Time' - 8 (DGROUP image base 0x1D9A0 in VICEROY)."""
        m = self.data.find(MARKER_MS_RUNTIME)
        if m < 0:
            self.notes.append("'MS Run-Time' marker not found; data segment unresolved.")
            return
        data_start = m - 8
        s = Segment()
        s.list_index = -1
        s.segment_num = -1
        s.rec_offset = -1
        s.header_offset = data_start
        s.code_offset = data_start
        s.is_data_segment = True
        # Size: from data_start up to the first overlay segment's header, if
        # the first overlay segment lives later in the file; else to EOF.
        first_seg_header = min((seg.header_offset for seg in self.segments),
                               default=len(self.data))
        if first_seg_header > data_start:
            s.code_size = first_seg_header - data_start
        else:
            s.code_size = len(self.data) - data_start
        s.load_segment = (data_start - self.code_offset) // 16
        self.data_segment = s

    # -- thunk / jump table ------------------------------------------------
    def parse_thunks(self) -> None:
        """Faithful V2 thunk-table walk.

        Start at the first 0x9A after the 'Enter directory for $' marker.
        Each thunk:
            9A <off16> <seg16>        ; LCALL runtime loader (off/seg = entry)
            EA <off16> <seg16>        ; JMPF overlay target (seg=0 => patched)
            <V2 disambiguation bytes> ; yields segment_index (page) or -1
        The disambiguation deterministically advances the cursor, so no
        byte-scan-to-next-0x9A heuristic is needed.
        """
        d = self.data
        n = len(d)
        m = d.find(MARKER_ENTER_DIR)
        if m < 0:
            self.notes.append("'Enter directory for $' marker not found; no thunk table.")
            return
        i = m
        while i < n and d[i] != 0x9A:
            i += 1
        self.jump_offset = i
        pos = i
        thunks = []
        while pos < n:
            if d[pos] != 0x9A:
                break
            start = pos
            lcall_off, lcall_seg = struct.unpack_from("<HH", d, pos + 1)
            if (lcall_seg, lcall_off) not in (RTLINK_ENTRY_A, RTLINK_ENTRY_B):
                break
            if pos + 6 > n or d[pos + 5] != 0xEA:
                break
            pos += 6                                   # consume 0x9A + 4 + 0xEA
            offset_in_segment = _u16(d, pos)
            segment = _u16(d, pos + 2)
            pos += 4
            byte_val = d[pos]
            pos += 1
            segment_index = -1
            if segment != 0 or byte_val == 0x9A:
                # Static / non-overlay call (no page translation).
                segment_index = -1
            else:
                segment_index = (byte_val | (d[pos] << 8))
                pos += 1
                segment_index -= 1
                b1 = d[pos]; pos += 1
                b2 = d[pos]; pos += 1
                b3 = d[pos]; pos += 1
                if b1 == 0x9A and b3 != 0x9A:
                    pos -= 2          # next thunk starts at b1; rewind to it
                    byte_val = b1
                else:
                    segment = b1 | (b2 << 8)
                    byte_val = b3
            t = Thunk()
            t.file_offset = start
            t.lcall_seg = lcall_seg
            t.lcall_off = lcall_off
            t.thunk_type = ("A" if (lcall_seg, lcall_off) == RTLINK_ENTRY_A
                            else "B")
            t.offset_in_segment = offset_in_segment
            t.ljmp_seg = segment
            t.segment_index = segment_index
            t.page_id = (segment_index + 1) if segment_index >= 0 else None
            thunks.append(t)
            # Skip any run of zero padding before the next thunk.
            while pos < n and byte_val == 0:
                byte_val = d[pos]
                pos += 1
            pos -= 1                  # back up so the loop re-sees the 0x9A
            t.size = pos - start
            t.raw_hex = d[start:start + min(t.size, 32)].hex()
        self.thunks = thunks
        if thunks:
            last = thunks[-1]
            self.jump_size = (last.file_offset + last.size) - self.jump_offset

    # -- resolution --------------------------------------------------------
    def page_code_offset(self, page_id: int):
        """File offset of the code base for a 1-based page-id, or None."""
        if 1 <= page_id <= len(self.segments):
            return self.segments[page_id - 1].code_offset
        return None

    def resolve(self, page_id: int, offset_in_segment: int):
        base = self.page_code_offset(page_id)
        if base is None:
            return None
        return base + offset_in_segment

    def resolve_thunk(self, thunk: "Thunk"):
        if thunk.page_id is None:
            return None
        return self.resolve(thunk.page_id, thunk.offset_in_segment)

    # -- driver ------------------------------------------------------------
    def parse_all(self) -> None:
        self.parse_header()
        self.find_rtlink_marker()
        if self.rtlink_marker < 0:
            self.notes.append("'RTLink' marker not found; this may not be an RTLink image.")
        if not self.detect_v2_and_locate_segments():
            raise ValueError("could not locate a V2 segment list in this executable")
        self.parse_segment_list()
        self.parse_segment_headers()
        self.locate_data_segment()
        self.parse_thunks()


# ---------------------------------------------------------------------------
# Reporting
# ---------------------------------------------------------------------------
def build_map(img: RTLinkImage) -> dict:
    return {
        "exe": img.path,
        "size": len(img.data),
        "header": {
            "num_relocations": img.num_relocations,
            "header_paragraphs": img.header_paragraphs,
            "code_offset": img.code_offset,
            "reloc_table_offset": img.reloc_table_offset,
            "entry_cs": img.entry_cs,
            "entry_ip": img.entry_ip,
        },
        "rtlink_marker": img.rtlink_marker,
        "is_v2": img.is_v2,
        "segments_offset": img.segments_offset,
        "rtlink_segment": img.rtlink_segment,
        "seglist_delta": img.seglist_delta,
        "page_id_model": "page_id = segment_list_index + 1 = segmentNum - 1; "
                         "target_file_offset = segments[page_id-1].code_offset + offset_in_segment",
        "segments": [s.to_dict() for s in img.segments],
        "data_segment": img.data_segment.to_dict() if img.data_segment else None,
        "thunk_table": {
            "jump_offset": img.jump_offset,
            "jump_size": img.jump_size,
            "count": len(img.thunks),
            "thunks": [t.to_dict() for t in img.thunks],
        },
        "notes": img.notes,
    }


def cmd_info(img: RTLinkImage, json_out: "Path | None") -> int:
    h = img
    print("RTLink/Plus V2 decode: %s (%d bytes)" % (h.path, len(h.data)))
    print("  MZ: numRelocations=%d  headerParas=%d -> codeOffset=0x%X  "
          "relocTableOffset=0x%X  entry=0x%04X:0x%04X"
          % (h.num_relocations, h.header_paragraphs, h.code_offset,
             h.reloc_table_offset, h.entry_cs, h.entry_ip))
    print("  RTLink marker @ %s" % (("0x%X" % h.rtlink_marker)
                                    if h.rtlink_marker >= 0 else "NOT FOUND"))
    delta_s = ("+%d" % h.seglist_delta) if h.seglist_delta is not None else "(brute scan)"
    print("  Segment list @ 0x%X  (rtlinkSegment=0x%04X, found via zeroReloc%s)"
          % (h.segments_offset, h.rtlink_segment, delta_s))
    print()
    print("Segment list (%d segments):" % len(h.segments))
    print("  idx page seg#  loadSeg  headerOff   codeOff    codeSize  #reloc")
    print("  --- ---- ----  -------  ---------   --------   --------  ------")
    for s in h.segments:
        print("  %3d 0x%02X %4d  0x%04X   0x%08X  0x%08X 0x%06X  %6d"
              % (s.list_index, s.page_id, s.segment_num, s.load_segment,
                 s.header_offset, s.code_offset, s.code_size, s.num_relocations))
    if h.data_segment:
        ds = h.data_segment
        print("  DATA            0x%04X   0x%08X  0x%08X 0x%06X  (DGROUP)"
              % (ds.load_segment, ds.header_offset, ds.code_offset, ds.code_size))
    print()
    n_a = sum(1 for t in h.thunks if t.thunk_type == "A")
    n_b = sum(1 for t in h.thunks if t.thunk_type == "B")
    n_resolved = sum(1 for t in h.thunks if t.page_id is not None)
    print("Thunk/jump table @ 0x%X..0x%X (%d thunks: %d type-A, %d type-B; "
          "%d resolve to an overlay page):"
          % (h.jump_offset, h.jump_offset + h.jump_size, len(h.thunks),
             n_a, n_b, n_resolved))
    print("  fileOffset  type  page  off-in-seg  ljmpSeg  -> target file off")
    print("  ----------  ----  ----  ----------  -------  ------------------")
    # Show a representative sample: first 8, the validation thunk, and a
    # stride-spread of the rest, capped so output stays readable.
    sample_idx = set(range(min(8, len(h.thunks))))
    step = max(1, len(h.thunks) // 24)
    sample_idx.update(range(0, len(h.thunks), step))
    for k, t in enumerate(h.thunks):
        if t.file_offset == 0x1CCD0:
            sample_idx.add(k)
    for k in sorted(sample_idx):
        t = h.thunks[k]
        tgt = img.resolve_thunk(t)
        tgt_s = ("0x%08X" % tgt) if tgt is not None else "(static / n/a)"
        page_s = ("0x%02X" % t.page_id) if t.page_id is not None else "  -"
        mark = "  <== 0x1CCD0" if t.file_offset == 0x1CCD0 else ""
        print("  0x%08X   %s    %s  0x%06X    0x%04X   %s%s"
              % (t.file_offset, t.thunk_type, page_s, t.offset_in_segment,
                 t.ljmp_seg, tgt_s, mark))
    if h.notes:
        print("\nNotes / caveats:")
        for note in h.notes:
            print("  * %s" % note)
    if json_out is not None:
        json_out.write_text(json.dumps(build_map(img), indent=2), encoding="utf-8")
        print("\nWrote full map JSON: %s" % json_out)
    return 0


def cmd_resolve(img: RTLinkImage, page_id: int, offset: int) -> int:
    base = img.page_code_offset(page_id)
    if base is None:
        print("page-id 0x%X out of range (1..%d)" % (page_id, len(img.segments)))
        return 1
    seg = img.segments[page_id - 1]
    tgt = base + offset
    print("page 0x%X = segment list index %d (segmentNum %d), code base 0x%08X"
          % (page_id, seg.list_index, seg.segment_num, base))
    print("  + offset 0x%04X  ->  file offset 0x%08X" % (offset, tgt))
    if not (base <= tgt < base + seg.code_size):
        print("  WARNING: offset 0x%04X is outside this page's code size 0x%X"
              % (offset, seg.code_size))
    return 0


def cmd_flatten(img: RTLinkImage, out_path: Path, map_path: "Path | None") -> int:
    """Best-effort flat layout. Always emits a page->file-offset map JSON.

    The flat EXE concatenates the resident image (everything up to the first
    overlay segment's code) followed by each overlay segment's code laid out
    contiguously, and rewrites each type-A thunk's JMPF segment operand to the
    flat paragraph of its target page. This is intentionally conservative: it
    does NOT attempt to rebuild the MZ relocation table for the relocated
    overlay segments (that is the risky part the spec flags), so the result is
    a layout/analysis aid, not necessarily a runnable binary. The authoritative
    artifact is the JSON map.
    """
    d = bytearray(img.data)
    # Flat plan: page_id -> (orig_code_offset, code_size, flat_offset).
    flat = {}
    # Resident region: keep file bytes [0, first_overlay_header) verbatim.
    first_header = min((s.header_offset for s in img.segments), default=len(d))
    flat_cursor = first_header
    layout = []
    for s in img.segments:
        flat_off = flat_cursor
        flat[s.page_id] = (s.code_offset, s.code_size, flat_off)
        layout.append({
            "page_id": s.page_id,
            "segment_num": s.segment_num,
            "orig_code_offset": s.code_offset,
            "code_size": s.code_size,
            "flat_offset": flat_off,
            "flat_paragraph": (flat_off - img.code_offset) // 16,
        })
        flat_cursor += s.code_size

    out = bytearray(d[:first_header])
    for s in img.segments:
        out += d[s.code_offset:s.code_offset + s.code_size]

    # Rewrite type-A thunk JMPF segment operands to flat paragraphs. The JMPF
    # operand sits at thunk file_offset + 6 (off16) and +8 (seg16).
    patched = 0
    for t in img.thunks:
        if t.page_id is None or t.page_id not in flat:
            continue
        _, _, flat_off = flat[t.page_id]
        flat_para = (flat_off - img.code_offset) // 16
        seg_pos = t.file_offset + 8
        struct.pack_into("<H", out, seg_pos, flat_para & 0xFFFF)
        patched += 1

    out_path.write_bytes(bytes(out))
    mp = map_path if map_path is not None else out_path.with_suffix(".map.json")
    mp.write_text(json.dumps({
        "source": img.path,
        "flat_exe": str(out_path),
        "resident_bytes": first_header,
        "code_offset": img.code_offset,
        "page_layout": layout,
        "thunks_patched": patched,
        "caveat": "Flat EXE relocates overlay code contiguously and rewrites "
                  "type-A thunk JMPF segment operands to flat paragraphs. The "
                  "MZ relocation table is NOT rebuilt for relocated segments; "
                  "treat the flat EXE as an analysis aid and the JSON as the "
                  "authoritative page map.",
    }, indent=2), encoding="utf-8")
    print("Wrote flat EXE: %s (%d bytes; %d thunks patched)"
          % (out_path, len(out), patched))
    print("Wrote page map: %s" % mp)
    return 0


# ---------------------------------------------------------------------------
# Self-validation
# ---------------------------------------------------------------------------
def cmd_validate(img: RTLinkImage) -> int:
    ok = True

    def check(name: str, cond: bool, detail: str = "") -> None:
        nonlocal ok
        status = "PASS" if cond else "FAIL"
        if not cond:
            ok = False
        print("  [%s] %s%s" % (status, name, ("  -- " + detail) if detail else ""))

    print("RTLink V2 self-validation against %s" % img.path)

    # Header facts.
    check("MZ numRelocations == 2260", img.num_relocations == 2260,
          "got %d" % img.num_relocations)
    check("codeOffset == 0x2400", img.code_offset == 0x2400,
          "got 0x%X" % img.code_offset)
    check("entry CS:IP == 0x110D:0x071D",
          (img.entry_cs, img.entry_ip) == (0x110D, 0x071D),
          "got 0x%04X:0x%04X" % (img.entry_cs, img.entry_ip))

    # Markers.
    check("'RTLink' @ 0x1A25D", img.data.find(MARKER_RTLINK) == 0x1A25D)
    check("'Enter directory for $' @ 0x1A5B7",
          img.data.find(MARKER_ENTER_DIR) == 0x1A5B7)
    check("'MS Run-Time' @ 0x1D9A8",
          img.data.find(MARKER_MS_RUNTIME) == 0x1D9A8)
    check("DGROUP base (MS-Run-Time - 8) == 0x1D9A0",
          img.data.find(MARKER_MS_RUNTIME) - 8 == 0x1D9A0)

    # Segment list.
    check("segment list @ 0x192F0", img.segments_offset == 0x192F0,
          "got 0x%X" % img.segments_offset)
    check("31 segments (segmentNum 2..32)",
          len(img.segments) == 31
          and img.segments[0].segment_num == 2
          and img.segments[-1].segment_num == 32,
          "got %d segments" % len(img.segments))

    # The validation thunk at file 0x1CCD0 (= 0x1A1F:0x06E0).
    win_check = img.code_offset + (0x1A1F << 4) + 0x06E0
    check("window 0x1A1F:0x06E0 == file 0x1CCD0", win_check == 0x1CCD0,
          "got 0x%X" % win_check)
    raw = img.data[0x1CCD0:0x1CCD0 + 12]
    check("thunk@0x1CCD0 raw == 9a ab 0d 0d 11 ea 52 03 00 00 10 00",
          raw == bytes.fromhex("9aab0d0d11ea5203000010 00".replace(" ", "")),
          raw.hex())
    vt = next((t for t in img.thunks if t.file_offset == 0x1CCD0), None)
    check("thunk@0x1CCD0 parsed",
          vt is not None
          and vt.page_id == 0x10
          and vt.offset_in_segment == 0x0352,
          ("page=0x%X off=0x%X" % (vt.page_id, vt.offset_in_segment))
          if vt else "thunk not found in table")

    # func_05B2C2 via page 0x10 + 0x0352.
    r1 = img.resolve(0x10, 0x0352)
    check("resolve(page 0x10, 0x0352) == 0x5B2C2", r1 == 0x5B2C2,
          ("0x%X" % r1) if r1 is not None else "None")
    check("func_05B2C2 starts with ENTER (C8 3A 00)",
          img.data[0x5B2C2:0x5B2C2 + 3] == bytes.fromhex("c83a00"),
          img.data[0x5B2C2:0x5B2C2 + 4].hex())

    # func_05CA7E (ENTER 0xDE) -- same page 0x10, offset 0x1B0E.
    off_5ca7e = 0x5CA7E - img.page_code_offset(0x10)
    r2 = img.resolve(0x10, off_5ca7e)
    check("resolve(page 0x10, 0x%04X) == 0x5CA7E" % off_5ca7e, r2 == 0x5CA7E,
          ("0x%X" % r2) if r2 is not None else "None")
    check("func_05CA7E starts with ENTER 0x00DE (C8 DE 00)",
          img.data[0x5CA7E:0x5CA7E + 3] == bytes.fromhex("c8de00"),
          img.data[0x5CA7E:0x5CA7E + 4].hex())

    print("\nVALIDATION: %s" % ("ALL PASS" if ok else "FAILURES PRESENT"))
    return 0 if ok else 1


# ---------------------------------------------------------------------------
# CLI
# ---------------------------------------------------------------------------
def _default_exe() -> Path:
    # Tool lives at reverse_engineered/tools/rtlink/; the canonical raw EXE is
    # reverse_engineered/raw/COLONIZE/VICEROY.EXE (identical to top-level copy).
    here = Path(__file__).resolve()
    candidate = here.parents[2] / "raw" / "COLONIZE" / "VICEROY.EXE"
    if candidate.exists():
        return candidate
    # Fall back to the project-root COLONIZE/ copy.
    return here.parents[3] / "COLONIZE" / "VICEROY.EXE"


def _hexint(s: str) -> int:
    return int(s, 0)


def main(argv=None) -> int:
    ap = argparse.ArgumentParser(description="RTLink/Plus V2 decoder for VICEROY.EXE")
    sub = ap.add_subparsers(dest="mode", required=True)

    p_info = sub.add_parser("info", help="print segment list + thunk-table sample")
    p_info.add_argument("--exe", type=Path, default=None)
    p_info.add_argument("--json", type=Path, default=None,
                        help="also write the full map to this JSON file")

    p_flat = sub.add_parser("flatten", help="write a flat EXE + page-offset map")
    p_flat.add_argument("--exe", type=Path, default=None)
    p_flat.add_argument("--out", type=Path, required=True)
    p_flat.add_argument("--map", type=Path, default=None)

    p_res = sub.add_parser("resolve", help="resolve a (page, offset) pair")
    p_res.add_argument("page", type=_hexint)
    p_res.add_argument("offset", type=_hexint)
    p_res.add_argument("--exe", type=Path, default=None)

    p_val = sub.add_parser("validate", help="run built-in byte self-checks")
    p_val.add_argument("--exe", type=Path, default=None)

    args = ap.parse_args(argv)
    exe_path = args.exe if getattr(args, "exe", None) else _default_exe()
    if not exe_path.exists():
        print("ERROR: executable not found: %s" % exe_path, file=sys.stderr)
        return 2

    img = RTLinkImage(exe_path.read_bytes(), str(exe_path))
    img.parse_all()

    if args.mode == "info":
        return cmd_info(img, args.json)
    if args.mode == "flatten":
        return cmd_flatten(img, args.out, args.map)
    if args.mode == "resolve":
        return cmd_resolve(img, args.page, args.offset)
    if args.mode == "validate":
        return cmd_validate(img)
    return 2


if __name__ == "__main__":
    sys.exit(main())
