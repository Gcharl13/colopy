; ============================================================================
; func_0329D2_unknown
; Region   : load_image
; Bytes    : file 0x0329D2..0x032A03  (49 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0329D2  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
0329D6  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
0329D9  9A 32 00 5F 24        LCALL  0x245f, 0x32                 ; UNKNOWN
0329DE  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0329E1  9A 8F 26 5F 24        LCALL  0x245f, 0x268f               ; UNKNOWN
0329E6  9A DB 38 5F 24        LCALL  0x245f, 0x38db               ; UNKNOWN
0329EB  6A 00                 PUSH   0                            ; UNKNOWN
0329ED  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
0329F0  9A 5A 09 5F 24        LCALL  0x245f, 0x95a                ; UNKNOWN
0329F5  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0329F8  50                    PUSH   ax                           ; UNKNOWN
0329F9  9A 3D 10 5F 24        LCALL  0x245f, 0x103d               ; UNKNOWN
0329FE  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
032A01  C9                    LEAVE                               ; UNKNOWN
032A02  CB                    RETF                                ; UNKNOWN
