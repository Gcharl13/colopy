; ============================================================================
; func_02B4F5_unknown
; Region   : load_image
; Bytes    : file 0x02B4F5..0x02B55E  (105 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02B4F5  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
02B4F9  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
02B4FC  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
02B4FF  0E                    PUSH   cs                           ; UNKNOWN
02B500  E8 93 FF              CALL   0x2b496                      ; UNKNOWN
02B503  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02B506  0B 46 0A              OR     ax, word ptr [bp + 0xa]      ; UNKNOWN
02B509  50                    PUSH   ax                           ; UNKNOWN
02B50A  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
02B50D  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
02B510  0E                    PUSH   cs                           ; UNKNOWN
02B511  E8 AE FF              CALL   0x2b4c2                      ; UNKNOWN
02B514  83 C4 06              ADD    sp, 6                        ; UNKNOWN
02B517  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
02B51A  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
02B51D  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
02B520  0E                    PUSH   cs                           ; UNKNOWN
02B521  E8 72 FF              CALL   0x2b496                      ; UNKNOWN
02B524  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02B527  0B 46 0A              OR     ax, word ptr [bp + 0xa]      ; UNKNOWN
02B52A  50                    PUSH   ax                           ; UNKNOWN
02B52B  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
02B52E  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
02B531  0E                    PUSH   cs                           ; UNKNOWN
02B532  E8 8D FF              CALL   0x2b4c2                      ; UNKNOWN
02B535  83 C4 06              ADD    sp, 6                        ; UNKNOWN
02B538  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
02B53B  23 46 0A              AND    ax, word ptr [bp + 0xa]      ; UNKNOWN
02B53E  8B 4E 0A              MOV    cx, word ptr [bp + 0xa]      ; UNKNOWN
02B541  23 4E FE              AND    cx, word ptr [bp - 2]        ; UNKNOWN
02B544  3B C1                 CMP    ax, cx                       ; UNKNOWN
02B546  74 11                 JE     0x2b559                      ; UNKNOWN
02B548  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
02B54B  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
02B54E  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
02B551  68 22 1D              PUSH   0x1d22                       ; UNKNOWN
02B554  9A DD 00 AA 38        LCALL  0x38aa, 0xdd                 ; UNKNOWN
02B559  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
02B55C  C9                    LEAVE                               ; UNKNOWN
02B55D  CB                    RETF                                ; UNKNOWN
