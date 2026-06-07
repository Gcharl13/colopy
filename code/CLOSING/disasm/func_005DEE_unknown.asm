; ============================================================================
; func_005DEE_unknown
; Region   : load_image
; Bytes    : file 0x005DEE..0x005E9A  (172 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

005DEE  55                    PUSH   bp ; STACK_PUSH
005DEF  8B EC                 MOV    bp, sp ; MOV
005DF1  83 EC 0E              SUB    sp, 0xe ; STACK_ALLOC
005DF4  57                    PUSH   di ; STACK_PUSH
005DF5  56                    PUSH   si ; STACK_PUSH
005DF6  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
005DF9  8B C6                 MOV    ax, si ; MOV
005DFB  2D A8 41              SUB    ax, 0x41a8 ; ARITH
005DFE  05 48 42              ADD    ax, 0x4248 ; ARITH
005E01  89 46 F2              MOV    word ptr [bp - 0xe], ax ; LOCAL_STORE
005E04  8A 44 07              MOV    al, byte ptr [si + 7] ; MOV
005E07  2A E4                 SUB    ah, ah ; ARITH
005E09  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
005E0C  83 7C 02 00           CMP    word ptr [si + 2], 0 ; CMP
005E10  7D 05                 JGE    0x5e17 ; CJUMP
005E12  C7 44 02 00 00        MOV    word ptr [si + 2], 0 ; MOV
005E17  B8 01 00              MOV    ax, 1 ; MOV
005E1A  50                    PUSH   ax ; STACK_PUSH
005E1B  2B C0                 SUB    ax, ax ; ARITH
005E1D  50                    PUSH   ax ; STACK_PUSH
005E1E  50                    PUSH   ax ; STACK_PUSH
005E1F  FF 76 F6              PUSH   word ptr [bp - 0xa] ; PUSH_GLOBAL
005E22  9A 3A 1A 7D 03        LCALL  0x37d, 0x1a3a ; LCALL
005E27  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
005E2A  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
005E2D  89 56 FE              MOV    word ptr [bp - 2], dx ; LOCAL_STORE
005E30  0B D2                 OR     dx, dx ; LOGIC
005E32  7D 08                 JGE    0x5e3c ; CJUMP
005E34  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
005E37  99                    CDQ ; ARITH
005E38  E9 23 01              JMP    0x5f5e ; JUMP
005E3B  90                    NOP ; NOP
005E3C  F6 44 06 08           TEST   byte ptr [si + 6], 8 ; LOGIC
005E40  75 1E                 JNE    0x5e60 ; CJUMP
005E42  8B 5E F2              MOV    bx, word ptr [bp - 0xe] ; LOCAL_LOAD
005E45  F6 07 01              TEST   byte ptr [bx], 1 ; LOGIC
005E48  75 16                 JNE    0x5e60 ; CJUMP
005E4A  8B 44 02              MOV    ax, word ptr [si + 2] ; MOV
005E4D  99                    CDQ ; ARITH
005E4E  8B C8                 MOV    cx, ax ; MOV
005E50  8B DA                 MOV    bx, dx ; MOV
005E52  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
005E55  8B 56 FE              MOV    dx, word ptr [bp - 2] ; LOCAL_LOAD
005E58  2B C1                 SUB    ax, cx ; ARITH
005E5A  1B D3                 SBB    dx, bx ; ARITH
005E5C  E9 FF 00              JMP    0x5f5e ; JUMP
005E5F  90                    NOP ; NOP
005E60  8B 04                 MOV    ax, word ptr [si] ; MOV
005E62  2B 44 04              SUB    ax, word ptr [si + 4] ; ARITH
005E65  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
005E68  F6 44 06 03           TEST   byte ptr [si + 6], 3 ; LOGIC
005E6C  74 2E                 JE     0x5e9c ; CJUMP
005E6E  8B 5E F6              MOV    bx, word ptr [bp - 0xa] ; LOCAL_LOAD
005E71  F6 87 59 40 80        TEST   byte ptr [bx + 0x4059], 0x80 ; LOGIC
005E76  74 13                 JE     0x5e8b ; CJUMP
005E78  8B 7C 04              MOV    di, word ptr [si + 4] ; MOV
005E7B  EB 0A                 JMP    0x5e87 ; JUMP
005E7D  90                    NOP ; NOP
005E7E  80 3D 0A              CMP    byte ptr [di], 0xa ; CMP
005E81  75 03                 JNE    0x5e86 ; CJUMP
005E83  FF 46 F8              INC    word ptr [bp - 8] ; ARITH
005E86  47                    INC    di ; ARITH
005E87  39 3C                 CMP    word ptr [si], di ; CMP
005E89  77 F3                 JA     0x5e7e ; CJUMP
005E8B  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
005E8E  0B 46 FC              OR     ax, word ptr [bp - 4] ; LOGIC
005E91  75 17                 JNE    0x5eaa ; CJUMP
005E93  8B 46 F8              MOV    ax, word ptr [bp - 8] ; LOCAL_LOAD
005E96  2B D2                 SUB    dx, dx ; ARITH
005E98  E9                    DB     0xE9 ; DATA_BYTE
005E99  C3                    DB     0xC3 ; DATA_BYTE
