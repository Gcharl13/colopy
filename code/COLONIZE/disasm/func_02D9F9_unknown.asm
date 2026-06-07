; ============================================================================
; func_02D9F9_unknown
; Region   : load_image
; Bytes    : file 0x02D9F9..0x02DA0B  (18 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02D9F9  55                    PUSH   bp                           ; UNKNOWN
02D9FA  8B EC                 MOV    bp, sp                       ; UNKNOWN
02D9FC  EB 08                 JMP    0x2da06                      ; UNKNOWN
02D9FE  8A 87 17 39           MOV    al, byte ptr [bx + 0x3917]   ; UNKNOWN
02DA02  98                    CWDE                                ; UNKNOWN
02DA03  89 46 06              MOV    word ptr [bp + 6], ax        ; UNKNOWN
02DA06  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
02DA09  8B C3                 MOV    ax, bx                       ; UNKNOWN
