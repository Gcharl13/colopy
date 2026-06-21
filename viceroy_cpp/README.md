# viceroy_cpp — Layer-3 C++ reimplementation (P0)

A modern C++ port of *Sid Meier's Colonization* (VICEROY.EXE), built **from the
spec** (`spec/`), per the project's three-layer model in `METHODOLOGY.md`. The
goal is to **look and run like the original**, while the low-level math is free
to be modernized — the spec's *documented behavior* is the contract, not the
16-bit byte sequence. See `REWRITE_READINESS.md` (repo root) for the full
strategy, fidelity policy, and roadmap.

> This is a clean Layer-3 implementation, distinct from the low-trust Layer-1
> evidence transcript in `viceroy_source/` (which is decode-notes, never
> compiled). Discipline follows `mapedit_source/REWRITE_PLAN.md`: cite the spec,
> never guess, verify against an oracle.

## P0 — what works now
The **asset → pixels spine**, decoded from the original game files from scratch:

- **`fab` / `madspack` / `ss`** — the MADSPACK 2.0 container + FAB (LZ77)
  decompressor + `.SS` sprite-sheet loader, ported from the byte-verified
  `tools/ssdec.py` (itself a port of the in-EXE `fab_decompress`/`madspack_load`).
- **`mp`** — `.MP` map loader (`formats/MP_FORMAT.md`).
- **`pal`** — `VICEROY.PAL` loader (6-bit → 8-bit).
- **`render`** — composites the map view using `PHYS0.SS` terrain tiles, mirroring
  `tools/render_map.py` (naive `sprite_idx = terrain_id`, skip placeholders
  0/16/100 per CLAUDE.md hard rule #5, river overlay = frame 1).
- **`image_io`** — dependency-free PPM + PNG writers (no third-party libs).

It decodes `VICEROY.PAL` + `PHYS0.SS` + `AMER2.MP` and emits a 928×1152 PNG of
the Americas that is **pixel-identical to the Python oracle**.

## Build & run (headless)
```sh
python3 bin/reconstitute.py                 # from repo root: rebuild raw/COLONIZE/*
cmake -S viceroy_cpp -B viceroy_cpp/build -DCMAKE_BUILD_TYPE=Release
cmake --build viceroy_cpp/build -j
./viceroy_cpp/build/viceroy_cpp --colonize raw/COLONIZE --out viceroy_cpp/build/map
python3 viceroy_cpp/verify.py               # PARITY OK iff C++ == ssdec oracle
```
No display is required: P0 renders to a file. A windowed/interactive client
(SDL/raylib, 320×200 mode-13h viewport) is a later phase.

## Verification
`verify.py` decodes the same assets via the byte-verified `tools/ssdec.py`,
composites identically, and pixel-diffs against the C++ PPM. The decode path
(FAB/MADSPACK/RLE) comes from `ssdec.py` there vs. the C++ port here, so any
decoder divergence is caught. P0 result: **PARITY OK (3,207,168 bytes exact).**

## Not yet (per roadmap in `REWRITE_READINESS.md`)
- Sub-cell terrain transition chain `func_O514→O513→O512` (CLAUDE.md #7) — P0 uses
  the naive `terrain_id→sprite` mapping; refinement is **TBD** (@asm those funcs).
- Sim core (turn loop, colony production, market…), screen-UI, fonts, input,
  windowing, sound — P1+.

## Layout
```
include/   fab madspack ss mp pal render image_io util  (.hpp)
src/       fab madspack ss mp pal render image_io main  (.cpp)
verify.py  oracle parity check (uses tools/ssdec.py)
CMakeLists.txt
```
