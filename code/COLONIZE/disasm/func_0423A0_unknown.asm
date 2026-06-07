; ============================================================================
; func_0423A0_unknown
; Region   : load_image
; Bytes    : file 0x0423A0..0x0423C1  (33 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0423A0  C8 06 00 00           ENTER  6, 0                         ; UNKNOWN
0423A4  8A 4E 08              MOV    cl, byte ptr [bp + 8]        ; UNKNOWN
0423A7  80 E1 07              AND    cl, 7                        ; UNKNOWN
0423AA  B8 01 00              MOV    ax, 1                        ; UNKNOWN
0423AD  D3 E0                 SHL    ax, cl                       ; UNKNOWN
0423AF  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
0423B2  8B 4E 08              MOV    cx, word ptr [bp + 8]        ; UNKNOWN
0423B5  C1 F9 03              SAR    cx, 3                        ; UNKNOWN
0423B8  69 56 06 3C 01        IMUL   dx, word ptr [bp + 6], 0x13c ; UNKNOWN
0423BD  03 CA                 ADD    cx, dx                       ; UNKNOWN
0423BF  81                    DB     0x81                         ; UNKNOWN (raw)
0423C0  C1                    DB     0xC1                         ; UNKNOWN (raw)
