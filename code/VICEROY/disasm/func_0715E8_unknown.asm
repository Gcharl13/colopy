; ============================================================================
; func_0715E8_unknown
; Region   : overlay
; Bytes    : file 0x0715E8..0x071623  (59 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0715E8  C8 08 00 00           ENTER  8, 0 ; PROLOGUE
0715EC  AD                    LODSW  ax, word ptr [si] ; STR
0715ED  08 00                 OR     byte ptr [bx + si], al ; LOGIC
0715EF  00 95 08 00           ADD    byte ptr [di + 8], dl ; ARITH
0715F3  00 7A 08              ADD    byte ptr [bp + si + 8], bh ; ARITH
0715F6  00 00                 ADD    byte ptr [bx + si], al ; ARITH
0715F8  31 08                 XOR    word ptr [bx + si], cx ; LOGIC
0715FA  00 00                 ADD    byte ptr [bx + si], al ; ARITH
0715FC  16                    PUSH   ss ; STACK_PUSH
0715FD  08 00                 OR     byte ptr [bx + si], al ; LOGIC
0715FF  00 FB                 ADD    bl, bh ; ARITH
071601  07                    POP    es ; STACK_POP
071602  00 00                 ADD    byte ptr [bx + si], al ; ARITH
071604  B2 07                 MOV    dl, 7 ; MOV
071606  00 00                 ADD    byte ptr [bx + si], al ; ARITH
071608  97                    XCHG   di, ax ; MOV
071609  07                    POP    es ; STACK_POP
07160A  00 00                 ADD    byte ptr [bx + si], al ; ARITH
07160C  7F 07                 JG     0x71615 ; CJUMP
07160E  00 00                 ADD    byte ptr [bx + si], al ; ARITH
071610  64 07                 POP    es ; STACK_POP
071612  00 00                 ADD    byte ptr [bx + si], al ; ARITH
071614  17                    POP    ss ; STACK_POP
071615  00 00                 ADD    byte ptr [bx + si], al ; ARITH
071617  00 22                 ADD    byte ptr [bp + si], ah ; ARITH
071619  0B 00                 OR     ax, word ptr [bx + si] ; LOGIC
07161B  00 9C 03 00           ADD    byte ptr [si + 3], bl ; ARITH
07161F  00 CA                 ADD    dl, cl ; ARITH
071621  01 00                 ADD    word ptr [bx + si], ax ; ARITH
