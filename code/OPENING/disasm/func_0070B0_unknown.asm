; ============================================================================
; func_0070B0_unknown
; Region   : load_image
; Bytes    : file 0x0070B0..0x007205  (341 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0070B0  55                    PUSH   bp ; STACK_PUSH
0070B1  8B EC                 MOV    bp, sp ; MOV
0070B3  83 EC 06              SUB    sp, 6 ; STACK_ALLOC
0070B6  57                    PUSH   di ; STACK_PUSH
0070B7  56                    PUSH   si ; STACK_PUSH
0070B8  C7 46 FC 00 00        MOV    word ptr [bp - 4], 0 ; LOCAL_STORE
0070BD  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
0070C0  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
0070C3  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
0070C6  9A 30 27 52 04        LCALL  0x452, 0x2730 ; LCALL
0070CB  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
0070CE  83 3E A0 42 02        CMP    word ptr [0x42a0], 2 ; CMP
0070D3  74 03                 JE     0x70d8 ; CJUMP
0070D5  E9 13 01              JMP    0x71eb ; JUMP
0070D8  B8 5C 00              MOV    ax, 0x5c ; CONST_LOAD
0070DB  50                    PUSH   ax ; STACK_PUSH
0070DC  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
0070DF  9A 2E 0A 52 04        LCALL  0x452, 0xa2e ; LCALL
0070E4  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0070E7  0B C0                 OR     ax, ax ; LOGIC
0070E9  74 03                 JE     0x70ee ; CJUMP
0070EB  E9 FD 00              JMP    0x71eb ; JUMP
0070EE  B8 2F 00              MOV    ax, 0x2f ; CONST_LOAD
0070F1  50                    PUSH   ax ; STACK_PUSH
0070F2  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
0070F5  9A 2E 0A 52 04        LCALL  0x452, 0xa2e ; LCALL
0070FA  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0070FD  0B C0                 OR     ax, ax ; LOGIC
0070FF  74 03                 JE     0x7104 ; CJUMP
007101  E9 E7 00              JMP    0x71eb ; JUMP
007104  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
007107  80 3F 00              CMP    byte ptr [bx], 0 ; CMP
00710A  74 09                 JE     0x7115 ; CJUMP
00710C  80 7F 01 3A           CMP    byte ptr [bx + 1], 0x3a ; CMP
007110  75 03                 JNE    0x7115 ; CJUMP
007112  E9 D6 00              JMP    0x71eb ; JUMP
007115  B8 A8 45              MOV    ax, 0x45a8 ; CONST_LOAD
007118  50                    PUSH   ax ; STACK_PUSH
007119  9A 3C 25 52 04        LCALL  0x452, 0x253c ; LCALL
00711E  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
007121  8B F0                 MOV    si, ax ; MOV
007123  0B F6                 OR     si, si ; LOGIC
007125  75 03                 JNE    0x712a ; CJUMP
007127  E9 C1 00              JMP    0x71eb ; JUMP
00712A  B8 04 01              MOV    ax, 0x104 ; CONST_LOAD
00712D  50                    PUSH   ax ; STACK_PUSH
00712E  9A 30 25 52 04        LCALL  0x452, 0x2530 ; LCALL
007133  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
007136  8B F8                 MOV    di, ax ; MOV
007138  89 7E FC              MOV    word ptr [bp - 4], di ; LOCAL_STORE
00713B  0B FF                 OR     di, di ; LOGIC
00713D  75 03                 JNE    0x7142 ; CJUMP
00713F  E9 A9 00              JMP    0x71eb ; JUMP
007142  EB 15                 JMP    0x7159 ; JUMP
007144  80 3C 3B              CMP    byte ptr [si], 0x3b ; CMP
007147  74 15                 JE     0x715e ; CJUMP
007149  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
00714C  05 02 01              ADD    ax, 0x102 ; ARITH
00714F  3B C7                 CMP    ax, di ; CMP
007151  76 0B                 JBE    0x715e ; CJUMP
007153  8A 04                 MOV    al, byte ptr [si] ; MOV
007155  88 05                 MOV    byte ptr [di], al ; MOV
007157  46                    INC    si ; ARITH
007158  47                    INC    di ; ARITH
007159  80 3C 00              CMP    byte ptr [si], 0 ; CMP
00715C  75 E6                 JNE    0x7144 ; CJUMP
00715E  C6 05 00              MOV    byte ptr [di], 0 ; MOV
007161  4F                    DEC    di ; ARITH
007162  89 7E FE              MOV    word ptr [bp - 2], di ; LOCAL_STORE
007165  8B 7E FC              MOV    di, word ptr [bp - 4] ; LOCAL_LOAD
007168  8B 5E FE              MOV    bx, word ptr [bp - 2] ; LOCAL_LOAD
00716B  80 3F 5C              CMP    byte ptr [bx], 0x5c ; CMP
00716E  74 12                 JE     0x7182 ; CJUMP
007170  80 3F 2F              CMP    byte ptr [bx], 0x2f ; CMP
007173  74 0D                 JE     0x7182 ; CJUMP
007175  B8 AD 45              MOV    ax, 0x45ad ; CONST_LOAD
007178  50                    PUSH   ax ; STACK_PUSH
007179  57                    PUSH   di ; STACK_PUSH
00717A  9A 86 06 52 04        LCALL  0x452, 0x686 ; LCALL
00717F  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
007182  57                    PUSH   di ; STACK_PUSH
007183  9A 24 07 52 04        LCALL  0x452, 0x724 ; LCALL
007188  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
00718B  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00718E  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
007191  9A 24 07 52 04        LCALL  0x452, 0x724 ; LCALL
007196  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
007199  03 46 FA              ADD    ax, word ptr [bp - 6] ; ARITH
00719C  3D 04 01              CMP    ax, 0x104 ; CMP
00719F  73 4A                 JAE    0x71eb ; CJUMP
0071A1  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
0071A4  57                    PUSH   di ; STACK_PUSH
0071A5  9A 86 06 52 04        LCALL  0x452, 0x686 ; LCALL
0071AA  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0071AD  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
0071B0  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
0071B3  57                    PUSH   di ; STACK_PUSH
0071B4  9A 30 27 52 04        LCALL  0x452, 0x2730 ; LCALL
0071B9  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
0071BC  83 3E A0 42 02        CMP    word ptr [0x42a0], 2 ; CMP
0071C1  74 16                 JE     0x71d9 ; CJUMP
0071C3  80 3D 5C              CMP    byte ptr [di], 0x5c ; CMP
0071C6  74 05                 JE     0x71cd ; CJUMP
0071C8  80 3D 2F              CMP    byte ptr [di], 0x2f ; CMP
0071CB  75 1E                 JNE    0x71eb ; CJUMP
0071CD  80 7D 01 5C           CMP    byte ptr [di + 1], 0x5c ; CMP
0071D1  74 06                 JE     0x71d9 ; CJUMP
0071D3  80 7D 01 2F           CMP    byte ptr [di + 1], 0x2f ; CMP
0071D7  75 12                 JNE    0x71eb ; CJUMP
0071D9  80 3C 00              CMP    byte ptr [si], 0 ; CMP
0071DC  74 0D                 JE     0x71eb ; CJUMP
0071DE  89 76 FA              MOV    word ptr [bp - 6], si ; LOCAL_STORE
0071E1  46                    INC    si ; ARITH
0071E2  83 7E FA 00           CMP    word ptr [bp - 6], 0 ; CMP
0071E6  74 03                 JE     0x71eb ; CJUMP
0071E8  E9 6E FF              JMP    0x7159 ; JUMP
0071EB  83 7E FC 00           CMP    word ptr [bp - 4], 0 ; CMP
0071EF  74 0B                 JE     0x71fc ; CJUMP
0071F1  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
0071F4  9A 36 25 52 04        LCALL  0x452, 0x2536 ; LCALL
0071F9  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
0071FC  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
0071FF  5E                    POP    si ; STACK_POP
007200  5F                    POP    di ; STACK_POP
007201  8B E5                 MOV    sp, bp ; MOV
007203  5D                    POP    bp ; STACK_POP
007204  CB                    RETF ; RETURN
