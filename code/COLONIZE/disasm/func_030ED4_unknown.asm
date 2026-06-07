; ============================================================================
; func_030ED4_unknown
; Region   : load_image
; Bytes    : file 0x030ED4..0x030FE6  (274 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

030ED4  C8 08 00 00           ENTER  8, 0                         ; UNKNOWN
030ED8  C7 46 F8 00 00        MOV    word ptr [bp - 8], 0         ; UNKNOWN
030EDD  2B C0                 SUB    ax, ax                       ; UNKNOWN
030EDF  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
030EE2  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
030EE5  80 3E 65 74 00        CMP    byte ptr [0x7465], 0         ; UNKNOWN
030EEA  75 03                 JNE    0x30eef                      ; UNKNOWN
030EEC  E9 D9 00              JMP    0x30fc8                      ; UNKNOWN
030EEF  39 06 A4 09           CMP    word ptr [0x9a4], ax         ; UNKNOWN
030EF3  75 2C                 JNE    0x30f21                      ; UNKNOWN
030EF5  39 46 0C              CMP    word ptr [bp + 0xc], ax      ; UNKNOWN
030EF8  75 11                 JNE    0x30f0b                      ; UNKNOWN
030EFA  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
030EFE  8A 07                 MOV    al, byte ptr [bx]            ; UNKNOWN
030F00  2A E4                 SUB    ah, ah                       ; UNKNOWN
030F02  89 46 0C              MOV    word ptr [bp + 0xc], ax      ; UNKNOWN
030F05  8A 47 01              MOV    al, byte ptr [bx + 1]        ; UNKNOWN
030F08  89 46 0E              MOV    word ptr [bp + 0xe], ax      ; UNKNOWN
030F0B  6A 00                 PUSH   0                            ; UNKNOWN
030F0D  FF 76 0E              PUSH   word ptr [bp + 0xe]          ; UNKNOWN
030F10  FF 76 0C              PUSH   word ptr [bp + 0xc]          ; UNKNOWN
030F13  FF 76 0E              PUSH   word ptr [bp + 0xe]          ; UNKNOWN
030F16  FF 76 0C              PUSH   word ptr [bp + 0xc]          ; UNKNOWN
030F19  9A F9 02 0B 38        LCALL  0x380b, 0x2f9                ; UNKNOWN
030F1E  83 C4 0A              ADD    sp, 0xa                      ; UNKNOWN
030F21  A1 38 73              MOV    ax, word ptr [0x7338]        ; UNKNOWN
030F24  40                    INC    ax                           ; UNKNOWN
030F25  40                    INC    ax                           ; UNKNOWN
030F26  1E                    PUSH   ds                           ; UNKNOWN
030F27  50                    PUSH   ax                           ; UNKNOWN
030F28  6A 00                 PUSH   0                            ; UNKNOWN
030F2A  9A C9 03 97 1B        LCALL  0x1b97, 0x3c9                ; UNKNOWN
030F2F  83 C4 06              ADD    sp, 6                        ; UNKNOWN
030F32  8B 46 10              MOV    ax, word ptr [bp + 0x10]     ; UNKNOWN
030F35  A3 06 0A              MOV    word ptr [0xa06], ax         ; UNKNOWN
030F38  8D 1E 86 09           LEA    bx, [0x986]                  ; UNKNOWN
030F3C  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
030F3F  2B D2                 SUB    dx, dx                       ; UNKNOWN
030F41  9A 5A 32 97 1B        LCALL  0x1b97, 0x325a               ; UNKNOWN
030F46  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
030F49  89 56 FC              MOV    word ptr [bp - 4], dx        ; UNKNOWN
030F4C  0B D0                 OR     dx, ax                       ; UNKNOWN
030F4E  74 78                 JE     0x30fc8                      ; UNKNOWN
030F50  83 7E 08 00           CMP    word ptr [bp + 8], 0         ; UNKNOWN
030F54  74 43                 JE     0x30f99                      ; UNKNOWN
030F56  83 3E A4 09 00        CMP    word ptr [0x9a4], 0          ; UNKNOWN
030F5B  75 3C                 JNE    0x30f99                      ; UNKNOWN
030F5D  6A 01                 PUSH   1                            ; UNKNOWN
030F5F  FF 36 3E 33           PUSH   word ptr [0x333e]            ; UNKNOWN
030F63  9A 6C 00 E6 21        LCALL  0x21e6, 0x6c                 ; UNKNOWN
030F68  83 C4 02              ADD    sp, 2                        ; UNKNOWN
030F6B  52                    PUSH   dx                           ; UNKNOWN
030F6C  50                    PUSH   ax                           ; UNKNOWN
030F6D  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
030F70  FF 76 FA              PUSH   word ptr [bp - 6]            ; UNKNOWN
030F73  9A E6 09 97 1B        LCALL  0x1b97, 0x9e6                ; UNKNOWN
030F78  83 C4 0A              ADD    sp, 0xa                      ; UNKNOWN
030F7B  6A 02                 PUSH   2                            ; UNKNOWN
030F7D  FF 36 40 33           PUSH   word ptr [0x3340]            ; UNKNOWN
030F81  9A 6C 00 E6 21        LCALL  0x21e6, 0x6c                 ; UNKNOWN
030F86  83 C4 02              ADD    sp, 2                        ; UNKNOWN
030F89  52                    PUSH   dx                           ; UNKNOWN
030F8A  50                    PUSH   ax                           ; UNKNOWN
030F8B  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
030F8E  FF 76 FA              PUSH   word ptr [bp - 6]            ; UNKNOWN
030F91  9A E6 09 97 1B        LCALL  0x1b97, 0x9e6                ; UNKNOWN
030F96  83 C4 0A              ADD    sp, 0xa                      ; UNKNOWN
030F99  83 7E 12 00           CMP    word ptr [bp + 0x12], 0      ; UNKNOWN
030F9D  7E 08                 JLE    0x30fa7                      ; UNKNOWN
030F9F  8B 46 12              MOV    ax, word ptr [bp + 0x12]     ; UNKNOWN
030FA2  9A 0A 00 11 5D        LCALL  0x5d11, 0xa                  ; UNKNOWN
030FA7  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
030FAA  FF 76 FA              PUSH   word ptr [bp - 6]            ; UNKNOWN
030FAD  9A 4A 25 97 1B        LCALL  0x1b97, 0x254a               ; UNKNOWN
030FB2  83 F8 02              CMP    ax, 2                        ; UNKNOWN
030FB5  75 11                 JNE    0x30fc8                      ; UNKNOWN
030FB7  C7 46 F8 01 00        MOV    word ptr [bp - 8], 1         ; UNKNOWN
030FBC  83 7E 0A 00           CMP    word ptr [bp + 0xa], 0       ; UNKNOWN
030FC0  7C 06                 JL     0x30fc8                      ; UNKNOWN
030FC2  8A 46 0A              MOV    al, byte ptr [bp + 0xa]      ; UNKNOWN
030FC5  A2 04 09              MOV    byte ptr [0x904], al         ; UNKNOWN
030FC8  C7 06 06 0A FF FF     MOV    word ptr [0xa06], 0xffff     ; UNKNOWN
030FCE  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
030FD1  0B 46 FA              OR     ax, word ptr [bp - 6]        ; UNKNOWN
030FD4  74 0B                 JE     0x30fe1                      ; UNKNOWN
030FD6  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
030FD9  FF 76 FA              PUSH   word ptr [bp - 6]            ; UNKNOWN
030FDC  9A 06 01 4F 00        LCALL  0x4f, 0x106                  ; UNKNOWN
030FE1  8A 46 F8              MOV    al, byte ptr [bp - 8]        ; UNKNOWN
030FE4  C9                    LEAVE                               ; UNKNOWN
030FE5  CB                    RETF                                ; UNKNOWN
