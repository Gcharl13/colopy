; ============================================================================
; func_042DB2_unknown
; Region   : load_image
; Bytes    : file 0x042DB2..0x042E43  (145 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

042DB2  55                    PUSH   bp                           ; UNKNOWN
042DB3  8B EC                 MOV    bp, sp                       ; UNKNOWN
042DB5  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
042DB8  9A 04 00 E2 29        LCALL  0x29e2, 4                    ; UNKNOWN
042DBD  8B E5                 MOV    sp, bp                       ; UNKNOWN
042DBF  8B 46 08              MOV    ax, word ptr [bp + 8]        ; UNKNOWN
042DC2  8B 1E A8 74           MOV    bx, word ptr [0x74a8]        ; UNKNOWN
042DC6  01 47 0C              ADD    word ptr [bx + 0xc], ax      ; UNKNOWN
042DC9  01 47 0E              ADD    word ptr [bx + 0xe], ax      ; UNKNOWN
042DCC  F6 06 FA 3D 01        TEST   byte ptr [0x3dfa], 1         ; UNKNOWN
042DD1  75 0F                 JNE    0x42de2                      ; UNKNOWN
042DD3  83 7F 12 00           CMP    word ptr [bx + 0x12], 0      ; UNKNOWN
042DD7  7D 09                 JGE    0x42de2                      ; UNKNOWN
042DD9  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
042DDC  0E                    PUSH   cs                           ; UNKNOWN
042DDD  E8 85 FC              CALL   0x42a65                      ; UNKNOWN
042DE0  8B E5                 MOV    sp, bp                       ; UNKNOWN
042DE2  F6 06 FA 3D 01        TEST   byte ptr [0x3dfa], 1         ; UNKNOWN
042DE7  74 54                 JE     0x42e3d                      ; UNKNOWN
042DE9  F6 06 FA 3D 06        TEST   byte ptr [0x3dfa], 6         ; UNKNOWN
042DEE  75 4D                 JNE    0x42e3d                      ; UNKNOWN
042DF0  8B 46 08              MOV    ax, word ptr [bp + 8]        ; UNKNOWN
042DF3  8B 1E A8 74           MOV    bx, word ptr [0x74a8]        ; UNKNOWN
042DF7  39 47 0C              CMP    word ptr [bx + 0xc], ax      ; UNKNOWN
042DFA  7E 41                 JLE    0x42e3d                      ; UNKNOWN
042DFC  FF 36 4C 3E           PUSH   word ptr [0x3e4c]            ; UNKNOWN
042E00  6A 01                 PUSH   1                            ; UNKNOWN
042E02  6A 00                 PUSH   0                            ; UNKNOWN
042E04  9A FC 03 97 1B        LCALL  0x1b97, 0x3fc                ; UNKNOWN
042E09  8B E5                 MOV    sp, bp                       ; UNKNOWN
042E0B  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
042E0E  0E                    PUSH   cs                           ; UNKNOWN
042E0F  E8 01 FF              CALL   0x42d13                      ; UNKNOWN
042E12  8B E5                 MOV    sp, bp                       ; UNKNOWN
042E14  99                    CDQ                                 ; UNKNOWN
042E15  52                    PUSH   dx                           ; UNKNOWN
042E16  50                    PUSH   ax                           ; UNKNOWN
042E17  6A 00                 PUSH   0                            ; UNKNOWN
042E19  9A 24 04 97 1B        LCALL  0x1b97, 0x424                ; UNKNOWN
042E1E  8B E5                 MOV    sp, bp                       ; UNKNOWN
042E20  6A 01                 PUSH   1                            ; UNKNOWN
042E22  68 CC 27              PUSH   0x27cc                       ; UNKNOWN
042E25  9A 41 37 97 1B        LCALL  0x1b97, 0x3741               ; UNKNOWN
042E2A  8B E5                 MOV    sp, bp                       ; UNKNOWN
042E2C  6A 01                 PUSH   1                            ; UNKNOWN
042E2E  68 D7 27              PUSH   0x27d7                       ; UNKNOWN
042E31  9A 41 37 97 1B        LCALL  0x1b97, 0x3741               ; UNKNOWN
042E36  8B E5                 MOV    sp, bp                       ; UNKNOWN
042E38  80 0E FA 3D 04        OR     byte ptr [0x3dfa], 4         ; UNKNOWN
042E3D  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
042E40  0E                    PUSH   cs                           ; UNKNOWN
042E41  E8                    DB     0xE8                         ; UNKNOWN (raw)
042E42  CF                    DB     0xCF                         ; UNKNOWN (raw)
