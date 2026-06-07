; ============================================================================
; func_05A83C_unknown
; Region   : load_image
; Bytes    : file 0x05A83C..0x05A9FC  (448 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

05A83C  C8 DA 00 00           ENTER  0xda, 0                      ; UNKNOWN
05A840  56                    PUSH   si                           ; UNKNOWN
05A841  FF 36 86 3E           PUSH   word ptr [0x3e86]            ; UNKNOWN
05A845  9A 98 00 AA 0D        LCALL  0xdaa, 0x98                  ; UNKNOWN
05A84A  83 C4 02              ADD    sp, 2                        ; UNKNOWN
05A84D  68 38 2D              PUSH   0x2d38                       ; UNKNOWN
05A850  68 3F 2D              PUSH   0x2d3f                       ; UNKNOWN
05A853  9A 24 00 09 45        LCALL  0x4509, 0x24                 ; UNKNOWN
05A858  83 C4 04              ADD    sp, 4                        ; UNKNOWN
05A85B  C7 86 3A FF 0E 01     MOV    word ptr [bp - 0xc6], 0x10e  ; UNKNOWN
05A861  68 0E 01              PUSH   0x10e                        ; UNKNOWN
05A864  6A 00                 PUSH   0                            ; UNKNOWN
05A866  68 3A CC              PUSH   0xcc3a                       ; UNKNOWN
05A869  9A E8 0D 65 5F        LCALL  0x5f65, 0xde8                ; UNKNOWN
05A86E  83 C4 06              ADD    sp, 6                        ; UNKNOWN
05A871  2B C0                 SUB    ax, ax                       ; UNKNOWN
05A873  89 86 56 FF           MOV    word ptr [bp - 0xaa], ax     ; UNKNOWN
05A877  89 86 4C FF           MOV    word ptr [bp - 0xb4], ax     ; UNKNOWN
05A87B  EB 0D                 JMP    0x5a88a                      ; UNKNOWN
05A87D  8B 9E 4C FF           MOV    bx, word ptr [bp - 0xb4]     ; UNKNOWN
05A881  C6 87 6F 88 00        MOV    byte ptr [bx - 0x7791], 0    ; UNKNOWN
05A886  FF 86 4C FF           INC    word ptr [bp - 0xb4]         ; UNKNOWN
05A88A  83 BE 4C FF 08        CMP    word ptr [bp - 0xb4], 8      ; UNKNOWN
05A88F  7C EC                 JL     0x5a87d                      ; UNKNOWN
05A891  C7 86 4C FF 00 00     MOV    word ptr [bp - 0xb4], 0      ; UNKNOWN
05A897  E9 96 00              JMP    0x5a930                      ; UNKNOWN
05A89A  C7 86 26 FF 00 00     MOV    word ptr [bp - 0xda], 0      ; UNKNOWN
05A8A0  6A 0E                 PUSH   0xe                          ; UNKNOWN
05A8A2  6A 00                 PUSH   0                            ; UNKNOWN
05A8A4  9A DA 00 AA 0D        LCALL  0xdaa, 0xda                  ; UNKNOWN
05A8A9  83 C4 04              ADD    sp, 4                        ; UNKNOWN
05A8AC  03 86 26 FF           ADD    ax, word ptr [bp - 0xda]     ; UNKNOWN
05A8B0  8B B6 36 FF           MOV    si, word ptr [bp - 0xca]     ; UNKNOWN
05A8B4  D1 E6                 SHL    si, 1                        ; UNKNOWN
05A8B6  8B 1E 38 82           MOV    bx, word ptr [0x8238]        ; UNKNOWN
05A8BA  89 40 46              MOV    word ptr [bx + si + 0x46], ax ; UNKNOWN
05A8BD  8B 1E 38 82           MOV    bx, word ptr [0x8238]        ; UNKNOWN
05A8C1  8B B6 36 FF           MOV    si, word ptr [bp - 0xca]     ; UNKNOWN
05A8C5  C6 40 36 00           MOV    byte ptr [bx + si + 0x36], 0 ; UNKNOWN
05A8C9  FF 86 36 FF           INC    word ptr [bp - 0xca]         ; UNKNOWN
05A8CD  83 BE 36 FF 04        CMP    word ptr [bp - 0xca], 4      ; UNKNOWN
05A8D2  7D 1B                 JGE    0x5a8ef                      ; UNKNOWN
05A8D4  7D C4                 JGE    0x5a89a                      ; UNKNOWN
05A8D6  6B 9E 36 FF 34        IMUL   bx, word ptr [bp - 0xca], 0x34 ; UNKNOWN
05A8DB  80 BF B7 C0 00        CMP    byte ptr [bx - 0x3f49], 0    ; UNKNOWN
05A8E0  75 B8                 JNE    0x5a89a                      ; UNKNOWN
05A8E2  A0 1E 3E              MOV    al, byte ptr [0x3e1e]        ; UNKNOWN
05A8E5  2A E4                 SUB    ah, ah                       ; UNKNOWN
05A8E7  D1 E0                 SHL    ax, 1                        ; UNKNOWN
05A8E9  89 86 26 FF           MOV    word ptr [bp - 0xda], ax     ; UNKNOWN
05A8ED  EB B1                 JMP    0x5a8a0                      ; UNKNOWN
05A8EF  C7 86 36 FF 00 00     MOV    word ptr [bp - 0xca], 0      ; UNKNOWN
05A8F5  8B 1E 38 82           MOV    bx, word ptr [0x8238]        ; UNKNOWN
05A8F9  8B B6 36 FF           MOV    si, word ptr [bp - 0xca]     ; UNKNOWN
05A8FD  C6 40 3A 00           MOV    byte ptr [bx + si + 0x3a], 0 ; UNKNOWN
05A901  FF 86 36 FF           INC    word ptr [bp - 0xca]         ; UNKNOWN
05A905  83 BE 36 FF 0C        CMP    word ptr [bp - 0xca], 0xc    ; UNKNOWN
05A90A  7C E9                 JL     0x5a8f5                      ; UNKNOWN
05A90C  C7 86 36 FF 00 00     MOV    word ptr [bp - 0xca], 0      ; UNKNOWN
05A912  8B B6 36 FF           MOV    si, word ptr [bp - 0xca]     ; UNKNOWN
05A916  D1 E6                 SHL    si, 1                        ; UNKNOWN
05A918  8B 1E 38 82           MOV    bx, word ptr [0x8238]        ; UNKNOWN
05A91C  C7 40 0E 00 00        MOV    word ptr [bx + si + 0xe], 0  ; UNKNOWN
05A921  FF 86 36 FF           INC    word ptr [bp - 0xca]         ; UNKNOWN
05A925  83 BE 36 FF 10        CMP    word ptr [bp - 0xca], 0x10   ; UNKNOWN
05A92A  7C E6                 JL     0x5a912                      ; UNKNOWN
05A92C  FF 86 4C FF           INC    word ptr [bp - 0xb4]         ; UNKNOWN
05A930  83 BE 4C FF 08        CMP    word ptr [bp - 0xb4], 8      ; UNKNOWN
05A935  7D 57                 JGE    0x5a98e                      ; UNKNOWN
05A937  FF B6 4C FF           PUSH   word ptr [bp - 0xb4]         ; UNKNOWN
05A93B  9A 06 00 BA 33        LCALL  0x33ba, 6                    ; UNKNOWN
05A940  83 C4 02              ADD    sp, 2                        ; UNKNOWN
05A943  9A 0F 01 09 45        LCALL  0x4509, 0x10f                ; UNKNOWN
05A948  9A A0 01 09 45        LCALL  0x4509, 0x1a0                ; UNKNOWN
05A94D  9A A0 01 09 45        LCALL  0x4509, 0x1a0                ; UNKNOWN
05A952  9A A0 01 09 45        LCALL  0x4509, 0x1a0                ; UNKNOWN
05A957  9A A0 01 09 45        LCALL  0x4509, 0x1a0                ; UNKNOWN
05A95C  8B 1E 38 82           MOV    bx, word ptr [0x8238]        ; UNKNOWN
05A960  88 47 02              MOV    byte ptr [bx + 2], al        ; UNKNOWN
05A963  B0 01                 MOV    al, 1                        ; UNKNOWN
05A965  8B 1E 38 82           MOV    bx, word ptr [0x8238]        ; UNKNOWN
05A969  88 47 01              MOV    byte ptr [bx + 1], al        ; UNKNOWN
05A96C  88 07                 MOV    byte ptr [bx], al            ; UNKNOWN
05A96E  2A C0                 SUB    al, al                       ; UNKNOWN
05A970  88 47 04              MOV    byte ptr [bx + 4], al        ; UNKNOWN
05A973  88 47 05              MOV    byte ptr [bx + 5], al        ; UNKNOWN
05A976  88 47 06              MOV    byte ptr [bx + 6], al        ; UNKNOWN
05A979  88 47 07              MOV    byte ptr [bx + 7], al        ; UNKNOWN
05A97C  88 47 08              MOV    byte ptr [bx + 8], al        ; UNKNOWN
05A97F  2B C0                 SUB    ax, ax                       ; UNKNOWN
05A981  89 47 0A              MOV    word ptr [bx + 0xa], ax      ; UNKNOWN
05A984  89 47 0C              MOV    word ptr [bx + 0xc], ax      ; UNKNOWN
05A987  89 86 36 FF           MOV    word ptr [bp - 0xca], ax     ; UNKNOWN
05A98B  E9 3F FF              JMP    0x5a8cd                      ; UNKNOWN
05A98E  9A 05 03 EF 21        LCALL  0x21ef, 0x305                ; UNKNOWN
05A993  C7 86 3C FF 00 00     MOV    word ptr [bp - 0xc4], 0      ; UNKNOWN
05A999  83 3E 00 3E 00        CMP    word ptr [0x3e00], 0         ; UNKNOWN
05A99E  74 4E                 JE     0x5a9ee                      ; UNKNOWN
05A9A0  C7 86 3C FF 01 00     MOV    word ptr [bp - 0xc4], 1      ; UNKNOWN
05A9A6  68 45 2D              PUSH   0x2d45                       ; UNKNOWN
05A9A9  8D 86 58 FF           LEA    ax, [bp - 0xa8]              ; UNKNOWN
05A9AD  50                    PUSH   ax                           ; UNKNOWN
05A9AE  9A 74 07 65 5F        LCALL  0x5f65, 0x774                ; UNKNOWN
05A9B3  83 C4 04              ADD    sp, 4                        ; UNKNOWN
05A9B6  83 3E 3F 0A 00        CMP    word ptr [0xa3f], 0          ; UNKNOWN
05A9BB  74 20                 JE     0x5a9dd                      ; UNKNOWN
05A9BD  68 32 0A              PUSH   0xa32                        ; UNKNOWN
05A9C0  8D 86 58 FF           LEA    ax, [bp - 0xa8]              ; UNKNOWN
05A9C4  50                    PUSH   ax                           ; UNKNOWN
05A9C5  9A 74 07 65 5F        LCALL  0x5f65, 0x774                ; UNKNOWN
05A9CA  83 C4 04              ADD    sp, 4                        ; UNKNOWN
05A9CD  68 4F 2D              PUSH   0x2d4f                       ; UNKNOWN
05A9D0  8D 86 58 FF           LEA    ax, [bp - 0xa8]              ; UNKNOWN
05A9D4  50                    PUSH   ax                           ; UNKNOWN
05A9D5  9A 34 07 65 5F        LCALL  0x5f65, 0x734                ; UNKNOWN
05A9DA  83 C4 04              ADD    sp, 4                        ; UNKNOWN
05A9DD  8D 9E 58 FF           LEA    bx, [bp - 0xa8]              ; UNKNOWN
05A9E1  9A 3A 01 E9 5A        LCALL  0x5ae9, 0x13a                ; UNKNOWN
05A9E6  0B C0                 OR     ax, ax                       ; UNKNOWN
05A9E8  75 04                 JNE    0x5a9ee                      ; UNKNOWN
05A9EA  89 86 3C FF           MOV    word ptr [bp - 0xc4], ax     ; UNKNOWN
05A9EE  C7 86 4C FF 00 00     MOV    word ptr [bp - 0xb4], 0      ; UNKNOWN
05A9F4  EB 50                 JMP    0x5aa46                      ; UNKNOWN
05A9F6  8B 9E 4C FF           MOV    bx, word ptr [bp - 0xb4]     ; UNKNOWN
05A9FA  8B C3                 MOV    ax, bx                       ; UNKNOWN
