# RTLink Plus Overlay System

VICEROY.EXE uses Pocket Soft's **RTLink Plus** overlay system to fit
its ~495KB of code into 16-bit DOS's 64KB code-segment limit. This
doc traces how the system works in this binary.

---

## High-level architecture

- **Load image**: file 0x002400..0x00DDDD. Always-resident code: C
  runtime, the RTLink dispatcher itself, the message API, and a
  handful of resident overlays.
- **DGROUP**: file 0x010000..0x01FFFF. Initialized data + BSS.
- **Thunk table**: file 0x01A5F0..0x01D5E6. 1,020 thunks, each 10–14
  bytes. Every cross-overlay call goes through one of these.
- **Overlay region**: file 0x020665+. Most game-logic functions
  (combat, raze, market, FF effects, AI, scoring, mapgen) live here.
  Loaded on-demand by the dispatcher.

---

## The dispatcher

**Primary dispatcher**: `func_210d_0d91` at file 0x011D91.
- 353 callers — most-called function in the load image.
- Receives an overlay-page index and an in-page offset; ensures the
  page is loaded into memory; transfers control to the in-page offset.

**Partner dispatcher**: `func_210d_0dab` at file 0x011DAB.
- Variant called from Type A thunks for slightly different dispatch
  semantics.

Both BYTE_VERIFIED via the Ghidra Phase 1 import.

The dispatcher reads:
- `s_Smart_vectoring_failed_BP_chain_210d_28cd[0x44]` — overlay-system
  state flag.
- `[210d:28cd + 0x41] & 0x0C` — bit-test to decide overlay-load vs.
  cached call.

---

## Thunk types

### Type A (12–14 bytes)

```
9A xx xx xx xx        ; LCALL dispatcher
trailer_word_1 (page index — typically 23 = 0x17 for "main game" overlay)
trailer_word_2 (in-page offset)
[optional padding]
```

The dispatcher reads trailer_word_1 to decide which overlay to load,
then JMPs to the in-page offset.

**Most overlays use page 23**; the SMITE function alone has 6 distinct
calls into page 23. Loading just that one page would unlock most
"locked" overlay calls for static analysis.

### Type B (10 bytes)

```
9A xx xx xx xx        ; LCALL dispatcher (page-load check still happens)
EA xx xx xx xx        ; JMP FAR fixed image-relative target
```

Type B targets are **fixed paragraphs in the load image**. After the
LCALL returns from the dispatcher's "is this overlay loaded?" check,
the JMP-FAR jumps to a directly-addressable function.

**This is the key insight**: most "overlay" calls that look like
`LCALL 0x181F:NNNN` are actually Type B thunks that JMP-FAR back into
the load image. Examples (BYTE_VERIFIED):

| Call | Thunk type | Target | Function |
|------|-----------|--------|----------|
| `LCALL 0x181F:0x07B4` | B | 0x00BC10 | `power_attribute_bit` |
| `LCALL 0x181F:0x04D4` | B | 0x00C322 | `random_int(lo, hi)` |
| `LCALL 0x181F:0x035C` | B | 0x0048CC | `clamp(value, lo, hi)` |
| `LCALL 0x181F:0x04B6` | B | 0x00513C | `output_flush_helper` |
| `LCALL 0x181F:0x048E` | B | 0x0050BC | `set_message_context` |
| `LCALL 0x181F:0x09A4` | B | 0x008110 | `get_power_name_word` |
| `LCALL 0x181F:0x0808` | B | 0x006E94 | `decrement_power_unit_count` |
| `LCALL 0x181F:0x0A38` | B | 0x007F34 | `get_per_power_byte` (universal accessor) |

These are FULLY decodable today from existing disasm files.

---

## Thunk-table layout

```
file 0x01A5F0..0x01D5E6  (12,278 bytes total)
1,020 thunks at varying sizes (10/12/14/16/20 bytes)
```

The first thunk at 0x01A5F0 is `_main()` itself (Type A, page 0).
Subsequent thunks dispatch to specific functions in their respective
overlay pages.

---

## Overlay pages

Per `code/VICEROY/overlay_segments.json`, **209 detected overlay
segments** at varying file offsets in the 0x020665..0x078DEE region.
Each "page" is a contiguous chunk of code that gets loaded as a unit.

The page index encoded in Type A thunks selects which page to load.
The dispatcher maintains a cache of recently-loaded pages.

Total overlay code: ~360 KB across all pages.

---

## How to follow an overlay call from disassembly

1. Read the LCALL instruction: `LCALL 0x<seg>:0x<off>`.
2. Compute thunk position: if seg is 0x181F, 0x191F, or 0x1A1F, the
   thunk is at file `0x2400 + (seg - 0x181F)*16 + off`. Wait — the
   in-segment-arithmetic version: `(seg - 0x181F) × 16 + off` is the
   offset within the thunk table.
3. Look up that thunk in `overlay_thunks.json`.
4. **If type B**: compute `target_file = 0x2400 + ljmp_seg × 16 +
   ljmp_off`. That's the directly-decodable target — find its disasm
   file at `code/VICEROY/disasm/func_<6hex>_*.asm`.
5. **If type A**: the target is in overlay page `trailer_word_1`. To
   decode, the page must be loaded into Ghidra (or extracted via the
   RTLink loader). This is the limit of static analysis without full
   overlay loading.

The script `tools/parse_thunks.py` builds the thunk table from the
EXE bytes; output is `overlay_thunks.json`.

---

## Overlay loading at runtime

When the dispatcher detects a needed overlay isn't in memory:
1. Locate the overlay's start in the .EXE file (per the thunk's
   trailer_word_1).
2. Allocate a paragraph-aligned buffer in conventional memory (or
   EMS/XMS if available).
3. Read the overlay bytes from disk.
4. Apply RTLink relocation fixups.
5. Update the dispatch jump-table to point into the loaded buffer.
6. Continue execution.

This is why the game has audible disk activity during certain events
(combat, screens with new dialogs, etc.) — pages are being faulted
in.

---

## Open work (Phase D)

- Fully annotate `func_210d_0d91` (the dispatcher) and
  `func_210d_0dab` (partner).
- Identify the overlay-page-to-file-offset map for all 250 pages.
- Build a complete cross-reference of which game-system function lives
  in which overlay page.
- Optionally: write a Python tool that loads the overlay region into
  Ghidra programmatically (would unlock all Type A targets for
  static analysis).

---

## 2026-05-03 — LCALL → thunk file-offset BREAKTHROUGH

The Day-1 disasm sprint produced an exact formula for resolving any
`LCALL <seg>:<off>` in load-image disasm to its thunk's file offset:

```
thunk_file_offset = 0x2400 + (lcall_seg << 4) + lcall_off
```

The 0x2400 offset is `header_bytes` for VICEROY (e_hdr_paragraphs *
16 = 576 paragraphs * 16). The seg << 4 + off computes the runtime
segment+offset address; subtracting the implicit `0x110D` load-base
and adding the file offset of CS:0 (= 0x2400) gives the thunk's
position in the file.

Verified by exact-match check on 7,048 LCALL sites. Tool:
`tools/resolve_lcall.py`. Resolution table:
`viceroy_source/lcall_resolution_VICEROY.json`.

### Empirical seg → file_offset map (partial)

The complete RTLink directory at file `0x20670` is not yet decoded
(format unknown — 4-byte LE32 records starting after 11 zero bytes,
header marker 0x00870458). However, an empirical resolver (Day-1)
mapped 34 of 82 distinct overlay segments to file offsets by
cross-referencing 1,020 thunk LJMP targets with 691
prologue-detected overlay functions.

Output: `viceroy_source/overlay_directory.json`.

| Method | Coverage |
|--------|----------|
| Total distinct overlay segments | 82 |
| Resolved with ≥2 thunk anchors | 34 (41%) |
| Unresolved (single-thunk segments) | 48 |

Unresolved segments include 0x0C36 (the dialog-rect setter target)
and 0x0C56 (sprite-blit target). Resolving these requires either
the proper RTLink directory format decode or extending the prologue
scanner to detect more function entries that act as additional
anchors.
