; ============================================================================
; func_01BCFB_unknown
; Region   : load_image
; Bytes    : file 0x01BCFB..0x01BD3A  (63 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

01BCFB  C8 08 00 00           ENTER  8, 0                         ; UNKNOWN
01BCFF  C7 46 FC 01 00        MOV    word ptr [bp - 4], 1         ; UNKNOWN
01BD04  8D 46 FE              LEA    ax, [bp - 2]                 ; UNKNOWN
01BD07  50                    PUSH   ax                           ; UNKNOWN
01BD08  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
01BD0B  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
01BD0E  9A 92 2F 5F 24        LCALL  0x245f, 0x2f92               ; UNKNOWN
01BD13  83 C4 04              ADD    sp, 4                        ; UNKNOWN
01BD16  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
01BD19  50                    PUSH   ax                           ; UNKNOWN
01BD1A  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
01BD1D  9A A3 31 5F 24        LCALL  0x245f, 0x31a3               ; UNKNOWN
01BD22  83 C4 06              ADD    sp, 6                        ; UNKNOWN
01BD25  0B C0                 OR     ax, ax                       ; UNKNOWN
01BD27  75 11                 JNE    0x1bd3a                      ; UNKNOWN
01BD29  50                    PUSH   ax                           ; UNKNOWN
01BD2A  6A 78                 PUSH   0x78                         ; UNKNOWN
01BD2C  6A 04                 PUSH   4                            ; UNKNOWN
01BD2E  0E                    PUSH   cs                           ; UNKNOWN
01BD2F  E8 D4 DE              CALL   0x19c06                      ; UNKNOWN
01BD32  83 C4 06              ADD    sp, 6                        ; UNKNOWN
01BD35  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
01BD38  C9                    LEAVE                               ; UNKNOWN
01BD39  CB                    RETF                                ; UNKNOWN
