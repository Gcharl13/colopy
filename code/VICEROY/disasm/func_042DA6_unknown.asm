; ============================================================================
; func_042DA6_unknown
; Region   : overlay
; Bytes    : file 0x042DA6..0x042DF9  (83 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

042DA6  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
042DAA  83 3E 9C 92 01        CMP    word ptr [0x929c], 1 ; CMP
042DAF  F5                    CMC ; FLAG
042DB0  1B C0                 SBB    ax, ax ; ARITH
042DB2  25 0F 00              AND    ax, 0xf ; LOGIC
042DB5  50                    PUSH   ax ; STACK_PUSH
042DB6  FF 36 56 9E           PUSH   word ptr [0x9e56] ; PUSH_GLOBAL
042DBA  68 F2 00              PUSH   0xf2 ; PUSH_CONST
042DBD  FF 36 BE 2D           PUSH   word ptr [0x2dbe] ; PUSH_GLOBAL
042DC1  9A 22 00 1F 18        LCALL  0x181f, 0x22 ; THUNK -> 0x0000:0x0062 (thunk @file 0x01A612 type B) overlay @file 0x025962
042DC6  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
042DC9  52                    PUSH   dx ; STACK_PUSH
042DCA  50                    PUSH   ax ; STACK_PUSH
042DCB  9A 3C 01 1F 18        LCALL  0x181f, 0x13c ; THUNK -> 0x004B:0x0288 (thunk @file 0x01A72C type B) overlay @file 0x060630
042DD0  83 C4 0A              ADD    sp, 0xa ; STACK_CLEANUP
042DD3  83 7E 06 00           CMP    word ptr [bp + 6], 0 ; CMP
042DD7  74 1E                 JE     0x42df7 ; CJUMP
042DD9  FF 36 56 9E           PUSH   word ptr [0x9e56] ; PUSH_GLOBAL
042DDD  6A 4F                 PUSH   0x4f ; PUSH_CONST
042DDF  C4 1E 9E 08           LES    bx, ptr [0x89e] ; MOV_FAR
042DE3  26 8A 07              MOV    al, byte ptr es:[bx] ; MOV
042DE6  2A E4                 SUB    ah, ah ; ARITH
042DE8  50                    PUSH   ax ; STACK_PUSH
042DE9  B8 F1 00              MOV    ax, 0xf1 ; CONST_LOAD
042DEC  8B 16 56 9E           MOV    dx, word ptr [0x9e56] ; GLOBAL_LOAD
042DF0  8B D8                 MOV    bx, ax ; MOV
042DF2  9A E2 00 1F 18        LCALL  0x181f, 0xe2 ; THUNK -> 0x0B70:0x003A (thunk @file 0x01A6D2 type B) overlay @file 0x02798C
042DF7  C9                    LEAVE ; EPILOGUE
042DF8  CB                    RETF ; RETURN
