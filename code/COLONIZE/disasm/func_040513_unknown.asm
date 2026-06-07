; ============================================================================
; func_040513_unknown
; Region   : load_image
; Bytes    : file 0x040513..0x040543  (48 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

040513  55                    PUSH   bp                           ; UNKNOWN
040514  8B EC                 MOV    bp, sp                       ; UNKNOWN
040516  57                    PUSH   di                           ; UNKNOWN
040517  56                    PUSH   si                           ; UNKNOWN
040518  8B 76 06              MOV    si, word ptr [bp + 6]        ; UNKNOWN
04051B  8B C6                 MOV    ax, si                       ; UNKNOWN
04051D  0E                    PUSH   cs                           ; UNKNOWN
04051E  E8 57 F6              CALL   0x3fb78                      ; UNKNOWN
040521  8B F0                 MOV    si, ax                       ; UNKNOWN
040523  0B F6                 OR     si, si                       ; UNKNOWN
040525  7C 18                 JL     0x4053f                      ; UNKNOWN
040527  8B 7E 08              MOV    di, word ptr [bp + 8]        ; UNKNOWN
04052A  57                    PUSH   di                           ; UNKNOWN
04052B  56                    PUSH   si                           ; UNKNOWN
04052C  0E                    PUSH   cs                           ; UNKNOWN
04052D  E8 C9 FF              CALL   0x404f9                      ; UNKNOWN
040530  83 C4 04              ADD    sp, 4                        ; UNKNOWN
040533  8B C6                 MOV    ax, si                       ; UNKNOWN
040535  0E                    PUSH   cs                           ; UNKNOWN
040536  E8 85 F6              CALL   0x3fbbe                      ; UNKNOWN
040539  8B F0                 MOV    si, ax                       ; UNKNOWN
04053B  0B F6                 OR     si, si                       ; UNKNOWN
04053D  7D EB                 JGE    0x4052a                      ; UNKNOWN
04053F  5E                    POP    si                           ; UNKNOWN
040540  5F                    POP    di                           ; UNKNOWN
040541  C9                    LEAVE                               ; UNKNOWN
040542  CB                    RETF                                ; UNKNOWN
