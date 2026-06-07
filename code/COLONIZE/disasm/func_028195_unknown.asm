; ============================================================================
; func_028195_unknown
; Region   : load_image
; Bytes    : file 0x028195..0x0282A4  (271 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

028195  C8 0E 00 00           ENTER  0xe, 0                       ; UNKNOWN
028199  B8 01 00              MOV    ax, 1                        ; UNKNOWN
02819C  89 46 F4              MOV    word ptr [bp - 0xc], ax      ; UNKNOWN
02819F  89 46 F2              MOV    word ptr [bp - 0xe], ax      ; UNKNOWN
0281A2  8D 46 FA              LEA    ax, [bp - 6]                 ; UNKNOWN
0281A5  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; UNKNOWN
0281A8  8C 56 F8              MOV    word ptr [bp - 8], ss        ; UNKNOWN
0281AB  8D 1E 4C 19           LEA    bx, [0x194c]                 ; UNKNOWN
0281AF  2B C0                 SUB    ax, ax                       ; UNKNOWN
0281B1  9A 04 00 61 5D        LCALL  0x5d61, 4                    ; UNKNOWN
0281B6  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
0281B9  89 56 FE              MOV    word ptr [bp - 2], dx        ; UNKNOWN
0281BC  0B D0                 OR     dx, ax                       ; UNKNOWN
0281BE  75 03                 JNE    0x281c3                      ; UNKNOWN
0281C0  E9 DF 00              JMP    0x282a2                      ; UNKNOWN
0281C3  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
0281C6  50                    PUSH   ax                           ; UNKNOWN
0281C7  6A 00                 PUSH   0                            ; UNKNOWN
0281C9  B8 01 00              MOV    ax, 1                        ; UNKNOWN
0281CC  8D 5E F2              LEA    bx, [bp - 0xe]               ; UNKNOWN
0281CF  2B D2                 SUB    dx, dx                       ; UNKNOWN
0281D1  9A 0E 00 15 5D        LCALL  0x5d15, 0xe                  ; UNKNOWN
0281D6  8A 46 FA              MOV    al, byte ptr [bp - 6]        ; UNKNOWN
0281D9  2A E4                 SUB    ah, ah                       ; UNKNOWN
0281DB  A3 E4 09              MOV    word ptr [0x9e4], ax         ; UNKNOWN
0281DE  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
0281E1  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
0281E4  6A 00                 PUSH   0                            ; UNKNOWN
0281E6  B8 02 00              MOV    ax, 2                        ; UNKNOWN
0281E9  8D 5E F2              LEA    bx, [bp - 0xe]               ; UNKNOWN
0281EC  2B D2                 SUB    dx, dx                       ; UNKNOWN
0281EE  9A 0E 00 15 5D        LCALL  0x5d15, 0xe                  ; UNKNOWN
0281F3  8A 46 FA              MOV    al, byte ptr [bp - 6]        ; UNKNOWN
0281F6  2A E4                 SUB    ah, ah                       ; UNKNOWN
0281F8  A3 E6 09              MOV    word ptr [0x9e6], ax         ; UNKNOWN
0281FB  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
0281FE  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
028201  6A 00                 PUSH   0                            ; UNKNOWN
028203  B8 03 00              MOV    ax, 3                        ; UNKNOWN
028206  8D 5E F2              LEA    bx, [bp - 0xe]               ; UNKNOWN
028209  2B D2                 SUB    dx, dx                       ; UNKNOWN
02820B  9A 0E 00 15 5D        LCALL  0x5d15, 0xe                  ; UNKNOWN
028210  8A 46 FA              MOV    al, byte ptr [bp - 6]        ; UNKNOWN
028213  2A E4                 SUB    ah, ah                       ; UNKNOWN
028215  A3 E8 09              MOV    word ptr [0x9e8], ax         ; UNKNOWN
028218  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
02821B  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
02821E  6A 00                 PUSH   0                            ; UNKNOWN
028220  B8 04 00              MOV    ax, 4                        ; UNKNOWN
028223  8D 5E F2              LEA    bx, [bp - 0xe]               ; UNKNOWN
028226  2B D2                 SUB    dx, dx                       ; UNKNOWN
028228  9A 0E 00 15 5D        LCALL  0x5d15, 0xe                  ; UNKNOWN
02822D  8A 46 FA              MOV    al, byte ptr [bp - 6]        ; UNKNOWN
028230  2A E4                 SUB    ah, ah                       ; UNKNOWN
028232  A3 EA 09              MOV    word ptr [0x9ea], ax         ; UNKNOWN
028235  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
028238  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
02823B  6A 00                 PUSH   0                            ; UNKNOWN
02823D  B8 05 00              MOV    ax, 5                        ; UNKNOWN
028240  8D 5E F2              LEA    bx, [bp - 0xe]               ; UNKNOWN
028243  2B D2                 SUB    dx, dx                       ; UNKNOWN
028245  9A 0E 00 15 5D        LCALL  0x5d15, 0xe                  ; UNKNOWN
02824A  8A 46 FA              MOV    al, byte ptr [bp - 6]        ; UNKNOWN
02824D  2A E4                 SUB    ah, ah                       ; UNKNOWN
02824F  A3 F2 09              MOV    word ptr [0x9f2], ax         ; UNKNOWN
028252  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
028255  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
028258  6A 00                 PUSH   0                            ; UNKNOWN
02825A  B8 06 00              MOV    ax, 6                        ; UNKNOWN
02825D  8D 5E F2              LEA    bx, [bp - 0xe]               ; UNKNOWN
028260  2B D2                 SUB    dx, dx                       ; UNKNOWN
028262  9A 0E 00 15 5D        LCALL  0x5d15, 0xe                  ; UNKNOWN
028267  8A 46 FA              MOV    al, byte ptr [bp - 6]        ; UNKNOWN
02826A  2A E4                 SUB    ah, ah                       ; UNKNOWN
02826C  A3 F6 09              MOV    word ptr [0x9f6], ax         ; UNKNOWN
02826F  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
028272  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
028275  6A 00                 PUSH   0                            ; UNKNOWN
028277  B8 07 00              MOV    ax, 7                        ; UNKNOWN
02827A  8D 5E F2              LEA    bx, [bp - 0xe]               ; UNKNOWN
02827D  2B D2                 SUB    dx, dx                       ; UNKNOWN
02827F  9A 0E 00 15 5D        LCALL  0x5d15, 0xe                  ; UNKNOWN
028284  8A 46 FA              MOV    al, byte ptr [bp - 6]        ; UNKNOWN
028287  2A E4                 SUB    ah, ah                       ; UNKNOWN
028289  A3 F4 09              MOV    word ptr [0x9f4], ax         ; UNKNOWN
02828C  68 00 A0              PUSH   0xa000                       ; UNKNOWN
02828F  68 00 FC              PUSH   0xfc00                       ; UNKNOWN
028292  9A 02 00 F3 5B        LCALL  0x5bf3, 2                    ; UNKNOWN
028297  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
02829A  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
02829D  9A 06 01 4F 00        LCALL  0x4f, 0x106                  ; UNKNOWN
0282A2  C9                    LEAVE                               ; UNKNOWN
0282A3  CB                    RETF                                ; UNKNOWN
