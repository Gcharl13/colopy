# .FF — MADS Bitmap Font Format

Per-glyph bitmap font files. Each .FF holds a set of glyph bitmaps
indexed by ASCII code. The game uses 5 different fonts for various
text-display contexts.

**5 .FF files in COLONIZE/**:

| File | Role |
|------|------|
| `FONTINTR.FF` | Intro / title font (large stylized) |
| `FONTKING.FF` | Large king-text font |
| `FONT-NP.FF`  | "No-press" / disabled menu items |
| `FONTSMAL.FF` | On-disk orphan — present in COLONIZE/ but NEVER loaded by VICEROY.EXE (not "the standard small UI font") |
| `FONTTINY.FF` | Default / body UI font — bound to the `@SMALLFONT` directive at runtime via `[0x89E]`; used by almost every screen |

See [`assets/fonts/FONT_CATALOG.md`](../assets/fonts/FONT_CATALOG.md)
for glyph counts.

---

## Layout — CRACKED 2026-06-21 (render-validated: all 4 fonts decode to readable A–Z/0–9)

Outer container: `.FF` is a **MADSPACK 2.0** container; its single FAB section
decompresses (via `tools/ssdec.py`) to the font payload. The payload has a **fixed
structure** (validated by decoding every glyph to a recognizable letter):

```
[0]            height H (byte)        # glyph cell height; VICEROY uses H+3 as line pitch (@0x3AB7)
[1]            max width (byte)
[2 .. 130)     width table: 128 bytes — slot j = width of ASCII char j+1 (see mapping note)
[130 .. 386)   offset table: 128 * u16 LE — slot j = payload offset of char j+1's bitmap
[386 .. end)   glyph bitmaps
```

- **⚠ INDEX MAPPING (corrected 2026-07-28): glyph slot `j` holds ASCII char `j+1`** —
  i.e. `width(ch) = width_table[ch−1]`, `bitmap(ch) = payload[offset[ch−1] : offset[ch]]`.
  The earlier `width[char]` reading was **off by one** (it renders 'A'→'B', '0'→'1' etc.).
  Proven two ways: (a) bitmap render — under `ch−1` every glyph is the right letter and the
  metrics become sane (FONTTINY `i`/`l`/space = 2 px, `M`/`W` = 6 px; FONT-NP `I`=5, `M`/`W`=11);
  (b) **engine bytes** — the blit_string core `func_00E51C` decrements the char before both
  lookups: `dec dl` `@0x00E5DA`, width read `mov al,[bx+si+2]` `@0x00E5E9`
  (= `font[2+(ch−1)]`), glyph-offset read `mov si,[bx+si+0x82]` `@0x00E606`
  (= `u16 font[0x82 + 2·(ch−1)]`). **B.**
- **Glyph** bitmap size = `offset[j+1]-offset[j]` = `H * ceil(width[j]*2/8)` (validated
  95/95 printable slots for all 5 fonts; blanks share an offset).
- **Bitmap encoding: 2 bits per pixel, MSB-first, row-major.** H rows; each row is
  `ceil(width*2/8)` bytes; within a byte the leftmost pixel is bits 7–6, next 5–4, etc.
  The 4 levels are 0=transparent/background, 1/2/3 = ink shades (highlight/base/shadow) for
  anti-aliased text. (LSB-first or planar decode produces scrambled glyphs — MSB row-major is
  the validated one.)
- Because the width/offset tables are fixed-size (128 each), the **bitmap region always starts
  at 386** (= 130 + 256). Decompressed sizes: FONTTINY 914, FONT-NP 914, FONTKING 1219,
  FONTINTR 1898 — each = 386 + Σ glyph sizes (exact).

**Reference decoder:** `viceroy_cpp/include/ff.hpp` + `src/ff.cpp` (C++), validated by
re-rendering the glyph atlas. *(Earlier hypotheses — interleaved `[w][h][bitmap]`, planar
1-bit-plane — were disproven; the offset-table + MSB 2bpp layout above is the correct one.)*

---

## Loader in VICEROY.EXE — LOCATED (2026-06-21)

- **Loader** = `lcall 0x1A1F:0xA86` (overlay; file **~0x6FC74**). Takes `BX` = far ptr to the
  lowercase/uppercase name string, returns `DX:AX` = far ptr to the parsed font struct. Call
  sites: FONTINTR @0x760C6 (`→[0x268A]`), FONTTINY @0x760E8 (`→[0x89E]`), FONTKING @0x754F6,
  FONT-NP @0x6B7AF. The active-font global is `[0x1F9E]`.
- **Glyph blitter** = `0x181F:0x3FE` (and `0x181F:0x998` for popup body); 2-bpp unpack +
  palette map live there.
- **Rasteriser core + ink→colour mapping (B, 2026-07-28)** = **`func_00E51C`** (resident, file
  `0x00E51C`): per char it does `dec dl` `@0x00E5DA` (the `ch−1` slot mapping above), reads
  width `@0x00E5E9` and glyph offset `@0x00E606`, then unpacks 2 bpp MSB-first
  (`shl ax,2` `@0x00E629`) and maps each ink level 0..3 through a **4-entry palette-index LUT
  at far ptr `[0x269E]:[0x26A0]`** (LUT captured to `[bp−6]` `@0x00E532`; applied
  `mov ah,[bp+si−6]` `@0x00E632`; entry `0xFF` = transparent skip `cmp ah,0xFF` `@0x00E637`).
  Per-string text colour is therefore whatever 4-byte LUT `[0x269E]` points at draw time —
  this is the previously hand-waved "glyph-engine colour mapping".
- **Committed metrics:** `data_extracted/fonts/ff_metrics.json` — per-glyph width tables,
  cell heights, line pitch (H+3) and space widths for all 5 fonts, decoded from the original
  assets with the corrected mapping. *(Decoder: `tools/ssdec.py` + `viceroy_cpp/src/ff.cpp`.)*

---

## Extraction outputs

For `<NAME>.FF`:
- `assets/fonts/<NAME>/<NAME>.FF.NNN.png` — one PNG per glyph (NNN = ASCII code)
- `assets/fonts/<NAME>/<NAME>.FF.json` — font-level metadata
- `assets/fonts/<NAME>/loader.json` — sidecar
