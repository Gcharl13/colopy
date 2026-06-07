; ============================================================================
; func_041196_unknown
; Region   : load_image
; Bytes    : file 0x041196..0x0411B8  (34 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

041196  55                    PUSH   bp                           ; UNKNOWN
041197  8B EC                 MOV    bp, sp                       ; UNKNOWN
041199  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
04119C  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
04119F  9A 02 00 C9 33        LCALL  0x33c9, 2                    ; UNKNOWN
0411A4  8B E5                 MOV    sp, bp                       ; UNKNOWN
0411A6  0B C0                 OR     ax, ax                       ; UNKNOWN
0411A8  74 0C                 JE     0x411b6                      ; UNKNOWN
0411AA  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
0411AD  A3 8E 82              MOV    word ptr [0x828e], ax        ; UNKNOWN
0411B0  8B 46 08              MOV    ax, word ptr [bp + 8]        ; UNKNOWN
0411B3  A3 8C 82              MOV    word ptr [0x828c], ax        ; UNKNOWN
0411B6  C9                    LEAVE                               ; UNKNOWN
0411B7  CB                    RETF                                ; UNKNOWN
