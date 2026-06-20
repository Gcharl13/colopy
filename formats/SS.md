# .SS — MicroProse MADS Sprite Sheet Format

The variable-size sprite-sheet format used throughout VICEROY.EXE,
MAPEDIT.EXE, OPENING.EXE, and CLOSING.EXE.

**206 .SS files in COLONIZE/** total. See
[MANIFEST.md](../MANIFEST.md) and
[`assets/sprites/SPRITE_CATALOG.md`](../assets/sprites/SPRITE_CATALOG.md)
for the per-file role catalog.

---

## High-level structure

```
offset  size  field
0       12    magic = "MADSPACK 2.0"
12       2    0x1A 0x00   (end-of-magic)
14       2    section_count (u16, LE)  -- = 4 for a typical .SS
16    10*N    directory: N entries, 10 bytes each
...           section data (in directory order), each `packed` bytes
```

**Directory entry layout — BYTE_VERIFIED 2026-06-20** (10 bytes each):
```
byte 0    flag    0 = stored RAW,  1 = COMPRESSED
byte 1    mode    compression id (observed = 4 for every .SS section)
byte 2..5 u32     unpacked_len (decompressed size)
byte 6..9 u32     packed_len   (bytes of section data on disk)
```
Example (`BUILDING.SS`, verified): 4 entries —
`(1,4,152,39) (1,4,768,502) (1,4,768,437) (1,4,35670,19836)`; data begins at
offset 56 and the four sections are concatenated in order. `CC-00.SS`/`CC-12.SS` share
identical sections 0–2 `(1,4,152,39)(0,4,16,16)(1,4,768,745)` (a common sprite header),
differing only in section 3 (pixels) — confirming these are genuine sprite sheets.

The **4 sections** of a typical .SS:
- Section 0: sprite header (152 B; identical across sheets)
- Section 1: per-sprite descriptor table (16 B raw on CC sheets, `flag=0`)
- Section 2: **palette — 768 B = 256 RGB triples** (decompressed)
- Section 3: pixel data (color-keyed, indexed-color; the bulk)

⚠ **Compression is the MADSPACK-2 *internal* codec (`mode=4`), NOT the standalone
ScummVM "FAB" format — BYTE_VERIFIED 2026-06-20.** Compressed sections carry **no `FAB`
magic and no shift byte** (ScummVM's `FabDecompressor` requires `"FAB"`+shift 10–13;
neither is present, and `mode=4` is out of FAB's shift range). So the per-section codec
must be RE'd from the `.SS` loader in `VICEROY.EXE` (strings present: `MADSPACK`
`@0x1FDAA`, `BUILDING` `@0x1F891`, `phys0` `@0x1FD70`, `.SS` `@0x1EE64`). **None of
these three strings has a direct `imm` xref** (`0xFDAA`/`0xEE64`/`0xFD70` — verified
2026-06-20), so the loader reaches them **indirectly via overlay pointer tables**;
locating the decompressor therefore needs **RTLink overlay/pointer-table tracing**
(`tools/follow_thunk.py` / `tools/find_callers.py`), the deep path this project uses
elsewhere. `flag=0` sections (e.g. CC sheet section 1) are readable raw today.

**Color key**: palette index 0 is transparent. Pixels reading 0 during
blit are skipped.

---

## Reference implementation

> ⚠ **TOOLING ABSENT (verified 2026-06-20):** the `mpskit` decoder referenced below
> (`tools/mpskit/ss.py`, `madspack.py`, `fab.py`) **is not present in this repo**, and
> the **FAB (LZ-variant) bitstream is not documented** here. The MADSPACK container is
> parseable (14-byte `MADSPACK 2.0\x1A` header → `04 00` = 4 sections → per-section
> `flag(1) mode(1) unpacked_len(u32) packed_len(u32)` + data), but **every `.SS` section
> is FAB-compressed (flag `01`)**, so the descriptor table and pixels stay unreadable
> until a FAB decoder is implemented (RE the codec from the `.SS` loader in `VICEROY.EXE`,
> still TBD below). `tools/extract_visuals.py` shells out to the missing `mpskit` and so
> silently emits **0 frames**. This blocks the BUILDING.SS / CC-NN pixel catalog
> (`notes/SPRITE_CATALOG.md`).

The byte-level format is implemented in
[`mpskit/ss.py`](../../tools/mpskit/ss.py) and uses
[`mpskit/madspack.py`](../../tools/mpskit/madspack.py) +
[`mpskit/fab.py`](../../tools/mpskit/fab.py) for the underlying
container + compression.

mpskit exposes both directions:
- `mpskit ss unpack <file.SS>` — emits per-sprite PNGs + JSON metadata
- `mpskit ss pack <file.SS>` — re-encodes from extracted PNGs

**Round-trip caveat**: FAB compression is non-deterministic at the bit
level — re-encoded .SS files don't byte-match the original. The
**lossless decoded round-trip** criterion applies: extract → re-encode
→ re-extract produces identical PNGs.

For byte-perfect verification of original assets, use
`tools/verify.py` which uses the byte-identity round-trip from the
golden manifest.

---

## Loader in VICEROY.EXE

The .SS loader function reads a filename string, calls fopen/fread,
decompresses each section, and stores sprite descriptors in a
SpriteSheet record at a DGROUP location.

**Loader function: NOT statically locatable — it lives in an RTLink overlay
(investigated 2026-06-20).** A bounded static search ruled out the resident-image
anchors and the string-xref routes:
- `func_0749E0` (the hinted "scenario loader") and its `0x191F:0x928` callee are a
  **config/INI text parser** (comma-separated `fgets`-style line reader, buffers at
  `[0x833C]`/`[0xA5B8]`), **not** the binary `.SS` loader.
- The asset-format strings have **zero real instruction references** in the resident
  image: `MADSPACK 2.0` (`@DGROUP 0xFDAA`/`0xFDB8`), `PIK` (`0xFD9A`), `rb` (`0xF80E`/
  `0xF9F5`) — every apparent hit is a coincidental `mov ax,imm`/`jmp`/`add` byte
  collision (verified by disassembling each). No `imm`/near-pointer loads these offsets.
- Conclusion: the binary loader + the **mode-4 section decompressor** are reached
  through RTLink overlay far-pointer indirection and are **not addressable by offset
  search** in the flat image.

A **second pass (2026-06-20)** using the reconstructed overlay map
(`tools/rtlink/viceroy_rtlink_map.json`, 31 segments) + the named disassembly also did
**not** isolate the decompressor: `func_0749E0`/`0x191F:0x928` are config-text parsers;
`func_008F2A` ("unpack nibble") is a game-data nibble accessor, not MADSPACK; the
`load_asset` path cited in `docs/COLONY_RENDERER_DECODED.md` lands in the command
dispatcher and its file offsets use a **different base** than the raw EXE in the
low/runtime region (`cs:[…]` indirect-call code). So the loader genuinely needs
methodical per-overlay reconstruction (with offset-base reconciliation) or a dynamic trace.

**To finish the decoder**, one of: (a) reconstruct the RTLink overlay map (resolve
each overlay's load segment + relocations, then disassemble the overlay that owns the
loader), or (b) dynamically trace the running game (DOSBox) at the `.SS` fopen. The
codec is the **MADSPACK-2 `mode=4`** scheme (NOT standalone FAB; §"Reference
implementation"). **Do not guess it** — a candidate decoder is only valid if it expands
every section to exactly its directory `unpacked_len` across all 26 sheets.

---

## Extraction outputs

For `<NAME>.SS`:
- `assets/sprites/<NAME>/<NAME>.SS.NNN.png` — one PNG per sprite frame
- `assets/sprites/<NAME>/<NAME>.SS.NNN.json` — frame metadata
- `assets/sprites/<NAME>/<NAME>.SS.json` — sheet-level metadata
- `assets/sprites/<NAME>/<NAME>.SS.pal.png` — embedded palette swatch
- `assets/sprites/<NAME>/loader.json` — sidecar (loader_function,
  loader_offset, sha256, format_spec)

---

## Sprite role catalog

See [`assets/sprites/SPRITE_CATALOG.md`](../assets/sprites/SPRITE_CATALOG.md)
for the per-sheet role table. The detailed sprite-to-role mapping
(per-frame: "this is a soldier walking north") is in
`assets/sprites/SPRITE_ROLE_CATALOG.md` (Phase CV7 deliverable).
