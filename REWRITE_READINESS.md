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
| **Asset loading** (`.SS/.PIK/.FF/.PAL/.MP/.TXT`) | **Ready** | `tools/ssdec.py` → ported to `viceroy_cpp` (P0) | none |
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
- **The asset decoders** — `tools/ssdec.py` (now ported to C++ in `viceroy_cpp`), `tools/extract_*`.
- **The visual oracle** — `tools/render_map.py` and the new `viceroy_cpp/verify.py` (pixel parity).
- **`viceroy_source/` as *leads only*** — low-trust Layer-1 transcript (never compiled); cite its
  `@asm` blocks to find code, but trust the **spec**, not its C bodies (CLAUDE.md trust order).
- **The proven Layer-3 pattern** — `mapedit_source/REWRITE_PLAN.md` ("cite or TBD, never guess";
  round-trip/oracle-verified).

**Write fresh:** the C++ sim core, the presentation layer (indexed-color surface + palette + the 4
`.FF` fonts + `.SS`/`.PIK` blitter), input + turn loop, and the test harness.

---

## 4. Architecture

Keep a hard split so the rules are testable headlessly and the look is faithful:

- **Sim core** — pure C++, no I/O: game state (Colony/Unit/Power/Native records per the
  byte-verified strides) + the spec formulas, driven by the decoded data tables. Deterministic via
  an injected RNG. This is where "modernized math" lives (wide ints, clean code) under the §1
  contract.
- **Presentation layer** — a thin client over the sim: a **320×200 indexed-color framebuffer**
  (mode-13h-faithful), VICEROY.PAL + cycling, the `.SS`/`.PIK` blitter and `.FF` glyph renderer,
  integer-scaled to the window. Engine intentionally unspecified (SDL2/raylib-class); P0 proves the
  pipeline headlessly to a file first.
- **Asset layer** — `viceroy_cpp` (P0): MADSPACK/FAB/SS/PIK/PAL/MP loaders.

---

## 5. Validation strategy (the real net-new investment)

"Looks + runs like the original" still needs an oracle:

1. **Visual parity** — composite each screen against `tools/render_map.py` / `viceroy_cpp/verify.py`
   and recorded session frames; pixel-diff. (P0 already passes this for the map view.)
2. **Behavioral golden-master** — per-system unit tests asserting the spec formulas (price drift,
   SoL EMA, combat odds, tax curve, REF accrual, score/rank…) over fixed inputs.
3. **Optional differential runs** — stand up the original under DOSBox and spot-check balance/feel
   on a few scripted turns. *This harness does not exist yet* and is the main QA build-out.

---

## 6. Phased roadmap

- **P0 — asset → pixels (DONE).** `viceroy_cpp`: decode VICEROY.PAL + PHYS0.SS + AMER2.MP from
  scratch, render the map view, **pixel-identical to the oracle**. Proves the foundation.
- **P1 — economic spine.** Sim core: turn loop (`func_005760`), colony production, market drift,
  warehousing, immigration. Golden-master tests per formula.
- **P2 — units & conflict.** Units/orders/movement, combat, natives, diplomacy.
- **P3 — meta systems.** Founding fathers/congress, revolution + REF + Tory uprising, scoring,
  map generation.
- **P4 — screen-UI parity.** Colony/Europe/advisor/congress/menus rendered from `spec/ui/*` with
  fonts + palette; visual-diff each.
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
