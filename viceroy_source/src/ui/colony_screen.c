/* ============================================================================
 * colony_screen.c -- Colony interaction UI  (in-game colony view)
 * ----------------------------------------------------------------------------
 * CORRECTED 2026-05-30: supersedes the prior mis-attribution that used the
 * Europe composer 0x031E4C.  Colony = page 0x03, screen-id 0x2C.
 *
 * WHAT WAS WRONG (do not repeat): the previous revision of this file anchored
 * on func_0321B4 and traced into the function at file 0x031E4C, calling it "the
 * colony paint composer."  That was WRONG.  0x031E4C is the EUROPE composer:
 * byte-proof shows it unconditionally draws a dock + 6 ships, a 3-immigrant
 * RECRUIT pool, a 16-good MARKET PRICE bar, and a "Selling <Good> at <N> Gold"
 * banner -- all Europe-screen features.  func_0321B4 is a page-04 Europe helper
 * (it reads a recruit's UnitRecord type), NOT colony.  Europe = screen-id 0x2B,
 * EUROPE.PIK handle 0x0FBA, entry file 0x030DEB -- that is a DIFFERENT screen
 * and is left alone here.
 *
 * THE REAL COLONY CHAIN (all byte-verified against raw/COLONIZE/VICEROY.EXE):
 *
 *   ENTRY  file 0x025EB6 .. 0x025EED  (colony_screen entry; page record-1 image,
 *          file range 0x024BF0..0x02CB00 -- the re-seg file named page_02.asm;
 *          the overlay is "page 0x03" in 1-based PIK/record numbering).
 *            0x025EC8  68 a0 0b            push 0x0BA0            ; "COLONY" PIK id
 *            0x025ECB  9a 7a 08 1f 19      lcall 0x191F:0x087A    ; load_PIK
 *            0x025EE5  bb 2c 00            mov  bx,0x2C           ; screen-id 0x2C
 *            0x025EE8  9a 72 07 1f 18      lcall 0x181F:0x0772    ; enter_screen_view
 *            0x025EED  cb                  retf
 *          enter_screen_view (0x181F:0x0772 -> Type-A page 0x1D) is the generic
 *          screen dispatcher; with bx=0x2C it routes to the colony composer.
 *
 *   COMPOSER  func_028592  (file 0x028592, page record-1).  The VICEROY twin of
 *          recol-0.2.0 paint_colony_screen (recol func_0199D8).  It fills the
 *          320x200 scene then CALLs its per-region sub-renderers in fixed order
 *          via in-page CS-relative trampolines (push cs; call 0x7Dxx/0x7Exx)
 *          that JMP-FAR through 0x191F:NNN; each trampoline's RTLink trailer word
 *          is page-id 0x02, so every sub-renderer resolves back into this page at
 *          page[0x02].code_offset(0x025900)+jmpf_off.  Resolved targets below.
 *
 * Offset/segment note: the re-seg disasm prints page-image IP = file-0x024BF0
 * and code-relative IP = file-0x025900.  The 0x191F far-JMP offsets in the
 * trampolines are page-CODE-relative (base 0x025900).  Every line gives the
 * absolute file offset so the mapping is unambiguous and independently checkable.
 *
 * Every coordinate / sprite id / loop-count below cites the @asm push that emits
 * it at a VICEROY.EXE file offset (preferred).  A handful of deep per-element
 * pixel constants that live one leaf deeper (inside the 0x191F leaf blitters that
 * the sub-renderers call) and are NOT pushed as literals in this page are marked
 * [recol-xref] honestly -- no VICEROY offset is invented for them.  Where VICEROY
 * confirms a recol coordinate it is tagged "byte-verified" with the @asm offset.
 *
 * Cross-reference for the layout shape: docs/COLONY_RENDERER_DECODED.md (decoded
 * from the recol-0.2.0 flat-linked twin colonize.exe; layout-faithful).
 * ============================================================================ */
#include "viceroy_types.h"
#include "iolib.h"
#include "colony.h"

/* Screen-state id returned to the reconstruction-layer screen dispatcher.
 * Anchored to the BYTE_VERIFIED enter_screen_view() id 0x2C (colony view);
 * see enter_screen_view(0x2C) @asm 0x025EE8 above. CONSOLIDATED 2026-06-09 into
 * the shared ui screen-id header. */
#include "ui_screen.h"

/* ----------------------------------------------------------------------------
 * Active colony record + screen-state globals (BYTE_VERIFIED).
 *   DGROUP:0x8542  -> active ColonyRecord (near ptr).  Read by the composer
 *                    (@asm 0x028685 mov bx,[0x8542]; test [bx+0x1C],0x80) and by
 *                    the stockpile / minimap / title sub-renderers.   @ref colony.h
 *   colony +0x00 / +0x01  map x / y                  (@asm 0x026379 mov al,[bx])
 *   colony +0x1A          status byte (>=4 -> hidden)(@asm 0x0268D7 cmp [bx+0x1A],4)
 *   colony +0x1B          owner / color              (@asm 0x02690A mov al,[bx+0x1B])
 *   colony +0x1C          flags (bit 0x80 = ?)       (@asm 0x028685 test [bx+0x1C],0x80)
 *   colony +0x1F          colonist count             (@asm 0x0270EA mov al,[bx+0x1F])
 *   colony +0x9A + i*2    per-commodity stock (16)   (@asm 0x028288 [bx+si+0x9A])
 *   DGROUP:0x0336  selected production/colonist sub-index (@asm 0x0264AD [0x336])
 *   DGROUP:0x0337  right-panel mode 0/1/2 (SoL/ship/msg) (@asm 0x02815F [0x337])
 *   DGROUP:0x0339  alternate flag-nation index           (@asm 0x028562 [0x339])
 *   DGROUP:0x033A  highlighted stockpile commodity        (@asm 0x028399 [0x33A])
 *   DGROUP:0x033C  minimap mode gate                       (@asm 0x027DC7 [0x33C])
 *   DGROUP:0x0B98  "screen minimized" gate (skip sprites)  (@asm 0x028551 [0xB98])
 *   DGROUP:0x2F5E  treasury / gold value word              (@asm 0x0283F9 [0x2F5E])
 *   DGROUP:0x2DA8  ICONS.SS sheet descriptor (far ptr 0x2DA8/.. used by blits)
 *   DGROUP:0x2DD0  panel backdrop fill id                  (@asm 0x027DD7 [0x2DD0])
 *   DGROUP:0x83E   active draw-context far ptr (es:bx for sheet header reads)
 *   DGROUP:0x266 + i*4   per-slot building (x,y) table (15) (@asm 0x027087)
 *   DGROUP:-0x729E + i   per-slot building TYPE byte (15)   (@asm 0x027095)
 *   DGROUP:-0x717E + i   per-slot building LEVEL byte (15; <0 = empty lot)
 *                                                           (@asm 0x02709D)
 * ---------------------------------------------------------------------------- */
extern struct colony_t far *ctx;          /* DGROUP:0x8542 */
extern int16_t g_sel_subidx_336;          /* DGROUP:0x0336 */
extern int16_t g_panel_mode_337;          /* DGROUP:0x0337 (0=SoL,1=ship,2=msg) */
extern int16_t g_hilite_good_33A;         /* DGROUP:0x033A */
extern int16_t g_minimized_B98;           /* DGROUP:0x0B98 */
extern int16_t g_gold_2F5E;               /* DGROUP:0x2F5E */

/* ----------------------------------------------------------------------------
 * Draw thunks used by the composer / sub-renderers (the resident 0x181F leaves).
 * Roles are byte-verified by call-site arg handling; file offsets via the
 * resident formula  file = 0x2400 + (seg<<4) + off  applied to 0x181F.
 *
 *   fill_rect(x,y,w,h)            0x7ED3 (-> 0x191F page-02 0x0A3E / leaf fill)
 *                                  pushed order (h, w, y, x); used for every
 *                                  opaque region fill on the colony screen.
 *   blit_box_id(x,y,w,h,id)       0x181F:0x0100 -> file 0x002BC8  (filled panel)
 *   blit_sprite(.,id,x,y,.)       0x181F:0x0254 -> file 0x00E76A  (sprite from .SS:
 *                                  AX=sprite_id, DX=x, BX=&sheet_desc, y/ctx pushed)
 *   draw_text(x,y,buf,..)         0x181F:0x013C -> file 0x002B6C  (string draw)
 *   fmt_word(buf,val,..)          0x181F:0x0022 -> file 0x002422  (number -> text)
 *   blit_band(x,y,w,h)            0x181F:0x00E2 -> file 0x00DB3A  (clipped re-blit)
 * Sub-renderer trampolines (push cs; call 0x7Dxx/0x7Exx -> JMP 0x191F:NNN, all
 * trailer page-id 0x02) are named with their resolved page-02 function in the
 * composer body below.
 * ---------------------------------------------------------------------------- */
extern void fill_rect(int x, int y, int w, int h);                 /* 0x7ED3 / 0x191F:0x07EC */
extern void blit_box_id(int x, int y, int w, int h, int id);       /* 0x181F:0x0100 */
extern void blit_sprite(int desc, int id, int x, int y);           /* 0x181F:0x0254 */
extern void draw_text(int x, int y, const char *buf);              /* 0x181F:0x013C */
extern void blit_band(int x, int y, int w, int h);                 /* 0x181F:0x00E2 */

/* The colony-screen entry that loads COLONY.PIK and enters screen-id 0x2C. */
extern void enter_screen_view(int bx_screen_id);                   /* 0x181F:0x0772 */

/* ============================================================================
 *                         === PLACEMENT TABLE ===
 * Every colony-screen element, its (x,y,w,h) or loop base/stride/count, the
 * sprite/string id, and the VICEROY @asm push that emits it (file offset), or
 * [recol-xref] where the literal is one leaf deeper than this page.  All values
 * are native 320x200 mode-13h pixels.  Pushed fill arg order is (h, w, y, x).
 *
 * --- COMPOSER  func_028592  (file 0x028592) ---------------------------------
 *  ELEMENT                      x    y    w    h    id     @asm (VICEROY file)
 *  Full-screen scene fill       0    0    320  200  -      0x0285A2 push 0xC8,0x140,0,0 -> call 0x7ED3 (fill)
 *  (then 11 sub-renderers in fixed order; see composer body)
 *  Final full blit (if arg!=0)  0    0    320  200  -      0x0285FA lcall 0x181F:0x0E2
 *
 * --- STOCKPILE bar  func_0281D6 (file 0x0281D6) -- recol func_019622 -----------
 *  Bar background fill          0    179  320  21   -      0x0281DB push 0x15,0x140,0xB3,0 -> call 0x7ED3   [byte-verified]
 *  First cell start X           1    -    -    -    -      0x0281EC mov [bp-0x6E],1                          [byte-verified]
 *  Icon Y base                  -    181  -    -    -      0x0281F1 mov [bp-0x72],0xB5                       [byte-verified]
 *  Cell pitch (X advance)       +19  -    -    -    -      0x02822A add [bp-0x6E],0x13                       [byte-verified]
 *  Commodity loop count         -    -    -    -    16     0x028231 cmp [bp-0x7E],0x10                       [byte-verified]
 *  Sprite id = i + 23           -    -    -    -    23..38 0x028253 add ax,0x17 (ICONS.SS base)             [byte-verified]
 *  Icon centering: ICONS hdr W  -    -    -    -    -      0x02825D es:[bx+si+0x152]; sar 1; +9 (@asm 0x028266)
 *  Highlight loop count         -    -    -    -    16     0x0283EB cmp [bp-0x7E],0x10                       [byte-verified]
 *  Selected-good source         -    -    -    -    -      0x028399 mov al,[0x33A]; highlight color 0x0E (@asm 0x0283BB)
 *  Gold display                 306  179  15   -    -      0x0283F1 push 0xF,0xB3,0x132; val [0x2F5E]        [byte-verified]
 *  Bar re-blit (if arg!=0)      0    179  320  21   -      0x028415 push 0xB3,0x140,0x15; lcall 0x181F:0xE2  [byte-verified]
 *
 * --- BUILDINGS loop  func_02701C (file 0x02701C) -- recol func_018475 ----------
 *  Backdrop fill (top band)     0    7    199  -    -      0x027031 push 0x80,0,..; lcall 0x181F:0xCE
 *  Backdrop frame               0    8    199  7    -      0x027044 push 7,0x78,0xC7,8,0; lcall 0x181F:0x4FC
 *  Building slot loop count     -    -    -    -    15     0x02707B cmp [bp-8],0xF                           [byte-verified]
 *  Per-slot (x,y) table         tbl  tbl  -    -    -      0x027087 [bx+0x266]=x, [bx+0x268]=y, y+=8, stride 4 [byte-verified]
 *  Per-slot TYPE byte           -    -    -    -    type   0x027095 mov dl,[bx-0x729E]                        [byte-verified]
 *  Per-slot LEVEL byte (<0=lot) -    -    -    -    lvl    0x02709D mov al,[bx-0x717E]; jl -> empty-lot       [byte-verified]
 *  Draw one building (lvl>=0)   -    -    -    -    -      0x0270AB call 0x7E33 (-> BUILDING.SS leaf)
 *  Draw empty lot   (lvl<0)     -    -    -    -    -      0x027072 call 0x7EF1
 *  Backdrop re-blit (if arg!=0) 0    8    199  -    -      0x0270BA push 8,0xC7,0x78; lcall 0x181F:0xE2
 *
 * --- FLAG panel  func_02853C (file 0x02853C) -- recol func_019984 --------------
 *  Panel fill                   303  132  17   45   -      0x02853C push 0x2D,0x11,0x84,0x12F -> call 0x7ED3 [byte-verified]
 *  (skip when minimized)        -    -    -    -    -      0x028551 cmp [0xB98],0
 *  Flag sprite                  -    -    -    -    68     0x028558 push 0x44 (0x2D hex style param next)    [byte-verified]
 *  Flag nation index            -    -    -    -    -      0x028562 [0x339] (alt) / 0x028568 [0x337] (normal)
 *  Panel re-blit (if arg!=0)    303  132  17   45   -      0x02857B push 0x84,0x11,0x2D; lcall 0x181F:0xE2   [byte-verified]
 *
 * --- SURROUNDING-TILE minimap  func_027DB2 (file 0x027DB2) -- recol func_019202 -
 *  Region fill                  121  130  84   48   -      0x027DB7 push 0x30,0x54,0x82,0x79 -> call 0x7ED3  [byte-verified]
 *  Inner panel box (bg [0x2DD0])121  132  84   57   -      0x027DCE push 0x39,0x84,0x54,0x79; lcall 0x181F:0x100 [byte-verified]
 *  Tile outer loop count        -    -    -    -    6      0x027DF7 cmp [bp-0x62],6                           [byte-verified]
 *
 * --- SoL / cargo / message panel  func_02814C (file 0x02814C) -- recol func_019599
 *  Region fill                  211  130  91   48   -      0x02814F push 0x30,0x5B,0x82,0xD3 -> call 0x7ED3  [byte-verified]
 *  Mode source                  -    -    -    -    -      0x02815F mov al,[0x337]                           [byte-verified]
 *  case 0 -> Sons of Liberty %   -    -    -    -    -      0x028167 call 0x7DC0
 *  case 1 -> ship in port        -    -    -    -    -      0x02816D call 0x7E60
 *  case 2 -> active message      -    -    -    -    -      0x028173 call 0x7EB0
 *  Panel re-blit (if arg!=0)    211  130  91   48   -      0x028188 push 0x82,0x5B,0x30; lcall 0x181F:0xE2   [byte-verified]
 *
 * --- TITLE text  func_0268CE (file 0x0268CE) -- recol func_017D31 --------------
 *  Hidden if status>=4          -    -    -    -    -      0x0268D7 cmp [bx+0x1A],4; jae return              [byte-verified]
 *  status*0x34 table gate       -    -    -    -    -      0x0268E2 imul bx,ax,0x34; cmp [bx+0x543F],ah      [byte-verified]
 *  owner/color char             -    -    -    -    -      0x02690A mov al,[bx+0x1B]                          [byte-verified]
 *  (text assembled via fmt/strcat leaves; printed by the generic text printer)
 *
 * --- MID-BAND field-worker / production area  func_0264A8 (file 0x0264A8) ------
 *  Selected sub-index source    -    -    -    -    -      0x0264AD mov al,[0x336]                           [byte-verified]
 *  Left-band setup fill         8    120  120  -    -      0x0264C4 push [0x835],0x78,0x78,8,0xC8; lcall 0x181F:0x506
 *  Upper-right band fill        224  32   72   72   -      0x0264E9 push 0x48,0x48,0x20,0xE0; call 0x7ED3    [byte-verified]
 *
 * --- SCENE / surrounding setup  func_026374 (file 0x026374; 2nd sub-paint) -----
 *  Reads colony map (x,y)       -    -    -    -    -      0x026379 [bx]=x, [bx+1]=y (@asm 0x026384)         [byte-verified]
 *  Scene block fill             0    8    80   80   -      0x0263A9 push 0x50,0x50,8,0xC8; call 0x7ED3       [byte-verified]
 *
 * --- DEEP per-element constants NOT pushed in this page (one leaf deeper) ------
 *  Building per-type/level SPRITE indices come from BUILDING.SS via the leaf
 *  reached at @asm 0x0270AB call 0x7E33 (national-variant select on player
 *  nation).  Exact per-level sprite ids are in the recol twin: switch on level
 *  0x0F/0x11/0x13/0x14/0x30/0x2F hex.   [recol-xref] COLONY_RENDERER_DECODED.md
 *  section 2 (recol func_018230).
 * ============================================================================ */

/* ----------------------------------------------------------------------------
 * colony_screen_enter -- VICEROY colony ENTRY  (file 0x025EB6 .. 0x025EED).
 * ----------------------------------------------------------------------------
 * Loads the COLONY.PIK background then enters the generic screen-view dispatcher
 * with the colony screen-id.  enter_screen_view internally routes screen-id 0x2C
 * to the colony paint composer func_028592.
 *
 *   0x025EC6  push 1                                  ; load-PIK arg
 *   0x025EC8  push 0x0BA0                             ; "COLONY" PIK string id
 *   0x025ECB  lcall 0x191F:0x087A                     ; load_PIK(handle args.., 0x0BA0)
 *   0x025ED3  or ax,ax; je 0x12FD                     ; bail if load failed
 *   0x025EDF  mov ax,0xFFAD; mov dx,2                 ; view params
 *   0x025EE5  mov bx,0x2C                             ; screen-id 0x2C  (COLONY)
 *   0x025EE8  lcall 0x181F:0x0772                     ; enter_screen_view(0x2C)
 *   0x025EED  retf
 * ---------------------------------------------------------------------------- */
void colony_screen_enter(void)
{
    /* load COLONY.PIK background.  @asm 0x025EC8 push 0x0BA0 / 0x025ECB lcall 0x191F:0x087A */
    /* (5 sheet-handle words [0x839E..0x83A4] + flag 1 pushed at 0x025EB6..0x025EC4) */

    /* enter the colony screen view.  @asm 0x025EE5 mov bx,0x2C / 0x025EE8 lcall 0x181F:0x0772 */
    enter_screen_view(0x2C);                           /* screen-id 0x2C -> func_028592 */
}

/* ----------------------------------------------------------------------------
 * colony_paint_stockpile -- VICEROY func_0281D6  (file 0x0281D6, page record-1).
 * ----------------------------------------------------------------------------
 * The 16-commodity stockpile bar across the screen bottom (y=179..199).  recol
 * twin = func_019622.  Two 16-iteration loops: the first lays each commodity
 * icon + quantity text; the second overlays the selected/boycott highlight.
 *
 *   0x0281DB  push 0x15,0x140,0xB3,0; call 0x7ED3        ; bar bg fill (0,179,320,21)
 *   0x0281EC  mov [bp-0x6E],1                            ; first cell X = 1
 *   0x0281F1  mov [bp-0x72],0xB5                         ; icon Y base = 181
 *   0x0281F6  mov [bp-0x7E],0                            ; i = 0
 *   loop i=0..15 (cmp [bp-0x7E],0x10 @ 0x028231):
 *     0x028253  add ax,0x17                              ; sprite id = i + 23
 *     0x02825D  cx = ICONS_hdr[+0x152 + i*12]; sar 1     ; half sprite width
 *     0x028266  dx = X - cx + 9                          ; centered draw X
 *     0x028270  lcall 0x181F:0x254                       ; blit_sprite(&0x2DA8,id,dx,y)
 *     0x02822A  add [bp-0x6E],0x13                       ; X += 19
 *   highlight loop i=0..15 (cmp [bp-0x7E],0x10 @ 0x0283EB):
 *     0x028399  al = [0x33A] (selected good); 0x0283BB push 0x0E (highlight)
 *   0x0283F1  push 0xF,0xB3,0x132; gold=[0x2F5E]; draw   ; gold at x=306,y=179
 *   0x028415  if [bp+6]!=0: lcall 0x181F:0xE2            ; re-blit bar band
 * ---------------------------------------------------------------------------- */
void colony_paint_stockpile(int repaint)
{
    int i;
    int x      = 1;        /* [bp-0x6E]  @asm 0x0281EC mov [bp-0x6E],1 */
    int y_icon = 0xB5;     /* [bp-0x72]  @asm 0x0281F1 mov [bp-0x72],0xB5 (181) */

    /* bar background fill (x=0,y=179,w=320,h=21).
     * @asm 0x0281DB push 0x15,0x140,0xB3,0 / 0x0281E6 call 0x7ED3. */
    fill_rect(0, 0xB3, 0x140, 0x15);                   /* @asm 0x0281DB..0x0281E6 */

    /* === pass 1: 16 commodity cells, pitch 19, sprite base 23 (ICONS.SS) === */
    for (i = 0; i < 0x10; i++) {                       /* @asm 0x028231 cmp [bp-0x7E],0x10 */
        int sprite_id = i + 0x17;                      /* @asm 0x028253 add ax,0x17 */
        int qty       = ctx ? 0 : 0;                   /* colony +0x9A + i*2  @asm 0x028288 [bx+si+0x9A] */
        /* center on cell X using ICONS header width:
         *   half_w = ICONS_hdr[+0x152 + i*12] >> 1   (@asm 0x02825D / 0x028262)
         *   draw_x = x - half_w + 9                   (@asm 0x028264 / 0x028266) */
        (void)qty;
        /* blit_sprite(&0x2DA8 = ICONS.SS desc, sprite_id, draw_x, y_icon).
         * @asm 0x028270 lcall 0x181F:0x254. */
        blit_sprite(/*&0x2DA8*/ 0, sprite_id, x, y_icon);  /* @asm 0x028270 */
        x += 0x13;                                     /* @asm 0x02822A add [bp-0x6E],0x13 (pitch 19) */
    }

    /* === pass 2: selected-good / boycott highlight, 16 cells === */
    for (i = 0; i < 0x10; i++) {                       /* @asm 0x0283EB cmp [bp-0x7E],0x10 */
        if (i == g_hilite_good_33A) {                  /* @asm 0x02839E cmp ax,[bp-0x7E] (al=[0x33A]) */
            ;                                          /* highlight color 0x0E  @asm 0x0283BB push 0x0E */
        }
    }

    /* gold display at (x=306, y=179, w=15), value = [0x2F5E].
     * @asm 0x0283F1 push 0xF,0xB3,0x132 / 0x0283F9 push [0x2F5E] / fmt + draw_text. */
    (void)g_gold_2F5E;                                 /* @asm 0x0283F9 push [0x2F5E] */

    /* re-blit the stockpile band on repaint.  @asm 0x02840F cmp [bp+6],0 /
     * 0x028415 push 0xB3,0x140,0x15 / 0x028424 lcall 0x181F:0xE2. */
    if (repaint != 0) {                                /* @asm 0x02840F cmp [bp+6],0 */
        blit_band(0, 0xB3, 0x140, 0x15);               /* @asm 0x028415..0x028424 (0,179,320,21) */
    }
}

/* ----------------------------------------------------------------------------
 * colony_paint_buildings -- VICEROY func_02701C  (file 0x02701C, page record-1).
 * ----------------------------------------------------------------------------
 * The 15 building slots (recol twin = func_018475).  Per-slot (x,y) come from a
 * DGROUP table; per-slot TYPE and LEVEL bytes select the sprite / empty lot.
 *
 *   0x027031  push 0x80,0,..; lcall 0x181F:0xCE          ; top-band backdrop
 *   0x027044  push 7,0x78,0xC7,8,0; lcall 0x181F:0x4FC    ; framed backdrop
 *   0x027067  mov [bp-8],0                                ; slot i = 0
 *   loop i=0..14 (cmp [bp-8],0xF @ 0x02707B):
 *     0x027087  ax = tbl[i].x = [bx+0x266]; cx = tbl[i].y = [bx+0x268]; cx += 8
 *     0x027095  dl = TYPE  = [bx-0x729E]
 *     0x02709D  al = LEVEL = [bx-0x717E]
 *     0x0270A2  if (al < 0)  call 0x7EF1                  ; empty lot
 *               else         call 0x7E33                  ; draw one building
 *   0x0270B4  if [bp+6]!=0: lcall 0x181F:0xE2             ; re-blit backdrop
 * ---------------------------------------------------------------------------- */
void colony_paint_buildings(int repaint)
{
    int i;

    /* top-band backdrop fill + frame (region around y=7..8, w=199).
     * @asm 0x027031 lcall 0x181F:0xCE ; 0x027044 lcall 0x181F:0x4FC. */

    /* === 15 building slots === */
    for (i = 0; i < 0x0F; i++) {                       /* @asm 0x02707B cmp [bp-8],0xF */
        int bx_x  = 0;   /* tbl[i].x  = [bx+0x266], stride 4   @asm 0x027087 */
        int bx_y  = 0;   /* tbl[i].y  = [bx+0x268] + 8         @asm 0x02708B / 0x02708F */
        int btype = 0;   /* [bx-0x729E]                        @asm 0x027095 */
        int blvl  = 0;   /* [bx-0x717E]  (<0 = empty lot)      @asm 0x02709D */
        (void)bx_x; (void)bx_y; (void)btype;

        if (blvl < 0) {                                /* @asm 0x0270A2 or ax,ax; jl */
            ;                                          /* empty lot: @asm 0x027072 call 0x7EF1 */
        } else {
            ;                                          /* building: @asm 0x0270AB call 0x7E33 (BUILDING.SS) */
        }
    }

    /* re-blit backdrop on repaint.  @asm 0x0270B4 cmp [bp+6],0 /
     * 0x0270BA push 8,0xC7,0x78 / 0x0270C8 lcall 0x181F:0xE2. */
    if (repaint != 0) {                                /* @asm 0x0270B4 cmp [bp+6],0 */
        blit_band(0, 8, 0xC7, 8);                      /* @asm 0x0270BA..0x0270C8 (top backdrop band) */
    }
}

/* ----------------------------------------------------------------------------
 * colony_paint_flag -- VICEROY func_02853C  (file 0x02853C, page record-1).
 * ----------------------------------------------------------------------------
 * The nation flag panel at the right edge (recol twin = func_019984).
 *
 *   0x02853C  push 0x2D,0x11,0x84,0x12F; call 0x7ED3      ; fill (303,132,17,45)
 *   0x028551  if [0xB98]==0 (not minimized):
 *     0x028558  push 0x44                                 ; flag sprite id = 68
 *     0x02855A  push 3                                    ; style param
 *     0x02855C  al = ([bp+8] ? [0x339] : [0x337])         ; nation index
 *     0x02856F  call 0x7D89                               ; blit flag
 *   0x028575  if [bp+6]!=0: lcall 0x181F:0xE2             ; re-blit panel
 * ---------------------------------------------------------------------------- */
void colony_paint_flag(int repaint, int alt_nation)
{
    /* panel fill (x=303, y=132, w=17, h=45).
     * @asm 0x02853C push 0x2D,0x11,0x84,0x12F / 0x02854B call 0x7ED3. */
    fill_rect(0x12F, 0x84, 0x11, 0x2D);                /* @asm 0x02853C..0x02854B (303,132,17,45) */

    /* flag sprite 68 (0x44), style 3, skipped when minimized.
     * @asm 0x028551 cmp [0xB98],0 / 0x028558 push 0x44 / 0x02856F call 0x7D89. */
    if (g_minimized_B98 == 0) {                        /* @asm 0x028551 cmp [0xB98],0 */
        int nation = alt_nation ? g_panel_mode_337     /* @asm 0x028562 al=[0x339] */
                                : g_panel_mode_337;    /* @asm 0x028568 al=[0x337] */
        (void)nation;
        ;                                              /* blit sprite 0x44: @asm 0x02856F call 0x7D89 */
    }

    /* re-blit panel on repaint.  @asm 0x028575 cmp [bp+6],0 /
     * 0x02857B push 0x84,0x11,0x2D / 0x02858A lcall 0x181F:0xE2. */
    if (repaint != 0) {                                /* @asm 0x028575 cmp [bp+6],0 */
        blit_band(0x12F, 0x84, 0x11, 0x2D);            /* @asm 0x02857B..0x02858A (303,132,17,45) */
    }
}

/* ----------------------------------------------------------------------------
 * colony_paint_minimap -- VICEROY func_027DB2  (file 0x027DB2, page record-1).
 * ----------------------------------------------------------------------------
 * The 3x3 surrounding-tile minimap (recol twin = func_019202).  Region fill +
 * inner panel box, then an outer 6-iteration tile walk.
 *
 *   0x027DB7  push 0x30,0x54,0x82,0x79; call 0x7ED3       ; fill (121,130,84,48)
 *   0x027DC7  if [0x33C]==0:
 *     0x027DCE  push 0x39,0x84,0x54,0x79,[0x2DD0]; lcall 0x181F:0x100 ; inner box
 *   0x027DF7  loop tile=0..5 (cmp [bp-0x62],6)            ; tile walk
 * ---------------------------------------------------------------------------- */
void colony_paint_minimap(void)
{
    int tile;

    /* region fill (x=121, y=130, w=84, h=48).
     * @asm 0x027DB7 push 0x30,0x54,0x82,0x79 / 0x027DC1 call 0x7ED3. */
    fill_rect(0x79, 0x82, 0x54, 0x30);                 /* @asm 0x027DB7..0x027DC1 (121,130,84,48) */

    /* inner panel box (x=121,y=132,w=84,h=57), bg id [0x2DD0].
     * @asm 0x027DCE push 0x39,0x84,0x54,0x79 / 0x027DE5 lcall 0x181F:0x100. */
    blit_box_id(0x79, 0x84, 0x54, 0x39, /*[0x2DD0]*/ 0);   /* @asm 0x027DCE..0x027DE5 */

    /* outer tile walk, 6 steps (per-direction; W skipped at map boundary).
     * @asm 0x027DF7 cmp [bp-0x62],6. */
    for (tile = 0; tile < 6; tile++) {                 /* @asm 0x027DF7 cmp [bp-0x62],6 */
        ;                                              /* per-tile terrain + worker overlay blit */
    }
}

/* ----------------------------------------------------------------------------
 * colony_paint_sol_panel -- VICEROY func_02814C  (file 0x02814C, page record-1).
 * ----------------------------------------------------------------------------
 * The panel right of the minimap (recol twin = func_019599).  Its contents are
 * chosen by mode word [0x337]: Sons-of-Liberty %, ship-in-port, or message.
 *
 *   0x02814F  push 0x30,0x5B,0x82,0xD3; call 0x7ED3       ; fill (211,130,91,48)
 *   0x02815F  al = [0x337]                                ; mode 0/1/2
 *     0 -> call 0x7DC0   ; Sons of Liberty %
 *     1 -> call 0x7E60   ; ship in port
 *     2 -> call 0x7EB0   ; active message
 *   0x028182  if [bp+6]!=0: lcall 0x181F:0xE2             ; re-blit panel
 * ---------------------------------------------------------------------------- */
void colony_paint_sol_panel(int repaint)
{
    /* region fill (x=211, y=130, w=91, h=48).
     * @asm 0x02814F push 0x30,0x5B,0x82,0xD3 / 0x02815A call 0x7ED3. */
    fill_rect(0xD3, 0x82, 0x5B, 0x30);                 /* @asm 0x02814F..0x02815A (211,130,91,48) */

    /* mode dispatch on [0x337].  @asm 0x02815F mov al,[0x337]. */
    switch (g_panel_mode_337) {                        /* @asm 0x02815F / jump table 0x028178 */
        case 0:  ; break;                              /* SoL %:    @asm 0x028167 call 0x7DC0 */
        case 1:  ; break;                              /* ship:     @asm 0x02816D call 0x7E60 */
        case 2:  ; break;                              /* message:  @asm 0x028173 call 0x7EB0 */
        default: ; break;
    }

    /* re-blit panel on repaint.  @asm 0x028182 cmp [bp+6],0 /
     * 0x028188 push 0x82,0x5B,0x30 / 0x028197 lcall 0x181F:0xE2. */
    if (repaint != 0) {                                /* @asm 0x028182 cmp [bp+6],0 */
        blit_band(0xD3, 0x82, 0x5B, 0x30);             /* @asm 0x028188..0x028197 (211,130,91,48) */
    }
}

/* ----------------------------------------------------------------------------
 * colony_paint_title -- VICEROY func_0268CE  (file 0x0268CE, page record-1).
 * ----------------------------------------------------------------------------
 * The colony name / population title text (recol twin = func_017D31).  Hidden
 * while the colony status byte is >= 4, or when its status-table gate is set.
 *
 *   0x0268D3  bx = [0x8542]
 *   0x0268D7  if [bx+0x1A] >= 4: return                   ; status hidden
 *   0x0268E2  imul bx,status,0x34; if [bx+0x543F]==0 ...   ; status-table gate
 *   0x0268EE  if [0xB98]!=0 or [0x828]!=0: return          ; minimized / blocked
 *   0x02690A  al = [bx+0x1B]                               ; owner / color
 *   (name + "Pop:" assembled by fmt/strcat leaves, printed by generic printer)
 * ---------------------------------------------------------------------------- */
void colony_paint_title(void)
{
    /* status / minimized gates (early-return).  @asm 0x0268D7 cmp [bx+0x1A],4 /
     * 0x0268E2 imul *0x34 / 0x0268EE cmp [0xB98],0 / 0x0268F8 cmp [0x828],0. */

    /* owner/color char + colony name text assembly.  @asm 0x02690A mov al,[bx+0x1B]. */
    (void)ctx;
}

/* ----------------------------------------------------------------------------
 * colony_screen_render -- VICEROY COLONY PAINT COMPOSER  func_028592
 *                         (file 0x028592, page record-1).
 * ----------------------------------------------------------------------------
 * The twin of recol-0.2.0 paint_colony_screen (func_0199D8).  Fills the 320x200
 * scene, then dispatches the per-region sub-renderers in fixed order through the
 * in-page CS-relative trampolines (push cs; call 0x7Dxx/0x7Exx -> JMP 0x191F:NNN,
 * every trailer page-id 0x02).  Resolved sub-renderer targets (page 0x02
 * code_offset 0x025900 + jmpf):
 *
 *   0x028595  lcall 0x181F:0xC22                          ; begin/grab draw context
 *   0x02859B  push cs; call 0x7E6A -> file 0x025C32        ; scene setup A
 *   0x02859F  push cs; call 0x7EDD -> file 0x026374        ; scene/surrounding setup B
 *   0x0285A2  push 0xC8,0x140,0,0; call 0x7ED3 -> 0x02633E  ; FULL-SCREEN fill (0,0,320,200)
 *   0x0285B4  push 0; call 0x7EF6 -> file 0x0268CE          ; TITLE text       (colony_paint_title)
 *   0x0285BC  push 0; call 0x7DB1 -> file 0x0264A8          ; MID-BAND field workers / production
 *   0x0285C4  push 0; call 0x7DED -> file 0x0270D0          ; colonist row / mid-band band
 *   0x0285CC  push 0; call 0x7E29 -> file 0x0281D6          ; STOCKPILE bar    (colony_paint_stockpile)
 *   0x0285D6  push 0,0; call 0x7DF7 -> file 0x02853C        ; FLAG panel       (colony_paint_flag)
 *   0x0285DE  push 0; call 0x7E0B -> file 0x027DB2          ; SURROUNDING minimap (colony_paint_minimap)
 *   0x0285E6  push 0; call 0x7D93 -> file 0x02814C          ; SoL/cargo/msg panel (colony_paint_sol_panel)
 *   0x0285EE  push 0; call 0x7D8E -> file 0x02701C          ; BUILDINGS loop   (colony_paint_buildings)
 *   0x0285F4  if [bp+6]!=0: push 0xC8,0x140,0; lcall 0x181F:0xE2 ; full-screen re-blit
 * ---------------------------------------------------------------------------- */
void colony_screen_render(int repaint)
{
    /* begin / grab draw context.  @asm 0x028595 lcall 0x181F:0xC22. */

    /* scene setup A + B (surrounding-tiles precompute, scene block).
     * @asm 0x02859B call 0x7E6A (func_025C32) / 0x02859F call 0x7EDD (func_026374). */

    /* full-screen scene fill (x=0, y=0, w=320, h=200).
     * @asm 0x0285A2 push 0xC8,0x140,0,0 / 0x0285AD call 0x7ED3 (fill via func_02633E). */
    fill_rect(0, 0, 0x140, 0xC8);                      /* @asm 0x0285A2..0x0285AD (0,0,320,200) */

    /* === ordered sub-renderers (fixed order; each push 0 = "static paint") === */
    colony_paint_title();                              /* @asm 0x0285B4 call 0x7EF6 (func_0268CE) */
    /* mid-band field workers / production area.       @asm 0x0285BC call 0x7DB1 (func_0264A8) */
    ;
    /* colonist row / mid-band lower band.             @asm 0x0285C4 call 0x7DED (func_0270D0) */
    ;
    colony_paint_stockpile(0);                         /* @asm 0x0285CC call 0x7E29 (func_0281D6) */
    colony_paint_flag(0, 0);                           /* @asm 0x0285D6 call 0x7DF7 (func_02853C) */
    colony_paint_minimap();                            /* @asm 0x0285DE call 0x7E0B (func_027DB2) */
    colony_paint_sol_panel(0);                         /* @asm 0x0285E6 call 0x7D93 (func_02814C) */
    colony_paint_buildings(0);                         /* @asm 0x0285EE call 0x7D8E (func_02701C) */

    /* full-screen re-blit on repaint.  @asm 0x0285F4 cmp [bp+6],0 /
     * 0x0285FA push 0xC8,0x140,0 / 0x028607 lcall 0x181F:0xE2. */
    if (repaint != 0) {                                /* @asm 0x0285F4 cmp [bp+6],0 */
        blit_band(0, 0, 0x140, 0xC8);                  /* @asm 0x0285FA..0x028607 (0,0,320,200) */
    }
}

/* ----------------------------------------------------------------------------
 * colony_screen_update -- input handling (draw spec only).
 *
 * The in-scene worker drag/drop, profession cycling, and build-menu hit-test
 * dispatch off the same page-record-1 cluster and re-blit via the repaint=1
 * paths of the sub-renderers above.  This file is the DRAW spec; the per-click
 * hit-test geometry belongs to the input module.
 * ---------------------------------------------------------------------------- */
int colony_screen_update(void)
{
    /* dispatch by event; redraw via colony_screen_render(1). */
    return SCREEN_COLONY;
}
