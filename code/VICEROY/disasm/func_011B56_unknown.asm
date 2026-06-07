; ============================================================================
; func_011B56_unknown
; Region   : load_image
; Bytes    : file 0x011B56..0x011CAB  (341 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

011B56  55                    PUSH   bp ; STACK_PUSH
011B57  8B EC                 MOV    bp, sp ; MOV
011B59  83 EC 06              SUB    sp, 6 ; STACK_ALLOC
011B5C  57                    PUSH   di ; STACK_PUSH
011B5D  56                    PUSH   si ; STACK_PUSH
011B5E  C7 46 FC 00 00        MOV    word ptr [bp - 4], 0 ; LOCAL_STORE
011B63  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
011B66  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
011B69  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
011B6C  9A 32 2B 1D 0D        LCALL  0xd1d, 0x2b32 ; LCALL
011B71  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
011B74  83 3E AC 27 02        CMP    word ptr [0x27ac], 2 ; CMP
011B79  74 03                 JE     0x11b7e ; CJUMP
011B7B  E9 13 01              JMP    0x11c91 ; JUMP
011B7E  B8 5C 00              MOV    ax, 0x5c ; CONST_LOAD
011B81  50                    PUSH   ax ; STACK_PUSH
011B82  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
011B85  9A 56 0C 1D 0D        LCALL  0xd1d, 0xc56 ; LCALL
011B8A  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
011B8D  0B C0                 OR     ax, ax ; LOGIC
011B8F  74 03                 JE     0x11b94 ; CJUMP
011B91  E9 FD 00              JMP    0x11c91 ; JUMP
011B94  B8 2F 00              MOV    ax, 0x2f ; CONST_LOAD
011B97  50                    PUSH   ax ; STACK_PUSH
011B98  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
011B9B  9A 56 0C 1D 0D        LCALL  0xd1d, 0xc56 ; LCALL
011BA0  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
011BA3  0B C0                 OR     ax, ax ; LOGIC
011BA5  74 03                 JE     0x11baa ; CJUMP
011BA7  E9 E7 00              JMP    0x11c91 ; JUMP
011BAA  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
011BAD  80 3F 00              CMP    byte ptr [bx], 0 ; CMP
011BB0  74 09                 JE     0x11bbb ; CJUMP
011BB2  80 7F 01 3A           CMP    byte ptr [bx + 1], 0x3a ; CMP
011BB6  75 03                 JNE    0x11bbb ; CJUMP
011BB8  E9 D6 00              JMP    0x11c91 ; JUMP
011BBB  B8 BA 2A              MOV    ax, 0x2aba ; CONST_LOAD
011BBE  50                    PUSH   ax ; STACK_PUSH
011BBF  9A 42 09 1D 0D        LCALL  0xd1d, 0x942 ; LCALL
011BC4  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
011BC7  8B F0                 MOV    si, ax ; MOV
011BC9  0B F6                 OR     si, si ; LOGIC
011BCB  75 03                 JNE    0x11bd0 ; CJUMP
011BCD  E9 C1 00              JMP    0x11c91 ; JUMP
011BD0  B8 04 01              MOV    ax, 0x104 ; CONST_LOAD
011BD3  50                    PUSH   ax ; STACK_PUSH
011BD4  9A 16 29 1D 0D        LCALL  0xd1d, 0x2916 ; LCALL
011BD9  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
011BDC  8B F8                 MOV    di, ax ; MOV
011BDE  89 7E FC              MOV    word ptr [bp - 4], di ; LOCAL_STORE
011BE1  0B FF                 OR     di, di ; LOGIC
011BE3  75 03                 JNE    0x11be8 ; CJUMP
011BE5  E9 A9 00              JMP    0x11c91 ; JUMP
011BE8  EB 15                 JMP    0x11bff ; JUMP
011BEA  80 3C 3B              CMP    byte ptr [si], 0x3b ; CMP
011BED  74 15                 JE     0x11c04 ; CJUMP
011BEF  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
011BF2  05 02 01              ADD    ax, 0x102 ; ARITH
011BF5  3B C7                 CMP    ax, di ; CMP
011BF7  76 0B                 JBE    0x11c04 ; CJUMP
011BF9  8A 04                 MOV    al, byte ptr [si] ; MOV
011BFB  88 05                 MOV    byte ptr [di], al ; MOV
011BFD  46                    INC    si ; ARITH
011BFE  47                    INC    di ; ARITH
011BFF  80 3C 00              CMP    byte ptr [si], 0 ; CMP
011C02  75 E6                 JNE    0x11bea ; CJUMP
011C04  C6 05 00              MOV    byte ptr [di], 0 ; MOV
011C07  4F                    DEC    di ; ARITH
011C08  89 7E FE              MOV    word ptr [bp - 2], di ; LOCAL_STORE
011C0B  8B 7E FC              MOV    di, word ptr [bp - 4] ; LOCAL_LOAD
011C0E  8B 5E FE              MOV    bx, word ptr [bp - 2] ; LOCAL_LOAD
011C11  80 3F 5C              CMP    byte ptr [bx], 0x5c ; CMP
011C14  74 12                 JE     0x11c28 ; CJUMP
011C16  80 3F 2F              CMP    byte ptr [bx], 0x2f ; CMP
011C19  74 0D                 JE     0x11c28 ; CJUMP
011C1B  B8 BF 2A              MOV    ax, 0x2abf ; CONST_LOAD
011C1E  50                    PUSH   ax ; STACK_PUSH
011C1F  57                    PUSH   di ; STACK_PUSH
011C20  9A A4 07 1D 0D        LCALL  0xd1d, 0x7a4 ; LCALL
011C25  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
011C28  57                    PUSH   di ; STACK_PUSH
011C29  9A 42 08 1D 0D        LCALL  0xd1d, 0x842 ; LCALL
011C2E  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
011C31  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
011C34  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
011C37  9A 42 08 1D 0D        LCALL  0xd1d, 0x842 ; LCALL
011C3C  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
011C3F  03 46 FA              ADD    ax, word ptr [bp - 6] ; ARITH
011C42  3D 04 01              CMP    ax, 0x104 ; CMP
011C45  73 4A                 JAE    0x11c91 ; CJUMP
011C47  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
011C4A  57                    PUSH   di ; STACK_PUSH
011C4B  9A A4 07 1D 0D        LCALL  0xd1d, 0x7a4 ; LCALL
011C50  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
011C53  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
011C56  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
011C59  57                    PUSH   di ; STACK_PUSH
011C5A  9A 32 2B 1D 0D        LCALL  0xd1d, 0x2b32 ; LCALL
011C5F  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
011C62  83 3E AC 27 02        CMP    word ptr [0x27ac], 2 ; CMP
011C67  74 16                 JE     0x11c7f ; CJUMP
011C69  80 3D 5C              CMP    byte ptr [di], 0x5c ; CMP
011C6C  74 05                 JE     0x11c73 ; CJUMP
011C6E  80 3D 2F              CMP    byte ptr [di], 0x2f ; CMP
011C71  75 1E                 JNE    0x11c91 ; CJUMP
011C73  80 7D 01 5C           CMP    byte ptr [di + 1], 0x5c ; CMP
011C77  74 06                 JE     0x11c7f ; CJUMP
011C79  80 7D 01 2F           CMP    byte ptr [di + 1], 0x2f ; CMP
011C7D  75 12                 JNE    0x11c91 ; CJUMP
011C7F  80 3C 00              CMP    byte ptr [si], 0 ; CMP
011C82  74 0D                 JE     0x11c91 ; CJUMP
011C84  89 76 FA              MOV    word ptr [bp - 6], si ; LOCAL_STORE
011C87  46                    INC    si ; ARITH
011C88  83 7E FA 00           CMP    word ptr [bp - 6], 0 ; CMP
011C8C  74 03                 JE     0x11c91 ; CJUMP
011C8E  E9 6E FF              JMP    0x11bff ; JUMP
011C91  83 7E FC 00           CMP    word ptr [bp - 4], 0 ; CMP
011C95  74 0B                 JE     0x11ca2 ; CJUMP
011C97  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
011C9A  9A 1C 29 1D 0D        LCALL  0xd1d, 0x291c ; LCALL
011C9F  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
011CA2  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
011CA5  5E                    POP    si ; STACK_POP
011CA6  5F                    POP    di ; STACK_POP
011CA7  8B E5                 MOV    sp, bp ; MOV
011CA9  5D                    POP    bp ; STACK_POP
011CAA  CB                    RETF ; RETURN
