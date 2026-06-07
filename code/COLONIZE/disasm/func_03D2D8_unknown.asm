; ============================================================================
; func_03D2D8_unknown
; Region   : load_image
; Bytes    : file 0x03D2D8..0x03D36F  (151 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03D2D8  55                    PUSH   bp                           ; UNKNOWN
03D2D9  8B EC                 MOV    bp, sp                       ; UNKNOWN
03D2DB  83 7E 04 00           CMP    word ptr [bp + 4], 0         ; UNKNOWN
03D2DF  75 03                 JNE    0x3d2e4                      ; UNKNOWN
03D2E1  E9 84 00              JMP    0x3d368                      ; UNKNOWN
03D2E4  83 7E 06 00           CMP    word ptr [bp + 6], 0         ; UNKNOWN
03D2E8  74 7E                 JE     0x3d368                      ; UNKNOWN
03D2EA  A1 88 82              MOV    ax, word ptr [0x8288]        ; UNKNOWN
03D2ED  39 46 04              CMP    word ptr [bp + 4], ax        ; UNKNOWN
03D2F0  7D 76                 JGE    0x3d368                      ; UNKNOWN
03D2F2  A1 8A 82              MOV    ax, word ptr [0x828a]        ; UNKNOWN
03D2F5  39 46 06              CMP    word ptr [bp + 6], ax        ; UNKNOWN
03D2F8  7D 6E                 JGE    0x3d368                      ; UNKNOWN
03D2FA  FF 36 12 83           PUSH   word ptr [0x8312]            ; UNKNOWN
03D2FE  FF 36 10 83           PUSH   word ptr [0x8310]            ; UNKNOWN
03D302  FF 36 0E 83           PUSH   word ptr [0x830e]            ; UNKNOWN
03D306  FF 36 0C 83           PUSH   word ptr [0x830c]            ; UNKNOWN
03D30A  8B 46 04              MOV    ax, word ptr [bp + 4]        ; UNKNOWN
03D30D  8B 56 06              MOV    dx, word ptr [bp + 6]        ; UNKNOWN
03D310  BB 01 00              MOV    bx, 1                        ; UNKNOWN
03D313  9A 08 00 73 5A        LCALL  0x5a73, 8                    ; UNKNOWN
03D318  A1 88 82              MOV    ax, word ptr [0x8288]        ; UNKNOWN
03D31B  48                    DEC    ax                           ; UNKNOWN
03D31C  3B 46 04              CMP    ax, word ptr [bp + 4]        ; UNKNOWN
03D31F  7E 1F                 JLE    0x3d340                      ; UNKNOWN
03D321  FF 36 12 83           PUSH   word ptr [0x8312]            ; UNKNOWN
03D325  FF 36 10 83           PUSH   word ptr [0x8310]            ; UNKNOWN
03D329  FF 36 0E 83           PUSH   word ptr [0x830e]            ; UNKNOWN
03D32D  FF 36 0C 83           PUSH   word ptr [0x830c]            ; UNKNOWN
03D331  8B 46 04              MOV    ax, word ptr [bp + 4]        ; UNKNOWN
03D334  40                    INC    ax                           ; UNKNOWN
03D335  8B 56 06              MOV    dx, word ptr [bp + 6]        ; UNKNOWN
03D338  BB 01 00              MOV    bx, 1                        ; UNKNOWN
03D33B  9A 08 00 73 5A        LCALL  0x5a73, 8                    ; UNKNOWN
03D340  A1 8A 82              MOV    ax, word ptr [0x828a]        ; UNKNOWN
03D343  48                    DEC    ax                           ; UNKNOWN
03D344  3B 46 06              CMP    ax, word ptr [bp + 6]        ; UNKNOWN
03D347  7E 1F                 JLE    0x3d368                      ; UNKNOWN
03D349  FF 36 12 83           PUSH   word ptr [0x8312]            ; UNKNOWN
03D34D  FF 36 10 83           PUSH   word ptr [0x8310]            ; UNKNOWN
03D351  FF 36 0E 83           PUSH   word ptr [0x830e]            ; UNKNOWN
03D355  FF 36 0C 83           PUSH   word ptr [0x830c]            ; UNKNOWN
03D359  8B 56 06              MOV    dx, word ptr [bp + 6]        ; UNKNOWN
03D35C  42                    INC    dx                           ; UNKNOWN
03D35D  8B 46 04              MOV    ax, word ptr [bp + 4]        ; UNKNOWN
03D360  BB 01 00              MOV    bx, 1                        ; UNKNOWN
03D363  9A 08 00 73 5A        LCALL  0x5a73, 8                    ; UNKNOWN
03D368  9A 05 03 EF 21        LCALL  0x21ef, 0x305                ; UNKNOWN
03D36D  C9                    LEAVE                               ; UNKNOWN
03D36E  C3                    RET                                 ; UNKNOWN
