# VICEROY File Format Specifications

Complete byte-level format specs for every file type in `COLONIZE/`.
Each format spec carries `@asm` and `@evidence` citations pointing to
either VICEROY.EXE disassembly or to the Python loader/decoder in
`colonize_sdl/engine/` that has been verified byte-perfect.

## Format inventory (319 total files in COLONIZE/)

| Format | Count | Spec file       | Decoder loader      | Status     |
|--------|-------|-----------------|--------------------|-----------|
| MZ-EXE | 6     | `EXE_MZ.md`     | DOS loader         | DONE      |
| RTLink | 1 (in VICEROY.EXE) | `RTLINK.md` | `src/overlay/rtlink.c` | PARTIAL |
| PAL    | 1     | `PAL.md`        | overlay loader      | DONE      |
| SS     | 206   | `SS.md`         | MS_SPRITE format    | DONE      |
| PIK    | 35    | `PIK.md`        | CVPC + MS_SPRITE    | DONE      |
| FF     | 5     | `FF.md`         | font loader         | DONE      |
| MP     | 3     | `MP.md`         | map loader          | DONE      |
| TXT    | 18    | `TXT.md`        | section parser      | DONE      |
| DAT    | 3     | `DAT.md`        | binary table loader | DONE      |
| COL    | 5     | `COL.md`        | sound-driver loader | PARTIAL   |
| BIN    | 1     | `BIN.md`        | sample-bank loader  | PARTIAL   |
| MOV    | 1     | `MOV.md`        | movie player        | PARTIAL   |
| PCX    | 2     | `PCX.md`        | standard ZSoft PCX  | DONE      |
| GIF    | 1     | `GIF.md`        | standard CompuServe | DONE      |
| MADSPACK | 0 (compression wrapper) | `MADSPACK.md` | madsdev pack_*.c | DONE |

Total file types covered: **15** (covering all 319 COLONIZE/ files).

## Format-spec convention

Every spec file follows the template:

```
# <FORMAT>.md

## Magic / signature
<Bytes that identify this format>

## Header layout
| Offset | Type   | Field        | Meaning |
|--------|--------|--------------|---------|
| 0      | byte[N]| magic        | "..."   |
| ...    | ...    | ...          | ...     |

## Body layout
<...detail...>

## Citations
- @asm <file_offset>..<file_offset>  -- the loader function
- @asm_file ../code/VICEROY/disasm/func_<6hex>_<name>.asm
- @python  ../../colonize_sdl/<module>.py  (verified byte-perfect)
- @verified Decode + re-encode round-trip is byte-equal to the original.
```

When a format hasn't been fully decoded, the spec says so explicitly (in
`@status: PARTIAL`) and lists the specific bytes that remain unknown.

## Cross-reference

Every loader function in `viceroy_source/src/iolib/asset_loader.c` (or
the overlay loaders in `viceroy_source/src/overlay/`) has an
`@asm_format` citation pointing back to its `formats/*.md` spec.

The `formats/` directory IS the byte-level ground truth. The `*.c`
files describe the runtime control flow; the `formats/*.md` files
describe the data structures that flow through it.
