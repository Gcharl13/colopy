; ============================================================================
; func_011860_unknown
; Region   : load_image
; Bytes    : file 0x011860..0x01190C  (172 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

011860  55                    PUSH   bp ; STACK_PUSH
011861  8B EC                 MOV    bp, sp ; MOV
011863  83 EC 0E              SUB    sp, 0xe ; STACK_ALLOC
011866  57                    PUSH   di ; STACK_PUSH
011867  56                    PUSH   si ; STACK_PUSH
011868  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
01186B  8B C6                 MOV    ax, si ; MOV
01186D  2D 0E 29              SUB    ax, 0x290e ; ARITH
011870  05 AE 29              ADD    ax, 0x29ae ; ARITH
011873  89 46 F2              MOV    word ptr [bp - 0xe], ax ; LOCAL_STORE
011876  8A 44 07              MOV    al, byte ptr [si + 7] ; MOV
011879  2A E4                 SUB    ah, ah ; ARITH
01187B  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
01187E  83 7C 02 00           CMP    word ptr [si + 2], 0 ; CMP
011882  7D 05                 JGE    0x11889 ; CJUMP
011884  C7 44 02 00 00        MOV    word ptr [si + 2], 0 ; MOV
011889  B8 01 00              MOV    ax, 1 ; MOV
01188C  50                    PUSH   ax ; STACK_PUSH
01188D  2B C0                 SUB    ax, ax ; ARITH
01188F  50                    PUSH   ax ; STACK_PUSH
011890  50                    PUSH   ax ; STACK_PUSH
011891  FF 76 F6              PUSH   word ptr [bp - 0xa] ; PUSH_GLOBAL
011894  9A 9A 1E 1D 0D        LCALL  0xd1d, 0x1e9a ; LCALL
011899  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
01189C  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
01189F  89 56 FE              MOV    word ptr [bp - 2], dx ; LOCAL_STORE
0118A2  0B D2                 OR     dx, dx ; LOGIC
0118A4  7D 08                 JGE    0x118ae ; CJUMP
0118A6  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
0118A9  99                    CDQ ; ARITH
0118AA  E9 23 01              JMP    0x119d0 ; JUMP
0118AD  90                    NOP ; NOP
0118AE  F6 44 06 08           TEST   byte ptr [si + 6], 8 ; LOGIC
0118B2  75 1E                 JNE    0x118d2 ; CJUMP
0118B4  8B 5E F2              MOV    bx, word ptr [bp - 0xe] ; LOCAL_LOAD
0118B7  F6 07 01              TEST   byte ptr [bx], 1 ; LOGIC
0118BA  75 16                 JNE    0x118d2 ; CJUMP
0118BC  8B 44 02              MOV    ax, word ptr [si + 2] ; MOV
0118BF  99                    CDQ ; ARITH
0118C0  8B C8                 MOV    cx, ax ; MOV
0118C2  8B DA                 MOV    bx, dx ; MOV
0118C4  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
0118C7  8B 56 FE              MOV    dx, word ptr [bp - 2] ; LOCAL_LOAD
0118CA  2B C1                 SUB    ax, cx ; ARITH
0118CC  1B D3                 SBB    dx, bx ; ARITH
0118CE  E9 FF 00              JMP    0x119d0 ; JUMP
0118D1  90                    NOP ; NOP
0118D2  8B 04                 MOV    ax, word ptr [si] ; MOV
0118D4  2B 44 04              SUB    ax, word ptr [si + 4] ; ARITH
0118D7  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
0118DA  F6 44 06 03           TEST   byte ptr [si + 6], 3 ; LOGIC
0118DE  74 2E                 JE     0x1190e ; CJUMP
0118E0  8B 5E F6              MOV    bx, word ptr [bp - 0xa] ; LOCAL_LOAD
0118E3  F6 87 BB 27 80        TEST   byte ptr [bx + 0x27bb], 0x80 ; LOGIC
0118E8  74 13                 JE     0x118fd ; CJUMP
0118EA  8B 7C 04              MOV    di, word ptr [si + 4] ; MOV
0118ED  EB 0A                 JMP    0x118f9 ; JUMP
0118EF  90                    NOP ; NOP
0118F0  80 3D 0A              CMP    byte ptr [di], 0xa ; CMP
0118F3  75 03                 JNE    0x118f8 ; CJUMP
0118F5  FF 46 F8              INC    word ptr [bp - 8] ; ARITH
0118F8  47                    INC    di ; ARITH
0118F9  39 3C                 CMP    word ptr [si], di ; CMP
0118FB  77 F3                 JA     0x118f0 ; CJUMP
0118FD  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
011900  0B 46 FC              OR     ax, word ptr [bp - 4] ; LOGIC
011903  75 17                 JNE    0x1191c ; CJUMP
011905  8B 46 F8              MOV    ax, word ptr [bp - 8] ; LOCAL_LOAD
011908  2B D2                 SUB    dx, dx ; ARITH
01190A  E9                    DB     0xE9 ; DATA_BYTE
01190B  C3                    DB     0xC3 ; DATA_BYTE
