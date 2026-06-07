; ============================================================================
; func_006DEE_unknown
; Region   : load_image
; Bytes    : file 0x006DEE..0x006E9A  (172 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

006DEE  55                    PUSH   bp ; STACK_PUSH
006DEF  8B EC                 MOV    bp, sp ; MOV
006DF1  83 EC 0E              SUB    sp, 0xe ; STACK_ALLOC
006DF4  57                    PUSH   di ; STACK_PUSH
006DF5  56                    PUSH   si ; STACK_PUSH
006DF6  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
006DF9  8B C6                 MOV    ax, si ; MOV
006DFB  2D FE 43              SUB    ax, 0x43fe ; ARITH
006DFE  05 9E 44              ADD    ax, 0x449e ; ARITH
006E01  89 46 F2              MOV    word ptr [bp - 0xe], ax ; LOCAL_STORE
006E04  8A 44 07              MOV    al, byte ptr [si + 7] ; MOV
006E07  2A E4                 SUB    ah, ah ; ARITH
006E09  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
006E0C  83 7C 02 00           CMP    word ptr [si + 2], 0 ; CMP
006E10  7D 05                 JGE    0x6e17 ; CJUMP
006E12  C7 44 02 00 00        MOV    word ptr [si + 2], 0 ; MOV
006E17  B8 01 00              MOV    ax, 1 ; MOV
006E1A  50                    PUSH   ax ; STACK_PUSH
006E1B  2B C0                 SUB    ax, ax ; ARITH
006E1D  50                    PUSH   ax ; STACK_PUSH
006E1E  50                    PUSH   ax ; STACK_PUSH
006E1F  FF 76 F6              PUSH   word ptr [bp - 0xa] ; PUSH_GLOBAL
006E22  9A EA 1A 52 04        LCALL  0x452, 0x1aea ; LCALL
006E27  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
006E2A  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
006E2D  89 56 FE              MOV    word ptr [bp - 2], dx ; LOCAL_STORE
006E30  0B D2                 OR     dx, dx ; LOGIC
006E32  7D 08                 JGE    0x6e3c ; CJUMP
006E34  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
006E37  99                    CDQ ; ARITH
006E38  E9 23 01              JMP    0x6f5e ; JUMP
006E3B  90                    NOP ; NOP
006E3C  F6 44 06 08           TEST   byte ptr [si + 6], 8 ; LOGIC
006E40  75 1E                 JNE    0x6e60 ; CJUMP
006E42  8B 5E F2              MOV    bx, word ptr [bp - 0xe] ; LOCAL_LOAD
006E45  F6 07 01              TEST   byte ptr [bx], 1 ; LOGIC
006E48  75 16                 JNE    0x6e60 ; CJUMP
006E4A  8B 44 02              MOV    ax, word ptr [si + 2] ; MOV
006E4D  99                    CDQ ; ARITH
006E4E  8B C8                 MOV    cx, ax ; MOV
006E50  8B DA                 MOV    bx, dx ; MOV
006E52  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
006E55  8B 56 FE              MOV    dx, word ptr [bp - 2] ; LOCAL_LOAD
006E58  2B C1                 SUB    ax, cx ; ARITH
006E5A  1B D3                 SBB    dx, bx ; ARITH
006E5C  E9 FF 00              JMP    0x6f5e ; JUMP
006E5F  90                    NOP ; NOP
006E60  8B 04                 MOV    ax, word ptr [si] ; MOV
006E62  2B 44 04              SUB    ax, word ptr [si + 4] ; ARITH
006E65  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
006E68  F6 44 06 03           TEST   byte ptr [si + 6], 3 ; LOGIC
006E6C  74 2E                 JE     0x6e9c ; CJUMP
006E6E  8B 5E F6              MOV    bx, word ptr [bp - 0xa] ; LOCAL_LOAD
006E71  F6 87 AF 42 80        TEST   byte ptr [bx + 0x42af], 0x80 ; LOGIC
006E76  74 13                 JE     0x6e8b ; CJUMP
006E78  8B 7C 04              MOV    di, word ptr [si + 4] ; MOV
006E7B  EB 0A                 JMP    0x6e87 ; JUMP
006E7D  90                    NOP ; NOP
006E7E  80 3D 0A              CMP    byte ptr [di], 0xa ; CMP
006E81  75 03                 JNE    0x6e86 ; CJUMP
006E83  FF 46 F8              INC    word ptr [bp - 8] ; ARITH
006E86  47                    INC    di ; ARITH
006E87  39 3C                 CMP    word ptr [si], di ; CMP
006E89  77 F3                 JA     0x6e7e ; CJUMP
006E8B  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
006E8E  0B 46 FC              OR     ax, word ptr [bp - 4] ; LOGIC
006E91  75 17                 JNE    0x6eaa ; CJUMP
006E93  8B 46 F8              MOV    ax, word ptr [bp - 8] ; LOCAL_LOAD
006E96  2B D2                 SUB    dx, dx ; ARITH
006E98  E9                    DB     0xE9 ; DATA_BYTE
006E99  C3                    DB     0xC3 ; DATA_BYTE
