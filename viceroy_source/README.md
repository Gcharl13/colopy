# VICEROY.EXE — Reconstructed C Source

This is the **final-form C source** for VICEROY.EXE (Sid Meier's
Colonization, MicroProse 1994). The goal is reconstruction at the level
where, given a period-correct compiler (Microsoft C 6.0 / Borland C++ 3.x)
and a period-correct linker with RTLink/Plus overlay support, **building
this tree should yield a binary equivalent to the original VICEROY.EXE**.

It is NOT a port — there is no SDL, no modern C, no platform abstraction.
This is real-mode 16-bit DOS C code with explicit segment / far-pointer
usage where the original used it.

---

## Citation convention — every fact must trace back to the original

This is the central rule. Every function body, struct field, global
variable, and constant carries a citation comment that points back to:

1. **The disassembled bytes** in `../code/VICEROY/disasm/func_<6hex>_<name>.asm`
2. **The pseudo-C decompilation** in `../code/VICEROY/decompiled.md` (when present)
3. **The manual function metadata** in `../code/VICEROY/manual_funcs.json` (when present)

The citation comment format:

```c
/* @asm     0x008892..0x0088D0  (62 bytes)
 * @decomp  decompiled.md "find_pair_in_table_C8_DE"
 * @manual  manual_funcs.json index 5
 * @verified Boundary verified: ENTER 4 / LEAVE / RETF
 * @verbatim Reassembling this function with TASM 4.x in 16-bit mode
 *           reproduces the original 62 bytes byte-for-byte. */
int find_pair_in_table_C8_DE(uint16_t key1, uint16_t key2) { ... }
```

The minimum acceptable citation block is just the `@asm` line — but more
is encouraged. **Functions without a citation block are NOT acceptable
in this tree.**

For struct fields:
```c
struct colony_t {
    uint8_t  map_x;        /* @field +0x00; @ref decompiled.md "colony_t" */
    uint8_t  map_y;        /* @field +0x01 */
    ...
};
```

For globals:
```c
extern uint16_t g_map_width;   /* DGROUP:0x853A; @ref PROGRESS.md "Hot globals" */
```

For magic constants:
```c
#define COMMODITY_TOOLS  14   /* @ref decompiled.md "colony_turn_update" — Tools index in 0..14 commodity range */
#define UNIT_RECORD_STRIDE 0x1C  /* @ref FUNCTIONS_INVENTORY.md "UnitRecord" */
```

**No fabrication.** If a value can't be cited, mark it `TODO_VERIFY` so
the reviewer can catch it.

---

## Directory layout

```
viceroy_source/
├── README.md                          ← this file
├── COMPLETION.md                       ← status table per module
├── SESSION_LOG.md                      ← progress log across sessions
├── Makefile                           ← target: a byte-equivalent VICEROY.EXE
│
├── docs/                              ← Subsystem narrative documentation
│   ├── ARCHITECTURE.md                 ← top-level overview
│   ├── DATA_MODEL.md                   ← every struct, byte by byte
│   ├── MAP_SYSTEM.md                   ← terrain/feature/resource layers
│   ├── COLONY_SYSTEM.md                ← colonies, production, buildings
│   ├── UNIT_SYSTEM.md                  ← units, types, movement, cargo
│   ├── COMBAT.md                       ← combat resolution
│   ├── AI_SYSTEM.md                    ← AI driver + personality
│   ├── NATIVE_RELATIONS.md             ← tribes, missions, attacks
│   ├── EUROPEAN_DIPLOMACY.md           ← treaties, market
│   ├── KING_TAX.md                     ← king demands, REF buildup
│   ├── REVOLUTION.md                   ← independence + REF deployment
│   ├── FOUNDING_FATHERS.md             ← 25 fathers + Congress
│   ├── RANDOM_EVENTS.md                ← LCR / weather / disease
│   ├── MAP_GENERATION.md               ← procedural map algorithm
│   ├── SCORING.md                      ← final score formula
│   ├── RENDER_CHAIN.md                 ← pixel pipeline (func_O514..O512)
│   ├── ASSET_ROLES.md                  ← every asset → loader function
│   ├── RTLINK_OVERLAYS.md              ← RTLink format spec
│   └── ENGINE.md                       ← madsdev.lib API
│
├── formats/                           ← Byte-level format specs
│   ├── README.md                       ← format index
│   ├── PAL.md, SS.md, PIK.md, FF.md, MP.md, TXT.md, DAT.md, COL.md,
│   ├── BIN.md, MOV.md, PCX.md, GIF.md, MADSPACK.md
│   └── (one per file extension)
│
├── include/                            ← Shared headers
│   ├── viceroy.h                       ← master / convenience include
│   ├── viceroy_types.h                 ← primitive typedefs
│   ├── colony.h                        ← ColonyRecord + colony_t
│   ├── unit.h                          ← UnitRecord + cargo helpers
│   ├── power.h                         ← PowerRecord (stride 0x13C)
│   ├── building.h                      ← BuildingId enum + costs
│   ├── ff.h                            ← Founding Father table
│   ├── ai_personality.h                ← AIPersonality
│   ├── market.h                        ← MarketState + pricing
│   ├── native.h                        ← NativeSettlement
│   ├── save.h                          ← save file structure
│   ├── globals.h                       ← all DGROUP globals
│   ├── iolib.h, format.h               ← C lib wrappers
│   ├── runtime.h, rtlink.h, dos.h      ← runtime/loader/system
│   └── overlay_externs.h               ← all overlay function externs
│
├── data/                              ← Initialized DGROUP tables
│   ├── README.md                       ← table index
│   ├── terrain_yield.c                 ← 21 terrain × 16 occupations
│   ├── unit_classes.c                  ← 45 unit type stat table
│   ├── building_costs.c                ← 39 building cost table
│   ├── ff_effects.c                    ← 25 Founding Father table
│   ├── kings_demands.c                 ← 7-stage king tax escalation
│   ├── scenario_starts.c               ← stock-map starting positions
│   ├── commodity_prices.c              ← 16 commodity market params
│   └── tribe_data.c                    ← 8 tribe parameter table
│
├── src/
│   ├── boot/                           ← entry.c (DOS entry → cstart)
│   ├── runtime/                        ← cstart.c (C runtime startup)
│   ├── overlay/                        ← rtlink.c, dispatch_thunks.c
│   ├── load_image/                     ← all overlay-resident loaders (16 files)
│   ├── asset/                          ← asset_loader.c (centralised API)
│   ├── colony/                         ← turn_update, assignment, accessors,
│   │                                      commodity
│   ├── unit/                           ← cargo.c
│   ├── map/                            ← (delegated to load_image/)
│   ├── render/                         ← tile_chain.c (func_O514..O512),
│   │                                      terrain.c, units.c, hud.c
│   ├── ui/                             ← title_screen, colony_screen,
│   │                                      europe_screen, dialog,
│   │                                      hall_of_fame, main_loop
│   ├── audio/                          ← audio_device.c, sound_dispatch.c
│   ├── save/                           ← save_serializer.c, load_deserializer.c
│   ├── ai/                             ← driver.c, unit_orders.c,
│   │                                      colony_orders.c
│   ├── combat/                         ← resolve.c, modifiers.c, demotion.c
│   ├── diplomacy/                      ← treaty.c, relations.c
│   ├── market/                         ← pricing.c, boycott.c
│   ├── mapgen/                         ← generator.c, climate.c, rivers.c,
│   │                                      settlements.c
│   ├── native/                         ← settlement.c, raid.c, mission.c
│   ├── founding_fathers/               ← recruit.c, effects.c
│   ├── king/                           ← demands.c, ref.c
│   ├── scoring/                        ← compute.c, endgame.c
│   ├── random_events/                  ← lcr.c, weather.c, disease.c
│   ├── iolib/                          ← file.c, format.c
│   └── data/                           ← production.c (legacy slot)
│
└── obj/                               ← build artifacts (.OBJ)
```

---

## Status

This is incrementally populated. See `COMPLETION.md` for the per-module
status. Every function's status is one of:

- **DONE**: complete, citation-backed, byte-verifiable
- **PARTIAL**: written but with TODO markers (e.g. for unresolved overlay calls)
- **STUB**: function declared with body `{ /* TBD: see func_<offset>.asm */ }`
- **TBD**: not yet started

The total tree will not be complete in a single session. The plan in
`COMPLETION.md` shows the order: boot/runtime first (smallest, best
understood), then colony / unit (the largest decoded slice), then map
(small), then I/O lib (medium), then the overlay (largest unknown).

---

## Building (notional)

```
$ cd viceroy_source
$ make all          # produces obj/VICEROY.EXE
$ make verify       # diffs against ../raw/COLONIZE/VICEROY.EXE; should be byte-identical
```

The Makefile is a placeholder — it documents the build steps without
actually shelling out to a 16-bit DOS toolchain. Reproducing the
byte-for-byte original requires a period-correct toolchain that is
not part of this project.

---

## Reading order for a reviewer

1. `README.md` (this file)
2. `COMPLETION.md` (what's done)
3. `include/colony.h` (the heart of the data model)
4. `include/unit.h`, `include/globals.h`
5. `src/boot/entry.c` (the program's entry point)
6. `src/colony/turn_update.c` (the most-decoded big function)
7. `src/colony/assignment.c` (the second-most-decoded big function)
8. `src/iolib/file.c` (the asset-loader gateway)

Anything else is supporting detail.
