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

## Save round-trip: BYTE-EXACT (10/10 real saves) — DONE

`viceroy_modern --roundtrip` of all 10 shipped `COLONY*.SAV` games (Dutch/English,
1497–1727) now re-saves **bit-for-bit identical** (`savediff` exit 0). Two further
fixes got there, on top of the Ctrl-Z magic:

1. **Map-buffer allocation on load** (`render_glue.c viceroy_map_load_bind`): the
   loader never allocated the four map-layer buffers, so `g_map_layer[]` was NULL
   and `blk_read(g_map_layer[i], W*H)` landed at `g_dgroup+0`, corrupting low
   DGROUP (the version word `@0x81A`). Now the host work buffers are bound first.
2. **Restored the 4-byte view/palette aux block** (`@0x83A6`-derived, between
   `@0x85C8` and `@0x8D80`) that both save and load had skipped — saves were 4
   bytes short and real-save tails loaded 4-byte-misaligned. Bridged load→save via
   `g_save_view_aux_83A6` for exact round-trips.

This certifies the modern DGROUP state model + serialization as byte-faithful to
the original for full real games — a chunk of Phase-7 parity achieved **without
DOSBox** (the saves are the original's own output). It also makes the shared-save
basis for combat parity solid: a save loaded into the modern build is byte-clean.

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
