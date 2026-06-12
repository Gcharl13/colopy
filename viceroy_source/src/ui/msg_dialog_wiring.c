/* ============================================================================
 * msg_dialog_wiring.c — Phase 3.5 dialog/event sweep
 *
 * Strong override definitions for the dialog/message overlay thunks that
 * were previously weak stubs.  All targets are already ported; this file
 * provides the alias definitions that the multiple extern spellings need.
 *
 * THUNK MAP (byte-verified against VICEROY.EXE thunk records):
 *
 *   0x181F:0x0652 -> file 0x6F5F2 = func_06F5F2 (msg_show / ovly_dialog_652 /
 *                    mn_msg_popup): stores [0x1F5E]=flag, loads "GAME" base,
 *                    calls menu_lookup_run(key, dx=0).
 *                    @asm 0x6F5F5 mov ax,[bp+8]  ; flag -> [0x1F5E]
 *                    @asm 0x6F5FF mov ax,[bp+6]  ; key
 *                    @asm 0x6F602 sub dx,dx      ; preselect=0
 *                    @asm 0x6F604 push cs; call 0x6F7EF = ljmp 0x181F:0x998
 *                    (0x181F:0x998 = menu_lookup_run = func_06F51A)
 *                    Modern: menu_run_boxed(key_off) covers the menu_lookup_run
 *                    chain; the [0x1F5E] side-effect is headless-safe to skip.
 *
 *   0x181F:0x0438 -> file 0x6C23C = func_06C23C_dialog_make_from_int
 *                    (msg_set_arg / ovly_msg_arg_438 / msg_set_int)
 *                    PORTED in src/overlay/overlay_06C220_06D938.c
 *
 *   0x181F:0x09AE -> file 0x6C27C = func_06C27C_dialog_slot_set_pair
 *                    (msg_emit_num / ovly_msg_arg_9AE / msg_set_long)
 *                    PORTED in src/overlay/overlay_06C220_06D938.c
 *
 *   0x181F:0x0416 -> file 0x6C220 = func_06C220_dialog_slot_set_block
 *                    (msg_set_ptr / ovly_msg_str_416)
 *                    PORTED in src/overlay/overlay_06C220_06D938.c
 *
 *   0x181F:0x03FE -> file 0x6F594 = menu_run_boxed shim
 *                    (ovly_msg_str_3FE) — called with BX=0x13A0 pre-loaded
 *                    by the CANNOTATTACK site @asm 0x03EF0D/0x03EF11.
 *                    Modern: hardcoded to menu_run_boxed(0x13A0).
 *
 *   0x191F:0x0AE0 -> file 0x34318 = func_034318_runtime_chain_289
 *                    (king_schedule_royal_events)
 *                    PORTED in src/overlay/overlay_0341D6_0388DE.c
 *
 *   0x181F:0x0A38 -> file 0x07F34 = func_007F34_logic_sz_27 (rel_query)
 *   0x181F:0x0A06 -> file 0x07F96 = func_007F96_op_sz_105  (rel_apply_event)
 *   0x181F:0x0A10 -> file 0x08000 = func_008000_op_sz_115  (rel_clear_event)
 *                    All PORTED in src/load_image/load_image_007610_00824E.c
 *
 * good_label_value  = market_bid_price (func_030590)
 *                     PORTED in src/market/pricing.c @0x030590
 *                     The near-call trampoline 0x36813 -> 0x191F:0x9EA was
 *                     a thunk-table entry, not a near-page jump; the C port
 *                     at market_bid_price implements the body byte-faithfully.
 * ============================================================================ */
#ifdef _VICEROY_MODERN
#include "viceroy_types.h"
#include "dgroup.h"

/* ---- extern references to the already-ported strong bodies ---- */
extern int  menu_run_boxed(uint16_t key_off);   /* src/ui/menu_runner.c */
extern int  func_06C23C_dialog_make_from_int(uint16_t a0, uint16_t a1);
extern int  func_06C27C_dialog_slot_set_pair(uint16_t slot, uint16_t v0, uint16_t v1);
extern int  func_06C220_dialog_slot_set_block(uint16_t slot, uint16_t v0, uint16_t v1);
extern int  func_034318_runtime_chain_289(uint16_t power);
extern int  func_007F34_logic_sz_27(uint16_t a, uint16_t b);
extern int  func_007F96_op_sz_105(uint16_t a, uint16_t b, uint16_t c);
extern int  func_008000_op_sz_115(uint16_t a, uint16_t b, uint16_t c);
extern int  market_bid_price(int good);         /* func_030590; src/market/pricing.c */

/* ============================================================================
 * ovly_dialog_652 / msg_show / mn_msg_popup — 0x181F:0x652 -> func_06F5F2
 * ----------------------------------------------------------------------------
 * func_06F5F2 @ 0x6F5F2..0x6F609 (24 bytes, byte-verified):
 *   push bp; mov bp,sp
 *   mov ax,[bp+8]          ; flag arg
 *   mov [0x1F5E],ax        ; @asm 0x6F5F8 stores flag in the preselect slot
 *   lea bx,[0x87C]         ; file-base "GAME"
 *   mov ax,[bp+6]          ; msg_id (DGROUP key offset)
 *   sub dx,dx              ; preselect = 0
 *   push cs; call 0x6F7EF  ; ljmp 0x181F:0x998 = menu_lookup_run
 *   leave; retf
 *
 * The [0x1F5E] store is headless-safe to skip (it's the preselect seed for a
 * subsequent panel re-open, irrelevant without an interactive session).
 * In headless mode menu_run_boxed logs the section and returns default choice.
 * ============================================================================ */
int ovly_dialog_652(int flag, int msg_id)   /* STRONG — overrides weak stub */
{
    (void)flag;                                     /* @asm 0x6F5F8 [0x1F5E]=flag (skip) */
    return menu_run_boxed((uint16_t)msg_id);         /* @asm 0x6F602..0x6F608 */
}

/* Public-name aliases for the callers that use different extern spellings
 * for the same 0x181F:0x652 thunk:
 *   msg_show(channel, key_handle)   — pricing.c, overlay_03C5A8, etc.
 *   mn_msg_popup(mode, key_handle)  — menu.c colony-service popup arms
 */
int msg_show(int channel, int key_handle)   /* STRONG — 0x181F:0x652 */
{
    (void)channel;
    return menu_run_boxed((uint16_t)key_handle);
}

int mn_msg_popup(int mode, int key_handle)  /* STRONG — 0x181F:0x652 */
{
    (void)mode;
    return menu_run_boxed((uint16_t)key_handle);
}

/* ============================================================================
 * msg_set_arg / ovly_msg_arg_438 / msg_set_int — 0x181F:0x438
 *   -> func_06C23C_dialog_make_from_int(slot, value)
 * The callers' argument order matches: cdecl right-to-left push means
 * [bp+6]=slot, [bp+8]=value in the original.
 * ============================================================================ */
int ovly_msg_arg_438(int slot, int value)   /* STRONG */
{
    return func_06C23C_dialog_make_from_int((uint16_t)slot, (uint16_t)value);
}

int msg_set_arg(int slot, int value)        /* STRONG — 0x181F:0x438 */
{
    return func_06C23C_dialog_make_from_int((uint16_t)slot, (uint16_t)value);
}

int msg_set_int(int slot, int value)        /* STRONG — 0x181F:0x438 */
{
    return func_06C23C_dialog_make_from_int((uint16_t)slot, (uint16_t)value);
}

/* ============================================================================
 * msg_emit_num / ovly_msg_arg_9AE / msg_set_long — 0x181F:0x9AE
 *   -> func_06C27C_dialog_slot_set_pair(slot, lo, hi)
 * cdecl push order: slot=[bp+6], lo=[bp+8], hi=[bp+0xA].
 * msg_emit_num(long n, int slot): slot is rightmost -> [bp+6]; n is a dword
 *   -> lo=[bp+8], hi=[bp+0xA].  ✓  match.
 * msg_set_long(int slot, long v): slot=[bp+6], lo=[bp+8], hi=[bp+0xA].  ✓
 * ============================================================================ */
int ovly_msg_arg_9AE(int slot, int v0, int v1)  /* STRONG */
{
    return func_06C27C_dialog_slot_set_pair((uint16_t)slot, (uint16_t)v0, (uint16_t)v1);
}

int msg_emit_num(long n, int slot)          /* STRONG — 0x181F:0x9AE */
{
    return func_06C27C_dialog_slot_set_pair((uint16_t)slot, (uint16_t)(uint32_t)n,
                                            (uint16_t)((uint32_t)n >> 16));
}

int msg_set_long(int slot, long v)          /* STRONG — 0x181F:0x9AE */
{
    return func_06C27C_dialog_slot_set_pair((uint16_t)slot, (uint16_t)(uint32_t)v,
                                            (uint16_t)((uint32_t)v >> 16));
}

/* ============================================================================
 * msg_set_ptr / ovly_msg_str_416 — 0x181F:0x416
 *   -> func_06C220_dialog_slot_set_block(slot, seg, off)
 * ============================================================================ */
int ovly_msg_str_416(int slot, int seg, int off)  /* STRONG */
{
    return func_06C220_dialog_slot_set_block((uint16_t)slot, (uint16_t)seg, (uint16_t)off);
}

int msg_set_ptr(int slot, void *ptr, int z) /* STRONG — 0x181F:0x416 */
{
    (void)z;
    /* The EXE passes DS:near_ptr as (seg=DS push, off=push near ptr).
     * In the modern flat model: store the raw pointer words into the slot. */
    uintptr_t p = (uintptr_t)ptr;
    return func_06C220_dialog_slot_set_block((uint16_t)slot,
                                             (uint16_t)(p >> 16),
                                             (uint16_t)p);
}

/* ============================================================================
 * ovly_msg_str_3FE — 0x181F:0x3FE -> menu_run_boxed shim
 * Called from unit_orders.c with BX pre-loaded to 0x13A0 (= "CANNOTATTACK")
 * @asm 0x03EF0D lea bx,[0x13A0] / 0x03EF11 lcall 0x181F:0x3FE
 * ============================================================================ */
void ovly_msg_str_3FE(void)                 /* STRONG */
{
    (void)menu_run_boxed(0x13A0);            /* @asm 0x03EF0D: BX=0x13A0 "CANNOTATTACK" */
}

/* ============================================================================
 * king_schedule_royal_events — 0x191F:0x0AE0 -> func_034318
 * PORTED: src/overlay/overlay_0341D6_0388DE.c  func_034318_runtime_chain_289
 * ============================================================================ */
void king_schedule_royal_events(int power_id)   /* STRONG */
{
    (void)func_034318_runtime_chain_289((uint16_t)power_id);
}

/* ============================================================================
 * rel_query / rel_apply_event / rel_clear_event
 * PORTED: src/load_image/load_image_007610_00824E.c
 * ============================================================================ */
uint8_t rel_query(int self, int other)     /* STRONG — 0x181F:0x0A38 */
{
    return (uint8_t)func_007F34_logic_sz_27((uint16_t)self, (uint16_t)other);
}

void rel_apply_event(int a, int b, int mask) /* STRONG — 0x181F:0x0A06 */
{
    (void)func_007F96_op_sz_105((uint16_t)a, (uint16_t)b, (uint16_t)mask);
}

void rel_clear_event(int mask, int a, int b) /* STRONG — 0x181F:0x0A10 */
{
    /* Note: arg order at 0x181F:0x0A10 is (mask, a, b) matching the EXE
     * call sites — verified @asm 0x03F2A5 push handle/push self/push 0x40 */
    (void)func_008000_op_sz_115((uint16_t)mask, (uint16_t)a, (uint16_t)b);
}

/* ============================================================================
 * good_label_value — near-call trampoline in pricing.c -> 0x191F:0x9EA
 *   -> func_030590 = market_bid_price (the sell/bid price for a commodity)
 * @asm 0x030590..0x0305A7 (byte-verified in pricing.c market_bid_price body)
 *   mov bx,[0x84FC] ; PR_PRICE_LEVEL(g_market, good) - 1; clamp 0
 * The "good_label_value" extern in pricing.c is the same body; they are
 * IDENTICAL — same file offset, same frame, same logic.
 * ============================================================================ */
long good_label_value(int good)             /* STRONG — 0x191F:0x9EA */
{
    return (long)market_bid_price(good);     /* same body as func_030590 */
}

#endif /* _VICEROY_MODERN */
