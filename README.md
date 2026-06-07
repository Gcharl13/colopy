# colopy — reverse-engineered source of *Sid Meier's Colonization* (DOS / `VICEROY.EXE`)

This repository is the **canonical reverse-engineering / disassembly** of the 1994
DOS game *Sid Meier's Colonization* (`VICEROY.EXE`, Microsoft C 6.0 + RTLink
overlays). It is a **self-sufficient disassembly bench**: clone it and you have
everything needed to *continue the core disassembly* — the bytes, the tools, the
work-in-progress disasm, the reconstructed C, and the notes/lessons — with no prior
context required. Any port (Python, Godot, native rebuild) is downstream and
generated *from* this source.

## Prime directive
Every reconstructed value traces to a **byte-verified** artifact in the original
binary — a file offset, a `NAMES.TXT` field, or a recorded ruling. **Never guess.**
Un-cited values are marked `TBD`, not invented.

## Layout
```
viceroy_source/   reconstructed C (src/ 127 files, include/, docs/, Makefile)
code/             work-in-progress DOS disassembly (VICEROY, COLONIZE, MAPEDIT,
                  OPENING, CLOSING) + overlay/thunk resolution maps
bin/              transformed byte-record of the 6 DOS exes (base64) + reconstitute.py
tools/            the RE/disasm tool suite (capstone drivers, rtlink decoder,
                  callgraph, sigmatch, auto-namer, xref scanners, …)
ghidra_export/    Ghidra disassembly reference
docs/             RE findings (DATA_MODEL, RESIDUAL_FINDINGS, GHIDRA_REFERENCE,
                  IMMIGRATION_RECRUIT_FINDINGS, RTLINK_OVERLAYS, …)
notes/            project catalogs + RULINGS + the truth hierarchy + tech reference
formats/          on-disk file-format specs (.MP/.SS/.PAL/.PIK/…)
data_extracted/   decoded data tables (JSON/text) — NO images yet
mapedit_source/ opening_source/ closing_source/   companion-program decompilations
```

## First run (continuing the disassembly)
```
python bin/reconstitute.py          # rebuild the real .EXE files from bin/*.b64 (sha256-verified)
```
Then: `notes/TRUTH_HIERARCHY.md` and `docs/DOC_INDEX*` for orientation;
`viceroy_source/VERIFICATION_LEDGER.md` for what's `BYTE_VERIFIED` vs skeleton;
`viceroy_source/RECONSTRUCTION_PLAN.md` + `PROGRESS.md` for the roadmap.

## Status — phased import
- [x] **Phase 1** — reverse-engineered C source (`viceroy_source/`).
- [x] **Phase 2** — DOS disassembly, RE tooling, notes/catalogs/rulings, byte-record.
- [x] **Phase 3 (data)** — decoded data tables (`data_extracted/`, JSON/text).
- [ ] **Phase 3 (images)** — the PNG / sprite / screenshot extractions (deferred).

## Scope decisions (deliberate)
- **DOS only.** The Win16 build was a throwaway analysis *oracle*; its findings are
  folded into the DOS-cited docs. No Win16 source, binaries, or tooling here.
- **No verbatim binaries** (they live only as `bin/*.b64`), **no runtime session
  dumps**, **no ports**, **no build/engine artifacts** — all regenerable or cruft.

> Private repository. Derivative reverse-engineering/preservation analysis of a
> copyrighted work — do not make public or redistribute. See `bin/README.md`.
