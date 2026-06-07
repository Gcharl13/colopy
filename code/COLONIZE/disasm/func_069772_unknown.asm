; ============================================================================
; func_069772_unknown
; Region   : load_image
; Bytes    : file 0x069772..0x069780  (14 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

069772  55                    PUSH   bp                           ; UNKNOWN
069773  8B EC                 MOV    bp, sp                       ; UNKNOWN
069775  8B 56 06              MOV    dx, word ptr [bp + 6]        ; UNKNOWN
069778  B4 41                 MOV    ah, 0x41                     ; UNKNOWN
06977A  CD 21                 INT    0x21                         ; UNKNOWN
06977C  E9 DD 06              JMP    0x69e5c                      ; UNKNOWN
06977F  00                    DB     0x00                         ; UNKNOWN (raw)
