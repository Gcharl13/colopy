; ============================================================================
; func_00A3E1_unknown
; Region   : load_image
; Bytes    : file 0x00A3E1..0x00A6A2  (705 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00A3E1  C8 8D 00 00           ENTER  0x8d, 0                      ; UNKNOWN
00A3E5  FF 46 E4              INC    word ptr [bp - 0x1c]         ; UNKNOWN
00A3E8  83 7E E4 14           CMP    word ptr [bp - 0x1c], 0x14   ; CMP
00A3EC  7C EC                 JL     0xa3da                       ; UNKNOWN
00A3EE  A0 91 A8              MOV    al, byte ptr [0xa891]        ; UNKNOWN
00A3F1  2A E4                 SUB    ah, ah                       ; UNKNOWN
00A3F3  01 06 C8 8D           ADD    word ptr [0x8dc8], ax        ; UNKNOWN
00A3F7  38 26 93 A8           CMP    byte ptr [0xa893], ah        ; UNKNOWN
00A3FB  7C 10                 JL     0xa40d                       ; UNKNOWN
00A3FD  A0 93 A8              MOV    al, byte ptr [0xa893]        ; UNKNOWN
00A400  98                    CWDE                                ; UNKNOWN
00A401  8B D8                 MOV    bx, ax                       ; UNKNOWN
00A403  D1 E3                 SHL    bx, 1                        ; UNKNOWN
00A405  A0 94 A8              MOV    al, byte ptr [0xa894]        ; UNKNOWN
00A408  98                    CWDE                                ; UNKNOWN
00A409  01 87 C8 8D           ADD    word ptr [bx - 0x7238], ax   ; ARITH
00A40D  C7 46 E6 00 00        MOV    word ptr [bp - 0x1a], 0      ; LOCAL_STORE
00A412  EB 57                 JMP    0xa46b                       ; UNKNOWN
00A414  FF 46 E8              INC    word ptr [bp - 0x18]         ; UNKNOWN
00A417  83 7E E8 05           CMP    word ptr [bp - 0x18], 5      ; CMP
00A41B  7D 4B                 JGE    0xa468                       ; UNKNOWN
00A41D  6A 01                 PUSH   1                            ; UNKNOWN
00A41F  8D 46 EA              LEA    ax, [bp - 0x16]              ; UNKNOWN
00A422  50                    PUSH   ax                           ; UNKNOWN
00A423  FF 76 E6              PUSH   word ptr [bp - 0x1a]         ; UNKNOWN
00A426  FF 76 E8              PUSH   word ptr [bp - 0x18]         ; UNKNOWN
00A429  0E                    PUSH   cs                           ; UNKNOWN
00A42A  E8 6F F7              CALL   0x9b9c                       ; UNKNOWN
00A42D  83 C4 08              ADD    sp, 8                        ; UNKNOWN
00A430  89 46 F0              MOV    word ptr [bp - 0x10], ax     ; LOCAL_STORE
00A433  83 7E EA 00           CMP    word ptr [bp - 0x16], 0      ; CMP
00A437  7C DB                 JL     0xa414                       ; UNKNOWN
00A439  FF 76 E6              PUSH   word ptr [bp - 0x1a]         ; UNKNOWN
00A43C  FF 76 E8              PUSH   word ptr [bp - 0x18]         ; UNKNOWN
00A43F  0E                    PUSH   cs                           ; UNKNOWN
00A440  E8 13 E5              CALL   0x8956                       ; UNKNOWN
00A443  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00A446  98                    CWDE                                ; UNKNOWN
00A447  8B F0                 MOV    si, ax                       ; UNKNOWN
00A449  8B 1E 42 85           MOV    bx, word ptr [0x8542]        ; UNKNOWN
00A44D  80 78 20 08           CMP    byte ptr [bx + si + 0x20], 8 ; CMP
00A451  75 07                 JNE    0xa45a                       ; UNKNOWN
00A453  8A 46 F0              MOV    al, byte ptr [bp - 0x10]     ; LOCAL_LOAD
00A456  00 06 95 A8           ADD    byte ptr [0xa895], al        ; UNKNOWN
00A45A  8B 46 F0              MOV    ax, word ptr [bp - 0x10]     ; LOCAL_LOAD
00A45D  8B 5E EA              MOV    bx, word ptr [bp - 0x16]     ; LOCAL_LOAD
00A460  D1 E3                 SHL    bx, 1                        ; UNKNOWN
00A462  01 87 C8 8D           ADD    word ptr [bx - 0x7238], ax   ; ARITH
00A466  EB AC                 JMP    0xa414                       ; UNKNOWN
00A468  FF 46 E6              INC    word ptr [bp - 0x1a]         ; UNKNOWN
00A46B  83 7E E6 05           CMP    word ptr [bp - 0x1a], 5      ; CMP
00A46F  7D 07                 JGE    0xa478                       ; UNKNOWN
00A471  C7 46 E8 00 00        MOV    word ptr [bp - 0x18], 0      ; LOCAL_STORE
00A476  EB 9F                 JMP    0xa417                       ; UNKNOWN
00A478  C7 46 E4 00 00        MOV    word ptr [bp - 0x1c], 0      ; LOCAL_STORE
00A47D  EB 24                 JMP    0xa4a3                       ; UNKNOWN
00A47F  90                    NOP                                 ; UNKNOWN
00A480  8D 46 DA              LEA    ax, [bp - 0x26]              ; UNKNOWN
00A483  50                    PUSH   ax                           ; UNKNOWN
00A484  FF 76 E4              PUSH   word ptr [bp - 0x1c]         ; UNKNOWN
00A487  0E                    PUSH   cs                           ; UNKNOWN
00A488  E8 71 FB              CALL   0x9ffc                       ; UNKNOWN
00A48B  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00A48E  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; LOCAL_STORE
00A491  83 7E DA 00           CMP    word ptr [bp - 0x26], 0      ; CMP
00A495  7C 09                 JL     0xa4a0                       ; UNKNOWN
00A497  8B 5E DA              MOV    bx, word ptr [bp - 0x26]     ; LOCAL_LOAD
00A49A  D1 E3                 SHL    bx, 1                        ; UNKNOWN
00A49C  01 87 C8 8D           ADD    word ptr [bx - 0x7238], ax   ; ARITH
00A4A0  FF 46 E4              INC    word ptr [bp - 0x1c]         ; UNKNOWN
00A4A3  8B 1E 42 85           MOV    bx, word ptr [0x8542]        ; UNKNOWN
00A4A7  8A 47 1F              MOV    al, byte ptr [bx + 0x1f]     ; MOV
00A4AA  98                    CWDE                                ; UNKNOWN
00A4AB  3B 46 E4              CMP    ax, word ptr [bp - 0x1c]     ; CMP
00A4AE  7F D0                 JG     0xa480                       ; UNKNOWN
00A4B0  FF 06 EA 8D           INC    word ptr [0x8dea]            ; UNKNOWN
00A4B4  6A 25                 PUSH   0x25                         ; UNKNOWN
00A4B6  0E                    PUSH   cs                           ; UNKNOWN
00A4B7  E8 84 E1              CALL   0x863e                       ; UNKNOWN
00A4BA  83 C4 02              ADD    sp, 2                        ; UNKNOWN
00A4BD  0B C0                 OR     ax, ax                       ; UNKNOWN
00A4BF  74 04                 JE     0xa4c5                       ; UNKNOWN
00A4C1  FF 06 EA 8D           INC    word ptr [0x8dea]            ; UNKNOWN
00A4C5  6A 26                 PUSH   0x26                         ; UNKNOWN
00A4C7  0E                    PUSH   cs                           ; UNKNOWN
00A4C8  E8 73 E1              CALL   0x863e                       ; UNKNOWN
00A4CB  83 C4 02              ADD    sp, 2                        ; UNKNOWN
00A4CE  0B C0                 OR     ax, ax                       ; UNKNOWN
00A4D0  74 04                 JE     0xa4d6                       ; UNKNOWN
00A4D2  FF 06 EA 8D           INC    word ptr [0x8dea]            ; UNKNOWN
00A4D6  C6 06 92 A8 00        MOV    byte ptr [0xa892], 0         ; UNKNOWN
00A4DB  FF 06 EC 8D           INC    word ptr [0x8dec]            ; UNKNOWN
00A4DF  6A 0F                 PUSH   0xf                          ; UNKNOWN
00A4E1  8B 1E 42 85           MOV    bx, word ptr [0x8542]        ; UNKNOWN
00A4E5  8A 47 1A              MOV    al, byte ptr [bx + 0x1a]     ; MOV
00A4E8  2A E4                 SUB    ah, ah                       ; UNKNOWN
00A4EA  50                    PUSH   ax                           ; UNKNOWN
00A4EB  9A 00 00 81 09        LCALL  0x981, 0                     ; UNKNOWN
00A4F0  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00A4F3  0B C0                 OR     ax, ax                       ; UNKNOWN
00A4F5  74 09                 JE     0xa500                       ; UNKNOWN
00A4F7  A1 EC 8D              MOV    ax, word ptr [0x8dec]        ; UNKNOWN
00A4FA  D1 E8                 SHR    ax, 1                        ; UNKNOWN
00A4FC  01 06 EC 8D           ADD    word ptr [0x8dec], ax        ; UNKNOWN
00A500  6A 11                 PUSH   0x11                         ; UNKNOWN
00A502  8B 1E 42 85           MOV    bx, word ptr [0x8542]        ; UNKNOWN
00A506  8A 47 1A              MOV    al, byte ptr [bx + 0x1a]     ; MOV
00A509  2A E4                 SUB    ah, ah                       ; UNKNOWN
00A50B  50                    PUSH   ax                           ; UNKNOWN
00A50C  9A 00 00 81 09        LCALL  0x981, 0                     ; UNKNOWN
00A511  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00A514  0B C0                 OR     ax, ax                       ; UNKNOWN
00A516  74 21                 JE     0xa539                       ; UNKNOWN
00A518  8B 1E 42 85           MOV    bx, word ptr [0x8542]        ; UNKNOWN
00A51C  8A 47 1A              MOV    al, byte ptr [bx + 0x1a]     ; MOV
00A51F  2A E4                 SUB    ah, ah                       ; UNKNOWN
00A521  69 D8 3C 01           IMUL   bx, ax, 0x13c                ; UNKNOWN
00A525  8A 87 09 88           MOV    al, byte ptr [bx - 0x77f7]   ; MOV
00A529  98                    CWDE                                ; UNKNOWN
00A52A  F7 26 EC 8D           MUL    word ptr [0x8dec]            ; UNKNOWN
00A52E  B9 64 00              MOV    cx, 0x64                     ; UNKNOWN
00A531  2B D2                 SUB    dx, dx                       ; UNKNOWN
00A533  F7 F1                 DIV    cx                           ; UNKNOWN
00A535  01 06 EC 8D           ADD    word ptr [0x8dec], ax        ; UNKNOWN
00A539  6A 12                 PUSH   0x12                         ; UNKNOWN
00A53B  8B 1E 42 85           MOV    bx, word ptr [0x8542]        ; UNKNOWN
00A53F  8A 47 1A              MOV    al, byte ptr [bx + 0x1a]     ; MOV
00A542  2A E4                 SUB    ah, ah                       ; UNKNOWN
00A544  50                    PUSH   ax                           ; UNKNOWN
00A545  9A 00 00 81 09        LCALL  0x981, 0                     ; UNKNOWN
00A54A  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00A54D  0B C0                 OR     ax, ax                       ; UNKNOWN
00A54F  74 2D                 JE     0xa57e                       ; UNKNOWN
00A551  8B 1E 42 85           MOV    bx, word ptr [0x8542]        ; UNKNOWN
00A555  80 7F 1A 04           CMP    byte ptr [bx + 0x1a], 4      ; CMP
00A559  73 0E                 JAE    0xa569                       ; UNKNOWN
00A55B  8A 47 1A              MOV    al, byte ptr [bx + 0x1a]     ; MOV
00A55E  2A E4                 SUB    ah, ah                       ; UNKNOWN
00A560  6B D8 34              IMUL   bx, ax, 0x34                 ; UNKNOWN
00A563  38 A7 3F 54           CMP    byte ptr [bx + 0x543f], ah   ; CMP
00A567  74 15                 JE     0xa57e                       ; UNKNOWN
00A569  8B 1E 42 85           MOV    bx, word ptr [0x8542]        ; UNKNOWN
00A56D  8A 47 1F              MOV    al, byte ptr [bx + 0x1f]     ; MOV
00A570  98                    CWDE                                ; UNKNOWN
00A571  05 03 00              ADD    ax, 3                        ; UNKNOWN
00A574  B9 05 00              MOV    cx, 5                        ; UNKNOWN
00A577  99                    CDQ                                 ; UNKNOWN
00A578  F7 F9                 IDIV   cx                           ; UNKNOWN
00A57A  01 06 EC 8D           ADD    word ptr [0x8dec], ax        ; UNKNOWN
00A57E  A0 92 A8              MOV    al, byte ptr [0xa892]        ; UNKNOWN
00A581  2A E4                 SUB    ah, ah                       ; UNKNOWN
00A583  01 06 EC 8D           ADD    word ptr [0x8dec], ax        ; UNKNOWN
00A587  6A 14                 PUSH   0x14                         ; UNKNOWN
00A589  0E                    PUSH   cs                           ; UNKNOWN
00A58A  E8 B1 E0              CALL   0x863e                       ; UNKNOWN
00A58D  83 C4 02              ADD    sp, 2                        ; UNKNOWN
00A590  0B C0                 OR     ax, ax                       ; UNKNOWN
00A592  74 06                 JE     0xa59a                       ; UNKNOWN
00A594  D1 26 EC 8D           SHL    word ptr [0x8dec], 1         ; UNKNOWN
00A598  EB 16                 JMP    0xa5b0                       ; UNKNOWN
00A59A  6A 13                 PUSH   0x13                         ; UNKNOWN
00A59C  0E                    PUSH   cs                           ; UNKNOWN
00A59D  E8 9E E0              CALL   0x863e                       ; UNKNOWN
00A5A0  83 C4 02              ADD    sp, 2                        ; UNKNOWN
00A5A3  0B C0                 OR     ax, ax                       ; UNKNOWN
00A5A5  74 09                 JE     0xa5b0                       ; UNKNOWN
00A5A7  A1 EC 8D              MOV    ax, word ptr [0x8dec]        ; UNKNOWN
00A5AA  D1 E8                 SHR    ax, 1                        ; UNKNOWN
00A5AC  01 06 EC 8D           ADD    word ptr [0x8dec], ax        ; UNKNOWN
00A5B0  8B 1E 42 85           MOV    bx, word ptr [0x8542]        ; UNKNOWN
00A5B4  83 BF AA 00 02        CMP    word ptr [bx + 0xaa], 2      ; CMP
00A5B9  7C 2B                 JL     0xa5e6                       ; UNKNOWN
00A5BB  C7 46 E2 19 00        MOV    word ptr [bp - 0x1e], 0x19   ; LOCAL_STORE
00A5C0  6A 11                 PUSH   0x11                         ; UNKNOWN
00A5C2  0E                    PUSH   cs                           ; UNKNOWN
00A5C3  E8 78 E0              CALL   0x863e                       ; UNKNOWN
00A5C6  83 C4 02              ADD    sp, 2                        ; UNKNOWN
00A5C9  0B C0                 OR     ax, ax                       ; UNKNOWN
00A5CB  75 05                 JNE    0xa5d2                       ; UNKNOWN
00A5CD  C7 46 E2 32 00        MOV    word ptr [bp - 0x1e], 0x32   ; LOCAL_STORE
00A5D2  8B 1E 42 85           MOV    bx, word ptr [0x8542]        ; UNKNOWN
00A5D6  8B 87 AA 00           MOV    ax, word ptr [bx + 0xaa]     ; MOV
00A5DA  03 46 E2              ADD    ax, word ptr [bp - 0x1e]     ; ARITH
00A5DD  48                    DEC    ax                           ; UNKNOWN
00A5DE  99                    CDQ                                 ; UNKNOWN
00A5DF  F7 7E E2              IDIV   word ptr [bp - 0x1e]         ; UNKNOWN
00A5E2  D1 E0                 SHL    ax, 1                        ; UNKNOWN
00A5E4  EB 02                 JMP    0xa5e8                       ; UNKNOWN
00A5E6  2B C0                 SUB    ax, ax                       ; UNKNOWN
00A5E8  89 46 DE              MOV    word ptr [bp - 0x22], ax     ; LOCAL_STORE
00A5EB  89 46 F4              MOV    word ptr [bp - 0xc], ax      ; LOCAL_STORE
00A5EE  8A 47 1F              MOV    al, byte ptr [bx + 0x1f]     ; MOV
00A5F1  98                    CWDE                                ; UNKNOWN
00A5F2  D1 E0                 SHL    ax, 1                        ; UNKNOWN
00A5F4  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
00A5F7  2B 06 C8 8D           SUB    ax, word ptr [0x8dc8]        ; UNKNOWN
00A5FB  F7 D8                 NEG    ax                           ; UNKNOWN
00A5FD  0B C0                 OR     ax, ax                       ; UNKNOWN
00A5FF  7D 02                 JGE    0xa603                       ; UNKNOWN
00A601  2B C0                 SUB    ax, ax                       ; UNKNOWN
00A603  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
00A606  40                    INC    ax                           ; UNKNOWN
00A607  D1 F8                 SAR    ax, 1                        ; UNKNOWN
00A609  3B 46 F4              CMP    ax, word ptr [bp - 0xc]      ; CMP
00A60C  7E 03                 JLE    0xa611                       ; UNKNOWN
00A60E  8B 46 F4              MOV    ax, word ptr [bp - 0xc]      ; LOCAL_LOAD
00A611  89 46 DE              MOV    word ptr [bp - 0x22], ax     ; LOCAL_STORE
00A614  0E                    PUSH   cs                           ; UNKNOWN
00A615  E8 E8 E6              CALL   0x8d00                       ; UNKNOWN
00A618  89 46 D6              MOV    word ptr [bp - 0x2a], ax     ; LOCAL_STORE
00A61B  8B 1E 42 85           MOV    bx, word ptr [0x8542]        ; UNKNOWN
00A61F  2B 87 AA 00           SUB    ax, word ptr [bx + 0xaa]     ; ARITH
00A623  79 02                 JNS    0xa627                       ; UNKNOWN
00A625  2B C0                 SUB    ax, ax                       ; UNKNOWN
00A627  3B 46 DE              CMP    ax, word ptr [bp - 0x22]     ; CMP
00A62A  7E 03                 JLE    0xa62f                       ; UNKNOWN
00A62C  8B 46 DE              MOV    ax, word ptr [bp - 0x22]     ; LOCAL_LOAD
00A62F  89 46 E0              MOV    word ptr [bp - 0x20], ax     ; LOCAL_STORE
00A632  8B 4E F4              MOV    cx, word ptr [bp - 0xc]      ; LOCAL_LOAD
00A635  01 0E D8 8D           ADD    word ptr [0x8dd8], cx        ; UNKNOWN
00A639  2B C8                 SUB    cx, ax                       ; UNKNOWN
00A63B  89 0E 6A 8E           MOV    word ptr [0x8e6a], cx        ; UNKNOWN
00A63F  01 46 FC              ADD    word ptr [bp - 4], ax        ; UNKNOWN
00A642  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
00A645  6A 00                 PUSH   0                            ; UNKNOWN
00A647  0E                    PUSH   cs                           ; UNKNOWN
00A648  E8 FB E7              CALL   0x8e46                       ; UNKNOWN
00A64B  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00A64E  FF 36 E8 8D           PUSH   word ptr [0x8de8]            ; UNKNOWN
00A652  6A 05                 PUSH   5                            ; UNKNOWN
00A654  0E                    PUSH   cs                           ; UNKNOWN
00A655  E8 EE E7              CALL   0x8e46                       ; UNKNOWN
00A658  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00A65B  6A 0E                 PUSH   0xe                          ; UNKNOWN
00A65D  6A 06                 PUSH   6                            ; UNKNOWN
00A65F  0E                    PUSH   cs                           ; UNKNOWN
00A660  E8 21 E8              CALL   0x8e84                       ; UNKNOWN
00A663  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00A666  6A 0A                 PUSH   0xa                          ; UNKNOWN
00A668  6A 02                 PUSH   2                            ; UNKNOWN
00A66A  0E                    PUSH   cs                           ; UNKNOWN
00A66B  E8 16 E8              CALL   0x8e84                       ; UNKNOWN
00A66E  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00A671  6A 0B                 PUSH   0xb                          ; UNKNOWN
00A673  6A 03                 PUSH   3                            ; UNKNOWN
00A675  0E                    PUSH   cs                           ; UNKNOWN
00A676  E8 0B E8              CALL   0x8e84                       ; UNKNOWN
00A679  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00A67C  6A 0C                 PUSH   0xc                          ; UNKNOWN
00A67E  6A 04                 PUSH   4                            ; UNKNOWN
00A680  0E                    PUSH   cs                           ; UNKNOWN
00A681  E8 00 E8              CALL   0x8e84                       ; UNKNOWN
00A684  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00A687  6A 09                 PUSH   9                            ; UNKNOWN
00A689  6A 01                 PUSH   1                            ; UNKNOWN
00A68B  0E                    PUSH   cs                           ; UNKNOWN
00A68C  E8 F5 E7              CALL   0x8e84                       ; UNKNOWN
00A68F  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00A692  FF 36 E6 8D           PUSH   word ptr [0x8de6]            ; UNKNOWN
00A696  6A 0E                 PUSH   0xe                          ; UNKNOWN
00A698  0E                    PUSH   cs                           ; UNKNOWN
00A699  E8 AA E7              CALL   0x8e46                       ; UNKNOWN
00A69C  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00A69F  5E                    POP    si                           ; UNKNOWN
00A6A0  C9                    LEAVE                               ; UNKNOWN
00A6A1  CB                    RETF                                ; UNKNOWN
