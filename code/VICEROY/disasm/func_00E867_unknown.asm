; ============================================================================
; func_00E867_unknown
; Region   : load_image
; Bytes    : file 0x00E867..0x00E876  (15 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00E867  C8 74 0E 03           ENTER  0xe74, 3 ; PROLOGUE
00E86B  DF 79 08              FISTP  qword ptr [bx + di + 8]      ; UNKNOWN
00E86E  81 EB 00 70           SUB    bx, 0x7000 ; ARITH
00E872  81 C2 00 07           ADD    dx, 0x700 ; ARITH
