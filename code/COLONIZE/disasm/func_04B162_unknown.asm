; ============================================================================
; func_04B162_unknown
; Region   : load_image
; Bytes    : file 0x04B162..0x04B1C6  (100 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04B162  C8 52 03 00           ENTER  0x352, 0                     ; UNKNOWN
04B166  68 90 29              PUSH   0x2990                       ; UNKNOWN
04B169  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
04B16C  50                    PUSH   ax                           ; UNKNOWN
04B16D  9A 74 07 65 5F        LCALL  0x5f65, 0x774                ; UNKNOWN
04B172  83 C4 04              ADD    sp, 4                        ; UNKNOWN
04B175  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
04B178  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
04B17B  16                    PUSH   ss                           ; UNKNOWN
04B17C  50                    PUSH   ax                           ; UNKNOWN
04B17D  9A 38 01 13 24        LCALL  0x2413, 0x138                ; UNKNOWN
04B182  83 C4 06              ADD    sp, 6                        ; UNKNOWN
04B185  8D 86 AE FC           LEA    ax, [bp - 0x352]             ; UNKNOWN
04B189  16                    PUSH   ss                           ; UNKNOWN
04B18A  50                    PUSH   ax                           ; UNKNOWN
04B18B  6A 00                 PUSH   0                            ; UNKNOWN
04B18D  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
04B191  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
04B195  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
04B199  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
04B19D  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
04B1A0  50                    PUSH   ax                           ; UNKNOWN
04B1A1  9A 0A 00 69 1A        LCALL  0x1a69, 0xa                  ; UNKNOWN
04B1A6  83 C4 10              ADD    sp, 0x10                     ; UNKNOWN
04B1A9  0B C0                 OR     ax, ax                       ; UNKNOWN
04B1AB  74 19                 JE     0x4b1c6                      ; UNKNOWN
04B1AD  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
04B1B1  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
04B1B5  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
04B1B9  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
04B1BD  B0 22                 MOV    al, 0x22                     ; UNKNOWN
04B1BF  9A 02 00 47 5A        LCALL  0x5a47, 2                    ; UNKNOWN
04B1C4  C9                    LEAVE                               ; UNKNOWN
04B1C5  CB                    RETF                                ; UNKNOWN
