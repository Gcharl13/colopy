; ============================================================================
; func_02B3F8_unknown
; Region   : load_image
; Bytes    : file 0x02B3F8..0x02B431  (57 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02B3F8  55                    PUSH   bp                           ; UNKNOWN
02B3F9  8B EC                 MOV    bp, sp                       ; UNKNOWN
02B3FB  57                    PUSH   di                           ; UNKNOWN
02B3FC  56                    PUSH   si                           ; UNKNOWN
02B3FD  8B 7E 08              MOV    di, word ptr [bp + 8]        ; UNKNOWN
02B400  BE 19 00              MOV    si, 0x19                     ; UNKNOWN
02B403  57                    PUSH   di                           ; UNKNOWN
02B404  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
02B407  9A 02 00 C9 33        LCALL  0x33c9, 2                    ; UNKNOWN
02B40C  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02B40F  0B C0                 OR     ax, ax                       ; UNKNOWN
02B411  74 18                 JE     0x2b42b                      ; UNKNOWN
02B413  57                    PUSH   di                           ; UNKNOWN
02B414  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
02B417  9A 04 01 C9 33        LCALL  0x33c9, 0x104                ; UNKNOWN
02B41C  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02B41F  2A E4                 SUB    ah, ah                       ; UNKNOWN
02B421  50                    PUSH   ax                           ; UNKNOWN
02B422  0E                    PUSH   cs                           ; UNKNOWN
02B423  E8 A8 FF              CALL   0x2b3ce                      ; UNKNOWN
02B426  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02B429  8B F0                 MOV    si, ax                       ; UNKNOWN
02B42B  8B C6                 MOV    ax, si                       ; UNKNOWN
02B42D  5E                    POP    si                           ; UNKNOWN
02B42E  5F                    POP    di                           ; UNKNOWN
02B42F  C9                    LEAVE                               ; UNKNOWN
02B430  CB                    RETF                                ; UNKNOWN
