; ============================================================================
; func_03831D_unknown
; Region   : load_image
; Bytes    : file 0x03831D..0x03835A  (61 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03831D  C8 0A 00 00           ENTER  0xa, 0                       ; UNKNOWN
038321  56                    PUSH   si                           ; UNKNOWN
038322  9A FB 01 E4 35        LCALL  0x35e4, 0x1fb                ; UNKNOWN
038327  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
03832A  0E                    PUSH   cs                           ; UNKNOWN
03832B  E8 F6 AA              CALL   0x32e24                      ; UNKNOWN
03832E  83 C4 02              ADD    sp, 2                        ; UNKNOWN
038331  6A 00                 PUSH   0                            ; UNKNOWN
038333  9A BD 00 2B 3E        LCALL  0x3e2b, 0xbd                 ; UNKNOWN
038338  83 C4 02              ADD    sp, 2                        ; UNKNOWN
03833B  6A 07                 PUSH   7                            ; UNKNOWN
03833D  68 40 01              PUSH   0x140                        ; UNKNOWN
038340  6A 00                 PUSH   0                            ; UNKNOWN
038342  6A 00                 PUSH   0                            ; UNKNOWN
038344  9A B3 02 2B 3E        LCALL  0x3e2b, 0x2b3                ; UNKNOWN
038349  83 C4 08              ADD    sp, 8                        ; UNKNOWN
03834C  C7 06 A6 09 01 00     MOV    word ptr [0x9a6], 1          ; UNKNOWN
038352  0E                    PUSH   cs                           ; UNKNOWN
038353  E8 30 B3              CALL   0x33686                      ; UNKNOWN
038356  0E                    PUSH   cs                           ; UNKNOWN
038357  E8 A2 C3              CALL   0x346fc                      ; UNKNOWN
