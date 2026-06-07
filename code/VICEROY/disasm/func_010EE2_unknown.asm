; ============================================================================
; func_010EE2_unknown
; Region   : load_image
; Bytes    : file 0x010EE2..0x010F2D  (75 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

010EE2  55                    PUSH   bp ; STACK_PUSH
010EE3  8B EC                 MOV    bp, sp ; MOV
010EE5  83 EC 02              SUB    sp, 2 ; STACK_ALLOC
010EE8  57                    PUSH   di ; STACK_PUSH
010EE9  56                    PUSH   si ; STACK_PUSH
010EEA  BE 0E 29              MOV    si, 0x290e ; CONST_LOAD
010EED  2B FF                 SUB    di, di ; ARITH
010EEF  89 7E FE              MOV    word ptr [bp - 2], di ; LOCAL_STORE
010EF2  EB 08                 JMP    0x10efc ; JUMP
010EF4  C7 46 FE FF FF        MOV    word ptr [bp - 2], 0xffff ; LOCAL_STORE
010EF9  83 C6 08              ADD    si, 8 ; ARITH
010EFC  39 36 4E 2A           CMP    word ptr [0x2a4e], si ; CMP
010F00  72 16                 JB     0x10f18 ; CJUMP
010F02  F6 44 06 83           TEST   byte ptr [si + 6], 0x83 ; LOGIC
010F06  74 F1                 JE     0x10ef9 ; CJUMP
010F08  56                    PUSH   si ; STACK_PUSH
010F09  9A 96 18 1D 0D        LCALL  0xd1d, 0x1896 ; LCALL
010F0E  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
010F11  40                    INC    ax ; ARITH
010F12  74 E0                 JE     0x10ef4 ; CJUMP
010F14  47                    INC    di ; ARITH
010F15  EB E2                 JMP    0x10ef9 ; JUMP
010F17  90                    NOP ; NOP
010F18  83 7E 04 01           CMP    word ptr [bp + 4], 1 ; CMP
010F1C  75 04                 JNE    0x10f22 ; CJUMP
010F1E  8B C7                 MOV    ax, di ; MOV
010F20  EB 03                 JMP    0x10f25 ; JUMP
010F22  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
010F25  5E                    POP    si ; STACK_POP
010F26  5F                    POP    di ; STACK_POP
010F27  8B E5                 MOV    sp, bp ; MOV
010F29  5D                    POP    bp ; STACK_POP
010F2A  C2 02 00              RET    2 ; RETURN
