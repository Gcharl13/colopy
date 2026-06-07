; ============================================================================
; func_064ACE_unknown
; Region   : load_image
; Bytes    : file 0x064ACE..0x064BC5  (247 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

064ACE  C8 0E 00 00           ENTER  0xe, 0                       ; UNKNOWN
064AD2  50                    PUSH   ax                           ; UNKNOWN
064AD3  53                    PUSH   bx                           ; UNKNOWN
064AD4  57                    PUSH   di                           ; UNKNOWN
064AD5  56                    PUSH   si                           ; UNKNOWN
064AD6  8B 76 06              MOV    si, word ptr [bp + 6]        ; UNKNOWN
064AD9  8B 7E 0A              MOV    di, word ptr [bp + 0xa]      ; UNKNOWN
064ADC  C7 46 FA 01 00        MOV    word ptr [bp - 6], 1         ; UNKNOWN
064AE1  C7 46 FC FF FF        MOV    word ptr [bp - 4], 0xffff    ; UNKNOWN
064AE6  6A 0D                 PUSH   0xd                          ; UNKNOWN
064AE8  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
064AEB  56                    PUSH   si                           ; UNKNOWN
064AEC  1E                    PUSH   ds                           ; UNKNOWN
064AED  68 5E 0C              PUSH   0xc5e                        ; UNKNOWN
064AF0  9A CC 13 65 5F        LCALL  0x5f65, 0x13cc               ; UNKNOWN
064AF5  83 C4 0A              ADD    sp, 0xa                      ; UNKNOWN
064AF8  8E 46 0C              MOV    es, word ptr [bp + 0xc]      ; UNKNOWN
064AFB  26 C7 05 00 00        MOV    word ptr es:[di], 0          ; UNKNOWN
064B00  6A 72                 PUSH   0x72                         ; UNKNOWN
064B02  FF 76 EE              PUSH   word ptr [bp - 0x12]         ; UNKNOWN
064B05  9A 80 0D 65 5F        LCALL  0x5f65, 0xd80                ; UNKNOWN
064B0A  83 C4 02              ADD    sp, 2                        ; UNKNOWN
064B0D  50                    PUSH   ax                           ; UNKNOWN
064B0E  9A 90 0C 65 5F        LCALL  0x5f65, 0xc90                ; UNKNOWN
064B13  83 C4 04              ADD    sp, 4                        ; UNKNOWN
064B16  83 F8 01              CMP    ax, 1                        ; UNKNOWN
064B19  1B C0                 SBB    ax, ax                       ; UNKNOWN
064B1B  40                    INC    ax                           ; UNKNOWN
064B1C  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
064B1F  8E 46 0C              MOV    es, word ptr [bp + 0xc]      ; UNKNOWN
064B22  26 C6 45 04 00        MOV    byte ptr es:[di + 4], 0      ; UNKNOWN
064B27  26 C7 45 08 FF FF     MOV    word ptr es:[di + 8], 0xffff ; UNKNOWN
064B2D  8B 46 08              MOV    ax, word ptr [bp + 8]        ; UNKNOWN
064B30  50                    PUSH   ax                           ; UNKNOWN
064B31  56                    PUSH   si                           ; UNKNOWN
064B32  8B 5E EE              MOV    bx, word ptr [bp - 0x12]     ; UNKNOWN
064B35  8C C6                 MOV    si, es                       ; UNKNOWN
064B37  9A FC 00 E9 5A        LCALL  0x5ae9, 0xfc                 ; UNKNOWN
064B3C  8E C6                 MOV    es, si                       ; UNKNOWN
064B3E  26 89 45 06           MOV    word ptr es:[di + 6], ax     ; UNKNOWN
064B42  0B C0                 OR     ax, ax                       ; UNKNOWN
064B44  75 03                 JNE    0x64b49                      ; UNKNOWN
064B46  E9 69 01              JMP    0x64cb2                      ; UNKNOWN
064B49  8E 46 0C              MOV    es, word ptr [bp + 0xc]      ; UNKNOWN
064B4C  26 C7 45 18 00 00     MOV    word ptr es:[di + 0x18], 0   ; UNKNOWN
064B52  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
064B55  26 89 45 02           MOV    word ptr es:[di + 2], ax     ; UNKNOWN
064B59  0B C0                 OR     ax, ax                       ; UNKNOWN
064B5B  75 03                 JNE    0x64b60                      ; UNKNOWN
064B5D  E9 E6 00              JMP    0x64c46                      ; UNKNOWN
064B60  8D 46 F6              LEA    ax, [bp - 0xa]               ; UNKNOWN
064B63  50                    PUSH   ax                           ; UNKNOWN
064B64  8E 46 0C              MOV    es, word ptr [bp + 0xc]      ; UNKNOWN
064B67  26 FF 75 06           PUSH   word ptr es:[di + 6]         ; UNKNOWN
064B6B  8C C6                 MOV    si, es                       ; UNKNOWN
064B6D  9A D2 08 65 5F        LCALL  0x5f65, 0x8d2                ; UNKNOWN
064B72  83 C4 04              ADD    sp, 4                        ; UNKNOWN
064B75  8D 45 1A              LEA    ax, [di + 0x1a]              ; UNKNOWN
064B78  56                    PUSH   si                           ; UNKNOWN
064B79  50                    PUSH   ax                           ; UNKNOWN
064B7A  6A 00                 PUSH   0                            ; UNKNOWN
064B7C  6A 01                 PUSH   1                            ; UNKNOWN
064B7E  8E C6                 MOV    es, si                       ; UNKNOWN
064B80  26 8B 5D 06           MOV    bx, word ptr es:[di + 6]     ; UNKNOWN
064B84  B8 10 00              MOV    ax, 0x10                     ; UNKNOWN
064B87  99                    CDQ                                 ; UNKNOWN
064B88  9A 04 00 03 5B        LCALL  0x5b03, 4                    ; UNKNOWN
064B8D  0B D0                 OR     dx, ax                       ; UNKNOWN
064B8F  75 03                 JNE    0x64b94                      ; UNKNOWN
064B91  E9 1E 01              JMP    0x64cb2                      ; UNKNOWN
064B94  6A 0C                 PUSH   0xc                          ; UNKNOWN
064B96  1E                    PUSH   ds                           ; UNKNOWN
064B97  68 A4 30              PUSH   0x30a4                       ; UNKNOWN
064B9A  8B C7                 MOV    ax, di                       ; UNKNOWN
064B9C  8B 56 0C              MOV    dx, word ptr [bp + 0xc]      ; UNKNOWN
064B9F  83 C0 1A              ADD    ax, 0x1a                     ; UNKNOWN
064BA2  52                    PUSH   dx                           ; UNKNOWN
064BA3  50                    PUSH   ax                           ; UNKNOWN
064BA4  9A 90 13 65 5F        LCALL  0x5f65, 0x1390               ; UNKNOWN
064BA9  83 C4 0A              ADD    sp, 0xa                      ; UNKNOWN
064BAC  0B C0                 OR     ax, ax                       ; UNKNOWN
064BAE  74 03                 JE     0x64bb3                      ; UNKNOWN
064BB0  E9 FF 00              JMP    0x64cb2                      ; UNKNOWN
064BB3  8B C7                 MOV    ax, di                       ; UNKNOWN
064BB5  8B 56 0C              MOV    dx, word ptr [bp + 0xc]      ; UNKNOWN
064BB8  83 C0 2A              ADD    ax, 0x2a                     ; UNKNOWN
064BBB  52                    PUSH   dx                           ; UNKNOWN
064BBC  50                    PUSH   ax                           ; UNKNOWN
064BBD  6A 00                 PUSH   0                            ; UNKNOWN
064BBF  6A 01                 PUSH   1                            ; UNKNOWN
064BC1  8E C2                 MOV    es, dx                       ; UNKNOWN
064BC3  8B F7                 MOV    si, di                       ; UNKNOWN
