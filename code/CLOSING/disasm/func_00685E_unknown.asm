; ============================================================================
; func_00685E_unknown
; Region   : load_image
; Bytes    : file 0x00685E..0x00696F  (273 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00685E  55                    PUSH   bp ; STACK_PUSH
00685F  8B EC                 MOV    bp, sp ; MOV
006861  B8 08 00              MOV    ax, 8 ; MOV
006864  9A D0 03 7D 03        LCALL  0x37d, 0x3d0 ; LCALL
006869  57                    PUSH   di ; STACK_PUSH
00686A  56                    PUSH   si ; STACK_PUSH
00686B  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
00686E  B8 5C 00              MOV    ax, 0x5c ; CONST_LOAD
006871  50                    PUSH   ax ; STACK_PUSH
006872  56                    PUSH   si ; STACK_PUSH
006873  9A 3E 29 7D 03        LCALL  0x37d, 0x293e ; LCALL
006878  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
00687B  8B F8                 MOV    di, ax ; MOV
00687D  B8 2F 00              MOV    ax, 0x2f ; CONST_LOAD
006880  50                    PUSH   ax ; STACK_PUSH
006881  56                    PUSH   si ; STACK_PUSH
006882  9A 3E 29 7D 03        LCALL  0x37d, 0x293e ; LCALL
006887  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
00688A  0B C0                 OR     ax, ax ; LOGIC
00688C  75 08                 JNE    0x6896 ; CJUMP
00688E  0B FF                 OR     di, di ; LOGIC
006890  75 0E                 JNE    0x68a0 ; CJUMP
006892  8B FE                 MOV    di, si ; MOV
006894  EB 0A                 JMP    0x68a0 ; JUMP
006896  0B FF                 OR     di, di ; LOGIC
006898  74 04                 JE     0x689e ; CJUMP
00689A  3B C7                 CMP    ax, di ; CMP
00689C  76 02                 JBE    0x68a0 ; CJUMP
00689E  8B F8                 MOV    di, ax ; MOV
0068A0  B8 2E 00              MOV    ax, 0x2e ; CONST_LOAD
0068A3  50                    PUSH   ax ; STACK_PUSH
0068A4  57                    PUSH   di ; STACK_PUSH
0068A5  9A BA 09 7D 03        LCALL  0x37d, 0x9ba ; LCALL
0068AA  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0068AD  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
0068B0  0B C0                 OR     ax, ax ; LOGIC
0068B2  74 24                 JE     0x68d8 ; CJUMP
0068B4  FF 36 92 43           PUSH   word ptr [0x4392] ; PUSH_GLOBAL
0068B8  50                    PUSH   ax ; STACK_PUSH
0068B9  9A FC 28 7D 03        LCALL  0x37d, 0x28fc ; LCALL
0068BE  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0068C1  50                    PUSH   ax ; STACK_PUSH
0068C2  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
0068C5  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
0068C8  56                    PUSH   si ; STACK_PUSH
0068C9  9A FA 24 7D 03        LCALL  0x37d, 0x24fa ; LCALL
0068CE  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
0068D1  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
0068D4  E9 8F 00              JMP    0x6966 ; JUMP
0068D7  90                    NOP ; NOP
0068D8  56                    PUSH   si ; STACK_PUSH
0068D9  9A B0 06 7D 03        LCALL  0x37d, 0x6b0 ; LCALL
0068DE  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
0068E1  05 05 00              ADD    ax, 5 ; ARITH
0068E4  50                    PUSH   ax ; STACK_PUSH
0068E5  9A 8E 24 7D 03        LCALL  0x37d, 0x248e ; LCALL
0068EA  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
0068ED  8B F8                 MOV    di, ax ; MOV
0068EF  0B FF                 OR     di, di ; LOGIC
0068F1  75 05                 JNE    0x68f8 ; CJUMP
0068F3  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
0068F6  EB 71                 JMP    0x6969 ; JUMP
0068F8  56                    PUSH   si ; STACK_PUSH
0068F9  57                    PUSH   di ; STACK_PUSH
0068FA  9A 52 06 7D 03        LCALL  0x37d, 0x652 ; LCALL
0068FF  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
006902  56                    PUSH   si ; STACK_PUSH
006903  9A B0 06 7D 03        LCALL  0x37d, 0x6b0 ; LCALL
006908  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
00690B  03 C7                 ADD    ax, di ; ARITH
00690D  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
006910  C7 46 FA FF FF        MOV    word ptr [bp - 6], 0xffff ; LOCAL_STORE
006915  C7 46 F8 02 00        MOV    word ptr [bp - 8], 2 ; LOCAL_STORE
00691A  EB 03                 JMP    0x691f ; JUMP
00691C  FF 4E F8              DEC    word ptr [bp - 8] ; ARITH
00691F  83 7E F8 00           CMP    word ptr [bp - 8], 0 ; CMP
006923  7C 38                 JL     0x695d ; CJUMP
006925  8B 5E F8              MOV    bx, word ptr [bp - 8] ; LOCAL_LOAD
006928  D1 E3                 SHL    bx, 1 ; LOGIC
00692A  FF B7 92 43           PUSH   word ptr [bx + 0x4392] ; PUSH_GLOBAL
00692E  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
006931  9A 52 06 7D 03        LCALL  0x37d, 0x652 ; LCALL
006936  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
006939  2B C0                 SUB    ax, ax ; ARITH
00693B  50                    PUSH   ax ; STACK_PUSH
00693C  57                    PUSH   di ; STACK_PUSH
00693D  9A 66 2F 7D 03        LCALL  0x37d, 0x2f66 ; LCALL
006942  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
006945  40                    INC    ax ; ARITH
006946  74 D4                 JE     0x691c ; CJUMP
006948  FF 76 F8              PUSH   word ptr [bp - 8] ; STACK_PUSH
00694B  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
00694E  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
006951  57                    PUSH   di ; STACK_PUSH
006952  9A FA 24 7D 03        LCALL  0x37d, 0x24fa ; LCALL
006957  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
00695A  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
00695D  57                    PUSH   di ; STACK_PUSH
00695E  9A 94 24 7D 03        LCALL  0x37d, 0x2494 ; LCALL
006963  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
006966  8B 46 FA              MOV    ax, word ptr [bp - 6] ; LOCAL_LOAD
006969  5E                    POP    si ; STACK_POP
00696A  5F                    POP    di ; STACK_POP
00696B  8B E5                 MOV    sp, bp ; MOV
00696D  5D                    POP    bp ; STACK_POP
00696E  CB                    RETF ; RETURN
