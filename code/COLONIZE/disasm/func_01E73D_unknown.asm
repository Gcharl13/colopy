; ============================================================================
; func_01E73D_unknown
; Region   : load_image
; Bytes    : file 0x01E73D..0x01E7BC  (127 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

01E73D  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
01E741  6A 0B                 PUSH   0xb                          ; UNKNOWN
01E743  FF 36 10 3E           PUSH   word ptr [0x3e10]            ; UNKNOWN
01E747  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
01E74A  9A CE 00 49 22        LCALL  0x2249, 0xce                 ; UNKNOWN
01E74F  83 C4 06              ADD    sp, 6                        ; UNKNOWN
01E752  6A 0B                 PUSH   0xb                          ; UNKNOWN
01E754  FF 36 4A 3E           PUSH   word ptr [0x3e4a]            ; UNKNOWN
01E758  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
01E75B  9A CE 00 49 22        LCALL  0x2249, 0xce                 ; UNKNOWN
01E760  83 C4 06              ADD    sp, 6                        ; UNKNOWN
01E763  6A 60                 PUSH   0x60                         ; UNKNOWN
01E765  FF 36 10 3E           PUSH   word ptr [0x3e10]            ; UNKNOWN
01E769  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
01E76C  9A 65 00 49 22        LCALL  0x2249, 0x65                 ; UNKNOWN
01E771  83 C4 06              ADD    sp, 6                        ; UNKNOWN
01E774  6A 60                 PUSH   0x60                         ; UNKNOWN
01E776  FF 36 4A 3E           PUSH   word ptr [0x3e4a]            ; UNKNOWN
01E77A  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
01E77D  9A 65 00 49 22        LCALL  0x2249, 0x65                 ; UNKNOWN
01E782  83 C4 06              ADD    sp, 6                        ; UNKNOWN
01E785  A1 14 3E              MOV    ax, word ptr [0x3e14]        ; UNKNOWN
01E788  48                    DEC    ax                           ; UNKNOWN
01E789  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
01E78C  EB 1D                 JMP    0x1e7ab                      ; UNKNOWN
01E78E  6B 5E FE 1C           IMUL   bx, word ptr [bp - 2], 0x1c  ; UNKNOWN
01E792  8A 87 83 88           MOV    al, byte ptr [bx - 0x777d]   ; UNKNOWN
01E796  24 0F                 AND    al, 0xf                      ; UNKNOWN
01E798  3A 46 06              CMP    al, byte ptr [bp + 6]        ; UNKNOWN
01E79B  75 0B                 JNE    0x1e7a8                      ; UNKNOWN
01E79D  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
01E7A0  9A 1C 08 B7 36        LCALL  0x36b7, 0x81c                ; UNKNOWN
01E7A5  83 C4 02              ADD    sp, 2                        ; UNKNOWN
01E7A8  FF 4E FE              DEC    word ptr [bp - 2]            ; UNKNOWN
01E7AB  83 7E FE 00           CMP    word ptr [bp - 2], 0         ; UNKNOWN
01E7AF  7D DD                 JGE    0x1e78e                      ; UNKNOWN
01E7B1  6B 5E 06 34           IMUL   bx, word ptr [bp + 6], 0x34  ; UNKNOWN
01E7B5  C6 87 B7 C0 02        MOV    byte ptr [bx - 0x3f49], 2    ; UNKNOWN
01E7BA  C9                    LEAVE                               ; UNKNOWN
01E7BB  CB                    RETF                                ; UNKNOWN
