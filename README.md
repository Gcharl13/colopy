# colopy — reverse-engineered source of *Sid Meier's Colonization* (DOS / `VICEROY.EXE`)

This repository is the **canonical reverse-engineering / disassembly** of the 1994
DOS game *Sid Meier's Colonization* (`VICEROY.EXE`, Microsoft C 6.0 + RTLink
overlays). It is a **self-sufficient disassembly bench**: clone it and you have
everything needed to *continue the core disassembly* — the bytes, the tools, the
work-in-progress disasm, the reconstructed C, and the notes/lessons — with no prior
context. Any port (Python, Godot, native rebuild) is downstream and generated *from*
this source.

## Prime directive
Every reconstructed value traces to a **byte-verified** artifact in the original
binary — a file offset, a `NAMES.TXT` field, or a recorded ruling. **Never guess.**
Un-cited values are marked `TBD`, not invented.

**Method:** the project follows a three-layer model — **evidence → specification
→ implementation** — see [`METHODOLOGY.md`](METHODOLOGY.md). The **specification**
([`spec/README.md`](spec/README.md)) is the source of truth and the entry point
for any port; `viceroy_source/` is reclassified as *evidence* that feeds it
([`viceroy_source/ROLE.md`](viceroy_source/ROLE.md)).

**Orientation:** [`CLAUDE.md`](CLAUDE.md) holds the hard rules; [`STATUS.md`](STATUS.md)
is the current-state dashboard; [`AUDIT.md`](AUDIT.md) records what is correct vs
misleading and the **corrected** completion metrics (the older "100% in citable
C" / "99% identified" headlines conflate syntactic tags with semantic
understanding — see `AUDIT.md` §4). Several legacy status docs (`PROGRESS.md`,
`DISASM_COMPLETION.md`, `WEEK1_SUMMARY.md`, `OVERLAY_PLAN.md`) are stale and
banner-marked.

## First run (continuing the disassembly)
```bash
pip install -r requirements.txt                    # capstone is the one hard dependency
python bin/reconstitute.py                         # rebuild the 6 DOS .EXE into raw/COLONIZE/ (sha256-verified)
python tools/disasm_mz.py --exes VICEROY.EXE       # -> ~1241 funcs / 212k insns into code/VICEROY/disasm/
python tools/rtlink/rtlink_decode.py validate --exe bin/VICEROY.EXE   # -> VALIDATION: ALL PASS
```
`reconstitute.py` stages the executables into `raw/COLONIZE/` — the path the whole
tool suite looks in — so the bench works out of the box. Capstone-by-offset also
works directly: file offsets in the disasm/docs (e.g. `0x035D9A`) index
`raw/COLONIZE/VICEROY.EXE` (or `bin/VICEROY.EXE`).

Then for orientation: `notes/TRUTH_HIERARCHY.md`, `viceroy_source/DOC_INDEX.md` (doc
map), `viceroy_source/VERIFICATION_LEDGER.md` (`BYTE_VERIFIED` vs skeleton), and
`viceroy_source/RECONSTRUCTION_PLAN.md` + `PROGRESS.md` (roadmap).

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
data_extracted/   decoded data tables (NAMES/GAME sections, palette, map, strings)
                  + a disassembly snapshot. (Graphics-asset metadata is NOT here —
                  it's a deferred visual phase, regenerable via tools/extract_visuals.py.)
mapedit_source/ opening_source/ closing_source/   companion-program decompilations
```

## Status — phased import
- [x] **Phase 1** — reverse-engineered C source (`viceroy_source/`).
- [x] **Phase 2** — DOS disassembly, RE tooling, notes/catalogs/rulings, byte-record.
- [x] **Phase 3 (data)** — decoded data tables (`data_extracted/`).
- [ ] **Phase 3 (images)** — the PNG / sprite / screenshot extractions (deferred;
      downstream/port concern, regenerable from the bytes via the asset tools).

## Scope decisions (deliberate)
- **DOS only.** The Win16 build was a throwaway analysis *oracle*; its findings are
  folded into the DOS-cited docs. No Win16 source, binaries, or tooling here.
- **No verbatim binaries** as `.EXE` (they live as `bin/*.b64`; `reconstitute.py`
  rebuilds them locally into git-ignored `raw/`), **no runtime session dumps**, **no
  ports**, **no build/engine artifacts** — all regenerable or cruft.
  - *Known exception:* `col.zip` is a convenience bundle of the original game
    files (incl. `VICEROY.EXE`, `AMER2.MP`) kept at the repo root. It is verbatim
    and redundant with `bin/*.b64`; retained by decision. See `AUDIT.md` §3.6.

> Private repository. Derivative reverse-engineering/preservation analysis of a
> copyrighted work — do not make public or redistribute. See `bin/README.md`.
