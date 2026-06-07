; ============================================================================
; func_01C75C_unknown
; Region   : load_image
; Bytes    : file 0x01C75C..0x01C8C3  (359 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

01C75C  C8 5A 00 00           ENTER  0x5a, 0                      ; UNKNOWN
01C760  8B 46 0A              MOV    ax, word ptr [bp + 0xa]      ; UNKNOWN
01C763  40                    INC    ax                           ; UNKNOWN
01C764  40                    INC    ax                           ; UNKNOWN
01C765  89 46 A6              MOV    word ptr [bp - 0x5a], ax     ; UNKNOWN
01C768  83 7E 0A FF           CMP    word ptr [bp + 0xa], -1      ; UNKNOWN
01C76C  75 11                 JNE    0x1c77f                      ; UNKNOWN
01C76E  50                    PUSH   ax                           ; UNKNOWN
01C76F  FF 36 A3 3B           PUSH   word ptr [0x3ba3]            ; UNKNOWN
01C773  9A 6C 00 E6 21        LCALL  0x21e6, 0x6c                 ; UNKNOWN
01C778  83 C4 02              ADD    sp, 2                        ; UNKNOWN
01C77B  52                    PUSH   dx                           ; UNKNOWN
01C77C  E9 36 01              JMP    0x1c8b5                      ; UNKNOWN
01C77F  6A 00                 PUSH   0                            ; UNKNOWN
01C781  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
01C784  9A 92 32 5F 24        LCALL  0x245f, 0x3292               ; UNKNOWN
01C789  83 C4 04              ADD    sp, 4                        ; UNKNOWN
01C78C  89 46 AA              MOV    word ptr [bp - 0x56], ax     ; UNKNOWN
01C78F  8D 46 FE              LEA    ax, [bp - 2]                 ; UNKNOWN
01C792  50                    PUSH   ax                           ; UNKNOWN
01C793  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
01C796  9A 42 33 5F 24        LCALL  0x245f, 0x3342               ; UNKNOWN
01C79B  83 C4 04              ADD    sp, 4                        ; UNKNOWN
01C79E  89 46 A8              MOV    word ptr [bp - 0x58], ax     ; UNKNOWN
01C7A1  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
01C7A4  9A E4 32 5F 24        LCALL  0x245f, 0x32e4               ; UNKNOWN
01C7A9  83 C4 02              ADD    sp, 2                        ; UNKNOWN
01C7AC  52                    PUSH   dx                           ; UNKNOWN
01C7AD  50                    PUSH   ax                           ; UNKNOWN
01C7AE  8D 46 AC              LEA    ax, [bp - 0x54]              ; UNKNOWN
01C7B1  16                    PUSH   ss                           ; UNKNOWN
01C7B2  50                    PUSH   ax                           ; UNKNOWN
01C7B3  9A 8A 14 65 5F        LCALL  0x5f65, 0x148a               ; UNKNOWN
01C7B8  83 C4 08              ADD    sp, 8                        ; UNKNOWN
01C7BB  8D 46 AC              LEA    ax, [bp - 0x54]              ; UNKNOWN
01C7BE  50                    PUSH   ax                           ; UNKNOWN
01C7BF  9A 9E 0D 65 5F        LCALL  0x5f65, 0xd9e                ; UNKNOWN
01C7C4  83 C4 02              ADD    sp, 2                        ; UNKNOWN
01C7C7  8D 46 AC              LEA    ax, [bp - 0x54]              ; UNKNOWN
01C7CA  50                    PUSH   ax                           ; UNKNOWN
01C7CB  9A 0C 00 13 24        LCALL  0x2413, 0xc                  ; UNKNOWN
01C7D0  83 C4 02              ADD    sp, 2                        ; UNKNOWN
01C7D3  68 3D 17              PUSH   0x173d                       ; UNKNOWN
01C7D6  8D 46 AC              LEA    ax, [bp - 0x54]              ; UNKNOWN
01C7D9  50                    PUSH   ax                           ; UNKNOWN
01C7DA  9A 34 07 65 5F        LCALL  0x5f65, 0x734                ; UNKNOWN
01C7DF  83 C4 04              ADD    sp, 4                        ; UNKNOWN
01C7E2  8D 46 AC              LEA    ax, [bp - 0x54]              ; UNKNOWN
01C7E5  50                    PUSH   ax                           ; UNKNOWN
01C7E6  9A 7D 00 13 24        LCALL  0x2413, 0x7d                 ; UNKNOWN
01C7EB  83 C4 02              ADD    sp, 2                        ; UNKNOWN
01C7EE  8B 46 A8              MOV    ax, word ptr [bp - 0x58]     ; UNKNOWN
01C7F1  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
01C7F5  2B 87 92 00           SUB    ax, word ptr [bx + 0x92]     ; UNKNOWN
01C7F9  79 02                 JNS    0x1c7fd                      ; UNKNOWN
01C7FB  2B C0                 SUB    ax, ax                       ; UNKNOWN
01C7FD  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
01C800  83 7E AA 01           CMP    word ptr [bp - 0x56], 1      ; UNKNOWN
01C804  75 26                 JNE    0x1c82c                      ; UNKNOWN
01C806  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
01C809  9A 88 03 5F 24        LCALL  0x245f, 0x388                ; UNKNOWN
01C80E  83 C4 02              ADD    sp, 2                        ; UNKNOWN
01C811  0B C0                 OR     ax, ax                       ; UNKNOWN
01C813  74 17                 JE     0x1c82c                      ; UNKNOWN
01C815  FF 36 F8 33           PUSH   word ptr [0x33f8]            ; UNKNOWN
01C819  8D 46 AC              LEA    ax, [bp - 0x54]              ; UNKNOWN
01C81C  50                    PUSH   ax                           ; UNKNOWN
01C81D  9A ED 00 13 24        LCALL  0x2413, 0xed                 ; UNKNOWN
01C822  83 C4 04              ADD    sp, 4                        ; UNKNOWN
01C825  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
01C82A  EB 2C                 JMP    0x1c858                      ; UNKNOWN
01C82C  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
01C82F  8D 46 AC              LEA    ax, [bp - 0x54]              ; UNKNOWN
01C832  16                    PUSH   ss                           ; UNKNOWN
01C833  50                    PUSH   ax                           ; UNKNOWN
01C834  9A 38 01 13 24        LCALL  0x2413, 0x138                ; UNKNOWN
01C839  83 C4 06              ADD    sp, 6                        ; UNKNOWN
01C83C  8D 46 AC              LEA    ax, [bp - 0x54]              ; UNKNOWN
01C83F  50                    PUSH   ax                           ; UNKNOWN
01C840  9A 0C 00 13 24        LCALL  0x2413, 0xc                  ; UNKNOWN
01C845  83 C4 02              ADD    sp, 2                        ; UNKNOWN
01C848  FF 36 C1 3D           PUSH   word ptr [0x3dc1]            ; UNKNOWN
01C84C  8D 46 AC              LEA    ax, [bp - 0x54]              ; UNKNOWN
01C84F  50                    PUSH   ax                           ; UNKNOWN
01C850  9A ED 00 13 24        LCALL  0x2413, 0xed                 ; UNKNOWN
01C855  83 C4 04              ADD    sp, 4                        ; UNKNOWN
01C858  8D 46 AC              LEA    ax, [bp - 0x54]              ; UNKNOWN
01C85B  50                    PUSH   ax                           ; UNKNOWN
01C85C  9A 8D 00 13 24        LCALL  0x2413, 0x8d                 ; UNKNOWN
01C861  83 C4 02              ADD    sp, 2                        ; UNKNOWN
01C864  83 7E FE 00           CMP    word ptr [bp - 2], 0         ; UNKNOWN
01C868  74 44                 JE     0x1c8ae                      ; UNKNOWN
01C86A  8D 46 AC              LEA    ax, [bp - 0x54]              ; UNKNOWN
01C86D  50                    PUSH   ax                           ; UNKNOWN
01C86E  9A 7D 00 13 24        LCALL  0x2413, 0x7d                 ; UNKNOWN
01C873  83 C4 02              ADD    sp, 2                        ; UNKNOWN
01C876  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
01C879  8D 46 AC              LEA    ax, [bp - 0x54]              ; UNKNOWN
01C87C  16                    PUSH   ss                           ; UNKNOWN
01C87D  50                    PUSH   ax                           ; UNKNOWN
01C87E  9A 38 01 13 24        LCALL  0x2413, 0x138                ; UNKNOWN
01C883  83 C4 06              ADD    sp, 6                        ; UNKNOWN
01C886  8D 46 AC              LEA    ax, [bp - 0x54]              ; UNKNOWN
01C889  50                    PUSH   ax                           ; UNKNOWN
01C88A  9A 0C 00 13 24        LCALL  0x2413, 0xc                  ; UNKNOWN
01C88F  83 C4 02              ADD    sp, 2                        ; UNKNOWN
01C892  FF 36 BD 3D           PUSH   word ptr [0x3dbd]            ; UNKNOWN
01C896  8D 46 AC              LEA    ax, [bp - 0x54]              ; UNKNOWN
01C899  50                    PUSH   ax                           ; UNKNOWN
01C89A  9A ED 00 13 24        LCALL  0x2413, 0xed                 ; UNKNOWN
01C89F  83 C4 04              ADD    sp, 4                        ; UNKNOWN
01C8A2  8D 46 AC              LEA    ax, [bp - 0x54]              ; UNKNOWN
01C8A5  50                    PUSH   ax                           ; UNKNOWN
01C8A6  9A 8D 00 13 24        LCALL  0x2413, 0x8d                 ; UNKNOWN
01C8AB  83 C4 02              ADD    sp, 2                        ; UNKNOWN
01C8AE  FF 76 A6              PUSH   word ptr [bp - 0x5a]         ; UNKNOWN
01C8B1  8D 46 AC              LEA    ax, [bp - 0x54]              ; UNKNOWN
01C8B4  16                    PUSH   ss                           ; UNKNOWN
01C8B5  50                    PUSH   ax                           ; UNKNOWN
01C8B6  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
01C8B9  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
01C8BC  9A E6 09 97 1B        LCALL  0x1b97, 0x9e6                ; UNKNOWN
01C8C1  C9                    LEAVE                               ; UNKNOWN
01C8C2  CB                    RETF                                ; UNKNOWN
