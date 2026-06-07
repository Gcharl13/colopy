; ============================================================================
; func_04477E_unknown
; Region   : overlay
; Bytes    : file 0x04477E..0x0447FA  (124 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04477E  C8 0C 00 00           ENTER  0xc, 0 ; PROLOGUE
044782  57                    PUSH   di ; STACK_PUSH
044783  56                    PUSH   si ; STACK_PUSH
044784  C7 46 F6 00 00        MOV    word ptr [bp - 0xa], 0 ; LOCAL_STORE
044789  6A 7E                 PUSH   0x7e ; PUSH_CONST
04478B  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
04478E  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
044791  9A EA 10 1D 0D        LCALL  0xd1d, 0x10ea ; LCALL
044796  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
044799  8B F0                 MOV    si, ax ; MOV
04479B  89 56 FE              MOV    word ptr [bp - 2], dx ; LOCAL_STORE
04479E  6A 7E                 PUSH   0x7e ; PUSH_CONST
0447A0  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
0447A3  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
0447A6  9A 10 10 1D 0D        LCALL  0xd1d, 0x1010 ; LCALL
0447AB  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
0447AE  8B F8                 MOV    di, ax ; MOV
0447B0  8B 4E FE              MOV    cx, word ptr [bp - 2] ; LOCAL_LOAD
0447B3  3B C6                 CMP    ax, si ; CMP
0447B5  75 04                 JNE    0x447bb ; CJUMP
0447B7  3B D1                 CMP    dx, cx ; CMP
0447B9  74 47                 JE     0x44802 ; CJUMP
0447BB  8E DA                 MOV    ds, dx ; MOV
0447BD  80 7D 01 46           CMP    byte ptr [di + 1], 0x46 ; CMP
0447C1  75 3F                 JNE    0x44802 ; CJUMP
0447C3  8E 46 FE              MOV    es, word ptr [bp - 2] ; LOCAL_LOAD
0447C6  26 8A 5C 01           MOV    bl, byte ptr es:[si + 1] ; MOV
0447CA  2A FF                 SUB    bh, bh ; ARITH
0447CC  36 F6 87 ED 27 04     TEST   byte ptr ss:[bx + 0x27ed], 4 ; LOGIC
0447D2  74 2E                 JE     0x44802 ; CJUMP
0447D4  B9 3B 01              MOV    cx, 0x13b ; CONST_LOAD
0447D7  83 C7 03              ADD    di, 3 ; ARITH
0447DA  80 3D 30              CMP    byte ptr [di], 0x30 ; CMP
0447DD  75 0C                 JNE    0x447eb ; CJUMP
0447DF  B9 54 01              MOV    cx, 0x154 ; CONST_LOAD
0447E2  80 7D 02 30           CMP    byte ptr [di + 2], 0x30 ; CMP
0447E6  75 03                 JNE    0x447eb ; CJUMP
0447E8  B9 5E 01              MOV    cx, 0x15e ; CONST_LOAD
0447EB  26 80 7C FF 31        CMP    byte ptr es:[si - 1], 0x31 ; CMP
0447F0  75 06                 JNE    0x447f8 ; CJUMP
0447F2  83 C1 09              ADD    cx, 9 ; ARITH
0447F5  EB 33                 JMP    0x4482a ; JUMP
0447F7  90                    NOP ; NOP
0447F8  8B C3                 MOV    ax, bx ; MOV
