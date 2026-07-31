## 1. Executables and overlay architecture

The shipped game directory contains six DOS MZ executables. One of them — VICEROY.EXE, the game proper — carries essentially all of the game logic, packed into an RTLink Plus (Pocket Soft) version-2 overlay image appended to a small resident load image. The other programs are satellites: a map editor, an intro player, an endgame player, and two installer utilities. This section maps the executable set, then dissects VICEROY's overlay machinery in enough detail to resolve any far call in the binary to a file offset.

### 1.1 The executable inventory

All six are plain 16-bit real-mode MZ executables (no NE/PE extended header). Values measured from the shipped files:

| EXE | File bytes | Image | Header | Code+Data | Overlay | Entry CS:IP | Relocs |
|-------------|-------:|-------:|-------:|----------:|---------:|-----------|-------:|
| VICEROY.EXE | 494,910 | 132,709 | 9,216 | 123,493 | 362,201 | 110D:071D | 2,260 |
| MAPEDIT.EXE | 145,292 | 114,185 | 5,632 | 108,553 | 31,107 | 1388:001E | 1,365 |
| OPENING.EXE | 89,178 | 67,271 | 3,072 | 64,199 | 21,907 | 0452:015C | 664 |
| CLOSING.EXE | 83,246 | 62,769 | 2,560 | 60,209 | 20,477 | 037D:0150 | 595 |
| MPSCOPY.EXE | 38,620 | 4,986 | 512 | 4,474 | 33,634 | 0000:0031 | 0 |
| INSTALL.EXE | 51,285 | 51,285 | 32 | 51,253 | 0 | 0C35:000E | 0 |

Five of the six carry a post-image overlay region. A byte-pattern survey (counts of `55 8B EC` prologues, `C8` ENTER prologues, `9A` far calls, `CD 21` DOS calls) shows that **only VICEROY's overlay contains loadable code** — 8,507 LCALL instructions and 1,323 ENTER prologues. The MAPEDIT/OPENING/CLOSING overlay regions are linker *debug data* (symbol tables and source-file directories), not executed code. VICEROY.EXE is 73% overlay by bytes; that is where the bulk of the game lives. The build stack is Microsoft C 6.0 medium model (confirmed by byte-pattern match of `__aFlmul`/`__aFldiv` and the canonical MSC 6.0 `rand()` LCG constants 0x000343FD / 0x00269EC3) over the MicroProse MADS asset engine and the RTLink Plus overlay runtime.

### 1.2 VICEROY.EXE — MZ header and file geography

| Field | Value | Note |
|-------|-------|------|
| signature | `MZ` | |
| relocation count (+0x06) | 2,260 | 4-byte (off,seg) entries |
| header paragraphs (+0x08) | 576 | code base = 576×16 = file 0x2400 |
| entry IP (+0x14) | 0x071D | |
| entry CS (+0x16) | 0x110D | runtime/load-image entry segment |
| reloc table offset (+0x18) | 0x1E | |

File 0x2400 is paragraph 0 of the load image; all segment arithmetic below is relative to it. Landmark strings inside the image:

| Marker | File offset | Meaning |
|--------|------------|---------|
| `RTLink` | 0x1A25D | identifies the RTLink-linked image |
| `Enter directory for $` | 0x1A5B7 | immediately precedes the thunk table |
| `MS Run-Time` | 0x1D9A8 | start of the static data segment − 8 |

**DGROUP (the static data segment) begins at file 0x1D9A0** and spans 0x2CD0 bytes of initialised data (its overlay-directory record gives load paragraph 0x1B5A). Every static datum at DGROUP offset `D` therefore lives at file `0x1D9A0 + D` — the rule used throughout this manual to byte-read strings and initialised tables (e.g. the string `"ORDERS"` at DGROUP 0x225D = file 0x1FBFD). At run time the loaded DGROUP segment is not a static constant; in an instrumented session (1994 binary under DOSBox) it was found at **segment 0x1CFD** (physical 0x1CFD0) by anchoring on the contiguous section-name table `UNIT\0ORDERS\0ACTIONS\0` which sits at DGROUP offset 0x2258. DGROUP offsets are preserved from the file image, so any static `DGROUP:0xNNNN` citation is readable live at `phys(DGROUP_base) + 0xNNNN`.

Gross file layout:

| Region | File range | Contents |
|--------|-----------|----------|
| MZ header + relocs | 0x0..0x2400 | header, 2,260 relocation entries |
| Load image (resident) | 0x2400..0x20665 | C runtime, RTLink loader, glyph/blit/message cores, resident helpers |
| — overlay segment list | 0x192F0 | 31 × 32-byte records (§1.3) |
| — thunk table | 0x1A5F0..~0x1D610 | 1,023 far-call stubs (§1.4) |
| — DGROUP image | 0x1D9A0..0x20670 | initialised data + strings |
| Overlay region | 0x20670..end | 31 demand-paged code segments (§1.3) |

### 1.3 RTLink Plus version 2 — overlay pages

VICEROY uses the "embedded overlay" flavour of RTLink Plus version 2: overlay segments are appended inside the EXE itself (no separate .OVL file) and demand-loaded by a resident runtime. The **segment list** at file 0x192F0 is a table of 32-byte records, one per overlay segment, with `segmentNum` incrementing 2..32 (31 records):

```c
typedef struct {              // one segment-list record @0x192F0 + 32*i
    uint16_t load_segment;    // +0x00 in-memory load paragraph (0x0000 or 0x0040)
    // +0x02..+0x07 unmapped (6 bytes; dword at +0x04 zero in this binary)
    uint32_t header_offset;   // +0x08 file offset of the segment's own header
    // +0x0C..+0x0D unmapped (2 bytes)
    uint16_t segment_num;     // +0x0E incrementing id 2,3,4,... (not an index)
    // +0x10..+0x1F unmapped (16 bytes, zero)
} RTLinkSegmentRecord;
```

(Location quirk: the generic V2 layout puts this list 48 bytes after the zero-offset relocation entry; in VICEROY that relocation is at file 0x192B0 and the list starts +64, with 16 zero bytes between.)

Each `header_offset` points at a per-segment header, followed by that segment's internal relocations, followed by the code:

```c
typedef struct {              // per-segment header, at header_offset
    uint16_t seg_paragraphs;  // +0x00 total paragraphs (header + code)
    uint16_t hdr_paragraphs;  // +0x02 header paragraphs
    // +0x04..+0x05 unmapped (2 bytes, small value)
    uint16_t reloc_start;     // +0x06 == 0 in V2
    uint16_t num_relocs;      // +0x08 count of internal fixups
    // followed by num_relocs × { uint16_t off; uint16_t seg; }
} RTLinkSegmentHeader;
// code_offset = header_offset + hdr_paragraphs*16
// code_size   = (seg_paragraphs - hdr_paragraphs)*16
```

The **page-id model** resolves overlay calls: `page_id = segment_num − 1`, and a code target is `code_offset(page) + (ljmp_seg << 4) + offset_in_segment` (the `ljmp_seg` term is the segment word retained in the thunk — zero for 506 of the 658 type-A thunks; nonzero for 152, e.g. page 0x1A's second sub-segment `ljmp_seg 0x11E` giving base 0x72090 + 0x11E0 = 0x73270). The complete page map, byte-verified against the EXE:

| Page | HeaderOff | CodeOff | CodeSize | Relocs | LoadSeg |
|:----:|---------:|--------:|---------:|------:|:------:|
| 0x01 | 0x20670 | 0x20EE0 | 0x3D10 | 527 | 0x0000 |
| 0x02 | 0x24BF0 | 0x25900 | 0x7200 | 826 | 0x0000 |
| 0x03 | 0x2CB00 | 0x2CFD0 | 0x2B20 | 296 | 0x0040 |
| 0x04 | 0x2FAF0 | 0x30550 | 0x6440 | 652 | 0x0040 |
| 0x05 | 0x36990 | 0x37340 | 0x4040 | 608 | 0x0040 |
| 0x06 | 0x3B380 | 0x3B900 | 0x3160 | 340 | 0x0040 |
| 0x07 | 0x3EA60 | 0x3ECF0 | 0x1400 | 152 | 0x0040 |
| 0x08 | 0x400F0 | 0x404B0 | 0x2420 | 228 | 0x0040 |
| 0x09 | 0x428D0 | 0x42C50 | 0x17B0 | 214 | 0x0000 |
| 0x0A | 0x44400 | 0x44540 | 0x16E0 | 70 | 0x0000 |
| 0x0B | 0x45C20 | 0x45D00 | 0x0900 | 43 | 0x0000 |
| 0x0C | 0x46600 | 0x46DE0 | 0x4C70 | 492 | 0x0000 |
| 0x0D | 0x4BA50 | 0x4C1F0 | 0x7350 | 477 | 0x0000 |
| 0x0E | 0x53540 | 0x53820 | 0x2A90 | 171 | 0x0000 |
| 0x0F | 0x562B0 | 0x56A10 | 0x3F40 | 461 | 0x0040 |
| 0x10 | 0x5A950 | 0x5AF70 | 0x37D0 | 382 | 0x0000 |
| 0x11 | 0x5E740 | 0x5E9B0 | 0x1120 | 145 | 0x0000 |
| 0x12 | 0x5FAD0 | 0x5FE60 | 0x1E40 | 218 | 0x0040 |
| 0x13 | 0x61CA0 | 0x61E10 | 0x15D0 | 79 | 0x0000 |
| 0x14 | 0x633E0 | 0x63880 | 0x2E00 | 285 | 0x0040 |
| 0x15 | 0x66680 | 0x66850 | 0x2130 | 105 | 0x0040 |
| 0x16 | 0x68980 | 0x68EE0 | 0x2C20 | 332 | 0x0040 |
| 0x17 | 0x6BB00 | 0x6BE50 | 0x3A00 | 201 | 0x0000 |
| 0x18 | 0x6F850 | 0x6F8E0 | 0x0260 | 24 | 0x0000 |
| 0x19 | 0x6FB40 | 0x6FDF0 | 0x16A0 | 162 | 0x0040 |
| 0x1A | 0x71490 | 0x72090 | 0x4340 | 757 | 0x0040 |
| 0x1B | 0x763D0 | 0x764D0 | 0x08A0 | 51 | 0x0040 |
| 0x1C | 0x76D70 | 0x76E50 | 0x0A30 | 43 | 0x0040 |
| 0x1D | 0x77880 | 0x77990 | 0x0470 | 58 | 0x0000 |
| 0x1E | 0x77E00 | 0x77ED0 | 0x06D0 | 42 | 0x0040 |
| 0x1F | 0x785A0 | 0x78640 | 0x0700 | 30 | 0x0040 |

Total overlay code ≈ 0x52CA0 bytes across 31 segments. `load_segment` takes only two values (0x0000 / 0x0040): segments sharing a value alias the same physical memory window and are paged in on demand — which is exactly why the load image cannot far-call overlay code directly and must go through the thunk table.

### 1.4 The thunk table and the stub-segment windows

The resident far-call **thunk table** begins at file 0x1A5F0 (the first `0x9A` byte after the `Enter directory for $` marker) and holds **1,023 thunks: 658 type-A and 365 type-B**, at variable record sizes (10/12/14 bytes, a few longer at the tail).

**Type A** (overlay call — this is the record the runtime patches at load time):

```
9A AB 0D 0D 11      LCALL 0x110D:0x0DAB   ; overlay-loader entry ("with page-id")
EA <off16> <seg16>  JMPF  target          ; seg16 = 0 on disk — PATCHED at load
<page16>            trailer word = page_id (= segment_num − 1)
```

**Type B** (`LCALL 0x110D:0x0D91` then a fixed JMPF): the target is already resident — the JMP-FAR lands back in the load image. Most helper calls that look like overlay calls are type B and decode statically (e.g. `LCALL 0x181F:0x04D4` → file 0xC322 `random_int`, `0x181F:0x035C` → 0x48CC `clamp`, `0x181F:0x07B4` → 0xBC10 `power_attribute_bit`).

The two loader entries live at file 0x1427B (type-A entry, sets `cs:[0x39F1]=0`) and 0x14261 (type-B entry, sets `cs:[0x39F1]=0x52`); they share a body at file 0x14293 which saves registers, calls the segment-lookup helper at file 0x164A2 (which walks six storage-class sub-helpers at 0x164FE/0x164E8/0x16564/0x16516/0x16837/0x167F2), and then either returns (segment already resident), **rewrites the thunk's JMPF segment word in place** (at `[si−4]`, si = saved return IP − 5), or faults the segment in from disk first. Because the patch happens at load time, the live JMPF targets do not exist in the static file — they must be derived through the page model of §1.3.

Load-image code reaches the table through **three overlapping stub-segment windows**, whose file bases are `0x2400 + (seg << 4)`:

| Window segment | File base of window |
|---------------|--------------------|
| 0x181F | 0x1A5F0 |
| 0x191F | 0x1B5F0 |
| 0x1A1F | 0x1C5F0 |

So for any disassembled `LCALL seg:off` with seg ∈ {0x181F, 0x191F, 0x1A1F}: `thunk_file_offset = 0x2400 + (seg << 4) + off`. The windows are 0x1000 paragraphs apart, so every thunk is reachable from at least one window. Worked validation: `LCALL 0x1A1F:0x06E0` → thunk at file 0x1CCD0 = `9A AB0D 0D11  EA 5203 0000  1000` → page 0x10, offset 0x0352 → code base 0x5AF70 + 0x352 = **file 0x5B2C2** (`func_05B2C2`, which duly opens with `C8 3A 00 00` = `ENTER 0x3A`). Under the general formula 578 of the 658 type-A thunks land on clean ENTER/PUSH-BP prologues; the remainder are legitimate mid-function tail-call entries.

### 1.5 COLONIZE.EXE — the flat companion build

Alongside the shipped set, the project's byte record preserves **COLONIZE.EXE** (455,137 bytes, described as the launcher/front-end build; it is *not* one of the six executables in the shipped game directory, whose batch file `COLONIZE.BAT` launches VICEROY.EXE). Its structure is the mirror image of VICEROY's: image size equals file size — **no overlay at all** — with 36,864 header bytes, **9,199 relocations** and 1,244 discovered functions, all resident. Code that in VICEROY is overlay-resident (for instance the F2–F9 advisor-report painters) is directly addressable in COLONIZE.EXE, which makes it a useful decompilation cross-check; conversely, several early offsets circulated for VICEROY features (e.g. a "king-audience painter at 0x249B1") turned out to be COLONIZE.EXE offsets — and that one is merely a filename builder, not a screen painter. All offsets in this manual index VICEROY.EXE unless explicitly stated otherwise.

### 1.6 OPENING.EXE and CLOSING.EXE — separate cinematic programs

The opening credits/cinematic and the endgame cinematic are **separate programs**, not VICEROY code. Both are MZ executables built with the same MSC 6.0 runtime (four C-runtime helpers byte-matched in each) and the same MADS asset engine; both carry an appended RTLink debug-data region (21,907 / 20,477 bytes) that contains **no executable code**. Their playback is data-driven from shipped text files: OPENING.TXT (1,479 bytes; lines of `start_frame, end_frame, series, sprite`), CLOSING.TXT (762 bytes; lines of `Series, Frame, Repeats, BaseX, Delay`, driving the CLOS-FWK/BEL/HAT/LDY/MAN/MIL/BKG.SS sheets), PATH.DAT (6,459 bytes of plain-ASCII `x, y` per-frame ship trajectory for the opening voyage) and AMERICA.MOV (572 bytes of movie metadata).

### 1.7 MAPEDIT.EXE — standalone editor with shipped debug symbols

MAPEDIT.EXE (145,292 bytes) is a **standalone program** sharing the MADS engine and the game's assets (viceroy.pal, TERRAIN.SS, PHYS0.SS, ICONS.SS, WOODTILE.SS, FONTINTR, FONTTINY, CURSOR.SS). Uniquely among the six, it **ships with CodeView NB02 debug information**: its overlay region opens with a directory of 33 named records — 13 top-level `.obj` segment records (popup.obj, menu.obj, text.obj, stuff.obj, map_2/5/6/9/a.obj, write.obj, vicemisc.obj, terrain.obj, me_mini.obj) and 19 `.c`/`.asm` source records — in this record format:

```c
typedef struct {              // NB02 directory record (MAPEDIT overlay)
    uint8_t  sep0;            // +0x00 = 0x00
    uint8_t  magic;           // +0x01 = 0x01
    uint8_t  sep1;            // +0x02 = 0x00
    uint8_t  name_len;        // +0x03
    // name_len bytes of name ("popup.obj", "fileio_8.c", ...)
    uint16_t linker_seg_para; // linker segment paragraph (sequential 0x06D7..0x0BA3)
    uint16_t flags;           // 0..0x0E
    uint16_t size_bytes;
    uint16_t reserved;        // always 0
    uint16_t type_marker;     // 0 = top-level .obj, 1 = sub-source
} NB02Record;
```

The mined symbol table yields **1,071 named symbols**, so the editor's functions are cited in this manual by their true linker names (`_write_map_file`, `_load_map_file`, `_forest_fix`, …). A symbol at `seg:off` lives at file offset `seg·16 + off + 0x1600` (0x1600 being unaccounted header slack below MAPEDIT's 5,632-byte MZ header region). The editor's own behaviour — startup, menus, and the .MP writer that is the ground truth for §3 — is fully symbol-resolved.

## 2. Asset containers and file formats

Every graphical asset in the game — sprite sheets (.SS), full-screen backgrounds (.PIK) and bitmap fonts (.FF) — is wrapped in the same MicroProse **MADSPACK 2.0** container, with sections individually compressed by the **FAB** LZ codec. The decoders described here are ports of the in-EXE library routines (byte-verified `madspack_load` / `fab_decompress`), and their decisive correctness test is that every compressed section expands to exactly its directory-declared size across all shipped files. Sound is handled differently: the "driver" is itself a loadable DOS executable selected by a filename template.

### 2.1 The MADSPACK 2.0 container

```c
typedef struct {              // container header
    char     magic[14];       // +0x00 "MADSPACK 2.0\x1A\x00" (loader checks first 8 bytes)
    uint16_t section_count;   // +0x0E
    // +0x10: section_count × 10-byte directory entries
    // 0xB0:  section data — FIXED start = 0x10 + 0xA0 reserved block,
    //        sections concatenated in directory order by packed size
} MadspackHeader;

typedef struct {              // directory entry (10 bytes)
    uint8_t  flag;            // +0x00 0 = stored raw, 1 = FAB-compressed
    uint8_t  mode;            // +0x01 observed 4 (NOT a codec selector; flag decides)
    uint32_t unpacked_len;    // +0x02
    uint32_t packed_len;      // +0x06
} MadspackDirEntry;
```

The fixed 0xB0 data start (a 160-byte reserved block follows the directory) is load-bearing: reading section data at `16 + 10·N` instead silently mis-frames every section.

**FAB compression** is an LZ77 bitstream with the magic `"FAB"` + a shift byte (10–13; observed 12 throughout), then a 16-bit LSB-first bit reservoir primed from bytes 4–5. Decoding: a `1` bit emits one literal byte from the byte stream; `0` then `0` is a short back-reference (2 more bits → copy length 2–5; 1-byte offset, biased −256); `0` then `1` is a long back-reference (2 bytes carrying an offset split by the shift value and a length field, where length 0 escapes to an extension byte: 0 = end of stream, 1 = bitstream realign, else length = byte+1). FAB encoding is non-deterministic at the bit level, so a re-encoded file decodes identically without byte-matching the original. The in-game loader chain is byte-verified: archive open + magic check at 0x76F26 inside `func_076E50`, buffered chunked section transfer via `func_0775EC` (chunks clamped to 0xF000), with the per-section decode transform dispatched through a callback vtable.

### 2.2 .SS sprite sheets

A typical .SS has 4 sections: **(0)** a sheet header, **(1)** the frame-descriptor table, **(2)** a 768-byte palette (256 × 6-bit RGB triples), **(3)** RLE pixel data.

```c
typedef struct {              // section 0 — sheet header (0x98 = 152 bytes)
    // +0x00..+0x25 unmapped (38 bytes)
    uint16_t frame_count;     // +0x26 number of 16-byte descriptors in section 1
    // +0x28..+0x97 unmapped (112 bytes)
} SSSheetHeader;

typedef struct {              // section 1 — one descriptor per disk sprite (16 bytes)
    uint32_t pixel_offset;    // +0x00 offset of this frame's RLE stream in section 3
    uint32_t pixel_size;      // +0x04 RLE byte count
    int16_t  anchor_x;        // +0x08 anchor = CENTRE-x   (screen x = ax - floor(w/2))
    int16_t  anchor_y;        // +0x0A anchor = BOTTOM-y   (screen y = ay - h + 1)
    uint16_t width;           // +0x0C
    uint16_t height;          // +0x0E
} SSFrameDesc;
```

**Anchor semantics** (ruling of 2026-07-31, pixel-verified against the running game, 1994 binary under DOSBox): the descriptor's (x,y) pair is an (anchor-x = centre-x, anchor-y = bottom-y) placement anchor, evidenced twice independently — KING1.SS descriptor (94,198) for a 189×187 frame draws at (0,12), and ENGLND1.SS descriptor (118,121) draws at (32,0), both pixel-exact. Placement of such frames is asset-anchored, not code-literal.

**RLE pixel encoding** (per line, decoded row-major into a w×h cell pre-filled with transparent):

| Byte | Meaning |
|------|---------|
| 0xFC | end of sprite |
| 0xFF | end of line (advance to next row, pixel column resets) |
| 0xFD (as line marker) | run-mode line: repeated (count, pixel) pairs; a count byte of 0xFF ends the line |
| any other first byte | literal-line marker; the following bytes are literal pixels, except 0xFE which introduces a (count, pixel) run, and 0xFF which ends the line |
| **0xFD (as pixel value)** | **transparent** — the sprite colour key |

**Frame numbering — engine frame N = disk descriptor N−1.** Engine code and all engine-derived documentation number sprite frames from 1; the descriptor table on disk is 0-based. Proof (ruling of 2026-07-31): TERRAIN.SS holds exactly **12** disk descriptors while the engine loads "frames 1..12"; WOODFRAM.SS holds **1** ("frame 1"); NAMEPLAT.SS holds **3** (frames 1–3); PHYS0.SS holds **154** descriptors (disk 0..153) so engine frame 154 is disk sprite 153. The draw verb `func_00E76A` indexes `base + frame·12 + 0x36` with no subtraction — the −1 lives in the load/record layout. A pixel render of PHYS0.SS confirms disk sprites 150–153 are the four straight-coast shorelines while disk 149 (= engine "frame 150") is a diagonal wave/hatch overlay.

### 2.3 .PIK full-screen images

A .PIK is a single 320×200 indexed-colour background in a MADSPACK container, nominally 3 sections: image header, an optional 768-byte palette, and FAB-compressed pixels. **Palette precedence rule**: an asset with an embedded palette section renders with its own palette; only assets without one fall back to the master VICEROY.PAL. Both cases ship:

- **COLONY.PIK has no embedded palette** — it is a 2-section file, a 320×72 strip blitted at y=128 on the colony screen, whose pixel indices are authored directly against the gameplay palette (pixel-verified against the running game, 1994 binary under DOSBox).
- **EUROPE.PIK is self-contained** — 3 sections including its embedded palette, and its artwork *bakes in* screen furniture: the harbour town, the dock slots, the 16-good market grid and the red "E" button are all background art, not engine-drawn elements (pixel-verified; the Europe screen rebuild from this file was 100.00% pixel-exact outside dynamic-sprite masks).

### 2.4 .FF bitmap fonts

An .FF is a MADSPACK container whose single FAB section decompresses to this payload:

```c
typedef struct {              // .FF decompressed payload
    uint8_t  cell_height;     // +0x00 glyph cell height H; engine line pitch = H+3 (@0x3AB7)
    uint8_t  max_width;       // +0x01
    uint8_t  widths[128];     // +0x02   slot j = width of ASCII char j+1
    uint16_t offsets[128];    // +0x82   slot j = payload offset of char j+1's bitmap
    // +0x182: glyph bitmaps, 2 bits/pixel, MSB-first, row-major
} FFFont;
```

**The index mapping is `ch−1`**: `width(ch) = widths[ch−1]`, `bitmap(ch) = payload[offsets[ch−1] .. offsets[ch]]`. This is proven both by rendering (under the naive `widths[ch]` mapping every glyph draws as its successor) and by the engine bytes: the string-blit core `func_00E51C` decrements the character before both lookups — `dec dl` at 0xE5DA, width read `mov al,[bx+si+2]` at 0xE5E9, offset read `mov si,[bx+si+0x82]` at 0xE606. Glyph bitmap size = `H · ceil(width·2/8)` (validated for 95/95 printable slots in all five shipped fonts). The four 2-bpp levels are 0 = transparent and 1/2/3 = ink shades for anti-aliasing. **Advance = width** (each glyph carries its own trailing spacing column). Decompressed payload sizes: FONTTINY 914, FONT-NP 914, FONTKING 1,219, FONTINTR 1,898, FONTSMAL 1,148 — each exactly 386 + Σ glyph sizes.

### 2.5 Sound: the `$sound$` driver overlay and `#SOUND.COL`

The audio "drivers" are DOS executables. All four device files — ASOUND.COL (AdLib), GSOUND.COL (SoundBlaster/GameBlaster), PSOUND.COL (PC speaker), RSOUND.COL (Roland MT-32) — begin with the MZ magic; CONFIG.COL (20 bytes) is a small device-configuration blob (base port / IRQ words). At boot, `func_07845A` (called from 0x762E6) takes the template string **`"#SOUND.COL"`** (file 0x1FD5A), replaces the `#` with the configured device letter from `[0x2608]`, and `func_01287A` loads the resulting file via DOS int 21h AX=4B03 (load overlay) under the tag **`"$sound$ "`** (file 0x2004B). The driver's header supplies five entry vectors installed to DGROUP 0xA654–0xA667 by `func_012928`; command dispatch is at 0x1299A (with an 8-deep queue when locked), and the timer ISR at 0xC6D9 clocks vector 4 every tick and vector 3 every fifth tick. Sampled audio lives in COLDIG.BIN (993,755 bytes of 8-bit unsigned PCM), indexed by the driver.

### 2.6 Data-file inventory

The shipped game directory holds 300 files. By type (sizes are byte totals):

| Type | Count | Bytes | Role |
|------|------:|------:|------|
| .SS | 206 | 1,418,359 | sprite sheets (§2.2): terrain/overlays (TERRAIN, PHYS0), icons, units, portraits (CC-00..24), woodcuts (WDCUT01..13), cinematic series |
| .PIK | 35 | 928,431 | 320×200 backgrounds (§2.3): COLONY, EUROPE, REPORT1–9, KINGLSS1/2, OPENMENU, DIFFICUL, NATIONS, … |
| .TXT | 18 | 186,518 | game data/text: NAMES (data dictionary), GAME (510 dialog `@KEY` definitions), LABELS, MENU, MAPMENU, PEDIA, COLONY, TRIBE, WOODCUT, OPENING, CLOSING, DEBUG, MAPEDIT, README, MEMORY/2, AUTOEXEC, CONFIG |
| .SAV | 10 | 288,510 | save slots COLONY00–09.SAV |
| .EXE | 6 | 902,531 | §1.1 |
| .COL | 5 | 190,180 | 4 MZ sound drivers + CONFIG.COL (§2.5) |
| .FF | 5 | 4,014 | fonts FONTTINY / FONTSMAL / FONTKING / FONTINTR / FONT-NP (§4) |
| .DAT | 3 | 20,646 | CYCLE.DAT (34 B, palette-cycling data, format unmapped), PATH.DAT (ASCII ship path), INSTALL.DAT |
| .DB | 2 | 1,619 | MODULES.DB (34 engine module names), ERRORS.DB (engine constraint names, e.g. PopupTooManyLines) |
| .BAT | 2 | 102 | COLONIZE.BAT, COLDEMO.BAT launchers |
| .MP | 1 | 12,534 | AMER2.MP — the standard Americas map (§3) |
| .BIN | 1 | 993,755 | COLDIG.BIN PCM sample bank |
| .PAL | 1 | 1,024 | VICEROY.PAL master palette (§4.4) |
| .MOV | 1 | 572 | AMERICA.MOV cinematic metadata |
| .GIF / .COM / .PIF / .ION | 4 | 129,829 | installer splash, PKUNZJR.COM, install shortcuts/descriptions |

## 3. The .MP map format and the game's loader

The map file format is known from the best possible source: the shipped editor's own writer and loader, read under their real linker names from MAPEDIT.EXE's CodeView symbols (`_write_map_file` at MAPEDIT file 0xB840, `_load_map_file` at 0xB700), and cross-checked byte-for-byte against the shipped world AMER2.MP. VICEROY reads the same file — but, as live testing showed, it rewrites parts of what it reads. Terrain-id semantics follow the NAMES.TXT `$TERRAIN` sections (`@UNFORESTED`, `@FORESTED`, `@OTHER`), which the editor's own data loader corroborates.

### 3.1 File layout

```c
typedef struct {              // .MP file
    uint16_t width;           // +0x00 AMER2 = 58 (0x3A)  — full grid incl. border ring
    uint16_t height;          // +0x02 AMER2 = 72 (0x48)
    uint16_t version;         // +0x04 must be 4 (loader cmp @MAPEDIT 0xB76D)
    // +0x06: layer 1 — terrain, width*height bytes, row-major (y outer, x inner)
    // then:  layer 2 — feature,          width*height bytes
    // then:  layer 3 — continent/owner,  width*height bytes
} MPFile;                     // file size = 6 + 3*width*height  (AMER2: 12,534 = 6 + 3*4176)
```

Nothing follows layer 3 — there are no colony/unit/settlement record arrays in .MP files (those belong to save-games).

**Layer 1 — terrain byte:**

| Bits | Mask | Meaning |
|------|------|---------|
| 0–4 | 0x1F | terrain id 0..28 |
| 5 | 0x20 | mountains/hills overlay |
| 6 | 0x40 | river overlay |
| 7 | 0x80 | modifier for bits 5/6 — with bit 5: set = Mountains (id 27), clear = Hills (28); with bit 6: set = Major River, clear = Minor River |

(Paint masks at MAPEDIT 0x2744–0x2788; reader `_terrain_type` at 0xB17C.) **Forest is *not* a bit** — forested terrain is expressed in the id itself: ids 8..23 are the auto-forest range (the game's terrain-id fold, byte-verified at VICEROY file 0x6204: read byte, mask `& 0x1F`, apply the auto-forest conversion; ids 16..23 are aliases of 8..15). The editor's `_terrain_is_forest` at 0xB222 tests exactly 8..0xF and 0x10..0x17.

**Layer 2 — feature flags** (game-side; the editor passes them through): bit 0 unit present, bit 1 settlement, bit 2 prime resource, bits 3/6 tested by the editor's `_is_hostile` at 0x44D1 (semantics game-side). AMER2.MP's layer 2 is all zeros.

**Layer 3 — continent/owner:** low nibble = continent/region id 1..15 (0 = border/none; labels compressed by `_map_find_continents` at 0xB242, overflow → 0xF); high nibble = owner (0xF = none).

**AMER2.MP layer-1 bit-combo census** (byte-verified): `0x20` hills ×56 · `0x40` minor river ×178 · `0x60` hills+minor river ×1 · `0xA0` mountains ×170 · `0xC0` major river ×47; plain-id tiles ×3,724. Terrain ids used: 0..23, 25, 26.

### 3.2 Terrain ids 0..28

Per NAMES.TXT `$TERRAIN`, in `@UNFORESTED` / `@FORESTED` / `@OTHER` order:

| ID | Name | ID | Name |
|----|------|----|------|
| 0 | Tundra | 8–15 | forested variants of 0–7 (Boreal Forest, …) |
| 1 | Desert | 16–23 | aliases of 8–15 (folded on load) |
| 2 | Plains | 24 | Arctic |
| 3 | Prairie | 25 | Ocean (blank-map fill value) |
| 4 | Grassland | 26 | Sea Lane |
| 5 | Savanna | 27 | Mountains (overlay form 0xA0) |
| 6 | Marsh | 28 | Hills (overlay form 0x20) |
| 7 | Swamp | | |

Mountains/Hills have a dual representation: as ids 27/28 (how `@OTHER` names them and how `_terrain_type` reports them: bit 5 set → 0x1B + (bit7 ? 0 : 1)) and as overlay bits on a base land terrain (how tiles store them; editor paint masks: Mountains `or 0xA0 / and 0x1F`, Hills `or 0x20 / and 0x5F`, Major River `or 0xC0 / and 0x1F`, Minor River `or 0x40 / and 0x3F`, all at MAPEDIT 0x2744–0x2788).

### 3.3 Border ring and the sea-lane column

The outermost 1-tile ring is not editable (`_change_map` bounds x,y ∈ [1..w−2]/[1..h−2] at MAPEDIT 0x31E9–0x320D) and is skipped by the continent finder; in AMER2.MP the ring is Ocean. The **sea-lane column is the right-most *playable* column x = w−2**: all 70 interior rows of AMER2's column 56 carry base id 26 (Sea Lane) — never fake this column as any other terrain. New maps are created all-Ocean (fill 0x19), hard-coded 58×72, version 4 (`_create_blank_map` at 0xB94A); the sea lane is hand-painted, not synthesised.

### 3.4 MAPEDIT's writer, loader and error codes

The writer emits header words, then the three layers in order (writes at MAPEDIT 0xB878–0xB8AC then 0xB8C8/0xB8E8/0xB910). The loader mirrors it, requires version == 4 (0xB76D–0xB773) and caps `w·h ≤ 0x2EE0` (12,000 tiles) at 0xB6CE. Error codes (`_map_error`):

| Code | Meaning |
|-----:|---------|
| 1 | file open failed |
| 2 | header read failed |
| 3 | wrong version (≠ 4) |
| 4 / 5 / 6 | layer 1 / 2 / 3 I/O failure |
| 9999 | map too big (w·h > 0x2EE0) |

**Round-trips are not byte-preserving.** On every load MAPEDIT runs `_forest_fix` (MAPEDIT 0x16B6), which normalises ids 0x10..0x17 → id−8 and strips forest under a mountains/hills overlay. A load→save cycle of any file containing ids 16..23 (AMER2.MP does) therefore changes bytes while preserving meaning.

### 3.5 VICEROY's loader behaviour

VICEROY loads AMER2.MP at the start of the standard game and accepts the same 6-byte header + three layers, but live testing with a crafted map (loaded in the running 1994 binary under DOSBox, with same-moment RAM reads of the runtime planes) established three loader-side rewrites:

1. **Layer 2 (features) is discarded.** All crafted feature bytes read back 0 live; the game rebuilds the runtime feature plane itself (bit 0 unit, bit 1 settlement). Feature-gated pixels (shore overlay, roads, resource suppression) are unreachable via .MP data.
2. **Border normalisation is enforced by the loader**: rows 0 and h−1 → Arctic; columns 0, 1 **and** w−1 → Sea Lane for all interior rows, **overwriting even land**. The sea-lane column is loader-enforced, not merely a data convention.
3. **Forest alias ids 16..23 are folded to 8..15 at load**, matching the editor's `_forest_fix`.

The runtime plane pointers live at DGROUP `[0x15C]` (terrain), `[0x160]` (feature), `[0x164]` (continent+owner) and `[0x168]` (flags; low nibble = colony-site value). In the same live campaign the full tile-render rule set derived from these bytes reproduced 100.0000% of non-overlay pixels across every captured viewport.

## 4. Fonts and palette

Text in the game flows through one resident glyph engine fed by proportional 2-bpp bitmap fonts (§2.4), with colour supplied not per-glyph but through a tiny indirection — a 4-entry palette-index look-up table that maps the glyph's ink levels at draw time. All colour ultimately indexes the VGA palette: a master file palette plus per-screen palettes embedded in .PIK backgrounds, with two index bands animated by pure palette rotation.

### 4.1 The four loaded fonts (and one orphan)

VICEROY loads exactly **four** fonts through a single load verb, `LCALL 0x1A1F:0xA86` (target file 0x76C70), which has exactly four call sites — proving the fifth disk file, FONTSMAL.FF, is an **orphan, never loaded** (no `fontsmal` string exists in the EXE):

| Font | Name string | Load site | Handle stored to | Role |
|------|------------|-----------|------------------|------|
| FONTTINY | `"fonttiny"` @0x1FD32 | 0x760E8 (in boot loader `func_075FB6`) | latch `[0x89E]/[0x8A0]` | **boot-default body font**: HUD, inventory, popup bodies, advisor bodies |
| FONTINTR | `"fontintr"` @0x1FD2B | 0x760C6 (same loader, loaded first) | latch `[0x268A]/[0x268C]` | titles, menus, Hall of Fame, score figures |
| FONTKING | `"FONTKING"` @0x1FCCB | 0x754F6 (in `func_075352`) | shared active-font global `[0x1F9E]/[0x1FA0]` (no private latch; FONTTINY fallback @0x7550A) | **king-defeats screen only** — the sole load |
| FONT-NP | `"FONT-NP"` @0x1F8AF | 0x6B7AF (in `func_06B722`) | stack local `[bp−0x3AC]` (no global) | speaker name-plate / woodcut path |

Font selection is a **screen-level latch**, not a per-draw argument: paint code pushes the latched handle (`push [0x8A0]; push [0x89E]` for FONTTINY at e.g. 0x25F62 / 0x30EDE / 0x3860C; `push [0x268C]; push [0x268A]` for FONTINTR at 0x22ABE / 0x23C06 / 0x3B054). The dialog framework's `SMALLFONT` directive merely copies the latched font — it does not load a smaller one. The measure core at file 0xE6A6 accumulates `width(ch) + spacing` per character with the same `ch−1` table indexing as the blitter.

### 4.2 Per-font metrics

Decoded from the shipped .FF files with the corrected `ch−1` mapping (95/95 glyph-size validation per font). Line pitch = cell height + 3.

| Font | Cell H | Pitch | Max W | Space | Notable widths |
|------|:-:|:-:|:-:|:-:|----------------|
| FONTTINY | 6 | 9 | 6 | 2 | most glyphs 4; `i` `l` = 2, `t` = 3; `M` `W` `m` `w` = 6 |
| FONTKING | 7 | 10 | 8 | 2 | `i` `l` = 2; digits 3–7; `M` `W` = 8 |
| FONT-NP | 8 | 11 | 11 | 5 | uppercase A–Z only; `I` = 5, `S` = 5; `M` `W` = 11 |
| FONTINTR | 9 | 12 | 9 | 3 | digits all 6; `I` `i` `l` = 3; `M` `W` = 7; `%` `/` `@` = 9 |
| FONTSMAL (orphan) | 6 | 9 | 8 | 3 | digits 6; `M` `W` = 8 — present on disk, never loaded |

### 4.3 The glyph ink LUT

The rasteriser core `func_00E51C` unpacks each glyph's 2-bpp levels (`shl ax,2` at 0xE629) and maps every ink level 0..3 through a **4-entry palette-index LUT held at far pointer `[0x269E]:[0x26A0]`** (captured into the frame at 0xE532, applied `mov ah,[bp+si−6]` at 0xE632). A LUT entry of **0xFF means transparent** — the pixel is skipped (`cmp ah,0xFF` at 0xE637). A string's colour is therefore whatever the 4-byte LUT contains at draw time; the setter family is `func_00E68A` (writes `[0x269E]=cl, [0x269F]=dl, [0x26A0]=al, [0x26A1]=al`). Anti-aliased text renders with up to three ink shades per call, and "text colour" bugs or state-dependence trace to LUT stores, not to the fonts.

### 4.4 VICEROY.PAL and the working palette

VICEROY.PAL is 1,024 bytes: **768 bytes of 256 × 3-byte RGB triples in VGA 6-bit precision, plus 256 trailing unused bytes** (stride 3, not 4 — a settled ruling). Conversion to 8-bit per channel is `v8 = (v6 << 2) | (v6 >> 4)`. Screens that load a .PIK with an embedded palette run on that palette instead (§2.3); indices below are resolved against the master file, decoded directly from the shipped VICEROY.PAL:

| Index | VICEROY.PAL RGB (8-bit) | Pinned role (byte-cited site) |
|------:|------------------------|-------------------------------|
| 12 (0x0C) | (255,0,0) red | primary red entry |
| 14 (0x0E) | (255,255,85) yellow | selected-good cell outline (Europe screen, runtime-selected vs green 10) |
| 15 (0x0F) | (255,255,255) white | body/number text ink across screens |
| 0x2F | (12,12,12) near-black | Europe market **price ink** at y=194 (byte-cited, seen on screen) |
| 0x37 | (93,121,186)* | dialog **bevel-dark + selection bar** (`[0x1F40]/[0x1F42]/[0x1F48]`=0x37 @0x734E0/0x734E6) |
| 68 (0x44) | (85,150,52) green | ink init `[0x830]`=0x44 (file 0x1E1D0+); Europe title idle green |
| 69 (0x45) | (52,130,32) green | Europe caption ink (measured; not byte-cited) |
| 149 (0x95) | (199,162,32) gold | ink init `[0x831]`=0x95; Europe arrival-banner gold |
| 0xFC | (255,85,255)* | boot-menu **gold hilite** (`[0x1F4E]`=0xFC @0x734C2; live-confirmed at the boot menu); Hall-of-Fame gold resolves to (199,162,32) via its screen palette |
| 0xFD | (255,85,255)* | dialog **bevel-light** ink (`[0x1F46]/[0x1F50]`=0xFD @0x734DA) |
| 0xFE | (255,85,255)* | boot dialog **text** ink (`[0x1F4A]`=0xFE @0x734BC) |

\* Entries marked with an asterisk are placeholder values in the master file (0xFC–0xFE are magenta; 0x37 sits inside the water ramp): the screens that use these indices load their own palettes, so the on-screen colour comes from the active screen palette, not from VICEROY.PAL. The boot-mode ink block is written as a unit by the setter at 0x734BC–0x734E9 (`[0x1F44]`=0x2E frame ring, plus the entries above).

**Palette animation — two rotation bands.** Water is animated *entirely* by palette cycling; no pixel indices ever change:

1. **Water ramp, indices 54–60** — a descending blue ramp, (105,138,195) → (32,44,138) in the master palette. Live render-and-diff of the Europe screen is pixel-exact once the capture's cycle phase is applied to these seven entries; the pixel data is static.
2. **Sparkle band, indices 120–127** — the sea-lane/water sparkle, a second blue band rotated by the VGA palette mechanism (live capture matched at rotation phase +2; the band is shared by the map and colony screens).

The 34-byte CYCLE.DAT file is associated with the cycling mechanism; its exact format is unmapped.
