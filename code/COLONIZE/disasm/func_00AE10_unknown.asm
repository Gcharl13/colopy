; ============================================================================
; func_00AE10_unknown
; Region   : load_image
; Bytes    : file 0x00AE10..0x00B003  (499 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00AE10  C8 12 00 00           ENTER  0x12, 0                      ; UNKNOWN
00AE14  9A 69 00 05 5C        LCALL  0x5c05, 0x69                 ; UNKNOWN
00AE19  9A 5E 01 27 5E        LCALL  0x5e27, 0x15e                ; UNKNOWN
00AE1E  68 27 5E              PUSH   0x5e27                       ; UNKNOWN
00AE21  68 D4 01              PUSH   0x1d4                        ; UNKNOWN
00AE24  9A 2C 0E 65 5F        LCALL  0x5f65, 0xe2c                ; UNKNOWN
00AE29  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00AE2C  9A 0A 00 AA 0D        LCALL  0xdaa, 0xa                   ; UNKNOWN
00AE31  A3 86 3E              MOV    word ptr [0x3e86], ax        ; UNKNOWN
00AE34  9A 54 00 AA 0D        LCALL  0xdaa, 0x54                  ; UNKNOWN
00AE39  9A 0A 00 AA 0D        LCALL  0xdaa, 0xa                   ; UNKNOWN
00AE3E  A3 8E 3E              MOV    word ptr [0x3e8e], ax        ; UNKNOWN
00AE41  9A 54 00 AA 0D        LCALL  0xdaa, 0x54                  ; UNKNOWN
00AE46  9A 0A 00 AA 0D        LCALL  0xdaa, 0xa                   ; UNKNOWN
00AE4B  A3 88 3E              MOV    word ptr [0x3e88], ax        ; UNKNOWN
00AE4E  9A 54 00 AA 0D        LCALL  0xdaa, 0x54                  ; UNKNOWN
00AE53  FF 36 86 3E           PUSH   word ptr [0x3e86]            ; UNKNOWN
00AE57  9A 98 00 AA 0D        LCALL  0xdaa, 0x98                  ; UNKNOWN
00AE5C  83 C4 02              ADD    sp, 2                        ; UNKNOWN
00AE5F  9A 10 00 23 5E        LCALL  0x5e23, 0x10                 ; UNKNOWN
00AE64  A3 8A 3E              MOV    word ptr [0x3e8a], ax        ; UNKNOWN
00AE67  89 16 8C 3E           MOV    word ptr [0x3e8c], dx        ; UNKNOWN
00AE6B  B8 13 00              MOV    ax, 0x13                     ; UNKNOWN
00AE6E  9A 00 00 D9 5C        LCALL  0x5cd9, 0                    ; UNKNOWN
00AE73  80 3E A2 09 01        CMP    byte ptr [0x9a2], 1          ; UNKNOWN
00AE78  1B C0                 SBB    ax, ax                       ; UNKNOWN
00AE7A  F7 D8                 NEG    ax                           ; UNKNOWN
00AE7C  50                    PUSH   ax                           ; UNKNOWN
00AE7D  6A 13                 PUSH   0x13                         ; UNKNOWN
00AE7F  9A 0C 00 4C 5E        LCALL  0x5e4c, 0xc                  ; UNKNOWN
00AE84  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00AE87  6A 13                 PUSH   0x13                         ; UNKNOWN
00AE89  6A 01                 PUSH   1                            ; UNKNOWN
00AE8B  9A 82 00 1E 5C        LCALL  0x5c1e, 0x82                 ; UNKNOWN
00AE90  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00AE93  68 B2 00              PUSH   0xb2                         ; UNKNOWN
00AE96  68 D0 17              PUSH   0x17d0                       ; UNKNOWN
00AE99  9A 2C 0E 65 5F        LCALL  0x5f65, 0xe2c                ; UNKNOWN
00AE9E  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00AEA1  83 3E 9A 09 00        CMP    word ptr [0x99a], 0          ; UNKNOWN
00AEA6  74 21                 JE     0xaec9                       ; UNKNOWN
00AEA8  8D 5E FC              LEA    bx, [bp - 4]                 ; UNKNOWN
00AEAB  9A CE 00 64 00        LCALL  0x64, 0xce                   ; UNKNOWN
00AEB0  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; UNKNOWN
00AEB3  89 56 F8              MOV    word ptr [bp - 8], dx        ; UNKNOWN
00AEB6  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
00AEB9  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
00AEBC  52                    PUSH   dx                           ; UNKNOWN
00AEBD  50                    PUSH   ax                           ; UNKNOWN
00AEBE  68 9A 03              PUSH   0x39a                        ; UNKNOWN
00AEC1  9A 50 00 00 00        LCALL  0, 0x50                      ; UNKNOWN
00AEC6  83 C4 0A              ADD    sp, 0xa                      ; UNKNOWN
00AEC9  68 00 A0              PUSH   0xa000                       ; UNKNOWN
00AECC  68 00 FC              PUSH   0xfc00                       ; UNKNOWN
00AECF  8D 1E BD 03           LEA    bx, [0x3bd]                  ; UNKNOWN
00AED3  9A 0C 00 D2 5C        LCALL  0x5cd2, 0xc                  ; UNKNOWN
00AED8  0B C0                 OR     ax, ax                       ; UNKNOWN
00AEDA  74 0A                 JE     0xaee6                       ; UNKNOWN
00AEDC  C7 06 9C 09 13 00     MOV    word ptr [0x99c], 0x13       ; UNKNOWN
00AEE2  E9 04 04              JMP    0xb2e9                       ; UNKNOWN
00AEE5  90                    NOP                                 ; UNKNOWN
00AEE6  8D 1E D2 3E           LEA    bx, [0x3ed2]                 ; UNKNOWN
00AEEA  B8 20 00              MOV    ax, 0x20                     ; UNKNOWN
00AEED  8B D0                 MOV    dx, ax                       ; UNKNOWN
00AEEF  9A 06 00 3F 5A        LCALL  0x5a3f, 6                    ; UNKNOWN
00AEF4  A1 D8 3E              MOV    ax, word ptr [0x3ed8]        ; UNKNOWN
00AEF7  0B 06 D6 3E           OR     ax, word ptr [0x3ed6]        ; UNKNOWN
00AEFB  75 09                 JNE    0xaf06                       ; UNKNOWN
00AEFD  C7 06 9C 09 14 00     MOV    word ptr [0x99c], 0x14       ; UNKNOWN
00AF03  E9 E3 03              JMP    0xb2e9                       ; UNKNOWN
00AF06  83 3E 4C 05 00        CMP    word ptr [0x54c], 0          ; UNKNOWN
00AF0B  74 43                 JE     0xaf50                       ; UNKNOWN
00AF0D  6A 01                 PUSH   1                            ; UNKNOWN
00AF0F  6A 00                 PUSH   0                            ; UNKNOWN
00AF11  9A 2E 01 62 05        LCALL  0x562, 0x12e                 ; UNKNOWN
00AF16  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00AF19  89 46 EE              MOV    word ptr [bp - 0x12], ax     ; UNKNOWN
00AF1C  40                    INC    ax                           ; UNKNOWN
00AF1D  75 03                 JNE    0xaf22                       ; UNKNOWN
00AF1F  E9 C7 03              JMP    0xb2e9                       ; UNKNOWN
00AF22  6A 04                 PUSH   4                            ; UNKNOWN
00AF24  6A 00                 PUSH   0                            ; UNKNOWN
00AF26  6A 00                 PUSH   0                            ; UNKNOWN
00AF28  FF 76 EE              PUSH   word ptr [bp - 0x12]         ; UNKNOWN
00AF2B  9A 86 02 62 05        LCALL  0x562, 0x286                 ; UNKNOWN
00AF30  83 C4 08              ADD    sp, 8                        ; UNKNOWN
00AF33  C7 06 82 CE C8 00     MOV    word ptr [0xce82], 0xc8      ; UNKNOWN
00AF39  C7 06 84 CE 40 01     MOV    word ptr [0xce84], 0x140     ; UNKNOWN
00AF3F  A1 9E 05              MOV    ax, word ptr [0x59e]         ; UNKNOWN
00AF42  8B 16 A0 05           MOV    dx, word ptr [0x5a0]         ; UNKNOWN
00AF46  A3 86 CE              MOV    word ptr [0xce86], ax        ; UNKNOWN
00AF49  89 16 88 CE           MOV    word ptr [0xce88], dx        ; UNKNOWN
00AF4D  EB 10                 JMP    0xaf5f                       ; UNKNOWN
00AF4F  90                    NOP                                 ; UNKNOWN
00AF50  8D 1E 82 CE           LEA    bx, [0xce82]                 ; UNKNOWN
00AF54  B8 40 01              MOV    ax, 0x140                    ; UNKNOWN
00AF57  BA C8 00              MOV    dx, 0xc8                     ; UNKNOWN
00AF5A  9A 06 00 3F 5A        LCALL  0x5a3f, 6                    ; UNKNOWN
00AF5F  A1 88 CE              MOV    ax, word ptr [0xce88]        ; UNKNOWN
00AF62  0B 06 86 CE           OR     ax, word ptr [0xce86]        ; UNKNOWN
00AF66  74 95                 JE     0xaefd                       ; UNKNOWN
00AF68  83 3E 4C 05 00        CMP    word ptr [0x54c], 0          ; UNKNOWN
00AF6D  74 49                 JE     0xafb8                       ; UNKNOWN
00AF6F  83 3E 52 05 08        CMP    word ptr [0x552], 8          ; UNKNOWN
00AF74  75 42                 JNE    0xafb8                       ; UNKNOWN
00AF76  6A 01                 PUSH   1                            ; UNKNOWN
00AF78  6A 00                 PUSH   0                            ; UNKNOWN
00AF7A  9A 2E 01 62 05        LCALL  0x562, 0x12e                 ; UNKNOWN
00AF7F  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00AF82  89 46 F0              MOV    word ptr [bp - 0x10], ax     ; UNKNOWN
00AF85  40                    INC    ax                           ; UNKNOWN
00AF86  75 03                 JNE    0xaf8b                       ; UNKNOWN
00AF88  E9 5E 03              JMP    0xb2e9                       ; UNKNOWN
00AF8B  6A 04                 PUSH   4                            ; UNKNOWN
00AF8D  6A 04                 PUSH   4                            ; UNKNOWN
00AF8F  6A 04                 PUSH   4                            ; UNKNOWN
00AF91  FF 76 F0              PUSH   word ptr [bp - 0x10]         ; UNKNOWN
00AF94  9A 86 02 62 05        LCALL  0x562, 0x286                 ; UNKNOWN
00AF99  83 C4 08              ADD    sp, 8                        ; UNKNOWN
00AF9C  C7 06 8A CE C8 00     MOV    word ptr [0xce8a], 0xc8      ; UNKNOWN
00AFA2  C7 06 8C CE 40 01     MOV    word ptr [0xce8c], 0x140     ; UNKNOWN
00AFA8  A1 AE 05              MOV    ax, word ptr [0x5ae]         ; UNKNOWN
00AFAB  8B 16 B0 05           MOV    dx, word ptr [0x5b0]         ; UNKNOWN
00AFAF  A3 8E CE              MOV    word ptr [0xce8e], ax        ; UNKNOWN
00AFB2  89 16 90 CE           MOV    word ptr [0xce90], dx        ; UNKNOWN
00AFB6  EB 0F                 JMP    0xafc7                       ; UNKNOWN
00AFB8  8D 1E 8A CE           LEA    bx, [0xce8a]                 ; UNKNOWN
00AFBC  B8 40 01              MOV    ax, 0x140                    ; UNKNOWN
00AFBF  BA C8 00              MOV    dx, 0xc8                     ; UNKNOWN
00AFC2  9A 06 00 3F 5A        LCALL  0x5a3f, 6                    ; UNKNOWN
00AFC7  A1 90 CE              MOV    ax, word ptr [0xce90]        ; UNKNOWN
00AFCA  0B 06 8E CE           OR     ax, word ptr [0xce8e]        ; UNKNOWN
00AFCE  75 03                 JNE    0xafd3                       ; UNKNOWN
00AFD0  E9 2A FF              JMP    0xaefd                       ; UNKNOWN
00AFD3  9A 04 00 B4 5C        LCALL  0x5cb4, 4                    ; UNKNOWN
00AFD8  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
00AFDC  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
00AFE0  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
00AFE4  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
00AFE8  2A C0                 SUB    al, al                       ; UNKNOWN
00AFEA  9A 02 00 47 5A        LCALL  0x5a47, 2                    ; UNKNOWN
00AFEF  8D 1E C9 03           LEA    bx, [0x3c9]                  ; UNKNOWN
00AFF3  9A 0A 00 4D 5B        LCALL  0x5b4d, 0xa                  ; UNKNOWN
00AFF8  A3 20 0C              MOV    word ptr [0xc20], ax         ; UNKNOWN
00AFFB  89 16 22 0C           MOV    word ptr [0xc22], dx         ; UNKNOWN
00AFFF  8B C2                 MOV    ax, dx                       ; UNKNOWN
00B001  0B                    DB     0x0B                         ; UNKNOWN (raw)
00B002  06                    DB     0x06                         ; UNKNOWN (raw)
