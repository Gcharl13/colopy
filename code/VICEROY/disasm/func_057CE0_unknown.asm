; ============================================================================
; func_057CE0_unknown
; Region   : overlay
; Bytes    : file 0x057CE0..0x057D24  (68 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

057CE0  C8 0E 00 00           ENTER  0xe, 0 ; PROLOGUE
057CE4  C7 46 F2 00 00        MOV    word ptr [bp - 0xe], 0 ; LOCAL_STORE
057CE9  EB 5B                 JMP    0x57d46 ; JUMP
057CEB  90                    NOP ; NOP
057CEC  83 7E F8 08           CMP    word ptr [bp - 8], 8 ; CMP
057CF0  7D 30                 JGE    0x57d22 ; CJUMP
057CF2  8B 5E F8              MOV    bx, word ptr [bp - 8] ; LOCAL_LOAD
057CF5  8A 87 BE 00           MOV    al, byte ptr [bx + 0xbe] ; MOV
057CF9  98                    CWDE ; ARITH
057CFA  03 46 F4              ADD    ax, word ptr [bp - 0xc] ; ARITH
057CFD  50                    PUSH   ax ; STACK_PUSH
057CFE  8A 87 B4 00           MOV    al, byte ptr [bx + 0xb4] ; MOV
057D02  98                    CWDE ; ARITH
057D03  03 46 F6              ADD    ax, word ptr [bp - 0xa] ; ARITH
057D06  50                    PUSH   ax ; STACK_PUSH
057D07  9A 96 06 1F 18        LCALL  0x181f, 0x696 ; THUNK -> 0x037F:0x0358 (thunk @file 0x01AC86 type B) overlay @file 0x02EE94
057D0C  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
057D0F  3B 46 06              CMP    ax, word ptr [bp + 6] ; CMP
057D12  75 05                 JNE    0x57d19 ; CJUMP
057D14  C7 46 FA 01 00        MOV    word ptr [bp - 6], 1 ; LOCAL_STORE
057D19  FF 46 F8              INC    word ptr [bp - 8] ; ARITH
057D1C  83 7E FA 00           CMP    word ptr [bp - 6], 0 ; CMP
057D20  74 CA                 JE     0x57cec ; CJUMP
057D22  83                    DB     0x83 ; DATA_BYTE
057D23  7E                    DB     0x7E ; DATA_BYTE
