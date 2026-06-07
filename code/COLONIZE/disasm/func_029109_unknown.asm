; ============================================================================
; func_029109_unknown
; Region   : load_image
; Bytes    : file 0x029109..0x0291B4  (171 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

029109  C8 08 00 00           ENTER  8, 0                         ; UNKNOWN
02910D  68 00 08              PUSH   0x800                        ; UNKNOWN
029110  FF 36 B6 09           PUSH   word ptr [0x9b6]             ; UNKNOWN
029114  FF 36 B4 09           PUSH   word ptr [0x9b4]             ; UNKNOWN
029118  9A 3E 30 97 1B        LCALL  0x1b97, 0x303e               ; UNKNOWN
02911D  83 C4 06              ADD    sp, 6                        ; UNKNOWN
029120  2B D2                 SUB    dx, dx                       ; UNKNOWN
029122  89 56 FE              MOV    word ptr [bp - 2], dx        ; UNKNOWN
029125  8D 1E 86 09           LEA    bx, [0x986]                  ; UNKNOWN
029129  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
02912C  9A 5A 32 97 1B        LCALL  0x1b97, 0x325a               ; UNKNOWN
029131  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
029134  89 56 FC              MOV    word ptr [bp - 4], dx        ; UNKNOWN
029137  0B D0                 OR     dx, ax                       ; UNKNOWN
029139  74 50                 JE     0x2918b                      ; UNKNOWN
02913B  C4 5E FA              LES    bx, ptr [bp - 6]             ; UNKNOWN
02913E  26 80 4F 0A 01        OR     byte ptr es:[bx + 0xa], 1    ; UNKNOWN
029143  26 C7 47 22 0A 00     MOV    word ptr es:[bx + 0x22], 0xa ; UNKNOWN
029149  C7 46 F8 00 00        MOV    word ptr [bp - 8], 0         ; UNKNOWN
02914E  8B 46 F8              MOV    ax, word ptr [bp - 8]        ; UNKNOWN
029151  40                    INC    ax                           ; UNKNOWN
029152  50                    PUSH   ax                           ; UNKNOWN
029153  8B 5E F8              MOV    bx, word ptr [bp - 8]        ; UNKNOWN
029156  D1 E3                 SHL    bx, 1                        ; UNKNOWN
029158  FF B7 A1 3D           PUSH   word ptr [bx + 0x3da1]       ; UNKNOWN
02915C  9A 6C 00 E6 21        LCALL  0x21e6, 0x6c                 ; UNKNOWN
029161  83 C4 02              ADD    sp, 2                        ; UNKNOWN
029164  52                    PUSH   dx                           ; UNKNOWN
029165  50                    PUSH   ax                           ; UNKNOWN
029166  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
029169  FF 76 FA              PUSH   word ptr [bp - 6]            ; UNKNOWN
02916C  9A E6 09 97 1B        LCALL  0x1b97, 0x9e6                ; UNKNOWN
029171  83 C4 0A              ADD    sp, 0xa                      ; UNKNOWN
029174  FF 46 F8              INC    word ptr [bp - 8]            ; UNKNOWN
029177  83 7E F8 10           CMP    word ptr [bp - 8], 0x10      ; UNKNOWN
02917B  7C D1                 JL     0x2914e                      ; UNKNOWN
02917D  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
029180  FF 76 FA              PUSH   word ptr [bp - 6]            ; UNKNOWN
029183  9A 4A 25 97 1B        LCALL  0x1b97, 0x254a               ; UNKNOWN
029188  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
02918B  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
02918E  0B 46 FA              OR     ax, word ptr [bp - 6]        ; UNKNOWN
029191  74 0B                 JE     0x2919e                      ; UNKNOWN
029193  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
029196  FF 76 FA              PUSH   word ptr [bp - 6]            ; UNKNOWN
029199  9A 06 01 4F 00        LCALL  0x4f, 0x106                  ; UNKNOWN
02919E  68 00 08              PUSH   0x800                        ; UNKNOWN
0291A1  FF 36 22 0C           PUSH   word ptr [0xc22]             ; UNKNOWN
0291A5  FF 36 20 0C           PUSH   word ptr [0xc20]             ; UNKNOWN
0291A9  9A 3E 30 97 1B        LCALL  0x1b97, 0x303e               ; UNKNOWN
0291AE  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
0291B1  48                    DEC    ax                           ; UNKNOWN
0291B2  C9                    LEAVE                               ; UNKNOWN
0291B3  CB                    RETF                                ; UNKNOWN
