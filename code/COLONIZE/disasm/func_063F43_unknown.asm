; ============================================================================
; func_063F43_unknown
; Region   : load_image
; Bytes    : file 0x063F43..0x063F8C  (73 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

063F43  55                    PUSH   bp                           ; UNKNOWN
063F44  8B EC                 MOV    bp, sp                       ; UNKNOWN
063F46  57                    PUSH   di                           ; UNKNOWN
063F47  56                    PUSH   si                           ; UNKNOWN
063F48  8B 76 0A              MOV    si, word ptr [bp + 0xa]      ; UNKNOWN
063F4B  8E 46 0C              MOV    es, word ptr [bp + 0xc]      ; UNKNOWN
063F4E  26 80 3C 2A           CMP    byte ptr es:[si], 0x2a       ; UNKNOWN
063F52  75 03                 JNE    0x63f57                      ; UNKNOWN
063F54  46                    INC    si                           ; UNKNOWN
063F55  8C C0                 MOV    ax, es                       ; UNKNOWN
063F57  83 3E 1A 0C 00        CMP    word ptr [0xc1a], 0          ; UNKNOWN
063F5C  75 13                 JNE    0x63f71                      ; UNKNOWN
063F5E  8B 7E 06              MOV    di, word ptr [bp + 6]        ; UNKNOWN
063F61  06                    PUSH   es                           ; UNKNOWN
063F62  56                    PUSH   si                           ; UNKNOWN
063F63  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
063F66  57                    PUSH   di                           ; UNKNOWN
063F67  9A 8A 14 65 5F        LCALL  0x5f65, 0x148a               ; UNKNOWN
063F6C  83 C4 08              ADD    sp, 8                        ; UNKNOWN
063F6F  EB 12                 JMP    0x63f83                      ; UNKNOWN
063F71  8B 7E 06              MOV    di, word ptr [bp + 6]        ; UNKNOWN
063F74  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
063F77  57                    PUSH   di                           ; UNKNOWN
063F78  1E                    PUSH   ds                           ; UNKNOWN
063F79  68 46 CE              PUSH   0xce46                       ; UNKNOWN
063F7C  06                    PUSH   es                           ; UNKNOWN
063F7D  56                    PUSH   si                           ; UNKNOWN
063F7E  9A 04 00 9D 06        LCALL  0x69d, 4                     ; UNKNOWN
063F83  8B C7                 MOV    ax, di                       ; UNKNOWN
063F85  8B 56 08              MOV    dx, word ptr [bp + 8]        ; UNKNOWN
063F88  5E                    POP    si                           ; UNKNOWN
063F89  5F                    POP    di                           ; UNKNOWN
063F8A  C9                    LEAVE                               ; UNKNOWN
063F8B  CB                    RETF                                ; UNKNOWN
