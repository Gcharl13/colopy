# Overlay re-segmentation — result

Produced by `tools/resegment_overlay.py` from the byte-decoded VP page directory
(`overlay_pages.json`). All offsets are FILE offsets into `COLONIZE/VICEROY.EXE`.

## Outputs

- `reverse_engineered/code/VICEROY/disasm_overlay_reseg/page_01.asm … page_1F.asm`
  (31 files) — each overlay page disassembled at its TRUE page code base, with a
  per-page header (file_offset / code_offset / code_end / reloc_count) and one
  `; ---- func_XXXXXX  size= insns= prologue= terminal= ----` block per function.
- `reverse_engineered/code/VICEROY/overlay_functions_reseg.json` — combined index:
  per-function `{file_offset, page_id, size, instructions, prologue_type,
  prologue_valid, terminal}`, plus `summary`, `pages`, and `reloc_validation`.

## Model validated by bytes (not assumed)

1. **code_offset is the true code base.** Each page's relocation table holds
   `reloc_count` u32 entries that are CODE-relative byte offsets: the far-pointer
   segment word lives at `code_offset + entry`, opcode (0x9A LCALL / 0xEA JMPF)
   at −3. Across all 31 pages, **6492 / 6507 (99.8%)** reloc sites land on a
   segment word in the link-time thunk set {0x181F, 0x191F, 0x1A1F, 0x0D1D,
   0x0C0C}; the remaining 15 are MOV-imm16 far-data fix-ups (byte@−1 ∈
   {0xB8,0xB9,0xBA}). Re-runnable: `python tools/resegment_overlay.py --validate-relocs`.

2. **A page's on-disk code runs to the NEXT page's `file_offset`, NOT to
   `file_offset + size_paragraphs*16`.** The descriptor `size_paragraphs` is the
   page's RESIDENT memory footprint and consistently undercounts the disk image:
   for every one of the 31 pages, the span
   `[file_offset+size_paragraphs*16, next_page.file_offset)` is ~90% nonzero real
   code, and on the clean pages the page's own relocation list references far-call
   sites right up to `next_page.file_offset` (e.g. page 1 max reloc site 0x024BEE
   vs next page 0x024BF0; page 2 0x02CAF8 vs 0x02CB00; page 0x0A 0x045C18 vs
   0x045C20). The 31 page images are laid end-to-end on disk. Using
   `size_paragraphs` as the end truncates the LAST function of every page — a
   second, distinct cause of stub functions (the first being the mid-RETF bug).

## Validation spot-checks (before → after)

| file offset | old flat decode | re-segmented decode |
|---|---|---|
| **0x2083C** (old "first overlay function") | "function" of 220 bytes; capstone reads `enter 0x1e,0; stosb; push ds; das; …` — actually page-1's RELOCATION TABLE u32s (`C8 1E 00 00 ǀ AA 1E 00 00 ǀ 5E 24 00 00 …` = reloc offsets 0x1EC8, 0x1EAA, 0x245E). Byte `0xC8` is a coincidental false ENTER. | **Correctly NOT a function** — 0x2083C is reloc-table data, 1700 bytes before page-1 code (`code_offset = 0x20EE0`). The real first function of page 1 is **0x20EE0**: `push ds; push 0x80c; push 0; lcall 0x181f,0x416 …` (string-ptr init, clean RETF at 0x20EFC). |
| **0x5B2C2** (combat, page 0x10) | truncated **35-byte stub** (per-function splitter stopped at the first RETF) | **full 2925-byte body**, 974 insns, `ENTER 0x3A,0` … terminal `RETF` at **0x5BE2E**; next function (`ENTER 2,0`) begins at 0x5BE30. Body is real combat code: `imul bx,[bp+6],0x1c` (UnitRecord stride) + `mov al,[bx+0x3147]` (UnitRecord base ~DGROUP:0x3146). The early RETF at 0x5B2E3 is an `[bp+6] < 0x12c` guard, correctly skipped. (2925 + trailing NOP pad at 0x5BE2F = the 2926 bytes expected.) |
| **0x30550** (page 0x04 first fn) | (happened to align) `push bp;mov bp,sp` … 21 B | identical 21-B body — a PowerRecord accessor: `imul ax,ax,0x13c; add ax,0x8808` (PowerRecord stride 316, base DGROUP:0x8808). Confirms aligned cases were already right; the bug was boundaries + reloc-region offsets. |
| **0x4C262** (page 0x0D mid) | 53 B stub | 53 B, `ENTER 2,0` array-copy loop (`shl bx,6; shl bx,2` stride-256 into DGROUP[-0x6750]) — unchanged, confirms clean interior decode. |
| **0x68FDC** (page 0x16 mid) | 23-B stub | **124 B** full body, `ENTER 6,0` (grew — was a mid-RETF stub). |
| **0x72CA4** (page 0x1A mid) | 29 B | 29 B `ENTER 0x50,0` — unchanged. |
| **0x68EE0** (page 0x16 first) | — | 87 B resource-free routine (`or ax,[mem]; je; lcall 0x191f,0x1a8` ×N then zero the pointers). |
| **0x78640** (page 0x1F first) | 189 B | 189 B `ENTER 2,0` … `RETF 8` (far fn, 4 word args). |

## Prologue-validity rate

Re-segmented overlay functions: **629 total, 626 (99.5%) start with a valid MSC
prologue** — 525 `ENTER imm16,0`, 95 `push bp;mov bp,sp`, 6 valid no-frame leaf
starts. **3 invalid (0.5%)**, all benign and correctly NOT flagged as functions:

- `0x3FF4C` (page 0x07, 419 B, first byte 0xF0): an inline **switch jump table**
  reached by `jmp word ptr cs:[bx+0x60A]` at 0x3FF44 — the table entries
  (0x04DC, 0x04F0, 0x0566, …) all resolve to valid offsets inside page-07 code.
- `0x78595` (page 0x1E) and `0x78D3B` (page 0x1F): 2-byte `RETF imm16` tail
  fragments in trailing page pad.

## Unblock count (Task 4)

- Old `functions.json`: **1241** functions = 550 load_image (resident, already
  decodable) + **691 overlay** (the blocked bulk; "skeleton" Purpose:UNKNOWN set).
- Of those 691 old overlay entries, **27 fell inside page reloc-table/header
  regions** — pure garbage (e.g. 0x2083C, 0x254C0, 0x3034C). Now excluded.
- Re-segmented overlay functions: **629**, of which **625 have a clean decode**
  (valid prologue + real instruction body); **626/629 = 99.5%** valid prologue.
- Of **620** start offsets shared between old and new, **405 GREW** — i.e. 405 of
  the old "skeleton" overlay functions were truncated stubs that now decode to
  their full body (303 grew by ≥2× or ≥100 bytes; e.g. 0x4E2D6 584→14975,
  0x53B7E 67→10025, 0x5CA7E 429→7348, 0x57F4E 355→7151, 0x5B2C2 35→2925).

**Net: the re-segmentation unblocks the full 691-function overlay skeleton —
every overlay page now decodes at its correct base; 625 functions get a clean,
correctly-bounded decode and 405 previously-stub bodies are recovered in full.**

## Task 3 — AI dispatcher / now-readable blocked functions

`anchor_map.md` already places the **AI driver, the turn-loop orchestrator, and
the render chain as overlay-resident** (previously blocked). The re-segmentation
makes the AI region fully decodable. The AI region is **pages 0x05 / 0x0F / 0x10**
(PowerRecord stride 0x13c referenced 69× on page 0x05; `dispatch_overlay_op`
@ 0x0D1D:0x07A4 called 10× on page 0x05, 13× on page 0x0F, 1× on page 0x10).

Per-power / per-unit AI entry points now recovered in full (each was a stub;
each takes a unit or power index and indexes the UnitRecord/PowerRecord tables;
none has an intra-page near-caller → they are invoked cross-page via Type-A
thunks, i.e. they ARE the overlay-dispatched leaves):

| file offset | page | prologue | size | evidence |
|---|---|---|---|---|
| **0x05CA7E** | 0x10 | `ENTER 0xDE,0` | 7348 B | per-unit AI: `[bp+6]` unit idx, `imul bx,[bp+6],0x1c` + `mov al,[bx+0x3146]` (UnitRecord base); 190 lcalls |
| **0x057F4E** | 0x0F | `ENTER` | 7151 B | AI logic, 209 lcalls, 13 dispatch_overlay_op calls |
| **0x05B2C2** | 0x10 | `ENTER 0x3A,0` | 2925 B | combat resolver (above) |
| **0x039EE2** | 0x05 | `ENTER 0x7E,0` | 2781 B | PowerRecord-heavy AI routine |
| **0x03A9C0** | 0x05 | `ENTER 0x3C4,0` | 2360 B | PowerRecord-heavy AI routine |

The **single top-level "iterate nations and dispatch" function** could not be
pinned to one offset with byte-certainty from the static disasm alone: the big AI
leaves above have **no intra-page near-callers**, so the nation loop that drives
them reaches them by far-call through Type-A overlay thunks (cross-page). Pinning
it requires resolving the Type-A thunk → page-function map (thunk `trailer_word_1`
= target page_id; e.g. 22 thunks target page 0x05). That is the recommended next
step to hand ai.c a definitive dispatcher entry; the AI leaves it dispatches are
the five offsets above. Reporting this precisely rather than guessing a single
offset (per the cite-or-stop directive).

## Task 3 — market price-to-coins value function (thunk 0x181F:0x9A4)

`LCALL 0x181F:0x9A4` indexes the thunk table at file 0x1A5F0 (segment 0x181F) +
0x9A4 = thunk slot **file 0x1AF94**. That slot is **Type-B** (resident):
`ljmp 0x05B3:0x01E0` → resident target **file 0x8110** (= 0x2400 + 0x5B3·16 +
0x1E0). It is therefore NOT an overlay-blocked function — it was always
decodable. Decode at 0x8110: `push bp; mov bp,sp; cmp [bp+6],4` (commodity-index
bound check); `bx = idx*6; mov ax,[bx-0x7304]` (stride-6 price table in DGROUP);
special-cases `cmp [bp+6],[0x5398]`/`[0x53D2]` → returns `[0x2E44]`/`[0x2E46]`
(per-commodity overrides). This is the commodity price/value lookup. (Confidence:
HIGH for the thunk→target resolution and table-lookup shape; the exact "coins"
semantics vs "base price" should be cross-checked against the market UI strings.)
