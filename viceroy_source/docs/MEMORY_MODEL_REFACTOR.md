# Memory-model refactor (milestone 2) — status & plan

Goal: make the byte-exact decompiled rules layer **compile and run on a modern
host** so that "all that's left is the modern Windows/SDL components." The game
keeps all mutable state in one 16-bit data segment (DGROUP); the refactor maps
that segment onto real memory without disturbing the byte-exact logic.

## Done (committed, compile-verified `-Wall` in both modes)

1. **DGROUP memory layer** (`include/dgroup.h`, `src/runtime/dgroup.c`). The 64 KB
   segment is a real array `g_dgroup[]` under `-D_VICEROY_MODERN`; every DS offset
   `N` maps to `&g_dgroup[N]`. In DOS mode `DG_BASE=0`, so behavior is byte-
   identical. Typed accessors `DG8/DGS8/DG16/DGS16/DG32`, `DG_PTR`, `DG_TABLE`.

2. **~328 scalar pokes converted** to the accessors (`tools/poke_to_dgroup.py`),
   across 19 files. Expression-equivalent in DOS mode; runs against `g_dgroup`
   in modern mode. Addresses preserved, so `@asm` citations stay valid.

3. **Record-table aliasing**. `unit_table` / `power` / `ai_personality` are now
   real pointer variables initialized to `DG_BASE+offset`, so name-indexed access
   (`power[p].gold`) and offset pokes (`DG8(0x3144+i*0x1C+2)`) are the same byte.
   Local vars/params named `power` (92 of them) shadow the global as before.

4. **`ctx` current-colony pointer (item A — DONE 2026-06-09)**. All 4 pointer-to-
   pointer pokes at DGROUP:0x8542 converted. Changes:
   - `dgroup.c` defines `struct colony_t far *ctx = NULL` (declaration was already
     in `globals.h`).
   - Write site (`load_image_008262_008C6F.c`): renamed local `ctx`→`ctx_local`,
     pointer computation now uses `DG_BASE+0x5D46+...` (works in both modes),
     global `ctx` is set via `ctx = (struct colony_t far *)ctx_local`, and
     `DG16(0x8542)` is kept in sync for DOS compatibility.
   - Read sites (`load_image_008C70_00AAB9.c`×3): all replaced with
     `unsigned char near *ctx_local = (unsigned char near *)ctx` — hoisted above
     the loop where the original re-read on every iteration. `DG32(ctx+0xC6)`
     replaced with `*(uint32_t near *)(ctx_local+0xC6)` (the DG_BASE truncation
     would corrupt the address in modern mode).

## Remaining

### B. ~92 remaining raw pokes — DONE 2026-06-09

Enhanced `poke_to_dgroup.py` to handle:
- `(uint16_t)(expr)` / `(uint16_t)var` — stripped the redundant size cast and returned
  the inner expr as the offset operand (safe: DGn already casts to uint16_t).
- `(unsigned)var` — same treatment for the `unsigned` cast form.
- `#  define` lines with spaces after `#` — fixed detection regex.
- Multi-pass loop (up to 8) to handle nested pokes like `DG8(DG16(si+4))`.

Applied automatically to 5 files (74 pokes), manually fixed 2 more:
- `overlay_03C5A8_040C11.c`: Updated `#ifndef G8` macros to use `DG8`/`DG16`.
- `overlay_06D938_0702D5.c`: `*(uint8_t near*)(unsigned)si = 0x20` → `DG8(si) = 0x20`.

Remaining intentional non-conversions (all correct as-is):
- 6 output-parameter writes in `008C70` (`*(T near *)arg*_bp_*`) — not DGROUP pokes.
- 1 pointer-relative dereference: `*(uint32_t near *)(ctx_local + 0xC6)` — converting
  to `DG32(ctx_local + 0xC6)` would truncate a 64-bit pointer in modern mode; must
  remain as direct pointer arithmetic.
- 10 `#define` macro bodies in 4 overlay files — correctly left untouched.

### C. Build wiring — DONE 2026-06-09

**The organised rules layer compiles green.** `cmake --build build_modern`
produces `libviceroy_rules.a` (95 objects) with **zero errors** under
`-D_VICEROY_MODERN`. Got there by clearing a 499→0 error cascade (struct layout,
stale field-name drift, cross-file decl/arity, comment-terminator corruption,
missing externs/constants) across colony/, unit/, combat/, king/, market/,
native/, diplomacy/, founding_fathers/, mapgen/, scoring/, save/, ui/, overlay/,
random_events/, iolib/, runtime/.

**Link surface (next phase).** The static archive has ~2018 undefined symbols;
~850 are `func_0XXXXX` / `overlay_call_*` bodies that live in the excluded
`load_image/` scaffolding (or aren't ported yet), plus ~43 render and ~26 audio
leaves. So *compiling* is done; *linking a runnable binary* is gated on the
load_image decompilation backlog (item D) + the SDL leaves.

**CMake target (DONE).** `CMakeLists.txt` builds the `src/` rules layer +
`runtime/dgroup.c` with `-D_VICEROY_MODERN` into a static library `viceroy_rules`.
Excluded leaves (documented in the CMake header):
- DOS platform: `boot/entry.c`, `runtime/cstart.c`, `overlay/rtlink.c`.
- SDL swap-points (milestone 3): `audio/*`, `asset/*`, `render/*`.
- `load_image/*` — the 16 first-pass raw decompiler skeletons (named by EXE
  address range). They still carry un-materialised `goto label_XXXXXX` targets
  and bare x86 register pseudo-vars (`ax`); the organised modules progressively
  replace them. Re-enter the build per-function as they're hand-ported.

**`colony_t` layout fixed (DONE).** The struct compiled to 0x1C4 (452) bytes with
fields at the wrong offsets: `stockpile_9a[20]` (40 B) overran the documented
scalars `liberty_aa@0xAA` / `progress_b6@0xB6` / SoL longs `@0xC2..0xC8`, a missing
pad byte at `+0x1B` shifted `flags_at_1c`/`population`/everything after, and a
vestigial `pad_ca_tail[0xE2]` bloated the tail. Now `#pragma pack(1)` + a **union**
so the commodity-stockpile word array and the byte-aliased scalars both resolve to
their exact DGROUP offsets — faithfully modelling the original flat record's
double-duty bytes. `sizeof == 0xCA` (202, the hard-evidence persistent-record
stride); `_Static_assert` replaces the invalid `#if sizeof(...)` check.

**Compile-fix wave (DONE / in progress).** Building surfaced the cross-file
decl/arity and stale-name drift predicted below. Fixed so far: stale field renames
(`field_at_95`→`counter_at_95`; UnitRecord `field_at_14`/`pad_15`/`field_at_16`→
`cargo_qty[4]`/`cargo_qty[5]`/`turn_counter`; `pad_96_99[1]`→`pad_97_99[0]`), a
missing `block_45e` goto label, nested/corrupted comment terminators
(`/* TODO */` and `@FOOD*/` closing block comments early; `<` typo'd for `/*`),
`<stddef.h>`/`<stdbool.h>` includes, a local `int errno` (DOS E* values differ
from glibc's), `typedef struct PowerRecord PowerRecord`, plus a batch of
undeclared DGROUP globals / screen+message constants and conflicting local
re-declarations across `overlay/`, `native/`, `market/`, `ui/`, `king/`,
`random_events/`. ~81 of ~107 in-scope files compiled clean on the first full
pass; the remaining ~26 are being reconciled.

### D. Linkable binary + front end (milestone 3) — TODO

- **Cross-file duplicate definitions** (found 2026-06-09; harmless for the static
  lib, but a multiple-definition error once an executable links). Use the GLOBAL
  filter — only external-linkage symbols collide:
  `nm libviceroy_rules.a | awk '/ [TDB] /{print $3}' | sort | uniq -d`.
  Initial sweep with the loose `[TtDdBb]` filter over-counted: `power_gold` and
  `war_flag_cell` are `static`/`static inline` (LOCAL, lowercase `t` — each TU
  keeps its own copy, NO link conflict), so they are NOT blockers.
  - *FIXED:* `func_06F7FE/06F821/06F83F` — page-tail trampoline thunks physically
    in the 06D938 segment; overlay_06C220 only called them but re-defined identical
    copies (boundary overreach). Its copies are now `extern` declarations.
  - *FIXED:* `colony_screen_render` — diagnosis showed these were TWO DIFFERENT
    functions sharing a name, not two ports of one: overlay's was `func_0270D0`
    (the colonist-row + warehouse + SoL sub-render), ui's is `func_028592` (the
    top-level paint composer that CALLS func_0270D0 @asm 0x0285C4). No call sites
    used the name, so the overlay copy was renamed to `colony_screen_paint_body`.
  - *FIXED:* `native_settlement_remove` — both were `func_046EC0`. Diffing showed
    native/settlement.c's "32-line" version is in fact the COMPLETE modular port
    (it covers the whole @asm range 0x46EED..0x46F8A across all 3 steps —
    unit-link fixup / table compact / count-decrement / eliminate-or-scale — just
    delegating to helpers, hence short), while overlay_046D70's 131-line copy is
    the same logic inlined. Kept native's as canonical; renamed the overlay copy
    `native_settlement_remove_046EC0_inline` (preserved as a byte-verified
    reference). 

  **Result: ZERO global duplicate definitions** (`nm libviceroy_rules.a |
  awk '/ [TDB] /{print $3}' | sort | uniq -d` is empty) — the library is now
  duplicate-clean for the eventual executable link.

- **DGROUP global decl consolidation + type reconciliation — DONE 2026-06-09.**
  The count globals at `0x539A/0x539C/0x539E` were declared file-locally in ~12
  files (int16/uint16 drift, *undefined* at link, dual-named vs `g_progress_*`,
  and `0x539A` had THREE names), AND separately defined as standalone vars in
  `data/production.c` — a different byte from the `DGS16(0x539C)` reads elsewhere.
  Unified as `g_dgroup`-resident macro aliases in `globals.h` (`#define
  g_unit_count_539C DGS16(0x539C)`, etc.) so the named form, the `DGS16()` form
  and `DS:0x539C` are one byte. Same treatment for the five agent-flagged undefined
  globals: `g_market` (0x84FC active `PowerRecord*`) now follows the `ctx` pattern
  (declared in `power.h`, defined in `dgroup.c`); `g_unit_type_flags_5236/5237`,
  `g_power_table_8808`, `native_class_weight_5AD8` are `g_dgroup` byte-pointer
  macros; the four `SCREEN_*` ids live in `include/ui_screen.h`. All resolve in
  the archive now (no undefined-global blockers); library still builds clean.
  Still standalone vars (lower priority, same latent var-vs-`DGS16` divergence):
  the other `g_progress_53xx`, `g_difficulty_53A6`.

- `dgroup_init()` must populate the **initialized static window** (DS 0x0000..0x2CC5)
  from the game data files — **never** from VICEROY.EXE bytes (copyright). The few
  embedded tables are documented byte-for-byte in `tools/audit.py` /
  `DGROUP_MEMORY_MAP.md` (analysis metadata, not game bytes).
- SDL front end: graphics (replace the VGA/blit/font leaves — located by file
  offset during load_image porting), input (keyboard/mouse `int 16h/33h`), sound,
  file I/O (the MSC C-runtime layer `strcpy@0xFDB4`/`fread`/... → native libc),
  and the RTLink overlay loader → a flat linked binary.
- **DOS-primitive host layer.** The 12 `int21h_AH_*` syscall wrappers (declared in
  `dos.h`, called by `iolib/file.c` and the ported `load_image` stdio) are all
  UNDEFINED — they must be implemented as native I/O (open/close/read/write/seek/
  find/alloc) for the executable to link. NB reconcile the seek interface: `dos.h`
  has `int21h_AX_4200/4201/4202` (split by whence) while the 010B26 `__lseek` port
  uses a unified `int21h_AH_42(handle,offset,whence)` — pick one when implementing.
- `load_image/*` decompilation backlog (16 files → **12 done, 4 in progress**
  2026-06-09; the 12 ported faithfully from disassembly with near-zero stubs —
  string libs, stdio, the main game loop, unit AI/combat, tile-influence paint,
  unit spawn/chain ops, colony order logic, the tooltip/bar drawing layer, and
  buffered file I/O; render/RTLink-loader/printf-core functions honest-stubbed as
  SDL/host plug-in points):
  materialise the `goto label_XXXXXX` targets and replace `ax`/register
  pseudo-vars with real locals. **Not scriptable** — the jump TARGET offsets are
  not annotated instruction offsets (target `0x002890` falls between `@0x00289F`/
  `@0x0028AB`), so each function is reconstructed by hand from its disassembly.

  **Validated porting process** (used for `load_image_0102EA_010AA5.c` = the
  far-string lib, and in progress for `00FAAA` = the near-string lib):
  1. `gcc -c <file>` to list the broken functions (bare `ax` / undefined labels).
  2. For each, read its `@asm` banner offset and the disassembly at
     `re_work/disasm/func_XXXXXX.asm` (gitignored — **read-only**, never commit;
     copyright). Decode and write faithful C; keep the `@asm` provenance.
  3. Re-signature to the real form (the auto banners show only the bp-offset half;
     `les/lds` ⇒ far, `mov reg,[bp+n]` ⇒ near). Rename to the canonical name when
     the address matches an `iolib.h` decl (provides the promised definition).
  4. Verify standalone compile + no duplicate definitions; re-include the file via
     the `VICEROY_LOADIMAGE_PORTED` allow-list in `CMakeLists.txt`.

  **Three categories** (drives priority; many files mix them):
  - *C-runtime / string-lib* (high addrs ~0xFAAA–0x12000): tractable & verifiable
    — being ported now (far + near string libs).
  - *Platform / video* (`00E454` VGA/CGA DAC + BIOS int 10h, drawing primitives):
    these are SDL milestone-3 swap-points like `render/`,`audio/` — porting the
    port-I/O/BIOS faithfully compiles but can't run modern; defer, don't faithfully
    port.
  - *Game logic* (low addrs ~0x2000–0xC000, the overlays' callees): the long tail
    — careful per-function RE, no bulk stubbing (a wrong `return 0` is a silent
    bug, worse than an honest excluded skeleton).

## Order of attack
~~A (ctx)~~ ✓ → ~~B (remaining pokes)~~ ✓ → ~~C (build wiring) — `libviceroy_rules.a`
builds green~~ ✓ → **D (load_image backlog + dgroup_init population + SDL front end)**.

---
*Refactor tooling: `tools/poke_to_dgroup.py` (poke→accessor), `include/dgroup.h`
(the model), `docs/dgroup_map.json` (address index). Re-run the converter's
dry-run to list the remaining manual sites.*
