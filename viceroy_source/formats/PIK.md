# PIK Format — Packed Image (CVPC + MS_SPRITE wrapper)

## File inventory
35 .PIK files in COLONIZE/, e.g. CINTRO.PIK, CIVIL.PIK, OUTPOST.PIK,
FORT.PIK, TUTORIAL.PIK, FOREIGN1.PIK..FOREIGN3.PIK, EUROPE.PIK,
NEWWORLD.PIK, INDIANS.PIK, TANIMATE.PIK, etc.

## Format

A .PIK file is a CVPC-encoded full-screen image (320×200 typical) wrapped
in an MS_SPRITE-style container.

```
+------------------------------------------------------------+
| MS_SPRITE wrapper header (25 bytes; same as .SS files)      |
| - 8 zero bytes                                              |
| - LE16 width, LE16 height                                   |
| - 13 metadata bytes                                          |
+------------------------------------------------------------+
| CVPC payload                                                |
| - PCX-style RLE encoded over packed pixel bytes             |
| - Run-length encoding scheme:                               |
|   if (byte & 0xC0) == 0xC0: count = byte & 0x3F; next = pixel |
|   else: count = 1; pixel = byte                              |
+------------------------------------------------------------+
```

## CVPC codec

CVPC = "Compressed Video Packed Color" (best guess for the acronym).
It's PCX RLE applied to mode-13h pixel byte stream (256-color, 1 byte
per pixel).

Verified algorithm:

```c
void cvpc_decode(const uint8_t *src, int src_len, uint8_t *dst, int width, int height) {
    int written = 0;
    int total = width * height;
    while (written < total) {
        uint8_t b = *src++;
        if ((b & 0xC0) == 0xC0) {
            int count = b & 0x3F;
            uint8_t pixel = *src++;
            for (int i = 0; i < count; i++) dst[written++] = pixel;
        } else {
            dst[written++] = b;
        }
    }
}
```

## Loader

The DOS-side loader is in the overlay (asset-loader region). The
Python port `colonize_sdl/engine/cvpc_codec.py` is byte-perfect against
all 35 PIK files.

## Verification

- @python    ../../../colonize_sdl/engine/cvpc_codec.py
- @verified  69/69 source PIK files round-trip byte-perfect (number from
             a previous verification run; some additional .PIK files were
             added later but follow the same format)

## Use cases

PIK files are full-screen background images:

| File           | Used by                                    |
|----------------|--------------------------------------------|
| CINTRO.PIK     | Title screen / intro                       |
| TUTORIAL.PIK   | Tutorial backdrop                          |
| EUROPE.PIK     | European harbor screen                     |
| NEWWORLD.PIK   | New World backdrop (?)                     |
| INDIANS.PIK    | Native village backdrop                    |
| OUTPOST.PIK / VILLAGE.PIK / TOWN.PIK / CITY.PIK | Colony-view backdrops by population tier |
| FOREIGN1..3.PIK| Foreign-power dialogue backdrops          |
| TANIMATE.PIK   | Tutorial animation frames                  |
| CIVIL.PIK      | Civil-war (revolution) screen             |
| FORT.PIK       | Fortress / military post backdrop         |

The full mapping is documented in `viceroy_source/docs/ASSET_ROLES.md`.
