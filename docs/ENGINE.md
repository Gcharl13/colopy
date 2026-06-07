# MicroProse Engine — MADS + RTLink Plus

VICEROY.EXE is built atop two layered MicroProse engine components:

1. **MADS** (MicroProse Adventure Development System) — handles asset
   formats (.SS, .PIK, .FF, .PAL) and basic graphics primitives.
2. **RTLink Plus** (Pocket Soft) — overlay system for fitting >64KB
   of code into 16-bit DOS.

Plus the MSC 6.0 C runtime for math, string, file I/O, and
randomness.

---

## MADS asset library

### MADSPACK 2.0 container

Generic compressed-section container used by .SS, .PIK, .FF.

```
[14-byte header]
   Signature: "MADSPACK 2.0"  (12 bytes)
   Section count + flags    (2 bytes)
[per-section directory]
   compression_type (0=raw, 1=FAB)
   hash_byte
   decompressed_size
   compressed_size
[section data]
```

Reference impl: [`mpskit/madspack.py`](../../tools/mpskit/madspack.py).

### FAB compression

LZ-style compression with bit-packed literals + back-references.
Variable-length codes for offsets and lengths. Non-deterministic at
the bit level (the encoder's choices can vary), so re-encoded files
don't byte-match the original even though they decode to the same
content.

Reference impl: [`mpskit/fab.py`](../../tools/mpskit/fab.py).

### Format-specific layers (on top of MADSPACK)

- `.SS`: 4 sections — sprite header, descriptor table, palette, pixel data
- `.PIK`: 3 sections — image header, palette, pixel data
- `.FF`: glyph-indexed bitmap font with 2-bit-per-pixel encoding

See per-format docs in [`formats/`](../formats/).

---

## RTLink Plus

See [RTLINK_OVERLAYS.md](RTLINK_OVERLAYS.md).

Key insight: Type B thunks let the loader expose load-image
functions through the same `LCALL 0x181F:NNN` calling convention
used for overlay calls. This means the MAJORITY of "overlay" calls
in disassembly are actually direct calls to load-image functions —
fully decodable today.

---

## MSC 6.0 C runtime (BYTE_VERIFIED)

VICEROY.EXE was compiled with Microsoft C 6.0 medium-model. The
runtime helpers are byte-pattern-identical across all MicroProse
binaries from this era:

| Helper | File offset | Verified |
|--------|------------:|----------|
| `__aFlmul` (32×32 mult) | 0x010530 | ✓ |
| `__aFldiv` (signed long div) | 0x010496 | ✓ |
| `rand()` (LCG) | 0x0103D4 | ✓ |
| `srand()` | 0x0103C2 | ✓ |
| `strcpy_near` | 0x00FDB4 | ✓ |
| `strcat_near` | 0x00FD74 | ✓ |
| `strlen_near` (estimated) | 0x010A4C | (per Ghidra Phase 1) |

The `rand()` LCG uses constants `0x000343FD` (multiplier) and
`0x00269EC3` (increment) — the canonical Microsoft MSC 6.0 values.
This means **every game roll is exactly reproducible** given the seed.

`sigmatch.py` finds these helpers in any same-compiler EXE (verified:
4 helpers each in MAPEDIT/OPENING/CLOSING).

---

## Game-specific runtime layer (above C runtime)

Sitting between the C runtime and the game logic, VICEROY's overlay
runtime adds:

- **`random_int(lo, hi)`** at file 0x00C322 — universal roll helper
  (`LCALL 0x181F:0x04D4`). Used by every game-system roll (combat,
  raze, market drift, king demand, LCR, mapgen).
- **`clamp(value, lo, hi)`** at file 0x0048CC — used by SMITE formula
  (`LCALL 0x181F:0x035C`).
- **`power_attribute_bit(power, bit)`** at file 0x00BC10 — PowerRecord
  attribute bitfield reader.
- **`get_per_power_byte(power, offset)`** at file 0x007F34 — universal
  EU/native byte accessor; routes to PowerRecord (stride 0x13C) for
  EU and TribeData (stride 78) for natives.
- **`get_power_name_word(power)`** at file 0x008110 — EU vs native
  power-name lookup.
- **`output_flush_helper`** at file 0x00513C — conditional message
  flush.
- **`set_message_context(code)`** at file 0x0050BC — sets a global for
  the next message.
- **`set_active_tribe(tribe_idx)`** at file 0x0081C6 — sets
  `g_settlement_ptr_8D4E`.
- **`decrement_power_unit_count_and_destroy(unit_idx)`** at file
  0x006E94 — destroy_unit primitive.

All BYTE_VERIFIED.

---

## How a typical game event flows

Take "player attacks Aztec village" as an example:

1. UI handler captures the click → `func_072090` (top menu) →
   units submenu → "attack" action.
2. Pathfinding moves the unit to the village tile (uses PATH.DAT data?).
3. Combat resolver `func_05B2C2` rolls combat outcome via
   `random_int` → demotion ladder applies.
4. If victorious → `func_04A7CA` (CHIEFKILL) computes raze gold:
   ```
   gold = sum_3 × roll_4 × 4 × (size_byte + 1)
   ```
   where each `random_int(1, upper)` and `random_int(1, 6)` consumes
   the seed.
5. PowerRecord[attacker].gold (offset +0x21) gets the dword-add.
6. `set_active_tribe()` updates the active tribe pointer.
7. Display dialog (CHIEFKILL message via `func_06F0F4` framework).
8. Render chain redraws (since the tile changed).
9. Tribe-attitude update via `func_04B308`.

Each step is a BYTE_VERIFIED entry-point function in
[`viceroy_source/FUNCTION_INVENTORY.md`](../viceroy_source/FUNCTION_INVENTORY.md).
