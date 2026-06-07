; ============================================================================
; func_06A02C_unknown
; Region   : load_image
; Bytes    : file 0x06A02C..0x06A058  (44 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06A02C  55                    PUSH   bp                           ; UNKNOWN
06A02D  8B EC                 MOV    bp, sp                       ; UNKNOWN
06A02F  56                    PUSH   si                           ; UNKNOWN
06A030  8B 76 04              MOV    si, word ptr [bp + 4]        ; UNKNOWN
06A033  8A 44 06              MOV    al, byte ptr [si + 6]        ; UNKNOWN
06A036  A8 83                 TEST   al, 0x83                     ; UNKNOWN
06A038  74 1B                 JE     0x6a055                      ; UNKNOWN
06A03A  A8 08                 TEST   al, 8                        ; UNKNOWN
06A03C  74 17                 JE     0x6a055                      ; UNKNOWN
06A03E  FF 74 04              PUSH   word ptr [si + 4]            ; UNKNOWN
06A041  9A A8 2B 65 5F        LCALL  0x5f65, 0x2ba8               ; UNKNOWN
06A046  59                    POP    cx                           ; UNKNOWN
06A047  80 64 06 F7           AND    byte ptr [si + 6], 0xf7      ; UNKNOWN
06A04B  33 C0                 XOR    ax, ax                       ; UNKNOWN
06A04D  89 44 04              MOV    word ptr [si + 4], ax        ; UNKNOWN
06A050  89 04                 MOV    word ptr [si], ax            ; UNKNOWN
06A052  89 44 02              MOV    word ptr [si + 2], ax        ; UNKNOWN
06A055  5E                    POP    si                           ; UNKNOWN
06A056  5D                    POP    bp                           ; UNKNOWN
06A057  C3                    RET                                 ; UNKNOWN
