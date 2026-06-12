/* ============================================================================
 * congress_screen.c -- THE CONTINENTAL CONGRESS SCREEN (Founding-Father hall:
 *                      CCBKGD backdrop + CC-NN.SS portrait plates + the
 *                      new-father reveal) and the modern bridges that wire the
 *                      whole FF chain.                      ROUTE_B_PLAN 3.2.
 * ----------------------------------------------------------------------------
 * THE ORIGINAL CHAIN (every hop disassembled; whois-verified 2026-06-12):
 *
 *   ENTRY 1 — acquisition (human power):  effects.c ff_acquire_dispatch
 *     (func_03BC42) @asm 0x3BD16 push ff_id; push power; call cs:0x1077
 *     -> ljmp 0x191F:0xF74 -> page06+0x24A = file 0x3BB4A.
 *   ENTRY 2 — F3 Continental-Congress report tail: func_037A10 @asm 0x38060
 *     cmp [0x346],0 / 0x38067 cmp [0x9E38],0 / 0x3806E push -1; push player;
 *     0x38073 lcall 0x191F:0xF74  (hall view, slot=-1, no reveal).
 *
 *   COMPOSER func_03BB4A cc_screen_background(power, slot)  @0x3BB4A
 *     (ENTER 0x300; spot-check C8 00 03 00; RETF @0x3BC40):
 *       [0x372]=0                                          @asm 0x3BB56
 *       load "CCBKGD" (dg 0x1253, file 0x1EBF3) into the dialog/clip rect
 *         [0x839E..0x83A4] via 0x181F:0x44E (func_076B9E: name + ".PIK"
 *         fmt dg 0x2402, open "rb" dg 0x2406); NONZERO -> skip draw
 *                                                          @asm 0x3BB6D/0x3BB75
 *       clip 0x181F:0x3B6 ; backdrop-to-buffer 0x181F:0x3F4 @asm 0x3BB7C/0x3BB87
 *       fill rect [0x2DA8..0x2DAE] h=0xC8 w=0x140 (0x181F:0x444) @asm 0x3BBB5
 *       if (slot>=0) ff_set_owned_bit(power, slot, 0)  -- HIDE the new FF
 *         (cs:0x1095 -> 0x1A1F:0x38 -> func_03B900)        @asm 0x3BBC0..0x3BBC9
 *       ff_portraits_draw(power)  (cs:0x1090 -> 0x1A1F:0x2A -> func_03BAA6)
 *                                                          @asm 0x3BBD3
 *       present full frame 0x181F:0xE2 (0,0x140,0xC8,0,0)  @asm 0x3BBE6
 *       if (slot>=0) { ff_set_owned_bit(power, slot, 1)    @asm 0x3BBF1..0x3BBFA
 *                      ff_portraits_draw(power)            @asm 0x3BC04
 *                      palette step 0x181F:0x3EA(8) }      @asm 0x3BC0C
 *       restore 0x181F:0x3C0 ; clip ; blit to VGA 0xA000:0xFC00 (0x181F:0x3F4)
 *                                                          @asm 0x3BC14..0x3BC24
 *       [0x372] = ([0x5383] cheat bit0x01 of the HIGH byte) @asm 0x3BC29..0x3BC37
 *       0x191F:0xAAC (func_076594, asset-arena epilogue)    @asm 0x3BC3A
 *
 *   PORTRAITS func_03BAA6 ff_portraits_draw(power)  @0x3BAA6 (ENTER 0x58):
 *     for i in 0..24:                                       @asm 0x3BB3E cmp 0x19
 *       id = byte[0x123A + i]   -- the 25-byte PLATE-ORDER table (an exact
 *            permutation of 0..24, dg 0x123A = file 0x1EBDA; runtime-loaded
 *            with the DGROUP image)                         @asm 0x3BAB8
 *       if (!ff_owned) continue   (push id; push power; 0x181F:0x7B4
 *            -> func_00BC10(power, ff))                     @asm 0x3BAC1..0x3BACF
 *       name = "CC-"          (dg 0x1234, file 0x1EBD4)     @asm 0x3BAD1 strcpy 0xD1D:0x7E4
 *       if (id < 10) name += "0"  (dg 0x1238)               @asm 0x3BAE0/0x3BAE6
 *       name += itoa(id)         (0x181F:0x182)             @asm 0x3BAF5..0x3BAFD
 *       arena reset 0x191F:0xFDE (leaf @0x764D0: rewind [0xA616] to [0x23C6],
 *            cap 0x3880)                                    @asm 0x3BB05
 *       ent = load 0x191F:0xFD0 (BX=&name, AX=0 -> func_076524 -> 0x1A1F:0x372
 *            func_076642 load_game_record: appends ".SS" when no '.' --
 *            @asm 0x76685/0x76698, default ext dg 0x23E6)   @asm 0x3BB0F
 *       if (ent) draw 0x181F:0x2F8 (func_00E964) with stack (0x64, es:[ent+0x48]),
 *            DX=es:[ent+0x46], AX=1, BX=&rect[0x2DA8] -- THE PLATE POSITION IS
 *            EMBEDDED IN THE CC-NN.SS FILE (element x/y words; ss.c reads the
 *            same element row as frames[].x/y)              @asm 0x3BB1E..0x3BB36
 *
 * MODERN MAPPING (this file):
 *   - backdrop: CCBKGD.PIK via pik_load (the loader's ".PIK" append is the
 *     byte-cited fmt dg 0x2402); full-screen per the present rect (0,0,320,200).
 *     The original composes into the popup/clip rect [0x839E..]; that rect is
 *     the runtime screen-bounds clip in every captured session
 *     (docs/DIALOG_GEOMETRY.md "Screen-bounds reminder").
 *   - portraits: CC-<id, 2-digit>.SS via ss_load; drawn at frames[0].x/y =
 *     the embedded element coords the original draw uses (es:[ent+0x46/0x48]).
 *   - reveal: the byte-cited ff_set_owned_bit(0)/draw/present, set(1)/draw
 *     two-pass sequence; the palette step 0x181F:0x3EA(8) (func_005160) is
 *     represented by a second present (RESIDUE: the fade leaf is unported).
 *
 * Plus the STRONG OVERRIDES that wire congress.c/effects.c to the real ported
 * bodies (the weak link-floor stubs yield; arg-order bridges are byte-cited
 * at each function).
 * ============================================================================ */
#ifdef _VICEROY_MODERN

#include <stdio.h>
#include <string.h>

#include "viceroy_types.h"
#include "dgroup.h"
#include "platform.h"

/* shell / platform glue (same externs menu_runner.c uses) */
extern const char *viceroy_data_dir(void);
extern int         viceroy_interactive(void);
extern void        vid_present(void);
extern uint8_t    *vid_framebuffer(void);
extern void        vid_set_palette(const uint8_t *rgb768);

/* ported bodies this file bridges to */
extern int  func_00BC10_ff_owned(uint16_t power, uint16_t ff);     /* 0x181F:0x7B4 resident */
extern int  func_03C282_ff_bell_cost_curve(uint16_t power);        /* 0x191F:0xF66 page06 */
extern int  func_06AE08_single_label_value_dialog(uint16_t arg0);  /* 0x1A1F:0x62 (FF banner) */
extern int  func_005108_op_sz_51(uint16_t arg0);                   /* 0x181F:0x4AC resident */
extern int  func_06C254_dialog_make_from_str(uint16_t a0, uint16_t a1, uint16_t a2); /* 0x191F:0xAC8 */
extern int  func_06C27C_dialog_slot_set_pair(uint16_t slot, uint16_t v0, uint16_t v1); /* 0x181F:0x9AE */
extern void foreign_intervention(void);                            /* 0x191F:0x348 = func_03D948 (king/intervention.c) */
extern void market_set_active(int power);                          /* 0x181F:0x582 = func_030550 (market/pricing.c) */
extern int  menu_run_key(const char *key, int preselect);          /* ui/menu_runner.c (3.1 engine) */
extern int  menu_run_boxed(uint16_t key_off);                      /* ui/menu_runner.c */

/* founding_fathers/ bodies */
extern void ff_set_owned_bit(int power, int ff_id, int set);       /* recruit.c func_03B900 */
extern int  ff_era_band(void);                                     /* recruit.c func_03B95A */
extern int  ff_count_offerable_in_cat(int power, int cat);         /* recruit.c func_03B980 */
extern int  ff_best_offer_category(int power);                     /* recruit.c func_03BA5A */
extern void ff_acquire_dispatch(int power, int ff_id);             /* effects.c func_03BC42 */
extern void ff_congress_screen(int power);                         /* congress.c func_03BFD2 */

/* ============================================================================
 * congress_portraits_draw -- modern port of func_03BAA6 @0x3BAA6 (page 0x06)
 * ----------------------------------------------------------------------------
 * Draw every Founding Father the power owns, as portrait plates in the hall,
 * in the byte-cited plate order, each at the position embedded in its own
 * CC-NN.SS file.  (Layout is 100% data-driven — no invented coordinates.)
 * ============================================================================ */
void congress_portraits_draw(int power)
{
    char name[0x52];                /* @asm rowbuf [bp-0x54] */
    char path[512];
    int  i;

    for (i = 0; i < 0x19; i++) {                       /* @asm 0x3BB3E cmp [bp-0x58],0x19 */
        int id = (int)DG8(0x123A + (unsigned)i);       /* @asm 0x3BAB8 mov al,[bx+0x123a] (plate order) */

        /* @asm 0x3BAC1 push id; 0x3BAC2 push power; lcall 0x181F:0x7B4
         * (real callee order: func_00BC10(power, ff)) */
        if (func_00BC10_ff_owned((uint16_t)power, (uint16_t)id) == 0)
            continue;                                  /* @asm 0x3BACF je next */

        /* name = "CC-" [+ "0"] + itoa(id)  (dg 0x1234 "CC-", dg 0x1238 "0";
         * file names are game-data identifiers, literal per the established
         * asset-name convention) */
        strcpy(name, "CC-");                           /* @asm 0x3BAD1/0x3BAD8 strcpy(buf, dg 0x1234) */
        if (id < 0x0A)                                 /* @asm 0x3BAE0 cmp [bp-0x56],0xA */
            strcat(name, "0");                         /* @asm 0x3BAE6 strcat(buf, dg 0x1238) */
        {
            char num[8];
            snprintf(num, sizeof num, "%d", id);       /* @asm 0x3BAF5..0x3BAFD 0x181F:0x182 append-int */
            strcat(name, num);
        }

        /* @asm 0x3BB05 arena reset (0x191F:0xFDE); 0x3BB0F load by name
         * (0x191F:0xFD0 -> func_076642: appends ".SS" when the name has no
         * '.' — @asm 0x76685 strchr / 0x76698 append dg 0x23E6 ".SS"). */
        {
            ss_sheet_t sheet;
            snprintf(path, sizeof path, "%s/%s.SS", viceroy_data_dir(), name);
            if (ss_load(path, &sheet) == 0) {
                if (sheet.nframes > 0) {
                    /* @asm 0x3BB1E..0x3BB36 draw 0x181F:0x2F8 at the coords
                     * embedded in the loaded record (es:[ent+0x46]=x,
                     * es:[ent+0x48]=y) = the .SS element x/y words that
                     * ss.c surfaces as frames[].x/.y. */
                    ss_blit(&sheet, 0, sheet.frames[0].x, sheet.frames[0].y);
                }
                ss_free(&sheet);
            }
            /* absent asset (no game data): plate is skipped — the hall
             * backdrop alone is shown, matching the load-failure branch. */
        }
    }
}

/* ============================================================================
 * congress_screen_render -- modern port of func_03BB4A @0x3BB4A (page 0x06)
 * ----------------------------------------------------------------------------
 *   power  : recruiting power (whose owned set is shown)
 *   new_ff : the just-elected FF id, or -1 = plain hall view (the F3 report
 *            tail and any pre-reveal view pass -1 @asm 0x3806E push -1)
 * ============================================================================ */
void congress_screen_render(int power, int new_ff)
{
    char path[512];
    pik_image_t bg;
    int have_bg = 0;

    DG16(0x0372) = 0;                                  /* @asm 0x3BB56 mov [0x372],ax(=0) */

    /* @asm 0x3BB5A..0x3BB6D push rect [0x83A4/0x83A2/0x83A0/0x839E] +
     * "CCBKGD" (dg 0x1253) + 0; lcall 0x181F:0x44E.  Loader func_076B9E
     * formats "<name>.PIK" (fmt dg 0x2402) and opens "rb" (dg 0x2406).
     * NONZERO return -> skip the draw passes (@asm 0x3BB75/0x3BB79). */
    snprintf(path, sizeof path, "%s/CCBKGD.PIK", viceroy_data_dir());
    if (pik_load(path, &bg) == 0) {
        have_bg = 1;
        if (bg.has_pal)
            vid_set_palette(bg.pal);
        {
            uint8_t *fb = vid_framebuffer();
            int w = bg.w < VID_W ? bg.w : VID_W;
            int h = bg.h < VID_H ? bg.h : VID_H;
            int y;
            /* @asm 0x3BB7C clip (0x181F:0x3B6); 0x3BB87 backdrop->buffer
             * (0x181F:0x3F4); 0x3BB8C..0x3BBB5 fill content rect
             * [0x2DA8..0x2DAE] h=0xC8 w=0x140 (0x181F:0x444) — the modern
             * equivalent composes the backdrop over the full 320x200 frame
             * (the present @0x3BBE6 is full-screen: 0,0x140,0xC8). */
            for (y = 0; y < h; y++)
                memcpy(fb + y * VID_W, bg.pixels + y * bg.w, (size_t)w);
        }

        if (new_ff >= 0) {                             /* @asm 0x3BBBA cmp [bp+8],0 ; jl */
            /* HIDE the new father for the first pass (the reveal trick):
             * @asm 0x3BBC0 push 0; push slot; push power; call cs:0x1095
             * -> func_03B900 ff_set_owned_bit(power, slot, 0). */
            ff_set_owned_bit(power, new_ff, 0);
        }
        congress_portraits_draw(power);                /* @asm 0x3BBD3 call cs:0x1090 -> func_03BAA6 */
        vid_present();                                 /* @asm 0x3BBE6 0x181F:0xE2 (0,0x140,0xC8,0,0) */

        if (new_ff >= 0) {                             /* @asm 0x3BBEB cmp [bp+8],0 ; jl 0x3BC14 */
            ff_set_owned_bit(power, new_ff, 1);        /* @asm 0x3BBF1..0x3BBFA cs:0x1095 (power,slot,1) */
            congress_portraits_draw(power);            /* @asm 0x3BC04 cs:0x1090 */
            /* @asm 0x3BC0C push 8; lcall 0x181F:0x3EA (func_005160) — the
             * palette/fade step of the reveal.  RESIDUE: the fade leaf is
             * not ported; the second present below shows the revealed hall. */
            vid_present();
        }

        /* @asm 0x3BC14 restore (0x181F:0x3C0); 0x3BC19 clip; 0x3BC1E..0x3BC24
         * copy composed frame to the VGA segment 0xA000 (0x181F:0x3F4) —
         * covered by vid_present() in the modern frame model. */
        pik_free(&bg);
    }
    /* epilogue: @asm 0x3BC29 mov ah,[0x5383]; and ax,0x100; -> bool ->
     * [0x372]  (cheat-flag bit of the HIGH byte = [0x5383] bit0). */
    DG16(0x0372) = (uint16_t)((DG8(0x5383) & 0x01) ? 1 : 0);
    /* @asm 0x3BC3A lcall 0x191F:0xAAC (func_076594 asset-arena epilogue) —
     * arena management is internal to the modern loaders. */
    (void)have_bg;
}

/* ============================================================================
 * STRONG OVERRIDES — wire the FF chain's extern names (weak in
 * tools/generated/linkfloor_stubs.c) to the real ported bodies.
 * Arg-order bridges are byte-cited per function (caller push order vs the
 * callee's [bp+6]/[bp+8] reads).
 * ============================================================================ */

/* 0x181F:0x582 -> func_030550 market_set_active: stages [0x9E12]+[0x84FC].
 * Both congress.c (@asm 0x3C328/0x3BFE2) and effects.c (@asm 0x3BC50) call it
 * before touching the active PowerRecord. */
void ff_announce(int power) { market_set_active(power); }

/* 0x181F:0x7B4 -> func_00BC10 (resident).  REAL arg order (power, ff):
 * callers push (ff, power) — e.g. @asm 0x3C091 push ff; 0x3C094 push power —
 * so the C decl ff_owned(ff_id, power) maps [bp+6]=power, [bp+8]=ff. */
int ff_owned(int ff_id, int power)
{
    return func_00BC10_ff_owned((uint16_t)power, (uint16_t)ff_id);
}

/* cs:0x1081 -> ljmp 0x1A1F:0x0000 -> func_03BFD2 ff_congress_screen — the
 * "make the next FF available" call IS the election body (whois 2026-06-12). */
void ff_become_available(int power) { ff_congress_screen(power); }

/* cs:0x108B -> ljmp 0x1A1F:0x001C -> func_03BA5A ff_best_offer_category. */
int ff_present_primer(int power) { return ff_best_offer_category(power); }

/* cs:0x109A -> ljmp 0x1A1F:0x0046 -> func_03B95A ff_era_band (reads only
 * [0x538A]; the pushed power arg is unused by the body @asm 0x3B95A..0x3B97F). */
int ff_category_band(int power) { (void)power; return ff_era_band(); }

/* cs:0x109F -> ljmp 0x1A1F:0x0054 -> func_03B980.  REAL arg order
 * (power, cat): @asm 0x3C078 push cat; 0x3C07B push power. */
int ff_cat_candidate(int cat, int pw) { return ff_count_offerable_in_cat(pw, cat); }

/* cs:0x107C -> ljmp 0x191F:0xFEC -> func_03BC42 ff_acquire_dispatch.
 * @asm 0x3C3DC push 0; push ff; push power -> callee (power, ff); the
 * trailing 0 is an unused third word. */
void ff_log_notify(int idx, int ff, int pw)
{
    (void)idx;
    ff_acquire_dispatch(pw, ff);
}

/* cs:0x1072 -> ljmp 0x191F:0xF66 -> func_03C282 (the bell-cost curve,
 * byte-ported in overlay_038A50_03C5A8.c). */
int ff_bells_required(int power) { return func_03C282_ff_bell_cost_curve((uint16_t)power); }

/* cs:0x1095 -> ljmp 0x1A1F:0x0038 -> func_03B900 ff_set_owned_bit.
 * effects.c pushes (1, ff, power) @asm 0x3BC5E..0x3BC67 -> callee
 * (power, ff, on); its C decl cs_1095(one, ff_id, power) keeps the C-side
 * value pairing — forward accordingly. */
void cs_1095(int one, int ff_id, int power) { ff_set_owned_bit(power, ff_id, one); }

/* cs:0x1077 -> ljmp 0x191F:0xF74 -> func_03BB4A cc_screen_background.
 * effects.c pushes (ff_id, power) @asm 0x3BD16..0x3BD1D -> callee
 * (power, slot=ff_id); its C decl cs_1077(ff_id, power) — forward swapped. */
void cs_1077(int ff_id, int power) { congress_screen_render(power, ff_id); }

/* 0x181F:0x998 -> func_06F51A menu_lookup_run (the 3.1 shim): BX="GAME"
 * base, AX=key, DX=preselect.  effects.c passes (0x87C, 0x125A "FREEDOM", 0)
 * @asm 0x3BD07..0x3BD11 — the boxed FF-acquire popup. */
void ff_portrait_dialog(void *a, void *b, int c)
{
    (void)a; (void)c;                       /* base "GAME" + DX=0 are implied by the runner */
    (void)menu_run_boxed((uint16_t)(uintptr_t)b);
}

/* 0x181F:0x652 -> func_06F5F2: [0x1F5E]=flag([bp+8]); AX=key([bp+6]);
 * BX=0x87C; DX=0 -> the 3.1 shim.  (disassembled @0x6F5F2..0x6F609) */
void ui_key_print(int key, int flag)
{
    DG16(0x1F5E) = (uint16_t)flag;          /* @asm 0x6F5F8 mov [0x1f5e],ax */
    (void)menu_run_boxed((uint16_t)key);    /* @asm 0x6F5FB..0x6F605 -> 0x181F:0x998 */
}

/* 0x181F:0x4AC -> func_005108 (resident view/track stage; ported). */
void ff_msg_open(int arg) { (void)func_005108_op_sz_51((uint16_t)arg); }

/* 0x1A1F:0x62 -> func_06AE08 single_label_value_dialog: the FF announcement
 * banner (headline [0x2E92] + the FF's name from [0x9652+ff*6]; pushes
 * "FATHER" dg 0x1EFA @0x6AEC4). */
void ff_pre_b(int ff_id) { (void)func_06AE08_single_label_value_dialog((uint16_t)ff_id); }

/* 0x191F:0x348 -> func_03D948 = the @FRIEND "foreign general/admiral joins"
 * handler (king/intervention.c) — POST-independence bell payoff
 * (@asm 0x3C3CD in ff_bells_tick). */
void cong_screen_a(void) { foreign_intervention(); }

/* 0x191F:0xAC8 -> func_06C254 dialog_make_from_str.  congress.c pushes
 * ([0x53D4], 1, 0) @asm 0x3C36C..0x3C374 -> callee args (0, 1, [0x53D4]);
 * its C decl cong_anim(a=g_53d4, b=1, c=0) — forward reversed. */
void cong_anim(int a, int b, int c)
{
    (void)func_06C254_dialog_make_from_str((uint16_t)c, (uint16_t)b, (uint16_t)a);
}

/* 0x181F:0x9AE -> func_06C27C dialog_slot_set_pair(slot, lo, hi): stages the
 * bells-required NUMBER into message slot z for the AMBUSHHINT/CONSIDER text
 * (@asm 0x3C384 cdq; push dx; push ax; push 0). */
void ff_notify_sound(long n, int z)
{
    (void)func_06C27C_dialog_slot_set_pair((uint16_t)z,
                                           (uint16_t)(n & 0xFFFF),
                                           (uint16_t)((n >> 16) & 0xFFFF));
}

#endif /* _VICEROY_MODERN */
