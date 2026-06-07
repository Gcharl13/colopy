; ============================================================================
; func_0503DE_unknown
; Region   : load_image
; Bytes    : file 0x0503DE..0x0504B1  (211 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0503DE  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
0503E2  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
0503E7  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
0503EA  80 BF AE 86 00        CMP    byte ptr [bx - 0x7952], 0    ; UNKNOWN
0503EF  74 34                 JE     0x50425                      ; UNKNOWN
0503F1  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
0503F4  53                    PUSH   bx                           ; UNKNOWN
0503F5  6B 5E 08 1C           IMUL   bx, word ptr [bp + 8], 0x1c  ; UNKNOWN
0503F9  8A 87 81 88           MOV    al, byte ptr [bx - 0x777f]   ; UNKNOWN
0503FD  2A E4                 SUB    ah, ah                       ; UNKNOWN
0503FF  50                    PUSH   ax                           ; UNKNOWN
050400  8A 87 80 88           MOV    al, byte ptr [bx - 0x7780]   ; UNKNOWN
050404  50                    PUSH   ax                           ; UNKNOWN
050405  9A 45 01 5F 24        LCALL  0x245f, 0x145                ; UNKNOWN
05040A  83 C4 08              ADD    sp, 8                        ; UNKNOWN
05040D  0B C0                 OR     ax, ax                       ; UNKNOWN
05040F  7C 0F                 JL     0x50420                      ; UNKNOWN
050411  A1 78 73              MOV    ax, word ptr [0x7378]        ; UNKNOWN
050414  B9 05 00              MOV    cx, 5                        ; UNKNOWN
050417  99                    CDQ                                 ; UNKNOWN
050418  F7 F9                 IDIV   cx                           ; UNKNOWN
05041A  48                    DEC    ax                           ; UNKNOWN
05041B  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
05041E  EB 05                 JMP    0x50425                      ; UNKNOWN
050420  C7 46 FE 02 00        MOV    word ptr [bp - 2], 2         ; UNKNOWN
050425  6B 5E 08 1C           IMUL   bx, word ptr [bp + 8], 0x1c  ; UNKNOWN
050429  80 BF 82 88 02        CMP    byte ptr [bx - 0x777e], 2    ; UNKNOWN
05042E  75 04                 JNE    0x50434                      ; UNKNOWN
050430  83 46 FE 02           ADD    word ptr [bp - 2], 2         ; UNKNOWN
050434  6B 5E 08 1C           IMUL   bx, word ptr [bp + 8], 0x1c  ; UNKNOWN
050438  80 BF 82 88 01        CMP    byte ptr [bx - 0x777e], 1    ; UNKNOWN
05043D  75 04                 JNE    0x50443                      ; UNKNOWN
05043F  83 6E FE 02           SUB    word ptr [bp - 2], 2         ; UNKNOWN
050443  6B 5E 08 1C           IMUL   bx, word ptr [bp + 8], 0x1c  ; UNKNOWN
050447  80 BF 82 88 04        CMP    byte ptr [bx - 0x777e], 4    ; UNKNOWN
05044C  75 04                 JNE    0x50452                      ; UNKNOWN
05044E  83 6E FE 03           SUB    word ptr [bp - 2], 3         ; UNKNOWN
050452  6B 5E 08 1C           IMUL   bx, word ptr [bp + 8], 0x1c  ; UNKNOWN
050456  80 BF 82 88 00        CMP    byte ptr [bx - 0x777e], 0    ; UNKNOWN
05045B  75 29                 JNE    0x50486                      ; UNKNOWN
05045D  83 6E FE 02           SUB    word ptr [bp - 2], 2         ; UNKNOWN
050461  8A 87 97 88           MOV    al, byte ptr [bx - 0x7769]   ; UNKNOWN
050465  98                    CWDE                                ; UNKNOWN
050466  50                    PUSH   ax                           ; UNKNOWN
050467  9A 08 00 5F 24        LCALL  0x245f, 8                    ; UNKNOWN
05046C  83 C4 02              ADD    sp, 2                        ; UNKNOWN
05046F  0B C0                 OR     ax, ax                       ; UNKNOWN
050471  74 04                 JE     0x50477                      ; UNKNOWN
050473  83 6E FE 02           SUB    word ptr [bp - 2], 2         ; UNKNOWN
050477  6B 5E 08 1C           IMUL   bx, word ptr [bp + 8], 0x1c  ; UNKNOWN
05047B  80 BF 97 88 1B        CMP    byte ptr [bx - 0x7769], 0x1b ; UNKNOWN
050480  75 04                 JNE    0x50486                      ; UNKNOWN
050482  83 6E FE 14           SUB    word ptr [bp - 2], 0x14      ; UNKNOWN
050486  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
050489  0E                    PUSH   cs                           ; UNKNOWN
05048A  E8 F8 FD              CALL   0x50285                      ; UNKNOWN
05048D  83 C4 02              ADD    sp, 2                        ; UNKNOWN
050490  0B C0                 OR     ax, ax                       ; UNKNOWN
050492  74 12                 JE     0x504a6                      ; UNKNOWN
050494  A1 06 3E              MOV    ax, word ptr [0x3e06]        ; UNKNOWN
050497  69 5E 06 3C 01        IMUL   bx, word ptr [bp + 6], 0x13c ; UNKNOWN
05049C  2B 87 F0 74           SUB    ax, word ptr [bx + 0x74f0]   ; UNKNOWN
0504A0  C1 F8 04              SAR    ax, 4                        ; UNKNOWN
0504A3  01 46 FE              ADD    word ptr [bp - 2], ax        ; UNKNOWN
0504A6  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
0504A9  0B C0                 OR     ax, ax                       ; UNKNOWN
0504AB  7E 02                 JLE    0x504af                      ; UNKNOWN
0504AD  2B C0                 SUB    ax, ax                       ; UNKNOWN
0504AF  C9                    LEAVE                               ; UNKNOWN
0504B0  CB                    RETF                                ; UNKNOWN
