## 5. Terrain system

Every square of the world map carries one of 29 terrain identifiers. The authoritative
source for terrain identity, ordering and per-terrain statistics is the `$TERRAIN` block
of the game's `NAMES.TXT` data file, which the engine parses at start-up into a
16-byte-stride record table in the data segment; the renderer, the yield calculator and
the combat engine all index that one table. This section gives the complete id space,
the data-file legend, the full per-terrain statistics, and the runtime record layout.

### 5.1 Terrain identifiers 0..28

The id is the low five bits of the stored terrain byte (`AND al,0x1F` at 0x620A).
Ids 8..23 are the forested variants of bases 0..7; ids 16..23 are a second encoding
of the same eight forest types (see §5.4).

| id | hex | Name | Notes |
|----|-----|------|-------|
| 0 | 0x00 | Tundra | base terrain |
| 1 | 0x01 | Desert | base terrain |
| 2 | 0x02 | Plains | base terrain |
| 3 | 0x03 | Prairie | base terrain |
| 4 | 0x04 | Grassland | base terrain |
| 5 | 0x05 | Savannah | base terrain |
| 6 | 0x06 | Marsh | base terrain |
| 7 | 0x07 | Swamp | base terrain |
| 8 | 0x08 | Boreal | forested Tundra |
| 9 | 0x09 | Scrub | forested Desert |
| 10 | 0x0A | Mixed | forested Plains |
| 11 | 0x0B | Broadleaf | forested Prairie |
| 12 | 0x0C | Conifer | forested Grassland |
| 13 | 0x0D | Tropical | forested Savannah |
| 14 | 0x0E | Wetland | forested Marsh |
| 15 | 0x0F | Rain | forested Swamp |
| 16–23 | 0x10–0x17 | (aliases) | second encoding of 8..15; fold `(id&7)|8` at 0x6225 |
| 24 | 0x18 | Arctic | |
| 25 | 0x19 | Ocean | water |
| 26 | 0x1A | Sea Lane | water; the right-edge map column is always Sea Lane (id 26, never 25) |
| 27 | 0x1B | Mountains | encoded as bit flags, not a stored id (§5.4) |
| 28 | 0x1C | Hills | encoded as bit flags, not a stored id (§5.4) |

The map loader enforces the border convention at load time (runtime-verified against
live memory): rows 0 and 71 are overwritten with Arctic (0x18), and columns 0, 1 and 57
with Sea Lane (0x1A) for y = 1..70, overwriting even land; forest alias ids 16..23 are
folded to 8..15 in the live plane.

### 5.2 The `$TERRAIN` column legend

The legend is stated in the header comment of the data file itself, directly above the
`@UNFORESTED` block, and the 14-column CSV rows match it exactly:

```text
a) Name
b) Movement, Defensive, Improvement, Value
c) Yield (Farmer, Planter(s), Planter(t), Planter(c),
          Trapper, Lumberjack, Ore Miner, Silver Miner, Fisherman)
```

The nine yield columns map to goods as follows (in-memory column order matches the CSV
order — the yield read is by good index, §5.5):

| yield column | worker | good produced |
|---|---|---|
| 1 | Farmer | Food |
| 2 | Planter(s) | Sugar |
| 3 | Planter(t) | Tobacco |
| 4 | Planter(c) | Cotton |
| 5 | Trapper | Furs |
| 6 | Lumberjack | Lumber |
| 7 | Ore Miner | Ore |
| 8 | Silver Miner | Silver |
| 9 | Fisherman | Fish (Food) |

### 5.3 Per-terrain data — the full 21 distinct rows

Transcribed verbatim from the extracted `@UNFORESTED` / `@FORESTED` / `@OTHER` blocks.
Columns: Mv = Movement, Df = Defensive, Im = Improvement, Vl = Value; then the nine
yields in legend order (Fa Su To Co Fu Lu Or Si Fi).

**Unforested bases (ids 0–7):**

| id | Name | Mv | Df | Im | Vl | Fa | Su | To | Co | Fu | Lu | Or | Si | Fi |
|----|------|----|----|----|----|----|----|----|----|----|----|----|----|----|
| 0 | Tundra | 1 | 0 | 4 | 2 | 2 | 0 | 0 | 0 | 0 | 0 | 2 | 0 | 0 |
| 1 | Desert | 1 | 0 | 3 | 2 | 1 | 0 | 0 | 1 | 0 | 0 | 2 | 0 | 0 |
| 2 | Plains | 1 | 0 | 3 | 4 | 4 | 0 | 0 | 2 | 0 | 0 | 1 | 0 | 0 |
| 3 | Prairie | 1 | 0 | 3 | 4 | 2 | 0 | 0 | 3 | 0 | 0 | 0 | 0 | 0 |
| 4 | Grassland | 1 | 0 | 3 | 4 | 2 | 0 | 3 | 0 | 0 | 0 | 0 | 0 | 0 |
| 5 | Savannah | 1 | 0 | 3 | 4 | 3 | 3 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| 6 | Marsh | 2 | 1 | 5 | 2 | 2 | 0 | 2 | 0 | 0 | 0 | 2 | 0 | 0 |
| 7 | Swamp | 2 | 1 | 7 | 2 | 2 | 2 | 0 | 0 | 0 | 0 | 2 | 0 | 0 |

**Forested variants (ids 8–15; ids 16–23 alias these):**

| id | Name | Mv | Df | Im | Vl | Fa | Su | To | Co | Fu | Lu | Or | Si | Fi |
|----|------|----|----|----|----|----|----|----|----|----|----|----|----|----|
| 8 | Boreal | 2 | 2 | 4 | 3 | 1 | 0 | 0 | 0 | 3 | 2 | 1 | 0 | 0 |
| 9 | Scrub | 1 | 2 | 4 | 1 | 1 | 0 | 0 | 1 | 2 | 1 | 1 | 0 | 0 |
| 10 | Mixed | 2 | 2 | 4 | 3 | 2 | 0 | 0 | 1 | 3 | 3 | 0 | 0 | 0 |
| 11 | Broadleaf | 2 | 2 | 4 | 3 | 1 | 0 | 0 | 1 | 2 | 2 | 0 | 0 | 0 |
| 12 | Conifer | 2 | 2 | 4 | 3 | 1 | 0 | 1 | 0 | 2 | 3 | 0 | 0 | 0 |
| 13 | Tropical | 2 | 2 | 6 | 3 | 2 | 1 | 0 | 0 | 2 | 2 | 0 | 0 | 0 |
| 14 | Wetland | 3 | 2 | 6 | 1 | 1 | 0 | 1 | 0 | 2 | 2 | 1 | 0 | 0 |
| 15 | Rain | 3 | 3 | 7 | 1 | 1 | 1 | 0 | 0 | 1 | 2 | 1 | 0 | 0 |

**Other terrains (ids 24–28):**

| id | Name | Mv | Df | Im | Vl | Fa | Su | To | Co | Fu | Lu | Or | Si | Fi |
|----|------|----|----|----|----|----|----|----|----|----|----|----|----|----|
| 24 | Arctic | 2 | 0 | 4 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| 25 | Ocean | 1 | 0 | 2 | 3 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 3 |
| 26 | Sea Lane | 1 | 0 | 2 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 3 |
| 27 | Mountains | 3 | 6 | 7 | 2 | 0 | 0 | 0 | 0 | 0 | 0 | 4 | 1 | 0 |
| 28 | Hills | 2 | 4 | 4 | 2 | 1 | 0 | 0 | 0 | 0 | 0 | 4 | 0 | 0 |

### 5.4 The auto-forest rule and the tile-byte encoding

The stored terrain byte is decoded by `get_terrain_id_from_raw` (`func_006204`, file
0x6204): read the byte, mask `AND 0x1F` (0x620A), then apply the auto-forest conversion.
Ids 8..23 form the forested band; for any id in that band the decoder (mode global
`[0x18E]` = 2) normalises to the eight canonical forest ids 8..15 via `(id & 7) | 8`
(0x6225) — so 16→8 … 23→15: ids 16..23 are a second encoding of the same eight forest
variants, not distinct terrains. Mode `[0x18E]` = 3 instead strips to the unforested
base `id & 7` (0x6238); the default mode returns the raw masked id.

The remaining bits of the terrain byte (per the map-file writer and `func_0624E`):
bit 5 (0x20) = relief present; bit 7 (0x80) then selects Mountains (set, id 27) versus
Hills (clear, id 28) — `AND 0x80; SBB; +0x1B` in `func_0624E`. Bit 6 (0x40) = river,
with bit 7 doubling as the Major (set) / Minor (clear) river selector on river tiles.
Bit 7 in isolation (bit 5 clear, bit 6 clear) never occurs in shipped maps and is inert.

### 5.5 The runtime terrain record table (DS:0x2F74, stride 16)

At start-up a loader (`func_0745F0`, byte-stream reads via the section reader) fills one
16-byte record per terrain at `DS:0x2F74 + terrain·16`: first a name-token word, then
the four `b)` columns as bytes, then the nine yield bytes.

```c
typedef struct {          // DS:0x2F74 + terrain*16, one record per terrain id
    uint16_t name;        // +0x00 name token (loaded 0x74607; title read [id*16+0x2F74] at 0x69DD1)
    uint8_t  movement;    // +0x02 Movement        (DS:0x2F76, loaded 0x7460D)
    uint8_t  defensive;   // +0x03 Defensive       (DS:0x2F77, combat read at 0x7E63)
    uint8_t  improvement; // +0x04 Improvement     (DS:0x2F78)
    uint8_t  value;       // +0x05 Value           (DS:0x2F79)
    uint8_t  yields[9];   // +0x07..+0x0F 9 yields (DS:0x2F7B+good, loop at 0x74633)
    // +0x06..+0x06 unmapped (1 byte)
} TerrainRecord;
```

The yield read is byte-verified in the colony production calculator at 0x9C15
(`func_009B9C`): `SHL si,4` (terrain·16), `bx` = good index, `MOV al,[bx+si+0x2F7B]` —
i.e. `yield = [terrain·16 + 0x2F7B + good]`. The Colonizopedia terrain pages title from
the same table (`[id·16 + 0x2F74]` at 0x69DD1, with a "(forest)" qualifier appended for
ids 8..15 at 0x69DF3), and the pedia's terrain category walks ids 0..0x1C skipping
0x10..0x18 (0x6B26E).

### 5.6 Terrain defence in combat: Defensive value × 25%

The defence-bonus filler `func_007D3E` reads the Defensive column at
`[terrain·16 + 0x2F77]` (0x7E63) for the defender's tile and accumulates it into the
defence-modifier chain. The Combat Analysis dialog (`func_05E9B0`) prints the terrain
row as **+ (Defensive × 25 %)** — the row is flagged "Terrain" for the defender
("Ambush" for the attacker), draws the target tile, and is skipped when the value is 0.
So the byte-verified per-terrain bonuses are: open land (Tundra/Desert/Plains/Prairie/
Grassland/Savannah) +0 %; Marsh/Swamp +25 %; forests +50 % (Rain +75 %); Hills +100 %;
Mountains +150 %; Arctic/Ocean/Sea Lane +0 %.

### 5.7 Special resources (`@RESOURCE`) and overlay names (`@OTHER_NAMES`)

The `@RESOURCE` block ("Special resource squares & values") lists each prime-resource
square with a single value byte — the production-bonus magnitude for the good implied
by its name. Transcribed verbatim (the data file carries the Prime Timber row twice):

| Resource | value | Resource | value |
|---|---|---|---|
| Depleted Mine | 6 | Beaver | 6 |
| Oasis | 3 | Game | 6 |
| Wheat | 4 | Prime Timber | 6 |
| Prime Cotton | 6 | Prime Timber | 6 |
| Prime Tobacco | 6 | Silver Deposit | 12 |
| Prime Sugar | 7 | Ore Deposit | 6 |
| Minerals | 4 | Fishery | 5 |

Prime-resource *presence* on a tile is procedural, not stored — it is the map
compositor's detail-band position hash (§6.9).

`@OTHER_NAMES` supplies the five overlay/UI names, in order: **Forest, River,
Major River, Minor River, Unexplored**.

## 6. The map compositor

Every visible map tile is composed at render time by a three-function chain: the
visible-rectangle loop `func_O514` (`func_0685DC`, file 0x685DC..0x68897) walks the
viewport; the per-tile selector `func_O513` (`func_0681A8`, 0x681A8..0x685DB) chooses
every sprite frame for one tile; and the sub-cell composer `func_O512` (`func_067F50`,
0x67F50..0x681A7) dithers each tile's edges into its neighbours. The whole chain below
is pixel-verified at 100.0000 % of non-overlay pixels against the running game (1994
binary under DOSBox), in three independent live tests: an all-water window (45,056 px),
a coastal land window (41,540 px), and five viewport captures of a crafted test map
exercising hills, rivers, river mouths, lakes and forest aliases.

**Frame-numbering convention (stated once, applies throughout):** all `0xNN` frame
constants in this chain are *engine* frame numbers, which are 1-based over the sprite
sheet's on-disk descriptors — disk sprite = engine frame − 1. (Proven by descriptor
counts: TERRAIN 12, WOODFRAM 1, NAMEPLAT 3, PHYS0 154, plus pixel renders.) PHYS0.SS
holds 154 disk frames (0..0x99); transparent pixels use palette index 0xFD.

### 6.1 O514 — the visible loop and per-tile addressing

`func_0685DC` walks the visible tile rectangle from the scroll origin `[0x8328]` (x) /
`[0x832E]` (y) over the viewport span, clamped to the map extents `[0x8804]`/`[0x8806]`.
Per tile it computes the linear index `(y+1)·stride[0x8548] + (x+1)` (0x6868E) — the
+1s are the 1-tile border padding that keeps neighbour reads in-bounds — forms
far-pointers into the four map planes (`[0x15C]` terrain, `[0x160]` feature, `[0x164]`
continent/owner, `[0x168]` flags; §7.1) at that index, sets the tile's screen anchor
(centre-x `[0xA5A4] = col·16 + 8` at 0x6875F, baseline-y `[0xA5A6] = (row+1)·16 − 1` at
0x68720), and calls O513. The fog mask `[0xA89E] = 1 << (player+4)` is latched at
0x685F2 (§7.2).

O513 first latches the tile bytes: `[0xA89F]` = feature byte (from `[0xA594]`),
`[0xA8A1]` = terrain byte (from `[0xA598]`), `[0xA8A2]` = classified terrain id, and the
tile fog byte `[0xA8A0]` (from `[0xA59C]`), at 0x681E0; world coordinates are
`[0xA5A0]`/`[0xA5A2]` (engine scroll-space = plane index − 1). All drawing lands in the
16×16 per-tile composite buffer at near-pointer 0x839E, which is then blitted to screen.

### 6.2 Ground tiles — the 12-frame TERRAIN.SS sheet

TERRAIN.SS is the base-ground sheet (loaded at boot and on map-enter), composited
*under* every PHYS0.SS overlay. `emit_ground_sprite` (`func_067E28`) blits from the
sheet pointer `[0x16C:0x16E]` (plain 16-px blit thunk when zoom = 0, 0x67E3A). The
sheet has exactly 12 frames; the ground-frame normaliser (`func_003436`) maps the
classified id to a disk frame:

```text
class 0..7            -> frames 0..7   (the eight unforested bases)
class 9 or 0x11       -> frame 8       (Scrub cactus ground)
class 0x18 Arctic     -> frame 9       (class >= 8: frame = class - 0xF)
class 0x19 Ocean      -> frame 10
class 0x1A Sea Lane   -> frame 11
```

O513's ground-id selection (0x682C0..0x68301): with `c = [0xA8A2]`, fold
`c & 7` for `c < 0x18`; a forested tile grounds with its unforested base, *except*
Scrub (`folded == 1`), which grounds via the fallback id 0x11 → cactus frame 8. The
Ocean/Sea-Lane split (frames 10/11) is visible on screen and pixel-confirmed.

### 6.3 O513 draw order and the sprite-frame assignment map

The per-tile draw order on the visible path, with the PHYS0 engine-frame bands:

| step | overlay | engine frames | gate / selector | site |
|---|---|---|---|---|
| 1 | fog tile + fog edges | 0x95; 0x69+dir | hidden flag (§6.11) | 0x68212, 0x68244 |
| 2 | base ground | TERRAIN 1..12 | normaliser §6.2 | 0x68285 / 0x68301 |
| 3 | open-water early out | — | water, 0 land neighbours: ground + detail + O512, return | 0x68274 |
| 4 | O512 edge blend | 0x69..0x6C stencils | every differing edge (§6.11) | 0x68315 |
| 5 | forest | 0x41 + mask4 | forested, not Scrub | 0x6833D |
| 6 | shore hatch | 0x96 | feature byte & 0x40 | 0x6834F |
| 7 | relief | 0x21 / 0x31 + mask4 | terrain byte & 0x20 (§6.5) | 0x6835C |
| 8 | rivers | 0x01 / 0x11 + mask4 | terrain byte & 0x40 (§6.6) | 0x6838A |
| 9 | detail band | 0x5A + value | position hash (§6.9) | 0x682B2 / 0x683F7 / 0x685D6 |
| 10 | surf/rumor | 0x68 | rumor hash (§6.10) | 0x68405..0x68414 |
| 11 | roads | 0x51; 0x52+d | feature byte & 0x0A (§6.8) | 0x68417 |
| 12 | coast edges | 0x97..0x9A | water tile, clean pattern (§6.7) | 0x6850D |
| 13 | coast quadrants | 0x6D..0x8C | water tile, no clean pattern (§6.7) | 0x684BC..0x684F5 |
| 14 | river mouths | 0x8D..0x90 / 0x91..0x94 | water tile, own bits & 0xC0 (§6.6) | 0x68524..0x685AC |

Rows 5–11 run on land tiles; rows 12–14 on water tiles. There is no other road or coast
band: the 0x6D band is coast sub-tiles (not roads) and 0x95 is the unexplored tile (not
a coast base).

### 6.4 Forest overlay — 0x41 + connection mask

Frame = `0x41 + mask`, where the 4-cardinal mask (`func_067C8E`) sets weights
**N=8, S=4, W=2, E=1** for each neighbour that connects. A neighbour connects
(`func_067C54`) iff its masked id is in the forest band 8..0x17 **and** `(id & 7) ≠ 1`
— **desert Scrub never connects** (and a Scrub centre draws no forest overlay at all;
its trees are the cactus ground frame). Live-confirmed: a Boreal|Scrub pair renders
Boreal with the isolated mask and Scrub with no overlay.

### 6.5 Mountains and hills — 0x21 / 0x31 + mask

Gated by terrain-byte bit 0x20 on non-water tiles: bit 0x80 set → Mountains, base
0x21; clear → Hills, base 0x31. The 4-cardinal adjacency mask (`func_067BE4`, weights
N=8/S=4/W=2/E=1) counts a neighbour iff its terrain byte satisfies
`(byte & 0xA0) == (own & 0xA0)` — **hills never connect to mountains** and vice versa
(live-confirmed both ways: each renders its isolated frame beside the other).

### 6.6 Rivers and river mouths

**Rivers** (draw at 0x6838A, land tiles): base = **0x01** when terrain-byte bit 0x80 is
set (Major River) else **0x11** (Minor River) (0x6839E/0x683A6); add the 4-cardinal
mask from `func_067B84` (terrain-plane bit 0x40, weights N=8/S=4/W=2/E=1); an isolated
river (mask 0) is forced to mask **0xF** (0x683BB) and drawn `base + mask` (0x683C6).
Because the mask tests only bit 0x40, **major and minor rivers interconnect** (a minor
river joins an adjacent major run), and a land river beside plain ocean counts no
connection there (it renders isolated) — both live-confirmed.

**River mouths** (water tiles, 0x68524..0x685AC): a *water* tile carrying its own
river bits (`terrain & 0xC0`, latched at 0x68206 before the beach-halo substitution)
draws base = **0x8D** if its bit 0x80 is set (major) else **0x91** (0x68524:
`AND 0x80; CMP 1; SBB; AND 4; ADD 0x8D`), then for each cardinal d = 0..3 (N,E,S,W)
draws `base + d` for every neighbour whose terrain byte has bit 0x40 **and** classifies
as non-water. Negative controls confirmed live: ocean with river bits but no land-river
neighbour draws nothing; plain ocean beside a land river draws no mouth.

### 6.7 Coast — beach halo, clean edges, quadrant fallback

`analyse_connections` (`func_067A24`) runs **only for water tiles** (gate 0x68256). It
builds the 8-direction land-neighbour bitmap `[0xA8A6]` (bit d = land, order 0=N, 1=NE,
2=E, 3=SE, 4=S, 5=SW, 6=W, 7=NW; water neighbours 0x19/0x1A skipped) plus a 4-entry
per-quadrant code table.

**Beach-halo ground substitution** (0x67AD4): while walking the cardinals, the routine
*overwrites* `[0xA8A1]` with the folded class of the last cardinal land neighbour seen
(visit order N,E,S,W — **W wins**), and reclassifies `[0xA8A2]` (0x67B10). O513
therefore grounds a coastal water tile with the *neighbour's land terrain*, draws the
coast frames over it, and finally backfills water through the frames' 0-index holes
(`func_067EEC` masked fill). The code-0 quadrant frames (disk 0x6C–0x6F) are all-zero
"punch-throughs" that exist precisely to punch water through the substituted ground.

**Clean edges** (0x68474..0x6850D): default pattern −1, then four tests on `[0xA8A6]`
assign the pattern and the draw is `0x97 + pattern`:

| pattern | mask test | frame | edge |
|---|---|---|---|
| 0 | `& 0xDD == 0xC1` | 0x97 | NW land corner |
| 1 | `& 0x77 == 0x07` | 0x98 | NE land corner |
| 2 | `& 0x77 == 0x70` | 0x99 | SW land corner |
| 3 | `& 0xDD == 0x1C` | 0x9A | SE land corner |

All four are drawable (engine 0x97..0x9A = disk 150..153, the 16×16 shoreline edges);
a 2×2 lake exercises all four, pixel-exact.

**Quadrant fallback** (no clean pattern, 0x684BC..0x684F5): for q = 0..3
(TL, TR, BR, BL) draw the 8×8 frame **`0x6D + code[q]·4 + q`** at the quadrant's
sub-cell offset. The quadrant code (built at 0x67ABD..0x67AEF) ORs, per quadrant:
**|=4** for its own cardinal (N,E,S,W for q0..q3), **|=1** for the next-clockwise
cardinal, **|=2** for its diagonal — maximum 7. All four quadrants draw
unconditionally (code 0 ⇒ frame `0x6D + q`, the punch-throughs) for any water tile
with ≥1 land neighbour that escapes the clean patterns. The reachable band is
0x6D..0x8C, all 8×8; a single-tile lake yields codes 7,7,7,7 → frames
0x89/0x8A/0x8B/0x8C, pixel-exact.

### 6.8 Roads — 0x51, then one frame per direction

Draw at 0x68417, gated: feature byte & 0x0A, mode `[0x18E]` == 0, non-water. The 8-dir
mask comes from `func_067D54` over the feature plane (bits 0x0A). **Mask 0 → the single
isolated frame 0x51; otherwise ONE FRAME PER SET BIT, `0x52 + d`** for each set
direction d (0=N, 1=NE, … 7=NW) — *not* a combined-mask frame. The road band is
0x51..0x59 only. (Byte-decoded; road pixels are not reachable from crafted map files
because the loader discards the feature plane — §7.1.)

### 6.9 The detail band 0x5A — the position hash IS prime resources

Sites 0x682B2 (open water), 0x683F7 (land), 0x685D6 (coast water), each gated
`[0x18A] == 0` (suppressed in the colony scene panel). The hash (`func_0060A0`, with
salt word `[0x190]`; salt 0 disables the band):

```text
v = (x & 3)*4 + (y & 3)
h = ((y >> 2)*3 + (x >> 2) + salt - forest) & 0xF     ; forest = 1 for ids 8..0x17
draw 0x5A + DTAB[class]   iff  h == v  or  (h ^ 0xA) == v
```

`class` uses the **full id decode including the relief bits → 27/28** (`func_0624E`
semantics; the plain `& 0x1F` reading was falsified by live pixels — mountains draw
the ore/gold sprite 0x66 = 0x5A+DTAB[27], hills the rock 0x67 = 0x5A+DTAB[28]).
The per-class table DTAB is the word array at **DS:0x192** (29 entries; runtime-read
from the live game, pixel-verified):
`[0,1,2,3,4,5,6,6, 9,1,8,9,10,10,6,6, <dup of 8..15 for raw 16..23>, −1 (Arctic),
7 (Ocean), −1 (Sea Lane), 12 (Mountains), 13 (Hills)]`; entry −1 = no detail, entry
value 0 is replaced by 6. Feature-plane bit 0x04 suppresses the detail unless the table
value is 12 (then `0x5A + 0`); tiles owned by a village (feature bit 2 with
continent-plane owner ≥ 4) draw none.

**This hash is the prime-resource mechanism**: a hash-hit tile is what the sidebar
reports as e.g. "(Prime Tobacco)" — procedural, never stored in the map
(live-corroborated).

### 6.10 Surf / rumor circle — 0x68

Frame 0x68 is the rumor circle, drawn on the land path after the detail band
(0x68405..0x68414) when the rumor hash (`func_006188`) hits:

```text
((y >> 2)*0x13 + (x >> 2)*0x11 + salt + 8) & 0x1F) - ((x & 3)*4) == (y & 3)
```

Suppressed for classes 0x18/0x19/0x1A and — the live-verified owner gate
(`func_005DF0` family) — whenever the continent-plane **owner nibble ≠ 0xF** (so land
claimed by a village never shows a rumor circle).

### 6.11 Unexplored tiles and the O512 edge/fog blends

A hidden tile (hidden flag `[bp-8]` from fog mask `[0xA89E]` + tile fog byte
`[0xA8A0]`, 0x681E0..0x681FE, tested at 0x6820C) draws **frame 0x95 — the
fog/unexplored tile** (0x68212), then calls O512 for the fog-edge blend. 0x95 is *not*
a coast sprite, and 0x69..0x6C are fog-edge/blend stencils, not coast.

**O512 (`func_067F50`)** loops the 4 cardinals (dx `[0,1,0,−1]` / dy `[−1,0,1,0]` =
N,E,S,W, tables at DGROUP 0xA8/0xAE). Per neighbour: bounds test (engine coordinate 0
IS in bounds — plane column 1; upper bound engine width−2), read + fold its terrain,
classify, read its fog state. **Water-neighbour ring-walk** (enabled only when arg2
= 0): walk the neighbour's own 8-ring counting *down* — even (cardinal) indices only,
order **W → S → E → N — first non-water wins** — and use that land class as the blend
class; this produces the land-side dithered beach. Skip the edge when the neighbour is
still water after the walk, or when neighbour class == centre class with the neighbour
visible. Otherwise draw `0x69 + dir` — a sparse index-0 dot stencil (disk 0x68..0x6B =
N,E,S,W) stamped into the mask buffer 0x839E — then masked-blit the neighbour's
terrain through it (`emit_terrain_sprite`, `func_067EEC`; plain thunk, or the scaled
variant when `[0x184] ≠ 0`). Net effect: the neighbour's terrain bleeds into this
tile's edge as a dither gradient — every biome transition, the coast's land side, and
the fog boundary all come from this one composer.

**The two O512 call sites in O513** (args: hidden, disable-ring, third 0):
- fog path 0x68244, after the 0x95 draw: `O512(1, centre_is_water, 0)` — blends
  explored neighbours into a fogged tile's edge;
- main path 0x68315: `O512(0, centre_is_water, 0)` — so land centres run with the
  ring-walk enabled (beach dither), water centres with it off (their coast is the §6.7
  composition).

### 6.12 Zoom scaling

The zoom level `[0x184]` runs 0..3. Viewport setup (`func_06787C`): span
`[0x8544] = 15 << zoom`, `[0x8546] = 12 << zoom`, tile pitch `[0x5AD4] = 16 >> zoom`;
sprite scale `[0x186] = 100 >> zoom` (0x679F4) — blits go through the plain thunks at
scale 100 and the scaled variants otherwise. Zoom 0..3 = 15×12 @16 px, 30×24 @8 px,
60×48 @4 px, 120×96 @2 px.

## 7. Runtime map state and the map screen periphery

The playing board lives in four parallel byte planes addressed through far pointers in
the data segment, drawn into a 320×200 Mode 13h screen whose left three-quarters is the
tile viewport and whose right edge is a woodgrain sidebar with minimap, status lines and
the selected-unit panel. This section pins the live memory layout, the fog model, the
screen geometry, and the colony screen's scene panel (which reuses the §6 compositor).

### 7.1 The live map planes

Four far pointers hold the planes (runtime-verified against live memory):

| pointer | plane | contents |
|---|---|---|
| `[0x15C]` | terrain | terrain byte (§5.4 encoding) |
| `[0x160]` | feature | bit 0 unit present, bit 1 settlement; road bits 0x0A; rebuilt by the game — the map-file feature layer is DISCARDED at load |
| `[0x164]` | continent/owner | low nibble continent, high nibble owner (0xF = none; village-owned land 5..0xA) |
| `[0x168]` | flags | low nibble = colony-site value |

Each plane is row-major, **stride 58**, with tile (0,0) at segment **base + 0x10**.
Three coordinate frames coexist: *plane* coordinates (0..57 × 0..71, including the
border ring), *engine* scroll-space `[0xA5A0]`/`[0xA5A2]` = plane − 1, and the
**sidebar "Locat:" display, which shows the plane index (= engine + 1)**. O514's
`(y+1)·stride + (x+1)` indexing (§6.1) converts engine to plane coordinates.

### 7.2 Fog and Reveal Map

The per-tile fog byte holds one bit per power in bits 4–7; the render mask is
`[0xA89E] = 1 << (player + 4)` (0x685F2) — explored-by-power-3 = bit 7 = 0x80, matching
runtime dumps. **Reveal Map** (cheat menu, enabled by Alt-W, I, N; the "Reveal Map →
Complete Map" row) sets the full-view flag `[0x53A2] = 1` and zeroes the fog mask
`[0xA89E]`; per-tile fog bytes are left untouched, and O513's mask==0 path then treats
every tile as visible.

### 7.3 The map screen — regions, fonts, keys

```python
regions = [
    (0,   0,   320, 9,   "Menu strip",          "text",  "wood fill; pulldown titles"),
    (0,   8,   240, 192, "Map viewport",        "art",   "15<<z x 12<<z tiles at 16>>z px"),
    (241, 8,   79,  41,  "Minimap",             "art",   "1 px/tile window + white viewport rect"),
    (240, 72,  80,  64,  "Season/Gold/Tax",     "text",  "FONTTINY line stack"),
    (240, 136, 80,  64,  "Selected-unit panel", "text",  "unit sprite + @INFO labels"),
]  # 320x200 Mode 13h
```

| Region | Bounds | Kind | Content source | State binding |
|---|---|---|---|---|
| Menu strip | (0,0,320,9) | text | menu titles `@GAME @VIEW @ORDERS @REPORTS @TRADE @CUP @PEDIA` | pulldown state |
| Viewport | (0,8)–(240,200) | art | §6 compositor | scroll `[0x8328]`/`[0x832E]`, zoom `[0x184]` |
| Minimap | (241,8,79,41) | art | `func_066CD6` (§7.4) | scroll window, fog, owners |
| Status lines | (240,72,80,64) | text | season/year, Gold, Tax (§7.5) | year `[0x538A]`, power record |
| Unit panel | (240,136,80,64) | text | Moves/Locat/type/skill/orders/terrain | selected unit record |

Fonts/inks: menu strip FONTTINY in green RGB (82,138,49); sidebar text FONTTINY in
white, palette index 0x0F (set at 0x76C85); sidebar x-origin `[0x8550]` = 240 (0x71039).
The UI colour slots at DS:0x830.. are loaded from the data file's `@COLORS` line — nine
palette-index bytes 68,149,8,128,47,138,134,128,138 (basic, hilite, grey, enhance,
shadow, select, border0..2) written to 0x830..0x839 (0x836 skipped), at 0x751A2..0x751E7.

Viewport zoom table (§6.12): **15<<z × 12<<z tiles at 16>>z px**, z = `[0x184]` ∈ 0..3
= 15×12@16 / 30×24@8 / 60×48@4 / 120×96@2. In VICEROY these are the four VIEW-menu
"Zoom Level" entries (plus zoom in/out); the stand-alone map editor binds the same four
spans to F1..F4 (`F1` = z3 120×96 … `F4` = z0 15×12, handler `_set_zoom_level(0x29−id)`
at its 0x30D8, clamp 0..3).

Navigation/keys: menu pulldowns per the seven titles above; REPORTS F2–F10 open the
advisor screens; VIEW menu zooms; F1 opens the terrain-information popup (shared
WOODPANL popup framework, `func_06F0F4`); click an own colony tile → colony screen;
click a foreign colony → the sidebar trade variant.

### 7.4 Minimap

`func_066CD6`: panel box (0xF1, 8, 0x4F, 0x29) = **(241,8,79,41)**, byte-verified at
0x66CF4. Contents are **1 pixel per tile** — a 56×39 scrolling window over the map, not
the whole map squashed. Per-tile dot colour from the DS:0x830 slot table: `[0x830]`
ocean/coast, `[0x831]` land, `[0x832]` fog (fog byte & 0x80), `[0x833]` owned
(& 0x20); the current-viewport rectangle is drawn in white (index 0x0F) — at zoom 0 a
15×12 rect, which independently confirms the zoom-0 span. The per-cell writer
(`func_066968`) writes single bytes per tile at x = col − `[0x9CCC]` + 252,
y = row − `[0x9CCA]` + 9, pitch `[0x2DAA]`.

### 7.5 Sidebar HUD

Status block (240,72,80,64), FONTTINY, white 0x0F: a three-line stack —
**season + year** (season names from `@SEASONS`: Spring/Autumn; year global `[0x538A]`,
banded `(year − 1500)/50` at 0x51F1F), **Gold: N** (power record +0x2A), **Tax: N %**
(power record +0x01); label strings from the `@MISC`/`@INFO` sections via the string
resolver. The line composer is `func_067700`; the per-line y-offsets are emitted through
a runtime-installed far pointer (`[0xA644]` = 0x1A1F:0x0F10, installed at 0x7730C) — a
true runtime indirection; the line stack itself is pixel-verified against the running
game. Selected-unit panel below at y=136: unit sprite, then Moves / Locat / unit type /
skill / orders / "(terrain)" lines (unit record stride 0x1C via `func_0672C8`; type and
skill names from the `@UNIT`/`@JOB` sections; Locat shows plane coordinates, §7.1).
Per-line coordinates beyond the stack order are (measured; not byte-cited):
season/year at (244,58), Gold (244,66), Tax (290,66), unit sprite (244,80),
Moves (270,82), Locat (270,92), type (244,104), skill (244,112), orders (244,120),
terrain (244,128).

### 7.6 The colony screen scene panel — the same compositor at ×1.5

The colony screen's terrain vignette is the §6 map compositor rendering a **5×5 tile
neighbourhood of the colony at native 16 px, then upscaled ×1.5 with an ordered
dither** — there is no dedicated 24-px tileset. Chain (`func_026374` at 0x26374):
scene latch `[0x18A]` = colony pointer (0x6891E); viewport forced 5×5, zoom `[0x184]`=0,
pitch 16, scale 100, origin = colony − (2,2), screen offset 0 (0x67894..0x67912); the
master loop `func_0685DC(cx−2, cy−2, 5, 5, power)` paints an **80×80** image on surface
0x839E — same painter, with map unit glyphs and the detail band suppressed by the scene
latch. Colony markers (ICONS frames 1..4 + pennant 0x77+power, population number and
name iff `[0x890]` == 0) and unit markers are drawn on the 80×80 *before* the upscale.
Then `func_00531C` (0x263A9..0x263D6) stretch-copies (0,0,80,80) → **(200,8,120,120)**,
duplicating every 2nd pixel and every 2nd row (exact 2→3 scaling) and passing every
written pixel through the positional 4×4 dither `func_005296` (`(dstoff&3) + (row&3)·4`),
which jitters the palette index within its 16-colour ramp for palette rows 0x10..0x87 —
deterministic, no RNG. The **visible panel (224,32,72,72) is the central 3×3 tiles** of
the 5×5 at 24-px pitch (the outer ring is overdrawn by the right-panel fill). Worker
sprites are added *after* the upscale at x = cell·24 + 252, y = cell·24 + 60 (signed
cell −2..+2), sprite `0x5A +` detail value, from PHYS0.SS.
