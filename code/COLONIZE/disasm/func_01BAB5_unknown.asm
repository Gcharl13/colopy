; ============================================================================
; func_01BAB5_unknown
; Region   : load_image
; Bytes    : file 0x01BAB5..0x01BB23  (110 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

01BAB5  C8 0E 00 00           ENTER  0xe, 0                       ; UNKNOWN
01BAB9  56                    PUSH   si                           ; UNKNOWN
01BABA  C7 46 FA 01 00        MOV    word ptr [bp - 6], 1         ; UNKNOWN
01BABF  C7 46 F6 00 00        MOV    word ptr [bp - 0xa], 0       ; UNKNOWN
01BAC4  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
01BAC7  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
01BACA  9A 3A 32 5F 24        LCALL  0x245f, 0x323a               ; UNKNOWN
01BACF  83 C4 04              ADD    sp, 4                        ; UNKNOWN
01BAD2  89 46 F4              MOV    word ptr [bp - 0xc], ax      ; UNKNOWN
01BAD5  0B C0                 OR     ax, ax                       ; UNKNOWN
01BAD7  7D 4A                 JGE    0x1bb23                      ; UNKNOWN
01BAD9  83 3E A4 09 00        CMP    word ptr [0x9a4], 0          ; UNKNOWN
01BADE  75 03                 JNE    0x1bae3                      ; UNKNOWN
01BAE0  E9 12 02              JMP    0x1bcf5                      ; UNKNOWN
01BAE3  6A 01                 PUSH   1                            ; UNKNOWN
01BAE5  9A BD 00 2B 3E        LCALL  0x3e2b, 0xbd                 ; UNKNOWN
01BAEA  83 C4 02              ADD    sp, 2                        ; UNKNOWN
01BAED  6A 09                 PUSH   9                            ; UNKNOWN
01BAEF  0E                    PUSH   cs                           ; UNKNOWN
01BAF0  E8 00 E1              CALL   0x19bf3                      ; UNKNOWN
01BAF3  83 C4 02              ADD    sp, 2                        ; UNKNOWN
01BAF6  8B 5E 08              MOV    bx, word ptr [bp + 8]        ; UNKNOWN
01BAF9  D1 E3                 SHL    bx, 1                        ; UNKNOWN
01BAFB  FF B7 A1 3D           PUSH   word ptr [bx + 0x3da1]       ; UNKNOWN
01BAFF  9A A9 01 2B 3E        LCALL  0x3e2b, 0x1a9                ; UNKNOWN
01BB04  83 C4 02              ADD    sp, 2                        ; UNKNOWN
01BB07  6A 0A                 PUSH   0xa                          ; UNKNOWN
01BB09  0E                    PUSH   cs                           ; UNKNOWN
01BB0A  E8 E6 E0              CALL   0x19bf3                      ; UNKNOWN
01BB0D  83 C4 02              ADD    sp, 2                        ; UNKNOWN
01BB10  6A 00                 PUSH   0                            ; UNKNOWN
01BB12  6A 78                 PUSH   0x78                         ; UNKNOWN
01BB14  6A 03                 PUSH   3                            ; UNKNOWN
01BB16  0E                    PUSH   cs                           ; UNKNOWN
01BB17  E8 B9 E0              CALL   0x19bd3                      ; UNKNOWN
01BB1A  83 C4 06              ADD    sp, 6                        ; UNKNOWN
01BB1D  8B 46 FA              MOV    ax, word ptr [bp - 6]        ; UNKNOWN
01BB20  5E                    POP    si                           ; UNKNOWN
01BB21  C9                    LEAVE                               ; UNKNOWN
01BB22  CB                    RETF                                ; UNKNOWN
