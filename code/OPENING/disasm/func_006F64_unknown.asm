; ============================================================================
; func_006F64_unknown
; Region   : load_image
; Bytes    : file 0x006F64..0x007023  (191 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

006F64  55                    PUSH   bp ; STACK_PUSH
006F65  8B EC                 MOV    bp, sp ; MOV
006F67  83 EC 02              SUB    sp, 2 ; STACK_ALLOC
006F6A  57                    PUSH   di ; STACK_PUSH
006F6B  56                    PUSH   si ; STACK_PUSH
006F6C  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
006F71  83 7E 0A 04           CMP    word ptr [bp + 0xa], 4 ; CMP
006F75  74 1F                 JE     0x6f96 ; CJUMP
006F77  83 7E 0C 00           CMP    word ptr [bp + 0xc], 0 ; CMP
006F7B  74 13                 JE     0x6f90 ; CJUMP
006F7D  81 7E 0C FF 7F        CMP    word ptr [bp + 0xc], 0x7fff ; CMP
006F82  77 0C                 JA     0x6f90 ; CJUMP
006F84  83 7E 0A 00           CMP    word ptr [bp + 0xa], 0 ; CMP
006F88  74 0C                 JE     0x6f96 ; CJUMP
006F8A  83 7E 0A 40           CMP    word ptr [bp + 0xa], 0x40 ; CMP
006F8E  74 06                 JE     0x6f96 ; CJUMP
006F90  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
006F93  E9 87 00              JMP    0x701d ; JUMP
006F96  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
006F99  8B FE                 MOV    di, si ; MOV
006F9B  81 EF FE 43           SUB    di, 0x43fe ; ARITH
006F9F  81 C7 9E 44           ADD    di, 0x449e ; ARITH
006FA3  56                    PUSH   si ; STACK_PUSH
006FA4  9A E6 14 52 04        LCALL  0x452, 0x14e6 ; LCALL
006FA9  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
006FAC  56                    PUSH   si ; STACK_PUSH
006FAD  E8 90 F4              CALL   0x6440 ; CALL_NEAR
006FB0  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
006FB3  F6 46 0A 04           TEST   byte ptr [bp + 0xa], 4 ; LOGIC
006FB7  74 15                 JE     0x6fce ; CJUMP
006FB9  80 4C 06 04           OR     byte ptr [si + 6], 4 ; LOGIC
006FBD  C6 05 00              MOV    byte ptr [di], 0 ; MOV
006FC0  8D 45 01              LEA    ax, [di + 1] ; ADDR
006FC3  89 46 08              MOV    word ptr [bp + 8], ax ; LOCAL_STORE
006FC6  C7 46 0C 01 00        MOV    word ptr [bp + 0xc], 1 ; LOCAL_STORE
006FCB  EB 3A                 JMP    0x7007 ; JUMP
006FCD  90                    NOP ; NOP
006FCE  83 7E 08 00           CMP    word ptr [bp + 8], 0 ; CMP
006FD2  75 28                 JNE    0x6ffc ; CJUMP
006FD4  FF 76 0C              PUSH   word ptr [bp + 0xc] ; PUSH_GLOBAL
006FD7  9A 30 25 52 04        LCALL  0x452, 0x2530 ; LCALL
006FDC  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
006FDF  89 46 08              MOV    word ptr [bp + 8], ax ; LOCAL_STORE
006FE2  0B C0                 OR     ax, ax ; LOGIC
006FE4  75 08                 JNE    0x6fee ; CJUMP
006FE6  C7 46 FE FF FF        MOV    word ptr [bp - 2], 0xffff ; LOCAL_STORE
006FEB  EB 2D                 JMP    0x701a ; JUMP
006FED  90                    NOP ; NOP
006FEE  80 64 06 FB           AND    byte ptr [si + 6], 0xfb ; LOGIC
006FF2  80 4C 06 08           OR     byte ptr [si + 6], 8 ; LOGIC
006FF6  C6 05 00              MOV    byte ptr [di], 0 ; MOV
006FF9  EB 0C                 JMP    0x7007 ; JUMP
006FFB  90                    NOP ; NOP
006FFC  FF 06 B0 45           INC    word ptr [0x45b0] ; ARITH
007000  80 64 06 F3           AND    byte ptr [si + 6], 0xf3 ; LOGIC
007004  C6 05 01              MOV    byte ptr [di], 1 ; MOV
007007  8B 46 0C              MOV    ax, word ptr [bp + 0xc] ; LOCAL_LOAD
00700A  89 45 02              MOV    word ptr [di + 2], ax ; MOV
00700D  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
007010  89 44 04              MOV    word ptr [si + 4], ax ; MOV
007013  89 04                 MOV    word ptr [si], ax ; MOV
007015  C7 44 02 00 00        MOV    word ptr [si + 2], 0 ; MOV
00701A  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
00701D  5E                    POP    si ; STACK_POP
00701E  5F                    POP    di ; STACK_POP
00701F  8B E5                 MOV    sp, bp ; MOV
007021  5D                    POP    bp ; STACK_POP
007022  CB                    RETF ; RETURN
