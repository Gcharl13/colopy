; ============================================================================
; func_04175A_unknown
; Region   : load_image
; Bytes    : file 0x04175A..0x04179C  (66 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04175A  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
04175E  2B C0                 SUB    ax, ax                       ; UNKNOWN
041760  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
041763  50                    PUSH   ax                           ; UNKNOWN
041764  9A 88 03 5F 24        LCALL  0x245f, 0x388                ; UNKNOWN
041769  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04176C  0B C0                 OR     ax, ax                       ; UNKNOWN
04176E  74 05                 JE     0x41775                      ; UNKNOWN
041770  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1         ; UNKNOWN
041775  6A 01                 PUSH   1                            ; UNKNOWN
041777  9A 88 03 5F 24        LCALL  0x245f, 0x388                ; UNKNOWN
04177C  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04177F  0B C0                 OR     ax, ax                       ; UNKNOWN
041781  74 03                 JE     0x41786                      ; UNKNOWN
041783  FF 46 FE              INC    word ptr [bp - 2]            ; UNKNOWN
041786  6A 02                 PUSH   2                            ; UNKNOWN
041788  9A 88 03 5F 24        LCALL  0x245f, 0x388                ; UNKNOWN
04178D  83 C4 02              ADD    sp, 2                        ; UNKNOWN
041790  0B C0                 OR     ax, ax                       ; UNKNOWN
041792  74 03                 JE     0x41797                      ; UNKNOWN
041794  FF 46 FE              INC    word ptr [bp - 2]            ; UNKNOWN
041797  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
04179A  C9                    LEAVE                               ; UNKNOWN
04179B  CB                    RETF                                ; UNKNOWN
