# Palette and Color Cycling

The 256-color VGA palette in VICEROY.EXE drives every visible pixel. One small
band of it is rotated by a timer to animate water.

---

## VICEROY.PAL — base palette

**File**: `COLONIZE/VICEROY.PAL`. 1,024 bytes (256 entries × 3 bytes RGB (768 bytes; +256 trailing/unused) — CORRECTED 2026-06-27, was wrongly "×4").
**Format spec**: [`formats/PAL.md`](../formats/PAL.md).

Each entry is `(R, G, B, padding)` with R/G/B in 0..63 (VGA 6-bit). To
convert to 8-bit per channel, multiply each component by 4 (or scale
by 255/63).

**Index 0** is the conventional transparent / color-key index for
sprite blitting.

**Extracted to**: `assets/palettes/viceroy.pal.json` (RGB triples) and
`assets/palettes/viceroy.png` (16×16 swatch preview). Round-trip
BYTE_VERIFIED via `tools/extract_pal.py` + `tools/encode_pal.py`.

---

## Loader

The .PAL loader is in VICEROY's startup code (called from the scenario
loader `func_0749E0` chain — TBD). It reads VICEROY.PAL into a DGROUP
buffer and writes it to the VGA hardware.

Loader function: TBD (find via PUSH "VICEROY.PAL" or via writes to I/O
port 0x3C8). The *cycling* path below no longer depends on this: it
streams through `mcga_setpal_range`, which is identified.

---

## Color cycling

Decoded 2026-08-05 from the disassembly — see `notes/rulings/RULINGS.md`
for the full argument. The break was that **`MAPEDIT.EXE` ships CodeView
symbols**, and among them is a module `cycle_1.c.obj` exporting
`_cycle_init` and `_cycle_colors`. VICEROY links the same C module,
compiled in a different memory model but otherwise identical
instruction for instruction.

| function | MAPEDIT | VICEROY |
|---|---|---|
| `cycle_init` | file `0x0107AA` (`0xF1A:0x00A`) | file `0x0C4A4` (`0x0A0A:0x004`, thunk `0x181F:0x0EAE`) |
| `cycle_colors` | file `0x010846` (`0xF1A:0x0A6`) | file `0x0C51A` (`0x0A0A:0x07A`) |

Substrate: `code/MAPEDIT/disasm_named/cycle_1.c.asm`, symbols in
`data_extracted/mapedit_symbols.json`.

### CYCLE.DAT

**File**: `COLONIZE/CYCLE.DAT`, **34 bytes**. It is a plain struct, not
code:

```c
struct {
    uint16 count;                                  // active bands
    struct { uint8 len, phase, start, delay; }     // 4 bytes each
        band[8];
};                                                 // 2 + 8*4 = 34
```

`cycle_init` reads `count` from DGROUP `0x929E` and walks `band[i]` at
`0x92A0 + 4i`. Each field, with the site that uses it:

| off | field | site (VICEROY) | role |
|---|---|---|---|
| +0 | `len` | `[bx-0x6D60]` @`0x0C58F` | entries in the band; also the `3*len` copy length and the phase modulus |
| +1 | `phase` | `[bx-0x6D5F]` @`0x0C60D` | runtime rotation counter — zeroed at init (@`0x0C4EF`) |
| +2 | `start` | `[bx-0x6D5E]` @`0x0C598` | first palette index; also the upload base |
| +3 | `delay` | `[bx-0x6D5D]` @`0x0C55F` | ticks between rotations |

The shipped bytes are

```
01 00 | 08 3D 78 23 | 74 10 3D 05 | 00 75 03 E9 | 13 01 3D 07 …
^count  ^band[0]      ^-------------- never read --------------
```

so **count = 1** and **`band[0] = { len 8, start 120, delay 35 }`** —
palette indices **120..127**.

Bands 1..7 are uninitialised bytes from whatever tool wrote the file.
This is the answer to the old note that the tail "plausibly decodes as
x86 (CMP, JE, JNE, JMP rel, PUSH, LCALL)": it genuinely is stray code,
captured out of the authoring tool's memory, and it is dead — the loop
bound is `count`. The `phase` byte of `band[0]` (`0x3D`) is dead too,
overwritten with 0 at init.

Decoded to `data_extracted/data/CYCLE_DAT.json`.

### The tick rate — 60.8766 Hz

`timer_install` programs the PIT with divisor **0x7A8 = 1960**
(`push 0x7a8` @`0x0C843` → `TIMER_SET_RATE` @`0x0E508`: `out 0x43,0x36`
then two `out 0x40`), so IRQ0 fires at

    1193182 / 1960 = 608.766 Hz

The ISR then divides twice before touching the counter cycling reads:

| gate | site | effect |
|---|---|---|
| `test [0x8338],1` — odd ticks bail | `0x0C6A5` | ÷2 → 304.383 Hz |
| `dec byte [0x376]`, reload **5** | `0x0C6F5` / `0x0C70B` | ÷5 → **60.8766 Hz** |

The 32-bit counter at `[0x92E8]` is incremented at that rate
(@`0x0C741`), and `timer_install` points the timer-read vector at it
(`[0x267A] = 0x92E8` @`0x0C857`). `cycle_colors` reads it through
`@timer_read` (`lcall 0xC0C:6` @`0x0C544`). MAPEDIT names the three
counters `@timer_read_dos` (BIOS 18.2 Hz), `@timer_read_600` and
`@timer_read_60`, which corroborates the arithmetic.

With `delay = 35`:

- **one step = 35 / 60.8766 = 0.5749 s**
- **full 8-entry round trip = 4.5995 s**

The period is wall-clock, not frame-count — `cycle_colors` fires when
`last + delay <= now` and then sets `last = now` — so it runs at the
same speed regardless of frame rate.

### The rotation

`cycle_colors` @`0x0C5B2`–`0x0C5F3` sets `STD` and runs three descending
`rep movsb`:

1. `cx = 3` — the band's **last** colour into a temp buffer
2. `cx = 3*len - 3` — the band shifted **up** one slot
3. `cx = 3` — the temp back into the **first** slot

Each colour moves to the **next higher index**; the last wraps to the
first. After `p` steps, palette index `start + k` shows the colour
authored at `start + ((k - p) mod len)`.

### How it is driven

`cycle_colors` has no static caller — it is installed as the timer ISR's
**low-priority callback**:

    push 0x0A0A ; push 0x007A ; lcall 0x0A29:0x21B     @0x04B62

(MAPEDIT calls the same entry `_TIMER_ACTIVATE_LOW_PRIORITY` at
`0xD1C:0x23D`; the two timer modules are offset by a constant `0x22`.)
The ISR invokes it via `lcall [0x92E4]` @`0x0C795`, i.e. at the full
60.8766 Hz. Two guards:

- **`[0x372]` — enable.** Set by `cycle_init` from its argument, and the
  map screen passes `([0x5383] & 1) ? 0 : 1` (@`0x076314`–`0x076323`),
  so cycling is on unless bit 0 of `[0x5383]` is set.
- **`[0x808]` — DAC busy.** Set at the head of every routine that streams
  the palette ports directly (@`0x0D1E9`, `0x0E71C`, `0x07854D`); the
  interrupt returns immediately while one is in flight.

A third gate, `[0x92C0]`, throttles by call count: `cycle_init` sets it
to 3 when the summed band length exceeds 16 and to **0** otherwise
(@`0x0C4FF`–`0x0C50C`). With one band of 8 it is 0, so every call runs.

The upload is `mcga_setpal_range(pal, band[0].start, total)`
(`lcall 0x0C2E:0x22` @`0x0C637`) where `total` is the summed length of
all bands. Correct for one band; a latent assumption that multiple bands
would have to be contiguous.

### What actually animates

Band 120..127 is a monotone blue ramp, and it is a **duplicate of part of
the static ocean ramp** — index 120 == index 56 and index 127 == index 59,
byte for byte. The duplicate exists precisely so it can be rotated
without disturbing the ocean's own shades.

Scanning every `.SS` for pixels in the band, the map view's sheets use it
like this:

| sheet | frames | band pixels |
|---|---|---|
| `TERRAIN` | 11 (Sea Lane) | 62 |
| `TERRAIN` | 7 | 2 |
| `PHYS0` | 1..31 (rivers), 150..153 (clean coast edges) | 475 |
| `ICONS` | 123 | 3 |

**Ocean — `TERRAIN` frame 10 — has zero band pixels.** The open sea does
not shimmer. What moves is the sea-lane column, the rivers and the clean
coast edges.

This also **refutes** the claim that bands 54–60 *and* 120–127 both cycle
(carried by `port/README.md` and the generated manual, part1 "Palette
animation" / part7 §29.4). 54–60 is the static ocean ramp; it has no
entry in `CYCLE.DAT`.

Other screens load their own palettes, and the DAC is global, so the band
keeps rotating over whatever is on screen. Whether that is visible on the
score/woodcut plates (which do use indices 120..127, against their own
palettes) is **TBD** — it needs a live capture, not a byte.

---

## Implications for asset rendering

Screenshot comparison is time-aware only for the 8 indices above, and only
for the sheets in the table. `docs/screens/06_ingame_map.png` was measured
against all 8 phases (`scratchpad/cycle_phase_probe.py`) and is at
**phase 0**: 3/256 mismatched pixels on the Sea Lane tile versus 60–62/256
for every other phase. Captures taken later in a session may not be.

The HTML port implements the band: `port/tools/build_assets.py` emits a
per-sheet mask carrying the source index, and `port/src/game.js`
(`cycAtlas`) re-tints one atlas per phase on demand, selected from the
wall clock at the rate above. `G.cyclePhase` pins the phase so
`shots.py` and the render probes stay deterministic.
