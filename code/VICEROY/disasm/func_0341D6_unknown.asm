; ============================================================================
; func_0341D6_unknown
; Region   : overlay
; Bytes    : file 0x0341D6..0x03423C  (102 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0341D6  C8 0E 00 00           ENTER  0xe, 0 ; PROLOGUE
0341DA  56                    PUSH   si ; STACK_PUSH
0341DB  83 3E 3A 9E 0A        CMP    word ptr [0x9e3a], 0xa ; CMP
0341E0  75 5A                 JNE    0x3423c ; CJUMP
0341E2  83 3E F4 07 00        CMP    word ptr [0x7f4], 0 ; CMP
0341E7  75 03                 JNE    0x341ec ; CJUMP
0341E9  E9 29 01              JMP    0x34315 ; JUMP
0341EC  83 3E 22 9E 00        CMP    word ptr [0x9e22], 0 ; CMP
0341F1  74 03                 JE     0x341f6 ; CJUMP
0341F3  E9 1F 01              JMP    0x34315 ; JUMP
0341F6  FF 36 24 9E           PUSH   word ptr [0x9e24] ; PUSH_GLOBAL
0341FA  0E                    PUSH   cs ; STACK_PUSH
0341FB  E8 C9 26              CALL   0x368c7 ; CALL_NEAR
0341FE  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
034201  0B C0                 OR     ax, ax ; LOGIC
034203  74 12                 JE     0x34217 ; CJUMP
034205  FF 36 24 9E           PUSH   word ptr [0x9e24] ; PUSH_GLOBAL
034209  0E                    PUSH   cs ; STACK_PUSH
03420A  E8 6F 26              CALL   0x3687c ; CALL_NEAR
03420D  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
034210  0B C0                 OR     ax, ax ; LOGIC
034212  75 03                 JNE    0x34217 ; CJUMP
034214  E9 FE 00              JMP    0x34315 ; JUMP
034217  FF 36 1C 9E           PUSH   word ptr [0x9e1c] ; PUSH_GLOBAL
03421B  0E                    PUSH   cs ; STACK_PUSH
03421C  E8 E4 26              CALL   0x36903 ; CALL_NEAR
03421F  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
034222  89 46 F2              MOV    word ptr [bp - 0xe], ax ; LOCAL_STORE
034225  9A A2 03 1F 18        LCALL  0x181f, 0x3a2 ; THUNK -> 0x0262:0x0002 (thunk @file 0x01A992 type B) overlay @file 0x021D32
03422A  50                    PUSH   ax ; STACK_PUSH
03422B  FF 36 24 9E           PUSH   word ptr [0x9e24] ; PUSH_GLOBAL
03422F  FF 76 F2              PUSH   word ptr [bp - 0xe] ; PUSH_GLOBAL
034232  0E                    PUSH   cs ; STACK_PUSH
034233  E8 A0 26              CALL   0x368d6 ; CALL_NEAR
034236  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
034239  5E                    POP    si ; STACK_POP
03423A  C9                    LEAVE ; EPILOGUE
03423B  CB                    RETF ; RETURN
