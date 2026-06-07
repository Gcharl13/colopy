; ============================================================================
; func_02EB1C_unknown
; Region   : overlay
; Bytes    : file 0x02EB1C..0x02EB26  (10 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02EB1C  55                    PUSH   bp ; STACK_PUSH
02EB1D  8B EC                 MOV    bp, sp ; MOV
02EB1F  56                    PUSH   si ; STACK_PUSH
02EB20  69 5E 06 CA 00        IMUL   bx, word ptr [bp + 6], 0xca ; ARITH
02EB25  8A                    DB     0x8A ; DATA_BYTE
