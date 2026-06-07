; ============================================================================
; func_02C99B_unknown
; Region   : load_image
; Bytes    : file 0x02C99B..0x02CA87  (236 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02C99B  C8 62 00 00           ENTER  0x62, 0                      ; UNKNOWN
02C99F  C4 1E 20 0C           LES    bx, ptr [0xc20]              ; UNKNOWN
02C9A3  26 8A 07              MOV    al, byte ptr es:[bx]         ; UNKNOWN
02C9A6  8B C8                 MOV    cx, ax                       ; UNKNOWN
02C9A8  D0 E8                 SHR    al, 1                        ; UNKNOWN
02C9AA  2A E4                 SUB    ah, ah                       ; UNKNOWN
02C9AC  83 E8 14              SUB    ax, 0x14                     ; UNKNOWN
02C9AF  F7 D8                 NEG    ax                           ; UNKNOWN
02C9B1  89 46 A6              MOV    word ptr [bp - 0x5a], ax     ; UNKNOWN
02C9B4  2A ED                 SUB    ch, ch                       ; UNKNOWN
02C9B6  8B D0                 MOV    dx, ax                       ; UNKNOWN
02C9B8  03 C1                 ADD    ax, cx                       ; UNKNOWN
02C9BA  83 C0 04              ADD    ax, 4                        ; UNKNOWN
02C9BD  89 46 A2              MOV    word ptr [bp - 0x5e], ax     ; UNKNOWN
02C9C0  03 C8                 ADD    cx, ax                       ; UNKNOWN
02C9C2  83 C1 04              ADD    cx, 4                        ; UNKNOWN
02C9C5  89 4E A0              MOV    word ptr [bp - 0x60], cx     ; UNKNOWN
02C9C8  C6 46 9E FE           MOV    byte ptr [bp - 0x62], 0xfe   ; UNKNOWN
02C9CC  68 FD 00              PUSH   0xfd                         ; UNKNOWN
02C9CF  68 FE 00              PUSH   0xfe                         ; UNKNOWN
02C9D2  52                    PUSH   dx                           ; UNKNOWN
02C9D3  B8 44 00              MOV    ax, 0x44                     ; UNKNOWN
02C9D6  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
02C9D9  50                    PUSH   ax                           ; UNKNOWN
02C9DA  B8 17 00              MOV    ax, 0x17                     ; UNKNOWN
02C9DD  89 46 AA              MOV    word ptr [bp - 0x56], ax     ; UNKNOWN
02C9E0  50                    PUSH   ax                           ; UNKNOWN
02C9E1  FF 36 3E 34           PUSH   word ptr [0x343e]            ; UNKNOWN
02C9E5  9A 6C 00 E6 21        LCALL  0x21e6, 0x6c                 ; UNKNOWN
02C9EA  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02C9ED  52                    PUSH   dx                           ; UNKNOWN
02C9EE  50                    PUSH   ax                           ; UNKNOWN
02C9EF  9A 36 04 13 24        LCALL  0x2413, 0x436                ; UNKNOWN
02C9F4  83 C4 0E              ADD    sp, 0xe                      ; UNKNOWN
02C9F7  68 FD 00              PUSH   0xfd                         ; UNKNOWN
02C9FA  68 FE 00              PUSH   0xfe                         ; UNKNOWN
02C9FD  FF 76 A2              PUSH   word ptr [bp - 0x5e]         ; UNKNOWN
02CA00  6A 44                 PUSH   0x44                         ; UNKNOWN
02CA02  6A 17                 PUSH   0x17                         ; UNKNOWN
02CA04  FF 36 40 34           PUSH   word ptr [0x3440]            ; UNKNOWN
02CA08  9A 6C 00 E6 21        LCALL  0x21e6, 0x6c                 ; UNKNOWN
02CA0D  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02CA10  52                    PUSH   dx                           ; UNKNOWN
02CA11  50                    PUSH   ax                           ; UNKNOWN
02CA12  9A 36 04 13 24        LCALL  0x2413, 0x436                ; UNKNOWN
02CA17  83 C4 0E              ADD    sp, 0xe                      ; UNKNOWN
02CA1A  C6 46 AE 00           MOV    byte ptr [bp - 0x52], 0      ; UNKNOWN
02CA1E  8D 46 AE              LEA    ax, [bp - 0x52]              ; UNKNOWN
02CA21  50                    PUSH   ax                           ; UNKNOWN
02CA22  9A 7D 00 13 24        LCALL  0x2413, 0x7d                 ; UNKNOWN
02CA27  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02CA2A  FF 36 3C 34           PUSH   word ptr [0x343c]            ; UNKNOWN
02CA2E  8D 46 AE              LEA    ax, [bp - 0x52]              ; UNKNOWN
02CA31  50                    PUSH   ax                           ; UNKNOWN
02CA32  9A ED 00 13 24        LCALL  0x2413, 0xed                 ; UNKNOWN
02CA37  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02CA3A  8D 46 AE              LEA    ax, [bp - 0x52]              ; UNKNOWN
02CA3D  50                    PUSH   ax                           ; UNKNOWN
02CA3E  9A 8D 00 13 24        LCALL  0x2413, 0x8d                 ; UNKNOWN
02CA43  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02CA46  68 FE 00              PUSH   0xfe                         ; UNKNOWN
02CA49  6A 51                 PUSH   0x51                         ; UNKNOWN
02CA4B  6A 44                 PUSH   0x44                         ; UNKNOWN
02CA4D  6A 17                 PUSH   0x17                         ; UNKNOWN
02CA4F  8D 46 AE              LEA    ax, [bp - 0x52]              ; UNKNOWN
02CA52  16                    PUSH   ss                           ; UNKNOWN
02CA53  50                    PUSH   ax                           ; UNKNOWN
02CA54  9A 1E 03 13 24        LCALL  0x2413, 0x31e                ; UNKNOWN
02CA59  83 C4 0C              ADD    sp, 0xc                      ; UNKNOWN
02CA5C  6A 00                 PUSH   0                            ; UNKNOWN
02CA5E  68 80 00              PUSH   0x80                         ; UNKNOWN
02CA61  6A 67                 PUSH   0x67                         ; UNKNOWN
02CA63  2B C0                 SUB    ax, ax                       ; UNKNOWN
02CA65  99                    CDQ                                 ; UNKNOWN
02CA66  2B DB                 SUB    bx, bx                       ; UNKNOWN
02CA68  9A 3B 00 B4 5C        LCALL  0x5cb4, 0x3b                 ; UNKNOWN
02CA6D  C7 46 AC 00 00        MOV    word ptr [bp - 0x54], 0      ; UNKNOWN
02CA72  FF 76 AC              PUSH   word ptr [bp - 0x54]         ; UNKNOWN
02CA75  0E                    PUSH   cs                           ; UNKNOWN
02CA76  E8 90 FD              CALL   0x2c809                      ; UNKNOWN
02CA79  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02CA7C  FF 46 AC              INC    word ptr [bp - 0x54]         ; UNKNOWN
02CA7F  83 7E AC 05           CMP    word ptr [bp - 0x54], 5      ; UNKNOWN
02CA83  7C ED                 JL     0x2ca72                      ; UNKNOWN
02CA85  C9                    LEAVE                               ; UNKNOWN
02CA86  CB                    RETF                                ; UNKNOWN
