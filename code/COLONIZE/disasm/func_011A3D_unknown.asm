; ============================================================================
; func_011A3D_unknown
; Region   : load_image
; Bytes    : file 0x011A3D..0x011A5E  (33 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

011A3D  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
011A41  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
011A44  0E                    PUSH   cs                           ; UNKNOWN
011A45  E8 2C ED              CALL   0x10774                      ; UNKNOWN
011A48  83 C4 02              ADD    sp, 2                        ; UNKNOWN
011A4B  83 F8 08              CMP    ax, 8                        ; UNKNOWN
011A4E  74 0E                 JE     0x11a5e                      ; UNKNOWN
011A50  50                    PUSH   ax                           ; UNKNOWN
011A51  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
011A54  9A 1A 0C FD 3C        LCALL  0x3cfd, 0xc1a                ; UNKNOWN
011A59  83 C4 04              ADD    sp, 4                        ; UNKNOWN
011A5C  C9                    LEAVE                               ; UNKNOWN
011A5D  CB                    RETF                                ; UNKNOWN
