; ============================================================================
; func_030566_unknown
; Region   : overlay
; Bytes    : file 0x030566..0x030570  (10 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

030566  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
03056A  56                    PUSH   si ; STACK_PUSH
03056B  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
03056E  8B C3                 MOV    ax, bx ; MOV
