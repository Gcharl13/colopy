; ============================================================================
; func_021AA6_unknown
; Region   : load_image
; Bytes    : file 0x021AA6..0x021AC1  (27 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

021AA6  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
021AAA  57                    PUSH   di                           ; UNKNOWN
021AAB  56                    PUSH   si                           ; UNKNOWN
021AAC  2B C9                 SUB    cx, cx                       ; UNKNOWN
021AAE  2B C0                 SUB    ax, ax                       ; UNKNOWN
021AB0  99                    CDQ                                 ; UNKNOWN
021AB1  8B F8                 MOV    di, ax                       ; UNKNOWN
021AB3  89 56 FE              MOV    word ptr [bp - 2], dx        ; UNKNOWN
021AB6  C4 76 06              LES    si, ptr [bp + 6]             ; UNKNOWN
021AB9  26 C5 5C 38           LDS    bx, ptr es:[si + 0x38]       ; UNKNOWN
021ABD  8C D8                 MOV    ax, ds                       ; UNKNOWN
021ABF  0B C3                 OR     ax, bx                       ; UNKNOWN
