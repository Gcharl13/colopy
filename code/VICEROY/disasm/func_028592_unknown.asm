; ============================================================================
; func_028592_unknown
; Region   : overlay
; Bytes    : file 0x028592..0x02860E  (124 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

028592  55                    PUSH   bp ; STACK_PUSH
028593  8B EC                 MOV    bp, sp ; MOV
028595  9A 22 0C 1F 18        LCALL  0x181f, 0xc22 ; THUNK -> 0x05EB:0x3956 (thunk @file 0x01B212 type B) overlay @file 0x02A946
02859A  0E                    PUSH   cs ; STACK_PUSH
02859B  E8 BC 44              CALL   0x2ca5a ; CALL_NEAR
02859E  0E                    PUSH   cs ; STACK_PUSH
02859F  E8 2B 45              CALL   0x2cacd ; CALL_NEAR
0285A2  68 C8 00              PUSH   0xc8 ; PUSH_CONST
0285A5  68 40 01              PUSH   0x140 ; PUSH_CONST
0285A8  6A 00                 PUSH   0 ; STACK_PUSH
0285AA  6A 00                 PUSH   0 ; STACK_PUSH
0285AC  0E                    PUSH   cs ; STACK_PUSH
0285AD  E8 13 45              CALL   0x2cac3 ; CALL_NEAR
0285B0  8B E5                 MOV    sp, bp ; MOV
0285B2  6A 00                 PUSH   0 ; STACK_PUSH
0285B4  0E                    PUSH   cs ; STACK_PUSH
0285B5  E8 2E 45              CALL   0x2cae6 ; CALL_NEAR
0285B8  8B E5                 MOV    sp, bp ; MOV
0285BA  6A 00                 PUSH   0 ; STACK_PUSH
0285BC  0E                    PUSH   cs ; STACK_PUSH
0285BD  E8 E1 43              CALL   0x2c9a1 ; CALL_NEAR
0285C0  8B E5                 MOV    sp, bp ; MOV
0285C2  6A 00                 PUSH   0 ; STACK_PUSH
0285C4  0E                    PUSH   cs ; STACK_PUSH
0285C5  E8 15 44              CALL   0x2c9dd ; CALL_NEAR
0285C8  8B E5                 MOV    sp, bp ; MOV
0285CA  6A 00                 PUSH   0 ; STACK_PUSH
0285CC  0E                    PUSH   cs ; STACK_PUSH
0285CD  E8 49 44              CALL   0x2ca19 ; CALL_NEAR
0285D0  8B E5                 MOV    sp, bp ; MOV
0285D2  6A 00                 PUSH   0 ; STACK_PUSH
0285D4  6A 00                 PUSH   0 ; STACK_PUSH
0285D6  0E                    PUSH   cs ; STACK_PUSH
0285D7  E8 0D 44              CALL   0x2c9e7 ; CALL_NEAR
0285DA  8B E5                 MOV    sp, bp ; MOV
0285DC  6A 00                 PUSH   0 ; STACK_PUSH
0285DE  0E                    PUSH   cs ; STACK_PUSH
0285DF  E8 19 44              CALL   0x2c9fb ; CALL_NEAR
0285E2  8B E5                 MOV    sp, bp ; MOV
0285E4  6A 00                 PUSH   0 ; STACK_PUSH
0285E6  0E                    PUSH   cs ; STACK_PUSH
0285E7  E8 99 43              CALL   0x2c983 ; CALL_NEAR
0285EA  8B E5                 MOV    sp, bp ; MOV
0285EC  6A 00                 PUSH   0 ; STACK_PUSH
0285EE  0E                    PUSH   cs ; STACK_PUSH
0285EF  E8 8C 43              CALL   0x2c97e ; CALL_NEAR
0285F2  8B E5                 MOV    sp, bp ; MOV
0285F4  83 7E 06 00           CMP    word ptr [bp + 6], 0 ; CMP
0285F8  74 12                 JE     0x2860c ; CJUMP
0285FA  6A 00                 PUSH   0 ; STACK_PUSH
0285FC  68 40 01              PUSH   0x140 ; PUSH_CONST
0285FF  68 C8 00              PUSH   0xc8 ; PUSH_CONST
028602  2B C0                 SUB    ax, ax ; ARITH
028604  99                    CDQ ; ARITH
028605  2B DB                 SUB    bx, bx ; ARITH
028607  9A E2 00 1F 18        LCALL  0x181f, 0xe2 ; THUNK -> 0x0B70:0x003A (thunk @file 0x01A6D2 type B) overlay @file 0x02798C
02860C  C9                    LEAVE ; EPILOGUE
02860D  CB                    RETF ; RETURN
