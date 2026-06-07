; ============================================================================
; func_063FD6_unknown
; Region   : load_image
; Bytes    : file 0x063FD6..0x064003  (45 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

063FD6  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
063FDA  56                    PUSH   si                           ; UNKNOWN
063FDB  6A 0A                 PUSH   0xa                          ; UNKNOWN
063FDD  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
063FE0  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
063FE3  9A F6 13 65 5F        LCALL  0x5f65, 0x13f6               ; UNKNOWN
063FE8  83 C4 06              ADD    sp, 6                        ; UNKNOWN
063FEB  8B F0                 MOV    si, ax                       ; UNKNOWN
063FED  89 56 FE              MOV    word ptr [bp - 2], dx        ; UNKNOWN
063FF0  0B D0                 OR     dx, ax                       ; UNKNOWN
063FF2  74 07                 JE     0x63ffb                      ; UNKNOWN
063FF4  8E 46 FE              MOV    es, word ptr [bp - 2]        ; UNKNOWN
063FF7  26 C6 04 00           MOV    byte ptr es:[si], 0          ; UNKNOWN
063FFB  8B 56 FE              MOV    dx, word ptr [bp - 2]        ; UNKNOWN
063FFE  5E                    POP    si                           ; UNKNOWN
063FFF  C9                    LEAVE                               ; UNKNOWN
064000  CA 04 00              RETF   4                            ; UNKNOWN
