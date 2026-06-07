; ============================================================================
; func_0674CC_unknown
; Region   : load_image
; Bytes    : file 0x0674CC..0x0674E7  (27 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0674CC  C8 00 00 00           ENTER  0, 0                         ; UNKNOWN
0674D0  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
0674D3  A3 DC CE              MOV    word ptr [0xcedc], ax        ; UNKNOWN
0674D6  EB 00                 JMP    0x674d8                      ; UNKNOWN
0674D8  83 7E 08 00           CMP    word ptr [bp + 8], 0         ; UNKNOWN
0674DC  74 07                 JE     0x674e5                      ; UNKNOWN
0674DE  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
0674E1  32 E4                 XOR    ah, ah                       ; UNKNOWN
0674E3  CD 10                 INT    0x10                         ; UNKNOWN
0674E5  C9                    LEAVE                               ; UNKNOWN
0674E6  CB                    RETF                                ; UNKNOWN
