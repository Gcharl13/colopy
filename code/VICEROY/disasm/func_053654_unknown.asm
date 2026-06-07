; ============================================================================
; func_053654_unknown
; Region   : overlay
; Bytes    : file 0x053654..0x053663  (15 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

053654  C8 0D 00 00           ENTER  0xd, 0 ; PROLOGUE
053658  8B 0B                 MOV    cx, word ptr [bp + di] ; LOCAL_LOAD
05365A  00 00                 ADD    byte ptr [bx + si], al ; ARITH
05365C  D0 17                 RCL    byte ptr [bx] ; LOGIC
05365E  00 00                 ADD    byte ptr [bx + si], al ; ARITH
053660  C2 03 00              RET    3 ; RETURN
