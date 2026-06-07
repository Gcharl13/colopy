; ============================================================================
; func_0063D5_unknown
; Region   : load_image
; Bytes    : file 0x0063D5..0x00641A  (69 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0063D5  C8 2D 05 00           ENTER  0x52d, 0 ; PROLOGUE
0063D9  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
0063DC  83 C1 05              ADD    cx, 5 ; ARITH
0063DF  3B C1                 CMP    ax, cx ; CMP
0063E1  7F 7F                 JG     0x6462 ; CJUMP
0063E3  8D 45 05              LEA    ax, [di + 5] ; ADDR
0063E6  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
0063E9  89 7E FC              MOV    word ptr [bp - 4], di ; LOCAL_STORE
0063EC  8B 76 FC              MOV    si, word ptr [bp - 4] ; LOCAL_LOAD
0063EF  83 EE 05              SUB    si, 5 ; ARITH
0063F2  3B 76 F8              CMP    si, word ptr [bp - 8] ; CMP
0063F5  7F 5D                 JG     0x6454 ; CJUMP
0063F7  8B 7E 08              MOV    di, word ptr [bp + 8] ; LOCAL_LOAD
0063FA  56                    PUSH   si ; STACK_PUSH
0063FB  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
0063FE  9A 0A 00 7F 03        LCALL  0x37f, 0xa ; LCALL
006403  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
006406  0B C0                 OR     ax, ax ; LOGIC
006408  74 44                 JE     0x644e ; CJUMP
00640A  56                    PUSH   si ; STACK_PUSH
00640B  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
00640E  9A E0 02 7F 03        LCALL  0x37f, 0x2e0 ; LCALL
006413  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
006416  8E C2                 MOV    es, dx ; MOV
006418  8B D8                 MOV    bx, ax ; MOV
