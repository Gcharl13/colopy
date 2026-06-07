; ============================================================================
; func_004314_unknown
; Region   : load_image
; Bytes    : file 0x004314..0x004322  (14 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

004314  C8 26 00 00           ENTER  0x26, 0 ; PROLOGUE
004318  53                    PUSH   bx ; STACK_PUSH
004319  52                    PUSH   dx ; STACK_PUSH
00431A  50                    PUSH   ax ; STACK_PUSH
00431B  57                    PUSH   di ; STACK_PUSH
00431C  56                    PUSH   si ; STACK_PUSH
00431D  69 D8 CA 00           IMUL   bx, ax, 0xca ; ARITH
004321  89                    DB     0x89 ; DATA_BYTE
