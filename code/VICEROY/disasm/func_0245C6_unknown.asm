; ============================================================================
; func_0245C6_unknown
; Region   : overlay
; Bytes    : file 0x0245C6..0x0245DC  (22 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0245C6  C8 08 00 00           ENTER  8, 0 ; PROLOGUE
0245CA  83 3E F4 07 00        CMP    word ptr [0x7f4], 0 ; CMP
0245CF  74 5E                 JE     0x2462f ; CJUMP
0245D1  A1 EA 07              MOV    ax, word ptr [0x7ea] ; GLOBAL_LOAD
0245D4  2D 09 00              SUB    ax, 9 ; ARITH
0245D7  03 06 CA 9C           ADD    ax, word ptr [0x9cca] ; ARITH
0245DB  89                    DB     0x89 ; DATA_BYTE
