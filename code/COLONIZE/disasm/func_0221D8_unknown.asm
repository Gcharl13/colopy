; ============================================================================
; func_0221D8_unknown
; Region   : load_image
; Bytes    : file 0x0221D8..0x0222D0  (248 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0221D8  C8 24 00 00           ENTER  0x24, 0                      ; UNKNOWN
0221DC  57                    PUSH   di                           ; UNKNOWN
0221DD  56                    PUSH   si                           ; UNKNOWN
0221DE  C4 5E 06              LES    bx, ptr [bp + 6]             ; UNKNOWN
0221E1  26 8B 47 12           MOV    ax, word ptr es:[bx + 0x12]  ; UNKNOWN
0221E5  26 8B 57 14           MOV    dx, word ptr es:[bx + 0x14]  ; UNKNOWN
0221E9  89 46 E8              MOV    word ptr [bp - 0x18], ax     ; UNKNOWN
0221EC  89 56 EA              MOV    word ptr [bp - 0x16], dx     ; UNKNOWN
0221EF  8D 46 DC              LEA    ax, [bp - 0x24]              ; UNKNOWN
0221F2  50                    PUSH   ax                           ; UNKNOWN
0221F3  8D 4E E0              LEA    cx, [bp - 0x20]              ; UNKNOWN
0221F6  51                    PUSH   cx                           ; UNKNOWN
0221F7  8D 56 DE              LEA    dx, [bp - 0x22]              ; UNKNOWN
0221FA  52                    PUSH   dx                           ; UNKNOWN
0221FB  8D 76 E2              LEA    si, [bp - 0x1e]              ; UNKNOWN
0221FE  56                    PUSH   si                           ; UNKNOWN
0221FF  8D 7E E6              LEA    di, [bp - 0x1a]              ; UNKNOWN
022202  57                    PUSH   di                           ; UNKNOWN
022203  8D 46 E4              LEA    ax, [bp - 0x1c]              ; UNKNOWN
022206  50                    PUSH   ax                           ; UNKNOWN
022207  06                    PUSH   es                           ; UNKNOWN
022208  53                    PUSH   bx                           ; UNKNOWN
022209  0E                    PUSH   cs                           ; UNKNOWN
02220A  E8 B5 FE              CALL   0x220c2                      ; UNKNOWN
02220D  83 C4 10              ADD    sp, 0x10                     ; UNKNOWN
022210  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
022214  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
022218  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
02221C  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
022220  8B 46 DE              MOV    ax, word ptr [bp - 0x22]     ; UNKNOWN
022223  03 46 E6              ADD    ax, word ptr [bp - 0x1a]     ; UNKNOWN
022226  48                    DEC    ax                           ; UNKNOWN
022227  50                    PUSH   ax                           ; UNKNOWN
022228  C4 5E E8              LES    bx, ptr [bp - 0x18]          ; UNKNOWN
02222B  26 8A 47 1E           MOV    al, byte ptr es:[bx + 0x1e]  ; UNKNOWN
02222F  50                    PUSH   ax                           ; UNKNOWN
022230  8B 46 E4              MOV    ax, word ptr [bp - 0x1c]     ; UNKNOWN
022233  8B 5E E2              MOV    bx, word ptr [bp - 0x1e]     ; UNKNOWN
022236  03 D8                 ADD    bx, ax                       ; UNKNOWN
022238  8D 5F FF              LEA    bx, [bx - 1]                 ; UNKNOWN
02223B  8B 56 E6              MOV    dx, word ptr [bp - 0x1a]     ; UNKNOWN
02223E  9A 00 00 84 5A        LCALL  0x5a84, 0                    ; UNKNOWN
022243  8B 46 E4              MOV    ax, word ptr [bp - 0x1c]     ; UNKNOWN
022246  40                    INC    ax                           ; UNKNOWN
022247  89 46 E0              MOV    word ptr [bp - 0x20], ax     ; UNKNOWN
02224A  8B 4E E6              MOV    cx, word ptr [bp - 0x1a]     ; UNKNOWN
02224D  41                    INC    cx                           ; UNKNOWN
02224E  89 4E DC              MOV    word ptr [bp - 0x24], cx     ; UNKNOWN
022251  8B 56 E2              MOV    dx, word ptr [bp - 0x1e]     ; UNKNOWN
022254  4A                    DEC    dx                           ; UNKNOWN
022255  4A                    DEC    dx                           ; UNKNOWN
022256  89 56 F2              MOV    word ptr [bp - 0xe], dx      ; UNKNOWN
022259  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
02225D  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
022261  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
022265  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
022269  8B 5E DE              MOV    bx, word ptr [bp - 0x22]     ; UNKNOWN
02226C  4B                    DEC    bx                           ; UNKNOWN
02226D  4B                    DEC    bx                           ; UNKNOWN
02226E  53                    PUSH   bx                           ; UNKNOWN
02226F  FF 76 E4              PUSH   word ptr [bp - 0x1c]         ; UNKNOWN
022272  FF 76 E6              PUSH   word ptr [bp - 0x1a]         ; UNKNOWN
022275  FF 76 E2              PUSH   word ptr [bp - 0x1e]         ; UNKNOWN
022278  C4 5E E8              LES    bx, ptr [bp - 0x18]          ; UNKNOWN
02227B  26 8A 5F 12           MOV    bl, byte ptr es:[bx + 0x12]  ; UNKNOWN
02227F  53                    PUSH   bx                           ; UNKNOWN
022280  8B 5E E8              MOV    bx, word ptr [bp - 0x18]     ; UNKNOWN
022283  26 8A 5F 14           MOV    bl, byte ptr es:[bx + 0x14]  ; UNKNOWN
022287  53                    PUSH   bx                           ; UNKNOWN
022288  6A 00                 PUSH   0                            ; UNKNOWN
02228A  6A 00                 PUSH   0                            ; UNKNOWN
02228C  8B DA                 MOV    bx, dx                       ; UNKNOWN
02228E  8B D1                 MOV    dx, cx                       ; UNKNOWN
022290  8B F0                 MOV    si, ax                       ; UNKNOWN
022292  8B F9                 MOV    di, cx                       ; UNKNOWN
022294  E8 24 F4              CALL   0x216bb                      ; UNKNOWN
022297  C4 5E 06              LES    bx, ptr [bp + 6]             ; UNKNOWN
02229A  26 8B 47 1E           MOV    ax, word ptr es:[bx + 0x1e]  ; UNKNOWN
02229E  26 8B 57 20           MOV    dx, word ptr es:[bx + 0x20]  ; UNKNOWN
0222A2  89 46 EC              MOV    word ptr [bp - 0x14], ax     ; UNKNOWN
0222A5  89 56 EE              MOV    word ptr [bp - 0x12], dx     ; UNKNOWN
0222A8  C4 5E E8              LES    bx, ptr [bp - 0x18]          ; UNKNOWN
0222AB  26 03 77 0C           ADD    si, word ptr es:[bx + 0xc]   ; UNKNOWN
0222AF  89 76 F0              MOV    word ptr [bp - 0x10], si     ; UNKNOWN
0222B2  26 03 7F 08           ADD    di, word ptr es:[bx + 8]     ; UNKNOWN
0222B6  89 7E F4              MOV    word ptr [bp - 0xc], di      ; UNKNOWN
0222B9  0B D0                 OR     dx, ax                       ; UNKNOWN
0222BB  75 03                 JNE    0x222c0                      ; UNKNOWN
0222BD  E9 17 01              JMP    0x223d7                      ; UNKNOWN
0222C0  C4 5E EC              LES    bx, ptr [bp - 0x14]          ; UNKNOWN
0222C3  26 F6 07 02           TEST   byte ptr es:[bx], 2          ; UNKNOWN
0222C7  74 03                 JE     0x222cc                      ; UNKNOWN
0222C9  E9 F3 00              JMP    0x223bf                      ; UNKNOWN
0222CC  8C C2                 MOV    dx, es                       ; UNKNOWN
0222CE  39                    DB     0x39                         ; UNKNOWN (raw)
0222CF  46                    DB     0x46                         ; UNKNOWN (raw)
