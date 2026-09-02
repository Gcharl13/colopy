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
  `func_0781DE` — located 2026-09-02, below — reads only `0x300` bytes, so
  VICEROY never touches them), but they are content:
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

## Loader in VICEROY.EXE — LOCATED (2026-09-02, REMAINING_WORK.md G5)

**`func_0781DE`** (file `0x0781DE`, thunk `0x1A1F:0xE28`, exactly one caller).
All offsets are file offsets into `VICEROY.EXE`; DGROUP strings are relative
to file `0x1D9A0`.

- **Call site** — boot asset loader `func_075FB6` `@0x76039–0x76043`:
  `push 0xa000; push 0xfc00; lea bx,[0x237d]; lcall 0x1a1f,0xe28` — i.e.
  `(dest = A000:FC00, name = DGROUP 0x237D)`. `0x237D` is
  **`"viceroy.pal"` in lowercase** (file `0x1FD1D`), which is why an
  uppercase `VICEROY.PAL` string search never found it. Failure sets
  `[0x822] = 0x13` `@0x7604C`.
- **Body** — `fopen(name, "rb")`: `lea bx,[0x25f2]` (`"rb"`) +
  `lcall 0x181f,0xe86` `@0x781EB–0x781EF` (→ `func_00C45A`); then
  **`fread(buf, 0x300, 1, fp)`**: `push si; push 1; push 0x300;
  lea ax,[bp-0x302]; lcall 0xd1d,0x528` `@0x781FA–0x78205`; then a far copy of
  `0x300` bytes to the destination: `push 0x300 … lcall 0xd1d,0xfb2`
  `@0x78211–0x78220`; `fclose` `@0x78232`.
- **DAC upload** — `push 0xa000; push 0xfc00; lcall 0x181f,0x3f4`
  `@0x762FE–0x76304` (also `@0x75982`, `@0x759CD`, `@0x75B66`) → `func_00D1E4`:
  `mov dx,0x3c8; xor al,al; out dx,al` `@0xD1FD–0xD202`, then `0x300` ×
  `outsb 0x3C9` with a retrace wait (loop `@0xD21F`).

**Consequence: VICEROY.EXE reads exactly 0x300 bytes. The trailing 256 flag
bytes (`0x300..0x3FF`) are never read by VICEROY.** They remain content for
round-trip purposes; their consumer is **TBD** — blocker: `MAPEDIT.EXE`
(`"viceroy.pal"` @0x177E7) and `COLONIZE.EXE` (@0x6C334) also name the file
and neither loader has been traced. `A000:FC00` is VGA memory past the
64,000-byte mode-13h frame, used here as palette scratch (that the segment
is free there is inferred from the address, not from a read instruction —
flagged, not load-bearing).

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
- .PAL **loader**: **BYTE_VERIFIED 2026-09-02** — `func_0781DE` @ file
  `0x0781DE` (thunk `0x1A1F:0xE28`, caller `@0x76043`), `fread` of `0x300`
  bytes `@0x781FA–0x78205`. The 256 trailing flag bytes are unread by VICEROY
  (consumer TBD, see "Loader in VICEROY.EXE").
