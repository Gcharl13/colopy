/* ============================================================================
 * naval_classify.c -- func_03FA9C naval_classify_dest  [PORTED 2026-06-10]
 * ----------------------------------------------------------------------------
 * The player-move gate (file 0x3FA9C..0x3FDDD, 834 B, full transcription in
 * docs/MAP_COMPOSER_SPEC.md + re_work/disasm/func_03FA9C.asm).  Returns 1 =
 * plain move legal; returns 0 with [0x9E4E] = status 1..9 for the
 * naval_move_arrive dialog dispatch (NODOCKS/LANDFALL/SAILHOME/SHIPCOMBAT/
 * SHIPLAKE/LANDFIRST), or 0 with status 0 = silently blocked.
 *
 * Helpers (resident, all already ported):
 *   0x6BE owner_at        func_005FD4   0x6D2 occ-power     func_006018
 *   0x916 (unit notify)   func_007966   0x72C terrain       func_005CFE
 *   0x7E0 occupant_at     func_0066CC   0x6B4 lake_test     func_005DBA
 *   0x90C moves-q         func_006CCA   0x2EE/0x2E4 cargo chain first/next
 *   0x696                 func_005F48   0x682 foreign_at    func_005F04
 *   0x948 leave-notify    func_006A7C
 * Capacity near-call (0x3FFF8 -> 0x1A1F:0x1A0): target in AMBIG seg --
 * semantic gate cite-marked TODO (returns "can board").
 * ============================================================================ */
#ifdef _VICEROY_MODERN

#include "viceroy_types.h"
#include "dgroup.h"

#define UB(i, off)  DG8(0x3144 + (i)*0x1C + (off))

extern int func_005FD4_map_xy_bounds_or_neg1_alt(uint16_t x, uint16_t y); /* 0x6BE */
extern int func_006018_logic_sz_33(uint16_t x, uint16_t y);              /* 0x6D2 */
extern int func_007966_logic_sz_41(uint16_t u);                          /* 0x916 */
extern int func_005CFE_map_tile_read_layer_15C(uint16_t x, uint16_t y);  /* 0x72C */
extern int func_0066CC_op_sz_57(uint16_t x, uint16_t y);                 /* 0x7E0 */
extern int func_005DBA_logic_sz_17(uint16_t x, uint16_t y);              /* 0x6B4 */
extern int func_006CCA_logic_sz_13(uint16_t u);                          /* 0x90C */
extern int func_005F48_logic_sz_58(uint16_t x, uint16_t y);              /* 0x696 */
extern int func_005F04_map_xy_bounds_or_neg1(uint16_t x, uint16_t y);    /* 0x682 */
extern int func_006A7C_logic_sz_50(uint16_t u, uint16_t x, uint16_t y);  /* 0x948 */
extern int unit_chain_resolve(int x, int y);     /* 0x2EE family (units.c) */
extern int unit_chain_next(int u);               /* 0x2E4 family */

static int cargo_can_board(int occupant, int role, int z)
{
    /* near 0x3FFF8 -> 0x1A1F:0x1A0 (AMBIG seg) -- hold-capacity gate.
     * TODO(decode): until then boarding is permitted. */
    (void)occupant; (void)role; (void)z;
    return 1;
}

int naval_classify_dest(int unit, int dest_x, int dest_y)
{
    int ret = 0;                                   /* [bp-0xA] @0x3FAA4 */
    DG16(0x9E4E) = 0;                              /* status   @0x3FAA9 */

    /* bounds @0x3FAAC..0x3FAEF */
    if (dest_y < 1 || dest_y >= (int16_t)DG16(0x853C) - 1)
        return 0;                                  /* -> 0x3FDD8 (ret 0) */
    if (dest_x >= (int16_t)DG16(0x853A) - 1 || dest_x < 1) {
        int t = UB(unit, 2);
        if (t < 0xD || t > 0x12) return 0;         /* @0x3FAD0/0x3FADA */
        DG16(0x9E4E) = 4;                          /* SAILHOME @0x3FAE4 */
        return 0;
    }

    int src_x = UB(unit, 0);                       /* @0x3FAF4 */
    int src_y = UB(unit, 1);                       /* @0x3FAFD */
    int type  = UB(unit, 2);
    int is_ship = (type >= 0xD && type <= 0x12);

    int land_owner = func_005FD4_map_xy_bounds_or_neg1_alt((uint16_t)dest_x,
                                                           (uint16_t)dest_y); /* 0x6BE */
    int occ_power  = func_006018_logic_sz_33((uint16_t)dest_x,
                                             (uint16_t)dest_y);  /* 0x6D2 -> [bp-0xE] */
    func_007966_logic_sz_41((uint16_t)unit);                     /* 0x916 @0x3FB29 */

    int raw_dest = func_005CFE_map_tile_read_layer_15C((uint16_t)dest_x,
                                                       (uint16_t)dest_y); /* 0x72C */
    int t_dest = raw_dest & 0x1F;                  /* @0x3FB47 */
    int t_src  = func_005CFE_map_tile_read_layer_15C((uint16_t)src_x,
                                                     (uint16_t)src_y) & 0x1F;
    int water_dest = (t_dest == 0x19 || t_dest == 0x1A);
    int water_src  = (t_src  == 0x19 || t_src  == 0x1A);

    /* A. land unit stepping onto WATER: board a ship @0x3FB6D..0x3FBD7 */
    if (water_dest && !is_ship) {
        int occ = func_0066CC_op_sz_57((uint16_t)dest_x, (uint16_t)dest_y); /* 0x7E0 */
        if (occ < 0) goto tail0;                   /* @0x3FB8F -> 0x3FDC7 */
        if ((UB(occ, 3) ^ UB(unit, 3)) & 0x0F)     /* owner xor @0x3FB9F */
            goto tail0;
        if (cargo_can_board(occ, DG8(0x5238 + type * 9), 0) == 0)
            goto tail0;                            /* @0x3FBD3 */
    }

    /* B. routing ladder @0x3FBDA.. */
    if (!water_dest && is_ship) {
        /* ship at land edge @0x3FBFE: own/foreign-EU owner -> dock checks,
         * else -> landfall classification @0x3FC62 */
        int own = UB(unit, 3) & 0x0F;
        if (!(land_owner == own ||
              (land_owner >= 0 && land_owner < 4))) {
            /* unowned/native shore @0x3FC62 */
            if (occ_power >= 0 && occ_power != own) goto tail0; /* @0x3FC73 */
            if (!water_src) {
                if (func_005F48_logic_sz_58((uint16_t)src_x,
                                            (uint16_t)src_y) < 0) /* 0x696 */
                    goto tail0;                     /* @0x3FC97 */
            }
            /* LANDFALL cargo scan @0x3FC9C..0x3FD0C: first carried unit with
             * role < 0x63 and moves-q gate picks the lander */
            {
                int picked = -1;
                int cur = unit_chain_resolve(src_x, src_y);  /* 0x2EE */
                while (cur >= 0) {
                    int ct = UB(cur, 2);
                    if (DG8(0x5238 + ct * 9) < 0x63) {       /* @0x3FCC9 */
                        int q = func_006CCA_logic_sz_13((uint16_t)unit); /* 0x90C */
                        if (UB(cur, 5) < q) { /* [si+0x3149] vs al @0x3FCDD */
                            picked = cur;
                            /* (original keeps scanning; first hit wins below) */
                        }
                    }
                    if (picked >= 0) break;        /* loop exits when set @0x3FCF4 */
                    cur = unit_chain_next(cur);    /* 0x2E4 */
                }
                if (picked < 0) goto tail0;        /* @0x3FD06 */
                DG16(0x9E50) = (uint16_t)picked;   /* @0x3FD0C lander */
                DG16(0x9E4E) = (raw_dest & 0x40) ? 3 : 2; /* river? LANDFALL2 */
                goto tail0;                        /* @0x3FD1B/0x3FD24 */
            }
        }
        /* owned shore: LANDFIRST rule @0x3FD28..0x3FD59 */
        if (water_src && occ_power >= 0 && occ_power != own) {
            DG16(0x9E4E) = 9;                      /* LANDFIRST @0x3FD53 */
            goto tail0;
        }
        /* fall into dock/water checks @0x3FC1C */
    }

    /* C. ship into water: lake + combat + sea-lane checks @0x3FC34.. */
    if (is_ship && water_dest) {
        if (func_005DBA_logic_sz_17((uint16_t)dest_x, (uint16_t)dest_y) != 1) {
            DG16(0x9E4E) = 8;                      /* SHIPLAKE @0x3FC58 */
            goto tail0;
        }
        /* foreign unit there -> SHIPCOMBAT message @0x3FD5C..0x3FD91 */
        {
            int f = func_005F04_map_xy_bounds_or_neg1((uint16_t)dest_x,
                                                      (uint16_t)dest_y); /* 0x682 */
            if (f >= 0 && f != (UB(unit, 3) & 0x0F)) {
                int ft = UB(unit, 2);
                if (!(ft >= 0x10 && ft <= 0x12)) { /* @0x3FD7D..0x3FD89 */
                    DG16(0x9E4E) = 7;
                    goto tail0;
                }
            }
        }
        /* sea-lane eastward = sail-home prompt @0x3FD94..0x3FDC0 */
        if (t_dest == 0x1A && t_src == 0x1A && src_x < dest_x &&
            UB(unit, 8) != 3 && UB(unit, 8) != 2) {
            DG16(0x9E4E) = 5;                      /* @0x3FDBA */
            goto tail0;
        }
    }

    ret = 1;                                       /* MOVE LEGAL @0x3FDC2 */
tail0:
    /* leave-notify always runs @0x3FDC7 (0x948) */
    func_006A7C_logic_sz_50((uint16_t)unit, (uint16_t)src_x, (uint16_t)src_y);
    return ret;                                    /* @0x3FDD8 */
}

#endif /* _VICEROY_MODERN */
