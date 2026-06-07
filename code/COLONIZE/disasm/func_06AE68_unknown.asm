; ============================================================================
; func_06AE68_unknown
; Region   : load_image
; Bytes    : file 0x06AE68..0x06AFBD  (341 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06AE68  55                    PUSH   bp                           ; UNKNOWN
06AE69  8B EC                 MOV    bp, sp                       ; UNKNOWN
06AE6B  83 EC 06              SUB    sp, 6                        ; UNKNOWN
06AE6E  57                    PUSH   di                           ; UNKNOWN
06AE6F  56                    PUSH   si                           ; UNKNOWN
06AE70  C7 46 FC 00 00        MOV    word ptr [bp - 4], 0         ; UNKNOWN
06AE75  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
06AE78  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
06AE7B  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
06AE7E  9A 68 2E 65 5F        LCALL  0x5f65, 0x2e68               ; UNKNOWN
06AE83  83 C4 06              ADD    sp, 6                        ; UNKNOWN
06AE86  83 3E 38 12 02        CMP    word ptr [0x1238], 2         ; UNKNOWN
06AE8B  74 03                 JE     0x6ae90                      ; UNKNOWN
06AE8D  E9 13 01              JMP    0x6afa3                      ; UNKNOWN
06AE90  B8 5C 00              MOV    ax, 0x5c                     ; UNKNOWN
06AE93  50                    PUSH   ax                           ; UNKNOWN
06AE94  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
06AE97  9A 90 0C 65 5F        LCALL  0x5f65, 0xc90                ; UNKNOWN
06AE9C  83 C4 04              ADD    sp, 4                        ; UNKNOWN
06AE9F  0B C0                 OR     ax, ax                       ; UNKNOWN
06AEA1  74 03                 JE     0x6aea6                      ; UNKNOWN
06AEA3  E9 FD 00              JMP    0x6afa3                      ; UNKNOWN
06AEA6  B8 2F 00              MOV    ax, 0x2f                     ; UNKNOWN
06AEA9  50                    PUSH   ax                           ; UNKNOWN
06AEAA  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
06AEAD  9A 90 0C 65 5F        LCALL  0x5f65, 0xc90                ; UNKNOWN
06AEB2  83 C4 04              ADD    sp, 4                        ; UNKNOWN
06AEB5  0B C0                 OR     ax, ax                       ; UNKNOWN
06AEB7  74 03                 JE     0x6aebc                      ; UNKNOWN
06AEB9  E9 E7 00              JMP    0x6afa3                      ; UNKNOWN
06AEBC  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
06AEBF  80 3F 00              CMP    byte ptr [bx], 0             ; UNKNOWN
06AEC2  74 09                 JE     0x6aecd                      ; UNKNOWN
06AEC4  80 7F 01 3A           CMP    byte ptr [bx + 1], 0x3a      ; UNKNOWN
06AEC8  75 03                 JNE    0x6aecd                      ; UNKNOWN
06AECA  E9 D6 00              JMP    0x6afa3                      ; UNKNOWN
06AECD  B8 44 15              MOV    ax, 0x1544                   ; UNKNOWN
06AED0  50                    PUSH   ax                           ; UNKNOWN
06AED1  9A 74 2C 65 5F        LCALL  0x5f65, 0x2c74               ; UNKNOWN
06AED6  83 C4 02              ADD    sp, 2                        ; UNKNOWN
06AED9  8B F0                 MOV    si, ax                       ; UNKNOWN
06AEDB  0B F6                 OR     si, si                       ; UNKNOWN
06AEDD  75 03                 JNE    0x6aee2                      ; UNKNOWN
06AEDF  E9 C1 00              JMP    0x6afa3                      ; UNKNOWN
06AEE2  B8 04 01              MOV    ax, 0x104                    ; UNKNOWN
06AEE5  50                    PUSH   ax                           ; UNKNOWN
06AEE6  9A 82 23 65 5F        LCALL  0x5f65, 0x2382               ; UNKNOWN
06AEEB  83 C4 02              ADD    sp, 2                        ; UNKNOWN
06AEEE  8B F8                 MOV    di, ax                       ; UNKNOWN
06AEF0  89 7E FC              MOV    word ptr [bp - 4], di        ; UNKNOWN
06AEF3  0B FF                 OR     di, di                       ; UNKNOWN
06AEF5  75 03                 JNE    0x6aefa                      ; UNKNOWN
06AEF7  E9 A9 00              JMP    0x6afa3                      ; UNKNOWN
06AEFA  EB 15                 JMP    0x6af11                      ; UNKNOWN
06AEFC  80 3C 3B              CMP    byte ptr [si], 0x3b          ; UNKNOWN
06AEFF  74 15                 JE     0x6af16                      ; UNKNOWN
06AF01  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
06AF04  05 02 01              ADD    ax, 0x102                    ; UNKNOWN
06AF07  3B C7                 CMP    ax, di                       ; UNKNOWN
06AF09  76 0B                 JBE    0x6af16                      ; UNKNOWN
06AF0B  8A 04                 MOV    al, byte ptr [si]            ; UNKNOWN
06AF0D  88 05                 MOV    byte ptr [di], al            ; UNKNOWN
06AF0F  46                    INC    si                           ; UNKNOWN
06AF10  47                    INC    di                           ; UNKNOWN
06AF11  80 3C 00              CMP    byte ptr [si], 0             ; UNKNOWN
06AF14  75 E6                 JNE    0x6aefc                      ; UNKNOWN
06AF16  C6 05 00              MOV    byte ptr [di], 0             ; UNKNOWN
06AF19  4F                    DEC    di                           ; UNKNOWN
06AF1A  89 7E FE              MOV    word ptr [bp - 2], di        ; UNKNOWN
06AF1D  8B 7E FC              MOV    di, word ptr [bp - 4]        ; UNKNOWN
06AF20  8B 5E FE              MOV    bx, word ptr [bp - 2]        ; UNKNOWN
06AF23  80 3F 5C              CMP    byte ptr [bx], 0x5c          ; UNKNOWN
06AF26  74 12                 JE     0x6af3a                      ; UNKNOWN
06AF28  80 3F 2F              CMP    byte ptr [bx], 0x2f          ; UNKNOWN
06AF2B  74 0D                 JE     0x6af3a                      ; UNKNOWN
06AF2D  B8 49 15              MOV    ax, 0x1549                   ; UNKNOWN
06AF30  50                    PUSH   ax                           ; UNKNOWN
06AF31  57                    PUSH   di                           ; UNKNOWN
06AF32  9A 34 07 65 5F        LCALL  0x5f65, 0x734                ; UNKNOWN
06AF37  83 C4 04              ADD    sp, 4                        ; UNKNOWN
06AF3A  57                    PUSH   di                           ; UNKNOWN
06AF3B  9A D2 07 65 5F        LCALL  0x5f65, 0x7d2                ; UNKNOWN
06AF40  83 C4 02              ADD    sp, 2                        ; UNKNOWN
06AF43  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
06AF46  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
06AF49  9A D2 07 65 5F        LCALL  0x5f65, 0x7d2                ; UNKNOWN
06AF4E  83 C4 02              ADD    sp, 2                        ; UNKNOWN
06AF51  03 46 FA              ADD    ax, word ptr [bp - 6]        ; UNKNOWN
06AF54  3D 04 01              CMP    ax, 0x104                    ; UNKNOWN
06AF57  73 4A                 JAE    0x6afa3                      ; UNKNOWN
06AF59  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
06AF5C  57                    PUSH   di                           ; UNKNOWN
06AF5D  9A 34 07 65 5F        LCALL  0x5f65, 0x734                ; UNKNOWN
06AF62  83 C4 04              ADD    sp, 4                        ; UNKNOWN
06AF65  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
06AF68  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
06AF6B  57                    PUSH   di                           ; UNKNOWN
06AF6C  9A 68 2E 65 5F        LCALL  0x5f65, 0x2e68               ; UNKNOWN
06AF71  83 C4 06              ADD    sp, 6                        ; UNKNOWN
06AF74  83 3E 38 12 02        CMP    word ptr [0x1238], 2         ; UNKNOWN
06AF79  74 16                 JE     0x6af91                      ; UNKNOWN
06AF7B  80 3D 5C              CMP    byte ptr [di], 0x5c          ; UNKNOWN
06AF7E  74 05                 JE     0x6af85                      ; UNKNOWN
06AF80  80 3D 2F              CMP    byte ptr [di], 0x2f          ; UNKNOWN
06AF83  75 1E                 JNE    0x6afa3                      ; UNKNOWN
06AF85  80 7D 01 5C           CMP    byte ptr [di + 1], 0x5c      ; UNKNOWN
06AF89  74 06                 JE     0x6af91                      ; UNKNOWN
06AF8B  80 7D 01 2F           CMP    byte ptr [di + 1], 0x2f      ; UNKNOWN
06AF8F  75 12                 JNE    0x6afa3                      ; UNKNOWN
06AF91  80 3C 00              CMP    byte ptr [si], 0             ; UNKNOWN
06AF94  74 0D                 JE     0x6afa3                      ; UNKNOWN
06AF96  89 76 FA              MOV    word ptr [bp - 6], si        ; UNKNOWN
06AF99  46                    INC    si                           ; UNKNOWN
06AF9A  83 7E FA 00           CMP    word ptr [bp - 6], 0         ; UNKNOWN
06AF9E  74 03                 JE     0x6afa3                      ; UNKNOWN
06AFA0  E9 6E FF              JMP    0x6af11                      ; UNKNOWN
06AFA3  83 7E FC 00           CMP    word ptr [bp - 4], 0         ; UNKNOWN
06AFA7  74 0B                 JE     0x6afb4                      ; UNKNOWN
06AFA9  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
06AFAC  9A A8 2B 65 5F        LCALL  0x5f65, 0x2ba8               ; UNKNOWN
06AFB1  83 C4 02              ADD    sp, 2                        ; UNKNOWN
06AFB4  B8 FF FF              MOV    ax, 0xffff                   ; UNKNOWN
06AFB7  5E                    POP    si                           ; UNKNOWN
06AFB8  5F                    POP    di                           ; UNKNOWN
06AFB9  8B E5                 MOV    sp, bp                       ; UNKNOWN
06AFBB  5D                    POP    bp                           ; UNKNOWN
06AFBC  CB                    RETF                                ; UNKNOWN
