; ============================================================================
; func_043335_unknown
; Region   : load_image
; Bytes    : file 0x043335..0x043406  (209 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

043335  C8 0E 00 00           ENTER  0xe, 0                       ; UNKNOWN
043339  57                    PUSH   di                           ; UNKNOWN
04333A  56                    PUSH   si                           ; UNKNOWN
04333B  8B 76 08              MOV    si, word ptr [bp + 8]        ; UNKNOWN
04333E  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
043341  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; UNKNOWN
043344  03 46 0A              ADD    ax, word ptr [bp + 0xa]      ; UNKNOWN
043347  48                    DEC    ax                           ; UNKNOWN
043348  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
04334B  89 76 F4              MOV    word ptr [bp - 0xc], si      ; UNKNOWN
04334E  03 76 0C              ADD    si, word ptr [bp + 0xc]      ; UNKNOWN
043351  4E                    DEC    si                           ; UNKNOWN
043352  89 76 F2              MOV    word ptr [bp - 0xe], si      ; UNKNOWN
043355  8D 46 F2              LEA    ax, [bp - 0xe]               ; UNKNOWN
043358  50                    PUSH   ax                           ; UNKNOWN
043359  8D 46 F8              LEA    ax, [bp - 8]                 ; UNKNOWN
04335C  50                    PUSH   ax                           ; UNKNOWN
04335D  8D 46 F4              LEA    ax, [bp - 0xc]               ; UNKNOWN
043360  50                    PUSH   ax                           ; UNKNOWN
043361  8D 46 F6              LEA    ax, [bp - 0xa]               ; UNKNOWN
043364  50                    PUSH   ax                           ; UNKNOWN
043365  9A 02 00 BE 17        LCALL  0x17be, 2                    ; UNKNOWN
04336A  83 C4 08              ADD    sp, 8                        ; UNKNOWN
04336D  8A 0E 0E 3E           MOV    cl, byte ptr [0x3e0e]        ; UNKNOWN
043371  80 C1 04              ADD    cl, 4                        ; UNKNOWN
043374  B0 01                 MOV    al, 1                        ; UNKNOWN
043376  D2 E0                 SHL    al, cl                       ; UNKNOWN
043378  88 46 FD              MOV    byte ptr [bp - 3], al        ; UNKNOWN
04337B  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
043380  83 3E 14 3E 00        CMP    word ptr [0x3e14], 0         ; UNKNOWN
043385  7E 7B                 JLE    0x43402                      ; UNKNOWN
043387  BE 80 88              MOV    si, 0x8880                   ; UNKNOWN
04338A  83 7C 18 00           CMP    word ptr [si + 0x18], 0      ; UNKNOWN
04338E  7D 64                 JGE    0x433f4                      ; UNKNOWN
043390  8A 04                 MOV    al, byte ptr [si]            ; UNKNOWN
043392  2A E4                 SUB    ah, ah                       ; UNKNOWN
043394  8B F8                 MOV    di, ax                       ; UNKNOWN
043396  8A 4C 01              MOV    cl, byte ptr [si + 1]        ; UNKNOWN
043399  2A ED                 SUB    ch, ch                       ; UNKNOWN
04339B  3B 46 F6              CMP    ax, word ptr [bp - 0xa]      ; UNKNOWN
04339E  7C 54                 JL     0x433f4                      ; UNKNOWN
0433A0  39 7E F8              CMP    word ptr [bp - 8], di        ; UNKNOWN
0433A3  7C 4F                 JL     0x433f4                      ; UNKNOWN
0433A5  39 4E F4              CMP    word ptr [bp - 0xc], cx      ; UNKNOWN
0433A8  7F 4A                 JG     0x433f4                      ; UNKNOWN
0433AA  39 4E F2              CMP    word ptr [bp - 0xe], cx      ; UNKNOWN
0433AD  7C 45                 JL     0x433f4                      ; UNKNOWN
0433AF  8A 44 03              MOV    al, byte ptr [si + 3]        ; UNKNOWN
0433B2  24 0F                 AND    al, 0xf                      ; UNKNOWN
0433B4  3A 06 0E 3E           CMP    al, byte ptr [0x3e0e]        ; UNKNOWN
0433B8  75 16                 JNE    0x433d0                      ; UNKNOWN
0433BA  51                    PUSH   cx                           ; UNKNOWN
0433BB  57                    PUSH   di                           ; UNKNOWN
0433BC  9A E8 02 C9 33        LCALL  0x33c9, 0x2e8                ; UNKNOWN
0433C1  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0433C4  22 46 FD              AND    al, byte ptr [bp - 3]        ; UNKNOWN
0433C7  2A E4                 SUB    ah, ah                       ; UNKNOWN
0433C9  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
0433CC  8B D0                 MOV    dx, ax                       ; UNKNOWN
0433CE  EB 10                 JMP    0x433e0                      ; UNKNOWN
0433D0  8A 54 03              MOV    dl, byte ptr [si + 3]        ; UNKNOWN
0433D3  8A 0E 0E 3E           MOV    cl, byte ptr [0x3e0e]        ; UNKNOWN
0433D7  B8 10 00              MOV    ax, 0x10                     ; UNKNOWN
0433DA  D3 E0                 SHL    ax, cl                       ; UNKNOWN
0433DC  22 D0                 AND    dl, al                       ; UNKNOWN
0433DE  2A F6                 SUB    dh, dh                       ; UNKNOWN
0433E0  0B D2                 OR     dx, dx                       ; UNKNOWN
0433E2  75 06                 JNE    0x433ea                      ; UNKNOWN
0433E4  39 16 1A 3E           CMP    word ptr [0x3e1a], dx        ; UNKNOWN
0433E8  74 0A                 JE     0x433f4                      ; UNKNOWN
0433EA  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
0433ED  0E                    PUSH   cs                           ; UNKNOWN
0433EE  E8 B3 FE              CALL   0x432a4                      ; UNKNOWN
0433F1  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0433F4  83 C6 1C              ADD    si, 0x1c                     ; UNKNOWN
0433F7  A1 14 3E              MOV    ax, word ptr [0x3e14]        ; UNKNOWN
0433FA  FF 46 FE              INC    word ptr [bp - 2]            ; UNKNOWN
0433FD  39 46 FE              CMP    word ptr [bp - 2], ax        ; UNKNOWN
043400  7C 88                 JL     0x4338a                      ; UNKNOWN
043402  5E                    POP    si                           ; UNKNOWN
043403  5F                    POP    di                           ; UNKNOWN
043404  C9                    LEAVE                               ; UNKNOWN
043405  CB                    RETF                                ; UNKNOWN
