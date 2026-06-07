; ============================================================================
; func_00907A_unknown
; Region   : load_image
; Bytes    : file 0x00907A..0x0090D8  (94 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00907A  C8 02 01 00           ENTER  0x102, 0                     ; UNKNOWN
00907E  56                    PUSH   si                           ; UNKNOWN
00907F  83 3E 68 00 02        CMP    word ptr [0x68], 2           ; UNKNOWN
009084  7C 4F                 JL     0x90d5                       ; UNKNOWN
009086  FF 36 6E 00           PUSH   word ptr [0x6e]              ; UNKNOWN
00908A  8D 86 FE FE           LEA    ax, [bp - 0x102]             ; UNKNOWN
00908E  50                    PUSH   ax                           ; UNKNOWN
00908F  9A 74 07 65 5F        LCALL  0x5f65, 0x774                ; UNKNOWN
009094  83 C4 04              ADD    sp, 4                        ; UNKNOWN
009097  68 78 00              PUSH   0x78                         ; UNKNOWN
00909A  8D 86 FE FE           LEA    ax, [bp - 0x102]             ; UNKNOWN
00909E  50                    PUSH   ax                           ; UNKNOWN
00909F  9A 34 07 65 5F        LCALL  0x5f65, 0x734                ; UNKNOWN
0090A4  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0090A7  8D 46 08              LEA    ax, [bp + 8]                 ; UNKNOWN
0090AA  50                    PUSH   ax                           ; UNKNOWN
0090AB  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
0090AE  8D 86 FE FE           LEA    ax, [bp - 0x102]             ; UNKNOWN
0090B2  50                    PUSH   ax                           ; UNKNOWN
0090B3  9A D2 07 65 5F        LCALL  0x5f65, 0x7d2                ; UNKNOWN
0090B8  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0090BB  8B F0                 MOV    si, ax                       ; UNKNOWN
0090BD  8D 82 FE FE           LEA    ax, [bp + si - 0x102]        ; UNKNOWN
0090C1  50                    PUSH   ax                           ; UNKNOWN
0090C2  9A 26 0B 65 5F        LCALL  0x5f65, 0xb26                ; UNKNOWN
0090C7  83 C4 06              ADD    sp, 6                        ; UNKNOWN
0090CA  8D 86 FE FE           LEA    ax, [bp - 0x102]             ; UNKNOWN
0090CE  50                    PUSH   ax                           ; UNKNOWN
0090CF  E8 2E FF              CALL   0x9000                       ; UNKNOWN
0090D2  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0090D5  5E                    POP    si                           ; UNKNOWN
0090D6  C9                    LEAVE                               ; UNKNOWN
0090D7  CB                    RETF                                ; UNKNOWN
