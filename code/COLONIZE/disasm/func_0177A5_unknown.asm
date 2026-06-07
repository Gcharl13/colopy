; ============================================================================
; func_0177A5_unknown
; Region   : load_image
; Bytes    : file 0x0177A5..0x0177DB  (54 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0177A5  55                    PUSH   bp                           ; UNKNOWN
0177A6  8B EC                 MOV    bp, sp                       ; UNKNOWN
0177A8  FF 36 90 CE           PUSH   word ptr [0xce90]            ; UNKNOWN
0177AC  FF 36 8E CE           PUSH   word ptr [0xce8e]            ; UNKNOWN
0177B0  FF 36 8C CE           PUSH   word ptr [0xce8c]            ; UNKNOWN
0177B4  FF 36 8A CE           PUSH   word ptr [0xce8a]            ; UNKNOWN
0177B8  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
0177BC  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
0177C0  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
0177C4  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
0177C8  FF 76 0C              PUSH   word ptr [bp + 0xc]          ; UNKNOWN
0177CB  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
0177CE  8B 56 08              MOV    dx, word ptr [bp + 8]        ; UNKNOWN
0177D1  8B 5E 0A              MOV    bx, word ptr [bp + 0xa]      ; UNKNOWN
0177D4  9A 04 00 49 5A        LCALL  0x5a49, 4                    ; UNKNOWN
0177D9  C9                    LEAVE                               ; UNKNOWN
0177DA  CB                    RETF                                ; UNKNOWN
