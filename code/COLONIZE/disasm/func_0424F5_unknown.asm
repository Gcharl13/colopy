; ============================================================================
; func_0424F5_unknown
; Region   : load_image
; Bytes    : file 0x0424F5..0x042513  (30 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0424F5  C8 08 00 00           ENTER  8, 0                         ; UNKNOWN
0424F9  B8 FF FF              MOV    ax, 0xffff                   ; UNKNOWN
0424FC  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
0424FF  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
042502  69 5E 06 3C 01        IMUL   bx, word ptr [bp + 6], 0x13c ; UNKNOWN
042507  80 BF BE 74 19        CMP    byte ptr [bx + 0x74be], 0x19 ; UNKNOWN
04250C  72 05                 JB     0x42513                      ; UNKNOWN
04250E  B8 05 00              MOV    ax, 5                        ; UNKNOWN
042511  C9                    LEAVE                               ; UNKNOWN
042512  CB                    RETF                                ; UNKNOWN
