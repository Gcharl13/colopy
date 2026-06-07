; ============================================================================
; func_005682_unknown
; Region   : load_image
; Bytes    : file 0x005682..0x0056CD  (75 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

005682  55                    PUSH   bp ; STACK_PUSH
005683  8B EC                 MOV    bp, sp ; MOV
005685  83 EC 02              SUB    sp, 2 ; STACK_ALLOC
005688  57                    PUSH   di ; STACK_PUSH
005689  56                    PUSH   si ; STACK_PUSH
00568A  BE A8 41              MOV    si, 0x41a8 ; CONST_LOAD
00568D  2B FF                 SUB    di, di ; ARITH
00568F  89 7E FE              MOV    word ptr [bp - 2], di ; LOCAL_STORE
005692  EB 08                 JMP    0x569c ; JUMP
005694  C7 46 FE FF FF        MOV    word ptr [bp - 2], 0xffff ; LOCAL_STORE
005699  83 C6 08              ADD    si, 8 ; ARITH
00569C  39 36 E8 42           CMP    word ptr [0x42e8], si ; CMP
0056A0  72 16                 JB     0x56b8 ; CJUMP
0056A2  F6 44 06 83           TEST   byte ptr [si + 6], 0x83 ; LOGIC
0056A6  74 F1                 JE     0x5699 ; CJUMP
0056A8  56                    PUSH   si ; STACK_PUSH
0056A9  9A 36 14 7D 03        LCALL  0x37d, 0x1436 ; LCALL
0056AE  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
0056B1  40                    INC    ax ; ARITH
0056B2  74 E0                 JE     0x5694 ; CJUMP
0056B4  47                    INC    di ; ARITH
0056B5  EB E2                 JMP    0x5699 ; JUMP
0056B7  90                    NOP ; NOP
0056B8  83 7E 04 01           CMP    word ptr [bp + 4], 1 ; CMP
0056BC  75 04                 JNE    0x56c2 ; CJUMP
0056BE  8B C7                 MOV    ax, di ; MOV
0056C0  EB 03                 JMP    0x56c5 ; JUMP
0056C2  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
0056C5  5E                    POP    si ; STACK_POP
0056C6  5F                    POP    di ; STACK_POP
0056C7  8B E5                 MOV    sp, bp ; MOV
0056C9  5D                    POP    bp ; STACK_POP
0056CA  C2 02 00              RET    2 ; RETURN
