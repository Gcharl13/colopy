; ============================================================================
; func_025256_unknown
; Region   : load_image
; Bytes    : file 0x025256..0x02527C  (38 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

025256  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
02525A  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
02525D  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
025260  8B 46 0A              MOV    ax, word ptr [bp + 0xa]      ; UNKNOWN
025263  0E                    PUSH   cs                           ; UNKNOWN
025264  E8 91 FF              CALL   0x251f8                      ; UNKNOWN
025267  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
02526A  89 56 FE              MOV    word ptr [bp - 2], dx        ; UNKNOWN
02526D  83 7E 0C 00           CMP    word ptr [bp + 0xc], 0       ; UNKNOWN
025271  74 09                 JE     0x2527c                      ; UNKNOWN
025273  C4 5E FC              LES    bx, ptr [bp - 4]             ; UNKNOWN
025276  26 80 0F 01           OR     byte ptr es:[bx], 1          ; UNKNOWN
02527A  C9                    LEAVE                               ; UNKNOWN
02527B  CB                    RETF                                ; UNKNOWN
