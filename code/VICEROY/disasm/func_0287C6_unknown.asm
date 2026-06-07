; ============================================================================
; func_0287C6_unknown
; Region   : overlay
; Bytes    : file 0x0287C6..0x0287E6  (32 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0287C6  55                    PUSH   bp ; STACK_PUSH
0287C7  8B EC                 MOV    bp, sp ; MOV
0287C9  6A 01                 PUSH   1 ; STACK_PUSH
0287CB  9A 56 00 1F 18        LCALL  0x181f, 0x56 ; THUNK -> 0x0009:0x00B4 (thunk @file 0x01A646 type B) overlay @file 0x02287E
0287D0  8B E5                 MOV    sp, bp ; MOV
0287D2  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
0287D5  0E                    PUSH   cs ; STACK_PUSH
0287D6  E8 E0 42              CALL   0x2cab9 ; CALL_NEAR
0287D9  8B E5                 MOV    sp, bp ; MOV
0287DB  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
0287DE  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
0287E1  6A 03                 PUSH   3 ; STACK_PUSH
0287E3  0E                    PUSH   cs ; STACK_PUSH
0287E4  E8                    DB     0xE8 ; DATA_BYTE
0287E5  C3                    DB     0xC3 ; DATA_BYTE
