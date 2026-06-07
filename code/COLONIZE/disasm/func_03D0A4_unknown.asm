; ============================================================================
; func_03D0A4_unknown
; Region   : load_image
; Bytes    : file 0x03D0A4..0x03D0C5  (33 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03D0A4  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
03D0A8  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
03D0AB  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
03D0AE  0E                    PUSH   cs                           ; UNKNOWN
03D0AF  E8 AF FF              CALL   0x3d061                      ; UNKNOWN
03D0B2  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03D0B5  0B C0                 OR     ax, ax                       ; UNKNOWN
03D0B7  7D 0A                 JGE    0x3d0c3                      ; UNKNOWN
03D0B9  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
03D0BC  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
03D0BF  0E                    PUSH   cs                           ; UNKNOWN
03D0C0  E8 D1 FE              CALL   0x3cf94                      ; UNKNOWN
03D0C3  C9                    LEAVE                               ; UNKNOWN
03D0C4  CB                    RETF                                ; UNKNOWN
