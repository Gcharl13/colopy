# .MP — Map File Format

The Colonization map file format. Read by both VICEROY.EXE (loads
AMER2.MP at game-start of the standard scenario) and MAPEDIT.EXE
(creates/edits arbitrary .MP files).

**Files in COLONIZE/**:
- `AMER2.MP` — the canonical standard-game world (Americas)
- `AMER2.MP.backup` — backup copy (same format)

**Authoritative source for terrain ID semantics**: NAMES.TXT $TERRAIN
section. Per CLAUDE.md hard rule, mapedit.c (in any historical archive)
is NOT to be cited as primary evidence for tile ordering — it has been
wrong about terrain ordering before.

---

## Layout

```
+--- header ---+
| width:  word (16-bit, little-endian)  ; default 56 for AMER2
| height: word (16-bit, little-endian)  ; default 70 for AMER2
+--- tile data ---+
| width × height bytes; row-major (y outer, x inner)
| each byte:
|   bits 0-4: terrain id (0..27)
|   bit  5  : river overlay (1 = river crossing this tile)
|   bit  6  : forest/special overlay (1 = forested, applied to land terrains)
|   bit  7  : ? (possibly "discovered by player 0")
+--- per-tile additional data (variable) ---+
| ColonyRecord array
| UnitRecord array
| NativeSettlement array
| (boundaries determined by following the read function in VICEROY,
|  starting from the *.MP push site)
```

The right-edge column is the **sea-lane column** (per CLAUDE.md): base
terrain id = 26. Never fake as desert.

---

## Terrain IDs (0..27)

Per `extracted/text/NAMES_sections.json` ($TERRAIN section), in order:

| ID | Hex | Name | Notes |
|----|-----|------|-------|
| 0 | 0x00 | Tundra | snowy frozen ground |
| 1 | 0x01 | Desert | hot dry |
| 2 | 0x02 | Plains | grass |
| 3 | 0x03 | Prairie | tall grass |
| 4 | 0x04 | Grassland | green |
| 5 | 0x05 | Savanna | dry grass |
| 6 | 0x06 | Marsh | wetland |
| 7 | 0x07 | Swamp | tropical wetland |
| 8 | 0x08 | Boreal Forest | northern forest (tundra+forest) |
| ... | ... | ... | (forest variants are auto-mapped in **8..23** per func_006204 BYTE_VERIFIED) |
| 24 | 0x18 | Arctic | polar ice — generator writes to map top/bottom rows (P5) |
| 25 | 0x19 | Ocean | open sea — generator's interior background fill (P0) |
| 26 | 0x1A | Sea Lane | navigable right-edge column (Ocean-class; **hard rule 2**) |
| 27 | 0x1B | Mountains | impassable rock |
| 28 | 0x1C | Hills | brown rolling |

> **Corrected 2026-06-20** (`notes/rulings/RULINGS.md`): ids **24–28** were
> previously listed as Mountains/Hills/Ocean/Lake with Arctic at 16. That table
> was the outlier — it placed Arctic *inside* the auto-forest range 8..23
> (impossible per func_006204) and conflated Ocean with Sea Lane. The
> byte-verified `@OTHER` ordering (**Arctic, Ocean, Sea Lane, Mountains, Hills**)
> + hard rule 2 (Sea Lane = 26) force the base to 24, and the random-map
> generator's immediates (0x18 poles / 0x19 interior fill / 0x1A right edge)
> corroborate it. (There is no separate "Lake" terrain in `@OTHER`.)

Sources for ID semantics:
- NAMES.TXT `$TERRAIN` / `@OTHER` section (canonical) — `@OTHER` order
  **Arctic, Ocean, Sea Lane, Mountains, Hills** → ids 24..28.
- `func_006204` BYTE_VERIFIED at file 0x6204 — auto-forest range check
  (terrain id 8..23 = forested variants of base terrains)
- `notes/rulings/RULINGS.md` 2026-06-20 — id 24–28 conflict resolution.

---

## Bit overlays

| Bit | Mask | Meaning |
|-----|------|---------|
| 5 | 0x20 | River overlay — sprite added on top of base terrain |
| 6 | 0x40 | Forest overlay (applied to base land terrains 0..7 to map to 8..15) |
| 7 | 0x80 | Possibly "explored by player 0" flag (TODO_VERIFY) |

The forest bit is REDUNDANT with terrain id 8..15 since those IDs are
the auto-forest mapping. The bit may be set for ALL forested tiles to
make traversal-cost lookups simpler. (TODO_VERIFY against the .MP
loader function.)

---

## Coast rendering convention

Per CLAUDE.md hard rule (BYTE_VERIFIED via prior pixel work):
- PHYS0 sprites 0x01 and 0x11 are **rivers**, not coast
- True coasts use sprites 150–153 plus the water-tile beach-halo mechanism
- Sea-lane column (right edge) base terrain id = 26 (Sea Lane; Ocean is 25 — corrected 2026-06-23, the prior "(Ocean)" label on 26 was wrong)

---

## Per-tile metadata (after the tile-data array)

The .MP file contains additional structures after `width × height`
bytes of tile data:

### ColonyRecord array

Per anchor_map.md (BYTE_VERIFIED stride): each ColonyRecord is **202
bytes persistent + 174 bytes working buffer = 376 bytes total**. The
.MP file likely stores only the persistent 202 bytes per colony.

- count: 1 word (number of colonies)
- per-colony: 202 bytes (TODO: full field layout from the loader)

### UnitRecord array

Per anchor_map.md (BYTE_VERIFIED): each UnitRecord is **0x1C = 28 bytes**.

- count: 1 word (number of units)
- per-unit: 28 bytes (BYTE_VERIFIED stride; field semantics in
  [`viceroy_source/include/unit.h`](../include/unit.h))

### NativeSettlement array

Per anchor_map.md (BYTE_VERIFIED): each NativeSettlement is **174 bytes
working buffer + 202 bytes persistent**. Likely uses the 202-byte
persistent form on disk.

- count: 1 word
- per-settlement: 202 bytes (TODO: full field layout from loader)

---

## Read/write entry points

**VICEROY.EXE**: the .MP loader is invoked at game-start. Find via the
`*.MP` PUSH-imm16 sites in VICEROY's overlay region.

**MAPEDIT.EXE**: load via the LOAD menu (`MAPTOLOAD` dialog) and save
via the SAVE menu (`MAPTOSAVE` dialog). Both at offsets in the menu
dispatcher region.

---

## Round-trip verification

A round-trip extractor (read → modify → write) should produce
byte-identical output if no fields are modified. The `tools/verify.py`
script in the parent project's tools/ directory enforces this.

---

## Open work

- **TODO_VERIFY**: the high bit (0x80) of each tile byte
- **TODO_VERIFY**: the exact post-tile-array layout (Colony/Unit/Native
  array order and counts)
- **Per-line annotation** of the .MP loader function in VICEROY (find
  via `*.MP` PUSH sites); will pin the exact field layout
