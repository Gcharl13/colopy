# Turn Dispatch & Phases

> **Layer 2 — Specification (population stub).** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R/TBD. Details TBD — breadth pass.

**Overall confidence:** dispatcher + turn-counter anchors `BYTE_VERIFIED`;
per-phase ordering partly `RECONSTRUCTED`; case-by-case decode `TBD`.
**Canonical primary:** `docs/ARCHITECTURE.md` (per-turn loop, dispatchers, anchors),
`data_extracted/text/NAMES_sections.json` (@NATIONALITY for power order).

## 1. Purpose & behavior
Each turn the game iterates active powers and, per power, processes pending events
(combat, market, king, diplomacy) via function dispatchers, then redraws the
viewport/HUD and writes saves at intervals (`docs/ARCHITECTURE.md`). Powers:
0..3 European players + 4..11 native tribes (`docs/ARCHITECTURE.md`). **B** (iteration scheme).

RECONSTRUCTED per-power sequence (manual/team-doc framing): natives → English →
French → Spanish → Dutch. The exact European order is the `@NATIONALITY` order
(English/French/Spanish/Dutch, **B** that this is the index order); confirmation
that turn processing follows index order is **TBD**.

## 2. State & data
DGROUP anchors (`docs/ARCHITECTURE.md`, BYTE_VERIFIED):
- `0x53A6` — current player / difficulty (byte). **B**
- `0x538E` — turn counter (16-bit, BYTE_VERIFIED via king-tax formula). **B**
- `0x5382` — game flags. **B**
- PowerRecord[N] at `0x8809 + N×0x13C`; UnitRecord[N] at `0x3146 + N×0x1C`;
  AIPersonality[N] at `0x540E + N×0x34`. **B**

Main dispatcher: the architecture doc names overlay dispatchers
(`func_210d_0d91` / `func_210d_0dab`, file `0x011D91`/`0x011DAB`, BYTE_VERIFIED)
as the cross-overlay call surface; AI dispatcher `func_04E2D6`, tutorial
dispatcher `func_020F50` (BYTE_VERIFIED entry points). A dedicated top-level
turn-phase dispatcher (~27 cases) is **TBD here** — confirm the function and its
case table before tagging. → `spec/BACKLOG.md`.

## 3. Formulas & rules
- Phase ordering within a power's turn (movement → production → market → king →
  diplomacy): **TBD** (case order not decoded).
- Turn-counter increment timing and year mapping: **TBD** (counter at `0x538E` **B**).
- Native-tribe turn processing (powers 4..11): **TBD**.

## 4. UI
End-of-turn redraw via render chain `func_O514 → O513 → O512`; HUD update; "next
unit needing orders" prompt loop (manual). Layout `TBD`.

## 5. Evidence
- `docs/ARCHITECTURE.md` — per-turn loop; power iteration 0..3 + 4..11; DGROUP anchors; dispatcher functions. **B**
- `data_extracted/text/NAMES_sections.json` — `@NATIONALITY` index order. **B**
- `docs/GAME_MANUAL.md` — per-unit orders prompt; end-of-turn flow. **R**

## 6. Open questions (TBD)
1. Identify the top-level turn/phase dispatcher and enumerate its ~27 cases.
   **Ruled out (2026-06-20):** the `func_33C96` switch (`jmp word ptr cs:[bx+0x3a1a]`
   `@0x33F65`, table `@0x33F6A`) is **not** it — it has only **12 cases** and is a
   market/Europe **trade-screen** economic/unit-command interpreter (mouse hit-test
   `0x181F:0x3CA`, page-23 UI helpers), not the headless turn loop. (And the
   `~0x36814` region I earlier floated as a "dispatch table" is a JMP-FAR trampoline
   island, not a case table — see `market.md` §3.) The real ~27-case turn-phase
   dispatcher is still **unlocated**.
2. Confirm power-processing order (natives first vs interleaved) at the dispatch site.
3. Map each phase to its BYTE_VERIFIED system function (production `func_02D658`, market `func_0305A8`, king tax `func_034AE0`, etc.).
4. Turn-counter → in-game-year conversion.
