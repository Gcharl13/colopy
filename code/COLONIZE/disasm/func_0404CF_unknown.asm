; ============================================================================
; func_0404CF_unknown
; Region   : load_image
; Bytes    : file 0x0404CF..0x0404F9  (42 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0404CF  55                    PUSH   bp                           ; UNKNOWN
0404D0  8B EC                 MOV    bp, sp                       ; UNKNOWN
0404D2  56                    PUSH   si                           ; UNKNOWN
0404D3  8B 76 06              MOV    si, word ptr [bp + 6]        ; UNKNOWN
0404D6  8B C6                 MOV    ax, si                       ; UNKNOWN
0404D8  0E                    PUSH   cs                           ; UNKNOWN
0404D9  E8 9C F6              CALL   0x3fb78                      ; UNKNOWN
0404DC  8B F0                 MOV    si, ax                       ; UNKNOWN
0404DE  0B F6                 OR     si, si                       ; UNKNOWN
0404E0  7C 14                 JL     0x404f6                      ; UNKNOWN
0404E2  56                    PUSH   si                           ; UNKNOWN
0404E3  0E                    PUSH   cs                           ; UNKNOWN
0404E4  E8 D4 FF              CALL   0x404bb                      ; UNKNOWN
0404E7  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0404EA  8B C6                 MOV    ax, si                       ; UNKNOWN
0404EC  0E                    PUSH   cs                           ; UNKNOWN
0404ED  E8 CE F6              CALL   0x3fbbe                      ; UNKNOWN
0404F0  8B F0                 MOV    si, ax                       ; UNKNOWN
0404F2  0B F6                 OR     si, si                       ; UNKNOWN
0404F4  7D EC                 JGE    0x404e2                      ; UNKNOWN
0404F6  5E                    POP    si                           ; UNKNOWN
0404F7  C9                    LEAVE                               ; UNKNOWN
0404F8  CB                    RETF                                ; UNKNOWN
