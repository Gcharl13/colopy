; ============================================================================
; func_00F084_unknown
; Region   : load_image
; Bytes    : file 0x00F084..0x00F0F1  (109 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00F084  C8 14 01 00           ENTER  0x114, 0                     ; UNKNOWN
00F088  68 68 1D              PUSH   0x1d68                       ; UNKNOWN
00F08B  8D 86 EC FE           LEA    ax, [bp - 0x114]             ; UNKNOWN
00F08F  50                    PUSH   ax                           ; UNKNOWN
00F090  9A 74 07 65 5F        LCALL  0x5f65, 0x774                ; UNKNOWN
00F095  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00F098  68 71 1D              PUSH   0x1d71                       ; UNKNOWN
00F09B  8D 86 EC FE           LEA    ax, [bp - 0x114]             ; UNKNOWN
00F09F  50                    PUSH   ax                           ; UNKNOWN
00F0A0  9A 34 07 65 5F        LCALL  0x5f65, 0x734                ; UNKNOWN
00F0A5  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00F0A8  83 3E 6C 04 00        CMP    word ptr [0x46c], 0          ; UNKNOWN
00F0AD  74 10                 JE     0xf0bf                       ; UNKNOWN
00F0AF  68 76 1D              PUSH   0x1d76                       ; UNKNOWN
00F0B2  8D 86 EC FE           LEA    ax, [bp - 0x114]             ; UNKNOWN
00F0B6  50                    PUSH   ax                           ; UNKNOWN
00F0B7  9A 34 07 65 5F        LCALL  0x5f65, 0x734                ; UNKNOWN
00F0BC  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00F0BF  83 3E 1A 0C 00        CMP    word ptr [0xc1a], 0          ; UNKNOWN
00F0C4  74 20                 JE     0xf0e6                       ; UNKNOWN
00F0C6  68 78 1D              PUSH   0x1d78                       ; UNKNOWN
00F0C9  8D 86 EC FE           LEA    ax, [bp - 0x114]             ; UNKNOWN
00F0CD  50                    PUSH   ax                           ; UNKNOWN
00F0CE  9A 34 07 65 5F        LCALL  0x5f65, 0x734                ; UNKNOWN
00F0D3  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00F0D6  68 46 CE              PUSH   0xce46                       ; UNKNOWN
00F0D9  8D 86 EC FE           LEA    ax, [bp - 0x114]             ; UNKNOWN
00F0DD  50                    PUSH   ax                           ; UNKNOWN
00F0DE  9A 34 07 65 5F        LCALL  0x5f65, 0x734                ; UNKNOWN
00F0E3  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00F0E6  8D 86 EC FE           LEA    ax, [bp - 0x114]             ; UNKNOWN
00F0EA  50                    PUSH   ax                           ; UNKNOWN
00F0EB  0E                    PUSH   cs                           ; UNKNOWN
00F0EC  E8 87 FD              CALL   0xee76                       ; UNKNOWN
00F0EF  C9                    LEAVE                               ; UNKNOWN
00F0F0  CB                    RETF                                ; UNKNOWN
