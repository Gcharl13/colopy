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

> ⚠ **Caveat (RULINGS 2026-08-19):** in DOSBox 0.74-3 (Linux) the region begins **0x10 bytes
> before phys 0** (BIOS Data Area found at region offset 0x423, not 0x413), so "region offset =
> phys" is off by 16 bytes there — enough to scramble far-pointer targets like the map planes.
> DGROUP-*relative* reads (everything anchored on `find_dgroup()`) are unaffected. When absolute
> phys addresses or far pointers matter, derive phys 0 from the BDA+IVT signature instead
> (`u16[base+0x413]==640` + populated INT 08h/21h vectors), as
> `tools/cheat_engine/viceroy_dosbox.lua` does.

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

## Interactive driving (Xvfb + xdotool + scrot)

`tools/drive_game.sh` extends the harness from boot-snapshot to **drive-the-game + screenshot
any state**. It runs DOSBox inside `Xvfb :99`, sends synthetic keyboard/mouse via `xdotool`,
and captures with `scrot`. This was used to capture `docs/screens/` — the first visual
ground-truth confirming the byte-documented setup screens (BEGINMENU menu, difficulty select,
nation select, name entry, opening cinematic) against the live game.

Proven input specifics (they matter):
- **Keyboard** works via `xdotool key --window <id> <key>`. **Escape QUITS** Colonization — use
  Space/click to advance cinematics, never Esc.
- **Mouse motion** must use **absolute** screen coords (`xdotool mousemove X Y`); DOSBox maps
  them 1:1. Window-relative warps land in the wrong place.
- **Mouse click**: an instant `click 1` is dropped (too fast for DOSBox mouse polling); use
  `mousedown 1` + ~0.3s hold + `mouseup 1`.

Sandbox caveat: a single long script that backgrounds DOSBox and drives xdotool may be killed
(exit 144); if so, issue the steps as separate short foreground commands.
