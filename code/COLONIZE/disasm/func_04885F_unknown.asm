; ============================================================================
; func_04885F_unknown
; Region   : load_image
; Bytes    : file 0x04885F..0x048874  (21 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04885F  C8 3E 00 00           ENTER  0x3e, 0                      ; UNKNOWN
048863  56                    PUSH   si                           ; UNKNOWN
048864  C7 46 EE 01 00        MOV    word ptr [bp - 0x12], 1      ; UNKNOWN
048869  C7 46 E6 FF FF        MOV    word ptr [bp - 0x1a], 0xffff ; UNKNOWN
04886E  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
048872  8B C3                 MOV    ax, bx                       ; UNKNOWN
