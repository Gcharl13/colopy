/* ============================================================================
 * VICEROY.EXE — Ghidra rosetta-stone pseudo-C reference
 *
 * Single-file consolidated reference for substituting names while
 * reverse-engineering VICEROY.EXE (Sid Meier's Colonization, 1994
 * MicroProse, Borland C++ 3.1 / RTLink Plus).
 *
 * Use as you walk Ghidra: every globally-known name is here. Every
 * UNKNOWN gap is explicitly marked so you can fill it in as you trace.
 * Nothing is invented — speculative items are labelled SUSPECTED.
 *
 * Tags used in comments:
 *   VERIFIED   — byte-traced from VICEROY.EXE; safe to apply in Ghidra
 *   PARTIAL    — partially known; specific gap noted
 *   SUSPECTED  — strong inference (cross-source); not byte-confirmed
 *   UNKNOWN    — true gap — DO NOT MAKE UP A NAME
 *
 * Source-of-truth files (project-internal):
 *   docs/DATA_MODEL.md
 *   docs/SAVE_FORMAT_CROSSREF.md            (pavelbel SAV cross-ref)
 *   docs/CAPITAL_BONUS_ANALYSIS.md
 *   docs/RESIDUAL_FINDINGS.md               (recent disasm finds)
 *   code/VICEROY/disasm/*.asm               (per-function bytes)
 *   viceroy_source/src/.../*.c              (47 BYTE_VERIFIED bodies)
 *   extracted/text/NAMES_sections.json      (game data tables)
 *
 * Convention: file-offset addresses below are RAW VICEROY.EXE byte
 * offsets (the same numbers Ghidra shows in the listing). DGROUP
 * addresses are listed as "DGROUP:0xNNNN" — these are runtime
 * data-segment offsets; in Ghidra they'll appear after relocation.
 *
 * Last updated: 2026-05-04
 * ============================================================================
 */

#ifndef VICEROY_GHIDRA_REFERENCE_H
#define VICEROY_GHIDRA_REFERENCE_H

#include <stdint.h>

/* ============================================================================
 * 1. PRIMITIVE TYPE ALIASES (16-bit DOS)
 * ============================================================================ */
typedef uint8_t   u8;
typedef int8_t    i8;
typedef uint16_t  u16;          /* word — most natural CPU size on 8086 */
typedef int16_t   i16;
typedef uint32_t  u32;          /* dword — used for gold and royal_money */
typedef int32_t   i32;
typedef u16       far_seg;      /* segment portion of far ptr */
typedef u16       far_ofs;      /* offset portion of far ptr */


/* ============================================================================
 * 2. KEY CONSTANTS (byte-VERIFIED)
 * ============================================================================ */

/* Struct strides — confirmed by IMUL/SHL patterns in disasm */
#define POWER_RECORD_STRIDE        316    /* 0x13C bytes per power     VERIFIED 0x04AB61: IMUL bx, [bp+8], 0x13C */
#define COLONY_RECORD_STRIDE       202    /* 0xCA bytes per colony     VERIFIED via stockpile placement at +0x9A */
#define UNIT_RECORD_STRIDE         28     /* 0x1C bytes per unit       VERIFIED 0x04A7D5: IMUL bx, [bp+6], 0x1C */
#define NATIVE_SETTLEMENT_STRIDE   18     /* 0x12 bytes per dwelling   VERIFIED via runtime cross-record analysis */
#define TRIBE_DATA_STRIDE          78     /* 0x4E bytes per tribe      VERIFIED via base-array bounds check */
#define AI_PERSONALITY_STRIDE      52     /* 0x34 bytes per power      VERIFIED 0x04A874: IMUL bx, [bp+8], 0x34 */

/* Counts */
#define NUM_POWERS                 12     /* 4 European + 8 native (NativeSettlement.owner range 0..11) */
#define NUM_EUROPEAN_POWERS        4      /* England, France, Spain, Netherlands */
#define NUM_TRIBES                 8      /* Inca, Aztec, Arawak, Iroquois, Cherokee, Apache, Sioux, Tupi */
#define NUM_UNIT_SLOTS             256    /* UnitRecord array size */
#define NUM_FOUNDING_FATHERS       25     /* CC-00..CC-24 portrait sprites; bits 0..24 in PowerRecord +0x07 mask */
#define NUM_BUILDINGS              42     /* @BUILDING table entries */
#define NUM_COMMODITIES            16     /* food..muskets in @CARGO; ICONS sprites 22..37 */
#define NUM_TERRAIN_TYPES          29     /* @TERRAIN table; .MP layer 1 byte values */

/* Map dimensions (DGROUP-resident, not constants — listed for reference) */
#define DEFAULT_MAP_WIDTH          58     /* DGROUP:0x853A — VERIFIED constant in tested scenarios */
#define DEFAULT_MAP_HEIGHT         72     /* DGROUP:0x853C */

/* Auto-forest range — VERIFIED at file 0x6204 and 0x6831B */
#define AUTO_FOREST_FIRST          8      /* terrain IDs 8..23 are forested variants */
#define AUTO_FOREST_LAST           23


/* ============================================================================
 * 3. DGROUP GLOBALS — VERIFIED ADDRESSES + ROLES
 *
 * In Ghidra, these are the runtime offsets within the data segment
 * (after relocation). Apply these names to the corresponding bytes.
 * ============================================================================ */

/* Forward decls of structs used in extern globals below */
typedef struct PowerRecord       PowerRecord;
typedef struct ColonyRecord      ColonyRecord;
typedef struct UnitRecord        UnitRecord;
typedef struct NativeSettlement  NativeSettlement;
typedef struct TribeData         TribeData;
typedef struct AIPersonality     AIPersonality;

/* CycleDatHeader is the in-memory layout of CYCLE.DAT (decoded 2026-05-04
 * — see RESIDUAL_FINDINGS.md §6). 34 bytes total. */
typedef struct CycleEntry {
    u8  start_idx;     /* +0  palette range start (read each tick, summed into 0x92C2) */
    u8  phase;         /* +1  current phase (mutated by tick — file value is initial state) */
    u8  end_idx;       /* +2  palette range end (read at C62E for blit args) */
    u8  period;        /* +3  cycle period / speed (best guess) */
} CycleEntry;
typedef struct CycleDatHeader {
    u16          count;            /* +0x00  number of active cycle entries (=1 in shipped CYCLE.DAT) */
    CycleEntry   entries[8];       /* +0x02..+0x21  up to 8 entries (32 bytes) */
} CycleDatHeader;

/* --- Game-state scalars --- */
extern u8       g_difficulty;            /* DGROUP:0x53A6  VERIFIED 2026-05-08 — pavelbel HEAD.difficulty enum:
                                                            0=Discoverer, 1=Explorer, 2=Conquistador,
                                                            3=Governor, 4=Viceroy. Test session value = 1
                                                            (Explorer). Used by CHIEFKILL formula and others
                                                            as `upper = 10 - difficulty` for random_int rolls. */
extern u8       g_king_anger;            /* DGROUP:0x53A7  VERIFIED — increments per Tea Party */
extern u8       g_ref_strength[8];       /* DGROUP:0x53DA..0x53E1  VERIFIED — REF unit counts per slot;
                                                            slot order: (Reg, Cav, MoW, Art) for 4 powers */
extern u16      g_map_width;             /* DGROUP:0x853A  VERIFIED */
extern u16      g_map_height;            /* DGROUP:0x853C  VERIFIED */
extern u16      g_screen_clip_rect[4];   /* DGROUP:0x839E  VERIFIED — popup geometry clip:
                                                            ymax=200, xmax=320, ymin=0, xmax_total=15585 */
extern u8       g_revolution_flags;      /* DGROUP:0x5382  PARTIAL — bit 0 = revolution-declared/endgame */
extern u16      g_active_power_idx;      /* near DGROUP:0x84FC  PARTIAL — current player index (0..NUM_POWERS-1) */

/* --- Far-ptr "active record" globals (set by setters before record-specific ops) --- */
extern PowerRecord*       g_active_power;        /* DGROUP:0x8D52  VERIFIED via PUSH [0x8D52] before record ops */
extern ColonyRecord*      g_active_colony;       /* DGROUP:0x8542  VERIFIED — 102 references per anchor map */
extern UnitRecord*        g_active_unit;         /* DGROUP:0x8D4A  VERIFIED — read by `MOV bx, [0x8D4A]` */
extern NativeSettlement*  g_active_settlement;   /* DGROUP:0x8D4E  VERIFIED — formerly "active TribeData" — used in
                                                                   CHIEFKILL formula at 0x04AB20 */
extern void*              g_king_or_payer;       /* DGROUP:0x84FC  PARTIAL — used by SMITE + king tax */
extern u16                g_message_context;     /* near DGROUP:0x8D5*  PARTIAL — current GAME.TXT @section being parsed */

/* --- Record-table base addresses --- */
extern PowerRecord       g_power_table[NUM_POWERS];             /* DGROUP:0x8808  VERIFIED — base + power_idx*316 */
extern ColonyRecord      g_colony_table[/* up to 80 */];        /* DGROUP base TBD — accessed via g_active_colony */
extern UnitRecord        g_unit_table[NUM_UNIT_SLOTS];          /* DGROUP:0x3146  VERIFIED — stride 28 */
extern NativeSettlement  g_settlement_table[/* up to ~80 */];   /* DGROUP:0x54EC  VERIFIED — stride 18 */
extern TribeData         g_tribe_data[NUM_TRIBES];              /* DGROUP:0x5AD6  VERIFIED — stride 78 */
extern AIPersonality     g_ai_personality[NUM_EUROPEAN_POWERS]; /* DGROUP:0x540E  VERIFIED — stride 52, EUR only */

/* --- Market / pricing --- */
extern u32      g_market_price_state[/*N*/];     /* DGROUP:0x8904  VERIFIED — stride 79×4 per per-power per-good */

/* --- Per-power active-unit count (for unit-list iteration) --- */
extern u8       g_unit_count_by_power[NUM_POWERS];  /* DGROUP:0x8CFC + N  VERIFIED via destroy_unit byte-trace */

/* --- Static buffers --- */
extern CycleDatHeader g_cycle_dat_buffer;        /* DGROUP:0x929E   VERIFIED — populated by load_cycle_dat();
                                                                    structure now decoded (2026-05-04 §6) */
extern u16      g_cycle_running_sum;             /* DGROUP:0x92C2   VERIFIED — sum of entry start_idx bytes
                                                                    each tick (color_cycle_tick) */
extern u16      g_cycle_state_flag;              /* DGROUP:0x92C0   VERIFIED — set 3 if running_sum > 0x10, else 0 */
extern u8       g_format_buffer_2D54[];          /* DGROUP:0x2D54   VERIFIED — twice-formatted scratch buffer */
extern u32      g_capital_raze_popup_amount;     /* DGROUP:0x9CB0   VERIFIED — gold value for @CASHTREASURE / @LOSTCITY2 */
extern u32      g_capital_raze_popup_count;      /* DGROUP:0x9CB8   VERIFIED */
extern u32      g_capital_raze_tribe_color;      /* DGROUP:0x9CBC   VERIFIED — tribe map-marker palette index;
                                                                    NOT "base wealth" (corrected 2026-05-04) */
extern char     g_capital_raze_tribe_name[16];   /* DGROUP:0x9CD2   VERIFIED — substituted tribe name string */


/* ============================================================================
 * 4. STRUCT LAYOUTS
 *
 * All offsets are VERIFIED against runtime memory unless tagged otherwise.
 * UNKNOWN regions are kept as `unknown_NN[K]` byte arrays so Ghidra
 * shows the gap instead of letting you accidentally guess.
 * ============================================================================ */

/* ----------------------------------------------------------------------------
 * PowerRecord — 316 bytes (0x13C). Base: DGROUP:0x8808.
 *
 * 12 entries (4 European + 8 native). Native entries reuse much of
 * the layout; tax/bells/etc. are not meaningful for natives.
 *
 * pavelbel's SAV NATION schema labels every byte; runtime confirmed
 * the marked-VERIFIED ones. Unconfirmed pavelbel labels live in the
 * `_pavel` comment but kept as `unknown_NN[]` until byte-confirmed.
 * ---------------------------------------------------------------------------- */
typedef struct PowerRecord {
    u8        unknown_00;                      /* +0x00  UNKNOWN — pavelbel: control_type (Human/EuroAI/etc.) */
    u8        tax_rate;                        /* +0x01  VERIFIED — tax %, 0..75 */
    u8        rebel_sentiment_pct;             /* +0x02  VERIFIED — nation-wide SoL %, 0..100 */
    u8        unknown_03[4];                   /* +0x03..+0x06  UNKNOWN — pavelbel: per-power flags + count bytes;
                                                          recruit[3] (3 profession bytes) suspected here */
    u32       founding_fathers_acquired_mask;  /* +0x07  VERIFIED — bit i = FF i acquired (bits 0..24 used) */
    u8        unknown_0B;                      /* +0x0B  UNKNOWN */
    u16       bells_toward_next_ff;            /* +0x0C  VERIFIED — RESETS on FF acquisition (NOT lifetime) */
    u16       bells_per_turn;                  /* +0x0E  VERIFIED */
    u16       crosses_per_turn;                /* +0x10  VERIFIED — drives immigration */
    u8        unknown_12[2];                   /* +0x12..+0x13  UNKNOWN — turn-modifier counters */
    u8        founding_father_count;           /* +0x14  VERIFIED — popcount of mask at +0x07 */
    u8        unknown_15[9];                   /* +0x15..+0x1D  UNKNOWN — per-turn deltas + boycott-prefix */
    u16       artillery_bought_count;          /* +0x1E  VERIFIED 2026-05-31 — Europe artillery-recruit escalation
                                                          counter. cost += count*100 then count++ each time a type-0x0B
                                                          (Artillery) colonist is recruited from the pool. Read×100 at
                                                          file 0x035124/0x03527B, INC at 0x035282, zeroed at new-game
                                                          init 0x03662F. == pavelbel artillery_bought_count. */
    u16       boycott_bitfield;                /* +0x20  VERIFIED — bit i = commodity i boycotted */
    i32       royal_money;                     /* +0x22  VERIFIED — drives REF growth; grows ~+18/turn */
    u8        unknown_26[4];                   /* +0x26..+0x29  UNKNOWN */
    u32       gold;                            /* +0x2A  VERIFIED — treasury (32-bit dword) */
    u32       lifetime_treasure_or_unknown_2E; /* +0x2E..+0x31  PARTIAL — receives same gold add as +0x2A in
                                                          treasure_train_cash_in (`func_05C878`); replaces the
                                                          earlier "+0x30 recruit_cost u16" guess. The doubling
                                                          recruit-cost field lives elsewhere — TBD */
    u8        home_x;                          /* +0x32  VERIFIED 2026-05-08 — player's home colony / spawn-back
                                                          X coordinate (byte). Copied to UnitRecord +0x07 (map_x)
                                                          when a unit spawns at home. Read at file 0x058BBA,
                                                          0x075916; written at 0x065CCB. PREVIOUSLY mis-labelled
                                                          as ref_strength_total u16 — that was wrong (the
                                                          5 MOV-byte sites here are home-coordinate accesses) */
    u8        home_y;                          /* +0x33  VERIFIED 2026-05-08 — player's home spawn-back Y
                                                          coordinate (byte). Copied to UnitRecord +0x08 (map_y).
                                                          Read at 0x058BC6, 0x058D7E, 0x05961C, 0x075922.
                                                          Written at 0x065CD2 alongside +0x32. */
    u8        unknown_34[16];                  /* +0x34..+0x43  UNKNOWN — pavelbel: REF foot/dragoon counts */
    u8        ref_foot_count;                  /* +0x44  PARTIAL — pavelbel-confirmed; runtime evidence indirect */
    u8        ref_dragoon_count;               /* +0x45  PARTIAL */
    u8        ref_man_o_war_count;             /* +0x46  PARTIAL */
    u8        unknown_47;                      /* +0x47  UNKNOWN */
    u8        unknown_48[4];                   /* +0x48..+0x4B  UNKNOWN — pavelbel: trade-route flags + immigration timer */
    u8        market_saturation[NUM_COMMODITIES]; /* +0x4C..+0x5B  PARTIAL — per-good 0xC8 = saturated (Europe shows 0/0) */
    u8        unknown_5C[228];                 /* +0x5C..+0x13F  UNKNOWN — score components, immigration queue,
                                                          per-power purchase progression, AI personality cache */
} PowerRecord;
/* sizeof(PowerRecord) MUST equal 316 — verify with static_assert in your build */


/* ----------------------------------------------------------------------------
 * ColonyRecord — 202 bytes (0xCA). Base: TBD (accessed via g_active_colony).
 *
 * NO separate 174-byte "working buffer" exists. Earlier hypothesis was
 * REJECTED. Persistent stride is the only stride.
 * ---------------------------------------------------------------------------- */
typedef struct ColonyRecord {
    u8        map_x;                           /* +0x00  VERIFIED */
    u8        map_y;                           /* +0x01  VERIFIED */
    char      name[24];                        /* +0x02..+0x19  VERIFIED — null-terminated colony name */
    u8        owner_idx;                       /* +0x1A  VERIFIED — power_idx, 0..3 typically (player owned) */
    u8        unknown_1B;                      /* +0x1B  PARTIAL — pavelbel: unknown08a (1 byte) */
    u8        colony_flags;                    /* +0x1C  PARTIAL — pavelbel: SoL bonuses, blink flag */
    u8        unknown_1D[2];                   /* +0x1D..+0x1E  PARTIAL — pavelbel: unknown08b (2 bytes) */
    u8        size;                            /* +0x1F  VERIFIED — number of colonists in colony */
    u8        unknown_20;                      /* +0x20  SUSPECTED — population_on_map per-nation visibility byte */
    u8        unknown_21;                      /* +0x21  UNKNOWN */
    u16       state_packed;                    /* +0x22  VERIFIED — colony_state_packed; high/low byte = SoL/Tory display */
    u8        unknown_24[28];                  /* +0x24..+0x3F  UNKNOWN — pavelbel: profession array start */
    u8        colonist_jobs[32];               /* +0x40..+0x5F  VERIFIED at +0x40 (job byte = NAMES.TXT @JOB idx).
                                                          Stride/length not byte-confirmed beyond first slot. */
    u8        buildings_bitmask[16];           /* +0x60..+0x6F  VERIFIED — 3 bits per upgrade chain.
                                                          Chains: Stockade→Fort→Fortress, Carpenter→Lumber Mill,
                                                          Blacksmith→Iron→Steel, etc. */
    u8        tile_workers[8];                 /* +0x70..+0x77  VERIFIED — NW/N/NE/W/E/SW/S/SE order;
                                                          value = colonist idx in colonist_jobs[],
                                                          0xFF = empty */
    u8        unknown_78[28];                  /* +0x78..+0x93  PARTIAL — pavelbel: custom_house_flags (2)
                                                          + unknown11 (6) + intervening fields */
    u16       custom_house_flags;              /* +0x76 area? PARTIAL — bit i = good i auto-sold */
    /* The following are NOT contiguous — pavelbel field offsets relative to SAV
     * record may not 1:1 match runtime offsets. Treat as sparse map: */
    u8        unknown_94[6];                   /* +0x94..+0x99  UNKNOWN */
    u16       stockpile[NUM_COMMODITIES];      /* +0x9A..+0xB9  VERIFIED on Plymouth frame 1310196718 */
    u16       hammers;                         /* +0xBA  VERIFIED — current hammers toward construction */
    u8        building_in_production;          /* +0xBC  VERIFIED — index into NAMES.TXT @BUILDING */
    u8        warehouse_level;                 /* +0xBD  PARTIAL — pavelbel: 0=base/100, 1=warehouse/200, 2=expansion/300 */
    u8        unknown_BE;                      /* +0xBE  UNKNOWN — pavelbel: unknown12a */
    u8        depletion_counter;               /* +0xBF  PARTIAL — pavelbel: depletion_counter */
    u16       hammers_purchased;               /* +0xC0  PARTIAL — pavelbel: hammers_purchased */
    i32       rebel_dividend;                  /* +0xC2  VERIFIED — Sons of Liberty numerator (Plymouth=66) */
    i32       rebel_divisor;                   /* +0xC6  VERIFIED — Sons of Liberty denominator (Plymouth=617);
                                                          SoL_pct = 100 * rebel_dividend / rebel_divisor */
} ColonyRecord;
/* SoL formula: VERIFIED. Plymouth 66/617 = 10.7% matches in-game display. */


/* ----------------------------------------------------------------------------
 * UnitRecord — 28 bytes (0x1C). Base: DGROUP:0x3146.
 * 256 slots; +0x00 = 0 or 0xFF marks empty slot.
 *
 * Many trailing-region offsets come from pavelbel SAV schema; runtime
 * confirmation is THIN past +0x10. Treat as PARTIAL.
 * ---------------------------------------------------------------------------- */
typedef struct UnitRecord {
    u8        unit_type;                       /* +0x00  VERIFIED — index into NAMES.TXT @UNIT (0..23);
                                                          ICONS sprite = @UNIT[unit_type].col1 */
    u8        nation_info;                     /* +0x01  VERIFIED — low nibble = power_idx, high nibble = visibility flags */
    u8        damaged_or_unknown;              /* +0x02  PARTIAL — pavelbel: 7 unknown bits + 1 damaged bit (ships) */
    u8        moves_used;                      /* +0x03  PARTIAL — pavelbel: moves used this turn */
    u8        origin_settlement;               /* +0x04  PARTIAL — pavelbel: COLONY idx (colonist) or TRIBE idx (brave) */
    u8        ai_plan_mode_char;               /* +0x05  PARTIAL — pavelbel: ASCII char for AI plan; only AI-owned units */
    u8        orders;                          /* +0x06  VERIFIED — NAMES.TXT @ORDERS code:
                                                          '-'=None, 'S'=Sentry, 'F'=Fortify, 'T'=Trade,
                                                          'G'=Goto, 'L'=Live(in colony), 'P'=Plow, 'R'=Road */
    u8        map_x;                           /* +0x07  VERIFIED */
    u8        map_y;                           /* +0x08  VERIFIED */
    u8        goto_x;                          /* +0x09  PARTIAL — pavelbel goto_x */
    u8        goto_y;                          /* +0x0A  PARTIAL */
    u8        unknown_0B;                      /* +0x0B  UNKNOWN — pavelbel: unknown18 */
    u8        holds_occupied;                  /* +0x0C  PARTIAL — pavelbel: holds in use (cargo/passenger count) */
    u8        cargo_items[3];                  /* +0x0D..+0x0F  PARTIAL — packed 4-bit cargo type pairs (6 cargo holds) */
    u8        cargo_qty[6];                    /* +0x10..+0x15  PARTIAL — pavelbel cargo_hold quantities */
    u8        turns_worked;                    /* +0x16  PARTIAL — Pioneer plow/road progress; statesman bell duration */
    u8        profession_or_treasure_amount;   /* +0x17  PARTIAL — colonist: NAMES.TXT @JOB idx;
                                                          Treasure Train: gold/100 (0x32 = 50 → 5,000 gold) */
    i16       transport_next_unit_idx;         /* +0x18  PARTIAL — linked-list next for ship cargo */
    i16       transport_prev_unit_idx;         /* +0x1A  PARTIAL — linked-list prev */
} UnitRecord;
/* sizeof(UnitRecord) = 28 — VERIFIED at 0x04A7D5: IMUL bx, [bp+6], 0x1C */


/* ----------------------------------------------------------------------------
 * NativeSettlement — 18 bytes (0x12). Base: DGROUP:0x54EC.
 *
 * Compacted on raze (table shifts down). User razed Inca cap (38,54)
 * and the table compaction was directly observed.
 * ---------------------------------------------------------------------------- */
typedef struct NativeSettlement {
    u8        map_x;                           /* +0x00  VERIFIED */
    u8        map_y;                           /* +0x01  VERIFIED */
    u8        owner_tribe_idx;                 /* +0x02  VERIFIED — 4..11 (NUM_EUROPEAN_POWERS..NUM_POWERS-1)
                                                          Inca=4? Aztec=5? — exact map UNKNOWN; cross-ref
                                                          against NAMES.TXT @TRIBES order */
    u8        blcs_flags;                      /* +0x03  VERIFIED — bit 0 brave_missing,
                                                                    bit 1 learned (skill teachable),
                                                                    bit 2 capital,
                                                                    bit 3 scouted (chief spoken to) */
    u8        population;                      /* +0x04  VERIFIED — number of dwellers; 0..13 */
    u8        mission;                         /* +0x05  VERIFIED — bits: 0x10 = mission active;
                                                          low nibble = mission-owner power_idx */
    i8        growth_counter;                  /* +0x06  PARTIAL — pavelbel: signed; spawns brave at 20 */
    u8        sentinel_FF;                     /* +0x07  PARTIAL — pavelbel: always 0xFF (unknown28a) */
    u8        last_bought;                     /* +0x08  PARTIAL — pavelbel: last commodity bought */
    u8        last_sold;                       /* +0x09  PARTIAL — pavelbel: last commodity sold */
    struct {
        u8 friction;
        u8 attacks_queued;
    } alarm[4];                                /* +0x0A..+0x11  VERIFIED — per-European-nation friction +
                                                          retaliation count (NOT a global table — it's per-settlement) */
} NativeSettlement;


/* ----------------------------------------------------------------------------
 * TribeData — 78 bytes (0x4E). Base: DGROUP:0x5AD6.
 *
 * Updated 2026-05-08 from runtime memory dump
 * (session_1777952458/mem/1310473156000000.zst). Several fields
 * verified, most still UNKNOWN.
 * ---------------------------------------------------------------------------- */
typedef struct TribeData {
    u8        always_one_a;                    /* +0x00  PARTIAL — observed = 0x01 for all 8 tribes;
                                                          probably "is_initialized" flag */
    u8        always_one_b;                    /* +0x01  PARTIAL — observed = 0x01 for all 8 tribes */
    u8        civ_tier;                        /* +0x02  VERIFIED — civilization tier 0..3
                                                          matching NAMES.TXT @TRIBES column 4:
                                                            Inca=3, Aztec=2,
                                                            Arawak/Iroquois/Cherokee=1,
                                                            Apache/Sioux/Tupi=0
                                                          Used by CHIEFKILL formula at 0x04AB24:
                                                            gold = sum_3 × roll_4 × 4 × (civ_tier + 1)
                                                          Max gold per tribe at Discoverer:
                                                            Inca:    720 × 4 = 2,880
                                                            Aztec:   720 × 3 = 2,160
                                                            mid:     720 × 2 = 1,440
                                                            nomadic: 720 × 1 =   720 */
    u8        flags_03;                        /* +0x03  PARTIAL — 0 for most tribes; Tupi has 0x80 (high bit) */
    u8        unknown_04;                      /* +0x04  UNKNOWN */
    u8        flag_05;                         /* +0x05  PARTIAL — 0x02 for Arawak only, 0x00 for all others */
    u8        unknown_06_0B[6];                /* +0x06..+0x0B  UNKNOWN */
    u8        per_tribe_byte_0C;               /* +0x0C  PARTIAL — varies per tribe:
                                                          Inca=0x87, Aztec=0x22, Arawak=0x01, others=0.
                                                          Likely contact-status bitfield (per-power) or
                                                          settlement-list-head indicator */
    u8        unknown_0D_35[41];               /* +0x0D..+0x35  UNKNOWN — likely skills_offered[4],
                                                          goods_wanted[4], capital_name_idx, climate
                                                          per pavelbel SAV INDIAN section, but offsets
                                                          not byte-confirmed */
    u8        per_tribe_byte_36;               /* +0x36  PARTIAL — Inca=0x07, Aztec=0x06, Tupi=0xFE;
                                                          could be alarm-base or aggression weight */
    u8        unknown_37_39[3];                /* +0x37..+0x39 */
    u8        per_tribe_byte_3A;               /* +0x3A  PARTIAL — Inca=0x60 (96), Aztec=0x64 (100),
                                                          Tupi=0x64 (100); could be base-attitude */
    u8        unknown_3B_3C[2];                /* +0x3B..+0x3C */
    u8        per_tribe_byte_3D;               /* +0x3D  PARTIAL — Inca=0x60, others=0 */
    u8        unknown_3E_45[8];                /* +0x3E..+0x45 */
    u8        per_tribe_byte_46;               /* +0x46  PARTIAL — Inca=0x09, Aztec=0x0F, Tupi=0x2F (47);
                                                          could be settlement count or max-pop counter */
    u8        unknown_47_49[3];
    u8        per_tribe_byte_4A;               /* +0x4A  PARTIAL — Inca=0x01, Aztec=0x05, Tupi=0x01 */
    u8        unknown_4B_4D[3];
} TribeData;
/* sizeof TribeData = 78 — VERIFIED via stride checks */


/* ----------------------------------------------------------------------------
 * AIPersonality — 52 bytes (0x34). Base: DGROUP:0x540E.
 *
 * 4 European entries only (NOT 12). Native tribes use TribeData fields.
 *
 * Updated 2026-05-04: a brute-force scan of every `IMUL bx, [bp+N], 0x34`
 * + indexed-byte access showed only TWO offsets are read in the entire
 * disasm: +0x31 (282 read sites!) and +0x32 (5 read sites). The other
 * 50 bytes are populated at game-init from NAMES.TXT @PERSONALITY but
 * read only by AI-internal code that hasn't been hand-traced yet.
 * ---------------------------------------------------------------------------- */
typedef struct AIPersonality {
    u8        unknown_00[0x31];                /* +0x00..+0x30  UNKNOWN — aggression / expansion / hostility
                                                          weights per NAMES.TXT @PERSONALITY suspected here;
                                                          consumed only by AI-internal code paths not yet traced */
    u8        is_ai_controlled;                /* +0x31  VERIFIED — 0 = human, !=0 = AI;
                                                          gates every player-facing popup (CHIEFKILL /
                                                          EXTORTLAUGH / NOCONTACT / CASHTREASURE / ...).
                                                          Read at 282 sites in the disasm.
                                                          Pattern: IMUL bx, [bp+power_idx], 0x34
                                                                   CMP byte [bx + 0x543F], 0
                                                                   JE show_message_to_human */
    u8        secondary_ai_flag_TBD;           /* +0x32  PARTIAL — tested 5 times; possibly
                                                          "is_ref_or_special_pseudo_power" — semantics TBD */
    u8        unknown_33;                      /* +0x33  UNKNOWN */
} AIPersonality;
/* sizeof AIPersonality = 52 — VERIFIED at 0x04A874: IMUL bx, [bp+8], 0x34 */


/* ============================================================================
 * 5. DATA ENUMS — drawn from NAMES.TXT (canonical game data)
 *
 * NAMES.TXT @-sections are loaded at game start by func_0749E0 (BYTE_VERIFIED
 * loader). Every game data table lives in NAMES.TXT — NOT hardcoded in EXE.
 * ============================================================================ */

/* Power index — order is ENG, FR, SP, NL, then 8 tribes by NAMES.TXT @TRIBES order */
typedef enum PowerIdx {
    POWER_ENGLAND     = 0,
    POWER_FRANCE      = 1,
    POWER_SPAIN       = 2,
    POWER_NETHERLANDS = 3,
    POWER_FIRST_TRIBE = 4,    /* tribes start here; +4..+11 = Inca,Aztec,Arawak,Iroquois,Cherokee,Apache,Sioux,Tupi */
    POWER_INCA        = 4,
    POWER_AZTEC       = 5,
    POWER_ARAWAK      = 6,
    POWER_IROQUOIS    = 7,
    POWER_CHEROKEE    = 8,
    POWER_APACHE      = 9,
    POWER_SIOUX       = 10,
    POWER_TUPI        = 11,
} PowerIdx;
/* Power-color palette indices: ENG=12 red, FR=9 blue, SP=14 yellow, NL=13 orange */
/* (NAMES.TXT @COUNTRY column 6) */

/* Tribe color (palette index in VICEROY.PAL) — VERIFIED from NAMES.TXT @TRIBES col-5 */
#define TRIBE_COLOR_INCA       97   /* #f7f3c7 cream */
#define TRIBE_COLOR_AZTEC      149  /* #c7a220 gold/ochre — matches "Gold Bars" treasure theme */
#define TRIBE_COLOR_ARAWAK     54   /* #698ac3 blue */
#define TRIBE_COLOR_IROQUOIS   87   /* #6d3c18 dark brown */
#define TRIBE_COLOR_CHEROKEE   67   /* #75a64d green */
#define TRIBE_COLOR_APACHE     111  /* #c3ae86 tan */
#define TRIBE_COLOR_SIOUX      118  /* #920000 dark red */
#define TRIBE_COLOR_TUPI       71   /* #045d04 dark green */
/* CIVILIZATION TIER from @TRIBES col-4: Inca=3, Aztec=2, Arawak=1, Iroquois=1,
 * Cherokee=1, Apache=0, Sioux=0, Tupi=0 — controls max population per settlement */

/* Unit types — full mapping in extracted/text/NAMES_sections.json @UNIT */
/* ICONS sprite index for each unit_type comes from @UNIT col 1 (VERIFIED). */
typedef enum UnitType {
    UT_CARAVEL          = 0,    /* ICONS  6 */
    UT_MERCHANTMAN      = 1,    /* ICONS  7 */
    UT_GALLEON          = 2,    /* ICONS  8 */
    UT_PRIVATEER        = 3,    /* ICONS 14 (suspected; verify) */
    UT_FRIGATE          = 4,    /* ICONS 15 */
    UT_MAN_O_WAR        = 5,    /* ICONS 128 */
    UT_FREE_COLONIST    = 6,    /* ICONS 101 */
    UT_PIONEER          = 7,    /* ICONS 102 */
    UT_SOLDIER          = 8,    /* ICONS 103 */
    UT_SCOUT            = 9,    /* ICONS 104 */
    UT_DRAGOON          = 10,   /* ICONS 105 */
    UT_MISSIONARY       = 11,   /* ICONS 106 */
    UT_BRAVE            = 12,   /* ICONS 110 */
    UT_ARMED_BRAVE      = 13,   /* ICONS 111 */
    UT_MOUNTED_BRAVE    = 14,   /* ICONS 112 */
    UT_MOUNTED_WARRIOR  = 15,   /* ICONS 113 */
    UT_TREASURE_TRAIN   = 16,   /* ICONS  17 — value at UnitRecord +0x17 × 100 */
    UT_REGULAR          = 17,   /* ICONS 126 — REF foot */
    UT_KING_CAVALRY     = 18,   /* ICONS 127 — REF cav */
    UT_CONTINENTAL_ARMY = 19,   /* ICONS 129 — post-revolution */
    UT_CONTINENTAL_CAV  = 20,   /* ICONS 130 */
    UT_WAGON_TRAIN      = 21,   /* ICONS  9 */
    UT_ARTILLERY        = 22,   /* ICONS 10 */
    /* PARTIAL — verify last entry against NAMES.TXT @UNIT */
} UnitType;

/* Commodity index (0..15). ICONS sprite = 22 + commodity_idx (VERIFIED). */
typedef enum Commodity {
    GOOD_FOOD = 0,    GOOD_SUGAR = 1,    GOOD_TOBACCO = 2,  GOOD_COTTON = 3,
    GOOD_FURS = 4,    GOOD_LUMBER = 5,   GOOD_ORE = 6,      GOOD_SILVER = 7,
    GOOD_HORSES = 8,  GOOD_RUM = 9,      GOOD_CIGARS = 10,  GOOD_CLOTH = 11,
    GOOD_COATS = 12,  GOOD_TRADE = 13,   GOOD_TOOLS = 14,   GOOD_MUSKETS = 15,
} Commodity;

/* Order code — UnitRecord +0x06 byte (ASCII char per NAMES.TXT @ORDERS) */
#define ORDER_NONE       '-'
#define ORDER_SENTRY     'S'
#define ORDER_FORTIFY    'F'
#define ORDER_TRADE      'T'
#define ORDER_GOTO       'G'
#define ORDER_LIVE       'L'   /* in colony */
#define ORDER_PLOW       'P'
#define ORDER_ROAD       'R'
#define ORDER_CLEAR      'C'   /* clear forest */


/* ============================================================================
 * 6. KNOWN FUNCTION OFFSETS (file offsets in VICEROY.EXE)
 *
 * Only the BYTE_VERIFIED ones. ~1,143 other functions exist with no
 * semantic name yet — Ghidra will show them as func_NNNNNN_unknown.
 * ============================================================================ */

/* --- Game-system core --- */
/* file 0x0103D4 */ extern u16  rand(void);                              /* MSC 6.0 LCG, BYTE_VERIFIED */
/* file 0x00C322 */ extern u16  random_int(u16 lo, u16 hi);              /* (lo..=hi) inclusive, BYTE_VERIFIED */
/* file 0x0081C6 */ extern void set_active_tribe(u16 tribe_idx);         /* sets g_active_settlement, BYTE_VERIFIED */
/* file 0x067DC8 */ extern void compute_dialog_rect(/* args */);         /* BYTE_VERIFIED — popup geometry calc */

/* --- Native diplomacy / events --- */
/* file 0x04A7CA */ extern void chief_greet_or_kill(u16 power_idx, u16 unit_idx, u16 settlement_idx);
                   /* "CHIEFHOWDY" / "CHIEFKILL" handler. Function actually extends
                    * to ~0x04ABFC (disasm file is truncated at 0x04A9C5).
                    * CHIEFKILL gold formula at 0x04AACD..0x04AB6E:
                    *
                    *   diff   = g_difficulty;                     // [0x53A6]
                    *   upper  = 10 - diff;
                    *   sum_3  = random_int(1, upper)
                    *          + random_int(1, upper)
                    *          + random_int(1, upper);
                    *   roll_4 = random_int(1, 6);
                    *   gold   = sum_3 * roll_4 * 4
                    *          * (g_active_settlement->something_at_+0x02 + 1);
                    *   show_treasure_popup(gold, 0);
                    *   if (power_idx < 4 && !g_ai_personality_flag_at_+0x3F) {
                    *       show_msg_template("CHIEFKILL");
                    *   }
                    *   g_power_table[power_idx].gold += gold;     // 32-bit ADD/ADC
                    *
                    * NOTE: there is NO capital-bonus branch in this function.
                    * The elevated Inca/Aztec capital totals must come from a
                    * SEPARATE @LOSTCITY2/Cibola treasure handler — UNKNOWN. */

/* file 0x04AC00 */ extern void extort_laugh_handler(/* args */);        /* "EXTORTLAUGH" tribute-refusal path */

/* file 0x049600..0x04A37A  (3,450 bytes — full extent) */
extern void lost_city_or_cibola_treasure_handler(u16 unit_idx, u16 power_idx, u16 tile_or_settlement);
                   /* VERIFIED-PARTIAL 2026-05-08. **Function spans
                    * 0x049600..0x04A37A (3,450 bytes) — disassembler tool
                    * truncated the function body at file 0x4969+ on bytes
                    * (9A CA 04 1F) it tagged as DATA_BYTE; those bytes are
                    * actually a valid LCALL 0x1F04:0x... instruction.
                    *
                    * Full pseudo-C reconstruction of the gold-amount slice
                    * (220 bytes at 0x04A005..0x04A0E1) in
                    * RESIDUAL_FINDINGS.md §17. Summary:
                    *
                    *   amount = 200;
                    *   if (ship discovering)  *(i16*)0x8DC4 >>= 2;
                    *   if (K >= 8)            amount = (8 - civ_tier) * 50;
                    *   if (K >= 7)            amount += K_lookup[power*16+K]
                    *                                   * (g_difficulty*2 + 15);
                    *   amount += random_int(0, amount);
                    *   amount -= some_array[some_idx] * 4;
                    *   amount += helper_181F_30C(...) * 4;
                    *   amount = amount * (*(i16*)0x8DC4) / 100;
                    *   amount += (g_difficulty + random_int(0,2)) * 10;
                    *   if (amount < 50) amount = 50;
                    *   *(u32*)0x9CB8 = amount;
                    *   push_popup_arg(amount, 3);
                    *   g_power_table[power_idx].gold += amount;
                    *
                    * Still UNKNOWN: identity of the K stack-local lookup,
                    * the 0x84BC table, the 0x9E78 array, and the function
                    * that sets *(i16*)0x8DC4 (the dominant scaling factor)
                    * before this handler is called. */

/* file 0x05C878 */ extern i32  treasure_train_cash_in(u16 unit_idx, u16 power_idx, u16 ctx);
                   /* VERIFIED 2026-05-04 (RESIDUAL_FINDINGS.md §7).
                    * Tagged "CASHTREASURE", "KINGGALLEON", "LOOTCASH".
                    *
                    *   gross   = unit.profession_or_treasure_amount * 100;
                    *   if (g_revolution_flags & 1) {
                    *       g_power_table[power_idx].gold += gross;       // +0x2A
                    *       show_msg_template(power_idx, "CASHTREASURE");
                    *   } else {
                    *       tax_cut = compute_tax_cut(gross, tax_rate);   // tax_rate = +0x01
                    *       net = gross - tax_cut;
                    *       g_power_table[power_idx].royal_money += tax_cut;  // +0x22
                    *       g_power_table[power_idx].gold        += net;      // +0x2A (32-bit)
                    *       g_power_table[power_idx].field_2E    += net;      // +0x2E (32-bit, lifetime?)
                    *   }
                    *
                    * Independently confirms PowerRecord +0x01 (tax_rate),
                    * +0x22 (royal_money), +0x2A (gold u32), and the new
                    * +0x2E..+0x31 u32 lifetime-treasure (?) counter. */

/* orphan range 0x00C4DB..0x00C51A */
extern void color_cycle_tick(u16 ctx);
                   /* VERIFIED 2026-05-04 (RESIDUAL_FINDINGS.md §6).
                    * Iterates g_cycle_dat_buffer.entries[0..count-1],
                    * sums each entry's start_idx into g_cycle_running_sum
                    * (DGROUP:0x92C2), zeros each entry's phase byte,
                    * sets g_cycle_state_flag (DGROUP:0x92C0) to 3 or 0
                    * based on running-sum threshold 0x10. */

/* orphan range 0x00C5E7..0x00C646 */
extern void color_cycle_palette_write(u16 enable);
                   /* VERIFIED 2026-05-04. Iterates entries, advances each
                    * entry's phase (with wrap-around on bp-4 limit),
                    * pushes phase byte back into g_cycle_dat_buffer entry,
                    * then LCALLs the VGA palette writer at 0x0C2E:0x0022
                    * with args derived from entries[*].end_idx and
                    * g_cycle_running_sum. */
/* file 0x03ECF0 */ extern void native_diplomatic_dispatch(/* args */);  /* hand-traced opcodes; semantics PARTIAL */

/* --- King events --- */
/* file 0x034AE0 */ extern void king_attempt_tax_change(void);
                   /* BYTE_VERIFIED — tax delta = (((diff & 0xFE) * 2 + 4) * (turn/400 + 1));
                    * pseudo-C in viceroy_source/src/king/king_tax_raise.c */

/* --- Score / rendering --- */
/* file 0x03A9C0 */ extern u32  compute_score(void);                     /* score-formula renderer, line-annotated */

/* --- Colony / production --- */
/* file 0x02D658 */ extern void colony_screen_dispatch(/* args */);      /* line-annotated; calls 6 overlay sub-renderers */
/* file 0x00A3E1 */ extern void colony_turn_update(/* args */);          /* sugar→rum, tobacco→cigars, ore→tools chain */

/* --- Market / economy --- */
/* file 0x0305A8 */ extern void market_price_drift(void);                /* line-annotated; PRICEUP/DOWN message paths traced */

/* --- Win / lose / endgame --- */
/* file 0x02F3A2 */ extern bool check_win_or_lose(void);                 /* line-annotated */

/* --- AI --- */
/* file 0x04E2D6 */ extern void ai_action_dispatcher(u8 power_idx);
                   /* 584-byte switch over 11 AI sub-actions; per-branch logic UNKNOWN */

/* --- Data-table loaders --- */
/* file 0x0749E0 */ extern void load_names_txt_sections(void);
                   /* BYTE_VERIFIED at @-section level — loads 40+ NAMES.TXT sections at game-init */

/* --- File / asset loaders --- */
/* file 0x0783E4 */ extern void load_cycle_dat(void);
                   /* VERIFIED — loads 34 bytes from CYCLE.DAT into g_cycle_dat_buffer.
                    * Payload semantics UNKNOWN (consumer not yet traced).
                    * Raw payload bytes captured in docs/RESIDUAL_FINDINGS.md §1 */

/* --- UI framework --- */
/* file 0x06F0F4 */ extern void dialog_framework(/* args */);            /* line-annotated dialog core */
/* file 0x06EEEC */ extern void parse_text_template(/* args */);         /* %STRING/%NUMBER/%YEAR/%COUNTRY substitution */
/* file 0x07431E */ extern void render_popup(/* args */);                /* reads g_screen_clip_rect at 0x839E */

/* --- Tile rendering --- */
/* file ~func_O514 */ extern void render_tile_chain(/* args */);         /* line-annotated; calls O513→O512 sub */

/* --- Math / formatting helpers --- */
/* file 0x00260E */ extern void format_to_buffer_2D54(u16 a, u16 b);     /* DGROUP:0x2D54 scratch */


/* ============================================================================
 * 7. KEY THUNK TARGETS (LCALL 0x181F:NNN — Type B thunks, JMP-FAR to load image)
 *
 * Most of the LCALL 0x181F:NNN calls aren't overlays — they're JMP-FAR
 * thunks resolving to fixed paragraphs in the load image. Decode in
 * Ghidra by following the JMP at the thunk's far target.
 * ============================================================================ */

/* LCALL 0x181F:0x04D4  →  random_int(lo, hi)            ; appears EVERYWHERE; sig: PUSH hi, PUSH lo, LCALL */
/* LCALL 0x181F:0x09AE  →  show_treasure_popup           ; signed 32-bit + power_idx */
/* LCALL 0x181F:0x0438  →  push_to_popup_buffer          ; per-arg PUSH(value, slot_idx) */
/* LCALL 0x181F:0x09A4  →  get_unit_record_or_xref       ; takes unit_idx, returns ax */
/* LCALL 0x181F:0x09E6  →  fetch_settlement_record(idx)  ; loads next NativeSettlement entry */
/* LCALL 0x181F:0x0E86  →  open_file(filename, mode)     ; returns file handle (Borland fopen) */
/* LCALL 0x181F:0x0CE0  →  tile_clip_check               ; (x, y) in viewport bounds */
/* LCALL 0x181F:0x07B4  →  ascii_arg_check               ; per-power 0x4B threshold check */
/* LCALL 0x181F:0x0302  →  visibility_test(x, y)         ; per fog-of-war */
/* LCALL 0x181F:0x078C  →  read_map_terrain(x, y)        ; .MP layer 1 byte */

/* LCALL 0x191F:0x019C  →  show_msg_template(power, key) ; queues GAME.TXT @-section message */
/* LCALL 0x191F:0x0928  →  ???                           ; called by dialog_framework — UNKNOWN target */
/* LCALL 0x191F:0x0ED0  →  blit_sprite_block             ; sprite render */

/* LCALL 0x0D1D:0x0528  →  fread(buf, size, n, handle)   ; Borland C runtime */
/* LCALL 0x0D1D:0x03F4  →  fclose(handle)                ; Borland C runtime */
/* LCALL 0x0D1D:0x07A4  →  formatted-output helper       ; takes (slot_id, value) */
/* LCALL 0x0D1D:0x11B4  →  format-engine                 ; (buffer, fmt, args) */
/* LCALL 0x0D1D:0x0DAB  →  RTLink overlay loader         ; segment-id → overlay page */


/* ============================================================================
 * 8. ASSET FILE ROLES (read-only)
 * ============================================================================ */

/* --- Game data tables (text) --- */
/* COLONIZE/NAMES.TXT       — 40+ @-sections; loaded at start by func_0749E0      VERIFIED */
/* COLONIZE/GAME.TXT        — 510 @-sections; dialog/popup message templates      VERIFIED */
/* COLONIZE/LABELS.TXT      — 7 sections; UI labels (advisor titles, etc.)        VERIFIED */
/* COLONIZE/PEDIA.TXT       — 163 entries; Colonopedia content                    VERIFIED */
/* COLONIZE/CONFIG.TXT      — BLASTER= sound config (DOS env)                     VERIFIED */

/* --- Sprite sheets (.SS) — pixel-verified roles per docs/SPRITE_CATALOG.md --- */
/* PHYS0.SS    — 154 sprites — terrain features (rivers idx 0x01/0x11, hills 0x31, mountains 0x21, coasts 150-153) */
/* TERRAIN.SS  — per-terrain textured ground (re-extracted 2026-04-25)            VERIFIED */
/* ICONS.SS    — 266 sprites — units (100-105, 109, 110-113, 126-130, 5-8, 14-17),
 *               commodities (22-37), cursors (0-7), boycott red-X (43)            VERIFIED */
/* BUILDING.SS — 48 sprites — colony buildings (per @BUILDING upgrade chains)     VERIFIED */
/* CC-NN.SS    — 25 sprites — Founding Father portraits (matches PowerRecord +0x07 bit) */
/* MSS / MYR   — half-figure speakers (4-6 each) for popup events                 VERIFIED */
/* IND0..IND7  — 8 native tribe sprites (in NAMES.TXT @TRIBES order)              VERIFIED */
/* WDCUT*.SS   — 13 woodcut event scenes (e.g. WDCUT12 = @RAIDBURN)               VERIFIED */
/* SCORE01-24  — 24 end-game score plates (Grand Canyon, Sheriff, USA outline,…)  VERIFIED */
/* KING/KING1/KING2/KINGLOSE/KINGWIN — king cinematic frames                      VERIFIED */
/* NAMEPLAT.SS — 3 sprites — colony nameplate flag composite                      VERIFIED */
/* CLOS-*.SS   — 7 closing cinematic sprites                                      VERIFIED */
/* OPEN*.SS    — 15 opening cinematic sprites                                     VERIFIED */
/* DEC-*.SS    — 53 cursive letters (52 alpha + 1 squiggle) — Declaration screen  VERIFIED */
/* CURSOR.SS   — 2 sprites: arrow + click-target dot                              VERIFIED */
/* DO NOT LOAD — BDARK.SS  (suspected orphan; not pixel-verified) */

/* --- Backgrounds (.PIK) --- */
/* CCBKGD, EUROPE, COLONY, NATIONS, DIFFICUL, OPENING, DECLARAT, KINGLSS1/2,      */
/* WIN, REPORT1..REPORT9, LEVN0001..LEVN0010 (scenario thumbnails)                */

/* --- Map & save data --- */
/* *.MP        — terrain (1B/tile) + feature bits (0x40 river, 0x80 road, 0xB0 lost-city, etc.)
 *               + visibility layer; header = width × height bytes                VERIFIED */
/* GAME.SAV    — see docs/SAVE_FORMAT_CROSSREF.md (pavelbel JSON schema)          VERIFIED */
/* HALLFAME.DAT — 1,362 bytes; record layout PARTIAL */

/* --- Audio --- */
/* ASOUND.COL — MZ DOS executable: AdLib FM driver         (file starts 4D 5A)   VERIFIED */
/* GSOUND.COL — MZ DOS executable: SoundBlaster + GameBl   (file starts 4D 5A)   VERIFIED */
/* PSOUND.COL — MZ DOS executable: PC Speaker driver       (file starts 4D 5A)   VERIFIED */
/* RSOUND.COL — MZ DOS executable: Roland MT-32 driver     (file starts 4D 5A)   VERIFIED */
/* CONFIG.COL — 20 bytes — selected device config (port 0x220, IRQ 7, etc.)      VERIFIED */
/* COLDIG.BIN — 993,755 bytes — raw 8-bit unsigned PCM, headerless;
 *              per-effect index lives inside the loaded .COL driver             VERIFIED */
/* (NO .MSC files exist; music is embedded in the .COL driver overlays)          VERIFIED */

/* --- Color cycling --- */
/* CYCLE.DAT  — 34 bytes; payload semantics UNKNOWN (resembles x86 dispatch
 *              code, not a palette-range descriptor); loader at file 0x0783E4   PARTIAL */

/* --- Palette --- */
/* VICEROY.PAL — 1024 bytes; 256-entry RGB palette (VGA 6-bit encoded)            VERIFIED */


/* ============================================================================
 * 9. KEY GAME FORMULAS (BYTE_VERIFIED unless noted)
 * ============================================================================ */

/* --- King tax raise (file 0x034AE0, viceroy_source/src/king/king_tax_raise.c) --- */
/* delta = ((difficulty & 0xFE) * 2 + 4) * (turn / 400 + 1)                         VERIFIED */

/* --- King anger (Tea Party) --- */
/* g_king_anger++   per Tea Party                                                   VERIFIED */
/* (does NOT directly drive REF growth — that's royal_money)                        VERIFIED */

/* --- REF growth driver --- */
/* g_power_table[power_idx].royal_money += ~18 per turn (rate UNKNOWN)              PARTIAL */
/* When royal_money crosses threshold, +1 REF unit added.
 * Threshold value > 1188 (no growth seen in tested sessions)                       UNKNOWN */

/* --- CHIEFKILL (native village raze) --- */
/* See chief_greet_or_kill() above — VERIFIED end-to-end at 0x04AACD..0x04AB6E */

/* --- Sons of Liberty per colony --- */
/* SoL_pct = 100 * rebel_dividend / max(rebel_divisor, 1)                           VERIFIED */
/* (ColonyRecord +0xC2 / +0xC6) */

/* --- Capital raze bonus (Inca/Aztec only?) --- */
/* UNKNOWN — observed 15,000 (Inca pop=13) and 10,000 (Aztec pop=10), both
 * far above pure-CHIEFKILL ceiling. Code path NOT in chief_greet_or_kill.
 * Suspected handler: @LOSTCITY2 / Cibola secondary treasure dispatch */

/* --- Founding Father acquisition --- */
/* UNKNOWN cost-progression formula. Brewster cost 129 at Discoverer + early-game.
 * pavelbel: NATION.next_founding_father (s16) holds index of FF currently pursued. */

/* --- Recruit cost --- RESOLVED 2026-05-31 (RESIDUAL_FINDINGS §21) */
/* recruit_cost is NOT a stored PowerRecord field (+0x30 has ZERO accesses — §14).
 * The recruit GOLD cost is the recruit-pool slot's +0x04 word, at
 *   DGROUP:0x978C + slot_idx*6 + 4   (written by func_074688; read 0x051E52, 0x035114).
 * Escalation is ARTILLERY-ONLY and LINEAR (not base<<count):
 *   if (colonist_type == 0x0B /Artillery/)  cost += g_active_power->artillery_bought_count * 100;
 *                                            g_active_power->artillery_bought_count++;
 *   @asm 0x035272 cmp ax,0xb ; 0x03527B imul [bx+0x1e],0x64 ; 0x03527F add ; 0x035282 inc [bx+0x1e]
 * Non-artillery recruits cost the slot's stored base verbatim. The per-type BASE
 * value is inserted by the resident pool generator (func_074688's caller, in the
 * un-dumped RTLink-resident segment) — that single numeric is the only TBD here. */

/* --- Combat --- */
/* attacker_strength × terrain_modifier × leader_bonus
 *   vs defender_strength × terrain_defense × fortification                         SUSPECTED */
/* Exact formula constants NOT byte-traced */

/* --- Production yield --- */
/* yield = base_per_terrain (NAMES.TXT @TERRAIN) × resource_bonus (@RESOURCE)
 *       × skill_multiplier × building_multiplier (@BUILDING)                       PARTIAL */
/* Master skill = 3× base; Indentured = 0.5×; Convert = 0.5×; PettyCriminal = 0.25× */

/* --- Map gen --- */
/* UNKNOWN — procedural-gen algorithm not traced */

/* --- Pathing / movement-cost --- */
/* UNKNOWN — per-tile move costs in NAMES.TXT @TERRAIN (col 8?) but lookup not traced */


/* ============================================================================
 * 10. EXPLICIT GAPS — DO NOT MAKE UP NAMES FOR THESE
 *
 * Apply UNKNOWN labels to corresponding Ghidra symbols until evidence
 * is added.
 * ============================================================================ */

/* (10a) ~1,143 of 1,241 functions: NO semantic name. Show as func_NNNNNN_unknown */
/* (10b) ~1,213 of 1,243 disasm files: NO hand-trace. Auto-tagged opcodes only */
/* (10c) PowerRecord +0x5C..+0x13F (228 bytes): score components, immigration queue */
/* (10d) ColonyRecord +0x24..+0x3F, +0x78..+0x99: pavelbel labels not byte-confirmed */
/* (10e) UnitRecord +0x10..+0x1B: pavelbel labels, runtime confirmation thin */
/* (10f) TribeData +0x00..+0x4D (76 of 78 bytes): only +0x02 byte read in CHIEFKILL */
/* (10g) AIPersonality semantics: stride only, fields entirely UNKNOWN */
/* (10h) CYCLE.DAT 34-byte payload semantics: loader cited, payload UNKNOWN */
/* (10i) Capital-bonus / Cibola handler: code path location UNKNOWN */
/* (10j) Audio drivers internals: ASOUND.COL OPL2 register sequences,
 *       sample-bank index, music format — all live INSIDE the MZ driver overlays */
/* (10k) Difficulty byte true location: 0x53A6 read in some paths but pavelbel says
 *       HEAD section; resolve in Ghidra by tracing menu-screen difficulty-pick handler */


/* ============================================================================
 * 11. SUGGESTED GHIDRA WORKFLOW
 *
 * 1. Apply structures: import the typedefs above as Ghidra structs.
 *    Use Ghidra's "Apply Data Type" on the table base addresses.
 * 2. Apply function signatures from §6 to those file offsets.
 * 3. For each LCALL 0x181F:NNN, follow the FAR JMP at the thunk to its
 *    target paragraph and apply the §7 names there.
 * 4. The 28 BYTE_VERIFIED .asm files in code/VICEROY/disasm/ have hand
 *    notes — use them as ground truth for those regions.
 * 5. When Ghidra's decompiler shows a struct field at +0xNN, cross-ref
 *    against the struct definitions in §4 BEFORE renaming.
 * 6. When you encounter a function not listed in §6, leave it as
 *    func_NNNNNN_unknown until you've traced its purpose. Do not name
 *    by assumption.
 * 7. Strings live in segments past the code; use Ghidra's "Search →
 *    For Strings" then cross-ref. Strings like "CHIEFKILL", "CYCLE.DAT",
 *    "GAME.TXT" anchor the corresponding handlers.
 * ============================================================================ */

#endif /* VICEROY_GHIDRA_REFERENCE_H */
