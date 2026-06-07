; ============================================================================
; func_0702C0_unknown
; Region   : overlay
; Bytes    : file 0x0702C0..0x0702D5  (21 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0702C0  C8 06 00 00           ENTER  6, 0 ; PROLOGUE
0702C4  56                    PUSH   si ; STACK_PUSH
0702C5  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
0702C8  40                    INC    ax ; ARITH
0702C9  B9 03 00              MOV    cx, 3 ; MOV
0702CC  8B D8                 MOV    bx, ax ; MOV
0702CE  99                    CDQ ; ARITH
0702CF  F7 F9                 IDIV   cx ; ARITH
0702D1  8B D0                 MOV    dx, ax ; MOV
0702D3  8B C3                 MOV    ax, bx ; MOV
