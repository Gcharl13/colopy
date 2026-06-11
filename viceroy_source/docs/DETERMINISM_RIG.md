# Determinism rig (ROUTE_B_PLAN 0.1) — usage and DOSBox replay protocol

The rig makes any input sequence byte-replayable against the modern build,
headless included, and defines the protocol for replaying the SAME sequence
against the original in DOSBox so the two ends are comparable by
`savediff.py` / `pixdiff.py`.

## Modern side (delivered, self-tested)

    ./viceroy_modern --script=run.scr [--seed=0x12345678]
    VICEROY_SCRIPT=run.scr VICEROY_SEED=0x12345678 ./viceroy_modern

Script grammar (`#` comments, one directive per line):

| directive | effect |
|---|---|
| `key TOKEN` | one keypress. Tokens: `ESC RETURN ENTER SPACE TAB UP DOWN LEFT RIGHT F1..F12`, single chars (`b`, `e`, `1`), raw `0xNN` |
| `wait N` | N empty polls (~16 ms each with a display; instant headless) |
| `shot PATH` | write a PPM checkpoint frame (pixdiff input) |
| `seed N` | set the MSC 6.0 LCG seed (DGROUP:0x28EE) at this point |
| `quit` | end the run |

Headless, a finished script ends the run automatically. The shell's own
F5/F7 keys produce/load original-format saves (savediff inputs).

Self-test (run twice, frames must be identical):

    seed 0x12345678
    wait 2
    key DOWN
    key UP
    wait 1
    shot /tmp/rig_run.ppm
    quit

Verified 2026-06-11: `pixdiff` reports IDENTICAL across repeated runs.

## DOSBox side (one-time setup; needs the user's game files)

Use **DOSBox-X** (vanilla 0.74 has no input injection). One-time config:

1. `dosbox-x -conf viceroy.conf` with the COLONIZE directory mounted;
   `machine=vgaonly`, `cycles=fixed 3000` (fixed cycles remove host-speed
   nondeterminism in the original's timing loops).
2. Replay a script with the built-in `AUTOTYPE` command before launching:
   `AUTOTYPE -p 250 -w 1500 v i c e r o y enter` style pacing, or bind the
   sequence in the mapper (`Ctrl-F1`) once and save the mapping file next
   to the script.
3. Frame checkpoints: `Ctrl-F5` writes a PNG — pair each `shot` directive
   with one Ctrl-F5 press at the same point in the DOSBox-X AUTOTYPE
   sequence. `pixdiff.py modern.ppm dosbox.png` compares them directly.
4. Saves: use the in-game save (F5 path) to the mounted directory; compare
   with `savediff.py modern.sav dosbox.sav --allow tools/save_allowlist.json`.

Token mapping `.scr` -> AUTOTYPE: `key X` -> the same character; `RETURN`
-> `enter`; `ESC` -> `esc`; arrows -> `up/down/left/right`; F-keys ->
`f1..f12`; `wait N` -> `-w` pacing gaps (250 ms per poll is a safe floor).

## RNG-seed parity (the part that makes saves comparable)

The original seeds its LCG from DOS time at boot. For determinism parity
runs, the seed must be FORCED equal on both sides:

- modern: `--seed=N` (sets DGROUP:0x28EE before the first poll).
- DOSBox: the same word lives at the same DGROUP offset in the running
  original; set it once at the title screen with the DOSBox-X debugger
  (`Alt-Pause`, `SM` memory-set on DS:0x28EE) — scriptable in the conf's
  `[autoexec]` via DEBUGBOX, documented here as the one-time recipe.
  Alternative when the debugger route is unavailable: derive the boot
  seed from a save written at turn 0 and feed THAT value to `--seed=`.

## What this rig gates

Phase 7.2 determinism parity = same `.scr` + same seed on both sides ->
`savediff == 0` at every 10-turn checkpoint; Phase 7.1 pixel matrix =
`shot`/Ctrl-F5 pairs at the ~25 checkpoint states -> `pixdiff == 0`.
