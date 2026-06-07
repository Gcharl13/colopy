; ============================================================================
; func_0348B2_unknown
; Region   : load_image
; Bytes    : file 0x0348B2..0x0348DB  (41 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0348B2  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
0348B6  6A 15                 PUSH   0x15                         ; UNKNOWN
0348B8  B8 0F 00              MOV    ax, 0xf                      ; UNKNOWN
0348BB  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
0348BE  50                    PUSH   ax                           ; UNKNOWN
0348BF  68 B3 00              PUSH   0xb3                         ; UNKNOWN
0348C2  68 31 01              PUSH   0x131                        ; UNKNOWN
0348C5  9A 00 01 EF 21        LCALL  0x21ef, 0x100                ; UNKNOWN
0348CA  83 C4 08              ADD    sp, 8                        ; UNKNOWN
0348CD  0B C0                 OR     ax, ax                       ; UNKNOWN
0348CF  74 0A                 JE     0x348db                      ; UNKNOWN
0348D1  C7 46 FE 0B 00        MOV    word ptr [bp - 2], 0xb       ; UNKNOWN
0348D6  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
0348D9  C9                    LEAVE                               ; UNKNOWN
0348DA  CB                    RETF                                ; UNKNOWN
