# PAL Format — VICEROY palette

## File inventory
- `VICEROY.PAL` (783 bytes) — single file in COLONIZE/

## Format

VGA-mode-13h-style 256-color palette. Each color is a 6-bit RGB triple
(VGA hardware native), stored as 3 bytes per entry, scaled 0..63 (NOT 0..255).

```
Offset 0x000..0x2FF (768 bytes): 256 × { R, G, B } 6-bit values
Offset 0x300..0x30E (15 bytes):  TBD trailer (palette-cycle range table?)
```

The trailer 15 bytes likely encode palette-cycling ranges (start_index,
end_index, cycle_speed for water animation, smoke, etc.). Confirmed by
the cycle-related globals in `colonize_sdl/engine/cycle_*.c`.

## Loader

The loader is overlay-resident. The load-image references `VICEROY.PAL`
via the asset-name-construction code in `src/load_image/load_image_*.c`.

## Citations

- @asm_file ../code/VICEROY/disasm/  (loader is overlay-resident; specific offset TBD)
- @python  ../../../colonize_sdl/palette.py
- @verified Round-trip byte-equal: `tools/extract_pal.py` decodes to JSON,
  `tools/encode_pal.py` repacks; SHA256 matches original.
- @ref     ../../docs/RULINGS.md  -- master palette extracted from coldata5
            (Win16 MS_PALETTE id 9000); the DOS VICEROY.PAL is a BYTE-FOR-BYTE
            subset (768 bytes vs 1024 of MS_PALETTE format).

## Conversion to modern formats

```
6-bit VGA -> 8-bit RGB: rgb_8bit = (vga_6bit << 2) | (vga_6bit >> 4)
```

The shift-up + low-bits replication is the canonical VGA-DAC scaling
formula and matches what mode-13h hardware produces on a CRT.

## Palette layout

Index 0 is transparent (background) by convention. Indices 1..255 are
the actual game colors. The palette is shared across:
- All sprite sheets (SS, PIK files)
- The map renderer (terrain, units, colonies)
- All UI elements (HUD, dialogs, menus)

Cycling ranges (animated):
- Water shimmer (typically indices 240..247 or similar)
- Fire / smoke effects (TBD)
- Title-screen logo gradient (TBD)
