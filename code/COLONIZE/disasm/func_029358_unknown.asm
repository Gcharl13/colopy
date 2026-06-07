; ============================================================================
; func_029358_unknown
; Region   : load_image
; Bytes    : file 0x029358..0x029371  (25 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

029358  C8 50 00 00           ENTER  0x50, 0                      ; UNKNOWN
02935C  83 3E E4 0E 3D        CMP    word ptr [0xee4], 0x3d       ; UNKNOWN
029361  7C 0E                 JL     0x29371                      ; UNKNOWN
029363  81 3E E4 0E 8D 00     CMP    word ptr [0xee4], 0x8d       ; UNKNOWN
029369  7D 06                 JGE    0x29371                      ; UNKNOWN
02936B  0E                    PUSH   cs                           ; UNKNOWN
02936C  E8 7D FF              CALL   0x292ec                      ; UNKNOWN
02936F  C9                    LEAVE                               ; UNKNOWN
029370  CB                    RETF                                ; UNKNOWN
