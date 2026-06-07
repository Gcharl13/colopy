; ============================================================================
; func_03CF94_unknown
; Region   : load_image
; Bytes    : file 0x03CF94..0x03CFB3  (31 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03CF94  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
03CF98  C7 46 FE FF FF        MOV    word ptr [bp - 2], 0xffff    ; UNKNOWN
03CF9D  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
03CFA0  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
03CFA3  0E                    PUSH   cs                           ; UNKNOWN
03CFA4  E8 EB FC              CALL   0x3cc92                      ; UNKNOWN
03CFA7  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03CFAA  0B C0                 OR     ax, ax                       ; UNKNOWN
03CFAC  75 05                 JNE    0x3cfb3                      ; UNKNOWN
03CFAE  B8 FF FF              MOV    ax, 0xffff                   ; UNKNOWN
03CFB1  C9                    LEAVE                               ; UNKNOWN
03CFB2  CB                    RETF                                ; UNKNOWN
