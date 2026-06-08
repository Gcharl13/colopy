> **>>> RECONSTRUCTED — NOT BYTE-VERIFIED <<<**
>
> The formulas, tables, and specific numbers in this document are reconstructed
> from accumulated playthrough knowledge and prior reverse-engineering notes.
> They have **not** been confirmed by reading bytes from VICEROY.EXE.
>
> Treat every numerical claim as RECONSTRUCTED until cross-referenced to a
> hand-decompiled function in `code/VICEROY/decompiled.md` or to bytes
> documented in `viceroy_source/VERIFICATION_LEDGER.md`.

# Data Model — Every struct, byte by byte

This document is the authoritative reference for the in-memory and on-disk
record layouts of VICEROY.EXE. It supersedes any earlier struct sketches in
`COLONIZATION_TECHNICAL_REFERENCE.md` where they conflict.

All offsets are little-endian (Intel x86), all multi-byte fields are LSB-first.

---

## 1. Power record (per-nation state) — 316 bytes (0x13C)

Stored in the **PowerTable** at DGROUP file offset `0x05248`. Indexed by
power id (0..7); slots 0..3 are the four playable European powers, slots
4..7 are reserved (used internally by AI / scratch).

> ## ⚠️ CORRECTED 2026-05-30 — the PowerRecord body below is the OLD reconstructed layout
> Byte-verification overturned several fields. `controller` is **NOT** in PowerRecord (it is
> **AIPersonality +0x31 = abs 0x543F**); `difficulty` is a **global (0x53A6)**, not per-power.
> The **byte-verified** PowerRecord (base 0x8808, stride 0x13C) is:
> `+0x01` tax_rate · `+0x02` rebel_pct · `+0x07` FF bitmap · `+0x0C/+0x0E` bells (current/total) ·
> `+0x14` FF count · `+0x20` boycott bitmap · **`+0x2A` gold (dword)** · `+0x2E` per-power bells
> tally · `+0x34` war matrix (abs 0x883C) · `+0x4C` price_level byte[16].
> Authoritative struct model: **`reverse_engineered/docs/DATA_MODEL.md` (sibling) + `include/*.h`**
> + `decompile_status.html`. (The NAMES.TXT @section table appended lower in THIS file IS verified.)

```c
struct PowerRecord {            /* 316 bytes (0x13C) -- BODY BELOW IS STALE; see banner above */
    uint8_t  power_id;          /* 0x00  0=England 1=France 2=Spain 3=Dutch  [verified] */
    uint8_t  tax_rate;          /* 0x01  CORRECTED (was "controller" -> that's AIPersonality+0x31) */
    uint8_t  rebel_pct;         /* 0x02  CORRECTED (was "difficulty" -> that's global 0x53A6) */
    uint8_t  flags;             /* 0x03  bit0=in_revolution, bit1=king,
                                          bit2=defeated, bit3=ai_done_turn */

    /* Treasury and accumulated economy */
    int32_t  treasury;          /* 0x04  current gold reserve */
    int32_t  treasury_last;     /* 0x08  last turn's treasury for delta */
    int16_t  tax_rate;          /* 0x0C  king's current tax rate (0..75) */
    int16_t  rebellion_pct;     /* 0x0E  cumulative SoL across colonies */
    int16_t  tory_pct;          /* 0x10  100 - rebellion_pct */
    int16_t  bells_total;       /* 0x12  liberty bells produced this game */
    int16_t  crosses_total;     /* 0x14  crosses produced (immigration) */
    int16_t  next_immigrant;    /* 0x16  unit type ID waiting on dock */
    int16_t  recruit_cost;      /* 0x18  current cost to buy from Europe */

    /* Colony / unit counts (cached) */
    int16_t  colony_count;      /* 0x1A  number of active colonies */
    int16_t  unit_count;        /* 0x1C  number of active units */
    int16_t  population;        /* 0x1E  total colonist count */

    /* Founding-fathers bitmask + counts */
    uint32_t ff_owned_lo;       /* 0x20  bitmask FF 0..31 (only 25 used) */
    uint32_t ff_owned_hi;       /* 0x24  reserved (bitmask FF 32..63) */
    int16_t  ff_recruiting_idx; /* 0x28  next FF in recruiting queue or -1 */
    int16_t  ff_progress;       /* 0x2A  bells accumulated toward next FF */
    int16_t  ff_required;       /* 0x2C  bells required for next FF */

    /* European market state — 16 commodities × variable bytes */
    int16_t  buy_price[16];     /* 0x2E..0x4D   2 × 16 = 32 bytes */
    int16_t  sell_price[16];    /* 0x4E..0x6D */
    int16_t  market_volume[16]; /* 0x6E..0x8D   total carried in market */
    int16_t  player_traded[16]; /* 0x8E..0xAD   net player buy/sell */
    uint8_t  boycotted[16];     /* 0xAE..0xBD   1 = under boycott */

    /* European population (recruitable units) — pool sizes */
    int16_t  recruit_pool[8];   /* 0xBE..0xCD   per-unit-type queue sizes */

    /* Diplomatic relations with the other 3 powers */
    int16_t  rel_state[8];      /* 0xCE..0xDD   0=peace,1=war,2=alliance */
    int16_t  rel_score[8];      /* 0xDE..0xED   relationship score -100..100 */

    /* Native relations (8 tribes) */
    int16_t  tribe_state[8];    /* 0xEE..0xFD   0..3 (peace..war) */
    int16_t  tribe_attitude[8]; /* 0xFE..0x10D  per-tribe -100..100 */

    /* King / Royal Expeditionary Force */
    int16_t  ref_regulars;      /* 0x10E  REF veterans */
    int16_t  ref_dragoons;      /* 0x110  REF cavalry */
    int16_t  ref_artillery;     /* 0x112  REF artillery */
    int16_t  ref_manowar;       /* 0x114  REF naval squadrons */
    int16_t  king_anger;        /* 0x116  king's anger meter 0..100 */
    int16_t  last_demand_turn;  /* 0x118  turn # of last tax demand */
    int16_t  pending_demand;    /* 0x11A  current king demand id (or -1) */

    /* Score components (recomputed end-of-turn) */
    int16_t  score_pop;         /* 0x11C */
    int16_t  score_gold;        /* 0x11E */
    int16_t  score_bells;       /* 0x120 */
    int16_t  score_ff;          /* 0x122 */
    int16_t  score_total;       /* 0x124 */

    /* AI state (only meaningful for AI-controlled powers) */
    int16_t  ai_personality_id; /* 0x126  index into AIPersonality table */
    int16_t  ai_strategy_state; /* 0x128  strategic priority code */
    int16_t  ai_target_x;       /* 0x12A  current expansion target tile */
    int16_t  ai_target_y;       /* 0x12C */
    int16_t  ai_war_target;     /* 0x12E  current war target power id (or -1) */
    int16_t  ai_unit_budget;    /* 0x130  max units AI may build this turn */
    int16_t  ai_colony_budget;  /* 0x132  max new colonies AI may found */
    int16_t  ai_pad[3];         /* 0x134..0x139  pad to 0x13C */
};                              /* total 316 bytes (0x13C) */
```

@ref `../include/power.h`, `../include/ai_personality.h`,
     `COLONIZATION_TECHNICAL_REFERENCE.md` §3.2 (Power Record)

---

## 2. Colony record (persistent) — 202 bytes (0xCA)

Lives in the **ColonyTable** at DGROUP file offset `0x05D60`, with a
maximum slot count of 64 (8 colonies × 8 powers in worst case; only 32 are
actually usable per-game).

```c
struct ColonyRecord {           /* 202 bytes (0xCA) */
    uint8_t  colony_id;         /* 0x00  table index (0..63) */
    uint8_t  owner;             /* 0x01  power id 0..3 */
    int16_t  map_x;             /* 0x02  tile x */
    int16_t  map_y;             /* 0x04  tile y */
    char     name[24];          /* 0x06  null-padded UPPERCASE name */

    /* Population / specialists */
    uint8_t  population;        /* 0x1E  total colonists IN colony */
    uint8_t  workers_in_colony; /* 0x1F  in-colony workers (not on tiles) */
    uint8_t  workers_on_tiles;  /* 0x20  workers in surrounding ring */
    uint8_t  pad_21;            /* 0x21 */

    /* Worker assignment table — 24 slots (8 ring tiles × 3 max +
     * per-building slots).
     * Each slot is 2 bytes: { unit_index, occupation_or_tile_id }.
     * Decoded by colony_assignment.c::colony_get_assignment().
     */
    uint16_t worker_slots[24];  /* 0x22..0x51   24 × 2 = 48 bytes */

    /* Stockpile — 16 commodity quantities (max 100 or warehouse cap) */
    int16_t  stock[16];         /* 0x52..0x71  2 × 16 = 32 bytes */

    /* Buildings — 32 building slots, each 1 byte (BLD_NONE..BLD_*) */
    uint8_t  building[32];      /* 0x72..0x91  building id per slot */

    /* Construction queue */
    uint8_t  in_construction;   /* 0x92  building id under construction */
    uint8_t  pad_93;            /* 0x93 */
    int16_t  hammers;           /* 0x94  hammers accumulated this build */
    int16_t  hammers_required;  /* 0x96  hammers needed to finish */

    /* SoL / Tory tracking */
    uint8_t  sol_pct;           /* 0x98  Sons of Liberty % (0..100) */
    uint8_t  tory_pct;          /* 0x99  Tory % (0..100) */
    int16_t  bells_per_turn;    /* 0x9A  liberty bells produced */
    int16_t  crosses_per_turn;  /* 0x9C  crosses produced */

    /* Production cache (recomputed at end of turn) */
    int16_t  production[16];    /* 0x9E..0xBD  2 × 16 = 32 bytes net produced */

    /* Defenders */
    uint8_t  garrison_count;    /* 0xBE */
    uint8_t  pad_BF;            /* 0xBF */
    int16_t  defense_strength;  /* 0xC0  cached combat value */

    /* Misc flags */
    uint8_t  was_captured;      /* 0xC2  bit 0 = captured this turn */
    uint8_t  warehouse_overflow;/* 0xC3  bit 0 = stock destroyed last turn */
    uint8_t  pad_C4[6];         /* 0xC4..0xC9  reserved */
};                              /* total 202 bytes (0xCA) */
```

@ref `../include/colony.h`,
     `COLONIZATION_TECHNICAL_REFERENCE.md` §3.1 (Colony Record)

### Working buffer (174 bytes / 0xAE) at *(DGROUP:0x8542)

The 174-byte working buffer is the **subset of fields that the colony screen
operates on directly** — the rest of the 202-byte record is recomputed.
The 28-byte difference is composed of cached/derived values:

- `production[16]` — 32 bytes, recomputed at end of turn
- `defense_strength` — 2 bytes, recomputed when garrison changes
- pad/flags region — overhead

@ref `../src/colony/accessors.c::colony_load_to_buffer()`,
     `../src/colony/accessors.c::colony_save_from_buffer()`

---

## 3. Unit record — 28 bytes (0x1C)

Stored in the **UnitTable** at DGROUP file offset `0x06A20`.

```c
struct UnitRecord {             /* 28 bytes (0x1C) */
    uint8_t  unit_id;           /* 0x00  table index */
    uint8_t  owner;             /* 0x01  power id 0..3 (or 4..7 = native/REF) */
    uint8_t  unit_type;         /* 0x02  unit type 0..63 (see UnitType enum) */
    uint8_t  flags;             /* 0x03  bit0=hidden, bit1=in_colony,
                                          bit2=in_cargo, bit3=sentry,
                                          bit4=fortified, bit5=plowing,
                                          bit6=building_road, bit7=pioneer */
    int16_t  map_x;             /* 0x04  tile x */
    int16_t  map_y;             /* 0x06  tile y */
    int16_t  destination_x;     /* 0x08  goto target (or -1) */
    int16_t  destination_y;     /* 0x0A */
    uint8_t  movement_left;     /* 0x0C  remaining moves this turn */
    uint8_t  movement_total;    /* 0x0D  full move budget per turn */
    uint8_t  cargo_count;       /* 0x0E  number of cargo slots used */
    uint8_t  cargo_max;         /* 0x0F  max cargo capacity (0/4/6/etc.) */
    int16_t  cargo[6];          /* 0x10..0x1B  6 × 2 cargo entries
                                                 (commodity id or unit id;
                                                 high bit = unit, low bits =
                                                 quantity for commodity) */
};                              /* total 28 bytes (0x1C) */
```

@ref `../include/unit.h`, `../src/unit/cargo.c`,
     `COLONIZATION_TECHNICAL_REFERENCE.md` §3.3 (Unit Record)

### Unit type table (45 types)

The UnitType table is at DGROUP `0x06530`. Each entry is 8 bytes:

```c
struct UnitType {               /* 8 bytes per entry */
    int16_t  cost;              /* 0x00  Europe purchase cost (0 if not for sale) */
    uint8_t  attack;             /* 0x02  combat attack strength */
    uint8_t  defense;            /* 0x03  combat defense strength */
    uint8_t  movement;           /* 0x04  base movement points */
    uint8_t  cargo_slots;        /* 0x05  0/4/6 (foot/wagon/ship) */
    uint8_t  flags;              /* 0x06  bit0=naval, bit1=transport,
                                            bit2=land_combat, bit3=can_attack,
                                            bit4=expert, bit5=can_capture */
    uint8_t  expert_skill;       /* 0x07  occupation_id this unit is expert in */
};
```

The full enum (UNIT_FREE_COLONIST..UNIT_MAN_O_WAR) is in
[../include/unit.h](../include/unit.h). 45 active types are defined by name in
NAMES.TXT @UNIT.

---

## 4. Native settlement record — 18 bytes (0x12)

Stored at **DGROUP:0x54EC**, stride **0x12 (18 bytes)**, live-count at
**DGROUP:0x539A**, max **84 (0x54)**. BYTE_VERIFIED 2026-05-28 (`imul *,0x12`
then `[bx+0x54EC]` at overlay 0x46035; 18-byte record copy at 0x46F40; count
INC/DEC at 0x46E2E/0x46F5D). The earlier 200-byte / `0x09100` / `0x4850` /
80-slot model was **fabricated** — those addresses and `imul *,0xC8` appear 0×
in VICEROY.EXE. See docs/RULINGS.md 2026-05-28.

See [../include/native.h](../include/native.h) for the exact field layout
(tribe id, settlement type, mission status, gift cycle, learned skill,
attack timer, etc.).

```c
struct NativeSettlement {       /* 18 bytes (0x12) — BYTE_VERIFIED 2026-05-28 */
    uint8_t  x;                 /* +0x00  map X (cmp [bx+0x54EC]) */
    uint8_t  y;                 /* +0x01  map Y (cmp [bx+0x54ED]) */
    uint8_t  owner;             /* +0x02  owning tribe id (cmp [bx+0x54EE]) */
    uint8_t  field_03;          /* +0x03  not yet decoded */
    uint8_t  population;        /* +0x04  population (CHIEFKILL raze input) */
    uint8_t  mission;           /* +0x05  mission flag (0x10 | owner_idx) */
    uint8_t  data_06_11[12];    /* +0x06..0x11  not yet decoded */
};                              /* total 18 bytes (0x12); live-count @0x539A, max 84 */
```

> NOTE: the prior 200-byte (0xC8) struct was **fabricated**. `0x4850`,
> `0x09100`, and `imul *,0xC8` appear 0× in VICEROY.EXE; every real access uses
> `imul *,0x12` then `[bx+0x54EC]` (overlay 0x46035 / 0x4610A). See
> docs/RULINGS.md 2026-05-28.

@ref `../include/native.h`,
     `COLONIZATION_TECHNICAL_REFERENCE.md` §3.4 (Native Settlement)

---

## 5. Map cell — 3 bytes per tile (one byte each in 3 layers)

The map is stored as **three parallel layers**, each `58 × 72 = 4,176` bytes:

- **Terrain layer** at file offset `+0x000` of MP body
- **Feature layer** at offset `+0x1050` (4176 = 0x1050)
- **Resource overlay layer** at offset `+0x20A0`

Each cell in the terrain layer is a packed byte:

```
bit 7 : Forested (overlays a tree sprite atop base terrain)
bit 6 : Road or River (depending on bit 5)
bit 5 : Prime resource exists
bits 4..0 : Base terrain id (0..31)
```

Base terrain IDs and their semantics live in NAMES.TXT @TERRAIN — do NOT
use mapedit.c, which has been wrong about ordering before.
See [MAP_SYSTEM.md](MAP_SYSTEM.md) for the full table.

@ref `../formats/MP.md`, `../src/load_image/load_image_*.c` (map loaders)

---

## 6. AI personality record — 52 bytes (0x34)

Stored in the **AIPersonalityTable** at DGROUP `0x0A800`. One per power, plus
8 pre-canned templates.

```c
struct AIPersonality {          /* 52 bytes (0x34) */
    uint8_t  template_id;       /* 0x00  0..7 (Builder, Conqueror, Trader, ...) */
    uint8_t  pad_01;
    int16_t  aggression;        /* 0x02  -100..100 */
    int16_t  expansion;         /* 0x04  drive to found new colonies */
    int16_t  militarism;        /* 0x06  drive to build soldiers */
    int16_t  religiosity;       /* 0x08  drive to build churches/missions */
    int16_t  trade;             /* 0x0A  drive to trade vs. self-sufficiency */
    int16_t  pioneer;           /* 0x0C  drive to terraform */
    int16_t  rebellion;         /* 0x0E  willingness to declare independence */
    int16_t  diplomacy;         /* 0x10  willingness to seek peace/alliance */
    int16_t  exploration;       /* 0x12  drive to scout the map */
    int16_t  defense;           /* 0x14  drive to fortify colonies */
    /* per-FF preference scores (25 fathers × 1 byte) */
    int8_t   ff_weight[25];     /* 0x16..0x2E  -10..+10 priority per father */
    uint8_t  pad[5];            /* 0x2F..0x33  pad to 52 */
};                              /* total 52 bytes (0x34) */
```

@ref `../include/ai_personality.h`,
     `COLONIZATION_TECHNICAL_REFERENCE.md` §3.5 (AI Personality)

---

## 7. Founding Father record (constant) — 12 bytes per FF

Read-only table of 25 entries at DGROUP `0x0B400`:

```c
struct FoundingFather {         /* 12 bytes per entry */
    uint8_t  father_id;         /* 0x00  0..24 */
    uint8_t  age;               /* 0x01  0..4 (Exploration..Military) */
    int16_t  base_cost;         /* 0x02  bells base cost (scaled by year) */
    uint8_t  effect_type;       /* 0x04  see FF_EFFECT_* enum */
    uint8_t  effect_value;      /* 0x05  parameter to effect */
    uint8_t  flags;             /* 0x06  bit0=once_only, bit1=passive */
    uint8_t  pad_07;
    uint16_t name_str_idx;      /* 0x08  index into NAMES.TXT @FATHER */
    uint16_t portrait_sprite;   /* 0x0A  ICONS.SS sprite index */
};
```

@ref `../include/ff.h`, `FOUNDING_FATHERS.md`

---

## 8. King's demand record — variable, queued

The pending-king-demand state is a 16-byte record on the PowerRecord
(`pending_demand` int16 + extra context in the Power scratch area). The
king's demand types and tax escalation logic are in [KING_TAX.md](KING_TAX.md).

---

## 9. Save file structure

The `.SAV` save file is a **direct dump** of the relevant DGROUP segments,
preceded by a 32-byte header. See [../formats/MP.md](../formats/MP.md) for
the map portion and [../include/save.h](../include/save.h) for the field
list.

```
+0x000  magic "COLONY94" + version uint16
+0x010  current turn / year / month
+0x020  active power id
+0x030  PowerTable[8]                    8 × 316 = 2,528 bytes
+0xA50  ColonyTable[64]                  64 × 202 = 12,928 bytes
+0x2C50 UnitTable[256]                   256 × 28 = 7,168 bytes
+0x4850 NativeSettlementTable           (UNVERIFIED save-layout guess; the in-memory table is 18-byte stride @ DGROUP:0x54EC)
+0x88B0 Map (terrain+feature+resource)   3 × 4176 = 12,528 bytes
+0xB9B0 Discovery bitmap (per-power)     4 × 522 = 2,088 bytes
+0xC1F8 Misc tables (FF state, events)
+0xCFFF EOF marker (file may be padded/truncated)
```

@ref `../include/save.h`, `SCORING.md` for endgame state.

---

## 10. Cross-validation status

| Struct                  | Size | Verified | Source                        |
|-------------------------|------|----------|-------------------------------|
| PowerRecord             | 316  | YES      | DGROUP table stride           |
| ColonyRecord (persist)  | 202  | YES      | ColonyTable stride            |
| colony_t (working)      | 174  | YES      | accessor copy lengths         |
| UnitRecord              | 28   | YES      | UnitTable stride              |
| NativeSettlement        | 18 (0x12) | YES | base 0x54EC, imul *,0x12, count @0x539A |
| AIPersonality           | 52   | YES      | template-table stride         |
| FoundingFather          | 12   | YES      | FF table stride               |
| Map cell                | 1    | YES      | MP file body length / 4176    |

@ref `COLONIZATION_TECHNICAL_REFERENCE.md` §2 for table base offsets and
     stride proofs.

---

## NAMES.TXT @SECTION → DGROUP table-base map (func_0749E0)

The game-data loader **func_0749E0** (overlay page 0x1A, file 0x0749E0; ported
in `src/overlay/overlay_0745F0_077A6A.c`) opens the data file at init (default
section `"EUROPE"` @DGROUP 0x1A2C) and dispatches **38 `@SECTION` headers**, each
filling a named DGROUP table. Byte-traced from the func_0749E0 body; a sample
(SEASONS string @0x21AC, AMER2.MP @0x2166, EUROPE @0x1A2C, SCENARIO stride
imul 0x13C @0x074D6F) was independently re-verified against VICEROY.EXE. This is
the canonical game-data-table layout and cross-validates the struct strides
above.

| @SECTION       | DGROUP table base / stride                         | Notes |
|----------------|----------------------------------------------------|-------|
| SEASONS        | word[-0x6800]                                      | |
| UNFORESTED     | per-entry sub-loader (ljmp 0x1A1F:0xD20)            | not yet decoded-inner |
| FORESTED       | sub + row[+0x3074]                                 | |
| OTHER          | sub                                                | |
| OTHER_NAMES    | [+0x2DB0]                                           | |
| RESOURCE       | [-0x6CF4]/[-0x684E]                                 | |
| COUNTRY        | [-0x72BE]/[+0x848]                                  | per-power byte 0x848 |
| NATIONALITY    | [-0x72F6]                                           | |
| NATIONABBREV   | [-0x6810]                                           | |
| HOMEPORT       | [-0x7C74]                                           | |
| COLONYNAME     | [idx*0x34+0x5426]                                  | stride 0x34 |
| LEADERNAME     | [idx*0x34+0x540E]                                  | **AIPersonality 0x540E/0x34 (confirms)** |
| MISSION        | [-0x6808]                                           | |
| DIFFICULTY     | [-0x7C6C]                                           | |
| CLASS          | [-0x69FE]                                           | |
| BUILDING       | [-0x707E] stride 0xC                                | |
| SCENARIO       | [-0x77C6]/[-0x77C5] PowerRecord stride 0x13C        | **PowerRecord 0x13C (confirms)** |
| JOB            | [-0x715E]                                           | |
| CARGO          | [-0x6840]+[-0x6904]                                 | |
| UNIT           | [+0x5230] stride 0xE                                | col1 = ICONS sprite index |
| ORDERS         | [+0x54DE]                                           | |
| ACTIONS        | [-0x6CD6]                                           | |
| VALUES         | [-0x6CC0]                                           | |
| ATTITUDE       | [-0x6CB8]                                           | |
| ATTITUDINAL    | [-0x6CAE]                                           | |
| LEVELS         | [-0x69CE]                                           | |
| TRIBES         | [-0x72EE]+[+0x84C]                                  | **col-5 = VICEROY.PAL color (confirms)** |
| FOUNDING       | [-0x6918]                                           | |
| FATHERS        | [-0x69AE]                                           | FoundingFather names |
| COLORS         | [0x830..0x839]                                      | |
| INFO           | [-0x690C]                                           | |
| MISC           | [+0x2DBA]                                           | |
| ROUTE          | [-0x6C22]                                           | |
| CMISC          | [-0x6C68]                                           | |
| CTITLE         | [-0x6C62]                                           | |
| CMESSAGE       | [-0x6C4E]                                           | |
| EUROLABEL      | [-0x6C28]                                           | |
| MISCELLANEOUS  | [-0x6CA4]                                           | count from PEDIA token via [0x846] |

Also confirmed in this region: stream/archive file format = MicroProse
**MADSPACK 2.0** (signature @DS:0x240A/0x2418, func_076E50 ctor); default map =
**AMER2.MP** (@0x2166, func_0755CC) — the project's pixel target.
