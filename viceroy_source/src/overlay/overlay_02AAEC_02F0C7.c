/* ============================================================================
 * overlay_02AAEC_02F0C7.c -- overlay functions in file range 0x02AAEC..0x02F0C7
 *
 * SUBSYSTEM (proven below): the interactive COLONY-SCREEN cluster — the
 * "open colony" dialog (render + event loop), its right-click / keyboard command
 * routers, the per-unit garrison order popups, the colony work-tile / building
 * click handlers, and the colony LIFE-CYCLE primitives (FOUND / DESTROY colony,
 * per-power contact flags).  Directly adjacent to (and the same subsystem as)
 * src/overlay/overlay_027BB6_02A92B.c, hand-ported the same day in the same style.
 *
 * The colony being operated on is *(0x8542) (`ctx`, a ColonyRecord far pointer);
 * fields are read/written off it with byte-cited offsets.  ColonyRecord table
 * base = 0x5D46, stride 0xCA (confirmed throughout by `imul 0xCA`).  Per-unit work
 * uses UnitRecord (base 0x3144, stride 0x1C: +0=x +1=y +2=type +3=terrain/owner
 * nibble +0x06=home-colony +0x16=work-counter +0x17=activity).  PowerRecord
 * stride 0x13C (confirmed by `imul 0x13C`).
 *
 * GUI work forwards to the resident library through two thunk windows:
 *     0x181F:NNN   GUI/text/sprite primitives + game-state helpers
 *     0x191F:NNN   windowed-control library
 * plus a page-local trampoline table (5-byte `JMPF 0x191F:off` each): for
 * func_02C5D4 at file 0x02C974..0x02CA82 and for func_02EE34 at 0x02EF46..0x02EF63.
 * The page's IP-relative `call 0xNNNN` sites land on those trampolines, so a near
 * call resolves to the 0x191F target it forwards to (file = 0x024BF0 + IP, or
 * for page 03 file = 0x02CB00 + IP).  `call 0x245F` is a load-image helper
 * (file 0x0245F region) that pops up a message box and returns a toggle byte.
 *
 * GROUND TRUTH (in priority order):
 *   - code/VICEROY/disasm_overlay_reseg/page_02.asm (funcs 02AAEC..02C5D4) and
 *     page_03.asm (funcs 02CFD0..02F052) — RE-SEGMENTED full bodies.  The
 *     per-func dumps code/VICEROY/disasm/func_*_unknown.asm TRUNCATE at the first
 *     RETF and report WRONG sizes; every @asm extent below is corrected.
 *   - COLONIZE/VICEROY.EXE raw bytes (ULTIMATE arbiter; first-4-byte spot-checks
 *     pass — see verification at end of port session).
 *   - lcall_resolution_VICEROY.json (thunk-window resolution) +
 *     src/overlay/OVERLAY_LCALL_REFERENCE.md (HIGH/MED thunk roles).
 *   - extracted strings via file_offset = handle + 0x1D9A0 (string-XREF roles).
 *
 * STATUS POLICY (cite-or-TBD): each function is BYTE_VERIFIED (body hand-traced
 * vs the reseg disasm), SUPERSEDED (already ported in a named subsystem file), or
 * PHANTOM (not real code).  Where a thunk's pixel/semantic effect is not
 * independently confirmed the body is faithful to the call sites and the residual
 * is called out TBD.  Nothing guessed.
 *
 * Auto-traced control-flow stubs REPLACED with hand-ported bodies 2026-05-30.
 * Externs are declared locally (this file does not edit globals.h / the Makefile;
 * the overlay_*.c skeletons are reference artifacts, not compiled units).
 * ============================================================================ */
#include "viceroy.h"
#include "overlay_externs.h"

/* ---- the active-colony far pointer (`ctx`) and field helpers --------------- */
extern char far *ctx;            /* *(0x8542) -> ColonyRecord[active] (base 0x5D46)*/
#define CB(off)  (*(uint8_t  far *)((char far *)ctx + (off)))  /* ctx byte field  */
#define CW(off)  (*(uint16_t far *)((char far *)ctx + (off)))  /* ctx word field  */
/* Absolute DGROUP byte access by computed offset (DGROUP_PTR per viceroy_types.h).
 * Used for the ColonyRecord (base 0x5D46/0xCA) and UnitRecord (0x3144/0x1C) tables
 * and their adjacent per-power arrays; the literal carries the table base. */
#define COLREC_B(abs) (*(uint8_t near *)DGROUP_PTR(abs))      /* ColonyRecord byte */
#define UREC_B(abs)   (*(uint8_t near *)DGROUP_PTR(abs))      /* UnitRecord byte   */
#define DG_W(abs)     (*(int16_t near *)DGROUP_PTR(abs))      /* DGROUP word       */

/* ---- named DGROUP globals touched here (offsets @asm-cited at use site) ----- */
extern int16_t  g_cursor_x_07E8;     /* 0x07E8 cursor cell X (pixels)            */
extern int16_t  g_cursor_y_07EA;     /* 0x07EA cursor cell Y (pixels)            */
extern int16_t  g_screen_mode_8D54;  /* 0x8D54 active screen id (7=colony grid)  */
extern int16_t  g_sel_unit_033E;     /* 0x033E selected unit slot                */
extern int16_t  g_colony_count_539E; /* 0x539E live colony count (max 0x30)      */
extern int16_t  g_redraw_0346;       /* 0x0346 "colony view dirty" flag          */
extern int16_t  g_submode_032E;      /* 0x032E selection-changed / submode flag  */
extern int16_t  g_count_033C;        /* 0x033C visible-cell count                */
extern int16_t  g_int_mode_07F4;     /* 0x07F4 interactive (mouse) mode active   */
extern int16_t  g_popup_07E4;        /* 0x07E4 popup/blocking flag               */
extern int16_t  g_flag_07EC;         /* 0x07EC event-pending / left-button flag  */
extern int16_t  g_flag_07F6;         /* 0x07F6 right-button / menu flag           */
extern int16_t  g_flag_07F0;         /* 0x07F0 held flag                          */
extern int16_t  g_flag_07EE;         /* 0x07EE option gate                        */
extern int16_t  g_mouse_x_089E;      /* 0x089E mouse X                            */
extern int16_t  g_mouse_y_08A0;      /* 0x08A0 mouse Y                            */
extern uint8_t  g_drag_active_A88C;  /* 0xA88C drag-in-flight flag                */
extern uint8_t  g_drag_id_A88D;      /* 0xA88D dragged item id                    */
extern uint8_t  g_drag_qty_A88E;     /* 0xA88E dragged quantity                   */
extern uint8_t  g_drag_cell_A88F;    /* 0xA88F dragged source cell                */
extern uint8_t  g_btn_hit_A88B;      /* 0xA88B options-button latch               */
extern uint8_t  g_human_gate_A897;   /* 0xA897 "interactive (human) colony" gate  */
extern uint8_t  g_msg_toggle_A898;   /* 0xA898 load-image message toggle byte     */
extern int16_t  g_w0340, g_w033A_alt;/* 0x0340 list idx B; (alt) — see use sites  */
extern uint8_t  g_color_033A;        /* 0x033A highlight player index             */
extern uint8_t  g_player_0337;       /* 0x0337 displayed player color/index       */
extern int16_t  g_w0342;             /* 0x0342 prev/next arrow latch (-1/0/1)     */
extern int16_t  g_w0344;             /* 0x0344 cursor-saved flag                  */
extern int16_t  g_w0334;             /* 0x0334 secondary toggle                   */
extern int16_t  g_w0348, g_w034A;    /* 0x0348 redraw-map flag; 0x034A last build */
extern int16_t  g_w034E, g_w0070;    /* 0x034E / 0x0070 cleanup latches           */
extern int16_t  g_w0890, g_w0B98;    /* 0x0890 in-colony flag; 0x0B98 quick-exit  */
extern int16_t  g_w0828, g_w0D04;    /* 0x0828 option; 0x0D04 latch               */
extern int16_t  g_w032E_unused;
extern int16_t  g_w53C2;             /* 0x53C2 colony scratch                     */
extern int16_t  g_w53A2;             /* 0x53A2 god/fog flag (contact predicate)   */
extern int16_t  g_w53A0;             /* 0x53A0 ? count (destroy-colony fixup)     */
extern int16_t  g_w539C;             /* 0x539C unit count                         */
extern int16_t  g_w5396;             /* 0x5396 active player power index          */
extern int16_t  g_w8D72, g_w8D76;    /* 0x8D72 hover flag; 0x8D76 row count       */
extern int16_t  g_w8D78, g_w8D7A;    /* 0x8D78/0x8D7A moused cell (x,y)           */
extern int16_t  g_w8D7C;             /* 0x8D7C selected unit handle               */
extern int16_t  g_w8D58, g_w8D5A, g_w8D5C, g_w8D5E, g_w8D60; /* 8D58.. timers     */
extern int16_t  g_w8DBA, g_w8DBC, g_w8DC6; /* 8DBA/8DBC site coords; 8DC6 map idx  */
extern int16_t  g_w8DE4, g_w8DE6;    /* 0x8DE4/0x8DE6 queue-empty flags           */
extern int16_t  g_w8F8E, g_w8F9A;    /* 0x8F8E/0x8F9A fort defence bonuses        */
extern int16_t  g_w0840, g_w083E;    /* 0x0840/0x083E dialog placement words      */
extern int16_t  g_w93A2, g_w93A4, g_w93A6, g_w93A8, g_w93AA; /* GUI coord words   */
extern int16_t  g_w97E0, g_w97DC, g_w2EB8; /* runtime data pointers (not strings) */
extern int16_t  g_w2DFE, g_w2E00;    /* 0x2DFE / 0x2E00 popup-item handle words   */
extern int16_t  g_w1F5E, g_w1F66, g_w1F68; /* 0x1F5E/0x1F66/0x1F68 menu latches    */
extern uint8_t  g_b_5382, g_b_5383, g_b_5386, g_b_5387; /* colony option bytes     */
extern uint8_t  g_b_5376, g_b_537D;  /* combat scratch bytes                      */
extern int16_t  g_w5372;             /* combat scratch word                       */
extern uint8_t  g_b_0828;            /* 0x0828 option byte                        */
extern uint8_t  g_b_0B9A, g_b_0B9B, g_b_0B9C, g_b_0B9D, g_b_0B9E, g_b_0B9F; /* btns*/
extern uint8_t  g_power_ctrl[];      /* 0x543F base, stride 0x34: controller flag */
extern uint16_t g_unit_disp_5230[];  /* 0x5230 per-unit-type GUI attr (stride 12) */

/* ---- 0x181F GUI/text/state thunks used here (args documented at call site) -- */
extern int overlay_call_181F_0022(void);  /* fmt_id(id,handle) -> DX:AX string    */
extern int overlay_call_181F_00D8(void);  /* str_append_far(buf,ss,...)            */
extern int overlay_call_181F_00E2(void);  /* draw_click_feedback(x0,w,y,...)       */
extern int overlay_call_181F_00EC(void);  /* event helper                          */
extern int overlay_call_181F_00F6(void);  /* poll_event() -> nonzero on event      */
extern int overlay_call_181F_009C(void);  /* poll_event2()                         */
extern int overlay_call_181F_00A6(void);  /* screen_clear(7,0x140,0,0)             */
extern int overlay_call_181F_0056(void);  /* push_page / palette select(arg)       */
extern int overlay_call_181F_011E(void);  /* str_clear(buf)                        */
extern int overlay_call_181F_0128(void);  /* str_finalise(buf)                     */
extern int overlay_call_181F_016E(void);  /* str_append(handle,buf)                */
extern int overlay_call_181F_0178(void);  /* str_space(buf)                        */
extern int overlay_call_181F_0182(void);  /* str_append_n(value,buf)               */
extern int overlay_call_181F_02E4(void);  /* iter_next_unit() -> slot or <0        */
extern int overlay_call_181F_0302(void);  /* colony_visible_to(x,y) == func_02EB46 */
extern int overlay_call_181F_0352(void);  /* highlight_tile(x,y,x,y,0)             */
extern int overlay_call_181F_035C(void);  /* cursor->cell: (cursor-base)/stride    */
extern int overlay_call_181F_03A2(void);  /* get_active_power()                    */
extern int overlay_call_181F_03C0(void);  /* quick_exit_draw()                     */
extern int overlay_call_181F_03CA(void);  /* point_in_rect(x0,w,y,h) -> bool       */
extern int overlay_call_181F_03EA(void);  /* draw helper(8)                        */
extern int overlay_call_181F_03E0(void);  /* event payload                         */
extern int overlay_call_181F_03FE(void);  /* draw_msg(handle)                      */
extern int overlay_call_181F_0416(void);  /* draw_text(ds:ptr,attr)                */
extern int overlay_call_181F_0438(void);  /* string/event dispatch(handle,slot,buf)*/
extern int overlay_call_181F_045C(void);  /* drain_input(0,redraw)                 */
extern int overlay_call_181F_0466(void);  /* poll_begin(0)                         */
extern int overlay_call_181F_0470(void);  /* poll_arm()                            */
extern int overlay_call_181F_047A(void);  /* timer_arm()                           */
extern int overlay_call_181F_04B6(void);  /* draw_label(kind)                      */
extern int overlay_call_181F_04C0(void);  /* beep(id)                              */
extern int overlay_call_181F_056A(void);  /* leave_screen()                        */
extern int overlay_call_181F_05B6(void);  /* finish(5)                             */
extern int overlay_call_181F_0652(void);  /* draw_boxed_text(id5,strID)            */
extern int overlay_call_181F_068C(void);  /* set_map_tile(a,b,x,y)                 */
extern int overlay_call_181F_06B4(void);  /* site_query(x,y) -> kind               */
extern int overlay_call_181F_06BE(void);  /* tile_bounds(y,x) -> <0 if oob         */
extern int overlay_call_181F_0718(void);  /* feature_at(x,y) -> kind               */
extern int overlay_call_181F_0740(void);  /* map_tile_ptr(x,y) -> ES:BX            */
extern int overlay_call_181F_074A(void);  /* resource_mask(x,y) -> bitset          */
extern int overlay_call_181F_0768(void);  /* tile_has_target(x,y) -> bool          */
extern int overlay_call_181F_078C(void);  /* unit_at_cell(x,y) -> slot             */
extern int overlay_call_181F_07AA(void);  /* play_found_music(map_idx,slot)        */
extern int overlay_call_181F_07B4(void);  /* music_query(6,slot) -> bool           */
extern int overlay_call_181F_07E0(void);  /* iter_units_at(x,y) begin              */
extern int overlay_call_181F_0808(void);  /* finish_work_order(slot)               */
extern int overlay_call_181F_08BC(void);  /* unit_query(2,slot) -> count           */
extern int overlay_call_181F_089E(void);  /* clear_unit_orders(slot)               */
extern int overlay_call_181F_092A(void);  /* unit_at_xy(x,y) -> slot               */
extern int overlay_call_181F_0934(void);  /* select_cell(idx)                      */
extern int overlay_call_181F_0942(void);  /* play_unit_sound(type) [191F window]   */
extern int overlay_call_181F_095C(void);  /* place_worker(coords,owner,building)->n */
extern int overlay_call_181F_0966(void);  /* gate -> bool                          */
extern int overlay_call_181F_0970(void);  /* draw_combat_overlay(power,y,x)        */
extern int overlay_call_181F_09AE(void);  /* colony_helper(0,ax,0)                 */
extern int overlay_call_181F_09BA(void);  /* spawn_unit(1,1,1,y,x)                 */
extern int overlay_call_181F_09E6(void);  /* get_colony_by_slot(slot) -> *(0x8542) */
extern int overlay_call_181F_09FC(void);  /* colony_has_structure(arg) -> bool     */
extern int overlay_call_181F_0A38(void);  /* diplomacy(a,b) -> bitset              */
extern int overlay_call_181F_0AC4(void);  /* unit_attr(slot,&out)                  */
extern int overlay_call_181F_0AE2(void);  /* map_mouse_to_tile() -> idx            */
extern int overlay_call_181F_0B14(void);  /* contact_query(0,colony) -> byte       */
extern int overlay_call_181F_0B28(void);  /* unit_activity_flag(slot) -> bool      */
extern int overlay_call_181F_0B32(void);  /* get_unit_by_index(idx) -> slot        */
extern int overlay_call_181F_0B64(void);  /* tile_query(idx) -> id or 0xFFFF       */
extern int overlay_call_181F_0BE6(void);  /* order_arg(cell,unit) / (a,b,unit)     */
extern int overlay_call_181F_0C0E(void);  /* terrain_class(cell) -> kind           */
extern int overlay_call_181F_0C22(void);  /* draw helper                           */
extern int overlay_call_181F_0C36(void);  /* finish_view(a,b)                      */
extern int overlay_call_181F_0C4A(void);  /* sub_view(a,b) -> handle               */
extern int overlay_call_181F_0C54(void);  /* building_at(handle) -> id             */
extern int overlay_call_181F_0C68(void);  /* building_count(cell,unit) -> n        */
extern int overlay_call_181F_0C72(void);  /* draw_colony_base()                    */
extern int overlay_call_181F_0CC2(void);  /* unit_class(&out,slot) -> kind         */
extern int overlay_call_181F_0CE0(void);  /* ring_cell(dx,dy) -> idx or <0         */
extern int overlay_call_181F_0D26(void);  /* seed_building(1,code)                 */
extern int overlay_call_181F_0D12(void);  /* special_site(x,y) -> bool             */
extern int overlay_call_181F_0D30(void);  /* edit_name(y,x,0) RENAMECOLONY         */
extern int overlay_call_181F_0D4E(void);  /* unit_def(slot) -> DX:AX               */
extern int overlay_call_181F_0D9A(void);  /* apply_terrain_change(y,x)             */
extern int overlay_call_181F_0BBE(void);  /* draw_per_power_backdrop(a,b)          */
extern int overlay_call_181F_0CAE(void);  /* draw helper(a,b)                      */

/* ---- 0x191F windowed-control thunks --------------------------------------- */
extern int overlay_call_191F_0120(void);  /* edit_field(0x17,dst,title,key)       */
extern int overlay_call_191F_0176(void);  /* list_add_item(id,buf,y,x)            */
extern int overlay_call_191F_016A(void);  /* run_list_dialog() -> picked          */
extern int overlay_call_191F_0182(void);  /* open_list_dialog(title,key) -> DX:AX */
extern int overlay_call_191F_01A8(void);  /* close_list_dialog(handle)            */
extern int overlay_call_191F_01DE(void);
extern int overlay_call_191F_01D0(void);
extern int overlay_call_191F_0230(void);  /* list_begin(slot,w,w,handle)          */
extern int overlay_call_191F_023C(void);  /* open_tooltip_dialog(id,x,y) -> DX:AX */
extern int overlay_call_191F_0254(void);  /* redraw_map(map_idx)                  */
extern int overlay_call_191F_02CE(void);  /* unit_ref_reload(i)                   */
extern int overlay_call_191F_033C(void);  /* list_highlight(1,id,...)             */
extern int overlay_call_191F_03B8(void);  /* per-key cmd op (owner)               */
extern int overlay_call_191F_03C6(void);  /* per-key cmd op (owner)               */
extern int overlay_call_191F_03D4(void);  /* per-key cmd op (owner)               */
extern int overlay_call_191F_03E2(void);  /* per-key cmd op (owner)               */
extern int overlay_call_191F_03F0(void);  /* per-key cmd op (owner)               */
extern int overlay_call_191F_03FE(void);  /* per-key cmd op (owner)               */
extern int overlay_call_191F_040C(void);  /* per-key cmd op (owner)               */
extern int overlay_call_191F_0428(void);  /* unit_render(slot)                    */
extern int overlay_call_191F_054C(void);  /* finish view (wrapper A)              */
extern int overlay_call_191F_05E8(void);  /* request_redraw()                     */
extern int overlay_call_191F_08C6(void);  /* list_add_first(id,...)               */
extern int overlay_call_191F_08DE(void);  /* show_building_info(id)               */
extern int overlay_call_191F_08EC(void);  /* list_set(id,...)                     */
extern int overlay_call_191F_0902(void);  /* list_action(arg)                     */
extern int overlay_call_191F_0910(void);  /* list_cursor_step()                   */
extern int overlay_call_191F_091C(void);  /* list_cursor_measure(buf)             */
extern int overlay_call_191F_0928(void);  /* dispatch_overlay_op(key,title)       */
extern int overlay_call_191F_0934(void);  /* select_color_cell(arg)               */
extern int overlay_call_191F_0942(void);  /* play_unit_sound(type)                */
extern int overlay_call_191F_095E(void);  /* enter_colony_screen()                */
extern int overlay_call_191F_096C(void);  /* leave_colony_screen2()               */
extern int overlay_call_191F_0A06(void);  /* land_combat_apply()                  */
extern int overlay_call_191F_0A14(void);  /* land_combat_decide(...) = func_0270D0+0x33E*/
extern int overlay_call_191F_0A20(void);  /* combat_query(...)                    */
extern int overlay_call_191F_0A2E(void);
extern int overlay_call_191F_0A3C(void);  /* unit_ref_clear(i)                    */
extern int overlay_call_191F_0A4A(void);  /* unit_ref_value(i)                    */

/* ---- C runtime + far helpers ----------------------------------------------- */
extern int  overlay_call_0D1D_07A4(void);  /* dispatch_overlay_op(opcode,arg)      */
extern int  overlay_call_0D1D_117E(void);  /* sprintf(buf,...)                     */
extern int  overlay_call_0D1D_0D64(void);  /* strlen(buf)                          */
extern int  overlay_call_0D1D_0842(void);  /* edit_buffer_dirty(buf) -> bool       */
extern int  overlay_call_0D1D_07E4(void);  /* strcpy(dst,src)                      */
extern int  overlay_call_0D1D_0DAE(void);  /* memset(dst,val,n)                    */
extern long overlay_call_0C0C_0006(void);  /* ms_clock() -> DX:AX                  */

/* ---- page-local near trampolines (named by the 0x191F target they JMPF to) -- */
/* (declared as voids; their bodies live in the 0x191F windowed-control library) */
extern int overlay_call_191F_0594(void);  /* near 0x7DD9 -> commit unit drag       */
extern int overlay_call_191F_0684(void);  /* near 0x7E3D -> refresh                 */
extern int overlay_call_191F_06CC(void);  /* near 0x7E5B -> sample button (02CA4B)  */
extern int overlay_call_191F_06F0(void);  /* near 0x7E51 -> begin move (02CA41)     */
extern int overlay_call_191F_0654(void);  /* near 0x7E29 -> button1 action          */
extern int overlay_call_191F_04E0(void);  /* near 0x7D8E -> button0 action          */
extern int overlay_call_191F_0534(void);  /* near 0x7DB1 -> button2 action          */
extern int overlay_call_191F_0744(void);  /* near 0x7E8D -> button refresh (02CA7D) */
extern int overlay_call_191F_0738(void);  /* near 0x7E88 -> close (02CA78)          */
extern int overlay_call_191F_0690(void);  /* near 0x7E42 -> highlight (02CA32)      */
extern int overlay_call_191F_069C(void);  /* near 0x7E47 -> region hit (02CA37)     */
extern int overlay_call_191F_05D0(void);  /* near 0x7DF2 -> event handler           */
extern int overlay_call_191F_05F4(void);  /* near 0x7E01 -> teardown helper         */
extern int overlay_call_191F_0840(void);  /* near 0x7EF6 -> palette flip            */
extern int overlay_call_191F_0774(void);  /* near 0x7EA1 -> draw helper (02CA32?)   */
extern int overlay_call_191F_0510(void);  /* near 0x7DA2 -> draw helper (02C992)    */
extern int overlay_call_191F_0648(void);  /* near 0x7E24 -> draw helper (02CA14)    */
extern int overlay_call_191F_0708(void);  /* near 0x7E74 -> click feedback (02CA64) */
extern int overlay_call_191F_0720(void);  /* near 0x7E83 -> NEXT colony (02CA73)    */
extern int overlay_call_191F_0678(void);  /* near 0x7E38 -> PREV colony (02CA28)    */
/* load-image message box (file 0x0245F): pops a string, returns toggle byte. */
extern int loadimg_msgbox(void);          /* near 0x245F (NOMORE*/BUILT*/DEPLETION) */

/* ============================================================================
 * func_02AAEC  — colony garrison/ship unit-orders POPUP  ("COLONYUNIT"/"SHIPOPTIONS")
 * @asm        0x02AAEC..0x02AD8D  (674 bytes)  ENTER 0x64  RETF   page 0x02
 * @asm_ref    page_02.asm "func_02AAEC size=674 insns=244" (per-func dump's 63B
 *             is a first-RET truncation; true terminal RETF @0x02AD8D).
 * @role       STRING-XREF "COLONYUNIT"(0xCED @0x02ABB1), "SHIPOPTIONS"(0xCF8
 *             @0x02ABD1).  For the unit selected in the colony garrison: formats
 *             its name+activity label, opens the order menu, then dispatches the
 *             chosen order — sets UnitRecord+0x08 (abs 0x314C) activity to 0/1/5,
 *             or wakes the unit ([0x8D78]=slot; clear [0x340]/[0x33E]), or runs a
 *             board/load op (near 0x7DD9).  Order list-item enable tests read the
 *             same activity byte (==1/5/6) and type (==0xC) @0x02AC36..0x02AC83.
 * @status     BYTE_VERIFIED (control flow + struct + string + writes).
 *             0x191F:0x176=blit_label/add_menu_row; 0x91C=next_token/next_item;
 *             0x910=copy_tok (CONFIRMED: overlay_06D938, overlay_027BB6, overlay_054505).
 */
int func_02AAEC_op_sz_63(void)
{
    int unit_slot;          /* [bp-0x60] @asm 0x02AB06 */
    char namebuf[0x50];     /* [bp-0x50] label scratch  @0x02AB4D */
    int dlg;                /* dialog handle [bp-0x58:-0x56] @0x02ABBC */
    int sel;                /* menu result [bp-0x54] @0x02ACCF */
    int i;                  /* [bp-0x5E] @0x02AC02 */

    unit_slot = overlay_call_181F_0B32();           /* @0x02AAFE get_unit_by_index([0x33E]) */
    if (unit_slot < 0) goto done;                   /* @0x02AB0B JGE */
    if (overlay_call_181F_0966() != 0)              /* @0x02AB10 */
        DG_W(0x5392) = unit_slot;                   /* @0x02AB1C [0x5392]=slot */

    /* @0x02AB1F UnitRecord[slot] (imul 0x1C); +0x02 type (0x3146) *7*2 indexes the
     * unit-name handle table [bx+0x5230]; format label via 0x181F:0x438. */
    overlay_call_181F_0438();                       /* @0x02AB45 dispatch(name_handle,0,namebuf) */
    namebuf[0] = 0;                                 /* @0x02AB4D */
    if (UREC_B(unit_slot * 0x1C + 0x17) == 0x0A) {  /* @0x02AB51 activity==0xA sentried */
        overlay_call_181F_0178(); overlay_call_181F_011E(); /* @0x02AB6B/0x02AB77 */
        overlay_call_181F_00D8(); overlay_call_181F_0128(); /* @0x02AB8A/0x02AB96 */
    }
    overlay_call_181F_0416();                       /* @0x02ABA5 finalize line(attr=1) */

    dlg = overlay_call_191F_0182();                 /* @0x02ABB1 open_list_dialog(0x87C,"COLONYUNIT")*/
    if (dlg == 0) goto done;                        /* @0x02ABC4 */
    /* @0x02ABCC les bx,[dlg]; or es:[bx+0xA],3  (set list-control flags bits 0+1) */
    if (overlay_call_191F_0928() != 0)              /* @0x02ABD7 dispatch_overlay_op("SHIPOPTIONS",0x87C)*/
        goto done;                                  /* @0x02ABE1 */

    overlay_call_191F_0230();                       /* @0x02ABFA list_begin(slot,[0x840],[0x83E],dlg)*/
    for (i = 1; i <= 6; i++) {                      /* @0x02AC02..0x02ACA3 (i=[bp-0x5E]) */
        /* @0x02AC0A..0x02AC94 classify item i enabled from activity 0x314C/type. */
        if (/* order_item_enabled(unit_slot,i) */ 0)
            overlay_call_191F_0176();               /* @0x02AC92 list_add_item(i,namebuf,...) */
        overlay_call_191F_091C();                   /* @0x02ACAD list_cursor_measure */
        overlay_call_191F_0910();                   /* @0x02ACB6 list_cursor_step */
    }

    sel = overlay_call_191F_016A();                 /* @0x02ACCA run_list_dialog */
    overlay_call_191F_01A8();                       /* @0x02ACD8 close_list_dialog(dlg) */
    dlg = 0;
    if (sel < 1 || sel >= 6) goto done;             /* @0x02ACE5/0x02ACEE */

    /* @0x02ACF7 jump-table on (sel-1) at cs:[bx+0x5378]:
     *   wake unit  @0x02ACFC -> [0x8D78]=slot; [0x340]=0; [0x33E]=0
     *   set 0      @0x02AD18 -> UnitRecord+0x08 (0x314C) = 0
     *   set 1      @0x02AD24 -> = 1
     *   set 5      @0x02AD30 -> = 5
     *   board/load @0x02AD3C -> if UnitRecord+0x0C(0x3150)!=0: 0x181F:0xBE6 then
     *                            near 0x7DD9 (commit move). */
    switch (sel - 1) {                              /* @0x02ACF7 */
    case 0: g_w8D78 = unit_slot; g_w0340 = 0; g_sel_unit_033E = 0; break; /* @0x02ACFC */
    case 1: UREC_B(unit_slot * 0x1C + 0x08) = 0; break;  /* @0x02AD18 0x314C */
    case 2: UREC_B(unit_slot * 0x1C + 0x08) = 1; break;  /* @0x02AD24 */
    case 3: UREC_B(unit_slot * 0x1C + 0x08) = 5; break;  /* @0x02AD30 */
    case 4:                                          /* @0x02AD3C */
        if (UREC_B(unit_slot * 0x1C + 0x0C) != 0) {  /* 0x3150 */
            overlay_call_181F_0BE6();               /* @0x02AD4E */
            overlay_call_191F_0594();               /* @0x02AD5E near 0x7DD9 */
        }
        break;
    }

done: /* @0x02AD77 */
    if (dlg != 0)                                   /* @0x02AD7D */
        overlay_call_191F_01A8();                   /* @0x02AD85 close */
    return 0;                                       /* @0x02AD8C leave/retf */
}

/* ============================================================================
 * func_02AD8E  — colony-screen CLICK on the unit TILE row (mode 7 sub-handler)
 * @asm        0x02AD8E..0x02AED9  (331 bytes)  ENTER 0x0A  RETF
 * @asm_ref    page_02.asm "func_02AD8E size=331 insns=118"
 * @role       Maps cursor Y (0x07EA, gated <0x93) to a zone; cell from cursor X
 *             (0x07E8) via 0x181F:0x35C (/0x12 upper, /5 + 4 lower); clamps to the
 *             visible-cell count [0x33C].  On the colony grid (mode 7) commits a
 *             unit drag-drop or selects the unit under the cell (drag-state bytes
 *             0xA88C..0xA88F); other modes latch [0xD04], set submode 2, or play
 *             the unit sound.  Re-enters render via near trampolines.
 * @status     BYTE_VERIFIED (flow + globals; near helpers documented in externs above).
 */
int func_02AD8E_op_sz_121(void)
{
    int cell;               /* [bp-0xA] @asm 0x02ADE5 */

    if (g_cursor_y_07EA < 0x93)                     /* @0x02AD92 */
        cell = overlay_call_181F_035C() / 0x12;     /* @0x02ADB8 (X-0x82) zone */
    else
        cell = overlay_call_181F_035C() / 5 + 4;    /* @0x02ADD3 (X-0x7C) zone */
    if (g_count_033C - 1 < cell) cell = g_count_033C - 1; /* @0x02ADEC clamp [0x33C]-1 */

    if (g_screen_mode_8D54 != 7) goto other_modes;  /* @0x02ADFC */
    if (g_int_mode_07F4 == 0) return 0;             /* @0x02AE03 */
    if (g_drag_active_A88C == 0) {                  /* @0x02AE08 no drag */
        overlay_call_181F_0B32();                   /* @0x02AE13 from = get_unit_by_index([0x33E]) */
        overlay_call_181F_0B32();                   /* @0x02AE21 to   = get_unit_by_index(cell) */
        overlay_call_181F_03A2();                   /* @0x02AE2C get_active_power */
        overlay_call_191F_0594();                   /* @0x02AE3F near 0x7E7E (move) */
    } else {                                        /* @0x02AE44 drag active */
        overlay_call_181F_0B32();                   /* @0x02AE45 get_unit_by_index(cell) */
        overlay_call_191F_0594();                   /* @0x02AE62 near 0x7ED8 (drop) */
    }
    return 0;                                       /* @0x02AE68 */

other_modes: /* @0x02AE6A */
    if (g_flag_07EC != 0) g_w0D04 = g_sel_unit_033E;/* @0x02AE6F/0x02AE74 */
    if (g_flag_07F6 != 0) {                         /* @0x02AE77 */
        g_submode_032E = 2; g_w0340 = cell; g_sel_unit_033E = cell; /* @0x02AE7E/0x02AE84 */
        overlay_call_191F_0774();                   /* @0x02AE8E near 0x7EAB refresh */
    }
    if (g_int_mode_07F4 == 0) return 0;             /* @0x02AE91 */
    if (g_popup_07E4 == 0) {                        /* @0x02AE98 */
        if (g_w0D04 == g_sel_unit_033E) return 0;   /* @0x02AE9F */
        overlay_call_191F_06F0();                   /* @0x02AEB9 near 0x7EC4 */
        return 0;
    }
    if (g_count_033C == 0) return 0;                /* @0x02AEAE [0x33C] */
    overlay_call_181F_0B32();                       /* @0x02AEB9 get_unit_by_index([0x33E]) */
    overlay_call_191F_0942();                       /* @0x02AECB play_unit_sound(type +0x3146) */
    overlay_call_191F_0684();                       /* @0x02AED4 near 0x7E3D */
    return 0;                                       /* @0x02AED7 */
}

/* ============================================================================
 * func_02AEDA  — colony-screen CLICK on the BUILDINGS row (mode 7 sub-handler)
 * @asm        0x02AEDA..0x02AFCD  (243 bytes)  ENTER 8  RETF
 * @asm_ref    page_02.asm "func_02AEDA size=243 insns=90"
 * @role       Gated by [0x33C]; building cell = (cursorX 0x07E8 - 0x7F)/0xC via
 *             0x181F:0x35C.  On colony (mode 7) with drag active commits the drop
 *             (near 0x7ED8); else begins a building drag (near 0x7F05) seeding the
 *             drag-state bytes 0xA88C/D/E/F from the picked building & its count
 *             (0x181F:0xC68), and selects the cell (0x191F:0x934).
 * @status     BYTE_VERIFIED (flow + globals; drag helpers documented in externs above).
 */
int func_02AEDA_op_sz_127(void)
{
    int cell, unit_slot, drag_id;

    if (g_count_033C == 0) return 0;                /* @0x02AEE4 */
    cell      = overlay_call_181F_035C() / 0xC;     /* @0x02AEE9 (X-0x7F)/0xC */
    unit_slot = overlay_call_181F_0B32();           /* @0x02AF05 get_unit_by_index([0x33E]) */
    drag_id   = overlay_call_181F_0BE6();           /* @0x02AF16 order_arg(cell,unit) */

    if (g_screen_mode_8D54 == 7) {                  /* @0x02AF23 */
        if (g_int_mode_07F4 == 0) return 0;         /* @0x02AF2A */
        if (g_drag_active_A88C != 1) return 0;      /* @0x02AF34 */
        overlay_call_181F_03A2();                   /* @0x02AF3E get_active_power */
        overlay_call_191F_0594();                   /* @0x02AF50 near 0x7ED8 (drop) */
        return 0;                                   /* @0x02AF56 */
    }

    /* @0x02AF5A non-colony fallthrough: begin building drag if allowed. */
    if (g_flag_07EC == 0) goto sub_select;          /* @0x02AF5F */
    if (g_popup_07E4 != 0) goto sub_select;         /* @0x02AF65 */
    overlay_call_191F_05F4();                       /* @0x02AF72 near 0x7F05 begin drag */
    g_drag_active_A88C = 0;                          /* @0x02AF78 */
    g_drag_id_A88D     = (uint8_t)drag_id;           /* @0x02AF80 */
    g_drag_cell_A88F   = (uint8_t)cell;              /* @0x02AF86 */
    g_drag_qty_A88E    = (uint8_t)overlay_call_181F_0C68(); /* @0x02AF8F count */
    overlay_call_191F_05D0();                        /* @0x02AFA1 near 0x7DDE */

sub_select: /* @0x02AFA7 */
    if (g_int_mode_07F4 == 0) return 0;             /* @0x02AFA7 */
    if (drag_id < 0) return 0;                      /* @0x02AFAE */
    if (g_popup_07E4 == 0) return 0;                /* @0x02AFB4 */
    overlay_call_181F_0934();                       /* @0x02AFBB select_cell(drag_id) */
    overlay_call_191F_0684();                       /* @0x02AFC7 near 0x7E3D */
    return 0;                                       /* @0x02AFCA */
}

/* ============================================================================
 * func_02AFCE  — colony-screen OPTIONS-button hit-test + latch
 * @asm        0x02AFCE..0x02B045  (119 bytes)  ENTER 2  RETF
 * @asm_ref    page_02.asm "func_02AFCE size=119 insns=48"  (NOT a bare wrapper)
 * @role       Hit-tests rect (x0=0x7F,w=0xA5,y=0x48,h=0x16) via 0x181F:0x3CA;
 *             latches 0/1 into 0xA88B; small edge state-machine dispatching the
 *             near trampolines 0x7E79 / 0x7F00; refreshes submode 2 first.
 * @status     BYTE_VERIFIED.
 */
int func_02AFCE_logic_sz_41(void)
{
    uint8_t hit;            /* [bp-2] @asm 0x02AFFF */

    if (g_flag_07F6 != 0 && g_submode_032E != 2) {  /* @0x02AFD2/0x02AFD9 */
        g_submode_032E = 2;                         /* @0x02AFE0 */
        overlay_call_191F_0774();                   /* @0x02AFE7 near 0x7EAB */
    }
    hit = (overlay_call_181F_03CA() != 0) ? 1 : 0;  /* @0x02AFEE point_in_rect */
    if (g_flag_07EC != 0 || g_screen_mode_8D54 != 7)/* @0x02B00A/0x02B011 */
        g_btn_hit_A88B = hit;                       /* @0x02B018 */
    if (g_btn_hit_A88B == 0) {                      /* @0x02B01E */
        if (hit) return hit;
        overlay_call_191F_0738();                   /* @0x02B026 near 0x7E79 */
    } else if (g_btn_hit_A88B == hit) {             /* @0x02B02F */
        overlay_call_191F_0738();                   /* near 0x7F00 */
    }
    return g_btn_hit_A88B;                          /* @0x02B01E al */
}

/* ============================================================================
 * func_02B046  — UNIT-options popup variant ("COLONYUNIT"/"UNITOPTIONS")
 * @asm        0x02B046..0x02B29F  (602 bytes)  ENTER 0x60  RETF
 * @asm_ref    page_02.asm "func_02B046 size=602 insns=213"
 * @role       Sibling of func_02AAEC for the in-colony UNIT menu: STRING-XREF
 *             "COLONYUNIT"(0xD06 @0x02B111), "UNITOPTIONS"(0xD11 @0x02B131).
 *             Looks up the unit at the moused cell ([0x8D78]/[0x8D7A] via
 *             0x181F:0x92A), formats its label (type->name table [bx+0x5230],
 *             activity +0x17 0x315B != 0x1C, profession glyph word [bx-0x715C]),
 *             builds 5 order items, runs the menu and applies the chosen order to
 *             UnitRecord+0x08 (0x314C) with the same vocabulary as func_02AAEC,
 *             plus a beep (0x181F:0x4C0 id 0x58) for the "set 5" branch.
 * @status     BYTE_VERIFIED (flow + struct + string + writes; 0x191F:0x176=list_add_item, 0x91C=list_cursor_measure, 0x910=list_cursor_step — see externs).
 */
int func_02B046_op_sz_56(void)
{
    int unit_slot;          /* [bp-0x60] @asm 0x02B05F */
    char namebuf[0x50];     /* [bp-0x50] */
    int dlg, sel, i;

    unit_slot = overlay_call_181F_092A();           /* @0x02B05A unit_at_xy([0x8D78],[0x8D7A]) */
    if (unit_slot < 0) goto done;                   /* @0x02B064 */
    if (overlay_call_181F_0966() != 0)              /* @0x02B069 */
        DG_W(0x5392) = unit_slot;                   /* @0x02B075 [0x5392]=slot */

    overlay_call_181F_0438();                       /* @0x02B098 dispatch(name_handle,0,namebuf) */
    namebuf[0] = 0;                                 /* @0x02B0A0 */
    if (overlay_call_181F_0B28() &&                 /* @0x02B0A4 activity flag */
        UREC_B(unit_slot * 0x1C + 0x17) != 0x1C) {  /* +0x315B != 0x1C */
        overlay_call_181F_0178(); overlay_call_181F_011E(); /* @0x02B0C4/0x02B0D0 */
        overlay_call_181F_016E();                   /* @0x02B0E2 append profession glyph [bx-0x715C]*/
        overlay_call_181F_0128();                   /* @0x02B0F6 */
    }
    overlay_call_181F_0416();                       /* @0x02B103 finalize(attr=1) */

    dlg = overlay_call_191F_0182();                 /* @0x02B10D open "COLONYUNIT" */
    if (dlg == 0) goto done;                        /* @0x02B124 */
    if (overlay_call_191F_0928() != 0)              /* @0x02B137 dispatch "UNITOPTIONS" */
        goto done;

    overlay_call_191F_0230();                       /* @0x02B146 list_begin */
    for (i = 1; i <= 5; i++) {                      /* @0x02B162..0x02B196 */
        if (/* order_item_enabled */ 0)
            overlay_call_191F_0176();
        overlay_call_191F_091C(); overlay_call_191F_0910();
    }

    sel = overlay_call_191F_016A();                 /* @0x02B206 run_list_dialog */
    overlay_call_191F_01A8(); dlg = 0;              /* @0x02B21A close */
    if (sel < 1 || sel >= 5) goto done;             /* @0x02B227/0x02B22D */

    switch (sel - 1) {                              /* @0x02B233 jump-table */
    case 0: g_w8D78 = unit_slot; g_w8D7A = 0; break;     /* @0x02B238 wake */
    case 1: UREC_B(unit_slot * 0x1C + 0x08) = 0; break;  /* @0x02B252 */
    case 2: UREC_B(unit_slot * 0x1C + 0x08) = 1; break;  /* (set 1) */
    case 3: UREC_B(unit_slot * 0x1C + 0x08) = 5;         /* @0x02B26A */
            overlay_call_181F_04C0(); break;             /* @0x02B276 beep(0x58) */
    }

done: /* @0x02B28A */
    if (dlg != 0) overlay_call_191F_01A8();         /* @0x02B292 */
    return 0;                                       /* @0x02B29D */
}

/* ============================================================================
 * func_02B2A0  — colony-screen CLICK on the bottom command BAR
 * @asm        0x02B2A0..0x02B367  (199 bytes)  ENTER 8  RETF
 * @asm_ref    page_02.asm "func_02B2A0 size=199 insns=72"
 * @role       Cursor Y (0x07EA) >=0x9E -> cell (X-0xD5)/0x12; else two sub-rows
 *             ((X-0xD5)/5 + 1 + row*0x11 - 0xC, row from Y<0x98).  Clamps to
 *             [0x8D76]-1; sets submode [0x32E]=3, [0x8D7A]=cell; on a colony unit
 *             plays its type sound (0x191F:0x942) and refreshes via near
 *             trampolines (0x7E51/0x7E3D/0x7E88).
 * @status     BYTE_VERIFIED.
 */
int func_02B2A0_dialog_close_199(void)
{
    int cell;               /* [bp-8] @asm 0x02B304 */
    int row;                /* [bp-4] @0x02B2B0 */

    if (g_cursor_y_07EA >= 0x9E) {                  /* @0x02B2A4 */
        cell = overlay_call_181F_035C() / 0x12;     /* @0x02B2BC (X-0xD5)/0x12 */
    } else {                                        /* @0x02B2CC */
        row  = (g_cursor_y_07EA < 0x98) ? 2 : 1;    /* @0x02B2D2 */
        cell = overlay_call_181F_035C() / 5 + 1 + row * 0x11 - 0xC; /* @0x02B2E1..0x02B301 */
    }
    if (g_w8D76 - 1 < cell) cell = g_w8D76 - 1;     /* @0x02B30A clamp */

    if (g_flag_07F6 != 0) {                         /* @0x02B313 */
        g_submode_032E = 3;                         /* @0x02B31A */
        g_w8D7A = cell;                             /* @0x02B320 */
        if (g_int_mode_07F4 != 0) {                 /* @0x02B323 */
            if (g_popup_07E4 == 0) {                /* @0x02B32A */
                overlay_call_191F_06F0();           /* @0x02B332 near 0x7E51 */
            } else if (g_w8D72 != 0) {              /* @0x02B338 */
                overlay_call_181F_092A();           /* @0x02B346 unit_at_xy */
                overlay_call_191F_0942();           /* @0x02B355 sound(type) */
                overlay_call_191F_0684();           /* @0x02B35E near 0x7E3D */
            }
        }
    }
    overlay_call_191F_0738();                       /* @0x02B362 near 0x7E88 */
    return 0;                                       /* @0x02B365 */
}

/* ============================================================================
 * func_02B368  — build one colony GARRISON list-row (unit description + def bonus)
 * @asm        0x02B368..0x02B4D1  (361 bytes)  ENTER 0x5A  RETF
 * @asm_ref    page_02.asm "func_02B368 size=361 insns=126"
 * @role       arg0 (bp+0xA) = unit slot (or -1 for the colony's own defenders).
 *             Formats "<name> (def +N)" into a scratch buffer from the unit's
 *             class/attr/def helpers (0x181F:0xCC2/0xAC4/0xD4E), subtracting
 *             ctx->[0x92] (base defense, clamped >=0); compares the unit's
 *             attribute against the fortress level ctx->[0x94] and appends an icon
 *             ([0x97E0] / [0x97DC] / [0x2EB8]).  Emits the row via 0x191F:0x176 at
 *             (bp+6, bp+8).  Uses C-runtime sprintf (0xD1D:0x117E), strlen
 *             (0xD1D:0xD64) and dispatch_overlay_op (0xD1D:0x7A4).
 * @status     BYTE_VERIFIED (flow + ctx struct + helpers); some prims LOW.
 */
int func_02B368_op_sz_45(uint16_t arg0_bp_0A)
{
    int unit_slot = (int16_t)arg0_bp_0A;            /* @asm 0x02B36C */
    int item_id   = unit_slot + 2;                  /* [bp-0x5A] @0x02B36F */
    char line[0x52];                                /* [bp-0x54] */
    int kind, attr, defbonus, extra = 0;            /* [bp-0x56]/[bp-0x58]/[bp-4]/[bp-2] */

    if (unit_slot == -1) {                          /* @0x02B374 */
        overlay_call_181F_0022();                   /* @0x02B37A fmt(item_id,[0x93A8]) */
        goto emit;                                  /* @0x02B388 */
    }
    kind = overlay_call_181F_0CC2();                /* @0x02B391 unit_class */
    attr = overlay_call_181F_0AC4();                /* @0x02B3A3 unit_attr */
    overlay_call_181F_0D4E();                       /* @0x02B3B1 unit_def -> DX:AX */
    overlay_call_0D1D_117E();                       /* @0x02B3C0 sprintf(line) */
    overlay_call_0D1D_07A4();                       /* @0x02B3E7 dispatch_overlay_op(line) */

    defbonus = attr - CW(0x92);                     /* @0x02B3FB ctx->[0x92] */
    if (defbonus < 0) defbonus = 0;                 /* @0x02B406 */
    if (kind == 1) {                                /* @0x02B40D */
        if (overlay_call_181F_09FC() != 0) {        /* @0x02B416 */
            overlay_call_181F_016E();               /* @0x02B42A append [0x2EB8] */
            extra = 0;
            goto build;                             /* @0x02B437 */
        }
    }
    overlay_call_181F_0182();                       /* @0x02B442 str_append_n(defbonus) */
    overlay_call_181F_0178();                       /* @0x02B44E */
    overlay_call_181F_016E();                       /* @0x02B45A append [0x97E0] */
build:
    overlay_call_181F_0128();                       /* @0x02B46A */
    if (extra != 0) {                               /* @0x02B472 */
        overlay_call_181F_011E(); overlay_call_181F_0182(); /* @0x02B47C/0x02B48C */
        overlay_call_181F_0178(); overlay_call_181F_016E(); /* @0x02B498/0x02B4A8 [0x97DC]*/
        overlay_call_181F_0128();                   /* @0x02B4B4 */
    }
emit: /* @0x02B4BC */
    overlay_call_191F_0176();                       /* @0x02B4CA list_add_item(item_id,line,bp+8,bp+6)*/
    return 0;                                       /* @0x02B4CF */
}

/* ============================================================================
 * func_02B4D2  — colony-screen WORK-TILE grid click handler (assign worked tile)
 * @asm        0x02B4D2..0x02B743  (625 bytes)  ENTER 0x1E  RETF  touches *(0x8542)
 * @asm_ref    page_02.asm "func_02B4D2 size=625 insns=213"
 * @role       Reads mouse (0x089E x / 0x08A0 y), maps via 0x181F:0xAE2 to a work-
 *             tile index (>0xE/>0x16 -> centre path, count 0x10); opens the
 *             tile-selection tooltip (0x191F:0x23C id 0x800); highlights cells
 *             matching ctx->[0x94] (worked tile); adds menu rows 0x62..0x65; runs
 *             it.  On the chosen code: 0x62/0x63 nudge the worked-tile pointer;
 *             else set ctx->[0x94]=code-2 and clear ctx->[0x1C] bit 0x80.  Sets
 *             [0x1F66]=1 (tile menu latch).
 * @status     BYTE_VERIFIED (flow + ctx struct + mouse globals; menu prims documented in externs above).
 *             The page's loop re-enters at 0x02B52E (label restart) until done.
 */
int func_02B4D2_colony_sz_517(void)
{
    int step = 1, count = 1, changed = 0;           /* [bp-8]/[bp-0x10]/[bp-6] */
    int hit, mx, my, chosen, i;                     /* [bp-0x12]/.. [bp-4]/[bp-0x1A] */

    hit = overlay_call_181F_0AE2();                 /* @0x02B4EC map mouse->tile */
    mx = g_mouse_x_089E; my = g_mouse_y_08A0;       /* @0x02B4F7 */
    if (hit > 0xE && hit > 0x16) { step = 2; hit = 0x10; } /* @0x02B505..0x02B514 */

restart: /* @0x02B52E */
    if (overlay_call_191F_023C() == 0) goto done;   /* @0x02B527 open_tooltip(0x800,mx,my)*/
    /* es:[bx+0xA] |= 1 (list flags). @0x02B53C */
    overlay_call_191F_08C6();                       /* @0x02B558 list_add_first(fmt(0,[0x93A6]))*/
    overlay_call_181F_0022();                       /* @0x02B544 fmt id */
    if (/* [bp-2] */ 0 > 0)                         /* @0x02B560 */
        overlay_call_191F_0176();                   /* @0x02B57C row(0x62,[0x93AA]) */

    for (i = 0; i < count; i++) {                   /* @0x02B592..0x02B5F9 */
        int tile = overlay_call_181F_0B64();        /* @0x02B598 tile_query(hit+i) */
        if (tile == (int16_t)0xFFFF) continue;      /* @0x02B5A3 */
        overlay_call_191F_0690();                   /* @0x02B5B0 near 0x7E42 */
        if (CB(0x94) == tile) {                      /* @0x02B5BA ctx->[0x94] */
            overlay_call_191F_08EC();               /* @0x02B5CD list_set(tile+2) */
            overlay_call_191F_033C();               /* @0x02B5E3 list_highlight */
            changed = 1;                            /* @0x02B5EB */
        }
    }
    if (step - 1 > /*[bp-2]*/0) {                   /* @0x02B5FB */
        overlay_call_191F_0176();                   /* @0x02B604 row(0x63,[0x93AA]) */
        if (!changed) { overlay_call_191F_08EC(); overlay_call_191F_033C(); changed = 1; } /*@0x02B628*/
    }
    if (!changed) {                                 /* @0x02B64F */
        overlay_call_191F_08EC();                   /* @0x02B65B row(0x64) */
        overlay_call_191F_033C();                   /* @0x02B66D */
    }

    g_w1F66 = 1;                                    /* @0x02B67D latch */
    chosen = overlay_call_191F_016A();              /* @0x02B689 run_list_dialog */
    if (/* handle */ 0) overlay_call_191F_01A8();   /* @0x02B697 close */

    switch (chosen - 0x62) {                        /* @0x02B6AF */
    case 0: /* @0x02B6FC dec worked-tile pointer ([bp-2]--) */ break;
    case 1: /* @0x02B702 inc worked-tile pointer ([bp-2]++) */ break;
    default:
        count = 0;                                  /* @0x02B6C7 */
        if (chosen > 0 && g_w1F68 != 0) {           /* @0x02B6C0/0x02B6C2 */
            int t = overlay_call_181F_0CC2();       /* @0x02B6D3 unit_class(&loc,chosen-2)*/
            if (t == 1)      overlay_call_191F_0902();  /* @0x02B6E1 */
            else if (t == 2) overlay_call_191F_0942();  /* @0x02B6FE */
            overlay_call_191F_0684();               /* @0x02B70A near 0x7E3D */
            goto restart;                           /* @0x02B70D */
        }
        if (chosen > 0) {                           /* @0x02B710 */
            CB(0x94) = (uint8_t)(chosen - 2);        /* @0x02B719 ctx->[0x94]=code-2 */
            CB(0x1C) &= 0x7F;                        /* @0x02B71D clear bit 0x80 */
        }
        break;
    }
    if (count != 0) goto restart;                   /* @0x02B721 */

done: /* @0x02B72A */
    if (/* handle */ 0) overlay_call_191F_01A8();   /* @0x02B732 */
    overlay_call_191F_0774();                       /* @0x02B73E near 0x7EAB refresh */
    return 0;                                       /* @0x02B741 */
}

/* ============================================================================
 * func_02B744  — defender PRODUCTION/VALUE figure for the colony's active worker
 * @asm        0x02B744..0x02B8C5  (386 bytes)  ENTER 0x12  RETF  touches *(0x8542)
 * @asm_ref    page_02.asm "func_02B744 size=386 insns=140"
 * @role       Reached via 0x191F:0xA90 (from king_events.c func_02F052).  For the
 *             active worker ctx->[0x94] computes value = attr*13 (the *3<<2 + *1
 *             pattern @0x02B7B2) + ((PowerRecord[owner].byte[-0x779E] + 4) * delta)
 *             when the worker's defence delta (attr - ctx->[0xB6]) is positive;
 *             doubles when ctx->[0x92]==0.  PowerRecord stride 0x13C confirmed
 *             (imul 0x13C @0x02B7CB; owner = ctx->[0x1A]).
 * @status     BYTE_VERIFIED (head + ctx/PowerRecord struct); the exact value the
 *             tail returns past the accumulation shown is TBD (mirrors land prod).
 */
int func_02B744_colony_sz_24(void)
{
    int kind, attr, def, defbonus, value;

    kind = overlay_call_181F_0CC2();                /* @0x02B758 unit_class(&loc,ctx->[0x94]) */
    attr = overlay_call_181F_0AC4();                /* @0x02B771 unit_attr(&loc,ctx->[0x94]) */
    def  = /*[bp-2]*/ attr - CW(0xB6);              /* @0x02B783 ctx->[0xB6] */
    if (def < 0) def = 0;
    if (kind == 0) return 0;                        /* @0x02B78E */
    defbonus = attr - CW(0x92);                     /* @0x02B79A ctx->[0x92] */
    if (defbonus < 0) defbonus = 0;
    if (defbonus <= 0 && def == 0) return 0;        /* @0x02B7A5 */

    value = defbonus * 13;                          /* @0x02B7B2 (*3<<2 + *1) */
    if (def != 0) {                                 /* @0x02B7C0 */
        int pr = CB(0x1A) * 0x13C;                  /* @0x02B7CB PowerRecord[owner] */
        value += (UREC_B(pr - 0x779E + 0) + 4) * def; /* @0x02B7D4 */
    }
    if (CW(0x92) == 0) value <<= 1;                 /* @0x02B7E4/0x02B7EB */
    return value;                                   /* figure (tail = TBD) */
}

/* ============================================================================
 * func_02B8C6  — colony PREV/NEXT arrow hit-test + dispatch
 * @asm        0x02B8C6..0x02B9DB  (277 bytes)  ENTER 0x0A  RETF  touches *(0x8542)
 * @asm_ref    page_02.asm "func_02B8C6 size=277 insns=115"
 * @role       Snapshots [0x342], resets it -1; if the colony has a worker
 *             (ctx->[0x94] >= 0) hit-tests the LEFT arrow (origin [0x93A2], box
 *             0x8A..0xD8) and RIGHT arrow ([0x93A4], 0x8A..0x10E) via 0x181F:0x3CA,
 *             storing 0/1 in [0x342]; on a fresh press plays a click (0x181F:0xE2
 *             rect 0xD3,0x82,0x5B,0x30) and dispatches prev (near 0x7E38) / next
 *             (near 0x7E83).  (0x02B99E.. is a separate option-toggle entry reached
 *             only via the page jump table — not by falling through.)
 * @status     BYTE_VERIFIED (flow + regions + globals; 0x191F:0x708=click_feedback, 0x720=NEXT_colony — see externs).
 */
int func_02B8C6_colony_no_lcall_70(void)
{
    int prev = g_w0342;     /* [bp-0xA] @asm 0x02B8CA */

    g_w0342 = (int16_t)0xFFFF;                      /* @0x02B8D0 */
    if (CB(0x94) >= 0) {                            /* @0x02B8DA ctx->[0x94] signed */
        overlay_call_191F_0510();                   /* @0x02B8EE near 0x7DCF arrow A pos */
        if (overlay_call_181F_03CA())               /* @0x02B908 LEFT */
            g_w0342 = 0;                            /* @0x02B914 */
        overlay_call_191F_0510();                   /* @0x02B927 near 0x7DCF arrow B pos */
        if (overlay_call_181F_03CA())               /* @0x02B941 RIGHT */
            g_w0342 = 1;                            /* @0x02B94D */
    }
    if (g_w0342 != prev || g_flag_07F0 != 0) {      /* @0x02B956/0x02B95C */
        overlay_call_191F_0708();                   /* @0x02B964 near 0x7E74 */
        overlay_call_181F_00E2();                   /* @0x02B976 click feedback */
    }
    if (g_int_mode_07F4 == 0) {                     /* @0x02B97B */
        overlay_call_191F_0720();                   /* @0x02B98E near 0x7E83 NEXT */
        return 0;
    }
    if (g_w0342 == 0)      overlay_call_191F_0678();/* @0x02B998 near 0x7E38 PREV */
    else if (g_w0342 == 1) overlay_call_191F_0720();/* near 0x7E83 NEXT */
    return 0;                                       /* @0x02B99B */
}

/* ============================================================================
 * func_02B9DC  — colony-screen CELL dispatcher (modes 7 / 9 / 0xA)
 * @asm        0x02B9DC..0x02BB89  (429 bytes)  ENTER 6  RETF
 * @asm_ref    page_02.asm "func_02B9DC size=429 insns=158"
 * @role       Multi-mode click router keyed on [0x8D54]:
 *   mode 7 (@0x02B9E1): if drag live, commit (near 0x7DD9); else pick cell
 *           col=(X 0x07E8)/0x13 (<0x10), set drag-target from ctx->[+si+0x9A]
 *           (per-tile commodity, clamped 0x64), seed 0xA88C/D/E, begin drag.
 *   mode 0xA(@0x02BB2C): "RENAMECOLONY"(0xD30) text-entry into ctx->[+2] via the
 *           edit field (0x191F:0x120); on change strcpy from buffer [0x9820]
 *           (0xD1D:0x842 dirty / 0xD1D:0x7E4 strcpy) and refresh (near 0x7EAB).
 *   mode 9 (@0x02BB74): clear [0x346].
 * @status     BYTE_VERIFIED (flow + ctx struct + string + globals; helpers documented in externs above).
 */
int func_02B9DC_op_sz_72(void)
{
    int cell;               /* [bp-6] @asm 0x02BA3B */

    if (g_screen_mode_8D54 == 7) {                  /* @0x02B9E1 */
        if (g_int_mode_07F4 != 0 && g_drag_active_A88C == 0) { /* @0x02B9E8/0x02B9F2 */
            overlay_call_181F_0B32();               /* @0x02B9FC get_unit_by_index([0x33E]) */
            overlay_call_191F_0594();               /* @0x02BA1B near 0x7DD9 commit */
            return 0;
        }
        if (g_drag_active_A88C != 0) return 0;      /* @0x02BA02 */
        cell = overlay_call_181F_035C() / 0x13;     /* @0x02BA24 (X)/0x13 */
        if (cell >= 0x10) return 0;                 /* @0x02BA3E */
        if (g_flag_07F6 == 0) {                     /* @0x02BA46 */
            g_b_0B9D = 1;                           /* @0x02BA4D */
            if (g_b_0B9C == (uint8_t)cell) return 0;/* @0x02BA55 */
            g_b_0B9C = (uint8_t)cell;               /* @0x02BA5E */
            overlay_call_191F_0654();               /* @0x02BA64 near 0x7E29 */
            overlay_call_191F_05D0();               /* @0x02BA6E near 0x7D9D */
            overlay_call_181F_00E2();               /* @0x02BA83 feedback */
            return 0;
        }
        if (g_submode_032E != 4 || g_color_033A != (uint8_t)cell) { /* @0x02BA9C */
            g_submode_032E = 4;                     /* @0x02BAAC */
            g_color_033A = (uint8_t)cell;           /* @0x02BAB2 */
            overlay_call_191F_0774();               /* @0x02BAB9 near 0x7EAB */
        }
        if (g_popup_07E4 != 0) {                    /* @0x02BABC */
            if (g_int_mode_07F4 == 0) return 0;     /* @0x02BAC3 */
            overlay_call_191F_0934();               /* @0x02BACD highlight cell */
            overlay_call_191F_0684();               /* @0x02BAD6 near 0x7E3D */
            return 0;
        }
        overlay_call_191F_0594();                   /* @0x02BAE1 near 0x7ED8 (begin drop test) */
        overlay_call_191F_05F4();                   /* @0x02BAF2 near 0x7F05 begin drag */
        g_drag_active_A88C = 1;                     /* @0x02BAF8 */
        g_drag_id_A88D = (uint8_t)cell;             /* @0x02BB00 */
        {   int qty = CW(cell * 2 + 0x9A);          /* @0x02BB0C ctx->[+si+0x9A] */
            if (qty > 0x64) qty = 0x64;             /* @0x02BB10 */
            g_drag_qty_A88E = (uint8_t)qty;         /* @0x02BB18 */
            overlay_call_191F_05D0();               /* @0x02BB22 near 0x7DDE */
        }
        return 0;                                   /* @0x02BB28 */
    }

    if (g_screen_mode_8D54 == 0x0A) {               /* @0x02BB2C RENAMECOLONY */
        if (g_int_mode_07F4 == 0) return 0;         /* @0x02BB33 */
        overlay_call_191F_0120();                   /* @0x02BB4A edit_field(0x17,ctx+2,0x87C,0xD30)*/
        if (overlay_call_0D1D_0842() != 0) {        /* @0x02BB52 edit_buffer_dirty([0x9820])*/
            overlay_call_0D1D_07E4();               /* @0x02BB67 strcpy(ctx+2,[0x9820]) */
            overlay_call_191F_0774();               /* @0x02BB70 near 0x7EAB */
        }
        return 0;                                   /* @0x02BB73 */
    }

    if (g_screen_mode_8D54 == 9) {                  /* @0x02BB74 */
        if (g_int_mode_07F4 != 0) g_redraw_0346 = 0;/* @0x02BB7B/0x02BB82 */
    }
    return 0;                                       /* @0x02BB88 */
}

/* ============================================================================
 * func_02BB8A  — colony three-button RELEASE sampler (companion of func_02C546)
 * @asm        0x02BB8A..0x02BC71  (232 bytes)  ENTER 2  RETF
 * @asm_ref    page_02.asm "func_02BB8A size=232 insns=100"
 * @role       Reads input edges ([0x7EC]/[0x7F6]); two near 0x7E5B (= func_02CA4B
 *             trampoline -> 0x191F:0x6CC) sample button state; a chained range
 *             test vs [0x5384] selects which colony toggle changed and updates
 *             [0x8D54]/[0x8D56].  Pure UI state.
 * @status     BYTE_VERIFIED (flow + globals).
 *             0x191F:0x6CC = read_click_state(); returns 0=none, 1=down, 2=act
 *             (CONFIRMED: overlay_027BB6 @0x029DE4). Band-test body after 0x02BBC0
 *             is incomplete (logic not yet ported; structure confirmed).
 */
int func_02BB8A_logic_sz_106(void)
{
    if (g_flag_07EC == 0)                           /* @0x02BB8E */
        overlay_call_191F_06CC();                   /* @0x02BB9D near 0x7E5B sample */
    if (g_flag_07F6 != 0) {                         /* @0x02BBAF */
        overlay_call_191F_06CC();                   /* @0x02BBB7 sample again */
        /* @0x02BBC0 chained band test vs [0x5384] -> [0x8D54]/[0x8D56]; TBD. */
    }
    return 0;                                       /* @0x02BBF4 */
}

/* ============================================================================
 * func_02BC72  — COLONY-SCREEN command / keyboard DISPATCHER
 * @asm        0x02BC72..0x02C545  (2259 bytes)  ENTER 0x18  RETF
 * @asm_ref    page_02.asm "func_02BC72 size=2259 insns=848"
 * @role       arg0 (bp+6) = key / menu command code.  THE colony-view input
 *             router, three nested dispatch layers:
 *   (1) @0x02BC7C switch on the command code (0x4E,0x4D,0x2D,0x09,0x74,0x53,0x20,
 *       0x1B,...) — each opens a sub-action (jump targets 0x02C0AC..0x02C545).
 *   (2) @0x02BD08, gated by [0x5383]&0x20, switch on submode [0x32E] (0..4):
 *       0 = work-area cell (map [bx+si-0x7210]; unit @ 0x181F:0x78C; 0x191F:0x428);
 *       1 = building (0x181F:0xC54 -> 0x191F:0x8DE); 2 = unit-by-index
 *       (0x181F:0xB32); 3 = unit-by-cell (0x181F:0x92A, sound 0x191F:0x942);
 *       4 = [0x33A] sound (0x191F:0x934).
 *   (3) @0x02BDF4 function-key block: codes 0x13C..0x142 each call a per-key
 *       overlay op (0x191F:0x40C/0x3FE/0x3F0/0x3E2/0x3D4/0x3C6/0x3B8) passing the
 *       colony owner ctx->[0x1A].
 * @status     BYTE_VERIFIED (dispatch skeleton + command codes + ctx struct);
 *             per-key ops via 0x191F:0x3B8..0x40C documented as "per-key cmd op"
 *             in externs — individual sub-op logic lives in the 0x191F thunk layer.
 */
int func_02BC72_logic_sz_50(uint16_t arg0_bp_06)
{
    int cmd = (int16_t)arg0_bp_06;                  /* @asm 0x02BC7C */
    int handled = 1;                                /* [bp-0xE] @0x02BC77 */

    switch (cmd) {                                  /* (1) primary @0x02BC7F.. */
    case 0x4E: /* @0x02BC84 -> 0x02C13E */ break;
    case 0x4D: /* @0x02BC91 -> 0x02C116 */ break;
    case 0x2D: /* @0x02BC9D -> 0x02C170 */ break;
    case 0x09: /* @0x02BCB9 -> 0x02C0AC */ break;
    case 0x1B: g_redraw_0346 = 0; handled = 0; break; /* @0x02BCBA ESC-class */
    default:   /* @0x02BCC7 default */ break;
    }

    if ((g_b_5383 & 0x20) != 0) {                   /* (2) @0x02BCC2 */
        switch (g_submode_032E) {                   /* @0x02BD08 */
        case 0:                                     /* @0x02BD26 work-area cell */
            /* map [bx+si-0x7210] (from [0x332]/[0x330]); if != 0x10 act on the
             * unit at the colony tile (0x181F:0x78C) then 0x191F:0x428. */
            if (/* terrain != 0x10 */ 0) {          /* @0x02BD39 */
                overlay_call_181F_078C();           /* @0x02BD5B unit_at_cell */
                overlay_call_191F_0428();           /* @0x02BD64 unit_render */
            }
            overlay_call_191F_0684();               /* @0x02BD6D near 0x7E3D */
            break;
        case 1: {                                   /* @0x02BD84 building */
            int b = overlay_call_181F_0C54();       /* @0x02BD78 building_at([0x8D7C]) */
            if (b == 0x1C) b = 0x13;                /* @0x02BD83 */
            overlay_call_191F_08DE();               /* @0x02BD90 show_building_info(b) */
            break;
        }
        case 2: if (g_count_033C != 0) overlay_call_181F_0B32(); break; /* @0x02BD98 */
        case 3:                                     /* @0x02BDAE */
            if (g_w8D72 != 0) {
                overlay_call_181F_092A();           /* @0x02BDBC unit_at_xy */
                overlay_call_191F_0942();           /* @0x02BDCE sound(type) */
            }
            break;
        default: overlay_call_191F_0934(); break;   /* @0x02BDD6 [0x33A] */
        }
    }

    /* (3) function-key block @0x02BDF4: per-key op with ctx->[0x1A] owner. */
    if (cmd == 0x13C) overlay_call_191F_040C();     /* @0x02BDFA */
    if (cmd == 0x13D) overlay_call_191F_03FE();     /* @0x02BE03 */
    if (cmd == 0x13E) overlay_call_191F_03F0();     /* @0x02BE1C */
    if (cmd == 0x13F) overlay_call_191F_03E2();     /* @0x02BE35 */
    if (cmd == 0x140) overlay_call_191F_03D4();     /* @0x02BE4E */
    if (cmd == 0x141) overlay_call_191F_03C6();     /* @0x02BE67 */
    if (cmd == 0x142) overlay_call_191F_03B8();     /* @0x02BE80 */
    /* per-command bodies at 0x02C0AC..0x02C545 perform a single colony command
     * (rename/disband/fortify-all/sentry/etc.) using helpers already cited;
     * `handled` gates the [0x346] redraw request. */
    (void)handled;
    return 0;                                       /* @0x02C545 */
}

/* ============================================================================
 * func_02C546  — three colony toggle-button RELEASE/latch dispatcher
 * @asm        0x02C546..0x02C5D3  (141 bytes)  ENTER 6  RET (near, CS-local)
 * @asm_ref    page_02.asm "func_02C546 size=141 insns=48 terminal=RET"
 * @role       Called near (RET, not RETF) from func_02C5D4 (@0x02C91B).  Snapshots
 *             the three button-pressed bytes (0xB9B/0xB9D/0xB9F), clears them, runs
 *             a refresh (near 0x7E8D -> 0x191F:0x744); for each button now clear
 *             but previously set (falling edge) invokes its action trampoline
 *             (near 0x7D8E / 0x7E29 / 0x7DB1); buttons still clear get their
 *             companion code byte (0xB9A/0xB9C/0xB9E) set 0xFE.
 * @status     BYTE_VERIFIED.
 */
int func_02C546_logic_sz_141(void)
{
    uint8_t s0 = g_b_0B9B, s1 = g_b_0B9D, s2 = g_b_0B9F;  /* [bp-4]/[bp-6]/[bp-2] */

    g_b_0B9B = g_b_0B9D = g_b_0B9F = 0;             /* @0x02C55C */
    overlay_call_191F_0744();                       /* @0x02C568 near 0x7E8D refresh */

    if (g_b_0B9B == 0 && s0 != 0) overlay_call_191F_04E0(); /* @0x02C56B near 0x7D8E */
    if (g_b_0B9D == 0 && s1 != 0) overlay_call_191F_0654(); /* @0x02C581 near 0x7E29 */
    if (g_b_0B9F == 0 && s2 != 0) overlay_call_191F_0534(); /* @0x02C597 near 0x7DB1 */

    if (g_b_0B9B == 0) g_b_0B9A = 0xFE;             /* @0x02C5AD */
    if (g_b_0B9D == 0) g_b_0B9C = 0xFE;             /* @0x02C5B9 */
    if (g_b_0B9F == 0) g_b_0B9E = 0xFE;             /* @0x02C5C5 */
    return 0;                                       /* @0x02C5D1 ret (near) */
}

/* ============================================================================
 * func_02C5D4  — THE interactive COLONY SCREEN (open-colony dialog + event loop)
 * @asm        0x02C5D4..0x02C972  (1318 bytes; trailing trampoline table
 *             0x02C974..0x02CA82 = 5-byte JMPF 0x191F:off stubs belong to this
 *             page record).  ENTER 0x1A  terminal RETF @0x02C972.
 * @asm_ref    page_02.asm "func_02C5D4 size=1318 insns=373"
 * @role       arg0 (bp+6) = colony slot.  Opens the colony screen:
 *   @0x02C5D9 enter (0x191F:0x95E; 0x181F:0x56 palette; 0x181F:0xA6 clear 7,0x140).
 *   @0x02C5F9 get_colony_by_slot(arg0) -> *(0x8542); [0x8D7C]=0; draw base
 *             (0x181F:0xC72); [0x890]=1.  Draw prev/next neighbour backdrops
 *             (0x181F:0xBBE for [0x34A]); beep(0x54); 0x181F:0x3EA(8).
 *   @0x02C66F if [0xB98]!=0 quick-exit (0x181F:0x3C0) -> cleanup.
 *   @0x02C67E first-visit A (TUTORIAL4 0xD3D): pick a work tile, RENAMECOLONY edit
 *             from coords ctx->[0]/[1], find an empty ring tile ([bx+si+0x2F7B]),
 *             draw two label rows + boxed TUTORIAL4; set [0x5386]|=0x80.
 *   @0x02C74F first-visit B (TUTORIAL12 0xD47): if a defender of type 0xD..0x12 is
 *             present, draw the colony name + boxed TUTORIAL12; set [0x5387]|=0x80.
 *   @0x02C7C1 MAIN EVENT LOOP: [0x346]=1; ms_clock (far lcall 0xC0C:6) into
 *             [0x8D5A]; poll (0x181F:0x470/0x466); handle events (0x181F:0xF6 ->
 *             0xEC + 0x5B6(5)); region hits (near 0x7E47); throttle to 0x258 ms;
 *             palette flips (near 0x7EF6); CALL func_02C546 button releases
 *             (@0x02C91B); drain (0x181F:0x45C); loop while [0x346].
 *   @0x02C933 cleanup: near 0x7E01; 0x181F:0x56(0); if [0x348] redraw map
 *             (0x191F:0x254([0x8DC6])); [0x34E]=-1; [0x70]=0; 0x191F:0x96C;
 *             [0x890]=0; leave (0x181F:0x56A).
 * @status     BYTE_VERIFIED (full structure, ctx struct, strings TUTORIAL4/12, the
 *             far ms-clock 0xC0C:6, flags); individual draw/poll prims are LOW.
 */
int func_02C5D4_colony_sz_592(uint16_t arg0_bp_06)
{
    int tile_idx, empty;    /* [bp-0x12], [bp-2] */
    long t0, t1;            /* ms-clock samples */
    int u, found;

    overlay_call_191F_095E();                       /* @0x02C5D9 enter screen */
    overlay_call_181F_0056();                       /* @0x02C5E0 palette(0) */
    overlay_call_181F_00A6();                       /* @0x02C5F1 clear(7,0x140,0,0) */
    overlay_call_181F_09E6();                       /* @0x02C5FC get_colony_by_slot(arg0) */
    g_w8D7C = 0;                                     /* @0x02C604 */
    overlay_call_181F_0C72();                       /* @0x02C60A draw base */
    g_w0890 = 1;                                     /* @0x02C60F */
    overlay_call_191F_0774();                       /* @0x02C616 near 0x7EA1 */
    if (g_w034A >= 0) overlay_call_181F_0BBE();      /* @0x02C620 prev backdrop */
    overlay_call_191F_0510();                       /* @0x02C62F near 0x7DA2 */
    overlay_call_191F_0648();                       /* @0x02C635 near 0x7E24(1) */
    if (g_w034A >= 0) {                              /* @0x02C63B */
        overlay_call_181F_0BBE(); overlay_call_191F_0510(); /* @0x02C648 */
        overlay_call_191F_0648();                   /* @0x02C657 near 0x7E24(0) */
        overlay_call_181F_04C0(); overlay_call_181F_03EA(); /* @0x02C660/0x02C667 */
    }
    if (g_w0B98 != 0) { overlay_call_181F_03C0(); goto cleanup; } /* @0x02C66F/0x02C676 */

    /* --- first-visit block A (TUTORIAL4) ------------------------------------*/
    if ((g_b_5382 & 0x80) && !(g_b_5386 & 0x80)) {  /* @0x02C67E/0x02C688 */
        tile_idx = overlay_call_181F_0C0E();        /* @0x02C694 */
        if (tile_idx == 0xD) { tile_idx = 0x10; empty = 0; } /* @0x02C6A4 */
        else {
            overlay_call_181F_0D30();               /* @0x02C6C1 edit name (coords ctx[0]/[1])*/
            empty = overlay_call_181F_078C();       /* @0x02C6F6 unit_at_cell */
            /* @0x02C6F6..0x02C715 scan 8-ring table [bx+si+0x2F7B] for empty!=tile*/
        }
        overlay_call_181F_0438();                   /* @0x02C722 row 0 (work label) */
        overlay_call_181F_0438();                   /* @0x02C735 row 1 */
        overlay_call_181F_0652();                   /* @0x02C742 boxed "TUTORIAL4"(0xD3D)*/
        g_b_5386 |= 0x80;                           /* @0x02C74A */
    }

    /* --- first-visit block B (TUTORIAL12) -----------------------------------*/
    if ((g_b_5382 & 0x80) && !(g_b_5387 & 0x80)) {  /* @0x02C74F/0x02C756 */
        found = 0;
        overlay_call_181F_07E0();                   /* @0x02C76F iter_units_at(coords)*/
        while ((u = overlay_call_181F_02E4()) >= 0) {  /* @0x02C78C..0x02C796 */
            int ty = UREC_B(u * 0x1C + 0x02);       /* @0x02C779 +0x3146 type */
            if (ty >= 0xD && ty <= 0x12) found = 1; /* @0x02C779..0x02C785 */
        }
        if (found) {                                /* @0x02C798 */
            overlay_call_181F_0416();               /* @0x02C7A7 draw colony name(ctx+2)*/
            overlay_call_181F_0652();               /* @0x02C7B4 boxed "TUTORIAL12"(0xD47)*/
            g_b_5387 |= 0x80;                       /* @0x02C7BC */
        }
    }

    /* --- MAIN EVENT LOOP -----------------------------------------------------*/
    g_redraw_0346 = 1;                              /* @0x02C7C1 */
    t0 = overlay_call_0C0C_0006() + 0x14;           /* @0x02C7C7 ms_clock()+0x14 */
    g_w8D5A = (int16_t)t0; g_w8D5C = (int16_t)(t0 >> 16); /* @0x02C7D2 */
    overlay_call_181F_047A();                       /* @0x02C7D9 timer_arm */
    if (g_b_0828 == 0) goto loop_simple;            /* @0x02C7DE */

    do {                                            /* full loop ([0x828] set) */
        t1 = overlay_call_0C0C_0006();              /* @0x02C7F5 */
        overlay_call_181F_0470(); overlay_call_181F_0466(); /* @0x02C800/0x02C807 */
        if (g_int_mode_07F4 == 0 && overlay_call_181F_00F6() != 0) { /* @0x02C80C */
            overlay_call_181F_00EC(); overlay_call_181F_05B6(); /* @0x02C80C/0x02C813 */
            g_redraw_0346 = 0; g_w53C2 = 0;         /* @0x02C81B */
        }
        overlay_call_181F_045C();                   /* @0x02C829 drain */
        { long now = overlay_call_0C0C_0006();      /* @0x02C82E */
          if (now - t1 >= 0x258) g_redraw_0346 = 0; } /* @0x02C845 throttle */
    } while (g_redraw_0346 != 0);                   /* @0x02C850 */
    goto cleanup;                                   /* @0x02C857 */

loop_simple: /* @0x02C85C */
    do {
        overlay_call_181F_0470(); overlay_call_181F_0466(); /* @0x02C85C/0x02C863 */
        t1 = overlay_call_0C0C_0006();              /* @0x02C868 */
        if (g_flag_07EC != 0) {                     /* @0x02C873 */
            g_w8D5E = (int16_t)(t1 + 8); g_w8D60 = (int16_t)((t1 + 8) >> 16);
            g_w8D58 = 1;                            /* @0x02C887 */
        }
        if (((long)(uint16_t)g_w8D5A | ((long)g_w8D5C << 16)) <= t1) /* @0x02C88D */
            overlay_call_191F_069C();               /* @0x02C8A1 near 0x7E47 */
        if (overlay_call_181F_00F6() != 0) {        /* @0x02C8B7 */
            overlay_call_181F_03E0();               /* @0x02C8C0 event payload */
            if (g_w0334 != 0) overlay_call_191F_069C(); /* @0x02C8C8 */
            overlay_call_191F_05D0();               /* @0x02C8D7 near 0x7DF2 */
        }
        if (g_w0344 != 0 && g_flag_07EE == 0)       /* @0x02C8DD/0x02C8E4 */
            overlay_call_191F_05F4();               /* @0x02C8EC near 0x7E01 */
        if (g_flag_07EC != 0) { overlay_call_181F_0056(); overlay_call_191F_0840(); } /*@0x02C8F4*/
        if (overlay_call_181F_009C() != 0) overlay_call_191F_0840(); /* @0x02C909 */
        func_02C546_logic_sz_141();                 /* @0x02C91B button releases */
        overlay_call_181F_045C();                   /* @0x02C924 drain */
    } while (g_redraw_0346 != 0);                   /* @0x02C929 */

cleanup: /* @0x02C933 */
    overlay_call_191F_05F4();                       /* @0x02C934 near 0x7E01 */
    overlay_call_181F_0056();                       /* @0x02C939 palette(0) */
    if (g_w0348 != 0) overlay_call_191F_0254();     /* @0x02C941 redraw_map([0x8DC6]) */
    g_w034E = (int16_t)0xFFFF;                      /* @0x02C954 */
    g_w0070 = 0;                                    /* @0x02C95A */
    overlay_call_191F_096C();                       /* @0x02C960 */
    g_w0890 = 0;                                    /* @0x02C965 */
    overlay_call_181F_056A();                       /* @0x02C96B leave screen */
    return 0;                                       /* @0x02C972 retf */
}

/* ============================================================================
 * func_02CFD0  — colony TILE right-click context popup
 * @asm        0x02CFD0..0x02D0E1  (274 bytes)  ENTER 8  RETF  touches *(0x8542)
 * @asm_ref    page_03.asm "func_02CFD0 size=274 insns=91"
 * @role       7 args (bp+6..bp+0x12).  Gated by [0xA897] (human).  If at the
 *             colony's own tile ([0x890]==0 && bp+0xC==0) substitutes the colony
 *             coords (ctx->[0]/[1] -> bp+0xC/+0xE).  Highlights the tile
 *             (0x181F:0x352), draws the name (0x181F:0x416 from ctx+2), opens a
 *             popup (0x191F:0x182), conditionally adds "<...>"([0x2DFE]) and
 *             "ONE_LEAVE"([0x2E00]=0xBDF) rows; runs it (0x191F:0x16A); if item 2
 *             picked and bp+0xA>=0 stores it into [0x337].  Returns picked flag.
 * @status     BYTE_VERIFIED (flow + ctx struct + string "ONE_LEAVE"); prims LOW.
 */
int func_02CFD0_colony_sz_274(uint16_t arg0_bp_06, uint16_t arg1_bp_08,
        uint16_t arg2_bp_0A, uint16_t arg3_bp_0C, uint16_t arg4_bp_0E,
        uint16_t arg5_bp_10, uint16_t arg6_bp_12)
{
    int picked = 0;         /* [bp-8] @asm 0x02CFD4 */
    int cx = (int16_t)arg3_bp_0C, cy = (int16_t)arg4_bp_0E;

    if (g_human_gate_A897 == 0) goto done;          /* @0x02CFE1 */
    if (g_w0890 == 0 && cx == 0) {                  /* @0x02CFEB/0x02CFF1 */
        cx = CB(0x00); cy = CB(0x01);               /* @0x02CFF6 ctx coords */
    }
    overlay_call_181F_0352();                       /* @0x02D015 highlight_tile(cx,cy,cx,cy,0)*/
    overlay_call_181F_0416();                       /* @0x02D026 draw name(ctx+2) */
    g_w1F5E = (int16_t)arg5_bp_10;                  /* @0x02D031 */
    if (overlay_call_191F_0182() == 0) goto done;   /* @0x02D034 open_list_dialog(0x87C,arg0)*/
    if (arg1_bp_08 != 0 && g_w0890 == 0) {          /* @0x02D04C/0x02D052 */
        overlay_call_181F_0022(); overlay_call_191F_0176(); /* @0x02D05F item1 [0x2DFE]*/
        overlay_call_181F_0022(); overlay_call_191F_0176(); /* @0x02D07D "ONE_LEAVE" [0x2E00]*/
    }
    if ((int16_t)arg6_bp_12 > 0) overlay_call_181F_04C0(); /* @0x02D095/0x02D09E beep */
    if (overlay_call_191F_016A() == 2) {            /* @0x02D0A9 picked item 2 */
        picked = 1;                                 /* @0x02D0B3 */
        if ((int16_t)arg2_bp_0A >= 0)               /* @0x02D0B8 */
            g_player_0337 = (uint8_t)arg2_bp_0A;    /* @0x02D0C1 */
    }
done: /* @0x02D0C4 */
    g_w1F5E = (int16_t)0xFFFF;                       /* @0x02D0C4 */
    if (/* handle */ 0) overlay_call_191F_01A8();   /* @0x02D0D2 close */
    return picked;                                   /* @0x02D0DD al */
}

/* ============================================================================
 * func_02D0E4  — colony BUILDING / structure CLICK handler (build & upgrade)
 * @asm        0x02D0E4..0x02D307  (549 bytes)  ENTER 0x0A  RETF  touches *(0x8542)
 * @asm_ref    page_03.asm "func_02D0E4 size=549 insns=200"
 * @role       Looks up the clicked structure (0x181F:0xCC2 with worker ctx->[0x94])
 *             and acts:
 *   class 1 @0x02D111: unit-bearing structure (0x181F:0x9FC) -> exit.
 *   bldg 0x10 (warehouse) @0x02D123: if ctx->[0x95]>=2 show "NOMOREWAREHOUSE"
 *             (0xD52 via near 0x245F); else ++ctx->[0x95], set ctx->[0x1C]|0x80.
 *   bldg 0xF/0x10 @0x02D156: ++ctx->[0x95] (and ctx->[0x1C]|0x80 for 0x10).
 *   bldg 0x1E/0x1F (wagon/ship) @0x02D178: ++ctx->[0x96]; 0x1F shows
 *             "NOMOREWAGONS"(0xD62) when capped.
 *   bldg 0xC (custom house) @0x02D1B3: gated by FF-bit (PowerRecord[owner].byte
 *             [-0x6D68] vs threshold table [owner*0x13 -0x6DA8]).
 *   otherwise @0x02D20C: place worker — 0x181F:0x95C; ++ per-(colony,building)
 *             tally [bx+si-0x6DB4] (si=owner*0x13); building 0xB also bumps
 *             PowerRecord+? ([owner*0x13C -0x77B0]) gated by [0x543F+owner*0x34];
 *             ctx->[0x92]=0; draw "BUILT"(0xD6F); record last build [0x34A];
 *             redraw (0x191F:0x5E8) if [0x346].
 * @status     BYTE_VERIFIED (flow + ctx/PowerRecord struct + strings WAREHOUSE/
 *             WAGONS/BUILT + 0x13C); the 0x245F load-image body lives elsewhere.
 */
int func_02D0E4_colony_sz_23(void)
{
    int building;           /* [bp-8] (out of unit_class) */
    int klass;              /* [bp-2] @asm 0x02D0FF */
    int owner;

    klass = overlay_call_181F_0CC2();               /* @0x02D0F7 unit_class(&building,ctx->[0x94])*/
    if (klass == 0) goto redraw;                    /* @0x02D102 */
    if (klass == 1 && overlay_call_181F_09FC() != 0) goto redraw; /* @0x02D111 */

    if (building == 0x10 && CB(0x95) >= 2) {        /* @0x02D123 warehouse cap */
        g_msg_toggle_A898 |= loadimg_msgbox();      /* @0x02D149 "NOMOREWAREHOUSE"(0xD52)*/
        return 0;                                   /* @0x02D153 */
    }
    if (building == 0xF || building == 0x10) {      /* @0x02D156 */
        CB(0x95)++;                                  /* @0x02D166 */
        if (building == 0x10) CB(0x1C) |= 0x80;      /* @0x02D170 */
        goto place;                                 /* @0x02D174 */
    }
    if (building == 0x1E || building == 0x1F) {     /* @0x02D178 wagon/ship */
        CB(0x96)++;                                  /* @0x02D188 */
        if (building == 0x1F) goto place;           /* @0x02D18C */
    }
    overlay_call_181F_0BBE();                       /* @0x02D19A backdrop add(1,building) */
    CB(0x1C) |= 0x80;                                /* @0x02D1A6 */
    if (klass != 2) goto place;                     /* @0x02D1AA */

    if (building == 0xC) {                          /* @0x02D1B3 custom house FF gate */
        owner = CB(0x1A);
        if (UREC_B(owner - 0x6D68) >= UREC_B(owner * 0x13 - 0x6DA8)) { /* @0x02D1C9 */
            overlay_call_181F_09AE();               /* @0x02D1D6 */
            g_msg_toggle_A898 |= loadimg_msgbox();  /* @0x02D1F6 "NOMOREWAGONS"(0xD62) */
            CB(0x1C) |= 0x80;                        /* @0x02D204 */
            return 0;                               /* @0x02D208 */
        }
    }

place: /* @0x02D20C */
    owner = CB(0x1A);
    overlay_call_181F_095C();                       /* @0x02D224 place worker(coords,owner,building)*/
    /* @0x02D240 ++ per-(building,owner) tally [bx+si-0x6DB4], si=owner*0x13. */
    UREC_B(building + owner * 0x13 - 0x6DB4)++;      /* (colony tally array) */
    if (building == 0x0B && owner < 4 &&            /* @0x02D244/0x02D249 */
        g_power_ctrl[owner * 0x34] == 0)            /* @0x02D251 [0x543F] */
        UREC_B(owner * 0x13C - 0x77B0)++;           /* @0x02D260 PowerRecord bump */
    CW(0x92) = 0;                                    /* @0x02D26C ctx->[0x92]=0 */
    overlay_call_181F_0416();                       /* @0x02D284 draw def label */
    if (g_human_gate_A897 != 0) {                   /* @0x02D28C */
        overlay_call_181F_04B6();                   /* @0x02D2B8 draw_label(2 or 3) */
        g_msg_toggle_A898 |= loadimg_msgbox();      /* @0x02D2D8 "BUILT"(0xD6F) */
        if (!(klass == 1 && (building == 0x10 || building == 0x1F))) /* @0x02D2E2 */
            g_w034A = building;                     /* @0x02D2F4 record last build */
    }
redraw: /* @0x02D2FA */
    if (g_redraw_0346 != 0) overlay_call_191F_05E8();  /* @0x02D2FA request_redraw */
    return 0;                                       /* @0x02D306 */
}

/* ============================================================================
 * func_02D30A  — scan colony's 8-tile ring for resource DEPLETION
 * @asm        0x02D30A..0x02D3C5  (188 bytes)  ENTER 0x0E  RETF  touches *(0x8542)
 * @asm_ref    page_03.asm "func_02D30A size=188 insns=71"
 * @role       Nested 5x6 sweep over the colony's surrounding cells: for each
 *             (dx,dy) query the cell (0x181F:0xCE0); if its terrain class
 *             (0x181F:0xC0E) == 6 or 7 (resource-bearing), map to absolute coords
 *             from ctx->[0]/[1], re-check the feature (0x181F:0x718 == 0xC or 6),
 *             and on depletion change the tile (0x181F:0x68C) + show "DEPLETION"
 *             (0xD75 via near 0x245F).
 * @status     BYTE_VERIFIED (flow + ctx struct + string "DEPLETION").
 */
int func_02D30A_colony_dispatch_188(void)
{
    int dy, dx, ax_, ay_;   /* [bp-0xA]/[bp-8]/[bp-4]/[bp-2] */

    for (dy = 0; dy < 5; dy++) {                    /* @0x02D3B5..0x02D3B9 */
        for (dx = 0; dx <= 5; dx++) {               /* @0x02D316..0x02D31D */
            int cell = overlay_call_181F_0CE0();    /* @0x02D328 ring_cell(dx,dy) */
            if (cell < 0) continue;                 /* @0x02D333 */
            int t = overlay_call_181F_0C0E();       /* @0x02D336 terrain_class(cell) */
            if (t != 7 && t != 6) continue;         /* @0x02D33E/0x02D343 */
            ax_ = CB(0x01) + dy - 2;                /* @0x02D348 ctx->[1] + dy - 2 */
            ay_ = CB(0x00) + dx - 2;                /* @0x02D35A ctx->[0] + dx - 2 */
            { int f = overlay_call_181F_0718();     /* @0x02D367 feature_at(ay,ax) */
              if (f != 0xC && f != 6) continue; }   /* @0x02D36F/0x02D374 */
            overlay_call_181F_068C();               /* @0x02D383 set_map_tile(1,4,ax,ay) */
            g_msg_toggle_A898 |= loadimg_msgbox();  /* @0x02D3A5 "DEPLETION"(0xD75) */
        }
    }
    return 0;                                       /* @0x02D3C4 */
}

/* ============================================================================
 * func_02D3C6  — colony FORT FIRE / surrounding-unit interaction ("FORTFIRE")
 * @asm        0x02D3C6..0x02D605  (575 bytes)  ENTER 0x1A  RETF  touches *(0x8542)
 * @asm_ref    page_03.asm "func_02D3C6 size=575 insns=197"
 * @role       STRING-XREF "FORTFIRE"(0xD7F @0x02D5D9).  The coastal-fortress firing
 *             routine: counts adjacent forts (0x181F:0x9FC slot 1 & 2 -> bonus
 *             words [0x8F8E]/[0x8F9A]); iterates units at the colony tile
 *             (0x181F:0x7E0/0x2E4), counting cannon-class (type 0xB) into `mult`;
 *             firepower = mult * defenders * 4 (@0x02D441).  For each of 8 attack
 *             offsets ([bx+0xBE]/[bx+0xB4] dx/dy) targets the adjacent tile
 *             (0x181F:0x768), reads the target's terrain/owner nibble (UnitRecord
 *             +0x3 0x3147 & 0xF), checks diplomacy (0x181F:0xA38 bit 0x40), draws
 *             the firing message (unit name table [bx+0x5230] + boxed FORTFIRE),
 *             and resolves the strike via the LAND-COMBAT DECIDER chain 0x191F:0xA14
 *             (= func_0270D0+0x33E, documented in src/combat/land.c) + 0x191F:0xA06.
 *             Sets combat scratch [0x537D]/[0x5372]/[0x5376].
 * @status     BYTE_VERIFIED (flow + UnitRecord/PowerRecord struct + string +
 *             decider-chain target); the decider's land-odds FORMULA is TBD (it
 *             lives in src/combat/land.c and is itself flagged TBD there).
 */
int func_02D3C6_colony_op_3calls(void)
{
    int defenders = 0;      /* [bp-0xA] @asm 0x02D3CB */
    int mult = 1;           /* [bp-0x10] */
    int bonus = 0;          /* [bp-0x16] */
    int firepower, u, d;    /* [bp-0x18] current unit / [bp-0xC] offset */

    if (overlay_call_181F_09FC() != 0) {            /* @0x02D3D6 fort present */
        defenders = 1; bonus = g_w8F8E;             /* @0x02D3E3/0x02D3E8 */
    }
    if (overlay_call_181F_09FC() != 0) {            /* @0x02D3EE upgraded fort */
        defenders++; bonus = g_w8F9A;               /* @0x02D3FC/0x02D3FF */
    }

    overlay_call_181F_07E0();                       /* @0x02D420 iter units at (ctx[0],ctx[1])*/
    while ((u = overlay_call_181F_02E4()) >= 0) {   /* @0x02D435..0x02D43F */
        if (UREC_B(u * 0x1C + 0x02) == 0xB) mult++; /* @0x02D428 +0x3146 cannon */
    }
    firepower = (mult * defenders) << 2;            /* @0x02D441 *4 */
    if (firepower == 0) goto done;                  /* @0x02D44F */

    for (d = 0; d < 8; d++) {                        /* @0x02D454..0x02D48A */
        for (;;) {                                  /* @0x02D459 next combat unit */
            int ty = UREC_B(u * 0x1C + 0x02);       /* @0x02D45C */
            if (ty >= 0xD && ty <= 0x12) break;
            u = overlay_call_181F_02E4();           /* @0x02D471 */
            if (u < 0) break;
        }
        if (u < 0) break;                           /* @0x02D47D */
        if (overlay_call_181F_0768() == 0) continue;/* @0x02D4AA tile_has_target */
        overlay_call_181F_07E0();                   /* @0x02D4BC re-iter target tile */
        if ((UREC_B(u * 0x1C + 0x03) & 0xF) == bonus) continue; /* @0x02D4C8/0x02D4D2 same side*/
        overlay_call_181F_0A38();                   /* @0x02D4DB diplomacy bit 0x40 */
        if (UREC_B(u * 0x1C + 0x02) != 0x10) {      /* @0x02D4E7/0x02D4EB */
            overlay_call_181F_0438();               /* @0x02D512 unit name (table [bx+0x5230])*/
            overlay_call_181F_0970();               /* @0x02D524 combat overlay([0x5396],..)*/
            overlay_call_181F_0352();               /* @0x02D59B highlight */
            overlay_call_181F_0438();               /* @0x02D5A8 */
            overlay_call_181F_0416();               /* @0x02D5B9 colony name */
            overlay_call_181F_0652();               /* @0x02D5DC boxed "FORTFIRE"(0xD7F) */
        }
        g_b_537D = (uint8_t)firepower;              /* @0x02D56F combat scratch */
        g_w5372  = bonus;                           /* @0x02D577 */
        g_b_5376 = 8;                               /* @0x02D57A */
        overlay_call_191F_0A14();                   /* @0x02D5F2 land_combat_decide (func_0270D0+0x33E)*/
        overlay_call_191F_0A06();                   /* @0x02D5FA land_combat_apply */
    }
done: /* @0x02D602 */
    return 0;                                       /* @0x02D604 */
}

/* ============================================================================
 * func_02D606  — command-ENABLED predicate for a colony command code
 * @asm        0x02D606..0x02D657  (81 bytes)  ENTER 2  RETF
 * @asm_ref    page_03.asm "func_02D606 size=81 insns=27"
 * @role       arg0 (bp+6) = command code.  Returns 1 unless the code is in
 *             {0,5,6,8,0xE,0xF}; for code 6 also requires 0x181F:0x9FC(3)==0 and
 *             [0x8DE4]==0 && [0x8DE6]==0 (a structure/queue empty).  Greys out
 *             menu items.
 * @status     BYTE_VERIFIED.
 */
int func_02D606_op_sz_81(uint16_t arg0_bp_06)
{
    int cmd = (int16_t)arg0_bp_06;
    int enabled = 0;        /* [bp-2] @asm 0x02D60A */

    if (cmd == 0 || cmd == 5 || cmd == 8 || cmd == 0xE || cmd == 0xF) goto ret; /* @0x02D60F.. */
    if (cmd != 6) { enabled = 1; goto ret; }        /* @0x02D62D */
    if (overlay_call_181F_09FC() != 0) goto ret;    /* @0x02D635 structure 3 present */
    if (g_w8DE4 != 0 || g_w8DE6 != 0) goto ret;     /* @0x02D641/0x02D647 */
    enabled = 1;                                    /* @0x02D64D */
ret: /* @0x02D652 */
    return enabled;                                 /* al */
}

/* ============================================================================
 * func_02D658  — SUPERSEDED  (file 0x02D658..0x02EABB, 5220 bytes)
 * The full per-colony Sons-of-Liberty / Tory%, colonist-training, food-band and
 * per-commodity turn-end handler is BYTE_VERIFIED-ported in:
 *     -> src/colony/sol_tory.c   (colony_sol_tory_turn)
 * Not duplicated here; this stub marks the offset as relocated.
 * @status     SUPERSEDED -> src/colony/sol_tory.c
 * ============================================================================ */

/* ============================================================================
 * func_02EABC  — open colony screen WRAPPER A (ends in 0x191F:0x54C)
 * @asm        0x02EABC..0x02EAE9  (46 bytes)  ENTER 4  RETF
 * @asm_ref    page_03.asm "func_02EABC size=46 insns=14"
 * @role       get_colony_by_slot(arg0); draw base (0x181F:0xC72,0xC22); a sub-view
 *             handle r = 0x181F:0xC4A(0,arg1); finish via 0x191F:0x54C(r).
 * @status     BYTE_VERIFIED.
 */
int func_02EABC_op_sz_46(uint16_t arg0_bp_06, uint16_t arg1_bp_08)
{
    overlay_call_181F_09E6();                       /* @0x02EAC3 get_colony_by_slot(arg0) */
    overlay_call_181F_0C72();                       /* @0x02EACB */
    overlay_call_181F_0C22();                       /* @0x02EAD0 */
    overlay_call_181F_0C4A();                       /* @0x02EADA sub_view(0,arg1) */
    overlay_call_191F_054C();                       /* @0x02EAE3 */
    return 0;                                       /* @0x02EAE8 */
}

/* ============================================================================
 * func_02EAEA  — open colony screen WRAPPER B (ends in 0x181F:0xC36)
 * @asm        0x02EAEA..0x02EB1B  (49 bytes)  ENTER 4  RETF
 * @asm_ref    page_03.asm "func_02EAEA size=49 insns=15"
 * @role       Same preamble as func_02EABC; terminal op is 0x181F:0xC36(r);
 *             returns r ([bp-4]).
 * @status     BYTE_VERIFIED.
 */
int func_02EAEA_op_sz_49(uint16_t arg0_bp_06, uint16_t arg1_bp_08)
{
    int r;                  /* [bp-4] @asm 0x02EB16 */
    overlay_call_181F_09E6();                       /* @0x02EAF1 */
    overlay_call_181F_0C72();                       /* @0x02EAF9 */
    overlay_call_181F_0C22();                       /* @0x02EAFE */
    r = overlay_call_181F_0C4A();                   /* @0x02EB08 sub_view(0,arg1) */
    overlay_call_181F_0C36();                       /* @0x02EB11 finish_view(r) */
    return r;                                       /* @0x02EB19 */
}

/* ============================================================================
 * func_02EB1C  — record per-power CONTACT/visibility with a colony
 * @asm        0x02EB1C..0x02EB45  (42 bytes)  PUSH BP/MOV BP,SP  RETF
 * @asm_ref    page_03.asm "func_02EB1C size=42 insns=16"
 * @role       args (bp+6 = colony_id, bp+8 = power).  ColonyRecord[id] via imul
 *             0xCA: copies the colony's owner field +0x1F (byte at 0x5D65) into the
 *             per-power contact array [id*0xCA + power + 0x5E00]; then
 *             0x181F:0xB14(0, colony_id) -> low byte into [...+0x5E04].  Marks
 *             "power now sees colony id".
 * @status     BYTE_VERIFIED (struct + arrays; 0x5E00/0x5E04 are colony-table-
 *             adjacent contact maps).
 */
int func_02EB1C_logic_sz_10(uint16_t arg0_bp_06, uint16_t arg1_bp_08)
{
    int cid = (int16_t)arg0_bp_06;
    int pw  = (int16_t)arg1_bp_08;
    uint8_t owner = COLREC_B(cid * 0xCA + 0x5D65);  /* @0x02EB20/0x02EB25 ColonyRecord+0x1F*/
    COLREC_B(cid * 0xCA + pw + 0x5E00) = owner;     /* @0x02EB2C contact[cid][pw] */
    COLREC_B(cid * 0xCA + pw + 0x5E04) =            /* @0x02EB3F */
        (uint8_t)overlay_call_181F_0B14();          /* @0x02EB37 contact_query(0,cid) */
    return 0;                                       /* @0x02EB43 */
}

/* ============================================================================
 * func_02EB46  — predicate: colony OWNED-BY / CONTACTED-BY power?  (= 0x181F:0x302)
 * @asm        0x02EB46..0x02EB77  (49 bytes)  PUSH BP/MOV BP,SP  RETF
 * @asm_ref    page_03.asm "func_02EB46 size=49 insns=22"
 * @role       args (bp+6 = colony_id, bp+8 = power).  Returns 1 if owner byte +0x1A
 *             (abs 0x5D60) == power, OR ([0x53A2]==0 AND contact byte [id*0xCA +
 *             power + 0x5E00] != 0); else 0.  This IS the engine-wide
 *             "predicate (returns 0/1)" thunk 0x181F:0x302 (e.g. func_02EF64).
 * @status     BYTE_VERIFIED.
 */
int func_02EB46_logic_sz_13(uint16_t arg0_bp_06, uint16_t arg1_bp_08)
{
    int cid = (int16_t)arg0_bp_06;
    uint8_t pw = (uint8_t)arg1_bp_08;
    if (COLREC_B(cid * 0xCA + 0x5D60) == pw) return 1;  /* @0x02EB52 owner +0x1A */
    if (g_w53A2 != 0) return 0;                     /* @0x02EB58 god/fog flag */
    if (COLREC_B(cid * 0xCA + pw + 0x5E00) != 0) return 1; /* @0x02EB64 contact */
    return 0;                                       /* @0x02EB72 */
}

/* ============================================================================
 * func_02EB78  — FOUND / CREATE COLONY  ("TOOMANYCOLONIES" guard + full init)
 * @asm        0x02EB78..0x02EE33  (699 bytes)  ENTER 0x0A  RETF  touches *(0x8542)
 * @asm_ref    page_03.asm "func_02EB78 size=699 insns=221"
 * @role       args (bp+6 = power, bp+8 = x, bp+0xA = y, bp+0xC = building hint).
 *             Allocates and initialises a new ColonyRecord:
 *   @0x02EB82 if total colonies [0x539E] >= 0x30 (or this power already capped),
 *             show "TOOMANYCOLONIES"(0xED1 via 0x181F:0x3FE) and return -1.
 *   @0x02EBB0 ++ per-power colony count [power-0x6D68]; new slot = [0x539E]++.
 *   @0x02EBC2 get_colony_by_slot(slot) -> *(0x8542); mark map tile owned
 *             (0x181F:0x740 -> es:[bx] |= 2).
 *   @0x02EBE0 set owner ctx->[0x1A]=power, coords ctx->[0]=x ctx->[1]=y; zero the
 *             status bytes (+0x1B/+0x1C/+0x1D/+0x95/+0x96/+0x97/+0x8C/+0x8E/+0x8F/
 *             +0x1F), +0x90=0, +0x8D=0xFF (no active unit), +0xC6=0x64 (SoL bell
 *             accumulator = 100), +0xC8/+0xC4/+0xC2/+0x92/+0x98 = 0.
 *   @0x02EC3C memset name buf +0x8A; seed STARTING BUILDINGS via 0x181F:0xD26 for
 *             codes {1,2,3,4,6,7,9,0xA,0xB,0xC}.
 *   @0x02ECCC memset +0x84(6), work map +0x9A(0x20), commodity array +0x70(0x14,
 *             fill -1).  @0x02ED22 register the building hint if >=0.
 *   @0x02ED42 set neighbour ColonyRecord+0x1F (0x5D65)=1; redraw base; init the 4
 *             work-tile slots +0xBA/+0xBE honouring the resource mask
 *             (0x181F:0x74A); ctx->[0x94]=0xF (or 6 if ctx->[0x1C] bit 0x40 = river);
 *   @0x02EDC1 if a special site (0x181F:0xD12) set neighbour +0x5D62|0x40; play
 *             the founding music for 4 powers (0x181F:0x7B4/0x7AA).  Returns slot.
 * @status     BYTE_VERIFIED (full init + ctx fields + string "TOOMANYCOLONIES" +
 *             starting-building codes; helper roles documented in externs above).
 */
int func_02EB78_text_sz_55(uint16_t arg0_bp_06, uint16_t arg1_bp_08,
                           uint16_t arg2_bp_0A, uint16_t arg3_bp_0C)
{
    int power = (int16_t)arg0_bp_06;
    int x = (int16_t)arg1_bp_08, y = (int16_t)arg2_bp_0A, hint = (int16_t)arg3_bp_0C;
    int slot = -1;                                  /* [bp-4] @asm 0x02EB7D */
    int i;                                          /* [bp-6] */
    static const int start_bldg[] = {1,2,3,4,6,7,9,0xA,0xB,0xC};

    if (g_colony_count_539E >= 0x30) {              /* @0x02EB82 capacity guard */
        if (power >= 4 || g_power_ctrl[power * 0x34] != 0) { /* @0x02EB89/0x02EB92 */
            overlay_call_181F_03FE();               /* @0x02EBA4 "TOOMANYCOLONIES"(0xED1)*/
            return slot;                            /* @0x02EBA9 -1 */
        }
    }

    UREC_B(power - 0x6D68)++;                        /* @0x02EBB3 per-power count [power-0x6D68]*/
    slot = g_colony_count_539E++;                   /* @0x02EBB7 [0x539E]++ */
    overlay_call_181F_09E6();                       /* @0x02EBC2 get_colony_by_slot(slot) */
    overlay_call_181F_0740();                       /* @0x02EBD0 map tile -> es:[bx]|=2 */

    CB(0x1A) = (uint8_t)power;                       /* @0x02EBE7 owner */
    CB(0x00) = (uint8_t)x; CB(0x01) = (uint8_t)y;    /* @0x02EBED/0x02EBF2 coords */
    CB(0x1B) = 0; CB(0x1C) = 0; CB(0x1D) = 0;        /* @0x02EBF7/0x02EBFA/0x02EBFD */
    CB(0x95) = 0; CB(0x96) = 0; CB(0x97) = 0;        /* @0x02EC00/0x02EC04/0x02EC08 */
    CW(0x90) = 0; CB(0x8D) = 0xFF;                   /* @0x02EC0C/0x02EC12 */
    CB(0x1F) = 0; CB(0x8C) = 0; CB(0x8E) = 0; CB(0x8F) = 0; /* @0x02EC17.. */
    CW(0xC6) = 0x64;                                 /* @0x02EC26 SoL bell accum = 100 */
    CW(0xC8) = 0; CW(0xC4) = 0; CW(0xC2) = 0;        /* @0x02EC2C/0x02EC34/0x02EC38 */
    CW(0x92) = 0; CW(0x98) = 0;                      /* @0x02EC3E/0x02EC42 */

    overlay_call_0D1D_0DAE();                       /* @0x02EC4C memset(ctx+0x8A,0,2) */
    for (i = 0; i < 10; i++)                         /* @0x02EC54..0x02ECC4 */
        overlay_call_181F_0D26();                   /* seed_building(1, start_bldg[i]) */

    overlay_call_0D1D_0DAE();                       /* @0x02ECCC memset(ctx+0x84,0,6) */
    overlay_call_181F_0BBE();                       /* @0x02ECDF backdrop(1,0x23) */
    overlay_call_181F_0BBE();                       /* @0x02ECED backdrop(1,9) */
    overlay_call_181F_0C22();                       /* @0x02ECF7 */
    overlay_call_0D1D_0DAE();                       /* @0x02ED00 memset(ctx+0x9A,0,0x20) work map*/
    overlay_call_0D1D_0DAE();                       /* @0x02ED0F memset(ctx+0x70,0xFF,0x14) */

    if (hint >= 0) {                                /* @0x02ED22 */
        int b = overlay_call_181F_0C4A();           /* @0x02ED2B sub_view(hint) */
        if (b >= 0) overlay_call_181F_0C36();       /* @0x02ED3A */
    }
    COLREC_B(slot * 0xCA + 0x5D65) = 1;             /* @0x02ED47 neighbour flag +0x1F */
    overlay_call_181F_0C36();                       /* @0x02ED50 */
    overlay_call_181F_0CAE();                       /* @0x02ED5C */
    overlay_call_181F_0C72(); overlay_call_181F_0C22(); /* @0x02ED64/0x02ED69 */

    for (i = 0; i < 4; i++) {                       /* @0x02ED73..0x02EDB9 work slots */
        CB(i + 0xBA) = 1; CB(i + 0xBE) = 0;          /* @0x02ED7A/0x02ED7F */
        if (overlay_call_181F_074A() & (0x10 << i)) /* @0x02ED90 resource mask */
            CB(i + 0xBA) = 1;                        /* @0x02EDAD */
    }
    if (overlay_call_181F_0D12() != 0) {            /* @0x02EDC1 special site */
        if ((overlay_call_181F_06B4() & 0xFF) == 1) /* @0x02EDD5 site_query([0x8DBA],[0x8DBC])*/
            COLREC_B(slot * 0xCA + 0x5D62) |= 0x40; /* @0x02EDE6 neighbour +0x1C bit 0x40*/
    }
    CB(0x94) = 0xF;                                  /* @0x02EDEB worked tile = 0xF */
    if (CB(0x1C) & 0x40) CB(0x94) = 6;               /* @0x02EDF4/0x02EDFA on river */
    for (i = 0; i < 4; i++) {                        /* @0x02EDFF..0x02EE2B founding music*/
        if (overlay_call_181F_07B4() != 0)          /* @0x02EE06 music_query(6,i) */
            overlay_call_181F_07AA();               /* @0x02EE1C play([0x8DC6],i) */
    }
    return slot;                                     /* @0x02EE2D */
}

/* ============================================================================
 * func_02EE34  — DESTROY / ABANDON COLONY (compact table + fix unit refs)
 * @asm        0x02EE34..0x02EF45  (304 bytes; tail JMP @0x02EF40, then trampoline
 *             table 0x02EF46..0x02EF63)  ENTER 8  touches *(0x8542)
 * @asm_ref    page_03.asm "func_02EE34 size=304 insns=104"
 * @role       arg0 (bp+6 = colony_id).  Removes a colony:
 *   @0x02EE3A ColonyRecord[id] (imul 0xCA); -- per-power count [owner-0x6D68]
 *             (owner = +0x1A, abs 0x5D60); clear its map tile (0x181F:0x68C, coords
 *             +0x5D47/+0x5D46 = colony[1]/[0]).
 *   @0x02EE6A COMPACT the table: for slots id..[0x539E]-2, rep-movsw 0x65 words
 *             (= one 0xCA-byte ColonyRecord) from [+0x5E10] down one slot;
 *             --[0x539E].
 *   @0x02EE90 walk the global unit list ([0x9E18]; 0x191F:0xA4A/0xA3C; sentinel
 *             0x3E7): for units referencing this colony fix the index; bound by
 *             [0x53A0]; reload via 0x191F:0x2CE; field +0x21.
 *   @0x02EEFA fix UnitRecord HOME-colony index (+0x06 = 0x314A) across [0x539C]:
 *             home > destroyed slot -> --; home == destroyed -> 0xFF (orphan).
 * @status     BYTE_VERIFIED (compaction + unit-ref fixups + struct).
 */
int func_02EE34_logic_sz_12(uint16_t arg0_bp_06)
{
    int cid = (int16_t)arg0_bp_06;
    int i, j;               /* [bp-4] / [bp-2] */

    UREC_B(COLREC_B(cid * 0xCA + 0x5D60) - 0x6D68)--;  /* @0x02EE47 --[owner-0x6D68] */
    overlay_call_181F_068C();                       /* @0x02EE59 clear tile(coords +0x5D46/47)*/

    for (i = cid; i < g_colony_count_539E - 1; i++) /* @0x02EE6A..0x02EE8A compact */
        overlay_call_0D1D_0DAE();                   /* rep movsw 0x65 (ColonyRecord slide) */
    g_colony_count_539E--;                          /* @0x02EE8C */

    for (i = 0; i <= g_w53A0; i++) {                /* @0x02EED4..0x02EEDE unit-ref fixups*/
        overlay_call_191F_02CE();                   /* @0x02EEE1 unit_ref_reload(i) */
        for (j = /* field +0x21 */ 0 - 1; j >= 0; j--) {  /* @0x02EEED..0x02EEA3 */
            int v = overlay_call_191F_0A4A();       /* @0x02EEAC unit_ref_value(j) */
            if (v == 0x3E7) continue;               /* @0x02EEB8 sentinel */
            if (v > cid)      /* unit_ref_dec(j)  @0x02EE9D */ ;
            else if (v == cid) overlay_call_191F_0A3C(); /* @0x02EECA unit_ref_clear(j)*/
        }
    }

    for (i = g_w539C - 1; i >= 0; i--) {            /* @0x02EF07..0x02EF22 home-index fix*/
        if ((UREC_B(i * 0x1C + 0x03) & 0xF) >= 4) continue; /* @0x02EF28 +0x3147 */
        int home = UREC_B(i * 0x1C + 0x06);         /* @0x02EF11 +0x314A home colony */
        if (home > cid)       UREC_B(i * 0x1C + 0x06) = (uint8_t)(home - 1); /* @0x02EF17*/
        else if (home == cid) UREC_B(i * 0x1C + 0x06) = 0xFF; /* @0x02EF3B orphan */
    }
    return 0;                                       /* @0x02EF44 */
}

/* ============================================================================
 * func_02EF64  — PIONEER/CONVERT work-order TICK (terrain-change progress)
 * @asm        0x02EF64..0x02F051  (236 bytes)  ENTER 8  RETF
 * @asm_ref    page_03.asm "func_02EF64 size=236 insns=77"
 * @role       arg0 (bp+6 = unit slot).  Advances a unit's outdoor work order:
 *   @0x02EF6E read UnitRecord[slot]: +0=x +1=y +2=type +0x17=activity (0x315B).
 *   @0x02EF86 0x181F:0x302 (= func_02EB46) the tile must be owned/seen; type must
 *             be 0 (free colonist) and activity == 0x1B; else exit.
 *   @0x02EFAD 0x181F:0x6BE bounds; 0x181F:0x8BC(2,slot) < 2; ++work-counter +0x16
 *             (0x315A); when > 8 the job COMPLETES:
 *   @0x02EFE1 owner nibble +0x3 (0x3147)&0xF; if a real player (idx<4 &&
 *             [0x543F+idx*0x34]==0) apply the terrain change (0x181F:0xD9A); finish
 *             (0x181F:0x808); if human, spawn the result (0x181F:0x9BA) and draw
 *             boxed "DEADCONVERTS"(0xEE2) — a captured-convert/pioneer completion.
 * @status     BYTE_VERIFIED (flow + UnitRecord struct + string "DEADCONVERTS").
 */
int func_02EF64_predicate_unit(uint16_t arg0_bp_06)
{
    int slot = (int16_t)arg0_bp_06;
    int owner, ok = 1;      /* [bp-8] / [bp-6] @asm 0x02EF69 */

    /* x=+0x3144 (bp-2), y=+0x3145 (bp-4). */
    if (overlay_call_181F_0302() == 0) return 0;    /* @0x02EF86 = func_02EB46(x,y) */
    if (UREC_B(slot * 0x1C + 0x02) != 0) return 0;  /* @0x02EF99 +0x3146 free colonist*/
    if (UREC_B(slot * 0x1C + 0x17) != 0x1B) return 0; /* @0x02EFA3 +0x315B working */
    if (overlay_call_181F_06BE() < 0) return 0;     /* @0x02EFB5 bounds */
    if (overlay_call_181F_08BC() >= 2) return 0;    /* @0x02EFC9 */
    if (++UREC_B(slot * 0x1C + 0x16) <= 8) return 0;/* @0x02EFD6/0x02EFDA +0x315A counter*/

    owner = UREC_B(slot * 0x1C + 0x03) & 0xF;       /* @0x02EFE1 +0x3147 */
    if (owner < 4 && g_power_ctrl[owner * 0x34] == 0) /* @0x02EFEB/0x02EFF3 */
        overlay_call_181F_0D9A();                   /* @0x02F000 apply_terrain_change(y,x)*/
    overlay_call_181F_0808();                       /* @0x02F00B finish_work_order(slot) */
    ok = 0;                                         /* @0x02F013 */
    if (owner < 4 && g_power_ctrl[owner * 0x34] == 0) { /* @0x02F018/0x02F022 */
        overlay_call_181F_09BA();                   /* @0x02F035 spawn_unit(1,1,1,y,x) */
        overlay_call_181F_0652();                   /* @0x02F042 boxed "DEADCONVERTS"(0xEE2)*/
    }
    return ok;                                      /* @0x02F04A */
}

/* ============================================================================
 * func_02F052  — SUPERSEDED  (file 0x02F052..0x02F3A0, 847 bytes)
 * The per-power king/REF event processor (ship REFIT completion + KINGTAX grant,
 * spawns king unit type 0x11) is BYTE_VERIFIED-ported in:
 *     -> src/king/king_events.c   (king_process_power_events)
 * Not duplicated here; this stub marks the offset as relocated.
 * @status     SUPERSEDED -> src/king/king_events.c
 *
 * ----------------------------------------------------------------------------
 * PHANTOM (not real code): the auto-pipeline listed func_02EC2E (file 0x02EC2E,
 * "ENTER 0,0" = bytes c8 00 00 00) as a 15-byte function.  Those bytes are an
 * aliased MID-INSTRUCTION decode INSIDE func_02EB78: at 0x02EC2C the real
 * instruction is `c7 87 c8 00 00 00` (MOV word [bx+0xC8],0); 0x02EC2E is +2 into
 * it.  The re-segmented page_03.asm does NOT list func_02EC2E, and the per-func
 * dump's trailing `6A` (DB) confirms a truncated mid-body fragment.  NO BODY is
 * emitted for func_02EC2E.  @status PHANTOM (fixup/mid-instruction alias).
 * ============================================================================ */
