; ============================================================================
; func_0029AC_unknown
; Region   : load_image
; Bytes    : file 0x0029AC..0x0029DD  (49 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0029AC  55                    PUSH   bp ; STACK_PUSH
0029AD  8B EC                 MOV    bp, sp ; MOV
0029AF  56                    PUSH   si ; STACK_PUSH
0029B0  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
0029B3  56                    PUSH   si ; STACK_PUSH
0029B4  0E                    PUSH   cs ; STACK_PUSH
0029B5  E8 8A FF              CALL   0x2942 ; CALL_NEAR
0029B8  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
0029BB  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
0029BE  9A 62 00 00 00        LCALL  0, 0x62 ; LCALL
0029C3  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
0029C6  52                    PUSH   dx ; STACK_PUSH
0029C7  50                    PUSH   ax ; STACK_PUSH
0029C8  1E                    PUSH   ds ; STACK_PUSH
0029C9  56                    PUSH   si ; STACK_PUSH
0029CA  9A B4 11 1D 0D        LCALL  0xd1d, 0x11b4 ; LCALL
0029CF  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
0029D2  56                    PUSH   si ; STACK_PUSH
0029D3  0E                    PUSH   cs ; STACK_PUSH
0029D4  E8 7B FF              CALL   0x2952 ; CALL_NEAR
0029D7  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
0029DA  5E                    POP    si ; STACK_POP
0029DB  C9                    LEAVE ; EPILOGUE
0029DC  CB                    RETF ; RETURN
