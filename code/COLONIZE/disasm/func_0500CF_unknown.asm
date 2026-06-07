; ============================================================================
; func_0500CF_unknown
; Region   : load_image
; Bytes    : file 0x0500CF..0x0500F6  (39 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0500CF  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
0500D3  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
0500D8  EB 03                 JMP    0x500dd                      ; UNKNOWN
0500DA  FF 46 FE              INC    word ptr [bp - 2]            ; UNKNOWN
0500DD  83 7E FE 10           CMP    word ptr [bp - 2], 0x10      ; UNKNOWN
0500E1  7D 32                 JGE    0x50115                      ; UNKNOWN
0500E3  8A 46 08              MOV    al, byte ptr [bp + 8]        ; UNKNOWN
0500E6  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
0500E9  C1 E3 04              SHL    bx, 4                        ; UNKNOWN
0500EC  03 5E FE              ADD    bx, word ptr [bp - 2]        ; UNKNOWN
0500EF  C1 E3 02              SHL    bx, 2                        ; UNKNOWN
0500F2  38 87 3A CB           CMP    byte ptr [bx - 0x34c6], al   ; UNKNOWN
