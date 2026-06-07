# VICEROY Overlay — Plan to convert all 691 functions to citable C

The 362 KB overlay region of VICEROY.EXE contains the bulk of the actual
game logic — combat, AI, render chain, save/load core, asset loaders for
SS / PIK / PAL / FF / MP / TXT / DAT / COL / BIN / MOV / PCX / GIF, dialog
boxes, Europe screen, colony screen, and message tables.

**Inventory:**
- 691 functions detected via the ENTER-prologue scan
- 102,749 bytes covered by detected functions out of 362,201 total overlay bytes
  (28.4% coverage; remainder is data, padding, and undetected boundaries)
- 1,020 thunks at file 0x01A5F0 distributed across 32 distinct segments
  (trailer_word_1 values; some thunks have null trailers — the docs say
   82 segments total counting these)
- 8 functions exceed 1000 bytes (the heavy game-logic dispatchers)
- 32 functions in 500-1000 bytes
- 106 functions in 200-500 bytes
- 156 functions in 100-200 bytes
- 186 functions in 50-100 bytes
- 116 functions in 25-50 bytes
- 87 functions <25 bytes (tiny helpers / wrappers)

**Goal:** Every overlay function becomes a citable C function in
`reverse_engineered/viceroy_source/src/overlay/`, with `@asm` block,
file path back to its `.asm`, and best-effort identification of role.

The deliverable is the same standard as the load-image source: a
function in the tree must cite back to the original bytes.

---

## Strategy: TIERED PORTING

Time-budget: ~10 hours total.  Per-function average must be < 1 minute,
so we MUST batch.

### Tier 1 — Mechanical stub generation (all 691 functions)

Build `tools/overlay_to_c.py`.  For each overlay function:

1. Read its `.asm` file
2. Detect prologue type (`ENTER`, `PUSH BP/MOV BP,SP`, `PUSH BP/MOV BP,SP/PUSH SI`, etc.)
3. Detect body shape:
   - **TINY-ACCESSOR** (<25 bytes, no LCALL): one struct field read
   - **WRAPPER** (25-50 bytes, single LCALL): forwards to overlay func
   - **DISPATCHER** (multiple LCALLs with constant opcodes): operation router
   - **LOOP-BODY** (LOOP / JCXZ / DEC CX iteration): table walk
   - **LARGE-LOGIC** (200+ bytes): hand-port required
4. Generate a `.c` stub with:
   - Citation block (file offset, size, asm path)
   - Function signature (args from prologue + visible PUSH count)
   - Body: either a generated body for TINY/WRAPPER patterns, or
     `/* TODO: hand-port — see ../code/VICEROY/disasm/...asm */` for complex ones
   - All discovered LCALLs as `extern overlay_call_<seg>_<off>(…)` declarations

Output structure: one `.c` file per overlay segment plus a `seg_unknown.c`
catch-all, organized as:

```
viceroy_source/src/overlay/
├── seg_001.c               (functions in segment 1)
├── seg_002.c
├── seg_003.c
├── ...
├── seg_4365_main.c         (the most-common segment)
├── seg_unknown.c           (orphans — segment id not yet decoded)
└── overlay_externs.h       (auto-generated declarations for every overlay LCALL target)
```

This tier produces a citable stub for every overlay function in
~2 hours of automated work.

### Tier 2 — Pattern-batch hand-port (~150 functions)

Identify recurring patterns from Tier 1's output and batch-port them.
Examples:

- **Bit-array test/set/clear pairs** (like the `test_bit_at_8a` / `set_or_clear_bit_at_8a`
  pair we found): replace stub with parameterized inline.
- **Packed-nibble pack/unpack pairs**: same pattern.
- **Bound-checked array readers**: the `current_unit_field_at_*` family.
- **find_X_in_Y linear scans**: common pattern.
- **count_X_matching tally loops**: common pattern.
- **wrapper_for_op_X**: dispatch wrappers (like `dispatch_overlay_op_50`).

For each identified pattern, write a single template, then bulk-substitute
into all matching stubs.  Estimated: ~150 functions in ~3 hours.

### Tier 3 — Hand-port the largest functions (~50 functions)

The 8 1000+ byte functions and the top of the 500-1000 byte cluster are
the major game-logic dispatchers.  Each gets individual analysis like
the `colony_turn_update` and `colony_assign_or_change_colonist_job`
treatment we already did.

These are the **highest-value** functions because they expose:
- The combat resolver
- The AI driver
- The render chain (overlay-resident drawer functions)
- The save/load core
- The dialog dispatcher

Estimated: ~3 hours for 8-12 functions at the high end, with shallower
analysis for the 30-50 next-tier ones.

### Tier 4 — Wrap up + docs

- Update COMPLETION.md with actual numbers
- Refresh PROGRESS.md and anchor_map.md
- Generate a per-segment summary
- Cross-link the source tree to decompiled.md

Estimated: ~1 hour.

---

## Per-function citation template

Every overlay function — whether mechanically stubbed or hand-ported —
gets this minimum citation block:

```c
/* @asm        0xNNNNNN..0xMMMMMM  (S bytes)  region=overlay
 * @asm_file   ../code/VICEROY/disasm/func_<6hex>_<name>.asm
 * @segment    <id> (from RTLink thunk table; see formats/RTLINK.md)
 * @prologue   ENTER N / PUSH BP+MOV BP,SP
 * @callees    overlay 0x<seg>:<off>, overlay 0x<seg>:<off>, near 0x<addr>
 * @callers    <count> (see callgraph.json)
 * @verified   boundary OK / RAW / hand-ported
 * @status     STUB / PARTIAL / DONE
 */
RETURN_TYPE func_<offset>_<name>(ARGS) {
    /* Body: either generated or hand-ported */
}
```

The four-character status field gives a quick visual cue:
- `STUB` — auto-generated, body is `/* TBD */`, citation is complete
- `PARTIAL` — body has structure but TODO markers
- `DONE` — body is fully ported with all branches/loops resolved

---

## What we WON'T do

To stay within scope:

- **No format decoder rewrite for overlay-resident loaders**: just
  identify each loader's signature; defer format-spec work to a
  separate `formats/` pass.
- **No byte-equivalent reassembly**: that requires a period-correct
  toolchain we don't have.
- **No semantic verification of unknown-pattern bodies**: a stub with
  citation is acceptable; the user can review individual hand-ports.
- **No rename of every .asm file**: focus on .c emission, not .asm
  housekeeping.

---

## Order of attack

1. **Build tools/overlay_classifier.py and tools/overlay_to_c.py** (1 hour)
2. **Run on all 691 functions, generate stubs into viceroy_source/src/overlay/** (1 hour for the script run)
3. **Identify top-50 by callers** from callgraph.json — hand-port those (4 hours)
4. **Identify the 30 largest** — hand-port those (3 hours)
5. **Update docs and finalize** (1 hour)

Total: ~10 hours.

After this run, every byte of VICEROY.EXE that's been categorized as
"function" by the disassembler will have a citable C representation.
