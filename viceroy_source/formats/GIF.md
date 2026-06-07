# GIF Format — CompuServe Graphics Interchange (standard)

## File inventory
1 .GIF file in COLONIZE/:
- `INSTALL.GIF` — installer splash / logo screen used by INSTALL.EXE

## Format

Standard CompuServe GIF87a or GIF89a. Documented at gif.com.

```
+---------------------------------------------------------------+
| Header                                                          |
| - "GIF87a" or "GIF89a" (6 bytes)                                |
+---------------------------------------------------------------+
| Logical Screen Descriptor (7 bytes)                            |
| - LE16 width                                                    |
| - LE16 height                                                   |
| - byte packed (global color table flag, color resolution, ...) |
| - byte background color index                                  |
| - byte pixel aspect ratio                                      |
+---------------------------------------------------------------+
| Global Color Table (if present): 3 × 2^(N+1) bytes              |
+---------------------------------------------------------------+
| Image Descriptor blocks (one per frame)                        |
| LZW-compressed pixel data                                       |
+---------------------------------------------------------------+
| Trailer: 0x3B                                                   |
+---------------------------------------------------------------+
```

## Loader

INSTALL.GIF is consumed by INSTALL.EXE which is OUT OF SCOPE per the
user rule (Phase 2 scope reduction — INSTALL.EXE and MPSCOPY.EXE are
not in our coverage). The file is documented here for completeness.

## Citations

- @ref       Public CompuServe GIF specification
- @rule      Per PROGRESS.md: INSTALL.EXE is out of scope; we do not
              hand-port the GIF loader.
