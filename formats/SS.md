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
0       12    magic = "MADSPACK 2.0"   (loader checks first 8 bytes "MADSPACK")
12       2    0x1A 0x00   (end-of-magic)
14       2    section_count (u16, LE)  -- = 4 for a typical .SS
16    10*N    directory: N entries, 10 bytes each
B0    ...     section data -- FIXED START = 16 + 0xA0 reserved block (NOT 16+10*N);
              sections concatenated in directory order, each `packed` bytes.
```

> ⚠ **The section data starts at offset `0xB0` (`16 + 0xA0`)** — a 160-byte reserved
> block follows the directory. (This is the single fact I missed for a long time:
> reading from `16+10*N=56` instead made the directory padding look like "x86 code"
> and hid the `FAB` magic that sits at `0xB0`.)

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

✅ **Compression IS standard FAB — SOLVED 2026-06-20, working decoder in
[`tools/ssdec.py`](../tools/ssdec.py).** Each `flag=1` section (at/after `0xB0`) is a
**FAB stream** beginning with the magic `"FAB"` + a shift byte (observed **0x0C** = 12).
My earlier "no FAB magic / mode-4 mystery" conclusion was **wrong** — it came entirely
from reading sections at the wrong offset (`56` instead of `0xB0`); the `FAB\x0C` magic
is right there at `0xB0`. `tools/ssdec.py` (ported verbatim from the byte-verified
`fab_decompress`/`madspack_load` in `ghidra_export/VICEROY_decompiled.named.c`)
**decodes all 28 `.SS` sheets, every section to its exact `unpacked` size**, the palette
to 768 B, and renders correct sprites (CC-NN = the 25 `@FATHERS` portraits; BUILDING.SS
= 48 building frames). FAB = an LZ77 bitstream (LSB-first 16-bit refill): a `1` bit = one
literal byte; a `0` bit = a back-reference (short: 2 more bits → len 2–5, 1-byte offset;
long: 2-byte offset/len with a `len==0` escape). The `mode` byte (`=4`) is *not* a codec
selector — `flag` alone picks RAW(0) vs FAB(1).

<details><summary>Superseded "not FAB / not locatable" notes (kept for history)</summary>

> Earlier passes claimed the codec was a MADSPACK-internal `mode=4` scheme with "no FAB
> magic", and that the loader was "overlay-resident, not statically locatable / needs a
> dump". **All wrong**, for two compounding reasons: (1) the section data starts at
> `0xB0`, not `56`, so the real `FAB`-prefixed bytes were never examined; (2) the
> `MADSPACK` string lives in the loader overlay's *own* data segment (`DS:0x240A`), so a
> resident-DGROUP xref search found nothing. The strings below have no DGROUP `imm` xref</details>

Original investigation notes (retained): the resident-DGROUP strings `MADSPACK`
`@0x1FDAA`, `BUILDING` `@0x1F891`, `phys0` `@0x1FD70`, `.SS` `@0x1EE64` have **no direct
`imm` xref** (`0xFDAA`/`0xEE64`/`0xFD70` — verified
2026-06-20), so the loader reaches them **indirectly via overlay pointer tables**;
locating the decompressor therefore needs **RTLink overlay/pointer-table tracing**
(`tools/follow_thunk.py` / `tools/find_callers.py`), the deep path this project uses
elsewhere. `flag=0` sections (e.g. CC sheet section 1) are readable raw today.

**Color key**: palette index 0 is transparent. Pixels reading 0 during
blit are skipped.

---

## Reference implementation

> **2026-09-02:** the paragraph below is history. The in-repo decoder is `tools/ssdec.py`
> and the gate is `tools/extract_visuals.py` (rewritten 2026-09-02, REMAINING_WORK.md G7:
> 204/206 sheets, 1,425 frames); `mpskit` never existed in this repo and is no longer
> referenced by any tool. `.SS` files are decode-only (FAB re-encoding is not
> byte-deterministic); `tools/verify_assets.py` checks the container decode.
>
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

**Loader function: LOCATED — `func_076E50_stream_open` (file `0x076E50`, 2026-06-20).**
(My earlier "not statically locatable / needs a dump" claim was **wrong** — corrected.)
The loader is in the overlay `0x0745F0..0x077A6A` (reconstructed in
`viceroy_source/src/overlay/overlay_0745F0_077A6A.c`), and the reason the DGROUP
string-search failed is now clear: **the `"MADSPACK 2.0\x1A"` magic lives in that
overlay's *own* data segment at `DS:0x240A`/`0x2418`, not in the resident DGROUP** — so
there is no `0xFDAA` xref to find. The whole MADSPACK stream subsystem is byte-verified:
- **`func_076E50_stream_open`** — opens the archive: `sprintf` the path, `open`
  (`0x181F:0xE86`) → handle at `obj+0x06`; reads the 16-byte header, **verifies the
  magic via `0x0D1D:0x1084` (`@0x076F26`)**, binds the **entry table (stride `0xA`,
  count at `obj+0x28`)** and sums each entry's size into `obj+0x14` (dword total). This
  confirms the on-disk directory layout in §"High-level structure".
- **`func_0775EC_stream_read_chunked`** (file `0x0775EC`) — buffered chunked transfer:
  primes the section buffer via **`0x0D1D:0xB1C`** (`→ func_0100EC`, the C-runtime
  buffered-stream refill) and copies out via `0x0D1D:0xE9D`, clamping chunks to
  `0xF000`.
- **`func_0776F4_stream_pump`** / **`func_077772_stream_op_dispatch`** drive a
  per-record **callback vtable** (read cb `[0xA644]`, seek cb `[0xA63A]`, table
  `[0x26CA..0x26E0]`); the actual **per-section decode transform** is one of those
  vtable handlers inside the `0x0D1D` library segment.

> ~~**Remaining (bounded library RE, no dump needed):** read the exact byte/bit transform
> in the `0x0D1D` decode vtable handler to write the codec. The codec is the **MADSPACK-2
> `mode=4`** scheme (NOT standalone FAB).~~ **Retired 2026-09-02 (G5):** this paragraph
> contradicted both the working decoder (§"High-level structure": FAB, every section to its
> exact size on all 206 sheets) and the bytes — the section reader `func_077100`
> (`0x1A1F:0xE82`) decompresses via `lcall 0x1a1f,0xeba` `@0x771FE` → `func_0772FA`, which
> selects the FAB handler when the entry's type byte is 1 (`[0x26CA]==1` `@0x773CA`) and
> requires the result to equal the requested size (`cmp [bp-0x24],ax` `@0x77290`). The
> `mode` byte is not a codec selector.

### The .SS loader proper — `func_076642` (byte-verified 2026-09-02, G5)

`func_076642` (file `0x076642`, thunk **`0x1A1F:0x372`**, 10 callers: boot `func_075FB6`
`@0x7615A` cursor / `@0x761E7` woodtile / `@0x76226` parch / `@0x76264` opentile, plus
`@0x72BD0`, `@0x45B02`, `@0x6F6F6`, `@0x6C043`, `@0x6C0DA`). `BX` = name, `AX` = flags
(boot passes `0x4000`); returns `DX:AX` = far pointer to the sheet record. Name handling:
`strcpy` `@0x76677`; if no `'.'` (`push 0x2e … lcall 0xd1d,0xc56` `@0x7667F–0x7668D`) then
`strcat ".SS"` (`push 0x23e6` `@0x76691`; DGROUP `0x23E6` = `".SS"` at file `0x1FD86`);
a leading `'*'` is skipped `@0x766C0–0x766C9`, a leading `"RM"` `@0x766D1–0x766DC`; mode
`"rb"` = `0x23ED` `@0x766FF`. Container open = `func_076E50` `@0x76706` (`0x1A1F:0xE9E`).
Error codes into `[0x23F0]`: `0xFFFF` open failed `@0x7670F`, `0xFFFE` header/frame-table
read failed `@0x76718`/`@0x76852`, `0xFFFC` alloc failed `@0x767EC`.

| Section | Read | Fields the engine uses |
|---|---|---|
| 0 — **0x98-byte sheet header** | `mov ax,0x98; lcall 0x1a1f,0xe82` `@0x76734–0x76738` into `[bp-0x114]` | `+0x00` u8 → `sheet+0x2C` `@0x76916–0x7691D`, and gates the pixel read (`cmp byte [bp-0x114],0` `@0x7677C`/`@0x76A0F`/`@0x76A43`); `+0x02`/`+0x04` u16 → `sheet+0 = (hdr+2 != 0 && hdr+4 < 4)` `@0x76921–0x7693E`, `sheet+2 = hdr+4` `@0x7693E–0x76945`; `+0x06..+0x25` sixteen u16 → `sheet+8..+0x27` (loop `@0x76961–0x76979`); **`+0x0C` must be non-zero** (`cmp word [bp-0x108],0; jne` `@0x7685C`) else fatal dialog `lcall 0x181f,0x772` code `0xFFF9` `@0x7686B–0x76874`; **`+0x26` u16 = frame count** → `sheet+4` `@0x76949–0x7694D` (frame-table alloc `n<<4` `@0x76744–0x7674B`, record `n·12+0x42` `@0x7674E–0x7675B`); `+0x90`/`+0x92` u16 → `sheet+0x28`/`+0x2A` `@0x76951–0x7695D`; **`+0x94` u32 = pixel-section size** (added to the allocation `@0x76783–0x7678D`, read length `@0x76A5C–0x76A62`). Meaning of `+0x02..+0x25`, `+0x90/+0x92` is in the consumers of `sheet+0..+0x2B` — **TBD**, blocker: no consumer read in this pass. |
| 1 — **frame table, 16 B/frame** | `mov ax,[bp-2]` (= n·16) `; lcall 0x1a1f,0xe82` `@0x76845–0x76849` | per frame `i` (`di = i<<4`): `+8,+0xA,+0xC,+0xE` = x, y, w, h → the 12-byte sheet frame entry at `sheet+0x42+12i`, `+4..+0xA` (`mov ax,es:[di+8] … es:[bx+0x46]` … `es:[di+0xe] … es:[bx+0x4c]` `@0x769C9–0x76A04`); `+4` = size, summed into the running data pointer (`add ax,es:[di+4]; lcall 0x1a1f,0xe78` `@0x76A24–0x76A2C` → `func_00E454` far-pointer normalise); `+0` (offset) **not read**. Matches `ssdec.load_sheet` (`<I I h h H H`). |
| 2 — **0x300 palette** | `mov ax,0x300; lcall 0x1a1f,0xe82` `@0x768C4–0x768C8` | read **only when the global palette sink `[0x23F2:0x23F4]` is non-zero** (`mov ax,[0x23f4]; or ax,[0x23f2]; je 0x768d4` `@0x76899–0x768A0`); otherwise skipped by `ftell` + `fseek(packed)` (`lcall 0xd1d,0x9a2` `@0x768DC` … `lcall 0xd1d,0xa3e` `@0x7690E`). |
| 3 — **RLE pixels** | `@0x76A4A–0x76A62`, length `hdr+0x94` | read whole into the record tail when `hdr+0 == 0` and flag bit 2 is clear. RLE opcodes `0xFC..0xFF` are in `ssdec.rle_decode` (ported from the decompile, not re-derived here). |

Shipped values (section 0 of TERRAIN/PHYS0/BUILDING): `00 01 00 00 03 00 …`, `+0x0C = 1`,
`+0x26` = 12 / 154 / 48, `+0x94` = 3372 / 23481 / 35670 = exactly section 3's unpacked size.
`es:[bx+0x3E]` in this loader is a **sheet-record word zeroed at init** (`mov es:[bx+0x3e],ax`,
`ax=0`, `@0x76812`, among `+0x2E..+0x40` `@0x7680C–0x76832`), not a file field; what later
writes it is TBD (blocker: the sheet-record consumers have not been traced from here).

**`WIN-FWRK.SS`** (the declared failure of `tools/extract_visuals.py`): its section 2 is
**104 bytes** (not a palette), its header `+0x0C` is **0** (the fatal-dialog case above),
and the name occurs in **none** of VICEROY / OPENING / CLOSING / MAPEDIT / COLONIZE.EXE
(string census 2026-09-02). Which program loads it, and what its section 2 is, are TBD.

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
