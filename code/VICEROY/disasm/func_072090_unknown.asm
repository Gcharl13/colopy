; ============================================================================
; func_072090 — top_menu_bar_init  (BYTE_VERIFIED 2026-05-04)
; ----------------------------------------------------------------------------
; Initialises the top-of-screen menu bar (GAME / VIEW / ORDERS / REPORTS /
; TRADE / COLONIZOPEDIA). Pushes the menu position globals and an 0xFA0
; constant (= 4000, likely max-height/width or color), calls into the
; render-overlay function at 0x0000:0x02F6 to draw the bar.
;
; Globals:
;   [0x089E] word  menu_bar_x (or wood-tile origin)
;   [0x08A0] word  menu_bar_y
;
; Region : overlay
; Bytes  : file 0x072090..0x0720B7 (39 bytes)
; Strings: game, menu, orders, pedia, reports, trade, view (per
;          FUNCTION_INVENTORY.md classification)
; Status : BYTE_VERIFIED structural
; ============================================================================

072090  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
072094  57                    PUSH   di ; STACK_PUSH
072095  56                    PUSH   si ; STACK_PUSH
072096  BE 01 00              MOV    si, 1 ; MOV
072099  FF 36 A0 08           PUSH   word ptr [0x8a0] ; PUSH_GLOBAL
07209D  FF 36 9E 08           PUSH   word ptr [0x89e] ; PUSH_GLOBAL
0720A1  68 A0 0F              PUSH   0xfa0 ; PUSH_CONST
0720A4  9A D2 02 1F 1A        LCALL  0x1a1f, 0x2d2 ; THUNK -> 0x0000:0x02F6 (thunk @file 0x01C8C2 type A) overlay @file 0x025BF6
0720A9  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
0720AC  A3 96 08              MOV    word ptr [0x896], ax ; GLOBAL_LOAD
0720AF  89 16 98 08           MOV    word ptr [0x898], dx ; GLOBAL_LOAD
0720B3  8B C2                 MOV    ax, dx ; MOV
0720B5  0B                    DB     0x0B ; DATA_BYTE
0720B6  06                    DB     0x06 ; DATA_BYTE
