; ============================================================================
; func_04891A_unknown
; Region   : overlay
; Bytes    : file 0x04891A..0x0489AD  (147 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04891A  C8 12 00 00           ENTER  0x12, 0 ; PROLOGUE
04891E  56                    PUSH   si ; STACK_PUSH
04891F  C7 46 EE 00 00        MOV    word ptr [bp - 0x12], 0 ; LOCAL_STORE
048924  EB 1D                 JMP    0x48943 ; JUMP
048926  FF 46 FC              INC    word ptr [bp - 4] ; ARITH
048929  83 7E FC 04           CMP    word ptr [bp - 4], 4 ; CMP
04892D  7D 11                 JGE    0x48940 ; CJUMP
04892F  6B 5E EE 27           IMUL   bx, word ptr [bp - 0x12], 0x27 ; ARITH
048933  03 5E FC              ADD    bx, word ptr [bp - 4] ; ARITH
048936  D1 E3                 SHL    bx, 1 ; LOGIC
048938  C7 87 04 5B 00 00     MOV    word ptr [bx + 0x5b04], 0 ; MOV
04893E  EB E6                 JMP    0x48926 ; JUMP
048940  FF 46 EE              INC    word ptr [bp - 0x12] ; ARITH
048943  83 7E EE 08           CMP    word ptr [bp - 0x12], 8 ; CMP
048947  7D 07                 JGE    0x48950 ; CJUMP
048949  C7 46 FC 00 00        MOV    word ptr [bp - 4], 0 ; LOCAL_STORE
04894E  EB D9                 JMP    0x48929 ; JUMP
048950  C7 46 F0 00 00        MOV    word ptr [bp - 0x10], 0 ; LOCAL_STORE
048955  6B 5E F0 4E           IMUL   bx, word ptr [bp - 0x10], 0x4e ; ARITH
048959  F6 87 D9 5A 80        TEST   byte ptr [bx + 0x5ad9], 0x80 ; LOGIC
04895E  75 0A                 JNE    0x4896a ; CJUMP
048960  FF 76 F0              PUSH   word ptr [bp - 0x10] ; PUSH_GLOBAL
048963  0E                    PUSH   cs ; STACK_PUSH
048964  E8 A5 30              CALL   0x4ba0c ; CALL_NEAR
048967  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
04896A  FF 46 F0              INC    word ptr [bp - 0x10] ; ARITH
04896D  83 7E F0 08           CMP    word ptr [bp - 0x10], 8 ; CMP
048971  7C E2                 JL     0x48955 ; CJUMP
048973  C7 46 F0 00 00        MOV    word ptr [bp - 0x10], 0 ; LOCAL_STORE
048978  EB 79                 JMP    0x489f3 ; JUMP
04897A  90                    NOP ; NOP
04897B  90                    NOP ; NOP
04897C  FF 46 F8              INC    word ptr [bp - 8] ; ARITH
04897F  8B 46 F4              MOV    ax, word ptr [bp - 0xc] ; LOCAL_LOAD
048982  39 46 F8              CMP    word ptr [bp - 8], ax ; CMP
048985  7D 69                 JGE    0x489f0 ; CJUMP
048987  8B 5E F8              MOV    bx, word ptr [bp - 8] ; LOCAL_LOAD
04898A  8A 87 C8 00           MOV    al, byte ptr [bx + 0xc8] ; MOV
04898E  98                    CWDE ; ARITH
04898F  03 46 F6              ADD    ax, word ptr [bp - 0xa] ; ARITH
048992  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
048995  8A 87 DE 00           MOV    al, byte ptr [bx + 0xde] ; MOV
048999  98                    CWDE ; ARITH
04899A  03 46 F2              ADD    ax, word ptr [bp - 0xe] ; ARITH
04899D  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
0489A0  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
0489A4  8B 76 F8              MOV    si, word ptr [bp - 8] ; LOCAL_LOAD
0489A7  80 78 70 00           CMP    byte ptr [bx + si + 0x70], 0 ; CMP
0489AB  7C CF                 JL     0x4897c ; CJUMP
