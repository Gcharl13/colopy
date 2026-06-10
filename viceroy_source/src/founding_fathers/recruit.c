/* ============================================================================
 *           >>> PARTIALLY BYTE-VERIFIED (data) / MOSTLY left unresolved (flow) <<<
 * ----------------------------------------------------------------------------
 * BYTE-VERIFIED here:
 *   - The 25-entry Founding-Father table (id, category, three AI weights) is
 *     read verbatim from COLONIZE/NAMES.TXT @FATHERS (the canonical data source;
 *     the game itself parses this at startup, @ref MEMORY.md names_txt_authoritative).
 *   - The 6 category names and the in-category prerequisite RULE are read from
 *     NAMES.TXT @FOUNDING.
 *
 * NOT verified (the prior reconstruction's invented numbers are removed):
 *   - The liberty-bell accumulation, the Continental-Congress trigger flow, and
 *     the per-FF bell-cost CURVE. These are documented in the technical
 *     reference but were NOT confirmed against bytes in this pass; they are
 *     marked left unresolved with disassembly anchors for follow-up.
 *   - The previous file's `ff_next_pool_required = 50*year_mult*(n+1)` formula,
 *     its 5-globally-sequential-ages model, and Jefferson "+50%" were fabricated
 *     and are NOT reproduced.
 *
 * Upgrade per viceroy_source/VERIFICATION_LEDGER.md.
 * ============================================================================ */

/* ============================================================================
 * recruit.c -- Continental Congress: Founding-Father data + recruitment flow
 * ----------------------------------------------------------------------------
 * @ref ../docs/FOUNDING_FATHERS.md
 * @ref ../../../COLONIZE/NAMES.TXT @FATHERS / @FOUNDING  (canonical data)
 * @asm effect dispatch on recruit: func_03BC42 @0x03BC42 (see effects.c)
 * ============================================================================ */
#include "viceroy_types.h"
#include "power.h"
#include "ff.h"

/* ----------------------------------------------------------------------------
 * VERIFIED Founding-Father categories (NAMES.TXT @FOUNDING @ file 0x2F03).
 * The @FATHERS "type" column (0..4) indexes these. Index 5 (Independence) is
 * the post-revolution pseudo-category, not a recruitable FF group.
 * ---------------------------------------------------------------------------- */
enum FfCategory {
    FFCAT_TRADE = 0,        /* @FOUNDING line 0 "Trade"        */
    FFCAT_EXPLORATION = 1,  /* @FOUNDING line 1 "Exploration"  */
    FFCAT_MILITARY = 2,     /* @FOUNDING line 2 "Military"     */
    FFCAT_POLITICAL = 3,    /* @FOUNDING line 3 "Political"    */
    FFCAT_RELIGIOUS = 4,    /* @FOUNDING line 4 "Religious"    */
    FFCAT_INDEPENDENCE = 5  /* @FOUNDING line 5 "Independence" (non-recruit) */
};

/* ----------------------------------------------------------------------------
 * VERIFIED Founding-Father table, transcribed byte-for-byte from
 * COLONIZE/NAMES.TXT @FATHERS. Columns: name, category(type), then the three
 * AI selection weights for eras 1500-1600 / 1600-1700 / 1700+.
 * Row index == the ff_id used by the effect dispatch (effects.c).
 * ---------------------------------------------------------------------------- */
struct FoundingFatherRecord {
    const char *name;
    uint8_t     category;    /* FfCategory */
    uint8_t     weight_1500; /* AI pick weight, era 1500-1600 */
    uint8_t     weight_1600; /* AI pick weight, era 1600-1700 */
    uint8_t     weight_1700; /* AI pick weight, era 1700+      */
};

/* @ref NAMES.TXT @FATHERS (exact values; "type, w1500, w1600, w1700") */
const struct FoundingFatherRecord FF_TABLE[25] = {
    /*  0 */ { "Adam Smith",              FFCAT_TRADE,        2,  8,  6 },
    /*  1 */ { "Jakob Fugger",            FFCAT_TRADE,        0,  5,  8 },
    /*  2 */ { "Peter Minuit",            FFCAT_TRADE,        9,  1,  0 },
    /*  3 */ { "Peter Stuyvesant",        FFCAT_TRADE,        2,  4,  8 },
    /*  4 */ { "Jan de Witt",             FFCAT_TRADE,        2,  6, 10 },
    /*  5 */ { "Ferdinand Magellan",      FFCAT_EXPLORATION,  2, 10, 10 },
    /*  6 */ { "Francisco Coronado",      FFCAT_EXPLORATION,  3,  5,  7 },
    /*  7 */ { "Hernando de Soto",        FFCAT_EXPLORATION,  5, 10,  5 },
    /*  8 */ { "Henry Hudson",            FFCAT_EXPLORATION, 10,  1,  0 },
    /*  9 */ { "Sieur De La Salle",       FFCAT_EXPLORATION,  7,  5,  3 },
    /* 10 */ { "Hernan Cortes",           FFCAT_MILITARY,     6,  5,  1 },
    /* 11 */ { "George Washington",       FFCAT_MILITARY,     0,  4, 10 },
    /* 12 */ { "Paul Revere",             FFCAT_MILITARY,    10,  2,  1 },
    /* 13 */ { "Francis Drake",           FFCAT_MILITARY,     4,  8,  6 },
    /* 14 */ { "John Paul Jones",         FFCAT_MILITARY,     0,  6,  7 },
    /* 15 */ { "Thomas Jefferson",        FFCAT_POLITICAL,    4,  5,  6 },
    /* 16 */ { "Pocahontas",              FFCAT_POLITICAL,    7,  5,  3 },
    /* 17 */ { "Thomas Paine",            FFCAT_POLITICAL,    1,  2,  8 },
    /* 18 */ { "Simon Bolivar",           FFCAT_POLITICAL,    0,  4,  6 },
    /* 19 */ { "Benjamin Franklin",       FFCAT_POLITICAL,    5,  5,  5 },
    /* 20 */ { "William Brewster",        FFCAT_RELIGIOUS,    7,  4,  1 },
    /* 21 */ { "William Penn",            FFCAT_RELIGIOUS,    8,  5,  2 },
    /* 22 */ { "Jean de Brebeuf",         FFCAT_RELIGIOUS,    6,  6,  1 },
    /* 23 */ { "Juan de Sepulveda",       FFCAT_RELIGIOUS,    3,  8,  3 },
    /* 24 */ { "Bartolome de las Casas",  FFCAT_RELIGIOUS,    0,  5, 10 },
};

/* g_year (DGROUP:0x538A) — current year, read directly by func_03B95A below. */
extern int16_t g_year;   /* @asm 03B963 cmp [0x538a],0x640 */

/* ----------------------------------------------------------------------------
 * ff_era_band -- func_03B95A @0x03B95A  (page 0x06, ENTER 2,0, RETF)
 * ----------------------------------------------------------------------------
 * BYTE-VERIFIED era band selector. No args; reads g_year (DGROUP:0x538A):
 *   band = 0; if (g_year >= 0x640) band = 1; if (g_year >= 0x6a4) band += 1;
 * i.e. band 0 for year < 1600, band 1 for 1600 <= year < 1700, band 2 for
 * year >= 1700 (0x640=1600, 0x6a4=1700). Confirms the `<` boundary the prior
 * pass left unresolved: 1600 and 1700 themselves fall into the HIGHER band. This is
 * the index added to FF_MEM_BASE+0x03 to pick the AI weight column.
 * @asm 03B963 `cmp [0x538a],0x640`; 03B970 `cmp [0x538a],0x6a4`.
 * @ref VERIFICATION_LEDGER.md 2026-05-30 (score_tick uses the same 0x6a4 edge).
 * Status: BYTE_VERIFIED.
 * ---------------------------------------------------------------------------- */
int ff_era_band(void)
{
    int band = 0;                       /* @asm 03B95E mov [bp-2],0 */
    if (g_year >= 0x640) band = 1;      /* @asm 03B963 cmp [0x538a],0x640 ; jl ; 03B96B mov [bp-2],1 */
    if (g_year >= 0x6a4) band += 1;     /* @asm 03B970 cmp [0x538a],0x6a4 ; jl ; 03B978 inc [bp-2] */
    return band;                        /* @asm 03B97B */
}

/* @ref @FATHERS cols 2/3/4 selected by the same band logic as func_03B95A.
 * (Convenience wrapper kept for callers that pass an explicit year; the band
 * edges are the verified 1600/1700 from ff_era_band.) */
int ff_weight_for_year(int ff_id, int year)
{
    int band;
    if (ff_id < 0 || ff_id >= 25) return 0;
    band = (year >= 1700) ? 2 : (year >= 1600) ? 1 : 0;    /* matches func_03B95A edges */
    switch (band) {
        case 0:  return FF_TABLE[ff_id].weight_1500;       /* year < 1600  (@FATHERS col 2) */
        case 1:  return FF_TABLE[ff_id].weight_1600;       /* 1600..1699   (@FATHERS col 3) */
        default: return FF_TABLE[ff_id].weight_1700;       /* year >= 1700 (@FATHERS col 4) */
    }
}

/* ----------------------------------------------------------------------------
 * VERIFIED in-CATEGORY prerequisite rule (NAMES.TXT @FOUNDING comment):
 *   "Father of higher level will not appear until at least one father of next
 *    lower level (of same type) has joined the Congress."
 * i.e. availability is gated WITHIN a category by row order, NOT by a single
 * global age ladder (correcting the prior reconstruction).
 *
 * `owned_test(ff_id)` returns nonzero if the given power already has that FF.
 * The actual ownership query site in VICEROY.EXE is not yet decoded (see effects.c note:
 * the dispatch bumps the count at PowerRecord+0x14 but the per-FF "owned" bit
 * is set elsewhere). This helper is therefore expressed against a callback.
 * ---------------------------------------------------------------------------- */
int ff_is_available(int ff_id, int (*owned_test)(int ff_id))
{
    if (ff_id < 0 || ff_id >= 25) return 0;
    if (owned_test(ff_id)) return 0;                 /* already recruited */

    /* Available iff every EARLIER father of the SAME category is owned
     * (so only the next un-recruited father in each category is offerable). */
    int cat = FF_TABLE[ff_id].category;
    for (int j = 0; j < ff_id; j++) {
        if (FF_TABLE[j].category == cat && !owned_test(j))
            return 0;                                /* a lower-level same-type FF still missing */
    }
    return 1;
}

/* ============================================================================
 *               >>> BYTE-VERIFIED recruitment helpers (page 0x06) <<<
 * ----------------------------------------------------------------------------
 * The bell accumulation + Continental-Congress trigger (func_03C322) and the
 * election screen (func_03BFD2) are in src/founding_fathers/congress.c. The
 * small recruitment-eligibility helpers below were hand-decompiled from the
 * same overlay page (file image base 0x03B380; @asm = absolute file offset;
 * spot-checked against raw EXE bytes, VERIFICATION_LEDGER.md 2026-05-30).
 *
 * These index the in-MEMORY @FATHERS table at DGROUP:0x9652 (stride 6):
 *   +0x00 word  per-FF flag/notify handle
 *   +0x02 byte  category (0..4)
 *   +0x03..+0x05  era-band weights (band 0/1/2 from ff_era_band)
 * (loaded from NAMES.TXT @FATHERS at startup by func_0749E0).
 * ---------------------------------------------------------------------------- */
#define FF_MEM_BASE   0x9652   /* word[0]=handle, byte[2]=cat, byte[3..5]=era weights */
#define FF_MEM2_BASE  0x96E8   /* 6-word FOUNDING table: [cat*2] = per-cat display value (see congress.c) */

extern struct PowerRecord *g_active_power; /* DGROUP:0x84FC */
extern int     ff_owned(int ff_id, int power); /* 0x181F:0x07B4 -> nonzero if power owns ff_id (body in thunk page) */

/* ----------------------------------------------------------------------------
 * ff_set_owned_bit -- func_03B900 @0x03B900  (page 0x06, ENTER 6,0, RETF)
 * ----------------------------------------------------------------------------
 * RESOLVES the prior pass's left unresolved: "FF owned bitmap PowerRecord+0x07 set on
 * acquire — caller/congress path". The per-power FF-owned bitmap is a byte
 * array at PowerRecord+0x07 (DGROUP 0x880F = power_table 0x8808 + 0x07),
 * indexed BIT-wise by ff_id: byte = base + power*0x13C + (ff_id>>3),
 * bit = 1 << (ff_id & 7). `set`!=0 → OR the bit in; else AND the complement.
 *   power == [bp+6], ff_id == [bp+8], set == [bp+0xa]
 * @asm 03B907 `and cl,7` (bit); 03B90D `shl ax,cl`; 03B918 `imul dx,[bp+6],0x13c`;
 *      03B91F `add cx,0x880f`; 03B92B `or [bx],al` / 03B937 `and [bx],al`.
 * Status: BYTE_VERIFIED. (This is what func_03BC42 does NOT do — confirms the
 * acquire dispatch only bumps count+0x14/slot+0x12; the bit is set HERE.)
 * ---------------------------------------------------------------------------- */
void ff_set_owned_bit(int power, int ff_id, int set)
{
    uint8_t  bit  = (uint8_t)(1 << (ff_id & 7));               /* @asm 03B904/03B90D */
    uint8_t *byte = (uint8_t *)(0x880F
                  + (unsigned)power * POWER_RECORD_STRIDE
                  + ((unsigned)ff_id >> 3));                   /* @asm 03B915 sar cx,3 ; 03B918 imul 0x13c ; 03B91F add 0x880f */
    if (set)                                                   /* @asm 03B923 cmp [bp+0xa],0 ; je clear */
        *byte |= bit;                                          /* @asm 03B92B or  [bx],al */
    else
        *byte &= (uint8_t)~bit;                                /* @asm 03B933 not al ; 03B937 and [bx],al */
}

/* ----------------------------------------------------------------------------
 * ff_available -- func_03B93C @0x03B93C  (page 0x06, push bp;mov bp,sp, RETF)
 * ----------------------------------------------------------------------------
 * Returns 1 if `power` does NOT own `ff_id`, else 0 — the boolean inverse of
 * the overlay-resident ff_owned (0x181F:0x07B4). This is the exact predicate
 * the Congress candidate loop filters on (un-owned FFs are offerable).
 *   ff_id == [bp+6], power == [bp+8]
 * @asm 03B945 `lcall 0x181f,0x7b4`; 03B94C `or ax,ax`; 03B94E `je ->1` else 0.
 * Status: BYTE_VERIFIED (flow); ff_owned body in thunk page (overlay-resident).
 * ---------------------------------------------------------------------------- */
int ff_available(int ff_id, int power)
{
    if (ff_owned(ff_id, power) != 0)    /* @asm 03B945 lcall 0x7b4 ; 03B94C or ax,ax */
        return 0;                       /* @asm 03B950 sub ax,ax (owned -> not available) */
    return 1;                           /* @asm 03B954 mov ax,1 */
}

/* ----------------------------------------------------------------------------
 * ff_count_offerable_in_cat -- func_03B980 @0x03B980  (page 0x06, ENTER 4,0)
 * ----------------------------------------------------------------------------
 * Counts FFs in category `cat` that the power does NOT own AND whose CURRENT
 * era-band weight is nonzero — i.e. how many are actually offerable now.
 *   power == [bp+6], cat == [bp+8]
 * @asm 03B996 `lcall 0x7b4` (skip if owned); 03B9B0 `cmp [bx-0x69ac],al`
 *      (category match); 03B9B7 `call 0x109a` (era band -> si); 03B9C7
 *      `cmp [bx+si-0x69ab],0` (weight!=0); 03B9CE `inc [bp-4]`. Loop ff 0..24.
 * Status: BYTE_VERIFIED. (ff_category_band = call 0x109a, overlay-resident, body in thunk page.)
 * ---------------------------------------------------------------------------- */
extern int ff_category_band(int power); /* call 0x109a -> ljmp 0x1A1F:0x0046 (body in thunk page) */

int ff_count_offerable_in_cat(int power, int cat)
{
    int n = 0;                                                 /* @asm 03B987 [bp-4]=0 */
    int band;
    int ff;
    for (ff = 0; ff < 25; ff++) {                              /* @asm 03B9D4 cmp [bp-2],0x19 */
        if (ff_owned(ff, power))                               /* @asm 03B996 lcall 0x7b4 ; 03B9A0 jne skip */
            continue;
        if (*(uint8_t *)(FF_MEM_BASE + ff * 6 + 0x02) != (uint8_t)cat) /* @asm 03B9B0 cmp [bx-0x69ac],al */
            continue;
        band = ff_category_band(power);                        /* @asm 03B9B7 call 0x109a (per matching FF, as in asm) */
        if (*(uint8_t *)(FF_MEM_BASE + ff * 6 + 0x03 + band) != 0)     /* @asm 03B9C7 cmp [bx+si-0x69ab],0 */
            n++;                                               /* @asm 03B9CE inc [bp-4] */
    }
    return n;                                                  /* @asm 03B9DA */
}

/* ----------------------------------------------------------------------------
 * ff_count_owned_in_cat -- func_03B9E0 @0x03B9E0  (page 0x06, ENTER 4,0)
 * ----------------------------------------------------------------------------
 * Counts FFs in category `cat` the power DOES own. (Used to gate the
 * in-category unlock ladder: a higher FF appears once a lower same-type FF
 * is owned — matches ff_is_available() above.)
 *   power == [bp+6], cat == [bp+8]
 * @asm 03B9F4 `lcall 0x7b4`; 03B9FE `je skip` (count only OWNED); 03BA0E
 *      `cmp [bx-0x69ac],al` (category); 03BA14 `inc [bp-4]`. Loop ff 0..24.
 * Status: BYTE_VERIFIED.
 * ---------------------------------------------------------------------------- */
int ff_count_owned_in_cat(int power, int cat)
{
    int n = 0;                                                 /* @asm 03B9E6 [bp-4]=0 */
    int ff;
    for (ff = 0; ff < 25; ff++) {                              /* @asm 03BA1A cmp [bp-2],0x19 */
        if (!ff_owned(ff, power))                              /* @asm 03B9F4 lcall 0x7b4 ; 03B9FE je skip */
            continue;
        if (*(uint8_t *)(FF_MEM_BASE + ff * 6 + 0x02) == (uint8_t)cat) /* @asm 03BA0E cmp [bx-0x69ac],al */
            n++;                                               /* @asm 03BA14 inc [bp-4] */
    }
    return n;                                                  /* @asm 03BA20 */
}

/* ----------------------------------------------------------------------------
 * ff_best_offer_category -- func_03BA5A @0x03BA5A  (page 0x06, ENTER 8,0)
 * ----------------------------------------------------------------------------
 * Returns the CATEGORY (0..4) with the highest candidate score from the
 * overlay-resident scorer ff_cat_candidate (0x1A1F:0x0054), else 0xFFFF.
 * Early-out: if the power's founding_fathers_count (PowerRecord+0x14,
 * [bx-0x77e4] with bx=power*0x13C; 0x8808+0x14 == 0x10000-0x77e4) is >= 0x19
 * (25, i.e. every FF already recruited) it returns 5 — the Independence
 * pseudo-category sentinel (FF_CAT_INDEPENDENCE), meaning "no normal FF left".
 *   power == [bp+6]  (the `cat` arg [bp+8] is unused by the body)
 * @asm 03BA67 `imul bx,[bp+6],0x13c`; 03BA6C `cmp [bx-0x77e4],0x19` (FF count);
 *      03BA73 `mov ax,5; retf`. Else loop i 0..4 calling 0x109f(i,power);
 *      03BA8A `cmp ax,[bp-8]` keep max; 03BA92/03BA95 record best i.
 * Status: BYTE_VERIFIED — [bx-0x77e4] == PowerRecord+0x14 == FF count
 *      (cross-confirmed: effects.c increments the same +0x14 on acquire).
 *      ff_cat_candidate body in thunk page.
 * ---------------------------------------------------------------------------- */
extern int ff_cat_candidate(int cat, int pw); /* call 0x109f -> ljmp 0x1A1F:0x0054 (score; body in thunk page) */

int ff_best_offer_category(int power)
{
    int best_id = -1;                                          /* @asm 03BA5E [bp-2]=0xffff */
    int best_score = -1;                                       /* @asm 03BA64 [bp-8]=0xffff */
    int i;
    uint8_t *pr = (uint8_t *)(0x8808 + (unsigned)power * POWER_RECORD_STRIDE); /* @asm 03BA67 imul 0x13c */
    if (pr[0x14] >= 0x19)                                      /* @asm 03BA6C cmp [bx-0x77e4],0x19 ; jb (FF count == all 25) */
        return FF_CAT_INDEPENDENCE;                            /* @asm 03BA73 mov ax,5 (sentinel: no FF left) */
    for (i = 0; i < 5; i++) {                                  /* @asm 03BA9B cmp [bp-6],5 */
        int s = ff_cat_candidate(i, power);                    /* @asm 03BA84 call 0x109f */
        if (s >= best_score) {                                 /* @asm 03BA8A cmp ax,[bp-8] ; jl skip */
            best_score = s;                                    /* @asm 03BA8F mov [bp-8],ax */
            best_id = i;                                       /* @asm 03BA95 mov [bp-2],ax */
        }
    }
    return best_id;                                            /* @asm 03BAA1 */
}

/* ============================================================================
 * NARROWED not yet decoded (NOT byte-verified) — what remains after the 2026-05-30 pass:
 * ----------------------------------------------------------------------------
 *   - [RESOLVED 2026-05-30] The bell COST CURVE per FF# = ff_bells_required
 *     (0x191F:0x0F66 -> page 0x06 +0x982 -> file **0x03C282**, func_03C282; the
 *     old "0x026282" was a pre-RTLink-tool mis-resolution). Byte-ported in
 *     src/overlay/overlay_038A50_03C5A8.c: difficulty-scaled base x1.5 per era
 *     gate (yrs 0x640/0x672/0x6A4/0x6D6), grows with owned-FF count, halved for
 *     the first FF, flat post-independence.
 *     Runtime datum (docs/DATA_MODEL.md:313): cost == 129 when Brewster
 *     is the next FF with 99 bells accumulated ("30 in 129"). The technical
 *     reference's {85,103,123,145,170,...,1362} table is NOT at a cited offset
 *     and is NOT verified — do NOT treat as the curve.
 *   - ff_owned (0x181F:0x07B4): the per-FF "does power own it" query body —
 *     overlay-resident (type-B thunk to seg 0x981), blocked. Its ROLE is
 *     proven (ff_available is its byte-verified boolean inverse) and it reads
 *     the PowerRecord+0x07 bitmap that ff_set_owned_bit writes.
 *   - ff_category_band (0x1A1F:0x0046) and ff_cat_candidate (0x1A1F:0x0054):
 *     overlay-resident scorers; call sites + args verified, bodies in thunk page.
 *   - The PASSIVE FFs (ids 0,2,3,4,5,7,8,10,11,12,13,15,17,19,21,23) are
 *     applied at the relevant subsystem tick, not by func_03BC42; those query
 *     sites live in their own subsystems (out of FF scope here).
 * ============================================================================ */
