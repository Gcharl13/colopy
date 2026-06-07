; ============================================================================
; func_032E63_unknown
; Region   : load_image
; Bytes    : file 0x032E63..0x032E7B  (24 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

032E63  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
032E67  56                    PUSH   si                           ; UNKNOWN
032E68  8B 1E A8 74           MOV    bx, word ptr [0x74a8]        ; UNKNOWN
032E6C  8B 76 06              MOV    si, word ptr [bp + 6]        ; UNKNOWN
032E6F  8A 40 4C              MOV    al, byte ptr [bx + si + 0x4c] ; UNKNOWN
032E72  98                    CWDE                                ; UNKNOWN
032E73  48                    DEC    ax                           ; UNKNOWN
032E74  79 02                 JNS    0x32e78                      ; UNKNOWN
032E76  2B C0                 SUB    ax, ax                       ; UNKNOWN
032E78  5E                    POP    si                           ; UNKNOWN
032E79  C9                    LEAVE                               ; UNKNOWN
032E7A  CB                    RETF                                ; UNKNOWN
