; ============================================================================
; func_02EE34_unknown
; Region   : overlay
; Bytes    : file 0x02EE34..0x02EE40  (12 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02EE34  C8 08 00 00           ENTER  8, 0 ; PROLOGUE
02EE38  57                    PUSH   di ; STACK_PUSH
02EE39  56                    PUSH   si ; STACK_PUSH
02EE3A  69 5E 06 CA 00        IMUL   bx, word ptr [bp + 6], 0xca ; ARITH
02EE3F  8A                    DB     0x8A ; DATA_BYTE
