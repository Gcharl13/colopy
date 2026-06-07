; ============================================================================
; func_04211B_unknown
; Region   : load_image
; Bytes    : file 0x04211B..0x04236D  (594 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04211B  C8 B8 01 00           ENTER  0x1b8, 0                     ; UNKNOWN
04211F  2B 06 74 C1           SUB    ax, word ptr [0xc174]        ; UNKNOWN
042123  F7 6E 06              IMUL   word ptr [bp + 6]            ; UNKNOWN
042126  2B C1                 SUB    ax, cx                       ; UNKNOWN
042128  03 46 DA              ADD    ax, word ptr [bp - 0x26]     ; UNKNOWN
04212B  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
04212E  3B 46 E0              CMP    ax, word ptr [bp - 0x20]     ; UNKNOWN
042131  7D 1A                 JGE    0x4214d                      ; UNKNOWN
042133  83 7E 06 00           CMP    word ptr [bp + 6], 0         ; UNKNOWN
042137  7E 05                 JLE    0x4213e                      ; UNKNOWN
042139  FF 4E 06              DEC    word ptr [bp + 6]            ; UNKNOWN
04213C  EB 0F                 JMP    0x4214d                      ; UNKNOWN
04213E  0B C9                 OR     cx, cx                       ; UNKNOWN
042140  7E 05                 JLE    0x42147                      ; UNKNOWN
042142  FF 46 F2              INC    word ptr [bp - 0xe]          ; UNKNOWN
042145  EB 06                 JMP    0x4214d                      ; UNKNOWN
042147  8B 46 E0              MOV    ax, word ptr [bp - 0x20]     ; UNKNOWN
04214A  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
04214D  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
042150  39 46 E0              CMP    word ptr [bp - 0x20], ax     ; UNKNOWN
042153  7F B4                 JG     0x42109                      ; UNKNOWN
042155  83 7E F6 00           CMP    word ptr [bp - 0xa], 0       ; UNKNOWN
042159  74 1B                 JE     0x42176                      ; UNKNOWN
04215B  99                    CDQ                                 ; UNKNOWN
04215C  F7 7E F6              IDIV   word ptr [bp - 0xa]          ; UNKNOWN
04215F  89 46 DE              MOV    word ptr [bp - 0x22], ax     ; UNKNOWN
042162  0B C0                 OR     ax, ax                       ; UNKNOWN
042164  75 10                 JNE    0x42176                      ; UNKNOWN
042166  FF 46 E4              INC    word ptr [bp - 0x1c]         ; UNKNOWN
042169  8A 4E E4              MOV    cl, byte ptr [bp - 0x1c]     ; UNKNOWN
04216C  8B 46 F6              MOV    ax, word ptr [bp - 0xa]      ; UNKNOWN
04216F  D3 F8                 SAR    ax, cl                       ; UNKNOWN
042171  3B 46 FC              CMP    ax, word ptr [bp - 4]        ; UNKNOWN
042174  7F F0                 JG     0x42166                      ; UNKNOWN
042176  C7 46 EA 00 00        MOV    word ptr [bp - 0x16], 0      ; UNKNOWN
04217B  E9 AC 01              JMP    0x4232a                      ; UNKNOWN
04217E  C7 46 E2 01 00        MOV    word ptr [bp - 0x1e], 1      ; UNKNOWN
042183  8A 4E E4              MOV    cl, byte ptr [bp - 0x1c]     ; UNKNOWN
042186  8B 5E EA              MOV    bx, word ptr [bp - 0x16]     ; UNKNOWN
042189  D1 E3                 SHL    bx, 1                        ; UNKNOWN
04218B  8B 87 62 C1           MOV    ax, word ptr [bx - 0x3e9e]   ; UNKNOWN
04218F  2B 87 76 C1           SUB    ax, word ptr [bx - 0x3e8a]   ; UNKNOWN
042193  89 46 E6              MOV    word ptr [bp - 0x1a], ax     ; UNKNOWN
042196  D3 F8                 SAR    ax, cl                       ; UNKNOWN
042198  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
04219B  8B 46 D6              MOV    ax, word ptr [bp - 0x2a]     ; UNKNOWN
04219E  89 46 EE              MOV    word ptr [bp - 0x12], ax     ; UNKNOWN
0421A1  C7 46 E8 FF FF        MOV    word ptr [bp - 0x18], 0xffff ; UNKNOWN
0421A6  C7 46 EC 00 00        MOV    word ptr [bp - 0x14], 0      ; UNKNOWN
0421AB  EB 74                 JMP    0x42221                      ; UNKNOWN
0421AD  FF 36 72 09           PUSH   word ptr [0x972]             ; UNKNOWN
0421B1  FF 36 70 09           PUSH   word ptr [0x970]             ; UNKNOWN
0421B5  FF 76 D8              PUSH   word ptr [bp - 0x28]         ; UNKNOWN
0421B8  8B 5E EA              MOV    bx, word ptr [bp - 0x16]     ; UNKNOWN
0421BB  D1 E3                 SHL    bx, 1                        ; UNKNOWN
0421BD  8B 87 88 C1           MOV    ax, word ptr [bx - 0x3e78]   ; UNKNOWN
0421C1  80 E4 0F              AND    ah, 0xf                      ; UNKNOWN
0421C4  8B F3                 MOV    si, bx                       ; UNKNOWN
0421C6  8D 1E 82 CE           LEA    bx, [0xce82]                 ; UNKNOWN
0421CA  8B 56 D6              MOV    dx, word ptr [bp - 0x2a]     ; UNKNOWN
0421CD  9A 0E 00 15 5D        LCALL  0x5d15, 0xe                  ; UNKNOWN
0421D2  8B 84 88 C1           MOV    ax, word ptr [si - 0x3e78]   ; UNKNOWN
0421D6  8B C8                 MOV    cx, ax                       ; UNKNOWN
0421D8  F6 C4 80              TEST   ah, 0x80                     ; UNKNOWN
0421DB  75 0D                 JNE    0x421ea                      ; UNKNOWN
0421DD  8B 46 F8              MOV    ax, word ptr [bp - 8]        ; UNKNOWN
0421E0  39 46 EC              CMP    word ptr [bp - 0x14], ax     ; UNKNOWN
0421E3  7C 1F                 JL     0x42204                      ; UNKNOWN
0421E5  F6 C5 40              TEST   ch, 0x40                     ; UNKNOWN
0421E8  75 1A                 JNE    0x42204                      ; UNKNOWN
0421EA  FF 36 72 09           PUSH   word ptr [0x972]             ; UNKNOWN
0421EE  FF 36 70 09           PUSH   word ptr [0x970]             ; UNKNOWN
0421F2  FF 76 D8              PUSH   word ptr [bp - 0x28]         ; UNKNOWN
0421F5  B8 38 00              MOV    ax, 0x38                     ; UNKNOWN
0421F8  8D 1E 82 CE           LEA    bx, [0xce82]                 ; UNKNOWN
0421FC  8B 56 D6              MOV    dx, word ptr [bp - 0x2a]     ; UNKNOWN
0421FF  9A 0E 00 15 5D        LCALL  0x5d15, 0xe                  ; UNKNOWN
042204  8A 4E E4              MOV    cl, byte ptr [bp - 0x1c]     ; UNKNOWN
042207  8B 5E EA              MOV    bx, word ptr [bp - 0x16]     ; UNKNOWN
04220A  D1 E3                 SHL    bx, 1                        ; UNKNOWN
04220C  8B 87 62 C1           MOV    ax, word ptr [bx - 0x3e9e]   ; UNKNOWN
042210  D3 F8                 SAR    ax, cl                       ; UNKNOWN
042212  48                    DEC    ax                           ; UNKNOWN
042213  3B 46 EC              CMP    ax, word ptr [bp - 0x14]     ; UNKNOWN
042216  7E 06                 JLE    0x4221e                      ; UNKNOWN
042218  8B 46 E2              MOV    ax, word ptr [bp - 0x1e]     ; UNKNOWN
04221B  01 46 D6              ADD    word ptr [bp - 0x2a], ax     ; UNKNOWN
04221E  FF 46 EC              INC    word ptr [bp - 0x14]         ; UNKNOWN
042221  8A 4E E4              MOV    cl, byte ptr [bp - 0x1c]     ; UNKNOWN
042224  8B 5E EA              MOV    bx, word ptr [bp - 0x16]     ; UNKNOWN
042227  D1 E3                 SHL    bx, 1                        ; UNKNOWN
042229  8B 87 62 C1           MOV    ax, word ptr [bx - 0x3e9e]   ; UNKNOWN
04222D  D3 F8                 SAR    ax, cl                       ; UNKNOWN
04222F  3B 46 EC              CMP    ax, word ptr [bp - 0x14]     ; UNKNOWN
042232  7E 38                 JLE    0x4226c                      ; UNKNOWN
042234  8B 46 F8              MOV    ax, word ptr [bp - 8]        ; UNKNOWN
042237  39 46 EC              CMP    word ptr [bp - 0x14], ax     ; UNKNOWN
04223A  75 06                 JNE    0x42242                      ; UNKNOWN
04223C  8B 46 D6              MOV    ax, word ptr [bp - 0x2a]     ; UNKNOWN
04223F  89 46 E8              MOV    word ptr [bp - 0x18], ax     ; UNKNOWN
042242  8B 5E EA              MOV    bx, word ptr [bp - 0x16]     ; UNKNOWN
042245  D1 E3                 SHL    bx, 1                        ; UNKNOWN
042247  F6 87 89 C1 40        TEST   byte ptr [bx - 0x3e77], 0x40 ; UNKNOWN
04224C  75 03                 JNE    0x42251                      ; UNKNOWN
04224E  E9 5C FF              JMP    0x421ad                      ; UNKNOWN
042251  8B 46 F8              MOV    ax, word ptr [bp - 8]        ; UNKNOWN
042254  39 46 EC              CMP    word ptr [bp - 0x14], ax     ; UNKNOWN
042257  7C 03                 JL     0x4225c                      ; UNKNOWN
042259  E9 51 FF              JMP    0x421ad                      ; UNKNOWN
04225C  FF 36 72 09           PUSH   word ptr [0x972]             ; UNKNOWN
042260  FF 36 70 09           PUSH   word ptr [0x970]             ; UNKNOWN
042264  FF 76 D8              PUSH   word ptr [bp - 0x28]         ; UNKNOWN
042267  B8 3A 00              MOV    ax, 0x3a                     ; UNKNOWN
04226A  EB 8C                 JMP    0x421f8                      ; UNKNOWN
04226C  A1 96 0B              MOV    ax, word ptr [0xb96]         ; UNKNOWN
04226F  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
042272  83 7E E2 01           CMP    word ptr [bp - 0x1e], 1      ; UNKNOWN
042276  75 11                 JNE    0x42289                      ; UNKNOWN
042278  8B 5E EA              MOV    bx, word ptr [bp - 0x16]     ; UNKNOWN
04227B  D1 E3                 SHL    bx, 1                        ; UNKNOWN
04227D  83 BF 62 C1 01        CMP    word ptr [bx - 0x3e9e], 1    ; UNKNOWN
042282  7E 05                 JLE    0x42289                      ; UNKNOWN
042284  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1         ; UNKNOWN
042289  83 7E FE 00           CMP    word ptr [bp - 2], 0         ; UNKNOWN
04228D  74 71                 JE     0x42300                      ; UNKNOWN
04228F  8B 5E EA              MOV    bx, word ptr [bp - 0x16]     ; UNKNOWN
042292  D1 E3                 SHL    bx, 1                        ; UNKNOWN
042294  8B 87 76 C1           MOV    ax, word ptr [bx - 0x3e8a]   ; UNKNOWN
042298  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
04229B  F6 87 89 C1 40        TEST   byte ptr [bx - 0x3e77], 0x40 ; UNKNOWN
0422A0  74 08                 JE     0x422aa                      ; UNKNOWN
0422A2  01 46 E6              ADD    word ptr [bp - 0x1a], ax     ; UNKNOWN
0422A5  C7 46 FA 00 00        MOV    word ptr [bp - 6], 0         ; UNKNOWN
0422AA  6A 01                 PUSH   1                            ; UNKNOWN
0422AC  8B 5E EA              MOV    bx, word ptr [bp - 0x16]     ; UNKNOWN
0422AF  D1 E3                 SHL    bx, 1                        ; UNKNOWN
0422B1  8A A7 89 C1           MOV    ah, byte ptr [bx - 0x3e77]   ; UNKNOWN
0422B5  25 00 80              AND    ax, 0x8000                   ; UNKNOWN
0422B8  83 F8 01              CMP    ax, 1                        ; UNKNOWN
0422BB  1B C0                 SBB    ax, ax                       ; UNKNOWN
0422BD  83 E0 03              AND    ax, 3                        ; UNKNOWN
0422C0  83 C0 0C              ADD    ax, 0xc                      ; UNKNOWN
0422C3  50                    PUSH   ax                           ; UNKNOWN
0422C4  FF 76 D8              PUSH   word ptr [bp - 0x28]         ; UNKNOWN
0422C7  8B 46 EE              MOV    ax, word ptr [bp - 0x12]     ; UNKNOWN
0422CA  40                    INC    ax                           ; UNKNOWN
0422CB  40                    INC    ax                           ; UNKNOWN
0422CC  50                    PUSH   ax                           ; UNKNOWN
0422CD  FF 76 E6              PUSH   word ptr [bp - 0x1a]         ; UNKNOWN
0422D0  8B F3                 MOV    si, bx                       ; UNKNOWN
0422D2  0E                    PUSH   cs                           ; UNKNOWN
0422D3  E8 05 FB              CALL   0x41ddb                      ; UNKNOWN
0422D6  83 C4 0A              ADD    sp, 0xa                      ; UNKNOWN
0422D9  6A 01                 PUSH   1                            ; UNKNOWN
0422DB  8A A4 89 C1           MOV    ah, byte ptr [si - 0x3e77]   ; UNKNOWN
0422DF  25 00 40              AND    ax, 0x4000                   ; UNKNOWN
0422E2  83 F8 01              CMP    ax, 1                        ; UNKNOWN
0422E5  1B C0                 SBB    ax, ax                       ; UNKNOWN
0422E7  24 FD                 AND    al, 0xfd                     ; UNKNOWN
0422E9  83 C0 0F              ADD    ax, 0xf                      ; UNKNOWN
0422EC  50                    PUSH   ax                           ; UNKNOWN
0422ED  FF 76 D8              PUSH   word ptr [bp - 0x28]         ; UNKNOWN
0422F0  8B 46 E8              MOV    ax, word ptr [bp - 0x18]     ; UNKNOWN
0422F3  40                    INC    ax                           ; UNKNOWN
0422F4  40                    INC    ax                           ; UNKNOWN
0422F5  50                    PUSH   ax                           ; UNKNOWN
0422F6  FF 76 FA              PUSH   word ptr [bp - 6]            ; UNKNOWN
0422F9  0E                    PUSH   cs                           ; UNKNOWN
0422FA  E8 DE FA              CALL   0x41ddb                      ; UNKNOWN
0422FD  83 C4 0A              ADD    sp, 0xa                      ; UNKNOWN
042300  8B 5E EA              MOV    bx, word ptr [bp - 0x16]     ; UNKNOWN
042303  D1 E3                 SHL    bx, 1                        ; UNKNOWN
042305  8B B7 88 C1           MOV    si, word ptr [bx - 0x3e78]   ; UNKNOWN
042309  81 E6 FF 0F           AND    si, 0xfff                    ; UNKNOWN
04230D  8B C6                 MOV    ax, si                       ; UNKNOWN
04230F  D1 E6                 SHL    si, 1                        ; UNKNOWN
042311  03 F0                 ADD    si, ax                       ; UNKNOWN
042313  C1 E6 02              SHL    si, 2                        ; UNKNOWN
042316  C4 1E 70 09           LES    bx, ptr [0x970]              ; UNKNOWN
04231A  26 8B 40 3E           MOV    ax, word ptr es:[bx + si + 0x3e] ; UNKNOWN
04231E  2B 46 F2              SUB    ax, word ptr [bp - 0xe]      ; UNKNOWN
042321  03 46 06              ADD    ax, word ptr [bp + 6]        ; UNKNOWN
042324  01 46 D6              ADD    word ptr [bp - 0x2a], ax     ; UNKNOWN
042327  FF 46 EA              INC    word ptr [bp - 0x16]         ; UNKNOWN
04232A  8B 46 EA              MOV    ax, word ptr [bp - 0x16]     ; UNKNOWN
04232D  39 06 74 C1           CMP    word ptr [0xc174], ax        ; UNKNOWN
042331  7E 35                 JLE    0x42368                      ; UNKNOWN
042333  83 7E DE 00           CMP    word ptr [bp - 0x22], 0      ; UNKNOWN
042337  75 03                 JNE    0x4233c                      ; UNKNOWN
042339  E9 42 FE              JMP    0x4217e                      ; UNKNOWN
04233C  8B D8                 MOV    bx, ax                       ; UNKNOWN
04233E  D1 E3                 SHL    bx, 1                        ; UNKNOWN
042340  8B B7 88 C1           MOV    si, word ptr [bx - 0x3e78]   ; UNKNOWN
042344  81 E6 FF 0F           AND    si, 0xfff                    ; UNKNOWN
042348  8B C6                 MOV    ax, si                       ; UNKNOWN
04234A  D1 E6                 SHL    si, 1                        ; UNKNOWN
04234C  03 F0                 ADD    si, ax                       ; UNKNOWN
04234E  C1 E6 02              SHL    si, 2                        ; UNKNOWN
042351  C4 1E 70 09           LES    bx, ptr [0x970]              ; UNKNOWN
042355  26 8B 40 3E           MOV    ax, word ptr es:[bx + si + 0x3e] ; UNKNOWN
042359  40                    INC    ax                           ; UNKNOWN
04235A  3B 46 DE              CMP    ax, word ptr [bp - 0x22]     ; UNKNOWN
04235D  7E 03                 JLE    0x42362                      ; UNKNOWN
04235F  8B 46 DE              MOV    ax, word ptr [bp - 0x22]     ; UNKNOWN
042362  89 46 E2              MOV    word ptr [bp - 0x1e], ax     ; UNKNOWN
042365  E9 1B FE              JMP    0x42183                      ; UNKNOWN
042368  5E                    POP    si                           ; UNKNOWN
042369  C9                    LEAVE                               ; UNKNOWN
04236A  CA 02 00              RETF   2                            ; UNKNOWN
