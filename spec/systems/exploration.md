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
- **Scout "infiltrate colony" interaction** — `func_05A20E` (file `0x5A20E`).
  **BYTE_VERIFIED mechanism:** for a **human European** actor (unit
  `UnitRecord +0x01 & 0x0F < 4` and `AIPersonality[+0x543F].controller == 0`) the
  `@SCOUTCOLONY` **3-option dialog** is shown (with the colony name substituted),
  thunk `0x181F:0x652` @`0x5A254`; otherwise the result defaults to option 3.
  Choosing option 1 is **blocked during the revolution** (`TEST [0x5382],1` →
  `@NOMAYORSDURINGREV` @`0x5A28A`). The three options' exact effects (and the
  Scout-skill numeric bonuses) are **TBD**.
- Lost-City rumor squares: see `spec/systems/events.md`.

## 4. UI
Hidden tiles render as "Unexplored" (`@OTHER_NAMES` last entry, NAMES — **B** that
the label exists). Viewport redraw via map render chain `func_O514 → O513 → O512`.
Layout `TBD`.

## 5. Evidence
- `docs/GAME_MANUAL.md` — fog/discovery, permanent reveal, scout abilities. **R**
- `formats/MP_FORMAT.md` — tile-byte bit 7 (unconfirmed discovered flag). **TBD**
- `data_extracted/text/GAME_sections.json` — @LOSTOURSCOUTS/@SCOUTCOLONY. **B** (strings).
- `func_05A20E` (file `0x5A20E`) — scout infiltrate-colony: `@SCOUTCOLONY` 3-option dialog (human-European gated), option 1 blocked post-independence via `@NOMAYORSDURINGREV` (`[0x5382]&1`). **B** (dialog + gate; option semantics TBD).

## 6. Open questions (TBD)
1. Confirm the per-tile discovered flag location (tile-byte bit 7 vs separate visibility map).
2. Sight radius by unit type; whether terrain (hills/mountains) extends sight.
3. Whether other powers' positions reveal on contact only, or via shared exploration.
4. Trace scout-bonus arithmetic out of `func_05A20E`.
