# .PIK — MADS Packed Image Format (320×200 backgrounds)

Full-screen background images for game screens. Each .PIK is a single
320×200 indexed-color image (using VICEROY.PAL or an embedded palette),
FAB-compressed inside a MADSPACK container.

**35 .PIK files in COLONIZE/**. See
[`assets/backgrounds/BACKGROUND_CATALOG.md`](../assets/backgrounds/BACKGROUND_CATALOG.md)
for the per-file role table.

---

## Layout

```
[MADSPACK 2.0 header — 14 bytes]
[3-section directory]
  Section 0: image header (width, height, BPP)
  Section 1: palette (256 × 3 RGB6 entries) — optional, falls back to VICEROY.PAL
  Section 2: pixel data (indexed-color, FAB-compressed)
```

---

## Reference implementation

[`mpskit/pik.py`](../../tools/mpskit/pik.py) +
[`mpskit/madspack.py`](../../tools/mpskit/madspack.py) +
[`mpskit/fab.py`](../../tools/mpskit/fab.py).

CLI:
- `mpskit pik unpack <file.PIK>` — emits `<NAME>.PIK.png` (320×200 RGB image)
- `mpskit pik pack <file.PIK>` — re-encodes from PNG

Round-trip is lossless decoded (FAB compression non-deterministic).

---

## Loader in VICEROY.EXE

Loaded for screen transitions: COLONY.PIK when entering colony screen,
EUROPE.PIK for Europe screen, etc. The loader fopen+freads the file,
sets up a 320×200 framebuffer, blits decoded pixels to VGA mode 13h.

**Loader function**: TBD (Phase D).

---

## Extraction outputs

For `<NAME>.PIK`:
- `assets/backgrounds/<NAME>/<NAME>.PIK.png` — the rendered 320×200 image
- `assets/backgrounds/<NAME>/<NAME>.PIK.json` — image metadata
- `assets/backgrounds/<NAME>/loader.json` — sidecar
