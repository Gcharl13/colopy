; ============================================================================
; func_03FED1_unknown
; Region   : load_image
; Bytes    : file 0x03FED1..0x03FEED  (28 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03FED1  55                    PUSH   bp                           ; UNKNOWN
03FED2  8B EC                 MOV    bp, sp                       ; UNKNOWN
03FED4  56                    PUSH   si                           ; UNKNOWN
03FED5  8B 76 06              MOV    si, word ptr [bp + 6]        ; UNKNOWN
03FED8  8B C6                 MOV    ax, si                       ; UNKNOWN
03FEDA  0E                    PUSH   cs                           ; UNKNOWN
03FEDB  E8 CD FE              CALL   0x3fdab                      ; UNKNOWN
03FEDE  8B C6                 MOV    ax, si                       ; UNKNOWN
03FEE0  8B 56 08              MOV    dx, word ptr [bp + 8]        ; UNKNOWN
03FEE3  8B 5E 0A              MOV    bx, word ptr [bp + 0xa]      ; UNKNOWN
03FEE6  0E                    PUSH   cs                           ; UNKNOWN
03FEE7  E8 50 FF              CALL   0x3fe3a                      ; UNKNOWN
03FEEA  5E                    POP    si                           ; UNKNOWN
03FEEB  C9                    LEAVE                               ; UNKNOWN
03FEEC  CB                    RETF                                ; UNKNOWN
