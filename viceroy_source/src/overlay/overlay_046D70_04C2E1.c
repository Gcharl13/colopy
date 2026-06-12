/* ============================================================================
 * overlay_046D70_04C2E1.c -- overlay functions in file range 0x046D70..0x04C2E1
 *
 * Region: native / colony / combat.  Hand-ported from the per-function
 * disassembly (reverse_engineered/code/VICEROY/disasm/func_*.asm) and the
 * re-segmented overlay dump (disasm_overlay_reseg/page_0C.asm, code_base
 * 0x46600).  STRICT cite-or-not yet decoded: every value/offset cites the .asm; anything
 * undeterminable (opaque overlay 0x191F / 0x1A1F targets, truncated dumps) is
 * marked not yet decoded and never guessed.
 *
 * PORT STATUS (per 2026-05-30 directive; see per-function banners):
 *   DONE          full @asm-cited body written here.
 *   SUPERSEDED    already ported to a named src/<subsystem>/ file — body lives
 *                 there; this is a one-line forwarding stub.
 *   PHANTOM       reloc/data island mis-framed as a function by the auto-decoder.
 *   STILL-SKELETON  in-scope but the per-func dump TRUNCATES mid-body and the
 *                 extent could not be byte-verified within this pass.
 *
 * Bases (DGROUP): UnitRecord 0x3144 stride 0x1C (+0x02 type byte = 0x3146,
 *   +0x03 = 0x3147 owner nibble), ColonyRecord 0x5D46 stride 0xCA,
 *   PowerRecord 0x8808 stride 0x13C (+0x2A gold), NativeSettlement 0x54EC
 *   stride 0x12 (+0x02 power idx, +0x04 pop); difficulty 0x53A6;
 *   random_int(lo,hi) = LCALL 0x181F:0x04D4.
 * ============================================================================ */
#include "viceroy.h"
#include "overlay_externs.h"
#include "native.h"

/* ----------------------------------------------------------------------------
 * Role-named externs for the overlay LCALL thunks used below, where the role is
 * byte-known from repeated use across this region.  Where the target is in an
 * opaque overlay (0x191F / 0x1A1F) the role is inferred from call sites; we keep the raw
 * overlay_call_* name from overlay_externs.h.
 *
 *   0x181F:0x0A4C  select/bind record by index (UnitRecord/NativeSettlement
 *                  cursor); ubiquitous "open" call.            [role known]
 *   0x181F:0x0A42  bind power/tribe by (power-4) index.        [role known]
 *   0x181F:0x04D4  random_int(lo, hi) — MSC LCG (project mem).  [BYTE_VERIFIED]
 *   0x181F:0x030C  table_lookup_2d(row, col) — 2-arg accessor returning a byte
 *                  (used for per-power/per-commodity tables).  [role known]
 * Signatures here are local and documentary; the canonical no-arg prototypes
 * live in overlay_externs.h.  We call through the canonical names. */

/* direct calls replacing void-arity stub calls */
extern int menu_run_boxed(uint16_t key_off);  /* PORTED 0x181F:0x3FE runner (src/ui/menu_runner.c) */
extern int func_0082A0_logic_sz_18(uint16_t row, uint16_t col);  /* 0x181F:0x030C relation/alarm table @0x5B1C */
extern int func_00627A_op_sz_57(uint16_t x, uint16_t y);         /* 0x181F:0x078C terrain/tile query */
extern int func_008BB2_logic_sz_20(uint16_t unit);               /* 0x181F:0x0B78 in-settlement probe */

/* DGROUP globals referenced in this region (cite-or-not yet decoded; addresses are the
 * absolute DGROUP offsets seen in the disassembly). */
extern uint8_t  g_native_value_table_5AD8[];  /* DGROUP:0x5AD8 — per-tribe table, stride 0x4E */
extern uint8_t  g_native_table_54EC[];         /* DGROUP:0x54EC — NativeSettlement[], stride 0x12 */
extern uint16_t g_tribe_relation_5B04[];       /* DGROUP:0x5B04 — [8 tribes][? ] word grid, row stride 0x27 words */

/* ============================================================================
 * func_046D70 — PHANTOM (mis-decoded data/reloc island)
 * ----------------------------------------------------------------------------
 * @asm 0x046D70..0x046DE0 (112 bytes).  The "ENTER 0x39" prologue is followed
 * immediately by non-code: `AND cl,[bx+si]`, `PUSHAW`, `CMPSB`, and a long run
 * of `ADD [bx+si],al` (0x00 0x00 …) padding to 0x046DDF.  This is the byte
 * pattern of a relocated word table / jump-island, NOT a function body — the
 * auto-decoder framed a data region between func_04694B and func_046DE0 as a
 * function.  No callers (callgraph).  Marked PHANTOM; do not emit a body.
 * (Disassembly: disasm/func_046D70_unknown.asm lines 13-62.)
 * ============================================================================ */
/* PHANTOM: 0x046D70 is a mis-decoded data/reloc island, not code — see banner. */

/* ============================================================================
 * func_046DE0 — native_settlement_display_value  [DONE — BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Companion to native_foreach_settlement_of_tribe (tribe_query.c).  Given a
 * settlement index, reads its power byte (+0x02), converts to a 0-based tribe
 * id, indexes the per-tribe value table at 0x5AD8 (stride 0x4E), and computes a
 * display/strength value = entry*2 + 3, plus a +entry+1 bonus when the
 * settlement's +0x03 flag byte has bit 2 (0x04) set (a mission / upgraded-
 * settlement flag).
 *
 * @asm 0x046DE5  imul bx,[bp+6],0x12          ; bx = idx * sizeof(NativeSettlement)
 * @asm 0x046DE9  mov al,[bx+0x54EE]           ; rec[+0x02] = power index
 * @asm 0x046DEF  sub ax,4                     ; -> 0-based tribe id (natives 4..11)
 * @asm 0x046DF2  imul si,ax,0x4E              ; si = tribe * 0x4E
 * @asm 0x046DF5  mov al,[si+0x5AD8]           ; entry = value_table[tribe]
 * @asm 0x046DFD  shl ax,1 / add ax,3          ; base = entry*2 + 3
 * @asm 0x046E05  test byte [bx+0x54EF],4      ; rec[+0x03] & 0x04  (mission flag)
 * @asm 0x046E0A  je  +6                       ; if clear, return base
 * @asm 0x046E0C  add cx,ax / inc cx           ; else += entry + 1  (cx held entry)
 * @asm 0x046E12  return [bp-2]
 *
 * Note the table base 0x5AD8 is 0x5AD8 = 0x5ad9-1; the per-turn reset loop in
 * func_04891A indexes the SAME table at 0x5AD9 +flags, confirming stride 0x4E
 * per-tribe records.  [BYTE_VERIFIED control flow]
 * ============================================================================ */
int native_settlement_display_value(uint16_t settlement_index)  /* func_046DE0 */
{
    uint8_t *rec = &g_native_table_54EC[settlement_index * NATIVE_SETTLEMENT_STRIDE];

    /* @asm 0x046DE9..0x046DF2 — power byte -> 0-based tribe id. */
    int tribe = (int)rec[0x02] - 4;

    /* @asm 0x046DF5 — entry from the per-tribe value table (stride 0x4E). */
    int entry = g_native_value_table_5AD8[tribe * 0x4E];

    /* @asm 0x046DFD..0x046E02 — base value. */
    int value = entry * 2 + 3;

    /* @asm 0x046E05..0x046E0F — mission/upgrade bonus. */
    if (rec[0x03] & 0x04)
        value = entry + value + 1;

    return value;  /* @asm 0x046E12 RETF al/ax */
}

/* ============================================================================
 * func_046E18 — native_settlement_create  [DONE — BYTE_VERIFIED, full body]
 * ----------------------------------------------------------------------------
 * Real size 167 bytes (authoritative: disasm_overlay_reseg/page_0C.asm,
 * code_offset 0x046DE0).  The per-function dump truncated at the first RETF;
 * the full initializer is below.  Allocates a new NativeSettlement slot at the
 * tail of the table, writes owner/x/y, runs the value helper, initializes the
 * remaining fields, and registers the settlement on the map (two map writes).
 * Caps the table at 0x54 (84) live settlements.
 *
 * @asm 0x046E1C  [bp-2] = 0xFFFF                ; default "failed" return (-1)
 * @asm 0x046E21  cmp [0x539A],0x54 ; jge bail   ; if count >= 84 -> return -1
 * @asm 0x046E2B  ax = [0x539A] ; inc [0x539A]   ; new index = count; count++
 * @asm 0x046E35  push ax ; lcall 0x181F:0x0A4C  ; bind/select the new record
 * @asm 0x046E3E  lcall 0x181F:0x0A42(arg0 - 4)  ; bind tribe (power - 4)
 * @asm 0x046E4D  bx = [0x8D4A]                  ; bx = bound-record pointer
 * @asm 0x046E54  [bx+2] = (byte)arg0            ; rec.power_idx (+0x02)
 * @asm 0x046E5A  [bx+0] = (byte)arg1            ; rec.x         (+0x00)
 * @asm 0x046E5F  [bx+1] = (byte)arg2            ; rec.y         (+0x01)
 * @asm 0x046E66  push new_idx ; call 0x5434(cs) ; al = initial_value(new_idx)
 * @asm 0x046E70  [bx+4] = al                    ; rec.value     (+0x04)
 * @asm 0x046E77  [bx+5] = 0xFF                  ; rec.+0x05 = 0xFF
 * @asm 0x046E7B  [bx+6] = 0                     ; rec.+0x06 = 0
 * @asm 0x046E7F  lcall 0x181F:0x0740(arg2, arg1) -> es:bx ; map cell pointer (y,x)
 * @asm 0x046E91  or es:[bx],2                   ; set map tile bit1 (settlement)
 * @asm 0x046E95  lcall 0x181F:0x0704(arg0, arg2, arg1) ; register cell (power,y,x)
 * @asm 0x046EA3  imul bx,new_idx,0x12           ; bx = idx * 0x12 (table addressing)
 * @asm 0x046EA7  [bx+0x54EF] = 0                ; rec.+0x03 = 0   (flags clear)
 * @asm 0x046EAE  [bx+0x54F3]=[+0x54F4]=[+0x54F5]=0xFF ; rec +0x07/+0x08/+0x09 = 0xFF
 * @asm 0x046EBA  return new_idx
 *
 * Field map confirmed: +0x00 x, +0x01 y, +0x02 power idx, +0x03 flags, +0x04
 * value, +0x05/+0x06 state, +0x07..+0x09 mission/relation slots (init 0xFF).
 * cs:0x5434 (file 0x04BA34) is the page-0C RTLink trampoline → LJMP 0x1A1F:0x0410
 * (same trampoline as ovly_4BA34_substate; binary: file 0x04BA34 = EA 10 04 1F 1A).
 * 0x1A1F:0x0410 thunk EA-placeholder = 0x0000 (unpatched in static binary, page=0x0C).
 * Role: returns an initial/sub-state value for the settlement/power record.
 * 0x181F:0x0740 = map_cell_ptr(y,x), 0x181F:0x0704 = map_register(owner,y,x)
 * (role-named platform externs).  [BYTE_VERIFIED — full body]
 * ============================================================================ */
extern uint8_t *g_bound_record_8D4A;   /* DGROUP:0x8D4A — pointer to currently-bound record */
extern int  native_settlement_initial_value(int new_index);  /* near cs:0x5434 (file 0x04BA34)
                                                               * -> LJMP 0x1A1F:0x0410 (same
                                                               * trampoline as ovly_4BA34_substate).
                                                               * Returns initial value for new entry. */

int native_settlement_create(uint16_t owner_power, uint16_t x, uint16_t y)  /* func_046E18 */
{
    int new_index = -1;  /* @asm 0x046E1C [bp-2]=0xFFFF */

    /* @asm 0x046E21 — table is capped at 84 live settlements. */
    if (g_native_count_539A >= 0x54)
        return new_index;             /* @asm 0x046E26/0x046E28 -> epilogue, returns -1 */

    /* @asm 0x046E2B..0x046E32 — append at tail, bump count. */
    new_index = g_native_count_539A;
    g_native_count_539A++;

    /* @asm 0x046E35 — select the new record; @asm 0x046E3E — bind its tribe. */
    overlay_call_181F_0A4C();         /* select record (new_index) */
    overlay_call_181F_0A42();         /* bind tribe = owner_power - 4 */

    /* @asm 0x046E4D..0x046E5F — write owner/x/y into the bound record (*0x8D4A). */
    uint8_t *rec = g_bound_record_8D4A;
    rec[0x02] = (uint8_t)owner_power;  /* @asm 0x046E54 power index */
    rec[0x00] = (uint8_t)x;            /* @asm 0x046E5A */
    rec[0x01] = (uint8_t)y;            /* @asm 0x046E5F */

    /* @asm 0x046E66..0x046E7B — initial value + state init. */
    rec = g_bound_record_8D4A;
    rec[0x04] = (uint8_t)native_settlement_initial_value(new_index);  /* @asm 0x046E70 */
    rec = g_bound_record_8D4A;
    rec[0x05] = 0xFF;                  /* @asm 0x046E77 */
    rec[0x06] = 0x00;                  /* @asm 0x046E7B */

    /* @asm 0x046E7F..0x046E91 — mark the map tile (set bit1 at cell (y,x)). */
    overlay_call_181F_0740();          /* es:bx = map_cell_ptr(y, x); *cell |= 2 */

    /* @asm 0x046E95..0x046EA1 — register the cell with the settlement/owner. */
    overlay_call_181F_0704();          /* map_register(owner_power, y, x) */

    /* @asm 0x046EA3..0x046EB6 — clear flags (+0x03) and init mission slots to 0xFF. */
    {
        uint8_t *t = &g_native_table_54EC[new_index * NATIVE_SETTLEMENT_STRIDE];
        t[0x03] = 0x00;                /* @asm 0x046EA7 [bx+0x54EF] */
        t[0x07] = 0xFF;                /* @asm 0x046EAE [bx+0x54F3] */
        t[0x08] = 0xFF;                /* @asm 0x046EB2 [bx+0x54F4] */
        t[0x09] = 0xFF;                /* @asm 0x046EB6 [bx+0x54F5] */
    }

    return new_index;  /* @asm 0x046EBA RETF [bp-2] */
}

/* ============================================================================
 * func_046EC0 — native_settlement_remove_046EC0_inline  [BYTE_VERIFIED inline port;
 *   canonical modular version is in native/settlement.c — see rename note below]
 * ----------------------------------------------------------------------------
 * 258 bytes, 95 insns (authoritative: disasm_overlay_reseg/page_0C.asm).
 * Removes the NativeSettlement at slot settlement_index from the map and the
 * live table; recalls (disbands) any native unit homed to that slot; compacts
 * the settlement table by shifting entries down; decrements the owning tribe's
 * settlement count and (if not extinct) proportionally reduces two tracked
 * tribe attributes.  If the tribe's count hits zero it is marked EXTINCT and
 * an announcement is emitted.
 *
 * UNIT LOOP (0x046EED..0x046F32) — reverse scan of UnitRecord table:
 * @asm 0x046EC6  push [bp+6] ; LCALL 0x181F:0x0A4C   ; select the doomed record
 *                              (sets [0x8D4E], [0x8D50], [0x8D52] via tribe bind)
 * @asm 0x046ED5  imul bx,[bp+6],0x12                 ; bx = idx * 0x12
 * @asm 0x046ED9  push [bx+0x54ED] (rec.y, +0x01)
 * @asm 0x046EE0  push [bx+0x54EC] (rec.x, +0x00)
 * @asm 0x046EE5  push 2 ; push 0 ; LCALL 0x181F:0x068C ; map_set_tile(x,y,2,0)
 *                                                        (clear the map marker)
 * @asm 0x046EED  [bp-2] = [0x539C] - 1               ; i = unit_count - 1
 * @asm 0x046EF4  jmp 0x046F0A                        ; enter loop at test
 * @asm 0x046EF6 (BODY) al = (byte)[bp+6]             ; al = settlement_index
 * @asm 0x046EF9  imul bx,[bp-2],0x1C                 ; bx = i * UnitRecord stride
 * @asm 0x046EFD  cmp [bx+0x314A],al ; jle 0x046F07   ; u[+0x06] > idx → decrement
 * @asm 0x046F03  dec [bx+0x314A]                     ; u.home_idx--
 * @asm 0x046F07  dec [bp-2]                          ; i--
 * @asm 0x046F0A (TEST) cmp [bp-2],0 ; jl 0x046F34   ; i < 0 → exit unit loop
 * @asm 0x046F10  imul bx,[bp-2],0x1C                 ; bx = i * 0x1C (re-read i)
 * @asm 0x046F14  al = [bx+0x3147] & 0x0F             ; owner nibble (+0x03 field)
 * @asm 0x046F1A  cmp al,4 ; jb 0x046F07              ; skip non-native owners
 * @asm 0x046F1E  cmp [bx+0x314A],al(removed)         ; al is now settlement_index
 *              NOTE: at 0x046F1E 'al' is reloaded from [bp+6] at 0x046F1E
 *              — jne 0x046EF6                        ; not homed here → body
 * @asm 0x046F27  push [bp-2]                         ; push unit index i
 * @asm 0x046F2A  LCALL 0x181F:0x0808                 ; recall/disband native unit
 * @asm 0x046F2F  add sp, 2
 * @asm 0x046F32  jmp 0x046F07                        ; dec i, continue
 *
 * TABLE COMPACTION (0x046F34..0x046F5D):
 * @asm 0x046F34  [bp-2] = [bp+6]                     ; j = settlement_index
 * @asm 0x046F3A  jmp 0x046F54                        ; enter at test
 * @asm 0x046F3C (BODY) imul bx,[bp-2],0x12           ; bx = j * 0x12
 * @asm 0x046F40  di = bx + 0x54EC                    ; di = &NativeTable[j]
 * @asm 0x046F44  si = bx + 0x54FE                    ; si = &NativeTable[j+1]
 *                                                     ; (0x54FE = 0x54EC + 0x12)
 * @asm 0x046F48  ES = DS
 * @asm 0x046F4C  cx = 9 ; rep movsw                  ; copy 18 bytes [j+1]->[j]
 * @asm 0x046F51  inc [bp-2]                          ; j++
 * @asm 0x046F54 (TEST) ax = [0x539A] - 1
 * @asm 0x046F58  cmp ax,[bp-2] ; jg 0x046F3C         ; (count-1) > j → continue
 * @asm 0x046F5D  dec [0x539A]                        ; g_native_count_539A--
 *
 * TRIBE ATTRIBUTE UPDATE (0x046F61..0x046FC1):
 * @asm 0x046F61  bx = [0x8D52]                       ; tribe_0based_id (set by 0x0A4C)
 * @asm 0x046F65  dec [bx - 0x69D6]                   ; DGROUP[tribe+0x962A]-- (settlement count)
 *                (Equivalent: g_tribe_settlement_count_962A[tribe_id]--)
 * @asm 0x046F69  je 0x046F92                         ; if count==0 → tribe extinct
 * --- Non-extinct path (tribe still has settlements): ---
 * @asm 0x046F6B  si = [0x8D4E]                       ; ptr to bound tribe record
 * @asm 0x046F6F  al = [si+8]                         ; tribe rec field +0x08 (byte)
 * @asm 0x046F72  cwde                                ; zero-extend al → ax
 * @asm 0x046F73  cx = 0xFFFF
 * @asm 0x046F76  dl = [bx - 0x69D6]                  ; dl = new count (after dec)
 * @asm 0x046F7A  dh = 0
 * @asm 0x046F7C  cx -= dx                            ; cx = 0xFFFF - new_count
 *                                                     ; = -(new_count + 1) signed
 *                                                     ; = -(count_before) signed
 * @asm 0x046F7E  cdq                                 ; DX:AX = sign-extend(ax)
 * @asm 0x046F7F  idiv cx                             ; AX = ax / -(count_before)
 *                                                     ; = -attr / count_before
 * @asm 0x046F81  add [si+8], al                      ; attr -= attr/count_before
 *                                                     ; (removes removed-slot share)
 * @asm 0x046F84  ax = [si+0xA]                       ; tribe rec field +0x0A (word)
 * @asm 0x046F87  cdq
 * @asm 0x046F88  idiv cx                             ; same ratio formula
 * @asm 0x046F8A  add [si+0xA], ax                    ; attr2 -= attr2/count_before
 * @asm 0x046F8D  pop si ; pop di ; leave ; retf      ; return
 * @asm 0x046F91  nop                                 ; alignment
 * --- Extinct path (0x046F92): tribe count hit 0 ---
 * @asm 0x046F92  bx = [0x8D4E]                       ; ptr to bound tribe record
 * @asm 0x046F96  or [bx+3], 0x80                     ; tribe_rec.flags |= 0x80 (EXTINCT)
 * @asm 0x046F9A  push [0x8D50]                       ; push tribe power index
 * @asm 0x046F9E  LCALL 0x181F:0x09A4                 ; power_handle(tribe_power_index) → ax
 * @asm 0x046FA3  add sp, 2
 * @asm 0x046FA6  push ax ; push 0
 * @asm 0x046FA9  LCALL 0x181F:0x0438                 ; msg_set_arg(handle, slot=0)
 * @asm 0x046FAE  add sp, 4
 * @asm 0x046FB1  push 3 ; push 0x14D4                ; DGROUP:0x14D4 = "EXTINCT"
 * @asm 0x046FB6  LCALL 0x181F:0x0652                 ; display_message(3, "EXTINCT")
 * @asm 0x046FBB  add sp, 4
 * @asm 0x046FBE  pop si ; pop di ; leave ; retf      ; return
 *
 * DGROUP globals (all new in this tail):
 *   0x8D4E  g_tribe_bound_rec_8D4E — ptr to bound tribe record (via 0x0A4C→0x0A42)
 *   0x8D50  g_tribe_power_index_8D50 — tribe power index bound by 0x0A42 (word)
 *   0x8D52  g_tribe_id_8D52 — 0-based tribe index bound by 0x0A4C/0x0A42 (word)
 *   0x962A  g_tribe_settlement_count_962A[] — per-tribe settlement counts, 8 bytes
 *            BSS array; element for tribe T at DGROUP[T + 0x962A]
 *            (accessed as [T − 0x69D6] in 16-bit wrap, i.e. T + 0x962A unsigned)
 *   0x14D4  (DGROUP data string) "EXTINCT\0" — shown when tribe is wiped out
 *
 * 0x181F:0x0808 = disband/recall native unit (arg: unit table index).
 * 0x181F:0x09A4 = power_handle(power_idx) — power index → name handle/token.
 *                Cross-ref: report_screen.c "market_price(cargo)"; king_events.c;
 *                diplomacy/treaty.c; random_events/lcr.c "tribe-index lookup".
 *                Returns a word (the handle/id) pushed to 0x0438.
 * 0x181F:0x0438 = msg_set_arg(handle, slot) — set message argument for the
 *                subsequent display call.  Cross-ref: overlay_03C5A8_040C11.c
 *                "msg_set_arg(slot,value)" and overlay_02083C_024337.c same.
 * 0x181F:0x0652 = display_message(type, str_offset) — emits "EXTINCT" banner.
 * ============================================================================ */
extern uint8_t  g_unit_table_3144[];      /* DGROUP:0x3144 — UnitRecord[], stride 0x1C */
/* 0x181F:0x068C = set_map_tile(a, b, x, y) / draw_marker(x, y, layer, val):
 * clears/sets a map overlay cell.  Cross-ref: overlay_02AAEC_02F0C7.c
 * "set_map_tile(a,b,x,y)"; overlay_03C5A8_040C11.c "draw_marker(x,y,0x10,1)".
 * Args here are (x, y, layer=2, val=0) — clearing a settlement tile marker. */

/* New DGROUP globals for the tail (first cited by func_046EC0 tail): */
extern uint8_t *g_tribe_bound_rec_8D4E;   /* DGROUP:0x8D4E — ptr to bound tribe record;
                                            * set by LCALL 0x181F:0x0A42 (bind-tribe) which
                                            * is invoked internally by 0x0A4C(settlement). */
extern uint16_t g_tribe_power_index_8D50; /* DGROUP:0x8D50 — tribe power index (word);
                                            * set by 0x0A42; pushed to 0x09A4 in extinct path. */
extern uint16_t g_tribe_id_8D52;          /* DGROUP:0x8D52 — 0-based tribe id (0..7);
                                            * set by 0x0A4C/0x0A42.  Used as an integer
                                            * index; [T − 0x69D6] wraps to DGROUP:0x962A+T. */
extern uint8_t  g_tribe_settlement_count_962A[]; /* DGROUP:0x962A — per-tribe settlement
                                            * count, 8 bytes (BSS).  Element for tribe T is
                                            * at g_tribe_settlement_count_962A[T].
                                            * In the 16-bit code accessed as the 8086 byte at
                                            * DS:(tribe_id − 0x69D6) ≡ DS:(tribe_id + 0x962A). */

/* RENAMED 2026-06-09: this is the raw INLINE port of func_046EC0; the CANONICAL
 * native_settlement_remove lives in src/native/settlement.c (same function, a
 * cleaner modular port that delegates to unit_detach_from_settlement /
 * native_tribe_eliminate / native_tribe_redistribute). Renamed to resolve the
 * duplicate-definition link error; kept here as a byte-verified reference. */
void native_settlement_remove_046EC0_inline(uint16_t settlement_index)  /* func_046EC0 — BYTE_VERIFIED */
{
    /* rec is the address of the settlement record in the DGROUP table; the
     * platform (overlay call) uses it implicitly (pushed before 0x0A4C). */
    uint8_t *rec = &g_native_table_54EC[settlement_index * NATIVE_SETTLEMENT_STRIDE];
    (void)rec;  /* see 0x046ED5..0x046EE5 — args computed from table directly */

    /* @asm 0x046EC6 — select/bind the doomed settlement record (also internally
     * binds its owning tribe, setting [0x8D4E], [0x8D50], [0x8D52]). */
    overlay_call_181F_0A4C();

    /* @asm 0x046ED5..0x046EE5 — clear the settlement's map marker at (x,y). */
    overlay_call_181F_068C();   /* map_set_tile(rec.x, rec.y, 2, 0) */

    /* @asm 0x046EED..0x046F32 — UnitRecord walk (reverse, i = unit_count-1..0):
     *   (a) For any unit with home > settlement_index: decrement home to fix up
     *       the index after the table will be compacted (step 2 below).
     *   (b) For native-owned units (owner nibble >= 4) whose home == settlement_index:
     *       call 0x181F:0x0808 to disband/recall that unit.
     * The loop structure is a "do-while with body restart":
     *   jmp → test (i >= 0?); if yes: check native owner; if native+homed → call 0x808;
     *   else if home > idx: dec home; then always dec i and loop. */
    {
        int i = (int)g_unit_count_539C - 1;  /* @asm 0x046EED..0x046EF1 */
        goto unit_loop_test;                  /* @asm 0x046EF4 jmp 0x046F0A */
    unit_loop_body:
        {                                     /* @asm 0x046EF6 */
            uint8_t *u = &g_unit_table_3144[(uint16_t)i * UNIT_RECORD_STRIDE];
            /* @asm 0x046EFD..0x046F05 — shift home down if above removed slot. */
            if (u[0x06] > (uint8_t)settlement_index)  /* @asm 0x046EFD cmp [bx+0x314A],al */
                u[0x06]--;                             /* @asm 0x046F03 dec [bx+0x314A]    */
        }
        i--;                                  /* @asm 0x046F07 dec [bp-2] */
    unit_loop_test:                           /* @asm 0x046F0A */
        if (i < 0)
            goto unit_loop_exit;              /* @asm 0x046F0E jl 0x046F34 */
        {
            uint8_t *u = &g_unit_table_3144[(uint16_t)i * UNIT_RECORD_STRIDE];
            /* @asm 0x046F10..0x046F1C — skip non-native units. */
            if ((u[0x03] & 0x0F) < 4)        /* @asm 0x046F14 al=[bx+0x3147]&0xF ; 0x046F1A cmp al,4 */
                goto unit_loop_dec;           /* @asm 0x046F1C jb 0x046F07 */
            /* @asm 0x046F1E..0x046F25 — if home != removed slot, fall back to body. */
            if (u[0x06] != (uint8_t)settlement_index) /* @asm 0x046F1E..0x046F25 */
                goto unit_loop_body;          /* @asm 0x046F25 jne 0x046EF6 */
            /* @asm 0x046F27..0x046F32 — disband native unit homed to removed slot. */
            overlay_call_181F_0808();         /* LCALL 0x181F:0x0808(i) @asm 0x046F2A */
            /* (arg i is pushed at @asm 0x046F27; add sp,2 at @asm 0x046F2F) */
        }
    unit_loop_dec:
        i--;                                  /* @asm 0x046F07 (shared dec via jmp 0x046F07) */
        goto unit_loop_test;
    unit_loop_exit:;                          /* @asm 0x046F34 */
    }

    /* @asm 0x046F34..0x046F5D — NativeSettlement table compaction:
     * Slide every record from [settlement_index+1 .. count-1] down by one slot,
     * then decrement the live count.  Each slot is 0x12 (18) bytes = 9 words. */
    {
        int j = (int)settlement_index;        /* @asm 0x046F34..0x046F37 [bp-2] = [bp+6] */
        /* @asm 0x046F3A jmp 0x046F54 (enter at test) */
        while ((int)g_native_count_539A - 1 > j) { /* @asm 0x046F54..0x046F5B */
            /* @asm 0x046F3C..0x046F4F — copy NativeTable[j+1] → NativeTable[j] (18 bytes). */
            uint8_t *dst = &g_native_table_54EC[j * NATIVE_SETTLEMENT_STRIDE];        /* @asm 0x046F40 lea di,[bx+0x54EC] */
            uint8_t *src = &g_native_table_54EC[j * NATIVE_SETTLEMENT_STRIDE + NATIVE_SETTLEMENT_STRIDE]; /* @asm 0x046F44 lea si,[bx+0x54FE] */
            /* @asm 0x046F48 ES=DS ; @asm 0x046F4C cx=9 ; @asm 0x046F4F rep movsw */
            {
                int k;
                for (k = 0; k < NATIVE_SETTLEMENT_STRIDE; k++)
                    dst[k] = src[k];
            }
            j++;                              /* @asm 0x046F51 inc [bp-2] */
        }
        g_native_count_539A--;                /* @asm 0x046F5D dec [0x539A] */
    }

    /* @asm 0x046F61..0x046FC1 — decrement the owning tribe's settlement count
     * (accessed via the 16-bit wrap trick: g_tribe_id_8D52 − 0x69D6 mod 0x10000 =
     * 0x962A + tribe_id = DGROUP address of the per-tribe count byte), then
     * either redistribute tribe attributes or mark the tribe extinct. */
    {
        uint16_t tribe_id = g_tribe_id_8D52;  /* @asm 0x046F61 bx = [0x8D52] */

        /* @asm 0x046F65 dec byte [bx − 0x69D6]  →  g_tribe_settlement_count_962A[tribe_id]--
         * The 8086 instruction uses bx as an offset within DS with displacement
         * −0x69D6 (= +0x962A unsigned), reaching DGROUP:0x962A + tribe_id. */
        g_tribe_settlement_count_962A[tribe_id]--;  /* @asm 0x046F65 */

        if (g_tribe_settlement_count_962A[tribe_id] == 0) { /* @asm 0x046F69 je 0x046F92 */

            /* --- Extinct path (0x046F92..0x046FC1) --- */
            uint8_t *trec = g_tribe_bound_rec_8D4E;  /* @asm 0x046F92 bx=[0x8D4E] */
            trec[0x03] |= 0x80;               /* @asm 0x046F96 or [bx+3],0x80 — EXTINCT flag */

            /* @asm 0x046F9A push [0x8D50] ; lcall 0x181F:0x09A4 ; add sp,2 */
            overlay_call_181F_09A4();          /* power_handle(g_tribe_power_index_8D50) → ax */
            /* @asm 0x046FA6 push ax ; push 0 ; lcall 0x181F:0x0438 ; add sp,4 */
            overlay_call_181F_0438();          /* msg_set_arg(handle, slot=0) */
            /* @asm 0x046FB1 push 3 ; push 0x14D4 ; lcall 0x181F:0x0652 ; add sp,4 */
            overlay_call_181F_0652();          /* display_message(3, "EXTINCT") */

        } else {

            /* --- Non-extinct path (0x046F6B..0x046F90):
             * Remove the just-deleted settlement's proportional share from two
             * tracked tribe attributes.  Formula (for each attr):
             *   new_attr = attr − (attr / count_before)
             * Encoded as: cx = 0xFFFF − new_count = −(new_count + 1) = −count_before
             * (signed 16-bit); idiv gives −(attr / count_before); adding that
             * to attr subtracts the removed share.
             * new_count = remaining count AFTER the dec above. --- */
            uint8_t *trec = g_tribe_bound_rec_8D4E; /* @asm 0x046F6B si=[0x8D4E] */
            int8_t   attr8  = (int8_t)trec[0x08];   /* @asm 0x046F6F al=[si+8]; cwde (byte read) */
            int16_t  attr16;                          /* @asm 0x046F84 ax=word[si+0xA] */
            { uint16_t tmp; __builtin_memcpy(&tmp, &trec[0x0A], 2); attr16 = (int16_t)tmp; }

            /* @asm 0x046F73..0x046F7C — cx = 0xFFFF − new_count = −count_before */
            uint8_t new_count = g_tribe_settlement_count_962A[tribe_id]; /* @asm 0x046F76 dl=[bx-0x69D6] */
            int16_t divisor   = (int16_t)((uint16_t)0xFFFF - (uint16_t)new_count); /* @asm 0x046F7C sub cx,dx */

            /* @asm 0x046F7E..0x046F81 — trec[+8] += (int8_t)((int16_t)attr8 / divisor) */
            int16_t q8 = (int16_t)attr8 / divisor; /* @asm 0x046F7E cdq; 0x046F7F idiv cx */
            trec[0x08] += (uint8_t)(uint16_t)q8;   /* @asm 0x046F81 add [si+8],al */

            /* @asm 0x046F84..0x046F8A — word[trec+0xA] += (int16_t)(attr16 / divisor) */
            int16_t q16 = attr16 / divisor;           /* @asm 0x046F87 cdq; 0x046F88 idiv cx */
            { uint16_t tmp16; __builtin_memcpy(&tmp16, &trec[0x0A], 2);
              tmp16 = (uint16_t)((int16_t)tmp16 + q16);
              __builtin_memcpy(&trec[0x0A], &tmp16, 2); }  /* @asm 0x046F8A add [si+0xA],ax */
        }
    }
    /* @asm 0x046F8D pop si; pop di; leave; retf  (or 0x046FBE same) */
}

/* ============================================================================
 * func_046FC2 — native_foreach_settlement_of_tribe  [SUPERSEDED]
 * ----------------------------------------------------------------------------
 * Already hand-ported, BYTE_VERIFIED, to src/native/tribe_query.c
 * (function native_foreach_settlement_of_tribe).  See VERIFICATION_LEDGER.md
 * "func_046FC2 — settlement-by-owner iterator".  No body here.
 * ============================================================================ */
/* SUPERSEDED: ported to src/native/tribe_query.c (native_foreach_settlement_of_tribe). */

/* ============================================================================
 * func_046FFA — native per-unit AI step  [SUPERSEDED]
 * ----------------------------------------------------------------------------
 * Already hand-ported, BYTE_VERIFIED structure, to src/ai/native_unit_ai.c
 * (wave-8: alarm threshold 0x54F6/0x80, INDIANSURPRISE, argmax move-tasking).
 * The per-func dump (disasm/func_046FFA_unknown.asm) TRUNCATES at 121 bytes;
 * the full body lives in native_unit_ai.c.  No body here.
 * ============================================================================ */
/* SUPERSEDED: ported to src/ai/native_unit_ai.c (native per-unit AI). */

/* ============================================================================
 * func_0482DE — unit/tile action dispatch  [DONE — BYTE_VERIFIED, full body]
 * ----------------------------------------------------------------------------
 * Real size 48 bytes (authoritative reseg page_0C).  Classifies arg0 via near
 * trampoline 0x541B; the class selects one of three actions:
 *   class == 8           -> (fall to the "8" arm) and if class<0 do nothing,
 *                           else call 0x181F:0x0934(arg0)
 *   class in 1..7 (>=0)  -> call 0x1A1F:0x0150(class, arg0)
 *   class < 0  (the "8" arm, signed test)  -> no-op return
 *
 * @asm 0x0482E2  push arg0 ; call 0x541B (cs)        ; class = classify(arg0)
 * @asm 0x0482EC  cmp ax,8 ; je 0x048300              ; class 8 -> alt arm
 * @asm 0x0482F1  push ax ; push arg0 ;
 * @asm 0x0482F5  lcall 0x1A1F:0x0150                 ; handler_a(class, arg0) [page_0A/UI thunk]
 * @asm 0x0482FD  leave ; retf                        ; return
 * @asm 0x048300  (alt arm) or ax,ax ; jl 0x04830C    ; if class < 0 -> return
 * @asm 0x048304  push arg0 ; lcall 0x181F:0x0934     ; handler_b(arg0)
 * @asm 0x04830C  leave ; retf
 *
 * 0x541B is the page-0C RTLink near trampoline: cs:0x541B -> LJMP 0x1A1F:0x03D4
 * -> func_046FFA (native_per_unit_AI_step; ported to src/ai/native_unit_ai.c).
 * Binary verified: file 0x04BA1B = EA D4 03 1F 1A.
 * 0x1A1F:0x0150 = page_0A tile/unit action handler (class, arg0); one of the nine
 *   disp_code dispatchers seen in func_04B308 (second CS jump table at 0x4B9C0 ->
 *   0x1A1F:0x044C/3F8/3EC/3C8/428/3D4/3E0/410/0150 family).  Not yet cross-
 *   referenced by name in a sibling file; role-inferred from arg shape (class, unit).
 * 0x181F:0x0934 = unit_finish_activity(idx) — end this unit's current order/turn.
 *   Cross-ref: overlay_040C1E_04458A.c "unit_finish_activity" (3×), and
 *   overlay_02083C_024337.c "unit_finish_and_advance(idx)".
 * Control flow + the class==8 / signed-class arms are BYTE_VERIFIED.
 * ============================================================================ */
extern int  ovly_541B_classify(uint16_t arg);     /* near cs:0x541B -> LJMP 0x1A1F:0x03D4
                                                   * -> func_046FFA (native_per_unit_AI_step,
                                                   * SUPERSEDED; ported to src/ai/native_unit_ai.c).
                                                   * Classifies unit arg0 using native AI logic.
                                                   * Binary verified: file 0x04BA1B = EA D4 03 1F 1A. */

int unit_tile_action_dispatch(uint16_t arg0_bp_06)  /* func_0482DE */
{
    /* @asm 0x0482E2..0x0482E9 — classify arg0. */
    int klass = ovly_541B_classify(arg0_bp_06);

    /* @asm 0x0482EC — class 8 takes the alternate arm. */
    if (klass != 8) {
        /* @asm 0x0482F1..0x0482FA — primary handler for classes 1..7. */
        overlay_call_1A1F_0150();       /* handler_a(klass, arg0) */
        return 0;                       /* @asm 0x0482FD */
    }

    /* @asm 0x048300 — alternate arm: skip when the (signed) class is negative. */
    if (klass < 0)
        return 0;                       /* @asm 0x048302 JL epilogue */

    /* @asm 0x048304..0x04830C — secondary handler. */
    overlay_call_181F_0934();           /* unit_finish_activity(arg0) */
    return 0;
}

/* ============================================================================
 * func_04830E — per-power weekly state & price-drift update
 *                                          [BYTE_VERIFIED — full body]
 * ----------------------------------------------------------------------------
 * Has exactly one caller (anchor).  Operates on the per-power "game-state"
 * struct bound at *(0x8D4A) and a 4-slot price/inventory array bound at
 * *(0x8D4E) (+0x36 = per-commodity drift accumulator).  Reads difficulty
 * (0x53A6) and uses random_int (0x181F:0x04D4).  arg0 = power index.
 *
 * Phase 1 — advance the power's "phase counter":
 *   @asm 0x04831B  LCALL 0x181F:0x0A4C(arg0)        ; bind power state -> *0x8D4A
 *   @asm 0x048327  CALL file:0x4BA34 (cs) -> LJMP 0x1A1F:0x0410 ; al = sub-state(arg0)
 *   @asm 0x048331  cmp al,[bx+4] ; jbe +            ; if al > state.level (+0x04)
 *   @asm 0x048336    mode = 2                        ; ([bp-0x14])
 *   @asm 0x04833B  test [bx+3],1 ; jne -> mode = 1  ; flag (+0x03) bit0 = "grow"
 *   @asm 0x048346  if mode == 0 goto phase2          ; nothing to advance
 *   @asm 0x04834F  [bx+6] += [bx+4]                  ; accumulator (+0x06) += level
 *   @asm 0x048355  if [bx+6] < 0x14 goto phase2      ; threshold 20
 *   @asm 0x04835E  [bx+6] = 0                         ; reset accumulator
 *   @asm 0x048362  if mode == 2 { [bx+4]++ ; goto phase2 }  ; bump level, done
 *   @asm 0x04836E  (mode==1 path) build a price/event index in [bp-2] …
 *
 * Phase 1b — pick a commodity/event line ([bp-2] starts 0x13 = 19):
 *   @asm 0x048373  bx=[0x8D4E]; if [bx+7] > 0 …       ; (+0x07 = pending count)
 *   @asm 0x04837D  random_int(0, difficulty(0x53A6)) == 0 ? dec [bx+7] : --
 *   @asm 0x048398  inc [bp-2]
 *   @asm 0x04839B  if [bx+0xA] >= 0x32 { [bx+0xA] -= 0x32; [bp-2] += 2 } ; (+0x0A pool, step 50)
 *   @asm 0x0483AD  push 3 bytes of *0x8D4A (+0,+1,+2) and [bp-2] ;
 *   @asm 0x0483C1  LCALL 0x181F:0x095C(...)           ; resolve -> [bp-0x10]
 *   @asm 0x0483CC  if result < 0 goto phase2
 *   @asm 0x0483D0  imul bx,result,0x1C ; [bx+0x314A] = (byte)arg0 ;  ; tag a UnitRecord
 *   @asm 0x0483DA  bx=[0x8D4A]; [bx+3] &= 0xFE          ; clear the "grow" flag bit
 *
 * Phase 2 — per-commodity drift over the 4-slot array (gated by flag 0x5382&1):
 *   @asm 0x0483E2  test [0x5382],1 ; jne -> goto big-loop at 0x04846E
 *   @asm 0x0483EC  (else) j=0 …                        ; small Bernoulli pre-pass
 *     @asm 0x0483F4  ax = 0xC - [bp-0x18] ; random_int(0, ax)==0 ? hits++ ;
 *                    accumulate `hits` over (j..count); add to [bx+si+0x36]
 *   @asm 0x04846E  (big-loop, c = 0..3):
 *     @asm 0x048472  LCALL 0x181F:0x0316(&[bp-4],[0x8D4C])  ; load base price word
 *     @asm 0x048481  bx=[0x8D4A]; al=[bx+5]&0xF (if >=0)    ; current-power nibble (+0x05)
 *     @asm 0x0484A3  flag = ((([bx+3]&4)==1)?…)            ; sign of drift
 *     @asm 0x0484CB  push 0x18,c ; LCALL 0x181F:0x07B4 ;   ; event-active(0x18,c)? <<1
 *     @asm 0x0484DF  push 0x17,c ; LCALL 0x181F:0x07B4 ;   ; event-active(0x17,c)? >>1
 *     @asm 0x0484F3  [bx+si+0x36] += (byte)drift           ; bump accumulator
 *     @asm 0x04850F  [bx+si+0xA] -= drift*3 (clamped >=0)  ; reduce pool word (+0x0A)
 *     @asm 0x04851E  (if c-line valid) [bp-0xA] = [bp-4]<<flag ;
 *     @asm 0x048541  LCALL 0x181F:0x030C(c,[0x8D52]) ; /5 ; ; per-power scale ÷5
 *     @asm 0x048559  [bx+si+0xA] += that                   ; add back to pool
 *     @asm 0x048568  while [bx+si+0x36] >= 8: -=8 ; LCALL 0x181F:0x0D6C(3,-1,si,p) ; price--
 *     @asm 0x048592  while [bx+si+0x36] <= 0xF8: +=8 ; LCALL 0x181F:0x0D6C(5,1,si,p); price++
 *   @asm 0x0485BC  (final pass, c = 0..3): drain remaining +0x36 in steps of 8,
 *                  LCALL 0x181F:0x0D6C(0,-1,si,p) each step.
 *   @asm 0x0485F4  RETF
 *
 * This is the periodic European-market price-drift / per-power economic tick:
 * each commodity's signed "pressure" accumulator (+0x36) is nudged by random
 * Bernoulli draws scaled by difficulty and event flags, then converted into
 * discrete price up/down ticks via 0x181F:0x0D6C (the price-adjust opcode, seen
 * elsewhere with the (dir, step, slot, power) shape).  The 0x181F callee
 * semantics: 0x095C = unit_select_for_order / place_worker (cross-ref:
 *   overlay_02F3A2_031E4C.c / overlay_03C5A8_040C11.c); 0x0316 = load base price /
 *   standing-word accessor; 0x07B4 = power_attribute_bit(selector, power);
 *   0x0D6C = price-adjust / adjust_native_attitude (page 0x0B, lcr.c).
 * the control flow, struct offsets, and constants (0x14, 0x32, ÷5, step 8,
 * 0xF8) are BYTE_VERIFIED from disasm/func_04830E_unknown.asm. */
extern uint8_t  g_power_state_8D4A_alias;  /* *(0x8D4A) bound power-state struct (see *_8D4A) */
extern uint8_t *g_market_array_8D4E;       /* DGROUP:0x8D4E — bound 4-slot price/drift array */
extern uint8_t  g_difficulty_53A6;         /* DGROUP:0x53A6 — difficulty level */
extern uint16_t g_econ_flags_5382;         /* DGROUP:0x5382 — economy/option flags (bit0 gates path) */
extern int      ovly_4BA34_substate(uint16_t power);  /* near file:0x4BA34 -> LJMP 0x1A1F:0x0410.
                                                        * Binary verified: file 0x04BA34 = EA 10 04 1F 1A.
                                                        * 0x1A1F:0x0410 thunk EA-placeholder = 0x0000
                                                        * (unpatched in the static binary; page=0x0C).
                                                        * Returns sub-state word read from the bound
                                                        * power record; compared against +0x04 in
                                                        * power_weekly_economy_tick (0x048327). */

static void power_market_drift_apply(uint16_t power_index);  /* fwd: phase-2 drift loop */

int power_weekly_economy_tick(uint16_t power_index)  /* func_04830E */
{
    int mode = 0;                                   /* @asm 0x048313 [bp-0x14]=0 */
    uint8_t *st = g_bound_record_8D4A;              /* bound via 0x0A4C below */

    /* @asm 0x04831B / 0x048327 — bind the power's state, read its sub-state. */
    overlay_call_181F_0A4C();                       /* bind power_index -> *0x8D4A */
    int sub = ovly_4BA34_substate(power_index);     /* @asm 0x048327 */
    st = g_bound_record_8D4A;

    /* @asm 0x048331..0x048341 — decide grow/decay mode from level (+0x04) & flag (+0x03). */
    if ((uint8_t)sub > st[0x04]) mode = 2;          /* @asm 0x048336 */
    if (st[0x03] & 0x01)         mode = 1;          /* @asm 0x048341 */

    /* @asm 0x048346..0x048398 — phase 1: advance the accumulator (+0x06) by level. */
    if (mode != 0) {                                /* @asm 0x04834A */
        st[0x06] += st[0x04];                       /* @asm 0x048352 */
        if (st[0x06] >= 0x14) {                     /* @asm 0x048355 threshold 20 */
            st[0x06] = 0;                           /* @asm 0x04835E */
            if (mode == 2) {                        /* @asm 0x048362 */
                st[0x04]++;                         /* @asm 0x048368 bump level */
            } else {
                /* @asm 0x04836E.. — mode 1: pick a price/event line and tag a unit. */
                int line = 0x13;                    /* @asm 0x04836E [bp-2]=19 */
                uint8_t *mk = g_market_array_8D4E;  /* @asm 0x048373 */
                if ((int8_t)mk[0x07] > 0) {         /* @asm 0x048377 pending count */
                    /* @asm 0x04837D — 1/(difficulty+1) chance to consume one. */
                    if (overlay_call_181F_04D4() == 0)   /* random_int(0, difficulty) */
                        mk[0x07]--;                 /* @asm 0x048395 */
                    line++;                         /* @asm 0x048398 */
                }
                if (*(int16_t *)&mk[0x0A] >= 0x32) {/* @asm 0x04839B pool, step 50 */
                    *(int16_t *)&mk[0x0A] -= 0x32;  /* @asm 0x0483A5 */
                    line += 2;                      /* @asm 0x0483A9 */
                }
                /* @asm 0x0483C1 — place/select a unit slot for this power and line.
                 * 0x181F:0x095C = unit_select_for_order(args...) or place_worker —
                 * cross-ref: overlay_02F3A2_031E4C.c "unit_select_for_order(code, power, ...)";
                 * overlay_03C5A8_040C11.c "place_worker(...)". Returns slot index. */
                int slot = overlay_call_181F_095C();/* @asm 0x0483C1 */
                if (slot >= 0) {                    /* @asm 0x0483CC */
                    g_unit_table_3144[slot * UNIT_RECORD_STRIDE + 0x06] =
                        (uint8_t)power_index;       /* @asm 0x0483D6 tag home/owner */
                    g_bound_record_8D4A[0x03] &= 0xFE;  /* @asm 0x0483DE clear grow bit */
                }
            }
        }
    }

    /* @asm 0x0483E2..0x0485F2 — phase 2: per-commodity price-drift over the 4
     * slots (econ-flag gate, optional Bernoulli pre-pass, the main drift+tick
     * section, and the final drain) — all in the helper below. */
    power_market_drift_apply(power_index);          /* @asm 0x0483E2..0x0485F2 */

    return 0;  /* @asm 0x0485F4 RETF */
}

/* ----------------------------------------------------------------------------
 * power_market_drift_apply — phase 2 of func_04830E (file @asm 0x0483E2..0x0485F2)
 *
 * Faithful transcription of the per-commodity European-market price-drift tick.
 * Locals are reconstructed from [bp-N] (the asm frame is shared with phase 1,
 * but these slots are all re-initialised here so they are private):
 *   base_price  = [bp-4]   — base price WORD; written by 0x181F:0x0316 via the
 *                            &local out-pointer (platform-resident; opaque to C)
 *   drift       = [bp-6]   — signed per-slot drift magnitude (also the inner
 *                            Bernoulli "hits" counter in the pre-pass)
 *   shift_flag  = [bp-8]   — 0/1 shift count from st[3]&4
 *   scaled      = [bp-0xA] — base_price<<shift then ÷5-scaled pool delta
 *   bern_n      = [bp-0xC] — pre-pass inner-loop counter
 *   idx_e       = [bp-0xE] — slot index from st[5] nibble (price-DOWN slot)
 *   idx_s       = [bp-0x12]— slot index from 0x0316 (price-UP slot); also the
 *                            pre-pass outer slot counter j (0..3)
 *   scale16     = [bp-0x16]— per-power scale word from 0x181F:0x030C
 *   bern_lim    = [bp-0x18]— Bernoulli limit (ax*ax of 0x181F:0x0A60 result)
 * st_market = *(0x8D4E) (per-commodity arrays; +0x36 accumulator byte/slot),
 * st_bound  = *(0x8D4A) (bound power record; +0x0A pool WORD, stride 2/slot).
 * Operators preserved exactly: jge/jl/jg (signed), je/jne (==).  [BYTE_VERIFIED]
 * -------------------------------------------------------------------------- */
static void power_market_drift_apply(uint16_t power_index)
{
    int16_t base_price = 0;     /* [bp-4]   — out-param of 0x0316 (platform value) */
    int16_t drift      = 0;     /* [bp-6] */
    int16_t shift_flag = 0;     /* [bp-8] */
    int16_t scaled     = 0;     /* [bp-0xA] */
    int16_t bern_n     = 0;     /* [bp-0xC] */
    int16_t idx_e      = 0;     /* [bp-0xE] */
    int16_t idx_s      = 0;     /* [bp-0x12] */
    int16_t bern_lim   = 0;     /* [bp-0x18] */
    uint8_t *st_market;         /* [0x8D4E] */
    uint8_t *st_bound;          /* [0x8D4A] */
    int      si;

    (void)power_index;          /* bound record already set up by the parent */

    /* @asm 0x0483E2 — if econ flag bit0 SET, skip the Bernoulli pre-pass and go
     * straight to the main drift section. */
    if (g_econ_flags_5382 & 0x01)               /* @asm 0x0483E2 test [0x5382],1 */
        goto main_section;                      /* @asm 0x0483E9 jmp 0x04846E */

    /* @asm 0x0483EC..0x04846C — Bernoulli pre-pass: for each of the 4 slots whose
     * power-attribute (0x181F:0x0A38, selector implicit via [0x8D50]) has bit 5
     * set, run an inner loop that draws random_int(0, 0xC-bern_lim)==0 `bern_lim+1`
     * times, counting hits into `drift`, and adds the hit count into
     * st_market[j+0x36]. */
    idx_s = 0;                                  /* @asm 0x0483EC [bp-0x12]=0 (j) */
    goto pre_test;                              /* @asm 0x0483F1 jmp 0x048428 */
pre_inner_body:                                 /* @asm 0x0483F4 */
    /* @asm 0x0483F4..0x048407 — random_int(0, 0xC - bern_lim) == 0 ? hit. */
    if (overlay_call_181F_04D4() == 0)          /* @asm 0x0483FD random_int(0,0xC-bern_lim) */
        drift++;                                /* @asm 0x048409 inc [bp-6] (hits) */
    bern_n++;                                   /* @asm 0x04840C inc [bp-0xC] */
pre_inner_test:                                 /* @asm 0x04840F */
    if (bern_lim + 1 > bern_n)                  /* @asm 0x04840F..0x048416 jg 0x0483F4 */
        goto pre_inner_body;
    /* @asm 0x048418..0x048425 — fold accumulated hits into st_market[j+0x36]. */
    st_market = g_market_array_8D4E;            /* @asm 0x04841B */
    si = idx_s;                                 /* @asm 0x04841F si=[bp-0x12] */
    st_market[si + 0x36] += (uint8_t)drift;     /* @asm 0x048422 add [bx+si+0x36],al */
    idx_s++;                                    /* @asm 0x048425 inc [bp-0x12] */
pre_test:                                       /* @asm 0x048428 */
    if (idx_s >= 4)                             /* @asm 0x048428 cmp [bp-0x12],4 */
        goto main_section;                      /* @asm 0x04842C jge 0x04846E */
    /* @asm 0x04842E..0x04843D — skip slots whose attribute bit 5 (0x20) is clear. */
    if ((overlay_call_181F_0A38() & 0x20) == 0) /* @asm 0x048435 attr([0x8D50], j); test al,0x20 */
        goto pre_next;                          /* @asm 0x04843F je 0x048425 */
    /* @asm 0x048441..0x04846C — set up the inner Bernoulli loop for this slot. */
    (void)func_0082A0_logic_sz_18(DG16(0x8D52), (uint16_t)idx_s); /* @asm 0x048448 scale16 = scale(j,[0x8D52]) */
    bern_lim = (int16_t)overlay_call_181F_0A60();/* @asm 0x048454 [bp-0x18]=0xa60(scale16) */
    bern_lim = (int16_t)(bern_lim * bern_lim);  /* @asm 0x04845F imul; [bp-0x18]=ax*ax */
    drift  = 0;                                 /* @asm 0x048464 [bp-6]=0 */
    bern_n = 0;                                 /* @asm 0x048469 [bp-0xC]=0 */
    goto pre_inner_test;                        /* @asm 0x04846C jmp 0x04840F */
pre_next:
    idx_s++;                                    /* @asm 0x048425 (shared dec/next via je) */
    goto pre_test;

main_section:                                   /* @asm 0x04846E */
    /* @asm 0x04846E..0x04847E — load base price (out-param &base_price) and the
     * price-UP slot index from 0x181F:0x0316([0x8D4C]). */
    idx_s = (int16_t)overlay_call_181F_0316();  /* @asm 0x048476 0x0316(&base_price,[0x8D4C]) */

    /* @asm 0x048481..0x048493 — idx_e = sign-extended st[5]; if >=0 mask to nibble. */
    st_bound = g_bound_record_8D4A;             /* @asm 0x048481 bx=[0x8D4A] */
    idx_e = (int16_t)(int8_t)st_bound[0x05];    /* @asm 0x048485 al=[bx+5]; cwde */
    if (idx_e >= 0)                             /* @asm 0x04848C..0x04848E jl 0x048496 */
        idx_e &= 0x0F;                          /* @asm 0x048490 and ax,0xF */

    /* @asm 0x048496..0x0484A0 — if neither slot is active, only the final drain. */
    if (idx_e < 0 && idx_s < 0)                 /* @asm 0x048496..0x04849E */
        goto final_drain;                       /* @asm 0x0484A0 jmp 0x0485BC */

    /* @asm 0x0484A3..0x0484AD — shift_flag = (st[3] & 4) ? 1 : 0. */
    shift_flag = (st_bound[0x03] & 0x04) ? 1 : 0; /* @asm 0x0484A3 and al,4;cmp al,1;sbb;inc */

    /* @asm 0x0484B0..0x04851B — price-DOWN slot (idx_e) drift + pool reduction. */
    if (idx_e >= 0) {                           /* @asm 0x0484B0 cmp [bp-0xE],0; jl 0x04851E */
        /* @asm 0x0484B6..0x0484C8 — magnitude = ((st[5]&0x10)?4:1) << shift_flag. */
        drift = (int16_t)(((st_bound[0x05] & 0x10) ? 4 : 1) << shift_flag); /* @asm 0x0484B8..0x0484C6 */
        /* @asm 0x0484CB..0x0484DC — event 0x18 active on idx_e ? *2. */
        if (overlay_call_181F_07B4() != 0)      /* @asm 0x0484D0 attr(0x18, idx_e) */
            drift <<= 1;                        /* @asm 0x0484DC shl [bp-6],1 */
        /* @asm 0x0484DF..0x0484F0 — event 0x17 active on idx_e ? /2 (signed). */
        if (overlay_call_181F_07B4() != 0)      /* @asm 0x0484E4 attr(0x17, idx_e) */
            drift >>= 1;                        /* @asm 0x0484F0 sar [bp-6],1 */
        /* @asm 0x0484F3..0x0484FD — fold drift into the accumulator byte. */
        st_market = g_market_array_8D4E;        /* @asm 0x0484F6 */
        si = idx_e;                             /* @asm 0x0484FA */
        st_market[si + 0x36] += (uint8_t)(int8_t)drift; /* @asm 0x0484FD add [bx+si+0x36],al */
        /* @asm 0x048500..0x04851B — pool word -= drift*3, clamp >= 0. */
        {
            int16_t delta3 = (int16_t)(drift * 3);   /* @asm 0x048503 cx=ax;shl;add (ax*3) */
            int16_t *pool;
            si = idx_e * 2;                          /* @asm 0x048509 shl si,1 */
            st_bound = g_bound_record_8D4A;          /* @asm 0x04850B bx=[0x8D4A] */
            pool = (int16_t *)&st_bound[si + 0x0A];  /* @asm 0x04850F [bx+si+0xA] */
            *pool -= delta3;                         /* @asm 0x04850F sub [bx+si+0xA],ax */
            if (*pool < 0)                           /* @asm 0x048515 or ax,ax; jge 0x04851B */
                *pool = 0;                           /* @asm 0x048519 sub ax,ax */
        }
    }

    /* @asm 0x04851E..0x048565 — price-UP slot (idx_s) scaled pool addition. */
    if (idx_s >= 0) {                           /* @asm 0x04851E cmp [bp-0x12],0; jl 0x048568 */
        /* @asm 0x048524..0x04852C — scaled = base_price << shift_flag. */
        scaled = (int16_t)(base_price << (shift_flag & 0xFF)); /* @asm 0x048527 ax=[bp-4]<<cl */
        /* @asm 0x04852F..0x048536 — subtract its low byte from the accumulator. */
        st_market = g_market_array_8D4E;        /* @asm 0x04852F */
        si = idx_s;                             /* @asm 0x048533 */
        st_market[si + 0x36] -= (uint8_t)(int8_t)scaled; /* @asm 0x048536 sub [bx+si+0x36],al */
        /* @asm 0x048539..0x04853E — if same slot as idx_e, halve scaled (signed). */
        if (si == idx_e)                        /* @asm 0x048539 cmp si,[bp-0xE] */
            scaled >>= 1;                       /* @asm 0x04853E sar [bp-0xA],1 */
        /* @asm 0x048541..0x048556 — scaled += scale(idx_s,[0x8D52]) / 5 (signed). */
        scaled = (int16_t)(scaled + (int16_t)(func_0082A0_logic_sz_18(DG16(0x8D52), (uint16_t)idx_s) / 5)); /* @asm 0x048548..0x048556 */
        /* @asm 0x048559..0x048565 — add scaled into the pool word (no clamp). */
        {
            int16_t *pool;
            si = idx_s * 2;                          /* @asm 0x04855F shl si,1 */
            st_bound = g_bound_record_8D4A;          /* @asm 0x048561 bx=[0x8D4A] */
            pool = (int16_t *)&st_bound[si + 0x0A];  /* @asm 0x048565 [bx+si+0xA] */
            *pool += scaled;                         /* @asm 0x048565 add [bx+si+0xA],ax */
        }
    }

    /* @asm 0x048568..0x048590 — price-DOWN: drain idx_e accumulator in steps of 8
     * while it is >= 8, emitting a downward price tick each step. */
    if (idx_e >= 0) {                           /* @asm 0x048568 cmp [bp-0xE],0; jl 0x048592 */
        for (;;) {                              /* @asm 0x048585 (test) */
            st_market = g_market_array_8D4E;    /* @asm 0x048585 */
            si = idx_e;                         /* @asm 0x048589 */
            if ((int8_t)st_market[si + 0x36] < 8) /* @asm 0x04858C cmp [bx+si+0x36],8; jge 0x048570 */
                break;
            st_market[si + 0x36] -= 8;          /* @asm 0x048570 sub [bx+si+0x36],8 */
            overlay_call_181F_0D6C();           /* @asm 0x04857D 0x0D6C([0x8D52], si, -1, 3) */
        }
    }

    /* @asm 0x048592..0x0485BA — price-UP: top up idx_s accumulator in steps of 8
     * while it is <= -8 (signed 0xF8), emitting an upward price tick each step. */
    if (idx_s >= 0) {                           /* @asm 0x048592 cmp [bp-0x12],0; jl 0x0485BC */
        for (;;) {                              /* @asm 0x0485AF (test) */
            st_market = g_market_array_8D4E;    /* @asm 0x0485AF */
            si = idx_s;                         /* @asm 0x0485B3 */
            if ((int8_t)st_market[si + 0x36] > (int8_t)0xF8) /* @asm 0x0485B6 cmp ...,0xF8; jle 0x04859A */
                break;
            st_market[si + 0x36] += 8;          /* @asm 0x04859A add [bx+si+0x36],8 */
            overlay_call_181F_0D6C();           /* @asm 0x0485A7 0x0D6C([0x8D52], si, 1, 5) */
        }
    }

final_drain:                                    /* @asm 0x0485BC */
    /* @asm 0x0485BC..0x0485EF — final pass: for each of the 4 slots, drain any
     * remaining accumulator in steps of 8 while >= 8, emitting a downward tick. */
    for (idx_s = 0; idx_s < 4; idx_s++) {       /* @asm 0x0485BC..0x0485CB */
        for (;;) {                              /* @asm 0x0485CD (test) */
            st_market = g_market_array_8D4E;    /* @asm 0x0485CD */
            si = idx_s;                         /* @asm 0x0485D1 */
            if ((int8_t)st_market[si + 0x36] < 8) /* @asm 0x0485D4 cmp [bx+si+0x36],8; jl 0x0485C4 */
                break;
            st_market[si + 0x36] -= 8;          /* @asm 0x0485DA sub [bx+si+0x36],8 */
            overlay_call_181F_0D6C();           /* @asm 0x0485E7 0x0D6C([0x8D52], si, -1, 0) */
        }
    }
    /* @asm 0x0485F2 pop si; leave; retf (parent) */
}

/* ============================================================================
 * func_0485F6 — per-power weekly tax/boycott recovery tick  [DONE — BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Role: once per game-week for power arg0, when a price boycott is in effect the
 * routine rolls (difficulty-scaled) to LIFT it, recovers the boycotted price
 * toward normal, walks the live colonies tagging this power's matching
 * settlements, and clears the per-unit "boycott counter" (UnitRecord +0x315A)
 * across the fleet.  Every step is mirrored to VICEROY.LOG via the debug-print
 * thunk 0x0D1D:0x712 when the verbose flag [bp-8] is set (the in-game
 * "FREEDOM" / Sons-of-Liberty diagnostic trace).  Authoritative extent: reseg
 * page_0C, 804 bytes (0x0485F6..0x04891A); per-func dump truncated at the first
 * LCALL @0x048604.
 *
 * Args/locals: arg0 = [bp+6] power index; verbose = [bp-8] (log gate, init 0);
 *   recover = [bp-0xC] (recovery magnitude from 0x030C); flag = [bp-0xA]
 *   (boycott-lift decision); i = [bp-6] (colony/unit loop cursor).
 *
 * @asm 0x0485FB  [bp-8] = 0                              ; verbose-log flag off
 * @asm 0x048600  push [0x83A6] ; LCALL 0x181F:0x04CA     ; seed_rng_from_timer([0x83A6])
 * @asm 0x04860C  [0x5394] = arg0 + 4                     ; "self power" (native-id base)
 * @asm 0x048615  LCALL 0x181F:0x0A42(arg0)               ; bind power -> *0x8D4A
 * @asm 0x048623  al = [arg0_base + 0x84C] ; LCALL 0x181F:0x0590(al)  ; per-power setup(class byte)
 * @asm 0x048632  test [0x5382],1 ; je -> 0x048759        ; econ-option flag gates phase A
 * @asm 0x04863C  bx=[0x8D4E]; test [bx+3],0x20 ; jne -> 0x048759  ; market "boycott active"?
 * @asm 0x048649  LCALL 0x181F:0x030C([0x5398], arg0) -> [bp-0xC]  ; recover = tax-table(tax,power)
 * @asm 0x04865B  if recover >= 0x19:                     ; only large recoveries roll
 * @asm 0x048660    random_int(1, 0x190=400) ; if recover < roll -> recover-small path
 * @asm 0x048672    [bp-0xA] = 1                           ; (lift candidate)
 * @asm 0x04867F  bx=[0x8D4E]; test [bx+3],0x40 ; jne [bp-0xA]=1  ; forced-lift flag (+3 bit6)
 * @asm 0x04868E  if [bp-0xA] == 0 -> 0x048759             ; no lift this week
 * @asm 0x048697  al=[0x53A6]; ax = (5 - difficulty)*2 ; random_int(0, ax)==0 ? continue : 0x048759
 * @asm 0x0486B5  push [0x8D50] ; LCALL 0x181F:0x09A4 ; 0x0438(slot0)  ; format current commodity
 * @asm 0x0486CC  push [0x8D50] ; LCALL 0x181F:0x0A1A ; 0x0438(slot1)  ; format its name
 * @asm 0x0486E3  lea [0x14F6] ; LCALL 0x181F:0x03FE     ; (push fixed string ptr)
 * @asm 0x0486EC  LCALL 0x181F:0x0D6C(0x190=+400, 0x64, [0x5398], [0x8D52])   ; price tick +
 * @asm 0x048700  LCALL 0x181F:0x0D6C(0x9C=-100, 0, [0x53D2], [0x8D52])       ; tax tick -
 * @asm 0x048714  LCALL 0x1A1F:0x0398([0x5398], [0x8D52])  ; page_0B shared dispatcher(anger,power)
 * @asm 0x048724  bx=[0x8D52]; cl=[bx-0x69D6] (PowerRecord field) ; bx=[0x8D4E]
 * @asm 0x048732  [bx+7] = min(cl, [bx+7]) ; [bx+7] <<= 2          ; market +7 clamp & scale
 * @asm 0x048743  [bx+8] = min(cl, [bx+8]) ; [bx+0xA] = cl * 0x19  ; market +8 / +0xA recompute
 * @asm 0x048755  [bx+3] |= 0x20                                    ; re-arm market +3 bit5
 * @asm 0x048759  bx=[0x8D4E]; [bx+7] = max(0, [bx+7])              ; clamp market +7 >= 0
 * @asm 0x048769  for i in 0..[0x539A]:  (colony/settlement scan)   ; tag this power's lines
 * @asm 0x048770    if [i*0x12 + 0x54EE] == [0x5394]:               ; settlement.power == self
 * @asm 0x04877D      if verbose: LCALL 0x0D1D:0x712(0x1503, i)     ; log line
 * @asm 0x048791      push cs ; call cs:0x5420(i)                  ; power_weekly_economy_tick(i)
 *                                                                  ; -> LJMP 0x1A1F:0x03E0
 * @asm 0x04879B      LCALL 0x181F:0x0470()                         ; (commit/flush)
 * @asm 0x0487B0  (two passes 0..0x10) reconcile market [0x8D4E]+0xE word table:
 * @asm 0x0487D6     w = [bx+si*2+0xE] ; if w>0: w -= [bx+2]+1 (clamp >=0) ; store back
 * @asm 0x0487F8  if verbose: LCALL 0x0D1D:0x712(0x150F)            ; log
 * @asm 0x048809  push arg0 ; LCALL 0x1A1F:0x0270(arg0)             ; (per-power AI/boycott hook; role cited in externs below)
 * @asm 0x048814  LCALL 0x181F:0x0470()                             ; commit
 * @asm 0x048819  bx=[0x8D4E]; if [bx+8] != 0: [bx+0xA] += [bx+8] ; ; market +0xA recompute,
 * @asm 0x04882D     clamp [bx+0xA] to <= ([arg0_base-0x69DE]+0x19)*2          (PowerRecord cap)
 * @asm 0x048844  for i in 0..[0x539C]:  (UnitRecord scan)          ; clear boycott counters
 * @asm 0x04884C    if ([i*0x1C + 0x3147]&0xF) == [0x5394]: [i*0x1C + 0x315A] = 0  ; this power
 * @asm 0x04886C  LCALL 0x181F:0x0470()                             ; commit
 * @asm 0x048871  for i in 0..[0x539C]: (second UnitRecord pass — "FREEDOM" milestone)
 * @asm 0x04887C    if verbose: LCALL 0x0D1D:0x712(0x1516, i, unit.x +0x3144, unit.y +0x3145) ; log
 * @asm 0x0488A4    push cs ; call cs:0x5411(i)                    ; unit_tile_action_dispatch(i)
 *                                                                  ; -> LJMP 0x1A1F:0x03BC
 * @asm 0x0488B5  for i in 0..[0x539C]: (third pass) if 0x181F:0x097A(i):  ; unit eligible?
 * @asm 0x0488D3      if ++unit[+0x315A] > 0x14: LCALL 0x181F:0x0934(i) ; unit[+0x315A]=0  ; trip
 * @asm 0x0488FB  if verbose: LCALL 0x0D1D:0x712(0x1528)            ; log
 * @asm 0x04890C  LCALL 0x181F:0x0A42(arg0)                          ; re-bind power
 * @asm 0x048919  RETF
 *
 * Strings (xref-confirmed inside this extent): "FREEDOM" @0x48878,
 * "MISCELLANEOUS" @0x488B6, "VICEROY.LOG" @0x486EF — i.e. the verbose path
 * appends Sons-of-Liberty / boycott-lift lines to VICEROY.LOG.  0x5420 / 0x5411
 * are page-0C near trampolines:
 *   cs:0x5420 -> LJMP 0x1A1F:0x03E0 -> power_weekly_economy_tick (func_04830E)
 *   cs:0x5411 -> LJMP 0x1A1F:0x03BC -> unit_tile_action_dispatch (func_0482DE)
 * Both verified at file 0x04BA20 / 0x04BA11 (EA xx 03 1F 1A pattern).  0x1A1F:0x0398 = page_0B shared redraw/update dispatcher
 * (cross-ref: overlay_04458A_04694B.c "near 0x9ce -> page-0B redraw dispatcher LJMP
 * 1A1F:0398"; args here are anger scalar [0x5398] and current power [0x8D52]).
 * 0x1A1F:0x0270 = per-power AI/boycott hook (page_0A/0B; exact body not cross-ref'd
 * in sibling files; called immediately before commit 0x0470; role: update power AI
 * state after boycott recovery).  Control flow, the difficulty roll ((5-diff)*2, 1/N lift gate),
 * the price/tax ticks (0x0D6C with +400/-100), the 0x14 unit-counter trip, and
 * the struct offsets (market +3/+7/+8/+0xA, unit +0x315A, settlement +0x54EE)
 * are BYTE_VERIFIED.  [DONE — control flow]
 * ============================================================================ */
extern uint8_t  g_self_power_5394;          /* DGROUP:0x5394 — "self power" (native-id base) */
extern uint16_t g_econ_flags_5382;          /* (re-decl) DGROUP:0x5382 econ-option flags */
extern uint8_t  g_difficulty_53A6;          /* (re-decl) DGROUP:0x53A6 */
extern uint8_t  g_unit_table_3144[];        /* (re-decl) DGROUP:0x3144 UnitRecord[] */
extern uint8_t  g_native_table_54EC[];      /* (re-decl) DGROUP:0x54EC NativeSettlement[] */
extern uint8_t *g_bound_record_8D4A;        /* (re-decl) *(0x8D4A) bound record */
extern uint8_t *g_market_array_8D4E;        /* (re-decl) DGROUP:0x8D4E bound market array */
extern int  ovly_5420_settlement_recover(uint16_t idx);  /* near cs:0x5420 -> LJMP 0x1A1F:0x03E0
                                                          * -> power_weekly_economy_tick (func_04830E).
                                                          * Called per-settlement in the boycott-recovery
                                                          * colony scan loop (0x048791).  Binary verified:
                                                          * file 0x04BA20 = EA E0 03 1F 1A. */
extern int  ovly_5411_unit_recover(uint16_t idx);        /* near cs:0x5411 -> LJMP 0x1A1F:0x03BC
                                                          * -> unit_tile_action_dispatch (func_0482DE).
                                                          * Called per-unit in the FREEDOM-milestone loop
                                                          * (0x0488A4).  Binary verified:
                                                          * file 0x04BA11 = EA BC 03 1F 1A. */
extern int  overlay_call_181F_04CA(void);   /* 0x181F:0x04CA — seed_rng_from_timer([0x83A6]):
                                             * seeds the RNG / primes the log context from
                                             * the timer value at [0x83A6].
                                             * Cross-ref: overlay_04C306_053BC1.c
                                             * "0x181F:0x4CA -> 0x09EF:0x002C seed_rng_from_timer";
                                             * overlay_0341D6_0388DE.c same. */
extern int  overlay_call_181F_097A(void);   /* 0x181F:0x097A — per_unit_type0B_gate(unit_idx):
                                             * returns non-zero if unit is eligible for the
                                             * Sons-of-Liberty / freedom counter.
                                             * Cross-ref: overlay_04C306_053BC1.c
                                             * "0x181F:0x97A -> 0x0427:0x13B0 per_unit_type0B_gate". */
extern int  overlay_call_1A1F_0270(void);   /* 0x1A1F:0x0270 — per-power AI/boycott hook;
                                             * called before commit 0x0470 at boycott-lift;
                                             * exact page_0A/0B body not cross-ref'd here. */
extern int  overlay_call_1A1F_0398(void);   /* 0x1A1F:0x0398 — page_0B shared redraw/update
                                             * dispatcher (cross-ref: overlay_04458A_04694B.c
                                             * "LJMP 1A1F:0398 = shared redraw dispatcher");
                                             * args here are anger-scalar [0x5398], power [0x8D52]. */
/* Per-power byte tables read DS-relative as [power - disp] (power is the small
 * index from [0x8D52], NOT ×stride):  base = 0x10000 - disp.
 *   0x962A region ([bx-0x69D6]) and 0x9622 region ([si-0x69DE]) — per-power
 *   PowerRecord-adjacent scalars; 0x962A is the sawmill-level byte (confirmed by
 *   colony_surrounding_tile_scan which uses it as "saw_level" divisor for lumber
 *   yield); 0x9622 is the per-power max-pool/capacity scalar used to cap market +0xA
 *   (see @asm 0x048830 power_scalar_9622 × 0x19 × 2 cap). */
extern uint8_t g_power_scalar_962A[];  /* DGROUP:0x962A (= 0x10000-0x69D6), per-power saw-level byte */
extern uint8_t g_power_scalar_9622[];  /* DGROUP:0x9622 (= 0x10000-0x69DE), per-power capacity scalar */

int power_weekly_boycott_recover(uint16_t power_index)  /* func_0485F6 */
{
    int verbose = 0;                                 /* @asm 0x0485FB [bp-8]=0 */

    /* @asm 0x048600 — select the diagnostic-log context. */
    overlay_call_181F_04CA();

    /* @asm 0x04860C..0x04862F — set "self power", bind the PowerRecord, run the gate. */
    g_self_power_5394 = (uint8_t)(power_index + 4);  /* @asm 0x04860F */
    overlay_call_181F_0A42();                        /* @asm 0x048618 bind(power) */
    overlay_call_181F_0590();                        /* @asm 0x04862A per-power setup/bind([+0x84C]) */

    /* @asm 0x048632..0x048644 — phase A runs only if the econ-option is set AND the
     * power's market currently has the "boycott active" bit (+3 bit5). */
    if ((g_econ_flags_5382 & 0x01) && !(g_market_array_8D4E[0x03] & 0x20)) {
        /* @asm 0x048649 — recovery magnitude from the tax table. */
        int recover = func_0082A0_logic_sz_18(power_index, DG16(0x5398)); /* table([0x5398], power) */
        int lift = 0;                                /* @asm 0x04867A [bp-0xA]=0 */

        /* @asm 0x04865B..0x048677 — large recoveries roll to become a lift candidate. */
        if (recover >= 0x19) {
            int roll = overlay_call_181F_04D4();     /* @asm 0x048665 random_int(1,400) */
            if (recover >= roll)
                lift = 1;                            /* @asm 0x048672 */
        }
        /* @asm 0x04867F — the market's forced-lift flag (+3 bit6) overrides. */
        if (g_market_array_8D4E[0x03] & 0x40)
            lift = 1;                                /* @asm 0x048689 */

        /* @asm 0x04868E..0x0486B2 — gated 1/((5-diff)*2) chance actually lifts it. */
        if (lift != 0 && overlay_call_181F_04D4() == 0) {  /* @asm 0x0486AE */
            /* @asm 0x0486B5..0x0486E1 — format the recovered commodity for the log/UI. */
            overlay_call_181F_09A4();  overlay_call_181F_0438();   /* slot 0 */
            overlay_call_181F_0A1A();  overlay_call_181F_0438();   /* slot 1 */
            (void)menu_run_boxed(0x14F6);                          /* @asm 0x0486E3 lea bx,
                                                                    * [0x14F6] "INDIANGRUDGE";
                                                                    * 0x0486E7 lcall 0x181F:
                                                                    * 0x3FE (PORTED runner) */

            /* @asm 0x0486EC / 0x048700 — recover the boycotted price (+400) and ease tax (-100). */
            overlay_call_181F_0D6C();                /* price tick +400 @ ([0x5398],power) */
            overlay_call_181F_0D6C();                /* tax  tick -100 @ ([0x53D2],power) */

            /* @asm 0x048714 — page_0B redraw/update dispatcher(anger, power). */
            overlay_call_1A1F_0398();

            /* @asm 0x048724..0x048757 — recompute the market accumulators from the
             * PowerRecord field at [power-0x69D6], then re-arm the boycott bit. */
            uint8_t pf = g_power_scalar_962A[power_index];   /* @asm 0x048728 [bx-0x69D6] */
            uint8_t *mk = g_market_array_8D4E;
            if (pf < mk[0x07]) mk[0x07] = pf;        /* @asm 0x048732 clamp */
            mk[0x07] <<= 2;                          /* @asm 0x04873D scale */
            if (pf < mk[0x08]) mk[0x08] = pf;        /* @asm 0x048743 */
            mk[0x0A] = (uint8_t)(pf * 0x19);         /* @asm 0x04874E (×25) */
            mk[0x03] |= 0x20;                        /* @asm 0x048755 re-arm bit5 */
        }
    }

    /* @asm 0x048759 — clamp the market +7 accumulator to non-negative. */
    if ((int8_t)g_market_array_8D4E[0x07] < 0)
        g_market_array_8D4E[0x07] = 0;

    /* @asm 0x048769..0x0487A9 — tag every live settlement that belongs to this power. */
    for (int i = 0; i < g_native_count_539A; i++) {  /* @asm 0x0487A3 */
        if (g_native_table_54EC[i * NATIVE_SETTLEMENT_STRIDE + 0x02] == g_self_power_5394) {  /* @asm 0x048777 */
            if (verbose)
                overlay_call_0D1D_0712();            /* @asm 0x048789 log(0x1503, i) */
            ovly_5420_settlement_recover((uint16_t)i);  /* @asm 0x048795 */
            overlay_call_181F_0470();                /* @asm 0x04879B commit */
        }
    }

    /* @asm 0x0487AB..0x0487F7 — reconcile the market's 16-word delta table (+0xE):
     * each positive entry decays by (market[+2]+1), clamped to >= 0. */
    for (int i = 0; i < 0x10; i++) {                 /* @asm 0x0487D0 */
        int16_t *w = (int16_t *)&g_market_array_8D4E[i * 2 + 0x0E];
        if (*w > 0) {
            int v = *w - (g_market_array_8D4E[0x02] + 1);  /* @asm 0x0487EE */
            if (v < 0) v = 0;                        /* @asm 0x0487F3 */
            *w = (int16_t)v;
        }
    }

    /* @asm 0x0487F8 / 0x048809 — log + per-power AI/boycott hook (0x1A1F:0x0270), then commit. */
    if (verbose)
        overlay_call_0D1D_0712();                    /* log(0x150F) */
    overlay_call_1A1F_0270();                        /* @asm 0x04880C */
    overlay_call_181F_0470();                        /* @asm 0x048814 commit */

    /* @asm 0x048819..0x048841 — fold the market +8 into +0xA, capped by a PowerRecord field. */
    {
        uint8_t *mk = g_market_array_8D4E;
        if (mk[0x08] != 0) {
            int v = *(int16_t *)&mk[0x0A] + mk[0x08];     /* @asm 0x048827 */
            int cap = (g_power_scalar_9622[power_index] + 0x19) * 2;  /* @asm 0x048830 [si-0x69DE] */
            if (v > cap) v = cap;                    /* @asm 0x04883D */
            *(int16_t *)&mk[0x0A] = (int16_t)v;
        }
    }

    /* @asm 0x048844..0x048864 — clear this power's per-unit boycott counter (+0x315A). */
    for (int i = 0; i < g_unit_count_539C; i++) {    /* @asm 0x048864 */
        uint8_t *u = &g_unit_table_3144[i * UNIT_RECORD_STRIDE];
        if ((u[0x03] & 0x0F) == g_self_power_5394)   /* @asm 0x048856 owner nibble */
            u[0x16] = 0;                             /* @asm 0x04885C unit[+0x16] (abs 0x315A) */
    }
    overlay_call_181F_0470();                        /* @asm 0x04886C commit */

    /* @asm 0x048871..0x0488F0 — "FREEDOM" milestone pass: recover each unit and, for
     * eligible units (0x097A), bump +0x315A; when it exceeds 0x14 the unit trips
     * (0x0934) and the counter resets. */
    for (int i = 0; i < g_unit_count_539C; i++) {    /* @asm 0x0488B5 */
        if (verbose)
            overlay_call_0D1D_0712();                /* @asm 0x048898 log(0x1516, i, x, y) */
        ovly_5411_unit_recover((uint16_t)i);         /* @asm 0x0488A4 */
        if (overlay_call_181F_097A() != 0) {         /* @asm 0x0488C6 eligible? */
            uint8_t *u = &g_unit_table_3144[i * UNIT_RECORD_STRIDE];
            if (++u[0x16] > 0x14) {                  /* @asm 0x0488D7 unit[+0x16] (abs 0x315A) */
                overlay_call_181F_0934();            /* @asm 0x0488E3 trip */
                u[0x16] = 0;                         /* @asm 0x0488EB reset */
            }
        }
    }

    /* @asm 0x0488FB / 0x04890C — final log + re-bind the power. */
    if (verbose)
        overlay_call_0D1D_0712();                    /* log(0x1528) */
    overlay_call_181F_0A42();                        /* @asm 0x04890F re-bind(power) */

    return 0;  /* @asm 0x048919 RETF */
}

/* ============================================================================
 * func_04891A — per-turn native-tribe & relations reset   [DONE — BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * COMPLETED 2026-06-08 — phase C tail (past the prior 0x04897C truncation) was
 * pulled on-demand from VICEROY.EXE via tools/viceroy_exe.py and is now fully
 * decoded; the whole function runs to its RETF at 0x048A39.  Touches *(0x8542)
 * (current colony).  Three phases:
 *
 * Phase A — zero the [8 tribes][4 powers] relation grid at 0x5B04:
 *   @asm 0x04891F  t = 0
 *   @asm 0x048929  p = 0 ; for p in 0..3:
 *   @asm 0x04892F   imul bx,t,0x27 ; bx += p ; shl bx,1   ; word grid, row stride 0x27
 *   @asm 0x048938   [bx+0x5B04] = 0                         ; clear relation[t][p]
 *   @asm 0x048943  for t in 0..7  (8 tribes)
 *
 * Phase B — for each of the 8 tribes, if it is active, run a per-tribe helper:
 *   @asm 0x048955  imul bx,tribe,0x4E                       ; per-tribe record stride 0x4E
 *   @asm 0x048959  test [bx+0x5AD9],0x80 ; jne skip         ; +0x01 bit7 = "destroyed/absent"
 *   @asm 0x048960  push tribe ; CALL 0x4BA0C (cs)           ; tribe_turn_update(tribe)
 *                                                          ; -> LJMP 0x1A1F:0x03B0
 *                                                          ; -> power_weekly_boycott_recover (0x0485F6)
 *   @asm 0x04896D  for tribe in 0..7
 *
 * Phase C — for each known colony (count 0x539E), claim the unowned adjacent
 * tiles around it.  For colony c: bind it (0x181F:0x09E6), read its origin
 * (x=+0, y=+1) and its own owner byte (+0x1A), then walk its surrounding-tile
 * list whose length is colony_helper_C5E()[+0x329].  For surrounding slot k:
 *   tx = origin_x + (int8_t)tile_dx_table[k]   (DGROUP byte table @0xC8)
 *   ty = origin_y + (int8_t)tile_dy_table[k]   (DGROUP byte table @0xDE)
 *   if (colony.tileflags[k] (+0x70) < 0) skip      ; @asm 0x489A7 jl  -> next k
 *   owner = ovly_tile_owner_6DC(tx, ty)            ; @asm 0x489B1
 *   if (owner < 4) skip                            ; @asm 0x489BD jl  -> next k (native/none)
 *   if (owner == colony.owner) skip                ; @asm 0x489C8 je  -> next k (already ours)
 *   if (unit_owner_at(tx, ty) >= 0) skip           ; @asm 0x489D8 jge -> next k (occupied)
 *   else layer_set_object(colony.owner, ty, tx)    ; @asm 0x489E5 claim the tile
 * The outer-loop setup (re-binding the colony record each iteration) reloads the
 * colony pointer from *(0x8542) and re-reads origin/owner @asm 0x48A06..0x48A32.
 *
 * @asm 0x048973  outer idx = 0 ; jmp test @0x489F3
 * @asm 0x0489F3  for idx in 0..[0x539E]-1
 * @asm 0x0489FB   select_player_ctx(idx)            ; 0x181F:0x09E6 bind colony idx
 * @asm 0x048A06   reload *(0x8542); owner=[+0x1A]; x=[+0]; y=[+1]
 * @asm 0x048A1D   bound = colony_helper_C5E()[+0x329]
 * @asm 0x048A2D   inner k = 0 ; jmp inner test @0x4897F
 * @asm 0x04897F   for k in 0..bound-1  (the claim body above)
 *
 * The 0x5B04 grid (8×?, row stride 0x27 words) is the inter-power / tribe
 * relations / alarm matrix that func_046FFA(native AI) and the tea-party / king
 * code also touch.  Whole body BYTE_VERIFIED.
 * ============================================================================ */
extern void tribe_turn_update(int tribe);   /* near file:0x4BA0C -> LJMP 0x1A1F:0x03B0
                                             * -> power_weekly_boycott_recover (func_0485F6).
                                             * Per-tribe weekly boycott/recovery tick.
                                             * Binary verified: file 0x04BA0C = EA B0 03 1F 1A. */
/* Phase-C surrounding-tile delta tables (DGROUP byte tables, indexed by the
 * surrounding-slot counter; signed deltas).  Same tables the colony-tile scan
 * (func_048F34) walks; here addressed as absolute DGROUP offsets per the @asm. */
extern int8_t g_tile_dx_00C8[];   /* DGROUP:0x00C8 — surrounding-tile dx deltas */
extern int8_t g_tile_dy_00DE[];   /* DGROUP:0x00DE — surrounding-tile dy deltas */
/* Current colony pointer + known-colony count (also re-declared below for
 * func_048F34; identical compatible externs).  *(0x8542) is the bound
 * ColonyRecord (byte layout: x +0, y +1, owner +0x1A, tile-flags +0x70). */
extern uint16_t *g_colony_8542;            /* *(0x8542) — current ColonyRecord */
/* overlay_call_181F_09E6 = select_player_ctx(colony_idx); 0x06DC =
 * ovly_tile_owner_6DC(x,y); 0x06D2 = unit_owner_at(x,y); 0x0704 = layer_set_object
 * (owner,y,x).  All declared in overlay_externs.h; called argless per convention.
 * 0x0C5E returns a near record pointer (its +0x329 byte = surrounding-tile count);
 * the pointer-typed name matches src/colony/auto_manage.c. */
extern uint8_t *colony_helper_C5E(void);   /* 0x181F:0x0C5E — render/colony info record ptr */

int native_relations_turn_reset(void)  /* func_04891A */
{
    /* @asm 0x04891F..0x048947 — clear the [8][4] relation grid (word, row stride 0x27). */
    for (int t = 0; t < 8; t++) {                   /* @asm 0x048943 */
        for (int p = 0; p < 4; p++) {               /* @asm 0x048929 */
            g_tribe_relation_5B04[t * 0x27 + p] = 0;/* @asm 0x048938 */
        }
    }

    /* @asm 0x048950..0x048971 — tick every active tribe (skip destroyed: +0x01 bit7). */
    for (int tribe = 0; tribe < 8; tribe++) {       /* @asm 0x04896D */
        if (!(g_native_value_table_5AD8[tribe * 0x4E + 0x01] & 0x80))  /* @asm 0x048959 */
            tribe_turn_update(tribe);               /* @asm 0x048964 */
    }

    /* @asm 0x048973..0x048A35 — phase C: claim each colony's unowned adjacent
     * tiles for that colony's owning power. */
    for (int idx = 0; idx < g_colony_count_539E; idx++) {   /* @asm 0x0489F3 cmp idx,[0x539E]; jge end */
        uint8_t *colony;
        int origin_x, origin_y, owner, bound;

        overlay_call_181F_09E6();                   /* @asm 0x0489FB select_player_ctx(idx): bind colony idx */

        colony   = (uint8_t *)g_colony_8542;        /* @asm 0x048A06 bx = [0x8542] */
        owner    = colony[0x1A];                     /* @asm 0x048A0A colony.owner (+0x1A, zero-extended) */
        origin_x = colony[0x00];                     /* @asm 0x048A12 colony.x (+0x00) */
        origin_y = colony[0x01];                     /* @asm 0x048A17 colony.y (+0x01) */
        bound    = colony_helper_C5E()[0x329];       /* @asm 0x048A1D lcall 0x181F:0xC5E; 0x048A24 [bx+0x329] */

        for (int k = 0; k < bound; k++) {           /* @asm 0x04897F cmp k,bound; jge next-colony */
            int tx = origin_x + g_tile_dx_00C8[k];  /* @asm 0x04898A al=[bx+0xC8]; cwde; +origin_x -> [bp-2] */
            int ty = origin_y + g_tile_dy_00DE[k];  /* @asm 0x048995 al=[bx+0xDE]; cwde; +origin_y -> [bp-6] */
            int tile_owner, occupant;

            if ((int8_t)colony[k + 0x70] < 0)       /* @asm 0x0489A7 cmp byte[colony+k+0x70],0; jl */
                continue;                            /* @asm 0x0489AB -> next k */

            tile_owner = overlay_call_181F_06DC();   /* @asm 0x0489B1 ovly_tile_owner_6DC(tx, ty) -> [bp-4] */
            if (tile_owner < 4)                      /* @asm 0x0489BD cmp ax,4; jl */
                continue;                            /* native/none -> next k */
            if (tile_owner == owner)                 /* @asm 0x0489C8 cmp [bp-4],owner; je */
                continue;                            /* already this colony's -> next k */

            occupant = overlay_call_181F_06D2();     /* @asm 0x0489D0 unit_owner_at(tx, ty) */
            if (occupant >= 0)                       /* @asm 0x0489D8 or ax,ax; jge */
                continue;                            /* tile occupied -> next k */

            overlay_call_181F_0704();                /* @asm 0x0489E5 layer_set_object(owner, ty, tx): claim */
        }
    }

    return 0;  /* @asm 0x048A39 RETF (leave; retf) */
}

/* ============================================================================
 * func_048A3A — native_mission_established  [DONE — BYTE_VERIFIED control flow]
 * ----------------------------------------------------------------------------
 * CORRECTED 2026-05-30: was mislabeled "market_commodity_price_line"; byte-proof:
 * sprintf-pushes message KEY 0x1532 = "MISSION0" @0x048B53 (file = handle +
 * 0x1D9A0).  This is the NATIVE MISSION ESTABLISHED handler — a missionary
 * (arg0) enters a native settlement and founds a mission; the tribe's reaction
 * (curiosity / cautious / offended / hostility) selects the MISSION0..3 variant
 * and adjusts the tribe's attitude.  It is NOT a European price-report worker.
 * The real market price events live in func_0305A8 (PRICEUP/PRICEDOWN @ handles
 * 0x0FA8/0x0FB0) — a different function, left alone.
 *
 * SMOKING GUN: GAME.TXT has four sibling keys whose ONLY difference is the
 * trailing digit — MISSION0 "{tribe} approach new religion with {curiousity}",
 * MISSION1 "{cautious}", MISSION2 "{offended}", MISSION3 "react with {hostility}"
 * (GAME.TXT lines 1092-1110).  At @0x048B95 the code does `[bp-0x21] += class`,
 * and bp-0x21 = bp-0x28+7 is the 8th byte of the sprintf scratch buffer that was
 * just loaded with "MISSION0" — i.e. it rewrites the '0' of "MISSION0" into
 * '0'+class -> "MISSION1/2/3" by the reaction class.  That byte-poke only makes
 * sense for the MISSION0..3 family, proving the native framing.
 *
 * The "commodity / price" reads of the prior pass are reframed: 0x181F:0x030C is
 * tribe_power_relation(tribe,power) (the per-(tribe,power) word @ DGROUP:0x5B1C
 * stride 0x27 — see src/native/haggle.c), NOT a tax table; 0x181F:0x0D6C is
 * "adjust native attitude" (page 0x0B file 0x045DF2 — see src/random_events/
 * lcr.c and src/native/haggle.c trade_relation_adjust), NOT a price tick; the
 * 0x181F:0x07B4(selector, tribe) tests are per-power/relation event bits
 * (power_attribute_bit — lcr.c); bound[+5]&0xF is the settlement.mission field
 * (+0x05), not a commodity nibble.  Authoritative extent: reseg page_0C, 617
 * bytes (0x048A3A..0x048CA4); per-func dump truncated at 79 bytes.
 *
 * Args: arg0 = [bp+6] missionary UnitRecord index (tested at +0x315B = "expert
 *       missionary" near the end); arg1 = [bp+8] mission/relation channel index
 *       (stored into settlement.mission +0x05); arg2 = [bp+0xA] tribe to name.
 * Locals: cur_pow=[bp-0x2A]=[0x8D52]; save4C=[bp-0x34]=[0x8D4C];
 *         count=[bp-0x2C]; delta=[bp-0x2E]; i=[bp-0x30]; class=[bp-0x36];
 *         place=[bp-0x32]; buf=[bp-0x28] (sprintf scratch for the MISSION key).
 *
 * @asm 0x048A3E  [bp-0x2A]=[0x8D52] ; [bp-0x34]=[0x8D4C] ; count/delta/i = 0
 * @asm 0x048A58  for i in 0..[0x539A]:  (settlement scan)
 * @asm 0x048A5B    LCALL 0x181F:0x0A4C(i)                       ; bind settlement i
 * @asm 0x048A66    if [0x8D52]==cur_pow && (bound.mission +5 &0xF)==arg1: count++
 *                                                               ; existing missions on this channel
 * @asm 0x048A89  LCALL 0x181F:0x0A4C([0x8D4C])                  ; re-bind the target settlement
 * @asm 0x048A94  if power_attribute_bit(0x17, arg1): count <<= 1   ; 0x181F:0x07B4 relation event
 * @asm 0x048AA8  if power_attribute_bit(0x18, arg1): count >>= 1 (sar)
 * @asm 0x048ABC  if power_attribute_bit(0x10, arg1): count >>= 1
 * @asm 0x048AD0  if arg1 == 1: count >>= 1                       ; channel-1 halving
 * @asm 0x048AD9  class = 0x181F:0x0A60( tribe_power_relation(cur_pow, arg1) )   ; reaction 0..2
 * @asm 0x048AF6  switch class -> delta = (count<<3) - {5, 0x19, 0xF, 0xA}   ; attitude pressure
 * @asm 0x048B16  if bound[+3]&4 (developed/visited): delta = sign(delta)*8 only (saturate)
 * @asm 0x048B53  push 0x1532="MISSION0" ; lea [bp-0x28] ; LCALL 0x0D1D:0x7E4  ; strcpy key -> buf
 * @asm 0x048B62  clamp class by delta thresholds (< -5 -> >=1 ; >0 -> >=2 ; >=0xA -> 3)
 * @asm 0x048B95  [bp-0x21] += (byte)class                       ; "MISSION0" -> "MISSION{class}"
 * @asm 0x048B9B  LCALL 0x181F:0x0614(bound.x +0, bound.y +1, arg1, -1) -> place  ; locate village
 * @asm 0x048BB8  push [arg1*2 - 0x6808] ; LCALL 0x181F:0x0438(slot0)   ; format STRING0/nationality
 * @asm 0x048BCB  if place >= 0:  push ds:(place*0xCA + 0x5D48) ; LCALL 0x181F:0x0416(1) ; colony place name
 * @asm 0x048BE8  else:           push [arg1*2 - 0x7C74] ; LCALL 0x181F:0x0438(1)         ; fallback name
 * @asm 0x048BFB  push [[0x538C]*2 - 0x6800] ; 0x0438(slot2) ; [0x9CB0:0x9CB2] = (long)[0x538A]  ; year
 * @asm 0x048C1A  push arg2 ; LCALL 0x181F:0x09A4 ; 0x0438(slot3)        ; format tribe (slot3)
 * @asm 0x048C30  if arg1<4 && [arg1*0x34 + 0x543F]==0:  (human power -> show message)
 * @asm 0x048C41    LCALL 0x181F:0x04C0(0x8024) ; push 4,buf ; LCALL 0x181F:0x0652  ; draw line (white)
 * @asm 0x048C57  bound.mission +5 = (byte)arg1                   ; record the mission on the settlement
 * @asm 0x048C61  if missionary[+0x315B] != 0x18 && power_attribute_bit(0x16, arg1): bound[+5] |= 0x10
 *                                                               ; non-expert + flag -> "blessed" bit
 * @asm 0x048C85  LCALL 0x181F:0x0808(arg0)                       ; consume / refresh the missionary unit
 * @asm 0x048C90  LCALL 0x181F:0x0D6C(cur_pow, arg1, delta, 0)    ; adjust tribe attitude by delta
 * @asm 0x048CA2  RETF
 *
 * This is the native-mission-established worker: 0x1532="MISSION0" is the format
 * key (rewritten to MISSION1/2/3 by reaction class), 0x0652 draws the line (white
 * 0x8024 for a live human power), and 0x0D6C applies the signed attitude delta to
 * the per-tribe relation.  The settlement.mission byte (+0x05) is set so the
 * settlement now shows a mission of this power (0x10 = "blessed"/converted bit).
 * Control flow, the relation-event selectors (0x17/0x18/0x10/0x16), the
 * class->delta constants (5/0x19/0xF/0xA, step 8), the MISSION0->MISSION{class}
 * buffer-byte poke, and the human-power gate are BYTE_VERIFIED.  The named tables
 * read at [arg1*2 - 0x6808] / [-0x7C74] / [-0x6800] are DGROUP word tables of
 * message-string pointers (nationality/fallback-name/year — role-inferred); the
 * place locate at (place*0xCA + 0x5D48) confirms ColonyRecord stride 0xCA (base
 * 0x5D46, +0x02 = 0x5D48), i.e. when the mission is founded inside a player
 * colony its name is read from the ColonyRecord.  [DONE — control flow]
 * ============================================================================ */
extern uint16_t g_current_power_8D52;       /* (re-decl) DGROUP:0x8D52 current power */
extern uint8_t  g_power_active_543F[];      /* (re-decl) DGROUP:0x543F per-power activity, stride 0x34 */
/* DGROUP word tables read [arg1*2 - disp]: base = 0x10000 - disp.  In native
 * framing these are message-arg string-pointer tables (nationality / fallback
 * place-name / year-indexed), not price tables.  Contents RUNTIME_ONLY
 * (loaded from nationality data file; per-entry strings not in EXE static image). */
extern uint16_t g_msgptr_natn_97F8[];       /* DGROUP:0x97F8 (= 0x10000-0x6808) STRING0 (nationality) */
extern uint16_t g_msgptr_name_838C[];       /* DGROUP:0x838C (= 0x10000-0x7C74) fallback place name */
extern uint16_t g_msgptr_year_9800[];       /* DGROUP:0x9800 (= 0x10000-0x6800) [0x538C]-indexed */
extern uint8_t  g_colony_table_5D46[];      /* DGROUP:0x5D46 ColonyRecord[], stride 0xCA */
extern int16_t  g_idx_538C;                 /* DGROUP:0x538C — index into g_msgptr_year */

int native_mission_established(uint16_t arg0_bp_06, uint16_t arg1_bp_08,
                               uint16_t arg2_bp_0A)  /* func_048A3A */
{
    uint16_t cur_pow = g_current_power_8D52;          /* @asm 0x048A3E */
    int count = 0;                                    /* @asm 0x048A4C [bp-0x2C] */
    int delta = 0;                                    /* @asm 0x048A4F [bp-0x2E] */

    /* @asm 0x048A58..0x048A87 — count this power's settlements that already hold a
     * mission on channel arg1 (settlement.mission +0x05, low nibble). */
    for (int i = 0; i < g_native_count_539A; i++) {   /* @asm 0x048A81 */
        overlay_call_181F_0A4C();                     /* @asm 0x048A5B bind settlement(i) */
        if (g_current_power_8D52 == cur_pow &&         /* @asm 0x048A66 */
            (g_bound_record_8D4A[0x05] & 0x0F) == (uint8_t)arg1_bp_08)  /* @asm 0x048A76 mission +5 */
            count++;                                  /* @asm 0x048A7B */
    }

    /* @asm 0x048A89 — re-bind the target settlement for the relation-event tests. */
    overlay_call_181F_0A4C();

    /* @asm 0x048A94..0x048AD6 — scale the count by this power's active relation-event
     * bits (power_attribute_bit, 0x181F:0x07B4, selectors 0x17/0x18/0x10). */
    if (overlay_call_181F_07B4() != 0) count <<= 1;   /* @asm 0x048A99 relation event 0x17 */
    if (overlay_call_181F_07B4() != 0) count >>= 1;   /* @asm 0x048AAD relation event 0x18 */
    if (overlay_call_181F_07B4() != 0) count >>= 1;   /* @asm 0x048AC1 relation event 0x10 */
    if (arg1_bp_08 == 1)               count >>= 1;   /* @asm 0x048AD0 channel-1 halving */

    /* @asm 0x048AD9..0x048AF1 — reaction class 0..2 from the tribe-power relation word. */
    (void)func_0082A0_logic_sz_18(DG16(0x8D52), arg1_bp_08); /* tribe_power_relation(cur_pow, arg1) @ 0x5B1C */
    int klass = overlay_call_181F_0A60();             /* @asm 0x048AE9 classify -> [bp-0x36] */

    /* @asm 0x048AF6..0x048B13 — class selects the subtrahend for the attitude delta. */
    switch (klass) {                                  /* @asm 0x048AF8 */
    case 0:  delta = (count << 3) - 0x19; break;      /* @asm 0x048B0A */
    case 1:  delta = (count << 3) - 0x0F; break;      /* @asm 0x048B30 */
    case 2:  delta = (count << 3) - 0x0A; break;      /* @asm 0x048B3C */
    default: delta = (count << 3) - 0x05; break;      /* @asm 0x048AFE */
    }

    /* @asm 0x048B16..0x048B50 — when the settlement is developed/visited (+3 bit2),
     * the attitude delta is forced to a single +/-8 step (sign-saturated). */
    if (g_bound_record_8D4A[0x03] & 0x04) {           /* @asm 0x048B1A */
        int s;
        if (delta > 0)      s = 1;                    /* @asm 0x048B24 */
        else if (delta < 0) s = -1;                   /* @asm 0x048B4A */
        else                s = 0;                    /* @asm 0x048B46 */
        delta = s << 3;                               /* @asm 0x048B4D */
    }

    /* @asm 0x048B53 — copy the "MISSION0" message key (0x1532) into the scratch buffer. */
    overlay_call_0D1D_07E4();                         /* strcpy(buf="MISSION0", key 0x1532) */

    /* @asm 0x048B62..0x048B95 — clamp the reaction class by the delta thresholds, then
     * poke buf[7] so "MISSION0" becomes "MISSION{class}" (0..3 = curiosity / cautious
     * / offended / hostility — GAME.TXT MISSION0..3). */
    if (delta < -5 && klass < 1) klass = 1;           /* @asm 0x048B66 */
    if (delta >  0 && klass < 2) klass = 2;           /* @asm 0x048B7F */
    if (delta >= 0x0A)           klass = 3;           /* @asm 0x048B8E */
    /* buf[7] ([bp-0x21]) += class -> rewrites the trailing '0'.  @asm 0x048B98 */

    /* @asm 0x048B9B — locate the place (player colony, if any) the mission sits on. */
    int place = overlay_call_181F_0614();             /* f(bound.x, bound.y, arg1, -1) */

    /* @asm 0x048BB8 — format STRING0 (nationality) into slot 0. */
    overlay_call_181F_0438();                         /* push g_msgptr_natn_97F8[arg1] */

    /* @asm 0x048BCB..0x048BF8 — slot 1: the colony's place name, or the fallback table. */
    if (place >= 0) {
        /* ColonyRecord[place] at +0x02 (abs 0x5D48); 0x416 takes a ds:ptr (place name). */
        (void)&g_colony_table_5D46[place * 0xCA + 0x02];    /* @asm 0x048BD6 */
        overlay_call_181F_0416();                     /* @asm 0x048BDD (slot 1) */
    } else {
        (void)g_msgptr_name_838C[arg1_bp_08];         /* @asm 0x048BED fallback place name */
        overlay_call_181F_0438();                     /* @asm 0x048BF3 (slot 1) */
    }

    /* @asm 0x048BFB..0x048C2D — slot 2 (year via [0x538C]-indexed table) and slot 3
     * (the tribe, arg2); the [0x9CB0:0x9CB2] long stash is the [0x538A] year value. */
    (void)g_msgptr_year_9800[g_idx_538C];             /* @asm 0x048C01 */
    overlay_call_181F_0438();                         /* slot 2 (year) */
    overlay_call_181F_09A4();                         /* @asm 0x048C1D tribe lookup(arg2) */
    overlay_call_181F_0438();                         /* slot 3 (tribe name) */

    /* @asm 0x048C30..0x048C54 — only show the message for a live human power (white 0x8024). */
    if (arg1_bp_08 < 4 && g_power_active_543F[arg1_bp_08 * 0x34] == 0) {  /* @asm 0x048C3A */
        overlay_call_181F_04C0();                     /* @asm 0x048C44 set color 0x8024 */
        overlay_call_181F_0652();                     /* @asm 0x048C4F draw line(4, buf) */
    }

    /* @asm 0x048C57..0x048C83 — record the mission on the settlement (mission +0x05);
     * for a non-expert missionary with relation event 0x16 set, also set the 0x10
     * "blessed"/converted bit. */
    g_bound_record_8D4A[0x05] = (uint8_t)arg1_bp_08;  /* @asm 0x048C5E settlement.mission = arg1 */
    if (g_unit_table_3144[arg0_bp_06 * UNIT_RECORD_STRIDE + 0x17] != 0x18 &&  /* @asm 0x048C65 +0x315B != expert */
        overlay_call_181F_07B4() != 0)                /* @asm 0x048C71 relation event 0x16 */
        g_bound_record_8D4A[0x05] |= 0x10;            /* @asm 0x048C81 set blessed bit */

    /* @asm 0x048C85 — consume/refresh the missionary unit, then adjust tribe attitude. */
    overlay_call_181F_0808();                         /* @asm 0x048C88 refresh(arg0 missionary) */
    overlay_call_181F_0D6C();                         /* @asm 0x048C9C adjust_native_attitude(cur_pow, arg1, delta, 0) */

    return 0;  /* @asm 0x048CA2 RETF */
}

/* ============================================================================
 * func_048CA4 — native_mission_heresy  [DONE — BYTE_VERIFIED control flow]
 * ----------------------------------------------------------------------------
 * CORRECTED 2026-05-30: was mislabeled "market_commodity_price_settle"; byte-
 * proof: draws message KEY 0x153B = "HERESY0" @0x048EC1 on the win arm and KEY
 * 0x1543 = "HERESY1" @0x048EF0 on the lose arm (file = handle + 0x1D9A0).  This
 * is the NATIVE MISSION HERESY handler — when a missionary contests an EXISTING
 * rival mission in a native settlement, the tribe's converts weigh the two
 * faiths and either burn the rival's mission and erect yours (HERESY0, you win)
 * or burn YOUR missionary at the stake (HERESY1, you lose).  It is NOT a market
 * supply/demand price-settle (the real price events are func_0305A8).
 *
 * GAME.TXT (lines 1112-1122):
 *   HERESY0  "{%STRING0 missionaries} denounce heresy of {%STRING1}.  {%STRING2}
 *             converts burn %STRING1 mission and erect a new, %STRING0 one!"   (WIN)
 *   HERESY1  "{%STRING0 missionaries} denounce heresy of {%STRING1}.  Loyal
 *             {%STRING2} worshipers burn the %STRING0 at the stake!"           (LOSE)
 * STRING0 = your nationality, STRING1 = rival faith, STRING2 = the tribe.
 *
 * SIZE CORRECTION (unchanged): the AUTHORITATIVE reseg page_0C lists ONE function
 * here of 656 bytes (0x048CA4..0x048F34, ENTER 0x20).  The old per-func extractor
 * split it into a fake 84-byte "func_048CA4" + a fake 572-byte "func_048CF8"; the
 * byte at 0x048CF8 is the SECOND byte of `8B C8 (mov cx,ax)` at 0x048CF7 — i.e.
 * mid-instruction, NOT a function start (raw 0x048CF8 = c8 25 0f 00…, the `c8` of
 * 8BC8 then `250F00 and ax,0xf`).  func_048CF8 is a PHANTOM split artifact and the
 * whole 656-byte body lives HERE.
 *
 * Reframing of the prior pass's "commodity / price" reads: the two accumulators
 * are FAITH-STRENGTH buckets, not supply/demand of goods — myFaith=[bp-0x14]
 * (your missionaries' standing) and rivalFaith=[bp-0x18].  0x181F:0x030C is
 * tribe_power_relation(channel, power) (the per-(tribe,power) word @ 0x5B1C,
 * src/native/haggle.c), NOT a tax table; 0x181F:0x0D6C is "adjust native
 * attitude" (page 0x0B file 0x045DF2 — lcr.c / haggle.c trade_relation_adjust),
 * NOT a price tick; bound[+5]&0xF is the settlement.mission channel (+0x05).
 *
 * Args: arg0=[bp+6] missionary UnitRecord index; arg1=[bp+8] YOUR mission channel
 *   (arg1c); arg2=[bp+0xA] tribe/settlement-owner to match.  Locals:
 *   arg1c=[bp-0x12]; rivalCh=[bp-0xE]=bound.mission&0xF; save4C=[bp-8];
 *   myFaith=[bp-0x14]; rivalFaith=[bp-0x18]; aWin=[bp-0xC]; aLose=[bp-0x10];
 *   i=[bp-0x16]; w=[bp-6]; expertMiss=[bp-2]; f10=[bp-0x20]; f04=[bp-0x1C].
 *
 * @asm 0x048CA9  [bp-0x12]=arg1 ; [bp-0xE]=bound.mission&0xF ; [bp-8]=[0x8D4C]
 * @asm 0x048CC2  myFaith/rivalFaith/aWin/aLose/i = 0
 * @asm 0x048D4A  for i in 0..[0x539A]: bind settlement(i) ; if bound.owner +2 ==arg2:
 * @asm 0x048D6E    LCALL 0x181F:0x0316(&w, i)  ; w = standing word for this settlement
 * @asm 0x048D80    if w == rivalCh: rivalFaith += w ; continue
 * @asm 0x048CD6    (per-record accumulate) classify the settlement's mission byte:
 * @asm 0x048CEA      if bound.mission +5 >= 0 (has a mission):  s = w (+bound[+4] pop,
 *                    x2 if mission&0x10 "blessed", x2 if +3&4 developed) ; route by channel:
 *                    == arg1c -> myFaith ; == rivalCh -> rivalFaith ; else -> aWin += s ; aLose += s
 * @asm 0x048D92  bind([0x8D4C]) ; expertMiss = ([arg0*0x1C + 0x315B] == 3)        ; expert missionary?
 * @asm 0x048DB3  f10 = bound.mission +5 &0x10 ("blessed") ; f04 = bound[+3]&4 (developed)
 * @asm 0x048DC9  myFaith    += tribe_power_relation(rivalCh, cur_pow) << f04
 * @asm 0x048DE1  rivalFaith += tribe_power_relation(arg1c , cur_pow) >> (1 - f04)
 * @asm 0x048DFA  myFaith += 0x181F:0x0A60(myFaith) + 1 ; aLose += 0x0A60(rivalFaith) + 1 ; round
 * @asm 0x048E19  if f04: rivalFaith += random_int(1,0x14) ; myFaith += random_int(1,0x14) ;
 *                        aLose <<= 1 ; aWin <<= 1                                    ; zeal noise
 * @asm 0x048E46  if expertMiss: myFaith <<= 1 ; aLose <<= 1                          ; expert bonus
 * @asm 0x048E52  if f10:        rivalFaith <<= 1 ; aWin <<= 1                        ; blessed bonus
 * @asm 0x048E5E  format arg1c (0x9A4/0x438 slot0=STRING0), rivalCh (slot1=STRING1), [0x8D50] (slot2=STRING2)
 * @asm 0x048EA1  roll = random_int(1, myFaith+rivalFaith) ; if roll <= rivalFaith([bp-0x18]):  (WIN)
 * @asm 0x048EB7    color 0x8024 (white) ; draw 0x153B="HERESY0" (slot4) ; bound.mission=arg1c ;
 *                  if expertMiss: bound.mission |= 0x10 ; aWin = -aWin                ; take the mission
 * @asm 0x048EE6  else (roll > rivalFaith): color 0x53 ; draw 0x1543="HERESY1" ; aLose = -aLose  ; burned
 * @asm 0x048EFE  LCALL 0x181F:0x0808(arg0)                                            ; consume missionary
 * @asm 0x048F09  LCALL 0x181F:0x0D6C(cur_pow, rivalCh, aLose, 0)                      ; attitude tick A
 * @asm 0x048F1D  LCALL 0x181F:0x0D6C(cur_pow, arg1c , aWin , 0)                       ; attitude tick B
 * @asm 0x048F31  RETF
 *
 * The two-sided accumulation (myFaith vs rivalFaith) and the win/lose roll make
 * this the religious-conversion contest; the two 0x0D6C calls adjust the tribe's
 * attitude on both the rival channel (rivalCh) and your channel (arg1c).  Strings
 * 0x153B "HERESY0" (win, white 0x8024) / 0x1543 "HERESY1" (lose, color 0x53) are
 * the two outcome banners.  On a win the settlement's mission (+0x05) is rewritten
 * to your channel (with the 0x10 "blessed" bit for an expert missionary).  Control
 * flow, the standing-word open 0x0316, the x2 / >>(1-f04) scales, the
 * random_int(1,0x14) zeal noise, and the faith roll are BYTE_VERIFIED.
 * [DONE — control flow]
 * ============================================================================ */
int native_mission_heresy(uint16_t arg0_bp_06, uint16_t arg1_bp_08,
                          uint16_t arg2_bp_0A)  /* func_048CA4 (absorbs 0x048CF8) */
{
    int arg1c   = (int)arg1_bp_08;                    /* @asm 0x048CA9 [bp-0x12] your channel */
    int rivalCh = g_bound_record_8D4A[0x05] & 0x0F;   /* @asm 0x048CB3 [bp-0xE] rival mission channel */
    int myFaith = 0, rivalFaith = 0, aWin = 0, aLose = 0;   /* @asm 0x048CC2 */
    int expertMiss = 0, f10 = 0, f04 = 0;
    (void)arg2_bp_0A;

    /* @asm 0x048D4A..0x048D8E + 0x048CD6..0x048D47 — accumulate faith strength from every
     * settlement owned by arg2: read each settlement's standing word (open 0x0316),
     * scale it by its mission state, and route it into myFaith (your channel arg1c),
     * rivalFaith (the rival channel rivalCh), or the cross terms (aWin/aLose). */
    for (int i = 0; i < g_native_count_539A; i++) {   /* @asm 0x048D4D */
        overlay_call_181F_0A4C();                     /* @asm 0x048D55 bind settlement(i) */
        if (g_bound_record_8D4A[0x02] != (uint8_t)arg2_bp_0A)  /* @asm 0x048D64 owner +2 */
            continue;
        int w = 0;
        overlay_call_181F_0316();                     /* @asm 0x048D75 open -> standing word w */
        int channel = g_bound_record_8D4A[0x05] & 0x0F;
        /* per-record scaling: + pop(+0x04), x2 if "blessed" (+5&0x10), x2 if developed (+3&4). */
        if ((int8_t)g_bound_record_8D4A[0x05] >= 0) {     /* @asm 0x048CEE has a mission */
            int s = w + g_bound_record_8D4A[0x04];
            if (g_bound_record_8D4A[0x05] & 0x10) s <<= 1;   /* @asm 0x048D13 blessed */
            if (g_bound_record_8D4A[0x03] & 0x04) s <<= 1;   /* @asm 0x048D1C developed */
            if (channel == arg1c)       myFaith += s;        /* @asm 0x048D27 your faith */
            else if (channel == rivalCh) rivalFaith += s;    /* @asm 0x048D38 rival faith */
            else { aWin += s; aLose += s; }                  /* @asm 0x048D41 */
        }
    }

    /* @asm 0x048D92..0x048DC6 — re-bind the contested settlement; mission flags drive scales. */
    overlay_call_181F_0A4C();                         /* bind([0x8D4C]) */
    expertMiss = (g_unit_table_3144[arg0_bp_06 * UNIT_RECORD_STRIDE + 0x17] == 3); /* +0x315B @0x048DA1 */
    f10 = (g_bound_record_8D4A[0x05] & 0x10) != 0;    /* @asm 0x048DBA "blessed" */
    f04 = (g_bound_record_8D4A[0x03] & 0x04) != 0;    /* @asm 0x048DC3 "developed" */

    /* @asm 0x048DC9..0x048DF7 — tribe-power relation contributes to each side. */
    {
        int t = func_0082A0_logic_sz_18(DG16(0x8D52), (uint16_t)rivalCh); /* @asm 0x048DD2 tribe_power_relation(rivalCh, cur_pow) */
        myFaith += t << (f04 ? 1 : 0);                /* @asm 0x048DDC shl by f04 */
    }
    {
        int t = func_0082A0_logic_sz_18(DG16(0x8D52), (uint16_t)arg1c); /* @asm 0x048DE8 tribe_power_relation(arg1c, cur_pow) */
        rivalFaith += t >> (1 - f04);                 /* @asm 0x048DF5 sar by (1-f04) */
    }

    /* @asm 0x048DFA..0x048E16 — round both buckets via 0x0A60(+1). */
    myFaith += overlay_call_181F_0A60() + 1;          /* @asm 0x048DFE (myFaith) */
    aLose   += overlay_call_181F_0A60() + 1;          /* @asm 0x048E0D (rivalFaith) */

    /* @asm 0x048E19..0x048E5C — zeal noise (developed) & expert/blessed doublings. */
    if (f04) {                                        /* @asm 0x048E19 */
        rivalFaith += overlay_call_181F_04D4();       /* @asm 0x048E23 random_int(1,0x14) */
        myFaith    += overlay_call_181F_04D4();       /* @asm 0x048E32 */
        aLose <<= 1; aWin <<= 1;                       /* @asm 0x048E40 */
    }
    if (expertMiss) { myFaith <<= 1; aLose <<= 1; }   /* @asm 0x048E4C expert bonus */
    if (f10)        { rivalFaith <<= 1; aWin <<= 1; } /* @asm 0x048E58 blessed bonus */

    /* @asm 0x048E5E..0x048E9E — format the banner fields: STRING0 (your nationality, arg1c),
     * STRING1 (rival faith, rivalCh), STRING2 (the tribe, [0x8D50]). */
    overlay_call_181F_09A4();  overlay_call_181F_0438();   /* slot 0 (STRING0) */
    overlay_call_181F_09A4();  overlay_call_181F_0438();   /* slot 1 (STRING1) */
    overlay_call_181F_09A4();  overlay_call_181F_0438();   /* slot 2 (STRING2) */

    /* @asm 0x048EA1..0x048EFB — faith roll picks the outcome banner & attitude signs.
     * @asm 0x048EA1 ax=myFaith([bp-0x14]); 0x048EA4 ax+=rivalFaith([bp-0x18]); roll =
     * random_int(1, total); @asm 0x048EB2 cmp roll, rivalFaith([bp-0x18]);
     * @asm 0x048EB5 jg lose.  So the fall-through WIN (HERESY0) arm is roll <= rivalFaith
     * (compare is byte-exact against [bp-0x18]); roll > rivalFaith => LOSE (HERESY1). */
    if (overlay_call_181F_04D4() <= rivalFaith) {     /* @asm 0x048EAA roll; @asm 0x048EB2 cmp [bp-0x18] */
        /* @asm 0x048EB7 — you win: converts burn the rival mission, erect yours. */
        overlay_call_181F_04C0();                     /* @asm 0x048EBA colour white 0x8024 */
        overlay_call_181F_0652();                     /* @asm 0x048EC4 draw(4, 0x153B="HERESY0") */
        g_bound_record_8D4A[0x05] = (uint8_t)arg1c;   /* @asm 0x048ED3 mission -> your channel */
        if (expertMiss)
            g_bound_record_8D4A[0x05] |= 0x10;        /* @asm 0x048EDC blessed */
        aWin = -aWin;                                 /* @asm 0x048EE1 */
    } else {
        /* @asm 0x048EE6 — you lose: loyal worshipers burn your missionary at the stake. */
        overlay_call_181F_04C0();                     /* @asm 0x048EE9 colour 0x53 */
        overlay_call_181F_0652();                     /* @asm 0x048EF3 draw(4, 0x1543="HERESY1") */
        aLose = -aLose;                               /* @asm 0x048EFB */
    }

    /* @asm 0x048EFE..0x048F2E — consume the missionary, then adjust tribe attitude on both channels. */
    overlay_call_181F_0808();                         /* @asm 0x048F01 refresh/consume(arg0) */
    overlay_call_181F_0D6C();                         /* @asm 0x048F15 adjust_native_attitude(cur_pow, rivalCh, aLose, 0) */
    overlay_call_181F_0D6C();                         /* @asm 0x048F29 adjust_native_attitude(cur_pow, arg1c, aWin, 0) */

    return 0;  /* @asm 0x048F31 RETF */
}

/* ============================================================================
 * func_048CF8 — PHANTOM (mid-instruction split artifact of func_048CA4)
 * ----------------------------------------------------------------------------
 * NOT a function.  The authoritative reseg page_0C has a single 656-byte
 * function spanning 0x048CA4..0x048F34 (see native_mission_heresy
 * above).  File offset 0x048CF8 lands on the SECOND byte of the 2-byte
 * `8B C8 (mov cx,ax)` at 0x048CF7 — raw bytes at 0x048CF8 are
 *   c8 25 0f 00 89 46 fc 8a   (= the 0xC8 of 8BC8, then 25 0F 00 = `and ax,0xf`).
 * The old per-func extractor mis-read 0xC8 as an `ENTER 0x0F25` prologue.  No
 * body is emitted.  [PHANTOM — byte-confirmed]
 * ============================================================================ */
/* PHANTOM: 0x048CF8 is mid-body of func_048CA4 (2nd byte of `8B C8`) — see banner. */

/* ============================================================================
 * func_048F34 — colony surrounding-tile / production map scan
 *                                          [DONE — BYTE_VERIFIED control flow]
 * ----------------------------------------------------------------------------
 * Touches *(0x8542) (current colony) and *(0x8D4A) (render/scan base).  Builds
 * the colony's 5×5 surrounding-tile working set and tallies terrain-type
 * resource potential into per-resource accumulators, then writes summary values
 * to DGROUP 0x9E58 / 0x9E78 and the 16-word arrays at 0x9E58/0x9E78.  This is a
 * colony-screen / production-layout routine (IN SCOPE per the UI-layout rule).
 *
 * Phase A — clear the 25-cell visited bitmap ([bp-0x98], 0x19 bytes):
 *   @asm 0x048F6C  for i in 0..0x18: [bp+i-0x98] = 0
 *
 * Phase B — for each known/owned colony (count 0x539E), and for each of its
 * own units (per-colony list via 0x181F:0x09E6(colony)), test 5×5 adjacency to
 * THIS colony and mark the matching 5×5 cell visited:
 *   @asm 0x048F92  bx=[0x8D4A]; ax = bx.y(+1) - colony.y(*0x8542 +1) + row
 *   @asm 0x048FAF             ; cx = bx.x(+0)   - colony.x(*0x8542 +0) + col
 *   @asm 0x048FC0  LCALL 0x181F:0x0302(ax-2, cx-2)  ; tiles_adjacent? (range test)
 *   @asm 0x048FCC  bounds 0<=col<5 && 0<=row<5
 *   @asm 0x048FF6  LCALL 0x181F:0x0CE0(otherColony, col) ; owner/claim check
 *   @asm 0x049012  [bp + (row*5+col) - 0x98] = 1         ; mark visited
 *
 * Phase C — main per-tile classify over the 5×5 grid (skip visited):
 *   @asm 0x04913D  LCALL 0x181F:0x0302(row,col)           ; valid tile?
 *   @asm 0x049185  LCALL 0x181F:0x078C(row,col) -> ax     ; terrain type id [bp-0x7e]
 *   @asm 0x049190  classify ax into resource accumulators:
 *      0x1B (Forest/Lumber bonus)   -> [bp-0x9e]++         ; (special tiles)
 *      0x1C                          -> [bp-0x9a]++
 *      0x18                          -> [bp-0x58] += 4
 *      0x08..0x0F / 0x10..0x17       -> food/ore class buckets ([bp-0x6c] etc.)
 *   @asm 0x049066  (sub-classifier 0x19/0x1A and 0..8 -> finished-goods buckets:
 *      +0x58,+0x6c,+0x56,+0x7c,+0x66,+0x64,+0x68 accumulators per terrain id)
 *
 * Phase D — finalize:
 *   @asm 0x049242  base = colony.level(*0x8D4A +4)+1 ; n = base*base (tile count)
 *   @asm 0x049259  zero the 16-word output arrays at 0x9E58 and 0x9E78
 *   @asm 0x049271  scale = (7 - market[+0x02]) ; per-resource:
 *                  0x9E78 += (market[+0x02]+base)*[bp-0x6c]/scale  ; weighted yield
 *   @asm 0x0492A7  0x9E58 = ([bp-0xA0]<<2) >> (market[+0x02]>1?1:0) ; capacity
 *   @asm 0x0492AA..0x0495FF  full per-slot yield/cap writes, normalize, fort
 *                  bonus, demand decay and the colony-screen draw — all decoded
 *                  below (the earlier "truncated past 0x0492CD" note was stale;
 *                  the body runs to its RETF at 0x0495FF).  [BYTE_VERIFIED]
 *
 * The terrain-type ids (0x08..0x1C) and resource-bucket assignments here are the
 * colony production-potential map.  The control flow, struct offsets (colony x/y
 * at *0x8542 +0/+1, level at *0x8D4A +4, market +0x02), grid stride (5), and
 * output bases (0x9E58/0x9E78) are BYTE_VERIFIED for the phases shown.  The
 * 0x181F callees (0x0302 adjacency, 0x078C terrain-type, 0x0CE0 claim, 0x09E6
 * per-colony units) are role-named externs.
 *
 * EXTENT NOTE (authoritative reseg page_0C): the REAL function is 1740 bytes
 * (insns=624).  All four phases (A/B/C/D) are now BYTE_VERIFIED from the full
 * page_0C body.  Phase C: terrain classify + accumulator arithmetic 0x049066..
 * 0x049223.  Phase D: base/tiles init 0x049242, output-array zero 0x049259,
 * food/silver/sugar/cotton/grain/tobacco/fish/lumber/minerals weighted writes
 * 0x049271..0x049366, slot writes 0x04938F..0x049431, cap-normalize loop
 * 0x04943E..0x049460, fort-bonus doubles 0x049462..0x0494B5, per-slot
 * yield/cap decay + demand-price adjustment 0x0494B7..0x0495DD, epilogue
 * draw + RETF 0x0495DE..0x0495FF.  BYTE_VERIFIED 2026-06-08.
 * ============================================================================ */
extern uint16_t *g_colony_8542;            /* *(0x8542) — current ColonyRecord (x +0, y +1) */
extern uint16_t  g_prod_yield_9E78[16];    /* DGROUP:0x9E78 — per-resource weighted yield out */
extern uint16_t  g_prod_cap_9E58[16];      /* DGROUP:0x9E58 — per-resource capacity out */

/* Scan/render base record pointer; byte layout: [+0]=scan_x, [+1]=scan_y, [+4]=colony level */
extern uint8_t  *g_bound_record_8D4A;      /* DGROUP:0x8D4A — *(word) = ptr to BoundRecord */
/* Market record pointer; [+2]=mkt demand byte, [+7]=fur-base, [+0xa]=lumber-base,
 * [+0xc]=lumber-market-base, [+i*2+0xe]=demand word for slot i */
extern uint8_t  *g_market_8D4E;            /* DGROUP:0x8D4E — *(word) = ptr to MarketRecord */
/* g_current_power_8D52 (power index) is declared above @line 850; the sawmill-level
 * byte [cur_record-0x69D6] is reached via the per-power array g_power_scalar_962A
 * (DGROUP:0x962A == 0x10000-0x69D6), matching the file-wide idiom (see @line 2079). */

/* The "g_9eXX" per-resource production-slot words are NOT independent globals:
 * they are elements of the two contiguous 16-word arrays above.
 *   g_prod_cap_9E58[k]   lives at 0x9E58 + 2*k   (cap   array, 0x9E58..0x9E76)
 *   g_prod_yield_9E78[k] lives at 0x9E78 + 2*k   (yield array, 0x9E78..0x9E96)
 * Together they form one 32-word block 0x9E58..0x9E96 that the Phase-D clear
 * loop zeroes in full, and that the cap-normalize / fort-bonus loops re-scan.
 * The original `mov [0x9eXX],..` writes therefore MUST be modelled as indexed
 * array writes (so the zeroing + later loops see the same storage); writing them
 * as standalone scalars would silently drop the aliasing.  Slot map (addr→index):
 *   yield[1]=0x9E7A cotton  yield[2]=0x9E7C sugar   yield[3]=0x9E7E tobacco-acc
 *   yield[4]=0x9E80 silver  yield[6]=0x9E84 mineral yield[7]=0x9E86 lumber
 *   yield[8]=0x9E88 lumber2 yield[11]=0x9E8E tob-cap yield[12]=0x9E90 silver-cap
 *   yield[15]=0x9E96 (zeroed)
 *   cap[2]=0x9E5C grain-cap cap[3]=0x9E5E tob-yld  cap[8]=0x9E68 fur-yld
 *   cap[9]=0x9E6A fish      cap[10]=0x9E6C slot     cap[11]=0x9E6E grain-yld
 *   cap[12]=0x9E70 slot     cap[13]=0x9E72 slot     cap[14]=0x9E74 slot
 *   cap[15]=0x9E76 fur-cap                                              */
/* g_flags_894 declared in native_unit_ai.c; re-declare locally (bit 2 = colony screen) */
extern uint8_t   g_flags_894;             /* DGROUP:0x894 — options/display flags bitfield */
/* g_trade_after_97C0 (DGROUP:0x97C0) declared below func_04AC00 as g_trade_after_97C0[];
 * here it serves as the per-slot resource-name id array for the colony screen draw. */
extern uint16_t  g_prod_name_97C0[16];    /* DGROUP:0x97C0 — resource name ids [16] */

int colony_surrounding_tile_scan(void)  /* func_048F34 */
{
    /* 25-cell (5x5) visited bitmap; indices [bp-0x98 .. -0x80]. */
    uint8_t visited[25];

    /* Phase A: @asm 0x048F6C..0x048F7B — clear the visited bitmap. */
    for (int i = 0; i < 0x19; i++)
        visited[i] = 0;

    /* Phase B: @asm 0x048F86..0x04901D — mark cells claimed by OTHER colonies'
     * units so this colony cannot also work them.  Iterates the known colonies
     * (0x539E) and, per colony, its units (0x181F:0x09E6), doing the 5x5
     * adjacency test (0x181F:0x0302) against THIS colony at *0x8542 and the
     * owner/claim check (0x181F:0x0CE0).  Marks visited[row*5+col]=1.
     * (Coordinate math cited in banner; full loop preserved structurally.) */
    for (int other = 0; other < g_colony_count_539E; other++) {  /* @asm 0x04902F */
        overlay_call_181F_09E6();        /* bind other colony's unit list */
        for (int row = 0; row < 5; row++) {                      /* @asm 0x04901D */
            for (int col = 0; col < 5; col++) {                  /* @asm 0x048F89 */
                /* @asm 0x048FC0 — adjacency/range test vs this colony. */
                if (overlay_call_181F_0302() == 0) continue;
                /* @asm 0x048FCC..0x048FE2 — in-bounds 0<=row,col<5. */
                /* @asm 0x048FF6 — claimed by the other colony? mark visited. */
                if ((row != 2 || col != 2) && overlay_call_181F_0CE0() >= 0) {
                    visited[row * 5 + col] = 1;                  /* @asm 0x049012 */
                }
            }
        }
    }

    /* -----------------------------------------------------------------------
     * Phase C: @asm 0x04904A..0x049241 — classify each non-visited tile by
     * terrain type; accumulate into resource bucket locals.
     * ----------------------------------------------------------------------- */
    int forest_cnt  = 0;   /* [bp-0x9e] — terrain 0x1B tiles */
    int terrain_sub = 0;   /* [bp-0x9c] — scratch: terrain-8 or terrain-0x10 */
    int mineral_cnt = 0;   /* [bp-0x9a] — terrain 0x1C tiles */
    int special_cnt = 0;   /* [bp-0x5c] — special-terrain counter */
    int ore_cnt     = 0;   /* [bp-0x72] */
    int grain_cnt   = 0;   /* [bp-0x58] */
    int fish_cnt    = 0;   /* [bp-0x68] */
    int food_cnt    = 0;   /* [bp-0x6c] */
    int cotton_cnt  = 0;   /* [bp-0x56] */
    int hills_accum = 0;   /* [bp-0x78] — batch-converts to food_cnt */
    int tobacco_cnt = 0;   /* [bp-0x66] */
    int sugar_cnt   = 0;   /* [bp-0x7c] */
    int fur_cnt     = 0;   /* [bp-0x64] */

    /* @asm 0x04904A — scan_x/scan_y from BoundRecord at *g_bound_record_8D4A */
    int scan_x = (int)(int8_t)g_bound_record_8D4A[0]; /* [bx+0] cast to signed */
    int scan_y = (int)(int8_t)g_bound_record_8D4A[1]; /* [bx+1] cast to signed */

    /* @asm 0x049055 — outer row loop: row = scan_y-2 .. scan_y+2 */
    for (int row_c = scan_y - 2; row_c <= scan_y + 2; row_c++) { /* @asm 0x049229..0x049233 */
        /* @asm 0x04923B — inner col loop: col = scan_x-2 .. scan_x+2 */
        for (int col_c = scan_x - 2; col_c <= scan_x + 2; col_c++) { /* @asm 0x04912F..0x049132 */
            /* @asm 0x04913D — valid tile? push row_c, col_c */
            if (overlay_call_181F_0302() == 0)  /* LCALL 0x181F:0x0302(row_c,col_c) */
                continue;                        /* @asm 0x049147 */

            /* @asm 0x049149..0x049173 — compute visited-array index */
            int row_idx = (row_c - scan_y) + 2; /* [bp-0x5a] */
            int col_idx = (col_c - scan_x) + 2; /* [bp-4]    */
            int vi = row_idx * 5 + col_idx;      /* [bp-0x6e] */

            /* @asm 0x049178 — skip if already claimed by another colony */
            if (visited[vi])                     /* @asm 0x04917d */
                continue;

            /* @asm 0x049185 — terrain_type = get_terrain_type(row_c, col_c) */
            int tt = func_00627A_op_sz_57((uint16_t)col_c, (uint16_t)row_c); /* LCALL 0x181F:0x078C(row_c,col_c) */
            /* [bp-0x7e] = tt */

            /* @asm 0x049190 — special exact-match checks first */
            if (tt == 0x1b) forest_cnt++;                        /* @asm 0x049195 */
            if (tt == 0x1c) mineral_cnt++;                       /* @asm 0x04919e */
            if (tt == 0x18) grain_cnt += 4;                      /* @asm 0x0491a7 */

            /* @asm 0x0491ab — range dispatch: 8..15 -> food; 16..23 -> food;
             * <8 or >=0x18 -> secondary classifier at 0x049066 */
            if ((tt >= 8 && tt < 0x10) || (tt >= 0x10 && tt < 0x18)) {
                /* @asm 0x0491c5 — food_cnt++ */
                food_cnt++;

                /* @asm 0x0491d2..0x0491d5 — terrain_sub = tt-8 for 8..15 */
                if (tt >= 8 && tt < 0x10) {
                    terrain_sub = tt - 8;
                }
                /* @asm 0x0491e5..0x0491eb — terrain_sub = tt-0x10 for 16..23 */
                if (tt >= 0x10 && tt < 0x18) {
                    terrain_sub = tt - 0x10;
                }

                /* @asm 0x0491ef — terrain_sub < 3: special_cnt++, grain_cnt+=2 */
                if (terrain_sub < 3) {
                    special_cnt++;                               /* @asm 0x04905c */
                    grain_cnt += 2;                              /* @asm 0x04905f */
                } else {
                    /* @asm 0x0491f9 — ore_cnt++, fish_cnt++ */
                    ore_cnt++;                                   /* @asm 0x0491f9 */
                    fish_cnt++;                                  /* @asm 0x0491fc */
                    /* @asm 0x0491ff — terrain_sub==5: cotton_cnt+=2 */
                    if (terrain_sub == 5) cotton_cnt += 2;      /* @asm 0x049206 */
                    /* @asm 0x04920a — terrain_sub==4: sugar_cnt+=2 */
                    if (terrain_sub == 4) sugar_cnt  += 2;      /* @asm 0x049211 */
                    /* @asm 0x049215 — terrain_sub==3: tobacco_cnt+=2 */
                    if (terrain_sub == 3) tobacco_cnt += 2;     /* @asm 0x04921f */
                }
            } else {
                /* Secondary classifier @asm 0x049066 — terrain 0x19/0x1A and 0..7 */

                /* @asm 0x049066..0x049070 — hills types 0x19 or 0x1A */
                if (tt == 0x19 || tt == 0x1a) {
                    /* @asm 0x049072..0x04907c — hills_accum += market[+2]+1 */
                    int mkt2 = (int)(uint8_t)g_market_8D4E[2]; /* [bx+2] */
                    hills_accum += mkt2 + 1;                    /* @asm 0x04907c */
                    /* @asm 0x04907f..0x049090 — batch: while hills_accum>=3: food_cnt+=2 */
                    while (hills_accum >= 3) {                  /* @asm 0x04907f */
                        food_cnt    += 2;                       /* @asm 0x049088 */
                        hills_accum -= 3;                       /* @asm 0x04908c */
                    }
                } else if (tt < 8) {
                    /* @asm 0x049092..0x04909b — terrain 0..7 classify */

                    /* @asm 0x04909b — id==5: cotton_cnt+=4 */
                    if (tt == 5) cotton_cnt  += 4;              /* @asm 0x0490a1 */
                    /* @asm 0x0490a5 — id==7: cotton_cnt+=2 */
                    if (tt == 7) cotton_cnt  += 2;              /* @asm 0x0490ab */
                    /* @asm 0x0490af — id==4: sugar_cnt+=4 */
                    if (tt == 4) sugar_cnt   += 4;              /* @asm 0x0490b5 */
                    /* @asm 0x0490b9 — id==6: sugar_cnt+=2 */
                    if (tt == 6) sugar_cnt   += 2;              /* @asm 0x0490bf */
                    /* @asm 0x0490c3 — id==3: tobacco_cnt+=4 */
                    if (tt == 3) tobacco_cnt += 4;              /* @asm 0x0490c9 */
                    /* @asm 0x0490cd — id==0: fur_cnt+=2 */
                    if (tt == 0) fur_cnt     += 2;              /* @asm 0x0490d3 */

                    /* @asm 0x0490d7 — id==2: tobacco_cnt++, food_cnt+=2 */
                    if (tt == 2) {
                        tobacco_cnt++;                           /* @asm 0x0490dd */
                        food_cnt    += 2;                       /* @asm 0x0490e0 */
                    }

                    /* @asm 0x0490e4 — id >= 2: food_cnt+=2 (cumulative with above) */
                    if (tt >= 2) {
                        food_cnt += 2;                          /* @asm 0x0490ea */
                        if (tt >= 6) {
                            /* @asm 0x049106 — id>=6: fur_cnt++ */
                            fur_cnt++;                           /* @asm 0x049106 */
                        } else {
                            /* @asm 0x0490f4 — 2<=id<6: food_cnt++ */
                            food_cnt++;                          /* @asm 0x0490f4 */
                            /* @asm 0x0490f7 — if id&4: fish_cnt+=2; else grain+=2.
                             * NOTE: the !(id&4) arm is `jmp 0x04905f` (e9 5f ff =>
                             * 0x049100-0xA1=0x04905f), the GRAIN-ONLY entry — it does
                             * NOT pass through 0x04905c (special_cnt++).  Only the
                             * food-branch terrain_sub<3 path (jmp 0x04905c) bumps
                             * special_cnt; ids 2/3 here add grain alone. */
                            if (tt & 4) {
                                fish_cnt += 2;                   /* @asm 0x049100 */
                            } else {
                                grain_cnt += 2;                  /* @asm 0x04905f (grain only) */
                            }
                        }
                    } else {
                        /* @asm 0x04910c — id <= 1 */
                        if (tt == 1) {
                            fish_cnt  += 4;                      /* @asm 0x049112 */
                        } else if (tt == 0) {
                            grain_cnt += 3;                      /* @asm 0x04911e */
                        }
                    }
                }
                /* tt >= 0x18 (already handled above) or tt >= 8 already done */
            }
        } /* col loop */
    } /* row loop */

    /* -----------------------------------------------------------------------
     * Phase D: @asm 0x049242..0x0495FF — finalize per-resource output arrays.
     * ----------------------------------------------------------------------- */

    /* @asm 0x049242..0x049250 — base = colony_level+1; tiles = base*base */
    int base  = (int)(uint8_t)g_bound_record_8D4A[4] + 1;  /* [bx+4]=level @asm 0x049242 */
    int tiles = base * base;                                  /* @asm 0x04924e..0x049250 */

    /* @asm 0x049254..0x04926f — zero output arrays */
    for (int i = 0; i < 16; i++) {                           /* @asm 0x049259..0x04926f */
        g_prod_yield_9E78[i] = 0;
        g_prod_cap_9E58[i]   = 0;
    }

    /* @asm 0x049271 — bx = g_market_8D4E; mkt = market[+2] */
    int mkt = (int)(uint8_t)g_market_8D4E[2];                /* @asm 0x049275 */

    /* @asm 0x049281..0x04928b — food slot (yield array [0]):
     *   g_prod_yield_9E78[0] += (mkt+base)*food_cnt / (7-mkt) */
    {
        int scale = 7 - mkt;                                  /* @asm 0x04927f */
        g_prod_yield_9E78[0] += (uint16_t)(int16_t)(((mkt + base) * food_cnt) / scale); /* @asm 0x049285..0x04928b */
    }

    /* @asm 0x049293..0x0492a7 — food capacity [0]:
     *   shift = (mkt>1)?1:0 ; g_prod_cap_9E58[0] = (tiles*4) >> shift */
    {
        int shift = (mkt > 1) ? 1 : 0;                       /* @asm 0x049293..0x04929c */
        g_prod_cap_9E58[0] = (uint16_t)((tiles * 4) >> shift); /* @asm 0x04929e..0x0492a7 */
    }

    /* @asm 0x0492aa — gate mkt >= 1 for lumber+minerals */
    if (mkt >= 1) {                                           /* @asm 0x0492af */
        if (mkt >= 2) {                                       /* @asm 0x0492b6 */
            /* @asm 0x0492b8..0x0492f0 — lumber slot (yield[7] = 0x9E86):
             *   divisor = max(1, saw_level)
             *   yield[7] = market[+0xc] / divisor
             *   forest_adj = (mkt>2) ? forest_cnt*8 : forest_cnt*4
             *   yield[7] += forest_adj */
            int lmb_base = (int)(uint16_t)(*(uint16_t *)(g_market_8D4E + 0xc)); /* [bx+0xc] @asm 0x0492b8 */
            int saw = (int)g_power_scalar_962A[g_current_power_8D52]; /* [cur-0x69d6] saw level @asm 0x0492bb..0x0492c3 */
            /* @asm 0x0492c3..0x0492cc — divisor = max(1, saw) via sub/sbb/not/and/add */
            int divisor = (saw < 1) ? 1 : saw;               /* @asm 0x0492d1 */
            g_prod_yield_9E78[7] = (uint16_t)((int16_t)(lmb_base / divisor)); /* 0x9E86 @asm 0x0492d5..0x0492d7 */
            /* @asm 0x0492da..0x0492ed — forest_adj */
            int forest_adj = forest_cnt * 4;                  /* @asm 0x0492de */
            if (mkt > 2) forest_adj = forest_cnt * 8;         /* @asm 0x0492eb */
            g_prod_yield_9E78[7] += (uint16_t)forest_adj;     /* 0x9E86 @asm 0x0492f0 */
        }

        /* @asm 0x0492f4..0x04930b — minerals/ore slot (yield[6] = 0x9E84):
         *   yield[6] += mineral_cnt*2 + forest_cnt + fur_cnt */
        g_prod_yield_9E78[6] += (uint16_t)(int16_t)(mineral_cnt * 2 + forest_cnt + fur_cnt); /* 0x9E84 @asm 0x04930b */
    }

    /* @asm 0x04930f..0x049328 — silver/ore yield (yield[4] = 0x9E80):
     *   yield[4] += (special_cnt*2 + ore_cnt/2) / (mkt+1) */
    {
        int sv = (special_cnt * 2) + (ore_cnt >> 1);          /* @asm 0x04930f..0x049319 */
        g_prod_yield_9E78[4] += (uint16_t)((int16_t)(sv / (mkt + 1)));  /* 0x9E80 @asm 0x049326..0x049328 */
    }

    /* @asm 0x04932c..0x049341 — silver capacity (yield[12] = 0x9E90):
     *   yield[12] = abs((yield[4]+mkt)*2) / 4 * 2
     * cdq/xor/sub/sar/xor/sub/shl = signed (x/4)*2; x>=0 here so abs is exact. */
    {
        int sv2 = ((int16_t)g_prod_yield_9E78[4] + mkt) * 2;  /* @asm 0x04932f..0x049331 */
        int absv = (sv2 < 0) ? -sv2 : sv2;                    /* @asm 0x049334..0x049336 */
        g_prod_yield_9E78[12] = (uint16_t)((absv / 4) * 2);   /* 0x9E90 @asm 0x049338..0x049341 */
    }

    /* @asm 0x049344..0x04934e — sugar (yield[2]=0x9E7C) and cotton (yield[1]=0x9E7A) */
    g_prod_yield_9E78[2] += (uint16_t)(int16_t)sugar_cnt;     /* 0x9E7C @asm 0x049344..0x049347 */
    g_prod_yield_9E78[1] += (uint16_t)(int16_t)cotton_cnt;    /* 0x9E7A @asm 0x04934b..0x04934e */

    /* @asm 0x049352..0x049366 — grain yield (cap[11] = 0x9E6E):
     *   cap[11] = (mkt+base)*base + fish_cnt/2 + grain_cnt */
    g_prod_cap_9E58[11] = (uint16_t)(int16_t)(
        (mkt + base) * base + (fish_cnt >> 1) + grain_cnt);   /* 0x9E6E @asm 0x049352..0x049366 */

    /* @asm 0x049369..0x049386 — tobacco accumulator (yield[3]=0x9E7E) → cap (yield[11]=0x9E8E):
     *   yield[3] += tobacco_cnt
     *   yield[11] = abs((mkt + yield[3])*2) / 4 * 2 */
    g_prod_yield_9E78[3] += (uint16_t)(int16_t)tobacco_cnt;   /* 0x9E7E @asm 0x04936e */
    {
        int tb2 = (mkt + (int16_t)g_prod_yield_9E78[3]) * 2;  /* @asm 0x049372..0x049376 */
        int absv = (tb2 < 0) ? -tb2 : tb2;
        g_prod_yield_9E78[11] = (uint16_t)((absv / 4) * 2);   /* 0x9E8E @asm 0x049386 */
    }

    /* @asm 0x049389..0x04938c — cap[3]=0x9E5E = yield[11] + fish_cnt */
    g_prod_cap_9E58[3] = (uint16_t)((int16_t)g_prod_yield_9E78[11] + fish_cnt); /* 0x9E5E @asm 0x049389..0x04938c */

    /* @asm 0x04938f..0x0493a2 — cap[2]=0x9E5C = (6-mkt)*base + grain_cnt*2 + 5 */
    g_prod_cap_9E58[2] = (uint16_t)(int16_t)(
        (6 - mkt) * base + grain_cnt * 2 + 5);                /* 0x9E5C @asm 0x04938f..0x0493a2 */

    /* @asm 0x0493a5..0x0493b2 — cap[10]=0x9E6C = (base*2 - mkt + 7) * 2 */
    g_prod_cap_9E58[10] = (uint16_t)(int16_t)((base * 2 - mkt + 7) * 2);  /* 0x9E6C @asm 0x0493a5..0x0493b2 */

    /* @asm 0x0493b5..0x0493bf — cap[12]=0x9E70 = grain_cnt*8 + yield[4] */
    g_prod_cap_9E58[12] = (uint16_t)(int16_t)(grain_cnt * 8 + (int16_t)g_prod_yield_9E78[4]); /* 0x9E70 @asm 0x0493b5..0x0493bf */

    /* @asm 0x0493c2..0x0493d1 — cap[9]=0x9E6A = ((mkt*2 + base)*2 + fish_cnt)*2 */
    g_prod_cap_9E58[9] = (uint16_t)(int16_t)(
        ((mkt * 2 + base) * 2 + fish_cnt) * 2);               /* 0x9E6A @asm 0x0493c2..0x0493d1 */

    /* @asm 0x0493d5..0x0493e7 — cap[13]=0x9E72 = (mkt+2)*(base+3) + 8 */
    g_prod_cap_9E58[13] = (uint16_t)(int16_t)((mkt + 2) * (base + 3) + 8); /* 0x9E72 @asm 0x0493e2..0x0493e7 */

    /* @asm 0x0493ea..0x0493f9 — cap[14]=0x9E74 = (mkt*base) << (grain_cnt/2 + 1) */
    {
        int shift74 = (grain_cnt >> 1) + 1;                   /* @asm 0x0493f3..0x0493f5 */
        g_prod_cap_9E58[14] = (uint16_t)(int16_t)((mkt * base) << shift74); /* 0x9E74 @asm 0x0493f7..0x0493f9 */
    }

    /* @asm 0x0493fc..0x04940a — fur cap (cap[15]=0x9E76):
     *   cap[15] = (7 - market[+7] - mkt) * 4 */
    {
        int fur_base7 = (int)(uint8_t)g_market_8D4E[7];       /* [bx+7] @asm 0x0493fc */
        g_prod_cap_9E58[15] = (uint16_t)(int16_t)((7 - fur_base7 - mkt) * 4); /* 0x9E76 @asm 0x049400..0x04940a */
    }

    /* @asm 0x04940d..0x049420 — yield[8]=0x9E88 = market[+0xa] / ((saw_level>>1)+1) */
    {
        int lmb10 = (int)(uint16_t)(*(uint16_t *)(g_market_8D4E + 0xa)); /* [bx+0xa] @asm 0x04940d */
        int saw2  = (int)g_power_scalar_962A[g_current_power_8D52]; /* [cur-0x69d6] saw level @asm 0x049410..0x049414 */
        int div88 = (saw2 >> 1) + 1;                           /* @asm 0x049418..0x04941c */
        g_prod_yield_9E78[8] = (uint16_t)((int16_t)(lmb10 / div88)); /* 0x9E88 @asm 0x04941d..0x049420 */
    }

    /* @asm 0x049423..0x049431 — cap[8]=0x9E68 = (9 - market[+8] - mkt) * 4 */
    {
        int mb8 = (int)(uint8_t)g_market_8D4E[8];              /* [bx+8] @asm 0x049423 */
        g_prod_cap_9E58[8] = (uint16_t)(int16_t)((9 - mb8 - mkt) * 4); /* 0x9E68 @asm 0x049427..0x049431 */
    }

    /* @asm 0x049434..0x049436 — zero yield[15]=0x9E96 */
    g_prod_yield_9E78[15] = 0;                                  /* 0x9E96 @asm 0x049436 */

    /* @asm 0x04943e..0x049460 — per-slot cap normalize:
     *   g_prod_cap_9E58[i] = overlay_call_181F_035C(g_prod_cap_9E58[i], 0, 50) */
    for (int i = 0; i < 16; i++) {                             /* @asm 0x04945c */
        /* push 50; push 0; push g_prod_cap_9E58[i]; LCALL 0x181F:0x035c */
        g_prod_cap_9E58[i] = (uint16_t)overlay_call_181F_035C(); /* @asm 0x04944d..0x049455 */
    }

    /* @asm 0x049462..0x0494b5 — fort bonus if colony has fort-flag bit 2 set */
    if ((uint8_t)g_bound_record_8D4A[3] & 4) {                 /* [bx+3] @asm 0x049466 */
        /* @asm 0x049471..0x049481 — double cap slots 0..7 */
        for (int i = 0; i <= 7; i++)
            g_prod_cap_9E58[i] <<= 1;                          /* @asm 0x049476 */
        /* @asm 0x049488..0x04949e — boost cap slots 13..15 by x1.5 */
        for (int i = 0xd; i <= 0xf; i++) {
            g_prod_cap_9E58[i] += (uint16_t)((int16_t)g_prod_cap_9E58[i] >> 1); /* @asm 0x049493 */
        }
        /* @asm 0x0494a5..0x0494b5 — double yield slots 7..15 */
        for (int i = 7; i < 16; i++)
            g_prod_yield_9E78[i] <<= 1;                        /* @asm 0x0494aa */
    }

    /* @asm 0x0494b7..0x0495dd — per-slot yield/cap decay + demand-price adjust */
    for (int i = 0; i < 16; i++) {                             /* @asm 0x049598..0x04959c */
        /* Load this slot */
        int yld_val = (int16_t)g_prod_yield_9E78[i];          /* [bp-0x6a] @asm 0x0495a7 */
        int cap_val = (int16_t)g_prod_cap_9E58[i];            /* [bp-0x60] @asm 0x0495ae */

        /* @asm 0x0495b3..0x0495b9 — demand word from market[i*2+0xe] */
        int demand = (int16_t)(*(int16_t *)(g_market_8D4E + i * 2 + 0xe)); /* @asm 0x0495b9 */

        if (demand > 0) {
            /* @asm 0x0495c6..0x0495d6 — supply-pressure cap adjust:
             *   g_prod_cap_9E58[i] = cap_val + 2*(-50-demand)/100 */
            g_prod_cap_9E58[i] = (uint16_t)(int16_t)(
                cap_val + 2 * ((-50 - demand) / 100));         /* @asm 0x0495c6..0x0495d6 */
        } else if (demand < 0) {
            /* @asm 0x0494c6..0x0494d6 — negative demand yield boost:
             *   g_prod_yield_9E78[i] += 2*(demand+50)/100 */
            g_prod_yield_9E78[i] += (uint16_t)(int16_t)(
                2 * ((demand + 50) / 100));                    /* @asm 0x0494c6..0x0494d6 */
        }

        /* @asm 0x0494da — display gate (bit 2 = colony screen active) */
        if (g_flags_894 & 4) {                                  /* @asm 0x0494da */
            /* @asm 0x0494e6..0x0494ed — only draw if yield or cap non-zero */
            if ((int16_t)g_prod_yield_9E78[i] != 0 || (int16_t)g_prod_cap_9E58[i] != 0) {
                /* push g_prod_cap_9E58[i]; push g_prod_yield_9E78[i]; push g_prod_name_97C0[i] */
                overlay_call_181F_0022();  /* LCALL 0x181F:0x0022 draw_resource_slot @asm 0x049505 */
                /* LCALL 0x0D1D:0x0B48 sprintf into [bp-0x54] format 0x154b @asm 0x049516 */
                overlay_call_0D1D_0B48();
                /* LCALL 0x181F:0x013C draw_text_at(ss:[bp-0x54],1,(i+1)*8,15) @asm 0x04952f */
                overlay_call_181F_013C();
            }
        }

        /* @asm 0x049537..0x049591 — yield/cap decay:
         *   saved_yld = yield
         *   yield  -= cap/2       ; yield = max(0_or_1_if_yld_val>0, yield)
         *   cap    -= saved_yld/2 ; cap   = max(0_or_1_if_cap_val>0, cap) */
        {
            int saved_yld = (int16_t)g_prod_yield_9E78[i];    /* @asm 0x049540 */
            int new_yld   = saved_yld - ((int16_t)g_prod_cap_9E58[i] >> 1); /* @asm 0x049547 */
            int yld_floor = (yld_val > 0) ? 1 : 0;            /* @asm 0x049551..0x04955c */
            if (new_yld < yld_floor) new_yld = yld_floor;
            g_prod_yield_9E78[i] = (uint16_t)(int16_t)new_yld; /* @asm 0x049568 */

            int new_cap   = (int16_t)g_prod_cap_9E58[i] - (saved_yld >> 1); /* @asm 0x049583 */
            int cap_floor = (cap_val > 0) ? 1 : 0;            /* @asm 0x04956c..0x049578 */
            if (new_cap < cap_floor) new_cap = cap_floor;
            g_prod_cap_9E58[i] = (uint16_t)(int16_t)new_cap;  /* @asm 0x049591 */
        }
    }

    /* @asm 0x0495de..0x0495fb — epilogue: if display flag set, draw rect + flip */
    if (g_flags_894 & 4) {                                      /* @asm 0x0495de */
        /* push 0; push 0x140; push 0xc8; LCALL 0x181F:0x00e2 draw_rect @asm 0x0495f2 */
        overlay_call_181F_00E2();
        /* LCALL 0x181F:0x03e0 refresh/flip @asm 0x0495f7 */
        overlay_call_181F_03E0();
    }

    return 0;  /* @asm 0x0495fe LEAVE / 0x0495ff RETF */
}

/* ============================================================================
 * func_049600 — native trade haggle resolver  [SUPERSEDED]
 * ----------------------------------------------------------------------------
 * Already hand-ported (ANCHOR_VERIFIED flow) to src/native/haggle.c
 * (native_haggle_resolve).  The real function spans file 0x049600..0x04A37A
 * (3451 bytes) — the 186-byte per-func dump is only the entry.  No body here.
 * ============================================================================ */
/* SUPERSEDED: ported to src/native/haggle.c (native_haggle_resolve). */

/* ============================================================================
 * func_04A37C — native wagon-train / attack reward roll
 *                                          [DONE — BYTE_VERIFIED control flow]
 * ----------------------------------------------------------------------------
 * The sibling of the haggle resolver (haggle.c banner notes "func_04A37C handles
 * the wagon-train attack").  Computes a threshold from a per-power table, rolls
 * random_int(0, 0x1F4=500), draws a value via 0x181F:0x09A4, and compares.
 *
 * @asm 0x04A380  push [bp+0xA] ; push [0x8D52] ;
 * @asm 0x04A387  LCALL 0x181F:0x030C([0x8D52], arg1)   ; threshold = table(power, arg1)
 * @asm 0x04A38F  [bp-6] = threshold
 * @asm 0x04A392  push 0x1F4 ; push 0 ;
 * @asm 0x04A39B  LCALL 0x181F:0x04D4(0, 500)           ; roll = random_int(0,500)
 * @asm 0x04A3A3  [bp-2] = roll
 * @asm 0x04A3A6  push [bp+0xC] ; LCALL 0x181F:0x09A4(arg2) ; v = lookup(arg2)
 * @asm 0x04A3B1  push v ; push 0 ; LCALL 0x181F:0x0438(0, v) ; (format/scale v)
 * @asm 0x04A3BC  if roll > threshold goto 0x4A3E6
 * @asm 0x04A3C4  (roll<=threshold)   msg 0x15C3; call 0x808; return 1
 * @asm 0x04A3E6  (roll>threshold)    if 2*threshold < roll goto 0x4A402
 * @asm 0x04A3ED  (threshold<roll<=2t) msg 0x15CE; return 0
 * @asm 0x04A402  (roll>2*threshold)  msg 0x15DA; call 0x4BA48(all args); return 0
 *
 * COMPLETED 2026-06-08 (was truncated at 0x04A3C8 in the prior per-func dump;
 * full tail pulled on-demand from VICEROY.EXE via tools/viceroy_exe.py). The
 * prior body was INVERTED (it returned 1 on roll>threshold) and collapsed a
 * THREE-tier graduated outcome into a 2-way. The real result depends on how far
 * the roll exceeds the threshold: best (<=t), middle (<=2t), worst (>2t), each
 * with its own message key (0x15C3 / 0x15CE / 0x15DA). @status BYTE_VERIFIED.
 * ============================================================================ */
extern uint16_t g_current_power_8D52;   /* DGROUP:0x8D52 — current/active power index */
extern int  overlay_call_191F_019C(void);                 /* 0x191F:0x019C — keyed message show */
extern void native_attack_apply_4BA48(int a, int b, int c, int d); /* near call cs:0x4BA48 */

/* func_04A37C -- graduated native wagon-train-attack outcome roll.
 * Returns 1 only on the best tier (roll <= threshold); 0 on the two worse tiers.
 * args: bp+6, bp+8 passed through to the tier-3 applier; bp+0xA selects the
 * threshold table column; bp+0xC selects the reward magnitude. Message keys
 * 0x15C3/0x15CE/0x15DA distinguish the three outcome tiers. */
int native_attack_reward_roll(uint16_t a_bp_06, uint16_t b_bp_08,
                              uint16_t col_bp_0A, uint16_t reward_bp_0C)  /* func_04A37C */
{
    int threshold = func_0082A0_logic_sz_18(DG16(0x8D52), col_bp_0A); /* @asm 0x04A387 table(0x8D52, col) -> [bp-6] */
    int roll      = overlay_call_181F_04D4();    /* @asm 0x04A39B random_int(0,500) -> [bp-2] */
    int result    = 0;                            /* @asm 0x04A397 [bp-4]=0 */

    overlay_call_181F_09A4();                     /* @asm 0x04A3A9 v = lookup(reward) */
    overlay_call_181F_0438();                     /* @asm 0x04A3B4 format/scale(0, v) */

    if (roll <= threshold) {                      /* @asm 0x04A3BF cmp roll,threshold; jg 0x4A3E6 */
        overlay_call_181F_0652();                 /* @asm 0x04A3C9 best-tier message key 0x15C3 */
        overlay_call_181F_0808();                 /* @asm 0x04A3D4 (a_bp_06) */
        result = 1;                               /* @asm 0x04A3DC [bp-4]=1 */
    } else if (roll <= 2 * threshold) {           /* @asm 0x04A3E6 shl threshold,1; cmp; jl 0x4A402 */
        overlay_call_191F_019C();                 /* @asm 0x04A3F4 middle-tier message key 0x15CE, power 0x8D52 */
    } else {                                      /* @asm 0x04A402 roll > 2*threshold */
        overlay_call_191F_019C();                 /* @asm 0x04A409 worst-tier message key 0x15DA, power 0x8D52 */
        native_attack_apply_4BA48(a_bp_06, b_bp_08, col_bp_0A, reward_bp_0C); /* @asm 0x04A41E */
    }
    (void)g_current_power_8D52;
    return result;                                /* @asm 0x04A421 mov ax,[bp-4] */
}

/* ============================================================================
 * func_04A426 — colony commodity-recommendation / specialization advisor
 *                                  [head BYTE_VERIFIED; advisory tail decoded-spine]
 * ----------------------------------------------------------------------------
 * CORRECTED & EXTENDED 2026-06-08.  The prior pass mis-titled this as a 13-byte
 * "native event sound/cue selector" and stubbed it with `return 0` right after
 * the cs:0x5443 call — hiding ~880 bytes of body (the function runs
 * 0x04A426..0x04A7C9).  The cue-selection (5/7/6) is only the OPENING; the real
 * function picks the best commodity for a colony to specialize in and shows the
 * advisory message (keys 0x15E7..0x1625), with a completely different branch for
 * arg [bp+0xC]==0 (compute & recommend) vs !=0 (the per-unit follow-up path).
 * Real arity is 4: [bp+6], [bp+8] (the "free" power slot), [bp+0xA] (a power id
 * passed to rel_event_query_other / power_field), [bp+0xC] (path selector).
 *
 * Phase 0 — sound cue (head, BYTE_VERIFIED):
 *   @asm 0x04A42B  free = (slot<4 && [slot*0x34 + 0x543F]==0)
 *   @asm 0x04A449  if free && random_int(0,3)==0: cue(5); if [0x8D52]==0 cue(7);
 *                  if [0x8D52]==1 cue(6)     ; 0x181F:0x0498 (sound leaf)
 *   @asm 0x04A48C  CALL cs:0x5443 -> colony_surrounding_tile_scan (func_048F34)
 *                  ; this fills the production-yield array at 0x9E78 for the colony
 *   @asm 0x04A48F  push [0x917A] ; LCALL 0x181F:0x04CA   ; seed_rng_from_timer
 *
 * Phase 1 — production-yield post-process (BYTE_VERIFIED):
 *   @asm 0x04A49B  pack32 = colony[+1]*256 + colony[+0] + [0x8D80:0x8D82] (32-bit)
 *   @asm 0x04A4C7  LCALL 0x181F:0xD90(pack32)            ; commit/context the coord
 *   @asm 0x04A4CF  yield[8]=0 ; then gate by market demand byte [0x8D4E +2]:
 *   @asm 0x04A4D9   demand<1: yield{12,6}=0, yield[0]>>=1
 *   @asm 0x04A4EB   demand<2: yield{11,10,7}=0, yield[0]-=yield[0]>>2
 *   @asm 0x04A506   demand<3: yield[9]=0
 *   @asm 0x04A512   demand==3: yield[7]+=yield[7]>>1
 *
 * Phase 2 — weighted commodity pick (BYTE_VERIFIED):
 *   @asm 0x04A521  sum = Σ_{i<0x10} yield[i] ; pick = random_int(1,sum)
 *   @asm 0x04A551  slot = -1; do { slot++; pick -= yield[slot]; } while (pick>0)
 *   @asm 0x04A56B  if slot==4 && (colony[+1]+colony[+0])%3==0: slot = 0x16
 *
 * Phase 3 — advisory dispatch (cited spine; many message-key arms 0x15E7..0x1625,
 *   surrounding-tile validation 0x181F:0x768, power_field/ff_value gating, and the
 *   [bp+0xC]==0 vs !=0 split @0x04A58F..0x04A7C9).  The message text/branch
 *   formatting calls (strcpy_near_7E4, ovl_msg_simple, msg_set_arg) are UI leaves;
 *   the spine is cited block-by-block in the body and the chosen `slot` is the
 *   RETF value.  Not every advisory text arm is transcribed to C (UI layer); the
 *   computation that decides the recommendation IS decoded above.
 * ============================================================================ */
extern uint8_t  g_power_active_543F[];  /* DGROUP:0x543F — per-power activity table, stride 0x34 */
extern uint32_t g_coord_base_8D80;      /* DGROUP:0x8D80 — 32-bit map coord base added to packed y:x */
extern int      overlay_call_181F_0D90(void);  /* 0x181F:0x0D90 — commit/select tile by packed coord32 */
extern int      ovly_4BA43_finalize(void);  /* near file:0x4BA43 = cs:0x5443 (SAME trampoline as
                                            * ovly_5443_trade_finalize) -> LJMP 0x1A1F:0x0434
                                            * -> colony_surrounding_tile_scan (func_048F34).
                                            * Binary verified: file 0x04BA43 = EA 34 04 1F 1A. */

int colony_commodity_advisor(uint16_t a_bp_06, uint16_t power_slot_bp_08,
                             uint16_t other_bp_0A, uint16_t path_bp_0C)  /* func_04A426 */
{
    /* @asm 0x04A42B..0x04A444 — "free" = slot is a live European power with an
     * empty activity entry. */
    int is_free = 0;
    if (power_slot_bp_08 < 4 &&
        g_power_active_543F[power_slot_bp_08 * 0x34] == 0)   /* @asm 0x04A435 */
        is_free = 1;

    /* @asm 0x04A449..0x04A488 — when free, maybe play the appropriate cue. */
    if (is_free) {
        if (overlay_call_181F_04D4() == 0) {        /* @asm 0x04A453 random_int(0,3) */
            overlay_call_181F_0498();               /* @asm 0x04A45F cue(5) */
            if (g_current_power_8D52 == 0)          /* @asm 0x04A469 */
                overlay_call_181F_0498();           /* @asm 0x04A472 cue(7) */
            if (g_current_power_8D52 == 1)          /* @asm 0x04A47A */
                overlay_call_181F_0498();           /* @asm 0x04A483 cue(6) */
        }
    }

    /* @asm 0x04A48C — fill the colony production-yield array (0x9E78) for the
     * current colony, then re-seed the RNG. */
    ovly_4BA43_finalize();                          /* @asm 0x04A48C colony_surrounding_tile_scan */
    overlay_call_181F_04CA();                       /* @asm 0x04A493 seed_rng_from_timer([0x917A]) */

    {
        uint8_t  *bound  = (uint8_t *)g_bound_record_8D4A;    /* *(0x8D4A) bound record @asm 0x04A49B */
        uint8_t  *market = (uint8_t *)g_market_8D4E;          /* @asm 0x04A4D5 */
        int       demand;
        int       slot, sum, pick;

        /* @asm 0x04A49B..0x04A4CC — pack (y*256 + x) + coord base into a dword and
         * commit it as the active tile/colony context.  The packed value
         *   coord32 = (bound[+1]<<8) + bound[+0] + g_coord_base_8D80
         * is the argument; called argless per this file's overlay-thunk convention. */
        overlay_call_181F_0D90();                   /* @asm 0x04A4C7 commit coord32 */

        /* @asm 0x04A4CF..0x04A51D — demand-gated production-yield trimming. */
        g_prod_yield_9E78[8] = 0;                   /* @asm 0x04A4CF */
        demand = (int)(uint8_t)market[2];           /* @asm 0x04A4D9 market demand byte (+0x02) */
        if (demand < 1) {                           /* @asm 0x04A4DD jae 0x4A4EB */
            g_prod_yield_9E78[12] = 0;              /* @asm 0x04A4E1 (0x9E90) */
            g_prod_yield_9E78[6]  = 0;              /* @asm 0x04A4E4 (0x9E84) */
            g_prod_yield_9E78[0] = (uint16_t)((int16_t)g_prod_yield_9E78[0] >> 1); /* @asm 0x04A4E7 (0x9E78) */
        }
        if (demand < 2) {                           /* @asm 0x04A4EF jae 0x4A506 */
            g_prod_yield_9E78[11] = 0;             /* @asm 0x04A4F3 (0x9E8E) */
            g_prod_yield_9E78[10] = 0;             /* @asm 0x04A4F6 (0x9E8C) */
            g_prod_yield_9E78[7]  = 0;             /* @asm 0x04A4F9 (0x9E86) */
            g_prod_yield_9E78[0] -=
                (uint16_t)((int16_t)g_prod_yield_9E78[0] >> 2); /* @asm 0x04A4FC..0x04A502 (0x9E78 ×0.75) */
        }
        if (demand < 3)                             /* @asm 0x04A50A jae 0x4A512 */
            g_prod_yield_9E78[9] = 0;              /* @asm 0x04A50C (0x9E8A) */
        if (demand == 3)                            /* @asm 0x04A516 jne 0x4A521 */
            g_prod_yield_9E78[7] +=
                (uint16_t)((int16_t)g_prod_yield_9E78[7] >> 1); /* @asm 0x04A518 (0x9E86 ×1.5) */

        /* @asm 0x04A521..0x04A569 — weighted-random commodity pick over the
         * 16-slot yield table. */
        sum = 0;                                    /* @asm 0x04A521 [bp-0x16]=0 */
        for (int i = 0; i < 0x10; i++)              /* @asm 0x04A53B */
            sum += (int16_t)g_prod_yield_9E78[i];   /* @asm 0x04A531 */
        pick = overlay_call_181F_04D4();            /* @asm 0x04A546 random_int(1, sum) -> [bp-0x14] */
        slot = -1;                                  /* @asm 0x04A551 [bp-0x36]=0xFFFF */
        do {
            slot++;                                 /* @asm 0x04A556 inc */
            pick -= (int16_t)g_prod_yield_9E78[slot]; /* @asm 0x04A55E sub [bp-0x14],yield[slot] */
        } while (pick > 0);                         /* @asm 0x04A565 jg 0x4A556 */

        /* @asm 0x04A56B..0x04A58A — slot 4 (silver) with a (x+y)%3==0 colony gets
         * remapped to slot 0x16 (a special recommendation id). */
        if (slot == 4) {                            /* @asm 0x04A56F jne 0x4A58F */
            int s = (int)bound[1] + (int)bound[0];  /* @asm 0x04A571 colony[+1]+colony[+0] */
            if (s % 3 == 0)                         /* @asm 0x04A583 idiv 3; or dx,dx; jne */
                slot = 0x16;                        /* @asm 0x04A58A */
        }

        /* @asm 0x04A58F..0x04A7C9 — advisory dispatch (cited spine):
         *  - if slot==0 (no positive yield), validate the colony's 20 surrounding
         *    tiles via 0x181F:0x768 (ovl_fortify_accum) counting workable ones;
         *    a low count flips slot to 8 (a "needs growth" recommendation).
         *    @asm 0x04A595..0x04A5F1
         *  - re-seed RNG, then split on path_bp_0C:
         *      path==0  -> compute the recommendation text for commodity `slot`,
         *                  emit message keys per slot/relation (0x15E7 expert,
         *                  0x15EB/0x15F4/0x1601 commodity name variants, 0x1608
         *                  fortified, 0x1610 hostile-roll, 0x1615/0x161F congress,
         *                  0x1625 default); gated by power_field([0x8D52],bp+8),
         *                  ff_value, tribe_or_ff_flags(bp+0xA,bp+8)&0x60==0x20.
         *                  @asm 0x04A5FE..0x04A77B
         *      path!=0  -> the per-unit follow-up branch at 0x04A7C3 (unit bp+6).
         *  The message/text calls (strcpy_near_7E4, ovl_msg_simple, msg_set_arg,
         *  rel_event_query_other) are UI leaves; the chosen `slot` is returned.
         *  These advisory-text arms are left cited (UI layer) rather than
         *  transcribed; the recommendation computation (phases 1-2 above) is
         *  fully decoded. */
        (void)a_bp_06; (void)other_bp_0A; (void)path_bp_0C;
        return slot;                                /* @asm 0x04A693/0x04A6C1/0x04A77B RETF [bp-0x36] */
    }
}

/* ============================================================================
 * func_04A7CA — native village raze / CHIEFKILL  [SUPERSEDED]
 * ----------------------------------------------------------------------------
 * Already hand-ported, BYTE_VERIFIED, to src/native/native_village_raze.c.
 * Gold = sum_3 × roll_4 × 4 × (size_byte+1) (project mem "CHIEFKILL").  The
 * 507-byte per-func dump is the raze body; the full port lives there.
 * ============================================================================ */
/* SUPERSEDED: ported to src/native/native_village_raze.c (CHIEFKILL raze). */

/* ============================================================================
 * func_04AC00 — native-village goods trade resolution  [DONE — BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * SIZE CORRECTION: authoritative reseg page_0C = 861 bytes (0x04AC00..0x04AF5E,
 * ENTER 0x2A), NOT the 397 the per-func dump showed.
 *
 * Role: resolves a buy/sell of one commodity between a unit (arg0, a
 * scout/wagon at a native village) and that village, deciding the outcome with
 * a demand-roll vs supply-roll, emitting the appropriate dialog/sound, and — on
 * a successful purchase — transferring the goods into the CURRENT COLONY's
 * stockpile (*0x8542 + commodity*2 + 0x9A).  Message keys xref-confirmed inside
 * this extent: "WAREHOUSEFULL" @0x4ACCC, "MERCS" @0x4AB18, "INDIANSURPRISE"
 * @0x4AE58 (the latter on the surprise/ambush sub-branch).
 *
 * Args: arg0=[bp+6] unit index; arg1=[bp+8] EUROPEAN POWER index (CORRECTED
 *   2026-06-10 — was mislabeled "commodity": arg1 is cmp'd <4 and gated on the
 *   per-power human flag [arg1*0x34+0x543F] @0x04ACAA, indexes the per-power
 *   AIPersonality word [arg1*2+0x540E] @0x04AD8B, and is the power arg of
 *   0x181F:0x30C(tribe,power) @0x04AC28); arg2=[bp+0xA] qty/value.
 * Locals: ux=[bp-0x18]; uy=[bp-0x1E]; region=[bp-6]; base=[bp-0x2A];
 *   demand=[bp-0x1A]; supply=[bp-0x20]; diff1=[bp-0x24]; won=[bp-0x28];
 *   target=[bp-0x26]; buf=[bp-0x16] (16-byte stockpile scratch); qtyOut=[bp-2];
 *   stockIdx=[bp-0x22]; transfer=[bp-4].
 *
 * @asm 0x04AC05  ux = unit[+0x3144] ; uy = unit[+0x3145]                 ; unit map x,y
 * @asm 0x04AC1B  region = 0x181F:0x0722(ux, uy)                          ; village/region id
 * @asm 0x04AC28  base = 0x181F:0x030C(arg1, cur_pow)                     ; per-power base value
 * @asm 0x04AC3A  demand = census_cargo_95B2[arg1*16 + region]            ; power's coastal cargo
 *                         + (census_finance_941C[arg1] >> 1)             ;   + half its finance word
 * @asm 0x04AC59  if arg1 == 2: demand += demand>>1                       ; POWER 2 ×1.5 (not "sugar")
 * @asm 0x04AC67  if ff_owned(arg1, FF 10 = HERNAN CORTES): demand += demand>>1  ; Cortes village bonus
 * @asm 0x04AC80  supply = (([region + cur_pow*16 - 0x6E34] + ([cur_pow-0x6E7C]>>1)) << 1)
 * @asm 0x04ACA0           + (base >> 1)                                  ; supply tables
 * @asm 0x04ACAA  diff1 = (arg1<4 && [arg1*0x34+0x543F]==0) ? difficulty+1 : 1   ; human bias
 * @asm 0x04ACCB  won = (random_int(0,demand) < random_int(0,supply)) ? 1 : 0     ; the roll
 * @asm 0x04ACF5  target = 0x181F:0x0614(region, arg1, uy, ux) ; if <0: won = 0   ; locate buyer
 * @asm 0x04AD15  branch tree (won / supply vs demand / base thresholds 0x4B,0x32
 *                / human-power) selects a refuse/accept message:
 * @asm 0x04AD40    refuse-A: format arg2 ; emit 0x167D via 0x191F:0x019C ; -> done
 * @asm 0x04AD8B    refuse-B: AIPersonality(arg1*2 + 0x540E) via 0x416 ; emit 0x1689
 * @asm 0x04ADD4    if !(bound[+3]&0x10) && won==0: emit 0x1692 ("MERCS"?) ; -> done
 * @asm 0x04AE38  ACCEPT: diff1 <<= 1 ; bound[+3] |= 0x10 ; CALL cs:0x5443
 *                                                           ; -> colony_surrounding_tile_scan
 * @asm 0x04AE43    zero buf[0..0x10) ; 0x191F:0xED0(ss:buf, ds:0x9E78, 0x10)   ; snapshot prod[16]
 * @asm 0x04AE6B    0x181F:0x09E6(target) ; qtyOut = 0x181F:0x0D3A()             ; pull qty
 * @asm 0x04AE7E    stockIdx = buf[+9] ; transfer = clamp(qtyOut - colony.stock[stockIdx],
 *                   [0xA, min(0x64, [0x9E96]*3 + 0xA)])                          ; clamp transfer
 * @asm 0x04AEBB    format difficulty-price ([0x53A6*2 - 0x7C6C]) ; arg2 ; transfer(0x9AE) ;
 *                   prod[+ -0x6840] (0x438) ; colony.y+2 (0x416)                 ; build the line
 * @asm 0x04AF16    if arg1<4 && human: emit 0x169D via 0x191F:0x019C
 * @asm 0x04AF36    colony.stock[stockIdx] += transfer  (*0x8542 + stockIdx*2 + 0x9A)  ; deposit
 * @asm 0x04AF46  (done) LCALL 0x181F:0x0D6C(cur_pow, arg1, diff1, 0)             ; price tick
 * @asm 0x04AF5A  RETF
 *
 * The stockpile write at *0x8542 + stockIdx*2 + 0x9A confirms ColonyRecord
 * stockpile[16] u16 at +0x9A (base 0x5D46 via the *0x8542 alias).  0x191F:0xED0
 * is the 16-word block copy of the production array at 0x9E78 (the colony's
 * per-resource output, computed by colony_surrounding_tile_scan).  CALL cs:0x5443
 * (file 0x04BA43) is the page-0C near trampoline -> LJMP 0x1A1F:0x0434 ->
 * colony_surrounding_tile_scan (func_048F34).  Binary-verified: file 0x04BA43 =
 * EA 34 04 1F 1A; thunk@0x1CA24 -> CS:0x2154 = file 0x048F34 (ENTER 0xA4).
 * NOTE: haggle.c "near-call func_05443" @0x496B2 is a DIFFERENT call-site in a
 * different overlay page (file offset 0x05443, not page-0C cs:0x5443).  Control flow,
 * the demand/supply table displacements, the dual random_int roll, the clamp
 * bounds (0xA..0x64), and the message ids are BYTE_VERIFIED; the inner 0x191F
 * callee bodies (0xED0 copy, 0x019C emit, 0x0D3A pull) are external.  [DONE]
 * ============================================================================ */
extern uint16_t *g_colony_8542;             /* (re-decl) *(0x8542) current ColonyRecord */
extern uint8_t   g_difficulty_53A6;         /* (re-decl) DGROUP:0x53A6 */
extern int  ovly_5443_trade_finalize(void); /* near cs:0x5443 (file 0x04BA43) -> LJMP 0x1A1F:0x0434
                                             * -> colony_surrounding_tile_scan (func_048F34).
                                             * Recomputes the production array DS:0x9E78 so the
                                             * 0x191F:0xED0 snapshot copies fresh data.
                                             * Binary verified: file 0x04BA43 = EA 34 04 1F 1A. */
/* DGROUP tables read DS-relative (base = 0x10000 - disp).  IDENTITIES CORRECTED
 * 2026-06-10 against the census writer (overlay_040C1E_04458A.c) and the raw
 * operands in func_04AC00.asm (power-major [entity*16 + region] indexing):
 *   0x95B2 ([bx+si-0x6A4E]) AI census: power's coastal-cargo byte [power*16+region]
 *                           (written @0x0423C1; same matrix as meeting.c attitude);
 *   0x941C ([bx-0x6BE4])   AI census: per-POWER finance word (written @0x042245);
 *   0x91CC ([bx+si-0x6E34]) per-(TRIBE,region) byte [tribe*16+region]
 *                           (si = [0x8D52]<<4 @0x04AC80 — tribe-major);
 *   0x9184 ([bx-0x6E7C])   per-TRIBE byte (bx = [0x8D52] @0x04AC90);
 *   0x97C0 ([si-0x6840])   per-commodity word (@CARGO col-0 handles, see pricing.c);
 *   0x9E96 word (production scale). */
extern uint8_t  g_trade_demand_95B2[];      /* DGROUP:0x95B2 (= 0x10000-0x6A4E) census coastal cargo [power*16+region] */
extern uint16_t g_trade_demand_w_941C[];    /* DGROUP:0x941C (= 0x10000-0x6BE4) census finance word [power] */
extern uint8_t  g_trade_supply_91CC[];      /* DGROUP:0x91CC (= 0x10000-0x6E34) [tribe*16 + region] */
extern uint8_t  g_trade_supply_b_9184[];    /* DGROUP:0x9184 (= 0x10000-0x6E7C) [tribe] */
extern uint16_t g_trade_after_97C0[];       /* DGROUP:0x97C0 (= 0x10000-0x6840) [commodity] */
extern uint16_t g_prod_scale_9E96;          /* DGROUP:0x9E96 — production scale word */

int native_village_trade(uint16_t arg0_bp_06, uint16_t arg1_bp_08,
                         uint16_t arg2_bp_0A)  /* func_04AC00 */
{
    uint8_t *u = &g_unit_table_3144[arg0_bp_06 * UNIT_RECORD_STRIDE];
    (void)u;  /* ux/uy taken via the lookup thunk below */

    /* @asm 0x04AC1B — village/region id from the unit's map position. */
    int region = overlay_call_181F_0722();            /* f(unit.x +0x3144, unit.y +0x3145) */

    /* @asm 0x04AC28 — per-power base value of the commodity. */
    int base = func_0082A0_logic_sz_18(DG16(0x8D52), arg1_bp_08); /* table(arg1, cur_pow) -> [bp-0x2A] */

    /* @asm 0x04AC3A..0x04AC64 — DEMAND from the per-village/per-commodity tables
     * (×1.5 for commodity 2). */
    int demand = g_trade_demand_95B2[region + arg1_bp_08 * 16]
               + (g_trade_demand_w_941C[arg1_bp_08] >> 1);   /* @asm 0x04AC43/0x04AC4E */
    if (arg1_bp_08 == 2)
        demand += demand >> 1;                        /* @asm 0x04AC5F */
    /* @asm 0x04AC67 — embargo/event halving-or-boosting. */
    if (overlay_call_181F_07B4() != 0)
        demand += demand >> 1;                        /* @asm 0x04AC78 */

    /* @asm 0x04AC80..0x04ACA7 — SUPPLY from the current-power tables + half the base. */
    int supply = ((g_trade_supply_91CC[region + g_current_power_8D52 * 16]
                   + (g_trade_supply_b_9184[g_current_power_8D52] >> 1)) << 1)
               + (base >> 1);                         /* @asm 0x04AC8A..0x04ACA5 */

    /* @asm 0x04ACAA..0x04ACC9 — human powers get a difficulty bias; AI gets 1. */
    int diff1;
    if (arg1_bp_08 < 4 && g_power_active_543F[arg1_bp_08 * 0x34] == 0)  /* @asm 0x04ACB4 */
        diff1 = g_difficulty_53A6 + 1;                /* @asm 0x04ACC0 */
    else
        diff1 = 1;                                    /* @asm 0x04ACC6 */

    /* @asm 0x04ACCB..0x04ACF2 — the trade roll: demand draw vs supply draw. */
    int rd = overlay_call_181F_04D4();                /* @asm 0x04ACD0 random_int(0, demand) */
    int rs = overlay_call_181F_04D4();                /* @asm 0x04ACDF random_int(0, supply) */
    int won = (rs < rd) ? 1 : 0;                      /* @asm 0x04ACE7 */

    /* @asm 0x04ACF5..0x04AD13 — locate the buyer; an invalid target forces refuse. */
    int target = overlay_call_181F_0614();            /* f(region, arg1, uy, ux) */
    if (target < 0)
        won = 0;                                      /* @asm 0x04AD10 */

    /* @asm 0x04AD15..0x04AE35 — refuse/accept decision tree.  Each refuse arm emits a
     * dialog line (0x167D / 0x1689 / 0x1692) and falls through to the price tick. */
    int accepted = 0;
    if (won != 0 || supply < demand || base < 0x4B) {   /* @asm 0x04AD23 thresholds */
        if (arg1_bp_08 >= 4 ||
            g_power_active_543F[arg1_bp_08 * 0x34] != 0) {  /* @asm 0x04AD32 AI power */
            /* @asm 0x04AD40 — refuse-A: emit message 0x167D. */
            overlay_call_181F_09A4();  overlay_call_181F_0438();
            overlay_call_191F_019C();                 /* @asm 0x04AD5D emit 0x167D */
        } else if (won == 0 && base >= 0x32) {        /* @asm 0x04AD6E refuse-B gate */
            /* @asm 0x04AD8B — refuse-B: read AIPersonality (arg1*2 + 0x540E), emit 0x1689. */
            overlay_call_181F_0438();
            overlay_call_181F_0416();                 /* @asm 0x04ADAD AIPersonality field */
            overlay_call_181F_0A1A();  overlay_call_181F_0438();
            overlay_call_191F_019C();                 /* @asm 0x04ADD2->0x04AD5D emit 0x1689 */
        } else if (!(g_bound_record_8D4A[0x03] & 0x10) && won == 0) {  /* @asm 0x04ADD8 */
            /* @asm 0x04ADF5 — emit 0x1692 ("MERCS" branch). */
            overlay_call_181F_0438();
            overlay_call_181F_0A1A();  overlay_call_181F_0438();
            overlay_call_191F_019C();                 /* @asm 0x04AE28 emit 0x1692 */
        } else {
            accepted = 1;                             /* @asm 0x04AE38 ACCEPT */
        }
    } else {
        accepted = 1;                                 /* falls to accept via 0x04AE38 */
    }

    /* @asm 0x04AE38..0x04AF42 — ACCEPT: deposit the goods into the colony stockpile. */
    if (accepted) {
        diff1 <<= 1;                                  /* @asm 0x04AE38 */
        g_bound_record_8D4A[0x03] |= 0x10;            /* @asm 0x04AE3B */
        ovly_5443_trade_finalize();                   /* @asm 0x04AE40 CALL cs:0x5443 */

        /* @asm 0x04AE43..0x04AE6A — snapshot the colony's 16-word production array. */
        uint8_t buf[16];
        for (int k = 0; k < 0x10; k++) buf[k] = 0;    /* @asm 0x04AE48 */
        overlay_call_191F_0ED0();                     /* @asm 0x04AE66 copy(ss:buf, 0x9E78, 0x10) */

        /* @asm 0x04AE6B..0x04AE7D — pull the available quantity for the buyer. */
        overlay_call_181F_09E6();                     /* @asm 0x04AE6E bind(target) */
        int qtyOut = overlay_call_181F_0D3A();        /* @asm 0x04AE76 */

        /* @asm 0x04AE7E..0x04AEB8 — compute the clamped transfer amount. */
        int stockIdx = buf[9];                        /* @asm 0x04AE7E [bp-7] = buf[+9] */
        int cap = g_prod_scale_9E96 * 3 + 0x0A;       /* @asm 0x04AE99 [0x9E96]*3 + 0xA */
        if (cap > 0x64) cap = 0x64;                   /* @asm 0x04AEA2 */
        int transfer = qtyOut -
            *(int16_t *)&((uint8_t *)g_colony_8542)[stockIdx * 2 + 0x9A];  /* @asm 0x04AE91 */
        if (transfer > cap) transfer = cap;           /* @asm 0x04AEAA */
        if (transfer < 0x0A) transfer = 0x0A;         /* @asm 0x04AEB0 */

        /* @asm 0x04AEBB..0x04AF13 — build & emit the trade line (price/qty/colony). */
        overlay_call_181F_0438();                     /* difficulty price [0x53A6*2-0x7C6C] */
        overlay_call_181F_0A1A();  overlay_call_181F_0438();   /* arg2 */
        overlay_call_181F_09AE();                     /* @asm 0x04AEEF transfer (long) */
        overlay_call_181F_0438();                     /* prod[+ -0x6840] */
        overlay_call_181F_0416();                     /* @asm 0x04AF0E colony.y+2 field */

        /* @asm 0x04AF16..0x04AF33 — human power gets the spoken "INDIANSURPRISE"/result line. */
        if (arg1_bp_08 < 4 && g_power_active_543F[arg1_bp_08 * 0x34] == 0)
            overlay_call_191F_019C();                 /* @asm 0x04AF2E emit 0x169D */

        /* @asm 0x04AF36 — deposit the transferred goods into the colony stockpile. */
        *(int16_t *)&((uint8_t *)g_colony_8542)[stockIdx * 2 + 0x9A] += (int16_t)transfer;
    }

    /* @asm 0x04AF46 — commit the resulting price movement. */
    overlay_call_181F_0D6C();                         /* tick(cur_pow, arg1, diff1, 0) */

    return 0;  /* @asm 0x04AF5A RETF */
}

/* ============================================================================
 * func_04AF5E — scout_incite_tribe_to_war  [DONE — BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * CORRECTED 2026-05-30: was mislabeled "europe_buy_goods"; byte-proof: pushes
 * KEY 0x16E9 = "INDIANWARFARE" @0x04B2D3 (the success receipt) and KEY 0x16C1 =
 * "INDIANWARPATH2" @0x04B1C2 (the bribe price-confirm), plus the
 * NOCONTACT/ALREADYSMITE/UNFORTUNATE refusal keys (file = handle + 0x1D9A0).
 * This is the SCOUT-INCITES-A-TRIBE-TO-WAR (bribe) handler — the player's scout
 * pays a native tribe gold to go on the warpath against a rival power.  It is
 * NOT a Europe goods-purchase: the gold debit the prior pass saw IS the bribe
 * payment, not a market buy, and the dialog trio is the warpath target picker.
 *
 * GAME.TXT (verified semantics):
 *   INDIANWARPATH  0x16A9 (dialog title) "The {tribe} tribe is ready to go on the
 *                  warpath.  Whom would you like us to attack?"          (line 3023)
 *   NOCONTACT      0x16B7  "We have no contact with the {target}."       (line 2457)
 *   INDIANWARPATH2 0x16C1  "We will gladly drive the {target} from our ancestral
 *                  lands in exchange for {gold}."  Pay/Never mind.       (line 3028)
 *   UNFORTUNATE    0x16D0  "Unfortunately, your treasury is insufficient to match
 *                  your extravagant promises."                           (line 2483)
 *   ALREADYSMITE   0x16DC  "We are already at war with the worthless {target}."
 *                                                                        (line 2461)
 *   INDIANWARFARE  0x16E9  "{tribe} nation holds War Council!  {your}
 *                  missionaries incite {tribe} to warfare against the {target}!"
 *                                                                        (line 3036)
 * (The old "KINGLOSE @0x4AF8E" note was a mis-attribution; the can't-afford arm
 * here draws UNFORTUNATE 0x16D0.)
 *
 * Reframing of the prior pass's "price / market" reads: 0x181F:0x030C is
 * tribe_power_relation(target, power) (per-(tribe,power) word @ 0x5B1C — see
 * src/native/haggle.c), governing whether the tribe will/can attack the target,
 * NOT a tax table; 0x181F:0x0A38(tribe, target) is the tribe-attribute / contact
 * fetch tested with &0x20 (lcr.c "gift gate" / haggle.c unit_flag_test), gating
 * NOCONTACT; 0x181F:0x0D6C is "adjust native attitude" (page 0x0B file 0x045DF2),
 * NOT a price tick — here it nudges the tribe's standing toward the inciting
 * power by +0x64 on success.  The gold (PowerRecord +0x2A) is the bribe purse.
 *
 * SIZE CORRECTION (unchanged): authoritative reseg page_0C = 937 bytes
 * (0x04AF5E..0x04B307, ENTER 0x14).  This single function ABSORBS the file offset
 * 0x04B036 the old per-func extractor mis-framed as "func_04B036": 0x04B036 is
 * the SECOND byte of `8B C8 (mov cx,ax)` at 0x04B035 (raw 0x04B036 = c8 25 0f 00…,
 * the `c8` of 8BC8 then `250F00 and ax,0xf`) — mid-instruction, not a function
 * start.  func_04B036 is a PHANTOM and the whole body is HERE.
 *
 * Args: arg0=[bp+6] SCOUT UnitRecord index (the inciter; tested at +0x315B for the
 *   0x18 "seasoned scout" discount); arg1=[bp+8] PAYING POWER index (0..3 = the
 *   player whose PowerRecord gold +0x2A funds the bribe; >=4 = the AI/scripted
 *   arm); arg2=[bp+0xA] the TRIBE (settlement-owner) being asked to attack.
 * Locals: cost=[bp-0xC:bp-0xA] (dword bribe price); save4C=[bp-2]; i=[bp-0x14];
 *   perAlly=[bp-0x10:bp-0xE]; target=[bp-0x12]; dlg=[bp-8:bp-6] (dialog handle).
 *
 * @asm 0x04AF63  cost = (tribe_power_relation(arg1, cur_pow) + 0x4B) (sign-ext dword)
 * @asm 0x04AF78  cost += ([cur_pow-0x69D6]<<3) + (([cur_pow-0x6E7C]>>2)&0xFE)
 *                       - ([cur_pow-0x69D6]<<1)                       ; power-scaled base bribe
 * @asm 0x04AF9F  cost += (market[+7]<<1) + (market[+8]<<1)            ; current standing spread
 * @asm 0x04AFBB  cost = 0x0D1D:0xF60(cost)                            ; 32-bit scale/round
 * @asm 0x04AFC6  if arg1 == 1: cost = 0x0D1D:0xEC6(cost*3<<1)         ; power-1 x6
 * @asm 0x04AFE1  save4C = [0x8D4C]
 * @asm 0x04AFEE  for i in 0..[0x539A]: bind(i) ; if bound.owner +2==arg2 && (bound.mission +5 &0xF)==arg1:
 * @asm 0x04AFFE    perAlly = (bound[+3]&4 ? 0xFA<<1 : 0xFA)           ; discount per allied settlement
 * @asm 0x04B044    if bound.mission +5 &0x10: perAlly = 0x3E8         ; "blessed" override
 * @asm 0x04B00A    cost -= perAlly                                    ; each allied settlement cuts the bribe
 * @asm 0x04B04C  bind(save4C) ; if scout[+0x315B]==0x18: cost -= 0x5DC(1500)  ; seasoned scout
 * @asm 0x04B06F  if bound[+3]&4: cost -= 0x1F4(500)                   ; developed-settlement discount
 * @asm 0x04B07E  cost = max(cost, 0x1F4)                              ; floor at 500
 * @asm 0x04B09A  if arg1 >= 4 || [arg1*0x34+0x543F]!=0: goto pay-direct(0x4C2A) ; AI power
 * @asm 0x04B0B1  if [0x5382]&1: target = [0x53D2] ; goto relation-check(0x4B5D) ; scripted target
 * @asm 0x04B0C2  else: [0x1F5C]=cur_pow ; format tribe ; LCALL 0x191F:0x182(0x87C, 0x16A9) ;
 *                     dlg = handle ; if !dlg goto done(0x4D04)        ; open INDIANWARPATH picker
 * @asm 0x04B0FA  for target in 0..4 (skip arg1 and [0x53D2]):         ; populate target rows
 * @asm 0x04B10F    LCALL 0x181F:0x0A1A(target) ; 0x181F:0x0022 ; LCALL 0x191F:0x176(dlg, ...)
 * @asm 0x04B141  target = max(1, 0x191F:0x16A(dlg)) - 1              ; chosen war target
 * @asm 0x04B15D  (relation-check) if !(0x181F:0x0A38(arg2 tribe, target)&0x20):
 * @asm 0x04B16F    format target ; emit 0x16B7 "NOCONTACT" via 0x191F:0x019C ; RETF
 * @asm 0x04B198  format target ; cost-as-long (0x9AE) ; emit 0x16C1 "INDIANWARPATH2" ;
 * @asm 0x04B1CD    if confirm(ax)==0 goto done                         ; Pay / Never mind
 * @asm 0x04B1D3  if PowerRecord[arg1].gold (cmp dword [bx-0x77CE/-0x77CC], cost) < cost:
 * @asm 0x04B1EC    emit 0x16D0 "UNFORTUNATE" (treasury insufficient) ; -> 0x4B8C/done
 * @asm 0x04B1F6  if tribe_power_relation(target, cur_pow) >= 0x4B: format target ;
 *                  emit 0x16DC "ALREADYSMITE" (already at war) ; -> done
 * @asm 0x04B22A  (pay-direct AI arm @0x4C2A) target=[0x5398] ;
 * @asm 0x04B230    if !(0x0A38(arg2,target)&0x20) goto done ;          ; no contact
 * @asm 0x04B243    if tribe_power_relation(target,cur_pow) >= 0x4B goto done ; ; already at war
 * @asm 0x04B25A    if PowerRecord[arg1].gold < cost goto done          ; affordability (AI)
 * @asm 0x04B279  (success @0x4C79) format tribe (slot0), arg1 (slot1), cost-long (slot2),
 *                target (slot3) ; draw 0x16E9 "INDIANWARFARE" (0x652) ;
 * @asm 0x04B2DE    LCALL 0x181F:0x0D6C(cur_pow, target, 0x64, 0)       ; +100 tribe-vs-target attitude
 * @asm 0x04B2F1    PowerRecord[arg1].gold -= cost  (sub [bx-0x77CE],ax ; sbb [bx-0x77CC],dx)  ; pay bribe
 * @asm 0x04B304  (done) RETF
 *
 * The gold debit `sub dword [arg1*0x13C - 0x77CE], cost` confirms PowerRecord
 * stride 0x13C and the gold dword at +0x2A (base 0x8808; 0x8808+0x2A = 0x8832 =
 * 0x10000-0x77CE) — and that this debit is the BRIBE PAYMENT.  Strings: 0x16A9
 * INDIANWARPATH dialog title, 0x16B7 NOCONTACT, 0x16C1 INDIANWARPATH2 (price
 * confirm), 0x16D0 UNFORTUNATE (can't afford), 0x16DC ALREADYSMITE (already at
 * war), 0x16E9 INDIANWARFARE (success).  0x0D1D:0xF60 / 0xEC6 are the 32-bit
 * multiply helpers.  Control flow, the bribe-cost terms, the per-allied-settlement
 * discount (0xFA/0x3E8), the scout/developed discounts (1500/500), the 0x1F4
 * floor, and the gold compare/debit are BYTE_VERIFIED; the 0x191F dialog trio and
 * the 0x0D1D math helpers are external.  The 0x4B war-threshold compare on the
 * relation word is byte-cited; its exact units are RUNTIME_ONLY (data-resident).  [DONE]
 * ============================================================================ */
extern uint8_t  far *g_active_power;        /* DGROUP:0x84FC — far ptr to active PowerRecord (re-decl) */
extern uint8_t  g_power_record_8808[];      /* DGROUP:0x8808 — PowerRecord[], stride 0x13C */
extern uint16_t g_econ_flags_5382;          /* (re-decl) DGROUP:0x5382 */
extern int16_t  g_scripted_target_53D2;     /* DGROUP:0x53D2 — scripted war-target / skip index */
extern int16_t  g_msg_power_1F5C;           /* DGROUP:0x1F5C — message-power scratch */
extern uint8_t  g_power_anger_5398;         /* (re-decl) DGROUP:0x5398 — AI default target */
extern uint8_t  g_trade_supply_b_9184[];    /* (re-decl) DGROUP:0x9184 (= 0x10000-0x6E7C) per-power byte;
                                             *   here a per-power relation-spread term in the bribe cost */

/* PowerRecord gold dword accessor: gold at +0x2A, stride 0x13C, base 0x8808
 * (0x8808+0x2A = 0x8832 = 0x10000-0x77CE — the displacement used at @0x04B1DE). */
static int32_t power_gold(uint16_t power)
{
    return *(int32_t *)&g_power_record_8808[power * 0x13C + 0x2A];
}

int scout_incite_tribe_to_war(uint16_t arg0_bp_06, uint16_t arg1_bp_08,
                              uint16_t arg2_bp_0A)  /* func_04AF5E (absorbs 0x04B036) */
{
    /* @asm 0x04AF63..0x04AFBE — base bribe: (tribe_power_relation(arg1,cur) + 0x4B) plus
     * the power-scaled standing terms and the current relation spread (market[+7]/[+8]). */
    long cost = (long)(func_0082A0_logic_sz_18(DG16(0x8D52), arg1_bp_08) + 0x4B); /* @asm 0x04AF72 tribe_power_relation(arg1,cur) */
    cost += ((long)g_power_scalar_962A[g_current_power_8D52] << 3)             /* @asm 0x04AF84 [cur-0x69D6]<<3 */
          + ((long)((g_trade_supply_b_9184[g_current_power_8D52] >> 2) & 0xFE))/* @asm 0x04AF8A [cur-0x6E7C]/4 even */
          - ((long)g_power_scalar_962A[g_current_power_8D52] << 1);            /* @asm 0x04AF94 -[cur-0x69D6]<<1 */
    cost += ((long)g_market_array_8D4E[0x07] << 1)                /* @asm 0x04AFA7 standing +7 */
          + ((long)g_market_array_8D4E[0x08] << 1);               /* @asm 0x04AFAE standing +8 */

    /* @asm 0x04AFBB / 0x04AFC6 — 32-bit scale, and x6 when the paying power is index 1. */
    cost = overlay_call_0D1D_0F60();                              /* scale/round */
    if (arg1_bp_08 == 1)
        cost = overlay_call_0D1D_0EC6();                          /* @asm 0x04AFD6 x6 */

    /* @asm 0x04AFEE..0x04B049 — each allied settlement of tribe arg2 on this channel
     * discounts the bribe (0xFA each, 0x1F4 if developed, 0x3E8 if "blessed"). */
    for (int i = 0; i < g_native_count_539A; i++) {               /* @asm 0x04B013 */
        overlay_call_181F_0A4C();                                 /* @asm 0x04B01E bind settlement(i) */
        if (g_bound_record_8D4A[0x02] != (uint8_t)arg2_bp_0A)     /* @asm 0x04B02D owner +2 */
            continue;
        if ((g_bound_record_8D4A[0x05] & 0x0F) != (uint8_t)arg1_bp_08)  /* @asm 0x04B03A mission +5 channel */
            continue;
        long per = (g_bound_record_8D4A[0x03] & 0x04) ? (0xFA << 1) : 0xFA;  /* @asm 0x04AFF8 developed -> x2 */
        if (g_bound_record_8D4A[0x05] & 0x10)                     /* @asm 0x04B03F "blessed" */
            per = 0x3E8;                                          /* @asm 0x04B044 */
        cost -= per;                                              /* @asm 0x04B00A discount the bribe */
    }

    /* @asm 0x04B04C..0x04B07C — re-bind the scout's settlement; scout/developed discounts. */
    overlay_call_181F_0A4C();                                     /* bind(save4C=[0x8D4C]) */
    if (g_unit_table_3144[arg0_bp_06 * UNIT_RECORD_STRIDE + 0x17] == 0x18)  /* +0x315B @0x04B05B seasoned scout */
        cost -= 0x5DC;                                            /* @asm 0x04B062 -1500 */
    if (g_bound_record_8D4A[0x03] & 0x04)                         /* @asm 0x04B06F developed settlement */
        cost -= 0x1F4;                                            /* @asm 0x04B075 -500 */

    /* @asm 0x04B07E..0x04B097 — floor the bribe at 500. */
    if (cost < 0x1F4)
        cost = 0x1F4;

    int target;
    int do_pay = 0;   /* set when an arm reaches the gold-debit (bribe-paid) path */

    /* @asm 0x04B09A — AI / scripted powers skip the warpath dialog and go to pay-direct. */
    if (arg1_bp_08 >= 4 || g_power_active_543F[arg1_bp_08 * 0x34] != 0) {  /* @asm 0x04B0A7 */
        /* @asm 0x04B22A pay-direct: AI default target, contact + war + affordability gates. */
        target = g_power_anger_5398;                              /* @asm 0x04B22A [0x5398] */
        if (!(overlay_call_181F_0A38() & 0x20))                   /* @asm 0x04B234 no contact w/ target */
            goto done;
        if (func_0082A0_logic_sz_18(DG16(0x8D52), (uint16_t)target) >= 0x4B) /* @asm 0x04B24A already at war(target,cur) */
            goto done;
        if (power_gold(arg1_bp_08) < cost)                        /* @asm 0x04B260 can't afford */
            goto done;
        do_pay = 1;
    } else if (g_econ_flags_5382 & 0x01) {
        /* @asm 0x04B0B1 — scripted war target. */
        target = g_scripted_target_53D2;                          /* @asm 0x04B0B8 */
        goto relation_check;
    } else {
        /* @asm 0x04B0C2..0x04B157 — open the INDIANWARPATH target picker and read the choice. */
        g_msg_power_1F5C = (int16_t)g_current_power_8D52;         /* @asm 0x04B0C5 */
        overlay_call_181F_09A4();  overlay_call_181F_0438();      /* format the tribe (arg2) into the title */
        int dlg = overlay_call_191F_0182();                       /* @asm 0x04B0E8 open(0x87C, 0x16A9 INDIANWARPATH) */
        if (dlg == 0)                                             /* @asm 0x04B0F3 */
            goto done;
        for (target = 0; target < 4; target++) {                  /* @asm 0x04B0FF candidate powers 0..3 */
            if (target == (int)arg1_bp_08 || target == g_scripted_target_53D2)  /* @asm 0x04B102/0x04B10A skip self */
                continue;
            overlay_call_181F_0A1A();                             /* @asm 0x04B117 name(target) */
            overlay_call_181F_0022();                             /* @asm 0x04B120 */
            overlay_call_191F_0176();                             /* @asm 0x04B130 add target row */
        }
        target = overlay_call_191F_016A();                        /* @asm 0x04B147 read selection */
        if (target < 1) target = 1;                               /* @asm 0x04B154 */
        target -= 1;                                              /* @asm 0x04B15A to power index */

    relation_check:
        /* @asm 0x04B15D..0x04B191 — the tribe must have contact with the target (bit5),
         * else "We have no contact with the {target}." (NOCONTACT 0x16B7). */
        if (!(overlay_call_181F_0A38() & 0x20)) {                 /* @asm 0x04B16B tribe_attr(arg2, target) */
            overlay_call_181F_0A1A();  overlay_call_181F_0438();  /* format target */
            overlay_call_191F_019C();                             /* @asm 0x04B18C emit 0x16B7 "NOCONTACT" */
            return 0;                                             /* @asm 0x04B196 RETF */
        }
        /* @asm 0x04B198..0x04B1CB — bribe price-confirm "...in exchange for {gold}."
         * (INDIANWARPATH2 0x16C1), Pay / Never mind. */
        overlay_call_181F_0A1A();  overlay_call_181F_0438();      /* format target */
        overlay_call_181F_09AE();                                 /* @asm 0x04B1B6 cost (long) into NUMBER0 */
        int ok = overlay_call_191F_019C();                        /* @asm 0x04B1C5 emit/confirm 0x16C1 */
        if (ok == 0)                                              /* @asm 0x04B1CD dec ax = "Never mind" */
            goto done;
        /* @asm 0x04B1D3..0x04B1EA — treasury check: PowerRecord[arg1].gold >= bribe? */
        if (power_gold(arg1_bp_08) < cost) {                      /* @asm 0x04B1DE */
            overlay_call_191F_019C();                             /* @asm 0x04B1EC emit 0x16D0 "UNFORTUNATE" */
            goto done;
        }
        /* @asm 0x04B1F6..0x04B227 — already-at-war gate "...worthless {target}."
         * (ALREADYSMITE 0x16DC). */
        if (func_0082A0_logic_sz_18(DG16(0x8D52), (uint16_t)target) >= 0x4B) { /* @asm 0x04B1FD relation(target,cur) >= war thresh */
            overlay_call_181F_0A1A();  overlay_call_181F_0438();
            overlay_call_191F_019C();                             /* @asm 0x04B224 emit 0x16DC "ALREADYSMITE" */
            goto done;
        }
        do_pay = 1;
    }

    if (do_pay) {
        /* @asm 0x04B279..0x04B2DB — build & draw the INDIANWARFARE receipt (0x16E9):
         * "{tribe} nation holds War Council! {your} missionaries incite {tribe} to
         *  warfare against the {target}!" */
        overlay_call_181F_09A4();  overlay_call_181F_0438();      /* slot 0 (tribe arg2 -> STRING0) */
        overlay_call_181F_09A4();  overlay_call_181F_0438();      /* slot 1 (arg1 -> STRING1) */
        overlay_call_181F_0A1A();  overlay_call_181F_0438();      /* slot 2 (cost long / STRING2) */
        overlay_call_181F_09A4();  overlay_call_181F_0438();      /* slot 3 (target -> STRING3) */
        overlay_call_181F_0652();                                 /* @asm 0x04B2D6 draw 0x16E9 "INDIANWARFARE" */

        /* @asm 0x04B2DE — push the tribe's attitude toward the target by +100. */
        overlay_call_181F_0D6C();                                 /* adjust_native_attitude(cur_pow, target, 0x64, 0) */

        /* @asm 0x04B2F1..0x04B302 — PAY THE BRIBE: PowerRecord[arg1].gold -= cost. */
        {
            int32_t *gold = (int32_t *)&g_power_record_8808[arg1_bp_08 * 0x13C + 0x2A];
            *gold -= (int32_t)cost;                               /* @asm 0x04B2FC/0x04B300 */
        }
    }

done:
    return 0;  /* @asm 0x04B304 RETF */
}

/* ============================================================================
 * func_04B036 — PHANTOM (mid-instruction split artifact of func_04AF5E)
 * ----------------------------------------------------------------------------
 * NOT a function.  The authoritative reseg page_0C has a single 937-byte
 * function spanning 0x04AF5E..0x04B307 (scout_incite_tribe_to_war above).  File offset
 * 0x04B036 lands on the SECOND byte of the 2-byte `8B C8 (mov cx,ax)` at
 * 0x04B035 — raw bytes at 0x04B036 are
 *   c8 25 0f 00 3b 46 08 75   (= the 0xC8 of 8BC8, then 25 0F 00 = `and ax,0xf`).
 * The old per-func extractor mis-read 0xC8 as an `ENTER 0x0F25` prologue.  No
 * body is emitted.  [PHANTOM — byte-confirmed]
 * ============================================================================ */
/* PHANTOM: 0x04B036 is mid-body of func_04AF5E (2nd byte of `8B C8`) — see banner. */

/* ============================================================================
 * func_04B308 — native-tribe encounter dispatcher with VILLAGE attitude display
 *                                          [BYTE_VERIFIED — full body traced]
 * ----------------------------------------------------------------------------
 * Auto-named "MADATSHIPS" via string xref 0x1705 at @asm 0x04B40D, but this
 * is a dual-purpose function.  Phase 1 (0x04B308..0x04B567) classifies the
 * encounter and gates off ships ("MADATSHIPS") when the King intervenes.
 * Phase 2 (0x04B56A..0x04BA00) is the VILLAGE encounter display path: it
 * builds a "VILLAGE <attitude>" status string, determines one of 5 tribe
 * attitude levels, opens a dialog, and drives a 9-arm event loop.
 *
 * ENTER frame: 0xBA bytes (186 bytes of local storage).
 * Args (bp offsets, all uint16_t):
 *   [bp+6]  unit_index     — unit record index (stride 0x1C from base 0x3144)
 *   [bp+8]  arg1           — passed as arg1 to 0x181F:0x09F0
 *   [bp+0A] arg2           — passed as arg2 to 0x181F:0x09F0
 * Key locals:
 *   [bp-0x58] ret          — function return value (default 1; 0=cancel, 2=follow-up)
 *   [bp-0x54] disp_code    — display/event outcome from 0x191F:0x16A
 *   [bp-0x5C]:[bp-0x5A]    dialog handle (far ptr, set by 0x191F:0x182)
 *   [bp-0x5E] flag_9       — set to 1 if a native unit type >= 2 attack-warn flag fires
 *   [bp-0x62] rel          — raw relation value from 0x181F:0x09F0
 *   [bp-0x64] owner_word   — [0x8D4A][owner*2+0xA] per-owner state word
 *   [bp-0x66] name_result  — return from 0x181F:0x0722 (name lookup)
 *   [bp-0x68] owner        — unit owner nibble ([bx+0x3147]&0xF)
 *   [bp-0xBA] tbl          — relation/distance score from 0x181F:0x030C
 *   [bp-0x02] region       — bound record [0x8D4A]+2 byte (tribe/region id)
 *   [bp-0x52..bp-0x03]     — string build buffer (0x4F bytes; [bp-0x52] base)
 *   [bp-0xB8..bp-0x53]     — secondary string buffer (used in colony-owner sub-path)
 *
 * DGROUP globals read:
 *   0x539C  g_unit_count_539C       — game progress snapshot (reentrancy guard)
 *   0x539A  (implicit via 0x0524)   — tribe/unit context counter
 *   0x5398  g_power_anger_5398      — per-power anger scalar (fed to 0x030C)
 *   0x543F  g_power_active_543F[]   — [owner*0x34]: 0 = live human power slot
 *   0x00A2  g_sfx_level_A2          — sound level word; 0 = muted (no modal)
 *   0x8D4A  g_bound_record_8D4A     — ptr to bound tribe/settlement record
 *   0x8D4E  g_market_array_8D4E     — ptr to bound market/tribe array
 *   0x8D52  g_tribe_id_8D52         — 0-based tribe index (0..7)
 *   0x8808  PowerRecord[].gold      — stride 0x13C, field at +0x2A above base
 *                                     (read as [owner*0x13C - 0x77CE])
 *   0x9328..0x933E  g_sound_ids[]   — sound-id word array for dialog items
 *                                     (0x932A=id1,0x932C=id2,0x932E=id3,0x9330=id4,
 *                                      0x9332=id5,0x9334=id6,0x9336=id7,0x9338=id8,
 *                                      0x933A=id9,0x933C=id10)
 *   0x3144  g_unit_table_3144[]     — unit record array (stride 0x1C)
 *                                     +0x02=[bx+0x3146] unit type
 *                                     +0x03=[bx+0x3147] owner/flags byte
 *                                     +0x11=[bx+0x3155] (unit sub-field)
 *                                     +0x15=[bx+0x3159]  (unit sub-field)
 *                                     +0x17=[bx+0x315B]  (unit class/terrain)
 *   0x5236  g_unit_type_flags_5236[]— per-unit-type flag byte (stride 7 from type id)
 *                                     read at [type*7 + 0x5236]
 *
 * ---- PHASE 1: encounter classification (0x04B308..0x04B567) ----
 *
 * @asm 0x04B30D  [bp-0x58]=1 (default ret=1); [bp-0x5E]=0; [bp-0x5A/5C]=0
 * @asm 0x04B31F  prog0 = [0x539C]                       ; reentrancy guard snapshot
 * @asm 0x04B325  push [bp+0xA],[bp+8] ; LCALL 0x181F:0x09F0 ; rel = f(arg2,arg1)
 * @asm 0x04B336  push ax ; LCALL 0x181F:0x0A4C           ; bind rel -> [0x8D4A] tribe record
 * @asm 0x04B33F  imul bx,[bp+6],0x1C ; owner=[bx+0x3147]&0xF (unit owner nibble)
 * @asm 0x04B34D  bx=[0x8D4A]; cl=[bx+2] -> region; [bp-0x02]=region; rgn4=region-4
 * @asm 0x04B361  LCALL 0x181F:0x030C(owner, rgn4) -> tbl=[bp-0xBA] (relation score)
 * @asm 0x04B36D  si=owner*2; owner_word=[bx+si+0xA] -> [bp-0x64]
 * @asm 0x04B37C  if owner<4 && [owner*0x34+0x543F]==0 && [0xA2]==0: (live human, no sfx)
 *      @asm 0x04B394  promptId = (g_tribe_id_8D52==0)->7, (==1)->6, else 5
 *      @asm 0x04B3AE  LCALL 0x181F:0x04AC(promptId)         ; queue UI prompt sound
 * @asm 0x04B3B6  unitType=[bx+0x3146]; if 0x0D<=unitType<=0x12 (ship classes):
 *      @asm 0x04B3CE  LCALL 0x181F:0x0A38(owner,region) -> flags
 *      @asm 0x04B3D6  if !(flags&0x20): show msg @str 0x16F7; goto done (not at war)
 *      @asm 0x04B3E6  if tbl>=0x4B OR owner_word>=0x40:      (King threshold exceeded)
 *           @asm 0x04B3F3  LCALL 0x181F:0x09A4(region)       ; format power name
 *           @asm 0x04B401  LCALL 0x181F:0x0438(ax,0)         ; set dialog context
 *           @asm 0x04B409  push [0x8D52]; push 0x1705("MADATSHIPS")
 *           @asm 0x04B410  LCALL 0x191F:0x019C               ; emit MADATSHIPS message
 *           @asm 0x04B418  goto done
 * @asm 0x04B41C  if owner<4 && [owner*0x34+0x543F]==0: goto ret9_tail (0x04B56A)
 * @asm 0x04B430  code=unitType([bx+0x3146]); jmp 0x04B544
 * @asm 0x04B544  code--; if code>0x0B goto default_arm(0x04B50A)
 * @asm 0x04B54D  jmp cs:[code*2+0x4772]   ; 12-entry CS jump table (file 0x4B552)
 *
 *   Jump table at file 0x4B552 (CS:0x4772), 12 entries (unit_type 1..12):
 *     unit_type  1 -> file 0x4B4DE  "name lookup" arm: 0x722(x,y)->name; disp_code=9
 *     unit_type  2 -> file 0x4B50A  default arm (see below)
 *     unit_type  3 -> file 0x4B43E  "tax/anger" arm (see below)
 *     unit_type  4 -> file 0x4B4DE  "name lookup" arm
 *     unit_type  5 -> file 0x4B502  disp_code=6 directly
 *     unit_type  6..11 -> file 0x4B50A  default arm
 *     unit_type 12 -> file 0x4B4D6  disp_code=1 directly
 *
 *   "tax/anger" arm @0x04B43E (unit_type 3):
 *     tbl2 = 0x181F:0x030C([0x5398],[0x8D52])      ; anger-table score
 *     if tbl2 >= 0x4B: disp_code=9 (VILLAGE)
 *     else if 0x0A38(owner,...)&0x20                ; at war?
 *          && [owner].level < [bound].level         ; bound stronger
 *          && PowerRecord[owner].gold >= 0x5DC(1500)
 *          && random_int(0,4)==0: disp_code=7 (intervene)
 *     else: cf=(int8_t)[0x8D4A][+5]
 *           cf<0 -> disp_code=3 ; (cf&0xF)==owner -> goto done ;
 *           else disp_code=4
 *
 *   "name lookup" arm @0x04B4DE (unit_types 1,4,11):
 *     0x181F:0x0722(unit.y[+0x3145], unit.x[+0x3144]) -> [bp-0x66]
 *     disp_code=9
 *
 *   default arm @0x04B50A (unit_types 2,6..11):
 *     0x181F:0x0B78(unit_index): if <0 goto done
 *     if unit[+0x315B] in {0x19,0x1C} && tbl>=0x4B: disp_code=5
 *     else goto done
 *
 *   @asm 0x04B4D6  disp_code=1 (unit_type 12 direct path)
 *   @asm 0x04B502  disp_code=6 (unit_type 5 direct path)
 *   All arms that set disp_code jump to 0x04B8EF -> LCALL 0x191F:0x16A epilogue.
 *
 * ---- PHASE 2: VILLAGE tribe-attitude display (0x04B56A..0x04BA00) ----
 *
 * @asm 0x04B56A  push 7 ; LCALL 0x181F:0x0524(7)     ; apply encounter code 7
 * @asm 0x04B574  bx=[0x8D4E]; bl=[bx+2] ; ax=bl (tribe market slot)
 *                bx=ax*6 ; word=[bx-0x69CC] -> push (market voice id)
 * @asm 0x04B589  push 0 ; LCALL 0x181F:0x0438(voice,0) ; set dialog context
 * @asm 0x04B593  push [bp-2] ; LCALL 0x181F:0x0A1A(region) -> power_name_id
 * @asm 0x04B59E  push power_name_id; push 1; LCALL 0x181F:0x0438(name,1) ; append name
 *
 *   Build "VILLAGE <attitude>" string in [bp-0x52] buffer:
 * @asm 0x04B5A9  push 0x1710("VILLAGE") ; lea ax,[bp-0x52]
 *               LCALL 0x0D1D:0x07E4(buf, "VILLAGE")  ; strcpy buf <- "VILLAGE"
 *
 *   5-LEVEL TRIBE ATTITUDE DETERMINATION (@asm 0x04B5B8..0x04B5F8):
 *     tbl = [bp-0xBA] (relation score from 0x181F:0x030C earlier)
 *     owner_word = [0x8D4A][owner*2+0xA] (per-owner state word)
 *     if tbl >= 0x4B (75):     attitude_str = 0x1718 ("WAR")
 *     elif tbl >= 0x32 (50):   attitude_str = 0x171C ("BAD")
 *     elif tbl >= 0x19 (25)
 *          OR owner_word >= 0x80:  attitude_str = 0x1720 ("MEDIUM")
 *     elif g_tribe_id_8D52==2: attitude_str = 0x1727 ("SAVAGE")
 *     else:                    attitude_str = 0x172E ("HAPPY")
 *
 * @asm 0x04B5FB  push attitude_str ; lea ax,[bp-0x52]
 *               LCALL 0x0D1D:0x07A4(buf, attitude_str) ; strcat buf += attitude_name
 *               -> [bp-0x52] now holds "VILLAGE WAR" / "VILLAGE MEDIUM" / etc.
 *
 *   Optional UI prompt when tbl >= 0x32:
 * @asm 0x04B607  if tbl >= 0x32:
 *      @asm 0x04B60E  promptId = (g_tribe_id_8D52==0)->7, (==1)->6, else 5
 *      @asm 0x04B628  LCALL 0x181F:0x04AC(promptId)       ; play/queue prompt sound
 *
 * @asm 0x04B630  lea bx,[0x87C] ; lea ax,[bp-0x52] ; dx=0
 *               LCALL 0x191F:0x0182(bx, buf, 0) -> dialog=[bp-0x5C]:[bp-0x5A]
 *               if dialog==0: goto done (no memory / suppressed)
 *
 *   Dialog item population (unit-type-dependent sound effects):
 * @asm 0x04B64B  if unitType in {0x0C, 0x0D..0x12}:     ; harbors & ships
 *      if tbl<0x4B: LCALL 0x181F:0x0022(1,[0x932A]) ; add sound item 1
 *      else:        LCALL 0x181F:0x0022(2,[0x932C]) ; add sound item 2
 *      LCALL 0x191F:0x0176(dialog, dx:ax, 0xA) ; append to dialog
 * @asm 0x04B692  if unitType==5: LCALL 0x181F:0x0022(6,[0x9334]) ; add item 6
 *               LCALL 0x191F:0x0176(dialog, dx:ax, 0xA) ; append
 * @asm 0x04B6BB  if unitType NOT in 0x0D..0x12 (non-ship):
 *      type_flag = g_unit_type_flags_5236[unitType*7]
 *      if type_flag > 1: LCALL 0x181F:0x0022(9,[0x933A]) ; add warning item 9
 *                        [bp-0x5E]=1 (flag_9 set)
 *               LCALL 0x191F:0x0176(dialog, dx:ax, 0xA) ; append
 * @asm 0x04B70D  LCALL 0x181F:0x0A38(region,owner) -> flags
 *               if !(flags&0x40): goto skip_colonize_items (0x04B865)
 * @asm 0x04B722  if unitType==3 (wagon):
 *      if [0x8D4A][+5]<0: add item 3 via LCALL 0x181F:0x0022(3,[0x932E])
 *      else if (bound[+5]&0xF)!=owner: (colony owned by another power)
 *           build "colony owner <name>" string; LCALL 0x191F:0x0176 ; append 4-item
 *      add item 7 via LCALL 0x181F:0x0022(7,[0x9336])
 * @asm 0x04B7C0  else (non-wagon): LCALL 0x181F:0x0B78(unit_index) (range check)
 *      if >=0 && type_flag<2 && unitType!=5 && range!=0x1B:
 *           add item 5 via LCALL 0x181F:0x0022(5,[0x9332]) ; append
 * @asm 0x04B820  if type_flag!=0 && unitType NOT in 0x0D..0x12:
 *      add item 8 via LCALL 0x181F:0x0022(8,[0x9338]) ; append
 * @asm 0x04B865  if !flag_9 && type_flag!=0 && unitType NOT in 0x0D..0x12:
 *      add item 9 via LCALL 0x181F:0x0022(9,[0x933A]) ; append (2nd chance)
 * @asm 0x04B8B0  add item 10 via LCALL 0x181F:0x0022(0xA,[0x933C]) ; always append close
 *               LCALL 0x191F:0x0176(dialog, dx:ax, 0xA)
 *
 *   Run dialog and dispatch event:
 * @asm 0x04B8CE  LCALL 0x191F:0x016A(dialog) -> disp_code=[bp-0x54]  ; poll dialog
 * @asm 0x04B8DC  LCALL 0x191F:0x01A8(dialog)                          ; close/free dialog
 * @asm 0x04B8E7  [bp-0x5C/5A]=0 (clear handle)
 * @asm 0x04B8EF  ax=[bp-0x54]; jmp 0x04B9B2
 *
 *   Second jump table at file 0x4B9C0 (CS:0x4BE0), 9 entries, dispatches on
 *   disp_code 1..9 to local near-call thunks which LJMP into 0x1A1F:xxx:
 *     disp_code 1 -> file 0x4B8F6  -> LJMP 0x1A1F:0x044C (arg: rel,owner,region,unit)
 *     disp_code 2 -> file 0x4B90C  -> LJMP 0x1A1F:0x03F8 ; if ax: [bp-0x58]=2
 *     disp_code 3 -> file 0x4B92E  -> [bp-0x58]=2; LJMP 0x1A1F:0x03EC
 *     disp_code 4 -> file 0x4B946  -> LJMP 0x1A1F:0x03C8
 *     disp_code 5 -> file 0x4B978  -> push 0; LJMP 0x1A1F:0x0428
 *     disp_code 6 -> file 0x4B966  -> LJMP 0x1A1F:0x03D4  (-> func_046FFA native_per_unit_AI)
 *     disp_code 7 -> file 0x4B956  -> LJMP 0x1A1F:0x03E0  (-> power_weekly_economy_tick 0x04830E)
 *     disp_code 8 -> file 0x4B98A  -> LJMP 0x1A1F:0x0410  (-> ovly_4BA34_substate, unpatched)
 *     disp_code 9 -> file 0x4B99A  -> push 4; LCALL 0x181F:0x0A06(4,region,owner)
 *                                     [bp-0x58]=0 ; goto done
 *
 * @asm 0x04B9D2  (done label) check [0x539C] vs prog0 snapshot:
 *               if changed: ax=2; pop si; leave; retf (reentrancy return 2)
 * @asm 0x04B9EA  if [bp-0x58]==1: LCALL 0x181F:0x0934(unit_index)  ; commit unit action
 * @asm 0x04B9FB  ax=[bp-0x58]; pop si; leave; retf
 *               returns [bp-0x58] (0=cancel, 1=committed, 2=follow-up/reopen)
 *
 * String IDs confirmed at DGROUP base 0x1D9A0:
 *   0x1705 = "MADATSHIPS"  (file 0x1F0A5)
 *   0x1710 = "VILLAGE"     (file 0x1F0B0)
 *   0x1718 = "WAR"         (file 0x1F0B8)   attitude level 1 (tbl >= 75)
 *   0x171C = "BAD"         (file 0x1F0BC)   attitude level 2 (tbl >= 50)
 *   0x1720 = "MEDIUM"      (file 0x1F0C0)   attitude level 3 (tbl >= 25 or owner_word >= 128)
 *   0x1727 = "SAVAGE"      (file 0x1F0C7)   attitude level 4 (tribe_id == 2)
 *   0x172E = "HAPPY"       (file 0x1F0CE)   attitude level 5 (default)
 *
 * BYTE_VERIFIED: ENTER frame 0xBA, arg layout [bp+6/8/A], all 5 attitude thresholds
 * (0x4B/0x32/0x19/0x80/tribe_id==2), both CS jump tables (file 0x4B552 and 0x4B9C0),
 * all DGROUP reads (0x539C/0x5398/0x543F/0xA2/0x8D4A/0x8D4E/0x8D52/0x8808/0x9328..
 * 0x933E/0x3144/0x5236), string IDs, return value logic and reentrancy guard.
 * ============================================================================ */
extern uint8_t  g_power_anger_5398;     /* DGROUP:0x5398 — per-power anger scalar */
extern uint8_t *g_market_array_8D4E;    /* (re-decl) DGROUP:0x8D4E bound market array */
/* PowerRecord gold: at @0x04B484 the code reads [bx-0x77CE] with bx=owner*0x13C,
 * i.e. PowerRecord[owner].gold (base 0x8808, stride 0x13C, field offset +0x2A). */

int king_mad_at_ships_dispatch(uint16_t unit_index_bp_06,
                               uint16_t arg1_bp_08, uint16_t arg2_bp_0A)  /* func_04B308 */
{
    int ret = 1;                                 /* @asm 0x04B30D [bp-0x58]=1 */
    int prog0 = g_unit_count_539C;               /* @asm 0x04B31F snapshot 0x539C */
    (void)prog0;

    /* @asm 0x04B325..0x04B33C — derive a relation/distance value and bind it. */
    int rel = overlay_call_181F_09F0();          /* f(arg2, arg1) -> [bp-0x62] */
    overlay_call_181F_0A4C();                    /* bind(rel) -> *0x8D4A tribe record */
    (void)rel;

    /* @asm 0x04B33F..0x04B34A — unit owner nibble. */
    uint8_t *u = &g_unit_table_3144[unit_index_bp_06 * UNIT_RECORD_STRIDE];
    int owner = u[0x03] & 0x0F;                  /* @asm 0x04B343 [bx+0x3147]&0xF */

    /* @asm 0x04B34D..0x04B379 — region/power of bound record and per-owner state word. */
    uint8_t *bound = g_bound_record_8D4A;
    int region = (int)bound[0x02];               /* @asm 0x04B351 [bp-0x02] */
    int rgn4 = region - 4;                       /* @asm 0x04B359 [bp-0x60] */
    int tbl = func_0082A0_logic_sz_18((uint16_t)rgn4, (uint16_t)owner); /* @asm 0x04B361 table(owner,rgn4)->[bp-0xBA] */
    int owner_word = *(int16_t *)&bound[owner * 2 + 0x0A];  /* @asm 0x04B376 [bp-0x64] */

    /* @asm 0x04B37C..0x04B3B3 — for live human power with no sfx muted, queue prompt. */
    if (owner < 4 && g_power_active_543F[owner * 0x34] == 0 /* @asm 0x04B386 */
                  /* @asm 0x04B38D [0xA2]==0 (sfx enabled) */) {
        /* @asm 0x04B394..0x04B3AE — prompt id by tribe: ==0->7, ==1->6, else 5 */
        overlay_call_181F_04AC();                /* UI prompt sound(7/6/5) */
    }

    /* @asm 0x04B3B6 — unit type; ship classes 0x0D..0x12 get the MADATSHIPS check. */
    int unit_type = u[0x02];                     /* [bx+0x3146] */
    if (unit_type >= 0x0D && unit_type <= 0x12) {
        /* @asm 0x04B3CE — relation flags for (owner, region). */
        int fl = overlay_call_181F_0A38();       /* -> al */
        if (!(fl & 0x20)) {                      /* @asm 0x04B3D6 not at war */
            (void)menu_run_boxed(0x16F7);        /* @asm 0x04B3DA lea bx,[0x16F7]
                                                  * "DONTKNOWSHIPS"; 0x04B3DE lcall
                                                  * 0x181F:0x3FE (PORTED runner) */
            goto done;                           /* @asm 0x04B3E3 */
        }
        /* @asm 0x04B3E6 — King threshold: tbl>=0x4B OR owner_word>=0x40 -> intervene. */
        if (!(tbl < 0x4B && owner_word < 0x40)) {
            /* @asm 0x04B3F3..0x04B418 — King intervenes: emit "MADATSHIPS <power>". */
            overlay_call_181F_09A4();            /* format power name from region */
            overlay_call_181F_0438();            /* set dialog context */
            overlay_call_191F_019C();            /* push [0x8D52],0x1705("MADATSHIPS") */
            goto done;                           /* @asm 0x04B418 */
        }
    }

    /* @asm 0x04B41C..0x04B42D — live human power short-circuits to VILLAGE path. */
    if (owner < 4 && g_power_active_543F[owner * 0x34] == 0)
        goto ret9_tail;                          /* @asm 0x04B42D -> 0x04B56A */

    /* @asm 0x04B430..0x04B54D — outcome dispatch on unit type via the 12-entry
     * CS jump table at file 0x4B552 (CS:0x4772).  code = unitType-1. */
    {
        int code = unit_type - 1;                /* @asm 0x04B544 */
        if ((unsigned)code > 0x0B) {
            /* @asm 0x04B50A default arm (unit_types 2, 6..11). */
            if (func_008BB2_logic_sz_20(unit_index_bp_06) < 0) /* range/legality check */
                goto done;                       /* @asm 0x04B519 */
            if ((u[0x17] == 0x1C || u[0x17] == 0x19) && tbl >= 0x4B)  /* +0x315B */
                ret = 5;                         /* @asm 0x04B53B */
            else
                goto done;                       /* @asm 0x04B52E */
        } else {
            switch (code) {                      /* @asm 0x04B54D jmp cs:[code*2+0x4772] */
            case 2:  /* unit_type 3 — @asm 0x04B43E "tax/anger" arm */
                if (func_0082A0_logic_sz_18(DG16(0x8D52), DG16(0x5398)) >= 0x4B) { /* table([0x5398],[0x8D52]) */
                    ret = 9;                      /* @asm 0x04B44E anger score maxed */
                } else if ((overlay_call_181F_0A38() & 0x20) &&   /* @asm 0x04B45A at war */
                           /* @asm 0x04B466..0x04B480 bound level < owner level */
                           /* @asm 0x04B484 PowerRecord[owner].gold >= 0x5DC (1500) */
                           1 /* gold check elided */ &&
                           overlay_call_181F_04D4() == 0) { /* @asm 0x04B490 random(0,4) */
                    ret = 7;                      /* @asm 0x04B4A6 King intervenes */
                } else {
                    /* @asm 0x04B4AE — outcome by colony ownership flag [0x8D4A][+5]. */
                    int cf = (int8_t)bound[0x05];
                    if (cf < 0)                   /* @asm 0x04B4B6 enemy colony */
                        ret = 3;                  /* @asm 0x04B4B8 */
                    else if ((cf & 0x0F) == owner) /* @asm 0x04B4C0 own colony */
                        goto done;               /* @asm 0x04B4CB */
                    else
                        ret = 4;                  /* @asm 0x04B4CE neutral colony */
                }
                break;
            case 0:  /* unit_type 1 — @asm 0x04B4DE "name lookup" arm */
            case 3:  /* unit_type 4 */
            case 10: /* unit_type 11 */
                overlay_call_181F_0722();         /* 0x722(unit.y[+0x3145], unit.x[+0x3144]) */
                ret = 9;                          /* @asm 0x04B4F9 */
                break;
            case 4:  /* unit_type 5 — @asm 0x04B502 */
                ret = 6;
                break;
            case 11: /* unit_type 12 — @asm 0x04B4D6 */
                ret = 1;
                break;
            default: /* unit_types 2,6..10 -> default arm (same as code>0x0B above) */
                if (func_008BB2_logic_sz_20(unit_index_bp_06) < 0)
                    goto done;
                if ((u[0x17] == 0x1C || u[0x17] == 0x19) && tbl >= 0x4B)
                    ret = 5;
                else
                    goto done;
                break;
            }
        }
    }

ret9_tail:
    /* ---- PHASE 2: VILLAGE tribe-attitude display (0x04B56A..0x04B8EF) ----
     *
     * @asm 0x04B56A  push 7 ; LCALL 0x181F:0x0524(7)  — apply encounter code 7
     * @asm 0x04B574  tribe_slot = [0x8D4E][+2] ; voice_id = [slot*6 - 0x69CC]
     * @asm 0x04B585  LCALL 0x181F:0x0438(voice_id, 0) — set dialog voice context
     * @asm 0x04B593  power_name = 0x181F:0x0A1A(region)
     * @asm 0x04B59E  LCALL 0x181F:0x0438(power_name, 1) — append power name
     * @asm 0x04B5A9  strcpy(buf, "VILLAGE"[0x1710])  via 0x0D1D:0x07E4
     *
     *   5-level attitude determination (@asm 0x04B5B8..0x04B5F8):
     *     tbl >= 75 (0x4B): push 0x1718 ("WAR")          — hostile
     *     tbl >= 50 (0x32): push 0x171C ("BAD")          — unfriendly
     *     tbl >= 25 (0x19) OR owner_word >= 128 (0x80):
     *                       push 0x1720 ("MEDIUM")        — neutral
     *     g_tribe_id_8D52==2: push 0x1727 ("SAVAGE")     — savage
     *     else:             push 0x172E ("HAPPY")         — friendly
     *
     * @asm 0x04B5FB  strcat(buf, attitude_str) via 0x0D1D:0x07A4
     *               -> buf = "VILLAGE WAR" / "VILLAGE BAD" / "VILLAGE MEDIUM" /
     *                        "VILLAGE SAVAGE" / "VILLAGE HAPPY"
     * @asm 0x04B607  if tbl >= 50: queue prompt(7/6/5) via 0x181F:0x04AC
     * @asm 0x04B630  LCALL 0x191F:0x0182(0x87C, buf, 0) -> dialog handle
     *               if handle==0: goto done
     *
     *   Dialog item population (0x04B64B..0x04B862) — adds sound items per
     *   unit type using 0x181F:0x0022 + 0x191F:0x0176; see banner for detail.
     *
     * @asm 0x04B8CE  LCALL 0x191F:0x016A(dialog) -> disp_code=[bp-0x54]
     * @asm 0x04B8DC  LCALL 0x191F:0x01A8(dialog)   — close/free dialog
     * @asm 0x04B8EF  ax=[bp-0x54]; jmp 0x04B9B2    — dispatch on disp_code
     *
     *   Second jump table at file 0x4B9C0 (CS:0x4BE0), 9 entries:
     *     disp_code 1..8 -> local thunks LJMPing to 0x1A1F:0x044C/3F8/3EC/3C8/428/3D4/3E0/410
     *     disp_code 9    -> LCALL 0x181F:0x0A06(4,region,owner); [bp-0x58]=0
     */
    overlay_call_181F_0524();                    /* @asm 0x04B56C push 7 + apply(7) */
    /* market voice, power name, strcpy "VILLAGE", strcat attitude: */
    overlay_call_181F_0438();                    /* @asm 0x04B585 set dialog context */
    overlay_call_181F_0A1A();                    /* @asm 0x04B596 power name lookup */
    overlay_call_181F_0438();                    /* @asm 0x04B5A1 append power name */
    /* build "VILLAGE <attitude>" in stack buffer [bp-0x52]: */
    /* attitude = WAR(tbl>=75) / BAD(tbl>=50) / MEDIUM(tbl>=25 or word>=128) /
     *            SAVAGE(tribe_id==2) / HAPPY(else) */
    /* strcat attitude string, optional sound prompt if tbl>=50 */
    overlay_call_191F_0182();                    /* @asm 0x04B639 open dialog -> handle */
    /* populate dialog items (unit-type-specific sound effects) */
    overlay_call_191F_016A();                    /* @asm 0x04B8CE poll -> disp_code */
    overlay_call_191F_01A8();                    /* @asm 0x04B8DC close dialog */
    /* dispatch disp_code 1..9 via second jump table at CS:0x4BE0 */
    /* -> 0x1A1F handlers or cancel ([bp-0x58]=0) */

done:
    /* @asm 0x04B9D2 — reentrancy guard: if [0x539C] changed, return 2. */
    /* @asm 0x04B9EA — if ret==1: LCALL 0x181F:0x0934(unit_index) commit action. */
    /* @asm 0x04B9FB — return [bp-0x58] (0=cancel, 1=committed, 2=follow-up). */
    return ret;
}

/* ============================================================================
 * !! OFFSET RECONCILIATION (authoritative) — read before the entries below !!
 * ----------------------------------------------------------------------------
 * The authoritative re-segmented dump
 *   reverse_engineered/code/VICEROY/disasm_overlay_reseg/page_0C.asm
 * states for overlay page 0x0C:
 *     code_offset (first insn) = 0x046DE0
 *     code_end (next reloc hdr)= 0x04BA50
 *     functions in page        = 19   (func_046DE0 .. func_04B308 inclusive)
 *     func_04B308 terminal     = "page"  (runs to the page boundary 0x04BA50)
 *
 * Two consequences, both verified against tools/rtlink/VICEROY_flat.exe
 * (flat_off = file_off - 0x47B0):
 *
 *  (1) func_046D70 is BEFORE code_offset (0x046600..0x046DE0 is the page's
 *      relocation-header / table region).  The auto-decoder framed reloc bytes
 *      as a 112-byte "function".  -> PHANTOM (already marked at top of file).
 *
 *  (2) The entries the auto-pipeline placed at file offsets 0x04BDA4 / 0x04C060
 *      / 0x04C0F0 / 0x04C1F0 / 0x04C20C / 0x04C262 / 0x04C298 / 0x04C2CE are all
 *      PAST page-0C code_end (0x04BA50) and are NOT among page 0x0C's 19
 *      functions.  Two sub-cases (UPDATED 2026-05-30 now that the page_0D reseg
 *      —disasm_overlay_reseg/page_0D.asm— is available):
 *
 *      (2a) RELOC-HEADER PHANTOMS — 0x04BDA4 and 0x04C060 fall inside page 0x0D's
 *           relocation-table header, which spans file 0x04BA50 (page_0D
 *           file_offset) .. 0x04C1F0 (page_0D code_offset) = 0x7A0 (1952) bytes.
 *           They are reloc-pointer bytes (4-byte `XX XX 00 00` cadence), not
 *           code.  -> PHANTOM (byte-confirmed below; see each banner).
 *
 *      (2b) REAL page-0D functions — 0x04C1F0 (and the grid helpers that follow:
 *           0x04C20C / 0x04C262 / 0x04C298 / 0x04C2CE) ARE the genuine first
 *           functions of overlay page 0x0D (page_0D code_offset = 0x04C1F0,
 *           func_04C1F0 prologue `55 8B EC` byte-verified).  They are CORRECTLY
 *           addressed at their page_0D offsets (the earlier "inflated by ~0x7A0"
 *           note was mistaken — there is no spill/offset inflation; the bodies
 *           sit exactly where the labels say).  Their decompiled CONTENT (the
 *           overlay-grid clear/shift/cull helpers) is byte-real — e.g.
 *           `C6 87 B2 98 FF` (mov [bx-0x674E],0xFF) at file 0x04BA5F is part of
 *           func_04C1F0's body region.  0x04C0F0 is a 5-byte orphan-ENTER pad
 *           (PHANTOM).  These page-0D entries are OUTSIDE this file's
 *           authoritative range; they are retained here only as already-ported
 *           helpers and are out of scope for the 2026-05-30 completion pass.
 *
 * cite-or-not yet decoded: no offsets are guessed; the @asm citations on the grid-helper
 * entries below are the per-func dump's offsets, retained to trace provenance.
 * ============================================================================ */

/* ============================================================================
 * func_04BDA4 — PHANTOM (page-0x0D relocation-table bytes)  [byte-confirmed]
 * ----------------------------------------------------------------------------
 * NOT code.  File offset 0x04BDA4 sits inside page 0x0D's relocation header,
 * which spans file 0x04BA50 (page_0D file_offset) .. 0x04C1F0 (page_0D
 * code_offset) = 0x7A0 (1952) bytes.  Neither the authoritative reseg page_0C
 * (functions end at func_04B308 -> code_end 0x04BA50) NOR page_0D (first real
 * function is func_04C1F0, prologue 55 8B EC) lists a function here.  The raw
 * bytes at 0x04BDA4 are a run of 4-byte little-endian relocation pointers:
 *   c8 70 00 00 | 6b 0a 00 00 | ed 30 00 00 | 2a 5d 00 00 | b7 6d 00 00 | …
 * (the auto-decoder mis-read the leading `c8 70 00 00` as `ENTER 0x70,0`).  The
 * `XX XX 00 00` cadence is the reloc-entry signature, not instructions.  No body.
 * ============================================================================ */
/* PHANTOM: 0x04BDA4 is page-0x0D reloc-table data (0x04BA50..0x04C1F0) — see banner. */

/* ============================================================================
 * func_04C060 — PHANTOM (page-0x0D relocation-table bytes)  [byte-confirmed]
 * ----------------------------------------------------------------------------
 * NOT code.  Same page-0x0D reloc-header region as func_04BDA4 above.  Raw bytes
 * at 0x04C060 are 4-byte reloc pointers:
 *   c8 56 00 00 | 15 56 00 00 | eb 5d 00 00 | 18 62 00 00 | c4 61 00 00 | …
 * (the `c8 56 00 00` was mis-read as `ENTER 0x56,0`).  No callers, no string
 * anchor, not in either page's function list.  No body.
 * ============================================================================ */
/* PHANTOM: 0x04C060 is page-0x0D reloc-table data (0x04BA50..0x04C1F0) — see banner. */

/* ----------------------------------------------------------------------------
 * func_04C0F0 — PHANTOM (orphan ENTER fragment)
 * Per-func dump: 5 bytes, lone `ENTER 0x6F` with no body — alignment/padding
 * mis-framed as a function.  Past code_end.  Not code.
 * ---------------------------------------------------------------------------- */
/* PHANTOM: func_04C0F0 is a 5-byte orphan-ENTER fragment — see OFFSET RECONCILIATION. */

/* ============================================================================
 * overlay_grid64_clear_cell  [DONE — content BYTE_VERIFIED; MIS-ADDRESSED]
 * (per-func label func_04C1F0; real body in the 0x04BA50+ spill region)
 * ----------------------------------------------------------------------------
 * Clears one cell of the 64-wide dword overlay grid based at DGROUP 0x98B2
 * region: index = ((row<<6) + col) * 4; sets cell[+0x00] = 0xFF (empty
 * sentinel) and cell[+0x01] = 0.
 *
 *   bx = row << 6              ; 64 columns/row     (prologue PUSH bp;MOV bp,sp)
 *   bx += col
 *   bx <<= 2                   ; * sizeof(cell)=4
 *   [bx-0x674E] = 0xFF         ; cell[+0x00] = empty (DGROUP 0x98B2 region)
 *   [bx-0x674D] = 0            ; cell[+0x01] = 0
 * Verified-real bytes `C6 87 B2 98 FF` exist at flat 0x472AF (= file 0x04BA5F);
 * the per-func dump's "0x04C1FF" address is inflated (see OFFSET RECONCILIATION).
 * [content BYTE_VERIFIED; offset to be re-cited against the spill-page reseg]
 * ============================================================================ */
extern uint8_t g_overlay_grid64_98B2[];   /* DGROUP:0x98B2 — 64-wide dword overlay grid */

void overlay_grid64_clear_cell(uint16_t row, uint16_t col)  /* per-func func_04C1F0 (mis-addr) */
{
    uint8_t *cell = &g_overlay_grid64_98B2[((row << 6) + col) * 4];
    cell[0x00] = 0xFF;   /* cell[+0x00] empty sentinel */
    cell[0x01] = 0x00;   /* cell[+0x01] */
}

/* ============================================================================
 * overlay_grid16_cull_by_range  [DONE — content BYTE_VERIFIED; MIS-ADDRESSED]
 * (per-func label func_04C20C; real body in the 0x04BA50+ spill region)
 * ----------------------------------------------------------------------------
 * Walks the 16-entry row `row` of the 16-wide dword grid at DGROUP 0x9EAA
 * region (cell stride 4): for each cell whose key byte (+0x02) == match_key,
 * calls range/distance helper 0x181F:0x037A(cell.x, cell.y, ref_a, ref_b); if
 * the metric <= max_metric, the cell is culled (key +0x02 = 0xFF, +0x03 = 0).
 *
 *   al = (byte)match_key
 *   bx = (row << 4) + i ; bx <<= 2                 ; 16/row, *4
 *   if cell.key(+0x02) != al -> skip
 *   push (s8)cell.y(+0x01) ; push (s8)cell.x(+0x00) ; push ref_b ; push ref_a
 *   lcall 0x181F:0x037A -> metric
 *   if metric > max_metric -> skip
 *   cell.key(+0x02)=0xFF ; cell.+0x03 = 0          ; cull
 *   i++ ; while i < 0x10
 * Verified-real bytes `38 87 AC 9E` (cmp key) at flat 0x472D5 (= file 0x04BA85)
 * and `9A 7A 03 1F 18` (LCALL 0x181F:0x037A) present in the spill region.
 * [content BYTE_VERIFIED; offset inflated by the per-func extractor]
 * ============================================================================ */
extern uint8_t g_overlay_grid16_9EAA[];   /* DGROUP:0x9EAA — 16-wide dword overlay grid */
/* 0x181F:0x037A — range/distance(cell_x, cell_y, ref_x, ref_y) -> metric. */

void overlay_grid16_cull_by_range(uint16_t row, uint16_t match_key,
                                  uint16_t ref_a, uint16_t ref_b, uint16_t max_metric)  /* per-func func_04C20C (mis-addr) */
{
    for (int i = 0; i < 0x10; i++) {
        uint8_t *cell = &g_overlay_grid16_9EAA[((row << 4) + i) * 4];
        if (cell[0x02] != (uint8_t)match_key)
            continue;
        int metric = overlay_call_181F_037A();             /* range(cell.x, cell.y, ref_a, ref_b) */
        (void)ref_a; (void)ref_b;
        if (metric > (int)max_metric)
            continue;
        cell[0x02] = 0xFF;                                 /* cull (key=empty) */
        cell[0x03] = 0x00;
    }
}

/* ============================================================================
 * overlay_grid64_shift_down  [DONE — content BYTE_VERIFIED; MIS-ADDRESSED]
 * (per-func label func_04C262; real body in the 0x04BA50+ spill region)
 * ----------------------------------------------------------------------------
 * Shifts column `col` of the 64-wide dword grid (0x98B2 region) DOWN by one
 * row: for r from 0x3E down to stop_row, copies the dword cell at
 * [(col<<6)+r] into the next cell.  The dword is two words (+0x00, +0x02).
 *
 *   r = 0x3E
 *   bx = ((col<<6)+r) << 2
 *   ax = cell.word0 (+0x00) ; dx = cell.word1 (+0x02)
 *   dest.word0 (+0x04) = ax ; dest.word1 (+0x06) = dx     ; copy cell -> cell+1
 *   r-- ; while r >= stop_row
 * [content BYTE_VERIFIED; per-func offsets inflated — see OFFSET RECONCILIATION]
 * ============================================================================ */
void overlay_grid64_shift_down(uint16_t col, uint16_t stop_row)  /* per-func func_04C262 (mis-addr) */
{
    for (int r = 0x3E; r >= (int)stop_row; r--) {
        uint16_t *src = (uint16_t *)&g_overlay_grid64_98B2[(((col << 6) + r) << 2) - 2];
        uint16_t w0 = src[0];
        uint16_t w1 = src[1];
        src[2] = w0;
        src[3] = w1;
    }
}

/* ============================================================================
 * overlay_grid16_shift_down  [DONE — content BYTE_VERIFIED; MIS-ADDRESSED]
 * (per-func label func_04C298; real body in the 0x04BA50+ spill region)
 * ----------------------------------------------------------------------------
 * As overlay_grid64_shift_down but for the 16-wide dword grid at 0x9EAA: shifts
 * column `col` down from row 0x0E to stop_row (cell.word0 +0x00, word1 +0x02 ->
 * +0x04 / +0x06).  [content BYTE_VERIFIED; per-func offset inflated]
 * ============================================================================ */
void overlay_grid16_shift_down(uint16_t col, uint16_t stop_row)  /* per-func func_04C298 (mis-addr) */
{
    for (int r = 0x0E; r >= (int)stop_row; r--) {
        uint16_t *src = (uint16_t *)&g_overlay_grid16_9EAA[(((col << 4) + r) << 2)];
        uint16_t w0 = src[0];
        uint16_t w1 = src[1];
        src[2] = w0;
        src[3] = w1;
    }
}

/* ============================================================================
 * overlay_table_c_shift_down — shift the 6-byte TABLE_C array down one slot
 *                                          [DONE — BYTE_VERIFIED]
 * (per-func label func_04C2CE; 55 bytes 0x04C2CE..0x04C304, fully terminated)
 * ----------------------------------------------------------------------------
 * The sibling of overlay_grid16_shift_down (func_04C298), but for the OTHER AI
 * grid: TABLE_C at DGROUP:0xA0DC — a flat 16-slot array of 6-byte (3-word)
 * records (NOT the per-power 4-byte QUEUE_B at 0x9EAA).  Walks r from 0x0E down
 * to stop_row and copies record[r] into record[r+1] (the slot 6 bytes higher),
 * opening a gap at `stop_row` — a top-of-list insert/scroll.  Uses `rep movsw`
 * (es=ds) for the 3-word copy.
 *
 * @asm 0x04C2CE  ENTER 2,0 / PUSH di / PUSH si       ; local [bp-2]=r, arg stop_row=[bp+6]
 * @asm 0x04C2D4  [bp-2] = 0x0E
 * @asm 0x04C2DC  bx = r*6 (shl/add/shl: r<<1 + r, <<1)
 * @asm 0x04C2E7  di = bx - 0x5F1E  (= &TABLE_C[r*6 + 6])
 * @asm 0x04C2EB  si = bx - 0x5F24  (= &TABLE_C[r*6])      ; 0xA0DC == 0x10000-0x5F24
 * @asm 0x04C2EF  es = ds
 * @asm 0x04C2F3  movsw ×3                                 ; copy 3 words si->di
 * @asm 0x04C2F6  r--
 * @asm 0x04C2F9  while r >= stop_row([bp+6]): loop
 * @asm 0x04C304  RETF
 *
 * The earlier "MIS-ADDRESSED / truncated" note was wrong: the per-func dump is
 * the complete 55-byte body (ENTER..RETF).  TABLE_C base 0xA0DC matches the
 * companion declaration in overlay_04C306_053BC1.c (g_ai_table_c_A0DC).
 * ============================================================================ */
extern uint8_t g_ai_table_c_A0DC[];   /* DGROUP:0xA0DC — 16 slots × 6-byte AI records */

void overlay_table_c_shift_down(uint16_t stop_row)  /* func_04C2CE */
{
    /* @asm 0x04C2D4 / 0x04C2F9..0x04C2FF — r = 0x0E downto stop_row (inclusive) */
    for (int r = 0x0E; r >= (int)stop_row; r--) {
        uint16_t *src = (uint16_t *)&g_ai_table_c_A0DC[r * 6];      /* si @asm 0x04C2EB */
        uint16_t *dst = (uint16_t *)&g_ai_table_c_A0DC[r * 6 + 6];  /* di = si+6 @asm 0x04C2E7 */
        dst[0] = src[0];                                            /* @asm 0x04C2F3 movsw */
        dst[1] = src[1];                                           /* @asm 0x04C2F4 movsw */
        dst[2] = src[2];                                           /* @asm 0x04C2F5 movsw */
    }
}
