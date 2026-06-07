; ============================================================================
; func_006682_unknown
; Region   : load_image
; Bytes    : file 0x006682..0x0066CD  (75 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

006682  55                    PUSH   bp ; STACK_PUSH
006683  8B EC                 MOV    bp, sp ; MOV
006685  83 EC 02              SUB    sp, 2 ; STACK_ALLOC
006688  57                    PUSH   di ; STACK_PUSH
006689  56                    PUSH   si ; STACK_PUSH
00668A  BE FE 43              MOV    si, 0x43fe ; CONST_LOAD
00668D  2B FF                 SUB    di, di ; ARITH
00668F  89 7E FE              MOV    word ptr [bp - 2], di ; LOCAL_STORE
006692  EB 08                 JMP    0x669c ; JUMP
006694  C7 46 FE FF FF        MOV    word ptr [bp - 2], 0xffff ; LOCAL_STORE
006699  83 C6 08              ADD    si, 8 ; ARITH
00669C  39 36 3E 45           CMP    word ptr [0x453e], si ; CMP
0066A0  72 16                 JB     0x66b8 ; CJUMP
0066A2  F6 44 06 83           TEST   byte ptr [si + 6], 0x83 ; LOGIC
0066A6  74 F1                 JE     0x6699 ; CJUMP
0066A8  56                    PUSH   si ; STACK_PUSH
0066A9  9A E6 14 52 04        LCALL  0x452, 0x14e6 ; LCALL
0066AE  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
0066B1  40                    INC    ax ; ARITH
0066B2  74 E0                 JE     0x6694 ; CJUMP
0066B4  47                    INC    di ; ARITH
0066B5  EB E2                 JMP    0x6699 ; JUMP
0066B7  90                    NOP ; NOP
0066B8  83 7E 04 01           CMP    word ptr [bp + 4], 1 ; CMP
0066BC  75 04                 JNE    0x66c2 ; CJUMP
0066BE  8B C7                 MOV    ax, di ; MOV
0066C0  EB 03                 JMP    0x66c5 ; JUMP
0066C2  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
0066C5  5E                    POP    si ; STACK_POP
0066C6  5F                    POP    di ; STACK_POP
0066C7  8B E5                 MOV    sp, bp ; MOV
0066C9  5D                    POP    bp ; STACK_POP
0066CA  C2 02 00              RET    2 ; RETURN
