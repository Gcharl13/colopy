; ============================================================================
; func_016BB6_unknown
; Region   : load_image
; Bytes    : file 0x016BB6..0x016C6F  (185 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

016BB6  55                    PUSH   bp ; STACK_PUSH
016BB7  8B EC                 MOV    bp, sp ; MOV
016BB9  83 EC 08              SUB    sp, 8 ; STACK_ALLOC
016BBC  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
016BBF  3B 1E 75 45           CMP    bx, word ptr [0x4575] ; CMP
016BC3  72 07                 JB     0x16bcc ; CJUMP
016BC5  B8 00 09              MOV    ax, 0x900 ; CONST_LOAD
016BC8  F9                    STC ; FLAG
016BC9  E9 01 F5              JMP    0x160cd ; JUMP
016BCC  81 3E 96 48 D6 D6     CMP    word ptr [0x4896], 0xd6d6 ; CMP
016BD2  75 04                 JNE    0x16bd8 ; CJUMP
016BD4  FF 16 98 48           CALL   word ptr [0x4898] ; CALL_NEAR
016BD8  F6 87 77 45 20        TEST   byte ptr [bx + 0x4577], 0x20 ; LOGIC
016BDD  74 0B                 JE     0x16bea ; CJUMP
016BDF  B8 02 42              MOV    ax, 0x4202 ; CONST_LOAD
016BE2  33 C9                 XOR    cx, cx ; LOGIC
016BE4  8B D1                 MOV    dx, cx ; MOV
016BE6  CD 21                 INT    0x21 ; SYS
016BE8  72 DF                 JB     0x16bc9 ; CJUMP
016BEA  F6 87 77 45 80        TEST   byte ptr [bx + 0x4577], 0x80 ; LOGIC
016BEF  74 70                 JE     0x16c61 ; CJUMP
016BF1  8B 56 08              MOV    dx, word ptr [bp + 8] ; LOCAL_LOAD
016BF4  1E                    PUSH   ds ; STACK_PUSH
016BF5  07                    POP    es ; STACK_POP
016BF6  33 C0                 XOR    ax, ax ; LOGIC
016BF8  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
016BFB  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
016BFE  FC                    CLD ; FLAG
016BFF  57                    PUSH   di ; STACK_PUSH
016C00  56                    PUSH   si ; STACK_PUSH
016C01  8B FA                 MOV    di, dx ; MOV
016C03  8B F2                 MOV    si, dx ; MOV
016C05  89 66 F8              MOV    word ptr [bp - 8], sp ; LOCAL_STORE
016C08  8B 4E 0A              MOV    cx, word ptr [bp + 0xa] ; LOCAL_LOAD
016C0B  E3 3A                 JCXZ   0x16c47 ; CJUMP
016C0D  B0 0A                 MOV    al, 0xa ; CONST_LOAD
016C0F  F2 AE                 REPNE SCASB al, byte ptr es:[di] ; STR
016C11  75 4C                 JNE    0x16c5f ; CJUMP
016C13  9A DE 23 88 13        LCALL  0x1388, 0x23de ; LCALL
016C18  3D A8 00              CMP    ax, 0xa8 ; CMP
016C1B  76 46                 JBE    0x16c63 ; CJUMP
016C1D  83 EC 02              SUB    sp, 2 ; STACK_ALLOC
016C20  8B DC                 MOV    bx, sp ; MOV
016C22  BA 00 02              MOV    dx, 0x200 ; CONST_LOAD
016C25  3D 28 02              CMP    ax, 0x228 ; CMP
016C28  73 03                 JAE    0x16c2d ; CJUMP
016C2A  BA 80 00              MOV    dx, 0x80 ; CONST_LOAD
016C2D  2B E2                 SUB    sp, dx ; STACK_ALLOC
016C2F  8B D4                 MOV    dx, sp ; MOV
016C31  8B FA                 MOV    di, dx ; MOV
016C33  16                    PUSH   ss ; STACK_PUSH
016C34  07                    POP    es ; STACK_POP
016C35  8B 4E 0A              MOV    cx, word ptr [bp + 0xa] ; LOCAL_LOAD
016C38  AC                    LODSB  al, byte ptr [si] ; STR
016C39  3C 0A                 CMP    al, 0xa ; CMP
016C3B  74 0C                 JE     0x16c49 ; CJUMP
016C3D  3B FB                 CMP    di, bx ; CMP
016C3F  74 19                 JE     0x16c5a ; CJUMP
016C41  AA                    STOSB  byte ptr es:[di], al ; STR
016C42  E2 F4                 LOOP   0x16c38 ; CJUMP
016C44  E8 23 00              CALL   0x16c6a ; CALL_NEAR
016C47  EB 6B                 JMP    0x16cb4 ; JUMP
016C49  B0 0D                 MOV    al, 0xd ; CONST_LOAD
016C4B  3B FB                 CMP    di, bx ; CMP
016C4D  75 03                 JNE    0x16c52 ; CJUMP
016C4F  E8 18 00              CALL   0x16c6a ; CALL_NEAR
016C52  AA                    STOSB  byte ptr es:[di], al ; STR
016C53  B0 0A                 MOV    al, 0xa ; CONST_LOAD
016C55  FF 46 FC              INC    word ptr [bp - 4] ; ARITH
016C58  EB E3                 JMP    0x16c3d ; JUMP
016C5A  E8 0D 00              CALL   0x16c6a ; CALL_NEAR
016C5D  EB E2                 JMP    0x16c41 ; JUMP
016C5F  5E                    POP    si ; STACK_POP
016C60  5F                    POP    di ; STACK_POP
016C61  EB 5F                 JMP    0x16cc2 ; JUMP
016C63  B8 FC FF              MOV    ax, 0xfffc ; CONST_LOAD
016C66  0E                    PUSH   cs ; STACK_PUSH
016C67  E8 B4 E4              CALL   0x1511e ; CALL_NEAR
016C6A  50                    PUSH   ax ; STACK_PUSH
016C6B  53                    PUSH   bx ; STACK_PUSH
016C6C  51                    PUSH   cx ; STACK_PUSH
016C6D  8B CF                 MOV    cx, di ; MOV
