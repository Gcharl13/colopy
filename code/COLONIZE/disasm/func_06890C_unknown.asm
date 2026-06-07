; ============================================================================
; func_06890C_unknown
; Region   : load_image
; Bytes    : file 0x06890C..0x0689C6  (186 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06890C  55                    PUSH   bp                           ; UNKNOWN
06890D  8B EC                 MOV    bp, sp                       ; UNKNOWN
06890F  83 EC 0E              SUB    sp, 0xe                      ; UNKNOWN
068912  57                    PUSH   di                           ; UNKNOWN
068913  56                    PUSH   si                           ; UNKNOWN
068914  BF FF FF              MOV    di, 0xffff                   ; UNKNOWN
068917  8B 76 06              MOV    si, word ptr [bp + 6]        ; UNKNOWN
06891A  F6 44 06 40           TEST   byte ptr [si + 6], 0x40      ; UNKNOWN
06891E  74 03                 JE     0x68923                      ; UNKNOWN
068920  E9 97 00              JMP    0x689ba                      ; UNKNOWN
068923  F6 44 06 83           TEST   byte ptr [si + 6], 0x83      ; UNKNOWN
068927  75 03                 JNE    0x6892c                      ; UNKNOWN
068929  E9 8E 00              JMP    0x689ba                      ; UNKNOWN
06892C  56                    PUSH   si                           ; UNKNOWN
06892D  9A 18 06 65 5F        LCALL  0x5f65, 0x618                ; UNKNOWN
068932  83 C4 02              ADD    sp, 2                        ; UNKNOWN
068935  8B F8                 MOV    di, ax                       ; UNKNOWN
068937  8B DE                 MOV    bx, si                       ; UNKNOWN
068939  81 EB 78 12           SUB    bx, 0x1278                   ; UNKNOWN
06893D  8B 87 1C 13           MOV    ax, word ptr [bx + 0x131c]   ; UNKNOWN
068941  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
068944  56                    PUSH   si                           ; UNKNOWN
068945  E8 E4 16              CALL   0x6a02c                      ; UNKNOWN
068948  83 C4 02              ADD    sp, 2                        ; UNKNOWN
06894B  8A 44 07              MOV    al, byte ptr [si + 7]        ; UNKNOWN
06894E  2A E4                 SUB    ah, ah                       ; UNKNOWN
068950  50                    PUSH   ax                           ; UNKNOWN
068951  9A BE 20 65 5F        LCALL  0x5f65, 0x20be               ; UNKNOWN
068956  83 C4 02              ADD    sp, 2                        ; UNKNOWN
068959  0B C0                 OR     ax, ax                       ; UNKNOWN
06895B  7C 5A                 JL     0x689b7                      ; UNKNOWN
06895D  83 7E FC 00           CMP    word ptr [bp - 4], 0         ; UNKNOWN
068961  74 57                 JE     0x689ba                      ; UNKNOWN
068963  B8 74 12              MOV    ax, 0x1274                   ; UNKNOWN
068966  50                    PUSH   ax                           ; UNKNOWN
068967  8D 46 F2              LEA    ax, [bp - 0xe]               ; UNKNOWN
06896A  50                    PUSH   ax                           ; UNKNOWN
06896B  9A 74 07 65 5F        LCALL  0x5f65, 0x774                ; UNKNOWN
068970  83 C4 04              ADD    sp, 4                        ; UNKNOWN
068973  8D 46 F4              LEA    ax, [bp - 0xc]               ; UNKNOWN
068976  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
068979  80 7E F2 5C           CMP    byte ptr [bp - 0xe], 0x5c    ; UNKNOWN
06897D  74 13                 JE     0x68992                      ; UNKNOWN
06897F  B8 76 12              MOV    ax, 0x1276                   ; UNKNOWN
068982  50                    PUSH   ax                           ; UNKNOWN
068983  8D 46 F2              LEA    ax, [bp - 0xe]               ; UNKNOWN
068986  50                    PUSH   ax                           ; UNKNOWN
068987  9A 34 07 65 5F        LCALL  0x5f65, 0x734                ; UNKNOWN
06898C  83 C4 04              ADD    sp, 4                        ; UNKNOWN
06898F  EB 04                 JMP    0x68995                      ; UNKNOWN
068991  90                    NOP                                 ; UNKNOWN
068992  FF 4E FE              DEC    word ptr [bp - 2]            ; UNKNOWN
068995  B8 0A 00              MOV    ax, 0xa                      ; UNKNOWN
068998  50                    PUSH   ax                           ; UNKNOWN
068999  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
06899C  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
06899F  9A 8A 08 65 5F        LCALL  0x5f65, 0x88a                ; UNKNOWN
0689A4  83 C4 06              ADD    sp, 6                        ; UNKNOWN
0689A7  8D 46 F2              LEA    ax, [bp - 0xe]               ; UNKNOWN
0689AA  50                    PUSH   ax                           ; UNKNOWN
0689AB  9A 22 11 65 5F        LCALL  0x5f65, 0x1122               ; UNKNOWN
0689B0  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0689B3  0B C0                 OR     ax, ax                       ; UNKNOWN
0689B5  74 03                 JE     0x689ba                      ; UNKNOWN
0689B7  BF FF FF              MOV    di, 0xffff                   ; UNKNOWN
0689BA  C6 44 06 00           MOV    byte ptr [si + 6], 0         ; UNKNOWN
0689BE  8B C7                 MOV    ax, di                       ; UNKNOWN
0689C0  5E                    POP    si                           ; UNKNOWN
0689C1  5F                    POP    di                           ; UNKNOWN
0689C2  8B E5                 MOV    sp, bp                       ; UNKNOWN
0689C4  5D                    POP    bp                           ; UNKNOWN
0689C5  CB                    RETF                                ; UNKNOWN
