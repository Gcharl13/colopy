# MAPEDIT.EXE — Clean Modern-C Rewrite Plan

> **Design document — no clean C has been written yet.** This plan replaces the
> abandoned auto-traced approach (now in `legacy_autogen/`) with a hand-decoded,
> readable, modern-C reconstruction grounded only in verified facts. Approve
> this plan before any `.c` is committed under a clean `src/`.

## Why re-approach

The prior approach ran a tool (`tools/emit_c_chunks.py`) over the disassembly
and emitted control-flow skeletons for all 210 functions. The result *looks*
like ~6,500 lines of source but is ~0% semantic: register operations and their
meaning were discarded, leaving `if (ax != 0) {}` scaffolding. It cannot be
finished by "filling in" — there is nothing to build on. A clean rewrite,
decoding the genuinely MAPEDIT-specific functions by hand into named modern C,
produces a result that is correct, readable, and verifiable.

## Principles (same discipline as `viceroy_source/`)

- **Cite or TBD, never guess** — every function carries `@asm <offset>..<offset>`
  + `@asm_file` and a tier: `BYTE_VERIFIED` / `RECONSTRUCTED` / `TBD`.
- **Modern C** — C99, fixed-width types (`uint8_t`, `int16_t`), named `struct`/
  `enum`, real control flow. No `func_XXXXXX` names once a role is known; no
  raw-register pseudo-bodies.
- **Trust hierarchy** — NAMES.TXT `$TERRAIN` and the disassembly outrank any C.
  Obey `/CLAUDE.md` hard rules (terrain ordering, sea-lane=26, auto-forest 8..23
  at `0x6204`, river vs coast sprites).
- **Reuse, don't re-decode** — shared OBJ helpers identical to VICEROY are pulled
  in via `tools/sigmatch.py`, not re-decoded.

## Target layout (clean `src/`, separate from `legacy_autogen/`)

```
mapedit_source/
  include/   mp.h, terrain.h, editor.h   (clean named types)
  src/       mp_io.c        .MP reader/writer
             terrain.c      terrain enum + auto-forest (func_006204)
             menu.c         menu dispatcher
             palette_ui.c   tile-palette UI (UNFORESTED/FORESTED/OTHER)
  Makefile
```

## Work order

1. **Foundations from verified facts (no new decode needed)**
   - `terrain.h` — 28-entry terrain enum from NAMES.TXT `$TERRAIN`
     (`data_extracted/text/NAMES_sections.json`), the canonical source.
   - `terrain.c` — `terrain_id_from_raw(byte)` mask `& 0x1F` + auto-forest
     range 8..23, ported from `func_006204` (BYTE_VERIFIED at file `0x6204`).
   - `mp.h` — `MpHeader{width,height}` + tile-byte bit layout from
     `formats/MP_FORMAT.md` (bits 0-4 terrain, 5 river, 6 forest, 7 TBD).

2. **`.MP` reader/writer (`mp_io.c`)**
   - Locate the `.MP` read/write functions in MAPEDIT via `*.MP`, `MAPTOLOAD`,
     `MAPTOSAVE` push sites in `code/MAPEDIT/strings.json` →
     `code/MAPEDIT/disasm/`.
   - Hand-decode header + tile-array load/store; cite each `@asm` offset.
   - **Gate:** round-trip `COLONIZE/AMER2.MP` byte-identically via
     `tools/verify.py` (reuse existing harness; PAL/MP round-trip already PASS).

3. **Close the open `.MP` format questions** (promote `MP_FORMAT.md` TODOs)
   - Tile bit 7 (`0x80`) meaning — trace the loader.
   - Post-tile-array layout (Colony/Unit/Native array order + counts) — follow
     the loader past the tile array; cross-check strides in
     `viceroy_source/include/{unit,colony,native}.h`.

4. **Menu dispatcher (`menu.c`)** — decode the dispatcher region; map menu
   entries to actions (New/Load/Save/terrain-paint).

5. **Tile-palette UI (`palette_ui.c`)** — decode via `UNFORESTED`/`FORESTED`/
   `OTHER` push sites; map palette cells → terrain ids.

## Scope boundary

This is a **behavioral** reconstruction of the editor's real jobs (load/edit/
save `.MP`), **not** a 1:1 port of all 210 stub functions. Tiny shared accessors
and CRT helpers are sigmatch'd in, not re-decoded. Functions whose semantics
cannot be established from the bytes stay `TBD` with a citation — never guessed.

## Verification

- `tools/verify.py` — `AMER2.MP` read→write is byte-identical.
- Each clean function's `@asm` extent matches `code/MAPEDIT/functions.json`.
- `tools/sigmatch.py --self-test` still passes for the shared helpers reused.
- No clean `.c` claims a tier it can't cite (manual review against the rule in
  `/CLAUDE.md`).
