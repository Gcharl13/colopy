; ============================================================================
; func_01A99D_unknown
; Region   : load_image
; Bytes    : file 0x01A99D..0x01A9C6  (41 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

01A99D  C8 FE 00 00           ENTER  0xfe, 0                      ; UNKNOWN
01A9A1  EB 72                 JMP    0x1aa15                      ; UNKNOWN
01A9A3  8D 46 A4              LEA    ax, [bp - 0x5c]              ; UNKNOWN
01A9A6  50                    PUSH   ax                           ; UNKNOWN
01A9A7  9A 0C 00 13 24        LCALL  0x2413, 0xc                  ; UNKNOWN
01A9AC  83 C4 02              ADD    sp, 2                        ; UNKNOWN
01A9AF  8D 46 A4              LEA    ax, [bp - 0x5c]              ; UNKNOWN
01A9B2  50                    PUSH   ax                           ; UNKNOWN
01A9B3  9A 7D 00 13 24        LCALL  0x2413, 0x7d                 ; UNKNOWN
01A9B8  83 C4 02              ADD    sp, 2                        ; UNKNOWN
01A9BB  8B B6 C8 FE           MOV    si, word ptr [bp - 0x138]    ; UNKNOWN
01A9BF  D1 E6                 SHL    si, 1                        ; UNKNOWN
01A9C1  8B B2 C2 FE           MOV    si, word ptr [bp + si - 0x13e] ; UNKNOWN
01A9C5  8A                    DB     0x8A                         ; UNKNOWN (raw)
