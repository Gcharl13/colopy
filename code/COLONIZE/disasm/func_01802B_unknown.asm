; ============================================================================
; func_01802B_unknown
; Region   : load_image
; Bytes    : file 0x01802B..0x018092  (103 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

01802B  C8 0E 00 00           ENTER  0xe, 0                       ; UNKNOWN
01802F  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
018032  9A 43 13 5F 24        LCALL  0x245f, 0x1343               ; UNKNOWN
018037  83 C4 02              ADD    sp, 2                        ; UNKNOWN
01803A  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
01803D  8D 46 08              LEA    ax, [bp + 8]                 ; UNKNOWN
018040  50                    PUSH   ax                           ; UNKNOWN
018041  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
018044  8B 5E 0C              MOV    bx, word ptr [bp + 0xc]      ; UNKNOWN
018047  8A 87 A6 08           MOV    al, byte ptr [bx + 0x8a6]    ; UNKNOWN
01804B  98                    CWDE                                ; UNKNOWN
01804C  50                    PUSH   ax                           ; UNKNOWN
01804D  50                    PUSH   ax                           ; UNKNOWN
01804E  8D 46 FC              LEA    ax, [bp - 4]                 ; UNKNOWN
018051  50                    PUSH   ax                           ; UNKNOWN
018052  8D 46 F4              LEA    ax, [bp - 0xc]               ; UNKNOWN
018055  50                    PUSH   ax                           ; UNKNOWN
018056  6A 02                 PUSH   2                            ; UNKNOWN
018058  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
01805B  83 C0 52              ADD    ax, 0x52                     ; UNKNOWN
01805E  8B 56 FA              MOV    dx, word ptr [bp - 6]        ; UNKNOWN
018061  8B DA                 MOV    bx, dx                       ; UNKNOWN
018063  9A 02 00 D0 38        LCALL  0x38d0, 2                    ; UNKNOWN
018068  89 46 F2              MOV    word ptr [bp - 0xe], ax      ; UNKNOWN
01806B  C7 46 F6 00 00        MOV    word ptr [bp - 0xa], 0       ; UNKNOWN
018070  EB 59                 JMP    0x180cb                      ; UNKNOWN
018072  A1 44 73              MOV    ax, word ptr [0x7344]        ; UNKNOWN
018075  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
018078  39 46 F6              CMP    word ptr [bp - 0xa], ax      ; UNKNOWN
01807B  75 45                 JNE    0x180c2                      ; UNKNOWN
01807D  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
018081  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
018085  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
018089  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
01808D  8B 5E F8              MOV    bx, word ptr [bp - 8]        ; UNKNOWN
018090  8B C3                 MOV    ax, bx                       ; UNKNOWN
