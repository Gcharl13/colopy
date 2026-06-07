; ============================================================================
; func_02D5AD_unknown
; Region   : load_image
; Bytes    : file 0x02D5AD..0x02D5F8  (75 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02D5AD  55                    PUSH   bp                           ; UNKNOWN
02D5AE  8B EC                 MOV    bp, sp                       ; UNKNOWN
02D5B0  57                    PUSH   di                           ; UNKNOWN
02D5B1  56                    PUSH   si                           ; UNKNOWN
02D5B2  8B 76 08              MOV    si, word ptr [bp + 8]        ; UNKNOWN
02D5B5  0B F6                 OR     si, si                       ; UNKNOWN
02D5B7  7C 0E                 JL     0x2d5c7                      ; UNKNOWN
02D5B9  8B 7E 06              MOV    di, word ptr [bp + 6]        ; UNKNOWN
02D5BC  8B DE                 MOV    bx, si                       ; UNKNOWN
02D5BE  C1 E3 04              SHL    bx, 4                        ; UNKNOWN
02D5C1  FF B7 B4 34           PUSH   word ptr [bx + 0x34b4]       ; UNKNOWN
02D5C5  EB 07                 JMP    0x2d5ce                      ; UNKNOWN
02D5C7  8B 7E 06              MOV    di, word ptr [bp + 6]        ; UNKNOWN
02D5CA  FF 36 4A 33           PUSH   word ptr [0x334a]            ; UNKNOWN
02D5CE  57                    PUSH   di                           ; UNKNOWN
02D5CF  0E                    PUSH   cs                           ; UNKNOWN
02D5D0  E8 4A FC              CALL   0x2d21d                      ; UNKNOWN
02D5D3  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02D5D6  83 FE 08              CMP    si, 8                        ; UNKNOWN
02D5D9  7C 19                 JL     0x2d5f4                      ; UNKNOWN
02D5DB  83 FE 18              CMP    si, 0x18                     ; UNKNOWN
02D5DE  7D 14                 JGE    0x2d5f4                      ; UNKNOWN
02D5E0  57                    PUSH   di                           ; UNKNOWN
02D5E1  0E                    PUSH   cs                           ; UNKNOWN
02D5E2  E8 57 FB              CALL   0x2d13c                      ; UNKNOWN
02D5E5  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02D5E8  FF 36 F0 32           PUSH   word ptr [0x32f0]            ; UNKNOWN
02D5EC  57                    PUSH   di                           ; UNKNOWN
02D5ED  0E                    PUSH   cs                           ; UNKNOWN
02D5EE  E8 2C FC              CALL   0x2d21d                      ; UNKNOWN
02D5F1  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02D5F4  5E                    POP    si                           ; UNKNOWN
02D5F5  5F                    POP    di                           ; UNKNOWN
02D5F6  C9                    LEAVE                               ; UNKNOWN
02D5F7  CB                    RETF                                ; UNKNOWN
