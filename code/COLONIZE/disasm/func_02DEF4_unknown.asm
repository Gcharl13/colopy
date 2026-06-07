; ============================================================================
; func_02DEF4_unknown
; Region   : load_image
; Bytes    : file 0x02DEF4..0x02DF01  (13 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02DEF4  55                    PUSH   bp                           ; UNKNOWN
02DEF5  8B EC                 MOV    bp, sp                       ; UNKNOWN
02DEF7  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
02DEFA  8A 87 A6 0A           MOV    al, byte ptr [bx + 0xaa6]    ; UNKNOWN
02DEFE  98                    CWDE                                ; UNKNOWN
02DEFF  C9                    LEAVE                               ; UNKNOWN
02DF00  CB                    RETF                                ; UNKNOWN
