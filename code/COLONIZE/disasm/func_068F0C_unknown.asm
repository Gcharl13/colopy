; ============================================================================
; func_068F0C_unknown
; Region   : load_image
; Bytes    : file 0x068F0C..0x068F20  (20 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

068F0C  55                    PUSH   bp                           ; UNKNOWN
068F0D  8B EC                 MOV    bp, sp                       ; UNKNOWN
068F0F  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
068F12  F6 87 BB 13 02        TEST   byte ptr [bx + 0x13bb], 2    ; UNKNOWN
068F17  74 05                 JE     0x68f1e                      ; UNKNOWN
068F19  8D 47 E0              LEA    ax, [bx - 0x20]              ; UNKNOWN
068F1C  EB 02                 JMP    0x68f20                      ; UNKNOWN
068F1E  8B C3                 MOV    ax, bx                       ; UNKNOWN
