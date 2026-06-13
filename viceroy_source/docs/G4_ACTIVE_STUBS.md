# Gate G4 — the link-active weak-stub worklist

Generated/refreshed by `tools/active_stubs.sh` (reads the linked
`build_modern/viceroy_modern`). This is the **accurate** G4 worklist.

## Real-data validation harness (2026-06-13) — the decisive signal

The user's COLONIZE data lives in `col.zip` on `main`; extracted to a gitignored
runtime dir and pointed at via `VICEROY_DATA`. Running the smoke with real data
is a working validation harness — it drives the real per-turn event / market /
king logic, not the empty-data path. **This corrected a false signal:** the
"0 stub hits" reported under no data was an artifact; with real data the smoke
hits real code.

```sh
VICEROY_DATA=<COLONIZE-dir> ./build_modern/viceroy_modern --smoke=500 --stub-report
```

Real-data gameplay-reachable stub baseline:

| stage | distinct symbols | calls |
|---|--:|--:|
| initial (real data) | 15 | 3519 |
| after MODERN-REPLACE of display/input (`headless_io_stubs.c`) | **12** | **16** |

The 3500-call dominator was `overlay_call_1059_000A` (modal input poll) plus two
render leaves (clear-region, draw-header-text) — all correct headless no-ops,
now strong MODERN-REPLACED defs. The remaining **12 symbols / 16 calls** are
genuine low-frequency logic gaps (NOT display, so not no-op-able):

- **message formatters** (`overlay_call_181F_016E` strcat_str, `_0182` fmt_int,
  `_011E` label-prefix, `_01BE` separator, `_0128` finalize) — build the event
  text (`[INDIANSURPRISE]`, `[PRICEDOWN]`, …); call-site comments give the args,
  so each needs its C call site completed with the right `(buf, value)` args.
- **`power_set_flag`** (3) — the multiplexed `0x181F:0x0438` (diplomacy flag-set
  vs `func_06C23C_dialog_make_from_int`); needs 3rd-party cross-ref to pin the
  diplomacy-resident leaf.
- **`overlay_call_0D1D_07A4`** — GAME.TXT key 0xBA7 loader; **`ff_pre_a`** — FF
  effect; **`func_06B692`** — skipped Phase-4.8 cluster member (now proven
  reachable); **`overlay_call_02D8_000E`**, **`_181F_0422`**, **`_181F_040A`**.

This is the real Gate-G4 clause-2 worklist (validatable: fix, re-run, watch the
count drop). Clause 2's full closure still needs the unported in-game screens
running + DOSBox for byte-parity.

## The measurement correction

`tools/linkgap.py` counts symbols **undefined in `libviceroy_rules.a`** — its
"func_body 149" tally. That over-counts what G4 actually requires, because at
final link most of those are satisfied by:

- a strong definition elsewhere in the rules lib (referenced one place,
  defined in another object — `nm` shows `U` per-object but `T` overall),
- a strong definition in a **separately linked `src/platform/` object**
  (e.g. `func_01041A_dos_delete_file` lives in `dos_service_glue.c`), or
- a `PROVIDE(...)` alias in `tools/linkfloor_extra.ld`.

The stubs that actually stay live are the weak symbols that survive
**un-overridden into the executable** — `nm viceroy_modern` shows them as `W`.
That set, not the `.a` undefined list, is the real G4 worklist.

## Current census (2026-06-13, after Phase 4.8)

| metric | count |
|---|--:|
| link-active weak `func_` stubs (Phase 4.7) | 64 |
| — wired in Phase 4.8 (→ ported leaves) | −36 |
| **link-active weak `func_` stubs (now)** | **28** |
| named (render/audio/named-gap) stubs | ~855 |

The 36 wired and the 28 remaining (per-item dispositions) are tracked in
**`docs/PHASE4_THUNK_LEDGER.md`**. The 28 residue are unported screen/AI
leaves, mid-function entry-splits, one partial dialog port (`func_04A7CA`),
and platform/dispatch candidates — none safely auto-wireable without the
Phase-7 validation harness (which needs the user's game data + DOSBox).

Smoke note: `--smoke=500 --stub-report` hits **0** of these on the AI-only
path. G4 asks whether any are reachable on a *full-verb* path — that is the
reachability work, plus the Phase-7 DOSBox parity (needs user game data).

## The 2 standalone bodies

- **`func_0114E4`** (694 B) — the DOS **INT 21h text-mode line reader**
  (`fd=[bp+6], buf=[bp+8], count=[bp+0xa]`, CR/LF + Ctrl-Z/EOF handling),
  i.e. the MSC C-runtime `fread` primitive called via `func_0115CE`. The
  modern build reads data files through host stdio (`data_load.c`), so this
  is a strong **MODERN-REPLACED** candidate — pending a reachability proof
  that no live modern path reaches the DOS-overlay loaders
  (`load_image_00FAAA`, `load_image_010B26`) that call it. Do **not** port
  the INT 21h body verbatim onto the modern host.
- **`func_04A7CA_speak_with_chief`** (1077 B) — native-chief diplomacy dialog.
  A genuine remaining body, but dialog/UI-heavy and not smoke-reachable, so it
  can only be cross-checked statically (`.asm` + Ghidra) until the full-verb
  harness exists. Prime candidate for a Ghidra-assisted port.

## The 62 thunk / multi-entry symbols (wire / split / verdict — not "port a body")

- **RTLink far-jump trampoline clusters** (5-byte `ljmp` stride): `func_03EA0B`
  …`func_03EA38` (1A1F window), `func_0613F5`…`func_06144F`, `func_06B67E`
  …`func_06B6BA`. Each is a thunk into an overlay leaf — resolve the target
  (decode the `ljmp seg:off`, cf. `func_03EA10 → 1A1F:0x070`) and `PROVIDE`-wire
  it to the ported leaf, **or** record an UNREACHABLE verdict if only superseded
  parents reference it. (`func_03EA10` *is* live — referenced at
  `overlay_03C5A8_040C11.c:1301`.)
- **Mid-function entry points** (no bare disasm; a containing function exists):
  `func_02C9B5/02C9BF/02CA1E/02CA23/02CA46/02CA55/02CAC3/02CAE1`, and singles
  like `func_03689A`, `func_039E53`, `func_05BE3E_terrain_class`. These need an
  ENTRY-SPLIT or an alias to the ported parent.
- **Near-call helpers**: `func_006696`, `func_00CCEB/CE98/CEAD`, `func_015219`,
  `func_016127`, `func_03F1598`, `func_03F940`, `func_0400EA`, `func_04172D`,
  `func_041732`, `func_05A938/93D`, `func_05E723`, `func_06BAEC`.

## Reachability analysis (`tools/reachability.py`)

Builds the original call graph from the disasm (near calls + far `lcall`s
resolved via `lcall_resolution_VICEROY.json`), roots it at every `func_`
**call site** in modern `src/*.c`, and forward-reaches. Because a C
reimplementation can drop calls the original made, original-edge reachability
is an over-approximation — so "no path" is a *sound* one-sided result. Caveat:
the graph carries only **direct** near/far edges, not indirect dispatch (jump
tables / function pointers), so "no static-call path" is a candidate that still
needs the indirect-dispatch check before a final UNREACHABLE verdict.

Run on the 64 active `func_` stubs:

| result | count | meaning |
|---|--:|---|
| has static-call path | 62 | genuinely reachable via direct calls → must wire/port |
| no static-call path  | 2  | `func_04A7CA`, `func_05BE3E` — 0 direct callers → dispatch-reached |

Key findings:

- **The 62 are real work, not skippable.** The thunk clusters all have live
  overlay callers (e.g. `func_061409 ← func_06083A/060C34/060EC4/060FBC`), so
  the `func_03EAxx`/`func_0613xx`/`func_06B6xx` trampolines must be wired to
  their leaves, and the `func_02C9xx` mid-entries split from their parents.
- **The 2 "no direct caller" cases are dispatch-reached, and one is already
  solved.** `func_04A7CA` is marked **`[SUPERSEDED]`** in
  `overlay_046D70_04C2E1.c` (native village raze / CHIEFKILL, reimplemented in
  C) and is reached only through `1A1F:0x41C` — so the live stub
  `func_04A7CA_speak_with_chief` is a **thunk to wire onto the existing C
  body**, not a function to port. This is the tool working as intended: a
  meaningful name + 0 direct callers ⇒ dispatched, not dead.

Usage:

```sh
tools/reachability.py audit /tmp/active_func.txt   # classify a stub list
tools/reachability.py callers func_03EA10          # transitive caller chain (verdict evidence)
```

## How to refresh

```sh
tools/active_stubs.sh            # after any rebuild: the link-active stub set
tools/reachability.py audit ...  # classify reach/no-path for a stub list
```
