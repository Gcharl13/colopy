# Gate G4 — the link-active weak-stub worklist

Generated/refreshed by `tools/active_stubs.sh` (reads the linked
`build_modern/viceroy_modern`). This is the **accurate** G4 worklist.

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

## Current census (2026-06-13)

| metric | count |
|---|--:|
| link-active weak symbols (all) | 919 |
| link-active weak `func_` stubs  | 64 |
| ├─ standalone body (has disasm) | 2 |
| └─ thunk / multi-entry (no bare disasm) | 62 |
| named (render/audio/named-gap) stubs | 855 |

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

## How to refresh

```sh
tools/active_stubs.sh            # after any rebuild
```
