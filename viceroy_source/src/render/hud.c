/* ============================================================================
 *   >>> BYTE-TRACED placement (draw-call coords) + frame-verified layout <<<
 * ----------------------------------------------------------------------------
 * Map-view HUD: the map viewport, the right-hand sidebar (minimap + status +
 * selected-unit panel) and the top menu / message strip, on the native 320x200
 * mode-13h canvas.
 *
 * UPGRADE 2026-05-30: the map-view chrome composers HAVE now been decoded to
 * file offsets from the RE-SEGMENTED overlay disassembly (page_12.asm /
 * page_15.asm), and the C bodies live in src/overlay/. So the placement is no
 * longer "TBD" — the actual draw-call x/y/w/h push-immediates are byte-traced
 * below in the HUD PLACEMENT TABLE (HUD_*). The composers are:
 *
 *   func_06787C  render_frame_setup       overlay_066EC8_06896A.c  @0x06787C
 *       -> the map-VIEWPORT geometry (tile px, span, origin) for the frame.
 *   func_06083A  draw_map_view_chrome     overlay_05C69C_0610DA.c  @0x06083A
 *       -> the top menu strip + the date/turn + the bottom message/command line.
 *   func_068898  draw_minimap_or_cursor_box overlay_066EC8_06896A.c @0x068898
 *       -> recomputes geometry, then draws the minimap/overview viewport box.
 *   func_066B96  minimap_fill             overlay_0612E6_066EB3.c  @0x066B96
 *       -> the minimap background fill (0x27 x 0x38 rect at the minimap origin).
 *   func_066BB0  minimap_update           overlay_0612E6_066EB3.c  @0x066BB0
 *       -> minimap window blit + the white "you are here" viewport rectangle.
 *   func_066CD6  minimap_panel            overlay_0612E6_066EB3.c  @0x066CD6
 *       -> the minimap PANEL FRAME (outer box + inner strip) — gives the exact
 *          minimap rectangle in screen pixels.
 *
 * The frame-blit thunks these call are load-image overlay leaves (their pixel
 * format is platform/opaque), but their CALLING CONVENTION (the pushed
 * x/y/w/h/color) is byte-decoded, so the COORDINATES are solid. Roles confirmed
 * against include/overlay_externs.h + the established model in src/render/blit.c:
 *   0x181F:0x100  text/centred-string blit  (font, x, y, w, &str)
 *   0x181F:0x13C  text row blit             (color, y, x, ...)
 *   0x181F:0x0CE  filled-rect / line draw   (ax=x, dx=y, bx=w, push h, ...)
 *   0x181F:0x0E2  box-outline draw          (ax=x, dx=y, bx=w, push h, ...)
 *   0x181F:0x0BA  box draw (no descriptor)  (ax=x, dx=y, bx=w, push h, push ?)
 *   0x181F:0x0C4  textured box (descriptor) (clip + far-record [0x82C])
 *   0x181F:0x484  set active region/palette + simple fill (clip rect)
 *   0x1A1F:0x896  resident rect-fill        (x, y, w, h, color) [minimap_fill]
 *
 * What was ALREADY solid (kept below):
 *   - The on-screen frame-verified visible layout: reverse_engineered/docs/
 *     RENDERER_GEOMETRY.md ("Map view ... VERIFIED v2/v3", "Default map view
 *     sidebar"). These are the VISIBLE regions; the byte-traced HUD_* table is
 *     the DRAW-CALL truth and is preferred where the two differ (the frame
 *     border accounts for the ~3px deltas, e.g. minimap 241 vs 244).
 *   - The DATA SOURCES: PowerRecord (DGROUP:0x8808, stride 0x13C) field offsets
 *     and the REF count globals (DGROUP:0x53DA..0x53E1) are byte-verified
 *     (see power.h and project memory 2026-05-05).
 *   - The clip-rect global: DGROUP:0x839E..0x83A4 is the SCREEN BOUNDS clip rect
 *     (200, 320, 0, ...), NOT a popup rect (RENDERER_GEOMETRY.md "Screen-bounds
 *     reminder"). The real popup rect is computed inline by overlay func_07431E
 *     (DIALOG_GEOMETRY.md), NOT stored in DGROUP.
 * ============================================================================ */

/* ============================================================================
 * hud.c -- Map-view sidebar / minimap / status (geometry + data sources)
 * ----------------------------------------------------------------------------
 * @region         overlay (in-game dispatch) + data-driven
 * @verified_by    Layout: frame analysis (RENDERER_GEOMETRY.md, 2026-05-21).
 *                 Data: PowerRecord/REF byte offsets (power.h, memory 2026-05-05).
 * @ref            ../../docs/RENDERER_GEOMETRY.md  (map-view sidebar)
 * @ref            ../../docs/DIALOG_GEOMETRY.md    (popup rect = func_07431E)
 * @ref            ../../../FUNCTIONS_INVENTORY.md
 * ============================================================================ */
#include "viceroy_types.h"
#include "power.h"

/* ----------------------------------------------------------------------------
 * Native canvas + map-view layout rects (320x200). FRAME-VERIFIED.
 * @ref RENDERER_GEOMETRY.md "Map view (gameplay) VERIFIED v2/v3" + v3 revision.
 * ---------------------------------------------------------------------------- */
#define SCREEN_W           320   /* @ref RENDERER_GEOMETRY.md native mode 13h */
#define SCREEN_H           200

#define TOPMENU_X            0    /* top menu strip (0,0,320,8) v3 */
#define TOPMENU_Y            0
#define TOPMENU_W          320
#define TOPMENU_H            8    /* v3 correction: 8, not 14 (line 316) */

#define MAPVIEW_X            0    /* visible map viewport begins at y=8 (v3) */
#define MAPVIEW_Y            8
#define MAPVIEW_W          240    /* 15 tiles x 16 px (RENDERER_GEOMETRY closest zoom) */
#define MAPVIEW_H          192

#define SIDEBAR_X          240    /* right sidebar (240,0,80,200) — WOODPANL.PIK */
#define SIDEBAR_Y            0
#define SIDEBAR_W           80
#define SIDEBAR_H          200

/* Sidebar sub-regions (frame-verified; "Default map view sidebar" table). */
#define MINIMAP_X          244    /* minimap (244,8,72,44) — 58x72 world squashed */
#define MINIMAP_Y            8
#define MINIMAP_W           72
#define MINIMAP_H           44

#define STATUS_YEAR_X      244    /* "Spring %YEAR"  @ (244,58) */
#define STATUS_YEAR_Y       58
#define STATUS_GOLD_X      244    /* "Gold: %NUMBER" @ (244,66) */
#define STATUS_GOLD_Y       66
#define STATUS_TAX_X       290    /* "Tax: %NUMBER%%" @ (290,66) */
#define STATUS_TAX_Y        66

#define UNITPANEL_SPRITE_X 244    /* selected-unit sprite @ (244,80) */
#define UNITPANEL_SPRITE_Y  80
#define UNITPANEL_MOVES_X  270    /* "Moves: N"     @ (270,82)  LABELS @INFO[0] */
#define UNITPANEL_MOVES_Y   82
#define UNITPANEL_LOC_X    270    /* "Locat: (x,y)" @ (270,92)  LABELS @INFO[1] */
#define UNITPANEL_LOC_Y     92
#define UNITPANEL_TYPE_X   244    /* unit type      @ (244,104) NAMES  @UNIT[type] */
#define UNITPANEL_TYPE_Y   104
#define UNITPANEL_SKILL_X  244    /* unit skill     @ (244,112) NAMES  @JOB[skill] */
#define UNITPANEL_SKILL_Y  112
#define UNITPANEL_ORDERS_X 244    /* orders         @ (244,120) LABELS @MISC */
#define UNITPANEL_ORDERS_Y 120
#define UNITPANEL_TERR_X   244    /* "(Terrain)"    @ (244,128) NAMES  @UNFORESTED/@FORESTED */
#define UNITPANEL_TERR_Y   128

/* ============================================================================
 *  BYTE-TRACED HUD PLACEMENT  (the draw-call truth)
 * ----------------------------------------------------------------------------
 *  Everything below is decoded from the actual push-immediates in the map-view
 *  chrome composers (page_12.asm / page_15.asm). Each constant cites its
 *  `@asm 0xXXXXXX`. This is the authoritative "what is placed where" for the
 *  gameplay screen and is preferred over the frame-verified rects above where
 *  the two differ (the wood-frame border accounts for the small deltas).
 * ============================================================================ */

/* ----------------------------------------------------------------------------
 * (A) MAP VIEWPORT GEOMETRY — func_06787C render_frame_setup  @asm 0x06787C
 *     (overlay_066EC8_06896A.c; FULL body byte-traced there 2026-05-30).
 *
 * Inputs (DGROUP): zoom [0x184], scroll-centre tile [0x17C]/[0x17E],
 *                  minimap flag [0x18A], map dims [0x853A]w / [0x853C]h.
 *
 * The viewport is a tile grid; render_frame_setup computes, per frame:
 *   tile_px   [0x5AD4] = [0x8326] = 0x10 >> zoom            @asm 0x0678AE
 *   span_cols [0x8544]            = 0x0F << zoom             @asm 0x067884
 *   span_rows [0x8546]            = 0x0C << zoom             @asm 0x06788C
 *       (minimap/overview flag [0x18A]!=0 -> span = 5x5, zoom forced 0  @0x06789B)
 *   origin_col[0x8328] = -(span_cols/2 - centre_x[0x17C])   @asm 0x0678B9
 *   origin_row[0x832E] = -(span_rows/2 - centre_y[0x17E])   @asm 0x0678C7
 *       (non-minimap: clamped into [1 .. mapdim-span-1] both axes @0x0678DE)
 *   max_col   [0x8804] = span_cols + origin_col - 1         @asm 0x067A0B
 *   max_row   [0x8806] = span_rows + origin_row - 1         @asm 0x067A16
 *
 * At closest zoom (zoom=0): tile_px=16, span=15x12 tiles -> 240x192 px.
 * The visible viewport begins at screen y=8 (under the 8-px menu strip) — the
 * tile->pixel map is done by O514/O513 (tile_chain.c) using the globals above;
 * pixel base [0x832A]/[0x832C] is 0 unless the map is narrower than the span.
 * ---------------------------------------------------------------------------- */
#define G_ZOOM            0x0184   /* zoom level (cl); tile_px = 0x10>>zoom */
#define G_CENTRE_X        0x017C   /* scroll-centre tile col */
#define G_CENTRE_Y        0x017E   /* scroll-centre tile row */
#define G_MINIMAP_FLAG    0x018A   /* !=0 => overview/minimap geometry (5x5) */
#define G_TILE_PX         0x5AD4   /* = [0x8326]; tile pixel size = 0x10>>zoom */
#define G_TILE_PX2        0x8326   /* duplicate of tile pixel size */
#define G_SPAN_COLS       0x8544   /* visible span in tiles (x) = 0xF<<zoom */
#define G_SPAN_ROWS       0x8546   /* visible span in tiles (y) = 0xC<<zoom */
#define G_ORIGIN_COL      0x8328   /* top-left visible tile col */
#define G_ORIGIN_ROW      0x832E   /* top-left visible tile row */
#define G_PIXBASE_COL     0x832A   /* pixel-grid base col (0 unless map < span) */
#define G_PIXBASE_ROW     0x832C   /* pixel-grid base row */
#define G_MAX_COL         0x8804   /* max visible tile col = span+origin-1 */
#define G_MAX_ROW         0x8806   /* max visible tile row = span+origin-1 */
#define G_MAP_W           0x853A   /* world width  in tiles */
#define G_MAP_H           0x853C   /* world height in tiles */

#define VIEWPORT_TILE_PX_BASE  0x10  /* tile_px = 0x10>>zoom  @asm 0x0678AE */
#define VIEWPORT_SPAN_COLS_BASE 0x0F /* span_x  = 0x0F<<zoom  @asm 0x067884 */
#define VIEWPORT_SPAN_ROWS_BASE 0x0C /* span_y  = 0x0C<<zoom  @asm 0x06788C */
#define VIEWPORT_OVERVIEW_SPAN  5    /* [0x18A]!=0 -> 5x5     @asm 0x06789B */
#define VIEWPORT_SCREEN_Y       8    /* viewport top px (under menu strip) */

/* ----------------------------------------------------------------------------
 * (B) MINIMAP RECT — byte-traced from func_066CD6 minimap_panel (panel frame),
 *     func_066B96 minimap_fill (bg), func_066968 minimap_compose (pixel anchor),
 *     func_066BB0 minimap_update (clip window + viewport box).
 *     (overlay_0612E6_066EB3.c; FULL bodies byte-traced there.)
 *
 * Minimap origin in WORLD tile coords (set by the minimap-init helper 0x0668B8):
 *   g_minimap_col0 = [0x9CCC]   g_minimap_row0 = [0x9CCA]
 * Minimap content is anchored on SCREEN at pixel (col0 + 0xFC, row0 + 9):
 *   dst_x = sx - [0x9CCC] + 0xFC   dst_y = sy - [0x9CCA] + 9   @asm 0x0669CF/0x0669D8
 *   => the minimap content top-left screen pixel = (0xFC=252, 9).
 *
 * Panel frame (func_066CD6, drawn as box-outline + inner strip):
 *   outer box   x=0xF1(241) y=8  w=0x4F(79) h=0x29(41)   @asm 0x066CF4 -> 0x181F:0xBA
 *   inner strip x=0xFB(251) y=8  w=0x30(48) h=6          @asm 0x066D4B -> 0x181F:0xCE
 *   highlight   x=0xF1(241) y=8  w=0x29(41) h=0x4F(79)   @asm 0x066DD7 -> 0x181F:0xE2
 * Background fill (func_066B96): 0x27(39) x 0x38(56) at the minimap origin
 *                                                       @asm 0x066B9E -> 0x1A1F:0x896
 * Visible-window clip (func_066BB0): [row0 .. row0+0x26] x [col0 .. col0+0x37]
 *   i.e. 0x27=39 tile-cols x 0x38=56 tile-rows of world  @asm 0x066BD7/0x066C02
 * ---------------------------------------------------------------------------- */
#define G_MINIMAP_COL0    0x9CCC   /* minimap origin world col */
#define G_MINIMAP_ROW0    0x9CCA   /* minimap origin world row */

#define MINIMAP_PIX_X     0xFC     /* 252  content top-left X  @asm 0x0669CF */
#define MINIMAP_PIX_Y     9        /*   9  content top-left Y  @asm 0x0669D8 */

#define MINIMAP_FRAME_X   0xF1     /* 241  outer box x  @asm 0x066DDD (ax=0xf1) */
#define MINIMAP_FRAME_Y   8        /*   8  outer box y  @asm 0x066DE0 (dx=8) */
#define MINIMAP_FRAME_W   0x4F     /*  79  outer box w  @asm 0x066CFE (bx=0x4f) */
#define MINIMAP_FRAME_H   0x29     /*  41  outer box h  @asm 0x066CF4 (push 0x29) */

#define MINIMAP_INNER_X   0xFB     /* 251  inner strip x  @asm 0x066D4F (ax=0xfb) */
#define MINIMAP_INNER_Y   8        /*   8  inner strip y  @asm 0x066D52 (dx=8) */
#define MINIMAP_INNER_W   0x30     /*  48  inner strip w  @asm 0x066D4B (push 0x30) */
#define MINIMAP_INNER_H   6        /*   6  inner strip h  @asm 0x066D4D (push 6) */

#define MINIMAP_FILL_W    0x27     /*  39  bg fill w (tiles)  @asm 0x066B9E (push 0x27) */
#define MINIMAP_FILL_H    0x38     /*  56  bg fill h (tiles)  @asm 0x066BA0 (push 0x38) */
#define MINIMAP_WIN_COLS  0x37     /*  55  clip window col extent  @asm 0x066C02 (+0x37) */
#define MINIMAP_WIN_ROWS  0x26     /*  38  clip window row extent  @asm 0x066BD7 (+0x26) */

/* ----------------------------------------------------------------------------
 * (C) TOP MENU STRIP + DATE/TURN + BOTTOM MESSAGE LINE — func_06083A
 *     draw_map_view_chrome  @asm 0x06083A  (overlay_05C69C_0610DA.c).
 *
 * func_06083A is ~356 instructions of FIXED-coordinate draw calls (no game-rule
 * branching). The literal push-immediate coords are:
 *   set region/palette mode 0x22                          @asm 0x06084F -> 0x181F:0x484
 *   menu strip fill: color=0xF y=5 w=0x140(320) x=0       @asm 0x060898 -> 0x181F:0x100
 *   first text row : color=0xF y=0x19(25) x=0xA(10)       @asm 0x0608CE -> 0x181F:0x13C
 *   date/turn fields drawn at x=0x7D(125) and x=0xD0(208) @asm 0x0609C1/0x0609DE -> 0x181F:0x13C
 *   bottom strip box: ax=0x118(280) dx=0xAA(170) bx=0x135(309) push 0xBD(189),0
 *                                                         @asm 0x060BD6 -> 0x181F:0xCE
 *       (operands cited verbatim; under the 0xCE arg order ax=x,dx=y,bx=w,push h.
 *        NB: x+w here exceeds 320, so bx may be a 2nd X-coord rather than a width
 *        for this primitive — exact w-vs-x2 role is TBD, the raw values are solid.)
 *   full-screen frame box: x=0 w=0x140(320) h=0xC8(200)   @asm 0x060C1E -> 0x181F:0xE2
 *   tile-row label = ([0x9E14]/0x4A)+1                    @asm 0x06087D
 *
 * The per-item menu LABELS (GAME/VIEW/ORDERS/REPORTS/TRADE/CHEAT) are laid out
 * from a string table; their visible x-positions are frame-verified (kept in
 * topmenu_render below): x = 4, 44, 84, 144, 200, 244, y=2.
 * @ref RENDERER_GEOMETRY.md "Default map view sidebar" lines 532-551.
 * ---------------------------------------------------------------------------- */
#define MENU_STRIP_COLOR  0x0F     /* yellow-on-wood  @asm 0x060898 (push 0xf) */
#define MENU_STRIP_X      0        /*                 @asm 0x06089F (push 0) */
#define MENU_STRIP_Y      5        /*                 @asm 0x06089A (push 5) */
#define MENU_STRIP_W      0x140    /* 320 full width  @asm 0x06089C (push 0x140) */
#define MENU_ROW1_X       0x0A     /*  10  @asm 0x0608D2 (ax=0xa) */
#define MENU_ROW1_Y       0x19     /*  25  @asm 0x0608D0 (push 0x19) */
#define DATETURN_FIELD2_X 0x7D     /* 125  date/turn field  @asm 0x0609C1 (push 0x7d) */
#define DATETURN_FIELD3_X 0xD0     /* 208  date/turn field  @asm 0x0609DE (push 0xd0) */
#define MSGLINE_BOX_X     0x118    /* 280  bottom strip ax  @asm 0x060BDB (ax=0x118) */
#define MSGLINE_BOX_Y     0xAA     /* 170  bottom strip dx  @asm 0x060BDE (dx=0xaa) */
#define MSGLINE_BOX_W     0x135    /* 309  bottom strip bx (w or x2, TBD)  @asm 0x060BE1 (bx=0x135) */
#define MSGLINE_BOX_H     0xBD     /* 189  bottom strip push-h  @asm 0x060BD6 (push 0xbd) */
#define SCREEN_BOX_X      0        /*   0  full-screen frame  @asm 0x060C1E (push 0) */
#define SCREEN_BOX_W      0x140    /* 320  full-screen frame  @asm 0x060C20 (push 0x140) */
#define SCREEN_BOX_H      0xC8     /* 200  full-screen frame  @asm 0x060C23 (push 0xc8) */
#define G_MAPROW_TILE     0x9E14   /* tile-row label src; /0x4A+1  @asm 0x06087D */

/* ----------------------------------------------------------------------------
 * (D) STRUCTURED HUD PLACEMENT TABLE
 * ----------------------------------------------------------------------------
 * One row per HUD element: its screen rect (x,y,w,h) and the @asm offset of the
 * draw call that places it. w/h == -1 means "not a fixed rect" (text run anchored
 * at x,y, or a tile-grid region whose pixel size is the zoom-derived tile_px).
 * Coordinates are 320x200 native. This is the coded "what is placed where".
 * ---------------------------------------------------------------------------- */
struct hud_placement {
    const char *element;   /* HUD element name */
    int x, y, w, h;        /* screen rect; -1 = not a fixed pixel rect */
    const char *asm_src;   /* @asm offset of the placing draw call */
    const char *composer;  /* the decoded composer function */
};

static const struct hud_placement HUD_LAYOUT[] = {
    /* element                  x       y     w      h     @asm          composer */
    { "map_viewport",            0,      8,  240,   192,  "0x06787C",  "render_frame_setup"      }, /* zoom0: 15x12 tiles @16px */
    { "minimap_panel_frame",  0xF1,     8, 0x4F,  0x29,  "0x066CF4",  "minimap_panel(066CD6)"   }, /* outer box -> 0x181F:0xBA */
    { "minimap_inner_strip",  0xFB,     8, 0x30,     6,  "0x066D4B",  "minimap_panel(066CD6)"   }, /* -> 0x181F:0xCE */
    { "minimap_content",      0xFC,     9,   -1,    -1,  "0x0669CF",  "minimap_compose(066968)" }, /* anchor px (252,9) */
    { "minimap_viewport_box", 0xF1,     8, 0x29,  0x4F,  "0x066DD7",  "minimap_panel(066CD6)"   }, /* "you are here" -> 0x181F:0xE2 */
    { "top_menu_strip",          0,      5, 0x140,   -1,  "0x060898",  "draw_map_view_chrome"    }, /* fill -> 0x181F:0x100 */
    { "menu_text_row",        0x0A,  0x19,   -1,    -1,  "0x0608CE",  "draw_map_view_chrome"    }, /* -> 0x181F:0x13C */
    { "dateturn_readout_f2",  0x7D,  0x19,   -1,    -1,  "0x0609C1",  "draw_map_view_chrome"    }, /* x=125 */
    { "dateturn_readout_f3",  0xD0,  0x19,   -1,    -1,  "0x0609DE",  "draw_map_view_chrome"    }, /* x=208 */
    { "message_command_box", 0x118,  0xAA, 0x135,  0xBD,  "0x060BD6",  "draw_map_view_chrome"    }, /* -> 0x181F:0xCE */
    { "screen_frame_box",        0,      0, 0x140, 0xC8,  "0x060C1E",  "draw_map_view_chrome"    }, /* -> 0x181F:0xE2 */
    /* Sidebar status/unit-panel text rows: laid out by the in-game dispatch
     * overlay from LABELS/NAMES; on-screen positions frame-verified (see the
     * STATUS_ and UNITPANEL_ defines above; @ref RENDERER_GEOMETRY.md 542-551). */
    { "status_year",           244,    58,   -1,    -1,  "frame-verified", "RENDERER_GEOMETRY.md" },
    { "status_gold",           244,    66,   -1,    -1,  "frame-verified", "RENDERER_GEOMETRY.md" },
    { "status_tax",            290,    66,   -1,    -1,  "frame-verified", "RENDERER_GEOMETRY.md" },
    { "unit_panel_sprite",     244,    80,   -1,    -1,  "frame-verified", "RENDERER_GEOMETRY.md" },
};
#define HUD_LAYOUT_COUNT  (int)(sizeof(HUD_LAYOUT) / sizeof(HUD_LAYOUT[0]))

/* ----------------------------------------------------------------------------
 * Clip-rect global (NOT a popup rect).  BYTE-CITED.
 * @ref RENDERER_GEOMETRY.md "Screen-bounds reminder": DGROUP:0x839E..0x83A4 =
 *      (200, 320, 0, 15585) constant clip rect across all 396 trace snapshots.
 * The popup/dialog rect is computed inline by overlay func_07431E using the
 * GAME.TXT @width directive + cursor pos (DIALOG_GEOMETRY.md). The resident
 * func_067DC8 (compute_dialog_rect_from_cursor, BYTE_VERIFIED 2026-05-03)
 * writes its 4 computed values into &[0x839E] via the setter at 0x0C36:0x000A.
 * ---------------------------------------------------------------------------- */
#define G_SCREEN_BOUNDS  0x839E   /* clip rect [0x839E..0x83A4] */

/* ----------------------------------------------------------------------------
 * Data sources for the status line + CC display.  BYTE-CITED.
 *   PowerRecord (power.h): stride 0x13C, base DGROUP:0x8808.
 *     tax_rate          +0x01
 *     congress_progress +0x0C   (bells toward next FF)
 *     liberty_bells     +0x0E
 *     founding_fathers  +0x14
 *     gold              +0x2A   (treasury dword)
 *   Per project memory 2026-05-05 (firmer than power.h pads):
 *     rebel_pct         +0x02   (byte; tory = 100 - rebel)
 *     boycott_bitfield  +0x20
 *   REF counts (DGROUP, byte-verified, memory 2026-05-05):
 *     regulars 0x53DA, cavalry 0x53DC, man-o-war 0x53DE, artillery 0x53E0.
 * ---------------------------------------------------------------------------- */
#define PR_TAX_RATE          0x01
#define PR_REBEL_PCT         0x02   /* @ref memory project_king_anger_and_ref */
#define PR_CONGRESS_PROGRESS 0x0C
#define PR_LIBERTY_BELLS     0x0E
#define PR_FF_COUNT          0x14
#define PR_BOYCOTT           0x20
#define PR_GOLD              0x2A

#define G_REF_REGULARS   0x53DA
#define G_REF_CAVALRY    0x53DC
#define G_REF_MANOWAR    0x53DE   /* slot 2 (memory: NOT slot 3) */
#define G_REF_ARTILLERY  0x53E0   /* slot 3 (memory: NOT slot 2) */

/* ----------------------------------------------------------------------------
 * Draw primitives — ALL TBD (emitted by the dispatch overlay, not decoded to a
 * file offset yet). Declared so the layout reads, but each is a stub.
 * ---------------------------------------------------------------------------- */

/* Blit a PIK/sheet sprite. Resident-or-overlay routine TBD (load_PIK is
 * LCALL 0x191F:0x087A per RENDERER_GEOMETRY.md; text via FONTSMAL/FONTKING). */
extern void hud_blit(int sprite_id, int x, int y);                 /* TBD */

/* Draw a text run. The original resolves strings from LABELS.TXT/NAMES.TXT and
 * renders with FONTSMAL (6x8) / FONTTINY (5x6) / FONTKING (8x16). The font
 * blit routine is TBD. */
extern void hud_text(int font_id, int x, int y, const char *s);    /* TBD */

/* Render the squashed minimap into MINIMAP rect (58x72 world -> 72x44). The
 * minimap composer is overlay/data-driven; TBD. */
extern void hud_minimap_render(int rx, int ry, int rw, int rh);    /* TBD */

/* ----------------------------------------------------------------------------
 * sidebar_render -- compose the map-view sidebar.
 * ----------------------------------------------------------------------------
 * Layout is frame-verified; data reads are byte-cited; the emits are TBD.
 * `pr` is the active player's PowerRecord; `sel_unit_idx` < 0 = none selected.
 * ---------------------------------------------------------------------------- */
void sidebar_render(struct PowerRecord *pr, int sel_unit_idx)
{
    /* 1. WOODPANL.PIK background fills SIDEBAR rect.  @ref RENDERER_GEOMETRY.md
     *    "Default map view sidebar" / load_PIK LCALL 0x191F:0x087A. (TBD emit) */
    hud_blit(/*WOODPANL*/ -1, SIDEBAR_X, SIDEBAR_Y);

    /* 2. Minimap (58x72 world squashed into 72x44).  @ref MINIMAP rect. */
    hud_minimap_render(MINIMAP_X, MINIMAP_Y, MINIMAP_W, MINIMAP_H);

    /* 3. Status lines. Data byte-cited; format strings come from LABELS.TXT.
     *    year  : "Spring %YEAR"          @ (244,58)
     *    gold  : "Gold: %NUMBER%%"       @ (244,66)  <- pr->gold (PR_GOLD +0x2A)
     *    tax   : "Tax: %NUMBER2%%"       @ (290,66)  <- pr->tax_rate (+0x01) */
    hud_text(/*FONTSMAL*/ 0, STATUS_YEAR_X, STATUS_YEAR_Y, /*year str*/ 0);
    hud_text(/*FONTSMAL*/ 0, STATUS_GOLD_X, STATUS_GOLD_Y, /*gold str*/ 0);
    hud_text(/*FONTSMAL*/ 0, STATUS_TAX_X,  STATUS_TAX_Y,  /*tax  str*/ 0);
    (void)pr;  /* fields read via PR_GOLD / PR_TAX_RATE at the real call site */

    /* 4. Selected-unit panel (only when a unit is selected). */
    if (sel_unit_idx >= 0) {
        /* sprite  @ (244,80)  ICONS.SS[<unit map sprite>]  (see units.c, CITED) */
        hud_blit(/*unit sprite*/ -1, UNITPANEL_SPRITE_X, UNITPANEL_SPRITE_Y);
        /* "Moves: N"     LABELS @INFO[0]  @ (270,82) */
        hud_text(0, UNITPANEL_MOVES_X,  UNITPANEL_MOVES_Y,  0);
        /* "Locat: (x,y)" LABELS @INFO[1]  @ (270,92) */
        hud_text(0, UNITPANEL_LOC_X,    UNITPANEL_LOC_Y,    0);
        /* unit type      NAMES @UNIT[type]  @ (244,104) */
        hud_text(0, UNITPANEL_TYPE_X,   UNITPANEL_TYPE_Y,   0);
        /* unit skill     NAMES @JOB[skill]  @ (244,112) */
        hud_text(0, UNITPANEL_SKILL_X,  UNITPANEL_SKILL_Y,  0);
        /* orders         LABELS @MISC       @ (244,120) */
        hud_text(0, UNITPANEL_ORDERS_X, UNITPANEL_ORDERS_Y, 0);
        /* "(Terrain)"    NAMES @UNFORESTED/@FORESTED  @ (244,128) */
        hud_text(0, UNITPANEL_TERR_X,   UNITPANEL_TERR_Y,   0);
    }
}

/* ----------------------------------------------------------------------------
 * topmenu_render -- the top menu strip (0,0,320,8).
 * ----------------------------------------------------------------------------
 * Labels from LABELS.TXT @MISC (+ "COLONIZOPEDIA"); x positions frame-verified
 * ("Default map view sidebar" table). FONTSMAL yellow on wood. Emits TBD.
 * ---------------------------------------------------------------------------- */
void topmenu_render(void)
{
    /* GAME(4) VIEW(44) ORDERS(84) REPORTS(144) TRADE(200) CHEAT(244)
     * COLONIZOPEDIA(234 right). @ref RENDERER_GEOMETRY.md lines 532-538. */
    hud_text(0,   4, 2, /*GAME*/  0);
    hud_text(0,  44, 2, /*VIEW*/  0);
    hud_text(0,  84, 2, /*ORDERS*/0);
    hud_text(0, 144, 2, /*REPORTS*/0);
    hud_text(0, 200, 2, /*TRADE*/ 0);
    hud_text(0, 244, 2, /*CHEAT*/ 0);
    hud_text(0, 234, 2, /*COLONIZOPEDIA*/ 0);
}
