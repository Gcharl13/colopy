; ============================================================================
; func_019009_unknown
; Region   : load_image
; Bytes    : file 0x019009..0x0190B5  (172 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

019009  C8 74 00 00           ENTER  0x74, 0                      ; UNKNOWN
01900D  C6 46 A4 00           MOV    byte ptr [bp - 0x5c], 0      ; UNKNOWN
019011  8D 46 FA              LEA    ax, [bp - 6]                 ; UNKNOWN
019014  50                    PUSH   ax                           ; UNKNOWN
019015  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
019019  8A 87 94 00           MOV    al, byte ptr [bx + 0x94]     ; UNKNOWN
01901D  98                    CWDE                                ; UNKNOWN
01901E  50                    PUSH   ax                           ; UNKNOWN
01901F  9A 42 33 5F 24        LCALL  0x245f, 0x3342               ; UNKNOWN
019024  83 C4 04              ADD    sp, 4                        ; UNKNOWN
019027  89 46 9C              MOV    word ptr [bp - 0x64], ax     ; UNKNOWN
01902A  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
01902E  8A 87 94 00           MOV    al, byte ptr [bx + 0x94]     ; UNKNOWN
019032  98                    CWDE                                ; UNKNOWN
019033  50                    PUSH   ax                           ; UNKNOWN
019034  9A E4 32 5F 24        LCALL  0x245f, 0x32e4               ; UNKNOWN
019039  83 C4 02              ADD    sp, 2                        ; UNKNOWN
01903C  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
01903F  89 56 FE              MOV    word ptr [bp - 2], dx        ; UNKNOWN
019042  0B D0                 OR     dx, ax                       ; UNKNOWN
019044  74 11                 JE     0x19057                      ; UNKNOWN
019046  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
019049  50                    PUSH   ax                           ; UNKNOWN
01904A  8D 46 A4              LEA    ax, [bp - 0x5c]              ; UNKNOWN
01904D  16                    PUSH   ss                           ; UNKNOWN
01904E  50                    PUSH   ax                           ; UNKNOWN
01904F  9A C0 14 65 5F        LCALL  0x5f65, 0x14c0               ; UNKNOWN
019054  83 C4 08              ADD    sp, 8                        ; UNKNOWN
019057  6A 39                 PUSH   0x39                         ; UNKNOWN
019059  68 84 00              PUSH   0x84                         ; UNKNOWN
01905C  6A 5B                 PUSH   0x5b                         ; UNKNOWN
01905E  68 D3 00              PUSH   0xd3                         ; UNKNOWN
019061  8D 46 A4              LEA    ax, [bp - 0x5c]              ; UNKNOWN
019064  16                    PUSH   ss                           ; UNKNOWN
019065  50                    PUSH   ax                           ; UNKNOWN
019066  9A 1E 03 13 24        LCALL  0x2413, 0x31e                ; UNKNOWN
01906B  83 C4 0C              ADD    sp, 0xc                      ; UNKNOWN
01906E  0E                    PUSH   cs                           ; UNKNOWN
01906F  E8 BB FE              CALL   0x18f2d                      ; UNKNOWN
019072  B8 5A 00              MOV    ax, 0x5a                     ; UNKNOWN
019075  C4 1E 70 09           LES    bx, ptr [0x970]              ; UNKNOWN
019079  26 8B 8F D2 02        MOV    cx, word ptr es:[bx + 0x2d2] ; UNKNOWN
01907E  89 4E 92              MOV    word ptr [bp - 0x6e], cx     ; UNKNOWN
019081  41                    INC    cx                           ; UNKNOWN
019082  99                    CDQ                                 ; UNKNOWN
019083  F7 F9                 IDIV   cx                           ; UNKNOWN
019085  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; UNKNOWN
019088  C7 46 96 04 00        MOV    word ptr [bp - 0x6a], 4      ; UNKNOWN
01908D  26 8B 8F D4 02        MOV    cx, word ptr es:[bx + 0x2d4] ; UNKNOWN
019092  D1 F9                 SAR    cx, 1                        ; UNKNOWN
019094  89 4E 90              MOV    word ptr [bp - 0x70], cx     ; UNKNOWN
019097  89 46 8E              MOV    word ptr [bp - 0x72], ax     ; UNKNOWN
01909A  8B C8                 MOV    cx, ax                       ; UNKNOWN
01909C  8B 46 9C              MOV    ax, word ptr [bp - 0x64]     ; UNKNOWN
01909F  48                    DEC    ax                           ; UNKNOWN
0190A0  8B D8                 MOV    bx, ax                       ; UNKNOWN
0190A2  99                    CDQ                                 ; UNKNOWN
0190A3  F7 F9                 IDIV   cx                           ; UNKNOWN
0190A5  40                    INC    ax                           ; UNKNOWN
0190A6  89 46 98              MOV    word ptr [bp - 0x68], ax     ; UNKNOWN
0190A9  83 F8 04              CMP    ax, 4                        ; UNKNOWN
0190AC  7E 17                 JLE    0x190c5                      ; UNKNOWN
0190AE  C7 46 98 04 00        MOV    word ptr [bp - 0x68], 4      ; UNKNOWN
0190B3  8B C3                 MOV    ax, bx                       ; UNKNOWN
