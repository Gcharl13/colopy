; ============================================================================
; func_0164CA_unknown
; Region   : load_image
; Bytes    : file 0x0164CA..0x016515  (75 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0164CA  55                    PUSH   bp ; STACK_PUSH
0164CB  8B EC                 MOV    bp, sp ; MOV
0164CD  83 EC 02              SUB    sp, 2 ; STACK_ALLOC
0164D0  57                    PUSH   di ; STACK_PUSH
0164D1  56                    PUSH   si ; STACK_PUSH
0164D2  BE C6 46              MOV    si, 0x46c6 ; CONST_LOAD
0164D5  2B FF                 SUB    di, di ; ARITH
0164D7  89 7E FE              MOV    word ptr [bp - 2], di ; LOCAL_STORE
0164DA  EB 08                 JMP    0x164e4 ; JUMP
0164DC  C7 46 FE FF FF        MOV    word ptr [bp - 2], 0xffff ; LOCAL_STORE
0164E1  83 C6 08              ADD    si, 8 ; ARITH
0164E4  39 36 06 48           CMP    word ptr [0x4806], si ; CMP
0164E8  72 16                 JB     0x16500 ; CJUMP
0164EA  F6 44 06 83           TEST   byte ptr [si + 6], 0x83 ; LOGIC
0164EE  74 F1                 JE     0x164e1 ; CJUMP
0164F0  56                    PUSH   si ; STACK_PUSH
0164F1  9A CE 15 88 13        LCALL  0x1388, 0x15ce ; LCALL
0164F6  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
0164F9  40                    INC    ax ; ARITH
0164FA  74 E0                 JE     0x164dc ; CJUMP
0164FC  47                    INC    di ; ARITH
0164FD  EB E2                 JMP    0x164e1 ; JUMP
0164FF  90                    NOP ; NOP
016500  83 7E 04 01           CMP    word ptr [bp + 4], 1 ; CMP
016504  75 04                 JNE    0x1650a ; CJUMP
016506  8B C7                 MOV    ax, di ; MOV
016508  EB 03                 JMP    0x1650d ; JUMP
01650A  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
01650D  5E                    POP    si ; STACK_POP
01650E  5F                    POP    di ; STACK_POP
01650F  8B E5                 MOV    sp, bp ; MOV
016511  5D                    POP    bp ; STACK_POP
016512  C2 02 00              RET    2 ; RETURN
