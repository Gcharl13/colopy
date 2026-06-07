; ============================================================================
; func_036459_unknown
; Region   : load_image
; Bytes    : file 0x036459..0x03648E  (53 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

036459  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
03645D  56                    PUSH   si                           ; UNKNOWN
03645E  FF 36 AC 79           PUSH   word ptr [0x79ac]            ; UNKNOWN
036462  0E                    PUSH   cs                           ; UNKNOWN
036463  E8 7B D0              CALL   0x334e1                      ; UNKNOWN
036466  83 C4 02              ADD    sp, 2                        ; UNKNOWN
036469  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
03646C  6A 01                 PUSH   1                            ; UNKNOWN
03646E  9A BD 00 2B 3E        LCALL  0x3e2b, 0xbd                 ; UNKNOWN
036473  83 C4 02              ADD    sp, 2                        ; UNKNOWN
036476  8B 1E 9A 79           MOV    bx, word ptr [0x799a]        ; UNKNOWN
03647A  D1 E3                 SHL    bx, 1                        ; UNKNOWN
03647C  FF B7 F3 37           PUSH   word ptr [bx + 0x37f3]       ; UNKNOWN
036480  9A A9 01 2B 3E        LCALL  0x3e2b, 0x1a9                ; UNKNOWN
036485  83 C4 02              ADD    sp, 2                        ; UNKNOWN
036488  6B 5E FE 1C           IMUL   bx, word ptr [bp - 2], 0x1c  ; UNKNOWN
03648C  8B C3                 MOV    ax, bx                       ; UNKNOWN
