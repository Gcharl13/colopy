/* ============================================================================
 *           >>> BYTE-VERIFIED (func_03BC42) <<<
 * ----------------------------------------------------------------------------
 * ff_acquire_dispatch() below is decompiled byte-for-byte from VICEROY.EXE
 * overlay page 0x06, function func_03BC42 @ file 0x03BC42 (the Founding-Father
 * acquisition + immediate-effect dispatch).  The brief's anchor 0x3BD37 is the
 * `inc PowerRecord+0x14` (ff_count) site INSIDE this function.
 *
 * The ff_id switch values are the NAMES.TXT @FATHERS line indices (0-based);
 * this mapping is CONFIRMED by matching the decompiled per-id effects to the
 * documented FF effects (e.g. id 1 = Jakob Fugger clears the boycott mask).
 *
 * Helper routines reached via `lcall 0x181F:NNNN` have VERIFIED call sites/args;
 * their internal behaviour: bodies in thunk page (resolved target file offsets cited).
 *
 * NOTE: include/ff.h was corrected (2026-05-29) to the byte-verified @FATHERS
 * order @ file 0x3047 and now agrees with the enum below one-for-one. The IDs
 * are still defined locally here to keep this byte-verified switch self-contained
 * (and to avoid a redefinition clash with the local enum); ff.h may be #included
 * by future passes instead. Do NOT alter the verified id VALUES below.
 * ============================================================================ */

/* ============================================================================
 * effects.c -- Founding Father acquisition + immediate effect dispatch
 * ----------------------------------------------------------------------------
 * @ref ../docs/FOUNDING_FATHERS.md
 * @ref ../../../COLONIZE/NAMES.TXT @FATHERS   (canonical id ordering)
 * @asm VICEROY.EXE func_03BC42 @0x03BC42  (page 0x06, ENTER 0x60,0, RETF)
 * ============================================================================ */
#include "viceroy_types.h"
#include "dgroup.h"
#include "power.h"

/* ----------------------------------------------------------------------------
 * BYTE-VERIFIED Founding-Father IDs == NAMES.TXT @FATHERS line index (0-based).
 * @ref COLONIZE/NAMES.TXT @FATHERS @ file 0x3047:
 *   0 Adam Smith        1 Jakob Fugger      2 Peter Minuit     3 Peter Stuyvesant
 *   4 Jan de Witt       5 F. Magellan       6 F. Coronado      7 Hernando de Soto
 *   8 Henry Hudson      9 Sieur De La Salle 10 Hernan Cortes   11 G. Washington
 *  12 Paul Revere      13 Francis Drake    14 John Paul Jones  15 Thomas Jefferson
 *  16 Pocahontas       17 Thomas Paine     18 Simon Bolivar    19 Benj. Franklin
 *  20 William Brewster 21 William Penn     22 Jean de Brebeuf  23 Juan de Sepulveda
 *  24 Bartolome de las Casas
 * Confirmed by the per-id effects decompiled below. */
enum FoundingFatherId {
    FF_ADAM_SMITH = 0, FF_JAKOB_FUGGER, FF_PETER_MINUIT, FF_PETER_STUYVESANT,
    FF_JAN_DE_WITT, FF_MAGELLAN, FF_CORONADO, FF_DE_SOTO,
    FF_HENRY_HUDSON, FF_LA_SALLE, FF_HERNAN_CORTES, FF_WASHINGTON,
    FF_PAUL_REVERE, FF_FRANCIS_DRAKE, FF_JOHN_PAUL_JONES, FF_JEFFERSON,
    FF_POCAHONTAS, FF_THOMAS_PAINE, FF_SIMON_BOLIVAR, FF_FRANKLIN,
    FF_WILLIAM_BREWSTER, FF_WILLIAM_PENN, FF_DE_BREBEUF, FF_DE_SEPULVEDA,
    FF_LAS_CASAS,
    FF_COUNT = 25
};

/* ----------------------------------------------------------------------------
 * VERIFIED PowerRecord fields touched by this handler.
 *   +0x12  uint16  "pending/last-acquired FF" slot (set to 0xFFFF on acquire)
 *   +0x14  uint8   founding-fathers count (incremented on every acquire)
 *   +0x20  uint16  boycott mask (cleared by Jakob Fugger)
 *   +0x02..+0x04   3-byte European immigration "dock" pool (unit-type bytes)
 *   +0x32 / +0x33  bytes copied into a freshly-created unit (John Paul Jones)
 * @ref docs/RULINGS.md 2026-05-28 PowerRecord 0x8808 / boycott +0x20 / ff_count +0x14
 * @asm DGROUP:0x84FC = pointer to ACTIVE player's PowerRecord (g_active_power);
 *      confirmed elsewhere by gold dword at [bx+0x2a]/[bx+0x2c].
 * ---------------------------------------------------------------------------- */
/* (2026-06-12) All DGROUP state is now reached through the DG accessors
 * (dgroup.h) — the former named externs (g_active_power, g_colony_cur,
 * g_num_powers, ...) bound to WRONG or read-only link-floor homes in the
 * modern build (g_active_power -> the naval WORD at 0x5394, the counts ->
 * weak FUNCTION stubs) and would have faulted on first execution.  Homes:
 *   [0x84FC] active PowerRecord near offset   @asm 03BD33 mov bx,[0x84fc]
 *   [0x8542] selected ColonyRecord offset (id-9 / id-24 walks)
 *   [0x539E] colony count   [0x539A] settlement count   [0x539C] unit count
 *   [0x53D0] Bolivar/rebel-sentiment meter
 *   [0x543F] AIPersonality controller column, stride 0x34 (0 = human)
 *   [0x3144] unit table, stride 0x1C: +0x02 type, +0x03 owner&0xf, +0x08
 *            orders, +0x09/+0x0A goto x/y, +0x16 turn_counter, +0x17 subtype
 *   [0x8D4A]/[0x8D4E] selected-settlement record offsets (settle_at/settle_at2)
 */

/* ----------------------------------------------------------------------------
 * Overlay/load-image helpers used by the dispatch. Call sites/args VERIFIED;
 * bodies in thunk page.
 * FILE OFFSETS CORRECTED 2026-06-10: every target below was re-derived from the
 * raw RTLink thunk records (0x181F table @file 0x1A5F0+off, 0x1A1F table
 * @0x1C5F0+off; resident `ljmp seg:off` -> file = seg*16+0x2400+off; overlay
 * records -> overlay_segmap[ovl].base+off32 — rule verified on random_int
 * 0x4D4->0xC322, clamp 0x35C->0x48CC, power_handle 0x9A4->0x8110 which pricing.c
 * had independently traced).  ALL 17 offsets previously cited here from
 * lcall_resolution_VICEROY.json were WRONG — treat that JSON as unreliable.
 * Helper-pair spacings (settle_at/settle_at2 +0x2C, unit_type_of/unit_set_type
 * +0x3A) survive the re-basing, confirming record reads were right, bases wrong.
 * ---------------------------------------------------------------------------- */
extern void ff_announce(int power);                 /* 0x181F:0x0582 -> func_030550 (ovl 4+0) = market_set_active in
                                                     * market/pricing.c — i.e. SET ACTIVE POWER ([0x9E12], [0x84FC]
                                                     * = 0x8808+power*0x13C); the FF announce path activates the
                                                     * power record before composing text. @asm 03BC50 */
extern void power_set_flag(int handle, int flag);   /* 0x181F:0x0438 -> file 0x6C23C (ovl 23+0x3EC) = msg_set_arg body */
extern int  power_handle(int power);                /* 0x181F:0x09A4 -> file 0x08110 (resident 05B3:01E0) — matches the
                                                     * 14-byte difficulty clamp pricing.c traced at 0x008110 */
extern void ui_sound_or_msg(int arg);               /* 0x181F:0x04AC -> file 0x05108 (resident 029F:0318) @asm 03BCFD push 3 */
extern void ff_portrait_dialog(void *a, void *b, int c); /* 0x181F:0x0998 -> func_06F51A (ovl 23+0x36CA; sibling of the
                                                     * dialog-show func_06F61C in the same UI overlay) @asm 03BD11 */
extern int  unit_at(int idx);                       /* 0x181F:0x09E6 -> file 0x082DC (resident 05EB:002C) — the
                                                     * "select record i" helper census/meeting call colony_select */
/* @asm 03BD97: push arg; push arg; push power; push type(0x11) ; lcall 0x95c ; add sp,8
 * Far cdecl: last push (type) is arg0. Signature mirrors push order. */
extern int  unit_create(int type, int power, int arg_hi, int arg_lo); /* 0x181F:0x095C -> func_006D24 (resident 0427:06B4) */
extern int  settle_at(int idx);                     /* 0x181F:0x0A42 -> func_0081C6 (resident 05DC:0006; Pocahontas loop) */
extern int  settle_at2(int idx);                    /* 0x181F:0x0A4C -> file 0x081F2 (resident 05DC:0032; Brebeuf/id22 loop) */
extern void native_alarm_clear(int a, int neg, int power, int idx); /* 0x181F:0x0D6C -> func_045DF2 (ovl 11+0xF2)
                                                     * = diplo_182_pair "adjust native/power attitude" (meeting.c) */
extern void coronado_reveal(int idx, int power);    /* 0x181F:0x07AA -> func_0063B6 (resident 03F1:00A6; id6 reveal;
                                                     * @asm push power; push idx -> idx=arg0) */
extern int  unit_type_of(int idx);                  /* 0x181F:0x0C54 -> func_009102 (resident 05EB:0E52; id24 -> AL type) */
extern void unit_set_type(int type, int idx);       /* 0x181F:0x0CAE -> file 0x0913C (resident 05EB:0E8C; id24 set 0x1c) */
extern void colony_effect_id9(int zero, int one);   /* 0x181F:0x0BBE -> func_0092E0 (resident 05EB:1030; La Salle;
                                                     * @asm push 1; push 0 -> arg0=0) */
extern void ff_finish(int flag);                    /* 0x181F:0x0E1C -> ovl 21+0xC0; ovl-21 base DISPUTED (segmap 0x66850 vs
                                                     * 0x67080 anchored by func_0673CC/func_067476) so target = 0x66910 or
                                                     * 0x67140 — neither a prologue; likely alternate entry. @asm 03BFC6 push 1 */
extern void ff_pre_a(int power);                    /* 0x181F:0x056A -> file 0x0C136 (resident 0984:04F6, frameless push-leaf) @asm 03BD2E */
extern void ff_pre_b(int ff_id);                    /* 0x1A1F:0x0062 -> func_06AE08 (ovl 22+0x1F28, ENTER 0x58) @asm 03BD26.
                                                     * BODY DECODED 2026-06-10: the FF announcement BANNER painter -
                                                     * draws the [0x2E92] headline then the FF's name from
                                                     * FF_MEM_BASE word[0x9652 + ff_id*6] (congress.c table),
                                                     * full-width (0x140) commits via 0x181F:0x100. */

/* cs-relative near calls in page 0x06 (helpers, bodies not yet decoded): */
extern void cs_1095(int one, int ff_id, int power);  /* @asm 03BC67 call 0x1095 */
extern void cs_1086(void *out, int power);           /* @asm 03BCA2 call 0x1086 */
extern void cs_1077(int ff_id, int power);           /* @asm 03BD1D call 0x1077 */

/* Native-settlement table (DGROUP:0x8D4A) and map/unit tables used by effects. */
/* Native-settlement selection slots: [0x8D4A] (+0x05 mission flag = 0x10|owner,
 * @ref MEMORY.md) and [0x8D4E] (+0x46 alarm word, Pocahontas) hold the record
 * offsets stored by settle_at/settle_at2 — read via DG16() at the use sites. */

/* ----------------------------------------------------------------------------
 * ff_acquire_dispatch -- func_03BC42
 * ----------------------------------------------------------------------------
 *   power == [bp+6] : recruiting power index
 *   ff_id == [bp+8] : Founding-Father id (NAMES.TXT @FATHERS line index)
 * ---------------------------------------------------------------------------- */
void ff_acquire_dispatch(int power, int ff_id)
{
    unsigned p;                        /* active PowerRecord near offset ([0x84FC]) */
    int16_t save_8dc6;                 /* @asm 03BC47 mov ax,[0x8dc6]; -> [bp-0x58] */
    int i;

    save_8dc6 = DGS16(0x8DC6);         /* @asm 03BC47 stashed, reused at id14/id20 tail */
    ff_announce(power);                /* @asm 03BC50 lcall 0x181f,0x582 */

    /* @asm 03BC58: if (ff_id >= 0) { ... announcement + flagging ... } */
    if (ff_id >= 0) {
        /* @asm 03BC5E: push 1; push ff_id; push power; call cs:0x1095
         * -> ljmp 0x1A1F:0x38 = func_03B900 ff_set_owned_bit(power, ff_id, 1)
         * (page-06 thunk row disassembled 2026-06-12; recruit.c has the body) */
        cs_1095(1, ff_id, power);                          /* @asm 03BC67 call 0x1095 */

        /* @asm 03BC6D..03BC85: power_set_flag(*(WORD*)(ff_id*6 - 0x69ae), 1)
         * = the FF's NAME/notify string handle (FF_MEM_BASE 0x9652, congress.c). */
        {
            int16_t handle = (int16_t)DG16(0x9652 + (unsigned)ff_id * 6); /* @asm 03BC78 [bx-0x69ae] */
            power_set_flag(handle, 1);                     /* @asm 03BC7E lcall 0x181f,0x438 */
        }

        /* @asm 03BC86: if (*(int8_t*)(ff_id + 0x53a9) < 0) *(...) = (uint8_t)power;
         * a per-FF "first owner" byte table at DGROUP:0x53A9, set once. */
        if (DGS8(0x53A9 + (unsigned)ff_id) < 0)            /* @asm 03BC89 */
            DG8(0x53A9 + (unsigned)ff_id) = (uint8_t)power;/* @asm 03BC93 */
    } else {
        /* @asm 03BC9A: out-of-band path (ff_id<0): cs_1086 then power_set_flag(&buf,1).
         * cs:0x1086 -> ljmp 0x1A1F:0x0E = func_03BA26 ff_format_name_row.
         * Unreached from the wired flow (callers gate pending>=0); left weak. */
        uint8_t buf[0x50];                                 /* @asm lea ax,[bp-0x50] */
        cs_1086(buf, power);                               /* @asm 03BCA2 call 0x1086 */
        power_set_flag((int)(long)buf, 1);                 /* @asm 03BCAF lcall 0x181f,0x416 */
    }

    /* @asm 03BCB7: if (power < 4 && controller(0x543F+power*0x34) == 0) {
     *   ...play the full recruit presentation (only for the active/human power)... }
     * @ref AIPersonality DGROUP:0x543F stride 0x34, +0x00 controller (0 => human). */
    if (power < 4 &&
        DG8(0x543F + (unsigned)power * 0x34) == 0) {                  /* @asm 03BCC1 */
        /* @asm 03BCCE: power_set_flag(*(WORD*)(power*6 - 0x69ae), 0) */
        int16_t handle = (int16_t)DG16(0x9652 + (unsigned)power * 6); /* @asm 03BCD9 */
        power_set_flag(handle, 0);                                    /* @asm 03BCDF lcall 0x181f,0x438 */
        power_set_flag(power_handle(power), 1);                       /* @asm 03BCF5 lcall 0x181f,0x438 */
        ui_sound_or_msg(3);                                           /* @asm 03BCFD lcall 0x181f,0x4ac */
        /* @asm 03BD07: lea bx,[0x87c]; lea ax,[0x125a]; sub dx,dx; lcall 0x181F:0x998
         * = the 3.1 MENU SHIM (menu_runner.c chain): boxed GAME.TXT key
         * "FREEDOM" (dg 0x125A) — the FF acquire popup.  [WIRED: strong
         * ff_portrait_dialog in ui/congress_screen.c -> menu_run_boxed] */
        ff_portrait_dialog((void *)0x087C, (void *)0x125A, 0);        /* @asm 03BD11 lcall 0x181f,0x998 */
        /* @asm 03BD16: push ff_id; push power; call cs:0x1077
         * -> ljmp 0x191F:0xF74 = func_03BB4A cc_screen_background(power, ff_id)
         * = THE CONGRESS SCREEN (CCBKGD + CC-NN.SS portrait plates + the
         * new-father reveal).  [WIRED: ui/congress_screen.c] */
        cs_1077(ff_id, power);                                        /* @asm 03BD1D call 0x1077 */
        ff_pre_b(ff_id);                                              /* @asm 03BD26 lcall 0x1a1f,0x62 */
        ff_pre_a(power);                                              /* @asm 03BD2E lcall 0x181f,0x56a */
    }

    /* ====================== common acquisition core ====================== */
    /* @asm 03BD33: p = [0x84FC] (active PowerRecord near offset) */
    p = DG16(0x84FC);
    DG8(p + 0x14) += 1;                           /* @asm 03BD37 inc byte [bx+0x14] ff_count++  <-- 0x3BD37 */
    DG16(p + 0x12) = 0xFFFF;                      /* @asm 03BD3A mov word [bx+0x12],0xffff */

    /* ============================== EFFECT SWITCH ============================== */
    /* Each `if (ff_id == N)` block mirrors a CMP/JNE chain in the original. */

    /* --- id 1: JAKOB FUGGER -- clear the boycott mask. @asm 03BD3F/03BD45 --- */
    if (ff_id == FF_JAKOB_FUGGER) {                          /* @asm cmp [bp+8],1 */
        DG16(p + 0x20) = 0;                                  /* @asm 03BD45 mov word [bx+0x20],0 */
    }

    /* --- id 9: SIEUR DE LA SALLE -- per-colony effect for colonies owned by
     *     `power` with population >= 3 (free Stockade). @asm 03BD4A..03BD89 --- */
    if (ff_id == FF_LA_SALLE) {                              /* @asm cmp [bp+8],9 (jne 0xa0b) */
        for (i = 0; i < DGS16(0x539E); i++) {                /* @asm 03BD85 cmp [0x539e] colony count ([bp-0x5a]) */
            unit_at(i);                                      /* @asm 03BD58 push i; lcall 0x181f,0x9e6 (colony select) */
            /* @asm 03BD61: c = [0x8542] (selected ColonyRecord near offset) */
            unsigned c = DG16(0x8542);
            if (DG8(c + 0x1A) == (uint8_t)power && DGS8(c + 0x1F) >= 3) /* @asm 03BD68 cmp [bx+0x1a],al ; 03BD6D cmp [bx+0x1f],3 */
                colony_effect_id9(0, 1);                     /* @asm 03BD73 push 1; push 0; lcall 0x181f,0xbbe */
        }
    }

    /* --- id 14 (0xE): JOHN PAUL JONES -- create a free unit of type 0x11 at the
     *     power's home coords, then init its UnitRecord. @asm 03BD8B..03BDD8 --- */
    if (ff_id == FF_JOHN_PAUL_JONES) {                       /* @asm cmp [bp+8],0xe */
        int arg = power - 0x18;                              /* @asm 03BD94 sub ax,0x18 */
        /* @asm push arg; push arg; push power; push 0x11 -> unit_create(0x11,power,arg,arg)
         * (type 0x11 forced in the ==0xe branch; the else-0xf path is unreachable here). */
        int slot = unit_create(0x11, power, arg, arg);       /* @asm 03BDAC lcall 0x181f,0x95c */
        if (slot >= 0) {                                     /* @asm 03BDB7 or ax,ax; jl */
            unsigned u = 0x3144 + (unsigned)slot * 0x1C;     /* @asm 03BDBB imul bx,ax,0x1c (unit table 0x3144) */
            /* Source bytes are PowerRecord[power]+0x32/+0x33 (home x/y), indexed
             * by the `power` ARG (si=[bp+6]*0x13C), NOT the active-player ptr. */
            unsigned src = 0x8808 + (unsigned)power * 0x13C + 0x32; /* @asm si-0x77c6 */
            DG8(u + 0x08) = 0;                                /* @asm 03BDBE mov [bx+0x314c],0 (orders; 0x3144+0x08) */
            DG8(u + 0x09) = DG8(src + 0);                     /* @asm 03BDC8 [si-0x77c6] -> [bx+0x314d] (goto_x; +0x09) */
            DG8(u + 0x0A) = DG8(src + 1);                     /* @asm 03BDD0 [si-0x77c5] -> [bx+0x314e] (goto_y; +0x0A) */
            DG8(u + 0x16) = 0;                                /* @asm 03BDD8 mov [bx+0x315a],0 (turn_counter; 0x3144+0x16) */
        }
    }

    /* --- id 16 (0x10): POCAHONTAS -- reset native alarm/tension toward `power`
     *     across all settlements (two loops). @asm 03BDDD..03BE4B ---
     * [0x8D4E]/[0x8D4A] hold the SELECTED settlement record offsets (written by
     * settle_at/settle_at2; modern convention = DGROUP near offsets, see
     * load_image_007610_00824E.c "mov [0x8d4a],bx"). Re-read per iteration. */
    if (ff_id == FF_POCAHONTAS) {                            /* @asm cmp [bp+8],0x10 */
        for (i = 0; i < 8; i++) {                            /* @asm 03BE1C cmp [bp-0x5a],8 */
            settle_at(i);                                    /* @asm 03BDEB lcall 0x181f,0xa42 */
            /* @asm 03BDF3: si=power*2; alarm = -*(int16_t*)([0x8D4E] + si + 0x46) */
            int16_t alarm = (int16_t)-DGS16(DG16(0x8D4E) + (unsigned)power * 2 + 0x46); /* @asm 03BDFC neg */
            if (alarm < 0)                                   /* @asm 03BE04 or ax,ax; jge */
                native_alarm_clear(0, alarm, power, i);      /* @asm 03BE11 lcall 0x181f,0xd6c */
        }
        for (i = 0; i < DGS16(0x539A); i++) {                /* @asm 03BE47 cmp [0x539a] settlement count */
            settle_at2(i);                                   /* @asm 03BE2B lcall 0x181f,0xa4c */
            /* @asm 03BE33: si=power*2; *(int16_t*)([0x8D4A] + si + 0x0a) = 0 */
            DGS16(DG16(0x8D4A) + (unsigned)power * 2 + 0x0A) = 0; /* @asm 03BE3C */
        }
    }

    /* --- id 18 (0x12): SIMON BOLIVAR -- add 0x14 (20) to a power-scoped meter
     *     (DGROUP:0x53D0), capped at 0x64 (100). Only if power<4 & human-ctrl.
     *     @asm 03BE4D..03BE74 --- */
    if (ff_id == FF_SIMON_BOLIVAR) {                         /* @asm cmp [bp+8],0x12 */
        if (power < 4 &&
            DG8(0x543F + (unsigned)power * 0x34) == 0) {     /* @asm 03BE5D */
            int v = DGS16(0x53D0) + 0x14;                    /* @asm 03BE64 add [0x53d0],0x14 */
            if (v > 0x64) v = 0x64;                          /* @asm 03BE6C cmp 0x64; clamp */
            DGS16(0x53D0) = (int16_t)v;                      /* @asm 03BE74 mov [0x53d0],ax */
        }
    }

    /* --- id 22 (0x16): JEAN DE BREBEUF -- set the mission flag (0x10) on every
     *     native settlement whose owner == power. @asm 03BE77..03BEB0 ---
     * @ref NativeSettlement +0x05 mission flag = 0x10|owner (MEMORY.md). */
    if (ff_id == FF_DE_BREBEUF) {                            /* @asm cmp [bp+8],0x16 */
        for (i = 0; i < DGS16(0x539A); i++) {                /* @asm 03BEAC cmp [0x539a] */
            settle_at2(i);                                   /* @asm 03BE85 lcall 0x181f,0xa4c */
            unsigned s = DG16(0x8D4A);                       /* selected settlement offset */
            if (DGS8(s + 5) >= 0 && (DG8(s + 5) & 0x0F) == (uint8_t)power) /* @asm 03BE91/03BE9D */
                DG8(s + 5) |= 0x10;                          /* @asm 03BEA2 or byte [bx+5],0x10 */
        }
    }

    /* --- id 24 (0x18): BARTOLOME DE LAS CASAS -- upgrade every unit owned by
     *     `power` of subtype 0x1B (Indian Convert) to 0x1C (Free Colonist).
     *     @asm 03BEB2..03BF52 (nested settlement/unit walk) --- */
    if (ff_id == FF_LAS_CASAS) {                             /* @asm cmp [bp+8],0x18 (==0x18 -> 0xb3b) */
        /* --- pass 1: nested unit walk (@asm 0xb3b..0xb71) ---
         * outer index `j` in [bp-0x5e] bounded by [0x539c]; for each unit whose
         * owner byte (UnitRecord+0x03)&0xf == power, if that unit's type
         * (UnitRecord+0x02) == 0 and its subtype (+0x17) == 0x1B (Indian Convert),
         * promote subtype to 0x1C (Free Colonist). */
        for (i = 0; i < DGS16(0x539C); i++) {                /* @asm 03BEED cmp [0x539c] */
            unsigned u = 0x3144 + (unsigned)i * 0x1C;        /* @asm 03BEC2 imul bx,ax,0x1c */
            if ((DG8(u + 0x03) & 0x0F) != (uint8_t)power)    /* @asm 03BEC5 [bx+0x3147]&0xf cmp [bp+6] (owner +0x03) */
                continue;                                    /* @asm 03BECE jne next */
            if (DG8(u + 0x02) == 0 && DG8(u + 0x17) == 0x1B) /* @asm 03BED4 [bx+0x3146]==0 (type) ; 03BEDB [bx+0x315b]==0x1b (subtype) */
                DG8(u + 0x17) = 0x1C;                        /* @asm 03BEE2 mov [bx+0x315b],0x1c */
        }
        /* --- pass 2: per-power colony walk (@asm 0xb73..0xbac) ---
         * Outer over k in [0,[0x539e]); unit_at(k) selects a colony into the
         * DGROUP:0x8542 slot; if that colony's owner byte (struct+0x1a)==power,
         * walk its members m in [0,struct+0x1f): if unit_type_of(m)==0x1B, set
         * it to 0x1C via unit_set_type(0x1C,m). */
        for (int k = 0; k < DGS16(0x539E); k++) {            /* @asm 03BF2F cmp [0x539e] */
            unit_at(k);                                      /* @asm 03BF39 lcall 0x181f,0x9e6 */
            unsigned c = DG16(0x8542);                       /* DGROUP:0x8542 selected colony offset */
            if (DG8(c + 0x1A) != (uint8_t)power)             /* @asm 03BF48 cmp [bx+0x1a],al */
                continue;                                    /* @asm 03BF4B jne */
            for (int m = 0; m < DGS8(c + 0x1F); m++) {       /* @asm 03BF01 [bx+0x1f] > [bp-0x5e] */
                if (unit_type_of(m) == 0x1B)                 /* @asm 03BF15 lcall 0xc54; cmp 0x1b */
                    unit_set_type(0x1C, m);                  /* @asm 03BF22 push 0x1c; push m; lcall 0xcae */
            }
        }
    }

    /* --- id 6: FRANCISCO CORONADO -- reveal all colonies of all powers.
     *     @asm 03BF54..03BF83 --- */
    if (ff_id == FF_CORONADO) {                              /* @asm cmp [bp+8],6 */
        for (i = 0; i < DGS16(0x539E); i++) {                /* @asm 03BF7C cmp [0x539e] ([bp-0x60]) */
            unit_at(i);                                      /* @asm 03BF63 lcall 0x181f,0x9e6 */
            /* @asm push [bp+6](power); push [bp-0x60](i) -> coronado_reveal(i, power) */
            coronado_reveal(i, power);                       /* @asm 03BF71 lcall 0x181f,0x7aa */
        }
    }

    /* --- id 20 (0x14): WILLIAM BREWSTER -- replace dock-pool entries of type
     *     0x19 (Petty Criminal) or 0x1A (Indentured Servant) with 0x1C (Free
     *     Colonist), for the 3 immigration slots at PowerRecord+0x02..+0x04.
     *     @asm 03BF85..03BFB7 --- */
    if (ff_id == FF_WILLIAM_BREWSTER) {                      /* @asm cmp [bp+8],0x14 */
        unsigned pool = 0x8808 + (unsigned)power * 0x13C + 0x02; /* @asm si-0x77f6 */
        for (i = 0; i < 3; i++) {                            /* @asm 03BFB3 cmp [bp-0x5a],3 */
            if (DG8(pool + i) == 0x19 || DG8(pool + i) == 0x1A) /* @asm 03BF98/03BF9F */
                DG8(pool + i) = 0x1C;                        /* @asm 03BFAB mov byte [...],0x1c */
        }
    }

    /* ====================== common tail ====================== */
    unit_at(save_8dc6);            /* @asm 03BFB9 push [bp-0x58]; lcall 0x181f,0x9e6 */
    ff_finish(1);                  /* @asm 03BFC6 push 1; lcall 0x181f,0xe1c */
    /* @asm 03BFCF leave / 03BFD0 retf */
}

/* ============================================================================
 * DECODE STATUS (updated 2026-06-10):
 *
 * RESOLVED:
 *   - DGROUP:0x53A9 = FF first-owner byte table, 25 entries (one per FF id 0..24),
 *     initialized to 0xFF (unowned) by game init (func_0757C4: memset 0x53A9,0xFF,25).
 *     Set on first grant in func_03BC42 @asm 03BC89/03BC93.  See congress.c.
 *   - DGROUP:0x9652 (= -0x69AE segment-relative) = FF_MEM_BASE, stride 6:
 *       +0x00  congress notification handle (word)
 *       +0x02  category 0..4 (byte)
 *       +0x03..+0x05  era-band AI weights (3 bytes)
 *     Layout fully decoded in congress.c (FF_MEM_BASE / FF_MEM2_BASE).
 *   - Ownership query: ff_owned(ff_id, power) at 0x181F:0x07B4 returns nonzero
 *     if power owns FF ff_id.  Declared in congress.c line 85; used by all
 *     PASSIVE-FF subsystem ticks (IDs 0,2,3,4,5,7,8,10,11,12,13,15,17,19,21,23).
 *   - The FF *bitmap* (PowerRecord+0x07) is NOT written by this handler; the
 *     congress-grant path (func_03BC42) owns that.  This handler only bumps
 *     COUNT (+0x14) and the pending slot (+0x12).
 *
 * STILL PENDING:
 *   - The boycott field is a 16-bit mask at +0x20 (CLEARED whole here).
 *     RESOLVED 2026-06-10 (cross-ref): the per-commodity bit SET operation is
 *     byte-verified in king/tax_apply.c — king[+0x20] |= (1 << good) @asm
 *     0x034717; Fugger's whole-mask CLEAR here is the inverse.
 *   - Helper BODIES behind the 0x181F:NNNN calls: TARGETS now resolved
 *     2026-06-10 via the RTLink thunk rule (corrected offsets cited above;
 *     several have disasm available: func_006D24, func_0063B6, func_009102,
 *     func_0092E0, func_0081C6, func_045DF2, func_06AE08).  Body DECODES are
 *     still open — each is a separate trace.
 * ============================================================================ */
