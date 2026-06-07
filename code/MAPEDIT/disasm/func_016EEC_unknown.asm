; ============================================================================
; func_016EEC_unknown
; Region   : load_image
; Bytes    : file 0x016EEC..0x016FAB  (191 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

016EEC  55                    PUSH   bp ; STACK_PUSH
016EED  8B EC                 MOV    bp, sp ; MOV
016EEF  83 EC 02              SUB    sp, 2 ; STACK_ALLOC
016EF2  57                    PUSH   di ; STACK_PUSH
016EF3  56                    PUSH   si ; STACK_PUSH
016EF4  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
016EF9  83 7E 0A 04           CMP    word ptr [bp + 0xa], 4 ; CMP
016EFD  74 1F                 JE     0x16f1e ; CJUMP
016EFF  83 7E 0C 00           CMP    word ptr [bp + 0xc], 0 ; CMP
016F03  74 13                 JE     0x16f18 ; CJUMP
016F05  81 7E 0C FF 7F        CMP    word ptr [bp + 0xc], 0x7fff ; CMP
016F0A  77 0C                 JA     0x16f18 ; CJUMP
016F0C  83 7E 0A 00           CMP    word ptr [bp + 0xa], 0 ; CMP
016F10  74 0C                 JE     0x16f1e ; CJUMP
016F12  83 7E 0A 40           CMP    word ptr [bp + 0xa], 0x40 ; CMP
016F16  74 06                 JE     0x16f1e ; CJUMP
016F18  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
016F1B  E9 87 00              JMP    0x16fa5 ; JUMP
016F1E  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
016F21  8B FE                 MOV    di, si ; MOV
016F23  81 EF C6 46           SUB    di, 0x46c6 ; ARITH
016F27  81 C7 66 47           ADD    di, 0x4766 ; ARITH
016F2B  56                    PUSH   si ; STACK_PUSH
016F2C  9A CE 15 88 13        LCALL  0x1388, 0x15ce ; LCALL
016F31  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
016F34  56                    PUSH   si ; STACK_PUSH
016F35  E8 50 F3              CALL   0x16288 ; CALL_NEAR
016F38  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
016F3B  F6 46 0A 04           TEST   byte ptr [bp + 0xa], 4 ; LOGIC
016F3F  74 15                 JE     0x16f56 ; CJUMP
016F41  80 4C 06 04           OR     byte ptr [si + 6], 4 ; LOGIC
016F45  C6 05 00              MOV    byte ptr [di], 0 ; MOV
016F48  8D 45 01              LEA    ax, [di + 1] ; ADDR
016F4B  89 46 08              MOV    word ptr [bp + 8], ax ; LOCAL_STORE
016F4E  C7 46 0C 01 00        MOV    word ptr [bp + 0xc], 1 ; LOCAL_STORE
016F53  EB 3A                 JMP    0x16f8f ; JUMP
016F55  90                    NOP ; NOP
016F56  83 7E 08 00           CMP    word ptr [bp + 8], 0 ; CMP
016F5A  75 28                 JNE    0x16f84 ; CJUMP
016F5C  FF 76 0C              PUSH   word ptr [bp + 0xc] ; PUSH_GLOBAL
016F5F  9A F2 23 88 13        LCALL  0x1388, 0x23f2 ; LCALL
016F64  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
016F67  89 46 08              MOV    word ptr [bp + 8], ax ; LOCAL_STORE
016F6A  0B C0                 OR     ax, ax ; LOGIC
016F6C  75 08                 JNE    0x16f76 ; CJUMP
016F6E  C7 46 FE FF FF        MOV    word ptr [bp - 2], 0xffff ; LOCAL_STORE
016F73  EB 2D                 JMP    0x16fa2 ; JUMP
016F75  90                    NOP ; NOP
016F76  80 64 06 FB           AND    byte ptr [si + 6], 0xfb ; LOGIC
016F7A  80 4C 06 08           OR     byte ptr [si + 6], 8 ; LOGIC
016F7E  C6 05 00              MOV    byte ptr [di], 0 ; MOV
016F81  EB 0C                 JMP    0x16f8f ; JUMP
016F83  90                    NOP ; NOP
016F84  FF 06 70 48           INC    word ptr [0x4870] ; ARITH
016F88  80 64 06 F3           AND    byte ptr [si + 6], 0xf3 ; LOGIC
016F8C  C6 05 01              MOV    byte ptr [di], 1 ; MOV
016F8F  8B 46 0C              MOV    ax, word ptr [bp + 0xc] ; LOCAL_LOAD
016F92  89 45 02              MOV    word ptr [di + 2], ax ; MOV
016F95  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
016F98  89 44 04              MOV    word ptr [si + 4], ax ; MOV
016F9B  89 04                 MOV    word ptr [si], ax ; MOV
016F9D  C7 44 02 00 00        MOV    word ptr [si + 2], 0 ; MOV
016FA2  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
016FA5  5E                    POP    si ; STACK_POP
016FA6  5F                    POP    di ; STACK_POP
016FA7  8B E5                 MOV    sp, bp ; MOV
016FA9  5D                    POP    bp ; STACK_POP
016FAA  CB                    RETF ; RETURN
