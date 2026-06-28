# RTLINK — Pocket Soft RTLink Plus overlays

Five of the six DOS executables in `COLONIZE/` use the **RTLink Plus**
overlay system (Pocket Soft, ~1990–1995): a third-party linker/runtime that
appends overlay segments to the MZ image and demand-loads them at runtime.
The sixth (`INSTALL.EXE`) has no overlay and is out of scope. INSTALL.EXE
and MPSCOPY.EXE are out of scope per user direction.

## Critical finding: which overlays are CODE vs DEBUG INFO

A byte-pattern survey of the four in-scope executables (`VICEROY`,
`MAPEDIT`, `OPENING`, `CLOSING`) reveals **only VICEROY's overlay
contains real loadable code**. The other three overlay regions are
*linker debug data* — symbol tables and source-file listings — appended
by RTLink for runtime symbolic-debug support, not loadable program
segments.

| EXE         | Overlay size | `55 8B EC` | `C8` (ENTER) | `9A` (LCALL) | `CD 21` (DOS INT) | Verdict |
|-------------|-------------:|-----------:|--------------:|--------------:|-------------------:|---------|
| VICEROY.EXE | 362,201      | 99         | 1,323         | 8,507         | 5                  | **real code** |
| MAPEDIT.EXE | 30,979       | 0          | 10            | 0             | 0                  | debug data |
| OPENING.EXE | 21,907       | 0          | 2             | 7             | 0                  | debug data |
| CLOSING.EXE | 20,477       | 0          | 5             | 10            | 0                  | debug data |

VICEROY's overlay has 8,507 LCALL instructions (matching its many
inter-overlay calls), 1,323 ENTER prologues (its compiler's preferred
function entry), and 5 DOS interrupt calls. The others have far fewer
of all of these — their overlays are not executed.

**MAPEDIT.EXE's "debug" overlay is decoded** to verify the format —
it contains an NB02 directory mapping linker-segment-paragraphs to
source `.obj` and `.c` filenames. See "MAPEDIT segment directory" below.

## Critical finding: VICEROY's overlay uses ENTER prologues

VICEROY's overlay code uses the Borland-style **`C8 imm16 imm8`**
(`ENTER` instruction) prologue for nearly all of its functions, *not*
the canonical Microsoft `55 8B EC` (`PUSH BP / MOV BP, SP`). Without
recognising ENTER, function discovery in the overlay missed >95% of
the real functions.

After extending `tools/disasm_mz.py`'s prologue heuristic to recognise
ENTER, VICEROY function counts jumped from 371 → **1,237** (load image
546 + overlay 691). Captured CALL/LCALL graph edges grew from 150 →
**1,073**. Hot-global detection found **872** distinct DGROUP
addresses (was 259).

## VICEROY.EXE overlay-thunk table — fully catalogued

The thunk table is the load-image-side bridge to overlay code. Every
overlay function that the load image needs to call has a **thunk** here.
When the load image far-calls a thunk, its first instruction (LCALL)
invokes the RTLink runtime; the runtime resolves the overlay location,
patches the thunk's second instruction (LJMP) so its segment word
points at the runtime address where the overlay segment is now loaded,
then returns. The LJMP then transfers control to the overlay.

- **Location:** file 0x01A5F0..0x01D5E6 (12,278 bytes — 12 KB)
- **Total thunks:** 1,020
- **Distinct overlay segments referenced:** 82
- **Thunk types:** two
  - **Type-A** (variable size; LCALL target = `0x110D:0x0DAB`): 658 thunks.
    Trailer is 2 / 4 / 6 bytes depending on the metadata it carries.
  - **Type-B** (10 bytes, LCALL target = `0x110D:0x0D91`): 362 thunks.
    No trailer.

Type-A trailer-size distribution:
- 2 bytes (281 thunks) — most common
- 4 bytes (375 thunks) — second-most common
- 6 bytes (1 thunk)
- 10 bytes (1 thunk)

Top type-A trailer values (decoded as little-endian metadata words):
| Trailer hex   | Count | Decoded                |
|---------------|------:|------------------------|
| `0200`        |    79 | LE16 0x0002            |
| `04000000`    |    75 | LE16,LE16 0x0004,0x0000 |
| `0100`        |    46 | LE16 0x0001            |
| `1700`        |    40 | LE16 0x0017            |
| `0D00`        |    27 | LE16 0x000D            |
| `12000000`    |    23 | 0x0012,0x0000          |
| `0600B200`    |    21 | 0x0006,0x00B2          |
| `0A00`        |    21 | 0x000A                 |
| `16000000`    |    21 | 0x0016,0x0000          |
| `1A001E01`    |    20 | 0x001A,0x011E          |

The trailer values are likely RTLink-runtime hints (e.g. relocation
fix-up indices, segment-affinity tags); the precise semantics aren't
yet reverse-engineered. The 4-byte trailers may carry (segment,
offset) of a target the runtime patches alongside the LJMP.

## VICEROY.EXE overlay segments

The 82 distinct overlay segments are the linker-virtual paragraph
addresses the runtime knows about. Top segments by entry-point density:

| Segment | Thunks | Likely role (heuristic from neighbour analysis) |
|---------|------:|--------------------------------------------------|
| 0x0000  |   661 | Main code segment — bulk of game logic |
| 0x05EB  |    82 | Major secondary segment |
| 0x0427  |    47 | Major tertiary segment |
| 0x004B  |    25 | Sub-system |
| 0x037F  |    24 | Sub-system |
| 0x0984  |    16 | Sub-system |
| 0x0009  |    10 | Sub-system |
| 0x05B3  |     9 | Sub-system |
| 0x0262  |     8 | Sub-system |
| 0x012B  |     7 | Sub-system |
| 0x0097  |     6 | Sub-system |
| 0x029F  |     6 | Sub-system |
| (50 more segments with 1-5 thunks each) | | |

Without the segment-id ↔ file-offset directory decoded, these are
linker-virtual addresses. They're stable identifiers that can be used
to name overlay-resident functions (e.g. `overlay_05EB_0258`).

## RTLink runtime entry points (file 0x14261, 0x1427B)

Both runtime entry points share the same body starting at file
`0x014293`. They differ only in a one-byte flag set on entry:

- **`0x110D:0x0DAB` (file 0x01427B)** — type-A entry: sets `cs:[0x39F1] = 0`.
- **`0x110D:0x0D91` (file 0x014261)** — type-B entry: sets `cs:[0x39F1] = 0x52`.

The shared body:

1. `PUSHF; CLI` — disable interrupts during the segment-register dance.
2. Test re-entry flags `cs:[0x39E1]` and `cs:[0x39DE]`. If the loader is
   already busy (re-entrant from an interrupt handler), bail to a
   fall-back path at 0x14318 that emits a different LCALL and a JMP.
3. Set busy flag `cs:[0x39E1] = 0xFF`.
4. `POPF`, then pop the LCALL's saved IP+CS into globals
   `cs:[0x397D]` (saved IP) and `cs:[0x397F]` (saved CS).
5. Save current SP at `cs:[0x3983]`.
6. Push the saved CS:IP back onto the stack so a subsequent `RETF` will
   resume past the LJMP, and PUSHF.
7. Save the live general-purpose registers (AX, BX, DX, SI, DS, ES, CX,
   DI, BP) and call the segment-lookup helper at file `0x0164A2`.
8. The lookup helper walks a chain of 6 sub-helpers (one per overlay
   storage class — disk, EMS, XMS, …) at 0x164FE / 0x164E8 / 0x16564 /
   0x16516 / 0x16837 / 0x167F2.
9. The lookup helper returns CF/ZF flags that select between three
   continuation paths: "no patch needed" (already loaded, just return),
   "patch reloc" (rewrite the LJMP segment word in place at `[si-4]`,
   where SI = saved IP - 5 = pointer to the LJMP's segment-word slot),
   and "fault / load from disk" (additional work).
10. The loader returns; the LJMP fires with the patched segment word
    and execution lands inside the overlay segment at the requested
    offset.

At its peak, the type-A entry (0x1427B) is called **127 times** by
load-image and inter-thunk code; the type-B entry (0x14261) is called
**109 times**. They are the two most-called targets in the entire
program.

### Segment-lookup helper (file 0x0164A2)

The dispatcher reads the LCALL's saved IP from `cs:[0x397D]`, subtracts 5
(to back up to the LCALL itself, where the LJMP-target word is stored at
`[si+6..si+9]`), saves at `cs:[0x3981]`, then loads ES:DI from the
caller's `[bp+0x18]` slot. If ES is already 0x110D the lookup is a
self-call and returns immediately. Otherwise it tries each storage-class
helper in turn. The helpers are at 0x164FE, 0x164E8, 0x16564, 0x16516,
0x16837, 0x167F2.

## MAPEDIT segment directory (NB02-style)

MAPEDIT's overlay starts with a directory of 33 named records. Each
record has the format:

```
+0:  byte 0x00            (separator)
+1:  byte 0x01            (magic)
+2:  byte 0x00            (separator)
+3:  byte name_len
+4:  N bytes name (e.g. "popup.obj", "fileio_8.c")
+4+N: 2 bytes  linker_segment_paragraph (LE16)
+6+N: 2 bytes  flags (LE16; usually 0..0x0E)
+8+N: 2 bytes  size_in_bytes (LE16)
+A+N: 2 bytes  reserved (LE16, always 0)
+C+N: 2 bytes  type_marker (LE16; 0x0000 for top-level .obj, 0x0001 for sub-source)
```

For .c source records (debug info, not loadable), the prefix is
`01 00 01 00 LL` (5 bytes). The trailer is similarly structured but
the type_marker is `0x0001`.

MAPEDIT's directory contains:
- 13 top-level `.obj` records (loadable segments — though MAPEDIT's
  overlay contains no actual code per the byte-pattern survey above):
  popup.obj (5800B), menu.obj (574B), text.obj (342B), stuff.obj (630B),
  map_2.obj (166B), map_5.obj (1220B), write.obj (3042B),
  vicemisc.obj (204B), terrain.obj (0B/empty), map_6.obj (1244B),
  map_9.obj (4334B), map_a.obj (1228B), me_mini.obj (114B).
- 19 `.c` and `.asm` source records — debug-only.

Linker segment paragraphs are sequential and increasing across .obj
records (0x06D7 → 0x0BA3), confirming they're virtual addresses
assigned by the linker.

## VICEROY segment directory (partial decode)

The VICEROY overlay starts with 11 zero bytes then a sequence of
records. Unlike MAPEDIT, **the records have no embedded names** —
VICEROY was either built without debug info, or it was stripped before
release.

LE32 dump of the first ~60 records starting at `overlay_offset + 0x0B`:

```
record 0:  0x00870458   (high byte 0x87 — special / header marker?)
record 1:  0x000002BC   (= 700)
record 2:  0x0000020F   (= 527)
record 3:  0x00000000
record 4:  0x00003941   (= 14657)
record 5:  0x00002991   (= 10641)
record 6:  0x00003330   (= 13104)
…
```

The first record's high byte 0x87 may be a directory-version marker
(MAPEDIT's directory begins with 0x00 0x01 0x00 — different magic).
Subsequent records' values are small integers compatible with paragraph
counts or byte sizes.

**What's NOT yet decoded for VICEROY:**

- The mapping from a segment ID (e.g. 0x05EB) to its physical byte
  offset in the overlay file region.
- Whether each 4-byte LE32 record corresponds 1:1 to a segment, or
  whether the records are interleaved with relocation tables / per-
  segment metadata.

Decoding the directory is the next leverage point: once we can map a
segment ID to a physical file offset, every overlay thunk's
`LJMP <seg>:<off>` becomes a concrete file offset that can be added
to `manual_funcs.json` as a named overlay function. **This is the next
step to unblock per-anchor game-logic annotation.**

## What we already have without the directory

Despite the directory being incomplete, function discovery is
working well. After adding ENTER-prologue support:

- **691 overlay functions discovered** at concrete file offsets (102 KB
  of identified code, ~28% of the 362 KB overlay).
- **1,020 named overlay entry points** (segment:offset identifiers
  from the thunk catalogue).
- **8,507 LCALL operands** mapped to (segment, offset) targets — these
  flow into `code/VICEROY/callgraph.json`'s "unknown call targets"
  list and identify additional overlay entry points beyond the thunk
  table.

So the *anchor* set is:
- 1,020 entry points from thunks (named by `seg:off`)
- 691 functions at concrete file offsets (named by `func_<file_off>`)
- These overlap partially — many discovered functions are entry points
  of named thunks. Cross-referencing them is a future task.

## Tools

- `tools/parse_thunks.py` — parses the thunk table; outputs
  `code/<EXE>/overlay_thunks.{json,md}`. Defensive parser handles
  variable-length type-A trailers (2 / 4 / 6 bytes).
- `tools/disasm_mz.py` — recognises both `55 8B EC` and `C8 imm16 imm8`
  (ENTER) prologues, plus alternative `55 89 E5` encoding.
- (Pending) `tools/parse_rtlink_directory.py` — would consume the
  4-byte records starting at `overlay_offset + 0xB` and emit a
  segment_id ↔ file_offset mapping.
