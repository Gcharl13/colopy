; ============================================================================
; func_05FC30_unknown
; Region   : overlay
; Bytes    : file 0x05FC30..0x05FC43  (19 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

05FC30  C8 0A 00 00           ENTER  0xa, 0 ; PROLOGUE
05FC34  69 0A 00 00           IMUL   cx, word ptr [bp + si], 0 ; ARITH
05FC38  18 0A                 SBB    byte ptr [bp + si], cl ; ARITH
05FC3A  00 00                 ADD    byte ptr [bx + si], al ; ARITH
05FC3C  13 13                 ADC    dx, word ptr [bp + di] ; ARITH
05FC3E  00 00                 ADD    byte ptr [bx + si], al ; ARITH
05FC40  CA 08 00              RETF   8 ; RETURN
