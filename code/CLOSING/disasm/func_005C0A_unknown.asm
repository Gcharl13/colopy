; ============================================================================
; func_005C0A_unknown
; Region   : load_image
; Bytes    : file 0x005C0A..0x005C84  (122 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

005C0A  55                    PUSH   bp ; STACK_PUSH
005C0B  8B EC                 MOV    bp, sp ; MOV
005C0D  83 EC 04              SUB    sp, 4 ; STACK_ALLOC
005C10  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
005C13  3B 1E 57 40           CMP    bx, word ptr [0x4057] ; CMP
005C17  72 05                 JB     0x5c1e ; CJUMP
005C19  B8 00 09              MOV    ax, 0x900 ; CONST_LOAD
005C1C  EB 2A                 JMP    0x5c48 ; JUMP
005C1E  F7 46 0A 00 80        TEST   word ptr [bp + 0xa], 0x8000 ; LOGIC
005C23  74 48                 JE     0x5c6d ; CJUMP
005C25  83 7E 0C 00           CMP    word ptr [bp + 0xc], 0 ; CMP
005C29  74 1A                 JE     0x5c45 ; CJUMP
005C2B  33 C9                 XOR    cx, cx ; LOGIC
005C2D  8B D1                 MOV    dx, cx ; MOV
005C2F  B8 01 42              MOV    ax, 0x4201 ; CONST_LOAD
005C32  CD 21                 INT    0x21 ; SYS
005C34  72 4B                 JB     0x5c81 ; CJUMP
005C36  F7 46 0C 02 00        TEST   word ptr [bp + 0xc], 2 ; LOGIC
005C3B  75 0E                 JNE    0x5c4b ; CJUMP
005C3D  03 46 08              ADD    ax, word ptr [bp + 8] ; ARITH
005C40  13 56 0A              ADC    dx, word ptr [bp + 0xa] ; ARITH
005C43  79 28                 JNS    0x5c6d ; CJUMP
005C45  B8 00 16              MOV    ax, 0x1600 ; CONST_LOAD
005C48  F9                    STC ; FLAG
005C49  EB 36                 JMP    0x5c81 ; JUMP
005C4B  89 56 FE              MOV    word ptr [bp - 2], dx ; LOCAL_STORE
005C4E  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
005C51  8B D1                 MOV    dx, cx ; MOV
005C53  B8 02 42              MOV    ax, 0x4202 ; CONST_LOAD
005C56  CD 21                 INT    0x21 ; SYS
005C58  03 46 08              ADD    ax, word ptr [bp + 8] ; ARITH
005C5B  13 56 0A              ADC    dx, word ptr [bp + 0xa] ; ARITH
005C5E  79 0D                 JNS    0x5c6d ; CJUMP
005C60  8B 4E FE              MOV    cx, word ptr [bp - 2] ; LOCAL_LOAD
005C63  8B 56 FC              MOV    dx, word ptr [bp - 4] ; LOCAL_LOAD
005C66  B8 00 42              MOV    ax, 0x4200 ; CONST_LOAD
005C69  CD 21                 INT    0x21 ; SYS
005C6B  EB D8                 JMP    0x5c45 ; JUMP
005C6D  8B 56 08              MOV    dx, word ptr [bp + 8] ; LOCAL_LOAD
005C70  8B 4E 0A              MOV    cx, word ptr [bp + 0xa] ; LOCAL_LOAD
005C73  8A 46 0C              MOV    al, byte ptr [bp + 0xc] ; LOCAL_LOAD
005C76  B4 42                 MOV    ah, 0x42 ; CONST_LOAD
005C78  CD 21                 INT    0x21 ; SYS
005C7A  72 05                 JB     0x5c81 ; CJUMP
005C7C  80 A7 59 40 FD        AND    byte ptr [bx + 0x4059], 0xfd ; LOGIC
005C81  E9 E5 F6              JMP    0x5369 ; JUMP
