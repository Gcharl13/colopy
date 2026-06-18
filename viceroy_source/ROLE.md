# Role of `viceroy_source/` — Layer-1 EVIDENCE (not the product)

> **Reclassified 2026-06-18.** Under the project's three-layer model
> (`/METHODOLOGY.md`), this tree is **evidence**, not the deliverable.

## What this tree is now

`viceroy_source/src/*.c` is a **line-for-line, `@asm`-cited transcript of the
VICEROY.EXE disassembly** — register-named locals (`[bp-0x2c]`), `goto`s at exact
instruction offsets, `far` pointers, RTLink thunks. The `Makefile` itself states
it is a *"DOCUMENTATION Makefile … NOT runnable on a modern host."* It documents
the bytes; it is **not a program**, and it never compiled or ran.

It also carries the scars of the old *decompile → bad code → fix → back to
disasm* cycle (`wave-6/7/9/10/11`, `CORRECTED`, `WRONG FUNCTION`, `FABRICATED`,
superseded files). That cycle is exactly what the three-layer model retires.

## What it is good for

The **byte-verified decode-notes** here (≈47 `BYTE_VERIFIED` functions, plus
many `@asm`-cited control-flow traces) are **raw material for the specification**
(`spec/`). When authoring a Layer-2 spec, mine this tree — and the raw disasm in
`code/VICEROY/` — for the offsets and formulas, then write the clean, cited,
language-neutral spec.

## What it is NOT

- **Not** the source of truth — that is `spec/` (Layer 2), grounded in `code/`.
- **Not** the implementation — the modern, runnable port (Layer 3) is built
  **from the spec**, not from this C. Language TBD.
- **Not** to be "completed" by filling in more line-for-line functions. Effort
  goes into the spec and the `spec/BACKLOG.md` evidence queue instead.

## Trust

Per `notes/TRUTH_HIERARCHY.md`, C reconstruction is **low trust** and never wins
a conflict against the disassembly or NAMES.TXT. Treat everything here as cited
evidence to be re-expressed in the spec, not as settled fact.
