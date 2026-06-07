; ============================================================================
; func_0347D3_unknown
; Region   : load_image
; Bytes    : file 0x0347D3..0x0347F3  (32 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0347D3  55                    PUSH   bp                           ; UNKNOWN
0347D4  8B EC                 MOV    bp, sp                       ; UNKNOWN
0347D6  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
0347D9  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
0347DC  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
0347DF  9A 49 02 2B 3E        LCALL  0x3e2b, 0x249                ; UNKNOWN
0347E4  8B E5                 MOV    sp, bp                       ; UNKNOWN
0347E6  6A 00                 PUSH   0                            ; UNKNOWN
0347E8  6A 00                 PUSH   0                            ; UNKNOWN
0347EA  6A 01                 PUSH   1                            ; UNKNOWN
0347EC  9A D0 02 2B 3E        LCALL  0x3e2b, 0x2d0                ; UNKNOWN
0347F1  C9                    LEAVE                               ; UNKNOWN
0347F2  CB                    RETF                                ; UNKNOWN
