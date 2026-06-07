; ============================================================================
; func_03D0C5_unknown
; Region   : load_image
; Bytes    : file 0x03D0C5..0x03D0E6  (33 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03D0C5  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
03D0C9  56                    PUSH   si                           ; UNKNOWN
03D0CA  C7 46 FC FF FF        MOV    word ptr [bp - 4], 0xffff    ; UNKNOWN
03D0CF  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
03D0D2  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
03D0D5  0E                    PUSH   cs                           ; UNKNOWN
03D0D6  E8 B9 FB              CALL   0x3cc92                      ; UNKNOWN
03D0D9  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03D0DC  0B C0                 OR     ax, ax                       ; UNKNOWN
03D0DE  75 06                 JNE    0x3d0e6                      ; UNKNOWN
03D0E0  B8 FF FF              MOV    ax, 0xffff                   ; UNKNOWN
03D0E3  5E                    POP    si                           ; UNKNOWN
03D0E4  C9                    LEAVE                               ; UNKNOWN
03D0E5  CB                    RETF                                ; UNKNOWN
