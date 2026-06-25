# Runtime memory-snapshot harness (DOSBox, headless)

`tools/runtime_snapshot.py` boots VICEROY headless under stock DOSBox 0.74 and snapshots the
emulated DOS RAM directly from the DOSBox process — **no debugger build and no symbols
required**. It exists to cross-check (and extend) static reverse-engineering against the real
loaded image, which matters because RTLink overlays are paged on demand and type-A thunks are
patched at load time (so live addresses don't exist in the static EXE).

## How it works
DOSBox holds its emulated RAM as one large anonymous mmap in its own address space. The harness
finds that region in `/proc/<pid>/maps` (the one carrying the `MADSPACK`+`ORDERS` signatures)
and reads it via `/proc/<pid>/mem`. Emulated **physical** address `P` is at region offset `P`,
so DOS conventional memory (0–1MB) sits at the start of the dump.

## Verified anchors (2026-06-25)
- Live **DGROUP base = segment `0x1CFD`** (phys `0x1CFD0`), found automatically by anchoring on
  the contiguous section-name table `UNIT\0ORDERS\0ACTIONS\0` at DGROUP `0x2258`.
- DGROUP offsets are preserved from the static EXE image, so any `DGROUP:0xNNNN` citation in the
  specs is directly readable live as `phys 0x1CFD0 + 0xNNNN`.
- **Runtime-confirmed** the Track-6 finding: `DGROUP:0x54de[13]` = `-STGLFFBPR---` (the `@ORDERS`
  column-2 accelerator/status letters), occurring exactly once in 16MB of RAM.

## Usage
```
python3 tools/runtime_snapshot.py --wait 12 --out dosmem.bin   # capture + print verification
```
```python
from runtime_snapshot import Snapshot
s = Snapshot('dosmem.bin'); s.find_dgroup()
s.peek_dgroup(0x54de, 13)      # live DGROUP bytes
s.search(b'MADSPACK')          # byte-pattern offsets in DOS RAM
```

## Scope / limits
Stock DOSBox renders the DOS console to the emulated video surface (not host stdout), and this
harness does **not** automate gameplay input — so it snapshots the boot/menu state plus whatever
is resident then (resident code, DGROUP, boot-loaded NAMES/GAME data, loaded sheets). Reaching a
specific in-game state (e.g. an open orders menu, to catch the in-engine accelerator key-match)
still needs scripted input or a debugger build. The dump (`dosmem.bin`, ~16MB) is regenerable and
is **not committed**.
