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

### C. Build wiring + front end (milestone 3)
- A CMake/Makefile target building the `src/` rules layer + `runtime/dgroup.c`
  with `-D_VICEROY_MODERN` into a library.
- `dgroup_init()` must populate the **initialized static window** (DS 0x0000..0x2CC5)
  from the game data files — **never** from VICEROY.EXE bytes (copyright). The few
  embedded tables are documented byte-for-byte in `tools/audit.py` /
  `DGROUP_MEMORY_MAP.md` (analysis metadata, not game bytes).
- SDL front end: graphics (replace the VGA/blit/font leaves — located by file
  offset during load_image porting), input (keyboard/mouse `int 16h/33h`), sound,
  file I/O (the MSC C-runtime layer `strcpy@0xFDB4`/`fread`/... → native libc),
  and the RTLink overlay loader → a flat linked binary.
- Cross-file decl/arity reconciliation surfaced during decompilation (e.g.
  `func_06CFE8` is now `(mode,panel)` but a sibling still calls it `(void)`); a
  real build pass flushes these out.

## Order of attack
~~A (ctx)~~ ✓ → ~~B (remaining pokes)~~ ✓ → C (build wiring). After A+B the rules
layer should build clean under `-D_VICEROY_MODERN`; C makes it runnable.

---
*Refactor tooling: `tools/poke_to_dgroup.py` (poke→accessor), `include/dgroup.h`
(the model), `docs/dgroup_map.json` (address index). Re-run the converter's
dry-run to list the remaining manual sites.*
