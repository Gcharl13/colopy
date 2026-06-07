; ============================================================================
; func_04A5AC_unknown
; Region   : load_image
; Bytes    : file 0x04A5AC..0x04A5FC  (80 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04A5AC  C8 6C 00 00           ENTER  0x6c, 0                      ; UNKNOWN
04A5B0  56                    PUSH   si                           ; UNKNOWN
04A5B1  0E                    PUSH   cs                           ; UNKNOWN
04A5B2  E8 88 E8              CALL   0x48e3d                      ; UNKNOWN
04A5B5  A0 63 09              MOV    al, byte ptr [0x963]         ; UNKNOWN
04A5B8  2A E4                 SUB    ah, ah                       ; UNKNOWN
04A5BA  50                    PUSH   ax                           ; UNKNOWN
04A5BB  6A 05                 PUSH   5                            ; UNKNOWN
04A5BD  68 40 01              PUSH   0x140                        ; UNKNOWN
04A5C0  6A 00                 PUSH   0                            ; UNKNOWN
04A5C2  FF 36 D2 33           PUSH   word ptr [0x33d2]            ; UNKNOWN
04A5C6  9A 6C 00 E6 21        LCALL  0x21e6, 0x6c                 ; UNKNOWN
04A5CB  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04A5CE  52                    PUSH   dx                           ; UNKNOWN
04A5CF  50                    PUSH   ax                           ; UNKNOWN
04A5D0  9A 1E 03 13 24        LCALL  0x2413, 0x31e                ; UNKNOWN
04A5D5  83 C4 0C              ADD    sp, 0xc                      ; UNKNOWN
04A5D8  C4 1E B4 09           LES    bx, ptr [0x9b4]              ; UNKNOWN
04A5DC  26 8A 07              MOV    al, byte ptr es:[bx]         ; UNKNOWN
04A5DF  2A E4                 SUB    ah, ah                       ; UNKNOWN
04A5E1  83 C0 07              ADD    ax, 7                        ; UNKNOWN
04A5E4  89 46 A6              MOV    word ptr [bp - 0x5a], ax     ; UNKNOWN
04A5E7  C6 46 AC 00           MOV    byte ptr [bp - 0x54], 0      ; UNKNOWN
04A5EB  8D 46 AC              LEA    ax, [bp - 0x54]              ; UNKNOWN
04A5EE  50                    PUSH   ax                           ; UNKNOWN
04A5EF  9A 7D 00 13 24        LCALL  0x2413, 0x7d                 ; UNKNOWN
04A5F4  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04A5F7  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
04A5FA  8B C3                 MOV    ax, bx                       ; UNKNOWN
