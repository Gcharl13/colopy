; ============================================================================
; func_00FA74_unknown
; Region   : load_image
; Bytes    : file 0x00FA74..0x00FAC6  (82 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00FA74  C8 52 00 00           ENTER  0x52, 0                      ; UNKNOWN
00FA78  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
00FA7B  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
00FA7E  50                    PUSH   ax                           ; UNKNOWN
00FA7F  9A 74 07 65 5F        LCALL  0x5f65, 0x774                ; UNKNOWN
00FA84  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00FA87  68 66 07              PUSH   0x766                        ; UNKNOWN
00FA8A  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
00FA8D  50                    PUSH   ax                           ; UNKNOWN
00FA8E  9A 34 07 65 5F        LCALL  0x5f65, 0x734                ; UNKNOWN
00FA93  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00FA96  68 71 07              PUSH   0x771                        ; UNKNOWN
00FA99  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
00FA9C  50                    PUSH   ax                           ; UNKNOWN
00FA9D  9A A2 03 65 5F        LCALL  0x5f65, 0x3a2                ; UNKNOWN
00FAA2  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00FAA5  89 46 AE              MOV    word ptr [bp - 0x52], ax     ; UNKNOWN
00FAA8  0B C0                 OR     ax, ax                       ; UNKNOWN
00FAAA  74 1A                 JE     0xfac6                       ; UNKNOWN
00FAAC  50                    PUSH   ax                           ; UNKNOWN
00FAAD  9A BC 02 65 5F        LCALL  0x5f65, 0x2bc                ; UNKNOWN
00FAB2  83 C4 02              ADD    sp, 2                        ; UNKNOWN
00FAB5  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
00FAB8  50                    PUSH   ax                           ; UNKNOWN
00FAB9  9A 22 11 65 5F        LCALL  0x5f65, 0x1122               ; UNKNOWN
00FABE  83 C4 02              ADD    sp, 2                        ; UNKNOWN
00FAC1  B8 01 00              MOV    ax, 1                        ; UNKNOWN
00FAC4  C9                    LEAVE                               ; UNKNOWN
00FAC5  CB                    RETF                                ; UNKNOWN
