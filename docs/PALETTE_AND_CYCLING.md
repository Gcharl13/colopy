# Palette and Color Cycling

The 256-color VGA palette in VICEROY.EXE drives every visible pixel.
Some palette indices are continuously rotated by a timer to animate
water shimmer, lava glow, and similar effects.

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
buffer and writes it to the VGA hardware via:

```
out 0x3C8, 0          ; "start palette write at index 0"
mov cx, 768           ; 256 × 3 RGB bytes (skip the padding)
rep outsb 0x3C9       ; stream them all
```

Loader function: TBD (Phase D — find via PUSH "VICEROY.PAL" or via
writes to I/O port 0x3C8).

---

## Color cycling (animation)

Some palette indices are rotated continuously to create animation
effects without redrawing pixels. This is the classic VGA technique
for water shimmer, lava flow, and pulsing glows.

### Mechanism

1. A timer interrupt fires periodically (typically 18.2 Hz from the
   PC's standard timer, or potentially a higher rate via mode-X
   reprogramming).
2. The timer ISR calls a "cycle-tick" function in VICEROY.
3. The cycle-tick reads `CYCLE.DAT` (or a parsed in-memory version)
   to get the list of cycle ranges.
4. For each range `[start_idx..end_idx]`, the function rotates the
   RGB triples by 1 position (e.g., `pal[s+1] := pal[s]`,
   `pal[s+2] := pal[s+1]`, ..., `pal[s] := saved_last`).
5. The modified range is re-streamed via `out 0x3C9` to the VGA
   palette registers.

### CYCLE.DAT

**File**: `COLONIZE/CYCLE.DAT`. **34 bytes** — surprisingly small.

Bytes:
```
01 00 08 3D 78 23 74 10 3D 05 00 75 03 E9 13 01
3D 07 00 74 1A E9 0B 01 FF 76 0A 57 56 9A 00 00
2A 2D
```

These bytes plausibly decode as x86 16-bit instructions (CMP, JE, JNE,
JMP rel, PUSH, LCALL). It looks like a **tiny code patch / animation
script** rather than a pure data table. The cycle-tick function might
JMP into this loaded buffer, or interpret it as a custom VM.

**Status**: format TBD until the cycle-tick function in VICEROY is
identified and annotated (Phase D).

### Cycle-tick function

To find it: search disassembled functions for writes to I/O port 0x3C9
(`OUT 0x3C9, ...` or `OUT DX, AL` with DX=0x3C9). Filter to
timer-callable functions (typically registered via INT 8h or INT 1Ch
hooks in startup code).

Status: not yet annotated.

---

## Implications for asset rendering

The cycling means **screenshot comparison must be time-aware**: if you
compare a render at t=0 to a DOSBox screenshot at t=1, the cycled
indices won't match. For visual_diff.py (Phase G dependency):
- Either compare at aligned time-step (after the same number of cycle
  ticks).
- Or restrict comparison to non-cycled indices.

The `cycle.json` deliverable (output of decoding CYCLE.DAT) lets
verifier tools mask the cycled ranges before comparison.

---

## Open work

1. Locate the cycle-tick function in VICEROY (Phase D).
2. Decode CYCLE.DAT's actual semantic (code patch, custom-VM, or
   data table) by tracing what the cycle-tick function does with it.
3. Emit `assets/palettes/cycle.json` with the cycle ranges and
   periods (per CV1 spec).
4. Build `tools/visual_diff.py` that masks cycled indices for
   time-independent comparison.
