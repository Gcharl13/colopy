; ============================================================================
; func_0094B6_unknown
; Region   : load_image
; Bytes    : file 0x0094B6..0x0094E6  (48 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0094B6  C8 08 00 00           ENTER  8, 0                         ; UNKNOWN
0094BA  80 3E 30 01 00        CMP    byte ptr [0x130], 0          ; UNKNOWN
0094BF  74 23                 JE     0x94e4                       ; UNKNOWN
0094C1  FF 36 84 32           PUSH   word ptr [0x3284]            ; UNKNOWN
0094C5  0E                    PUSH   cs                           ; UNKNOWN
0094C6  E8 49 FF              CALL   0x9412                       ; UNKNOWN
0094C9  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0094CC  A0 82 32              MOV    al, byte ptr [0x3282]        ; UNKNOWN
0094CF  50                    PUSH   ax                           ; UNKNOWN
0094D0  0E                    PUSH   cs                           ; UNKNOWN
0094D1  E8 90 FF              CALL   0x9464                       ; UNKNOWN
0094D4  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0094D7  8D 5E FC              LEA    bx, [bp - 4]                 ; UNKNOWN
0094DA  9A CE 00 64 00        LCALL  0x64, 0xce                   ; UNKNOWN
0094DF  C6 06 30 01 00        MOV    byte ptr [0x130], 0          ; UNKNOWN
0094E4  C9                    LEAVE                               ; UNKNOWN
0094E5  CB                    RETF                                ; UNKNOWN
