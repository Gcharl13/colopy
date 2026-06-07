; ============================================================================
; func_02B022_unknown
; Region   : load_image
; Bytes    : file 0x02B022..0x02B03B  (25 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02B022  55                    PUSH   bp                           ; UNKNOWN
02B023  8B EC                 MOV    bp, sp                       ; UNKNOWN
02B025  8B 56 06              MOV    dx, word ptr [bp + 6]        ; UNKNOWN
02B028  0B D2                 OR     dx, dx                       ; UNKNOWN
02B02A  7D 04                 JGE    0x2b030                      ; UNKNOWN
02B02C  8B 56 08              MOV    dx, word ptr [bp + 8]        ; UNKNOWN
02B02F  4A                    DEC    dx                           ; UNKNOWN
02B030  39 56 08              CMP    word ptr [bp + 8], dx        ; UNKNOWN
02B033  7F 02                 JG     0x2b037                      ; UNKNOWN
02B035  2B D2                 SUB    dx, dx                       ; UNKNOWN
02B037  8B C2                 MOV    ax, dx                       ; UNKNOWN
02B039  C9                    LEAVE                               ; UNKNOWN
02B03A  CB                    RETF                                ; UNKNOWN
