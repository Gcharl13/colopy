# Exploration / Visibility (Fog of War)

> **Layer 2 — Specification (population stub).** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R/TBD. Details TBD — breadth pass.

**Overall confidence:** behavior `RECONSTRUCTED` from manual; **per-tile fog encoding
`BYTE_VERIFIED`** (separate per-power visibility layer, bit `player+4`); **sight
radius per unit type `BYTE_VERIFIED`** (`func_006608`).
**Canonical primary:** `docs/GAME_MANUAL.md` (visibility / discovery rules);
`data_extracted/text/GAME_sections.json` (scout/rumor messages).

## 1. Purpose & behavior
The map starts hidden. The player only sees the area immediately around their
starting ship; native tribes and other European powers stay hidden until met
directly. Moving and exploring reveals more of the world, and **once revealed an
area remains visible for the rest of the game** (`docs/GAME_MANUAL.md`).
RECONSTRUCTED: persistent reveal (no re-fogging), per-tile "discovered" state.

## 2. State & data
- **Per-tile fog — BYTE_VERIFIED (2026-06-19):** visibility is a **separate map
  layer** (far-ptr `[0x168]`, the 4th layer; cross-ref `colonization-memory-map (1).md`
  "visibility layer"), **not** the `.MP` terrain bit 7. Each tile byte holds **one
  bit per power**: bit `player + 4` = explored-by-player. The renderer builds the
  test mask `1 << (player+4)` at `[0xA89E]` (`func_0685DC @0x685F2`) and a tile is
  drawn fogged when `fog_byte & mask == 0` (`func_0681A8 @0x681E0`). So player 0 =
  bit `0x10` … player 3 = bit `0x80` (the runtime dump's "`0x80` = explored" is the
  player-3 case). Persistent reveal = the bit is sticky once set.
- **Visibility radius per unit type — BYTE_VERIFIED (2026-06-20):** the reveal
  chain is `func_006608 @0x6608` (radius selector) → `func_0065C4 @0x65C4`
  (water-flag + setup) → `func_006468 @0x6468` (square loop) → `func_00631A
  @0x631A` (single-tile OR `1<<(player+4)` into the fog layer). The reveal area is
  a **(2R+1)×(2R+1) square** centred on the unit (`func_006468` double-loops
  `dy,dx = −R..+R`, `@0x649F`/`@0x65A7`). Radius `R` from `func_006608`:
  | Default sight | `R` (`di`) | site |
  |---|---|---|
  | Normal land unit | **1** (3×3) | `@0x6610 di=1` |
  | Scout (type 5) | **2** (5×5) | `@0x665E di+=1` |
  | Galleon/Privateer/Frigate (type 0x0F/0x10/0x11) | **2** (5×5) | `@0x6619..0x662E` |
  | Any naval (0x0D..0x12) **if** owner has ability #7 | **2** (5×5) | `@0x6631 lcall 0x981:0 (7,owner); @0x6643` |
  | Other ships (Caravel/Merchantman/Man-O-War) w/o ability #7 | **1** (3×3) | default |
  `func_0065C4` also derives a **naval/water reveal flag** (type ∈ 0x0D..0x12,
  passed as `[bp+4]`) governing *which* tiles are eligible, distinct from `R`.
  The ability-#7 test is `lcall 0x981:0 (7, owner)` — the **has-father helper**
  (`func_00BC10`) checking the power's owned-FF bitmask. **Father id 7 = Hernando
  de Soto** (`@FATHERS` order, index = father id — confirmed this session for
  Fugger 1 / Magellan 5 / Drake 13 / Penn 21). His manual effect is exactly
  **extended line of sight + all Lost-City rumors positive** — so the +1 naval
  sight here is **de Soto's sight bonus**, **BYTE_VERIFIED** in mechanism. (The
  land-unit reach of de Soto's bonus, if any, is applied elsewhere; this site only
  grants the naval +1.) NOTE `func_0063B6 @0x63B6` is a **separate** ±5 (11×11) colony/
  settlement-centred reveal (stride-0xCA record table `0x5D46`), not unit sight.
- Scout-related message keys (`GAME_sections.json`, BYTE_VERIFIED strings):
  `@LOSTOURSCOUTS`, `@LOSTTHEIRSCOUTS`, `@SCOUTCOLONY` — used by scout interactions.

## 3. Formulas & rules
- **Sight radius / area revealed each step — BYTE_VERIFIED:** see §2 (`func_006608`
  → `func_006468`, `(2R+1)²` square; R=1 land / R=2 scout & big ships / R=2 any
  naval with ability #7). No terrain (hill/mountain) sight extension is applied —
  the radius is purely unit-type-driven. **B.**
- Scout & Seasoned Scout bonuses: **B that they gate rumor outcomes** — the Lost-City handler `func_061454` tests `unit_type==5` (Scout) and class `+0x15==0x16` (Seasoned Scout) (`events.md` §3). Numeric magnitude of the bonus **TBD**.
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
- `func_006608` (file `0x6608`) — sight-radius selector (R=1 default, R=2 scout/big
  ships/ability-#7 naval); `func_006468` (`0x6468`) `(2R+1)²` reveal loop; `func_00631A`
  (`0x631A`) single-tile fog OR `1<<(player+4)`. **B**.

## 6. Open questions (TBD)
1. ~~Confirm the per-tile discovered flag location.~~ **Done** — separate
   visibility layer (far-ptr `[0x168]`), bit `player+4` (§2). **B.**
2. ~~Sight radius by unit type; whether terrain extends sight.~~ **Done 2026-06-20**
   — `func_006608` radius table (§2/§3); no terrain extension. **B.** The
   **ability/FF #7 granting naval +1 sight = Hernando de Soto** (has-father
   helper `func_00BC10`, `@FATHERS` id 7). Residual: where de Soto's bonus
   reaches **land** units (this site is naval-only).
3. Whether other powers' positions reveal on contact only, or via shared exploration.
4. Trace scout-bonus arithmetic out of `func_05A20E`.
