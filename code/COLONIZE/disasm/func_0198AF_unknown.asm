; ============================================================================
; func_0198AF_unknown
; Region   : load_image
; Bytes    : file 0x0198AF..0x01995C  (173 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0198AF  C8 0C 00 00           ENTER  0xc, 0                       ; UNKNOWN
0198B3  8D 46 F4              LEA    ax, [bp - 0xc]               ; UNKNOWN
0198B6  50                    PUSH   ax                           ; UNKNOWN
0198B7  8D 46 F6              LEA    ax, [bp - 0xa]               ; UNKNOWN
0198BA  50                    PUSH   ax                           ; UNKNOWN
0198BB  8D 46 FE              LEA    ax, [bp - 2]                 ; UNKNOWN
0198BE  50                    PUSH   ax                           ; UNKNOWN
0198BF  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
0198C2  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
0198C5  0E                    PUSH   cs                           ; UNKNOWN
0198C6  E8 AD FF              CALL   0x19876                      ; UNKNOWN
0198C9  83 C4 0A              ADD    sp, 0xa                      ; UNKNOWN
0198CC  C7 46 F8 00 00        MOV    word ptr [bp - 8], 0         ; UNKNOWN
0198D1  EB 48                 JMP    0x1991b                      ; UNKNOWN
0198D3  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
0198D7  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
0198DB  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
0198DF  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
0198E3  03 46 F6              ADD    ax, word ptr [bp - 0xa]      ; UNKNOWN
0198E6  50                    PUSH   ax                           ; UNKNOWN
0198E7  6A 3F                 PUSH   0x3f                         ; UNKNOWN
0198E9  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
0198EC  8B 5E FE              MOV    bx, word ptr [bp - 2]        ; UNKNOWN
0198EF  03 D8                 ADD    bx, ax                       ; UNKNOWN
0198F1  40                    INC    ax                           ; UNKNOWN
0198F2  8B 56 FA              MOV    dx, word ptr [bp - 6]        ; UNKNOWN
0198F5  42                    INC    dx                           ; UNKNOWN
0198F6  9A 00 00 84 5A        LCALL  0x5a84, 0                    ; UNKNOWN
0198FB  FF 36 72 09           PUSH   word ptr [0x972]             ; UNKNOWN
0198FF  FF 36 70 09           PUSH   word ptr [0x970]             ; UNKNOWN
019903  FF 76 FA              PUSH   word ptr [bp - 6]            ; UNKNOWN
019906  8B 46 0A              MOV    ax, word ptr [bp + 0xa]      ; UNKNOWN
019909  03 46 F8              ADD    ax, word ptr [bp - 8]        ; UNKNOWN
01990C  8D 1E 82 CE           LEA    bx, [0xce82]                 ; UNKNOWN
019910  8B 56 FC              MOV    dx, word ptr [bp - 4]        ; UNKNOWN
019913  9A 0E 00 15 5D        LCALL  0x5d15, 0xe                  ; UNKNOWN
019918  FF 46 F8              INC    word ptr [bp - 8]            ; UNKNOWN
01991B  8B 46 F8              MOV    ax, word ptr [bp - 8]        ; UNKNOWN
01991E  39 46 08              CMP    word ptr [bp + 8], ax        ; UNKNOWN
019921  7E 5F                 JLE    0x19982                      ; UNKNOWN
019923  C7 46 FC 2F 01        MOV    word ptr [bp - 4], 0x12f     ; UNKNOWN
019928  8B 4E F6              MOV    cx, word ptr [bp - 0xa]      ; UNKNOWN
01992B  41                    INC    cx                           ; UNKNOWN
01992C  41                    INC    cx                           ; UNKNOWN
01992D  F7 E9                 IMUL   cx                           ; UNKNOWN
01992F  05 84 00              ADD    ax, 0x84                     ; UNKNOWN
019932  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
019935  8B 4E F8              MOV    cx, word ptr [bp - 8]        ; UNKNOWN
019938  39 4E 06              CMP    word ptr [bp + 6], cx        ; UNKNOWN
01993B  75 96                 JNE    0x198d3                      ; UNKNOWN
01993D  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
019941  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
019945  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
019949  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
01994D  03 46 F6              ADD    ax, word ptr [bp - 0xa]      ; UNKNOWN
019950  48                    DEC    ax                           ; UNKNOWN
019951  50                    PUSH   ax                           ; UNKNOWN
019952  6A 3F                 PUSH   0x3f                         ; UNKNOWN
019954  8B 56 FA              MOV    dx, word ptr [bp - 6]        ; UNKNOWN
019957  8B 5E FE              MOV    bx, word ptr [bp - 2]        ; UNKNOWN
01995A  81                    DB     0x81                         ; UNKNOWN (raw)
01995B  C3                    DB     0xC3                         ; UNKNOWN (raw)
