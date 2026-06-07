; ============================================================================
; func_00F281_unknown
; Region   : load_image
; Bytes    : file 0x00F281..0x00F290  (15 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00F281  C8 74 0E 03           ENTER  0xe74, 3 ; PROLOGUE
00F285  DF 79 08              FISTP  qword ptr [bx + di + 8]      ; UNKNOWN
00F288  81 EB 00 70           SUB    bx, 0x7000 ; ARITH
00F28C  81 C2 00 07           ADD    dx, 0x700 ; ARITH
