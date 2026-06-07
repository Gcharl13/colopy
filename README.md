# colopy — reverse-engineered source of *Sid Meier's Colonization* (DOS / `VICEROY.EXE`)

This repository is the **canonical reverse-engineering / decompilation** of the
1994 DOS game *Sid Meier's Colonization* (`VICEROY.EXE`, Microsoft C 6.0 + RTLink
overlays). It is meant to be the durable source of truth: the reconstructed C plus
the notes and lessons learned, structured so that the decompile can be **continued
from this repo alone** — or any port (Python, Godot, a native rebuild) generated
from it — even with no prior context.

## Prime directive
Every reconstructed value traces to a **byte-verified** artifact in the original
binary — a file offset, a `NAMES.TXT` field, or a recorded ruling. **Never guess.**
If a value can't be cited, it's marked `TBD`, not invented.

## Status — phased import
This repo is being assembled in phases (largest, most-derivable assets last):

- [x] **Phase 1 — reverse-engineered C source** (`viceroy_source/`): the decompiled
      C (`src/`, 127 files), headers (`include/`), the reconstruction docs + the
      verification ledger (`docs/`), the `Makefile`, and the call/thunk-resolution
      analysis JSON.
- [ ] **Phase 2** — DOS disassembly, the RE tooling, and the top-level
      catalogs/rulings (notes & lessons).
- [ ] **Phase 3** — decoded data tables and the visual-asset extractions (PNGs).
- [ ] **Byte record** — `VICEROY.EXE` in a *non-original, transformed* format
      (to allow re-disassembly of regions not yet covered).

## Scope decisions (deliberate)
- **DOS only.** The Win16 build was used only as a throwaway analysis *oracle*; its
  findings were folded into the DOS-cited docs. No Win16 source or binaries live here.
- **No verbatim original game binaries**, **no runtime session dumps**, **no ports.**
  Ports and visual renders are downstream and regenerable from this source.

## Where to start (continuing the decompile)
1. `viceroy_source/README.md` and `viceroy_source/DOC_INDEX.md` — orientation.
2. `viceroy_source/VERIFICATION_LEDGER.md` — what is `BYTE_VERIFIED` vs. a skeleton.
3. `viceroy_source/RECONSTRUCTION_PLAN.md` + `PROGRESS.md` — the roadmap and status.
4. `viceroy_source/FUNCTION_INVENTORY.md` — the function catalog.

> Private repository. Contains derivative reverse-engineering analysis of a
> copyrighted work, kept for preservation/interoperability research — do not make
> public or redistribute.
