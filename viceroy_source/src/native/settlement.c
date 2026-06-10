/* ============================================================================
 *           >>> NATIVE SETTLEMENT LIFECYCLE — BYTE_VERIFIED <<<
 * ----------------------------------------------------------------------------
 * The add / remove+compact / count mechanics of the 18-byte NativeSettlement
 * table are byte-traced against VICEROY.EXE.  The per-turn growth/raid/gift
 * tick and the player-interaction helpers below are NOT byte-traced — those
 * are clearly marked RECONSTRUCTED/left unresolved inline.
 *
 * TABLE (BYTE_VERIFIED — docs/RULINGS.md 2026-05-28):
 *   base   DGROUP:0x54EC   stride 0x12 (18 bytes)   live-count DGROUP:0x539A
 *   max    84 (0x54)
 *   fields +0x00 x  +0x01 y  +0x02 owner  +0x04 pop  +0x05 mission(0x10|owner)
 *
 * @verified_by  Hand-decompiled from the RE-SEGMENTED overlay dump
 *               (reverse_engineered/code/VICEROY/disasm_overlay_reseg/) 2026-05-29.
 *               String segment base = file 0x1D9A0 (CHIEFKILL @seg 0x1668 =
 *               file 0x1F008; BURNED @seg 0x1C28 = file 0x1F5C8).
 * ============================================================================ */
#include "viceroy_types.h"
#include "native.h"

/* ----------------------------------------------------------------------------
 * Globals (BYTE_VERIFIED bases)
 * ---------------------------------------------------------------------------- */
extern uint8_t  g_native_table_54EC[];   /* DGROUP:0x54EC — NativeSettlement[] base, stride 0x12 */
extern int16_t  g_native_count_539A;     /* DGROUP:0x539A — live settlement count (word, max 0x54) */
extern int16_t  g_unit_count_539C;       /* DGROUP:0x539C — live UNIT count (word, ×0x1C) */
extern void *   g_cur_settlement_8D4A;   /* DGROUP:0x8D4A — far ptr to "settlement being built" record */
extern void *   g_cur_settlement_8D4E;   /* DGROUP:0x8D4E — far ptr to "settlement being removed" record */
extern void *   g_tribe_ptr_8D52;        /* DGROUP:0x8D52 — far ptr into per-tribe record (settlement-count byte @ -0x69D6) */

/* Forward declarations for resident helpers called in this TU. */
extern uint8_t  settlement_initial_population(int settlement_index);
extern void     map_mark_settlement_tile(int x, int y, int owner);
extern uint8_t *unit_record(int index);
extern void     unit_detach_from_settlement(int unit_index);
extern uint8_t  native_class_weight_5AD8[];  /* DGROUP:0x5AD8 per-class weight table */
extern uint32_t game_random_range(uint32_t lo, uint32_t hi);
extern void     native_tribe_announce_extinction(void);
extern void     spawn_indian_convert(int settlement_index);

/* RUNTIME_ONLY: loaded from NAMES.TXT / data files — NOT from VICEROY.EXE bytes */
#define NATIVE_GROWTH_PCT    20  /* placeholder — real value from NAMES.TXT          */
#define MISSION_CONVERT_PCT  30  /* placeholder — real value from NAMES.TXT          */

/* ============================================================================
 * native_settlement_add — BYTE_VERIFIED
 *
 * @asm_function  func_046E18  (file 0x046E18..0x046EBE, 167 bytes)
 * @asm_disasm    disasm_overlay_reseg/page_0C.asm (page 0x0C, code_base 0x46DE0)
 *
 * Args (caller PUSH order, RTL):
 *   [BP+6]  = owner    (tribe id)          -> record +0x02
 *   [BP+8]  = x        (map column)        -> record +0x00
 *   [BP+0xA]= y        (map row)           -> record +0x01
 *
 * Allocation: returns 0xFFFF if the table is full (count >= 84); otherwise the
 * new slot index = count, and count is incremented.
 *
 *   @asm 0x46E21  cmp  word [0x539A], 0x54      ; 84-slot cap
 *   @asm 0x46E26  jl   alloc
 *   @asm 0x46E28  jmp  full (return 0xFFFF)
 *   @asm 0x46E2B  mov  ax, [0x539A]             ; new index = current count
 *   @asm 0x46E2E  inc  word [0x539A]            ; count++   (the documented INC site)
 *
 * Field writes (via the [0x8D4A] "current settlement" far ptr, which the
 * preceding LCALL 0x181F:0xA4C resolves to &table[new_index]):
 *   @asm 0x46E4D..0x46E5F  [bx+2]=owner([BP+6]) ; [bx]=x([BP+8]) ; [bx+1]=y([BP+0xA])
 *   @asm 0x46E66  call 0x5434 -> AL             ; initial population
 *   @asm 0x46E70  [bx+4] = population
 *   @asm 0x46E77  [bx+5] = 0xFF                 ; mission = none
 *   @asm 0x46E7B  [bx+6] = 0
 *   @asm 0x46EA3  imul bx,[bp-2],0x12 ; [bx+0x54EF]=0 (re-based +0x03 flags)
 *   @asm 0x46EAE  [bx+0x54F3..0x54F5] = 0xFF     ; +0x07..+0x09 cleared
 * Also registers the tile on the map (LCALL 0x181F:0x740 / OR es:[bx],2 marks
 * the map cell as settled) and resolves the world coord (LCALL 0x181F:0x704).
 * ============================================================================ */
int native_settlement_add(int owner, int x, int y)
{
    /* @asm 0x46E1C — default return = 0xFFFF (table full) */
    int16_t new_index = (int16_t)0xFFFF;

    /* @asm 0x46E21..0x46E2E — 84-slot cap, then claim slot = count, count++ */
    if (g_native_count_539A >= 0x54)
        return new_index;
    new_index = g_native_count_539A;
    g_native_count_539A++;

    /* @asm 0x46E4D..0x46E5F — first three fields (resolved ptr @0x8D4A) */
    uint8_t *rec = (uint8_t *)g_cur_settlement_8D4A;
    rec[0x02] = (uint8_t)owner;     /* +0x02 owner  */
    rec[0x00] = (uint8_t)x;         /* +0x00 x      */
    rec[0x01] = (uint8_t)y;         /* +0x01 y      */

    /* @asm 0x46E66..0x46E7B — population (call 0x5434), mission=none, +6=0 */
    rec[0x04] = settlement_initial_population(new_index);  /* CALL near 0x5434 */
    rec[0x05] = 0xFF;               /* +0x05 mission flag — none */
    rec[0x06] = 0;

    /* @asm 0x46EA3..0x46EB6 — re-based clears on the NEW index */
    {
        uint8_t *r2 = &g_native_table_54EC[new_index * NATIVE_SETTLEMENT_STRIDE];
        r2[0x03] = 0;               /* +0x03 flags */
        r2[0x07] = 0xFF;
        r2[0x08] = 0xFF;
        r2[0x09] = 0xFF;
    }

    /* @asm 0x46E7F..0x46E9E — mark the map tile as settled / resolve coord
     * (LCALL 0x181F:0x740 then OR es:[bx],2 ; LCALL 0x181F:0x704). Side effect. */
    map_mark_settlement_tile(x, y, owner);

    return new_index;
}

/* settlement_initial_population / map_mark_settlement_tile forward-declared above. */

/* ============================================================================
 * native_settlement_remove — BYTE_VERIFIED (add/remove/compact)
 *
 * @asm_function  func_046EC0  (file 0x046EC0..0x046FC1, 258 bytes)
 * @asm_disasm    disasm_overlay_reseg/page_0C.asm
 *
 * Arg: [BP+6] = index of the settlement to remove.
 *
 * STEP 1 — detach units linked to this settlement
 *   @asm 0x46EED..0x46F32  loop i = unit_count-1 .. 0 (stride 0x1C):
 *     - units with owner-nibble [bx+0x3147]&0xF >= 4 whose link byte
 *       [bx+0x314A] == removed_index get detached (LCALL 0x181F:0x808);
 *     - units of lower owners with the same link get their [bx+0x314A]
 *       decremented (it is a settlement index that must shift down too).
 *
 * STEP 2 — COMPACT the table (the core lifecycle proof)
 *   @asm 0x46F3C..0x46F5B  loop i = removed_index .. count-2:
 *       imul bx,[bp-2],0x12        ; bx = i*0x12
 *       lea  di,[bx+0x54EC]        ; dest = &table[i]
 *       lea  si,[bx+0x54FE]        ; src  = &table[i+1]  (0x54FE-0x54EC = 0x12)
 *       mov  cx,9 ; rep movsw      ; copy 9 words = 18 bytes (one record down)
 *   @asm 0x46F5D  dec word [0x539A] ; count--   (the documented DEC site)
 *
 * STEP 3 — per-tribe bookkeeping / elimination
 *   @asm 0x46F61..0x46F65  bx = [0x8D52] ; dec byte [bx-0x69D6]  ; tribe's
 *                          settlement count--.
 *   @asm 0x46F69  je 0x992 -> tribe is ELIMINATED (no settlements left):
 *       @asm 0x46F92  [tribe+3] |= 0x80  (eliminated flag on tribe record
 *                     @0x8D4E) + cleanup thunks (0x181F:0x9A4 / 0x438 / 0x652).
 *   @asm 0x46F6B..0x46F8A  ELSE (tribe survives): scale the removed settlement's
 *       [si+8] (byte) and [si+0xA] (word) DOWN in proportion to the remaining
 *       settlement count.  The byte-exact arithmetic (CORRECTED 2026-05-30 — the
 *       earlier "spread evenly across the remaining settlements" was a
 *       misreading; the code modifies the REMOVED record in place):
 *         si = [0x8D4E]                         ; the removed settlement record
 *         n  = byte [tribe-0x69D6]              ; remaining count (post-decrement)
 *         cx = 0xFFFF - n                       ; = -(n+1) as a SIGNED word
 *         [si+8]   += sign_extend([si+8])   / cx   ; (cdq; idiv cx) byte field
 *         [si+0xA] += [si+0xA]              / cx   ; (cdq; idiv cx) word field
 *       Because cx = -(n+1), `field += field/(-(n+1))` == `field - field/(n+1)`
 *       == `field * n/(n+1)`: each field is scaled down by n/(n+1).  (si = the
 *       removed record, which the table compaction in STEP 2 leaves as a stale
 *       tail copy; this scaling runs on that record before the slot is reused.)
 * ============================================================================ */
void native_settlement_remove(int index)
{
    /* @asm 0x46EED..0x46F32 — STEP 1: fix up unit links (stride 0x1C). */
    for (int i = g_unit_count_539C - 1; i >= 0; i--) {
        uint8_t *u = unit_record(i);          /* &UnitRecord[i] (base 0x3144) */
        if ((u[0x03] & 0x0F) >= 4) {          /* @asm 0x46F14..0x46F1C owner>=4 */
            if (u[0x06] == (uint8_t)index)    /* @asm 0x46F21 link byte +0x06(0x314A) */
                unit_detach_from_settlement(i);   /* LCALL 0x181F:0x808 */
        } else if (u[0x06] > (uint8_t)index) {    /* @asm 0x46EFD..0x46F03 */
            u[0x06]--;                            /* shift link index down */
        }
    }

    /* @asm 0x46F3C..0x46F5B — STEP 2: COMPACT (shift records [i+1] -> [i]). */
    for (int i = index; i < g_native_count_539A - 1; i++) {
        uint8_t *dst = &g_native_table_54EC[i * NATIVE_SETTLEMENT_STRIDE];
        uint8_t *src = dst + NATIVE_SETTLEMENT_STRIDE;        /* +0x12 */
        for (int b = 0; b < NATIVE_SETTLEMENT_STRIDE; b++)    /* rep movsw, 9 words */
            dst[b] = src[b];
    }

    /* @asm 0x46F5D — count-- */
    g_native_count_539A--;

    /* @asm 0x46F61..0x46F8A — STEP 3: per-tribe count-- then eliminate-or-scale.
     * @asm 0x46F65 dec byte [bx-0x69D6] (bx=[0x8D52]) ; @asm 0x46F69 je eliminate. */
    if (tribe_settlement_count_dec(g_tribe_ptr_8D52) == 0) {
        native_tribe_eliminate(g_cur_settlement_8D4E);    /* @0x46F92 sets +3 |= 0x80 */
    } else {
        native_tribe_redistribute(g_cur_settlement_8D4E,
                                  g_tribe_ptr_8D52);      /* @0x46F6B scale +8/+0xA down */
    }
}


/* ============================================================================
 * tribe_settlement_count_dec — BYTE_VERIFIED
 *
 * @asm 0x46F61  mov bx,[0x8D52]            ; bx = current tribe record ptr
 * @asm 0x46F65  dec byte [bx-0x69D6]       ; tribe's settlement count--
 * @asm 0x46F69  je  eliminate              ; ZF set (==0) -> tribe eliminated
 *
 * [bx-0x69D6] is the per-tribe settlement-count byte (the tribe record ptr at
 * 0x8D52 points 0x69D6 past it).  Returns the post-decrement count.
 * ============================================================================ */
int tribe_settlement_count_dec(void *tribe_ptr)
{
    uint8_t *cnt = (uint8_t *)tribe_ptr - 0x69D6;   /* @asm [bx-0x69D6] */
    return (int)(--(*cnt));
}

/* ============================================================================
 * native_tribe_eliminate — BYTE_VERIFIED (flag); cleanup thunks ANCHOR_VERIFIED
 *
 * @asm 0x46F92  mov bx,[0x8D4E]            ; the removed settlement record
 * @asm 0x46F96  or  byte [bx+3],0x80       ; +0x03 |= 0x80  (tribe eliminated flag)
 * @asm 0x46F9A..0x46FBB  follow-up overlay calls (announce extinction):
 *        push [0x8D50]; LCALL 0x181F:0x9A4 -> AX                 ; power_handle(tribe_power_index)
 *                                                                 ;   per overlay_046D70_04C2E1.c
 *        push AX; push 0; LCALL 0x181F:0x438                     ; (string/event dispatch;
 *                                                                 ;   body in thunk page)
 *        push 3; push 0x14D4; LCALL 0x181F:0x652                 ; emit message @seg 0x14D4
 *                                                                 ;   (screen-clear/draw; body in thunk page)
 *      (0x14D4 string id + the three thunks are ANCHOR_VERIFIED via the call
 *       sites; thunk bodies in thunk page.)
 * ============================================================================ */
void native_tribe_eliminate(void *settlement_record)
{
    ((uint8_t *)settlement_record)[0x03] |= 0x80;   /* @asm 0x46F96 or [bx+3],0x80 */
    native_tribe_announce_extinction();             /* @asm 0x46F9A..0x46FBB (thunks) */
}

/* ============================================================================
 * native_tribe_redistribute — BYTE_VERIFIED arithmetic
 *
 * Scales the removed settlement's +0x08 (byte) and +0x0A (word) fields DOWN by
 * n/(n+1), where n = the tribe's remaining settlement count.  See the @asm
 * walkthrough in native_settlement_remove's banner (0x46F6B..0x46F8A).  The
 * divisor cx = 0xFFFF - n is -(n+1) as a signed word; adding field/cx therefore
 * subtracts field/(n+1).
 * ============================================================================ */
void native_tribe_redistribute(void *settlement_record, void *tribe_ptr)
{
    uint8_t  *rec = (uint8_t *)settlement_record;   /* si = [0x8D4E] */
    uint8_t   n   = ((uint8_t *)tribe_ptr)[-0x69D6]; /* @asm dl = byte [bx-0x69D6] */
    int16_t   cx  = (int16_t)(0xFFFF - n);          /* @asm cx = 0xFFFF - n = -(n+1) */

    /* @asm 0x46F6F..0x46F81 — byte field: [si+8] += (int8)[si+8] / cx */
    int8_t   *b8  = (int8_t *)&rec[0x08];
    *b8 = (int8_t)(*b8 + (int8_t)((int16_t)*b8 / cx));

    /* @asm 0x46F84..0x46F8A — word field: [si+0xA] += [si+0xA] / cx */
    int16_t  *w0A = (int16_t *)&rec[0x0A];
    *w0A = (int16_t)(*w0A + (*w0A / cx));
}

/* ============================================================================
 * native_settlement_value_for_display — BYTE_VERIFIED
 *
 * @asm_function  func_046DE0  (file 0x046DE0..0x046E17, 56 bytes)
 *
 * Computes a per-settlement "value" used by the UI from two byte fields and a
 * per-class multiplier:
 *   class    = record[+0x02]        ; (read as [bx+0x54EE])
 *   tribe_w  = byte[0x5AD8 + (class-4)*0x4E]   ; per-(class-4) table
 *   value    = tribe_w*2 + 3
 *   if (record[+0x03] & 4)          ; (test [bx+0x54EF],4)
 *       value = tribe_w + value + 1
 *
 * Confirms: stride 0x12 (imul *,0x12), field +0x02 @0x54EE, flag field +0x03
 * @0x54EF with bit 0x04 used as a "developed/visited" modifier.
 * ============================================================================ */
int native_settlement_value_for_display(int index)
{
    uint8_t *rec = &g_native_table_54EC[index * NATIVE_SETTLEMENT_STRIDE];
    int      cls = rec[0x02];                                    /* +0x02 */
    int      tribe_w = native_class_weight_5AD8[(cls - 4) * 0x4E]; /* @0x5AD8 */
    int      value = tribe_w * 2 + 3;
    if (rec[0x03] & 0x04)                                        /* +0x03 bit 4 */
        value = tribe_w + value + 1;
    return value;
}

/* ============================================================================
 *                  >>> RECONSTRUCTED below this line — NOT BYTE-VERIFIED <<<
 * ----------------------------------------------------------------------------
 * The per-turn settlement tick and the player-interaction handlers below are
 * carried over from the prior reconstruction.  They have NOT been byte-traced.
 * The numeric rates (NATIVE_GROWTH_PCT, MISSION_CONVERT_PCT, attitude deltas,
 * tribute formulas) are NOT in VICEROY.EXE as literals — most native behaviour
 * tables load from NAMES.TXT @TRIBES / TRIBE.TXT at runtime, and the per-turn
 * scoring crosses RTLink overlay thunks.  Treat every number here as RUNTIME_ONLY
 * (NAMES.TXT/data-file) — no static EXE values.
 *
 * What IS anchored: the in-game settlement scoring/attitude builder is
 * func at file 0x048AE0+ in page_0C (pushes the "MISSION0" message key
 * @seg 0x1532); it reads the current settlement via [0x8D4A], tests the
 * +0x03 bit-4 flag, and clamps a 0..3 level from thresholds at -5 / 0 / 10.
 * The numeric attitude deltas it feeds, however, are not byte-resolved.
 * ============================================================================ */

void native_tick_all(void)
{
    /* @asm-anchored loop shape: iterate g_native_count_539A records, stride
     * 0x12, base 0x54EC (cf. the marker loop func @0x670CF). The PER-RECORD
     * work below is RECONSTRUCTED. */
    for (int i = 0; i < g_native_count_539A; i++) {
        native_settlement_tick(i);
    }
}

void native_settlement_tick(int index)   /* RECONSTRUCTED — rates RUNTIME_ONLY (NAMES.TXT/data-file) */
{
    struct NativeSettlement *s =
        (struct NativeSettlement *)&g_native_table_54EC[index * NATIVE_SETTLEMENT_STRIDE];

    /* 1. Population growth — RUNTIME_ONLY rate (loaded from NAMES.TXT/data-file) */
    if (game_random_range(0, 99) < NATIVE_GROWTH_PCT /* RUNTIME_ONLY (NAMES.TXT/data-file) */) {
        if (s->population < settlement_max_pop(s->owner /* class proxy */)) {
            s->population++;
        }
    }

    /* 2. Mission conversion — gated on +0x05 bit 0x10 (BYTE_VERIFIED bit;
     *    @asm test byte [bx+0x54F1],0x10 @0x043F40). Rate RUNTIME_ONLY (NAMES.TXT/data-file). */
    if (s->mission & 0x10) {
        int convert_rate = MISSION_CONVERT_PCT;   /* RUNTIME_ONLY (NAMES.TXT/data-file) */
        if (game_random_range(0, 99) < convert_rate) {
            spawn_indian_convert(index);
        }
    }
}

int settlement_max_pop(int type)          /* RECONSTRUCTED — values RUNTIME_ONLY (NAMES.TXT/data-file) */
{
    switch (type) {
    case SETTLEMENT_CAMP:    return 3;
    case SETTLEMENT_VILLAGE: return 6;
    case SETTLEMENT_CITY:    return 10;
    case SETTLEMENT_CAPITAL: return 12;
    }
    return 6;
}
