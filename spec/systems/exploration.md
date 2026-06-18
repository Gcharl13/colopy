# Exploration / Visibility (Fog of War)

> **Layer 2 — Specification (population stub).** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R/TBD. Details TBD — breadth pass.

**Overall confidence:** behavior `RECONSTRUCTED` from manual; state offsets and
sighting radius `TBD`.
**Canonical primary:** `docs/GAME_MANUAL.md` (visibility / discovery rules);
`data_extracted/text/GAME_sections.json` (scout/rumor messages).

## 1. Purpose & behavior
The map starts hidden. The player only sees the area immediately around their
starting ship; native tribes and other European powers stay hidden until met
directly. Moving and exploring reveals more of the world, and **once revealed an
area remains visible for the rest of the game** (`docs/GAME_MANUAL.md`).
RECONSTRUCTED: persistent reveal (no re-fogging), per-tile "discovered" state.

## 2. State & data
- Per-tile discovered flag: candidate is `.MP` tile-byte **bit 7** ("possibly
  discovered by player 0", `formats/MP_FORMAT.md`) — **TBD / unconfirmed**.
- Visibility radius per unit type (scout vs ship vs colonist): **TBD**.
- Scout-related message keys (`GAME_sections.json`, BYTE_VERIFIED strings):
  `@LOSTOURSCOUTS`, `@LOSTTHEIRSCOUTS`, `@SCOUTCOLONY` — used by scout interactions.

## 3. Formulas & rules
- Sight radius / what a moving unit reveals each step: **TBD**.
- Scout & Seasoned Scout bonuses ("Better at exploring rumors, negotiating,
  meeting Chiefs, infiltrating", manual): **R** for function; numbers **TBD**.
- Lost-City rumor squares: see `spec/systems/events.md`.

## 4. UI
Hidden tiles render as "Unexplored" (`@OTHER_NAMES` last entry, NAMES — **B** that
the label exists). Viewport redraw via map render chain `func_O514 → O513 → O512`.
Layout `TBD`.

## 5. Evidence
- `docs/GAME_MANUAL.md` — fog/discovery, permanent reveal, scout abilities. **R**
- `formats/MP_FORMAT.md` — tile-byte bit 7 (unconfirmed discovered flag). **TBD**
- `data_extracted/text/GAME_sections.json` — @LOSTOURSCOUTS/@SCOUTCOLONY. **B** (strings).
- `docs/ARCHITECTURE.md` — `func_05A20E` scout interactions. **B** (entry point).

## 6. Open questions (TBD)
1. Confirm the per-tile discovered flag location (tile-byte bit 7 vs separate visibility map).
2. Sight radius by unit type; whether terrain (hills/mountains) extends sight.
3. Whether other powers' positions reveal on contact only, or via shared exploration.
4. Trace scout-bonus arithmetic out of `func_05A20E`.
