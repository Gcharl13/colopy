; ============================================================================
; func_036B34_unknown
; Region   : overlay
; Bytes    : file 0x036B34..0x036B40  (12 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

036B34  C8 27 00 00           ENTER  0x27, 0 ; PROLOGUE
036B38  7C 27                 JL     0x36b61 ; CJUMP
036B3A  00 00                 ADD    byte ptr [bx + si], al ; ARITH
036B3C  20 27                 AND    byte ptr [bx], ah ; LOGIC
036B3E  00 00                 ADD    byte ptr [bx + si], al ; ARITH
