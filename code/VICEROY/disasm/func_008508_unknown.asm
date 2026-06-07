; ============================================================================
; func_008508_unknown
; Region   : load_image
; Bytes    : file 0x008508..0x008511  (9 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

008508  55                    PUSH   bp ; STACK_PUSH
008509  8B EC                 MOV    bp, sp ; MOV
00850B  69 5E 06 CA 00        IMUL   bx, word ptr [bp + 6], 0xca ; ARITH
008510  8A                    DB     0x8A ; DATA_BYTE
