; ============================================================================
; func_02CE32_unknown
; Region   : load_image
; Bytes    : file 0x02CE32..0x02CF1E  (236 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02CE32  C8 62 00 00           ENTER  0x62, 0                      ; UNKNOWN
02CE36  C4 1E 20 0C           LES    bx, ptr [0xc20]              ; UNKNOWN
02CE3A  26 8A 07              MOV    al, byte ptr es:[bx]         ; UNKNOWN
02CE3D  8B C8                 MOV    cx, ax                       ; UNKNOWN
02CE3F  D0 E8                 SHR    al, 1                        ; UNKNOWN
02CE41  2A E4                 SUB    ah, ah                       ; UNKNOWN
02CE43  83 E8 28              SUB    ax, 0x28                     ; UNKNOWN
02CE46  F7 D8                 NEG    ax                           ; UNKNOWN
02CE48  89 46 A6              MOV    word ptr [bp - 0x5a], ax     ; UNKNOWN
02CE4B  2A ED                 SUB    ch, ch                       ; UNKNOWN
02CE4D  8B D0                 MOV    dx, ax                       ; UNKNOWN
02CE4F  03 C1                 ADD    ax, cx                       ; UNKNOWN
02CE51  83 C0 04              ADD    ax, 4                        ; UNKNOWN
02CE54  89 46 A2              MOV    word ptr [bp - 0x5e], ax     ; UNKNOWN
02CE57  03 C8                 ADD    cx, ax                       ; UNKNOWN
02CE59  83 C1 04              ADD    cx, 4                        ; UNKNOWN
02CE5C  89 4E A0              MOV    word ptr [bp - 0x60], cx     ; UNKNOWN
02CE5F  C6 46 9E FE           MOV    byte ptr [bp - 0x62], 0xfe   ; UNKNOWN
02CE63  68 FD 00              PUSH   0xfd                         ; UNKNOWN
02CE66  68 FE 00              PUSH   0xfe                         ; UNKNOWN
02CE69  52                    PUSH   dx                           ; UNKNOWN
02CE6A  B8 70 00              MOV    ax, 0x70                     ; UNKNOWN
02CE6D  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
02CE70  50                    PUSH   ax                           ; UNKNOWN
02CE71  2B C0                 SUB    ax, ax                       ; UNKNOWN
02CE73  89 46 AA              MOV    word ptr [bp - 0x56], ax     ; UNKNOWN
02CE76  50                    PUSH   ax                           ; UNKNOWN
02CE77  FF 36 4E 34           PUSH   word ptr [0x344e]            ; UNKNOWN
02CE7B  9A 6C 00 E6 21        LCALL  0x21e6, 0x6c                 ; UNKNOWN
02CE80  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02CE83  52                    PUSH   dx                           ; UNKNOWN
02CE84  50                    PUSH   ax                           ; UNKNOWN
02CE85  9A 36 04 13 24        LCALL  0x2413, 0x436                ; UNKNOWN
02CE8A  83 C4 0E              ADD    sp, 0xe                      ; UNKNOWN
02CE8D  68 FD 00              PUSH   0xfd                         ; UNKNOWN
02CE90  68 FE 00              PUSH   0xfe                         ; UNKNOWN
02CE93  FF 76 A2              PUSH   word ptr [bp - 0x5e]         ; UNKNOWN
02CE96  6A 70                 PUSH   0x70                         ; UNKNOWN
02CE98  6A 00                 PUSH   0                            ; UNKNOWN
02CE9A  FF 36 50 34           PUSH   word ptr [0x3450]            ; UNKNOWN
02CE9E  9A 6C 00 E6 21        LCALL  0x21e6, 0x6c                 ; UNKNOWN
02CEA3  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02CEA6  52                    PUSH   dx                           ; UNKNOWN
02CEA7  50                    PUSH   ax                           ; UNKNOWN
02CEA8  9A 36 04 13 24        LCALL  0x2413, 0x436                ; UNKNOWN
02CEAD  83 C4 0E              ADD    sp, 0xe                      ; UNKNOWN
02CEB0  C6 46 AE 00           MOV    byte ptr [bp - 0x52], 0      ; UNKNOWN
02CEB4  8D 46 AE              LEA    ax, [bp - 0x52]              ; UNKNOWN
02CEB7  50                    PUSH   ax                           ; UNKNOWN
02CEB8  9A 7D 00 13 24        LCALL  0x2413, 0x7d                 ; UNKNOWN
02CEBD  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02CEC0  FF 36 3C 34           PUSH   word ptr [0x343c]            ; UNKNOWN
02CEC4  8D 46 AE              LEA    ax, [bp - 0x52]              ; UNKNOWN
02CEC7  50                    PUSH   ax                           ; UNKNOWN
02CEC8  9A ED 00 13 24        LCALL  0x2413, 0xed                 ; UNKNOWN
02CECD  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02CED0  8D 46 AE              LEA    ax, [bp - 0x52]              ; UNKNOWN
02CED3  50                    PUSH   ax                           ; UNKNOWN
02CED4  9A 8D 00 13 24        LCALL  0x2413, 0x8d                 ; UNKNOWN
02CED9  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02CEDC  68 FE 00              PUSH   0xfe                         ; UNKNOWN
02CEDF  68 B6 00              PUSH   0xb6                         ; UNKNOWN
02CEE2  6A 70                 PUSH   0x70                         ; UNKNOWN
02CEE4  6A 00                 PUSH   0                            ; UNKNOWN
02CEE6  8D 46 AE              LEA    ax, [bp - 0x52]              ; UNKNOWN
02CEE9  16                    PUSH   ss                           ; UNKNOWN
02CEEA  50                    PUSH   ax                           ; UNKNOWN
02CEEB  9A 1E 03 13 24        LCALL  0x2413, 0x31e                ; UNKNOWN
02CEF0  83 C4 0C              ADD    sp, 0xc                      ; UNKNOWN
02CEF3  6A 00                 PUSH   0                            ; UNKNOWN
02CEF5  6A 70                 PUSH   0x70                         ; UNKNOWN
02CEF7  68 C8 00              PUSH   0xc8                         ; UNKNOWN
02CEFA  2B C0                 SUB    ax, ax                       ; UNKNOWN
02CEFC  99                    CDQ                                 ; UNKNOWN
02CEFD  2B DB                 SUB    bx, bx                       ; UNKNOWN
02CEFF  9A 3B 00 B4 5C        LCALL  0x5cb4, 0x3b                 ; UNKNOWN
02CF04  C7 46 AC 00 00        MOV    word ptr [bp - 0x54], 0      ; UNKNOWN
02CF09  FF 76 AC              PUSH   word ptr [bp - 0x54]         ; UNKNOWN
02CF0C  0E                    PUSH   cs                           ; UNKNOWN
02CF0D  E8 AA FD              CALL   0x2ccba                      ; UNKNOWN
02CF10  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02CF13  FF 46 AC              INC    word ptr [bp - 0x54]         ; UNKNOWN
02CF16  83 7E AC 04           CMP    word ptr [bp - 0x54], 4      ; UNKNOWN
02CF1A  7C ED                 JL     0x2cf09                      ; UNKNOWN
02CF1C  C9                    LEAVE                               ; UNKNOWN
02CF1D  CB                    RETF                                ; UNKNOWN
