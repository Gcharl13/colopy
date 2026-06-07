; ============================================================================
; func_018528_unknown
; Region   : load_image
; Bytes    : file 0x018528..0x018619  (241 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

018528  C8 7E 00 00           ENTER  0x7e, 0                      ; UNKNOWN
01852C  57                    PUSH   di                           ; UNKNOWN
01852D  56                    PUSH   si                           ; UNKNOWN
01852E  6A 30                 PUSH   0x30                         ; UNKNOWN
018530  6A 78                 PUSH   0x78                         ; UNKNOWN
018532  68 82 00              PUSH   0x82                         ; UNKNOWN
018535  6A 00                 PUSH   0                            ; UNKNOWN
018537  0E                    PUSH   cs                           ; UNKNOWN
018538  E8 6A F2              CALL   0x177a5                      ; UNKNOWN
01853B  83 C4 08              ADD    sp, 8                        ; UNKNOWN
01853E  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
018542  8A 47 1F              MOV    al, byte ptr [bx + 0x1f]     ; UNKNOWN
018545  98                    CWDE                                ; UNKNOWN
018546  03 06 3A 73           ADD    ax, word ptr [0x733a]        ; UNKNOWN
01854A  89 46 98              MOV    word ptr [bp - 0x68], ax     ; UNKNOWN
01854D  C7 46 A4 01 00        MOV    word ptr [bp - 0x5c], 1      ; UNKNOWN
018552  C7 46 A0 8F 00        MOV    word ptr [bp - 0x60], 0x8f   ; UNKNOWN
018557  2B C0                 SUB    ax, ax                       ; UNKNOWN
018559  89 46 82              MOV    word ptr [bp - 0x7e], ax     ; UNKNOWN
01855C  89 46 92              MOV    word ptr [bp - 0x6e], ax     ; UNKNOWN
01855F  EB 31                 JMP    0x18592                      ; UNKNOWN
018561  50                    PUSH   ax                           ; UNKNOWN
018562  9A F7 0D 5F 24        LCALL  0x245f, 0xdf7                ; UNKNOWN
018567  83 C4 02              ADD    sp, 2                        ; UNKNOWN
01856A  89 46 8E              MOV    word ptr [bp - 0x72], ax     ; UNKNOWN
01856D  FF 76 92              PUSH   word ptr [bp - 0x6e]         ; UNKNOWN
018570  9A F5 0E 5F 24        LCALL  0x245f, 0xef5                ; UNKNOWN
018575  83 C4 02              ADD    sp, 2                        ; UNKNOWN
018578  89 46 9A              MOV    word ptr [bp - 0x66], ax     ; UNKNOWN
01857B  8B F0                 MOV    si, ax                       ; UNKNOWN
01857D  D1 E6                 SHL    si, 1                        ; UNKNOWN
01857F  03 F0                 ADD    si, ax                       ; UNKNOWN
018581  C1 E6 02              SHL    si, 2                        ; UNKNOWN
018584  C4 1E 70 09           LES    bx, ptr [0x970]              ; UNKNOWN
018588  26 8B 40 3E           MOV    ax, word ptr es:[bx + si + 0x3e] ; UNKNOWN
01858C  01 46 82              ADD    word ptr [bp - 0x7e], ax     ; UNKNOWN
01858F  FF 46 92              INC    word ptr [bp - 0x6e]         ; UNKNOWN
018592  8B 46 92              MOV    ax, word ptr [bp - 0x6e]     ; UNKNOWN
018595  39 46 98              CMP    word ptr [bp - 0x68], ax     ; UNKNOWN
018598  7F C7                 JG     0x18561                      ; UNKNOWN
01859A  C6 06 EF 32 02        MOV    byte ptr [0x32ef], 2         ; UNKNOWN
01859F  C7 46 A6 04 00        MOV    word ptr [bp - 0x5a], 4      ; UNKNOWN
0185A4  83 3E 3A 73 00        CMP    word ptr [0x733a], 0         ; UNKNOWN
0185A9  75 0B                 JNE    0x185b6                      ; UNKNOWN
0185AB  C7 46 A6 00 00        MOV    word ptr [bp - 0x5a], 0      ; UNKNOWN
0185B0  EB 04                 JMP    0x185b6                      ; UNKNOWN
0185B2  FE 0E EF 32           DEC    byte ptr [0x32ef]            ; UNKNOWN
0185B6  A0 EF 32              MOV    al, byte ptr [0x32ef]        ; UNKNOWN
0185B9  98                    CWDE                                ; UNKNOWN
0185BA  8B 4E 98              MOV    cx, word ptr [bp - 0x68]     ; UNKNOWN
0185BD  49                    DEC    cx                           ; UNKNOWN
0185BE  F7 E9                 IMUL   cx                           ; UNKNOWN
0185C0  03 46 A6              ADD    ax, word ptr [bp - 0x5a]     ; UNKNOWN
0185C3  03 46 82              ADD    ax, word ptr [bp - 0x7e]     ; UNKNOWN
0185C6  83 F8 60              CMP    ax, 0x60                     ; UNKNOWN
0185C9  7D E7                 JGE    0x185b2                      ; UNKNOWN
0185CB  FF 46 A4              INC    word ptr [bp - 0x5c]         ; UNKNOWN
0185CE  FF 4E A0              DEC    word ptr [bp - 0x60]         ; UNKNOWN
0185D1  2B C0                 SUB    ax, ax                       ; UNKNOWN
0185D3  89 46 AC              MOV    word ptr [bp - 0x54], ax     ; UNKNOWN
0185D6  89 46 92              MOV    word ptr [bp - 0x6e], ax     ; UNKNOWN
0185D9  E9 2D 01              JMP    0x18709                      ; UNKNOWN
0185DC  C7 46 9C 0A 00        MOV    word ptr [bp - 0x64], 0xa    ; UNKNOWN
0185E1  83 3E FB 08 01        CMP    word ptr [0x8fb], 1          ; UNKNOWN
0185E6  75 0E                 JNE    0x185f6                      ; UNKNOWN
0185E8  83 3E 01 09 00        CMP    word ptr [0x901], 0          ; UNKNOWN
0185ED  75 07                 JNE    0x185f6                      ; UNKNOWN
0185EF  83 3E F0 0E 00        CMP    word ptr [0xef0], 0          ; UNKNOWN
0185F4  74 51                 JE     0x18647                      ; UNKNOWN
0185F6  83 3E E8 0E 00        CMP    word ptr [0xee8], 0          ; UNKNOWN
0185FB  74 07                 JE     0x18604                      ; UNKNOWN
0185FD  83 3E C6 32 00        CMP    word ptr [0x32c6], 0         ; UNKNOWN
018602  74 43                 JE     0x18647                      ; UNKNOWN
018604  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
018608  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
01860C  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
018610  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
018614  8B 5E 9A              MOV    bx, word ptr [bp - 0x66]     ; UNKNOWN
018617  8B C3                 MOV    ax, bx                       ; UNKNOWN
