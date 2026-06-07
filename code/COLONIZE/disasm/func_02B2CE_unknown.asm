; ============================================================================
; func_02B2CE_unknown
; Region   : load_image
; Bytes    : file 0x02B2CE..0x02B30C  (62 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02B2CE  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
02B2D2  C7 06 00 CE 00 00     MOV    word ptr [0xce00], 0         ; UNKNOWN
02B2D8  1E                    PUSH   ds                           ; UNKNOWN
02B2D9  68 17 1D              PUSH   0x1d17                       ; UNKNOWN
02B2DC  8D 1E 14 1D           LEA    bx, [0x1d14]                 ; UNKNOWN
02B2E0  9A FC 00 E9 5A        LCALL  0x5ae9, 0xfc                 ; UNKNOWN
02B2E5  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
02B2E8  0B C0                 OR     ax, ax                       ; UNKNOWN
02B2EA  74 10                 JE     0x2b2fc                      ; UNKNOWN
02B2EC  50                    PUSH   ax                           ; UNKNOWN
02B2ED  6A 01                 PUSH   1                            ; UNKNOWN
02B2EF  6A 22                 PUSH   0x22                         ; UNKNOWN
02B2F1  68 00 CE              PUSH   0xce00                       ; UNKNOWN
02B2F4  9A F0 03 65 5F        LCALL  0x5f65, 0x3f0                ; UNKNOWN
02B2F9  83 C4 08              ADD    sp, 8                        ; UNKNOWN
02B2FC  83 7E FE 00           CMP    word ptr [bp - 2], 0         ; UNKNOWN
02B300  74 08                 JE     0x2b30a                      ; UNKNOWN
02B302  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
02B305  9A BC 02 65 5F        LCALL  0x5f65, 0x2bc                ; UNKNOWN
02B30A  C9                    LEAVE                               ; UNKNOWN
02B30B  CB                    RETF                                ; UNKNOWN
