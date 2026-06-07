# Resident Unknowns — the last 5 MISSING inventory entries

**Status of this document:** byte-grounded investigation, no fabrication.
Every claim below is backed by a raw-byte citation into
`reverse_engineered/raw/COLONIZE/VICEROY.EXE` (file offsets, uppercase hex)
or a JSON artifact in this tree. Where a semantic role cannot be cited, it is
marked **TBD**.

---

## TL;DR — these are NOT functions

The decompile-status inventory lists exactly five entries with
`status=MISSING, region=resident` (5 of 1250 rows — confirmed via
`viceroy_source/docs/decompile_status.json`). These are the "only real gaps":

```
0x5651C  0x56694  0x5AC34  0x5AEA0  0x5AF2C
```

**All five are static DATA tables, not executable code.** The linear
disassembler planted a phantom function boundary at each offset because the
first data byte is `0xC8`, which it decoded as the `ENTER` opcode
(`C8 nn 00 00` → "ENTER nn, 0"). In reality `C8 nn 00 00` is just the first
two little-endian 16-bit values of a numeric table (low value `0x_C8`, then
high byte `nn`). The "ENTER 2 / 0xE / 0x2E / 0x32 / 0x19" prologues noted in
the task brief are a coincidence of that mis-decode.

### Five independent proofs (all byte-cited)

1. **Nothing calls them.** None of the five file offsets appears in
   `viceroy_source/all_call_targets.json` as a `near_call_targets[].ip` nor
   resolves from any `lcall_targets[]` (`seg*16+off`). A function with zero
   callers across a 1241-function corpus, sitting between two well-formed
   functions, is the signature of inline data.

2. **No global accesses.** `code/VICEROY/per_func_globals.json` → `per_func`
   has **no entry** for any of the five (`<absent>`). The global-reference
   pass that catalogued every real function from `0x002400` upward skipped
   all five — they contain no recognizable memory operands.

3. **They live past the relocated image.** The MZ relocation table
   (2260 entries) spans file offsets `0x2417 .. 0x204D8`. All five tables sit
   far beyond that (`0x5651C+`), inside the overlay-appended tail of the
   RTLink/Plus image. The disasm header label `Region: overlay` is correct;
   the `region:"resident"` tag in `decompile_status.json` is a mislabel for
   these tail offsets.

4. **No relocations inside the tables.** Zero relocation entries fall within
   any of the five byte ranges. Therefore the 16-bit words they contain are
   **literal data**, not relocatable segment addresses — they are not a
   far-pointer/jump table of code addresses. (See the `0x037F` note below.)

5. **The bytes decode as uniform 4-byte value records, not instructions.**
   Disassembling past the fake `ENTER` yields nonsensical instruction soup
   (`OUT`, `IN`, `INT1`, `HLT`, `SLDT`, `POPAW`, endless
   `ADD byte ptr [bx+si], al` from `00 00` filler). Re-read as
   `(u16 value, u16 tag)` records, every table is clean: small integers in a
   bounded `0 .. ~14300` range, with the high word almost always `0x0000`.

### Neighborhood = the unit-system overlay

Both clusters are embedded among **UnitRecord** logic
(table base `DGROUP:0x3144`, stride `0x1C` — see
[DATA_MODEL.md §3](DATA_MODEL.md#3-unit-record--28-bytes-0x1c)):

- `func_056A10` (right after the `0x5651C`/`0x56694` pair) loads the active
  selection pointer `[0x8542]`, loops 8 neighbours, and reads
  `byte ptr [bx+0x3147] & 0x0F` (UnitRecord +0x03 type nibble) — a
  tile/unit scan. Entry byte-cited at file `0x056A10`
  (`8B 1E 42 85` = `MOV bx,[0x8542]`).
- `func_05AF70` (right after the `0x5AEA0`/`0x5AF2C` pair) does
  `IMUL bx, ax, 0x1C` then reads UnitRecord `+0x00 [0x3144]`,
  `+0x01 [0x3145]`, `+0x02 [0x3146]` — UnitRecord field access. Entry
  byte-cited at file `0x05AF70` (`6B D8 1C` … `8A 87 44 31`).
- `func_05B0DC` (same segment) reads UnitRecord `+0x03` and `+0x0C`, the
  **AIPersonality** table (`IMUL bx,..,0x34` then `[bx+0x543F]`, i.e.
  base `0x540E` + `0x31`), and a 16-column lookup `[bx+di-0x7B44]` with
  `di = type<<4`. Byte-cited at file `0x05B0DC`.

So the five tables are **static data located among unit-system overlay code**.
Their precise semantic role (coordinate offsets? per-type lookup? draw data?
loader metadata?) is **TBD** — not byte-confirmed — and is deliberately NOT
guessed here.

**Deeper dig (2026-05-30) — narrows the location, rules out one theory:**
- **They sit in inter-segment GAPS of the overlay image**, not inside any mapped
  code segment's `[code_offset, code_offset+code_size)` range (checked against
  all 31 segments in `tools/rtlink/viceroy_rtlink_map.json`). The `0x56694` table
  trails the segment that ends exactly at `0x56A10`, where the next overlay
  segment (list_index 14 / page 0x15, base `code_offset=0x56A10`) begins with
  `func_056A10`. DGROUP data ends far earlier at file `0x20670`
  (`data_segment.code_offset 0x1D9A0 + code_size 0x2CD0`), so these are NOT
  DGROUP globals.
- **RTLink fixup-table theory TESTED and REJECTED.** Hypothesis: `0x56694`'s 54
  `0x037F`-tagged records are loader fixup offsets where segment `0x037F` (a live
  overlay far-call target) gets patched. Test: with the `0x56A10` segment base,
  none of the tagged offsets (508, 770, 968, 351, …) land on a `7f 03` segment
  operand; the offsets are unsorted; and there are 91 image-wide `lcall :0x037F`
  sites (not 54). So it is **not** a simple per-segment fixup table for `0x037F`.
- Net: still DATA, still not game-mechanics, still TBD format. Leading (unproven)
  read is RTLink overlay/loader metadata — which is OUT of the game-logic scope
  ("DOS-specific loaders not necessary"). Do **not** re-chase the simple
  fixup-table theory; if pinned later, find a LEA/MOV of the table's
  segment-relative offset in the segment that PRECEDES `0x56A10`.

### The `0x037F` tag

In `0x56694` the records split into 169 `(value, 0x0000)` followed by
54 `(value, 0x037F)` (`0x037F = 895`; transition at file `0x05691C`).
`0x037F` is also the overlay paragraph used by neighbouring unit code
(`func_05AF70` calls `LCALL 0x037F:0x0358` and `0x037F:0x000A`). Because there
is **no relocation** on these words, `0x037F` here is a literal data
constant/tag, not a live segment selector. Whether it is an incidental match
or a deliberate parallel "(offset, segment-tag)" encoding is **TBD**.

### In-scope verdict (all five)

**Not a function → not portable.** There is no routine to translate into
`src/`. These are data. The correct follow-up is to reclassify them in the
inventory as `DATA` (not `MISSING` functions) and, only once a consuming load
site pins the semantics, emit them as a cited `static const` table in the
owning unit-system source file. Recommended eventual home if/when identified:
`viceroy_source/src/unit/` (the segments are unit logic) — most likely
`move.c` or `chain.c` given the neighbour scans, but **do not** place them
until a byte-cited consumer fixes the meaning. No port performed in this pass.

---

## Per-table detail

All ranges below are `[start .. end)` file offsets; `end` = start of the next
real function in `code/VICEROY/classification.json`. Header dword is the first
four bytes (the bytes mis-read as `ENTER`).

### 0x5651C  (45 bytes → `[0x5651C .. 0x56694)`)

- **Header dword** `0x000002C8` → first two u16s = `712, 0`. The "ENTER 2"
  is byte `0x02` = high byte of `0x02C8 (=712)`. Byte-cite (file `0x05651C`):
  `C8 02 00 00  0B 02 00 00  E7 06 00 00 …`.
- **Shape:** ~11 records of `(u16, 0x0000)`; values `712, 523, 1767, 2238,
  3773, 3751, 3623, …` — bounded small ints, high word `0`.
- **Reads/writes:** none (pure data; no operands, no globals — proof #2).
- **Called by:** nobody (proof #1). Followed immediately by the unit-scan
  table `0x56694` and `func_056A10` (active-unit neighbour scan via
  `[0x8542]`).
- **Verdict:** DATA, role **TBD**. In-scope subsystem = unit (overlay
  neighbour). Not ported.

### 0x56694  (811 bytes → `[0x56694 .. 0x56A10)`)

- **Header dword** `0x00000EC8` → first u16 = `3784`; "ENTER 0xE" = high byte
  of `0x0EC8 (=3784)`. Byte-cite (file `0x056694`):
  `C8 0E 00 00  38 14 00 00  22 14 00 00 …`.
- **Shape:** 223 records of `(u16, tag)`. Tag distribution
  (byte-verified): **169×`0x0000`** then **54×`0x037F`**; the `0x037F` run
  begins at file `0x05691C` (values `508, 770, 968, 351, 1511, …`). Largest
  table of the five.
- **Reads/writes:** none. **Called by:** nobody.
- **Verdict:** DATA (two-segment table, `0x0000` then `0x037F` tag), role
  **TBD**. Sits directly before `func_056A10` (unit neighbour scan). Not
  ported.

### 0x5AC34  (89 bytes counted by the disassembler; the contiguous table runs to `[0x5AC34 .. 0x5AEA0)`)

- **Header dword** `0x00002EC8` → first u16 = `11976`; "ENTER 0x2E" = high
  byte of `0x2EC8 (=11976)`. Byte-cite (file `0x05AC34`):
  `C8 2E 00 00  48 1C 00 00  F5 27 00 00 …`.
- **Shape:** records of `(u16, 0x0000)`; values `11976, 7240, 10229, 4462,
  223, 7774, …` — same bounded `0..~14300` integer family, high word `0`.
- **Reads/writes:** none. **Called by:** nobody.
- **Verdict:** DATA, role **TBD**. First table of the `0x5A` unit cluster
  (`func_05AF70` UnitRecord access, `func_05B0DC` combat/AIPersonality
  lookup). Not ported.

### 0x5AEA0  (140 bytes → `[0x5AEA0 .. 0x5AF2C)`) — contiguous with 0x5AF2C

- **Header dword** `0x000032C8` → first u16 = `13000`; "ENTER 0x32" = high
  byte of `0x32C8 (=13000)`. Byte-cite (file `0x05AEA0`):
  `C8 32 00 00  F1 34 00 00  BB 34 00 00 …`.
- **Shape:** records of `(u16, 0x0000)`; values `13000, 13553, 13499, 13449,
  13375, 13346, …` (note the tight descending run — characteristic of
  sorted/offset data, not code).
- **Contiguity:** `0x5AEA0 + 0x8C = 0x5AF2C` exactly; `0x5AEA0` and `0x5AF2C`
  are **one data region** split by a phantom boundary. The block ends with
  six `(0,0)` records (zero-pad/alignment) just before `func_05AF70`.
- **Reads/writes:** none. **Called by:** nobody.
- **Verdict:** DATA, role **TBD**; physically one array with `0x5AF2C`. Not
  ported.

### 0x5AF2C  (68 bytes → `[0x5AF2C .. 0x5AF70)`) — tail of the 0x5AEA0 array

- **Header dword** `0x000019C8` → first u16 = `6600`; "ENTER 0x19" = high
  byte of `0x19C8 (=6600)`. Byte-cite (file `0x05AF2C`):
  `C8 19 00 00  6C 27 00 00  42 33 00 00 …`.
- **Shape:** a short run of `(u16, 0x0000)` records (`6600, 10092, 13122,
  13714, …`) then `(0,0)` zero-padding to the function boundary at
  `0x05AF70`. This is the tail/last page of the `0x5AEA0` table; the
  disassembler split it off into its own "function" only because the byte at
  `0x5AF2C` is again `0xC8`.
- **Reads/writes:** none. **Called by:** nobody.
- **Verdict:** DATA, role **TBD**; continuation of `0x5AEA0`. Not ported.

---

## Recommended follow-up (no code change made here)

1. **Reclassify** these 5 in `code/VICEROY/classification.json` /
   `viceroy_source/docs/decompile_status.json` from `MISSING` function to a
   `DATA` kind, so the inventory stops reporting them as undecompiled code.
   This closes the "5 gaps" honestly: there are **0** missing in-scope
   *functions* — the gaps were data.
2. **Pin the semantics** by finding the load site: search unit-overlay code
   (`func_056A10`, `func_05AF70`, `func_05B0DC`, and the rest of segments
   `0x14`/`0x15`) for a `LEA`/`MOV` that forms a pointer to file offset
   `0x5651C / 0x56694 / 0x5AC34 / 0x5AEA0` (as a DGROUP- or overlay-relative
   address). The indexing stride at that site (×2, ×4, …) will reveal record
   width and meaning. Until then the role stays **TBD** — do not guess.
3. Once cited, emit as `static const uint16_t <name>[]` in the owning
   `src/unit/*.c` with the file-offset citation.
