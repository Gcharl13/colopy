; ============================================================================
; func_0698BC_unknown
; Region   : load_image
; Bytes    : file 0x0698BC..0x0698D5  (25 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0698BC  55                    PUSH   bp                           ; UNKNOWN
0698BD  8B EC                 MOV    bp, sp                       ; UNKNOWN
0698BF  8B 46 08              MOV    ax, word ptr [bp + 8]        ; UNKNOWN
0698C2  8B 4E 0C              MOV    cx, word ptr [bp + 0xc]      ; UNKNOWN
0698C5  0B C8                 OR     cx, ax                       ; UNKNOWN
0698C7  8B 4E 0A              MOV    cx, word ptr [bp + 0xa]      ; UNKNOWN
0698CA  75 09                 JNE    0x698d5                      ; UNKNOWN
0698CC  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
0698CF  F7 E1                 MUL    cx                           ; UNKNOWN
0698D1  5D                    POP    bp                           ; UNKNOWN
0698D2  CA 08 00              RETF   8                            ; UNKNOWN
