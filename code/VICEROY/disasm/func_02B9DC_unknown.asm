; ============================================================================
; func_02B9DC_unknown
; Region   : overlay
; Bytes    : file 0x02B9DC..0x02BA24  (72 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02B9DC  C8 06 00 00           ENTER  6, 0 ; PROLOGUE
02B9E0  56                    PUSH   si ; STACK_PUSH
02B9E1  83 3E 54 8D 07        CMP    word ptr [0x8d54], 7 ; CMP
02B9E6  75 3C                 JNE    0x2ba24 ; CJUMP
02B9E8  83 3E F4 07 00        CMP    word ptr [0x7f4], 0 ; CMP
02B9ED  75 03                 JNE    0x2b9f2 ; CJUMP
02B9EF  E9 36 01              JMP    0x2bb28 ; JUMP
02B9F2  80 3E 8C A8 00        CMP    byte ptr [0xa88c], 0 ; CMP
02B9F7  74 03                 JE     0x2b9fc ; CJUMP
02B9F9  E9 2C 01              JMP    0x2bb28 ; JUMP
02B9FC  FF 36 3E 03           PUSH   word ptr [0x33e] ; PUSH_GLOBAL
02BA00  9A 32 0B 1F 18        LCALL  0x181f, 0xb32 ; THUNK -> 0x05EB:0x2F8E (thunk @file 0x01B122 type B) overlay @file 0x029F7E
02BA05  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
02BA08  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
02BA0B  9A A2 03 1F 18        LCALL  0x181f, 0x3a2 ; THUNK -> 0x0262:0x0002 (thunk @file 0x01A992 type B) overlay @file 0x021D32
02BA10  50                    PUSH   ax ; STACK_PUSH
02BA11  A0 8D A8              MOV    al, byte ptr [0xa88d] ; GLOBAL_LOAD
02BA14  2A E4                 SUB    ah, ah ; ARITH
02BA16  50                    PUSH   ax ; STACK_PUSH
02BA17  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
02BA1A  0E                    PUSH   cs ; STACK_PUSH
02BA1B  E8 AB 0F              CALL   0x2c9c9 ; CALL_NEAR
02BA1E  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
02BA21  5E                    POP    si ; STACK_POP
02BA22  C9                    LEAVE ; EPILOGUE
02BA23  CB                    RETF ; RETURN
