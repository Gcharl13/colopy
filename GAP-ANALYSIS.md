# GAP-ANALYSIS — current codebase vs `engine-dev-environment-spec.md` (Drydock)

**Phase 0 deliverable. No code has been changed.** Per the mission brief this document maps the
existing engine/editor to the spec's architecture, proposes a migration order for P0–P2, and
lists every conflict that needs a ruling before implementation starts. **Work stops here until
the migration order and the open questions in §7 are approved.**

---

## 1. Inventory — what exists today

### 1.1 The codebase

| Aspect | Current state |
|---|---|
| Language | **C++17** (CMake `project(viceroy_cpp CXX)`), not C11. ~19.2 kLOC engine+sim, ~12.3 kLOC forge editor backend/UI. |
| Build | CMake ≥3.16, three targets: `viceroy_sim` (static lib, pure logic), `viceroy_cpp` (offline asset importer/renderer, needs libpng, optional), `forge` (editor+game server). `FORGE_GUI` option (OFF): a Dear ImGui/GLFW desktop scaffold exists at `forge/gui/` but is unverified, needs network at configure time (FetchContent), and duplicates the web UI. |
| GUI | **A browser IDE**: `forge serve <port>` runs a hand-rolled HTTP server (`httpd.cpp`) serving one embedded HTML/JS page (`web_ui.cpp`, 4,233 lines) with 13 docked tabs. Deeply integrated: every editor feature and the playable game itself run through it. |
| Tests | 10 CTest targets (sim golden masters, forge map/rules/mod/save/data/engine/bundle selftests, two Python validators) + `tools/verify_rules.py` — a **byte-parity oracle** proving the compiled defaults equal `@UNIT`/`@CARGO`/`@JOB` reference data. Per-increment gate also runs Playwright visual probes. |
| Dependencies | libpng (optional), Python 3 for tools, Node/Playwright for UI probes. No SQLite, no ImGui in the default build. |
| Data pipeline | `bin/reconstitute.py` rebuilds original-game binaries from b64; `tools/*.py` extract JSON + PNG assets into `data_extracted/`. **`data_extracted/` is generated extraction output with byte-provenance — it is evidence, not authoring source.** |

### 1.2 Where game entities/rules are defined

Three layers, already partially unified by an earlier in-repo effort (the A1–A4 "store" work),
which is philosophically close to Drydock but structurally different:

1. **Reference data** — `data_extracted/tables/names_tables.json` + `tribe_tables.json`
   (42 `@SECTION` tables, verbatim from the original NAMES.TXT/TRIBES files) and
   `data_extracted/text/*.json` (GAME.TXT 499 message sections, MENU/LABELS/NAMES text).
2. **Compiled defaults** — `sim/rules.hpp` `RuleData` (structs + `default_rules()`), proven
   value-identical to the reference tables by `verify_rules.py`. The sim reads only `RuleData`.
3. **Engine catalog JSON** — `data_extracted/engine/`: `schema.json` (56 tables: 42 reference /
   13 runtime-state / 1 config, ~268 typed columns), `bindings.json`, `turn.json` (data-driven
   turn pipeline), `functions.json` (33 formula descriptors), 36 node graphs (`graphs/`),
   8 screen layouts (`screens/`), `messages.json`, `sprites.json` catalog, `effects.json`
   (force-composition rows), `scenarios/new_world.json`, `cfg.json` (~100 rule scalars).

There is already a **path-grammar store** (`forge/store.cpp` `cell("@UNIT[3].attack")` /
`cell("cfg.food_growth_threshold")` get/set over reference+state+config) — a thin (61-line)
dispatch over the engine's binding layer, not a typed record store: no handles, no ref index,
no undo journal, no per-field provenance, mutation is *not* funneled through one chokepoint.

### 1.3 How the current editor works

13 web tabs over `/api/*` JSON routes: **Rules** (cfg scalar grid + overlay/mod),
**Schema** (browse schema.json + reverse index), **Map** (byte-faithful .MP paint/validate),
**Data** (binding inspector, `cell()` get/set), **Tables** (generic CRUD over every `@SECTION`),
**Formulas** (formula browser with live values), **Assets** (sprite catalog browser),
**Screens** (screen-JSON designer + preview), **Systems** (formula cards + live trace),
**Logic** (node-graph editor over the 36 event graphs + interpreter), **Turn** (turn.json phase
editor), **Sandbox** (isolated colony sim), **Play** (the full playable game: map HUD, colony /
Europe / Congress screens, reports F1–F10, popups). Persistence: edits POST to the server which
writes the JSON files (rules overlay via mod.cpp; tables via rules_json; graphs/screens/turn
saved wholesale). **No undo. No ref index. No used-by. Provenance only at the
whole-overlay level (active mod), not per field.**

### 1.4 File formats

JSON everywhere for data; binary `.MP` maps (3-plane, byte-faithful loader); PNG atlases +
`palette.json`; savegames as JSON (schema-driven, gitignored). Nothing is one-record-per-file;
`names_tables.json` alone holds 42 tables, graphs are one file per event graph.

---

## 2. Entity → spec record-type mapping (§3.2 registry)

| Existing definition | Rows | Target type | Notes |
|---|---|---|---|
| `@UNIT` + `RuleData` unit stats | 24 | **UNIT** | Parity oracle exists (`verify_rules.py`) — ideal early migration |
| `@CARGO` + market params | 16 | **GOOD** | Parity oracle exists |
| `@UNFORESTED`/`@FORESTED`/`@OTHER` yield tables + terrain ids 0–28 | 29 | **TERR** | Three row-bands fold into one type; forest/river/hills L1 bits → **FEAT** records referenced by tiles |
| `@BUILDING` | 42 | **BLDG** | |
| `@JOB` | 28 | **PROF** | Parity oracle exists |
| `@FOUNDING` + `@FATHERS` + FF logic constants | 25 | **FFAT** | |
| `@COUNTRY`/`@NATIONALITY`/`@HOMEPORT`/`@LEADERNAME` + `@TRIBES` (+8 per-tribe settlement tables) | 12 | **NATN** | Tribe authored-settlement coordinate lists → SCEN payload data, not NATN fields |
| `turn.json` phases | 15 | **PHAS** | Near-1:1; already ordered data |
| `cfg.json` rule scalars | ~100 | **new type CONF** | §3.2 has no config-scalar type; "when in doubt, it's a record" → propose CONF (id, value, range, doc) |
| `effects.json` force compositions | ~10 | **new type FORC** (or EFCT operand lists) | decide during EVNT work |
| GAME.TXT sections (`GAME_sections.json`, 499) | 499 | **MSGE** + **TEXT** | box/sprite/speaker metadata → MSGE; strings → TEXT |
| NAMES/MENU/LABELS text sections | ~31 tables | **TEXT** | grouped ~50/file per §4.2 |
| 36 node graphs (`graphs/*.json`) | 36 | **EVNT/RQMT/RQST/EFCT** | **Largest semantic migration** — graphs are imperative node programs; spec §8 wants relational atoms. Deferred past P2 (see §7 Q5) |
| `screens/*.json` layouts | 8 | **DLOG** | |
| `sprites.json` catalog + tileset PNGs | ~437 entries | **ATLS/SPRT** | atlas PNGs become payload records (§4.4) |
| `palette.json` (VICEROY.PAL) | 1 | **PLTT** | remap ranges not yet modeled |
| `.MP` maps + `scenarios/new_world.json` | 2 | **SCEN** | binary payload + JSON seed data |
| `schema.json` | 56 tables | **SCHM** | the migration rewrites this as SCHM records |
| `functions.json` / `FORMULAS.txt` | 33 | *(no counterpart)* | keep as generated documentation; revisit at P4 effect-trace time |
| 13 runtime-**state** tables (game, powers, colonies, units, …) | — | **out of store** | Spec's store is the *catalog*; runtime state lives sim-side (§10.1 `sim/` consumes `core/`). The state tables stay on the existing binding/savegame path |

## 3. Editor panel → spec view mapping

| Current tab | Becomes | When |
|---|---|---|
| Tables | **Grid view** (generic, reflection-driven) | P1 — first strangler replacement |
| Rules | Grid view over CONF records + layer selector | P1–P2 |
| Schema | **Object Window** (SCHM browsable like any type) | P1 |
| Data (binding inspector) | Form view + text view | P2 |
| Turn | Grid/form over PHAS | P2 |
| Formulas / Systems | keep as-is (docs surface); fold into effect trace at P4 | — |
| Logic (node graphs) | §8.5 outline editor + chain graph — **after** EVNT decomposition | post-P2 |
| Screens | DLOG form view + preview | post-P2 |
| Assets | P6 sprite workbench | out of scope |
| Map | P6 map workbench (already byte-faithful) | out of scope |
| Sandbox / Play | the game itself; P4 live mode | out of scope |

Nothing is proposed for outright retirement in P0–P2: each legacy tab retires only when its
generic replacement covers the workflow (strangler rule), logged in MIGRATION-LOG.md.

## 4. No spec counterpart — keep / migrate / retire

| Item | Disposition |
|---|---|
| `bin/reconstitute.py` + extraction `tools/*` + `data_extracted/**` | **Keep** — provenance layer; `data/base/*.rec` is *generated from it once*, then becomes authoring truth |
| `spec/` (byte-verified game spec) + gate G (ctest/selftests/validators/Playwright) | **Keep** — unchanged; Drydock work must pass the same gate |
| `verify_rules.py` parity oracle | **Keep & extend** — becomes the P0 migration-correctness gate (store-loaded values == RuleData == original tables) |
| Node-graph interpreter (`engine.cpp`) | **Keep until** EVNT atoms replace graphs (post-P2) |
| `forge/store.cpp` `cell()` grammar + bindings | **Migrate** — catalog reads route to the new record store via a bridge; state/cfg paths keep working; retire the reference-table half when all catalog types are migrated |
| Web `httpd` + `/api` routes | **Keep** — the strangler host (see Q2) |
| `forge/gui` ImGui scaffold | **Decision needed** (Q2) — either becomes the Drydock shell or is retired |
| savegame.cpp (state persistence) | **Keep** — out of Drydock scope (state ≠ catalog) |
| `mod.cpp` rules overlay | **Retire at P5** (spec overlays subsume it); untouched in P0–P2 |

## 5. Risks & strangler seams

| Risk | Seam / mitigation |
|---|---|
| Migrated values drift from byte-verified originals | **Seam: `RuleData`.** The sim keeps reading `RuleData`; P0 adds a loader that populates `RuleData` from the record store/pack. `verify_rules.py` (extended to run against store-loaded data) is the hard gate — identical numbers or no merge. |
| The game must run at every commit | The JSON files stay in place and loaded until each type's `.rec` migration passes parity; a build flag flips each type's source. Deleting JSON happens only after its type is fully cut over. |
| Editor regression (13 live tabs) | New views mount as additional tabs beside the old ones; old tab retires per-type only after the replacement covers its workflow. `/api` routes stay stable throughout. |
| Determinism gate vs floating point | Catalog data is integer-dominant; canonical float rule (§4.2) applied from day one; round-trip CI test lands in the same commit as the parser. |
| Positional indices are load-bearing (EXE parity: power index = nation, terrain id order, @RESOURCE row order…) | String IDs per spec **plus an explicit `index` field** on migrated types where the original ordinal is semantic; codegen emits ordinal lookup tables so sim indexing is unchanged. |
| `web_ui.cpp` is 4,233 lines (spec's no-long-files rule) | New editor code lands in small `ed/*` units per §10.1; the monolith shrinks as tabs retire — no big-bang rewrite. |
| Node-graph → EVNT atoms is a semantic rewrite | Explicitly deferred past P2 (Q5); graphs keep running on the interpreter meanwhile. |

## 6. Proposed migration order

**P0 (schema + codegen + text + validator CLI):**
1. **GOOD** (16), 2. **UNIT** (24), 3. **PROF** (28) — small, matrix-shaped, and all three are
   covered by the existing byte-parity oracle, so correctness is provable, not eyeballed.
   Deliverables: SCHM format, codegen (structs + reflection tables + load/serialize/validate),
   canonical text parser/serializer, `drydockc data/ -o game.pack`, round-trip CI gate,
   `RuleData`-bridge loader, `data/base/{good,unit,prof}/*.rec`.

**P1 (store + Object Window + grid):**
4. **TERR** (+FEAT), 5. **BLDG**, 6. **CONF** (cfg scalars), 7. **PHAS** (turn.json), 8. **SCHM**
   itself. Store internals per §10.3 (arrays, ID hash, u32 handles, ref index, `store_set`
   chokepoint + undo journal). Object Window + grid view strangle the Tables tab first.

**P2 (form + pickers + used-by + undo UI):**
9. **NATN**, 10. **FFAT**, 11. **TEXT**/**MSGE** bulk (grouped files), 12. **SPRT/ATLS/PLTT**
   metadata (payload sidecars). Form view, ref hyperlinks/pickers, used-by panel, safe delete,
   undo/redo wired to the journal. Engine cutover: `RuleData` built from the pack for all
   migrated types; JSON sources for those types deleted; Tables/Rules/Data tabs retired for
   migrated types.

Rationale: parity-oracle types first (provable), matrix-shaped types second (grid view shows
value fastest), ref-heavy and bulk types last (need pickers + grouped-file support). EVNT/DLOG/
SCEN deliberately excluded (Q5).

## 7. Open questions — **rulings needed before implementation**

1. **Language.** Spec mandates C11; the codebase is C++17 and the sim's golden masters live in
   C++. A full C rewrite would break every byte-verified test. Options:
   **(a)** new Drydock modules (`core/ schema/ text/ pack/`) written in portable C11, compiled
   into the existing C++ build (headers C-compatible); **(b)** spec architecture implemented in
   the repo's existing C++17 style. I recommend **(a)** — honors the spec where it's cheap,
   preserves the sim. Confirm.
2. **GUI.** Spec wants Dear ImGui (cimgui, docking). The deeply-integrated editor is a browser
   IDE; a dormant ImGui scaffold exists but needs network at configure time and duplicates
   everything. Options: **(a)** build P1–P2 views (Object Window/grid/form) as new panels inside
   the existing web shell — zero new deps, strangler-friendly, game keeps running; **(b)** stand
   up the ImGui shell now and grow the new views there while the web UI keeps the legacy tabs.
   I recommend **(a) for P1–P2**, revisiting ImGui at P4 (live mode is where one-process ImGui
   pays off). This deviates from §10.2 — explicit approval requested.
3. **Runtime state out of store scope** (13 state tables stay sim-side, savegame path unchanged)
   — confirm.
4. **New record types** CONF (rule scalars) and FORC (force compositions) — confirm additions to
   the registry.
5. **Node graphs → EVNT/RQMT/RQST/EFCT deferred past P2** (graphs keep running on the existing
   interpreter; no speculative scaffolding) — confirm.
6. **IDs**: string IDs per spec + explicit `index` field where the original ordinal is
   load-bearing — confirm.
7. **`data/base/` generated once from `data_extracted/`**, after which `.rec` files are the
   authoring truth and `data_extracted/` remains frozen provenance — confirm.

---
*Prepared as Drydock Phase 0. Implementation (P1 of the mission = spec P0) starts only after
the migration order and Q1–Q7 receive rulings.*
