; ============================================================================
; func_068D66_unknown
; Region   : load_image
; Bytes    : file 0x068D66..0x068D84  (30 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

068D66  55                    PUSH   bp                           ; UNKNOWN
068D67  8B EC                 MOV    bp, sp                       ; UNKNOWN
068D69  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
068D6C  FF 4F 02              DEC    word ptr [bx + 2]            ; UNKNOWN
068D6F  78 0B                 JS     0x68d7c                      ; UNKNOWN
068D71  FF 07                 INC    word ptr [bx]                ; UNKNOWN
068D73  8B 1F                 MOV    bx, word ptr [bx]            ; UNKNOWN
068D75  8A 47 FF              MOV    al, byte ptr [bx - 1]        ; UNKNOWN
068D78  32 E4                 XOR    ah, ah                       ; UNKNOWN
068D7A  EB 06                 JMP    0x68d82                      ; UNKNOWN
068D7C  53                    PUSH   bx                           ; UNKNOWN
068D7D  0E                    PUSH   cs                           ; UNKNOWN
068D7E  E8 31 11              CALL   0x69eb2                      ; UNKNOWN
068D81  5B                    POP    bx                           ; UNKNOWN
068D82  5D                    POP    bp                           ; UNKNOWN
068D83  CB                    RETF                                ; UNKNOWN
