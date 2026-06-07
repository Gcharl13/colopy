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

## Layout

```
[MADSPACK 2.0 header — 14 bytes]
[per-glyph directory: char_code → (offset, width, height) entries]
[per-glyph bitmap data — 2-bit-per-pixel encoded, FAB-compressed]
```

The 2-bit-per-pixel encoding gives 4 colors per glyph (typically:
0=transparent, 1=highlight, 2=base, 3=shadow). Used for anti-aliased
rendering against any background.

---

## Reference implementation

[`mpskit/ff.py`](../../tools/mpskit/ff.py).

CLI:
- `mpskit ff unpack <file.FF>` — emits per-glyph PNGs + an atlas
- `mpskit ff pack <file.FF>` — re-encodes from PNGs

Round-trip is lossless decoded.

---

## Loader in VICEROY.EXE

Each font is loaded once at startup (per the `func_0749E0` scenario
loader which references `fontintr` and `fonttiny`). Loaded fonts are
indexed by font handle in a DGROUP table. Text-rendering routines call
into a glyph blitter with `(font_handle, char, x, y, color)`.

**Loader function**: TBD (Phase D — find via PUSH "fontintr" /
"fonttiny" sites).

**Glyph blitter function**: TBD (Phase D — high-call-count function
that takes (font_handle, char, x, y) args).

---

## Extraction outputs

For `<NAME>.FF`:
- `assets/fonts/<NAME>/<NAME>.FF.NNN.png` — one PNG per glyph (NNN = ASCII code)
- `assets/fonts/<NAME>/<NAME>.FF.json` — font-level metadata
- `assets/fonts/<NAME>/loader.json` — sidecar
