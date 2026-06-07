; ============================================================================
; func_042374_unknown
; Region   : load_image
; Bytes    : file 0x042374..0x04239F  (43 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

042374  55                    PUSH   bp                           ; UNKNOWN
042375  8B EC                 MOV    bp, sp                       ; UNKNOWN
042377  53                    PUSH   bx                           ; UNKNOWN
042378  52                    PUSH   dx                           ; UNKNOWN
042379  0B D2                 OR     dx, dx                       ; UNKNOWN
04237B  75 04                 JNE    0x42381                      ; UNKNOWN
04237D  0B DB                 OR     bx, bx                       ; UNKNOWN
04237F  74 1C                 JE     0x4239d                      ; UNKNOWN
042381  8B 1E 74 C1           MOV    bx, word ptr [0xc174]        ; UNKNOWN
042385  D1 E3                 SHL    bx, 1                        ; UNKNOWN
042387  89 87 88 C1           MOV    word ptr [bx - 0x3e78], ax   ; UNKNOWN
04238B  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
04238E  89 87 62 C1           MOV    word ptr [bx - 0x3e9e], ax   ; UNKNOWN
042392  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
042395  89 87 76 C1           MOV    word ptr [bx - 0x3e8a], ax   ; UNKNOWN
042399  FF 06 74 C1           INC    word ptr [0xc174]            ; UNKNOWN
04239D  C9                    LEAVE                               ; UNKNOWN
04239E  CB                    RETF                                ; UNKNOWN
