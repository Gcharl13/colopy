; ============================================================================
; func_02DA1B_unknown
; Region   : load_image
; Bytes    : file 0x02DA1B..0x02DA3C  (33 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02DA1B  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
02DA1F  C7 46 FC FF FF        MOV    word ptr [bp - 4], 0xffff    ; UNKNOWN
02DA24  EB 25                 JMP    0x2da4b                      ; UNKNOWN
02DA26  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
02DA29  0E                    PUSH   cs                           ; UNKNOWN
02DA2A  E8 4B FF              CALL   0x2d978                      ; UNKNOWN
02DA2D  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02DA30  0B C0                 OR     ax, ax                       ; UNKNOWN
02DA32  74 1D                 JE     0x2da51                      ; UNKNOWN
02DA34  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
02DA37  89 5E FC              MOV    word ptr [bp - 4], bx        ; UNKNOWN
02DA3A  8B C3                 MOV    ax, bx                       ; UNKNOWN
