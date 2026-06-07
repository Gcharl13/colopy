; ============================================================================
; func_02DF01_unknown
; Region   : load_image
; Bytes    : file 0x02DF01..0x02DF4A  (73 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02DF01  C8 06 00 00           ENTER  6, 0                         ; UNKNOWN
02DF05  B8 FF FF              MOV    ax, 0xffff                   ; UNKNOWN
02DF08  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
02DF0B  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
02DF0E  A1 40 73              MOV    ax, word ptr [0x7340]        ; UNKNOWN
02DF11  EB 2B                 JMP    0x2df3e                      ; UNKNOWN
02DF13  83 7E FA 00           CMP    word ptr [bp - 6], 0         ; UNKNOWN
02DF17  7D 2C                 JGE    0x2df45                      ; UNKNOWN
02DF19  50                    PUSH   ax                           ; UNKNOWN
02DF1A  0E                    PUSH   cs                           ; UNKNOWN
02DF1B  E8 A6 FF              CALL   0x2dec4                      ; UNKNOWN
02DF1E  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02DF21  0B C0                 OR     ax, ax                       ; UNKNOWN
02DF23  74 11                 JE     0x2df36                      ; UNKNOWN
02DF25  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
02DF28  FF 46 FC              INC    word ptr [bp - 4]            ; UNKNOWN
02DF2B  39 46 FC              CMP    word ptr [bp - 4], ax        ; UNKNOWN
02DF2E  75 06                 JNE    0x2df36                      ; UNKNOWN
02DF30  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
02DF33  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
02DF36  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
02DF39  9A 4E 00 B7 36        LCALL  0x36b7, 0x4e                 ; UNKNOWN
02DF3E  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
02DF41  0B C0                 OR     ax, ax                       ; UNKNOWN
02DF43  7D CE                 JGE    0x2df13                      ; UNKNOWN
02DF45  8B 46 FA              MOV    ax, word ptr [bp - 6]        ; UNKNOWN
02DF48  C9                    LEAVE                               ; UNKNOWN
02DF49  CB                    RETF                                ; UNKNOWN
