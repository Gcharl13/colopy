; ============================================================================
; func_0280DA_unknown
; Region   : load_image
; Bytes    : file 0x0280DA..0x0280F2  (24 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0280DA  55                    PUSH   bp                           ; UNKNOWN
0280DB  8B EC                 MOV    bp, sp                       ; UNKNOWN
0280DD  8B 46 08              MOV    ax, word ptr [bp + 8]        ; UNKNOWN
0280E0  A3 08 0A              MOV    word ptr [0xa08], ax         ; UNKNOWN
0280E3  8D 1E 86 09           LEA    bx, [0x986]                  ; UNKNOWN
0280E7  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
0280EA  2B D2                 SUB    dx, dx                       ; UNKNOWN
0280EC  0E                    PUSH   cs                           ; UNKNOWN
0280ED  E8 EF FE              CALL   0x27fdf                      ; UNKNOWN
0280F0  C9                    LEAVE                               ; UNKNOWN
0280F1  CB                    RETF                                ; UNKNOWN
