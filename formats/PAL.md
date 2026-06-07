# .PAL — VGA Palette File Format

The 256-color VGA palette used by VICEROY.EXE and MAPEDIT.EXE. Loaded
once at game-start and pushed to the VGA hardware via I/O ports
0x3C8/0x3C9.

**Files in COLONIZE/**:
- `VICEROY.PAL` — 1,024 bytes (the only .PAL file)

---

## Layout

```
[256 entries × 4 bytes each = 1024 bytes total]
  Each entry:
    byte 0: red component   (0..63, VGA 6-bit)
    byte 1: green component (0..63)
    byte 2: blue component  (0..63)
    byte 3: padding / flags (typically 0)
```

The entire file is a flat array. No header. No compression.

To convert to 8-bit-per-channel RGB, multiply each component by 4
(or scale by 255/63).

**Index 0** is conventionally the **transparent/key color** in
sprite sheets. The actual color value at index 0 is still defined
(used by some UI areas) but sprites treat reads of 0 as "skip pixel"
during blit.

---

## Loader in VICEROY.EXE

The loader reads VICEROY.PAL into a DGROUP buffer and writes it to
the VGA palette registers via:

```
out 0x3C8, 0          ; tell VGA "start writing palette at index 0"
rep outsb 0x3C9       ; stream all 768 RGB bytes (skipping the padding byte)
```

The cycle-tick function (CYCLE.DAT consumer) modifies specific
ranges in this buffer in a timer interrupt and re-streams the
modified ranges to update animated colors (water shimmer, etc.).

---

## Round-trip

`tools/extract_pal.py` reads VICEROY.PAL and emits:
- `assets/palettes/viceroy.pal.json` — RGB triples + padding bytes
- `assets/palettes/viceroy.png` — 16×16 swatch preview

`tools/encode_pal.py` takes the JSON and re-emits a byte-identical
.PAL file. Round-trip verification: SHA-256 of repacked bytes equals
SHA-256 of original.

---

## Citations

- BYTE_VERIFIED file size: 1024 bytes (= 256 × 4)
- VGA palette protocol: standard hardware programming (Intel x86 PC)
- Cycle-tick function: TODO_VERIFY (Phase D, locate via writes to
  port 0x3C9 in a timer-driven function)
