; ============================================================================
; func_00623A_unknown
; Region   : load_image
; Bytes    : file 0x00623A..0x0062D1  (151 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00623A  55                    PUSH   bp ; STACK_PUSH
00623B  8B EC                 MOV    bp, sp ; MOV
00623D  56                    PUSH   si ; STACK_PUSH
00623E  57                    PUSH   di ; STACK_PUSH
00623F  8B 76 08              MOV    si, word ptr [bp + 8] ; LOCAL_LOAD
006242  8A 44 06              MOV    al, byte ptr [si + 6] ; MOV
006245  A8 82                 TEST   al, 0x82 ; LOGIC
006247  74 69                 JE     0x62b2 ; CJUMP
006249  A8 40                 TEST   al, 0x40 ; LOGIC
00624B  75 65                 JNE    0x62b2 ; CJUMP
00624D  C7 44 02 00 00        MOV    word ptr [si + 2], 0 ; MOV
006252  A8 01                 TEST   al, 1 ; LOGIC
006254  74 0B                 JE     0x6261 ; CJUMP
006256  A8 10                 TEST   al, 0x10 ; LOGIC
006258  74 58                 JE     0x62b2 ; CJUMP
00625A  8B 4C 04              MOV    cx, word ptr [si + 4] ; MOV
00625D  89 0C                 MOV    word ptr [si], cx ; MOV
00625F  24 FE                 AND    al, 0xfe ; LOGIC
006261  0C 02                 OR     al, 2 ; LOGIC
006263  24 EF                 AND    al, 0xef ; LOGIC
006265  88 44 06              MOV    byte ptr [si + 6], al ; MOV
006268  8B FE                 MOV    di, si ; MOV
00626A  81 EF A8 41           SUB    di, 0x41a8 ; ARITH
00626E  81 C7 48 42           ADD    di, 0x4248 ; ARITH
006272  33 DB                 XOR    bx, bx ; LOGIC
006274  8A 5C 07              MOV    bl, byte ptr [si + 7] ; MOV
006277  A8 08                 TEST   al, 8 ; LOGIC
006279  75 4D                 JNE    0x62c8 ; CJUMP
00627B  A8 04                 TEST   al, 4 ; LOGIC
00627D  75 1E                 JNE    0x629d ; CJUMP
00627F  F6 05 01              TEST   byte ptr [di], 1 ; LOGIC
006282  75 44                 JNE    0x62c8 ; CJUMP
006284  81 FE B0 41           CMP    si, 0x41b0 ; CMP
006288  74 0C                 JE     0x6296 ; CJUMP
00628A  81 FE B8 41           CMP    si, 0x41b8 ; CMP
00628E  74 06                 JE     0x6296 ; CJUMP
006290  81 FE C8 41           CMP    si, 0x41c8 ; CMP
006294  75 25                 JNE    0x62bb ; CJUMP
006296  F6 87 59 40 40        TEST   byte ptr [bx + 0x4059], 0x40 ; LOGIC
00629B  74 1E                 JE     0x62bb ; CJUMP
00629D  B9 01 00              MOV    cx, 1 ; MOV
0062A0  51                    PUSH   cx ; STACK_PUSH
0062A1  8D 7E 06              LEA    di, [bp + 6] ; ADDR
0062A4  57                    PUSH   di ; STACK_PUSH
0062A5  53                    PUSH   bx ; STACK_PUSH
0062A6  0E                    PUSH   cs ; STACK_PUSH
0062A7  E8 74 02              CALL   0x651e ; CALL_NEAR
0062AA  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
0062AD  B9 01 00              MOV    cx, 1 ; MOV
0062B0  EB 3F                 JMP    0x62f1 ; JUMP
0062B2  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
0062B5  80 4C 06 20           OR     byte ptr [si + 6], 0x20 ; LOGIC
0062B9  EB 5E                 JMP    0x6319 ; JUMP
0062BB  53                    PUSH   bx ; STACK_PUSH
0062BC  56                    PUSH   si ; STACK_PUSH
0062BD  E8 5E 00              CALL   0x631e ; CALL_NEAR
0062C0  5B                    POP    bx ; STACK_POP
0062C1  5B                    POP    bx ; STACK_POP
0062C2  F6 44 06 08           TEST   byte ptr [si + 6], 8 ; LOGIC
0062C6  74 D5                 JE     0x629d ; CJUMP
0062C8  8B 0C                 MOV    cx, word ptr [si] ; MOV
0062CA  8B 54 04              MOV    dx, word ptr [si + 4] ; MOV
0062CD  2B CA                 SUB    cx, dx ; ARITH
0062CF  42                    INC    dx ; ARITH
0062D0  89                    DB     0x89 ; DATA_BYTE
