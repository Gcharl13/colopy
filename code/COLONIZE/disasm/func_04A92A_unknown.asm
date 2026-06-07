; ============================================================================
; func_04A92A_unknown
; Region   : load_image
; Bytes    : file 0x04A92A..0x04A97A  (80 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04A92A  C8 58 00 00           ENTER  0x58, 0                      ; UNKNOWN
04A92E  56                    PUSH   si                           ; UNKNOWN
04A92F  0E                    PUSH   cs                           ; UNKNOWN
04A930  E8 0A E5              CALL   0x48e3d                      ; UNKNOWN
04A933  A0 63 09              MOV    al, byte ptr [0x963]         ; UNKNOWN
04A936  2A E4                 SUB    ah, ah                       ; UNKNOWN
04A938  50                    PUSH   ax                           ; UNKNOWN
04A939  6A 05                 PUSH   5                            ; UNKNOWN
04A93B  68 40 01              PUSH   0x140                        ; UNKNOWN
04A93E  6A 00                 PUSH   0                            ; UNKNOWN
04A940  FF 36 D2 33           PUSH   word ptr [0x33d2]            ; UNKNOWN
04A944  9A 6C 00 E6 21        LCALL  0x21e6, 0x6c                 ; UNKNOWN
04A949  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04A94C  52                    PUSH   dx                           ; UNKNOWN
04A94D  50                    PUSH   ax                           ; UNKNOWN
04A94E  9A 1E 03 13 24        LCALL  0x2413, 0x31e                ; UNKNOWN
04A953  83 C4 0C              ADD    sp, 0xc                      ; UNKNOWN
04A956  C4 1E B4 09           LES    bx, ptr [0x9b4]              ; UNKNOWN
04A95A  26 8A 07              MOV    al, byte ptr es:[bx]         ; UNKNOWN
04A95D  2A E4                 SUB    ah, ah                       ; UNKNOWN
04A95F  83 C0 07              ADD    ax, 7                        ; UNKNOWN
04A962  89 46 AA              MOV    word ptr [bp - 0x56], ax     ; UNKNOWN
04A965  C6 46 B0 00           MOV    byte ptr [bp - 0x50], 0      ; UNKNOWN
04A969  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
04A96C  50                    PUSH   ax                           ; UNKNOWN
04A96D  9A 7D 00 13 24        LCALL  0x2413, 0x7d                 ; UNKNOWN
04A972  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04A975  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
04A978  8B C3                 MOV    ax, bx                       ; UNKNOWN
