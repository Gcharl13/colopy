; ============================================================================
; func_06600E_unknown
; Region   : load_image
; Bytes    : file 0x06600E..0x066028  (26 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06600E  C8 00 00 00           ENTER  0, 0                         ; UNKNOWN
066012  06                    PUSH   es                           ; UNKNOWN
066013  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
066016  0B C0                 OR     ax, ax                       ; UNKNOWN
066018  74 0B                 JE     0x66025                      ; UNKNOWN
06601A  8E C0                 MOV    es, ax                       ; UNKNOWN
06601C  B4 49                 MOV    ah, 0x49                     ; UNKNOWN
06601E  CD 21                 INT    0x21                         ; UNKNOWN
066020  9A FB 00 F3 5C        LCALL  0x5cf3, 0xfb                 ; UNKNOWN
066025  07                    POP    es                           ; UNKNOWN
066026  C9                    LEAVE                               ; UNKNOWN
066027  CB                    RETF                                ; UNKNOWN
