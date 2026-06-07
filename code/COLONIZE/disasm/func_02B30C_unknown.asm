; ============================================================================
; func_02B30C_unknown
; Region   : load_image
; Bytes    : file 0x02B30C..0x02B34A  (62 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02B30C  55                    PUSH   bp                           ; UNKNOWN
02B30D  8B EC                 MOV    bp, sp                       ; UNKNOWN
02B30F  83 3E 4C 0A 00        CMP    word ptr [0xa4c], 0          ; UNKNOWN
02B314  74 34                 JE     0x2b34a                      ; UNKNOWN
02B316  6A 00                 PUSH   0                            ; UNKNOWN
02B318  6A 00                 PUSH   0                            ; UNKNOWN
02B31A  FF 76 14              PUSH   word ptr [bp + 0x14]         ; UNKNOWN
02B31D  FF 76 12              PUSH   word ptr [bp + 0x12]         ; UNKNOWN
02B320  FF 76 10              PUSH   word ptr [bp + 0x10]         ; UNKNOWN
02B323  FF 76 0E              PUSH   word ptr [bp + 0xe]          ; UNKNOWN
02B326  8B 1E 4C 0A           MOV    bx, word ptr [0xa4c]         ; UNKNOWN
02B32A  FF 77 06              PUSH   word ptr [bx + 6]            ; UNKNOWN
02B32D  FF 77 04              PUSH   word ptr [bx + 4]            ; UNKNOWN
02B330  FF 77 02              PUSH   word ptr [bx + 2]            ; UNKNOWN
02B333  FF 37                 PUSH   word ptr [bx]                ; UNKNOWN
02B335  FF 76 0C              PUSH   word ptr [bp + 0xc]          ; UNKNOWN
02B338  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
02B33B  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
02B33E  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
02B341  9A 0C 00 B6 5A        LCALL  0x5ab6, 0xc                  ; UNKNOWN
02B346  8B E5                 MOV    sp, bp                       ; UNKNOWN
02B348  C9                    LEAVE                               ; UNKNOWN
02B349  CB                    RETF                                ; UNKNOWN
