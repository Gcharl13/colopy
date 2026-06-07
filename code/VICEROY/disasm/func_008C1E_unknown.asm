; ============================================================================
; func_008C1E_unknown
; Region   : load_image
; Bytes    : file 0x008C1E..0x008C6F  (81 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

008C1E  C8 06 00 00           ENTER  6, 0                         ; UNKNOWN
008C22  B8 FF FF              MOV    ax, 0xffff                   ; UNKNOWN
008C25  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
008C28  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
008C2B  A1 78 8D              MOV    ax, word ptr [0x8d78]        ; UNKNOWN
008C2E  EB 33                 JMP    0x8c63                       ; UNKNOWN
008C30  83 7E FA 00           CMP    word ptr [bp - 6], 0         ; UNKNOWN
008C34  7D 34                 JGE    0x8c6a                       ; UNKNOWN
008C36  50                    PUSH   ax                           ; UNKNOWN
008C37  0E                    PUSH   cs                           ; UNKNOWN
008C38  E8 5B FF              CALL   0x8b96                       ; UNKNOWN
008C3B  83 C4 02              ADD    sp, 2                        ; UNKNOWN
008C3E  0B C0                 OR     ax, ax                       ; UNKNOWN
008C40  74 19                 JE     0x8c5b                       ; UNKNOWN
008C42  FF 46 FC              INC    word ptr [bp - 4]            ; UNKNOWN
008C45  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
008C48  39 46 FE              CMP    word ptr [bp - 2], ax        ; UNKNOWN
008C4B  75 0E                 JNE    0x8c5b                       ; UNKNOWN
008C4D  8B 1E 42 85           MOV    bx, word ptr [0x8542]        ; UNKNOWN
008C51  8A 47 1F              MOV    al, byte ptr [bx + 0x1f]     ; MOV
008C54  98                    CWDE                                ; UNKNOWN
008C55  03 46 FC              ADD    ax, word ptr [bp - 4]        ; UNKNOWN
008C58  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
008C5B  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
008C5E  9A 4A 00 27 04        LCALL  0x427, 0x4a                  ; UNKNOWN
008C63  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
008C66  0B C0                 OR     ax, ax                       ; UNKNOWN
008C68  7D C6                 JGE    0x8c30                       ; UNKNOWN
008C6A  8B 46 FA              MOV    ax, word ptr [bp - 6]        ; UNKNOWN
008C6D  C9                    LEAVE                               ; UNKNOWN
008C6E  CB                    RETF                                ; UNKNOWN
