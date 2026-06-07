# MAPEDIT.EXE — Reconstructed C Source

The standalone map editor that ships with Sid Meier's Colonization
(MicroProse 1994). Reads/writes `.MP` map files compatible with
VICEROY.EXE.

This is the smaller sibling of `viceroy_source/` and follows the
same conventions:

- **100% citation backing** — every function has an `@asm` block
  pointing at `code/MAPEDIT/disasm/func_<6hex>_*.asm`
- **Same struct definitions** for shared formats (.MP, .SS) reused
  from `../viceroy_source/include/`
- **Auto-traced control-flow bodies** from `tools/full_pipeline.py`,
  with hand-ported semantic detail on the largest functions

## Inventory

| Metric                          | Value           |
|---------------------------------|-----------------|
| Original file size              | 145,292 bytes   |
| Image (load) bytes              | 114,185         |
| Overlay bytes (debug data only) | 31,107          |
| Functions in load_image         | **210**         |
| Functions in overlay            | 0 (debug data)  |
| Total instructions              | 83,318          |

## Pattern distribution (after classifier pass)

- `TINY_ACCESSOR`: 54
- `PROLOGUE_HEAVY`: 53
- `WRAPPER_LCALL`: 27
- `MEDIUM_LOGIC`: 18
- `DISPATCHER`: 13
- `UNKNOWN`: 12
- `TINY_RETURN`: 11
- `WRAPPER_NEARCALL`: 9
- `FIND_LOOP`: 8
- `COUNT_LOOP`: 3
- `LARGE_LOGIC`: 2

## How MAPEDIT relates to VICEROY

MAPEDIT.EXE shares format-handling OBJ modules with VICEROY.EXE:

- `.MP` map format (read + write)
- `.SS` sprite-sheet rendering (used to display tiles in the editor)
- `.PAL` palette loading (uses `VICEROY.PAL`)
- `.FF` font rendering (uses fonts from VICEROY)

So many functions in `mapedit_source/src/load_image/` will have
identical bytes to functions in `viceroy_source/src/load_image/` —
those are the shared OBJ modules.

## Citation convention

Same as VICEROY: every function has `@asm` + `@asm_file` linking
back to its disassembly. See `../viceroy_source/README.md` for the
detailed convention.
