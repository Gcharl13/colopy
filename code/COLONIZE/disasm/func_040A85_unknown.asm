; ============================================================================
; func_040A85_unknown
; Region   : load_image
; Bytes    : file 0x040A85..0x040AB8  (51 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

040A85  55                    PUSH   bp                           ; UNKNOWN
040A86  8B EC                 MOV    bp, sp                       ; UNKNOWN
040A88  57                    PUSH   di                           ; UNKNOWN
040A89  56                    PUSH   si                           ; UNKNOWN
040A8A  8B 7E 06              MOV    di, word ptr [bp + 6]        ; UNKNOWN
040A8D  8B C7                 MOV    ax, di                       ; UNKNOWN
040A8F  0E                    PUSH   cs                           ; UNKNOWN
040A90  E8 E5 F0              CALL   0x3fb78                      ; UNKNOWN
040A93  8B F8                 MOV    di, ax                       ; UNKNOWN
040A95  0B FF                 OR     di, di                       ; UNKNOWN
040A97  7C 1B                 JL     0x40ab4                      ; UNKNOWN
040A99  8B C7                 MOV    ax, di                       ; UNKNOWN
040A9B  0E                    PUSH   cs                           ; UNKNOWN
040A9C  E8 1F F1              CALL   0x3fbbe                      ; UNKNOWN
040A9F  8B F0                 MOV    si, ax                       ; UNKNOWN
040AA1  57                    PUSH   di                           ; UNKNOWN
040AA2  0E                    PUSH   cs                           ; UNKNOWN
040AA3  E8 E6 F8              CALL   0x4038c                      ; UNKNOWN
040AA6  83 C4 02              ADD    sp, 2                        ; UNKNOWN
040AA9  3B FE                 CMP    di, si                       ; UNKNOWN
040AAB  7D 01                 JGE    0x40aae                      ; UNKNOWN
040AAD  4E                    DEC    si                           ; UNKNOWN
040AAE  8B FE                 MOV    di, si                       ; UNKNOWN
040AB0  0B FF                 OR     di, di                       ; UNKNOWN
040AB2  7D E5                 JGE    0x40a99                      ; UNKNOWN
040AB4  5E                    POP    si                           ; UNKNOWN
040AB5  5F                    POP    di                           ; UNKNOWN
040AB6  C9                    LEAVE                               ; UNKNOWN
040AB7  CB                    RETF                                ; UNKNOWN
