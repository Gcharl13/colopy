; ============================================================================
; func_0065C7_unknown
; Region   : load_image
; Bytes    : file 0x0065C7..0x006606  (63 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0065C7  55                    PUSH   bp ; STACK_PUSH
0065C8  8B EC                 MOV    bp, sp ; MOV
0065CA  56                    PUSH   si ; STACK_PUSH
0065CB  57                    PUSH   di ; STACK_PUSH
0065CC  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
0065CF  8B FE                 MOV    di, si ; MOV
0065D1  81 EF FE 43           SUB    di, 0x43fe ; ARITH
0065D5  81 C7 9E 44           ADD    di, 0x449e ; ARITH
0065D9  F6 05 10              TEST   byte ptr [di], 0x10 ; LOGIC
0065DC  74 24                 JE     0x6602 ; CJUMP
0065DE  33 DB                 XOR    bx, bx ; LOGIC
0065E0  8A 5C 07              MOV    bl, byte ptr [si + 7] ; MOV
0065E3  F6 87 AF 42 40        TEST   byte ptr [bx + 0x42af], 0x40 ; LOGIC
0065E8  74 18                 JE     0x6602 ; CJUMP
0065EA  56                    PUSH   si ; STACK_PUSH
0065EB  0E                    PUSH   cs ; STACK_PUSH
0065EC  E8 17 00              CALL   0x6606 ; CALL_NEAR
0065EF  58                    POP    ax ; STACK_POP
0065F0  83 7E 04 00           CMP    word ptr [bp + 4], 0 ; CMP
0065F4  74 0C                 JE     0x6602 ; CJUMP
0065F6  33 C0                 XOR    ax, ax ; LOGIC
0065F8  88 05                 MOV    byte ptr [di], al ; MOV
0065FA  89 45 02              MOV    word ptr [di + 2], ax ; MOV
0065FD  89 04                 MOV    word ptr [si], ax ; MOV
0065FF  89 44 04              MOV    word ptr [si + 4], ax ; MOV
006602  5F                    POP    di ; STACK_POP
006603  5E                    POP    si ; STACK_POP
006604  5D                    POP    bp ; STACK_POP
006605  C3                    RET ; RETURN
