; ============================================================================
; func_021774_unknown
; Region   : load_image
; Bytes    : file 0x021774..0x0218AB  (311 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

021774  C8 0E 00 00           ENTER  0xe, 0                       ; UNKNOWN
021778  57                    PUSH   di                           ; UNKNOWN
021779  56                    PUSH   si                           ; UNKNOWN
02177A  83 7E 12 00           CMP    word ptr [bp + 0x12], 0      ; UNKNOWN
02177E  74 49                 JE     0x217c9                      ; UNKNOWN
021780  8B 7E 06              MOV    di, word ptr [bp + 6]        ; UNKNOWN
021783  8E 46 08              MOV    es, word ptr [bp + 8]        ; UNKNOWN
021786  26 FF 75 04           PUSH   word ptr es:[di + 4]         ; UNKNOWN
02178A  26 8B 5D 04           MOV    bx, word ptr es:[di + 4]     ; UNKNOWN
02178E  8B D3                 MOV    dx, bx                       ; UNKNOWN
021790  B8 FF FF              MOV    ax, 0xffff                   ; UNKNOWN
021793  8C C6                 MOV    si, es                       ; UNKNOWN
021795  9A 02 00 74 5B        LCALL  0x5b74, 2                    ; UNKNOWN
02179A  8E C6                 MOV    es, si                       ; UNKNOWN
02179C  26 FF 75 0A           PUSH   word ptr es:[di + 0xa]       ; UNKNOWN
0217A0  26 FF 75 08           PUSH   word ptr es:[di + 8]         ; UNKNOWN
0217A4  FF 76 0C              PUSH   word ptr [bp + 0xc]          ; UNKNOWN
0217A7  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
0217AA  26 FF 35              PUSH   word ptr es:[di]             ; UNKNOWN
0217AD  8D 1E 82 CE           LEA    bx, [0xce82]                 ; UNKNOWN
0217B1  8B 46 0E              MOV    ax, word ptr [bp + 0xe]      ; UNKNOWN
0217B4  8B 56 10              MOV    dx, word ptr [bp + 0x10]     ; UNKNOWN
0217B7  8C C6                 MOV    si, es                       ; UNKNOWN
0217B9  9A 08 00 5D 5B        LCALL  0x5b5d, 8                    ; UNKNOWN
0217BE  8E C6                 MOV    es, si                       ; UNKNOWN
0217C0  26 03 05              ADD    ax, word ptr es:[di]         ; UNKNOWN
0217C3  89 46 0E              MOV    word ptr [bp + 0xe], ax      ; UNKNOWN
0217C6  E9 DB 00              JMP    0x218a4                      ; UNKNOWN
0217C9  8B 76 06              MOV    si, word ptr [bp + 6]        ; UNKNOWN
0217CC  C6 46 FB 00           MOV    byte ptr [bp - 5], 0         ; UNKNOWN
0217D0  8E 46 08              MOV    es, word ptr [bp + 8]        ; UNKNOWN
0217D3  26 FF 74 02           PUSH   word ptr es:[si + 2]         ; UNKNOWN
0217D7  26 8B 54 02           MOV    dx, word ptr es:[si + 2]     ; UNKNOWN
0217DB  8B DA                 MOV    bx, dx                       ; UNKNOWN
0217DD  B8 FF FF              MOV    ax, 0xffff                   ; UNKNOWN
0217E0  9A 02 00 74 5B        LCALL  0x5b74, 2                    ; UNKNOWN
0217E5  C4 5E 0A              LES    bx, ptr [bp + 0xa]           ; UNKNOWN
0217E8  8B FB                 MOV    di, bx                       ; UNKNOWN
0217EA  8C 46 FE              MOV    word ptr [bp - 2], es        ; UNKNOWN
0217ED  26 80 3F 00           CMP    byte ptr es:[bx], 0          ; UNKNOWN
0217F1  75 03                 JNE    0x217f6                      ; UNKNOWN
0217F3  E9 AE 00              JMP    0x218a4                      ; UNKNOWN
0217F6  26 80 3D 7E           CMP    byte ptr es:[di], 0x7e       ; UNKNOWN
0217FA  75 64                 JNE    0x21860                      ; UNKNOWN
0217FC  8E 46 08              MOV    es, word ptr [bp + 8]        ; UNKNOWN
0217FF  26 FF 74 06           PUSH   word ptr es:[si + 6]         ; UNKNOWN
021803  26 8B 5C 06           MOV    bx, word ptr es:[si + 6]     ; UNKNOWN
021807  8B D3                 MOV    dx, bx                       ; UNKNOWN
021809  B8 FF FF              MOV    ax, 0xffff                   ; UNKNOWN
02180C  89 76 F6              MOV    word ptr [bp - 0xa], si      ; UNKNOWN
02180F  8C 46 F8              MOV    word ptr [bp - 8], es        ; UNKNOWN
021812  9A 02 00 74 5B        LCALL  0x5b74, 2                    ; UNKNOWN
021817  8E 46 FE              MOV    es, word ptr [bp - 2]        ; UNKNOWN
02181A  47                    INC    di                           ; UNKNOWN
02181B  26 8A 05              MOV    al, byte ptr es:[di]         ; UNKNOWN
02181E  88 46 FA              MOV    byte ptr [bp - 6], al        ; UNKNOWN
021821  C4 5E F6              LES    bx, ptr [bp - 0xa]           ; UNKNOWN
021824  26 FF 77 0A           PUSH   word ptr es:[bx + 0xa]       ; UNKNOWN
021828  26 FF 77 08           PUSH   word ptr es:[bx + 8]         ; UNKNOWN
02182C  8D 46 FA              LEA    ax, [bp - 6]                 ; UNKNOWN
02182F  16                    PUSH   ss                           ; UNKNOWN
021830  50                    PUSH   ax                           ; UNKNOWN
021831  26 FF 37              PUSH   word ptr es:[bx]             ; UNKNOWN
021834  8D 1E 82 CE           LEA    bx, [0xce82]                 ; UNKNOWN
021838  8B 46 0E              MOV    ax, word ptr [bp + 0xe]      ; UNKNOWN
02183B  8B 56 10              MOV    dx, word ptr [bp + 0x10]     ; UNKNOWN
02183E  9A 08 00 5D 5B        LCALL  0x5b5d, 8                    ; UNKNOWN
021843  C4 5E F6              LES    bx, ptr [bp - 0xa]           ; UNKNOWN
021846  26 03 07              ADD    ax, word ptr es:[bx]         ; UNKNOWN
021849  89 46 0E              MOV    word ptr [bp + 0xe], ax      ; UNKNOWN
02184C  26 FF 77 02           PUSH   word ptr es:[bx + 2]         ; UNKNOWN
021850  26 8B 5F 02           MOV    bx, word ptr es:[bx + 2]     ; UNKNOWN
021854  8B D3                 MOV    dx, bx                       ; UNKNOWN
021856  B8 FF FF              MOV    ax, 0xffff                   ; UNKNOWN
021859  9A 02 00 74 5B        LCALL  0x5b74, 2                    ; UNKNOWN
02185E  EB 37                 JMP    0x21897                      ; UNKNOWN
021860  26 8A 05              MOV    al, byte ptr es:[di]         ; UNKNOWN
021863  88 46 FA              MOV    byte ptr [bp - 6], al        ; UNKNOWN
021866  8E 46 08              MOV    es, word ptr [bp + 8]        ; UNKNOWN
021869  26 FF 74 0A           PUSH   word ptr es:[si + 0xa]       ; UNKNOWN
02186D  26 FF 74 08           PUSH   word ptr es:[si + 8]         ; UNKNOWN
021871  8D 46 FA              LEA    ax, [bp - 6]                 ; UNKNOWN
021874  16                    PUSH   ss                           ; UNKNOWN
021875  50                    PUSH   ax                           ; UNKNOWN
021876  26 FF 34              PUSH   word ptr es:[si]             ; UNKNOWN
021879  8D 1E 82 CE           LEA    bx, [0xce82]                 ; UNKNOWN
02187D  8B 46 0E              MOV    ax, word ptr [bp + 0xe]      ; UNKNOWN
021880  8B 56 10              MOV    dx, word ptr [bp + 0x10]     ; UNKNOWN
021883  89 76 F2              MOV    word ptr [bp - 0xe], si      ; UNKNOWN
021886  8C 46 F4              MOV    word ptr [bp - 0xc], es      ; UNKNOWN
021889  9A 08 00 5D 5B        LCALL  0x5b5d, 8                    ; UNKNOWN
02188E  C4 5E F2              LES    bx, ptr [bp - 0xe]           ; UNKNOWN
021891  26 03 07              ADD    ax, word ptr es:[bx]         ; UNKNOWN
021894  89 46 0E              MOV    word ptr [bp + 0xe], ax      ; UNKNOWN
021897  8E 46 FE              MOV    es, word ptr [bp - 2]        ; UNKNOWN
02189A  47                    INC    di                           ; UNKNOWN
02189B  26 80 3D 00           CMP    byte ptr es:[di], 0          ; UNKNOWN
02189F  74 03                 JE     0x218a4                      ; UNKNOWN
0218A1  E9 52 FF              JMP    0x217f6                      ; UNKNOWN
0218A4  8B 46 0E              MOV    ax, word ptr [bp + 0xe]      ; UNKNOWN
0218A7  5E                    POP    si                           ; UNKNOWN
0218A8  5F                    POP    di                           ; UNKNOWN
0218A9  C9                    LEAVE                               ; UNKNOWN
0218AA  CB                    RETF                                ; UNKNOWN
