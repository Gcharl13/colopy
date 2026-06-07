; ============================================================================
; func_02D28F_unknown
; Region   : load_image
; Bytes    : file 0x02D28F..0x02D2F7  (104 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02D28F  C8 18 00 00           ENTER  0x18, 0                      ; UNKNOWN
02D293  57                    PUSH   di                           ; UNKNOWN
02D294  56                    PUSH   si                           ; UNKNOWN
02D295  6A 02                 PUSH   2                            ; UNKNOWN
02D297  8D 46 E8              LEA    ax, [bp - 0x18]              ; UNKNOWN
02D29A  50                    PUSH   ax                           ; UNKNOWN
02D29B  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
02D29E  9A 8A 08 65 5F        LCALL  0x5f65, 0x88a                ; UNKNOWN
02D2A3  83 C4 06              ADD    sp, 6                        ; UNKNOWN
02D2A6  C7 46 FC 00 00        MOV    word ptr [bp - 4], 0         ; UNKNOWN
02D2AB  8D 46 E8              LEA    ax, [bp - 0x18]              ; UNKNOWN
02D2AE  50                    PUSH   ax                           ; UNKNOWN
02D2AF  9A D2 07 65 5F        LCALL  0x5f65, 0x7d2                ; UNKNOWN
02D2B4  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02D2B7  8B F8                 MOV    di, ax                       ; UNKNOWN
02D2B9  B8 08 00              MOV    ax, 8                        ; UNKNOWN
02D2BC  2B C7                 SUB    ax, di                       ; UNKNOWN
02D2BE  0B C0                 OR     ax, ax                       ; UNKNOWN
02D2C0  7E 1E                 JLE    0x2d2e0                      ; UNKNOWN
02D2C2  BE 08 00              MOV    si, 8                        ; UNKNOWN
02D2C5  2B F7                 SUB    si, di                       ; UNKNOWN
02D2C7  89 7E FE              MOV    word ptr [bp - 2], di        ; UNKNOWN
02D2CA  8B 7E 06              MOV    di, word ptr [bp + 6]        ; UNKNOWN
02D2CD  1E                    PUSH   ds                           ; UNKNOWN
02D2CE  68 36 1E              PUSH   0x1e36                       ; UNKNOWN
02D2D1  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
02D2D4  57                    PUSH   di                           ; UNKNOWN
02D2D5  9A C0 14 65 5F        LCALL  0x5f65, 0x14c0               ; UNKNOWN
02D2DA  83 C4 08              ADD    sp, 8                        ; UNKNOWN
02D2DD  4E                    DEC    si                           ; UNKNOWN
02D2DE  75 ED                 JNE    0x2d2cd                      ; UNKNOWN
02D2E0  8D 46 E8              LEA    ax, [bp - 0x18]              ; UNKNOWN
02D2E3  16                    PUSH   ss                           ; UNKNOWN
02D2E4  50                    PUSH   ax                           ; UNKNOWN
02D2E5  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
02D2E8  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
02D2EB  9A C0 14 65 5F        LCALL  0x5f65, 0x14c0               ; UNKNOWN
02D2F0  83 C4 08              ADD    sp, 8                        ; UNKNOWN
02D2F3  5E                    POP    si                           ; UNKNOWN
02D2F4  5F                    POP    di                           ; UNKNOWN
02D2F5  C9                    LEAVE                               ; UNKNOWN
02D2F6  CB                    RETF                                ; UNKNOWN
