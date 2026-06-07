; ============================================================================
; func_07464C_unknown
; Region   : overlay
; Bytes    : file 0x07464C..0x07465A  (14 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

07464C  55                    PUSH   bp ; STACK_PUSH
07464D  8B EC                 MOV    bp, sp ; MOV
07464F  53                    PUSH   bx ; STACK_PUSH
074650  56                    PUSH   si ; STACK_PUSH
074651  8B 4E 06              MOV    cx, word ptr [bp + 6] ; LOCAL_LOAD
074654  8B F0                 MOV    si, ax ; MOV
074656  8B C2                 MOV    ax, dx ; MOV
074658  8B D6                 MOV    dx, si ; MOV
