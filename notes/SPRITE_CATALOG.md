# Sprite Catalog

Authoritative catalog of every sprite sheet referenced by the in-game
renderer. Maintained by the `sprite-cataloger` agent (and the main thread
when the agent is unable to complete).

All sprites are extracted from MADSPACK-compressed `.SS` files and live
under `extracted/assets/sprites/<SHEET>/<SHEET>.SS.NNN.png`. Palette
index 253 is the transparency key in PHYS0. Other sheets use a standard
alpha channel.

## PHYS0.SS — terrain / coast / road / resource overlays

154 sprites total, 16×16 each (except row 0x70 which is 8×8 sub-tiles).
Organized as 10 rows of 16 (`base + 0..15`, with the last entry of each
row often being a padding/marker sprite).

### Row 0x00 (indices 0–15) — River overlays ⚠️

**Depicts**: Blue water channels with **GREEN grass banks**. These are
river sprites, NOT coast edges. The banks are always green regardless of
surrounding terrain.

**⚠️ Confusion warning**: These sprites look like coast edges at first
glance. Drawing them on non-grass land tiles (e.g., desert) produces the
infamous "green leaves on sand" artifact. The TRUE DOS coast rendering
uses sprites 150–153 + per-sub-tile coast strips (row 0x70).

**Used by**: the DOS river overlay pass when feature bit `0x40` is set
on a land tile.

**Evidence**: pixel inspection at 10× (`tools/atlases/phys0_5rows_labeled.png`).

### Row 0x10 (indices 16–31) — Desert-edge overlays ⚠️

**Depicts**: Similar river-like shapes as row 0x00, but banks include tan
and brown pixels mixed with green. Subtly different from 0x00 — the key
distinction is palette usage in the bank pixels.

**Used by**: river/coast rendering when the adjacent land tile is desert
(base=1) or scrub (base=9).

**Lookalike**: Row 0x00 is the near-identical counterpart for green
terrain. Always confirm by checking the adjacent land's base terrain.

### Row 0x20 (indices 32–47) — Mountains (snow-capped peaks)

**Depicts**: Gray/brown rock with snow caps.

**Used by**: self-overlay on tiles with feature bits = `0xA0` (bit 5+7 set).

**Ruling**: Per `docs/RULINGS.md` 2026-04-20, this row is **mountains**,
not hills. Earlier disassembly-based claims placing hills at 0x21 were
consistent with this if the DOS map-editor palette-slot labels "Hills"
and "Mountains" are swapped relative to the C reconstruction's NAMES
table.

### Row 0x30 (indices 48–63) — Hills (brown rolling)

**Depicts**: Brown rolling terrain with no snow.

**Used by**: self-overlay on tiles with feature bits = `0x20` (bit 5 only).

### Row 0x40 (indices 64–79) — Forest (trees)

**Depicts**: Green tree clusters over the underlying base terrain.
Sub-cells composed via the 3×3 transition table so a forest tile
adjacent to a non-forest tile only draws trees on cells facing away
from the neighbor, preventing double-draw at shared edges.

**Used by**: self-overlay on tiles with base `8..15` OR feature bit
`0x80`. The forest is drawn ON THIS tile, selecting sub-cells where the
neighbor is NOT also forest.

### Row 0x50 (indices 80–95) — Road overlay + cursor

**Depicts**: Road segments at various cardinal combinations. Index = base
80 + 4-bit cardinal neighbor mask (N=8, E=4, S=2, W=1).

- **80**: isolated single-tile road marker
- **81..94**: road with neighbors per mask
- **95**: **Active cursor highlight ring** (not a road variant — repurposed
  slot). Used by `_render_selection` in `main.py`. VICEROY.EXE draws this
  in `func_O513` at 0x68212 via `mov ax, 0x95 / call 0x67DC8`.

### Row 0x60 (indices 96–111) — Resource overlays + selection / padding

Confirmed via agent pixel inspection + verification:

| Index | Content |
|-------|---------|
| 96 | Fish / aquatic resource (on water tiles) |
| 97 | Beaver / fur resource |
| 98 | Deer / game resource |
| 99 | Pine tree / lumber / forest resource |
| 100 | Blank / null |
| 101 | Stone OR silver nugget (**needs follow-up** — visually similar) |
| 102 | Small ore nugget |
| 103 | Gold / Aztec coin / treasure icon |
| 104–107 | Dashed / dotted rectangular outlines — selection-box variants |
| 108–111 | Pure black 8×8 — null padding |

**Used by**: resource overlay pass. The resource byte in layer 2 or 3 of
the .MP file selects which of 96–103 to draw on that tile. See
`MAP_FORMAT.md` for the resource-byte layout (pending).

### Row 0x70 (indices 112–127) — 8×8 coast sub-tile strips

**High-value re-investigation opportunity.** These are 8×8 (not 16×16)
blue/green sub-tile fragments — potentially the TRUE DOS coast sprites
rendered via 4-sub-tile composition on water tiles. Current renderer
uses sprites 150–153 as bulk coast overlays; this row may offer finer-
grained per-sub-tile coast rendering that matches DOS more precisely.

**Action**: before shipping further coast refinements, have
`dos-disassembler` locate where func_O512 references sprite indices in
this range and confirm the composition rule.

### Row 0x80 (indices 128–143) — More river / water variants

Need further inspection to distinguish from row 0x00. May be variants
for different river widths or for river-meets-coast transitions.

### Row 0x90 (indices 144–153) — Coast / shallow-water / sandy-edge

| Index | Content |
|-------|---------|
| 144–147 | Small blue water / fish-swirl fragments (smaller than 8×8?) |
| 148 | **Deep dithered ocean** — pure 16×16 opaque, palette indices (24,28,125) / (32,44,137) / (16,16,117). Used as full water-tile base fill. |
| 149 | **Sandy dune** — vertical stripes of desert, 4 columns of tan (117,97,68)(133,113,80)(101,80,52)(153,129,93). |
| 150 | Ocean with sand at NW corner (2-edge). Used for water tiles with land to NW. |
| 151 | Ocean with sand at corresponding corner (see below). |
| 152 | Ocean with wider sand on SE/S+E. |
| 153 | Ocean with sand on 3 sides — "island-in-water" variant. |

**Used by**: `_render_terrain` in `main.py` builds a `beach[]` dict mapping
4-bit cardinal land-neighbor mask → sprite + flip. Verified in the current
coast render of ONE.MP / AMER2.MP.

## CC-00 through CC-24 — Founding Father portrait sheets

**CORRECTED 2026-06-20.** These 25 sheets are **Founding Father portraits**
(`NAMES.TXT @FATHERS` by index — 25 entries = 25 sheets), per the **SPRITE-A
resolution** in `notes/PROJECT_BOARD.md` ("FULLY RESOLVED 2026-05-05"). The **prior
"unit/colonist sheet" hypothesis is SUPERSEDED and wrong** — unit/colonist sprites
live in **ICONS.SS** (byte-cited from `@UNIT` column 1 "Icon": Colonists 101, Soldiers
103, Caravel 6, …, Cont. Cav. 130; see `GAME_INDEX_TABLES.md`), not in CC-NN.

**Container facts (verified 2026-06-20 from `col.zip` → `raw/COLONIZE/CC-NN.SS`):**
each sheet is a **MADSPACK 2.0** container (`magic "MADSPACK 2.0\x1A"`) with **4
FAB-compressed sections** (sprite header / descriptor table / palette / pixel data);
file SHAs match `MANIFEST.md`.

**Files confirmed genuine sprite sheets (2026-06-20):** the directory + section roles
parse cleanly (`formats/SS.md` byte-verified layout) — section 2 = **768 B = 256 RGB
palette**, and CC sheets share identical header/descriptor sections — so the assets are
valid, not corrupt. **Per-frame pixel cataloging is BLOCKED on the codec.** Compressed
sections use the **MADSPACK-2 internal codec (`mode=4`), NOT the standalone ScummVM
"FAB"** (no `FAB` magic / shift byte present), and the `mpskit` decoder referenced by
`formats/SS.md` is **absent from the repo**. Most sections are compressed (`flag=1`), so
the descriptor/pixels need the codec. Recovering pixels requires the **mode-4 decoder**, but a bounded static hunt
(2026-06-20) found the **loader is NOT statically locatable** — it lives in an RTLink
overlay: the resident anchors `func_0749E0` / `0x191F:0x928` are a **config-text
parser** (not the binary loader), and the format strings (`MADSPACK`/`PIK`/`rb`) have
**zero real instruction refs** in the flat image (all apparent hits are byte
collisions). So finishing needs **RTLink overlay-map reconstruction or a dynamic
(DOSBox) trace** at the `.SS` fopen — see `formats/SS.md` §"Loader in VICEROY.EXE".
Until then the per-portrait frame layout stays **TBD**.

<details><summary>SUPERSEDED unit-sheet hypothesis (kept for history — do not cite)</summary>

> An older note treated CC-00..CC-24 as unit/colonist sheets (CC-00=Free Colonist …
> CC-24=naval). This was a **hypothesis only**, refuted by SPRITE-A (CC-NN = FF
> portraits; units = ICONS.SS). Retained solely so the prior reasoning is traceable.

</details>

## BUILDING.SS — Colony buildings

Sprites for colony buildings (carpenter, blacksmith, stable, fortress,
warehouse, stockade, docks, armory, church, newspaper, distillery,
tobacconist, weaver, fur trader, rum distillery, cigar maker, etc.) plus
their higher-tier upgrades. **48 sprites** (per `notes/ASSET_CATALOG.md`) vs **42**
PEDIA `@BUILDING0..41` entries — not 1:1 (likely shared sprites across upgrade tiers).

**Status: NOT CATALOGED — BLOCKED on the FAB/MADSPACK decoder (2026-06-20).** Verified
container: MADSPACK 2.0, 4 FAB-compressed sections, 20,990 bytes, SHA `e91784542982216a…`
matching `MANIFEST.md`. The per-index → building-name mapping needs the **decoded
pixels** (same tooling blocker as the CC-NN note above), not data/disasm. The PEDIA
index list (`docs/PEDIA_TXT_CATALOG.md` `@BUILDING0..41`) is the cross-reference target
once a decoder exists.

## ICONS.SS — Goods and HUD icons

### ⚠️ VERIFIED 2026-05-31: PORT PNG index = VICEROY index − 1 (GLOBAL off-by-one)

**The single most important ICONS fact.** `COLONIZE/ICONS.SS` holds **131
sprites** (MADSPACK part0 `nsprites=131`; part1 = 2096 B = 131 × 16-byte
headers). The `tools/mpskit/ss.py` extractor dumps them **0-based** to
`extracted/assets/sprites/ICONS/ICONS.SS.{NNN:03}.png` (NNN=000..130); each PNG
is **pixel-identical** to a fresh decode of the original .SS (verified for a
12-index spread incl. 0/5/56/57/62/63/124/125/130 — sidecar start_offset/
length/width/height all match the original sprite headers exactly).

But the **game's runtime sprite numbers are 1 higher than the dump index.**
VICEROY blits via sheet handle `[DS:0x83E]` (= ICONS), record stride 12,
width word at `+0x3E` (`func_002EE4` @0x2F66; `func_003104` @0x3165). The
index `ax` used in `ax*12+0x3E` is **1-based relative to the ss.py 0-based
dump**, so:

> **port_png_index = VICEROY_sprite_index − 1**, and this offset is **GLOBAL**
> (every sprite role, not a sub-range).

**Anchors that prove it (NAMES.TXT `@UNIT` col-1 = VICEROY icon index, decoded
with `COLONIZE/VICEROY.PAL`):** Caravel 6→png5 (ship✓), Merchantman 7→png6✓,
**Galleon 8→png7 (ship✓ — png8 is the WAGON, so DIRECT mapping is wrong)**,
Privateer 15→png14✓, Frigate 16→png15✓, Man-O-War 128→png127 (ship✓ — png128
is a person), **Wagon Train 9→png8 (covered wagon✓)**, **Artillery 10→png9
(cannon✓)**, Treasure 17→png16 (gold✓), Colonist 101→png100, Soldier 103→png102
(FOOT✓), Scout 104→png103 (mounted✓), Dragoon 105→png104 (mounted✓), Brave
110→png109✓. Under DIRECT (no −1) the foot/mounted and ship/wagon/cannon roles
scramble; under −1 every name matches its art. This also reconciles
`CLAUDE.md`'s renderer indices (ships 5-7/14-15/127, foot units 100-105+109) —
those ARE the VICEROY `@UNIT` indices minus 1, i.e. they are already PORT png
indices. **So the renderer should index PNGs at `VICEROY_idx − 1`.**

### Report-screen gauge / row segment sprites (byte-cited roles → PORT png)

Roles are byte-verified in `.../drawlist/REPORTS.md` (gauge
primitive `func_002EE4` @0x236; rebel/tory enqueue `func_0033F2` @0x222). The
VICEROY indices below are ground truth from the disassembly; the PORT png index
is `VICEROY − 1` (rule above); the depiction is the **decoded original**.

| Role | VICEROY idx | **PORT png** | px (w×h) | Depiction (decoded, VICEROY.PAL) |
|------|-------------|--------------|----------|----------------------------------|
| Crosses gauge — FILLED segment | 0x39 (57) | **056** | 7×12 | Bright green/yellow **Christian cross** (crucifix) |
| Bell gauge — FILLED segment | 0x3F (63) | **062** | 10×12 | Silver/gray **Liberty Bell** (yoke bar + cracked body) |
| Gauge — EMPTY segment (shared, hardcoded `mov ax,0x38`) | 0x38 (56) | **055** | 8×12 | **Red "X"** mark — see caveat below |
| Rebel row sprite | 0x7C (124) | **123** | 13×11 | American/colonial **flag** (stars-and-stripes) |
| Tory row sprite | 0x7D (125) | **124** | 13×11 | Gold **crown** (loyalist/King) |

Semantics line up perfectly under −1: crosses-gauge fills with a cross,
bell-gauge fills with a bell, rebels march under the flag, tories under the
crown.

**Re the observed "red hollow box":** `ICONS.SS.063.png` (= VICEROY 0x3F **if
read DIRECTLY**) is a 16×16 **red hollow box outline** (palette idx 112 =
(242,0,0) — a genuine artist **placeholder/registration sprite**, alongside
the white-box placeholders at png 18-20 and 63-64, and the 1×1 nulls at png
4/70-72/78-80). It is **NOT a palette bug**: the .SS-embedded palette (part2)
is identical to `COLONIZE/VICEROY.PAL` (only 3/256 indices differ, none in the
red ramp 112-116), and the bell-filled segment really lives at png **062**.
The bug is purely the **off-by-one**, not color. (Note `extracted/palette.json`
IS wrong — its idx 112 = magenta #a020a4 — but ss.py did **not** use it for
ICONS, so the PNGs are correctly colored. Don't use `extracted/palette.json`
for ICONS; use the .SS-embedded palette / `VICEROY.PAL`.)

**CAVEAT (one residual uncertainty):** the EMPTY segment is the hardcoded
constant `0x38` shared by both gauges; under the proven −1 rule it resolves to
**png 055 = a red "X"**, which is visually odd for an "empty meter track." The
−1 rule itself is not in doubt (12+ independent anchors), and the asm draws
`0x38` for every unfilled cell (`func_002EE4` @0x2FA5 → blit `LCALL 0xC36:0xA`).
If a future DOS-reference screenshot of the F2/F3 meters shows a different empty
fill, re-examine whether the empty segment alone is special-cased; until then
png 055 is the byte-faithful choice. (png 056, the gold/dim cross, is the
crosses-FILLED neighbor, NOT the empty tick.)

**Method note:** decoded straight from `COLONIZE/ICONS.SS` via MADSPACK +
`ss.py` linemode reader using `COLONIZE/VICEROY.PAL` (1024 B = 256 RGB 6-bit +
trailer; scaled ×255÷63, max channel = 63). PNG-vs-original pixel-identity and
sidecar header-match both confirmed before drawing any conclusion.

---

| Index | Icon (hypothesis — see −1 caveat above; these are PORT png indices) |
|-------|-------------------|
| 0 | Food |
| 1 | Sugar |
| 2 | Tobacco |
| 3 | Cotton |
| 4 | Furs |
| 5 | Lumber |
| 6 | Ore |
| 7 | Silver |
| 8 | Horses |
| 9 | Rum |
| 10 | Cigars |
| 11 | Cloth |
| 12 | Coats |
| 13 | Trade Goods |
| 14 | Tools |
| 15 | Muskets |
| 16+ | HUD pips, nation flags, small arrow indicators, etc. |

**Status**: HYPOTHESIS for goods 0-15 (NOT yet pixel-verified, and note the
−1 offset means VICEROY good-id N → png N−1). Decoded png 0-3 are large 21×16
goods **crates/baskets**; png 4 is a 1×1 null; png 5-9 are ship/wagon/cannon
(see −1 anchors above). The clean 16-goods strip has not been positively
located — do not trust this table for goods until verified.

## WOODFRAM.SS — 9-slice dialog frame

Single sprite, approximately 200×128 (verify). Wooden frame with a hollow
center. Use as a 9-slice when drawing dialog boxes of arbitrary size:
corners stay fixed, horizontal and vertical edges tile, center is
transparent or tiled with `WOODTILE`.

**Action**: implement a `nine_slice_blit(surf, frame_sprite, rect)`
helper in `main.py` before building the dialog system.

## WOODTILE.SS — Wood-grain fill tile

Single ~16×16 tile, tileable seamlessly. Used to fill the interior of
dialog boxes and wood-paneled screens where a PIK background isn't
sufficient.

## Backgrounds (extracted/assets/backgrounds/*.PIK.png)

Full-screen (320×200) backdrops. Each is a single PIK-decoded PNG.

| File | Purpose |
|------|---------|
| CCBKGD.PIK | Colony screen (generic — may be alternate name for CLOS-BKG?) |
| CLOS-BKG.PIK | Colony screen main backdrop |
| CUSTOMIZ.PIK | Customize-game screen |
| DECLARAT.PIK | Declaration of Independence / revolution scene |
| DECOIND.PIK | Decorative / Indians illustration |
| DIFFICUL.PIK | Difficulty selection screen |
| EUROPE.PIK | European port screen |
| KINGLSS1.PIK | King audience screen variant 1 |
| KINGLSS2.PIK | King audience screen variant 2 |
| LEVN0001..LEVN0010.PIK | "Level" or cutscene screens (verify) |
| NATIONS.PIK | Nation selection screen |
| OPENBORD.PIK | Border illustration at game start |
| OPENING.PIK | Title / opening screen |
| OPENMENU.PIK | Main-menu backdrop |
| REPORT1..REPORT9.PIK | Report screens (F2..F10) |
| WOODPAN2.PIK | Alternate wood panel |
| WOODPANL.PIK | Main wood-paneled sidebar strip |

Also in that directory: the CLOS-BEL, CLOS-FWK, CLOS-HAT (partial name)
directories may contain in-colony building illustrations or colonist
portraits — verify.

## TERRAIN.SS — Per-terrain textured ground

**CORRECTED 2026-04-21** (see `docs/RULINGS.md`): earlier flagged as
orphan based on a negative string-search in VICEROY.EXE — pixel
inspection at 5× showed 12 sprites that are obviously the textured
ground tiles for each major biome. The renderer now blits these as
the base terrain fill instead of solid color.

**RE-EXTRACTED 2026-04-25**: The original extraction was incomplete; the
`extracted/assets/sprites/TERRAIN/` directory did not exist at the time of
the 2026-04-21 ruling. An extraction agent ran `tools/mpskit/main.py ss
unpack COLONIZE/TERRAIN.SS` and recovered the complete sheet: 12 frames
(TERRAIN.SS.000.png through TERRAIN.SS.011.png) plus palette. Format: 16×16
8-bit indexed PNG, transparent index 253. The 2026-04-21 pixel-evidence
claim is now fully supported.

12 sprites, 16×16 each:

| Index | Content                          | Used for .MP base IDs |
|-------|----------------------------------|-----------------------|
| 0     | Tundra (gray/yellow speckle)     | 0 (Tundra), 8 (Boreal) |
| 1     | Desert (sandy tan)               | 1 (Desert), 9 (Scrub — see #8 alt) |
| 2     | Plains (olive-brown dots)        | 2 (Plains), 10 (Mixed), 17-23 (unknown extended) |
| 3     | Prairie (yellow field)           | 3 (Prairie), 11 (Broadleaf) |
| 4     | Grassland (bright green tufts)   | 4 (Grassland), 12 (Conifer) |
| 5     | Savannah (medium green)          | 5 (Savannah), 13 (Tropical) |
| 6     | Marsh (green + blue water spots) | 6 (Marsh), 14 (Wetland) |
| 7     | Swamp (sandy + dark features)    | 7 (Swamp), 15 (Rain Forest) |
| 8     | Scrub (sand + cacti) — alt       | (not currently used; TERRAIN_TO_SPRITE maps Scrub to 1) |
| 9     | Arctic (white + blue)            | 16 (Arctic) |
| 10    | Ocean (solid dark blue)          | 25 (Ocean) |
| 11    | Sea Lane (darker blue)           | 26 (Sea Lane) |

Forested biomes (IDs 8-15) currently reuse their unforested base via
`TERRAIN_TO_SPRITE`. The forest sprite layer (PHYS0 row 0x41) is
composited on top.

### Known extraction artifacts

The PHYS0 extraction contains three "placeholder" sprite indices that are 1×1
single pixels (fully transparent, palette index 253). These are NOT usable
sprites and should never be indexed into by any code:

- **Index 0** (row 0x00, first frame): 1×1 placeholder
- **Index 16** (row 0x10, first frame): 1×1 placeholder
- **Index 100** (row 0x60, first frame): 1×1 placeholder

Documented row boundaries refer to slot numbers in the flat index space.
Usable sprite content within each affected row begins at offset +1:
indices 1–15, 17–31, and 97–103 respectively. The cause is unknown: either
MADSPACK 2.0 decompression has a bug, or the original .SS file genuinely
has empty slots at these positions. If a future session needs one of these
indices, first investigate mpskit extraction options or inspect the source
.SS file directly.
## Orphan sheets (DO NOT USE IN RENDERER)

- **BDARK.SS** — suspected orphan, NOT yet pixel-verified. If a future
  session wants to use it, first inspect the sprites at 5× to confirm.
  Loading an orphan caused the "wrong terrain at cursor" bug earlier.

## Known ambiguities / follow-up

1. **Row 0x70 (112–127)**: are these the true DOS coast sprites? Needs
   disassembly verification of func_O512's sprite-index arithmetic.
2. **Row 0x80 (128–143)**: distinction from row 0x00 rivers unknown.
3. **CC-NN sheets**: ~~hypothesised as unit sheets~~ **CORRECTED 2026-06-20 — they are
   Founding Father portraits** (`@FATHERS`, SPRITE-A); per-frame layout blocked on the
   FAB decoder (see §CC-00..CC-24).
4. **Nation-tinting palette indices for CC-NN sprites**: unknown.
   Needs disassembly to find the palette-remap function.
5. **BUILDING.SS index → building name mapping**: not cataloged — **blocked on the
   FAB/MADSPACK decoder** (`tools/mpskit/*` absent; FAB bitstream undocumented), not a
   "PNG inspection" gap. 48 sprites vs 42 PEDIA `@BUILDING` entries.
6. **ICONS.SS indices 16+**: not yet cataloged.
7. **CLOS-BEL, CLOS-FWK, CLOS-HAT directory contents**: not yet inspected.
8. **Sprite 101**: silver nugget or stone? Similar visuals — disambiguate
   via palette indices used.

Each of these is a discrete follow-up task; pick them off as they
unblock specific rendering work.

## Evidence index

- `tools/atlases/phys0_atlas.png` — full 10-row PHYS0 atlas at low zoom
- `tools/atlases/phys0_5rows_labeled.png` — rows 0x00–0x40 labeled, 4×
- `tools/atlases/phys0_96_143.png` — indices 96–143 at 5×
- `tools/atlases/phys0_144_159.png` — indices 144–159 at 5×
- `tools/atlases/phys0_real_coast.png` — sprites 146–153 at 12×
- `tools/atlases/row01_row11_compare.png` — row 0x00 vs 0x10 direct comparison, 10×
- `tools/atlases/row01_vs_row11_big.png` — same, 8×
