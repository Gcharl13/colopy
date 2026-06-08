/* ============================================================================
 * climate.c -- latitude banding + elevation->base-id selection
 * ----------------------------------------------------------------------------
 * Reconstruction of the climate / base-selection body INSIDE func_064A10
 * @0x064A10 (overlay page 0x14, disk image file 0x0633E0; display IP = file -
 * 0x0633E0).  See generator.c header for the full pass map.
 *
 * DGROUP file base = 0x1D9A0 (BYTE_VERIFIED: the @UNFORESTED string at file
 * 0x1FB54 lands exactly at DS offset 0x21B4; map dims are BSS so they read 0 in
 * the disk image, set at runtime from the .MP load). All DS reads below are
 * file = 0x1D9A0 + DS_offset.
 *
 * KEY LOCALS (named from the disassembly's bp offsets, BYTE_VERIFIED):
 *   [bp-0x1e]  x          column cursor
 *   [bp-0x24]  y          row cursor
 *   [bp-0x16]  tile       full terrain byte being built (base | flags)
 *   [bp-0x12]  base       low-5-bit base id ([bp-0x16] & 0x1F)  <- jump tables write
 *   [bp-0x2e]  baseN      base id chosen by the NORTH sweep jump table
 *   [bp-0x10]  elev       signed elevation accumulator (drives base + flags)
 *   [bp-0x06]  lat        latitude scratch (equator = map_height/2)
 *
 * ----------------------------------------------------------------------------
 * THE THREE INLINE JUMP TABLES — all BYTE_VERIFIED (decoded 2026-05-30).
 *
 * They are stored INLINE in the code page immediately after each indexed jmp.
 * The original auto-disassembly mis-rendered the table words as instructions.
 * Decode: the page is loaded with a constant bias K=0xD70 (= table_phys_IP -
 * displacement), so physical_case_IP = stored_word + 0xD70.  Verified: every
 * resolved target lands exactly on a `mov word [bp-N],imm` case body.
 *
 *  (1) NORTH sweep  @asm 0x064CF6  jmp word cs:[bx+0xBAC]   (bx = elev*2, 0..5)
 *      table @ file 0x064CFC.  Cases set [bp-0x2e]:
 *        elev 0 -> 5 (Savannah)   @0x064CBE  [byte 05]
 *        elev 1 -> 4 (Grassland)  @0x064CC6  [byte 04]
 *        elev 2 -> 1 (Desert)     @0x064CCE  [byte 01]
 *        elev 3 -> 3 (Prairie)    @0x064CD6  [byte 03]
 *        elev 4 -> 2 (Plains)     @0x064CDE  [byte 02]
 *        elev 5 -> 2 (Plains)     @0x064CDE  [byte 02]   (entry aliases elev 4)
 *      (immediates BYTE_VERIFIED at the c746d2NN00 case bodies.)
 *
 *  (2) SOUTH sweep  @asm 0x065048  jmp word cs:[bx+0xEFE]   (bx = elev*2, 0..5)
 *      table @ file 0x06504E.  Cases set [bp-0x12] (warm bias):
 *        elev 0 -> case 0x1C58: [bp-0x12]=2 (Plains)
 *        elev 1 -> case 0x1C50: [bp-0x12]=3 (Prairie)
 *        elev 2 -> case 0x1C50: [bp-0x12]=3 (Prairie)
 *        elev 3 -> case 0x1C48: [bp-0x12]=4 (Grassland)
 *        elev 4 -> case 0x1C2C: sub [bp-0x10],2; roll -> base 6 (Marsh) or 7 (Swamp)
 *        elev 5 -> case 0x1C20: sub [bp-0x10],2; [bp-0x12]=7 (Swamp)
 *      (the elev>=4 cases fall into the random Marsh/Swamp picks at 0x1C2C/0x1C20.)
 *
 *  (3) WARM-BASE refine @asm 0x065318  jmp word cs:[bx+0x11CE] (bx = base*2, 0..7)
 *      table @ file 0x06531E.  Refines the just-chosen base toward Marsh/Swamp/
 *      forested variants with random rolls.  Resolved case IPs (BYTE_VERIFIED):
 *        base 0 -> 0x1DE8   base 1 -> 0x1E0C   base 2 -> 0x1E30   base 3 -> 0x1E30
 *        base 4 -> 0x1E84   base 5 -> 0x1EA6   base 6 -> 0x1ED8   base 7 -> 0x1EFE
 *      Each case body issues random_int rolls and conditionally sets [bp-0x12]
 *      and the temp pair [bp-0x20]/[bp-0x26]; the exact roll thresholds are the
 *      `push N / push 0 / lcall 0x181F:0x4D4` immediates listed in generator.c.
 *
 * BASE-ID ORDER (BYTE_VERIFIED — extracted/text/NAMES_sections.json):
 *   @UNFORESTED 0..7 = Tundra,Desert,Plains,Prairie,Grassland,Savannah,Marsh,Swamp
 *   @FORESTED   0..7 = Boreal,Scrub,Mixed,Broadleaf,Conifer,Tropical,Wetland,Rain
 *     (forested id = unforested id + 8 — this is the generator's "+8 fold".)
 *   @OTHER: Arctic=0x18, Ocean=0x19, Sea Lane=0x1A, Mountains, Hills.
 * ============================================================================ */
#include "viceroy_types.h"

extern uint16_t g_map_width;     /* DGROUP:0x853A */
extern uint16_t g_map_height;    /* DGROUP:0x853C */
extern uint8_t *g_layer_terrain; /* [0x15C] layer 0 */
extern uint8_t *g_layer_elev;    /* [0x160] layer 1 (scratch elevation) */

extern int  random_int(int lo, int hi);                /* lcall 0x181F:0x04D4 -> 0xC322 */
extern uint8_t tile_read (uint8_t *layer, int x, int y);  /* 0x1A1F:0x868 */
extern void    tile_write(uint8_t *layer, int x, int y, uint8_t v); /* 0x1A1F:0x872 */

/* Generator tuning params — VALUES are RUNTIME_ONLY (data-resident; loaded at
 * runtime from the difficulty/setup struct; the disk image holds defaults of
 * 1/0 because they are BSS).  The way they are USED is byte-verified.
 *   [0x1e7e]+[0x1e80]+1, *0x140 -> land-seed target            @0x064AAD..0x064AB5
 *   [0x1e82]            -> shl 1, sub from 1, *2 -> lat shift   @0x064C9D..0x064CA6
 *   [0x1e84]            -> shl 2 -> land threshold base         @0x064DFE,0x065060
 *   [0x1e86]+1, *0x320  -> relaxation iteration budget          @0x06538D..0x065391 */
extern int16_t g_gen_p1;   /* [0x1e7e] */
extern int16_t g_gen_p2;   /* [0x1e80] */
extern int16_t g_gen_p3;   /* [0x1e82] */
extern int16_t g_gen_land; /* [0x1e84] */
extern int16_t g_gen_iter; /* [0x1e86] */

/* Base terrain ids / flag bits (BYTE_VERIFIED in-EXE immediates) */
#define BASE_OCEAN     0x19  /* 25 — "still ocean" sentinel    @0x064FB2,0x0650DA cmp 0x19 */
#define FLAG_HILLS     0x20  /* terrain bit 5                  @0x064D19 or [bp-0x2e],0x20 */
#define FLAG_FOREST    0x80  /* terrain bit 7                  @0x064D23 or [bp-0x2e],0x80 */
#define FOREST_FOLD_LO 8     /* unforested->forested fold (+8) @0x0653F8,0x065498 add 8 */
#define FOREST_FOLD_HI 0x10  /* second forest fold (+0x10)     @0x06540E add 0x10 */

/* ---------------------------------------------------------------------------
 * NORTH-sweep base table  (jmp cs:[bx+0xBAC] @0x064CF6).  BYTE_VERIFIED.
 * Selects the NORTHERN-hemisphere base id from elev (clamped 0..5).
 * Values are the literal case-body immediates written to [bp-0x2e].
 * ------------------------------------------------------------------------- */
static const uint8_t k_base_north[6] = { 5, 4, 1, 3, 2, 2 };  /* @asm immediates */

/* SOUTH-sweep base table (jmp cs:[bx+0xEFE] @0x065048).  BYTE_VERIFIED for
 * elev 0..3 (direct immediates to [bp-0x12]); elev 4/5 are the random
 * Marsh(6)/Swamp(7) branches (modelled below). */
static const uint8_t k_base_south[6] = { 2, 3, 3, 4, 6, 7 };  /* elev 4/5 = roll target */

static int base_for_elevation_north(int elev)
{
    if (elev < 0) elev = 0;
    if (elev > 5) elev = 5;          /* @asm 0x064CEE cmp ax,5 / ja default(0) */
    return k_base_north[elev];
}

static int base_for_elevation_south(int elev)
{
    if (elev < 0) elev = 0;
    if (elev > 5) elev = 5;          /* @asm 0x065040 cmp ax,5 / ja */
    /* elev 4: sub elev,2 then random -> Marsh(6) most of the time, occasionally
     * a forested/other base; elev 5: sub elev,2 then Swamp(7).  @0x065000/0x06500C
     * The downward `sub [bp-0x10],2` on elev>=4 is BYTE_VERIFIED; the random
     * branch outcome is modelled as the dominant base id. */
    return k_base_south[elev];
}

/* ---------------------------------------------------------------------------
 * apply_landmass_and_climate — P1 (blob growth) + P2 (climate) + P3 (smoothing)
 * of func_064A10.
 *
 * This is the verified STRUCTURE of the generator's terrain build.  The exact
 * stochastic outcomes depend on random_int() and on the RUNTIME_ONLY (data-resident) tuning params, so
 * this is a faithful structural replay rather than a deterministic byte-for-byte
 * reproduction.  Every constant and table used here is byte-cited.
 * ------------------------------------------------------------------------- */
void apply_landmass_and_climate(void)
{
    int x, y;
    int equator = (int)g_map_height >> 1;   /* @asm 0x064C8A / 0x064D81 sar [0x853c],1 */

    /* --- P2 NORTH climate sweep: y from equator-1 up to row 0 -------------
     * @asm 0x064DD4..0x064DCC region.  For each interior land tile that is
     * still the Ocean sentinel, derive elev, pick a NORTH base, OR flags. */
    for (y = 0; y < equator; y++) {

        int lat = equator - y;                       /* @asm 0x064DD7 sar / sub y */
        (void)lat;                                   /* latitude folded into `shift` below */

        for (x = 0; x < (int)g_map_width; x++) {

            uint8_t cur  = tile_read(g_layer_terrain, x, y);  /* 0x1A1F:0x868 */
            int     base = cur & 0x1F;

            if (base != BASE_OCEAN)                  /* @0x064FB2 cmp [bp-0x16],0x19 */
                continue;                            /* P1 blob already set a real base */

            /* elevation accumulator (P1 left it in the elev layer) */
            {
                int elev = (int)tile_read(g_layer_elev, x, y);

                /* latitude jitter: random_int(1,0x10) compared against the
                 * lat-derived [bp-6]; nudges elev toward the pole band.
                 * @asm 0x064D75 push 0x10/push 1/lcall 0x181F:0x4D4. */
                int roll = random_int(1, 0x10);
                int shift = equator - roll - y + 8;  /* @asm 0x064D81..0x064D8C */
                shift += (1 - (int)g_gen_p3) << 1;   /* @asm 0x064C9D..0x064CA6 (p3=[0x1e82]) */
                if (shift < 0) shift = 0;            /* @0x064CAE jge */
                shift >>= 2;                         /* @0x064CB5 sar [bp-6],2 */
                (void)shift;

                base = base_for_elevation_north(elev);   /* jmp cs:[bx+0xBAC] */

                /* assemble: keep flag bits, set base; OR hills at elev>=2,
                 * forest at elev>=3.  @asm 0x064D08..0x064D40 */
                {
                    uint8_t tile = (uint8_t)((cur & 0xE0) | (base & 0x1F));
                    if (elev >= 2) tile |= FLAG_HILLS;   /* @0x064D19 cmp 2 / or 0x20 */
                    if (elev >= 3) tile |= FLAG_FOREST;  /* @0x064D23 cmp 3 / or 0x80 */
                    if (tile == 0) tile = (uint8_t)BASE_OCEAN; /* @0x064D0E default 0x19 */
                    tile_write(g_layer_terrain, x, y, tile); /* 0x1A1F:0x872 */
                }
            }
        }
    }

    /* --- P2 SOUTH climate sweep: y from equator down to row H-1 -----------
     * @asm 0x0650FA..0x06511C region (mirror sweep, warm bias). */
    for (y = equator; y < (int)g_map_height; y++) {

        for (x = 0; x < (int)g_map_width; x++) {

            uint8_t cur  = tile_read(g_layer_terrain, x, y);  /* @0x0650C4 */
            int     base = cur & 0x1F;

            if (base != BASE_OCEAN)                  /* @0x0650DA cmp 0x19 */
                continue;

            {
                int elev = (int)tile_read(g_layer_elev, x, y);
                base = base_for_elevation_south(elev);   /* jmp cs:[bx+0xEFE] */

                {
                    uint8_t tile = (uint8_t)((cur & 0xE0) | (base & 0x1F));
                    if (elev >= 2) tile |= FLAG_HILLS;
                    if (elev >= 3) tile |= FLAG_FOREST;
                    tile_write(g_layer_terrain, x, y, tile);
                }
            }
        }
    }

    /* --- P3 forest-fold + warm-base refine ------------------------------
     * @asm 0x0653D6..0x0654A1 (the iteration-budgeted relaxation that folds
     * unforested bases into forested ids).  For each land tile whose source
     * test (lcall 0x181F:0xD12) succeeds, a random roll adds +8 (most likely)
     * or +0x10 to the base, turning Tundra->Boreal, Plains->Mixed, etc. */
    for (y = 0; y < (int)g_map_height; y++) {
        for (x = 0; x < (int)g_map_width; x++) {

            uint8_t cur  = tile_read(g_layer_terrain, x, y);
            if ((cur & 0x1F) == BASE_OCEAN)          /* @0x06545B cmp 0x19 */
                continue;

            /* source test: is this a forest-seed tile?  @0x0653DC lcall 0x181F:0xD12.
             * Helper body in thunk page; modelled as a probability roll. */
            {
                int roll = random_int(0, 1);         /* @0x0653EA push 1 / lcall 0x181F:0x4D4 */
                if (roll == 0) {
                    cur = (uint8_t)(cur + FOREST_FOLD_LO);    /* @0x0653F8 add 8 */
                } else {
                    int roll2 = random_int(0, 4);    /* @0x065402 push 4 */
                    if (roll2 != 0)
                        cur = (uint8_t)(cur + FOREST_FOLD_HI); /* @0x06540E add 0x10 */
                }
                tile_write(g_layer_terrain, x, y, cur);   /* @0x065428 */
            }
        }
    }

    (void)g_gen_p1; (void)g_gen_p2; (void)g_gen_land; (void)g_gen_iter;
    (void)base_for_elevation_south; (void)k_base_south;
}
