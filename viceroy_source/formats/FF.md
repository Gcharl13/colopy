# FF Format — Bitmap Font

## File inventory
**Byte-verified vs VICEROY.EXE (2026-05-30; see docs/UI_FIDELITY.md "Fonts").**
The EXE loads exactly **4** fonts via `LCALL 0x1A1F:0x0A86`:
- `FONTTINY.FF` — default/body font → DGROUP `[0x89E]` (reports, status, popups). EXE name `fonttiny` @0x1FD32.
- `FONTINTR.FF` — menus / titles / new-game pickers → `[0x268A]`. EXE name `fontintr` @0x1FD29.
- `FONTKING.FF` — King-audience font, loaded on demand. EXE name `FONTKING` @0x1FCCB.
- `FONT-NP.FF` — newspaper/woodcut report font, on demand. EXE name `FONT-NP` @0x1F8AF.

`FONTSMAL.FF` exists on disk but is **NEVER referenced by VICEROY.EXE** (orphan).
The previously-listed `FONTMED/FONTLARG/FONTBOLD/SYMBOLS` were **fabricated** — no
such files and no such strings in the binary.

## Format

Bitmap font. Each FF file is a sequence of glyph entries. Each glyph is
a fixed-size or variable-width packed-pixel bitmap.

```
+---------------------------------------------------------------+
| Header                                                          |
| - LE16 first_char  (typically 32 = ASCII space)                 |
| - LE16 last_char   (typically 127 = ASCII delete)               |
| - LE16 height      (pixel height)                                |
| - LE16 max_width   (max glyph width in pixels)                   |
| - LE16 default_advance                                            |
+---------------------------------------------------------------+
| Per-glyph offset table: LE16[(last - first + 1)]               |
|   Each entry is the byte-offset (within the file) of that      |
|   glyph's bitmap data.                                          |
+---------------------------------------------------------------+
| Per-glyph bitmap data:                                         |
|   - byte width                                                  |
|   - byte advance                                                |
|   - byte[height * ceil(width/8)] packed-pixel rows              |
+---------------------------------------------------------------+
```

The exact header may vary; the Python-port parser at
`colonize_sdl/font.py` is the byte-perfect reference.

## Glyph rendering

Bits in each row map to pixels left-to-right:
- bit 7 = leftmost pixel
- bit 0 = rightmost pixel of that byte
- 1 = foreground color (palette index passed at draw time)
- 0 = transparent

## Loader

The DOS-side font loader is in the overlay (asset-loader region). The
font drawer is also overlay-resident. Cross-reference candidates:
- The `font_*.c` modules from madsdev.lib (per MAPEDIT.EXE NB02
  symbols) confirm a font primitives library exists.
- LCALL targets matching `0x181F:0x254` and `0x181F:0x444` in the
  classifier's TEXT_DRAW group are candidates for the per-glyph blit.

## Verification

- @python    ../../../colonize_sdl/font.py
- @verified  All 5 FF files load and render at the expected sizes,
             matching DOSBox screenshots.

## Citations

- @asm_file  not yet decoded (overlay font loader + drawer)
- @ref       ../../../docs/COLTEXT0_INDEX.md  -- text-string ID index
