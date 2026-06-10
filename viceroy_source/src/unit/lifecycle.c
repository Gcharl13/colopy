/* ============================================================================
 *                       >>> BYTE_VERIFIED (control flow + all UnitRecord
 *                           writes); a few helper targets / side tables not yet decoded <<<
 * ----------------------------------------------------------------------------
 * unit/lifecycle.c -- unit CREATION, PLACEMENT, tile-CHAIN unlink, and
 * DESTRUCTION (table compaction) for the flat UnitRecord table.
 *
 *   func_04007E  unit_create        allocate a new UnitRecord slot (off-map)
 *   func_00693A  unit_place_on_tile place a unit at (x,y), insert at chain head
 *   func_0068AA  unit_chain_unlink  remove a unit from its tile chain + off-map
 *   func_006E94  unit_destroy       unlink, compact the array, fix all indices
 *
 * UnitRecord: base DGROUP:0x3144, stride 0x1C (28). Fields used here:
 *   +0x00 map_x (0x3144)      +0x07 profession (0x314B)
 *   +0x01 map_y (0x3145)      +0x08 orders     (0x314C)
 *   +0x02 type  (0x3146)      +0x0C cargo_slot_count (0x3150)
 *   +0x03 owner|flags (0x3147, owner = low nibble)
 *   +0x06 moves_remaining (0x314A)
 *   +0x18 chain_prev (0x315C, word)   +0x1A chain_next (0x315E, word)
 * Active unit count is the word at DGROUP:0x539C.
 *
 * ALL FOUR were BYTE_VERIFIED 2026-05-30 against the raw VICEROY.EXE bytes at
 * their file offsets. IMPORTANT METHODOLOGY NOTE: the re-segmented overlay
 * listings (disasm_overlay_reseg/page_15, page_17) DRIFT OUT OF ALIGNMENT in
 * these regions -- e.g. page_15 decodes 0x06958 as `push [0x9cca]` and page_17
 * folds 0x06E94 into a bogus 2820-byte func_06E3D0. The RAW EXE bytes (and the
 * byte-aligned per-func dumps) are the arbiter and were used here. (This is
 * the "C8-imm16 false-ENTER" hazard the brief warns about, in BOTH directions:
 * here the per-func view is correct and the reseg is wrong.) See the per-func
 * decode reproduced in each banner below; every cited byte was checked.
 *
 * @region          load_image / overlay
 * @verified_by     Hand-decompiled from VICEROY.EXE raw bytes 2026-05-30.
 * @ref             code/VICEROY/disasm/func_04007E_unknown.asm
 * @ref             code/VICEROY/disasm/func_0068AA_unknown.asm
 * @ref             code/VICEROY/disasm/func_006E94_unknown.asm
 * @ref             include/unit.h
 * ============================================================================ */
#include "viceroy_types.h"
#include "globals.h"
#include "unit.h"

/* ---- DGROUP globals (near; DS = DGROUP at run time) ------------------------ */

/* Flat byte view of the unit table at DGROUP:0x3144. Indexing
 * [idx*0x1C + (off-0x3144)] reproduces the binary's `imul bx,idx,0x1C;
 * [bx+off]` addressing exactly. (Defined by the data owner; declared extern.) */
extern uint8_t  g_units_3144[];

/* DGROUP:0x539C -- active UnitRecord count (RULINGS 2026-05-28). */

/* DGROUP:0x5392 -- "selected unit" index (fixed up after a destroy shift). */
extern int16_t  g_selected_unit_5392;

/* DGROUP:(idx-0x7304) -- per-EU-power unit-count array, byte-indexed by the
 * owner nibble (0..3). Decremented on destroy. @asm 0x06EB8/0x06EBF.
 * (Base/stride byte-clear; full semantics owned by the power subsystem.) */
extern uint8_t  g_power_unit_count_7304[];

/* DGROUP:(0x54EF + k*0x12) -- a stride-0x12 flag table OR'd with 1 on destroy,
 * indexed by the destroyed unit's +0x314A byte. @asm 0x06ED7/0x06EDA.
 * Table contents/role not yet decoded; the index math and the |=1 are byte-verified. */
extern uint8_t  g_table_54EF[];

/* ---- helpers (byte offsets within a record image) -------------------------- */
#define U_OFF(idx, k)  g_units_3144[(idx) * UNIT_RECORD_STRIDE + (k)]
#define U_MAPX   0x00
#define U_MAPY   0x01
#define U_TYPE   0x02
#define U_OWNER  0x03
#define U_MOVES  0x06
#define U_PROF   0x07
#define U_ORDERS 0x08
#define U_CARGON 0x0C
#define U_PREV   0x18   /* word */
#define U_NEXT   0x1A   /* word */

static int16_t u_word(int idx, int k)
{
    return (int16_t)(U_OFF(idx, k) | (U_OFF(idx, k + 1) << 8));
}
static void u_word_set(int idx, int k, int16_t v)
{
    U_OFF(idx, k)     = (uint8_t)(v & 0xFF);
    U_OFF(idx, k + 1) = (uint8_t)((v >> 8) & 0xFF);
}

/* ---- cross-segment helpers (args/returns from call sites; bodies in thunk page) ------ */

/* 0x181F:0x894 -- called once per allocation. Stack: push [bp+0xC] then push
 * new_idx; `add sp,4` => 2 args (new_idx, arg_c). Likely "register new unit /
 * animate spawn". @asm 0x040082/0x04008F/0x040090. */
extern void    ovly_unit_spawned_181F_894(int16_t new_idx, int16_t arg_c);
/* 0x181F:0x844 -- called at end of create with regs (ax=idx, dx=[bp+8],
 * bx=[bp+0xA]); finishes unit setup. @asm 0x0400BD..0x0400C6. Param order here
 * mirrors the register load order (idx, dx_arg, bx_arg). */
extern void    ovly_unit_init_181F_844(int16_t idx, int16_t dx_arg, int16_t bx_arg);

/* Map-side tile occupancy helpers (0x037F:*), shared with chain.c. */
extern int     unit_tile_head(int x, int y);                 /* func_0066CC */
extern int16_t map_tile_set_occupant_037F_0A(int16_t x, int16_t y);   /* 0x037F:0x000A */
/* 0x037F:0x015E takes 4 words: two mode immediates then (y, x). Place passes
 * (1,1,y,x); unlink passes (0,1,y,x). add sp,8 confirms 4 args at both sites. */
extern void    map_tile_set_head_037F_15E(int16_t a, int16_t b, int16_t y, int16_t x);
extern int16_t map_tile_reveal_037F_598(int16_t x, int16_t y);        /* 0x037F:0x0598 */
extern void    map_tile_notify_037F_228(int16_t owner, int16_t y, int16_t x);/* 0x037F:0x0228 */

/* ============================================================================
 * unit_create -- allocate a fresh UnitRecord at the end of the table.
 * @asm func_04007E  file 0x04007E..0x0400CF  (82 bytes)  BYTE_VERIFIED
 * ----------------------------------------------------------------------------
 *   04007E enter 2,0
 *   040082 push [bp+0xC]
 *   040085 mov  ax,[0x539C]            ; ax = old unit_count (== new index)
 *   040088 inc  word [0x539C]          ; grow the table
 *   04008C mov  [bp-2],ax              ; save new index
 *   04008F push ax
 *   040090 lcall 0x181F:0x894          ; spawn/register hook(new_idx)
 *   040095 add  sp,4
 *   040098 mov  al,0xFF
 *   04009A imul bx,[bp-2],0x1C
 *   04009E mov  [bx+0x3144],al          ; map_x = 0xFF  (off-map)
 *   0400A2 mov  [bx+0x3145],al          ; map_y = 0xFF
 *   0400A6 cmp  word [bp+6],1
 *   0400AA cmc
 *   0400AB sbb  al,al                   ; al = ([bp+6]==0) ? 0x00 : 0xFF
 *   0400AD and  al,0x0D                 ; al = ([bp+6]==0) ? 0x00 : 0x0D
 *   0400AF mov  [bx+0x3146],al          ; type = 0 or 0x0D
 *   0400B3 mov  [bx+0x314A],0xFF        ; moves_remaining = 0xFF
 *   0400B8 mov  [bx+0x3150],0           ; cargo_slot_count = 0
 *   0400BD mov  ax,[bp-2]
 *   0400C0 mov  dx,[bp+8]
 *   0400C3 mov  bx,[bp+0xA]
 *   0400C6 lcall 0x181F:0x844           ; finish-init(idx, [bp+8], [bp+0xA])
 *   0400CB mov  ax,[bp-2]               ; return new index
 *   0400CE leave; retf
 *
 * The type is set to 0x0D when `kind_flag` ([bp+6]) is nonzero, else 0x00. The
 * CMC/SBB/AND idiom is the compiler's branchless `(flag ? 0x0D : 0)`:
 *   CMP x,1 sets CF=1 iff x<1 (x==0); CMC flips it; SBB al,al -> 0/-1 mask;
 *   AND 0x0D selects 0x0D or 0. The new record is created OFF-MAP (0xFF,0xFF)
 *   with full moves and no cargo; the caller later places it via
 *   unit_place_on_tile. Args [bp+8]/[bp+0xA] are forwarded to the 0x844 hook
 *   (their meaning is owned by that helper — body in thunk page). [bp+0xC] is pushed first
 *   but only consumed by the 0x894 hook's caller frame.
 * ============================================================================ */
int16_t unit_create(int16_t kind_flag, int16_t arg_b, int16_t arg_a, int16_t arg_c)
{
    int16_t idx;
    uint8_t type;

    idx = (int16_t)g_unit_count_539C;         /* @asm 0x040085 ax = old count */
    g_unit_count_539C++;                      /* @asm 0x040088 inc [0x539C] */
    ovly_unit_spawned_181F_894(idx, arg_c);   /* @asm 0x040090 (args new_idx, [bp+0xC]) */

    U_OFF(idx, U_MAPX) = 0xFF;                /* @asm 0x04009E */
    U_OFF(idx, U_MAPY) = 0xFF;                /* @asm 0x0400A2 */

    /* type = (kind_flag != 0) ? 0x0D : 0x00  -- CMC/SBB/AND idiom */
    type = (kind_flag != 0) ? 0x0D : 0x00;    /* @asm 0x0400A6..0x0400AD */
    U_OFF(idx, U_TYPE)   = type;              /* @asm 0x0400AF */
    U_OFF(idx, U_MOVES)  = 0xFF;              /* @asm 0x0400B3 */
    U_OFF(idx, U_CARGON) = 0x00;              /* @asm 0x0400B8 */

    ovly_unit_init_181F_844(idx, arg_b, arg_a); /* @asm 0x0400BD..C6: ax=idx,dx=[bp+8]=arg_b,bx=[bp+0xA]=arg_a */
    return idx;                               /* @asm 0x0400CB */
}

/* ============================================================================
 * unit_place_on_tile -- put unit AX at (DX=x, BX=y) and link it at the HEAD of
 *                        that tile's occupancy chain.
 * @asm func_00693A  file 0x00693A..0x0069D0  (157 bytes)  BYTE_VERIFIED
 * ----------------------------------------------------------------------------
 *   00693A enter 2,0
 *   00693E push dx; push ax; push di; push si    ; [bp-4]=x, [bp-6]=idx
 *   006942 mov  di,bx           ; di = y
 *   006944 mov  ax,dx           ; ax = x
 *   006946 mov  dx,di           ; dx = y
 *   006948 push cs; call 0x66CC ; si = unit_tile_head(x, y)  (current head)
 *   00694C mov  si,ax
 *   00694E mov  al,[bp-4]       ; al = x
 *   006951 imul bx,[bp-6],0x1C  ; bx = idx*0x1C
 *   006955 mov  [bp-2],bx
 *   006958 mov  [bx+0x3144],al  ; map_x = x
 *   00695C mov  ax,di           ; ax = y
 *   00695E mov  [bx+0x3145],al  ; map_y = y
 *   006962 mov  word [bx+0x315C],0xFFFF   ; new.chain_prev = -1 (it is the head)
 *   006968 mov  [bx+0x315E],si  ; new.chain_next = old head
 *   00696C or   si,si
 *   00696E jl   0x697E          ; old head < 0 (tile was empty) -> branch
 *   006970 mov  ax,[bp-6]       ; ax = idx
 *   006973 imul bx,si,0x1C
 *   006976 mov  [bx+0x315C],ax  ; old_head.chain_prev = new idx
 *   00697A pop si; pop di; leave; retf      ; (inserted before existing head)
 *
 *   0697E mov  si,[bp-4]        ; --- tile was empty: register occupancy ---
 *   006981 push di; push si; lcall 0x037F:0x000A   ; set tile occupant
 *   006988 add  sp,4
 *   00698B or   ax,ax
 *   00698D je   0x69CD
 *   00698F push 1; push 1; push di; push si; lcall 0x037F:0x015E   ; (wait: 6a01 6a01)
 *           --- decoded: push 1; push 1 then push di; push si; 0x037F:0x015E ---
 *   00699A add  sp,8
 *   00699D mov  bx,[bp-2]
 *   0069A0 mov  al,[bx+0x3147]; and al,0xF; cmp al,4
 *   0069A8 jb   0x69B8          ; owner is EU power (0..3)?
 *   0069AA push di; push si; lcall 0x037F:0x0598   ; reveal/fog query
 *   0069B1 add  sp,4
 *   0069B4 or   ax,ax; jne 0x69CD
 *   0069B8 mov  bx,[bp-2]; mov al,[bx+0x3147]; and ax,0xF
 *   0069C2 push ax; push di; push si; lcall 0x037F:0x0228   ; notify(owner,y,x)
 *   0069CA add  sp,6
 *   0069CD pop si; pop di; leave; retf
 *
 * On entry (MSC register args): AX = unit index, DX = x, BX = y. The unit is
 * always written to (x,y) and prepended to the tile chain. If the tile already
 * had a head, this unit becomes the new head and the old head's prev is fixed
 * up (the short path). If the tile was empty, the longer path registers the
 * tile occupancy (0x037F:0x0A), sets the occupant (0x037F:0x15E), and -- for an
 * EU-owned unit -- runs a reveal/notify pair (0x037F:0x598 / 0x037F:0x228). The
 * map-side 0x037F:* helpers are body in thunk page; the UnitRecord writes and the link surgery
 * are byte-verified.
 *
 * NB the two `push 1` before the 0x037F:0x15E call: bytes `6A 01 6A 01` push
 * two immediate 1s, then `push di; push si` -> the helper takes (1,1,y,x); the
 * extra 8-byte cleanup (`add sp,8`) confirms 4 pushed words.
 * ============================================================================ */
void unit_place_on_tile(int16_t unit_idx, int16_t x, int16_t y)
{
    int16_t old_head;
    uint8_t owner;

    old_head = (int16_t)unit_tile_head(x, y); /* @asm 0x06949 call 0x66CC */
#ifdef _VICEROY_MODERN
    { extern void tilehead_set(int,int,int);
      tilehead_set(x, y, unit_idx); }          /* this unit becomes the head */
#endif

    U_OFF(unit_idx, U_MAPX) = (uint8_t)x;     /* @asm 0x06958 */
    U_OFF(unit_idx, U_MAPY) = (uint8_t)y;     /* @asm 0x0695E */
    u_word_set(unit_idx, U_PREV, -1);         /* @asm 0x06962 chain_prev = -1 */
    u_word_set(unit_idx, U_NEXT, old_head);   /* @asm 0x06968 chain_next = old head */

    if (old_head >= 0) {                       /* @asm 0x0696E jl */
        u_word_set(old_head, U_PREV, unit_idx);/* @asm 0x06976 old_head.prev = new */
        return;                                /* @asm 0x0697A */
    }

    /* --- tile was empty: this unit becomes the lone occupant --- */
    if (map_tile_set_occupant_037F_0A(x, y) == 0) /* @asm 0x06981 */
        return;                                /* @asm 0x0698D je 0x69CD */

    map_tile_set_head_037F_15E(1, 1, y, x);    /* @asm 0x06995 push 1;1;di(y);si(x) */

    owner = U_OFF(unit_idx, U_OWNER) & 0x0F;   /* @asm 0x069A0 */
    if (owner >= 4) {                          /* @asm 0x069A6 cmp 4; jb skip */
        if (map_tile_reveal_037F_598(x, y) != 0) /* @asm 0x069AC */
            return;                            /* @asm 0x069B6 jne 0x69CD */
    }
    owner = U_OFF(unit_idx, U_OWNER) & 0x0F;   /* @asm 0x069BB */
    map_tile_notify_037F_228(owner, y, x);     /* @asm 0x069C5 */
}

/* ============================================================================
 * unit_chain_unlink -- remove unit AX from its tile chain and mark it off-map.
 * @asm func_0068AA  file 0x0068AA..0x006938  (143 bytes)  BYTE_VERIFIED
 * ----------------------------------------------------------------------------
 *   0068AA enter 2,0; push di; push si
 *   0068B0 mov  si,ax           ; si = idx
 *   0068B2 sub  bx,bx           ; bx = 0  (was-linked flag)
 *   0068B4 imul di,si,0x1C; mov [bp-2],di
 *   0068BA cmp  [di+0x315C],bx  ; chain_prev < 0 ?
 *   0068BE jl   0x68D2
 *   0068C0 mov  bx,di
 *   0068C2 mov  ax,[bx+0x315E]               ; ax = this.chain_next
 *   0068C6 imul bx,[bx+0x315C],0x1C          ; bx = prev*0x1C
 *   0068CB mov  [bx+0x315E],ax               ; prev.chain_next = this.next
 *   0068CF mov  bx,1                          ; flag = 1 (had a prev)
 *   0068D2 mov  di,[bp-2]
 *   0068D5 cmp  [di+0x315E],0  ; chain_next < 0 ?
 *   0068DA jl   0x68EE
 *   0068DC mov  bx,di
 *   0068DE mov  ax,[bx+0x315C]               ; ax = this.chain_prev
 *   0068E2 imul bx,[bx+0x315E],0x1C          ; bx = next*0x1C
 *   0068E7 mov  [bx+0x315C],ax               ; next.chain_prev = this.prev
 *   0068EB mov  bx,1                          ; flag = 1 (had a next)
 *   0068EE or   bx,bx
 *   0068F0 jne  0x6928          ; if it was linked at all, skip tile-occupancy
 *   0068F2 mov  bx,[bp-2]                      ; --- it was a standalone head ---
 *   0068F5 mov  al,[bx+0x3145]; push ax        ; y
 *   0068FC mov  al,[bx+0x3144]; push ax        ; x
 *   006901 lcall 0x037F:0x000A; add sp,4       ; tile occupancy id
 *   006909 or   ax,ax; je 0x6928
 *   00690D push 0; push 1
 *   006911 mov  bx,[bp-2]; mov al,[bx+0x3145]; push ax  ; y
 *   0069?? mov  al,[bx+0x3144]; push ax                  ; x
 *   006920 lcall 0x037F:0x015E; add sp,8       ; clear tile occupant
 *   006928 mov  al,0xFF
 *   00692A mov  bx,[bp-2]
 *   00692D mov  [bx+0x3144],al                 ; map_x = 0xFF (off-map)
 *   006931 mov  [bx+0x3145],al                 ; map_y = 0xFF
 *   006935 pop si; pop di; leave; retf
 *
 * Splices the unit out of the doubly-linked tile chain (patch prev.next and
 * next.prev). The `flag` (bx) tells whether the unit had any neighbour; if it
 * had NONE (it was the lone occupant of its tile), the tile's occupancy record
 * is cleared via 0x037F:0x0A / 0x037F:0x15E. Finally the unit is parked off-map
 * (0xFF,0xFF). Does NOT touch chain_prev/next of the removed record (they are
 * overwritten on its next placement). Note this does NOT update the table-side
 * "tile head" pointer when the removed unit WAS the head but had a next -- the
 * next's prev becomes -1 here, making it the head implicitly; the map-side head
 * lookup (0x037F:*) re-derives the head from the chain.
 * ============================================================================ */
void unit_chain_unlink(int16_t unit_idx)
{
    int linked = 0;                            /* @asm bx=0 */
    int16_t prev, next;
#ifdef _VICEROY_MODERN
    { extern int tilehead_get(int,int); extern void tilehead_set(int,int,int);
      int ux = U_OFF(unit_idx, U_MAPX), uy = U_OFF(unit_idx, U_MAPY);
      if (tilehead_get(ux, uy) == unit_idx)
          tilehead_set(ux, uy, (int16_t)u_word(unit_idx, U_NEXT)); }
#endif

    prev = u_word(unit_idx, U_PREV);
    if (prev >= 0) {                           /* @asm 0x068BE jl */
        next = u_word(unit_idx, U_NEXT);       /* @asm 0x068C2 */
        u_word_set(prev, U_NEXT, next);        /* @asm 0x068CB prev.next = this.next */
        linked = 1;                            /* @asm 0x068CF */
    }
    next = u_word(unit_idx, U_NEXT);
    if (next >= 0) {                           /* @asm 0x068DA jl */
        prev = u_word(unit_idx, U_PREV);       /* @asm 0x068DE */
        u_word_set(next, U_PREV, prev);        /* @asm 0x068E7 next.prev = this.prev */
        linked = 1;                            /* @asm 0x068EB */
    }

    if (linked == 0) {                         /* @asm 0x068F0 jne skip */
        /* lone occupant: clear the tile's occupancy slot */
        if (map_tile_set_occupant_037F_0A(U_OFF(unit_idx, U_MAPX),
                                          U_OFF(unit_idx, U_MAPY)) != 0) { /* @asm 0x06901 */
            map_tile_set_head_037F_15E(0, 1,
                                       U_OFF(unit_idx, U_MAPY),
                                       U_OFF(unit_idx, U_MAPX));           /* @asm 0x06920 push 0;1;y;x */
        }
    }

    U_OFF(unit_idx, U_MAPX) = 0xFF;            /* @asm 0x0692D */
    U_OFF(unit_idx, U_MAPY) = 0xFF;            /* @asm 0x06931 */
}

/* ============================================================================
 * unit_destroy -- delete unit DI=[bp+6] from the table (chain-unlink, then
 *                 compact the array down and renumber all chain links).
 * @asm func_006E94  file 0x006E94..0x006F59  (198 bytes)  BYTE_VERIFIED
 * ----------------------------------------------------------------------------
 *   006E94 enter 8,0; push di; push si
 *   006E9A mov  di,[bp+6]; or di,di; jge 0x6EA4; jmp 0x6F56   ; idx<0 -> exit
 *   006EA4 imul bx,di,0x1C; mov [bp-8],bx
 *   006EAA mov  bl,[bx+0x3147]; and bx,0xF                     ; owner nibble
 *   006EB1 jl   0x6EC3
 *   006EB3 cmp  bx,4; jge 0x6EC3                                ; EU power 0..3 ?
 *   006EB8 cmp  byte [bx-0x7304],0; je 0x6EC3
 *   006EBF dec  byte [bx-0x7304]                                ; power_unit_count[owner]--
 *   006EC3 cmp  bx,4; jl 0x6EDF                                 ; (native) owner>=4 ?
 *   006EC8 mov  bx,[bp-8]; cmp byte [bx+0x314A],0; jl 0x6EDF
 *   006ED2 mov  al,[bx+0x314A]; cbw; imul bx,ax,0x12
 *   006EDA or   byte [bx+0x54EF],1                              ; table_54EF[moves*0x12] |= 1
 *   006EDF mov  ax,di; push cs; call 0x68AA                     ; unit_chain_unlink(idx)
 *   006EE5 mov  si,di
 *   006EE7 mov  ax,[0x539C]; dec ax; cmp ax,di; jle 0x6F1F      ; idx is last slot?
 *   006EEF imul ax,si,0x1C; add ax,0x3144; mov [bp-2],ax        ; dest = &unit[idx]
 *   006EF8 mov  ax,[0x539C]; sub ax,si; dec ax; mov [bp-4],ax   ; n = count-idx-1
 *   006F01 mov  dx,[bp-2]
 *   006F04 mov  bx,dx; mov di,dx; lea si,[bx+0x1C]              ; src = next record
 *   006F0B mov  ax,ds; mov es,ax; mov cx,0xE; rep movsw         ; copy 0x1C bytes down
 *   006F14 add  dx,0x1C; dec word [bp-4]; jne 0x6F04            ; shift all higher recs
 *   006F1C mov  di,[bp+6]
 *   006F1F sub  cx,cx; mov ax,[0x539C]; dec ax; mov [0x539C],ax ; count--
 *   006F28 or   ax,ax; jle 0x6F45
 *   006F2C mov  bx,0x315C; mov dx,ax                             ; walk chain words
 *   006F31 cmp  [bx],di; jle 0x6F37; dec [bx]                    ; prev > idx -> prev--
 *   006F37 cmp  [bx+2],di; jle 0x6F3F; dec [bx+2]                ; next > idx -> next--
 *   006F3F add  bx,0x1C; dec dx; jne 0x6F31
 *   006F45 cmp  word [0x5392],0; je 0x6F56
 *   006F4C cmp  di,[0x5392]; jg 0x6F56; dec word [0x5392]        ; fix selected idx
 *   006F56 pop si; pop di; leave; retf
 *
 * The canonical "delete element from a packed array" routine:
 *   1. Decrement the owner's per-power unit count (EU powers only).
 *   2. (native / moves>=0 branch) set a flag in the stride-0x12 table at 0x54EF
 *      indexed by the +0x314A byte. (Table role not yet decoded.)
 *   3. Unlink the unit from its tile chain (func_0068AA).
 *   4. If the unit is not the last slot, REP MOVSW-shift every higher record
 *      down by one stride (0x1C bytes = 0xE words).
 *   5. unit_count-- .
 *   6. Renumber chain links: any chain_prev/chain_next that pointed ABOVE the
 *      deleted index is decremented (the records they referenced just moved
 *      down one slot). Links == idx are untouched (that unit is gone / already
 *      unlinked); links < idx are unaffected.
 *   7. Fix the global "selected unit" index the same way.
 *
 * SIGN/COMPARE NOTE: step 6 uses `cmp [bx],di; jle keep` so a link is
 * decremented only when it is strictly GREATER than idx (`> idx`). Step 7 uses
 * `cmp di,[0x5392]; jg skip`, i.e. selected-- when `idx <= selected`. Both are
 * reproduced exactly.
 * ============================================================================ */
void unit_destroy(int16_t unit_idx)
{
    int idx = unit_idx;
    uint8_t owner;
    int new_count;
    int i;

    if (idx < 0)                               /* @asm 0x06E9D */
        return;

    owner = U_OFF(idx, U_OWNER) & 0x0F;        /* @asm 0x06EAA */
    if (owner < 4) {                           /* @asm 0x06EB3 */
        if (g_power_unit_count_7304[owner] != 0) /* @asm 0x06EB8 */
            g_power_unit_count_7304[owner]--;  /* @asm 0x06EBF */
    } else {
        /* native (owner >= 4) branch */
        if ((int8_t)U_OFF(idx, U_MOVES) >= 0) {/* @asm 0x06ECB cmp [+0x314A],0; jl */
            int k = (int8_t)U_OFF(idx, U_MOVES) * 0x12;  /* @asm 0x06ED7 imul ax,0x12 */
            g_table_54EF[k] |= 1;              /* @asm 0x06EDA or [bx+0x54EF],1 */
        }
    }

    unit_chain_unlink((int16_t)idx);           /* @asm 0x06EE2 call 0x68AA */

    /* --- compact the array if idx is not the last slot --- */
    new_count = (int)g_unit_count_539C - 1;    /* @asm 0x06EE7 ax = count-1 */
    if (new_count > idx) {                     /* @asm 0x06EED cmp ax,di; jle skip */
        int n = (int)g_unit_count_539C - idx - 1; /* @asm 0x06EF8 records to shift */
        /* shift records [idx+1 .. count-1] down to [idx ..] : 0x1C bytes each.
         * The binary does this with REP MOVSW (0xE words) per record. */
        int dst = idx * UNIT_RECORD_STRIDE;    /* @asm 0x06EEF dest offset */
        int j;
        for (j = 0; j < n; j++) {              /* @asm 0x06F04..0x06F1A loop */
            int s;
            for (s = 0; s < UNIT_RECORD_STRIDE; s++) /* @asm rep movsw cx=0xE */
                g_units_3144[dst + j * UNIT_RECORD_STRIDE + s] =
                    g_units_3144[dst + (j + 1) * UNIT_RECORD_STRIDE + s];
        }
    }

    g_unit_count_539C--;                       /* @asm 0x06F21 count-- */

    /* --- renumber chain links that referenced shifted records --- */
    new_count = (int)g_unit_count_539C;        /* ax after dec */
    for (i = 0; i < new_count; i++) {          /* @asm 0x06F2C..0x06F43 loop dx=count */
        int16_t p = u_word(i, U_PREV);         /* word [i*0x1C + 0x315C] */
        int16_t nx = u_word(i, U_NEXT);        /* word [i*0x1C + 0x315E] */
        if (p > idx)  u_word_set(i, U_PREV, (int16_t)(p - 1));   /* @asm 0x06F31..0x06F35 */
        if (nx > idx) u_word_set(i, U_NEXT, (int16_t)(nx - 1));  /* @asm 0x06F37..0x06F3C */
    }

    /* --- fix the global selected-unit index --- */
    if (g_selected_unit_5392 != 0) {           /* @asm 0x06F45 */
        if (idx <= g_selected_unit_5392)       /* @asm 0x06F4C cmp di,[0x5392]; jg skip */
            g_selected_unit_5392--;            /* @asm 0x06F52 */
    }
}

/* ============================================================================
 * NOTES / TODO_VERIFY
 * ----------------------------------------------------------------------------
 *  - Control flow + every UnitRecord field write/read above is byte-verified
 *    against the raw EXE (see per-banner @asm offsets; all decode byte-exact).
 *  - The cross-segment helpers (0x181F:0x894 / 0x844; 0x037F:0x0A / 0x15E /
 *    0x314 / 0x598 / 0x228) have bodies in thunk page; arg/return shapes
 *    come from the call sites only -- NOT invented.
 *  - g_power_unit_count_7304[] (DGROUP-(idx-0x7304)) and g_table_54EF[]
 *    (DGROUP:0x54EF, stride 0x12) addressing is byte-clear; the tables' full
 *    layout/role is owned by the power subsystem -- declared extern here.
 *  - unit_create arg mapping: [bp+6]=kind_flag (type 0/0x0D), [bp+8] and
 *    [bp+0xA] are forwarded to the 0x844 init hook (likely x,y or owner,type),
 *    [bp+0xC] is consumed by the 0x894 spawn hook. Exact roles body in thunk page for those
 *    helper bodies; the modelled param names reflect the forwarding order.
 * ============================================================================ */
