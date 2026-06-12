/* ============================================================================
 * menu_runner.c -- THE @BEGINMENU DATA-DRIVEN MENU / BOXED-TEXT RUNNER
 *                  (the 0x181F:0x3FE engine), ported.  ROUTE_B_PLAN 3.1.
 * ----------------------------------------------------------------------------
 * THE ORIGINAL CHAIN (every hop byte-verified against re_work/VICEROY.EXE):
 *
 *   caller:  lea bx,[KEY] ; lcall 0x181F:0x3FE          (e.g. @0x075C64 lea
 *            bx,[0x2345] "BEGINMENU"; 39 static-id sites + 6 dynamic-BX sites
 *            enumerated by scanning for 9a fe 03 1f 18)
 *   0x181F:0x3FE -> file 0x6F594 (page 0x17 +0x3744) SHIM:
 *            mov ax,bx           ; AX = key-string near ptr      @asm 0x06F594
 *            lea bx,[0x87C]      ; BX = file base-name "GAME"    @asm 0x06F596
 *                                ;   (DS:0x87C = "GAME" @file 0x1E21C -- the
 *                                ;    GAME.TXT base name, NOT a descriptor)
 *            sub dx,dx           ; DX = 0 = no preselect         @asm 0x06F59A
 *            push cs; call 0x6F7EF                               @asm 0x06F59C
 *   (sibling shim @0x06F5A2: mov dx,ax; mov ax,bx -- the PRESELECT variant:
 *    DX = preselected row, consumed as [bp-0x16a] by the template engine)
 *   0x6F7EF = ljmp 0x181F:0x998 -> file 0x6F51A  menu_lookup_run:
 *            rec = 0x191F:0x182 (func_06F0F4 template engine)    @asm 0x06F523
 *            if (rec) { ret = 0x191F:0x16A (func_06E3D0 modal)   @asm 0x06F535
 *                       0x191F:0x1A8 free }                      @asm 0x06F542
 *            return ret (0 when the section is missing)          @asm 0x06F547
 *
 * THIS FILE collapses that chain into one modern, functional runner over the
 * platform layer (GAME.TXT via stdio like main_modern.c load_beginmenu /
 * naval_glue.c load_msg -- NOT the DOS file reader; text via viceroy_font()).
 * Every STRUCTURAL element is cited to the original bytes below; the two
 * spots where the modern build substitutes (frame art, palette mapping of the
 * style words) are explicitly marked RECONSTRUCTED.
 *
 * === TEMPLATE ENGINE (func_06F0F4, file 0x6F0F4..0x6F519, fully decoded) ===
 *  entry: AX=key ptr, BX=file-base ptr, DX=preselect ([bp-0x16a] = push dx
 *         right after ENTER 0x168 @asm 0x06F0F8).
 *  state=1, option_counter=1                                @asm 0x06F0FD..0x06F103
 *  open section (0x0D1D:0x7E4 fmt @0x2478 + 0x191F:0x928)   @asm 0x06F114..0x06F12E
 *  per line (0x191F:0x91C):
 *    blank line            -> state++ (>=3 stops)           @asm 0x06F185..0x06F18C
 *    line[0]=='@'          -> directive, keyword table at DS:0x1FC7
 *                             (raw "OPTIONS\0PROMPT\0TEXT\0SMALLFONT\0Y\0X\0
 *                              WIDTH\0LENGTH\0CHECKBOX\0DEFAULT\0" @file 0x1F967)
 *      @OPTIONS  -> state=2                                 @asm 0x06F1A4/0x06F1CF
 *      @PROMPT   -> state=2                                 @asm 0x06F1BC/0x06F1CF
 *      @TEXT     -> state=1                                 @asm 0x06F1D8/0x06F1EB
 *      @SMALLFONT-> panel font ctx = [0x89E]/[0x8A0]        @asm 0x06F1F4..0x06F216
 *      @Y=N      -> skip non-digits (ctype tbl cs:[0x27ED]&4), rec[+0xE]=atoi
 *                                                           @asm 0x06F21E..0x06F25E
 *      @X=N      -> rec[+0xC]=atoi                          @asm 0x06F266..0x06F2A6
 *      @WIDTH=N  -> width floor (helper 0x191F:0x910)       @asm 0x06F2AE..0x06F2F9
 *      @LENGTH=N -> [0xA5B6]=atoi if unset (edit-field len) @asm 0x06F300..0x06F347
 *      @CHECKBOX -> checkbox=1; rec[+0xA]|=5                @asm 0x06F34E..0x06F36B
 *      @DEFAULT=N-> if preselect==0: cursor row = atoi      @asm 0x06F374..0x06F3FB
 *      unknown @ -> state=3 (next section header ENDS us)   @asm 0x06F402
 *    state==1 text -> append LABEL widget (0x191F:0x8C6)    @asm 0x06F410..0x06F432
 *    state==2 text -> append OPTION widget (0x191F:0x176)
 *                     with VALUE = option_counter (push word [bp-0x162])
 *                                                           @asm 0x06F47E..0x06F4A1
 *                     counter++ ONLY here -> option values are 1-BASED IN
 *                     @OPTIONS ORDER                        @asm 0x06F4D9
 *                     if counter==preselect/default: cursor=this widget
 *                                                           @asm 0x06F4BC..0x06F4D5
 *                     checkbox: widget[+6]=0 (unchecked)    @asm 0x06F4B2..0x06F4B6
 *  fail (no section/rec): [0x1F5E]=[0x1F5C]=[0x1F60]=0xFFFF, [0x1F66]=0,
 *  return NULL -> runner returns 0                          @asm 0x06F4F5..0x06F518
 *
 * === GEOMETRY (constructor func_06C520 + finalize func_06D316) ===
 *  border word  +0x46 = (flags&0x10)?0:3  = 3               @asm 0x06C5DA..0x06C5E9
 *  inset  word  +0x48 = (flags&0x10)?0:2  = 2               @asm 0x06C5ED..0x06C5F5
 *  min content width +0x28 = 0x50 (80)                      @asm 0x06C5A6 (26 c7 47 28 50 00)
 *  default style words [0x1F3C..0x1F44]={7,7,8,8,0} -> panel[+0x3C..+0x44]
 *    (normal text pair (7,7), HIGHLIGHT pair (8,8))         @asm 0x06C5B7..0x06C5D6
 *    DGROUP init image bytes @file 0x1F8DC: 07 00 07 00 08 00 08 00 00 00
 *  default X/Y: panel[+0xC]/[+0xE] = [0x1F58]/[0x1F5A] = 0xFFFF = CENTER
 *    sentinel (then 0x1F58/0x1F5A reset)                    @asm 0x06C588.. (banner)
 *  per-line width = text_px + 10 margin                     @asm 0x06CCE3 (05 0a 00)
 *  content_w = max(80, longest_line+10, @WIDTH)             @asm 0x06D392
 *  X = (@x==-1) ? (320-box_w)/2 : @x                        @asm 0x06D522 (sar;sub 0xA0;neg)
 *  Y = (@y==-1) ? (200-box_h)/2 : @y                        @asm 0x06D53B (sar;sub 0x64;neg)
 *  clamp: X+box_w<=0x140, Y+box_h<=0xC8 (shift left/up)     @asm 0x06D563 / 0x06D571
 *  height terms: rows + 3 gaps (+6 with title match, +3 option-block pad)
 *                                                           @asm 0x06D363/0x06D509/0x06D513/0x06D61D
 *
 * === DRAW PASS (func_06D9CC row chain) ===
 *  row x = base_x - panel[+0x22] - 1 where base_x = panel[+0x24]+inset+4
 *        => content_x + inset - 1                           @asm 0x06DA54..0x06DA5B
 *  row pitch: y += text_height + panel[+0x46](=3)           @asm 0x06DC10..0x06DC17
 *  SELECTED row drawn with the +0x40/+0x42 style pair (8,8); others with
 *  +0x3C/+0x3E (7,7) -- a STYLE SWITCH, no filled-rect      @asm 0x06DA85..0x06DAF0
 *  checkbox glyph: option child[+1] = 0x5D - (widget[+6]<=1) (glyph 0x5C/0x5D)
 *                                                           @asm 0x06DB5C..0x06DB70
 *  frame: the original blits WOODFRAM through 0x181F:0x510 (site @0x0263D6)
 *  and saves the backdrop via 0x1A1F:0x364                  @asm 0x06E53F
 *
 * === MODAL LOOP (func_06E3D0, file 0x6E3D0..0x6EED4, key arms re-verified) ===
 *  key source 0x181F:0x3E0; dispatch on the row list:
 *   0x20 SPACE -> commit/toggle                             @asm 0x06E9CD (cmp ax,0x20)
 *   0x0D ENTER -> commit                                    @asm 0x06E9DA (sub ax,0xd)
 *   0x1B ESC   -> panel[+0] = 0xFFFF and exit               @asm 0x06E9E2..0x06E9EA
 *   0x13B F1   -> commit (help gate [0x1F66])               @asm 0x06EC2E (sub ax,0x13b)
 *   0x148 UP   -> cursor = cursor->prev (+0x14/+0x16), wrap to TAIL panel[+0x70],
 *                 skip rows with bit0 set, give up after 2 wraps
 *                                                           @asm 0x06EAEC..0x06EB49
 *   0x150 DOWN -> cursor = cursor->next (+0x10/+0x12), wrap to HEAD panel[+0x54]
 *                                                           @asm 0x06EA88..0x06EAE8
 *   other key  -> hotkey walk: first row whose widget[+2]==key becomes the
 *                 cursor (MOVES the highlight, does not commit)
 *                                                           @asm 0x06EBC0..0x06EBE0
 *  COMMIT: panel[+0] = cursor_widget[+4] (the 1-based option VALUE)
 *                                                           @asm 0x06EB9F..0x06EBAA
 *  checkbox commit: SPACE toggles widget[+6] 0<->1 (cmp/sbb/neg), ENTER exits
 *                                                           @asm 0x06EB5C..0x06EB80
 *  TEARDOWN: [0x1F5C]=[0x1F5E]=[0x1F60]=0xFFFF; [0x1F8A]=0; [0x1F66]=0;
 *  checkbox mode rebuilds the option bitmask [0x1F54] (bit n = 1<<(n-1), the
 *  same encoding as opt_flag_set @asm 0x06F558..0x06F567)   @asm 0x06EE68..0x06EEB6
 *  return AX = panel[+0]                                    @asm 0x06EECC..0x06EED1
 *
 * RETURN SEMANTICS (the contract every call site relies on):
 *   >=1  the picked option (1-based in @OPTIONS order)
 *   -1   dismissed with ESC (0xFFFF as int16)
 *    0   section missing / no record (and 0 = "ok" for @CHECKBOX panels)
 *   (func_0759E8 dispatches with `dec ax; jge` @asm 0x075C6D -- <1 aborts)
 *
 * MODERN SUBSTITUTIONS (explicit, per the honesty rules):
 *   - frame art: WOODFRAM sprite frame (0x181F:0x510) is not decoded as art;
 *     centered panels get vid_box_fill+vid_box_outline placeholders.
 *     RECONSTRUCTED colors (fill 0, frame 15).
 *   - style words 7/8 are used directly as palette indices; the original
 *     resolves them through the text-context leaves (0x181F:0x100 family).
 *     RECONSTRUCTED mapping (the init VALUES 7/7/8/8 are byte-cited).
 *   - fonts: the original uses the staged ctx ([0x89E] FONTINTR/FONTTINY);
 *     the modern build has FONTSMAL.FF loaded -- @SMALLFONT is a no-op.
 *   - disabled-row skip (widget[0] bit0 @asm 0x06EAD9) has no modern data
 *     source yet; all parsed rows are selectable.
 *   - key codes are the SDL keysyms the platform layer delivers, mapped 1:1
 *     onto the cited BIOS codes (0x148->SDLK_UP etc., see KEY_* below).
 * ============================================================================ */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "viceroy_types.h"
#include "dgroup.h"
#include "platform.h"

/* main_modern.c / platform glue (same externs naval_glue.c uses) */
extern const char *viceroy_data_dir(void);
extern int         viceroy_interactive(void);
extern ff_font_t  *viceroy_font(void);

/* render_glue.c primitives */
extern void vid_box_fill(int x, int y, int w, int h, uint8_t color);
extern void vid_box_outline(int x, int y, int w, int h, uint8_t color);
extern void vid_text_color(int c);
extern void vid_text_xy(const char *s, int x, int y);
extern int  vid_text_width(const char *s);

/* ---- byte-cited layout constants (sources in the banner) ------------------ */
#define MR_BORDER      3      /* panel[+0x46]   @asm 0x06C5E9 */
#define MR_INSET       2      /* panel[+0x48]   @asm 0x06C5F5 */
#define MR_MIN_W       0x50   /* panel[+0x28]   @asm 0x06C5A6 */
#define MR_LINE_MARGIN 10     /* line+0x0A      @asm 0x06CCE3 */
#define MR_GAP         3      /* block pads     @asm 0x06D513 / 0x06D61D */
#define MR_STYLE_NORM  7      /* [0x1F3C]/[0x1F3E] -> panel[+0x3C..]  @asm 0x06C5B7 */
#define MR_STYLE_HI    8      /* [0x1F40]/[0x1F42] -> panel[+0x40..]  @asm 0x06C5C5 */
#define MR_SCREEN_W    0x140  /* right clamp    @asm 0x06D563 */
#define MR_SCREEN_H    0xC8   /* bottom clamp   @asm 0x06D571 */

/* SDL keysyms (script_input.c vocabulary) <- original BIOS codes */
#define MR_KEY_UP      1073741906   /* <- 0x148  @asm 0x06EC36 */
#define MR_KEY_DOWN    1073741905   /* <- 0x150  @asm 0x06EC3E */
#define MR_KEY_ENTER   13           /* <- 0x0D   @asm 0x06E9DA */
#define MR_KEY_ESC     27           /* <- 0x1B   @asm 0x06E9E2 */
#define MR_KEY_SPACE   32           /* <- 0x20   @asm 0x06E9CD */

#define MR_MAX_PROMPT  8
#define MR_MAX_OPT     12
#define MR_LINE_LEN    96

typedef struct {
    char prompt[MR_MAX_PROMPT][MR_LINE_LEN];
    int  nprompt;
    char opt[MR_MAX_OPT][MR_LINE_LEN];
    int  nopt;
    int  x, y;          /* @X/@Y; -1 = centered ([0x1F58]/[0x1F5A] init 0xFFFF) */
    int  width;         /* @WIDTH floor (0 = none) */
    int  checkbox;      /* @CHECKBOX -> rec[+0xA]|=5 */
    int  smallfont;     /* @SMALLFONT (modern no-op; ctx [0x89E]) */
    int  length;        /* @LENGTH (edit fields; recorded, not yet consumed) */
    int  cur_row;       /* @DEFAULT / DX preselect ([bp-0x16a]) */
} mr_panel_t;

/* ----------------------------------------------------------------------------
 * Section loader = func_06F0F4's token loop over stdio (cites in the banner).
 * Case-insensitive directive match (file has "@width", table has "WIDTH";
 * matcher 0x0D1D:0x816 is the runtime's prefix match).
 * -------------------------------------------------------------------------- */
static int mr_prefix(const char *s, const char *kw)
{
    while (*kw) {
        char a = *s++, b = *kw++;
        if (a >= 'a' && a <= 'z') a = (char)(a - 32);
        if (a != b) return 1;
    }
    return 0;
}

static int mr_atoi_skip(const char *s)
{   /* skip to the first digit (ctype walk cs:[0x27ED]&4 @asm 0x06F236..0x06F24D) */
    while (*s && (*s < '0' || *s > '9')) s++;
    return atoi(s);
}

static int mr_load_section(const char *key, int preselect, mr_panel_t *m)
{
    char path[512], line[256];
    size_t klen = strlen(key);
    FILE *f;
    int in = 0, state = 1;                  /* [bp-4]=1 @asm 0x06F100 */

    memset(m, 0, sizeof *m);
    m->x = -1; m->y = -1;                   /* center sentinels ([0x1F58]/[0x1F5A]=0xFFFF) */
    m->cur_row = preselect;                 /* entry DX -> [bp-0x16a] @asm 0x06F0F8 */

    /* base name "GAME" = DS:0x87C (@file 0x1E21C); 0x0D1D:0x7E4 formats the
     * path @asm 0x06F114..0x06F121; modern: <data>/GAME.TXT */
    snprintf(path, sizeof path, "%s/GAME.TXT", viceroy_data_dir());
    f = fopen(path, "r");
    if (!f) return -1;                      /* open_section fail -> rec NULL -> 0 */

    while (fgets(line, sizeof line, f)) {
        char *p = line + strspn(line, " \t");
        size_t len = strcspn(p, "\r\n");
        p[len] = 0;

        if (!in) {                          /* 0x191F:0x928 open section @asm 0x06F126 */
            in = (p[0] == '@' && !strncmp(p + 1, key, klen) && p[1 + klen] == 0);
            continue;
        }
        if (!p[0]) {                        /* blank -> state++ @asm 0x06F185..0x06F189 */
            if (++state >= 3) break;        /* @asm 0x06F4EC cmp [bp-4],3 */
            continue;
        }
        if (p[0] == '@') {                  /* directive @asm 0x06F193 cmp byte,0x40 */
            const char *d = p + 1;          /* @asm 0x06F1AA inc ax */
            if      (!mr_prefix(d, "OPTIONS"))   state = 2;          /* @asm 0x06F1CF */
            else if (!mr_prefix(d, "PROMPT"))    state = 2;          /* @asm 0x06F1BC */
            else if (!mr_prefix(d, "TEXT"))      state = 1;          /* @asm 0x06F1EB */
            else if (!mr_prefix(d, "SMALLFONT")) m->smallfont = 1;   /* @asm 0x06F207 */
            else if (!mr_prefix(d, "WIDTH"))     m->width  = mr_atoi_skip(d); /* @asm 0x06F2E8 */
            else if (!mr_prefix(d, "LENGTH")) {                      /* @asm 0x06F33B */
                if (m->length == 0) m->length = mr_atoi_skip(d);
            }
            else if (!mr_prefix(d, "CHECKBOX"))  m->checkbox = 1;    /* @asm 0x06F363 */
            else if (!mr_prefix(d, "DEFAULT")) {                     /* @asm 0x06F3E5 */
                if (m->cur_row == 0) m->cur_row = mr_atoi_skip(d);
            }
            else if (!mr_prefix(d, "Y"))         m->y = mr_atoi_skip(d); /* @asm 0x06F25E */
            else if (!mr_prefix(d, "X"))         m->x = mr_atoi_skip(d); /* @asm 0x06F2A6 */
            else { state = 3; break; }      /* unknown @ = next section @asm 0x06F402 */
            continue;
        }
        if (state == 1) {                   /* label line @asm 0x06F410 */
            if (m->nprompt < MR_MAX_PROMPT)
                strncpy(m->prompt[m->nprompt++], p, MR_LINE_LEN - 1);
        } else if (state == 2) {            /* option line, value=counter @asm 0x06F47E */
            if (m->nopt < MR_MAX_OPT)
                strncpy(m->opt[m->nopt++], p, MR_LINE_LEN - 1);
        }
    }
    fclose(f);
    return in ? 0 : -1;
}

/* ----------------------------------------------------------------------------
 * Geometry finalize = func_06D316 (formula cites in the banner).
 * -------------------------------------------------------------------------- */
typedef struct { int x, y, w, h, text_x, text_y0, pitch; } mr_geom_t;

static void mr_finalize_geometry(const mr_panel_t *m, mr_geom_t *g)
{
    ff_font_t *f = viceroy_font();
    int th = f ? f->maxh : 8;
    int longest = 0, i, w;
    int content_w, rows_h;

    g->pitch = th + MR_BORDER;              /* y += text_h + panel[+0x46] @asm 0x06DC13 */

    for (i = 0; i < m->nprompt; i++) {
        w = vid_text_width(m->prompt[i]);
        if (w > longest) longest = w;
    }
    for (i = 0; i < m->nopt; i++) {
        w = vid_text_width(m->opt[i]);
        if (w > longest) longest = w;
    }

    /* content_w = max(80, longest+10, @WIDTH)  @asm 0x06D392 */
    content_w = MR_MIN_W;
    if (longest + MR_LINE_MARGIN > content_w) content_w = longest + MR_LINE_MARGIN;
    if (m->width > content_w)                 content_w = m->width;

    g->w = content_w + 2 * MR_BORDER;       /* + border pads @asm 0x06D4BA / 0x06D606 */

    rows_h = m->nprompt * g->pitch;
    if (m->nopt)
        rows_h += MR_GAP + m->nopt * g->pitch;   /* option block +3 @asm 0x06D606/0x06D61D */
    g->h = rows_h + 2 * (MR_BORDER + MR_INSET) - MR_BORDER + MR_GAP;

    /* X/Y center-or-anchor @asm 0x06D522 / 0x06D53B */
    g->x = (m->x == -1) ? (320 - g->w) / 2 : m->x;
    g->y = (m->y == -1) ? (200 - g->h) / 2 : m->y;
    /* clamp @asm 0x06D563 / 0x06D571 */
    if (g->x + g->w > MR_SCREEN_W) g->x = MR_SCREEN_W - g->w;
    if (g->y + g->h > MR_SCREEN_H) g->y = MR_SCREEN_H - g->h;
    if (g->x < 0) g->x = 0;
    if (g->y < 0) g->y = 0;

    /* row text x = content_x + inset - 1  @asm 0x06DA54..0x06DA5B */
    g->text_x  = g->x + MR_BORDER + MR_INSET - 1;
    g->text_y0 = g->y + MR_BORDER + MR_INSET;
}

/* ---- background save/restore (0x1A1F:0x364 save @asm 0x06E53F; restore on
 *      teardown via the dispose path @asm 0x06EEC4) ------------------------- */
static uint8_t mr_bg[VID_W * VID_H];

static void mr_save_bg(const mr_geom_t *g)
{
    uint8_t *fb = vid_framebuffer();
    int r;
    for (r = 0; r < g->h && g->y + r < VID_H; r++)
        memcpy(mr_bg + r * g->w, fb + (g->y + r) * VID_W + g->x,
               (size_t)((g->x + g->w <= VID_W) ? g->w : VID_W - g->x));
}

static void mr_restore_bg(const mr_geom_t *g)
{
    uint8_t *fb = vid_framebuffer();
    int r;
    for (r = 0; r < g->h && g->y + r < VID_H; r++)
        memcpy(fb + (g->y + r) * VID_W + g->x, mr_bg + r * g->w,
               (size_t)((g->x + g->w <= VID_W) ? g->w : VID_W - g->x));
}

/* ---- one draw pass (func_06D9CC row chain over modern primitives) --------- */
static void mr_draw(const mr_panel_t *m, const mr_geom_t *g, int sel,
                    const uint8_t *checks)
{
    int i, y = g->text_y0;
    char buf[MR_LINE_LEN + 4];

    /* frame only for CENTERED panels (anchored panels -- @y set, e.g.
     * @BEGINMENU y on the OPENMENU plate -- draw rows straight onto the
     * caller's backdrop, matching the original frames).  The original frame
     * is the WOODFRAM blit 0x181F:0x510 (site @0x0263D6); RECONSTRUCTED
     * placeholder: fill 0 + outline 15. */
    if (m->x == -1 && m->y == -1) {
        vid_box_fill(g->x, g->y, g->w, g->h, 0x00);
        vid_box_outline(g->x, g->y, g->w, g->h, 0x0F);
    }

    for (i = 0; i < m->nprompt; i++, y += g->pitch) {
        vid_text_color(MR_STYLE_NORM);      /* pair (7,7) panel[+0x3C] @asm 0x06C5B7 */
        vid_text_xy(m->prompt[i], g->text_x, y);
    }
    if (m->nopt) y += MR_GAP;               /* option-block pad @asm 0x06D513 */

    for (i = 0; i < m->nopt; i++, y += g->pitch) {
        const char *s = m->opt[i];
        if (m->checkbox) {
            /* original mark = glyph 0x5D-(widget[+6]<=1) (0x5C/0x5D)
             * @asm 0x06DB5C..0x06DB70; modern ASCII substitute */
            snprintf(buf, sizeof buf, "[%c] %s", checks[i] ? 'x' : ' ', s);
            s = buf;
        }
        /* selected row -> style pair (8,8) panel[+0x40] @asm 0x06DA85..0x06DAF0 */
        vid_text_color((i + 1 == sel) ? MR_STYLE_HI : MR_STYLE_NORM);
        vid_text_xy(s, g->text_x, y);
    }
    vid_present();
}

/* ---- teardown latches (@asm 0x06EE68..0x06EEB6) --------------------------- */
static void mr_teardown(const mr_panel_t *m, const uint8_t *checks)
{
    DG16(0x1F5C) = 0xFFFF;                  /* @asm 0x06EE68 */
    DG16(0x1F5E) = 0xFFFF;                  /* @asm 0x06EE6E */
    DG16(0x1F60) = 0xFFFF;                  /* @asm 0x06EE71 */
    DG16(0x1F8A) = 0;                       /* @asm 0x06EE76 */
    DG16(0x1F66) = 0;                       /* @asm 0x06EE79 */
    if (m->checkbox) {                      /* rebuild [0x1F54] @asm 0x06EE7C..0x06EEB6 */
        uint16_t mask = 0;
        int i;
        for (i = 0; i < m->nopt; i++)
            if (checks[i]) mask |= (uint16_t)(1 << i);  /* bit=1<<(n-1) @asm 0x06F565 */
        DG16(0x1F54) = mask;
    }
}

/* ----------------------------------------------------------------------------
 * menu_run_key -- the full runner (template + modal).  preselect = entry DX.
 * -------------------------------------------------------------------------- */
int menu_run_key(const char *key, int preselect)
{
    mr_panel_t m;
    mr_geom_t g;
    uint8_t checks[MR_MAX_OPT];
    int sel, ret, i;

    if (!key || !key[0])
        return 0;
    if (mr_load_section(key, preselect, &m) != 0)
        return 0;                           /* rec NULL -> 0 @asm 0x06F51E/0x06F547 */

    memset(checks, 0, sizeof checks);       /* widget[+6]=0 @asm 0x06F4B6 */

    sel = (m.cur_row >= 1 && m.cur_row <= m.nopt) ? m.cur_row : 1;

    /* ---- non-interactive (smoke/headless-without-script): log + default ----
     * the original blocks on 0x181F:0x3E0; the modern build follows the
     * naval_glue.c ovl_yesno_dialog convention instead of blocking.  (When a
     * determinism script drives the shell, viceroy_interactive() is 1 and the
     * REAL modal loop below consumes the scripted keys -- font or not, so the
     * rig can never wedge on an unconsumed queue.) */
    if (!viceroy_interactive()) {
        printf("menu [%s]: %s\n", key, m.nprompt ? m.prompt[0] : "");
        for (i = 0; i < m.nopt; i++)
            printf("   %d) %s%s\n", i + 1, m.opt[i], (i + 1 == sel) ? "  *" : "");
        mr_teardown(&m, checks);
        return m.checkbox ? 0 : (m.nopt ? sel : 1);
    }

    mr_finalize_geometry(&m, &g);
    mr_save_bg(&g);                         /* 0x1A1F:0x364 @asm 0x06E53F */
    mr_draw(&m, &g, m.nopt ? sel : 0, checks);

    if (m.nopt == 0) {
        /* pure boxed text (message panel): any key dismisses; ESC = -1.
         * (row list empty -> button-only nav @asm 0x06E88F..0x06E9C9) */
        for (;;) {
            int k = vid_poll_key();
            if (k == VID_QUIT_REQUESTED) { ret = -1; break; }
            if (k == 0) { vid_delay_ms(16); continue; }
            ret = (k == MR_KEY_ESC) ? -1 : 1;
            break;
        }
        goto out;
    }

    for (;;) {
        int k = vid_poll_key();
        if (k == VID_QUIT_REQUESTED) { ret = -1; break; }
        if (k == 0) { vid_delay_ms(16); continue; }

        if (k == MR_KEY_ESC) {              /* panel[+0]=0xFFFF @asm 0x06E9EA */
            ret = -1;
            break;
        }
        if (k == MR_KEY_ENTER) {            /* commit @asm 0x06EB4C/0x06EB9F */
            ret = m.checkbox ? 0 : sel;     /* checkbox: ENTER exits @asm 0x06EB7A..0x06EB80 */
            break;
        }
        if (k == MR_KEY_SPACE) {
            if (m.checkbox) {               /* toggle widget[+6] @asm 0x06EB69..0x06EB76 */
                checks[sel - 1] ^= 1;
                mr_draw(&m, &g, sel, checks);
                continue;
            }
            ret = sel;                      /* non-checkbox SPACE commits @asm 0x06E9CD */
            break;
        }
        if (k == MR_KEY_DOWN) {             /* next, wrap to head @asm 0x06EA88..0x06EABF */
            sel = (sel % m.nopt) + 1;
            mr_draw(&m, &g, sel, checks);
            continue;
        }
        if (k == MR_KEY_UP) {               /* prev, wrap to tail @asm 0x06EAEC..0x06EB2B */
            sel = (sel > 1) ? sel - 1 : m.nopt;
            mr_draw(&m, &g, sel, checks);
            continue;
        }
        /* hotkey walk (widget[+2]==key MOVES the cursor) @asm 0x06EBC0..0x06EBE0:
         * modern: '1'..'9' = row index; letters match the row's first char. */
        if (k >= '1' && k < '1' + m.nopt) {
            sel = k - '0';
            mr_draw(&m, &g, sel, checks);
            continue;
        }
        if (k > 32 && k < 127) {
            char up = (char)((k >= 'a' && k <= 'z') ? k - 32 : k);
            for (i = 0; i < m.nopt; i++) {
                char c0 = m.opt[i][strspn(m.opt[i], " \t")];
                if (c0 >= 'a' && c0 <= 'z') c0 = (char)(c0 - 32);
                if (c0 == up) { sel = i + 1; mr_draw(&m, &g, sel, checks); break; }
            }
            continue;
        }
    }

out:
    mr_restore_bg(&g);                      /* dispose/restore @asm 0x06EEC4 */
    vid_present();
    mr_teardown(&m, checks);
    return ret;
}

/* ----------------------------------------------------------------------------
 * menu_run_boxed -- the `lea bx,[id]; lcall 0x181F:0x3FE` protocol: id is the
 * DGROUP offset of the key string (resolved through the loaded DGROUP image,
 * so DS:0x2345 really is "BEGINMENU" at runtime).  Shim @asm 0x06F594.
 * -------------------------------------------------------------------------- */
int menu_run_boxed(uint16_t key_off)
{
    return menu_run_key((const char *)&DG8(key_off), 0);   /* DX=0 @asm 0x06F59A */
}

/* ----------------------------------------------------------------------------
 * Strong overrides for the wrapper names older ports call (the weak link-floor
 * stubs in tools/generated/linkfloor_stubs.c yield to these):
 *   ov_msg_show      -- options_dialog.c sites (NOCITY/GAMEOPTIONS/...)
 *   mn_opt_register  -- menu.c colony-service arms (ONE_ENTER/ONE_LEAVE)
 *   opt_run_menu     -- menu.c opt_register/opt_set_* emit path (0x181F:0x998)
 * -------------------------------------------------------------------------- */
void ov_msg_show(int key)      { (void)menu_run_boxed((uint16_t)key); }
void mn_opt_register(int key)  { (void)menu_run_boxed((uint16_t)key); }
void opt_run_menu(int key, int field)
{
    (void)field;                            /* builders pass DX=0 @asm 0x06F5C0 etc. */
    (void)menu_run_boxed((uint16_t)key);
}
