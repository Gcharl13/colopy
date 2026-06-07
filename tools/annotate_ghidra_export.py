"""
annotate_ghidra_export.py — V2 aggressive substitution.

Replaces every hex literal in VICEROY2.EXE.c that we've identified with
its known semantic name, and annotates every struct-field-offset access
with a comment naming the field.

V2 changes from V1:
  - Replaces hex literals GLOBALLY (not just in cast contexts).
    `0x53a6` becomes `G_DIFFICULTY` everywhere it appears as a standalone
    constant.
  - Expanded struct-field offset table — covers every UnitRecord,
    ColonyRecord, NativeSettlement, TribeData, AIPersonality, PowerRecord
    field we've documented.
  - Annotates known unit-type IDs, terrain IDs, building IDs, and
    common bit-mask constants when used near struct accesses.

Output: VICEROY2_annotated.c

Usage:
    python annotate_ghidra_export.py
"""
from __future__ import annotations

import re
from pathlib import Path

ROOT = Path(str(__import__("pathlib").Path(__file__).resolve().parents[1]))
INPUT = ROOT / 'VICEROY2.EXE.c'
OUTPUT = ROOT / 'VICEROY2_annotated.c'


# ---------------------------------------------------------------------------
# REFERENCE HEADER (inserted at top of file)
# ---------------------------------------------------------------------------
HEADER = r"""
/* ============================================================================
 * COLONIZATION (1994 DOS) REVERSE-ENGINEERING REFERENCE HEADER (V2)
 * Auto-inserted by tools/annotate_ghidra_export.py
 *
 * Every claim here is byte-cited against VICEROY.EXE.
 * VERIFIED  — byte-traced from runtime memory or disasm
 * PARTIAL   — pavelbel-derived or inferred from access pattern
 * ============================================================================ */

/* ---------- DGROUP TABLE BASE ADDRESSES ---------- */
#define UNIT_TABLE_BASE              0x3146  /* UnitRecord[256], stride 0x1C */
#define COLONY_TABLE_BASE            0x5D46  /* ColonyRecord[N],  stride 0xCA */
#define NATIVE_SETTLEMENT_BASE       0x54EC  /* NativeSettlement[N], stride 0x12 */
#define TRIBE_DATA_BASE              0x5AD6  /* TribeData[8],    stride 0x4E */
#define AI_PERSONALITY_BASE          0x540E  /* AIPersonality[4], stride 0x34 */
#define POWER_RECORD_BASE            0x8808  /* PowerRecord[12], stride 0x13C */

/* ---------- STRIDE CONSTANTS ---------- */
#define UNIT_STRIDE                  0x1C   /*  28 */
#define COLONY_STRIDE                0xCA   /* 202 */
#define SETTLEMENT_STRIDE            0x12   /*  18 */
#define TRIBE_STRIDE                 0x4E   /*  78 */
#define AI_PERSONALITY_STRIDE        0x34   /*  52 */
#define POWER_STRIDE                 0x13C  /* 316 */

/* ---------- DGROUP SCALAR GLOBALS ---------- */
#define G_DIFFICULTY            0x53A6  /* u8   0=Disc 1=Expl 2=Conq 3=Gov 4=Vic */
#define G_KING_ANGER            0x53A7  /* u8   ++ per Tea Party */
#define G_TURN_COUNTER          0x539E  /* u16  monotonic turn (1492 = year 0) */
#define G_REVOLUTION_FLAGS      0x5382  /* u8   bit 0 = revolution declared */
#define G_REF_STRENGTH          0x53DA  /* u16[4]  REF unit counts */
#define G_REF_REG_COUNT         0x53DA  /* u16  Regulars (Foot) */
#define G_REF_CAV_COUNT         0x53DC  /* u16  Cavalry (Dragoons) */
#define G_REF_ART_COUNT         0x53DE  /* u16  Artillery */
#define G_REF_MOW_COUNT         0x53E0  /* u16  Man-O-War (Ships) */
#define G_SCREEN_CLIP_RECT      0x839E  /* i16[4]  popup geometry clip */
#define G_MAP_WIDTH             0x853A  /* u16  = 58 in test scenarios */
#define G_MAP_HEIGHT            0x853C  /* u16  = 72 */
#define G_ACTIVE_COLONY         0x8542  /* far*  → ColonyRecord (178 refs!) */
#define G_KING_OR_PAYER         0x84FC  /* far*  PARTIAL */
#define G_ACTIVE_UNIT           0x8D4A  /* far*  → UnitRecord */
#define G_ACTIVE_SETTLEMENT     0x8D4E  /* far*  → NativeSettlement (CHIEFKILL) */
#define G_ACTIVE_POWER          0x8D52  /* far*  → PowerRecord */
#define G_TREASURE_BASE_SCRATCH 0x8DC4  /* i16  Lost-City formula scratch */
#define G_CYCLE_DAT_BUFFER      0x929E  /* u8[34]  CYCLE.DAT raw contents */
#define G_CYCLE_STATE_FLAG      0x92C0  /* u16  3 if running_sum > 16 else 0 */
#define G_CYCLE_RUNNING_SUM     0x92C2  /* u16  sum of cycle entry start_idx */
#define G_POPUP_GOLD_AMOUNT     0x9CB0  /* u32  capital-raze popup buffer */
#define G_POPUP_COUNT           0x9CB8  /* u32  popup arg slot 3 */
#define G_POPUP_TRIBE_COLOR     0x9CBC  /* u32  tribe map-marker palette idx */
#define G_POPUP_TRIBE_NAME      0x9CD2  /* char[16]  popup tribe name string */
#define G_FORMAT_BUFFER         0x2D54  /* u8[]  format scratch buffer */

/* ---------- POWER INDICES (NAMES.TXT @TRIBES order) ---------- */
#define POWER_ENGLAND     0
#define POWER_FRANCE      1
#define POWER_SPAIN       2
#define POWER_NETHERLANDS 3
#define POWER_FIRST_TRIBE 4
#define POWER_INCA        4   /* civ_tier 3 */
#define POWER_AZTEC       5   /* civ_tier 2 */
#define POWER_ARAWAK      6   /* civ_tier 1 */
#define POWER_IROQUOIS    7   /* civ_tier 1 */
#define POWER_CHEROKEE    8   /* civ_tier 1 */
#define POWER_APACHE      9   /* civ_tier 0 */
#define POWER_SIOUX       10  /* civ_tier 0 */
#define POWER_TUPI        11  /* civ_tier 0 */

/* ---------- STRUCT TYPE DEFINITIONS ---------- */
typedef unsigned char  u8;
typedef signed   char  i8;
typedef unsigned short u16_t;
typedef signed   short i16_t;
typedef unsigned int   u32_t;
typedef signed   int   i32_t;

/* PowerRecord — 316 B (0x13C). Base: DGROUP:POWER_RECORD_BASE. */
struct PowerRecord {
    u8     control_type;             /* +0x00  PARTIAL */
    u8     tax_rate;                 /* +0x01  VERIFIED */
    u8     rebel_sentiment_pct;      /* +0x02  VERIFIED */
    u8     unknown_03[4];
    u32_t  founding_fathers_mask;    /* +0x07  VERIFIED — bits 0..24 */
    u8     unknown_0B;
    u16_t  bells_toward_next_ff;     /* +0x0C  VERIFIED */
    u16_t  bells_per_turn;           /* +0x0E  VERIFIED */
    u16_t  crosses_per_turn;         /* +0x10  VERIFIED */
    u8     unknown_12[2];
    u8     founding_father_count;    /* +0x14  VERIFIED */
    u8     unknown_15[11];
    u16_t  boycott_bitfield;         /* +0x20  VERIFIED */
    i32_t  royal_money;              /* +0x22  VERIFIED — drives REF growth */
    u8     unknown_26[4];
    u32_t  gold;                     /* +0x2A  VERIFIED — treasury */
    u32_t  lifetime_treasure;        /* +0x2E..+0x31  PARTIAL */
    u8     home_x;                   /* +0x32  VERIFIED */
    u8     home_y;                   /* +0x33  VERIFIED */
    u8     unknown_34[16];
    u8     ref_foot_count;           /* +0x44  PARTIAL */
    u8     ref_dragoon_count;        /* +0x45  PARTIAL */
    u8     ref_man_o_war_count;     /* +0x46  PARTIAL */
    u8     unknown_47[5];
    u8     market_saturation[16];   /* +0x4C..+0x5B  PARTIAL */
    u8     unknown_5C[228];
};

/* ColonyRecord — 202 B (0xCA). Base: DGROUP:COLONY_TABLE_BASE. */
struct ColonyRecord {
    u8     map_x;                    /* +0x00  VERIFIED */
    u8     map_y;                    /* +0x01  VERIFIED */
    char   name[24];                 /* +0x02..+0x19  VERIFIED */
    u8     owner_idx;                /* +0x1A  VERIFIED */
    u8     unknown_1B;
    u8     colony_flags;             /* +0x1C  PARTIAL */
    u8     unknown_1D[2];
    u8     size;                     /* +0x1F  VERIFIED — colonist count */
    u8     population_on_map;        /* +0x20  SUSPECTED */
    u8     unknown_21;
    u16_t  state_packed;             /* +0x22  VERIFIED — SoL/Tory display */
    u8     unknown_24[28];
    u8     colonist_jobs[32];        /* +0x40..+0x5F  VERIFIED */
    u8     buildings_bitmask[16];    /* +0x60..+0x6F  VERIFIED */
    u8     tile_workers[8];          /* +0x70..+0x77  VERIFIED */
    u8     unknown_78[34];
    u16_t  stockpile[16];            /* +0x9A..+0xB9  VERIFIED */
    u16_t  hammers;                  /* +0xBA  VERIFIED */
    u8     building_in_production;   /* +0xBC  VERIFIED */
    u8     warehouse_level;          /* +0xBD  PARTIAL */
    u8     unknown_BE[4];
    i32_t  rebel_dividend;           /* +0xC2  VERIFIED — SoL numerator */
    i32_t  rebel_divisor;            /* +0xC6  VERIFIED — SoL denominator */
};

/* UnitRecord — 28 B (0x1C). Base: DGROUP:UNIT_TABLE_BASE. 256 slots. */
struct UnitRecord {
    u8     unit_type;                /* +0x00  VERIFIED — NAMES.TXT @UNIT idx */
    u8     nation_info;              /* +0x01  VERIFIED — low4 power, high4 vis */
    u8     damaged;                  /* +0x02  PARTIAL */
    u8     moves_used;               /* +0x03  PARTIAL */
    u8     origin_settlement;        /* +0x04  PARTIAL */
    u8     ai_plan_mode;             /* +0x05  PARTIAL */
    u8     orders;                   /* +0x06  VERIFIED */
    u8     map_x;                    /* +0x07  VERIFIED */
    u8     map_y;                    /* +0x08  VERIFIED */
    u8     goto_x;                   /* +0x09  PARTIAL */
    u8     goto_y;                   /* +0x0A  PARTIAL */
    u8     unknown_0B;
    u8     holds_occupied;           /* +0x0C  PARTIAL */
    u8     cargo_items[3];           /* +0x0D..+0x0F  PARTIAL */
    u8     cargo_qty[6];             /* +0x10..+0x15  PARTIAL */
    u8     turns_worked;             /* +0x16  PARTIAL */
    u8     profession_or_treasure;   /* +0x17  VERIFIED — × 100 = Treasure */
    i16_t  transport_next;           /* +0x18  PARTIAL */
    i16_t  transport_prev;           /* +0x1A  PARTIAL */
};

/* NativeSettlement — 18 B (0x12). Base: DGROUP:NATIVE_SETTLEMENT_BASE. */
struct NativeSettlement {
    u8     map_x;
    u8     map_y;
    u8     owner_tribe_idx;
    u8     blcs_flags;               /* bit0 brave_missing, bit1 learned,
                                        bit2 capital, bit3 scouted */
    u8     population;
    u8     mission;                  /* bit 0x10 active, low4 owner */
    i8     growth_counter;
    u8     sentinel_FF;              /* always 0xFF */
    u8     last_bought;
    u8     last_sold;
    u8     alarm[8];                 /* 4 × {friction, attacks_queued} */
};

/* TribeData — 78 B (0x4E). Base: DGROUP:TRIBE_DATA_BASE. */
struct TribeData {
    u8     always_one_a;             /* +0x00  = 0x01 */
    u8     always_one_b;             /* +0x01  = 0x01 */
    u8     civ_tier;                 /* +0x02  VERIFIED — 0..3 */
    u8     unknown_03_4D[75];
};

/* AIPersonality — 52 B (0x34). Base: DGROUP:AI_PERSONALITY_BASE. */
struct AIPersonality {
    u8     unknown_00[0x31];
    u8     is_ai_controlled;         /* +0x31  VERIFIED — 0=human, !=0=AI */
    u8     secondary_ai_flag;        /* +0x32  PARTIAL */
    u8     unknown_33;
};

/* CYCLE.DAT entry layout */
struct CycleEntry { u8 start_idx, phase, end_idx, period; };

/* ---------- KEY OVERLAY THUNKS (LCALL targets) ---------- */
/* LCALL 0x181F:0x04D4  random_int(lo, hi)         — appears EVERYWHERE */
/* LCALL 0x181F:0x09AE  push_popup_arg / modify_gold (overloaded; 106 sites) */
/* LCALL 0x181F:0x0438  push_to_popup_buffer */
/* LCALL 0x181F:0x09A4  get_unit_record_or_xref */
/* LCALL 0x181F:0x09E6  fetch_settlement_record(idx) */
/* LCALL 0x181F:0x0E86  open_file(filename, mode)  — Borland fopen */
/* LCALL 0x181F:0x0CE0  tile_clip_check(x, y) */
/* LCALL 0x181F:0x07B4  ascii_arg_check */
/* LCALL 0x181F:0x0302  visibility_test(x, y) */
/* LCALL 0x181F:0x078C  read_map_terrain(x, y) */
/* LCALL 0x191F:0x019C  show_msg_template(power, key) — GAME.TXT @-section */
/* LCALL 0x191F:0x0ED0  blit_sprite_block */
/* LCALL 0x0D1D:0x0528  fread (Borland C runtime) */
/* LCALL 0x0D1D:0x03F4  fclose */
/* LCALL 0x0D1D:0x0DAB  RTLink overlay loader */

/* ---------- KNOWN FUNCTION FILE OFFSETS ----------
 * file 0x00C322  random_int(lo, hi)        — uniform [lo..hi] inclusive
 * file 0x0103D4  rand()                    — MSC 6.0 LCG
 * file 0x0081C6  set_active_tribe          — sets G_ACTIVE_SETTLEMENT
 * file 0x067DC8  compute_dialog_rect       — popup geometry
 * file 0x034AE0  king_attempt_tax_change   — tax delta = ((diff & 0xFE)*2 + 4)
 *                                                        * (turn / 400 + 1)
 * file 0x04A7CA  chief_greet_or_kill       — CHIEFKILL handler;
 *                                            gold = sum_3 × roll_4 × 4 × (civ_tier+1)
 * file 0x05C878  treasure_train_cash_in    — gross = unit.profession × 100;
 *                                            tax=cut; royal_money += tax;
 *                                            gold += (gross-tax)
 * file 0x049600  lost_city_or_cibola_handler  — Lost-City formula (~3450 B)
 * file 0x00C4DB  color_cycle_tick (orphan)
 * file 0x00C5E7  color_cycle_palette_write
 * file 0x0783E4  load_cycle_dat            — reads 34 B into G_CYCLE_DAT_BUFFER
 * file 0x0749E0  load_names_txt_sections
 * file 0x06F0F4  dialog_framework
 * file 0x06EEEC  parse_text_template       — %STRING/%NUMBER/%YEAR/%COUNTRY
 * file 0x07431E  render_popup              — reads G_SCREEN_CLIP_RECT
 * file 0x02D658  colony_screen_dispatch
 * file 0x00A3E1  colony_turn_update
 * file 0x0305A8  market_price_drift
 * file 0x03A9C0  compute_score
 * file 0x02F3A2  check_win_or_lose
 * file 0x04E2D6  ai_action_dispatcher      — 584 B, 11 sub-actions
 * ============================================================================
 */

"""


# ---------------------------------------------------------------------------
# DGROUP scalar address → name map (used for global substitution)
# ---------------------------------------------------------------------------
# Hex addresses are looked up case-insensitively; `\b0x53a6\b` matches.
DGROUP_GLOBALS = {
    '0x53a6': 'G_DIFFICULTY',
    '0x53a7': 'G_KING_ANGER',
    '0x539e': 'G_TURN_COUNTER',
    '0x5382': 'G_REVOLUTION_FLAGS',
    '0x53da': 'G_REF_REG_COUNT',
    '0x53dc': 'G_REF_CAV_COUNT',
    '0x53de': 'G_REF_ART_COUNT',
    '0x53e0': 'G_REF_MOW_COUNT',
    '0x839e': 'G_SCREEN_CLIP_RECT',
    '0x853a': 'G_MAP_WIDTH',
    '0x853c': 'G_MAP_HEIGHT',
    '0x8542': 'G_ACTIVE_COLONY',
    '0x84fc': 'G_KING_OR_PAYER',
    '0x8d4a': 'G_ACTIVE_UNIT',
    '0x8d4e': 'G_ACTIVE_SETTLEMENT',
    '0x8d52': 'G_ACTIVE_POWER',
    '0x8dc4': 'G_TREASURE_BASE_SCRATCH',
    '0x929e': 'G_CYCLE_DAT_BUFFER',
    '0x92c0': 'G_CYCLE_STATE_FLAG',
    '0x92c2': 'G_CYCLE_RUNNING_SUM',
    '0x9cb0': 'G_POPUP_GOLD_AMOUNT',
    '0x9cb8': 'G_POPUP_COUNT',
    '0x9cbc': 'G_POPUP_TRIBE_COLOR',
    '0x9cd2': 'G_POPUP_TRIBE_NAME',
    '0x2d54': 'G_FORMAT_BUFFER',
}


# ---------------------------------------------------------------------------
# Stride constants — replace the bare hex stride values in struct math
# ---------------------------------------------------------------------------
STRIDE_REPLACEMENTS = {
    '0x1c':  'UNIT_STRIDE',         # 28
    '0xca':  'COLONY_STRIDE',       # 202
    '0x12':  'SETTLEMENT_STRIDE',   # 18 — but very common; need context match
    '0x4e':  'TRIBE_STRIDE',        # 78
    '0x34':  'AI_PERSONALITY_STRIDE', # 52 — also common
    '0x13c': 'POWER_STRIDE',        # 316
}


# ---------------------------------------------------------------------------
# Struct-field offset annotations (every documented field)
# ---------------------------------------------------------------------------
STRUCT_FIELD_ANNOTATIONS = [
    # UnitRecord (base 0x3146, stride 0x1C)
    (r'\* 0x1c \+ 0x3146\b', '/* UnitRecord+0x00 unit_type */'),
    (r'\* 0x1c \+ 0x3147\b', '/* UnitRecord+0x01 nation_info */'),
    (r'\* 0x1c \+ 0x3148\b', '/* UnitRecord+0x02 damaged_or_unknown */'),
    (r'\* 0x1c \+ 0x3149\b', '/* UnitRecord+0x03 moves_used */'),
    (r'\* 0x1c \+ 0x314a\b', '/* UnitRecord+0x04 origin_settlement */'),
    (r'\* 0x1c \+ 0x314b\b', '/* UnitRecord+0x05 ai_plan_mode */'),
    (r'\* 0x1c \+ 0x314c\b', '/* UnitRecord+0x06 orders */'),
    (r'\* 0x1c \+ 0x314d\b', '/* UnitRecord+0x07 map_x */'),
    (r'\* 0x1c \+ 0x314e\b', '/* UnitRecord+0x08 map_y */'),
    (r'\* 0x1c \+ 0x314f\b', '/* UnitRecord+0x09 goto_x */'),
    (r'\* 0x1c \+ 0x3150\b', '/* UnitRecord+0x0A goto_y */'),
    (r'\* 0x1c \+ 0x3151\b', '/* UnitRecord+0x0B unknown */'),
    (r'\* 0x1c \+ 0x3152\b', '/* UnitRecord+0x0C holds_occupied */'),
    (r'\* 0x1c \+ 0x3153\b', '/* UnitRecord+0x0D cargo_items[0] */'),
    (r'\* 0x1c \+ 0x3154\b', '/* UnitRecord+0x0E cargo_items[1] */'),
    (r'\* 0x1c \+ 0x3155\b', '/* UnitRecord+0x0F cargo_items[2] */'),
    (r'\* 0x1c \+ 0x3156\b', '/* UnitRecord+0x10 cargo_qty[0] */'),
    (r'\* 0x1c \+ 0x3157\b', '/* UnitRecord+0x11 cargo_qty[1] */'),
    (r'\* 0x1c \+ 0x3158\b', '/* UnitRecord+0x12 cargo_qty[2] */'),
    (r'\* 0x1c \+ 0x3159\b', '/* UnitRecord+0x13 cargo_qty[3] */'),
    (r'\* 0x1c \+ 0x315a\b', '/* UnitRecord+0x14 cargo_qty[4]/turns_worked */'),
    (r'\* 0x1c \+ 0x315b\b', '/* UnitRecord+0x15 profession_or_treasure */'),
    (r'\* 0x1c \+ 0x315c\b', '/* UnitRecord+0x16 transport_next (low) */'),
    (r'\* 0x1c \+ 0x315d\b', '/* UnitRecord+0x17 transport_next (high) */'),
    (r'\* 0x1c \+ 0x315e\b', '/* UnitRecord+0x18 transport_prev (low) */'),
    (r'\* 0x1c \+ 0x315f\b', '/* UnitRecord+0x19 transport_prev (high) */'),
    # Pre-table accesses (some functions read 1-2 bytes before the array starts)
    (r'\* 0x1c \+ 0x3144\b', '/* unit_idx*28 + (UNIT_TABLE-2) */'),
    (r'\* 0x1c \+ 0x3145\b', '/* unit_idx*28 + (UNIT_TABLE-1) */'),

    # ColonyRecord (base 0x5D46, stride 0xCA)
    (r'\* 0xca \+ 0x5d46\b', '/* ColonyRecord+0x00 map_x */'),
    (r'\* 0xca \+ 0x5d47\b', '/* ColonyRecord+0x01 map_y */'),
    (r'\* 0xca \+ 0x5d48\b', '/* ColonyRecord+0x02 name[0] */'),
    (r'\* 0xca \+ 0x5d60\b', '/* ColonyRecord+0x1A owner_idx */'),
    (r'\* 0xca \+ 0x5d61\b', '/* ColonyRecord+0x1B unknown */'),
    (r'\* 0xca \+ 0x5d62\b', '/* ColonyRecord+0x1C colony_flags */'),
    (r'\* 0xca \+ 0x5d65\b', '/* ColonyRecord+0x1F size (colonist count) */'),
    (r'\* 0xca \+ 0x5d66\b', '/* ColonyRecord+0x20 population_on_map */'),
    (r'\* 0xca \+ 0x5d68\b', '/* ColonyRecord+0x22 state_packed */'),
    (r'\* 0xca \+ 0x5d86\b', '/* ColonyRecord+0x40 colonist_jobs[0] */'),
    (r'\* 0xca \+ 0x5da6\b', '/* ColonyRecord+0x60 buildings_bitmask[0] */'),
    (r'\* 0xca \+ 0x5db6\b', '/* ColonyRecord+0x70 tile_workers[0] (NW) */'),
    (r'\* 0xca \+ 0x5dca\b', '/* ColonyRecord+0x84 unknown region */'),
    (r'\* 0xca \+ 0x5de0\b', '/* ColonyRecord+0x9A stockpile[0] (Food) */'),
    (r'\* 0xca \+ 0x5e00\b', '/* ColonyRecord+0xBA hammers */'),
    (r'\* 0xca \+ 0x5e02\b', '/* ColonyRecord+0xBC building_in_production */'),
    (r'\* 0xca \+ 0x5e08\b', '/* ColonyRecord+0xC2 rebel_dividend */'),
    (r'\* 0xca \+ 0x5e0c\b', '/* ColonyRecord+0xC6 rebel_divisor */'),

    # NativeSettlement (base 0x54EC, stride 0x12)
    (r'\* 0x12 \+ 0x54ec\b', '/* NativeSettlement+0x00 map_x */'),
    (r'\* 0x12 \+ 0x54ed\b', '/* NativeSettlement+0x01 map_y */'),
    (r'\* 0x12 \+ 0x54ee\b', '/* NativeSettlement+0x02 owner_tribe_idx */'),
    (r'\* 0x12 \+ 0x54ef\b', '/* NativeSettlement+0x03 BLCS flags (bit 2 = capital) */'),
    (r'\* 0x12 \+ 0x54f0\b', '/* NativeSettlement+0x04 population */'),
    (r'\* 0x12 \+ 0x54f1\b', '/* NativeSettlement+0x05 mission */'),
    (r'\* 0x12 \+ 0x54f2\b', '/* NativeSettlement+0x06 growth_counter */'),
    (r'\* 0x12 \+ 0x54f6\b', '/* NativeSettlement+0x0A alarm[0].friction */'),

    # TribeData (base 0x5AD6, stride 0x4E)
    (r'\* 0x4e \+ 0x5ad6\b', '/* TribeData+0x00 always_one_a */'),
    (r'\* 0x4e \+ 0x5ad7\b', '/* TribeData+0x01 always_one_b */'),
    (r'\* 0x4e \+ 0x5ad8\b', '/* TribeData+0x02 civ_tier */'),
    (r'\* 0x4e \+ 0x5ae2\b', '/* TribeData+0x0C per-tribe (Inca=0x87, Aztec=0x22) */'),

    # AIPersonality (base 0x540E, stride 0x34)
    (r'\* 0x34 \+ 0x540e\b', '/* AIPersonality+0x00 (begin) */'),
    (r'\* 0x34 \+ 0x5426\b', '/* AIPersonality+0x18 */'),
    (r'\* 0x34 \+ 0x543f\b', '/* AIPersonality+0x31 is_ai_controlled */'),
    (r'\* 0x34 \+ 0x5440\b', '/* AIPersonality+0x32 secondary_ai_flag */'),

    # PowerRecord (base 0x8808, stride 0x13C)
    (r'\* 0x13c \+ 0x8808\b', '/* PowerRecord+0x00 control_type */'),
    (r'\* 0x13c \+ 0x8809\b', '/* PowerRecord+0x01 tax_rate */'),
    (r'\* 0x13c \+ 0x880a\b', '/* PowerRecord+0x02 rebel_sentiment_pct */'),
    (r'\* 0x13c \+ 0x880f\b', '/* PowerRecord+0x07 founding_fathers_mask */'),
    (r'\* 0x13c \+ 0x8814\b', '/* PowerRecord+0x0C bells_toward_next_ff */'),
    (r'\* 0x13c \+ 0x8816\b', '/* PowerRecord+0x0E bells_per_turn */'),
    (r'\* 0x13c \+ 0x8818\b', '/* PowerRecord+0x10 crosses_per_turn */'),
    (r'\* 0x13c \+ 0x881c\b', '/* PowerRecord+0x14 founding_father_count */'),
    (r'\* 0x13c \+ 0x8828\b', '/* PowerRecord+0x20 boycott_bitfield */'),
    (r'\* 0x13c \+ 0x882a\b', '/* PowerRecord+0x22 royal_money */'),
    (r'\* 0x13c \+ 0x8832\b', '/* PowerRecord+0x2A gold (low word) */'),
    (r'\* 0x13c \+ 0x8834\b', '/* PowerRecord+0x2C gold (high word) */'),
    (r'\* 0x13c \+ 0x8836\b', '/* PowerRecord+0x2E lifetime_treasure (low) */'),
    (r'\* 0x13c \+ 0x8838\b', '/* PowerRecord+0x30 lifetime_treasure (high) */'),
    (r'\* 0x13c \+ 0x883a\b', '/* PowerRecord+0x32 home_x */'),
    (r'\* 0x13c \+ 0x883b\b', '/* PowerRecord+0x33 home_y */'),
    (r'\* 0x13c \+ 0x884c\b', '/* PowerRecord+0x44 ref_foot_count */'),
    (r'\* 0x13c \+ 0x884d\b', '/* PowerRecord+0x45 ref_dragoon_count */'),
    (r'\* 0x13c \+ 0x884e\b', '/* PowerRecord+0x46 ref_man_o_war_count */'),
    (r'\* 0x13c \+ 0x8854\b', '/* PowerRecord+0x4C market_saturation[0] */'),

    # PowerRecord NEGATIVE-disp accesses (signed disp16 = unsigned 0x88NN)
    # -0x77NN signed (16-bit) = 0x88NN unsigned (= 0x10000 - 0x77NN)
    (r'\* 0x13c \+ -0x77c4\b', '/* PowerRecord+0x34 (= -0x77C4 signed) */'),
    (r'\* 0x13c \+ -0x77c6\b', '/* PowerRecord+0x32 home_x (= -0x77C6 signed) */'),
    (r'\* 0x13c \+ -0x77cc\b', '/* PowerRecord+0x2C gold (high) (= -0x77CC) */'),
    (r'\* 0x13c \+ -0x77ce\b', '/* PowerRecord+0x2A gold (low) (= -0x77CE) */'),
    (r'\* 0x13c \+ -0x77d0\b', '/* PowerRecord+0x28 (= -0x77D0) */'),
    (r'\* 0x13c \+ -0x77d2\b', '/* PowerRecord+0x26 (= -0x77D2) */'),
    (r'\* 0x13c \+ -0x77d4\b', '/* PowerRecord+0x24 (royal_money high) (= -0x77D4) */'),
    (r'\* 0x13c \+ -0x77d6\b', '/* PowerRecord+0x22 royal_money (low) (= -0x77D6) */'),
    (r'\* 0x13c \+ -0x77f1\b', '/* PowerRecord+0x07 founding_fathers_mask (= -0x77F1) */'),
    (r'\* 0x13c \+ -0x77f7\b', '/* PowerRecord+0x01 tax_rate (= -0x77F7) */'),
    (r'\* 0x13c \+ -0x77f8\b', '/* PowerRecord+0x00 control_type (= -0x77F8) */'),

    # NativeSettlement NEGATIVE-disp (base 0x54EC = -0xAB14 signed)
    (r'\* 0x12 \+ -0xab14\b', '/* NativeSettlement+0x00 map_x (= -0xAB14) */'),

    # ColonyRecord NEGATIVE-disp (base 0x5D46 = -0xA2BA signed)
    (r'\* 0xca \+ -0xa2ba\b', '/* ColonyRecord+0x00 map_x (= -0xA2BA) */'),

    # UnitRecord NEGATIVE-disp (base 0x3146 = -0xCEBA signed)
    (r'\* 0x1c \+ -0xceba\b', '/* UnitRecord+0x00 unit_type (= -0xCEBA) */'),
    (r'\* 0x1c \+ -0xceb8\b', '/* UnitRecord+0x02 damaged (= -0xCEB8) */'),
]

# Compile patterns once
COMPILED_FIELD_ANNOTATIONS = [(re.compile(p), c) for (p, c) in STRUCT_FIELD_ANNOTATIONS]


def annotate(input_path: Path, output_path: Path):
    text = input_path.read_text(encoding='utf-8', errors='replace')
    print(f'Input: {input_path.name} ({len(text):,} chars)')

    # 1. Add inline comments to struct-access patterns (before any substitution
    #    that would rename the bases)
    field_count = 0
    for pat, comment in COMPILED_FIELD_ANNOTATIONS:
        new_text, n = pat.subn(lambda m: m.group(0) + ' ' + comment, text)
        if n > 0:
            field_count += n
            text = new_text
    print(f'  Added {field_count} struct-field annotations')

    # 2. Annotate every reference to a known DGROUP global (cast or bare).
    scalar_count = 0
    for hex_addr, name in DGROUP_GLOBALS.items():
        # Match the hex literal as a whole word, regardless of context
        pat = re.compile(r'\b' + re.escape(hex_addr) + r'\b(?!\s*\*\s*0x)')
        def replace(m):
            return m.group(0) + f'/*{name}*/'
        new_text, n = pat.subn(replace, text)
        if n > 0:
            scalar_count += n
            text = new_text
    print(f'  Added {scalar_count} DGROUP-scalar annotations')

    # 3. Annotate stride constants when used in struct math (e.g., * 0x13c)
    # These help the user spot which struct is being indexed even when the
    # base address isn't in our table.
    stride_count = 0
    stride_annotations = {
        r'\* 0x13c\b':   '/* POWER_STRIDE 316 */',
        r'\* 0xca\b':    '/* COLONY_STRIDE 202 */',
        r'\* 0x4e\b':    '/* TRIBE_STRIDE 78 */',
    }
    # Only annotate the FIRST occurrence per line to avoid noise — done by
    # only annotating where pattern is followed by ` + 0x` (struct access)
    for pat_str, comment in stride_annotations.items():
        # Match `* STRIDE` followed by ` + 0x` or ` + -0x` (struct base offset)
        # We don't add if the line already has any /* comment near it.
        full_pat = re.compile(pat_str + r'(?= \+ -?0x)')
        new_text, n = full_pat.subn(lambda m: m.group(0) + ' ' + comment, text)
        if n > 0:
            stride_count += n
            text = new_text
    print(f'  Added {stride_count} stride annotations')

    # 3. Insert reference header
    lines = text.split('\n')
    insert_at = 0
    for i, line in enumerate(lines):
        if 'OLD_IMAGE_DOS_RELOC' in line and '};' in line:
            insert_at = i + 1
            break
        if i > 80:
            break
    if insert_at == 0:
        text = HEADER + text
    else:
        text = '\n'.join(lines[:insert_at]) + '\n' + HEADER + '\n'.join(lines[insert_at:])

    output_path.write_text(text, encoding='utf-8')
    print(f'Output: {output_path.name} ({len(text):,} chars)')


if __name__ == '__main__':
    annotate(INPUT, OUTPUT)
