# Reverse-engineering toolchain (`viceroy_source/tools/`)

These scripts rebuild — directly from `COLONIZE/VICEROY.EXE` — the byte-level
analysis layer the project's docs reference (`code/VICEROY/disasm/*.asm`,
`functions.json`, `strings.json`, `anchor_map.md`). Prior sessions did not have
the binary in-repo and were blocked on byte-verification; these tools close that
gap.

## The binary

`VICEROY.EXE` is **not committed** (copyright; `re_work/` and `*.EXE` are
git-ignored). Drop it at `re_work/VICEROY.EXE`. Expected:

| | |
|---|---|
| size   | 494,910 bytes |
| sha256 | `a17ed64c27671e5e95236e54a7ddc85803a96ba822fbed05e1dad34d3917e2e3` |

## Address model (verified)

```
file_offset = LOAD_BASE + (seg << 4) + off        LOAD_BASE = e_cparhdr*16 = 0x2400
```

Segments in instruction operands are **load-module-relative** (the convention the
LCALL/reloc machinery uses). The DGROUP string area base is file `0x1D9A0`
(seg 0x1B5A:0), so a message-key's DGROUP offset = `foff - 0x1D9A0`. The RTLink
thunk table is one block at file `0x1A5F0`, aliased by seg windows
0x181F / 0x191F / 0x1A1F.

Note: some older docs label segments in **Ghidra paragraph** numbering
(= load-module seg + 0x1000), e.g. doc "2b5a" == file-relative "1b5a". The tools
use the file-relative convention throughout.

## Scripts

| script | purpose |
|--------|---------|
| `viceroy_exe.py` | MZ parse, seg↔file-offset, byte/disasm access (capstone 16-bit). `python3 viceroy_exe.py [foff] [n]` to dump. Import `EXE` elsewhere. |
| `strings_scan.py` | extract NUL-terminated ASCII with file offsets + DGROUP offsets + PUSH-imm xref sites → `re_work/strings.json`. |
| `funcscan.py` | prologue/return function-boundary scan (1,248 funcs, matches the documented 1,241). `--emit` writes per-function `.asm` to `re_work/disasm/`. |
| `audit.py` | regression audit of headline BYTE_VERIFIED claims against the binary (27/27 green). **Append a check for every new byte-trace.** |

## Verification loop (cite-or-not yet decoded)

1. Identify a function (string-key xref first, then callgraph/role).
2. Read its bytes: `python3 viceroy_exe.py 0xNNNNN 0xLEN` or `re_work/disasm/func_XXXXXX.asm`.
3. Hand-port to pseudo-C, `@asm`-cite each load-bearing line, mark `BYTE_VERIFIED`
   / `ANCHOR_VERIFIED` / `not yet decoded` — never guess.
4. Add an assertion to `audit.py`; keep it green.
5. Log it in `../VERIFICATION_LEDGER.md`.
