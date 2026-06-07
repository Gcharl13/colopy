; ============================================================================
; func_03D771_unknown
; Region   : load_image
; Bytes    : file 0x03D771..0x03DB88  (1047 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03D771  C8 26 00 00           ENTER  0x26, 0                      ; UNKNOWN
03D775  2B C0                 SUB    ax, ax                       ; UNKNOWN
03D777  89 46 DE              MOV    word ptr [bp - 0x22], ax     ; UNKNOWN
03D77A  89 46 F0              MOV    word ptr [bp - 0x10], ax     ; UNKNOWN
03D77D  FF 36 30 0B           PUSH   word ptr [0xb30]             ; UNKNOWN
03D781  FF 36 0E 0B           PUSH   word ptr [0xb0e]             ; UNKNOWN
03D785  FF 36 0C 0B           PUSH   word ptr [0xb0c]             ; UNKNOWN
03D789  FF 36 1A 0B           PUSH   word ptr [0xb1a]             ; UNKNOWN
03D78D  FF 36 18 0B           PUSH   word ptr [0xb18]             ; UNKNOWN
03D791  9A BE 12 65 5F        LCALL  0x5f65, 0x12be               ; UNKNOWN
03D796  83 C4 0A              ADD    sp, 0xa                      ; UNKNOWN
03D799  FF 46 F0              INC    word ptr [bp - 0x10]         ; UNKNOWN
03D79C  C7 46 DC 00 00        MOV    word ptr [bp - 0x24], 0      ; UNKNOWN
03D7A1  A1 88 82              MOV    ax, word ptr [0x8288]        ; UNKNOWN
03D7A4  48                    DEC    ax                           ; UNKNOWN
03D7A5  48                    DEC    ax                           ; UNKNOWN
03D7A6  50                    PUSH   ax                           ; UNKNOWN
03D7A7  6A 01                 PUSH   1                            ; UNKNOWN
03D7A9  9A DA 00 AA 0D        LCALL  0xdaa, 0xda                  ; UNKNOWN
03D7AE  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03D7B1  89 46 EE              MOV    word ptr [bp - 0x12], ax     ; UNKNOWN
03D7B4  A1 8A 82              MOV    ax, word ptr [0x828a]        ; UNKNOWN
03D7B7  48                    DEC    ax                           ; UNKNOWN
03D7B8  48                    DEC    ax                           ; UNKNOWN
03D7B9  50                    PUSH   ax                           ; UNKNOWN
03D7BA  6A 01                 PUSH   1                            ; UNKNOWN
03D7BC  9A DA 00 AA 0D        LCALL  0xdaa, 0xda                  ; UNKNOWN
03D7C1  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03D7C4  89 46 E6              MOV    word ptr [bp - 0x1a], ax     ; UNKNOWN
03D7C7  FF 36 12 83           PUSH   word ptr [0x8312]            ; UNKNOWN
03D7CB  FF 36 10 83           PUSH   word ptr [0x8310]            ; UNKNOWN
03D7CF  FF 36 0E 83           PUSH   word ptr [0x830e]            ; UNKNOWN
03D7D3  FF 36 0C 83           PUSH   word ptr [0x830c]            ; UNKNOWN
03D7D7  8B 46 EE              MOV    ax, word ptr [bp - 0x12]     ; UNKNOWN
03D7DA  8B 56 E6              MOV    dx, word ptr [bp - 0x1a]     ; UNKNOWN
03D7DD  9A 04 00 75 5A        LCALL  0x5a75, 4                    ; UNKNOWN
03D7E2  2A E4                 SUB    ah, ah                       ; UNKNOWN
03D7E4  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
03D7E7  F6 46 FC 20           TEST   byte ptr [bp - 4], 0x20      ; UNKNOWN
03D7EB  75 B4                 JNE    0x3d7a1                      ; UNKNOWN
03D7ED  FF 76 E6              PUSH   word ptr [bp - 0x1a]         ; UNKNOWN
03D7F0  FF 76 EE              PUSH   word ptr [bp - 0x12]         ; UNKNOWN
03D7F3  9A 71 00 3C 22        LCALL  0x223c, 0x71                 ; UNKNOWN
03D7F8  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03D7FB  0B C0                 OR     ax, ax                       ; UNKNOWN
03D7FD  75 A2                 JNE    0x3d7a1                      ; UNKNOWN
03D7FF  8B 46 EE              MOV    ax, word ptr [bp - 0x12]     ; UNKNOWN
03D802  89 46 E4              MOV    word ptr [bp - 0x1c], ax     ; UNKNOWN
03D805  8B 46 E6              MOV    ax, word ptr [bp - 0x1a]     ; UNKNOWN
03D808  89 46 E0              MOV    word ptr [bp - 0x20], ax     ; UNKNOWN
03D80B  6A 03                 PUSH   3                            ; UNKNOWN
03D80D  6A 00                 PUSH   0                            ; UNKNOWN
03D80F  9A DA 00 AA 0D        LCALL  0xdaa, 0xda                  ; UNKNOWN
03D814  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03D817  D1 E0                 SHL    ax, 1                        ; UNKNOWN
03D819  89 46 DA              MOV    word ptr [bp - 0x26], ax     ; UNKNOWN
03D81C  6A 01                 PUSH   1                            ; UNKNOWN
03D81E  6A 00                 PUSH   0                            ; UNKNOWN
03D820  9A DA 00 AA 0D        LCALL  0xdaa, 0xda                  ; UNKNOWN
03D825  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03D828  89 46 EC              MOV    word ptr [bp - 0x14], ax     ; UNKNOWN
03D82B  FF 36 FA 82           PUSH   word ptr [0x82fa]            ; UNKNOWN
03D82F  FF 36 F8 82           PUSH   word ptr [0x82f8]            ; UNKNOWN
03D833  FF 36 F6 82           PUSH   word ptr [0x82f6]            ; UNKNOWN
03D837  FF 36 F4 82           PUSH   word ptr [0x82f4]            ; UNKNOWN
03D83B  80 4E FC 40           OR     byte ptr [bp - 4], 0x40      ; UNKNOWN
03D83F  8B 5E FC              MOV    bx, word ptr [bp - 4]        ; UNKNOWN
03D842  8B 46 EE              MOV    ax, word ptr [bp - 0x12]     ; UNKNOWN
03D845  8B 56 E6              MOV    dx, word ptr [bp - 0x1a]     ; UNKNOWN
03D848  9A 08 00 73 5A        LCALL  0x5a73, 8                    ; UNKNOWN
03D84D  FF 46 DC              INC    word ptr [bp - 0x24]         ; UNKNOWN
03D850  2B C0                 SUB    ax, ax                       ; UNKNOWN
03D852  89 46 F4              MOV    word ptr [bp - 0xc], ax      ; UNKNOWN
03D855  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; UNKNOWN
03D858  E9 A5 00              JMP    0x3d900                      ; UNKNOWN
03D85B  83 7E F6 04           CMP    word ptr [bp - 0xa], 4       ; UNKNOWN
03D85F  7C 03                 JL     0x3d864                      ; UNKNOWN
03D861  E9 A5 00              JMP    0x3d909                      ; UNKNOWN
03D864  8B 5E F6              MOV    bx, word ptr [bp - 0xa]      ; UNKNOWN
03D867  8A 87 21 09           MOV    al, byte ptr [bx + 0x921]    ; UNKNOWN
03D86B  98                    CWDE                                ; UNKNOWN
03D86C  03 46 E6              ADD    ax, word ptr [bp - 0x1a]     ; UNKNOWN
03D86F  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
03D872  50                    PUSH   ax                           ; UNKNOWN
03D873  8A 87 1C 09           MOV    al, byte ptr [bx + 0x91c]    ; UNKNOWN
03D877  98                    CWDE                                ; UNKNOWN
03D878  03 46 EE              ADD    ax, word ptr [bp - 0x12]     ; UNKNOWN
03D87B  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
03D87E  50                    PUSH   ax                           ; UNKNOWN
03D87F  9A 71 00 3C 22        LCALL  0x223c, 0x71                 ; UNKNOWN
03D884  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03D887  0B C0                 OR     ax, ax                       ; UNKNOWN
03D889  75 1F                 JNE    0x3d8aa                      ; UNKNOWN
03D88B  FF 36 12 83           PUSH   word ptr [0x8312]            ; UNKNOWN
03D88F  FF 36 10 83           PUSH   word ptr [0x8310]            ; UNKNOWN
03D893  FF 36 0E 83           PUSH   word ptr [0x830e]            ; UNKNOWN
03D897  FF 36 0C 83           PUSH   word ptr [0x830c]            ; UNKNOWN
03D89B  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
03D89E  8B 56 FA              MOV    dx, word ptr [bp - 6]        ; UNKNOWN
03D8A1  9A 04 00 75 5A        LCALL  0x5a75, 4                    ; UNKNOWN
03D8A6  A8 40                 TEST   al, 0x40                     ; UNKNOWN
03D8A8  74 53                 JE     0x3d8fd                      ; UNKNOWN
03D8AA  C7 46 F4 01 00        MOV    word ptr [bp - 0xc], 1       ; UNKNOWN
03D8AF  FF 36 FA 82           PUSH   word ptr [0x82fa]            ; UNKNOWN
03D8B3  FF 36 F8 82           PUSH   word ptr [0x82f8]            ; UNKNOWN
03D8B7  FF 36 F6 82           PUSH   word ptr [0x82f6]            ; UNKNOWN
03D8BB  FF 36 F4 82           PUSH   word ptr [0x82f4]            ; UNKNOWN
03D8BF  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
03D8C2  8B 56 FA              MOV    dx, word ptr [bp - 6]        ; UNKNOWN
03D8C5  9A 04 00 75 5A        LCALL  0x5a75, 4                    ; UNKNOWN
03D8CA  2A E4                 SUB    ah, ah                       ; UNKNOWN
03D8CC  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
03D8CF  FF 36 FA 82           PUSH   word ptr [0x82fa]            ; UNKNOWN
03D8D3  FF 36 F8 82           PUSH   word ptr [0x82f8]            ; UNKNOWN
03D8D7  FF 36 F6 82           PUSH   word ptr [0x82f6]            ; UNKNOWN
03D8DB  FF 36 F4 82           PUSH   word ptr [0x82f4]            ; UNKNOWN
03D8DF  80 4E FC 40           OR     byte ptr [bp - 4], 0x40      ; UNKNOWN
03D8E3  8B 5E FC              MOV    bx, word ptr [bp - 4]        ; UNKNOWN
03D8E6  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
03D8E9  8B 56 FA              MOV    dx, word ptr [bp - 6]        ; UNKNOWN
03D8EC  9A 08 00 73 5A        LCALL  0x5a73, 8                    ; UNKNOWN
03D8F1  8B 46 EE              MOV    ax, word ptr [bp - 0x12]     ; UNKNOWN
03D8F4  89 46 E8              MOV    word ptr [bp - 0x18], ax     ; UNKNOWN
03D8F7  8B 46 E6              MOV    ax, word ptr [bp - 0x1a]     ; UNKNOWN
03D8FA  89 46 E2              MOV    word ptr [bp - 0x1e], ax     ; UNKNOWN
03D8FD  FF 46 F6              INC    word ptr [bp - 0xa]          ; UNKNOWN
03D900  83 7E F4 00           CMP    word ptr [bp - 0xc], 0       ; UNKNOWN
03D904  75 03                 JNE    0x3d909                      ; UNKNOWN
03D906  E9 52 FF              JMP    0x3d85b                      ; UNKNOWN
03D909  6A 63                 PUSH   0x63                         ; UNKNOWN
03D90B  6A 00                 PUSH   0                            ; UNKNOWN
03D90D  9A DA 00 AA 0D        LCALL  0xdaa, 0xda                  ; UNKNOWN
03D912  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03D915  83 F8 3C              CMP    ax, 0x3c                     ; UNKNOWN
03D918  7D 08                 JGE    0x3d922                      ; UNKNOWN
03D91A  8B 46 DA              MOV    ax, word ptr [bp - 0x26]     ; UNKNOWN
03D91D  89 46 F2              MOV    word ptr [bp - 0xe], ax      ; UNKNOWN
03D920  EB 37                 JMP    0x3d959                      ; UNKNOWN
03D922  83 F8 5F              CMP    ax, 0x5f                     ; UNKNOWN
03D925  7E 0B                 JLE    0x3d932                      ; UNKNOWN
03D927  83 7E EC 01           CMP    word ptr [bp - 0x14], 1      ; UNKNOWN
03D92B  1B C0                 SBB    ax, ax                       ; UNKNOWN
03D92D  F7 D8                 NEG    ax                           ; UNKNOWN
03D92F  89 46 EC              MOV    word ptr [bp - 0x14], ax     ; UNKNOWN
03D932  83 7E EC 00           CMP    word ptr [bp - 0x14], 0      ; UNKNOWN
03D936  74 07                 JE     0x3d93f                      ; UNKNOWN
03D938  8B 46 DA              MOV    ax, word ptr [bp - 0x26]     ; UNKNOWN
03D93B  40                    INC    ax                           ; UNKNOWN
03D93C  40                    INC    ax                           ; UNKNOWN
03D93D  EB 06                 JMP    0x3d945                      ; UNKNOWN
03D93F  8B 46 DA              MOV    ax, word ptr [bp - 0x26]     ; UNKNOWN
03D942  83 C0 06              ADD    ax, 6                        ; UNKNOWN
03D945  B9 08 00              MOV    cx, 8                        ; UNKNOWN
03D948  99                    CDQ                                 ; UNKNOWN
03D949  F7 F9                 IDIV   cx                           ; UNKNOWN
03D94B  89 56 F2              MOV    word ptr [bp - 0xe], dx      ; UNKNOWN
03D94E  83 7E EC 01           CMP    word ptr [bp - 0x14], 1      ; UNKNOWN
03D952  1B C0                 SBB    ax, ax                       ; UNKNOWN
03D954  F7 D8                 NEG    ax                           ; UNKNOWN
03D956  89 46 EC              MOV    word ptr [bp - 0x14], ax     ; UNKNOWN
03D959  8B 46 F2              MOV    ax, word ptr [bp - 0xe]      ; UNKNOWN
03D95C  89 46 DA              MOV    word ptr [bp - 0x26], ax     ; UNKNOWN
03D95F  FF 36 12 83           PUSH   word ptr [0x8312]            ; UNKNOWN
03D963  FF 36 10 83           PUSH   word ptr [0x8310]            ; UNKNOWN
03D967  FF 36 0E 83           PUSH   word ptr [0x830e]            ; UNKNOWN
03D96B  FF 36 0C 83           PUSH   word ptr [0x830c]            ; UNKNOWN
03D96F  8B D8                 MOV    bx, ax                       ; UNKNOWN
03D971  8A 87 2F 09           MOV    al, byte ptr [bx + 0x92f]    ; UNKNOWN
03D975  98                    CWDE                                ; UNKNOWN
03D976  01 46 E6              ADD    word ptr [bp - 0x1a], ax     ; UNKNOWN
03D979  8B 56 E6              MOV    dx, word ptr [bp - 0x1a]     ; UNKNOWN
03D97C  8A 87 26 09           MOV    al, byte ptr [bx + 0x926]    ; UNKNOWN
03D980  98                    CWDE                                ; UNKNOWN
03D981  01 46 EE              ADD    word ptr [bp - 0x12], ax     ; UNKNOWN
03D984  8B 46 EE              MOV    ax, word ptr [bp - 0x12]     ; UNKNOWN
03D987  9A 04 00 75 5A        LCALL  0x5a75, 4                    ; UNKNOWN
03D98C  2A E4                 SUB    ah, ah                       ; UNKNOWN
03D98E  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
03D991  83 7E F4 00           CMP    word ptr [bp - 0xc], 0       ; UNKNOWN
03D995  75 21                 JNE    0x3d9b8                      ; UNKNOWN
03D997  FF 76 E6              PUSH   word ptr [bp - 0x1a]         ; UNKNOWN
03D99A  FF 76 EE              PUSH   word ptr [bp - 0x12]         ; UNKNOWN
03D99D  9A 02 00 C9 33        LCALL  0x33c9, 2                    ; UNKNOWN
03D9A2  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03D9A5  0B C0                 OR     ax, ax                       ; UNKNOWN
03D9A7  74 0F                 JE     0x3d9b8                      ; UNKNOWN
03D9A9  F6 46 FC 40           TEST   byte ptr [bp - 4], 0x40      ; UNKNOWN
03D9AD  75 09                 JNE    0x3d9b8                      ; UNKNOWN
03D9AF  F6 46 FC 20           TEST   byte ptr [bp - 4], 0x20      ; UNKNOWN
03D9B3  75 03                 JNE    0x3d9b8                      ; UNKNOWN
03D9B5  E9 73 FE              JMP    0x3d82b                      ; UNKNOWN
03D9B8  83 7E F4 00           CMP    word ptr [bp - 0xc], 0       ; UNKNOWN
03D9BC  75 06                 JNE    0x3d9c4                      ; UNKNOWN
03D9BE  F6 46 FC 40           TEST   byte ptr [bp - 4], 0x40      ; UNKNOWN
03D9C2  74 06                 JE     0x3d9ca                      ; UNKNOWN
03D9C4  83 7E DC 03           CMP    word ptr [bp - 0x24], 3      ; UNKNOWN
03D9C8  7D 1F                 JGE    0x3d9e9                      ; UNKNOWN
03D9CA  FF 36 30 0B           PUSH   word ptr [0xb30]             ; UNKNOWN
03D9CE  FF 36 1A 0B           PUSH   word ptr [0xb1a]             ; UNKNOWN
03D9D2  FF 36 18 0B           PUSH   word ptr [0xb18]             ; UNKNOWN
03D9D6  FF 36 0E 0B           PUSH   word ptr [0xb0e]             ; UNKNOWN
03D9DA  FF 36 0C 0B           PUSH   word ptr [0xb0c]             ; UNKNOWN
03D9DE  9A BE 12 65 5F        LCALL  0x5f65, 0x12be               ; UNKNOWN
03D9E3  83 C4 0A              ADD    sp, 0xa                      ; UNKNOWN
03D9E6  E9 7D 01              JMP    0x3db66                      ; UNKNOWN
03D9E9  FF 46 DE              INC    word ptr [bp - 0x22]         ; UNKNOWN
03D9EC  83 7E F4 00           CMP    word ptr [bp - 0xc], 0       ; UNKNOWN
03D9F0  75 03                 JNE    0x3d9f5                      ; UNKNOWN
03D9F2  E9 F1 00              JMP    0x3dae6                      ; UNKNOWN
03D9F5  A1 82 0B              MOV    ax, word ptr [0xb82]         ; UNKNOWN
03D9F8  83 C0 06              ADD    ax, 6                        ; UNKNOWN
03D9FB  D1 E0                 SHL    ax, 1                        ; UNKNOWN
03D9FD  50                    PUSH   ax                           ; UNKNOWN
03D9FE  6A 01                 PUSH   1                            ; UNKNOWN
03DA00  9A DA 00 AA 0D        LCALL  0xdaa, 0xda                  ; UNKNOWN
03DA05  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03DA08  83 F8 06              CMP    ax, 6                        ; UNKNOWN
03DA0B  7F 03                 JG     0x3da10                      ; UNKNOWN
03DA0D  E9 D6 00              JMP    0x3dae6                      ; UNKNOWN
03DA10  A1 82 0B              MOV    ax, word ptr [0xb82]         ; UNKNOWN
03DA13  D1 E0                 SHL    ax, 1                        ; UNKNOWN
03DA15  83 C0 03              ADD    ax, 3                        ; UNKNOWN
03DA18  50                    PUSH   ax                           ; UNKNOWN
03DA19  6A 01                 PUSH   1                            ; UNKNOWN
03DA1B  9A DA 00 AA 0D        LCALL  0xdaa, 0xda                  ; UNKNOWN
03DA20  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03DA23  89 46 EA              MOV    word ptr [bp - 0x16], ax     ; UNKNOWN
03DA26  FF 36 FA 82           PUSH   word ptr [0x82fa]            ; UNKNOWN
03DA2A  FF 36 F8 82           PUSH   word ptr [0x82f8]            ; UNKNOWN
03DA2E  FF 36 F6 82           PUSH   word ptr [0x82f6]            ; UNKNOWN
03DA32  FF 36 F4 82           PUSH   word ptr [0x82f4]            ; UNKNOWN
03DA36  8B 46 E8              MOV    ax, word ptr [bp - 0x18]     ; UNKNOWN
03DA39  8B 56 E2              MOV    dx, word ptr [bp - 0x1e]     ; UNKNOWN
03DA3C  9A 04 00 75 5A        LCALL  0x5a75, 4                    ; UNKNOWN
03DA41  2A E4                 SUB    ah, ah                       ; UNKNOWN
03DA43  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
03DA46  FF 36 FA 82           PUSH   word ptr [0x82fa]            ; UNKNOWN
03DA4A  FF 36 F8 82           PUSH   word ptr [0x82f8]            ; UNKNOWN
03DA4E  FF 36 F6 82           PUSH   word ptr [0x82f6]            ; UNKNOWN
03DA52  FF 36 F4 82           PUSH   word ptr [0x82f4]            ; UNKNOWN
03DA56  80 4E FC 80           OR     byte ptr [bp - 4], 0x80      ; UNKNOWN
03DA5A  8B 5E FC              MOV    bx, word ptr [bp - 4]        ; UNKNOWN
03DA5D  8B 46 E8              MOV    ax, word ptr [bp - 0x18]     ; UNKNOWN
03DA60  8B 56 E2              MOV    dx, word ptr [bp - 0x1e]     ; UNKNOWN
03DA63  9A 08 00 73 5A        LCALL  0x5a73, 8                    ; UNKNOWN
03DA68  C7 46 F2 FF FF        MOV    word ptr [bp - 0xe], 0xffff  ; UNKNOWN
03DA6D  C7 46 F6 00 00        MOV    word ptr [bp - 0xa], 0       ; UNKNOWN
03DA72  EB 03                 JMP    0x3da77                      ; UNKNOWN
03DA74  FF 46 F6              INC    word ptr [bp - 0xa]          ; UNKNOWN
03DA77  83 7E F2 00           CMP    word ptr [bp - 0xe], 0       ; UNKNOWN
03DA7B  7D 57                 JGE    0x3dad4                      ; UNKNOWN
03DA7D  83 7E F6 04           CMP    word ptr [bp - 0xa], 4       ; UNKNOWN
03DA81  7D 51                 JGE    0x3dad4                      ; UNKNOWN
03DA83  8B 5E F6              MOV    bx, word ptr [bp - 0xa]      ; UNKNOWN
03DA86  8A 87 21 09           MOV    al, byte ptr [bx + 0x921]    ; UNKNOWN
03DA8A  98                    CWDE                                ; UNKNOWN
03DA8B  03 46 E2              ADD    ax, word ptr [bp - 0x1e]     ; UNKNOWN
03DA8E  89 46 E6              MOV    word ptr [bp - 0x1a], ax     ; UNKNOWN
03DA91  FF 36 FA 82           PUSH   word ptr [0x82fa]            ; UNKNOWN
03DA95  FF 36 F8 82           PUSH   word ptr [0x82f8]            ; UNKNOWN
03DA99  FF 36 F6 82           PUSH   word ptr [0x82f6]            ; UNKNOWN
03DA9D  FF 36 F4 82           PUSH   word ptr [0x82f4]            ; UNKNOWN
03DAA1  8B D0                 MOV    dx, ax                       ; UNKNOWN
03DAA3  8A 87 1C 09           MOV    al, byte ptr [bx + 0x91c]    ; UNKNOWN
03DAA7  98                    CWDE                                ; UNKNOWN
03DAA8  03 46 E8              ADD    ax, word ptr [bp - 0x18]     ; UNKNOWN
03DAAB  89 46 EE              MOV    word ptr [bp - 0x12], ax     ; UNKNOWN
03DAAE  9A 04 00 75 5A        LCALL  0x5a75, 4                    ; UNKNOWN
03DAB3  2A E4                 SUB    ah, ah                       ; UNKNOWN
03DAB5  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
03DAB8  A8 40                 TEST   al, 0x40                     ; UNKNOWN
03DABA  74 B8                 JE     0x3da74                      ; UNKNOWN
03DABC  F6 46 FC 80           TEST   byte ptr [bp - 4], 0x80      ; UNKNOWN
03DAC0  75 B2                 JNE    0x3da74                      ; UNKNOWN
03DAC2  8B 46 F6              MOV    ax, word ptr [bp - 0xa]      ; UNKNOWN
03DAC5  89 46 F2              MOV    word ptr [bp - 0xe], ax      ; UNKNOWN
03DAC8  8B 46 EE              MOV    ax, word ptr [bp - 0x12]     ; UNKNOWN
03DACB  89 46 E8              MOV    word ptr [bp - 0x18], ax     ; UNKNOWN
03DACE  8B 46 E6              MOV    ax, word ptr [bp - 0x1a]     ; UNKNOWN
03DAD1  89 46 E2              MOV    word ptr [bp - 0x1e], ax     ; UNKNOWN
03DAD4  FF 4E EA              DEC    word ptr [bp - 0x16]         ; UNKNOWN
03DAD7  83 7E EA 00           CMP    word ptr [bp - 0x16], 0      ; UNKNOWN
03DADB  7E 09                 JLE    0x3dae6                      ; UNKNOWN
03DADD  83 7E F2 00           CMP    word ptr [bp - 0xe], 0       ; UNKNOWN
03DAE1  7C 03                 JL     0x3dae6                      ; UNKNOWN
03DAE3  E9 60 FF              JMP    0x3da46                      ; UNKNOWN
03DAE6  C7 46 F6 00 00        MOV    word ptr [bp - 0xa], 0       ; UNKNOWN
03DAEB  8B 5E F6              MOV    bx, word ptr [bp - 0xa]      ; UNKNOWN
03DAEE  8A 87 4D 09           MOV    al, byte ptr [bx + 0x94d]    ; UNKNOWN
03DAF2  98                    CWDE                                ; UNKNOWN
03DAF3  03 46 E0              ADD    ax, word ptr [bp - 0x20]     ; UNKNOWN
03DAF6  89 46 E6              MOV    word ptr [bp - 0x1a], ax     ; UNKNOWN
03DAF9  FF 36 FA 82           PUSH   word ptr [0x82fa]            ; UNKNOWN
03DAFD  FF 36 F8 82           PUSH   word ptr [0x82f8]            ; UNKNOWN
03DB01  FF 36 F6 82           PUSH   word ptr [0x82f6]            ; UNKNOWN
03DB05  FF 36 F4 82           PUSH   word ptr [0x82f4]            ; UNKNOWN
03DB09  8B D0                 MOV    dx, ax                       ; UNKNOWN
03DB0B  8A 87 38 09           MOV    al, byte ptr [bx + 0x938]    ; UNKNOWN
03DB0F  98                    CWDE                                ; UNKNOWN
03DB10  03 46 E4              ADD    ax, word ptr [bp - 0x1c]     ; UNKNOWN
03DB13  89 46 EE              MOV    word ptr [bp - 0x12], ax     ; UNKNOWN
03DB16  9A 04 00 75 5A        LCALL  0x5a75, 4                    ; UNKNOWN
03DB1B  2A E4                 SUB    ah, ah                       ; UNKNOWN
03DB1D  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
03DB20  24 1F                 AND    al, 0x1f                     ; UNKNOWN
03DB22  3C 10                 CMP    al, 0x10                     ; UNKNOWN
03DB24  73 37                 JAE    0x3db5d                      ; UNKNOWN
03DB26  6A 01                 PUSH   1                            ; UNKNOWN
03DB28  6A 00                 PUSH   0                            ; UNKNOWN
03DB2A  9A DA 00 AA 0D        LCALL  0xdaa, 0xda                  ; UNKNOWN
03DB2F  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03DB32  0B C0                 OR     ax, ax                       ; UNKNOWN
03DB34  74 27                 JE     0x3db5d                      ; UNKNOWN
03DB36  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
03DB39  83 C0 08              ADD    ax, 8                        ; UNKNOWN
03DB3C  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
03DB3F  FF 36 FA 82           PUSH   word ptr [0x82fa]            ; UNKNOWN
03DB43  FF 36 F8 82           PUSH   word ptr [0x82f8]            ; UNKNOWN
03DB47  FF 36 F6 82           PUSH   word ptr [0x82f6]            ; UNKNOWN
03DB4B  FF 36 F4 82           PUSH   word ptr [0x82f4]            ; UNKNOWN
03DB4F  8B 46 EE              MOV    ax, word ptr [bp - 0x12]     ; UNKNOWN
03DB52  8B 56 E6              MOV    dx, word ptr [bp - 0x1a]     ; UNKNOWN
03DB55  8B 5E FC              MOV    bx, word ptr [bp - 4]        ; UNKNOWN
03DB58  9A 08 00 73 5A        LCALL  0x5a73, 8                    ; UNKNOWN
03DB5D  FF 46 F6              INC    word ptr [bp - 0xa]          ; UNKNOWN
03DB60  83 7E F6 14           CMP    word ptr [bp - 0xa], 0x14    ; UNKNOWN
03DB64  7C 85                 JL     0x3daeb                      ; UNKNOWN
03DB66  9A 05 03 EF 21        LCALL  0x21ef, 0x305                ; UNKNOWN
03DB6B  81 7E F0 00 02        CMP    word ptr [bp - 0x10], 0x200  ; UNKNOWN
03DB70  7D 14                 JGE    0x3db86                      ; UNKNOWN
03DB72  A1 82 0B              MOV    ax, word ptr [0xb82]         ; UNKNOWN
03DB75  03 06 7C 0B           ADD    ax, word ptr [0xb7c]         ; UNKNOWN
03DB79  40                    INC    ax                           ; UNKNOWN
03DB7A  40                    INC    ax                           ; UNKNOWN
03DB7B  C1 E0 03              SHL    ax, 3                        ; UNKNOWN
03DB7E  3B 46 DE              CMP    ax, word ptr [bp - 0x22]     ; UNKNOWN
03DB81  7E 03                 JLE    0x3db86                      ; UNKNOWN
03DB83  E9 F7 FB              JMP    0x3d77d                      ; UNKNOWN
03DB86  C9                    LEAVE                               ; UNKNOWN
03DB87  CB                    RETF                                ; UNKNOWN
