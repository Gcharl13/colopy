; ============================================================================
; func_070782_unknown
; Region   : overlay
; Bytes    : file 0x070782..0x07078F  (13 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

070782  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
070786  56                    PUSH   si ; STACK_PUSH
070787  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
07078A  99                    CDQ ; ARITH
07078B  2B C2                 SUB    ax, dx ; ARITH
07078D  D1 F8                 SAR    ax, 1 ; LOGIC
