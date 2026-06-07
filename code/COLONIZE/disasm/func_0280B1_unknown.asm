; ============================================================================
; func_0280B1_unknown
; Region   : load_image
; Bytes    : file 0x0280B1..0x0280C9  (24 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0280B1  55                    PUSH   bp                           ; UNKNOWN
0280B2  8B EC                 MOV    bp, sp                       ; UNKNOWN
0280B4  8B 46 08              MOV    ax, word ptr [bp + 8]        ; UNKNOWN
0280B7  A3 06 0A              MOV    word ptr [0xa06], ax         ; UNKNOWN
0280BA  8D 1E 86 09           LEA    bx, [0x986]                  ; UNKNOWN
0280BE  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
0280C1  2B D2                 SUB    dx, dx                       ; UNKNOWN
0280C3  0E                    PUSH   cs                           ; UNKNOWN
0280C4  E8 18 FF              CALL   0x27fdf                      ; UNKNOWN
0280C7  C9                    LEAVE                               ; UNKNOWN
0280C8  CB                    RETF                                ; UNKNOWN
