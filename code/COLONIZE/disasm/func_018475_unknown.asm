; ============================================================================
; func_018475_unknown
; Region   : load_image
; Bytes    : file 0x018475..0x018528  (179 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

018475  C8 0A 00 00           ENTER  0xa, 0                       ; UNKNOWN
018479  56                    PUSH   si                           ; UNKNOWN
01847A  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
01847E  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
018482  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
018486  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
01848A  68 80 00              PUSH   0x80                         ; UNKNOWN
01848D  6A 00                 PUSH   0                            ; UNKNOWN
01848F  B8 FF FF              MOV    ax, 0xffff                   ; UNKNOWN
018492  BA 07 00              MOV    dx, 7                        ; UNKNOWN
018495  BB C7 00              MOV    bx, 0xc7                     ; UNKNOWN
018498  9A 00 00 84 5A        LCALL  0x5a84, 0                    ; UNKNOWN
01849D  6A 07                 PUSH   7                            ; UNKNOWN
01849F  6A 78                 PUSH   0x78                         ; UNKNOWN
0184A1  68 C7 00              PUSH   0xc7                         ; UNKNOWN
0184A4  6A 08                 PUSH   8                            ; UNKNOWN
0184A6  6A 00                 PUSH   0                            ; UNKNOWN
0184A8  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
0184AC  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
0184B0  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
0184B4  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
0184B8  9A 0C 00 30 22        LCALL  0x2230, 0xc                  ; UNKNOWN
0184BD  83 C4 12              ADD    sp, 0x12                     ; UNKNOWN
0184C0  C7 46 F8 00 00        MOV    word ptr [bp - 8], 0         ; UNKNOWN
0184C5  EB 0D                 JMP    0x184d4                      ; UNKNOWN
0184C7  52                    PUSH   dx                           ; UNKNOWN
0184C8  51                    PUSH   cx                           ; UNKNOWN
0184C9  56                    PUSH   si                           ; UNKNOWN
0184CA  0E                    PUSH   cs                           ; UNKNOWN
0184CB  E8 7E FF              CALL   0x1844c                      ; UNKNOWN
0184CE  83 C4 06              ADD    sp, 6                        ; UNKNOWN
0184D1  FF 46 F8              INC    word ptr [bp - 8]            ; UNKNOWN
0184D4  83 7E F8 0F           CMP    word ptr [bp - 8], 0xf       ; UNKNOWN
0184D8  7D 32                 JGE    0x1850c                      ; UNKNOWN
0184DA  8B 5E F8              MOV    bx, word ptr [bp - 8]        ; UNKNOWN
0184DD  C1 E3 02              SHL    bx, 2                        ; UNKNOWN
0184E0  8B 87 BF 08           MOV    ax, word ptr [bx + 0x8bf]    ; UNKNOWN
0184E4  8B 8F C1 08           MOV    cx, word ptr [bx + 0x8c1]    ; UNKNOWN
0184E8  83 C1 08              ADD    cx, 8                        ; UNKNOWN
0184EB  8B 5E F8              MOV    bx, word ptr [bp - 8]        ; UNKNOWN
0184EE  8A 97 D4 32           MOV    dl, byte ptr [bx + 0x32d4]   ; UNKNOWN
0184F2  2A F6                 SUB    dh, dh                       ; UNKNOWN
0184F4  8B F0                 MOV    si, ax                       ; UNKNOWN
0184F6  8A 87 41 74           MOV    al, byte ptr [bx + 0x7441]   ; UNKNOWN
0184FA  98                    CWDE                                ; UNKNOWN
0184FB  0B C0                 OR     ax, ax                       ; UNKNOWN
0184FD  7C C8                 JL     0x184c7                      ; UNKNOWN
0184FF  52                    PUSH   dx                           ; UNKNOWN
018500  51                    PUSH   cx                           ; UNKNOWN
018501  56                    PUSH   si                           ; UNKNOWN
018502  50                    PUSH   ax                           ; UNKNOWN
018503  0E                    PUSH   cs                           ; UNKNOWN
018504  E8 29 FD              CALL   0x18230                      ; UNKNOWN
018507  83 C4 08              ADD    sp, 8                        ; UNKNOWN
01850A  EB C5                 JMP    0x184d1                      ; UNKNOWN
01850C  83 7E 06 00           CMP    word ptr [bp + 6], 0         ; UNKNOWN
018510  74 13                 JE     0x18525                      ; UNKNOWN
018512  6A 08                 PUSH   8                            ; UNKNOWN
018514  68 C7 00              PUSH   0xc7                         ; UNKNOWN
018517  6A 78                 PUSH   0x78                         ; UNKNOWN
018519  2B C0                 SUB    ax, ax                       ; UNKNOWN
01851B  BA 08 00              MOV    dx, 8                        ; UNKNOWN
01851E  2B DB                 SUB    bx, bx                       ; UNKNOWN
018520  9A 3B 00 B4 5C        LCALL  0x5cb4, 0x3b                 ; UNKNOWN
018525  5E                    POP    si                           ; UNKNOWN
018526  C9                    LEAVE                               ; UNKNOWN
018527  CB                    RETF                                ; UNKNOWN
