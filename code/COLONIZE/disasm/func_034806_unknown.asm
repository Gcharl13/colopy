; ============================================================================
; func_034806_unknown
; Region   : load_image
; Bytes    : file 0x034806..0x034829  (35 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

034806  55                    PUSH   bp                           ; UNKNOWN
034807  8B EC                 MOV    bp, sp                       ; UNKNOWN
034809  6A 01                 PUSH   1                            ; UNKNOWN
03480B  9A BD 00 2B 3E        LCALL  0x3e2b, 0xbd                 ; UNKNOWN
034810  8B E5                 MOV    sp, bp                       ; UNKNOWN
034812  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
034815  0E                    PUSH   cs                           ; UNKNOWN
034816  E8 DA FF              CALL   0x347f3                      ; UNKNOWN
034819  8B E5                 MOV    sp, bp                       ; UNKNOWN
03481B  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
03481E  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
034821  6A 03                 PUSH   3                            ; UNKNOWN
034823  0E                    PUSH   cs                           ; UNKNOWN
034824  E8 AC FF              CALL   0x347d3                      ; UNKNOWN
034827  C9                    LEAVE                               ; UNKNOWN
034828  CB                    RETF                                ; UNKNOWN
