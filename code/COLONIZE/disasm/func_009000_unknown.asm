; ============================================================================
; func_009000_unknown
; Region   : load_image
; Bytes    : file 0x009000..0x009010  (16 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

009000  55                    PUSH   bp                           ; UNKNOWN
009001  8B EC                 MOV    bp, sp                       ; UNKNOWN
009003  68 88 12              PUSH   0x1288                       ; UNKNOWN
009006  FF 76 04              PUSH   word ptr [bp + 4]            ; UNKNOWN
009009  9A 6E 09 65 5F        LCALL  0x5f65, 0x96e                ; UNKNOWN
00900E  C9                    LEAVE                               ; UNKNOWN
00900F  C3                    RET                                 ; UNKNOWN
