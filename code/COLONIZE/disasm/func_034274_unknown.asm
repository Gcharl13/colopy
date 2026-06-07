; ============================================================================
; func_034274_unknown
; Region   : load_image
; Bytes    : file 0x034274..0x0342D4  (96 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

034274  C8 08 00 00           ENTER  8, 0                         ; UNKNOWN
034278  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
03427B  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
03427E  2B C9                 SUB    cx, cx                       ; UNKNOWN
034280  89 4E F8              MOV    word ptr [bp - 8], cx        ; UNKNOWN
034283  8B 5E 0A              MOV    bx, word ptr [bp + 0xa]      ; UNKNOWN
034286  89 0F                 MOV    word ptr [bx], cx            ; UNKNOWN
034288  83 F8 03              CMP    ax, 3                        ; UNKNOWN
03428B  7D 05                 JGE    0x34292                      ; UNKNOWN
03428D  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
034290  EB 19                 JMP    0x342ab                      ; UNKNOWN
034292  8B 5E 0A              MOV    bx, word ptr [bp + 0xa]      ; UNKNOWN
034295  FF 07                 INC    word ptr [bx]                ; UNKNOWN
034297  83 6E FE 03           SUB    word ptr [bp - 2], 3         ; UNKNOWN
03429B  83 7E FE 05           CMP    word ptr [bp - 2], 5         ; UNKNOWN
03429F  7D 05                 JGE    0x342a6                      ; UNKNOWN
0342A1  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
0342A4  EB E7                 JMP    0x3428d                      ; UNKNOWN
0342A6  8B 5E 0A              MOV    bx, word ptr [bp + 0xa]      ; UNKNOWN
0342A9  FF 07                 INC    word ptr [bx]                ; UNKNOWN
0342AB  B8 10 00              MOV    ax, 0x10                     ; UNKNOWN
0342AE  8B 5E 12              MOV    bx, word ptr [bp + 0x12]     ; UNKNOWN
0342B1  89 07                 MOV    word ptr [bx], ax            ; UNKNOWN
0342B3  8B 5E 10              MOV    bx, word ptr [bp + 0x10]     ; UNKNOWN
0342B6  89 07                 MOV    word ptr [bx], ax            ; UNKNOWN
0342B8  6B 46 F8 11           IMUL   ax, word ptr [bp - 8], 0x11  ; UNKNOWN
0342BC  03 46 08              ADD    ax, word ptr [bp + 8]        ; UNKNOWN
0342BF  8B 5E 0C              MOV    bx, word ptr [bp + 0xc]      ; UNKNOWN
0342C2  89 07                 MOV    word ptr [bx], ax            ; UNKNOWN
0342C4  8B 5E 0A              MOV    bx, word ptr [bp + 0xa]      ; UNKNOWN
0342C7  8B 07                 MOV    ax, word ptr [bx]            ; UNKNOWN
0342C9  EB 12                 JMP    0x342dd                      ; UNKNOWN
0342CB  8B 5E 0E              MOV    bx, word ptr [bp + 0xe]      ; UNKNOWN
0342CE  C7 07 8A 00           MOV    word ptr [bx], 0x8a          ; UNKNOWN
0342D2  C9                    LEAVE                               ; UNKNOWN
0342D3  CB                    RETF                                ; UNKNOWN
