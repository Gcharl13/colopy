# .COL — Sound Drivers, and the one config file that shares the extension

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
| `CONFIG.COL` | 20 | — | not a driver — 20 bytes of config words (§"CONFIG.COL") |

The device column is read from the drivers' own ID strings, not guessed from
the filename prefixes. (The pre-2026-08-17 version of this file assigned
`GSOUND.COL` to "GameBlaster / SoundBlaster" — that was a guess and it was
wrong; `GMID` is General MIDI.)

---

## CONFIG.COL — seven words, byte-verified reader (added 2026-09-02, G6)

**Reader `func_070DE8`** (VICEROY file `0x070DE8`):

```
070DEC  push 0x2056 ; push 0x2059          ; "rb" (DGROUP 0x2056), "CONFIG.COL" (0x2059, file 0x1F9F9)
070DF2  lcall 0xd1d, 0x4da                 ; fopen
070E04  push ax ; push 1 ; push 2 ; push 0x260a ; lcall 0xd1d,0x528    ; fread([0x260A], 2, 1)
070E1B  ...                                 push 0x260c ...             ; fread([0x260C], 2, 1)
070E31  ...                                 push 0x260e ...             ; [0x260E]
070E47  ...                                 push 0x2610 ...             ; [0x2610]
070E5D  ...                                 push 0x2612 ...             ; [0x2612]
070E73  ...                                 push 0x2614 ...             ; [0x2614]
070E89  ...                                 push 0x2616 ...             ; [0x2616]   (@0x70E04-0x70E93)
070EA4  lcall 0xd1d, 0x3f4                 ; fclose
070EAC  mov ax, [0x260c] ; lcall 0x1a1f,0xc50 ; mov [0x2608], al       ; word 1 -> driver letter
```

Each `fread` is checked and a short read stops the chain (`je 0x70e9b`).
**Bytes 14..19 of the 20-byte file are never read.**

Shipped words: `0x0220 0x0020 0x0007 0x0220 0x0020 0x0007 0x0001`, tail
`00 00 00 00 00 00`. Word 1 (`[0x260C]`) is the sound-driver selector that
becomes `[0x2608]`, the letter `func_07845A` substitutes for `'#'` in
`"#SOUND.COL"` (`cmp byte [si],0x23 … mov [si],al` `@0x78480–0x78489`).
**Opaque:** the meaning of words 0 and 2..6 (their consumers at
`[0x260A]`, `[0x260E..0x2616]` are not traced here) and the unread tail.
The codec (`tools/asset_codecs.py` `config_col_*`) emits the seven words with
their DGROUP destinations and carries the tail verbatim; round trip bit-exact.

Decoded: `data_extracted/data/CONFIG_COL.json`.

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

Loader in VICEROY: `func_01287A` — `mov al,3; mov ah,0x4b; int 0x21`
`@0x128CD–0x128D1` (DOS load-overlay), then its five far entry points are
copied from image `+0x32` via `es:[0x28]` `@0x12946–0x12951`.

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

`tools/asset_codecs.py` `mz_decode` / `mz_encode` (2026-09-02): the standard
28-byte MZ header is parsed into its 13 fields, the relocation table
(`e_crlc` entries at `e_lfarlc`) into `[segment, offset]` pairs, the ID string
at `0x210` is surfaced; **the load image (driver code, music sequence data,
COLDIG index) and the header padding are carried verbatim** (`image_hex`,
`header_pad_hex`). Bit-exact for all four drivers under `tools/verify_assets.py`.
Byte-identity is the only *meaningful* round trip for an executable — the
codec exists so the gate can say which bytes are understood and which are not.

---

## Still open

The music side. Extracting the sequence data and the device synth from these
overlays is a separate, much larger effort than the sample index was — see the
follow-up list in the 2026-08-17 ruling.
