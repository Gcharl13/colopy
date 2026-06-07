; ============================================================================
; func_04D1F4_unknown
; Region   : load_image
; Bytes    : file 0x04D1F4..0x04D34C  (344 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04D1F4  C8 58 00 00           ENTER  0x58, 0                      ; UNKNOWN
04D1F8  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
04D1FB  9A 04 00 E2 29        LCALL  0x29e2, 4                    ; UNKNOWN
04D200  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04D203  6A 07                 PUSH   7                            ; UNKNOWN
04D205  0E                    PUSH   cs                           ; UNKNOWN
04D206  E8 59 DF              CALL   0x4b162                      ; UNKNOWN
04D209  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04D20C  68 90 00              PUSH   0x90                         ; UNKNOWN
04D20F  6A 05                 PUSH   5                            ; UNKNOWN
04D211  68 40 01              PUSH   0x140                        ; UNKNOWN
04D214  6A 00                 PUSH   0                            ; UNKNOWN
04D216  FF 36 62 33           PUSH   word ptr [0x3362]            ; UNKNOWN
04D21A  9A 6C 00 E6 21        LCALL  0x21e6, 0x6c                 ; UNKNOWN
04D21F  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04D222  52                    PUSH   dx                           ; UNKNOWN
04D223  50                    PUSH   ax                           ; UNKNOWN
04D224  9A 1E 03 13 24        LCALL  0x2413, 0x31e                ; UNKNOWN
04D229  83 C4 0C              ADD    sp, 0xc                      ; UNKNOWN
04D22C  C7 46 AC 19 00        MOV    word ptr [bp - 0x54], 0x19   ; UNKNOWN
04D231  C6 46 B0 00           MOV    byte ptr [bp - 0x50], 0      ; UNKNOWN
04D235  FF 36 74 33           PUSH   word ptr [0x3374]            ; UNKNOWN
04D239  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
04D23C  50                    PUSH   ax                           ; UNKNOWN
04D23D  9A ED 00 13 24        LCALL  0x2413, 0xed                 ; UNKNOWN
04D242  83 C4 04              ADD    sp, 4                        ; UNKNOWN
04D245  68 92 00              PUSH   0x92                         ; UNKNOWN
04D248  B8 1B 00              MOV    ax, 0x1b                     ; UNKNOWN
04D24B  89 46 A8              MOV    word ptr [bp - 0x58], ax     ; UNKNOWN
04D24E  50                    PUSH   ax                           ; UNKNOWN
04D24F  6A 50                 PUSH   0x50                         ; UNKNOWN
04D251  B8 02 00              MOV    ax, 2                        ; UNKNOWN
04D254  89 46 AE              MOV    word ptr [bp - 0x52], ax     ; UNKNOWN
04D257  50                    PUSH   ax                           ; UNKNOWN
04D258  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
04D25B  16                    PUSH   ss                           ; UNKNOWN
04D25C  50                    PUSH   ax                           ; UNKNOWN
04D25D  9A 1E 03 13 24        LCALL  0x2413, 0x31e                ; UNKNOWN
04D262  83 C4 0C              ADD    sp, 0xc                      ; UNKNOWN
04D265  C6 46 B0 00           MOV    byte ptr [bp - 0x50], 0      ; UNKNOWN
04D269  FF 36 76 33           PUSH   word ptr [0x3376]            ; UNKNOWN
04D26D  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
04D270  50                    PUSH   ax                           ; UNKNOWN
04D271  9A ED 00 13 24        LCALL  0x2413, 0xed                 ; UNKNOWN
04D276  83 C4 04              ADD    sp, 4                        ; UNKNOWN
04D279  68 92 00              PUSH   0x92                         ; UNKNOWN
04D27C  6A 1B                 PUSH   0x1b                         ; UNKNOWN
04D27E  6A 50                 PUSH   0x50                         ; UNKNOWN
04D280  6A 52                 PUSH   0x52                         ; UNKNOWN
04D282  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
04D285  16                    PUSH   ss                           ; UNKNOWN
04D286  50                    PUSH   ax                           ; UNKNOWN
04D287  9A 1E 03 13 24        LCALL  0x2413, 0x31e                ; UNKNOWN
04D28C  83 C4 0C              ADD    sp, 0xc                      ; UNKNOWN
04D28F  C6 46 B0 00           MOV    byte ptr [bp - 0x50], 0      ; UNKNOWN
04D293  FF 36 78 33           PUSH   word ptr [0x3378]            ; UNKNOWN
04D297  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
04D29A  50                    PUSH   ax                           ; UNKNOWN
04D29B  9A ED 00 13 24        LCALL  0x2413, 0xed                 ; UNKNOWN
04D2A0  83 C4 04              ADD    sp, 4                        ; UNKNOWN
04D2A3  68 92 00              PUSH   0x92                         ; UNKNOWN
04D2A6  6A 1B                 PUSH   0x1b                         ; UNKNOWN
04D2A8  6A 50                 PUSH   0x50                         ; UNKNOWN
04D2AA  68 A2 00              PUSH   0xa2                         ; UNKNOWN
04D2AD  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
04D2B0  16                    PUSH   ss                           ; UNKNOWN
04D2B1  50                    PUSH   ax                           ; UNKNOWN
04D2B2  9A 1E 03 13 24        LCALL  0x2413, 0x31e                ; UNKNOWN
04D2B7  83 C4 0C              ADD    sp, 0xc                      ; UNKNOWN
04D2BA  C6 46 B0 00           MOV    byte ptr [bp - 0x50], 0      ; UNKNOWN
04D2BE  FF 36 7A 33           PUSH   word ptr [0x337a]            ; UNKNOWN
04D2C2  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
04D2C5  50                    PUSH   ax                           ; UNKNOWN
04D2C6  9A ED 00 13 24        LCALL  0x2413, 0xed                 ; UNKNOWN
04D2CB  83 C4 04              ADD    sp, 4                        ; UNKNOWN
04D2CE  68 92 00              PUSH   0x92                         ; UNKNOWN
04D2D1  6A 1B                 PUSH   0x1b                         ; UNKNOWN
04D2D3  6A 4C                 PUSH   0x4c                         ; UNKNOWN
04D2D5  68 F2 00              PUSH   0xf2                         ; UNKNOWN
04D2D8  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
04D2DB  16                    PUSH   ss                           ; UNKNOWN
04D2DC  50                    PUSH   ax                           ; UNKNOWN
04D2DD  9A 1E 03 13 24        LCALL  0x2413, 0x31e                ; UNKNOWN
04D2E2  83 C4 0C              ADD    sp, 0xc                      ; UNKNOWN
04D2E5  C7 46 AA 01 00        MOV    word ptr [bp - 0x56], 1      ; UNKNOWN
04D2EA  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
04D2EE  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
04D2F2  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
04D2F6  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
04D2FA  6A 77                 PUSH   0x77                         ; UNKNOWN
04D2FC  6B 46 AA 50           IMUL   ax, word ptr [bp - 0x56], 0x50 ; UNKNOWN
04D300  03 46 AE              ADD    ax, word ptr [bp - 0x52]     ; UNKNOWN
04D303  BA 19 00              MOV    dx, 0x19                     ; UNKNOWN
04D306  BB B4 00              MOV    bx, 0xb4                     ; UNKNOWN
04D309  9A 04 00 7D 5A        LCALL  0x5a7d, 4                    ; UNKNOWN
04D30E  FF 46 AA              INC    word ptr [bp - 0x56]         ; UNKNOWN
04D311  83 7E AA 03           CMP    word ptr [bp - 0x56], 3      ; UNKNOWN
04D315  7E D3                 JLE    0x4d2ea                      ; UNKNOWN
04D317  C7 46 AA 00 00        MOV    word ptr [bp - 0x56], 0      ; UNKNOWN
04D31C  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
04D320  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
04D324  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
04D328  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
04D32C  6A 77                 PUSH   0x77                         ; UNKNOWN
04D32E  8B 46 AA              MOV    ax, word ptr [bp - 0x56]     ; UNKNOWN
04D331  40                    INC    ax                           ; UNKNOWN
04D332  40                    INC    ax                           ; UNKNOWN
04D333  6B D8 14              IMUL   bx, ax, 0x14                 ; UNKNOWN
04D336  B8 02 00              MOV    ax, 2                        ; UNKNOWN
04D339  BA 3A 01              MOV    dx, 0x13a                    ; UNKNOWN
04D33C  9A 0A 00 76 5A        LCALL  0x5a76, 0xa                  ; UNKNOWN
04D341  FF 46 AA              INC    word ptr [bp - 0x56]         ; UNKNOWN
04D344  83 7E AA 08           CMP    word ptr [bp - 0x56], 8      ; UNKNOWN
04D348  7C D2                 JL     0x4d31c                      ; UNKNOWN
04D34A  C9                    LEAVE                               ; UNKNOWN
04D34B  CB                    RETF                                ; UNKNOWN
