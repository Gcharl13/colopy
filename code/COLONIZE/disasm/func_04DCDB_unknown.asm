; ============================================================================
; func_04DCDB_unknown
; Region   : load_image
; Bytes    : file 0x04DCDB..0x04DCE7  (12 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04DCDB  55                    PUSH   bp                           ; UNKNOWN
04DCDC  8B EC                 MOV    bp, sp                       ; UNKNOWN
04DCDE  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
04DCE1  0B DB                 OR     bx, bx                       ; UNKNOWN
04DCE3  7F 07                 JG     0x4dcec                      ; UNKNOWN
04DCE5  8B C3                 MOV    ax, bx                       ; UNKNOWN
