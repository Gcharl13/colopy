; ============================================================================
; func_05C43A_unknown
; Region   : load_image
; Bytes    : file 0x05C43A..0x05C47D  (67 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

05C43A  C8 0E 00 00           ENTER  0xe, 0                       ; UNKNOWN
05C43E  C7 46 F2 00 00        MOV    word ptr [bp - 0xe], 0       ; UNKNOWN
05C443  EB 5A                 JMP    0x5c49f                      ; UNKNOWN
05C445  83 7E F8 08           CMP    word ptr [bp - 8], 8         ; UNKNOWN
05C449  7D 30                 JGE    0x5c47b                      ; UNKNOWN
05C44B  8B 5E F8              MOV    bx, word ptr [bp - 8]        ; UNKNOWN
05C44E  8A 87 2F 09           MOV    al, byte ptr [bx + 0x92f]    ; UNKNOWN
05C452  98                    CWDE                                ; UNKNOWN
05C453  03 46 F4              ADD    ax, word ptr [bp - 0xc]      ; UNKNOWN
05C456  50                    PUSH   ax                           ; UNKNOWN
05C457  8A 87 26 09           MOV    al, byte ptr [bx + 0x926]    ; UNKNOWN
05C45B  98                    CWDE                                ; UNKNOWN
05C45C  03 46 F6              ADD    ax, word ptr [bp - 0xa]      ; UNKNOWN
05C45F  50                    PUSH   ax                           ; UNKNOWN
05C460  9A 47 03 C9 33        LCALL  0x33c9, 0x347                ; UNKNOWN
05C465  83 C4 04              ADD    sp, 4                        ; UNKNOWN
05C468  3B 46 06              CMP    ax, word ptr [bp + 6]        ; UNKNOWN
05C46B  75 05                 JNE    0x5c472                      ; UNKNOWN
05C46D  C7 46 FA 01 00        MOV    word ptr [bp - 6], 1         ; UNKNOWN
05C472  FF 46 F8              INC    word ptr [bp - 8]            ; UNKNOWN
05C475  83 7E FA 00           CMP    word ptr [bp - 6], 0         ; UNKNOWN
05C479  74 CA                 JE     0x5c445                      ; UNKNOWN
05C47B  83                    DB     0x83                         ; UNKNOWN (raw)
05C47C  7E                    DB     0x7E                         ; UNKNOWN (raw)
