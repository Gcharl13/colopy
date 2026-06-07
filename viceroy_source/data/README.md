# Data tables — where they actually live (RESOLVED 2026-06-07, byte-verified)

> **The prior version of this file was wrong** and is the source of a
> long-standing confusion. It claimed the balance tables sit at DGROUP offsets
> `0x05000 / 0x06530 / 0x07A00 / 0x09800 / 0x0B400 / 0x07D00 / 0x08400`. Those
> offsets are in the **code** region — DGROUP initialized data does not begin
> until **file 0x1D9A0** (= `DS:0x0000`, segment 0x1B5A). See
> `../docs/DATA_TABLES.md` for the full byte-level resolution.

## The two kinds of "table"

VICEROY.EXE's DGROUP splits at the end of initialized data, **DS:0x2CC5**
(= file 0x20665, the overlay boundary):

| Region | DS range | In the EXE file? | What's there |
|--------|----------|------------------|--------------|
| Initialized `_DATA` | `0x0000..0x2CC5` | **yes** (file `0x1D9A0..0x20665`) | strings + small **control** tables (adjacency deltas, per-good id maps, jump tables, geometry) |
| `_BSS` | `0x2CC5..` (e.g. 0x5235, 0x59D8, 0x8808, 0x8F86) | **no** (zero-filled at startup) | the **balance** tables, populated at runtime from the `COLONIZE/*.TXT` data files |

### The balance tables are EXTERNAL (not in VICEROY.EXE)

Unit stats, terrain yields, commodity prices, tribe data, founding-father data,
king demand schedules and scenario starts are **not** static bytes in the EXE.
They live in the game's text data files and are parsed into BSS buffers at load
time:

| Data file | Loaded by (file offset) | Fills (BSS base) |
|-----------|-------------------------|------------------|
| `NAMES.TXT`  | func @0x749F6, @0x74F6C (page 0x1A) | @UNIT/@CARGO/@TERRAIN/@BUILDING/@FATHERS/@TRIBE sections |
| `COLONY.TXT` | xref @DG 0x0ba0 / 0x1453 | colony/production text + tables |
| `TRIBE.TXT`  | xref @DG 0x1e95 | native tribe records → DGROUP 0x59D8 (stride 78) |
| `GAME.TXT`   | xref @DG 0x087c (12 sites) | game-rule option bitmaps 0x5382.. |

So **their numeric values cannot be byte-verified from VICEROY.EXE alone** — they
require the `COLONIZE/*.TXT` files (the prior project's
`extracted/text/NAMES_sections.json` came from those). Until those are supplied,
every value in the `*.c` files below is `[TBD — external data file]`, NOT a
byte-fact. Each file now carries that banner; the struct *layouts* (strides/field
order, byte-verified from the accessors) are the reusable part.

### The embedded control tables ARE in the EXE (byte-verified)

See `embedded_control_tables.c` — these are real DGROUP bytes with cited
accessors:

| Table | DS off | file off | shape | accessor | meaning |
|-------|--------|----------|-------|----------|---------|
| 8-neighbour Δx | 0x00B4 | 0x1DA54 | 8×i8 | `mov al,[bx+0xb4]` @0x07091 | tile adjacency dx, dirs N..NW |
| 8-neighbour Δy | 0x00BE | 0x1DA5E | 8×i8 | `mov al,[bx+0xbe]` @0x0709B | tile adjacency dy |
| good→chain-bit | 0x02F4 | 0x1DC94 | 19×i8 | `mov al,[bx+0x2f4]` @0x08DAE (func_008D9C) | building-chain id per commodity |
| good→raw-input | 0x02A2 | 0x1DC42 | 19×i8 | (commodity_net helpers) | raw-material id per finished good |

## The `*.c` files in this directory

`terrain_yield.c`, `unit_classes.c`, `building_costs.c`, `ff_effects.c`,
`kings_demands.c`, `scenario_starts.c`, `commodity_prices.c`, `tribe_data.c` —
**layout-only**. Values are `[TBD — external]` pending the `.TXT` data files.
`embedded_control_tables.c` — **BYTE_VERIFIED** real EXE tables.
