; ============================================================================
; func_02B431_unknown
; Region   : load_image
; Bytes    : file 0x02B431..0x02B458  (39 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02B431  55                    PUSH   bp                           ; UNKNOWN
02B432  8B EC                 MOV    bp, sp                       ; UNKNOWN
02B434  56                    PUSH   si                           ; UNKNOWN
02B435  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
02B438  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
02B43B  9A 04 01 C9 33        LCALL  0x33c9, 0x104                ; UNKNOWN
02B440  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02B443  2A E4                 SUB    ah, ah                       ; UNKNOWN
02B445  24 1F                 AND    al, 0x1f                     ; UNKNOWN
02B447  8B F0                 MOV    si, ax                       ; UNKNOWN
02B449  83 FE 19              CMP    si, 0x19                     ; UNKNOWN
02B44C  74 0A                 JE     0x2b458                      ; UNKNOWN
02B44E  83 FE 1A              CMP    si, 0x1a                     ; UNKNOWN
02B451  74 05                 JE     0x2b458                      ; UNKNOWN
02B453  2B C0                 SUB    ax, ax                       ; UNKNOWN
02B455  5E                    POP    si                           ; UNKNOWN
02B456  C9                    LEAVE                               ; UNKNOWN
02B457  CB                    RETF                                ; UNKNOWN
