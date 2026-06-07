; ============================================================================
; func_008790_unknown
; Region   : load_image
; Bytes    : file 0x008790..0x008824  (148 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

008790  55                    PUSH   bp ; STACK_PUSH
008791  8B EC                 MOV    bp, sp ; MOV
008793  57                    PUSH   di ; STACK_PUSH
008794  56                    PUSH   si ; STACK_PUSH
008795  C4 76 06              LES    si, ptr [bp + 6] ; MOV_FAR
008798  2B FF                 SUB    di, di ; ARITH
00879A  26 39 3C              CMP    word ptr es:[si], di ; CMP
00879D  74 75                 JE     0x8814 ; CJUMP
00879F  26 80 7C 04 01        CMP    byte ptr es:[si + 4], 1 ; CMP
0087A4  74 58                 JE     0x87fe ; CJUMP
0087A6  26 80 7C 04 02        CMP    byte ptr es:[si + 4], 2 ; CMP
0087AB  74 51                 JE     0x87fe ; CJUMP
0087AD  26 39 7C 02           CMP    word ptr es:[si + 2], di ; CMP
0087B1  75 39                 JNE    0x87ec ; CJUMP
0087B3  26 FF 74 06           PUSH   word ptr es:[si + 6] ; STACK_PUSH
0087B7  8C C7                 MOV    di, es ; MOV
0087B9  9A 38 09 52 04        LCALL  0x452, 0x938 ; LCALL
0087BE  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
0087C1  8B C6                 MOV    ax, si ; MOV
0087C3  8B D7                 MOV    dx, di ; MOV
0087C5  05 1A 00              ADD    ax, 0x1a ; ARITH
0087C8  52                    PUSH   dx ; STACK_PUSH
0087C9  50                    PUSH   ax ; STACK_PUSH
0087CA  6A 00                 PUSH   0 ; STACK_PUSH
0087CC  6A 01                 PUSH   1 ; STACK_PUSH
0087CE  8E C7                 MOV    es, di ; MOV
0087D0  8B DE                 MOV    bx, si ; MOV
0087D2  26 8B 5F 06           MOV    bx, word ptr es:[bx + 6] ; MOV
0087D6  B8 B0 00              MOV    ax, 0xb0 ; CONST_LOAD
0087D9  99                    CDQ ; ARITH
0087DA  9A 00 00 D5 08        LCALL  0x8d5, 0 ; LCALL
0087DF  0B D0                 OR     dx, ax ; LOGIC
0087E1  75 07                 JNE    0x87ea ; CJUMP
0087E3  BF 01 00              MOV    di, 1 ; MOV
0087E6  EB 04                 JMP    0x87ec ; JUMP
0087E8  90                    NOP ; NOP
0087E9  90                    NOP ; NOP
0087EA  2B FF                 SUB    di, di ; ARITH
0087EC  8E 46 08              MOV    es, word ptr [bp + 8] ; LOCAL_LOAD
0087EF  26 FF 74 06           PUSH   word ptr es:[si + 6] ; STACK_PUSH
0087F3  9A 68 04 52 04        LCALL  0x452, 0x468 ; LCALL
0087F8  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
0087FB  EB 17                 JMP    0x8814 ; JUMP
0087FD  90                    NOP ; NOP
0087FE  26 C7 44 10 FF FF     MOV    word ptr es:[si + 0x10], 0xffff ; CONST_LOAD
008804  26 C7 44 12 00 40     MOV    word ptr es:[si + 0x12], 0x4000 ; CONST_LOAD
00880A  2B C0                 SUB    ax, ax ; ARITH
00880C  26 89 44 0E           MOV    word ptr es:[si + 0xe], ax ; MOV
008810  26 89 44 0C           MOV    word ptr es:[si + 0xc], ax ; MOV
008814  8E 46 08              MOV    es, word ptr [bp + 8] ; LOCAL_LOAD
008817  26 C7 04 00 00        MOV    word ptr es:[si], 0 ; MOV
00881C  8B C7                 MOV    ax, di ; MOV
00881E  5E                    POP    si ; STACK_POP
00881F  5F                    POP    di ; STACK_POP
008820  C9                    LEAVE ; EPILOGUE
008821  CA 04 00              RETF   4 ; RETURN
