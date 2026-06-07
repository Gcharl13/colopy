; ============================================================================
; func_04CFC4_unknown
; Region   : load_image
; Bytes    : file 0x04CFC4..0x04D01B  (87 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04CFC4  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
04CFC8  6A 06                 PUSH   6                            ; UNKNOWN
04CFCA  0E                    PUSH   cs                           ; UNKNOWN
04CFCB  E8 94 E1              CALL   0x4b162                      ; UNKNOWN
04CFCE  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04CFD1  68 90 00              PUSH   0x90                         ; UNKNOWN
04CFD4  6A 05                 PUSH   5                            ; UNKNOWN
04CFD6  68 40 01              PUSH   0x140                        ; UNKNOWN
04CFD9  6A 00                 PUSH   0                            ; UNKNOWN
04CFDB  FF 36 60 33           PUSH   word ptr [0x3360]            ; UNKNOWN
04CFDF  9A 6C 00 E6 21        LCALL  0x21e6, 0x6c                 ; UNKNOWN
04CFE4  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04CFE7  52                    PUSH   dx                           ; UNKNOWN
04CFE8  50                    PUSH   ax                           ; UNKNOWN
04CFE9  9A 1E 03 13 24        LCALL  0x2413, 0x31e                ; UNKNOWN
04CFEE  83 C4 0C              ADD    sp, 0xc                      ; UNKNOWN
04CFF1  C4 1E B4 09           LES    bx, ptr [0x9b4]              ; UNKNOWN
04CFF5  26 8A 07              MOV    al, byte ptr es:[bx]         ; UNKNOWN
04CFF8  2A E4                 SUB    ah, ah                       ; UNKNOWN
04CFFA  83 C0 06              ADD    ax, 6                        ; UNKNOWN
04CFFD  68 91 00              PUSH   0x91                         ; UNKNOWN
04D000  50                    PUSH   ax                           ; UNKNOWN
04D001  68 40 01              PUSH   0x140                        ; UNKNOWN
04D004  6A 00                 PUSH   0                            ; UNKNOWN
04D006  FF 36 9A 34           PUSH   word ptr [0x349a]            ; UNKNOWN
04D00A  9A 6C 00 E6 21        LCALL  0x21e6, 0x6c                 ; UNKNOWN
04D00F  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04D012  52                    PUSH   dx                           ; UNKNOWN
04D013  50                    PUSH   ax                           ; UNKNOWN
04D014  9A 1E 03 13 24        LCALL  0x2413, 0x31e                ; UNKNOWN
04D019  C9                    LEAVE                               ; UNKNOWN
04D01A  CB                    RETF                                ; UNKNOWN
