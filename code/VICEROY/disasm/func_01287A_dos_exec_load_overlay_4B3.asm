; ============================================================================
; func_01287A_unknown
; Region   : load_image
; Bytes    : file 0x01287A..0x012902  (136 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

01287A  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
01287E  06                    PUSH   es ; STACK_PUSH
01287F  1E                    PUSH   ds ; STACK_PUSH
012880  56                    PUSH   si ; STACK_PUSH
012881  57                    PUSH   di ; STACK_PUSH
012882  33 C0                 XOR    ax, ax ; LOGIC
012884  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
012887  BB FF FF              MOV    bx, 0xffff ; CONST_LOAD
01288A  B4 48                 MOV    ah, 0x48 ; CONST_LOAD
01288C  CD 21                 INT    0x21 ; SYS
01288E  72 03                 JB     0x12893 ; CJUMP
012890  E9 80 00              JMP    0x12913 ; JUMP
012893  83 EB 02              SUB    bx, 2 ; ARITH
012896  89 5E FE              MOV    word ptr [bp - 2], bx ; LOCAL_STORE
012899  B4 48                 MOV    ah, 0x48 ; CONST_LOAD
01289B  CD 21                 INT    0x21 ; SYS
01289D  73 03                 JAE    0x128a2 ; CJUMP
01289F  EB 7F                 JMP    0x12920 ; JUMP
0128A1  90                    NOP ; NOP
0128A2  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
0128A5  50                    PUSH   ax ; STACK_PUSH
0128A6  48                    DEC    ax ; ARITH
0128A7  8E C0                 MOV    es, ax ; MOV
0128A9  BF 08 00              MOV    di, 8 ; MOV
0128AC  BE AB 26              MOV    si, 0x26ab ; CONST_LOAD
0128AF  B9 08 00              MOV    cx, 8 ; MOV
0128B2  F3 A4                 REP MOVSB byte ptr es:[di], byte ptr [si] ; STR
0128B4  58                    POP    ax ; STACK_POP
0128B5  55                    PUSH   bp ; STACK_PUSH
0128B6  8C D1                 MOV    cx, ss ; MOV
0128B8  89 0E A3 26           MOV    word ptr [0x26a3], cx ; GLOBAL_LOAD
0128BC  89 26 A5 26           MOV    word ptr [0x26a5], sp ; GLOBAL_LOAD
0128C0  1E                    PUSH   ds ; STACK_PUSH
0128C1  07                    POP    es ; STACK_POP
0128C2  BB A7 26              MOV    bx, 0x26a7 ; CONST_LOAD
0128C5  89 07                 MOV    word ptr [bx], ax ; MOV
0128C7  89 47 02              MOV    word ptr [bx + 2], ax ; MOV
0128CA  C5 56 06              LDS    dx, ptr [bp + 6] ; MOV_FAR
0128CD  B0 03                 MOV    al, 3 ; MOV
0128CF  B4 4B                 MOV    ah, 0x4b ; CONST_LOAD
0128D1  CD 21                 INT    0x21 ; SYS
0128D3  BA 5A 1B              MOV    dx, 0x1b5a ; CONST_LOAD
0128D6  8E DA                 MOV    ds, dx ; MOV
0128D8  8B 16 A3 26           MOV    dx, word ptr [0x26a3] ; GLOBAL_LOAD
0128DC  8E D2                 MOV    ss, dx ; MOV
0128DE  8B 26 A5 26           MOV    sp, word ptr [0x26a5] ; GLOBAL_LOAD
0128E2  5D                    POP    bp ; STACK_POP
0128E3  72 2E                 JB     0x12913 ; CJUMP
0128E5  8E 06 A7 26           MOV    es, word ptr [0x26a7] ; GLOBAL_LOAD
0128E9  26 8B 1E 2A 00        MOV    bx, word ptr es:[0x2a] ; GLOBAL_LOAD
0128EE  26 A1 2C 00           MOV    ax, word ptr es:[0x2c] ; GLOBAL_LOAD
0128F2  05 0F 00              ADD    ax, 0xf ; ARITH
0128F5  D1 D8                 RCR    ax, 1 ; LOGIC
0128F7  C1 E8 03              SHR    ax, 3 ; LOGIC
0128FA  03 D8                 ADD    bx, ax ; ARITH
0128FC  8C C0                 MOV    ax, es ; MOV
0128FE  2B D8                 SUB    bx, ax ; ARITH
012900  83                    DB     0x83 ; DATA_BYTE
012901  C3                    DB     0xC3 ; DATA_BYTE
