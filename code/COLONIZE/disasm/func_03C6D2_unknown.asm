; ============================================================================
; func_03C6D2_unknown
; Region   : load_image
; Bytes    : file 0x03C6D2..0x03C731  (95 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03C6D2  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
03C6D6  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
03C6DB  A1 CC 79              MOV    ax, word ptr [0x79cc]        ; UNKNOWN
03C6DE  39 06 CE 79           CMP    word ptr [0x79ce], ax        ; UNKNOWN
03C6E2  75 3D                 JNE    0x3c721                      ; UNKNOWN
03C6E4  83 3E EE 0E 00        CMP    word ptr [0xeee], 0          ; UNKNOWN
03C6E9  74 36                 JE     0x3c721                      ; UNKNOWN
03C6EB  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1         ; UNKNOWN
03C6F0  83 3E 56 C1 00        CMP    word ptr [0xc156], 0         ; UNKNOWN
03C6F5  74 05                 JE     0x3c6fc                      ; UNKNOWN
03C6F7  9A 08 01 0B 38        LCALL  0x380b, 0x108                ; UNKNOWN
03C6FC  83 3E 3E 3E 00        CMP    word ptr [0x3e3e], 0         ; UNKNOWN
03C701  74 08                 JE     0x3c70b                      ; UNKNOWN
03C703  C7 06 3C 3E 00 00     MOV    word ptr [0x3e3c], 0         ; UNKNOWN
03C709  EB 16                 JMP    0x3c721                      ; UNKNOWN
03C70B  83 3E 08 3E 01        CMP    word ptr [0x3e08], 1         ; UNKNOWN
03C710  75 0B                 JNE    0x3c71d                      ; UNKNOWN
03C712  6A 00                 PUSH   0                            ; UNKNOWN
03C714  0E                    PUSH   cs                           ; UNKNOWN
03C715  E8 33 D7              CALL   0x39e4b                      ; UNKNOWN
03C718  83 C4 02              ADD    sp, 2                        ; UNKNOWN
03C71B  EB 04                 JMP    0x3c721                      ; UNKNOWN
03C71D  0E                    PUSH   cs                           ; UNKNOWN
03C71E  E8 DE D1              CALL   0x398ff                      ; UNKNOWN
03C721  83 7E FE 00           CMP    word ptr [bp - 2], 0         ; UNKNOWN
03C725  74 05                 JE     0x3c72c                      ; UNKNOWN
03C727  9A 08 01 0B 38        LCALL  0x380b, 0x108                ; UNKNOWN
03C72C  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
03C72F  C9                    LEAVE                               ; UNKNOWN
03C730  CB                    RETF                                ; UNKNOWN
