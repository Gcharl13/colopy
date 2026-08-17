# .BIN — Digital Sample Bank

**1 .BIN file in COLONIZE/**: `COLDIG.BIN` — 993,755 bytes.

A headerless concatenation of **8-bit unsigned PCM, mono**. The file itself
carries no index: the per-sample (offset, length) table lives inside the four
sound **driver** overlays (`?SOUND.COL` — see `formats/COL.md`) and is
byte-identical in all four.

Decoded 2026-08-17 — see `notes/rulings/RULINGS.md` for the full byte
citations. `tools/decode_coldig.py` re-derives everything below from
`raw/COLONIZE/` on every run; the committed decode is
`data_extracted/coldig_index.json`, and `cport/data/colopy_sfx.{h,c}` is the
generated C-port table.

---

## Index table

| Driver | table @ file | @ load |
|---|---|---|
| `ASOUND.COL` | `0x0039F` | `0x019F` |
| `GSOUND.COL` | `0x01E7B` | `0x1C7B` |
| `PSOUND.COL` | `0x021A3` | `0x1FA3` |
| `RSOUND.COL` | `0x01F01` | `0x1D01` |

Each image loads at file `0x200`, so load = file − `0x200`.

```
struct { uint32 offset; uint32 length; }   /* little-endian, stride 8 */
```

The driver's own walker (the `FIND`-labelled `FINDWV` routine, `ASOUND.COL`
`@0x00D39`) stops on a **zero-length** row:

```
8D 36 9F 01   lea si,[0x19F]      ; table base
8B 5C 04      mov bx,[si+4]       ; length lo
0B 5C 06      or  bx,[si+6]       ; length hi  -> 0 = terminator
74 1B         je  done
...
83 C6 08      add si,8            ; stride
```

So the table holds **35 samples** plus a terminator whose offset field is
`0x0F29DB`.

### Why the decode is certain

Three independent checks, all fatal in the tool:

1. the 35 lengths sum to **exactly 993,755** = `len(COLDIG.BIN)`;
2. offsets are fully contiguous — `offset[i+1] == offset[i] + length[i]`;
3. `offset[0] == 0` and the terminator lands on the end of the file.

A wrong base or stride cannot satisfy all three at once.

---

## Sample rate — two rates, not one

The play-by-index entry (`ASOUND.COL` `@0x00F28`) selects the rate from the
index before it fetches the descriptor:

```
B9 6A 4A      mov cx,0x4A6A       ; 19050 Hz
83 FB 05      cmp bx,5
72 03         jb  keep
B9 11 2B      mov cx,0x2B11       ; 11025 Hz
```

**Indices 0..4 play at 19050 Hz; 5..34 at 11025 Hz.** Sites: ASOUND `@0x00F19`,
GSOUND `@0x029EC`, PSOUND `@0x02D20`, RSOUND `@0x02A7E`. (The pre-2026-08-17
"~11025 Hz throughout" note in this file was an assumption, now corrected.)

---

## Sound id → sample index

VICEROY.EXE plays effects by **id**, not by index: ids `0x40..0x5D` reach the
driver's id dispatcher (`ASOUND.COL @0x01C35`), which bounds-checks
`cmp bx,0x5D; ja` and jumps through a word table at file `0x01DB9`. Each SFX
handler is a literal `mov ax,<index>` before the call into the player, so the
mapping is read directly out of the bytes:

| id | idx | id | idx | id | idx | id | idx | id | idx |
|---|---|---|---|---|---|---|---|---|---|
| `0x40` | 31 | `0x46` | — | `0x4C` | 14 | `0x52` | 12 | `0x58` | 21 |
| `0x41` | 32 | `0x47` | — | `0x4D` | 10 | `0x53` | 19 | `0x59` | — |
| `0x42` | 30 | `0x48` | 29 | `0x4E` | 6 | `0x54` | 13 | `0x5A` | — |
| `0x43` | 27 | `0x49` | 34 | `0x4F` | 11 | `0x55` | 20 | `0x5B` | 22 |
| `0x44` | 18 | `0x4A` | 28 | `0x50` | 7 | `0x56` | 9 | `0x5C` | 8 |
| `0x45` | 17 | `0x4B` | 33 | `0x51` | 5 | `0x57` | 16 | `0x5D` | — |

"—" = the id is handled some other way, not by playing a sample. The VICEROY
side gates these on the SOUND EFFECTS option `[0xA4]` before
`lcall 0x181F:0x4C0` (manual §24.5); note the gate tests bit `0x40` (so it
speaks of `0x40–0x5F`) while the driver's own table stops at `0x5D`.

---

## Cue sites in VICEROY.EXE

The game plays a sound with `mov ax,<id>` + `lcall 0x181F:0x4C0`
(`9A C0 04 1F 18`). That call occurs **exactly 40 times**; **36** carry a
literal id in the three bytes before it, and **4** compute it at runtime (one
is the Sound Test cheat). Where the cue belongs to a message emit the key
string is pushed inside the same block, so the EXE names the event — the
DGROUP→file delta is pinned by push `0x1B94` == `"RAIDSTORES"` @`0x1F534`.

Twelve sites name their event: `0x54` `REFIT` @`0x2F1CD`, `0x56` `TEAPARTY`
@`0x346F6`, `0x3F` (tune) `INTERVENE` @`0x3D7B1`, `0x8024` (fanfare)
`HERESY0` @`0x48EB7`, `0x53` `HERESY1` @`0x48EE6`, `0x55` `CHIEFKILL`
@`0x4AB9E`, `0x4F` `RAIDSTORES` @`0x5C3C2`, `0x53` `RAIDBURN` @`0x5C501`,
**`0x4B` then `0x4D`** `RAIDSHIP` @`0x5C569`/@`0x5C571` (a pair), `0x4E`
`RAIDGOLD` @`0x5C5ED`, `0x5B` `RAIDNOTHING` @`0x5C62D`.

`tools/decode_coldig.py` writes the whole 40-site inventory to
`data_extracted/coldig_index.json` under `cue_sites`.

---

## The audio branch's empirical slice map is SUPERSEDED

The 2026-08-16 audio milestone located each effect inside `COLDIG.BIN` by
cross-correlating per-id DOSBox captures against the bank, and committed the
result as `data_extracted/data/coldig_slices.json`, labelled "empirical
capture — NOT byte-cited". Its own note said the index "sits in the loaded
driver's data segment, which is not decoded".

That is no longer true: the table is in the overlay image and is decoded above.
The two disagree on **all 21 shared ids** — offsets drift by up to 61,992 bytes
(id `0x50` correlates onto the wrong sample entirely) and lengths run
consistently short, clipping decay tails. Four ids the milestone shipped as FM
renders — `0x4D`, `0x4E`, `0x4F`, `0x5B` — the driver's own dispatcher sends to
real bank samples.

Per `notes/TRUTH_HIERARCHY.md` the byte-read table wins, and it is exact by
construction: the 35 lengths sum to exactly 993,755 = the file size, the offsets
are fully contiguous, and the terminator lands on the end of the file. A
correlation cannot beat that. `tools/gen_audio_pack.py` therefore slices from
`data_extracted/coldig_index.json`; `coldig_slices.json` is kept only as the
capture record that named the effects.

## Still open

- **Names.** No name strings for the samples exist in the drivers; labelling
  them needs a DOSBox listen-and-label pass. TBD.
- **The rest of the cue map.** All 40 call sites are enumerated above, but only
  12 name their event; the other 28 emit no key in the block, so naming them
  needs the enclosing routine identified. TBD, and NOT guessed.
- **Indices 0..4, 15, 23, 24, 25, 26** are never referenced by the SFX
  dispatcher. They contain real audio (0..4 are five same-length clips with
  monotonically falling RMS — plausibly a volume/distance ramp) but their
  trigger is TBD.

---

## Round-trip

Byte-identity. `tools/decode_coldig.py --wav` splits the bank into
`extracted/assets/audio/sfx_NN.wav` (regenerable, git-ignored); concatenating
those payloads in index order reproduces the file exactly, since the table is
contiguous and gapless.
