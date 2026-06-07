; ============================================================================
; func_01E6B9_unknown
; Region   : load_image
; Bytes    : file 0x01E6B9..0x01E6F2  (57 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

01E6B9  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
01E6BD  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
01E6C0  48                    DEC    ax                           ; UNKNOWN
01E6C1  74 43                 JE     0x1e706                      ; UNKNOWN
01E6C3  48                    DEC    ax                           ; UNKNOWN
01E6C4  74 2C                 JE     0x1e6f2                      ; UNKNOWN
01E6C6  48                    DEC    ax                           ; UNKNOWN
01E6C7  74 33                 JE     0x1e6fc                      ; UNKNOWN
01E6C9  83 7E 08 04           CMP    word ptr [bp + 8], 4         ; UNKNOWN
01E6CD  7D 64                 JGE    0x1e733                      ; UNKNOWN
01E6CF  6B 5E 08 34           IMUL   bx, word ptr [bp + 8], 0x34  ; UNKNOWN
01E6D3  80 BF B7 C0 00        CMP    byte ptr [bx - 0x3f49], 0    ; UNKNOWN
01E6D8  75 59                 JNE    0x1e733                      ; UNKNOWN
01E6DA  A0 FA 3D              MOV    al, byte ptr [0x3dfa]        ; UNKNOWN
01E6DD  83 E0 01              AND    ax, 1                        ; UNKNOWN
01E6E0  83 F8 01              CMP    ax, 1                        ; UNKNOWN
01E6E3  1B C0                 SBB    ax, ax                       ; UNKNOWN
01E6E5  24 FB                 AND    al, 0xfb                     ; UNKNOWN
01E6E7  83 C0 09              ADD    ax, 9                        ; UNKNOWN
01E6EA  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
01E6ED  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
01E6F0  C9                    LEAVE                               ; UNKNOWN
01E6F1  CB                    RETF                                ; UNKNOWN
