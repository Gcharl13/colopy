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
- **Scout & Seasoned-Scout Lost-City bonus — BYTE_VERIFIED magnitude (2026-06-20).**
  `func_061454` builds a **scout level 0..3**: +1 if `unit_type==5` (Scout), +1 if
  class `+0x315B==0x16` (Seasoned/Expert Scout), +1 if owner has **de Soto** (FF 7,
  `@0x614C6`; de Soto also forces a positive-outcome reroll `[bp-0x2e]:=1`). The
  outcome **magnitude roll** is biased **`+scout_level·10`** (`@0x6151D`:
  `random_int(1,100) + scout_level·10`), so scouts add **+10/+20/+30**; and the
  **bad-outcome escape** (outcomes 5/8) rerolls via `random_int(1, scout_level+1)`,
  so higher level dodges danger more often. **B.**
- **Scout "infiltrate colony" interaction** — `func_05A20E` (file `0x5A20E`).
  **BYTE_VERIFIED (2026-06-20): a 4-option `@SCOUTCOLONY` dialog** (string `0x1A64`),
  result in `[bp-6]`:
  1. **Meet With Mayor** — **blocked during the revolution** (`test [0x5382],1` →
     `@NOMAYORSDURINGREV` `@0x5A281`); else parley.
  2. **Infiltrate Colony** (`@0x5A2DC`) — success roll `random_int(1,36) ≤ (X+6)·2`,
     **halved for a Seasoned Scout** (class `0x16`, `sar [bp-4],1` `@0x5A2F2`; `+
     (diff−2)` vs a human target). Success reveals colony info + bumps the target
     colony `+0xAA` by 100; **failure → the scout is caught/lost** (`@0x5A3EA`).
  3. **Attack Colony** → `func_05A40E`; this path holds the **Jan de Witt** (FF 4)
     gate `@0x5A469` (full vs limited foreign-colony info).
  4. **Nothing** — no action. **B** (was mislabeled "3 options").
- Lost-City rumor squares: see `spec/systems/events.md`.

## 4. UI
Hidden tiles render as "Unexplored" (`@OTHER_NAMES` last entry, NAMES — **B** that
the label exists). Viewport redraw via map render chain `func_O514 → O513 → O512`.
Layout `TBD`.

## 5. Evidence
- `docs/GAME_MANUAL.md` — fog/discovery, permanent reveal, scout abilities. **R**
- `formats/MP_FORMAT.md` — tile-byte bit 7 (unconfirmed discovered flag). **TBD**
- `data_extracted/text/GAME_sections.json` — @LOSTOURSCOUTS/@SCOUTCOLONY. **B** (strings).
- `func_05A20E` (file `0x5A20E`) — scout infiltrate-colony: `@SCOUTCOLONY` **4-option** dialog (Meet Mayor / Infiltrate / Attack / Nothing); Meet Mayor blocked post-independence (`@NOMAYORSDURINGREV`); Infiltrate roll `random_int(1,36)≤(X+6)·2` (Seasoned-halved); Attack → `func_05A40E` (de Witt gate `@0x5A469`). **B** (option semantics resolved §3).
- `func_006608` (file `0x6608`) — sight-radius selector (R=1 default, R=2 scout/big
  ships/ability-#7 naval); `func_006468` (`0x6468`) `(2R+1)²` reveal loop; `func_00631A`
  (`0x631A`) single-tile fog OR `1<<(player+4)`. **B**.

## 6. Open questions (TBD)
1. ~~Confirm the per-tile discovered flag location.~~ **Done** — separate
   visibility layer (far-ptr `[0x168]`), bit `player+4` (§2). **B.**
2. ~~Sight radius by unit type; whether terrain extends sight; de Soto's reach.~~
   **Done 2026-06-20** — `func_006608` radius table (§2/§3); no terrain extension.
   **B.** **ability/FF #7 = Hernando de Soto** (has-father helper `func_00BC10`,
   `@FATHERS` id 7), and the de Soto bonus is **naval-only**: the `has_father(7)`
   branch boosts R only for types `0xD..0x12` (`@0x6647..0x6658`); land units get
   R=1 (Scout R=2) regardless. So this build **does not** extend de Soto's sight to
   land units (a divergence from the manual's "all units"). `func_006608` is the
   sole radius selector. **Resolved.**
3. ~~Whether other powers' positions reveal on contact only, or via shared exploration.~~
   **Resolved 2026-06-20 — per-player, no shared exploration.** Each player owns an
   **independent fog bit `1 << (player+4)`** in the tile's visibility byte (§2); a tile
   is visible to player *p* iff *that* bit is set, which only *p*'s own units set. So a
   rival's units/colonies are seen **only when they lie within your own revealed/visible
   tiles** (line-of-sight/contact), never via shared sight. **B** (follows from the
   per-player fog mechanism).
4. ~~Trace scout-bonus arithmetic (`func_05A20E` / `func_061454`).~~ **Done 2026-06-20**
   — Lost-City magnitude `+scout_level·10` (level 0..3 = type5 +1 / Seasoned +1 /
   de Soto +1) and bad-outcome reroll `random_int(1,level+1)`; infiltrate roll
   `random_int(1,36)≤(X+6)·2` Seasoned-halved (§3). **B.**
