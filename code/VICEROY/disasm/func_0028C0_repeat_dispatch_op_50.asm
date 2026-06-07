; ============================================================================
; func_0028C0_unknown
; Region   : load_image
; Bytes    : file 0x0028C0..0x0028E1  (33 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0028C0  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
0028C4  57                    PUSH   di ; STACK_PUSH
0028C5  56                    PUSH   si ; STACK_PUSH
0028C6  8B 56 08              MOV    dx, word ptr [bp + 8] ; LOCAL_LOAD
0028C9  0B D2                 OR     dx, dx ; LOGIC
0028CB  7E 10                 JLE    0x28dd ; CJUMP
0028CD  8B F2                 MOV    si, dx ; MOV
0028CF  8B 7E 06              MOV    di, word ptr [bp + 6] ; LOCAL_LOAD
0028D2  57                    PUSH   di ; STACK_PUSH
0028D3  0E                    PUSH   cs ; STACK_PUSH
0028D4  E8 D9 FF              CALL   0x28b0 ; CALL_NEAR
0028D7  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
0028DA  4E                    DEC    si ; ARITH
0028DB  75 F5                 JNE    0x28d2 ; CJUMP
0028DD  5E                    POP    si ; STACK_POP
0028DE  5F                    POP    di ; STACK_POP
0028DF  C9                    LEAVE ; EPILOGUE
0028E0  CB                    RETF ; RETURN
