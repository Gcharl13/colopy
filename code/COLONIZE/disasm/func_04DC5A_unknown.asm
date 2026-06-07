; ============================================================================
; func_04DC5A_unknown
; Region   : load_image
; Bytes    : file 0x04DC5A..0x04DC69  (15 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04DC5A  55                    PUSH   bp                           ; UNKNOWN
04DC5B  8B EC                 MOV    bp, sp                       ; UNKNOWN
04DC5D  57                    PUSH   di                           ; UNKNOWN
04DC5E  8B 56 06              MOV    dx, word ptr [bp + 6]        ; UNKNOWN
04DC61  0B D2                 OR     dx, dx                       ; UNKNOWN
04DC63  7F 07                 JG     0x4dc6c                      ; UNKNOWN
04DC65  8B C2                 MOV    ax, dx                       ; UNKNOWN
04DC67  F7 D0                 NOT    ax                           ; UNKNOWN
