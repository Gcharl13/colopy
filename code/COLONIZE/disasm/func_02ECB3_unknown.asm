; ============================================================================
; func_02ECB3_unknown
; Region   : load_image
; Bytes    : file 0x02ECB3..0x02ECF2  (63 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02ECB3  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
02ECB7  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
02ECBC  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
02ECBF  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
02ECC2  9A 02 00 C9 33        LCALL  0x33c9, 2                    ; UNKNOWN
02ECC7  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02ECCA  0B C0                 OR     ax, ax                       ; UNKNOWN
02ECCC  74 1F                 JE     0x2eced                      ; UNKNOWN
02ECCE  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
02ECD1  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
02ECD4  9A 04 01 C9 33        LCALL  0x33c9, 0x104                ; UNKNOWN
02ECD9  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02ECDC  24 1F                 AND    al, 0x1f                     ; UNKNOWN
02ECDE  3A 46 0A              CMP    al, byte ptr [bp + 0xa]      ; UNKNOWN
02ECE1  72 0A                 JB     0x2eced                      ; UNKNOWN
02ECE3  3A 46 0C              CMP    al, byte ptr [bp + 0xc]      ; UNKNOWN
02ECE6  77 05                 JA     0x2eced                      ; UNKNOWN
02ECE8  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1         ; UNKNOWN
02ECED  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
02ECF0  C9                    LEAVE                               ; UNKNOWN
02ECF1  CB                    RETF                                ; UNKNOWN
