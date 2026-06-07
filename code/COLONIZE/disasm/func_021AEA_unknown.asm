; ============================================================================
; func_021AEA_unknown
; Region   : load_image
; Bytes    : file 0x021AEA..0x021B0E  (36 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

021AEA  C8 18 00 00           ENTER  0x18, 0                      ; UNKNOWN
021AEE  57                    PUSH   di                           ; UNKNOWN
021AEF  56                    PUSH   si                           ; UNKNOWN
021AF0  2B C9                 SUB    cx, cx                       ; UNKNOWN
021AF2  2B C0                 SUB    ax, ax                       ; UNKNOWN
021AF4  89 46 EA              MOV    word ptr [bp - 0x16], ax     ; UNKNOWN
021AF7  89 46 E8              MOV    word ptr [bp - 0x18], ax     ; UNKNOWN
021AFA  C4 76 06              LES    si, ptr [bp + 6]             ; UNKNOWN
021AFD  26 8B 44 38           MOV    ax, word ptr es:[si + 0x38]  ; UNKNOWN
021B01  26 8B 54 3A           MOV    dx, word ptr es:[si + 0x3a]  ; UNKNOWN
021B05  8B D8                 MOV    bx, ax                       ; UNKNOWN
021B07  89 56 F2              MOV    word ptr [bp - 0xe], dx      ; UNKNOWN
021B0A  8B C2                 MOV    ax, dx                       ; UNKNOWN
021B0C  0B C3                 OR     ax, bx                       ; UNKNOWN
