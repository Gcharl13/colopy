; ============================================================================
; func_039FF5_unknown
; Region   : load_image
; Bytes    : file 0x039FF5..0x03A0FD  (264 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

039FF5  C8 5E 00 00           ENTER  0x5e, 0                      ; UNKNOWN
039FF9  A1 0A 3E              MOV    ax, word ptr [0x3e0a]        ; UNKNOWN
039FFC  89 46 A2              MOV    word ptr [bp - 0x5e], ax     ; UNKNOWN
039FFF  6B D8 1C              IMUL   bx, ax, 0x1c                 ; UNKNOWN
03A002  80 BF 8C 88 00        CMP    byte ptr [bx - 0x7774], 0    ; UNKNOWN
03A007  75 03                 JNE    0x3a00c                      ; UNKNOWN
03A009  E9 E9 00              JMP    0x3a0f5                      ; UNKNOWN
03A00C  2B D2                 SUB    dx, dx                       ; UNKNOWN
03A00E  89 16 06 0A           MOV    word ptr [0xa06], dx         ; UNKNOWN
03A012  8D 1E 86 09           LEA    bx, [0x986]                  ; UNKNOWN
03A016  8D 06 5D 22           LEA    ax, [0x225d]                 ; UNKNOWN
03A01A  9A 5A 32 97 1B        LCALL  0x1b97, 0x325a               ; UNKNOWN
03A01F  89 46 AC              MOV    word ptr [bp - 0x54], ax     ; UNKNOWN
03A022  89 56 AE              MOV    word ptr [bp - 0x52], dx     ; UNKNOWN
03A025  0B D0                 OR     dx, ax                       ; UNKNOWN
03A027  75 03                 JNE    0x3a02c                      ; UNKNOWN
03A029  E9 C9 00              JMP    0x3a0f5                      ; UNKNOWN
03A02C  6A 63                 PUSH   0x63                         ; UNKNOWN
03A02E  FF 36 3A 33           PUSH   word ptr [0x333a]            ; UNKNOWN
03A032  9A 6C 00 E6 21        LCALL  0x21e6, 0x6c                 ; UNKNOWN
03A037  83 C4 02              ADD    sp, 2                        ; UNKNOWN
03A03A  52                    PUSH   dx                           ; UNKNOWN
03A03B  50                    PUSH   ax                           ; UNKNOWN
03A03C  FF 76 AE              PUSH   word ptr [bp - 0x52]         ; UNKNOWN
03A03F  FF 76 AC              PUSH   word ptr [bp - 0x54]         ; UNKNOWN
03A042  9A E6 09 97 1B        LCALL  0x1b97, 0x9e6                ; UNKNOWN
03A047  83 C4 0A              ADD    sp, 0xa                      ; UNKNOWN
03A04A  C7 46 A6 00 00        MOV    word ptr [bp - 0x5a], 0      ; UNKNOWN
03A04F  EB 70                 JMP    0x3a0c1                      ; UNKNOWN
03A051  FF 76 A6              PUSH   word ptr [bp - 0x5a]         ; UNKNOWN
03A054  FF 76 A2              PUSH   word ptr [bp - 0x5e]         ; UNKNOWN
03A057  9A 92 2F 5F 24        LCALL  0x245f, 0x2f92               ; UNKNOWN
03A05C  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03A05F  89 46 A4              MOV    word ptr [bp - 0x5c], ax     ; UNKNOWN
03A062  C6 46 B0 00           MOV    byte ptr [bp - 0x50], 0      ; UNKNOWN
03A066  FF 76 A6              PUSH   word ptr [bp - 0x5a]         ; UNKNOWN
03A069  FF 76 A2              PUSH   word ptr [bp - 0x5e]         ; UNKNOWN
03A06C  9A DF 2F 5F 24        LCALL  0x245f, 0x2fdf               ; UNKNOWN
03A071  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03A074  89 46 AA              MOV    word ptr [bp - 0x56], ax     ; UNKNOWN
03A077  50                    PUSH   ax                           ; UNKNOWN
03A078  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
03A07B  16                    PUSH   ss                           ; UNKNOWN
03A07C  50                    PUSH   ax                           ; UNKNOWN
03A07D  9A 38 01 13 24        LCALL  0x2413, 0x138                ; UNKNOWN
03A082  83 C4 06              ADD    sp, 6                        ; UNKNOWN
03A085  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
03A088  50                    PUSH   ax                           ; UNKNOWN
03A089  9A 0C 00 13 24        LCALL  0x2413, 0xc                  ; UNKNOWN
03A08E  83 C4 02              ADD    sp, 2                        ; UNKNOWN
03A091  8B 5E A4              MOV    bx, word ptr [bp - 0x5c]     ; UNKNOWN
03A094  D1 E3                 SHL    bx, 1                        ; UNKNOWN
03A096  FF B7 A1 3D           PUSH   word ptr [bx + 0x3da1]       ; UNKNOWN
03A09A  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
03A09D  50                    PUSH   ax                           ; UNKNOWN
03A09E  9A ED 00 13 24        LCALL  0x2413, 0xed                 ; UNKNOWN
03A0A3  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03A0A6  8B 46 A6              MOV    ax, word ptr [bp - 0x5a]     ; UNKNOWN
03A0A9  40                    INC    ax                           ; UNKNOWN
03A0AA  50                    PUSH   ax                           ; UNKNOWN
03A0AB  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
03A0AE  16                    PUSH   ss                           ; UNKNOWN
03A0AF  50                    PUSH   ax                           ; UNKNOWN
03A0B0  FF 76 AE              PUSH   word ptr [bp - 0x52]         ; UNKNOWN
03A0B3  FF 76 AC              PUSH   word ptr [bp - 0x54]         ; UNKNOWN
03A0B6  9A E6 09 97 1B        LCALL  0x1b97, 0x9e6                ; UNKNOWN
03A0BB  83 C4 0A              ADD    sp, 0xa                      ; UNKNOWN
03A0BE  FF 46 A6              INC    word ptr [bp - 0x5a]         ; UNKNOWN
03A0C1  6B 5E A2 1C           IMUL   bx, word ptr [bp - 0x5e], 0x1c ; UNKNOWN
03A0C5  8A 87 8C 88           MOV    al, byte ptr [bx - 0x7774]   ; UNKNOWN
03A0C9  2A E4                 SUB    ah, ah                       ; UNKNOWN
03A0CB  3B 46 A6              CMP    ax, word ptr [bp - 0x5a]     ; UNKNOWN
03A0CE  7F 81                 JG     0x3a051                      ; UNKNOWN
03A0D0  FF 76 AE              PUSH   word ptr [bp - 0x52]         ; UNKNOWN
03A0D3  FF 76 AC              PUSH   word ptr [bp - 0x54]         ; UNKNOWN
03A0D6  9A 4A 25 97 1B        LCALL  0x1b97, 0x254a               ; UNKNOWN
03A0DB  89 46 A8              MOV    word ptr [bp - 0x58], ax     ; UNKNOWN
03A0DE  0B C0                 OR     ax, ax                       ; UNKNOWN
03A0E0  7E 13                 JLE    0x3a0f5                      ; UNKNOWN
03A0E2  83 F8 63              CMP    ax, 0x63                     ; UNKNOWN
03A0E5  74 0E                 JE     0x3a0f5                      ; UNKNOWN
03A0E7  FF 4E A8              DEC    word ptr [bp - 0x58]         ; UNKNOWN
03A0EA  FF 76 A8              PUSH   word ptr [bp - 0x58]         ; UNKNOWN
03A0ED  FF 76 A2              PUSH   word ptr [bp - 0x5e]         ; UNKNOWN
03A0F0  9A 19 31 5F 24        LCALL  0x245f, 0x3119               ; UNKNOWN
03A0F5  C7 06 06 0A FF FF     MOV    word ptr [0xa06], 0xffff     ; UNKNOWN
03A0FB  C9                    LEAVE                               ; UNKNOWN
03A0FC  CB                    RETF                                ; UNKNOWN
