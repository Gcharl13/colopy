; ============================================================================
; func_04E2EB_unknown
; Region   : load_image
; Bytes    : file 0x04E2EB..0x04E304  (25 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04E2EB  55                    PUSH   bp                           ; UNKNOWN
04E2EC  8B EC                 MOV    bp, sp                       ; UNKNOWN
04E2EE  83 7E 06 11           CMP    word ptr [bp + 6], 0x11      ; UNKNOWN
04E2F2  74 06                 JE     0x4e2fa                      ; UNKNOWN
04E2F4  83 7E 06 09           CMP    word ptr [bp + 6], 9         ; UNKNOWN
04E2F8  75 0A                 JNE    0x4e304                      ; UNKNOWN
04E2FA  C7 46 06 08 00        MOV    word ptr [bp + 6], 8         ; UNKNOWN
04E2FF  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
04E302  C9                    LEAVE                               ; UNKNOWN
04E303  CB                    RETF                                ; UNKNOWN
