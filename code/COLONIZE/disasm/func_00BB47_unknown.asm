; ============================================================================
; func_00BB47_unknown
; Region   : load_image
; Bytes    : file 0x00BB47..0x00BC44  (253 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00BB47  C8 5A 00 00           ENTER  0x5a, 0                      ; UNKNOWN
00BB4B  57                    PUSH   di                           ; UNKNOWN
00BB4C  56                    PUSH   si                           ; UNKNOWN
00BB4D  BE 01 00              MOV    si, 1                        ; UNKNOWN
00BB50  83 3E 0A 0B 00        CMP    word ptr [0xb0a], 0          ; UNKNOWN
00BB55  74 03                 JE     0xbb5a                       ; UNKNOWN
00BB57  BE 05 00              MOV    si, 5                        ; UNKNOWN
00BB5A  68 B2 1A              PUSH   0x1ab2                       ; UNKNOWN
00BB5D  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
00BB60  9A A2 03 65 5F        LCALL  0x5f65, 0x3a2                ; UNKNOWN
00BB65  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00BB68  8B F8                 MOV    di, ax                       ; UNKNOWN
00BB6A  0B FF                 OR     di, di                       ; UNKNOWN
00BB6C  75 03                 JNE    0xbb71                       ; UNKNOWN
00BB6E  E9 C0 00              JMP    0xbc31                       ; UNKNOWN
00BB71  8D 5E A6              LEA    bx, [bp - 0x5a]              ; UNKNOWN
00BB74  8B C7                 MOV    ax, di                       ; UNKNOWN
00BB76  9A 00 00 34 5B        LCALL  0x5b34, 0                    ; UNKNOWN
00BB7B  0B C0                 OR     ax, ax                       ; UNKNOWN
00BB7D  75 03                 JNE    0xbb82                       ; UNKNOWN
00BB7F  E9 AF 00              JMP    0xbc31                       ; UNKNOWN
00BB82  8D 46 A6              LEA    ax, [bp - 0x5a]              ; UNKNOWN
00BB85  50                    PUSH   ax                           ; UNKNOWN
00BB86  68 A9 1A              PUSH   0x1aa9                       ; UNKNOWN
00BB89  9A A6 07 65 5F        LCALL  0x5f65, 0x7a6                ; UNKNOWN
00BB8E  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00BB91  0B C0                 OR     ax, ax                       ; UNKNOWN
00BB93  74 06                 JE     0xbb9b                       ; UNKNOWN
00BB95  BE 02 00              MOV    si, 2                        ; UNKNOWN
00BB98  E9 96 00              JMP    0xbc31                       ; UNKNOWN
00BB9B  57                    PUSH   di                           ; UNKNOWN
00BB9C  6A 01                 PUSH   1                            ; UNKNOWN
00BB9E  6A 02                 PUSH   2                            ; UNKNOWN
00BBA0  8D 46 FA              LEA    ax, [bp - 6]                 ; UNKNOWN
00BBA3  50                    PUSH   ax                           ; UNKNOWN
00BBA4  9A F0 03 65 5F        LCALL  0x5f65, 0x3f0                ; UNKNOWN
00BBA9  83 C4 08              ADD    sp, 8                        ; UNKNOWN
00BBAC  0B C0                 OR     ax, ax                       ; UNKNOWN
00BBAE  75 02                 JNE    0xbbb2                       ; UNKNOWN
00BBB0  EB 7F                 JMP    0xbc31                       ; UNKNOWN
00BBB2  8B 16 30 0A           MOV    dx, word ptr [0xa30]         ; UNKNOWN
00BBB6  39 56 FA              CMP    word ptr [bp - 6], dx        ; UNKNOWN
00BBB9  7F DA                 JG     0xbb95                       ; UNKNOWN
00BBBB  7D 05                 JGE    0xbbc2                       ; UNKNOWN
00BBBD  BE 03 00              MOV    si, 3                        ; UNKNOWN
00BBC0  EB 6F                 JMP    0xbc31                       ; UNKNOWN
00BBC2  57                    PUSH   di                           ; UNKNOWN
00BBC3  6A 01                 PUSH   1                            ; UNKNOWN
00BBC5  6A 04                 PUSH   4                            ; UNKNOWN
00BBC7  8D 46 F6              LEA    ax, [bp - 0xa]               ; UNKNOWN
00BBCA  50                    PUSH   ax                           ; UNKNOWN
00BBCB  9A F0 03 65 5F        LCALL  0x5f65, 0x3f0                ; UNKNOWN
00BBD0  83 C4 08              ADD    sp, 8                        ; UNKNOWN
00BBD3  0B C0                 OR     ax, ax                       ; UNKNOWN
00BBD5  74 5A                 JE     0xbc31                       ; UNKNOWN
00BBD7  8B 46 F8              MOV    ax, word ptr [bp - 8]        ; UNKNOWN
00BBDA  F7 6E F6              IMUL   word ptr [bp - 0xa]          ; UNKNOWN
00BBDD  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
00BBE0  89 56 FE              MOV    word ptr [bp - 2], dx        ; UNKNOWN
00BBE3  A1 32 0B              MOV    ax, word ptr [0xb32]         ; UNKNOWN
00BBE6  0B 06 30 0B           OR     ax, word ptr [0xb30]         ; UNKNOWN
00BBEA  74 14                 JE     0xbc00                       ; UNKNOWN
00BBEC  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
00BBEF  39 06 30 0B           CMP    word ptr [0xb30], ax         ; UNKNOWN
00BBF3  75 06                 JNE    0xbbfb                       ; UNKNOWN
00BBF5  39 16 32 0B           CMP    word ptr [0xb32], dx         ; UNKNOWN
00BBF9  74 05                 JE     0xbc00                       ; UNKNOWN
00BBFB  BE 04 00              MOV    si, 4                        ; UNKNOWN
00BBFE  EB 31                 JMP    0xbc31                       ; UNKNOWN
00BC00  57                    PUSH   di                           ; UNKNOWN
00BC01  6A 01                 PUSH   1                            ; UNKNOWN
00BC03  68 8E 00              PUSH   0x8e                         ; UNKNOWN
00BC06  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
00BC09  9A F0 03 65 5F        LCALL  0x5f65, 0x3f0                ; UNKNOWN
00BC0E  83 C4 08              ADD    sp, 8                        ; UNKNOWN
00BC11  0B C0                 OR     ax, ax                       ; UNKNOWN
00BC13  74 1C                 JE     0xbc31                       ; UNKNOWN
00BC15  8B 4E 0A              MOV    cx, word ptr [bp + 0xa]      ; UNKNOWN
00BC18  0B C9                 OR     cx, cx                       ; UNKNOWN
00BC1A  74 13                 JE     0xbc2f                       ; UNKNOWN
00BC1C  57                    PUSH   di                           ; UNKNOWN
00BC1D  6A 01                 PUSH   1                            ; UNKNOWN
00BC1F  68 D0 00              PUSH   0xd0                         ; UNKNOWN
00BC22  51                    PUSH   cx                           ; UNKNOWN
00BC23  9A F0 03 65 5F        LCALL  0x5f65, 0x3f0                ; UNKNOWN
00BC28  83 C4 08              ADD    sp, 8                        ; UNKNOWN
00BC2B  0B C0                 OR     ax, ax                       ; UNKNOWN
00BC2D  74 02                 JE     0xbc31                       ; UNKNOWN
00BC2F  2B F6                 SUB    si, si                       ; UNKNOWN
00BC31  0B FF                 OR     di, di                       ; UNKNOWN
00BC33  74 09                 JE     0xbc3e                       ; UNKNOWN
00BC35  57                    PUSH   di                           ; UNKNOWN
00BC36  9A BC 02 65 5F        LCALL  0x5f65, 0x2bc                ; UNKNOWN
00BC3B  83 C4 02              ADD    sp, 2                        ; UNKNOWN
00BC3E  8B C6                 MOV    ax, si                       ; UNKNOWN
00BC40  5E                    POP    si                           ; UNKNOWN
00BC41  5F                    POP    di                           ; UNKNOWN
00BC42  C9                    LEAVE                               ; UNKNOWN
00BC43  CB                    RETF                                ; UNKNOWN
