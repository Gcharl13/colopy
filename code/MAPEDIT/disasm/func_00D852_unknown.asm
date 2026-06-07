; ============================================================================
; func_00D852_unknown
; Region   : load_image
; Bytes    : file 0x00D852..0x00D8FA  (168 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00D852  55                    PUSH   bp ; STACK_PUSH
00D853  8B EC                 MOV    bp, sp ; MOV
00D855  0B C0                 OR     ax, ax ; LOGIC
00D857  74 05                 JE     0xd85e ; CJUMP
00D859  9A 8A 03 65 0F        LCALL  0xf65, 0x38a ; LCALL
00D85E  A1 24 07              MOV    ax, word ptr [0x724] ; GLOBAL_LOAD
00D861  A3 34 07              MOV    word ptr [0x734], ax ; GLOBAL_LOAD
00D864  A1 26 07              MOV    ax, word ptr [0x726] ; GLOBAL_LOAD
00D867  A3 36 07              MOV    word ptr [0x736], ax ; GLOBAL_LOAD
00D86A  68 26 07              PUSH   0x726 ; PUSH_CONST
00D86D  68 24 07              PUSH   0x724 ; PUSH_CONST
00D870  9A 7C 05 65 0F        LCALL  0xf65, 0x57c ; LCALL
00D875  8B E5                 MOV    sp, bp ; MOV
00D877  A3 22 07              MOV    word ptr [0x722], ax ; GLOBAL_LOAD
00D87A  9A 06 00 18 0D        LCALL  0xd18, 6 ; LCALL
00D87F  A3 38 07              MOV    word ptr [0x738], ax ; GLOBAL_LOAD
00D882  89 16 3A 07           MOV    word ptr [0x73a], dx ; GLOBAL_LOAD
00D886  8B 1E 22 07           MOV    bx, word ptr [0x722] ; GLOBAL_LOAD
00D88A  83 3E 2E 07 00        CMP    word ptr [0x72e], 0 ; CMP
00D88F  74 0D                 JE     0xd89e ; CJUMP
00D891  0B DB                 OR     bx, bx ; LOGIC
00D893  75 09                 JNE    0xd89e ; CJUMP
00D895  C7 06 30 07 01 00     MOV    word ptr [0x730], 1 ; GLOBAL_LOAD
00D89B  EB 07                 JMP    0xd8a4 ; JUMP
00D89D  90                    NOP ; NOP
00D89E  C7 06 30 07 00 00     MOV    word ptr [0x730], 0 ; GLOBAL_LOAD
00D8A4  0B DB                 OR     bx, bx ; LOGIC
00D8A6  74 0C                 JE     0xd8b4 ; CJUMP
00D8A8  83 3E 2A 07 00        CMP    word ptr [0x72a], 0 ; CMP
00D8AD  75 05                 JNE    0xd8b4 ; CJUMP
00D8AF  BA 01 00              MOV    dx, 1 ; MOV
00D8B2  EB 02                 JMP    0xd8b6 ; JUMP
00D8B4  2B D2                 SUB    dx, dx ; ARITH
00D8B6  89 1E 2A 07           MOV    word ptr [0x72a], bx ; GLOBAL_LOAD
00D8BA  0B DB                 OR     bx, bx ; LOGIC
00D8BC  75 04                 JNE    0xd8c2 ; CJUMP
00D8BE  89 1E 2E 07           MOV    word ptr [0x72e], bx ; GLOBAL_LOAD
00D8C2  A1 24 07              MOV    ax, word ptr [0x724] ; GLOBAL_LOAD
00D8C5  39 06 34 07           CMP    word ptr [0x734], ax ; CMP
00D8C9  75 19                 JNE    0xd8e4 ; CJUMP
00D8CB  A1 26 07              MOV    ax, word ptr [0x726] ; GLOBAL_LOAD
00D8CE  39 06 36 07           CMP    word ptr [0x736], ax ; CMP
00D8D2  75 10                 JNE    0xd8e4 ; CJUMP
00D8D4  0B D2                 OR     dx, dx ; LOGIC
00D8D6  75 0C                 JNE    0xd8e4 ; CJUMP
00D8D8  39 16 30 07           CMP    word ptr [0x730], dx ; CMP
00D8DC  75 06                 JNE    0xd8e4 ; CJUMP
00D8DE  89 16 2C 07           MOV    word ptr [0x72c], dx ; GLOBAL_LOAD
00D8E2  EB 06                 JMP    0xd8ea ; JUMP
00D8E4  C7 06 2C 07 01 00     MOV    word ptr [0x72c], 1 ; GLOBAL_LOAD
00D8EA  89 16 28 07           MOV    word ptr [0x728], dx ; GLOBAL_LOAD
00D8EE  0B D2                 OR     dx, dx ; LOGIC
00D8F0  74 15                 JE     0xd907 ; CJUMP
00D8F2  C7 06 2E 07 FF FF     MOV    word ptr [0x72e], 0xffff ; GLOBAL_LOAD
00D8F8  8A C3                 MOV    al, bl ; MOV
