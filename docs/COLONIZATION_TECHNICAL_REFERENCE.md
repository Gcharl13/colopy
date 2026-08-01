# Sid Meier's Colonization — Technical Reference

The shipped 1994 MS-DOS release, documented from its binaries and data files.
Facts in this volume were established by disassembly of the shipped
executables, by reads of live game memory under emulation, and by pixel-level
comparison of screens reconstructed from these pages against the running game.
Where a value could not be established it is marked unmapped or runtime — no
figure in this volume is invented.

## Contents

Part I — The machine and its files: §1 Executables and overlay architecture ·
§2 Asset containers and file formats · §3 The .MP map format · §4 Fonts and palette
Part II — World and terrain: §5 Terrain system · §6 The map compositor ·
§7 Runtime map state and the map screen periphery
Part III — Economy and colonies: §8 Colonies · §9 Market and trade ·
§10 The native economy · §11 Trade routes
Part IV — Units and combat: §12 Units · §13 Movement and pathfinding · §14 Combat
Part V — Politics and powers: §15 Powers and relations · §16 European diplomacy ·
§17 Congress, bells, and Founding Fathers · §18 Revolution, the King, and
multiplayer · §19 Natives · §20 Turn flow and persistence · §21 Random numbers
Part VI — Events and messages: §22 The string files · §23 The event catalogue ·
§24 Music and sound
Part VII — User interface: §25 UI engine · §26 Screens · §27 Input, cheats,
and options
Part VIII — The editor and appendices: §28 The map editor · §29 Verification ·
§A Data structures · §B Sprite sheets and palette

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

---

## 5. Terrain system

Every square of the world map carries one of 29 terrain identifiers. The authoritative
source for terrain identity, ordering and per-terrain statistics is the `$TERRAIN` block
of the game's `NAMES.TXT` data file, which the engine parses at start-up into a
16-byte-stride record table in the data segment; the renderer, the yield calculator and
the combat engine all index that one table. This section gives the complete id space,
the data-file legend, the full per-terrain statistics, and the runtime record layout.

### 5.1 Terrain identifiers 0..28

The id is the low five bits of the stored terrain byte (`AND al,0x1F` at 0x620A).
Ids 8..23 are the forested variants of bases 0..7; ids 16..23 are a second encoding
of the same eight forest types (see §5.4).

| id | hex | Name | Notes |
|----|-----|------|-------|
| 0 | 0x00 | Tundra | base terrain |
| 1 | 0x01 | Desert | base terrain |
| 2 | 0x02 | Plains | base terrain |
| 3 | 0x03 | Prairie | base terrain |
| 4 | 0x04 | Grassland | base terrain |
| 5 | 0x05 | Savannah | base terrain |
| 6 | 0x06 | Marsh | base terrain |
| 7 | 0x07 | Swamp | base terrain |
| 8 | 0x08 | Boreal | forested Tundra |
| 9 | 0x09 | Scrub | forested Desert |
| 10 | 0x0A | Mixed | forested Plains |
| 11 | 0x0B | Broadleaf | forested Prairie |
| 12 | 0x0C | Conifer | forested Grassland |
| 13 | 0x0D | Tropical | forested Savannah |
| 14 | 0x0E | Wetland | forested Marsh |
| 15 | 0x0F | Rain | forested Swamp |
| 16–23 | 0x10–0x17 | (aliases) | second encoding of 8..15; fold `(id&7)|8` at 0x6225 |
| 24 | 0x18 | Arctic | |
| 25 | 0x19 | Ocean | water |
| 26 | 0x1A | Sea Lane | water; the right-edge map column is always Sea Lane (id 26, never 25) |
| 27 | 0x1B | Mountains | encoded as bit flags, not a stored id (§5.4) |
| 28 | 0x1C | Hills | encoded as bit flags, not a stored id (§5.4) |

The map loader enforces the border convention at load time (runtime-verified against
live memory): rows 0 and 71 are overwritten with Arctic (0x18), and columns 0, 1 and 57
with Sea Lane (0x1A) for y = 1..70, overwriting even land; forest alias ids 16..23 are
folded to 8..15 in the live plane.

### 5.2 The `$TERRAIN` column legend

The legend is stated in the header comment of the data file itself, directly above the
`@UNFORESTED` block, and the 14-column CSV rows match it exactly:

```text
a) Name
b) Movement, Defensive, Improvement, Value
c) Yield (Farmer, Planter(s), Planter(t), Planter(c),
          Trapper, Lumberjack, Ore Miner, Silver Miner, Fisherman)
```

The nine yield columns map to goods as follows (in-memory column order matches the CSV
order — the yield read is by good index, §5.5):

| yield column | worker | good produced |
|---|---|---|
| 1 | Farmer | Food |
| 2 | Planter(s) | Sugar |
| 3 | Planter(t) | Tobacco |
| 4 | Planter(c) | Cotton |
| 5 | Trapper | Furs |
| 6 | Lumberjack | Lumber |
| 7 | Ore Miner | Ore |
| 8 | Silver Miner | Silver |
| 9 | Fisherman | Fish (Food) |

### 5.3 Per-terrain data — the full 21 distinct rows

Transcribed verbatim from the extracted `@UNFORESTED` / `@FORESTED` / `@OTHER` blocks.
Columns: Mv = Movement, Df = Defensive, Im = Improvement, Vl = Value; then the nine
yields in legend order (Fa Su To Co Fu Lu Or Si Fi).

**Unforested bases (ids 0–7):**

| id | Name | Mv | Df | Im | Vl | Fa | Su | To | Co | Fu | Lu | Or | Si | Fi |
|----|------|----|----|----|----|----|----|----|----|----|----|----|----|----|
| 0 | Tundra | 1 | 0 | 4 | 2 | 2 | 0 | 0 | 0 | 0 | 0 | 2 | 0 | 0 |
| 1 | Desert | 1 | 0 | 3 | 2 | 1 | 0 | 0 | 1 | 0 | 0 | 2 | 0 | 0 |
| 2 | Plains | 1 | 0 | 3 | 4 | 4 | 0 | 0 | 2 | 0 | 0 | 1 | 0 | 0 |
| 3 | Prairie | 1 | 0 | 3 | 4 | 2 | 0 | 0 | 3 | 0 | 0 | 0 | 0 | 0 |
| 4 | Grassland | 1 | 0 | 3 | 4 | 2 | 0 | 3 | 0 | 0 | 0 | 0 | 0 | 0 |
| 5 | Savannah | 1 | 0 | 3 | 4 | 3 | 3 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| 6 | Marsh | 2 | 1 | 5 | 2 | 2 | 0 | 2 | 0 | 0 | 0 | 2 | 0 | 0 |
| 7 | Swamp | 2 | 1 | 7 | 2 | 2 | 2 | 0 | 0 | 0 | 0 | 2 | 0 | 0 |

**Forested variants (ids 8–15; ids 16–23 alias these):**

| id | Name | Mv | Df | Im | Vl | Fa | Su | To | Co | Fu | Lu | Or | Si | Fi |
|----|------|----|----|----|----|----|----|----|----|----|----|----|----|----|
| 8 | Boreal | 2 | 2 | 4 | 3 | 1 | 0 | 0 | 0 | 3 | 2 | 1 | 0 | 0 |
| 9 | Scrub | 1 | 2 | 4 | 1 | 1 | 0 | 0 | 1 | 2 | 1 | 1 | 0 | 0 |
| 10 | Mixed | 2 | 2 | 4 | 3 | 2 | 0 | 0 | 1 | 3 | 3 | 0 | 0 | 0 |
| 11 | Broadleaf | 2 | 2 | 4 | 3 | 1 | 0 | 0 | 1 | 2 | 2 | 0 | 0 | 0 |
| 12 | Conifer | 2 | 2 | 4 | 3 | 1 | 0 | 1 | 0 | 2 | 3 | 0 | 0 | 0 |
| 13 | Tropical | 2 | 2 | 6 | 3 | 2 | 1 | 0 | 0 | 2 | 2 | 0 | 0 | 0 |
| 14 | Wetland | 3 | 2 | 6 | 1 | 1 | 0 | 1 | 0 | 2 | 2 | 1 | 0 | 0 |
| 15 | Rain | 3 | 3 | 7 | 1 | 1 | 1 | 0 | 0 | 1 | 2 | 1 | 0 | 0 |

**Other terrains (ids 24–28):**

| id | Name | Mv | Df | Im | Vl | Fa | Su | To | Co | Fu | Lu | Or | Si | Fi |
|----|------|----|----|----|----|----|----|----|----|----|----|----|----|----|
| 24 | Arctic | 2 | 0 | 4 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| 25 | Ocean | 1 | 0 | 2 | 3 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 3 |
| 26 | Sea Lane | 1 | 0 | 2 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 3 |
| 27 | Mountains | 3 | 6 | 7 | 2 | 0 | 0 | 0 | 0 | 0 | 0 | 4 | 1 | 0 |
| 28 | Hills | 2 | 4 | 4 | 2 | 1 | 0 | 0 | 0 | 0 | 0 | 4 | 0 | 0 |

### 5.4 The auto-forest rule and the tile-byte encoding

The stored terrain byte is decoded by `get_terrain_id_from_raw` (`func_006204`, file
0x6204): read the byte, mask `AND 0x1F` (0x620A), then apply the auto-forest conversion.
Ids 8..23 form the forested band; for any id in that band the decoder (mode global
`[0x18E]` = 2) normalises to the eight canonical forest ids 8..15 via `(id & 7) | 8`
(0x6225) — so 16→8 … 23→15: ids 16..23 are a second encoding of the same eight forest
variants, not distinct terrains. Mode `[0x18E]` = 3 instead strips to the unforested
base `id & 7` (0x6238); the default mode returns the raw masked id.

The remaining bits of the terrain byte (per the map-file writer and `func_0624E`):
bit 5 (0x20) = relief present; bit 7 (0x80) then selects Mountains (set, id 27) versus
Hills (clear, id 28) — `AND 0x80; SBB; +0x1B` in `func_0624E`. Bit 6 (0x40) = river,
with bit 7 doubling as the Major (set) / Minor (clear) river selector on river tiles.
Bit 7 in isolation (bit 5 clear, bit 6 clear) never occurs in shipped maps and is inert.

### 5.5 The runtime terrain record table (DS:0x2F74, stride 16)

At start-up a loader (`func_0745F0`, byte-stream reads via the section reader) fills one
16-byte record per terrain at `DS:0x2F74 + terrain·16`: first a name-token word, then
the four `b)` columns as bytes, then the nine yield bytes.

```c
typedef struct {          // DS:0x2F74 + terrain*16, one record per terrain id
    uint16_t name;        // +0x00 name token (loaded 0x74607; title read [id*16+0x2F74] at 0x69DD1)
    uint8_t  movement;    // +0x02 Movement        (DS:0x2F76, loaded 0x7460D)
    uint8_t  defensive;   // +0x03 Defensive       (DS:0x2F77, combat read at 0x7E63)
    uint8_t  improvement; // +0x04 Improvement     (DS:0x2F78)
    uint8_t  value;       // +0x05 Value           (DS:0x2F79)
    uint8_t  yields[9];   // +0x07..+0x0F 9 yields (DS:0x2F7B+good, loop at 0x74633)
    // +0x06..+0x06 unmapped (1 byte)
} TerrainRecord;
```

The yield read is byte-verified in the colony production calculator at 0x9C15
(`func_009B9C`): `SHL si,4` (terrain·16), `bx` = good index, `MOV al,[bx+si+0x2F7B]` —
i.e. `yield = [terrain·16 + 0x2F7B + good]`. The Colonizopedia terrain pages title from
the same table (`[id·16 + 0x2F74]` at 0x69DD1, with a "(forest)" qualifier appended for
ids 8..15 at 0x69DF3), and the pedia's terrain category walks ids 0..0x1C skipping
0x10..0x18 (0x6B26E).

### 5.6 Terrain defence in combat: Defensive value × 25%

The defence-bonus filler `func_007D3E` reads the Defensive column at
`[terrain·16 + 0x2F77]` (0x7E63) for the defender's tile and accumulates it into the
defence-modifier chain. The Combat Analysis dialog (`func_05E9B0`) prints the terrain
row as **+ (Defensive × 25 %)** — the row is flagged "Terrain" for the defender
("Ambush" for the attacker), draws the target tile, and is skipped when the value is 0.
So the byte-verified per-terrain bonuses are: open land (Tundra/Desert/Plains/Prairie/
Grassland/Savannah) +0 %; Marsh/Swamp +25 %; forests +50 % (Rain +75 %); Hills +100 %;
Mountains +150 %; Arctic/Ocean/Sea Lane +0 %.

### 5.7 Special resources (`@RESOURCE`) and overlay names (`@OTHER_NAMES`)

The `@RESOURCE` block ("Special resource squares & values") lists each prime-resource
square with a single value byte — the production-bonus magnitude for the good implied
by its name. Transcribed verbatim (the data file carries the Prime Timber row twice):

| Resource | value | Resource | value |
|---|---|---|---|
| Depleted Mine | 6 | Beaver | 6 |
| Oasis | 3 | Game | 6 |
| Wheat | 4 | Prime Timber | 6 |
| Prime Cotton | 6 | Prime Timber | 6 |
| Prime Tobacco | 6 | Silver Deposit | 12 |
| Prime Sugar | 7 | Ore Deposit | 6 |
| Minerals | 4 | Fishery | 5 |

Prime-resource *presence* on a tile is procedural, not stored — it is the map
compositor's detail-band position hash (§6.9).

`@OTHER_NAMES` supplies the five overlay/UI names, in order: **Forest, River,
Major River, Minor River, Unexplored**.

### 5.8 The worked-tile production calculation (`func_009B9C`, 0x9B9C..0x9FFB)

One function computes what a colonist working a ring tile produces:
`compute_terrain_yield` — 1,120 bytes, called once per worked tile from the
5×5 ring scan of the colony turn processor (`CALL 0x9B9C` at 0xA42A). Every
modifier below is byte-cited; the order is the order the code applies them.

1. **Resolve the good** for this worker slot (`CALL 0x9974` at 0x9BB7; return
   0 if none), then the tile's feature byte (`0x37F:0x10E` at 0x9BEB), terrain
   id (`0x3E4:0x0E` at 0x9BF9) and prime resource (`0x37F:0x4B0` at 0x9C0A).
2. **Base yield** = `[terrain·16 + 0x2F7B + good]` (0x9C15/0x9C1E — the
   §5.5 table). A base of 0 short-circuits every modifier (0x9C27).
3. **Sea adjacency** (goods ≥ 8 only, 0x9C2E): count adjacent Ocean/Sea-Lane
   tiles (0x9C3E) — ≥ 8 → −2 (0x9C4C), 6–7 → −1 (0x9C57), < 6 → +1 (0x9C61).
   The +2/+3/+4 tails at 0x9C66/0x9C72/0x9C7E are emitted but unreachable.
4. **Furs road bump**: good 4 with feature bits 0x0A → +1 (0x9C87..0x9C9F).
   **River bumps**: terrain-byte bit 0x40 → +1 (0x9CA2), Major (bit 0x80) →
   +1 more (0x9CAB). Clamp ≥ 0 (0x9CB4).
5. **Profession match**: the worked-tile colonist's `@JOB` byte is compared to
   the good (`func_008956` via tables DS:0xC8/0xDE; compare at 0x9CDC);
   `era_flag` marks Food/Horses (0x9CFB..0x9D0E).
6. **Sons-of-Liberty adjustment**: `sol_pct` from `func_008524` (§8.1);
   `tory_cnt = (pop·(100−sol) + 50)/100` (0x9D27..0x9D30);
   `sol_adj = −(tory_cnt / (10 − difficulty))` for an active human colony
   (divisor 10 otherwise; 0x9D49..0x9D7F), then +1 for each of the
   ColonyRecord `+0x1C` bit-4 / bit-2 latches (0x9D88..0x9D98). A **positive**
   `sol_adj` is added here (0x9D9B..0x9DA7); a **negative** one is held back
   and applied as the very last step with a ≥ 0 clamp (0x9FD8..0x9FF3).
7. **Expert bonus**: on a profession match with nonzero yield — Food/Horses
   +2 (0x9DBF); every other good **doubles** (`SHL` at 0x9DD2). The expert
   also doubles the prime-resource bonus (0x9E0A).
8. **Prime resource**: `rbonus = func_009AAA(resource, good)` (0x9DDE);
   a negative (penalty) result doubles the yield instead (0x9DFE), otherwise
   `yield += rbonus` (0x9E0D). The bonus table inside `func_009AAA` is
   unmapped (TBD). Fishery/yield-0 guard at 0x9DE7.
9. **Lumber doubles** (good 5, `SHL` at 0x9EAB).
10. **Improvements** (0x9EB4..0x9F4C, gated yield > 0): bonus magnitude
    `tier` = 1, raised to 2 in the cited profession/era cases (0x9EC6/0x9EDD).
    **Road** (feature bits 0x0A, 0x9EF9) adds `tier` only for goods > 3 —
    the ore/fur/timber band (0x9F05..0x9F0E). **Plow** (feature bit 0x40,
    0x9F17) adds `tier` only for goods ≤ 3 — the crop band (0x9F23..0x9F2C).
    **River** adds `tier`, and `tier` again for a Major river
    (0x9F2F..0x9F46). Food takes `add = tier` directly (0x9EE7).
11. **Gates**: goods ≥ 8 need building/father bit 6 or produce 0
    (0x9F4F..0x9F62); **Henry Hudson** (FF op 8) doubles Furs
    (0x9F65/0x9F77/0x9F83); the special class 0x1B adds +1 for goods
    {0,1,2,3,4} and ≥ 8 (0x9F86..0x9FB6). Final clamp ≥ 0, negative
    `sol_adj`, return (0x9FB9..0x9FF6).

**The colony centre tile** is computed separately in the turn processor with
**no worker**: a food class 0..3 by terrain band (0xA24C..0xA290) with +2 at
difficulty 0 / +1 at difficulty 1 (0xA295/0xA2A1), +1 river (0xA2B9), +2 for
resources 1/9/2 (0xA314), plus the `+0x1C` latches; and the best non-food good
scanned over goods 1..7 **skipping Lumber** (0xA375), with a penalty resource
doubling base first (0xA39F) and +1 at difficulty 0 (0xA3AB). Both post at
0xA3EE..0xA409.

**Improvement state storage**: roads live in the runtime feature plane
`[0x160]` as bits 0x0A (write `or es:[bx],8` at 0x040AEC), plowing as bit 0x40
(`or es:[bx],0x40` at 0x04089F), clearing subtracts 8 from the forested
terrain id (0x040896, lumber windfall → colony stockpile at 0x04084D,
`@CLEARCUT`); rivers are terrain-byte bits 6/7 (§5.4). Work time = the
Improvement column `[terrain·16 + 0x2F78]` + 2 for clear/plow (0x040727), no
+2 for roads (0x040A50), counted in `UnitRecord +0x16` (0x04071D/0x040A46),
halved for Hardy Pioneers (`sar ax,1` at 0x4074A/0x40A59), −20 tools per
action (0x4060F).

## 6. The map compositor

Every visible map tile is composed at render time by a three-function chain: the
visible-rectangle loop `func_O514` (`func_0685DC`, file 0x685DC..0x68897) walks the
viewport; the per-tile selector `func_O513` (`func_0681A8`, 0x681A8..0x685DB) chooses
every sprite frame for one tile; and the sub-cell composer `func_O512` (`func_067F50`,
0x67F50..0x681A7) dithers each tile's edges into its neighbours. The whole chain below
is pixel-verified at 100.0000 % of non-overlay pixels against the running game (1994
binary under DOSBox), in three independent live tests: an all-water window (45,056 px),
a coastal land window (41,540 px), and five viewport captures of a crafted test map
exercising hills, rivers, river mouths, lakes and forest aliases.

**Frame-numbering convention (stated once, applies throughout):** all `0xNN` frame
constants in this chain are *engine* frame numbers, which are 1-based over the sprite
sheet's on-disk descriptors — disk sprite = engine frame − 1. (Proven by descriptor
counts: TERRAIN 12, WOODFRAM 1, NAMEPLAT 3, PHYS0 154, plus pixel renders.) PHYS0.SS
holds 154 disk frames (0..0x99); transparent pixels use palette index 0xFD.

### 6.1 O514 — the visible loop and per-tile addressing

`func_0685DC` walks the visible tile rectangle from the scroll origin `[0x8328]` (x) /
`[0x832E]` (y) over the viewport span, clamped to the map extents `[0x8804]`/`[0x8806]`.
Per tile it computes the linear index `(y+1)·stride[0x8548] + (x+1)` (0x6868E) — the
+1s are the 1-tile border padding that keeps neighbour reads in-bounds — forms
far-pointers into the four map planes (`[0x15C]` terrain, `[0x160]` feature, `[0x164]`
continent/owner, `[0x168]` flags; §7.1) at that index, sets the tile's screen anchor
(centre-x `[0xA5A4] = col·16 + 8` at 0x6875F, baseline-y `[0xA5A6] = (row+1)·16 − 1` at
0x68720), and calls O513. The fog mask `[0xA89E] = 1 << (player+4)` is latched at
0x685F2 (§7.2).

O513 first latches the tile bytes: `[0xA89F]` = feature byte (from `[0xA594]`),
`[0xA8A1]` = terrain byte (from `[0xA598]`), `[0xA8A2]` = classified terrain id, and the
tile fog byte `[0xA8A0]` (from `[0xA59C]`), at 0x681E0; world coordinates are
`[0xA5A0]`/`[0xA5A2]` (engine scroll-space = plane index − 1). All drawing lands in the
16×16 per-tile composite buffer at near-pointer 0x839E, which is then blitted to screen.

### 6.2 Ground tiles — the 12-frame TERRAIN.SS sheet

TERRAIN.SS is the base-ground sheet (loaded at boot and on map-enter), composited
*under* every PHYS0.SS overlay. `emit_ground_sprite` (`func_067E28`) blits from the
sheet pointer `[0x16C:0x16E]` (plain 16-px blit thunk when zoom = 0, 0x67E3A). The
sheet has exactly 12 frames; the ground-frame normaliser (`func_003436`) maps the
classified id to a disk frame:

```text
class 0..7            -> frames 0..7   (the eight unforested bases)
class 9 or 0x11       -> frame 8       (Scrub cactus ground)
class 0x18 Arctic     -> frame 9       (class >= 8: frame = class - 0xF)
class 0x19 Ocean      -> frame 10
class 0x1A Sea Lane   -> frame 11
```

O513's ground-id selection (0x682C0..0x68301): with `c = [0xA8A2]`, fold
`c & 7` for `c < 0x18`; a forested tile grounds with its unforested base, *except*
Scrub (`folded == 1`), which grounds via the fallback id 0x11 → cactus frame 8. The
Ocean/Sea-Lane split (frames 10/11) is visible on screen and pixel-confirmed.

### 6.3 O513 draw order and the sprite-frame assignment map

The per-tile draw order on the visible path, with the PHYS0 engine-frame bands:

| step | overlay | engine frames | gate / selector | site |
|---|---|---|---|---|
| 1 | fog tile + fog edges | 0x95; 0x69+dir | hidden flag (§6.11) | 0x68212, 0x68244 |
| 2 | base ground | TERRAIN 1..12 | normaliser §6.2 | 0x68285 / 0x68301 |
| 3 | open-water early out | — | water, 0 land neighbours: ground + detail + O512, return | 0x68274 |
| 4 | O512 edge blend | 0x69..0x6C stencils | every differing edge (§6.11) | 0x68315 |
| 5 | forest | 0x41 + mask4 | forested, not Scrub | 0x6833D |
| 6 | shore hatch | 0x96 | feature byte & 0x40 | 0x6834F |
| 7 | relief | 0x21 / 0x31 + mask4 | terrain byte & 0x20 (§6.5) | 0x6835C |
| 8 | rivers | 0x01 / 0x11 + mask4 | terrain byte & 0x40 (§6.6) | 0x6838A |
| 9 | detail band | 0x5A + value | position hash (§6.9) | 0x682B2 / 0x683F7 / 0x685D6 |
| 10 | surf/rumor | 0x68 | rumor hash (§6.10) | 0x68405..0x68414 |
| 11 | roads | 0x51; 0x52+d | feature byte & 0x0A (§6.8) | 0x68417 |
| 12 | coast edges | 0x97..0x9A | water tile, clean pattern (§6.7) | 0x6850D |
| 13 | coast quadrants | 0x6D..0x8C | water tile, no clean pattern (§6.7) | 0x684BC..0x684F5 |
| 14 | river mouths | 0x8D..0x90 / 0x91..0x94 | water tile, own bits & 0xC0 (§6.6) | 0x68524..0x685AC |

Rows 5–11 run on land tiles; rows 12–14 on water tiles. There is no other road or coast
band: the 0x6D band is coast sub-tiles (not roads) and 0x95 is the unexplored tile (not
a coast base).

### 6.4 Forest overlay — 0x41 + connection mask

Frame = `0x41 + mask`, where the 4-cardinal mask (`func_067C8E`) sets weights
**N=8, S=4, W=2, E=1** for each neighbour that connects. A neighbour connects
(`func_067C54`) iff its masked id is in the forest band 8..0x17 **and** `(id & 7) ≠ 1`
— **desert Scrub never connects** (and a Scrub centre draws no forest overlay at all;
its trees are the cactus ground frame). Live-confirmed: a Boreal|Scrub pair renders
Boreal with the isolated mask and Scrub with no overlay.

### 6.5 Mountains and hills — 0x21 / 0x31 + mask

Gated by terrain-byte bit 0x20 on non-water tiles: bit 0x80 set → Mountains, base
0x21; clear → Hills, base 0x31. The 4-cardinal adjacency mask (`func_067BE4`, weights
N=8/S=4/W=2/E=1) counts a neighbour iff its terrain byte satisfies
`(byte & 0xA0) == (own & 0xA0)` — **hills never connect to mountains** and vice versa
(live-confirmed both ways: each renders its isolated frame beside the other).

### 6.6 Rivers and river mouths

**Rivers** (draw at 0x6838A, land tiles): base = **0x01** when terrain-byte bit 0x80 is
set (Major River) else **0x11** (Minor River) (0x6839E/0x683A6); add the 4-cardinal
mask from `func_067B84` (terrain-plane bit 0x40, weights N=8/S=4/W=2/E=1); an isolated
river (mask 0) is forced to mask **0xF** (0x683BB) and drawn `base + mask` (0x683C6).
Because the mask tests only bit 0x40, **major and minor rivers interconnect** (a minor
river joins an adjacent major run), and a land river beside plain ocean counts no
connection there (it renders isolated) — both live-confirmed.

**River mouths** (water tiles, 0x68524..0x685AC): a *water* tile carrying its own
river bits (`terrain & 0xC0`, latched at 0x68206 before the beach-halo substitution)
draws base = **0x8D** if its bit 0x80 is set (major) else **0x91** (0x68524:
`AND 0x80; CMP 1; SBB; AND 4; ADD 0x8D`), then for each cardinal d = 0..3 (N,E,S,W)
draws `base + d` for every neighbour whose terrain byte has bit 0x40 **and** classifies
as non-water. Negative controls confirmed live: ocean with river bits but no land-river
neighbour draws nothing; plain ocean beside a land river draws no mouth.

### 6.7 Coast — beach halo, clean edges, quadrant fallback

`analyse_connections` (`func_067A24`) runs **only for water tiles** (gate 0x68256). It
builds the 8-direction land-neighbour bitmap `[0xA8A6]` (bit d = land, order 0=N, 1=NE,
2=E, 3=SE, 4=S, 5=SW, 6=W, 7=NW; water neighbours 0x19/0x1A skipped) plus a 4-entry
per-quadrant code table.

**Beach-halo ground substitution** (0x67AD4): while walking the cardinals, the routine
*overwrites* `[0xA8A1]` with the folded class of the last cardinal land neighbour seen
(visit order N,E,S,W — **W wins**), and reclassifies `[0xA8A2]` (0x67B10). O513
therefore grounds a coastal water tile with the *neighbour's land terrain*, draws the
coast frames over it, and finally backfills water through the frames' 0-index holes
(`func_067EEC` masked fill). The code-0 quadrant frames (disk 0x6C–0x6F) are all-zero
"punch-throughs" that exist precisely to punch water through the substituted ground.

**Clean edges** (0x68474..0x6850D): default pattern −1, then four tests on `[0xA8A6]`
assign the pattern and the draw is `0x97 + pattern`:

| pattern | mask test | frame | edge |
|---|---|---|---|
| 0 | `& 0xDD == 0xC1` | 0x97 | NW land corner |
| 1 | `& 0x77 == 0x07` | 0x98 | NE land corner |
| 2 | `& 0x77 == 0x70` | 0x99 | SW land corner |
| 3 | `& 0xDD == 0x1C` | 0x9A | SE land corner |

All four are drawable (engine 0x97..0x9A = disk 150..153, the 16×16 shoreline edges);
a 2×2 lake exercises all four, pixel-exact.

**Quadrant fallback** (no clean pattern, 0x684BC..0x684F5): for q = 0..3
(TL, TR, BR, BL) draw the 8×8 frame **`0x6D + code[q]·4 + q`** at the quadrant's
sub-cell offset. The quadrant code (built at 0x67ABD..0x67AEF) ORs, per quadrant:
**|=4** for its own cardinal (N,E,S,W for q0..q3), **|=1** for the next-clockwise
cardinal, **|=2** for its diagonal — maximum 7. All four quadrants draw
unconditionally (code 0 ⇒ frame `0x6D + q`, the punch-throughs) for any water tile
with ≥1 land neighbour that escapes the clean patterns. The reachable band is
0x6D..0x8C, all 8×8; a single-tile lake yields codes 7,7,7,7 → frames
0x89/0x8A/0x8B/0x8C, pixel-exact.

### 6.8 Roads — 0x51, then one frame per direction

Draw at 0x68417, gated: feature byte & 0x0A, mode `[0x18E]` == 0, non-water. The 8-dir
mask comes from `func_067D54` over the feature plane (bits 0x0A). **Mask 0 → the single
isolated frame 0x51; otherwise ONE FRAME PER SET BIT, `0x52 + d`** for each set
direction d (0=N, 1=NE, … 7=NW) — *not* a combined-mask frame. The road band is
0x51..0x59 only. (Byte-decoded; road pixels are not reachable from crafted map files
because the loader discards the feature plane — §7.1.)

### 6.9 The detail band 0x5A — the position hash IS prime resources

Sites 0x682B2 (open water), 0x683F7 (land), 0x685D6 (coast water), each gated
`[0x18A] == 0` (suppressed in the colony scene panel). The hash (`func_0060A0`, with
salt word `[0x190]`; salt 0 disables the band):

```text
v = (x & 3)*4 + (y & 3)
h = ((y >> 2)*3 + (x >> 2) + salt - forest) & 0xF     ; forest = 1 for ids 8..0x17
draw 0x5A + DTAB[class]   iff  h == v  or  (h ^ 0xA) == v
```

`class` uses the **full id decode including the relief bits → 27/28** (`func_0624E`
semantics; the plain `& 0x1F` reading was falsified by live pixels — mountains draw
the ore/gold sprite 0x66 = 0x5A+DTAB[27], hills the rock 0x67 = 0x5A+DTAB[28]).
The per-class table DTAB is the word array at **DS:0x192** (29 entries; runtime-read
from the live game, pixel-verified):
`[0,1,2,3,4,5,6,6, 9,1,8,9,10,10,6,6, <dup of 8..15 for raw 16..23>, −1 (Arctic),
7 (Ocean), −1 (Sea Lane), 12 (Mountains), 13 (Hills)]`; entry −1 = no detail, entry
value 0 is replaced by 6. Feature-plane bit 0x04 suppresses the detail unless the table
value is 12 (then `0x5A + 0`); tiles owned by a village (feature bit 2 with
continent-plane owner ≥ 4) draw none.

**This hash is the prime-resource mechanism**: a hash-hit tile is what the sidebar
reports as e.g. "(Prime Tobacco)" — procedural, never stored in the map
(live-corroborated).

### 6.10 Surf / rumor circle — 0x68

Frame 0x68 is the rumor circle, drawn on the land path after the detail band
(0x68405..0x68414) when the rumor hash (`func_006188`) hits:

```text
((y >> 2)*0x13 + (x >> 2)*0x11 + salt + 8) & 0x1F) - ((x & 3)*4) == (y & 3)
```

Suppressed for classes 0x18/0x19/0x1A and — the live-verified owner gate
(`func_005DF0` family) — whenever the continent-plane **owner nibble ≠ 0xF** (so land
claimed by a village never shows a rumor circle).

### 6.11 Unexplored tiles and the O512 edge/fog blends

A hidden tile (hidden flag `[bp-8]` from fog mask `[0xA89E]` + tile fog byte
`[0xA8A0]`, 0x681E0..0x681FE, tested at 0x6820C) draws **frame 0x95 — the
fog/unexplored tile** (0x68212), then calls O512 for the fog-edge blend. 0x95 is *not*
a coast sprite, and 0x69..0x6C are fog-edge/blend stencils, not coast.

**O512 (`func_067F50`)** loops the 4 cardinals (dx `[0,1,0,−1]` / dy `[−1,0,1,0]` =
N,E,S,W, tables at DGROUP 0xA8/0xAE). Per neighbour: bounds test (engine coordinate 0
IS in bounds — plane column 1; upper bound engine width−2), read + fold its terrain,
classify, read its fog state. **Water-neighbour ring-walk** (enabled only when arg2
= 0): walk the neighbour's own 8-ring counting *down* — even (cardinal) indices only,
order **W → S → E → N — first non-water wins** — and use that land class as the blend
class; this produces the land-side dithered beach. Skip the edge when the neighbour is
still water after the walk, or when neighbour class == centre class with the neighbour
visible. Otherwise draw `0x69 + dir` — a sparse index-0 dot stencil (disk 0x68..0x6B =
N,E,S,W) stamped into the mask buffer 0x839E — then masked-blit the neighbour's
terrain through it (`emit_terrain_sprite`, `func_067EEC`; plain thunk, or the scaled
variant when `[0x184] ≠ 0`). Net effect: the neighbour's terrain bleeds into this
tile's edge as a dither gradient — every biome transition, the coast's land side, and
the fog boundary all come from this one composer.

**The two O512 call sites in O513** (args: hidden, disable-ring, third 0):
- fog path 0x68244, after the 0x95 draw: `O512(1, centre_is_water, 0)` — blends
  explored neighbours into a fogged tile's edge;
- main path 0x68315: `O512(0, centre_is_water, 0)` — so land centres run with the
  ring-walk enabled (beach dither), water centres with it off (their coast is the §6.7
  composition).

### 6.12 Zoom scaling

The zoom level `[0x184]` runs 0..3. Viewport setup (`func_06787C`): span
`[0x8544] = 15 << zoom`, `[0x8546] = 12 << zoom`, tile pitch `[0x5AD4] = 16 >> zoom`;
sprite scale `[0x186] = 100 >> zoom` (0x679F4) — blits go through the plain thunks at
scale 100 and the scaled variants otherwise. Zoom 0..3 = 15×12 @16 px, 30×24 @8 px,
60×48 @4 px, 120×96 @2 px.

## 7. Runtime map state and the map screen periphery

The playing board lives in four parallel byte planes addressed through far pointers in
the data segment, drawn into a 320×200 Mode 13h screen whose left three-quarters is the
tile viewport and whose right edge is a woodgrain sidebar with minimap, status lines and
the selected-unit panel. This section pins the live memory layout, the fog model, the
screen geometry, and the colony screen's scene panel (which reuses the §6 compositor).

### 7.1 The live map planes

Four far pointers hold the planes (runtime-verified against live memory):

| pointer | plane | contents |
|---|---|---|
| `[0x15C]` | terrain | terrain byte (§5.4 encoding) |
| `[0x160]` | feature | bit 0 unit present, bit 1 settlement; road bits 0x0A; rebuilt by the game — the map-file feature layer is DISCARDED at load |
| `[0x164]` | continent/owner | low nibble continent, high nibble owner (0xF = none; village-owned land 5..0xA) |
| `[0x168]` | flags | low nibble = colony-site value |

Each plane is row-major, **stride 58**, with tile (0,0) at segment **base + 0x10**.
Three coordinate frames coexist: *plane* coordinates (0..57 × 0..71, including the
border ring), *engine* scroll-space `[0xA5A0]`/`[0xA5A2]` = plane − 1, and the
**sidebar "Locat:" display, which shows the plane index (= engine + 1)**. O514's
`(y+1)·stride + (x+1)` indexing (§6.1) converts engine to plane coordinates.

### 7.2 Fog and Reveal Map

The per-tile fog byte holds one bit per power in bits 4–7; the render mask is
`[0xA89E] = 1 << (player + 4)` (0x685F2) — explored-by-power-3 = bit 7 = 0x80, matching
runtime dumps. **Reveal Map** (cheat menu, enabled by Alt-W, I, N; the "Reveal Map →
Complete Map" row) sets the full-view flag `[0x53A2] = 1` and zeroes the fog mask
`[0xA89E]`; per-tile fog bytes are left untouched, and O513's mask==0 path then treats
every tile as visible.

### 7.3 The map screen — regions, fonts, keys

```python
regions = [
    (0,   0,   320, 9,   "Menu strip",          "text",  "wood fill; pulldown titles"),
    (0,   8,   240, 192, "Map viewport",        "art",   "15<<z x 12<<z tiles at 16>>z px"),
    (241, 8,   79,  41,  "Minimap",             "art",   "1 px/tile window + white viewport rect"),
    (240, 72,  80,  64,  "Season/Gold/Tax",     "text",  "FONTTINY line stack"),
    (240, 136, 80,  64,  "Selected-unit panel", "text",  "unit sprite + @INFO labels"),
]  # 320x200 Mode 13h
```

| Region | Bounds | Kind | Content source | State binding |
|---|---|---|---|---|
| Menu strip | (0,0,320,9) | text | menu titles `@GAME @VIEW @ORDERS @REPORTS @TRADE @CUP @PEDIA` | pulldown state |
| Viewport | (0,8)–(240,200) | art | §6 compositor | scroll `[0x8328]`/`[0x832E]`, zoom `[0x184]` |
| Minimap | (241,8,79,41) | art | `func_066CD6` (§7.4) | scroll window, fog, owners |
| Status lines | (240,72,80,64) | text | season/year, Gold, Tax (§7.5) | year `[0x538A]`, power record |
| Unit panel | (240,136,80,64) | text | Moves/Locat/type/skill/orders/terrain | selected unit record |

Fonts/inks: menu strip FONTTINY in green RGB (82,138,49); sidebar text FONTTINY in
white, palette index 0x0F (set at 0x76C85); sidebar x-origin `[0x8550]` = 240 (0x71039).
The UI colour slots at DS:0x830.. are loaded from the data file's `@COLORS` line — nine
palette-index bytes 68,149,8,128,47,138,134,128,138 (basic, hilite, grey, enhance,
shadow, select, border0..2) written to 0x830..0x839 (0x836 skipped), at 0x751A2..0x751E7.

Viewport zoom table (§6.12): **15<<z × 12<<z tiles at 16>>z px**, z = `[0x184]` ∈ 0..3
= 15×12@16 / 30×24@8 / 60×48@4 / 120×96@2. In VICEROY these are the four VIEW-menu
"Zoom Level" entries (plus zoom in/out); the stand-alone map editor binds the same four
spans to F1..F4 (`F1` = z3 120×96 … `F4` = z0 15×12, handler `_set_zoom_level(0x29−id)`
at its 0x30D8, clamp 0..3).

Navigation/keys: menu pulldowns per the seven titles above; REPORTS F2–F10 open the
advisor screens; VIEW menu zooms; F1 opens the terrain-information popup (shared
WOODPANL popup framework, `func_06F0F4`); click an own colony tile → colony screen;
click a foreign colony → the sidebar trade variant.

### 7.4 Minimap

`func_066CD6`: panel box (0xF1, 8, 0x4F, 0x29) = **(241,8,79,41)**, byte-verified at
0x66CF4. Contents are **1 pixel per tile** — a 56×39 scrolling window over the map, not
the whole map squashed. Per-tile dot colour from the DS:0x830 slot table: `[0x830]`
ocean/coast, `[0x831]` land, `[0x832]` fog (fog byte & 0x80), `[0x833]` owned
(& 0x20); the current-viewport rectangle is drawn in white (index 0x0F) — at zoom 0 a
15×12 rect, which independently confirms the zoom-0 span. The per-cell writer
(`func_066968`) writes single bytes per tile at x = col − `[0x9CCC]` + 252,
y = row − `[0x9CCA]` + 9, pitch `[0x2DAA]`.

### 7.5 Sidebar HUD

Status block (240,72,80,64), FONTTINY, white 0x0F: a three-line stack —
**season + year** (season names from `@SEASONS`: Spring/Autumn; year global `[0x538A]`,
banded `(year − 1500)/50` at 0x51F1F), **Gold: N** (power record +0x2A), **Tax: N %**
(power record +0x01); label strings from the `@MISC`/`@INFO` sections via the string
resolver. The line composer is `func_067700`; the per-line y-offsets are emitted through
a runtime-installed far pointer (`[0xA644]` = 0x1A1F:0x0F10, installed at 0x7730C) — a
true runtime indirection; the line stack itself is pixel-verified against the running
game. Selected-unit panel below at y=136: unit sprite, then Moves / Locat / unit type /
skill / orders / "(terrain)" lines (unit record stride 0x1C via `func_0672C8`; type and
skill names from the `@UNIT`/`@JOB` sections; Locat shows plane coordinates, §7.1).
Per-line coordinates beyond the stack order are (measured; not byte-cited):
season/year at (244,58), Gold (244,66), Tax (290,66), unit sprite (244,80),
Moves (270,82), Locat (270,92), type (244,104), skill (244,112), orders (244,120),
terrain (244,128).

### 7.6 The colony screen scene panel — the same compositor at ×1.5

The colony screen's terrain vignette is the §6 map compositor rendering a **5×5 tile
neighbourhood of the colony at native 16 px, then upscaled ×1.5 with an ordered
dither** — there is no dedicated 24-px tileset. Chain (`func_026374` at 0x26374):
scene latch `[0x18A]` = colony pointer (0x6891E); viewport forced 5×5, zoom `[0x184]`=0,
pitch 16, scale 100, origin = colony − (2,2), screen offset 0 (0x67894..0x67912); the
master loop `func_0685DC(cx−2, cy−2, 5, 5, power)` paints an **80×80** image on surface
0x839E — same painter, with map unit glyphs and the detail band suppressed by the scene
latch. Colony markers (ICONS frames 1..4 + pennant 0x77+power, population number and
name iff `[0x890]` == 0) and unit markers are drawn on the 80×80 *before* the upscale.
Then `func_00531C` (0x263A9..0x263D6) stretch-copies (0,0,80,80) → **(200,8,120,120)**,
duplicating every 2nd pixel and every 2nd row (exact 2→3 scaling) and passing every
written pixel through the positional 4×4 dither `func_005296` (`(dstoff&3) + (row&3)·4`),
which jitters the palette index within its 16-colour ramp for palette rows 0x10..0x87 —
deterministic, no RNG. The **visible panel (224,32,72,72) is the central 3×3 tiles** of
the 5×5 at 24-px pitch (the outer ring is overdrawn by the right-panel fill). Worker
sprites are added *after* the upscale at x = cell·24 + 252, y = cell·24 + 60 (signed
cell −2..+2), sprite `0x5A +` detail value, from PHYS0.SS.

---

## 8. Colonies

Every colony is a fixed-size 202-byte record in a single DGROUP array. The record
carries the colony's position, name, owner, population, profession roster,
constructed-building bitmask, warehouse stockpile, and the Sons-of-Liberty bell
pool; everything the colony screen draws is derived from it plus a handful of BSS
scratch tables rebuilt on screen entry. The most surprising subsystem — fully
byte-verified and replay-validated — is that the on-screen *placement* of the
colony's buildings among the 15 plots is produced by a deterministic RNG shuffle
seeded from the colony's map coordinates.

### 8.1 ColonyRecord

The colony table lives at `DS:0x5D46`, stride `0xCA` (202 bytes); the live count
is the word `[0x539E]`, capped at 48 (`cmp [0x539E],0x30` at 0x2EB82). The
currently-active colony is the **near pointer `[0x8542]`**, written by the
set-active-colony routine at 0x8302..0x830B (`imul bx,idx,0xCA; add bx,0x5D46;
mov [0x8542],bx`). Slots are recycled: a razed colony's slot is reused for the
next founded colony, and slot validity is determined by a non-empty name at
`+0x02`. Live-verified in the running game: `*[0x8542]` → a record decoding as
`(51,29) "Jamestown"`, exactly `0x5D46 + 4·0xCA`.

```c
typedef struct {                 // array DS:0x5D46, stride 0xCA; active = *[0x8542]
    uint8_t  map_x;              // +0x00: tile column (live-verified)
    uint8_t  map_y;              // +0x01: tile row
    char     name[24];           // +0x02..+0x19: NUL-terminated colony name
    uint8_t  owner;              // +0x1A: 0 English 1 French 2 Spanish 3 Dutch;
                                 //        <4 = European test at 0x830F
    uint8_t  status_1B;          // +0x1B: numeric prefix of the foreign-title
                                 //        builder (zero-padded append at 0x26915)
    uint8_t  flags_1C;           // +0x1C: bit flags — colony-marker population-number
                                 //        colour (0x00448B..0x0044A4) and
                                 //        centre-tile yield bits (0x00A32F/0x00A339)
    uint8_t  _pad1D[2];          // +0x1D..+0x1E unmapped (2 bytes)
    uint8_t  population;         // +0x1F: colonist count (burn-loot formula 0x05DE1E;
                                 //        plaza-row count 0x0270E6)
    uint16_t flags_20;           // +0x20: (measured; not byte-cited — observed 0x1002;
                                 //        foreign-colony marker byte in low half)
    uint16_t state_22;           // +0x22: (measured; not byte-cited)
    uint8_t  _pad24[0x1C];       // +0x24..+0x3F unmapped (28 bytes)
    uint8_t  professions[0x30];  // +0x40..: one @JOB byte per colonist
                                 //        (live length = population; context-help
                                 //        reads the +0x40 profession field at
                                 //        0x02BD90; bytes past the roster up to
                                 //        +0x6F are unmapped)
    uint8_t  tile_worker[8];     // +0x70..+0x77: colonist index working each
                                 //        surrounding tile, 0xFF = unworked
                                 //        (worked-slot test func_008956 reads
                                 //        +0x70+slot against the offset tables
                                 //        DS:0xC8/DS:0xDE)
    uint8_t  _pad78[0x0C];       // +0x78..+0x83 unmapped (12 bytes)
    uint8_t  buildings[6];       // +0x84..+0x89: 42-bit constructed mask, bit i =
                                 //        building id i (reader func_0860E:
                                 //        byte = rec+0x84+(id>>3), bit = id&7;
                                 //        setter func_092E0 at 0x9308;
                                 //        build-complete write at 0x02D19A)
    uint8_t  _pad8A[2];          // +0x8A..+0x8B unmapped
    uint8_t  title_num[4];       // +0x8C..+0x8F: four numeric fields appended by the
                                 //        foreign-owner title builder (0x26942)
    uint16_t field_90;           // +0x90: (measured; not byte-cited)
    uint8_t  _pad92[2];          // +0x92..+0x93 unmapped
    uint8_t  cargo_94;           // +0x94: cargo-holds datum read by the colony
                                 //        cargo panel (func_027746)
    uint8_t  warehouse_level;    // +0x95: Warehouse Expansion counter (building id
                                 //        0x10 has NO bit — it increments this)
    uint8_t  capitol_level;      // +0x96: Capitol Expansion counter (building id 0x1F)
    uint8_t  _pad97[3];          // +0x97..+0x99 unmapped
    uint16_t stockpile[16];      // +0x9A..+0xB9: warehouse quantity per good,
                                 //        @CARGO order (runtime-verified against the
                                 //        stockpile bar func_0281D6)
    uint16_t counter_BA;         // +0xBA: counter pair lo/hi (measured; not byte-cited)
    uint16_t counter_BC;         // +0xBC: (measured; not byte-cited)
    uint8_t  marker_frame;       // +0xBE: map-marker frame byte (marker painter
                                 //        func_004314 at 0x004385)
    uint8_t  _padBF[3];          // +0xBF..+0xC1 unmapped
    int32_t  sol_numerator;      // +0xC2: rebel bell pool (accumulated + clamped to
                                 //        the cap at 0x02DAC6..0x02DAD4)
    int32_t  sol_denominator;    // +0xC6: bell cap = decay + population·2
                                 //        (0x02DA1C..0x02DA6F); founding init
                                 //        +0xC6=100, +0xC2=0 at 0x02EC26
} ColonyRecord;                  // sizeof = 0xCA (202)
```

Sons of Liberty percent = `sol_numerator·100 / sol_denominator` (32-bit multiply
0x008557 + divide 0x00855E in `func_008524`; 0 if the denominator ≤ 0 at
0x008542), then +20 for a human-controlled colony (latch `add ax,0x14` at
0x00859F, gated on `owner<4`), clamped to 100 (0x0085A8..0x0085AD).

### 8.2 Building construction state and upgrade chains

The 42 building definitions of NAMES.TXT `@BUILDING` load into a stride-12
record table at `DS:0x8F82` (name pointer +0, prerequisite/predecessor +3,
chain successor +4, category byte at `0x8F87+id·12`, loaded at 0x74D2F). A
constructed building sets its bit in `ColonyRecord +0x84` (`func_092E0`,
`or [bx],al` at 0x9308) **without clearing the predecessor's bit** — upgrade
tiers coexist as bits and the highest tier present wins for render and
production (build-complete handler at 0x02D19A confirms: set only, no clear).
Two definitions have no bit at all: **Warehouse Expansion (id 0x10)** increments
the counter `+0x95` and **Capitol Expansion (id 0x1F)** increments `+0x96`.
School ids: Schoolhouse 0x0C, College 0x0D, University 0x0E.

Chain walking uses the `0x8F82` fields: prerequisite line shown when
`byte 0x8F82[id]+3 ≥ 0`; the upgrade-chain loop steps `next = byte 0x8F82[b]+4`
while ≥ 0 (Colonizopedia building/skill pages, 0x06A89C..0x06A947 and
0x06AD3C..0x06AD9F).

### 8.3 Worker/building byte tables

Two static DGROUP byte tables bind buildings to professions:

- **Building → job**: `DS:0x2CA` (file 0x1DC6A), 42 signed bytes, read through
  `func_009786` (`0x181F:0xACE`). Byte-verified entries: ids 3–5 → 0x0F Gunsmith,
  9–11 → 0x11 Statesman, 21–23 → 0x0B Weaver, 27–29 → 0x09 Distiller, 35–36 →
  0x0D Carpenter, 37–38 → 0x10 Preacher, 39–41 → 0x0E Blacksmith. Jobs 0x12
  (Teacher) and 0x15 are skipped by the pedia header renderer.
- **Job → building**: `DS:0x2F4` (file 0x1DC94), 19 signed bytes, read through
  `func_008D9C` (`0x181F:0xB00`). Jobs 0–8 (the nine outdoor field jobs) → −1
  (no workplace building); job 0x0D → 35 Carpenter's Shop, 0x0F → 3 Armory,
  0x11 → 9 Town Hall, etc.

### 8.4 Colony-screen building placement — the RNG layout algorithm

The colony view has **15 fixed plots** in the upper-left town area. Which
building occupies which plot is computed on every colony-screen paint by
`func_025D34`, a deterministic random shuffle. The whole chain is byte-verified
and was validated by exact replay: re-implementing the algorithm below
reproduces the live game's Jamestown layout with every sprite pixel-exact
(pixel-verified against the running game, 1994 binary under DOSBox).

**Plot position table** — static at `DS:0x266` (file 0x1DC06), 15 × (word x,
word y); the renderer draws at `(x, y+8)` (the +8 applied once, at 0x02708B —
applying it twice is a documented replay bug):

| plot | x | y (table) | y on screen | plot | x | y (table) | y on screen |
|-----:|----:|----:|----:|-----:|----:|----:|----:|
| 0 | 56 | 5 | 13 | 8 | 128 | 45 | 53 |
| 1 | 145 | 7 | 15 | 9 | 10 | 68 | 76 |
| 2 | 173 | 10 | 18 | 10 | 15 | 94 | 102 |
| 3 | 8 | 33 | 41 | 11 | 87 | 3 | 11 |
| 4 | 37 | 37 | 45 | 12 | 66 | 79 | 87 |
| 5 | 67 | 46 | 54 | 13 | 123 | 98 | 106 |
| 6 | 96 | 45 | 53 | 14 | 123 | 47 | 55 |

**Plot categories** — static counts `byte[0x224] = [7,4,2,1,1]` and bases
`byte[0x22A] = [0,7,11,13,14]` (file 0x1DBC4/0x1DBCA): category 0 = plots 0–6,
1 = plots 7–10, 2 = plots 11–12, 3 = plot 13, 4 = plot 14. The per-plot category
table `0x8D62` is rebuilt each open as `[0,0,0,0,0,0,0,1,1,1,1,2,2,3,4]`
(0x025D7B..0x025DB8).

**The RNG.** Three byte-verified pieces:

```text
seed:   func_009726 (0x181F:0xD62; sole caller func_025D34 @0x025D3A)
        seed32 = (colony_map_y << 8) + colony_map_x + dword[0x8D80]   @0x009736
        srand @0x103C2 keeps only the LOW 16 BITS of the seed:
        mov [0x28EE],ax ; mov word [0x28F0],0   -- effective seed space is 16-bit

rand:   @0x103D4 (MSC 6.0 LCG; bytes B8 FD 43 BA 03 00 ... 05 C3 9E / 83 D2 26)
        state = state·0x000343FD + 0x00269EC3    (32-bit, state at [0x28EE]/[0x28F0])
        return (state >> 16) & 0x7FFF

random_int(lo,hi):  func_00C322 (0x181F:0x4D4)
        r = rand(); return lo + ((r · (hi−lo+1)) >> 15)   @0x00C334
```

`[0x8D80]` is a **per-session dword** set at boot init: it read 0x2C55 in one
live session and 0x5B7C in a fresh boot (its writer is unlocated — runtime-open).
It is constant within a session, so a given colony always lays out the same way
during play; the pure map-position seed alone does *not* reproduce a layout
(exactly 2 of 65536 16-bit seeds reproduced the validated capture).

**Registration groups.** The building-definition registration block at 0x0746BC
issues 42 calls (one per id) through the far trampoline at 0x76384 →
`func_07464C`, assigning each id to one of **15 groups** — one screen slot per
group:

| group | ids | buildings | cat |
|---:|---|---|---:|
| 0 | 0–2 | Stockade / Fort / Fortress | 3 |
| 1 | 3–5 | Armory / Magazine / Arsenal | 1 |
| 2 | 6–8 | Docks / Drydock / Shipyard | 4 |
| 3 | 9–11, **30–31** | Town Hall ×3 + **Capitol / Capitol Expansion** | 2 |
| 4 | 12–14 | Schoolhouse / College / University | 1 |
| 5 | 15–17 | Warehouse / Warehouse Expansion / **Stable** | 1 |
| 6 | 18 | Custom House (alone) | 0 |
| 7 | 19–20 | Printing Press / Newspaper | 0 |
| 8 | 21–23 | Weaver's House / Weaver's Shop / Textile Mill | 0 |
| 9 | 24–26 | Tobacconist's House / Shop / Cigar Factory | 0 |
| 10 | 27–29 | Rum Distiller's House / Rum Distillery / Rum Factory | 0 |
| 11 | 32–34 | Fur Trader's House / Fur Trading Post / Fur Factory | 0 |
| 12 | 35–36 | Carpenter's Shop / Lumber Mill | 1 |
| 13 | 37–38 | Church / Cathedral | 2 |
| 14 | 39–41 | Blacksmith's House / Shop / Iron Works | 0 |

The **category** of a group is NAMES `@BUILDING` numeric **column 3** of its
first (representative) id, loaded to `0x8F87+id·12` at 0x74D2F. Over the 15
representatives the category histogram is exactly `[7,4,2,1,1]` — matching the
plot counts. (The histogram over all 42 defs is 19/10/7/3/3 and does NOT match;
an early decode tripped over that.) The group table is *not* `floor(id/3)`:
Capitol 30/31 shares group 3 with Town Hall, Stable 17 sits with Warehouse in
group 5, Custom House 18 is alone, and Fur Trader's House 32 opens group 11.

**Placement loop** (0x025DDB / 0x025DBF..0x025E07): after seeding, each of the
15 work-list slots (flattened category order: 7 cat-0 slots, 4 cat-1, 2 cat-2,
1 cat-3, 1 cat-4) picks a plot within its category block:

```text
plot = base[cat] + random_int(0, count[cat]−1)
if plot already taken (0x8E92[plot] ≥ 0): retry     -- draw again, same range
0x8E92[plot] = slot                                 -- plot → slot map
```

i.e. a random permutation within each static category block. Then the 42
building defs are each mapped to their group's slot (0x025E0E..0x025E5A), and
for every building the colony actually **has** — the present-gate query
`0x181F:0x9FC` per id at 0x025E64 — the plot's def table gets
`0x8E82[plot] = building id` (0x025E9F); unbuilt plots stay `0xFF`.
**Id 0 (Stockade) is force-included** regardless of the query (0x25E70), so
every colony renders something on the cat-3 plot. A later pass at 0x025E1A uses
the `0x8F88` chain/produced-good column to assign goods — it plays no part in
plot selection.

**Frame selection** (`func_026DD4`, 0x026DD4..0x026FF1): for an occupied plot
the BUILDING.SS frame is `def_id + 1` in EXE-sheet space (`mov ax,[bp+6]; inc ax`
at 0x026DE5..0x026DE9), blitted via `0x181F:0x254` at 0x026E4E. Overrides, all
byte-read: `def_id==0` with build-query(0)==0 ⇒ frame **0x11** (0x026DEC);
`def_id==0x0F` / `0x11` with garrison queries ⇒ frames **0x2F / 0x30**
(0x026E05..0x026E34). The Colonizopedia building page applies the same
`id 0x11 → frame 0x2F` override (0x06AB62). Empty plots (`def < 0`) are drawn by
`func_026FF2` with the terrain-decoration frame `byte[DS:0x260 + category]`
(table `[45,44,43,0,46]` — category 3 draws nothing), skipped when the byte is 0.
Live verification (Jamestown): 8 buildings at plots {2,3,4,5,6,10,12,13} with
def-ids {0x20,0x1B,0x27,0x18,0x15,0x23,0x09,0x00}, every frame pixel-exact.

### 8.7 Sons of Liberty — the full pipeline

The displayed percent is `func_008524` (0x8524..0x85B1, thunk `0x181F:0xC86`):
`SoL% = (sol_numerator · 100) / sol_denominator` (multiply 0x8557, divide
0x855E; denominator ≤ 0 returns 0), **+20** when the owner is a human European
holding FF op 0x12 (0x859F; the op is glossed both "Jan de Witt" and
`@FATHERS` #18 Bolívar in-repo — flagged), clamped to 100 (0x85A8).

The two accumulators update once per colony turn in `func_02D658`
(0x2DA1C..0x2DAD8): the cap decays `B −= B>>6`, floors at 1, then
`B += 2·population`; the pool decays and accrues `A += new_bells − (A>>6)`,
floors at 0, and clamps `A ≤ B` — so the percent is structurally ≤ 100.
Founding init is `B = 100, A = 0` (0x02EC26..0x02EC38; runtime-confirmed
B = 200 for a pop-1 colony after one turn). `new_bells` is the colony's bell
production, halved-and-negated for the tory-leader power during the war
(0x2D9DF..0x2D9F2) and dragged down by `population/20` when population exceeds
bells (0x2DA12..0x2DA18). Derived steady state: `SoL% → min(100,
50·bells/pop)` — 100% needs bells ≥ 2·population.

**Consumers**, each byte-cited: combat scales strength by `SoL%/100`
(0x05CF98; analysis rows Rebel Unrest +SoL% / Tory Unrest −(100−SoL%));
production applies `sol_adj = −(tory_cnt/(10−diff))` with the `+0x1C` latches
(§5.8); the colony status messages latch at 50%/100% edges
(`@REBELMAJORITY` 0x2DB29, `@REBELUNANIMOUS` 0x2DB6E, tory reverses, decade
`@SONSUP`/`@SONSDOWN`); `INEFFICIENT` fires when the tory count reaches
`10−diff` (0x2DCE4); the colony screen derives member count =
`pop − round(tory%·pop/100)` (0x0273F4..0x02740E); and the **national meter
`[0x53D0]`** gates the Declaration at ≥ 50 (0x3E99E, `@TOOTORY` below), arms
the Spanish Succession below 75 (§18.7), takes +20 from Bolívar's acquisition
(0x3BE64), and feeds the King's demand-severity score (0x361F9) and the final
score (0x03A561). How the per-colony percents aggregate into `[0x53D0]` is
behind untraced overlay calls (`0x1A1F:0x134`) — TBD.

## 9. Market and trade

The European market is per-power state inside the PowerRecord (stride 0x13C,
European powers at `DS:0x8808` + power·0x13C; active-power pointer `[0x84FC]`).
Prices are not a fixed table: the per-good base is random-seeded at game start
and then driven by a per-turn decay plus per-transaction updates, with the four
manufactured luxuries coupled through a shared supply pool.

### 9.1 Per-power money and market state

| field | type | meaning |
|---|---|---|
| `+0x01` | u8 | **tax rate** (0..100) — read at 0x031043 for the Europe banner; raised by King events |
| `+0x1E` | u16 | artillery-bought counter (Europe artillery price escalation: `cost = base + count·100`, read ×100 at 0x035124/0x03527B, `inc` at 0x035282, zeroed at new game 0x03662F) |
| `+0x20` | u16 | **boycott bitmask**, bit = good index. Test `func_030B38` (`(1<<good) & [bx+0x20]`); set at 0x34717 (Tea Party); back-tax lift at 0x3340C (`&= ~bit` after paying price×500 into the King fund `+0x22`); **Jakob Fugger** (Founding Father id 1) clears the whole word to 0 at 0x3BD45 |
| `+0x22` | s32 | King's REF fund (receives sale tax) |
| `+0x26` | s32 | sales tally (net proceeds accumulator) |
| `+0x2A` | u32 | **gold (treasury)** — every credit goes through the clamp helper at 0x8806: add s32, clamp to [0, 999999] |
| `+0x4C` | u8[16] | per-good **price level** (indexed by good; step-up `+=1` at 0x32272, step-down `−=1` clamp ≥0 at 0x3228D) |
| `+0x5C` | s16[16] | market pool (drift-only; never touched by the transaction path) |
| `+0x7C` | s32[16] | traded volume (cumulative value) |
| `+0xBC` | s32[16] | European supply per good |
| `+0xFC` | s32[16] | per-good trade accumulator (`@0x8904` in DGROUP terms) — summed by the drift function |

**Displayed bid/ask pair** (Europe price strip, 16-good loop 0x38D40..0x38E3B):
`sell = price_level[good] − 1` (accessor `func_030590`, clamp ≥ 0) and
`buy = CARGO_row[good].col1 + price_level[good]` (accessor `func_030566`,
`mov al,[bx-0x6900]` with bx=good·9 at 0x30575, `add ax,cx` at 0x30587). The
on-screen spread is therefore the per-good constant `@CARGO` column 1 + 1:
Food 1, Sugar 4, Tobacco 3, Cotton 2, Furs 4, Lumber 2, Ore 3, Silver 20,
Horses 2, Rum/Cigars/Cloth/Coats 11, Trade Goods 2, Tools 2, Muskets 3.

### 9.2 Goods — `@CARGO`

Good ids 0..15, in NAMES `@CARGO` order (all market arrays use this index):
0 Food, 1 Sugar, 2 Tobacco, 3 Cotton, 4 Furs, 5 Lumber, 6 Ore, 7 Silver,
8 Horses, 9 Rum, 10 Cigars, 11 Cloth, 12 Coats, 13 Trade Goods, 14 Tools,
15 Muskets. Four **extended ids 16..19** are name-only production tokens:
16 Hammers, 17 Crosses, 18 Liberty Bells, 19 Flags — never traded, used for
production display (icon remaps 0x0D→0x37, 0x10→0x39, 0x11→0x3F in the
Colonizopedia product strips). Commodity icons are ICONS frames `good + 0x17`
in EXE-sheet numbering.

### 9.3 Price drift

**Per-turn driver**: the end-of-turn processor `func_0755CC` invokes
`func_036574` at 0x0757B0; it zeroes the per-power accumulators (`+0x5C/+0x7C/
+0xBC/+0xFC` loop at 0x03670E) and runs a **4-power loop** calling the drift
function `func_0305A8` (via the JMP-FAR trampoline at 0x368BD) once per power.
**Per-transaction**: the SELL handler (`func_032914` at 0x32D99) and BUY handler
(`func_0324F2` at 0x32902) each call `drift(good, 0)` — a single-good re-drift
immediately after the trade.

The drift itself (`func_0305A8`, 0x0305A8..0x03064C):

```text
for good in 0..15:                        # @0x305B3
    acc = price_seed[good]                # word table DS:0x53EA (good·2)  @0x305B8
    for power in 0..3:                    # @0x305CE
        v = PowerRecord[power].accum_FC[good]   # @0x305D8
        if v < 0: v = 0                   # @0x305E0
        acc += v                          # 32-bit @0x305F0
    if driver-mode:                       # @0x305FF/0x30605
        price_seed[good] -= acc >> 8      # proportional decay @0x30618..0x30639
```

`price_seed[16]` at `DS:0x53EA` is **randomized at new-game init**:
`func_07561C` fills each entry with `random_int(600, 1000)` (0x75645, loop ×16)
— there is no fixed base-price table. Later phases of `func_0305A8` couple the
luxuries: `S_pair = supply[9]+supply[10]+supply[11]+supply[12]` (Rum, Cigars,
Cloth, Coats; 32-bit adds, clamp ≥ 1, at 0x030649), then for each finished good
`target[i] = (S_pair·3)/supply[i]` (×3 at 0x03074F, 32-bit divide at 0x030759);
the raw inputs 1..4 (Sugar/Tobacco/Cotton/Furs) use the same formula against
their own supply (Furs halved, +1 if year<1700 and +1 if year<1600, at
0x0307C9). Dumping one luxury lowers its own price and nudges the other three
up.

### 9.4 Buy/sell transactions

**SELL** (`func_032914`; args good, screen-idx, confirm):
`gross = price·qty` (0x3249F); tax split at 0x32A4A..0x32A78:
`tax = gross·tax_rate(+0x01)/100`, `net = gross − tax`; gold credit `+net`
through the [0,999999] clamp helper (0x32A82); King fund `+0x22 += tax`
(0x32A92); tally `+0x26 += net` (0x32A9C). **BUY** (six inline sites in the
purchase pages, e.g. Muskets qty 0x32 at 0x526A2, Horses at 0x52790, Tools qty
0x64 at 0x52866): affordability check then inline debit
`sub [bx+0x2A],ax; sbb [bx+0x2C],dx` — **buys are untaxed**.

Both paths call a mirror pair of accumulator updaters (good, qty):

| field | BUY `func_0322D0` | SELL `func_03234A` |
|---|---|---|
| EU supply `+0xBC` | `−= qty` @0x3231C | `+= qty` @0x323B4 |
| accumulator `+0xFC` | `−= qty` @0x32324 | `+= qty` @0x323BC |
| traded volume `+0x7C` | `−= price·qty` @0x32340 | `+= price·qty·(100−tax%)/100` @0x32402 |
| DGROUP pool `[bx−0x779C]` (4 × stride 0x9E) | `−= scaled_qty` ×4 @0x322FF | `+= scaled_qty` ×4 @0x32383 (4th power ×2/3) |

`scaled_qty = ((price_level−2)·16·qty)/100` (helper 0x32294); the `@CARGO`
"spread" column (field 4, `[bx-0x68FC]`) is a per-good left-shift exponent on
qty inside these updaters (`shl dx,cl` at 0x322EA/0x32360), not the display
spread.

On the Europe screen the market bar (0,179,320,21; 16 cells, pitch 0x13, icons
`good+0x17`, bid price centred at y=194) routes clicks to the sell handler,
which first tests the boycott bit and blocks with a message if set. Recruit
gold cost comes from the recruit-pool slot word at `DS:0x978C + slot·6 + 4`
(read 0x051E52/0x035114) — for Artillery (colonist type 0x0B) it escalates
`base + artillery_bought·100`.

## 10. The native economy

Each Indian settlement prices its trade through a single routine,
`func_048F34` (file 0x048F34..0x0495FF), which fills two 16-word DGROUP arrays
— `0x9E58[16]` per-good **demand** and `0x9E78[16]` per-good **supply**, in
`@CARGO` order — for the active settlement. It runs in three phases and its
outputs feed the village trade dialog, the food beg/gift events, and the haggle
price. The routine also contains the cheat-menu "Supply and Demand (Indians)"
debug dump, gated on debug bit `[0x894] & 4`.

Inputs: the active NativeSettlement record (pointer `[0x8D4A]` family; `+0x03`
flags bit 4 = capital, `+0x04` population) and the active TribeData record
(pointer `[0x8D4E]`; `+0x02` = tribe tier). `N = population + 1` (0x049242),
`tier = tribe[+2]`.

### 10.1 Phase A — colony-claimed-tile mask (0x048F3C..0x049049)

A 25-byte mask marks which tiles of the settlement's 5×5 neighbourhood are
worked by a European colony (those tiles contribute nothing). For each colony
0..`[0x539E]` (selected via `0x181F:0x9E6` → `[0x8542]` at 0x04903A), each
settlement-relative cell (a,b) is mapped to colony-relative coordinates
(0x048F92..0x048FBA); if within the colony's 5×5 (0x048FCC..0x048FE2) the
centre (2,2) is special-cased (0x048FE4) and otherwise the worked-slot test
`func_008956` (`0x181F:0xCE0`, reading `ColonyRecord+0x70+slot`) decides;
matches set `mask[a·5+b] = 1` (0x049002). **Original bug (byte fact)**: the
in-bounds call at 0x048FC0 passes *relative* coordinates (x′−2, y′−2) to
`func_005BFA`, which tests **absolute** bounds `1 ≤ x < map_w−1` — Phase B
passes absolute coordinates correctly (0x04913D).

### 10.2 Phase B — 5×5 terrain point scan (0x04904A..0x049241)

Terrain id per tile via `0x181F:0x78C`. Contributions accumulated per tile:

| terrain | contribution | site |
|---|---|---|
| Mountains (27) | mountains counter +1 | 0x049190 |
| Hills (28) | hills counter +1 | 0x049199 |
| Arctic (24) | cold +4 | 0x0491A2 |
| Forested 8..23 | food/game point; base = t−8 (or t−16); base<3 ⇒ cold-forest counter, else warm-forest: sugar/tobacco/cotton +2 | 0x0491AB..0x04921F |
| Savannah | sugar +4 | 0x04909F |
| Swamp | sugar +2 | 0x0490A5 |
| Grassland | tobacco +4 | 0x0490AF |
| Marsh | tobacco +2 | 0x0490B9 |
| Prairie | cotton +4 | 0x0490C3 |
| Tundra | ore +2 | 0x0490CD |
| Plains | cotton +1, food +2 | 0x0490D7 |
| Ocean (25) / Sea Lane (26) | fish rate points; every 3 pts ⇒ food +2 | 0x049066..0x049090 |

### 10.3 Phase C — supply/demand arrays (0x049242..0x0495DC)

Both arrays zeroed at 0x049259..0x04926F, then per good (formulas exactly as
decoded; where the manual gives only a site, the term exists but its algebra
was not transcribed):

| good | supply | demand |
|---|---|---|
| Food | `+= (tier+N)·food_pts/(7−tier)` @0x049271 | `4·N²`, halved if tier ≥ 2 @0x04928F..0x0492A7 |
| Silver | `tribe[+0xC]/K + 4·mountains` (K = per-tribe byte `[0x962A+idx]`) @0x0492B8..0x0492F0 | — |
| Ore | `2·hills + mountains + tundra` (tier ≥ 1) @0x0492F4..0x04930B | — |
| Furs | `(2·coldforest + otherforest/2)/(tier+1)` @0x04930F..0x049328 | — |
| Coats/Tobacco/Sugar/Cotton/Cloth | supply terms @0x04932C..0x049386 | — |
| Tobacco | — | `(6−tier)·N + 2·cold + 5` @0x04938F |
| Cigars | — | term @0x0493A5 |
| Coats | — | `8·cold + furs` @0x0493B5 |
| Rum | — | term @0x0493C2 |
| Trade Goods | — | `(tier+2)·(N+3) + 8` @0x0493D5 |
| Tools | — | `(tier·N) << (cold/2 + 1)` @0x0493EA |
| Muskets | supply = 0 @0x049434 | `4·(7 − tribe[+7] − tier)` @0x0493FC |
| Horses | `tribe[+0xA] / ([0x962A+idx]/2 + 1)` @0x04940D | `4·(9 − tribe[+8] − tier)` @0x049423 |

Then, in order:

1. **Demand clamp to [0, 50]** (0x32) via the clamp helper `0x181F:0x35C`
   (0x04943E..0x049460).
2. **Capital boost** (settlement flags `+0x03 & 4`, 0x049462..0x0494B5):
   demand[0..7] ×2, demand[13..15] ×1.5, supply[7..15] ×2.
3. **Tribe stock adjustment**: per-good tribe stock `tribe[+0xE+2g]` folded into
   both arrays (0x0494C0..0x0494D6 / 0x0495B9..0x0495D6).
4. **Mutual discount**: `supply −= demand/2; demand −= supply/2`, each floored
   at ≥ 1 (0x049537..0x049591). The debug dump sits between the two halves.

### 10.4 Consumers

- **Village trade** (`func_04A7CA`): zeroes last-bought goods
  (0x04A8C1..0x04A8F0), index-sorts the arrays (`0x191F:0xED0` at 0x04A8F7) and
  names the top goods in the "especially interested in …" line
  (0x04A91D/0x04A932).
- **Food events** (`func_056C3E`, the mission-village event handler and the sole
  caller of `func_048F34`, at 0x057093): a food *deficit*
  `demand[0]−supply[0]` gates the **INDIANBEGFOOD** popup (key pushed at
  0x05716F); a surplus `supply[0]>demand[0]` gates **INDIANGIVEFOOD** (0x0573EB).
- **Haggle price** (`func_049600`): subtracts `supply[idx]·4` in the price
  computation (0x04A07A).

## 11. Trade routes

Trade routes are a small fixed array of 12 records, each holding a name, a
sea/land type and up to four stops; each stop packs its destination and up to
six load and six unload cargo types into nibbles. Units are attached to a route
through two nibbles of their class byte, and the per-turn executor walks the
stops under order code 2.

```c
typedef struct {                 // stride 0x0A
    uint16_t dest;               // +0x00: colony index; 0x3E7 (999) = Europe
    uint8_t  counts;             // +0x02: lo nibble = unload count, hi nibble = load
                                 //        count (max 6 each)
    uint8_t  load_nib[3];        // +0x03..+0x05: load cargo ids, nibble-packed
    uint8_t  unload_nib[3];      // +0x06..+0x08: unload cargo ids, nibble-packed
    uint8_t  pad;                // +0x09: unmapped (save-file diff pending)
} StopRecord;                    // nibble get/set func_0603DA / func_06040A

typedef struct {                 // stride 0x4A; max 12 routes; count word [0x53A0]
    char       name[0x20];       // +0x00
    uint8_t    type;             // +0x20: 1 = sea, 0 = land
    uint8_t    stop_count;       // +0x21: max 4
    StopRecord stops[4];         // +0x22..+0x49
} RouteRecord;                   // selected route: [0x9E14] = route·0x4A, seg [0x9E16]
                                 //   (func_05FE60)
```

- **Commands**: menu ids 0x50 Edit / 0x51 Create / 0x52 Delete (MENU.TXT
  `@TRADE` row order) → `func_060FBC` / `func_0610B0` / `func_0612E6`
  (0x0238F2/0x0238EA/0x0238FC). Creating past 12 routes posts `@TRADEMANY`
  (cap check 0x0610B5).
- **Unit linkage**: unit byte `+0x17` (absolute 0x315B) — **low nibble = route
  id, high nibble = stop index** (accessors `0x181F:0x858/0x862/0x876/0x8B2`);
  the unit's order code is 2 ("Trade Route").
- **Assign** ("Begin Trade Route", `func_022D46`): `@TRADENONE` if no routes
  exist; the route menu is filtered sea-only for ships / land-only otherwise
  (`@TRADENONE2` if the filter empties); sets order 2 and steps immediately.
- **Create flow**: cap check → pick destination 1 → coastal test
  (`0x181F:0xD12`) → `@TRADETYPE` sea/land choice (or forced land) → default
  name = colony name + random `@TRADENAMES` word (collision appends " A") →
  `@TRADENAME` entry (max 0x1F chars) → stop count preset 2 → pick destination
  2 (cancel aborts before `inc [0x53A0]`) → editor. The editor creates a
  phantom probe unit at (0xFF,0xFF) to filter reachable destinations, deleted
  on exit (0x0610A0). Delete compacts the array (`rep movsw` 0x25 words) and
  decrements higher route ids on all linked units.
- **Execution**: the per-turn executor for order 2 is `func_041080` (dispatcher
  jump table at file 0x24A38). A route with only one stop posts **@ROUTELOOP**
  (0x0413F7), verbatim:

```text
Your Excellency, our "{%STRING0}" trade route
has only one port on its itinerary!
```

## 12. Units

Up to 300 units live in a single 28-byte-stride array. A unit is its type (a
row of the NAMES `@UNIT` table), an owner nibble, a position, an order code,
cargo nibbles and a handful of per-turn scratch fields; the type indexes a
14-byte runtime stat table loaded from `@UNIT` at boot.

### 12.1 UnitRecord

Base `DS:0x3144`, stride 0x1C. (Field addresses below are absolute DGROUP; the
record-relative offset is the low nibble progression from +0x00.)

```c
typedef struct {                 // array DS:0x3144, stride 0x1C, 300 max
    uint8_t map_x;               // +0x00 (0x3144): renderer @0x03A63, placer @0x06958
    uint8_t map_y;               // +0x01 (0x3145)
    uint8_t unit_type;           // +0x02 (0x3146): @UNIT row 0..22; 694 refs
    uint8_t owner;               // +0x03 (0x3147): low nibble = power 0..11
                                 //        (set_unit_owner @0x738E); high nibble state
    uint8_t flags;               // +0x04 (0x3148): transient bit register — 0x80
                                 //        draw-active / "Damaged" display pair
                                 //        (set @0x069923, cleared @0x069942; combat
                                 //        @ARTILLERY sets it @0x05B6F6); 0x40 ship-
                                 //        carrying-cargo (@0x02F37A); 0x20 Merchantman
                                 //        tag; 0x10 long-path; 0x08 tile-dirty;
                                 //        0x04 ship-cargo; 0x02 was-fortifying
    uint8_t moves_spent;         // +0x05 (0x3149): move credits spent this turn
                                 //        (reset @0x005872; +3/step @0x05CAE2)
    uint8_t timer;               // +0x06 (0x314A): countdown (init 0xFF, dec)
    uint8_t ai_state;            // +0x07 (0x314B): persistent AI state letter
                                 //        ('X','-','0','1','G','E','R',...)
    uint8_t order;               // +0x08 (0x314C): order code 0..0x0C (dispatchers
                                 //        @0x249CB / @0x51DCE)
    uint8_t goto_x;              // +0x09 (0x314D): Go-To target / route next stop
    uint8_t goto_y;              // +0x0A (0x314E): (writer @0x22D38)
    uint8_t heading;             // +0x0B (0x314F): 8-way facing 0..7, 8 = none
                                 //        (reverse test xor al,4 @0x047AA8)
    uint8_t cargo_count;         // +0x0C (0x3150): goods in hold (@0x0B2AB)
    uint8_t cargo_ids[3];        // +0x0D..+0x0F (0x3151..0x3153): nibble-packed
                                 //        good ids, 2 per byte, up to 6 (@0x0B2CB)
    uint8_t cargo_qty[2];        // +0x10..+0x11 (0x3154..0x3155): per-slot
                                 //        quantities (@0x0B2FB)
    uint16_t timer_16;           // +0x12 (0x3156): overloaded — natives: snapshot of
                                 //        progress counter [0x538E] (@0x06DB3);
                                 //        player units: byte 0xFF sentinel → random
                                 //        0..0x13 on first use (@0x50C75)
    uint8_t turn_flag;           // +0x14 (0x3158): per-turn land-unit boolean
                                 //        (cleared @0x04968D; read for Wagon Trains
                                 //        @0x0507E1; exact label runtime-open)
    uint8_t tools;               // +0x15 (0x3159): pioneer tools 0..100
                                 //        (−20 per action @0x4060F)
    uint8_t work_counter;        // +0x16 (0x315A): turns-in-activity
                                 //        (clear/plow/road/fortify @0x04071D)
    uint8_t profession;          // +0x17 (0x315B): colonist profession 0x13..0x1C;
                                 //        for routed units: lo nibble = route id,
                                 //        hi nibble = stop index
    uint16_t occ_back;           // +0x18 (0x315C): per-tile occupancy back link
    uint16_t occ_next;           // +0x1A (0x315E): next link (placer @0x06968/@0x06976)
} UnitRecord;                    // sizeof = 0x1C (28)
```

### 12.2 The `@UNIT` stat table

The loader at 0x074EC3 parses the 23 `@UNIT` rows into a runtime table at
`DS:0x5230`, stride 14: +0 name ptr, +2 icon, **+4 moves stored ×3**
(`shl al,1 / add al,cl` at 0x074F04; road cost = 1/3), **+5 combat (defense)**,
**+6 attack**, +7 cargo holds, +8 move class (99 = naval), +9 hull, +0x0A size,
**+0x0B guns**, **+0x0C ai-value** (the ship-combat pair), +0x0D flags. Values
verbatim from NAMES.TXT:

| id | unit | icon | mv | atk | cmb | crg | cls | hull | size | guns | ai | flags |
|---:|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---|
| 0 | Colonists | 101 | 1 | 0 | 1 | 0 | 1 | 1 | 0 | 0 | 0 | 01000000 |
| 1 | Soldiers | 103 | 1 | 2 | 2 | 0 | 1 | 2 | 0 | 0 | 0 | 00011100 |
| 2 | Pioneers | 102 | 1 | 0 | 1 | 0 | 1 | 2 | 0 | 0 | 0 | 01000000 |
| 3 | Missionaries | 106 | 2 | 0 | 1 | 0 | 1 | 1 | 0 | 0 | 0 | 00100000 |
| 4 | Dragoons | 105 | 4 | 3 | 3 | 0 | 1 | 3 | 0 | 0 | 0 | 00111100 |
| 5 | Scouts | 104 | 4 | 1 | 1 | 0 | 1 | 2 | 0 | 0 | 0 | 01100100 |
| 6 | Regulars | 126 | 1 | 5 | 5 | 0 | 1 | 3 | 0 | 0 | 0 | 00011100 |
| 7 | Cont. Cav. | 130 | 4 | 5 | 5 | 0 | 1 | 3 | 0 | 0 | 0 | 00011100 |
| 8 | Cavalry | 127 | 4 | 6 | 6 | 0 | 1 | 4 | 0 | 0 | 0 | 00011100 |
| 9 | Cont. Army | 129 | 1 | 4 | 4 | 0 | 1 | 3 | 0 | 0 | 0 | 00011100 |
| 10 | Treasure | 17 | 1 | 0 | 0 | 0 | 6 | 4 | 0 | 0 | 0 | 00000000 |
| 11 | Artillery | 10 | 1 | 7 | 5 | 0 | 1 | 6 | 4 | 0 | 0 | 00011000 |
| 12 | Wagon Train | 9 | 2 | 0 | 1 | 2 | 99 | 1 | 0 | 0 | 0 | 00000000 |
| 13 | Caravel | 6 | 4 | 0 | 2 | 2 | 99 | 4 | 4 | 0 | 4 | 10100010 |
| 14 | Merchantman | 7 | 5 | 0 | 6 | 4 | 99 | 6 | 8 | 1 | 8 | 10000010 |
| 15 | Galleon | 8 | 6 | 0 | 10 | 6 | 99 | 10 | 10 | 4 | 20 | 10000010 |
| 16 | Privateer | 15 | 8 | 8 | 8 | 2 | 99 | 8 | 12 | 4 | 12 | 00000001 |
| 17 | Frigate | 16 | 6 | 16 | 16 | 4 | 99 | 16 | 20 | 12 | 32 | 10000001 |
| 18 | Man-O-War | 128 | 5 | 24 | 24 | 6 | 99 | 32 | 90 | 32 | 64 | 10000001 |
| 19 | Braves | 110 | 1 | 1 | 1 | 0 | 0 | 1 | 0 | 0 | 0 | 00111000 |
| 20 | Armed Braves | 111 | 1 | 2 | 2 | 0 | 0 | 2 | 0 | 0 | 0 | 00111000 |
| 21 | Mtd. Braves | 112 | 4 | 2 | 2 | 0 | 0 | 2 | 0 | 0 | 0 | 00111000 |
| 22 | Mtd. Warriors | 113 | 4 | 3 | 3 | 0 | 0 | 3 | 0 | 0 | 0 | 00111000 |

**Ship types are 0x0D..0x12** (13 Caravel .. 18 Man-O-War) — this range gates
ship logic everywhere (pathfinder, combat, docks). The Artillery "Damaged"
display pair is attack +2 / damaged −2 (delta = col atk − col cmb, 0x069B39).

### 12.3 Professions — `@JOB`

28 rows (id, base name, expert form, tier = minimum school level 1=Schoolhouse /
2=College / 3=University / 4=not school-taught, and the expert's gold value):
0 Farmer (Expert Farmers, 1, 1100), 1–3 Sugar/Tobacco/Cotton Planter (Master
…, 2, −1), 4 Fur Trapper (1, −1), 5 Lumberjack (1, 700), 6 Ore Miner (1, 600),
7 Silver Miner (1, 900), 8 Fisherman (1, 1000), 9 Distiller (2, 1100),
10 Tobacconist (2, 1200), 11 Weaver (2, 1300), 12 Fur Trader (2, 950),
13 Carpenter (1, 1000), 14 Blacksmith (2, 1050), 15 Gunsmith (2, 850),
16 Preacher (Firebrand, 3, 1500), 17 Statesman (Elder, 3, 1900), 0x12 Teacher
(4, −1), 0x13 Colonist (Free Colonists, 4, −1), 0x14 Pioneer (Hardy, 1, 1200),
0x15 Soldier (Veteran, 2, 2000), 0x16 Scout (Seasoned, 1, −1), 0x17 Dragoon
(Veteran, 2, −1), 0x18 Missionary (Jesuit, 3, 1400), and the specials
**0x19 Ind. Servant, 0x1A Criminal, 0x1B Convert** (all tier 4, −1) plus the
pseudo-profession **0x1C** used as a display variant and remapped to 0x13 by
the context-help dispatcher (0x02BD83). The runtime job table is `DS:0x8EA2`,
stride 8 (+0 name, +2 expert plural).

**Unit-type → expert-job table** at `DS:0x30E` (file 0x1DCAE), bytes
`13 15 14 18 17 16` (hex): type 0 Colonists → 0x13 Colonist, 1 Soldiers →
0x15 (Veteran Soldiers), 2 Pioneers → 0x14 (Hardy Pioneers), 3 Missionaries →
0x18 (Jesuit Missionaries), 4 Dragoons → 0x17 (Veteran Dragoons), 5 Scouts →
0x16 (Seasoned Scouts).

### 12.4 Orders

Order codes live at `UnitRecord +0x08` (0x314C); the per-turn dispatcher at
0x249CB jump-tables codes 2..9 (table at file 0x24A38). The `@ORDERS` section
carries 13 rows of `name, key-letter`; the accelerator/status-letter array is
built into `DS:0x54DE` (writer 0x074F96) and read as the on-map status glyph
indexed by the order code (0x0391D) — the letters are exactly
`- S T G L F F B P R - - -`:

| code | order | key | init write | per-turn executor |
|---:|---|:-:|---|---|
| 0 | No Orders | `-` | @0x21ED7 | — (auto-activate) |
| 1 | Sentry | `S` | @0x21FEB | — (skip) |
| 2 | Trade Route | `T` | @0x22E05 | func_041080 |
| 3 | Go To | `G` | @0x22D2D | func_040E22 |
| 4 | Live In Village | `L` | no store site exists (menu row only) | passive |
| 5 | Fortify | `F` | @0x22105 | func_04101C → writes code 6 @0x41024 |
| 6 | Fortified | `F` | @0x41024 | passive (+50% defense) |
| 7 | Build Colony | `B` | @0x2279E | func_040C1E |
| 8 | Clear/Plow | `P` | @0x22324 | func_040656 |
| 9 | Build Road | `R` | @0x2250E | func_0409D6 |
| 0xA–0xC | No Orders (AI reserved) | `-` | AI-only | AI |

Status-glyph overrides (renderer at 0x0386A): ships not owned by the viewer
show their cargo count as an ASCII digit (`+0x30` at 0x0393F); 'X' when hidden;
the AI state letter `+0x07` for AI units, replaced by 'E' when ≥ 0x80.

## 13. Movement and pathfinding

Terrain movement cost is data-driven: the `@TERRAIN` `Movement` column is
loaded to `terrain·16 + 0x2F76` and charged as `Movement·3` against a budget
stored ×3, so a road (cost 1/3) costs exactly one stored point. Short-range
pathfinding is a bounded 16×16-window BFS with a cost cache, decoded in full
below together with its three debug overlays.

### 13.1 The short-range path-step finder — `func_061F02` (file 0x061F02)

Register args: `ax` = target_x, `dx` = target_y, `bx` = cost bound; returns
`ax` = best direction 0..7 *at the target toward the path start*, −1 on failure
(init at 0x06205A).

- **Window**: start tile = (`[0xA14E]`,`[0xA14C]`); window origin = start − 8
  (0x061F2F/0x061F38); 16×16 tiles.
- **Cost cache**: 256 bytes at `DS:0xA270`, memset at 0x061FBA..0x061FC7; BFS
  queues x at `DS:0xA372` / y at `DS:0xA472`, write/read indices
  `[0x2D16]/[0x2D18]`, capacity 0xE1 (0x062055). The cache is reused when the
  origin (`[0x2D1A]/[0x2D1C]`) is unchanged (0x061F83..0x061FA9).
- **Neighbour tables** (file 0x1DA54/0x1DA5E): `DS:0xB4` dx =
  {0,1,1,1,0,−1,−1,−1}, `DS:0xBE` dy = {−1,−1,0,1,1,1,0,−1} — directions 0..7 =
  N, NE, E, SE, S, SW, W, NW (applied 0x06210D/0x06211B).
- **Ship gating**: moving unit type `[0x1DD2]` in 13..18 (0x061F41/0x061F48) =
  the ship range; tile is water iff terrain id == 0x19 (25 Ocean) or 0x1A
  (26 Sea Lane) (0x062174..0x06217C); land/water mismatch allowed only at the
  endpoints (0x0621BE..0x0621E5); water-water extra checks via the helpers at
  0x06219D/0x0621AF.
- **One-move units**: if the type's stored moves ≤ 3 (`byte[0x5234+type·14] ≤ 3`
  at 0x061F6B) every step costs a flat 3 (0x0622F4).
- **Step costs** (in priority order): road/plow layer mask 0x0A at both ends →
  **+1** (0x0622A7..0x0622C0); river bit 0x40 on a cardinal step → **+1**
  (0x0622CC..0x0622EC); otherwise **terrain Movement ×3** —
  `byte[terrain·16+0x2F76]·3` (0x062300..0x06230C). NAMES values: open land 1,
  forests 2, Hills 2, Arctic 2, Mountains 3, Ocean/Sea Lane 1.
- **Occupancy/power rules**: occupying power at the tile must be −1 or the
  moving power `[0x1DD6]` (0x062217); a second ownership probe rejects
  power ≥ 4 (0x062245) and AI-controlled powers, else adds +8 (0x06225E);
  native units (type ≥ 19, 0x0621E8) reject rumor tiles (0x0621F5).
- **Phase 2**: picks the minimum-cost neighbour of the target (cost init 99 =
  0x63 at 0x06206B), **tie-break by distance** (`func_00493C` at 0x06259F),
  pruned against the bound `[0xA370]` (0x06202C/0x062062).

### 13.2 The movement debug overlays

Three of the seven DEBUG.TXT `@OPTIONS` bits in the cheat bitfield `[0x894]`
(builder `func_02356C`, exactly 7 checkbox items) are movement overlays:
**bit 0x10 "Close Moves"** (gate at 0x061F14), **bit 0x20 "Far Moves"**
(sibling `func_06295E`, 0x062975, format `"Far: %d(%d,%d)…"`), **bit 0x40
"All Movement"** (`func_062D84`, 0x062D94, sets the latch `[0x1DF2]` that
Close Moves honours). The Close-Moves overlay draws over the live map view
(full redraw via `0x181F:0xE1C(1)`):

- **Per-tile cost numbers**: for each nonzero cache cell, `func_078068`
  prints the cost in white (0x0F): px = `(x+[0x832A]−[0x8328])·[0x5AD4]`,
  py = `(y+[0x832C]−[0x832E])·[0x8326]+8`, nudged `+7>>zoom, +6>>zoom` with
  zoom = `[0x184]` (0x078081..0x0780E3); at zoom 0 a backing rectangle is drawn
  behind the digits (0x07810C).
- **Summary line**: format `"(%d,%d)-(%d,%d) %d == %d"` (DS:0x1DD8, file
  0x1F778) filled with start x/y, target x/y, bound, best direction; colour 12
  (red); drawn at **(5,190)** directly to the 320×200 VGA surface
  (0x062683..0x0626B1).
- **Keys**: 'Z' zoom in (`[0x184]−−`, clamp ≥0), 'X' zoom out (clamp ≤3), each
  redraws; ESC clears the latches and exits; any other key exits
  (0x0626D0..0x062705).

### 13.3 Go-To orders

Order code 3 with the destination at `UnitRecord +0x09/+0x0A` (writer
0x22D38/0x22D2D); per-turn executor `func_040E22`. The destination is chosen
with the shared picker (`func_060026` / `func_022CDC`): headers `@SAILPORT`
(ship) / `@TRAVELPLACE` (land unit); rows are eligible own colonies filtered by
water/land region match, plus a Europe row for ships only (choosing Europe
issues set-sail); pages of 10 with "(More)".

## 14. Combat

Combat resolves one attack with a single roll over modified strengths. The base
strength comes from the unit stat table; a chain of byte-cited multipliers
(veterancy, terrain, colony, fatigue, difficulty, Sons of Liberty) modifies it;
the optional Combat Analysis dialog itemizes exactly those modifiers before the
result is applied.

### 14.1 Base strength — `func_007C2A`

The root strength calculator writes the per-side base at `[col·2+0x8D06]`
(0x007CA5): `base = stat_table[type·14 + 0x5235]` (the +5 combat column);
**carriers add the +6 attack column** (`+0x5236`); a **damaged ship**
(flag bit) takes **−2**. Modifier-flag words per side: primary
`F = [col·2+0x8D00]`, secondary `S = [col·2+0xA156]` (cleared at 0x05CB3A);
producers include Veteran at 0x007CD6, Drake at 0x007CF0/0x007D09, Fatigue
(`[0x8D01]|=1`) at 0x05CB9B, Bombard (`[0x8D01]|=0x80`) at 0x05CF7D.

### 14.2 The Combat Analysis modifier table

The dialog (see §14.4) renders one row per set flag bit; the same bits drive
the strength math. Complete row table (labels are LABELS.TXT `@MISC` lines):

| flag | row label | effect |
|---|---|---|
| F&0x200 | unit shown under its veteran-profession name | base strength |
| F&0x400 | Muskets (good 15 name + icon 0x26) | "+1" (value semantics unresolved, @0x05EBDA) |
| F&2 | Veteran (types 1/4, profession 0x15) | +50% |
| F&4 | Cargo | −12.5% per used hold (cargo·100/8, @0x05ED65) |
| F&0x100 / S&8 | Fatigue | −33% / −66% |
| F&1 | Attack Bonus | +50% |
| F&0x8000 | Bombard | +50% |
| S&2 | Tory Unrest | −(100 − SoL%) |
| S&4 | Rebel Unrest | +SoL% (SoL from `func_008524`, `0x181F:0xC86`) |
| F&0x80 | Ambush (attacker) / Terrain (defender) — draws the target tile | +terrain_defense·25% (row skipped if 0) |
| F&0x40 | Colony | +(fort_level+1)·50% (`0x181F:0x9D2`) |
| F&8 (+0x10/+0x20) | colony-structure row (building name, table DS:0x9634) | +n·50%, n = 1/2, doubled by F&0x20 |
| F&0x800 (S-side) | Artillery In Open | −75% |
| S&1 | Artillery Vs. Raid | +100% |
| F&0x2000 | Fortified | +50% |
| F&0x1000 | Spain Bonus | +50% |
| F&0x4000 | Drake (privateers, Founding Father 13 owned) | +50% |
| `[0x5383]&0x20` (cheat) | extra rows: final strengths + the raw roll vs att+def | — |

Terrain defense values are the `$TERRAIN` "Defensive" column (byte-verified):
open land 0, Marsh/Swamp 1, forests 2 (Rain 3), Hills 4, Mountains 6. The
defense-bonus filler `func_007D3E` accumulates into `[0x8D04]`: colony +2
(0x7D8D), fortified building (level ≥ 2) +4 with a doubling condition
(0x7DBC/0x7DD1), river/road +(n+1)·2 (0x7E12), open terrain + the per-terrain
byte at `terrain·16+0x2F77` (0x7E63).

### 14.3 The strength chain and the roll — `func_05CA7E`

Attacker strength `[bp-0x90]` (defender `[bp-0xA6]`) is built from the stat
columns and modified, in order:

1. terrain/fort bonus: `strength·([0x8D04]+4)/4 · 3/2` (0x05CE05, `·3/2` chain
   at 0x05CE16);
2. **difficulty handicap**: a human-controlled combatant gets
   `strength += (4 − difficulty)` on **both** sides (attacker 0x5CE35, defender
   0x5CE54; +4 at Discoverer down to +0 at Viceroy);
3. generic terrain multiplier `·[bp-0x96]/3` (0x05CE69);
4. colony present on the defending tile → +50%, flag `[0x8D01]|0x10`
   (0x05CF43);
5. War-of-Independence bombardment (endgame flag `[0x5382]&1`, REF defender) →
   +50%, flag `[0x8D01]|0x80` (0x05CF7D);
6. Sons-of-Liberty scaling `strength·SoL%/100` (0x05CF98);
7. difficulty scaling `strength·difficulty/20` (0x05CFFC);
8. a further strength **doubling at 0x05D0D9 gated on the difficulty byte
   `[0x53A6]`** — its exact condition is an open item (runtime).

Fatigue is offered *before* the roll via GAME.TXT `@HALF` — attacking with
tired troops fights at reduced strength (the −33%/−66% rows above); text
verbatim:

```text
Your Excellency, these men are tired.  If we force
them to attack this turn, they will fight at {%NUMBER0/3
strength}.

"Charge!"
"Then let them rest."
```

**The roll** (act mode): `roll = random_int(1, ATK+DEF)` via `func_00C322`
(`0x181F:0x4D4`) at 0x05D188; **the attacker wins iff `roll ≤ ATK`**
(`cmp roll,[bp-0x90]; jg` ⇒ loss). Evaluate mode instead returns the odds score
`(ATK·8)/(DEF+1)` (0x05D032) for AI ranking. The naval unit-vs-unit roll in the
consequence applier `func_05B2C2` uses the **raw** ship stat pair `+0x0B/+0x0C`
(`0x523B/0x523C`, no modifier scaling): `roll = random_int(1, A+D)` at
0x05B844, with independence-war special cases (0x05B87D/0x05BA2D).

### 14.4 When the Combat Analysis dialog shows

Gate at 0x05D221 inside `func_05CA7E`, *after* the roll is computed but before
resolution renders: Game Options bit **`[0x5383]&2`** ("Combat Analysis"
checkbox) AND (attacker human OR defender human OR full-view `[0x53A2]≠0`).
Sole call site 0x05D291, 13 arguments (both unit indices, both positions, both
owners, both strengths, and the roll). The dialog itself (`func_05E9B0`, page
0x11) is a two-pass measure/draw modal: frame x=53, w=214, h=rows·20+6,
vertically centred; title "COMBAT ANALYSIS" (`@MISC` 75); attacker column
x=56, defender +80; row pitch 20; values right-aligned at column+0x50; each
cell dual-drawn dark/light for a drop shadow; modal-wait terminator.

### 14.5 Naval prompts

- `@HALF` — the pre-attack fatigue prompt above (also flags the −33% row).
- `@EVASIVE` — posted at 0x05D469 when a ship evades; text verbatim:

```text
{%STRING0 %STRING1} evades {%STRING2 %STRING3}.
```

---

### 14.6 After the roll — demotion, capture, promotion

The consequence applier is `func_05B2C2` (0x5B2C2..0x5BE2C), reached from the
decider through the wrapper `func_05BE30`.

**The demotion ladder** (if-ladder 0x5B5AA..0x5B61F): a defeated land unit
falls one rung instead of dying — Dragoons→Soldiers (0x5B5B3),
Soldiers→Colonists (0x5B5C3), Cont. Cavalry→Cont. Army (0x5B5DF),
Cavalry→Regulars (0x5B5EF), Cont. Army→Colonists (0x5B5CF); anything else is
destroyed. A demoted-to-Colonist with the Missionary profession byte (0x18)
becomes a Missionaries unit instead (0x5B60E/0x5B615); a Veteran Soldier
loses veteran status on the way down (0x05B570..0x05B577). Message `@DEMOTE`
(0x05B679).

**Capture instead of death**: the loser is capture-eligible only for types
Colonists, Treasure, and Wagon Train (flag set 0x5B31D..0x5B33D), the loser's
owner must be European (< 4), and a winning ship needs transport room
(0x5B410..0x5B428) — then the unit changes hands intact via `set_unit_owner`
(0x5B4C7). Messages: `@LOOTCAPTURE` (Treasure, 0x05B544), `@WAGONCAPTURE`
(0x05B566), `@COLONISTCAPTURE`/`@COLONISTCAPTURE2` (0x05B586/0x05B57E).

**Artillery**: on a loss it flips to the "Damaged" display state
(`+0x04 |= 0x80` at 0x05B6F6, `@ARTILLERY`; the displayed delta is the
attack−combat column pair 7−5 = "+2 / −2", 0x069B39); a damaged artillery
that loses again is destroyed (`@ARTILLERY2`, 0x05B740).

**Ships**: ship-vs-ship uses the raw guns/hull columns with no modifier
chain (`roll = random_int(1, guns_A + hull_D)` at 0x05B844); outcomes are
`@SHIPDAMAGE` (0x05BC79) or `@SHIPSUNK` (0x05BD0F) — a sinking ship carrying
cargo (`+0x04 & 0x40`, set at 0x02F37A) scatters its 6 cargo slots
(loop 0x05BD28, `@CARGOCAPTURE` 0x05B98C on seizure). Only Privateers and
Frigates may start ship attacks (`@SHIPCOMBAT` guard in the ship dispatcher
`func_03FDDE`); `@EVASIVE` posts on an evade (0x05D469 — the evade condition
itself is unmapped). Shore fire from a colony fort is deterministic:
`strength = artillery_count · fort_level · 4`, no roll (`func_02D3C6`,
`@FORTFIRE` at 0x02D5D9).

**Promotion**: the winner is promoted with probability
`winner_strength / S` where `S = atk + def ± difficulty` (human +d, AI −d)
minus a class penalty (Petty Criminal −10, Indentured Servant −5) — roll
`random_int(1,S)` at 0x5C764. **George Washington** (FF 11, tested at
0x5C758) skips the roll: promotion is automatic. The class ladder
`func_05E714` writes the next rank (0x5C7DD); at the soldier ceiling the unit
*type* advances instead — Soldier → Continental Army (0x5C7C3). Popups
`@VETERAN` / `@VALOR` / `@WELLSEASONED`.

In-repo conflicts, flagged: one combat.md bullet calls `func_05CA7E`
"pre-combat setup, not the roll" — overruled by the wave-9 ruling and the
roll site 0x05D188; the 0x05CF43 +50% write is glossed both "colony" and
"Spain-vs-natives"; the profession byte is cited both `+0x17` and record
`+0x15`. The Combat Analysis gate is written `[0x5383]&2` and "Game-Options
bit 0x0200" in different sheets.

## 15. Powers and relations

Four European powers (0 = English, 1 = French, 2 = Spanish, 3 = Dutch) share the New
World with eight native tribes (power ids 4–11) and, late in the game, the King's
Royal Expeditionary Force. Per-power state is split across two parallel record
arrays — a small 52-byte "personality" record holding names and control flags, and a
large 316-byte record holding the economy, diplomacy and Congress state — plus a
handful of per-power scalar tables. Everything in this section is the substrate the
diplomacy, Congress and revolution machinery of sections 16–18 reads and writes.

### 15.1 The 52-byte personality record (base 0x540E, stride 0x34, count 4)

```c
typedef struct {                    // DGROUP:0x540E + power*0x34 (runtime BSS; loaded from NAMES.TXT / save)
    char leader_name[24];           // +0x00 NUL-terminated ("Walter Raleigh"); default for the @LEADERNAME entry box
    char country_name[24];          // +0x18 region name ("New England"); %STRING source for diplomacy popups
    uint8_t event_flags;            // +0x30 one-time-event bitfield; bit 0x40 test-and-set at 0x61870/0x61877 (burial-ground anger)
    uint8_t controller;             // +0x31 (abs 0x543F+p*0x34): 0 = human, 1 = AI, 2 = eliminated (set at 0x3C91A)
    uint16_t colony_name_seq;       // +0x32 default-colony naming counter (INC at 0x4056E, zeroed at 0x75930)
} AIPersonality;
```

The controller byte at `[0x543F + power*0x34]` is the single most-tested per-power
flag in the binary (~218 references): the turn loop skips inactive powers on it
(0x57C5/0x58AA), the parley dispatcher's human-only gate reads it (0x57F8C), the
Founding-Father cost formula branches on it (0x3C29C), and hot-seat multiplayer
writes it from the `@MULTI` checkbox dialog (section 18.6).

### 15.2 The 316-byte power record (base 0x8808, stride 0x13C, count 4)

Active record far pointer: `[0x84FC]`. The whole 4×0x13C block is serialized
verbatim as save block #8 (section 20.3).

```c
typedef struct {                    // DGROUP:0x8808 + power*0x13C
    uint8_t  tax_pct;               // +0x01 royal tax rate 0..75 (clamp at 0x3434F)
    uint8_t  rebel_sentiment_pct;   // +0x02 Sons-of-Liberty % (F3 display)
    uint32_t acquired_ff_bitmask;   // +0x07 bit f = Founding Father f owned (byte base 0x880F; reader func_00BC10 @0xBC10)
    uint16_t bells_toward_next_ff;  // +0x0C liberty-bell pool; resets on each acquisition
    uint16_t bells_per_turn;        // +0x0E bells produced last turn (zeroed at 0x2F23F each production phase)
    uint16_t crosses_per_turn;      // +0x10 immigration points per turn
    int16_t  ff_in_progress;        // +0x12 father id being worked toward; 0xFFFF = none (cleared at 0x3BD37)
    uint16_t founding_father_count; // +0x14 owned-father count (cost-curve input)
    uint16_t artillery_bought;      // +0x1E Europe artillery escalation counter (read*100 at 0x35124)
    uint16_t boycott_bitmask;       // +0x20 bit g = good g boycotted after a Tea Party (set 0x34717, cleared 0x33423 / 0x3BD45)
    int32_t  royal_money;           // +0x22 the King's REF fund; +=(8*diff+10) per turn, era-doubled; buys a REF unit at 1800
    int32_t  eu_sales_tally;        // +0x26 cumulative net European sales (0x32A9C)
    uint32_t gold;                  // +0x2A treasury, clamp 0..999999 (add helper 0x181F:0xABA)
    uint8_t  home_x, home_y;        // +0x32/+0x33 sea-lane spawn/arrival coordinates (read 0x58D72; writers 0x418D0/0x65CCB/0x74D74)
    uint8_t  relations[4];          // +0x34 relation-bit row vs powers 0..3 (matrix base 0x883C; see 15.3)
    uint8_t  treaty_respect[4];     // +0x40 treaty-respect counters (base 0x8848; see 15.4)
    uint8_t  boycott_count[16];     // +0x4C per-good back-tax accumulator (INC 0x32271 / DEC 0x32288); also market sensitivity load
    int16_t  market_pool[16];       // +0x5C European supply/demand imbalance
    int32_t  market_traded[16];     // +0x7C cumulative traded volume
    int32_t  market_eu_supply[16];  // +0xBC European stock
    int32_t  market_base[16];       // +0xFC drift accumulator (buy += at 0x323BC, sell -= at 0x32324)
    // +0x03..+0x06, +0x16..+0x1D, +0x38..+0x3F, +0x44..+0x4B unmapped (interleaved gaps)
} PowerRecord;
```

### 15.3 The relations matrix (PowerRecord +0x34, base 0x883C)

Relations between every pair of European powers are one byte at
`0x883C + subject*0x13C + target` (the code addresses it as `[bx+si-0x77C4]`,
the wrapped-displacement form of 0x883C — read at 0x58A72). Accessors:
`func_007F34` get, `func_007F96` symmetric set, `func_008000` symmetric clear
(error strings "Treaty on/off error").

| bit  | meaning | evidence |
|------|---------|----------|
| 0x01 | resolved/normalised relationship | set 0x5318F |
| 0x02 | at war | set 0x58A7B / 0x59A61 / 0x3F0E8; cleared 0x5DE98 |
| 0x08 | grievance pending | set 0x3F0D7 / 0x59AE9; per-turn transition to bit 0x01 when the +0x40 timer expires and `random_int(0,3)==0` (0x53165) |
| 0x10 | parley cooldown (16 turns; stamp word `[0x53C8+power*2] = turn+0x10` at 0x58075 / 0x5914C) | |
| 0x20 | met / contacted | |
| 0x40 | peace treaty in force | set both ways 0x59139 |
| 0x80 | privateer hidden attribution — a privateer (unit type 0x10) attack sets this instead of the war bit (guard 0x3F092, set 0x3F0A1); cleared/revealed 0x58BE1 | |

### 15.4 The treaty-respect counter (PowerRecord +0x40, base 0x8848)

A plain byte counter, **not** a second bit matrix. On signing a treaty it is
seeded `2*(6 - difficulty)`, halved if the power has Benjamin Franklin
(0x59B00–0x59B31); the AI↔AI treaty handler `func_057DC0` writes it 1/0
(0x57EC5 / 0x57F2D). While nonzero, an AI aborts planned attacks on its treaty
partner (`func_03ECF0` @0x3F163). The decrement site is unmapped (runtime).

### 15.5 Per-power scalar tables

| address | shape | meaning |
|---------|-------|---------|
| 0x940C + p | byte | AI **attitude** toward action (parley willingness input; `(attitude>>2)` vs demand at 0x58C24; target eligibility needs ≥ 8 at 0x57B1A) |
| 0x941C + p*2 | word | per-power **grievance/finance** word (grievance-score read `[bx-0x6BE4]` in the war-bit path; census writer 0x42245; REF-intervention and succession strength term) |
| 0x942C + p | byte | per-power **strength/coastal-cargo** census total (succession ranking and SMITE-factor input) |
| 0x53C8 + p*2 | word | parley-cooldown timestamp (turn + 16) |
| 0x53DA/0x53DC/0x53DE/0x53E0 | words | REF Regulars / Cavalry / Man-O-War / Artillery counts |
| 0x53D2 | word | the King/REF (or withdrawn) power id; negative = none (tested 0x23930) |
| 0x5394 / 0x5396 / 0x5398 | words | current power / render power / human (rebel) power |

Power ids 0–3 are the Europeans; ids 4–11 are the tribes in `@TRIBES` order
(4 = Inca, 5 = Aztec, 6 = Arawak, 7 = Iroquois, 8 = Cherokee, 9 = Apache,
10 = Sioux, 11 = Tupi — section 19.1). The King's power is not a fifth record: it
reuses an eliminated European slot, its id held in `[0x53D2]`.


## 16. European diplomacy

All power-to-power diplomacy runs through a single 7-kilobyte dispatcher,
`func_057F4E` (file 0x057F4E, `enter 0xD6`), driving a 48-section GAME.TXT family:
42 conversation popups (width 220, rival-leader portrait), 6 announcements/guards
(width 190, advisor portrait) and 5 support list-sections. Section names are built
at runtime by strcpy/strcat from a fragment pool at file 0x1F250+ ("MEEK" 0x1F250,
"MANLY" 0x1F255, "HELLO" 0x1F267, "AHOY" 0x1F26D, "FIRST" 0x1F272, "USA", …),
which is why the full names never appear as string literals. Conversations are
emitted through `func_06F61C` (0x1A1F:0x688), which sets speaker channel 3
(`[0x1F60]` = power B → portrait sheet MYR0..MYR3.SS); announcements go through
`func_06F5F2` (0x181F:0x652, advisor channel `[0x1F5E]` → MSS1/MSS2 portraits).

### 16.1 Entry chain

```text
unit moves onto a foreign unit/colony tile
  func_03ECF0 (unit-vs-tile confrontation resolver)  @0x3F82B ──┐
  func_046FFA (movement processor, unit flag [0x3148]&8) @0x481CB ─┤
                                                                  ▼
  func_059B90 (contact evaluator; sole dispatcher call @0x5A2CE)
                                                                  ▼
  func_057F4E(humanA, powerB 0..3, unit, neighbor table, force)
    human-only gate @0x57F8C (cmp [bp+6],4; controller [0x543F+p*0x34]==0)
    if side A is AI → silently delegates to the AI↔AI ticker func_057DC0 @0x57FA4
```

First European-to-European contact also fires woodcut 10 ("MEETING FELLOW
EUROPEANS") at 0x57FDF, and every WAR*/`@MERCENARY` emission is preceded by the war
fanfare `func_005108(4)`; first-contact fanfare id is 0x8020+power. String helper
`func_057A3A` fills `%STRINGn` from `@GREATKINGS`/`@GREATDEEDS`/`@GREATLEADER`/
`@GREATLEADER2`[power]; `func_057AA2` picks `@MEEKNESS` row 1 "request" / row 2
"demand". Leader name comes from `0x540E+p*0x34`, region name from `0x5426+p*0x34`,
and the player's title from the difficulty-rank pointer `[0x8394+diff*2]`.
Benjamin Franklin (Founding Father 19) — tested via `func_00BC10(p,0x13)` — halves
demands and prices and cancels AI hostility at 6 sites in this dispatcher
(e.g. 0x5834E).

### 16.2 Greetings (`@HELLO*`)

Key = `"HELLO"` + (not-met ? (ship ? `"AHOY"` : `"FIRST"`) : tone `"MEEK"`/`"MANLY"`);
an independent (post-revolution) counterpart selects `"HELLOUSA"`. Key pushes at
0x588CD–0x58923, emit 0x58939. Representative body (`@HELLOFIRST`):

> "Greetings, %STRING0, and welcome to {%STRING1}. We have justly claimed all of
> this land in the name of {%STRING2}, and we are here to %STRING3. Please do not
> interfere with this God-given mission."

### 16.3 Subfamily outcome tables

Row numbering is the 1-based dialog return. "Row 2" is always the second option
line of the section text quoted.

**Third-party demands — `@APOSTATES` (attack a European treaty partner) /
`@HEATHEN` (attack a tribe), key push 0x58989 / 0x589C0, emit 0x58A30:**

| option | state writes |
|--------|--------------|
| row 1 "Never! …" | none (relations with B unchanged; B's attitude worsens via the demand bookkeeping) |
| row 2 "Yes! We shall crush …" | European target: treaty bit 0x40 cleared + war bit 0x02 set vs the third party (0x58A6A/0x58A7B). Tribe target: tension hit `func_045DF2(tribe, A, +100, 0)` at 0x58A91 |

**Protests — `@PIRACY`(`USA`), push 0x58B0D, emit 0x58B45:**

| option | state writes |
|--------|--------------|
| row 1 "What pirates? We have NEVER condoned piracy!" | hidden-attribution bit 0x80 stays set |
| row 2 "Very well, we shall withdraw our privateers to Europe." | every privateer recalled to Europe and bit 0x80 cleared (0x58B7D–0x58BE1) |

**Protests — `@SIEGES`(`USA`), push 0x58C99, handler 0x58CD8:** row 2 withdraws
all units adjacent to B's colonies. **Latent bug 1:** `@SIEGESUSA`'s two option
lines are textually swapped (withdraw is row 1 in the text) but the handler acts
on row 2 for both sections — so answering "Our forces … shall stay" to an
independent power actually executes the withdrawal.

**Extortion — `@TRIBUTE`(`USA`) / `@WANTSTUFFUSA` / `@PROVOKE` / `@WARMANLY` /
`@RID`(`USA`):** the AI accumulates a demand from forces-near-colonies, scaled by
difficulty (16.5). Paying transfers gold at 0x58ED0; a goods demand moves colony
stock rows at 0x58FB4; refusal escalates to `@PROVOKE`/`@WAR*` ("Prepare for
WAR!") and the war bit. **Latent bug 2:** for a non-independent extorter the code
builds the key `"WANTSTUFF"` at 0x58F56, but GAME.TXT contains no `@WANTSTUFF`
section — only `@WANTSTUFFUSA` exists; the lookup misses.

**Treaty and standing-peace menu — `@WORTHY` (demarcation-treaty proposal,
0x5911D→0x59120), `@GIVECASH` (0x591D5), `@PEACE*`/`@OLDPEACE*`/`@PEACEUSA`
(0x59150/0x59283/0x59356 → emit 0x59395):** the peace menu carries four fixed
rows:

| option (`@PEACEMEEK` text) | outcome |
|----------------------------|---------|
| "Go in peace, {%STRING1} brothers." | end parley; treaty set both ways (bit 0x40, verb 0x181F:0xA06 @0x59139) + siege stand-down `func_057CE0` + 16-turn cooldown |
| "First you must withdraw your forces from our colonies!" | withdraw branch → `@WITHDRAW` / `@NOTWITHDRAW` / `@NOTHINGWITHDRAW` / `@MAYBEWITHDRAW` (0x593B7–0x5949B). Withdrawal price = `25*(difficulty+2)*forces`, minimum 100, doubled at war, −50 per unit, halved by Franklin |
| "How much do you value your worthless lives, heathen swine?" | threat branch → `@GIFTS` ("a gift of {%NUMBER0$} in exchange for your continued forbearance", 0x59700) or `@THREATS` ("We laugh at your feeble threats", 0x59755), possibly `@PROVOKE` war (0x5974C) |
| "We suggest an alliance." | `@MILITARY` dynamic-row menu (rows built at 0x5976D over lea 0x19FA, shown via `func_06E3D0` @0x59848) → per-target `@NOCONTACT` / `@ALREADYSMITE` / `@SMITEINDIANS` / `@SMITEEUROPE` / `@UNFORTUNATE` (0x5989D–0x59A0F). Purchase: B declares war on target T (bits at 0x59A49–0x59A71), player pays B (0x59AC7), `@MERCENARY` announcement "The {%STRING0} declare war on the {%STRING1}." (0x59AB3). `@UNFORTUNATE` fires when the treasury (+0x2A/+0x2C, 32-bit compare 0x58E1F/0x58E29) cannot cover the promise |

### 16.4 The AI↔AI ticker (`func_057DC0`)

Runs every 3rd turn per met pair when the human dispatcher delegates. Peace
resolution emits `@SIGNTREATY` ("The {%STRING0} and {%STRING1} have signed a
peace treaty.", 0x57E86, MSS2 advisor), sets bit 0x40 both ways symmetrically
(0x57EC5/0x57ED0) and seeds treaty-respect = 1; war emits `@DECLAREWAR`
(0x57F18). Willingness gates: turn ≥ 0x28 (40) at 0x57B10 and at least one of
the pair's attitude bytes `[0x940C+p] ≥ 8` (0x57B1A/0x57B24). **Latent bug 3:**
the had-a-treaty branch pushes the key `"CANCELTREATY"` at 0x57F10, which has no
GAME.TXT section (only `@CANCELPEACE` exists) — the announcement is silently lost.

### 16.5 Demand accumulation and difficulty scaling (inside `func_057F4E`)

```text
grace period   : no AI war/refusal before turn 10*(10-diff)          (0x58374)
demand value   : value * 10*(diff+8) / 100        (×0.8…×1.2)        (0x583A0)
flat surcharge : += 500*(diff+1)                                     (0x5842B)
roll term      : (diff+1)*value >> 3 feeds a 0..400 roll             (0x58409)
attitude term  : += (diff-2)*meeting_value                           (0x58580)
action gate    : random_int(1,1000) < 200*diff + 100  (10%…90%)      (0x58315)
no-action gate : decline when (attitude>>2) > demand AND
                 (demand <= 12 OR random_int(0,4) != 0)              (0x58C24)
afford gate    : demand vs 32-bit gold +0x2A/+0x2C                   (0x58E1F)
```

### 16.6 Attacking a treaty partner, movement guards, succession

- Human attacker on a treaty partner (`func_03ECF0`): `@HAVETREATY` ("We have
  signed a peace treaty… / Cancel Action. / Break Treaty.") at 0x3F130 — row 2
  sets the war bit (0x3F298), clears the treaty (0x3F2A5) and continues, then the
  `@CANCELPEACE` announcement (0x3F22F). AI attacker → `@DECLAREWAR` (0x3F262);
  human victim → `@SNEAK` "Sneak attack by the treacherous {%STRING0}!"
  (0x3F1B4). A second `@HAVETREATY` site exists in the order-issuing flow
  `func_021FF2` @0x220CE (UI trigger unmapped).
- Movement guards: `@NOWARSDURINGREV` ("Foreign colonies cannot be attacked
  during the {War of Independence}.") emitted at 0x5A912 inside the
  foreign-colony attack handler `func_05A862`, reached only under the
  war-declared gate `test [0x5382],1` @0x5A8C8; `@TRADEATWAR` at 0x5A458 and the
  Jan-de-Witt gate `@TRADEMERCANTILISM` (Founding Father 4) at 0x5A469 in the
  foreign-colony trade entry `func_05A40E`.
- `@SUCCESSION` (War of the Spanish Succession, `func_03C638` @0x3C76A, MSS2
  advisor): the whole-map power merge of section 18.7. Skipped in multiplayer
  (gate 0x3C63D).


## 17. Congress, bells, and Founding Fathers

Liberty bells produced by colonies accumulate per power toward the next session
of the Continental Congress, which appoints one of 25 Founding Fathers. Fathers
are permanent: nine apply a one-time effect on acquisition; the rest are
continuous gates tested at each affected mechanic via the owned-bit reader
`func_00BC10`. The F3 advisor report ("CONTINENTAL CONGRESS ACTIVITIES") shows
the running totals.

### 17.1 Bell accrual

The per-power production phase `func_02F052` first zeroes `bells_per_turn`
(PowerRecord +0x0E := 0 at 0x2F23F), then loops all colonies owned by the power
and runs the colony-turn processor `func_02D658` on each. Its sole Congress call
site, 0x2D6A7, invokes the driver `func_03C322(nation, bells)`: bells accrue
into `[0x84FC]+0x0C` (pool) and +0x0E (per-turn display). If no candidate is
selected (`+0x12 < 0`) the pick dialog runs; when the pool reaches the cost the
acquisition runs.

### 17.2 The bell-cost formula (`func_03C282`, file 0x03C282..0x03C322)

```text
diff = [0x53A6]; year = [0x538A]; ff = PowerRecord[power]+0x14

if power < 4 and controller [0x543F+power*0x34] == 0:   # human European
    cost = (diff + 3) * 16                              # 0x3C29C
else:                                                   # AI
    cost = (14 - diff) * 8                              # 0x3C2A9
for gate in (1600, 1650, 1700, 1750):                   # 0x640/0x672/0x6A4/0x6D6
    if year >= gate: cost += cost >> 1                  # each gate compounds x1.5
cost = (ff + 1) * cost + 1                              # 0x3C302
if ff == 0: cost >>= 1                                  # first father half price (0x3C30B)
if [0x5382] & 1:                                        # after declaring independence
    cost = diff * 1500 + 2000                           # 0x3C30D (diff*0x5DC + 0x7D0)
```

Cross-check: a human at difficulty 1 holding one father, pre-1600, gives
`(1+1)*((1+3)*16)+1 = 129` — the observed "Brewster next = 129". The F3 subtitle
"(NN in MM)" is `NN = cost - pool`, `MM = cost` (F3 body call at 0x37B08); there
is no graphical progress bar anywhere in the game.

### 17.3 The pick dialog (`@WHICHFREEDOM`)

Candidate build `func_03BFD2`: the father table is the runtime array 0x9652,
stride 6, loaded from NAMES.TXT `@FATHERS` (25 rows: +0 name id, +2 category,
+3/+4/+5 era-weight bytes). The era band is year <1600 / 1600–1699 / ≥1700
(`func_03B95A`, year gates at 0x3B963). For each of the 5 categories
(Trade/Exploration/Military/Political/Religious, names from NAMES `@FOUNDING`)
one candidate is drawn by weighted random over the un-owned fathers with nonzero
current-era weight — `budget = random_int(1, Σweights)`, subtract-walk until
≤ 0 (0x3BFFC–0x3C046). An empty category produces no row.

The dialog (width 190) lists up to five rows "FATHERNAME (Category Adviser)";
row id = category+1. It **cannot be cancelled** — a result ≤ 0 re-shows the
dialog (0x3C231). Right-click/help (`[0x1F68]`) opens the Colonizopedia FATHER
page for the candidate (0x3C24E), then re-shows. The choice is stored to
`PowerRecord +0x12` (0x3C269). The AI picks its category via `func_03BA5A`
(internals unmapped).

### 17.4 Acquisition flow (`func_03BC42`)

On reaching the cost: the owned bit — bit `(f & 7)` of
`[0x880F + nation*0x13C + (f>>3)]` — is set, and the first-owner byte
`[0x53A9 + f]` records which power got the father first. Player flow: the
`@FREEDOM` popup ("%STRING1 Founding Fathers announce that {%STRING0} has joined
the Continental Congress!") → the congress splash `func_03BB4A`: full-screen
CCBKGD.PIK (asset id 0x1253 pushed at 0x3BB6A, no frame/title/OK chrome),
portraits drawn **without** the new father, present, then the bit is set and the
screen redrawn — the new portrait "lights up" — with sound 8 and a wait-key
(0x3BC14); then the pedia FATHER page (0x3BD26). Bookkeeping: `+0x14`++,
`+0x12 := 0xFFFF`. Portraits are the 25 sheets CC-00..CC-24.SS (1:1 with
`@FATHERS` order); each owned portrait is blitted at the coordinates baked into
its own sheet frame-0 descriptor (`es:[bx+0x46/0x48]`) — positions live in the
art, not the code.

Per-father **instant** effects applied by the acquisition dispatcher:

| id | Father | one-time effect (site) |
|----|--------|------------------------|
| 1 | Jakob Fugger | clear all boycotts: PowerRecord +0x20 := 0 (0x3BD45) |
| 6 | Francisco Coronado | reveal every colony on the map (0x3BF54) |
| 9 | Sieur de La Salle | free Stockade for own colonies of size ≥ 3 (0x3BD4A) |
| 14 | John Paul Jones | spawn a free Frigate, unit type 0x11 (0x3BD8B) |
| 16 | Pocahontas | reset all native attitudes to content (0x3BDDD) |
| 18 | Simón Bolívar | revolution meter [0x53D0] += 20, cap 100 (0x3BE64) |
| 20 | William Brewster | dock pool: Petty Criminals/Indentured Servants → Free Colonists (0x3BF85) |
| 22 | Jean de Brébeuf | all own missions become expert: settlement +0x05 \|= 0x10 (0x3BE77) |
| 24 | Bartolomé de las Casas | all own Indian Converts (class 0x1B) → Free Colonists 0x1C (0x3BEB2) |

All other fathers are continuous gates tested at their own mechanic (e.g.
Washington auto-promotion 0x5C758, Franklin's six diplomacy sites, Penn crosses
×1.5 at 0xA16B, Jefferson bells +50% via owned-bit 0x0F).

### 17.5 The F3 Continental Congress screen

Reached from REPORTS → F3 (menu letter 'B') and as the post-acquisition report.
Body `func_037A20` (file 0x37A10..0x3807D); overlay on CCBKGD.PIK.

```python
regions = [
    (0,   0, 320, 10, "Title: CONTINENTAL CONGRESS ACTIVITIES", "text", "fill (0,0,320,5) c=0x90; centered"),
    (0,  10, 320, 20, "Next Session subtitle: (<FF>) (NN in MM)", "text", "text-only progress"),
    (0,  36, 320,  8, "Rebel/Tory Sentiment strip",              "text", "PowerRecord +0x02"),
    (0,  44, 320, 32, "Bell row (bells/turn)",                   "art",  "sprite 0x3F filled / 0x38 empty, span 300"),
    (0,  76, 320, 40, "REF rows (2 x 4-column count badges)",    "art",  "counts 0x53DA..0x53E8; icons runtime BSS [0x52xx]"),
    (0, 116, 320, 60, "Founding Fathers list (plain text)",      "text", "owned-father names, marker sprite 0x61"),
    (290,184, 26, 14, "OK",                                      "hit",  "dismiss"),
]  # 320x200 Mode 13h; band rects (measured; not byte-cited), text params byte-cited
```

Fonts and inks: whole body FONTTINY; title color 0x90 (pale yellow), body 0x92
(bright yellow) against the CCBKGD palette; left margin x=4, y seed 25
(0x37A4E/0x37A49), line pitch = glyph height 6 + 2 = 8 px (0x37BD1–0x37BDB).
The bell row uses the shared proportional count-strip verb 0x181F:0x236
(`func_002EE4`): `stride = (300 - sprite_w)/(count-1)` clamped to
`[1, sprite_w+1]` — many bells overlap toward 1 px pitch; fullness is filled-vs-
empty sprites, never a gauge. REF land badges at 0x37E1C (counts
[0x53DA]/[0x53DC]/[0x53E0]/[0x53DE] — the screen draws Artillery before
Man-O-War), war-stage naval badges at 0x37EFE (counts [0x53E2]..[0x53E8]); each
row is a 4-column proportional badge layout (open 0x181F:0x218, flush 0x22C,
span 300). No US-flag sprite is drawn anywhere in the F3 body or the reveal
popup (byte-verified negative).


### 17.6 Crosses and immigration

The crosses→immigrant step is `func_0363A2` (0x0363A2..0x036573):
accumulated crosses live at `PowerRecord +0x2E` (add 0x0363F5, reset
0x03645E) and the threshold at `+0x30` (written 0x0363EF from the return of
`func_035D9A`). A new colonist appears on the Europe dock when the
accumulator exceeds the threshold (0x036404), announced through `@UNREST`
("Religious unrest in %COUNTRY causes increased emigration…") with tutorial
T5 chained after.

**The threshold** (`func_035D9A`): `accum` = Σ of the player's colony
populations (+0x1F, loop 0x035DB0) + 1 per owned unit (0x035DD8..0x035DF8);
then `if accum < 4000: accum ×= 2` (0x035E35), `+= 8` (0x035E38), hard clamp
4000 (0x035E44); difficulty scale `×(8−d)/8` for the human (0x035E5D);
**England ×2/3** (0x035E75..0x035E7B). A bigger empire therefore *slows*
immigration. The main per-turn crosses *accrual* into `+0x2E`
(church/cathedral production) is explicitly unidentified in the repo — TBD.
William Penn multiplies colony cross production ×1.5 (0xA16B).

**Who arrives**: the dock holds 3 candidates at `PowerRecord +0x02..+0x04`;
the arrival picks slot `random_int(0,2)` (0x036462) and the slot refills from
the generator (`func_034C24` path): a 3-tier ladder with threshold
`(lvl+3)>>1` where `lvl` = difficulty for the human — `random_int(1,15)` →
Petty Criminal 0x1A, else `random_int(1,10)` → Indentured Servant 0x19, else
`random_int(1,8)` → Free Colonist 0x1C; **William Brewster** (FF 0x14)
upgrades the criminal/servant results to Free Colonists (0x34C79) and also
rewrites the standing dock pool (0x3BF85) and unlocks choosing the emigrant
(0x36437). Harder difficulty ⇒ more low-tier arrivals. Every fourth turn
(`turn&3 == 0`) the generator instead draws professional types from
per-power counters. Recruit gold prices come from the pool word
`0x978C + slot·6 + 4` (reads 0x035114/0x051E52) — a documented in-repo
conflict flags the same table as the Europe ship/artillery purchase catalog
(Artillery 500, Caravel 1000, Merchantman 2000, Galleon 3000, Privateer
2000, Frigate 5000, fills 0x07497E..0x0749D8); only Artillery escalates
(+100 per unit bought, `+0x1E` counter). The F2 adviser gauge renders
`+0x2E of +0x30` ("(%d of %d)", `func_037958`).

## 18. Revolution, the King, and multiplayer

The endgame pivots on one meter, one flag word and one power id: the national
Sons-of-Liberty meter `[0x53D0]` (0..100), the game-state bits `[0x5382]`, and
the King/REF power `[0x53D2]`. Declaring independence flips `[0x5382]` bit 0,
turns the Crown's standing Expeditionary Force into an on-map power, and is won
by attrition, not by timer.

### 18.1 The revolution meter `[0x53D0]`

Initialized 0 at new game (0x75620); Bolívar adds +20 capped at 100 (0x3BE64);
the king's tax-severity score reads it (0x361F9). The endgame dispatcher at
0x2391C clamps it to 75 (0x2392A) and routes: below 75 with `[0x53D2] < 0` → the
Spanish-Succession arm; at/above 75 → the revolution handlers. In hot-seat
multiplayer (`[0x5381]&0x80`) the pre-war state is held at this 75 cap and the
auto-revolution arms are suppressed.

### 18.2 Declaring independence

| event_id | string_key | trigger | condition | options | outcomes | arms |
|---|---|---|---|---|---|---|
| declare-1 | `@ALREADYREVOLUTION` | Declare-Independence command → `func_03E984` | `[0x5382]&1` already set (0x3E988) | — | none (return) | — |
| declare-2 | `@TOOTORY` | same | `[0x53D0] < 50` (cmp 0x32 at 0x3E99E) | — | shows "Only {%NUMBER0%%} of the colonists support the independence movement… We cannot start a rebellion against the King until the {majority} is behind us."; return | — |
| declare-3 | `@MULTIREV` | same, hot-seat only | `[0x5381]&0x80` (0x3E9C5) | "Declare independence" / "Never Mind" | on confirm: `and [0x5381],0x7F` (0x3E9D3) — the game demotes to single-player exactly as the text warns | falls through to declare-4 |
| declare-4 | `@DECLARE` | same | SoL ≥ 50 | "Never! That would be treasonous! God save the King!" / "Yes! Give me liberty or give me death!" | rebel power `[0x5398] := [0x5394]` (0x3E9D8); on row 2 → `func_03DE46` (0x3EA06) | declaration |
| declare-5 | `@INDEPENDENCE` | `func_03DE46` | — | — | `[0x5382] \|= 1` (0x3E031); declaration year to `[0x53A7]/[0x53A8]` (0x3DE65); initial REF dispatch | war |

### 18.3 Game-state bits `[0x5382]` (word; save block #3)

| bit | meaning |
|-----|---------|
| 0x0001 | War of Independence declared (stage 1) |
| 0x0002 | foreign intervention active (stage 2; set by `func_03D948` @0x3DA22) |
| 0x0008 | independence WON (set 0x2F55A; gates the score bonus) |
| 0x0010 | REF-arrival phase flag (set 0x2FAE0); also gates the Congress driver off |
| 0x0020 | forced/end-stage flag (set by the dispatcher once SoL≥75+declared+intervention, and by `@FORCED` stage d) |
| 0x0080..0x8000 | the Game Options word (high-byte rows: Tutorial Hints 0x0080, Water Cycling 0x0100 inverted, Combat Analysis 0x0200, Autosave 0x0400, End of Turn 0x0800, Fast Slide 0x1000, cheat master 0x2000, Show Foreign 0x4000, Show Indian 0x8000) |

Victory: the per-turn resolver at 0x2F464 (runs while bit 0 set, bit 3 clear)
counts surviving King-owned units of types {6, 8, 0xB}; when the count falls
below the threshold (1 normally, 8 when bit 0x40 is set; 0x2F4D2–0x2F4E5) and
the intervention tally clears, `or [0x5382],8` (0x2F55A) — the rebels win, the
message built from the rebel record `[0x5398]*0x34+0x540E` (0x2F510). If
independence is won and was declared before 1780, the score gains
`(1780 - declaration_year) * 2` (0x3A609).

### 18.4 The King's power and the `@FORCED` staged advancer

The REF exists pre-war only as the four count globals (0x53DA..0x53E0), seeded
at new game by `func_0755CC` (`8d+15 / 5d+5 / 3d+2 / 6d+2` for difficulty d) and
grown by `func_03E162` (royal fund +0x22 accrues `(8*diff+10)*2^era` per turn;
at ≥ 1800 buy one unit, subtract 1800, slot by ratio). At the war transition the
Crown becomes a real on-map power whose id lands in `[0x53D2]`.

Cheat id 0x68 "Advance Revolution Status" (handler 0x2391C, DEBUG.TXT `@FORCED`)
advances one stage per invocation and documents the staging exactly:

| stage | condition | action |
|-------|-----------|--------|
| a | `[0x53D0] < 75` | set meter to 75 + create the REF power if none (0x191F:0x364 → `func_03C638`) |
| b | — | declare independence (0x191F:0x356 → `func_03DE46`, `[0x5382]|=1`) |
| c | — | next war stage (0x191F:0x348 → `func_03D948`, `|=2`) |
| d | — | `[0x5382] |= 0x20` + show the `@FORCED` text |

Stages b–d are blocked while `[0x5381]&0x80` (multiplayer).

### 18.5 The King audience screen

One renderer, `func_075352` (file 0x075352), paints the audience/tax-demand, the
loss and the win screens. Assets: backdrop **KINGLSS1.PIK** (throne room, empty
chair, blank scroll); outcome-selected foreground sheet **KING1.SS** (audience) /
KINGLOSE / KINGWIN — the king-and-dog figure, 189×187 — plus the nation banner
sheet (nation stem + digit, e.g. ENGLND1.SS, the throne-canopy banner). Variant
select at 0x75430 from the two stack args; nation prefix from `[0x5398]`
(switch 0x753BB: ENGLND/FRANCE/SPAIN/DUTCH). Callers: audience sequencer
`func_075594` (pushes 1,1 → KING1), and the King-event orchestrator `func_02F3A2`
(loss at 0x2F552, win at 0x2F6A8).

```python
regions = [
    (0,   0, 320, 200, "KINGLSS1.PIK throne room",       "art",  "full-screen backdrop"),
    (0,  12, 189, 187, "KING1/KINGLOSE/KINGWIN.SS king",  "art",  "bottom-anchored to row 199 (frame-descriptor anchor)"),
    (32,  0,  -1,  -1, "ENGLND<d>.SS canopy banner",      "art",  "nation-selected; size from sheet"),
    (232, 29,  80,  40, "speech header, 4 lines",         "text", "per-line centered on x=271.5, tops y=29..61 (measured; not byte-cited)"),
    (232, 69,  86,  72, "speech body, 9 lines",           "text", "left x=232, pitch 8 = FONTKING H+1 (measured; not byte-cited)"),
]  # 320x200 Mode 13h
```

FONTKING is loaded at 0x754F6; the pen stores (242,47) at 0x75526/0x7552C are
engine register values, not the on-screen origin — the glyph runner re-lays the
text under mode flags `[0x1F56]|=0x18` (0x75538). Body text is runtime-built by
`func_02F3A2` from the GAME.TXT tax family; the pen/ink is restored to the
FONTINTR color on exit (0x75576). Fade-in via the palette verb at 0x75553.

Tax-event branch keys (GAME.TXT, `@width=190`, speaker channel `[0x1F5C]=8` →
KING1.SS): `@KINGTAX` ("…we have graciously decided to raise your tax rate by
{%NUMBER0%%}. The tax rate is now {%NUMBER1%%}. If you wish, you may kiss our
royal pinky ring."), `@KINGRAISE` (punitive raise for demanding lower taxes),
`@KINGLOWER`, `@KINGNOTHING` ("…You may, however, kiss our royal pinky ring."),
`@MERCANTILISM`, `@PURCHASETAX`, pretexts `@KINGWIFE`/`@KINGWAR`/`@KINGNAVACT`/
`@KINGSTAMPACT` (severity-selected, section on taxation), options `@TAXOPTIONS`
("Kiss pinky ring." / "Hold '{%STRING3 Party}.'") and `@TEAPARTY`.

### 18.6 Hot-seat multiplayer

- **Unlock:** environment `SET COLONIZE=MULTI` (`getenv` pair at DGROUP
  0x2064/0x206D) → `[0x201E]=1` (0x70EDD–0x70EFB; also a CLI switch 0x70D0E),
  adding a 5th game-start menu entry (mode 4, 0x70B9F).
- **`@MULTI`** (new-game setup `func_07431E` @0x74531): "Select powers to be
  controlled by human players." — a checkbox dialog; each checked power gets
  controller `[0x543F+p*0x34] = 0` (read from the checkbox bitmask `[0x1F54]`);
  more than one human sets the hot-seat flag `[0x5381] |= 0x80` (0x745D5); none
  checked defaults to England.
- **`@MULTINEXT`** (turn loop @0x597C): between human turns the screen blanks
  and shows "^^{%STRING0} Player Turn … Press any key for {%STRING0} player's
  turn." (advisor 2), then the view power switches and re-centers.
- Consumers of `[0x5381]&0x80`: rebel sentiment clamped to 75 with
  auto-revolution suppressed (0x2391C region); `@FORCED` stages b–d blocked; the
  Spanish-Succession merge skipped (0x3C63D); `@MULTIREV` demotes the game to
  single-player on a confirmed declaration (18.2).

### 18.7 The War of the Spanish Succession merge

Handler `func_03C638` (event id 0x68 in the master event dispatcher; gate:
`[0x53D0] < 75` clamped, `[0x53D2] < 0`, single-player only). It ranks the four
powers by `3*[0x9418+p] + 2*[0x9298+p] + [0x9410+p]` (0x3C655–0x3C66B, sort
0x3C68E), picks the weakest eligible AI as ceding and the strongest as
beneficiary, emits `@SUCCESSION` ("War of the Spanish Succession ends in Europe!
{%STRING0}, ravaged by war, agrees to cede %STRING1 to the {%STRING2}. Treaty of
Utrecht specifies that all {%STRING3} possessions in the New World now fall
under {%STRING2} rule.", 0x3C76A), then rewrites every map-tile owner nibble
(0x3C7AF–0x3C80C), every unit owner (0x3C81D), every colony owner (+0x1A,
0x3C8A0), and a third owner-nibble table (0x3C8CA–0x3C8FE). Aftermath: the
ceding power's controller := 2 "eliminated" (0x3C91A) and its id stored to
`[0x53D2]` (0x3C922); the power thereafter renders as "(Withdrawn from New
World)" (LABELS `@MISC`). What transfers is exactly tiles, units, colonies and
the third owner table — no treasury, father, trade-route or Europe-dock
transfer is documented. The gate that *enqueues* event 0x68 is an unresolved
residual (the dispatcher `func_0235D6` has no located caller); the same
handler is reachable from cheat `@FORCED` stage (a) (§18.4).

### 18.8 The tax petition — how the King eases (or punishes)

Handler `func_034AE0` (file 0x034AE0..0x034B7D, dispatched as case 4 of the
king-action switch `func_034C24` at 0x34C05, inside turn phase 4). Three
guards, then a roll, then one of three outcomes:

- **Guard 1** (0x034AE8): return if `tax_pct ≤ 1`. **Candidate** raise =
  `delta·turn_factor` with `delta = ((diff & 0xFE) << 1) + 4` (0x034AEE) and
  `turn_factor = turn/400 + 1` (0x034AFC).
- **Guard 2** (0x034B10): if `candidate + 5 ≥ tax_pct` → **@KINGRAISE** path.
- **Guard 3** (0x034B1A): if `tax_pct ≤ candidate` → **@KINGNOTHING**
  (0x034B33: "…kiss our royal pinky ring.", no options).
- **Roll** (0x034B25): `random_int(1, diff+1)`; result 1 → **@KINGLOWER**
  (probability `1/(diff+1)` — the Crown eases more readily at low
  difficulty). Lower amount = `random_int(5 − diff, 1)` negated for display
  (0x034B44..0x034B5C: "…lower your tax rate by {%NUMBER0%%}").
- **@KINGRAISE** amount = `random_int(diff, 1) · 2` — the punitive raise is
  doubled (0x034B62..0x034B7D: "Your DARE to demand lower taxes!…"), and it
  carries the `@TAXOPTIONS` pair, so it can chain into a Tea Party (§23.4).

Open items, stated plainly: no player-facing "request lower taxes" control is
documented anywhere in the UI specs (the "player demands" framing is
narrative); the outbound announce goes through the overlay at `0x191F:0xAE0`
whose internal tax write is untraced; the per-turn call frequency of
`func_034AE0` is unmapped. The tax write-site clamp itself is byte-cited: any
applied delta lands at `func_034318` 0x03434C with the hard clamp at 75
(0x03434F).

### 18.9 The King's mercenaries

Two distinct offers, both priced per unit in hundreds of gold. (The manual's
§23.4 event table has no mercenary row — this subsection is the coverage.)

**Peacetime** (`func_03E664`, 0x03E664..0x03E842, turn phase 1): gated off
once the revolution starts (`[0x5382]&1`), then a **1-in-21** roll
(`random_int(0,0x14) != 0` → return, 0x03E66A); the offering power must hold a
peace treaty (relation bit 0x40, 0x03E6A2). Composition: `count =
random_int(1,3)` plus coin-flips that either add one more or set 1–2
artillery (0x03E6C8..0x03E703). **Fee**: `gold_per_unit = ((diff + 4)·2 +
random_int(0,6)) · 100` (0x03E713), `price = gold_per_unit · (count +
2·artillery)` (0x03E726..0x03E736). Offer dialog `@MERCENARIES` ("The King of
%STRING0 has offered to send us a force of trained {mercenaries}… No thank
you. / Pay {%NUMBER0$}."); arrival `@MERCS`. Delivered units are Veteran
Dragoons and Veteran Artillery on a Man-O-War (type table `func_03C4A2`).

**Wartime** (`func_03E442`, 0x03E442..0x03E663): a per-power one-shot bit
(PowerRecord byte 0, bit 0x08 — set on the first eligible call at 0x03E4CD,
offer possible only from the second call on), then a **1-in-3** gate
(0x03E4E8). Composition: `count = random_int(2, (4−diff)/2 + 2)` (0x03E512)
plus exactly one of Continental Cavalry or Artillery (0x03E52E..0x03E546).
**Fee**: `gold_per_unit = ((diff + 3)·2 + random_int(0,6)) · 100` (0x03E558),
`price = gold_per_unit · (count + 2)` (0x03E56B). The offer only appears if
affordable (`price ≤ treasury +0x2A`, 0x03E5FD); paying debits at 0x03E651.
Wartime types: Veteran Continental Army + Continental Cavalry / Artillery.

**Landing** (`func_03D510`, shared with the free intervention force): arrival
colony is a population-weighted random pick over up to 10 coastal colonies
(`+0x1C & 0x40`; weights = size, roll at 0x3D57E), a Man-O-War (type 0x12)
lands at the best-scored beach tile (0x03D748), troops spawn carried at the
(−2,−2) sentinel (0x03D8C8), and every land unit is stamped Veteran
(`+0x17 := 0x15` at 0x03D835).

**Mobilization at the Declaration** (`func_03E2EA`, byte-verified): for every
colony with SoL ≥ 50 (0x03E3F1), a budget `((SoL−50)·(size/2))/50` clamped ≥ 1
(0x03E3F6..0x03E425) of Veteran Soldiers/Dragoons in the stack are promoted
in place — type 1 → 9 Continental Army (0x03E37B), type 4 → 7 Continental
Cavalry (0x03E306); `@MOBILIZE`/`@MOBILIZE2`. No units are created.

### 18.10 The Royal Expeditionary Force schedule

Counts live at `[0x53DA]` Regulars, `[0x53DC]` Cavalry, `[0x53DE]` Man-O-War,
`[0x53E0]` Artillery (user-verified against the F3 display). **New-game seed**
(`new_game_state_init` at 0x7569B, difficulty d): Regulars `8d+15`, Cavalry
`5(d+1)`, Man-O-War `3d+2`, Artillery `6d+2` — i.e. 15/5/2/2 at Discoverer up
to 47/25/14/26 at Viceroy. **Growth** (`func_03E162`, pre-independence only,
gate 0x3E172): the royal fund `PowerRecord +0x22` accrues `(8d+10)` per turn,
doubled at each of 1600/1700/1750 (0x3E17C..0x3E1AC) — +18/turn at Explorer,
runtime-verified. At **1800** in the fund (0x3E1C6) one unit is bought
(0x3E238) and 1800 deducted (0x3E271); the slot keeps the army in ratio —
Cavalry when `(reg+2)/3 > cav` (0x3E1D5), Artillery when `reg/4 > art`
(0x3E1EB), Man-O-War when `(reg+cav+art+5)/10 > ships` (0x3E203), else
Regulars. Post-declaration the purchase is announced instead (`@KINGBUY`,
0x3E262). Sale tax funds it: every European sale routes
`gross·tax%/100` into `+0x22` (0x32A92), as do back-tax payments (0x033413).

### 18.11 The difficulty ledger — every documented d-scaled constant

Difficulty `d` = `[0x53A6]` (0 Discoverer .. 4 Viceroy; default 2 at 0x7433C,
written only by the picker at 0x705D2/0x706A3/0x7071E). The term is almost
always a **human handicap** — most sites gate on the controller byte and use
a fixed constant for AI powers.

**Starting conditions:** gold 1000 (d=0, 0x036779) / 300 (d=1, 0x036599) /
0 (d ≥ 2) — human only; units = Caravel + Pioneers + Soldiers aboard
(0x07584B..0x0758CD; Dutch ship → Merchantman 0x075875), **doubled at d ≤ 1**
by a second placement pass (0x0758F5/0x075961); REF seed §18.10; native alarm
seed `random_int(0,14) + 2d` for the human (0x65DC7/0x65DCE); year 1492
(0x757E7), map 58×72 (0x75702), price seeds `random_int(600,1000)` ×16
(0x75645). Initial tax rate: no initializer is byte-cited (UI shows 0%) — TBD.

| Mechanic | Formula in d | Site |
|---|---|---|
| Combat: human handicap | strength += (4−d), both sides | 0x5CE35 / 0x5CE54 |
| Combat: scaling | strength·d/20 | 0x05CFFC |
| Combat: generic base | d+5 | 0x3F005 |
| Treaty-respect seed | 2·(6−d), halved w/ Franklin | 0x59B00..0x59B31 |
| AI war grace period | no AI war before turn 10·(10−d) | 0x58374 |
| AI demand value | ·10·(d+8)/100, then +500·(d+1) | 0x583A0 / 0x5842B |
| AI action gate | roll(1,1000) < 200d+100 → 10..90% | 0x58315 |
| Withdrawal price | 25·(d+2)·forces, min 100, ×2 at war | 0x593B7..0x5949B |
| King tax-raise delta | ((d&0xFE)<<1)+4, ×(turn/400+1) | 0x034AEE |
| King demand cadence | interval 18→15/12/9 by era, −(d−2) human | 0x36193 |
| Tax-lower odds | 1/(d+1); lower amt random(5−d,1) | 0x034B25 / 0x034B44 |
| Mercenary fee (war) | ((d+3)·2 + rand(0,6))·100 per unit | 0x03E558 |
| Mercenary fee (peace) | ((d+4)·2 + rand(0,6))·100 per unit | 0x03E713 |
| Mercenary count (war) | random(2, (4−d)/2 + 2) | 0x03E512 |
| REF fund accrual | (8d+10)/turn, ×2 per era | 0x3E17C |
| REF seed | 8d+15 / 5(d+1) / 3d+2 / 6d+2 | 0x7569B |
| Native attitude (human) | 2·(d+3) + tribe terms, thr 0x41 | 0x46500 |
| Native attitude (AI) | tribe terms − d + 12, thr 0x32 | 0x46538 |
| Native training success | roll(1,1000) ≥ 200d+100 → 90..10% | 0x4A72C |
| Native attack chance | random((5−d)·2) | 0x48697 |
| Raze gold factor | rolls of random(1, 10−d) | 0x4AAD0 |
| King treasure cut | max(5d+50, 2·tax) ≤ 90%, tax w/ Cortés | 0x5C976 |
| Native gift/reward | 2d+15; 10·(d+rand); cap 8−d | 0x4A05A / 0x4A0C2 / 0x4A2A9 |
| Immigration threshold | ·(8−d)/8 (England then ×2/3) | 0x35E60 / 0x035E6E |
| Rival-immigration bonus | 100·(d+1) | 0x35FFB |
| FF bell cost (human) | (d+3)·16 base (§17) | 0x3C29C |
| FF cost post-declaration | d·1500 + 2000 | 0x3C30D |
| FF score penalty | ff_count·(−1−d) | 0x3A4B9 |
| SoL production divisor | 10−d (human; AI fixed 10) | 0x9D49 / 0xA05C |
| Tory penalty threshold | 10−d as count threshold | 0x27416 |
| Tory uprising gate | fires with prob (d+1)/(d+2) | 0x3CADD |
| Tory militia strength | pop·tory%·2/100 + d + 1 | (RULINGS batch) |
| Center-tile food | +2 at d=0, +1 at d=1 | 0xA295 / 0xA2A1 |
| Score multiplier | [4,5,6,8,10] = d+4+(d≥3)+(d≥4) | 0x3AA0A..0x3AA27 |
| Indian razes score penalty | razed_count·−(1+d) | 0x3A4B1..0x3A4C3 |
| Tutorial build warnings | only at d < 2 | 0x22763 |

Non-mechanics, for the record: `[0x8394+2d]` is the per-difficulty king
salutation/title pointer (text only); Lost-City-Rumor odds are scout-scaled,
**not** difficulty-scaled; European recruit prices come from a pre-filled pool
word (only artillery escalates, +100·bought).

### 18.12 The Tory uprising

Processor `func_03CAC6` (0x3CAC6; its caller is resolved-as-runtime-dispatch —
no static call site exists). There is **no SoL threshold gate** on the
trigger path (byte-verified negative); the only gate is the per-call roll
`random_int(0, d+1) != 0` (0x3CADD) — fire probability `(d+1)/(d+2)`, 50% at
Discoverer up to ~83% at Viceroy. Target = the rebel colony with the highest
**tory strength** = `pop·(100−SoL%)·2/100 + d + 1` (0x3CBE6..0x3CC06),
skipping colonies already hit (`+0x1C` bit 0, set on the winner at 0x3CC3C).
Militia spawn on the free adjacent tiles: `spawn_unit(type 1 Soldiers,
owner = the King's power [0x53D2])` at 0x3CCCF, with a random upgrade gate
promoting a spawn to Dragoons (0x3CD31); if no adjacent tile is free the
uprising is silently suppressed (0x3CD59). Message `@TORYUPRISING` ("Tory
uprising near %STRING0! Parliament arms Tory Militia!", 0x3CD94). The
in-repo wording conflict on militia count (≤ 8 per free tile vs
strength-counted-down) is unresolved — flagged.

### 18.13 Scoring and the Hall of Fame

Component sum `func_039EE2`, seven terms into the grand total
(0x03A896..0x03A8AB): **population** (+1 per criminal/servant/convert, +2
per Free Colonist, +4 per specialist, 0x3A0BE..0x3A113); **Founding
Fathers** +5 each (0x03A2BE); **rebel sentiment** = the national meter
`[0x53D0]` ×1 (0x03A561); **razes** = razed-settlement count
(`PowerRecord +0x18`) × −(1+d) (0x03A4B1..0x03A4C5 — one spec sheet glosses
this same site as an FF penalty; flagged); **gold** = treasury/1000
(0x3A3F2); **post-intervention bells** = `+0x0C`/100 gated on the
intervention flag (0x3A704..0x3A724); **revolution bonus** = `(1780 −
declaration_year)·2`, additive, only if independence was won and declared
before 1780 (0x3A5F5..0x3A609 — the retail manual's "×2.0 multiplier"
framing is byte-refuted). Scaler `func_03A9C0`: multiplier
`d+4 (+1 if d≥3, +1 if d≥4)` = 4/5/6/8/10 (0x3AA0A..0x3AA27), `score =
(mult·base)/100 >> 1` (0x3AA31/0x3AA6A), Hall-of-Fame rank = largest n with
`n²/3 < score`, capped 23 (0x3AA41..0x3AA79). The Hall of Fame renders on
WOODPAN2/WOODPANL in FONTINTR (title gold 0xFC), persists
`HALLFAME.DAT` — 5 shown of 6 records, stride 42, score word at `+0x26`,
descending insertion (`func_03ADA6`).

## 19. Natives

Eight tribes populate the map with individually tracked villages. The engine
keeps three layers of native state: an 78-byte per-tribe record, an 18-byte
per-village record, and two per-power anger signals (a per-village alarm word
and a 0..100 tension meter). Village interaction — trade, missions, training,
tribute, war — flows through a 10-entry action menu and the GAME.TXT
`@CHIEF*`/`@VILLAGE*`/`@INDIAN*` families.

### 19.1 Tribe records and ids

TribeData: base 0x5AD6, stride 0x4E (78), 8 entries, populated at game init from
NAMES.TXT `@TRIBES`. Field +2 is the settlement-size/level factor (CHIEFKILL
byte-trace at 0x4AB24); the byte at +3 carries the **tribe-dead bit 0x80** — the
cheat-menu tribe list tests `[0x5AD9 + i*0x4E] & 0x80` to grey out dead tribes.
Village owner ids 4..11 follow `@TRIBES` order:

| id | tribe | gift good | level | sprite |
|----|-------|-----------|-------|--------|
| 4 | Incas | Jewelled Relics | 3 | 97 |
| 5 | Aztecs | Gold Bars | 2 | 149 |
| 6 | Arawaks | Bone Jewelry | 1 | 54 |
| 7 | Iroquois | Wood Carvings | 1 | 87 |
| 8 | Cherokee | Turquoise | 1 | 67 |
| 9 | Apache | Beads | 0 | 111 |
| 10 | Sioux | Beads | 0 | 118 |
| 11 | Tupi | Gems | 0 | 71 |

(Reserve name-only tribes — Maya, Toltecs, Kiowa, … — follow in `@TRIBES` but
never instantiate.) Tribe indices 0/1 = Inca/Aztec select the special first-
contact woodcuts below.

### 19.2 The village array (base 0x54EC, stride 0x12)

```c
typedef struct {                    // DGROUP:0x54EC + v*0x12
    uint8_t map_x, map_y;           // +0x00/+0x01
    uint8_t owner;                  // +0x02 tribe/power id 4..11 (scans at 0x37638/0x45D11/0x46078)
    uint8_t flags;                  // +0x03 bit 0x04 capital (set 0x66225, doubles value 0x7DCA);
                                    //        bit 0x02 "already taught" (set 0x4A78A); bit 0x01 write-only
    uint8_t population;             // +0x04 size (CHIEFKILL input)
    uint8_t mission;                // +0x05 0xFF none; low nibble = owning power; bit 0x10 expert-mission
                                    //        doubler (Brébeuf; set 0x48C81, tested 0x57300)
    uint8_t growth_counter;         // +0x06 (runtime cross-ref; no static reader)
    uint8_t trespass;               // +0x07 escalation counter (0xFE on trespass 0x4A337; bumped on trade 0x5C3F2)
    uint8_t last_bought;            // +0x08 cargo id of last good bought
    uint8_t last_sold;              // +0x09 write-only in the static image (init 0xFF at 0x46EB6)
    uint16_t alarm[4];              // +0x0A per-European-power anger words (indexed settlement*9+power @0x4734E)
} NativeSettlement;
```

The per-power **anger words** at `+0x0A + power*2` drive the war state at
alarm ≥ 128 (raid scan 0x4734E; placement gates 0x4CAD7, 0x53D4E). A parallel
0..100 **tension table** at 0x5B1C (stride 39 words per village row, only
columns 0..3 used) is written solely by the applier `func_045DF2`:
`tension += delta`, clamped [0,100], with positive deltas halved for the French
power (0x45E21) and for Pocahontas owners (0x45E30); thresholds 75 = hostile,
100 = war (0x45E9E/0x45EB2). Notable deltas: ±1 per-turn drift, +1/+2/+3
trespass, −4 successful trade (0x5C41E), +100 incite/burial-ground desecration
(0x486F8/0x61B84), mission established negative (clamped so tension ≤ 70).

### 19.3 First contact

First contact with a tribe (handler `func_056C3E` @0x56DA6) shows woodcut 3
"MEETING THE NATIVES" — or woodcut 4 "THE AZTEC EMPIRE" (tribe 1) / woodcut 5
"THE INCA NATION" (tribe 0), with tune cues 0x33/0x35/0x36 — then the
`@INDIANWELCOME` treaty offer:

> "The {%STRING0} tribe welcomes you. We are a glorious nation of
> {%NUMBER0 %STRING1}. To celebrate our friendship, we generously offer you the
> land you now occupy as a gift. Will you accept our treaty and live with us in
> peace as brothers?"  — Yes / No

### 19.4 Village visits

Entering a village (woodcut 7 on the first) offers the NAMES `@ACTIONS` menu:
Trade With Village · Enter Hostile Village · Establish Mission · Denounce Heresy
of %Fs Mission · Live Among The Natives · Ask to Speak With Chief · Incite
Indians · Demand Tribute · Attack Village · Cancel Action.

- **Supply/demand**: the trade pricing, the "especially interested in …" line
  and the `@INDIANBEGFOOD`/`@INDIANGIVEFOOD` food events are all driven by the
  village supply/demand routine `func_048F34` — section 10 documents it in
  full (phases, capital ×2 boost, consumers).
- **Training** ("Live Among The Natives"): only outdoors skills are learnable;
  Petty Criminals are refused (`@LEARNCRIMINAL`); masters are refused
  (`@LEARNMASTER`); each village teaches once — the grant at 0x4A782 writes the
  profession into the unit's expertise byte and stamps the village flag +0x03
  bit 0x02 (`@LEARNALREADY`). Unskilled colonists succeed on
  `random_int(1,1000) ≥ 200*difficulty + 100` (0x4A72C), i.e. 90/70/50/30/10 %.
- **Chief audience** (`@CHIEFHOWDY`/`@CHIEFGIFT`/`@CHIEFAREA`/`@CHIEFGUIDES`):
  gift beads scaled by tribe, map-area reveal for scouts; `@CHIEFKILL` is the
  taboo execution outcome of razing.

### 19.5 Missions

`Establish Mission` places a mission: village byte +0x05 = owning power, with
bit 0x10 (expert) set when the founding power has Jean de Brébeuf
(`has_father(0x16)` gate at 0x48C71 → `or [bx+5],0x10` at 0x48C81); acquiring
Brébeuf retroactively upgrades all own missions (0x3BE77). Conversion
(`func_0572E6`, "INDIANSCONVERT"): each eligible turn rolls `random_int(0,15)`
against `threshold = TribeData[+2] + 2`, doubled by the expert bit — success
spawns an Indian Convert (class 0x1B) at the colony (0x57374). A destroyed
mission or expelled missionary applies a computed positive tension delta
(0x57267).

### 19.6 Attitude and anger displays

The village attitude phrase is built from a colonial-presence score banded at
cutoffs −5 / 0 / 10 into Content / Uneasy / Restless / Angry (builder
0x48B62–0x48B90); War is the separate alarm ≥ 128 state. The per-power
European attitude byte `[0x940C+p]` is a distinct diplomacy signal (section 15.5).
Pocahontas resets all village attitudes to content on acquisition and halves
subsequent tension rises. Debug bit 0x01 of `[0x894]` ("Anger & Friction
Levels") overlays the live anger word — white number
`[v*0x12 + 0x54F6 + 2*viewpower]` at village pixel (+2,+9) (0x4241) and appends
eight per-tribe rows to the map info panel (0x44303).

### 19.7 Village destruction (and the Kill-Indians cheat)

Razing (`func_04A7CA`) rolls a village-escape check `random_int(0, 40*scout+100)`
(scout = Seasoned-Scout attacker bonus) with re-rolls biased by size; on a raze
the treasure is `(Σ 3×random_int(0,10-diff)) * random_int(0,6) * 4 * (tier+1)`,
credited straight to the attacker's gold (+0x2A add/adc at 0x4AB66). The
cheat-menu item 0x67 "Kill Indians" (0x23BDC) exposes the same internals: it
builds the live tribe list from TribeData (stride 0x4E, dead bit 0x80 at +3) and
calls `func_046FC2`, which destroys every village whose owner equals tribe+4 —
confirming the owner-id convention and the destroy path used by combat.


### 19.8 Loot — razing settlements and capturing colonies

**Indian settlement raze** (the `@CHIEFKILL` path, `func_04A7CA`; gold block
0x04AAD0..0x04AB6E):

`gold = (Σ of 3 rolls of random_int(1, 10−diff)) · random_int(1,6) · 4 · (size+1)`

— the three rolls at 0x04AADD..0x04AB06, the ×`random_int(1,6)` at 0x04AB0B,
the ×4 at 0x04AB1D, the size factor at 0x04AB20..0x04AB2D, credited 32-bit
straight to the attacker's treasury `PowerRecord +0x2A` (0x04AB5D..0x04AB6E).
**No ×100 and no Treasure unit on this path.** The size factor carries a
documented in-repo conflict: the appendix traces it to `TribeData +0x02`
(0x04AB24), while the 2026-05-30 ruling (user-verified) identifies it as
`NativeSettlement +0x04` population — the `+0x02` read was the "Apache richer
than Aztec" bug. Difficulty ceilings at size factor 21: 15,120 / 13,608 /
12,096 / 10,584 / 9,072 (Discoverer→Viceroy). The roll *before* the formula is
the village-survives check, not the payout: scout bonus for Seasoned Scouts
(0x4A7D9), `random_int(0, 40·scout+100)` (0x4A827) re-rolled against
settlement size, tribe-2 bound `(8−diff)<<scout` (0x4A84A); size ≥ 75 branches
to the big-treasure path (0x4A802). Capital razes exceed the formula ceiling
in both captured data points — a capital-only bonus exists whose magnitude is
unmapped (TBD). The **Treasure-unit spawn** lives on the colony-combat path
(`func_05CA7E`): `spawn_unit(type 0xA)` at 0x05E4FF, value/100 stored in the
unit's class byte (0x05E516), ×100 for display (0x05E51A), `@LOOT`/`@LOOT2`.
Cortés does not touch raze gold — his documented effect is the King's cut of
*transported* treasure (`func_05C878`: cut = tax rate with Cortés, else
`max(5·diff+50, 2·tax)` clamped ≤ 90, 0x5C965/0x5C976 — the `@LOOTCASH`
`%NUMBER1`).

**European colony capture** (inside `func_05CA7E`, math at 0x05DE1E):

`loot = (colony.population · victim.gold) / max(Σ populations of victim's colonies, 1)`

— population `+0x1F` read at 0x05DE1F, the victim's whole-empire population
summed over the colony table (owner match at `0x5D60`, 0x05DDD4..0x05DDFF),
divisor clamped ≥ 1 (0x05DE05), 32-bit multiply/divide (0x05DE35/0x05DE3C),
then the gold moves victim → attacker (0x05DE49 / 0x05DE59..0x05DE63) — the
victim loses a population-weighted *share of its entire treasury*. The block
is **gated off during the War of Independence** (`test [0x5382],1` at
0x05DE11). Message `@CAPTURED` ("{%STRING0} march into {%STRING2}!
{%NUMBER0$} plundered!"). No Crown cut exists on this path; `@LOOTCASH`
belongs to treasure-fleet arrival only.

### 19.9 Alarm, tension, and raids

Two meters exist. Per-settlement **alarm** words sit at `NativeSettlement
+0x0A + power·2` (raid/hostility trigger at ≥ 128, tested 0x4734E/0x4CAD7/
0x53D4E). The separate **tension** table at `DGROUP:0x5B1C`
(`word[(row·39 + col)·2]`, getter 0x0082A0, only the 4 European columns ever
touched) runs 0..100 — hostile at ≥ 75 (0x47328), war at 100 (0x45EB2).
The applier `func_045DF2` clamps every delta to [0,100] and **halves positive
deltas** for France (power 1, 0x45E21) and for any power holding
**Pocahontas** (FF 16, 0x45E30). Documented deltas: per-turn drift ±1
(0x4857D/0x485A7), trespass +1/+2/+3 by severity (0x4A2E8/0x4A319/0x4A674),
successful trade −4 (0x5C41E), mission established — computed negative,
clamped so tension ≤ 70 (0x571EB), mission destroyed + (0x57267),
incite +100 / rival −100 (0x486F8/0x4870C), **burial-ground desecration
+100** (0x61B84) — instant war footing. The six `@PISS0..5` anger-source
strings (roads, deforestation, missionaries, unprovoked attack, population
pressure) carry no documented numeric deltas — TBD.

**Raids** (`native_raid_outcome_dispatch`, `func_05BE84`): gate roll
`random_int(1,12) − 1`, biased +(d−2) against a human European owner
(0x5BF1A), versus threshold `3·K + 1` (0x5BEE5; K's meaning unmapped); then
outcome `random_int(1,4)` (0x5BF35), downgraded while `turn < 40·(2−d)`
(0x5BF44), dispatched five ways (0x5C026): `@RAIDSTORES` (goods stolen —
bumps the settlement's raid budget +0x08 and wealth +0x0A, 0x5C3CC),
`@RAIDWREAK` (0x5C1DE), `@RAIDGOLD` (0x5C5F7), `@RAIDBURN`/`@RAIDSHIP`
(0x5C50B/0x5C57B), and `@RAIDNOTHING` — "raiding party wiped out"
(0x5C637). The concrete payloads of WREAK/BURN/GOLD/SHIP beyond their
messages are unmapped — TBD.

## 20. Turn flow and persistence

A turn is one pass of the resident loop `func_005760` (file 0x5760): for each of
the four European powers in strict index order it runs King → Orders →
Production → Diplomacy → Periodic, then a once-per-turn year-advance and
autosave tail. Natives are not a separate top-level pass — their AI runs inside
the per-power processing. Saves are verbatim memory dumps: 43 raw DGROUP blocks
behind a "COLONIZE" magic, no compression, no reordering.

### 20.1 The per-power phase chain

| phase | function | contents |
|-------|----------|----------|
| 1 King/mercenary | `func_03E664` (call 0x58E2; gated `[0x5382]&1==0`) | peacetime mercenary roll (0x3E707) and King events |
| 2 Orders/movement | `func_024A48` (0x58E7) | per-unit orders pump; REF fund accrual `func_03E162` rides here (via 0x24B42); AI unit moves `func_04E2D6` with the contact evaluator `func_059B90` firing diplomacy on unit-vs-tile encounters (section 16.1) |
| 3 Production | `func_02F052` (0x59EA) | zeroes bells/turn (+0x0E at 0x2F23F); per-colony turn processor `func_02D658` — yields, food/starvation/spoilage report popups, school teaching, bell accrual into the Congress driver `func_03C322` (0x2D6A7) |
| 4 Diplomacy | `func_052F7E` (0x5A37) | king-action dispatch `func_034C24` (tax raises are event-driven here, not periodic); AI diplomacy |
| 5 Periodic/congress | `func_02F3A2` (0x5AE5) | colony stats `func_042138`, Founding-Father congress `func_03B2F8` (gated `[0x5382]&0x10==0`), King defeat/victory screens (0x2F552/0x2F6A8) |

The **market drift** is an end-of-turn phase of its own: the end-of-turn
processor `func_0755CC` calls the drift driver `func_036574` at 0x757B0, which
clears the per-power 16-good accumulators and runs the four-power loop into the
drift function `func_0305A8` (price base relaxes by `(base + Σ clamped trade)/256`
per good). Immigration crosses (`func_035D9A`) run immediately after the price
recompute (0x363E2), followed by the religious-unrest arrival chain (`@UNREST`).

Year cadence (loop tail 0x5A9D–0x5ACC): `inc [0x538E]` every turn; before 1600
one turn = one year; from 1600 the season word `[0x538C]` toggles Spring/Autumn
and the year steps every second turn; start 1492, forced-end check at 1725
(0x5BB5 sets `[0x82B]=1`).

### 20.2 Autosave

Gated by Game-Options bit 0x0400 (row 5 "Autosave") and suppressed while the
autoplay/suppressor flag `[0x826]` is nonzero (gate 0x5AD7). Turn-loop consumers
0x58D7/0x5A29 call the helper at 0x5642: a **rolling autosave to slot 9 every
turn**, plus a **decade autosave to slot 8** when the year is divisible by 10 —
matching the manual's "most recent save in the last slot, previous decade save
beside it". A further end-game save fires near the forced 1725 end (0x5BDB,
gated `[0x82B]`). Manual slots are chosen in the `@SAVEGAME` dialog; filenames
are `COLONY<slot>.SAV` (stem at file 0x1FA82, extension at 0x1FA89).

### 20.3 The save file (serializer `func_0734F8`, loader `func_073BB0`)

Header: the 8 bytes `"COLONIZE"` + 0x1A, mode "wb". Body: **43 raw DGROUP
blocks**, each a single `fwrite(base,1,size)` — on-disk offset = sum of the
preceding block sizes; within a block, layout = the runtime struct. The loader
is a 1:1 mirror (43 `fread`s), proving no compression or field reordering.
Principal blocks:

| # | base | size | content |
|---|------|------|---------|
| 1 | `[0x081A]` | 2 | save format/version word |
| 2 | 0x853A | 4 | map width + height |
| 3 | 0x5380 | 0x8E | **game-globals block**: `[0x5382]` game flags + Game Options word, `[0x5384]` colony-report options, `[0x5386]` sound mirror, season/year/turn 0x538A–0x538E, counts 0x539A–0x539E, difficulty 0x53A6, revolution meter 0x53D0, REF power 0x53D2, REF counts 0x53DA–0x53E0 |
| 4 | 0x540E | 0xD0 | 4× AIPersonality (stride 0x34) |
| 6 | 0x5D46 | n·0xCA | ColonyRecords |
| 7 | 0x3144 | n·0x1C | UnitRecords |
| 8 | 0x8808 | 0x4F0 | 4× PowerRecord (stride 0x13C) |
| 9 | 0x54EC | n·0x12 | NativeSettlements |
| 10 | 0x5AD6 | 0x270 | TribeData |
| 13 | 0x9298 | 4 | per-power colony count |
| 15–23 | 0x940C … 0x942C | 4–8 each | per-power attitude / AI / economy word tables (incl. 0x940C, 0x941C, 0x942C) |
| 39–43 | 0x8540 / 0x853E / view words | 2 each | current colony, map cursor, viewport/scroll |

Because block 3 carries all three option words, every options dialog survives
save/load; the sound toggles `[0xA0]/[0xA2]/[0xA4]` are re-expanded from
`[0x5386]` on load (0x74249). The debug bitfield `[0x894]` is in **no** block —
debug options are session-only. No configuration file exists.

### 20.4 The music scheduler

The background rotation pump `func_004EE6` runs from the input-idle loops each
turn-idle: it skips unless background music `[0xA2]` (or a one-shot `[0x9E]`) is
on, polls the driver ("playing?" id 8), honors a forced-next tune `[0x94]`, then
seeds the RNG from the tick clock `[0x83A8]` and rolls a tune index inside a
state window — **peace** (`[0x5382]&1` clear): folk tunes 1–12 with a 1-in-9
excursion into 13–23; **War of Independence**: independence/military tunes 13–18
with a 1-in-5 excursion back to folk. Event classes requested by game code
(war fanfare, native themes 0x33/0x35/0x36, etc.) preempt via `[0x9A]`. The
index→id map is `func_004DF8`; a re-roll avoids repeating the current tune
`[0x96]`.


## 21. Random numbers

Every roll in the game comes from one Microsoft C 6.0 linear congruential
generator in the resident image, wrapped by a range-scaling helper that the
overlays reach through a single thunk. With the seed and the call sequence, all
game randomness is exactly reproducible — the colony-screen building layout is
replayed from its seed on every screen open.

### 21.1 The generator

```text
srand(seed)      @0x103C2 : stores only the LOW 16 BITS of the argument —
                            mov [0x28EE],ax ; mov word [0x28F0],0
                            (effective seed space is 16-bit)
rand()           @0x103D4 : seed32 = seed32 * 0x343FD + 0x269EC3    ; MSC 6.0 constants
                            return (seed32 >> 16) & 0x7FFF          ; AND AH,0x7F
                            seed dword at DGROUP:0x28EE/0x28F0
random_int(lo,hi)@0x0C322 : r = rand()                              ; 15-bit
                            return lo + ((r * (hi - lo + 1)) >> 15) ; inclusive range
                            reached via overlay thunk 0x181F:0x4D4
```

The multiplier 0x343FD (= 214013) occurs exactly once in the binary (byte pair
`FD 43` at 0x103D5); the `>>15` is implemented as a byte swap plus seven
SAR/RCR pairs.

### 21.2 Known seeded subsystems

| subsystem | seeding / roll | site |
|-----------|----------------|------|
| Colony building placement | per-colony deterministic seed `srand((colony_y<<8) + colony_x + dword[0x8D80])` (seed helper `func_009726`, 0x181F:0xD62, sole caller 0x25D3A); then per-plot `random_int(0, count[cat]-1)` shuffle with occupied-retry — a colony always lays out identically; `[0x8D80]` is a per-session boot value (runtime) | 0x9736 / 0x25DBF |
| Combat resolution | single inclusive roll `random_int(1, ATK+DEF)`; attacker wins if roll ≤ ATK; separate 50% ambush coin `random_int(0,1)` | 0x5B849 / 0x5D188 |
| Music shuffle | pump re-seeds from the tick clock `[0x83A8]`, rolls the tune-index window, re-rolls on repeat | `func_004EE6` |
| Founding-Father pick | weighted walk `budget = random_int(1, Σ era-weights)`, subtract until ≤ 0 | 0x3C0DB / 0x3C035 |
| Trade-route default name | new route's default name = colony name + a random `@TRADENAMES` word (collision appends " A") | `func_0610B0` |
| King tax attempt | difficulty roll `random_int(1, diff+1)` gate on the raise | 0x34B25 |
| Native raid outcome | gate `random_int(1,12)` + base outcome `random_int(1,4)` | 0x5BEFD / 0x5BF35 |
| Tory uprising | fires when `random_int(0, diff+1) != 0` — probability `(diff+1)/(diff+2)` | 0x3CADD |
| Mission conversion | `random_int(0,15)` vs `tier+2` (doubled by the expert bit) | 0x5730A |
| Lost City Rumor gold | ruins `10*3d8` (0x61770); big treasure `2*4d10` (0x617C0) | `func_061454` |

---

## 22. The string files

Every word the game displays lives in eleven plain-text `.TXT` resources shipped beside the executables, all sharing one section format: an `@KEY` line opens a section, the following lines are its body, and `@;` lines are comments. GAME.TXT holds the dynamic message templates (with `%`-substitution slots), LABELS.TXT the static UI labels, NAMES.TXT the game-data taxonomy whose *row order is the runtime id*, PEDIA.TXT the encyclopedia, MENU.TXT the pull-down menu tree, DEBUG.TXT the cheat/debug dialogs, WOODCUT.TXT the event-screen captions, and MAPEDIT.TXT/MAPMENU.TXT the map editor's text. This chapter inventories all of them and specifies the template grammar and the engine that renders it.

### 22.1 File inventory

| File | `@`-sections | Role |
|------|-------------:|------|
| GAME.TXT | 499 | dynamic message/dialog templates (semantic catalogue counts 510 sections; the raw file also carries valueless directive lines) |
| LABELS.TXT | 7 | static UI labels (`@INFO` 4 · `@MISC` 221 · `@ROUTE` 9 · `@CMISC` 3 · `@CTITLE` 10 · `@CMESSAGE` 19 · `@EUROLABEL` 4) |
| NAMES.TXT | 31 | data taxonomy — row index = runtime id |
| PEDIA.TXT | 166 | Colonizopedia articles + category index |
| MENU.TXT | 8 | in-game menu bar (`@GAME @VIEW @ORDERS @REPORTS @TRADE @CUP @PEDIA @END`) |
| DEBUG.TXT | 20 | cheat/debug dialogs (4 sections dead) |
| WOODCUT.TXT | 1 | `@WOODCUT`, 17 caption lines (0–16) |
| MAPEDIT.TXT | 19 | map-editor dialogs (MAPEDIT.EXE only) |
| MAPMENU.TXT | 5 | map-editor menu bar (`@GAME @VIEW @CUP @HELP @END`) |
| OPENING.TXT / CLOSING.TXT | 3 / 2 | intro/outro cinematic scripts (`@CREDITS`/`@OPENING`/`@CLOSING` timing rows + `@MESSAGES` "Loading Game...") |
| COLONY.TXT / TRIBE.TXT | 5 / 9 | colony-name pools per nation; native-settlement coordinate lists per tribe |

### 22.2 GAME.TXT — the message bank

499 sections. The major key families:

| Family | Keys | Notes |
|--------|------|-------|
| Boot & options dialogs | `@BEGINMENU @AMERICA @GAMEOPTIONS @COLONYOPTIONS @SOUNDOPTIONS @SAVEGAME @LOADGAME* @PICKNATION @DIFFICULTY @LEADERNAME @LANDHO` | checkbox/options dialogs of Part V |
| Music pickers | `@PICKMUSIC @PICKINDEPENDENCE @PICKMILITARY @PICKINDIAN` | see §24.2 |
| European diplomacy | 48 sections: 42 `@width=220` conversations + 6 `@width=190` announcements/guards + 5 support lists (`@GREATKINGS @GREATDEEDS @GREATLEADER* @MEEKNESS @FRIEND`) | keys are **built at runtime** from a fragment pool at file 0x1F250+ ("MEEK" 0x1F250, "MANLY" 0x1F255, "HELLO" 0x1F267, "AHOY" 0x1F26D, "FIRST" 0x1F272, "USA"…), which is why full names never appear as string literals |
| Tutorials | `@TUTORIAL1..19` + `@TUTNOLUMBER @TUTNOSPACES` | see §23.2 |
| Intro caption cards | `@BUILD1..10` | one per LEVN000n.PIK card, rendered at pen (14,54) during world generation |
| Nation flavour | `@NATION0A/0B..3A/3B` | two briefing pages per power |
| Hot-seat multiplayer | `@MULTI @MULTINEXT @MULTIREV` | unlocked by `SET COLONIZE=MULTI` |
| Trade routes | `@TRADESTART @TRADETYPE @TRADENAMES @TRADENAME @TRADENONE @TRADENONE2 @TRADESELECT @TRADEDELETE @ROUTELOOP @TRADEWITH @TRADENOCARGO @TRADENOWANT` | `@TRADENAMES` = "5 / Run / Ferry / Cargo / Transport / Triangle" (count + 5 name stems) |
| Unit-option menus | `@UNITOPTIONS @SHIPOPTIONS @ARMOPTIONS @EUROPESHIPOPTIONS @EUROPESHIPCLICK @EUROPEARM` | dock/unit right-click order menus |
| King & tax | `@KINGTAX @KINGRAISE @KINGLOWER @KINGNOTHING @KINGNAVACT @KINGSTAMPACT @KINGWAR @KINGWIFE @MERCANTILISM @PURCHASETAX @TAXOPTIONS @TEAPARTY` + audience/war keys `@KINGRECRUIT @KINGFUND @KINGGALLEON2/3 @KINGFRIGATE @KINGNEWWAR @KINGVICTORY @KINGMERCY @KINGBUY @KINGMOBILIZE @KINGLOSE @KINGWIN @KINGBLESS @KINGLAUGH @KINGNO @KINGWELCOME0` | see §23.4 |
| Lost City | `@LOSTCITY0..9 @BURIAL1..3 @SCREWED @VANISH` | see §23.5 |
| Native events | `@INDIAN*` (welcome/treaty/gifts/war), `@RAID*` (6-key block at file 0x1F52A + orphan `@RAIDSCALP`), `@CHIEF*`, `@EXTORT*`, `@VILLAGE*`, `@LEARN*`, `@MISSION0..3`, `@HERESY0/1` | see §23.6 |
| Revolution | `@DECLARE @INDEPENDENCE @TOOTORY @ALREADYREVOLUTION @MOBILIZE* @UPKEEP @WARN1..3 @INTERVENTION @INTERVENE @CONSIDER @SUCCESSION @SEIZURE* @INVASION @REFIT` + guards `@NOWARSDURINGREV @NOCOLONIESEITHER @NOMAYORSDURINGREV @EUROPENOTAVAIL @FOREIGNNOTAVAIL` | see §23.7 |

Layout directives across the whole file: the `@width` histogram is {190: 336 sections, 220: 99, 300: 11, 310: 10, 160: 8, …}; only 21 sections carry a literal `@x`/`@y` (menus, tutorials, and the King-audience trio `@VICEROY` x=232/y=21, `@KINGLOSE` x=232/y=31, `@KINGWIN` x=202/y=125). No gameplay event popup is pinned — they all centre.

### 22.3 LABELS.TXT — the `@MISC` string-ID table

LABELS.TXT carries no substitution slots; it is pure label text. Six of its sections are consumed positionally (`@INFO` unit-info panel, `@CMISC`/`@CTITLE`/`@CMESSAGE` colony screen, `@EUROLABEL` Europe buttons, `@ROUTE` trade-route editor). The 221-line `@MISC` section is special: it feeds a runtime **string-ID table**.

- **Loader** (at file 0x75226–0x7523C, in the page-0x1A boot loader cluster): opens file "LABELS", selects section "MISC" (via 0x191F:0x928), then loops idx 0..220 (`cmp 0xDD` @0x75237) storing one interned value per line with `mov [bx+0x2DBA],ax` (`shl bx,1`).
- **The slots hold integer string IDs, not pointers.** Live values run **327..547 sequential**; they are resolved to text through the fetch verb **0x181F:0x22**. (A snapshot oracle that dereferenced slot value 537 as an address landed mid-string — the ID model is the byte-proven one.)
- **Slot formula:** any DGROUP word at offset O in 0x2DBA..0x2F72 holds `@MISC line = (O − 0x2DBA)/2`.

Notable slot map (line = slot index):

| Line | Text | Line | Text |
|-----:|------|-----:|------|
| 0/1 | "a" / "an" | 106 | "and" |
| 2 | End of Turn | 108 | ENCYCLOPEDIA OF COLONIZATION |
| 29/30/37/49–52/93 | the advisor-report titles (F9/F2/F3/F4/F5/F6/F7/F8) | 109/110 | (More) / (Exit) — pedia pager |
| 61–64 | Ship / Cargo / Location / Destination (F7 headers) | 129 | Artillery Vs. Raid |
| 65 | Veteran | 132/133 | Tory Unrest / Rebel Unrest |
| 75 | COMBAT ANALYSIS | 161–176 | setup labels ("Click Here When Finished", Choose/Difficulty Level/Level, Easiest..Toughest, Select/European Power/Power, Immigration/Cooperation/Conquest/Trade) |
| 76–84 | Fatigue, Attack Bonus, Ambush, Terrain, Colony, Fortified, Spain Bonus, …, Artillery In Open | 179–188 | pedia stat labels: Combat, Attack, Cargo Holds, Moves, Plow, River, Coast, Move Cost, Defense or Ambush Bonus, Prerequisite |
| 90 | Drake | 200/201 | Prime / Damaged |
| 95–100 | F8 strength rows: Colonies, Population, Average Colony, Military Power, Naval Power, Merchant Marine | 203/204 | Bid Price / Ask Price |
| 104 | Bombard | 210 | Exit |
| — | — | 211–220 | placeholder numerals "211".."220" |

`@ROUTE` (9 lines, the trade-route editor): EDIT TRADE ROUTE · Route Name: · Route Type: · Sea · Land · Destination · Unload Cargo · Load Cargo · (Delete Destination).

### 22.4 NAMES.TXT — sections and column legends

31 sections; row order is the runtime id everywhere (e.g. `@UNIT` row = unit type byte, `@COUNTRY`/`@TRIBES` order = power index 0..3 / 4..11). Column legends, verbatim from the file's own comment headers:

| Section | Lines | Columns (legend) |
|---------|------:|------------------|
| `@SEASONS` | 2 | Spring / Autumn |
| `@UNFORESTED` / `@FORESTED` | 8+8 | name; Movement, Defensive, Improvement, Value; Yield (Farmer, Planter(s), Planter(t), Planter(c), Trapper, Lumberjack, Ore Miner, Silver Miner, Fisherman) |
| `@OTHER` | 5 | same columns — Arctic, Ocean, Sea Lane, Mountains, Hills (ids 24..28) |
| `@OTHER_NAMES` | 5 | Forest, River, Major River, Minor River, Unexplored |
| `@RESOURCE` | 14 | "Special resource squares & values" — name, value |
| `@COUNTRY` | 4 | "Country names (color => must be 9-15)" — name, colour |
| `@NATIONALITY` / `@NATIONABBREV` / `@HOMEPORT` / `@COLONYNAME` / `@INDEPENDENT` / `@MISSION` | 4 each | positional per-power strings |
| `@LEADERNAME` | 4 | "Leaders: a) aggressive/friendly b) expansionist/perfectionist c) civilize/militaristic" — name + AI-bias triplet (loaded at 0x547A1 into the per-power table at DGROUP 0x9566) |
| `@DIFFICULTY` | 5 | Discoverer..Viceroy |
| `@CLASS` | 8 | "European classes: Name, transportation costs" |
| `@BUILDING` | 42 | "name, cost, tools(*10), size, min_colony, upkeep" |
| `@SCENARIO` | 2 | "map file (do not change), start, end, x0, y0, x1, y1, x2, y2, x3, y3" |
| `@JOB` | 28 | "name, student level (4 = unlearnable), cost in europe" (+ expert name) |
| `@CARGO` | 20 | "start1, 2, low, high, burden, rise, fall, attrition, volatility" — the market model; stats loaded only for rows 0–15, rows 16–19 name-only |
| `@UNIT` | 23 | "icon, movement, attack, combat, cargo, size, cost, tools, guns, hull, role; AI Role(binary) => Invade Settle Explore Attack Defend Escort Transp Naval" |
| `@ORDERS` | 13 | order name + status letter |
| `@ACTIONS` | 10 | village-visit action labels (incl. "Denounce Heresy of %Fs Mission") |
| `@VALUES` | 4 | quality grades low quality/good/fine/excellent |
| `@ATTITUDE` / `@ATTITUDINAL` | 5+5 | Content..War; Extremely..Slightly |
| `@LEVELS` | 5 | tribe tech levels: Semi-Nomadic/Camp, Agrarian/Village, Advanced/City, … |
| `@TRIBES` | 26 | "Indian tribe info: tech-level, color" — first 8 rows full 5-column tribes (name, adjective, treasure good, level, sprite), rows 9+ name-only reserve pool |
| `@FOUNDING` | 6 | father categories (Trade/Exploration/Military/Political/Religious/Independence) |
| `@FATHERS` | 25 | "type, weight 1500-1600, weight 1600-1700, weight 1700+" |
| `@COLORS` | 1 | "Text Colors: basic, hilite, grey, enhance, shadow, select, border 0, 1, 2" = 68, 149, 8, 128, 47, 138, 134, 128, 138 |

### 22.5 PEDIA.TXT — 166 surfaces

The Colonizopedia's article bank: seven category renderers, each keyed `<KEY><idx>`:

| Category (`@PEDIA` line) | Key | Entries |
|--------------------------|-----|---------|
| Cargo Type | `@CARGO0..15` | 16 |
| Unit Type | `@UNIT0..23` | 24 |
| Terrain Type | `@TERRAIN0..28` | 29 (spans the unforested+forested+other id space) |
| Colonist Skill | `@JOB0..27` | 28 |
| Colony Building | `@BUILDING0..41` | 42 |
| Founding Father | `@FATHER0..24` | 25 |
| Game Concept | *(see quirk)* | 12 titles |
| index sections | `@PEDIA` (7 category labels) + `@MISCELLANEOUS` | 2 |

Total = 166 top-level sections. **The `@MISC0..11` quirk:** the Game Concept category loads its 12-entry index from `@MISCELLANEOUS` (line 0 = count "12", then Disband, Fortify, Plowing, Roads, Sentry, Trade Route, Veteran Units, Prices, Taxes, Liberty Bells, Crosses, Hammers — loader at 0x07530B–0x07534B, count to `[0x846]`, line pointers to `[0x935C+2i]`), and the article renderer then builds the key `"MISC"+n` — but **no `@MISC0..11` sections exist in PEDIA.TXT**. What the engine renders when `menu_lookup_run` misses the section is unresolved (likely a header-only page); unmapped.

### 22.6 MENU.TXT, DEBUG.TXT, WOODCUT.TXT, editor files

**MENU.TXT** is flat: 8 sections, each one dropdown (line 0 = the bar title). Grammar: `~` precedes a hotkey/underline letter (`~GAME`, `~F~1`, `~F~0~1`, `~s~p~a~c~e~ bar`), `#` marks a separator/value-fill cell (e.g. "Zoom In#   ~Z"). `@CUP`'s title line is `~CHEAT` (the cheat menu, hidden until the Alt-W/I/N combo); `@PEDIA`'s is `~COLONIZOPEDIA`; `@END` is the empty terminator. Row texts are given verbatim in Part V §menus.

**DEBUG.TXT**: 20 sections. Sixteen are live cheat/debug dialogs (`@MEMORY @CREATE @CREATE2 @CSHIP @FOREIGN @FOREIGN2 @SETVIEW @SETHUMAN @SETAUTO @SETREPORT @SETEUROPE @DANGER @SOUND @OPTIONS @FORCED @TEST`); **four are dead** — `@MOTD`, `@MOTD2`, `@BADGUYS`, `@END` have no referencing string in any shipped EXE (`@END` is empty anyway). `@DANGER` ("DANGER, WILL ROBINSON!") is the AI assertion box, reachable in the shipping binary from 37 call sites.

**WOODCUT.TXT**: one section `@WOODCUT`, 17 caption lines 0–16 ("A NEW WORLD" … "INDIAN RAID"); lines 14–16 are placeholders with no art (see §23.1).

**MAPEDIT.TXT** (19 sections: `@MAPTOLOAD @MAPTOEDIT @SAVE @LOAD @ERROR @EXIT @SAVEAS @CREATENOW @NEWNAME @XS @YS @CONTINENTS1 @CONTINENTS2 @HELP1..5 @ABOUT`) and **MAPMENU.TXT** (5: `@GAME @VIEW @CUP @HELP @END`) serve MAPEDIT.EXE only; none of the 19 sections uses any `@`-directive.

### 22.7 The substitution grammar

Token inventory across GAME.TXT (502 scanned sections): `%STRING0` ×360, `%STRING1` ×211, `%STRING2` ×87, `%STRING3` ×49, `%STRING4` ×6; `%NUMBER0` ×124, `%NUMBER1` ×35, `%NUMBER2` ×11, `%NUMBER3` ×2; `%COUNTRY` ×7; `%YEAR` ×1. DEBUG.TXT adds `%HEXn` (`@MEMORY`'s "PSP at = %HEX4"). `%%` is a literal percent; `$` after a number renders as currency. The substituter uses longest-digit-run matching with trailing alpha kept literal (`%STRING0catraz` → "Alcatraz").

Slot storage:

- **VICEROY.EXE**: `%NUMBERn` values live in the slot array at DS:0x9CB0. `%STRINGn` slots are registered immediately before each emit via the two resident setters `func_06C220` (thunk 0x181F:0x416) and `func_06C23C` (thunk 0x181F:0x438, slot 0) — e.g. TUTORIAL12 registers the colony name at 0x2C7A7 just before its emit at 0x2C7B1.
- **MAPEDIT.EXE** (a compiled twin of the same engine): `%STRINGn` slots at **DS:0x634E + 64·n**, set by `_popup_say_string`; `%NUMBERn`, `%HEXn`, `%%` likewise.

Line and span directives (parser state machine, byte-cited in the MAPEDIT twin at 0x7C82 and in VICEROY's dialog engine):

| Syntax | Effect |
|--------|--------|
| *(blank line)* | separates the text block from the option block; option lines get ids 1..n in read order |
| `^` | raw (non-wrapped) line |
| `^^` | centred line |
| *(plain)* | word-wrapped paragraph text |
| `{…}` | highlight span — `{`/`}` toggle the hilite latch `[0x1F62]` (glyph loop `func_06C388` @0x06C3C4/@0x06C478); ink = the hilite entry of the dialog ink record |
| `\|` | truncates — ends the visible span of the line |
| `~x` | accelerator: underlines/hot-keys the following character (menus, checkbox rows); `~F~1`-style sequences bind F-keys |
| `#` | separator / value-fill placeholder in menu rows |

`@`-directives inside a section body — the parser `func_06F0F4` @0x06F0F4 (keyword table at file 0x1F967) recognises exactly **10 live directives**:

| Directive | Handler | Effect |
|-----------|---------|--------|
| `@OPTIONS` | mode switch | following lines are option rows |
| `@PROMPT` | mode switch | text-entry mode |
| `@TEXT` | @0x6F1D8 | back to body-text mode |
| `@SMALLFONT` | @0x6F207 | copies the current font latch `[0x89E]/[0x8A0]` into the dialog — it does **not** load FONTSMAL.FF (never loaded by the engine) |
| `@X=` / `@Y=` | @0x6F266 / @0x6F21E | literal popup origin (−1 = centre sentinel) |
| `@WIDTH=` | @0x6F2B0 | pixel content-width **floor** (never a clamp; keyword "WIDTH\0" at file 0x1F989) |
| `@LENGTH=` | @0x6F302 | text-entry max length → `[0xA5B6]` |
| `@CHECKBOX` | @0x6F350 | checkbox dialog (`FLAGS \|= 5`) |
| `@DEFAULT=` | @0x6F374 | pre-highlighted row index (an index, not a colour) |

An 11th keyword string, `TEXTCOLR` (file 0x1F9AA), is **vestigial as a directive** — the parser never compares it. The string is instead the sheet name for the TEXTCOLR.SS colour-table load (`func_06F6DA` @0x06F6F0), whose sprite pixels seed the dialog ink globals `[0x1F3C..0x1F4E]`. There is no per-popup text-colour override.

### 22.8 Template-engine key facts

- **`menu_lookup_run` = 0x181F:0x998 = `func_06F51A`.** Calling convention: **AX = section-name pointer, BX = file-name pointer, DX = preselect row; returns the 1-based selected row**. The GAME-file wrapper 0x181F:0x3FE (@0x06F594) hardwires file "GAME" (DS:0x87C) and takes the section in BX.
- Build chain: section reader 0x191F:0x928 (`func_06F8FA`) → template parser 0x191F:0x182 (`func_06F0F4`) → geometry finalize `func_06D316` (centred on (160,100) unless `@x/@y`) → modal pump 0x191F:0x16A (`func_06E3D0`), which returns the row.
- Checkbox channel: bitmask word `[0x1F54]` — reset 0x191F:0x26E, pre-seed 0x262, read-back 0x306.
- **ESC returns 0xFFFF** (byte-cited in the editor twin's event loop `@popup_exec` @0x6F5E: Up/Down move skipping greyed rows with wrap, Enter/Space select, hotkey match, mouse row select; entry mode appends printables to maxlen with backspace).
- Text entry lands in the popup text buffer (editor twin: DS:0x4B64); dead wrapper `@popup_ask_number` has zero callers in MAPEDIT.EXE.

## 23. The event catalogue

This chapter is the game's event book: every interrupting event, one row per event, in the schema *event_id / string_key / trigger / condition / options / outcomes (state writes) / arms (downstream)*. All string keys are GAME.TXT sections (verbatim bodies quoted where load-bearing); all popups render through the shared centred-dialog engine of Part V with a speaker channel (`[0x1F5C]` king/tribe, `[0x1F5E]` advisor, `[0x1F60]` missionary), all three reset to 0xFFFF after close at 0x06EE6B. Where a probability or write was not byte-decoded it is marked unmapped rather than estimated.

### 23.1 Woodcut event screens (17)

One renderer, `func_06B722` @0x06B722 (`show_woodcut(n)`): black clear, WOODFRAM frame 1 centred, title `"<year>: <CAPTION>"` from `@WOODCUT` line n, NAMEPLAT strip at y=162, caption at y=165 in FONT-NP (ink LUT palette indices 0x5C/0x5D/0x5E), WDCUT art blit, staged fade, modal wait. The wrapper `func_00543C` (0x181F:0x524) enforces **once-only** per game via the shown-bitmask at `[0x540A]` and fires the sound cues. Art = WDCUT01..WDCUT13.SS (no 00/14/15/16); a missing-file check @0x06B79F makes the art-less numbers unshowable. The caller scan is exhaustive: exactly 10 call sites.

| n | Caption (string = `@WOODCUT` line n) | Trigger | Sound cue | Arms |
|---|--------------------------------------|---------|-----------|------|
| 0 | A NEW WORLD | **no caller** (latent save-under popup mode) | music class 2 wired | — |
| 1 | DISCOVERY OF THE NEW WORLD | first landfall — `func_020EFE` @0x020F00 (sole caller `func_03FDDE`, after `[0x543E]\|=0x80`) | music class 2 | tutorial T2 tail |
| 2 | BUILDING A COLONY | first colony — build executor `func_040C1E` @0x040E00, human only | sfx 0x54 | — |
| 3 | MEETING THE NATIVES | first tribe contact, tribe ≥ 2 — `func_056C3E` @0x056DA6 | tune 0x33 | then `@INDIANWELCOME` |
| 4 | THE AZTEC EMPIRE | same site, tribe 1 (Aztec) | tune 0x35 | then `@INDIANWELCOME` |
| 5 | THE INCA NATION | same site, tribe 0 (Inca) | tune 0x36 | then `@INDIANWELCOME` |
| 6 | DISCOVERY OF THE PACIFIC OCEAN | **no caller** — sound cue wired @0x0054A2 but never hooked | tune 0x39 (dead) | — |
| 7 | ENTERING INDIAN VILLAGE | first village entry — `func_04B308` @0x04B56C (human) | — | village-visit dialog |
| 8 | THE FOUNTAIN OF YOUTH | Lost City outcome 1 — `func_061454` @0x0618F9 | after tune 0x37 | recruit prompt `@LOSTCITY0` |
| 9 | CARGO FROM THE NEW WORLD | first cargo arrival in Europe — `func_041EEA` @0x0420EF | music class 2 | — |
| 10 | MEETING FELLOW EUROPEANS | first power-to-power contact — `func_057F4E` @0x057FDF | contact fanfare 0x8020+p (§24.4) | `@HELLO*` greeting |
| 11 | COLONY BURNING | colony burned — `func_05CA7E` @0x05DADC (with `@BURNED`) and @0x05DFCB | sfx 0x53 + tune 0x32 | — |
| 12 | COLONY DESTROYED | **no caller** | — | — |
| 13 | INDIAN RAID | natives attack a human colony — `func_05CA7E` @0x05D219 | — | raid outcome popup (§23.6) |
| 14–16 | placeholders | unreachable — no caller *and* no .SS art | — | — |

### 23.2 Tutorial overlays (`@TUTORIAL1..19`)

All 19 are ordinary GAME.TXT popups emitted through 0x181F:0x652 = `func_06F5F2(name, advisor)` (sets the advisor portrait channel `[0x1F5E]` → MSS<n>.SS) or the 0x3FE wrapper. Gate: Game-Options bit 0x80 "Tutorial Hints" (T18 is ungated). Each step is **event-driven and idempotent**: its site does `test [0x5386/7],bit; jne skip → emit → or [0x5386/7],bit`; new-game init pre-marks `[0x5386]=0x0E`. Sections with literal placement: T1 (10,40), T4 (x=10), T12 (y=5), T16 (5,10 smallfont), T17/T18 (y=10 w=300 smallfont); the rest centre.

The unit-focus dispatcher `func_020F50` @0x020F50 (called from the end-of-move handler @0x021E63 and the map idle loop @0x024AC6 after a ~30-tick wait) serves T1, T3, T8–T11, T13–T15, T19 from an if/else chain over the selected unit:

| # | Trigger site | Condition | Advisor |
|---|--------------|-----------|---------|
| T1 | dispatcher | first turn (%STRING0 = unit-type name) | 0 |
| T2 | @0x020F43 | land discovered (tail of `func_020EFE`; no once-flag) | 0 |
| T3 | dispatcher | pioneer on a ≥5-resource site (%STRING0 = signature good) | 3 |
| T4 | @0x02C73F | colony open: better job available from the terrain ring (%STRING0/1 = current/alternative goods) | 5 |
| T5 | @0x036514 | religious-unrest immigration — chained after `@UNREST` | 4 |
| T6 | @0x02EA41 | goods ready for export at end of turn (%NUMBER0 qty, %STRING0..2 goods/colony/port) | 0 |
| T7 | @0x028D36 | colony pop ≥ 3 and no stockade | 1 |
| T8 | dispatcher | petty-criminal/servant near a training village | 5 |
| T9 | dispatcher | pioneer on unroaded forest/hills near a colony | 3 |
| T10 | dispatcher | pioneer on a plowable/clearable colony ring tile | 3 |
| T11 | dispatcher | idle ship, turn < 20 | — |
| T12 | @0x02C7B1 | colony open with a ship at the tile (%STRING0 = colony name) | 5 |
| T13 | dispatcher | pioneer before the first colony | 3 |
| T14 | dispatcher | soldier selected | 1 |
| T15 | dispatcher | colonist on a colony tile (%STRING0 = colony name) | 5 |
| T16 | @0x0286F6 | colony food deficit (red-X corn counters) | — |
| T17 | @0x035C22 | Europe screen first open | — |
| T18 | @0x032760 | Europe buy: cannot afford 100 units — **ungated** (no hints bit, no once-flag) | — |
| T19 | dispatcher | Indian convert selected | 4 |

Related conditional warnings from the found-colony validator `func_022542` (fire only at difficulty < 2, i.e. `[0x53A6] < 2` @0x22763): `@TUTNOSPACES` when adjacent productive squares < 4 (@0x22772), `@TUTNOLUMBER` when forested squares = 0 (@0x2278A); both are two-option confirms and the build proceeds only on row 2.

### 23.3 European diplomacy (the 48-section family)

One dispatcher owns the family: **`func_057F4E`** (page 0x0F, 7,151 bytes), entered from the contact evaluator `func_059B90` when a unit meets a foreign power (unit-vs-tile resolver @0x03F82B; movement processor @0x0481CB). AI-to-AI meetings delegate silently to the ticker `func_057DC0` @0x057FA4 — popups run only for the human. Conversations emit via 0x1A1F:0x688 = `func_06F61C` (speaker channel `[0x1F60]` = power B → MYR0..MYR3.SS portrait; returns the 1-based row); announcements via 0x181F:0x652 (advisor portraits MSS1/MSS2). Relation state = the 4×4 matrix at PowerRecord+0x34 (DGROUP 0x883C, row stride 0x13C): bits 0x02 war · **0x08 pending grievance** · 0x10 parley cooldown (16 turns) · 0x20 met · 0x40 peace treaty · **0x80 privateer hidden attribution**. PowerRecord+0x40 is the **treaty-respect counter** (plain byte, seeded `2·(6−difficulty)`, halved with Franklin; a nonzero value makes an AI abort attacks on its treaty partner @0x03F163; the decrement site is unmapped). `%STRING` slots are filled from `@GREATKINGS/@GREATDEEDS/@GREATLEADER*[power]` by `func_057A3A`; `@MEEKNESS` supplies "request"/"demand". Franklin (FF #19) halves demands/prices and cancels AI hostility at 6 cited sites; a war fanfare (`func_005108(4)`) precedes every WAR*/MERCENARY emit.

| Event / key(s) | Trigger (key-push → emit) | Options & outcomes (state writes) | Armed by / arms |
|----------------|---------------------------|-----------------------------------|-----------------|
| Greeting `@HELLOFIRST/@HELLOAHOY/@HELLOMEEK/@HELLOMANLY/@HELLOUSA` | key = "HELLO" + (not-met ? ship ? "AHOY" : "FIRST" : tone "MEEK"/"MANLY"); USA for an independent power; @0x0588CD–0x058923 → @0x058939 | greeting only; leads into the parley menu | first contact also fires woodcut 10 @0x057FDF + fanfare 0x8020+p |
| Third-party demand `@APOSTATES` (+USA) | AI asks the player to attack its treaty partner; @0x058989 → @0x058A30 | row 2 accepts → player's treaty with the target cleared + war bit 0x02 set @0x058A6A/@0x058A7B | — |
| Third-party demand `@HEATHEN` (+USA) | AI asks the player to attack a tribe; @0x0589C0 → @0x058A30 | row 2 accepts → tribe tension +100 vs the target tribe (`func_045DF2(t,A,100,0)` @0x058A91) | — |
| Protest `@PIRACY/@PIRACYUSA` — *"%STRING0 is most displeased with the {%STRING1 pirates} lying in wait off the coast of %STRING2…"* | fires when the war-matrix **privateer bit 0x80** is set for the pair; @0x058B0D → @0x058B45 | row 1 "What pirates? We have NEVER condoned piracy!" — denial; row 2 recalls **all** privateers to Europe and clears bit 0x80 @0x058B7D–0x058BE1 (Europe is the engine's destination sentinel **999/0x3E7**, the same value used by trade-route stops; a ship-type-guarded scan against it sits @0x6013C–0x60146) | armed by `func_03ECF0` @0x03F0A1: a Privateer attack (unit type 0x10 guard @0x03F092) sets 0x80 *instead of* the war bit |
| Protest `@SIEGES/@SIEGESUSA` | player units besieging B's colonies; @0x058C99 → @0x058CD8 | row 2 withdraws the besieging units. **Latent bug:** `@SIEGESUSA`'s rows are textually swapped but the handler acts on row 2 for both — answering "our forces shall stay" to an independent power executes the withdrawal | — |
| Extortion `@TRIBUTE/@TRIBUTEUSA` | demand accumulated from forces-near-colonies, difficulty-scaled (`value·10·(diff+8)/100`, surcharge `+500·(diff+1)`); @0x058E7D → @0x058EB8 | pay → gold transfer @0x058ED0; refuse → escalation into the WAR keys below | grievance: bit 0x08 set when the grievance score crosses its threshold @0x3F0D7/@0x59AE9 |
| Extortion `@WANTSTUFFUSA` — goods demand | @0x058F56 → @0x058F95 | accept → colony stock rows moved to B @0x058FB4. **Latent bug:** the non-USA key "WANTSTUFF" is built @0x058F56 but **has no GAME.TXT section** (only `@WANTSTUFFUSA` exists) | — |
| War declarations `@WARMEEK`/`@WARMANLY` — *"You reject our generous offer? Then in the name of %STRING0 we shall wipe you from the face of the New World. Prepare for WAR!"* | refusal outcomes of the demand tree; @0x059222/@0x059516 → @0x059274/@0x05957E | war bit 0x02 set for the pair | war fanfare class 4 first |
| Ultimatum `@RID/@RIDUSA`, provocation `@PROVOKE` | @0x059077 → @0x0590A3; @0x058FEE/@0x05974C | leave-or-war ultimatum; `@PROVOKE` = *"We can no longer tolerate your foul provocations. Prepare for WAR!"* | — |
| Treaty menu `@WORTHY` → `@PEACEMEEK/@PEACEMANLY/@OLDPEACE*/@PEACEUSA`, `@GIVECASH` | standing-peace proposals; @0x05911D–@0x059395 | treaty set both ways @0x059139 (0x181F:0xA06, bit 0x40) + siege stand-down `func_057CE0`; respect counter set 1 | 16-turn parley cooldown stamp `[0x53C8+p·2]` |
| Withdraw family `@WITHDRAW/@NOTWITHDRAW/@NOTHINGWITHDRAW/@MAYBEWITHDRAW` | @0x0593B7–@0x05949B | withdraw price = `25·(diff+2)·forces` (min 100, ×2 at war, −50/unit, Franklin ÷2) | `@GIFTS` @0x059700 / `@THREATS` @0x059755 side outcomes |
| Alliance `@MILITARY` → `@NOCONTACT/@ALREADYSMITE/@SMITEINDIANS/@SMITEEUROPE/@UNFORTUNATE/@MERCENARY` | dynamic row list (lea 0x19FA @0x05976D, shown via the modal pump @0x059848); smite family @0x05989D–@0x059A0F | purchase → B declares war on target T (bits @0x059A49–0x059A71) + player pays B @0x059AC7; `@MERCENARY` = *"The {%STRING0} declare war on the {%STRING1}."* | war fanfare class 4 |
| AI↔AI ticker `@SIGNTREATY`/`@DECLAREWAR` | `func_057DC0`, every 3rd turn per met pair; @0x057E86 / @0x057F18 | peace → treaty bit 0x40 both ways + respect := 1; war → `@DECLAREWAR`. **Latent bug:** the had-treaty branch pushes key "CANCELTREATY" @0x057F10 which **has no GAME.TXT section** (only `@CANCELPEACE` exists) | — |
| Attacking a treaty partner `@HAVETREATY` → `@CANCELPEACE`; `@SNEAK` | human attacker → `@HAVETREATY` @0x03F130 (row 2 "Break Treaty." continues) → `@CANCELPEACE` @0x03F22F; AI attacker → `@DECLAREWAR` @0x03F262; human victim → `@SNEAK` @0x03F1B4 | war bit set @0x03F298, treaty cleared @0x03F2A5 | second `@HAVETREATY` site @0x0220CE (order-issuing flow; its UI trigger is unmapped) — that path sets the war bit @0x220E6, clears the treaty via 0x181F:0xA10, plays **SFX 0x58** @0x220F9 and issues attack order 5 before the attack-execution call |
| `@SUCCESSION` — *"War of the Spanish Succession ends in Europe! {%STRING0}, ravaged by war, agrees to cede %STRING1 to the {%STRING2}…"* | `func_03C638` @0x03C76A (MSS2 advisor), scheduled while the SoL meter `[0x53D0] < 75` and no power has seceded (`[0x53D2] < 0`) | whole-map owner-bit rewrite @0x03C799–0x03C7D1 — the weakest AI power is absorbed | skipped in hot-seat multiplayer @0x03C63D |
| Movement guards `@NOWARSDURINGREV` / `@TRADEATWAR` / `@TRADEMERCANTILISM` | `@NOWARSDURINGREV` @0x05A916 (also enforcement @0x5A912 in the attack handler, only inside the WoI-declared gate @0x5A8C8: emits and sets the cancel flag, skipping the attack call @0x5A92C); `@TRADEATWAR` @0x05A458 and the **Jan de Witt gate** (FF #4) `@TRADEMERCANTILISM` @0x05A469, both in the foreign-colony trade entry `func_05A40E` | attack/trade cancelled; no state change | — |

### 23.4 King and tax events

The per-turn tax-demand driver is `func_036138`. Cadence: nothing before turn 30; then a demand fires when `turn % interval == 0`, interval 18 shrinking to 15/12/9 as the year crosses 1600/1700/1750, further reduced by `(diff−2)` for the human; skipped once tax > 85. Speaker channel `[0x1F5C]=8` → KING1.SS.

The **pretext** is chosen by a composite severity score
```text
sev = random_int(1,1000) + (2·SoL[0x53D0] − tax)·5 + gold_term(+0x2A,100)
    + per_player_const[0x9410+p] + turn/30            ; @0x361CC..0x36221
```

| event_id | string_key | Condition (sev) | Message opening |
|----------|-----------|------------------|-----------------|
| KING-WIFE | `@KINGWIFE` | `< 0x28A` (and `[0x53A7] < 0x1E`) @0x362C7 | "In honor of our recent wedding to our %STRING2 wife…" |
| KING-WAR | `@KINGWAR` | `< 0x3B6` @0x362FA (+`random_int(1,8)` war number) | "Because of recent developments in our ongoing war with %STRING2…" |
| KING-NAVACT | `@KINGNAVACT` | `< 0x44C` @0x36348 (+`random_int(3,4)`) | "…impose a new {Navigation Act}…" |
| KING-STAMPACT | `@KINGSTAMPACT` | else @0x36371 (+`random_int(5,8)`) | "…teach them proper respect… by imposing a new {Stamp Act}…" |

The core demand `@KINGTAX` (width 190): *"It is essential that the Crown receive proper recompense for its efforts on your behalf. Therefore we have graciously decided to raise your tax rate by {%NUMBER0%%}. The tax rate is now {%NUMBER1%%}. If you wish, you may kiss our royal pinky ring."* Options `@TAXOPTIONS`: **"Kiss pinky ring."** (accept — tax applied, hard-clamped to 75 at 0x03434F) / **"Hold '{%STRING3 Party}.'"** (refuse). Refusal fires `@TEAPARTY` — *"{%STRING3 Party}! Sons of Liberty throw {%NUMBER0} tons of %STRING0 into the sea at %STRING1! … %STRING0 cannot be traded in %STRING2 until boycott is lifted."* — and sets the per-good boycott bit `PowerRecord+0x20 |= (1<<good)` @0x034717. The boycott is lifted per-good by paying back-tax = `count × 500` gold (count = `PowerRecord[+0x4C+good] + base_table[0x9700+good·9]`, clamped ≥0; payment @0x03340D moves the gold into the royal fund and clears the bit @0x033423), or wholesale by acquiring Jakob Fugger (FF id 1: `mov [bx+0x20],0` @0x03BD45).

Related rows:

| event_id | string_key | Trigger / condition | Outcome |
|----------|-----------|---------------------|---------|
| KING-RAISE | `@KINGRAISE` | player *demands lower taxes* and fails | punitive raise ("Your DARE to demand lower taxes!…") |
| KING-LOWER / KING-NOTHING | `@KINGLOWER` / `@KINGNOTHING` | outcome of the lower-taxes petition | tax −%NUMBER0 / unchanged |
| KING-MERCANTILISM | `@MERCANTILISM` | building a profit-taking manufactory | tax raise, same options |
| KING-PURCHASETAX | `@PURCHASETAX` | use of Crown resources (Royal University etc.) | tax raise |
| KING-GALLEON | `@KINGGALLEON2/3`, `@CASHTREASURE`, `@LOOTCASH` | treasure unit with no Galleon; accept → Crown ships it | cut% = tax (with Cortés, FF #10) else `max(5·diff+50, 2·tax)` clamped ≤ 90; player receives gross − cut |
| KING-NEWWAR | `@KINGNEWWAR` | Crown declares war on a rival and orders the player in ("…we shall provide you with {%NUMBER0$}…") | peace arrangement cancelled. Portrait = **KING1.SS** (no "KING2.SS" exists anywhere in the binary — byte-refuted) |
| Tax-level gate | — | `tax ≥ 60` (0x3C, @0x034A1B) branches the king message flow; 75 (0x4B) is the hard cap | — |

### 23.5 Lost City rumors (`func_061454`)

Trigger: a unit enters a rumor tile. Rumor presence is **procedural** — predicate `func_006188` @0x6188 computes it from a coordinate hash against the map seed `[0x190]` (`((x>>2)·0x13 + (y>>2)·0x11 + seed + 8) & 0x1F − (y&3)·4 == (x&3)`), gated on terrain ≠ ocean/sea-lane/arctic and feature nibble = "none". Outcome index `n = max(anti_streak_floor, random_int(1,9))` — the floor rises by 1 per rumor and caps at 3, so the good low outcomes are only reachable on the first rumors; a quality roll `random_int(1,100) + scout·10` against thresholds 10/25 demotes/refines; per-game caps `[0x1DC6]/[0x1DC7]` limit Fountain and Cibola to one each; with debug bit `[0x5382]&1` the outcome is forced to 2. `s` = Seasoned-Scout bonus (unit type 5, class 0x16). The key is built literally as `"LOSTCITY"+n` (itoa append @0x618D1).

| n | string_key | Outcome (state writes) | Reward roll |
|---|-----------|------------------------|-------------|
| 1 | `@LOSTCITY1` — *"You have discovered a {Fountain of Youth}!…"* | **8 free immigrants** queued on the Europe docks; recruit prompt `@LOSTCITY0`; **woodcut 8** @0x0618F9 after **tune 0x37** @0x618ED; promotes to 2 if `[0x5382]&1` | — |
| 2 | `@LOSTCITY2` — Seven Cities of Cibola | Treasure unit created (type 0xA); value stored /100 in its class byte; sound 0x3C | `%NUMBER1 = 100·(10·(s+2) + 1d20)` |
| 3 | `@LOSTCITY3` — ruins of a lost civilization | gold credited to PowerRecord+0x2A @0x61C4C | `10·(3d8)`, scaled `·(s+2)/2` |
| 4 | `@LOSTCITY4` — burial mounds | options: "Let us search for treasure!" / "Stay clear of those!"; search → sub-dispatch `@BURIAL1` (empty) / `@BURIAL2` gold `10·(3d8)` / `@BURIAL3` treasure `200·(1d8+2s+10)`; a **human** desecrating a **hostile** tribe's grounds appends `@SCREWED` (*"…You have trespassed on sacred land. Now you must die!"*) and the unit is lost; desecration raises that tribe's tension **+100** (`func_045DF2` @0x61B84 → war footing); one special path per power (flag bit 0x40 in `[0x543E]` @0x6186B) | — |
| 5 | `@LOSTCITY5` | expedition **vanishes** — triggering unit destroyed (downgrades to 6 when disallowed) | — |
| 6 | `@LOSTCITY6` | nothing but rumors | — |
| 7 | `@LOSTCITY7` — small friendly tribe | chief's gift of gold | `2·(4d10)` |
| 8 | `@LOSTCITY8` | trespass near holy shrines — tribe displeased | — |
| 9 | `@LOSTCITY9` — desperate survivors | colonist(s) spawn and join the nation @0x61809 | — |

### 23.6 Native events

Speaker channel `[0x1F5C]` = tribe index (0=Inca … 7=Tupi) → IND<n>A<pose>.SS portrait, read from the settlement's owner byte.

| event_id | string_key | Trigger / condition | Options | Outcomes / arms |
|----------|-----------|---------------------|---------|-----------------|
| NAT-WELCOME | `@INDIANWELCOME` — *"The {%STRING0} tribe welcomes you. We are a glorious nation of {%NUMBER0 %STRING1}… Will you accept our treaty and live with us in peace as brothers?"* | first contact with a tribe (`func_056C3E`, after woodcut 3/4/5) | Yes / No | No → `@INDIANSHUN` ("…Prepare for WAR!"); related `@INDIANBOW`/`@INDIANTREATY`/`@INDIANPEACE`/`@INDIANCOME` |
| NAT-GIVEFOOD | `@INDIANGIVEFOOD` | supply/demand model in `func_056C3E`: the tribe's per-good **supply array [0x9E78] exceeds demand [0x9E58]** for food @0x05737C, and the player's stores are low — emit @0x0573EB | — | +%NUMBER0 food gifted |
| NAT-BEGFOOD | `@INDIANBEGFOOD` — *"…Will our brothers of {%STRING1} share the bounty of their harvests…"* | food **deficit** `[0x9E58]−[0x9E78]` @0x057098–0x05709F — emit @0x05716F | "I'm sorry, we gave at the office." / "We offer you {%NUMBER0} of our {%NUMBER1 food}…" | refusal/gift affect tension (delta site unmapped) |
| NAT-GIVESTUFF / CONVERT | `@INDIANGIVESTUFF`, `@INDIANSCONVERT` | goodwill gift; mission conversion `func_0572E6` — P(convert) = `(TribeData[+2]+2)/15`, doubled by Jean de Brebeuf (FF 0x16) | — | convert unit created at the colony, class 0x1B |
| NAT-RAID | 6-key block `@RAIDWREAK @RAIDSTORES @RAIDBURN @RAIDSHIP @RAIDGOLD @RAIDNOTHING` (contiguous in the EXE at file 0x1F52A) — e.g. *"Spies report: {%STRING0} raiding party wreaks havoc in the {%STRING3} colony of {%STRING1}."* | raid handler `func_05BE84`: gate roll `random_int(1,12)−1` (+`diff−2` vs a human European) vs threshold `3·K+1`; base outcome `random_int(1,4)` adjusted by turn (`turn < 40·(2−diff)` downgrades) and availability gates; 5-way dispatch @0x5C026 | — | 1→`@RAIDSTORES` (loot cargo, sfx 0x4F), 2→`@RAIDWREAK`, 3→`@RAIDGOLD` (sfx 0x4E), 4→`@RAIDBURN`/`@RAIDSHIP`, 0→`@RAIDNOTHING` (raiders wiped out, sfx 0x5B). `@RAIDSCALP` exists as a section but is **not** in the 6-key block — an orphan, not a 7th outcome. Raid on a human colony also fires **woodcut 13** @0x05D219 |
| NAT-WARPATH | `@INDIANWARPATH @INDIANWARPATH2 @INDIANWARFARE @INDIANWAR @INDIANGRUDGE @INDIANSURPRISE` | warpath handler `func_04B036` (sets `[0x1F5C]` = tribe owner); `@INDIANGRUDGE` = the Tory-side war-council entry during the revolution | — | war footing; alarm ≥ 128 (per-settlement per-power word at +0x0A+2·p) is the raid state; the parallel tension table (0..100) turns hostile at 75, war at 100 |
| NAT-EXTORT | `@EXTORTSTUFF @EXTORTPOOR @EXTORTLAUGH @EXTORTNO` | player Demands Tribute (`func_04AC00`) | — | gold clamped to `[10, min(3·tribe_wealth+10, 100)]`, moved from settlement to player |
| NAT-VILLAGE | `@VILLAGEHAPPY @VILLAGEMEDIUM @VILLAGESAVAGE @VILLAGEBAD @VILLAGEWAR`; `@MADATSHIPS @MADATWAGONS @DONTKNOWSHIPS` | scout enters village (`func_04B308`; attitude words from NAMES `@ATTITUDE`, banded at score cutoffs −5/0/10; War = alarm ≥ 128) | — | display; ship/wagon anger blocks trade |
| NAT-RAZE | `@CHIEFKILL @INDIANGOLD @INDIANBURN` | player attacks a settlement (`func_04A7CA`); `@CHIEFKILL` = taboo execution | — | raze gold = `(Σ3·random(1,10−diff)) · random(1,6) · 4 · (tribe+1)` → +0x2A; no woodcut fires here (the old "WDCUT12" gloss is byte-refuted — WDCUT12 has no caller) |
| NAT-TENSION | *(silent)* | tension applier `func_045DF2` (33 call sites): trespass +1/+2/+3, successful trade −4, mission established −(clamped), burial desecration +100, incite ±100, per-turn drift ±1 | — | deltas halved for France and with Pocahontas (FF 16); clamp [0,100] |

### 23.7 Revolution events

| event_id | string_key | Trigger / condition | Options | Outcomes / arms |
|----------|-----------|---------------------|---------|-----------------|
| REV-DECLARE | `@DECLARE` — *"Shall we declare our independence from {%STRING0}…? This will end our turn and place us at war with our King!"* | GAME menu "DECLARE INDEPENDENCE" → `func_03E984`; refused with `@ALREADYREVOLUTION` if already at war, or `@TOOTORY` (+%NUMBER0 = SoL) while the national SoL meter `[0x53D0] < 50` (@0x3E99E) | "Never! That would be treasonous!…" / "Yes! Give me liberty or give me death!" | yes → `func_03DE46`: `[0x5382]\|=1`, rebel power `[0x5398]:=[0x5394]`, declaration year stored, initial REF dispatch |
| REV-INDEPENDENCE | `@INDEPENDENCE` — *"Continental Congress signs {Declaration of Independence}! … General %STRING0 calls for volunteers for new Continental Army!"* | emitted by `func_03DE46` @0x3E104 | — | war begins; veteran soldiers promote (`@MOBILIZE`) |
| REV-WARN | `@WARN1/2/3` — *"…the King's forces control all but %NUMBER0 of the ports in %STRING0!…"* / *"…all but %NUMBER1 of our colonies!…"* / *"…%NUMBER2%% of the %STRING0 population. If he ever controls 90%%, the Continental Congress will be unable to continue the war…"* | wartime status warnings (ports / colonies / population thresholds); emit sites unmapped | — | surrender conditions foreshadowed |
| REV-CONSIDER | `@CONSIDER` — *"%STRING0 is considering intervention on our behalf… If we can generate %NUMBER0 liberty bells, they will join us."* | pre-intervention notice | — | arms the intervention watch |
| REV-INTERVENTION | `@INTERVENTION` (+ ally names from `@FRIEND`: British General Cornwallis / French General Lafayette / Spanish Generals / Dutch Admiral de Ruyter) | intervention declaration `func_03D948` — picks the strongest eligible foreign ally, sets `[0x5382]\|=2` @0x3DA22; arrival waves `func_03D510` land at a weighted colony pick `random_int(1, Σ weights)` @0x3D57E | — | Intervention Force joins the rebel side |
| REV-TORY | `@TORYUPRISING` | per-turn roll in `func_03CAC6`: `random_int(0, diff+1) ≠ 0` @0x3CADD ⇒ probability `(diff+1)/(diff+2)` | — | Tory uprising spawns loyalist units |
| REV-END | `@KINGVICTORY` / win path | per-turn resolver @0x02F464: rebels **win** when surviving REF combatants fall below the threshold (1, or 8 with `[0x5382]&0x40`) → `[0x5382]\|=8` @0x2F55A | — | score bonus `+2·(1780 − declaration_year)` if declared before 1780 |
| REV-MULTI | `@MULTIREV` — *"The Revolution does not function in multi-player mode…"* | declaring in hot-seat (`[0x5381]&0x80`) @0x03E9C5 | Declare independence / Never Mind | confirm clears the multiplayer flag (`and [0x5381],0x7F` @0x03E9D3) — game continues single-player |
| REV-GUARDS | `@NOWARSDURINGREV @NOCOLONIESEITHER @NOMAYORSDURINGREV @EUROPENOTAVAIL @FOREIGNNOTAVAIL` | action guards while `[0x5382]&1` (see §23.3 last row for the byte-cited `@NOWARSDURINGREV` enforcement) | — | action cancelled |

### 23.8 Europe arrival and immigration chain

| event_id | string_key | Trigger | Outcome / arms |
|----------|-----------|---------|----------------|
| EUR-UNREST | `@UNREST` — *"Religious unrest in %COUNTRY causes increased emigration. Colonists ({%STRING1}) now available in %STRING0."* | crosses-driven immigration event (market/king phase; emit @0x3651F region) | **arms tutorial T5** (chained immediately after, advisor 4, @0x036514); recruit variant `@RECRUITCHOOSE` presents the dock choice |
| EUR-ARRIVE | *(banner, not a popup)* | ship reaches the Europe port: the header banner is composed by `func_030F76` into the top text band (band rect (x=320,y=7,w=0,h=0) set by `set_text_box` @0x035B2D) from the dock-state strings of LABELS `@MISC` lines 5–8 ("Sailing For" / "Inbound From" / "Now Arriving In" / "Docks At") plus port, season/year and tax/gold state | first cargo sold in Europe fires **woodcut 9** @0x0420EF |
| EUR-SAILHOME | `@SAILHOME` — *"We have reached the {high seas}… Shall we sail for Europe?"* (default row 1) | ship enters the sea-lane column | yes → Europe screen on arrival; `@SAILAWAY`/`@SAILPORT` are the return prompts |

## 24. Music and sound

All music and effects are driven through an external, load-time sound driver; VICEROY.EXE itself contains **no `.XMI` filenames and no tune names beyond the picker menus** — a tune id is an opaque byte handed to the driver. Three master switches (Background Music `[0xA2]`, Event Music `[0xA0]`, Sound Effects `[0xA4]`) gate everything, persisted via the save-side mirror `[0x5386]`.

### 24.1 The tune-id table (0x20..0x3E)

Byte-verified row↔id mapping from the Pick-Music jump tables (names verbatim from the `@PICKMUSIC` family):

| id | name | id | name |
|----|------|----|------|
| 0x20 | Bird Song | 0x30 | Morelli's Lesson |
| 0x21 | Smoky Tune | 0x31 | To Arms |
| 0x22 | Cornwall | 0x32 | Indian Victory |
| 0x23 | Shady Grove | 0x33 | Natives |
| 0x24 | Fiddler's Dance | 0x34 | *(event-only; no picker row)* |
| 0x25 | Jine the Cavalry | 0x35 | Tenochtitlan |
| 0x26 | Joe Clark | 0x36 | Pizarro at Cuzco |
| 0x27 | Little Fiddle | 0x37 | *(event-only — Fountain of Youth, requested @0x0618ED)* |
| 0x28 | *(unnamed, independence-class scheduler-only)* | 0x38 | Bonny Morn |
| 0x29 | Love Forever | 0x39 | Hornpipe |
| 0x2A | York Fusiliers | 0x3A | Hole In The Wall |
| 0x2B | Washington Artillery March | 0x3B | Nightingale |
| 0x2C | Road to Boston | 0x3E | *(event-only; requested @0x02F30A/@0x05C93D/@0x07544B)* |
| 0x2D | Independence Way | | |
| 0x2E | The Reveille | | |
| 0x2F | Successful Campaign | | |

The id→XMI resolution happens inside the driver binary (`?SOUND.COL`), so the names of 0x28/0x34/0x37/0x3E are unmapped. One further id outside the table, **0x3F**, is played exactly once — at the intervention-force arrival (`mov ax,0x3F` @0x3D7B1); it has no picker row and its name is likewise unmapped.

### 24.2 The four pickers (`func_023344` @0x023344)

One function drives all four GAME.TXT picker sections (PICKMUSIC / PICKINDEPENDENCE / PICKMILITARY / PICKINDIAN; section-name strings at file 0x1E428–0x1E450). Reached from the GAME menu, command 4 (@0x023617). Behaviour:

- **Preselect**: the current tune `[0x96]` maps to a picker row via a 28-entry jump table at file 0x0233E4 (ids 0x20..0x3B; 0x34/0x37 have no row — event-only).
- **Main menu**: rows 1–12 = the 12 folk tunes; rows 13/14/15 open the Independence/Military/Indian sub-pickers (each run via 0x181F:0x3FE) and offset the returned row: 13 → id = sel+0x28, 14 → sel+0x2D, 15 → sel+0x31 with a skip over 0x34 (@0x02351A).
- **On pick** (selection→id jump table at file 0x02353A): `mov [0x96],ax` then gated play via 0x181F:0x4C0. There is **no persistent lock** — normal rotation resumes when the tune ends.

The Sound Options dialog (`@SOUNDOPTIONS`, `func_0232AE` @0x0232AE) is the standard 3-row checkbox: row 1 → `[0xA2]` Background Music, row 2 → `[0xA0]` Event Music, row 3 → `[0xA4]` Sound Effects; results mirrored into `[0x5386]` @0x023301–0x023322; turning an option off immediately sends **driver command 1 (stop)** @0x023339.

### 24.3 The background scheduler (`func_004EE6` @0x004EE6)

Pumped from the input-idle loops (verb 0x181F:0x470). Per pump:

1. Skip unless background music `[0xA2]` is on or a one-shot `[0x9E]` is pending; poll the driver with **command 8 ("playing?")** and return while a tune is still sounding.
2. **Forced-next** `[0x94]` wins if set. The queue-tune API `func_0050BC` (0x181F:0x48E) sets `[0x94]` and sends a stop so the pump switches immediately.
3. **Class requests** `[0x9A]` (set by events via 0x181F:0x498/0x4A2/0x4AC/0x4B6 = `func_0050F0/0050FC/005108/00513C`, plus the woodcut wrapper `func_00543C`) map through the jump table @0x005008: **1** → folk window A, **2** → folk window B, **3** → independence tunes, **4** → military tunes, **5** → tune 0x33 once, **6** → 0x35, **7** → 0x36.
4. Otherwise the RNG (seeded from `[0x83A8]`) picks a tune-index window:
   - **peace** (`[0x5382]&1` clear): indices 1–12 (folk), with a **1-in-9** crossover into 13–23 (the war/period tunes);
   - **War of Independence**: indices 13–18, with a **1-in-5** crossover back into folk.
5. Index→id via `func_004DF8` (table @0x004EAC); a result equal to the current `[0x96]` is re-rolled; playback through the gate `func_00518E`.

### 24.4 Event cues

| Cue | Where |
|-----|-------|
| Woodcuts 0/1/9 | music **class 2** request (folk window B) in the wrapper `func_00543C` |
| Woodcuts 3/4/5/6 | direct tunes 0x33 / 0x35 / 0x36 / 0x39 (the 0x39 cue @0x0054A2 is wired but its woodcut has no caller) |
| Woodcut 11 (colony burning) | **sfx 0x53 + tune 0x32** ("Indian Victory") @0x05DFCB |
| Build first colony (woodcut 2) | **sfx 0x54** @0x040E00 |
| Fountain of Youth | **tune 0x37** @0x0618ED, then woodcut 8 |
| Cibola treasure | sound 0x3C |
| Native raid outcomes | sfx **0x4F** (stores looted), **0x4E** (gold seized), **0x5B** (raid wiped out) |
| First European contact | **fanfare id 0x8020+power** (high-bit ids address driver fanfare banks; `mov ax,0x8020` @0x58040) |
| Native contact / live-among-natives | fanfare **0x8024** @0x48C41 / @0x48EB7; native raze/massacre **sfx 0x53** @0x48EE6 |
| Treaty-break attack (order flow) | **sfx 0x58** @0x220F9, right after the war-bit write @0x220E6 (§23.3) |
| War declaration / mercenary | war fanfare — class-request 4 via `func_005108(4)` before every WAR*/MERCENARY emit |
| Revolution | independence-class (3) requests: declaration @0x3DE88, intervention @0x3D790/@0x3D9A3, REF phase @0x3E2EF; intervention arrival also plays the unnamed id **0x3F** @0x3D7B1 |
| Lost City sub-events | tune 0x33 queued @0x61910 (native outcome); tune 0x24 queued @0x61ABB (burial treasure); tune 0x32 queued @0x61B42 (desecration → war footing); class requests 1/2 @0x61BCE/@0x61920 |
| First cargo in Europe (woodcut 9) | tune **0x24** queued @0x4208C alongside the class-2 request |
| Colony burn music | class-2 requests @0x5C8AC/@0x5CA2B (with the sfx 0x53 + tune 0x32 pair above) |
| New-game start | plays tune **0x39** @0x756E4 and queues **0x25** @0x759A0 in the page-0x1A init path |
| Turn-loop event tune 0x3E | requested @0x02F30A / @0x05C93D / @0x07544B (name unmapped) |

### 24.5 Driver architecture

- **Load**: at boot `func_07845A` (called @0x0762E6) builds the driver filename from the template **`"#SOUND.COL"`** (file 0x1FD5A) — the `#` replaced by the sound-config byte `[0x2608]` — and loads it via DOS **int 21h AX=4B03** (load-overlay) in `func_01287A`; the driver image is identified by the tag **`"$sound$ "`** (file 0x2004B). Seven config words are fed to it; the writers of `[0x2608]`/`[0x260A..0x2616]` (setup-program output) are unmapped.
- **Vectors**: the driver header exports **5 entry vectors**, installed to DGROUP 0xA654–0xA667 by `func_012928`, reset @0x012976. Vector 1 = play/query command entry; vector 2 = shutdown flush; vectors 3/4 = ISR service entries.
- **Dispatch** (@0x01299A): a lock byte `[0x26C5]` guards re-entry — unlocked commands `ljmp [0xA658]` straight into the driver; locked ones queue (8 deep, ring at `[0x26B4]`, count `[0x26C4]`).
- **Clocking**: the timer ISR @0x00C6D9 calls **vector 4 every tick and vector 3 every 5th tick**. The exit path sends stop (id 1), polls id 8 until silent, then calls vector 2.
- **Command gate** `func_00518E` (AX = id): ids `< 0x10` are driver commands and always pass; **bit 0x20 ids (tunes) are gated on `[0xA0]`** (Event Music); **bit 0x40 ids (SFX 0x40–0x5F) on `[0xA4]`**; the surviving id goes `lcall 0x1059:0xA` into the driver. Command ids seen: **1 = stop**, **8 = query-playing**.
- **Sound Test cheat** (MENU `@CUP` cmd 0x69 → @0x023D86): numeric-entry dialog from DEBUG.TXT `@SOUND` ("Play what sound #?"), result `[0x9CC8]` → gated play — arbitrary id playback against the live driver.

---

## 25. UI engine — draw primitives, dialog framework, popups, menus

Every screen in the 1994 binary is painted through one resident draw-verb library (the far-call
window `0x181F:NNNN`, resolved through the RTLink thunk table at file 0x1A5F0–0x1B5EF; a type-B
thunk resolves as `target_file_offset = 0x2400 + (jmpf_seg<<4) + jmpf_off`). On top of the verbs
sit four engine layers: the `@`-directive dialog framework (every GAME.TXT template dialog,
plaque, and list menu), the gameplay-popup engine (speaker portraits + modal wait), the
pulldown-menu engine of the in-game map bar, and the mouse/keyboard input pipeline. This section
documents each layer to rebuild precision; §26 then applies them screen by screen.

### 25.1 The draw-verb vocabulary (`0x181F:NNNN`)

Text verbs split into two colour families: the **global-colour** family (`func_002Axx`) takes no
colour argument — the pen colour is the screen-level latch byte `[0x830]` (with `[0x831]` as the
hilite slot); the **explicit-colour** family (`func_002Bxx`) takes the colour as a push argument.
Both bottom out in the string rasteriser core `func_00E51C` (`0x181F:0x1FA`), whose 2-bpp ink
levels map through the 4-entry LUT at `[0x269E]:[0x26A0]`.

| Thunk `0x181F:` | Target (file) | Class | Function |
|---|---|---|---|
| `0x1FA` | 0x0E51C | text core | proportional string rasteriser (`ch−1` glyph lookup, 2 bpp → ink LUT); all text bottoms out here |
| `0x204` | 0x0E6A6 | measure | pixel width of a string (Σ glyph widths) — the width source for every centred/right-aligned element |
| `0x22`  | 0x02462 | fetch | **string-fetch-by-id**: walks N NUL-terminated strings in the heap at `[0x2D42:0x2D44]` and returns a far ptr to string #N. Draws nothing (an early "fill_rect" gloss is wrong) |
| `0x100` | 0x02BC8 | text | **centred** text-in-box (args: colour, y, box-w, x) |
| `0x13C` | 0x02B38 | text | draw text at explicit (x,y) — explicit-colour |
| `0x132` | 0x02AFE | text | draw text at (x,y) — global-colour `[0x830]` |
| `0x150` | 0x02B72 | text | **right-aligned** draw (anchor x minus measured width; mechanism at 0x002B9F — the Colonizopedia "(Exit)" uses it) |
| `0x182` | 0x029DE | build | append a **decimal number** to the working string buffer |
| `0x1A0` | 0x02A06 | build | append a zero-padded number |
| `0x16E` | 0x02992 | build | strcat into the working buffer |
| `0x114` | 0x02AC6 | measure | measure/justify helper (right-align maths) |
| `0x11E` / `0x128` | 0x02922 / 0x02932 | build | append literal `(` / `)` (glyph pool at file 0x1D9F0+, DGROUP 0x5E/0x60) |
| `0x1BE` | 0x028F2 | build | append `": "` (DGROUP 0x55) |
| `0x146` / `0x15A` | 0x02962 / — | build | append `+` (DGROUP 0x66) / `−` (DGROUP 0x68) |
| `0x178` | 0x028B0 | build | append `" "` (DGROUP 0x50) |
| `0x196` | — | build | append `" "` × N (repeat-space) |
| `0xE2`  | 0x0DB3A | sprite/present | **clipped sprite/cell blit** from sheet ctx `[0x2DA8]` — used both for element frames and as the "present composed rect" step (`push h; push w; push x`). NOT a line rule |
| `0x254` | 0x0E76A | sprite | **blit ONE sprite**. Convention: `AX` = frame (bit 15 = H-mirror), `DX` = x, stacked args = y + far sheet handle, `BX` = &surface-ctx (`0x2DA8` screen / `0x839E` work surface). Reads frame header `[bx]`=w−1, `[bx+2]`=h−1 |
| `0x24A` / `0x1468` / `0x18F8` | 0x0380C / 0x0D9E0 / 0x0DB80 | sprite | blit variants |
| `0x2BC` | 0x0386A | sprite | **per-unit info panel** composite (unit figure + condition) — map sidebar, Europe ship rows, F6/F7 reports, pedia UNIT page |
| `0x222` / `0x22C` / `0x218` | 0x033F2 / 0x03104 / 0x03193 | sprite row | enqueue icon+count (`0x222`, row counter `[0x2CE0]++`), open row (`0x218`), **flush** the accumulated row left-to-right into a fixed span (`0x22C`, `push 4` columns, span `bx=0x12C`=300) |
| `0x236` | 0x02EE4 | sprite row | **proportional filled/empty icon strip**: `count` filled sprites (AX) tiled across a span, pitch `(span−w)/(count−1)` clamped `[1, w+1]`, remainder = empty sprite 0x38 (hard-coded at 0x002FA5). The game's only "gauge" — there are no fill bars |
| `0x3C0` | 0x04A80 | modal | **wait-for-key/click loop** (~120-tick timeout at 0x4ADD, mouse region `[0x826]`/`[0x7F4]`). Draws NOTHING — the dialog builder paints the box first. Returns the key in DI |
| `0x444` | 0x0DCF6 | fill | rect block-fill / 2-D copy |
| `0x484` | 0x0DCD4 | fill | horizontal solid-colour span fill |
| `0xBA`  | 0x0DDEA | fill | **solid bar fill** (args `ax`=x, `dx`=y, `bx`=w; stack colour, h, sheet) — dialog interiors, highlight bars |
| `0xCE`  | 0x0E0A2 | rect | **1-px HOLLOW rectangle outline** (h/v-span helpers `0xBBC:0xC`/`0xBC3:6`) — selection boxes, dropdown row highlight. Never a filled cell |
| `0xC4`  | 0x0E350 | fill | **tiled fill** from a 4-word tile record (§25.2 fill-record system) |
| `0x510` | 0x0531C | blit | src→dst stretch blit; sole call site 0x0263D6 is the colony-scene ×1.5 upscaler (§26.8) |
| `0x590` / `0xDAE` | 0x0BCEA / 0x0BCAA | fill | span-fill + VRAM variants |
| `0x44E` / `0x438` | (overlay 0x76B9E) | load | **load_PIK by name** (appends ".PIK") / paired asset blit-by-name |
| `0x4C0` | — | sound | **gated sound play** (id gated on the sound-option globals; ids <0x10 = driver commands always pass) |
| `0x998` | 0x6F51A | engine | **menu_lookup_run**: given a section name + file ctx `[0x87C]`, builds the `@`-template via `0x191F:0x182` (parser) and runs it via `0x191F:0x16A` (modal pump), returning the 1-based chosen row in AX |
| `0x3FE` | 0x6F594 | engine | **GAME wrapper**: hardwires file `"GAME"` (`[0x87C]`), section name in BX, then runs the same `0x998` core — the verb behind `@BEGINMENU`, the options dialogs and every plain GAME.TXT popup |
| `0x652` | 0x6F5F2 | engine | **advisor popup**: as `0x3FE` but first sets the advisor portrait channel `[0x1F5E]` → `MSS<n>.SS` (tutorials, announcements); the companion `0x1A1F:0x688` = 0x6F61C sets the third channel `[0x1F60]` → `MYR<n>.SS` for conversations |
| `0x3CA` | 0x04B16 | hit | point-in-rect against mouse `[0x7E8]/[0x7EA]` (args x,y,w,h) |
| `0x35C` | 0x048CC | util | `clamp(v,lo,hi)` — NOT a draw (a mis-cite that propagated; corrected) |

### 25.2 The dialog framework (the `@`-template layout engine)

One engine on overlay page 0x17 lays out and runs every GAME.TXT `@KEY` dialog, popup body, boot
plaque and list menu: construct `func_06C520` (0x06C520) → template parser `func_06F0F4`
(0x06F0F4) → finalize/layout `func_06D316` (0x06D316) → modal pump `func_06E3D0` (0x06E3D0),
with row records appended by `func_044D16` (0x044D16, thunk `0x1A1F:0x33E`).

```c
typedef struct {                    // dialog struct (far ptr; les bx,[bp+4] in func_06D316)
    uint16_t pad0;                  // +0x00
    uint16_t option_count;          // +0x02 option-row count (inc @0x06CA2B via func_06C850)
    uint16_t text_count;            // +0x04 text-line count (inc @0x06CB87 via func_06CA82)
    uint16_t prompt_count;          // +0x08 third item-class count (func_06CB94)
    uint16_t flags;                 // +0x0A 0x10=borderless, 0x40=off-screen, 0x20=sibling, |=5 checkbox
    int16_t  req_x, req_y;          // +0x0C/+0x0E requested X/Y from @x/@y (−1 = centre sentinel)
    int16_t  x, y;                  // +0x10/+0x12 final on-screen X/Y (centre/clamp resolved)
    uint16_t w, h;                  // +0x14/+0x16 box W/H
    uint16_t rect[4];               // +0x18..+0x1E final absolute rect (stores @0x06D5B9)
    uint16_t longest_px;            // +0x20 longest-line pixel width
    uint16_t pad;                   // +0x22 = 4: option-row x-INDENT component (NOT outer width)
    uint16_t content_x0;            // +0x24 = (flags&0x10)?0:3; option row x = +0x24+inset+pad = box_x+9
    uint16_t row_y_seed;            // +0x26 = inset'(3)+border(3) = 6; += border+text_h if text present
    uint16_t width_floor;           // +0x28 content-width floor: init 0x50 (80), overridden by @WIDTH
    uint16_t text_x0, text_y0;      // +0x2A/+0x2C = 3 / 6; text line x = +0x2A+inset = box_x+5
    uint8_t  fill_c1, fill_c2;      // +0x3C/+0x3E fill pair ← [0x1F3C]/[0x1F3E] (TEXTCOLR.SS spr 1/2 pixels)
    uint8_t  sel_c1, sel_c2;        // +0x40/+0x42 selection-band pair ← [0x1F40]/[0x1F42] (boot 0x37)
    uint8_t  ring2_c;               // +0x44 ring-2 frame colour ← [0x1F44]
    uint16_t border;                // +0x46 = (flags&0x10)?0:3
    uint16_t inset;                 // +0x48 = (flags&0x10)?0:2
    uint16_t content_cursor;        // +0x4A content-height cursor (init 0; item y = border+cursor)
    uint16_t hit_row, hit_row2;     // +0x4C/+0x4E cursor: the row under the pointer (pump stores)
    void far *option_head;          // +0x54/+0x56 option-row list head
    void far *text_head;            // +0x58/+0x5A text-line list head
    void far *widget_head;          // +0x5C/+0x5E child/widget list (pump loop B; painter func_06DE6E)
    void far *prompt_head;          // +0x60/+0x62 prompt list head
    void far *submenu_or_sprite;    // +0x68/+0x6A attached submenu; on widget nodes = the ELEMENT
                                    //   SPRITE far-ptr the painter blits (func_06D938 @0x06D952)
    uint16_t ink_record[8];         // +0x74 5 ink words + font ptr, built by func_06C296:
                                    //   +2 normal ←[0x1F4A], +4 disabled ←[0x1F4C], +6 hilite ←[0x1F4E],
                                    //   +8 ←[0x1F50], +0xA ←[0x1F52], +0xC/+0xE font
    uint16_t key_lo, key_hi;        // +0x80/+0x82 identity key / @SMALLFONT font latch copy
    // +0x30..+0x3B, +0x50..+0x53, +0x64..+0x67, +0x6C..+0x73, +0x84.. unmapped
} Dialog;
```

**Template parser** `func_06F0F4` (ENTER 0x168): reads section lines, blank line = paragraph,
`@`-directive test `cmp byte [bx],0x40` at 0x06F193. Exactly ten live directives (keyword pool at
file 0x1F967, DGROUP base delta 0x1D9A0): `OPTIONS` (mode 2 — option rows), `PROMPT`, `TEXT`
(mode 1 — body), `SMALLFONT` (copies the current font latch `[0x89E]/[0x8A0]` into `+0x80` — it
does NOT load FONTSMAL, which is never loaded by the binary), `Y` → `+0x0E`, `X` → `+0x0C`,
`WIDTH` (pixel content-width **floor** → `+0x28`; "WIDTH\0" at file 0x1F989), `LENGTH`
(text-entry max → `[0xA5B6]`), `CHECKBOX` (`flags |= 5`), `DEFAULT` (pre-highlighted row index —
an index, not a colour). The eleventh pool string `TEXTCOLR` (file 0x1F9AA) is never compared by
the parser — it is the sheet name for the **TEXTCOLR.SS colour-table load** in `func_06F6DA`
(0x06F6F0): sprite-pixel reads there seed the ink globals `[0x1F3C..0x1F4E]`.

**Box geometry** `func_06D316` (0x06D316..0x06D889):

```text
content_w = max(@WIDTH[+0x28], longest_line_px[+0x20], [+0x34])         ; clamp @0x06D392
box_w     = content_w + 2*border(3)                                     ; @0x06D4D0/@0x06D4E5 — NO pad term
box_h     = 2*content_cursor[+0x4A] + border[+0x46], item-driven        ; @0x06D35F..0x06D369
X = (req_x == -1) ? 160 - W/2 : req_x                                   ; @0x06D522
Y = (req_y == -1) ? 100 - H/2 : req_y                                   ; @0x06D53B
clamp: right > 0x140 shift left @0x06D563 ; bottom > 0xC8 shift up @0x06D571
negative left/top -> error logger 0x181F:0x772 @0x06D5AD
```

Vertical layout: text block pens from `+0x2C` (box-relative 6) with **text-line pitch =
glyph_h + 1** (0x06D07E); if text is present the option seed bumps `+0x26 += border(3) + text_h`
(0x06D440). Option rows sit at x = box_x+9, text/title lines at box_x+5; option text draws at
row-pen+1 (0x06DB8C). **Row pitch = clamped_glyph_h + border**: the pitch helper `func_06CD66`
(0x06CD66) returns the font cell height **clamped 6→5 on bordered dialogs** (`[0x1F8A]==0`,
latched at pump entry 0x06E3F6), so a bordered FONTTINY dialog has pitch 5+3 = **8 px**
(borderless: 6). Boot-menu check: `@y=91`, 1 title line → title top 91+6 = 97; first option top
91+6+3+6+1 = 107. Return AX=0 laid out, AX=1 empty-item bail.

**Modal pump** `func_06E3D0` (thunk `0x191F:0x16A`): hit-tests the frame bbox `+0x10..+0x16`
against mouse `[0x7E8]/[0x7EA]` with gates `[0x7F6]/[0x7F0]`; loop A walks the option list from
`+0x54` at y-seed `+0x26` with the 8-px pitch above (disabled rows — node flag bit 0 — are
skipped; the hit row lands in `+0x4C/+0x4E`); loop B walks widgets from `+0x5C` (row top =
dialog_y + inset + node[0], height = node[+2], action dispatch `call 0x3D26`). There is **no
universal x/y constant** — both are per-dialog struct state.

**Row records** (`func_044D16`, 0x16-byte nodes): `+0` flags (bit 0 = empty ⇒ skipped), `+2`
string-derived scalar, `+4` command id the row fires, `+6/+8` row text far-ptr, `+0x0E/+0x10`
NEXT, `+0x12/+0x14` PREV. Nodes carry **no screen coordinates** — row (x,y) is computed at
pump/paint time.

**Selection bar** (`func_06D9CC`, hit row == `+0x4C`): filled band at **(box_x+4, option_top−1,
content_w−2, glyph_h+2)** — boot menu: (81, 106, 158, 7) — colour `+0x40` ← `[0x1F40]` (boot
0x37; tiled instead if the byte is 7). Pixel-confirmed: the extra 2 px once measured on the left
was the box's own bevel column sharing palette index 0x37.

**Box paint chain** (driver `func_06E2DE` → box painter `func_06E0C8`, all chrome skipped when
flags&0x10): 1-px **black outline** (colour 0 pushed immediate, `0x181F:0xCE`); ring 2 inset 1
colour `[0x1F44]`; ring-3 **bevel** at inset 2 — light `[0x1F46]` top+right, dark `[0x1F48]`
left+bottom; interior fill (x+3, y+3, w−6, h−6) colour `[0x1F3C]/[0x1F3E]` via `func_06C18C`.

**Fill-record system:** `func_06C18C` (0x06C18C) takes the **tiled** path only when
`[0x1F6C] != 0` AND fill colour 1 == **7** (the wood-tile sentinel) — then `0x181F:0xC4` =
`func_00E350` tiles the 4-word record at near ptr `[0x1F6C]`, phase-anchored at the **box
origin** (`phase = |fill_xy − box_xy| mod (tile_w, tile_h)` at 0x00E371..0x00E3A2); otherwise a
flat `0x181F:0xBA` fill. The boot loader builds three 32×24 tile records: `[0x93F0]` ←
WOODTILE.SS spr 1 (0x07620F), `[0x93F8]` ← PARCH.SS spr 1 (0x07624D), `[0x9400]` ← OPENTILE.SS
spr 1 (0x07627C; literal "opentile" at file 0x1FD51); default `[0x1F6C]=0x93F0`. Two mode
setters: **in-game** at 0x073474 (inks from `[0x830..0x839]`, WOODTILE) and **boot/title** at
0x0734BC (text `[0x1F4A]=0xFE`, gold hilite `[0x1F4E]=0xFC`, disabled `[0x1F4C]=8`, ring
`[0x1F44]=0x2E`, bevel light `[0x1F46]=0xFD` / dark `[0x1F48]=0x37`, selection
`[0x1F40]=[0x1F42]=0x37`, **OPENTILE** `[0x1F6C]=0x9400`), invoked from the title composer at
0x075C52 right before the `@BEGINMENU` run. `[0x1F4E]=0xFC` at the boot menu is additionally
confirmed by a live RAM read (0x95 in-game — state-dependent).

**Ink selection per glyph** (`func_06C346`): disabled → `+0x74+4`; hilite when `[0x1F62]!=0` →
`+0x74+6`; else normal `+0x74+2`. `{` / `}` in any string toggle the hilite latch `[0x1F62]`
1/0 (`func_06C388`); `|` ends the visible span.

**Frame sprite:** the dialog element painter is `func_06D938` — it blits the sprite far-ptr
stored at widget-node `+0x68/+0x6A` via `0x181F:0x254`, taking h/w from the sprite header. The
WOODFRAM/NAMEPLAT chrome sprites are pre-loaded handles bound by the builder; the dialog overlay
pushes no asset-name string itself. **Save-under**: dialogs and menus save the screen under
their rect with mode `ax=0xFFF8` via `0x1A1F:0x364` → `func_078640` and restore via
`0x1A1F:0x38A` → `func_0786FE`.

### 25.3 The popup engine (gameplay event dialogs)

Every gameplay popup (~30 GAME.TXT event templates: king demands, raids, Lost City, combat
outcomes…) is the §25.2 engine plus a **speaker-portrait channel system**. Three DGROUP channel
words select the portrait sheet; `0xFFFF` = no sprite:

| Channel | Global | Builder | Sheet built from the channel value |
|---|---|---|---|
| King / tribe | `[0x1F5C]` | `func_06BE92` (0x06BE92) | 0..7 → `IND<n>A<pose>.SS` (tribe order = NAMES `@TRIBES`: Inca, Aztec, Arawak, Iroquois, Cherokee, Apache, Sioux, Tupi); >7 → `KING<n>.SS` (split `cmp 7/jle` at 0x06BE96; only KING1 exists — KING2 is byte-absent) |
| Advisor | `[0x1F5E]` | `func_06BF12` (0x06BF12) | 0..5 → `MSS0..MSS5.SS` |
| Missionary | `[0x1F60]` | `func_06BF3C` (0x06BF3C) | 0..3 → `MYR0..MYR3.SS` |

Popups reach the engine through per-channel emit wrappers: plain body = the `0x3FE` GAME wrapper;
advisor-voiced = `0x181F:0x652` (`func_06F5F2`, sets `[0x1F5E]` before the run); conversation =
`0x1A1F:0x688` (`func_06F61C`, sets `[0x1F60]` and returns the chosen row); king/tribe events set
`[0x1F5C]` directly (e.g. `mov [0x1F5C],8` for `@KINGTAX`). The blitter `func_06BF66` copies the
loaded sheet handle into a 0x14-byte cel and blits it via
the page-27 graphics overlay (`0x1A1F:0x372`, file 0x76642) to the back-buffer 0xA000:0xFC00,
clipped to the popup rect `[0x839E..0x83A4]`. **There is no coordinate literal** — the landing
pixel is computed inside the blitter from the sheet handle and returned in AX/DX (stored back to
cel `+0xC/+0xE`); the .SS directory carries no per-cel anchor field, so a specific frame's pixel
is runtime state. After a popup closes all three channels reset to `0xFFFF` at file **0x06EE6B**.

Placement: gameplay popups are **centred** (no `@x/@y`); across all of GAME.TXT the `@width`
histogram is {190: 336 sections, 220: 99, 300: 11, 310: 10, 160: 8, …}. Standard event popups
(`@KINGTAX`, `@RAIDWREAK`, `@LOSTCITY0..9`, `@FOODLOW`, `@SHIPCOMBAT`, `@LANDFALL`, `@BURNED`,
`@DECLARE`, `@INVASION` …) are `@width=190`; the wide set (`@TEAPARTY`, `@CASHTREASURE`,
`@INTERVENTION`, `@INDEPENDENCE`, `@SONSUP`, `@SMITEINDIANS`) is `@width=220`. Only 21 sections
carry a literal `@x/@y` (menus, tutorials, `@VICEROY` x=232/y=21, `@KINGLOSE` x=232/y=31,
`@KINGWIN` x=202/y=125). Dismissal = any key/click via the modal wait `0x181F:0x3C0`; there is
**no OK/Cancel button sprite anywhere** — the strings "OK"/"Cancel" do not exist in the binary
as button labels; options are `@OPTIONS` text rows. Body font = FONTTINY (the engine default
latch `[0x89E]`).

### 25.4 The pulldown-menu engine (in-game map menu bar)

The map bar (GAME / VIEW / ORDERS / REPORTS / TRADE / CHEAT / COLONIZOPEDIA) is a separate
module on overlay page 0x0A. The bar object at `[0x896]` is built once by `func_072090`
(0x072090) from the `game menu` data sections (`"game"/"menu"` opened at 0x0720BE via reader
`0x191F:0x928`; 7 add-pulldown calls → `func_044B7A`, 91 add-item calls → `func_044D16`). The
interaction core is **`func_0452D4`** (0x0452D4, 1559 B, page 0x0A) — the modal
open/navigate/select tracker (an earlier attribution of the dropdown to the dialog pump
`func_06E3D0` was overturned; that engine serves the `@`-directive dialogs).

```c
typedef struct {                 // menubar object at [0x896] (created by func_044836)
    uint16_t result_cmd;         // +0x00 selected command id (write @0x045895; 0 = none)
    uint16_t bar_y;              // +0x04 = 1
    uint16_t title_gap;          // +0x06 = 0x0C (12) between titles
    uint16_t item_leading;       // +0x08 = 3
    uint16_t title_xpad;         // +0x0A = 1
    uint16_t bar_c1, bar_c2;     // +0x0E/+0x10 bar colours ← [0x149C]/[0x149E] (runtime-filled,
                                 //   partly from MENUCOLR.SS sprite queries)
    uint16_t hi_c1, hi_c2;       // +0x1A/+0x1C highlight colours ← [0x14A8]/[0x14AA]
    uint16_t title_font[6];      // +0x20 title font descriptor (string at +0x28)
    uint16_t item_font[6];       // +0x2C item font descriptor (string at +0x34)
    void far *first_menu;        // +0x38
} Menubar;

typedef struct {                 // menu node (0x22 bytes, alloc @0x044BD9)
    uint16_t pad0;               // +0x00
    uint16_t x;                  // +0x02 = prev menu x+width + gap; FIRST TITLE x = 0x0C (12)
    uint16_t title_w;            // +0x04
    uint16_t panel_inner_w;      // +0x06 (init 0x0A, grown by add-item)
    uint16_t hotkey;             // +0x08 title accelerator char
    uint16_t flags;              // +0x0C bit0 = disabled
    void far *title;             // +0x0E
    void far *owner;             // +0x12 owner menubar
    void far *next, *prev;       // +0x16/+0x1A
    void far *first_item;        // +0x1E
} Menu;

typedef struct {                 // item node
    uint16_t flags;              // +0x00 bit0 disabled, bit1 hidden
    uint16_t shortcut;           // +0x02 item accelerator key
    uint16_t command_id;         // +0x04 returned on commit
    void far *label;             // +0x06 (empty first byte = separator row)
    void far *next, *prev;       // +0x0E/+0x12
} MenuItem;
```

Layout (`func_044FA4`): panel x = menu.x; panel y = bar_y + title-text-height + 3; width =
`menu.+6` + 2; height = n_visible·(item_font_h + leading) + leading + 2; item x = panel_x + 1;
first item y = panel_y + leading + 1. **Screen clamps**: right edge ≥ 0x13E → shifted so right =
**0x13D** (317); bottom ≥ 0xC6 → shifted so bottom = **0xC7** (199). Bar draw (`func_044E7C`):
full-width fill (0, 0, 320, title_h + bar_y + 1); selected title gets a highlight box in colours
`+0x1A/+0x1C`; title text at menu.x + pad, y = bar_y (=1). Save-under before open
(`0x1A1F:0x364`), restore + blit on close. Interaction: Alt-tap (`[0xB96]`) or a bar click opens;
'8'/0x148 up, '2'/0x150 down (skipping hidden/disabled/separators, wrapping), 0x14B/0x14D
prev/next menu, Enter accepts, Esc cancels, any other key is scanned against item `+0x02`
shortcuts; releasing Alt closes. The result command id is switch-dispatched by the executor
`func_0235D6` (0x0235D6, `switch [bp+6]`). The **CHEAT menu is built always** but hidden unless
the cheat bit is set (`test [0x5383],0x20` at 0x072A8B → menu-record hidden bit; see §27.2 for
the Alt-W-I-N combo).

### 25.5 Mouse / keyboard pipeline (summary; bindings in §27)

**Mouse**: one resident module (file 0xC980+, segment 0xA58) wraps `int 0x33` in exactly 8 call
sites; in mode 13h the driver cursor is suppressed and a **16×16 software cursor** (transparent
colour 0xFF, screen stride 320) is drawn by an installed AX=0x14 event handler (handler at
0xCB87). The poll/edge-detector at 0xD106 publishes: `[0x7E8]/[0x7EA]` cursor x/y, `[0x7E6]` raw
buttons, `[0x7EC]` down-edge, `[0x7F4]` release-edge, `[0x7F6]` any-button-down, and `[0x7E4]` =
`!(buttons & 1)` — **0 = left click, 1 = right click**, written only on a fresh press. There is
no central hit-test table: each screen compares the globals against its own rects via
`0x181F:0x3CA`.

**Keyboard**: 100 % BIOS INT 16h polling — `kbhit` at 0xD272 (AH=1) and `getch` at 0xD286
(AH=0); no INT 09h ISR is ever installed. `getch` normalises: printable key → AH zeroed (clean
ASCII); extended key (AL==0) → scan code kept in AH, so callers distinguish letters from
arrows/F-keys by the high byte. Wait helpers: `wait_for_keypress` (0x4A5C),
`wait_keyOrClick` = `0x181F:0x3C0` (0x4A80), `drain_keyboard_buffer` (0x4AFA), interruptible
`idle_poll` (0x4D1E, abort codes 0x110/0x12D → `[0x828]=1`). Dispatch is table-driven: the key
indexes a normalisation/flag table at DS:0x27ED (bit 1 = case-fold −0x20) and then per-screen
action tables; the executor is `func_0235D6`.

---

## 26. Screens — geometry, fonts, keys, state

Every screen below is native 320×200 (mode 13h). Coordinates are byte-cited EXE immediates
unless marked "(measured; not byte-cited)" — pixel-verified against the running game, 1994
binary under DOSBox. Palette indices refer to the screen's loaded PIK/gameplay palette.

### 26.1 Boot / main menu

The title screen's plaque menu: OPENMENU.PIK backdrop, one wood-framed dialog run from GAME.TXT
`@BEGINMENU` (`@options @width=160 @y=91 @smallfont`), painted by the §25.2 engine under the
boot-mode ink setter (0x0734BC). The three `0x1A1F:0xDF8` calls before the menu are full-screen
**palette-index remaps** (7→6, 8→9, 15→14 — `func_00E146`), a no-op on OPENMENU.PIK; there is no
"OPENBORD sprite" pass.

```python
regions = [
    (0,   0, 320, 200, "OPENMENU.PIK backdrop",      "art",   "load_PIK @0x075AE4; composited over OPENING.PIK"),
    (77, 91, 166,  58, "Menu plaque box",            "panel", "w=160+2*3 byte-derived; x=160-166/2; h item-driven (measured 58)"),
    (82, 97, 156,   6, "Title line",                 "text",  "'{COLONIZATION} Version ...' x=box+5, top=box+6"),
    (86, 107, 148, 40, "Option rows x5",             "hit",   "x=box+9; tops y=107+8k, k=0..4 (pitch 8)"),
    (81, 106, 158,  7, "Selection bar",              "hit",   "(box_x+4, option_top-1, 158, 7) tracks the hit row"),
]  # 320x200 Mode 13h
```

| Region | Bounds | Kind | Content source | State binding |
|---|---|---|---|---|
| Plaque box | (77,91,166,58) | panel | dialog engine; OPENTILE.SS 32×24 tile fill phase-anchored at box origin (`[0x1F6C]=0x9400`, sentinel colour 7) | — |
| Box chrome | outline+2 rings | panel | black outline (idx 0), ring `[0x1F44]`=0x2E, bevel light 0xFD top/right, dark 0x37 left/bottom | boot-mode setter 0x0734BC |
| Title | y=97 | text | `@BEGINMENU` title; `{...}` span in gold | hilite latch `[0x1F62]` |
| Options ×5 | y=107+8k, x=86 | hit | "Start a Game in NEW WORLD / Start a Game in AMERICA / CUSTOMIZE New World / LOAD Game / View Hall of Fame" | `dec ax` ladder at 0x075C6D |
| Selection bar | (81,106,158,7) | hit | flat fill colour `[0x1F40]`=0x37 | hit row `+0x4C` |

Fonts/inks: **FONTTINY** (the `@smallfont` directive copies the FONTTINY latch; pixel-proven —
FONTINTR's 9-px cells cannot fit these spans). Text 0xFE, `{}`-hilite gold **0xFC**
(live-confirmed), disabled 8. Keys: arrows move the bar, ENTER(13) selects, ESC(27) cancels,
SPACE(32), digit + first-letter hotkeys. Dispatch (`dec ax` at 0x075C6D): 1=exit branch,
2=load/AMERICA sub-picker, 3=setup/scenario list, 4=new game → `begin_game` 0x072578. State:
returned 1-based row in AX from `0x181F:0x3FE` run at 0x075C60.

### 26.2 Difficulty select

Full-screen DIFFICUL.PIK (five conquistador figures baked into the art); code adds only the
labels, the finish prompt, and a 1-px hollow selection outline. Painter `func_070494` /
`func_070580`, cell helper `func_0702C0`.

```python
regions = [
    (0,    0, 320, 200, "DIFFICUL.PIK backdrop", "art",  "load_PIK 'DIFFICUL' @0x0705A8; own embedded palette"),
    (128,  7,  68,  90, "Discoverer cell",       "hit",  "grid: x=(idx%3)*105+23, y=(idx//3)*96+7, idx=n+1"),
    (233,  7,  68,  90, "Explorer cell",         "hit",  ""),
    (23, 103,  68,  90, "Conquistador cell",     "hit",  ""),
    (128,103,  68,  90, "Governor cell",         "hit",  ""),
    (233,103,  68,  90, "Viceroy cell",          "hit",  ""),
    (0,   16, 112,  26, "Title 'Choose / Difficulty Level'", "text", "y=16/29, centred over the left column (measured)"),
    (0,   81, 112,   8, "Finish prompt",         "text", "'(Click Here When Finished)' y=81 (measured)"),
]  # 320x200 Mode 13h
```

| Region | Bounds | Kind | Content source | State binding |
|---|---|---|---|---|
| Cell i (0..4) | (col·105+23, grp·96+7, 68, 90) | hit | level name = NAMES `@DIFFICULTY` (Discoverer/Explorer/Conquistador/Governor/Viceroy); sub-label = LABELS `@MISC` 165–169 (Easiest..Toughest) | selected → `[0x53A6]` |
| Selection outline | selected cell | rect | `0x181F:0xCE` 1-px hollow; per-row colour byte {0xA, 9, 0xE, 0xD, 0xC}; captured state shows ink 9 (blue) | `[0x53A6]==row` |
| Titles | y=16/29 | text | `@MISC` 162/163 "Choose"/"Difficulty Level", FONTINTR, black shadow at (1,0),(0,1),(1,1) (measured) | — |
| Finish prompt | y=81 | text/hit | `@MISC` 161 + parens, FONTTINY ink 254; commit zone = click with mouseY<103 & mouseX<128 (0x07073A) | exit |

Fonts/inks: FONTINTR labels, inks level1=254 / level2=253 / level3=0 (measured; not byte-cited).
Keys: up = (level+4)%5, down = (level+1)%5 (0x070692/0x0706C8), ESC exits. Name/description
drawn centred in the cell for the selected row only. PIK-load failure degrades to the
`@DIFFICULTY` text list via `0x181F:0x998`.

### 26.3 Nation select

Full-screen NATIONS.PIK (four flag plaques baked in), 2×2 grid, twin of §26.2. Painter
`func_07092E` / `func_070A1A`, cell helper `func_070782`; menu-mode `[0x1F5C]=4`.

```python
regions = [
    (0,    0, 320, 200, "NATIONS.PIK backdrop", "art", "load_PIK 'NATIONS' @0x070A42"),
    (112, 13,  88,  82, "England cell",         "hit", "grid: x=(i%2)*99+112, y=(i//2)*91+13"),
    (211, 13,  88,  82, "France cell",          "hit", ""),
    (112,104,  88,  82, "Spain cell",           "hit", ""),
    (211,104,  88,  82, "Netherlands cell",     "hit", ""),
    (0,   36, 112,  26, "Title 'Select / European Power'", "text", "y=36/49, left-column-centred (measured)"),
    (0,  182, 112,   8, "Finish prompt",        "text", "y=182 (measured)"),
]  # 320x200 Mode 13h
```

| Region | Bounds | Kind | Content source | State binding |
|---|---|---|---|---|
| Cell i (0..3) | (col·99+112, row·91+13, 88, 82) | hit | NAMES `@COUNTRY` England/France/Spain/Netherlands; leaders `@LEADERNAME`; trait label at cell bottom = `@MISC` 173–176 (Immigration/Cooperation/Conquest/Trade) | selected → `[0x5398]` |
| Selection outline | selected cell | rect | `0x181F:0xCE` 1-px hollow, colour = per-nation flag byte `[bx+0x848]`; captured state ink 12 (red) | `[0x5398]==row` |
| Titles | y=36/49 | text | `@MISC` 170/171 "Select"/"European Power", FONTINTR | — |
| Commit | click & mouseX<112 | hit | left-margin zone (0x070BFC) | exit, returns `[0x5398]` |

Fonts/inks: FONTINTR, same ink triplet as §26.2. Keys: arrows rotate mod 4 (0x070B40), ESC.
Fallback: `@PICKNATION` text list. The per-nation flavour pages `@NATION0A..3B` follow (§26.5).

### 26.4 Leader-name entry

A WOODPANL-backed text-entry dialog (`@LEADERNAME`, `@width=300`, maxlen 23) shown after nation
select; default text = the nation's leader name from the AIPersonality record 0x540E + n·0x34.

```python
regions = [
    (0,   0, 320, 200, "WOODPANL.PIK backdrop", "art",   "wood-panel background"),
    (10, 88, 300,   8, "Prompt line",           "text",  "@LEADERNAME body, centred; y=88 (measured)"),
    (79, 98, 167,  14, "Entry field outline",   "panel", "green 1-px outline (measured; not byte-cited)"),
    (82,101, 161,   9, "Entry text + cursor",   "text",  "default 'Walter Raleigh' + '_' cursor; X=160-W/2 centring"),
]  # 320x200 Mode 13h
```

| Region | Bounds | Kind | Content source | State binding |
|---|---|---|---|---|
| Prompt | y=88 centred | text | GAME `@LEADERNAME` | — |
| Field | (79,98,167,14) | panel | green outline + text-bbox background fill (measured) | — |
| Entry text | (82,101) | text | FONTINTR, proportional glyph advance; `_` cursor | result copied to leader-name field 0x540E+n·0x34; `@LENGTH` max → `[0xA5B6]` |

Font: **FONTINTR** (this dialog carries no `@smallfont`; the FONTTINY rule applies only to
`@smallfont` dialogs). The `@width=300` box draws no visible frame on this screen. Keys:
printable chars append (proportional FONTTINY-style advance per glyph), ENTER accepts, ESC
cancels.

### 26.5 Nation briefings (`@NATION<n>A/B`)

Two full-width text plaques shown once, at game start, immediately after leader-name entry —
history page A then gameplay-bonus page B. Sole invoker: new-game setup `func_07431E`, which
builds `"NATION0A"`, patches digit `buf[6] += [0x5398]` (0x07444F), shows page A, then
`inc buf[7]` ('A'→'B', 0x0744A8) and shows page B. Both sections are `@width=300`, centred, run
by the standard §25.2 engine over the WOODPANL backdrop.

```python
regions = [
    (0,  0, 320, 200, "WOODPANL.PIK backdrop", "art",   ""),
    (7, -1, 306,  -1, "Briefing dialog",       "panel", "@width=300 => box_w=306, x=160-306/2=7; y centred, h item-driven"),
]  # 320x200 Mode 13h
```

Fonts/inks: FONTTINY body per the engine defaults; keys: any key/click dismisses (modal wait
`0x181F:0x3C0`). State: nation index `[0x5398]` selects the section pair.

### 26.6 Intro caption cards (`@BUILD1..10`)

A self-advancing slideshow over world generation: ten full-screen LEVN PIK plates, each with a
GAME.TXT caption block. Renderer `func_004B72` (resident): builds `"LEVN00"+n`, loads via
`0x181F:0x44E` (card 1 blanks the screen and latches the 768-byte palette), then renders section
`"BUILD"+n` with `^^`-centred lines; staged present `func_005160(8)`.

```python
regions = [
    (0,  0, 320, 200, "LEVN000n.PIK plate", "art",  "one per card, full-screen"),
    (14, 54, 292, -1, "Caption text block", "text", "pen (14,54); ^^-centred lines"),
]  # 320x200 Mode 13h
```

| Item | Value | Source |
|---|---|---|
| Text pen | (14, 54) | `func_004B72`; inks `[0x1F4A]=0x0E`, `[0x1F50]=0x36`, restored after |
| Card 2 substitutions | %STRING0 = difficulty rank `[0x8394+2·diff]`, %STRING1 = leader name (0x540E+p·0x34) | byte-cited |
| Card 3 | %STRING0 = home port `[0x838C+2·nation]` | byte-cited |
| Card 4 | %STRING0 = nation name, %STRING1 = `@MYLEADER[nation]` ("King/King/King/Stadtholder") | byte-cited |
| Advance | one card per **0x23A ticks** via counter `[0x8C]` (sequencer `func_004D1E` = `0x181F:0x3AC`, 34 call sites in world-gen) | byte-cited |
| Skip / abort | any key or click (`[0x8A]=1`); Alt-X / Alt-Q exits to DOS (exit code 3) | byte-cited |

### 26.7 Map view (main gameplay screen)

The default in-game screen: tile viewport left, wood sidebar right, pulldown bar on top. Tile
rendering itself (terrain decode, zoom compositor, fog, units) is specified in Part II; this
entry gives the screen geometry and bindings.

```python
regions = [
    (0,    0, 320,   8, "Pulldown menu bar",        "hit",   "bar fill h=title_h+2; titles y=1, first x=12, gap 12"),
    (0,    8, 240, 192, "World viewport",           "art",   "render_frame_setup func_06787C; 15x12 tiles @16px (zoom 0)"),
    (241,  8,  79,  41, "Minimap panel",            "hit",   "func_066CD6, panel box @0x66CF4; 1px/tile 56x39 window"),
    (240, 72,  80,  64, "Sidebar B: season/gold/tax","text", "x-origin [0x8550]=240 (@0x071039)"),
    (240,136,  80,  64, "Sidebar C: unit panel",    "text",  "sprite + @INFO labels; foreign-colony hover variant"),
]  # 320x200 Mode 13h
```

| Region | Bounds | Kind | Content source | State binding |
|---|---|---|---|---|
| Menu bar | (0,0,320,8) | hit | 7 titles from MENU sections `@GAME @VIEW @ORDERS @REPORTS @TRADE @CUP @PEDIA`; per-title x from glyph widths (mechanism byte-cited; exact x's not) | Alt-tap `[0xB96]`; result → `func_0235D6` |
| Viewport | (0,8,240,192) | art | zoom `[0x184]`: spans `0xF<<z` × `0xC<<z`, tile px `0x10>>z` → 15×12@16 / 30×24@8 / 60×48@4 / 120×96@2 | cursor `[0x853E]/[0x8540]` |
| Minimap | (241,8,79,41) | hit | owner-dot colours from `[0x830..0x833]` = NAMES `@COLORS` bytes (68,149,8,128…, palette indices); viewport rect idx 0x0F | click recentres |
| Sidebar B | (240,72,80,64) | text | season NAMES `@SEASONS` + year `[0x538A]`; gold = PowerRecord+0x2A; tax = +0x01; FONTTINY white 0x0F | live |
| Sidebar C | (240,136,80,64) | text | unit sprite (`0x181F:0x2BC` panel), `@INFO` "Moves:/Locat:", type NAMES `@UNIT`, skill `@JOB`, orders, terrain name | selected unit `[0x5392]` |

Sidebar per-line stack (single-frame measurement, approximate): season/year (244,58), Gold
(244,66), Tax (290,66), unit sprite (244,80), Moves (270,82), Locat (270,92), type (244,104),
skill (244,112), orders (244,120), terrain (244,128) — 8-px FONTTINY lines (measured; the
per-line y is emitted through a runtime-installed printer pointer `[0xA644]`). Keys: see §27.1.
Click own colony → colony screen (entry chain via set_active_colony at file 0x82DC).

### 26.8 Colony screen

The colony management screen: composer `func_028592` (0x028592) draws 12 ordered steps —
terrain scene first, then a full-screen WOODTILE region fill composited over it, then title,
panels, buildings. COLONY.PIK is a 320×72 town-scene strip blitted at y=128 (no embedded
palette; renders on the gameplay palette). Entry: screen id 0x2C; active colony ptr `*[0x8542]`
(ColonyRecord base 0x5D46, stride 0xCA; `+0`=cx, `+1`=cy, `+2`=name).

```python
regions = [
    (0,    0, 320,   7, "Title strip",                  "text",  "name+season+year+gold; paint 0x181F:0xB0, origin runtime (text-box globals [0x2CC6..])"),
    (0,    0, 320, 200, "WOODTILE region fill",         "panel", "step 4 func_02633E; composited over the scene, from (0,0)"),
    (0,  128, 320,  72, "COLONY.PIK town strip",        "art",   "320x72 strip at y=128"),
    (200,  8, 120, 120, "5x5 scene (x1.5 upscale)",     "art",   "80x80 render stretch-copied via 0x181F:0x510 + 4x4 dither"),
    (224, 32,  72,  72, "Visible 3x3 scene window",     "art",   "central 3x3 of the 5x5; 24px tiles; outer ring overdrawn"),
    (248, 56,  24,  24, "Colony-centre tile",           "art",   "field-production centre cell"),
    (0,  130, 120,  48, "Left panel: colonist plaza",   "hit",   "region id 0; rows left-aligned at origin+2"),
    (121,130,  84,  48, "Middle panel: cargo dock",     "hit",   "region id 8; 6 crate slots (ICONS disk 122) or centred caption"),
    (207,130,  95,  48, "Right panel: SoL/cargo/msg",   "hit",   "x207..301 on screen (fill push was 211,91); mode [0x337]"),
    (303,132,  17,  45, "Nation flag panel",            "hit",   "region id 3; ICONS 0x44 at +3, frame=[0x337]/[0x339]"),
    (0,  179, 320,  21, "Stockpile bar",                "hit",   "16 cells pitch 19; icons y=181; digits (9+19i,194)"),
    (306,179,  15,  21, "Exit caption/zone",            "hit",   "region id 9; string-id slot [0x2F5E]=210 -> @MISC 'Exit'"),
]  # 320x200 Mode 13h
```

| Region | Bounds | Kind | Content source | State binding |
|---|---|---|---|---|
| Title | (0,0,320,7) | text | colony name (rec+2) + NAMES `@SEASONS[0x538C]` + year `[0x538A]` + gold (PowerRecord+0x2A via money formatter); green FONTTINY | live |
| Buildings ×15 | table DS:0x266 (stride 4: x@+0, y@+2) | art | BUILDING.SS frame = **def_id+1** (EXE-sheet; specials: def 0 + no-stockade → 0x11; def 0xF/0x11 garrison → 0x2F/0x30; blit `0x181F:0x254` at 0x026E4E); empty plot (byte 0x8E82[i]==255) → frame `DS:0x260[category]−1` | def table 0x8E82, categories 0x8D62 = [0,0,0,0,0,0,0,1,1,1,1,2,2,3,4]; plot assignment = per-colony 16-bit-seeded RNG shuffle (`func_025D34`) |
| Plot positions | (56,13)(145,15)(173,18)(8,41)(37,45)(67,54)(96,53)(6,14)(128,53)(10,76)(15,102)(87,11)(66,87)(123,106)(123,55) | art | the DS:0x266 table values as printed (no extra +8) | — |
| Scene | (200,8,120,120) | art | map compositor: 5×5 neighbourhood at 16 px from TERRAIN.SS `[0x16C]` + PHYS0.SS `[0x174]`, colony/unit markers on the 80×80, then ×1.5 stretch (2→3 duplication) with positional 4×4 ramp dither (`func_00531C`/`func_005296`) — deterministic, no dedicated 24-px tileset | colony (cx,cy)−2 origin |
| Scene workers | x=cell·24+252, y=cell·24+60 | art | PHYS0 sprites, drawn after the upscale; cells signed −2..+2 from DS:0xC8/0xDE | colony+0x329 count |
| Plaza row | (0,130,120,48) | hit | colonist sprites, rows left-aligned at panel origin+2; pitch = sprite width + adaptive gap (2→0, fit-to-96px, 0x02715C) | count = colony+0x1F + `[0x8D72]` |
| Middle panel | (121,130,84,48) | hit | 6 cargo-crate slots (ICONS disk frame 122) or centred caption via string-id slot + `0x181F:0x22`/`0x100` | `[0x33C]` |
| Right panel | (207..301,130,48) | hit | `[0x337]` 3-way: 0 = SoL/garrison icon bar (`0x181F:0x222` rows); 1 = cargo + caption `[0x939A]`; 2 = cargo + caption + hammer strip (`0x236` sprite 55) | SoL% = `(colony+0xC2·100)/colony+0xC6` (+20 human latch, clamp 100 — `func_008524`) |
| SoL band text | "100% (1)" at (75,133) white; "No Ships In Port" caption (118,130) | text | digit in parens (not letter I); caption = `@MISC` string id | live |
| Stockpile bar | (0,179,320,21) | hit | 16 cells pitch 19 (0x13); icon = ICONS `good+0x17` (EXE) at y=181; qty digits centred at (9+19i, 194), white 0x0F, red 0x0C over warehouse cap; order Food first | colony+0x9A 16×u16 |
| Carpenter overlay | colonist ICONS 81 at (42,111); green box `#55ff55` x39..50 y112..127; hammers ICONS 54 ×production at (15,104),(22,104),(29,104) | art | production count = live building-production state (strip verb `0x181F:0x236`) | per-turn |
| Exit | (306,179,15,21) | hit | FONTTINY white "Exit" (string-id 210 of the 221-entry `@MISC` id table at 0x2DBA) | region id 9 |

Fonts/inks: FONTTINY throughout; title green (screen latch); digits white 0x0F / red 0x0C.
Click regions (hit-tester at 0x299A0, ids): title 0xA, scene-left 2 (0,8,199,120), scene-right 1
(200,8,120,120), plaza 0, minimap 8, SoL 4, flag 3, stockpile 5 (0,179,305,21), exit 9, default
0x14. Keys (manual-sourced; routed through the multi-function display, no per-letter compare in
the static image): Tab view-to-view, arrows within view, Enter jobs menu, L/=/+ load, U/−/_
unload, M toggle views, 1/2/3 production/units/construction, N numbers, C construction menu, B
buy, F1 info, ESC exit.

### 26.9 Europe screen

The home-port harbour (screen-view id 0x2B, EUROPE.PIK key 0x0FBA; composer `func_031E4C`,
9-step chain). The dock town, market grid and the red "E" are baked PIK art; the engine draws
the title band, market prices, dock contents, captions and the recruit menu.

```python
regions = [
    (0,    0, 320,   8, "Title band",               "text", "text y=1 centred on x=160; band rect (320,7,0,0) via set_text_box @0x035B24"),
    (0,    8, 320, 192, "Play-area fill over PIK",  "art",  "func_030D86 @0x031E4C"),
    (0,  179, 320,  21, "Market bar",               "hit",  "16 cells stride 19; icons x=1+19i y=181; bid/ask pairs y=194"),
    (143,118,  81,  60, "Dock rect",                "hit",  "id 1; 'Loading: <ship>' centres in this rect"),
    (147,165,  72,  12, "Dock ship slots x6",       "art",  "x=147+12k, y=165, 10x12 each; crate frame (disk 0x7A)"),
    (1,  118,  70,  51, "Loading panel",            "hit",  "id 3; caption slot 336 'Docks At'/Loading"),
    (72, 118,  70,  51, "Bound For panel",          "hit",  "id 2; caption slot 337/338"),
    (224,120,  96,  59, "Expected panel",           "hit",  "id 4"),
    (281, 89,  37,  32, "Recruit/Purchase/Train",   "hit",  "id 5; rows (281,89+11r,37,9)"),
    (306,179,  15,  21, "Exit zone",                "hit",  "id 0xB; white 'Exit' + red 'E' at (308,187)"),
]  # 320x200 Mode 13h
```

| Region | Bounds | Kind | Content source | State binding |
|---|---|---|---|---|
| Title band | (0,0,320,8), text y=1 | text | "London, England. Spring, 1500. Tax:0% Gold: 1000$" — banner builder `func_030F76`; centred within box (320,7,0,0); the gold suffix is the FONTTINY '$' glyph; literal "Tax:0%" has no space | ink state-dependent: idle green **68**, arrival-banner gold **149**; good `[0x9E12]`, year `[0x538A]`, tax PowerRecord+0x01 |
| Market icons | x=1+19i, y=181 | art | ICONS `good+0x17` (EXE), 16 goods in NAMES `@CARGO` order | boycott: the good's own icon redrawn as the marker (gate 0x031A73) |
| Market prices | cell-centred, y=194 | text | **bid/ask pairs**, FONTTINY ink 0x2F; bid = nibble of the per-good market record (base 0x3150 stride 0x1C); ask = bid + `@CARGO`.Burden + 1 | live prices; click = buy/sell (sell handler 0x32914) |
| Selected-good outline | around the active cell | rect | 1-px outline, yellow 14 / green 10 (runtime `[0x9E12]`-driven; measured) | `[0x9E12]` |
| Dock slots | (147+12k, 165, 10, 12) | art | crate sprite (`mov ax,0x7B` engine = disk frame 122) | ships in port `[0xFA2]` |
| Ship status rows | y=146 / 137 / 132 | text/art | sail-state 1/2/3 bands (`func_031298` jump-table); bar width `0x64>>state`; type icon `@UNIT[type]` | per-ship sail distance |
| Captions | "Expected Soon" (16,120); "Bound For"/"New England" (87,120/127); "Loading:"/"Caravel" (150/186,120) (measured x/y) | text | fixed per-panel `@MISC` string-id slots: 336 Docks At, 337 Expected Soon, 338 Bound For, 339 No Ships In Port | in-port loop selects only colour (0xA/0xF) |
| Recruit menu | rows (281, 89+11r, 37, 9) | hit | LABELS `@EUROLABEL` "RECRUIT/PURCHASE/TRAIN/x"; rows horizontally centred; bevel colours 57/48 (measured), accelerator first letter yellow; row pitch 11 (measured — the "glyphH+2" formula does not reproduce it) | ink 0x0F / 0x00 by selection |
| Exit | (306,179,15,21) | hit | white "Exit" caption; the red "E" at (308,187) is PIK art | generic screen-view close; keys `x`/ESC/E |

State fields: treasury PowerRecord+0x2A (u32), tax +0x01, boycott bitmask +0x20, price_level
+0x4C[16], vol_accum +0x5C[16]. Keys (manual-sourced except the byte-corroborated `x`): Tab,
arrows, Enter dock/harbor options, L/= buy full, + buy some, U/−/_ sell, R/1 recruit, P/2
purchase, T/3 train, F1 info, ESC/E exit. Water animation is pure palette cycling (indices
54–60), gated by the Water Color Cycling option (§27.4).

### 26.10 Combat Analysis dialog

A modal two-column modifier breakdown shown inside land-combat resolution (`func_05CA7E`),
after the roll is computed and before resolution renders, when Game-Options bit 0x0200 is set
and a human is involved. The dialog is `func_05E9B0` (page 0x11; thunk `0x1A1F:0x704`), called
once at 0x05D291 with 13 args.

```python
regions = [
    (53, -1, 214, -1, "Analysis box",   "panel", "x=53, w=214; h=rows*20+6, vertically centred (y=100-h/2)"),
    (56, -1,  80, -1, "Attacker column","text",  "labels at x=56; values right-aligned at 56+0x50"),
    (160,-1,  80, -1, "Defender column","text",  "labels at x=160; values right-aligned at 160+0x50"),
]  # 320x200 Mode 13h
```

| Element | Value | Source |
|---|---|---|
| Frame | `0x1A1F:0x710`, x=53, w=214, h=rows·20+6, vertically centred; row pitch 20 | byte-cited |
| Title | "COMBAT ANALYSIS" = LABELS `@MISC` line 75 (slot `[0x2E50]`) | byte-cited |
| Columns | attacker x=56, defender x=160; labels colour `[0x830]`, values right-aligned at col_x+0x50 colour `[0x831]`; per-column unit sprite + info panel (`0x181F:0x2BC`) | byte-cited |
| Inputs | per column: flag word `F=[col·2+0x8D00]`, secondary `S=[col·2+0xA156]`, base strength `[col·2+0x8D06]` | byte-cited |
| Dismiss | modal wait `0x181F:0x3C0` | byte-cited |

Row table (flag → label → value): F&0x200 veteran-name row (base strength); F&0x400 Muskets
"+1"; F&2 Veteran +50%; F&4 Cargo −12.5% per used hold; F&0x100/S&8 Fatigue −33%/−66%; F&1
Attack Bonus +50%; F&0x8000 Bombard +50%; S&2/S&4 Tory/Rebel Unrest −(100−SoL%)/+SoL%; F&0x80
Ambush (att) / Terrain (def, draws the target tile) +terrain_def·25%; F&0x40 Colony
+(fortlevel+1)·50%; F&8(+0x10/0x20) colony-structure row +n·50%; F&0x800 Artillery In Open −75%;
S&1 Artillery Vs. Raid +100%; F&0x2000 Fortified +50%; F&0x1000 Spain Bonus +50%; F&0x4000 Drake
+50%. With the cheat bit (`[0x5383]&0x20`) extra rows show the final strengths and the raw roll.

### 26.11 Colonizopedia

The in-game encyclopedia: an alphabetized 3-column browser plus seven category entry-page
renderers on overlay page 0x16 (one function per `@PEDIA` category). Reached from the eight
`@PEDIA` pulldown items (commands 0x70..0x77 → `func_06B398`) and from per-screen context help
(dispatcher `func_02BC72` on selection type `[0x32E]`).

**Browser / index pager** (`func_06B398` / `func_06B02A`):

```python
regions = [
    (0,   0, 320,  15, "Title strip",   "text", "'ENCYCLOPEDIA OF COLONIZATION' centred y=5, colour 0xF"),
    (5,   5, 100,   7, "(More)",        "hit",  "left, only when count>72; hover recolour [0x831]"),
    (215, 5, 100,   7, "(Exit)",        "hit",  "right-aligned to x=315, y=5 via 0x181F:0x150"),
    (0,  15, 320, 185, "Index grid",    "hit",  "3 cols x 24 rows; x=col*100+5 (5/105/205), y=row*7+25, pitch 7"),
]  # 320x200 Mode 13h
```

| Element | Value | Source |
|---|---|---|
| Grid cell | x = col·100+5, y = row·7+25 (25..186); text at (x+2, y+1); cell hit 100×7 | `func_069156` 0x069182/0x069190 |
| Inks | normal `[0x830]`, highlighted `[0x831]`; highlight bar `0x181F:0xBA` w=textW+4 h=fontH+1 colour `[0x835]`; browser title colour 0xF literal | byte-cited |
| List | capacity 216; category sizes 16/23/21/27/38/25/12 (skips: terrain 0x10..0x17, Teacher, 4 buildings); forested terrains get " Forest" suffix; gnome-sorted alphabetically | byte-cited |
| Keys | Up '8'/0x148, Down '2'/0x150 (±1 mod count); Left '4'/0x14B −24 (wrap); Right '6'/TAB/0x14D +24; ENTER/SPACE open; ESC exit; "(More)" pages forward 3 columns cyclically | byte-cited |
| Font | FONTTINY (`[0x89E]`) | byte-cited |

**Shared entry-page skeleton** (identical opcode sequence in all seven): WOODPANL.PIK backdrop
(fallback fill colour 8); screen title `[0x2E92]` "ENCYCLOPEDIA OF COLONIZATION" centred y=5
colour `[0x831]`; entry header "<name>: <category>" centred at y = font_h+7; body seed y =
header_y + font_h + 0xE (JOB page: +font_h+3), x = 10; article = PEDIA section `<KEY><idx>` via
menu_lookup_run (`0x181F:0x998`), text-window y-cursor `[0x1F5A]`; terminator: present `0xE2`
(0,320,200) + modal wait. Sheets: ICONS.SS `[0x83E]`, BUILDING.SS `[0x842]`.

Per-page layouts (all byte-cited):

| Page (fn) | Layout facts |
|---|---|
| Cargo (`func_0694AE`) | production-chain rows, pitch y+=0x14; per row: job figure ICONS `job+0x52` at (10, y−2), cargo icon `cargo+0x17` then 6 more copies at x+=4 (7-icon stack), text "<Cargo> With <Expert>" at (x, y+4) colour `[0x830]` |
| Unit (`func_0696C6`) | temp preview UnitRecord (destroyed at exit); figures via `0x181F:0x2BC`, pitch 18 px, x home 8; type 0 = 25-figure profession gallery, 17/row, wrap y+=0x14; name line at fig_y+6; stat line "Combat/Moves(÷3)/Cargo Holds" at (8, y) — type 0xB's "(and Damaged <Name>" is missing its ")" in the shipping binary; article `@UNIT0..23`, `[0x1F5A]` = stat_y+0xC |
| Terrain (`func_069D8C`) | header "(<Name>: Terrain Type)"; **3×3 tile preview** framed (7,y0)–(0x3A,y0+0x33) (52×52 double rect colours `[0x839]`/`[0x837]`), 16-px cells at x=9/25/41; base ground from the boot-rasterized 12-tile TERRAIN array `[0x16C]`; forest overlay PHYS0 `0x41+M[c+3r]`, M=[5,7,6,13,15,14,9,11,10]; hills 0x31+M, mountains 0x21+M; rivers (0,1)→0x17 (0,2)→0x1B; roads (2,0)/(2,1); centre resource `0x5A+R[id]` (word table at file 0x1DB32); stat rows right column x=63 pitch 0x10 — figure `0x52+j` + "<Job>: N" at (75, row+6) colour `[0x831]` + bonus lines colour `[0x830]`; movement/defence line "M / +25·defence%" at (63, row+6); article `@TERRAIN0..28` |
| Skill (`func_06A700`) | workplace building chain (BUILDING frame b+1, x += frame_w+3); job figure `idx+0x52` at (10, y+bldg_h/2−7); product strip icons `idx+0x17`, x+=0x10 |
| Building (`func_06AA88`) | big picture BUILDING `rec+1` at (10, y) (idx 0x11→0x2F, 0x10/0x1F none); header at (10+w+3, h/2−7+y+6) colour `[0x831]`; worker figure + product; prerequisite line at (10, y) colour `[0x830]`, y+=0x14 |
| Father (`func_06AE08`) | text-only: name (table 0x9652 stride 6), y += font_h+0xE, article `@FATHER0..24` |
| Concept (`func_06AF1C`) | text-only: 12 names from the PEDIA `@MISCELLANEOUS` loader, article `"MISC<n>"` |

Inks: `[0x830]`=0x44, `[0x831]`=0x95 static inits (runtime rewrites possible).

### 26.12 Continental Congress (F3) + advisor-report geometry

The F3 Activities screen: full-screen REPORT3.PIK backdrop, text/sprite body `func_037A20`
(0x037A10..0x3807D). Progress toward the next Founding Father is **text only** — "(NN in MM)" —
the game has no fill bars anywhere.

```python
regions = [
    (0,  0, 320,   5, "Title fill + centred title", "text", "fill colour 0x90; 'CONTINENTAL CONGRESS ACTIVITIES' (@MISC 37)"),
    (4, 25, 312, 150, "Body line stack",            "text", "x=4, y-seed 25, pitch 8 (FONTTINY h6+2); colour 0x92"),
    (4, -1, 300,  -1, "Bell gauge row",             "art",  "0x181F:0x236: filled 0x3F / empty 0x38, span 300"),
    (4, -1, 300,  -1, "Rebel/Tory strip",           "art",  "sprites 0x7C x rebels + 0x7D x tories, span 300"),
    (4, -1, 300,  -1, "REF rows x2",                "art",  "0x222 enqueue x4 -> 0x22C flush, 4 columns, span 300"),
    (4, -1, 312,  -1, "Founding Fathers grid",      "text", "cols x={4,82,160,238}, step 0x4E, colour 0x61, 4/row"),
]  # 320x200 Mode 13h
```

State: PowerRecord +0x02 rebel%, +0x0C bells_current, +0x0E bells/turn, +0x12 FF-in-progress,
+0x14 FF count; REF counts `[0x53DA/DC/E0/DE]` + naval `[0x53E2..E8]`; threshold computed by
`func_03C282` (base `(diff+3)·2` human / `14−diff` AI, ×8, +50 % per year band 1600/1650/1700/
1750, ×(FF+1)+1, halved at 0 FF; endgame override `diff·0x5DC+0x7D0`). The FF-acquisition
**reveal popup** is a different path: full-screen CCBKGD.PIK (`func_03BB4A`), owned portraits
CC-00..24.SS blitted at each sheet's own baked frame-descriptor coordinates, two-phase light-up,
key/ESC dismiss — no frame, title, or OK widget.

**Advisor reports F1–F10 — summary geometry** (all bodies at file 0x37xxx–0x3Axxx; shared frame:
REPORT<N>.PIK, centred title in fill (0,0,320,~5) colour 0x90, footer sprite y=200, OK = `@MISC`
46 via the modal wait; body font FONTTINY, row flow = glyph_h+2):

| Report (body @file) | Static geometry |
|---|---|
| F1 Terrain (0x3744A) | rows y=0xA x=0x19; advance y+=0x1E then font+2; icon sprite terrain+0x72; right-justified counts at x=0x136−textW |
| F2 Religious (0x37958) | crosses gauge `0x236` X=10 Y=25 span 300, filled 0x39/empty 0x38; optional text x=10 y=25 colour 0xF |
| F3 Congress (0x37A10) | above |
| F4 Labor (0x38418) | matrix: name x=2, y-base 42, pitch 8, colour 0x92; count at +0x27 colour 0x61; dark-red (0x77) separator line x=2..311 |
| F5 Economic (0x38A50) | headers x=76/170/220 y=25; commodity table x=2 stride 17; value cols x=250/150 stride 12; y 25/33 pitch 8 |
| F6 Colony (0x39218) | rows base (2,20) pitch 17, 9/page; name colour 0x92 at +0x17; 4 centred captions y=27 at (2/82/162/242, box 80/80/80/76) |
| F7 Naval (0x3954C) | 4-col table: first row y=42, pitch 20, 7 ships/page; name LEFT x=26 colour 0x61; cargo sprite row; Location centred box (162,80); Destination centred box (242,76) |
| F8 Foreign (0x39888) | gate `[0x5382]&1` clear = draws; labels x=2 colour 0x91; power value columns x=13/80/160/240; full-width 0x77 separators |
| F9 Indian (0x39EE2) | rows from village table 0x54EC stride 18; columns x=16, +72, +20; y-start 24, second block 150; text colour = `[0x830]` (`@COLORS` basic) |
| F10 Score (0x3A9C0) | WOODPAN2 + SCORE<panel+1> plate, panel = largest i with i²/3 ≥ scaled score; FONTTINY labels + FONTINTR figures |

### 26.13 King audience / King-defeat screens

One renderer, `func_075352` (0x075352), paints the King audience (tax demands), the player-wins
(`@KINGLOSE`) and player-loses (`@KINGWIN`) plates. Backdrop = **KINGLSS<n>.PIK** (throne room,
empty chair, blank scroll); the outcome-selected **foreground** sheet (KING1.SS mocking king +
dog / KINGLOSE.SS crying / KINGWIN.SS triumphant) and the nation banner (ENGLND1/2, FRANCE…,
stem + digit) land by the .SS frame-descriptor anchor convention (descriptor stores centre-x /
bottom-y; on-screen x = ax−⌊w/2⌋, y = ay−h+1).

```python
regions = [
    (0,   0, 320, 200, "KINGLSS<n>.PIK throne room", "art",  "load_PIK @0x0753A9"),
    (0,  12, 189, 187, "KING1.SS figure",            "art",  "desc (94,198) -> (0,12), bottom-anchored to row 199"),
    (32,  0,  -1,  -1, "ENGLND1.SS canopy banner",   "art",  "desc (118,121) -> (32,0); nation stem + digit"),
    (232, 29,  80,  40, "Scroll header, 4 lines",    "text", "per-line centred on x~271.5, tops y=29..61 (measured)"),
    (232, -1,  80,  72, "Scroll body, 9 lines",      "text", "left-aligned x=232, pitch 8 = FONTKING h+1 (measured)"),
]  # 320x200 Mode 13h
```

| Element | Value | Source |
|---|---|---|
| Variant select | `(bp+6,bp+8)`: (1,1)→KING1 (audience); (1,other)→KINGLOSE (player WINS); (2,·)→KINGWIN (player LOSES); nation prefix switch on `[0x5398]` | 0x075430 / 0x0753BB |
| Font | **FONTKING** (sole user in the binary; loaded 0x0754F6, dialog font latch `[0x1F9E]/[0x1FA0]`; falls back to FONTTINY) | byte-cited |
| Pen stores | `[0x1F4A]=242, [0x1F50]=47`, flags `[0x1F56]|=0x18` — register values, NOT the on-screen origin; the glyph runner re-lays-out under the 0x18 flags | 0x075526/0x07552C |
| Text layout | header per-line centred x≈271.5, tops y=29..61; body x=232, pitch 8 (measured; FONTKING metrics pixel-perfect) | measured |
| Body strings | GAME `@KINGLOSE` (`@width=68 @x=232 @y=31`) / `@KINGWIN` (`@width=90 @x=202 @y=125`); audience bodies built by the King-event orchestrator `func_02F3A2` | byte-cited (GAME.TXT directives) |
| Dismiss / choice | the `@`-menu run at 0x075540 (king's option list); page-flip + palette restore 0x075553 | byte-cited |

Ink: FONTKING is 2-bpp; level-3 measures black (idx 0) on this palette (measured).

### 26.14 Woodcut event screens

Full-screen carved-wood event plates (WDCUT01..13.SS) with a caption strip, shown once per
event. Renderer `func_06B722` (0x06B722, `0x181F:0x52E`); once-only wrapper `func_00543C`
(`0x181F:0x524`, shown-bitmask `[0x540A]`, per-woodcut music cues).

```python
regions = [
    (0,   0, 320, 200, "Black clear",           "panel", ""),
    (-1, -1,  -1,  -1, "WOODFRAM frame 1",      "art",   "centred from sheet-header words"),
    (-1, -1,  -1,  -1, "WDCUT<n> art",          "art",   "plate blit inside the frame"),
    (-1, 162, -1,  -1, "NAMEPLAT strip",        "art",   "left cap + N mid tiles + right cap, centred on x=160, y=162"),
    (-1, 165, -1,  -1, "Caption",               "text",  "'<year>: <CAPTION>' centred y=165, FONT-NP"),
]  # 320x200 Mode 13h
```

Caption = line n of the single `@WOODCUT` section, prefixed `"<year>: "` from `[0x538A]`;
ink LUT palette indices 0x5C/0x5D/0x5E; staged present/fade `func_005160(8)`; modal wait;
palette restore. Frame numbering is 1-based over disk descriptors. Trigger table (caller scan
exhaustive): 1 DISCOVERY (first landfall), 2 BUILDING A COLONY (first colony, human), 3/4/5
MEETING THE NATIVES / AZTEC / INCA (first contact by tribe), 7 ENTERING INDIAN VILLAGE, 8
FOUNTAIN OF YOUTH (Lost City outcome 1), 9 CARGO FROM THE NEW WORLD (first Europe cargo), 10
MEETING FELLOW EUROPEANS, 11 COLONY BURNING, 13 INDIAN RAID; 0/6/12/14–16 have no caller
(unreachable in the shipping binary).

### 26.15 Trade-route editor

The Edit Trade Route screen (page 0x12; commands 0x50 Edit / 0x51 Create / 0x52 Delete →
`func_060FBC`/`func_0610B0`/`func_0612E6`; painter `func_06083A`). Data: RouteRecord stride
0x4A, max 12 (`[0x53A0]`): +0 name[0x20], +0x20 type (1=sea), +0x21 stop count (max 4), +0x22
stops[4] stride 0xA (dest word — 0x3E7 = Europe; load/unload cargo nibbles).

```python
regions = [
    (0,     0, 320, 200, "Clear colour 0x22",       "panel", ""),
    (0,     5, 320,   8, "Title",                   "text",  "'EDIT TRADE ROUTE <n+1>' centred y=5, colour 0x0F @0x060898"),
    (10, 0x19, 300,   8, "Route Name row",          "hit",   "'Route Name:' + name at (10,25); click = @TRADENAME entry"),
    (10,   -1, 300,   8, "Route Type row",          "text",  "'Route Type:' + Sea/Land at (10, glyph_h+0x1B)"),
    (10,   -1, 310,   8, "Column headers",          "text",  "Destination / Unload / Load at y=0x37-glyph_h; x=w('0.  ')+10 / 0x7D / 0xD0"),
    (0,  0x3D, 320,  80, "Stops table (5 bands)",   "hit",   "rows y=0x3D..0x8D pitch 0x14; separators x=0x73 and x=0xC6"),
    (0x118,0xAA, 30, 20, "OK button",               "hit",   "box (0x118,0xAA)-(0x135,0xBD), label 'OK' (@MISC)"),
]  # 320x200 Mode 13h
```

| Region | Bounds | Kind | Content source | State binding |
|---|---|---|---|---|
| Stop row n | y = 0x3D + n·0x14 | hit | "N. <destname>" at (10, rowY+8); unload icons from x=0x7D, load icons from x=0xD0 — ICONS `cargo+0x17`, advance sprite_w+2 | route stops[4]; row=(y−0x3D)/0x14; x<0x73 destination, <0xC6 unload, else load |
| Cargo cells | icon columns | hit | click icon = remove (shift left); click space = `@CARGOUNLOAD`/`@CARGOLOAD` 16-row menu (width 120), max 6 | nibble get/set `func_0603DA`/`func_06040A` |
| Destination picker | shared dialog | hit | `@TRADESTART` header; rows = eligible own colonies; Europe row for ships only (per-nation port name `[0x838C]`) | `func_060026` (also serves Go-To orders) |
| OK / exit | (0x118,0xAA,0x1E,0x14) | hit | y≥0xAA exits; Enter/Esc exit | commit |

Labels from the runtime `@ROUTE` table `[0x93DE..0x93EE]` (9 entries). The editor creates a
phantom probe unit at (0xFF,0xFF) to filter reachable destinations (deleted at exit). Create
flow: cap check → dest 1 → coastal test → `@TRADETYPE` → default name = colony + random
`@TRADENAMES` word → name entry → dest 2 → editor. Delete compacts the array and fixes unit
links (unit byte +0x17: lo nibble route, hi nibble stop).

### 26.16 Founding-Father pick dialog

The `@WHICHFREEDOM` dialog (width 190, centred, standard engine), posted by the colony-turn
update when no FF candidate is in progress. Rows = one weighted-random candidate per each of the
5 categories: "FATHERNAME (Category Adviser)" — category names from NAMES `@FOUNDING`
(Trade/Exploration/Military/Political/Religious), "Adviser" from `@MISC`; row id = category+1.

```python
regions = [
    (62, -1, 196, -1, "Pick dialog", "panel", "@width=190 => box_w=196, x=160-196/2=62; y centred, h item-driven"),
]  # 320x200 Mode 13h
```

Bindings: **cannot cancel** (result ≤0 re-shows, 0x03C231); right-click/help (`[0x1F68]`) opens
the pedia FATHER page for the candidate, then re-shows; result → `[0x84FC]+0x12` = father id.
Acquisition fires the `@FREEDOM` popup then the CCBKGD reveal (§26.12). Candidate weights =
NAMES `@FATHERS` era-weight bytes (era bands <1600 / 1600–1699 / ≥1700).

### 26.17 Tutorial / popup placement notes

Tutorial hints (`@TUTORIAL1..19`) are ordinary GAME.TXT popups through the §25.2/§25.3 engine
(portrait channel `[0x1F5E]` → MSS<n>.SS), gated by Game-Options bit 0x80 (T18 ungated).
Placement is either centred or a fixed GAME.TXT literal — never unit-relative:

| Section | Literal directives |
|---|---|
| `@TUTORIAL1` | `@x=10 @y=40` |
| `@TUTORIAL4` | `@x=10` |
| `@TUTORIAL12` | `@y=5` |
| `@TUTORIAL16` | `@x=5 @y=10 @smallfont` |
| `@TUTORIAL17` / `@TUTORIAL18` | `@y=10 @width=300 @smallfont` |
| `@VICEROY` | `@x=232 @y=21` |
| `@KINGLOSE` / `@KINGWIN` | `@x=232 @y=31` / `@x=202 @y=125` |
| all §25.3 gameplay popups | centred, `@width` 190 or 220 |

Once-flags live in save bytes `[0x5380]/[0x5386]/[0x5387]`; the unit-focus dispatcher
`func_020F50` (0x020F50) drives T1/T3/T8–T11/T13–T15/T19 from the selected unit `[0x5392]`.

---

## 27. Input, cheats, and options

The complete keyboard surface of the shipped binary, the hidden Alt-W-I-N cheat system, and the
three persisted option dialogs. Facts here fall into three trust classes: literal compare sites
in the EXE (exact codes), `~`-marked accelerator letters in the TXT menu data (exact text; the
per-row handler binding is data-driven), and printed-manual key lists whose engine wiring is
runtime table dispatch — each class is labelled where it matters.

### 27.1 Keyboard maps

**Dispatch model.** The command executor is `func_0235D6` (`switch [bp+6]` on a normalised
command/key id). Only the F-key report ladder is a literal compare chain (0x023843–0x02390B);
the single-letter accelerators are data-driven — the `~`-marked letter parsed from each menu
row (live-verified in RAM: the menu nodes carry the `MENU.TXT` labels verbatim) is matched
against the typed key by the menu engine, and the matched row's command id dispatches. So the
letters below are exact (string-table + manual-corroborated); the per-row handler binding is
runtime menu-node state, not a static per-key compare.

Map view — global single-letter commands (from the `~` accelerators of the ORDERS/VIEW rows):

| Key | Action | | Key | Action |
|---|---|---|---|---|
| Arrows | move active unit / cursor (8-way with the keypad; menus and the pedia also accept ASCII '8'/'2'/'4'/'6' aliases of scancodes 0x148/0x150/0x14B/0x14D) | | `G` | Go to port / place |
| `A` | Activate unit | | `O` | Dump cargo overboard |
| `W` | Wait for next unit | | `L` / `U` | Load / Unload cargo |
| `Space` | No orders (skip) | | `T` | Begin trade route |
| `F` | Fortify | | `Shift-D` | Disband unit |
| `S` | Sentry | | `E` | Return to Europe |
| `B` | Build / Join colony | | `V` / `M` | View mode / Move mode |
| `P` | Clear forest / Plow | | `H` | Show hidden terrain |
| `R` | Build road | | `Z` / `X` | Zoom in / out |
| `C` | Centre view | | `ESC` | exit (confirm) |
| Alt+letter | open that pulldown (Alt-G/V/O/R/T…) | | right-click | info popup |

**8-way movement / view scroll.** Cursor movement is handled by the keyboard movement
dispatcher `func_023F1C` (0x023F1C..0x0241CE) on the last scan code `[0x981E]`: the arrow/numpad
arms bump the cursor `[0x17C]/[0x17E]` by ±1 (or the page step `[0x188]`), clamped to the map
bounds `[0x853A]/[0x853C]`; the extended-scancode block 0x147..0x151 selects a **direction code
0..7** through the 9-entry jump table at file 0x024170 (`jmp cs:[bx·2+0x3290]`) — full 8-way
movement including the keypad diagonals — which then either issues the unit move or scrolls the
view (`0x181F:0xDA4`).

F-key reports (explicit `cmp [bp+6],code` ladder — all byte-cited):

| Key | Report | code | Thunk | Body @file |
|---|---|---|---|---|
| F1 | Terrain Information | 0x48 | `0x191F:0x41A` | 0x3744A |
| F2 | Religious Adviser | 0x41 | `0x191F:0x40C` | 0x37958 |
| F3 | Continental Congress | 0x42 | `0x191F:0x3FE` | 0x37A10 |
| F4 | Labor Adviser | 0x43 | `0x191F:0x3F0` | 0x38418 |
| F5 | Economic Adviser | 0x44 | `0x191F:0x3E2` | 0x38A50 |
| F6 | Colony Adviser | 0x45 | `0x191F:0x3D4` | 0x39218 |
| F7 | Naval Adviser | 0x46 | `0x191F:0x3C6` | 0x3954C |
| F8 | Foreign Affairs | 0x47 | `0x191F:0x3B8` | 0x39888 |
| F9 | Indian Adviser | 0x49 | `0x191F:0x3AA` (gated, see §27.2) | 0x39EE2 |
| F10 | Colonization Score | — | score path | 0x3A9C0 |

Colony screen (manual-sourced — the keys drive the multi-function display, no static per-letter
compare): Tab view-to-view; arrows within view; Enter jobs menu; `L`/`=` load all, `+` load
some; `U`/`-` unload all, `_` unload some; `M` toggle views; `1`/`2`/`3`
production/units/construction; `N` numbers on/off; `C` construction menu; `B` buy; `F1` info;
`ESC` exit.

Europe screen (manual-sourced; `x`/ESC byte-corroborated): Tab; arrows; Enter dock/harbor
options; `L`/`=` buy full, `+` buy some; `U` sell, `-`/`_` sell all/some; `R`/`1` recruit,
`P`/`2` purchase, `T`/`3` train; `F1` info; `ESC`/`E` exit.

Dialogs / popups: arrows move the highlighted row; Enter/click confirms; Space/Enter/click
dismisses a message; row highlight = the `0x181F:0xCE` 1-px hollow outline. Boot menu: arrows,
ENTER 13, ESC 27, SPACE 32, digits + first letters. Pulldowns: '8'/'2' or arrow scancodes
navigate, 0x14B/0x14D switch menus, item-shortcut letters fire rows, releasing Alt closes.
Internal abort codes 0x110/0x12D in the idle poll set the abort flag `[0x828]`.

### 27.2 The Alt-W-I-N cheat system

- **Master flag** = bit 0x20 of `[0x5383]`. Cleared at new-game init (`mov word [0x5382],0xC600`
  at 0x0755E5); survives load (`and word [0x5382],0x207F` at 0x02306A).
- **Enable combo: Alt-W, Alt-I, Alt-N** in the map key handler `func_023F1C` — sequence state
  `[0xB92]`, key compares 0x111/0x117/0x131 at 0x023FA9/0x023FB9/0x023FD0 → `xor byte
  [0x5383],0x20` + un/hide the CHEAT menu + redraw. No CLI or file enable exists.
- The CHEAT pulldown (`@CUP`, header "~CHEAT") is always built as menu 6 with hard-coded command
  ids, hidden while the bit is clear (`test [0x5383],0x20` at 0x072A8B).
- **Anti-cheat**: with cheat mode on, F10 Colonization Score is refused with a **beep**
  (`test [0x5383],0x20` at 0x0238D1 diverts the dispatch); F9 uses the same gate bit.

Cheat-menu command table (row order per `@CUP`; ids 0x62..0x6F):

| id | Item | Effect (byte-cited) |
|---|---|---|
| 0x62 | F01 Create Unit | DEBUG `@CREATE` (peace) / `@CREATE2` (war): unit spawner at the map cursor (`[0x853E]/[0x8540]`); rows → unit types (row 9 → `@CSHIP` Caravel..Man-O-War; rows 10–13 Indians owned by the village under the cursor, or war remaps to Continental/King's forces; row 14 → `@FOREIGN`/`@FOREIGN2` creating-power picker) |
| 0x63 | F02 Debug Info Flags | the `[0x894]` checkbox dialog (§27.3) |
| 0x65 | F04 Reveal Map | `@SETVIEW`: view-as-power `[0x53A4]`, row 5 Complete Map `[0x53A2]=1` + clears the cheat bit |
| 0x66 | F05 Set Human Player | `@SETHUMAN`: all powers AI, picked power human (`[0x5398]/[0x5394]/[0x5396]`); "None" → `@SETAUTO` autoplay `[0x826]=1` |
| 0x67 | F06 Kill Indians | runtime tribe menu → `func_046FC2` destroys every village (base 0x54EC stride 0x12) owned by tribe+4 |
| 0x68 | F07 Advance Revolution Status | `@FORCED`, staged: (a) rebel meter `[0x53D0]`=75 + create REF power; (b) declare independence (`[0x5382]|=1`); (c) next war stage (`|=2`); (d) `|=0x20` + text |
| 0x69 | Sound Test | DEBUG `@SOUND` numeric dialog ("Play what sound #?") → `[0x9CC8]` → gated play `0x181F:0x4C0` — arbitrary sound-id playback |
| 0x6A | Memory Check | DEBUG `@MEMORY` display-only: far-heap / menu-arena / near / stack free + PSP segment |
| 0x6B | F08 Show Strategy | `func_02165E`: plots the 64×4-byte AI strategy slots per power (BSS 0x98B0+power·0x100, {x,y,?,type}); pass 2 prints 14 counter rows at (5, i·7+10) colour 0xF |
| 0x6C | F09 Show Colony Sites | `func_021602`: per-tile site desirability (low nibble of the tile flag byte) drawn over the map |
| 0x6F | F010 Test Routine | `and [0x5382],0xF4` + dialog with unit count `[0x539C]` / colony count `[0x539E]` |

Ungated debug: the `@DANGER` AI-assertion box (`func_078142`, 37 call sites) fires in the
shipping binary on AI sanity-check failure.

### 27.3 The `[0x894]` debug bitfield (7 bits; session-only; default 8)

Builder `func_02356C` (cheat id 0x63): checkbox dialog over DEBUG `@OPTIONS` (7 rows), preset
`and dx,[0x894]`, rebuild `or [0x894],ax`. The field lives in **no save block** — session-only —
and boots with **bit 0x08 already set** (live-verified at boot and in-game; invisible without
the cheat bit).

| bit | Row | Tester | Effect |
|---|---|---|---|
| 0x01 | Anger & Friction Levels | 0x004241 / 0x044303 | white anger number at village px+2/py+9; info panel appends 8 tribe rows |
| 0x02 | Indian AI movement | 0x0470A3 | shows AI moves + tile flash when visible to the human |
| 0x04 | Supply and Demand (Indians) | 0x0494DA/0x0495DE | 16-good supply/demand dump, x=1, y=8·(g+1), colour 0x0F, blocking getch |
| 0x08 | Foreign AI planning modes | 0x003971 (ALSO requires the cheat bit) | AI units' map letters become their plan-mode char (≥0x80 → 'E') |
| 0x10 | Close Moves | 0x061F14 | per-tile path-cost overlay, red summary (5,190), Z/X zoom |
| 0x20 | Far Moves | 0x062975 | "Far: %d(%d,%d)…" overlay |
| 0x40 | All Movement | 0x062D94 | sets latch `[0x1DF2]` honoured by the Close-Moves renderer |

### 27.4 The three options dialogs

All are standard §25.2 checkbox dialogs over GAME.TXT sections; checkbox channel = bitmask word
`[0x1F54]` (reset `0x191F:0x26E`, pre-seed `0x262`, read-back `0x306`).

**Game Options** (`@GAMEOPTIONS`, width 190, `func_022FD6`; state word `[0x5382]`, clear mask
`and 0x207F` — deliberately preserving the 0x2000 cheat-master bit):

| Row | Option | Bit | Polarity |
|---|---|---|---|
| 1 | Show Indian Moves | 0x8000 | direct |
| 2 | Show Foreign Moves | 0x4000 | direct |
| 3 | Fast Piece Slide | 0x1000 | direct (slide step 8 vs 10, zoom-shifted) |
| 4 | End of Turn | 0x0800 | direct |
| 5 | Autosave | 0x0400 | direct (rolling slot 9 each turn + slot 8 on decades) |
| 6 | Combat Analysis | 0x0200 | direct (gate at 0x05D221) |
| 7 | Water Color Cycling | 0x0100 | **INVERTED** — bit set = cycling OFF; side-effect: `[0x372]` master + vblank-synced full DAC restore when disabling |
| 8 | Tutorial Hints | 0x0080 | direct |

**Colony Report Options** (`@COLONYOPTIONS`, width 220, `func_02311A`; state word `[0x5384]`,
clear `and 0xFC00`). **All 10 bits are INVERTED — a set bit means "suppress"**:

| Row | Option | Bit | | Row | Option | Bit |
|---|---|---|---|---|---|---|
| 1 | Labels on buildings | 0x0002 | | 6 | Report tools needed | 0x0010 |
| 2 | Labels on cargo and terrain | 0x0001 | | 7 | Report inefficient government | 0x0008 |
| 3 | Report when colonists trained | 0x0080 | | 8 | Report new cargos available | 0x0004 |
| 4 | Report food shortages | 0x0040 | | 9 | Report Sons of Liberty membership | 0x0100 |
| 5 | Report raw materials shortages | 0x0020 | | 10 | Report rebel majorities | 0x0200 |

**Sound Options** (`@SOUNDOPTIONS`, `func_0232AE`): row 1 `[0xA2]` Background Music, row 2
`[0xA0]` Event Music, row 3 `[0xA4]` Sound Effects — mirrored into the persisted flag word
`[0x5386]`; turning an option off sends driver command 1 (stop). **Pick Music** (`@PICKMUSIC` +
3 sub-pickers, `func_023344`): rows 1–12 = the folk tunes, rows 13/14/15 open the
Independence/Military/Indian sub-lists; selection → tune id `[0x96]` (ids 0x20..0x3B) + gated
play; no persistent lock — normal rotation resumes when the tune ends.

**Persistence**: `[0x5382]` (game options), `[0x5384/5]` (colony options) and `[0x5386]` (sound
mirror) all live in **save block #3** (base 0x5380, size 0x8E), written by `func_0734F8` and
restored by `func_073BB0` — all three dialogs survive save/load; `[0xA0]/[0xA2]/[0xA4]` and the
water-cycling master `[0x372]` are re-derived on load. The debug bitfield `[0x894]` is in no
save block — session-only. No configuration file exists.

---

## 28. The map editor (MAPEDIT.EXE)

Colonization ships a stand-alone map editor, MAPEDIT.EXE (145,292 bytes), which
shares the MADS engine and the game's asset files (VICEROY.PAL, TERRAIN.SS,
PHYS0.SS, ICONS.SS, WOODTILE.SS, FONTINTR, FONTTINY, CURSOR.SS) with the main
executable. Uniquely among the shipped binaries it retains a CodeView NB02
debug block, so every function in this section is cited by its real,
compiler-emitted name together with its file offset. The editor reads and
writes the 3-layer `.MP` map format (6-byte header `width u16, height u16,
version u16 = 4`, then terrain / feature / continent layers of width×height
bytes each; AMER2.MP is 12,534 = 6 + 3·58·72 bytes).

### 28.1 The CodeView symbol trove

The debug block at file offset 0x1BE09 carries **1,071 public symbols**; a
symbol's file offset is `segment·16 + offset + 0x1600` (0x1600 = MZ header
size). The symbols partition the binary into named modules: the editor's own
code in `mapedit.obj` (138 symbols), `popup.obj` (84), `map.obj` (76, plus
`map_2/map_5/map_6/map_9/map_a`), `menu.obj` (38), `write.obj` (30),
`text.obj` (14), `me_mini.obj` (13), `tile.obj`, `stuff.obj`, `strings.obj`,
`env_1.obj`, `compass.obj`; and the MADS engine library (`mouse_1/mouse_2`,
`mem_*`, `pal_1`, `ems_1/ems_2`, `xms_1`, `himem_1`, `pack_5`, `pfabcomp`
(the FAB compressor), `loader_1`, `timer_1/timer_3`, `keys_4`, `sound_1/2`,
`font_1`, `cycle_1`, `mcga_7`, `sprite_e`, `matte_0`, `heap_1`, `error_1`,
`dos\crt0.asm`). These names anchor the whole section and — because the
engine modules are shared — resolve otherwise-anonymous code in VICEROY.EXE
(§28.8).

### 28.2 Startup and initialisation

`_main` @0x3ED8 scans the command line. Arguments beginning `-` or `/` go
through the per-character `_flag_parse` @0x3E72:

| flag | effect |
|------|--------|
| `-c` | `_create_me_now`=1 — force the create-new-map path |
| `-m:file` | `_map_name` ← file, `_map_selected`=1 |
| `?` (any arg starting `?`) | `_show_flags` @0x3DF6 — prints the usage text at DS:0x3AA..0x487 and exits |
| any other letter | ignored |

Otherwise control passes to `_viceroy_game` @0x3B16. On exit, a non-zero
`_exit_value` prints `"Exit value: %d\n"`. Initialisation is strictly ordered
and each failure sets a distinct exit code:

| step | asset / action | exit code on failure |
|------|----------------|----------------------|
| video mode 0x13 (MCGA 320×200) @0x3B2E | — | — |
| palette | VICEROY.PAL | 0x13 |
| two 320×200 work buffers `_scr_work` / `_scr_orig` | — | 0x14 |
| `_font_inter` | FONTINTR | 0x15 |
| `_menu_font` | FONTTINY | 0x16 |
| `_load_terrain_tiles` @0xB152 → `_terrain_1` | TERRAIN.SS as a flat 12-frame 16×16 array | 0x321 / 0x322 |
| cursor | CURSOR.SS | 0x17 |
| `_tiles` / `_tiles2` | PHYS0.SS | 0x18 |
| icons | ICONS.SS | 0x19 |
| `_scr_back` 32×24 tile | WOODTILE.SS | 0x1A / 0x1B |

then `_get_tile_colors` (mini-map colour table, §28.5), `_load_data` @0x3936
(NAMES.TXT), a **12,000-byte undo buffer** `_map_undo_memory`
(`_undo_available`=1) @0x3D6E, `_start_new_game` @0x3A7A, and the main loop
`_turn_control_loop` @0x38B0. The TERRAIN.SS-as-base-ground load order is one
of the independent proofs that TERRAIN.SS is the ground sheet composited
under the PHYS0.SS overlays.

### 28.3 Text-data loads

`_load_data` @0x3936 reads **NAMES.TXT**: `@UNFORESTED` fills terrain records
0..7, `@FORESTED` fills 8..15 and records 16..23 are `memcpy` aliases of
8..15 (@0x39B1–0x39CD), `@OTHER` fills 24..28
(Arctic/Ocean/Sea Lane/Mountains/Hills — the same authority order the game
uses: 25 = Ocean, 26 = Sea Lane), `@OTHER_NAMES` fills `_terrain_names`
("Forest / River / Major River / Minor River / Unexplored"), and `@COLORS`
fills nine palette-index globals (`_basic_color`, `_hilite_color`,
`_grey_color`, `_enhance_color`, `_shadow_color`, `_select_color`,
`_border0/1/2`, DS:0x92..0x9B), propagated to the popup engine by
`_popups_normal` @0x1618. Each terrain record is 16 bytes (appendix A). The
13th NAMES numeric column is never read.

**MAPMENU.TXT** feeds `_construct_mapedit_menu` @0x1796: sections `@GAME`
("Editor"), `@VIEW`, `@CUP` ("Map"), `@HELP`. Menu items receive hard-coded
event ids at the `_menu_add_item` call sites (0x13 Save As, 0x14 New, 0x1A
Save, 0x1B Load, 0x1F Exit, 0x24–0x2B zooms, 0x4A–0x4E map operations, 0x51+
help). Dialog wording comes from the 19 sections of MAPEDIT.TXT.

### 28.4 Session flow

`_start_new_game` @0x3A7A:

- With no `-m`/`-c`: the **file picker** `_file_menu("MAPEDIT", "MAPTOEDIT",
  "*.MP")` @0x3A8C ("Select Map File to Edit / (ESC to create new map)");
  ESC or cancel falls through to the create path.
- Map defaults `w=58, h=72` are set @0x3AB5; `@map_startup` allocates four
  0x2EE0-byte (= 58·72 = 4,176-tile, 12,000-byte-rounded) layer buffers:
  terrain, feature, continent, plus a memory-only `_site` layer.
- **Create**: `_create_me` @0x2BFC — a name-entry popup (sections
  "MAPEDIT"/"NEWNAME", default `UNTITLED.MP`, max 0x14 chars) →
  `_create_blank_map(58,72)`: size hard-coded, every tile filled with
  **Ocean (0x19)**, version = 4, then `_map_changes`=1. **There is no
  map-size picker and no procedural map generation anywhere in
  MAPEDIT.EXE** — arbitrary sizes can only enter via files.
- **Load**: `_load_map_file` @0xB700 (header/size validation), then
  **`_forest_fix` @0x16B6**, which normalises forest alias ids 16..23 down
  to 8..15 and strips the forest id from tiles carrying the mountain/hill
  overlay bit.
- Both paths centre the cursor and the view at (w/2, h/2).

`_file_menu` @0x1B6A runs DOS findfirst/findnext over the pattern into
13-byte name slots at DS:0x64F0, pages of 10, with "(More)" pager rows
(codes 0x61/0x62); the result goes to `_file_select`.

### 28.5 The main editor screen

```python
regions = [
    (0,   0, 320,   8, "Menu bar",       "panel", "WOODTILE fill; FONTTINY titles (_main_screen_refresh @0x2317)"),
    (0,   8, 240, 192, "Map viewport",   "hit",   "fixed 240x192 px (_map_pixel_size 0xF0/0xC0 @0xB633/@0xB639; hit test _mouse_area @0x31CA)"),
    (241, 8,  79,  41, "Mini-map panel", "panel", "frame rect (251,8)-(308,48) (_show_mini @0xCF14)"),
    (252, 9,  56,  39, "Mini-map",       "art",   "1 px per tile, max 56x39 (@0xCF8D)"),
    (241, 50, 79, 150, "Info window",    "text",  "border (240,49)-(320,200) (_info_window_clear @0x1DBD); click opens Tile Select"),
]  # 320x200 Mode 13h; drawn into two offscreen 320x200 buffers _scr_work/_scr_orig
```

**Zoom** (`@compute_view_parameters` @0xBA76): scale 0..3, visible tiles =
(15<<scale) × (12<<scale), tile pixels = 16>>scale. The four fixed levels:

| key | scale | visible tiles | px/tile | sprite scale |
|-----|-------|---------------|---------|--------------|
| F4  | 0 (startup default) | 15×12 | 16 | 100% |
| F3  | 1 | 30×24 | 8 | 50% |
| F2  | 2 | 60×48 | 4 | 25% |
| F1  | 3 | 120×96 | 2 | 12% |

The view corner is clamped to [1, dim−view−1]; maps smaller than the view
are centred via `_map_tile_inset`.

**Info window** (FONTTINY, ink `_basic_color`, origin x=242 y=51, line pitch
fontH+1; content painters @0x1F4E–0x22D2), top to bottom:

1. `Size: (w, h)`
2. `Curs: (x, y)`
3. `Terrain at cursor:` + name — with `" Forest"` appended for ids 8..0x17
   and `(Major River)`/`(Minor River)` decoded from bits 0x40+0x80
4. `Selected:` + a 16×16 tool swatch (ground tile + PHYS0 forest overlay;
   or PHYS0 frames 4 / 0x14 / 0x24 / 0x34 for the river/river/mountain/hill
   tools)
5. shift-click help lines
6. `Fill radius: N`
7. `Coast Protect: ON|OFF`

**Mini-map**: 1 pixel per tile, window = clamp(centre −28, −19). Colour =
`_terrain_colors[id]`, where ids 0..23 sample **pixel (8,8) of the tile's
TERRAIN.SS frame** and Mountains/Hills sample PHYS0 frames 0x21/0x31
(`_get_tile_colors` @0xCBCC). A white (palette 0x0F) rectangle marks the
current view (@0xCFB4).

**Cursor**: ICONS.SS frame **0x13+scale** (a 16/8/4/2-pixel box matching the
tile size), blinking with a 20-tick (~1/3 s) period (@0x29C6/@0x372E).

### 28.6 The "Map Tile Select" screen

`_selection_screen` @0x2826 (menu id 0x4B, accelerator M, or a click on the
info window) is a custom full-screen picker on black. Items are 16×16 on a
**17-pixel pitch**:

- row 0, y=1: the 8 unforested base tiles;
- row 1, y=18: the forested variants (base tile + PHYS0 frame 0x41 overlay;
  Desert's forest uses the dedicated Scrub ground tile via id 0x11);
- bottom row, y=48: Arctic / Ocean / Sea Lane tiles, then PHYS0 sprite items
  frame 4 = Major River, 0x14 = Minor River, 0x24 = Mountains, 0x34 = Hills.

A white selection box is drawn at (x−1,y−1)–(x+16,y+16); the selected tool's
name is labelled at (160,10). Arrow keys move ±1/±8 across the 24 slots;
any other key or a click-release exits. The startup default tool is Ocean.
Each tool compiles to a (sel, and, or, rmc) mask set (`_parse_spot` @0x26CC)
applied to the terrain byte:

| tool | sel | and | or | rmc |
|------|-----|-----|----|-----|
| terrain id t (rows 0/1, Arctic) | t | 0xFF | 0 | 0 |
| Ocean / Sea Lane | 0x19 / 0x1A | 0x40 | 0 | 0 |
| Major / Minor River | 0 | 0x1F / 0x3F | 0xC0 / 0x40 | 1 |
| Mountains / Hills | 0 | 0x1F / 0x5F | 0xA0 / 0x20 | 1 |

### 28.7 Paint interaction

- Screen→tile mapping: `tx = mx/tsz − inset_x + corner_x`,
  `ty = (my−8)/tsz − inset_y + corner_y` (@0x35C4–0x35F1).
- **Plain click** recentres the view (`_set_center`). **Shift+left** paints
  (`_fill_map`): a square brush of side 2r+1 where r = `_fill_radius` 0..2,
  i.e. **1×1 / 3×3 / 5×5** (menu "Fill Mode Change", id 0x4C, cycles
  r=(r+1)%3 @0x3104); painting is continuous while dragging, with one undo
  snapshot taken at stroke start. **Shift+right** is context-sensitive:
  with a terrain tool it is an **eyedropper** (picks up the tile under the
  cursor as the current tool); with a feature tool it removes the feature
  (applies the and-mask only). Keyboard: Enter/Space = paint at cursor,
  Backspace = pick-up/remove.
- `_change_map` @0x31E0 enforces three guards: the **1-tile border ring is
  immutable**; while **Coastline Protect** is ON (`_coastline_protect`
  [DS:0x4E], toggled by menu id 0x4D) painting terrain onto Ocean/Sea-Lane
  tiles is skipped (@0x3265–0x327D); and the mountain/hill or-bit is
  **always** refused on water (@0x328B). Any accepted write sets
  `_map_changes`.
- **Undo** is a single slot covering the terrain layer only: a 12,000-byte
  copy taken at stroke start; `_perform_undo` @0x1D7E restores it (menu id
  0x4E / key U, gated by `_undo_available`/`_undo_active`). The mini-map is
  rebuilt on every draw (`_small_map_needs_update` exists but is never
  referenced).
- Cursor movement: numpad 1–9 and Home/Up/PgUp/Left/Right/End/Down/PgDn give
  8-way movement (jump table at file 0x346E), clamped to [1, dim−2], with
  auto-scroll when within 2 tiles of the view edge (`_possibly_center`
  @0x2A5E).

### 28.8 Menus and dialogs

**Engine identity.** MAPEDIT's `menu.obj` is **the same pulldown module as
VICEROY's in-game menu bar, built from the same source**: the dropdown
screen clamps @0x008E97/@0x008EA6 (`cmp [bp-8],0x13e` / `cmp [bp-2],0xc6` —
right edge ≤ 317, bottom ≤ 199) are instruction-identical, with the same
locals and constants, to VICEROY `func_044FA4` @0x04505F/@0x04506E, and the
node shapes match (bar's menu list at +0x38, a menu's item list at +0x1E,
`~`-hotkey extraction, pending-command word at struct offset +0).

**Menu bar** (`_construct_mapedit_menu` @0x1796): `_menu_create(0x800,
FONTTINY)` @0x17AA → `_menu_bar` at DS:0x78. Constants (@0x86C3–0x86E6):
bar y=1, bar gap 12, drop-row pad 3, bar text pad 1, drop text pad 4. Bar
and dropdown backgrounds use fill colour 7,7, the sentinel that selects the
**WOODTILE fill** — the pre-rendered 32×24 `_scr_back` tile (menu helper
@0x83C2, popup helper @0x4D1A). Bar items read positionally from
MAPMENU.TXT (`_text_get`, one line per call, `_` → space): "Editor", View,
"Map", Help (Help right-justified at x = 0x140−width−12 @0x8B0B). First bar
item x=12, then prev.x+prev.w+12; hotkey characters (after `~`) draw in the
hilite colour @0x84FF–0x8567. Dropdowns: x = bar-item x, y = barFontH+4,
width = maxItemW+2 (min 0xA), height = (fontH+3)·visible+5, 1-px border in
`_menu_border_color`, wood interior, empty rows drawn as centred 1-px
separator rules, save-under id 0xFFF8.

**Command dispatch** (`_execute_menu_event` @0x2DE0, jump table at file
0x2DFC):

| id | item | action |
|----|------|--------|
| 0x1A | Save | confirm popup `@SAVE` → `_write_map_file`; failure → `@ERROR`; success clears `_map_changes` @0x2F8E |
| 0x13 | Save As | strip path, string popup `@SAVEAS` (14 chars), force extension "MP", write @0x2EAC |
| 0x1B | Load | if dirty confirm `@LOAD`; `_file_menu(@MAPTOLOAD,"*.MP")`; load; `_forest_fix`; recentre @0x2FD4 |
| 0x14 | Create | if dirty confirm `@CREATENOW`; `_create_me`; recentre + `_new_mini` @0x2F24 |
| 0x1F | Exit | if dirty, 3-way `@EXIT` (exit unsaved / save+exit / cancel) @0x305E |
| 0x24/0x25 | Zoom In ~Z / Out ~X | `_set_zoom_level(_map_scale ∓ 1)` @0x30C2/@0x30D2 |
| 0x26–0x29 | F1..F4 zoom rows | `_set_zoom_level(0x29−id)`, clamp 0..3 @0x30D8/@0x2B8B |
| 0x2B | ~Center View | `_set_center(cursor, 1)` @0x30E0 |
| 0x4A | Find Continents | `_continent_check` @0x2C70: `_map_find_continents` @0xB242 — two flood passes labelling continents 1..15 into the layer-3 low nibbles; >15 land regions → `@CONTINENTS1` popup, >15 water → `@CONTINENTS2`; then a full-screen continent-id view (Ocean/Sea-Lane blanked), any key restores |
| 0x4B | ~Map Tile Select | `_selection_screen` @0x2826 |
| 0x4C | ~Fill Mode Change | `_fill_radius` = (r+1)%3 @0x3104 |
| 0x4D | Coastline Protect | toggle `_coastline_protect` |
| 0x4E | ~Undo Last Change | `_perform_undo` @0x3128 |
| 0x51–0x54 | Help rows 1–4 | `@popup_box("HELP1".."HELP4")` @0x3140–@0x3164 |
| 0x5F | "How To Use Maps" row | `@popup_box("ABOUT")` @0x3170 — shipped off-by-one, §28.9 |
| 0x21, 0x6A | *(no menu row)* | `_set_view_mode` / `_memory_check` @0x30BA/@0x317C — dead, nothing emits these ids |

**Popup/dialog engine** (`popup.obj`, segment 0x33D). `_popup_create`
@0x50AE: frame inset 3; bevel borders from the `@COLORS` border0/1/2
palette indices (outer ring + inset−1 rect in border0, top/left in the
border-down colour, bottom/right in border-up, @0x6CB3–0x6DA1); wood
(WOODTILE) interior; FONTINTR text, switched to FONTTINY by a `@SMALLFONT`
directive. Minimum width 0x50; auto-centre x=160−w/2, y=100−h/2, clamped to
320×200; item rows fontH+3, entry rows fontH+8. The section parser
`@popup_start_box` @0x7C82 is a small state machine: a blank line separates
the text block from the option block; `^^` = centred line, `^` = raw line,
plain lines word-wrap; `{…}` = hilite span, `|` truncates; option items get
ids 1..n in read order; directives `@OPTIONS/@PROMPT/@TEXT/@SMALLFONT/@X=/
@Y=/@WIDTH/@LENGTH/@CHECKBOX/@DEFAULT` are parsed (none is used by the 19
MAPEDIT.TXT sections). Substitutions: `%STRINGn` (DS:0x634E+64n, set by
`_popup_say_string`), `%NUMBERn`, `%HEXn`, `%%`. The event loop
`@popup_exec` @0x6F5E: Up/Down move (skip greyed, wrap), Enter/Space select
→ popup word 0 = item id, **ESC → 0xFFFF**, hotkey match, mouse rows with
release-select; entry mode appends printable chars to maxlen, accepts on
Enter into `_popup_text_buffer` DS:0x4B64. `@popup_ask_number` has zero
callers (dead), as do `_menu_read_colors` ("MENUCOLR.SS") and
`_popup_read_colors` ("TEXTCOLR"). HELP1–4/ABOUT are plain text popups (no
buttons, no scrolling; a popup taller than 200 px aborts with error 0xFFAF).

**Keyboard accelerators** (`_human_interface_loop` @0x3724; keys upcased,
tried in order): (1) bar hotkeys E/V/M/H open the dropdowns
(`@menu_bar_key_parse` @0x97C2); (2) global item accelerators
(`@menu_key_parse` @0x9856, firing without opening a menu): S=Save,
A=Save As, L=Load, Z/X=zoom in/out, F1–F4=zoom levels, C=Center,
M=Tile Select, F=Fill Mode, P=Coastline Protect, O=Find Continents, U=Undo;
(3) `_parse_main_keys` @0x33B6: ESC/Ctrl-Q/Ctrl-X/Alt-Q/Alt-X → exit flow,
Space/Enter paint, Backspace pick-up, numpad/arrows move. `_shift_key`
(BIOS 0x417 & 3) gates paint-vs-move on mouse strokes.

### 28.9 The five shipped bugs

All five are byte-verified in the shipped binary:

1. **"Memor~y check" never appears.** The `@CUP` (Map) menu section has 6
   item rows but the construction code issues only 5 `_text_get` reads —
   the last row is never read, and its handler id 0x6A is dead. (The
   handler itself, `_memory_check` @0x2BCC, would show a popup from the
   file "DEBUG", section `@MEMORY`.)
2. **Help off-by-one.** `@HELP` has 6 rows but 5 reads, assigned ids 0x51,
   0x52, 0x53, 0x54, 0x5F. The row labelled **"How To Use Maps" therefore
   fires id 0x5F, which opens the `@ABOUT` popup**; the "About Map Editor"
   row is never read and the `@HELP5` section is unreachable.
3. **Dead `@XS`/`@YS`.** No referencing string for either section exists
   anywhere in the EXE — the map size is hard-coded 58×72; the size-entry
   dialogs the text file provides for were never wired up.
4. **Dead command ids 0x21 and 0x6A.** Both have live handlers in the
   dispatch jump table (`_set_view_mode`, `_memory_check`) but no menu row
   or key ever emits them.
5. **Load→save is not byte-preserving.** `_forest_fix` runs on every load,
   folding forest alias ids 16..23 to 8..15 and stripping forest under
   mountain/hill overlays — so round-tripping a file that contains ids
   16..23 (AMER2.MP does) rewrites those bytes. (The main game performs the
   same fold in its own loader, so the meaning is unchanged.)

### 28.10 Renderer frame map and engine parity

The editor's tile renderer (helper @0xC3A2) is the same compositor scheme
as the game's: ground from the 12-tile TERRAIN.SS array, PHYS0.SS overlays
on top, BDARK.SS never referenced. Ground selection (`_tile_id` @0x46CE):
ids 0..7 → frames 0..7; ids 9 and 0x11 → frame 8 (Scrub); 0x18/0x19/0x1A →
frames 9/10/11 (Arctic/Ocean/Sea Lane). Frame constants below are **engine
frame numbers, 1-based over the disk descriptors** (disk sprite = engine
frame − 1):

| overlay | engine frames | rule |
|---------|---------------|------|
| forest | 0x41+mask | mask = N8\|S4\|W2\|E1 over neighbouring forests |
| mountains | 0x21+mask | neighbours connect only when `byte&0xA0` is equal |
| hills | 0x31+mask | same adjacency rule |
| major river | 0x01..0x10 | 4-neighbour mask; isolated → mask 0xF |
| minor river | 0x11..0x20 | same |
| river mouths | 0x8D+dir / 0x91+dir | on water tiles adjoining a land river |
| unexplored | 0x95 | |
| straight coasts | 0x97..0x9A (disk 150–153) | by edge class |
| beach-halo quadrants | 0x6D+quad+4·code | 8×8 sub-tiles at 8×8 sub-offsets |
| scale-0 extras | 0x5A+idx resources, 0x68 lost city, 0x51/0x52+dir roads | inert on fresh maps (feature layer empty) |

Engine frame 0x96 (disk 149), the feature-bit wave/hatch overlay, is
present but dormant in the editor (@0xC550). The identity of these
constants with VICEROY's in-game map renderer — same coast adder at
VICEROY file 0x06850D, same halo adder at 0x0684E8 — plus the
instruction-identical menu clamps of §28.8, make MAPEDIT a second,
independently shipped witness to the game's rendering rules.

## 29. Verification

Everything in this manual was established by three mutually checking
methods against the shipped 1994 binaries and data files: static
disassembly with byte-level citation, live memory reads of the running game
under emulation, and pixel-level render-and-diff in which whole screens
were rebuilt purely from the documented facts and compared against
captures of the real game. This section records what each method
contributed and — just as importantly — what remains unproven.

### 29.1 Static disassembly

The primary evidence layer is the disassembly of VICEROY.EXE (an RTLink
overlaid MZ executable: resident segments plus 31 overlay pages reached
through thunk tables), MAPEDIT.EXE (with its CodeView symbols, §28.1), and
the OPENING/CLOSING cinematic executables. Every load-bearing number in
this manual is cited to a file offset in one of these binaries, to a field
of the NAMES.TXT/GAME.TXT-family data files, or to a recorded ruling; where
a value is computed at runtime it is marked as such rather than guessed.
Cross-checks internal to this layer repeatedly caught errors: for example,
the sprite-frame numbering convention (engine frame = disk descriptor + 1)
was proven from descriptor counts — TERRAIN.SS holds exactly 12 disk
descriptors while the engine loads "frames 1..12", and PHYS0.SS holds 154
(disk 0..153) while engine code references frame 154 — with no subtraction
anywhere in the draw verb (the offset lives in the in-memory record layout,
appendix A).

### 29.2 Live-RAM reads under emulation

The running game (DOSBox 0.74-3) is the top of the evidence order. Memory
snapshots were taken at known moments and the game's data segment located
by **DGROUP anchoring**: scanning the dump for known DGROUP string
constants (e.g. "WOODPANL" at DS:0x2189) pins the physical base (0x1CFD0
in the verification sessions), after which every documented DGROUP offset
can be read directly. This validated record layouts end-to-end (the active
colony pointer `[0x8542]` → bytes `33 1D "Jamestown"` = (51,29) exactly as
the ColonyRecord head specifies), exposed state the disassembly could not
decide (the debug bitfield `[0x894]` defaults to 8, not 0; the boot text
ink latch `[0x1F4E]` reads 0xFC at the boot menu and 0x95 in-game), and
killed a systematically wrong oracle: the word `[0x2F5E]` = 537 had been
dereferenced as a string pointer yielding "Sons of Liberty"; the live table
walk showed it is an integer **string id** (slot 210 of a 221-entry id
table, resolving to "Exit") — consistent with the pixel evidence in both
screens where the wrong reading had propagated.

### 29.3 Render-and-diff

Twelve-plus screens were rebuilt from scratch using only the documented
facts (geometry, fonts, palette indices, sprite frames, formulas) and
diffed pixel-by-pixel against captures of the running game (pixel-verified
against the running game, 1994 binary under DOSBox):

| screen | rebuilt-vs-live result |
|--------|------------------------|
| difficulty select | 99.96% identical |
| nation select | 99.86% identical |
| boot (main) menu | 98.7% identical; four documented claims falsified and corrected in the process |
| leader-name entry | pixel-identical (residual: the mouse cursor) |
| King audience | pixel-identical (residual: the mouse cursor) |
| Europe screen, idle state | **100.00%** outside declared dynamic-sprite masks |
| Europe screen, ship-arriving state | **100.00%** |
| colony screen | structurally exact: every element matched or produced a recorded correction; **all 15 building plots pixel-exact from an exact replay of the placement RNG chain** (16-bit seed → LCG → 15-group category shuffle → frame select) |
| map view (ocean window) | **100.0000%** — 45,056/45,056 non-overlay pixels |
| land window (Jamestown region) | **100.0000%** of 41,540 non-overlay pixels |
| crafted-test-map windows (5 viewports over a purpose-built 58×72 map exercising hills, mountains, rivers, mouths, lakes, forest aliases) | **100.0000%** non-overlay in all five (raw including live-object overlays: 95.15–98.00%) |

The method is deliberately adversarial: a mismatch is treated as a
falsifier of the documentation, not of the capture. It refuted, among
others, a claimed sprite-blit chain on the boot menu (actually a
palette-index find-and-replace, a no-op on that background), transposed
width/height argument labels on the frontend cell grids, a wrong market-bar
y, and the "Sons of Liberty" string described above; and it discovered
mechanisms no static read had found — the beach-halo **ground
substitution** (a coastal water tile is grounded with its last cardinal
land neighbour's terrain, coast frames drawn over it, and water backfilled
through the frames' zero-holes) and the colony scene panel's deterministic
×1.5 dithered upscale of the shared 16-px map compositor.

Non-overlay means: engine object sprites (units, villages, the view
cursor, a ≤2-px sprite overhang) are masked from the diff, since they are
game objects, not tile-compositor output; every masked region is declared.

### 29.4 Capture pipeline

Comparisons must model the capture chain or they fail for the wrong
reasons. Three facts matter: (1) the captures are **2× frames** — each
native pixel is a 2×2 block, recovered by sampling every second row and
column; (2) the emulator framebuffer is **RGB565**: the 6-bit VGA palette
entry is expanded `(v<<2)|(v>>4)` and then floored to 5/6/5 bits, and the
renderer must apply the same quantisation before diffing; (3) **palette
cycling**: the sea-lane sparkle is a VGA palette rotation over indices
120–127, so each capture's cycle phase (0..7) is fitted before the diff,
and the Europe harbour water indices 54–60 are likewise pure palette
animation with zero pixel-index changes. None of these steps touches the
documented render rules; they model only the measurement instrument.

### 29.5 What remains unexercised or unmapped

Stated honestly, in the open:

- **Shore-hatch 0x96, roads, and the feature-resource bit have byte-cited
  draw gates but no pixel test.** The game's `.MP` loader discards layer 2
  (features) entirely and rebuilds the plane at runtime, so no crafted map
  can exercise them; the draw sites (land/water shore gates at VICEROY file
  0x6834F/0x68354, the road walker with its per-direction frames 0x52+d)
  are decoded from the disassembly only. Exercising them needs an organic
  in-game state with pioneer-built roads. (Hills, rivers, river mouths,
  lake coasts, forest aliases, fog blends — all previously on this list —
  are now live-confirmed by the crafted-map and land-window tests.)
- **AIPersonality tail bytes** +0x30/+0x32/+0x33 are unlabelled.
- **ColonyRecord** retains unmapped runs; two locations (+0x24, +0x99)
  have provably **no static accessor** in the entire EXE and read zero in
  live dumps.
- The boot-time writer of **`[0x8D80]`** (a session-constant term mixed
  into the colony building-placement seed; live values 0x2C55, 0x5B7C in
  two sessions) is unlocated.
- **`func_003E40`** — the map unit-marker sprite mapping drawn into the
  colony scene panel — is undecoded.
- The live value of **`[0x890]`** on the colony screen (it gates the
  marker name/population text inside the scene panel) has not been read.

## A. Appendix — data structures

This appendix collects every record layout established for the shipped
binaries, as C structs with byte offsets. Only fields actually mapped are
named; gaps are declared. Unless noted, addresses are DGROUP-relative in
VICEROY.EXE; per-field citations are the decisive read/write sites.
"(runtime-verified)" marks fields whose meaning rests on live-memory
observation of the running game rather than a static code citation.

### A.1 UnitRecord — 0x1C bytes, base DGROUP:0x3144, 300 slots

```c
typedef struct {                 // base 0x3144, stride 0x1C
    uint8_t  map_x;              // +0x00 drawn position (renderer @0x03A63, placer @0x06958)
    uint8_t  map_y;              // +0x01
    uint8_t  unit_type;          // +0x02 NAMES @UNIT row 0..23 (dispatcher @0x51D6B; 694 refs)
    uint8_t  owner_flags;        // +0x03 low nibble = power 0..11, high nibble = state (setter @0x738E)
    uint8_t  scratch_bits;       // +0x04 per-pass flag register: 0x08 tile-dirty (@0x0481B0), 0x80 draw/AI marker (@0x069923), 0x20 Merchantman tag (@0x04CE44), 0x10 path>=8 hops (@0x05106E), 0x02 was-fortifying (@0x04CEC9), 0x04 ship-cargo class (@0x04CDDC)
    uint8_t  moves_spent;        // +0x05 AI move-credits spent this turn (reset @0x005872; +3/step @0x05CAE2; gate @0x03EE95)
    uint8_t  countdown;          // +0x06 timer, init 0xFF, dec (@0x2EF17)
    uint8_t  ai_state;           // +0x07 persistent AI state letter ('X','0','1','G','E','R','V',...; init @0x06D84)
    uint8_t  order;              // +0x08 order code 0..0x0C = NAMES @ORDERS row (dispatch @0x249CB)
    uint8_t  goto_x;             // +0x09 goto / trade-route next-stop target (writer @0x22D38)
    uint8_t  goto_y;             // +0x0A
    uint8_t  heading;            // +0x0B facing 0..7, 8 = none (xor-4 reverse @0x047AA8; bound @0x0516F0)
    uint8_t  cargo_count;        // +0x0C goods in hold (@0x0B2AB)
    uint8_t  cargo_ids[3];       // +0x0D nibble-packed good ids, up to 6 (@0x0B2CB)
    uint8_t  cargo_qty[2];       // +0x10 per-slot quantities (@0x0B2FB)
    uint16_t timer;              // +0x12 overloaded: AI/native = snapshot of [0x538E] (@0x06DB3); player = byte 0xFF then rand 0..0x13 (@0x06DA3/@0x50C75)
    uint8_t  moved_flag;         // +0x14 per-turn land-unit boolean; read only for Wagon Trains (@0x04968D/@0x04F730/@0x0507E1; exact label runtime-open)
    uint8_t  tools;              // +0x15 pioneer tools 0..100, -20/action (@0x4060F)
    uint8_t  work_counter;       // +0x16 turns in clear/road/fortify activity (@0x04071D)
    uint8_t  class_prof;         // +0x17 colonist profession 0x13..0x1C; on route units: low nibble = route id, high = stop idx (@0x5B60E / @0x0075D4)
    uint16_t occ_back;           // +0x18 per-tile occupancy list back link (@0x06976)
    uint16_t occ_next;           // +0x1A next link (@0x06968)
} UnitRecord;                    // fully mapped
```

### A.2 ColonyRecord — 0xCA bytes, array head DGROUP:0x5D46, ~50 slots

Reached via the active-colony far pointer `[0x8542]` (0 at boot, real after
founding; slot free when the name at +0x02 is empty; slots are recycled).

```c
typedef struct {                 // stride 0xCA; serialized to save-games
    uint8_t  map_x;              // +0x00
    uint8_t  map_y;              // +0x01
    char     name[24];           // +0x02 NUL-terminated
    uint8_t  owner_power;        // +0x1A 0..3 (colony-burn trace)
    uint8_t  foreign_status;     // +0x1B (runtime-verified; semantics open)
    uint8_t  status_flags;       // +0x1C per-colony status byte
    uint8_t  flags_1d;           // +0x1D bit 0x80 only (test @0x551D8, set @0x55C20, clear @0x55A2F)
    uint8_t  countdown_1e;       // +0x1E gated by +0x8E (@0x4D9C7, 14 sites)
    uint8_t  population;         // +0x1F size (burn-loot formula @0x05DE1E)
    uint16_t flags_20;           // +0x20 (runtime-verified; foreign-marker byte at low half)
    uint16_t state_22;           // +0x22 packed state (runtime-verified)
    uint16_t unused_24;          // +0x24 NO static accessor exists; 0 in live dumps
    // +0x26..+0x3F unmapped (26 bytes)
    uint8_t  job_skills[32];     // +0x40 1 byte per colonist, live length = population (runtime-verified); declared span to +0x5F
    uint8_t  bldg_mask_60[6];    // +0x60 buildings-constructed bitmask (runtime-verified observation)
    // +0x66..+0x6F unmapped (10 bytes)
    uint8_t  tile_workers[8];    // +0x70 colonist idx per surrounding tile, NW..SE, 0xFF empty (runtime-verified)
    // +0x78..+0x83 unmapped (12 bytes)
    uint8_t  constructed_mask;   // +0x84 building mask (static accessor cite)
    // +0x85..+0x8D unmapped (9 bytes)
    uint8_t  gate_8e;            // +0x8E gates the +0x1E countdown
    // +0x8F..+0x91 unmapped (3 bytes)
    uint8_t  hammers;            // +0x92 build progress (paired with +0xB6)
    // +0x93..+0x94 unmapped (2 bytes)
    uint8_t  warehouse_level;    // +0x95
    uint8_t  counter_96;         // +0x96 inc/dec counter (@0x2C244/@0x5C474)
    // +0x97..+0x98 unmapped (2 bytes)
    uint8_t  unused_99;          // +0x99 NO static accessor; 0 in live dumps
    uint16_t stockpile[16];      // +0x9A per-good cargo, NAMES @CARGO order (runtime-verified against the in-game bar)
    uint16_t hammers_b6;         // +0xB6 build-progress pair of +0x92
    // +0xB8..+0xB9 unmapped (2 bytes)
    uint8_t  power_flag[4];      // +0xBA per-power byte flags, init 1 in the colony-reset loop (@0x2ED7A)
    uint8_t  power_flag2[4];     // +0xBE paired array, init 0 (@0x2ED7F)
    int32_t  rebel_dividend;     // +0xC2 Sons-of-Liberty numerator (runtime-verified)
    int32_t  rebel_divisor;      // +0xC6 denominator; SoL% = dividend/divisor
} ColonyRecord;
```

### A.3 RouteRecord (0x4A) and StopRecord (0x0A) — trade routes

Routes live in their own segment 0x1B22, base offset 0, max 12
(`select_route` = `func_05FE60`; count `[0x53A0]`, cap @0x610B5; delete
shifts 0x4A bytes @0x605DB).

```c
typedef struct {
    uint16_t destination;        // +0x00 colony id (record = id*0xCA + 0x5D46), 0x3E7 = Europe, 0x3E8 = none (@0x05FEE1)
    uint8_t  counts;             // +0x02 low nibble = UNLOAD count (lanes +0x06..), high = LOAD count (lanes +0x03..) (@0x060382)
    uint8_t  goods[7];           // +0x03 nibble-packed good ids, 2 per byte: +0x03..+0x05 load lanes, +0x06..+0x08 unload lanes (@0x603DA)
} StopRecord;                    // 0x0A bytes

typedef struct {
    char       name[32];         // +0x00 route name (memcpy @0x61273; uniqueness strcmp @0x611FF)
    uint8_t    type;             // +0x20 0 = sea, 1 = land (@0x61282)
    uint8_t    cursor;           // +0x21 current-stop cursor (init 2 @0x61286; inc @0x60C7A)
    StopRecord stops[4];         // +0x22 up to 4 stops (set_stop_ptr @0x05FE7A)
} RouteRecord;                   // 0x4A bytes; unit binding = UnitRecord +0x17 nibbles
```

### A.4 PowerRecord — 0x13C bytes, base DGROUP:0x8808, 12 entries

Entries 0..3 are the European powers, 4..11 the native tribes. (Earlier
field cites off a base of 0x8809 are the same bytes: that table's +0x21
gold / +0x25 loot / +0x29 treasury are +0x22/+0x26/+0x2A here.)

```c
typedef struct {                 // stride 0x13C
    uint8_t  treasure_pool;      // +0x00 (SMITE multiplier trace)
    uint8_t  tax_pct;            // +0x01 0..100 (@0x034AE0 chain)
    uint8_t  rebel_sentiment;    // +0x02 0..100 (runtime-verified vs display)
    // +0x03..+0x06 unmapped (4 bytes; +0x06 = attribute-bitfield start)
    uint32_t ff_bitmask;         // +0x07 acquired Founding Fathers, bit = FF idx (reader func_00BC10 @0x00BC10)
    // +0x0B unmapped (1 byte)
    uint16_t bells_next_ff;      // +0x0C bells toward next FF, resets on acquisition (runtime-verified)
    uint16_t bells_per_turn;     // +0x0E
    uint16_t crosses_per_turn;   // +0x10
    // +0x12..+0x13 unmapped (2 bytes)
    uint16_t ff_count;           // +0x14
    // +0x16..+0x1D unmapped (8 bytes)
    uint16_t artillery_bought;   // +0x1E Europe artillery escalation counter (read x100 @0x035124; inc @0x035282; zeroed @0x03662F)
    uint16_t boycott_bits;       // +0x20 bit i = good i boycotted (runtime-verified)
    int32_t  royal_money;        // +0x22 King's REF budget (runtime-verified: +18/turn at Discoverer)
    int32_t  unknown_26;         // +0x26
    uint32_t gold;               // +0x2A treasury (write-back updates UI)
    // +0x2E..+0x31 unmapped (4 bytes)
    uint8_t  home_x;             // +0x32 spawn/relocation x (REF growth chain)
    uint8_t  home_y;             // +0x33
    uint8_t  relations[4];       // +0x34 4x4 relation matrix row (DG 0x883C, row stride 0x13C; get func_007F34, symmetric set func_007F96):
                                 //       bits: 0x02 war, 0x08 grievance-pending, 0x10 parley cooldown, 0x20 met, 0x40 peace treaty, 0x80 privateer-hidden
    // +0x38..+0x3F unmapped (8 bytes)
    uint8_t  treaty_respect;     // +0x40 counter, seed 2*(6-difficulty), halved w/ Franklin (@0x059B00; AI attack-abort @0x03F163; decrement site unlocated)
    // +0x41..+0x43 unmapped (3 bytes)
    uint8_t  ref_bytes[3];       // +0x44 disputed: one runtime dump write-verified as REF dragoons/regulars/artillery, another found it stale; the King's code reads the globals 0x53DA..0x53E1 instead
    // +0x47..+0x4B unmapped (5 bytes)
    uint8_t  mkt_sensitivity[16];// +0x4C per good (measured; not byte-cited)
    int16_t  mkt_pool[16];       // +0x5C (measured; not byte-cited)
    int32_t  mkt_traded[16];     // +0x7C (measured; not byte-cited)
    int32_t  mkt_eu_supply[16];  // +0xBC (measured; not byte-cited)
    int32_t  mkt_base[16];       // +0xFC (measured; not byte-cited)
} PowerRecord;                   // ends exactly at +0x13C
```

### A.5 AIPersonality — 0x34 bytes, base DGROUP:0x540E, 4 entries

European powers only (tribes use TribeData instead). Leader/region name
pointers used by the diplomacy text filler are `0x540E + p·0x34` and
`0x5426 + p·0x34`.

```c
typedef struct {                 // stride 0x34
    char    leader_name[24];     // +0x00 e.g. "Walter Raleigh" (runtime-verified; NAMES @LEADERNAME)
    char    country_name[24];    // +0x18 e.g. "New England"
    uint8_t unknown_30;          // +0x30 (English = 0xC0; unlabelled)
    uint8_t is_active;           // +0x31
    uint8_t unknown_32;          // +0x32
    uint8_t unknown_33;          // +0x33
} AIPersonality;
```

### A.6 TribeData — 0x4E bytes, base DGROUP:0x5AD6, 8 entries

Selected by `set_active_tribe` (`func_0081C6`): `[0x8D4E] = 0x5AD6 +
tribe_idx·0x4E`.

```c
typedef struct {                 // stride 0x4E
    // +0x00..+0x01 unmapped (2 bytes)
    uint8_t settlement_size_factor; // +0x02 raze-formula multiplier (@0x04AB24 trace)
    // +0x03..+0x4D unmapped (75 bytes)
} TribeData;
```

### A.7 NativeSettlement — 0x12 bytes, base DGROUP:0x54EC, ≥60 slots

The table is compacted on raze; walk from index 0 until an (0,0) coordinate
pair.

```c
typedef struct {                 // stride 0x12
    uint8_t map_x;               // +0x00
    uint8_t map_y;               // +0x01
    uint8_t owner_power;         // +0x02 4..11
    uint8_t flags;               // +0x03 0x02 taught, 0x04 mission/capital, 0x08 visited, 0x40 event
    uint8_t population;          // +0x04 CHIEFKILL size byte (user-verified raze payout)
    uint8_t mission;             // +0x05 0xFF none, else 0x10 | power 0..3 (user-verified)
    int8_t  growth_counter;      // +0x06 +population per turn; spawns/grows at 20
    uint8_t sentinel;            // +0x07 always 0xFF
    uint8_t last_bought;         // +0x08 cargo idx of last good bought here
    uint8_t last_sold;           // +0x09
    struct { uint8_t friction, attacks; } alarm[4]; // +0x0A per European power
} NativeSettlement;              // fully mapped
```

### A.8 VICEROY dialog struct (the @-directive dialog framework)

Allocated per dialog; accessed as a far pointer (`les bx,[bp+4]` in the
finalizer `func_06D316`). Field cites are the construct/pump sites.

```c
typedef struct {
    uint16_t opt_count;          // +0x02 option-row count (appender func_06C850 @0x06CA2B)
    uint16_t text_count;         // +0x04 text-line count (appender func_06CA82 @0x06CB87)
    uint16_t third_count;        // +0x08 third item-class count (@0x06CD57)
    uint16_t flags;              // +0x0A 0x10 borderless, 0x40 off-screen, 0x20 sibling-attach; checkbox sets |=5
    int16_t  req_x, req_y;       // +0x0C/+0x0E from @x/@y; -1 = centre sentinel (@0x06F2A6/@0x06F25E)
    int16_t  x, y;               // +0x10/+0x12 final on-screen origin
    uint16_t w, h;               // +0x14/+0x16 box size
    uint16_t rect[4];            // +0x18 final absolute rect (@0x06D5B9)
    uint16_t longest_line_px;    // +0x20 (clamp @0x06D392)
    uint16_t pad;                // +0x22 = 4, option-row x-indent component (@0x06C5AC)
    uint16_t content_x;          // +0x24 (flags&0x10)?0:3; option rows at box_x+9 (@0x06D9D6)
    uint16_t row_y_seed;         // +0x26 = inset'(3)+border(3), bumped past the text block (@0x06D440)
    uint16_t width_floor;        // +0x28 init 0x50, @WIDTH override (@0x06CA7B)
    uint16_t text_x, text_y;     // +0x2A/+0x2C text-line origin seeds (lines at box_x+5)
    // +0x2E..+0x3B partially mapped (+0x32 = 4; +0x34 width term)
    uint16_t fill_color[2];      // +0x3C from [0x1F3C]/[0x1F3E] (= TEXTCOLR.SS sprite 1/2 pixel); value 7 = wood-tile fill sentinel
    uint16_t sel_color[2];       // +0x40 selection band from [0x1F40]/[0x1F42] (boot value 0x37)
    uint16_t ring2_color;        // +0x44 from [0x1F44]
    uint16_t border;             // +0x46 (flags&0x10)?0:3
    uint16_t inset;              // +0x48 (flags&0x10)?0:2
    uint16_t content_h_cursor;   // +0x4A summed as items append; H = 2*this + border
    // +0x4C..+0x53 unmapped (8 bytes)
    void far *opt_head;          // +0x54 option-row list (painter func_06D9CC)
    void far *text_head;         // +0x58 text-line list (painter func_06CFE8)
    void far *widget_head;       // +0x5C child/widget list (pump loop B @0x06E699)
    void far *prompt_head;       // +0x60 prompt/third-class list (painter func_06DC64)
    // +0x64..+0x67 unmapped (4 bytes)
    void far *submenu;           // +0x68 attached submenu; on widget nodes: the sprite far-ptr blitted (@0x06D952)
    // +0x6C..+0x73 unmapped (8 bytes)
    uint16_t ink_record[8];      // +0x74 built by func_06C296: +2 normal<-[0x1F4A], +4 disabled<-[0x1F4C], +6 hilite<-[0x1F4E], +8/+A aux, +C/+E font ptr
    // ({ and } in any string toggle the hilite latch [0x1F62])
    void far *font_key;          // +0x80 identity/font latch (@SMALLFONT stores the FONTTINY latch here @0x06F211)
} Dialog;                        // ~0x84+ bytes; trailing size unmapped

typedef struct {                 // one option row (appender @0x044DCE region)
    uint16_t flags;              // +0x00 bit 0 = text empty -> pump skips
    uint16_t scalar;             // +0x02 accelerator column or pixel width (callee untraced)
    uint16_t command_id;         // +0x04 id the row fires
    char far *text;              // +0x06
    // +0x0A..+0x0D reserved, never written (4 bytes)
    void far *next;              // +0x0E
} DialogRowNode;
```

### A.9 Menu-bar structs (VICEROY page-0x0A module = MAPEDIT menu.obj)

The in-game menu bar object lives at `[0x896]` (built by `func_072090`
@0x0720AC from MENU.TXT); MAPEDIT builds its bar from MAPMENU.TXT with the
same module (`_menu_bar` DS:0x78). All offsets byte-cited in the VICEROY
copy; the MAPEDIT node shapes match (result word +0, first menu +0x38,
first item +0x1E).

```c
typedef struct {                 // menubar (creator func_044836)
    uint16_t result_id;          // +0x00 selected command id (write @0x045895; 0 = none)
    uint16_t bar_y;              // +0x04 = 1
    uint16_t title_gap;          // +0x06 = 0x0C
    uint16_t item_leading;       // +0x08 = 3
    uint16_t title_x_pad;        // +0x0A = 1
    uint16_t bar_colors[2];      // +0x0E from [0x149C]/[0x149E]
    uint16_t hilite_colors[2];   // +0x1A from [0x14A8]/[0x14AA]
    uint8_t  title_font[12];     // +0x20 font descriptor (far string ptr at +0x28)
    uint8_t  item_font[12];      // +0x2C (far string ptr at +0x34)
    void far *first_menu;        // +0x38
} MenuBar;

typedef struct {                 // menu node, 0x22 bytes (alloc @0x044BD9)
    uint16_t x;                  // +0x02 = prev.x + prev.width + gap (first title x = 0x0C)
    uint16_t title_w;            // +0x04
    uint16_t panel_inner_w;      // +0x06 init 0x0A
    uint16_t hotkey;             // +0x08 title hotkey char
    uint16_t flags;              // +0x0C bit 0 = disabled
    char far *title;             // +0x0E
    void far *owner;             // +0x12 owning menubar
    void far *next;              // +0x16
    void far *prev;              // +0x1A
    void far *first_item;        // +0x1E
} MenuNode;

typedef struct {                 // item node
    uint16_t flags;              // +0x00 bit 0 disabled, bit 1 hidden
    uint16_t shortcut;           // +0x02
    uint16_t command_id;         // +0x04 (returned into menubar +0)
    char far *label;             // +0x06 empty first byte = separator
    void far *next;              // +0x0E
    void far *prev;              // +0x12
} MenuItemNode;
```

Dropdown layout (`func_044FA4`): panel x = menu.x; y = bar_y +
title-height + 3; w = panel_inner_w + 2; h = visible·(item_font_h +
leading) + leading + 2; clamps right ≤ 0x13D, bottom ≤ 0xC7 —
instruction-identical in both programs (§28.8).

### A.10 MAPEDIT terrain record and popup result

```c
typedef struct {                 // MAPEDIT _load_data terrain table, 29 records
    char   *name;                // +0x00 near ptr into the NAMES text pool
    uint8_t num_a, num_b, num_c; // +0x02..+0x04 NAMES numeric columns 1-3
    // +0x05..+0x06 unmapped (2 bytes)
    uint8_t nums[9];             // +0x07..+0x0F NAMES numeric columns 4-12 (column 13 never read)
} MapeditTerrainRec;             // 16 bytes

typedef struct {                 // MAPEDIT popup object (popup.obj)
    uint16_t result;             // +0x00 selected item id 1..n; 0xFFFF = ESC (@popup_exec @0x6F5E)
    // remainder unmapped (geometry/config words; constants in section 28.8)
} MapeditPopup;
```

### A.11 Sprite sheet in memory (.SS handle)

A loaded sheet handle carries a header, then **12-byte frame records at
+0x36**, indexed by the 1-based engine frame number: record =
`handle + 0x36 + 12·(frame−1)` (VICEROY draw verb `func_00E76A`; the
OPENING blit routine at its file 0x4520 uses the same layout).

```c
typedef struct {                 // per-frame record, stride 12
    // +0x00..+0x03 unmapped (4 bytes; pixel-data reference)
    int16_t  anchor_x;           // +0x04 = frame CENTRE x  (screen x = anchor_x - w/2)
    int16_t  anchor_y;           // +0x06 = frame BOTTOM y  (screen y = anchor_y - h + 1)
    uint16_t width;              // +0x08
    uint16_t height;             // +0x0A (y-extent)
} SSFrameRec;                    // sheet dims at handle +0x4A/+0x4C
```

The (centre-x, bottom-y) anchor semantics were proven twice independently
by pixel diff (the King-audience figure and throne-canopy banner land
exactly where `ax−⌊w/2⌋, ay−h+1` predicts). Pixel value 0xFD in a decoded
frame is transparent.

## B. Appendix — sprite sheets and palette

All numbers in this appendix were decoded directly from the shipped
MADSPACK 2.0 containers (header `"MADSPACK 2.0"`, section directory,
FAB-compressed sections; frames stored RLE with transparent index 0xFD) —
nothing is transcribed from secondary notes. The disc set contains **206
`.SS` sheets**. Frame numbering: **disk index = 0-based descriptor order;
engine frame = disk + 1** (the convention proven in §29.1). Roles are
stated only where the project established them; everything else is counted
but left unlabelled.

### B.1 TERRAIN.SS — 12 frames, all 16×16 (the base-ground sheet)

Loaded at boot and on map-enter; composited UNDER the PHYS0.SS overlays.
Frame = ground id per the loaders in both programs (VICEROY fold at file
0x6204; MAPEDIT `_tile_id` @0x46CE). MAPEDIT's mini-map colours sample
pixel (8,8) of each frame.

| disk | engine | size | ground |
|------|--------|------|--------|
| 0 | 1 | 16×16 | Tundra |
| 1 | 2 | 16×16 | Desert |
| 2 | 3 | 16×16 | Plains |
| 3 | 4 | 16×16 | Prairie |
| 4 | 5 | 16×16 | Grassland |
| 5 | 6 | 16×16 | Savannah |
| 6 | 7 | 16×16 | Marsh |
| 7 | 8 | 16×16 | Swamp |
| 8 | 9 | 16×16 | Scrub floor (ground for ids 9 and 0x11 — forested Desert) |
| 9 | 10 | 16×16 | Arctic |
| 10 | 11 | 16×16 | Ocean |
| 11 | 12 | 16×16 | Sea Lane |

### B.2 PHYS0.SS — 154 frames (terrain overlay sheet)

All frames 16×16 except the three 1×1 placeholders (disk 0, 16, 100 —
never drawn: river mask 0 is remapped to the isolated form 0xF) and the
8×8 beach-halo band (disk 108–139).

| disk band | engine | size | role |
|-----------|--------|------|------|
| 0 | 0x01 | 1×1 | placeholder (major-river mask 0, unreachable) |
| 1–15 | 0x02..0x10 | 16×16 | major rivers, 4-neighbour mask N8/S4/W2/E1; isolated = mask 0xF |
| 16 | 0x11 | 1×1 | placeholder (minor-river mask 0) |
| 17–31 | 0x12..0x20 | 16×16 | minor rivers (same masks; majors/minors interconnect via terrain bit 0x40) |
| 32–47 | 0x21..0x30 | 16×16 | mountains, mask over neighbours with equal `byte&0xA0` |
| 48–63 | 0x31..0x40 | 16×16 | hills (same adjacency; hills never connect to mountains) |
| 64–79 | 0x41..0x50 | 16×16 | forest, mask over neighbouring forests; desert scrub (id&7==1) never connects |
| 80–88 | 0x51..0x59 | 16×16 | roads: isolated = engine 0x51; else ONE frame per set 8-dir bit, engine 0x52+d |
| 89–99, 101–102 | 0x5A..0x67 | 16×16 | terrain-detail / prime-resource band (position hash + DTAB class; mountains draw ore/gold engine 0x66, hills rock engine 0x67) |
| 100 | 0x65 | 1×1 | placeholder inside the detail band |
| 103 | 0x68 | 16×16 | surf / lost-city-rumor circle (suppressed when the continent-plane owner nibble ≠ 0xF) |
| 104–107 | 0x69..0x6C | 16×16 | dither-blend stencils N,E,S,W (class-boundary and fog-edge blends) |
| 108–139 | 0x6D..0x8C | 8×8 | beach-halo quadrant sub-tiles, engine 0x6D+quad+4·code (code-0 frames disk 108–111 are all-zero punch-throughs) |
| 140–147 | 0x8D..0x94 | 16×16 | river mouths on water: base engine 0x8D (major) / 0x91 (minor) + cardinal direction |
| 148 | 0x95 | 16×16 | unexplored/fog tile |
| 149 | 0x96 | 16×16 | wave/hatch shore overlay (feature-layer bit 0x40; dormant in the standard game) |
| 150–153 | 0x97..0x9A | 16×16 | the four straight-coast shorelines, by edge class |

### B.3 ICONS.SS — 131 frames (HUD, goods, units, markers)

Mixed sizes; established bands (disk numbering, engine gloss):

| disk | engine | size | role |
|------|--------|------|------|
| 0–3 | 1..4 | 21×16 | colony map markers (drawn with the pennant on the map and colony scene) |
| 4 | 5 | 1×1 | placeholder |
| 5–7, 14–15, 127 | 6..8, 15..16, 0x80 | 13–14×16 | ship unit icons (@UNIT icon column; e.g. Privateer eng 15, Frigate eng 16, Man-O-War eng 128 = disk 127) |
| 18–21 | 0x13..0x16 | 16/8/4/2 px | map cursor set, engine 0x13+zoom (MAPEDIT blink cursor) |
| 22–37 | 0x17..0x26 | 6–13×12 | the 16 goods icons, @CARGO order (Europe market bar and colony stockpile bar, icon y=181) |
| 67–69 | 0x44..0x46 | 14×13 | button/flag plaques (colony flag panel = engine 0x44, frame = nation) |
| 81–108 | 0x52..0x6D | 6–14×16 | unit figure band; foot-unit icons disk 100–105 + 109 (Colonist eng 101 = disk 100, Soldier eng 103 = disk 102) |
| 118–121 | 0x77..0x7A | 6×5 | nation pennants, engine 0x77+power (colony markers) |
| 122 | 0x7B | 10×12 | cargo crate (Europe dock slots at (147+12·slot,165); colony dock boxes) |
| 124 | 0x7D | 13×11 | crown (colony Sons-of-Liberty/Tory band) |
| remainder | — | various | not yet role-assigned (incl. disk 38–66 second 12-px band, 70–80, 110–117, 123, 125–126, 128–130) |

### B.4 BUILDING.SS — 48 frames (colony buildings)

Drawn frame = **def + 1** in engine numbering, i.e. **disk frame = def
id**, named from NAMES.TXT `@BUILDING` (42 defs). Special cases at the
colony composer: def 0 with build-query 0 → engine 0x11 (disk 16); defs
0x0F/0x11 with garrison → engine 0x2F/0x30 (disk 46/47); empty plots draw
a per-category frame from the DS:0x260 table minus one. 1×1/2×2 entries
are placeholder descriptors.

| disk (=def) | size | building |
|------|------|----------|
| 0 | 73×18 | Stockade |
| 1 | 73×18 | Fort |
| 2 | 73×18 | Fortress |
| 3 | 44×22 | Armory |
| 4 | 44×22 | Magazine |
| 5 | 44×22 | Arsenal |
| 6 | 75×48 | Docks |
| 7 | 75×48 | Drydock |
| 8 | 75×48 | Shipyard |
| 9 | 53×37 | Town Hall |
| 10 | 1×1 | Town Hall (level 2 — placeholder art) |
| 11 | 1×1 | Town Hall (level 3 — placeholder art) |
| 12 | 44×22 | Schoolhouse |
| 13 | 44×22 | College |
| 14 | 44×22 | University |
| 15 | 44×22 | Warehouse |
| 16 | 73×18 | Warehouse Expansion (also the def-0 forced-stockade frame, engine 0x11) |
| 17 | 1×1 | Stable (placeholder art) |
| 18 | 23×27 | Custom House |
| 19 | 23×27 | Printing Press |
| 20 | 23×27 | Newspaper |
| 21 | 23×27 | Weaver's House |
| 22 | 23×27 | Weaver's Shop |

| disk (=def) | size | building |
|------|------|----------|
| 23 | 23×27 | Textile Mill |
| 24 | 23×27 | Tobacconist's House |
| 25 | 23×27 | Tobacconist's Shop |
| 26 | 23×27 | Cigar Factory |
| 27 | 23×27 | Rum Distiller's House |
| 28 | 23×27 | Rum Distillery |
| 29 | 23×27 | Rum Factory |
| 30 | 1×1 | Capitol (placeholder art) |
| 31 | 2×2 | Capitol Expansion (placeholder art) |
| 32 | 23×27 | Fur Trader's House |
| 33 | 23×27 | Fur Trading Post |
| 34 | 23×27 | Fur Factory |
| 35 | 44×22 | Carpenter's Shop |
| 36 | 44×22 | Lumber Mill |
| 37 | 53×37 | Church |
| 38 | 53×37 | Cathedral |
| 39 | 23×27 | Blacksmith's House |
| 40 | 23×27 | Blacksmith's Shop |
| 41 | 23×27 | Iron Works |
| 42 | 53×37 | (extra frame; empty-plot/category art) |
| 43 | 44×22 | (extra frame) |
| 44 | 23×27 | (extra frame) |
| 45 | 75×48 | (extra frame) |
| 46 | 44×22 | garrison variant (engine 0x2F) |
| 47 | 44×22 | garrison variant (engine 0x30) |

### B.5 Small chrome sheets

| sheet | frames | sizes | role |
|-------|--------|-------|------|
| WOODTILE.SS | 1 | 32×24 | the wood background tile — menu bars, dropdowns, popup interiors, colony composer fill (fill-colour-7 sentinel selects it) |
| WOODFRAM.SS | 1 | 274×170 | woodcut-screen frame, centred from its sheet header |
| NAMEPLAT.SS | 3 | 18×14, 16×14, 18×14 | woodcut caption strip at y=162: left cap + repeated mid tile + right cap, centred on x=160 |
| CURSOR.SS | 2 | 17×17 both | mouse pointer (2 frames) |
| OPENTILE.SS | 1 | 32×24 | boot-menu plaque fill tile (tiled, phase-anchored at the box origin) |
| PARCH.SS | 1 | 32×24 | parchment fill tile |

### B.6 Inventory of the remaining sheets (counts from decode)

| sheet(s) | frames each | frame sizes | role where established |
|----------|-------------|-------------|------------------------|
| BDARK.SS | 46 | 2×2 – 75×48 | **orphan — no load path in either EXE; never loaded** |
| CC-00 .. CC-24 (25 sheets) | 1 | 31×86 – 115×114 | the 25 Founding Father portraits (Continental Congress / FF pick) |
| CLOS-BEL / -FWK / -HAT / -LDY / -MAN / -MIL / -ROC | 21 / 66 / 22 / 21 / 14 / 20 / 22 | up to 204 px wide / 89 tall (CLOS-FWK) | closing-cinematic elements (CLOSING.EXE) |
| DEC-LOWA .. DEC-LOWZ (26) | 8 | 5–11 × 22 | Declaration of Independence lettering, lower case |
| DEC-UPPA .. DEC-UPPZ (26) | 11 | 8–19 × 22 | upper case |
| DEC-SQIG | 11 | 28×22 | lettering flourish |
| DUTCH1 / ENGLND1 / FRANCE1 / SPAIN1 | 1 | 172–178 × 120–122 | King-audience nation banner, variant 1 (ENGLND1 = throne-canopy banner drawn at (32,0)) |
| DUTCH2 / ENGLND2 / FRANCE2 / SPAIN2 | 1 | 170–176 × 128–133 | nation banner, variant 2 |
| IND0A0 .. IND7A3 (32 sheets) | 1 (IND2A0: 2) | 50×141 – 153×182 | native chief speaker portraits (tribe, pose; loader name-patches "IND0A0") |
| KING.SS | 1 | 79×161 | King speaker portrait |
| KING1.SS | 1 | 189×187 | King-audience foreground figure (king + dog), drawn at (0,12) over KINGLSS1.PIK |
| KING2.SS | 8 | 79×161 | King speaker frames |
| KINGLOSE.SS | 1 | 149×179 | king crying — player wins the war |
| KINGWIN.SS | 1 | 214×198 | king triumphant — player loses |
| MPSLOGO.SS / MPSNAME.SS | 16 / 29 | 155×119 / up to 302×26 | MicroProse logo + name (opening) |
| MSS0 .. MSS5 (6) | 1 | 60×68 – 149×95 | advisor portraits (speaker channel `[0x1F5E]` 0..5) |
| MYR0 .. MYR3 (4) | 1 | 67×68 – 96×93 | European rival leader portraits (conversation channel 3) |
| OPENLOGO | 1 | 276×50 | opening title logo |
| OPENBONK / OPENCRD1-3 / OPENFISH / OPENGUY / OPENMON1-3 / OPENSHIP / OPENSUN / OPENWND1-2 | 18 / 7,7,5 / 13 / 54 / 15,32,21 / 8 / 7 / 10,11 | various | opening-cinematic elements (OPENING.EXE anim table) |
| SCORE01 .. SCORE24 (24) | 1 | 140–142 × 97–99 | score-screen panels ("SCORE"+NN filename build) |
| WDCUT01 .. WDCUT13 (13) | 1 | 192 × 113/115 | woodcut event plates (no 00/14–16 files; captions 0/14–16 unshowable) |
| WIN.SS / WIN-FWRK.SS | 1 / 46 | 320×200 / up to 200×91 | victory backdrop + fireworks |

### B.7 VICEROY.PAL — the master palette

The file is 1,024 bytes: 768 bytes of 6-bit VGA RGB (256 × 3) plus 256
trailing unused bytes. Values below are 8-bit `RRGGBB` after the standard
expansion `(v<<2)|(v>>4)`. Screens whose `.PIK` backgrounds carry an
embedded palette (the frontend/cinematic plates) replace this palette
while shown; COLONY.PIK, for example, has none and renders on VICEROY.PAL.

| base | +0 .. +15 |
|------|-----------|
| 0 | 000000 0000AA 00AA00 00AAAA AA0000 AA4900 AA5500 AAAAAA 555555 5555FF 55FF55 55FFFF FF0000 FF7100 FFFF55 FFFFFF |
| 16 | FBFBFB F3F3F3 EBEBEB E3E3E3 DBDBDB D3D3D3 CBCBCB C3C3C3 BEBEBE B6B6B6 AEAEAE A6A6A6 9E9E9E 969696 8E8E8E 868686 |
| 32 | 828282 797979 717171 696969 616161 595959 515151 494949 454545 3C3C3C 343434 2C2C2C 242424 1C1C1C 141414 0C0C0C |
| 48 | DBEFFF C3DBF3 B2CBEB 9EBADF 8EAAD7 799ACF 698AC3 5D79BA 4D65AE 4159A6 34499E 283892 202C8A 181C7D 101075 08086D |
| 64 | D7E3AA B6CF86 96BA69 75A64D 559634 348220 1C6D10 045D04 BABA41 A6AA41 9A9E41 8A8E3C 79823C 697138 5D6534 515930 |
| 80 | CF9634 BE8630 B2792C A26928 965D20 86511C 79451C 6D3C18 CFB28E BAA27D AA926D 9A825D 867151 756145 655134 55452C |
| 96 | FFFFDB F7F3C7 F3E7B6 EBDBA2 E7CB92 DFB682 DBA675 D79265 FFFBEB F3EFDB EBE3CB E3DBBA DBCFAE D3C39E CBB692 C3AE86 |
| 112 | F30000 E30000 D30000 C30000 B20000 A20000 920000 860000 4D65AE 5169B2 4961A6 4159A2 384D9E 30459A 2C3C96 283892 |
| 128 | 794934 75492C 694530 713C1C 613C28 65381C 593424 5D3018 512C20 49281C 3C2018 FF55FF FF55FF FF55FF FF55FF FF55FF |
| 144 | FFFFBE FFFF8E FFF35D FFE32C E3C328 C7A220 A67D1C 8A5D14 000000 000000 000000 000000 000000 000000 000000 000000 |
| 160 | 000000 ×16 |
| 176 | 000000 ×16 |
| 192 | 000000 ×14, 0C0C0C (206), 000000 |
| 208 | 000000 ×16 |
| 224 | 000000 ×16 |
| 240 | 000000 ×12, FF55FF FF55FF FF55FF (252–254), CFCFCF (255) |

**Cycling bands** (VGA palette rotation; pixel indices never change):

- **54–60** — the harbour-water shimmer band inside the 48–63 blue ramp
  (pixel-verified pure palette animation on the Europe screen);
- **120–127** — the sea-lane sparkle band (rotated with an 8-step phase;
  fitted per capture in every map diff).

Index 0xFD (253) doubles as the RLE transparent sentinel inside `.SS`
frames; the tribe map-marker colours cited by the raze popup data are
palette entries here (Aztec 149 = C7A220, Inca 97 = F7F3C7).

---

