; ============================================================================
; func_038890_unknown
; Region   : overlay
; Bytes    : file 0x038890..0x0388DE  (78 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

038890  C8 66 00 00           ENTER  0x66, 0 ; PROLOGUE
038894  56                    PUSH   si ; STACK_PUSH
038895  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
038898  0E                    PUSH   cs ; STACK_PUSH
038899  E8 99 15              CALL   0x39e35 ; CALL_NEAR
03889C  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
03889F  C7 46 AA 02 00        MOV    word ptr [bp - 0x56], 2 ; LOCAL_STORE
0388A4  C7 46 A8 2A 00        MOV    word ptr [bp - 0x58], 0x2a ; LOCAL_STORE
0388A9  2B C0                 SUB    ax, ax ; ARITH
0388AB  89 46 AE              MOV    word ptr [bp - 0x52], ax ; LOCAL_STORE
0388AE  89 46 9C              MOV    word ptr [bp - 0x64], ax ; LOCAL_STORE
0388B1  89 46 A4              MOV    word ptr [bp - 0x5c], ax ; LOCAL_STORE
0388B4  E9 5B 01              JMP    0x38a12 ; JUMP
0388B7  90                    NOP ; NOP
0388B8  50                    PUSH   ax ; STACK_PUSH
0388B9  9A E6 09 1F 18        LCALL  0x181f, 0x9e6 ; THUNK -> 0x05EB:0x002C (thunk @file 0x01AFD6 type B) overlay @file 0x02701C
0388BE  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
0388C1  8A 46 06              MOV    al, byte ptr [bp + 6] ; LOCAL_LOAD
0388C4  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
0388C8  38 47 1A              CMP    byte ptr [bx + 0x1a], al ; CMP
0388CB  74 03                 JE     0x388d0 ; CJUMP
0388CD  E9 3F 01              JMP    0x38a0f ; JUMP
0388D0  68 92 00              PUSH   0x92 ; PUSH_CONST
0388D3  8B 46 A8              MOV    ax, word ptr [bp - 0x58] ; LOCAL_LOAD
0388D6  40                    INC    ax ; ARITH
0388D7  40                    INC    ax ; ARITH
0388D8  50                    PUSH   ax ; STACK_PUSH
0388D9  FF 76 AA              PUSH   word ptr [bp - 0x56] ; PUSH_GLOBAL
0388DC  8B C3                 MOV    ax, bx ; MOV
