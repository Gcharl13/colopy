/* ============================================================================
 *        >>> NATIVE-SETTLEMENT CONFRONTATION DISPATCHER — func_04B308 <<<
 * ----------------------------------------------------------------------------
 * Runs when a unit moves onto a native-settlement tile (the 0x1A1F:0x16C
 * cross-page check in the per-unit confrontation evaluator, unit_orders.c
 * @asm 0x03EE29).  Resolves the settlement + tribe, plays the contact music
 * cue for human powers, applies the ship "they will not see us" / "we are not
 * welcome" gates, then either
 *   - FORCES an action for AI-controlled powers (switch on unit type), or
 *   - builds the interactive option panel for the human player,
 * and dispatches the chosen action to the per-action handler.
 *
 * @asm_function  func_04B308   (file 0x04B308..0x04BA00 incl. tail, 1786 bytes,
 *                               prologue `ENTER 0xBA,0`, RETF)
 * @reach         page 0x12 + 0x4528 -> 0x1A1F:0x016C (Type-A thunk)
 * @asm_disasm    re_work/sheets/func_04B308_*.txt (decode sheets)
 *
 * JUMP TABLE 1 (@asm 0x4B54D `jmp cs:[bx+0x4772]`, 12 entries inline at file
 * 0x4B552, seg base 0x46DE0 — the AI forced-action switch on unit TYPE-1):
 *   type 1,4,11 -> 0x4B4DE   (colonist family: live-among-natives, choice 9)
 *   type 2,6..10-> 0x4B50A   (default: cargo trade gate, choice 5)
 *   type 3      -> 0x4B43E   (missionary: incite/establish/denounce)
 *   type 5      -> 0x4B502   (scout: speak with chief, choice 6)
 *   type 12     -> 0x4B4D6   (wagon train: haggle, choice 1)
 *   default(>12)-> 0x4B50A
 *
 * JUMP TABLE 2 (@asm 0x4B9BB `jmp cs:[bx+0x4be0]`, 9 entries inline at file
 * 0x4B9C0 — the ACTION dispatch on choice-1):
 *   1->0x4B8F6 haggle        2->0x4B90C attack-reward   3->0x4B92E mission
 *   4->0x4B946 heresy        5->0x4B978 advisor         6->0x4B966 chief
 *   7->0x4B956 incite-war    8->0x4B98A goods-trade     9->0x4B99A relations
 *
 * ACTION HANDLERS (all near-call trampolines at 0x4BA07..0x4BA48 -> 0x1A1F):
 *   0x4BA48 -> 1A1F:0x44C = func_049600 native_haggle_resolve        [PORTED]
 *   0x4BA2A -> 1A1F:0x3F8 = func_04A37C native_attack_reward_roll    [PORTED]
 *   0x4BA25 -> 1A1F:0x3EC = func_048A3A native_mission_established   [PORTED]
 *   0x4BA07 -> 1A1F:0x3A4 = func_048CA4 native_mission_heresy        [PORTED]
 *   0x4BA3E -> 1A1F:0x428 = func_04A426 colony_commodity_advisor     [PORTED]
 *   0x4BA39 -> 1A1F:0x41C = func_04A7CA speak-with-chief / CHIEFKILL [PARTIAL:
 *              only the gold block is ported (native_village_raze.c); the full
 *              entry keeps a weak hit-counting default below]
 *   0x4BA16 -> 1A1F:0x3C8 = func_04AF5E scout_incite_tribe_to_war    [PORTED]
 *   0x4BA2F -> 1A1F:0x404 = func_04AC00 native_village_trade         [PORTED]
 *
 * RETURN: 2 if the unit roster changed (unit count moved) or the action
 * consumed the unit; 1 = end the unit's turn (0x181F:0x934 issued here);
 * 0 = continue (only the choice-9 live-among-natives relations path).
 * @status BYTE_VERIFIED (both jump tables byte-extracted; every branch cited)
 * ============================================================================ */
#include "viceroy_types.h"
#include "dgroup.h"

/* resident / load-image leaves (all PORTED) */
extern int  func_046004_settlement_at_tile(uint16_t x, uint16_t y); /* 181F:09F0 */
extern void func_0081F2_logic_sz_34(uint16_t idx);                  /* 181F:0A4C settlement_make_current */
extern int  func_0082A0_logic_sz_18(uint16_t row, uint16_t col);    /* 181F:030C alarm/relation table */
extern int  func_005108_op_sz_51(uint16_t cue);                     /* 181F:04AC music cue */
extern int  func_007F34_logic_sz_27(uint16_t a, uint16_t b);        /* 181F:0A38 war/treaty flags */
extern int  func_008110_logic_sz_14(uint16_t tribe);                /* 181F:09A4 tribe name id */
extern int  func_06C23C_dialog_make_from_int(uint16_t slot, uint16_t val); /* 181F:0438 */
extern int  func_00C322_rtl_sz_63(uint16_t lo, uint16_t hi);        /* 181F:04D4 random_int */
extern int  func_005E90_op_sz_64(uint16_t x, uint16_t y);           /* 181F:0722 region at */
extern int  func_008BB2_logic_sz_20(uint16_t unit);                 /* 181F:0B78 in-settlement probe */
extern int  func_00543C_op_sz_131(uint16_t arg);                    /* 181F:0524 */
extern int  func_0080C8_logic_sz_14(uint16_t power);                /* 181F:0A1A power name id */
extern int  func_007F96_op_sz_105(uint16_t a, uint16_t b, uint16_t mask); /* 181F:0A06 relation set-bits */
extern int  func_067700_compose_active_tile(uint16_t active);       /* 181F:0E1C */
extern void func_007BCE_logic_sz_25(uint16_t unit);                 /* 181F:0934 end-turn */

/* panel / text engine (PORTED shells) */
extern int  func_06F0F4_text_template_run(void);                    /* 191F:0182 bx=0x87C ax=buf dx=0 */
extern int  func_06C850_panel_append_button(uint16_t panel_lo, uint16_t panel_hi,
                                            uint16_t label_lo, uint16_t label_hi,
                                            uint16_t value);        /* 191F:0176 */
extern int  func_06E3D0_panel_run_modal(uint16_t panel_off, uint16_t panel_seg); /* 191F:016A */
extern int  func_0789FA_free_dos_block(void);                       /* 191F:01A8 */

/* human-panel-only leaves still on the Phase-4 stub floor (hit-counted) */
extern int  menu_run_boxed(uint16_t key_off);  /* PORTED 0x181F:0x3FE runner (src/ui/menu_runner.c) */
extern long overlay_call_191F_019C();  /* func_06F5B0 text panel (0x1705, [0x8D52]) @0x4B410 */
extern long overlay_call_181F_0022();  /* func_002462 string-list fetch [0x2D42]+n */
extern long overlay_call_0D1D_07E4();  /* format text id into buf */
extern long overlay_call_0D1D_07A4();  /* append text id to buf */
extern long overlay_call_0D1D_117E();  /* far string copy */
extern long overlay_call_0D1D_0B48();  /* string-splice fmt */

/* action handlers */
extern int  native_haggle_resolve(int unit_idx, int settle, int power, int tribe); /* func_049600 */
extern int  native_attack_reward_roll(uint16_t unit, uint16_t settle,
                                      uint16_t owner, uint16_t tribe);   /* func_04A37C */
extern int  native_mission_established(uint16_t unit, uint16_t owner, uint16_t tribe); /* func_048A3A */
extern int  native_mission_heresy(uint16_t unit, uint16_t owner, uint16_t tribe);      /* func_048CA4 */
extern int  colony_commodity_advisor(uint16_t unit, uint16_t owner,
                                     uint16_t tribe, uint16_t zero);     /* func_04A426 */
extern int  scout_incite_tribe_to_war(uint16_t unit, uint16_t owner, uint16_t tribe);  /* func_04AF5E */
extern int  native_village_trade(uint16_t unit, uint16_t owner, uint16_t tribe);       /* func_04AC00 */

/* func_04A7CA full entry (speak-with-chief outcome roll incl. CHIEFKILL): only
 * its gold block is ported (native_village_raze.c).  Weak hit-counting default
 * so the dispatcher stays honest until the body lands; a real port overrides. */
extern void viceroy_stub_hit(const char *sym);
__attribute__((weak)) int func_04A7CA_speak_with_chief(uint16_t unit, uint16_t owner,
                                                       uint16_t tribe)
{
    (void)unit; (void)owner; (void)tribe;
    viceroy_stub_hit("func_04A7CA_speak_with_chief");
    return 0;
}

int func_04B308_confront_native(uint16_t unit /*bp+6*/, uint16_t x /*bp+8*/,
                                uint16_t y /*bp+0xA*/)
{
    int ret = 1;                       /* [bp-0x58] 1=end-turn 2=consumed 0=continue */
    int btn9 = 0;                      /* [bp-0x5e] explore button placed marker */
    int panel_lo = 0, panel_hi = 0;    /* [bp-0x5c]/[bp-0x5a] modal panel handle */
    int saved_units;                   /* [bp-0x56] roster-change detector       */
    int settle, owner, tribe, tribe0, alarm, contact, type, choice;
    uint16_t np;                       /* DG16(0x8D4A) NativeSettlement near ptr */
    int ubx;

    saved_units = DGS16(0x539C);                       /* @0x4B31F unit count   */

    /* @0x4B325 settlement at the target tile -> make it current. */
    settle = func_046004_settlement_at_tile(x, y);     /* @0x4B32B 181F:09F0    */
    func_0081F2_logic_sz_34((uint16_t)settle);         /* @0x4B337 181F:0A4C    */

    ubx   = unit * 0x1C;
    owner = DG8(0x3147 + ubx) & 0x0F;                  /* @0x4B343 [bp-0x68]    */
    np    = DG16(0x8D4A);                              /* @0x4B34D              */
    tribe = DG8(np + 2);                               /* @0x4B351 [bp-2]       */
    tribe0 = tribe - 4;                                /* @0x4B359 [bp-0x60]    */
    alarm = func_0082A0_logic_sz_18((uint16_t)tribe0, (uint16_t)owner); /* @0x4B361 [bp-0xBA] */
    contact = DG16(np + 0x0A + owner * 2);             /* @0x4B376 [bp-0x64]    */

    /* @0x4B37C human power -> first-contact music cue by tribe class. */
    if (owner < 4 && DG8(0x543F + owner * 0x34) == 0 && DG16(0x00A2) == 0) {
        int cue;
        if (DG16(0x8D52) == 0)      cue = 7;           /* @0x4B394..0x4B39B     */
        else if (DG16(0x8D52) == 1) cue = 6;           /* @0x4B3A0..0x4B3A7     */
        else                        cue = 5;           /* @0x4B3AC              */
        func_005108_op_sz_51((uint16_t)cue);           /* @0x4B3AE 181F:04AC    */
    }

    /* @0x4B3B6 ship gate (types 0x0D..0x12). */
    type = DG8(0x3146 + ubx);
    if (type >= 0x0D && type <= 0x12) {
        if (!(func_007F34_logic_sz_27((uint16_t)owner, (uint16_t)tribe) & 0x20)) { /* @0x4B3CE */
            /* @0x4B3DA lea bx,[0x16F7] "DONTKNOWSHIPS"; @0x4B3DE lcall
             * 0x181F:0x3FE (PORTED runner). */
            (void)menu_run_boxed(0x16F7);
            goto fin;                                  /* @0x4B3E3 jmp 0x4B9D2  */
        }
        if (alarm >= 0x4B || contact >= 0x40) {        /* @0x4B3E6/0x4B3ED      */
            /* @0x4B3F3 "we are not welcome" panel: tribe name int + text 0x1705. */
            int name = func_008110_logic_sz_14((uint16_t)tribe);   /* 181F:09A4 */
            func_06C23C_dialog_make_from_int(0, (uint16_t)name);   /* @0x4B401  */
            (void)overlay_call_191F_019C(0x1705, (int16_t)DG16(0x8d52));            /* @0x4B410 (0x1705,[0x8D52]) */
            goto fin;                                  /* @0x4B418              */
        }
    }

    /* @0x4B41C AI/human split: human (owner<4 && personality==0) -> panel. */
    if (owner < 4 && DG8(0x543F + owner * 0x34) == 0)
        goto human_panel;                              /* @0x4B42D jmp 0x4B56A  */

    /* ---- AI FORCED-ACTION SWITCH on unit type (jump table 1) ------------- */
    choice = 0;
    switch (type) {                                    /* @0x4B544 dec ax; jmp cs:[0x4772] */
    case 3: {                                          /* -> 0x4B43E missionary */
        /* incite gate: settlement relation to the CURRENT nation is hostile
         * and we trail them in mission share and we can afford 1500 gold. */
        int rel2 = func_0082A0_logic_sz_18(DG16(0x8D52), DG16(0x5398)); /* @0x4B446 */
        if (rel2 < 0x4B &&                             /* @0x4B44E              */
            (func_007F34_logic_sz_27(DG16(0x5398), (uint16_t)tribe) & 0x20) && /* @0x4B45A */
            DG8(0x917C + owner) < DG8(0x917C + DG16(0x5398))) {  /* @0x4B466..0x4B475 */
            int pbx = owner * 0x13C;
            int hi  = DGS16(pbx + 0x8834);             /* gold dword hi @0x4B47B */
            if (hi > 0 || (hi == 0 && DG16(pbx + 0x8832) >= 0x5DC)) { /* @0x4B480..0x4B48A */
                if (func_00C322_rtl_sz_63(0, 4) != 0 ||           /* @0x4B490   */
                    (int8_t)DG8(np + 5) >= 0) {        /* @0x4B49C mission byte */
                    choice = 7;                        /* @0x4B4A6 incite war   */
                    goto dispatch;
                }
            }
        }
        if ((int8_t)DG8(np + 5) < 0) {                 /* @0x4B4B2 no mission   */
            choice = 3;                                /* @0x4B4B8 establish    */
            goto dispatch;
        }
        if ((DG8(np + 5) & 0x0F) == owner)             /* @0x4B4C0 ours already */
            goto fin;                                  /* @0x4B4CB              */
        choice = 4;                                    /* @0x4B4CE denounce     */
        goto dispatch;
    }
    case 1: case 4: case 11:                           /* -> 0x4B4DE colonist   */
        /* region code computed into [bp-0x66] (faithful dead store). */
        (void)func_005E90_op_sz_64(DG8(0x3144 + ubx), DG8(0x3145 + ubx)); /* @0x4B4EE */
        choice = 9;                                    /* @0x4B4F9 live among   */
        goto dispatch;
    case 12:                                           /* -> 0x4B4D6 wagon train*/
        choice = 1;                                    /* haggle                */
        goto dispatch;
    case 5:                                            /* -> 0x4B502 scout      */
        choice = 6;                                    /* speak with chief      */
        goto dispatch;
    default:                                           /* -> 0x4B50A            */
        if (func_008BB2_logic_sz_20(unit) < 0)         /* @0x4B50D in settlement?*/
            goto fin;                                  /* @0x4B519              */
        if (DG8(0x315B + ubx) != 0x1C &&               /* @0x4B520 cargo0       */
            DG8(0x315B + ubx) != 0x19)                 /* @0x4B527              */
            goto fin;
        if (alarm >= 0x4B)                             /* @0x4B531              */
            goto fin;
        choice = 5;                                    /* @0x4B53B trade        */
        goto dispatch;
    }

human_panel:
    /* ---- HUMAN OPTION PANEL (@0x4B56A..0x4B8EE) -------------------------- */
    func_00543C_op_sz_131(7);                          /* @0x4B56A 181F:0524    */
    {
        /* greeting ints: nation-struct[+2]-keyed word + tribe name. */
        uint16_t nb = DG16(0x8D4E);                    /* @0x4B574              */
        int k = DG8(nb + 2);                           /* @0x4B578              */
        func_06C23C_dialog_make_from_int(0, DG16(k * 6 + 0x9634)); /* @0x4B585..0x4B58B */
        func_06C23C_dialog_make_from_int(1,
            (uint16_t)func_0080C8_logic_sz_14((uint16_t)tribe));   /* @0x4B596/0x4B5A1 */
    }
    /* @0x4B5A9 base text 0x1710 into [bp-0x52]; pick the alarm-tier suffix. */
    (void)overlay_call_0D1D_07E4();                    /* (buf, 0x1710)         */
    {
        uint16_t tid;
        if (alarm >= 0x4B)      tid = 0x1718;          /* @0x4B5B8              */
        else if (alarm >= 0x32) tid = 0x171C;          /* @0x4B5C4              */
        else if (alarm < 0x19 && (int16_t)DG16(np + 0x0A + owner * 2) < 0x80)
            tid = (DG16(0x8D52) == 2) ? 0x1727 : 0x172E; /* @0x4B5EC..0x4B5F8   */
        else                    tid = 0x1720;          /* @0x4B5E7              */
        (void)tid;
        (void)overlay_call_0D1D_07A4();                /* @0x4B5FF (buf, tid)   */
    }
    if (alarm >= 0x32) {                               /* @0x4B607 hostile cue  */
        int cue;
        if (DG16(0x8D52) == 0)      cue = 7;           /* @0x4B60E              */
        else if (DG16(0x8D52) == 1) cue = 6;           /* @0x4B61A              */
        else                        cue = 5;           /* @0x4B626              */
        func_005108_op_sz_51((uint16_t)cue);           /* @0x4B628              */
    }
    /* @0x4B630 build the panel (bx=layout 0x87C, ax=buf, dx=0) -> DX:AX. */
    panel_lo = func_06F0F4_text_template_run();        /* 191F:0182             */
    panel_hi = 0;
    if (panel_lo == 0 && panel_hi == 0)                /* @0x4B644 or dx,ax     */
        goto fin;                                      /* @0x4B648              */

    /* @0x4B64B ship/wagon: attack (alarm<0x4B, id 1) or demand (id 2). */
    if (type == 0x0C || (type >= 0x0D && type <= 0x12)) {
        uint16_t id = (alarm < 0x4B) ? 1 : 2;          /* @0x4B664..0x4B676 [0x932A]/[0x932C] */
        (void)overlay_call_181F_0022((int16_t)DG16(0x932c));                /* @0x4B67A string fetch */
        func_06C850_panel_append_button((uint16_t)panel_lo, (uint16_t)panel_hi,
                                        0, 0, id);     /* @0x4B68A 191F:0176    */
    }
    /* @0x4B692 scout: speak-with-chief button (id 6, [0x9334]). */
    if (type == 5) {
        (void)overlay_call_181F_0022((int16_t)DG16(0x9334));                /* @0x4B6A3              */
        func_06C850_panel_append_button((uint16_t)panel_lo, (uint16_t)panel_hi,
                                        0, 0, 6);      /* @0x4B6B3              */
    }
    /* @0x4B6BB land unit with @UNIT movement>1: explore button (id 9). */
    if (!(type >= 0x0D && type <= 0x12) &&
        DG8(0x5236 + type * 6) > 1) {                  /* @0x4B6E3              */
        (void)overlay_call_181F_0022((int16_t)DG16(0x933a));                /* @0x4B6F0 [0x933A]     */
        func_06C850_panel_append_button((uint16_t)panel_lo, (uint16_t)panel_hi,
                                        0, 0, 9);      /* @0x4B700              */
        btn9 = 1;                                      /* @0x4B708 [bp-0x5E]    */
    }
    /* @0x4B70D contact-established branch (war flags bit 0x40). */
    if (func_007F34_logic_sz_27((uint16_t)owner, (uint16_t)tribe) & 0x40) {
        if (type == 3) {                               /* @0x4B726 missionary   */
            if ((int8_t)DG8(np + 5) < 0) {             /* @0x4B734 no mission   */
                (void)overlay_call_181F_0022((int16_t)DG16(0x932e));        /* @0x4B740 [0x932E] id 3*/
                func_06C850_panel_append_button((uint16_t)panel_lo, (uint16_t)panel_hi,
                                                0, 0, 3); /* @0x4B7AF shared    */
            } else if ((DG8(np + 5) & 0x0F) != (uint8_t)owner) { /* @0x4B74C    */
                /* @0x4B757 "denounce <power> heresy": splice the mission
                 * owner's name into the [0x9330] template (id 4). */
                (void)overlay_call_181F_0022((int16_t)DG16(0x9330));        /* @0x4B75B [0x9330]     */
                (void)overlay_call_0D1D_117E();        /* @0x4B76A buf copy     */
                (void)func_0080C8_logic_sz_14(DG8(np + 5) & 0x0F); /* @0x4B77D name id */
                (void)overlay_call_181F_0022();        /* @0x4B786 name str     */
                (void)overlay_call_0D1D_0B48();        /* @0x4B799 splice fmt   */
                func_06C850_panel_append_button((uint16_t)panel_lo, (uint16_t)panel_hi,
                                                0, 0, 4); /* @0x4B7AF           */
            }                                          /* ours -> no 3/4 button */
            (void)overlay_call_181F_0022((int16_t)DG16(0x9338));            /* @0x4B84D [0x9336] id 7*/
            func_06C850_panel_append_button((uint16_t)panel_lo, (uint16_t)panel_hi,
                                            0, 0, 7);  /* @0x4B85D incite       */
        } else {
            /* @0x4B7C0 in-settlement slow land unit with plain cargo: trade. */
            if (func_008BB2_logic_sz_20(unit) >= 0 &&  /* @0x4B7C3              */
                DG8(0x5236 + type * 6) < 2 &&          /* @0x4B7E7              */
                type != 5 &&                           /* @0x4B7EE              */
                func_008BB2_logic_sz_20(unit) != 0x1B) { /* @0x4B7F5            */
                (void)overlay_call_181F_0022((int16_t)DG16(0x9332));        /* @0x4B808 [0x9332] id 5*/
                func_06C850_panel_append_button((uint16_t)panel_lo, (uint16_t)panel_hi,
                                                0, 0, 5); /* @0x4B818           */
            }
            /* @0x4B820 any moving land unit: enter-village button (id 8). */
            if (DG8(0x5236 + type * 6) != 0 &&
                !(type >= 0x0D && type <= 0x12)) {     /* @0x4B83F..0x4B845     */
                (void)overlay_call_181F_0022((int16_t)DG16(0x9338));        /* @0x4B84D [0x9338]     */
                func_06C850_panel_append_button((uint16_t)panel_lo, (uint16_t)panel_hi,
                                                0, 0, 8); /* @0x4B85D           */
            }
        }
    }
    /* @0x4B865 explore button if not already placed. */
    if (btn9 == 0 &&
        DG8(0x5236 + type * 6) != 0 &&
        !(type >= 0x0D && type <= 0x12)) {             /* @0x4B883..0x4B890     */
        (void)overlay_call_181F_0022((int16_t)DG16(0x933a));                /* @0x4B898 [0x933A] id 9*/
        func_06C850_panel_append_button((uint16_t)panel_lo, (uint16_t)panel_hi,
                                        0, 0, 9);      /* @0x4B8A8              */
    }
    /* @0x4B8B0 cancel button (id 0xA), run modal, free the panel. */
    (void)overlay_call_181F_0022();                    /* [0x933C]              */
    func_06C850_panel_append_button((uint16_t)panel_lo, (uint16_t)panel_hi,
                                    0, 0, 0x0A);       /* @0x4B8C6              */
    choice = func_06E3D0_panel_run_modal((uint16_t)panel_lo, (uint16_t)panel_hi); /* @0x4B8D4 */
    (void)func_0789FA_free_dos_block();                /* @0x4B8E2 191F:01A8    */
    panel_lo = panel_hi = 0;                           /* @0x4B8E7              */

dispatch:
    /* ---- ACTION DISPATCH (jump table 2, @0x4B9B2 on choice-1) ------------ */
    switch (choice) {
    case 1:                                            /* -> 0x4B8F6 haggle     */
        (void)native_haggle_resolve((int)unit, settle, owner, tribe);
        break;
    case 2:                                            /* -> 0x4B90C attack     */
        if (native_attack_reward_roll(unit, (uint16_t)settle,
                                      (uint16_t)owner, (uint16_t)tribe) != 0)
            ret = 2;                                   /* @0x4B926              */
        break;
    case 3:                                            /* -> 0x4B92E mission    */
        ret = 2;                                       /* @0x4B92E              */
        (void)native_mission_established(unit, (uint16_t)owner, (uint16_t)tribe);
        break;
    case 4:                                            /* -> 0x4B946 heresy     */
        (void)native_mission_heresy(unit, (uint16_t)owner, (uint16_t)tribe);
        break;
    case 5:                                            /* -> 0x4B978 advisor    */
        (void)colony_commodity_advisor(unit, (uint16_t)owner, (uint16_t)tribe, 0);
        break;
    case 6:                                            /* -> 0x4B966 chief      */
        if (func_04A7CA_speak_with_chief(unit, (uint16_t)owner, (uint16_t)tribe) != 0)
            ret = 2;                                   /* via L_4B91F           */
        break;
    case 7:                                            /* -> 0x4B956 incite     */
        (void)scout_incite_tribe_to_war(unit, (uint16_t)owner, (uint16_t)tribe);
        break;
    case 8:                                            /* -> 0x4B98A trade      */
        (void)native_village_trade(unit, (uint16_t)owner, (uint16_t)tribe);
        break;
    case 9:                                            /* -> 0x4B99A relations  */
        (void)func_007F96_op_sz_105((uint16_t)owner, (uint16_t)tribe, 4); /* @0x4B9A2 */
        ret = 0;                                       /* @0x4B9AA              */
        break;
    default:                                           /* 0x0A cancel / 0       */
        break;
    }

fin:
    /* ---- EPILOGUE (@0x4B9D2) --------------------------------------------- */
    (void)func_067700_compose_active_tile(1);          /* @0x4B9D3 181F:0E1C(1) */
    if (DGS16(0x539C) != saved_units)                  /* @0x4B9DC roster moved */
        return 2;                                      /* @0x4B9E4              */
    if (ret == 1)                                      /* @0x4B9EA              */
        func_007BCE_logic_sz_25(unit);                 /* @0x4B9F3 181F:0934    */
    return ret;                                        /* @0x4B9FB              */
}

/* Strong override of the generated weak stub: the unit_orders.c call site
 * declares ovly_confront_1A1F_16C(unit, x, y) @asm 0x03EE29. */
int16_t ovly_confront_1A1F_16C(int16_t unit, int16_t x, int16_t y)
{
    return (int16_t)func_04B308_confront_native((uint16_t)unit, (uint16_t)x,
                                                (uint16_t)y);
}
