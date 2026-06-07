; ============================================================================
; func_019202_unknown
; Region   : load_image
; Bytes    : file 0x019202..0x0192C0  (190 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

019202  C8 74 00 00           ENTER  0x74, 0                      ; UNKNOWN
019206  56                    PUSH   si                           ; UNKNOWN
019207  6A 30                 PUSH   0x30                         ; UNKNOWN
019209  6A 54                 PUSH   0x54                         ; UNKNOWN
01920B  68 82 00              PUSH   0x82                         ; UNKNOWN
01920E  6A 79                 PUSH   0x79                         ; UNKNOWN
019210  0E                    PUSH   cs                           ; UNKNOWN
019211  E8 91 E5              CALL   0x177a5                      ; UNKNOWN
019214  83 C4 08              ADD    sp, 8                        ; UNKNOWN
019217  83 3E DB 0A 00        CMP    word ptr [0xadb], 0          ; UNKNOWN
01921C  75 68                 JNE    0x19286                      ; UNKNOWN
01921E  6A 39                 PUSH   0x39                         ; UNKNOWN
019220  68 84 00              PUSH   0x84                         ; UNKNOWN
019223  6A 54                 PUSH   0x54                         ; UNKNOWN
019225  6A 79                 PUSH   0x79                         ; UNKNOWN
019227  FF 36 10 33           PUSH   word ptr [0x3310]            ; UNKNOWN
01922B  9A 6C 00 E6 21        LCALL  0x21e6, 0x6c                 ; UNKNOWN
019230  83 C4 02              ADD    sp, 2                        ; UNKNOWN
019233  52                    PUSH   dx                           ; UNKNOWN
019234  50                    PUSH   ax                           ; UNKNOWN
019235  9A 1E 03 13 24        LCALL  0x2413, 0x31e                ; UNKNOWN
01923A  83 C4 0C              ADD    sp, 0xc                      ; UNKNOWN
01923D  C7 46 9E 00 00        MOV    word ptr [bp - 0x62], 0      ; UNKNOWN
019242  EB 03                 JMP    0x19247                      ; UNKNOWN
019244  FF 46 9E              INC    word ptr [bp - 0x62]         ; UNKNOWN
019247  83 7E 9E 06           CMP    word ptr [bp - 0x62], 6      ; UNKNOWN
01924B  7C 03                 JL     0x19250                      ; UNKNOWN
01924D  E9 2C 03              JMP    0x1957c                      ; UNKNOWN
019250  8D 46 98              LEA    ax, [bp - 0x68]              ; UNKNOWN
019253  50                    PUSH   ax                           ; UNKNOWN
019254  8D 46 9A              LEA    ax, [bp - 0x66]              ; UNKNOWN
019257  50                    PUSH   ax                           ; UNKNOWN
019258  8D 46 A4              LEA    ax, [bp - 0x5c]              ; UNKNOWN
01925B  50                    PUSH   ax                           ; UNKNOWN
01925C  8D 4E A6              LEA    cx, [bp - 0x5a]              ; UNKNOWN
01925F  51                    PUSH   cx                           ; UNKNOWN
019260  FF 76 9E              PUSH   word ptr [bp - 0x62]         ; UNKNOWN
019263  0E                    PUSH   cs                           ; UNKNOWN
019264  E8 6D FF              CALL   0x191d4                      ; UNKNOWN
019267  83 C4 0A              ADD    sp, 0xa                      ; UNKNOWN
01926A  FF 36 72 09           PUSH   word ptr [0x972]             ; UNKNOWN
01926E  FF 36 70 09           PUSH   word ptr [0x970]             ; UNKNOWN
019272  FF 76 A4              PUSH   word ptr [bp - 0x5c]         ; UNKNOWN
019275  B8 7B 00              MOV    ax, 0x7b                     ; UNKNOWN
019278  8D 1E 82 CE           LEA    bx, [0xce82]                 ; UNKNOWN
01927C  8B 56 A6              MOV    dx, word ptr [bp - 0x5a]     ; UNKNOWN
01927F  9A 0E 00 15 5D        LCALL  0x5d15, 0xe                  ; UNKNOWN
019284  EB BE                 JMP    0x19244                      ; UNKNOWN
019286  C6 46 B0 00           MOV    byte ptr [bp - 0x50], 0      ; UNKNOWN
01928A  FF 36 28 33           PUSH   word ptr [0x3328]            ; UNKNOWN
01928E  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
019291  50                    PUSH   ax                           ; UNKNOWN
019292  9A ED 00 13 24        LCALL  0x2413, 0xed                 ; UNKNOWN
019297  83 C4 04              ADD    sp, 4                        ; UNKNOWN
01929A  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
01929D  50                    PUSH   ax                           ; UNKNOWN
01929E  9A 4D 00 13 24        LCALL  0x2413, 0x4d                 ; UNKNOWN
0192A3  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0192A6  FF 36 DD 0A           PUSH   word ptr [0xadd]             ; UNKNOWN
0192AA  9A 2F 2F 5F 24        LCALL  0x245f, 0x2f2f               ; UNKNOWN
0192AF  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0192B2  89 46 90              MOV    word ptr [bp - 0x70], ax     ; UNKNOWN
0192B5  6B D8 1C              IMUL   bx, ax, 0x1c                 ; UNKNOWN
0192B8  8A 9F 82 88           MOV    bl, byte ptr [bx - 0x777e]   ; UNKNOWN
0192BC  2A FF                 SUB    bh, bh                       ; UNKNOWN
0192BE  8B C3                 MOV    ax, bx                       ; UNKNOWN
