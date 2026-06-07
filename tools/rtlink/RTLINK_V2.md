# VICEROY.EXE — RTLink(R)/Plus VERSION 2 structure

This documents the confirmed RTLink/Plus **Version 2** (Rex-Nebular flavour:
embedded overlay segments, no `.OVL`) structure of `COLONIZE/VICEROY.EXE`
(494,910 bytes, sha256 `a17ed64c…`), and the model the decoder in
`rtlink_decode.py` uses to resolve overlay code.

Everything below is byte-verified against the raw EXE. Fields whose meaning is
not byte-confirmed are explicitly labelled **TBD**; nothing here is guessed.

---

## 1. MZ header (file 0x00)

| Field | Offset | Value | Note |
|-------|--------|-------|------|
| signature | 0x00 | `MZ` | |
| relocation count | 0x06 | **2260** | |
| header paragraphs | 0x08 | **576** | `codeOffset = 576<<4 = 0x2400` |
| entry IP | 0x14 | **0x071D** | |
| entry CS | 0x16 | **0x110D** | runtime/load-image entry |
| reloc table offset | 0x18 | **0x1E** | 2260 × 4-byte (off,seg) entries follow |

`codeOffset = 0x2400` is the file offset of paragraph 0 of the load image; all
segment arithmetic below is relative to it.

### RTLink marker strings

| Marker | File offset | Use |
|--------|-------------|-----|
| `RTLink` | **0x1A25D** | identifies the image as RTLink-linked |
| `Enter directory for $` | **0x1A5B7** | immediately precedes the thunk table |
| `MS Run-Time` | **0x1D9A8** | start of static data segment = this − 8 |

`DGROUP` image base = `0x1D9A8 − 8 = 0x1D9A0`. (The string-data rule used
elsewhere in this project, `file_offset = handle + 0x1D9A0`, is consistent
with this.)

---

## 2. Segment list (file 0x192F0)

A table of **32-byte records**, one per dynamically loaded overlay segment.
VICEROY has **31 records**, with `segmentNum` incrementing **2 … 32**.

Record layout (only the confirmed fields):

| Field | Offset in record | Type | Meaning |
|-------|------------------|------|---------|
| `loadSegment` | +0x00 | word | in-memory load paragraph (low 16 bits) |
| (TBD) | +0x04 | dword | unused/zero in VICEROY — **TBD** |
| `headerOffset` | +0x08 | dword | file offset of this segment's header |
| `segmentNum` | +0x0E | word | incrementing id (2,3,4,…); **not** an index |
| (padding) | +0x10..+0x1F | 16 bytes | zero in VICEROY |

Example record #0 (`@0x192F0`):
```
00000000 d1030000 70060200 0000 0200 0000000000000000 00000000
^loadSeg ^TBD     ^hdrOff  ^pad ^seg#2  ^16-byte zero padding
=0x0000  =0x03d1  =0x20670       =2
```

### How the list is located — VICEROY DEVIATION

The textbook V2 detector scans relocations for one whose **offset == 0**, then
expects the segment list at `relocFileOffset + 48`, validating that the
`segmentNum` words there read 2 then 3.

In VICEROY the matching zero-offset relocation is at file **0x192B0**
(`off=0, seg=0x16EB`), but the segment list starts at **0x192F0**, i.e.
**+64**, not +48. The 16 bytes between (`0x192E0..0x192EF`) are zero.

`rtlink_decode.py` handles this by probing candidate deltas `{48, 64}` after
each zero-offset relocation, and — failing that — brute-scanning the whole
file for the `segmentNum = 2,3,4` signature at stride 32. VICEROY is caught by
the `+64` probe; the brute-scan also independently lands on `0x192F0`.

---

## 3. Per-segment header (at each `headerOffset`)

| Field | Offset | Type | Meaning |
|-------|--------|------|---------|
| `segParagraphs` | +0x00 | word | total paragraphs (header + code) |
| `hdrParagraphs` | +0x02 | word | header paragraphs |
| (TBD) | +0x04 | word | small value, purpose **TBD** |
| `relocationStart` | +0x06 | word | **== 0** in V2 |
| `numRelocations` | +0x08 | word | count of internal relocations |
| relocations | +0x0A | `numRelocations × (off word, seg word)` | segment-internal fixups |

Derived:
- `codeOffset = headerOffset + hdrParagraphs × 16`
- `codeSize   = (segParagraphs − hdrParagraphs) × 16`

Example header for `segmentNum 2` (`@0x20670`):
```
5804 8700 bc02 0000 0f02 …
^0x458 ^0x87 ^0x2bc ^relStart=0 ^numReloc=0x020F (527)
codeOffset = 0x20670 + 0x87×16 = 0x20EE0
codeSize   = (0x458 − 0x87)×16 = 0x3D10
```

---

## 4. The page-id model (overlay resolution)

This is the key for resolving thunk targets to file offsets.

> **`page_id = segment_list_index + 1 = segmentNum − 1`**
> **`target_file_offset = segments[page_id − 1].codeOffset + offset_in_segment`**

A type-A thunk carries a trailer word equal to this `page_id`. Page `0x10`
(=16) therefore selects segment-list **index 15** (`segmentNum 17`), whose
`codeOffset` is `0x5AF70`. Verified end-to-end below.

### Confirmed segment / page map

| idx | page | seg# | loadSeg | headerOff | codeOff | codeSize | #reloc |
|----:|:----:|----:|:-------:|----------:|--------:|---------:|-------:|
| 0 | 0x01 | 2 | 0x0000 | 0x20670 | 0x20EE0 | 0x3D10 | 527 |
| 1 | 0x02 | 3 | 0x0000 | 0x24BF0 | 0x25900 | 0x7200 | 826 |
| 2 | 0x03 | 4 | 0x0040 | 0x2CB00 | 0x2CFD0 | 0x2B20 | 296 |
| 3 | 0x04 | 5 | 0x0040 | 0x2FAF0 | 0x30550 | 0x6440 | 652 |
| 4 | 0x05 | 6 | 0x0040 | 0x36990 | 0x37340 | 0x4040 | 608 |
| 5 | 0x06 | 7 | 0x0040 | 0x3B380 | 0x3B900 | 0x3160 | 340 |
| 6 | 0x07 | 8 | 0x0040 | 0x3EA60 | 0x3ECF0 | 0x1400 | 152 |
| 7 | 0x08 | 9 | 0x0040 | 0x400F0 | 0x404B0 | 0x2420 | 228 |
| 8 | 0x09 | 10 | 0x0000 | 0x428D0 | 0x42C50 | 0x17B0 | 214 |
| 9 | 0x0A | 11 | 0x0000 | 0x44400 | 0x44540 | 0x16E0 | 70 |
| 10 | 0x0B | 12 | 0x0000 | 0x45C20 | 0x45D00 | 0x0900 | 43 |
| 11 | 0x0C | 13 | 0x0000 | 0x46600 | 0x46DE0 | 0x4C70 | 492 |
| 12 | 0x0D | 14 | 0x0000 | 0x4BA50 | 0x4C1F0 | 0x7350 | 477 |
| 13 | 0x0E | 15 | 0x0000 | 0x53540 | 0x53820 | 0x2A90 | 171 |
| 14 | 0x0F | 16 | 0x0040 | 0x562B0 | 0x56A10 | 0x3F40 | 461 |
| 15 | **0x10** | 17 | 0x0000 | 0x5A950 | **0x5AF70** | 0x37D0 | 382 |
| 16 | 0x11 | 18 | 0x0000 | 0x5E740 | 0x5E9B0 | 0x1120 | 145 |
| 17 | 0x12 | 19 | 0x0040 | 0x5FAD0 | 0x5FE60 | 0x1E40 | 218 |
| 18 | 0x13 | 20 | 0x0000 | 0x61CA0 | 0x61E10 | 0x15D0 | 79 |
| 19 | 0x14 | 21 | 0x0040 | 0x633E0 | 0x63880 | 0x2E00 | 285 |
| 20 | 0x15 | 22 | 0x0040 | 0x66680 | 0x66850 | 0x2130 | 105 |
| 21 | 0x16 | 23 | 0x0040 | 0x68980 | 0x68EE0 | 0x2C20 | 332 |
| 22 | 0x17 | 24 | 0x0000 | 0x6BB00 | 0x6BE50 | 0x3A00 | 201 |
| 23 | 0x18 | 25 | 0x0000 | 0x6F850 | 0x6F8E0 | 0x0260 | 24 |
| 24 | 0x19 | 26 | 0x0040 | 0x6FB40 | 0x6FDF0 | 0x16A0 | 162 |
| 25 | 0x1A | 27 | 0x0040 | 0x71490 | 0x72090 | 0x4340 | 757 |
| 26 | 0x1B | 28 | 0x0040 | 0x763D0 | 0x764D0 | 0x08A0 | 51 |
| 27 | 0x1C | 29 | 0x0040 | 0x76D70 | 0x76E50 | 0x0A30 | 43 |
| 28 | 0x1D | 30 | 0x0000 | 0x77880 | 0x77990 | 0x0470 | 58 |
| 29 | 0x1E | 31 | 0x0040 | 0x77E00 | 0x77ED0 | 0x06D0 | 42 |
| 30 | 0x1F | 32 | 0x0040 | 0x785A0 | 0x78640 | 0x0700 | 30 |
| — | DATA | — | 0x1B5A | 0x1D9A0 | 0x1D9A0 | 0x2CD0 | (DGROUP) |

Total overlay code ≈ `0x52CA0` bytes across 31 segments. `loadSegment` is
either `0x0000` or `0x0040`; segments sharing a `loadSegment` value are mapped
to the same memory window by the runtime and paged in on demand (multiple
overlay segments alias the same physical paragraphs — this is why the
load-image cannot far-call them directly and must go through the thunks).

---

## 5. Thunk table (file 0x1A5F0 … ~0x1D610)

The resident far-call thunk table. **1023 thunks** total
(**658 type-A**, **365 type-B**). It begins at the first `0x9A` byte after the
`Enter directory for $` marker (file 0x1A5F0).

### Three overlapping addressing windows

Load-image `LCALL <seg>:<off>` instructions reach the table through three
far-segment windows whose bases are `codeOffset + seg<<4`:

| Window seg | Base file offset |
|------------|------------------|
| `0x181F` | 0x1A5F0 |
| `0x191F` | 0x1B5F0 |
| `0x1A1F` | 0x1C5F0 |

So a disasm `LCALL 0x1A1F:0x06E0` targets file `0x2400 + 0x1A1F0 + 0x6E0 =
0x1CCD0`. The windows overlap (each is 0x1000 apart) so any thunk in the table
is reachable from at least one window.

### Thunk record shapes

**Type A** (overlay call — `LCALL 0x110D:0x0DAB`):
```
9A AB 0D 0D 11   ; LCALL 0x110D:0x0DAB  (runtime overlay loader, "with page-id")
EA <off16> <seg16> ; JMPF  overlay target; seg16 = 0 (runtime-patched at load)
<page16>         ; trailer word = page-id (= segmentNum − 1)
```
**Type B** (`LCALL 0x110D:0x0D91`): a call into code that's already resident /
needs no page translation. Parsed with `segment_index = −1` (no page);
faithful to the documented V2 rule (`segment != 0` **or** next byte `0x9A`
⇒ no translation). 365 of these.

Thunk records are **variable length** (10/12/14 bytes, with a few 16/20/24-byte
records at the tail). The decoder advances deterministically using the V2
disambiguation logic, *not* a byte-scan-to-next-`0x9A` heuristic (which would
desync on `0x9A` bytes inside operands).

### The validation thunk

File **0x1CCD0** (= window `0x1A1F:0x06E0`):
```
9a ab 0d 0d 11   ea 52 03 00 00   10 00
LCALL 110D:0DAB  JMPF 0000:0352    page 0x10
```
→ page `0x10` → segment index 15 → `codeOffset 0x5AF70` → `+0x0352` →
**file 0x5B2C2 = `func_05B2C2`** (opens `c8 3a 00 00` = `ENTER 0x003A`).

`func_05CA7E` (opens `c8 de 00 00` = `ENTER 0x00DE`) is in the same page 0x10
at `offset_in_segment = 0x5CA7E − 0x5AF70 = 0x1B0E`.

---

## 6. Using the tool

```bash
# Full segment list + thunk sample, and write the machine-readable map:
python rtlink_decode.py info --json viceroy_rtlink_map.json

# Resolve a (page-id, offset-in-segment) pair to a file offset:
python rtlink_decode.py resolve 0x10 0x0352      # -> 0x5B2C2 (func_05B2C2)
python rtlink_decode.py resolve 0x10 0x1B0E      # -> 0x5CA7E (func_05CA7E)

# Best-effort flat EXE + authoritative page->file-offset map JSON:
python rtlink_decode.py flatten --out VICEROY_flat.exe --map VICEROY_flat.map.json

# Run the built-in byte self-checks:
python rtlink_decode.py validate
```

`flatten` lays every overlay segment out contiguously and rewrites each
type-A thunk's `JMPF` segment operand to its flat paragraph. It deliberately
does **not** rebuild the MZ relocation table for the relocated overlay
segments (the spec flags that as the risky step), so the flat EXE is an
analysis aid; the emitted JSON page map is the authoritative artifact.

---

## 7. Summary of deviations from the generic V2 spec

1. **Segment-list offset is +64, not +48** from the zero-offset relocation
   site (file 0x192B0 → list at 0x192F0; 16 zero bytes between). All other V2
   structures (record layout, header layout, thunk shapes, the
   `page = segmentNum − 1` model) match exactly.
2. Segment-list records have **16 bytes of zero padding** after the confirmed
   fields (offsets +0x10..+0x1F). The dword at record +0x04 and the word at
   header +0x04 are present but their meaning is **TBD**.
3. **Overlay page 0x1A packs TWO load-segments (KNOWN LIMITATION).** The
   segment-list entry for page 0x1A gives code_offset 0x72090 (1st segment,
   the menu builder func_072090), but page 0x1A also contains a SECOND segment
   whose code base is **0x73270** (func_073270). Thunks that target the second
   segment — e.g. the savegame drivers `0x1A1F:0xCF6`→func_0734F8 and
   `0x1A1F:0xD12`→func_073BB0 — resolve against **0x73270**, NOT 0x72090.
   So `resolve 0x1A <off>` is correct only for the FIRST segment; for the save/
   load drivers compute `0x73270 + off` (verified 0x73270+0x288=0x734F8 ENTER,
   +0x940=0x73BB0 ENTER). A proper fix is to split page 0x1A into two segment
   entries in the parser (TODO); until then use the 0x73270 base for page-0x1A
   second-segment targets. (Found wave-10 while decoding the save serializer.)

   **GENERALIZED (wave-11):** page 0x1A is just the visible instance. The true
   target of ANY thunk is `code_offset(page) + (ljmp_seg << 4) + offset_in_segment`,
   where `ljmp_seg` is the JMPF segment word already retained in the map JSON. The
   bare `resolve <page> <off>` (which omits the `ljmp_seg<<4` term) is correct ONLY
   for the **506** thunks with `ljmp_seg == 0`; the **152** nonzero-`ljmp_seg`
   thunks need the extra term (page 0x1A's second segment = `ljmp_seg 0x11E` →
   0x72090 + 0x11E*16 = 0x73270). Under the general formula, 578/658 type-A thunks
   land on clean ENTER/PUSH-BP prologues (the rest are legit mid-function tail-call
   entries). TODO: fold `(ljmp_seg<<4)` into `resolve`/map target computation.

Validated: 2026-05-30 against `COLONIZE/VICEROY.EXE`. All 17 `validate`
self-checks pass; 6 thunks cross-checked byte-for-byte against the raw EXE.
