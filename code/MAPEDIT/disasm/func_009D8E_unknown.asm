; ============================================================================
; func_009D8E_unknown
; Region   : load_image
; Bytes    : file 0x009D8E..0x009DA2  (20 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

009D8E  55                    PUSH   bp ; STACK_PUSH
009D8F  8B EC                 MOV    bp, sp ; MOV
009D91  8B 4E 08              MOV    cx, word ptr [bp + 8] ; LOCAL_LOAD
009D94  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
009D97  2B D2                 SUB    dx, dx ; ARITH
009D99  8A C1                 MOV    al, cl ; MOV
009D9B  FE C0                 INC    al ; ARITH
009D9D  25 07 00              AND    ax, 7 ; LOGIC
009DA0  3B C3                 CMP    ax, bx ; CMP
