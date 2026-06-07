; ============================================================================
; func_02EB78_unknown
; Region   : overlay
; Bytes    : file 0x02EB78..0x02EBAF  (55 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02EB78  C8 0A 00 00           ENTER  0xa, 0 ; PROLOGUE
02EB7C  56                    PUSH   si ; STACK_PUSH
02EB7D  C7 46 FC FF FF        MOV    word ptr [bp - 4], 0xffff ; LOCAL_STORE
02EB82  83 3E 9E 53 30        CMP    word ptr [0x539e], 0x30 ; CMP
02EB87  7C 27                 JL     0x2ebb0 ; CJUMP
02EB89  83 7E 06 04           CMP    word ptr [bp + 6], 4 ; CMP
02EB8D  7C 03                 JL     0x2eb92 ; CJUMP
02EB8F  E9 9B 02              JMP    0x2ee2d ; JUMP
02EB92  6B 5E 06 34           IMUL   bx, word ptr [bp + 6], 0x34 ; ARITH
02EB96  80 BF 3F 54 00        CMP    byte ptr [bx + 0x543f], 0 ; CMP
02EB9B  74 03                 JE     0x2eba0 ; CJUMP
02EB9D  E9 8D 02              JMP    0x2ee2d ; JUMP
02EBA0  8D 1E D1 0E           LEA    bx, [0xed1] ; ADDR
02EBA4  9A FE 03 1F 18        LCALL  0x181f, 0x3fe ; THUNK -> 0x0000:0x3744 (thunk @file 0x01A9EE type A) overlay @file 0x029044
02EBA9  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
02EBAC  5E                    POP    si ; STACK_POP
02EBAD  C9                    LEAVE ; EPILOGUE
02EBAE  CB                    RETF ; RETURN
