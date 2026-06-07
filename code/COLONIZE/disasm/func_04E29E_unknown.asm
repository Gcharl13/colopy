; ============================================================================
; func_04E29E_unknown
; Region   : load_image
; Bytes    : file 0x04E29E..0x04E2D3  (53 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04E29E  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
04E2A2  56                    PUSH   si                           ; UNKNOWN
04E2A3  BE 01 00              MOV    si, 1                        ; UNKNOWN
04E2A6  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
04E2A9  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
04E2AC  0E                    PUSH   cs                           ; UNKNOWN
04E2AD  E8 04 FE              CALL   0x4e0b4                      ; UNKNOWN
04E2B0  83 C4 04              ADD    sp, 4                        ; UNKNOWN
04E2B3  0B C0                 OR     ax, ax                       ; UNKNOWN
04E2B5  75 13                 JNE    0x4e2ca                      ; UNKNOWN
04E2B7  8B 5E 0A              MOV    bx, word ptr [bp + 0xa]      ; UNKNOWN
04E2BA  0B DB                 OR     bx, bx                       ; UNKNOWN
04E2BC  7C 0A                 JL     0x4e2c8                      ; UNKNOWN
04E2BE  8D 77 01              LEA    si, [bx + 1]                 ; UNKNOWN
04E2C1  0E                    PUSH   cs                           ; UNKNOWN
04E2C2  E8 DA FE              CALL   0x4e19f                      ; UNKNOWN
04E2C5  4E                    DEC    si                           ; UNKNOWN
04E2C6  75 F9                 JNE    0x4e2c1                      ; UNKNOWN
04E2C8  2B F6                 SUB    si, si                       ; UNKNOWN
04E2CA  0E                    PUSH   cs                           ; UNKNOWN
04E2CB  E8 CC FD              CALL   0x4e09a                      ; UNKNOWN
04E2CE  8B C6                 MOV    ax, si                       ; UNKNOWN
04E2D0  5E                    POP    si                           ; UNKNOWN
04E2D1  C9                    LEAVE                               ; UNKNOWN
04E2D2  CB                    RETF                                ; UNKNOWN
