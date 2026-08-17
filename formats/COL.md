# .COL — Sound Drivers

`?SOUND.COL` are **not** data files. Each is an `MZ`-headed DOS executable — a
sound *driver* the game loads as an overlay (DOS `int 21h AX=4B03`, built from
the template `"#SOUND.COL"` at VICEROY.EXE file `0x1FD5A` with `#` replaced by
the sound-config byte `[0x2608]`; see manual §24.5).

**5 .COL files in COLONIZE/**:

| File | Size | ID string @ file `0x210` | Device |
|------|-----:|---|---|
| `ASOUND.COL` | 48,651 | `ColonizatonA09-14-94` | AdLib / OPL |
| `GSOUND.COL` | 46,242 | `Coloniz GMID09-12-94` | **General MIDI** |
| `PSOUND.COL` | 48,599 | `ColonizatonP 9-13-94` | PC speaker |
| `RSOUND.COL` | 46,668 | `RLND Colniz 09/13/94` | Roland MT-32 |
| `CONFIG.COL` | 20 | — | not a driver — 20 bytes of config words |

The device column is read from the drivers' own ID strings, not guessed from
the filename prefixes. (The pre-2026-08-17 version of this file assigned
`GSOUND.COL` to "GameBlaster / SoundBlaster" — that was a guess and it was
wrong; `GMID` is General MIDI.)

---

## MZ layout

All four are single-segment small/tiny-model images: header 512 bytes (32
paragraphs), so the image starts at file `0x200` and **load = file − 0x200**.
Entry is `CS:IP = 0000:0010` — file `0x210`, the 20-byte ID string above,
followed by `"NO"`, then at file `0x22A/0x22C/0x22E` a relocated DS paragraph,
a word, `0x0064`, and `0x000B` = **11 far entry points** listed as words from
file `0x232`. Public entry #2 is the id dispatcher (`ASOUND.COL @0x01C35`).

Each driver is really two parts: a **digital-sample player** in the low image,
and the **MPS music driver** at DS = loadseg + `0x3C0`.

---

## What each driver contains

- **Music**: synthesised on the target device from sequence data inside the
  driver — AdLib register streams, General MIDI, PC-speaker frequency pairs,
  MT-32 (RSOUND carries `[MpsColoniz]` custom-timbre names such as
  `Explosion1/2/4`, `SmNoise2`, `WhiteNoise` at `@0x39F2–0x3D0A`). **There is
  no music audio file anywhere in the game**; a port cannot play the tunes
  without re-implementing a device synth.
- **Digital effects**: the *index* into `COLDIG.BIN` — a 36-row
  `{u32 offset, u32 length}` table (35 samples + zero-length terminator),
  byte-identical in all four drivers. Locations, the walker/player code, the
  two sample rates and the id→index jump table are documented in
  `formats/BIN.md`; the decoder is `tools/decode_coldig.py`.

The strings `"EMMXXXX0"` and `"coldig.bin"` are present in all four drivers
(ASOUND `@0x3E50`, GSOUND `@0x34C2`, PSOUND `@0x475E`, RSOUND `@0x3E02`) but no
driver code references them — the bank is opened by `COLONIZE.EXE`, which holds
`"#SOUND.COL"` `@0x6C3B0` and `"coldig.bin"` `@0x6C3EE` next to
`"Not enough memory to load '%s' (need: %ld, found: %ld)"`. The driver's own
EMS path is at ASOUND load `0x0DC2` (`INT 67h AH=40/41/…`).

---

## Round-trip

Byte-identity (verified via `tools/verify.py`).

---

## Still open

The music side. Extracting the sequence data and the device synth from these
overlays is a separate, much larger effort than the sample index was — see the
follow-up list in the 2026-08-17 ruling.
