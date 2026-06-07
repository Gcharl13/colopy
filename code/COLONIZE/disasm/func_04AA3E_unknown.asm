; ============================================================================
; func_04AA3E_unknown
; Region   : load_image
; Bytes    : file 0x04AA3E..0x04AB4C  (270 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04AA3E  C8 58 00 00           ENTER  0x58, 0                      ; UNKNOWN
04AA42  56                    PUSH   si                           ; UNKNOWN
04AA43  0E                    PUSH   cs                           ; UNKNOWN
04AA44  E8 F6 E3              CALL   0x48e3d                      ; UNKNOWN
04AA47  A0 63 09              MOV    al, byte ptr [0x963]         ; UNKNOWN
04AA4A  2A E4                 SUB    ah, ah                       ; UNKNOWN
04AA4C  50                    PUSH   ax                           ; UNKNOWN
04AA4D  6A 05                 PUSH   5                            ; UNKNOWN
04AA4F  68 40 01              PUSH   0x140                        ; UNKNOWN
04AA52  6A 00                 PUSH   0                            ; UNKNOWN
04AA54  FF 36 D2 33           PUSH   word ptr [0x33d2]            ; UNKNOWN
04AA58  9A 6C 00 E6 21        LCALL  0x21e6, 0x6c                 ; UNKNOWN
04AA5D  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04AA60  52                    PUSH   dx                           ; UNKNOWN
04AA61  50                    PUSH   ax                           ; UNKNOWN
04AA62  9A 1E 03 13 24        LCALL  0x2413, 0x31e                ; UNKNOWN
04AA67  83 C4 0C              ADD    sp, 0xc                      ; UNKNOWN
04AA6A  C4 1E B4 09           LES    bx, ptr [0x9b4]              ; UNKNOWN
04AA6E  26 8A 07              MOV    al, byte ptr es:[bx]         ; UNKNOWN
04AA71  2A E4                 SUB    ah, ah                       ; UNKNOWN
04AA73  83 C0 07              ADD    ax, 7                        ; UNKNOWN
04AA76  89 46 AA              MOV    word ptr [bp - 0x56], ax     ; UNKNOWN
04AA79  C6 46 B0 00           MOV    byte ptr [bp - 0x50], 0      ; UNKNOWN
04AA7D  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
04AA80  50                    PUSH   ax                           ; UNKNOWN
04AA81  9A 7D 00 13 24        LCALL  0x2413, 0x7d                 ; UNKNOWN
04AA86  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04AA89  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
04AA8C  D1 E3                 SHL    bx, 1                        ; UNKNOWN
04AA8E  FF B7 57 3B           PUSH   word ptr [bx + 0x3b57]       ; UNKNOWN
04AA92  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
04AA95  50                    PUSH   ax                           ; UNKNOWN
04AA96  8B F3                 MOV    si, bx                       ; UNKNOWN
04AA98  9A ED 00 13 24        LCALL  0x2413, 0xed                 ; UNKNOWN
04AA9D  83 C4 04              ADD    sp, 4                        ; UNKNOWN
04AAA0  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
04AAA3  50                    PUSH   ax                           ; UNKNOWN
04AAA4  9A 4D 00 13 24        LCALL  0x2413, 0x4d                 ; UNKNOWN
04AAA9  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04AAAC  6A 06                 PUSH   6                            ; UNKNOWN
04AAAE  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
04AAB1  50                    PUSH   ax                           ; UNKNOWN
04AAB2  0E                    PUSH   cs                           ; UNKNOWN
04AAB3  E8 00 E3              CALL   0x48db6                      ; UNKNOWN
04AAB6  83 C4 04              ADD    sp, 4                        ; UNKNOWN
04AAB9  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
04AABC  50                    PUSH   ax                           ; UNKNOWN
04AABD  9A 8D 00 13 24        LCALL  0x2413, 0x8d                 ; UNKNOWN
04AAC2  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04AAC5  A0 63 09              MOV    al, byte ptr [0x963]         ; UNKNOWN
04AAC8  2A E4                 SUB    ah, ah                       ; UNKNOWN
04AACA  50                    PUSH   ax                           ; UNKNOWN
04AACB  FF 76 AA              PUSH   word ptr [bp - 0x56]         ; UNKNOWN
04AACE  68 40 01              PUSH   0x140                        ; UNKNOWN
04AAD1  6A 00                 PUSH   0                            ; UNKNOWN
04AAD3  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
04AAD6  16                    PUSH   ss                           ; UNKNOWN
04AAD7  50                    PUSH   ax                           ; UNKNOWN
04AAD8  9A 1E 03 13 24        LCALL  0x2413, 0x31e                ; UNKNOWN
04AADD  83 C4 0C              ADD    sp, 0xc                      ; UNKNOWN
04AAE0  C4 1E B4 09           LES    bx, ptr [0x9b4]              ; UNKNOWN
04AAE4  26 8A 07              MOV    al, byte ptr es:[bx]         ; UNKNOWN
04AAE7  2A E4                 SUB    ah, ah                       ; UNKNOWN
04AAE9  83 C0 0E              ADD    ax, 0xe                      ; UNKNOWN
04AAEC  01 46 AA              ADD    word ptr [bp - 0x56], ax     ; UNKNOWN
04AAEF  C7 46 AC 0A 00        MOV    word ptr [bp - 0x54], 0xa    ; UNKNOWN
04AAF4  68 8A 29              PUSH   0x298a                       ; UNKNOWN
04AAF7  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
04AAFA  50                    PUSH   ax                           ; UNKNOWN
04AAFB  9A 74 07 65 5F        LCALL  0x5f65, 0x774                ; UNKNOWN
04AB00  83 C4 04              ADD    sp, 4                        ; UNKNOWN
04AB03  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
04AB06  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
04AB09  16                    PUSH   ss                           ; UNKNOWN
04AB0A  50                    PUSH   ax                           ; UNKNOWN
04AB0B  9A 38 01 13 24        LCALL  0x2413, 0x138                ; UNKNOWN
04AB10  83 C4 06              ADD    sp, 6                        ; UNKNOWN
04AB13  8B 46 AA              MOV    ax, word ptr [bp - 0x56]     ; UNKNOWN
04AB16  A3 02 0A              MOV    word ptr [0xa02], ax         ; UNKNOWN
04AB19  FF B4 57 3B           PUSH   word ptr [si + 0x3b57]       ; UNKNOWN
04AB1D  6A 00                 PUSH   0                            ; UNKNOWN
04AB1F  9A E4 03 97 1B        LCALL  0x1b97, 0x3e4                ; UNKNOWN
04AB24  83 C4 04              ADD    sp, 4                        ; UNKNOWN
04AB27  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
04AB2A  50                    PUSH   ax                           ; UNKNOWN
04AB2B  0E                    PUSH   cs                           ; UNKNOWN
04AB2C  E8 A7 E2              CALL   0x48dd6                      ; UNKNOWN
04AB2F  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04AB32  6A 00                 PUSH   0                            ; UNKNOWN
04AB34  68 40 01              PUSH   0x140                        ; UNKNOWN
04AB37  68 C8 00              PUSH   0xc8                         ; UNKNOWN
04AB3A  2B C0                 SUB    ax, ax                       ; UNKNOWN
04AB3C  99                    CDQ                                 ; UNKNOWN
04AB3D  2B DB                 SUB    bx, bx                       ; UNKNOWN
04AB3F  9A 3B 00 B4 5C        LCALL  0x5cb4, 0x3b                 ; UNKNOWN
04AB44  9A 6B 00 EF 21        LCALL  0x21ef, 0x6b                 ; UNKNOWN
04AB49  5E                    POP    si                           ; UNKNOWN
04AB4A  C9                    LEAVE                               ; UNKNOWN
04AB4B  CB                    RETF                                ; UNKNOWN
