; ============================================================================
; func_059B90_unknown
; Region   : overlay
; Bytes    : file 0x059B90..0x059B9F  (15 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

059B90  C8 4A 00 00           ENTER  0x4a, 0 ; PROLOGUE
059B94  56                    PUSH   si ; STACK_PUSH
059B95  2B C0                 SUB    ax, ax ; ARITH
059B97  89 46 C8              MOV    word ptr [bp - 0x38], ax ; LOCAL_STORE
059B9A  89 46 CA              MOV    word ptr [bp - 0x36], ax ; LOCAL_STORE
059B9D  EB 0E                 JMP    0x59bad ; JUMP
