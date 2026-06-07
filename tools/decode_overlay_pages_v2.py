#!/usr/bin/env python3
r"""decode_overlay_pages_v2.py -- DETERMINISTIC RTLink/Plus VP-directory decode
for VICEROY.EXE.  Supersedes the prologue-voting heuristic in
decode_overlay_pages.py: the on-disk overlay page directory (RTLink "segment
descriptor table") has now been located and its fields byte-decoded, so every
page's disk offset, paragraph size and residency are read straight out of the
binary -- no voting, no guessing.

============================================================================
HOW THE RTLink RUNTIME FINDS A PAGE ON DISK  (byte-traced, all FILE offsets)
============================================================================
A page fault flows:  Type-A thunk  -> rtlink_loader_A (0x1427B, =LCALL 110D:0DAB)
-> rtlink_loader_shared (0x14293) -> classifier (0x164A2) -> page-in path
(110D:1EBD = 0x1538D) -> seek+read (0x1567F / 0x16412).

The page-in path computes a *descriptor* and reads its disk position:

  loader_shared @0x14385:  LDS si, cs:[0x397D]      ; si = the thunk's saved CS:IP
                @0x1438A:  MOV ax,[si+5]            ; ax = thunk seg-selector word
                @0x14398:  AND ax,0x3FFF            ; mask flag bits
                @0x1439B:  DEC ax                   ; -> zero-based descriptor index
                @0x1439C:  SHL ax,1                 ; *2 paragraphs  (stride = 32 bytes)
                @0x1439E:  ADD ax, cs:[0x399B]      ; + descriptor-table base paragraph
                @0x143A3:  MOV es,ax                ; es -> the 32-byte descriptor
                @0x143A5:  TEST es:[0],0x8000 ...   ; residency / state flags

  seek routine @0x1567F:   MOV dx, es:[8]           ; disk file offset, LOW  word
                @0x15684:  MOV cx, es:[0xA]         ; disk file offset, HIGH word
                @0x1569C:  MOV ax,0x4200            ; LSEEK, whence=SEEK_SET
                @0x1569F:  INT 21h                  ; seek handle BX = cs:[0x3975]
  read  routine @0x16453:  MOV ah,0x3F / INT 21h    ; read page image into the window

  The file handle cs:[0x3975] is a DUP (INT 21h AH=45h @0x140EB) of handle 2 --
  i.e. RTLink pages directly out of the *already-open* program file, it never
  re-opens VICEROY.EXE for the resident-disk pages.

So a descriptor's disk position is simply  u32 at descriptor+8  (LE, [8]=low,
[0xA]=high), an ABSOLUTE byte offset into VICEROY.EXE.

============================================================================
THE DESCRIPTOR TABLE  (= the VP page directory)  -- byte-decoded
============================================================================
The table base segment cs:[0x399B] is set at init (system_init / 0x13F5C):
    MOV ax,[0x3999] ; ADD ax,4 ; MOV [0x399B],ax
[0x3999] is a LINK-TIME constant baked into the runtime data image; its value
is read at file 0x2400 + 0x110D*16 + 0x3999 = 0x16EB.  Hence the descriptor
table lives at image paragraph 0x16EB + 4 = 0x16EF, i.e. FILE 0x192F0.
(Self-check: descriptor[0].disk == 0x20670 == overlay image start.)

Each record is 32 bytes (stride confirmed by the SHL ax,1 = 2 paragraphs):
    +0x00  u16  flags / state  (0x0040 = "demand-load" bit on most code pages;
                                0x8000/0x20/0x40 are set at RUNTIME as the page
                                becomes resident/locked -- in the on-disk image
                                only 0x0000 or 0x0040 appear)
    +0x02  u16  (runtime link field; 0 on disk)
    +0x04  u16  size_paragraphs  (size of the page image on disk, in paragraphs)
    +0x06  u16  (runtime memory-segment field; 0 on disk)
    +0x08  u32  disk_file_offset  (ABSOLUTE byte offset into VICEROY.EXE)
    +0x0C  u16  (runtime / index; 0 on disk)
    +0x0E..0x1F  runtime LRU / linkage (0 on disk)

There are exactly 31 non-zero records (indices 0..30); record 31+ are all zero.
This matches the 31 overlay pages (page_id 0x01..0x1F).  The page_id -> record
mapping is  record_index = page_id - 1  (the loader's DEC ax above).  Verified:
all 16 high-confidence and all 6 medium-confidence prologue-voted page bases from
decode_overlay_pages.py fall inside record (page_id-1)'s [disk, disk+size*16)
extent; the 9 low-confidence votes are CORRECTED by the directory.

============================================================================
PER-PAGE LAYOUT  (each page image = [reloc header] [reloc table] [pad] [code])
============================================================================
The page disk image begins with an 8-word page header (same shape as the
overlay-image header at 0x20670 = page 1's header):
    +0x00 u16   (e.g. page 1 = 0x0458; per-page, meaning a 2nd fixup-list count)
    +0x02 u16   (e.g. page 1 = 0x0087)
    +0x04 u16   = 0x02BC CONSTANT across all 31 pages (RTLink format/version word)
    +0x06 u16   = 0x0000
    +0x08 u16 reloc_count   (e.g. page 1 = 0x020F = 527) -- count of u32 entries that follow
    +0x0A.. u16 = 0x0000 padding
Immediately after the 16-byte header is a u32 relocation table of `reloc_count`
entries.  Each entry is a BYTE offset (relative to the page image base) of a
FAR-pointer segment word to be fixed up at load.  Empirically (page 1): 483/527
point 3 bytes past a 0x9A (LCALL) opcode and 44/527 past a 0xEA (JMPF); the
segment words there are the link-time thunk/runtime segments 0x181F, 0x191F,
0x0D1D, 0x0C0C -- i.e. this is the RTLink overlay relocation list, NOT a second
page directory.  After the reloc table comes zero padding to a 16-byte boundary,
then the first overlay function (often an MSC `C8 imm16 00` ENTER prologue;
page 1 starts with `1E 68..` push-ds since it is the init/opening segment).

    code_start  =  round_up_16(disk + 16 + reloc_count*4) , then skip zero pad.
    (reloc_count is page-header word index 4 = byte offset +0x08.)

============================================================================
OUTPUT
============================================================================
Rewrites reverse_engineered/code/VICEROY/overlay_pages.json with, for each of
the 31 pages: {file_offset (= disk image base), code_offset (first instruction),
size_paragraphs, size_bytes, reloc_count, flags, residency, confidence:"high"}.
A prologue self-check is recorded per page (code_offset lands on
C8../55 8B EC, or is flagged non-standard for the handful of push-first pages).
"""
from __future__ import annotations

import json
import struct
from pathlib import Path

HDR = 0x2400               # MZ load-image header size (e_cparhdr*16 = 576*16)
RUNTIME_CS = 0x110D        # RTLink runtime code segment (from LCALL 110D:0DAB)
PTR_3999_OFF = 0x3999      # baked link-time word: overlay-manager segment
DESC_REC_SIZE = 32         # descriptor stride (SHL ax,1 = 2 paragraphs)
N_PAGES = 31               # page_id 0x01..0x1F
OVERLAY_START = 0x20670


def read_u16(b: bytes, off: int) -> int:
    return struct.unpack_from("<H", b, off)[0]


def read_u32(b: bytes, off: int) -> int:
    return struct.unpack_from("<I", b, off)[0]


def locate_descriptor_table(exe: bytes) -> int:
    """Return the FILE offset of the 32-byte descriptor table.

    base_para = [0x3999] (baked, image-relative) + 4 ; file = 0x2400 + base_para*16.
    """
    p3999 = read_u16(exe, HDR + RUNTIME_CS * 16 + PTR_3999_OFF)   # = 0x16EB
    desc_para = p3999 + 4                                          # = 0x16EF
    desc_file = HDR + desc_para * 16                               # = 0x192F0
    # self-check: record 0 must point at the overlay image start
    assert read_u32(exe, desc_file + 8) == OVERLAY_START, (
        f"descriptor[0].disk=0x{read_u32(exe, desc_file + 8):X} != overlay start "
        f"0x{OVERLAY_START:X}; descriptor-table location wrong")
    return desc_file


def code_start(exe: bytes, disk: int) -> tuple[int, int, str]:
    """(code_offset, reloc_count, prologue_note) from a page's on-disk header."""
    reloc_count = read_u16(exe, disk + 8)            # page header word index 4 (byte +0x08)
    after = disk + 16 + reloc_count * 4              # end of reloc table
    cs = (after + 15) & ~15                          # round up to paragraph
    while cs < len(exe) and exe[cs] == 0x00:         # skip zero alignment pad
        cs += 1
    b = exe[cs:cs + 5]
    if not b:
        note = "code-offset at/after EOF (page is reloc-only or all-pad)"
    elif len(b) >= 3 and b[0] == 0x55 and b[1] == 0x8B and b[2] == 0xEC:
        note = "push bp;mov bp,sp"
    elif len(b) >= 4 and b[0] == 0xC8 and b[3] == 0x00:
        note = f"ENTER 0x{read_u16(exe, cs + 1):04X},0"
    elif b[0] in (0x1E, 0x9A, 0xFA, 0x06, 0x60, 0x83, 0xA1, 0xC7, 0x8B, 0x2E,
                  0x26, 0xB8, 0x33, 0xFF, 0x53, 0x56, 0x57, 0x50, 0x8E):
        # valid leaf / __loadds / no-frame function start (no push-bp prologue);
        # the documented ~11% of non-standard-but-valid overlay entries.
        note = f"valid no-frame start (first byte 0x{b[0]:02X})"
    else:
        note = f"UNRECOGNISED first byte 0x{b[0]:02X}"
    return cs, reloc_count, note


def main() -> int:
    root = Path(__file__).resolve().parent.parent
    exe = (root / "COLONIZE" / "VICEROY.EXE").read_bytes()

    desc_file = locate_descriptor_table(exe)

    pages: dict[str, dict] = {}
    prev_disk = None
    for idx in range(N_PAGES):
        rec = desc_file + idx * DESC_REC_SIZE
        flags = read_u16(exe, rec + 0x00)
        size_para = read_u16(exe, rec + 0x04)
        disk = read_u32(exe, rec + 0x08)
        assert OVERLAY_START <= disk <= len(exe), f"rec {idx} disk 0x{disk:X} out of range"
        assert prev_disk is None or disk > prev_disk, "non-monotonic disk offsets"
        prev_disk = disk
        code_off, reloc_count, prologue = code_start(exe, disk)
        page_id = idx + 1
        # Descriptor +0x00 flag bits are READ by the loader (test es:[0],0x40 @0x145E1
        # /0x14D3A; test es:[0],0x8000 @0x143A5; test es:[0],1/6 in the page-in path).
        # On disk only 0x0000 or 0x0040 appear. Bit 0x40 gates the "+[si+7] size
        # adjustment" path at 0x145E1-0x145EA (a per-page trailing-fixup/size attribute);
        # 0x8000/0x20/etc. are set at RUNTIME as the page becomes resident. We report the
        # raw flag bit rather than over-naming the attribute.
        residency = "flag0x40_set" if (flags & 0x0040) else "flag0x40_clear"
        pages[f"0x{page_id:02X}"] = {
            "record_index": idx,
            "file_offset": f"0x{disk:06X}",          # disk image base (what the loader LSEEKs to)
            "code_offset": f"0x{code_off:06X}",       # first overlay instruction
            "size_paragraphs": size_para,
            "size_bytes": f"0x{size_para * 16:06X}",
            "reloc_count": reloc_count,
            "flags": f"0x{flags:04X}",
            "residency": residency,
            "prologue_at_code_offset": prologue,
            "confidence": "high",
        }

    out = {
        "_doc": "RTLink/Plus overlay PAGE -> disk directory for VICEROY.EXE, decoded "
                "DETERMINISTICALLY from the on-disk 32-byte segment-descriptor table "
                "(supersedes the prologue-vote heuristic). See "
                "tools/decode_overlay_pages_v2.py header for the full byte trace.",
        "exe": "COLONIZE/VICEROY.EXE",
        "method": "vp_segment_descriptor_table (byte-decoded)",
        "overlay_image_start": f"0x{OVERLAY_START:06X}",
        "descriptor_table": {
            "file_offset": f"0x{desc_file:06X}",
            "_derivation": "image_para = [DGROUP:0x3999]( =0x16EB ) + 4 = 0x16EF; "
                           "file = 0x2400 + 0x16EF*16 = 0x192F0 "
                           "(self-checked: record0.disk == 0x20670)",
            "record_size": DESC_REC_SIZE,
            "record_count_nonzero": N_PAGES,
            "fields": {
                "+0x00": "u16 flags; bit 0x40 read at 0x145E1/0x14D3A (gates +[si+7] size "
                         "adjust); bit 0x8000/0x1/0x6 set/tested at runtime as page becomes "
                         "resident. On disk: 0x0000 (14 pages) or 0x0040 (17 pages).",
                "+0x04": "u16 size_paragraphs (on-disk page image size, incl. reloc header)",
                "+0x08": "u32 disk_file_offset (absolute byte offset into VICEROY.EXE; LSEEK target)",
                "+0x0C..0x1F": "runtime memory-segment / LRU linkage (zero on disk)",
            },
            "page_id_to_record": "record_index = page_id - 1 (loader DEC ax @0x1439B)",
        },
        "runtime_trace": {
            "thunk_selector_read": "0x1438A MOV ax,[si+5]; 0x14398 AND ax,0x3FFF; "
                                   "0x1439B DEC ax; 0x1439C SHL ax,1; "
                                   "0x1439E ADD ax,cs:[0x399B]; 0x143A3 MOV es,ax",
            "lseek": "0x1567F MOV dx,es:[8]; 0x15684 MOV cx,es:[0xA]; "
                     "0x1569C MOV ax,0x4200; 0x1569F INT 21h",
            "read": "0x16453 MOV ah,0x3F; INT 21h (window via ES:DI)",
            "file_handle": "cs:[0x3975] = DUP of handle 2 (INT 21h AH=45h @0x140EB) "
                           "-- pages out of the already-open program file",
            "descriptor_table_base_init": "0x13F5C MOV ax,[0x3999]; ADD ax,4; MOV [0x399B],ax",
        },
        "per_page_layout": "[8-word page header][u32 reloc table x hdr[4]][zero pad to "
                           "16][overlay code]; code_offset = round16(disk+16+reloc_count*4) "
                           "then skip zero pad. The reloc table holds byte offsets of "
                           "far-call/JMPF segment words to fix up (segs 0x181F/0x191F/"
                           "0x0D1D/0x0C0C); NOT a nested page directory.",
        "page_count": N_PAGES,
        "pages": pages,
    }

    out_path = root / "reverse_engineered" / "code" / "VICEROY" / "overlay_pages.json"
    out_path.write_text(json.dumps(out, indent=2), encoding="utf-8")

    print(f"[decode_overlay_pages_v2] descriptor table @ 0x{desc_file:06X}; "
          f"{N_PAGES} pages, all high confidence.")
    print("  page  rec  disk       code       size_par  relocs  flags  prologue")
    for pid, r in pages.items():
        print(f"   {pid}  {r['record_index']:2d}  {r['file_offset']}  {r['code_offset']}  "
              f"{r['size_paragraphs']:5d}     {r['reloc_count']:5d}  {r['flags']}  "
              f"{r['prologue_at_code_offset']}")
    print(f"  wrote {out_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
