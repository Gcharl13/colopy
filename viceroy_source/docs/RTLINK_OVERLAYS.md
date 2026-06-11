> **>>> RECONSTRUCTED — NOT BYTE-VERIFIED <<<**
>
> The formulas, tables, and specific numbers in this document are reconstructed
> from accumulated playthrough knowledge and prior reverse-engineering notes.
> They have **not** been confirmed by reading bytes from VICEROY.EXE.
>
> Treat every numerical claim as RECONSTRUCTED until cross-referenced to a
> hand-decompiled function in `code/VICEROY/decompiled.md` or to bytes
> documented in `viceroy_source/VERIFICATION_LEDGER.md`.

# RTLink Plus Overlay System

## What it is

VICEROY.EXE is built with **RTLink Plus** (Pocket Soft, ~1992), a DOS
overlay loader that allows a single executable to ship far more code than
fits in conventional memory. It works by:

1. Splitting the program into a small **always-resident root** and many
   **virtual pages (VPs)** stored in the EXE's overlay region.
2. Loading VPs on demand from disk into a fixed swap area.
3. Patching call sites the first time a function is called so subsequent
   calls bypass the loader.

VICEROY.EXE has:

- **132,709 bytes** of always-resident root (cstart, runtime, RTLink loader)
- **362,201 bytes** of overlay region (250 VPs across 82 distinct overlay
  segments)
- **1,020 thunks** at file offset `0x1A5F0..0x1D5E6` (12,278 bytes)

@ref `../formats/RTLINK.md` (full spec)

## Thunk format

Each thunk is **12 bytes**, with two variants:

### Type-A thunk (call-resolver type)

```
+0  E8 ?? ??       LCALL <runtime_entry>     ; 5-byte near call
+5  EA ?? ?? ?? ?? LJMP  <segment:offset>    ; placeholder, patched at first hit
+A  ?? ??          (segment id, page number)
```

### Type-B thunk (jump-resolver type)

```
+0  E9 ?? ??       LJMP  <runtime_entry>     ; 3-byte near jump
+3  ?? ??          (call descriptor)
+5  EA ?? ?? ?? ?? LJMP  <segment:offset>    ; placeholder
+A  ?? ??          (page number)
```

## Runtime entry stubs

Two runtime entry stubs handle the two thunk types:

- **`rtlink_call_handler`** at file `0x1427B` (type-A, 23 bytes)
- **`rtlink_jump_handler`** at file `0x14261` (type-B, 23 bytes)

Both call into `rtlink_load_overlay_segment(segment_id)` which:

1. Checks the segment table to see if `segment_id` is currently resident.
2. If not:
   - Computes `disk_offset = overlay_base + segment_offset[segment_id]`
   - Reads `segment_size[segment_id]` bytes from VICEROY.EXE on disk
   - Or fetches from EMS/XMS cache if available (set up in system_init)
   - Stores at `swap_buffer + segment_id * SEGMENT_STRIDE`
   - Updates segment-resident bitmap
3. Patches the calling thunk's `LJMP placeholder` with the actual address.
4. Returns to that address.

@ref `../src/overlay/rtlink.c`,
     `../src/overlay/dispatch_thunks.c`

## Memory layout

```
+--------------------------+  ← high memory
| Far heap                 |
+--------------------------+
| EMS overlay cache (16KB) |  if EMS detected
+--------------------------+
| Overlay swap buffer      |  fixed, usually ~64KB
+--------------------------+
| Near heap (DGROUP)       |
+--------------------------+
| BSS                      |
+--------------------------+
| DATA                     |
+--------------------------+
| Resident root (CODE)     |  132 KB
+--------------------------+
| Stack                    |
+--------------------------+
| PSP                      |
+--------------------------+  ← PSP segment
```

## Segment descriptor table

Located at file offset `0x14400` (immediately after the runtime stubs).
Each entry:

```c
struct OverlaySegment {
    uint16_t disk_offset_lo;     /* low 16 bits of file offset */
    uint16_t disk_offset_hi;     /* high 16 bits */
    uint16_t size_in_paragraphs; /* segment size / 16 */
    uint16_t residency_flags;    /* bit 0 = resident, bit 1 = locked */
};
```

82 entries × 8 bytes = 656 bytes. The 250 VPs fit into these 82 segments
(some segments hold multiple VPs).

## EMS / XMS caching

If `system_init()` detects EMS:

```c
int detect_ems(void) {
    /* Test for EMS device driver name "EMMXXXX0" */
    /* via INT 67h AH=46h or by opening device "EMMXXXX0" */
    return ems_present();
}

void cache_overlay_in_ems(void) {
    /* Allocate 16-page (64KB) handle */
    /* Map overlay segments into EMS pages on first read */
    /* Fast subsequent reads via memcpy from EMS window */
}
```

XMS detection (HMA/upper memory) similarly used if EMS not present.

If neither: pure disk-load every miss.

## Performance characteristics

- **Cold call** (segment not resident): ~50-200 ms disk I/O on a slow
  drive, ~5-15 ms on a fast drive.
- **Warm call** (segment resident): pure memory access via patched LJMP.
- **EMS-cached call**: ~1 ms memcpy from EMS window.

The game design assumes **most overlay calls become warm after the first
turn** — which they do, because the same segments are used over and over
(map render, unit move, etc.).

## Segment classification

The 82 segments break down roughly as:

| Class             | Count | Purpose                                |
|-------------------|-------|----------------------------------------|
| Boot              | 1     | Title screen, intro                    |
| Asset loaders     | 8     | One per file format                    |
| Render chain      | 12    | func_O514..516, sprite blit variants   |
| Game systems      | 30    | Combat, AI, market, native, etc.       |
| UI panels         | 15    | Colony, Europe, dialogs                |
| Audio             | 6     | Sound dispatch, sample play            |
| Save/load         | 4     | Save serializer, load deserializer     |
| Misc utilities    | 6     | Date math, RNG, string fmt             |

@ref `../src/overlay/MANIFEST.md`,
     `../src/overlay/SEGMENTS.md`

## How to call an overlay function from C

```c
/* The compiler emits: */
extern void overlay_func(int arg);    /* far prototype, generates LCALL */

void caller(void) {
    overlay_func(42);                  /* compiles to LCALL <thunk_addr> */
}
```

The thunk address is fixed at link time. The first call traps into the
RTLink loader; subsequent calls jump straight through the patched LJMP.

## Reverse-engineering implications

When disassembling, every LCALL or LJMP into the `0x1A5F0..0x1D5E6` range
is a **thunk to an overlay function**. Resolution requires:

1. Read the 12-byte thunk to get `(segment_id, offset_within_segment)`.
2. Look up the segment in the 82-entry segment table.
3. The "real" function is at `(segment.disk_offset + offset_within_segment)`.

Our pipeline (`tools/disasm_mz.py` + `tools/overlay_classifier.py`) does
this resolution automatically.

## Cross-references

- Architecture overview: [ARCHITECTURE.md](ARCHITECTURE.md)
- Format spec: [../formats/RTLINK.md](../formats/RTLINK.md) (planned)
- C source: [../src/overlay/rtlink.c](../src/overlay/rtlink.c)
- Manifest: [../src/overlay/MANIFEST.md](../src/overlay/MANIFEST.md)

## Sub-segment records — DECODED 2026-06-11 (BYTE_VERIFIED, constraint-solved)

Type-A overlay records are **variable length**:

    9A <loader 0x0DAB> 0D 11  EA <off16> 00 00  <page16>            (12 bytes)
    9A <loader 0x0DAB> 0D 11  EA <off16> 00 00  <page16> <extra16>  (14 bytes)

and the target is

    file_target = group_base[page] + (extra << 4) + off      (extra = 0 for 12-byte)

`extra` is a paragraph offset of a SUB-SEGMENT within the page group.  The
record length is determined by whether the next record starts at +12.

Validation: 373 extra-bearing records across 17 pages; solving each page's
group base from the constraint system yields 260 exact function-start hits
with ZERO near-misses (the remainder land on known boundary-detector gaps).
The previous two-anchor "base overrides" for pages 21/26 (+0x830, +0x11E0)
were exactly absorbing a missing `extra << 4` term (0x83<<4, 0x11E<<4) and
are retired.  Group bases: `tools/subseg_bases.json`; resolver:
`tools/portlib.py::resolve_thunk` (whois/decode_sheet/arity_truth all
consume it).

First payoff: `0x191F:0x2EA` (the AI ship-explore leaf) = page08 +
(0x138<<4) + 0x15E = file 0x4198E = `func_04198E_find_adjacent_cell`
(already ported); a prior page+off misread had wired the unit timer-decay
function there, caught by the 500-turn determinism baseline at turn 383.
