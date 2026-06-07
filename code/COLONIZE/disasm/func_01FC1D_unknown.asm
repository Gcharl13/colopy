; ============================================================================
; func_01FC1D_unknown
; Region   : load_image
; Bytes    : file 0x01FC1D..0x01FCF8  (219 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

01FC1D  C8 1E 05 00           ENTER  0x51e, 0                     ; UNKNOWN
01FC21  56                    PUSH   si                           ; UNKNOWN
01FC22  8D 86 04 FB           LEA    ax, [bp - 0x4fc]             ; UNKNOWN
01FC26  16                    PUSH   ss                           ; UNKNOWN
01FC27  50                    PUSH   ax                           ; UNKNOWN
01FC28  6A 00                 PUSH   0                            ; UNKNOWN
01FC2A  FF 36 90 CE           PUSH   word ptr [0xce90]            ; UNKNOWN
01FC2E  FF 36 8E CE           PUSH   word ptr [0xce8e]            ; UNKNOWN
01FC32  FF 36 8C CE           PUSH   word ptr [0xce8c]            ; UNKNOWN
01FC36  FF 36 8A CE           PUSH   word ptr [0xce8a]            ; UNKNOWN
01FC3A  68 E2 17              PUSH   0x17e2                       ; UNKNOWN
01FC3D  9A 0A 00 69 1A        LCALL  0x1a69, 0xa                  ; UNKNOWN
01FC42  83 C4 10              ADD    sp, 0x10                     ; UNKNOWN
01FC45  0B C0                 OR     ax, ax                       ; UNKNOWN
01FC47  74 03                 JE     0x1fc4c                      ; UNKNOWN
01FC49  E9 E7 03              JMP    0x20033                      ; UNKNOWN
01FC4C  9A 1D 00 EF 21        LCALL  0x21ef, 0x1d                 ; UNKNOWN
01FC51  C7 06 14 0C 00 00     MOV    word ptr [0xc14], 0          ; UNKNOWN
01FC57  8D 86 04 FB           LEA    ax, [bp - 0x4fc]             ; UNKNOWN
01FC5B  16                    PUSH   ss                           ; UNKNOWN
01FC5C  50                    PUSH   ax                           ; UNKNOWN
01FC5D  9A 02 00 F3 5B        LCALL  0x5bf3, 2                    ; UNKNOWN
01FC62  FF 36 90 CE           PUSH   word ptr [0xce90]            ; UNKNOWN
01FC66  FF 36 8E CE           PUSH   word ptr [0xce8e]            ; UNKNOWN
01FC6A  FF 36 8C CE           PUSH   word ptr [0xce8c]            ; UNKNOWN
01FC6E  FF 36 8A CE           PUSH   word ptr [0xce8a]            ; UNKNOWN
01FC72  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
01FC76  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
01FC7A  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
01FC7E  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
01FC82  68 C8 00              PUSH   0xc8                         ; UNKNOWN
01FC85  2B C0                 SUB    ax, ax                       ; UNKNOWN
01FC87  99                    CDQ                                 ; UNKNOWN
01FC88  BB 40 01              MOV    bx, 0x140                    ; UNKNOWN
01FC8B  9A 04 00 49 5A        LCALL  0x5a49, 4                    ; UNKNOWN
01FC90  6A 00                 PUSH   0                            ; UNKNOWN
01FC92  68 40 01              PUSH   0x140                        ; UNKNOWN
01FC95  68 C8 00              PUSH   0xc8                         ; UNKNOWN
01FC98  2B C0                 SUB    ax, ax                       ; UNKNOWN
01FC9A  99                    CDQ                                 ; UNKNOWN
01FC9B  2B DB                 SUB    bx, bx                       ; UNKNOWN
01FC9D  9A 3B 00 B4 5C        LCALL  0x5cb4, 0x3b                 ; UNKNOWN
01FCA2  9A 08 00 D0 21        LCALL  0x21d0, 8                    ; UNKNOWN
01FCA7  6B 06 10 3E 34        IMUL   ax, word ptr [0x3e10], 0x34  ; UNKNOWN
01FCAC  05 86 C0              ADD    ax, 0xc086                   ; UNKNOWN
01FCAF  50                    PUSH   ax                           ; UNKNOWN
01FCB0  8D 46 AC              LEA    ax, [bp - 0x54]              ; UNKNOWN
01FCB3  50                    PUSH   ax                           ; UNKNOWN
01FCB4  9A 74 07 65 5F        LCALL  0x5f65, 0x774                ; UNKNOWN
01FCB9  83 C4 04              ADD    sp, 4                        ; UNKNOWN
01FCBC  8D 46 AC              LEA    ax, [bp - 0x54]              ; UNKNOWN
01FCBF  50                    PUSH   ax                           ; UNKNOWN
01FCC0  9A 80 0D 65 5F        LCALL  0x5f65, 0xd80                ; UNKNOWN
01FCC5  83 C4 02              ADD    sp, 2                        ; UNKNOWN
01FCC8  6A 1A                 PUSH   0x1a                         ; UNKNOWN
01FCCA  6A 00                 PUSH   0                            ; UNKNOWN
01FCCC  8D 86 E8 FA           LEA    ax, [bp - 0x518]             ; UNKNOWN
01FCD0  50                    PUSH   ax                           ; UNKNOWN
01FCD1  9A E8 0D 65 5F        LCALL  0x5f65, 0xde8                ; UNKNOWN
01FCD6  83 C4 06              ADD    sp, 6                        ; UNKNOWN
01FCD9  6A 1A                 PUSH   0x1a                         ; UNKNOWN
01FCDB  6A 00                 PUSH   0                            ; UNKNOWN
01FCDD  8D 86 CC FE           LEA    ax, [bp - 0x134]             ; UNKNOWN
01FCE1  50                    PUSH   ax                           ; UNKNOWN
01FCE2  9A E8 0D 65 5F        LCALL  0x5f65, 0xde8                ; UNKNOWN
01FCE7  83 C4 06              ADD    sp, 6                        ; UNKNOWN
01FCEA  C7 86 E4 FA 01 00     MOV    word ptr [bp - 0x51c], 1     ; UNKNOWN
01FCF0  8D 46 AC              LEA    ax, [bp - 0x54]              ; UNKNOWN
01FCF3  89 86 CA FE           MOV    word ptr [bp - 0x136], ax    ; UNKNOWN
01FCF7  EB                    DB     0xEB                         ; UNKNOWN (raw)
