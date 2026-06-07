; ============================================================================
; func_041B7D_unknown
; Region   : load_image
; Bytes    : file 0x041B7D..0x041BBF  (66 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

041B7D  55                    PUSH   bp                           ; UNKNOWN
041B7E  8B EC                 MOV    bp, sp                       ; UNKNOWN
041B80  1E                    PUSH   ds                           ; UNKNOWN
041B81  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
041B84  6A 00                 PUSH   0                            ; UNKNOWN
041B86  9A C9 03 97 1B        LCALL  0x1b97, 0x3c9                ; UNKNOWN
041B8B  8B E5                 MOV    sp, bp                       ; UNKNOWN
041B8D  8B 46 08              MOV    ax, word ptr [bp + 8]        ; UNKNOWN
041B90  99                    CDQ                                 ; UNKNOWN
041B91  A3 2A 3F              MOV    word ptr [0x3f2a], ax        ; UNKNOWN
041B94  89 16 2C 3F           MOV    word ptr [0x3f2c], dx        ; UNKNOWN
041B98  8B 46 0A              MOV    ax, word ptr [bp + 0xa]      ; UNKNOWN
041B9B  99                    CDQ                                 ; UNKNOWN
041B9C  A3 2E 3F              MOV    word ptr [0x3f2e], ax        ; UNKNOWN
041B9F  89 16 30 3F           MOV    word ptr [0x3f30], dx        ; UNKNOWN
041BA3  8B 46 0C              MOV    ax, word ptr [bp + 0xc]      ; UNKNOWN
041BA6  99                    CDQ                                 ; UNKNOWN
041BA7  A3 32 3F              MOV    word ptr [0x3f32], ax        ; UNKNOWN
041BAA  89 16 34 3F           MOV    word ptr [0x3f34], dx        ; UNKNOWN
041BAE  8D 1E 75 27           LEA    bx, [0x2775]                 ; UNKNOWN
041BB2  8D 06 6E 27           LEA    ax, [0x276e]                 ; UNKNOWN
041BB6  2B D2                 SUB    dx, dx                       ; UNKNOWN
041BB8  9A 6F 36 97 1B        LCALL  0x1b97, 0x366f               ; UNKNOWN
041BBD  C9                    LEAVE                               ; UNKNOWN
041BBE  CB                    RETF                                ; UNKNOWN
