; ============================================================================
; func_068F4A_unknown
; Region   : load_image
; Bytes    : file 0x068F4A..0x068F6C  (34 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

068F4A  55                    PUSH   bp                           ; UNKNOWN
068F4B  8B EC                 MOV    bp, sp                       ; UNKNOWN
068F4D  56                    PUSH   si                           ; UNKNOWN
068F4E  57                    PUSH   di                           ; UNKNOWN
068F4F  8B 56 08              MOV    dx, word ptr [bp + 8]        ; UNKNOWN
068F52  0B D2                 OR     dx, dx                       ; UNKNOWN
068F54  7E 54                 JLE    0x68faa                      ; UNKNOWN
068F56  4A                    DEC    dx                           ; UNKNOWN
068F57  8B 5E 0A              MOV    bx, word ptr [bp + 0xa]      ; UNKNOWN
068F5A  1E                    PUSH   ds                           ; UNKNOWN
068F5B  07                    POP    es                           ; UNKNOWN
068F5C  8B 7E 06              MOV    di, word ptr [bp + 6]        ; UNKNOWN
068F5F  0B D2                 OR     dx, dx                       ; UNKNOWN
068F61  74 50                 JE     0x68fb3                      ; UNKNOWN
068F63  8B 4F 02              MOV    cx, word ptr [bx + 2]        ; UNKNOWN
068F66  E3 1E                 JCXZ   0x68f86                      ; UNKNOWN
068F68  3B CA                 CMP    cx, dx                       ; UNKNOWN
068F6A  76 02                 JBE    0x68f6e                      ; UNKNOWN
