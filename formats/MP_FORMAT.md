# .MP — Map File Format

The Colonization map file format. Read by both VICEROY.EXE (loads
AMER2.MP at game-start of the standard scenario) and MAPEDIT.EXE
(creates/edits arbitrary .MP files).

> **REWRITTEN 2026-07-30 from the actual MAPEDIT.EXE writer/loader**
> (`_write_map_file` @0xB840 / `_load_map_file` @0xB700, map_9.obj,
> `code/MAPEDIT/disasm_named/map_9.asm` — real symbol names from the EXE's
> CodeView debug info, `data_extracted/mapedit_symbols.json`). The previous
> version of this file was inferred without the editor and had four
> substantive errors (header size, body layout, overlay-bit semantics, and
> the "record arrays" section — see `notes/rulings/RULINGS.md` 2026-07-30).
> Every field below is byte-cited and cross-checked against `AMER2.MP`
> (12,534 bytes = 6 + 3·58·72; header words (58, 72, 4) — verified).

**Files in COLONIZE/**:
- `AMER2.MP` — the canonical standard-game world (Americas)

**Authoritative source for terrain ID semantics**: NAMES.TXT $TERRAIN
section (per CLAUDE.md hard rule 1). MAPEDIT.EXE *agrees*: `_load_data`
@0x3936 reads `@UNFORESTED` → ids 0..7, `@FORESTED` → ids 8..15 (records
16..23 memcpy'd from 8..15 @0x39B1–0x39CD), `@OTHER` → ids 24..28.

---

## Layout (B — from the writer)

```
+--- header: 6 bytes ---+
| width:   u16 LE   ; AMER2 = 58 (0x3A)
| height:  u16 LE   ; AMER2 = 72 (0x48)
| version: u16 LE   ; must be 4 (_map_file_version; loader cmp @0xB76D)
+--- layer 1: terrain, width×height bytes, row-major (y outer, x inner) ---+
| per byte:
|   bits 0-4 (0x1F): terrain id 0..28
|   bit  5   (0x20): mountains/hills overlay
|   bit  6   (0x40): river overlay
|   bit  7   (0x80): modifier for bits 5/6:
|                     with bit5: set = Mountains(27), clear = Hills(28)
|                     with bit6: set = Major River, clear = Minor River
+--- layer 2: feature, width×height bytes ---+
| per-tile bit flags (game-side; editor only passes them through):
|   bit0 = unit present        (_is_unit @0x43C8)
|   bit1 = settlement          (_is_colony/_is_village/_is_city @0x43F6..)
|   bit2 = prime resource      (_resource_at @0x45CF)
|   bits 3/6 tested by _is_hostile @0x44D1 (semantics TBD, game-side)
| AMER2.MP layer 2 is all zeros.
+--- layer 3: continent/owner, width×height bytes ---+
|   low nibble  = continent/region id 1..15 (0 = border/none)
|                 (_continent_at @0x428B; written by _map_find_continents
|                  @0xB242, labels compressed to 1..15, overflow → 0xF)
|   high nibble = owner (_owner_of @0x42C5; 0xF = none)
+--- end of file ---+
```

**File size = 6 + 3·width·height.** Nothing follows layer 3 — there are
**no ColonyRecord/UnitRecord/NativeSettlement arrays in .MP files** (those
belong to save-games). AMER2.MP's size proves it: 12,534 = 6 + 3·4176.

Writer sequence: header 4 bytes @0xB878–0xB885 + version 2 bytes
@0xB896–0xB8AC, then three `w·h`-byte layer writes (`_map` @0xB8C8,
`_feature` @0xB8E8, `_continent` @0xB910). Loader `_load_map_file` @0xB700
mirrors it, requires version==4 @0xB76D–0xB773, and caps `w·h ≤ 0x2EE0`
(12,000 tiles) @0xB6CE (`_map_error` 9999 on overflow).

Error codes (`_map_error` [0x4A4]): 1 open, 2 header, 3 version,
4/5/6 layer-1/2/3 I/O, 9999 map too big.

### Bit-combo census of AMER2.MP layer 1 (verified 2026-07-30)
`0x00`×3724 · `0x20` hills×56 · `0x40` minor river×178 · `0x60`
hills+minor river×1 · `0xA0` mountains×170 · `0xC0` major river×47.
Terrain ids used: 0..23, 25, 26.

### Forest is NOT a bit
Forested terrain is expressed **in the id** (8..23 = auto-forest range,
hard rule 3). The editor's `_terrain_is_forest` @0xB222 tests 8..0xF and
0x10..0x17. On every load MAPEDIT runs `_forest_fix` @0x16B6 which
normalizes ids 0x10..0x17 → id−8 and strips forest under a
mountains/hills overlay — so a load→save round-trip through MAPEDIT is
**not byte-preserving** for files (like AMER2.MP) that contain ids 16..23.

### Border ring and the sea-lane column (hard rule 2, refined)
- The outermost 1-tile ring is **not editable** (`_change_map` bounds
  x,y ∈ [1..w−2]/[1..h−2] @0x31E9–0x320D) and is skipped by the continent
  finder. In AMER2.MP the ring is Ocean (25).
- **Hard rule 2's "right-edge column = Sea Lane 26" refers to the
  right-most *playable* column x = w−2**: in AMER2.MP all 70 interior rows
  of column 56 are Sea Lane (verified). Sea lane also spreads over the
  eastern ocean region and parts of column 1. The rule's *number* (26)
  stands unchanged.
- New maps are created **all Ocean (25)**: `_create_blank_map` @0xB94A
  memsets layer 1 to 0x19, layers 2/3 to 0, sets version=4 @0xB9C2. Size
  is **hard-coded 58×72** (`push 0x48; push 0x3A` @0x2C53–0x2C55). No
  sea-lane column is synthesized — it is hand-painted (id 0x1A, paint
  and-mask 0x40 preserves an existing river bit @0x273C).

---

## Terrain IDs (0..28)

Per NAMES.TXT `$TERRAIN` (`@UNFORESTED`/`@FORESTED`/`@OTHER`), in order:

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
| ... | ... | ... | (forest variants auto-mapped in **8..23** per func_006204 BYTE_VERIFIED; 16..23 are aliases of 8..15) |
| 24 | 0x18 | Arctic | polar ice |
| 25 | 0x19 | Ocean | open sea — `_create_blank_map` fill value |
| 26 | 0x1A | Sea Lane | navigable; right-most playable column (**hard rule 2**) |
| 27 | 0x1B | Mountains | overlay form: bit5+bit7 (0xA0) |
| 28 | 0x1C | Hills | overlay form: bit5 alone (0x20) |

> **Corrected 2026-06-20** (`notes/rulings/RULINGS.md`): ids **24–28** were
> previously listed as Mountains/Hills/Ocean/Lake with Arctic at 16. That table
> was the outlier — the byte-verified `@OTHER` ordering (**Arctic, Ocean, Sea
> Lane, Mountains, Hills**) forces the base to 24. (No "Lake" terrain exists.)

Note the dual representation of Mountains/Hills: as *ids* 27/28 (how
`@OTHER` names them and how `_terrain_type` @0xB17C reports them:
bit5 set → type = 0x1B + (bit7 ? 0 : 1)) and as *overlay bits* on a base
land terrain (how tiles store them; paint masks: Mountains `or 0xA0 /
and 0x1F` @0x276C–0x277B, Hills `or 0x20 / and 0x5F` @0x277E–0x2788,
Major River `or 0xC0 / and 0x1F` @0x2744–0x2753, Minor River `or 0x40 /
and 0x3F` @0x275A–0x2764).

---

## Coast rendering convention

Per CLAUDE.md hard rule 4 (BYTE_VERIFIED via prior pixel work):
- PHYS0 sprite rows 0x01 and 0x11 are **rivers**, not coast
- True coasts use sprites 150–153 plus the water-tile beach-halo mechanism
- Sea Lane is id 26, Ocean 25 (corrected 2026-06-23)

---

## Read/write entry points

**MAPEDIT.EXE** (all byte-cited): writer `_write_map_file` @0xB840;
loader `_load_map_file` @0xB700; creator `_create_blank_map` @0xB94A;
menu paths in `_execute_menu_event` @0x2DE0 — SAVE id 0x1A @0x2F8E,
SAVE AS id 0x13 @0x2EAC, LOAD id 0x1B @0x2FD4, NEW id 0x14 @0x2F24,
EXIT id 0x1F @0x305E (with save-on-exit option).

**VICEROY.EXE**: loads AMER2.MP at game start (the `AMER2.MP` string
lives in the end-of-turn/setup cluster near `func_0755CC`); its .MP
loader has not yet been per-line annotated — TODO; it must accept the
same 6-byte header + 3 layers (AMER2.MP is this format).

---

## Round-trip verification

`tools/verify.py` enforces read→write byte-identity for *our tools*.
Note MAPEDIT itself is not byte-preserving (see `_forest_fix` above).

---

## Open work

- Layer-2 bits 3/6 exact game-side semantics (`_is_hostile` @0x44D1
  tests 0x48) — needs the VICEROY reader.
- Per-line annotation of VICEROY's .MP loader (find via the AMER2.MP
  string ref) — confirms the game reads the same three layers.
- One border-ring anomaly in AMER2.MP: a single ring tile with base id 3
  (Prairie) among the Ocean ring — likely original data quirk; harmless
  (ring is non-editable).


## VICEROY loader behavior (live-verified 2026-07-31, RULINGS batch 7)

- **Layer 2 (features) is DISCARDED on load** — VICEROY rebuilds the runtime feature plane
  (bit0 unit, bit1 settlement); crafted feature bytes never reach the renderer.
- **Border normalization on load**: rows 0 and h−1 → Arctic; columns 0, 1 and w−1 → Sea Lane
  for interior rows, overwriting even land (hard rule 2 enforced by the loader itself).
- Forest alias ids 16..23 are folded to 8..15 at load (matching MAPEDIT's `_forest_fix`).
