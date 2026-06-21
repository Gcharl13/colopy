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
| `FONTSMAL.FF` | Standard small UI font |
| `FONTTINY.FF` | Smallest dialog text |

See [`assets/fonts/FONT_CATALOG.md`](../assets/fonts/FONT_CATALOG.md)
for glyph counts.

---

## Layout — PARTIALLY DECODED (2026-06-21); the bitmap layout is NOT yet cracked

Outer container: `.FF` is a **MADSPACK 2.0** container; its single FAB section
decompresses (via `tools/ssdec.py`) to the font payload. Decompressed sizes:
FONTTINY **914**, FONT-NP **914**, FONTKING **1219**, FONTINTR **1898**.

What is **byte-verified** about the payload:
- **Byte 0 = glyph height** (VICEROY reads `mov al,es:[bx]; add ax,3` @0x3AB7, used as
  the row pitch). Header begins `[height, maxWidth, flag]`, then ~30 zero bytes, then a run
  of small width-like values (e.g. FONTINTR ' '=3, '!'=3, '"'=5, '#'=7, '$'=7, '%'=9,
  digits=6 — a plausible per-glyph width table).
- Glyphs are **2 bits per pixel** (4 levels: 0=transparent, 1=highlight, 2=base, 3=shadow),
  for anti-aliased text. FONTKING/FONT-NP are **variable-height**; FONTTINY/FONTINTR fixed.

What is **NOT cracked** (every obvious recipe disproven 2026-06-21 — see `RULINGS.md`):
- Interleaved `[w][h][bitmap]` from offset 33 **desyncs immediately** (consumes ~165/914),
  with both `ceil(w*h*2/8)` and row-aligned `h*ceil(w*2/8)` bitmap sizing.
- A fixed-height width-table + bitmap block gives **no clean file-length landing** for any
  height.
So the true layout is non-obvious (offset table? separate variable-height table? per-font
differences?). **Do not guess a decoder** — the authoritative parser is the overlay-resident
loader below; cracking it needs that disasm or a render-validation pass (decode glyphs,
render `A–Z 0–9`, confirm they form correct letters).

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
