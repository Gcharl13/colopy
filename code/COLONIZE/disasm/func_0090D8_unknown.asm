; ============================================================================
; func_0090D8_unknown
; Region   : load_image
; Bytes    : file 0x0090D8..0x009136  (94 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0090D8  C8 02 01 00           ENTER  0x102, 0                     ; UNKNOWN
0090DC  56                    PUSH   si                           ; UNKNOWN
0090DD  83 3E 68 00 01        CMP    word ptr [0x68], 1           ; UNKNOWN
0090E2  7C 4F                 JL     0x9133                       ; UNKNOWN
0090E4  FF 36 6C 00           PUSH   word ptr [0x6c]              ; UNKNOWN
0090E8  8D 86 FE FE           LEA    ax, [bp - 0x102]             ; UNKNOWN
0090EC  50                    PUSH   ax                           ; UNKNOWN
0090ED  9A 74 07 65 5F        LCALL  0x5f65, 0x774                ; UNKNOWN
0090F2  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0090F5  68 7B 00              PUSH   0x7b                         ; UNKNOWN
0090F8  8D 86 FE FE           LEA    ax, [bp - 0x102]             ; UNKNOWN
0090FC  50                    PUSH   ax                           ; UNKNOWN
0090FD  9A 34 07 65 5F        LCALL  0x5f65, 0x734                ; UNKNOWN
009102  83 C4 04              ADD    sp, 4                        ; UNKNOWN
009105  8D 46 08              LEA    ax, [bp + 8]                 ; UNKNOWN
009108  50                    PUSH   ax                           ; UNKNOWN
009109  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
00910C  8D 86 FE FE           LEA    ax, [bp - 0x102]             ; UNKNOWN
009110  50                    PUSH   ax                           ; UNKNOWN
009111  9A D2 07 65 5F        LCALL  0x5f65, 0x7d2                ; UNKNOWN
009116  83 C4 02              ADD    sp, 2                        ; UNKNOWN
009119  8B F0                 MOV    si, ax                       ; UNKNOWN
00911B  8D 82 FE FE           LEA    ax, [bp + si - 0x102]        ; UNKNOWN
00911F  50                    PUSH   ax                           ; UNKNOWN
009120  9A 26 0B 65 5F        LCALL  0x5f65, 0xb26                ; UNKNOWN
009125  83 C4 06              ADD    sp, 6                        ; UNKNOWN
009128  8D 86 FE FE           LEA    ax, [bp - 0x102]             ; UNKNOWN
00912C  50                    PUSH   ax                           ; UNKNOWN
00912D  E8 D0 FE              CALL   0x9000                       ; UNKNOWN
009130  83 C4 02              ADD    sp, 2                        ; UNKNOWN
009133  5E                    POP    si                           ; UNKNOWN
009134  C9                    LEAVE                               ; UNKNOWN
009135  CB                    RETF                                ; UNKNOWN
