; ============================================================================
; func_02B36D_unknown
; Region   : load_image
; Bytes    : file 0x02B36D..0x02B3AB  (62 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02B36D  55                    PUSH   bp                           ; UNKNOWN
02B36E  8B EC                 MOV    bp, sp                       ; UNKNOWN
02B370  83 3E 4A 0A 00        CMP    word ptr [0xa4a], 0          ; UNKNOWN
02B375  74 34                 JE     0x2b3ab                      ; UNKNOWN
02B377  6A 00                 PUSH   0                            ; UNKNOWN
02B379  6A 00                 PUSH   0                            ; UNKNOWN
02B37B  FF 76 14              PUSH   word ptr [bp + 0x14]         ; UNKNOWN
02B37E  FF 76 12              PUSH   word ptr [bp + 0x12]         ; UNKNOWN
02B381  FF 76 10              PUSH   word ptr [bp + 0x10]         ; UNKNOWN
02B384  FF 76 0E              PUSH   word ptr [bp + 0xe]          ; UNKNOWN
02B387  8B 1E 4A 0A           MOV    bx, word ptr [0xa4a]         ; UNKNOWN
02B38B  FF 77 06              PUSH   word ptr [bx + 6]            ; UNKNOWN
02B38E  FF 77 04              PUSH   word ptr [bx + 4]            ; UNKNOWN
02B391  FF 77 02              PUSH   word ptr [bx + 2]            ; UNKNOWN
02B394  FF 37                 PUSH   word ptr [bx]                ; UNKNOWN
02B396  FF 76 0C              PUSH   word ptr [bp + 0xc]          ; UNKNOWN
02B399  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
02B39C  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
02B39F  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
02B3A2  9A 0C 00 B6 5A        LCALL  0x5ab6, 0xc                  ; UNKNOWN
02B3A7  8B E5                 MOV    sp, bp                       ; UNKNOWN
02B3A9  C9                    LEAVE                               ; UNKNOWN
02B3AA  CB                    RETF                                ; UNKNOWN
