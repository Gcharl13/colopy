; ============================================================================
; func_010BBC_unknown
; Region   : load_image
; Bytes    : file 0x010BBC..0x010C53  (151 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

010BBC  55                    PUSH   bp ; STACK_PUSH
010BBD  8B EC                 MOV    bp, sp ; MOV
010BBF  56                    PUSH   si ; STACK_PUSH
010BC0  57                    PUSH   di ; STACK_PUSH
010BC1  8B 76 08              MOV    si, word ptr [bp + 8] ; LOCAL_LOAD
010BC4  8A 44 06              MOV    al, byte ptr [si + 6] ; MOV
010BC7  A8 82                 TEST   al, 0x82 ; LOGIC
010BC9  74 69                 JE     0x10c34 ; CJUMP
010BCB  A8 40                 TEST   al, 0x40 ; LOGIC
010BCD  75 65                 JNE    0x10c34 ; CJUMP
010BCF  C7 44 02 00 00        MOV    word ptr [si + 2], 0 ; MOV
010BD4  A8 01                 TEST   al, 1 ; LOGIC
010BD6  74 0B                 JE     0x10be3 ; CJUMP
010BD8  A8 10                 TEST   al, 0x10 ; LOGIC
010BDA  74 58                 JE     0x10c34 ; CJUMP
010BDC  8B 4C 04              MOV    cx, word ptr [si + 4] ; MOV
010BDF  89 0C                 MOV    word ptr [si], cx ; MOV
010BE1  24 FE                 AND    al, 0xfe ; LOGIC
010BE3  0C 02                 OR     al, 2 ; LOGIC
010BE5  24 EF                 AND    al, 0xef ; LOGIC
010BE7  88 44 06              MOV    byte ptr [si + 6], al ; MOV
010BEA  8B FE                 MOV    di, si ; MOV
010BEC  81 EF 0E 29           SUB    di, 0x290e ; ARITH
010BF0  81 C7 AE 29           ADD    di, 0x29ae ; ARITH
010BF4  33 DB                 XOR    bx, bx ; LOGIC
010BF6  8A 5C 07              MOV    bl, byte ptr [si + 7] ; MOV
010BF9  A8 08                 TEST   al, 8 ; LOGIC
010BFB  75 4D                 JNE    0x10c4a ; CJUMP
010BFD  A8 04                 TEST   al, 4 ; LOGIC
010BFF  75 1E                 JNE    0x10c1f ; CJUMP
010C01  F6 05 01              TEST   byte ptr [di], 1 ; LOGIC
010C04  75 44                 JNE    0x10c4a ; CJUMP
010C06  81 FE 16 29           CMP    si, 0x2916 ; CMP
010C0A  74 0C                 JE     0x10c18 ; CJUMP
010C0C  81 FE 1E 29           CMP    si, 0x291e ; CMP
010C10  74 06                 JE     0x10c18 ; CJUMP
010C12  81 FE 2E 29           CMP    si, 0x292e ; CMP
010C16  75 25                 JNE    0x10c3d ; CJUMP
010C18  F6 87 BB 27 40        TEST   byte ptr [bx + 0x27bb], 0x40 ; LOGIC
010C1D  74 1E                 JE     0x10c3d ; CJUMP
010C1F  B9 01 00              MOV    cx, 1 ; MOV
010C22  51                    PUSH   cx ; STACK_PUSH
010C23  8D 7E 06              LEA    di, [bp + 6] ; ADDR
010C26  57                    PUSH   di ; STACK_PUSH
010C27  53                    PUSH   bx ; STACK_PUSH
010C28  0E                    PUSH   cs ; STACK_PUSH
010C29  E8 A2 09              CALL   0x115ce ; CALL_NEAR
010C2C  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
010C2F  B9 01 00              MOV    cx, 1 ; MOV
010C32  EB 3F                 JMP    0x10c73 ; JUMP
010C34  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
010C37  80 4C 06 20           OR     byte ptr [si + 6], 0x20 ; LOGIC
010C3B  EB 5E                 JMP    0x10c9b ; JUMP
010C3D  53                    PUSH   bx ; STACK_PUSH
010C3E  56                    PUSH   si ; STACK_PUSH
010C3F  E8 90 10              CALL   0x11cd2 ; CALL_NEAR
010C42  5B                    POP    bx ; STACK_POP
010C43  5B                    POP    bx ; STACK_POP
010C44  F6 44 06 08           TEST   byte ptr [si + 6], 8 ; LOGIC
010C48  74 D5                 JE     0x10c1f ; CJUMP
010C4A  8B 0C                 MOV    cx, word ptr [si] ; MOV
010C4C  8B 54 04              MOV    dx, word ptr [si + 4] ; MOV
010C4F  2B CA                 SUB    cx, dx ; ARITH
010C51  42                    INC    dx ; ARITH
010C52  89                    DB     0x89 ; DATA_BYTE
