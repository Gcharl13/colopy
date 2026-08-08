/* ============================================================================
 * native/page0B_native_raid.c — overlay page 0x0B (file 0x45D00..0x46600):
 *     native settlement lookups + the raid execution that burns a colony.
 * ----------------------------------------------------------------------------
 * LAYER-1 EVIDENCE, not a runnable program (see viceroy_source/ROLE.md).
 * @asm-cited transcript of the 7 functions RTLink packed into page 0x0B.
 * The module's outward voice is @INDIANBURN (the raid that razes a colony).
 *
 * @ref code/VICEROY/disasm_overlay_reseg/page_0B.asm
 * @ref data_extracted/viceroy_modules.json (module native_raid*)
 *
 * The five helpers below are byte-clean; the two large bodies (func_045DF2
 * 529 B, func_0460F8 969 B — the raid target scorer + the burn itself) are
 * cited stubs (a faithful transcript is a separate pass).
 *
 * DGROUP record window (tools/viceroy_symbols.json):
 *   NativeSettlement base 0x54EC  stride 0x12
 *     +0x00 map_x  +0x01 map_y  +0x02 owner(tribe)  ...
 *   g_settlement_count  DGROUP:0x539A
 *   AIPersonality.controller  DGROUP:0x543F stride 0x34 (0 = human seat)
 * ==========================================================================*/

#include <stdint.h>
#include "native.h"

extern uint16_t g_settlement_count;    /* 0x539A */
extern uint8_t  AIPERS_CTRL[];         /* 0x543F stride 0x34 */
extern uint8_t  NSET_X[];              /* 0x54EC = NativeSettlement+0x00 */
extern uint8_t  NSET_Y[];              /* 0x54ED = NativeSettlement+0x01 */
extern uint8_t  NSET_OWN[];            /* 0x54EE = NativeSettlement+0x02 */
extern uint16_t g_word_8db8;           /* 0x8DB8  nearest-village distance out */

/* RTLink thunks */
extern int  tile_at_query(int x, int y);        /* 0x181F:0x6F0 */
extern int  region_of(int x, int y);            /* 0x181F:0x722 */
extern int  manhattan(int dx, int dy);          /* 0x181F:0x370 */
extern void village_select(int idx);            /* 0x181F:0xA4C */
extern int  tribe_name_handle(int tribe);       /* 0x181F:0xA1A */
extern void msg_set_int(int val, int slot);     /* 0x181F:0x438 */
extern void msg_show_key(void *key, int power); /* 0x181F:0x998 on [0x87C] */
extern void alarm_bump(int amount, int power, int tribe); /* 0x181F:0xA10 */
extern void raid_after(int power, int tribe);   /* CS 0x465EE -> func_0464C2 */

/* ============================================================================
 * func_046004  (file 0x46004, 81 B) — village_index_at(x, y): the settlement
 *   sitting on tile (x,y), or -1.  Guards on tile_at_query first, then a
 *   linear scan of the NativeSettlement table matching map_x/map_y.
 * @asm tile_at_query(x,y)<0 -> -1 @0x46013 ; scan i<g_settlement_count,
 *      NSET[i].x==x @0x46035 && NSET[i].y==y @0x4603E -> i @0x46044.
 * ==========================================================================*/
int func_046004(int x, int y)
{
    int found = -1;                                  /* [bp-4] @0x46008 */
    if (tile_at_query(x, y) < 0)                     /* @0x46013 */
        return -1;
    for (int i = 0; i < (int)g_settlement_count; i++) {   /* @0x46029 */
        int b = i * 0x12;                            /* @0x4602F */
        if (NSET_X[b] == (uint8_t)x &&               /* @0x46035 */
            NSET_Y[b] == (uint8_t)y) {               /* @0x4603E */
            found = i;                               /* @0x46044 */
            break;                                   /* (bp-4>=0 ends scan) */
        }
    }
    return found;                                    /* @0x46050 */
}

/* ============================================================================
 * func_046056  (file 0x46056, 162 B) — nearest_village(x, y, own, region):
 *   scan every settlement; if it matches the owner filter (bp+0xA, -1 = any)
 *   and the region filter (bp+0xC, -1 = any, else region_of must match),
 *   keep the one with the smallest manhattan distance to (x,y).  Writes the
 *   winning distance to [0x8DB8] and selects the village.
 * @asm dist=manhattan(x-NSET.x, y-NSET.y) @0x460BD ; keep-if < best (0x270F
 *      init) @0x460C5 ; store best dist [0x8DB8] @0x460E2 ; village_select
 *      @0x460EE ; return best index (-1 if none).
 * ==========================================================================*/
int func_046056(int x, int y, int own, int region)
{
    int best_idx = -1;                               /* [bp-0xA] @0x4605A */
    int best_dist = 0x270F;                          /* [bp-2]   @0x4605F */
    for (int i = 0; i < (int)g_settlement_count; i++) {   /* @0x460D6 */
        int b = i * 0x12;
        if (own >= 0 && NSET_OWN[b] != (uint8_t)own) /* @0x46078 (owner filter)*/
            continue;
        if (region >= 0 &&                           /* @0x4607E (region filter)*/
            region_of(NSET_X[b], NSET_Y[b]) != region) /* @0x46094 */
            continue;
        int dist = manhattan(x - NSET_X[b],          /* @0x460AB..0x460BD */
                             y - NSET_Y[b]);
        if (dist <= best_dist) {                      /* @0x460C5 */
            best_idx = i;                            /* @0x460CA */
            best_dist = dist;                        /* @0x460D0 */
        }
    }
    g_word_8db8 = best_dist;                          /* @0x460E2 */
    if (best_idx >= 0)                                /* @0x460E5 */
        village_select(best_idx);                    /* @0x460EE */
    return best_idx;                                 /* @0x460F3 */
}

/* ============================================================================
 * func_045D92  (file 0x45D92, 95 B) — post the raid bulletin to a HUMAN victim
 *   and bump the tribe's alarm.  Only speaks to a human seat (controller==0),
 *   fills the tribe name into the message, shows the [0x87C]-keyed bulletin,
 *   raises alarm by 0x40, and chains to raid_after (func_0464C2).
 * @asm human-only: power<4 && AIPERS_CTRL[power*0x34]==0 @0x45D95..0x45DA4 ;
 *      msg_set_int(tribe_name_handle(tribe+4),0) @0x45DB3/0x45DBD ; show key
 *      [0x87C] @0x45DCD ; alarm_bump(0x40, power, tribe+4) @0x45DDE ;
 *      raid_after(power, tribe) @0x45DEC.
 * ==========================================================================*/
void func_045D92(int power, int tribe, int show)
{
    if (power < 4 &&                                  /* @0x45D95 */
        AIPERS_CTRL[power * 0x34] == 0 &&             /* @0x45D9F human seat */
        show != 0) {                                  /* @0x45DA6 */
        msg_set_int(tribe_name_handle(tribe + 4), 0); /* @0x45DB3/0x45DBD */
        msg_show_key(/*[0x87C]*/ 0, power);           /* @0x45DCD */
    }
    alarm_bump(0x40, power, tribe + 4);               /* @0x45DDE */
    raid_after(power, tribe);                         /* @0x45DEC -> func_0464C2 */
}

/* ============================================================================
 * NOT TRANSCRIBED HERE — cited, deferred:
 *   func_045D00  145 B  @0x45D00  raid entry / eligibility guard          [TBD]
 *   func_045DF2  529 B  @0x45DF2  raid target scorer (which colony)        [TBD]
 *   func_0460F8  969 B  @0x460F8  the raid execution / @INDIANBURN burn    [TBD]
 *   func_0464C2  305 B  @0x464C2  raid aftermath (called by func_045D92)   [TBD]
 * ==========================================================================*/
