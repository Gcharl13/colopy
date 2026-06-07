; ============================================================================
; func_04497E_unknown
; Region   : overlay
; Bytes    : file 0x04497E..0x044999  (27 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04497E  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
044982  57                    PUSH   di ; STACK_PUSH
044983  56                    PUSH   si ; STACK_PUSH
044984  2B C9                 SUB    cx, cx ; ARITH
044986  2B C0                 SUB    ax, ax ; ARITH
044988  99                    CDQ ; ARITH
044989  8B F8                 MOV    di, ax ; MOV
04498B  89 56 FE              MOV    word ptr [bp - 2], dx ; LOCAL_STORE
04498E  C4 76 06              LES    si, ptr [bp + 6] ; MOV_FAR
044991  26 C5 5C 38           LDS    bx, ptr es:[si + 0x38] ; MOV_FAR
044995  8C D8                 MOV    ax, ds ; MOV
044997  0B C3                 OR     ax, bx ; LOGIC
