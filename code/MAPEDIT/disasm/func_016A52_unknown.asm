; ============================================================================
; func_016A52_unknown
; Region   : load_image
; Bytes    : file 0x016A52..0x016ACC  (122 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

016A52  55                    PUSH   bp ; STACK_PUSH
016A53  8B EC                 MOV    bp, sp ; MOV
016A55  83 EC 04              SUB    sp, 4 ; STACK_ALLOC
016A58  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
016A5B  3B 1E 75 45           CMP    bx, word ptr [0x4575] ; CMP
016A5F  72 05                 JB     0x16a66 ; CJUMP
016A61  B8 00 09              MOV    ax, 0x900 ; CONST_LOAD
016A64  EB 2A                 JMP    0x16a90 ; JUMP
016A66  F7 46 0A 00 80        TEST   word ptr [bp + 0xa], 0x8000 ; LOGIC
016A6B  74 48                 JE     0x16ab5 ; CJUMP
016A6D  83 7E 0C 00           CMP    word ptr [bp + 0xc], 0 ; CMP
016A71  74 1A                 JE     0x16a8d ; CJUMP
016A73  33 C9                 XOR    cx, cx ; LOGIC
016A75  8B D1                 MOV    dx, cx ; MOV
016A77  B8 01 42              MOV    ax, 0x4201 ; CONST_LOAD
016A7A  CD 21                 INT    0x21 ; SYS
016A7C  72 4B                 JB     0x16ac9 ; CJUMP
016A7E  F7 46 0C 02 00        TEST   word ptr [bp + 0xc], 2 ; LOGIC
016A83  75 0E                 JNE    0x16a93 ; CJUMP
016A85  03 46 08              ADD    ax, word ptr [bp + 8] ; ARITH
016A88  13 56 0A              ADC    dx, word ptr [bp + 0xa] ; ARITH
016A8B  79 28                 JNS    0x16ab5 ; CJUMP
016A8D  B8 00 16              MOV    ax, 0x1600 ; CONST_LOAD
016A90  F9                    STC ; FLAG
016A91  EB 36                 JMP    0x16ac9 ; JUMP
016A93  89 56 FE              MOV    word ptr [bp - 2], dx ; LOCAL_STORE
016A96  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
016A99  8B D1                 MOV    dx, cx ; MOV
016A9B  B8 02 42              MOV    ax, 0x4202 ; CONST_LOAD
016A9E  CD 21                 INT    0x21 ; SYS
016AA0  03 46 08              ADD    ax, word ptr [bp + 8] ; ARITH
016AA3  13 56 0A              ADC    dx, word ptr [bp + 0xa] ; ARITH
016AA6  79 0D                 JNS    0x16ab5 ; CJUMP
016AA8  8B 4E FE              MOV    cx, word ptr [bp - 2] ; LOCAL_LOAD
016AAB  8B 56 FC              MOV    dx, word ptr [bp - 4] ; LOCAL_LOAD
016AAE  B8 00 42              MOV    ax, 0x4200 ; CONST_LOAD
016AB1  CD 21                 INT    0x21 ; SYS
016AB3  EB D8                 JMP    0x16a8d ; JUMP
016AB5  8B 56 08              MOV    dx, word ptr [bp + 8] ; LOCAL_LOAD
016AB8  8B 4E 0A              MOV    cx, word ptr [bp + 0xa] ; LOCAL_LOAD
016ABB  8A 46 0C              MOV    al, byte ptr [bp + 0xc] ; LOCAL_LOAD
016ABE  B4 42                 MOV    ah, 0x42 ; CONST_LOAD
016AC0  CD 21                 INT    0x21 ; SYS
016AC2  72 05                 JB     0x16ac9 ; CJUMP
016AC4  80 A7 77 45 FD        AND    byte ptr [bx + 0x4577], 0xfd ; LOGIC
016AC9  E9 01 F6              JMP    0x160cd ; JUMP
