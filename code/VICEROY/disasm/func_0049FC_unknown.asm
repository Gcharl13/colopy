; ============================================================================
; func_0049FC_unknown
; Region   : load_image
; Bytes    : file 0x0049FC..0x004A10  (20 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0049FC  55                    PUSH   bp ; STACK_PUSH
0049FD  8B EC                 MOV    bp, sp ; MOV
0049FF  8B 4E 08              MOV    cx, word ptr [bp + 8] ; LOCAL_LOAD
004A02  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
004A05  2B D2                 SUB    dx, dx ; ARITH
004A07  8A C1                 MOV    al, cl ; MOV
004A09  FE C0                 INC    al ; ARITH
004A0B  25 07 00              AND    ax, 7 ; LOGIC
004A0E  3B C3                 CMP    ax, bx ; CMP
