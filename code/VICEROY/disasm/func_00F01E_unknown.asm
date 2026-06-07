; ============================================================================
; func_00F01E_unknown
; Region   : load_image
; Bytes    : file 0x00F01E..0x00F02D  (15 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00F01E  C8 74 0E 03           ENTER  0xe74, 3 ; PROLOGUE
00F022  DF 79 08              FISTP  qword ptr [bx + di + 8]      ; UNKNOWN
00F025  81 EB 00 70           SUB    bx, 0x7000 ; ARITH
00F029  81 C2 00 07           ADD    dx, 0x700 ; ARITH
