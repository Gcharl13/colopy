; ============================================================================
; func_02E290_unknown
; Region   : load_image
; Bytes    : file 0x02E290..0x02E2D8  (72 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02E290  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
02E294  56                    PUSH   si                           ; UNKNOWN
02E295  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
02E299  8A 47 1F              MOV    al, byte ptr [bx + 0x1f]     ; UNKNOWN
02E29C  98                    CWDE                                ; UNKNOWN
02E29D  3B 46 06              CMP    ax, word ptr [bp + 6]        ; UNKNOWN
02E2A0  7E 33                 JLE    0x2e2d5                      ; UNKNOWN
02E2A2  C7 46 FE F0 00        MOV    word ptr [bp - 2], 0xf0      ; UNKNOWN
02E2A7  8B 46 08              MOV    ax, word ptr [bp + 8]        ; UNKNOWN
02E2AA  83 F8 0F              CMP    ax, 0xf                      ; UNKNOWN
02E2AD  7E 03                 JLE    0x2e2b2                      ; UNKNOWN
02E2AF  B8 0F 00              MOV    ax, 0xf                      ; UNKNOWN
02E2B2  89 46 08              MOV    word ptr [bp + 8], ax        ; UNKNOWN
02E2B5  F6 46 06 01           TEST   byte ptr [bp + 6], 1         ; UNKNOWN
02E2B9  74 09                 JE     0x2e2c4                      ; UNKNOWN
02E2BB  C7 46 FE 0F 00        MOV    word ptr [bp - 2], 0xf       ; UNKNOWN
02E2C0  C1 66 08 04           SHL    word ptr [bp + 8], 4         ; UNKNOWN
02E2C4  8A 46 FE              MOV    al, byte ptr [bp - 2]        ; UNKNOWN
02E2C7  8B 76 06              MOV    si, word ptr [bp + 6]        ; UNKNOWN
02E2CA  D1 FE                 SAR    si, 1                        ; UNKNOWN
02E2CC  20 40 60              AND    byte ptr [bx + si + 0x60], al ; UNKNOWN
02E2CF  8A 46 08              MOV    al, byte ptr [bp + 8]        ; UNKNOWN
02E2D2  08 40 60              OR     byte ptr [bx + si + 0x60], al ; UNKNOWN
02E2D5  5E                    POP    si                           ; UNKNOWN
02E2D6  C9                    LEAVE                               ; UNKNOWN
02E2D7  CB                    RETF                                ; UNKNOWN
