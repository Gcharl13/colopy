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
[2 .. 130)     width table: 128 bytes, width[char] for char 0..127  (control chars = 0)
[130 .. 386)   offset table: 128 * u16 LE, offset[char] = file offset of that glyph's bitmap
[386 .. end)   glyph bitmaps
```

- **Glyph c** bitmap = `payload[offset[c] : offset[c+1]]` (size 0 ⇒ blank, e.g. space). The
  offset table makes blanks share an offset, so glyph size = `offset[c+1]-offset[c]` =
  `H * ceil(width[c]*2/8)` (validated: 87/87 chars match for FONTINTR & FONTTINY).
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
- The `.FF`-parsing/decompression code is **overlay-resident** (the recurring
  hard-to-disassemble RTLink overlay), so the exact directory/bitmap layout is **TBD**
  pending that trace (or render-validation). *(There is no `tools/mpskit/ff.py` — that earlier
  reference was stale; no working `.FF` glyph decoder exists in-repo yet.)*

---

## Extraction outputs

For `<NAME>.FF`:
- `assets/fonts/<NAME>/<NAME>.FF.NNN.png` — one PNG per glyph (NNN = ASCII code)
- `assets/fonts/<NAME>/<NAME>.FF.json` — font-level metadata
- `assets/fonts/<NAME>/loader.json` — sidecar
