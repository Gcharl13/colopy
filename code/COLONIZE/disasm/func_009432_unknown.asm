; ============================================================================
; func_009432_unknown
; Region   : load_image
; Bytes    : file 0x009432..0x009446  (20 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

009432  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
009436  8D 46 FC              LEA    ax, [bp - 4]                 ; UNKNOWN
009439  50                    PUSH   ax                           ; UNKNOWN
00943A  E8 E1 FF              CALL   0x941e                       ; UNKNOWN
00943D  0B C0                 OR     ax, ax                       ; UNKNOWN
00943F  74 05                 JE     0x9446                       ; UNKNOWN
009441  8A 46 FC              MOV    al, byte ptr [bp - 4]        ; UNKNOWN
009444  C9                    LEAVE                               ; UNKNOWN
009445  CB                    RETF                                ; UNKNOWN
