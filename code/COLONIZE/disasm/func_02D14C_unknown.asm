; ============================================================================
; func_02D14C_unknown
; Region   : load_image
; Bytes    : file 0x02D14C..0x02D16D  (33 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02D14C  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
02D150  57                    PUSH   di                           ; UNKNOWN
02D151  56                    PUSH   si                           ; UNKNOWN
02D152  8B 56 08              MOV    dx, word ptr [bp + 8]        ; UNKNOWN
02D155  0B D2                 OR     dx, dx                       ; UNKNOWN
02D157  7E 10                 JLE    0x2d169                      ; UNKNOWN
02D159  8B F2                 MOV    si, dx                       ; UNKNOWN
02D15B  8B 7E 06              MOV    di, word ptr [bp + 6]        ; UNKNOWN
02D15E  57                    PUSH   di                           ; UNKNOWN
02D15F  0E                    PUSH   cs                           ; UNKNOWN
02D160  E8 D9 FF              CALL   0x2d13c                      ; UNKNOWN
02D163  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02D166  4E                    DEC    si                           ; UNKNOWN
02D167  75 F5                 JNE    0x2d15e                      ; UNKNOWN
02D169  5E                    POP    si                           ; UNKNOWN
02D16A  5F                    POP    di                           ; UNKNOWN
02D16B  C9                    LEAVE                               ; UNKNOWN
02D16C  CB                    RETF                                ; UNKNOWN
