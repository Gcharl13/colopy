# EXE_MZ — DOS MZ executable header

Every shipped `.EXE` in `COLONIZE/` is a plain DOS MZ executable. None of
them are NE/PE/LE/LX (no extended header). Five of the six carry an
**overlay** appended after the image — see `formats/RTLINK.md`.

## Byte layout (28 bytes of fixed header + relocation table + image + overlay)

| Offset | Size | Field | Notes |
|------:|-----:|-------|-------|
| 0x00 | 2 | `e_signature` | ASCII `MZ` (0x5A4D LE). |
| 0x02 | 2 | `e_last_page` | Bytes used in the last 512-byte page. 0 → full page. |
| 0x04 | 2 | `e_pages` | Total 512-byte pages in the image (rounded up). |
| 0x06 | 2 | `e_relocs` | Number of entries in the relocation table. |
| 0x08 | 2 | `e_hdr_paragraphs` | Header size in 16-byte paragraphs (header + relocation table, padded). |
| 0x0A | 2 | `e_min_alloc` | Minimum extra paragraphs above the image. |
| 0x0C | 2 | `e_max_alloc` | Maximum extra paragraphs (DOS gives as much as available, capped here). |
| 0x0E | 2 | `e_ss` | Initial SS value, segment-relative. |
| 0x10 | 2 | `e_sp` | Initial SP value. |
| 0x12 | 2 | `e_checksum` | Word-sum checksum, often zero. |
| 0x14 | 2 | `e_ip` | Initial IP value. |
| 0x16 | 2 | `e_cs` | Initial CS value, segment-relative. |
| 0x18 | 2 | `e_reloc_table_offset` | File offset of the relocation table. Usually 0x1C or 0x1E. |
| 0x1A | 2 | `e_overlay_number` | 0 for the main module. (None of these EXEs use this — they use post-image overlays instead, see RTLINK.md.) |

## Derived quantities

```
image_bytes  = e_pages * 512 - (512 - e_last_page  if e_last_page != 0 else 0)
header_bytes = e_hdr_paragraphs * 16
code_data_bytes = image_bytes - header_bytes      ; the bytes Capstone disassembles
overlay_offset  = image_bytes                     ; where the overlay starts in the file
overlay_bytes   = file_size - image_bytes
load_image      = file_bytes[header_bytes : image_bytes]
overlay_data    = file_bytes[image_bytes : end]
```

## The six COLONIZE/ executables

Values measured from `raw/COLONIZE/`:

| EXE          | File   | Image  | Header | Code+Data | Overlay  | CS:IP        | Relocs |
|--------------|-------:|-------:|-------:|----------:|---------:|--------------|-------:|
| VICEROY.EXE  | 494,910 | 132,709 | 9,216 |   123,493 |  362,201 | 110D:071D    |  2,260 |
| MAPEDIT.EXE  | 145,292 | 114,185 | 5,632 |   108,553 |   31,107 | 1388:001E    |  1,365 |
| OPENING.EXE  |  89,178 |  67,271 | 3,072 |    64,199 |   21,907 | 0452:015C    |    664 |
| CLOSING.EXE  |  83,246 |  62,769 | 2,560 |    60,209 |   20,477 | 037D:0150    |    595 |
| MPSCOPY.EXE  |  38,620 |   4,986 |   512 |     4,474 |   33,634 | 0000:0031    |      0 |
| INSTALL.EXE  |  51,285 |  51,285 |    32 |    51,253 |        0 | 0C35:000E    |      0 |

Observations:

- **All six are CS_MODE_16** (real-mode 16-bit). Disassemble with capstone
  `CS_ARCH_X86 + CS_MODE_16`.
- **Five of six carry an overlay** appended after the image. INSTALL.EXE
  does not (image == file size). MPSCOPY.EXE is *almost entirely* overlay
  (~87% of bytes). VICEROY.EXE is 73% overlay — that's where the bulk of
  the game logic lives.
- The `e_overlay_number` field is 0 in all six. The overlay system in use
  is **not** the original DOS overlay mechanism (DOS `EXEC` with overlay
  number); it is RTLink Plus (Pocket Soft / RTL Systems), which uses an
  appended overlay section with its own runtime loader inside the load
  image. See `formats/RTLINK.md`.

## Relocation table

The relocation table starts at file offset `e_reloc_table_offset` and
contains `e_relocs` 4-byte entries. Each entry is a `(offset, segment)`
pair (LE16, LE16) pointing into the load image. At load time DOS adds the
load segment to the word at `image[offset + segment*16]`. The disassembler
must apply these fix-ups when computing absolute addresses for far calls
and far data references.

INSTALL.EXE and MPSCOPY.EXE have **zero** relocations — they are
position-independent or fully self-contained in a single segment.

## How `tools/disasm_mz.py` consumes this

1. Open the EXE file, parse the 28-byte fixed header per the table above.
2. Read the relocation table (skip if `e_relocs` is 0).
3. Slice out the load image (`file_bytes[header_bytes : image_bytes]`).
4. Slice out the overlay (`file_bytes[image_bytes :]`) if non-empty.
5. Apply relocations: for each `(off, seg)`, the LE16 word at
   `image[off + seg*16]` is a *segment value to be patched at load time*
   — for static disassembly we do NOT patch, but we record each location
   so the listing can flag those bytes as "relocation target" rather
   than ordinary code.
6. Run capstone over the load image starting at the `CS:IP` pair.
7. Run capstone over the overlay separately (post-image is not contiguous
   with the load image; the overlay loader maps overlay segments at
   different runtime addresses — see `formats/RTLINK.md`).
