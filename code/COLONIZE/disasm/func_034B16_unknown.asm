; ============================================================================
; func_034B16_unknown
; Region   : load_image
; Bytes    : file 0x034B16..0x034B31  (27 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

034B16  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
034B1A  56                    PUSH   si                           ; UNKNOWN
034B1B  8B 1E A8 74           MOV    bx, word ptr [0x74a8]        ; UNKNOWN
034B1F  8B 76 06              MOV    si, word ptr [bp + 6]        ; UNKNOWN
034B22  8A 40 4C              MOV    al, byte ptr [bx + si + 0x4c] ; UNKNOWN
034B25  98                    CWDE                                ; UNKNOWN
034B26  48                    DEC    ax                           ; UNKNOWN
034B27  79 02                 JNS    0x34b2b                      ; UNKNOWN
034B29  2B C0                 SUB    ax, ax                       ; UNKNOWN
034B2B  88 40 4C              MOV    byte ptr [bx + si + 0x4c], al ; UNKNOWN
034B2E  5E                    POP    si                           ; UNKNOWN
034B2F  C9                    LEAVE                               ; UNKNOWN
034B30  CB                    RETF                                ; UNKNOWN
