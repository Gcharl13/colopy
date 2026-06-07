; ============================================================================
; func_016B38_unknown
; Region   : load_image
; Bytes    : file 0x016B38..0x016B79  (65 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

016B38  55                    PUSH   bp                           ; UNKNOWN
016B39  8B EC                 MOV    bp, sp                       ; UNKNOWN
016B3B  A1 36 08              MOV    ax, word ptr [0x836]         ; UNKNOWN
016B3E  39 46 06              CMP    word ptr [bp + 6], ax        ; UNKNOWN
016B41  74 34                 JE     0x16b77                      ; UNKNOWN
016B43  0B C0                 OR     ax, ax                       ; UNKNOWN
016B45  7C 14                 JL     0x16b5b                      ; UNKNOWN
016B47  9A 42 00 BB 0D        LCALL  0xdbb, 0x42                  ; UNKNOWN
016B4C  8B 1E 36 08           MOV    bx, word ptr [0x836]         ; UNKNOWN
016B50  C1 E3 02              SHL    bx, 2                        ; UNKNOWN
016B53  89 87 98 D3           MOV    word ptr [bx - 0x2c68], ax   ; UNKNOWN
016B57  89 97 9A D3           MOV    word ptr [bx - 0x2c66], dx   ; UNKNOWN
016B5B  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
016B5E  A3 36 08              MOV    word ptr [0x836], ax         ; UNKNOWN
016B61  0B C0                 OR     ax, ax                       ; UNKNOWN
016B63  7C 12                 JL     0x16b77                      ; UNKNOWN
016B65  8B D8                 MOV    bx, ax                       ; UNKNOWN
016B67  C1 E3 02              SHL    bx, 2                        ; UNKNOWN
016B6A  FF B7 9A D3           PUSH   word ptr [bx - 0x2c66]       ; UNKNOWN
016B6E  FF B7 98 D3           PUSH   word ptr [bx - 0x2c68]       ; UNKNOWN
016B72  9A 30 00 BB 0D        LCALL  0xdbb, 0x30                  ; UNKNOWN
016B77  C9                    LEAVE                               ; UNKNOWN
016B78  CB                    RETF                                ; UNKNOWN
