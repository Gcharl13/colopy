# DAT Format — Binary Tables

## File inventory
3 .DAT files in COLONIZE/:
- `CYCLE.DAT` (34 bytes) — palette cycling parameters
- `PATH.DAT` — pathfinding cost-table (not yet decoded)
- `INSTALL.DAT` — installation manifest (not yet decoded)

Plus user-state files (typically in saves/ rather than COLONIZE/):
- `HALLFAME.DAT` — high-score / hall-of-fame data

## Format (CYCLE.DAT)

```
Offset 0x00..0x21 (34 bytes): N × { palette_start, palette_end, speed }
where each entry is 3 bytes (or similar packed format).

Each entry instructs the palette-cycling timer interrupt to rotate the
palette indices in [start..end] every (speed) tick. Used for:
- Water shimmer animation
- Smoke / fire animation
- Title-screen logo gradient
```

## Format (HALLFAME.DAT)

The Hall of Fame format is documented in the Python port at
`colonize_sdl/engine/hallfame_format.py`. Each entry stores:
- player name (null-terminated string)
- final score
- year completed
- difficulty
- nation
- victory type (revolution / king / wealthy / abandoned)

## Format (PATH.DAT)

PATH.DAT contains the AI's precomputed pathfinding cost table.
Specifics not yet decoded.

## Format (INSTALL.DAT)

INSTALL.DAT is the installer's manifest. Lists the files to copy and
their expected sizes/checksums. Used by INSTALL.EXE (out of scope per
user rule).

## Loader

DOS-side: overlay-resident loaders.
Python: `colonize_sdl/engine/hallfame_format.py` for hall-of-fame.

## Verification

- @python  ../../../colonize_sdl/engine/hallfame_format.py
- @ref     ../../../ASSET_CATALOG.md  for the full file inventory
