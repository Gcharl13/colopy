; ============================================================================
; func_035F98_unknown
; Region   : load_image
; Bytes    : file 0x035F98..0x035FDD  (69 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

035F98  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
035F9C  6A 0C                 PUSH   0xc                          ; UNKNOWN
035F9E  6A 48                 PUSH   0x48                         ; UNKNOWN
035FA0  68 A5 00              PUSH   0xa5                         ; UNKNOWN
035FA3  68 93 00              PUSH   0x93                         ; UNKNOWN
035FA6  9A 00 01 EF 21        LCALL  0x21ef, 0x100                ; UNKNOWN
035FAB  83 C4 08              ADD    sp, 8                        ; UNKNOWN
035FAE  0B C0                 OR     ax, ax                       ; UNKNOWN
035FB0  74 06                 JE     0x35fb8                      ; UNKNOWN
035FB2  C6 46 FE 01           MOV    byte ptr [bp - 2], 1         ; UNKNOWN
035FB6  EB 04                 JMP    0x35fbc                      ; UNKNOWN
035FB8  C6 46 FE 00           MOV    byte ptr [bp - 2], 0         ; UNKNOWN
035FBC  83 3E E6 0E 00        CMP    word ptr [0xee6], 0          ; UNKNOWN
035FC1  75 07                 JNE    0x35fca                      ; UNKNOWN
035FC3  83 3E BA 79 0A        CMP    word ptr [0x79ba], 0xa       ; UNKNOWN
035FC8  75 08                 JNE    0x35fd2                      ; UNKNOWN
035FCA  8A 46 FE              MOV    al, byte ptr [bp - 2]        ; UNKNOWN
035FCD  2A E4                 SUB    ah, ah                       ; UNKNOWN
035FCF  A3 A8 79              MOV    word ptr [0x79a8], ax        ; UNKNOWN
035FD2  A1 A8 79              MOV    ax, word ptr [0x79a8]        ; UNKNOWN
035FD5  EB 17                 JMP    0x35fee                      ; UNKNOWN
035FD7  0E                    PUSH   cs                           ; UNKNOWN
035FD8  E8 D9 FC              CALL   0x35cb4                      ; UNKNOWN
035FDB  C9                    LEAVE                               ; UNKNOWN
035FDC  CB                    RETF                                ; UNKNOWN
