; ============================================================================
; func_04642F_unknown
; Region   : load_image
; Bytes    : file 0x04642F..0x0464A5  (118 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04642F  C8 9A 06 00           ENTER  0x69a, 0                     ; UNKNOWN
046433  49                    DEC    cx                           ; UNKNOWN
046434  22 83 C4 04           AND    al, byte ptr [bp + di + 0x4c4] ; UNKNOWN
046438  A8 40                 TEST   al, 0x40                     ; UNKNOWN
04643A  74 12                 JE     0x4644e                      ; UNKNOWN
04643C  69 76 C8 3C 01        IMUL   si, word ptr [bp - 0x38], 0x13c ; UNKNOWN
046441  8B 5E FE              MOV    bx, word ptr [bp - 2]        ; UNKNOWN
046444  80 B8 EA 74 00        CMP    byte ptr [bx + si + 0x74ea], 0 ; UNKNOWN
046449  74 03                 JE     0x4644e                      ; UNKNOWN
04644B  E9 50 07              JMP    0x46b9e                      ; UNKNOWN
04644E  83 7E FE 04           CMP    word ptr [bp - 2], 4         ; UNKNOWN
046452  7D 4C                 JGE    0x464a0                      ; UNKNOWN
046454  6B 5E FE 34           IMUL   bx, word ptr [bp - 2], 0x34  ; UNKNOWN
046458  80 BF B7 C0 00        CMP    byte ptr [bx - 0x3f49], 0    ; UNKNOWN
04645D  75 41                 JNE    0x464a0                      ; UNKNOWN
04645F  FF 76 C8              PUSH   word ptr [bp - 0x38]         ; UNKNOWN
046462  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
046465  9A 06 00 49 22        LCALL  0x2249, 6                    ; UNKNOWN
04646A  83 C4 04              ADD    sp, 4                        ; UNKNOWN
04646D  A8 40                 TEST   al, 0x40                     ; UNKNOWN
04646F  74 2F                 JE     0x464a0                      ; UNKNOWN
046471  FF 76 C8              PUSH   word ptr [bp - 0x38]         ; UNKNOWN
046474  9A 94 01 49 22        LCALL  0x2249, 0x194                ; UNKNOWN
046479  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04647C  50                    PUSH   ax                           ; UNKNOWN
04647D  6A 00                 PUSH   0                            ; UNKNOWN
04647F  9A E4 03 97 1B        LCALL  0x1b97, 0x3e4                ; UNKNOWN
046484  83 C4 04              ADD    sp, 4                        ; UNKNOWN
046487  6A 04                 PUSH   4                            ; UNKNOWN
046489  9A 11 03 28 1A        LCALL  0x1a28, 0x311                ; UNKNOWN
04648E  83 C4 02              ADD    sp, 2                        ; UNKNOWN
046491  8D 1E 86 09           LEA    bx, [0x986]                  ; UNKNOWN
046495  8D 06 79 28           LEA    ax, [0x2879]                 ; UNKNOWN
046499  2B D2                 SUB    dx, dx                       ; UNKNOWN
04649B  9A 6F 36 97 1B        LCALL  0x1b97, 0x366f               ; UNKNOWN
0464A0  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
0464A3  FF                    DB     0xFF                         ; UNKNOWN (raw)
0464A4  76                    DB     0x76                         ; UNKNOWN (raw)
