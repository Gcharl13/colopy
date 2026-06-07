# `bin/` — transformed byte-record of the DOS executables

This directory holds the **ground-truth bytes** of the executables this project
disassembles — stored as **base64** (`*.b64`), a non-original, non-runnable format.
They are here so the disassembly can be **continued from a fresh clone**: the RE
tooling (capstone, `tools/disasm_*`, `tools/rtlink/`) needs the real bytes,
addressable by file offset, to disassemble regions not yet covered.

## Reconstitute the real `.EXE` files
```
python bin/reconstitute.py        # run from the repo root; stages into raw/COLONIZE/
```
This decodes each `*.b64` and writes the real `.EXE` into **`raw/COLONIZE/`** — the
path the disasm tool suite (`tools/disasm_mz.py`, `tools/rtlink/`, `callgraph.py`, …)
looks in — verifying every file against `SHA256SUMS.txt`. Pass an explicit dir to
override (e.g. `python bin/reconstitute.py bin` to write beside the `.b64`). The
decoded `.EXE` files are **git-ignored** (never committed in original form).

## What's here
| file | bytes | role |
|---|---|---|
| `VICEROY.EXE` | 483 KB | the main game — primary disassembly target. **File offsets in the disasm/docs (e.g. `0x035D9A`) index this file** (at `raw/COLONIZE/VICEROY.EXE` after reconstitute). |
| `VICEROY_flat.exe` | 449 KB | the **un-EXEPACK'd** VICEROY (the EXEPACK + SZDD layers were resolved; see `notes/` / RULINGS). Use when a region needs the unpacked image. |
| `COLONIZE.EXE` | 444 KB | launcher/front-end |
| `MAPEDIT.EXE` | 142 KB | the map editor (map-format ground truth) |
| `OPENING.EXE` | 87 KB | intro program |
| `CLOSING.EXE` | 81 KB | endgame program |

Each has a `code/<NAME>/disasm/` tree of work-in-progress disassembly.

## Note
Derivative reverse-engineering / preservation material for a copyrighted work,
kept in a **private** repository for interoperability research. The base64 form is
a complete reproduction in a different container — it does **not** change the
copyright status; do not make public or redistribute.
