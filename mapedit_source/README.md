# MAPEDIT.EXE — Reverse-Engineering Workspace

The standalone map editor that ships with Sid Meier's Colonization
(MicroProse 1994). Reads/writes `.MP` map files compatible with VICEROY.EXE.

> **Status (2026-06-18):** the map editor is being **re-approached as a clean,
> modern-C reconstruction**. No clean C source exists yet — see
> [`REWRITE_PLAN.md`](REWRITE_PLAN.md). The earlier auto-generated output has
> been quarantined under [`legacy_autogen/`](legacy_autogen/) because it is
> ~0% semantic (control-flow skeletons only). See the project audit at
> [`/AUDIT.md`](../AUDIT.md) for the full rationale.

## What's here

| Path | What it is | Trust |
|------|-----------|-------|
| `REWRITE_PLAN.md` | The clean modern-C plan (design; not yet code) | — |
| `FUNCTION_INVENTORY.md` | 210 functions: 5 sigmatch `BYTE_VERIFIED` helpers + 205 RAW | evidence |
| `legacy_autogen/` | Auto-traced skeletons — **do not cite as source** | none |
| `../code/MAPEDIT/disasm/*.asm` | Raw per-function disassembly | authoritative |
| `../code/MAPEDIT/*.json` | classification / functions / relocs / strings | authoritative |
| `../code/MAPEDIT/MAPEDIT_ANALYSIS.md` | Binary analysis + next steps | evidence |
| `../formats/MP_FORMAT.md` | `.MP` on-disk format spec | mostly verified |

## Inventory (from the binary)

| Metric | Value |
|--------|-------|
| Original file size | 145,292 bytes |
| Image (load) bytes | 114,185 |
| Overlay bytes (debug data only) | 31,107 |
| Functions detected | 210 |
| Functions hand-decoded to clean C | **0** (rewrite not started) |
| Functions `BYTE_VERIFIED` (shared, via sigmatch) | 5 |

## How MAPEDIT relates to VICEROY

MAPEDIT.EXE shares format-handling OBJ modules with VICEROY.EXE (`.MP` read/write,
`.SS` sprite rendering, `.PAL` palette, `.FF` fonts). Many `load_image` functions
have **identical bytes** to VICEROY functions — those are the shared OBJ modules
and are recoverable directly via `tools/sigmatch.py` rather than re-decoded.

## Conventions

Citations and trust rules follow the project root: see [`/CLAUDE.md`](../CLAUDE.md)
(hard rules) and [`notes/TRUTH_HIERARCHY.md`](../notes/TRUTH_HIERARCHY.md). Every
clean-C function produced under the rewrite must carry an `@asm` + `@asm_file`
citation and a verification tier, exactly as in `../viceroy_source/`.
