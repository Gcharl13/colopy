; ============================================================================
; func_068A14_unknown
; Region   : overlay
; Bytes    : file 0x068A14..0x068A23  (15 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

068A14  C8 10 00 00           ENTER  0x10, 0 ; PROLOGUE
068A18  9E                    SAHF ; FLAG
068A19  10 00                 ADC    byte ptr [bx + si], al ; ARITH
068A1B  00 E1                 ADD    cl, ah ; ARITH
068A1D  18 00                 SBB    byte ptr [bx + si], al ; ARITH
068A1F  00 CA                 ADD    dl, cl ; ARITH
068A21  05                    DB     0x05 ; DATA_BYTE
068A22  00                    DB     0x00 ; DATA_BYTE
