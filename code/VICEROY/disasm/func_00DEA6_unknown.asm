; ============================================================================
; func_00DEA6_unknown
; Region   : load_image
; Bytes    : file 0x00DEA6..0x00DF3E  (152 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00DEA6  C8 0E 00 00           ENTER  0xe, 0 ; PROLOGUE
00DEAA  53                    PUSH   bx ; STACK_PUSH
00DEAB  52                    PUSH   dx ; STACK_PUSH
00DEAC  50                    PUSH   ax ; STACK_PUSH
00DEAD  57                    PUSH   di ; STACK_PUSH
00DEAE  56                    PUSH   si ; STACK_PUSH
00DEAF  8B 46 16              MOV    ax, word ptr [bp + 0x16] ; LOCAL_LOAD
00DEB2  2B 46 08              SUB    ax, word ptr [bp + 8] ; ARITH
00DEB5  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
00DEB8  8B 46 0E              MOV    ax, word ptr [bp + 0xe] ; LOCAL_LOAD
00DEBB  2B 46 08              SUB    ax, word ptr [bp + 8] ; ARITH
00DEBE  89 46 F2              MOV    word ptr [bp - 0xe], ax ; LOCAL_STORE
00DEC1  8B 46 1A              MOV    ax, word ptr [bp + 0x1a] ; LOCAL_LOAD
00DEC4  0B 46 18              OR     ax, word ptr [bp + 0x18] ; LOGIC
00DEC7  74 0F                 JE     0xded8 ; CJUMP
00DEC9  8B 46 12              MOV    ax, word ptr [bp + 0x12] ; LOCAL_LOAD
00DECC  0B 46 10              OR     ax, word ptr [bp + 0x10] ; LOGIC
00DECF  74 07                 JE     0xded8 ; CJUMP
00DED1  C7 46 F4 01 00        MOV    word ptr [bp - 0xc], 1 ; LOCAL_STORE
00DED6  EB 05                 JMP    0xdedd ; JUMP
00DED8  C7 46 F4 00 00        MOV    word ptr [bp - 0xc], 0 ; LOCAL_STORE
00DEDD  83 7E F4 00           CMP    word ptr [bp - 0xc], 0 ; CMP
00DEE1  75 03                 JNE    0xdee6 ; CJUMP
00DEE3  E9 AB 00              JMP    0xdf91 ; JUMP
00DEE6  8D 5E 14              LEA    bx, [bp + 0x14] ; ADDR
00DEE9  8B 46 EC              MOV    ax, word ptr [bp - 0x14] ; LOCAL_LOAD
00DEEC  8B 56 EE              MOV    dx, word ptr [bp - 0x12] ; LOCAL_LOAD
00DEEF  9A 08 00 4E 0A        LCALL  0xa4e, 8 ; LCALL
00DEF4  52                    PUSH   dx ; STACK_PUSH
00DEF5  50                    PUSH   ax ; STACK_PUSH
00DEF6  9A 04 00 05 0C        LCALL  0xc05, 4 ; LCALL
00DEFB  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
00DEFE  89 56 FE              MOV    word ptr [bp - 2], dx ; LOCAL_STORE
00DF01  8D 5E 0C              LEA    bx, [bp + 0xc] ; ADDR
00DF04  8B 46 F0              MOV    ax, word ptr [bp - 0x10] ; LOCAL_LOAD
00DF07  8B 56 0A              MOV    dx, word ptr [bp + 0xa] ; LOCAL_LOAD
00DF0A  9A 08 00 4E 0A        LCALL  0xa4e, 8 ; LCALL
00DF0F  52                    PUSH   dx ; STACK_PUSH
00DF10  50                    PUSH   ax ; STACK_PUSH
00DF11  9A 04 00 05 0C        LCALL  0xc05, 4 ; LCALL
00DF16  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
00DF19  89 56 FA              MOV    word ptr [bp - 6], dx ; LOCAL_STORE
00DF1C  1E                    PUSH   ds ; STACK_PUSH
00DF1D  C4 7E F8              LES    di, ptr [bp - 8] ; MOV_FAR
00DF20  C5 76 FC              LDS    si, ptr [bp - 4] ; MOV_FAR
00DF23  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
00DF26  0B C0                 OR     ax, ax ; LOGIC
00DF28  75 02                 JNE    0xdf2c ; CJUMP
00DF2A  EB 64                 JMP    0xdf90 ; JUMP
00DF2C  8B 56 08              MOV    dx, word ptr [bp + 8] ; LOCAL_LOAD
00DF2F  8B 5E F6              MOV    bx, word ptr [bp - 0xa] ; LOCAL_LOAD
00DF32  D1 EA                 SHR    dx, 1 ; LOGIC
00DF34  73 30                 JAE    0xdf66 ; CJUMP
00DF36  0B D2                 OR     dx, dx ; LOGIC
00DF38  74 04                 JE     0xdf3e ; CJUMP
00DF3A  8B CA                 MOV    cx, dx ; MOV
00DF3C  F3 A5                 REP MOVSW word ptr es:[di], word ptr [si] ; STR
