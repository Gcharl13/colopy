/* ============================================================================
 * overlay_02F3A2_031E4C.c -- overlay functions in file range 0x02F3A2..0x031E4C
 *
 * RE-RECONSTRUCTED 2026-05-30 from the FULL re-segmented disassembly
 * (code/VICEROY/disasm_overlay_reseg/page_03.asm + page_04.asm) and the raw
 * COLONIZE/VICEROY.EXE bytes. The original auto-generated control-flow skeletons
 * were replaced/triaged per the RECONSTRUCTION_PLAN SCOPE split.
 *
 * ----------------------------------------------------------------------------
 * WHAT THIS FILE IS
 * ----------------------------------------------------------------------------
 * File offsets 0x02F3A2..0x031E4C straddle two overlay pages:
 *   page_03  (file 0x02CB00, code 0x02CFD0..0x02FAE8) -- its LAST function is
 *            func_02F3A2 (king_war_turn, 1869 B, page-end).
 *   page_04  (file 0x02FAF0, code 0x030550..) -- the Europe / report-screen and
 *            market/unit-list UI cluster.
 * The bytes in between (0x02FAE8..0x030550) are page_04's RELOC HEADER
 * (652 relocs); they mis-decode as ENTER prologues. Two "functions" the
 * auto-tracer emitted there (func_02FF0C, func_03034C) are NOT real code.
 *
 * ----------------------------------------------------------------------------
 * STATUS TAGS (per function, see the per-function table in the task summary)
 * ----------------------------------------------------------------------------
 *   SUPERSEDED  -> the real, byte-verified port lives in a named subsystem file;
 *                  this stub is removed in favour of that. (5 functions)
 *   PHANTOM/NOT_A_FUNCTION -> reloc-header bytes; no body. (2)
 *   REAL (ported) -> in-scope game-mechanics / UI-LAYOUT; hand-ported below,
 *                  @asm-cited per basic block, cite-or-left unresolved. (23)
 *
 * SCOPE NOTE (2026-05-30 directive): the heavy users below are the Europe-port
 * and F-key REPORT screens -- "what is drawn where" (panel frames, row geometry,
 * column rects, per-unit cargo rows, beveled cells). That is UI/RENDER LAYOUT =
 * IN SCOPE. The pixel-pushing leaves they call (the 0x181F:xxxx text/sprite/box
 * primitives and the 0x191F:xxxx line helpers) are OUT-OF-SCOPE platform leaves
 * and are kept only as role-named externs (call sites preserved). The local
 * near-call helpers 0x368xx/0x369xx are RTLink THUNK trampolines (each is a
 * `JMP FAR 0x191F:nnn`) -- also kept as externs, bodies not ported.
 * ============================================================================ */
#include <stddef.h>
#include "viceroy.h"
#include "overlay_externs.h"

/* ----------------------------------------------------------------------------
 * Verified DGROUP globals referenced by this file (offset -> role).
 * Names are local aliases; the bytes are the arbiter.  [V] = byte-verified here.
 * ----------------------------------------------------------------------------
 *   0x9E12  word   g_active_power    active power index (0..3 Euro / +natives)  [V]
 *   0x84FC  near*  g_market          active PowerRecord ptr (0x8808+power*0x13C)[V]
 *   0x9E1C  word   g_cursor_unit_a   selected/active unit-record index          [V]
 *   0x9E20  word   g_cursor_unit_b   secondary highlighted unit index           [V]
 *   0x9E28  word   g_end_turn_btn    end-turn/Next button hover-press state      [V]
 *                 0=button up/outside rect, 1=held/inside rect.
 *                 BYTE_VERIFIED: func_033716 @overlay_031F28_033EB2 toggles it
 *                 based on point_in_rect(0x93,0xA5,0x48,0x0C) @asm 0x03374D.
 *   0x9E2A  word   g_ship_count      # ships of active power (func_030D16)       [V]
 *   0x9E2C  word   g_ship_cursor     selected-ship cursor (clamped to count)     [V]
 *   0x9E3A  word   g_phase_9E3A      game-phase / screen-mode word               [V]
 *                 Same register named g_phase_9E3A in overlay_0341D6_0388DE.c
 *                 and g_map_mode in overlay_031F28_033EB2.c.  Written to 8/9/10/
 *                 0xF by map transitions; checked here as 0,1,4 for report-panel
 *                 flash gates (phase values active during report sub-panel views).
 *   0x9E40  word   g_boycott_9E40    boycott-active flag                         [V]
 *                 BYTE_VERIFIED: europe_screen.c names it g_boycott_9E40; line
 *                 148 "boycott highlight color 0xF gated by [0x9E40]/[0xF9A]".
 *   0x07EE  word   g_flash_active    global "flash enabled" flag                 [V]
 *   0x0F9A  word   g_report_panel    active report-panel ID                      [V]
 *                 0=16-row table, 1=unit-detail, 2=cargo-list.
 *                 BYTE_VERIFIED: overlay_031F28 writes 1 @asm 0x03359B (unit
 *                 select), 0 @asm 0x033B2B (clear); overlay_0341D6 writes 2
 *                 @asm 0x342A5 (cargo panel).
 *   0x0FA2  word   g_detail_unit     unit whose detail panel is shown (0=list)   [V]
 *   0x0FA7  byte   g_boycott_sat     boycott saturation one-shot suppress flag   [V]
 *                 BYTE_VERIFIED: europe_screen.c line 109 "gated by [0x9E40]
 *                 (boycott) / [0xFA7] (saturation)"; written 1 @asm 0x033ADF,
 *                 cleared 0 @asm 0x035ADA.
 *   0x0F9E  byte   g_sel_row         currently-selected report row              [V]
 *   0x089E  far*   g_font_metrics    far ptr to active font (byte0 = line h)     [V]
 *   0x083E  far*   g_str_table       far ptr into the string/measure table       [V]
 *   0x0840  word   g_str_table_seg   (segment half of 0x083E pair)               [V]
 *   0x53A6  byte   g_difficulty      difficulty 0..4 (price/odds scaler)          [V]
 *   0x538A  word   g_year            current year value                          [V]
 *   0x538C  word   g_era_index       era/age index (year->table)                 [V]
 *   0x543F  byte[] g_power_flags     per-power record, stride 0x34; +0x00 is_AI   [V]
 *   0x5230  word[] g_unit_name_tbl   per-unit-type name-string ptr (stride 7)     [V]
 *   0x5232  byte[] g_unit_icon_tbl   per-unit-type map/cargo sprite (stride 7)    [V]
 *   0x5237  byte[] g_unit_cap_tbl    per-unit-type capacity/slot count (stride 7) [V]
 *   0x2DA8  word[4] g_clip_region    persistent 4-word clip/colour region         [V]
 *   0x2DAE.. (end of that region)
 *   0x2DCC/0x2DCE/0x2DD0/0x2DE8 word  per-panel label-string ptrs (report headers)[V]
 *   0x93A0/0x93B0 word   misc label-string ptrs                                   [V]
 *
 * UnitRecord: base 0x3144, stride 0x1C.  Fields used here (cited at use):
 *   +0x02 (->0x3146) byte type       @UNIT line index (ships = 0x0D..0x12)        [V]
 *   +0x04 (->0x3148) byte flags       bit7 = "needs-orders/active"                 [V]
 *   +0x08 (->0x314C) byte order_state set by func_030C68                           [V]
 *   +0x0C (->0x3150) byte cargo_flag  has-cargo/visible-in-panel                   [V]
 *   +0x15 (->0x3159) byte field_15    set 0x64 by func_030C68 (mode 2)             [V]
 *   +0x17 (->0x315B) byte field_17    = order key byte                            [V]
 * ---------------------------------------------------------------------------- */

/* DGROUP scalar accessors (near data segment). Bytes are the contract. */
#define G16(off)   (*(unsigned short *)(off))
#define G8(off)    (*(unsigned char  *)(off))
#define UNIT(i)    ((unsigned char *)(0x3144 + (unsigned)(i) * 0x1C))

/* Per-good @CARGO param table (NAMES.TXT) at DGROUP 0x96FC, stride 9.
 * @asm 0x030575 reads byte [bx-0x6900] with bx=good*9 -> field index 4 (burden),
 * since base 0x96FC == [good*9 - 0x6904]; so [-0x6900] == base+4.   [V/contract] */
#define CARGO_FIELD(good,field)  (*(unsigned char *)(0x96FC + (unsigned)(good)*9 + (field)))

/* ----------------------------------------------------------------------------
 * Platform-leaf externs (OUT-OF-SCOPE bodies; call sites kept = IN-SCOPE layout).
 * The 0x181F:/0x191F:/0x0D1D: targets are resolved-but-not-redecoded primitives;
 * already declared as overlay_call_<seg>_<off>() in overlay_externs.h. Below we
 * give ROLE NAMES (per 2026-05-30 directive: prefer role names where byte-known)
 * as thin local aliases so the LAYOUT reads as design, not opcodes.
 * ---------------------------------------------------------------------------- */
/* --- unit iteration (resident unit subsystem) --- */
extern int  unit_first_of_owner(int owner);   /* @asm 0x181F:0x07E0 -> first unit rec idx, -1 done */
extern int  unit_next(int cur);                /* @asm 0x181F:0x02E4 -> next unit rec idx, <0 done  */
/* --- RNG --- */
extern int  random_int(int lo, int hi);        /* @asm 0x181F:0x04D4 (resident 0x00C322) [V]        */
/* --- text/number formatting + draw primitives (font/blit leaves) --- */
extern long num_to_str(int value);             /* @asm 0x181F:0x0022 value -> ascii (dx:ax ptr)     */
extern int  str_width(const char *s);          /* @asm 0x181F:0x0114 pixel width of string          */
extern int  text_measure(/*...*/);             /* @asm 0x181F:0x0204 measure formatted text         */
extern void str_begin(char *buf, void *arg);   /* @asm 0x181F:0x016E start building a display string*/
extern void str_append(char *buf);             /* @asm 0x181F:0x0178 append token to string         */
extern void str_finish(char *buf);             /* @asm 0x181F:0x011E finalize string                */
extern void str_append_num(char *buf, int n);  /* @asm 0x181F:0x0182 append number field            */
extern void str_pad(char *buf);                /* @asm 0x181F:0x01B4 pad/justify                     */
extern void draw_text_clip(/*...*/);           /* @asm 0x181F:0x013C draw text within clip rect      */
extern void draw_text_at(/*...*/);             /* @asm 0x181F:0x0100 draw text at x,y                */
extern void box_fill(/*...*/);                 /* @asm 0x181F:0x0254 filled box / cell background    */
extern void box_clear(/*...*/);                /* @asm 0x181F:0x00E2 clear/restore box region        */
extern void box_bevel(/*...*/);                /* @asm 0x181F:0x00BA beveled box edge                */
extern void hline(/*...*/);                    /* @asm 0x181F:0x00CE horizontal rule / icon row      */
extern int  sprite_blit(/*...*/);              /* @asm 0x181F:0x02BC blit a sprite; returns width    */
extern int  sprite_blit2(/*...*/);             /* @asm 0x181F:0x02F8 blit sprite variant             */
extern int  glyph_value(/*...*/);              /* @asm 0x181F:0x0BE6 measure/return a glyph metric   */
extern void edge_light(/*...*/);               /* @asm 0x191F:0x08BC 3-D light edge (top/left)       */
extern void edge_shadow(/*...*/);              /* @asm 0x191F:0x08B2 3-D shadow edge (bottom/right)  */
extern long ldiv32_helper(/*...*/);            /* @asm 0x0D1D:... runtime long divide/format         */
/* strcat_far declared in iolib.h (included via viceroy.h) */
extern void strfmt_far(/*...*/);               /* @asm 0x0D1D:0x07A4 / 0x11B4 / 0x08FA formatting     */

/* --- local near-call helpers (RTLink thunks: each is JMP FAR 0x191F:nnn) ---
 * These are OUT-OF-SCOPE trampolines; we keep role-named call sites only. */
extern void  draw_window_frame(int x, int y, int x2, int y2);  /* @asm near 0x6DDC (file 0x368CC -> 0x191F:0x0CE6) */
extern char *report_row_label(int row);                        /* @asm near 0x6D23 (file 0x36813 -> 0x191F:0x09EA) */
extern char *report_row_value(int row);                        /* @asm near 0x6DA0 (file 0x36890)                  */
extern int   report_row_has(int row);                          /* @asm near 0x6DD7 (file 0x368C7)                  */
extern void  report_row_cells(int row,int*a,int*b,int*c,int*d); /* @asm near 0x6D55 (file 0x36845)                 */
extern void  cargo_row_decode(/*...*/);                        /* @asm near 0x6DAF/0x6D9B (file 0x3689F/0x3688B)   */
extern int   list_unit_at(int slot);                           /* @asm near 0x6E13 (file 0x36903)                  */
extern void  draw_table_row(/*...*/);                          /* @asm near 0x6E3B (file 0x3692B)                  */
extern int   func_0066CC_op_sz_57(uint16_t x, uint16_t y);     /* 0x181F:0x7E0 tile head (AX,DX) */
extern int   unit_chain_next(int idx);                         /* 0x181F:0x2E4 */
extern void  draw_list_row2(/*...*/);                          /* @asm near 0x6E04 (file 0x368F4)                  */
extern void  panel_helper_1E1D(int arg);                       /* @asm near 0x6E1D (file 0x3690D)                  */
extern void  panel_helper_1E6D(int arg);                       /* @asm near 0x6E6D (file 0x3695D)                  */

/* ============================================================================
 * func_02F3A2  --  SUPERSEDED -> src/king/war_turn.c  (king_war_turn)
 * ----------------------------------------------------------------------------
 * The auto-tracer split off only the first 63 bytes; the REAL function is
 * 1869 B (0x02F3A2..0x02FAE8, page-end of page_03, raw `C8 78 00 00`=ENTER 0x78).
 * It is the War-of-Independence king turn (defeat-year >=1600 gate, REF landing
 * matrix, dated 1790/1800/1840/1850 messages) and is BYTE_VERIFIED in
 * src/king/war_turn.c.  No body here.
 * ============================================================================ */
/* SUPERSEDED: see src/king/war_turn.c (func_02F3A2 king_war_turn, BYTE_VERIFIED). */

/* ============================================================================
 * func_02FF0C  --  PHANTOM / NOT_A_FUNCTION
 * ----------------------------------------------------------------------------
 * Offset 0x02FF0C lies AFTER func_02F3A2's RETF (0x02FAE8) and inside page_04's
 * reloc header (file 0x02FAF0..0x030550). Raw bytes `C8 26 00 00 96 26 00 00`
 * are relocation-table entries, not an ENTER 0x26 prologue. It does not appear
 * in the re-segmented disassembly's function list. No body.
 * ============================================================================ */
/* PHANTOM/NOT_A_FUNCTION: page_04 reloc-header bytes mis-decoded as ENTER. */

/* ============================================================================
 * func_03034C  --  PHANTOM / NOT_A_FUNCTION
 * ----------------------------------------------------------------------------
 * Offset 0x03034C is also inside page_04's reloc header (0x02FAF0..0x030550).
 * Raw `C8 50 00 00 7B 07 00 00` = reloc entries, not ENTER 0x50. Absent from the
 * re-segmented function list. (The auto "region scoring / STANDALONE_COMPUTE"
 * guess was a control-flow trace over header bytes.) No body.
 * ============================================================================ */
/* PHANTOM/NOT_A_FUNCTION: page_04 reloc-header bytes mis-decoded as ENTER. */

/* ============================================================================
 * func_030550  --  SUPERSEDED -> src/market/pricing.c  (market_set_active)
 * ----------------------------------------------------------------------------
 * g_active_power = power; g_market = 0x8808 + power*0x13C.  Byte-verified in
 * pricing.c; also re-confirmed by report_screen.c (player-context selector).
 * ============================================================================ */
/* SUPERSEDED: see src/market/pricing.c (func_030550 market_set_active, [V]). */

/* ============================================================================
 * func_030566  --  market_sell_price(good)   [REAL, ported]
 *   @asm func_030566 @ file 0x030566..0x03058F  (42 B, ENTER 2,0, RETF) [V]
 *
 * Returns the European SELL (player-receives) unit price for `good`:
 *   price_level[good] (PowerRecord +0x4C+good)  +  cargo_burden[good]  (>=0).
 * @asm:
 *   0x03056B  bx = good
 *   0x030570  bx = good*9            (shl 3 + add ax)         -> @CARGO row
 *   0x030575  al = [bx-0x6900] = CARGO_FIELD(good,4) (burden) ; cwde
 *   0x03057A  bx = g_market (0x84FC)
 *   0x030583  al = [bx+good+0x4C] = price_level[good]         ; cwde
 *   0x030587  ax = price_level + burden
 *   0x030589  if (ax < 0) ax = 0    (JNS / sub ax,ax)
 * ============================================================================ */
int market_sell_price(int good)
{
    unsigned char *m = *(unsigned char **)0x84FC;       /* @asm 0x03057A g_market    */
    int burden = (signed char)CARGO_FIELD(good, 4);     /* @asm 0x030575 burden      */
    int level  = (signed char)m[0x4C + good];           /* @asm 0x030583 price_level */
    int price  = level + burden;                        /* @asm 0x030587             */
    if (price < 0) price = 0;                            /* @asm 0x030589 JNS         */
    return price;
}

/* ============================================================================
 * func_030590  --  market_buy_price(good)   [REAL, ported]
 *   @asm func_030590 @ file 0x030590..0x0305A7  (24 B, ENTER 2,0, RETF) [V]
 *
 * Returns the European BUY (player-pays) unit price = price_level[good] - 1,
 * clamped >=0.  (The classic Colonization bid/ask spread of 1.)
 * @asm:
 *   0x030595  bx = g_market (0x84FC)
 *   0x030599  si = good
 *   0x03059C  al = [bx+si+0x4C] = price_level[good] ; cwde
 *   0x0305A0  ax--                                  (DEC ax)
 *   0x0305A1  if (ax < 0) ax = 0                    (JNS / sub ax,ax)
 * ============================================================================ */
int market_buy_price(int good)
{
    unsigned char *m = *(unsigned char **)0x84FC;       /* @asm 0x030595 g_market    */
    int price = (signed char)m[0x4C + good] - 1;        /* @asm 0x03059C/0x0305A0    */
    if (price < 0) price = 0;                            /* @asm 0x0305A1 JNS         */
    return price;
}

/* ============================================================================
 * func_0305A8  --  SUPERSEDED -> src/market/pricing.c  (market_price_drift)
 * ----------------------------------------------------------------------------
 * The per-turn market drift engine, REAL extent 0x0305A8..0x030B37 (1424 B,
 * 524 insns; raw `C8 66 00 00`=ENTER 0x66). The auto stub captured only 87 B.
 * Fully hand-ported & byte-verified in pricing.c. No body here.
 * ============================================================================ */
/* SUPERSEDED: see src/market/pricing.c (func_0305A8 market_price_drift, [V]). */

/* ============================================================================
 * func_030B38  --  SUPERSEDED -> src/market/boycott.c  (boycott_is_active)
 * ----------------------------------------------------------------------------
 * return (1<<good) & PowerRecord[active].boycott_mask(+0x20).  Byte-verified
 * in boycott.c.  No body here.
 * ============================================================================ */
/* SUPERSEDED: see src/market/boycott.c (func_030B38 boycott_is_active, [V]). */

/* ============================================================================
 * func_030B4C  --  unit_census_active(int *out_needs_orders)   [REAL, ported]
 *   @asm func_030B4C @ file 0x030B4C..0x030BB5  (105 B, ENTER 4,0, RET) [V]
 *   (auto stub claimed 36 B "sound wrapper" -- wrong; it is a unit scan.)
 *
 * Walks every unit owned by (g_active_power - 0x14) and:
 *   - counts ALL such units            -> return value
 *   - counts those that still need orders (type's cap-table byte !=0, unit flag
 *     +0x3148 bit7 set, type != 0x0B)  -> *out_needs_orders
 * @asm:
 *   0x030B55  *out (bp+4) = 0
 *   0x030B5A  owner = g_active_power(0x9E12) - 0x14
 *   0x030B62  cur = unit_first_of_owner(owner)        (0x181F:0x07E0)
 *   loop @0x030B6A:
 *     0x030B6A bx = cur*0x1C ; type = byte[bx+0x3146]
 *     0x030B72 cmcode = type ; expand
 *     0x030B7A bx = type*7   (shl/add chain) -> cap-table index
 *     0x030B84 if (g_unit_cap_tbl[type*7 + 0x5237] != 0)   (i.e. CAP(type)!=0)
 *     0x030B8D   if (UNIT(cur)[+0x04] & 0x80)              (needs-orders flag)
 *     0x030B94     if (type != 0x0B)  (*out)++            (skip type 0x0B)
 *     0x030B9E   total++
 *     0x030BA4 cur = unit_next(cur)  (0x181F:0x02E4) ; while (cur >= 0)
 *   return total (bp-2)
 * ============================================================================ */
int unit_census_active(int *out_needs_orders)
{
    int total = 0;                                       /* @asm 0x030B52 bp-2 */
    int owner = (int)G16(0x9E12) - 0x14;                 /* @asm 0x030B5A      */
    int cur;
    *out_needs_orders = 0;                               /* @asm 0x030B58      */
    for (cur = unit_first_of_owner(owner); cur >= 0; cur = unit_chain_next(cur)) {
        int type = UNIT(cur)[0x02];                      /* @asm 0x030B70 [+0x3146] */
        if (G8(0x5237 + type * 7) != 0) {                /* @asm 0x030B84 CAP(type) */
            if (UNIT(cur)[0x04] & 0x80) {                /* @asm 0x030B8D needs-orders */
                if (type != 0x0B)                        /* @asm 0x030B94 */
                    (*out_needs_orders)++;               /* @asm 0x030B9C */
            }
        }
        total++;                                         /* @asm 0x030B9E */
    }
    return total;                                        /* @asm 0x030BB0 */
}

/* ============================================================================
 * func_030BB6  --  unit_nth_active(int n)   [REAL, ported]
 *   @asm func_030BB6 @ file 0x030BB6..0x030C13  (94 B, ENTER 6,0, RETF) [V]
 *
 * Returns the unit-record index of the n-th unit of the active power whose type
 * passes the cap-table gate (CAP(type)!=0); returns -1 if none.
 * @asm:
 *   0x030BC3 owner = g_active_power - 0x14 ; cur = unit_first_of_owner(owner)
 *   loop @0x030BD2: type = UNIT(cur).type ; if (CAP(type)!=0) {
 *       count++ (bp-4) ; if (count == n (bp+6)) result = cur (bp-6 -> bp-2) }
 *   cur = unit_next(cur) ; while >=0 ; return result(bp-2, init 0xFFFF)
 * ============================================================================ */
int unit_nth_active(int n)
{
    int result = -1;                                     /* @asm 0x030BBD bp-2 = 0xFFFF */
    int count  = -1;                                     /* @asm 0x030BBA/0x030BBD bp-4 = 0xFFFF */
    int owner  = (int)G16(0x9E12) - 0x14;                /* @asm 0x030BC3 (NOTE: bp-4 and bp-6
                                                          * share storage; n arrives in bp+6) */
    int cur;
    /* count starts at 0xFFFF (-1) and is pre-incremented -> first match yields 0,
     * matching the asm's wrapped 0-based index compared against n (bp+6). */
    for (cur = unit_first_of_owner(owner); cur >= 0; cur = unit_chain_next(cur)) {
        int type = UNIT(cur)[0x02];                      /* @asm 0x030BD6 */
        if (G8(0x5237 + type * 7) != 0) {                /* @asm 0x030BE8 CAP(type) */
            count++;                                     /* @asm 0x030BF2 INC bp-4 */
            if (count == n)                              /* @asm 0x030BF5 CMP bp-4, bp+6 */
                result = cur;                            /* @asm 0x030BFA bp-6 = cur */
        }
    }
    return result;                                       /* @asm 0x030C0F bp-2 */
}

/* ============================================================================
 * func_030C14  --  ship_nth_active(int n)   [REAL, ported]
 *   @asm func_030C14 @ file 0x030C14..0x030C67  (83 B, ENTER 6,0, RETF) [V]
 *
 * Like unit_nth_active but the gate is "type is a SHIP" (0x0D <= type <= 0x12,
 * @UNIT ship rows). Returns the n-th ship's record index, or -1.
 * @asm 0x030C34/0x030C3B  CMP type,0x0D (JB skip) ; CMP type,0x12 (JBE accept)
 * ============================================================================ */
int ship_nth_active(int n)
{
    int result = -1;                                     /* @asm 0x030C1E bp-2 = 0xFFFF */
    int count  = -1;                                     /* @asm 0x030C1B bp-6 = 0xFFFF */
    int owner  = (int)G16(0x9E12) - 0x14;                /* @asm 0x030C21 */
    int cur;
    /* count pre-incremented from -1 (asm 0xFFFF) -> 0-based; compared to n (bp+6). */
    for (cur = unit_first_of_owner(owner); cur >= 0; cur = unit_chain_next(cur)) {
        int type = UNIT(cur)[0x02];                      /* @asm 0x030C34 */
        if (type >= 0x0D && type <= 0x12) {              /* @asm 0x030C34/0x030C3B ship range */
            count++;                                     /* @asm 0x030C45 INC bp-6 */
            if (count == n)                              /* @asm 0x030C48 CMP bp-6, bp+6 */
                result = cur;                            /* @asm 0x030C4D bp-2 = cur */
        }
    }
    return result;                                       /* @asm 0x030C62 bp-2 */
}

/* ============================================================================
 * func_030C68  --  order_assign(int order_key)   [REAL, ported]
 *   @asm func_030C68 @ file 0x030C68..0x030D15  (174 B, ENTER 6,0, RETF) [V]
 *
 * Maps a command/order key to an internal order code, (for one code) rolls a
 * difficulty-weighted random success, finds the target unit, and writes the
 * order onto its UnitRecord. Returns the affected unit index (or <0).
 *
 * key->code map  @asm 0x030C71..0x030C9D:
 *   0x14 -> 2 , 0x18 -> 3 , 0x16 -> 5 , 0x15 -> 1   (else 0)
 *
 * For key 0x15 (code 1) @asm 0x030C9D..0x030CD4:
 *   if (active_power < 4 AND g_power_flags[power*0x34] == 0  [human flag])
 *        r = difficulty (0x53A6);  else  r = 1;
 *   if (random_int(0, r+4) == 0)  code = 4;       (0x181F:0x04D4)
 *
 * Then @asm 0x030CD9: u = find/select unit via 0x181F:0x095C(code, power,
 *   power-0x14, power-0x14); if (u >= 0) {
 *       UNIT(u)[+0x08]=1 (order_state) ; UNIT(u)[+0x17]=order_key ;
 *       if (code == 2) UNIT(u)[+0x15]=0x64 }
 *   return u.
 * ============================================================================ */
extern int unit_select_for_order(int code, int power, int owner_a, int owner_b); /* @asm 0x181F:0x095C */

int order_assign(int order_key)
{
    int code = 0;                                        /* @asm 0x030C6C bp-2 */
    int u;

    if (order_key == 0x14) code = 2;                     /* @asm 0x030C71 */
    if (order_key == 0x18) code = 3;                     /* @asm 0x030C7C */
    if (order_key == 0x16) code = 5;                     /* @asm 0x030C87 */
    if (order_key == 0x15) {                             /* @asm 0x030C92 */
        int r;
        code = 1;                                        /* @asm 0x030C98 */
        /* difficulty-weighted "demote to code 4" chance, human players only */
        if ((int)G16(0x9E12) < 4 &&                      /* @asm 0x030C9D */
            G8(0x543F + (int)G16(0x9E12) * 0x34) == 0)   /* @asm 0x030CA4 is_AI==0 */
            r = G8(0x53A6);                              /* @asm 0x030CB0 difficulty */
        else
            r = 1;                                       /* @asm 0x030CBA */
        if (random_int(0, r + 4) == 0)                   /* @asm 0x030CC2/0x030CC8 */
            code = 4;                                    /* @asm 0x030CD4 */
    }

    u = unit_select_for_order(code,                      /* @asm 0x030CE8 0x181F:0x095C */
                              (int)G16(0x9E12),
                              (int)G16(0x9E12) - 0x14,
                              (int)G16(0x9E12) - 0x14);
    if (u >= 0) {                                        /* @asm 0x030CF5 */
        UNIT(u)[0x08] = 1;                               /* @asm 0x030CFA [+0x314C] order_state */
        UNIT(u)[0x17] = (unsigned char)order_key;        /* @asm 0x030D02 [+0x315B] */
        if (code == 2)                                   /* @asm 0x030D06 */
            UNIT(u)[0x15] = 0x64;                        /* @asm 0x030D0C [+0x3159]=100 */
    }
    return u;                                            /* @asm 0x030D11 */
}

/* ============================================================================
 * func_030D16  --  ship_cursor_recount(void)   [REAL, ported]
 *   @asm func_030D16 @ file 0x030D16..0x030D6B  (86 B, ENTER 2,0, RETF) [V]
 *   (auto stub mislabeled "sound".)
 *
 * Recomputes g_ship_count (0x9E2A) = number of SHIP units of the active power,
 * then clamps the ship-selection cursor g_ship_cursor (0x9E2C) to range.
 * @asm:
 *   0x030D1A  g_ship_count = 0
 *   0x030D20  owner = g_active_power - 0x14 ; cur = unit_first_of_owner(owner)
 *   loop @0x030D30: type=UNIT(cur).type; if (type<0x0D || type>0x12) g_ship_count++
 *       -- NOTE: the increment is on the NON-ship branch (JB/JBE skip ship range),
 *          i.e. this counts NON-ship units of the owner.  [byte-faithful]
 *   cur = unit_next(cur); while >=0
 *   0x030D54  if (g_ship_count != 0 && g_ship_cursor >= g_ship_count)
 *   0x030D64       g_ship_cursor = 0
 * ============================================================================ */
void ship_cursor_recount(void)
{
    int owner = (int)G16(0x9E12) - 0x14;                 /* @asm 0x030D20 */
    int cur;
    G16(0x9E2A) = 0;                                     /* @asm 0x030D1A */
    for (cur = unit_first_of_owner(owner); cur >= 0; cur = unit_chain_next(cur)) {
        int type = UNIT(cur)[0x02];                      /* @asm 0x030D33 */
        if (type < 0x0D || type > 0x12)                  /* @asm 0x030D33/0x030D3A */
            G16(0x9E2A)++;                               /* @asm 0x030D41 */
    }
    if (G16(0x9E2A) != 0 &&                              /* @asm 0x030D54 */
        (int)G16(0x9E2C) >= (int)G16(0x9E2A))            /* @asm 0x030D5E */
        G16(0x9E2C) = 0;                                 /* @asm 0x030D64 */
}

/* ============================================================================
 * func_030D86  --  SUPERSEDED -> src/ui/europe_screen.c  (europe_clip_blit)
 * ----------------------------------------------------------------------------
 * Generic two-clip-region blit (pushes 0x839E..0x83A4 and 0x2DA8..0x2DAE then
 * LCALL 0x181F:0x0444). Byte-verified in europe_screen.c. The dead-code tail at
 * 0x030DBC is func_030DBC = europe_open (also in europe_screen.c). No body here.
 * ============================================================================ */
/* SUPERSEDED: see src/ui/europe_screen.c (func_030D86 europe_clip_blit; tail
 * 0x030DBC = europe_open). */

/* ============================================================================
 * func_030DF4  --  report_unit_panel(int menu_id)   [REAL, ported -- UI LAYOUT]
 *   @asm func_030DF4 @ file 0x030DF4..0x030F75  (385 B, ENTER 0x64,0, RETF) [V]
 *
 * Composes one menu/info panel for the unit/report screen: builds a multi-line
 * display string for `menu_id`, lays out its rows, measures, and draws the
 * framed window. This DECIDES POSITIONS -> IN SCOPE.
 *
 * Layout facts (byte-verified):
 *   - title string ptr = g_word_table[menu_id*2 - 0x6840]    @asm 0x030E02
 *   - branch on report_row_has(menu_id) (near 0x6DD7)         @asm 0x030E2E
 *       false -> single-line variant (label 0x2EC0)           @asm 0x030E38
 *       true  -> multi-section: label 0x2EB4 + provider rows
 *                report_row_label(0x6D23) / report_row_value(0x6DA0)  @asm 0x030E6A/0x030EAA
 *   - row height = menu_id*0x13 + 0x0A (19 px rows, +10 top)  @asm 0x030ED4
 *   - measured via text_measure(0x181F:0x0204), centred:
 *       x = win_w/2 - text_w/2 ; height window via 0x35C      @asm 0x030F00..0x030F18
 *   - draw frame/box: 0x181F:0x00BA, 0x1F0, 0x1FA with the
 *     persistent region 0x2DA8..0x2DAE                        @asm 0x030F3F..0x030F6D
 *
 * The string-builder / measure / draw calls are leaves (externs). The geometry
 * (row pitch 0x13, top 0x0A, centring) is the LAYOUT and is reproduced.
 * Detailed per-pixel arg packing left as the leaf contract (library-implementation-only).
 * ============================================================================ */
extern unsigned short g_word_table[];   /* DGROUP word table; title ptr @ [menu_id - 0x3420] (word) */

void report_unit_panel(int menu_id)
{
    char buf[0x50];                                      /* @asm bp-0x50 string scratch */
    int  row_h = menu_id * 0x13 + 0x0A;                  /* @asm 0x030ED4 row pitch 19, top 10 */
    (void)row_h;

    /* title line */
    str_begin(buf, &g_word_table[menu_id]);              /* @asm 0x030E0A title=[bx-0x6840] */
    str_append(buf);                                     /* @asm 0x030E16 */
    str_finish(buf);                                     /* @asm 0x030E22 */

    if (!report_row_has(menu_id)) {                      /* @asm 0x030E2E near 0x6DD7 */
        /* single-line variant */
        str_begin(buf, 0 /*label 0x2EC0*/);              /* @asm 0x030E40 */
    } else {
        /* multi-section variant: label + per-row provider text */
        str_begin(buf, 0 /*label 0x2EB4*/);              /* @asm 0x030E52 */
        str_append(buf);                                 /* @asm 0x030E5E */
        /* report_row_label(menu_id) -> append number  @asm 0x030E6A/0x030E76 */
        str_append_num(buf, 0 /*report_row_label*/);     /* @asm 0x030E76 */
        str_pad(buf);                                    /* @asm 0x030E82 */
        str_begin(buf, 0 /*label 0x2EB2*/);              /* @asm 0x030E92 */
        str_append(buf);                                 /* @asm 0x030E9E */
        /* report_row_value(menu_id) -> append number  @asm 0x030EAA/0x030EB6 */
        str_append_num(buf, 0 /*report_row_value*/);     /* @asm 0x030EB6 */
    }
    str_finish(buf);                                     /* @asm 0x030EC2 */

    /* measure + centre + draw framed window (leaf contract) */
    text_measure(/* buf, win cols 0x89E/0x8A0 */);       /* @asm 0x030EEF 0x181F:0x0204 */
    box_bevel(/* centred rect, colour 7 */);             /* @asm 0x030F3F 0x181F:0x00BA */
    /* 0x181F:0x1F0 / 0x1FA finalize the window with region 0x2DA8.  @asm 0x030F4E/0x030F6D */
}

/* ============================================================================
 * func_030F76  --  report_header_row(int draw_arg)   [REAL, ported -- UI LAYOUT]
 *   @asm func_030F76 @ file 0x030F76..0x0310B3  (318 B, ENTER 0x64,0, RET) [V]
 *
 * Builds the REPORT-screen header line: "<Nation> <Adjective> ... <Year>" and
 * draws it. Pure composition of strings + one draw -> IN SCOPE.
 *
 * @asm pieces:
 *   0x030F7A  nation name  = g_str[active_power*2 - 0x7C74] (power-name table)
 *   0x030F84  num_to_str + strcat_far(0x0D1D:0x117E) into buf, then str_pad
 *   0x030FA7  adjective    = g_str[active_power*2 - 0x72BE]; strfmt 0x0D1D:0x11B4
 *   0x030FD4  era word     = g_str[era_index(0x538C)*2 - 0x6800]; strfmt 0x0D1D:0x11B4
 *   0x031001  year value   = g_year(0x538A) formatted via 0x0D1D:0x08FA + 0x07A4
 *   0x03102F  label 0x93B0 prepended (str_begin)
 *   0x03103F  tax byte = g_market[+1] appended as number (str_append_num)
 *   0x031055  finalize (0x10A) + two str_append (0x178)
 *   0x031079  label 0x93A0 + finalize
 *   0x031095  0x181F:0xB1E with active_power, then 0x181F:0xB0 draw at (bp+4)
 * ============================================================================ */
extern unsigned short g_power_name_tbl[]; /* @ [power - 0x3E3A] word: nation name ptr */

void report_header_row(int draw_arg)
{
    char buf[0x50];                                      /* @asm bp-0x50 */
    int  power = (int)G16(0x9E12);

    /* nation name */
    num_to_str(g_power_name_tbl[power] /* [bx-0x7C74] */);/* @asm 0x030F80/0x030F84 */
    strcat_far(NULL, NULL /* buf TODO */);               /* @asm 0x030F93 0x0D1D:0x117E */
    str_pad(buf);                                        /* @asm 0x030F9F */
    /* nation adjective */
    num_to_str(0 /* [bx-0x72BE] */);                     /* @asm 0x030FAD/0x030FB1 */
    strfmt_far(/* buf */);                               /* @asm 0x030FC0 0x0D1D:0x11B4 */
    /* era word */
    num_to_str(0 /* [era*2-0x6800] */);                  /* @asm 0x030FDA/0x030FDE */
    strfmt_far(/* buf */);                               /* @asm 0x030FED */
    str_pad(buf);                                        /* @asm 0x030FF9 */
    /* year value */
    strfmt_far(/* g_year=0x538A */);                     /* @asm 0x03100B 0x0D1D:0x08FA */
    strcat_far(NULL, NULL /* buf TODO */);               /* @asm 0x03101B 0x0D1D:0x07A4 */
    str_pad(buf);                                        /* @asm 0x031027 */
    /* label + tax */
    str_begin(buf, 0 /*0x93B0*/);                        /* @asm 0x031037 */
    {
        unsigned char *m = *(unsigned char **)0x84FC;    /* @asm 0x03103F g_market */
        str_append_num(buf, (signed char)m[1]);          /* @asm 0x031043 tax = [+1] */
    }
    str_finish(buf);                                     /* @asm 0x031059 0x181F:0x10A */
    str_append(buf);                                     /* @asm 0x031065 */
    str_append(buf);                                     /* @asm 0x031071 */
    str_begin(buf, 0 /*0x93A0*/);                        /* @asm 0x031081 */
    str_append(buf);                                     /* @asm 0x03108D */
    /* draw: 0x181F:0xB1E (power) then 0x181F:0xB0 with mode arg (bp+4) */
    draw_text_clip(/* buf, power=0x9E12 */);             /* @asm 0x03109D 0x181F:0xB1E */
    draw_text_at(/* buf, (bp+4) */);                     /* @asm 0x0310AD 0x181F:0xB0  */
    (void)draw_arg;
}

/* ============================================================================
 * func_0310B4  --  report_table_16rows(int input_enabled)  [REAL -- UI LAYOUT]
 *   @asm func_0310B4 @ file 0x0310B4..0x031297  (483 B, ENTER 0x74,0, RET) [V]
 *   (auto stub captured only 85 B.)
 *
 * Draws a 16-row report table (e.g. the per-commodity / per-unit summary page).
 * Frame, per-row label+value layout, selected-row highlight, optional input box.
 *
 * Layout facts (byte-verified):
 *   - window frame (0x15,0x140,0xB3,0) via draw_window_frame (near 0x6DDC) @asm 0x0310B9
 *   - row index i = bp-0x72, 0..15 (CMP 0x10)               @asm 0x031253
 *   - row top y advances by 0x13 (19 px) each row           @asm 0x03124C
 *   - per row: report_row_label(0x6D23)+strfmt, key 0xFC1,
 *              report_row_value(0x6DA0)+strfmt               @asm 0x031122/0x03115A
 *   - centred via text_measure(0x204): x = -(w/2 - col) + 8  @asm 0x031186..0x03119B
 *   - selected row (g_sel_row 0xF9E == i): colour 0xA, or
 *     0xE when flash gate (0x7EE && g_phase_9E3A==0) or boycott gate  @asm 0x0311E5..0x03121A
 *   - draw row cell via 0x181F:0x0CE                         @asm 0x031247
 *   - footer rule (0xF,0xB3,0x132,[0x2F5E]) via 0x22+0x13C   @asm 0x03125C
 *   - if (input_enabled (bp+4)) clear/activate input box
 *     (0xB3,0x140,0x15,...) via 0x181F:0x0E2                 @asm 0x03127A
 * ============================================================================ */
void report_table_16rows(int input_enabled)
{
    char buf[0x52];                                      /* @asm bp-0x52 row text */
    int  y = 1;                                          /* @asm bp-0x68 (start), advanced 0x13 */
    int  i;

    draw_window_frame(0x15, 0x140, 0xB3, 0);             /* @asm 0x0310B9 near 0x6DDC */

    for (i = 0; i < 0x10; i++) {                         /* @asm 0x031253 16 rows */
        int colour = 0x0A;                               /* @asm 0x0311EF default */

        /* label = report_row_label(i); value = report_row_value(i)  */
        report_row_label(i);                             /* @asm 0x031122 near 0x6D23 */
        strfmt_far(/* buf */);                            /* @asm 0x031129 0x0D1D:0x8FA */
        strcat_far(NULL, NULL /* buf TODO */);            /* @asm 0x031139 0x0D1D:0x7A4 */
        /* key 0x0FC1 appended @asm 0x031141; value @asm 0x03115A near 0x6DA0 */
        report_row_value(i);                             /* @asm 0x03115A near 0x6DA0 */
        text_measure(/* buf */);                          /* @asm 0x031186 0x181F:0x204 centre */

        /* selected-row / flash highlight */
        if (G8(0x0F9E) == i) {                            /* @asm 0x0311EA g_sel_row */
            if (G16(0x07EE) != 0 && G16(0x9E3A) == 0)     /* @asm 0x0311F3/0x0311FA */
                colour = 0x0E;                            /* @asm 0x031201 */
            if (G16(0x0F9A) == 0 && G16(0x9E40) != 0 &&   /* @asm 0x031205/0x03120C */
                G8(0x0FA7) == 0)                          /* @asm 0x031213 */
                colour = 0x0E;                            /* @asm 0x03121A */
        }
        (void)colour;
        hline(/* row cell at y, colour, region 0x2DA8 */); /* @asm 0x031247 0x181F:0x0CE */
        y += 0x13;                                        /* @asm 0x03124C row pitch 19 */
    }

    /* footer separator line */
    num_to_str((int)G16(0x2F5E));                         /* @asm 0x031264/0x031268 */
    draw_text_clip(/* footer (0xF,0xB3,0x132) */);        /* @asm 0x031272 0x181F:0x13C */

    if (input_enabled) {                                  /* @asm 0x03127A bp+4 */
        box_clear(/* input box (0xB3,0x140,0x15) */);     /* @asm 0x03128F 0x181F:0x0E2 */
    }
}

/* ============================================================================
 * func_031298  --  bar_geometry(grade, p3, count, base, &out0..&out6)
 *                                                          [REAL -- UI LAYOUT]
 *   @asm func_031298 @ file 0x031298..0x031365  (206 B, ENTER 8,0, RETF) [V]
 *
 * Computes the geometry of one horizontal BAR/METER in a report (score/economy
 * bars). Classifies a "grade" into bands and emits x/width plus a marker glyph
 * code. Pure layout math -> IN SCOPE.
 *
 * @asm:
 *   bp+6 grade, bp+8 base_x, bp+0xA min_count, bp+0xC step, bp+0xE &band,
 *   bp+0x10 &x, bp+0x12 &marker, bp+0x14 &w0, bp+0x16 &w1
 *   - *band(bp+0xE)=0; if (grade>=4) walk grade down by 4 then by 8 until <
 *     thresholds, incrementing *band each step                @asm 0x0312A2..0x0312E0
 *   - step_px = 0x10 >> *band  (sar)                           @asm 0x0312E5
 *   - width adj: band 0 -> += step(bp+0xC); band 2 -> +1        @asm 0x0312F5/0x031300
 *   - *w0=*w1=step_px                                           @asm 0x031303
 *   - *x = grade_low*width + base_x                             @asm 0x031310..0x031319
 *   - marker(bp+0x12): band 0 -> 0x92, band 1 -> 0x89, band 2 -> 0x84
 *     (switch on (*band) via 0x186A dec-chain)                  @asm 0x03135A
 * ============================================================================ */
void bar_geometry(int grade, int base_x, int min_count, int step,
                  int *band, int *x, int *marker, int *w0, int *w1)
{
    int g = grade;                                       /* @asm bp-2 */
    int low = 0;                                         /* @asm bp-8 */
    int step_px;

    *band = 0;                                           /* @asm 0x0312A7 */
    if (g < 4) {                                         /* @asm 0x0312AC */
        low = g;                                         /* @asm 0x0312B1 */
    } else {
        (*band)++;                                       /* @asm 0x0312B9 */
        g -= 4;                                          /* @asm 0x0312BB */
        while (g >= 8) { (*band)++; g -= 8; }            /* @asm 0x0312BF..0x0312D9 */
        low = g;                                         /* (residual band-low)  */
        (*band)++;                                       /* @asm 0x0312DB final inc */
    }

    step_px = 0x10 >> *band;                             /* @asm 0x0312E5 */
    *w0 = step_px;                                       /* @asm 0x0312EA bp-6 */
    *w1 = step_px;                                       /* @asm 0x0312ED bp-4 */
    if (*band == 0) *w1 = step_px + step;                /* @asm 0x0312F0/0x0312F5 */
    if (*band == 2) (*w1)++;                             /* @asm 0x0312FB/0x031300 */

    *x = low * (*w1) + base_x;                           /* @asm 0x031310..0x031319 */

    /* marker glyph per band */
    if (*band == 0)      *marker = 0x92;                 /* @asm 0x031326 */
    else if (*band == 1) *marker = 0x89;                 /* @asm 0x031330..0x03133F */
    else if (*band == 2) *marker = 0x84;                 /* @asm 0x031346..0x031353 */
    (void)min_count;
}

/* ============================================================================
 * func_031366  --  unit_cargo_row(unit_idx, x, y, w, &state) [REAL -- UI LAYOUT]
 *   @asm func_031366 @ file 0x031366..0x0314AD  (327 B, ENTER 0xA,0, RETF) [V]
 *   (auto stub captured only 229 B.)
 *
 * Draws one ship's cargo/passenger row: a sprite (the unit icon), label text,
 * and a per-good cargo bar. The composition + coordinates -> IN SCOPE.
 *
 * @asm:
 *   - cargo_row_decode(near 0x6DAF) fills locals: bp-0xA,bp-8,bp-6 (x/w/h),
 *     bp-2 (?), bp-4 (kind 0..3)                                @asm 0x03138D
 *   - if (kind(bp-4) >= 2) skip to tail @0x031930              @asm 0x031393
 *   - icon sprite: step 0x64>>kind ; sprite_blit(0x2BC) at x    @asm 0x0313A1..0x0313C2
 *   - only for SHIP unit (type 0x0D..0x12) AND kind==0 AND
 *     bp+0xC<2 AND UNIT.cargo_flag(+0x3150): draw cargo glyph
 *       glyph_value(0x181F:0xBE6) -> +0x17 ; box_fill(0x254)     @asm 0x0313C7..0x031417
 *   - kind tail (>=2): draw name text at x via sprite_blit2(0x2F8)
 *     using g_unit_name_tbl[type*7 - ... 0x5232 icon]            @asm 0x031420..0x03146D
 *   - if (bp+0x10 >= 0 && kind < 3) draw highlight hline(0xCE)   @asm 0x03146D..0x0314A6
 *   - (*state(bp+0xE))++                                          @asm 0x0314A6
 * ============================================================================ */
void unit_cargo_row(int unit_idx, int x, int y, int w, int *state)
{
    int kind;                                            /* @asm bp-4 */
    int rx, rw;                                          /* @asm bp-0xA, bp-6 */
    int type = UNIT(unit_idx)[0x02];                     /* @asm 0x0313C7 [+0x3146] */
    (void)y; (void)w;

    cargo_row_decode(/* unit_idx, &rx,&rw,&kind,... */); /* @asm 0x03138D near 0x6DAF */
    rx = 0; rw = 0; kind = 0; /* filled by leaf; modelled */

    if (kind >= 2) goto tail;                            /* @asm 0x031393 */

    /* unit icon sprite (size scales 0x64>>kind) */
    sprite_blit(/* x, sprite, 0x64>>kind */);            /* @asm 0x0313C2 0x181F:0x2BC */

    /* cargo glyph only for a ship with cargo, in the active column */
    if (type >= 0x0D && type <= 0x12 &&                  /* @asm 0x0313CB/0x0313D5 ship */
        kind == 0 &&                                     /* @asm 0x0313DF */
        /* bp+0xC < 2 */ 1 &&                            /* @asm 0x0313E8 */
        UNIT(unit_idx)[0x0C] != 0) {                     /* @asm 0x0313EE [+0x3150] cargo_flag */
        glyph_value(/* unit_idx */);                     /* @asm 0x031405 0x181F:0xBE6 */
        box_fill(/* x+0x17, region 0x2DA8 */);           /* @asm 0x031417 0x181F:0x254 */
    }

tail:
    /* name/label column (kind>=2 path) */
    if (kind < 3) {                                      /* @asm 0x031420 */
        sprite_blit2(/* name sprite g_unit_icon_tbl[type*7+0x5232] */); /* @asm 0x031468 0x181F:0x2F8 */
    }
    /* optional row highlight */
    if (/* bp+0x10 */ 1 && kind < 3) {                   /* @asm 0x03146D/0x031473 */
        hline(/* rx+rw highlight, region 0x2DAE */);     /* @asm 0x0314A1 0x181F:0xCE */
    }
    (*state)++;                                          /* @asm 0x0314A6 */
    (void)x; (void)rx; (void)rw;
}

/* ============================================================================
 * func_0314AE  --  column_rect(int col, int *x, int *y, int *w, int *h)
 *                                                          [REAL -- UI LAYOUT]
 *   @asm func_0314AE @ file 0x0314AE..0x0314DB  (46 B, push bp, RETF) [V]
 *
 * Returns the on-screen rectangle of report COLUMN `col`:
 *   x = 0x93 + col*0x0C  (147 + 12*col) ; y = 0xA5 (165) ; w = 0x0A ; h = 0x0C.
 * @asm 0x0314B1  ax=col; ax*=3 (shl+add); ax<<=2 (=col*12); add 0x93 -> *x
 *      0x0314C8  *y=0xA5 ; *w=0x0A ; *h=0x0C
 * ============================================================================ */
void column_rect(int col, int *x, int *y, int *w, int *h)
{
    *x = 0x93 + col * 0x0C;                               /* @asm 0x0314B1..0x0314C3 */
    *y = 0xA5;                                            /* @asm 0x0314C8 */
    *w = 0x0A;                                            /* @asm 0x0314CC */
    *h = 0x0C;                                            /* @asm 0x0314D3 */
}

/* ============================================================================
 * func_0314DC  --  unit_stack_panel(int input_enabled)  [REAL -- UI LAYOUT]
 *   @asm func_0314DC @ file 0x0314DC..0x0317CB  (752 B, ENTER 0x68,0, RET) [V]
 *   (auto stub captured only 211 B.)
 *
 * Draws the UNIT-STACK / passenger detail panel (frame, a 6-row table of items,
 * per-row unit icon + counts). Branches on g_detail_unit(0xFA2): list mode vs
 * single-unit-detail mode. Heavy layout -> IN SCOPE.
 *
 * Layout facts (byte-verified):
 *   - frame (0x3C,0x51,0x76,0x8F) via draw_window_frame(near 0x6DDC)  @asm 0x0314E1
 *   - LIST mode (g_detail_unit==0): loop slot 0..5
 *       report_row_cells(near 0x6D55) -> rect locals (bp-0x62..bp-0x56)
 *       box_fill(0x254) at slot row, base x 0x7B                       @asm 0x03152A..0x03155E
 *   - DETAIL mode (!=0): unit = list_unit_at(g_cursor_unit_a) (near 0x6E13)
 *       title string from g_unit_name_tbl[type*7+0x5230]; draw_text_at(0x100)
 *       if (type==0x0E) special label; then row table              @asm 0x031560..0x031631
 *   - inner per-slot loop (bp-0x5C 0..g_detail_unit): highlight colour
 *       0xA (==g_cursor_unit_a) or 0xF (flash gates 0x7EE/g_phase_9E3A==1/g_end_turn_btn==0/g_boycott_9E40)
 *       draw via draw_table_row(near 0x6E3B)                        @asm 0x031641..0x0316BB
 *   - second 6-slot loop draws cargo icons per unit using
 *       glyph_value(0xBE6)+order_assign(0xC68!) results             @asm 0x0316E1..0x0317A8
 *       NOTE @asm 0x031791 calls 0x181F:0xC68 -- this is func_030C68
 *       (order_assign) reused as a per-slot query.                  [V]
 *   - footer / input box if (input_enabled) via box_clear(0xE2)     @asm 0x0317B0
 * ============================================================================ */
void unit_stack_panel(int input_enabled)
{
    int slot;

    draw_window_frame(0x3C, 0x51, 0x76, 0x8F);           /* @asm 0x0314E1 near 0x6DDC */

    if (G16(0x0FA2) == 0) {                              /* @asm 0x0314F1 LIST mode */
        /* a header number (0x2DD0) drawn @asm 0x031501; then 6 item rows */
        for (slot = 0; slot < 6; slot++) {               /* @asm 0x031521 */
            int a, b, c, d;
            report_row_cells(slot, &a, &b, &c, &d);      /* @asm 0x03153E near 0x6D55 */
            box_fill(/* row rect, base x 0x7B, region 0x2DA8 */); /* @asm 0x031559 0x181F:0x254 */
        }
    } else {                                             /* @asm 0x031560 DETAIL mode */
        int unit = list_unit_at((int)G16(0x9E1C));       /* @asm 0x031565 near 0x6E13 */
        int type = UNIT(unit)[0x02];                     /* @asm 0x03158E [+0x3146] */
        /* title: special if escort/colonist type 0x0E */
        if (type != 0x0E) {                              /* @asm 0x031592 */
            str_begin(0, &g_word_table[0] /* 0x2DE8 */); /* @asm 0x03157A */
            str_append(0);                               /* @asm 0x03159F */
            /* name = g_unit_name_tbl[type*7 + 0x5230]   @asm 0x0315B9 */
        }
        draw_text_at(/* title at (0x45,0x78,0x51,0x8F) */); /* @asm 0x0315D7 0x181F:0x100 */

        if (type == 0x0E) {                              /* @asm 0x0315E3 */
            /* type-0x0E specific name + a second title line @asm 0x0315EA..0x031631 */
            draw_text_at(/* second title */);            /* @asm 0x031629 0x181F:0x100 */
        }

        /* per-slot highlighted rows */
        for (slot = 0; slot < (int)G16(0x0FA2); slot++) { /* @asm 0x0316C1 */
            int u = list_unit_at(slot);                  /* @asm 0x031646 near 0x6E13 */
            int colour = -1;                             /* @asm bp-0x68 = 0xFFFF */
            if (slot == (int)G16(0x9E1C) ||              /* @asm 0x031657 */
                slot == (int)G16(0x9E20)) {              /* @asm 0x03165F */
                if (slot == (int)G16(0x9E1C)) colour = 0x0A; /* @asm 0x03166A */
                if (G16(0x07EE) != 0 && G16(0x9E3A) == 1 &&  /* @asm 0x031671/0x031678 */
                    G16(0x9E28) == 0) colour = 0x0F;     /* @asm 0x03167F/0x031686 */
                if (G16(0x0F9A) == 1 && G16(0x9E40) != 0 &&  /* @asm 0x03168B/0x031692 */
                    slot == (int)G16(0x9E20)) colour = 0x0F; /* @asm 0x031699/0x0316A1 */
            }
            (void)u; (void)colour;
            draw_table_row(/* slot, colour, 2,5,marker,unit */); /* @asm 0x0316B8 near 0x6E3B */
        }

        /* second pass: cargo icons per slot (uses func_030C68/order_assign query) */
        for (slot = 0; slot < 6; slot++) {               /* @asm 0x031739 */
            int a, b, c, d;
            int cargo, q;
            report_row_cells(slot, &a, &b, &c, &d);      /* @asm 0x031753 near 0x6D55 */
            cargo = glyph_value(/* slot, unit */);       /* @asm 0x031780 0x181F:0xBE6 */
            q     = order_assign(0 /* per-slot query key TODO */);  /* @asm 0x031791 0x181F:0xC68 = func_030C68 */
            (void)cargo; (void)q; (void)a; (void)b; (void)c; (void)d;
            box_fill(/* icon cell */);                   /* @asm 0x03171C/0x031731 0x181F:0x254 */
        }
    }

    if (input_enabled) {                                 /* @asm 0x0317B0 bp+4 */
        box_clear(/* input box (0x76,0x51,0x3C,0x8F) */); /* @asm 0x0317C4 0x181F:0xE2 */
    }
}

/* ============================================================================
 * func_0317CC  --  military_list_panel(int input_enabled)  [REAL -- UI LAYOUT]
 *   @asm func_0317CC @ file 0x0317CC..0x0318D1  (261 B, ENTER 0x56,0, RETF) [V]
 *
 * Draws the MILITARY (army) list panel: frame, a title (nation + label), then
 * iterates two unit-owner classes drawing each as a table row.
 *
 * @asm:
 *   - frame (0x33,0x46,0x76,0x48) via draw_window_frame(near 0x6DDC)  @asm 0x0317D1
 *   - title text: label 0x2DCE (str_begin 0x16E) + draw_text_at(0x100) @asm 0x0317E3..0x031805
 *   - second label = g_str[active_power*0x34 + 0x5426] via strfmt 0x7A4 @asm 0x03180C
 *     then draw at x = 0x45 + font_line_h(0x89E byte0)                  @asm 0x031821..0x03183E
 *   - row x col = 0x49 (bp-0x54)
 *   - loop A: owner = active_power - 0x1C ; for each unit:
 *       draw_table_row(near 0x6E3B) with marker -1, 1, 0xD             @asm 0x03185A..0x031871
 *   - loop B: owner = active_power - 0x18 ; same                       @asm 0x031890..0x0318A7
 *   - if (input_enabled) box_clear(0xE2) at (0x76,0x46,0x33,0x48)      @asm 0x0318B6
 * ============================================================================ */
void military_list_panel(int input_enabled)
{
    int cur;

    draw_window_frame(0x33, 0x46, 0x76, 0x48);           /* @asm 0x0317D1 near 0x6DDC */

    /* title (label 0x2DCE) */
    str_begin(0, 0 /*0x2DCE*/);                          /* @asm 0x0317EB 0x181F:0x16E */
    draw_text_at(/* (0x45,0x78,0x46,0x48) */);           /* @asm 0x031800 0x181F:0x100 */
    /* nation label = g_str[power*0x34 + 0x5426] */
    strfmt_far(/* power*0x34 + 0x5426 */);               /* @asm 0x031819 0x0D1D:0x7A4 */
    draw_text_at(/* x = 0x45 + line_h */);               /* @asm 0x031839 0x181F:0x100 */

    /* loop A: owner class (power - 0x1C) */
    for (cur = func_0066CC_op_sz_57((uint16_t)((int)G16(0x9E12) - 0x1C),
                                    (uint16_t)((int)G16(0x9E12) - 0x1C));
                       /* 0x181F:0x7E0 tile head, AX=DX=power-0x1C @asm 0x031853 */
         cur >= 0; cur = unit_chain_next(cur)) {
        draw_table_row(/* -1,&row,1,0xD,col,cur */);     /* @asm 0x03186B near 0x6E3B */
    }
    /* loop B: owner class (power - 0x18) */
    for (cur = func_0066CC_op_sz_57((uint16_t)((int)G16(0x9E12) - 0x18),
                                    (uint16_t)((int)G16(0x9E12) - 0x18));
                       /* 0x181F:0x7E0 tile head, AX=DX=power-0x18 @asm 0x031888 */
         cur >= 0; cur = unit_chain_next(cur)) {
        draw_table_row(/* -1,&row,1,0xD,col,cur */);     /* @asm 0x0318A1 near 0x6E3B */
    }

    if (input_enabled)                                   /* @asm 0x0318B6 */
        box_clear(/* (0x76,0x46,0x33,0x48) */);          /* @asm 0x0318CA 0x181F:0xE2 */
}

/* ============================================================================
 * func_0318D2  --  naval_list_panel(int input_enabled)   [REAL -- UI LAYOUT]
 *   @asm func_0318D2 @ file 0x0318D2..0x0319A5  (211 B, ENTER 0x56,0, RETF) [V]
 *
 * Sibling of military_list_panel: the NAVAL list panel.
 * @asm:
 *   - frame (0x33,0x46,0x76,0x01) via draw_window_frame(near 0x6DDC)  @asm 0x0318D6
 *   - title: num_to_str(0x2DCC)+strcat_far(0x117E); draw_text_at(0x100) @asm 0x0318E5..0x031912
 *   - row col = 2 (bp-0x54)
 *   - loop A: owner = active_power - 0x10 ; draw_table_row(near 0x6E3B) @asm 0x03192E..0x031945
 *   - loop B: owner = active_power - 0x0C ; same                        @asm 0x031964..0x03197B
 *   - if (input_enabled) box_clear(0xE2) at (0x76,0x46,0x33,0x01)       @asm 0x03198A
 * ============================================================================ */
void naval_list_panel(int input_enabled)
{
    int cur;

    draw_window_frame(0x33, 0x46, 0x76, 0x01);           /* @asm 0x0318D6 near 0x6DDC */

    num_to_str((int)G16(0x2DCC));                        /* @asm 0x0318E5 0x181F:0x22 */
    strcat_far(NULL, NULL /* title TODO */);             /* @asm 0x0318F8 0x0D1D:0x117E */
    draw_text_at(/* (0x45,0x78,0x46,0x01) */);           /* @asm 0x03190D 0x181F:0x100 */

    for (cur = func_0066CC_op_sz_57((uint16_t)((int)G16(0x9E12) - 0x10),
                                    (uint16_t)((int)G16(0x9E12) - 0x10));
                       /* 0x181F:0x7E0 tile head, AX=DX=power-0x10 @asm 0x031927 */
         cur >= 0; cur = unit_chain_next(cur)) {
        draw_table_row(/* -1,&row,1,0xD,col=2,cur */);   /* @asm 0x03193F near 0x6E3B */
    }
    for (cur = func_0066CC_op_sz_57((uint16_t)((int)G16(0x9E12) - 0x0C),
                                    (uint16_t)((int)G16(0x9E12) - 0x0C));
                       /* 0x181F:0x7E0 tile head, AX=DX=power-0x0C @asm 0x03195C */
         cur >= 0; cur = unit_chain_next(cur)) {
        draw_table_row(/* -1,&row,1,0xD,col=2,cur */);   /* @asm 0x031975 near 0x6E3B */
    }

    if (input_enabled)                                   /* @asm 0x03198A */
        box_clear(/* (0x76,0x46,0x33,0x01) */);          /* @asm 0x03199E 0x181F:0xE2 */
}

/* ============================================================================
 * func_0319A6  --  panel_pair_0319A6(int arg)   [REAL, ported]
 *   @asm func_0319A6 @ file 0x0319A6..0x0319BB  (21 B, push bp, RETF) [V]
 *
 * Two-step helper: calls panel_helper_1E1D(arg) then panel_helper_1E6D(arg)
 * (both RTLink thunks). Likely "compute then draw" for one sub-panel.
 * @asm 0x0319A9 push arg; near 0x6E1D ; 0x0319B2 push arg; near 0x6E6D.
 * ============================================================================ */
void panel_pair_0319A6(int arg)
{
    panel_helper_1E1D(arg);                              /* @asm 0x0319AD near 0x6E1D */
    panel_helper_1E6D(arg);                              /* @asm 0x0319B6 near 0x6E6D */
}

/* ============================================================================
 * func_0319BC  --  meter_geometry(idx, base, &band, &x, &w0, &w1, &marker)
 *                                                          [REAL -- UI LAYOUT]
 *   @asm func_0319BC @ file 0x0319BC..0x031A31  (117 B, ENTER 8,0, RETF) [V]
 *   (auto stub captured 97 B.)
 *
 * Variant of bar_geometry with band thresholds 3/5 and column pitch 0x11 (17px),
 * width 0x10, markers 0x8A / 0xA1.  Pure layout math -> IN SCOPE.
 * @asm:
 *   bp+6 idx; classify: if (idx<3) low=idx; else band++ then while(>=5) ...  @asm 0x0319D0
 *   *w(bp+0x12)=*w(bp+0x10)=0x10                                              @asm 0x0319F3
 *   *x(bp+0xC) = low*0x11 + base(bp+8)                                        @asm 0x031A00
 *   marker(bp+0xE): band0->0x8A, band1->0xA1  (switch via 0x1F38 dec-chain)   @asm 0x031A28
 * ============================================================================ */
void meter_geometry(int idx, int base, int *band, int *x, int *w0, int *w1, int *marker)
{
    int g = idx;                                         /* @asm bp-2 */
    int low = 0;                                         /* @asm bp-8 */

    *band = 0;                                           /* @asm 0x0319CB */
    if (g < 3) {                                         /* @asm 0x0319D0 */
        low = g;                                         /* @asm 0x0319D5 */
    } else {
        (*band)++;                                       /* @asm 0x0319DD */
        g -= 3;                                          /* @asm 0x0319DF */
        while (g >= 5) { (*band)++; g -= 5; }            /* @asm 0x0319E3..0x0319EE */
        low = g;
        (*band)++;                                       /* @asm 0x0319EE final inc */
    }

    *w0 = 0x10;                                          /* @asm 0x0319F6 */
    *w1 = 0x10;                                          /* @asm 0x0319FB */
    *x  = low * 0x11 + base;                             /* @asm 0x031A00 col pitch 17 */

    if (*band == 0)      *marker = 0x8A;                 /* @asm 0x031A14 */
    else if (*band == 1) *marker = 0xA1;                 /* @asm 0x031A1E */
}

/* ============================================================================
 * func_031A32  --  unit_icon_row(unit_idx, x, &state, draw_flag) [REAL -- LAYOUT]
 *   @asm func_031A32 @ file 0x031A32..0x031AF9  (199 B, ENTER 0xA,0, RETF) [V]
 *
 * Sibling of unit_cargo_row (func_031366): draws one unit's icon + optional
 * cargo glyph + optional highlight, on a different panel. Composition+coords ->
 * IN SCOPE.
 * @asm:
 *   - cargo_row_decode(near 0x6D9B) fills rect locals + kind(bp-4)   @asm 0x031A53
 *   - if (kind<2): sprite_blit(0x2BC) icon at x with size 0x64        @asm 0x031A5F..0x031A6E
 *   - ship (type 0x0D..0x12) AND kind==0 AND UNIT.cargo_flag(+0x3150):
 *       glyph_value(0xBE6)+0x17 ; box_fill(0x254)                     @asm 0x031A73..0x031AB4
 *   - if (draw_flag(bp+0xC) >= 0 && kind<2): hline(0xCE) highlight    @asm 0x031AB9..0x031AED
 *   - (*state(bp+0xA))++                                              @asm 0x031AF2
 * ============================================================================ */
void unit_icon_row(int unit_idx, int x, int *state, int draw_flag)
{
    int kind = 0;                                        /* @asm bp-4 (from decode) */
    int type = UNIT(unit_idx)[0x02];                     /* @asm 0x031A73 [+0x3146] */

    cargo_row_decode(/* unit_idx, ..., &kind */);        /* @asm 0x031A53 near 0x6D9B */

    if (kind < 2) {                                      /* @asm 0x031A59 */
        sprite_blit(/* x, sprite, size 0x64 */);         /* @asm 0x031A6E 0x181F:0x2BC */
        if (type >= 0x0D && type <= 0x12 &&              /* @asm 0x031A77/0x031A7E ship */
            kind == 0 &&                                 /* @asm 0x031A85 */
            UNIT(unit_idx)[0x0C] != 0) {                 /* @asm 0x031A8B [+0x3150] cargo_flag */
            glyph_value(/* unit_idx */);                 /* @asm 0x031AA2 0x181F:0xBE6 */
            box_fill(/* x+0x17, region 0x2DA8 */);       /* @asm 0x031AB4 0x181F:0x254 */
        }
    }
    if (draw_flag >= 0 && kind < 2) {                    /* @asm 0x031AB9/0x031ABF */
        hline(/* highlight, region 0x2DAE */);           /* @asm 0x031AED 0x181F:0xCE */
    }
    (*state)++;                                          /* @asm 0x031AF2 */
    (void)x;
}

/* ============================================================================
 * func_031AFA  --  cargo_list_panel(int input_enabled)   [REAL -- UI LAYOUT]
 *   @asm func_031AFA @ file 0x031AFA..0x031BAF  (182 B, ENTER 8,0, RETF) [V]
 *
 * The CARGO/ship-hold list panel: frame, iterate the active power's SHIP units,
 * draw each as a list row with selected/flash highlight.
 * @asm:
 *   - frame (0x3B,0x60,0x78,0xE0) via draw_window_frame(near 0x6DDC)  @asm 0x031AFE
 *   - row x = 0xE9 (bp-4)
 *   - for each unit of (active_power - 0x14):
 *       if (type 0x0D..0x12 ship):
 *         colour = -1; if (g_ship_cursor(0x9E2C)==row) colour=0xA;
 *         flash gates 0x7EE/g_phase_9E3A==4 or g_report_panel==2/g_boycott_9E40 -> colour 0xF;
 *         draw_list_row2(near 0x6E04)                                  @asm 0x031B28..0x031B83
 *   - if (input_enabled) box_clear(0xE2) at (0x78,0x60,0x3B,0xE0)      @asm 0x031B95
 * ============================================================================ */
void cargo_list_panel(int input_enabled)
{
    int row = 0;                                         /* @asm bp-2 */
    int cur;

    draw_window_frame(0x3B, 0x60, 0x78, 0xE0);           /* @asm 0x031AFE near 0x6DDC */

    for (cur = unit_first_of_owner((int)G16(0x9E12) - 0x14); /* @asm 0x031B18 */
         cur >= 0; cur = unit_chain_next(cur)) {
        int type = UNIT(cur)[0x02];                      /* @asm 0x031B28 */
        if (type >= 0x0D && type <= 0x12) {              /* @asm 0x031B2B/0x031B32 ship */
            int colour = -1;                             /* @asm bp-8 = 0xFFFF */
            if (G16(0x9E2C) == row) {                    /* @asm 0x031B41 g_ship_cursor */
                colour = 0x0A;                           /* @asm 0x031B47 */
                if (G16(0x07EE) != 0 && G16(0x9E3A) == 4)/* @asm 0x031B4C/0x031B53 */
                    colour = 0x0F;                       /* @asm 0x031B5A */
                if (G16(0x0F9A) == 2 && G16(0x9E40) != 0)/* @asm 0x031B5F/0x031B66 */
                    colour = 0x0F;                       /* @asm 0x031B6D */
            }
            (void)colour;
            draw_list_row2(/* colour, &row, x=0xE9, cur */); /* @asm 0x031B80 near 0x6E04 */
        }
        row++;                                           /* via bp-2 increment in row helper */
    }

    if (input_enabled)                                   /* @asm 0x031B95 */
        box_clear(/* (0x78,0x60,0x3B,0xE0) */);          /* @asm 0x031BA9 0x181F:0xE2 */
}

/* ============================================================================
 * func_031BB0  --  num_badge_metrics(int value, int *w_out, int *y_out)
 *                                                          [REAL -- UI LAYOUT]
 *   @asm func_031BB0 @ file 0x031BB0..0x031BE5  (54 B, ENTER 2,0, RET) [V]
 *
 * Helper for func_031BE6: formats `value` to text, measures its pixel width,
 * and returns layout metrics for centring a number inside a badge.
 *   *w_out = str_width(num_to_str(value))                 @asm 0x031BB4/0x031BC1
 *   (caller also passes a 3rd out, set to a const) -- @asm writes:
 *     [bp+6] = width ; [bp+8] = 0x25 ; [bp+0xA] = (font_line_h - 1) + 4
 * @asm 0x031BCB  al = byte[*0x89E] (line height) ; dec ; +4 -> [bp+0xA]
 * ============================================================================ */
void num_badge_metrics(int value, int *w_out, int *y_out)
{
    long s = num_to_str(value);                          /* @asm 0x031BB7 0x181F:0x22 */
    int  line_h = *(*(unsigned char **)0x089E);          /* @asm 0x031BCB byte[*0x89E] */
    *w_out = str_width((const char *)(unsigned)s);       /* @asm 0x031BC1 0x181F:0x114 */
    /* @asm 0x031BD8 the middle out is set to 0x25 by the caller frame */
    *y_out = (line_h - 1) + 4;                           /* @asm 0x031BD4/0x031BDC */
}

/* ============================================================================
 * func_031BE6  --  beveled_num_cell(int value, int x, int y, int mode) -> height
 *   @asm func_031BE6 @ file 0x031BE6..0x031DC7  (481 B, ENTER 0xB6,0, RET) [V]
 *
 * Draws a beveled numeric CELL/badge (a 3-D button showing a number) and RETURNS
 * its text height (ax = [bp-0xAE]).  Colours and bevel direction depend on `mode`
 * bit0 (raised vs sunken); bit1 selects the "no-bevel" variant.  This IS layout/
 * widget composition -> IN SCOPE.
 *
 * ABI CORRECTION (byte-verified from the bp+ reads): the auto-port typed this as
 *   void beveled_num_cell(mode,x,y) -- WRONG.  The real args are
 *   value=[bp+4], x=[bp+6], y=[bp+8], mode=[bp+0xA] (FOUR words) and it returns
 *   an int height in ax (used by func_031DC8 to advance its row cursor).
 *
 * @asm:
 *   - mode([bp+0xA]) bit0 picks the colour set (raised: fg0/edge0x30/text0x39/
 *     light7 ; sunken: fg0xF/edge0x39/text0x30/light0xE)          @asm 0x031BEC..0x031C24
 *   - num_badge_metrics(value=[bp+4], &w, &h0) via near 0x031BB0   @asm 0x031C3A
 *   - cell x = (w_text - w)/2 + x([bp+6]) ; cell y = y([bp+8])+2    @asm 0x031C40..0x031C55
 *   - if (mode bit1 == 0) draw 4 bevel edges:
 *       edge_light(0x191F:0x8BC) x2 (top + left) ;
 *       edge_shadow(0x191F:0x8B2) x2 (bottom + right)              @asm 0x031C62..0x031D04
 *     and if light-colour>=0 a final box_bevel(0x181F:0xBA)        @asm 0x031D09..0x031D3A
 *   - number text: num_to_str(value)+strcat_far(0x117E); if a 2nd
 *     token via 0x0D1D:0x842/0x7E4 ; draw via draw_text_clip(0x13C)
 *     twice (shadow + face); RETURN the second draw's height       @asm 0x031D3F..0x031DBF
 * ============================================================================ */
int beveled_num_cell(int value, int x, int y, int mode)
{
    char buf[0x52];                                      /* @asm bp-0x56 number text */
    int  fg, edge, text_col, light;                      /* colour set */
    int  w = 0, h0 = 0;
    int  cell_x, cell_y;

    if (mode & 1) {                                      /* @asm 0x031BEC raised */
        fg = 0x00; light = 0x0F; edge = 0x30; text_col = 0x39; /* @asm 0x031BF4..0x031C08 */
        (void)light; light = 7;                          /* @asm 0x031C08 light=7 */
    } else {                                             /* @asm 0x031C10 sunken */
        fg = 0x0F; light = -1; edge = 0x39; text_col = 0x30;   /* @asm 0x031C10..0x031C20 */
        light = 0x0E;                                    /* @asm 0x031C24 */
    }
    (void)fg;

    num_badge_metrics(value, &w, &h0);                   /* @asm 0x031C3A near 0x031BB0 (&w = [bp-0xAE]) */
    cell_x = (/*w_text*/0 - w) / 2 + x;                  /* @asm 0x031C40..0x031C4C */
    cell_y = y + 2;                                      /* @asm 0x031C50 */
    (void)cell_x; (void)cell_y;

    if ((mode & 2) == 0) {                               /* @asm 0x031C59 bevel variant */
        edge_light(/* top edge, colour text_col */);     /* @asm 0x031C8A 0x191F:0x8BC */
        edge_shadow(/* right edge */);                   /* @asm 0x031CB8 0x191F:0x8B2 */
        edge_light(/* left edge, colour edge */);        /* @asm 0x031CDE 0x191F:0x8BC */
        edge_shadow(/* bottom edge */);                  /* @asm 0x031D04 0x191F:0x8B2 */
        if (light >= 0) {                                /* @asm 0x031D09 */
            box_bevel(/* inner highlight, colour light */); /* @asm 0x031D3A 0x181F:0xBA */
        }
    }

    /* number text (shadow + face) */
    num_to_str(value);                                   /* @asm 0x031D42 0x181F:0x22 */
    strcat_far(NULL, buf);                               /* @asm 0x031D51 0x0D1D:0x117E */
    /* optional second token @asm 0x031D5D 0x0D1D:0x842 -> 0x7E4 */
    draw_text_clip(/* buf, edge colour (shadow) */);     /* @asm 0x031DA2 0x181F:0x13C */
    draw_text_clip(/* buf, text_col (face) */);          /* @asm 0x031DB4 0x181F:0x13C ([bp-4]=h) */
    (void)edge; (void)text_col;
    return w;                                            /* @asm 0x031DBF mov ax,[bp-0xAE] (cell width) */
}

/* ============================================================================
 * func_031DC8  --  beveled_cell_grid(int redraw)   [REAL -- UI LAYOUT]
 *   @asm func_031DC8 @ file 0x031DC8..0x031E4B  (132 B, ENTER 0xA,0, near RET) [V]
 *
 * EXTENT CORRECTION (byte-verified): the auto stub claimed "real size 351 B,
 * truncated at file-range end 0x031E4C" and that the tail ported in the next
 * overlay file.  WRONG: this function ends at a NEAR `ret` @0x031E4B (132 bytes,
 * fully inside this file).  The "351 B / spill" reading swept in the SEPARATE
 * function that begins at 0x031E4C.  No body spills anywhere; the complete grid
 * loop is reproduced below.
 *
 * Draws the right-side panel of three stacked beveled numeric cells.  arg0
 * ([bp+4], `redraw`) when nonzero clears the panel rectangle afterwards.
 * @asm:
 *   - frame (0x20,0x25,0x59,0x119) via draw_window_frame(near 0x6DDC)  @asm 0x031DD6
 *   - cell origin x=0x119 ([bp-2]), y=0x59 ([bp-4]), idx=0 ([bp-6])    @asm 0x031DDC..0x031DE6
 *   - for idx=0..2 (@0x031DEB loop, JL 0x031DEB @0x031E2F):
 *       highlight = (idx == [0x9E2E] && [0x07EE] != 0 && g_phase_9E3A == 5)
 *                                                                      @asm 0x031DF0..0x031E07
 *       h = beveled_num_cell(table_93D8[idx], x, y, highlight)         @asm 0x031E0C..0x031E20
 *           (table at DGROUP 0x93D8 = {0x1430,0x143E,0x1430})          @asm 0x031E19 [bx-0x6C28]
 *       y += h + 2                                                     @asm 0x031E23..0x031E25
 *   - if (redraw != 0) box_clear(0x119,0x59,0x20,0x25) via 0x181F:0xE2 @asm 0x031E31..0x031E45
 * ============================================================================ */
void beveled_cell_grid(int redraw)
{
    static const int cell_value[3] = { 0x1430, 0x143E, 0x1430 };  /* DGROUP 0x93D8 */
    int x = 0x119;                                       /* @asm 0x031DDC [bp-2] */
    int y = 0x59;                                        /* @asm 0x031DE1 [bp-4] */
    int idx;                                             /* @asm 0x031DE6 [bp-6] */

    draw_window_frame(0x20, 0x25, 0x59, 0x119);          /* @asm 0x031DD6 near 0x6DDC */

    for (idx = 0; idx < 3; idx++) {                      /* @asm 0x031DE6/0x031E2B..0x031E2F JL */
        int highlight = 0;                               /* @asm 0x031DEB [bp-8]=0 */
        if (idx == (int)G16(0x9E2E) &&                   /* @asm 0x031DF0/0x031DF3 JNE */
            G16(0x07EE) != 0 &&                          /* @asm 0x031DF9 JE  */
            G16(0x9E3A) == 5)                            /* @asm 0x031E00 JNE */
            highlight = 1;                               /* @asm 0x031E07 */
        y += beveled_num_cell(cell_value[idx], x, y, highlight) + 2;
                                                         /* @asm 0x031E1D near 0x031BE6; ret+2 @0x031E23 */
    }

    if (redraw != 0)                                     /* @asm 0x031E31 JE 0x031E4A */
        box_clear(/* 0x119,0x59,0x20,0x25 */);           /* @asm 0x031E45 0x181F:0xE2 */
}
