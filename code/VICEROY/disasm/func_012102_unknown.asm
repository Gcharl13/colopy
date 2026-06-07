; ============================================================================
; func_012102_unknown
; Region   : load_image
; Bytes    : file 0x012102..0x012213  (273 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

012102  55                    PUSH   bp ; STACK_PUSH
012103  8B EC                 MOV    bp, sp ; MOV
012105  B8 08 00              MOV    ax, 8 ; MOV
012108  9A D0 03 1D 0D        LCALL  0xd1d, 0x3d0 ; LCALL
01210D  57                    PUSH   di ; STACK_PUSH
01210E  56                    PUSH   si ; STACK_PUSH
01210F  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
012112  B8 5C 00              MOV    ax, 0x5c ; CONST_LOAD
012115  50                    PUSH   ax ; STACK_PUSH
012116  56                    PUSH   si ; STACK_PUSH
012117  9A 1A 0D 1D 0D        LCALL  0xd1d, 0xd1a ; LCALL
01211C  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
01211F  8B F8                 MOV    di, ax ; MOV
012121  B8 2F 00              MOV    ax, 0x2f ; CONST_LOAD
012124  50                    PUSH   ax ; STACK_PUSH
012125  56                    PUSH   si ; STACK_PUSH
012126  9A 1A 0D 1D 0D        LCALL  0xd1d, 0xd1a ; LCALL
01212B  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
01212E  0B C0                 OR     ax, ax ; LOGIC
012130  75 08                 JNE    0x1213a ; CJUMP
012132  0B FF                 OR     di, di ; LOGIC
012134  75 0E                 JNE    0x12144 ; CJUMP
012136  8B FE                 MOV    di, si ; MOV
012138  EB 0A                 JMP    0x12144 ; JUMP
01213A  0B FF                 OR     di, di ; LOGIC
01213C  74 04                 JE     0x12142 ; CJUMP
01213E  3B C7                 CMP    ax, di ; CMP
012140  76 02                 JBE    0x12144 ; CJUMP
012142  8B F8                 MOV    di, ax ; MOV
012144  B8 2E 00              MOV    ax, 0x2e ; CONST_LOAD
012147  50                    PUSH   ax ; STACK_PUSH
012148  57                    PUSH   di ; STACK_PUSH
012149  9A 56 0C 1D 0D        LCALL  0xd1d, 0xc56 ; LCALL
01214E  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
012151  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
012154  0B C0                 OR     ax, ax ; LOGIC
012156  74 24                 JE     0x1217c ; CJUMP
012158  FF 36 FA 2A           PUSH   word ptr [0x2afa] ; PUSH_GLOBAL
01215C  50                    PUSH   ax ; STACK_PUSH
01215D  9A 80 0C 1D 0D        LCALL  0xd1d, 0xc80 ; LCALL
012162  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
012165  50                    PUSH   ax ; STACK_PUSH
012166  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
012169  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
01216C  56                    PUSH   si ; STACK_PUSH
01216D  9A 9E 29 1D 0D        LCALL  0xd1d, 0x299e ; LCALL
012172  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
012175  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
012178  E9 8F 00              JMP    0x1220a ; JUMP
01217B  90                    NOP ; NOP
01217C  56                    PUSH   si ; STACK_PUSH
01217D  9A 42 08 1D 0D        LCALL  0xd1d, 0x842 ; LCALL
012182  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
012185  05 05 00              ADD    ax, 5 ; ARITH
012188  50                    PUSH   ax ; STACK_PUSH
012189  9A 16 29 1D 0D        LCALL  0xd1d, 0x2916 ; LCALL
01218E  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
012191  8B F8                 MOV    di, ax ; MOV
012193  0B FF                 OR     di, di ; LOGIC
012195  75 05                 JNE    0x1219c ; CJUMP
012197  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
01219A  EB 71                 JMP    0x1220d ; JUMP
01219C  56                    PUSH   si ; STACK_PUSH
01219D  57                    PUSH   di ; STACK_PUSH
01219E  9A E4 07 1D 0D        LCALL  0xd1d, 0x7e4 ; LCALL
0121A3  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0121A6  56                    PUSH   si ; STACK_PUSH
0121A7  9A 42 08 1D 0D        LCALL  0xd1d, 0x842 ; LCALL
0121AC  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
0121AF  03 C7                 ADD    ax, di ; ARITH
0121B1  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
0121B4  C7 46 FA FF FF        MOV    word ptr [bp - 6], 0xffff ; LOCAL_STORE
0121B9  C7 46 F8 02 00        MOV    word ptr [bp - 8], 2 ; LOCAL_STORE
0121BE  EB 03                 JMP    0x121c3 ; JUMP
0121C0  FF 4E F8              DEC    word ptr [bp - 8] ; ARITH
0121C3  83 7E F8 00           CMP    word ptr [bp - 8], 0 ; CMP
0121C7  7C 38                 JL     0x12201 ; CJUMP
0121C9  8B 5E F8              MOV    bx, word ptr [bp - 8] ; LOCAL_LOAD
0121CC  D1 E3                 SHL    bx, 1 ; LOGIC
0121CE  FF B7 FA 2A           PUSH   word ptr [bx + 0x2afa] ; PUSH_GLOBAL
0121D2  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
0121D5  9A E4 07 1D 0D        LCALL  0xd1d, 0x7e4 ; LCALL
0121DA  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0121DD  2B C0                 SUB    ax, ax ; ARITH
0121DF  50                    PUSH   ax ; STACK_PUSH
0121E0  57                    PUSH   di ; STACK_PUSH
0121E1  9A 8A 32 1D 0D        LCALL  0xd1d, 0x328a ; LCALL
0121E6  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0121E9  40                    INC    ax ; ARITH
0121EA  74 D4                 JE     0x121c0 ; CJUMP
0121EC  FF 76 F8              PUSH   word ptr [bp - 8] ; STACK_PUSH
0121EF  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
0121F2  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
0121F5  57                    PUSH   di ; STACK_PUSH
0121F6  9A 9E 29 1D 0D        LCALL  0xd1d, 0x299e ; LCALL
0121FB  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
0121FE  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
012201  57                    PUSH   di ; STACK_PUSH
012202  9A 1C 29 1D 0D        LCALL  0xd1d, 0x291c ; LCALL
012207  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
01220A  8B 46 FA              MOV    ax, word ptr [bp - 6] ; LOCAL_LOAD
01220D  5E                    POP    si ; STACK_POP
01220E  5F                    POP    di ; STACK_POP
01220F  8B E5                 MOV    sp, bp ; MOV
012211  5D                    POP    bp ; STACK_POP
012212  CB                    RETF ; RETURN
