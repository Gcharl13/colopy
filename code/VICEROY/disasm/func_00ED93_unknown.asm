; ============================================================================
; func_00ED93_unknown
; Region   : load_image
; Bytes    : file 0x00ED93..0x00EDA2  (15 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00ED93  C8 74 0E 03           ENTER  0xe74, 3 ; PROLOGUE
00ED97  DF 79 08              FISTP  qword ptr [bx + di + 8]      ; UNKNOWN
00ED9A  81 EB 00 70           SUB    bx, 0x7000 ; ARITH
00ED9E  81 C2 00 07           ADD    dx, 0x700 ; ARITH
