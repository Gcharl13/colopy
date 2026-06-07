; ============================================================================
; func_0452D4_unknown
; Region   : overlay
; Bytes    : file 0x0452D4..0x045301  (45 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0452D4  C8 3C 00 00           ENTER  0x3c, 0 ; PROLOGUE
0452D8  56                    PUSH   si ; STACK_PUSH
0452D9  C7 46 E0 00 00        MOV    word ptr [bp - 0x20], 0 ; LOCAL_STORE
0452DE  2B C0                 SUB    ax, ax ; ARITH
0452E0  89 46 D8              MOV    word ptr [bp - 0x28], ax ; LOCAL_STORE
0452E3  89 46 D6              MOV    word ptr [bp - 0x2a], ax ; LOCAL_STORE
0452E6  C4 5E 06              LES    bx, ptr [bp + 6] ; MOV_FAR
0452E9  26 8B 47 12           MOV    ax, word ptr es:[bx + 0x12] ; MOV
0452ED  26 8B 57 14           MOV    dx, word ptr es:[bx + 0x14] ; MOV
0452F1  89 46 F2              MOV    word ptr [bp - 0xe], ax ; LOCAL_STORE
0452F4  89 56 F4              MOV    word ptr [bp - 0xc], dx ; LOCAL_STORE
0452F7  C7 46 F6 01 00        MOV    word ptr [bp - 0xa], 1 ; LOCAL_STORE
0452FC  BB 40 00              MOV    bx, 0x40 ; CONST_LOAD
0452FF  8E C3                 MOV    es, bx ; MOV
