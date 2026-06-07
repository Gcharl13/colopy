; ============================================================================
; func_0463EC_unknown
; Region   : load_image
; Bytes    : file 0x0463EC..0x04642F  (67 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0463EC  C8 9A 06 00           ENTER  0x69a, 0                     ; UNKNOWN
0463F0  49                    DEC    cx                           ; UNKNOWN
0463F1  22 83 C4 04           AND    al, byte ptr [bp + di + 0x4c4] ; UNKNOWN
0463F5  A8 40                 TEST   al, 0x40                     ; UNKNOWN
0463F7  74 2B                 JE     0x46424                      ; UNKNOWN
0463F9  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
0463FC  9A 94 01 49 22        LCALL  0x2249, 0x194                ; UNKNOWN
046401  83 C4 02              ADD    sp, 2                        ; UNKNOWN
046404  50                    PUSH   ax                           ; UNKNOWN
046405  6A 00                 PUSH   0                            ; UNKNOWN
046407  9A E4 03 97 1B        LCALL  0x1b97, 0x3e4                ; UNKNOWN
04640C  83 C4 04              ADD    sp, 4                        ; UNKNOWN
04640F  6A 01                 PUSH   1                            ; UNKNOWN
046411  68 6E 28              PUSH   0x286e                       ; UNKNOWN
046414  9A 41 37 97 1B        LCALL  0x1b97, 0x3741               ; UNKNOWN
046419  83 C4 04              ADD    sp, 4                        ; UNKNOWN
04641C  83 F8 02              CMP    ax, 2                        ; UNKNOWN
04641F  74 03                 JE     0x46424                      ; UNKNOWN
046421  E9 7A 07              JMP    0x46b9e                      ; UNKNOWN
046424  83 7E C8 04           CMP    word ptr [bp - 0x38], 4      ; UNKNOWN
046428  7D 24                 JGE    0x4644e                      ; UNKNOWN
04642A  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
04642D  FF                    DB     0xFF                         ; UNKNOWN (raw)
04642E  76                    DB     0x76                         ; UNKNOWN (raw)
