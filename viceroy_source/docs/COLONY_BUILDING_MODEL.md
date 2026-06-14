# Colony Building Display — Data Model (BYTE_VERIFIED + empirically confirmed)

How the colony screen decides **which building is drawn where, and why**. Every
claim here is grounded in the VICEROY.EXE disassembly (`re_work/disasm/`) and
cross-checked against real saves (`COLONY0x.SAV`). This exists so the work is
never re-derived from guesses.

## The chain, end to end

```
ColonyRecord+0x84 bit-array   ──q9fc──►  func_025D34 (layout)  ──►  0x8E82[slot]
   (which buildings exist)               (which slot, shuffled)      (good index)
                                                                         │
   0x266[slot] (x,y) ◄── func_02701C painter ──► func_026DD4 ◄──────────┘
                                                 frame = good+1 (1-based)
                                                 → BUILDING.SS sprite
```

## 1. Which buildings a colony has — `ColonyRecord+0x84` bit-array

`q9fc(b)` = `test_building_or_father_bit(b)` = `func_0863E` →
`func_0860E`: tests bit `b` of the byte array at
`0x5DCA + colony_idx*0xCA` (= `ColonyRecord+0x84`, stride 202).
Bit `b` set ⇒ the colony owns `@BUILDING[b]` (NAMES.TXT order, 0..41).

Empirically verified — COLONY00.SAV colony 0 (Jamestown, pop 10) bit-array
`CF B2 22 09 99 00 00 00` decodes to: Stockade, Fort, Fortress, Armory, Docks,
Drydock, Town Hall, Schoolhouse, College, Warehouse, Stable, Weaver's House,
Tobacconist's House, Rum Distiller's House, Fur Trader's House, Carpenter's
Shop, Lumber Mill, Blacksmith's House — a coherent pop-10 structure set.

**The modern bug:** `overlay_call_181F_09FC` was a weak return-0 stub, so no
colony ever reported a structure. Now overridden (`production_support.c`) to
forward to `test_building_or_father_bit`.

## 2. The 42 `@BUILDING` records — NAMES.TXT, table at DGROUP `0x8F82` (stride 12)

Loaded by `func_0749E0` (@BUILDING section) + `func_0746BC` (topology). Fields:

| off | DGROUP | field | source |
|----|--------|-------|--------|
| +0x00 | 0x8F82 | name_token | @BUILDING name |
| +0x05 | 0x8F87 | **back_ref = display category 0..4** | @BUILDING 3rd number |
| +0x06 | 0x8F88 | **column = building-line id 0..0xE** | func_0746BC tuple |

15 building **lines** (column 0..0xE), tiers within a line share a column.
Lines group into 5 **categories** by `back_ref`:

| cat | #lines | lines |
|----|--------|-------|
| 0 | 7 | CustomHouse, PrintingPress, Weaver, Tobacconist, RumDistiller, FurTrader, Blacksmith |
| 1 | 4 | Armory, Schoolhouse, Warehouse(+Stable), Carpenter(+LumberMill) |
| 2 | 2 | Town Hall, Church |
| 3 | 1 | Stockade/Fort/Fortress |
| 4 | 1 | Docks/Drydock/Shipyard |

Cross-check: category counts `[7,4,2,1,1]` == DGROUP `0x224` exactly.

**The modern bug:** neither `func_0746BC` (column) nor the @BUILDING loader
(back_ref) runs at boot — both setters are stubbed. `colony_building_config_init`
(`overlay_024342_027B62.c`) now populates `0x8F87`/`0x8F88` from these verified
values; called once at boot (`main_modern.c`).

## 3. Slot layout — `func_025D34` (`colony_draw_random_layout`)

15 display slots, screen (x,y) in DGROUP `0x266` (stride 4, in the EXE image).
`0x224[5]=[7,4,2,1,1]` slots/category, `0x22A[5]=[0,7,11,13,14]` first-slot.

1. **FLATTEN** `0x8D62[base[c]+k]=c` → per-slot category map
   `[0,0,0,0,0,0,0,1,1,1,1,2,2,3,4]` (also the painter's TYPE byte).
2. **CLAIM** for each slot i, random free slot in its category → `0x8E92[slot]=i`
   (shuffle within category; `random_int` = `0x181F:0x4D4`).
3. **ASSIGN** each column a slot-index: `claimed[col]=base[cat]+row_used[cat]++`
   (first/base tier per column decides).
4. **PLACE** each present good i (q9fc): `0x8E82[ 0x8E92[claimed[col_i]] ] = i`.
   Tiers share a column → highest-index (top tier) wins the slot.

So a colony shows exactly its set of building **lines** (top tier of each),
each in a random slot of its size-category. Jamestown → 12 lines → 12/15 slots.

**The modern bug:** the prior `.c` reconstruction wrote the wrong offsets
(`0x8D62[k]=val`). Rewritten byte-faithful 2026-06-14.

`func_009726` (0x181F:0xD62, "begin pass") seeds the layout RNG from the colony
position for stable layouts; it derefs unwired resident seed leaves
(`0x9EF:0x1A/0x2C`) and is currently skipped (layout still correct, global RNG).
TODO: wire the seed leaves for per-colony layout stability.

## 4. Sprite — `func_026DD4`

Base sprite `frame = good_index + 1` (1-based) from the sheet at `[0x2DA8]`
(BUILDING.SS, 48 frames). Modern `ss_blit`/`ss_blit_remap` is 0-based, so
`frame_0based = good_index`. Wall perimeter has special frames (0x11/0x2F/0x30,
1-based) gated by `q9fc(0)/q9fc(0xF)/q9fc(0x11)`. `col_bldg_frame` in
`ui/colony_screen.c` returns `good_index` for the 0-based blit.

## Verification harness

`main_modern.c` headless colony frame injects Jamestown's real `+0x84` bits into
the test ColonyRecord, runs `colony_draw_random_layout`, and paints the plot →
`viceroy_colony.ppm`. 12/15 slots fill (Jamestown's 12 lines), Church/Custom
House/Printing Press correctly absent.
