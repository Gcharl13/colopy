; ============================================================================
; func_00C51A_unknown
; Region   : load_image
; Bytes    : file 0x00C51A..0x00C5E7  (205 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00C51A  C8 0E 00 00           ENTER  0xe, 0 ; PROLOGUE
00C51E  57                    PUSH   di ; STACK_PUSH
00C51F  56                    PUSH   si ; STACK_PUSH
00C520  83 3E 72 03 00        CMP    word ptr [0x372], 0 ; CMP
00C525  75 03                 JNE    0xc52a ; CJUMP
00C527  E9 18 01              JMP    0xc642 ; JUMP
00C52A  A1 C0 92              MOV    ax, word ptr [0x92c0] ; GLOBAL_LOAD
00C52D  FF 06 74 03           INC    word ptr [0x374] ; ARITH
00C531  39 06 74 03           CMP    word ptr [0x374], ax ; CMP
00C535  7D 03                 JGE    0xc53a ; CJUMP
00C537  E9 08 01              JMP    0xc642 ; JUMP
00C53A  83 3E 08 08 00        CMP    word ptr [0x808], 0 ; CMP
00C53F  74 03                 JE     0xc544 ; CJUMP
00C541  E9 FE 00              JMP    0xc642 ; JUMP
00C544  9A 06 00 0C 0C        LCALL  0xc0c, 6 ; LCALL
00C549  89 46 F2              MOV    word ptr [bp - 0xe], ax ; LOCAL_STORE
00C54C  89 56 F4              MOV    word ptr [bp - 0xc], dx ; LOCAL_STORE
00C54F  2B C0                 SUB    ax, ax ; ARITH
00C551  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
00C554  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
00C557  E9 BA 00              JMP    0xc614 ; JUMP
00C55A  8B D8                 MOV    bx, ax ; MOV
00C55C  C1 E3 02              SHL    bx, 2 ; LOGIC
00C55F  8A 87 A3 92           MOV    al, byte ptr [bx - 0x6d5d] ; MOV
00C563  2A E4                 SUB    ah, ah ; ARITH
00C565  2B D2                 SUB    dx, dx ; ARITH
00C567  03 87 C4 92           ADD    ax, word ptr [bx - 0x6d3c] ; ARITH
00C56B  13 97 C6 92           ADC    dx, word ptr [bx - 0x6d3a] ; ARITH
00C56F  3B 56 F4              CMP    dx, word ptr [bp - 0xc] ; CMP
00C572  7E 03                 JLE    0xc577 ; CJUMP
00C574  E9 9A 00              JMP    0xc611 ; JUMP
00C577  7C 08                 JL     0xc581 ; CJUMP
00C579  3B 46 F2              CMP    ax, word ptr [bp - 0xe] ; CMP
00C57C  76 03                 JBE    0xc581 ; CJUMP
00C57E  E9 90 00              JMP    0xc611 ; JUMP
00C581  8B 46 F2              MOV    ax, word ptr [bp - 0xe] ; LOCAL_LOAD
00C584  8B 56 F4              MOV    dx, word ptr [bp - 0xc] ; LOCAL_LOAD
00C587  89 87 C4 92           MOV    word ptr [bx - 0x6d3c], ax ; MOV
00C58B  89 97 C6 92           MOV    word ptr [bx - 0x6d3a], dx ; MOV
00C58F  8A 87 A0 92           MOV    al, byte ptr [bx - 0x6d60] ; MOV
00C593  2A E4                 SUB    ah, ah ; ARITH
00C595  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
00C598  8A 8F A2 92           MOV    cl, byte ptr [bx - 0x6d5e] ; MOV
00C59C  2A ED                 SUB    ch, ch ; ARITH
00C59E  89 4E FA              MOV    word ptr [bp - 6], cx ; LOCAL_STORE
00C5A1  8A 8F A1 92           MOV    cl, byte ptr [bx - 0x6d5f] ; MOV
00C5A5  89 4E F6              MOV    word ptr [bp - 0xa], cx ; LOCAL_STORE
00C5A8  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1 ; LOCAL_STORE
00C5AD  3D 01 00              CMP    ax, 1 ; CMP
00C5B0  7E 52                 JLE    0xc604 ; CJUMP
00C5B2  FD                    STD ; FLAG
00C5B3  1E                    PUSH   ds ; STACK_PUSH
00C5B4  1E                    PUSH   ds ; STACK_PUSH
00C5B5  07                    POP    es ; STACK_POP
00C5B6  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
00C5B9  03 46 FA              ADD    ax, word ptr [bp - 6] ; ARITH
00C5BC  D1 E0                 SHL    ax, 1 ; LOGIC
00C5BE  03 46 FC              ADD    ax, word ptr [bp - 4] ; ARITH
00C5C1  03 46 FA              ADD    ax, word ptr [bp - 6] ; ARITH
00C5C4  8B 5E FC              MOV    bx, word ptr [bp - 4] ; LOCAL_LOAD
00C5C7  D1 E3                 SHL    bx, 1 ; LOGIC
00C5C9  03 5E FC              ADD    bx, word ptr [bp - 4] ; ARITH
00C5CC  BF 06 2D              MOV    di, 0x2d06 ; CONST_LOAD
00C5CF  83 C7 02              ADD    di, 2 ; ARITH
00C5D2  C5 36 6E 03           LDS    si, ptr [0x36e] ; MOV_FAR
00C5D6  03 F0                 ADD    si, ax ; ARITH
00C5D8  83 EE 01              SUB    si, 1 ; ARITH
00C5DB  57                    PUSH   di ; STACK_PUSH
00C5DC  56                    PUSH   si ; STACK_PUSH
00C5DD  B9 03 00              MOV    cx, 3 ; MOV
00C5E0  F3 A4                 REP MOVSB byte ptr es:[di], byte ptr [si] ; STR
00C5E2  5F                    POP    di ; STACK_POP
00C5E3  1E                    PUSH   ds ; STACK_PUSH
00C5E4  07                    POP    es ; STACK_POP
00C5E5  8B CB                 MOV    cx, bx ; MOV
