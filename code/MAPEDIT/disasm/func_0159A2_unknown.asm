; ============================================================================
; __aFldiv  (BYTE_VERIFIED via sigmatch — inherited annotation)
; ----------------------------------------------------------------------------
; This function's bytes match VICEROY.EXE at 0x010496 (152 bytes).
; That source location is BYTE_VERIFIED (hand-decompiled in viceroy_source/).
;
; Description: MSC 6.0 32-bit signed long divide
; ----------------------------------------------------------------------------
; Region   : load_image
; Bytes    : file 0x0159A2..0x015A3A  (152 bytes)
; Status   : BYTE_VERIFIED (sigmatch — same bytes as VICEROY 0x010496)
; ============================================================================

0159A2  55                    PUSH   bp ; STACK_PUSH
0159A3  8B EC                 MOV    bp, sp ; MOV
0159A5  57                    PUSH   di ; STACK_PUSH
0159A6  56                    PUSH   si ; STACK_PUSH
0159A7  53                    PUSH   bx ; STACK_PUSH
0159A8  33 FF                 XOR    di, di ; LOGIC
0159AA  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
0159AD  0B C0                 OR     ax, ax ; LOGIC
0159AF  7D 11                 JGE    0x159c2 ; CJUMP
0159B1  47                    INC    di ; ARITH
0159B2  8B 56 06              MOV    dx, word ptr [bp + 6] ; LOCAL_LOAD
0159B5  F7 D8                 NEG    ax ; ARITH
0159B7  F7 DA                 NEG    dx ; ARITH
0159B9  1D 00 00              SBB    ax, 0 ; ARITH
0159BC  89 46 08              MOV    word ptr [bp + 8], ax ; LOCAL_STORE
0159BF  89 56 06              MOV    word ptr [bp + 6], dx ; LOCAL_STORE
0159C2  8B 46 0C              MOV    ax, word ptr [bp + 0xc] ; LOCAL_LOAD
0159C5  0B C0                 OR     ax, ax ; LOGIC
0159C7  7D 11                 JGE    0x159da ; CJUMP
0159C9  47                    INC    di ; ARITH
0159CA  8B 56 0A              MOV    dx, word ptr [bp + 0xa] ; LOCAL_LOAD
0159CD  F7 D8                 NEG    ax ; ARITH
0159CF  F7 DA                 NEG    dx ; ARITH
0159D1  1D 00 00              SBB    ax, 0 ; ARITH
0159D4  89 46 0C              MOV    word ptr [bp + 0xc], ax ; LOCAL_STORE
0159D7  89 56 0A              MOV    word ptr [bp + 0xa], dx ; LOCAL_STORE
0159DA  0B C0                 OR     ax, ax ; LOGIC
0159DC  75 15                 JNE    0x159f3 ; CJUMP
0159DE  8B 4E 0A              MOV    cx, word ptr [bp + 0xa] ; LOCAL_LOAD
0159E1  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
0159E4  33 D2                 XOR    dx, dx ; LOGIC
0159E6  F7 F1                 DIV    cx ; ARITH
0159E8  8B D8                 MOV    bx, ax ; MOV
0159EA  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
0159ED  F7 F1                 DIV    cx ; ARITH
0159EF  8B D3                 MOV    dx, bx ; MOV
0159F1  EB 38                 JMP    0x15a2b ; JUMP
0159F3  8B D8                 MOV    bx, ax ; MOV
0159F5  8B 4E 0A              MOV    cx, word ptr [bp + 0xa] ; LOCAL_LOAD
0159F8  8B 56 08              MOV    dx, word ptr [bp + 8] ; LOCAL_LOAD
0159FB  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
0159FE  D1 EB                 SHR    bx, 1 ; LOGIC
015A00  D1 D9                 RCR    cx, 1 ; LOGIC
015A02  D1 EA                 SHR    dx, 1 ; LOGIC
015A04  D1 D8                 RCR    ax, 1 ; LOGIC
015A06  0B DB                 OR     bx, bx ; LOGIC
015A08  75 F4                 JNE    0x159fe ; CJUMP
015A0A  F7 F1                 DIV    cx ; ARITH
015A0C  8B F0                 MOV    si, ax ; MOV
015A0E  F7 66 0C              MUL    word ptr [bp + 0xc] ; ARITH
015A11  91                    XCHG   cx, ax ; MOV
015A12  8B 46 0A              MOV    ax, word ptr [bp + 0xa] ; LOCAL_LOAD
015A15  F7 E6                 MUL    si ; ARITH
015A17  03 D1                 ADD    dx, cx ; ARITH
015A19  72 0C                 JB     0x15a27 ; CJUMP
015A1B  3B 56 08              CMP    dx, word ptr [bp + 8] ; CMP
015A1E  77 07                 JA     0x15a27 ; CJUMP
015A20  72 06                 JB     0x15a28 ; CJUMP
015A22  3B 46 06              CMP    ax, word ptr [bp + 6] ; CMP
015A25  76 01                 JBE    0x15a28 ; CJUMP
015A27  4E                    DEC    si ; ARITH
015A28  33 D2                 XOR    dx, dx ; LOGIC
015A2A  96                    XCHG   si, ax ; MOV
015A2B  4F                    DEC    di ; ARITH
015A2C  75 07                 JNE    0x15a35 ; CJUMP
015A2E  F7 DA                 NEG    dx ; ARITH
015A30  F7 D8                 NEG    ax ; ARITH
015A32  83 DA 00              SBB    dx, 0 ; ARITH
015A35  5B                    POP    bx ; STACK_POP
015A36  5E                    POP    si ; STACK_POP
015A37  5F                    POP    di ; STACK_POP
015A38  5D                    POP    bp ; STACK_POP
015A39  CA 08 00              RETF   8 ; RETURN
