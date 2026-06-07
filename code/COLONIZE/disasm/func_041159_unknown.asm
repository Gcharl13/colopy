; ============================================================================
; func_041159_unknown
; Region   : load_image
; Bytes    : file 0x041159..0x041196  (61 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

041159  55                    PUSH   bp                           ; UNKNOWN
04115A  8B EC                 MOV    bp, sp                       ; UNKNOWN
04115C  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
041160  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
041164  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
041168  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
04116C  6A 03                 PUSH   3                            ; UNKNOWN
04116E  8A 46 06              MOV    al, byte ptr [bp + 6]        ; UNKNOWN
041171  50                    PUSH   ax                           ; UNKNOWN
041172  B8 3B 01              MOV    ax, 0x13b                    ; UNKNOWN
041175  BA C5 00              MOV    dx, 0xc5                     ; UNKNOWN
041178  BB 05 00              MOV    bx, 5                        ; UNKNOWN
04117B  9A 08 00 58 5A        LCALL  0x5a58, 8                    ; UNKNOWN
041180  68 C5 00              PUSH   0xc5                         ; UNKNOWN
041183  6A 05                 PUSH   5                            ; UNKNOWN
041185  6A 03                 PUSH   3                            ; UNKNOWN
041187  B8 3B 01              MOV    ax, 0x13b                    ; UNKNOWN
04118A  BA C5 00              MOV    dx, 0xc5                     ; UNKNOWN
04118D  8B D8                 MOV    bx, ax                       ; UNKNOWN
04118F  9A 3B 00 B4 5C        LCALL  0x5cb4, 0x3b                 ; UNKNOWN
041194  C9                    LEAVE                               ; UNKNOWN
041195  CB                    RETF                                ; UNKNOWN
