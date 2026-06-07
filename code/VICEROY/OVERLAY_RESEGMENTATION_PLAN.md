# RTLink VP overlay re-segmentation plan (VICEROY.EXE)

Status: the on-disk VP page directory is now **byte-decoded and deterministic**
(see `tools/decode_overlay_pages_v2.py` and the regenerated
`overlay_pages.json`). This unblocks 100%-certain overlay re-segmentation. All
offsets below are FILE offsets into `COLONIZE/VICEROY.EXE`.

## What was the blocker, and what fixed it

The old `decode_overlay_pages.py` recovered page bases by *prologue voting*
because the on-disk directory's field semantics were unknown. The directory was
mis-identified: the 8-word header + u32 run at `0x20670` is the page-1 image's
own **relocation table** (527 fix-up offsets of far-call segment words), not the
page directory.

The real VP page directory is the RTLink **32-byte segment-descriptor table**,
located at **file `0x192F0`** (derivation: baked link-time word
`DGROUP:0x3999` = `0x16EB`; descriptor base paragraph = `0x16EB + 4 = 0x16EF`;
file = `0x2400 + 0x16EF*16`; self-checked because `descriptor[0].disk == 0x20670`,
the overlay image start). 31 non-zero records map 1:1 to page_id (`record =
page_id - 1`). Each record's `+0x08` u32 is the absolute disk offset the RTLink
loader `LSEEK`s to (byte-traced at `0x1567F` MOV dx,es:[8] / `0x15684` MOV
cx,es:[0xA] / `0x1569C` AX=0x4200 / INT 21h, then `0x16453` AH=0x3F read).

## Per-page on-disk image layout

```
disk_offset (descriptor +0x08)  ->  +0x00  8-word page header
                                                  +0x08 u16 reloc_count
                                     +0x10  u32 reloc_table[reloc_count]
                                            (byte offsets, page-image-relative,
                                             of far-call/JMPF segment words;
                                             target segs 0x181F/0x191F/0x0D1D/0x0C0C)
                                     ...    zero pad to 16-byte boundary
                                     code_offset  ->  overlay function code
size_paragraphs (descriptor +0x04) gives the page image length on disk.
code_offset = round_up_16(disk + 16 + reloc_count*4), then skip zero pad.
```

`overlay_pages.json` now lists, per page: `file_offset` (disk image base),
`code_offset` (first instruction), `size_paragraphs`, `size_bytes`,
`reloc_count`, `flags`, `residency`.

## How to re-run the disassembler so each overlay function decodes at its page base

The key error in past overlay disasm was treating overlay code as if it were one
flat blob, or anchoring it at the wrong base. With the directory decoded:

1. **Regenerate the directory** (deterministic, no API cost):
   ```
   python tools/decode_overlay_pages_v2.py
   ```
   This writes the authoritative page table to `overlay_pages.json`.

2. **Per-page disassembly base.** For each page `P` (page_id `0x01..0x1F`):
   - On disk the page code lives at `[code_offset, file_offset + size_paragraphs*16)`.
   - At runtime the page is paged into the overlay window. The window base
     paragraph is `cs:[0x399B]`-table-driven, but for *static disassembly* the
     correct CS to display is the page's link-time segment so that intra-page
     `CALL`/`JMP` rel16 targets and far-pointer fix-ups read naturally.
   - Use the **runtime CS = the value the loader patches in**: each Type-A thunk's
     `[si+5]` selector (`overlay_thunks.json` trailer) gives the descriptor index
     (`(sel & 0x3FFF) - 1 == page_id - 1`); the page's display segment is the
     paragraph at which `code_offset` would sit if the page image were loaded at
     its window base. In practice, set the disassembler's segment so that
     `IP(code_offset) == thunk.ljmp_off` for that page's thunks — i.e.
     `disasm_base_para = (code_offset - HDR)//16 - (thunk.ljmp_off // 16)` and
     refine by the thunk-offset modulus.

3. **Apply the per-page relocation table before disassembly.** For exact far
   pointers, walk `reloc_table` (file `disk+0x10`, `reloc_count` u32 entries):
   each entry `e` marks the segment word at file `code_offset + e` (page-image
   relative) — patch/annotate it with the runtime segment. Untouched, those seg
   words read as the link-time stubs `0x181F / 0x191F / 0x0D1D / 0x0C0C`; that is
   expected and is how you confirm a fix-up site.

4. **Function boundaries within a page.** Scan `[code_offset, page_end)` for MSC
   prologues `C8 imm16 00` (ENTER) and `55 8B EC` (push bp; mov bp,sp). NOTE the
   `C8 .. 00` heuristic has heavy false positives in data/reloc regions — only
   scan the code span `[code_offset, page_end)`, never the reloc header. ~89% of
   page entries are standard prologues; the rest are valid leaf / `__loadds`
   starts (first byte `0x83/0xA1/0xC7/0x8B/...`), already classified in
   `tools/resolve_thunks.py`.

5. **Cross-check.** Each page's `code_offset` must be a valid instruction start
   (verified: 27/31 ENTER or push-bp, 4/31 valid leaf starts) and each page's
   reloc targets must resolve to the four known thunk segments. The 16
   high-confidence prologue-voted bases agree with the directory (14 exact; the
   2 that differ, pages 0x06 and 0x14, were vote errors that the directory
   corrects). This is the validation gate — if a re-disassembly run produces an
   overlay function whose body references a reloc site NOT in its page's reloc
   table, the page assignment is wrong.

## Files

- `tools/decode_overlay_pages_v2.py` — deterministic directory decoder (new).
- `code/VICEROY/overlay_pages.json` — regenerated, all 31
  pages high-confidence with `file_offset` + `code_offset` + sizes + flags.
- `tools/decode_overlay_pages.py` — the old prologue-vote tool, kept for
  provenance; its `_blocker` is now resolved by v2.
