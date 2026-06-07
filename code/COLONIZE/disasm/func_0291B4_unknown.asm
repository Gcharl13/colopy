; ============================================================================
; func_0291B4_unknown
; Region   : load_image
; Bytes    : file 0x0291B4..0x0292EC  (312 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0291B4  C8 10 00 00           ENTER  0x10, 0                      ; UNKNOWN
0291B8  56                    PUSH   si                           ; UNKNOWN
0291B9  C7 46 F2 FF FF        MOV    word ptr [bp - 0xe], 0xffff  ; UNKNOWN
0291BE  C4 1E 8A 40           LES    bx, ptr [0x408a]             ; UNKNOWN
0291C2  26 8A 47 21           MOV    al, byte ptr es:[bx + 0x21]  ; UNKNOWN
0291C6  2A E4                 SUB    ah, ah                       ; UNKNOWN
0291C8  3B 06 94 40           CMP    ax, word ptr [0x4094]        ; UNKNOWN
0291CC  7F 03                 JG     0x291d1                      ; UNKNOWN
0291CE  E9 14 01              JMP    0x292e5                      ; UNKNOWN
0291D1  83 7E 06 01           CMP    word ptr [bp + 6], 1         ; UNKNOWN
0291D5  F5                    CMC                                 ; UNKNOWN
0291D6  1B C0                 SBB    ax, ax                       ; UNKNOWN
0291D8  83 E0 06              AND    ax, 6                        ; UNKNOWN
0291DB  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
0291DE  83 7E 06 01           CMP    word ptr [bp + 6], 1         ; UNKNOWN
0291E2  1B C0                 SBB    ax, ax                       ; UNKNOWN
0291E4  24 AD                 AND    al, 0xad                     ; UNKNOWN
0291E6  05 D0 00              ADD    ax, 0xd0                     ; UNKNOWN
0291E9  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
0291EC  8B F0                 MOV    si, ax                       ; UNKNOWN
0291EE  0E                    PUSH   cs                           ; UNKNOWN
0291EF  E8 CE F5              CALL   0x287c0                      ; UNKNOWN
0291F2  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0291F5  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
0291F8  89 76 F4              MOV    word ptr [bp - 0xc], si      ; UNKNOWN
0291FB  C7 46 FA 00 00        MOV    word ptr [bp - 6], 0         ; UNKNOWN
029200  EB 3F                 JMP    0x29241                      ; UNKNOWN
029202  83 7E F2 00           CMP    word ptr [bp - 0xe], 0       ; UNKNOWN
029206  7D 41                 JGE    0x29249                      ; UNKNOWN
029208  03 46 F8              ADD    ax, word ptr [bp - 8]        ; UNKNOWN
02920B  50                    PUSH   ax                           ; UNKNOWN
02920C  0E                    PUSH   cs                           ; UNKNOWN
02920D  E8 07 F6              CALL   0x28817                      ; UNKNOWN
029210  83 C4 02              ADD    sp, 2                        ; UNKNOWN
029213  89 46 F0              MOV    word ptr [bp - 0x10], ax     ; UNKNOWN
029216  A1 E2 0E              MOV    ax, word ptr [0xee2]         ; UNKNOWN
029219  8B 76 F0              MOV    si, word ptr [bp - 0x10]     ; UNKNOWN
02921C  8B CE                 MOV    cx, si                       ; UNKNOWN
02921E  D1 E6                 SHL    si, 1                        ; UNKNOWN
029220  03 F1                 ADD    si, cx                       ; UNKNOWN
029222  C1 E6 02              SHL    si, 2                        ; UNKNOWN
029225  C4 1E 70 09           LES    bx, ptr [0x970]              ; UNKNOWN
029229  26 8B 88 52 01        MOV    cx, word ptr es:[bx + si + 0x152] ; UNKNOWN
02922E  41                    INC    cx                           ; UNKNOWN
02922F  41                    INC    cx                           ; UNKNOWN
029230  01 4E F4              ADD    word ptr [bp - 0xc], cx      ; UNKNOWN
029233  39 46 F4              CMP    word ptr [bp - 0xc], ax      ; UNKNOWN
029236  7E 06                 JLE    0x2923e                      ; UNKNOWN
029238  8B 46 FA              MOV    ax, word ptr [bp - 6]        ; UNKNOWN
02923B  89 46 F2              MOV    word ptr [bp - 0xe], ax      ; UNKNOWN
02923E  FF 46 FA              INC    word ptr [bp - 6]            ; UNKNOWN
029241  8B 46 FA              MOV    ax, word ptr [bp - 6]        ; UNKNOWN
029244  39 46 FE              CMP    word ptr [bp - 2], ax        ; UNKNOWN
029247  7F B9                 JG     0x29202                      ; UNKNOWN
029249  83 7E F2 00           CMP    word ptr [bp - 0xe], 0       ; UNKNOWN
02924D  7D 09                 JGE    0x29258                      ; UNKNOWN
02924F  83 7E FE 06           CMP    word ptr [bp - 2], 6         ; UNKNOWN
029253  7C 03                 JL     0x29258                      ; UNKNOWN
029255  E9 8D 00              JMP    0x292e5                      ; UNKNOWN
029258  83 7E F2 00           CMP    word ptr [bp - 0xe], 0       ; UNKNOWN
02925C  7C 36                 JL     0x29294                      ; UNKNOWN
02925E  8B 46 F2              MOV    ax, word ptr [bp - 0xe]      ; UNKNOWN
029261  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; UNKNOWN
029264  EB 1F                 JMP    0x29285                      ; UNKNOWN
029266  8B 46 F6              MOV    ax, word ptr [bp - 0xa]      ; UNKNOWN
029269  03 46 F8              ADD    ax, word ptr [bp - 8]        ; UNKNOWN
02926C  8B C8                 MOV    cx, ax                       ; UNKNOWN
02926E  40                    INC    ax                           ; UNKNOWN
02926F  50                    PUSH   ax                           ; UNKNOWN
029270  8B F1                 MOV    si, cx                       ; UNKNOWN
029272  0E                    PUSH   cs                           ; UNKNOWN
029273  E8 A1 F5              CALL   0x28817                      ; UNKNOWN
029276  83 C4 02              ADD    sp, 2                        ; UNKNOWN
029279  50                    PUSH   ax                           ; UNKNOWN
02927A  56                    PUSH   si                           ; UNKNOWN
02927B  0E                    PUSH   cs                           ; UNKNOWN
02927C  E8 C7 F5              CALL   0x28846                      ; UNKNOWN
02927F  83 C4 04              ADD    sp, 4                        ; UNKNOWN
029282  FF 46 F6              INC    word ptr [bp - 0xa]          ; UNKNOWN
029285  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
029288  48                    DEC    ax                           ; UNKNOWN
029289  3B 46 F6              CMP    ax, word ptr [bp - 0xa]      ; UNKNOWN
02928C  7F D8                 JG     0x29266                      ; UNKNOWN
02928E  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
029291  48                    DEC    ax                           ; UNKNOWN
029292  EB 46                 JMP    0x292da                      ; UNKNOWN
029294  FF 36 94 40           PUSH   word ptr [0x4094]            ; UNKNOWN
029298  0E                    PUSH   cs                           ; UNKNOWN
029299  E8 48 F0              CALL   0x282e4                      ; UNKNOWN
02929C  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02929F  52                    PUSH   dx                           ; UNKNOWN
0292A0  50                    PUSH   ax                           ; UNKNOWN
0292A1  6A 00                 PUSH   0                            ; UNKNOWN
0292A3  9A C9 03 97 1B        LCALL  0x1b97, 0x3c9                ; UNKNOWN
0292A8  83 C4 06              ADD    sp, 6                        ; UNKNOWN
0292AB  83 7E 06 00           CMP    word ptr [bp + 6], 0         ; UNKNOWN
0292AF  74 05                 JE     0x292b6                      ; UNKNOWN
0292B1  68 A5 19              PUSH   0x19a5                       ; UNKNOWN
0292B4  EB 03                 JMP    0x292b9                      ; UNKNOWN
0292B6  68 AF 19              PUSH   0x19af                       ; UNKNOWN
0292B9  0E                    PUSH   cs                           ; UNKNOWN
0292BA  E8 4C FE              CALL   0x29109                      ; UNKNOWN
0292BD  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0292C0  89 46 F0              MOV    word ptr [bp - 0x10], ax     ; UNKNOWN
0292C3  0B C0                 OR     ax, ax                       ; UNKNOWN
0292C5  7C 1E                 JL     0x292e5                      ; UNKNOWN
0292C7  50                    PUSH   ax                           ; UNKNOWN
0292C8  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
0292CB  03 46 F8              ADD    ax, word ptr [bp - 8]        ; UNKNOWN
0292CE  50                    PUSH   ax                           ; UNKNOWN
0292CF  0E                    PUSH   cs                           ; UNKNOWN
0292D0  E8 73 F5              CALL   0x28846                      ; UNKNOWN
0292D3  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0292D6  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
0292D9  40                    INC    ax                           ; UNKNOWN
0292DA  50                    PUSH   ax                           ; UNKNOWN
0292DB  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
0292DE  0E                    PUSH   cs                           ; UNKNOWN
0292DF  E8 03 F5              CALL   0x287e5                      ; UNKNOWN
0292E2  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0292E5  0E                    PUSH   cs                           ; UNKNOWN
0292E6  E8 81 F9              CALL   0x28c6a                      ; UNKNOWN
0292E9  5E                    POP    si                           ; UNKNOWN
0292EA  C9                    LEAVE                               ; UNKNOWN
0292EB  CB                    RETF                                ; UNKNOWN
