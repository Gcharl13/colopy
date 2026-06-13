# Phase 4 — thunk-floor disposition ledger

Row-by-row disposition of the link-active weak `func_` stubs (the set from
`tools/active_stubs.sh`). Phase 4 is done when every row is **WIRED**,
**PORTED**, or **UNREACHABLE(proof)**. Resolutions come from `tools/whois.py`
+ the thunk-window decode; reachability from `tools/reachability.py`.

## Progress

| | count |
|---|--:|
| link-active weak `func_` stubs at Phase-4.7 | 64 |
| **wired in Phase 4.8** (→ ported same-page leaves) | **36** |
| remaining | **28** |

Smoke green throughout: 500 turns, year 1992, REF 131/44/21/32 = 228, 0 stub hits.

## Wired in Phase 4.8 (terminal: WIRED)

Three `ljmp seg:off` trampoline clusters + 3 singles, each resolved to its
same-page ported overlay leaf and PROVIDE-aliased in `tools/linkfloor_extra.ld`:

- **`func_0613xx`** (19) → map-view tile/menu leaves in `overlay_05C69C_0610DA.c`
- **`func_06B6xx`** (9) → list-widget/legend leaves in `overlay_068A14_06C1CC.c`
- **`func_03EAxx`** (6) → page-06 war/colony leaves
- **singles** (3): `func_03689A→func_03200A`, `func_039E53→func_037340_rtl_sz_100`,
  `func_0400EA→func_040002_logic_sz_42`

These serve screens not yet reachable in the modern shell (the in-game map loop
is unported), so the wires are **latent** — observably safe now (smoke is the
regression guard), with dynamic correctness deferred to Phase 7. Per-thunk
caveat: some C call sites are void-declared while the leaf expects args
(`func_03EA10()` → `func_03C4A2(mode,power)`); these read garbage args **only**
when the (currently unreachable) screen runs, and must be re-checked against the
leaf signature during Phase-7 validation.

## Remaining 28 (per-item disposition)

### Leaf UNPORTED — port the leaf, then wire (15)

The trampoline resolves cleanly, but its overlay leaf has no C body yet.

| thunk(s) | leaf (unported) | region |
|---|---|---|
| `func_02C9B5/02C9BF/02CA1E/02CA23/02CA46/02CA55/02CAC3/02CAE1` | `func_026AB2/027954/02798C/026DD4/026CC2/026BCC/02633E/026FF2` | names/string panel |
| `func_05A938 / func_05A93D` | `func_05A40E / func_05A20E` | AI region |
| `func_05E723` | `func_05B2C2` (AI consequence applier) | AI region |
| `func_03EA33` | `0x3CA0A` (not inside a known function span) | page-06 |
| `func_06B692 / func_06B6B5 / func_06BAEC` | `0x69304 / 0x68EE0 / 0x6B6C4` (not in span) | list/legend |

### Mid-function entry points — entry-split required (8)

No standalone disasm at the offset; the byte is inside a larger function. These
are near-call labels (`call 0x….`) into a parent body. Splitting means exposing
the parent's code at that offset as a callable C function.

`func_006696`, `func_00CCEB`, `func_00CE98` (masked row copy), `func_00CEAD`
(advance/store), `func_015219`, `func_016127`, `func_04172D` (near 0x172D
move-validate, in `func_040656/0409D6`), `func_041732` (near 0x1732 unit-place).
`func_03F940` (near 0x142→`func_03F946`) and `func_03F1598` (a synthetic
near-helper placeholder name; offset is past the image) are the same shape.

### Partial port — complete the body (1)

`func_04A7CA_speak_with_chief` (507+ B, native CHIEFKILL/speak-with-chief).
`confront.c` carries its own weak stub and calls it; only the gold sub-computation
is ported (`native/native_village_raze.c:native_village_raze_gold`). Reached via
`1A1F:0x41C` (so 0 direct callers — dispatch-reached, as `reachability.py` flags).
Needs the full dialog handler ported (Ghidra-assisted) before it can be wired.

### Platform substitution candidate (1)

`func_0114E4` — the DOS **INT 21h text-mode `fread` primitive** (`func_0115CE`),
4 live static callers (the DOS-overlay data loaders `load_image_00FAAA`,
`load_image_010B26`). The modern build reads data files through host stdio
(`data_load.c`), so this is a strong **MODERN-REPLACED** candidate — pending a
proof that no live modern path invokes the DOS-overlay loaders. Do **not** port
the INT 21h body verbatim.

### Dispatch-reached, needs jump-table proof (1)

`func_05BE3E_terrain_class` — 0 direct callers; reached via a dispatch table /
function pointer. Needs the indirect-dispatch trace before a verdict.

## Gate G4 status

- **Clause 1** ("zero gameplay-reachable weak stubs"): structural `func_` stubs
  down 64 → 28; the 28 need leaf ports / entry-splits / partial-port completion.
- **Clause 2** ("stub counter 0 across the Phase-7 playthrough suite"):
  **BLOCKED** — needs the user's COLONIZE game data + DOSBox to run the
  full-verb playthrough/parity suite. The AI-only smoke holds at 0.
- **Clause 3** (UNREACHABLE_LEDGER complete): the remaining rows are mostly
  *reachable-but-unported* (not unreachable), so they resolve by porting/wiring,
  not by ledger verdict; the genuine UNREACHABLE candidates (`func_0114E4`,
  `func_05BE3E`) await their dispatch/loader proofs.
