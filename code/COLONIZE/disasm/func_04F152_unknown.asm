; ============================================================================
; func_04F152_unknown
; Region   : load_image
; Bytes    : file 0x04F152..0x04F234  (226 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04F152  C8 08 00 00           ENTER  8, 0                         ; UNKNOWN
04F156  6B 1E 0A 3E 1C        IMUL   bx, word ptr [0x3e0a], 0x1c  ; UNKNOWN
04F15B  8A 87 80 88           MOV    al, byte ptr [bx - 0x7780]   ; UNKNOWN
04F15F  2A E4                 SUB    ah, ah                       ; UNKNOWN
04F161  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
04F164  8A 8F 81 88           MOV    cl, byte ptr [bx - 0x777f]   ; UNKNOWN
04F168  2A ED                 SUB    ch, ch                       ; UNKNOWN
04F16A  89 4E FA              MOV    word ptr [bp - 6], cx        ; UNKNOWN
04F16D  8A 97 83 88           MOV    dl, byte ptr [bx - 0x777d]   ; UNKNOWN
04F171  83 E2 0F              AND    dx, 0xf                      ; UNKNOWN
04F174  69 DA 3C 01           IMUL   bx, dx, 0x13c                ; UNKNOWN
04F178  88 87 DC 74           MOV    byte ptr [bx + 0x74dc], al   ; UNKNOWN
04F17C  88 8F DD 74           MOV    byte ptr [bx + 0x74dd], cl   ; UNKNOWN
04F180  FF 36 0A 3E           PUSH   word ptr [0x3e0a]            ; UNKNOWN
04F184  9A D4 12 B7 36        LCALL  0x36b7, 0x12d4               ; UNKNOWN
04F189  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04F18C  FF 76 FA              PUSH   word ptr [bp - 6]            ; UNKNOWN
04F18F  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
04F192  FF 36 0A 3E           PUSH   word ptr [0x3e0a]            ; UNKNOWN
04F196  0E                    PUSH   cs                           ; UNKNOWN
04F197  E8 40 FF              CALL   0x4f0da                      ; UNKNOWN
04F19A  83 C4 06              ADD    sp, 6                        ; UNKNOWN
04F19D  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
04F1A0  A1 0A 3E              MOV    ax, word ptr [0x3e0a]        ; UNKNOWN
04F1A3  9A 08 00 B7 36        LCALL  0x36b7, 8                    ; UNKNOWN
04F1A8  EB 2A                 JMP    0x4f1d4                      ; UNKNOWN
04F1AA  6B 5E F8 1C           IMUL   bx, word ptr [bp - 8], 0x1c  ; UNKNOWN
04F1AE  C6 87 88 88 01        MOV    byte ptr [bx - 0x7778], 1    ; UNKNOWN
04F1B3  8A 46 FE              MOV    al, byte ptr [bp - 2]        ; UNKNOWN
04F1B6  6B 5E F8 1C           IMUL   bx, word ptr [bp - 8], 0x1c  ; UNKNOWN
04F1BA  88 87 89 88           MOV    byte ptr [bx - 0x7777], al   ; UNKNOWN
04F1BE  8A 46 FA              MOV    al, byte ptr [bp - 6]        ; UNKNOWN
04F1C1  88 87 8A 88           MOV    byte ptr [bx - 0x7776], al   ; UNKNOWN
04F1C5  8A 46 FC              MOV    al, byte ptr [bp - 4]        ; UNKNOWN
04F1C8  88 87 96 88           MOV    byte ptr [bx - 0x776a], al   ; UNKNOWN
04F1CC  8B 46 F8              MOV    ax, word ptr [bp - 8]        ; UNKNOWN
04F1CF  9A 4E 00 B7 36        LCALL  0x36b7, 0x4e                 ; UNKNOWN
04F1D4  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
04F1D7  0B C0                 OR     ax, ax                       ; UNKNOWN
04F1D9  7C 1A                 JL     0x4f1f5                      ; UNKNOWN
04F1DB  A1 0A 3E              MOV    ax, word ptr [0x3e0a]        ; UNKNOWN
04F1DE  39 46 F8              CMP    word ptr [bp - 8], ax        ; UNKNOWN
04F1E1  75 C7                 JNE    0x4f1aa                      ; UNKNOWN
04F1E3  6B 5E F8 1C           IMUL   bx, word ptr [bp - 8], 0x1c  ; UNKNOWN
04F1E7  80 BF 88 88 02        CMP    byte ptr [bx - 0x7778], 2    ; UNKNOWN
04F1EC  74 C5                 JE     0x4f1b3                      ; UNKNOWN
04F1EE  C6 87 88 88 00        MOV    byte ptr [bx - 0x7778], 0    ; UNKNOWN
04F1F3  EB BE                 JMP    0x4f1b3                      ; UNKNOWN
04F1F5  FF 36 0A 3E           PUSH   word ptr [0x3e0a]            ; UNKNOWN
04F1F9  9A 5F 09 B7 36        LCALL  0x36b7, 0x95f                ; UNKNOWN
04F1FE  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04F201  A1 0C 3E              MOV    ax, word ptr [0x3e0c]        ; UNKNOWN
04F204  83 E8 0C              SUB    ax, 0xc                      ; UNKNOWN
04F207  50                    PUSH   ax                           ; UNKNOWN
04F208  50                    PUSH   ax                           ; UNKNOWN
04F209  FF 36 0A 3E           PUSH   word ptr [0x3e0a]            ; UNKNOWN
04F20D  9A 0A 04 B7 36        LCALL  0x36b7, 0x40a                ; UNKNOWN
04F212  83 C4 06              ADD    sp, 6                        ; UNKNOWN
04F215  FF 36 0A 3E           PUSH   word ptr [0x3e0a]            ; UNKNOWN
04F219  9A D4 0C B7 36        LCALL  0x36b7, 0xcd4                ; UNKNOWN
04F21E  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04F221  6A 01                 PUSH   1                            ; UNKNOWN
04F223  6A 01                 PUSH   1                            ; UNKNOWN
04F225  6A 01                 PUSH   1                            ; UNKNOWN
04F227  FF 76 FA              PUSH   word ptr [bp - 6]            ; UNKNOWN
04F22A  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
04F22D  9A 0C 00 E4 35        LCALL  0x35e4, 0xc                  ; UNKNOWN
04F232  C9                    LEAVE                               ; UNKNOWN
04F233  CB                    RETF                                ; UNKNOWN
