/* ============================================================================
 * colony/page03_colony_turn.c — overlay page 0x03 (file 0x2CFD0..0x2FAF0):
 *     the colony end-of-turn processing band.
 * ----------------------------------------------------------------------------
 * LAYER-1 EVIDENCE, not a runnable program (see viceroy_source/ROLE.md).
 * A `@asm`-cited transcript of the sixteen functions RTLink packed into
 * overlay page 0x03.  Register-named locals, far RTLink thunks, gotos at exact
 * offsets.  Every constant carries an @asm file-offset + operand-byte cite OR
 * an explicit [TBD].
 *
 * @ref code/VICEROY/disasm_overlay_reseg/page_03.asm   (the 16-function page)
 * @ref data_extracted/viceroy_modules.json             (module colony_econ*)
 *
 * ------------------------------------------------------------------------
 * WHAT THIS PAGE IS.  The module card first glossed page 0x03 as "the colony
 * per-turn economy"; reading the bytes REFINES that — it is the colony
 * turn-end processing band, which is three jobs, not one:
 *
 *   (1) the SoL/Tory% + schooling + food-band + per-commodity status handler
 *       func_02D658 (5220 B) — the module's outward voice (BUILT/FOOD*/
 *       STARVE*/SPOIL*/DEPLETION/SONS*/REBEL*/TORY*/TRAIN*/NEEDTOOLS/…).
 *       *** Already transcribed *** in colony/sol_tory.c; not repeated here.
 *
 *   (2) fog-of-war colony visibility: what a RIVAL power sees of one of our
 *       colonies (population + fortification snapshot, and the predicate
 *       "is this colony visible to power N") — func_02EB1C / func_02EB46.
 *
 *   (3) the prime-resource ring scan revealed around a colony, and the
 *       commodity-surplus gate that decides which goods are tradeable
 *       cargo vs consumed internally — func_02D30A / func_02D606.
 *
 * Plus a two-option colony context popup (func_02CFD0) and a handful of thin
 * thunk-adapter leaves.  The two large render/production bodies (func_02F052,
 * func_02F3A2) are left as cited stubs — a faithful transcript of ~2700 B of
 * branchy code is a separate pass, and a guess would violate the prime
 * directive.
 *
 * DGROUP record windows (tools/viceroy_symbols.json):
 *   ColonyRecord  base 0x5D46  stride 0xCA
 *     +0x00 map_x   +0x01 map_y   +0x1A owner_power   +0x1F size(pop)
 *     +0xBA population_on_map[4]   +0xBE fortification_on_map[4]
 * ==========================================================================*/

#include <stdint.h>
#include "colony.h"      /* colony_t, current-colony ptr, RTLink thunk decls */

/* --- DGROUP globals this page touches (all @asm-cited at use sites) -------- */
extern colony_t *g_current_colony_ptr;   /* DGROUP:0x8542 */
extern uint16_t  g_opt_890;               /* DGROUP:0x0890  render/scan guard  */
extern uint16_t  g_opt_53a2;              /* DGROUP:0x53A2  visibility override */
extern uint16_t  g_word_8de4, g_word_8de6;/* DGROUP:0x8DE4/6  ore-mine counters */
extern uint16_t  g_opt_mode_1f5e;         /* DGROUP:0x1F5E  OPT_MODE_1F5E       */
extern uint8_t   g_flag_337;              /* DGROUP:0x0337  (sibling of 0x0336) */
extern uint8_t   g_ring_found_a898;       /* DGROUP:0xA898  prime-scan found bit*/
extern uint8_t   g_scan_active_a897;      /* DGROUP:0xA897  ring-scan enable    */
extern uint16_t  g_key_game;              /* DGROUP:0x087C  KEY_GAME ($ handle) */

/* ColonyRecord byte-window bases used as `arr[colony_index*0xCA + field]`:
 * these DGROUP addresses are (ColonyRecord base 0x5D46 + field), so e.g.
 * 0x5D65 == 0x5D46+0x1F == the size(pop) byte.  @asm cites at each site.     */
extern uint8_t COL_SIZE[];        /* 0x5D65 = ColonyRecord+0x1F (pop)         */
extern uint8_t COL_OWNER[];       /* 0x5D60 = ColonyRecord+0x1A (owner power) */
extern uint8_t COL_POP_ON_MAP[];  /* 0x5E00 = ColonyRecord+0xBA (per power)   */
extern uint8_t COL_FORT_ON_MAP[]; /* 0x5E04 = ColonyRecord+0xBE (per power)   */

/* --- resident / cross-page helpers reached through the RTLink thunks ------- */
extern colony_t *get_colony_by_slot(int slot);       /* 0x181F:0x9E6 -> 0x82DC */
extern int  colony_query_a994(void);                 /* 0x181F:0xC72 -> 0xA994 */
extern int  colony_query_bc06(void);                 /* 0x181F:0xC22 -> 0xBC06 */
extern int  colony_calc_8c1e(int, int);              /* 0x181F:0xC4A -> 0x8C1E */
extern int  colony_calc_9318(int, int);              /* 0x181F:0xC36 -> 0x9318 */
extern int  colony_size_cap_2883e(int);              /* 0x191F:0x54C -> 0x2883E [colony_ui*] */
extern uint8_t fort_snapshot_8686(int, int);         /* 0x181F:0xB14 -> 0x8686 */
extern int  resource_query_863e(int);                /* 0x181F:0x9FC -> 0x863E */
extern int  tile_scan_ce0(int row, int col);         /* 0x181F:0xCE0 -> tile query */
extern int  resource_kind_c0e(int handle);           /* 0x181F:0xC0E -> 0x90C8 */
extern int  resource_at(int x, int y);               /* 0x181F:0x718 -> 0x60A0 [map.obj] */
extern void feature_set(int a, int b, int x, int y); /* 0x181F:0x68C -> 0x68C  [map.obj] */
extern void dlg_something_352(int, int, int, int, int); /* 0x181F:0x352 -> 0xBF3C */
extern void popup_set_font_416(void *rec, int, int); /* 0x181F:0x416 -> popup_engine* */
extern int  strings_get(int sel, int handle);        /* 0x181F:0x022 -> 0x2462 [strings.obj] */
extern void popup_helper_4c0(int);                   /* 0x181F:0x4C0 -> 0x518E */
extern void *popup_start_box(void *key, int a, int b);  /* 0x191F:0x182 [popup.obj] */
extern void popup_add_item(void *box, int lo, int hi);  /* 0x191F:0x176 [popup.obj] */
extern int  popup_exec(void *box);                      /* 0x191F:0x16A [popup.obj] */
extern void popup_dispose(void *box);                   /* 0x191F:0x1A8 [engine_overlay*] */

/* the two DGROUP string-constant handles this popup names @asm 0x2D05B/0x2D079 */
extern uint16_t STR_2DFE, STR_2E00;

/* ============================================================================
 * func_02CFD0  (file 0x2CFD0, 274 B) — a two-option colony context popup.
 *   args (stack): +6 key/section, +8 show-rows, +0xA sel-store, +0xC/+0xE x/y,
 *                 +0x10 opt-mode, +0x12 helper-arg.
 *   Returns AL = 1 iff a row was committed (goto 0x2D0B3 path).
 * @asm ENTER 8,0 @0x2CFD0 ; guard byte[0xA897]!=0 @0x2CFE1 ; the two rows come
 *      from DGROUP string handles [0x2DFE]/[0x2E00] @0x2D05B/0x2D079 ; commit
 *      writes the chosen index to byte[0x337] @0x2D0C1.
 * ROLE is a colony two-option popup; WHICH two options is the string decode of
 * [0x2DFE]/[0x2E00] — [TBD], not overclaimed.
 * ==========================================================================*/
int func_02CFD0(int key, int show_rows, int sel_store,
                int cx, int cy, int opt_mode, int helper_arg)
{
    int committed = 0;              /* [bp-8] @0x2CFD4 */
    void *box_lo = 0, *box_hi = 0;  /* [bp-6]/[bp-4] far handle @0x2CFD9 */

    if (g_scan_active_a897 == 0)                 /* @0x2CFE1: byte[0xA897] */
        goto done;

    if (g_opt_890 == 0) {                        /* @0x2CFEB: word[0x890] */
        if (cx == 0) {                           /* @0x2CFF1: default to colony xy */
            cx = g_current_colony_ptr->map_x;    /* @0x2CFF6..0x2CFFE */
            cy = g_current_colony_ptr->map_y;    /* @0x2D001..0x2D004 */
        }
        dlg_something_352(cx, cy, cx, cy, 0);    /* @0x2D015 (5 args) */
    }

    /* set the popup font from the current-colony name field (+2) @0x2D01D */
    popup_set_font_416((char *)g_current_colony_ptr + 2, 0, 0);   /* @0x2D026 */

    g_opt_mode_1f5e = opt_mode;                  /* @0x2D031: [0x1F5E] = arg */
    /* open the box keyed on KEY_GAME (lea bx,[0x87C]) @0x2D034..0x2D03D */
    { void *box = popup_start_box(&g_key_game, key, 0);
      box_lo = box; box_hi = box; }
    if (box_lo == 0) goto done;                  /* @0x2D04A */

    if (show_rows != 0 && g_opt_890 == 0) {      /* @0x2D04C/0x2D052 */
        /* row 0: strings_get(1, STR_2DFE) ; row 1: strings_get(2, STR_2E00) */
        int r0 = strings_get(1, STR_2DFE);       /* @0x2D059..0x2D064 */
        popup_add_item(box_lo, r0, r0);          /* @0x2D06F */
        int r1 = strings_get(2, STR_2E00);       /* @0x2D077..0x2D082 */
        popup_add_item(box_lo, r1, r1);          /* @0x2D08D */
    }
    if (helper_arg > 0)                          /* @0x2D095 */
        popup_helper_4c0(helper_arg);            /* @0x2D09E */

    if (popup_exec(box_lo) == 2) {               /* @0x2D0A9: committed */
        committed = 1;                           /* @0x2D0B3 */
        if (sel_store >= 0)                      /* @0x2D0B8 */
            g_flag_337 = (uint8_t)sel_store;     /* @0x2D0C1: byte[0x337] */
    }

done:
    g_opt_mode_1f5e = 0xFFFF;                     /* @0x2D0C4: restore OPT_MODE */
    if (box_lo != 0)                              /* @0x2D0D0 */
        popup_dispose(box_lo);                    /* @0x2D0D8 */
    return committed & 0xFF;                       /* AL @0x2D0DD */
}

/* ============================================================================
 * func_02D30A  (file 0x2D30A, 188 B) — reveal prime resources in the colony's
 *   5x5 work ring.  Walks the ring; where a cell carries a qualifying resource
 *   (kind 6/7) over a qualifying feature (0x6/0xC), stamps it via feature_set
 *   and the placer func_02EF64, OR-ing the "found" bit into byte[0xA898].
 * @asm double loop row=[bp-0xA]0..4 / col=[bp-8]0..4 @0x2D3B5/0x2D319 ;
 *      world xy = colony.xy + ring - 2 @0x2D34C..0x2D363 ; the call to the
 *      local placer @0x2D3A5 (CALL 0x2EF5F = func_02EF64) OR-ed @0x2D3AB.
 * ==========================================================================*/
void func_02D30A(void)
{
    for (int row = 0; row < 5; row++) {                    /* @0x2D3B5 */
        for (int col = 0; col < 5; col++) {               /* @0x2D319 */
            int h = tile_scan_ce0(row, col);              /* @0x2D328 */
            if (h < 0) continue;                          /* @0x2D331 (cwde/jl) */
            int rk = resource_kind_c0e(h);                /* @0x2D336 */
            if (rk != 7 && rk != 6) continue;             /* @0x2D33E/0x2D343 */

            int wy = g_current_colony_ptr->map_y + row - 2; /* @0x2D34C..0x2D356 */
            int wx = g_current_colony_ptr->map_x + col - 2; /* @0x2D35A..0x2D363 */
            int f = resource_at(wx, wy);                  /* @0x2D367 */
            if (f != 0xC && f != 6) continue;             /* @0x2D36F/0x2D374 */

            feature_set(1, 4, wx, wy);                    /* @0x2D383 */
            /* func_02EF64(placer): args (0,3,x,y,-1, byte[0xA898]!=1?, 0xD75) */
            uint8_t placed = func_02EF64(0, 3, wx, wy, -1,
                                         (g_scan_active_a897 /*byte[0xA898]*/ == 1)
                                             ? 0 : 1,
                                         0xD75);          /* @0x2D38B..0x2D3A8 */
            g_ring_found_a898 |= placed;                  /* @0x2D3AB */
        }
    }
}

/* ============================================================================
 * func_02D606  (file 0x2D606, 81 B) — is-tradeable-surplus-good(good).
 *   Returns 0 for goods consumed internally (food 0, lumber 5, horses 8,
 *   tools 0xE, muskets 0xF) and for ore (6) when no mine is worked; 1 for the
 *   cash crops + manufactures (which become "cargo ready" / can spoil).
 * @asm skip-set compares @0x2D60F..0x2D62B ; ore special: resource_query(3)==0
 *      && word[0x8DE4]==0 && word[0x8DE6]==0 @0x2D633..0x2D64B ; default 1
 *      @0x2D64D.
 * ==========================================================================*/
int func_02D606(int good)
{
    int tradeable = 0;                            /* [bp-2] @0x2D60A */
    if (good == 0 || good == 5 || good == 8 ||
        good == 0xE || good == 0xF)               /* @0x2D60F..0x2D62B */
        goto ret;                                 /* -> 0 */
    if (good == 6) {                              /* @0x2D62D: ore */
        if (resource_query_863e(3) == 0 &&        /* @0x2D633 (0x181F:0x9FC) */
            g_word_8de4 == 0 && g_word_8de6 == 0) /* @0x2D641/0x2D647 */
            goto ret;                             /* no mine -> 0 */
    }
    tradeable = 1;                                /* @0x2D64D */
ret:
    return tradeable;                             /* @0x2D652 */
}

/* ============================================================================
 * func_02EB1C  (file 0x2EB1C, 42 B) — fog snapshot: record what power `p` sees
 *   of colony `ci` — its population and fortification level.
 * @asm pop  = colony[ci].size (byte[bx+0x5D65], bx=ci*0xCA) @0x2EB25 ;
 *      colony[ci].population_on_map[p] = pop (byte[bx+p+0x5E00]) @0x2EB2C ;
 *      colony[ci].fortification_on_map[p] = fort_snapshot(0,ci) (0x181F:0xB14)
 *      stored at byte[bx+p+0x5E04] @0x2EB3F.
 * ==========================================================================*/
void func_02EB1C(int ci, int p)
{
    int base = ci * 0xCA;                                  /* imul @0x2EB20 */
    COL_POP_ON_MAP[base + p] = COL_SIZE[base];             /* @0x2EB25/0x2EB2C */
    COL_FORT_ON_MAP[base + p] = fort_snapshot_8686(0, ci); /* @0x2EB37/0x2EB3F */
}

/* ============================================================================
 * func_02EB46  (file 0x2EB46, 49 B) — is colony `ci` visible to power `p`?
 *   1 if we own it (owner==p), or the visibility override [0x53A2] is set,
 *   or we have already recorded a nonzero pop snapshot for that power; else 0.
 * @asm owner cmp byte[bx+0x5D60]==p @0x2EB52 ; word[0x53A2]!=0 @0x2EB58 ;
 *      pop_on_map[p]!=0 -> 1 else 0 @0x2EB64.
 * ==========================================================================*/
int func_02EB46(int ci, int p)
{
    int base = ci * 0xCA;                                  /* imul @0x2EB4D */
    if (COL_OWNER[base] == (uint8_t)p) return 1;           /* @0x2EB52 */
    if (g_opt_53a2 != 0) return 1;                         /* @0x2EB58 */
    if (COL_POP_ON_MAP[base + p] == 0) return 0;           /* @0x2EB64 -> 0 */
    return 1;                                              /* @0x2EB6B */
}

/* ============================================================================
 * Thin thunk-adapter leaves (get the colony, run two queries, hand a computed
 * value to a cross-page routine).  Faithful but role-opaque without their
 * callers; kept as cited transcripts.
 * ==========================================================================*/

/* func_02EABC (46 B): get_colony_by_slot(a); query A994/BC06; then
 * colony_size_cap_2883e(colony_calc_8c1e(0, b)).  @asm 0x2EABC..0x2EAE9 */
void func_02EABC(int a, int b)
{
    get_colony_by_slot(a);                       /* @0x2EAC3 */
    colony_query_a994();                         /* @0x2EACB */
    colony_query_bc06();                         /* @0x2EAD0 */
    colony_size_cap_2883e(colony_calc_8c1e(0, b)); /* @0x2EADA/0x2EAE3 */
}

/* func_02EAEA (49 B): identical prologue to 02EABC but the final hand-off is
 * to colony_calc_9318 (0x181F:0xC36 -> 0x9318) and it RETURNS [bp-4].
 * @asm 0x2EAEA..0x2EB1A */
int func_02EAEA(int a, int b)
{
    int r = 0;                                   /* [bp-4] */
    get_colony_by_slot(a);                       /* @0x2EAF1 */
    colony_query_a994();                         /* @0x2EAF9 */
    colony_query_bc06();                         /* @0x2EAFE */
    colony_calc_9318(0, colony_calc_8c1e(0, b)); /* @0x2EB08/0x2EB11 */
    return r;                                    /* @0x2EB16 (mov ax,[bp-4]) */
}

/* ============================================================================
 * NOT TRANSCRIBED HERE — cited, deferred (a correct transcript is a separate
 * pass; a guessed body would break the prime directive):
 *
 *   func_02D658  5220 B  @0x2D658  SoL/Tory + schooling + food + per-commodity
 *                                  turn-end status handler.
 *                                  *** DONE in colony/sol_tory.c ***
 *   func_02D0E4   549 B  @0x2D0E4  colony popup sibling of 02CFD0            [TBD]
 *   func_02D3C6   575 B  @0x2D3C6  second ring-scan variant                  [TBD]
 *   func_02EB78   182 B  @0x2EB78  fog/visibility helper                     [TBD]
 *   func_02EC2E   518 B  @0x2EC2E  colony status sub-body                    [TBD]
 *   func_02EE34   304 B  @0x2EE34  colony status sub-body                    [TBD]
 *   func_02EF64   236 B  @0x2EF64  prime-resource marker PLACER (called by
 *                                  func_02D30A @0x2D3A5)                     [TBD]
 *   func_02F052   847 B  @0x2F052  large colony render/production body       [TBD]
 *   func_02F3A2  1869 B  @0x2F3A2  largest page-03 body (render/production)  [TBD]
 * ==========================================================================*/
