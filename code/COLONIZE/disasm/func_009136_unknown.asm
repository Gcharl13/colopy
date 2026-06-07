; ============================================================================
; func_009136_unknown
; Region   : load_image
; Bytes    : file 0x009136..0x009194  (94 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

009136  C8 02 01 00           ENTER  0x102, 0                     ; UNKNOWN
00913A  56                    PUSH   si                           ; UNKNOWN
00913B  83 3E 68 00 00        CMP    word ptr [0x68], 0           ; UNKNOWN
009140  7C 4F                 JL     0x9191                       ; UNKNOWN
009142  FF 36 6A 00           PUSH   word ptr [0x6a]              ; UNKNOWN
009146  8D 86 FE FE           LEA    ax, [bp - 0x102]             ; UNKNOWN
00914A  50                    PUSH   ax                           ; UNKNOWN
00914B  9A 74 07 65 5F        LCALL  0x5f65, 0x774                ; UNKNOWN
009150  83 C4 04              ADD    sp, 4                        ; UNKNOWN
009153  68 7E 00              PUSH   0x7e                         ; UNKNOWN
009156  8D 86 FE FE           LEA    ax, [bp - 0x102]             ; UNKNOWN
00915A  50                    PUSH   ax                           ; UNKNOWN
00915B  9A 34 07 65 5F        LCALL  0x5f65, 0x734                ; UNKNOWN
009160  83 C4 04              ADD    sp, 4                        ; UNKNOWN
009163  8D 46 08              LEA    ax, [bp + 8]                 ; UNKNOWN
009166  50                    PUSH   ax                           ; UNKNOWN
009167  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
00916A  8D 86 FE FE           LEA    ax, [bp - 0x102]             ; UNKNOWN
00916E  50                    PUSH   ax                           ; UNKNOWN
00916F  9A D2 07 65 5F        LCALL  0x5f65, 0x7d2                ; UNKNOWN
009174  83 C4 02              ADD    sp, 2                        ; UNKNOWN
009177  8B F0                 MOV    si, ax                       ; UNKNOWN
009179  8D 82 FE FE           LEA    ax, [bp + si - 0x102]        ; UNKNOWN
00917D  50                    PUSH   ax                           ; UNKNOWN
00917E  9A 26 0B 65 5F        LCALL  0x5f65, 0xb26                ; UNKNOWN
009183  83 C4 06              ADD    sp, 6                        ; UNKNOWN
009186  8D 86 FE FE           LEA    ax, [bp - 0x102]             ; UNKNOWN
00918A  50                    PUSH   ax                           ; UNKNOWN
00918B  E8 72 FE              CALL   0x9000                       ; UNKNOWN
00918E  83 C4 02              ADD    sp, 2                        ; UNKNOWN
009191  5E                    POP    si                           ; UNKNOWN
009192  C9                    LEAVE                               ; UNKNOWN
009193  CB                    RETF                                ; UNKNOWN
