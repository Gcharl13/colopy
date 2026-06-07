; ============================================================================
; func_030E5F_unknown
; Region   : load_image
; Bytes    : file 0x030E5F..0x030EA6  (71 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

030E5F  C8 06 00 00           ENTER  6, 0                         ; UNKNOWN
030E63  C7 46 FA FE FF        MOV    word ptr [bp - 6], 0xfffe    ; UNKNOWN
030E68  B8 FF FF              MOV    ax, 0xffff                   ; UNKNOWN
030E6B  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
030E6E  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
030E71  EB 28                 JMP    0x30e9b                      ; UNKNOWN
030E73  83 7E FE 31           CMP    word ptr [bp - 2], 0x31      ; UNKNOWN
030E77  7D 28                 JGE    0x30ea1                      ; UNKNOWN
030E79  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
030E7C  0E                    PUSH   cs                           ; UNKNOWN
030E7D  E8 4E FD              CALL   0x30bce                      ; UNKNOWN
030E80  83 C4 02              ADD    sp, 2                        ; UNKNOWN
030E83  0B C0                 OR     ax, ax                       ; UNKNOWN
030E85  74 11                 JE     0x30e98                      ; UNKNOWN
030E87  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
030E8A  FF 46 FC              INC    word ptr [bp - 4]            ; UNKNOWN
030E8D  39 46 FC              CMP    word ptr [bp - 4], ax        ; UNKNOWN
030E90  75 06                 JNE    0x30e98                      ; UNKNOWN
030E92  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
030E95  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
030E98  FF 46 FE              INC    word ptr [bp - 2]            ; UNKNOWN
030E9B  83 7E FA FF           CMP    word ptr [bp - 6], -1        ; UNKNOWN
030E9F  7C D2                 JL     0x30e73                      ; UNKNOWN
030EA1  8B 46 FA              MOV    ax, word ptr [bp - 6]        ; UNKNOWN
030EA4  C9                    LEAVE                               ; UNKNOWN
030EA5  CB                    RETF                                ; UNKNOWN
