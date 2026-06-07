; ============================================================================
; func_058BD6_unknown
; Region   : load_image
; Bytes    : file 0x058BD6..0x058D83  (429 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

058BD6  C8 DE 00 00           ENTER  0xde, 0                      ; UNKNOWN
058BDA  57                    PUSH   di                           ; UNKNOWN
058BDB  56                    PUSH   si                           ; UNKNOWN
058BDC  B8 FF FF              MOV    ax, 0xffff                   ; UNKNOWN
058BDF  89 86 2A FF           MOV    word ptr [bp - 0xd6], ax     ; UNKNOWN
058BE3  89 86 50 FF           MOV    word ptr [bp - 0xb0], ax     ; UNKNOWN
058BE7  89 46 A0              MOV    word ptr [bp - 0x60], ax     ; UNKNOWN
058BEA  2B C0                 SUB    ax, ax                       ; UNKNOWN
058BEC  89 86 28 FF           MOV    word ptr [bp - 0xd8], ax     ; UNKNOWN
058BF0  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; UNKNOWN
058BF3  89 46 92              MOV    word ptr [bp - 0x6e], ax     ; UNKNOWN
058BF6  89 86 6A FF           MOV    word ptr [bp - 0x96], ax     ; UNKNOWN
058BFA  89 86 56 FF           MOV    word ptr [bp - 0xaa], ax     ; UNKNOWN
058BFE  89 46 90              MOV    word ptr [bp - 0x70], ax     ; UNKNOWN
058C01  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
058C04  89 46 86              MOV    word ptr [bp - 0x7a], ax     ; UNKNOWN
058C07  89 86 38 FF           MOV    word ptr [bp - 0xc8], ax     ; UNKNOWN
058C0B  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
058C0F  8A 87 82 88           MOV    al, byte ptr [bx - 0x777e]   ; UNKNOWN
058C13  2A E4                 SUB    ah, ah                       ; UNKNOWN
058C15  89 86 66 FF           MOV    word ptr [bp - 0x9a], ax     ; UNKNOWN
058C19  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
058C1C  8B F3                 MOV    si, bx                       ; UNKNOWN
058C1E  9A 54 06 B7 36        LCALL  0x36b7, 0x654                ; UNKNOWN
058C23  83 C4 02              ADD    sp, 2                        ; UNKNOWN
058C26  2A E4                 SUB    ah, ah                       ; UNKNOWN
058C28  8A 8C 85 88           MOV    cl, byte ptr [si - 0x777b]   ; UNKNOWN
058C2C  2A ED                 SUB    ch, ch                       ; UNKNOWN
058C2E  2B C1                 SUB    ax, cx                       ; UNKNOWN
058C30  89 86 68 FF           MOV    word ptr [bp - 0x98], ax     ; UNKNOWN
058C34  83 7E 0E 00           CMP    word ptr [bp + 0xe], 0       ; UNKNOWN
058C38  74 05                 JE     0x58c3f                      ; UNKNOWN
058C3A  80 84 85 88 03        ADD    byte ptr [si - 0x777b], 3    ; UNKNOWN
058C3F  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
058C43  8A 87 83 88           MOV    al, byte ptr [bx - 0x777d]   ; UNKNOWN
058C47  83 E0 0F              AND    ax, 0xf                      ; UNKNOWN
058C4A  89 86 7A FF           MOV    word ptr [bp - 0x86], ax     ; UNKNOWN
058C4E  8A 87 86 88           MOV    al, byte ptr [bx - 0x777a]   ; UNKNOWN
058C52  98                    CWDE                                ; UNKNOWN
058C53  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
058C56  80 BF 82 88 0D        CMP    byte ptr [bx - 0x777e], 0xd  ; UNKNOWN
058C5B  72 0F                 JB     0x58c6c                      ; UNKNOWN
058C5D  80 BF 82 88 12        CMP    byte ptr [bx - 0x777e], 0x12 ; UNKNOWN
058C62  77 08                 JA     0x58c6c                      ; UNKNOWN
058C64  C7 86 7C FF 01 00     MOV    word ptr [bp - 0x84], 1      ; UNKNOWN
058C6A  EB 06                 JMP    0x58c72                      ; UNKNOWN
058C6C  C7 86 7C FF 00 00     MOV    word ptr [bp - 0x84], 0      ; UNKNOWN
058C72  FF B6 7A FF           PUSH   word ptr [bp - 0x86]         ; UNKNOWN
058C76  8B 46 08              MOV    ax, word ptr [bp + 8]        ; UNKNOWN
058C79  8B 56 0A              MOV    dx, word ptr [bp + 0xa]      ; UNKNOWN
058C7C  9A 60 00 B7 36        LCALL  0x36b7, 0x60                 ; UNKNOWN
058C81  89 46 82              MOV    word ptr [bp - 0x7e], ax     ; UNKNOWN
058C84  50                    PUSH   ax                           ; UNKNOWN
058C85  0E                    PUSH   cs                           ; UNKNOWN
058C86  E8 61 E4              CALL   0x570ea                      ; UNKNOWN
058C89  83 C4 04              ADD    sp, 4                        ; UNKNOWN
058C8C  89 86 3A FF           MOV    word ptr [bp - 0xc6], ax     ; UNKNOWN
058C90  2B C0                 SUB    ax, ax                       ; UNKNOWN
058C92  A3 58 C1              MOV    word ptr [0xc158], ax        ; UNKNOWN
058C95  A3 E0 CD              MOV    word ptr [0xcde0], ax        ; UNKNOWN
058C98  A3 5A C1              MOV    word ptr [0xc15a], ax        ; UNKNOWN
058C9B  A3 E2 CD              MOV    word ptr [0xcde2], ax        ; UNKNOWN
058C9E  83 BE 68 FF 03        CMP    word ptr [bp - 0x98], 3      ; UNKNOWN
058CA3  7D 5F                 JGE    0x58d04                      ; UNKNOWN
058CA5  8B 86 68 FF           MOV    ax, word ptr [bp - 0x98]     ; UNKNOWN
058CA9  89 86 6A FF           MOV    word ptr [bp - 0x96], ax     ; UNKNOWN
058CAD  83 7E 0E 00           CMP    word ptr [bp + 0xe], 0       ; UNKNOWN
058CB1  74 39                 JE     0x58cec                      ; UNKNOWN
058CB3  83 BE 7A FF 04        CMP    word ptr [bp - 0x86], 4      ; UNKNOWN
058CB8  7C 03                 JL     0x58cbd                      ; UNKNOWN
058CBA  E9 7B 1B              JMP    0x5a838                      ; UNKNOWN
058CBD  6B 9E 7A FF 34        IMUL   bx, word ptr [bp - 0x86], 0x34 ; UNKNOWN
058CC2  80 BF B7 C0 00        CMP    byte ptr [bx - 0x3f49], 0    ; UNKNOWN
058CC7  74 03                 JE     0x58ccc                      ; UNKNOWN
058CC9  E9 6C 1B              JMP    0x5a838                      ; UNKNOWN
058CCC  99                    CDQ                                 ; UNKNOWN
058CCD  52                    PUSH   dx                           ; UNKNOWN
058CCE  50                    PUSH   ax                           ; UNKNOWN
058CCF  6A 00                 PUSH   0                            ; UNKNOWN
058CD1  9A 24 04 97 1B        LCALL  0x1b97, 0x424                ; UNKNOWN
058CD6  83 C4 06              ADD    sp, 6                        ; UNKNOWN
058CD9  6A 01                 PUSH   1                            ; UNKNOWN
058CDB  68 50 2C              PUSH   0x2c50                       ; UNKNOWN
058CDE  9A 41 37 97 1B        LCALL  0x1b97, 0x3741               ; UNKNOWN
058CE3  83 C4 04              ADD    sp, 4                        ; UNKNOWN
058CE6  48                    DEC    ax                           ; UNKNOWN
058CE7  74 03                 JE     0x58cec                      ; UNKNOWN
058CE9  E9 4C 1B              JMP    0x5a838                      ; UNKNOWN
058CEC  83 BE 68 FF 02        CMP    word ptr [bp - 0x98], 2      ; UNKNOWN
058CF1  75 05                 JNE    0x58cf8                      ; UNKNOWN
058CF3  80 0E 59 C1 01        OR     byte ptr [0xc159], 1         ; UNKNOWN
058CF8  83 BE 68 FF 01        CMP    word ptr [bp - 0x98], 1      ; UNKNOWN
058CFD  75 05                 JNE    0x58d04                      ; UNKNOWN
058CFF  80 0E E0 CD 08        OR     byte ptr [0xcde0], 8         ; UNKNOWN
058D04  83 7E 0E 00           CMP    word ptr [bp + 0xe], 0       ; UNKNOWN
058D08  74 0B                 JE     0x58d15                      ; UNKNOWN
058D0A  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
058D0D  9A 35 15 B7 36        LCALL  0x36b7, 0x1535               ; UNKNOWN
058D12  83 C4 02              ADD    sp, 2                        ; UNKNOWN
058D15  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
058D18  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
058D1B  9A D1 03 C9 33        LCALL  0x33c9, 0x3d1                ; UNKNOWN
058D20  83 C4 04              ADD    sp, 4                        ; UNKNOWN
058D23  89 86 2C FF           MOV    word ptr [bp - 0xd4], ax     ; UNKNOWN
058D27  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
058D2A  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
058D2D  9A 61 0A 5F 24        LCALL  0x245f, 0xa61                ; UNKNOWN
058D32  83 C4 04              ADD    sp, 4                        ; UNKNOWN
058D35  89 86 2A FF           MOV    word ptr [bp - 0xd6], ax     ; UNKNOWN
058D39  83 BE 3A FF 00        CMP    word ptr [bp - 0xc6], 0      ; UNKNOWN
058D3E  7C 03                 JL     0x58d43                      ; UNKNOWN
058D40  E9 A3 01              JMP    0x58ee6                      ; UNKNOWN
058D43  C7 46 92 01 00        MOV    word ptr [bp - 0x6e], 1      ; UNKNOWN
058D48  83 BE 2C FF 00        CMP    word ptr [bp - 0xd4], 0      ; UNKNOWN
058D4D  7D 34                 JGE    0x58d83                      ; UNKNOWN
058D4F  C7 86 72 FF 01 00     MOV    word ptr [bp - 0x8e], 1      ; UNKNOWN
058D55  FF B6 72 FF           PUSH   word ptr [bp - 0x8e]         ; UNKNOWN
058D59  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
058D5C  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
058D5F  68 2B 2D              PUSH   0x2d2b                       ; UNKNOWN
058D62  9A DD 00 AA 38        LCALL  0x38aa, 0xdd                 ; UNKNOWN
058D67  83 C4 08              ADD    sp, 8                        ; UNKNOWN
058D6A  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
058D6D  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
058D70  9A 02 00 C9 33        LCALL  0x33c9, 2                    ; UNKNOWN
058D75  83 C4 04              ADD    sp, 4                        ; UNKNOWN
058D78  0B C0                 OR     ax, ax                       ; UNKNOWN
058D7A  74 03                 JE     0x58d7f                      ; UNKNOWN
058D7C  E9 21 1A              JMP    0x5a7a0                      ; UNKNOWN
058D7F  5E                    POP    si                           ; UNKNOWN
058D80  5F                    POP    di                           ; UNKNOWN
058D81  C9                    LEAVE                               ; UNKNOWN
058D82  CB                    RETF                                ; UNKNOWN
