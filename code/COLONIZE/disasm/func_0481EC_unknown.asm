; ============================================================================
; func_0481EC_unknown
; Region   : load_image
; Bytes    : file 0x0481EC..0x048232  (70 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0481EC  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
0481F0  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
0481F5  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
0481F8  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
0481FB  9A 38 00 3C 22        LCALL  0x223c, 0x38                 ; UNKNOWN
048200  83 C4 04              ADD    sp, 4                        ; UNKNOWN
048203  83 F8 19              CMP    ax, 0x19                     ; UNKNOWN
048206  74 05                 JE     0x4820d                      ; UNKNOWN
048208  83 F8 1A              CMP    ax, 0x1a                     ; UNKNOWN
04820B  75 20                 JNE    0x4822d                      ; UNKNOWN
04820D  FF 46 FE              INC    word ptr [bp - 2]            ; UNKNOWN
048210  83 F8 1A              CMP    ax, 0x1a                     ; UNKNOWN
048213  74 18                 JE     0x4822d                      ; UNKNOWN
048215  FF 46 FE              INC    word ptr [bp - 2]            ; UNKNOWN
048218  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
04821B  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
04821E  9A 9A 04 C9 33        LCALL  0x33c9, 0x49a                ; UNKNOWN
048223  83 C4 04              ADD    sp, 4                        ; UNKNOWN
048226  40                    INC    ax                           ; UNKNOWN
048227  74 04                 JE     0x4822d                      ; UNKNOWN
048229  83 46 FE 03           ADD    word ptr [bp - 2], 3         ; UNKNOWN
04822D  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
048230  C9                    LEAVE                               ; UNKNOWN
048231  CB                    RETF                                ; UNKNOWN
