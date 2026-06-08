/* >>> VALUES ARE [RUNTIME_ONLY (data-resident) — EXTERNAL DATA FILE], NOT BYTE-VERIFIED <<<
 * This balance table is NOT embedded in VICEROY.EXE. It is parsed at runtime
 * from a COLONIZE/*.TXT data file (NAMES.TXT/COLONY.TXT/TRIBE.TXT) into a BSS
 * buffer (DS offset > 0x2CC5). The numeric values below are RECONSTRUCTED and
 * must not be trusted until the .TXT data files are supplied and parsed.
 * Only the struct LAYOUT (stride/field order) is byte-anchored. See README.md
 * and docs/DATA_TABLES.md.  (banner added 2026-06-07) */

/* ============================================================================
 *   DATA: NAMES.TXT @UNIT (verified)  |  combat stats mirror DGROUP:0x5230
 * ----------------------------------------------------------------------------
 * Rebuilt 2026-05-30 from NAMES.TXT @UNIT. The previous version was FULLY
 * FABRICATED (docs/RULINGS.md 2026-05-30): it invented 45 rows in a made-up
 * order with an 8-byte stride at a fake offset 0x06530, and had nearly every
 * ship's defense wrong (Privateer 4 vs 8, Frigate 8 vs 16, Man-O-War 12 vs 24,
 * Galleon 6 vs 10, Merchantman 4 vs 6), Artillery 4/2 vs 7/5, Scout atk 1 vs 4,
 * phantom unit types (Damaged Artillery, separate Veteran rows), and it omitted
 * the real Regulars row and 2 of the 4 native types.
 *
 * @source extracted/text/NAMES_sections.json @UNIT ; raw COLONIZE/NAMES.TXT.
 *   @UNIT legend: "icon, movement, attack, combat, cargo, size, cost, tools,
 *                  guns, hull, role"  (role = 8-bit AI mask, see below).
 *   23 rows, file order = the canonical unit-type id (UnitRecord.type @+0x02).
 * @xref attack/combat columns mirror the BYTE_VERIFIED stat table DGROUP:0x5230
 *   stride 14 (+0x06 attack=0x5236, +0x05 defense=0x5235 — CORRECTED 2026-05-30
 *   from the wrong +0x0C/+0x0B; loader stores verified @0x74F11/@0x74F1A, see
 *   docs/COMBAT_STATS.md). Ship guns/hull (col9/col10) load to +0x0B/+0x0C
 *   (0x523b/0x523c) and are the SHIP-roll DEF/ATK. That runtime table is the
 *   authority for the combat resolver. (Data values here were already correct.)
 * @xref colonize_sdl/engine/game_data.py (same @UNIT parse).
 *
 * NOTE on `cost` (col 7): this is the NAMES.TXT economic-size value, NOT the
 * Europe gold purchase price (Artillery 500g, Galleon 3000g, etc. live in a
 * separate, not-yet-traced table). `size` (col 6) = cargo-hold space cost
 * (99 = ship/uncarryable). `veteran` status is UnitRecord.vet_type @+0x17, NOT
 * a distinct unit type.
 * ============================================================================ */
#include "viceroy_types.h"

/* role bit mask (col 11, an 8-char binary string in @UNIT), MSB..LSB:
 *   Invade Settle Explore Attack Defend Escort Transport Naval
 * Kept as the verbatim @UNIT string to stay byte-faithful without re-encoding. */
struct UnitTypeEntry {
    const char *name;
    uint8_t  icon;        /* col1: @UNIT "icon" — 1-BASED. The 0-based ICONS.SS
                           * sprite index = icon - 1. Verified empirically vs
                           * docs/icon_catalog_verified.json: @UNIT Caravel=6 ->
                           * ICONS.SS[5]=Caravel, Galleon=8 -> [7], Colonists=101
                           * -> [100]=Free Colonist. colonize_sdl/unit_sprite_map.py
                           * uses the correct 0-based values. RULINGS 2026-05-30. */
    uint8_t  movement;    /* col2 */
    uint8_t  attack;      /* col3  (mirrors 0x5230 +0x06 = 0x5236, LAND ATK) */
    uint8_t  defense;     /* col4 "combat" (mirrors 0x5230 +0x05 = 0x5235, LAND DEF) */
    uint8_t  cargo;       /* col5: cargo slots */
    uint8_t  size;        /* col6: hold-space cost (99 = ship/uncarryable) */
    uint8_t  cost;        /* col7: economic-size value (NOT Europe gold price) */
    uint8_t  tools;       /* col8 */
    uint8_t  guns;        /* col9 */
    uint8_t  hull;        /* col10 */
    const char *role;     /* col11: 8-bit AI role mask (verbatim) */
};

const struct UnitTypeEntry UNIT_TYPE_TABLE[23] = {
    /* id  name             icon mv at df ca sz co tl gn hu  role */
    /*  0 */ { "Colonists",    101, 1,  0, 1, 0, 1, 1,  0, 0, 0, "01000000" },
    /*  1 */ { "Soldiers",     103, 1,  2, 2, 0, 1, 2,  0, 0, 0, "00011100" },
    /*  2 */ { "Pioneers",     102, 1,  0, 1, 0, 1, 2,  0, 0, 0, "01000000" },
    /*  3 */ { "Missionaries", 106, 2,  0, 1, 0, 1, 1,  0, 0, 0, "00100000" },
    /*  4 */ { "Dragoons",     105, 4,  3, 3, 0, 1, 3,  0, 0, 0, "00111100" },
    /*  5 */ { "Scouts",       104, 4,  1, 1, 0, 1, 2,  0, 0, 0, "01100100" },
    /*  6 */ { "Regulars",     126, 1,  5, 5, 0, 1, 3,  0, 0, 0, "00011100" },
    /*  7 */ { "Cont. Cav.",   130, 4,  5, 5, 0, 1, 3,  0, 0, 0, "00011100" },
    /*  8 */ { "Cavalry",      127, 4,  6, 6, 0, 1, 4,  0, 0, 0, "00011100" },
    /*  9 */ { "Cont. Army",   129, 1,  4, 4, 0, 1, 3,  0, 0, 0, "00011100" },
    /* 10 */ { "Treasure",      17, 1,  0, 0, 0, 6, 4,  0, 0, 0, "00000000" },
    /* 11 */ { "Artillery",     10, 1,  7, 5, 0, 1, 6,  4, 0, 0, "00011000" },
    /* 12 */ { "Wagon Train",    9, 2,  0, 1, 2,99, 1,  0, 0, 0, "00000000" },
    /* 13 */ { "Caravel",        6, 4,  0, 2, 2,99, 4,  4, 0, 4, "10100010" },
    /* 14 */ { "Merchantman",    7, 5,  0, 6, 4,99, 6,  8, 1, 8, "10000010" },
    /* 15 */ { "Galleon",        8, 6,  0,10, 6,99,10, 10, 4,20, "10000010" },
    /* 16 */ { "Privateer",     15, 8,  8, 8, 2,99, 8, 12, 4,12, "00000001" },
    /* 17 */ { "Frigate",       16, 6, 16,16, 4,99,16, 20,12,32, "10000001" },
    /* 18 */ { "Man-O-War",    128, 5, 24,24, 6,99,32, 90,32,64, "10000001" },
    /* 19 */ { "Braves",       110, 1,  1, 1, 0, 0, 1,  0, 0, 0, "00111000" },
    /* 20 */ { "Armed Braves", 111, 1,  2, 2, 0, 0, 2,  0, 0, 0, "00111000" },
    /* 21 */ { "Mtd. Braves",  112, 4,  2, 2, 0, 0, 2,  0, 0, 0, "00111000" },
    /* 22 */ { "Mtd. Warriors",113, 4,  3, 3, 0, 0, 3,  0, 0, 0, "00111000" },
};
