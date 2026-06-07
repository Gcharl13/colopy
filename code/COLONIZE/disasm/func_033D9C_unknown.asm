; ============================================================================
; func_033D9C_unknown
; Region   : load_image
; Bytes    : file 0x033D9C..0x033E6F  (211 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

033D9C  C8 68 00 00           ENTER  0x68, 0                      ; UNKNOWN
033DA0  56                    PUSH   si                           ; UNKNOWN
033DA1  6A 3C                 PUSH   0x3c                         ; UNKNOWN
033DA3  6A 51                 PUSH   0x51                         ; UNKNOWN
033DA5  6A 76                 PUSH   0x76                         ; UNKNOWN
033DA7  68 8F 00              PUSH   0x8f                         ; UNKNOWN
033DAA  0E                    PUSH   cs                           ; UNKNOWN
033DAB  E8 A2 F8              CALL   0x33650                      ; UNKNOWN
033DAE  83 C4 08              ADD    sp, 8                        ; UNKNOWN
033DB1  83 3E EF 0A 00        CMP    word ptr [0xaef], 0          ; UNKNOWN
033DB6  75 68                 JNE    0x33e20                      ; UNKNOWN
033DB8  6A 45                 PUSH   0x45                         ; UNKNOWN
033DBA  6A 78                 PUSH   0x78                         ; UNKNOWN
033DBC  6A 51                 PUSH   0x51                         ; UNKNOWN
033DBE  68 8F 00              PUSH   0x8f                         ; UNKNOWN
033DC1  FF 36 10 33           PUSH   word ptr [0x3310]            ; UNKNOWN
033DC5  9A 6C 00 E6 21        LCALL  0x21e6, 0x6c                 ; UNKNOWN
033DCA  83 C4 02              ADD    sp, 2                        ; UNKNOWN
033DCD  52                    PUSH   dx                           ; UNKNOWN
033DCE  50                    PUSH   ax                           ; UNKNOWN
033DCF  9A 1E 03 13 24        LCALL  0x2413, 0x31e                ; UNKNOWN
033DD4  83 C4 0C              ADD    sp, 0xc                      ; UNKNOWN
033DD7  C7 46 A4 00 00        MOV    word ptr [bp - 0x5c], 0      ; UNKNOWN
033DDC  EB 03                 JMP    0x33de1                      ; UNKNOWN
033DDE  FF 46 A4              INC    word ptr [bp - 0x5c]         ; UNKNOWN
033DE1  83 7E A4 06           CMP    word ptr [bp - 0x5c], 6      ; UNKNOWN
033DE5  7C 03                 JL     0x33dea                      ; UNKNOWN
033DE7  E9 83 02              JMP    0x3406d                      ; UNKNOWN
033DEA  8D 46 9E              LEA    ax, [bp - 0x62]              ; UNKNOWN
033DED  50                    PUSH   ax                           ; UNKNOWN
033DEE  8D 46 A0              LEA    ax, [bp - 0x60]              ; UNKNOWN
033DF1  50                    PUSH   ax                           ; UNKNOWN
033DF2  8D 46 A8              LEA    ax, [bp - 0x58]              ; UNKNOWN
033DF5  50                    PUSH   ax                           ; UNKNOWN
033DF6  8D 4E AA              LEA    cx, [bp - 0x56]              ; UNKNOWN
033DF9  51                    PUSH   cx                           ; UNKNOWN
033DFA  FF 76 A4              PUSH   word ptr [bp - 0x5c]         ; UNKNOWN
033DFD  0E                    PUSH   cs                           ; UNKNOWN
033DFE  E8 6D FF              CALL   0x33d6e                      ; UNKNOWN
033E01  83 C4 0A              ADD    sp, 0xa                      ; UNKNOWN
033E04  FF 36 72 09           PUSH   word ptr [0x972]             ; UNKNOWN
033E08  FF 36 70 09           PUSH   word ptr [0x970]             ; UNKNOWN
033E0C  FF 76 A8              PUSH   word ptr [bp - 0x58]         ; UNKNOWN
033E0F  B8 7B 00              MOV    ax, 0x7b                     ; UNKNOWN
033E12  8D 1E 82 CE           LEA    bx, [0xce82]                 ; UNKNOWN
033E16  8B 56 AA              MOV    dx, word ptr [bp - 0x56]     ; UNKNOWN
033E19  9A 0E 00 15 5D        LCALL  0x5d15, 0xe                  ; UNKNOWN
033E1E  EB BE                 JMP    0x33dde                      ; UNKNOWN
033E20  FF 36 9C 79           PUSH   word ptr [0x799c]            ; UNKNOWN
033E24  0E                    PUSH   cs                           ; UNKNOWN
033E25  E8 5B F6              CALL   0x33483                      ; UNKNOWN
033E28  83 C4 02              ADD    sp, 2                        ; UNKNOWN
033E2B  89 46 9A              MOV    word ptr [bp - 0x66], ax     ; UNKNOWN
033E2E  C6 46 AE 00           MOV    byte ptr [bp - 0x52], 0      ; UNKNOWN
033E32  FF 36 28 33           PUSH   word ptr [0x3328]            ; UNKNOWN
033E36  8D 46 AE              LEA    ax, [bp - 0x52]              ; UNKNOWN
033E39  50                    PUSH   ax                           ; UNKNOWN
033E3A  9A ED 00 13 24        LCALL  0x2413, 0xed                 ; UNKNOWN
033E3F  83 C4 04              ADD    sp, 4                        ; UNKNOWN
033E42  8D 46 AE              LEA    ax, [bp - 0x52]              ; UNKNOWN
033E45  50                    PUSH   ax                           ; UNKNOWN
033E46  9A 4D 00 13 24        LCALL  0x2413, 0x4d                 ; UNKNOWN
033E4B  83 C4 02              ADD    sp, 2                        ; UNKNOWN
033E4E  6B 5E 9A 1C           IMUL   bx, word ptr [bp - 0x66], 0x1c ; UNKNOWN
033E52  80 BF 82 88 0E        CMP    byte ptr [bx - 0x777e], 0xe  ; UNKNOWN
033E57  74 30                 JE     0x33e89                      ; UNKNOWN
033E59  8D 46 AE              LEA    ax, [bp - 0x52]              ; UNKNOWN
033E5C  50                    PUSH   ax                           ; UNKNOWN
033E5D  8B F3                 MOV    si, bx                       ; UNKNOWN
033E5F  9A 0C 00 13 24        LCALL  0x2413, 0xc                  ; UNKNOWN
033E64  83 C4 02              ADD    sp, 2                        ; UNKNOWN
033E67  8A 9C 82 88           MOV    bl, byte ptr [si - 0x777e]   ; UNKNOWN
033E6B  2A FF                 SUB    bh, bh                       ; UNKNOWN
033E6D  8B C3                 MOV    ax, bx                       ; UNKNOWN
