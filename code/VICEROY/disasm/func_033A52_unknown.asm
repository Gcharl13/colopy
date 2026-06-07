; ============================================================================
; func_033A52_unknown
; Region   : overlay
; Bytes    : file 0x033A52..0x033AB6  (100 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

033A52  C8 08 00 00           ENTER  8, 0 ; PROLOGUE
033A56  83 3E 3A 9E 0A        CMP    word ptr [0x9e3a], 0xa ; CMP
033A5B  75 59                 JNE    0x33ab6 ; CJUMP
033A5D  83 3E F4 07 00        CMP    word ptr [0x7f4], 0 ; CMP
033A62  75 03                 JNE    0x33a67 ; CJUMP
033A64  E9 7B 01              JMP    0x33be2 ; JUMP
033A67  83 3E 22 9E 00        CMP    word ptr [0x9e22], 0 ; CMP
033A6C  74 03                 JE     0x33a71 ; CJUMP
033A6E  E9 71 01              JMP    0x33be2 ; JUMP
033A71  FF 36 24 9E           PUSH   word ptr [0x9e24] ; PUSH_GLOBAL
033A75  0E                    PUSH   cs ; STACK_PUSH
033A76  E8 4E 2E              CALL   0x368c7 ; CALL_NEAR
033A79  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
033A7C  0B C0                 OR     ax, ax ; LOGIC
033A7E  74 12                 JE     0x33a92 ; CJUMP
033A80  FF 36 24 9E           PUSH   word ptr [0x9e24] ; PUSH_GLOBAL
033A84  0E                    PUSH   cs ; STACK_PUSH
033A85  E8 F4 2D              CALL   0x3687c ; CALL_NEAR
033A88  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
033A8B  0B C0                 OR     ax, ax ; LOGIC
033A8D  75 03                 JNE    0x33a92 ; CJUMP
033A8F  E9 50 01              JMP    0x33be2 ; JUMP
033A92  FF 36 1C 9E           PUSH   word ptr [0x9e1c] ; PUSH_GLOBAL
033A96  0E                    PUSH   cs ; STACK_PUSH
033A97  E8 69 2E              CALL   0x36903 ; CALL_NEAR
033A9A  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
033A9D  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
033AA0  9A A2 03 1F 18        LCALL  0x181f, 0x3a2 ; THUNK -> 0x0262:0x0002 (thunk @file 0x01A992 type B) overlay @file 0x021D32
033AA5  50                    PUSH   ax ; STACK_PUSH
033AA6  FF 36 24 9E           PUSH   word ptr [0x9e24] ; PUSH_GLOBAL
033AAA  FF 76 FA              PUSH   word ptr [bp - 6] ; STACK_PUSH
033AAD  0E                    PUSH   cs ; STACK_PUSH
033AAE  E8 25 2E              CALL   0x368d6 ; CALL_NEAR
033AB1  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
033AB4  C9                    LEAVE ; EPILOGUE
033AB5  CB                    RETF ; RETURN
