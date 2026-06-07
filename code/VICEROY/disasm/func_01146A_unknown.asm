; ============================================================================
; func_01146A_unknown
; Region   : load_image
; Bytes    : file 0x01146A..0x0114E4  (122 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

01146A  55                    PUSH   bp ; STACK_PUSH
01146B  8B EC                 MOV    bp, sp ; MOV
01146D  83 EC 04              SUB    sp, 4 ; STACK_ALLOC
011470  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
011473  3B 1E B9 27           CMP    bx, word ptr [0x27b9] ; CMP
011477  72 05                 JB     0x1147e ; CJUMP
011479  B8 00 09              MOV    ax, 0x900 ; CONST_LOAD
01147C  EB 2A                 JMP    0x114a8 ; JUMP
01147E  F7 46 0A 00 80        TEST   word ptr [bp + 0xa], 0x8000 ; LOGIC
011483  74 48                 JE     0x114cd ; CJUMP
011485  83 7E 0C 00           CMP    word ptr [bp + 0xc], 0 ; CMP
011489  74 1A                 JE     0x114a5 ; CJUMP
01148B  33 C9                 XOR    cx, cx ; LOGIC
01148D  8B D1                 MOV    dx, cx ; MOV
01148F  B8 01 42              MOV    ax, 0x4201 ; CONST_LOAD
011492  CD 21                 INT    0x21 ; SYS
011494  72 4B                 JB     0x114e1 ; CJUMP
011496  F7 46 0C 02 00        TEST   word ptr [bp + 0xc], 2 ; LOGIC
01149B  75 0E                 JNE    0x114ab ; CJUMP
01149D  03 46 08              ADD    ax, word ptr [bp + 8] ; ARITH
0114A0  13 56 0A              ADC    dx, word ptr [bp + 0xa] ; ARITH
0114A3  79 28                 JNS    0x114cd ; CJUMP
0114A5  B8 00 16              MOV    ax, 0x1600 ; CONST_LOAD
0114A8  F9                    STC ; FLAG
0114A9  EB 36                 JMP    0x114e1 ; JUMP
0114AB  89 56 FE              MOV    word ptr [bp - 2], dx ; LOCAL_STORE
0114AE  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
0114B1  8B D1                 MOV    dx, cx ; MOV
0114B3  B8 02 42              MOV    ax, 0x4202 ; CONST_LOAD
0114B6  CD 21                 INT    0x21 ; SYS
0114B8  03 46 08              ADD    ax, word ptr [bp + 8] ; ARITH
0114BB  13 56 0A              ADC    dx, word ptr [bp + 0xa] ; ARITH
0114BE  79 0D                 JNS    0x114cd ; CJUMP
0114C0  8B 4E FE              MOV    cx, word ptr [bp - 2] ; LOCAL_LOAD
0114C3  8B 56 FC              MOV    dx, word ptr [bp - 4] ; LOCAL_LOAD
0114C6  B8 00 42              MOV    ax, 0x4200 ; CONST_LOAD
0114C9  CD 21                 INT    0x21 ; SYS
0114CB  EB D8                 JMP    0x114a5 ; JUMP
0114CD  8B 56 08              MOV    dx, word ptr [bp + 8] ; LOCAL_LOAD
0114D0  8B 4E 0A              MOV    cx, word ptr [bp + 0xa] ; LOCAL_LOAD
0114D3  8A 46 0C              MOV    al, byte ptr [bp + 0xc] ; LOCAL_LOAD
0114D6  B4 42                 MOV    ah, 0x42 ; CONST_LOAD
0114D8  CD 21                 INT    0x21 ; SYS
0114DA  72 05                 JB     0x114e1 ; CJUMP
0114DC  80 A7 BB 27 FD        AND    byte ptr [bx + 0x27bb], 0xfd ; LOGIC
0114E1  E9 01 F6              JMP    0x10ae5 ; JUMP
