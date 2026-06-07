; ============================================================================
; func_009B20_unknown
; Region   : load_image
; Bytes    : file 0x009B20..0x009B93  (115 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

009B20  C8 0A 00 00           ENTER  0xa, 0                       ; UNKNOWN
009B24  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1         ; UNKNOWN
009B29  83 3E 0A 0B 00        CMP    word ptr [0xb0a], 0          ; UNKNOWN
009B2E  74 05                 JE     0x9b35                       ; UNKNOWN
009B30  C7 46 FE 02 00        MOV    word ptr [bp - 2], 2         ; UNKNOWN
009B35  68 46 03              PUSH   0x346                        ; UNKNOWN
009B38  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
009B3B  9A A2 03 65 5F        LCALL  0x5f65, 0x3a2                ; UNKNOWN
009B40  83 C4 04              ADD    sp, 4                        ; UNKNOWN
009B43  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; UNKNOWN
009B46  0B C0                 OR     ax, ax                       ; UNKNOWN
009B48  75 03                 JNE    0x9b4d                       ; UNKNOWN
009B4A  E9 07 06              JMP    0xa154                       ; UNKNOWN
009B4D  8D 1E 49 03           LEA    bx, [0x349]                  ; UNKNOWN
009B51  8B 46 F6              MOV    ax, word ptr [bp - 0xa]      ; UNKNOWN
009B54  9A 3B 00 34 5B        LCALL  0x5b34, 0x3b                 ; UNKNOWN
009B59  A1 30 0A              MOV    ax, word ptr [0xa30]         ; UNKNOWN
009B5C  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
009B5F  FF 76 F6              PUSH   word ptr [bp - 0xa]          ; UNKNOWN
009B62  6A 01                 PUSH   1                            ; UNKNOWN
009B64  6A 02                 PUSH   2                            ; UNKNOWN
009B66  8D 46 FC              LEA    ax, [bp - 4]                 ; UNKNOWN
009B69  50                    PUSH   ax                           ; UNKNOWN
009B6A  9A D4 04 65 5F        LCALL  0x5f65, 0x4d4                ; UNKNOWN
009B6F  83 C4 08              ADD    sp, 8                        ; UNKNOWN
009B72  0B C0                 OR     ax, ax                       ; UNKNOWN
009B74  75 03                 JNE    0x9b79                       ; UNKNOWN
009B76  E9 DB 05              JMP    0xa154                       ; UNKNOWN
009B79  FF 76 F6              PUSH   word ptr [bp - 0xa]          ; UNKNOWN
009B7C  6A 01                 PUSH   1                            ; UNKNOWN
009B7E  6A 04                 PUSH   4                            ; UNKNOWN
009B80  68 88 82              PUSH   0x8288                       ; UNKNOWN
009B83  9A D4 04 65 5F        LCALL  0x5f65, 0x4d4                ; UNKNOWN
009B88  83 C4 08              ADD    sp, 8                        ; UNKNOWN
009B8B  0B C0                 OR     ax, ax                       ; UNKNOWN
009B8D  75 03                 JNE    0x9b92                       ; UNKNOWN
009B8F  E9 C2 05              JMP    0xa154                       ; UNKNOWN
009B92  FF                    DB     0xFF                         ; UNKNOWN (raw)
