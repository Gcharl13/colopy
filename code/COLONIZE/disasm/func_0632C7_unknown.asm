; ============================================================================
; func_0632C7_unknown
; Region   : load_image
; Bytes    : file 0x0632C7..0x063306  (63 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0632C7  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
0632CB  C7 46 FC 00 00        MOV    word ptr [bp - 4], 0         ; UNKNOWN
0632D0  A1 14 3E              MOV    ax, word ptr [0x3e14]        ; UNKNOWN
0632D3  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
0632D6  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
0632D9  9A 32 00 5F 24        LCALL  0x245f, 0x32                 ; UNKNOWN
0632DE  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0632E1  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
0632E5  80 BF 82 88 05        CMP    byte ptr [bx - 0x777e], 5    ; UNKNOWN
0632EA  75 1A                 JNE    0x63306                      ; UNKNOWN
0632EC  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
0632EF  0E                    PUSH   cs                           ; UNKNOWN
0632F0  E8 8B F9              CALL   0x62c7e                      ; UNKNOWN
0632F3  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0632F6  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
0632F9  A1 14 3E              MOV    ax, word ptr [0x3e14]        ; UNKNOWN
0632FC  39 46 FE              CMP    word ptr [bp - 2], ax        ; UNKNOWN
0632FF  74 2B                 JE     0x6332c                      ; UNKNOWN
063301  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
063304  C9                    LEAVE                               ; UNKNOWN
063305  CB                    RETF                                ; UNKNOWN
