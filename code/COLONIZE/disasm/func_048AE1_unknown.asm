; ============================================================================
; func_048AE1_unknown
; Region   : load_image
; Bytes    : file 0x048AE1..0x048AFB  (26 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

048AE1  55                    PUSH   bp                           ; UNKNOWN
048AE2  8B EC                 MOV    bp, sp                       ; UNKNOWN
048AE4  56                    PUSH   si                           ; UNKNOWN
048AE5  81 3E 3E C6 D8 00     CMP    word ptr [0xc63e], 0xd8      ; UNKNOWN
048AEB  7D 2C                 JGE    0x48b19                      ; UNKNOWN
048AED  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
048AF0  8B 1E 3E C6           MOV    bx, word ptr [0xc63e]        ; UNKNOWN
048AF4  D1 E3                 SHL    bx, 1                        ; UNKNOWN
048AF6  C4 36 CA 0B           LES    si, ptr [0xbca]              ; UNKNOWN
048AFA  26                    DB     0x26                         ; UNKNOWN (raw)
