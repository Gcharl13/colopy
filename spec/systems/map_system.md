# Map System & Terrain

> **Layer 2 — Specification (population stub).** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R/TBD. Details TBD — breadth pass.

**Overall confidence:** terrain tables + `.MP` layout + auto-forest rule + **`$TERRAIN`
column legend + the tile-render chain & coast/beach-halo composer** `BYTE_VERIFIED`;
generator in `map_generation.md`.
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
- Per-terrain yield/movement/defense numbers: **now legend-mapped** (see §2; Defensive in `combat.md`).

### Coast / beach-halo rendering — **BYTE_VERIFIED** (2026-06-19, verified vs EXE)
The tile-draw chain (hard rule 7) maps to: **`func_O514` = `func_0685DC`** (visible
row/col loop, `0x0685DC..0x068897`) → **`func_O513` = `func_0681A8`** (per-tile
terrain/feature/road/river/coast sprite **selector**, `0x0681A8..0x0685DB`) →
**`func_O512` = `func_067F50`** (sub-cell **water/coast composer**, `0x067F50..0x0681A7`).

- **Water test (`func_067F50`):** a tile is water when its base id `≥ 0x18`
  (Arctic `0x18` / Ocean `0x19` / Sea-Lane `0x1A`) — `@0x67FD0 cmp al,0x18`; land
  ids (`< 0x18`) are masked `& 7` to the base type. Neighbours are read from the
  terrain layer far-ptr `[0xA598]`/`[0xA59C]` at offset `± 1` (horizontal) and
  `± map_stride [0x8548]` (vertical), and mapped to a water/land class via
  `0x181F:0x6AA` (`@0x67FDE`). The composer walks the **4 sub-cells** (`[bp-4]`),
  building per-edge flag bytes `[0xA89F]`/`[0xA8A1]`/`[0xA8A2]`.
- **Beach-halo sprites (`func_0681A8`)** — the coastal-edge band is **`0x95..0x99`
  (149..153)**, confirming hard rule 4: **base beach `0x95`** drawn when a water-edge
  flag is set (`@0x68212`), and **directional edge sprites `0x97 + edge_index`
  (151..153)** (`@0x6850D add ax,0x97`) selected by the composed edge code
  (`[0xA8A1] & 0xC0`, `@0x68206`). Forest/hills overlays use the separate auto-forest
  rows `+0x21`/`+0x31` (`@0x6837F/0x68384`). Emission is via `func_067DC8` (sub-cell
  placement) + `func_067EEC` (`emit_terrain_sprite`).
- So **coasts are a *render-time* composition**, not stored tiles: the composer
  reads each water tile's land-neighbour configuration and the selector stamps the
  matching beach edge(s) from the `0x95..0x99` band around it. The exact
  neighbour-config → which-of-`0x95..0x99` truth table is the bit logic in
  `func_067F50`/`func_0681A8` (located; full per-direction enumeration is intricate).

**Per-tile layer dispatch (`func_0681A8` = O513) — BYTE_VERIFIED order.** O513 first
loads the tile + neighbours from the three layer far-ptrs `[0xA594]`/`[0xA598]`/`[0xA59C]`
into `[0xA89F]`/`[0xA8A1]`/`[0xA8A2]` (and a fog mask via `[0xA89E]`/`[0xA8A0]`,
`@0x681E0`). Then per tile:
1. **Water/fog tiles** → beach base `0x95` + the coast composer (`call func_067F50`,
   `@0x68244`) — see above.
2. **Base terrain** → `emit_ground_sprite` (`func_067E28`) with the terrain class
   `[0xA8A2]` (`@0x68285`/`@0x68301`).
3. **Auto-forest variant** (hard rule 3) → land class masked `& 7`, then the forested
   bands `8..0x0F` / `0x10..0x17` select the variant; fallback id `0x11` (`@0x682C0..0x68301`).
4. **Terrain-detail / variant overlay** → sprite base **`0x5A` (90) + variant index**
   from the position+terrain hash `func_0060A0` (`0x181F:0x718([0xA5A0],[0xA5A2])`,
   `@0x6829A`, drawn `@0x682B2`). `func_0060A0` is a shared util (14 callers): reads
   the terrain via `func_005CFE`, masks `& 0x3F`, applies the 8..0x17 forest-band
   check, and hashes tile `(x&3,y&3)` → a deterministic per-tile variant. *(Not
   roads — roads are a separate layer drawn between tile centres, site `TBD`.)*
5. **Relief overlay** → mountains `0x21` / hills `0x31` / forest `0x41`, gated by tile
   bits (`@0x6837F`/`@0x68384`).
6. **Roads & rivers (connectivity-based)** → `func_067A24` = **`analyse_connections`**
   builds a 4-cardinal connection bitmap `[0xA8A6]` + per-direction table `[0x2D24]`
   (bits OR'd: N/E/S/W, `@0x67ACC/0x67AE8/0x67AEF`); the **road** sprite is base
   **`0x6D` + connectivity_mask** and the **river** sprite is the **`0x51..0x5E`** range
   by connectivity (drawn via `0x181F:0x32C`, "roads/rivers edges"). So a road/river
   tile picks the sprite matching which neighbours also carry road/river.
7. **Coast / shore** → single **shore `0x40`**, **feature edges `0x8D..0x94`**, and the
   **coast band `0x96..0x99`** (composer, above).

**Authoritative PHYS0 sprite-index bands (byte-grounded, `src/render/terrain.c`):**
`0x21` mtn · `0x31` hills · `0x41` forest · `0x40` shore · **`0x51..0x5E` river** ·
**`0x6D` roads** · `0x5A` terrain-detail centre (position hash) · `0x8D..0x94` feature
edges · **`0x96..0x99` coast**. Neighbour masks: `func_067A24` connections,
`func_067B84`/`067BE4` 4-card feature, `func_067C8E` forest edges, `func_067D54`
8-dir terrain. Drawn through `func_067DC8` (sub-cell place) / `func_067E28` (ground) /
`func_067EEC` (terrain).
> **Correction (2026-06-19):** an earlier draft put "river = `0x96` on bit `0x40`" —
> wrong. Per `terrain.c` (verified): **river = `0x51..0x5E`**, **roads = `0x6D`**,
> **shore = `0x40`**, and **`0x96..0x99` = coast**; roads/rivers are connectivity-
> selected, not a single bit→sprite.

**Viewport geometry (`func_0685DC` = O514) — BYTE_VERIFIED.** The outer loop walks
the visible tile rectangle from the **scroll origin `[0x8328]` (x) / `[0x832E]` (y)**
over the viewport span, clamped to the map extents `[0x8804]`/`[0x8806]`. Per tile it
computes the **linear index `(y+1)·stride[0x8548] + (x+1)`** (`@0x6868E`; the `+1`s
are the **1-tile border padding** that lets neighbour reads stay in-bounds), forms
far-pointers into the **4 layers** — `[0x15C]` terrain / `[0x160]` elevation /
`[0x164]` resource / `[0x168]` fog — at that index, and calls O513. The
**visibility/fog mask is `1 << (player+4)`** stored at `[0xA89E]` (`@0x685F2`): the
per-tile fog byte holds **one bit per power (bits 4–7)** — so explored-by-player-3 =
bit 7 = `0x80` (matches the runtime dump's "`0x80` = explored"). See `exploration.md`.

## 4. UI
Tiles drawn by `func_O514`(`0x0685DC`) `→ func_O513`(`0x0681A8`) `→ func_O512`(`0x067F50`)
(CLAUDE.md hard rule 7; see §3 Coast rendering). Terrain-info popup on `[F1]` (manual). Layout `TBD`.

## 5. Evidence
- `data_extracted/text/NAMES_sections.json` — @UNFORESTED/@FORESTED/@OTHER/@OTHER_NAMES/@RESOURCE. **B**
- `formats/MP_FORMAT.md` — header + tile-byte bitfield + record arrays. **B**
- `docs/GAME_INDEX_TABLES.md:377` — auto-forest 8..23 at file 0x6204. **B**
- `func_067F50` (O512, water/coast composer) / `func_0681A8` (O513, sprite selector) / `func_0685DC` (O514, row/col loop) — coast beach-halo band `0x95..0x99`, water test id≥`0x18`, neighbour read via `[0xA598]`±`[0x8548]`. **B** (verified vs EXE; cross-ref `viceroy_source/src/render/tile_chain.c`).
- `func_064A10` (`map_generate_new_world`) — procedural generator (see `map_generation.md`). **B**
- `docs/GAME_MANUAL.md` — terrain function, improvements, polar-ice bounds. **R**

## 6. Open questions (TBD)
1. ~~Decode the per-terrain CSV columns.~~ **Done 2026-06-19** — `Movement, Defensive, Improvement, Value` + 9 yields (§2).
1b. Coast beach-halo: the full neighbour-config → which-of-`0x95..0x99` sprite truth table in `func_067F50`/`func_0681A8` (chain + band byte-verified; per-direction enumeration intricate).
2. Confirm bit 7 meaning of the tile byte; confirm record-array boundaries from the `.MP` read function.
3. Map `@RESOURCE` entries to the bonus they grant and to placement rules.
4. ~~Terrain id 24/25/27 assignments.~~ **Resolved 2026-06-20** (`notes/rulings/RULINGS.md`)
   — `@OTHER` order (B) + hard rule 2 (Sea Lane = 26) fix ids **24=Arctic,
   25=Ocean, 26=Sea Lane, 27=Mountains, 28=Hills**; corroborated by the random-map
   generator immediates (`0x18/0x19/0x1A`). `formats/MP_FORMAT.md` corrected (it
   was the outlier — had Arctic at 16, inside the auto-forest range). Residual: the
   internal structure of the auto-forest range 8..23 (16 slots vs ~8 variants).
