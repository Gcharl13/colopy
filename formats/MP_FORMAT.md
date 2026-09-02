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
  finder. In AMER2.MP the ring is Ocean (25) except **21 Prairie (id 3)
  tiles, all in row 0** (x = 1..18, 23, 24, 27 — census 2026-09-02; the
  earlier "a single ring tile" count was wrong). VICEROY overwrites row 0
  with Arctic at load (§"VICEROY loader behavior"), so they never show.
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

**VICEROY.EXE** — annotated 2026-09-02 (REMAINING_WORK.md G5; file
offsets into `VICEROY.EXE`, DGROUP strings relative to file `0x1D9A0`;
thunks resolved with `tools/follow_thunk.py`):

- **`func_071106` = map_load_file** (thunk `0x1A1F:0xC8E`, caller
  `new_game_state_init` `@0x75733`). Name: appends the default extension
  `[0x154]` = `"mp"` when there is no `'.'` (`lcall 0x1a1f,0xcaa` `@0x7111B`
  → `func_00D77C`), `fopen([0x8554], "rb")` (`lea bx,[0x208e]` `@0x71124`,
  `lcall 0x181f,0xe86` `@0x71128`; error `[0x158]=1` `@0x71134`). `[0x8554]`
  is `strcpy`'d from `[0x2166]` = `"AMER2.MP"` (file `0x1FB06`)
  `@0x755D1–0x755D7`; the MAPTOLOAD picker (`push 0x2357 "*.MP"; push 0x235c
  "MAPTOLOAD"; push 0x2366 "GAME"` `@0x75D0A–0x75D14`) overwrites it and sets
  `[0x2174]=1` when the choice differs from `"AMER2.MP"` (`@0x75D2A–0x75D44`).
- **Header**: `fread(0x853A, 4, 1)` `@0x7113E–0x71146` → `[0x853A]` width,
  `[0x853C]` height (error 2 `@0x71152`); `fread(&ver, 2, 1)`
  `@0x7115C–0x71167`; **`ver` must be 4** — `cmp [bp-4],4; jg 0x7117b; jge
  0x7118c` `@0x71173–0x71179`: any other value reaches `@0x7117B`, which
  errors with 3 (`@0x71182`) unless `[0x152] < 0` (`[0x152]` = last-loaded
  version, initially 0 — so in practice ver ≠ 4 → error 3); then
  `[0x152] = ver` `@0x7118F`; `w·h` → `[0x85A4:0x85A6]` `@0x71192–0x7119C`.
- **Size gate** `func_0710C2` (`ljmp 0x1a1f:0xc64` `@0x7147C`):
  `[0x15A] = (w·h > 0x2EE0)` `@0x710CB–0x710E4`; if set, error `0x270F` (9999)
  `@0x710F1` — the same cap as MAPEDIT.
- **Three layer reads of `w·h` bytes**, each `push seg; push off; push 0;
  push 1; mov ax,[0x85a4]; mov dx,[0x85a6]; mov bx,fp; lcall 0x1a1f,0xcb4`
  (→ `func_00D41E` fread): terrain → `[0x15C:0x15E]` `@0x711B1–0x711C6`
  (error 4), feature → `[0x160:0x162]` `@0x711D8–0x711EE` (error 5),
  continent → `[0x164:0x166]` `@0x71200–0x71216` (error 6). **Nothing else
  is read**: `call 0x70fa0` `@0x71230` only publishes the plane pointers and
  dims into the surface structs `[0x85A8..0x85C6]`; `fclose` `@0x7123C`.
  Error codes `[0x158]`: 1 open, 2 header, 3 version, 4/5/6 layers,
  9999 too big — the same table as MAPEDIT's.
- **`func_071246` = map_save_file** (`"wb"` = `0x2091` `@0x71264`): `fwrite`
  w,h (4 bytes, `0xd1d:0x60c` `@0x71286`), version `[0x152]` (2 bytes
  `@0x712AD`), then the three layers via `lcall 0x1a1f,0xc9c` (→
  `func_0775EC` chunked write) `@0x712DD` / `@0x71304` / `@0x7132C`.
- **`func_071350` = map_create_blank(w,h)**: memset layer 1 to `0x19` Ocean,
  layers 2/3 to 0 (`push 0x19 … lcall 0xd1d,0x11fa` `@0x71385–0x7138F`;
  `push 0` `@0x7139B`/`@0x713B1`), `[0x152]=4` `@0x713C8` — mirrors MAPEDIT's
  `_create_blank_map`.
- **`func_0713D4` = map_load_default** (thunk `0x1A1F:0xC80`, called
  `@0x7571C` for every new game): if `[0x18C]==0` (a file map — the
  random-world path sets `[0x18C]=1` and 58×72 `@0x756FC–0x75708`) it opens
  `[0x8554]` (`lea bx,[0x2094]` `"rb"` `@0x713FF`), presets **120×75**
  (`0x78`, `0x4B`, `0x2328` tiles `@0x7140B–0x7141D`), reads **only the
  4-byte w/h header** `@0x71427–0x7142F`, allocates the four runtime planes
  via `func_070FF8` (`call 0x71481` → `ljmp 0x1a1f:0xc72`: terrain
  `[0x15C]`, feature `[0x160]`, continent `[0x164]`, fog `[0x168]`
  `@0x7104C–0x710A5`) and closes; the layers themselves are read afterwards
  by `func_071106`.

So VICEROY accepts exactly the writer's layout: 6-byte header + 3 layers,
nothing after. The post-load normalisation is in §"VICEROY loader behavior".

---

## Round-trip verification

`tools/asset_codecs.py` (`mp_decode` / `mp_encode`, used by
`tools/extract_mp.py` / `encode_mp.py`) re-emits the six-byte header and
the three layers; `tools/verify_assets.py` checks it bit-exact against
`raw/COLONIZE/AMER2.MP` under `make test` (2026-09-02, G6). `tools/verify.py`
is the byte-identity check against the golden manifest. Note MAPEDIT itself
is not byte-preserving (see `_forest_fix` above).

---

## Open work (rewritten 2026-09-02 — the three earlier bullets are settled)

- ~~Layer-2 bits 3/6 exact game-side semantics (`_is_hostile` @0x44D1
  tests 0x48) — needs the VICEROY reader.~~ **Moot for VICEROY**: layer 2
  is zeroed at load (`@0x65AA5–0x65AB7`, below) before play, so file bits
  never reach the game. What `_is_hostile` tests is the *runtime* feature
  plane that the game itself writes — a MAPEDIT-side question only.
- ~~Per-line annotation of VICEROY's .MP loader.~~ Done — §"Read/write entry
  points" (`func_071106` reads exactly the same three layers).
- ~~One border-ring anomaly: a single Prairie ring tile.~~ Corrected: 21
  Prairie tiles, all in row 0, overwritten by the Arctic row fill at load.
- **Still open**: `[0x1E9F]` = `"P"` is `strcat`'d to a custom map name
  `@0x65EBB` before a sidecar open `@0x65ECF` (`<MAP>.MPP`?) — not traced.

## The three former `TODO_VERIFY` items — settled 2026-09-02 (REMAINING_WORK.md G8, RULINGS 2026-09-02e)

Commit d87e9bb's version of this file carried three `TODO_VERIFY` notes;
8ba0e1d rewrote the file from the MAPEDIT writer and dropped the markers
without settling them. Each is now decided against VICEROY's bytes and the
raw `AMER2.MP` (file offsets into `VICEROY.EXE`):

1. *"bit 7 (0x80) = possibly 'explored by player 0' flag"* → **No.** Bit 7 is
   the Mountains-vs-Hills / Major-vs-Minor-river modifier: `func_00624E`
   `@0x6254–0x6266` (`test bl,0x20 … and ax,0x80; cmp ax,1; sbb dx,dx; and
   dx,1; add dx,0x1b` → 27 when bit 7 is set, 28 otherwise) and the river
   draw `@0x68397` (`test byte [0xa8a1],0x80` selects the major-river form).
   Exploration is a **separate runtime plane** `[0x168]` (allocated
   `@0x7109D`, zeroed at load `@0x65ABC`) with one bit per power
   (`add cl,4; mov al,1; shl al,cl` `@0x685F2–0x685F7`). Census: no byte in
   AMER2.MP has bit 7 set without bit 5 or 6.
2. *"forest bit 0x40, redundant with ids 8..15, set for all forested
   tiles?"* → **No.** `0x40` is the **river** bit (VICEROY's river gate
   `test byte [0xa8a1],0x40` `@0x6838A`; MAPEDIT paint masks above). Forest
   lives only in the id: AMER2.MP carries 687 tiles with ids 16..23, folded
   to 8..15 at load (`@0x65A4E–0x65A85`) and at read
   (`func_006204` `@0x6216–0x622A`).
3. *"exact post-tile-array layout (Colony/Unit/Native array order and
   counts)"* → **There is none.** The loader reads the header and exactly
   three `w·h` layers and stops (`func_071106`, `fclose` `@0x7123C`); the
   writer emits the same (`func_071246`); 6 + 3·58·72 = 12,534 = the file
   size. Those records belong to save games (`spec/systems/save.md`).

## VICEROY loader behavior (byte-verified 2026-09-02; supersedes the live-verified 2026-07-31 note)

For a **file map** (`[0x18C]==0`) `new_game_state_init` and the arg-gated
branch of `func_064A10` normalise the terrain plane after `func_071106` has
read it. In order (all sites re-read from the listing; `0x181F:0xBA` →
`func_00DDEA` rect-fill, `0x181F:0xCE` → `func_00E0A2` rectangle *outline* —
two hlines then two vlines `@0xE0E2/@0xE100/@0xE11E/@0xE13C`):

1. **Rows 0 and h−1 → Arctic (`0x18`)**: `push 1; push 0x18; ax=0, dx=0,
   bx=w; lcall 0x181f,0xba` `@0x75746–0x75761`, again with `dx=h−1`
   `@0x75766–0x75785`.
2. `push [bp+6]; lcall 0x1a1f,0x83e` `@0x7579B` → `func_064A10`. It first
   draws `random_int(1, 0x7FFF)` into `[0x190]` (`@0x64A16–0x64A23` — **one
   RNG draw even for a file map**), then `cmp word [bp+6],0; je …; jmp
   0x65941` `@0x64A2C–0x64A32` skips generation.
3. **Sea-Lane outlines (`0x1A`)**: `(0,0)–(w−1,h−1)` `@0x65941–0x65960`, then
   `(1,0)–(w−2,h−1)` `@0x65965–0x65986`. Net: **columns 0, 1, w−2 and w−1**
   become Sea Lane (the 2026-07-31 note said "0, 1 and w−1" — corrected).
4. **Rows 0 and h−1 → Arctic again** `@0x6598B–0x659CA` (so the corners and
   the top/bottom of the ring end as Arctic, not Sea Lane).
5. **Per-tile fold** `@0x659CF–0x65A9D`: `base = byte & 0x1F` `@0x65A10`;
   skip `base ≥ 0x18` `@0x65A15`; if bit `0x20` (hills/mountains) is set →
   `byte = (byte & 0xE0) | (base & 7)` `@0x65A1A–0x65A45` (forest stripped
   under an overlay, flags kept); else if `0x10 ≤ base < 0x18` →
   `base −= 8` `@0x659D8–0x659E0` → `@0x65A4E–0x65A85`.
6. **Layer 2 (feature) memset 0** `@0x65AA5–0x65AB7`; **fog plane memset 0**
   `@0x65ABC–0x65ACE` (`0x181F:0x484`).

So crafted feature bytes never reach the renderer, rows 0/h−1 are Arctic
for **every** file map regardless of content, and hard rule 2 is enforced
by the engine itself. AMER2.MP already satisfies most of it (column 56 =
Sea Lane in all 70 interior rows, column 57 = Ocean, column 0 = Ocean,
column 1 mixed) — the load pass is what makes columns 0/57 Sea Lane and
row 0 Arctic on screen. Neither port applies this pass yet
(REMAINING_WORK.md G12).
