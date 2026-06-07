; ============================================================================
; func_02D831_unknown
; Region   : load_image
; Bytes    : file 0x02D831..0x02D846  (21 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02D831  55                    PUSH   bp                           ; UNKNOWN
02D832  8B EC                 MOV    bp, sp                       ; UNKNOWN
02D834  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
02D837  0E                    PUSH   cs                           ; UNKNOWN
02D838  E8 CE FF              CALL   0x2d809                      ; UNKNOWN
02D83B  8B D8                 MOV    bx, ax                       ; UNKNOWN
02D83D  C1 E3 03              SHL    bx, 3                        ; UNKNOWN
02D840  8B 87 35 38           MOV    ax, word ptr [bx + 0x3835]   ; UNKNOWN
02D844  C9                    LEAVE                               ; UNKNOWN
02D845  CB                    RETF                                ; UNKNOWN
