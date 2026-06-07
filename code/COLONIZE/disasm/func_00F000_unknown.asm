; ============================================================================
; func_00F000_unknown
; Region   : load_image
; Bytes    : file 0x00F000..0x00F084  (132 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00F000  C8 14 01 00           ENTER  0x114, 0                     ; UNKNOWN
00F004  68 53 1D              PUSH   0x1d53                       ; UNKNOWN
00F007  8D 86 EC FE           LEA    ax, [bp - 0x114]             ; UNKNOWN
00F00B  50                    PUSH   ax                           ; UNKNOWN
00F00C  9A 74 07 65 5F        LCALL  0x5f65, 0x774                ; UNKNOWN
00F011  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00F014  68 5C 1D              PUSH   0x1d5c                       ; UNKNOWN
00F017  8D 86 EC FE           LEA    ax, [bp - 0x114]             ; UNKNOWN
00F01B  50                    PUSH   ax                           ; UNKNOWN
00F01C  9A 34 07 65 5F        LCALL  0x5f65, 0x734                ; UNKNOWN
00F021  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00F024  83 3E 6C 04 00        CMP    word ptr [0x46c], 0          ; UNKNOWN
00F029  74 10                 JE     0xf03b                       ; UNKNOWN
00F02B  68 5F 1D              PUSH   0x1d5f                       ; UNKNOWN
00F02E  8D 86 EC FE           LEA    ax, [bp - 0x114]             ; UNKNOWN
00F032  50                    PUSH   ax                           ; UNKNOWN
00F033  9A 34 07 65 5F        LCALL  0x5f65, 0x734                ; UNKNOWN
00F038  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00F03B  80 3E A0 09 00        CMP    byte ptr [0x9a0], 0          ; UNKNOWN
00F040  74 10                 JE     0xf052                       ; UNKNOWN
00F042  68 61 1D              PUSH   0x1d61                       ; UNKNOWN
00F045  8D 86 EC FE           LEA    ax, [bp - 0x114]             ; UNKNOWN
00F049  50                    PUSH   ax                           ; UNKNOWN
00F04A  9A 34 07 65 5F        LCALL  0x5f65, 0x734                ; UNKNOWN
00F04F  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00F052  83 3E 1A 0C 00        CMP    word ptr [0xc1a], 0          ; UNKNOWN
00F057  74 20                 JE     0xf079                       ; UNKNOWN
00F059  68 63 1D              PUSH   0x1d63                       ; UNKNOWN
00F05C  8D 86 EC FE           LEA    ax, [bp - 0x114]             ; UNKNOWN
00F060  50                    PUSH   ax                           ; UNKNOWN
00F061  9A 34 07 65 5F        LCALL  0x5f65, 0x734                ; UNKNOWN
00F066  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00F069  68 46 CE              PUSH   0xce46                       ; UNKNOWN
00F06C  8D 86 EC FE           LEA    ax, [bp - 0x114]             ; UNKNOWN
00F070  50                    PUSH   ax                           ; UNKNOWN
00F071  9A 34 07 65 5F        LCALL  0x5f65, 0x734                ; UNKNOWN
00F076  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00F079  8D 86 EC FE           LEA    ax, [bp - 0x114]             ; UNKNOWN
00F07D  50                    PUSH   ax                           ; UNKNOWN
00F07E  0E                    PUSH   cs                           ; UNKNOWN
00F07F  E8 F4 FD              CALL   0xee76                       ; UNKNOWN
00F082  C9                    LEAVE                               ; UNKNOWN
00F083  CB                    RETF                                ; UNKNOWN
