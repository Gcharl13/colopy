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

## Remaining

### A. The `ctx` current-colony pointer (delicate — do carefully)
`ctx` (DGROUP:0x8542) is the *mutable* pointer to the colony being viewed/simulated
(102 functions deref it). Constraints discovered:
- `0x8542` is touched **only** by 4 pointer-to-pointer pokes (`*(uint8_t near *
  near *)0x8542`), never as a scalar — so there is one clean access path.
- Several sites declare a **local** `unsigned char near *ctx` that *shadows* the
  global, then poke `[0x8542]` to set the global current-colony. So the name
  collides; a macro alias is impossible.

Recommended model: keep a single global `struct colony_t *ctx` (DOS: located at
DS:0x8542; modern: a plain pointer global). Convert the 4 pointer-pokes to set/get
`ctx` directly, renaming the shadowing locals (e.g. `ctx_new`):
```
*(uint8_t near * near *)0x8542 = ctx_local;   ->   ctx = (struct colony_t*)ctx_local;
ctx_local = *(uint8_t near * near *)0x8542;    ->   ctx_local = (unsigned char*)ctx;
```
Since nothing else pokes `0x8542`, `ctx` becomes the single source of truth. (The
colony record itself still lives in `g_dgroup` via `DG_COLONY_TABLE`/the ColonyRecord
the offset points at; only the *cursor* is the pointer.)

### B. ~92 remaining raw pokes (manual, `tools/poke_to_dgroup.py` reports them)
The converter conservatively skipped these:
- **pointer-valued operands** `*(T near*)var` / `*(T near*)arg` where `var` holds a
  DS offset — convert to `DGn(var)` once confirmed the operand is an offset (not a
  host pointer). Most are safe; verify per-site.
- **`(cast)(expr)` operands** — rewrite the inner expression then `DGn(...)`.
- the 4 `ctx` pointer-pokes (see A).

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
A (ctx) → B (remaining pokes) → C (build wiring), each compile-verified. After A+B
the rules layer should build clean under `-D_VICEROY_MODERN`; C makes it runnable.

---
*Refactor tooling: `tools/poke_to_dgroup.py` (poke→accessor), `include/dgroup.h`
(the model), `docs/dgroup_map.json` (address index). Re-run the converter's
dry-run to list the remaining manual sites.*
