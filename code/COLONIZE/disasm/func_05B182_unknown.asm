; ============================================================================
; func_05B182_unknown
; Region   : load_image
; Bytes    : file 0x05B182..0x05B277  (245 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

05B182  C8 16 00 00           ENTER  0x16, 0                      ; UNKNOWN
05B186  56                    PUSH   si                           ; UNKNOWN
05B187  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
05B18B  8A 07                 MOV    al, byte ptr [bx]            ; UNKNOWN
05B18D  2A E4                 SUB    ah, ah                       ; UNKNOWN
05B18F  8A 57 01              MOV    dl, byte ptr [bx + 1]        ; UNKNOWN
05B192  2A F6                 SUB    dh, dh                       ; UNKNOWN
05B194  9A 60 00 B7 36        LCALL  0x36b7, 0x60                 ; UNKNOWN
05B199  89 46 F0              MOV    word ptr [bp - 0x10], ax     ; UNKNOWN
05B19C  0B C0                 OR     ax, ax                       ; UNKNOWN
05B19E  7C 10                 JL     0x5b1b0                      ; UNKNOWN
05B1A0  6A 0A                 PUSH   0xa                          ; UNKNOWN
05B1A2  50                    PUSH   ax                           ; UNKNOWN
05B1A3  9A 26 0D B7 36        LCALL  0x36b7, 0xd26                ; UNKNOWN
05B1A8  83 C4 04              ADD    sp, 4                        ; UNKNOWN
05B1AB  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
05B1AE  EB 05                 JMP    0x5b1b5                      ; UNKNOWN
05B1B0  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
05B1B5  C7 46 F2 FF FF        MOV    word ptr [bp - 0xe], 0xffff  ; UNKNOWN
05B1BA  2B C0                 SUB    ax, ax                       ; UNKNOWN
05B1BC  89 46 EC              MOV    word ptr [bp - 0x14], ax     ; UNKNOWN
05B1BF  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
05B1C2  89 46 EA              MOV    word ptr [bp - 0x16], ax     ; UNKNOWN
05B1C5  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
05B1C8  EB 77                 JMP    0x5b241                      ; UNKNOWN
05B1CA  8B 5E FA              MOV    bx, word ptr [bp - 6]        ; UNKNOWN
05B1CD  8A 87 2F 09           MOV    al, byte ptr [bx + 0x92f]    ; UNKNOWN
05B1D1  98                    CWDE                                ; UNKNOWN
05B1D2  8B 36 38 73           MOV    si, word ptr [0x7338]        ; UNKNOWN
05B1D6  8A 4C 01              MOV    cl, byte ptr [si + 1]        ; UNKNOWN
05B1D9  2A ED                 SUB    ch, ch                       ; UNKNOWN
05B1DB  03 C1                 ADD    ax, cx                       ; UNKNOWN
05B1DD  8B D0                 MOV    dx, ax                       ; UNKNOWN
05B1DF  8A 87 26 09           MOV    al, byte ptr [bx + 0x926]    ; UNKNOWN
05B1E3  98                    CWDE                                ; UNKNOWN
05B1E4  8A 0C                 MOV    cl, byte ptr [si]            ; UNKNOWN
05B1E6  03 C1                 ADD    ax, cx                       ; UNKNOWN
05B1E8  9A 60 00 B7 36        LCALL  0x36b7, 0x60                 ; UNKNOWN
05B1ED  89 46 F0              MOV    word ptr [bp - 0x10], ax     ; UNKNOWN
05B1F0  0B C0                 OR     ax, ax                       ; UNKNOWN
05B1F2  7C 4A                 JL     0x5b23e                      ; UNKNOWN
05B1F4  6B D8 1C              IMUL   bx, ax, 0x1c                 ; UNKNOWN
05B1F7  8A 8F 83 88           MOV    cl, byte ptr [bx - 0x777d]   ; UNKNOWN
05B1FB  83 E1 0F              AND    cx, 0xf                      ; UNKNOWN
05B1FE  89 4E EE              MOV    word ptr [bp - 0x12], cx     ; UNKNOWN
05B201  6A 0A                 PUSH   0xa                          ; UNKNOWN
05B203  50                    PUSH   ax                           ; UNKNOWN
05B204  9A 26 0D B7 36        LCALL  0x36b7, 0xd26                ; UNKNOWN
05B209  83 C4 04              ADD    sp, 4                        ; UNKNOWN
05B20C  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
05B20F  8B 46 EE              MOV    ax, word ptr [bp - 0x12]     ; UNKNOWN
05B212  39 46 0C              CMP    word ptr [bp + 0xc], ax      ; UNKNOWN
05B215  75 27                 JNE    0x5b23e                      ; UNKNOWN
05B217  6A 0B                 PUSH   0xb                          ; UNKNOWN
05B219  FF 76 F0              PUSH   word ptr [bp - 0x10]         ; UNKNOWN
05B21C  9A 26 0D B7 36        LCALL  0x36b7, 0xd26                ; UNKNOWN
05B221  83 C4 04              ADD    sp, 4                        ; UNKNOWN
05B224  C1 F8 03              SAR    ax, 3                        ; UNKNOWN
05B227  01 46 F8              ADD    word ptr [bp - 8], ax        ; UNKNOWN
05B22A  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
05B22D  01 46 EC              ADD    word ptr [bp - 0x14], ax     ; UNKNOWN
05B230  39 46 EA              CMP    word ptr [bp - 0x16], ax     ; UNKNOWN
05B233  7F 09                 JG     0x5b23e                      ; UNKNOWN
05B235  89 46 EA              MOV    word ptr [bp - 0x16], ax     ; UNKNOWN
05B238  8B 46 EE              MOV    ax, word ptr [bp - 0x12]     ; UNKNOWN
05B23B  89 46 F2              MOV    word ptr [bp - 0xe], ax      ; UNKNOWN
05B23E  FF 46 FA              INC    word ptr [bp - 6]            ; UNKNOWN
05B241  83 7E FA 08           CMP    word ptr [bp - 6], 8         ; UNKNOWN
05B245  7C 83                 JL     0x5b1ca                      ; UNKNOWN
05B247  83 7E 06 00           CMP    word ptr [bp + 6], 0         ; UNKNOWN
05B24B  74 08                 JE     0x5b255                      ; UNKNOWN
05B24D  8B 46 F2              MOV    ax, word ptr [bp - 0xe]      ; UNKNOWN
05B250  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
05B253  89 07                 MOV    word ptr [bx], ax            ; UNKNOWN
05B255  83 7E 08 00           CMP    word ptr [bp + 8], 0         ; UNKNOWN
05B259  74 08                 JE     0x5b263                      ; UNKNOWN
05B25B  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
05B25E  8B 5E 08              MOV    bx, word ptr [bp + 8]        ; UNKNOWN
05B261  89 07                 MOV    word ptr [bx], ax            ; UNKNOWN
05B263  83 7E 0A 00           CMP    word ptr [bp + 0xa], 0       ; UNKNOWN
05B267  74 08                 JE     0x5b271                      ; UNKNOWN
05B269  8B 46 EC              MOV    ax, word ptr [bp - 0x14]     ; UNKNOWN
05B26C  8B 5E 0A              MOV    bx, word ptr [bp + 0xa]      ; UNKNOWN
05B26F  89 07                 MOV    word ptr [bx], ax            ; UNKNOWN
05B271  8B 46 F8              MOV    ax, word ptr [bp - 8]        ; UNKNOWN
05B274  5E                    POP    si                           ; UNKNOWN
05B275  C9                    LEAVE                               ; UNKNOWN
05B276  CB                    RETF                                ; UNKNOWN
