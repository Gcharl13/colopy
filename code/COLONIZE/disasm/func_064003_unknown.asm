; ============================================================================
; func_064003_unknown
; Region   : load_image
; Bytes    : file 0x064003..0x064034  (49 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

064003  C8 08 00 00           ENTER  8, 0                         ; UNKNOWN
064007  57                    PUSH   di                           ; UNKNOWN
064008  8B 7E 06              MOV    di, word ptr [bp + 6]        ; UNKNOWN
06400B  8B 46 08              MOV    ax, word ptr [bp + 8]        ; UNKNOWN
06400E  50                    PUSH   ax                           ; UNKNOWN
06400F  57                    PUSH   di                           ; UNKNOWN
064010  89 7E F8              MOV    word ptr [bp - 8], di        ; UNKNOWN
064013  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
064016  9A 48 14 65 5F        LCALL  0x5f65, 0x1448               ; UNKNOWN
06401B  83 C4 04              ADD    sp, 4                        ; UNKNOWN
06401E  8B D8                 MOV    bx, ax                       ; UNKNOWN
064020  03 5E F8              ADD    bx, word ptr [bp - 8]        ; UNKNOWN
064023  8E 46 FA              MOV    es, word ptr [bp - 6]        ; UNKNOWN
064026  26 C6 07 0A           MOV    byte ptr es:[bx], 0xa        ; UNKNOWN
06402A  43                    INC    bx                           ; UNKNOWN
06402B  26 C6 07 00           MOV    byte ptr es:[bx], 0          ; UNKNOWN
06402F  5F                    POP    di                           ; UNKNOWN
064030  C9                    LEAVE                               ; UNKNOWN
064031  CA 04 00              RETF   4                            ; UNKNOWN
