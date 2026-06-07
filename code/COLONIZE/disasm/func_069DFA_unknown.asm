; ============================================================================
; func_069DFA_unknown
; Region   : load_image
; Bytes    : file 0x069DFA..0x069E0C  (18 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

069DFA  55                    PUSH   bp                           ; UNKNOWN
069DFB  8B EC                 MOV    bp, sp                       ; UNKNOWN
069DFD  56                    PUSH   si                           ; UNKNOWN
069DFE  57                    PUSH   di                           ; UNKNOWN
069DFF  1E                    PUSH   ds                           ; UNKNOWN
069E00  07                    POP    es                           ; UNKNOWN
069E01  8B 56 06              MOV    dx, word ptr [bp + 6]        ; UNKNOWN
069E04  BE EE 30              MOV    si, 0x30ee                   ; UNKNOWN
069E07  AD                    LODSW  ax, word ptr [si]            ; UNKNOWN
069E08  3B C2                 CMP    ax, dx                       ; UNKNOWN
069E0A  74 10                 JE     0x69e1c                      ; UNKNOWN
