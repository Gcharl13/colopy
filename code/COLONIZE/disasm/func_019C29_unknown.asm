; ============================================================================
; func_019C29_unknown
; Region   : load_image
; Bytes    : file 0x019C29..0x019C65  (60 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

019C29  55                    PUSH   bp                           ; UNKNOWN
019C2A  8B EC                 MOV    bp, sp                       ; UNKNOWN
019C2C  6A 01                 PUSH   1                            ; UNKNOWN
019C2E  9A BD 00 2B 3E        LCALL  0x3e2b, 0xbd                 ; UNKNOWN
019C33  8B E5                 MOV    sp, bp                       ; UNKNOWN
019C35  83 7E 0A 00           CMP    word ptr [bp + 0xa], 0       ; UNKNOWN
019C39  74 04                 JE     0x19c3f                      ; UNKNOWN
019C3B  6A 0F                 PUSH   0xf                          ; UNKNOWN
019C3D  EB 02                 JMP    0x19c41                      ; UNKNOWN
019C3F  6A 10                 PUSH   0x10                         ; UNKNOWN
019C41  0E                    PUSH   cs                           ; UNKNOWN
019C42  E8 AE FF              CALL   0x19bf3                      ; UNKNOWN
019C45  83 C4 02              ADD    sp, 2                        ; UNKNOWN
019C48  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
019C4B  D1 E3                 SHL    bx, 1                        ; UNKNOWN
019C4D  FF B7 A1 3D           PUSH   word ptr [bx + 0x3da1]       ; UNKNOWN
019C51  9A A9 01 2B 3E        LCALL  0x3e2b, 0x1a9                ; UNKNOWN
019C56  83 C4 02              ADD    sp, 2                        ; UNKNOWN
019C59  6A 00                 PUSH   0                            ; UNKNOWN
019C5B  6A 00                 PUSH   0                            ; UNKNOWN
019C5D  6A 01                 PUSH   1                            ; UNKNOWN
019C5F  0E                    PUSH   cs                           ; UNKNOWN
019C60  E8 70 FF              CALL   0x19bd3                      ; UNKNOWN
019C63  C9                    LEAVE                               ; UNKNOWN
019C64  CB                    RETF                                ; UNKNOWN
