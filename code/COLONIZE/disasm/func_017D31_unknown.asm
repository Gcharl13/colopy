; ============================================================================
; func_017D31_unknown
; Region   : load_image
; Bytes    : file 0x017D31..0x017DC8  (151 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

017D31  C8 54 00 00           ENTER  0x54, 0                      ; UNKNOWN
017D35  56                    PUSH   si                           ; UNKNOWN
017D36  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
017D3A  80 7F 1A 04           CMP    byte ptr [bx + 0x1a], 4      ; UNKNOWN
017D3E  73 11                 JAE    0x17d51                      ; UNKNOWN
017D40  8A 47 1A              MOV    al, byte ptr [bx + 0x1a]     ; UNKNOWN
017D43  2A E4                 SUB    ah, ah                       ; UNKNOWN
017D45  6B D8 34              IMUL   bx, ax, 0x34                 ; UNKNOWN
017D48  38 A7 B7 C0           CMP    byte ptr [bx - 0x3f49], ah   ; UNKNOWN
017D4C  75 03                 JNE    0x17d51                      ; UNKNOWN
017D4E  E9 09 01              JMP    0x17e5a                      ; UNKNOWN
017D51  83 3E 10 09 00        CMP    word ptr [0x910], 0          ; UNKNOWN
017D56  74 03                 JE     0x17d5b                      ; UNKNOWN
017D58  E9 FF 00              JMP    0x17e5a                      ; UNKNOWN
017D5B  80 3E A0 09 00        CMP    byte ptr [0x9a0], 0          ; UNKNOWN
017D60  74 03                 JE     0x17d65                      ; UNKNOWN
017D62  E9 F5 00              JMP    0x17e5a                      ; UNKNOWN
017D65  C6 46 B0 00           MOV    byte ptr [bp - 0x50], 0      ; UNKNOWN
017D69  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
017D6D  8A 47 1B              MOV    al, byte ptr [bx + 0x1b]     ; UNKNOWN
017D70  2A E4                 SUB    ah, ah                       ; UNKNOWN
017D72  50                    PUSH   ax                           ; UNKNOWN
017D73  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
017D76  16                    PUSH   ss                           ; UNKNOWN
017D77  50                    PUSH   ax                           ; UNKNOWN
017D78  9A 5F 01 13 24        LCALL  0x2413, 0x15f                ; UNKNOWN
017D7D  83 C4 06              ADD    sp, 6                        ; UNKNOWN
017D80  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
017D83  50                    PUSH   ax                           ; UNKNOWN
017D84  9A 0C 00 13 24        LCALL  0x2413, 0xc                  ; UNKNOWN
017D89  83 C4 02              ADD    sp, 2                        ; UNKNOWN
017D8C  C7 46 AC 00 00        MOV    word ptr [bp - 0x54], 0      ; UNKNOWN
017D91  EB 29                 JMP    0x17dbc                      ; UNKNOWN
017D93  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
017D97  8B 76 AC              MOV    si, word ptr [bp - 0x54]     ; UNKNOWN
017D9A  8A 80 8C 00           MOV    al, byte ptr [bx + si + 0x8c] ; UNKNOWN
017D9E  98                    CWDE                                ; UNKNOWN
017D9F  50                    PUSH   ax                           ; UNKNOWN
017DA0  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
017DA3  16                    PUSH   ss                           ; UNKNOWN
017DA4  50                    PUSH   ax                           ; UNKNOWN
017DA5  9A 38 01 13 24        LCALL  0x2413, 0x138                ; UNKNOWN
017DAA  83 C4 06              ADD    sp, 6                        ; UNKNOWN
017DAD  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
017DB0  50                    PUSH   ax                           ; UNKNOWN
017DB1  9A 0C 00 13 24        LCALL  0x2413, 0xc                  ; UNKNOWN
017DB6  83 C4 02              ADD    sp, 2                        ; UNKNOWN
017DB9  FF 46 AC              INC    word ptr [bp - 0x54]         ; UNKNOWN
017DBC  83 7E AC 04           CMP    word ptr [bp - 0x54], 4      ; UNKNOWN
017DC0  7D 25                 JGE    0x17de7                      ; UNKNOWN
017DC2  83 7E AC 01           CMP    word ptr [bp - 0x54], 1      ; UNKNOWN
017DC6  75 CB                 JNE    0x17d93                      ; UNKNOWN
