# Ghidra-assisted decompilation workflow

A force-multiplier over the existing RE pipeline, used to draft and **cross-check**
function bodies. Ghidra C is a fast first pass and an *independent second reading*
of the same bytes — **not** ground truth. Every ported value still cites its
`@asm` file offset; `re_work/disasm/*.asm` remains the source of truth.

## Why it helps (and where it doesn't)

The custom pipeline already covers overlay/thunk resolution (`ovlresolve.py`,
`rtlink/flatten.py`), arity histograms (`arity_truth.json`), DGROUP naming
(`dgroup_map.py`), and xref lookup (`whois.py`). The genuine gap was the lack of
an **asm → structured-C** step. Ghidra fills exactly that:

- **Decompiled bodies** for the BODY-MISSING backlog (undefined `func_0XXXXX`
  symbols with a disasm file) — structured `if/while/switch` + recovered locals,
  far faster to port than reading linear asm.
- **Independent verification.** Where Ghidra C and the hand-port agree, confidence
  is high; where they diverge, it's a flag. (See validation below.)

It does **not** replace the byte-cite discipline, and on functions whose flow
crosses overlay/segment boundaries it emits `pcode error / non-existing memory`
warnings — those bodies need manual attention against the `.asm`.

## Setup (one-time, per ephemeral container)

- JDK 21+ (present on the standard image).
- Ghidra >= 12.x. Download the official release zip, unzip under
  `/home/user/ghidra/` (auto-detected) or set `GHIDRA_HOME`.
  The install and all decompiled output are **gitignored / ephemeral** — only the
  tooling in `tools/ghidra/` is committed.

## Load model: flat file-offset == address

VICEROY.EXE is imported as a **Raw Binary**, `x86:LE:16:Real Mode`, base 0.
Ghidra lays it out in 64 KB segment blocks (`0000`, `1000`, `2000`, …), so a flat
file offset `F` maps to `((F & 0xF0000) >> 4):(F & 0xFFFF)` — e.g. `func_03E162`
→ `3000:e162`. This is deliberately consistent with the project's existing
file-offset addressing (the `.asm` files and every `*.json` are keyed by file
offset), so Ghidra is a drop-in second engine over the same address space.

`ReconDecomp.java` does that flat→segmented translation, ensures a function exists
at the target, decompiles it, and writes `func_<hex>.c`.

## Usage

```sh
# ad-hoc:
tools/ghidra/decomp.sh 0x3e162 0x4900

# batch (one func_XXXXXX or 0xHEX per line; '#' comments ok):
tools/ghidra/decomp.sh --list /tmp/body_missing.txt
```

First invocation imports + analyzes once (~2 min); later runs reuse the saved
project (`-process … -noanalysis`) and decompile in seconds. Output goes to
`$GHIDRA_OUT` (default `/home/user/ghidra/out`), which is **not** committed.

## Validation (why this output is trusted)

`func_03E162` decompiled to the byte-exact logic of the hand-port
`king_ref_buildup` (src/king/ref.c), including the per-power REF-cost write:

```c
*(int *)(iVar3 + 0xe) = *(int *)(iVar3 + 0xe) + (uint)*(byte *)(param_1 + -0x6bf8);
```

`param_1 - 0x6BF8` with 16-bit wraparound ≡ `active_power + 0x9408`, i.e.
`king[+0xE] += DG8(active_power + 0x9408)` — matching the port's reverse-engineered
byte arithmetic exactly. The `d*8+10` increment, the 1600/1700/1750 era doublings,
the 0x708 threshold, and the slot-ratio picks all matched line-for-line.

A second sample: `func_004900` (wired this session as `overlay_call_181F_0370`)
decompiled to `abs/abs; max + (min>>1)` — a Chebyshev-style distance metric,
confirming the wire and supplying the exact body.
