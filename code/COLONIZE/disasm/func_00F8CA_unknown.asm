; ============================================================================
; func_00F8CA_unknown
; Region   : load_image
; Bytes    : file 0x00F8CA..0x00F984  (186 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00F8CA  C8 A6 00 00           ENTER  0xa6, 0                      ; UNKNOWN
00F8CE  C7 86 5E FF 01 00     MOV    word ptr [bp - 0xa2], 1      ; UNKNOWN
00F8D4  68 24 07              PUSH   0x724                        ; UNKNOWN
00F8D7  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
00F8DA  50                    PUSH   ax                           ; UNKNOWN
00F8DB  9A 74 07 65 5F        LCALL  0x5f65, 0x774                ; UNKNOWN
00F8E0  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00F8E3  68 CC 06              PUSH   0x6cc                        ; UNKNOWN
00F8E6  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
00F8E9  50                    PUSH   ax                           ; UNKNOWN
00F8EA  9A 34 07 65 5F        LCALL  0x5f65, 0x734                ; UNKNOWN
00F8EF  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00F8F2  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
00F8F5  16                    PUSH   ss                           ; UNKNOWN
00F8F6  50                    PUSH   ax                           ; UNKNOWN
00F8F7  8D 86 60 FF           LEA    ax, [bp - 0xa0]              ; UNKNOWN
00F8FB  16                    PUSH   ss                           ; UNKNOWN
00F8FC  50                    PUSH   ax                           ; UNKNOWN
00F8FD  E8 86 FC              CALL   0xf586                       ; UNKNOWN
00F900  83 C4 08              ADD    sp, 8                        ; UNKNOWN
00F903  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
00F906  50                    PUSH   ax                           ; UNKNOWN
00F907  8D 86 60 FF           LEA    ax, [bp - 0xa0]              ; UNKNOWN
00F90B  50                    PUSH   ax                           ; UNKNOWN
00F90C  68 26 07              PUSH   0x726                        ; UNKNOWN
00F90F  68 86 09              PUSH   0x986                        ; UNKNOWN
00F912  9A EA 17 B2 00        LCALL  0xb2, 0x17ea                 ; UNKNOWN
00F917  83 C4 08              ADD    sp, 8                        ; UNKNOWN
00F91A  0B C0                 OR     ax, ax                       ; UNKNOWN
00F91C  7D 03                 JGE    0xf921                       ; UNKNOWN
00F91E  E9 AC 00              JMP    0xf9cd                       ; UNKNOWN
00F921  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
00F924  16                    PUSH   ss                           ; UNKNOWN
00F925  50                    PUSH   ax                           ; UNKNOWN
00F926  8D 8E 60 FF           LEA    cx, [bp - 0xa0]              ; UNKNOWN
00F92A  16                    PUSH   ss                           ; UNKNOWN
00F92B  51                    PUSH   cx                           ; UNKNOWN
00F92C  E8 57 FC              CALL   0xf586                       ; UNKNOWN
00F92F  83 C4 08              ADD    sp, 8                        ; UNKNOWN
00F932  8D 86 60 FF           LEA    ax, [bp - 0xa0]              ; UNKNOWN
00F936  50                    PUSH   ax                           ; UNKNOWN
00F937  9A 5A 06 B2 00        LCALL  0xb2, 0x65a                  ; UNKNOWN
00F93C  83 C4 02              ADD    sp, 2                        ; UNKNOWN
00F93F  89 86 5C FF           MOV    word ptr [bp - 0xa4], ax     ; UNKNOWN
00F943  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
00F946  16                    PUSH   ss                           ; UNKNOWN
00F947  50                    PUSH   ax                           ; UNKNOWN
00F948  1E                    PUSH   ds                           ; UNKNOWN
00F949  68 40 3F              PUSH   0x3f40                       ; UNKNOWN
00F94C  9A 8A 14 65 5F        LCALL  0x5f65, 0x148a               ; UNKNOWN
00F951  83 C4 08              ADD    sp, 8                        ; UNKNOWN
00F954  8B 86 5C FF           MOV    ax, word ptr [bp - 0xa4]     ; UNKNOWN
00F958  0B C0                 OR     ax, ax                       ; UNKNOWN
00F95A  74 28                 JE     0xf984                       ; UNKNOWN
00F95C  48                    DEC    ax                           ; UNKNOWN
00F95D  48                    DEC    ax                           ; UNKNOWN
00F95E  74 40                 JE     0xf9a0                       ; UNKNOWN
00F960  48                    DEC    ax                           ; UNKNOWN
00F961  74 47                 JE     0xf9aa                       ; UNKNOWN
00F963  48                    DEC    ax                           ; UNKNOWN
00F964  74 4E                 JE     0xf9b4                       ; UNKNOWN
00F966  48                    DEC    ax                           ; UNKNOWN
00F967  74 55                 JE     0xf9be                       ; UNKNOWN
00F969  8D 1E 86 09           LEA    bx, [0x986]                  ; UNKNOWN
00F96D  8D 06 59 07           LEA    ax, [0x759]                  ; UNKNOWN
00F971  2B D2                 SUB    dx, dx                       ; UNKNOWN
00F973  9A 6F 36 97 1B        LCALL  0x1b97, 0x366f               ; UNKNOWN
00F978  C7 86 5E FF 02 00     MOV    word ptr [bp - 0xa2], 2      ; UNKNOWN
00F97E  8B 86 5E FF           MOV    ax, word ptr [bp - 0xa2]     ; UNKNOWN
00F982  C9                    LEAVE                               ; UNKNOWN
00F983  CB                    RETF                                ; UNKNOWN
