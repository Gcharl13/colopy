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
  `0xB0` (176) = high-nibble feature value (memory-dump observed). ⚠ **The
  "`0xB0` = Lost-City trigger marker, planted/cleared" model is SUPERSEDED** —
  `spec/systems/events.md` §6.1 (2026-06-21, EXE-verified) resolves rumor presence as
  **PROCEDURAL** (`func_006188 @0x6188` coordinate-hash vs a global map seed), *not* a
  stored `0xA0`/`0xB0` marker (a stored high-nibble would in fact **suppress** a rumor).
  Defer to `events.md` for the Lost-City **trigger**.
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
- **Sea-lane column** (hard rule 2): right-edge map column base terrain id = **26 (Sea Lane)**; never desert. (Ocean is **25** — see the `@OTHER` ordering at §282; the prior "26 (Ocean)" gloss was a label error, corrected 2026-06-23.)
- **Rivers vs coast** (hard rule 4): `PHYS0.SS` rows `0x01`/`0x11` are rivers, not coast.
- Per-terrain yield/movement/defense numbers: **now legend-mapped** (see §2; Defensive in `combat.md`).

### Coast + fog rendering — **CORRECTED 2026-06-22** (re-traced vs EXE; prior version wrong)
The tile-draw chain (hard rule 7) maps to: **`func_O514` = `func_0685DC`** (visible
row/col loop, `0x0685DC..0x068897`) → **`func_O513` = `func_0681A8`** (per-tile
terrain/feature/road/river/coast sprite **selector**, `0x0681A8..0x0685DB`) →
**`func_O512` = `func_067F50`** (sub-cell composer, `0x067F50..0x0681A7`).

#### O512 = the dithered terrain-edge BLEND composer — **DEEP-DIVE 2026-06-22 (byte-verified)**
O512 is **not** "just the coast" — it is the engine that **dithers every tile's edge into its 4
cardinal neighbours**, and the coast is one case of it. Full trace of `func_067F50`:

- **Loop the 4 cardinals** `[bp-4]=0..3` via the **4-dir tables** DGROUP `0xA8`(dx=`[0,1,0,-1]`)/
  `0xAE`(dy=`[-1,0,1,0]`) = **N,E,S,W** (`@0x68032`). For each neighbour cell:
  - in-bounds via `lcall 0x181F:0x302` (`is_xy_in_bounds`, `@0x68054`);
  - read neighbour terrain from layer `[0xA598]`, mask `&0x1F`, fold forest `<0x18 → &7`
    (`@0x67FC1`), then `lcall 0x181F:0x6AA` = **`classify_terrain`** → neighbour class `[bp-0x1C]`
    (`@0x67FDE`); fog/hidden flag `[bp-0xE]` from layer `[0xA59C]` & fog mask `[0xA89E]`.
- **Water-neighbour 8-ring walk** (`@0x6809A..0x6811E`, gated `nb_class∈{0x19,0x1A}` **and**
  `[bp+6]==0`): walk the neighbour's own ring via the **8-dir tables** `0xB4`/`0xBE`, **even
  indices only** (`test bl,1` skips diagonals, `@0x680E0`) = the neighbour's N/E/S/W; take the
  **first land** cell found (`read_terrain` `lcall 0x181F:0x72C` → `classify_terrain`) as the
  blend class `[bp-0x1C]`. This is what produces the **dithered beach** where land sits next to a
  water tile (the coast on the LAND side).
- **Skip** the edge when: neighbour is still water after the walk (`@0x68120`); or neighbour class
  == centre class (`[0xA8A2]` classified, `@0x68153`) with no fog. Otherwise →
- **DRAW the dithered blend** (`@0x68189`): `draw_subcell(0x69 + dir)` stamps the **dither stencil**
  (`0x69..0x6C` = sparse index-0 dot patterns, per-direction) into the **mask buffer `0x839E`**;
  then `emit_terrain_sprite(nb_class)` (`func_067EEC`) does a **masked blit** of the neighbour's
  terrain through `0x839E` (`lcall 0x181F:0x268`, or `:0x286` scaled when `[0x184]!=0`), at the
  sub-cell offset `[0x1EA4]/[0x1EA5]`. Net effect: the neighbour's terrain **bleeds into this
  tile's edge as a dither gradient** — the characteristic Col1 biome/coast transition.

**Two O512 call sites in O513** (args `[bp+4]=hidden, [bp+6]=disable-ring, [bp+8]`):
- **Fog path** (`@0x68244`, after the `0x95` draw): `O512(1, centre_water?1:0, 0)` — blends explored
  neighbours into a **fogged** tile's edge; ring-walk off for water centres.
- **Main path** (`@0x68315`): `O512(0, [bp-4], 0)` where `[bp-4]` = "centre is water". So **land
  centres run with the ring-walk ENABLED** (→ land-side coast dither); water centres run it off
  (their coast is O513's shore `0x96` + `0x97+pattern` + `0x6D` 8×8 quadrants, below).

**So the complete coast = O513 water-side (shore/edges/8×8) + O512 land-side dither (ring-walk) +
O512 biome dithering on every differing edge.** The "4–6 coast sprites" are only O513's water side;
the land-side beaches and all biome transitions come from O512's dither-mask blend. **B** (full chain
byte-traced; `classify_terrain`/`is_xy_in_bounds`/`read_terrain`/masked-blit are overlay `0x181F`
helpers, role inferred from call context).

> **Correction (2026-06-22, RULING):** the earlier "coast = base `0x95` + per-direction
> `0x69..0x6C`" was **wrong** — it was actually the **fog-of-war path**. `func_0681A8` draws
> **`0x95` (frame 149) ONLY on unexplored/fogged tiles**: `@0x68212 mov ax,0x95` is gated by
> `@0x6820c cmp [bp-8],0; je` where `[bp-8]` = the **hidden flag** set from the **fog mask
> `[0xA89E]`** + tile fog byte `[0xA8A0]` (`@0x681E0..0x681FE`; `[bp-8]=1` ⇒ unexplored). That
> branch then calls `func_067F50`, whose per-direction `0x69+dir` + `emit_terrain_sprite` draws are
> the **fog-edge blend** (partial neighbour terrain at the edge of explored area). `0x95`'s striped
> hatching resembles plow furrows — hence its "plow" look when mis-drawn on coasts. **`0x95` is the
> fog/unexplored sprite, not a coast base; `0x69..0x6C` are fog-edge (and selection-box) sprites,
> not coast.**

- **Real coast (visible-land path, `func_0681A8`):** after the base ground + forest, a tile with
  the **shore bit** (`[0xA89F] & 0x40`, `@0x6834F`) draws **shore base `0x96` (150)** (`@0x68356`);
  the **directional coast edges `0x97 + pattern` (151..153)** (`@0x6850D add ax,0x97`) are selected
  from the **4-cardinal connection bitmap `[0xA8A6]`** (pattern matches `&0xDD==0xC1` / `&0x77==0x07`
  / `&0x77==0x70` / `&0xDD==0x1C`, `@0x68479..0x684A8`), each followed by `emit_terrain_sprite`
  (`@0x68518`). Forest/hills overlays use the auto-forest rows `+0x21`/`+0x31`
  (`@0x6837F/0x68384`). Emission via `func_067DC8` (sub-cell place) + `func_067EEC`
  (`emit_terrain_sprite`).
- So **coasts are a render-time composition** on the *visible-land* side: shore base `0x96` +
  directional edges `0x97..0x99` chosen by the land/water connection bitmap. The exact
  pattern→`0x97..0x99` enumeration (`[0xA8A6]` cases above) is **TBD-precise** but the entry points
  are byte-cited. **B** (chain + frame roles); pattern table **R** (located, not fully enumerated).

**Per-tile layer dispatch (`func_0681A8` = O513) — BYTE_VERIFIED order.** O513 first
loads the tile + neighbours from the three layer far-ptrs `[0xA594]`/`[0xA598]`/`[0xA59C]`
into `[0xA89F]`/`[0xA8A1]`/`[0xA8A2]` (and a fog mask via `[0xA89E]`/`[0xA8A0]`,
`@0x681E0`). Then per tile:
1. **Hidden/fog tiles** → fog sprite `0x95` + the fog-edge composer (`call func_067F50`,
   `@0x68244`) — see the §3 correction. **(Not coast: `0x95` is the unexplored-tile
   sprite; the visible water-tile coast path is item 7.)**
2. **Base terrain** → `emit_ground_sprite` (`func_067E28`) with the terrain class
   `[0xA8A2]` (`@0x68285`/`@0x68301`).
3. **Auto-forest variant** (hard rule 3) → land class masked `& 7`, then the forested
   bands `8..0x0F` / `0x10..0x17` select the variant; fallback id `0x11` (`@0x682C0..0x68301`).
4. **Terrain-detail / variant overlay** → sprite base **`0x5A` (90) + variant index**
   from the position+terrain hash `func_0060A0` (`0x181F:0x718([0xA5A0],[0xA5A2])`,
   `@0x6829A`, drawn `@0x682B2`). `func_0060A0` is a shared util (14 callers): reads
   the terrain via `func_005CFE`, masks `& 0x3F`, applies the 8..0x17 forest-band
   check, and hashes tile `(x&3,y&3)` → a deterministic per-tile variant. *(No road
   layer is drawn in this chain — the band once labelled "roads" `0x6D` is the 8×8
   coast sub-tile set, item 7.)*
5. **Relief overlay** → mountains `0x21` / hills `0x31` / forest `0x41`, gated by tile
   bits (`@0x6837F`/`@0x68384`).
6. **Rivers (connectivity) — CORRECTED 2026-06-22 (was "river = `0x51..0x5E`"; those are ROADS).**
   The river draw is at **`@0x6838A`**, gated by **feature-layer bit `0x40`** (`[0xA8A1]`): it
   picks base **`0x01`** (feature bit `0x80` set) or **`0x11`** (clear, `@0x6839E/0x683A6`), adds
   a **4-cardinal** river-neighbour mask (`func_067B84`, `ax=0x40,dx=3`; bit order **N=8/S=4/W=2/E=1**;
   isolated → mask `0xf`, `@0x683BB`), and draws `base + mask` via `func_067DC8` (`@0x683C6`). These
   are the **BLUE river sprites `0x01..0x1F`** (pixel-verified blue water + green banks; CLAUDE.md
   hard rule #4), **not** `0x51`.
   **Roads** are the *separate* layer at **`@0x6842B`** (base **`0x51`** + 8-dir `func_067D54`,
   `ax=0xa`, gated `[0x18E]==0`) — pixel-verified BROWN (`0x51..0x58`); empty on new maps ("no
   roads in new maps"). **B** (both blocks byte-traced + frame colours pixel-confirmed); river
   major/minor base selector (feature bit `0x80`) **R** in a terrain-only reader.
7. **Coast (water-tile composition) — CORRECTED 2026-06-22 (was "roads = `0x6D`").**
   `func_067A24` = **`analyse_connections`** is called **only for water tiles**
   (terrain `0x19` Ocean / `0x1A` Sea-Lane, gated `@0x68256`). It builds `[0xA8A6]` =
   the **8-direction LAND-neighbour bitmap** (each neighbour's terrain read, **water
   neighbours `0x19/0x1A` skipped** `@0x67AA6`, so a bit is set only where a neighbour
   is land) plus a 4-entry per-quadrant diagonal/cardinal table at `[0x2D24]`. Then:
   - **shore base `0x96` (150)** when `[0xA89F] & 0x40` (`@0x68354/0x68356`);
   - if `[0xA8A6]` matches a **clean edge pattern** (`&0xDD==0xC1`→0 / `&0x77==0x07`→1 /
     `&0x77==0x70`→2 / `&0xDD==0x1C`→3, `@0x68479..0x684AA`) → one **16×16 edge
     `0x97 + pattern`** (151..153; pattern 3 would index 154 = past the 154-frame sheet
     — see TBD note) `@0x6850D`;
   - **else** (no clean pattern) → a **4-quadrant 8×8 sub-tile loop** (`@0x684BC..0x684F5`):
     for `q=0..3`, draw frame **`0x6D + table[q]·4 + q`** where `table[q]` (0..7) is the
     per-quadrant land bitmask built in `analyse_connections` (`@0x67AC7..0x67AEF`: diagonal
     land `|=2`, the two flanking cardinals `|=4`/`|=1`). The reachable frames are
     **`0x6D..0x8B` (109..139), all 8×8** (pixel-confirmed) — drawn at the quadrant sub-cell
     offset (TL/TR/BR/BL via `[0x1EA4]/[0x1EA5]`). Four 8×8 pieces tile the 16×16 cell — the
     **fine-grained complex-coastline** path. (The extreme `table[q]=7,q=3` combo would index
     `0x8C`=140, a 16×16 frame — an all-land-corner edge case, flagged TBD.)
   **There is no road draw in this chain** — the `0x6D` band is the 8×8 coast sub-tile
   set, gated by water terrain id + the land-neighbour bitmap, not a road bit (matches
   the user ground-truth "no roads in new maps"). **B** (chain + frame roles, sizes
   pixel-confirmed); the `[0xA8A6]`→`0x97..0x99` pattern table located, the pattern-3→154
   edge case **TBD**.

**Authoritative PHYS0 sprite-index bands (byte-verified vs `func_0681A8`/`func_067A24`):**
`0x21` mtn · `0x31` hills · `0x41` forest · `0x40` shore-feature · **`0x01..0x1F` river**
(base `0x01`/`0x11` + 4-card connectivity, BLUE — hard rule #4) · **`0x51..0x5E` roads**
(base `0x51` + connectivity, BROWN; separate layer, empty on new maps) · `0x5A`
terrain-detail centre (position hash) · `0x8D..0x94` feature
edges · **shore base `0x96`** + **coast edges `0x97..0x99`** (16×16, clean patterns) ·
**`0x6D..0x8B` = 8×8 coast sub-tile quadrants** (complex-coast fallback — **NOT roads**,
correction 2026-06-22) · **`0x95` = fog/unexplored tile** (hidden path, NOT coast —
correction 2026-06-22). Neighbour masks: `func_067A24` = `analyse_connections`
(water-tile land-neighbour bitmap `[0xA8A6]` + quadrant table `[0x2D24]`),
`func_067B84`/`067BE4` 4-card feature, `func_067C8E` forest edges, `func_067D54`
8-dir terrain. Drawn through `func_067DC8` (sub-cell place) / `func_067E28` (ground) /
`func_067EEC` (terrain).
> **Corrections:**
> - *(2026-06-19)* an earlier draft put "river = `0x96` on bit `0x40`" — wrong:
>   **shore base = `0x96`**, **coast edges `0x97..0x99`**.
> - *(2026-06-22)* a same-day draft then put **"river = `0x51..0x5E`"** — also wrong:
>   `0x51..0x5E` is the **ROAD** layer (BROWN, `@0x6842B`). **River = `0x01..0x1F`** (BLUE,
>   base `0x01`/`0x11` + 4-card connectivity `@0x6838A`; CLAUDE.md hard rule #4). See §3 item 6.
> - *(2026-06-22)* the "**roads = `0x6D`**" label was **also wrong** — re-traced vs EXE,
>   the `0x6D..0x8B` band is the **8×8 per-quadrant coast sub-tiles** drawn on water
>   tiles (the no-clean-edge fallback in `func_0681A8` `@0x684BC`), gated by the
>   land-neighbour bitmap `[0xA8A6]`, not by any road bit. There is **no road layer** in
>   this render chain. (`src/render/terrain.c`, a low-trust C reconstruction, is the
>   source of the stale "roads" wording — superseded by the disasm.)

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
- `func_067F50` (O512, fog-edge / sub-cell composer) / `func_0681A8` (O513, sprite selector) / `func_0685DC` (O514, row/col loop) — **coast band `0x96..0x99`** (visible path), **`0x95` = fog/unexplored sprite** (hidden path, §3 correction), water test id≥`0x18`, neighbour read via `[0xA598]`±`[0x8548]`. **B** (verified vs EXE).
- `func_064A10` (`map_generate_new_world`) — procedural generator (see `map_generation.md`). **B**
- `docs/GAME_MANUAL.md` — terrain function, improvements, polar-ice bounds. **R**

## 6. Open questions (TBD)
1. ~~Decode the per-terrain CSV columns.~~ **Done 2026-06-19** — `Movement, Defensive, Improvement, Value` + 9 yields (§2).
1b. **Coast vs fog rendering — CORRECTED 2026-06-22 (the 2026-06-21 "coast" entry was wrong; it
   described the FOG-OF-WAR path).** Re-traced vs EXE (capstone `func_0681A8`/`func_067F50`):
   - The `0x95` + per-direction `0x69..0x6C` draws are the **fog-of-war renderer**, NOT coast.
     `@0x68212 mov ax,0x95` is gated by `@0x6820c cmp [bp-8],0; je` where **`[bp-8]` = hidden flag**
     (set from the fog mask `[0xA89E]` + tile fog byte `[0xA8A0]`, `@0x681E0..0x681FE`;
     `[bp-8]=1` ⇒ unexplored). For a hidden tile it draws **`0x95` (fog/unexplored sprite, frame
     149 — striped, "plow"-looking)** then `func_067F50`, which loops the 4 cardinal directions
     (dx/dy at DGROUP `0xA8`/`0xAE`, `[bp-4]=0..3`) drawing `0x69+dir` (`@0x68189`) +
     `emit_terrain_sprite` (`@0x68197`) — the **fog-edge blend** showing partial explored
     neighbours at the fog boundary.
   - The **real coast** is the *visible water-tile* path: shore base **`0x96`** when
     `[0xA89F]&0x40` (`@0x6834F/0x68356`) + directional edges **`0x97+pattern` (151..153)**
     from the **land-neighbour bitmap `[0xA8A6]`** (`@0x6850D`, patterns `@0x68479..0x684A8`),
     each + `emit_terrain_sprite` (`@0x68518`). `[0xA8A6]` is built by `analyse_connections`
     (`func_067A24`), called **only** when the tile's own terrain is water (`0x19`/`0x1A`).
   - **Complex coastlines (no clean edge pattern) — RESOLVED 2026-06-22:** the fallback
     (`@0x684BC..0x684F5`) is a **4-quadrant 8×8 sub-tile loop** drawing **`0x6D + table[q]·4 + q`**
     (frames 109..139, all 8×8, pixel-confirmed) at TL/TR/BR/BL sub-cell offsets. This band was
     previously **mislabelled "roads = `0x6D`"** — it is the per-quadrant coast composition,
     gated by the same water-tile land-neighbour bitmap (no road bit). See §3 item 7. **B**
     (chain + frame roles + sizes); the `[0xA8A6]`→`0x97..0x99` pattern table located but the
     pattern-3→154-OOB case **TBD**.
2. **Tile-byte bit encoding — PARTIALLY RESOLVED 2026-06-20** (`func_006204` /
   `func_0624E`): low 5 bits (`& 0x1F`) = **base terrain id**; the forest decoder
   `func_006204` masks `& 0x1F` then applies the auto-forest map (ids 8..23 → `(id&7)|8`,
   per CLAUDE.md hard rule #3). In `func_0624E`, **bit `0x20` flags a special terrain**,
   and **bit `0x80` then selects id 27 vs 28** (`and 0x80; sbb; +0x1B`). Bit `0x80` *in
   isolation* (bit `0x20` clear) is **never observed** in shipped maps (PROJECT_BOARD
   AMB-6), so its standalone meaning stays TBD. **`.MP` record-array boundaries — DONE
   2026-06-21:** there are **no variable-length records**. The map body is **4 parallel
   byte-planes** (`g_map_layer[0..3]`), **each exactly `width×height` bytes** (`g_map_layer_bytes`,
   one byte/tile), written/read as four contiguous blocks (`for i<4: blk_write(g_map_layer[i],
   g_map_layer_bytes)` `@save 0x3342`; same in the loader). Plane `k` begins at
   `header + k·(w·h)`; within a plane each tile is one byte (low nibble terrain/owner, high
   nibble feature — confirmed via the tile reader `0x5D9C`/`0x5DF0`). So the "record
   boundaries" are simply the **layer strides `w·h`** — terrain plane + 3 overlay planes
   (feature, units-present, visibility), `w`=`[0x853A]`=56. **B.**
3. ~~Map `@RESOURCE` entries to the bonus they grant.~~ **Done 2026-06-20** — the
   NAMES.TXT legend names `@RESOURCE` *"Special resource squares & **values**"*: each
   resource's single column = the **production-bonus magnitude** for its associated good
   (Silver Deposit **12**, Prime Sugar **7**, Depleted Mine/Prime Cotton/Prime Tobacco/
   Beaver/Game/Prime Timber/Ore Deposit **6**, Fishery **5**, Wheat/Minerals **4**, Oasis
   **3**); the good is implied by name. **B** (primary legend). *Placement rules* (which
   terrain spawns which resource) live in the map-gen resource pass `func_063F3C`
   (`map_generation.md`) — remaining.
4. ~~Terrain id 24/25/27 assignments.~~ **Resolved 2026-06-20** (`notes/rulings/RULINGS.md`)
   — `@OTHER` order (B) + hard rule 2 (Sea Lane = 26) fix ids **24=Arctic,
   25=Ocean, 26=Sea Lane, 27=Mountains, 28=Hills**; corroborated by the random-map
   generator immediates (`0x18/0x19/0x1A`). `formats/MP_FORMAT.md` corrected (it
   was the outlier — had Arctic at 16, inside the auto-forest range).
5. ~~Auto-forest range 8..23 internal structure (16 slots vs ~8 variants).~~
   **Resolved 2026-06-20** — `func_006204 @0x6204` (`get_terrain_id_from_raw`) masks
   the raw byte `& 0x1F`, then (mode global `[0x18e]`) for any id in **8..23**
   normalizes to the **8 canonical forest ids 8..15** via `(id&7)|8` (`@0x6225`).
   So **16..23 are a *second* encoding of the same 8 forest variants** (16→8 …
   23→15), not distinct terrains — which is why the test range is 16 wide but only
   8 forest types exist. Modes: `[0x18e]==2` → normalize to forest 8..15;
   `[0x18e]==3` → **strip** to unforested base `id&7` (0..7) (`@0x6238`); default →
   raw masked id. (Also re-confirms **16 ≠ Arctic** — id 16 is a forest id folding
   to 8.) **B.**
