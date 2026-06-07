; ============================================================================
; func_009050_unknown
; Region   : load_image
; Bytes    : file 0x009050..0x009079  (41 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

009050  C8 02 01 00           ENTER  0x102, 0                     ; UNKNOWN
009054  83 3E 68 00 03        CMP    word ptr [0x68], 3           ; UNKNOWN
009059  7C 1C                 JL     0x9077                       ; UNKNOWN
00905B  8D 46 08              LEA    ax, [bp + 8]                 ; UNKNOWN
00905E  50                    PUSH   ax                           ; UNKNOWN
00905F  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
009062  8D 86 FE FE           LEA    ax, [bp - 0x102]             ; UNKNOWN
009066  50                    PUSH   ax                           ; UNKNOWN
009067  9A 26 0B 65 5F        LCALL  0x5f65, 0xb26                ; UNKNOWN
00906C  83 C4 06              ADD    sp, 6                        ; UNKNOWN
00906F  8D 86 FE FE           LEA    ax, [bp - 0x102]             ; UNKNOWN
009073  50                    PUSH   ax                           ; UNKNOWN
009074  E8 89 FF              CALL   0x9000                       ; UNKNOWN
009077  C9                    LEAVE                               ; UNKNOWN
009078  CB                    RETF                                ; UNKNOWN
