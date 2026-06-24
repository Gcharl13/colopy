# CLAUDE.md — Prime Directive & Hard Rules

This file is the orientation + rules authority for the project. It is cited
across the repo as *"per CLAUDE.md hard rule."* It was missing from the tree;
this version **reconstructs the rules from where they survive** (each rule
carries its surviving citation) so those references resolve again. It introduces
**no new unverified claims** — if a rule here is ever found to disagree with the
disassembly or NAMES.TXT, the higher source wins (see
`notes/TRUTH_HIERARCHY.md`).

## Prime directive

Every reconstructed value must trace to a **byte-verified** artifact — a file
offset in a DOS `.EXE`, a `NAMES.TXT`/`GAME.TXT` field, or a recorded ruling in
`notes/rulings/RULINGS.md`. **Never guess.** Un-cited values are marked `TBD`,
not invented. Conflicts are resolved by `notes/TRUTH_HIERARCHY.md` and the
ruling is written down — do not re-litigate settled disputes in conversation.

Orientation for a new session: this file → `METHODOLOGY.md` (the three-layer
model: evidence → **spec** → implementation) → `spec/README.md` (the
specification = source of truth) → `notes/TRUTH_HIERARCHY.md` → `STATUS.md`
(current state) and `AUDIT.md` (what is correct vs misleading). Evidence-layer
detail: `viceroy_source/` (now reclassified — see `viceroy_source/ROLE.md`).

## Trust order (summary; full table in `notes/TRUTH_HIERARCHY.md`)

Running DOS game > extracted sprite pixels > `VICEROY.EXE` disasm at a cited
offset > preprocessed disasm/index > team docs > **C reconstruction (low
trust — has been wrong about terrain ordering, sprite roles)** > AI speculation
(lowest). The original game manual (`docs/GAME_MANUAL.md`) is HIGH trust for a
feature's *function*, but EXE bytes win for exact *numbers*.

## Hard rules

1. **Terrain ordering authority = `NAMES.TXT` `$TERRAIN`**, never `mapedit.c`.
   The C reconstruction has been wrong about tile ordering before; do not cite
   it as primary evidence for terrain ids.
   *(survives in `formats/MP_FORMAT.md`, `viceroy_source/docs/MAP_SYSTEM.md`)*

2. **Sea-lane column** — the right-edge map column is the sea-lane; base terrain
   id = **26 (Sea Lane)**. Never fake it as desert. (Note: **Ocean is 25**, Sea
   Lane is 26 — per the byte-verified `@OTHER` ordering 24=Arctic/25=Ocean/26=Sea
   Lane and the 2026-06-20 ruling; the prior "(Ocean)" gloss on 26 was a label
   error, corrected 2026-06-23. The *number* 26 was always right.)
   *(survives in `formats/MP_FORMAT.md`)*

3. **Auto-forest range** — terrain ids **8..23** are the forested variants of
   the base terrains, byte-verified at file **`0x6204`**
   (`func_006204` / `get_terrain_id_from_raw`): read byte, mask `& 0x1F`, then
   apply the auto-forest conversion.
   *(survives in `viceroy_source/docs/MAP_SYSTEM.md`, `docs/COLONY_RENDER_CHAIN.md`,
   `docs/GAME_INDEX_TABLES.md`)*

4. **Rivers vs coast** — `PHYS0.SS` rows **`0x01` and `0x11`** are **rivers**,
   NOT coast. True coasts use sprites **150–153** plus the water-tile beach-halo
   mechanism.
   *(survives in `viceroy_source/docs/RENDER_CHAIN.md`, `formats/MP_FORMAT.md`)*

5. **Sprite-sheet roles** — **`TERRAIN.SS` is the base-ground sheet** (loaded at
   boot + on map-enter; the source of `emit_ground_sprite`/`G_SHEET_TERRAIN`),
   composited UNDER the **`PHYS0.SS` overlays** (forest/mountain/hill/river/road/
   coast/resource). **`BDARK.SS` is the only orphan** (no load path) — never load
   it. Skip placeholder sprite indices **0, 16, 100**.
   *(Amended 2026-06-22 with user sign-off — the prior "TERRAIN.SS is an orphan"
   was overturned by byte evidence: `BOOT_ASSETS[]` loads TERRAIN.SS, and
   `emit_ground_sprite` draws from `G_SHEET_TERRAIN`. See
   `notes/rulings/RULINGS.md` 2026-06-22. Survives in `spec/systems/map_system.md`
   §3; the old "orphan" wording in `docs/ASSET_ROLES.md` is stale re TERRAIN.SS.)*

6. **Renderer sprite indices** — ships 5–7 / 14–15 / 127; foot units
   100–105 + 109.
   *(survives in `notes/SPRITE_CATALOG.md`)*

7. **Tile drawing chain** — each map tile is drawn by
   `func_O514 → func_O513 → func_O512`. `func_O530` (file `0x69D8C`) is the
   **map-editor** terrain-palette dialog, confirmed not in-game.
   *(survives in `viceroy_source/docs/MAP_SYSTEM.md`, `docs/COLONY_RENDER_CHAIN.md`)*

8. **Colony data base** — the current-colony struct is at `*(0x8542)`;
   ColonyRecord strides per `notes/rulings/` anchor map.
   *(survives in `docs/ADVISOR_REPORTS_AUDIT.md`)*

## Path convention (avoids dangling references)

- `extracted/` (sprites, palettes, assets under `extracted/assets/…`) is a
  **regenerable, git-ignored** working tree produced by
  `tools/extract_visuals.py`. It is **not committed**. Docs that cite
  `extracted/...` refer to this regenerable output.
- **Committed, decoded data** lives in **`data_extracted/`** (NAMES/GAME
  sections, palette, map, strings, disasm snapshot).
- Verbatim DOS binaries are not committed as `.EXE`; `bin/*.b64` +
  `bin/reconstitute.py` rebuild them into git-ignored `raw/COLONIZE/`.
  (Note: `col.zip` is an additional convenience bundle of the original files;
  see `AUDIT.md` for its status.)

## Agents & workflow

Conflicts between sources are arbitrated against `notes/TRUTH_HIERARCHY.md` and
recorded in `notes/rulings/RULINGS.md` — **not** in the conversation thread, so
rulings survive compaction. Add *rules* to this file (with user sign-off); add
*decisions* to `RULINGS.md`.

## UI DOCUMENTATION MANDATE (2026-06-24, user directive)

**Goal: 100% byte-verified documentation of the ENTIRE UI — enough to rebuild it.**
Every screen, every drawn element's EXACT position, every font, every string, every
color — traced to a VICEROY.EXE offset. This is a standing directive until the UI is
fully documented.

**Hard rules for this work:**
1. **Never fabricate a single line.** Every placement/coordinate/frame/string/color must
   cite a `func_XXXXXX @0xNNNNN` (or a NAMES/GAME.TXT key, or a recorded ruling). If you
   cannot byte-verify it, write **TBD** — do NOT invent it, do NOT approximate it, do NOT
   pull it from the low-trust recon (`*_DECODED.md`/`SPRITE_CATALOG`) and present it as
   verified. Recon is a cross-check only; the EXE wins.
2. **Runtime values are TBD, not "complete."** If an element's position/frame is computed
   at runtime (RNG, BSS table, live state), say so explicitly and name the exact site +
   what a trace/port would need. **Never label a screen "COMPLETE" while a load-bearing
   render input is unresolved.** (Burned 2026-06-24: the colony screen was falsely marked
   COMPLETE while building placement `func_025D34` — RNG-driven — was unresolved.)
3. **When you solve one item, move to the next. Do not stop.** If stuck on an item, mark
   it TBD with the blocker and move on — do not halt the whole sweep on one leaf.
4. **Coverage tracker:** `docs/UI_AUDIT_TRACKER.md` lists every UI screen/subsystem and its
   status (DONE/PARTIAL/TBD). Keep it honest and current. A screen is DONE only when every
   element is byte-cited or explicitly TBD with the blocker named.
5. **Commit incrementally** (per screen / per cluster) so progress survives.
