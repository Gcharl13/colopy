; ============================================================================
; func_0610B0_unknown
; Region   : overlay
; Bytes    : file 0x0610B0..0x0610DA  (42 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0610B0  C8 64 00 00           ENTER  0x64, 0 ; PROLOGUE
0610B4  56                    PUSH   si ; STACK_PUSH
0610B5  83 3E A0 53 0C        CMP    word ptr [0x53a0], 0xc ; CMP
0610BA  7C 1E                 JL     0x610da ; CJUMP
0610BC  C7 06 B0 9C 0C 00     MOV    word ptr [0x9cb0], 0xc ; GLOBAL_LOAD
0610C2  C7 06 B2 9C 00 00     MOV    word ptr [0x9cb2], 0 ; GLOBAL_LOAD
0610C8  8D 1E 7C 08           LEA    bx, [0x87c] ; ADDR
0610CC  8D 06 6A 1D           LEA    ax, [0x1d6a] ; ADDR
0610D0  2B D2                 SUB    dx, dx ; ARITH
0610D2  9A 98 09 1F 18        LCALL  0x181f, 0x998 ; THUNK -> 0x0000:0x36CA (thunk @file 0x01AF88 type A) overlay @file 0x028FCA
0610D7  5E                    POP    si ; STACK_POP
0610D8  C9                    LEAVE ; EPILOGUE
0610D9  CB                    RETF ; RETURN
