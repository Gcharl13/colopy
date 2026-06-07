; ============================================================================
; func_006C0A_unknown
; Region   : load_image
; Bytes    : file 0x006C0A..0x006C84  (122 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

006C0A  55                    PUSH   bp ; STACK_PUSH
006C0B  8B EC                 MOV    bp, sp ; MOV
006C0D  83 EC 04              SUB    sp, 4 ; STACK_ALLOC
006C10  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
006C13  3B 1E AD 42           CMP    bx, word ptr [0x42ad] ; CMP
006C17  72 05                 JB     0x6c1e ; CJUMP
006C19  B8 00 09              MOV    ax, 0x900 ; CONST_LOAD
006C1C  EB 2A                 JMP    0x6c48 ; JUMP
006C1E  F7 46 0A 00 80        TEST   word ptr [bp + 0xa], 0x8000 ; LOGIC
006C23  74 48                 JE     0x6c6d ; CJUMP
006C25  83 7E 0C 00           CMP    word ptr [bp + 0xc], 0 ; CMP
006C29  74 1A                 JE     0x6c45 ; CJUMP
006C2B  33 C9                 XOR    cx, cx ; LOGIC
006C2D  8B D1                 MOV    dx, cx ; MOV
006C2F  B8 01 42              MOV    ax, 0x4201 ; CONST_LOAD
006C32  CD 21                 INT    0x21 ; SYS
006C34  72 4B                 JB     0x6c81 ; CJUMP
006C36  F7 46 0C 02 00        TEST   word ptr [bp + 0xc], 2 ; LOGIC
006C3B  75 0E                 JNE    0x6c4b ; CJUMP
006C3D  03 46 08              ADD    ax, word ptr [bp + 8] ; ARITH
006C40  13 56 0A              ADC    dx, word ptr [bp + 0xa] ; ARITH
006C43  79 28                 JNS    0x6c6d ; CJUMP
006C45  B8 00 16              MOV    ax, 0x1600 ; CONST_LOAD
006C48  F9                    STC ; FLAG
006C49  EB 36                 JMP    0x6c81 ; JUMP
006C4B  89 56 FE              MOV    word ptr [bp - 2], dx ; LOCAL_STORE
006C4E  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
006C51  8B D1                 MOV    dx, cx ; MOV
006C53  B8 02 42              MOV    ax, 0x4202 ; CONST_LOAD
006C56  CD 21                 INT    0x21 ; SYS
006C58  03 46 08              ADD    ax, word ptr [bp + 8] ; ARITH
006C5B  13 56 0A              ADC    dx, word ptr [bp + 0xa] ; ARITH
006C5E  79 0D                 JNS    0x6c6d ; CJUMP
006C60  8B 4E FE              MOV    cx, word ptr [bp - 2] ; LOCAL_LOAD
006C63  8B 56 FC              MOV    dx, word ptr [bp - 4] ; LOCAL_LOAD
006C66  B8 00 42              MOV    ax, 0x4200 ; CONST_LOAD
006C69  CD 21                 INT    0x21 ; SYS
006C6B  EB D8                 JMP    0x6c45 ; JUMP
006C6D  8B 56 08              MOV    dx, word ptr [bp + 8] ; LOCAL_LOAD
006C70  8B 4E 0A              MOV    cx, word ptr [bp + 0xa] ; LOCAL_LOAD
006C73  8A 46 0C              MOV    al, byte ptr [bp + 0xc] ; LOCAL_LOAD
006C76  B4 42                 MOV    ah, 0x42 ; CONST_LOAD
006C78  CD 21                 INT    0x21 ; SYS
006C7A  72 05                 JB     0x6c81 ; CJUMP
006C7C  80 A7 AF 42 FD        AND    byte ptr [bx + 0x42af], 0xfd ; LOGIC
006C81  E9 E5 F6              JMP    0x6369 ; JUMP
