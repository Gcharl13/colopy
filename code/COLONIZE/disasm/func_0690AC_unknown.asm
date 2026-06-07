; ============================================================================
; func_0690AC_unknown
; Region   : load_image
; Bytes    : file 0x0690AC..0x0690CD  (33 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0690AC  55                    PUSH   bp                           ; UNKNOWN
0690AD  8B EC                 MOV    bp, sp                       ; UNKNOWN
0690AF  57                    PUSH   di                           ; UNKNOWN
0690B0  56                    PUSH   si                           ; UNKNOWN
0690B1  8B 76 06              MOV    si, word ptr [bp + 6]        ; UNKNOWN
0690B4  8A 44 07              MOV    al, byte ptr [si + 7]        ; UNKNOWN
0690B7  2A E4                 SUB    ah, ah                       ; UNKNOWN
0690B9  8B F8                 MOV    di, ax                       ; UNKNOWN
0690BB  56                    PUSH   si                           ; UNKNOWN
0690BC  9A 18 06 65 5F        LCALL  0x5f65, 0x618                ; UNKNOWN
0690C1  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0690C4  80 A5 47 12 FD        AND    byte ptr [di + 0x1247], 0xfd ; UNKNOWN
0690C9  80 64 06 CF           AND    byte ptr [si + 6], 0xcf      ; UNKNOWN
