; ============================================================================
; func_04F55F_unknown
; Region   : load_image
; Bytes    : file 0x04F55F..0x04F71B  (444 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04F55F  C8 1A 00 00           ENTER  0x1a, 0                      ; UNKNOWN
04F563  2B C0                 SUB    ax, ax                       ; UNKNOWN
04F565  89 46 EC              MOV    word ptr [bp - 0x14], ax     ; UNKNOWN
04F568  89 46 F4              MOV    word ptr [bp - 0xc], ax      ; UNKNOWN
04F56B  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
04F56F  8A 87 89 88           MOV    al, byte ptr [bx - 0x7777]   ; UNKNOWN
04F573  2A E4                 SUB    ah, ah                       ; UNKNOWN
04F575  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
04F578  89 46 EA              MOV    word ptr [bp - 0x16], ax     ; UNKNOWN
04F57B  8A 87 8A 88           MOV    al, byte ptr [bx - 0x7776]   ; UNKNOWN
04F57F  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; UNKNOWN
04F582  89 46 E8              MOV    word ptr [bp - 0x18], ax     ; UNKNOWN
04F585  8B 46 F8              MOV    ax, word ptr [bp - 8]        ; UNKNOWN
04F588  2B 46 F4              SUB    ax, word ptr [bp - 0xc]      ; UNKNOWN
04F58B  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
04F58E  EB 4D                 JMP    0x4f5dd                      ; UNKNOWN
04F590  8B 46 F4              MOV    ax, word ptr [bp - 0xc]      ; UNKNOWN
04F593  F7 D0                 NOT    ax                           ; UNKNOWN
04F595  40                    INC    ax                           ; UNKNOWN
04F596  EB 02                 JMP    0x4f59a                      ; UNKNOWN
04F598  2B C0                 SUB    ax, ax                       ; UNKNOWN
04F59A  03 46 F6              ADD    ax, word ptr [bp - 0xa]      ; UNKNOWN
04F59D  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
04F5A0  50                    PUSH   ax                           ; UNKNOWN
04F5A1  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
04F5A4  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
04F5A7  0E                    PUSH   cs                           ; UNKNOWN
04F5A8  E8 5B FF              CALL   0x4f506                      ; UNKNOWN
04F5AB  83 C4 06              ADD    sp, 6                        ; UNKNOWN
04F5AE  0B C0                 OR     ax, ax                       ; UNKNOWN
04F5B0  74 11                 JE     0x4f5c3                      ; UNKNOWN
04F5B2  C7 46 EC 01 00        MOV    word ptr [bp - 0x14], 1      ; UNKNOWN
04F5B7  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
04F5BA  89 46 EA              MOV    word ptr [bp - 0x16], ax     ; UNKNOWN
04F5BD  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
04F5C0  89 46 E8              MOV    word ptr [bp - 0x18], ax     ; UNKNOWN
04F5C3  83 46 F0 02           ADD    word ptr [bp - 0x10], 2      ; UNKNOWN
04F5C7  83 7E F0 01           CMP    word ptr [bp - 0x10], 1      ; UNKNOWN
04F5CB  7F 0D                 JG     0x4f5da                      ; UNKNOWN
04F5CD  83 7E F0 00           CMP    word ptr [bp - 0x10], 0      ; UNKNOWN
04F5D1  74 C5                 JE     0x4f598                      ; UNKNOWN
04F5D3  7C BB                 JL     0x4f590                      ; UNKNOWN
04F5D5  8B 46 F4              MOV    ax, word ptr [bp - 0xc]      ; UNKNOWN
04F5D8  EB C0                 JMP    0x4f59a                      ; UNKNOWN
04F5DA  FF 46 FE              INC    word ptr [bp - 2]            ; UNKNOWN
04F5DD  83 7E EC 00           CMP    word ptr [bp - 0x14], 0      ; UNKNOWN
04F5E1  75 12                 JNE    0x4f5f5                      ; UNKNOWN
04F5E3  8B 46 F4              MOV    ax, word ptr [bp - 0xc]      ; UNKNOWN
04F5E6  03 46 F8              ADD    ax, word ptr [bp - 8]        ; UNKNOWN
04F5E9  3B 46 FE              CMP    ax, word ptr [bp - 2]        ; UNKNOWN
04F5EC  7C 07                 JL     0x4f5f5                      ; UNKNOWN
04F5EE  C7 46 F0 FF FF        MOV    word ptr [bp - 0x10], 0xffff ; UNKNOWN
04F5F3  EB D2                 JMP    0x4f5c7                      ; UNKNOWN
04F5F5  8B 46 F6              MOV    ax, word ptr [bp - 0xa]      ; UNKNOWN
04F5F8  2B 46 F4              SUB    ax, word ptr [bp - 0xc]      ; UNKNOWN
04F5FB  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
04F5FE  EB 4D                 JMP    0x4f64d                      ; UNKNOWN
04F600  8B 46 F4              MOV    ax, word ptr [bp - 0xc]      ; UNKNOWN
04F603  F7 D0                 NOT    ax                           ; UNKNOWN
04F605  40                    INC    ax                           ; UNKNOWN
04F606  EB 02                 JMP    0x4f60a                      ; UNKNOWN
04F608  2B C0                 SUB    ax, ax                       ; UNKNOWN
04F60A  03 46 F8              ADD    ax, word ptr [bp - 8]        ; UNKNOWN
04F60D  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
04F610  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
04F613  50                    PUSH   ax                           ; UNKNOWN
04F614  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
04F617  0E                    PUSH   cs                           ; UNKNOWN
04F618  E8 EB FE              CALL   0x4f506                      ; UNKNOWN
04F61B  83 C4 06              ADD    sp, 6                        ; UNKNOWN
04F61E  0B C0                 OR     ax, ax                       ; UNKNOWN
04F620  74 11                 JE     0x4f633                      ; UNKNOWN
04F622  C7 46 EC 01 00        MOV    word ptr [bp - 0x14], 1      ; UNKNOWN
04F627  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
04F62A  89 46 EA              MOV    word ptr [bp - 0x16], ax     ; UNKNOWN
04F62D  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
04F630  89 46 E8              MOV    word ptr [bp - 0x18], ax     ; UNKNOWN
04F633  83 46 FA 02           ADD    word ptr [bp - 6], 2         ; UNKNOWN
04F637  83 7E FA 01           CMP    word ptr [bp - 6], 1         ; UNKNOWN
04F63B  7F 0D                 JG     0x4f64a                      ; UNKNOWN
04F63D  83 7E FA 00           CMP    word ptr [bp - 6], 0         ; UNKNOWN
04F641  74 C5                 JE     0x4f608                      ; UNKNOWN
04F643  7C BB                 JL     0x4f600                      ; UNKNOWN
04F645  8B 46 F4              MOV    ax, word ptr [bp - 0xc]      ; UNKNOWN
04F648  EB C0                 JMP    0x4f60a                      ; UNKNOWN
04F64A  FF 46 FC              INC    word ptr [bp - 4]            ; UNKNOWN
04F64D  83 7E EC 00           CMP    word ptr [bp - 0x14], 0      ; UNKNOWN
04F651  75 12                 JNE    0x4f665                      ; UNKNOWN
04F653  8B 46 F4              MOV    ax, word ptr [bp - 0xc]      ; UNKNOWN
04F656  03 46 F6              ADD    ax, word ptr [bp - 0xa]      ; UNKNOWN
04F659  3B 46 FC              CMP    ax, word ptr [bp - 4]        ; UNKNOWN
04F65C  7C 07                 JL     0x4f665                      ; UNKNOWN
04F65E  C7 46 FA FF FF        MOV    word ptr [bp - 6], 0xffff    ; UNKNOWN
04F663  EB D2                 JMP    0x4f637                      ; UNKNOWN
04F665  FF 46 F4              INC    word ptr [bp - 0xc]          ; UNKNOWN
04F668  83 7E EC 00           CMP    word ptr [bp - 0x14], 0      ; UNKNOWN
04F66C  75 14                 JNE    0x4f682                      ; UNKNOWN
04F66E  A1 8A 82              MOV    ax, word ptr [0x828a]        ; UNKNOWN
04F671  3B 06 88 82           CMP    ax, word ptr [0x8288]        ; UNKNOWN
04F675  7D 03                 JGE    0x4f67a                      ; UNKNOWN
04F677  A1 88 82              MOV    ax, word ptr [0x8288]        ; UNKNOWN
04F67A  3B 46 F4              CMP    ax, word ptr [bp - 0xc]      ; UNKNOWN
04F67D  7E 03                 JLE    0x4f682                      ; UNKNOWN
04F67F  E9 03 FF              JMP    0x4f585                      ; UNKNOWN
04F682  83 7E EC 00           CMP    word ptr [bp - 0x14], 0      ; UNKNOWN
04F686  75 14                 JNE    0x4f69c                      ; UNKNOWN
04F688  8B 46 EA              MOV    ax, word ptr [bp - 0x16]     ; UNKNOWN
04F68B  8B 56 E8              MOV    dx, word ptr [bp - 0x18]     ; UNKNOWN
04F68E  9A 60 00 B7 36        LCALL  0x36b7, 0x60                 ; UNKNOWN
04F693  50                    PUSH   ax                           ; UNKNOWN
04F694  9A 15 0F B7 36        LCALL  0x36b7, 0xf15                ; UNKNOWN
04F699  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04F69C  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
04F69F  9A 5F 09 B7 36        LCALL  0x36b7, 0x95f                ; UNKNOWN
04F6A4  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04F6A7  FF 76 E8              PUSH   word ptr [bp - 0x18]         ; UNKNOWN
04F6AA  FF 76 EA              PUSH   word ptr [bp - 0x16]         ; UNKNOWN
04F6AD  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
04F6B0  9A 0A 04 B7 36        LCALL  0x36b7, 0x40a                ; UNKNOWN
04F6B5  83 C4 06              ADD    sp, 6                        ; UNKNOWN
04F6B8  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
04F6BB  9A D4 0C B7 36        LCALL  0x36b7, 0xcd4                ; UNKNOWN
04F6C0  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04F6C3  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
04F6C6  9A E8 02 32 18        LCALL  0x1832, 0x2e8                ; UNKNOWN
04F6CB  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
04F6CF  8A 87 83 88           MOV    al, byte ptr [bx - 0x777d]   ; UNKNOWN
04F6D3  24 0F                 AND    al, 0xf                      ; UNKNOWN
04F6D5  3A 06 0E 3E           CMP    al, byte ptr [0x3e0e]        ; UNKNOWN
04F6D9  75 3E                 JNE    0x4f719                      ; UNKNOWN
04F6DB  6A 00                 PUSH   0                            ; UNKNOWN
04F6DD  FF 76 E8              PUSH   word ptr [bp - 0x18]         ; UNKNOWN
04F6E0  FF 76 EA              PUSH   word ptr [bp - 0x16]         ; UNKNOWN
04F6E3  FF 76 E8              PUSH   word ptr [bp - 0x18]         ; UNKNOWN
04F6E6  FF 76 EA              PUSH   word ptr [bp - 0x16]         ; UNKNOWN
04F6E9  9A F9 02 0B 38        LCALL  0x380b, 0x2f9                ; UNKNOWN
04F6EE  83 C4 0A              ADD    sp, 0xa                      ; UNKNOWN
04F6F1  0B C0                 OR     ax, ax                       ; UNKNOWN
04F6F3  75 1C                 JNE    0x4f711                      ; UNKNOWN
04F6F5  6A 01                 PUSH   1                            ; UNKNOWN
04F6F7  6A 07                 PUSH   7                            ; UNKNOWN
04F6F9  6A 07                 PUSH   7                            ; UNKNOWN
04F6FB  8B 46 E8              MOV    ax, word ptr [bp - 0x18]     ; UNKNOWN
04F6FE  83 E8 03              SUB    ax, 3                        ; UNKNOWN
04F701  50                    PUSH   ax                           ; UNKNOWN
04F702  8B 46 EA              MOV    ax, word ptr [bp - 0x16]     ; UNKNOWN
04F705  83 E8 03              SUB    ax, 3                        ; UNKNOWN
04F708  50                    PUSH   ax                           ; UNKNOWN
04F709  9A 0C 00 E4 35        LCALL  0x35e4, 0xc                  ; UNKNOWN
04F70E  83 C4 0A              ADD    sp, 0xa                      ; UNKNOWN
04F711  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
04F714  9A 2D 06 0B 38        LCALL  0x380b, 0x62d                ; UNKNOWN
04F719  C9                    LEAVE                               ; UNKNOWN
04F71A  CB                    RETF                                ; UNKNOWN
