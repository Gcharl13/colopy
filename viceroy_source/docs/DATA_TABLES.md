# Data tables: EXE-embedded vs runtime-loaded (RESOLVED, byte-verified 2026-06-07)

This resolves the recurring "the data-table offsets are wrong" problem. The 8
balance tables prior sessions tried to pin to DGROUP offsets (`0x05000`,
`0x06530`, `0x07A00`, `0x09800`, `0x0B400`, `0x07D00`, `0x08400`, `0x01DB32`)
**are not embedded in VICEROY.EXE at all.** They are loaded at runtime from the
`COLONIZE/*.TXT` data files into BSS.

## DGROUP layout (byte-verified)

```
DS segment (load-module-relative) = 0x1B5A          DGROUP:0 == file 0x1D9A0
  proof: SMITEINDIANS is PUSHed as imm 0x1a1a and sits at file 0x1f3ba;
         0x1f3ba - 0x2400 - 0x1a1a = 0x1B5A0 = 0x1B5A<<4.

  DS 0x0000 .. 0x2CC5   initialized _DATA   -> file 0x1D9A0 .. 0x20665 (in EXE)
  DS 0x2CC5 ..          _BSS                -> zero-filled at start (NOT in EXE)
```

The initialized window ends exactly at the overlay boundary (file 0x20665, the
image_len). Anything the code addresses at a DS offset `>= 0x2CC5` is BSS:
`unit_table` 0x3144, `colony bits` 0x5DCA, `combat stat columns` 0x5235/0x5236,
`tribe_data` 0x59D8, `PowerRecord` 0x8808, `building chain` 0x8F86, `map_width`
0x853A, etc. — all BSS, all populated at runtime.

## The balance tables are EXTERNAL

VICEROY.EXE opens and parses these text data files (filename strings + xref code
sites verified in `re_work/strings.json`):

| File | filename string (file off / DG off) | parser xref sites |
|------|-------------------------------------|-------------------|
| `NAMES.TXT`  | 0x1e222 / 0x0882 | code @0x749F6, @0x74F6C |
| `COLONY.TXT` | 0x1e540 / 0x0ba0 | @DG 0x0ba0, 0x1453 |
| `TRIBE.TXT`  | 0x1f835 / 0x1e95 | @DG 0x1e95 |
| `GAME.TXT`   | 0x1e21c / 0x087c | 12 xref sites |

NAMES.TXT holds the `@UNIT`, `@CARGO`, `@TERRAIN`, `@BUILDING`, `@FATHERS`,
`@TRIBE` sections (the prior project's `extracted/text/NAMES_sections.json` was
derived from it). The parser writes the records into the BSS tables above.

**Consequence:** terrain_yield, unit_classes, commodity_prices, tribe_data,
ff_effects, kings_demands and scenario_starts **cannot be byte-verified from
VICEROY.EXE alone.** To complete them, supply the `COLONIZE/*.TXT` files; then
the values become byte-facts read from those files (and cross-checked against the
BSS write sites in the parser). Until then they are `[TBD — external]`. The
`data/*.c` balance files now carry that banner; only their struct *layouts*
(strides, field order — byte-anchored from accessors) are trustworthy.

## What IS embedded and byte-verified (`data/embedded_control_tables.c`)

The EXE *does* embed small control tables (logic, not balance):

| Table | DS off | file off | accessor (cited) | role |
|-------|--------|----------|------------------|------|
| `NEIGHBOR_DX[8]` | 0x00B4 | 0x1DA54 | `mov al,[bx+0xb4]` @0x07091, loop `cmp [bp-4],8` @0x07088 | tile adjacency Δx (N,NE,E,SE,S,SW,W,NW) |
| `NEIGHBOR_DY[8]` | 0x00BE | 0x1DA5E | `mov al,[bx+0xbe]` @0x0709B | tile adjacency Δy |
| `MAP_DELTA_C8[10]` | 0x00C8 | 0x1DA68 | same map-helper family | second delta table (role TBD) |
| `GOOD_TO_CHAIN_BIT[19]` | 0x02F4 | 0x1DC94 | func_008D9C `cmp [bp+6],0x13; mov al,[bx+0x2f4]; cwde` | building-chain id per commodity |
| `GOOD_TO_RAW_INPUT[19]` | 0x02A2 | 0x1DC42 | colony net-flow helpers | raw-material id per finished good |

Values:
```
NEIGHBOR_DX        =  0  1  1  1  0 -1 -1 -1
NEIGHBOR_DY        = -1 -1  0  1  1  1  0 -1
GOOD_TO_CHAIN_BIT  = -1×9, 1b 18 15 20 23 27 03 25 09 0c
GOOD_TO_RAW_INPUT  = -1×8, 08 01 02 03 04 -1 06 0e 05 -1 -1
```

These are registered in `tools/audit.py` and re-verified on every run.

## Other embedded `tab` runs (catalogued, mostly geometry/jump-tables)

`tools/dgroup_map.py` lists 54 non-string runs in the initialized window. Beyond
the control tables above, the notable ones are screen-geometry word arrays
(e.g. file 0x1dcfb, 1145 B of layout coords) and code-segment jump tables
(colony-services 22-entry @0x028AF0, report F-key dispatch). These are decoded
where a consuming function needs them, not en masse.
