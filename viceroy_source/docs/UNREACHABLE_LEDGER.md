# UNREACHABLE / terminal-verdict ledger (Gate G4)

Every symbol that ends in the **UNREACHABLE(proof)** or **MODERN-REPLACED**
terminal state, with its proof line.  Companion to the machine census in
`docs/TERMINAL_STATES.md` (tools/terminal_census.py).  Rules:

- A verdict needs a byte-level or link-level PROOF LINE — a cite that the
  original cannot reach the code on any gameplay path, or that the modern
  platform substitutes it by design.
- "Display no-op in headless" is NOT unreachable — those rows stay open
  until Phase-7 pixel parity exercises them.

## MODERN-REPLACED (platform substitution by design)

These DOS-platform translation units are excluded from the modern build;
their function inventory is satisfied by `src/platform/` at final link.
Proof: CMakeLists exclusion + the platform implementations.

| original unit | replaced by | proof |
|---|---|---|
| `src/boot/entry.c` (DOS MZ entry, system_init) | `src/platform/main_modern.c` | CMakeLists.txt filter; modern entry sets up dgroup/data_load directly |
| `src/runtime/cstart.c` (MSC C startup) | host crt + `main_modern.c` | CMakeLists.txt filter |
| `src/overlay/rtlink.c` (RTLink overlay loader) | flat link (all pages resident) | CMakeLists.txt filter; thunks resolve via linkfloor PROVIDE aliases |
| `src/render/blit.c` leaf-emitter wrappers | `src/platform/render_glue.c` (64 strong defs) | nm: every blit.c surface symbol is a `T` in the final binary |

## RESOLVED-LIBC (host C runtime satisfies by design)

38 symbols (`atoi`, `close`, `memcpy`, `strcat`, the `__*_chk` fortify
artifacts, ...) import from the host libc at final link.  Proof:
`nm -D --undefined-only build_modern/viceroy_modern` lists each; the
DOS-side bodies they shadow are the MSC RTL routines whose byte-verified
ports live in `src/runtime/` + `src/iolib/` and are used where DOS
semantics differ (CR/LF translation, DOS handles).  Full list in
TERMINAL_STATES.md §RESOLVED-LIBC.

## UNREACHABLE(proof) — byte-proven dead on every gameplay path

| symbol / site | proof line |
|---|---|
| `overlay_call_181F_0772` callers' DIAGNOSTIC branches (screen-ids 0x28/0x29/0x2A/0x2D) | func_077D5E fatal/diagnostic reporter gates on verbosity word [0x2476] (`@0x077D70 cmp [0x2476],dx; jl skip`); the DGROUP init image holds 0 and NO writer raises it (Phase 3.4 audit) — all four call sites are suppressed at runtime in the original too. Strong no-op stands in for the suppressed call. |
| `FONTSMAL.FF` loader path | the EXE loads exactly 4 fonts via LCALL 0x1A1F:0x0A86 (@0x0760E8/@0x0760C2/@0x0754F2/@0x06B7AB); no reference to FONTSMAL exists in VICEROY.EXE (docs/UI_FIDELITY.md "Fonts") — on-disk orphan. |
| MT-32 / MPU-401 music path (config-dependent) | declared UNREACHABLE-BY-CONFIG per ROUTE_B Phase 5.2 unless the user opts in: the AdLib path is the reference; MT-32 requires RSOUND.COL + MPU-401 hardware the modern platform does not emulate. Pending Phase-5 confirmation against the byte-verified device dispatch. |

## OPEN — candidate verdicts needing proof work

- DOS EMS paging / serial / IRQ leaves inside the BODY-MISSING set (Phase
  4.6 residue): each needs a caller-graph proof line before a verdict.
- `probe_soundblaster`/`probe_adlib` hardware port probes: will become
  MODERN-REPLACED when Phase 5 lands the host audio device model.
