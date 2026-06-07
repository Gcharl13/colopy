; ============================================================================
; func_063ACB_unknown
; Region   : load_image
; Bytes    : file 0x063ACB..0x063B02  (55 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

063ACB  55                    PUSH   bp                           ; UNKNOWN
063ACC  8B EC                 MOV    bp, sp                       ; UNKNOWN
063ACE  53                    PUSH   bx                           ; UNKNOWN
063ACF  56                    PUSH   si                           ; UNKNOWN
063AD0  8B F0                 MOV    si, ax                       ; UNKNOWN
063AD2  8D 46 08              LEA    ax, [bp + 8]                 ; UNKNOWN
063AD5  50                    PUSH   ax                           ; UNKNOWN
063AD6  8D 46 06              LEA    ax, [bp + 6]                 ; UNKNOWN
063AD9  50                    PUSH   ax                           ; UNKNOWN
063ADA  8B 5E FE              MOV    bx, word ptr [bp - 2]        ; UNKNOWN
063ADD  8D 46 0C              LEA    ax, [bp + 0xc]               ; UNKNOWN
063AE0  8D 56 0A              LEA    dx, [bp + 0xa]               ; UNKNOWN
063AE3  9A 14 00 97 5A        LCALL  0x5a97, 0x14                 ; UNKNOWN
063AE8  0B C0                 OR     ax, ax                       ; UNKNOWN
063AEA  75 7B                 JNE    0x63b67                      ; UNKNOWN
063AEC  8B C6                 MOV    ax, si                       ; UNKNOWN
063AEE  83 E8 ED              SUB    ax, -0x13                    ; UNKNOWN
063AF1  7C 74                 JL     0x63b67                      ; UNKNOWN
063AF3  83 E8 09              SUB    ax, 9                        ; UNKNOWN
063AF6  7E 0A                 JLE    0x63b02                      ; UNKNOWN
063AF8  83 E8 09              SUB    ax, 9                        ; UNKNOWN
063AFB  74 28                 JE     0x63b25                      ; UNKNOWN
063AFD  5E                    POP    si                           ; UNKNOWN
063AFE  C9                    LEAVE                               ; UNKNOWN
063AFF  CA 08 00              RETF   8                            ; UNKNOWN
