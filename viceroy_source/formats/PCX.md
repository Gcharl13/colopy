# PCX Format — ZSoft PaintBrush (standard)

## File inventory
2 .PCX files in COLONIZE/:
- (specific filenames per ASSET_CATALOG.md — typically credits / logo
  screens that use the standard ZSoft PCX format directly rather than
  the .PIK CVPC-wrapped variant)

## Format

Standard ZSoft PCX (version 5, 256-color VGA). Documented in any
period reference; the format is:

```
+---------------------------------------------------------------+
| Header (128 bytes)                                              |
| - 0x00 byte manufacturer (0x0A = ZSoft)                         |
| - 0x01 byte version (0x05 for 256-color)                        |
| - 0x02 byte encoding (0x01 = RLE)                               |
| - 0x03 byte bits_per_pixel (0x08 = 8-bit)                       |
| - 0x04 LE16 x_min                                                 |
| - 0x06 LE16 y_min                                                 |
| - 0x08 LE16 x_max                                                 |
| - 0x0A LE16 y_max                                                 |
| - 0x0C LE16 h_dpi                                                 |
| - 0x0E LE16 v_dpi                                                 |
| - 0x10 byte[48] palette_16  (16-color subset)                    |
| - 0x40 byte reserved                                              |
| - 0x41 byte n_planes (0x01)                                       |
| - 0x42 LE16 bytes_per_line                                        |
| - 0x44 LE16 palette_info                                          |
| - 0x46 byte[58] reserved                                          |
+---------------------------------------------------------------+
| Body: RLE-encoded scan lines                                    |
|   if (byte & 0xC0) == 0xC0:                                     |
|     count = byte & 0x3F                                          |
|     pixel = next byte                                            |
|     repeat pixel `count` times                                   |
|   else:                                                          |
|     emit byte as a single pixel                                  |
+---------------------------------------------------------------+
| 256-color palette (only if palette_info indicates):             |
|   byte 0x0C signature                                            |
|   byte[768] RGB triples (8-bit each)                             |
+---------------------------------------------------------------+
```

## Loader

DOS-side: standard ZSoft PCX read code in the overlay (likely shared
with the wrappers around `cvpc_codec.py`-equivalent in the C source —
PCX RLE is the same algorithm as CVPC; PCX just adds the 128-byte
header).

## Citations

- @python   ../../../colonize_sdl/engine/cvpc_codec.py  (the same RLE algorithm
            applies to standard PCX with the addition of the 128-byte header)
- @ref      Public ZSoft PCX format documentation
- @verified  PCX files round-trip cleanly through any standard PCX tool
