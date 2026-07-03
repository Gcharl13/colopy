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

**Trailer semantics DECODED 2026-07-03** (see "DECODED" below): the
trailer is `<overlay_segment:le16> [<para:le16>]` — the first word is
the overlay-segment index the runtime loads, the optional second word
is a **paragraph offset within that segment's file image** added to the
LJMP offset (`file = segment_base + para·16 + ljmp_off`; 2-byte
trailers ⇒ `para = 0`). E.g. `0600B200` = segment 6, para 0xB2;
`1A001E01` = segment 0x1A, para 0x11E.

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

**DECODED 2026-07-03 (`tools/rtlink_decode.py`)** — the segment ↔ file
mapping is solved empirically, without needing the LE32 directory:

- **Type-B thunks** (runtime entry `0x110D:0xD91`) carry a REAL
  `seg:off` in their LJMP: the target is **image-resident** and maps
  linearly, `file = header_paras·16 + seg·16 + off` (= `0x2400 + …`).
  323/362 land exactly on a function prologue. Anchor: thunk `0x718` →
  `ljmp 0x037F:0x04B0` → file `0x60A0` = `func_0060A0` (the prime-resource
  predicate) ✓.
- **Type-A thunks** (runtime entry `0x110D:0xDAB`) LJMP to a
  runtime-patched segment word (`0x0000` on disk); the trailer is
  **`<overlay_segment:le16> [<para:le16>]`** and the target is

      file = segment_file_base + para·16 + ljmp_off

  with `para = 0` for the short 2-byte trailer form. **The `para`
  word was decoded 2026-07-03** (superseding the first-cut model that
  ignored it): pages whose thunks carry mixed `para` values — e.g.
  segment `0x15`, the map-HUD page — cannot be fitted to a single base
  without it (the old fit scored 7/33 prologues there; the corrected
  model scores 23/33 and lands every byte-verified anchor exactly).
  Each segment's file base is fitted by maximizing prologue hits
  (ENTER `C8 .. 00` / `55 8B EC`) over paragraph-aligned candidates,
  then **pinned by byte-verified spec anchors where available** (an
  anchor wins over the blind fit — several pages are dominated by
  frameless leaf functions the prologue heuristic cannot see). 31
  segments resolved; bases are monotonic in segment index (the one
  exception, segment `0x11`, has a single thunk — insufficient data).
  Anchors (all validated by the tool, exit 1 on failure):
  - segment 3 base `0x2CFD0` + `0x33A` = file `0x2D30A` = the
    mine-depletion scan (content-located, the binary's only mask-4
    flags-plane setter) ✓
  - thunk `0x0E1C` (`0x181F:0xE1C`) → `0x67700` = `func_067700`, the
    map-HUD composer (`spec/ui/map_view.md` §6.3) ✓
  - thunk `0x1896` (`0x191F:0x896`) → `0x672C8` = `func_0672C8`, the
    unit-panel data fn (`map_view.md` §6.3) ✓
  - thunk `0x123C` (`0x191F:0x23C`) → `0x6C520` = `func_06C520`, the
    message-box draw (`spec/systems/turn_dispatch.md` §4) ✓
  - thunk `0x1928` (`0x191F:0x928`) → `0x6F8FA` = `func_06F8FA`, the
    popup window fill (`turn_dispatch.md` §4; pins segment `0x18`,
    whose blind fit is weak) ✓
  - thunk `0x11A8` (`0x191F:0x1A8`) → `0x789FA` = `func_0789FA`, the
    resident string primitive (`turn_dispatch.md` §4) ✓

  Note the "segment" seen in an `lcall`/far pointer (`0x181F`, `0x191F`,
  `0x1A1F`, …) is a **position in the thunk table**, not a code segment:
  table file pos = `0x2400 + seg·16 + off` (the table spans `0x1A5F0..
  0x1D5E6` = segments `0x181F..0x1D1E`). A "runtime-installed far
  pointer" like `[0xa644] = 0x1A1F:0x0F10` therefore resolves through
  the same table (that one → type-B → file `0x12A66`, image-resident).

This closed the last two blocked spec items (the `@RESOURCE` yield
application point and the depletion writer — see
`spec/systems/map_system.md` "Prime resources").

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
