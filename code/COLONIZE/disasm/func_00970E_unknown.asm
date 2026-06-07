; ============================================================================
; func_00970E_unknown
; Region   : load_image
; Bytes    : file 0x00970E..0x009731  (35 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00970E  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
009712  53                    PUSH   bx                           ; UNKNOWN
009713  0B DB                 OR     bx, bx                       ; UNKNOWN
009715  74 09                 JE     0x9720                       ; UNKNOWN
009717  8D 46 FC              LEA    ax, [bp - 4]                 ; UNKNOWN
00971A  50                    PUSH   ax                           ; UNKNOWN
00971B  FF 76 FA              PUSH   word ptr [bp - 6]            ; UNKNOWN
00971E  EB 06                 JMP    0x9726                       ; UNKNOWN
009720  8D 46 FC              LEA    ax, [bp - 4]                 ; UNKNOWN
009723  50                    PUSH   ax                           ; UNKNOWN
009724  6A 00                 PUSH   0                            ; UNKNOWN
009726  E8 2B FF              CALL   0x9654                       ; UNKNOWN
009729  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
00972C  8B 56 FE              MOV    dx, word ptr [bp - 2]        ; UNKNOWN
00972F  C9                    LEAVE                               ; UNKNOWN
009730  CB                    RETF                                ; UNKNOWN
