; ============================================================================
; func_016D76_unknown
; Region   : load_image
; Bytes    : file 0x016D76..0x016E22  (172 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

016D76  55                    PUSH   bp ; STACK_PUSH
016D77  8B EC                 MOV    bp, sp ; MOV
016D79  83 EC 0E              SUB    sp, 0xe ; STACK_ALLOC
016D7C  57                    PUSH   di ; STACK_PUSH
016D7D  56                    PUSH   si ; STACK_PUSH
016D7E  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
016D81  8B C6                 MOV    ax, si ; MOV
016D83  2D C6 46              SUB    ax, 0x46c6 ; ARITH
016D86  05 66 47              ADD    ax, 0x4766 ; ARITH
016D89  89 46 F2              MOV    word ptr [bp - 0xe], ax ; LOCAL_STORE
016D8C  8A 44 07              MOV    al, byte ptr [si + 7] ; MOV
016D8F  2A E4                 SUB    ah, ah ; ARITH
016D91  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
016D94  83 7C 02 00           CMP    word ptr [si + 2], 0 ; CMP
016D98  7D 05                 JGE    0x16d9f ; CJUMP
016D9A  C7 44 02 00 00        MOV    word ptr [si + 2], 0 ; MOV
016D9F  B8 01 00              MOV    ax, 1 ; MOV
016DA2  50                    PUSH   ax ; STACK_PUSH
016DA3  2B C0                 SUB    ax, ax ; ARITH
016DA5  50                    PUSH   ax ; STACK_PUSH
016DA6  50                    PUSH   ax ; STACK_PUSH
016DA7  FF 76 F6              PUSH   word ptr [bp - 0xa] ; PUSH_GLOBAL
016DAA  9A D2 1B 88 13        LCALL  0x1388, 0x1bd2 ; LCALL
016DAF  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
016DB2  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
016DB5  89 56 FE              MOV    word ptr [bp - 2], dx ; LOCAL_STORE
016DB8  0B D2                 OR     dx, dx ; LOGIC
016DBA  7D 08                 JGE    0x16dc4 ; CJUMP
016DBC  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
016DBF  99                    CDQ ; ARITH
016DC0  E9 23 01              JMP    0x16ee6 ; JUMP
016DC3  90                    NOP ; NOP
016DC4  F6 44 06 08           TEST   byte ptr [si + 6], 8 ; LOGIC
016DC8  75 1E                 JNE    0x16de8 ; CJUMP
016DCA  8B 5E F2              MOV    bx, word ptr [bp - 0xe] ; LOCAL_LOAD
016DCD  F6 07 01              TEST   byte ptr [bx], 1 ; LOGIC
016DD0  75 16                 JNE    0x16de8 ; CJUMP
016DD2  8B 44 02              MOV    ax, word ptr [si + 2] ; MOV
016DD5  99                    CDQ ; ARITH
016DD6  8B C8                 MOV    cx, ax ; MOV
016DD8  8B DA                 MOV    bx, dx ; MOV
016DDA  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
016DDD  8B 56 FE              MOV    dx, word ptr [bp - 2] ; LOCAL_LOAD
016DE0  2B C1                 SUB    ax, cx ; ARITH
016DE2  1B D3                 SBB    dx, bx ; ARITH
016DE4  E9 FF 00              JMP    0x16ee6 ; JUMP
016DE7  90                    NOP ; NOP
016DE8  8B 04                 MOV    ax, word ptr [si] ; MOV
016DEA  2B 44 04              SUB    ax, word ptr [si + 4] ; ARITH
016DED  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
016DF0  F6 44 06 03           TEST   byte ptr [si + 6], 3 ; LOGIC
016DF4  74 2E                 JE     0x16e24 ; CJUMP
016DF6  8B 5E F6              MOV    bx, word ptr [bp - 0xa] ; LOCAL_LOAD
016DF9  F6 87 77 45 80        TEST   byte ptr [bx + 0x4577], 0x80 ; LOGIC
016DFE  74 13                 JE     0x16e13 ; CJUMP
016E00  8B 7C 04              MOV    di, word ptr [si + 4] ; MOV
016E03  EB 0A                 JMP    0x16e0f ; JUMP
016E05  90                    NOP ; NOP
016E06  80 3D 0A              CMP    byte ptr [di], 0xa ; CMP
016E09  75 03                 JNE    0x16e0e ; CJUMP
016E0B  FF 46 F8              INC    word ptr [bp - 8] ; ARITH
016E0E  47                    INC    di ; ARITH
016E0F  39 3C                 CMP    word ptr [si], di ; CMP
016E11  77 F3                 JA     0x16e06 ; CJUMP
016E13  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
016E16  0B 46 FC              OR     ax, word ptr [bp - 4] ; LOGIC
016E19  75 17                 JNE    0x16e32 ; CJUMP
016E1B  8B 46 F8              MOV    ax, word ptr [bp - 8] ; LOCAL_LOAD
016E1E  2B D2                 SUB    dx, dx ; ARITH
016E20  E9                    DB     0xE9 ; DATA_BYTE
016E21  C3                    DB     0xC3 ; DATA_BYTE
