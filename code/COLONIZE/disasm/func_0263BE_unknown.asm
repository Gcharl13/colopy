; ============================================================================
; func_0263BE_unknown
; Region   : load_image
; Bytes    : file 0x0263BE..0x02642E  (112 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0263BE  C8 54 00 00           ENTER  0x54, 0                      ; UNKNOWN
0263C2  83 3E 0E 0A 00        CMP    word ptr [0xa0e], 0          ; UNKNOWN
0263C7  74 63                 JE     0x2642c                      ; UNKNOWN
0263C9  C4 5E 06              LES    bx, ptr [bp + 6]             ; UNKNOWN
0263CC  26 8B 47 14           MOV    ax, word ptr es:[bx + 0x14]  ; UNKNOWN
0263D0  26 03 47 10           ADD    ax, word ptr es:[bx + 0x10]  ; UNKNOWN
0263D4  48                    DEC    ax                           ; UNKNOWN
0263D5  48                    DEC    ax                           ; UNKNOWN
0263D6  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
0263D9  26 8B 47 16           MOV    ax, word ptr es:[bx + 0x16]  ; UNKNOWN
0263DD  26 03 47 12           ADD    ax, word ptr es:[bx + 0x12]  ; UNKNOWN
0263E1  83 E8 07              SUB    ax, 7                        ; UNKNOWN
0263E4  89 46 AC              MOV    word ptr [bp - 0x54], ax     ; UNKNOWN
0263E7  8B 0E B4 09           MOV    cx, word ptr [0x9b4]         ; UNKNOWN
0263EB  8B 16 B6 09           MOV    dx, word ptr [0x9b6]         ; UNKNOWN
0263EF  26 39 8F 80 00        CMP    word ptr es:[bx + 0x80], cx  ; UNKNOWN
0263F4  75 0C                 JNE    0x26402                      ; UNKNOWN
0263F6  26 39 97 82 00        CMP    word ptr es:[bx + 0x82], dx  ; UNKNOWN
0263FB  75 05                 JNE    0x26402                      ; UNKNOWN
0263FD  48                    DEC    ax                           ; UNKNOWN
0263FE  48                    DEC    ax                           ; UNKNOWN
0263FF  89 46 AC              MOV    word ptr [bp - 0x54], ax     ; UNKNOWN
026402  C6 46 AE 00           MOV    byte ptr [bp - 0x52], 0      ; UNKNOWN
026406  FF 36 74 34           PUSH   word ptr [0x3474]            ; UNKNOWN
02640A  8D 46 AE              LEA    ax, [bp - 0x52]              ; UNKNOWN
02640D  50                    PUSH   ax                           ; UNKNOWN
02640E  9A ED 00 13 24        LCALL  0x2413, 0xed                 ; UNKNOWN
026413  83 C4 04              ADD    sp, 4                        ; UNKNOWN
026416  A0 63 09              MOV    al, byte ptr [0x963]         ; UNKNOWN
026419  2A E4                 SUB    ah, ah                       ; UNKNOWN
02641B  50                    PUSH   ax                           ; UNKNOWN
02641C  FF 76 AC              PUSH   word ptr [bp - 0x54]         ; UNKNOWN
02641F  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
026422  8D 46 AE              LEA    ax, [bp - 0x52]              ; UNKNOWN
026425  16                    PUSH   ss                           ; UNKNOWN
026426  50                    PUSH   ax                           ; UNKNOWN
026427  9A C9 02 13 24        LCALL  0x2413, 0x2c9                ; UNKNOWN
02642C  C9                    LEAVE                               ; UNKNOWN
02642D  CB                    RETF                                ; UNKNOWN
