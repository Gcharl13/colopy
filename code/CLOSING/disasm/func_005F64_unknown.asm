; ============================================================================
; func_005F64_unknown
; Region   : load_image
; Bytes    : file 0x005F64..0x006023  (191 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

005F64  55                    PUSH   bp ; STACK_PUSH
005F65  8B EC                 MOV    bp, sp ; MOV
005F67  83 EC 02              SUB    sp, 2 ; STACK_ALLOC
005F6A  57                    PUSH   di ; STACK_PUSH
005F6B  56                    PUSH   si ; STACK_PUSH
005F6C  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
005F71  83 7E 0A 04           CMP    word ptr [bp + 0xa], 4 ; CMP
005F75  74 1F                 JE     0x5f96 ; CJUMP
005F77  83 7E 0C 00           CMP    word ptr [bp + 0xc], 0 ; CMP
005F7B  74 13                 JE     0x5f90 ; CJUMP
005F7D  81 7E 0C FF 7F        CMP    word ptr [bp + 0xc], 0x7fff ; CMP
005F82  77 0C                 JA     0x5f90 ; CJUMP
005F84  83 7E 0A 00           CMP    word ptr [bp + 0xa], 0 ; CMP
005F88  74 0C                 JE     0x5f96 ; CJUMP
005F8A  83 7E 0A 40           CMP    word ptr [bp + 0xa], 0x40 ; CMP
005F8E  74 06                 JE     0x5f96 ; CJUMP
005F90  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
005F93  E9 87 00              JMP    0x601d ; JUMP
005F96  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
005F99  8B FE                 MOV    di, si ; MOV
005F9B  81 EF A8 41           SUB    di, 0x41a8 ; ARITH
005F9F  81 C7 48 42           ADD    di, 0x4248 ; ARITH
005FA3  56                    PUSH   si ; STACK_PUSH
005FA4  9A 36 14 7D 03        LCALL  0x37d, 0x1436 ; LCALL
005FA9  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
005FAC  56                    PUSH   si ; STACK_PUSH
005FAD  E8 90 F4              CALL   0x5440 ; CALL_NEAR
005FB0  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
005FB3  F6 46 0A 04           TEST   byte ptr [bp + 0xa], 4 ; LOGIC
005FB7  74 15                 JE     0x5fce ; CJUMP
005FB9  80 4C 06 04           OR     byte ptr [si + 6], 4 ; LOGIC
005FBD  C6 05 00              MOV    byte ptr [di], 0 ; MOV
005FC0  8D 45 01              LEA    ax, [di + 1] ; ADDR
005FC3  89 46 08              MOV    word ptr [bp + 8], ax ; LOCAL_STORE
005FC6  C7 46 0C 01 00        MOV    word ptr [bp + 0xc], 1 ; LOCAL_STORE
005FCB  EB 3A                 JMP    0x6007 ; JUMP
005FCD  90                    NOP ; NOP
005FCE  83 7E 08 00           CMP    word ptr [bp + 8], 0 ; CMP
005FD2  75 28                 JNE    0x5ffc ; CJUMP
005FD4  FF 76 0C              PUSH   word ptr [bp + 0xc] ; PUSH_GLOBAL
005FD7  9A 8E 24 7D 03        LCALL  0x37d, 0x248e ; LCALL
005FDC  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
005FDF  89 46 08              MOV    word ptr [bp + 8], ax ; LOCAL_STORE
005FE2  0B C0                 OR     ax, ax ; LOGIC
005FE4  75 08                 JNE    0x5fee ; CJUMP
005FE6  C7 46 FE FF FF        MOV    word ptr [bp - 2], 0xffff ; LOCAL_STORE
005FEB  EB 2D                 JMP    0x601a ; JUMP
005FED  90                    NOP ; NOP
005FEE  80 64 06 FB           AND    byte ptr [si + 6], 0xfb ; LOGIC
005FF2  80 4C 06 08           OR     byte ptr [si + 6], 8 ; LOGIC
005FF6  C6 05 00              MOV    byte ptr [di], 0 ; MOV
005FF9  EB 0C                 JMP    0x6007 ; JUMP
005FFB  90                    NOP ; NOP
005FFC  FF 06 5A 43           INC    word ptr [0x435a] ; ARITH
006000  80 64 06 F3           AND    byte ptr [si + 6], 0xf3 ; LOGIC
006004  C6 05 01              MOV    byte ptr [di], 1 ; MOV
006007  8B 46 0C              MOV    ax, word ptr [bp + 0xc] ; LOCAL_LOAD
00600A  89 45 02              MOV    word ptr [di + 2], ax ; MOV
00600D  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
006010  89 44 04              MOV    word ptr [si + 4], ax ; MOV
006013  89 04                 MOV    word ptr [si], ax ; MOV
006015  C7 44 02 00 00        MOV    word ptr [si + 2], 0 ; MOV
00601A  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
00601D  5E                    POP    si ; STACK_POP
00601E  5F                    POP    di ; STACK_POP
00601F  8B E5                 MOV    sp, bp ; MOV
006021  5D                    POP    bp ; STACK_POP
006022  CB                    RETF ; RETURN
