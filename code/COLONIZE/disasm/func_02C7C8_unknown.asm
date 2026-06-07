; ============================================================================
; func_02C7C8_unknown
; Region   : load_image
; Bytes    : file 0x02C7C8..0x02C7DD  (21 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02C7C8  C8 06 00 00           ENTER  6, 0                         ; UNKNOWN
02C7CC  56                    PUSH   si                           ; UNKNOWN
02C7CD  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
02C7D0  40                    INC    ax                           ; UNKNOWN
02C7D1  B9 03 00              MOV    cx, 3                        ; UNKNOWN
02C7D4  8B D8                 MOV    bx, ax                       ; UNKNOWN
02C7D6  99                    CDQ                                 ; UNKNOWN
02C7D7  F7 F9                 IDIV   cx                           ; UNKNOWN
02C7D9  8B D0                 MOV    dx, ax                       ; UNKNOWN
02C7DB  8B C3                 MOV    ax, bx                       ; UNKNOWN
