/* ============================================================================
 * naval_screen.c -- THE NAVAL ADVISER (F7 report): the 4-column ruled ship
 *                   table (Ship / Cargo / Location / Destination).
 *                                                       ROUTE_B_PLAN 3.3.
 * ----------------------------------------------------------------------------
 * THE ORIGINAL CHAIN (every hop disassembled this session; capstone CS_MODE_16
 * over re_work/VICEROY.EXE -- all @asm cites are FILE offsets):
 *
 *  RAISE 1 -- SETREPORT F-key ladder (func_0235D6 command dispatcher):
 *    @asm 0x0238A9  83 7e 06 46     cmp word [bp+6],0x46   (selector 0x46 = F7)
 *    @asm 0x0238AF  ff 76 e4        push word [bp-0x1C]    (player = lookup-1)
 *    @asm 0x0238B2  9a c6 03 1f 19  lcall 0x191F:0x3C6
 *      thunk 0x191F:0x3C6 (rec @0x1B9B6, type A) -> page05+0x220C
 *      = 0x37340+0x220C = file 0x3954C (whois.py; page-05 base = func_037340).
 *  RAISE 2 -- COLONY-SCREEN F-key handler (func_02BB9C key block):
 *    @asm 0x02BE67  81 7e 06 41 01  cmp word [bp+6],0x141  (F7 scancode)
 *    @asm 0x02BE6E  mov bx,[0x8542] ; mov al,[bx+0x1A]     (colony OWNER byte)
 *    @asm 0x02BE77  push ax ; 0x02BE78 lcall 0x191F:0x3C6
 *      -> WIRED in overlay_02AAEC_02F0C7.c (cmd==0x141 arm).
 *
 *  COMPOSER  func_03954C  (file 0x3954C..0x39886; ENTER 0x6A spot c8 6a 00 00;
 *            RETF @0x39886)  = naval_screen_render() below.  One single pass
 *            over the unit table, 7 rows/page, page chrome repaint on overflow.
 *            (The old "two content passes" reading in docs/drawlist/REPORTS.md
 *            was wrong: [bp-0x52] is just a "page already shown" latch
 *            @0x39567/0x397DE consumed at @0x3985C.)
 *  CHROME    func_0393F4  (file 0x393F4..0x3954B; ENTER 0x58) = naval_chrome()
 *            below; reached via the page-05 trampoline @0x39E3F (ljmp
 *            0x191F:0xF12 -> page05+0x20B4 = 0x393F4).  Called at entry
 *            @0x39555 and again at re-pagination @0x397C9.  It draws the
 *            panel backdrop (report_open(7)), the title, the 4 centered
 *            column headers and the 3+8 grid rules.  (report_screen.c's old
 *            "naval_footer/_hdr (header pass / footer pass)" model of this
 *            function is RETIRED -- there is one body, the page chrome.)
 *  FOOTER    func_0373CA  (file 0x373CA..0x37449) = naval_footer_button()
 *            below; trampoline @0x39E30 (ljmp 0x191F:0xEE8 -> page05+0x8A).
 *            Draws the OK button box + centered label [0x2E16] (@MISC 46).
 *  BACKDROP  func_037340 report_open(panel)  (trampoline @0x39E53, ljmp
 *            0x191F:0xF4A -> page05+0): titlebuf = "REPORT" (dg 0x11A2)
 *            + itoa(panel) via 0x181F:0x182 (func_0029DE append-number)
 *            -> "REPORT7"; loaded as "REPORT7.PIK" by 0x181F:0x44E
 *            (func_076B9E: "%s.PIK" fmt dg 0x2402, fopen "rb" dg 0x2406) into
 *            the screen descriptor [0x2DA8..0x2DAE]; on SUCCESS (ret 0) the
 *            image's DAC window [0x98..0x98+0x64) is uploaded via the
 *            resident palette leaf 0xC2E:0x22 (file 0x0E702: out 0x3C8/0x3C9,
 *            ax=0x98 dx=0x64 @0x373B1..0x373BC); on FAILURE the descriptor
 *            is box-filled colour 0x22 via 0x181F:0x484 (func_00DCD4 ->
 *            0xB9E:0xA box fill) @0x37389..0x3739D.
 *
 *  LEAVES (tools/whois.py resolutions; all already-ported bodies):
 *    0x181F:0x582 -> func_030550  market_set_active(player)  [market/pricing.c]
 *                    (stores [0x9E12]=player, [0x84FC]=0x8808+player*0x13C)
 *    0x181F:0x2BC -> 012B:01BA func_00386A unit figure renderer; metric==0x64
 *                    path = unit_figure_blit_64  [platform/unit_blit.c]
 *    0x181F:0xBE6 -> func_00B2A2_cargo_slot_good(unit,slot)   [unit/cargo.c]
 *    0x181F:0xC68 -> func_00B2F0_cargo_slot_amount(unit,slot) [unit/cargo.c]
 *                    (the old report_screen.c externs had these two SWAPPED;
 *                    the byte truth: the 0xBE6 result is ADDED to the sprite
 *                    base @0x395B9, the 0xC68 result is compared with 0x64
 *                    @0x39600 -- good id added, quantity compared)
 *    0x181F:0x254 -> 0C36:000A sprite blit from the ICONS sheet [0x83E]
 *                    = blit_sprite()  [platform/render_glue.c]
 *    0x181F:0x302 -> func_005BFA is_xy_in_map_bounds(x,y)  [load_image]
 *    0x181F:0x768 -> func_0062B4 "terrain(x,y)&0x1F in {0x19,0x1A}" (is SEA)
 *                    (modern: the layer-0 read replaces the 0x37F:0x10E leaf)
 *    0x181F:0x22  -> func_002462 (file 0x2462): returns far ptr to the Nth
 *                    NUL-terminated string of the block at [0x2D42:0x2D44]
 *                    (repne scasb skip loop @0x2481..0x2489).  The modern
 *                    string arena makes this viceroy_str(handle).
 *    0x181F:0x100 -> func_002BC8: draw text CENTERED in a horizontal span:
 *                    pos = x + span/2 - strwidth/2, clamped >= 0
 *                    (@0x2BE4 sar both, @0x2BEF add, @0x2BF4 clamp), then
 *                    func_002B38 (0x13C-style draw at pos with colour).
 *    0x181F:0x13C -> func_002B38: draw text at (x,y) with explicit colour.
 *    0x191F:0x8B2 -> func_00E036 clipped vertical column stroke (ax=x,
 *                    dx=y0, bx=y1 + pushed colour & screen descriptor).
 *    0x191F:0x8BC -> func_00DFCC clipped horizontal row stroke (ax=x0,
 *                    dx=x1, bx=y).
 *    0x181F:0xCE  -> func_00E0A2 1-px rectangle outline (= draw_box()).
 *    0x181F:0xE2  -> func_00DB3A present band (0,0x140,0xC8) = vid_present().
 *    0x181F:0x3C0 -> func_004A80 modal input wait (OK/any-key dismiss).
 *    0x191F:0xF82 -> page09+0x2D0 = func_042F20 LOCATION-TEXT composer
 *                    (file 0x42F20..0x42FD5) = naval_loc_text() below.  The
 *                    old "draws the unit's own sprite" reading in REPORTS.md
 *                    was wrong: its result lands in the row buffer and is
 *                    drawn by the centered-text leaf 0x181F:0x100.
 *
 *  LABEL SLOTS (LABELS.TXT @MISC, loaded into [0x2DBA + i*2] by the loader
 *  loop @0x75226..0x7523C; modern: data_load.c viceroy_load_labels):
 *    [0x2E16] = @MISC 46  OK-button label          (footer)
 *    [0x2E22] = @MISC 52  'NAVAL ADVISER REPORT'   (title)
 *    [0x2E32] = @MISC 60  open-sea location name   (loc-text fallback)
 *    [0x2E34..0x2E3A] = @MISC 61..64  'Ship'/'Cargo'/'Location'/'Destination'
 *  No label text is embedded in the EXE (verified: re_work/strings.json has
 *  no NAVAL/SHIP/CARGO column strings) -- everything is GAME-DATA-driven.
 *
 *  DATA READS (all byte-cited in the bodies below):
 *    UnitRecord 0x3144 stride 0x1C: +0 x, +1 y, +2 class, +3 owner nibble,
 *      +8 (0x314C) order state, +9/+0xA (0x314D/E) goto dest, +0xC (0x3150)
 *      cargo slot count;  unit count [0x539C].
 *    @UNIT stat table 0x5230 stride 14 (the *14 chain @0x39630..0x39638):
 *      +0 word = type NAME handle.
 *    ColonyRecord 0x5D46 stride 0xCA: +0/+1 x/y, +2 name (loc-text).
 *    HOMEPORT name handles [0x838C + power*2]; high-seas name string at
 *      [0x5426 + power*0x34] (NAMES.TXT records).
 * ============================================================================ */
#ifdef _VICEROY_MODERN

#include <stdio.h>
#include <string.h>

#include "viceroy_types.h"
#include "dgroup.h"
#include "platform.h"

/* ---- shell / platform glue (same externs congress_screen.c uses) ---------- */
extern const char *viceroy_data_dir(void);
extern int         viceroy_interactive(void);
extern const char *viceroy_str(uint16_t handle);     /* runtime/data_load.c */
extern uint8_t     viceroy_layer_byte(int layer, int x, int y);

/* render_glue.c primitives (the byte-cited leaves' modern faces) */
extern void vid_text_color(int c);
extern void vid_text_xy(const char *s, int x, int y);
extern int  vid_text_width(const char *s);
extern int  vid_text_ctx_byte0(void);                 /* font ctx [0x89E] byte0 */
extern void vid_box_fill(int x, int y, int w, int h, uint8_t color);
extern void draw_box(int x1, int y1, int x2, int y2, int color); /* 0x181F:0xCE */
extern void blit_sprite(int desc, int id, int x, int y);         /* 0x181F:0x254 */

/* ported rule bodies this composer calls */
extern void market_set_active(int power);                        /* 0x181F:0x582 func_030550 */
extern int  func_005BFA_logic_sz_49(uint16_t x, uint16_t y);     /* 0x181F:0x302 in-bounds */
extern int16_t func_00B2A2_cargo_slot_good(int16_t unit, int16_t slot);   /* 0x181F:0xBE6 */
extern int16_t func_00B2F0_cargo_slot_amount(int16_t unit, int16_t slot); /* 0x181F:0xC68 */
extern void unit_figure_blit_64(int unit, int flags, int x, int box_w, int y);
                                                                 /* 0x181F:0x2BC metric 0x64 */
extern int  vid_poll_key(void);
extern void vid_delay_ms(int ms);

#define UREC8(i, off)  DG8(0x3144 + (unsigned)(i) * 0x1C + (off))

/* ----------------------------------------------------------------------------
 * text helpers -- the two resident text leaves the report body uses.
 * ---------------------------------------------------------------------------- */

/* 0x181F:0x13C -> func_002B38 (file 0x2B38): set colour, draw string at x,y. */
static void naval_text_at(const char *s, int x, int y, int color)
{
    vid_text_color(color);
    vid_text_xy(s, x, y);
}

/* 0x181F:0x100 -> func_002BC8 (file 0x2BC8): centre the string in the span
 * [x, x+span]: pos = x + (span>>1) - (width>>1) (@0x2BE4 sar ax,1 /
 * @0x2BE6 sar cx,1 / @0x2BEF add), clamped to >= 0 (@0x2BF4 or si,si/jge),
 * then the 0x13C-style draw (func_002B38) with the explicit colour. */
static void naval_text_centered(const char *s, int x, int span, int y, int color)
{
    int pos = x + (span >> 1) - (vid_text_width(s) >> 1);
    if (pos < 0)
        pos = 0;
    naval_text_at(s, pos, y, color);
}

/* terrain id at (x,y) -- the 0x37F:0x10E map-layer leaf behind func_00627A /
 * func_0062B4, replaced by the modern layer-0 accessor (the same substitution
 * render_glue.c makes for every map-layer read). */
static int naval_terrain_at(int x, int y)
{
    return (int)(viceroy_layer_byte(0, x, y) & 0x1F);  /* @0x62C6 and al,0x1F */
}

/* ----------------------------------------------------------------------------
 * naval_loc_text -- modern body of func_042F20 (0x191F:0xF82, page09+0x2D0,
 * file 0x42F20..0x42FD5): compose the LOCATION/DESTINATION name for a map
 * cell into buf.
 *   col  = power/owner index (the naval rows pass owner&0xF for the Location
 *          column @0x39694..0x3969B and the report player for the
 *          Destination column @0x39700)
 *   flag = 0 for Location (@0x39692 push 0), 1 for Destination (@0x396FE)
 * ---------------------------------------------------------------------------- */
void naval_loc_text(char *buf, int x, int y, int col, int flag)
{
    int cid, i;

    if (func_005BFA_logic_sz_49((uint16_t)x, (uint16_t)y) == 0) { /* @0x42F29 0x181F:0x302 */
        /* OFF-MAP cell (the high-seas band) */
        if (col >= 0 &&                                     /* @0x42F34 cmp [bp+0xC],0 / jl */
            (uint8_t)((col & 0xFF) - (x & 0xFF)) == 0x14)   /* @0x42F39..0x42F41 */
            strcat(buf, viceroy_str(DG16(0x838C + (unsigned)col * 2)));
                                  /* @0x42F43..0x42F4F push [bx-0x7C74] (= [0x838C+col*2],
                                   * the HOMEPORT name handle) ; 0x181F:0x16E strcat */
        else
            strcat(buf, viceroy_str(DG16(0x2E32)));         /* @0x42F58 push [0x2E32] @MISC 60 */
        return;                                             /* @0x42F56 leave/retf */
    }

    /* in-bounds: open sea + destination mode -> the power's home port */
    if (naval_terrain_at(x, y) == 0x1A && flag != 0) {      /* @0x42F64 0x181F:0x78C; @0x42F6B
                                                             * cmp ax,0x1A; @0x42F70 cmp [bp+0xE],0 */
        strcat(buf, viceroy_str(DG16(0x838C + (unsigned)col * 2)));   /* @0x42F74 -> 0x42F43 */
        return;
    }

    /* colony at the cell -> its name.  The 0x181F:0x7BE colony-at probe
     * (func_008D26) is the byte-cited table scan: match ColonyRecord x/y
     * (+0/+1, base 0x5D46 stride 0xCA, count [0x539E]) @0x8D5A..0x8D86;
     * its in-bounds/has-colony guards are short-circuits over the same scan. */
    cid = -1;
    for (i = 0; cid < 0 && i < (int16_t)DG16(0x539E); i++) {
        if (DG8(0x5D46 + (unsigned)i * 0xCA) == (uint8_t)x &&
            DG8(0x5D47 + (unsigned)i * 0xCA) == (uint8_t)y)
            cid = i;
    }
    DG16(0x8DC6) = (uint16_t)cid;                           /* @0x42F83 mov [0x8DC6],ax */
    if (cid >= 0) {                                         /* @0x42F86 or ax,ax / jl */
        strcat(buf, (const char *)&DG8(0x5D48 + (unsigned)cid * 0xCA));
                                  /* @0x42F8A imul 0xCA / add 0x5D48 (= record +2, the
                                   * colony NAME field); @0x42F95 0xD1D:0x7E4 strcpy */
        return;                                             /* @0x42F9A jmp exit */
    }

    /* fallback: "(x, y)" -- str_begin "(" (0x181F:0x11E = strcat dg 0x5E),
     * append x (0x182), ", " (0x1B4), append y (0x182), ")" (0x128 = strcat
     * dg 0x60).  @0x42F9F..0x42FCF; dg literals verified @file 0x1D9FE/0x1DA00. */
    {
        char t[24];
        snprintf(t, sizeof t, "(%d, %d)", x, y);
        strcat(buf, t);
    }
}

/* ----------------------------------------------------------------------------
 * naval_backdrop -- modern body of report_open(7) (func_037340, trampoline
 * @0x39E53) as the naval chrome invokes it @0x39403..0x39409 (push 7).
 * ---------------------------------------------------------------------------- */
static void naval_backdrop(void)
{
    char path[512];
    pik_image_t bg;

    /* "REPORT" (dg 0x11A2 @file 0x1EB42) + append-number 7 (0x181F:0x182
     * func_0029DE) = "REPORT7"; loader 0x181F:0x44E (func_076B9E) formats
     * "%s.PIK" (dg 0x2402 "PIK", fopen "rb" dg 0x2406 -- verified bytes
     * @0x1FDA2/0x1FDA6) and composes into the screen descriptor. */
    snprintf(path, sizeof path, "%s/REPORT7.PIK", viceroy_data_dir());
    if (pik_load(path, &bg) == 0) {                  /* @0x3737F lcall 0x181F:0x44E == 0 */
        uint8_t *fb = vid_framebuffer();
        int w = bg.w < VID_W ? bg.w : VID_W;
        int h = bg.h < VID_H ? bg.h : VID_H;
        int yy;
        for (yy = 0; yy < h; yy++)
            memcpy(fb + yy * VID_W, bg.pixels + yy * bg.w, (size_t)w);
        /* success path: upload the image's DAC window [0x98..0x98+0x64)
         * (@0x373B1 mov ax,0x98 / dx=0x64; 0x373BC lcall 0xC2E:0x22 with the
         * cursor latch [0x372] suppressed @0x373A4..0x373C1). */
        if (bg.has_pal)
            vid_set_palette_range(bg.pal, 0x98, 0x64);
        pik_free(&bg);
    } else {
        /* failure path @0x37389 or ax,ax / jne: 0x181F:0x484 (func_00DCD4 ->
         * 0xB9E:0xA box fill) fills the screen descriptor [0x2DA8..0x2DAE]
         * with colour 0x22 (@0x37395 mov al,0x22). */
        vid_box_fill(0, 0, VID_W, VID_H, 0x22);
    }
}

/* ----------------------------------------------------------------------------
 * naval_chrome -- modern body of func_0393F4 (file 0x393F4..0x3954B): the F7
 * page chrome.  Drawn at screen entry (@0x39555 call 0x39E3F) and again for
 * every new page (@0x397C9).
 * ---------------------------------------------------------------------------- */
void naval_chrome(int player)
{
    int i;

    market_set_active(player);          /* @0x393F8 push [bp+6]; 0x393FB lcall 0x181F:0x582
                                         * (func_030550: [0x9E12]=player,
                                         *  [0x84FC]=0x8808+player*0x13C) */
    naval_backdrop();                   /* @0x39403 push 7; 0x39406 call 0x39E53
                                         * -> 0x191F:0xF4A func_037340 report_open(7) */

    /* title: string [0x2E22] (@MISC 52) centered across the full width at
     * y=5, colour 0x90.  @0x3940C..0x39429: push 0x90,5,0x140,0,[0x2E22];
     * lcall 0x181F:0x22 (string fetch) ; push dx,ax ; lcall 0x181F:0x100
     * (centre-in-span draw). */
    naval_text_centered(viceroy_str(DG16(0x2E22)), 0, 0x140, 5, 0x90);

    /* the four column headers, centered per column box, y=0x1B, colour 0x92:
     *   'Ship'        [0x2E34] x=2    w=0x50   @0x39435..0x39462
     *   'Cargo'       [0x2E36] x=0x52 w=0x50   @0x39469..0x3948C
     *   'Location'    [0x2E38] x=0xA2 w=0x50   @0x39493..0x394B7
     *   'Destination' [0x2E3A] x=0xF2 w=0x4C   @0x394BE..0x394E2 */
    naval_text_centered(viceroy_str(DG16(0x2E34)), 0x02, 0x50, 0x1B, 0x92);
    naval_text_centered(viceroy_str(DG16(0x2E36)), 0x52, 0x50, 0x1B, 0x92);
    naval_text_centered(viceroy_str(DG16(0x2E38)), 0xA2, 0x50, 0x1B, 0x92);
    naval_text_centered(viceroy_str(DG16(0x2E3A)), 0xF2, 0x4C, 0x1B, 0x92);

    /* 3 vertical column rules: x = i*0x50 + 2 (i=1..3 -> 82/162/242),
     * y 0x19..0xB4, colour 0x77.  @0x394E5..0x39515: push descr+0x77;
     * ax=i*0x50+[bp-0x52](=2), dx=0x19, bx=0xB4; lcall 0x191F:0x8B2
     * (func_00E036 column stroke). */
    for (i = 1; i <= 3; i++)
        draw_box(i * 0x50 + 2, 0x19, i * 0x50 + 2, 0xB4, 0x77);

    /* 8 horizontal row rules: y = (i+2)*0x14 (i=0..7 -> 40..180 step 20),
     * x 2..0x13A, colour 0x77.  @0x39517..0x39548: ax=2, dx=0x13A,
     * bx=(i+2)*0x14; lcall 0x191F:0x8BC (func_00DFCC row stroke). */
    for (i = 0; i < 8; i++)
        draw_box(2, (i + 2) * 0x14, 0x13A, (i + 2) * 0x14, 0x77);
}

/* ----------------------------------------------------------------------------
 * naval_footer_button -- modern body of func_0373CA (file 0x373CA..0x37449,
 * trampoline @0x39E30): the report OK button.  func_03954C calls it
 * rpt_footer(-1,-2): push -1 then -2 -> x=[bp+6]=-2, y=[bp+8]=-1.
 * ---------------------------------------------------------------------------- */
void naval_footer_button(int x, int y)
{
    if (y < 0)  y = 0xB8;               /* @0x373CD cmp [bp+8],0 / jge ; 0x373D3 = 0xB8 */
    if (x == -1) x = 0x91;              /* @0x373D8 / 0x373DE = 0x91 */
    if (x == -2) x = 0x11E;             /* @0x373E3 / 0x373E9 = 0x11E */

    /* button outline (x,y)-(x+0x1D,y+0xD), colour 0x77: @0x373EE push
     * descriptor + y+0xD + 0x77; ax=x, bx=x+0x1D, dx=y; lcall 0x181F:0xCE
     * (func_00E0A2 rectangle outline, corners inclusive). */
    draw_box(x, y, x + 0x1D, y + 0x0D, 0x77);

    /* label [0x2E16] (@MISC 46) centered in [x, x+0x1E] at the box-centred
     * baseline y + 7 - fontheight/2, colour 0x92.  @0x37417 les bx,[0x89E];
     * al=es:[bx] (char height); shr al,1; neg(ax-7); add [bp+8]
     * @0x3741B..0x37427; then 0x181F:0x22 + 0x181F:0x100 @0x37435..0x37443. */
    naval_text_centered(viceroy_str(DG16(0x2E16)), x, 0x1E,
                        y + 7 - (vid_text_ctx_byte0() >> 1), 0x92);
}

/* present + modal wait -- the 0x181F:0xE2 (func_00DB3A, push 0,0x140,0xC8 =
 * full-frame present) / 0x181F:0x3C0 (func_004A80 input wait) pair that ends
 * every report page (@0x397AE..0x397C0 and @0x3986D..0x3987F).  Headless
 * runs do not block (the naval_glue.c ovl_yesno_dialog convention). */
static void naval_present_wait(void)
{
    vid_present();                      /* @0x397BB / 0x3987A lcall 0x181F:0xE2 */
    if (viceroy_interactive()) {        /* @0x397C0 / 0x3987F lcall 0x181F:0x3C0 */
        for (;;) {
            int k = vid_poll_key();
            if (k == VID_QUIT_REQUESTED) break;
            if (k == 0) { vid_delay_ms(16); continue; }
            break;                      /* any key dismisses the page */
        }
    }
}

/* ----------------------------------------------------------------------------
 * naval_screen_render -- modern body of func_03954C (file 0x3954C..0x39886):
 * THE NAVAL ADVISER.  Lists the player's ships (classes 0x0D..0x12) and the
 * player's land units standing on sea tiles (= units carried aboard), one row
 * each: unit figure, cargo icon run, class name, location, destination.
 * ---------------------------------------------------------------------------- */
void naval_screen_render(int player)
{
    char buf[0x50];                     /* [bp-0x50] row text buffer */
    int  base  = 2;                     /* [bp-0x56] @0x3955B mov ...,2 */
    int  row_y = 0x2A;                  /* [bp-0x58] @0x39560 mov ...,0x2A */
    int  shown = 0;                     /* [bp-0x52] @0x39567 (page-shown latch) */
    int  rows  = 0;                     /* [bp-0x64] @0x3956A */
    int  u;                             /* [bp-0x68] @0x3956D */
    int  nunits = (int16_t)DG16(0x539C);

    naval_chrome(player);               /* @0x39551 push [bp+6]; 0x39555 call 0x39E3F */

    for (u = 0; u < nunits; u++) {      /* @0x397E6 mov ax,[bp-0x68]; 0x397E9 cmp [0x539C],ax */
        int rec = 0x3144 + u * 0x1C;
        int cls, st, ux, uy, name_x, text_y;

        if ((DG8(rec + 3) & 0x0F) != (player & 0x0F))
            continue;                   /* @0x397F2 mov al,[bx+0x3147]; and 0xF;
                                         * 0x397F8 cmp al,[bp+6]; jne next */
        cls = DG8(rec + 2);             /* @0x39801 [bx+0x3146] */
        ux  = DG8(rec + 0);             /* @0x39813.. [bx+0x3144]/[bx+0x3145]
                                         * (the port-filter coords; re-read for
                                         * the location column @0x3967D/0x39686) */
        uy  = DG8(rec + 1);

        if (cls < 0x0D || cls > 0x12) { /* @0x39801 cmp 0xD / 0x39808 cmp 0x12 */
            /* land unit: row only when standing ON SEA (= aboard a ship).
             * @0x3981F lcall 0x181F:0x768 (func_0062B4: terrain&0x1F is
             * 0x19/0x1A); zero -> skip @0x39827..0x39829. */
            int t = naval_terrain_at(ux, uy);
            if (t != 0x19 && t != 0x1A)
                continue;
            /* figure at x = base+0x56 (88): entry @0x39836/0x39840 ->
             * 0x39574, bx=[bp-0x56]+0x56 @0x3957B..0x3957E. */
            unit_figure_blit_64(u, 0, base + 0x56, 0, row_y);
                                        /* @0x39586 lcall 0x181F:0x2BC --
                                         * regs ax=u dx=0 bx=x, stack
                                         * (row_y, 0, 0x64) @0x39574..0x39579 */
        } else {
            /* ship: figure at x = base (2): entry @0x39843..0x39852 jumps
             * into the row body at 0x39586 with bx=[bp-0x56]. */
            unit_figure_blit_64(u, 0, base, 0, row_y);
        }

        /* ---- cargo icon run (x from base+0x56, step 0xC, y=row+3) -------- */
        {
            int n = DG8(rec + 0x0C);    /* @0x395D3 mov al,[bx+0x3150] (slot count) */
            int xc = base + 0x56;       /* @0x39594..0x3959D (=[bp-0x5A]) */
            int k;
            for (k = 0; k < n; k++) {   /* @0x395D9 cmp ax,[bp-0x5C]; jle done */
                int good = func_00B2A2_cargo_slot_good((int16_t)u, (int16_t)k);
                                        /* @0x395E4 lcall 0x181F:0xBE6 -> [bp-0x62] */
                int qty  = func_00B2F0_cargo_slot_amount((int16_t)u, (int16_t)k);
                                        /* @0x395F5 lcall 0x181F:0xC68 -> [bp-0x54] */
                int sprbase = (qty < 0x64) ? 0x27 : 0x17;
                                        /* @0x39600 cmp ax,0x64; jl -> 0x395A8
                                         * mov ax,0x27; else @0x39605 mov ax,0x17 */
                if (good >= 0)
                    blit_sprite(0, sprbase + good, xc, row_y + 3);
                                        /* @0x395AE push [0x840],[0x83E] (ICONS),
                                         * y=[bp-0x6A]=row+3 @0x3958B..0x39591,
                                         * sprite=base+good @0x395B9,
                                         * clip &[0x2DA8], x=[bp-0x5A];
                                         * 0x395C3 lcall 0x181F:0x254 */
                xc += 0x0C;             /* @0x395C8 add [bp-0x5A],0xC */
            }
        }

        /* ---- class name (left-aligned, colour 0x61) ----------------------- */
        text_y = row_y + 6;             /* @0x3960A..0x39610 [bp-0x6A]=row+6 */
        name_x = base + 0x18;           /* @0x39613..0x39619 [bp-0x66]=base+0x18 */
        buf[0] = 0;                     /* @0x3961C mov byte [bp-0x50],0 */
        strcpy(buf, viceroy_str(DG16(0x5230 + (unsigned)cls * 14)));
                                        /* @0x39620..0x39649: bx=cls*14 (the
                                         * shl/add *14 chain @0x39630..0x39638);
                                         * push [bx+0x5230] (@UNIT name handle);
                                         * 0x181F:0x16E strcat */
        if (cls >= 0x0D && cls <= 0x12) /* @0x3964C cmp byte [si],0xD / 0x39651 cmp 0x12 */
            naval_text_at(buf, name_x, text_y, 0x61);          /* @0x39656 push 0x61 (x=26) */
        else
            naval_text_at(buf, name_x + 0x56, text_y, 0x61);   /* @0x39660..0x3966B (x=112) */

        /* ---- Location (centered in [base+0xA0, +0x50], colour 0x61) ------- */
        buf[0] = 0;                     /* @0x3968F mov [bp-0x50],ah(=0) */
        naval_loc_text(buf, ux, uy, DG8(rec + 3) & 0x0F, 0);
                                        /* @0x39692 push 0; owner&0xF @0x39694..
                                         * 0x3969B; 0x396A4 lcall 0x191F:0xF82 */
        naval_text_centered(buf, base + 0xA0, 0x50, text_y, 0x61);
                                        /* @0x396AC..0x396BF push 0x61,y,0x50,
                                         * base+0xA0; lcall 0x181F:0x100 */

        /* ---- Destination (centered in [base+0xF0, +0x4C], colour 0x61) ---- */
        st = DG8(rec + 0x08);           /* @0x396D0 [si+0x314C] order state */
        if (st == 3 || st == 0x0B || st == 2) {   /* @0x396D0/0x396D7/0x396DE */
            /* goto/route states: name the DEST cell [+0x314D/+0x314E] */
            int dx_ = DG8(rec + 0x09);  /* @0x396E9 [bx+0x314D] */
            int dy_ = DG8(rec + 0x0A);  /* @0x396F2 [bx+0x314E] */
            buf[0] = 0;                 /* @0x396FB */
            naval_loc_text(buf, dx_, dy_, player, 1);   /* @0x396FE push 1; push [bp+6];
                                                         * 0x39709 lcall 0x191F:0xF82 */
            naval_text_centered(buf, base + 0xF0, 0x4C, text_y, 0x61);
                                        /* @0x3977F..0x3978E lcall 0x181F:0x100 */
        } else if (func_005BFA_logic_sz_49((uint16_t)ux, (uint16_t)uy) == 0) {
                                        /* @0x39714..0x39724 lcall 0x181F:0x302;
                                         * NONZERO (on-map, no goto) -> NO
                                         * destination text (jne 0x39796) */
            /* off-map = the high-seas band: x encodes the heading. */
            uint8_t d = (uint8_t)((player & 0xFF) - (ux & 0xFF));
            buf[0] = 0;                 /* @0x39726 */
            if (d == 0x18 || d == 0x1C) /* @0x3972A..0x3973E (player-ux byte math) */
                strcat(buf, (const char *)&DG8(0x5426 + (unsigned)player * 0x34));
                                        /* @0x39740 imul 0x34 / add 0x5426;
                                         * 0x3974C lcall 0xD1D:0x7E4 strcpy
                                         * (westbound: the NAMES record string) */
            else if (d == 0x0C || d == 0x10)  /* @0x39754..0x39768 */
                strcat(buf, viceroy_str(DG16(0x838C + (unsigned)player * 2)));
                                        /* @0x3976A..0x39777 push [bx-0x7C74]
                                         * (= [0x838C+player*2] HOMEPORT);
                                         * 0x181F:0x16E strcat */
            naval_text_centered(buf, base + 0xF0, 0x4C, text_y, 0x61);
                                        /* @0x3977F..0x3978E (shared draw) */
        }
        /* else: ship on the map without goto orders -> blank destination
         * (@0x39724 jne 0x39796 skips the draw entirely). */

        /* ---- row advance + 7-row pagination ------------------------------- */
        row_y += 0x14;                  /* @0x39796 add [bp-0x58],0x14 */
        rows++;                         /* @0x3979A inc [bp-0x64] */
        if (rows >= 7) {                /* @0x3979D cmp [bp-0x64],7 / jl */
            naval_footer_button(-2, -1);/* @0x397A3 push -1; push -2; call 0x39E30 */
            naval_present_wait();       /* @0x397BB 0x181F:0xE2; 0x397C0 0x181F:0x3C0 */
            naval_chrome(player);       /* @0x397C5..0x397C9 call 0x39E3F (new page) */
            base = 2; row_y = 0x2A;     /* @0x397CF/0x397D4 */
            rows = 0; shown = 1;        /* @0x397D9/0x397DE mov [bp-0x52],1 */
        }
    }

    /* final footer: skipped only for a trailing EMPTY page (rows==0) when a
     * page was already shown.  @0x39856 cmp [bp-0x64],0 / jne; @0x3985C cmp
     * [bp-0x52],0 / jne exit. */
    if (rows != 0 || shown == 0) {
        naval_footer_button(-2, -1);    /* @0x39862..0x39867 call 0x39E30 */
        naval_present_wait();           /* @0x3986D..0x3987F 0xE2 + 0x3C0 */
    }
    (void)buf;
}

/* ============================================================================
 * STRONG OVERRIDES -- the legacy extern names (weak in
 * tools/generated/linkfloor_stubs.c) wired to the real chrome body.  The old
 * report_screen.c model split func_0393F4 into a "header pass" and a "footer
 * pass"; the bytes show ONE body (the page chrome) called from two sites
 * (@0x39555 entry, @0x397C9 re-pagination), so both names land here.
 * ============================================================================ */
void naval_footer_hdr(int player) { naval_chrome(player); }
void naval_footer(int player)     { naval_chrome(player); }

#endif /* _VICEROY_MODERN */
