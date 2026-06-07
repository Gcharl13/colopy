; ============================================================================
; func_04B774_unknown
; Region   : load_image
; Bytes    : file 0x04B774..0x04B82C  (184 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04B774  C8 2C 00 00           ENTER  0x2c, 0                      ; UNKNOWN
04B778  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
04B77B  9A 04 00 E2 29        LCALL  0x29e2, 4                    ; UNKNOWN
04B780  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04B783  6A 02                 PUSH   2                            ; UNKNOWN
04B785  0E                    PUSH   cs                           ; UNKNOWN
04B786  E8 D9 F9              CALL   0x4b162                      ; UNKNOWN
04B789  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04B78C  68 90 00              PUSH   0x90                         ; UNKNOWN
04B78F  6A 05                 PUSH   5                            ; UNKNOWN
04B791  68 40 01              PUSH   0x140                        ; UNKNOWN
04B794  6A 00                 PUSH   0                            ; UNKNOWN
04B796  FF 36 36 33           PUSH   word ptr [0x3336]            ; UNKNOWN
04B79A  9A 6C 00 E6 21        LCALL  0x21e6, 0x6c                 ; UNKNOWN
04B79F  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04B7A2  52                    PUSH   dx                           ; UNKNOWN
04B7A3  50                    PUSH   ax                           ; UNKNOWN
04B7A4  9A 1E 03 13 24        LCALL  0x2413, 0x31e                ; UNKNOWN
04B7A9  83 C4 0C              ADD    sp, 0xc                      ; UNKNOWN
04B7AC  B8 0A 00              MOV    ax, 0xa                      ; UNKNOWN
04B7AF  89 46 D6              MOV    word ptr [bp - 0x2a], ax     ; UNKNOWN
04B7B2  50                    PUSH   ax                           ; UNKNOWN
04B7B3  B8 19 00              MOV    ax, 0x19                     ; UNKNOWN
04B7B6  89 46 D4              MOV    word ptr [bp - 0x2c], ax     ; UNKNOWN
04B7B9  50                    PUSH   ax                           ; UNKNOWN
04B7BA  68 2C 01              PUSH   0x12c                        ; UNKNOWN
04B7BD  6A 00                 PUSH   0                            ; UNKNOWN
04B7BF  6A 00                 PUSH   0                            ; UNKNOWN
04B7C1  6A 01                 PUSH   1                            ; UNKNOWN
04B7C3  8B 1E A8 74           MOV    bx, word ptr [0x74a8]        ; UNKNOWN
04B7C7  8B 57 30              MOV    dx, word ptr [bx + 0x30]     ; UNKNOWN
04B7CA  8B 5F 2E              MOV    bx, word ptr [bx + 0x2e]     ; UNKNOWN
04B7CD  B8 39 00              MOV    ax, 0x39                     ; UNKNOWN
04B7D0  9A 70 01 D0 38        LCALL  0x38d0, 0x170                ; UNKNOWN
04B7D5  F6 06 FB 3D 20        TEST   byte ptr [0x3dfb], 0x20      ; UNKNOWN
04B7DA  74 2C                 JE     0x4b808                      ; UNKNOWN
04B7DC  8B 1E A8 74           MOV    bx, word ptr [0x74a8]        ; UNKNOWN
04B7E0  FF 77 30              PUSH   word ptr [bx + 0x30]         ; UNKNOWN
04B7E3  FF 77 2E              PUSH   word ptr [bx + 0x2e]         ; UNKNOWN
04B7E6  68 97 29              PUSH   0x2997                       ; UNKNOWN
04B7E9  8D 46 D8              LEA    ax, [bp - 0x28]              ; UNKNOWN
04B7EC  50                    PUSH   ax                           ; UNKNOWN
04B7ED  9A CC 0A 65 5F        LCALL  0x5f65, 0xacc                ; UNKNOWN
04B7F2  83 C4 08              ADD    sp, 8                        ; UNKNOWN
04B7F5  6A 0F                 PUSH   0xf                          ; UNKNOWN
04B7F7  6A 19                 PUSH   0x19                         ; UNKNOWN
04B7F9  6A 0A                 PUSH   0xa                          ; UNKNOWN
04B7FB  8D 46 D8              LEA    ax, [bp - 0x28]              ; UNKNOWN
04B7FE  16                    PUSH   ss                           ; UNKNOWN
04B7FF  50                    PUSH   ax                           ; UNKNOWN
04B800  9A 8F 02 13 24        LCALL  0x2413, 0x28f                ; UNKNOWN
04B805  83 C4 0A              ADD    sp, 0xa                      ; UNKNOWN
04B808  6A FF                 PUSH   -1                           ; UNKNOWN
04B80A  6A FE                 PUSH   -2                           ; UNKNOWN
04B80C  0E                    PUSH   cs                           ; UNKNOWN
04B80D  E8 DB F9              CALL   0x4b1eb                      ; UNKNOWN
04B810  83 C4 04              ADD    sp, 4                        ; UNKNOWN
04B813  6A 00                 PUSH   0                            ; UNKNOWN
04B815  68 40 01              PUSH   0x140                        ; UNKNOWN
04B818  68 C8 00              PUSH   0xc8                         ; UNKNOWN
04B81B  2B C0                 SUB    ax, ax                       ; UNKNOWN
04B81D  99                    CDQ                                 ; UNKNOWN
04B81E  2B DB                 SUB    bx, bx                       ; UNKNOWN
04B820  9A 3B 00 B4 5C        LCALL  0x5cb4, 0x3b                 ; UNKNOWN
04B825  9A 6B 00 EF 21        LCALL  0x21ef, 0x6b                 ; UNKNOWN
04B82A  C9                    LEAVE                               ; UNKNOWN
04B82B  CB                    RETF                                ; UNKNOWN
