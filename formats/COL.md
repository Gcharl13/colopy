# .COL — Sound Driver Overlays + Device Config

**Corrected 2026-08-16.** An earlier version of this page claimed each `.COL`
holds "(sound_id, file_offset_into_COLDIG, size) triples". That was falsified
by direct byte inspection (`notes/rulings/AUDIO_SPIKE.md`,
`docs/RESIDUAL_FINDINGS.md` §3): four of the five `.COL` files are **MZ DOS
executables** — self-contained sound *driver* programs loaded as overlays —
and the fifth is a 20-byte device-config blob.

**5 .COL files in COLONIZE/**:

| File | Size | Magic | Role (byte-cited, RESIDUAL_FINDINGS §3) |
|------|-----:|-------|------------------------------------------|
| `ASOUND.COL` | 48,651 | `MZ` | AdLib FM driver (OPL2 ports `0x388/0x389`) |
| `GSOUND.COL` | 46,242 | `MZ` | SoundBlaster / GameBlaster driver (DSP `0x220`) |
| `PSOUND.COL` | 48,599 | `MZ` | PC-speaker driver (port `0x61`) |
| `RSOUND.COL` | 46,668 | `MZ` | Roland MT-32 driver (MPU-401 `0x330`) |
| `CONFIG.COL` | 20 | — | device configuration blob (layout below) |

`ASOUND.COL` carries the build stamp `ColonizatonA09-14-94NO` and an 11-entry
far-call ABI table, decoded in `docs/RESIDUAL_FINDINGS.md` §16/§24/§26–27
(entries 0–5 active, 6–10 RETF stubs; OPL2 write primitive at file `0x0015AF`;
patch loader at file `0x000D65`).

---

## Loader in VICEROY.EXE (byte-cited)

At boot `func_07845A` (called @0x0762E6) takes the template `"#SOUND.COL"`
(string @ file `0x1FD5A`), substitutes `#` with the configured device letter
from DGROUP `[0x2608]`, and `func_01287A` loads the file via DOS
`int 21h AX=4B03` (load overlay) under tag `"$sound$ "` (@ file `0x2004B`).
`func_012928` installs the driver's 5 entry vectors to DGROUP `0xA654–0xA667`;
dispatch @0x01299A (lock `[0x26C5]`, 8-deep queue at `[0x26B4]`); the timer ISR
@0x00C6D9 clocks vector 4 every tick and vector 3 every 5th tick. Full protocol:
`spec/ui/options_dialogs.md` §5.

The writers of `[0x2608]` / `[0x260A..0x2616]` are unmapped (external setup —
`INSTALL.EXE` is the likely writer; open item 2 in
`spec/ui/options_dialogs.md` §8).

---

## CONFIG.COL layout (20 bytes, decoded — RESIDUAL_FINDINGS §3)

```
20 02   0x0220  base I/O port (SB)        ┐ device block 1
20 00   0x0020  secondary param           │
07 00   0x0007  IRQ 7                     ┘
20 02   0x0220  MIDI/pass-through port    ┐ device block 2 (mirror)
20 00   0x0020  (mirror)                  │
07 00   0x0007  (mirror)                  ┘
01 00   0x0001  sound-enabled flag
00 00 00 00 00 00   padding
```

Equivalent to a `BLASTER=A220 I7` environment line. Note: **no ASCII driver
letter appears in the file** — the letter that lands in `[0x2608]` is derived
elsewhere (mechanism unmapped, TBD).

---

## What is still sealed inside the drivers

The per-effect index into `COLDIG.BIN`, the music sequence data for tune ids
`0x20–0x3F`, and the OPL2 patch tables live in the driver data segments and are
**not decoded**. The 2026-08-16 audio milestone (`docs/AUDIO_PORT.md`,
`notes/rulings/RULINGS.md` 2026-08-16) deliberately routes around this via
empirical capture of the running drivers rather than decoding them.

---

## Round-trip

Byte-identity (verified via `tools/verify.py`).
