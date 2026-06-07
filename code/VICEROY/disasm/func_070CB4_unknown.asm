; ============================================================================
; func_070CB4_unknown
; Region   : overlay
; Bytes    : file 0x070CB4..0x070D16  (98 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

070CB4  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
070CB8  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
070CBB  8B 1F                 MOV    bx, word ptr [bx] ; MOV
070CBD  8A 07                 MOV    al, byte ptr [bx] ; MOV
070CBF  98                    CWDE ; ARITH
070CC0  8B D8                 MOV    bx, ax ; MOV
070CC2  89 5E FC              MOV    word ptr [bp - 4], bx ; LOCAL_STORE
070CC5  F6 87 ED 27 02        TEST   byte ptr [bx + 0x27ed], 2 ; LOGIC
070CCA  74 06                 JE     0x70cd2 ; CJUMP
070CCC  2D 20 00              SUB    ax, 0x20 ; ARITH
070CCF  E9 D4 00              JMP    0x70da6 ; JUMP
070CD2  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
070CD5  8B 1F                 MOV    bx, word ptr [bx] ; MOV
070CD7  8A 07                 MOV    al, byte ptr [bx] ; MOV
070CD9  98                    CWDE ; ARITH
070CDA  E9 C9 00              JMP    0x70da6 ; JUMP
070CDD  90                    NOP ; NOP
070CDE  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
070CE1  B0 3A                 MOV    al, 0x3a ; CONST_LOAD
070CE3  0E                    PUSH   cs ; STACK_PUSH
070CE4  E8 AA 02              CALL   0x70f91 ; CALL_NEAR
070CE7  0B C0                 OR     ax, ax ; LOGIC
070CE9  75 03                 JNE    0x70cee ; CJUMP
070CEB  E9 F8 00              JMP    0x70de6 ; JUMP
070CEE  C6 06 08 26 4E        MOV    byte ptr [0x2608], 0x4e ; GLOBAL_LOAD
070CF3  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
070CF6  2A C0                 SUB    al, al ; ARITH
070CF8  0E                    PUSH   cs ; STACK_PUSH
070CF9  E8 95 02              CALL   0x70f91 ; CALL_NEAR
070CFC  E9 E7 00              JMP    0x70de6 ; JUMP
070CFF  90                    NOP ; NOP
070D00  C6 06 28 08 01        MOV    byte ptr [0x828], 1 ; GLOBAL_LOAD
070D05  C7 06 26 08 01 00     MOV    word ptr [0x826], 1 ; GLOBAL_LOAD
070D0B  E9 D8 00              JMP    0x70de6 ; JUMP
070D0E  C7 06 1E 20 01 00     MOV    word ptr [0x201e], 1 ; GLOBAL_LOAD
070D14  E9                    DB     0xE9 ; DATA_BYTE
070D15  CF                    DB     0xCF ; DATA_BYTE
