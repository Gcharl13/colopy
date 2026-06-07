; ============================================================================
; func_02D5F8_unknown
; Region   : load_image
; Bytes    : file 0x02D5F8..0x02D61E  (38 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02D5F8  55                    PUSH   bp                           ; UNKNOWN
02D5F9  8B EC                 MOV    bp, sp                       ; UNKNOWN
02D5FB  83 7E 06 1C           CMP    word ptr [bp + 6], 0x1c      ; UNKNOWN
02D5FF  74 1D                 JE     0x2d61e                      ; UNKNOWN
02D601  83 7E 06 13           CMP    word ptr [bp + 6], 0x13      ; UNKNOWN
02D605  74 17                 JE     0x2d61e                      ; UNKNOWN
02D607  83 7E 06 19           CMP    word ptr [bp + 6], 0x19      ; UNKNOWN
02D60B  74 11                 JE     0x2d61e                      ; UNKNOWN
02D60D  83 7E 06 1A           CMP    word ptr [bp + 6], 0x1a      ; UNKNOWN
02D611  74 0B                 JE     0x2d61e                      ; UNKNOWN
02D613  83 7E 06 1B           CMP    word ptr [bp + 6], 0x1b      ; UNKNOWN
02D617  74 05                 JE     0x2d61e                      ; UNKNOWN
02D619  B8 01 00              MOV    ax, 1                        ; UNKNOWN
02D61C  C9                    LEAVE                               ; UNKNOWN
02D61D  CB                    RETF                                ; UNKNOWN
