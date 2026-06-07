; ============================================================================
; func_0063B6_unknown
; Region   : load_image
; Bytes    : file 0x0063B6..0x0063C4  (14 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0063B6  C8 0A 00 00           ENTER  0xa, 0 ; PROLOGUE
0063BA  57                    PUSH   di ; STACK_PUSH
0063BB  56                    PUSH   si ; STACK_PUSH
0063BC  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
0063BF  69 DE CA 00           IMUL   bx, si, 0xca ; ARITH
0063C3  8A                    DB     0x8A ; DATA_BYTE
