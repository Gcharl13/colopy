; ============================================================================
; func_069684_unknown
; Region   : load_image
; Bytes    : file 0x069684..0x06969F  (27 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

069684  55                    PUSH   bp                           ; UNKNOWN
069685  8B EC                 MOV    bp, sp                       ; UNKNOWN
069687  8A 56 06              MOV    dl, byte ptr [bp + 6]        ; UNKNOWN
06968A  4A                    DEC    dx                           ; UNKNOWN
06968B  B4 0E                 MOV    ah, 0xe                      ; UNKNOWN
06968D  CD 21                 INT    0x21                         ; UNKNOWN
06968F  B4 19                 MOV    ah, 0x19                     ; UNKNOWN
069691  CD 21                 INT    0x21                         ; UNKNOWN
069693  40                    INC    ax                           ; UNKNOWN
069694  3A 46 06              CMP    al, byte ptr [bp + 6]        ; UNKNOWN
069697  B8 FF FF              MOV    ax, 0xffff                   ; UNKNOWN
06969A  75 01                 JNE    0x6969d                      ; UNKNOWN
06969C  40                    INC    ax                           ; UNKNOWN
06969D  5D                    POP    bp                           ; UNKNOWN
06969E  CB                    RETF                                ; UNKNOWN
