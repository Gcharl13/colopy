/* ============================================================================
 * data/production.c — production-chain tables + per-tile yield table (DGROUP)
 * ----------------------------------------------------------------------------
 * Initialized .DATA / .BSS segment content for the colony economy.  The
 * original VICEROY.EXE keeps the yield/price magnitudes as data that is
 * *loaded from NAMES.TXT at game start* (func_0749E0 reads 40+ named
 * sections — see MEMORY.md "NAMES.TXT is the canonical source"); they are
 * NOT hard-coded constants in the EXE image.  Therefore every numeric cell of
 * the yield table below has a BYTE_VERIFIED structure (base address,
 * stride, index formula) is byte-verified, the VALUES are RUNTIME_ONLY (loaded from NAMES.TXT at game start).
 *
 * --- CITE-OR-left unresolved LEDGER --------------------------------------------------
 *  BYTE_VERIFIED structure:
 *    - g_terrain_yield_table  base DGROUP:0x2F7B, stride 16, indexed
 *        [terrain_id*16 + good_id]            @asm 0x9C1E (8A 80 7B 2F)
 *    - k_production_chains: the 5 raw->finished pairs + their arg order
 *                                             @asm 0xA65B..0xA68F
 *    - update_finished_good_from_raw control flow @asm 0x8E84..0x8EFC
 *    - the three band arrays g_band_base/over_low/over_high
 *                                             @asm 0x8E02 / 0x8E46
 *  RUNTIME_ONLY (loaded from NAMES.TXT @CARGO/@JOB/@BUILDING at game start):
 *    - every numeric yield in g_terrain_yield_table
 *    - the building-level threshold table read by 0x8D9C (DGROUP:0x2F4)
 *    - the raw->finished conversion ratios beyond the structural 2/3 step
 * -------------------------------------------------------------------------
 * ============================================================================ */
#include "viceroy.h"

/* ============================================================================
 * The 5 canonical production chains (from colony_turn_update tail @ 0xA65B)
 *
 * @asm 0xA65B: PUSH 0xE; PUSH 6;  CALL 0x8E84   Ore(6)     -> Tools(14)
 * @asm 0xA666: PUSH 0xA; PUSH 2;  CALL 0x8E84   Tobacco(2) -> Cigars(10)
 * @asm 0xA671: PUSH 0xB; PUSH 3;  CALL 0x8E84   Cotton(3)  -> Cloth(11)
 * @asm 0xA67C: PUSH 0xC; PUSH 4;  CALL 0x8E84   Furs(4)    -> Coats(12)
 * @asm 0xA687: PUSH 9;   PUSH 1;  CALL 0x8E84   Sugar(1)   -> Rum(9)
 *
 * (Call order in the binary is Ore,Tobacco,Cotton,Furs,Sugar.  The 'slot'
 *  column is the input commodity id, retained for documentation.)
 * @ref reverse_engineered/code/VICEROY/disasm/func_00A3E1_colony_turn_update.asm
 * ============================================================================ */
const struct production_chain k_production_chains[5] = {
    /* {raw, finished, slot=raw} */
    { COMMODITY_ORE,     COMMODITY_TOOLS,  COMMODITY_ORE     },  /* @asm 0xA65B */
    { COMMODITY_TOBACCO, COMMODITY_CIGARS, COMMODITY_TOBACCO },  /* @asm 0xA666 */
    { COMMODITY_COTTON,  COMMODITY_CLOTH,  COMMODITY_COTTON  },  /* @asm 0xA671 */
    { COMMODITY_FURS,    COMMODITY_COATS,  COMMODITY_FURS    },  /* @asm 0xA67C */
    { COMMODITY_SUGAR,   COMMODITY_RUM,    COMMODITY_SUGAR   },  /* @asm 0xA687 */
};

/* ============================================================================
 * update_finished_good_from_raw — DOCUMENTATION of the conversion logic
 * (the function lives in the load image; reproduced as comment-only here so the
 *  data file documents the conversion rule the tables feed.)
 *
 * @asm 0x008E84..0x008EFC (120 bytes)  ENTER 6 / LEAVE / RETF
 * @ref reverse_engineered/code/VICEROY/disasm/func_008E84_unknown.asm
 *
 * ARG ORDER (byte-verified from call site @asm 0xA65B `PUSH 0xE; PUSH 6`, cdecl):
 *   [bp+6] = raw_id      (= 6 Ore for the Ore->Tools chain)
 *   [bp+8] = finished_id (= 14 Tools)
 * i.e. the C signature is update_finished_good_from_raw(raw_id, finished_id).
 *
 * NOTE: the body reads the FINISHED index's tally and dispatches the RAW index's
 *       band — transcribed exactly as the bytes dictate (the high-level intent
 *       of that pairing is left as an interpretation note, not asserted):
 *
 *   amt   = g_global_amount[finished_id];            // @asm 0x8E88 MOV bx,[bp+8]; (DGROUP:0x8DC8)
 *   conv  = amt;                                      // @asm 0x8E91/0x8E94 → [bp-6],[bp-4]
 *   attr  = lookup_signed_2F4(finished_id);          // @asm 0x8E97 PUSH [bp+8]; CALL 0x8D9C
 *   level = building_present_count(attr);            // @asm 0x8EA1 CALL 0x864E
 *   if (level > 2)                                    // @asm 0x8EA9 CMP ax,2 / JLE
 *       conv = (amt * 2) / 3;                          // @asm 0x8EAE..0x8EB9 (SHL ×2; MOV cx,3; IDIV)
 *   dispatch_via_8e02_with_band(raw_id, conv);        // @asm 0x8EBC PUSH [bp-4]; PUSH [bp+6]; CALL 0x8E46
 *   // then surplus tracking on over_high[raw_id] (DGROUP:0x8E5A + raw_id*2):
 *   if (over_high[raw_id] != 0 && conv != amt) {       // @asm 0x8EC9..0x8ED8
 *       if (over_high[raw_id] == conv) result = amt;   // @asm 0x8EDD..0x8EE3
 *       else result = (over_high[raw_id]*3)/2;         // @asm 0x8EE8..0x8EFA (×3; SAR; /2)
 *   }
 *
 * The "×2/3 when building level > 2" step is structurally byte-verified; the
 * 2/3 and 3/2 ratios are literal in the instruction stream (SHL/×2; MOV cx,3 /
 * IDIV; ×3 / SAR).  Which @BUILDING level maps to the >2 threshold (the
 * production-cap a forge/factory grants) is RUNTIME_ONLY (@BUILDING column from NAMES.TXT).
 * ============================================================================ */

/* ============================================================================
 * g_terrain_yield_table — DGROUP:0x2F7B, the per-(terrain, good) base yield
 *
 * @asm 0x9C1E: MOV al, byte ptr [bx + si + 0x2F7B]   (bytes 8A 80 7B 2F)
 *   si = terrain_id * 16  (@asm 0x9C18 SHL si,4)
 *   bx = good_id          (resolve_tile_good_id return, 0..14)
 *   => cell = g_terrain_yield_table[terrain_id*16 + good_id]
 *
 * Declared in globals.h as g_terrain_yield_table[0x400] (64 terrain ids x 16).
 * VALUES ARE RUNTIME_ONLY (loaded from NAMES.TXT @CARGO at game start) (func_0749E0),
 * NOT hard-coded in VICEROY.EXE.  We zero-initialize so the structure is
 * self-contained; a loader (see load_game_state.py) supplies the real cells.
 *
 * Column meaning (good_id, the NAMES.TXT @CARGO order, confirmed in colony.h
 * stockpile_9a[] doc):
 *   0=Food 1=Sugar 2=Tobacco 3=Cotton 4=Furs 5=Lumber 6=Ore 7=Silver
 *   8=Horses 9=Rum 10=Cigars 11=Cloth 12=Coats 13=TradeGoods 14=Tools
 * Row meaning: terrain_id (base terrain, from LCALL 0x3E4:0xE / 0x3E4:0x3A).
 * ============================================================================ */
uint8_t g_terrain_yield_table[0x400] = {
    /* RUNTIME_ONLY (NAMES.TXT @CARGO: 64 terrains x 16 goods; data-driven, not in EXE image.
     * Zero placeholder at compile time.) */
    0
};

/* ============================================================================
 * Per-commodity band/market arrays (the "amount, headroom-above, headroom-below"
 * triple updated by set_commodity_band_at_index @ 0x8E02).
 *
 * @asm 0x8E0A  g_band_base[idx]   (primary amount)
 * @asm 0x8E32  g_over_low[idx]    (max(0, primary - midpoint))
 * @asm 0x8E5A  g_over_high[idx]   (max(0, primary - delta - midpoint))
 * @asm 0x8DC8  g_global_amount[idx] (this-turn produced total; read by 0x8E46/0x8E84)
 * All zero-initialized at game start (BSS); filled per-turn by the economy update.
 * ============================================================================ */
uint16_t g_global_amount[20]  = { 0 };   /* DGROUP:0x8DC8 */
uint16_t g_band_base[20]      = { 0 };   /* DGROUP:0x8E0A */
uint16_t g_over_low[20]       = { 0 };   /* DGROUP:0x8E32 */
uint16_t g_over_high[20]      = { 0 };   /* DGROUP:0x8E5A (over_high[6]=0x8E66 = Ore->Tools damper) */

/* ============================================================================
 * Pair tables at DGROUP:0xC8 / 0xDE (20 entries) — screen-coord -> tile index.
 *
 * @ref find_pair_in_table_C8_DE @ 0x8892 — scans these parallel byte tables.
 * The initial values are written by the overlay-resident colony-init code and
 * are NOT in the load image; RUNTIME_ONLY (set on overlay-decode pass). */
uint8_t g_pair_key1[20] = { /* RUNTIME_ONLY: set by overlay colony-init */ 0 };  /* DGROUP:0xC8 */
uint8_t g_pair_key2[20] = { /* RUNTIME_ONLY: set by overlay colony-init */ 0 };  /* DGROUP:0xDE */

/* ============================================================================
 * Colony-turn scalar auxiliaries (BSS; addresses cited).
 * ============================================================================ */
uint16_t g_8DC4 = 0;   /* DGROUP:0x8DC4 */
uint16_t g_8D4A = 0;   /* DGROUP:0x8D4A */
uint16_t g_8DD8 = 0;   /* DGROUP:0x8DD8  work-points cumulative (+= pop*2 @asm 0xA632) */
uint16_t g_8DE6 = 0;   /* DGROUP:0x8DE6  Tools final band arg   (@asm 0xA692) */
uint16_t g_8DE8 = 0;   /* DGROUP:0x8DE8  Lumber band arg        (@asm 0xA64E) */
uint16_t g_8DEA = 0;   /* DGROUP:0x8DEA  tory counter           (@asm 0xA4B0) */
uint16_t g_8DEC = 0;   /* DGROUP:0x8DEC  liberty-bell counter   (@asm 0xA4DB) */
uint16_t g_8E6A = 0;   /* DGROUP:0x8E6A  (pop*2 - rebellion_quota) @asm 0xA639 */

/* Colony center pre-pass results (set by compute_colony_center_yields). */
uint8_t  g_table_A891 = 0;            /* DGROUP:0xA891 food yield class */
uint8_t  g_table_A892 = 0;            /* DGROUP:0xA892 misc adjustment */
int8_t   g_table_A893 = (int8_t)0xFF; /* DGROUP:0xA893 best non-food commodity (0xFF=none) */
uint8_t  g_table_A894 = 0;            /* DGROUP:0xA894 best non-food amount */
uint8_t  g_table_A895 = 0;            /* DGROUP:0xA895 specialist tally */
uint8_t  g_table_A896 = 0;            /* DGROUP:0xA896 second tally (good 6/7/12 side-count @asm 0x9E21..) */

/* ============================================================================
 * Iterator / render auxiliaries — definitions kept here (their sole home in
 * this tree) so other units (boot/entry.c, iolib/file.c, runtime/cstart.c,
 * colony/assignment.c) link.  Addresses cited from globals.h; all BSS/zero.
 * ============================================================================ */
uint16_t g_iter_handle    = 0;   /* DGROUP:0x8D78 */
uint16_t g_iter_aux_a     = 0;   /* DGROUP:0x8D72 */
uint16_t g_iter_aux_b     = 0;   /* DGROUP:0x8D74 */
uint16_t g_iter_aux_c     = 0;   /* DGROUP:0x8D76 */
uint16_t g_iter_aux_d     = 0;   /* DGROUP:0x8D7A */
uint16_t g_render_aux_a   = 0;   /* DGROUP:0x8D4C */
void far *g_render_aux_b_ptr = 0;/* DGROUP:0x8D4E */
uint16_t g_pop_or_year    = 0;   /* DGROUP:0x8DB8 */
uint8_t  g_render_flag_34D = 0;  /* DGROUP:0x34D */
uint16_t g_field_917A     = 0;   /* DGROUP:0x917A */
uint32_t g_long_8D80      = 0;   /* DGROUP:0x8D80 */

/* Tutorial flags */
uint16_t g_tutorial_flag_35C = 0; /* DGROUP:0x35C */
uint16_t g_tutorial_flag_348 = 0; /* DGROUP:0x348 */

/* Map dimensions — real home is BSS at DGROUP:0x853A/0x853C; written at map load.
 * (Prior fixed defaults 56/70 were unverified guesses and have been removed.) */
uint16_t g_map_width  = 0;        /* DGROUP:0x853A  RUNTIME_ONLY (set at map load) */
uint16_t g_map_height = 0;        /* DGROUP:0x853C  RUNTIME_ONLY (set at map load) */

/* Game-progress cluster (addresses per globals.h). */
uint16_t g_progress_4_5394 = 0;   /* DGROUP:0x5394 */
uint8_t  g_difficulty_53A6 = 0;   /* DGROUP:0x53A6  difficulty 0..4 (was g_progress_5_53A6 "era counter" — RULINGS 2026-05-30) */
uint16_t g_progress_5398   = 0;   /* DGROUP:0x5398 */
uint16_t g_progress_5392   = 0;   /* DGROUP:0x5392 */
uint16_t g_progress_5396   = 0;   /* DGROUP:0x5396 */
/* 0x539E (colony count) / 0x539C (unit count): now DGROUP-resident aliases
 * g_colony_count_539E / g_unit_count_539C in globals.h (no standalone storage —
 * they live in g_dgroup[] like every other DS byte). CONSOLIDATED 2026-06-09. */
uint16_t g_progress_5382   = 0;   /* DGROUP:0x5382 */

/* C runtime / boot globals — definitions kept here for link completeness. */
uint16_t g_NFILE_QQ           = 0; /* DGROUP:0x27B9  RUNTIME_ONLY (set by C runtime cstart) */
uint16_t g_argc               = 0; /* DGROUP:0x27CF */
uint16_t g_argv               = 0; /* DGROUP:0x27D1 */
uint16_t g_envp               = 0; /* DGROUP:0x27D3 */
uint16_t g_program_ds         = 0; /* DGROUP:0x27B2 */
uint16_t g_default_text_mode_2B01 = 0; /* DGROUP:0x2B01 */
uint16_t g_iob_dispatch_2B16  = 0; /* DGROUP:0x2B16 */
void   (*g_iob_dispatch_2B18)(void) = 0; /* DGROUP:0x2B18 */
uint16_t g_errno_27AC         = 0; /* DGROUP:0x27AC */
uint16_t g_output_count_2D52  = 0; /* DGROUP:0x2D52 */

uint8_t  g_exec_param_26AB[8] = { 0 }; /* DGROUP:0x26AB */
uint16_t g_saved_ss_26A3      = 0; /* DGROUP:0x26A3 */
uint16_t g_saved_sp_26A5      = 0; /* DGROUP:0x26A5 */
uint16_t g_load_seg_26A7      = 0; /* DGROUP:0x26A7 */

uint16_t g_overlay_layout[0xAA] = { 0 }; /* DGROUP:0x3995  layout written by system_init */
