; ============================================================================
; func_010E66_unknown
; Region   : load_image
; Bytes    : file 0x010E66..0x010EDA  (116 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

010E66  55                    PUSH   bp ; STACK_PUSH
010E67  8B EC                 MOV    bp, sp ; MOV
010E69  83 EC 02              SUB    sp, 2 ; STACK_ALLOC
010E6C  57                    PUSH   di ; STACK_PUSH
010E6D  56                    PUSH   si ; STACK_PUSH
010E6E  2B FF                 SUB    di, di ; ARITH
010E70  39 7E 06              CMP    word ptr [bp + 6], di ; CMP
010E73  75 09                 JNE    0x10e7e ; CJUMP
010E75  2B C0                 SUB    ax, ax ; ARITH
010E77  50                    PUSH   ax ; STACK_PUSH
010E78  E8 67 00              CALL   0x10ee2 ; CALL_NEAR
010E7B  EB 57                 JMP    0x10ed4 ; JUMP
010E7D  90                    NOP ; NOP
010E7E  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
010E81  8A 44 06              MOV    al, byte ptr [si + 6] ; MOV
010E84  8B C8                 MOV    cx, ax ; MOV
010E86  24 03                 AND    al, 3 ; LOGIC
010E88  3C 02                 CMP    al, 2 ; CMP
010E8A  75 3C                 JNE    0x10ec8 ; CJUMP
010E8C  F6 C1 08              TEST   cl, 8 ; LOGIC
010E8F  75 0D                 JNE    0x10e9e ; CJUMP
010E91  8B DE                 MOV    bx, si ; MOV
010E93  81 EB 0E 29           SUB    bx, 0x290e ; ARITH
010E97  F6 87 AE 29 01        TEST   byte ptr [bx + 0x29ae], 1 ; LOGIC
010E9C  74 2A                 JE     0x10ec8 ; CJUMP
010E9E  8B 04                 MOV    ax, word ptr [si] ; MOV
010EA0  2B 44 04              SUB    ax, word ptr [si + 4] ; ARITH
010EA3  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
010EA6  0B C0                 OR     ax, ax ; LOGIC
010EA8  7E 1E                 JLE    0x10ec8 ; CJUMP
010EAA  50                    PUSH   ax ; STACK_PUSH
010EAB  FF 74 04              PUSH   word ptr [si + 4] ; STACK_PUSH
010EAE  8A 4C 07              MOV    cl, byte ptr [si + 7] ; MOV
010EB1  2A ED                 SUB    ch, ch ; ARITH
010EB3  51                    PUSH   cx ; STACK_PUSH
010EB4  9A FE 1F 1D 0D        LCALL  0xd1d, 0x1ffe ; LCALL
010EB9  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
010EBC  39 46 FE              CMP    word ptr [bp - 2], ax ; CMP
010EBF  74 07                 JE     0x10ec8 ; CJUMP
010EC1  80 4C 06 20           OR     byte ptr [si + 6], 0x20 ; LOGIC
010EC5  BF FF FF              MOV    di, 0xffff ; CONST_LOAD
010EC8  8B 44 04              MOV    ax, word ptr [si + 4] ; MOV
010ECB  89 04                 MOV    word ptr [si], ax ; MOV
010ECD  C7 44 02 00 00        MOV    word ptr [si + 2], 0 ; MOV
010ED2  8B C7                 MOV    ax, di ; MOV
010ED4  5E                    POP    si ; STACK_POP
010ED5  5F                    POP    di ; STACK_POP
010ED6  8B E5                 MOV    sp, bp ; MOV
010ED8  5D                    POP    bp ; STACK_POP
010ED9  CB                    RETF ; RETURN
