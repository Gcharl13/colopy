; ============================================================================
; func_05F5D4_unknown
; Region   : load_image
; Bytes    : file 0x05F5D4..0x05F685  (177 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

05F5D4  C8 98 03 06           ENTER  0x398, 6                     ; UNKNOWN
05F5D8  3A 73 3B              CMP    dh, byte ptr [bp + di + 0x3b] ; UNKNOWN
05F5DB  86 56 FF              XCHG   byte ptr [bp - 1], dl        ; UNKNOWN
05F5DE  7F 03                 JG     0x5f5e3                      ; UNKNOWN
05F5E0  E9 A1 00              JMP    0x5f684                      ; UNKNOWN
05F5E3  80 F9 20              CMP    cl, 0x20                     ; UNKNOWN
05F5E6  7C 03                 JL     0x5f5eb                      ; UNKNOWN
05F5E8  E9 99 00              JMP    0x5f684                      ; UNKNOWN
05F5EB  FF B6 56 FF           PUSH   word ptr [bp - 0xaa]         ; UNKNOWN
05F5EF  9A F7 0D 5F 24        LCALL  0x245f, 0xdf7                ; UNKNOWN
05F5F4  83 C4 02              ADD    sp, 2                        ; UNKNOWN
05F5F7  89 86 14 FF           MOV    word ptr [bp - 0xec], ax     ; UNKNOWN
05F5FB  FF B6 56 FF           PUSH   word ptr [bp - 0xaa]         ; UNKNOWN
05F5FF  9A 30 0E 5F 24        LCALL  0x245f, 0xe30                ; UNKNOWN
05F604  83 C4 02              ADD    sp, 2                        ; UNKNOWN
05F607  89 46 EA              MOV    word ptr [bp - 0x16], ax     ; UNKNOWN
05F60A  83 BE 14 FF 15        CMP    word ptr [bp - 0xec], 0x15   ; UNKNOWN
05F60F  74 0A                 JE     0x5f61b                      ; UNKNOWN
05F611  83 BE 14 FF 17        CMP    word ptr [bp - 0xec], 0x17   ; UNKNOWN
05F616  74 03                 JE     0x5f61b                      ; UNKNOWN
05F618  E9 2B FF              JMP    0x5f546                      ; UNKNOWN
05F61B  83 7E 8C 00           CMP    word ptr [bp - 0x74], 0      ; UNKNOWN
05F61F  7D 0A                 JGE    0x5f62b                      ; UNKNOWN
05F621  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
05F625  F6 47 1B 08           TEST   byte ptr [bx + 0x1b], 8      ; UNKNOWN
05F629  74 2C                 JE     0x5f657                      ; UNKNOWN
05F62B  50                    PUSH   ax                           ; UNKNOWN
05F62C  9A 08 00 5F 24        LCALL  0x245f, 8                    ; UNKNOWN
05F631  83 C4 02              ADD    sp, 2                        ; UNKNOWN
05F634  0B C0                 OR     ax, ax                       ; UNKNOWN
05F636  74 12                 JE     0x5f64a                      ; UNKNOWN
05F638  83 7E EA 15           CMP    word ptr [bp - 0x16], 0x15   ; UNKNOWN
05F63C  74 0C                 JE     0x5f64a                      ; UNKNOWN
05F63E  83 7E C0 00           CMP    word ptr [bp - 0x40], 0      ; UNKNOWN
05F642  75 13                 JNE    0x5f657                      ; UNKNOWN
05F644  83 7E C4 00           CMP    word ptr [bp - 0x3c], 0      ; UNKNOWN
05F648  75 0D                 JNE    0x5f657                      ; UNKNOWN
05F64A  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
05F64E  F6 47 1B 04           TEST   byte ptr [bx + 0x1b], 4      ; UNKNOWN
05F652  75 03                 JNE    0x5f657                      ; UNKNOWN
05F654  E9 EF FE              JMP    0x5f546                      ; UNKNOWN
05F657  6A 12                 PUSH   0x12                         ; UNKNOWN
05F659  FF B6 56 FF           PUSH   word ptr [bp - 0xaa]         ; UNKNOWN
05F65D  9A 3D 10 5F 24        LCALL  0x245f, 0x103d               ; UNKNOWN
05F662  83 C4 04              ADD    sp, 4                        ; UNKNOWN
05F665  FF 46 8C              INC    word ptr [bp - 0x74]         ; UNKNOWN
05F668  C7 46 D0 01 00        MOV    word ptr [bp - 0x30], 1      ; UNKNOWN
05F66D  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
05F671  80 67 1B FB           AND    byte ptr [bx + 0x1b], 0xfb   ; UNKNOWN
05F675  83 7E C4 00           CMP    word ptr [bp - 0x3c], 0      ; UNKNOWN
05F679  75 03                 JNE    0x5f67e                      ; UNKNOWN
05F67B  E9 BF FE              JMP    0x5f53d                      ; UNKNOWN
05F67E  FF 4E C4              DEC    word ptr [bp - 0x3c]         ; UNKNOWN
05F681  E9 C2 FE              JMP    0x5f546                      ; UNKNOWN
05F684  83                    DB     0x83                         ; UNKNOWN (raw)
