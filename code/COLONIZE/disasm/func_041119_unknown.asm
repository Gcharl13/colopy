; ============================================================================
; func_041119_unknown
; Region   : load_image
; Bytes    : file 0x041119..0x041159  (64 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

041119  55                    PUSH   bp                           ; UNKNOWN
04111A  8B EC                 MOV    bp, sp                       ; UNKNOWN
04111C  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
041120  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
041124  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
041128  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
04112C  6A 03                 PUSH   3                            ; UNKNOWN
04112E  8A 46 08              MOV    al, byte ptr [bp + 8]        ; UNKNOWN
041131  50                    PUSH   ax                           ; UNKNOWN
041132  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
041135  05 3B 01              ADD    ax, 0x13b                    ; UNKNOWN
041138  BA C5 00              MOV    dx, 0xc5                     ; UNKNOWN
04113B  BB 01 00              MOV    bx, 1                        ; UNKNOWN
04113E  9A 08 00 58 5A        LCALL  0x5a58, 8                    ; UNKNOWN
041143  68 C5 00              PUSH   0xc5                         ; UNKNOWN
041146  6A 05                 PUSH   5                            ; UNKNOWN
041148  6A 03                 PUSH   3                            ; UNKNOWN
04114A  B8 3B 01              MOV    ax, 0x13b                    ; UNKNOWN
04114D  BA C5 00              MOV    dx, 0xc5                     ; UNKNOWN
041150  8B D8                 MOV    bx, ax                       ; UNKNOWN
041152  9A 3B 00 B4 5C        LCALL  0x5cb4, 0x3b                 ; UNKNOWN
041157  C9                    LEAVE                               ; UNKNOWN
041158  CB                    RETF                                ; UNKNOWN
