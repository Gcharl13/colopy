; ============================================================================
; func_021F9A_unknown
; Region   : load_image
; Bytes    : file 0x021F9A..0x022080  (230 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

021F9A  C8 0C 00 00           ENTER  0xc, 0                       ; UNKNOWN
021F9E  56                    PUSH   si                           ; UNKNOWN
021F9F  C4 5E 06              LES    bx, ptr [bp + 6]             ; UNKNOWN
021FA2  26 FF 77 2A           PUSH   word ptr es:[bx + 0x2a]      ; UNKNOWN
021FA6  26 FF 77 28           PUSH   word ptr es:[bx + 0x28]      ; UNKNOWN
021FAA  E8 C5 F6              CALL   0x21672                      ; UNKNOWN
021FAD  83 C4 04              ADD    sp, 4                        ; UNKNOWN
021FB0  C4 5E 06              LES    bx, ptr [bp + 6]             ; UNKNOWN
021FB3  26 03 47 04           ADD    ax, word ptr es:[bx + 4]     ; UNKNOWN
021FB7  40                    INC    ax                           ; UNKNOWN
021FB8  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
021FBB  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
021FBF  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
021FC3  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
021FC7  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
021FCB  50                    PUSH   ax                           ; UNKNOWN
021FCC  6A 00                 PUSH   0                            ; UNKNOWN
021FCE  6A 00                 PUSH   0                            ; UNKNOWN
021FD0  68 40 01              PUSH   0x140                        ; UNKNOWN
021FD3  26 8A 47 0E           MOV    al, byte ptr es:[bx + 0xe]   ; UNKNOWN
021FD7  50                    PUSH   ax                           ; UNKNOWN
021FD8  26 8A 47 10           MOV    al, byte ptr es:[bx + 0x10]  ; UNKNOWN
021FDC  50                    PUSH   ax                           ; UNKNOWN
021FDD  6A 00                 PUSH   0                            ; UNKNOWN
021FDF  6A 00                 PUSH   0                            ; UNKNOWN
021FE1  2B C0                 SUB    ax, ax                       ; UNKNOWN
021FE3  99                    CDQ                                 ; UNKNOWN
021FE4  BB 40 01              MOV    bx, 0x140                    ; UNKNOWN
021FE7  E8 D1 F6              CALL   0x216bb                      ; UNKNOWN
021FEA  C4 5E 06              LES    bx, ptr [bp + 6]             ; UNKNOWN
021FED  26 8B 47 38           MOV    ax, word ptr es:[bx + 0x38]  ; UNKNOWN
021FF1  26 8B 57 3A           MOV    dx, word ptr es:[bx + 0x3a]  ; UNKNOWN
021FF5  89 46 F4              MOV    word ptr [bp - 0xc], ax      ; UNKNOWN
021FF8  89 56 F6              MOV    word ptr [bp - 0xa], dx      ; UNKNOWN
021FFB  0B D0                 OR     dx, ax                       ; UNKNOWN
021FFD  75 03                 JNE    0x22002                      ; UNKNOWN
021FFF  E9 A5 00              JMP    0x220a7                      ; UNKNOWN
022002  C4 5E F4              LES    bx, ptr [bp - 0xc]           ; UNKNOWN
022005  26 F6 47 0C 01        TEST   byte ptr es:[bx + 0xc], 1    ; UNKNOWN
02200A  74 03                 JE     0x2200f                      ; UNKNOWN
02200C  E9 80 00              JMP    0x2208f                      ; UNKNOWN
02200F  26 8B 47 02           MOV    ax, word ptr es:[bx + 2]     ; UNKNOWN
022013  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
022016  8C C0                 MOV    ax, es                       ; UNKNOWN
022018  3B 5E 0A              CMP    bx, word ptr [bp + 0xa]      ; UNKNOWN
02201B  75 45                 JNE    0x22062                      ; UNKNOWN
02201D  3B 46 0C              CMP    ax, word ptr [bp + 0xc]      ; UNKNOWN
022020  75 40                 JNE    0x22062                      ; UNKNOWN
022022  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
022026  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
02202A  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
02202E  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
022032  FF 76 F8              PUSH   word ptr [bp - 8]            ; UNKNOWN
022035  6A 00                 PUSH   0                            ; UNKNOWN
022037  6A 00                 PUSH   0                            ; UNKNOWN
022039  68 40 01              PUSH   0x140                        ; UNKNOWN
02203C  C4 5E 06              LES    bx, ptr [bp + 6]             ; UNKNOWN
02203F  26 8A 47 1A           MOV    al, byte ptr es:[bx + 0x1a]  ; UNKNOWN
022043  50                    PUSH   ax                           ; UNKNOWN
022044  26 8A 47 1C           MOV    al, byte ptr es:[bx + 0x1c]  ; UNKNOWN
022048  50                    PUSH   ax                           ; UNKNOWN
022049  6A 00                 PUSH   0                            ; UNKNOWN
02204B  6A 00                 PUSH   0                            ; UNKNOWN
02204D  26 8B 5F 0A           MOV    bx, word ptr es:[bx + 0xa]   ; UNKNOWN
022051  D1 E3                 SHL    bx, 1                        ; UNKNOWN
022053  C4 76 F4              LES    si, ptr [bp - 0xc]           ; UNKNOWN
022056  26 03 5C 04           ADD    bx, word ptr es:[si + 4]     ; UNKNOWN
02205A  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
02205D  2B D2                 SUB    dx, dx                       ; UNKNOWN
02205F  E8 59 F6              CALL   0x216bb                      ; UNKNOWN
022062  6A 00                 PUSH   0                            ; UNKNOWN
022064  C4 5E 06              LES    bx, ptr [bp + 6]             ; UNKNOWN
022067  26 FF 77 04           PUSH   word ptr es:[bx + 4]         ; UNKNOWN
02206B  26 8B 47 0A           MOV    ax, word ptr es:[bx + 0xa]   ; UNKNOWN
02206F  03 46 FE              ADD    ax, word ptr [bp - 2]        ; UNKNOWN
022072  50                    PUSH   ax                           ; UNKNOWN
022073  C4 76 F4              LES    si, ptr [bp - 0xc]           ; UNKNOWN
022076  26 FF 74 10           PUSH   word ptr es:[si + 0x10]      ; UNKNOWN
02207A  26 FF 74 0E           PUSH   word ptr es:[si + 0xe]       ; UNKNOWN
02207E  8B C3                 MOV    ax, bx                       ; UNKNOWN
