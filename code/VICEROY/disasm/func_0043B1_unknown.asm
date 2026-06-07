; ============================================================================
; func_0043B1_unknown
; Region   : load_image
; Bytes    : file 0x0043B1..0x0043D9  (40 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0043B1  C8 25 03 00           ENTER  0x325, 0 ; PROLOGUE
0043B5  8B F8                 MOV    di, ax ; MOV
0043B7  83 FE 64              CMP    si, 0x64 ; CMP
0043BA  7D 16                 JGE    0x43d2 ; CJUMP
0043BC  8A 0E 84 01           MOV    cl, byte ptr [0x184] ; GLOBAL_LOAD
0043C0  B8 02 00              MOV    ax, 2 ; MOV
0043C3  D3 F8                 SAR    ax, cl ; LOGIC
0043C5  29 46 D6              SUB    word ptr [bp - 0x2a], ax ; ARITH
0043C8  8B 16 D4 5A           MOV    dx, word ptr [0x5ad4] ; GLOBAL_LOAD
0043CC  EB 07                 JMP    0x43d5 ; JUMP
0043CE  8B FE                 MOV    di, si ; MOV
0043D0  EB D9                 JMP    0x43ab ; JUMP
0043D2  BA 10 00              MOV    dx, 0x10 ; CONST_LOAD
0043D5  8B C2                 MOV    ax, dx ; MOV
0043D7  D1 FA                 SAR    dx, 1 ; LOGIC
