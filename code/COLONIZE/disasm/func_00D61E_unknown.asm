; ============================================================================
; func_00D61E_unknown
; Region   : load_image
; Bytes    : file 0x00D61E..0x00D655  (55 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00D61E  C8 14 00 00           ENTER  0x14, 0                      ; UNKNOWN
00D622  68 63 1C              PUSH   0x1c63                       ; UNKNOWN
00D625  8D 46 EC              LEA    ax, [bp - 0x14]              ; UNKNOWN
00D628  50                    PUSH   ax                           ; UNKNOWN
00D629  9A 74 07 65 5F        LCALL  0x5f65, 0x774                ; UNKNOWN
00D62E  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00D631  83 3E 10 3E 03        CMP    word ptr [0x3e10], 3         ; UNKNOWN
00D636  75 0F                 JNE    0xd647                       ; UNKNOWN
00D638  6A 02                 PUSH   2                            ; UNKNOWN
00D63A  8D 46 EC              LEA    ax, [bp - 0x14]              ; UNKNOWN
00D63D  16                    PUSH   ss                           ; UNKNOWN
00D63E  50                    PUSH   ax                           ; UNKNOWN
00D63F  9A 38 01 13 24        LCALL  0x2413, 0x138                ; UNKNOWN
00D644  83 C4 06              ADD    sp, 6                        ; UNKNOWN
00D647  8D 46 EC              LEA    ax, [bp - 0x14]              ; UNKNOWN
00D64A  50                    PUSH   ax                           ; UNKNOWN
00D64B  6A 01                 PUSH   1                            ; UNKNOWN
00D64D  6A 01                 PUSH   1                            ; UNKNOWN
00D64F  0E                    PUSH   cs                           ; UNKNOWN
00D650  E8 8E FD              CALL   0xd3e1                       ; UNKNOWN
00D653  C9                    LEAVE                               ; UNKNOWN
00D654  CB                    RETF                                ; UNKNOWN
