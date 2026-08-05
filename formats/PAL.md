# .PAL — VGA Palette File Format

The 256-color VGA palette used by VICEROY.EXE and MAPEDIT.EXE. Loaded
once at game-start and pushed to the VGA hardware via I/O ports
0x3C8/0x3C9.

**Files in COLONIZE/**:
- `VICEROY.PAL` — 1,024 bytes (the only .PAL file)

---

## Layout

```
0x000..0x2FF   256 RGB triples, 3 bytes each (768 bytes)
                 +0: red   (0..63, VGA 6-bit)
                 +1: green (0..63)
                 +2: blue  (0..63)
0x300..0x3FF   256 flag bytes, ONE PER PALETTE INDEX (byte 768+i belongs to
               entry i)
                                                      = 1024 bytes total
```

The entire file is a flat array. No header. No compression.

**Two corrections live here, both of which cost real time:**

- The entry stride is **3 bytes, not 4** (corrected 2026-06-27). The 4-byte
  reading produced wrong colours across every asset; it was settled by rendering
  `COLONY.PIK` against the live DOS capture (sky index 54 → `(104,136,192)`).
- The trailing 256 bytes are **not "padding" and not "unused"** (corrected
  2026-08-05). In the shipped `VICEROY.PAL` they hold `0x05` across indices
  0..151 and 252..255 and `0x00` between — 156 non-zero bytes, only two distinct
  values, one byte per palette index. Their **meaning is TBD** (the .PAL loader
  is still unidentified — `docs/PALETTE_AND_CYCLING.md`), but they are content:
  an extractor that drops them cannot round-trip the file. `extract_pal.py` did
  drop them, hardcoding `pad = 0`, so the Phase-B round-trip gate failed
  continuously from the 2026-06-27 stride correction until 2026-08-05 while
  `STATUS.md` reported it green. Both tools now carry the layout above and the
  round-trip is byte-exact.

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
rep outsb 0x3C9       ; stream all 768 RGB bytes (the 256 flag bytes are
                      ; not part of the DAC stream)
```

The cycle-tick function is **`cycle_colors`, VICEROY file `0x0C51A`**
(decoded 2026-08-05 — `docs/PALETTE_AND_CYCLING.md`, RULINGS 2026-08-05).
It runs from the timer ISR at 60.8766 Hz, rotates the one band
`CYCLE.DAT` declares (8 entries from index 120, one step per 35 ticks)
one index upward with wraparound, and re-streams just that range via
`mcga_setpal_range` (`0x00E702`). Note this animates the sea-lane
column, the rivers and the clean coast edges — **not** the open ocean,
whose sprite uses no colour in the band.

---

## Round-trip

`tools/extract_pal.py` reads VICEROY.PAL and emits:
- `assets/palettes/viceroy.pal.json` — RGB triples plus each index's
  trailing flag byte (kept under the legacy key `padding`; the value is
  the real byte, not a hardcoded 0)
- `assets/palettes/viceroy.png` — 16×16 swatch preview

`tools/encode_pal.py` takes the JSON and re-emits a byte-identical
.PAL file. Round-trip verification: SHA-256 of repacked bytes equals
SHA-256 of original.

---

## Citations

- BYTE_VERIFIED file size: 1024 bytes (= 768 RGB + 256 flag bytes)
- VGA palette protocol: standard hardware programming (Intel x86 PC)
- Cycle-tick function: **BYTE_VERIFIED** — `cycle_colors` @ file `0x0C51A`,
  installed as the timer ISR's low-priority callback; upload via
  `mcga_setpal_range` @ `0x00E702` (`out 0x3C8` then `outsb`). The
  read-back counterpart is `mcga_getpal` @ `0x078548` (`out 0x3C7` then
  `insb`). See `docs/VICEROY_NAMES_FROM_MAPEDIT.md` §4.
- .PAL **loader**: still TBD — the cycling path does not depend on it.
