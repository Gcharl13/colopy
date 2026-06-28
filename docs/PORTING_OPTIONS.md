# Plan — Three forward options for the new-colony game: Modding tool, Godot port, ESP32-P4 port

## Context

The `new-colony` (colopy) project is a *build-from-spec* reimplementation of Sid Meier's
*Colonization*. The reverse-engineering is finished: `spec/` is a byte-verified contract (30
systems + 52 UI screens), the data is decoded to JSON (`data_extracted/`), the art is a
paletted-PNG atlas (`docs/atlas/`), and — crucially — there is already a **working C++17
reference implementation** in `viceroy_cpp/` with a **pure, headless, deterministic,
golden-master-tested sim core** (P1–P3 done) plus an offline asset importer and a P0 map
renderer that is pixel-identical to the oracle.

The user wants to explore three forward directions and decide where to invest:
1. **Port to Godot** — using idiomatic Godot Nodes/Scenes (TileMap, Control, Sprite2D), *not* a
   single hand-drawn-framebuffer script.
2. **Port to an ESP32-P4 + display** — run the game on embedded hardware.
3. **A "game engine / design program"** built around the files — a tool for finer design and
   **modding**.

**The intended outcome of this document:** a decision-support comparison of all three, plus a
recommended build sequence. Per the user's direction: the **modding/design tool is the lead
track** (deepest detail, first to build); the **Godot port keeps both logic-binding options
open** (GDExtension reuse vs GDScript/C# rewrite — decide later); the **ESP32-P4 track targets
the full faithful game**, not just a slice.

### The one insight that drives everything

All three options are **the same game wearing three different faces.** The crown jewel — the
sim core at `viceroy_cpp/sim/*` (built as the `viceroy_sim` static lib, `viceroy_cpp/CMakeLists.txt:15`,
guarded by `viceroy_cpp/sim/tests/sim_tests.cpp`) — has **no I/O and an injectable RNG**
(`RandFn = std::function<int(int,int)>`, `sim/immigration.hpp:9`). It does not know or care what
draws it. The same is true of the offline asset pipeline (which already emits a modern
**paletted-PNG atlas + `frames.json` + `manifest.json` + `VICEROY.PAL`** bundle) and of the
data tables in `data_extracted/`.

**Every option reuses this exact trio — sim core + bundle + data tables + golden-master tests —
verbatim. They differ only in their presentation, input, and tooling layer.** You are not
choosing three games; you are choosing where to spend presentation effort, and in what order.

### Two cross-cutting prerequisites that every option silently depends on

The adversarial review surfaced two pieces of shared, net-new work that benefit all three tracks
and should be done in the shared core (so they stay under `sim_tests`), not re-discovered per
client:

- **The `RuleData` seam (also the modding tool's MVP).** The sim currently **duplicates the JSON
  tables as C++ literals** rather than reading them — verified: `sim/unit.cpp` has
  `static const UnitStats kStats[...]` (header comment even says "from data_extracted @UNIT" while
  the values are inlined); `sim/combat.cpp` has terrain-defense as a literal `switch`;
  `sim/economy.cpp`/`market.cpp`/`founding_fathers.cpp`/`ref.cpp` inline their constants;
  `market.cpp`'s `price_drift` never consumes `@CARGO`'s `rise/fall/volatility`. A value-identical
  refactor to read these from `data_extracted/tables/*.json` (defaults = current literals) makes
  the data the single source of truth — which the Godot and ESP32 clients then inherit for free.
- **The unit/turn sim spine.** `World` is currently `{ std::vector<Colony> colonies; }` with units
  explicitly deferred ("`units[] arrive with P2`", `sim/game.hpp`); `step_turn` runs only the
  single-player economic spine. A *playable* client (Godot or ESP32) needs a unit array on `World`,
  movement, end-turn order application, and multi-power orchestration — **net-new, newly
  golden-tested C++**, not just presentation. This is the work both player-client tracks bury.

---

## Comparison at a glance

| | **Forge (modding tool) — LEAD** | **Godot port** | **ESP32-P4 (full game)** |
|---|---|---|---|
| **Role** | Authoring + balance laboratory; the shared content pipeline upstream of both clients | Flagship cross-platform player client, idiomatic nodes | Dedicated embedded/handheld player client |
| **Code reuse of `viceroy_cpp`** | Sim + `bundle.cpp` + `mp/pal/png_io` reused; renderers embed in an ImGui canvas | Sim reusable via GDExtension (or rewritten); `png_io/pal/ff/bundle/mp` reused; presentation rewritten as nodes | **>90%**: sim *and* `surface.cpp` blitter + `ff.cpp` glyphs + `mapview/colony_screen` port near-verbatim; only `to_rgb()` replaced |
| **Net-new work** | `RuleData` seam; **a `.MP` encoder (none exists)**; data-model/editor UI; split test harness | Node/scene UI for 52 screens; palette-cycling shader; binding (if GDExtension); the unit/turn spine | ESP-IDF shell; asset-flatten tool; index→RGB scanout path; touch/input; sound (I²S); save-to-SD |
| **Fidelity ceiling** | N/A (validates that edited bundles still match the spec) | Very high — indices preserved via R8 + palette-LUT shader; 320×200 integer-scaled | High; **RGB565 truncates the 8-bit palette permanently → target RGB666** |
| **Hardest risk** | "Moddable" oversells: params are data-driven, but **formulas/enums (`NUNITTYPES=24`)/atlas are code/art walls** | The unit/turn spine is net-new tested logic; `CYCLE.DAT` shimmer undecoded | Per-frame index→RGB LUT is mandatory CPU work (PPA has no indexed input); PSRAM bandwidth — measure on real HW |
| **Verdict (adversarial)** | Feasible-with-caveats (best-grounded design; 2 code-fact corrections) | Feasible-with-caveats (no fatal flaw; 2 "ready" items overstated) | Feasible-with-caveats (riskiest; risk is plumbing, not viability) |

---

## Track 1 (LEAD) — "Viceroy Forge": the data-driven design & modding tool

A content-authoring environment (not a player client) that edits the game's externalized data,
art, text, and maps, validates edits **live against the headless sim core + golden-master
harness**, and packs the result into the same runtime bundle the player clients consume. This is
the lead track because its MVP (the `RuleData` seam) **de-risks and benefits all three options on
day one**, and because it is the cleanest expression of the shared-foundation thesis.

### 1.1 What is moddable (and the honest ceiling)

**Data-driven balance tuning — yes.** These already live as typed JSON with column metadata
(`columns`/`legend`/`byte_anchors`/`provenance`) that can drive typed widgets + range checks:

- `data_extracted/tables/names_tables.json` → `@UNIT` (stats/cost), `@BUILDING` (cost/size/upkeep),
  `@CARGO` (price params), `@JOB` (professions), `@UNFORESTED/@FORESTED/@OTHER` (terrain
  yields/defense/value), `@RESOURCE`, `@FATHERS` (era weights), `@DIFFICULTY`, `@COLORS`.
- `data_extracted/tables/tribe_tables.json`, `dgroup_tables.json` (record strides + scalars).
- `data_extracted/text/*.full.json` (all UI text + Colonopedia, with `%STRINGn` placeholders and
  markup), `data_extracted/map/*` (`.MP` tiles), the atlas PNGs + `frames.json`,
  `palette.json`/`VICEROY.PAL`/`CYCLE.DAT`.

**Arbitrary game-logic modding — no (be honest about this).** The *structure and formulas* are
code, not data: the SoL 1/64 EMA shape, `ATK/(ATK+DEF)`, the REF purchase loop (`sim/ref.cpp`),
the demotion ladder + capturable set (`sim/combat.cpp`), the FF cost curve. And the enums
(`NUNITTYPES=24`) and the fixed atlas frame set are hard walls — adding a 24th unit breaks both
the enum and the sprites. **Framing: a balance laboratory + content editor, not a code-modding
SDK.** Non-data rules can be *opt-in* new schema (e.g. a `@DEMOTE` table, an FF-curve config
block), each ruling-logged in `notes/rulings/RULINGS.md`.

### 1.2 Architecture — Dear ImGui desktop app, sim linked in-process

Recommended host is a **Dear ImGui native app that links the sim core directly** (in-process), reusing
`viceroy_cpp/sim/*`, `src/bundle.cpp`, `src/mp.cpp`, `src/pal.cpp`, `src/png_io.cpp`, `src/ff.cpp`
as libraries. Rationale: the sim is C++17 with one dep (libpng); linking it in-process makes the
killer feature (live validate) free — an edit mutates a `RuleData` and re-runs
`step_turn`/`resolve_land`/`price_drift` in microseconds, no IPC. The map/colony renderers take a
`Surface&` (in-memory framebuffer) and are engine-agnostic — verified to have **no window/input
loop** — so the Forge supplies its own ImGui window and embeds them *without* needing the unbuilt
P4/P5 interactive client. (Godot-as-host forces the sim across a binding boundary and is poor at
spreadsheet editing; a web app can't link the C++ sim without a WASM build — keep both as
fallbacks only.)

> Caveat (verified): ImGui's `ImGuiTable` gives the *grid widget*, not the *data model*. The typed
> columns, cross-table referential integrity, sparse-override diff/merge, and undo are net-new
> application code and are the **bulk** of the editor work.

### 1.3 The MVP — the single highest-leverage move

**The `RuleData` injection seam + a read-only "balance inspector," before any editor UI.**

1. Introduce a `sim::RuleData` struct (units, terrain, buildings, cargo, fathers, scalar config)
   + a `load_rules(json)` adapter, injected into the sim like `RandFn` is today. Defaults = the
   current literals.
2. Wire the smallest, most isolated table first (`sim/unit.cpp`'s `kStats` ← `@UNIT`), run
   `sim_tests` to confirm green (the refactor is mechanically **value-identical** — verified: the
   JSON `defensive`/attack columns already match the C++ literals exactly), then extend to
   `combat`/`economy`/`market`/`founding_fathers`.
3. **Split the test harness** into (a) a *parameterized baseline* suite over un-modded `RuleData`
   (the existing fixed-vector tests) and (b) a **new** *modded-data invariant* suite (ranges,
   referential integrity, "price stays in band," "SoL converges"). This is required and net-new:
   the existing golden tests hard-assert the literals (`unit_stats(SOLDIERS).attack == 2`), so they
   **cannot** double as a live mod validator — any edit fails them by construction.

Delivering just this proves the entire central thesis with the smallest possible surface (no
ImGui, no map encoder, no bundle writer) and, if it surfaces a non-value-identical constant or an
enum-width wall, reveals the project's true modding ceiling on day one.

### 1.4 Full editor set (post-MVP phases)

- **Map editor** — reuse the original MAPEDIT UX (fully recoverable from
  `data_extracted/text/MAPEDIT.full.json` + `MAPMENU` + `formats/MP_FORMAT.md`): paint/pickup,
  terrain palette, coastline-protect, fill radius, zoom, continent/ocean-count warnings, river
  rules. **Write path is net-new:** `viceroy_cpp/include/mp.hpp` declares only `load_mp` — there is
  **no `save_mp`/encoder** (small, ~30 lines: `u16le` header + tile bytes + optional L3 resfog
  plane). Validate: right-edge column = Sea Lane (26), terrain ids in valid ranges, bit6 forest on
  land only, coastline integrity. (Note: `mapedit_source/REWRITE_PLAN.md` cited in
  `REWRITE_READINESS.md:87` does **not** exist — reconstruct the round-trip oracle from the format
  doc; don't expect a file.)
- **Data-table editor** — typed grid over every `@`-section; writes a **sparse override JSON**
  (never the base extract); validates per-column + cross-table refs; runs the live-validate hook.
- **Text / localization editor** — edits `*.full.json` bodies; preserves `%STRINGn`/markup/directives;
  validates placeholder parity; previews width using `.FF` glyph metrics (`src/ff.cpp`); supports
  language layers.
- **Atlas / sprite reimporter** — artists edit PNGs and re-pack via `src/bundle.cpp::write_bundle`.
  **Critical check: palette-index integrity** — incoming PNG must be color-type-3 using only
  `VICEROY.PAL` indices (`read_png_indexed` enforces indexed); preserve per-frame hotspots; honor
  skip rules (placeholder frames 0/16/100; never load `BDARK.SS`/`FONTSMAL.FF`).
- **Palette + cycling editor** — edits 256 RGB entries + cycle ranges; writes a `cycle.json`
  (decoded form of the still-TBD 34-byte `CYCLE.DAT`); live animated preview.

### 1.5 Mod packaging

A directory/zip `mod/` with `modinfo.json` (id, version, `spec_version`, `load_order`, deps) +
sparse `tables/`, `text/`, `maps/`, `sprites/`, `palette/`, `rules.json` overlays. Runtime loads
base bundle, then applies mods by `load_order`; tables merge at `@section→row-index`, text at
`@key`, sprites by frame, maps whole-file. **Highest-risk open problem:** merge semantics vs the
sim's fixed enums/atlas (table-length changes are effectively unmoddable without code+art) — gate
strictly on `spec_version`. Output is exactly the runtime bundle the clients consume → "publish
mod" = "emit a bundle overlay."

### 1.6 Forge phasing & risks

- **F1 (MVP):** `RuleData` seam + harness split + read-only balance inspector.
- **F2:** map editor (+ `.MP` encoder) + data-table editor + live-validate hook.
- **F3:** atlas reimporter + palette/cycling editor + visual-diff preview (reuses
  `mapview.cpp`/`colony_screen.cpp` → `Surface` → PNG).
- **F4:** text/localization editor + balance-curve charting.
- **F5:** mod packaging/overlay loader + `spec_version` gate + scenario scripting.

Top risks: (1) `RuleData` refactor touches the crown-jewel sim — must stay value-identical;
(2) `CYCLE.DAT` unresolved (cosmetic); (3) opt-in non-data schema risks departing from "spec is
the contract" — ruling-log each; (4) the editor data model is the real bulk of work, not the grid
widget; (5) sparse-merge semantics vs fixed enums (rate **high**).

---

## Track 2 — Godot 4.x port (both logic-binding paths kept open)

A faithful Godot port using **idiomatic Nodes/Scenes** (the user's explicit intent): `TileMapLayer`
terrain + overlays, `Control`/`MenuBar`/`Theme` UI, `Sprite2D` units — under a **320×200 viewport
with `stretch=viewport`, `scale_mode=integer`** so the mode-13h look is integer-scaled and spec
byte-cited coords map straight to node positions. Not a hand-drawn framebuffer.

### 2.1 The open decision — how to run the game logic (decide later)

| Path | Pros | Cons |
|---|---|---|
| **(A) Reuse C++ sim via GDExtension (godot-cpp)** | Reuses tested logic byte-for-byte; `sim_tests` keeps guarding it (links the same `viceroy_sim` target); no logic fork; the binding is a thin `RefCounted` facade exposing `step_turn`/`colony_info`/`resolve_attack`/etc. | Per-platform native builds (incl. harder web/WASM export); pin `compatibility_minimum` 4.3+; godot-cpp API/ABI versioning to manage |
| **(B) Rewrite logic in GDScript/C#** | No native build step; pure-Godot, simplest distribution incl. web | Re-derives ~900 lines **and** re-verifies them; GDScript's float/int union risks silent drift in the integer-truncation math (`price_drift /256`, SoL `>>6`, `(10−diff)` yield, `uint64_t built_mask`, combat ladder). Forfeits the golden-master guarantee for the rewritten slice |

This plan **documents both and defers the choice** (per user direction). If/when chosen, the
analysis leans (A) for fidelity; (B) only if cross-platform/web distribution outranks reuse.

### 2.2 Assets → Godot (preserve indices for palette cycling)

Godot's default PNG import flattens to RGBA8 — that **destroys the palette index and freezes the
water shimmer**, violating the `REWRITE_READINESS.md` §4a invariant. Solution: carry the **index in
a single-channel (R8) texture** and apply `VICEROY.PAL` as a **256×1 palette-LUT texture in a
`canvas_item` shader** (`COLOR = texture(palette, vec2((idx+0.5)/256, 0.5))`; idx 0 → transparent).
Cycling is then a CPU rotate of the 256×1 LUT each tick (driven by `cycle.json`) — free regardless
of map size, shared by terrain + sprites + UI. Preferred index source: reuse `src/png_io.cpp`'s
`read_png_indexed` via a small GDExtension/import step (single source of truth, no importer
foot-guns). `frames.json` rects → `TileSet` tiles (terrain ids incl. forested 8–23 / Arctic 24 /
Ocean 25 / Sea Lane 26 / Mountains 27 / Hills 28) and `AtlasTexture` regions (units, with hotspot →
`Sprite2D.offset`).

### 2.3 Nodes/scenes, fonts, input

- **Scene tree:** `Main` → `Sim` autoload (the chosen logic backend) + `PaletteCycler` autoload +
  a `CanvasLayer` screen stack: `MapView.tscn` (TerrainLayer + OverlayLayer `TileMapLayer`s,
  `Camera2D` zoom for the 4 `@VIEW` levels, minimap via one custom `_draw()`, sidebar `Control`s at
  spec coords), `ColonyScreen.tscn`, `EuropeScreen.tscn`, F2–F10 report scenes, modal popups. Spec
  coords → node `position/size`; spec color index → `Color`; spec font → a `FontFile`.
- **Fonts:** convert the 4 `.FF` bitmap fonts offline (reuse `src/ff.cpp`) to Godot **BMFont
  `.fnt` + glyph PNG** → `FontFile` usable by any `Label`/`Theme`. Bake body text to RGBA (static
  colors per `spec/ui/fonts_and_colors.md`); keep the indexed-shader path available if any text is
  found to cycle.
- **Turn loop:** `_process` does only cycling + tweens; an explicit **End-Turn** action flushes
  queued orders then calls `Sim.step_turn()` once and refreshes nodes. Selection/orders via
  `_unhandled_input`; F-keys push report scenes.

### 2.4 Godot phasing (honest)

- **Spike (~weekend):** godot-cpp builds; a facade wraps `step_turn`+`colony_info`; a test scene
  asserts year/gold across N turns match `sim_tests`. *(Only if path A.)*
- **G1 (~1 wk):** terrain render from the R8 atlas + palette shader → the "shimmying globe."
- **G2 (~1–2 wks):** map HUD, minimap, camera zoom levels, unit sprites, selection.
- **G3 (~2–3 wks + the spine):** End-Turn loop, orders, combat, fonts. **Buried cost:** this
  includes the net-new, newly-golden-tested **unit/turn spine** (units on `World`, movement, order
  application, multi-power) — treat as its own row, not "the P2 movement gap."
- **G4 (months — the long pole):** the 52 UI screens as `.tscn` from `spec/ui/*`. Godot
  *shortens* this vs native P4 (`Control`/`MenuBar`/`Theme`/`FontFile`/`TileMapLayer` replace a
  hand-written widget/blitter/text stack).
- **G5:** sound, cinematics, save/load, polish.

Risks: index preservation through Godot import (mitigate with the runtime `png_io` loader +
round-trip check); `CYCLE.DAT` shimmer undecoded (cosmetic); godot-cpp API churn (pin version);
the 4 zoom levels (16/8/4/2 px tiles) need explicit `Camera2D` integer-zoom handling; sidebar/menu
coords are tier-R (a few px tolerance).

---

## Track 3 — ESP32-P4 + MIPI-DSI display (full faithful game)

The best-fit embedded target for this codebase: the P4's **MIPI-DSI native RGB565/666/888 output**,
its **PPA (Pixel Processing Accelerator) for hardware scale/convert**, and **up to 32 MB PSRAM /
128 MB flash** align almost one-to-one with the existing indexed-framebuffer + offline-bundle
architecture. The sim and the blitter port nearly unchanged; the work is a presentation/input
shell + one build-time asset-flatten tool. Hardware: dual RISC-V @400 MHz + FPU, 768 KB SRAM.

### 3.1 Sim on-device — essentially free

Compiles under ESP-IDF unmodified (RISC-V GCC defaults to `gnu++26`; C++17 is a subset). Verified
the entire `sim/` tree has **zero `throw`/`iostream`/`new`/`std::string`/`std::map`** — the only
heap users are `std::vector<Colony/Unit>` on `World` and the `std::function` RNG (one benign setup
alloc; can build `-fno-exceptions`). **Footprint:** even with 2,000 units + 64 colonies, total live
state ≈ **~52 KB** — fits on-chip SRAM, trivial in PSRAM. **Cross-compile `sim_tests.cpp` and run
the exact golden-master suite on-device** — the strongest fidelity proof available; make it a hard
bring-up gate.

### 3.2 Assets — build-time flatten, mmap from flash

Add a build-time sink after `src/bundle.cpp` that flattens the bundle into a fixed-layout
`assets.bin` (header + 256-RGB palette + sheet table + 7-int frame records + **raw 8bpp indices —
NOT RGB**, preserving cycling). The on-device loader is a `mmap`-style cast over flash
(`esp_partition_mmap`) — **no libpng, no JSON, zero decode**. Size: measured **~20 MB** flat across
241 atlas files (corrects an earlier "6–12 MB" estimate) — a rounding error against 128 MB flash,
but **mmap from flash; do not copy the whole atlas to PSRAM**. Keep only the active screen's sheets
hot (a single screen needs ~2 MB; largest sheet PHYS0 = 0.56 MB).

### 3.3 Rendering — the one genuinely new subsystem

Keep the **320×200 8bpp indexed framebuffer as source of truth** (`surface.hpp`, `W=320 H=200`);
all blit primitives + the `.FF` glyph renderer port **verbatim** — only `surface.cpp:97`'s
`to_rgb()` is replaced. Pipeline: (A) sim → indexed FB in SRAM (sub-ms); (B) **index → RGB,
mandatory per-frame CPU LUT pass** — *verified: the PPA cannot consume indexed/CLUT input*, so a
256-entry LUT rebuilt each frame from the live `VICEROY.PAL` (this is where cycling stays live);
(C) PPA hardware integer-scale the small RGB intermediate into a double-buffered PSRAM scanout,
EDMA to DSI. **Target RGB666, not RGB565** — RGB565 truncates the 8-bit palette permanently and the
project's contract is "preserve colors exactly"; bandwidth headroom easily absorbs RGB666.
**Hand-rolled blitter over LVGL** (the existing `Surface` is already pixel-identical to the oracle;
LVGL would discard that parity). Redraw-on-dirty makes a turn-based game feel instant — a shipped
P4+DSI project hits 60 FPS animated at 1024×600 via PPA partial redraws, far above what's needed.
**Landmine:** confirm PSRAM clock is actually 200 MHz in `sdkconfig` (it silently drops to 80 MHz
in some configs, halving all bandwidth).

### 3.4 Full-game scope (per user direction — nothing cut by default)

- **Map view + minimap + sidebar, colony screen, turn loop** — port from `mapview.cpp` /
  `colony_screen.cpp` near-verbatim.
- **Europe + all F2–F10 report screens + popups** — static-layout button screens; touch suits them.
- **Input** — capacitive touch (GT911 over I²C on the common DSI panels) as primary (tile/minimap/
  menu taps, swipe-scroll, on-screen order buttons), optional physical D-pad+A/B/Start.
- **Save/load** — serialize the ~52 KB POD-ish state to SD or flash NVS (high value, low cost).
- **Sound** — play the original `COLDIG.BIN` PCM SFX via I²S DAC/amp.
- **Cinematics** — `.PIK` backgrounds decode to 320×200 stills (title/end screens); fully animated
  OPENING/CLOSING are the one area likely **approximated** (the bundle doesn't carry them as frames;
  timing is in `docs/CINEMATIC_TIMING_AUDIT.md` but unannotated).
- **Networking/multiplayer** — out of scope (P4 has no built-in WiFi/BT; single-player needs none).

### 3.5 ESP32-P4 phasing & risks

- **P-A (1–2 wks):** ESP-IDF project; cross-compile sim + **run golden-master on-device** (gate);
  DSI panel up with a test pattern at integer scale.
- **P-B (1 wk):** asset-flatten tool + `assets.bin` mmap loader; render one sprite + one `.FF`
  string, byte-verify vs oracle.
- **P-C (1–2 wks):** port `Surface` + `mapview.cpp`; **prove the palette-cycle LUT rebuild +
  dirty-rect PPA scale early** (the only subsystem with no existing code and all the real risk);
  pixel-parity vs P0 oracle.
- **P-D (2 wks):** GT911 touch + colony screen + End-Turn loop + save/load.
- **P-E (full-game build-out):** Europe/reports, sound (I²S), title/end stills, the unit/turn spine
  (shared with Godot), performance tuning.

Top risks: PSRAM-bandwidth ceiling on full-panel scaling (measure first; mitigations:
dirty-region, indexed FB in SRAM, RGB666); index→RGB is a fixed per-frame CPU cost (design it in);
integer-scale fit (320×200 ×3 = 960×600 letterboxes cleanly on 1024×600 — pick the panel early);
the 200 MHz-vs-80 MHz PSRAM trap; RGB565→RGB666 fidelity decision.

---

## Recommended sequencing

These are not mutually exclusive; the dependency structure picks the order, and it agrees with the
user's choice of the Forge as the lead:

1. **Forge F1 — the `RuleData` seam + harness split (LEAD, start here).** Highest leverage:
   smallest surface that proves the thesis, turns the data tables into the true single source of
   truth (Godot + ESP32 inherit data-driven balance for free), and reveals the real modding ceiling
   on day one. Verified mechanically sound (value-identical refactor).
2. **The unit/turn sim spine** (units on `World`, movement, orders, multi-power) as tested C++ —
   the prerequisite both *playable* clients silently assume. Doing it once in the shared core means
   neither client re-discovers the gap.
3. **Godot port** as the flagship player client — most broadly shippable; its long pole (52 UI
   screens) is the same P4-UI work but easier in Godot, and the Forge built in step 1 is its
   content pipeline. Resolve the GDExtension-vs-rewrite decision here.
4. **ESP32-P4 (full game)** as the leaf — it depends on a **frozen bundle binary format** (it
   flattens the bundle to mmap-able `assets.bin`) and the finished sim spine; do it once those are
   stable so you're not chasing a moving target on the hardest-to-iterate platform.

Build the Forge so it is **the shared content pipeline** upstream of both clients (it alone *writes*
the bundle; the clients only *read* it), generalizing the original's standalone `MAPEDIT.EXE`
precedent from maps to all data/art/text.

## Cross-cutting decisions the owner must make

1. **How far the `RuleData` seam reaches** — the line between "tunable config" (params: extractable,
   verified value-identical) and "code" (formulas, the demotion ladder, FF curve, `NUNITTYPES`).
   This defines what "modding" means and gates everything; make it first.
2. **Freeze the bundle binary format (+ add `cycle.json`)** — the ESP32 flatten step, the Forge's
   overlay/merge semantics, and Godot's R8-atlas export all assume a stable schema (incl. `frames.json`
   hotspots, `manifest.json` layers, merge granularity). Also decide the `CYCLE.DAT` story: decode it
   or ship a documented hand-tuned approximation (it's undecoded across all three).
3. **Land the unit/turn spine in shared tested C++** — not re-implemented per client, not in GDScript
   where it forfeits the test guarantee.
4. **Godot: GDExtension vs rewrite** — deferred here per user direction; the analysis leans
   GDExtension (pin `compatibility_minimum` 4.3+).
5. **ESP32 scanout depth: RGB565 vs RGB666** — the one place fidelity is permanently lost; given the
   "colors exactly" contract and the bandwidth headroom, RGB666 should be the stated default. Pick
   the target panel early (it dictates scanout geometry).

---

## Verification

This plan is exploratory; verification applies to each track as it is built, all anchored on the
existing oracle infrastructure:

- **Sim correctness (all tracks):** `viceroy_cpp/sim/tests/sim_tests.cpp` stays green throughout.
  After the `RuleData` refactor it splits into a parameterized baseline suite (must stay green) + a
  new modded-data invariant suite. Build/run:
  `cmake -S viceroy_cpp -B viceroy_cpp/build && cmake --build viceroy_cpp/build -j && ./viceroy_cpp/build/sim_tests`.
- **Forge:** the live-validate loop *is* the verification — every edit re-runs the relevant
  `sim_tests` subset in-process (test binary runs in ~0.002s) + a visual diff of the affected
  320×200 screen rendered via `mapview.cpp`/`colony_screen.cpp` → PNG, diffed against the pre-edit
  render. `.MP` editor: round-trip a map through the new encoder and assert byte-identity vs
  `load_mp`.
- **Godot:** the GDExtension facade asserts year/gold/price across N turns equal `sim_tests`
  expectations; visual parity of the map view + each screen against the P0 oracle / DOS reference
  screenshots in `docs/screens/`; a round-trip check that R8 atlas indices survive Godot import.
- **ESP32-P4:** **cross-compile and run `sim_tests` on-device** (hard bring-up gate) — the strongest
  fidelity proof; then pixel-parity of the rendered map view against the P0 oracle output; measure
  PSRAM bandwidth + frame timing on real hardware before committing the scanout path.

### Critical files to start in (by track)

- **Forge:** `viceroy_cpp/sim/{unit,combat,economy,market,ref,founding_fathers}.cpp` (the literals to
  data-drive), `viceroy_cpp/sim/tests/sim_tests.cpp`, `viceroy_cpp/include/mp.hpp` +
  `viceroy_cpp/src/mp.cpp` (decode-only — add the encoder), `data_extracted/tables/names_tables.json`,
  `viceroy_cpp/src/bundle.cpp`, `data_extracted/text/MAPEDIT.full.json`, `formats/MP_FORMAT.md`.
- **Godot:** `viceroy_cpp/sim/types.hpp`/`game.hpp` (binding surface), `viceroy_cpp/CMakeLists.txt`
  (`viceroy_sim` target), `viceroy_cpp/src/png_io.cpp`/`pal.cpp`/`ff.cpp`, `viceroy_cpp/src/bundle.cpp`
  (frames schema), `spec/ui/map_view.md`, `docs/PALETTE_AND_CYCLING.md`.
- **ESP32-P4:** `viceroy_cpp/sim/types.hpp` (footprint), `viceroy_cpp/sim/tests/sim_tests.cpp`,
  `viceroy_cpp/src/surface.cpp` + `include/surface.hpp` (port verbatim; `to_rgb()` is the only
  replacement), `viceroy_cpp/src/bundle.cpp` (flatten), `viceroy_cpp/src/mapview.cpp` +
  `colony_screen.cpp`, `REWRITE_READINESS.md` §1/§4a.
