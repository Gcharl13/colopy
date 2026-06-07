; ============================================================================
; func_00722C_unknown
; Region   : load_image
; Bytes    : file 0x00722C..0x0072C3  (151 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00722C  55                    PUSH   bp ; STACK_PUSH
00722D  8B EC                 MOV    bp, sp ; MOV
00722F  56                    PUSH   si ; STACK_PUSH
007230  57                    PUSH   di ; STACK_PUSH
007231  8B 76 08              MOV    si, word ptr [bp + 8] ; LOCAL_LOAD
007234  8A 44 06              MOV    al, byte ptr [si + 6] ; MOV
007237  A8 82                 TEST   al, 0x82 ; LOGIC
007239  74 69                 JE     0x72a4 ; CJUMP
00723B  A8 40                 TEST   al, 0x40 ; LOGIC
00723D  75 65                 JNE    0x72a4 ; CJUMP
00723F  C7 44 02 00 00        MOV    word ptr [si + 2], 0 ; MOV
007244  A8 01                 TEST   al, 1 ; LOGIC
007246  74 0B                 JE     0x7253 ; CJUMP
007248  A8 10                 TEST   al, 0x10 ; LOGIC
00724A  74 58                 JE     0x72a4 ; CJUMP
00724C  8B 4C 04              MOV    cx, word ptr [si + 4] ; MOV
00724F  89 0C                 MOV    word ptr [si], cx ; MOV
007251  24 FE                 AND    al, 0xfe ; LOGIC
007253  0C 02                 OR     al, 2 ; LOGIC
007255  24 EF                 AND    al, 0xef ; LOGIC
007257  88 44 06              MOV    byte ptr [si + 6], al ; MOV
00725A  8B FE                 MOV    di, si ; MOV
00725C  81 EF FE 43           SUB    di, 0x43fe ; ARITH
007260  81 C7 9E 44           ADD    di, 0x449e ; ARITH
007264  33 DB                 XOR    bx, bx ; LOGIC
007266  8A 5C 07              MOV    bl, byte ptr [si + 7] ; MOV
007269  A8 08                 TEST   al, 8 ; LOGIC
00726B  75 4D                 JNE    0x72ba ; CJUMP
00726D  A8 04                 TEST   al, 4 ; LOGIC
00726F  75 1E                 JNE    0x728f ; CJUMP
007271  F6 05 01              TEST   byte ptr [di], 1 ; LOGIC
007274  75 44                 JNE    0x72ba ; CJUMP
007276  81 FE 06 44           CMP    si, 0x4406 ; CMP
00727A  74 0C                 JE     0x7288 ; CJUMP
00727C  81 FE 0E 44           CMP    si, 0x440e ; CMP
007280  74 06                 JE     0x7288 ; CJUMP
007282  81 FE 1E 44           CMP    si, 0x441e ; CMP
007286  75 25                 JNE    0x72ad ; CJUMP
007288  F6 87 AF 42 40        TEST   byte ptr [bx + 0x42af], 0x40 ; LOGIC
00728D  74 1E                 JE     0x72ad ; CJUMP
00728F  B9 01 00              MOV    cx, 1 ; MOV
007292  51                    PUSH   cx ; STACK_PUSH
007293  8D 7E 06              LEA    di, [bp + 6] ; ADDR
007296  57                    PUSH   di ; STACK_PUSH
007297  53                    PUSH   bx ; STACK_PUSH
007298  0E                    PUSH   cs ; STACK_PUSH
007299  E8 74 02              CALL   0x7510 ; CALL_NEAR
00729C  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
00729F  B9 01 00              MOV    cx, 1 ; MOV
0072A2  EB 3F                 JMP    0x72e3 ; JUMP
0072A4  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
0072A7  80 4C 06 20           OR     byte ptr [si + 6], 0x20 ; LOGIC
0072AB  EB 5E                 JMP    0x730b ; JUMP
0072AD  53                    PUSH   bx ; STACK_PUSH
0072AE  56                    PUSH   si ; STACK_PUSH
0072AF  E8 5E 00              CALL   0x7310 ; CALL_NEAR
0072B2  5B                    POP    bx ; STACK_POP
0072B3  5B                    POP    bx ; STACK_POP
0072B4  F6 44 06 08           TEST   byte ptr [si + 6], 8 ; LOGIC
0072B8  74 D5                 JE     0x728f ; CJUMP
0072BA  8B 0C                 MOV    cx, word ptr [si] ; MOV
0072BC  8B 54 04              MOV    dx, word ptr [si + 4] ; MOV
0072BF  2B CA                 SUB    cx, dx ; ARITH
0072C1  42                    INC    dx ; ARITH
0072C2  89                    DB     0x89 ; DATA_BYTE
