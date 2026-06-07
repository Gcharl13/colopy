; ============================================================================
; func_063E5A_unknown
; Region   : load_image
; Bytes    : file 0x063E5A..0x063E96  (60 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

063E5A  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
063E5E  50                    PUSH   ax                           ; UNKNOWN
063E5F  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
063E62  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
063E65  9A 48 14 65 5F        LCALL  0x5f65, 0x1448               ; UNKNOWN
063E6A  83 C4 04              ADD    sp, 4                        ; UNKNOWN
063E6D  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
063E70  1E                    PUSH   ds                           ; UNKNOWN
063E71  8B 4E FE              MOV    cx, word ptr [bp - 2]        ; UNKNOWN
063E74  BB 01 00              MOV    bx, 1                        ; UNKNOWN
063E77  C5 56 06              LDS    dx, ptr [bp + 6]             ; UNKNOWN
063E7A  B4 40                 MOV    ah, 0x40                     ; UNKNOWN
063E7C  CD 21                 INT    0x21                         ; UNKNOWN
063E7E  1F                    POP    ds                           ; UNKNOWN
063E7F  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
063E82  0B C0                 OR     ax, ax                       ; UNKNOWN
063E84  74 0C                 JE     0x63e92                      ; UNKNOWN
063E86  B2 0A                 MOV    dl, 0xa                      ; UNKNOWN
063E88  B4 02                 MOV    ah, 2                        ; UNKNOWN
063E8A  CD 21                 INT    0x21                         ; UNKNOWN
063E8C  B2 0D                 MOV    dl, 0xd                      ; UNKNOWN
063E8E  B4 02                 MOV    ah, 2                        ; UNKNOWN
063E90  CD 21                 INT    0x21                         ; UNKNOWN
063E92  C9                    LEAVE                               ; UNKNOWN
063E93  CA 04 00              RETF   4                            ; UNKNOWN
