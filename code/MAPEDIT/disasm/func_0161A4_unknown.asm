; ============================================================================
; func_0161A4_unknown
; Region   : load_image
; Bytes    : file 0x0161A4..0x01623B  (151 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0161A4  55                    PUSH   bp ; STACK_PUSH
0161A5  8B EC                 MOV    bp, sp ; MOV
0161A7  56                    PUSH   si ; STACK_PUSH
0161A8  57                    PUSH   di ; STACK_PUSH
0161A9  8B 76 08              MOV    si, word ptr [bp + 8] ; LOCAL_LOAD
0161AC  8A 44 06              MOV    al, byte ptr [si + 6] ; MOV
0161AF  A8 82                 TEST   al, 0x82 ; LOGIC
0161B1  74 69                 JE     0x1621c ; CJUMP
0161B3  A8 40                 TEST   al, 0x40 ; LOGIC
0161B5  75 65                 JNE    0x1621c ; CJUMP
0161B7  C7 44 02 00 00        MOV    word ptr [si + 2], 0 ; MOV
0161BC  A8 01                 TEST   al, 1 ; LOGIC
0161BE  74 0B                 JE     0x161cb ; CJUMP
0161C0  A8 10                 TEST   al, 0x10 ; LOGIC
0161C2  74 58                 JE     0x1621c ; CJUMP
0161C4  8B 4C 04              MOV    cx, word ptr [si + 4] ; MOV
0161C7  89 0C                 MOV    word ptr [si], cx ; MOV
0161C9  24 FE                 AND    al, 0xfe ; LOGIC
0161CB  0C 02                 OR     al, 2 ; LOGIC
0161CD  24 EF                 AND    al, 0xef ; LOGIC
0161CF  88 44 06              MOV    byte ptr [si + 6], al ; MOV
0161D2  8B FE                 MOV    di, si ; MOV
0161D4  81 EF C6 46           SUB    di, 0x46c6 ; ARITH
0161D8  81 C7 66 47           ADD    di, 0x4766 ; ARITH
0161DC  33 DB                 XOR    bx, bx ; LOGIC
0161DE  8A 5C 07              MOV    bl, byte ptr [si + 7] ; MOV
0161E1  A8 08                 TEST   al, 8 ; LOGIC
0161E3  75 4D                 JNE    0x16232 ; CJUMP
0161E5  A8 04                 TEST   al, 4 ; LOGIC
0161E7  75 1E                 JNE    0x16207 ; CJUMP
0161E9  F6 05 01              TEST   byte ptr [di], 1 ; LOGIC
0161EC  75 44                 JNE    0x16232 ; CJUMP
0161EE  81 FE CE 46           CMP    si, 0x46ce ; CMP
0161F2  74 0C                 JE     0x16200 ; CJUMP
0161F4  81 FE D6 46           CMP    si, 0x46d6 ; CMP
0161F8  74 06                 JE     0x16200 ; CJUMP
0161FA  81 FE E6 46           CMP    si, 0x46e6 ; CMP
0161FE  75 25                 JNE    0x16225 ; CJUMP
016200  F6 87 77 45 40        TEST   byte ptr [bx + 0x4577], 0x40 ; LOGIC
016205  74 1E                 JE     0x16225 ; CJUMP
016207  B9 01 00              MOV    cx, 1 ; MOV
01620A  51                    PUSH   cx ; STACK_PUSH
01620B  8D 7E 06              LEA    di, [bp + 6] ; ADDR
01620E  57                    PUSH   di ; STACK_PUSH
01620F  53                    PUSH   bx ; STACK_PUSH
016210  0E                    PUSH   cs ; STACK_PUSH
016211  E8 A2 09              CALL   0x16bb6 ; CALL_NEAR
016214  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
016217  B9 01 00              MOV    cx, 1 ; MOV
01621A  EB 3F                 JMP    0x1625b ; JUMP
01621C  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
01621F  80 4C 06 20           OR     byte ptr [si + 6], 0x20 ; LOGIC
016223  EB 5E                 JMP    0x16283 ; JUMP
016225  53                    PUSH   bx ; STACK_PUSH
016226  56                    PUSH   si ; STACK_PUSH
016227  E8 34 0E              CALL   0x1705e ; CALL_NEAR
01622A  5B                    POP    bx ; STACK_POP
01622B  5B                    POP    bx ; STACK_POP
01622C  F6 44 06 08           TEST   byte ptr [si + 6], 8 ; LOGIC
016230  74 D5                 JE     0x16207 ; CJUMP
016232  8B 0C                 MOV    cx, word ptr [si] ; MOV
016234  8B 54 04              MOV    dx, word ptr [si + 4] ; MOV
016237  2B CA                 SUB    cx, dx ; ARITH
016239  42                    INC    dx ; ARITH
01623A  89                    DB     0x89 ; DATA_BYTE
