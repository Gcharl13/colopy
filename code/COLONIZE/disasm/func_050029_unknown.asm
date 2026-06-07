; ============================================================================
; func_050029_unknown
; Region   : load_image
; Bytes    : file 0x050029..0x05006F  (70 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

050029  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
05002D  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
050032  EB 03                 JMP    0x50037                      ; UNKNOWN
050034  FF 46 FE              INC    word ptr [bp - 2]            ; UNKNOWN
050037  83 7E FE 40           CMP    word ptr [bp - 2], 0x40      ; UNKNOWN
05003B  7D 32                 JGE    0x5006f                      ; UNKNOWN
05003D  8A 46 08              MOV    al, byte ptr [bp + 8]        ; UNKNOWN
050040  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
050043  C1 E3 06              SHL    bx, 6                        ; UNKNOWN
050046  03 5E FE              ADD    bx, word ptr [bp - 2]        ; UNKNOWN
050049  C1 E3 02              SHL    bx, 2                        ; UNKNOWN
05004C  38 87 28 C7           CMP    byte ptr [bx - 0x38d8], al   ; UNKNOWN
050050  75 E2                 JNE    0x50034                      ; UNKNOWN
050052  8A 46 0A              MOV    al, byte ptr [bp + 0xa]      ; UNKNOWN
050055  38 87 29 C7           CMP    byte ptr [bx - 0x38d7], al   ; UNKNOWN
050059  75 D9                 JNE    0x50034                      ; UNKNOWN
05005B  8A 46 0C              MOV    al, byte ptr [bp + 0xc]      ; UNKNOWN
05005E  38 87 2A C7           CMP    byte ptr [bx - 0x38d6], al   ; UNKNOWN
050062  75 D0                 JNE    0x50034                      ; UNKNOWN
050064  8A 46 0E              MOV    al, byte ptr [bp + 0xe]      ; UNKNOWN
050067  38 87 2B C7           CMP    byte ptr [bx - 0x38d5], al   ; UNKNOWN
05006B  7C C7                 JL     0x50034                      ; UNKNOWN
05006D  C9                    LEAVE                               ; UNKNOWN
05006E  CB                    RETF                                ; UNKNOWN
