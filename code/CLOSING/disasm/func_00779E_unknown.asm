; ============================================================================
; func_00779E_unknown
; Region   : load_image
; Bytes    : file 0x00779E..0x007832  (148 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00779E  55                    PUSH   bp ; STACK_PUSH
00779F  8B EC                 MOV    bp, sp ; MOV
0077A1  57                    PUSH   di ; STACK_PUSH
0077A2  56                    PUSH   si ; STACK_PUSH
0077A3  C4 76 06              LES    si, ptr [bp + 6] ; MOV_FAR
0077A6  2B FF                 SUB    di, di ; ARITH
0077A8  26 39 3C              CMP    word ptr es:[si], di ; CMP
0077AB  74 75                 JE     0x7822 ; CJUMP
0077AD  26 80 7C 04 01        CMP    byte ptr es:[si + 4], 1 ; CMP
0077B2  74 58                 JE     0x780c ; CJUMP
0077B4  26 80 7C 04 02        CMP    byte ptr es:[si + 4], 2 ; CMP
0077B9  74 51                 JE     0x780c ; CJUMP
0077BB  26 39 7C 02           CMP    word ptr es:[si + 2], di ; CMP
0077BF  75 39                 JNE    0x77fa ; CJUMP
0077C1  26 FF 74 06           PUSH   word ptr es:[si + 6] ; STACK_PUSH
0077C5  8C C7                 MOV    di, es ; MOV
0077C7  9A C4 08 7D 03        LCALL  0x37d, 0x8c4 ; LCALL
0077CC  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
0077CF  8B C6                 MOV    ax, si ; MOV
0077D1  8B D7                 MOV    dx, di ; MOV
0077D3  05 1A 00              ADD    ax, 0x1a ; ARITH
0077D6  52                    PUSH   dx ; STACK_PUSH
0077D7  50                    PUSH   ax ; STACK_PUSH
0077D8  6A 00                 PUSH   0 ; STACK_PUSH
0077DA  6A 01                 PUSH   1 ; STACK_PUSH
0077DC  8E C7                 MOV    es, di ; MOV
0077DE  8B DE                 MOV    bx, si ; MOV
0077E0  26 8B 5F 06           MOV    bx, word ptr es:[bx + 6] ; MOV
0077E4  B8 B0 00              MOV    ax, 0xb0 ; CONST_LOAD
0077E7  99                    CDQ ; ARITH
0077E8  9A 0E 00 F5 07        LCALL  0x7f5, 0xe ; LCALL
0077ED  0B D0                 OR     dx, ax ; LOGIC
0077EF  75 07                 JNE    0x77f8 ; CJUMP
0077F1  BF 01 00              MOV    di, 1 ; MOV
0077F4  EB 04                 JMP    0x77fa ; JUMP
0077F6  90                    NOP ; NOP
0077F7  90                    NOP ; NOP
0077F8  2B FF                 SUB    di, di ; ARITH
0077FA  8E 46 08              MOV    es, word ptr [bp + 8] ; LOCAL_LOAD
0077FD  26 FF 74 06           PUSH   word ptr es:[si + 6] ; STACK_PUSH
007801  9A F4 03 7D 03        LCALL  0x37d, 0x3f4 ; LCALL
007806  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
007809  EB 17                 JMP    0x7822 ; JUMP
00780B  90                    NOP ; NOP
00780C  26 C7 44 10 FF FF     MOV    word ptr es:[si + 0x10], 0xffff ; CONST_LOAD
007812  26 C7 44 12 00 40     MOV    word ptr es:[si + 0x12], 0x4000 ; CONST_LOAD
007818  2B C0                 SUB    ax, ax ; ARITH
00781A  26 89 44 0E           MOV    word ptr es:[si + 0xe], ax ; MOV
00781E  26 89 44 0C           MOV    word ptr es:[si + 0xc], ax ; MOV
007822  8E 46 08              MOV    es, word ptr [bp + 8] ; LOCAL_LOAD
007825  26 C7 04 00 00        MOV    word ptr es:[si], 0 ; MOV
00782A  8B C7                 MOV    ax, di ; MOV
00782C  5E                    POP    si ; STACK_POP
00782D  5F                    POP    di ; STACK_POP
00782E  C9                    LEAVE ; EPILOGUE
00782F  CA 04 00              RETF   4 ; RETURN
