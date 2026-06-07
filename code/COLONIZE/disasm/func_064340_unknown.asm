; ============================================================================
; func_064340_unknown
; Region   : load_image
; Bytes    : file 0x064340..0x06437B  (59 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

064340  C8 06 00 00           ENTER  6, 0                         ; UNKNOWN
064344  53                    PUSH   bx                           ; UNKNOWN
064345  57                    PUSH   di                           ; UNKNOWN
064346  56                    PUSH   si                           ; UNKNOWN
064347  89 5E FE              MOV    word ptr [bp - 2], bx        ; UNKNOWN
06434A  2B F6                 SUB    si, si                       ; UNKNOWN
06434C  8B F8                 MOV    di, ax                       ; UNKNOWN
06434E  83 FE 4F              CMP    si, 0x4f                     ; UNKNOWN
064351  7D 18                 JGE    0x6436b                      ; UNKNOWN
064353  57                    PUSH   di                           ; UNKNOWN
064354  9A 16 07 65 5F        LCALL  0x5f65, 0x716                ; UNKNOWN
064359  83 C4 02              ADD    sp, 2                        ; UNKNOWN
06435C  8B C8                 MOV    cx, ax                       ; UNKNOWN
06435E  8B 5E FE              MOV    bx, word ptr [bp - 2]        ; UNKNOWN
064361  FF 46 FE              INC    word ptr [bp - 2]            ; UNKNOWN
064364  88 07                 MOV    byte ptr [bx], al            ; UNKNOWN
064366  46                    INC    si                           ; UNKNOWN
064367  0B C9                 OR     cx, cx                       ; UNKNOWN
064369  75 E3                 JNE    0x6434e                      ; UNKNOWN
06436B  57                    PUSH   di                           ; UNKNOWN
06436C  9A 16 07 65 5F        LCALL  0x5f65, 0x716                ; UNKNOWN
064371  83 C4 02              ADD    sp, 2                        ; UNKNOWN
064374  8B 46 F8              MOV    ax, word ptr [bp - 8]        ; UNKNOWN
064377  5E                    POP    si                           ; UNKNOWN
064378  5F                    POP    di                           ; UNKNOWN
064379  C9                    LEAVE                               ; UNKNOWN
06437A  CB                    RETF                                ; UNKNOWN
