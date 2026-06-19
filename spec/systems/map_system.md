# Map System & Terrain

> **Layer 2 — Specification (population stub).** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R/TBD. Details TBD — breadth pass.

**Overall confidence:** terrain tables + `.MP` layout + auto-forest rule
`BYTE_VERIFIED`; per-yield semantics partly `RECONSTRUCTED`.
**Canonical primary:** `data_extracted/text/NAMES_sections.json`
(@UNFORESTED/@FORESTED/@OTHER/@OTHER_NAMES/@RESOURCE), `formats/MP_FORMAT.md`,
auto-forest `func_006204` (file `0x6204`).

## 1. Purpose & behavior
The world is a grid of terrain tiles; each tile has a base terrain type, optional
river and forest overlays, and may carry a special resource. Terrain determines
economic yields, movement cost, and combat modifiers (`docs/GAME_MANUAL.md`).

## 2. State & data
**`.MP` file layout** (`formats/MP_FORMAT.md`, BYTE_VERIFIED):
- Header: `width:word`, `height:word` (AMER2 = 56 × 70).
- Tile data: width × height bytes, row-major (y outer, x inner). Per byte:
  bits 0–4 = terrain id (0..27); bit 5 = river overlay; bit 6 = forest/special
  overlay; bit 7 = ? (possibly "discovered").
- Then ColonyRecord / UnitRecord / NativeSettlement arrays.

**Runtime map layers** (`colonization-memory-map (1).md`, **RUNTIME-VERIFIED**; live
play board is **56 × 72**, row-major `tile = y·56 + x`, 4032 bytes/layer):
- **Features/Rumors layer** — per-tile special-attribute byte: `0x00` = none,
  **`0xB0` (176) = Lost-City / Rumors-of-treasure marker**. Stepping a unit onto a
  `0xB0` tile fires the rumor event and **clears the tile to `0x00`** (plant/remove
  **write-verified**). This is the Lost-City **trigger** (see `spec/systems/events.md`).
- **Visibility layer** (= features + 0x1B80): per-power fog, `0x00` unexplored /
  `0x80` explored. **RUNTIME-VERIFIED** (read).

**Terrain id authority = `NAMES.TXT` (`$TERRAIN`), NOT `mapedit.c`** (CLAUDE.md hard rule 1).
- `@UNFORESTED` (ids ~0..7): Tundra, Desert, Plains, Prairie, Grassland, Savannah, Marsh, Swamp. **B**
- `@FORESTED` (forest variants): Boreal, Scrub, Mixed, Broadleaf, Conifer, Tropical, Wetland, Rain. **B**
- `@OTHER`: Arctic, Ocean, Sea Lane, Mountains, Hills. **B**
- `@OTHER_NAMES`: Forest, River, Major River, Minor River, Unexplored. **B**
- `@RESOURCE`: Depleted Mine, Oasis, Wheat, Prime Cotton/Tobacco/Sugar, Minerals,
  Fishery, Beaver, Game, Prime Timber, Silver Deposit, Ore Deposit (each w/ a value byte). **B**

**`$TERRAIN` row columns — BYTE_VERIFIED from the NAMES legend** (header comment
above `@UNFORESTED`, `raw/COLONIZE/NAMES.TXT`): each row is
`Name, Movement, Defensive, Improvement, Value, <9 yields>` where the 9 yields are
**Farmer→Food, Planter(s)→Sugar, Planter(t)→Tobacco, Planter(c)→Cotton,
Trapper→Furs, Lumberjack→Lumber, Ore-Miner→Ore, Silver-Miner→Silver,
Fisherman→Fish/Food**. (This resolves the prior "columns TBD".) The DGROUP terrain
table is `terrain·16`-strided; the 9 yields are read as `[terrain·16 + 0x2F7B + good]`
(`compute_terrain_yield`), and the **Defensive** value feeds land combat
(`func_007D3E`, see `combat.md`). **B** (legend) — the in-memory column order matches
the CSV order.

## 3. Formulas & rules
- **Auto-forest** (CLAUDE.md hard rule 3): read raw byte, mask `& 0x1F`, then
  forested variants occupy terrain ids **8..23** (`func_006204` / file `0x6204`,
  BYTE_VERIFIED; cross-cited `docs/GAME_INDEX_TABLES.md:377`).
- **Sea-lane column** (hard rule 2): right-edge map column base terrain id = **26 (Ocean)**; never desert.
- **Rivers vs coast** (hard rule 4): `PHYS0.SS` rows `0x01`/`0x11` are rivers, not coast.
- Per-terrain yield/movement/defense numbers: **TBD** (NAMES columns not yet decoded).

## 4. UI
Tiles drawn by `func_O514 → func_O513 → func_O512` (CLAUDE.md hard rule 7;
`docs/COLONY_RENDER_CHAIN.md`). Terrain-info popup on `[F1]` (manual). Layout `TBD`.

## 5. Evidence
- `data_extracted/text/NAMES_sections.json` — @UNFORESTED/@FORESTED/@OTHER/@OTHER_NAMES/@RESOURCE. **B**
- `formats/MP_FORMAT.md` — header + tile-byte bitfield + record arrays. **B**
- `docs/GAME_INDEX_TABLES.md:377` — auto-forest 8..23 at file 0x6204. **B**
- `docs/GAME_MANUAL.md` — terrain function, improvements, polar-ice bounds. **R**

## 6. Open questions (TBD)
1. Decode the per-terrain CSV columns in `@UNFORESTED/@FORESTED/@OTHER` (yield/move/defense).
2. Confirm bit 7 meaning of the tile byte; confirm record-array boundaries from the `.MP` read function.
3. Map `@RESOURCE` entries to the bonus they grant and to placement rules.
4. Terrain id 24/25/27 assignments (Arctic base, Mountains, Hills, Sea Lane=26) — confirm full 0..27 table.
