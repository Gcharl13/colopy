; ============================================================================
; func_05C199_unknown
; Region   : load_image
; Bytes    : file 0x05C199..0x05C1FF  (102 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

05C199  C8 54 00 00           ENTER  0x54, 0                      ; UNKNOWN
05C19D  68 E8 2D              PUSH   0x2de8                       ; UNKNOWN
05C1A0  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
05C1A3  89 46 AC              MOV    word ptr [bp - 0x54], ax     ; UNKNOWN
05C1A6  50                    PUSH   ax                           ; UNKNOWN
05C1A7  9A 74 07 65 5F        LCALL  0x5f65, 0x774                ; UNKNOWN
05C1AC  83 C4 04              ADD    sp, 4                        ; UNKNOWN
05C1AF  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
05C1B2  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
05C1B5  50                    PUSH   ax                           ; UNKNOWN
05C1B6  9A 34 07 65 5F        LCALL  0x5f65, 0x734                ; UNKNOWN
05C1BB  83 C4 04              ADD    sp, 4                        ; UNKNOWN
05C1BE  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
05C1C1  50                    PUSH   ax                           ; UNKNOWN
05C1C2  68 86 09              PUSH   0x986                        ; UNKNOWN
05C1C5  9A 24 00 09 45        LCALL  0x4509, 0x24                 ; UNKNOWN
05C1CA  83 C4 04              ADD    sp, 4                        ; UNKNOWN
05C1CD  0B C0                 OR     ax, ax                       ; UNKNOWN
05C1CF  75 18                 JNE    0x5c1e9                      ; UNKNOWN
05C1D1  89 46 AE              MOV    word ptr [bp - 0x52], ax     ; UNKNOWN
05C1D4  EB 0B                 JMP    0x5c1e1                      ; UNKNOWN
05C1D6  9A 0F 01 09 45        LCALL  0x4509, 0x10f                ; UNKNOWN
05C1DB  89 46 AC              MOV    word ptr [bp - 0x54], ax     ; UNKNOWN
05C1DE  FF 46 AE              INC    word ptr [bp - 0x52]         ; UNKNOWN
05C1E1  8B 46 0A              MOV    ax, word ptr [bp + 0xa]      ; UNKNOWN
05C1E4  39 46 AE              CMP    word ptr [bp - 0x52], ax     ; UNKNOWN
05C1E7  7E ED                 JLE    0x5c1d6                      ; UNKNOWN
05C1E9  1E                    PUSH   ds                           ; UNKNOWN
05C1EA  FF 76 AC              PUSH   word ptr [bp - 0x54]         ; UNKNOWN
05C1ED  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
05C1F0  9A C9 03 97 1B        LCALL  0x1b97, 0x3c9                ; UNKNOWN
05C1F5  83 C4 06              ADD    sp, 6                        ; UNKNOWN
05C1F8  9A 0A 00 09 45        LCALL  0x4509, 0xa                  ; UNKNOWN
05C1FD  C9                    LEAVE                               ; UNKNOWN
05C1FE  CB                    RETF                                ; UNKNOWN
