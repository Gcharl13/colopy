; ============================================================================
; func_00E032_unknown
; Region   : load_image
; Bytes    : file 0x00E032..0x00E151  (287 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00E032  C8 0C 00 00           ENTER  0xc, 0                       ; UNKNOWN
00E036  C7 46 F8 13 00        MOV    word ptr [bp - 8], 0x13      ; UNKNOWN
00E03B  9A 69 00 05 5C        LCALL  0x5c05, 0x69                 ; UNKNOWN
00E040  9A 5E 01 27 5E        LCALL  0x5e27, 0x15e                ; UNKNOWN
00E045  9A 0A 00 AA 0D        LCALL  0xdaa, 0xa                   ; UNKNOWN
00E04A  A3 86 3E              MOV    word ptr [0x3e86], ax        ; UNKNOWN
00E04D  9A 54 00 AA 0D        LCALL  0xdaa, 0x54                  ; UNKNOWN
00E052  9A 0A 00 AA 0D        LCALL  0xdaa, 0xa                   ; UNKNOWN
00E057  A3 8E 3E              MOV    word ptr [0x3e8e], ax        ; UNKNOWN
00E05A  9A 54 00 AA 0D        LCALL  0xdaa, 0x54                  ; UNKNOWN
00E05F  9A 0A 00 AA 0D        LCALL  0xdaa, 0xa                   ; UNKNOWN
00E064  A3 88 3E              MOV    word ptr [0x3e88], ax        ; UNKNOWN
00E067  9A 54 00 AA 0D        LCALL  0xdaa, 0x54                  ; UNKNOWN
00E06C  9A 10 00 23 5E        LCALL  0x5e23, 0x10                 ; UNKNOWN
00E071  A3 8A 3E              MOV    word ptr [0x3e8a], ax        ; UNKNOWN
00E074  89 16 8C 3E           MOV    word ptr [0x3e8c], dx        ; UNKNOWN
00E078  8B 46 F8              MOV    ax, word ptr [bp - 8]        ; UNKNOWN
00E07B  9A 00 00 D9 5C        LCALL  0x5cd9, 0                    ; UNKNOWN
00E080  80 3E A2 09 00        CMP    byte ptr [0x9a2], 0          ; UNKNOWN
00E085  75 1B                 JNE    0xe0a2                       ; UNKNOWN
00E087  83 7E F8 03           CMP    word ptr [bp - 8], 3         ; UNKNOWN
00E08B  74 05                 JE     0xe092                       ; UNKNOWN
00E08D  B8 01 00              MOV    ax, 1                        ; UNKNOWN
00E090  EB 02                 JMP    0xe094                       ; UNKNOWN
00E092  2B C0                 SUB    ax, ax                       ; UNKNOWN
00E094  50                    PUSH   ax                           ; UNKNOWN
00E095  FF 76 F8              PUSH   word ptr [bp - 8]            ; UNKNOWN
00E098  9A 0C 00 4C 5E        LCALL  0x5e4c, 0xc                  ; UNKNOWN
00E09D  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00E0A0  EB 06                 JMP    0xe0a8                       ; UNKNOWN
00E0A2  8B 46 F8              MOV    ax, word ptr [bp - 8]        ; UNKNOWN
00E0A5  A3 DC CE              MOV    word ptr [0xcedc], ax        ; UNKNOWN
00E0A8  FF 76 F8              PUSH   word ptr [bp - 8]            ; UNKNOWN
00E0AB  6A 01                 PUSH   1                            ; UNKNOWN
00E0AD  9A 82 00 1E 5C        LCALL  0x5c1e, 0x82                 ; UNKNOWN
00E0B2  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00E0B5  68 00 A0              PUSH   0xa000                       ; UNKNOWN
00E0B8  68 00 FC              PUSH   0xfc00                       ; UNKNOWN
00E0BB  8D 1E AC 1C           LEA    bx, [0x1cac]                 ; UNKNOWN
00E0BF  9A 0C 00 D2 5C        LCALL  0x5cd2, 0xc                  ; UNKNOWN
00E0C4  0B C0                 OR     ax, ax                       ; UNKNOWN
00E0C6  74 09                 JE     0xe0d1                       ; UNKNOWN
00E0C8  C7 06 9C 09 13 00     MOV    word ptr [0x99c], 0x13       ; UNKNOWN
00E0CE  E9 D9 02              JMP    0xe3aa                       ; UNKNOWN
00E0D1  8D 1E D2 3E           LEA    bx, [0x3ed2]                 ; UNKNOWN
00E0D5  B8 20 00              MOV    ax, 0x20                     ; UNKNOWN
00E0D8  8B D0                 MOV    dx, ax                       ; UNKNOWN
00E0DA  9A 06 00 3F 5A        LCALL  0x5a3f, 6                    ; UNKNOWN
00E0DF  A1 D8 3E              MOV    ax, word ptr [0x3ed8]        ; UNKNOWN
00E0E2  0B 06 D6 3E           OR     ax, word ptr [0x3ed6]        ; UNKNOWN
00E0E6  75 09                 JNE    0xe0f1                       ; UNKNOWN
00E0E8  C7 06 9C 09 14 00     MOV    word ptr [0x99c], 0x14       ; UNKNOWN
00E0EE  E9 B9 02              JMP    0xe3aa                       ; UNKNOWN
00E0F1  8D 1E 82 CE           LEA    bx, [0xce82]                 ; UNKNOWN
00E0F5  B8 40 01              MOV    ax, 0x140                    ; UNKNOWN
00E0F8  BA C8 00              MOV    dx, 0xc8                     ; UNKNOWN
00E0FB  9A 06 00 3F 5A        LCALL  0x5a3f, 6                    ; UNKNOWN
00E100  A1 88 CE              MOV    ax, word ptr [0xce88]        ; UNKNOWN
00E103  0B 06 86 CE           OR     ax, word ptr [0xce86]        ; UNKNOWN
00E107  74 DF                 JE     0xe0e8                       ; UNKNOWN
00E109  8D 1E 8A CE           LEA    bx, [0xce8a]                 ; UNKNOWN
00E10D  B8 40 01              MOV    ax, 0x140                    ; UNKNOWN
00E110  BA C8 00              MOV    dx, 0xc8                     ; UNKNOWN
00E113  9A 06 00 3F 5A        LCALL  0x5a3f, 6                    ; UNKNOWN
00E118  A1 90 CE              MOV    ax, word ptr [0xce90]        ; UNKNOWN
00E11B  0B 06 8E CE           OR     ax, word ptr [0xce8e]        ; UNKNOWN
00E11F  74 C7                 JE     0xe0e8                       ; UNKNOWN
00E121  9A 04 00 B4 5C        LCALL  0x5cb4, 4                    ; UNKNOWN
00E126  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
00E12A  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
00E12E  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
00E132  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
00E136  2A C0                 SUB    al, al                       ; UNKNOWN
00E138  9A 02 00 47 5A        LCALL  0x5a47, 2                    ; UNKNOWN
00E13D  8D 1E B8 1C           LEA    bx, [0x1cb8]                 ; UNKNOWN
00E141  9A 0A 00 4D 5B        LCALL  0x5b4d, 0xa                  ; UNKNOWN
00E146  A3 20 0C              MOV    word ptr [0xc20], ax         ; UNKNOWN
00E149  89 16 22 0C           MOV    word ptr [0xc22], dx         ; UNKNOWN
00E14D  8B C2                 MOV    ax, dx                       ; UNKNOWN
00E14F  0B                    DB     0x0B                         ; UNKNOWN (raw)
00E150  06                    DB     0x06                         ; UNKNOWN (raw)
