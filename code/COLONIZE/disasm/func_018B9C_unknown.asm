; ============================================================================
; func_018B9C_unknown
; Region   : load_image
; Bytes    : file 0x018B9C..0x018D71  (469 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

018B9C  C8 76 00 00           ENTER  0x76, 0                      ; UNKNOWN
018BA0  83 3E 10 09 00        CMP    word ptr [0x910], 0          ; UNKNOWN
018BA5  74 5A                 JE     0x18c01                      ; UNKNOWN
018BA7  C6 46 A0 00           MOV    byte ptr [bp - 0x60], 0      ; UNKNOWN
018BAB  8D 46 FA              LEA    ax, [bp - 6]                 ; UNKNOWN
018BAE  50                    PUSH   ax                           ; UNKNOWN
018BAF  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
018BB3  8A 87 94 00           MOV    al, byte ptr [bx + 0x94]     ; UNKNOWN
018BB7  98                    CWDE                                ; UNKNOWN
018BB8  50                    PUSH   ax                           ; UNKNOWN
018BB9  9A 42 33 5F 24        LCALL  0x245f, 0x3342               ; UNKNOWN
018BBE  83 C4 04              ADD    sp, 4                        ; UNKNOWN
018BC1  89 46 96              MOV    word ptr [bp - 0x6a], ax     ; UNKNOWN
018BC4  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
018BC8  8A 87 94 00           MOV    al, byte ptr [bx + 0x94]     ; UNKNOWN
018BCC  98                    CWDE                                ; UNKNOWN
018BCD  50                    PUSH   ax                           ; UNKNOWN
018BCE  9A E4 32 5F 24        LCALL  0x245f, 0x32e4               ; UNKNOWN
018BD3  83 C4 02              ADD    sp, 2                        ; UNKNOWN
018BD6  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
018BD9  89 56 FE              MOV    word ptr [bp - 2], dx        ; UNKNOWN
018BDC  0B D0                 OR     dx, ax                       ; UNKNOWN
018BDE  74 11                 JE     0x18bf1                      ; UNKNOWN
018BE0  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
018BE3  50                    PUSH   ax                           ; UNKNOWN
018BE4  8D 46 A0              LEA    ax, [bp - 0x60]              ; UNKNOWN
018BE7  16                    PUSH   ss                           ; UNKNOWN
018BE8  50                    PUSH   ax                           ; UNKNOWN
018BE9  9A C0 14 65 5F        LCALL  0x5f65, 0x14c0               ; UNKNOWN
018BEE  83 C4 08              ADD    sp, 8                        ; UNKNOWN
018BF1  6A 39                 PUSH   0x39                         ; UNKNOWN
018BF3  68 84 00              PUSH   0x84                         ; UNKNOWN
018BF6  6A 5B                 PUSH   0x5b                         ; UNKNOWN
018BF8  68 D3 00              PUSH   0xd3                         ; UNKNOWN
018BFB  8D 46 A0              LEA    ax, [bp - 0x60]              ; UNKNOWN
018BFE  16                    PUSH   ss                           ; UNKNOWN
018BFF  EB 17                 JMP    0x18c18                      ; UNKNOWN
018C01  6A 39                 PUSH   0x39                         ; UNKNOWN
018C03  68 84 00              PUSH   0x84                         ; UNKNOWN
018C06  6A 5B                 PUSH   0x5b                         ; UNKNOWN
018C08  68 D3 00              PUSH   0xd3                         ; UNKNOWN
018C0B  FF 36 95 3B           PUSH   word ptr [0x3b95]            ; UNKNOWN
018C0F  9A 6C 00 E6 21        LCALL  0x21e6, 0x6c                 ; UNKNOWN
018C14  83 C4 02              ADD    sp, 2                        ; UNKNOWN
018C17  52                    PUSH   dx                           ; UNKNOWN
018C18  50                    PUSH   ax                           ; UNKNOWN
018C19  9A 1E 03 13 24        LCALL  0x2413, 0x31e                ; UNKNOWN
018C1E  83 C4 0C              ADD    sp, 0xc                      ; UNKNOWN
018C21  C7 46 9C 9E 00        MOV    word ptr [bp - 0x64], 0x9e   ; UNKNOWN
018C26  B8 D5 00              MOV    ax, 0xd5                     ; UNKNOWN
018C29  89 46 9E              MOV    word ptr [bp - 0x62], ax     ; UNKNOWN
018C2C  89 46 92              MOV    word ptr [bp - 0x6e], ax     ; UNKNOWN
018C2F  C7 46 94 12 00        MOV    word ptr [bp - 0x6c], 0x12   ; UNKNOWN
018C34  C7 46 8C 05 00        MOV    word ptr [bp - 0x74], 5      ; UNKNOWN
018C39  B8 10 00              MOV    ax, 0x10                     ; UNKNOWN
018C3C  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; UNKNOWN
018C3F  89 46 F2              MOV    word ptr [bp - 0xe], ax      ; UNKNOWN
018C42  2B C0                 SUB    ax, ax                       ; UNKNOWN
018C44  89 46 F0              MOV    word ptr [bp - 0x10], ax     ; UNKNOWN
018C47  89 46 98              MOV    word ptr [bp - 0x68], ax     ; UNKNOWN
018C4A  89 46 9A              MOV    word ptr [bp - 0x66], ax     ; UNKNOWN
018C4D  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
018C50  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
018C54  8A 07                 MOV    al, byte ptr [bx]            ; UNKNOWN
018C56  2A E4                 SUB    ah, ah                       ; UNKNOWN
018C58  8A 57 01              MOV    dl, byte ptr [bx + 1]        ; UNKNOWN
018C5B  2A F6                 SUB    dh, dh                       ; UNKNOWN
018C5D  9A 60 00 B7 36        LCALL  0x36b7, 0x60                 ; UNKNOWN
018C62  89 46 F4              MOV    word ptr [bp - 0xc], ax      ; UNKNOWN
018C65  E9 F7 00              JMP    0x18d5f                      ; UNKNOWN
018C68  FF 36 72 09           PUSH   word ptr [0x972]             ; UNKNOWN
018C6C  FF 36 70 09           PUSH   word ptr [0x970]             ; UNKNOWN
018C70  8B 46 F2              MOV    ax, word ptr [bp - 0xe]      ; UNKNOWN
018C73  03 46 90              ADD    ax, word ptr [bp - 0x70]     ; UNKNOWN
018C76  48                    DEC    ax                           ; UNKNOWN
018C77  50                    PUSH   ax                           ; UNKNOWN
018C78  6A 23                 PUSH   0x23                         ; UNKNOWN
018C7A  8B 46 8E              MOV    ax, word ptr [bp - 0x72]     ; UNKNOWN
018C7D  9A 67 00 76 1A        LCALL  0x1a76, 0x67                 ; UNKNOWN
018C82  8B 56 F6              MOV    dx, word ptr [bp - 0xa]      ; UNKNOWN
018C85  D1 FA                 SAR    dx, 1                        ; UNKNOWN
018C87  03 56 92              ADD    dx, word ptr [bp - 0x6e]     ; UNKNOWN
018C8A  8D 1E 82 CE           LEA    bx, [0xce82]                 ; UNKNOWN
018C8E  9A 02 00 35 5D        LCALL  0x5d35, 2                    ; UNKNOWN
018C93  A1 42 73              MOV    ax, word ptr [0x7342]        ; UNKNOWN
018C96  39 46 9A              CMP    word ptr [bp - 0x66], ax     ; UNKNOWN
018C99  75 68                 JNE    0x18d03                      ; UNKNOWN
018C9B  C7 46 8A 0A 00        MOV    word ptr [bp - 0x76], 0xa    ; UNKNOWN
018CA0  83 3E E8 0E 00        CMP    word ptr [0xee8], 0          ; UNKNOWN
018CA5  74 0C                 JE     0x18cb3                      ; UNKNOWN
018CA7  83 3E C6 32 04        CMP    word ptr [0x32c6], 4         ; UNKNOWN
018CAC  75 05                 JNE    0x18cb3                      ; UNKNOWN
018CAE  C7 46 8A 0F 00        MOV    word ptr [bp - 0x76], 0xf    ; UNKNOWN
018CB3  83 3E FB 08 03        CMP    word ptr [0x8fb], 3          ; UNKNOWN
018CB8  75 0C                 JNE    0x18cc6                      ; UNKNOWN
018CBA  83 3E 01 09 00        CMP    word ptr [0x901], 0          ; UNKNOWN
018CBF  74 05                 JE     0x18cc6                      ; UNKNOWN
018CC1  C7 46 8A 0F 00        MOV    word ptr [bp - 0x76], 0xf    ; UNKNOWN
018CC6  83 7E 8A 00           CMP    word ptr [bp - 0x76], 0      ; UNKNOWN
018CCA  74 37                 JE     0x18d03                      ; UNKNOWN
018CCC  83 3E 10 09 00        CMP    word ptr [0x910], 0          ; UNKNOWN
018CD1  75 30                 JNE    0x18d03                      ; UNKNOWN
018CD3  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
018CD7  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
018CDB  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
018CDF  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
018CE3  8B 46 F2              MOV    ax, word ptr [bp - 0xe]      ; UNKNOWN
018CE6  03 46 9C              ADD    ax, word ptr [bp - 0x64]     ; UNKNOWN
018CE9  50                    PUSH   ax                           ; UNKNOWN
018CEA  8A 46 8A              MOV    al, byte ptr [bp - 0x76]     ; UNKNOWN
018CED  50                    PUSH   ax                           ; UNKNOWN
018CEE  8B 46 92              MOV    ax, word ptr [bp - 0x6e]     ; UNKNOWN
018CF1  8B 5E F6              MOV    bx, word ptr [bp - 0xa]      ; UNKNOWN
018CF4  03 D8                 ADD    bx, ax                       ; UNKNOWN
018CF6  48                    DEC    ax                           ; UNKNOWN
018CF7  8B 56 9C              MOV    dx, word ptr [bp - 0x64]     ; UNKNOWN
018CFA  2B 56 F8              SUB    dx, word ptr [bp - 8]        ; UNKNOWN
018CFD  4A                    DEC    dx                           ; UNKNOWN
018CFE  9A 00 00 84 5A        LCALL  0x5a84, 0                    ; UNKNOWN
018D03  8B 46 94              MOV    ax, word ptr [bp - 0x6c]     ; UNKNOWN
018D06  01 46 92              ADD    word ptr [bp - 0x6e], ax     ; UNKNOWN
018D09  8B 46 8C              MOV    ax, word ptr [bp - 0x74]     ; UNKNOWN
018D0C  FF 46 F0              INC    word ptr [bp - 0x10]         ; UNKNOWN
018D0F  39 46 F0              CMP    word ptr [bp - 0x10], ax     ; UNKNOWN
018D12  7C 40                 JL     0x18d54                      ; UNKNOWN
018D14  C7 46 F0 00 00        MOV    word ptr [bp - 0x10], 0      ; UNKNOWN
018D19  FF 46 98              INC    word ptr [bp - 0x68]         ; UNKNOWN
018D1C  83 7E 98 03           CMP    word ptr [bp - 0x68], 3      ; UNKNOWN
018D20  7C 03                 JL     0x18d25                      ; UNKNOWN
018D22  E9 81 00              JMP    0x18da6                      ; UNKNOWN
018D25  83 7E 98 01           CMP    word ptr [bp - 0x68], 1      ; UNKNOWN
018D29  75 07                 JNE    0x18d32                      ; UNKNOWN
018D2B  C7 46 9C 98 00        MOV    word ptr [bp - 0x64], 0x98   ; UNKNOWN
018D30  EB 05                 JMP    0x18d37                      ; UNKNOWN
018D32  C7 46 9C 90 00        MOV    word ptr [bp - 0x64], 0x90   ; UNKNOWN
018D37  C7 46 92 D5 00        MOV    word ptr [bp - 0x6e], 0xd5   ; UNKNOWN
018D3C  C7 46 8C 11 00        MOV    word ptr [bp - 0x74], 0x11   ; UNKNOWN
018D41  C7 46 F6 03 00        MOV    word ptr [bp - 0xa], 3       ; UNKNOWN
018D46  B8 05 00              MOV    ax, 5                        ; UNKNOWN
018D49  89 46 94              MOV    word ptr [bp - 0x6c], ax     ; UNKNOWN
018D4C  89 46 F2              MOV    word ptr [bp - 0xe], ax      ; UNKNOWN
018D4F  C7 46 F8 01 00        MOV    word ptr [bp - 8], 1         ; UNKNOWN
018D54  FF 46 9A              INC    word ptr [bp - 0x66]         ; UNKNOWN
018D57  8B 46 8E              MOV    ax, word ptr [bp - 0x72]     ; UNKNOWN
018D5A  9A 4E 00 B7 36        LCALL  0x36b7, 0x4e                 ; UNKNOWN
018D5F  89 46 8E              MOV    word ptr [bp - 0x72], ax     ; UNKNOWN
018D62  0B C0                 OR     ax, ax                       ; UNKNOWN
018D64  7C 40                 JL     0x18da6                      ; UNKNOWN
018D66  6B D8 1C              IMUL   bx, ax, 0x1c                 ; UNKNOWN
018D69  8A 9F 82 88           MOV    bl, byte ptr [bx - 0x777e]   ; UNKNOWN
018D6D  2A FF                 SUB    bh, bh                       ; UNKNOWN
018D6F  8B C3                 MOV    ax, bx                       ; UNKNOWN
