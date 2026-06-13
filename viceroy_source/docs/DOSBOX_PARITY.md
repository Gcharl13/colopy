# DOSBox parity — verified setup and status

Goal: validate the modern rules layer against the original by running VICEROY.EXE
in DOSBox and comparing state (`savediff.py`) / frames (`pixdiff.py`). This doc
records the **verified, in-container** setup and the current gaps.

## Verified working (2026-06-13)

- **Headless DOSBox-X runs the original in-container**: `apt install dosbox-x
  xvfb imagemagick xdotool`; `Xvfb :99` + `dosbox-x -conf tools/parity/viceroy.conf`
  (mount the COLONIZE dir, `machine=vgaonly`, `cycles=fixed 3000` for
  determinism). VICEROY.EXE boots to its main menu.
- **Navigation, blind**: `xdotool key --window <id> Down/Return/...` injects keys;
  `import -window root frame.png` grabs the framebuffer to read where you are.
  Confirmed: title menu → LOAD dialog (the 10 shipped COLONY*.SAV games).
- **Modern load-fidelity harness**: `viceroy_modern --roundtrip=GAME.SAV` loads a
  real save and re-saves it (`GAME.SAV.rt`); `tools/savediff.py GAME.SAV
  GAME.SAV.rt` byte-compares.

## Bug fixed: modern build can now load real COLONIZE saves

`load_savegame` rejected every real save (`rc=1`). Cause: the original save
header is `"COLONIZE"` + NUL + **`0x1A` (Ctrl-Z)** then the version word; the
modern `get_magic_string` stopped at the NUL and never consumed the `0x1A`, so
the version read (and everything after) was one byte misaligned → cascade to an
EOF read. The modern *save* (`put_magic_string`) also omitted the `0x1A`, so the
build round-tripped its *own* saves but was byte-incompatible with the original.

Fixed in `src/runtime/dos_io.c`: `get_magic_string` consumes the trailing `0x1A`
(ungetc-tolerant); `put_magic_string` writes it. The modern build now loads a
real 1653 Dutch save (**18 colonies, 92 units**) and re-saves near-identically.

## Remaining save-fidelity gap (precisely diagnosed)

The round-trip is *not yet* byte-perfect (27905 vs 27909, version word `0x81A`
clobbered). Root cause: `load_savegame` never **allocates** the four map-layer
buffers — the `@0x073C84` alloc is a comment, not code — so `g_map_layer[i]`
(DGROUP `0x15C/0x160/0x164/0x168`) hold garbage and `blk_read(f, g_map_layer[i],
W*H)` writes map data through them, **corrupting low DGROUP** (including the
version word at `0x81A`). Fix = implement the platform map-buffer allocation on
load (allocate `W*H` host buffers, set the layer handles, then `blk_read`), using
the same host-buffer model as `viceroy_map_attach` / `render_glue.c`. Until then
the loaded *state* (units/colonies/powers/market — the combat-relevant tables) is
correct, but the map layers and a few low-DGROUP scalars are not.

## Combat-economy parity recipe (the original target)

1. Load a war-era COLONY save in DOSBox; trigger a combat (move attacker onto
   defender); save pre/post-combat `.SAV`. Force the LCG seed equal
   (`DS:0x28EE`, or derive from the turn-0 save → modern `--seed=`).
2. Modern: load the pre-combat `.SAV`, replay the combat via `combat_resolve`
   (already wired through the `func_05E723` trampoline), save.
3. `savediff` the post-combat saves. The byte diff IS the spec for the two
   unported consequence appliers (`combat_apply_attacker_loss`,
   `combat_destroy_or_damage`); port them until the diff clears.

Prerequisite: the map-buffer allocation fix above (so the loaded state is clean).

## Files

- `tools/parity/viceroy.conf` — deterministic DOSBox-X config.
- `tools/parity/dosbox_launch.sh` — headless launcher (Xvfb + dosbox-x).
- `viceroy_modern --roundtrip=` + `tools/savediff.py` — modern load-fidelity.
