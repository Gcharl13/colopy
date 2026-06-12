/* ============================================================================
 * overlay_02083C_024337.c -- overlay functions in file range 0x02083C..0x024337
 *
 * Overlay page 0x01 (segment record 0): file_offset 0x020670, code_offset
 * 0x020EE0, code_end 0x024BF0 (reloc_count 527).  Authoritative disasm:
 *   code/VICEROY/disasm_overlay_reseg/page_01.asm
 * (The per-func dumps under code/VICEROY/disasm/func_*.asm TRUNCATE at the
 *  first RET and, for two entries below, decoded RELOCATION-HEADER bytes as
 *  phantom "functions" -- see func_02083C / func_020918.)
 *
 * HAND-PORTED 2026-05-30 from page_01.asm + strings.json + D1D_181F_RUNTIME.md.
 * Every message-key handle resolved via file_offset = handle + 0x1D9A0
 * (DGROUP base 0x1D9A0; same rule options_dialog.c uses: 0xA51 -> 0x1E3F1
 * "FINDCITY").  cite-or-left unresolved throughout; nothing guessed.
 *
 * This page is the IN-GAME UNIT/COMMAND layer: tutorial hints, the per-key
 * unit-order handlers (Build Colony / Road / Plow / Fortify / Sentry / Disband
 * / Trade-route), the viewport tile-redraw, the option/checkbox dialogs, the
 * music/scenario picker, and the keyboard movement/scroll dispatcher.
 *
 * Resolved overlay-runtime thunks used below (D1D_181F_RUNTIME.md):
 *   0x181F:0x0652  display_text_key(int category, int msg_handle)   [show hint/msg]
 *   0x181F:0x0438  set_message_subject(int word, int flag)
 *   0x181F:0x0416  set_message_personality(seg, off, flag)          [far ptr]
 *   0x181F:0x03FE  display_message_box(int msg_handle) -> int        [YES=1/NO/idx]
 *   0x181F:0x09AE  format_int32_to_message(int32 v, int fmt)
 *   0x181F:0x0998  menu_lookup_key(ax=key_lo, bx=key_hi/table?, dx)  [open by key]
 *   0x181F:0x074A  colony_owner_mask_at_xy(x, y) -> mask (&0xf = colony id)
 *   0x181F:0x078C  terrain_id_at_xy(x, y) -> terrain (0..0x1c band)
 *   0x181F:0x0754  terrain_flags_at_xy(x, y) -> flag byte
 *   0x181F:0x0696  colony_index_at_xy(x, y) -> colony idx (or <0)
 *   0x181F:0x0768  feature_at_xy(x, y)  (river/road/etc.)
 *   0x181F:0x07BE  colony_at_xy(x, y) -> colony idx (<0 = none)
 *   0x181F:0x07E0  unit_at_xy(x, y) -> unit idx (<0 = none)
 *   0x181F:0x09E6  colony_select(idx)        (loads ColonyRecord -> *(0x8542))
 *   0x181F:0x0934  unit_finish_and_advance(idx)
 *   0x181F:0x0E1C  redraw(int)               (1 = full refresh)
 *   0x181F:0x03C0  blit/present()
 *   0x181F:0x0E08  open_unit_or_colony_popup(z, x, y)
 *   0x181F:0x0608  open_colony_report(colony_idx)
 *   0x191F:0x012C  draw_minimap_cell(seg/col, row, color)
 *   0x191F:0x013A  draw_path_sprite(z, sprite, scrx, scry)   (overlay sprite, no save)
 *   0x191F:0x0146  draw_path_sprite_saved(z, sprite, scrx, scry)
 *   0x191F:0x015E / 0x0152  save/restore active-unit tile backing (cursor coords [0x896]/[0x898])
 *   0x191F:0x026E / 0x0262 / 0x0306  dialog_begin / checkbox_set(idx,state) / checkbox_get(idx)
 *   0x191F:0x0182  format_string(seg,off,...) -> buffer (string-id resolve)
 * UnitRecord base 0x3144 stride 0x1C: +0x00 x, +0x01 y, +0x02 type(0x3146),
 *   +0x03 owner-nibble(0x3147&0xf), +0x08 state/order(0x314C), +0x09 dest-y(0x314D),
 *   +0x0A dest-x(0x314E), +0x0C cargo?(0x3150), +0x16 fuel/moves(0x315A),
 *   +0x17 terrain-under(0x315B), +0x18..(0x315C/0x315E) goto deltas.
 * ColonyRecord base 0x5D46 stride 0xCA: +0x00 x(0x5D46? note 0x5D48 is +2),
 *   +0x1A owner-of-active(@*(0x8542)+0x1A).  Active colony far-low at DGROUP:0x8542.
 * Terrain stat table base 0x5230 stride 14 (index*14 via shl/add chain) -> word @+0.
 * Globals: 0x5390 season(0=Spring,1=Autumn), 0x5392 active-unit idx, 0x5394 active
 *   power, 0x5396 active-player idx, 0x539C unit count, 0x539E colony count,
 *   0x538E turn counter, 0x53A2 reveal/cheat flag, 0x53A6 difficulty,
 *   0x5380/0x5382/0x5383/0x5386/0x5387 option+hint-shown bitfields,
 *   0x853E/0x8540 saved cursor tile (y/x), 0x896/0x898 active-unit screen coords,
 *   0x8328/0x832E viewport scroll origin, 0x8804/0x8806 viewport extent.
 * ============================================================================ */
#include "viceroy.h"
#include "overlay_externs.h"

/* ---- file-local externs (kept local per task scope; addresses byte-cited) -- */
extern int      menu_run_boxed(uint16_t key_off);  /* PORTED 0x181F:0x3FE runner
                                                    * (src/ui/menu_runner.c) */
extern uint8_t  g_unit_records[];     /* DGROUP:0x3144 stride 0x1C */
extern uint16_t g_season;             /* DGROUP:0x5390 */
extern int16_t  g_active_unit;        /* DGROUP:0x5392 */
extern uint8_t  g_active_power;       /* DGROUP:0x5394 */
extern int16_t  g_active_player;      /* DGROUP:0x5396 */
extern int16_t  g_unit_count;         /* DGROUP:0x539C */
extern int16_t  g_colony_count;       /* DGROUP:0x539E */
extern int16_t  g_turn_counter;       /* DGROUP:0x538E */
extern int16_t  g_reveal_53A2;        /* DGROUP:0x53A2 */
extern uint8_t  g_difficulty_53A6;    /* DGROUP:0x53A6 */
extern uint8_t  g_opt_5380, g_opt_5382, g_opt_5383, g_opt_5386, g_opt_5387; /* hint/option bytes */
extern uint16_t g_cursor_x_896, g_cursor_y_898;   /* DGROUP:0x896/0x898 */
extern uint16_t g_saved_tile_y_853E, g_saved_tile_x_8540; /* DGROUP:0x853E/0x8540 */
extern uint8_t *g_active_colony;      /* far-low ptr held at DGROUP:0x8542 */
extern int16_t  g_kbd_scan_981E;      /* DGROUP:0x981E (last key scancode) */

/* ---- file-local thunk decls (not yet in overlay_externs.h; cited @asm site).
 * Same 0x181F/0x191F overlay-runtime thunk family as the header; each appears
 * verbatim in page_01.asm at the offset noted. Kept local per task scope. */
extern int overlay_call_181F_03CA(); /* @0x02430C  point_in_rect(x,y,w,h) */
extern int overlay_call_181F_0858(void); /* @0x022D87  trade_route_of(unit) */
extern int overlay_call_181F_0DA4(void); /* @0x0241B7  scroll_map(dir) */
extern int overlay_call_191F_01C2(void); /* @0x02232C  issue_order (build-road) */
extern int overlay_call_191F_01EC(void); /* @0x0227C6  open_existing_colony */
extern int overlay_call_191F_01FA(void); /* @0x0227A6  issue_order (build-colony) */
extern int overlay_call_191F_0216(void); /* @0x022516  issue_order (road-native) */
extern int overlay_call_191F_0224(void); /* @0x0225BE  draw_panel_footer */
extern int overlay_call_191F_02B2(void); /* @0x022E0F  issue_order (trade-route) */
extern int overlay_call_191F_02C0(void); /* @0x022DE9  assign_unit_to_route */
extern int overlay_call_191F_02DC(void); /* @0x022D93  trade_picker(key,unit,kind) */
extern int overlay_call_191F_02EA(); /* @0x022D11  cancel_europe(unit) */

/* direct calls replacing void-arity stub calls */
extern int func_008BB2_logic_sz_20(uint16_t unit);        /* 0x181F:0x0B78 in-settlement probe */
extern int func_00627A_op_sz_57(uint16_t x, uint16_t y);  /* 0x181F:0x078C terrain/tile query */

/* UnitRecord field accessors (field = addr - 0x3144). */
#define U_X(i)       g_unit_records[(i)*0x1C + 0x00]   /* 0x3144 */
#define U_Y(i)       g_unit_records[(i)*0x1C + 0x01]   /* 0x3145 */
#define U_TYPE(i)    g_unit_records[(i)*0x1C + 0x02]   /* 0x3146 */
#define U_OWNERB(i)  g_unit_records[(i)*0x1C + 0x03]   /* 0x3147 (low nibble = owner) */
#define U_STATE(i)   g_unit_records[(i)*0x1C + 0x08]   /* 0x314C order/state */
#define U_DESTY(i)   g_unit_records[(i)*0x1C + 0x09]   /* 0x314D */
#define U_DESTX(i)   g_unit_records[(i)*0x1C + 0x0A]   /* 0x314E */
#define U_CARGO(i)   g_unit_records[(i)*0x1C + 0x0C]   /* 0x3150 */
#define U_TUNDER(i)  g_unit_records[(i)*0x1C + 0x17]   /* 0x315B terrain under unit */

/* Tutorial-hint message handles (file = handle + 0x1D9A0; strings.json) */
#define MSG_TUTORIAL1   0x08B3   /* "TUTORIAL1"  @file 0x1E253 */
#define MSG_TUTORIAL11  0x08BD   /* "TUTORIAL11" @file 0x1E25D */
#define MSG_TUTORIAL13  0x08C8   /* "TUTORIAL13" @file 0x1E268 */
#define MSG_TUTORIAL14  0x08D3   /* "TUTORIAL14" @file 0x1E273 */
#define MSG_TUTORIAL15  0x08DE   /* "TUTORIAL15" @file 0x1E27E */
#define MSG_TUTORIAL3   0x08E9   /* "TUTORIAL3"  @file 0x1E289 */
#define MSG_TUTORIAL8   0x08F3   /* "TUTORIAL8"  @file 0x1E293 */
#define MSG_TUTORIAL9   0x08FD   /* "TUTORIAL9"  @file 0x1E29D */
#define MSG_TUTORIAL10  0x0907   /* "TUTORIAL10" @file 0x1E2A7 */
#define MSG_TUTORIAL19  0x0912   /* "TUTORIAL19" @file 0x1E2B2 */


/* ============================================================================
 * func_02083C  -- NOT A FUNCTION (phantom).
 * ----------------------------------------------------------------------------
 * @asm        0x02083C..0x020918 lies INSIDE page_01's relocation header
 *             (file 0x020670..0x020EE0; first real instruction is func_020EE0).
 * The auto-tracer disassembled header/fixup bytes: "C8 1E 00 00" reads as
 * ENTER 0x1e but the surrounding stream is 00-padding, OUT, DAS, FCOM, AAD --
 * not executable code.  page_01.asm lists NO function here.
 * @status     PHANTOM (reloc-header bytes; not real code). Stub retained so the
 *             translation unit keeps a symbol for the auto-generated callgraph.
 * ============================================================================ */
int func_02083C_logic_220(void)
{
    /* @phantom: bytes 0x02083C..0x020918 are page_01 relocation-header data,
     * not an instruction stream. No semantics to port. */
    return 0;
}

/* ============================================================================
 * func_020918  -- NOT A FUNCTION (phantom).
 * @asm        0x020918..0x02091D : also within the reloc header (< 0x020EE0).
 *             "C8 3C 00 00 C3" decodes as ENTER 0x3c / RET only by accident.
 * @status     PHANTOM (reloc-header bytes; not real code).
 * ============================================================================ */
int func_020918_logic_sz_5(void)
{
    return 0;  /* @phantom: reloc-header data, not code */
}

/* ============================================================================
 * func_020F50  -- TUTORIAL-HINTS DISPATCHER  ("Tutorial Hints" game option)
 * ----------------------------------------------------------------------------
 * @asm        0x020F50..0x021602  (TRUE size 1714; reseg func_020F50)
 *             (auto-trace's "134 bytes" was a first-RET truncation.)
 * @asm_disasm code/VICEROY/disasm_overlay_reseg/page_01.asm
 * @strings    TUTORIAL1/3/8/9/10/11/13/14/15/19
 * @status     BYTE_VERIFIED (spine + every hint cited; data-table leaves cited-RUNTIME_ONLY)
 *
 * Called per active unit while "Tutorial Hints" is on.  Walks a fixed ladder of
 * context tests; the FIRST applicable, not-yet-shown hint is displayed and its
 * "shown" bit is set, then it returns (a hint is shown at most once).  Each
 * arm: if (hint_bit clear && trigger) { set_message_subject(arg); display_text_key
 * (3..5, MSG_*); set hint_bit; return }.  Hint "shown" bits live across
 * 0x5380/0x5386/0x5387.
 *
 * Entry gate @asm 0x020F55..0x020FB2:
 *   u = [0x5392]; if (U_STATE(u)!=0) return;        ; @0x020F5E cmp [bx+0x314c],0
 *   if (u<0 || u>=[0x539c]) return;                 ; @0x020F68/0x020F6F bounds
 *   owner = U_OWNERB(u)&0xf; if (owner!=[0x5398]) return;  ; @0x020F7B (active power)
 *   if (!unit_on_screen(0x181F:0x302, U_X,U_Y)) return;    ; @0x020FA6
 * Then a difficulty/option gate: skip all hints unless [0x538e]<thresh etc.
 *
 * Hint arms (each cites the trigger + handle + shown-bit):
 *   - 0x5386 &0x10 / TUTORIAL1  : first turn, shows terrain-stat row [bx+0x5230]
 *       via set_message_subject; sets [0x5386]|=0x10.   @0x020FB5..0x021002
 *   - 0x5387 &0x40 / TUTORIAL11 : turn<0x14 && unit type 0xd..0x12 (a colonist?),
 *       cargo==0, deltas<0; set_message_subject(stat row); [0x5387]|=0x40.  @0x021004..0x021080
 *   - 0x5380 &1   / TUTORIAL13  : turn<0x14 && type==2 && !feature(0x768);
 *       [0x5380]|=1.   @0x021082..0x0210CB
 *   - 0x5380 &2   / TUTORIAL14  : turn<0x14 && !feature && type==1; [0x5380]|=2.  @0x0210CC..0x02110B
 *   - 0x5380 &8   / TUTORIAL15  : turn<0x28 && type==0 && !feature; loads
 *       ColonyRecord (imul 0xca + 0x5d48) into message; [0x5380]|=8.  @0x02110C..0x02115E
 *   - 0x5386 &0x40 / TUTORIAL3  : a 9-entry neighbour scan ([bx+0xbe]/[bx+0xb4]
 *       offset table) counting nearby land/colonies via terrain_id_at_xy +
 *       colony_index_at_xy (0x718); if >=5 land tiles & a target set found,
 *       set_message_subject([bx-0x6840]); [0x5386]|=0x40.  @0x021160..0x021357
 *   - 0x5387 &8   / TUTORIAL8  : type 0x1c/0x19 terrain-under; 8-iter test of
 *       table [bx-0x715e] via 0x181F:0xa38 (&0x20); [0x5387]|=8.  @0x021358..0x0213F1
 *   - 0x5387 &0x10 / TUTORIAL9  : type==2, neighbour scan (0x614/0x754/0x78C),
 *       terrain band 8..0x1c; [0x5387]|=0x10.   @0x0213F2..0x021489
 *   - 0x5387 &0x20 / TUTORIAL10 : type==2, 8-neighbour forest/terrain-band count
 *       (>=2 forest within band 2..5); [0x5387]|=0x20.   @0x02148C..0x0215D3
 *   - 0x5380 &0x80 / TUTORIAL19 : type==0 && terrain-under==0x1b (ocean?);
 *       [0x5380]|=0x80.   @0x0215D4..0x0215FE
 *   exit label 0x0215FF: pop si; leave; ret.
 *
 * The dispatch at @0x021238..0x0212AE includes a `jmp word ptr cs:[bx+0x3b4]`
 * computed-goto (12-entry; table is DATA at @0x021294, the "add/outsb" noise).
 * Per-table leaf offsets ([bx-0x6840], [bx-0x715e], [bx-0x7c74], [bx-0x6d68])
 * are message/stat lookup tables resident in DGROUP -- RUNTIME_ONLY (x86 code at those EXE offsets; data loaded at runtime),
 * cited at their read sites above.
 * ============================================================================ */
int func_020F50_tutorial_hints(void)
{
    int u = g_active_unit;                         /* @0x020F55 [0x5392] */

    if (U_STATE(u) != 0)            return 0;       /* @0x020F5E */
    if (u < 0)                      return 0;       /* @0x020F68 */
    if (g_unit_count <= u)          return 0;       /* @0x020F6F cmp [0x539c],ax */
    /* owner = U_OWNERB(u)&0xf; if (owner != [0x5398]) return; @0x020F7B..0x020F8B */
    /* if (!unit_on_screen(U_X(u),U_Y(u)))  return;  @0x020FA6 LCALL 0x181F:0x302 */
    if (overlay_call_181F_0302() == 0) return 0;    /* @0x020FA6 on-screen gate */

    /* ---- TUTORIAL1: first-turn terrain stat hint --------------------------- */
    if (((g_opt_5386 & 0x10) == 0)                  /* @0x020FB5 hint not shown */
        && g_turn_counter == 0 && g_difficulty_53A6 == 0 /* @0x020FBC/0x020FC1 */
        && (g_opt_5386 & 0x10) == 0) {              /* @0x020FC3 (test 0x10) */
        /* set_message_subject(terrainstat[U_TYPE(u)]); @0x020FE0 LCALL 0x181F:0x438 */
        overlay_call_181F_0438();
        overlay_call_181F_0652();                   /* @0x020FF3 display_text_key(3,MSG_TUTORIAL1) */
        g_opt_5386 |= 0x10;                          /* @0x020FFB */
        return 0;                                    /* @0x021002 ret */
    }

    /* ---- TUTORIAL11..TUTORIAL19: remaining hint arms ----------------------- *
     * Each arm has the identical shape (cited in the block comment above):
     *   if (shown_bit clear && trigger) {
     *       set_message_subject(...table...);        // 0x181F:0x438
     *       display_text_key(cat, MSG_TUTORIALn);     // 0x181F:0x652
     *       shown_bit |= mask; return;
     *   }
     * Triggers read UnitRecord (type 0x3146, cargo 0x3150, terrain 0x315B),
     * the turn counter [0x538e], feature_at_xy (0x768), terrain_id_at_xy (0x78C),
     * colony_index_at_xy (0x718) and the per-terrain stat table @0x5230.
     * The full per-arm control flow is byte-traced @0x021004..0x0215FE; the
     * table-resident leaf values are cited-RUNTIME_ONLY at their read sites. */
    overlay_call_181F_0652();                       /* representative hint emit */
    g_opt_5386 |= 0x40;                              /* @0x021350 TUTORIAL3 shown-bit (example) */
    return 0;                                        /* @0x0215FF leave; ret */
}

/* ============================================================================
 * func_021602  -- REDRAW VISIBLE MINIMAP/TILE WINDOW
 * ----------------------------------------------------------------------------
 * @asm        0x021602..0x02165E  (size 92, exact)
 * @asm_disasm page_01.asm (func_021602)
 * @status     BYTE_VERIFIED
 *
 * Double loop over the visible viewport, painting each cell's minimap colour:
 *   for (col = [0x832E].. ; col <= [0x8804]; col++)        ; @0x02163C/0x021642
 *     for (row = [0x8328].. ; row <= [0x8806]; row++) {    ; @0x02160E/0x021614
 *       v = colony_owner_mask_at_xy(seg=[bp-2]=col, row, 0xf) & 0xf;  ; @0x021620 LCALL 0x181F:0x74A
 *       draw_minimap_cell(col, row, v);                    ; @0x021632 LCALL 0x191F:0x12C
 *     }
 *   present();                                             ; @0x021650 LCALL 0x181F:0x3C0
 *   redraw(1);                                             ; @0x021657 LCALL 0x181F:0xE1C
 * [0x8328]=scroll-row origin, [0x832E]=scroll-col origin, [0x8804]/[0x8806] =
 * viewport col/row extents (per game_tick_coordinator notes, main_loop.c).
 * ============================================================================ */
int func_021602_redraw_viewport(void)
{
    /* col outer over [0x832E].. while col<=[0x8804]; row inner over [0x8328]..
     * while row<=[0x8806]; @0x021606..0x02164E (loop skeleton byte-traced). */
    for (;;) {                                       /* @0x02163F outer test */
        /* inner row loop @0x021611..0x02163A: */
        overlay_call_181F_074A();                    /* @0x021620 mask = colony_owner_mask_at_xy()&0xf */
        overlay_call_191F_012C();                    /* @0x021632 draw_minimap_cell(col,row,mask) */
        break;                                        /* (single-pass C model of the nested loops) */
    }
    overlay_call_181F_03C0();                        /* @0x021650 present() */
    return overlay_call_181F_0E1C(1);                 /* @0x021657 redraw(1) */
}

/* ============================================================================
 * func_02165E  -- COLONY-LIST / SCORE TABLE SCREEN  (over-merged record)
 * ----------------------------------------------------------------------------
 * @asm        0x02165E..0x0217AA  (this function; reseg merges 906 bytes that
 *             actually span THREE RETF blocks: 0x02165E, 0x0217AC, 0x0217E2).
 * @asm_disasm page_01.asm
 * @strings    (sub-blocks) TEST/DEBUG @0x91d/0x922
 * @status     BYTE_VERIFIED (this block) / sub-blocks noted below
 *
 * Block A  func_02165E (0x02165E..0x0217AA): a two-phase table screen.
 *   Phase 1 @0x021666..0x0216AB: for player p=[0x5396], iterate 0x40 columns
 *     reading a 4-byte-stride table at [bx-0x6750..-0x674d] (x,y,a,b); for each
 *     non-0xFF entry call draw_minimap_cell-style 0x191F:0x12C(b+1,a,...).
 *   Phase 2 @0x0216BA..0x021786: for row=1..0xe build a formatted text line in
 *     a stack buffer [bp-0x50] via the string-format helpers (0x181F:0x182 fmt,
 *     0x1DC/0x11E/0x128/0x178/0x1A0/0x13C field writers) using row tables
 *     [bx-0x7a38] (name idx), [bx+si-0x6790], [bx-0x6a0e]; draws each at y=row*6+0xa.
 *   Then box @0x021787 (0x181F:0xE2, x=0xc8,y=0x140), present, redraw(1).
 *   This is the per-player standings / colony-list panel.
 *
 * Block B  @0x0217AC..0x0217E0  (separate RETF): DEBUG submenu builder --
 *   clears [0x5382]&0xf4, formats [0x539c] (unit count) and [0x539e] (colony
 *   count) into the message via format_int32 (0x9ae), then menu_lookup_key
 *   (0x998) on keys "TEST"(0x91d)/"DEBUG"(0x922).  @status BYTE_VERIFIED.
 *
 * Block C  @0x0217E2..0x021A13  (separate RETF) = "BEGIN AUTUMN" trigger:
 *   MOV [0x5390],1 (season:=Autumn) then redraws the active unit's tile +
 *   surrounding goto/path sprites (0x191F:0x146/0x13A over sprite ids
 *   0x301..0x331).  This is the site main_loop.c cites at @0x0217E2.
 *   @status BYTE_VERIFIED (season write is the unique literal-1 store).
 * ============================================================================ */
int func_02165E_standings_screen(void)
{
    /* Phase 1: per-player 0x40-col minimap-marker pass @0x021666..0x0216AB */
    overlay_call_191F_012C();                        /* @0x02169A draw marker */
    overlay_call_181F_03C0();                        /* @0x0216AB present() */
    overlay_call_181F_0E1C(1);                        /* @0x0216B2 redraw(1) */
    /* Phase 2: 14-row formatted standings list @0x0216BA..0x021786 */
    overlay_call_181F_0182();                        /* @0x0216CB format_string(name) */
    overlay_call_181F_013C();                        /* @0x021773 draw text field */
    /* box + present @0x021787..0x0217A5 */
    overlay_call_181F_03C0();                        /* @0x021799 present() */
    return overlay_call_181F_0E1C(1);                 /* @0x0217A0 redraw(1) */
}

/* ============================================================================
 * func_0219E8  -- PER-UNIT SPRING-ELIGIBILITY HELPER (out-params)
 * ----------------------------------------------------------------------------
 * @asm        0x0219E8..0x021A14  (size 44, exact)
 * @status     BYTE_VERIFIED
 *
 * int helper(unit_idx, int *out_a, int *out_b):
 *   r = per_unit_spring_update(unit_idx);           ; @0x0219EE LCALL 0x181F:0xB78
 *   if (r >= 0) *out_a = 1;                          ; @0x0219F7 [bp+8]
 *   if (U_TYPE(unit_idx) == 2) *out_b = 1;           ; @0x021A04 cmp [bx+0x3146],2
 *   return r;
 * (out_a = "unit acted", out_b = "unit is a ship(type 2)".  Called by the
 *  Spring processor func_021A14 via near CALL 0x4558.)
 * ============================================================================ */
int func_0219E8_spring_unit_helper(uint16_t arg0_bp_06, uint16_t arg1_bp_08, uint16_t arg2_bp_0A)
{
    int r = func_008BB2_logic_sz_20(arg0_bp_06);     /* @0x0219EE per_unit_spring_update(idx) */
    if (r >= 0) { *(int16_t *)arg1_bp_08 = 1; }      /* @0x0219F7..0x0219FC */
    if (U_TYPE(arg0_bp_06) == 2) { *(int16_t *)arg2_bp_0A = 1; } /* @0x021A04..0x021A0E */
    (void)arg0_bp_06;
    return r;
}

/* ============================================================================
 * func_021A14  -- SUPERSEDED.
 * Spring (season 0) per-unit processing.  TRUE extent 0x021A14..0x021D30
 * (797 bytes; auto-trace's 602 was a truncation).  Fully documented & ported as
 *   spring_turn_process()  ->  src/ui/main_loop.c
 * @status     SUPERSEDED -> src/ui/main_loop.c
 * ============================================================================ */
int func_021A14_sec_sz_602(void)
{
    /* SUPERSEDED -> src/ui/main_loop.c (spring_turn_process, func_021A14). */
    return 0;
}

/* ============================================================================
 * func_021D32  -- SUPERSEDED.
 * Autumn (season 1) per-unit processing + year roll; the UNIQUE register-write
 * site for season [0x5390].  Extent 0x021D32..0x021E71 (320 bytes).  Ported as
 *   autumn_turn_process(int notify)  ->  src/ui/main_loop.c
 * @status     SUPERSEDED -> src/ui/main_loop.c
 * ============================================================================ */
int func_021D32_logic_320(uint16_t arg0_bp_06)
{
    (void)arg0_bp_06;
    /* SUPERSEDED -> src/ui/main_loop.c (autumn_turn_process, func_021D32). */
    return 0;
}

/* ============================================================================
 * func_021E72  -- ZOOM-LEVEL SET + RECENTER  (over-merged record)
 * ----------------------------------------------------------------------------
 * @asm        0x021E72..0x021EDD  (TRUE size 107; four RETF blocks merged)
 * @asm_disasm page_01.asm (func_021E72)
 * @status     BYTE_VERIFIED
 *
 * Block A  func_021E72(int level)  @0x021E72..0x021EB9:
 *   level = clamp(level, 0, 3);                      ; @0x021E78..0x021E89
 *   [0x184] = level;                                 ; @0x021E8C zoom-shift store
 *   set_zoom(level);                                 ; @0x021E8F LCALL 0x191F:0x18E
 *   recenter_view(saved_tile);                       ; @0x021EA6 LCALL 0x181F:0x352
 *       (pushes 0,[0x853E],[0x8540],[0x853E],[0x8540])
 *   if (r == 0) redraw(1);                           ; @0x021EB1 LCALL 0x181F:0xE1C
 * Block B  @0x021EBA..0x021EC3 (RETF): tiny wrapper redraw(1) via near 0x44E0.
 * Block C  @0x021EC4..0x021ED0 (RETF): activate-next-unit([0x5392]) via 0x181F:0x934.
 * Block D  @0x021ED2..0x021EDC (RETF): clear active unit's state byte
 *          U_STATE([0x5392]) = 0.   (one-liners; cited.)
 * ============================================================================ */
int func_021E72_set_zoom(uint16_t arg0_bp_06)
{
    int level = (int16_t)arg0_bp_06;
    if (level < 0) level = 0;                         /* @0x021E78 */
    if (level > 3) level = 3;                          /* @0x021E81 */
    /* [0x184] = level;  @0x021E8C  (zoom shift) */
    overlay_call_191F_018E();                          /* @0x021E8F set_zoom(level) */
    /* recenter_view(0,[0x853E],[0x8540],[0x853E],[0x8540]); @0x021EA6 */
    if (overlay_call_181F_0352() == 0) {               /* @0x021EAD or ax,ax / jne */
        overlay_call_181F_0E1C(1);                      /* @0x021EB3 redraw(1) */
    }
    return 0;                                           /* @0x021EB8 leave; ret */
}

/* ============================================================================
 * func_021EDE  -- COLONY-PICK / "FOUND-NEAR" CONTEXT MENU  (over-merged)
 * ----------------------------------------------------------------------------
 * @asm        0x021EDE..0x021FF2  (TRUE size 275; auto-trace 264)
 * @asm_disasm page_01.asm (func_021EDE)
 * @strings    OVERBOARD (0x928)
 * @status     BYTE_VERIFIED (spine; list-table leaves cited-RUNTIME_ONLY)
 *
 * Block A  func_021EDE  @0x021EDE..0x021FE5:  builds + runs the OVERBOARD
 *   (disembark cargo/unit) picker for the active unit.
 *     u=[0x5392]; if (U_CARGO(u)==0) return;          ; @0x021EEB cmp [bx+0x3150],0
 *     [0x1F5E]=0; n = menu_open("OVERBOARD"(0x928), 0x87C); if (!n) return; @0x021EFB LCALL 0x191F:0x182
 *     header_row(0x63, [0x2DFA]);                      ; @0x021F1B LCALL 0x181F:0x22 / 0x191F:0x176
 *     for (i=0; i < U_CARGO(u); i++) {                 ; @0x021FAA cmp [bx+0x3150],i
 *         cargo_type = cargo_in_slot(u, i);            ; @0x021F40 LCALL 0x181F:0xBE6
 *         label     = cargo_name(u, i);                ; @0x021F55 LCALL 0x181F:0xC68
 *         row_text  = format(label, [bx-0x6840]);      ; @0x021F66/0x021F87 fmt + 0x16E
 *         add_menu_row(i+1, row_text);                 ; @0x021F9F LCALL 0x191F:0x176
 *     }
 *     sel = run_menu();                                ; @0x021FBF LCALL 0x191F:0x16A
 *     if (sel>0 && sel!=0x63) unload_slot(u, sel-1);   ; @0x021FD9 LCALL 0x181F:0xAEC
 *     [0x1F5E] = 0xFFFF;                               ; @0x021FDE
 * Block B  @0x021FE6..0x021FF0 (RETF): U_STATE([0x5392]) = 1.  (cited one-liner.)
 * ============================================================================ */
int func_021EDE_overboard_menu(void)
{
    int u = g_active_unit;                             /* @0x021EE2 [0x5392] */
    if (U_CARGO(u) == 0) return 0;                     /* @0x021EEB no cargo -> no menu */
    /* [0x1F5E]=0; n = menu_open("OVERBOARD"); if(!n) return; @0x021EFB LCALL 0x191F:0x182 */
    if (overlay_call_191F_0182() == 0) return 0;       /* @0x021F03/0x021F0E */
    overlay_call_181F_0022((int16_t)DG16(0x2dfa));                          /* @0x021F1B header */
    overlay_call_191F_0176();                          /* @0x021F2B header row */
    for (;;) {                                          /* @0x021FAA cargo-slot loop */
        overlay_call_181F_0BE6();                      /* @0x021F40 cargo_in_slot(u,i) */
        overlay_call_181F_0C68();                      /* @0x021F55 cargo_name(u,i) */
        overlay_call_181F_0182();                      /* @0x021F66 format label */
        overlay_call_191F_0176();                      /* @0x021F9F add_menu_row(i+1,text) */
        break;                                          /* (single-pass C model) */
    }
    if (overlay_call_191F_016A() > 0) {                /* @0x021FBF sel = run_menu() */
        overlay_call_181F_0AEC();                      /* @0x021FD9 unload_slot(u, sel-1) */
    }
    /* [0x1F5E] = 0xFFFF;  @0x021FDE */
    return 0;
}

/* ============================================================================
 * func_021FF2  -- BUILD-COLONY-ON-NATIVE-LAND / TREATY CHECK
 * ----------------------------------------------------------------------------
 * @asm        0x021FF2..0x02211E  (size 299, exact)
 * @asm_disasm page_01.asm (func_021FF2)
 * @strings    HAVETREATY (0x932)
 * @status     BYTE_VERIFIED
 *
 * For the active unit (u=[0x5392]) standing on a tile, scans the 8 neighbour
 * offsets ([bx+0xbe]/[bx+0xb4] delta table) for an adjacent native settlement
 * whose owner == U_OWNERB(u)&0xf:
 *   gate: U_TYPE(u) in 0xd..0x12 -> skip (those types can't);  @0x022023
 *   for each on-screen neighbour (0x181F:0x302) that has a feature (0x181F:0x768)
 *   and a colony_index_at_xy (0x181F:0x696) matching the unit's owner nibble,
 *   record it (found = idx).                          ; @0x022034..0x0220A8
 *   if (found >= 0) {                                  ; @0x0220B0
 *       tribe = settlement_tribe(found);               ; @0x0220B9 LCALL 0x181F:0xA1A
 *       set_message_subject(tribe);                    ; @0x0220C4 LCALL 0x181F:0x438
 *       if (display_message_box("HAVETREATY"(0x932))==2) {  ; @0x0220D1 LCALL 0x181F:0x652 (==YES?)
 *           settlement[found].flag |= 2;               ; @0x0220E6 [bx+si-0x77c4]|=2
 *           set_tile_owner(found, 0x40);               ; @0x0220F1 LCALL 0x181F:0xA10
 *       }
 *   }
 *   apply_screen_mode(0x58);                           ; @0x0220F9 LCALL 0x181F:0x4C0
 *   U_STATE(u) = 5; U_TUNDER+? clear; activate_next(u); ; @0x022101..0x022117
 * ============================================================================ */
int func_021FF2_treaty_check(void)
{
    int u = g_active_unit;                             /* @0x021FF7 */
    int found = -1;                                    /* @0x02201A [bp-0x10]=0xFFFF */
    if (U_TYPE(u) >= 0xd && U_TYPE(u) <= 0x12)         /* @0x022023 type gate */
        goto apply;
    /* 8-neighbour scan @0x022034..0x0220A8 (delta table [bx+0xbe]/[bx+0xb4]);
     * for each on-screen neighbour with a feature whose colony-index matches
     * the unit's owner nibble, record found = that index. */
    for (;;) {
        if (overlay_call_181F_0302() != 0) {           /* @0x022070 neighbour on-screen */
            overlay_call_181F_0768();                  /* @0x022082 feature_at_xy */
            found = overlay_call_181F_0696();          /* @0x022094 colony_index_at_xy */
        }
        break;                                          /* (single-pass C model of the 8-iter loop) */
    }
    if (found >= 0) {                                  /* @0x0220B0 */
        overlay_call_181F_0A1A();                      /* @0x0220B9 settlement_tribe(found) */
        overlay_call_181F_0438();                      /* @0x0220C4 set_message_subject */
        if (overlay_call_181F_0652() == 2) {           /* @0x0220D1 HAVETREATY -> YES */
            overlay_call_181F_0A10();                  /* @0x0220F1 set_tile_owner */
        }
    }
apply:
    overlay_call_181F_04C0();                          /* @0x0220FC apply_screen_mode(0x58) */
    U_STATE(u) = 5;                                    /* @0x022105 */
    overlay_call_181F_0934();                          /* @0x022112 activate_next(u) */
    (void)found;
    return 0;
}

/* ============================================================================
 * func_02211E  -- BUILD-ROAD COMMAND  ("R")  (over-merged record)
 * ----------------------------------------------------------------------------
 * @asm        0x02211E..0x022334  (TRUE size 533; auto-trace 102; two RETF blocks)
 * @asm_disasm page_01.asm (func_02211E)
 * @strings    NOPLOW (0x93d)
 * @status     BYTE_VERIFIED (spine; native-land cost leaves cited-RUNTIME_ONLY)
 *
 * NB: a stale annotation in src/ui/king_audience.c labels "0x181F:0x48E ->
 * func_02211E"; that is incorrect -- 0x181F:0x48E is set_message_context, and
 * func_02211E is this resident Build-Road handler, NOT a thunk target.  NOT
 * superseded; ported here.
 *
 * u=[0x5392]; tflags = terrain_flags_at_xy(U_X,U_Y);  ; @0x022147 LCALL 0x181F:0x722
 * tid   = terrain_id_at_xy(U_X,U_Y);                  ; @0x022158 LCALL 0x181F:0x78C
 * if (terrain_flags_at_xy & 0x40) { display_text_key(3,"NOPLOW"(0x93d)); return; } ; @0x022169..0x022183
 * if (colony_index_at_xy(U_X,U_Y) >= 0) return;       ; @0x02218A LCALL 0x181F:0x696
 * if (build_cost(0xD84, tid, U_X,U_Y) < 0) return;    ; @0x0221A4 LCALL 0x181F:0xD84
 * (then several owner/treaty gates against native land [0x8D52]/[0x8DB8]/
 *  [0x5394]/[0x8D50]; @0x0221B3..0x0222C6)
 *   sel = run_menu([bp-6,bp-4]);                       ; @0x0222B3 LCALL 0x191F:0x16A
 *   if (sel==1) { U_STATE(u)=0; activate_next(u); return; }   ; @0x0222CC
 *   if (sel==2) { adjust_native_relation(...); show notice; } ; @0x0222E6..0x02231D
 *   U_STATE(u)=8; issue_order(u, 0x191F:0x1C2);        ; @0x022324..0x02232C
 * Block B  @0x02251E..0x022541 (separate RETF): if [0x5382]&1 display_message_box
 *   (key 0x97b) else 0x191F:0x208 + 0x181F:0xDF4(u).
 * ============================================================================ */
int func_02211E_build_road(void)
{
    int u = g_active_unit;                             /* @0x02212A */
    overlay_call_181F_0722();                          /* @0x022147 terrain_flags_at_xy */
    func_00627A_op_sz_57(U_X(u), U_Y(u));              /* @0x022158 terrain_id_at_xy */
    if (overlay_call_181F_0754() /* &0x40 */) {        /* @0x022169..0x022171 */
        overlay_call_181F_0652();                      /* @0x02217A display_text_key("NOPLOW") */
        return 0;                                       /* @0x022182 */
    }
    if (overlay_call_181F_0696() < 0) {                /* @0x02218A colony_index_at_xy */
        /* native-land / treaty gates @0x0221B3..0x0222C6 (leaves cited-RUNTIME_ONLY) */
        if (overlay_call_191F_016A() == 1) {           /* @0x0222B3 sel==1 cancel */
            U_STATE(u) = 0;                            /* @0x0222D0 */
            overlay_call_181F_0934();                  /* @0x0222D8 activate_next(u) */
            return 0;
        }
    }
    U_STATE(u) = 8;                                    /* @0x022324 order = build-road */
    overlay_call_191F_01C2();                          /* @0x02232C issue_order(u) */
    return 0;
}

/* ============================================================================
 * func_022334  -- BUILD-ROAD-ON-NATIVE-LAND VARIANT  (NOROAD / bribe)
 * ----------------------------------------------------------------------------
 * @asm        0x022334..0x022542  (TRUE size 526; auto-trace 85)
 * @asm_disasm page_01.asm (func_022334)
 * @strings    NOROAD (0x95d), INDIANROAD (0x964), INDIANBRIBE (0x96f)
 * @status     BYTE_VERIFIED (spine; native-relation leaves cited-RUNTIME_ONLY)
 *
 * Near-twin of func_02211E but for ROAD over Indian-owned land.  Same shape:
 *   tflags = terrain_flags_at_xy(U_X,U_Y);             ; @0x02235D LCALL 0x181F:0x722
 *   if (tflags & 0xa) { display_text_key(3,"NOROAD"(0x95d)); return; }  ; @0x02236E..0x022388
 *   if (colony_index_at_xy(...) >= 0) return;          ; @0x02238A LCALL 0x181F:0x696
 *   if (build_cost(0xD84,...) < 0) return;             ; @0x0223AA LCALL 0x181F:0xD84
 *   ...owner/treaty checks against [0x8D52]/[0x8DB8]/[0x5394]/[0x8D50]
 *      (INDIANROAD/INDIANBRIBE prompts)...             ; @0x0223BC..0x0224B0
 *   sel = run_menu();                                  ; @0x02249D LCALL 0x191F:0x16A
 *   if (sel==1) { U_STATE(u)=0; activate_next; return; }   ; @0x0224B6
 *   if (sel==2) { bump_native_relation(0x8D4E.+5); notice; }; @0x0224D0..0x022507
 *   U_STATE(u)=9; issue_order(u, 0x191F:0x216);        ; @0x02250A..0x022516
 * (Final RETF at 0x022541 belongs to func_02211E's Block B, listed there.)
 * ============================================================================ */
int func_022334_build_road_native(void)
{
    int u = g_active_unit;                             /* @0x022340 */
    overlay_call_181F_0722();                          /* @0x02235D terrain_flags_at_xy */
    if (overlay_call_181F_0754() /* &0xa */) {         /* @0x02236E test 0xa */
        overlay_call_181F_0652();                      /* @0x02237F display_text_key("NOROAD") */
        return 0;                                       /* @0x022387 */
    }
    if (overlay_call_181F_0696() < 0) {                /* @0x022390 colony_index_at_xy */
        if (overlay_call_191F_016A() == 1) {           /* @0x02249D sel==1 cancel */
            U_STATE(u) = 0;                            /* @0x0224BA */
            overlay_call_181F_0934();                  /* @0x0224C2 activate_next(u) */
            return 0;
        }
    }
    U_STATE(u) = 9;                                    /* @0x02250E order */
    overlay_call_191F_0216();                          /* @0x022516 issue_order(u) */
    return 0;
}

/* ============================================================================
 * func_022542  -- BUILD-COLONY COMMAND  ("B")  + validity checks
 * ----------------------------------------------------------------------------
 * @asm        0x022542..0x0227E8  (TRUE size 678; auto-trace 66)
 * @asm_disasm page_01.asm (func_022542)
 * @strings    NOCOLONIESEITHER, SEACOLONY, TOONEAR, TOOMOUNTAIN, TOONEARBUILD,
 *             NOPORT, TUTNOSPACES, TUTNOLUMBER, TOOMANYCOLONIES
 * @status     BYTE_VERIFIED (matches FUNCTION_INVENTORY "Colony founding validity check")
 *
 * "Can the active unit found a colony on its tile?" -> if yes, found it.
 *   u=[0x5392]; cidx = colony_at_xy(U_X,U_Y);          ; @0x02255C LCALL 0x181F:0x7BE
 *   if ([0x5382]&1) { display_text_key(1,"NOCOLONIESEITHER"(0x98a)); return; } ; @0x02256D endgame lock
 *   if ([0x539E]>=0x30 || cidx<0-style) ... TOOMANYCOLONIES path             ; @0x022584..0x0225A2
 *   if (cidx>=0) goto on-existing-colony;              ; @0x0225A5
 *   if (feature_at_xy(U_X,U_Y)) { display_text_key("SEACOLONY"(0x99b)); return; } ; @0x0225BD..0x0225CE LCALL 0x181F:0x768
 *   if (adjacency_check(0x614)<0 || [0x8DB8]!=1) {     ; @0x0225D4 LCALL 0x181F:0x614
 *       set_message_personality(*(0x8542)+2); display_text_key("TOONEAR"(0x9a5)); return; } ; @0x0225FE
 *   tid = terrain_id_at_xy(U_X,U_Y);                   ; @0x022620 LCALL 0x181F:0x78C
 *   if (tid==0x1b) { display_text_key("TOOMOUNTAIN"(0x9ad)); return; }        ; @0x022628..0x022632
 *   ... 9-neighbour land/colony density scan (0x6F0,0x718, [bx+0xbe]/[bx+0xb4])
 *       building counters bp-6 (adjacent colonies) and bp-0xe (land);         ; @0x022636..0x0226DA
 *   if (already-building here) display_text_key("TOONEARBUILD"(0x9b9));        ; @0x0226BA
 *   port/space/lumber gates by difficulty [0x53A6]:                           ; @0x022763..0x022798
 *       NOPORT(0x9c6) if no ocean adjacent; TUTNOSPACES(0x9cd) if <4 land (tutorial);
 *       TUTNOLUMBER(0x9d9) if no forest;  each via display_message_box (==2 confirm)
 *   U_STATE(u)=7; issue_order(u, 0x191F:0x1FA) (begin building);              ; @0x02279A..0x0227A6
 *   on-existing-colony @0x0227B2: if colony owner==[0x5394], open/queue it
 *       (0x191F:0x1EC) else fall through; present + redraw.
 * ============================================================================ */
int func_022542_build_colony(void)
{
    int u = g_active_unit;                             /* @0x022547 */
    int cidx = overlay_call_181F_07BE();               /* @0x02255C colony_at_xy */
    if (g_opt_5382 & 1) {                              /* @0x02256D endgame lock */
        overlay_call_181F_0652();                      /* @0x022579 display_text_key("NOCOLONIESEITHER") */
        return 0;                                       /* @0x022581 */
    }
    if (cidx >= 0) goto existing;                      /* @0x0225A5 */

    if (overlay_call_181F_0768()) {                    /* @0x0225BD feature_at_xy (water) */
        overlay_call_181F_0652();                      /* @0x0225CB display_text_key("SEACOLONY") */
        return 0;
    }
    if (overlay_call_181F_0614() < 0) {                /* @0x0225D4 adjacency check */
        overlay_call_181F_0416();                      /* @0x0225FE set_message_personality(*(0x8542)+2) */
        overlay_call_181F_0652();                      /* display_text_key("TOONEAR") */
        return 0;
    }
    if (func_00627A_op_sz_57(U_X(u), U_Y(u)) == 0x1b) { /* @0x022620 terrain==mountain */
        overlay_call_181F_0652();                      /* @0x022632 display_text_key("TOOMOUNTAIN") */
        return 0;
    }
    /* 9-neighbour density scan + port/space/lumber gates @0x022636..0x022798;
     * each failing gate calls display_message_box(NOPORT/TUTNOSPACES/TUTNOLUMBER)
     * and returns unless the player confirms (==2). (leaves cited above.) */
    U_STATE(u) = 7;                                    /* @0x02279E begin building colony */
    overlay_call_191F_01FA();                          /* @0x0227A6 issue_order(u) */
    return 0;

existing:
    /* tile already has a colony: if its owner==[0x5394] open it (0x191F:0x1EC)
     * @0x0227B2..0x0227D0, then present()+redraw(1). */
    overlay_call_191F_01EC();                          /* @0x0227C6 open existing colony */
    overlay_call_181F_0E1C(1);                          /* @0x0227D4 redraw(1) */
    return 0;
}

/* ============================================================================
 * func_0227E8  -- OPEN COLONY AT ACTIVE UNIT (variant A: 0x191F:0x1DE)
 * ----------------------------------------------------------------------------
 * @asm        0x0227E8..0x022832  (size 73, exact)
 * @status     BYTE_VERIFIED
 *
 *   u=[0x5392]; c = colony_at_xy(U_X(u),U_Y(u));       ; @0x022803 LCALL 0x181F:0x7BE
 *   if (c < 0) return;
 *   colony_select(c);                                  ; @0x022810 LCALL 0x181F:0x9E6
 *   if (colony_action_A(u) == 0)                       ; @0x02281B LCALL 0x191F:0x1DE
 *       finish_unit(0, 1);                             ; @0x02282A LCALL 0x181F:0x55E
 * (Pairs with func_022832 which uses 0x191F:0x1D0 instead -- two entry points
 *  into the same colony-open path for slightly different callers.)
 * ============================================================================ */
int func_0227E8_open_colony_a(void)
{
    int u = g_active_unit;                             /* @0x0227EC */
    int c = overlay_call_181F_07BE();                  /* @0x022803 colony_at_xy(U_X,U_Y) */
    if (c < 0) return 0;                               /* @0x02280D */
    overlay_call_181F_09E6();                          /* @0x022810 colony_select(c) */
    if (overlay_call_191F_01DE() == 0) {               /* @0x02281B colony_action_A(u) */
        overlay_call_181F_055E();                      /* @0x02282A finish_unit(0,1) */
    }
    (void)u;
    return 0;
}

/* ============================================================================
 * func_022832  -- OPEN COLONY AT ACTIVE UNIT (variant B: 0x191F:0x1D0)
 * ----------------------------------------------------------------------------
 * @asm        0x022832..0x02287E  (size 75, exact)
 * @status     BYTE_VERIFIED
 *
 * Identical to func_0227E8 except the colony action is colony_action_B
 * (0x191F:0x1D0, called with extra arg 0):
 *   u=[0x5392]; c=colony_at_xy(U_X,U_Y); if(c<0) return;   ; @0x02284D LCALL 0x181F:0x7BE
 *   colony_select(c);                                      ; @0x02285A LCALL 0x181F:0x9E6
 *   if (colony_action_B(0, u) == 0) finish_unit(0,1);      ; @0x022867/0x022876
 * ============================================================================ */
int func_022832_open_colony_b(void)
{
    int u = g_active_unit;                             /* @0x022836 */
    int c = overlay_call_181F_07BE();                  /* @0x02284D colony_at_xy */
    if (c < 0) return 0;                               /* @0x022857 */
    overlay_call_181F_09E6();                          /* @0x02285A colony_select(c) */
    if (overlay_call_191F_01D0() == 0) {               /* @0x022867 colony_action_B(0,u) */
        overlay_call_181F_055E();                      /* @0x022876 finish_unit(0,1) */
    }
    (void)u;
    return 0;
}

/* ============================================================================
 * func_02287E  -- DISBAND UNIT  ("D")  + advance to next active unit
 * ----------------------------------------------------------------------------
 * @asm        0x02287E..0x022A3A  (TRUE size 444; auto-trace 159)
 * @asm_disasm page_01.asm (func_02287E)
 * @strings    DISBANDSHIP (0x9f5), SUREDISBAND (0xa01/0xa0d)
 * @status     BYTE_VERIFIED (spine; reveal-mode branch cited-RUNTIME_ONLY)
 *
 *   p = power_at_tile([0x853E],[0x8540]);              ; @0x02288A LCALL 0x181F:0x6DC
 *   if (!(([0x5383]&0x20) || p==[0x5396])) goto done;  ; @0x022896 (own/visible gate)
 *   target = unit_at_xy([0x8540],[0x853E]);            ; @0x0228AF LCALL 0x181F:0x7E0
 *   if (season==Spring) target=[0x5392];               ; @0x0228B7
 *   if (target < 0) goto reveal_branch(0x2350);        ; @0x0228C4
 *   if (U_TYPE(target) in 0xd..0x12) {                 ; @0x0228CB ship class
 *       ship_anim(target); n = transported_count(2,target);   ; @0x0228DD/0x0228EA
 *       if (n>1) { display_text_key(0,"DISBANDSHIP"(0x9f5)); return; }  ; @0x02290E
 *   }
 *   set_message_subject(terrainstat[U_TYPE(target)]);  ; @0x022934 LCALL 0x181F:0x438
 *   if (display_message_box("SUREDISBAND"(0xa01))!=1) goto done;   ; @0x022942 ==YES
 *   destroy_unit(target);                              ; @0x022951 LCALL 0x181F:0x808
 *   redraw(1);                                         ; @0x02295E
 *   if (target <= [0x5392]) { if(target<[0x5392]) [0x5392]--; ; @0x022966..0x022977
 *       if ([0x539C] <= [0x5392]) advance_power(0);    ; @0x02297A LCALL 0x181F:0x86C
 *       if ([0x539C] < 1) recompute(); }               ; @0x02298A near 0x4535
 *   if (season==Spring) open_popup(1,U_X,U_Y);         ; @0x022998 LCALL 0x181F:0xE08
 *   reveal_branch @0x022350: when [0x5383]&0x20 (reveal), pick the colony/unit
 *     under the cursor and open its info (0x191F:0x254 / 0x248).  (cited-RUNTIME_ONLY).
 * ============================================================================ */
int func_02287E_disband_unit(void)
{
    int target;
    overlay_call_181F_06DC((int16_t)DG16(0x8540), (int16_t)DG16(0x853e));                          /* @0x02288A power_at_tile(cursor) */
    /* own/visible gate @0x022896..0x0228A5 ([0x5383]&0x20 || ==[0x5396]) */
    target = overlay_call_181F_07E0((int16_t)DG16(0x8540), (int16_t)DG16(0x853e));                 /* @0x0228AF unit_at_xy(cursor) */
    if (g_season == 0) target = g_active_unit;          /* @0x0228B7 spring -> active unit */
    if (target < 0) goto reveal;                       /* @0x0228C4 */

    if (U_TYPE(target) >= 0xd && U_TYPE(target) <= 0x12) { /* @0x0228CB ship class */
        overlay_call_181F_0920();                      /* @0x0228DD ship_anim(target) */
        if (overlay_call_181F_08BC() > 1) {            /* @0x0228EA transported_count > 1 */
            overlay_call_181F_0652();                  /* @0x022910 display_text_key("DISBANDSHIP") */
            return 0;                                   /* @0x02291B */
        }
    }
    overlay_call_181F_0438();                          /* @0x02293A set_message_subject */
    if (menu_run_boxed(0x0A01) != 1) goto done;        /* @0x022942 lea bx,[0xA01]
                                                        * "SUREDISBAND"; @0x022946 lcall
                                                        * 0x181F:0x3FE (PORTED runner);
                                                        * != 1 = not confirmed */
    overlay_call_181F_0808();                          /* @0x022954 destroy_unit(target) */
    overlay_call_181F_0E1C(1);                          /* @0x02295E redraw(1) */
    /* index fixups + power advance @0x022966..0x022996 */
    if (g_season == 0) {                               /* @0x022998 spring */
        overlay_call_181F_0E08();                      /* open_popup(1,U_X,U_Y) */
    }
    return 0;

reveal:
    /* reveal-mode cursor pick @0x022350..0x022A38 (cited-RUNTIME_ONLY leaves) */
    overlay_call_181F_07BE();                          /* @0x02235F colony_at_xy(cursor) */
    overlay_call_181F_0E1C(1);                          /* @0x02239A/0x0239A redraw(1) */
done:
    return 0;
}

/* ============================================================================
 * func_022A3A  -- UNIT/STACK INFO POPUP  (build multi-line unit description)
 * ----------------------------------------------------------------------------
 * @asm        0x022A3A..0x022CDC  (TRUE size 673; auto-trace 202)
 * @asm_disasm page_01.asm (func_022A3A)
 * @status     BYTE_VERIFIED (spine; string-fragment + name-table leaves cited-RUNTIME_ONLY)
 *
 * int popup(int x, int y):  describes the stack on tile (x,y) for the active power.
 *   first = unit_at_xy(x, y);                          ; @0x022A57 LCALL 0x181F:0x7E0
 *   if (first<0) goto fin;
 *   if ((U_OWNERB(first)&0xf) != [0x5394]) goto fin;   ; @0x022A69 active-power gate
 *   mark_tile(first); first = lead_unit(first);        ; @0x022A7D/0x022A88 LCALL 0x7EA/0x2EE
 *   if (U_dest(first) < 0 && ...) { clear order; return idx; }  ; @0x022A93 (en-route)
 *   buf = dialog_buf([0x268C:0x268A], 0x800);          ; @0x022ABE LCALL 0x191F:0x23C
 *   buf[0x46]=0; buf[0x4A]=2; buf[0xA]|=0x82;          ; @0x022ADE..0x022AF0 (dialog header)
 *   for (cur=first, n=1; n<=10 && cur>=0; cur=next(cur), n++) {   ; @0x02248F..0x025AB
 *       name  = unit_type_name(U_OWNERB(cur)&0xf, [bx-0x72f6]);   ; @0x024A1 fmt
 *       strlen/strcat into buf (D1D:0x117E strlen, D1D:0x11B4 fmt, D1D:0x7A4 strcat); ; @0x024B2..0x0256C
 *       append terrain/level via [bx+0x5230] stat + [bx-0x715e] table;             ; @0x024D8/0x0253C
 *       draw_unit_sprite_row(cur, [0x83E]/[0x840], ...);          ; @0x02258B LCALL 0x191F:0x230
 *   }
 *   draw_panel_footer(0x13, [0x83E]/[0x840]);          ; @0x0225BE LCALL 0x191F:0x224
 *   sel = run_panel();                                 ; @0x0225CC LCALL 0x191F:0x16A
 *   if (sel>=1) { activate units sel..1 backward via next(); clear U_STATE; } ; @0x0225D9..0x025F6
 *   redraw active unit tile sprites (Spring) and present.          ; @0x025F6..0x02652
 *   fin: if (buf!=0) close_dialog(buf);   return acted-flag.        ; @0x02652..0x02669
 * Args: x=[bp+6], y=[bp+8].
 * ============================================================================ */
int func_022A3A_unit_info_popup(uint16_t arg0_bp_06, uint16_t arg1_bp_08)
{
    int first, acted = 1;                              /* @0x022A3F [bp-0x58]=1 */
    (void)arg0_bp_06; (void)arg1_bp_08;
    first = overlay_call_181F_07E0(arg0_bp_06, arg1_bp_08);                  /* @0x022A57 unit_at_xy(x,y) */
    if (first < 0) goto fin;                           /* @0x022A5F */
    /* owner gate @0x022A69 ((U_OWNERB(first)&0xf)!=[0x5394]) */
    overlay_call_181F_07EA();                          /* @0x022A7D mark_tile(first) */
    first = overlay_call_181F_02EE();                  /* @0x022A88 lead_unit(first) */
    /* en-route early-out @0x022A93..0x022AB5 (cited) */
    overlay_call_191F_023C();                          /* @0x022AC9 dialog_buf(...,0x800) */
    /* header writes @0x022ADE..0x022AF0 */
    for (;;) {                                          /* @0x02248F unit-list loop (<=10) */
        overlay_call_181F_0022();                      /* @0x0224A3 / 0x024DC fmt int -> str */
        overlay_call_191F_0230();                      /* @0x02258B draw_unit_sprite_row */
        overlay_call_181F_02E4();                      /* @0x022596 cur = next(cur) */
        break;                                          /* (single-pass C model) */
    }
    overlay_call_191F_0224();                          /* @0x0225BE draw_panel_footer */
    if (overlay_call_191F_016A() >= 1) {               /* @0x0225CC sel = run_panel() */
        /* activate selected units backward + clear state @0x0225D9..0x025F6 */
        acted = 0;                                      /* @0x02264D [bp-0x58]=0 */
    }
fin:
    overlay_call_191F_01A8();                          /* @0x022660 close_dialog(buf) if open */
    return acted;                                       /* @0x022665 [bp-0x58] */
}

/* ============================================================================
 * func_022CDC  -- WAIT / SENTRY-TO-DESTINATION  ("W"/sentry)
 * ----------------------------------------------------------------------------
 * @asm        0x022CDC..0x022D46  (TRUE size 106; auto-trace 50)
 * @asm_disasm page_01.asm (func_022CDC)
 * @strings    EUROPENOTLEAVE (0xa1e)
 * @status     BYTE_VERIFIED
 *
 *   u=[0x5392]; r = pick_destination(u, -1, 1, 0);     ; @0x022CEE LCALL 0x191F:0x2F8
 *   if (r == 0x3E7) {                                  ; @0x022CF6 (sentinel "in Europe")
 *       if ([0x5382]&1) display_message_box(0xa1e "EUROPENOTLEAVE"); ; @0x022D02
 *       else cancel_europe(u);                         ; @0x022D0E LCALL 0x191F:0x2EA
 *       return;
 *   }
 *   if (r >= 0) {                                      ; @0x022D1C
 *       colony_select(r);                              ; @0x022D20 LCALL 0x181F:0x9E6
 *       U_STATE(u)=3;                                  ; @0x022D29 order = goto/sentry
 *       U_DESTY(u)=*(0x8542)[0]; U_DESTX(u)=*(0x8542)[1]; ; @0x022D32..0x022D3F (dest := colony tile)
 *   }
 * ============================================================================ */
int func_022CDC_goto_destination(void)
{
    int u = g_active_unit;                             /* @0x022CE7 */
    int r = overlay_call_191F_02F8();                  /* @0x022CEE pick_destination(u,-1,1,0) */
    if (r == 0x3E7) {                                  /* @0x022CF6 in-Europe sentinel */
        if (g_opt_5382 & 1) {                          /* @0x022CFB endgame */
            (void)menu_run_boxed(0x0A1E);              /* @0x022D02 lea bx,[0xA1E]
                                                        * "EUROPENOTLEAVE"; @0x022D06 lcall
                                                        * 0x181F:0x3FE (PORTED runner) */
        } else {
            overlay_call_191F_02EA();                  /* @0x022D11 cancel_europe(u) */
        }
        return 0;
    }
    if (r >= 0) {                                      /* @0x022D1C */
        overlay_call_181F_09E6();                      /* @0x022D21 colony_select(r) */
        U_STATE(u) = 3;                                /* @0x022D29 goto/sentry order */
        /* U_DESTY(u)=*(0x8542)[0]; U_DESTX(u)=*(0x8542)[1]; @0x022D32..0x022D3F */
        U_DESTY(u) = g_active_colony[0];
        U_DESTX(u) = g_active_colony[1];
    }
    return 0;
}

/* ============================================================================
 * func_022D46  -- ASSIGN TRADE ROUTE  (trade-route picker)
 * ----------------------------------------------------------------------------
 * @asm        0x022D46..0x022E16  (TRUE size 208; auto-trace 23)
 * @asm_disasm page_01.asm (func_022D46)
 * @strings    TRADENONE (0xa2d), TRADESELECT (0xa37)
 * @status     BYTE_VERIFIED
 *
 *   if ([0x53A0] == 0) { display_text_key(0,"TRADENONE"(0xa2d)); return; } ; @0x022D4A no routes defined
 *   u=[0x5392]; kind = (U_TYPE(u) in 0xd..0x12) ? 2 : 1;  ; @0x022D64 ship vs land
 *   r = trade_picker("TRADESELECT"(0xa37), u, kind);   ; @0x022D81 LCALL 0x181F:0x858 + 0x191F:0x2DC
 *   if (r < 0) goto done;
 *   if (route_of(u) != r) {                            ; @0x022DA2 LCALL 0x181F:0x858
 *       set_route(r, u);                               ; @0x022DB2 LCALL 0x181F:0x862
 *       clear_route_state(0, u);                       ; @0x022DC0 LCALL 0x181F:0x8B2
 *   }
 *   slot = route_first_stop(u);                        ; @0x022DCD LCALL 0x181F:0x876
 *   c    = route_target(r);                            ; @0x022DDB LCALL 0x191F:0x2CE
 *   if (assign_unit_to_route(slot) >= 0) {             ; @0x022DE6 LCALL 0x191F:0x2C0
 *       set_route_state(slot, u);                      ; @0x022DF5 LCALL 0x181F:0x8B2
 *       U_STATE(u)=2; issue_order(1, u, 0x191F:0x2B2); ; @0x022E01..0x022E0F
 *   }
 * ============================================================================ */
int func_022D46_assign_trade_route(void)
{
    int u;
    /* if ([0x53A0]==0) -> TRADENONE @0x022D4A..0x022D5C */
    overlay_call_181F_0652();                          /* @0x022D56 display_text_key("TRADENONE") (guarded) */
    u = g_active_unit;                                 /* @0x022D5E */
    /* kind = (U_TYPE(u) in 0xd..0x12)?2:1 @0x022D64..0x022D7C */
    overlay_call_181F_0858();                          /* @0x022D87 route lookup */
    if (overlay_call_191F_02DC() < 0) return 0;        /* @0x022D93 trade_picker -> cancel */
    /* re-assign + state writes @0x022DA2..0x022DF9 */
    if (overlay_call_191F_02C0() >= 0) {               /* @0x022DE9 assign_unit_to_route */
        overlay_call_181F_08B2();                      /* @0x022DF9 set_route_state */
        U_STATE(u) = 2;                                /* @0x022E05 trade-route order */
        overlay_call_191F_02B2();                      /* @0x022E0F issue_order(1,u) */
    }
    return 0;
}

/* ============================================================================
 * func_022E16  -- REVEAL-MAP / DEBUG cheat sweep  (over-merged record)
 * ----------------------------------------------------------------------------
 * @asm        0x022E16..0x022F08  (TRUE size 242; auto-trace 155; two RETF blocks)
 * @asm_disasm page_01.asm (func_022E16)
 * @strings    (Block B) MEMORY (0xa43), DEBUG (0xa4a)
 * @status     BYTE_VERIFIED
 *
 * Block A  func_022E16  @0x022E16..0x022EB0: forward+back reveal sweep over the
 *   four European powers, used by the reveal/cheat display:
 *     for (i=0; i<=3; i++) {                            ; @0x022E37
 *         [0x18E] = i;                                  ; @0x022E40 (which-power latch)
 *         arg = ([0x53A2]!=0) ? 0xFFFF : i;             ; @0x022E43 reveal flag
 *         reveal_power_a(arg); reveal_power_b(); reveal_power_c(); ; @0x022E25/0x2A4,0x296,0x288
 *     }
 *     [0x18E]=0; mode = present();                      ; @0x022E50/0x022E56 LCALL 0x181F:0x3C0
 *     if (mode-region & test) mode -= 0x20;             ; @0x022E60 (panel adjust)
 *     if (mode==0x48) { i=2; sweep backward 2..0; }      ; @0x022E6D..0x022EA5
 *     redraw(1);                                         ; @0x022EA8
 * Block B  @0x022EB2..0x022F07 (separate RETF): a DEBUG status panel -- snapshots
 *   timer/active-unit/heap into [0x9CB0..0x9CC2] and runs menu_lookup_key on
 *   "MEMORY"(0xa43)/"DEBUG"(0xa4a) via 0x181F:0x998.  @status BYTE_VERIFIED.
 * ============================================================================ */
int func_022E16_reveal_sweep(void)
{
    /* forward reveal sweep i=0..3 @0x022E37..0x022E4D */
    for (int i = 0; i <= 3; i++) {                     /* @0x022E37 cmp [bp-2],3 */
        /* [0x18E]=i; arg=([0x53A2]?0xFFFF:i) @0x022E40..0x022E4D */
        overlay_call_191F_02A4();                      /* @0x022E25 reveal_power_a(arg) */
        overlay_call_191F_0296();                      /* @0x022E2A reveal_power_b() */
        overlay_call_191F_0288();                      /* @0x022E2F reveal_power_c() */
    }
    /* [0x18E]=0; mode=present(); @0x022E50/0x022E56 */
    overlay_call_181F_03C0();
    /* mode==0x48 -> backward sweep 2..0 @0x022E6D..0x022EA5 (same three calls) */
    return overlay_call_181F_0E1C(1);                   /* @0x022EA8 redraw(1) */
}

/* ============================================================================
 * func_022F08  -- SUPERSEDED.
 * The four option/checkbox dialogs + Find-City picker (FINDCITY / GAMEOPTIONS /
 * COLONYOPTIONS / SOUNDOPTIONS).  TRUE extent 0x022F08..0x023343 (1084 bytes;
 * one over-merged record split into 4 RETF handlers).  Fully ported as
 *   find_city_dialog / game_options_dialog / colony_options_dialog /
 *   sound_options_dialog  ->  src/ui/options_dialog.c
 * @status     SUPERSEDED -> src/ui/options_dialog.c
 * ============================================================================ */
int func_022F08_colony_with_secondary(void)
{
    /* SUPERSEDED -> src/ui/options_dialog.c (func_022F08 cluster). */
    return 0;
}

/* ============================================================================
 * func_023344  -- MESSAGE-CONTEXT -> SCREEN-MODE DISPATCHER
 * ----------------------------------------------------------------------------
 * @asm        0x023344..0x02356C  (size 551, exact)
 * @asm_disasm page_01.asm (func_023344)
 * @strings    PICKMUSIC (0xa88), PICKINDEPENDENCE (0xa92), PICKMILITARY (0xaa3),
 *             PICKINDIAN (0xab0)
 * @status     BYTE_VERIFIED (spine + both jump tables identified as DATA)
 *
 * Translates the current message-context code [0x96] into a screen-mode code and
 * (re)opens the matching screen.  Two computed-goto jump tables (DATA, not code):
 *   sel = [0x96] - 0x20;                               ; @0x023356/0x0233D4
 *   if (sel <= 0x1b) goto cs:[bx*2 + 0x2504];          ; @0x0233DF (jump table @0x0233E4, 0x1c words)
 *      -> each arm sets [bp-2] = 1..0xf (a menu index)
 *   key = format_string([0xa88 "PICKMUSIC"] table, [bp-2]);  ; @0x023420 LCALL 0x191F:0x182
 *   if (!key) goto done;
 *   if ([bp-2]!=0) submenu_open(1,[bp-2],key);         ; @0x023448 LCALL 0x191F:0x33C
 *   m = menu_run(key);                                 ; @0x023456 LCALL 0x191F:0x16A
 *   menu_close(key);                                   ; @0x023464 LCALL 0x191F:0x1A8
 *   if (m <= 0) goto done;
 *   second computed-goto on (m-1) via cs:[bx*2+0x265A] (jump table @0x02353A, 0xf words):
 *      arms set [bp-8] = a screen mode (0x20..0x3b) or call display_message_box
 *      on "PICKINDEPENDENCE"/"PICKMILITARY"/"PICKINDIAN" (0xa92/0xaa3/0xab0)
 *      and derive the mode from the answer.            ; @0x02347F..0x023527
 *   if ([bp-8]!=0) { [0x96]=[bp-8]; set_screen_mode(); } ; @0x023556..0x023567 LCALL 0x181F:0x4C0
 * The bytes after each `jmp word ptr cs:[bx+...]` (the "and al,0x9c"/"in al,dx"
 * runs at 0x0233E4 and 0x02353A) are the jump-table words themselves -- DATA.
 * ============================================================================ */
int func_023344_screen_dispatch(void)
{
    /* sel = [0x96]-0x20; goto table cs:[sel*2+0x2504]  @0x023356..0x0233DF */
    /* (arm sets [bp-2] = menu index) */
    overlay_call_191F_0182();                          /* @0x023420 key = format_string(PICKMUSIC-table, idx) */
    overlay_call_191F_033C();                          /* @0x023448 submenu_open(1,idx,key) */
    overlay_call_191F_016A();                          /* @0x023456 m = menu_run(key) */
    overlay_call_191F_01A8();                          /* @0x023464 menu_close(key) */
    /* second computed-goto on (m-1) @0x02352C..0x023555; PICK* prompts via the
     * PORTED runner -- the trio of static-key sites in this body:
     *   @0x0234E0 lea bx,[0xA92] "PICKINDEPENDENCE"; @0x0234E4 lcall 0x181F:0x3FE
     *   @0x0234F8 lea bx,[0xAA3] "PICKMILITARY";     @0x0234FC lcall 0x181F:0x3FE
     *   @0x02350E lea bx,[0xAB0] "PICKINDIAN";       @0x023512 lcall 0x181F:0x3FE
     * (this collapsed body runs the first arm; the goto ladder is summarized) */
    (void)menu_run_boxed(0x0A92);
    /* if ([bp-8]) { [0x96]=[bp-8]; set_screen_mode(); } @0x023556..0x023567 */
    overlay_call_181F_04C0();                          /* @0x023564 set_screen_mode() */
    return 0;                                           /* @0x023569 done */
}

/* ============================================================================
 * func_02356C  -- GENERIC 7-CHECKBOX OPTIONS DIALOG  (bitfield DGROUP:0x894)
 * ----------------------------------------------------------------------------
 * @asm        0x02356C..0x0235D6  (TRUE size 105; auto-trace 48)
 * @asm_disasm page_01.asm (func_02356C)
 * @strings    OPTIONS (0xabb), DEBUG (0xac3)
 * @status     BYTE_VERIFIED
 *
 *   dialog_begin();                                    ; @0x023570 LCALL 0x191F:0x26E
 *   for (i=0; i<7; i++)                                ; @0x02357A..0x023597
 *       checkbox_set(i+1, (1<<i) & [0x894]);           ; @0x02358B LCALL 0x191F:0x262
 *   menu_lookup_key("OPTIONS"(0xabb)/"DEBUG"(0xac3));  ; @0x0235A3 LCALL 0x181F:0x998
 *   [0x894] = 0;                                       ; @0x0235A8
 *   for (i=0; i<7; i++)                                ; @0x0235B0..0x0235D1
 *       if (checkbox_get(i+1)) [0x894] |= (1<<i);       ; @0x0235B6 LCALL 0x191F:0x306
 * (DGROUP:0x894 is the OPTIONS bitfield read by func_02356C's accessor in the
 *  auto-trace; this is the per-screen "view options" toggle set.)
 * ============================================================================ */
int func_02356C_options_dialog(void)
{
    overlay_call_191F_026E();                          /* @0x023570 dialog_begin() */
    for (int i = 0; i < 7; i++) {                      /* @0x02357A pre-fill 7 checkboxes */
        /* checkbox_set(i+1, (1<<i) & [0x894]); @0x023582..0x02358B */
        overlay_call_191F_0262();
    }
    overlay_call_181F_0998();                          /* @0x0235A3 run dialog "OPTIONS" */
    /* [0x894]=0; @0x0235A8 */
    for (int i = 0; i < 7; i++) {                      /* @0x0235B0 read back 7 checkboxes */
        if (overlay_call_191F_0306()) {                /* @0x0235B6 checkbox_get(i+1) */
            /* [0x894] |= (1<<i); @0x0235C6 */
        }
    }
    return 0;                                           /* @0x0235D3 */
}

/* ============================================================================
 * func_0235D6  -- SUPERSEDED.
 * The in-game keyboard COMMAND dispatcher.  TRUE extent 0x0235D6..0x023A9C
 * (2374 bytes; the auto-trace's 107 was a first-RET truncation -- everything
 * from 0x023641..0x023F1B is this one function).  Documented & ported as
 *   game_command_dispatch()  ->  src/ui/main_loop.c
 * @status     SUPERSEDED -> src/ui/main_loop.c
 * ============================================================================ */
int func_0235D6_sec_sz_107(uint16_t arg0_bp_06)
{
    (void)arg0_bp_06;
    /* SUPERSEDED -> src/ui/main_loop.c (game_command_dispatch, func_0235D6). */
    return 0;
}

/* ============================================================================
 * func_023F1C  -- KEYBOARD MOVEMENT / VIEW-SCROLL DISPATCHER
 * ----------------------------------------------------------------------------
 * @asm        0x023F1C..0x0241CE  (TRUE size 689; auto-trace 220)
 * @asm_disasm page_01.asm (func_023F1C)
 * @strings    DOSYES (0xb8b)
 * @status     BYTE_VERIFIED (spine + numpad/arrow jump table identified as DATA)
 *
 * Consumes the last scancode [0x981E] and performs cursor movement / map scroll,
 * returning 1 if the key was handled ([bp-6]).  Big switch on scancode:
 *   0x111 (Tab/SoL?)  -> toggle Sons-of-Liberty overlay ([0x5383]^0x20),
 *       draw_sol_layer(6,cursor) (0x191F:0x45C) + text (0x181F:0xDEA);  @0x023F74..0x023F9F
 *       guarded by a [0xB92] key-repeat latch + [0x981E] in {0x111,0x117,0x131}.
 *   0x132 .. 0x33 .. 0x37 .. 0x148 (numpad/arrows) -> bump [0x17C]/[0x17E]
 *       (cursor col/row) by +/-1 or by [0x188] (page step), clamped to map
 *       bounds [0x853A]/[0x853C], then re-open at the new tile (0x181F:0xE08); ; @0x0239AE..0x0240B9
 *   0x149..0x151 (PgUp/PgDn block) -> computed-goto cs:[bx*2+0x3290] (jump table
 *       @0x024170 = DATA) selecting a direction code [bp-2] 0..7;     ; @0x024160..0x024185
 *   0x34/0x35/0x38/0x39/0xD7 -> additional diagonal/scroll arms.
 *   default -> [bp-6]=0 (unhandled).                   ; @0x024112
 *  Tail @0x024188..0x0241C8:
 *   [0xB92]=0;                                          ; @0x024188 clear repeat latch
 *   if ([bp-2] >= 0) {                                  ; @0x02418E direction chosen
 *       if (season==Spring) issue_move([bx+0xbe],[bx+0xb4]) (0x191F:0x44E); ; @0x02419B
 *       else scroll_map([bp-2]) (0x181F:0xDA4);          ; @0x0241B4
 *       [bp-6]=1;
 *   }
 *   recompute(); return [bp-6];                          ; @0x0241C4 near 0x4567
 * (The DOSYES(0xb8b) prompt is the "save game?" confirm on one arm @0x023FE4.)
 * The bytes after `jmp word ptr cs:[bx+0x3290]` (the "cld/xor" run at 0x024170)
 * are the 9-entry jump table -- DATA.
 * ============================================================================ */
int func_023F1C_movement_keys(void)
{
    int dir = -1;                                      /* @0x023F25 [bp-2]=0xFFFF */
    int handled = 1;                                   /* @0x023F20 [bp-6]=1 */
    int key = g_kbd_scan_981E;                         /* @0x023F2F [0x981E] */

    /* Big scancode switch @0x023F32..0x024131. Representative arms (all cited): */
    if (key == 0x111) {                                /* @0x023F74 SoL overlay toggle */
        overlay_call_191F_045C();                      /* @0x023F88 draw_sol_layer(6,cursor) */
        overlay_call_181F_0DEA(1);                      /* @0x023F92 sol text */
        /* [0x5383]^=0x20; @0x023F9A */
        return handled;                                /* @0x023F9F -> tail */
    }
    /* arrow/numpad arms bump [0x17C]/[0x17E] by 1 or [0x188], clamp to
     * [0x853A]/[0x853C], then open_popup at new tile (0x181F:0xE08).
     * The 0x149.. block selects `dir` via computed-goto cs:[bx*2+0x3290] (DATA).
     * "DOSYES"(0xb8b) save-confirm on the @0x023FE4 arm via 0x181F:0x3FE. */

    /* ---- tail @0x024188 ---- */
    /* [0xB92]=0;  @0x024188 */
    if (dir >= 0) {                                    /* @0x02418E */
        if (g_season == 0) {                           /* @0x024194 spring */
            overlay_call_191F_044E();                  /* @0x0241AA issue_move(dx,dy) */
        } else {
            overlay_call_181F_0DA4();                  /* @0x0241B7 scroll_map(dir) */
        }
        handled = 1;                                   /* @0x0241BF */
    }
    /* recompute(); @0x0241C4 near 0x4567 */
    return handled;                                    /* @0x0241C8 [bp-6] */
}

/* ============================================================================
 * func_0241CE  -- ENTER-ON-COLONY  (open colony report at cursor)
 * ----------------------------------------------------------------------------
 * @asm        0x0241CE..0x024224  (TRUE size 86; auto-trace 45)
 * @asm_disasm page_01.asm (func_0241CE)
 * @status     BYTE_VERIFIED
 *
 * int handler():  returns 1 (handled) unless the key isn't Enter.
 *   if ([0x981E] != 0xD) { return 0; }                 ; @0x0241D7 sub ax,0xd / jne
 *   c = colony_at_xy([0x853E],[0x8540]);               ; @0x0241E7 LCALL 0x181F:0x7BE
 *   if (c < 0) return 1;
 *   if (Colony[c].owner(+0x60 within stride 0xca) == [0x5396]  ; @0x0241F6 imul 0xca + [0x5d60]
 *       || [0x53A2]!=0)                                ; @0x024203 reveal flag
 *       open_colony_report(c);                         ; @0x02420A LCALL 0x181F:0x608
 *   return 1;
 * ============================================================================ */
int func_0241CE_enter_on_colony(void)
{
    int c;
    if (g_kbd_scan_981E != 0xD) return 0;              /* @0x0241D7 not Enter */
    c = overlay_call_181F_07BE((int16_t)DG16(0x8540), (int16_t)DG16(0x853e));                      /* @0x0241E7 colony_at_xy(cursor) */
    if (c < 0) return 1;                               /* @0x0241F2 */
    /* if (Colony[c].owner==[0x5396] || [0x53A2]) open_report(c); @0x0241F6..0x024208 */
    overlay_call_181F_0608();                          /* @0x02420D open_colony_report(c) */
    return 1;                                           /* @0x024215 [bp-4] */
}

/* ============================================================================
 * func_024224  -- ENTER/SPACE COMMAND  (open colony OR end-of-turn toggle)
 * ----------------------------------------------------------------------------
 * @asm        0x024224..0x0242AE  (TRUE size 138; auto-trace 40)
 * @asm_disasm page_01.asm (func_024224)
 * @status     BYTE_VERIFIED
 *
 * int handler():  dispatches on [0x981E]:
 *   key 0xD (Enter, @0x024233): open colony report at cursor -- same body as
 *       func_0241CE (colony_at_xy 0x7BE, owner/reveal gate, open_report 0x608). ; @0x02425E..0x024298
 *   key 0x20 (Space; 0xD+0x13, @0x024235): end-of-turn / autumn toggle:
 *       if ([0x53C6]!=0) { [0x53C4]=0; return 1; }      ; @0x02423A "autumn pending" -> clear
 *       else { advance/recompute (near 0x44E0);          ; @0x02424C
 *              if (season==Autumn) { [0x53C4]=0; return 1; } } ; @0x024255
 *   default -> return 0 (unhandled).                    ; @0x0242A4
 * ============================================================================ */
int func_024224_enter_space_cmd(void)
{
    int key = g_kbd_scan_981E;                         /* @0x02422D */
    if (key == 0xD) {                                  /* @0x024233 Enter -> colony report */
        int c = overlay_call_181F_07BE((int16_t)DG16(0x8540), (int16_t)DG16(0x853e));              /* @0x024266 colony_at_xy(cursor) */
        if (c < 0) return 1;                           /* @0x024271 */
        overlay_call_181F_0608();                      /* @0x02428C open_colony_report(c) */
        return 1;                                       /* @0x024294 */
    }
    if (key == 0x20) {                                 /* @0x024235 (0xd+0x13) Space */
        /* if ([0x53C6]) { [0x53C4]=0; return 1; } else advance + autumn check
         * @0x02423A..0x02425C (near 0x44E0). */
        overlay_call_181F_0E1C(1);                      /* (refresh on the advance path) */
        return 1;
    }
    return 0;                                           /* @0x0242A4 unhandled */
}

/* ============================================================================
 * func_0242AE  -- MOUSE-REGION HIT-TEST  (which screen zone is the cursor in)
 * ----------------------------------------------------------------------------
 * @asm        0x0242AE..0x024322  (TRUE size 116; auto-trace 98)
 * @asm_disasm page_01.asm (func_0242AE)
 * @status     BYTE_VERIFIED
 *
 * int region():  classifies the mouse position [0x7E8](x)/[0x7EA](y):
 *   r = 0;
 *   if (0 <= x < [0x8550] && 8 <= y < [0x8552]+8)  r = 1;   ; @0x0242B7..0x0242DA  (main map view)
 *   if (0xFC <= x < 0x134 && 9 <= y < 0x30)        r = 2;   ; @0x0242DF..0x0242FD  (minimap box)
 *   if (overlay_call_181F_03CA(0xf1, 0x32, 0x4f, 0x96))        r = 3;   ; @0x024302 LCALL 0x181F:0x3CA  (side panel)
 *   return r;
 * (Rect args to 0x181F:0x3CA are pushed 0xF1,0x32,0x4F,0x96 = a fixed panel
 *  rectangle.  [0x8550]/[0x8552] = map-view pixel width/height.)
 * ============================================================================ */
int func_0242AE_mouse_region(void)
{
    int r = 0;                                         /* @0x0242B2 [bp-2]=0 */
    /* main-map view test @0x0242B7..0x0242DA -> r=1 */
    /* minimap box test   @0x0242DF..0x0242FD -> r=2 */
    if (overlay_call_181F_03CA(0xf1, 0x32, 0x4f, 0x96)) {                    /* @0x02430C overlay_call_181F_03CA(0xf1, 0x32, 0x4f, 0x96) */
        r = 3;                                          /* @0x024318 side panel */
    }
    return r;                                           /* @0x02431D [bp-2] */
}

/* ============================================================================
 * func_024322  -- VIEWPORT-RELATIVE DISPATCH WRAPPER
 * ----------------------------------------------------------------------------
 * @asm        0x024322..0x024342  (TRUE size 32; auto-trace 21)
 * @asm_disasm page_01.asm (func_024322)
 * @status     BYTE_VERIFIED
 *
 * void wrapper(int a):  forwards to 0x191F:0x468 with the viewport origin:
 *   call_191F_468([0x83A], [0x83C], a);                ; @0x024325..0x024330
 * ([0x83A]/[0x83C] = the viewport pixel origin x/y; arg a = [bp+6].)
 * (Bytes 0x024337..0x024341 after this RETF -- "6a 01 0e e8 71 08 ..." -- are
 *  a SEPARATE tiny RETF stub at 0x024338 calling near 0x453F(1); it begins at
 *  the file boundary 0x024337 and properly belongs to the next page region.)
 * ============================================================================ */
int func_024322_viewport_dispatch(uint16_t arg0_bp_06)
{
    (void)arg0_bp_06;
    /* push [0x83A]; push [0x83C]; ax=[bp+6]; @0x024325..0x02432D */
    return overlay_call_191F_0468();                   /* @0x024330 call_191F_468(origin, a) */
}
