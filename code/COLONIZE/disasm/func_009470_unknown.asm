; ============================================================================
; func_009470_unknown
; Region   : load_image
; Bytes    : file 0x009470..0x0094B6  (70 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

009470  C8 08 00 00           ENTER  8, 0                         ; UNKNOWN
009474  80 3E 30 01 00        CMP    byte ptr [0x130], 0          ; UNKNOWN
009479  75 39                 JNE    0x94b4                       ; UNKNOWN
00947B  0E                    PUSH   cs                           ; UNKNOWN
00947C  E8 B3 FF              CALL   0x9432                       ; UNKNOWN
00947F  A2 82 32              MOV    byte ptr [0x3282], al        ; UNKNOWN
009482  6A 01                 PUSH   1                            ; UNKNOWN
009484  0E                    PUSH   cs                           ; UNKNOWN
009485  E8 DC FF              CALL   0x9464                       ; UNKNOWN
009488  83 C4 02              ADD    sp, 2                        ; UNKNOWN
00948B  0E                    PUSH   cs                           ; UNKNOWN
00948C  E8 51 FF              CALL   0x93e0                       ; UNKNOWN
00948F  A3 84 32              MOV    word ptr [0x3284], ax        ; UNKNOWN
009492  68 80 00              PUSH   0x80                         ; UNKNOWN
009495  0E                    PUSH   cs                           ; UNKNOWN
009496  E8 79 FF              CALL   0x9412                       ; UNKNOWN
009499  83 C4 02              ADD    sp, 2                        ; UNKNOWN
00949C  8D 5E FC              LEA    bx, [bp - 4]                 ; UNKNOWN
00949F  9A CE 00 64 00        LCALL  0x64, 0xce                   ; UNKNOWN
0094A4  C6 06 30 01 01        MOV    byte ptr [0x130], 1          ; UNKNOWN
0094A9  68 3C 00              PUSH   0x3c                         ; UNKNOWN
0094AC  68 F6 00              PUSH   0xf6                         ; UNKNOWN
0094AF  9A 2C 0E 65 5F        LCALL  0x5f65, 0xe2c                ; UNKNOWN
0094B4  C9                    LEAVE                               ; UNKNOWN
0094B5  CB                    RETF                                ; UNKNOWN
