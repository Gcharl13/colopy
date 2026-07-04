# REWRITE_READINESS.md — modern C++ reimplementation strategy

**Goal (user-set):** a from-scratch modern C++ build that **looks and runs like the
original** *Sid Meier's Colonization*, where the low-level math **may be modernized** from the
16-bit assembly it came from. This is a *behavioral + visual* fidelity target, **not** a
bit-exact reproduction of the original CPU instructions.

This is the project's **Layer 3 — Implementation** (`METHODOLOGY.md`): "a modern, runnable port
built *from the spec*… idiomatic, testable, actually compiles and runs," which "implements the
*documented behavior*, not the *byte sequence*." So the relaxed goal is already project doctrine —
**the `spec/` is the contract; the implementation form is free.**

> **Status:** P0 (asset → pixels) is **done and oracle-verified** — see `viceroy_cpp/`. The rest of
> this document is the strategy for P1+.

---

## 1. Fidelity policy — "preserve vs modernize"

The dividing line is **observability**:

- **PRESERVE (the contract):** anything the player can see or that changes game *balance* — every
  documented formula/output in `spec/systems/*` and every layout/font/color in `spec/ui/*`. The
  result must match; the *route* to it need not.
- **MODERNIZE (free):** the implementation *form* — drop segment math and far pointers; use clean
  `int`/`int64`/`double` instead of 16-bit truncation and Borland fixed-point; use any modern RNG;
  pick any engine, window system, and (integer-scaled) resolution.

**Dropped as hard requirements** (they only mattered for *provable byte-accuracy*): exact PRNG
algorithm + draw-ordering, exact 16-bit overflow/truncation, frame-cycle-exact timing.

**But "modernize the math" must still reproduce the player-visible numbers.** These specific
integer behaviors produce values the player reads on screen or feels as balance — keep their
*outputs* (use wider integers, but the documented rounding/curve must hold):

| Behavior | Spec | Note |
|---|---|---|
| Market price drift `price -= (base + Σtrade)/256` | `spec/systems/market.md` (`func_0305A8`) | integer divide by 256 |
| Sons of Liberty 1/64 EMA, steady-state ≈ `50·bells/pop` | `spec/systems/colony.md` (`sol_membership_pct`) | fixed decay; keep the curve |
| Per-tile yield = terrain table + profession + SoL penalty (`/(10−diff)`) | `spec/systems/colony.md` | integer truncation visible as yield |
| Score rank `largest n with n²/3 < score`, diff multiplier `[4,5,6,8,10]` | `spec/systems/scoring.md` | the rank bands are visible |
| Tax-raise delta `((diff & 0xFE)<<1)+4`, cap 75 | `spec/systems/king.md` | the % the player pays |
| Combat odds `ATK/(ATK+DEF)`, demotion ladder, handicap `+(4−diff)` | `spec/systems/combat.md` | win rates = balance |
| REF accrual `(8·diff+10)·2^era`, buy at 1800 | `spec/systems/ref_growth.md` | end-game pacing |

Determinism is still desirable (same seed → same game for testing/replays), but it's a **fresh,
clean** PRNG choice, not a reproduction of the original LCG's bit pattern. Any place the rewrite
*chooses* to diverge from the documented behavior gets a note in `notes/rulings/RULINGS.md`.

---

## 2. Readiness ledger (under the relaxed goal)

Two surveys this session + the spec certification (`spec/README.md`, "Authoritative Residual Ledger
empty"):

| Domain | Readiness | Build on | Residual (relaxed goal) |
|---|---|---|---|
| **Game logic / rules** (30 systems) | **Ready** | `spec/systems/*.md` formulas (all byte-verified; map-gen incl.) | A few **fuzzy AI** thresholds → APPROXIMABLE (pick a documented default) |
| **Asset loading** | **Ready** | two-stage (§4a): an **offline importer** decodes `.SS/.PIK/.FF` (MADSPACK/FAB) → a **paletted-PNG + JSON bundle**; the **runtime loads only the bundle** | none |
| **Map-view render** | **Ready** | tile chain `func_O514→O513→O512` (`spec/ui/map_view.md`), `viceroy_cpp` P0 | sub-cell transition refinement → COSMETIC (P0 uses naive mapping) |
| **Screen-UI render** (colony/Europe/advisor/congress) | **Ready** | `spec/ui/*.md` byte-grounded render bodies + geometry + font/color | sidebar HUD per-line coords; popup body color → APPROXIMABLE (measure from frames) |
| **Fonts + color** | **Ready** | `spec/ui/fonts_and_colors.md` (4 `.FF` fonts, palette-indexed colors → RGB) | none |
| **Palette cycling** | **Narrow gap** | `docs/PALETTE_AND_CYCLING.md` | `CYCLE.DAT` timing TBD → APPROXIMABLE (approximate the shimmer) |
| **Cinematics** (intro/closing) | **Out-of-scope (recoverable)** | OPENING/CLOSING `.EXE` are disassembled in-repo (`code/OPENING|CLOSING/disasm`, Phase-1) but unannotated | frame timing + `AMERICA.MOV` → Phase-2 effort or hand-time from captures |
| **Sound / music** | **Narrow gap** | `COLDIG.BIN` (PCM) + `.COL` configs byte-identity extracted | playback/sequencing mechanism unspecified → APPROXIMABLE |
| **Save / load** | **Ready** | `spec/systems/save.md` (`COLONY<slot>.SAV`, `HALLFAME.DAT`) | a few HALLFAME word semantics → COSMETIC |

**Net:** under "look + run like the original," there are **no blockers** — every former "blocker"
(determinism, overlay-resident layout) downgrades to APPROXIMABLE or COSMETIC once bit-exactness is
dropped.

---

## 3. Build on vs write fresh

**Reuse (do not re-derive):**
- **The spec contract** — `spec/systems/*` (formulas), `spec/ui/*` (geometry + font/color),
  `spec/data/*` + `data_extracted/text/*_sections.json` (NAMES/GAME/LABELS tables), `formats/*.md`.
- **The asset decoders** — `tools/ssdec.py` (ported to C++ in `viceroy_cpp`); these run **only in
  the offline importer** (§4a), never in the shipped runtime.
- **The visual oracle** — `viceroy_cpp` (the `mapview` renderer output) checked against DOS
  reference screenshots (pixel parity). *(The old `tools/render_map.py` Python oracle was a naive
  placeholder and has been removed — superseded by the C++ renderer.)*
- **`viceroy_source/` as *leads only*** — low-trust Layer-1 transcript (never compiled); cite its
  `@asm` blocks to find code, but trust the **spec**, not its C bodies (CLAUDE.md trust order).
- **The proven Layer-3 pattern** — `mapedit_source/REWRITE_PLAN.md` ("cite or TBD, never guess";
  round-trip/oracle-verified).

**Write fresh:** the C++ sim core, the presentation layer (indexed-color surface + palette + the 4
`.FF` fonts + an **atlas blitter**), the offline importer, input + turn loop, and the test harness.

---

## 4a. Asset pipeline — import once, run on a modern bundle

**Decision:** the shipped runtime does **not** carry the original MicroProse codec (MADSPACK/FAB/
`.SS` RLE). It runs entirely on **modern, standard formats**. The quirky codec lives in a **one-time
offline importer**:

```
original game files (user-owned)            ── importer (uses the decoder) ──▶  asset bundle
  raw/COLONIZE/PHYS0.SS, *.PIK, *.FF, ...                                         *.png (atlas) + *.json (frames) + palette
                                                                                  └── runtime loads ONLY this
```

- **Importer** (`viceroy_cpp import-all …`): decodes the assets via the ported MADSPACK/FAB code,
  packs sprite frames into a texture atlas, writes a **paletted PNG** (color-type-3, with
  `PLTE`+`tRNS`) + a **`frames.json`** (per-frame `w,h` + original `.SS` hotspot `x,y` + atlas rect),
  and `.PIK` backgrounds as paletted PNGs, into a bundle dir + `manifest.json`. PNG via **libpng**
  (a standard dep — not a game codec). **Status:** all **204** sprite sheets (`.SS`, minus the 2
  CLAUDE.md-#5 orphans) + **35** backgrounds (`.PIK`) + **4** fonts (`.FF`, format cracked
  2026-06-21 → glyph atlas + metrics) bundle with **0 failures**. (FONTSMAL stays orphan.)
- **Runtime** loads the bundle (libpng + JSON) and never touches `.SS`. Simpler, modding-friendly
  (artists can edit the PNGs), and dependency-light.

> **Format update (2026-07-04, user directive):** the committed asset trees
> (`data_extracted/**`, `docs/atlas/**`) ship as **24-bit BMPs** (magenta 255,0,255 =
> transparency colorkey), not PNGs. Invariant 1 below is preserved a different way: the runtime
> quantizes the BMP's RGB back to `VICEROY.PAL` **indices at load** (exact-match LUT in
> `native_assets.cpp read_png_quantized` — lossless because every asset pixel is a palette color
> and the magenta key collides with nothing, verified repo-wide), so palette cycling still works
> on indices. The legacy `viceroy_cpp import-all` bundle CLI below still round-trips its own
> paletted PNGs internally.

**Two fidelity invariants this must keep** (the reason it's *paletted* PNG, not flattened RGB):
1. **Indexed color is preserved.** The atlas stores **palette indices**, not baked RGB, so the
   runtime can apply the live `VICEROY.PAL` and do **palette cycling** (animated water/shimmer per
   `docs/PALETTE_AND_CYCLING.md` / `CYCLE.DAT`). Flattening to RGB would freeze those animations.
2. **Frame metadata is preserved.** `.SS` frames carry a `(x,y)` hotspot; per-frame PNGs alone drop
   it. `frames.json` keeps it, so unit/building/UI sprites place correctly (terrain tiles are 16×16
   at origin and don't need it, but the metadata is captured uniformly).

**Provenance:** ship the **engine + importer**, not the converted art. The import step runs locally
against the user's own game files — the bundle is derived from copyrighted MicroProse assets and is
not committed/redistributed (the `docs/atlas/` BMPs are a deliberate documentation exception, not
the shipping path).

---

## 4. Architecture

Keep a hard split so the rules are testable headlessly and the look is faithful:

- **Sim core** — pure C++, no I/O: game state (Colony/Unit/Power/Native records per the
  byte-verified strides) + the spec formulas, driven by the decoded data tables. Deterministic via
  an injected RNG. This is where "modernized math" lives (wide ints, clean code) under the §1
  contract.
- **Presentation layer** — a thin client over the sim: a **320×200 indexed-color framebuffer**
  (mode-13h-faithful), VICEROY.PAL + cycling, an **atlas blitter** (from the §4a bundle) and `.FF`
  glyph renderer, integer-scaled to the window. Engine intentionally unspecified (SDL2/raylib-class);
  P0 proves the pipeline headlessly to a file first.
- **Asset layer** — split per §4a: the **importer** (MADSPACK/FAB/SS decode → bundle, offline) and
  the **runtime bundle loader** (paletted PNG + JSON). `.MP`/`.PAL` are simple enough to load
  directly at runtime.

---

## 5. Validation strategy (the real net-new investment)

"Looks + runs like the original" still needs an oracle:

1. **Visual parity** — composite each screen from `viceroy_cpp` (the `mapview` renderer)
   and recorded session frames; pixel-diff. (P0 already passes this for the map view.)
2. **Behavioral golden-master** — per-system unit tests asserting the spec formulas (price drift,
   SoL EMA, combat odds, tax curve, REF accrual, score/rank…) over fixed inputs.
3. **Optional differential runs** — stand up the original under DOSBox and spot-check balance/feel
   on a few scripted turns. *This harness does not exist yet* and is the main QA build-out.

---

## 6. Phased roadmap

- **P0 — asset → pixels (DONE).** `viceroy_cpp`: the offline importer (§4a) decodes PHYS0.SS → a
  paletted-PNG atlas + `frames.json`; the runtime renders the map view **from the bundle** (no codec)
  + VICEROY.PAL + AMER2.MP, **pixel-identical to the oracle**. Proves the foundation + the pipeline.
- **P1 — economic spine (DONE).** Headless sim core `viceroy_cpp/sim/`: turn cadence + orchestrated
  per-turn loop (`game.step_turn`), colony production (tory penalty + expert), SoL 1/64 EMA,
  hammers/build, warehouse cap, food→growth, immigration, market price drift, REF growth — all
  golden-master tested (`sim_tests`).
- **P2 — units & conflict (DONE).** `@UNIT` stat table + Unit model; land combat (odds, terrain
  defense, difficulty handicap, demotion ladder, capture); natives (mission/raid/tension/trade/
  tribute); diplomacy (war/treaty matrices, cooldown, AI willingness). Golden-tested. *(Remaining
  for later: unit movement/orders pathing, naval combat detail — not gating P3.)*
- **P3 — meta systems (DONE).** Founding Fathers bell-cost curve + availability + era bands;
  revolution (declare gate, REF-war victory, score bonus, Tory uprising); scoring (difficulty
  mult, population component, rank); map-gen climate→terrain + dims. Golden-tested.
- **P4 — screen-UI parity (NEXT).** Colony/Europe/advisor/congress/menus rendered from `spec/ui/*`
  with fonts + palette; visual-diff each. **Fonts now unblocked:** the `.FF` format is cracked +
  bundled (glyph atlas + metrics; RULING 2026-06-21). Remaining for P4: build the screen-render +
  text/widget layer on top of the P0 blitter — a substantial new sub-project.
- **P5 — polish.** Palette cycling, sound, cinematics (annotate OPENING/CLOSING or hand-time),
  windowed/interactive client + input.

Each phase ships against the spec contract + the visual/behavioral oracle.

---

## 7. Honest residuals under the relaxed goal

Things still needing a judgement-call (none block "look + run like the original"):
- **Fuzzy AI thresholds** (diplomacy willingness, native tension deltas) — pick a documented
  default; flag in `RULINGS.md`.
- **Sidebar HUD per-line coords + popup body text color** — overlay-resident; measure from frames.
- **`CYCLE.DAT` palette-cycle timing** — approximate the animation (water shimmer).
- **OPENING/CLOSING cinematic timing + `AMERICA.MOV`** — disassembled in-repo but unannotated;
  Phase-2 annotation or hand-time from captures (outside the chosen VICEROY-only RE scope).

**Bottom line:** the simulation and asset pipeline are ready to implement directly from the spec;
the rewrite's real cost is engineering + a validation harness, not further reverse-engineering.
