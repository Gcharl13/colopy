# C Reconstruction Completion Plan (autonomous engine)

**The C source under `reverse_engineered/viceroy_source/` is THE product.**
Python (`colonize_sdl/`) and Godot (`colonization_godot/`) are deprioritized
test harnesses — do NOT work on them under this plan.

## END GOAL (why accuracy AND structure both matter — user directive 2026-05-30)
The C reconstruction must be (a) **byte-accurate** to VICEROY.EXE, AND (b) usable to
**rebuild the game in some other (undecided) format/engine later**. So the C is the
PORTABLE SPEC of the game, not just a disassembly transcript. Structure every port so a
future re-target can lift the logic cleanly:
- **Clean platform/logic boundary.** Game rules + UI layout = portable C. Platform leaves
  (blit/font/VGA/IO/RTLink/sound/input) stay behind well-named `extern`s so a new target
  swaps only that layer. (This is exactly why the scope split exists.)
- **Express the DESIGN, not the asm.** Use named structs/fields + role-named helpers +
  plain arithmetic; a reader must understand WHAT the rule does, not just mimic opcodes.
  Prefer role names for platform externs (e.g. `draw_sprite`, `dialog_show`) over raw
  `overlay_call_181F_xxxx` where the role is byte-known.
- **Capture data + layout as DATA.** Formulas, tables (unit/building/cargo/terrain), state
  struct layouts, and UI positions/geometry ("what is drawn where") should be expressed as
  named constants/tables a re-target can consume directly.
- **cite-or-TBD stays absolute** — accuracy is the foundation; an honest `[TBD]` is fine,
  a guess poisons the re-build.

GOAL: drive every **game-mechanics** function/struct/table toward **byte-grounded**
coverage — convert `UNKNOWN` / `SKELETON` / `[TBD]` / `RECONSTRUCTED` into
`BYTE_VERIFIED` (or an honest, cited `TBD`). Eliminate fabrication.

## SCOPE — GAME MECHANICS + UI/RENDER LAYOUT (user directives 2026-05-30)
IN SCOPE — port these:
1. **Game behavior**: combat, colony production/SoL/Tory, economy/market/trade/haggle,
   AI decisions, diplomacy, natives, king/REF/tax, founding fathers, scoring, unit
   movement/orders RULES, turn processing, and the data tables.
2. **UI / RENDER LAYOUT & COMPOSITION** — "WHAT IS DRAWN WHERE" (user 2026-05-30):
   the screen composition routines, panel/element POSITIONS + geometry, which sprite/
   text goes at which coordinates, the tile render chain (terrain/unit placement), the
   per-screen draw orchestrators, dialog/menu LAYOUT (option positions, hit-regions).
   These DEFINE the on-screen layout and ARE needed. (Already kept: render chain,
   UI screens, colony-screen panels, report renderers, tile_info_panel, GUI dialog/
   menu layout.)

OUT OF SCOPE — do NOT port; one-line stub + move on (these are the same on any
platform / are pure plumbing, NOT layout and NOT game rules):
- **Low-level draw PRIMITIVES** (not layout): the pixel-blit / RLE sprite-decode inner
  loop, font GLYPH rasterizer, VGA mode-13h register setup, palette load. (Keep the
  composition routine that CALLS them — that's the "what/where"; skip only the
  pixel-pushing leaf.)
- C runtime / MSC library: file I/O (fopen/fread/fwrite/fseek), malloc/heap, str*/mem*,
  printf-family, atexit/cstart. (EXCEPTION: RNG rand 0x103D4 / random_int 0xC322 IS in
  scope — game rolls depend on it. Done.)
- RTLink overlay loader / thunk machinery / DOS EXEC / INT 21h wrappers.
- Sound, raw keyboard/timer/input plumbing.
For an out-of-scope function: leave a one-line
`/* OUT-OF-SCOPE: DOS platform (<category>) — per 2026-05-30 directive */` stub — no
body, no fabrication. The ~550 resident func_00xxxx/func_01xxxx (C-runtime/load-image)
are mostly out of scope EXCEPT any that compute screen layout/positions. When an
in-scope function CALLS a platform leaf, keep the call site (extern); don't port the leaf.
RULE OF THUMB: if it decides POSITION/LAYOUT/what-element-goes-where → IN. If it just
moves bytes/pixels/files with no layout decision → OUT.

## Ground truth (in priority order)
1. `code/VICEROY/disasm_overlay_reseg/page_*.asm` — full re-segmented instruction disasm.
2. `COLONIZE/VICEROY.EXE` raw bytes (sha256 in MANIFEST.md).
3. `extracted/text/NAMES_sections.json` — data tables (@UNIT, @CARGO, …).
4. `code/VICEROY/` string tables + callgraph + `anchor_map.md`.

## Guardrails (NEVER violate — these are why this runs without user input)
1. **Scope**: only `viceroy_source/` + its docs/ledgers + `docs/RULINGS.md`.
   Never touch `colonize_sdl/`, `colonization_godot/`, `tests/golden/`.
2. **cite-or-TBD**: every offset/value cites the `.asm`; anything undeterminable
   is marked `TBD`/`UNKNOWN` — **never guessed**. No fabrication, ever.
3. One function/cluster per commit (standard message + Co-Authored-By). Never
   amend, never `--no-verify`.
4. No golden updates, no harness edits (those need user input → would stop us).
5. Tag every ported function: `BYTE_VERIFIED` / `ANCHOR_VERIFIED` /
   `RECONSTRUCTED` / `TBD`, and log it in `VERIFICATION_LEDGER.md`.

## Priority queue (work top-down)
- **P0 — finish partially-reconstructed verified subsystems** (functions already
  known to be core gameplay; complete their full bodies from the disasm):
  combat resolver `func_05B2C2`, colony-turn `func_0A3E1`, production,
  market pricing, king tax/REF, founding fathers, native settlement/raze,
  diplomacy, save/load, scoring.
- **P1 — god nodes / high fan-in + colony-struct (0x8542) touchers** (the engine spine).
- **P2 — game-logic skeletons by `@inferred_role`**: combat, colony, market, AI,
  native, king, FF, mapgen, random_events, save, scoring.
- **P3 — system/leaf**: iolib, load_image, overlay dispatch, rng, runtime.
- **P4 — UNKNOWN with no inferred_role** (last).

## Method per target
1. Read its full disasm in `page_*.asm`.
2. Identify purpose: **string xref first** (message keys) → callgraph → `@inferred_role`.
3. Hand-port to pseudo-C, `@asm`-cited per basic block, cite-or-TBD.
4. Write to the correct subsystem `.c` (relocate from `overlay_*.c`/`load_image_*.c`
   stub into a named `src/<subsystem>/` file once identified).
5. Tag status; update `VERIFICATION_LEDGER.md` + `FUNCTION_INVENTORY.md`;
   add a `docs/RULINGS.md` entry on any cross-source conflict.
6. Commit. Loop to the next queue item.

## Throughput model
- I personally port P0/P1 (highest fidelity, core spine).
- Background agents port P2/P3 clusters in parallel, under STRICT cite-or-TBD.
  Each agent's output is **verified by me** (spot-check cited offsets against the
  `.asm`; reject any fabrication) BEFORE it is committed — the review gate.

## When to surface to the user (ONLY these)
- A whole subsystem reaches full byte-verified coverage (milestone), or
- Genuinely blocked: a needed credential/external resource, OR contradictory
  evidence whose wrong resolution risks data loss.
Otherwise: keep working and committing. Do not stop for status or confirmation.

## Status log (append per batch)
- 2026-05-30: plan created. combat `fort_path` resolved → routing flag (not a
  stat scaler); roll @0x5B819 uses raw 0x523b/0x523c. Starting P0 combat-resolver
  completion + parallel P2 porting.
