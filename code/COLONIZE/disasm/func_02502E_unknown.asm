; ============================================================================
; func_02502E_unknown
; Region   : load_image
; Bytes    : file 0x02502E..0x0251F8  (458 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02502E  C8 14 00 00           ENTER  0x14, 0                      ; UNKNOWN
025032  2B C0                 SUB    ax, ax                       ; UNKNOWN
025034  89 46 EE              MOV    word ptr [bp - 0x12], ax     ; UNKNOWN
025037  89 46 EC              MOV    word ptr [bp - 0x14], ax     ; UNKNOWN
02503A  A3 16 0A              MOV    word ptr [0xa16], ax         ; UNKNOWN
02503D  A3 18 0A              MOV    word ptr [0xa18], ax         ; UNKNOWN
025040  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
025043  05 96 00              ADD    ax, 0x96                     ; UNKNOWN
025046  2B D2                 SUB    dx, dx                       ; UNKNOWN
025048  9A FC 00 4F 00        LCALL  0x4f, 0xfc                   ; UNKNOWN
02504D  89 46 F0              MOV    word ptr [bp - 0x10], ax     ; UNKNOWN
025050  89 56 F2              MOV    word ptr [bp - 0xe], dx      ; UNKNOWN
025053  0B D0                 OR     dx, ax                       ; UNKNOWN
025055  75 03                 JNE    0x2505a                      ; UNKNOWN
025057  E9 73 01              JMP    0x251cd                      ; UNKNOWN
02505A  8B 56 F2              MOV    dx, word ptr [bp - 0xe]      ; UNKNOWN
02505D  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
025060  89 56 FA              MOV    word ptr [bp - 6], dx        ; UNKNOWN
025063  05 96 00              ADD    ax, 0x96                     ; UNKNOWN
025066  8B 4E F8              MOV    cx, word ptr [bp - 8]        ; UNKNOWN
025069  8B DA                 MOV    bx, dx                       ; UNKNOWN
02506B  81 C1 84 00           ADD    cx, 0x84                     ; UNKNOWN
02506F  53                    PUSH   bx                           ; UNKNOWN
025070  51                    PUSH   cx                           ; UNKNOWN
025071  52                    PUSH   dx                           ; UNKNOWN
025072  50                    PUSH   ax                           ; UNKNOWN
025073  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
025076  99                    CDQ                                 ; UNKNOWN
025077  52                    PUSH   dx                           ; UNKNOWN
025078  50                    PUSH   ax                           ; UNKNOWN
025079  B8 29 00              MOV    ax, 0x29                     ; UNKNOWN
02507C  9A 95 00 7A 5B        LCALL  0x5b7a, 0x95                 ; UNKNOWN
025081  C4 5E F8              LES    bx, ptr [bp - 8]             ; UNKNOWN
025084  2B C0                 SUB    ax, ax                       ; UNKNOWN
025086  26 89 47 4E           MOV    word ptr es:[bx + 0x4e], ax  ; UNKNOWN
02508A  26 89 47 4C           MOV    word ptr es:[bx + 0x4c], ax  ; UNKNOWN
02508E  26 89 47 52           MOV    word ptr es:[bx + 0x52], ax  ; UNKNOWN
025092  26 89 47 50           MOV    word ptr es:[bx + 0x50], ax  ; UNKNOWN
025096  A1 FE 09              MOV    ax, word ptr [0x9fe]         ; UNKNOWN
025099  26 89 47 0A           MOV    word ptr es:[bx + 0xa], ax   ; UNKNOWN
02509D  A1 00 0A              MOV    ax, word ptr [0xa00]         ; UNKNOWN
0250A0  26 89 47 0C           MOV    word ptr es:[bx + 0xc], ax   ; UNKNOWN
0250A4  A1 02 0A              MOV    ax, word ptr [0xa02]         ; UNKNOWN
0250A7  26 89 47 0E           MOV    word ptr es:[bx + 0xe], ax   ; UNKNOWN
0250AB  B8 FF FF              MOV    ax, 0xffff                   ; UNKNOWN
0250AE  A3 00 0A              MOV    word ptr [0xa00], ax         ; UNKNOWN
0250B1  A3 02 0A              MOV    word ptr [0xa02], ax         ; UNKNOWN
0250B4  26 C7 47 28 50 00     MOV    word ptr es:[bx + 0x28], 0x50 ; UNKNOWN
0250BA  B8 04 00              MOV    ax, 4                        ; UNKNOWN
0250BD  26 89 47 22           MOV    word ptr es:[bx + 0x22], ax  ; UNKNOWN
0250C1  26 89 47 32           MOV    word ptr es:[bx + 0x32], ax  ; UNKNOWN
0250C5  A1 E4 09              MOV    ax, word ptr [0x9e4]         ; UNKNOWN
0250C8  26 89 47 3C           MOV    word ptr es:[bx + 0x3c], ax  ; UNKNOWN
0250CC  A1 E6 09              MOV    ax, word ptr [0x9e6]         ; UNKNOWN
0250CF  26 89 47 3E           MOV    word ptr es:[bx + 0x3e], ax  ; UNKNOWN
0250D3  A1 E8 09              MOV    ax, word ptr [0x9e8]         ; UNKNOWN
0250D6  26 89 47 40           MOV    word ptr es:[bx + 0x40], ax  ; UNKNOWN
0250DA  A1 EA 09              MOV    ax, word ptr [0x9ea]         ; UNKNOWN
0250DD  26 89 47 42           MOV    word ptr es:[bx + 0x42], ax  ; UNKNOWN
0250E1  A1 EC 09              MOV    ax, word ptr [0x9ec]         ; UNKNOWN
0250E4  26 89 47 44           MOV    word ptr es:[bx + 0x44], ax  ; UNKNOWN
0250E8  26 8A 47 0A           MOV    al, byte ptr es:[bx + 0xa]   ; UNKNOWN
0250EC  83 E0 10              AND    ax, 0x10                     ; UNKNOWN
0250EF  83 F8 01              CMP    ax, 1                        ; UNKNOWN
0250F2  1B C9                 SBB    cx, cx                       ; UNKNOWN
0250F4  83 E1 03              AND    cx, 3                        ; UNKNOWN
0250F7  26 89 4F 46           MOV    word ptr es:[bx + 0x46], cx  ; UNKNOWN
0250FB  83 F8 01              CMP    ax, 1                        ; UNKNOWN
0250FE  1B C0                 SBB    ax, ax                       ; UNKNOWN
025100  83 E0 02              AND    ax, 2                        ; UNKNOWN
025103  26 89 47 48           MOV    word ptr es:[bx + 0x48], ax  ; UNKNOWN
025107  2B C0                 SUB    ax, ax                       ; UNKNOWN
025109  26 89 47 56           MOV    word ptr es:[bx + 0x56], ax  ; UNKNOWN
02510D  26 89 47 54           MOV    word ptr es:[bx + 0x54], ax  ; UNKNOWN
025111  26 89 47 5A           MOV    word ptr es:[bx + 0x5a], ax  ; UNKNOWN
025115  26 89 47 58           MOV    word ptr es:[bx + 0x58], ax  ; UNKNOWN
025119  26 89 47 5E           MOV    word ptr es:[bx + 0x5e], ax  ; UNKNOWN
02511D  26 89 47 5C           MOV    word ptr es:[bx + 0x5c], ax  ; UNKNOWN
025121  26 89 47 62           MOV    word ptr es:[bx + 0x62], ax  ; UNKNOWN
025125  26 89 47 60           MOV    word ptr es:[bx + 0x60], ax  ; UNKNOWN
025129  26 89 47 72           MOV    word ptr es:[bx + 0x72], ax  ; UNKNOWN
02512D  26 89 47 70           MOV    word ptr es:[bx + 0x70], ax  ; UNKNOWN
025131  26 89 47 66           MOV    word ptr es:[bx + 0x66], ax  ; UNKNOWN
025135  26 89 47 64           MOV    word ptr es:[bx + 0x64], ax  ; UNKNOWN
025139  26 89 47 6A           MOV    word ptr es:[bx + 0x6a], ax  ; UNKNOWN
02513D  26 89 47 68           MOV    word ptr es:[bx + 0x68], ax  ; UNKNOWN
025141  26 89 47 6E           MOV    word ptr es:[bx + 0x6e], ax  ; UNKNOWN
025145  26 89 47 6C           MOV    word ptr es:[bx + 0x6c], ax  ; UNKNOWN
025149  FF 36 FA 09           PUSH   word ptr [0x9fa]             ; UNKNOWN
02514D  FF 36 F8 09           PUSH   word ptr [0x9f8]             ; UNKNOWN
025151  FF 36 F6 09           PUSH   word ptr [0x9f6]             ; UNKNOWN
025155  FF 36 F4 09           PUSH   word ptr [0x9f4]             ; UNKNOWN
025159  FF 36 F2 09           PUSH   word ptr [0x9f2]             ; UNKNOWN
02515D  26 89 07              MOV    word ptr es:[bx], ax         ; UNKNOWN
025160  26 89 47 02           MOV    word ptr es:[bx + 2], ax     ; UNKNOWN
025164  26 89 47 04           MOV    word ptr es:[bx + 4], ax     ; UNKNOWN
025168  26 89 47 06           MOV    word ptr es:[bx + 6], ax     ; UNKNOWN
02516C  26 89 47 08           MOV    word ptr es:[bx + 8], ax     ; UNKNOWN
025170  A3 FE 09              MOV    word ptr [0x9fe], ax         ; UNKNOWN
025173  26 89 47 20           MOV    word ptr es:[bx + 0x20], ax  ; UNKNOWN
025177  26 89 47 24           MOV    word ptr es:[bx + 0x24], ax  ; UNKNOWN
02517B  26 89 47 26           MOV    word ptr es:[bx + 0x26], ax  ; UNKNOWN
02517F  26 89 47 2A           MOV    word ptr es:[bx + 0x2a], ax  ; UNKNOWN
025183  26 89 47 2C           MOV    word ptr es:[bx + 0x2c], ax  ; UNKNOWN
025187  26 89 47 2E           MOV    word ptr es:[bx + 0x2e], ax  ; UNKNOWN
02518B  26 89 47 30           MOV    word ptr es:[bx + 0x30], ax  ; UNKNOWN
02518F  26 89 47 34           MOV    word ptr es:[bx + 0x34], ax  ; UNKNOWN
025193  26 89 47 36           MOV    word ptr es:[bx + 0x36], ax  ; UNKNOWN
025197  26 89 47 38           MOV    word ptr es:[bx + 0x38], ax  ; UNKNOWN
02519B  26 89 47 4A           MOV    word ptr es:[bx + 0x4a], ax  ; UNKNOWN
02519F  50                    PUSH   ax                           ; UNKNOWN
0251A0  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
0251A3  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
0251A6  8D 47 74              LEA    ax, [bx + 0x74]              ; UNKNOWN
0251A9  06                    PUSH   es                           ; UNKNOWN
0251AA  50                    PUSH   ax                           ; UNKNOWN
0251AB  0E                    PUSH   cs                           ; UNKNOWN
0251AC  E8 FE FB              CALL   0x24dad                      ; UNKNOWN
0251AF  83 C4 14              ADD    sp, 0x14                     ; UNKNOWN
0251B2  83 3E 92 CE 00        CMP    word ptr [0xce92], 0         ; UNKNOWN
0251B7  75 08                 JNE    0x251c1                      ; UNKNOWN
0251B9  C4 5E F8              LES    bx, ptr [bp - 8]             ; UNKNOWN
0251BC  26 80 4F 0A 80        OR     byte ptr es:[bx + 0xa], 0x80 ; UNKNOWN
0251C1  8B 46 F8              MOV    ax, word ptr [bp - 8]        ; UNKNOWN
0251C4  8B 56 FA              MOV    dx, word ptr [bp - 6]        ; UNKNOWN
0251C7  89 46 EC              MOV    word ptr [bp - 0x14], ax     ; UNKNOWN
0251CA  89 56 EE              MOV    word ptr [bp - 0x12], dx     ; UNKNOWN
0251CD  8B 46 F2              MOV    ax, word ptr [bp - 0xe]      ; UNKNOWN
0251D0  0B 46 F0              OR     ax, word ptr [bp - 0x10]     ; UNKNOWN
0251D3  74 1B                 JE     0x251f0                      ; UNKNOWN
0251D5  8B 46 EC              MOV    ax, word ptr [bp - 0x14]     ; UNKNOWN
0251D8  8B 56 EE              MOV    dx, word ptr [bp - 0x12]     ; UNKNOWN
0251DB  39 46 F0              CMP    word ptr [bp - 0x10], ax     ; UNKNOWN
0251DE  75 05                 JNE    0x251e5                      ; UNKNOWN
0251E0  39 56 F2              CMP    word ptr [bp - 0xe], dx      ; UNKNOWN
0251E3  74 0B                 JE     0x251f0                      ; UNKNOWN
0251E5  FF 76 F2              PUSH   word ptr [bp - 0xe]          ; UNKNOWN
0251E8  FF 76 F0              PUSH   word ptr [bp - 0x10]         ; UNKNOWN
0251EB  9A 06 01 4F 00        LCALL  0x4f, 0x106                  ; UNKNOWN
0251F0  8B 46 EC              MOV    ax, word ptr [bp - 0x14]     ; UNKNOWN
0251F3  8B 56 EE              MOV    dx, word ptr [bp - 0x12]     ; UNKNOWN
0251F6  C9                    LEAVE                               ; UNKNOWN
0251F7  CB                    RETF                                ; UNKNOWN
