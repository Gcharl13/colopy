; ============================================================================
; func_04C85A_unknown
; Region   : load_image
; Bytes    : file 0x04C85A..0x04C9D0  (374 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04C85A  C8 8C 00 00           ENTER  0x8c, 0                      ; UNKNOWN
04C85E  56                    PUSH   si                           ; UNKNOWN
04C85F  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
04C862  9A 04 00 E2 29        LCALL  0x29e2, 4                    ; UNKNOWN
04C867  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04C86A  6A 05                 PUSH   5                            ; UNKNOWN
04C86C  0E                    PUSH   cs                           ; UNKNOWN
04C86D  E8 F2 E8              CALL   0x4b162                      ; UNKNOWN
04C870  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04C873  68 90 00              PUSH   0x90                         ; UNKNOWN
04C876  6A 05                 PUSH   5                            ; UNKNOWN
04C878  68 40 01              PUSH   0x140                        ; UNKNOWN
04C87B  6A 00                 PUSH   0                            ; UNKNOWN
04C87D  FF 36 5E 33           PUSH   word ptr [0x335e]            ; UNKNOWN
04C881  9A 6C 00 E6 21        LCALL  0x21e6, 0x6c                 ; UNKNOWN
04C886  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04C889  52                    PUSH   dx                           ; UNKNOWN
04C88A  50                    PUSH   ax                           ; UNKNOWN
04C88B  9A 1E 03 13 24        LCALL  0x2413, 0x31e                ; UNKNOWN
04C890  83 C4 0C              ADD    sp, 0xc                      ; UNKNOWN
04C893  68 91 00              PUSH   0x91                         ; UNKNOWN
04C896  C4 1E B4 09           LES    bx, ptr [0x9b4]              ; UNKNOWN
04C89A  26 8A 07              MOV    al, byte ptr es:[bx]         ; UNKNOWN
04C89D  2A E4                 SUB    ah, ah                       ; UNKNOWN
04C89F  83 C0 06              ADD    ax, 6                        ; UNKNOWN
04C8A2  50                    PUSH   ax                           ; UNKNOWN
04C8A3  68 40 01              PUSH   0x140                        ; UNKNOWN
04C8A6  6A 00                 PUSH   0                            ; UNKNOWN
04C8A8  FF 36 96 34           PUSH   word ptr [0x3496]            ; UNKNOWN
04C8AC  9A 6C 00 E6 21        LCALL  0x21e6, 0x6c                 ; UNKNOWN
04C8B1  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04C8B4  52                    PUSH   dx                           ; UNKNOWN
04C8B5  50                    PUSH   ax                           ; UNKNOWN
04C8B6  9A 1E 03 13 24        LCALL  0x2413, 0x31e                ; UNKNOWN
04C8BB  83 C4 0C              ADD    sp, 0xc                      ; UNKNOWN
04C8BE  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
04C8C2  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
04C8C6  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
04C8CA  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
04C8CE  6A 77                 PUSH   0x77                         ; UNKNOWN
04C8D0  B8 43 00              MOV    ax, 0x43                     ; UNKNOWN
04C8D3  BA 19 00              MOV    dx, 0x19                     ; UNKNOWN
04C8D6  BB A1 00              MOV    bx, 0xa1                     ; UNKNOWN
04C8D9  9A 04 00 7D 5A        LCALL  0x5a7d, 4                    ; UNKNOWN
04C8DE  C6 46 AC 00           MOV    byte ptr [bp - 0x54], 0      ; UNKNOWN
04C8E2  FF 36 6E 33           PUSH   word ptr [0x336e]            ; UNKNOWN
04C8E6  8D 46 AC              LEA    ax, [bp - 0x54]              ; UNKNOWN
04C8E9  50                    PUSH   ax                           ; UNKNOWN
04C8EA  9A ED 00 13 24        LCALL  0x2413, 0xed                 ; UNKNOWN
04C8EF  83 C4 04              ADD    sp, 4                        ; UNKNOWN
04C8F2  68 92 00              PUSH   0x92                         ; UNKNOWN
04C8F5  B8 19 00              MOV    ax, 0x19                     ; UNKNOWN
04C8F8  89 46 A6              MOV    word ptr [bp - 0x5a], ax     ; UNKNOWN
04C8FB  89 86 78 FF           MOV    word ptr [bp - 0x88], ax     ; UNKNOWN
04C8FF  50                    PUSH   ax                           ; UNKNOWN
04C900  6A 4C                 PUSH   0x4c                         ; UNKNOWN
04C902  8D 46 AC              LEA    ax, [bp - 0x54]              ; UNKNOWN
04C905  16                    PUSH   ss                           ; UNKNOWN
04C906  50                    PUSH   ax                           ; UNKNOWN
04C907  9A 8F 02 13 24        LCALL  0x2413, 0x28f                ; UNKNOWN
04C90C  83 C4 0A              ADD    sp, 0xa                      ; UNKNOWN
04C90F  C6 46 AC 00           MOV    byte ptr [bp - 0x54], 0      ; UNKNOWN
04C913  FF 36 70 33           PUSH   word ptr [0x3370]            ; UNKNOWN
04C917  8D 46 AC              LEA    ax, [bp - 0x54]              ; UNKNOWN
04C91A  50                    PUSH   ax                           ; UNKNOWN
04C91B  9A ED 00 13 24        LCALL  0x2413, 0xed                 ; UNKNOWN
04C920  83 C4 04              ADD    sp, 4                        ; UNKNOWN
04C923  68 92 00              PUSH   0x92                         ; UNKNOWN
04C926  6A 19                 PUSH   0x19                         ; UNKNOWN
04C928  FF 36 B6 09           PUSH   word ptr [0x9b6]             ; UNKNOWN
04C92C  FF 36 B4 09           PUSH   word ptr [0x9b4]             ; UNKNOWN
04C930  8D 46 AC              LEA    ax, [bp - 0x54]              ; UNKNOWN
04C933  16                    PUSH   ss                           ; UNKNOWN
04C934  50                    PUSH   ax                           ; UNKNOWN
04C935  2B C0                 SUB    ax, ax                       ; UNKNOWN
04C937  9A 0E 00 75 5B        LCALL  0x5b75, 0xe                  ; UNKNOWN
04C93C  48                    DEC    ax                           ; UNKNOWN
04C93D  89 86 74 FF           MOV    word ptr [bp - 0x8c], ax     ; UNKNOWN
04C941  2D 90 00              SUB    ax, 0x90                     ; UNKNOWN
04C944  F7 D8                 NEG    ax                           ; UNKNOWN
04C946  50                    PUSH   ax                           ; UNKNOWN
04C947  8D 46 AC              LEA    ax, [bp - 0x54]              ; UNKNOWN
04C94A  16                    PUSH   ss                           ; UNKNOWN
04C94B  50                    PUSH   ax                           ; UNKNOWN
04C94C  9A 8F 02 13 24        LCALL  0x2413, 0x28f                ; UNKNOWN
04C951  83 C4 0A              ADD    sp, 0xa                      ; UNKNOWN
04C954  C6 46 AC 00           MOV    byte ptr [bp - 0x54], 0      ; UNKNOWN
04C958  FF 36 90 34           PUSH   word ptr [0x3490]            ; UNKNOWN
04C95C  8D 46 AC              LEA    ax, [bp - 0x54]              ; UNKNOWN
04C95F  50                    PUSH   ax                           ; UNKNOWN
04C960  9A ED 00 13 24        LCALL  0x2413, 0xed                 ; UNKNOWN
04C965  83 C4 04              ADD    sp, 4                        ; UNKNOWN
04C968  68 92 00              PUSH   0x92                         ; UNKNOWN
04C96B  6A 19                 PUSH   0x19                         ; UNKNOWN
04C96D  B8 AA 00              MOV    ax, 0xaa                     ; UNKNOWN
04C970  89 46 A8              MOV    word ptr [bp - 0x58], ax     ; UNKNOWN
04C973  50                    PUSH   ax                           ; UNKNOWN
04C974  8D 46 AC              LEA    ax, [bp - 0x54]              ; UNKNOWN
04C977  16                    PUSH   ss                           ; UNKNOWN
04C978  50                    PUSH   ax                           ; UNKNOWN
04C979  9A 8F 02 13 24        LCALL  0x2413, 0x28f                ; UNKNOWN
04C97E  83 C4 0A              ADD    sp, 0xa                      ; UNKNOWN
04C981  C6 46 AC 00           MOV    byte ptr [bp - 0x54], 0      ; UNKNOWN
04C985  FF 36 92 34           PUSH   word ptr [0x3492]            ; UNKNOWN
04C989  8D 46 AC              LEA    ax, [bp - 0x54]              ; UNKNOWN
04C98C  50                    PUSH   ax                           ; UNKNOWN
04C98D  9A ED 00 13 24        LCALL  0x2413, 0xed                 ; UNKNOWN
04C992  83 C4 04              ADD    sp, 4                        ; UNKNOWN
04C995  68 92 00              PUSH   0x92                         ; UNKNOWN
04C998  6A 19                 PUSH   0x19                         ; UNKNOWN
04C99A  B8 DC 00              MOV    ax, 0xdc                     ; UNKNOWN
04C99D  89 86 7A FF           MOV    word ptr [bp - 0x86], ax     ; UNKNOWN
04C9A1  50                    PUSH   ax                           ; UNKNOWN
04C9A2  8D 46 AC              LEA    ax, [bp - 0x54]              ; UNKNOWN
04C9A5  16                    PUSH   ss                           ; UNKNOWN
04C9A6  50                    PUSH   ax                           ; UNKNOWN
04C9A7  9A 8F 02 13 24        LCALL  0x2413, 0x28f                ; UNKNOWN
04C9AC  83 C4 0A              ADD    sp, 0xa                      ; UNKNOWN
04C9AF  C7 86 7C FF 00 00     MOV    word ptr [bp - 0x84], 0      ; UNKNOWN
04C9B5  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
04C9B9  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
04C9BD  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
04C9C1  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
04C9C5  6A 77                 PUSH   0x77                         ; UNKNOWN
04C9C7  8B 9E 7C FF           MOV    bx, word ptr [bp - 0x84]     ; UNKNOWN
04C9CB  C1 E3 03              SHL    bx, 3                        ; UNKNOWN
04C9CE  83                    DB     0x83                         ; UNKNOWN (raw)
04C9CF  C3                    DB     0xC3                         ; UNKNOWN (raw)
