# Audio Spike — findings & go/no-go (plan phase: non-gating)

**Status: NO-GO for in-scope audio. Audio stays OUT of the "100% identical
except audio" done-bar (the user's explicit scope decision).**

This is a *findings document only*. No playback code was written; nothing
here affects the pixel/behaviour fidelity gate. Its sole purpose is to make
the audio exclusion an informed decision rather than an unknown, and to
record concrete entry points for a future, separately-scoped audio effort.

---

## What audio artifacts actually exist (verifiable facts)

Inspected `COLONIZE/` directly (file sizes + header bytes, this session):

| File | Size | First bytes | Fact |
|------|-----:|-------------|------|
| `COLONIZE/ASOUND.COL` | 48,651 | `4d 5a 0b 00 60 00 ...` | **`MZ` — DOS executable** |
| `COLONIZE/GSOUND.COL` | 46,242 | `4d 5a a2 00 5b 00 ...` | **`MZ` — DOS executable** |
| `COLONIZE/PSOUND.COL` | 48,599 | `4d 5a d7 01 5f 00 ...` | **`MZ` — DOS executable** |
| `COLONIZE/RSOUND.COL` | 46,668 | `4d 5a 4c 00 5c 00 ...` | **`MZ` — DOS executable** |
| `COLONIZE/AMERICA.MOV` | 572 | `0c 00 00 0e 00 00 ...` | NOT audio/video (see below) |

Key finding: the four `*SOUND.COL` files are **`MZ`-headed DOS
executables / overlays (sound *driver* programs), not raw sample banks.**
The `A` / `G` / `P` / `R` prefixes plausibly distinguish audio-hardware
targets, but the exact prefix→hardware mapping is **undetermined and is NOT
guessed here** (prime directive). Reproducing audio is therefore *not* a
"decode a sample file" task — the sample/sequence data is loaded/produced
by driver code (or lives in the Win16 build), which is a materially larger
effort than a codec decode.

`AMERICA.MOV` is **not** an audio or video stream — per the existing,
already-verified `docs/MOV_FORMAT.md` it is 572 bytes of movement /
route-delta overlay data drawn over `OPENING.PIK`. `.MOV` is out of audio
scope entirely; no audio decoder applies to it.

No standalone `.VOC` / `.WAV` / `.SND` / `.XMI` / `.MID` audio assets are
present in `COLONIZE/`.

## Why this is correctly out of the done-bar

- The fidelity gate (P0 harnesses) measures *pixels* and *deterministic
  game-state traces*. Audio is orthogonal to both and cannot regress them.
- Audio requires reverse-engineering MZ driver executables (or the Win16
  audio path) — its own multi-session effort with no guaranteed timeline,
  exactly the kind of open-ended research the user scoped out.
- "100% identical **except audio**" remains the honest definition of done.

## Concrete entry points for a future, separately-scoped audio effort

(Recorded so the exclusion is actionable later — not started now.)

1. Disassemble the `*SOUND.COL` MZ overlays (same toolchain as
   `extracted/disassembly/` for VICEROY.EXE) to locate the sample/sequence
   tables and the driver dispatch. Identify the A/G/P/R hardware mapping
   from the code, not by guessing the prefixes.
2. Check VICEROY.EXE / the Win16 `colowin/` build for AIL / Miles Sound
   System driver signatures (early-90s MicroProse used Miles); music is
   likely XMI (→ convert XMI→MIDI for a modern engine).
3. Stopgap reference: capture in-game audio from a DOSBox playthrough so a
   future audio milestone has ground truth to compare against (parallels
   the `reference/dos/` screenshot approach for visuals).
4. `colowin/COLWIN.PRF` (412 B, per SAVE_FORMAT.md) holds sound/zoom/window
   prefs — decode the sound flags there for the settings UI later.

## Recommendation

Keep audio explicitly excluded from the fidelity done-bar. Track it on
`PROJECT_BOARD.md` under the labeled "Out of fidelity scope — audio"
heading. Revisit only as a deliberately separate milestone after the
visual/behaviour parity phases (P1–P7) are complete.
