# mapedit_source/legacy_autogen/ — DO NOT CITE AS SOURCE

**Status: auto-generated control-flow skeletons. ~0% semantic. Retained only
as a cross-index back to the disassembly.**

These files (`src/mapedit.c`, `src/load_image/*.c`, `mapedit.h`, `include/*`)
were emitted by `tools/emit_c_chunks.py` / `tools/build_mapedit_source.py`. Each
"function" is an **auto-traced control-flow trace** of the MAPEDIT.EXE
disassembly — every body is `@status SKELETON (auto-traced control flow;
semantics TBD)`. The register operations and their meaning were **discarded**
during generation; what remains is branch scaffolding like:

```c
int func_015CA2_logic_sz_70(uint16_t arg0_bp_06, ...) {
    if (/* JE fallthrough cond: */ ax != 0) /* @0x015CD3 JE 0x015CD7 */ { }
    return 0;  /* @auto: TODO confirm return semantics */
}
```

This is **not** reverse-engineered source. It looks like ~6,500 lines of C but
carries **no recoverable logic**. It was previously presented (in the old
`mapedit_source/README.md`) as having "hand-ported semantic detail on the
largest functions" — **that claim was false for MAPEDIT** and is corrected in
the audit (`/AUDIT.md`).

## Why it's kept and not deleted
The only value here is the `@asm` / `@asm_file` citation blocks, which index
each function to its raw disassembly in `code/MAPEDIT/disasm/`. Treat this
directory as a **lookup table from function offset → disasm file**, nothing more.

## What to use instead
- Authoritative raw evidence: `code/MAPEDIT/disasm/*.asm`, `code/MAPEDIT/*.json`,
  `code/MAPEDIT/MAPEDIT_ANALYSIS.md`.
- Function index: `../FUNCTION_INVENTORY.md` (5 sigmatch BYTE_VERIFIED helpers +
  205 RAW).
- File format: `../../formats/MP_FORMAT.md`.
- The clean rebuild plan: `../REWRITE_PLAN.md`.

Per the project Truth Hierarchy (`notes/TRUTH_HIERARCHY.md`), C reconstruction
is **low trust** and auto-generated C lower still. Nothing in this directory
wins a conflict against the disassembly or NAMES.TXT.
